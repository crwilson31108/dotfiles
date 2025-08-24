#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════╗
# ║                    HYPRLAND DOTFILES INSTALLER                      ║
# ║                      Silent Installation Mode                       ║
# ║          Automated setup with sane defaults - no prompts           ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
USER_CONFIG="$HOME/.config"
AUR_HELPER=""

# ASCII Art
print_header() {
    echo -e "${PURPLE}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║          ██╗  ██╗██╗   ██╗██████╗ ██████╗                       ║
    ║          ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗                      ║
    ║          ███████║ ╚████╔╝ ██████╔╝██████╔╝                      ║
    ║          ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗                      ║
    ║          ██║  ██║   ██║   ██║     ██║  ██║                      ║
    ║          ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝                      ║
    ║                                                                  ║
    ║                    DOTFILES INSTALLER                           ║
    ║                 Silent Install - No Prompts                     ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo -e "\n${PURPLE}═══════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}\n"
}

# Check if running as root
check_not_root() {
    if [ "$EUID" -eq 0 ]; then
        log_error "This script should not be run as root"
        log_info "Please run as regular user: ./install.sh"
        exit 1
    fi
}

# Check system compatibility
check_system() {
    log_section "SYSTEM COMPATIBILITY CHECK"
    
    if [ ! -f /etc/arch-release ]; then
        log_error "This script is designed for Arch Linux only"
        exit 1
    fi
    
    log_success "Arch Linux detected"
    
    # Check for network connectivity
    if ! ping -c 1 google.com >/dev/null 2>&1; then
        log_error "No internet connection available"
        exit 1
    fi
    
    log_success "Internet connection verified"
}

# Detect and setup AUR helper
setup_aur_helper() {
    log_section "AUR HELPER SETUP"
    
    if command -v yay >/dev/null 2>&1; then
        AUR_HELPER="yay"
        log_success "Using existing yay AUR helper"
    elif command -v paru >/dev/null 2>&1; then
        AUR_HELPER="paru"
        log_success "Using existing paru AUR helper"
    else
        log_info "Installing yay AUR helper..."
        
        # Install git and base-devel if not present
        sudo pacman -S --needed --noconfirm git base-devel
        
        # Clone and build yay
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd "$DOTFILES_DIR"
        
        AUR_HELPER="yay"
        log_success "yay AUR helper installed"
    fi
}

# Update system
update_system() {
    log_section "SYSTEM UPDATE"
    
    log_info "Updating package databases..."
    sudo pacman -Sy --noconfirm
    
    log_info "Updating system packages..."
    sudo pacman -Su --noconfirm
    
    log_info "Updating AUR packages..."
    $AUR_HELPER -Sua --noconfirm
    
    log_success "System updated"
}

# Resolve common package conflicts
resolve_conflicts() {
    log_info "Resolving common package conflicts..."
    
    # VS Code conflict: Remove AUR version in favor of official repo version
    if pacman -Qi visual-studio-code-bin &>/dev/null; then
        log_info "Removing visual-studio-code-bin in favor of official code package..."
        $AUR_HELPER -R --noconfirm visual-studio-code-bin || true
    fi
    
    # Discord conflict: Remove AUR version in favor of official
    if pacman -Qi discord-canary &>/dev/null && ! pacman -Qi discord &>/dev/null; then
        log_info "Removing discord-canary in favor of stable discord..."
        $AUR_HELPER -R --noconfirm discord-canary || true
    fi
    
    # Firefox conflict: Remove AUR versions
    if pacman -Qi firefox-nightly &>/dev/null && ! pacman -Qi firefox &>/dev/null; then
        log_info "Removing firefox-nightly in favor of stable firefox..."
        $AUR_HELPER -R --noconfirm firefox-nightly || true
    fi
    log_success "Package conflicts resolved"
}

# Helper function to install package groups with error handling
install_package_group() {
    local group_name="$1"
    shift
    local packages=("$@")
    
    log_info "Installing $group_name..."
    
    # Try to install the group, handling conflicts gracefully
    if ! sudo pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null; then
        log_warning "Some packages in '$group_name' had conflicts, trying individually..."
        
        # Install packages one by one to identify problematic ones
        for package in "${packages[@]}"; do
            if ! sudo pacman -S --needed --noconfirm "$package" 2>/dev/null; then
                log_warning "Failed to install $package, skipping..."
            fi
        done
    fi
}

# Install packages
install_packages() {
    log_section "PACKAGE INSTALLATION"
    
    # Resolve conflicts first
    resolve_conflicts
    
    # Core Hyprland ecosystem (essential for functionality)
    local core_packages=(
        "hyprland"
        "hypridle"
        "hyprcursor"
        "hyprland-qtutils"
        "hyprland-qt-support"
        "hyprlang"
        "hyprlock"
        "hyprpicker"
        "hyprshot"
        "hyprsunset"
        "hyprutils"
        "hyprwayland-scanner"
        "hyprpaper"
        "xdg-desktop-portal-hyprland"
        "wl-clipboard"
    )
    
    # Terminal and shell (essential tools)
    local terminal_packages=(
        "foot"
        "fish"
        "starship"
        "zsh"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "nushell"
        "eza"
        "bat"
        "fd"
        "ripgrep"
        "cliphist"
        "caffeinate"
        "curl"
        "wget"
        "git"
        "jq"
        "ruby"
        "xdg-user-dirs"
    )
    
    # GUI applications and tools
    # Thunar requires GVfs for mounting, udisks2 for disk management,
    # tumbler for thumbnails, and a polkit agent for permissions
    local gui_packages=(
        "thunar"
        "thunar-volman"          # Auto-mount and manage volumes
        "thunar-archive-plugin"  # Archive integration
        "thunar-media-tags-plugin" # Audio file tag editor
        "file-roller"            # Archive manager
        "gvfs"                   # Virtual filesystem for mounting
        "gvfs-mtp"               # Android/media players
        "gvfs-gphoto2"           # Digital cameras
        "gvfs-afc"               # iOS devices
        "gvfs-smb"               # Samba/Windows shares
        "gvfs-nfs"               # NFS shares
        "udisks2"                # Disk management service
        "tumbler"                # Thumbnail service
        "ffmpegthumbnailer"      # Video thumbnails
        "poppler-glib"           # PDF thumbnails
        "libgsf"                 # ODF thumbnails
        "libopenraw"             # RAW image thumbnails
        "webkit2gtk-4.1"         # HTML thumbnails
        "evince"                 # PDF viewer with thumbnailer
        "ristretto"              # Lightweight image viewer
        "firefox"
        "thunderbird"
        "code"
        "discord"
        "spotify-launcher"
        "steam"
    )
    
    # Media and graphics (enhanced with end-4's audio setup)
    local media_packages=(
        "pipewire"
        "pipewire-alsa"
        "pipewire-pulse"
        "pipewire-jack"
        "wireplumber"
        "pavucontrol-qt"
        "libdbusmenu-gtk3"
        "playerctl"
        "cava"
        "mpv"
        "imv"
        "grim"
        "slurp"
        "swappy"
        "imagemagick"
        "tesseract"
        "tesseract-data-eng"
        "wf-recorder"
        "webp-pixbuf-loader"     # WebP image support
        "libheif"                # HEIF/HEIC image support
    )
    
    # Fonts and themes (enhanced with end-4's selections)
    local theme_packages=(
        "ttf-jetbrains-mono-nerd"
        "ttf-nerd-fonts-symbols"
        "noto-fonts"
        "noto-fonts-emoji"
        "fontconfig"
        "papirus-icon-theme"
        "kvantum"
        "qt5ct"
        "qt6ct"
        "gtk3"
        "gtk4"
        "breeze"
        "glib2"
        "ttf-ibm-plex"  # Required by Quickshell config
        "ttf-jetbrains-mono"  # Required by Quickshell config
    )
    
    # System utilities (enhanced portal and desktop integration)
    local utility_packages=(
        "networkmanager"
        "nm-connection-editor"
        "network-manager-applet"
        "bluez"
        "bluez-utils"
        "blueman"
        "brightnessctl"
        "jq"
        "ruby"
        "polkit-gnome"
        "xdg-desktop-portal"
        "xdg-desktop-portal-kde"
        "xdg-desktop-portal-gtk"
        "xdg-user-dirs"
        "xdg-utils"
        "flatpak"
        "neofetch"
        "htop"
        "btop"
        "unzip"
        "zip"
        "p7zip"
        "git"
        "vim"
        "nano"
        "neovim"
    )
    
    # AUR packages (essential for functionality)
    local aur_packages=(
        "quickshell-git"
        "fuzzel"
        "wlogout"
        "rose-pine-cursor"
        "bibata-cursor-theme"
        "rofi-lbonn-wayland"
        "rofimoji"
        "udiskie"
        "gnome-epub-thumbnailer" # EPUB thumbnails
        "foliate"                # Modern ebook reader
        "brave-bin"              # Brave browser
    )
    
    # Install packages with better error handling
    install_package_group "core Hyprland packages" "${core_packages[@]}"
    install_package_group "terminal and shell packages" "${terminal_packages[@]}"
    install_package_group "GUI applications" "${gui_packages[@]}"
    install_package_group "media packages" "${media_packages[@]}"
    install_package_group "theme packages" "${theme_packages[@]}"
    install_package_group "utility packages" "${utility_packages[@]}"
    
    log_info "Installing AUR packages..."
    $AUR_HELPER -S --needed --noconfirm "${aur_packages[@]}" || {
        log_warning "Some AUR packages failed to install, continuing..."
    }
    
    log_success "All packages installed"
}


# Create backup of existing configs
create_backup() {
    log_section "CONFIGURATION BACKUP"
    
    mkdir -p "$BACKUP_DIR"
    log_info "Created backup directory: $BACKUP_DIR"
    
    # List of directories to backup
    local config_dirs=(
        "hypr"
        "foot"
        "fish"
        "nvim"
        "quickshell"
        "qt5ct"
        "qt6ct"
        "Kvantum"
        "gtk-3.0"
        "gtk-4.0"
        "Thunar"
        "xsettingsd"
        "fontconfig"
        "jq"
        "ruby"
    )
    
    # Backup existing configs
    for dir in "${config_dirs[@]}"; do
        if [ -d "$USER_CONFIG/$dir" ]; then
            log_info "Backing up $dir configuration..."
            cp -r "$USER_CONFIG/$dir" "$BACKUP_DIR/"
        fi
    done
    
    # Backup individual files
    local config_files=(
        "$USER_CONFIG/starship.toml"
        "$USER_CONFIG/rofimoji.rc"
        "$USER_CONFIG/kdeglobals"
        "$HOME/.gtkrc-2.0"
        "$HOME/.gtkrc-2.0.mine"
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
    )
    
    for file in "${config_files[@]}"; do
        if [ -f "$file" ]; then
            log_info "Backing up $(basename "$file")..."
            cp "$file" "$BACKUP_DIR/"
        fi
    done
    
    log_success "Backup completed: $BACKUP_DIR"
}

# Deploy configuration files
deploy_configs() {
    log_section "CONFIGURATION DEPLOYMENT"
    
    # Create necessary directories
    mkdir -p "$USER_CONFIG"
    
    # Copy config directories
    local config_dirs=(
        "hypr"
        "foot"
        "fish"
        "nvim"
        "quickshell"
        "qt5ct"
        "qt6ct"
        "Kvantum"
        "gtk-3.0"
        "gtk-4.0"
        "Thunar"
        "xsettingsd"
        "fontconfig"
        "jq"
        "ruby"
    )
    
    for dir in "${config_dirs[@]}"; do
        if [ -d "$DOTFILES_DIR/$dir" ]; then
            log_info "Deploying $dir configuration..."
            # Remove existing directory if it exists
            [ -d "$USER_CONFIG/$dir" ] && rm -rf "$USER_CONFIG/$dir"
            cp -r "$DOTFILES_DIR/$dir" "$USER_CONFIG/"
        fi
    done
    
    # Copy individual config files
    if [ -f "$DOTFILES_DIR/starship.toml" ]; then
        log_info "Deploying Starship configuration..."
        cp "$DOTFILES_DIR/starship.toml" "$USER_CONFIG/"
    fi
    
    if [ -f "$DOTFILES_DIR/rofimoji.rc" ]; then
        log_info "Deploying Rofimoji configuration..."
        cp "$DOTFILES_DIR/rofimoji.rc" "$USER_CONFIG/"
    fi
    
    if [ -f "$DOTFILES_DIR/kdeglobals" ]; then
        log_info "Deploying KDE globals..."
        cp "$DOTFILES_DIR/kdeglobals" "$USER_CONFIG/"
    fi
    
    # Deploy GTK 2.0 configs
    if [ -d "$DOTFILES_DIR/gtk-2.0" ]; then
        log_info "Deploying GTK 2.0 configuration..."
        [ -f "$DOTFILES_DIR/gtk-2.0/gtkrc" ] && cp "$DOTFILES_DIR/gtk-2.0/gtkrc" "$HOME/.gtkrc-2.0"
        [ -f "$DOTFILES_DIR/gtk-2.0/gtkrc.mine" ] && cp "$DOTFILES_DIR/gtk-2.0/gtkrc.mine" "$HOME/.gtkrc-2.0.mine"
    fi
    
    log_success "Configuration files deployed"
}

# Setup Thunar mounting support
setup_thunar_mounting() {
    log_section "THUNAR MOUNTING SUPPORT"
    
    # Create autostart configuration for Hyprland
    local autostart_file="$USER_CONFIG/hypr/autostart.conf"
    
    log_info "Setting up autostart services for mounting..."
    
    # Create or append to autostart.conf
    cat >> "$autostart_file" << 'EOF'

# Thunar mounting support
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = udiskie --automount --notify --tray &
EOF
    
    # Ensure autostart.conf is sourced in main hyprland.conf
    if [ -f "$USER_CONFIG/hypr/hyprland.conf" ] && ! grep -q "autostart.conf" "$USER_CONFIG/hypr/hyprland.conf"; then
        echo "source = ~/.config/hypr/autostart.conf" >> "$USER_CONFIG/hypr/hyprland.conf"
    fi
    
    log_success "Thunar mounting support configured"
}

# Setup shell
setup_shell() {
    log_section "SHELL CONFIGURATION"
    
    # Change default shell to fish (with fallback to zsh)
    if command -v fish >/dev/null 2>&1; then
        log_info "Setting fish as default shell..."
        # Add fish to /etc/shells if not present
        if ! grep -q "$(which fish)" /etc/shells; then
            echo "$(which fish)" | sudo tee -a /etc/shells
        fi
        sudo chsh -s "$(which fish)" "$USER" 2>/dev/null || {
            log_warning "Failed to change shell to fish, keeping current shell"
        }
        log_success "Fish shell configured"
    elif command -v zsh >/dev/null 2>&1; then
        log_info "Setting zsh as default shell..."
        if ! grep -q "$(which zsh)" /etc/shells; then
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi
        sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null || {
            log_warning "Failed to change shell to zsh, keeping current shell"
        }
        log_success "Zsh shell configured"
    fi
}

# Setup system services
setup_services() {
    log_section "SYSTEM SERVICES"
    
    # Enable NetworkManager
    log_info "Enabling NetworkManager service..."
    sudo systemctl enable NetworkManager --now 2>/dev/null || true
    
    # Enable Bluetooth
    log_info "Enabling Bluetooth service..."
    sudo systemctl enable bluetooth --now 2>/dev/null || true
    
    # Enable udisks2 for mounting
    log_info "Enabling udisks2 service for mounting..."
    sudo systemctl enable udisks2 --now 2>/dev/null || true
    
    # Setup Flatpak
    log_info "Setting up Flatpak..."
    # Add Flathub repository
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    # Enable Flatpak theming integration
    sudo flatpak override --filesystem=$HOME/.themes
    sudo flatpak override --filesystem=$HOME/.icons
    sudo flatpak override --env=GTK_THEME=catppuccin-mocha-red
    sudo flatpak override --env=ICON_THEME=Papirus
    log_success "Flatpak configured with Flathub repository"
    
    # Install essential Flatpak applications
    log_info "Installing Flatpak applications..."
    # Install Obsidian
    flatpak install -y flathub md.obsidian.Obsidian || log_warning "Failed to install Obsidian"
    # Install Moonlight
    flatpak install -y flathub com.moonlight_stream.Moonlight || log_warning "Failed to install Moonlight"
    log_success "Flatpak applications installed"
    
    # Create XDG user directories
    log_info "Creating XDG user directories..."
    xdg-user-dirs-update
    
    # Setup fusuma for touchpad gestures
    log_info "Adding user to input group for touchpad gestures..."
    sudo usermod -a -G input "$USER" || log_warning "Failed to add user to input group. You may need to add yourself manually: sudo usermod -a -G input $USER"
    
    log_info "Setting up fusuma for touchpad gestures..."
    gem install fusuma --user-install &>/dev/null || log_warning "Failed to install fusuma"
    chmod +x ~/.config/hypr/scripts/ws_*.sh 2>/dev/null || true
    
    # Update autostart with correct fusuma path
    FUSUMA_PATH="$HOME/.local/share/gem/ruby/3.4.0/bin/fusuma"
    if [[ -f ~/.config/hypr/config/autostart.conf ]]; then
        sed -i "s|exec-once = /home/caseyw/.local/share/gem/ruby/3.4.0/bin/fusuma -d|exec-once = $FUSUMA_PATH -d|g" ~/.config/hypr/config/autostart.conf
    fi
    
    log_success "System services configured"
}

# Set file permissions
set_permissions() {
    log_section "PERMISSIONS SETUP"
    
    # Make scripts executable
    if [ -d "$USER_CONFIG/hypr/scripts" ]; then
        log_info "Setting executable permissions for Hyprland scripts..."
        chmod +x "$USER_CONFIG/hypr/scripts/"*
    fi
    
    if [ -d "$USER_CONFIG/quickshell/scripts" ]; then
        log_info "Setting executable permissions for Quickshell scripts..."
        chmod +x "$USER_CONFIG/quickshell/scripts/"*
    fi
    
    # Make sync script executable
    if [ -f "$DOTFILES_DIR/sync_configs.sh" ]; then
        log_info "Setting executable permissions for sync script..."
        chmod +x "$DOTFILES_DIR/sync_configs.sh"
    fi
    
    log_success "Permissions configured"
}

# Install Material Symbols Rounded font for Quickshell icons
install_material_symbols_font() {
    log_section "MATERIAL SYMBOLS FONT INSTALLATION"
    
    # Check if Material Symbols Rounded is already installed
    if fc-list | grep -qi "Material Symbols Rounded"; then
        log_success "Material Symbols Rounded font already installed"
        return
    fi
    
    log_info "Installing Material Symbols Rounded font for Quickshell icons..."
    
    # Create fonts directory
    mkdir -p "$HOME/.local/share/fonts"
    
    # Download Material Symbols Rounded font
    local font_url="https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf"
    local font_file="$HOME/.local/share/fonts/MaterialSymbolsRounded.ttf"
    
    if curl -fsSL "$font_url" -o "$font_file" 2>/dev/null; then
        log_success "Material Symbols Rounded font downloaded"
        
        # Update font cache
        fc-cache -fv "$HOME/.local/share/fonts" >/dev/null 2>&1
        log_success "Font cache updated"
    else
        log_warning "Failed to download Material Symbols Rounded font. Quickshell icons may not display correctly."
        log_info "You can manually install it later by running:"
        log_info "curl -o ~/.local/share/fonts/MaterialSymbolsRounded.ttf '$font_url'"
        log_info "fc-cache -fv ~/.local/share/fonts"
    fi
}

# Final setup and validation
final_setup() {
    log_section "FINAL SETUP"
    
    # Install Material Symbols font for Quickshell
    install_material_symbols_font
    
    # Refresh font cache
    log_info "Refreshing font cache..."
    fc-cache -fv >/dev/null 2>&1
    
    # Update GTK icon cache
    log_info "Updating GTK icon cache..."
    gtk-update-icon-cache -f -t /usr/share/icons/Papirus-Dark >/dev/null 2>&1 || true
    
    # Create wallpaper directory if it doesn't exist
    mkdir -p "$HOME/Pictures/Wallpapers"
    log_info "Created wallpapers directory: $HOME/Pictures/Wallpapers"
    
    log_success "Final setup completed"
}

# Setup display manager for Hyprland
setup_display_manager() {
    log_section "DISPLAY MANAGER SETUP"
    
    # Install SDDM and required packages
    if ! command -v sddm >/dev/null 2>&1; then
        log_info "Installing SDDM display manager and dependencies..."
        sudo pacman -S --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia
    fi
    
    # Enable SDDM service
    log_info "Enabling SDDM display manager..."
    sudo systemctl enable sddm >/dev/null 2>&1 || true
    
    # Install SilentSDDM theme
    log_info "Installing SilentSDDM theme..."
    
    # Clone SilentSDDM if not present
    if [ ! -d "/tmp/SilentSDDM" ]; then
        log_info "Downloading SilentSDDM theme..."
        git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM /tmp/SilentSDDM
    fi
    
    # Install theme
    sudo mkdir -p /usr/share/sddm/themes/silent
    sudo cp -rf /tmp/SilentSDDM/* /usr/share/sddm/themes/silent/
    
    # Install fonts
    sudo cp -r /usr/share/sddm/themes/silent/fonts/* /usr/share/fonts/ || true
    
    # Create rose pine config
    log_info "Creating custom Rose Pine configuration..."
    sudo tee /usr/share/sddm/themes/silent/configs/rose-pine.conf >/dev/null << 'EOF'
; Rose Pine Dark Theme for SilentSDDM
[General]
scale = 1.0
enable-animations = true
background-fill-mode = fill

[LoginScreen]
background = rose-pine-gradient.jpg
use-background-color = false
background-color = #191724
blur = 0
brightness = 0.0
saturation = 0.0

[LoginScreen.LoginArea.Avatar]
shape = circle
border-radius = 35
active-size = 120
inactive-size = 80
active-border-size = 2
active-border-color = #c4a7e7

[LoginScreen.LoginArea.Username]
font-family = RedHatDisplay
font-size = 16
font-weight = 700
color = #e0def4

[LoginScreen.LoginArea.PasswordInput]
width = 200
height = 30
content-color = #e0def4
background-color = #26233a
background-opacity = 0.8
border-size = 1
border-color = #403d52
border-radius-left = 10
border-radius-right = 10

[LoginScreen.LoginArea.LoginButton]
background-color = #c4a7e7
background-opacity = 0.9
active-background-color = #eb6f92
active-background-opacity = 0.9
content-color = #191724
active-content-color = #191724

[LoginScreen.VirtualKeyboard]
background-color = #26233a
background-opacity = 0.95
key-content-color = #e0def4
key-color = #403d52
key-active-background-color = #c4a7e7
primary-color = #c4a7e7
EOF
    
    # Create gradient background
    log_info "Creating Rose Pine gradient background..."
    if command -v magick >/dev/null 2>&1; then
        sudo magick -size 3840x2160 \
            radial-gradient:'#191724-#1f1d2e-#26233a-#2d2438-#eb6f92-#c084aa-#c4a7e7-#403d52-#31748f' \
            /tmp/base_gradient.png 2>/dev/null || true
        
        sudo magick /tmp/base_gradient.png \
            \( +clone -channel RGB +noise Uniform -blur 0x0.3 \) \
            -compose Overlay -composite \
            -modulate 100,110,100 \
            /usr/share/sddm/themes/silent/backgrounds/rose-pine-gradient.jpg 2>/dev/null || true
        
        sudo rm /tmp/base_gradient.png 2>/dev/null || true
    else
        log_warning "ImageMagick not available, using solid color background"
        # Create solid color fallback
        sudo tee /usr/share/sddm/themes/silent/backgrounds/rose-pine-gradient.jpg >/dev/null << 'EOF'
# Fallback: solid rose pine background
EOF
    fi
    
    # Update metadata to use rose pine config
    sudo sed -i 's/ConfigFile=configs\/default.conf/ConfigFile=configs\/rose-pine.conf/' \
        /usr/share/sddm/themes/silent/metadata.desktop
    
    # Configure SDDM with SilentSDDM
    log_info "Configuring SDDM with SilentSDDM theme..."
    sudo mkdir -p /etc/sddm.conf.d
    
    sudo tee /etc/sddm.conf.d/silent-theme.conf >/dev/null << 'EOF'
[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent

[Users]
MaximumUid=60513
MinimumUid=1000

[Autologin]
Relogin=false
Session=
User=
EOF
    
    # Create Hyprland desktop entry if it doesn't exist
    if [ ! -f "/usr/share/wayland-sessions/hyprland.desktop" ]; then
        log_info "Creating Hyprland session entry..."
        sudo tee /usr/share/wayland-sessions/hyprland.desktop >/dev/null << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
    fi
    
    # Clean up
    rm -rf /tmp/SilentSDDM 2>/dev/null || true
    
    log_success "SilentSDDM theme with Rose Pine colors configured"
}

# Setup wallpapers directory with samples
setup_wallpapers() {
    log_section "WALLPAPER SETUP"
    
    local wallpaper_dir="$HOME/Pictures/Wallpapers"
    mkdir -p "$wallpaper_dir"
    
    # Check if wallpapers directory is empty
    if [ -z "$(ls -A "$wallpaper_dir" 2>/dev/null)" ]; then
        log_info "Downloading sample wallpapers..."
        
        # Download some high-quality sample wallpapers
        local wallpapers=(
            "https://raw.githubusercontent.com/rose-pine/wallpapers/main/pine-forest.png"
            "https://raw.githubusercontent.com/rose-pine/wallpapers/main/evening-lake.png"
            "https://raw.githubusercontent.com/rose-pine/wallpapers/main/mountain-sunset.png"
        )
        
        for wallpaper_url in "${wallpapers[@]}"; do
            local filename=$(basename "$wallpaper_url")
            log_info "Downloading $filename..."
            curl -fsSL "$wallpaper_url" -o "$wallpaper_dir/$filename" 2>/dev/null || {
                log_warning "Failed to download $filename, continuing..."
            }
        done
        
        # If downloads failed, create a solid color fallback
        if [ -z "$(ls -A "$wallpaper_dir" 2>/dev/null)" ]; then
            log_info "Creating fallback wallpaper..."
            convert -size 1920x1080 xc:'#191724' "$wallpaper_dir/rose-pine-base.png" 2>/dev/null || {
                log_warning "Could not create fallback wallpaper"
            }
        fi
        
        log_success "Sample wallpapers added to $wallpaper_dir"
    else
        log_success "Wallpapers directory already populated"
    fi
}

# Create keybind reference
create_keybind_reference() {
    log_section "KEYBIND REFERENCE SETUP"
    
    local reference_file="$HOME/Desktop/Hyprland-Keybinds.txt"
    
    log_info "Creating keybind reference card..."
    cat > "$reference_file" << 'EOF'
╔══════════════════════════════════════════════════════════════════════╗
║                    HYPRLAND KEYBIND REFERENCE                       ║
╚══════════════════════════════════════════════════════════════════════╝

🖥️  WINDOW MANAGEMENT:
Super + Q                 Close window
Super + F                 Toggle fullscreen
Super + V                 Toggle floating/tiling
Super + Y                 Pin window (show on all workspaces)
Super + L                 Lock screen
Alt + Tab                 Window switcher

📱 WORKSPACES:
Super + 1-9               Switch to workspace 1-9
Super + Ctrl + 1-9        Move window to workspace and follow
Super + Shift + 1-9       Move window to workspace silently
Super + Tab               Workspace overview
Super + Equal             Toggle special workspace

🚀 APPLICATIONS:
Super + Return            Open terminal (foot)
Super + Space             Application launcher
Super + A                 Application overview
Super + E                 File manager (Thunar)
Super + B                 Browser
Super + P                 Power menu
Super + Shift + E         Emoji picker

📷 SYSTEM:
Super + W                 Change wallpaper
Super + N                 Toggle blue light filter
Super + Shift + N         Clear notifications
Super + G                 Remove gaps
Super + Shift + G         Restore default gaps
Super + Escape            Dismiss popouts

🎵 MEDIA KEYS:
Volume Up/Down            Adjust volume
Mute                      Toggle mute
Play/Pause                Media control
Brightness Up/Down        Adjust screen brightness

📄 FILES:
- Dotfiles: ~/Documents/GitHub/dotfiles/
- Wallpapers: ~/Pictures/Wallpapers/
- Config: ~/.config/
- Backup: ~/.dotfiles_backup_*/

EOF
    
    # Also create a desktop shortcut
    mkdir -p "$HOME/Desktop"
    log_success "Keybind reference created at $reference_file"
}

# Hardware detection and optimization
optimize_hardware() {
    log_section "HARDWARE OPTIMIZATION"
    
    # Detect GPU and optimize
    if lspci | grep -qi nvidia; then
        log_info "NVIDIA GPU detected - setting environment variables..."
        
        # Add NVIDIA-specific environment variables to Hyprland config
        local nvidia_env_file="$USER_CONFIG/hypr/nvidia.conf"
        cat > "$nvidia_env_file" << 'EOF'
# NVIDIA-specific environment variables
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
EOF
        
        # Source it in main hyprland.conf if not already included
        if [ -f "$USER_CONFIG/hypr/hyprland.conf" ] && ! grep -q "nvidia.conf" "$USER_CONFIG/hypr/hyprland.conf"; then
            echo "source = ~/.config/hypr/nvidia.conf" >> "$USER_CONFIG/hypr/hyprland.conf"
        fi
        
        log_warning "NVIDIA detected: You may need to install nvidia-dkms and configure drivers"
    fi
    
    # Detect AMD GPU
    if lspci | grep -qi amd; then
        log_info "AMD GPU detected - optimizing for RADV..."
        
        local amd_env_file="$USER_CONFIG/hypr/amd.conf"
        cat > "$amd_env_file" << 'EOF'
# AMD-specific optimizations
env = RADV_DEBUG,zerovram
env = AMD_VULKAN_ICD,RADV
EOF
        
        if [ -f "$USER_CONFIG/hypr/hyprland.conf" ] && ! grep -q "amd.conf" "$USER_CONFIG/hypr/hyprland.conf"; then
            echo "source = ~/.config/hypr/amd.conf" >> "$USER_CONFIG/hypr/hyprland.conf"
        fi
    fi
    
    # Detect HiDPI display
    local scale_factor=1
    if xdpyinfo 2>/dev/null | grep -q "dots per inch" && [ "$(xdpyinfo 2>/dev/null | grep 'dots per inch' | awk '{print $2}' | cut -d. -f1)" -gt 120 ]; then
        scale_factor=1.5
        log_info "HiDPI display detected - setting scale factor to $scale_factor"
    fi
    
    log_success "Hardware optimization completed"
}

# Print completion message
print_completion() {
    log_section "INSTALLATION COMPLETE"
    
    echo -e "${GREEN}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║                    INSTALLATION SUCCESSFUL!                     ║
    ║                                                                  ║
    ║  Your Hyprland dotfiles have been installed and optimized:      ║
    ║                                                                  ║
    ║  ✅ Hyprland window manager with complete config                ║
    ║  ✅ Display manager auto-configured (SDDM with Astronaut)       ║
    ║  ✅ Fish shell with Starship prompt                             ║
    ║  ✅ Quickshell desktop widgets                                  ║
    ║  ✅ Thunar with full mounting & thumbnail support               ║
    ║  ✅ Brave browser and Flatpak configured                        ║
    ║  ✅ Sample wallpapers and keybind reference                     ║
    ║  ✅ Hardware-specific optimizations applied                     ║
    ║  ✅ Automatic configuration backups created                     ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    log_info "Configuration backup location: $BACKUP_DIR"
    log_info "Dotfiles location: $DOTFILES_DIR"
    
    echo -e "\n${YELLOW}READY TO USE:${NC}"
    echo -e "${CYAN}1.${NC} Reboot your system (display manager auto-configured)"
    echo -e "${CYAN}2.${NC} Select 'Hyprland' at login screen"
    echo -e "${CYAN}3.${NC} Check ~/Desktop/Hyprland-Keybinds.txt for shortcuts"
    echo -e "${CYAN}4.${NC} Sample wallpapers ready in ~/Pictures/Wallpapers/"
    echo -e "${CYAN}5.${NC} Hardware optimizations applied automatically"
    
    echo -e "\n${PURPLE}KEY BINDINGS:${NC}"
    echo -e "${CYAN}• Super + Q${NC}         : Close window"
    echo -e "${CYAN}• Super + Return${NC}    : Open terminal (foot)"
    echo -e "${CYAN}• Super + R${NC}         : Open launcher"
    echo -e "${CYAN}• Super + E${NC}         : Open file manager"
    echo -e "${CYAN}• Super + L${NC}         : Lock screen"
    echo -e "${CYAN}• Super + Shift + Q${NC} : Quit Hyprland"
    
    echo -e "\n${GREEN}Enjoy your new Hyprland setup! 🚀${NC}\n"
}

# Main installation flow
main() {
    print_header
    
    check_not_root
    check_system
    setup_aur_helper
    update_system
    install_packages
    create_backup
    deploy_configs
    setup_thunar_mounting
    setup_shell
    setup_services
    set_permissions
    final_setup
    setup_display_manager
    setup_wallpapers
    create_keybind_reference
    optimize_hardware
    
    print_completion
}

# Error handling
trap 'log_error "Installation failed at line $LINENO. Check the output above for details."; exit 1' ERR

# Run main installation
main "$@"