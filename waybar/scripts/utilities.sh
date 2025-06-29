#!/bin/bash

# Utilities menu for waybar
options="📋 Clipboard History\n😀 Emoji Picker\n🎨 Color Picker\n📸 Screenshot\n📁 File Manager\n⚙️ Settings"

choice=$(echo -e "$options" | wofi --dmenu --prompt="Utilities")

case "$choice" in
    "📋 Clipboard History")
        cliphist list | wofi -dmenu | cliphist decode | wl-copy
        ;;
    "😀 Emoji Picker")
        rofimoji
        ;;
    "🎨 Color Picker")
        hyprpicker -a
        ;;
    "📸 Screenshot")
        grim -g "$(slurp)"
        ;;
    "📁 File Manager")
        thunar
        ;;
    "⚙️ Settings")
        gnome-control-center
        ;;
esac