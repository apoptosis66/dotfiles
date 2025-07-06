#!/bin/bash

# Cups
sudo pacman -S --noconfirm cups cups-pdf cups-filters system-config-printer
sudo systemctl enable --now cups.service

# Driver
yay -S --noconfirm --needed brother-mfc-l2700dw 