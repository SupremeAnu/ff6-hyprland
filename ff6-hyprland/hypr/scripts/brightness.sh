#!/bin/bash
# FF6-themed brightness control script
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Check if brightnessctl is installed
if ! command -v brightnessctl &> /dev/null; then
    echo -e "$ERROR brightnessctl is not installed. Please install it first."
    echo -e "$INFO You can install it using your package manager."
    echo -e "$INFO For Arch-based systems: yay -S brightnessctl"
    exit 1
fi

# Sound files
SOUND_DIR="$HOME/.config/hypr/sounds"
BRIGHTNESS_UP_SOUND="$SOUND_DIR/cursor_move.wav"
BRIGHTNESS_DOWN_SOUND="$SOUND_DIR/cursor_move.wav"

# Create sounds directory if it doesn't exist
mkdir -p "$SOUND_DIR"

# Function to play sound if file exists
play_sound() {
    if [ -f "$1" ] && command -v paplay &> /dev/null; then
        paplay "$1" &
    fi
}

# Function to show notification
show_notification() {
    local title="$1"
    local message="$2"
    local icon="$3"
    
    if command -v notify-send &> /dev/null; then
        notify-send "$title" "$message" --icon="$icon" --expire-time=1500
    fi
}

# Function to get brightness percentage
get_brightness() {
    brightnessctl info | grep -oP '\(\K[^%]*'
}

# Handle arguments
case "$1" in
    "--inc")
        # Increase brightness by 5%
        brightnessctl set +5%
        play_sound "$BRIGHTNESS_UP_SOUND"
        
        # Get new brightness
        brightness=$(get_brightness)
        
        # Show notification
        show_notification "Brightness" "Brightness: $brightness%" "display-brightness"
        ;;
        
    "--dec")
        # Decrease brightness by 5%
        brightnessctl set 5%-
        play_sound "$BRIGHTNESS_DOWN_SOUND"
        
        # Get new brightness
        brightness=$(get_brightness)
        
        # Show notification
        show_notification "Brightness" "Brightness: $brightness%" "display-brightness"
        ;;
        
    *)
        # Show usage
        echo -e "$INFO Usage: $0 [OPTION]"
        echo -e "$INFO Options:"
        echo -e "$INFO   --inc         Increase brightness by 5%"
        echo -e "$INFO   --dec         Decrease brightness by 5%"
        exit 1
        ;;
esac

exit 0
