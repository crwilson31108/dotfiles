#!/bin/bash

# Hyprland Autostart Script

# Start authentication agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Start notification daemon
mako &

# Start OSD server
swayosd-server &

# Start wallpaper daemon
swww-daemon &

# Set wallpaper (you can change this path)
# swww img ~/Pictures/wallpaper.jpg --transition-type fade --transition-duration 2 &

# Start clipboard manager
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Start Quickshell
quickshell -c ~/.config/quickshell &

# Start network manager applet
nm-applet --indicator &

# Start bluetooth applet
blueman-applet &

# Start idle daemon
hypridle &

# Configure GTK theme
gsettings set org.gnome.desktop.interface gtk-theme "rose-pine"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"

# Create screenshots directory
mkdir -p ~/Pictures/Screenshots

# Start any user services
if [ -f ~/.config/hypr/user-autostart.sh ]; then
    ~/.config/hypr/user-autostart.sh &
fi