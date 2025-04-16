#!/bin/bash
# FF6 Hyprland Keybindings Help Script
# Displays a floating window with keybindings information
# Created: April 2025

# Create a temporary file for the keybindings
KEYBINDS_FILE=$(mktemp)

# Write keybindings to the temporary file
cat > "$KEYBINDS_FILE" << EOF
# FF6 Hyprland Keybindings

## General
Super + Enter = Open Terminal (Magic)
Super + E = Open File Manager (Items)
Super + D = Open Application Launcher (Relics)
Super + Q = Close Window
Super + H = Show This Help Menu
Super + L = Lock Screen
Super + V = Clipboard History
Print = Screenshot Menu

## Window Management
Super + Left/Right/Up/Down = Focus Window in Direction
Super + Shift + Left/Right/Up/Down = Move Window in Direction
Super + Mouse = Move Window
Super + Mouse Scroll = Cycle Through Windows
Super + F = Toggle Fullscreen
Super + T = Toggle Floating
Super + S = Toggle Split Direction
Alt + Tab = Switch Between Windows

## Workspaces
Super + 1-9 = Switch to Workspace
Super + Shift + 1-9 = Move Window to Workspace
Super + Mouse Wheel = Cycle Through Workspaces
Super + Ctrl + Left/Right = Previous/Next Workspace

## Special
Super + B = Toggle Waybar
Super + P = Power Menu
Super + W = Wallpaper Menu
Super + Shift + R = Reload Hyprland Configuration
EOF

# Display the keybindings in a floating kitty window
kitty --class "floating_keybinds" --title "FF6 Keybindings" -e sh -c "cat $KEYBINDS_FILE | less -R; rm $KEYBINDS_FILE"
