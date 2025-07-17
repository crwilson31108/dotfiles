#!/bin/bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Check if swww daemon is running
if ! pgrep -x "swww-daemon" > /dev/null; then
    echo "swww daemon is not running. Starting it..."
    swww-daemon &
    sleep 0.5
fi

# Get a random wallpaper from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

# Set the wallpaper with a nice transition
# You can customize the transition type here
swww img "$WALLPAPER" --transition-type grow --transition-pos center --transition-duration 1

# Optional: Print the wallpaper name
echo "Changed wallpaper to: $(basename "$WALLPAPER")"