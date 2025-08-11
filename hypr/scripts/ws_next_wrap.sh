#!/bin/bash
# Workspace next with wrapping (1-4)

current=$(hyprctl activeworkspace -j | jq '.id')

if [ "$current" -ge 4 ]; then
    hyprctl dispatch workspace 1
else
    hyprctl dispatch workspace e+1
fi