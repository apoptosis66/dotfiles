#!/bin/bash

yay -Sy --noconfirm --needed ttf-font-awesome noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra

mkdir -p ~/.local/share/fonts

if ! fc-list | grep -qi "JetBrainsMonoNL Nerd Font"; then
  cd /tmp
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d JetBrainsFont
  cp JetBrainsFont/JetBrainsMonoNLNerdFont-Regular.ttf ~/.local/share/fonts
  cp JetBrainsFont/JetBrainsMonoNLNerdFont-Bold.ttf ~/.local/share/fonts
  cp JetBrainsFont/JetBrainsMonoNLNerdFont-Italic.ttf ~/.local/share/fonts
  cp JetBrainsFont/JetBrainsMonoNLNerdFont-BoldItalic.ttf ~/.local/share/fonts
  rm -rf JetBrainsMono.zip JetBrainsFont
  fc-cache
  cd -
fi

if ! fc-list | grep -qi "CaskaydiaMono Nerd Font"; then
  cd /tmp
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
  unzip CascadiaMono.zip -d CascadiaFont
  cp CascadiaFont/CaskaydiaMonoNerdFont-Regular.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-Bold.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-Italic.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-BoldItalic.ttf ~/.local/share/fonts
  rm -rf CascadiaMono.zip CascadiaFont
  fc-cache
  cd -
fi

