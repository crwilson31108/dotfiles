#!/bin/bash

# AMD G14 Sleep Mode Optimizer
# Switches to 'deep' suspend mode for better wake reliability

echo "Current suspend mode: $(cat /sys/power/mem_sleep)"

# Check if deep sleep is available
if grep -q "deep" /sys/power/mem_sleep; then
    echo "Setting suspend mode to 'deep' for better AMD G14 wake reliability..."
    echo 'deep' | sudo tee /sys/power/mem_sleep > /dev/null
    echo "New suspend mode: $(cat /sys/power/mem_sleep)"
    
    # Make it persistent across reboots
    if [ ! -f /etc/systemd/sleep.conf.d/10-suspend-mode.conf ]; then
        sudo mkdir -p /etc/systemd/sleep.conf.d/
        echo "[Sleep]" | sudo tee /etc/systemd/sleep.conf.d/10-suspend-mode.conf > /dev/null
        echo "SuspendMode=deep" | sudo tee -a /etc/systemd/sleep.conf.d/10-suspend-mode.conf > /dev/null
        echo "Created persistent sleep configuration"
    fi
else
    echo "Deep sleep mode not available on this system"
fi