# Hyprland Gaming Setup Guide

## Configuration Files Created

1. **gaming.conf** - Core gaming optimizations including:
   - Raw mouse acceleration (libinput flat profile)
   - VRR support enabled
   - Window rules for games (immediate mode, no animations)

2. **gaming-toggle.conf** - Keybinds for:
   - `Super+Shift+G`: Toggle full gaming mode
   - `Super+Alt+A`: Disable animations
   - `Super+Alt+Shift+A`: Enable animations
   - `Super+Alt+F`: Toggle fractional scaling
   - `Super+G`: Launch Steam with gamescope
   - `Super+0`: Switch to gaming workspace

3. **Scripts**:
   - `gaming-mode.sh`: Toggles all performance settings at once
   - `toggle-fractional.sh`: Quick fractional scaling toggle
   - `gaming-launcher`: Universal game launcher with gamemode/gamescope

## Setup Instructions

1. Include the configs in your main hyprland.conf:
   ```
   source = ~/.config/hypr/gaming.conf
   source = ~/.config/hypr/gaming-toggle.conf
   ```

2. Install required packages:
   ```bash
   # Arch/CachyOS
   sudo pacman -S gamemode lib32-gamemode gamescope

   # Ubuntu/Debian
   sudo apt install gamemode gamescope
   ```

3. Add your user to gamemode group:
   ```bash
   sudo usermod -aG gamemode $USER
   ```

## Usage Examples

- **Quick gaming mode**: Press `Super+Shift+G` to toggle
- **Launch Steam optimized**: `gaming-launcher -r 1920x1080 -f --fps 144 steam`
- **Launch any game**: `gaming-launcher lutris`

## VRR Notes

VRR is enabled in the config. Make sure:
- Your monitor supports VRR/FreeSync/G-Sync
- You're using DisplayPort (HDMI VRR support varies)
- Check with: `hyprctl monitors` to see if VRR is active