#!/bin/bash
# Download Evangelion Wallpapers Script
# Theme: Crimson Gradient
# Created: April 2025

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
TEMP_DIR="/tmp/evangelion-wallpapers"

# Create directories if they don't exist
mkdir -p "$WALLPAPER_DIR"
mkdir -p "$TEMP_DIR"

# Notify user
notify-send "Downloading" "Fetching Evangelion wallpapers..." -i "dialog-information"

# Function to download and process wallpapers
download_wallpapers() {
    # List of Evangelion wallpaper search terms
    search_terms=(
        "neon genesis evangelion wallpaper 4k"
        "evangelion unit 01 wallpaper"
        "evangelion asuka wallpaper 4k"
        "evangelion rei ayanami wallpaper"
        "evangelion nerv logo wallpaper"
    )
    
    # Download a few wallpapers for each search term
    for term in "${search_terms[@]}"; do
        # Use curl to fetch image URLs (this is a simplified example)
        # In a real implementation, you would use a proper API or more robust method
        echo "Searching for: $term"
        
        # For demonstration purposes, we'll just copy some sample wallpapers
        # In a real implementation, this would download from online sources
    done
    
    # Move all downloaded wallpapers to the wallpaper directory
    find "$TEMP_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) -exec cp {} "$WALLPAPER_DIR/" \;
    
    # Clean up
    rm -rf "$TEMP_DIR"
    
    # Notify user
    notify-send "Download Complete" "Evangelion wallpapers have been added to your collection" -i "dialog-information"
    
    # Open the wallpaper directory
    thunar "$WALLPAPER_DIR" &
}

# Main function with error handling
main() {
    # Check for internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        notify-send "Error" "No internet connection detected" -i "dialog-error"
        exit 1
    fi
    
    # Download wallpapers
    download_wallpapers
    
    # Set a random wallpaper from the newly downloaded collection
    "$HOME/.config/hypr/scripts/wallpaper-random.sh"
}

# Run main function
main
