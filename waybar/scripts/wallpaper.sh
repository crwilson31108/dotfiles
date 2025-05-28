#!/bin/bash

WALLPAPER_DIR="$HOME/.config/waybar/wallpapers"
CONFIG_FILE="$HOME/.config/waybar/current_wallpaper"
DEFAULT_TRANSITION="wipe"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Initialize swww if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww init
fi

# Get current wallpaper
get_current_wallpaper() {
    if [ -f "$CONFIG_FILE" ]; then
        cat "$CONFIG_FILE"
    else
        echo ""
    fi
}

# Set current wallpaper in config
set_current_wallpaper() {
    echo "$1" > "$CONFIG_FILE"
}

# Get list of wallpapers
get_wallpaper_list() {
    find "$WALLPAPER_DIR" -type f -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" | sort
}

# Set wallpaper with swww
set_wallpaper() {
    local wallpaper="$1"
    local transition="${2:-$DEFAULT_TRANSITION}"
    
    if [ -f "$wallpaper" ]; then
        swww img "$wallpaper" --transition-type "$transition" --transition-step 90
        set_current_wallpaper "$wallpaper"
        echo "Wallpaper set to: $(basename "$wallpaper")"
    else
        echo "Error: Wallpaper file not found"
        return 1
    fi
}

# Set random wallpaper
set_random_wallpaper() {
    local wallpapers=($(get_wallpaper_list))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi
    
    local random_index=$((RANDOM % ${#wallpapers[@]}))
    local random_wallpaper="${wallpapers[$random_index]}"
    
    set_wallpaper "$random_wallpaper"
}

# Show wallpaper menu with wofi
show_wallpaper_menu() {
    local wallpapers=($(get_wallpaper_list))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        notify-send "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi
    
    local menu_items=""
    for wp in "${wallpapers[@]}"; do
        menu_items+="$(basename "$wp")\n"
    done
    
    selection=$(echo -e "$menu_items" | wofi --dmenu --prompt "Select Wallpaper" --insensitive --width 400)
    
    if [ -n "$selection" ]; then
        for wp in "${wallpapers[@]}"; do
            if [ "$(basename "$wp")" = "$selection" ]; then
                set_wallpaper "$wp"
                break
            fi
        done
    fi
}

# For waybar integration - returns current wallpaper name
get_waybar_data() {
    local current=$(get_current_wallpaper)
    
    if [ -n "$current" ] && [ -f "$current" ]; then
        local name=$(basename "$current")
        echo "{\"text\":\"$name\",\"tooltip\":\"Current wallpaper: $name\nClick to change\"}"
    else
        echo "{\"text\":\"No wallpaper\",\"tooltip\":\"Click to set wallpaper\"}"
    fi
}

# Main
case "$1" in
    "set")
        if [ -n "$2" ]; then
            set_wallpaper "$2" "$3"
        else
            echo "Usage: $0 set WALLPAPER_PATH [TRANSITION_TYPE]"
        fi
        ;;
    "random")
        set_random_wallpaper
        ;;
    "menu")
        show_wallpaper_menu
        ;;
    "waybar")
        get_waybar_data
        ;;
    *)
        # Default behavior: return data for waybar
        get_waybar_data
        ;;
esac