#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════╗
# ║                    ZRAM SETUP FOR ARCH LINUX                        ║
# ║                 Quick memory compression setup                      ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}[ERROR]${NC} This script should not be run as root"
    echo -e "${BLUE}[INFO]${NC} Please run as regular user: ./setup-zram.sh"
    exit 1
fi

echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}        ZRAM MEMORY COMPRESSION SETUP${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

# Check if zram-generator is installed
if ! pacman -Qi zram-generator &>/dev/null; then
    echo -e "${YELLOW}[INFO]${NC} Installing zram-generator..."
    sudo pacman -S --noconfirm zram-generator
else
    echo -e "${GREEN}[✓]${NC} zram-generator already installed"
fi

# Backup existing configuration if present
if [ -f "/etc/systemd/zram-generator.conf" ]; then
    echo -e "${YELLOW}[INFO]${NC} Backing up existing configuration..."
    sudo cp /etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf.bak
fi

# Create zram configuration
echo -e "${BLUE}[INFO]${NC} Creating zram configuration..."
sudo tee /etc/systemd/zram-generator.conf >/dev/null << 'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 60
EOF

# Reload systemd and restart zram
echo -e "${BLUE}[INFO]${NC} Activating zram..."
sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0.service 2>/dev/null || {
    echo -e "${YELLOW}[WARNING]${NC} Service will be fully active after reboot"
}

# Configure swappiness
echo -e "${BLUE}[INFO]${NC} Setting swappiness to 100 for optimal zram performance..."
echo "vm.swappiness=100" | sudo tee /etc/sysctl.d/99-swappiness.conf >/dev/null
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf >/dev/null 2>&1

# Check status
echo -e "\n${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              ZRAM STATUS${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}\n"

if swapon --show | grep -q zram0; then
    echo -e "${GREEN}[✓]${NC} Zram is active!\n"
    swapon --show
    echo ""
    if command -v zramctl >/dev/null 2>&1; then
        zramctl
    fi
else
    echo -e "${YELLOW}[!]${NC} Zram will be active after reboot"
fi

echo -e "\n${GREEN}[SUCCESS]${NC} Zram setup complete!"
echo -e "${BLUE}[INFO]${NC} Your system now uses compressed RAM for swap"
echo -e "${BLUE}[INFO]${NC} This improves performance and reduces SSD wear\n"