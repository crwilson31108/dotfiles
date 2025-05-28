#!/bin/bash
# Create a thirds layout on top with stacks underneath
# Layout will be:
# [  1  ] [  2  ] [  3  ]
# [  4  ] [  5  ] [  6  ]

# Get the number of windows in the current workspace
windows=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $(hyprctl activewindow -j | jq .workspace.id))] | length")

if [ "$windows" -lt 2 ]; then
    echo "Need at least 2 windows for this layout"
    exit 1
fi

# Focus workspace root
hyprctl dispatch hy3:changefocus bottom

# First create a vertical split (top/bottom)
hyprctl dispatch hy3:makegroup v

# Now create the top thirds
hyprctl dispatch hy3:makegroup h
hyprctl dispatch hy3:movefocus r
hyprctl dispatch hy3:makegroup h

# If we have more than 3 windows, organize the bottom
if [ "$windows" -gt 3 ]; then
    # Move to the bottom section
    hyprctl dispatch hy3:changefocus bottom
    hyprctl dispatch hy3:movefocus d
    
    # Create horizontal splits in the bottom section
    hyprctl dispatch hy3:makegroup h
    
    if [ "$windows" -gt 5 ]; then
        hyprctl dispatch hy3:movefocus r
        hyprctl dispatch hy3:makegroup h
    fi
fi