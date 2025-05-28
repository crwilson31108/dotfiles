#!/bin/bash

# Set theme name (you can change this to any installed theme)
THEME_NAME="Catppuccin-Red-Dark-Frappe"

# Apply GTK theme settings
gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 11'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Export GTK_THEME for stubborn applications
export GTK_THEME="${THEME_NAME}:dark"

# Apply Qt theme settings
export QT_QPA_PLATFORMTHEME=qt5ct

# Reload xsettingsd
killall -HUP xsettingsd 2>/dev/null

echo "Theme settings applied: $THEME_NAME"