#!/bin/bash

# Use dark mode for QT apps too (like VLC and kdenlive)
yay  -S --noconfirm --needed kvantum-qt5

# Prefer dark mode everything
yay  -S --noconfirm --needed gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"