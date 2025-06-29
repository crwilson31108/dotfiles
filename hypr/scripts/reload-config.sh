#!/bin/bash

# Set proper environment variables for Flatpak support
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"

# Restart waybar
pkill waybar
sleep 1
waybar -c ~/.config/waybar/config-top &
waybar -c ~/.config/waybar/config-bottom &

# Reload Hyprland config
hyprctl reload
