#!/bin/bash

# Caelestia Shell Installation Script
set -e

echo "Installing Caelestia Shell..."

# Check if we're in the right directory
if [ ! -f "assets/beat_detector.cpp" ]; then
    echo "Error: Please run this script from the caelestia shell directory"
    exit 1
fi

# Install aubio development headers if not present
if [ ! -d "/usr/include/aubio" ]; then
    echo "Installing aubio development headers..."
    sudo pacman -S --needed aubio
fi

# Compile beat detector
echo "Compiling beat detector..."
g++ -std=c++17 -Wall -Wextra \
    -I/usr/include/pipewire-0.3 \
    -I/usr/include/spa-0.2 \
    -I/usr/include/aubio \
    -o beat_detector \
    assets/beat_detector.cpp \
    -lpipewire-0.3 -laubio

# Install beat detector
echo "Installing beat detector..."
sudo mkdir -p /usr/lib/caelestia
sudo mv beat_detector /usr/lib/caelestia/beat_detector
sudo chmod +x /usr/lib/caelestia/beat_detector

echo "Installation complete!"
echo ""
echo "To start the shell, run: caelestia shell -d"
echo "Or: qs -c caelestia"
echo ""
echo "Configure your settings in ~/.config/caelestia/shell.json"