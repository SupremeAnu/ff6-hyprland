#!/bin/bash
# Script to display keybindings help overlay for FF6 Hyprland
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

# Play sound
if [ -f "$HYPR_DIR/scripts/play-sound.sh" ] && [ -f "$SOUNDS_DIR/menu_open.wav" ]; then
    "$HYPR_DIR/scripts/play-sound.sh" menu_open
fi

# Create temporary keybindings file
TMP_FILE="/tmp/ff6_keybindings.txt"

cat > "$TMP_FILE" << EOF
╔══════════════════════════════════════════════════════════════╗
║                 FF6 HYPRLAND KEYBINDINGS                     ║
╚══════════════════════════════════════════════════════════════╝

GENERAL:
  Super + H             Show this help
  Super + Q             Close active window
  Super + Shift + Q     Exit Hyprland
  Super + Space         Toggle floating mode
  Super + F             Toggle fullscreen
  Super + P             Toggle pseudo-tiling
  Super + J/K           Cycle through windows
  Super + 1-9           Switch to workspace 1-9
  Super + Shift + 1-9   Move window to workspace 1-9

APPLICATIONS:
  Super + Enter         Open terminal (Magic)
  Super + E             Open file manager (Items)
  Super + B             Open browser (Relics)
  Super + R             Open application launcher (FF6 Menu)
  Super + V             Open clipboard history
  Super + T             Toggle theme (Light/Dark)

WINDOW MANAGEMENT:
  Super + Left/Right    Focus left/right window
  Super + Up/Down       Focus up/down window
  Super + Shift + Arrows Move window in direction
  Super + Alt + Arrows  Resize window
  Super + Ctrl + Arrows Move window to edge
  Alt + Tab             Switch between windows

SPECIAL:
  Super + W             Open wallpaper menu (Espers)
  Super + Shift + W     Set random wallpaper
  Super + S             Take screenshot menu
  Super + Shift + S     Screenshot selection to clipboard
  Super + L             Lock screen
  Super + Escape        Power menu (Save)

WAYBAR:
  Left-click on icons   Primary action
  Right-click on icons  Secondary action
  Scroll on workspaces  Switch workspaces

Press Escape to close this help window
EOF

# Check if yad is installed
if command -v yad &> /dev/null; then
    # Display with yad
    yad --text-info --filename="$TMP_FILE" \
        --width=700 --height=600 \
        --center \
        --title="FF6 Keybindings" \
        --window-icon="input-keyboard" \
        --fontname="JetBrains Mono 12" \
        --fore="#FFFFFF" --back="#102080" \
        --borders=20 \
        --button="Close:0" \
        --text-align=center \
        --no-markup
elif command -v zenity &> /dev/null; then
    # Display with zenity
    zenity --text-info --filename="$TMP_FILE" \
        --width=700 --height=600 \
        --title="FF6 Keybindings" \
        --font="JetBrains Mono 12"
else
    # Fallback to terminal display
    kitty --class "floating_terminal" -e sh -c "cat $TMP_FILE; echo; echo 'Press any key to close'; read -n 1"
fi

# Clean up
rm -f "$TMP_FILE"

exit 0
