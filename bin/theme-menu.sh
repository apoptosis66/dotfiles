#!/bin/bash

# Theme menu
# Provides an interactive dmenu to switch between available themes

THEMES_DIR="$HOME/.config/themes/"
CURRENT_THEME_DIR="$HOME/.config/theme"

# Show theme selection menu and apply changes
show_theme_menu() {
  # Get current theme name
  if [[ -e "$CURRENT_THEME_DIR" ]]; then
    CURRENT_THEME_NAME=$(basename "$(realpath "$CURRENT_THEME_DIR")")
  else
    CURRENT_THEME_NAME="unknown"
  fi
  
  # Build menu options from available themes
  local themes=($(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort))
  
  # Remove the current theme from the list before building the menu
  local filtered_themes=()
  for theme in "${themes[@]}"; do
    if [[ "$theme" != "$CURRENT_THEME_NAME" ]]; then
      filtered_themes+=("$theme")
    fi
  done

  # Add current theme to the top of menu
  local wofi_input=$'\uf0a9 '"${CURRENT_THEME_NAME}"
  for theme in "${filtered_themes[@]}"; do
    wofi_input+="\n${theme}"
  done
  
  # Display theme selection menu
  local selection=$(echo -e "$wofi_input" | wofi --show dmenu --width 300 --height 225)
  
  # Extract theme name from selection (remove glyph and leading spaces)
  local selected_theme=$(echo "$selection" | sed 's/^\s*\uf0a9 \?//')

  # Exit if the selected theme is the current theme or empty
  if [[ -z "$selected_theme" || "$selected_theme" == "$CURRENT_THEME_NAME" ]]; then
    exit 0
  fi

  # Apply the new theme
  THEME_PATH="$THEMES_DIR/$selected_theme"

  # Check if the theme entered exists
  if [[ ! -d "$THEME_PATH" ]]; then
    echo "Theme '$selected_theme' does not exist in $THEMES_DIR" >&2
    exit 2
  fi

  # Set current theme
  ln -nsf "$THEME_PATH" "$HOME/.config/theme"

  # Touch ghostty config to pickup the changed theme
  # Note: No Programmic way to reload Ghostty config you must restart to see theme
  touch "$HOME/.config/ghostty/config"

  # Restart for new theme
  pkill waybar
  makoctl reload
  hyprctl reload
  hyprctl hyprpaper reload , "$HOME/.config/theme/wallpaper.jpg"
  hyprctl dispatch exec waybar

  # Notify of the new theme
  notify-send "Theme changed to $selected_theme" -t 5000
}

# Main execution
show_theme_menu
