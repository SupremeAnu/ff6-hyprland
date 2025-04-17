#!/bin/bash
# FF6-themed wallpaper switcher script
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Define wallpaper directory
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CURRENT_WALLPAPER="$WALLPAPER_DIR/current.png"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Check if swww is installed
if ! command -v swww &> /dev/null; then
    echo -e "$ERROR swww is not installed. Please install it first."
    echo -e "$INFO You can install it using your package manager."
    echo -e "$INFO For Arch-based systems: yay -S swww"
    exit 1
fi

# Initialize swww if not already running
if ! pgrep -x swww-daemon > /dev/null; then
    echo -e "$INFO Initializing swww..."
    swww init
fi

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    
    # Copy selected wallpaper to current.png
    cp "$wallpaper" "$CURRENT_WALLPAPER"
    
    # Set the wallpaper with swww
    swww img "$wallpaper" \
        --transition-type grow \
        --transition-pos center \
        --transition-duration 1.5
    
    # Play FF6 menu sound if available
    if [ -f "$HOME/.config/hypr/sounds/menu_select.wav" ]; then
        paplay "$HOME/.config/hypr/sounds/menu_select.wav" &
    fi
    
    # Notify user
    notify-send "FF6 Wallpaper" "Wallpaper changed" --icon=preferences-desktop-wallpaper
    
    echo -e "$OK Wallpaper set successfully!"
}

# Check if argument is provided
if [ -n "$1" ] && [ -f "$1" ]; then
    # Set specific wallpaper
    set_wallpaper "$1"
    exit 0
fi

# If no argument or file doesn't exist, show wallpaper selection menu
echo -e "$INFO Opening wallpaper selection menu..."

# Find all wallpapers in the directory
WALLPAPERS=("$WALLPAPER_DIR"/*.{png,jpg,jpeg})

# If no wallpapers found, download some FF6 wallpapers
if [ ${#WALLPAPERS[@]} -eq 0 ] || [ ! -f "${WALLPAPERS[0]}" ]; then
    echo -e "$WARNING No wallpapers found. Downloading FF6 wallpapers..."
    
    # Create temporary directory
    TMP_DIR=$(mktemp -d)
    
    # Download some FF6 wallpapers
    wget -q -O "$TMP_DIR/ff6_world.jpg" "https://images.alphacoders.com/292/292282.jpg"
    wget -q -O "$TMP_DIR/ff6_characters.jpg" "https://images2.alphacoders.com/598/598846.jpg"
    wget -q -O "$TMP_DIR/ff6_logo.png" "https://images3.alphacoders.com/128/1282983.png"
    
    # Move downloaded wallpapers to wallpaper directory
    mv "$TMP_DIR"/*.{jpg,png} "$WALLPAPER_DIR/"
    
    # Clean up
    rmdir "$TMP_DIR"
    
    # Update wallpaper list
    WALLPAPERS=("$WALLPAPER_DIR"/*.{png,jpg,jpeg})
fi

# Use rofi to select wallpaper
selected=$(ls -1 "$WALLPAPER_DIR" | grep -E "\.png$|\.jpg$|\.jpeg$" | rofi -dmenu -i -p "Select Wallpaper")

if [ -n "$selected" ]; then
    set_wallpaper "$WALLPAPER_DIR/$selected"
else
    echo -e "$INFO Wallpaper selection cancelled."
fi
