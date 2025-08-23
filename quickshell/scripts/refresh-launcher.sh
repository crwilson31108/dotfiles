#!/bin/bash

# Generate apps database for quickshell launcher
# Creates a fast, parseable JSON file with app data

CACHE_DIR="$HOME/.cache/quickshell"
APPS_DB="$CACHE_DIR/apps.json"
TEMP_DB="$APPS_DB.tmp"

# Create cache directory
mkdir -p "$CACHE_DIR"

# Desktop entry directories
dirs=(
    "/usr/share/applications"
    "/usr/local/share/applications" 
    "/var/lib/flatpak/exports/share/applications"
    "$HOME/.local/share/applications"
    "/var/lib/snapd/desktop/applications"
)

# Function to clean exec command
clean_exec() {
    local exec_cmd="$1"
    # Remove desktop entry field codes (%f, %F, %u, %U, %d, %D, %n, %N, %i, %c, %k, %v, %m)
    exec_cmd=$(echo "$exec_cmd" | sed -E 's/ %[fFuUdDnNickvm]//g')
    # Remove trailing spaces
    exec_cmd=$(echo "$exec_cmd" | sed 's/[[:space:]]*$//')
    echo "$exec_cmd"
}

# Function to get command for execution (handles snap, flatpak wrappers)
get_command() {
    local exec_cmd="$1"
    local desktop_file="$2"
    
    # Clean the exec command first
    exec_cmd=$(clean_exec "$exec_cmd")
    
    # For snap applications, extract snap name from desktop file path
    if [[ "$desktop_file" =~ /var/lib/snapd/desktop/applications/ ]]; then
        local snap_name=$(basename "$desktop_file" .desktop | cut -d'_' -f1)
        echo "snap run $snap_name"
        return
    fi
    
    # For flatpak applications, return the full flatpak command
    if [[ "$desktop_file" =~ /var/lib/flatpak/exports/share/applications/ ]]; then
        echo "$exec_cmd"
        return
    fi
    
    # For regular applications, return the cleaned exec
    echo "$exec_cmd"
}

# Start JSON array
echo "[" > "$TEMP_DB"

first=true

# Process each directory
for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        # Find all .desktop files
        while IFS= read -r -d '' desktop_file; do
            # Skip if NoDisplay is true
            if grep -q "^NoDisplay=true" "$desktop_file" 2>/dev/null; then
                continue
            fi
            
            # Skip if malformed (doesn't start with [Desktop Entry])
            if ! grep -q "^\[Desktop Entry\]" "$desktop_file" 2>/dev/null; then
                continue
            fi
            
            # Extract fields, handling quotes and special characters
            name=$(grep -m 1 "^Name=" "$desktop_file" 2>/dev/null | cut -d= -f2- | sed 's/"/\\"/g' | sed "s/'/\\'/g")
            generic_name=$(grep -m 1 "^GenericName=" "$desktop_file" 2>/dev/null | cut -d= -f2- | sed 's/"/\\"/g' | sed "s/'/\\'/g")
            comment=$(grep -m 1 "^Comment=" "$desktop_file" 2>/dev/null | cut -d= -f2- | sed 's/"/\\"/g' | sed "s/'/\\'/g")
            icon=$(grep -m 1 "^Icon=" "$desktop_file" 2>/dev/null | cut -d= -f2- | sed 's/"/\\"/g')
            exec_raw=$(grep -m 1 "^Exec=" "$desktop_file" 2>/dev/null | cut -d= -f2-)
            categories=$(grep -m 1 "^Categories=" "$desktop_file" 2>/dev/null | cut -d= -f2-)
            
            # Get cleaned command for execution
            exec_cmd=$(get_command "$exec_raw" "$desktop_file")
            
            # Skip if no name
            if [ -z "$name" ]; then
                continue
            fi
            
            # Generate entry ID
            entry_id=$(basename "$desktop_file" .desktop)
            
            # Add comma if not first entry
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$TEMP_DB"
            fi
            
            # Write JSON entry
            cat >> "$TEMP_DB" <<EOF
  {
    "id": "$entry_id",
    "name": "$name",
    "genericName": "$generic_name",
    "comment": "$comment",
    "icon": "$icon",
    "exec": "$exec_cmd",
    "categories": "$categories",
    "desktopFile": "$desktop_file",
    "timestamp": $(date +%s)
  }
EOF
        done < <(find "$dir" -maxdepth 1 -name "*.desktop" -print0 2>/dev/null)
    fi
done

# Add AppImages from common locations
appimage_dirs=(
    "$HOME/Applications"
    "$HOME/AppImages"
    "$HOME/.local/bin"
    "/opt"
)

for dir in "${appimage_dirs[@]}"; do
    if [ -d "$dir" ]; then
        while IFS= read -r -d '' appimage_file; do
            # Skip if not executable
            if [ ! -x "$appimage_file" ]; then
                continue
            fi
            
            # Extract AppImage info (basic fallback)
            filename=$(basename "$appimage_file")
            name="${filename%.*}"  # Remove extension
            
            # Add comma if not first entry
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$TEMP_DB"
            fi
            
            # Write JSON entry for AppImage
            cat >> "$TEMP_DB" <<EOF
  {
    "id": "appimage-$name",
    "name": "$name",
    "genericName": "AppImage Application",
    "comment": "Portable application",
    "icon": "application-x-executable",
    "exec": "$appimage_file",
    "categories": "Utility;",
    "desktopFile": "",
    "timestamp": $(date +%s)
  }
EOF
        done < <(find "$dir" -maxdepth 1 -name "*.AppImage" -print0 2>/dev/null)
    fi
done

# Close JSON array
echo -e "\n]" >> "$TEMP_DB"

# Validate and move
if command -v jq &> /dev/null; then
    if jq empty "$TEMP_DB" 2>/dev/null; then
        mv "$TEMP_DB" "$APPS_DB"
        echo "Apps database updated: $(jq length "$APPS_DB") apps"
    else
        echo "Error: Invalid JSON generated"
        rm -f "$TEMP_DB"
        exit 1
    fi
else
    # No validation, just move
    mv "$TEMP_DB" "$APPS_DB"
    echo "Apps database updated (validation skipped)"
fi

# Create signal file for quickshell
touch "$CACHE_DIR/.refresh_signal"

exit 0