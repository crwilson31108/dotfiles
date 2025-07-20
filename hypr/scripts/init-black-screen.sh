#!/bin/bash
# Initialize with black screen before starting swww
swww-daemon &
sleep 0.1
swww img --no-resize --fill-color 000000 /dev/null