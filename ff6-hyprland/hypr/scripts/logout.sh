#!/bin/bash
# FF6-Themed Hyprland Configuration - Logout Script
# This script provides a logout/power menu with FF6 styling

# Check if wlogout is installed
if ! command -v wlogout &> /dev/null; then
    echo "wlogout is not installed. Please install it first."
    exit 1
fi

# Create wlogout configuration directory if it doesn't exist
mkdir -p ~/.config/wlogout

# Copy FF6-themed wlogout configuration files
cp -f "$HOME/.config/hypr/wlogout/style.css" ~/.config/wlogout/
cp -f "$HOME/.config/hypr/wlogout/layout" ~/.config/wlogout/

# Play FF6 menu sound effect if available
if [ -f "$HOME/.config/hypr/sounds/menu.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/menu.wav" &
fi

# Launch wlogout with FF6 styling
wlogout -b 2 -c 0 -r 0 -m 0 --protocol layer-shell

exit 0
