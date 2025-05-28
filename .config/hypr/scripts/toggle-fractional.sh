#!/bin/bash

# Toggle fractional scaling for Hyprland

SCALE_STATE_FILE="/tmp/hyprland-fractional-scale"

if [ -f "$SCALE_STATE_FILE" ]; then
    # Currently using fractional scaling, switch to 1.0
    hyprctl keyword monitor ,preferred,auto,1
    rm -f "$SCALE_STATE_FILE"
    notify-send "Fractional Scaling" "Disabled (1.0x)" -i display
else
    # Currently at 1.0, switch to fractional scaling
    # Adjust this value to your preferred fractional scale
    FRACTIONAL_SCALE="1.25"
    hyprctl keyword monitor ,preferred,auto,$FRACTIONAL_SCALE
    echo "$FRACTIONAL_SCALE" > "$SCALE_STATE_FILE"
    notify-send "Fractional Scaling" "Enabled (${FRACTIONAL_SCALE}x)" -i display
fi