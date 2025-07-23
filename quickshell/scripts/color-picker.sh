#!/bin/bash
# Ensure proper Wayland environment
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-0}
export XDG_SESSION_TYPE=wayland

# Launch hyprpicker completely detached from quickshell
# Using setsid to create new session and nohup to ignore hangup signals
nohup setsid hyprpicker -a >/dev/null 2>&1 &

# Exit immediately so quickshell process completes
exit 0