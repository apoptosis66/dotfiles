#!/bin/bash

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

pacman -Q git &>/dev/null || sudo pacman -Sy --noconfirm --needed git

echo -e "\nCloning Hyperdesk..."
rm -rf ~/workspace/hyperdesk/
git clone https://github.com/apoptosis66/hyperdesk.git ~/workspace/hyperdesk >/dev/null

echo -e "\nInstallation starting..."
source ~/workspace/hyperdesk/install.sh
