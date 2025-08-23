#!/bin/bash

# Get WiFi networks (without rescan for speed)
wifi_list=$(nmcli device wifi list 2>/dev/null)

if [ -z "$wifi_list" ]; then
    echo "No WiFi networks found"
    exit 0
fi

# Get current connection
current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

# Parse and display networks
echo "$wifi_list" | tail -n +2 | while IFS= read -r line; do
    # Extract SSID and signal using fixed-width parsing
    ssid=$(echo "$line" | cut -c27-56 | xargs)
    signal=$(echo "$line" | awk '{print $8}')
    security=$(echo "$line" | awk '{for(i=10;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/ $//')
    
    # Skip hidden networks
    if [ "$ssid" = "--" ] || [ -z "$ssid" ]; then
        continue
    fi
    
    # Mark current connection
    if [ "$ssid" = "$current_ssid" ]; then
        echo "✅ $ssid (Connected)"
    else
        # Show security status
        if [[ "$security" == *"WPA"* ]]; then
            echo "🔒 $ssid"
        else
            echo "🔓 $ssid"
        fi
    fi
done

# Add options
echo "---"
echo "🔄 Refresh Networks"
echo "⚙️ Network Settings"