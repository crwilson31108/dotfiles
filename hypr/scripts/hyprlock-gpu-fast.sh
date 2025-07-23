#!/bin/bash

# Use GPU-accelerated capture with minimal processing
# Lower quality for speed, PPM format avoids PNG encoding overhead
grim -o eDP-1 -t ppm -q 85 /tmp/hyprlock-screenshot.ppm &
GRIM_PID=$!

# Launch hyprlock immediately
hyprlock &
HYPRLOCK_PID=$!

# Convert to PNG in background while hyprlock is starting
(
    wait $GRIM_PID
    # Use GPU-accelerated conversion if available
    if command -v ffmpeg &> /dev/null; then
        ffmpeg -i /tmp/hyprlock-screenshot.ppm -vf format=rgba -y /tmp/hyprlock-screenshot.png 2>/dev/null
    else
        convert /tmp/hyprlock-screenshot.ppm /tmp/hyprlock-screenshot.png
    fi
    rm -f /tmp/hyprlock-screenshot.ppm
) &

wait $HYPRLOCK_PID