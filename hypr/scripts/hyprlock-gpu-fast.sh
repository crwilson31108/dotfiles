#!/bin/bash

# Take a fresh screenshot every time hyprlock is initiated
# Remove any existing screenshot files first
rm -f /tmp/hyprlock-screenshot.png /tmp/hyprlock-screenshot.ppm

# Capture screenshot directly as PNG for immediate availability
grim -o eDP-1 /tmp/hyprlock-screenshot.png

# Launch hyprlock now that screenshot is ready
hyprlock