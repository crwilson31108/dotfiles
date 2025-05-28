#!/bin/bash

get_volume() {
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
    echo "$volume"
}

get_mute_status() {
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    echo "$muted"
}

get_default_sink_name() {
    pactl get-default-sink
}

get_default_source_name() {
    pactl get-default-source
}

get_source_mute_status() {
    muted=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
    echo "$muted"
}

volume=$(get_volume)
muted=$(get_mute_status)
mic_muted=$(get_source_mute_status)
sink=$(get_default_sink_name)
source=$(get_default_source_name)

if [[ "$muted" == "yes" ]]; then
    icon="󰝟"
    tooltip="Muted"
elif [ "$volume" -ge 66 ]; then
    icon="󰕾"
    tooltip="Volume: ${volume}%"
elif [ "$volume" -ge 33 ]; then
    icon="󰖀"
    tooltip="Volume: ${volume}%"
else
    icon="󰕿"
    tooltip="Volume: ${volume}%"
fi

if [[ "$mic_muted" == "yes" ]]; then
    tooltip="${tooltip}\nMicrophone: Muted"
else
    tooltip="${tooltip}\nMicrophone: Active"
fi

tooltip="${tooltip}\nSink: ${sink}\nSource: ${source}"

echo "{\"text\": \"${icon}\", \"tooltip\": \"${tooltip}\", \"percentage\": ${volume}, \"class\": \"custom-audio\"}"