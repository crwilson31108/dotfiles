#!/bin/bash

# Screenshot menu script for waybar

# Define screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
get_filename() {
    echo "$SCREENSHOT_DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
}

# Define screenshot options
declare -A options=(
    ["📷 Region"]="region"
    ["🖼️ Window"]="window"
    ["🖥️ Monitor"]="monitor"
    ["📋 Region to Clipboard"]="region_clipboard"
    ["⏱️ Region (3s delay)"]="region_delay"
)

# If no argument, show the module
if [ -z "$1" ]; then
    echo '{"text": "📷", "tooltip": "Screenshot\nClick: Region\nRight-click: Menu\nMiddle: Window"}'
    exit 0
fi

# Function to take screenshots
take_screenshot() {
    case "$1" in
        "region")
            grim -g "$(slurp)" - | swappy -f - &
            ;;
        "window")
            # Get window geometry using slurp with window selection
            grim -g "$(slurp -w 0)" - | swappy -f - &
            ;;
        "monitor")
            grim - | swappy -f - &
            ;;
        "region_clipboard")
            grim -g "$(slurp)" - | wl-copy &
            ;;
        "region_delay")
            sleep 3 && grim -g "$(slurp)" - | swappy -f - &
            ;;
    esac
}

# Handle different click actions
case "$1" in
    "menu")
        # Show menu with wofi
        choice=$(printf '%s\n' "${!options[@]}" | wofi --dmenu --prompt "Screenshot Mode")
        if [ -n "$choice" ]; then
            take_screenshot "${options[$choice]}"
        fi
        ;;
    "region")
        take_screenshot "region"
        ;;
    "window")
        take_screenshot "window"
        ;;
    "output")
        take_screenshot "monitor"
        ;;
esac