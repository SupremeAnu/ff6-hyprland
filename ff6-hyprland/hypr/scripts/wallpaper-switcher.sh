#!/bin/bash
# FF6-Themed Wallpaper Switcher
# Script to switch between different FF6-themed wallpapers

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
GENERATE_SCRIPT="$SCRIPT_DIR/generate-wallpapers.sh"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Check if swww is installed
if ! command -v swww &> /dev/null; then
    echo "swww is required but not installed. Please install it first."
    echo "On Arch: yay -S swww"
    exit 1
fi

# Initialize swww if not running
if ! swww query &> /dev/null; then
    swww init
fi

# Check if we have wallpapers, if not generate them
if [ ! -f "$WALLPAPER_DIR/ff6-blue-gradient-1080p.png" ]; then
    echo "No FF6 wallpapers found. Generating them now..."
    if [ -f "$GENERATE_SCRIPT" ]; then
        "$GENERATE_SCRIPT" --generate-all
    else
        echo "Error: Wallpaper generator script not found at $GENERATE_SCRIPT"
        exit 1
    fi
fi

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    swww img "$wallpaper" --transition-type grow --transition-pos center
    echo "Wallpaper set to: $wallpaper"
}

# Get screen resolution
get_resolution() {
    if command -v xrandr &> /dev/null; then
        if xrandr 2>/dev/null | grep -q "3840x2160"; then
            echo "4k"
        else
            echo "1080p"
        fi
    else
        # Default to 1080p if xrandr is not available
        echo "1080p"
    fi
}

# Main menu using rofi
show_rofi_menu() {
    local resolution=$(get_resolution)
    local options=""
    
    if [ "$resolution" = "4k" ]; then
        options="FF6 Blue Gradient (4K)\nFF6 Blue Radial (4K)\nFF6 Blue Diagonal (4K)\nGenerate New Wallpapers"
    else
        options="FF6 Blue Gradient (1080p)\nFF6 Blue Radial (1080p)\nFF6 Blue Diagonal (1080p)\nGenerate New Wallpapers"
    fi
    
    local selected=$(echo -e "$options" | rofi -dmenu -i -p "Select Wallpaper" -theme "$HOME/.config/rofi/themes/ff6-menu.rasi")
    
    case "$selected" in
        "FF6 Blue Gradient (1080p)")
            set_wallpaper "$WALLPAPER_DIR/ff6-blue-gradient-1080p.png"
            ;;
        "FF6 Blue Radial (1080p)")
            set_wallpaper "$WALLPAPER_DIR/ff6-blue-radial-1080p.png"
            ;;
        "FF6 Blue Diagonal (1080p)")
            set_wallpaper "$WALLPAPER_DIR/ff6-blue-diagonal-1080p.png"
            ;;
        "FF6 Blue Gradient (4K)")
            set_wallpaper "$WALLPAPER_DIR/ff6-blue-gradient-4k.png"
            ;;
        "FF6 Blue Radial (4K)")
            set_wallpaper "$WALLPAPER_DIR/ff6-blue-radial-4k.png"
            ;;
        "FF6 Blue Diagonal (4K)")
            set_wallpaper "$WALLPAPER_DIR/ff6-blue-diagonal-4k.png"
            ;;
        "Generate New Wallpapers")
            "$GENERATE_SCRIPT"
            ;;
        *)
            echo "No selection made."
            ;;
    esac
}

# Main menu in terminal
show_terminal_menu() {
    local resolution=$(get_resolution)
    
    echo "FF6-Themed Wallpaper Switcher"
    echo "----------------------------"
    
    if [ "$resolution" = "4k" ]; then
        echo "1. FF6 Blue Gradient (4K)"
        echo "2. FF6 Blue Radial (4K)"
        echo "3. FF6 Blue Diagonal (4K)"
    else
        echo "1. FF6 Blue Gradient (1080p)"
        echo "2. FF6 Blue Radial (1080p)"
        echo "3. FF6 Blue Diagonal (1080p)"
    fi
    
    echo "4. Generate New Wallpapers"
    echo "5. Exit"
    echo
    read -p "Enter your choice: " choice
    
    if [ "$resolution" = "4k" ]; then
        case $choice in
            1) set_wallpaper "$WALLPAPER_DIR/ff6-blue-gradient-4k.png" ;;
            2) set_wallpaper "$WALLPAPER_DIR/ff6-blue-radial-4k.png" ;;
            3) set_wallpaper "$WALLPAPER_DIR/ff6-blue-diagonal-4k.png" ;;
            4) "$GENERATE_SCRIPT" ;;
            5) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    else
        case $choice in
            1) set_wallpaper "$WALLPAPER_DIR/ff6-blue-gradient-1080p.png" ;;
            2) set_wallpaper "$WALLPAPER_DIR/ff6-blue-radial-1080p.png" ;;
            3) set_wallpaper "$WALLPAPER_DIR/ff6-blue-diagonal-1080p.png" ;;
            4) "$GENERATE_SCRIPT" ;;
            5) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    fi
}

# If no arguments, show the rofi menu
if [ $# -eq 0 ]; then
    # Check if we're in a graphical environment
    if [ -n "$DISPLAY" ] && command -v rofi &> /dev/null; then
        show_rofi_menu
    else
        show_terminal_menu
    fi
else
    # Handle command line arguments
    case "$1" in
        --gradient)
            if [ "$(get_resolution)" = "4k" ]; then
                set_wallpaper "$WALLPAPER_DIR/ff6-blue-gradient-4k.png"
            else
                set_wallpaper "$WALLPAPER_DIR/ff6-blue-gradient-1080p.png"
            fi
            ;;
        --radial)
            if [ "$(get_resolution)" = "4k" ]; then
                set_wallpaper "$WALLPAPER_DIR/ff6-blue-radial-4k.png"
            else
                set_wallpaper "$WALLPAPER_DIR/ff6-blue-radial-1080p.png"
            fi
            ;;
        --diagonal)
            if [ "$(get_resolution)" = "4k" ]; then
                set_wallpaper "$WALLPAPER_DIR/ff6-blue-diagonal-4k.png"
            else
                set_wallpaper "$WALLPAPER_DIR/ff6-blue-diagonal-1080p.png"
            fi
            ;;
        --random)
            # Pick a random wallpaper
            resolution=$(get_resolution)
            wallpapers=()
            
            if [ "$resolution" = "4k" ]; then
                wallpapers=("$WALLPAPER_DIR/ff6-blue-gradient-4k.png" "$WALLPAPER_DIR/ff6-blue-radial-4k.png" "$WALLPAPER_DIR/ff6-blue-diagonal-4k.png")
            else
                wallpapers=("$WALLPAPER_DIR/ff6-blue-gradient-1080p.png" "$WALLPAPER_DIR/ff6-blue-radial-1080p.png" "$WALLPAPER_DIR/ff6-blue-diagonal-1080p.png")
            fi
            
            random_index=$((RANDOM % ${#wallpapers[@]}))
            set_wallpaper "${wallpapers[$random_index]}"
            ;;
        *)
            echo "Usage: $0 [--gradient|--radial|--diagonal|--random]"
            ;;
    esac
fi
