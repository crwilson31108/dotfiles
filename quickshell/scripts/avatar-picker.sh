#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Supported image formats
FILTER="*.jpg *.jpeg *.png *.webp"

# Try different file pickers in order of preference
if command_exists kdialog; then
    # KDE file dialog
    FILE=$(kdialog --getopenfilename "$HOME" "Image Files (*.jpg *.jpeg *.png *.webp)|*.jpg *.jpeg *.png *.webp" --title "Select Avatar Image")
elif command_exists zenity; then
    # GNOME/GTK file dialog
    FILE=$(zenity --file-selection --title="Select Avatar Image" --file-filter="Image files | *.jpg *.jpeg *.png *.webp" --file-filter="All files | *")
elif command_exists yad; then
    # Yet Another Dialog
    FILE=$(yad --file --title="Select Avatar Image" --file-filter="Image files|*.jpg *.jpeg *.png *.webp" --file-filter="All files|*")
else
    # Fallback to notify user
    notify-send -a "quickshell" -u critical "No file picker found" "Please install kdialog, zenity, or yad"
    exit 1
fi

# Check if a file was selected
if [ -n "$FILE" ]; then
    echo "Selected file: $FILE" >&2
    # Check if file exists
    if [ -f "$FILE" ]; then
        echo "File exists, copying to ~/.face" >&2
        # Copy to .face
        cp "$FILE" "$HOME/.face"
        
        # Verify the copy worked
        if [ -f "$HOME/.face" ]; then
            echo "Successfully copied to ~/.face" >&2
            # Get just the filename for notification
            FILENAME=$(basename "$FILE")
            
            # Send notification
            notify-send -a "quickshell" -u low "Avatar Updated" "Profile picture changed to $FILENAME"
            
            # Exit with success
            exit 0
        else
            echo "Failed to copy file" >&2
            notify-send -a "quickshell" -u critical "Copy failed" "Failed to copy avatar image"
            exit 1
        fi
    else
        echo "File does not exist: $FILE" >&2
        notify-send -a "quickshell" -u critical "File not found" "The selected file does not exist"
        exit 1
    fi
else
    echo "No file selected (user cancelled)" >&2
    # User cancelled
    exit 0
fi