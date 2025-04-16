#!/bin/bash
# FF6 Hyprland Screenshot to Clipboard Script
# Takes a screenshot and copies it to clipboard
# Created: April 2025

# Create screenshots directory if it doesn't exist
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Play FF6 sound effect
~/.config/hypr/scripts/play-sound.sh confirm &

# Take screenshot based on argument
case "$1" in
    "full")
        # Full screen screenshot
        grim "$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        ;;
    "area")
        # Area screenshot
        grim -g "$(slurp)" "$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        ;;
    "window")
        # Active window screenshot
        ACTIVE_WINDOW=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$ACTIVE_WINDOW" "$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        ;;
    *)
        # Default to area screenshot
        grim -g "$(slurp)" "$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        ;;
esac

# Get the latest screenshot
LATEST_SCREENSHOT=$(ls -t "$SCREENSHOT_DIR" | head -n 1)

# Copy to clipboard
wl-copy < "$SCREENSHOT_DIR/$LATEST_SCREENSHOT"

# Notify user
notify-send "Screenshot Captured" "Saved to $SCREENSHOT_DIR and copied to clipboard" -i "$SCREENSHOT_DIR/$LATEST_SCREENSHOT"
