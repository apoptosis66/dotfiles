#!/bin/bash

# Copy and sync icon files
mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
cp ~/workspace/hyperdesk/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null

# Copy .desktop declarations
mkdir -p ~/.local/share/applications
cp ~/workspace/hyperdesk/applications/*.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
