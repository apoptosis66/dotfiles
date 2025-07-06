#!/bin/bash

sudo pacman -S --noconfirm cups cups-pdf cups-filters system-config-printer simple-scan
sudo systemctl enable --now cups.service
