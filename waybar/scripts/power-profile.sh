#!/usr/bin/env bash

# Get the current power profile
if command -v powerprofilesctl &> /dev/null; then
    current_profile=$(powerprofilesctl get)
    
    case "$current_profile" in
        "power-saver")
            echo "{\"text\": \"󰌪\", \"tooltip\": \"Power Saver Mode\", \"alt\": \"power-saver\", \"class\": \"power-saver\"}"
            ;;
        "balanced")
            echo "{\"text\": \"󰾆\", \"tooltip\": \"Balanced Mode\", \"alt\": \"balanced\", \"class\": \"balanced\"}"
            ;;
        "performance")
            echo "{\"text\": \"󰓅\", \"tooltip\": \"Performance Mode\", \"alt\": \"performance\", \"class\": \"performance\"}"
            ;;
        *)
            echo "{\"text\": \"󰾆\", \"tooltip\": \"Unknown Mode\", \"alt\": \"unknown\", \"class\": \"unknown\"}"
            ;;
    esac
else
    # If powerprofilesctl is not installed
    echo "{\"text\": \"󰾆\", \"tooltip\": \"power-profiles-daemon not installed\", \"alt\": \"not-installed\", \"class\": \"not-installed\"}"
fi