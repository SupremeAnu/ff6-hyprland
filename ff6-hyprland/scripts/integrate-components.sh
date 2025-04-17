#!/bin/bash
# FF6-themed Hyprland Integration Script
# This script ensures all components of the FF6-themed Hyprland configuration work together seamlessly

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Define configuration directories
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
KITTY_DIR="$CONFIG_DIR/kitty"
SWAPPY_DIR="$CONFIG_DIR/swappy"
SWAYNC_DIR="$CONFIG_DIR/swaync"
AGS_DIR="$CONFIG_DIR/ags"
XDG_DIR="$CONFIG_DIR/xdg-desktop-portal"
SOUNDS_DIR="$HYPR_DIR/sounds"
SPRITES_DIR="$CONFIG_DIR/sprites"

# Print header
echo -e "${INFO} FF6-themed Hyprland Integration Script"
echo -e "${INFO} ======================================="

# Function to check if a directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${OK} Directory $1 exists"
        return 0
    else
        echo -e "${ERROR} Directory $1 does not exist"
        return 1
    fi
}

# Function to check if a file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${OK} File $1 exists"
        return 0
    else
        echo -e "${ERROR} File $1 does not exist"
        return 1
    fi
}

# Function to check if a command exists
check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${OK} Command $1 is available"
        return 0
    else
        echo -e "${ERROR} Command $1 is not available"
        return 1
    fi
}

# Check for required directories
echo -e "${INFO} Checking required directories..."
MISSING_DIRS=0

for dir in "$HYPR_DIR" "$WAYBAR_DIR" "$ROFI_DIR" "$KITTY_DIR" "$SWAPPY_DIR" "$SWAYNC_DIR" "$AGS_DIR" "$XDG_DIR" "$SOUNDS_DIR" "$SPRITES_DIR"; do
    if ! check_dir "$dir"; then
        MISSING_DIRS=$((MISSING_DIRS+1))
    fi
done

if [ $MISSING_DIRS -gt 0 ]; then
    echo -e "${WARNING} $MISSING_DIRS directories are missing. Some features may not work correctly."
else
    echo -e "${OK} All required directories are present."
fi

# Check for critical files
echo -e "${INFO} Checking critical files..."
MISSING_FILES=0

CRITICAL_FILES=(
    "$HYPR_DIR/hyprland.conf"
    "$HYPR_DIR/colors.conf"
    "$HYPR_DIR/animations.conf"
    "$HYPR_DIR/hyprlock.conf"
    "$HYPR_DIR/hypridle.conf"
    "$WAYBAR_DIR/config-top.jsonc"
    "$WAYBAR_DIR/config-bottom.jsonc"
    "$WAYBAR_DIR/style.css"
    "$KITTY_DIR/kitty.conf"
    "$KITTY_DIR/ff_sprite.py"
    "$ROFI_DIR/config.rasi"
    "$ROFI_DIR/ff6.rasi"
    "$SWAPPY_DIR/config"
    "$SWAYNC_DIR/config.json"
    "$SWAYNC_DIR/style.css"
    "$AGS_DIR/config.js"
    "$XDG_DIR/portals.conf"
)

for file in "${CRITICAL_FILES[@]}"; do
    if ! check_file "$file"; then
        MISSING_FILES=$((MISSING_FILES+1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo -e "${WARNING} $MISSING_FILES critical files are missing. Some features may not work correctly."
else
    echo -e "${OK} All critical files are present."
fi

# Check for required commands
echo -e "${INFO} Checking required commands..."
MISSING_COMMANDS=0

REQUIRED_COMMANDS=(
    "hyprctl"
    "waybar"
    "rofi"
    "kitty"
    "swappy"
    "swaync-client"
    "swww"
    "brightnessctl"
    "pamixer"
    "python3"
    "convert"
)

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! check_command "$cmd"; then
        MISSING_COMMANDS=$((MISSING_COMMANDS+1))
    fi
done

if [ $MISSING_COMMANDS -gt 0 ]; then
    echo -e "${WARNING} $MISSING_COMMANDS required commands are missing. Some features may not work correctly."
else
    echo -e "${OK} All required commands are available."
fi

# Ensure scripts are executable
echo -e "${INFO} Ensuring scripts are executable..."
find "$HYPR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$WAYBAR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$KITTY_DIR" -type f -name "*.py" -exec chmod +x {} \;
find "$AGS_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
echo -e "${OK} All scripts are now executable."

# Create necessary directories if they don't exist
echo -e "${INFO} Creating necessary directories..."
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$HYPR_DIR/themes"
mkdir -p "$HYPR_DIR/wallpapers"
echo -e "${OK} Necessary directories created."

# Set up environment variables
echo -e "${INFO} Setting up environment variables..."
ENV_FILE="$HOME/.profile"

# Check if .profile exists, create if not
if [ ! -f "$ENV_FILE" ]; then
    touch "$ENV_FILE"
fi

# Add environment variables if not already present
if ! grep -q "HYPRLAND_FF6_THEME" "$ENV_FILE"; then
    echo -e "${INFO} Adding environment variables to $ENV_FILE..."
    cat >> "$ENV_FILE" << EOF

# Hyprland FF6 Theme environment variables
export HYPRLAND_FF6_THEME=1
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland,x11
export MOZ_ENABLE_WAYLAND=1
export XCURSOR_THEME=AtmaWeapon
export XCURSOR_SIZE=24
EOF
    echo -e "${OK} Environment variables added."
else
    echo -e "${OK} Environment variables already set."
fi

# Create keybindings file if it doesn't exist
if [ ! -f "$HYPR_DIR/keybindings.conf" ]; then
    echo -e "${INFO} Creating keybindings configuration..."
    cat > "$HYPR_DIR/keybindings.conf" << EOF
# FF6-themed Hyprland keybindings

# Terminal
bind = SUPER, Return, exec, kitty

# Application launcher
bind = SUPER, d, exec, rofi -show drun

# File manager
bind = SUPER, e, exec, thunar

# Browser
bind = SUPER, b, exec, firefox

# Screenshot
bind = , Print, exec, $HYPR_DIR/scripts/screenshot-clipboard.sh
bind = SHIFT, Print, exec, $HYPR_DIR/scripts/screenshot-save.sh
bind = CTRL, Print, exec, $HYPR_DIR/scripts/screenshot-swappy.sh

# Volume control
bind = , XF86AudioRaiseVolume, exec, $HYPR_DIR/scripts/volume.sh --inc
bind = , XF86AudioLowerVolume, exec, $HYPR_DIR/scripts/volume.sh --dec
bind = , XF86AudioMute, exec, $HYPR_DIR/scripts/volume.sh --toggle
bind = , XF86AudioMicMute, exec, $HYPR_DIR/scripts/volume.sh --toggle-mic

# Brightness control
bind = , XF86MonBrightnessUp, exec, $HYPR_DIR/scripts/brightness.sh --inc
bind = , XF86MonBrightnessDown, exec, $HYPR_DIR/scripts/brightness.sh --dec

# Theme toggle
bind = SUPER, t, exec, $HYPR_DIR/scripts/toggle-theme.sh

# Wallpaper switcher
bind = SUPER, w, exec, $HYPR_DIR/scripts/wallpaper-switcher.sh

# FF6 menu toggle
bind = SUPER, m, exec, $HYPR_DIR/scripts/toggle-ff6-menu.sh

# Lock screen
bind = SUPER, l, exec, $HYPR_DIR/scripts/lockscreen.sh

# Workspace navigation
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5
bind = SUPER, 6, workspace, 6
bind = SUPER, 7, workspace, 7
bind = SUPER, 8, workspace, 8
bind = SUPER, 9, workspace, 9
bind = SUPER, 0, workspace, 10

# Move window to workspace
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
bind = SUPER SHIFT, 3, movetoworkspace, 3
bind = SUPER SHIFT, 4, movetoworkspace, 4
bind = SUPER SHIFT, 5, movetoworkspace, 5
bind = SUPER SHIFT, 6, movetoworkspace, 6
bind = SUPER SHIFT, 7, movetoworkspace, 7
bind = SUPER SHIFT, 8, movetoworkspace, 8
bind = SUPER SHIFT, 9, movetoworkspace, 9
bind = SUPER SHIFT, 0, movetoworkspace, 10

# Window management
bind = SUPER, Q, killactive,
bind = SUPER SHIFT, Q, exit,
bind = SUPER, F, fullscreen,
bind = SUPER, Space, togglefloating,
bind = SUPER, P, pseudo,
bind = SUPER, Tab, cyclenext,
bind = SUPER SHIFT, Tab, cyclenext, prev

# Move focus
bind = SUPER, left, movefocus, l
bind = SUPER, right, movefocus, r
bind = SUPER, up, movefocus, u
bind = SUPER, down, movefocus, d

# Move window
bind = SUPER SHIFT, left, movewindow, l
bind = SUPER SHIFT, right, movewindow, r
bind = SUPER SHIFT, up, movewindow, u
bind = SUPER SHIFT, down, movewindow, d

# Resize window
bind = SUPER CTRL, left, resizeactive, -20 0
bind = SUPER CTRL, right, resizeactive, 20 0
bind = SUPER CTRL, up, resizeactive, 0 -20
bind = SUPER CTRL, down, resizeactive, 0 20

# Special workspace
bind = SUPER, grave, togglespecialworkspace,
bind = SUPER SHIFT, grave, movetoworkspace, special

# AGS overview
bind = SUPER, o, exec, ags -t overview
EOF
    echo -e "${OK} Keybindings configuration created."
else
    echo -e "${OK} Keybindings configuration already exists."
fi

# Update hyprland.conf to include keybindings
if ! grep -q "source = ~/.config/hypr/keybindings.conf" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${INFO} Updating hyprland.conf to include keybindings..."
    echo -e "\n# Include keybindings\nsource = ~/.config/hypr/keybindings.conf" >> "$HYPR_DIR/hyprland.conf"
    echo -e "${OK} Hyprland configuration updated."
else
    echo -e "${OK} Keybindings already included in hyprland.conf."
fi

# Create screenshot scripts
echo -e "${INFO} Creating screenshot scripts..."

# Screenshot to clipboard
cat > "$HYPR_DIR/scripts/screenshot-clipboard.sh" << 'EOF'
#!/bin/bash
# FF6-themed screenshot to clipboard script

# Play sound effect if available
if [ -f "$HOME/.config/hypr/sounds/menu_select.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/menu_select.wav" &
fi

# Take screenshot and copy to clipboard
grim -g "$(slurp)" - | wl-copy

# Notify user
notify-send "Screenshot" "Copied to clipboard" --icon=camera-photo
EOF
chmod +x "$HYPR_DIR/scripts/screenshot-clipboard.sh"

# Screenshot save
cat > "$HYPR_DIR/scripts/screenshot-save.sh" << 'EOF'
#!/bin/bash
# FF6-themed screenshot save script

# Create screenshots directory if it doesn't exist
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

# Play sound effect if available
if [ -f "$HOME/.config/hypr/sounds/menu_select.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/menu_select.wav" &
fi

# Take screenshot and save to file
grim -g "$(slurp)" "$FILENAME"

# Notify user
notify-send "Screenshot" "Saved to $FILENAME" --icon=camera-photo
EOF
chmod +x "$HYPR_DIR/scripts/screenshot-save.sh"

# Screenshot with swappy
cat > "$HYPR_DIR/scripts/screenshot-swappy.sh" << 'EOF'
#!/bin/bash
# FF6-themed screenshot with swappy script

# Play sound effect if available
if [ -f "$HOME/.config/hypr/sounds/menu_select.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/menu_select.wav" &
fi

# Take screenshot and open in swappy
grim -g "$(slurp)" - | swappy -f -

# Notify user
notify-send "Screenshot" "Opened in Swappy" --icon=camera-photo
EOF
chmod +x "$HYPR_DIR/scripts/screenshot-swappy.sh"

echo -e "${OK} Screenshot scripts created."

# Create autostart script
echo -e "${INFO} Creating autostart script..."
cat > "$HYPR_DIR/scripts/autostart.sh" << 'EOF'
#!/bin/bash
# FF6-themed Hyprland autostart script

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Start notification daemon
if command -v swaync &> /dev/null; then
    echo -e "${INFO} Starting swaync notification daemon..."
    swaync &
fi

# Start polkit agent
if command -v /usr/lib/polkit-kde-authentication-agent-1 &> /dev/null; then
    echo -e "${INFO} Starting polkit agent..."
    /usr/lib/polkit-kde-authentication-agent-1 &
elif command -v /usr/lib/polkit-gnome-authentication-agent-1 &> /dev/null; then
    echo -e "${INFO} Starting polkit agent..."
    /usr/lib/polkit-gnome-authentication-agent-1 &
fi

# Start wallpaper daemon
if command -v swww &> /dev/null; then
    echo -e "${INFO} Starting wallpaper daemon..."
    swww init
    
    # Set default wallpaper if available
    if [ -d "$HOME/.config/hypr/wallpapers" ]; then
        WALLPAPER=$(find "$HOME/.config/hypr/wallpapers" -type f -name "*.jpg" -o -name "*.png" | head -n 1)
        if [ -n "$WALLPAPER" ]; then
            echo -e "${INFO} Setting default wallpaper: $WALLPAPER"
            swww img "$WALLPAPER" --transition-type grow --transition-pos center
        fi
    fi
fi

# Start clipboard manager
if command -v wl-paste &> /dev/null && command -v cliphist &> /dev/null; then
    echo -e "${INFO} Starting clipboard manager..."
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
fi

# Start AGS
if command -v ags &> /dev/null; then
    echo -e "${INFO} Starting AGS..."
    ags &
fi

# Start hypridle
if command -v hypridle &> /dev/null; then
    echo -e "${INFO} Starting hypridle..."
    hypridle &
fi

# Play startup sound
if [ -f "$HOME/.config/hypr/sounds/confirm.wav" ]; then
    echo -e "${INFO} Playing startup sound..."
    paplay "$HOME/.config/hypr/sounds/confirm.wav" &
fi

echo -e "${OK} Autostart completed."
EOF
chmod +x "$HYPR_DIR/scripts/autostart.sh"
echo -e "${OK} Autostart script created."

# Update hyprland.conf to include autostart
if ! grep -q "exec-once = ~/.config/hypr/scripts/autostart.sh" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${INFO} Updating hyprland.conf to include autostart..."
    sed -i '/^exec-once = waybar/i exec-once = ~/.config/hypr/scripts/autostart.sh' "$HYPR_DIR/hyprland.conf"
    echo -e "${OK} Hyprland configuration updated."
else
    echo -e "${OK} Autostart already included in hyprland.conf."
fi

# Create a script to fix common issues
echo -e "${INFO} Creating troubleshooting script..."
cat > "$HYPR_DIR/scripts/fix-common-issues.sh" << 'EOF'
#!/bin/bash
# FF6-themed Hyprland troubleshooting script

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Print header
echo -e "${INFO} FF6-themed Hyprland Troubleshooting Script"
echo -e "${INFO} =========================================="

# Fix waybar not starting
fix_waybar() {
    echo -e "${INFO} Fixing Waybar..."
    
    # Kill any existing waybar instances
    killall waybar 2>/dev/null
    
    # Start waybar with the launch script
    if [ -f "$HOME/.config/hypr/scripts/launch-waybar.sh" ]; then
        "$HOME/.config/hypr/scripts/launch-waybar.sh"
        echo -e "${OK} Waybar restarted."
    else
        echo -e "${ERROR} Waybar launch script not found."
    fi
}

# Fix wallpaper not showing
fix_wallpaper() {
    echo -e "${INFO} Fixing wallpaper..."
    
    # Kill any existing swww instances
    killall swww-daemon 2>/dev/null
    
    # Start swww
    swww init
    
    # Set default wallpaper if available
    if [ -d "$HOME/.config/hypr/wallpapers" ]; then
        WALLPAPER=$(find "$HOME/.config/hypr/wallpapers" -type f -name "*.jpg" -o -name "*.png" | head -n 1)
        if [ -n "$WALLPAPER" ]; then
            echo -e "${INFO} Setting default wallpaper: $WALLPAPER"
            swww img "$WALLPAPER" --transition-type grow --transition-pos center
            echo -e "${OK} Wallpaper set."
        else
            echo -e "${ERROR} No wallpaper found."
        fi
    else
        echo -e "${ERROR} Wallpaper directory not found."
    fi
}

# Fix notifications not showing
fix_notifications() {
    echo -e "${INFO} Fixing notifications..."
    
    # Kill any existing swaync instances
    killall swaync 2>/dev/null
    
    # Start swaync
    swaync &
    
    echo -e "${OK} Notification daemon restarted."
    
    # Test notification
    notify-send "FF6 Hyprland" "Notification system is working!" --icon=dialog-information
}

# Fix screen sharing
fix_screen_sharing() {
    echo -e "${INFO} Fixing screen sharing..."
    
    # Check if xdg-desktop-portal-hyprland is installed
    if command -v xdg-desktop-portal-hyprland &> /dev/null; then
        # Kill existing portals
        killall xdg-desktop-portal-hyprland xdg-desktop-portal 2>/dev/null
        
        # Start portals in the correct order
        sleep 1
        /usr/lib/xdg-desktop-portal-hyprland &
        sleep 1
        /usr/lib/xdg-desktop-portal &
        
        echo -e "${OK} Screen sharing portals restarted."
    else
        echo -e "${ERROR} xdg-desktop-portal-hyprland not found."
    fi
}

# Fix audio issues
fix_audio() {
    echo -e "${INFO} Fixing audio..."
    
    # Restart PulseAudio if it's the audio system
    if command -v pulseaudio &> /dev/null; then
        pulseaudio -k
        pulseaudio --start
        echo -e "${OK} PulseAudio restarted."
    fi
    
    # Restart PipeWire if it's the audio system
    if command -v pipewire &> /dev/null; then
        systemctl --user restart pipewire pipewire-pulse wireplumber
        echo -e "${OK} PipeWire restarted."
    fi
}

# Reload Hyprland configuration
reload_hyprland() {
    echo -e "${INFO} Reloading Hyprland configuration..."
    hyprctl reload
    echo -e "${OK} Hyprland configuration reloaded."
}

# Show menu
echo "Please select an issue to fix:"
echo "1) Waybar not showing"
echo "2) Wallpaper not showing"
echo "3) Notifications not working"
echo "4) Screen sharing not working"
echo "5) Audio issues"
echo "6) Reload Hyprland configuration"
echo "7) Fix all issues"
echo "8) Exit"

read -p "Enter your choice (1-8): " choice

case $choice in
    1) fix_waybar ;;
    2) fix_wallpaper ;;
    3) fix_notifications ;;
    4) fix_screen_sharing ;;
    5) fix_audio ;;
    6) reload_hyprland ;;
    7)
        fix_waybar
        fix_wallpaper
        fix_notifications
        fix_screen_sharing
        fix_audio
        reload_hyprland
        ;;
    8) echo "Exiting..." ;;
    *) echo -e "${ERROR} Invalid choice." ;;
esac

# Play confirmation sound
if [ -f "$HOME/.config/hypr/sounds/confirm.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/confirm.wav" &
fi

echo -e "${INFO} Troubleshooting completed."
EOF
chmod +x "$HYPR_DIR/scripts/fix-common-issues.sh"
echo -e "${OK} Troubleshooting script created."

# Final message
echo -e "${INFO} ======================================="
if [ $MISSING_DIRS -eq 0 ] && [ $MISSING_FILES -eq 0 ] && [ $MISSING_COMMANDS -eq 0 ]; then
    echo -e "${OK} All components are properly integrated!"
    echo -e "${OK} FF6-themed Hyprland configuration is ready to use."
elif [ $MISSING_DIRS -eq 0 ] && [ $MISSING_FILES -eq 0 ]; then
    echo -e "${WARNING} Some commands are missing, but all files and directories are present."
    echo -e "${WARNING} You may need to install the missing commands for full functionality."
else
    echo -e "${WARNING} Some components are missing. Please check the logs above."
    echo -e "${WARNING} You may need to reinstall or reconfigure some components."
fi
echo -e "${INFO} ======================================="

# Play confirmation sound if available
if [ -f "$SOUNDS_DIR/confirm.wav" ] && command -v paplay &> /dev/null; then
    paplay "$SOUNDS_DIR/confirm.wav"
fi

exit 0
