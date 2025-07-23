#!/bin/bash

target_workspace="$1"
current_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id' 2>/dev/null || hyprctl monitors -j | jq -r '.[].activeWorkspace.id' | head -1)

# Only switch if we're not already on the target workspace
if [ "$current_workspace" != "$target_workspace" ]; then
    hyprctl dispatch workspace "$target_workspace"
fi