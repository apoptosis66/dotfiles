-- Config: https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = "rgb(787c99)",
            inactive_border = "rgba(0a0a0ddb)",
        },
    },
    decoration = {
        blur = {
            size = 3,
        },  
        shadow = {
            range = 2,
            color = "rgba(1a1a1aee)",
        }
    },
    animations = {
        enabled = false,
    },
    input = {
        numlock_by_default = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        vrr = 2,
        enable_anr_dialog = false,
    },
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    dwindle = {
        force_split = 2, -- Always split right
        preserve_split = true,
        split_width_multiplier = 2.0, -- Ultrawide Monitor
    },
    master = {
        new_status = "master",
    },
})