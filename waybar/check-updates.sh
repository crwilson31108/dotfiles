#!/bin/bash

# Get update counts
pacman_updates=$(checkupdates 2>/dev/null | wc -l)
aur_updates=$(yay -Qua 2>/dev/null | wc -l)
total_updates=$((pacman_updates + aur_updates))

# Determine icon and class
if [ $total_updates -gt 0 ]; then
    icon="󰚰"
    class="has-updates"
    tooltip="${pacman_updates} pacman updates\\n${aur_updates} AUR updates"
else
    icon="󰄳"
    class="updated"
    tooltip="System is up to date"
fi

# Output with icon in text
echo "${icon} ${total_updates}"