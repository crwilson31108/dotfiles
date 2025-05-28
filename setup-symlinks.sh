#!/bin/bash
# Script to set up symlinks for dotfiles

DOTFILES_DIR="$HOME/Documents/Github/dotfiles"
CONFIG_DIR="$HOME/.config"

# Backup existing .config if it exists and isn't a symlink
if [ -d "$CONFIG_DIR" ] && [ ! -L "$CONFIG_DIR" ]; then
    echo "Backing up existing .config directory..."
    mv "$CONFIG_DIR" "$CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create symlinks for configurations
echo "Setting up symlinks..."

# Link entire .config directory
if [ -d "$DOTFILES_DIR/.config" ]; then
    ln -sfn "$DOTFILES_DIR/.config" "$CONFIG_DIR"
    echo "✓ Linked entire .config directory"
fi

# .dmenurc
if [ -f "$DOTFILES_DIR/.dmenurc" ]; then
    ln -sfn "$DOTFILES_DIR/.dmenurc" "$HOME/.dmenurc"
    echo "✓ Linked .dmenurc"
fi

# Copy hypr and waybar from root to .config if they exist
if [ -d "$DOTFILES_DIR/hypr" ] && [ ! -d "$DOTFILES_DIR/.config/hypr" ]; then
    echo "Moving hypr config to .config..."
    mv "$DOTFILES_DIR/hypr" "$DOTFILES_DIR/.config/"
fi

if [ -d "$DOTFILES_DIR/waybar" ] && [ ! -d "$DOTFILES_DIR/.config/waybar" ]; then
    echo "Moving waybar config to .config..."
    mv "$DOTFILES_DIR/waybar" "$DOTFILES_DIR/.config/"
fi

echo "Symlinks created successfully!"