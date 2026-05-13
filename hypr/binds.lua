-- Binds: https://wiki.hypr.land/Configuring/Basics/Binds/

-- Config
local terminal = "ghostty"
local browser = "firefox --new-window"
local development = "code"
local file_manager = "nemo"
local messenger = "signal-desktop --password-store=gnome-libsecret --enable-features=UseOzonePlatform --ozone-platform=wayland"
local password_manager = "keepassxc"
local workspaces = 5
local scripts = "~/bin/"

-- Start apps
hl.bind("SUPER + return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + I", hl.dsp.exec_cmd(browser .. " -private-window"))
hl.bind("SUPER + D", hl.dsp.exec_cmd(development))
hl.bind("SUPER + F", hl.dsp.exec_cmd(file_manager))
hl.bind("SUPER + M", hl.dsp.exec_cmd(messenger))
hl.bind("SUPER + K", hl.dsp.exec_cmd(password_manager))
hl.bind("SUPER + N", hl.dsp.exec_cmd(terminal .. " -e nvim"))
hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal .. " -e btop"))

-- Urls
hl.bind("SUPER + A", hl.dsp.exec_cmd(browser .. " https://gemini.google.com/"))
hl.bind("SUPER + C", hl.dsp.exec_cmd(browser .. " https://calendar.google.com/"))
hl.bind("SUPER + G", hl.dsp.exec_cmd(browser .. ' --new-tab --url "https://mail.google.com/" --new-tab --url "https://messages.google.com/"'))
hl.bind("SUPER + Y", hl.dsp.exec_cmd(browser .. " https://youtube.com/"))

-- Hyprland
-- hl.bind("SUPER + SPACE", hl.dsp.exec_cmd('flock --nonblock /tmp/.rofi.lock -c "rofi -show drun -sort"'))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("uv run " .. scripts .. "control-panel.py"))
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd("pkill waybar && hyprctl eval 'hl.exec_cmd(\"waybar\")'"))
hl.bind("SUPER + CTRL + SPACE", hl.dsp.exec_cmd(scripts .. "theme-menu.sh"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.kill())

-- End active session
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + SHIFT + ESCAPE", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind("SUPER + ALT + ESCAPE", hl.dsp.exit())
hl.bind("SUPER + CTRL + ESCAPE", hl.dsp.exec_cmd("reboot"))
hl.bind("SUPER + SHIFT + CTRL + ESCAPE", hl.dsp.exec_cmd("systemctl poweroff"))

-- Control tiling
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))

-- Switch workspaces: SUPER + [1-workspaces]
-- Move active window to workspace: SUPER + SHIFT [1-workspaces]
for i = 1, workspaces do
    hl.bind("SUPER + " .. i,         hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i}))
end

-- Move focus: SUPER + arrow keys
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

-- Swap windows: SUPER + SHIFT + arrow keys
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

-- Resize active window
hl.bind("SUPER + minus", hl.dsp.window.resize({x = -100, y = 0, relative = true}))
hl.bind("SUPER + equal", hl.dsp.window.resize({x = 100, y = 0, relative = true}))
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({x = 0, y = -100, relative = true}))
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({x = 0, y = 100, relative = true}))

-- Scroll through existing workspaces with SUPER + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
hl.bind("code:191", hl.dsp.exec_cmd(scripts .. "hyprshot.sh -m region"))
hl.bind("SHIFT + code:191", hl.dsp.exec_cmd(scripts .. "hyprshot.sh -m window"))
hl.bind("CTRL + code:191", hl.dsp.exec_cmd(scripts .. "hyprshot.sh -m output"))

-- Color picker
hl.bind("SUPER + code:191", hl.dsp.exec_cmd("hyprpicker -a"))

-- Misc laptop / function key binds
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause",hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })