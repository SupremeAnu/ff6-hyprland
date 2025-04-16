#!/bin/bash
# Random Wallpaper Script for Hyprland
# Theme: Crimson Gradient
# Created: April 2025

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CURRENT_LINK="$WALLPAPER_DIR/current.png"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Get a random wallpaper
get_random_wallpaper() {
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | 
    grep -v "current.png" | shuf -n 1
}

# Set the wallpaper
random_wallpaper=$(get_random_wallpaper)

if [[ -n "$random_wallpaper" ]]; then
    # Create symbolic link to current wallpaper
    ln -sf "$random_wallpaper" "$CURRENT_LINK"
    
    # Set the wallpaper using swww
    swww img "$random_wallpaper" --transition-type grow --transition-pos 0.9,0.1 --transition-duration 2
    
    # Notify user
    notify-send "Random Wallpaper" "Wallpaper set to $(basename "$random_wallpaper")" -i "$random_wallpaper"
else
    notify-send "Error" "No wallpapers found in $WALLPAPER_DIR" -i "dialog-error"
fi
