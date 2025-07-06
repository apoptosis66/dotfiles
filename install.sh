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
source install/yay.sh
source install/terminal.sh
source install/config.sh
source install/bluetooth.sh
source install/printer.sh
source install/scanner.sh
source install/desktop.sh
source install/fonts.sh
source install/hyprlandia.sh
source install/mimetypes.sh
source install/nvidia.sh
source install/get.sh
source install/nvim.sh
source install/power.sh
source install/theme.sh
source install/xtras.sh

# Ensure locate is up to date now that everything has been installed
sudo updatedb

# Reboot
gum confirm "Reboot to apply all settings?" && reboot
