#!/bin/bash

# Get audio devices using pactl
get_sinks() {
    pactl list sinks | grep -E 'Sink #|Name:|Description:' | grep -B1 -A1 'Sink #' | sed 's/\s\s*/ /g'
}

get_sources() {
    pactl list sources | grep -E 'Source #|Name:|Description:' | grep -B1 -A1 'Source #' | sed 's/\s\s*/ /g'
}

# Generate Wofi menu items
sink_items=""
source_items=""

# Process sinks
while read -r line; do
    if [[ $line == *"Sink #"* ]]; then
        sink_id=$(echo "$line" | cut -d'#' -f2)
    elif [[ $line == *"Name:"* ]]; then
        sink_name=$(echo "$line" | cut -d':' -f2 | xargs)
    elif [[ $line == *"Description:"* ]]; then
        sink_desc=$(echo "$line" | cut -d':' -f2 | xargs)
        sink_items+="OUTPUT: $sink_desc ($sink_name)\n"
    fi
done < <(get_sinks)

# Process sources
while read -r line; do
    if [[ $line == *"Source #"* ]]; then
        source_id=$(echo "$line" | cut -d'#' -f2)
    elif [[ $line == *"Name:"* ]]; then
        source_name=$(echo "$line" | cut -d':' -f2 | xargs)
    elif [[ $line == *"Description:"* ]]; then
        source_desc=$(echo "$line" | cut -d':' -f2 | xargs)
        source_items+="INPUT: $source_desc ($source_name)\n"
    fi
done < <(get_sources)

# Combine and display menu with wofi
menu_items="$sink_items$source_items"
selection=$(echo -e "$menu_items" | wofi --dmenu --prompt "Select Audio Device" --insensitive --width 600)

if [[ $selection == "OUTPUT: "* ]]; then
    # Extract sink name from selection
    sink_name=$(echo "$selection" | sed -n 's/.*(\(.*\)).*/\1/p')
    if [[ -n "$sink_name" ]]; then
        pactl set-default-sink "$sink_name"
        notify-send "Audio Output" "Changed to: $(echo "$selection" | cut -d':' -f2 | cut -d'(' -f1 | xargs)"
    fi
elif [[ $selection == "INPUT: "* ]]; then
    # Extract source name from selection
    source_name=$(echo "$selection" | sed -n 's/.*(\(.*\)).*/\1/p')
    if [[ -n "$source_name" ]]; then
        pactl set-default-source "$source_name"
        notify-send "Audio Input" "Changed to: $(echo "$selection" | cut -d':' -f2 | cut -d'(' -f1 | xargs)"
    fi
fi

# Update waybar
pkill -SIGRTMIN+9 waybar