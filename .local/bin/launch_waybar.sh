#!/bin/bash


#Defuelt path
config="$HOME/.config"
cache_path="$HOME/.cache"
cache_file="$cache_path/waybar/themecache"

# Check if waybar-disabled file exists
if [ -f $cache_path/waybar-disabled ] ;then 
    killall waybar
    pkill waybar
    exit 1 
fi

# Quit all running waybar instances
killall waybar
sleep 0.2

# Default theme
themestyle="$config/waybar/themes/default"

# Get current theme information from cache file
if [ -f $cache_file ]; then
    themestyle=$(cat $cache_file)
else
    touch $cache_file
    echo "$themestyle" > $cache_file
fi

if [ ! -f ${themestyle}/style.css ] || [ ! -f ${themestyle}/config ]; then
    themestyle="$config/waybar/themes/default"
fi


# Loading the configuration
config_file="config"
style_file="style.css"

# Standard files can be overwritten with an existing config-custom or style-custom.css
if [ -f $themestyle/config-custom ] ;then
    config_file="config-custom"
fi
if [ -f $themestyle/style-custom.css ] ;then
    style_file="style-custom.css"
fi

# Start waybar
waybar -c $themestyle/$config_file -s $themestyle/$style_file
