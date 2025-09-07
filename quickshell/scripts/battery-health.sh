#!/bin/bash

# Get battery health information using Linux utilities

BAT_PATH="/sys/class/power_supply/BAT1"
if [ ! -d "$BAT_PATH" ]; then
    BAT_PATH="/sys/class/power_supply/BAT0"
fi

if [ ! -d "$BAT_PATH" ]; then
    echo "No battery found"
    exit 1
fi

# Read battery information
charge_full=$(cat "$BAT_PATH/charge_full" 2>/dev/null || echo "0")
charge_full_design=$(cat "$BAT_PATH/charge_full_design" 2>/dev/null || echo "0")
charge_now=$(cat "$BAT_PATH/charge_now" 2>/dev/null || echo "0")
voltage_now=$(cat "$BAT_PATH/voltage_now" 2>/dev/null || echo "0")
cycle_count=$(cat "$BAT_PATH/cycle_count" 2>/dev/null || echo "N/A")
manufacturer=$(cat "$BAT_PATH/manufacturer" 2>/dev/null || echo "Unknown")
model_name=$(cat "$BAT_PATH/model_name" 2>/dev/null || echo "Unknown")
technology=$(cat "$BAT_PATH/technology" 2>/dev/null || echo "Unknown")

# Calculate battery health (capacity) as percentage of design capacity
if [ "$charge_full_design" -gt 0 ]; then
    health=$((charge_full * 100 / charge_full_design))
else
    health=0
fi

# Calculate current percentage
if [ "$charge_full" -gt 0 ]; then
    percentage=$((charge_now * 100 / charge_full))
else
    percentage=0
fi

# Convert voltage from microvolts to volts
voltage_v=$(echo "scale=2; $voltage_now / 1000000" | bc 2>/dev/null || echo "0.00")

# Output in format that can be easily parsed
echo "HEALTH:$health"
echo "PERCENTAGE:$percentage"
echo "VOLTAGE:$voltage_v"
echo "CYCLES:$cycle_count"
echo "MANUFACTURER:$manufacturer"
echo "MODEL:$model_name"
echo "TECHNOLOGY:$technology"
echo "CHARGE_NOW:$charge_now"
echo "CHARGE_FULL:$charge_full"
echo "CHARGE_DESIGN:$charge_full_design"