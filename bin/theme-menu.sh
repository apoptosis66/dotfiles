#!/bin/bash

# Theme menu
# Provides an interactive dmenu to switch between available themes
THEMES_SCRIPT="$HOME/.config/themes/theme.py"

# Show theme selection menu and apply changes
show_theme_menu() {
  # Display theme selection menu
  local selected_theme=$(uv run $THEMES_SCRIPT list | rofi -dmenu -p "Theme")

  # Exit if the selected theme is empty or the current theme
  if [[ -z "$selected_theme" || "$selected_theme" == $'\uf0a9'* ]]; then
    exit 0
  fi

  # Apply the new theme
  local wallpaper=$(uv run $THEMES_SCRIPT theme $selected_theme -w)

  # Touch ghostty config to pickup the changed theme
  # Note: No Programmic way to reload Ghostty config you must restart to see theme
  touch "$HOME/.config/ghostty/config"

  # Restart for new theme
  pkill waybar
  makoctl reload
  hyprctl reload
  hyprctl hyprpaper wallpaper , $wallpaper, cover
  hyprctl dispatch exec waybar

  # Notify of the new theme
  notify-send "Theme changed to $selected_theme" -t 5000
}

# Main execution
show_theme_menu
