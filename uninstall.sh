#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════╗
# ║                    HYPRLAND DOTFILES UNINSTALLER                    ║
# ║                     Restore Previous Configuration                   ║
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
USER_CONFIG="$HOME/.config"

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

# Print header
print_header() {
    echo -e "${RED}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║                        UNINSTALLER                              ║
    ║                  Restore Previous Config                        ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Find backup directories
find_backups() {
    log_section "FINDING BACKUP DIRECTORIES"
    
    local backup_dirs=($(ls -d ~/.dotfiles_backup_* 2>/dev/null | sort -r))
    
    if [ ${#backup_dirs[@]} -eq 0 ]; then
        log_error "No backup directories found!"
        log_info "Cannot restore previous configuration."
        exit 1
    fi
    
    echo -e "${CYAN}Available backup directories:${NC}"
    for i in "${!backup_dirs[@]}"; do
        local dir="${backup_dirs[$i]}"
        local date=$(basename "$dir" | sed 's/\.dotfiles_backup_//')
        echo -e "${YELLOW}$((i+1)).${NC} $dir (created: $date)"
    done
    
    echo -e "\n${YELLOW}Which backup would you like to restore?${NC}"
    read -p "Enter number (1-${#backup_dirs[@]}) or 'q' to quit: " choice
    
    if [ "$choice" = "q" ] || [ "$choice" = "Q" ]; then
        log_info "Uninstall cancelled by user"
        exit 0
    fi
    
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#backup_dirs[@]} ]; then
        log_error "Invalid selection!"
        exit 1
    fi
    
    BACKUP_DIR="${backup_dirs[$((choice-1))]}"
    log_success "Selected backup: $BACKUP_DIR"
}

# Restore configurations
restore_configs() {
    log_section "RESTORING CONFIGURATIONS"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        log_error "Backup directory not found: $BACKUP_DIR"
        exit 1
    fi
    
    # List of config directories to restore
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
    )
    
    # Remove current configs and restore from backup
    for dir in "${config_dirs[@]}"; do
        if [ -d "$BACKUP_DIR/$dir" ]; then
            log_info "Restoring $dir configuration..."
            # Remove current config
            [ -d "$USER_CONFIG/$dir" ] && rm -rf "$USER_CONFIG/$dir"
            # Restore from backup
            cp -r "$BACKUP_DIR/$dir" "$USER_CONFIG/"
            log_success "$dir configuration restored"
        fi
    done
    
    # Restore individual files
    local config_files=(
        "starship.toml"
        "rofimoji.rc"
        "kdeglobals"
        ".gtkrc-2.0"
        ".gtkrc-2.0.mine"
        ".zshrc"
        ".p10k.zsh"
    )
    
    for file in "${config_files[@]}"; do
        if [ -f "$BACKUP_DIR/$file" ]; then
            local dest_path
            if [[ "$file" == .* ]]; then
                dest_path="$HOME/$file"
            else
                dest_path="$USER_CONFIG/$file"
            fi
            
            log_info "Restoring $file..."
            cp "$BACKUP_DIR/$file" "$dest_path"
            log_success "$file restored"
        fi
    done
}

# Cleanup
cleanup_dotfiles() {
    log_section "CLEANUP"
    
    echo -e "${YELLOW}Would you like to remove the dotfiles configurations? (y/N)${NC}"
    read -p "This will delete all dotfiles configs: " remove_choice
    
    if [ "$remove_choice" = "y" ] || [ "$remove_choice" = "Y" ]; then
        # List of directories to remove
        local remove_dirs=(
            "$USER_CONFIG/hypr"
            "$USER_CONFIG/quickshell"
            "$USER_CONFIG/foot"
            "$USER_CONFIG/fish"
        )
        
        for dir in "${remove_dirs[@]}"; do
            if [ -d "$dir" ]; then
                log_info "Removing $dir..."
                rm -rf "$dir"
            fi
        done
        
        # Remove individual files
        [ -f "$USER_CONFIG/starship.toml" ] && rm -f "$USER_CONFIG/starship.toml"
        
        log_success "Dotfiles configurations removed"
    else
        log_info "Keeping dotfiles configurations"
    fi
}

# Main uninstall flow
main() {
    print_header
    
    find_backups
    restore_configs
    cleanup_dotfiles
    
    log_section "UNINSTALL COMPLETE"
    log_success "Your previous configuration has been restored!"
    log_info "Backup used: $BACKUP_DIR"
    log_warning "You may need to logout/login or reboot to see all changes"
}

# Error handling
trap 'log_error "Uninstall failed at line $LINENO. Check the output above for details."; exit 1' ERR

# Run main uninstall
main "$@"