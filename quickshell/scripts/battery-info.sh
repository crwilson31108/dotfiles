#!/bin/bash

# Get battery information
BAT_INFO=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 2>/dev/null || upower -i /org/freedesktop/UPower/devices/battery_BAT0 2>/dev/null)

if [ -z "$BAT_INFO" ]; then
    echo -e "\0prompt\x1fBattery Information\n"
    echo "No battery information available"
    exit 0
fi

# Extract key values
vendor=$(echo "$BAT_INFO" | grep -E "^\s*vendor:" | awk -F: '{print $2}' | xargs)
model=$(echo "$BAT_INFO" | grep -E "^\s*model:" | awk -F: '{print $2}' | xargs)
state=$(echo "$BAT_INFO" | grep -E "^\s*state:" | awk -F: '{print $2}' | xargs)
percentage=$(echo "$BAT_INFO" | grep -E "^\s*percentage:" | awk -F: '{print $2}' | xargs)
energy=$(echo "$BAT_INFO" | grep -E "^\s*energy:" | awk -F: '{print $2}' | xargs)
energy_full=$(echo "$BAT_INFO" | grep -E "^\s*energy-full:" | awk -F: '{print $2}' | xargs)
energy_rate=$(echo "$BAT_INFO" | grep -E "^\s*energy-rate:" | awk -F: '{print $2}' | xargs)
voltage=$(echo "$BAT_INFO" | grep -E "^\s*voltage:" | awk -F: '{print $2}' | xargs)
capacity=$(echo "$BAT_INFO" | grep -E "^\s*capacity:" | awk -F: '{print $2}' | xargs)
time_to=$(echo "$BAT_INFO" | grep -E "^\s*time to" | sed 's/^\s*time to //')
technology=$(echo "$BAT_INFO" | grep -E "^\s*technology:" | awk -F: '{print $2}' | xargs)

# Format state with icon
case "$state" in
    "charging")
        state_icon="🔌"
        state_text="Charging"
        ;;
    "discharging")
        state_icon="🔋"
        state_text="Discharging"
        ;;
    "fully-charged")
        state_icon="✅"
        state_text="Fully Charged"
        ;;
    *)
        state_icon="❓"
        state_text="$state"
        ;;
esac

# Set rofi prompt
echo -e "\0prompt\x1fBattery Information"
echo -e "\0message\x1f$vendor $model"

# Display formatted information
echo "$state_icon Status: $state_text"
echo "🔋 Charge: $percentage"
echo "⚡ Energy: $energy / $energy_full"
echo "⚡ Power: $energy_rate"
echo "⚡ Voltage: $voltage"
echo "💯 Health: $capacity"
echo "🔧 Type: $technology"

if [ ! -z "$time_to" ]; then
    if [[ "$time_to" == *"empty"* ]]; then
        echo "⏱️  Time remaining: ${time_to#*:}"
    else
        echo "⏱️  Time to full: ${time_to#*:}"
    fi
fi

# Power profiles section
echo ""
echo "─── Power Profiles ───"
profiles=$(powerprofilesctl list 2>/dev/null)
if [ ! -z "$profiles" ]; then
    current_profile=$(powerprofilesctl get 2>/dev/null)
    
    # Parse and display profiles
    echo "$profiles" | while IFS= read -r line; do
        if [[ "$line" == "* "* ]]; then
            profile_name=$(echo "$line" | sed 's/^\* //' | sed 's/:$//')
            echo "⚡ $profile_name (active)"
        elif [[ "$line" == "  "* ]] && [[ "$line" != "    "* ]]; then
            profile_name=$(echo "$line" | sed 's/^  //' | sed 's/:$//')
            echo "   $profile_name"
        fi
    done
else
    echo "   No power profiles available"
fi