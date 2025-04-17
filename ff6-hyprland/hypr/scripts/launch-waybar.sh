#!/bin/bash
# Script to properly launch waybar with correct environment variables
# Part of FF6 Hyprland Configuration

# Kill any existing waybar instances
killall waybar 2>/dev/null

# Wait a moment to ensure previous instances are closed
sleep 0.5

# Launch waybar with proper environment
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Launch waybar in the background
waybar &

# Log the launch
echo "Waybar launched at $(date)" >> ~/.config/hypr/waybar-launch.log
