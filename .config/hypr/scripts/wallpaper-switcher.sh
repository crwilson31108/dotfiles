#!/bin/bash

# Enable globstar for recursive directory matching
shopt -s globstar

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Get list of wallpapers (including subdirectories for catppuccin wallpapers)
wallpapers=("$WALLPAPER_DIR"/catppuccin-wallpapers/**/*.{jpg,jpeg,png,webp})

# Filter out non-existent patterns
existing_wallpapers=()
for wall in "${wallpapers[@]}"; do
    [ -f "$wall" ] && existing_wallpapers+=("$wall")
done

# Check if we have wallpapers
if [ ${#existing_wallpapers[@]} -eq 0 ]; then
    notify-send "No wallpapers found" "Add images to $WALLPAPER_DIR"
    exit 1
fi

# If argument provided, use it as index, otherwise random
if [ -n "$1" ]; then
    if [ "$1" = "menu" ]; then
        # Show menu with wofi
        selected=$(printf '%s\n' "${existing_wallpapers[@]}" | xargs -n1 basename | wofi --dmenu --prompt "Select Wallpaper")
        [ -z "$selected" ] && exit 0
        wallpaper="$WALLPAPER_DIR/$selected"
    else
        # Use provided index
        index=$1
        wallpaper="${existing_wallpapers[$index]}"
    fi
else
    # Random selection
    wallpaper="${existing_wallpapers[$RANDOM % ${#existing_wallpapers[@]}]}"
fi

# Initialize swww if not running
if ! pgrep -x swww-daemon > /dev/null; then
    swww init
    sleep 1
fi

# Set new wallpaper with smooth transition
swww img "$wallpaper" --transition-type grow --transition-pos center --transition-fps 60 --transition-duration 1

# Show notification
notify-send "Wallpaper Changed" "$(basename "$wallpaper")" -i "$wallpaper"