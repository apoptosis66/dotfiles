-- Enviromental Variables: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Cursor Size
h1.env("XCURSOR_SIZE", "24")
h1.env("HYPRCURSOR_SIZE", "24")

-- Misc Toolkit
h1.env("SDL_VIDEODRIVER","wayland")
h1.env("MOZ_ENABLE_WAYLAND","1")
h1.env("ELECTRON_OZONE_PLATFORM_HINT","wayland")
h1.env("OZONE_PLATFORM","wayland")
h1.env("CLUTTER_BACKEND","wayland")
h1.env("CHROMIUM_FLAGS","--enable-features=OzonePlatform  --ozone-platform=wayland --gtk-version=4")

-- NVIDIA
h1.env("GBM_BACKEND", "nvidia-drm")
h1.env("NVD_BACKEND", "direct")
h1.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
h1.env("LIBVA_DRIVER_NAME", "nvidia")
h1.env("__GL_GSYNC_ALLOWED", "1")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_DATA_DIRS", "/usr/share:/usr/local/share:~/.local/share")

-- GTK
h1.env("GDK_BACKEND", "wayland")
h1.env("GDK_SCALE", "2")
h1.env("GTK_THEME", "Adwaita:dark")

-- QT
h1.env("QT_QPA_PLATFORM","wayland")
h1.env("QT_STYLE_OVERRIDE","kvantum")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
h1.env("QT_WAYLAND_DISABLE_WINDOWDECORATIONS","1")
h1.env("QT_QPA_PLATFORMTHEME", "qt5ct")