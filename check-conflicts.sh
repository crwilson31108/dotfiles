#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════╗
# ║                    PACKAGE CONFLICT CHECKER                         ║
# ║                  Identify problematic packages                      ║
# ╚══════════════════════════════════════════════════════════════════════╝

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Checking for common package conflicts...${NC}\n"

# Common conflicts to check
conflicts=(
    "code:visual-studio-code-bin"
    "discord:discord-canary:discord-ptb"
    "firefox:firefox-nightly:firefox-developer-edition"
    "chromium:google-chrome:google-chrome-dev"
    "thunar:pcmanfm:nautilus"
)

found_conflicts=false

for conflict_group in "${conflicts[@]}"; do
    IFS=':' read -ra packages <<< "$conflict_group"
    installed=()
    
    # Check which packages in this conflict group are installed
    for package in "${packages[@]}"; do
        if pacman -Qi "$package" &>/dev/null; then
            installed+=("$package")
        fi
    done
    
    # Report conflicts if more than one package is installed
    if [ ${#installed[@]} -gt 1 ]; then
        echo -e "${RED}CONFLICT DETECTED:${NC}"
        echo -e "  The following conflicting packages are installed:"
        for pkg in "${installed[@]}"; do
            echo -e "  ${YELLOW}• $pkg${NC}"
        done
        echo -e "  ${BLUE}Recommendation:${NC} Keep only one of these packages"
        echo ""
        found_conflicts=true
    fi
done

if [ "$found_conflicts" = false ]; then
    echo -e "${GREEN}✅ No common package conflicts detected!${NC}"
else
    echo -e "${YELLOW}Run the install script to automatically resolve these conflicts.${NC}"
fi

echo ""
echo -e "${BLUE}Checking for orphaned packages...${NC}"
orphans=$(pacman -Qtdq 2>/dev/null)
if [ -n "$orphans" ]; then
    echo -e "${YELLOW}Found orphaned packages:${NC}"
    echo "$orphans" | while read -r pkg; do
        echo -e "  ${YELLOW}• $pkg${NC}"
    done
    echo -e "\n${BLUE}To remove orphans:${NC} sudo pacman -Rns \$(pacman -Qtdq)"
else
    echo -e "${GREEN}✅ No orphaned packages found!${NC}"
fi