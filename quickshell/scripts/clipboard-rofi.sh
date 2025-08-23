#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get clipboard history from cliphist
selected=$(cliphist list | rofi -dmenu -p " Clipboard" -theme "$SCRIPT_DIR/clipboard-rofi.rasi")

# If something was selected, copy it to clipboard
if [ -n "$selected" ]; then
    # cliphist decode handles the clipboard entry
    echo "$selected" | cliphist decode | wl-copy
fi