#!/bin/bash

yay -Sy --noconfirm --needed ttf-font-awesome

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
