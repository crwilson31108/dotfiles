# 🚀 Hyprland Dotfiles

A complete Hyprland setup with Quickshell widgets, foot terminal, fish shell with Starship prompt, and Rose Pine theming throughout. Inspired by end-4's aesthetic with custom optimizations.

## ✨ Features

- **Hyprland** window manager with optimized configuration
- **Quickshell** modern desktop widgets and panels
- **Fish shell** with **Starship** prompt (Rose Pine theme)
- **Rose Pine** color scheme throughout the system
- **Automated silent installation** - no user prompts required
- **Comprehensive backup system** for existing configurations
- **One-command setup** with sane defaults

## 🔧 Quick Installation (Recommended)

```bash
git clone https://github.com/crwilson31108/dotfiles.git
cd dotfiles
./install.sh
```

That's it! The script will:
- **Automatically resolve package conflicts** (VS Code, Discord, etc.)
- Install all required packages automatically
- Backup your existing configurations
- Deploy the dotfiles with optimized settings
- Set up services and permissions
- Configure shell with Starship prompt
- **Auto-configure display manager** for seamless login
- **Download sample wallpapers** and create keybind reference
- **Apply hardware-specific optimizations** (NVIDIA/AMD)

After installation, simply **reboot** and select **Hyprland** at your login screen.

## 📋 Manual Installation Steps

### Step 1: Install Core Packages from Official Repositories

```bash
sudo pacman -S \
  hyprland \
  xdg-desktop-portal-hyprland \
  hyprlock \
  foot \
  fish \
  thunar \
  thunar-volman \
  tumbler \
  flatpak \
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
  inter-font \
  ttf-roboto \
  ttf-fira-code \
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
  zenity \
  gvfs \
  gvfs-mtp \
  gvfs-gphoto2 \
  gvfs-afc \
  udisks2 \
  upower \
  inotify-tools \
  cups \
  cups-filters \
  cups-pdf \
  system-config-printer
```

### Step 2: Install AUR Packages

```bash
yay -S \
  hyprland-git \
  hyprland-plugins \
  hypridle \
  hyprpicker \
  hyprsunset \
  quickshell \
  cliphist \
  grimblast \
  wob \
  power-profiles-daemon \
  swww \
  catppuccin-gtk-theme-mocha \
  bibata-cursor-theme \
  sddm
```

## Step 3: Papirus Icon Theme
```bash
sudo pacman -S papirus-icon-theme
yay -S papirus-folders
papirus-folders -C red --theme Papirus
papirus-folders -C red --theme Papirus-Dark
```


## Package Categories

### Core Hyprland Components
- **hyprland** - The Wayland compositor
- **xdg-desktop-portal-hyprland** - Screen sharing and desktop integration
- **hyprlock** - Screen locker
- **hyprland-plugins** (AUR) - Additional functionality plugins
- **hypridle** (AUR) - Idle management daemon
- **hyprpicker** (AUR) - Color picker tool
- **hyprsunset** (AUR) - Blue light filter
- **Custom Workspace Manager** - Built-in workspace overview with drag and drop

### Terminal & Shell
- **foot** - Lightweight Wayland terminal emulator
- **fish** - Friendly interactive shell

### Applications
- **thunar** - File manager
- **thunar-volman** - Volume management for thunar
- **tumbler** - Thumbnail service
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
- **cliphist** (AUR) - Clipboard manager with history
- **brightnessctl** - Backlight control
- **playerctl** - Media player control
- **wob** (AUR) - Overlay bar for volume/brightness
- **power-profiles-daemon** (AUR) - Power management
- **inotify-tools** - File system monitoring
- **udisks2** - Disk management
- **upower** - Power management

### File System & Storage
- **gvfs** - Virtual file system
- **gvfs-mtp** - MTP device support (Android phones)
- **gvfs-gphoto2** - Digital camera support
- **gvfs-afc** - Apple device support (iPhone/iPad)

### Printing Support
- **cups** - Print system
- **cups-filters** - Print filters
- **cups-pdf** - PDF printing
- **system-config-printer** - Printer configuration GUI

### Login Manager
- **sddm** - Simple Desktop Display Manager

### Theming & Appearance
- **qt5ct** & **qt6ct** - Qt theming tools
- **kvantum** - Qt theme engine
- **papirus-icon-theme** - Icon theme
- **ttf-jetbrains-mono-nerd** - Programming font with icons
- **inter-font** - High-quality UI font optimized for screens
- **ttf-roboto** - Google's modern UI font
- **ttf-fira-code** - Programming font with ligatures
- **catppuccin-gtk-theme-mocha** (AUR) - GTK theme
- **bibata-cursor-theme** (AUR) - Cursor theme
- **nwg-look** - GTK theme switcher
- **nwg-displays** - Display configuration
- **xsettingsd** - X settings daemon for GTK
- **swww** (AUR) - Wallpaper daemon

### Quickshell Components
- **quickshell** (AUR) - Modern Wayland shell with rich widgets and panels
- **hypridle** (AUR) - Idle management for stay awake functionality
- **hyprpicker** (AUR) - Color picker integration
- **hyprsunset** (AUR) - Blue light filter control
- **cliphist** (AUR) - Clipboard history management
- **zenity** - Native file picker dialogs
- **rofi-wayland** - Application launcher and clipboard interface
- **inotify-tools** - File system monitoring for app list updates

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

## Kernel Parameters for AMD Ryzen AI 370

For optimal performance and to suppress ACPI errors on AMD Ryzen AI 9 HX 370 systems, add these kernel parameters to your bootloader:

### Systemd-boot Configuration

Edit `/boot/loader/entries/linux-cachyos.conf` (or your kernel's entry file):

```
title Linux Cachyos
options root=UUID=YOUR-ROOT-UUID rw zswap.enabled=0 nowatchdog splash quiet loglevel=3 amd_pstate=active iommu=pt amd_iommu=on acpi_osi="Linux"
linux /vmlinuz-linux-cachyos
initrd /initramfs-linux-cachyos.img
```

### Parameter Explanations

- `quiet loglevel=3` - Suppresses non-critical boot messages including ACPI errors
- `amd_pstate=active` - Enables active AMD P-State driver for better power management on Zen 5
- `iommu=pt` - IOMMU passthrough mode for better performance
- `amd_iommu=on` - Enables AMD IOMMU support
- `acpi_osi="Linux"` - Better ACPI compatibility for modern hardware

These parameters are specifically optimized for the AMD Ryzen AI 370 (Zen 5) architecture and will improve sleep/standby functionality.

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
cp -r foot ~/.config/
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
cp -r fontconfig ~/.config/
cp -r nwg-displays ~/.config/
cp -r nwg-look ~/.config/
cp -r Thunar ~/.config/
cp -r quickshell ~/.config/
# Copy GTK 2.0 files
cp gtk-2.0/gtkrc ~/.gtkrc-2.0
cp gtk-2.0/gtkrc.mine ~/.gtkrc-2.0.mine
```

3. Copy SDDM configuration if it exists:
```bash
# Backup SDDM config to dotfiles
if [ -f /etc/sddm.conf ]; then
    sudo cp /etc/sddm.conf ~/Documents/Github/dotfiles/sddm.conf
fi
```

4. Enable necessary services:
```bash
systemctl --user enable pipewire pipewire-pulse wireplumber
sudo systemctl enable --now upower
sudo systemctl enable --now cups
sudo systemctl enable sddm  # Enable SDDM display manager
```

5. Set fish as default shell:
```bash
chsh -s /usr/bin/fish
```

6. Rebuild the font cache:
```bash
fc-cache -fv
```

7. Set Chromium as the default browser for all applications:
```bash
# Set Chromium as the default handler for HTTP/HTTPS URLs
xdg-mime default chromium.desktop x-scheme-handler/http
xdg-mime default chromium.desktop x-scheme-handler/https
xdg-mime default chromium.desktop text/html
```

8. Log out and log back in using Hyprland session.

## Font Configuration

This setup includes optimized font rendering for high-DPI displays with:

### Font Choices
- **UI Font**: Inter - Modern, highly legible font optimized for screens
- **Monospace Font**: JetBrains Mono - Programming font with excellent readability
- **Fallback Fonts**: Roboto, Fira Code, Noto fonts

### Rendering Optimizations
- **Antialiasing**: Enabled with slight hinting for high-DPI displays
- **Subpixel Rendering**: RGB layout for LCD screens
- **OpenType Features**: Kerning and ligatures enabled
- **Cross-toolkit Consistency**: Unified font configuration across Qt5, Qt6, GTK3, GTK4, and GTK2

### Configuration Files
- `~/.config/fontconfig/` - Font rendering configuration
- `~/.config/gtk-3.0/settings.ini` - GTK3 font settings
- `~/.config/gtk-4.0/settings.ini` - GTK4 font settings
- `~/.config/gtk-4.0/gtk.css` - GTK4 custom CSS with font optimizations
- `~/.gtkrc-2.0.mine` - GTK2 custom font settings
- `~/.config/qt5ct/qt5ct.conf` - Qt5 font configuration
- `~/.config/qt6ct/qt6ct.conf` - Qt6 font configuration

The configuration ensures consistent, crisp font rendering across all applications.

## Login Manager Setup

### SDDM Configuration (Recommended)

1. Install and enable SDDM:
```bash
sudo pacman -S sddm
sudo systemctl enable sddm
```

2. Configure SDDM autologin (optional):
Create or edit `/etc/sddm.conf`:
```ini
[Autologin]
User=yourusername
Session=hyprland
```

To disable autologin later, comment out these lines with `#`.

3. Copy SDDM configuration to dotfiles for backup:
```bash
sudo cp /etc/sddm.conf ~/Documents/Github/dotfiles/sddm.conf
```


## Key Bindings

### Application Shortcuts
- `Super + Return` - Open terminal (foot)
- `Super + Space` - Application launcher (quickshell)
- `Super + A` - Application overview (quickshell)
- `Super + E` - File manager (thunar)
- `Super + B` - Browser (Firefox)
- `Super + T` - Email client (Thunderbird)
- `Super + P` - Power menu (quickshell session)
- `Super + Shift + P` - Calculator
- `Super + Shift + E` - Emoji picker (rofimoji)

### Window Management
- `Super + Q` - Close window
- `Super + F` - Toggle fullscreen
- `Super + V` - Toggle floating/tiling
- `Super + Y` - Pin window (show on all workspaces)
- `Super + J` - Toggle split mode
- `Super + L` - Lock screen
- `Alt + Tab` - Window switcher (quickshell)

### Workspace Management
- `Super + 1-4` - Switch to workspace 1-4
- `Super + Ctrl + 1-4` - Move window to workspace and follow
- `Super + Shift + 1-4` - Move window to workspace silently
- `Super + Tab` - Workspace manager overview
- `Super + Equal` - Toggle special workspace

### System Controls
- `Super + W` - Random wallpaper
- `Super + N` - Toggle blue light filter
- `Super + Shift + N` - Clear notifications
- `Super + G` - Remove gaps
- `Super + Shift + G` - Restore default gaps
- `Super + Escape` - Dismiss quickshell popouts

### Media Keys
- `XF86AudioRaiseVolume/LowerVolume` - Volume control
- `XF86AudioMute` - Mute toggle
- `XF86AudioPlay/Next/Previous` - Media playback
- `XF86MonBrightnessUp/Down` - Brightness control

## 🔧 Troubleshooting

### Check for Package Conflicts
```bash
./check-conflicts.sh
```
This script identifies common package conflicts (VS Code, Discord, Firefox variants) and orphaned packages.

### Common Issues

**Installation fails with package conflicts:**
- Run `./check-conflicts.sh` to identify conflicts
- The install script automatically resolves most conflicts
- Manually remove conflicting packages: `yay -R package-name`

**Hyprland doesn't appear at login screen:**
- Verify SDDM is running: `systemctl status sddm`
- Check session file exists: `ls /usr/share/wayland-sessions/hyprland.desktop`
- Try different display manager: `sudo systemctl disable sddm && sudo systemctl enable gdm`

**Applications don't launch:**
- Check if XDG portals are working: `systemctl --user status xdg-desktop-portal-hyprland`
- Verify environment variables in `~/.config/hypr/hyprland.conf`

**Poor performance:**
- NVIDIA users: Install `nvidia-dkms` and reboot
- AMD users: Enable early KMS in `/etc/mkinitcpio.conf`
- Check hardware optimizations were applied: `ls ~/.config/hypr/nvidia.conf` or `ls ~/.config/hypr/amd.conf`

### Recovery Options

**Restore previous configuration:**
```bash
./uninstall.sh
```

**Clean installation (removes all configs):**
```bash
rm -rf ~/.config/hypr ~/.config/quickshell ~/.config/foot
./install.sh
```

**Update configurations:**
```bash
./sync_configs.sh
```

## Notes

- Package conflicts are automatically resolved during installation
- Hardware-specific optimizations are applied automatically
- Sample wallpapers and keybind reference are created on Desktop
- All original configurations are backed up with timestamps