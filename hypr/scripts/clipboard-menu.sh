#!/bin/bash
# Clipboard menu using cliphist and wofi

# Ensure cliphist is storing clipboard data
if ! pgrep -x "wl-paste" > /dev/null; then
    wl-paste --watch cliphist store &
fi

# Show clipboard history with wofi - using style.css for Catppuccin theme
# --insensitive for case-insensitive search
# --cache-file=/dev/null to prevent escape key issues
cliphist list | wofi --dmenu \
    --prompt "Clipboard" \
    --lines 10 \
    --width 800 \
    --insensitive \
    --cache-file=/dev/null \
    --style ~/.config/wofi/style.css | cliphist decode | wl-copy