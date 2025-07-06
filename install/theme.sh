#!/bin/bash

# Use dark mode for QT apps too (like VLC and kdenlive)
sudo pacman -S --noconfirm kvantum-qt5

# Prefer dark mode everything
sudo pacman -S --noconfirm gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Setup theme links
mkdir -p ~/.config/hyperdesk/themes
for f in ~/workspace/hyperdesk/themes/*; do ln -s "$f" ~/.config/hyperdesk/themes/; done

# Set initial theme
mkdir -p ~/.config/hyperdesk/current
ln -snf ~/.config/hyperdesk/themes/catppuccin ~/.config/hyperdesk/current/theme
ln -snf ~/.config/hyperdesk/current/theme/backgrounds/1-catppuccin.png ~/.config/hyperdesk/current/background

# Set specific app links for current theme
ln -snf ~/.config/hyperdesk/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf
ln -snf ~/.config/hyperdesk/current/theme/wofi.css ~/.config/wofi/style.css
ln -snf ~/.config/hyperdesk/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/hyperdesk/current/theme/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/hyperdesk/current/theme/mako.ini ~/.config/mako/config
