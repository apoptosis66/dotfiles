-- Enviromental Variables: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Cursor Size
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Misc Toolkit
hl.env("SDL_VIDEODRIVER","wayland")
hl.env("MOZ_ENABLE_WAYLAND","1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT","wayland")
hl.env("OZONE_PLATFORM","wayland")
hl.env("CLUTTER_BACKEND","wayland")
hl.env("CHROMIUM_FLAGS","--enable-features=OzonePlatform  --ozone-platform=wayland --gtk-version=4")

-- NVIDIA
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("NVD_BACKEND", "direct")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GL_GSYNC_ALLOWED", "1")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_DATA_DIRS", "/usr/share:/usr/local/share:~/.local/share")

-- GTK
hl.env("GDK_BACKEND", "wayland")
hl.env("GDK_SCALE", "2")
hl.env("GTK_THEME", "Adwaita:dark")

-- QT
hl.env("QT_QPA_PLATFORM","wayland")
hl.env("QT_STYLE_OVERRIDE","kvantum")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATIONS","1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")