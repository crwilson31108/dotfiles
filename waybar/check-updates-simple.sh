#!/bin/bash

# Get update counts
pacman_updates=$(checkupdates 2>/dev/null | wc -l)
aur_updates=$(yay -Qua 2>/dev/null | wc -l)
total_updates=$((pacman_updates + aur_updates))

# Output the count
echo "${total_updates}"