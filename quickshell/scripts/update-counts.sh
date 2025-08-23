#!/bin/bash
# System Update Count Checker for Quickshell
# Checks for available updates and writes JSON to runtime directory
# Used by Quickshell's update button in the Tools Drawer
export LC_ALL=C LANG=C

repo=0 aur=0 flatpak=0

# Check pacman updates
if command -v checkupdates >/dev/null 2>&1; then
  repo=$(checkupdates 2>/dev/null | wc -l | tr -d ' ')
elif command -v pacman >/dev/null 2>&1; then
  repo=$(pacman -Sup 2>/dev/null | grep -E '\.pkg\.tar\.(zst|xz)' | wc -l | tr -d ' ')
fi

# Check AUR updates
if command -v paru >/dev/null 2>&1; then
  aur=$(paru -Qua --color=never 2>/dev/null | wc -l | tr -d ' ')
elif command -v yay >/dev/null 2>&1; then
  aur=$(yay -Qua --color=never 2>/dev/null | wc -l | tr -d ' ')
fi

# Check Flatpak updates
if command -v flatpak >/dev/null 2>&1; then
  flatpak=$(flatpak remote-ls --updates 2>/dev/null | wc -l | tr -d ' ')
fi

total=$((repo + aur + flatpak))
json=$(printf '{"total":%d,"repo":%d,"aur":%d,"flatpak":%d}\n' "$total" "$repo" "$aur" "$flatpak")

# Write to runtime directory
outdir="/run/user/$(id -u)"
printf '%s' "$json" > "$outdir/qs-updates.json"