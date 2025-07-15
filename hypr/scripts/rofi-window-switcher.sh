#!/bin/bash
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃              Enhanced Rofi Window Switcher                  ┃
# ┃                 GNOME-style with previews                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Launch rofi in window mode with enhanced settings
rofi -show window \
    -theme-str 'window {width: 60%;}' \
    -theme-str 'listview {lines: 10;}' \
    -theme-str 'element {padding: 16px;}' \
    -theme-str 'element-icon {size: 32px;}' \
    -window-format "{w} · {c} · {t}" \
    -filter "" \
    -kb-accept-alt "Shift+Return" \
    -kb-cancel "Escape,Super+w"