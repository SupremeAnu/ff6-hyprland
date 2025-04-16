#!/bin/bash
# Wallpaper Menu Script for Hyprland
# Theme: Crimson Gradient
# Created: April 2025

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CURRENT_LINK="$WALLPAPER_DIR/current.png"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    
    # Create symbolic link to current wallpaper
    ln -sf "$wallpaper" "$CURRENT_LINK"
    
    # Set the wallpaper using swww
    swww img "$wallpaper" --transition-type grow --transition-pos 0.9,0.1 --transition-duration 2
    
    # Notify user
    notify-send "Wallpaper Changed" "Wallpaper set to $(basename "$wallpaper")" -i "$wallpaper"
}

# Get list of wallpapers
get_wallpapers() {
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | sort
}

# Create menu options
create_menu() {
    echo "󰸉 Random Wallpaper"
    echo "󰋩 Open Wallpaper Folder"
    echo "󰋙 Refresh Wallpaper List"
    echo "󰆼 Download Evangelion Wallpapers"
    
    # Add individual wallpapers
    for wallpaper in $(get_wallpapers); do
        # Skip the current.png symlink
        if [[ "$(basename "$wallpaper")" != "current.png" ]]; then
            echo "🖼️ $(basename "$wallpaper")"
        fi
    done
}

# Handle menu selection
handle_selection() {
    local selection="$1"
    
    case "$selection" in
        "󰸉 Random Wallpaper")
            "$HOME/.config/hypr/scripts/wallpaper-random.sh"
            ;;
        "󰋩 Open Wallpaper Folder")
            thunar "$WALLPAPER_DIR" &
            ;;
        "󰋙 Refresh Wallpaper List")
            notify-send "Wallpaper List" "Refreshed wallpaper list" -i "$CURRENT_LINK"
            ;;
        "󰆼 Download Evangelion Wallpapers")
            "$HOME/.config/hypr/scripts/download-evangelion-wallpapers.sh"
            ;;
        *)
            # Extract wallpaper name from selection
            wallpaper_name="${selection:2}"
            wallpaper_path="$WALLPAPER_DIR/$wallpaper_name"
            
            if [[ -f "$wallpaper_path" ]]; then
                set_wallpaper "$wallpaper_path"
            fi
            ;;
    esac
}

# Main function
main() {
    # Create menu and get selection
    selection=$(create_menu | rofi -dmenu -i -p "Wallpaper Menu" -theme-str '@import "crimson-theme.rasi"')
    
    # Handle selection if not cancelled
    if [[ -n "$selection" ]]; then
        handle_selection "$selection"
    fi
}

# Run main function
main
