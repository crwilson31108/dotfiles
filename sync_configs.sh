#!/bin/bash

# Sync script to copy active config files to dotfiles repository
# Usage: ./sync_configs.sh

set -e

# Handle running with sudo - use the actual user's home directory
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo ~$SUDO_USER)
else
    USER_HOME="$HOME"
fi

DOTFILES_DIR="$USER_HOME/Documents/Github/dotfiles"
CONFIG_DIR="$USER_HOME/.config"

echo "🔄 Syncing configuration files to dotfiles repository..."

# No backup functionality - direct sync

# Function to sync a config directory (true 1:1 mirror with deletions)
sync_config() {
    local src_dir="$1"
    local dest_dir="$2"
    local name="$3"
    
    if [ -d "$src_dir" ]; then
        echo "📁 Syncing $name (with deletions)..."
        
        # Remove destination if it exists
        if [ -d "$dest_dir" ]; then
            rm -rf "$dest_dir"
        fi
        
        # Copy the directory (complete replacement)
        cp -r "$src_dir" "$dest_dir"
        echo "✅ $name synced successfully (true 1:1 mirror)"
    else
        echo "⚠️  Warning: $src_dir not found, skipping $name"
        
        # If source doesn't exist but destination does, remove destination
        if [ -d "$dest_dir" ]; then
            echo "🗑️  Removing orphaned $name directory (source no longer exists)"
            rm -rf "$dest_dir"
            echo "✅ Orphaned $name directory deleted"
        fi
    fi
}

# Function to sync a single config file (with deletion handling)
sync_file() {
    local src_file="$1"
    local dest_file="$2"
    local name="$3"
    
    if [ -f "$src_file" ]; then
        echo "📄 Syncing $name..."
        
        # Remove destination if it exists
        if [ -f "$dest_file" ]; then
            rm -f "$dest_file"
        fi
        
        # Copy the file
        cp "$src_file" "$dest_file"
        echo "✅ $name synced successfully"
    else
        echo "⚠️  Warning: $src_file not found, skipping $name"
        
        # If source doesn't exist but destination does, remove destination
        if [ -f "$dest_file" ]; then
            echo "🗑️  Removing orphaned $name file (source no longer exists)"
            rm -f "$dest_file"
            echo "✅ Orphaned $name file deleted"
        fi
    fi
}

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# Sync main configuration directories
sync_config "$CONFIG_DIR/hypr" "$DOTFILES_DIR/hypr" "Hyprland"
sync_config "$CONFIG_DIR/foot" "$DOTFILES_DIR/foot" "Foot Terminal"
sync_config "$CONFIG_DIR/fish" "$DOTFILES_DIR/fish" "Fish Shell"
sync_config "$CONFIG_DIR/nvim" "$DOTFILES_DIR/nvim" "Neovim"
sync_config "$CONFIG_DIR/quickshell" "$DOTFILES_DIR/quickshell" "Quickshell"
sync_config "$CONFIG_DIR/qt5ct" "$DOTFILES_DIR/qt5ct" "Qt5 Settings"
sync_config "$CONFIG_DIR/qt6ct" "$DOTFILES_DIR/qt6ct" "Qt6 Settings"
sync_config "$CONFIG_DIR/Kvantum" "$DOTFILES_DIR/Kvantum" "Kvantum Theme"
sync_config "$CONFIG_DIR/gtk-3.0" "$DOTFILES_DIR/gtk-3.0" "GTK 3.0"
sync_config "$CONFIG_DIR/gtk-4.0" "$DOTFILES_DIR/gtk-4.0" "GTK 4.0"
sync_config "$CONFIG_DIR/Thunar" "$DOTFILES_DIR/Thunar" "Thunar"
sync_config "$CONFIG_DIR/xsettingsd" "$DOTFILES_DIR/xsettingsd" "XSettings Daemon"

# Sync individual config files
sync_file "$CONFIG_DIR/starship.toml" "$DOTFILES_DIR/starship.toml" "Starship Prompt"
sync_file "$CONFIG_DIR/rofimoji.rc" "$DOTFILES_DIR/rofimoji.rc" "Rofimoji"
sync_file "$USER_HOME/.config/kdeglobals" "$DOTFILES_DIR/kdeglobals" "KDE Globals"

# Sync GTK 2.0 settings
if [ -f "$USER_HOME/.gtkrc-2.0" ]; then
    echo "📄 Syncing GTK 2.0 settings..."
    mkdir -p "$DOTFILES_DIR/gtk-2.0"
    cp "$USER_HOME/.gtkrc-2.0" "$DOTFILES_DIR/gtk-2.0/gtkrc"
    echo "✅ GTK 2.0 settings synced successfully"
fi

# Sync system-wide configs (if accessible)
echo "📁 Checking system configs..."
if [ -r "/etc/sddm.conf" ]; then
    sync_file "/etc/sddm.conf" "$DOTFILES_DIR/sddm.conf" "SDDM Config"
fi

# Sync greetd/regreet configs
echo "📁 Syncing greetd/regreet configs..."
if [ -d "/etc/greetd" ]; then
    echo "📄 Syncing greetd configuration..."
    mkdir -p "$DOTFILES_DIR/greetd"
    
    # Copy greetd config files (if readable)
    if [ -r "/etc/greetd/config.toml" ]; then
        cp "/etc/greetd/config.toml" "$DOTFILES_DIR/greetd/config.toml"
        echo "✅ greetd config.toml synced"
    fi
    
    if [ -r "/etc/greetd/hyprland.conf" ]; then
        cp "/etc/greetd/hyprland.conf" "$DOTFILES_DIR/greetd/hyprland.conf"
        echo "✅ greetd hyprland.conf synced"
    fi
    
    if [ -r "/etc/greetd/regreet.toml" ]; then
        cp "/etc/greetd/regreet.toml" "$DOTFILES_DIR/greetd/regreet.toml"
        echo "✅ regreet.toml synced"
    fi
    
    if [ -r "/etc/greetd/regreet.css" ]; then
        cp "/etc/greetd/regreet.css" "$DOTFILES_DIR/greetd/regreet.css"
        echo "✅ regreet.css synced"
    fi
    
    echo "✅ greetd/regreet configs synced successfully"
else
    echo "⚠️  Warning: /etc/greetd not found or not accessible, skipping greetd configs"
fi

# Sync the sync script itself to maintain it in the repo
echo "📄 Syncing sync script..."
if [ -f "$DOTFILES_DIR/sync_configs.sh" ]; then
    echo "✅ sync_configs.sh is already in the dotfiles directory"
else
    echo "⚠️  Note: sync_configs.sh should be run from the dotfiles directory"
fi

echo ""
echo "🎉 Sync completed successfully!"
echo "📊 Summary:"
echo "   - Active configs copied to: $DOTFILES_DIR"
echo "   - TRUE 1:1 MIRROR: Deleted files/folders permanently removed"
echo "   - No backups created (direct overwrite)"
echo "   - Orphaned items deleted (no recovery)"
echo "   - Sync script maintained in dotfiles repo"
echo "   - Ready to commit changes to git"
echo ""
echo "📋 Git commit command (copy and paste):"
echo "cd $DOTFILES_DIR && git add . && git commit -m 'Update dotfiles - $(date)' && git push"