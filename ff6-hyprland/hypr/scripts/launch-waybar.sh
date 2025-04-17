#!/bin/bash
# Launch Waybar with proper configuration
# Part of the FF6-themed Hyprland configuration

# Kill any running waybar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do
    sleep 1
done

# Set environment variables for proper waybar styling
export FF6_THEME_ENABLED=1
export FF6_THEME_COLOR="#112855"
export FF6_THEME_BORDER="#3B7DFF"
export FF6_THEME_TEXT="#FFFFFF"
export FF6_THEME_HIGHLIGHT="#FFD700"

# Launch waybar with our configuration
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &

echo "Waybar launched with FF6 theme!"
