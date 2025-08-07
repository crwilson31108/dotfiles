#!/usr/bin/env bash

# Launch the first available file manager
# Priority: dolphin > thunar > nautilus > nemo > pcmanfm > terminal file manager

if command -v dolphin &>/dev/null; then
    dolphin "$@"
elif command -v thunar &>/dev/null; then
    thunar "$@"
elif command -v nautilus &>/dev/null; then
    nautilus "$@"
elif command -v nemo &>/dev/null; then
    nemo "$@"
elif command -v pcmanfm &>/dev/null; then
    pcmanfm "$@"
elif command -v yazi &>/dev/null; then
    foot -e yazi "$@"
elif command -v ranger &>/dev/null; then
    foot -e ranger "$@"
else
    notify-send "No file manager found" "Please install a file manager like dolphin, thunar, or nautilus"
fi