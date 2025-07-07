#!/bin/bash

# Function to show networks
show_networks() {
    /home/caseyw/.config/quickshell/scripts/wifi-selector.sh
}

# Function to handle selection
handle_selection() {
    selection="$1"
    
    if [[ "$selection" == *"Open Network Settings"* ]]; then
        nm-connection-editor &
        exit 0
    elif [[ "$selection" == *"Refresh Networks"* ]]; then
        exec "$0"
    elif [[ "$selection" == *"Disconnect from"* ]]; then
        # Extract current connection name
        current_connection=$(nmcli connection show --active | grep wifi | awk '{print $1}')
        if [ ! -z "$current_connection" ]; then
            nmcli connection down "$current_connection"
            notify-send "WiFi" "Disconnected from network"
        fi
        exit 0
    elif [[ "$selection" == *"Connected)"* ]]; then
        # Already connected, do nothing or show info
        exit 0
    elif [ ! -z "$selection" ] && [[ "$selection" != "" ]]; then
        # Extract SSID from selection
        ssid=$(echo "$selection" | sed 's/^[✅🔓🔒🔐📶 ]*//' | sed 's/ [🔓🔒🔐] [0-9]*%$//' | sed 's/ (Connected)$//')
        
        if [ ! -z "$ssid" ]; then
            # Try to connect
            # First check if we have a saved connection
            if nmcli connection show | grep -q "$ssid"; then
                nmcli connection up "$ssid"
                if [ $? -eq 0 ]; then
                    notify-send "WiFi" "Connected to $ssid"
                else
                    notify-send "WiFi" "Failed to connect to $ssid"
                fi
            else
                # Need password, launch nm-connection-editor for this network
                nm-connection-editor &
                notify-send "WiFi" "Opening network editor for $ssid"
            fi
        fi
    fi
}

# If called with selection, handle it
if [ $# -gt 0 ]; then
    handle_selection "$*"
else
    # Show networks
    show_networks
fi