#!/bin/bash

WALLPAPER_DIR="$HOME/.config/waybar/wallpapers"
mkdir -p "$WALLPAPER_DIR"

cd "$WALLPAPER_DIR"

# Download some sample wallpapers
wget -O forest.jpg "https://images.pexels.com/photos/3571551/pexels-photo-3571551.jpeg?auto=compress&cs=tinysrgb&w=1920"
wget -O mountain.jpg "https://images.pexels.com/photos/1261728/pexels-photo-1261728.jpeg?auto=compress&cs=tinysrgb&w=1920"
wget -O beach.jpg "https://images.pexels.com/photos/1005417/pexels-photo-1005417.jpeg?auto=compress&cs=tinysrgb&w=1920"
wget -O night-city.jpg "https://images.pexels.com/photos/1434608/pexels-photo-1434608.jpeg?auto=compress&cs=tinysrgb&w=1920"

echo "Downloaded wallpapers to $WALLPAPER_DIR"