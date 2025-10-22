#!/bin/bash

# Set some variables
wall_dir="${HOME}/.config/wallpaper/"
cacheDir="${HOME}/.cache/jp/"
rofi_command="rofi -dmenu -p Wallpaper -theme ${HOME}/.config/rofi/wallmenu.rasi"

# Create cache dir if not exists
if [ ! -d "${cacheDir}" ] ; then
	mkdir -p "${cacheDir}"
fi

# Convert images in directory and save to cache dir
for imagen in "$wall_dir"/*.{jpg,jpeg,png,webp}; do
	if [ -f "$imagen" ]; then
		nombre_archivo=$(basename "$imagen")
			if [ ! -f "${cacheDir}/${nombre_archivo}" ] ; then
				magick "$imagen" -strip -thumbnail 600x250^ -gravity center -extent 600x250 "${cacheDir}/${nombre_archivo}"
			fi
    fi
done

# Select a picture with rofi
wall_selection=$(find "${wall_dir}"  -maxdepth 1  -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -exec basename {} \; | sort | while read -r A ; do  echo -en "$A\x00icon\x1f""${cacheDir}"/"$A\n" ; done | $rofi_command)

# Set the wallpaper
[[ -n "$wall_selection" ]] || exit 1

# Run Wallust
wallust -q run "${wall_dir}/${wall_selection}"

# Restart for new theme
pkill waybar
makoctl reload
hyprctl reload
hyprctl hyprpaper reload , "${wall_dir}/${wall_selection}"
hyprctl dispatch exec waybar

# Notify of the new theme
notify-send "Wallpaper changed to ${wall_selection}" -t 5000

exit 0

