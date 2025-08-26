#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════╗
# ║                    SDDM ROSE PINE THEME INSTALLER                    ║
# ║                 Install SilentSDDM with Rose Pine                    ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Check if running as root
check_not_root() {
    if [ "$EUID" -eq 0 ]; then
        log_error "This script should not be run as root"
        log_info "Please run as regular user: ./install-sddm-theme.sh"
        exit 1
    fi
}

# Print header
print_header() {
    echo -e "${PURPLE}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║            SDDM ROSE PINE THEME INSTALLER                        ║
    ║         Install SilentSDDM with Rose Pine at 2x scale           ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Main installation
install_theme() {
    log_info "Installing SDDM display manager..."
    sudo pacman -S --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia imagemagick
    
    log_info "Downloading SilentSDDM theme..."
    git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM /tmp/SilentSDDM
    
    log_info "Installing theme files..."
    sudo mkdir -p /usr/share/sddm/themes/silent
    sudo cp -rf /tmp/SilentSDDM/* /usr/share/sddm/themes/silent/
    
    log_info "Installing fonts..."
    sudo cp -r /usr/share/sddm/themes/silent/fonts/* /usr/share/fonts/ || true
    sudo fc-cache -fv
    
    log_info "Installing Rose Pine theme configuration..."
    if [ -f "$SCRIPT_DIR/sddm-theme/rose-pine-theme.conf" ]; then
        sudo cp "$SCRIPT_DIR/sddm-theme/rose-pine-theme.conf" /usr/share/sddm/themes/silent/theme.conf
    else
        log_error "Rose Pine theme configuration not found!"
        exit 1
    fi
    
    log_info "Creating Rose Pine gradient background..."
    if command -v magick >/dev/null 2>&1; then
        sudo magick -size 3840x2160 \
            radial-gradient:'#191724-#1f1d2e-#26233a-#2d2438-#eb6f92-#c084aa-#c4a7e7-#403d52-#31748f' \
            /tmp/base_gradient.png
        
        sudo magick /tmp/base_gradient.png \
            \( +clone -channel RGB +noise Uniform -blur 0x0.3 \) \
            -compose Overlay -composite \
            -modulate 100,110,100 \
            /usr/share/sddm/themes/silent/backgrounds/rose-pine-gradient.jpg
        
        sudo rm /tmp/base_gradient.png
    else
        sudo convert -size 3840x2160 xc:'#191724' /usr/share/sddm/themes/silent/backgrounds/rose-pine-gradient.jpg
    fi
    
    log_info "Configuring SDDM..."
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp "$SCRIPT_DIR/etc/sddm.conf.d/10-theme.conf" /etc/sddm.conf.d/
    
    log_info "Creating Hyprland session entry..."
    if [ ! -f "/usr/share/wayland-sessions/hyprland.desktop" ]; then
        sudo tee /usr/share/wayland-sessions/hyprland.desktop >/dev/null << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
    fi
    
    log_info "Enabling SDDM service..."
    sudo systemctl enable sddm
    
    # Clean up
    rm -rf /tmp/SilentSDDM
    
    log_success "SDDM Rose Pine theme installed successfully!"
    echo -e "${YELLOW}Note: The theme is configured with 2x scale for HiDPI displays.${NC}"
    echo -e "${GREEN}Restart your system to use the new login screen.${NC}"
}

# Main execution
main() {
    print_header
    check_not_root
    install_theme
}

# Run main
main "$@"