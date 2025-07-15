source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # Empty to disable fastfetch
end
set -gx QT_QPA_PLATFORMTHEME qt6ct
set -gx QT_STYLE_OVERRIDE kvantum
set -gx BROWSER chromium

# Initialize Starship prompt
starship init fish | source
