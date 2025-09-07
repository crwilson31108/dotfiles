# 🚀 Hyprland Dotfiles

A complete Hyprland setup with Quickshell widgets, foot terminal, fish shell with Starship prompt, and Rose Pine theming throughout. Inspired by end-4's aesthetic with custom optimizations.

## ✨ Features

- **Hyprland** window manager with optimized configuration
- **Quickshell** modern desktop widgets and panels
- **Fish shell** with **Starship** prompt (Rose Pine theme)
- **Rose Pine** color scheme throughout the system
- **SilentSDDM theme** with custom Rose Pine colors (2x scale for HiDPI) - modern, customizable login screen
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
  nushell \
  yazi \
  zoxide \
  ripgrep \
  fd \
  tmux \
  github-cli \
  fzf \
  ffmpegthumbnailer \
  unar \
  poppler \
  thunderbird \
  steam \
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
  system-config-printer \
```

### Step 2: Install AUR Packages

```bash
yay -S \
  hyprland-git \
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
  sddm \
  brave-bin \
  caffeinate \
  nmgui-bin
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
- **hypridle** (AUR) - Idle management daemon
- **hyprpicker** (AUR) - Color picker tool
- **hyprsunset** (AUR) - Blue light filter
- **Custom Workspace Manager** - Built-in workspace overview with drag and drop

### Terminal & Shell
- **foot** - Lightweight Wayland terminal emulator
- **fish** - Friendly interactive shell
- **nushell** - Modern shell with structured data
- **yazi** - Modern terminal file manager with image previews
  - **ffmpegthumbnailer** - Video thumbnail support for yazi
  - **unar** - Archive preview support for yazi
  - **jq** - JSON preview support for yazi
  - **poppler** - PDF preview support for yazi
- **zoxide** - Smarter cd command that learns your habits
- **ripgrep** (rg) - Ultra-fast recursive grep with gitignore support
- **fd** - Fast and user-friendly alternative to find
- **tmux** - Terminal multiplexer for managing multiple sessions
- **github-cli** (gh) - GitHub's official command line tool
- **fzf** - Command-line fuzzy finder for files, history, and more

### Applications
- **thunar** - File manager
- **thunar-volman** - Volume management for thunar
- **tumbler** - Thumbnail service
- **pavucontrol** - PulseAudio volume control
- **blueman** - Bluetooth manager
- **gnome-calculator** - Calculator app
- **network-manager-applet** - Network management tray icon
- **nmgui** (AUR) - Modern NetworkManager GUI with intuitive WiFi management
- **brave-bin** - Privacy-focused Chromium-based browser
- **thunderbird** - Email client
- **steam** - Gaming platform

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
- **jq** - JSON processor for workspace scripts
- **ruby** - Runtime for fusuma touchpad gesture daemon
- **nmgui** (AUR) - Clean NetworkManager interface (accessed via WiFi button in top bar)

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
- **SilentSDDM theme** - Modern, highly customizable SDDM theme with Rose Pine colors (2x HiDPI scale)
- **qt6-svg qt6-virtualkeyboard qt6-multimedia** - Required dependencies for SilentSDDM
- **imagemagick** - For generating smooth gradient backgrounds

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
- **caffeinate** (AUR) - Prevents system sleep and display dimming
- **zenity** - Native file picker dialogs
- **rofi-wayland** - Application launcher and clipboard interface
- **inotify-tools** - File system monitoring for app list updates

#### Required Fonts for Quickshell
- **Material Symbols Rounded** - Icon font for Quickshell widgets (automatically installed by install.sh)
- **IBM Plex Sans** - UI font used in Quickshell configuration
- **JetBrains Mono NF** - Monospace font for terminal and code display

### Development Tools
- **neovim** - Text editor with LazyVim configuration
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

## AMD G14 Sleep/Wake Optimization

### Sleep Mode Configuration

For reliable wake from suspend on the ASUS G14 with AMD Ryzen AI 9 HX 370, run the sleep mode optimizer:

```bash
~/.config/hypr/scripts/setup-sleep-mode.sh
```

This switches from `s2idle` to `deep` suspend mode, which is more reliable on AMD systems.

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

## AMD Laptop Power Optimization

For maximum battery life on AMD laptops (especially with Ryzen 7000+ series), apply these power-saving tweaks:

### 1. CPU Governor Configuration
```bash
# Set powersave governor with power preference
echo "power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

To make permanent, create `/etc/systemd/system/amd-powersave.service`:
```ini
[Unit]
Description=Set AMD CPU powersave governor
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo "power" | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference && echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

Enable with: `sudo systemctl enable --now amd-powersave.service`

### 2. Install TLP for ACPI Management
```bash
sudo pacman -S tlp tlp-rdw
sudo systemctl enable --now tlp.service
```

Configure TLP to only handle ACPI (not CPU scaling) by editing `/etc/tlp.conf`:
```bash
# Let amd_pstate_epp handle CPU frequency
CPU_SCALING_GOVERNOR_ON_AC=
CPU_SCALING_GOVERNOR_ON_BAT=
CPU_ENERGY_PERF_POLICY_ON_AC=
CPU_ENERGY_PERF_POLICY_ON_BAT=

# ACPI settings for better battery life
SATA_LINKPWR_ON_BAT=max_performance
WIFI_PWR_ON_BAT=on
WOL_DISABLE=Y
```

### 3. RCU Kernel Parameters for Power Efficiency
Add these to your kernel parameters for reduced CPU interrupts:

**For systemd-boot** - Edit `/boot/loader/entries/*.conf`:
```
options root=UUID=YOUR-ROOT-UUID rw rcutree.enable_rcu_lazy=1 rcu_nocbs=all [other parameters...]
```

**For GRUB** - Edit `/etc/default/grub`:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="... rcutree.enable_rcu_lazy=1 rcu_nocbs=all"
```
Then run: `sudo grub-mkconfig -o /boot/grub/grub.cfg`

**Parameter explanations:**
- `rcutree.enable_rcu_lazy=1` - Delays RCU callbacks to reduce CPU wakeups
- `rcu_nocbs=all` - Offloads RCU processing from main CPUs, reducing interrupts

### 4. Monitor Power Usage
```bash
# Check current CPU frequency and governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference

# Monitor power consumption
sudo powertop

# Check TLP status
sudo tlp-stat -s
```

### Expected Results
With these optimizations on modern AMD laptops:
- 20-30% longer battery life during light usage
- Reduced idle power consumption
- Cooler operation with less fan noise
- No performance impact during demanding tasks (amd_pstate_epp handles boost when needed)

## Memory Compression with Zram

This setup includes optimized memory compression using zram instead of traditional swap or zswap, providing better performance especially on systems with fast CPUs and ample RAM.

### What is Zram?

**Zram** creates a compressed block device in RAM that acts as swap space. Unlike traditional swap:
- Data stays compressed in RAM instead of hitting disk
- Provides much lower latency (CPU + RAM only)
- Reduces SSD wear by avoiding swap writes
- Perfect for systems with 16GB+ RAM

**Zram vs Zswap:**
- **Zram**: Compressed RAM-only swap device (fast but bounded)
- **Zswap**: Compressed RAM cache in front of disk swap (balanced with disk fallback)

With 32GB RAM where typical usage is ~8GB, zram provides excellent performance without needing disk swap.

### Automatic Zram Setup

The installer automatically configures zram with:
- **Size**: Half your RAM (16GB on 32GB systems)
- **Algorithm**: zstd (fast and efficient compression)
- **Priority**: Higher than any disk swap
- **Swappiness**: Optimized for desktop responsiveness

**Quick setup without full installation:**
```bash
./setup-zram.sh
```

### Manual Zram Configuration

To manually configure or adjust zram settings:

```bash
# Install zram-generator
sudo pacman -S zram-generator

# Configure zram
sudo nano /etc/systemd/zram-generator.conf
```

Paste this configuration:
```ini
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 60
```

**Configuration options:**
- `zram-size`: How much RAM to allocate (e.g., `ram / 2`, `8G`, `16G`)
- `compression-algorithm`: zstd (recommended), lz4, lz4hc
- `swap-priority`: Higher numbers are used first

Activate the changes:
```bash
sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0.service
```

Verify zram is working:
```bash
# Check swap status
swapon --show

# View compression statistics
zramctl
```

### Tuning Swappiness

Adjust how aggressively the system uses zram:
```bash
# More aggressive swapping (good for zram)
sudo sysctl vm.swappiness=100

# Make it permanent
echo "vm.swappiness=100" | sudo tee -a /etc/sysctl.d/99-swappiness.conf
```

**Note**: The kernel parameter `zswap.enabled=0` in the systemd-boot configuration ensures zswap is disabled in favor of zram.

## Flatpak Applications

The installer automatically configures Flatpak and installs:
- **Obsidian** - Knowledge base and note-taking application
- **Moonlight** - Game streaming client for NVIDIA GameStream

Additional Flatpak applications can be installed with:
```bash
flatpak search <app-name>
flatpak install flathub <app-id>
```

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

### SilentSDDM Configuration (Recommended)

The installer automatically:
- Installs SDDM and SilentSDDM theme with dependencies
- Creates custom Rose Pine color configuration with 2x scale for HiDPI displays
- Generates smooth gradient background using ImageMagick
- Configures virtual keyboard support for touchscreen devices
- Enables SDDM service for next boot

### Quick SDDM Theme Installation

If you already have Hyprland configured and just want the SDDM Rose Pine theme:
```bash
./install-sddm-theme.sh
```

Manual configuration (if needed):
1. Install SDDM and dependencies:
```bash
sudo pacman -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia
```

2. Clone and install SilentSDDM:
```bash
git clone https://github.com/uiriansan/SilentSDDM.git
cd SilentSDDM
sudo cp -rf . /usr/share/sddm/themes/silent/
```

3. Set the theme in `/etc/sddm.conf.d/silent-theme.conf`:
```ini
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
```

3. Apply the Rose Pine theme (2x scale) by copying the configuration:
```bash
sudo cp ~/Documents/GitHub/dotfiles/sddm-theme/rose-pine-theme.conf /usr/share/sddm/themes/silent/theme.conf
```

4. Configure SDDM autologin (optional) in `/etc/sddm.conf.d/autologin.conf`:
```ini
[Autologin]
User=yourusername
Session=hyprland
```

To disable autologin later, comment out these lines with `#`.


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
- `Super + Shift + E` - Terminal file manager (yazi)

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

### Touchpad Gestures (Hybrid: Native + Fusuma)
- `Three-finger swipe left/right` - Navigate workspaces (native Hyprland - smooth)
- `Three-finger swipe up/down` - Toggle workspace manager (Quickshell via Fusuma)
- `Super + Tab` - Toggle workspace manager (keyboard shortcut)

## 💡 CLI Utilities Tips & Tricks

### Zoxide - Smarter Navigation

**Setup (automatically done by install.sh):**
```bash
# For Zsh - add to ~/.zshrc
eval "$(zoxide init zsh)"

# For Fish - add to ~/.config/fish/conf.d/zoxide.fish
zoxide init fish | source

# For Bash - add to ~/.bashrc
eval "$(zoxide init bash)"
```

**Usage:**
```bash
# After cd'ing around for a while, zoxide learns your habits
z proj        # Jumps to ~/Documents/GitHub/dotfiles/project
z dot         # Jumps to ~/Documents/GitHub/dotfiles
zi            # Interactive selection with fzf

# Add to your shell config for even better integration
alias cd="z"
```

### Ripgrep (rg) - Lightning Fast Search
```bash
# Basic search
rg "TODO"                    # Search for TODO in current directory
rg -i "config"              # Case-insensitive search
rg "^import" -g "*.py"      # Search only in Python files
rg "error" --type rust      # Search only in Rust files
rg -C 3 "function"          # Show 3 lines of context

# Advanced patterns
rg -e "TODO|FIXME|HACK"     # Multiple patterns
rg "class.*Config"          # Regex patterns
rg --files | rg "test"      # Find files with 'test' in name
```

### fd - Intuitive File Finding
```bash
# Find files by name
fd "config"                  # Find all files/dirs with 'config'
fd -e py                    # Find all Python files
fd -H "^\\."                 # Find hidden files
fd -t d "src"               # Find only directories named 'src'

# Powerful combinations with other tools
fd -e rs -x wc -l          # Count lines in all Rust files
fd -e jpg -x convert {} {.}.png  # Convert all JPGs to PNG
```

### fzf - Fuzzy Finding Everything
```bash
# File navigation
vim $(fzf)                   # Open file in vim with fuzzy search
cd $(fd -t d | fzf)         # cd to directory with fuzzy search

# Command history (add to shell config)
history | fzf | sh          # Search and execute from history

# Git integration
git log --oneline | fzf | awk '{print $1}' | xargs git show

# Kill processes interactively
ps aux | fzf | awk '{print $2}' | xargs kill

# Pro tip: Add these to your shell config
alias ff='fd --type f | fzf | xargs -r nvim'  # Fuzzy find and edit
alias fcd='cd $(fd --type d | fzf)'           # Fuzzy cd
```

### tmux - Terminal Multiplexing
```bash
# Basic usage
tmux                        # Start new session
tmux new -s work           # New named session
tmux ls                    # List sessions
tmux attach -t work        # Attach to session

# Key bindings (default prefix: Ctrl+b)
Ctrl+b c    # New window
Ctrl+b ,    # Rename window
Ctrl+b %    # Split vertically
Ctrl+b "    # Split horizontally
Ctrl+b arrow # Navigate panes
Ctrl+b d    # Detach from session
Ctrl+b [    # Enter scroll mode (q to exit)
```

### GitHub CLI (gh) - GitHub from Terminal
```bash
# Repository operations
gh repo create myproject --private
gh repo clone user/repo
gh repo view --web         # Open in browser

# Pull requests
gh pr create --title "Add feature" --body "Description"
gh pr list
gh pr view 123
gh pr checkout 123         # Checkout PR locally

# Issues
gh issue create
gh issue list --label "bug"
gh issue close 42

# Workflows
gh run list
gh run watch              # Watch latest run
gh workflow run tests.yml # Trigger workflow
```

### Yazi - Terminal File Manager
```bash
# Navigation
h/j/k/l     # Navigate (vim-style)
Enter       # Open file/enter directory
H           # Go to parent directory
~           # Go to home
Space       # Select/deselect
v           # Select all

# Operations
y           # Yank (copy)
x           # Cut
p           # Paste
d           # Delete (move to trash)
D           # Delete permanently
r           # Rename
/           # Search in current directory

# Preview
Tab         # Toggle preview
W           # Toggle word wrap in preview
```

### Power User Combinations
```bash
# Find and replace across project
fd -e rs | xargs rg -l "old_function" | xargs sed -i 's/old_function/new_function/g'

# Interactive git commit browser
git log --oneline | fzf --preview 'git show --color=always {1}' | awk '{print $1}'

# Find large files interactively
fd -t f -x du -h | sort -rh | head -20 | fzf

# Quick project switcher (add to shell config)
function proj() {
  cd $(fd -t d -d 3 . ~/Documents/GitHub | fzf)
}

# Fuzzy kill process
function fkill() {
  ps aux | fzf | awk '{print $2}' | xargs kill -9
}
```

## 🚀 LazyVim Configuration

This dotfiles setup includes a complete LazyVim configuration with:
- Pre-configured LSP servers for multiple languages
- Auto-completion and snippets
- File explorer and fuzzy finder
- Git integration
- Modern UI with telescope and which-key

The LazyVim configuration will be automatically deployed during installation. On first launch:
1. Neovim will automatically install all plugins
2. LSP servers will be installed as needed
3. Treesitter parsers will be downloaded

To manually set up LazyVim on an existing system:
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Copy the LazyVim config from dotfiles
cp -r ~/Documents/GitHub/dotfiles/nvim ~/.config/nvim

# Launch Neovim (plugins will auto-install)
nvim
```

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

**Quickshell icons missing (calendar_month, power_settings_new, etc):**
- The Material Symbols Rounded font is required for icons
- The install script automatically downloads and installs this font
- To manually install: 
  ```bash
  curl -o ~/.local/share/fonts/MaterialSymbolsRounded.ttf \
    "https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf"
  fc-cache -fv ~/.local/share/fonts
  killall quickshell && quickshell &
  ```

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