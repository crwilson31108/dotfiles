#!/bin/bash
# Launch screenshot tools completely detached from quickshell
# Using setsid to create new session and nohup to ignore hangup signals
nohup setsid sh -c 'grim -g "$(slurp)" - | swappy -f -' >/dev/null 2>&1 &

# Exit immediately so quickshell process completes
exit 0