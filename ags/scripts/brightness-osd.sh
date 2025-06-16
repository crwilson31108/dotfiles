#!/bin/bash

# Brightness control with OSD feedback
# Usage: brightness-osd.sh [up|down|set VALUE]

case "$1" in
    up)
        brightnessctl set +5%
        ;;
    down)
        brightnessctl set 5%-
        ;;
    set)
        if [[ -n "$2" ]] && [[ "$2" -ge 1 ]] && [[ "$2" -le 100 ]]; then
            brightnessctl set "$2%"
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

# The OSD will automatically show because it's listening to brightness changes