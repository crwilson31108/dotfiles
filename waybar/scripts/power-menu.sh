#!/usr/bin/env bash

# Power menu using wlogout - HyDE style

# Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Use style 2 (2x2 grid)
confDir="$HOME/.config"
wLayout="${confDir}/wlogout/layout"
wlTmplt="${confDir}/wlogout/style.css"

# Detect monitor resolution
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# Scale for 2x2 grid (style 2) - smaller values = smaller menu
wlColms=2
export x_mgn=$((x_mon * 38 / hypr_scale))  # Decreased to make menu bigger
export y_mgn=$((y_mon * 30 / hypr_scale))  # Decreased to make menu bigger
export x_hvr=$((x_mon * 36 / hypr_scale))
export y_hvr=$((y_mon * 28 / hypr_scale))

# Smaller font size
export fntSize=$((y_mon * 15 / 1000))  # Reduced from 2/100

# Use white icons for dark theme
export BtnCol="white"

# Border radius
hypr_border=10
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

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