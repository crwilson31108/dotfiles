#!/bin/bash

# This script creates a workspace selection menu using wofi

selected=$(printf "1\n2\n3\n4\n5\n6\n7\n8\n9\n10" | wofi --dmenu --prompt "Workspace" --width 100 --lines 10 --hide-scroll --insensitive)

if [[ -n "$selected" ]]; then
    hyprctl dispatch workspace "$selected"
fi