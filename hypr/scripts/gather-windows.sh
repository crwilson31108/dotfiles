#!/bin/bash

# Get current workspace
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Get all windows from workspaces 1-4 (excluding current)
moved_count=0

for ws in 1 2 3 4; do
    if [ "$ws" != "$current_ws" ]; then
        # Get windows from this workspace
        windows=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ws) | .address")
        
        # Move each window to current workspace
        while IFS= read -r window_address; do
            if [ -n "$window_address" ]; then
                hyprctl dispatch movetoworkspacesilent "$current_ws,address:$window_address"
                ((moved_count++))
            fi
        done <<< "$windows"
    fi
done

if [ $moved_count -gt 0 ]; then
    notify-send "Gather Windows" "Moved $moved_count windows to workspace $current_ws"
else
    notify-send "Gather Windows" "No windows found to move"
fi