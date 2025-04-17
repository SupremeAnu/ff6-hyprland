#!/bin/bash
# FF6-themed volume control script
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Check if pamixer is installed
if ! command -v pamixer &> /dev/null; then
    echo -e "$ERROR pamixer is not installed. Please install it first."
    echo -e "$INFO You can install it using your package manager."
    echo -e "$INFO For Arch-based systems: yay -S pamixer"
    exit 1
fi

# Sound files
SOUND_DIR="$HOME/.config/hypr/sounds"
VOLUME_UP_SOUND="$SOUND_DIR/cursor_move.wav"
VOLUME_DOWN_SOUND="$SOUND_DIR/cursor_move.wav"
VOLUME_TOGGLE_SOUND="$SOUND_DIR/menu_select.wav"
MIC_TOGGLE_SOUND="$SOUND_DIR/menu_select.wav"

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

# Function to get volume
get_volume() {
    pamixer --get-volume
}

# Function to get mute status
is_muted() {
    pamixer --get-mute
}

# Function to get microphone volume
get_mic_volume() {
    pamixer --default-source --get-volume
}

# Function to get microphone mute status
is_mic_muted() {
    pamixer --default-source --get-mute
}

# Handle arguments
case "$1" in
    "--inc")
        # Increase volume by 5%
        pamixer -i 5
        play_sound "$VOLUME_UP_SOUND"
        
        # Get new volume
        volume=$(get_volume)
        
        # Show notification
        show_notification "Volume" "Volume: $volume%" "audio-volume-high"
        ;;
        
    "--dec")
        # Decrease volume by 5%
        pamixer -d 5
        play_sound "$VOLUME_DOWN_SOUND"
        
        # Get new volume
        volume=$(get_volume)
        
        # Show notification
        show_notification "Volume" "Volume: $volume%" "audio-volume-medium"
        ;;
        
    "--toggle")
        # Toggle mute
        pamixer -t
        play_sound "$VOLUME_TOGGLE_SOUND"
        
        # Check if muted
        if [ "$(is_muted)" = "true" ]; then
            show_notification "Volume" "Muted" "audio-volume-muted"
        else
            volume=$(get_volume)
            show_notification "Volume" "Volume: $volume%" "audio-volume-high"
        fi
        ;;
        
    "--mic-inc")
        # Increase microphone volume by 5%
        pamixer --default-source -i 5
        play_sound "$VOLUME_UP_SOUND"
        
        # Get new microphone volume
        mic_volume=$(get_mic_volume)
        
        # Show notification
        show_notification "Microphone" "Microphone: $mic_volume%" "audio-input-microphone"
        ;;
        
    "--mic-dec")
        # Decrease microphone volume by 5%
        pamixer --default-source -d 5
        play_sound "$VOLUME_DOWN_SOUND"
        
        # Get new microphone volume
        mic_volume=$(get_mic_volume)
        
        # Show notification
        show_notification "Microphone" "Microphone: $mic_volume%" "audio-input-microphone"
        ;;
        
    "--toggle-mic")
        # Toggle microphone mute
        pamixer --default-source -t
        play_sound "$MIC_TOGGLE_SOUND"
        
        # Check if microphone is muted
        if [ "$(is_mic_muted)" = "true" ]; then
            show_notification "Microphone" "Microphone Muted" "audio-input-microphone-muted"
        else
            mic_volume=$(get_mic_volume)
            show_notification "Microphone" "Microphone: $mic_volume%" "audio-input-microphone"
        fi
        ;;
        
    *)
        # Show usage
        echo -e "$INFO Usage: $0 [OPTION]"
        echo -e "$INFO Options:"
        echo -e "$INFO   --inc         Increase volume by 5%"
        echo -e "$INFO   --dec         Decrease volume by 5%"
        echo -e "$INFO   --toggle      Toggle mute"
        echo -e "$INFO   --mic-inc     Increase microphone volume by 5%"
        echo -e "$INFO   --mic-dec     Decrease microphone volume by 5%"
        echo -e "$INFO   --toggle-mic  Toggle microphone mute"
        exit 1
        ;;
esac

exit 0
