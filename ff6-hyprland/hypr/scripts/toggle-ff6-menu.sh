#!/bin/bash
# Script to toggle the FF6-style menu in Hyprland
# Created: April 2025

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
SOUNDS_DIR="$HYPR_DIR/sounds"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Menu Toggle                       ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Play menu open sound
if [ -f "$SOUNDS_DIR/menu_open.wav" ]; then
    if command -v paplay &> /dev/null; then
        paplay "$SOUNDS_DIR/menu_open.wav" &
    elif command -v aplay &> /dev/null; then
        aplay "$SOUNDS_DIR/menu_open.wav" &
    fi
fi

# Check if rofi is installed
if ! command -v rofi &> /dev/null; then
    echo -e "${YELLOW}Error: rofi is not installed. Cannot display menu.${NC}"
    exit 1
fi

# Create a temporary FF6-style menu
cat > /tmp/ff6_menu.rasi << EOF
* {
    background-color: rgba(16, 32, 128, 0.9);
    text-color: #FFFFFF;
    font: "JetBrains Mono Nerd Font 12";
    border-color: #4080FF;
}

window {
    width: 400px;
    border: 2px;
    border-color: #4080FF;
    border-radius: 10px;
    padding: 20px;
}

inputbar {
    children: [prompt, entry];
    padding: 10px;
    border: 2px;
    border-color: #4080FF;
    border-radius: 5px;
    margin: 0 0 10px 0;
}

prompt {
    text-color: #4080FF;
    padding: 0 10px 0 0;
}

entry {
    placeholder: "Enter command...";
}

listview {
    lines: 8;
    scrollbar: true;
    padding: 5px;
    border: 2px;
    border-color: #4080FF;
    border-radius: 5px;
}

element {
    padding: 8px;
    spacing: 10px;
    border-radius: 5px;
}

element selected {
    background-color: #4080FF;
    text-color: #FFFFFF;
}

element-icon {
    size: 24px;
    padding: 0 10px 0 0;
}

scrollbar {
    handle-color: #4080FF;
    handle-width: 8px;
    border-radius: 5px;
}
EOF

# Launch rofi with FF6 theme
rofi -show drun -theme /tmp/ff6_menu.rasi

# Clean up
rm -f /tmp/ff6_menu.rasi

exit 0
