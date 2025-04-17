#!/bin/bash
# FF6-themed toggle script for light/dark theme
# Part of the FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Define theme files
THEME_DIR="$HOME/.config/hypr/themes"
CURRENT_THEME_FILE="$THEME_DIR/current_theme"
LIGHT_THEME="$THEME_DIR/ff6_light.conf"
DARK_THEME="$THEME_DIR/ff6_dark.conf"

# Create theme directory if it doesn't exist
mkdir -p "$THEME_DIR"

# Create theme files if they don't exist
if [ ! -f "$LIGHT_THEME" ]; then
    echo -e "$INFO Creating light theme file..."
    cat > "$LIGHT_THEME" << EOF
# FF6 Light Theme
\$ff6_menu_blue = rgb(59, 125, 255)
\$ff6_menu_blue_dark = rgb(17, 40, 85)
\$ff6_menu_blue_light = rgb(120, 170, 255)
\$ff6_menu_border = rgb(17, 40, 85)
\$ff6_menu_text = rgb(17, 40, 85)
\$ff6_menu_highlight = rgb(255, 215, 0)
\$ff6_menu_shadow = rgba(0, 0, 0, 0.3)

\$active_border = rgb(17, 40, 85)
\$active_shadow = rgba(17, 40, 85, 0.4)
\$inactive_border = rgba(59, 125, 255, 0.5)
\$inactive_shadow = rgba(59, 125, 255, 0.2)

\$urgent_color = rgb(255, 107, 107)
\$success_color = rgb(87, 227, 137)
\$warning_color = rgb(255, 215, 0)
EOF
fi

if [ ! -f "$DARK_THEME" ]; then
    echo -e "$INFO Creating dark theme file..."
    cat > "$DARK_THEME" << EOF
# FF6 Dark Theme
\$ff6_menu_blue = rgb(17, 40, 85)
\$ff6_menu_blue_dark = rgb(10, 26, 58)
\$ff6_menu_blue_light = rgb(59, 125, 255)
\$ff6_menu_border = rgb(59, 125, 255)
\$ff6_menu_text = rgb(255, 255, 255)
\$ff6_menu_highlight = rgb(255, 215, 0)
\$ff6_menu_shadow = rgb(0, 0, 0)

\$active_border = rgb(59, 125, 255)
\$active_shadow = rgba(59, 125, 255, 0.4)
\$inactive_border = rgba(59, 125, 255, 0.5)
\$inactive_shadow = rgba(10, 26, 58, 0.4)

\$urgent_color = rgb(255, 107, 107)
\$success_color = rgb(87, 227, 137)
\$warning_color = rgb(255, 215, 0)
EOF
fi

# Check current theme
if [ ! -f "$CURRENT_THEME_FILE" ]; then
    echo "dark" > "$CURRENT_THEME_FILE"
fi

CURRENT_THEME=$(cat "$CURRENT_THEME_FILE")

# Toggle theme
if [ "$CURRENT_THEME" = "dark" ]; then
    echo -e "$INFO Switching to light theme..."
    cp "$LIGHT_THEME" "$HOME/.config/hypr/colors.conf"
    echo "light" > "$CURRENT_THEME_FILE"
    
    # Play FF6 menu sound if available
    if [ -f "$HOME/.config/hypr/sounds/menu_open.wav" ]; then
        paplay "$HOME/.config/hypr/sounds/menu_open.wav" &
    fi
    
    # Notify user
    notify-send "FF6 Theme" "Switched to light theme" --icon=preferences-desktop-theme
else
    echo -e "$INFO Switching to dark theme..."
    cp "$DARK_THEME" "$HOME/.config/hypr/colors.conf"
    echo "dark" > "$CURRENT_THEME_FILE"
    
    # Play FF6 menu sound if available
    if [ -f "$HOME/.config/hypr/sounds/menu_open.wav" ]; then
        paplay "$HOME/.config/hypr/sounds/menu_open.wav" &
    fi
    
    # Notify user
    notify-send "FF6 Theme" "Switched to dark theme" --icon=preferences-desktop-theme
fi

# Reload Hyprland configuration
hyprctl reload

echo -e "$OK Theme toggled successfully!"
