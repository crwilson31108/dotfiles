# Hyprland Setup - Required Packages

This document lists all packages required for my Hyprland configuration. Use this as a reference when setting up a new system or migrating configurations.

## Core Components

### Window Manager & Compositor
- **hyprland** - The main compositor
- **hyprland-protocols** - Protocol implementations
- **xdg-desktop-portal-hyprland** - Desktop portal for Hyprland
- **xdg-desktop-portal-gtk** - GTK desktop portal

### Display & Graphics
- **wayland** - Display server protocol
- **xwayland** - X11 compatibility layer
- **wlroots** - Wayland compositor library

## System Services & Daemons

### Authentication & Polkit
- **polkit-gnome** - Authentication agent (`/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1`)
- **polkit-kde-agent** - Alternative authentication agent

### GTK & Theme Management
- **nwg-look** - GTK settings manager
- **xsettingsd** - X settings daemon
- **gnome-settings-daemon** - For `/usr/lib/gsd-xsettings`
- **gtk-layer-shell** - GTK Layer Shell protocol

## User Interface Components

### Status Bars & Panels
- **waybar** - Status bar (using 2 instances: top and bottom)
- **wob** - Lightweight overlay bar for volume/brightness

### Application Launchers & Menus
- **wofi** - Application launcher and dmenu replacement
- **wlogout** - Logout menu

### Notifications & OSD
- **swaync** - Notification center
- **swayosd** - On-screen display for volume/brightness
- **libnotify** - For `notify-send` command

### Window Management Helpers
- **hyprswitch** - Window switcher (Alt+Tab functionality)
- **eww** - ElKowars wacky widgets

## Terminal & Shell

### Terminal Emulators
- **foot** - Primary terminal emulator
- **alacritty** - Secondary terminal (used for pyprland scratchpads)

## File Management
- **thunar** - File manager
- **nemo** - Alternative file manager (referenced in window rules)

## Multimedia & Graphics

### Wallpaper Management
- **swww** - Wallpaper daemon with animations

### Screenshots
- **hyprshot** - Screenshot utility for Hyprland
- **grim** - Wayland screenshot tool
- **slurp** - Region selection for screenshots
- **swappy** - Screenshot annotation tool

### Media Players & Controls
- **playerctl** - Media player control
- **pavucontrol** - PulseAudio volume control

### Image Viewers
- **imv** - Image viewer

## Input & Internationalization
- **fcitx5** - Input method framework

## Network & System Tools

### Network Management
- **nm-applet** - NetworkManager applet
- **blueman** - Bluetooth manager

### System Monitoring
- **btop** - System monitor (used in pyprland scratchpad)
- **gnome-system-monitor** - Alternative system monitor

### Clipboard Management
- **cliphist** - Clipboard history manager
- **wl-clipboard** - Provides `wl-paste` and `wl-copy`

## Audio
- **pipewire** - Audio server
- **pipewire-pulse** - PulseAudio compatibility
- **wireplumber** - Session manager for PipeWire

## Development & Utilities

### Calculators
- **gnome-calculator** - Calculator application

### Screen Locking
- **hyprlock** - Screen locker for Hyprland

### Idle Management
- **hypridle** - Idle daemon for Hyprland

### Python Tools
- **pyprland** - Python plugin system for Hyprland

### Brightness Control
- **brightnessctl** - Backlight control (if using custom brightness scripts)

## Fonts & Icons

### Fonts
- **cantarell-fonts** - Primary UI font
- **ttf-font-awesome** - Icon font
- **ttf-fira-sans** - Used in various configs

### Icon Themes
- **papirus-icon-theme** - Icon theme (Papirus-Dark)

### Cursor Themes
- **bibata-cursor-theme** - Cursor theme (Bibata-Modern-Classic)

## GTK Themes
- **catppuccin-gtk-theme** - GTK theme

## Web Browsers
- **brave** - Web browser (bound to Super+B)

## Email Clients
- **thunderbird** - Email client (bound to Super+T)

## Additional Plugins & Extensions

### Hyprland Plugins
- **Hyprspace** - Workspace overview plugin (`~/.config/hypr/Hyprspace/Hyprspace.so`)

## Shell Dependencies
- **bash** - Shell scripting
- **coreutils** - Basic utilities (basename, etc.)
- **grep** - Text searching
- **procps-ng** - Process utilities (pgrep)

## Optional But Referenced
- **firefox** - Alternative browser (window rules)
- **librewolf** - Privacy-focused browser (window rules)
- **discord/armcord/webcord** - Discord clients (window rules)
- **steam** - Gaming platform (window rules)
- **evince** - Document viewer (window rules)
- **file-roller** - Archive manager (window rules)

## Installation Commands

### Arch Linux (using yay/paru)
```bash
# Core packages
yay -S hyprland waybar wofi swww hyprlock hypridle hyprshot \
    foot alacritty thunar swaync swayosd wob pyprland \
    cliphist wl-clipboard playerctl pavucontrol btop \
    grim slurp swappy fcitx5 nm-applet blueman \
    polkit-gnome xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    nwg-look xsettingsd gnome-settings-daemon gtk-layer-shell \
    cantarell-fonts ttf-font-awesome ttf-fira-sans \
    papirus-icon-theme bibata-cursor-theme catppuccin-gtk-theme-mocha \
    brave-bin thunderbird gnome-calculator brightnessctl \
    libnotify imv

# Python dependencies for pyprland
pip install --user pyprland

# AUR packages
yay -S hyprswitch eww wlogout
```

### Notes
1. Some packages might have different names depending on your distribution
2. The Hyprspace plugin needs to be built separately
3. Make sure to enable necessary services:
   ```bash
   systemctl --user enable pipewire pipewire-pulse wireplumber
   ```
4. Copy all configuration files from `~/.config/hypr/` to the new system
5. Don't forget to copy waybar configs from `~/.config/waybar/`
6. Theme settings are managed by nwg-look

## Configuration Backup Checklist
- [ ] `~/.config/hypr/` - All Hyprland configs
- [ ] `~/.config/waybar/` - Waybar configs
- [ ] `~/.config/wofi/` - Wofi styles
- [ ] `~/.config/swaync/` - Notification center config
- [ ] `~/.config/swayosd/` - SwayOSD config
- [ ] `~/.config/foot/` - Foot terminal config
- [ ] `~/.config/alacritty/` - Alacritty config
- [ ] `~/Pictures/Wallpapers/` - Wallpaper collection