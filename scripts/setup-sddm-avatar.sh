#!/bin/bash

# Script to set up Arch logo as SDDM user avatar
# Called during dotfiles installation

echo "Setting up Arch logo as SDDM avatar..."

# Create the avatar as .face.icon in home directory
if [ -f "/usr/share/pixmaps/archlinux-logo.png" ]; then
    cp /usr/share/pixmaps/archlinux-logo.png ~/.face.icon
    
    # Ensure SDDM can read the file
    setfacl -m u:sddm:x ~/
    setfacl -m u:sddm:r ~/.face.icon
    
    # Also set up in the AccountsService location
    sudo mkdir -p /var/lib/AccountsService/icons/
    sudo cp /usr/share/pixmaps/archlinux-logo.png "/var/lib/AccountsService/icons/$USER.png"
    
    echo "Avatar setup complete!"
else
    echo "Warning: Arch logo not found at /usr/share/pixmaps/archlinux-logo.png"
fi