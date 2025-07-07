#!/bin/bash

# Get WiFi networks
wifi_list=$(nmcli device wifi list --rescan yes 2>/dev/null)

if [ -z "$wifi_list" ]; then
    echo -e "\0prompt\x1fWiFi Networks"
    echo -e "\0message\x1fNo WiFi adapter found"
    echo "📶 No WiFi networks available"
    exit 0
fi

# Check if we're connected to WiFi
current_connection=$(nmcli connection show --active | grep wifi | awk '{print $1}')
current_ssid=$(nmcli device wifi show-password 2>/dev/null | grep SSID | awk '{print $2}')

# Set rofi prompt
echo -e "\0prompt\x1fWiFi Networks"
if [ ! -z "$current_ssid" ]; then
    echo -e "\0message\x1fConnected to: $current_ssid"
else
    echo -e "\0message\x1fSelect a network to connect"
fi

# Parse WiFi networks and format for rofi
echo "$wifi_list" | tail -n +2 | while IFS= read -r line; do
    # Extract fixed-width fields
    in_use=$(echo "$line" | cut -c1-8 | xargs)
    bssid=$(echo "$line" | cut -c9-26 | xargs)
    ssid=$(echo "$line" | cut -c27-56 | xargs)
    mode=$(echo "$line" | cut -c57-62 | xargs)
    signal=$(echo "$line" | awk '{print $8}')
    security=$(echo "$line" | awk '{for(i=10;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/ $//')
    
    # Skip hidden networks (empty SSID or --)
    if [ "$ssid" = "--" ] || [ -z "$ssid" ]; then
        continue
    fi
    
    # Set icon based on signal strength (extract number)
    if [[ "$signal" =~ ^[0-9]+$ ]]; then
        signal_num="$signal"
    else
        signal_num=50  # Default if can't parse
    fi
    
    if [ "$signal_num" -ge 75 ]; then
        icon="📶"
    elif [ "$signal_num" -ge 50 ]; then
        icon="📶"
    elif [ "$signal_num" -ge 25 ]; then
        icon="📶"
    else
        icon="📶"
    fi
    
    # Set security icon
    if [[ "$security" == *"WPA"* ]]; then
        sec_icon="🔒"
    elif [[ "$security" == *"WEP"* ]]; then
        sec_icon="🔐"
    else
        sec_icon="🔓"
    fi
    
    # Mark current connection
    if [ "$in_use" = "*" ]; then
        status="✅ "
        ssid_display="$ssid (Connected)"
    else
        status=""
        ssid_display="$ssid"
    fi
    
    # Format output for rofi
    echo "${status}${icon} ${ssid_display} ${sec_icon} ${signal_num}%"
done

# Add management options
echo ""
echo "⚙️  Open Network Settings"
echo "🔄 Refresh Networks"
if [ ! -z "$current_ssid" ]; then
    echo "❌ Disconnect from $current_ssid"
fi