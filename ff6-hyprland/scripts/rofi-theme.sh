#!/bin/bash
# FF6-Themed Hyprland Configuration - Rofi Theme Script
# This script ensures rofi is properly configured with the FF6 theme

# Ensure the rofi config directory exists
mkdir -p ~/.config/rofi/themes

# Copy the FF6 theme files to the rofi config directory
cp -f ~/.config/rofi/config.rasi ~/.config/rofi/config.rasi.bak 2>/dev/null || true
cp -f ~/.config/rofi/shared-fonts.rasi ~/.config/rofi/shared-fonts.rasi.bak 2>/dev/null || true
cp -f ~/.config/rofi/themes/ff6-menu.rasi ~/.config/rofi/themes/ff6-menu.rasi.bak 2>/dev/null || true

# Create symlinks to the FF6 theme files
ln -sf ~/.config/hyprland-crimson-config/rofi/config.rasi ~/.config/rofi/config.rasi
ln -sf ~/.config/hyprland-crimson-config/rofi/shared-fonts.rasi ~/.config/rofi/shared-fonts.rasi
mkdir -p ~/.config/rofi/themes
ln -sf ~/.config/hyprland-crimson-config/rofi/themes/ff6-menu.rasi ~/.config/rofi/themes/ff6-menu.rasi

echo "Rofi FF6 theme has been applied successfully!"
