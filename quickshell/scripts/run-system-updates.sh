#!/bin/bash

# System Update Execution Script
# Opens terminal and runs system updates

# Get the preferred terminal emulator
if command -v foot &> /dev/null; then
    TERMINAL="foot"
elif command -v kitty &> /dev/null; then
    TERMINAL="kitty"
elif command -v alacritty &> /dev/null; then
    TERMINAL="alacritty"
elif command -v wezterm &> /dev/null; then
    TERMINAL="wezterm"
elif command -v gnome-terminal &> /dev/null; then
    TERMINAL="gnome-terminal"
else
    # Fallback to any available terminal
    TERMINAL="xterm"
fi

# Detect preferred shell
if [ -n "$SHELL" ]; then
    USER_SHELL="$SHELL"
elif command -v zsh &> /dev/null; then
    USER_SHELL="zsh"
elif command -v bash &> /dev/null; then
    USER_SHELL="bash"
else
    USER_SHELL="sh"
fi

# Create update command based on available package managers
update_commands=""

# Add pacman/AUR updates
if command -v yay &> /dev/null; then
    update_commands="echo 'Updating system packages with yay...' && yay -Syu"
elif command -v paru &> /dev/null; then
    update_commands="echo 'Updating system packages with paru...' && paru -Syu"
elif command -v pacman &> /dev/null; then
    update_commands="echo 'Updating system packages with pacman...' && sudo pacman -Syu"
fi

# Add flatpak updates
if command -v flatpak &> /dev/null; then
    if [ -n "$update_commands" ]; then
        update_commands="${update_commands} && "
    fi
    update_commands="${update_commands}echo 'Updating Flatpak packages...' && flatpak update"
fi

# Add snap updates
if command -v snap &> /dev/null; then
    if [ -n "$update_commands" ]; then
        update_commands="${update_commands} && "
    fi
    update_commands="${update_commands}echo 'Updating Snap packages...' && sudo snap refresh"
fi

# If no update commands found, show message
if [ -z "$update_commands" ]; then
    update_commands="echo 'No package managers found for updates.'"
fi

# Add final message, refresh update counts, and wait for user input
update_commands="${update_commands} && echo 'Updates completed!' && echo 'Refreshing update counts...' && ~/.config/quickshell/scripts/update-counts.sh && echo 'Done! Press any key to continue...' && read -n 1"

# Launch terminal with update commands
case "$TERMINAL" in
    "foot")
        foot --title="System Updates" "$USER_SHELL" -c "$update_commands" &
        ;;
    "kitty")
        kitty --title "System Updates" "$USER_SHELL" -c "$update_commands" &
        ;;
    "alacritty")
        alacritty --title "System Updates" -e "$USER_SHELL" -c "$update_commands" &
        ;;
    "wezterm")
        wezterm start --class "system-updates" -- "$USER_SHELL" -c "$update_commands" &
        ;;
    "gnome-terminal")
        gnome-terminal --title="System Updates" -- "$USER_SHELL" -c "$update_commands" &
        ;;
    *)
        $TERMINAL -e "$USER_SHELL" -c "$update_commands" &
        ;;
esac