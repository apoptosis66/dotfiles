#!/bin/bash

if ! command -v nvim &>/dev/null; then
  yay -S --noconfirm --needed nvim luarocks tree-sitter-cli

  # Install LazyVim
  rm -rf ~/.config/nvim
  cp -R ~/workspace/hyperdesk/config/nvim/* ~/.config/nvim/
  rm -rf ~/.config/nvim/.git
fi
