-- Window Rules: https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Suppress Maximize Events
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Just a dash of opacity by default
hl.window_rule({ match = { class = ".*" }, opacity = "1.0 0.97" })

-- Fix some dragging issues with XWayland.
hl.window_rule({
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- Float Steam.
hl.window_rule({ match = { class = "steam" }, float = true })
hl.window_rule({ match = { class = "steam", title = "Steam" }, center = true })
hl.window_rule({ match = { class = "steam.*" }, opacity = "1 1" })
hl.window_rule({ match = { class = "steam", title = "Steam" }, size = { 1100, 700 } })
hl.window_rule({ match = { class = "steam", title = "Friends List" }, size = { 460, 800 } })
hl.window_rule({ match = { class = "steam" }, idle_inhibit = "fullscreen" })