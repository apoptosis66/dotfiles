#!/bin/bash

# Fun Intro
ascii_art='
   /$$   /$$                                         /$$$$$$$                      /$$      
  | $$  | $$                                        | $$__  $$                    | $$      
  | $$  | $$ /$$   /$$  /$$$$$$   /$$$$$$   /$$$$$$ | $$  \ $$  /$$$$$$   /$$$$$$$| $$   /$$
  | $$$$$$$$| $$  | $$ /$$__  $$ /$$__  $$ /$$__  $$| $$  | $$ /$$__  $$ /$$_____/| $$  /$$/
  | $$__  $$| $$  | $$| $$  \ $$| $$$$$$$$| $$  \__/| $$  | $$| $$$$$$$$|  $$$$$$ | $$$$$$/ 
  | $$  | $$| $$  | $$| $$  | $$| $$_____/| $$      | $$  | $$| $$_____/ \____  $$| $$_  $$ 
  | $$  | $$|  $$$$$$$| $$$$$$$/|  $$$$$$$| $$      | $$$$$$$/|  $$$$$$$ /$$$$$$$/| $$ \  $$
  |__/  |__/ \____  $$| $$____/  \_______/|__/      |_______/  \_______/|_______/ |__/  \__/
             /$$  | $$| $$                                                                  
            |  $$$$$$/| $$                                                                  
             \______/ |__/                                                                  
'

echo -e "\n$ascii_art\n"
echo -e "\nInstallation starting..."

# Install everything. Seperate files for easy comment out. Order matters.
source yay.sh
source terminal.sh
source config.sh
source nvidia.sh
source network.sh
source power.sh
source bluetooth.sh
source printer.sh
source scanner.sh
source desktop.sh
# source mimetypes.sh
source fonts.sh
source hyprlandia.sh
source git.sh
source development.sh
source xtras.sh
source theme.sh

# Ensure locate is up to date now that everything has been installed
sudo updatedb

# Reboot
gum confirm "Reboot to apply all settings?" && reboot
