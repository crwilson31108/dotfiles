# Hyprland Configuration Overview

## Current Setup
- **Window Manager**: Hyprland with various plugins
- **Status Bar**: Waybar (top and bottom configs available)
- **Application Launcher**: Wofi
- **Notifications**: SwayNC
- **Terminal**: Foot
- **Lock Screen**: Hyprlock
- **Idle Manager**: Hypridle
- **Wallpaper**: swww (via wallpaper-switcher.sh script)

## Key Bindings
- **Mod Key**: SUPER (Windows key)
- **Common shortcuts** defined in hyprland.conf

## Directory Structure
```
~/.config/hypr/
├── hyprland.conf           # Main config file
├── config/                 # Modular configuration files
│   ├── animations.conf     # Animation settings
│   ├── autostart.conf      # Startup applications
│   ├── decorations.conf    # Window decorations
│   ├── environment.conf    # Environment variables
│   ├── input.conf          # Input device settings
│   ├── monitor.conf        # Display configuration
│   ├── windowrules.conf    # Window-specific rules
│   └── workspace-rules.conf # Workspace settings
├── scripts/                # Helper scripts
│   ├── gaming-mode.sh      # Toggle gaming optimizations
│   ├── screenshot*         # Screenshot utilities
│   └── wallpaper-switcher.sh # Wallpaper management
├── gaming.conf             # Gaming-specific settings
├── monitors.conf           # Monitor-specific overrides
└── pyprland.toml          # Pyprland plugin config
```

## Features Configured
- [x] Fractional scaling toggle script
- [x] Gaming mode with optimizations
- [x] Screenshot tools (full, area, window)
- [x] Clipboard manager integration
- [x] Power profile switching
- [x] Workspace cycling
- [x] Audio control scripts
- [x] Network menu
- [x] Theme application (Catppuccin)

## TODO / Improvements
- [ ] Configure specific keybindings documentation
- [ ] Set up workspace persistence rules
- [ ] Fine-tune animation curves
- [ ] Configure multi-monitor layouts
- [ ] Set up window swallowing rules
- [ ] Configure touch gestures (if applicable)
- [ ] Optimize blur settings for performance
- [ ] Set up scratchpad windows
- [ ] Configure picture-in-picture rules
- [ ] Add custom shader effects

## Gaming Mode Features
- Disables animations
- Adjusts compositor settings
- Optimizes for performance
- Can be toggled via script

## Theming
- Currently using Catppuccin theme
- GTK theme configured via environment.d
- Waybar styled to match

## Scripts Available
- `apply-theme.sh` - Apply system-wide theme
- `gaming-mode.sh` - Toggle gaming optimizations
- `screenshot` - Take screenshots
- `wallpaper-switcher.sh` - Change wallpapers
- `workspace-cycle.sh` - Cycle through workspaces
- `toggle-fractional.sh` - Toggle fractional scaling

## Environment Variables
Set in `config/environment.conf`:
- GTK/QT theming variables
- Wayland-specific settings
- Application defaults

## Notes
- Hypridle configured for power saving
- Multiple Waybar configs available (standard and bottom bar)
- Wofi configured with custom styling
- Power menu integration via wlogout