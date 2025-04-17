#!/bin/bash
# XDG Portal Configuration Script for FF6-themed Hyprland
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Check if xdg-desktop-portal-hyprland is installed
if ! pacman -Q xdg-desktop-portal-hyprland &> /dev/null; then
    echo -e "$ERROR xdg-desktop-portal-hyprland is not installed. Please install it first."
    echo -e "$INFO You can install it using your package manager."
    echo -e "$INFO For Arch-based systems: yay -S xdg-desktop-portal-hyprland"
    exit 1
fi

# Create necessary directories
echo -e "$INFO Creating necessary directories..."
mkdir -p ~/.config/xdg-desktop-portal
mkdir -p ~/.config/systemd/user

# Copy XDG portal configuration files
echo -e "$INFO Installing XDG portal configuration..."
cp -v /home/ubuntu/hyprland-crimson-config/xdg/xdg-portal-hyprland.conf ~/.config/xdg-desktop-portal/
cp -v /home/ubuntu/hyprland-crimson-config/xdg/portals.conf ~/.config/xdg-desktop-portal/

# Create environment variables file for Hyprland
echo -e "$INFO Creating environment variables for XDG portal..."
cat > ~/.config/hypr/xdg-portal-env << EOF
# XDG Desktop Portal environment variables for Hyprland
# Part of the FF6-themed Hyprland configuration

# Set XDG environment variables
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Set portal environment variables
export HYPRLAND_INTERACTIVE_SCREENSHOT_SAVEDIR=~/Pictures/Screenshots
EOF

# Add environment variables to hyprland.conf if not already present
if ! grep -q "source = ~/.config/hypr/xdg-portal-env" ~/.config/hypr/hyprland.conf; then
    echo -e "$INFO Adding XDG portal environment variables to hyprland.conf..."
    echo "# Source XDG portal environment variables" >> ~/.config/hypr/hyprland.conf
    echo "source = ~/.config/hypr/xdg-portal-env" >> ~/.config/hypr/hyprland.conf
fi

# Create a script to restart XDG portals
echo -e "$INFO Creating script to restart XDG portals..."
cat > ~/.config/hypr/scripts/restart-xdg-portals.sh << EOF
#!/bin/bash
# Script to restart XDG portals
# Part of the FF6-themed Hyprland configuration

# Kill all existing portal processes
killall xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal 2>/dev/null

# Wait for processes to terminate
sleep 1

# Start portals in the correct order
/usr/lib/xdg-desktop-portal &
sleep 1
/usr/lib/xdg-desktop-portal-gtk &
sleep 1
/usr/lib/xdg-desktop-portal-hyprland &

echo "XDG portals restarted successfully!"
EOF

# Make the script executable
chmod +x ~/.config/hypr/scripts/restart-xdg-portals.sh

# Add the script to hyprland.conf if not already present
if ! grep -q "exec-once = ~/.config/hypr/scripts/restart-xdg-portals.sh" ~/.config/hypr/hyprland.conf; then
    echo -e "$INFO Adding XDG portal restart script to hyprland.conf..."
    echo "# Restart XDG portals on startup" >> ~/.config/hypr/hyprland.conf
    echo "exec-once = ~/.config/hypr/scripts/restart-xdg-portals.sh" >> ~/.config/hypr/hyprland.conf
fi

echo -e "$OK XDG Desktop Portal configuration installed successfully!"
echo -e "$INFO Screen sharing should now work properly in applications like web browsers and video conferencing tools."
echo -e "$INFO If you encounter issues, you can manually restart the portals by running: ~/.config/hypr/scripts/restart-xdg-portals.sh"
