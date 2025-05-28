#!/usr/bin/env bash

# Network manager menu using wofi
nmcli -t device wifi rescan

# Get list of available wifi networks
networks=$(nmcli --fields SSID,BARS,SECURITY device wifi list | tail -n +2 | sed 's/^ *//' | grep -v '^--' | sort -r)

# Use wofi for network selection
selected_network=$(echo "$networks" | wofi --dmenu --insensitive --width 400 \
    --cache-file /dev/null \
    --prompt "Wi-Fi Networks" \
    --style ~/.config/wofi/network.css \
    | awk '{print $1}')

# Exit if no network was selected
[ -z "$selected_network" ] && exit 0

# Check if the network is already known
if nmcli -t -f NAME connection show | grep -q "^$selected_network:"; then
    # Connect to the known network
    nmcli connection up "$selected_network"
else
    # Connect to a new network
    password=$(echo "" | wofi --dmenu --insensitive --width 300 \
        --prompt "Password for $selected_network" \
        --style ~/.config/wofi/password.css \
        --password)
    
    # Exit if no password was entered
    [ -z "$password" ] && exit 0
    
    # Connect to the network with the provided password
    nmcli device wifi connect "$selected_network" password "$password"
fi