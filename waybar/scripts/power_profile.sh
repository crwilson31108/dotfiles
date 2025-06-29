#!/bin/bash

# Get current power profile
current_profile=$(powerprofilesctl get 2>/dev/null || echo "balanced")

case "$1" in
    "next")
        case "$current_profile" in
            "power-saver")
                powerprofilesctl set balanced
                ;;
            "balanced")
                powerprofilesctl set performance
                ;;
            "performance")
                powerprofilesctl set power-saver
                ;;
        esac
        ;;
    *)
        # Display current profile
        case "$current_profile" in
            "power-saver")
                echo '{"text": "", "tooltip": "Power Saver", "class": "power-saver"}'
                ;;
            "balanced")
                echo '{"text": "", "tooltip": "Balanced", "class": "balanced"}'
                ;;
            "performance")
                echo '{"text": "", "tooltip": "Performance", "class": "performance"}'
                ;;
            *)
                echo '{"text": "", "tooltip": "Unknown", "class": "unknown"}'
                ;;
        esac
        ;;
esac