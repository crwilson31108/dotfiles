#!/bin/bash

# Gaming mode toggle script for Hyprland

GAMING_STATE_FILE="/tmp/hyprland-gaming-mode"

toggle_gaming_mode() {
    if [ -f "$GAMING_STATE_FILE" ]; then
        # Disable gaming mode
        echo "Disabling gaming mode..."
        
        # Re-enable animations
        hyprctl keyword animations:enabled 1
        
        # Re-enable blur
        hyprctl keyword decoration:blur:enabled true
        
        # Re-enable shadows
        hyprctl keyword decoration:drop_shadow true
        
        # Re-enable fractional scaling if it was enabled
        if [ -f "/tmp/fractional-scaling-state" ]; then
            SCALE=$(cat /tmp/fractional-scaling-state)
            hyprctl keyword monitor ,preferred,auto,$SCALE
        fi
        
        # Remove state file
        rm -f "$GAMING_STATE_FILE"
        
        notify-send "Gaming Mode" "Disabled - Effects restored" -i input-gaming
    else
        # Enable gaming mode
        echo "Enabling gaming mode..."
        
        # Save current fractional scaling state
        hyprctl monitors -j | jq -r '.[0].scale' > /tmp/fractional-scaling-state
        
        # Disable animations
        hyprctl keyword animations:enabled 0
        
        # Disable blur
        hyprctl keyword decoration:blur:enabled false
        
        # Disable shadows
        hyprctl keyword decoration:drop_shadow false
        
        # Set scaling to 1.0 for best performance
        hyprctl keyword monitor ,preferred,auto,1
        
        # Create state file
        touch "$GAMING_STATE_FILE"
        
        notify-send "Gaming Mode" "Enabled - Performance optimized" -i input-gaming
    fi
}

case "$1" in
    toggle)
        toggle_gaming_mode
        ;;
    *)
        echo "Usage: $0 toggle"
        exit 1
        ;;
esac