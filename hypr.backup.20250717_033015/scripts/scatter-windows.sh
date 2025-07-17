#!/bin/bash

# Get current workspace
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Available workspaces (1-4, excluding current)
workspaces=(1 2 3 4)
target_workspaces=()

# Remove current workspace from targets
for ws in "${workspaces[@]}"; do
    if [ "$ws" != "$current_ws" ]; then
        target_workspaces+=("$ws")
    fi
done

# If we're not on workspaces 1-4, use all of them
if [ ${#target_workspaces[@]} -eq 0 ]; then
    target_workspaces=(1 2 3 4)
fi

# Get list of unfocused window addresses on current workspace
unfocused_windows=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $current_ws and .focusHistoryID != 0) | .address")

# Convert to array
readarray -t window_addresses <<< "$unfocused_windows"

# If no unfocused windows, exit
if [ ${#window_addresses[@]} -eq 0 ] || [ -z "${window_addresses[0]}" ]; then
    notify-send "Scatter Windows" "No unfocused windows to move"
    exit 0
fi

# Distribute windows evenly across target workspaces
target_count=${#target_workspaces[@]}
window_count=${#window_addresses[@]}

for i in "${!window_addresses[@]}"; do
    if [ -n "${window_addresses[$i]}" ]; then
        # Calculate target workspace index using modulo for even distribution
        target_index=$((i % target_count))
        target_ws=${target_workspaces[$target_index]}
        
        # Move window to target workspace
        hyprctl dispatch movetoworkspacesilent "$target_ws,address:${window_addresses[$i]}"
    fi
done

notify-send "Scatter Windows" "Moved $window_count windows across ${target_count} workspaces"