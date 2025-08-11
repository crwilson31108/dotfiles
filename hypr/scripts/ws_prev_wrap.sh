#!/bin/bash
# Workspace previous with wrapping (1-4)

current=$(hyprctl activeworkspace -j | jq '.id')

if [ "$current" -le 1 ]; then
    hyprctl dispatch workspace 4
else
    hyprctl dispatch workspace e-1
fi