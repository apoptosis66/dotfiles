#!/bin/bash

# https://forum.endeavouros.com/t/a-complete-idiots-guide-to-endeavour-os-maintenance-update-upgrade/25184/180

# Update Arch Mirrors
reflector --verbose -c US --protocol https --sort rate --latest 25 --save /etc/pacman.d/mirrorlist

# Update System
yay -Syyu

# Clean Journal
journalctl --vacuum-time=4weeks

# Clean Cache (Uninstalled Packages)
#paccache -ruk0
#paccache -rk1
yay -Sc

# Remove Orphans
yay -Yc
pacman -Rns $(pacman -Qdtq)
