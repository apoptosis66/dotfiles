#!/bin/bash

# Copy over bin files
cp ../bin/* ~/bin/

# Copy over configs
cp -r ../btop ~/.config/
cp -r ../fastfetch ~/.config/
cp -r ../ghostty ~/.config/
cp -r ../hypr ~/.config/
cp -r ../nvim ~/.config/
cp -r ../waybar ~/.config/
cp -r ../wofi ~/.config/
cp -r ../themes ~/.config/


# Backup default bashrc
if [ -f ~/.bashrc ]; then
  cp ~/.bashrc ~/bashrc.bak
fi
cp ../bash/bashrc ~/.bashrc
source ~/.bashrc
