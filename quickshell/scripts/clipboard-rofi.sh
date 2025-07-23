#!/bin/bash

# Get clipboard history from cliphist
selected=$(cliphist list | rofi -dmenu -p "Clipboard" -theme-str 'window {width: 50%;}' -theme-str 'listview {lines: 10;}')

# If something was selected, copy it to clipboard
if [ -n "$selected" ]; then
    # cliphist decode handles the clipboard entry
    echo "$selected" | cliphist decode | wl-copy
fi