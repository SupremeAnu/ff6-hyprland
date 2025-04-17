#!/bin/bash
# FF6-themed Hyprlock configuration installer
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Check if hyprlock is installed
if ! command -v hyprlock &> /dev/null; then
    echo -e "$ERROR Hyprlock is not installed. Please install it first."
    echo -e "$INFO You can install it using your package manager or from source."
    exit 1
fi

# Create necessary directories
echo -e "$INFO Creating necessary directories..."
mkdir -p ~/.config/hypr/wallpaper_effects
mkdir -p ~/.config/hypr/scripts

# Copy hyprlock configuration
echo -e "$INFO Installing FF6-themed hyprlock configuration..."
cp -v /home/ubuntu/hyprland-crimson-config/hypr/hyprlock.conf ~/.config/hypr/
cp -v /home/ubuntu/hyprland-crimson-config/hypr/hypridle.conf ~/.config/hypr/

# Copy lock screen scripts
echo -e "$INFO Installing lock screen scripts..."
cp -v /home/ubuntu/hyprland-crimson-config/hypr/scripts/lockscreen.sh ~/.config/hypr/scripts/
chmod +x ~/.config/hypr/scripts/lockscreen.sh

# Create wallpaper effects directory if it doesn't exist
if [ ! -d ~/.config/hypr/wallpaper_effects ]; then
    mkdir -p ~/.config/hypr/wallpaper_effects
fi

# Copy current wallpaper to wallpaper_effects directory if it doesn't exist
if [ ! -f ~/.config/hypr/wallpaper_effects/.wallpaper_current ]; then
    echo -e "$INFO Setting up default wallpaper for lock screen..."
    cp -v /home/ubuntu/hyprland-crimson-config/wallpapers/ff6-menu-bg.png ~/.config/hypr/wallpaper_effects/.wallpaper_current
fi

# Add keybinding to hyprland.conf if it doesn't exist
if ! grep -q "SUPER, L, exec, hyprlock" ~/.config/hypr/hyprland.conf; then
    echo -e "$INFO Adding lock screen keybinding to hyprland.conf..."
    echo "# Lock screen binding" >> ~/.config/hypr/hyprland.conf
    echo "bind = SUPER, L, exec, hyprlock" >> ~/.config/hypr/hyprland.conf
fi

# Add hypridle to autostart if it doesn't exist
if ! grep -q "exec-once = hypridle" ~/.config/hypr/hyprland.conf; then
    echo -e "$INFO Adding hypridle to autostart in hyprland.conf..."
    echo "# Start hypridle for automatic screen locking" >> ~/.config/hypr/hyprland.conf
    echo "exec-once = hypridle" >> ~/.config/hypr/hyprland.conf
fi

echo -e "$OK FF6-themed hyprlock configuration installed successfully!"
echo -e "$INFO You can now lock your screen using Super+L"
