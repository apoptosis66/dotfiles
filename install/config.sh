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

# Login directly as user, rely on disk encryption + hyprlock for security
# Commenting out for now because I haven't gone full disk encryption
#sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
#sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null <<EOF
#[Service]
#ExecStart=
#ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
#EOF
