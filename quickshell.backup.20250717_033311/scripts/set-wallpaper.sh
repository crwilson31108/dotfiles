#!/bin/bash
# Simple wallpaper setter using swww
# Replaces caelestia wallpaper functionality

WALLPAPER="$1"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/wallpaper"

# Create state directory if it doesn't exist
mkdir -p "$STATE_DIR"

if [ -z "$WALLPAPER" ]; then
    echo "Usage: $0 <wallpaper-path>"
    exit 1
fi

if [ ! -f "$WALLPAPER" ]; then
    echo "Error: Wallpaper file not found: $WALLPAPER"
    exit 1
fi

# Set wallpaper using swww
swww img "$WALLPAPER" --transition-type fade --transition-duration 1

# Save current wallpaper path
echo "$WALLPAPER" > "$STATE_DIR/path.txt"

echo "Wallpaper set to: $WALLPAPER"