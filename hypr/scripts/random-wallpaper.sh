#!/bin/bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Initialize swww daemon
swww-daemon &

# Wait a moment for the daemon to start
sleep 0.5

# Get a random wallpaper from the directory
# Only select image files (jpg, jpeg, png, webp)
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

# Set the wallpaper with a nice transition
# You can customize the transition type and duration
swww img "$WALLPAPER" --transition-type grow --transition-pos center --transition-duration 1