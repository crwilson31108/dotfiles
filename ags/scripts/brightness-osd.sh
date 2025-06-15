#!/bin/bash

# Brightness control with OSD feedback
# Usage: brightness-osd.sh [up|down|set VALUE]

BRIGHTNESS_FILE="/sys/class/backlight/*/brightness"
MAX_BRIGHTNESS_FILE="/sys/class/backlight/*/max_brightness"

# Find actual brightness files
BRIGHTNESS_FILE=$(echo $BRIGHTNESS_FILE)
MAX_BRIGHTNESS_FILE=$(echo $MAX_BRIGHTNESS_FILE)

if [[ ! -f "$BRIGHTNESS_FILE" ]] || [[ ! -f "$MAX_BRIGHTNESS_FILE" ]]; then
    echo "Error: Brightness control not available"
    exit 1
fi

# Get current and max brightness
CURRENT=$(cat "$BRIGHTNESS_FILE")
MAX=$(cat "$MAX_BRIGHTNESS_FILE")
STEP=$((MAX / 20))  # 5% steps

case "$1" in
    up)
        NEW=$((CURRENT + STEP))
        if [[ $NEW -gt $MAX ]]; then
            NEW=$MAX
        fi
        echo $NEW | sudo tee "$BRIGHTNESS_FILE" > /dev/null
        ;;
    down)
        NEW=$((CURRENT - STEP))
        if [[ $NEW -lt 1 ]]; then
            NEW=1
        fi
        echo $NEW | sudo tee "$BRIGHTNESS_FILE" > /dev/null
        ;;
    set)
        if [[ -n "$2" ]] && [[ "$2" -ge 1 ]] && [[ "$2" -le 100 ]]; then
            NEW=$((MAX * $2 / 100))
            echo $NEW | sudo tee "$BRIGHTNESS_FILE" > /dev/null
        else
            echo "Usage: $0 set [1-100]"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 [up|down|set VALUE]"
        exit 1
        ;;
esac

# Calculate percentage for OSD
PERCENTAGE=$((NEW * 100 / MAX))

# Trigger OSD via AGS
ags -r "import { showBrightnessOSD } from './widget/OSD.tsx'; showBrightnessOSD($PERCENTAGE);"