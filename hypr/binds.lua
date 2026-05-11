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
h1.bind("SUPER + return", h1.dsp.exec_cmd(terminal))
h1.bind("SUPER + B", h1.dsp.exec_cmd(browser))
h1.bind("SUPER + I", h1.dsp.exec_cmd(browser .. " -private-window"))
h1.bind("SUPER + D", h1.dsp.exec_cmd(development))
h1.bind("SUPER + F", h1.dsp.exec_cmd(file_manager))
h1.bind("SUPER + M", h1.dsp.exec_cmd(messenger))
h1.bind("SUPER + K", h1.dsp.exec_cmd(password_manager))
h1.bind("SUPER + N", h1.dsp.exec_cmd(terminal .. " -e nvim"))
h1.bind("SUPER + T", h1.dsp.exec_cmd(terminal .. " -e btop"))

-- Urls
h1.bind("SUPER + A", h1.dsp.exec_cmd(browser .. " https://gemini.google.com/"))
h1.bind("SUPER + C", h1.dsp.exec_cmd(browser .. " https://calendar.google.com/"))
h1.bind("SUPER + G", h1.dsp.exec_cmd(browser .. ' --new-tab --url "https://mail.google.com/" --new-tab --url "https://messages.google.com/"'))
h1.bind("SUPER + Y", h1.dsp.exec_cmd(browser .. " https://youtube.com/"))

-- Hyprland
h1.bind("SUPER + SPACE", h1.dsp.exec_cmd('flock --nonblock /tmp/.rofi.lock -c "rofi -show drun -sort"'))
h1.bind("SUPER + SHIFT + SPACE", h1.dsp.exec_cmd("pkill waybar && hyprctl dispatch exec waybar"))
h1.bind("SUPER + CTRL + SPACE", h1.dsp.exec_cmd(scripts .. "theme-menu.sh"))
h1.bind("SUPER + Q", h1.dsp.window.close())
h1.bind("SUPER + SHIFT + Q", h1.dsp.window.kill())

-- End active session
h1.bind("SUPER + ESCAPE", h1.dsp.exec_cmd("hyprlock"))
h1.bind("SUPER + SHIFT + ESCAPE", h1.dsp.exec_cmd("systemctl suspend"))
h1.bind("SUPER + ALT + ESCAPE", h1.dsp.exit())
h1.bind("SUPER + CTRL + ESCAPE", h1.dsp.exec_cmd("reboot"))
h1.bind("SUPER + SHIFT + CTRL + ESCAPE", h1.dsp.exec_cmd("systemctl poweroff"))

-- Control tiling
h1.bind("SUPER + J", h1.dsp.layout("togglesplit"))

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
h1.bind("code:191", h1.dsp.exec_cmd(scripts .. "hyprshot.sh -m region"))
h1.bind("SHIFT + code:191", h1.dsp.exec_cmd(scripts .. "hyprshot.sh -m window"))
h1.bind("CTRL + code:191", h1.dsp.exec_cmd(scripts .. "hyprshot.sh -m output"))

-- Color picker
h1.bind("SUPER + code:191", h1.dsp.exec_cmd("hyprpicker -a"))

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