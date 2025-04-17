#!/bin/bash
# FF6-themed lockscreen script for Hyprland
# Part of the FF6-themed Hyprland configuration

# Play FF6 menu sound effect if available
if [ -f "$HOME/.config/hypr/sounds/menu_open.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/menu_open.wav" &
fi

# Create a temporary copy of the current wallpaper for modification
CURRENT_WALLPAPER="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
LOCK_WALLPAPER="$HOME/.config/hypr/wallpaper_effects/.lock_wallpaper"

# Check if we have ImageMagick installed for image manipulation
if command -v convert &> /dev/null; then
    # Create a blurred, darkened version of the current wallpaper with FF6 blue tint
    convert "$CURRENT_WALLPAPER" -blur 0x8 -fill "#112855" -colorize 30% \
        -brightness-contrast -10x20 "$LOCK_WALLPAPER"
    
    # Add FF6-style border to the image
    convert "$LOCK_WALLPAPER" -bordercolor "#3B7DFF" -border 10 "$LOCK_WALLPAPER"
else
    # If ImageMagick is not available, just copy the current wallpaper
    cp "$CURRENT_WALLPAPER" "$LOCK_WALLPAPER"
fi

# Check if we have a FF6 character sprite to overlay
if [ -d "$HOME/.config/hypr/sprites" ]; then
    # Get a random FF6 character sprite
    SPRITE_DIR="$HOME/.config/hypr/sprites"
    SPRITE=$(find "$SPRITE_DIR" -type f -name "*.png" | shuf -n 1)
    
    if [ -n "$SPRITE" ] && command -v convert &> /dev/null; then
        # Get screen dimensions
        SCREEN_WIDTH=$(hyprctl monitors -j | jq '.[0].width')
        SCREEN_HEIGHT=$(hyprctl monitors -j | jq '.[0].height')
        
        # Calculate position (centered, bottom third of screen)
        SPRITE_WIDTH=200  # Desired width of sprite
        SPRITE_HEIGHT=200 # Approximate height after scaling
        POS_X=$(( (SCREEN_WIDTH - SPRITE_WIDTH) / 2 ))
        POS_Y=$(( SCREEN_HEIGHT - SCREEN_HEIGHT/3 ))
        
        # Overlay the sprite on the lock wallpaper
        convert "$LOCK_WALLPAPER" \
            \( "$SPRITE" -resize "${SPRITE_WIDTH}x" \) \
            -gravity south -geometry "+0+${POS_Y}" -composite \
            "$LOCK_WALLPAPER"
    fi
fi

# Launch hyprlock with the prepared wallpaper
HYPRLOCK_WALLPAPER="$LOCK_WALLPAPER" hyprlock
