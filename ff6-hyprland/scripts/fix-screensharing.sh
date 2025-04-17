#!/bin/bash
# Fix Screen Sharing Script for FF6-themed Hyprland
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

echo -e "$INFO Fixing screen sharing for FF6-themed Hyprland..."

# Check if required packages are installed
MISSING_PKGS=""
for pkg in xdg-desktop-portal-hyprland xdg-desktop-portal-gtk slurp; do
    if ! pacman -Q $pkg &> /dev/null; then
        MISSING_PKGS="$MISSING_PKGS $pkg"
    fi
done

if [ -n "$MISSING_PKGS" ]; then
    echo -e "$WARNING The following packages are required but not installed:$MISSING_PKGS"
    echo -e "$INFO Please install them using your package manager."
    echo -e "$INFO For Arch-based systems: yay -S$MISSING_PKGS"
    echo -e "$WARNING Continuing anyway, but screen sharing may not work properly."
fi

# Create necessary directories
mkdir -p ~/.config/hypr/scripts

# Create a script to fix screen sharing
cat > ~/.config/hypr/scripts/fix-screensharing.sh << EOF
#!/bin/bash
# Script to fix screen sharing in Hyprland
# Part of the FF6-themed Hyprland configuration

# Kill all existing portal processes
killall xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal 2>/dev/null

# Wait for processes to terminate
sleep 2

# Start portals in the correct order
/usr/lib/xdg-desktop-portal &
sleep 2
/usr/lib/xdg-desktop-portal-gtk &
sleep 2
/usr/lib/xdg-desktop-portal-hyprland &

# Play FF6 confirmation sound if available
if [ -f "$HOME/.config/hypr/sounds/confirm.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/confirm.wav" &
fi

# Notify user
notify-send "Screen Sharing Fixed" "XDG portals have been restarted successfully!" --icon=dialog-information
EOF

# Make the script executable
chmod +x ~/.config/hypr/scripts/fix-screensharing.sh

# Create a desktop entry for the fix script
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/fix-screensharing.desktop << EOF
[Desktop Entry]
Type=Application
Name=Fix Screen Sharing
Comment=Fix screen sharing for Hyprland
Exec=~/.config/hypr/scripts/fix-screensharing.sh
Icon=preferences-system
Terminal=false
Categories=Utility;
EOF

echo -e "$OK Screen sharing fix script created successfully!"
echo -e "$INFO You can run it manually with: ~/.config/hypr/scripts/fix-screensharing.sh"
echo -e "$INFO Or launch it from your application menu as 'Fix Screen Sharing'"
echo -e "$INFO This script will restart the XDG portals to fix screen sharing issues."
