#!/bin/bash


# Default path
config_path="$HOME/.config"
themes_path="$config_path/waybar/themes"
cache_path="$HOME/.cache"
cache_file="$cache_path/waybar/themecache"

# Read theme folder
sleep 0.2
declare -A themes
dirs=$(find $themes_path -maxdepth 2 -type d)
for dir in $dirs
do
    if [ ! "$dir" == "$themes_path/assets" ] && [ ! "$dir" == "$themes_path" ]; then
        if [ -f $dir/theme_name ]; then
            theme_name=$(<"$dir/theme_name")
            themes["$theme_name"]=$dir
        fi
    fi
done

# Show wofi dialog
listNames=()
for name in "${!themes[@]}"; do
    listNames+=("$name")
    echo $name
done
echo "${listNames[@]}"
OLD_IFS=$IFS
IFS=$'\n'
choice=$(echo -e "${listNames[*]}" | wofi -d)
echo $choice
IFS=$OLD_IFS

# Set new theme by writing the theme information to cache file
if [ "$choice" ]; then
    echo "Loading waybar theme..."
    echo ${themes[$choice]} > $cache_file
    launch_waybar.sh
    notify-send "Waybar Theme changed to $choice"
fi