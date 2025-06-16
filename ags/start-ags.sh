#!/bin/bash

# Kill any existing AGS instances
ags quit --all 2>/dev/null || true
sleep 1

# Start the main bar
cd ~/.config/ags
ags run app.tsx &

# Wait a bit for the main instance to start
sleep 2

# Start the OSD instance
ags run osd-app.tsx &

echo "AGS started successfully"