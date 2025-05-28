#!/bin/bash

WALLPAPER_DIR="$HOME/.config/waybar/wallpapers"
mkdir -p "$WALLPAPER_DIR"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Please install it first."
    exit 1
fi

# Create solid color wallpapers
create_solid_wallpaper() {
    local color="$1"
    local name="$2"
    convert -size 1920x1080 xc:"$color" "$WALLPAPER_DIR/$name.png"
}

create_gradient_wallpaper() {
    local color1="$1"
    local color2="$2"
    local name="$3"
    convert -size 1920x1080 gradient:"$color1"-"$color2" "$WALLPAPER_DIR/$name.png"
}

# Solid colors
create_solid_wallpaper "#0f0f17" "dark-blue"
create_solid_wallpaper "#171a0f" "dark-green"
create_solid_wallpaper "#170f0f" "dark-red"
create_solid_wallpaper "#0f1017" "dark-purple"

# Gradients
create_gradient_wallpaper "#1a1b26" "#24283b" "tokyo-night"
create_gradient_wallpaper "#282a36" "#44475a" "dracula"
create_gradient_wallpaper "#2e3440" "#3b4252" "nord"
create_gradient_wallpaper "#1e1e2e" "#313244" "catppuccin"

echo "Created wallpapers in $WALLPAPER_DIR"