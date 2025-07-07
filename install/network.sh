#!/bin/bash

yay -S --noconfirm --needed \
    networkmanager \
    nm-connection-editor \
    network-manager-applet

sudo systemctl enable --now NetworkManager.service