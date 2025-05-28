#!/bin/bash

# Script to cycle through workspaces including empty ones
# Usage: workspace-cycle.sh next|prev

direction=$1
# Get current workspace from monitors instead of active window
current=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

if [ "$direction" = "next" ]; then
    # Cycle through workspaces 1-4
    next=$((current + 1))
    if [ "$next" -gt 4 ]; then
        next=1
    fi
    hyprctl dispatch workspace $next
elif [ "$direction" = "prev" ]; then
    # If we're at workspace 1, wrap to 4
    if [ "$current" -le 1 ]; then
        hyprctl dispatch workspace 4
    else
        hyprctl dispatch workspace $((current - 1))
    fi
fi