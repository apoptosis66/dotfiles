#!/bin/bash

# Use dark mode for QT apps too (like VLC and kdenlive)
yay  -S --noconfirm --needed kvantum-qt5

# Prefer dark mode everything
yay  -S --noconfirm --needed gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Set initial theme
ln -snf ~/.config/themes/catppuccin/ ~/.config/theme

# Set specific app links for current theme
ln -snf ~/.config/theme/wofi.css ~/.config/wofi/style.css
ln -snf ~/.config/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/theme/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/theme/mako.ini ~/.config/mako/config
