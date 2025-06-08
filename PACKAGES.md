# Hyprland Dotfiles - Package Installation Guide

This guide provides a complete list of all packages required to replicate this Hyprland setup on Arch Linux.

## Prerequisites

Install `yay` for AUR packages:
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Installation Steps

### Step 1: Install Core Packages from Official Repositories

```bash
sudo pacman -S \
  hyprland \
  xdg-desktop-portal-hyprland \
  hyprlock \
  alacritty \
  fish \
  thunar \
  chromium \
  pavucontrol \
  blueman \
  gnome-calculator \
  network-manager-applet \
  grim \
  slurp \
  swappy \
  wl-clipboard \
  brightnessctl \
  playerctl \
  libpulse \
  alsa-utils \
  jq \
  gettext \
  procps-ng \
  systemd \
  libnotify \
  dbus \
  neovim \
  git \
  bash \
  grep \
  findutils \
  sed \
  gawk \
  waybar \
  rofi-wayland \
  mako \
  wlogout \
  fcitx5 \
  polkit-kde-agent \
  qt5ct \
  qt6ct \
  kvantum \
  papirus-icon-theme \
  ttf-jetbrains-mono-nerd \
  nwg-look \
  nwg-displays \
  xsettingsd \
  wayland \
  wayland-protocols \
  cairo \
  pango \
  gdk-pixbuf2 \
  gtk3 \
  gtk4 \
  polkit \
  pipewire \
  pipewire-pulse \
  wireplumber \
  xdg-utils \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk \
  fastfetch \
  imagemagick \
  zenity
```

### Step 2: Install AUR Packages

```bash
yay -S \
  hyprland-plugins \
  grimblast \
  wob \
  power-profiles-daemon \
  swww \
  catppuccin-gtk-theme-mocha \
  bibata-cursor-theme
```

## Package Categories

### Core Hyprland Components
- **hyprland** - The Wayland compositor
- **xdg-desktop-portal-hyprland** - Screen sharing and desktop integration
- **hyprlock** - Screen locker
- **hyprland-plugins** (AUR) - Additional functionality plugins

### Terminal & Shell
- **alacritty** - GPU-accelerated terminal emulator
- **fish** - Friendly interactive shell

### Applications
- **thunar** - File manager
- **chromium** - Web browser
- **pavucontrol** - PulseAudio volume control
- **blueman** - Bluetooth manager
- **gnome-calculator** - Calculator app
- **network-manager-applet** - Network management tray icon

### Window Management Tools
- **rofi-wayland** - Application launcher
- **mako** - Notification daemon
- **wlogout** - Logout screen
- **swaync** (AUR) - Notification center
- **swayidle** (AUR) - Idle management

### System Utilities
- **grim** - Screenshot tool
- **slurp** - Selection tool for screenshots
- **swappy** - Screenshot annotation
- **grimblast** (AUR) - Enhanced screenshot utility
- **wl-clipboard** - Clipboard utilities
- **cliphist** - Clipboard manager
- **brightnessctl** - Backlight control
- **playerctl** - Media player control
- **wob** (AUR) - Overlay bar for volume/brightness
- **power-profiles-daemon** (AUR) - Power management

### Theming & Appearance
- **qt5ct** & **qt6ct** - Qt theming tools
- **kvantum** - Qt theme engine
- **papirus-icon-theme** - Icon theme
- **ttf-jetbrains-mono-nerd** - Programming font with icons
- **catppuccin-gtk-theme-mocha** (AUR) - GTK theme
- **bibata-cursor-theme** (AUR) - Cursor theme
- **nwg-look** - GTK theme switcher
- **nwg-displays** - Display configuration
- **xsettingsd** - X settings daemon for GTK
- **swww** (AUR) - Wallpaper daemon

### Development Tools
- **neovim** - Text editor
- **git** - Version control
- Various shell utilities (bash, grep, sed, awk, etc.)

### Audio & Video
- **pipewire** - Modern audio/video server
- **pipewire-pulse** - PulseAudio compatibility
- **wireplumber** - PipeWire session manager
- **libpulse** - PulseAudio libraries
- **alsa-utils** - ALSA utilities

### Dependencies
- Wayland libraries and protocols
- GTK3/GTK4 toolkits
- Various system libraries (cairo, pango, etc.)
- Desktop integration portals

## Post-Installation

1. Clone this dotfiles repository:
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

2. Copy configuration files to their locations:
```bash
cp -r hypr ~/.config/
cp -r waybar ~/.config/
cp -r alacritty ~/.config/
cp -r fish ~/.config/
cp -r rofi ~/.config/
cp -r mako ~/.config/
cp -r wlogout ~/.config/
cp -r nvim ~/.config/
cp -r qt5ct ~/.config/
cp -r qt6ct ~/.config/
cp -r Kvantum ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r gtk-4.0 ~/.config/
cp -r nwg-displays ~/.config/
cp -r nwg-look ~/.config/
cp -r Thunar ~/.config/
```

3. Enable necessary services:
```bash
systemctl --user enable pipewire pipewire-pulse wireplumber
```

4. Set fish as default shell:
```bash
chsh -s /usr/bin/fish
```

5. Log out and log back in using Hyprland session.

## Notes

- Some packages may have different names depending on your Arch repository
- The `hyprland-plugins` package may need specific plugin names
- Ensure your GPU drivers are properly installed for Wayland support
- You may need to configure some applications after installation