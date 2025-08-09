#!/bin/bash

# https://forum.endeavouros.com/t/a-complete-idiots-guide-to-endeavour-os-maintenance-update-upgrade/25184/180

# Check systemd failed services
systemctl --failed

# Log files check
sudo journalctl -p 3 -xb

# Update Arch Mirrors
reflector --verbose -c US --protocol https --sort rate --latest 25 --save /etc/pacman.d/mirrorlist

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

