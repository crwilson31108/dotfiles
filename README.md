# Hyprland Dotfiles

A complete Hyprland setup with quickshell, foot terminal, and Firefox.

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
  grimblast \
  wob \
  power-profiles-daemon \
  swww \
  catppuccin-gtk-theme-mocha \
  bibata-cursor-theme \
  greetd \
  greetd-regreet
```

## Step 3: Papirus Icon Theme
```bash
sudo pacman -S papirus-icon-theme
yay -S papirus-folders
papirus-folders -C red --theme Papirus
papirus-folders -C red --theme Papirus-Dark
```

## Step 4: HyprPM (Hyprland Plugin Manager)
```bash
hyprpm update
hyprpm add https://github.com/KZDKM/Hyprspace
hyprpm enable Hyprspace
```

## Package Categories

### Core Hyprland Components
- **hyprland** - The Wayland compositor
- **xdg-desktop-portal-hyprland** - Screen sharing and desktop integration
- **hyprlock** - Screen locker
- **hyprland-plugins** (AUR) - Additional functionality plugins
- **Hyprspace** - Workspace overview plugin (via HyprPM)

### Terminal & Shell
- **alacritty** - GPU-accelerated terminal emulator
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
- **cliphist** - Clipboard manager
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
- **greetd** (AUR) - Minimal login manager
- **greetd-regreet** (AUR) - GTK-based greeter for greetd

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
cp -r fontconfig ~/.config/
cp -r nwg-displays ~/.config/
cp -r nwg-look ~/.config/
cp -r Thunar ~/.config/
# Copy GTK 2.0 files
cp gtk-2.0/gtkrc ~/.gtkrc-2.0
cp gtk-2.0/gtkrc.mine ~/.gtkrc-2.0.mine
```

3. Enable necessary services:
```bash
systemctl --user enable pipewire pipewire-pulse wireplumber
sudo systemctl enable --now upower
sudo systemctl enable --now cups
```

4. Set fish as default shell:
```bash
chsh -s /usr/bin/fish
```

5. Rebuild the font cache:
```bash
fc-cache -fv
```

6. Log out and log back in using Hyprland session.

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

## Login Manager Setup (greetd/regreet)

### Configuration
1. Enable greetd service:
```bash
sudo systemctl enable greetd
```

2. Configure greetd to use regreet:
```bash
sudo cp /etc/greetd/config.toml /etc/greetd/config.toml.backup
```

3. Edit `/etc/greetd/config.toml`:
```toml
[terminal]
vt = 7

[default_session]
command = "sh -c 'exec </dev/null >/dev/null 2>&1; Hyprland --config /etc/greetd/hyprland.conf'"
user = "greeter"
```

4. Create `/etc/greetd/hyprland.conf`:
```
exec-once = regreet; hyprctl dispatch exit
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    disable_hyprland_qtutils_check = true
}
```

5. Configure regreet theme in `/etc/greetd/regreet.toml`:
```toml
[background]
path = "/usr/share/backgrounds/greeter.jpg"
fit = "Cover"

[GTK]
application_prefer_dark_theme = true
cursor_theme_name = "Bibata-Modern-Ice"
font_name = "JetBrains Mono 14"
icon_theme_name = "Papirus-Dark"
theme_name = "catppuccin-mocha-red-standard+default"

[commands]
reboot = [ "systemctl", "reboot" ]
poweroff = [ "systemctl", "poweroff" ]

[appearance]
greeting_msg = "Welcome to Hyprland"

[widget.clock]
format = "%a %H:%M"
resolution = "1s"
```

6. For silent boot (optional), add to kernel parameters:
```
quiet loglevel=0
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
- `Super + Tab` - Hyprspace workspace overview
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

## Notes

- Some packages may have different names depending on your Arch repository
- The `hyprland-plugins` package may need specific plugin names
- Ensure your GPU drivers are properly installed for Wayland support
- You may need to configure some applications after installation