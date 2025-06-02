#!/usr/bin/env bash

# Power profiles menu using fuzzel
profiles="Power Saver\nBalanced\nPerformance"

if command -v powerprofilesctl &> /dev/null; then
    current_profile=$(powerprofilesctl get)
    selected=$(echo -e $profiles | fuzzel --dmenu --prompt "Power Profile")

    case "$selected" in
        "Power Saver")
            if [ "$current_profile" != "power-saver" ]; then
                powerprofilesctl set power-saver
                if [ $? -eq 0 ]; then
                    notify-send "Power Profile" "Set to Power Saver" -i battery
                    pkill -SIGRTMIN+8 waybar
                else
                    notify-send "Power Profile" "Failed to set Power Saver mode" -i dialog-error
                fi
            fi
            ;;
        "Balanced")
            if [ "$current_profile" != "balanced" ]; then
                powerprofilesctl set balanced
                if [ $? -eq 0 ]; then
                    notify-send "Power Profile" "Set to Balanced" -i battery
                    pkill -SIGRTMIN+8 waybar
                else
                    notify-send "Power Profile" "Failed to set Balanced mode" -i dialog-error
                fi
            fi
            ;;
        "Performance")
            if [ "$current_profile" != "performance" ]; then
                powerprofilesctl set performance
                if [ $? -eq 0 ]; then
                    notify-send "Power Profile" "Set to Performance" -i battery
                    pkill -SIGRTMIN+8 waybar
                else
                    notify-send "Power Profile" "Failed to set Performance mode" -i dialog-error
                fi
            fi
            ;;
    esac
else
    # Notify that power-profiles-daemon is not installed
    notify-send "Power Profiles" "power-profiles-daemon is not installed" -i dialog-error
fi