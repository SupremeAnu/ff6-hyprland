#!/bin/bash

# FF6-themed Hyprland Configuration - Fix Script
# This script fixes rofi, wallust, and wlogout configurations

# Set colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Fixing FF6-themed configurations for rofi, wallust, and wlogout...${NC}"

# Create necessary directories
mkdir -p ~/.config/rofi/themes
mkdir -p ~/.config/rofi/wallust
mkdir -p ~/.config/hypr/wallust
mkdir -p ~/.config/waybar/wallust
mkdir -p ~/.config/kitty/kitty-themes
mkdir -p ~/.config/swaync/wallust
mkdir -p ~/.config/wlogout

echo -e "${GREEN}Created necessary directories${NC}"

# Fix rofi configuration
cp -f /home/ubuntu/hyprland-crimson-config/rofi/config.rasi ~/.config/rofi/
cp -f /home/ubuntu/hyprland-crimson-config/rofi/shared-fonts.rasi ~/.config/rofi/
cp -f /home/ubuntu/hyprland-crimson-config/rofi/ff6.rasi ~/.config/rofi/
cp -f /home/ubuntu/hyprland-crimson-config/rofi/ff6-theme.rasi ~/.config/rofi/
mkdir -p ~/.config/rofi/themes
cp -f /home/ubuntu/hyprland-crimson-config/rofi/themes/ff6-menu.rasi ~/.config/rofi/themes/

echo -e "${GREEN}Fixed rofi configuration${NC}"

# Fix wallust configuration
mkdir -p ~/.config/wallust/templates
cp -f /home/ubuntu/hyprland-crimson-config/wallust/wallust.toml ~/.config/wallust/
cp -rf /home/ubuntu/hyprland-crimson-config/wallust/templates/* ~/.config/wallust/templates/

# Create FF6-themed color templates for wallust
cat > ~/.config/wallust/templates/colors-hyprland.conf << EOF
$color0 = rgb(0a1a3f)
$color1 = rgb(1a2a5f)
$color2 = rgb(3a4a8f)
$color3 = rgb(4a5aaf)
$color4 = rgb(5a6acf)
$color5 = rgb(6a7aef)
$color6 = rgb(8a9aff)
$color7 = rgb(ffffff)
$color8 = rgb(d0d0ff)
$color9 = rgb(ffff80)
$color10 = rgb(00ffff)
$color11 = rgb(ff8080)
$color12 = rgb(80ff80)
$color13 = rgb(ff80ff)
$color14 = rgb(80ffff)
$color15 = rgb(ffffff)
EOF

echo -e "${GREEN}Fixed wallust configuration${NC}"

# Fix wlogout configuration
cp -f /home/ubuntu/hyprland-crimson-config/wlogout/style.css ~/.config/wlogout/
cp -f /home/ubuntu/hyprland-crimson-config/wlogout/layout ~/.config/wlogout/

echo -e "${GREEN}Fixed wlogout configuration${NC}"

# Create a script to apply wallust colors
cat > ~/.config/hypr/scripts/apply-wallust.sh << EOF
#!/bin/bash
# Apply wallust colors to all components

# Generate colors from wallpaper
wallust -g /home/ubuntu/hyprland-crimson-config/wallpapers/ff6-gradient.png

# Apply colors to Hyprland
if [ -f ~/.config/hypr/wallust/wallust-hyprland.conf ]; then
    echo "source = ~/.config/hypr/wallust/wallust-hyprland.conf" > ~/.config/hypr/colors.conf
fi

# Restart waybar to apply new colors
killall waybar
~/.config/hypr/scripts/launch-waybar.sh &
EOF

chmod +x ~/.config/hypr/scripts/apply-wallust.sh

echo -e "${GREEN}Created wallust application script${NC}"

# Create FF6 gradient wallpaper if it doesn't exist
mkdir -p /home/ubuntu/hyprland-crimson-config/wallpapers
if [ ! -f /home/ubuntu/hyprland-crimson-config/wallpapers/ff6-gradient.png ]; then
    echo -e "${BLUE}Creating FF6 gradient wallpaper...${NC}"
    
    # Create a simple gradient wallpaper using convert (ImageMagick)
    if command -v convert &> /dev/null; then
        convert -size 1920x1080 gradient:'#0a1a3f-#3a4a8f' /home/ubuntu/hyprland-crimson-config/wallpapers/ff6-gradient.png
        echo -e "${GREEN}Created FF6 gradient wallpaper${NC}"
    else
        echo -e "${RED}ImageMagick not found, cannot create gradient wallpaper${NC}"
        echo -e "${BLUE}Please install ImageMagick or create a gradient wallpaper manually${NC}"
    fi
fi

echo -e "${BLUE}FF6-themed configurations fixed successfully!${NC}"
echo -e "${BLUE}You may need to restart Hyprland for all changes to take effect.${NC}"
