#!/bin/bash

yay -S --noconfirm --needed \
  signal-desktop \
  libreoffice \
  qbittorrent \
  keepassxc \
  veracrypt \
  steam \
  gimp \
  easytag

# Copy over Hyperdesk applications
source ~/workspace/hyperdesk/bin/sync-applications
