#!/bin/bash
# FF6 Menu Toggle Script
# Theme: Final Fantasy VI Menu Style
# Created: April 2025

# Define the menu file
MENU_FILE="/tmp/ff6-menu.txt"

# Check if menu is already visible
if [ -f "$MENU_FILE" ]; then
    # Menu is visible, hide it
    rm "$MENU_FILE"
    pkill -f "rofi -dmenu -theme ff6-menu"
    notify-send "FF6 Menu Closed" -i "dialog-information"
    exit 0
fi

# Create menu file to indicate it's visible
touch "$MENU_FILE"

# Define menu options with FF6 style
OPTIONS="󰊠 Magic (Terminal)|kitty
󰊠 Items (Files)|thunar
󰊠 Relics (Browser)|firefox
󰊠 Config (Settings)|~/.config/hypr/scripts/theme-toggle.sh
󰊠 Espers (Wallpapers)|~/.config/hypr/scripts/wallpaper-menu.sh"

# Show menu with rofi
SELECTED=$(echo -e "$OPTIONS" | awk -F'|' '{print $1}' | rofi -dmenu -theme-str '@import "ff6-theme.rasi"' -theme ff6-menu -p "FF6 Menu" -location 1 -xoffset 10 -yoffset 40 -width 20)

# Get the command associated with the selection
if [ -n "$SELECTED" ]; then
    COMMAND=$(echo -e "$OPTIONS" | grep "$SELECTED" | awk -F'|' '{print $2}')
    
    # Execute the command
    if [ -n "$COMMAND" ]; then
        eval "$COMMAND" &
    fi
fi

# Remove the menu file
rm "$MENU_FILE"
