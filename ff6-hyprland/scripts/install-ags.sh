#!/bin/bash
# FF6-themed AGS installation script
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Check if AGS is installed
if ! command -v ags &> /dev/null; then
    echo -e "$ERROR AGS (Aylur's GTK Shell) is not installed. Please install it first."
    echo -e "$INFO You can install it using your package manager or from source."
    echo -e "$INFO For Arch-based systems: yay -S ags"
    exit 1
fi

# Create necessary directories
echo -e "$INFO Creating necessary directories..."
mkdir -p ~/.config/ags/modules/overview
mkdir -p ~/.config/ags/modules/.configuration
mkdir -p ~/.config/ags/user
mkdir -p ~/.config/ags/sounds

# Copy AGS configuration files
echo -e "$INFO Installing FF6-themed AGS configuration..."
cp -v /home/ubuntu/hyprland-crimson-config/ags/config.js ~/.config/ags/
cp -v /home/ubuntu/hyprland-crimson-config/ags/variables.js ~/.config/ags/
cp -v /home/ubuntu/hyprland-crimson-config/ags/user_options.js ~/.config/ags/

# Copy module files
echo -e "$INFO Installing AGS modules..."
cp -v /home/ubuntu/hyprland-crimson-config/ags/modules/overview/main.js ~/.config/ags/modules/overview/
cp -v /home/ubuntu/hyprland-crimson-config/ags/modules/.configuration/user_options.js ~/.config/ags/modules/.configuration/

# Copy style files
echo -e "$INFO Installing AGS styles..."
cp -v /home/ubuntu/hyprland-crimson-config/ags/user/style.css ~/.config/ags/user/

# Copy sound effects if they exist
if [ -d "/home/ubuntu/hyprland-crimson-config/sounds" ]; then
    echo -e "$INFO Installing sound effects..."
    cp -v /home/ubuntu/hyprland-crimson-config/sounds/*.wav ~/.config/ags/sounds/
fi

# Add AGS to autostart in hyprland.conf if it doesn't exist
if ! grep -q "exec-once = ags" ~/.config/hypr/hyprland.conf; then
    echo -e "$INFO Adding AGS to autostart in hyprland.conf..."
    echo "# Start Aylur's GTK Shell for desktop overview" >> ~/.config/hypr/hyprland.conf
    echo "exec-once = ags" >> ~/.config/hypr/hyprland.conf
fi

# Add keybinding for overview if it doesn't exist
if ! grep -q "bind = SUPER, O, exec, ags -t overview" ~/.config/hypr/hyprland.conf; then
    echo -e "$INFO Adding overview keybinding to hyprland.conf..."
    echo "# AGS overview binding" >> ~/.config/hypr/hyprland.conf
    echo "bind = SUPER, O, exec, ags -t overview" >> ~/.config/hypr/hyprland.conf
fi

echo -e "$OK FF6-themed AGS configuration installed successfully!"
echo -e "$INFO You can now access the desktop overview using Super+O"
