#!/bin/bash

yay -S --noconfirm --needed \
  hyprland \
  hyprshot \
  hyprpicker \
  hyprlock \
  hypridle \
  hyprpaper \
  hyprland-qtutils \
  wofi \
  waybar \
  mako \
  xdg-desktop-portal-hyprland \
  xdg-desktop-portal-gtk

# Start Hyprland on first session
# Change back to tty1 if hyprland is main desktop
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty2 ]] && exec Hyprland" >~/.bash_profile