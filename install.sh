# Install everything
for f in ~/workspace/hyperdesk/install/*.sh; do source "$f"; done

# Ensure locate is up to date now that everything has been installed
sudo updatedb

gum confirm "Reboot to apply all settings?" && reboot
