#!/bin/bash

# Check systemd failed services
systemctl --failed

# Log files check
sudo journalctl -p 3 -xb

# Update Arch Mirrors
sudo reflector --verbose -c US --protocol https --sort rate --latest 25 --save /etc/pacman.d/mirrorlist

# Update System
yay -Syyu

 #Delete Pacman Cache
sudo pacman -Scc

# Delete Yay Cache
yay -Scc

# Delete unwanted dependencies
yay -Yc

# Remove Orphans
sudo pacman -Rns $(pacman -Qdtq)

# Clean the Cache
rm -rf .cache/*

# Clean the Journal
sudo journalctl --vacuum-time=2weeks

