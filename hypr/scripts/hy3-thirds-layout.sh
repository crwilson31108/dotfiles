#!/bin/bash
# Create a thirds layout (3 equal columns)

# This creates a horizontal split at the root level, then splits each section
# to create 3 equal columns

# First, focus the workspace root to ensure we're working with the whole workspace
hyprctl dispatch hy3:changefocus bottom

# Create the first horizontal split
hyprctl dispatch hy3:makegroup h

# Move to the right side and split it again
hyprctl dispatch hy3:movefocus r
hyprctl dispatch hy3:makegroup h

# Now we have 3 equal columns
# The layout is: [Window 1] | [Window 2] | [Window 3]