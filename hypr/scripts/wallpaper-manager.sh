#!/usr/bin/env bash

# Smart wallpaper management system
# Handles static images, video wallpapers, and automatic switching

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THUMBNAILS_DIR="$HOME/.cache/wallpaper-thumbnails"
CURRENT_WALLPAPER_FILE="$HOME/.cache/current-wallpaper"

print_msg() {
    local color=$1
    shift
    echo -e "${color}[wallpaper]: $@${NC}"
}

# Initialize wallpaper directories
init_dirs() {
    mkdir -p "$WALLPAPER_DIR" "$THUMBNAILS_DIR"
}

# Check if file is a video
is_video() {
    local file="$1"
    [[ "$file" =~ \.(mp4|mkv|webm|avi|mov)$ ]]
}

# Check if file is an image
is_image() {
    local file="$1"
    [[ "$file" =~ \.(jpg|jpeg|png|gif|bmp|webp)$ ]]
}

# Generate thumbnail for image
generate_image_thumbnail() {
    local image="$1"
    local thumb_path="$THUMBNAILS_DIR/$(basename "${image%.*}").jpg"
    
    if [[ ! -f "$thumb_path" ]] && command -v convert &>/dev/null; then
        convert "$image" -resize 200x200^ -gravity center -extent 200x200 "$thumb_path" 2>/dev/null
    elif [[ ! -f "$thumb_path" ]] && command -v ffmpeg &>/dev/null; then
        ffmpeg -i "$image" -vf scale=200:200:force_original_aspect_ratio=increase,crop=200:200 "$thumb_path" -y &>/dev/null
    fi
    
    echo "$thumb_path"
}

# Generate thumbnail for video
generate_video_thumbnail() {
    local video="$1"
    local thumb_path="$THUMBNAILS_DIR/$(basename "${video%.*}").jpg"
    
    if [[ ! -f "$thumb_path" ]] && command -v ffmpeg &>/dev/null; then
        # Extract frame at 10% of video duration
        ffmpeg -i "$video" -ss $(ffprobe -v error -show_entries format=duration -of csv=p=0 "$video" | awk '{print $1*0.1}') -vframes 1 -vf scale=200:200:force_original_aspect_ratio=increase,crop=200:200 "$thumb_path" -y &>/dev/null 2>&1
    fi
    
    echo "$thumb_path"
}

# Set static wallpaper using hyprpaper
set_static_wallpaper() {
    local wallpaper="$1"
    
    if [[ ! -f "$wallpaper" ]]; then
        print_msg "$RED" "Wallpaper file not found: $wallpaper"
        return 1
    fi
    
    if ! is_image "$wallpaper"; then
        print_msg "$RED" "File is not a supported image format"
        return 1
    fi
    
    print_msg "$BLUE" "Setting static wallpaper: $(basename "$wallpaper")"
    
    # Kill existing hyprpaper if running
    pkill hyprpaper 2>/dev/null
    sleep 1
    
    # Create temporary hyprpaper config
    local temp_config=$(mktemp)
    cat > "$temp_config" << EOF
preload = $wallpaper
wallpaper = ,$wallpaper
splash = false
EOF
    
    # Start hyprpaper with config
    hyprpaper -c "$temp_config" &
    sleep 2
    rm "$temp_config"
    
    # Save current wallpaper info
    echo "static:$wallpaper" > "$CURRENT_WALLPAPER_FILE"
    
    print_msg "$GREEN" "Static wallpaper set successfully"
}

# Set video wallpaper using mpvpaper
set_video_wallpaper() {
    local wallpaper="$1"
    
    if [[ ! -f "$wallpaper" ]]; then
        print_msg "$RED" "Wallpaper file not found: $wallpaper"
        return 1
    fi
    
    if ! is_video "$wallpaper"; then
        print_msg "$RED" "File is not a supported video format"
        return 1
    fi
    
    if ! command -v mpvpaper &>/dev/null; then
        print_msg "$RED" "mpvpaper not installed. Install it for video wallpaper support."
        return 1
    fi
    
    print_msg "$BLUE" "Setting video wallpaper: $(basename "$wallpaper")"
    
    # Kill existing wallpaper processes
    pkill hyprpaper 2>/dev/null
    pkill mpvpaper 2>/dev/null
    sleep 1
    
    # Start mpvpaper
    mpvpaper '*' "$wallpaper" --loop --no-audio &
    
    # Save current wallpaper info
    echo "video:$wallpaper" > "$CURRENT_WALLPAPER_FILE"
    
    print_msg "$GREEN" "Video wallpaper set successfully"
}

# Auto-detect and set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    
    if is_image "$wallpaper"; then
        set_static_wallpaper "$wallpaper"
    elif is_video "$wallpaper"; then
        set_video_wallpaper "$wallpaper"
    else
        print_msg "$RED" "Unsupported file format: $wallpaper"
        return 1
    fi
}

# List available wallpapers
list_wallpapers() {
    init_dirs
    
    if [[ ! -d "$WALLPAPER_DIR" ]] || [[ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]]; then
        print_msg "$YELLOW" "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi
    
    print_msg "$BLUE" "Available wallpapers:"
    echo
    
    local count=0
    for file in "$WALLPAPER_DIR"/*; do
        [[ -f "$file" ]] || continue
        
        local basename=$(basename "$file")
        if is_image "$file" || is_video "$file"; then
            ((count++))
            local size=$(du -h "$file" | cut -f1)
            local type="image"
            [[ $(is_video "$file") ]] && type="video"
            
            echo "$count. $basename ($type, $size)"
            
            # Show dimensions if possible
            if is_image "$file" && command -v identify &>/dev/null; then
                local dims=$(identify -format "%wx%h" "$file" 2>/dev/null)
                [[ -n "$dims" ]] && echo "   Resolution: $dims"
            elif is_video "$file" && command -v ffprobe &>/dev/null; then
                local dims=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file" 2>/dev/null)
                [[ -n "$dims" ]] && echo "   Resolution: $dims"
            fi
        fi
    done
    
    if [[ $count -eq 0 ]]; then
        print_msg "$YELLOW" "No supported wallpaper files found"
        return 1
    fi
    
    print_msg "$BLUE" "Total wallpapers: $count"
}

# Interactive wallpaper selector
select_wallpaper() {
    list_wallpapers
    echo
    
    read -p "Enter wallpaper number or name: " choice
    
    if [[ -z "$choice" ]]; then
        print_msg "$YELLOW" "No wallpaper selected"
        return 1
    fi
    
    local selected_file=""
    
    # Check if it's a number
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
        local count=0
        for file in "$WALLPAPER_DIR"/*; do
            [[ -f "$file" ]] || continue
            if is_image "$file" || is_video "$file"; then
                ((count++))
                if [[ $count -eq $choice ]]; then
                    selected_file="$file"
                    break
                fi
            fi
        done
    else
        # Try to find by name
        for file in "$WALLPAPER_DIR"/*; do
            if [[ "$(basename "$file")" == "$choice" ]] || [[ "$(basename "$file")" == *"$choice"* ]]; then
                selected_file="$file"
                break
            fi
        done
    fi
    
    if [[ -z "$selected_file" ]]; then
        print_msg "$RED" "Wallpaper not found: $choice"
        return 1
    fi
    
    set_wallpaper "$selected_file"
}

# Random wallpaper
random_wallpaper() {
    init_dirs
    
    local wallpapers=()
    for file in "$WALLPAPER_DIR"/*; do
        [[ -f "$file" ]] || continue
        if is_image "$file" || is_video "$file"; then
            wallpapers+=("$file")
        fi
    done
    
    if [[ ${#wallpapers[@]} -eq 0 ]]; then
        print_msg "$RED" "No wallpapers available for random selection"
        return 1
    fi
    
    local random_index=$((RANDOM % ${#wallpapers[@]}))
    local random_wallpaper="${wallpapers[$random_index]}"
    
    print_msg "$BLUE" "Randomly selected: $(basename "$random_wallpaper")"
    set_wallpaper "$random_wallpaper"
}

# Show current wallpaper
show_current() {
    if [[ ! -f "$CURRENT_WALLPAPER_FILE" ]]; then
        print_msg "$YELLOW" "No current wallpaper information found"
        return 1
    fi
    
    local current=$(cat "$CURRENT_WALLPAPER_FILE")
    local type=$(echo "$current" | cut -d: -f1)
    local path=$(echo "$current" | cut -d: -f2-)
    
    print_msg "$BLUE" "Current wallpaper:"
    echo "  Type: $type"
    echo "  File: $(basename "$path")"
    echo "  Path: $path"
    
    if [[ -f "$path" ]]; then
        echo "  Size: $(du -h "$path" | cut -f1)"
        
        if is_image "$path" && command -v identify &>/dev/null; then
            local dims=$(identify -format "%wx%h" "$path" 2>/dev/null)
            [[ -n "$dims" ]] && echo "  Resolution: $dims"
        elif is_video "$path" && command -v ffprobe &>/dev/null; then
            local dims=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$path" 2>/dev/null)
            [[ -n "$dims" ]] && echo "  Resolution: $dims"
        fi
    else
        print_msg "$YELLOW" "Current wallpaper file no longer exists"
    fi
}

# Restore wallpaper (useful after system restart)
restore_wallpaper() {
    if [[ ! -f "$CURRENT_WALLPAPER_FILE" ]]; then
        print_msg "$YELLOW" "No wallpaper to restore"
        return 1
    fi
    
    local current=$(cat "$CURRENT_WALLPAPER_FILE")
    local path=$(echo "$current" | cut -d: -f2-)
    
    if [[ ! -f "$path" ]]; then
        print_msg "$RED" "Cannot restore wallpaper: file not found"
        return 1
    fi
    
    print_msg "$BLUE" "Restoring wallpaper: $(basename "$path")"
    set_wallpaper "$path"
}

# Clean thumbnails
clean_thumbnails() {
    if [[ -d "$THUMBNAILS_DIR" ]]; then
        print_msg "$BLUE" "Cleaning thumbnails..."
        rm -rf "$THUMBNAILS_DIR"/*
        print_msg "$GREEN" "Thumbnails cleaned"
    else
        print_msg "$YELLOW" "No thumbnails to clean"
    fi
}

# Show usage
show_usage() {
    echo "Usage: $0 <command> [options]"
    echo
    echo "Commands:"
    echo "  set <file>            Set specific wallpaper"
    echo "  list                  List available wallpapers"
    echo "  select                Interactive wallpaper selection"
    echo "  random                Set random wallpaper"
    echo "  current               Show current wallpaper info"
    echo "  restore               Restore last wallpaper"
    echo "  clean-thumbs          Clean thumbnail cache"
    echo "  help                  Show this help"
    echo
    echo "Examples:"
    echo "  $0 set ~/Pictures/wallpaper.jpg"
    echo "  $0 random"
    echo "  $0 select"
}

# Main function
main() {
    case "${1:-help}" in
        set)
            if [[ -z "$2" ]]; then
                print_msg "$RED" "Please specify wallpaper file"
                exit 1
            fi
            set_wallpaper "$2"
            ;;
        list)
            list_wallpapers
            ;;
        select)
            select_wallpaper
            ;;
        random)
            random_wallpaper
            ;;
        current)
            show_current
            ;;
        restore)
            restore_wallpaper
            ;;
        clean-thumbs)
            clean_thumbnails
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_msg "$RED" "Unknown command: $1"
            echo
            show_usage
            exit 1
            ;;
    esac
}

main "$@"