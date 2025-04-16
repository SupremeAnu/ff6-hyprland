#!/bin/bash
# Set Wallpaper Script for Hyprland
# Theme: Crimson Gradient
# Created: April 2025

# Check if file exists
if [ ! -f "$1" ]; then
    notify-send "Error" "File does not exist: $1" -i "dialog-error"
    exit 1
fi

# Check if file is an image
if [[ ! "$1" =~ \.(jpg|jpeg|png|svg|webp)$ ]]; then
    notify-send "Error" "Not a supported image file: $1" -i "dialog-error"
    exit 1
fi

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CURRENT_LINK="$WALLPAPER_DIR/current.png"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Copy the image to wallpaper directory if it's not already there
filename=$(basename "$1")
if [ ! -f "$WALLPAPER_DIR/$filename" ]; then
    cp "$1" "$WALLPAPER_DIR/"
fi

# Create symbolic link to current wallpaper
ln -sf "$WALLPAPER_DIR/$filename" "$CURRENT_LINK"

# Set the wallpaper using swww
swww img "$WALLPAPER_DIR/$filename" --transition-type grow --transition-pos 0.9,0.1 --transition-duration 2

# Notify user
notify-send "Wallpaper Changed" "Wallpaper set to $filename" -i "$WALLPAPER_DIR/$filename"
