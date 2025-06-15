#!/bin/bash

# Custom floating toggle script that respects AGS bars
# Based on solutions from https://github.com/hyprwm/Hyprland/issues/7926

# Get the class and floating status of the active window
active_class=$(hyprctl activewindow | awk -F": " '/class:/ {print $2}')
is_floating=$(hyprctl activewindow | awk -F": " '/floating:/ {print $2}')

# If the window is already floating, toggle it back to tiled
if [[ $is_floating == "1" ]]; then
    hyprctl dispatch togglefloating
    exit 0
fi

# Float the window and resize/position based on its class
# All windows start 50px from top (below AGS top bar) and are sized to fit between bars

case $active_class in
    *"zen"*)
        hyprctl dispatch togglefloating
        hyprctl dispatch resizeactive exact 90% 820
        hyprctl dispatch moveactive exact 72 50
        ;;
    *"Alacritty"*)
        hyprctl dispatch togglefloating
        hyprctl dispatch resizeactive exact 85% 750
        hyprctl dispatch moveactive exact 108 75
        ;;
    *"kitty"*)
        hyprctl dispatch togglefloating
        hyprctl dispatch resizeactive exact 85% 750
        hyprctl dispatch moveactive exact 108 75
        ;;
    *"Code"*)
        hyprctl dispatch togglefloating
        hyprctl dispatch resizeactive exact 95% 840
        hyprctl dispatch moveactive exact 36 50
        ;;
    *)
        # Default for all other applications
        hyprctl dispatch togglefloating
        hyprctl dispatch resizeactive exact 80% 800
        hyprctl dispatch moveactive exact 144 50
        ;;
esac