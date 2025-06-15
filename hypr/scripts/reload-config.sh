#!/bin/bash

# Kill AGS if it's running
ags quit

# Set proper environment variables for Flatpak support
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"

# Reload Hyprland config
hyprctl reload

# Start AGS from its config directory
cd ~/.config/ags && ags run &
