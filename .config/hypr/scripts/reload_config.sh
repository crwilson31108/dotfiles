#!/bin/bash

# Kill waybar if it's running
killall waybar

# Set proper environment variables for Flatpak support
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"

# Reload Hyprland config
hyprctl reload

# Start both waybar instances
waybar & 
waybar -c ~/.config/waybar/config-bottom &

# Update the keybindings cheat sheet data
echo "Updating keybindings cheat sheet..." >> /tmp/hyprland_reload.log

# Notify user about the reload
if command -v notify-send >/dev/null 2>&1; then
    notify-send -t 3000 "Hyprland" "Configuration reloaded with keybindings cheat sheet" -i preferences-system
fi