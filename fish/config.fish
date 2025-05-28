source /usr/share/cachyos-fish-config/cachyos-config.fish

# Add local bin to PATH
set -gx PATH $HOME/.local/bin $PATH

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Enable Wayland support for Firefox-based browsers
set -gx MOZ_ENABLE_WAYLAND 1

# Chromium/Electron smooth scrolling flags
set -gx CHROMIUM_FLAGS "--enable-smooth-scrolling --ozone-platform-hint=auto"

# Enable kinetic scrolling for GTK applications
set -gx GTK_KINETIC_SCROLLING 1
set -gx GDK_CORE_DEVICE_EVENTS 1

# Qt kinetic scrolling
set -gx QT_QUICK_FLICKABLE_WHEEL_DECELERATION 2000

# Qt theme
set -gx QT_STYLE_OVERRIDE kvantum
