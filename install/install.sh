#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

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

# Install yay for futher packages
pacman -S --needed --noconfirm base-devel
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
  cd ~
  rm -rf yay-bin
fi

# Install all packages
mapfile -t packages < <(grep -v '^#' "packages.txt" | grep -v '^$')
yay -S --noconfirm --needed "${packages[@]}"

# Copy over bin files
cp ../bin/* ~/bin/

# Copy over configs
cp -r ../btop ~/.config/
cp -r ../fastfetch ~/.config/
cp -r ../ghostty ~/.config/
cp -r ../hypr ~/.config/
cp -r ../nvim ~/.config/
cp -r ../waybar ~/.config/
cp -r ../rofi ~/.config/
cp -r ../themes ~/.config/
cp -r ../wallpaper ~/.config/

# Backup default bashrc
if [ -f ~/.bashrc ]; then
  cp ~/.bashrc ~/bashrc.bak
fi
cp ../bash/bashrc ~/.bashrc
source ~/.bashrc

# Nvidia Setup
source nvidia.sh

# Firewall Setup
# Allow nothing but SSH in, everything out
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw --force enable

# Enable/Start Services
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now cups.service
sudo systemctl enable --now ufw.service

# Set Power Profile
if ls /sys/class/power_supply/BAT* &>/dev/null; then
  # This computer runs on a battery
  powerprofilesctl set balanced
else
  # This computer runs on power outlet
  powerprofilesctl set performance
fi

# Start Hyprland on tty2
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty2 ]] && exec Hyprland" >~/.bash_profile

# GTK Themes
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Configure Git
echo -e "\nEnter identification for git..."
export GIT_USER_NAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export GIT_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

if [[ -n "${GIT_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$GIT_USER_NAME"
fi

if [[ -n "${GIT_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$GIT_USER_EMAIL"
fi

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
git config --global init.defaultBranch master

# Ensure locate is up to date now that everything has been installed
sudo updatedb

# Reboot
gum confirm "Reboot to apply all settings?" && reboot
