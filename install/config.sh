#!/bin/bash

# Copy over bin files
cp bin/* ~/bin/

# Copy over configs
cp -r config/* ~/.config/

# Copy default bashrc
if [ -f ~/.bashrc ]; then
  cp ~/.bashrc ~/bashrc.bak
fi
cp default/bashrc ~/.bashrc
source ~/.bashrc
