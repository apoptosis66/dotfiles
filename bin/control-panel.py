# /// script
# dependencies = [
#   "PyGObject",
#   "psutil"
# ]
# ///

import datetime
import json
import os
import re
import subprocess
import sys

import gi
import psutil

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
gi.require_version("Gio", "2.0")
from gi.repository import Gdk, Gio, GLib, Gtk, GtkLayerShell


class ControlPanel(Gtk.Window):
    def __init__(self, initial_mode="apps"):
        super().__init__()
        # Configure as an overlay layer shell window
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)

        # By not setting any anchors, the window will be centered automatically

        # Enable keyboard interactivity so we can catch the Escape key and type in search
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.EXCLUSIVE)

        self.set_size_request(600, 500)

        self.set_name("control-panel")
        self.load_css()

        # UI Layout
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        box.set_margin_start(20)
        box.set_margin_end(20)
        box.set_margin_top(20)
        box.set_margin_bottom(20)
        self.add(box)

        header_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)

        title_lbl = Gtk.Label()
        title_lbl.set_markup("<span size='x-large' weight='bold'>Control Panel</span>")
        title_lbl.set_halign(Gtk.Align.START)
        header_box.pack_start(title_lbl, True, True, 0)
        box.pack_start(header_box, False, False, 10)

        # Mode Switcher (Tabs)
        self.mode_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
        self.mode_box.set_halign(Gtk.Align.START)
        self.mode_box.get_style_context().add_class("linked")
        box.pack_start(self.mode_box, False, False, 0)

        self.btn_apps = Gtk.RadioButton.new_with_label_from_widget(None, "Apps")
        self.btn_apps.set_mode(False)
        self.btn_apps.connect("toggled", self.on_mode_toggled, "apps")
        self.mode_box.pack_start(self.btn_apps, False, False, 0)

        self.btn_themes = Gtk.RadioButton.new_with_label_from_widget(
            self.btn_apps, "Themes"
        )
        self.btn_themes.set_mode(False)
        self.btn_themes.connect("toggled", self.on_mode_toggled, "themes")
        self.mode_box.pack_start(self.btn_themes, False, False, 0)

        self.btn_network = Gtk.RadioButton.new_with_label_from_widget(
            self.btn_apps, "Network"
        )
        self.btn_network.set_mode(False)
        self.btn_network.connect("toggled", self.on_mode_toggled, "network")
        self.mode_box.pack_start(self.btn_network, False, False, 0)

        self.btn_system = Gtk.RadioButton.new_with_label_from_widget(
            self.btn_apps, "System"
        )
        self.btn_system.set_mode(False)
        self.btn_system.connect("toggled", self.on_mode_toggled, "system")
        self.mode_box.pack_start(self.btn_system, False, False, 0)

        self.current_mode = "apps"

        # Content Stack
        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE)
        box.pack_start(self.stack, True, True, 10)

        # Apps Container
        self.apps_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)

        # App Launcher / Search
        self.search = Gtk.SearchEntry()
        self.search.set_placeholder_text("Search apps or commands...")
        self.search.connect("search-changed", self.on_search_changed)
        self.search.connect("activate", self.on_search_activate)
        self.search.connect("key-press-event", self.on_search_key_press)
        self.apps_box.pack_start(self.search, False, False, 0)

        # App List ScrolledWindow
        self.scrolled_window = Gtk.ScrolledWindow()
        self.scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        self.scrolled_window.set_min_content_height(300)

        self.listbox = Gtk.ListBox()
        self.listbox.connect("row-activated", self.on_row_activated)
        self.listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.scrolled_window.add(self.listbox)

        self.apps_box.pack_start(self.scrolled_window, True, True, 0)
        self.stack.add_named(self.apps_box, "apps")

        # System Tab Contents
        self.system_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)

        # Temp
        temp_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=5)
        self.temp_lbl = Gtk.Label(label="TEMP:")
        self.temp_lbl.set_halign(Gtk.Align.START)
        temp_box.pack_start(self.temp_lbl, False, False, 0)
        self.temp_prog = Gtk.Label(label="N/A")
        temp_box.pack_start(self.temp_prog, False, False, 0)
        self.system_box.pack_start(temp_box, False, False, 0)

        # CPU
        cpu_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
        self.cpu_lbl = Gtk.Label(label="CPU")
        self.cpu_lbl.set_halign(Gtk.Align.START)
        cpu_box.pack_start(self.cpu_lbl, False, False, 0)
        self.cpu_prog = Gtk.ProgressBar()
        cpu_box.pack_start(self.cpu_prog, False, False, 0)
        self.system_box.pack_start(cpu_box, False, False, 0)

        # RAM
        ram_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
        self.ram_lbl = Gtk.Label(label="RAM")
        self.ram_lbl.set_halign(Gtk.Align.START)
        ram_box.pack_start(self.ram_lbl, False, False, 0)
        self.ram_prog = Gtk.ProgressBar()
        ram_box.pack_start(self.ram_prog, False, False, 0)
        self.system_box.pack_start(ram_box, False, False, 0)

        # Volume
        vol_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        vol_lbl = Gtk.Label(label="VOLUME")
        vol_lbl.set_halign(Gtk.Align.START)
        vol_box.pack_start(vol_lbl, False, False, 0)
        self.vol_scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
        self.vol_scale.set_value(self.get_current_volume())
        self.vol_scale.connect("value-changed", self.on_volume_changed)
        vol_box.pack_start(self.vol_scale, False, False, 0)
        self.system_box.pack_start(vol_box, False, False, 0)

        self.stack.add_named(self.system_box, "system")

        if initial_mode == "themes":
            self.btn_themes.set_active(True)
        elif initial_mode == "network":
            self.btn_network.set_active(True)
        elif initial_mode == "system":
            # Explicitly set the stack to the system view during initialization
            self.stack.set_visible_child_name("system")
            self.btn_system.set_active(True)
        else:
            self.refresh_list()
            self.search.grab_focus()

        # Workspace Switcher
        ws_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        ws_box.set_halign(Gtk.Align.CENTER)
        box.pack_start(ws_box, False, False, 10)

        self.ws_btns = {}
        for i in range(1, 6):
            btn = Gtk.Button(label=str(i))
            btn.set_size_request(36, 36)
            btn.connect(
                "clicked",
                lambda widget, w=i: self.run_cmd(
                    f"hyprctl dispatch 'hl.dsp.focus({{ workspace = \"{w}\" }})'"
                ),
            )
            ws_box.pack_start(btn, False, False, 0)
            self.ws_btns[i] = btn

        # Bottom Power Action Row
        power_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        power_box.set_halign(Gtk.Align.CENTER)
        box.pack_start(power_box, False, False, 10)

        p_clrs = {
            "": "#8be9fd",
            "󰤄": "#bd93f9",
            "󰐥": "#ff5555",
            "󰑐": "#f1fa8c",
        }
        p_acts = {
            "": "hyprlock",
            "󰤄": "systemctl suspend",
            "󰑐": "reboot",
            "󰐥": "shutdown now",
        }
        for icon, cmd in p_acts.items():
            btn = Gtk.Button()
            btn.set_size_request(64, 64)
            lbl = Gtk.Label()
            lbl.set_halign(Gtk.Align.CENTER)
            lbl.set_valign(Gtk.Align.CENTER)
            lbl.set_markup(
                f"<span color='{p_clrs.get(icon, '#ffffff')}' font='32'>{icon}</span>"
            )
            btn.add(lbl)
            btn.connect("clicked", lambda widget, c=cmd: self.run_cmd(c))
            power_box.pack_start(btn, False, False, 0)

        self.time_lbl = Gtk.Label()
        self.time_lbl.set_halign(Gtk.Align.CENTER)
        self.update_clock()
        box.pack_start(self.time_lbl, False, False, 0)

        GLib.timeout_add_seconds(1, self.update_clock)

        # Close on Escape key
        self.connect("key-press-event", self.on_key_press)

    def update_clock(self):
        now = datetime.datetime.now().strftime("%Y-%m-%d %-I:%M %p")
        self.time_lbl.set_markup(f"<span size='medium'>{now}</span>")

        # System updates
        cpu_pct = psutil.cpu_percent()
        self.cpu_prog.set_fraction(cpu_pct / 100.0)
        self.cpu_lbl.set_text(f"CPU: {cpu_pct}%")

        mem = psutil.virtual_memory()
        used_gb = mem.used / 1073741824
        total_gb = mem.total / 1073741824
        self.ram_prog.set_fraction(mem.percent / 100.0)
        self.ram_lbl.set_text(
            f"RAM: {used_gb:.2f}GB / {total_gb:.1f}GB ({mem.percent}%)"
        )

        try:
            temps = psutil.sensors_temperatures()
            core_temp = temps.get("coretemp", temps.get("cpu_thermal", []))[0].current
            self.temp_prog.set_markup(
                f"<span color='#52fa69' weight='bold'>{int(core_temp)}°C</span>"
            )
        except:
            self.temp_prog.set_markup("<span color='#52fa69' weight='bold'>N/A</span>")

        # Sync volume slider with system
        current_vol = self.get_current_volume()
        if int(self.vol_scale.get_value()) != current_vol:
            self.vol_scale.handler_block_by_func(self.on_volume_changed)
            self.vol_scale.set_value(current_vol)
            self.vol_scale.handler_unblock_by_func(self.on_volume_changed)

        self.update_workspaces()

        return True

    def update_workspaces(self):
        try:
            res = subprocess.check_output(["hyprctl", "activeworkspace", "-j"])
            active = json.loads(res).get("id")
            for i, btn in self.ws_btns.items():
                if i == active:
                    btn.get_style_context().add_class("suggested-action")
                else:
                    btn.get_style_context().remove_class("suggested-action")
        except:
            pass

    def get_current_volume(self):
        try:
            v = (
                subprocess.check_output(
                    "wpctl get-volume @DEFAULT_AUDIO_SINK@", shell=True
                )
                .decode()
                .strip()
            )
            vol_str = v.split(":")[1].strip().split()[0]
            return int(float(vol_str) * 100)
        except:
            return 50

    def on_volume_changed(self, scale):
        val = scale.get_value()
        subprocess.run(
            f"wpctl set-volume @DEFAULT_AUDIO_SINK@ {val / 100:.2f}",
            shell=True,
            check=False,
        )

    def on_mode_toggled(self, button, name):
        if button.get_active():
            self.current_mode = name
            if name == "system":
                self.stack.set_visible_child_name("system")
            else:
                self.stack.set_visible_child_name("apps")
                self.search.set_text("")
                self.refresh_list()
                self.search.grab_focus()

    def refresh_list(self):
        for child in self.listbox.get_children():
            self.listbox.remove(child)

        if self.current_mode == "apps":
            self.search.set_placeholder_text("Search apps or commands...")
            self.setup_app_list()
        elif self.current_mode == "themes":
            self.search.set_placeholder_text("Search themes...")
            self.setup_theme_list()
        elif self.current_mode == "network":
            self.search.set_placeholder_text("Search network connections...")
            self.setup_network_list()

        self.listbox.set_filter_func(self.filter_items)
        self.listbox.show_all()

    def setup_app_list(self):
        apps = []
        seen_names = set()
        for app_info in Gio.AppInfo.get_all():
            if app_info.should_show():
                name = app_info.get_name()
                if name and name not in seen_names:
                    apps.append(app_info)
                    seen_names.add(name)

        # Sort apps alphabetically ("-sort" logic)
        apps.sort(key=lambda a: a.get_name().lower())

        for app_info in apps:
            row = Gtk.ListBoxRow()
            hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
            hbox.set_margin_start(10)
            hbox.set_margin_end(10)
            hbox.set_margin_top(8)
            hbox.set_margin_bottom(8)

            icon = app_info.get_icon()
            image = Gtk.Image()
            if icon:
                image.set_from_gicon(icon, Gtk.IconSize.DIALOG)
            else:
                image.set_from_icon_name(
                    "application-x-executable", Gtk.IconSize.DIALOG
                )
            image.set_pixel_size(48)
            hbox.pack_start(image, False, False, 0)

            label = Gtk.Label(label=app_info.get_name())
            label.set_halign(Gtk.Align.START)
            hbox.pack_start(label, True, True, 0)

            row.add(hbox)
            row.app_info = app_info
            self.listbox.add(row)

    def setup_theme_list(self):
        try:
            output = subprocess.check_output(
                "uv run ~/bin/theme.py list", shell=True, text=True
            )
            themes = [line.strip() for line in output.splitlines() if line.strip()]

            for theme in themes:
                row = Gtk.ListBoxRow()
                hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
                hbox.set_margin_start(10)
                hbox.set_margin_end(10)
                hbox.set_margin_top(8)
                hbox.set_margin_bottom(8)

                image = Gtk.Image.new_from_icon_name(
                    "preferences-desktop-theme", Gtk.IconSize.DIALOG
                )
                image.set_pixel_size(48)
                hbox.pack_start(image, False, False, 0)

                label = Gtk.Label(label=theme)
                label.set_halign(Gtk.Align.START)
                hbox.pack_start(label, True, True, 0)

                row.add(hbox)
                row.theme_name = theme
                self.listbox.add(row)
        except Exception as e:
            print(f"Error loading themes: {e}")

    def setup_network_list(self):
        try:
            output = subprocess.check_output(
                "nmcli -t -f name,type con show 2>/dev/null | grep -v ':lo' | sort || true",
                shell=True,
                text=True,
            )
            connections = [line.strip() for line in output.splitlines() if line.strip()]

            for conn_line in connections:
                parts = conn_line.rsplit(":", 1)
                if len(parts) == 2:
                    conn, net_type = parts
                    conn = conn.replace("\\:", ":")
                else:
                    conn, net_type = conn_line, ""

                row = Gtk.ListBoxRow()
                hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
                hbox.set_margin_start(10)
                hbox.set_margin_end(10)
                hbox.set_margin_top(8)
                hbox.set_margin_bottom(8)

                icon_name = "network-wireless"
                if "ethernet" in net_type or "wired" in net_type:
                    icon_name = "network-wired"
                elif "vpn" in net_type or "wireguard" in net_type or "tun" in net_type:
                    icon_name = "network-vpn"
                elif "bluetooth" in net_type:
                    icon_name = "network-bluetooth"

                image = Gtk.Image.new_from_icon_name(icon_name, Gtk.IconSize.DIALOG)
                image.set_pixel_size(48)
                hbox.pack_start(image, False, False, 0)

                label = Gtk.Label(label=conn)
                label.set_halign(Gtk.Align.START)
                hbox.pack_start(label, True, True, 0)

                row.add(hbox)
                row.connection_name = conn
                self.listbox.add(row)
        except Exception as e:
            print(f"Error loading network connections: {e}")

    def filter_items(self, row):
        search_text = self.search.get_text().lower()
        if not search_text:
            return True

        if hasattr(row, "app_info"):
            return search_text in row.app_info.get_name().lower()
        elif hasattr(row, "theme_name"):
            return search_text in row.theme_name.lower()
        elif hasattr(row, "connection_name"):
            return search_text in row.connection_name.lower()
        return True

    def on_search_changed(self, entry):
        self.listbox.invalidate_filter()
        # Select the first visible row automatically as you type
        for row in self.listbox.get_children():
            if row.get_child_visible():
                self.listbox.select_row(row)
                break

    def on_search_activate(self, entry):
        row = self.listbox.get_selected_row()
        if row:
            self.on_row_activated(self.listbox, row)

    def on_search_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Up:
            self.move_selection(-1)
            return True
        elif event.keyval == Gdk.KEY_Down:
            self.move_selection(1)
            return True
        return False

    def move_selection(self, direction):
        selected_row = self.listbox.get_selected_row()
        visible_rows = [r for r in self.listbox.get_children() if r.get_child_visible()]

        if not visible_rows:
            return

        if selected_row in visible_rows:
            current_idx = visible_rows.index(selected_row)
            next_idx = (current_idx + direction) % len(visible_rows)
        else:
            next_idx = 0 if direction > 0 else -1

        next_row = visible_rows[next_idx]
        self.listbox.select_row(next_row)

        # Ensure the selected listbox item scrolls securely into view
        adjustment = self.scrolled_window.get_vadjustment()
        allocation = next_row.get_allocation()

        if allocation.y < adjustment.get_value():
            adjustment.set_value(allocation.y)
        elif (
            allocation.y + allocation.height
            > adjustment.get_value() + adjustment.get_page_size()
        ):
            adjustment.set_value(
                allocation.y + allocation.height - adjustment.get_page_size()
            )

    def on_row_activated(self, listbox, row):
        if hasattr(row, "app_info"):
            try:
                cmd = row.app_info.get_commandline()
                if cmd:
                    cmd = re.sub(r"%[fFuUicein]", "", cmd).strip()
                    self.run_cmd(cmd)
                else:
                    row.app_info.launch([], None)
                    Gtk.main_quit()
            except Exception as e:
                print(f"Error launching {row.app_info.get_name()}: {e}")
        elif hasattr(row, "theme_name"):
            theme = row.theme_name
            # Skip if it is the active theme indicator
            if theme.startswith("\uf0a9"):
                Gtk.main_quit()
                return

            home = os.path.expanduser("~")
            script = f"""
            wallpaper=$(uv run ~/bin/theme.py theme "{theme}" -w)
            touch "{home}/.config/ghostty/config"
            pkill waybar
            makoctl reload
            hyprctl reload
            hyprctl hyprpaper wallpaper , $wallpaper, cover
            hyprctl eval 'hl.exec_cmd("waybar")'
            notify-send "Theme changed to {theme}" -t 5000
            """
            self.run_cmd(script)
        elif hasattr(row, "connection_name"):
            conn = row.connection_name
            safe_conn = conn.replace("'", "'\\''")
            script = f"""
            if nmcli con up '{safe_conn}' >/dev/null 2>&1; then
                notify-send "Network Manager" "Successfully connected to '{safe_conn}'."
            else
                notify-send "Network Manager" "Failed to connect to '{safe_conn}'. Check permissions or connection details."
            fi
            """
            self.run_cmd(script)

    def run_cmd(self, cmd):
        subprocess.Popen(
            cmd,
            shell=True,
            start_new_session=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        Gtk.main_quit()

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()
            return True
        return False

    def load_css(self):
        panel_css = ""
        theme_css_path = os.path.expanduser("~/.config/themes/control-panel.css")
        if os.path.exists(theme_css_path):
            with open(theme_css_path, "r") as f:
                panel_css += f.read()
        else:
            print(f"Warning: theme CSS not found at {theme_css_path}", file=sys.stderr)

        css_provider = Gtk.CssProvider()
        css_provider.load_from_data(panel_css)

        screen = Gdk.Screen.get_default()
        Gtk.StyleContext.add_provider_for_screen(
            screen, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER
        )


if __name__ == "__main__":
    initial_mode = "apps"
    if len(sys.argv) > 1:
        arg = sys.argv[1].lower()
        if arg == "themes":
            initial_mode = "themes"
        elif arg == "network":
            initial_mode = "network"
        elif arg == "system":
            initial_mode = "system"

    panel = ControlPanel(initial_mode)
    panel.show_all()
    Gtk.main()
    sys.exit(0)
