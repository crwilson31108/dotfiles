#!/usr/bin/env bash

# Power menu using wlogout - HyDE style

# Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Use 2x2 grid layout
confDir="$HOME/.config"
wLayout="${confDir}/wlogout/layout"
wlTmplt="${confDir}/wlogout/style.css"

# Detect monitor resolution
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# Scale for 2x2 grid - clean centered layout
wlColms=2
export x_mgn=$((x_mon * 25 / hypr_scale))   # Base margin from edges
export y_mgn=$((y_mon * 25 / hypr_scale))   # Base margin from top/bottom
export x_hvr=$((x_mon * 23 / hypr_scale))   # Hover margin (slightly smaller)
export y_hvr=$((y_mon * 23 / hypr_scale))   # Hover margin (slightly smaller)

# Clean font size
export fntSize=$((y_mon * 25 / 1000))

# Use white icons for dark theme
export BtnCol="white"

# Clean border radius values
export active_rad=25     # Hover border radius
export button_rad=15     # Base button border radius

# Create waybar theme file if it doesn't exist (for the CSS import)
mkdir -p ~/.config/waybar
if [ ! -f ~/.config/waybar/theme.css ]; then
    cat > ~/.config/waybar/theme.css << 'EOF'
/* Catppuccin Frappé theme colors */
@define-color main-bg rgba(65, 69, 89, 0.95);
@define-color main-fg #c6d0f5;
@define-color wb-act-bg rgba(140, 170, 238, 0.5);
@define-color wb-hvr-bg rgba(140, 170, 238, 0.7);

/* Animation */
@keyframes gradient_f {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}
EOF
fi

# Process the CSS template
wlStyle="$(envsubst <"${wlTmplt}")"

# Launch wlogout with enhanced blur effect
hyprctl keyword layerrule "blur,logout_dialog"
hyprctl keyword layerrule "ignorezero,logout_dialog"
hyprctl keyword layerrule "animation fadeIn,logout_dialog"
hyprctl keyword layerrule "dimaround,logout_dialog"

wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell