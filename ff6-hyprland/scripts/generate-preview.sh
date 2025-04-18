#!/bin/bash
# Generate a preview image for the FF6-themed Hyprland configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directories
SCREENSHOTS_DIR="/home/ubuntu/hyprland-crimson-config/screenshots"
SPRITES_DIR="/home/ubuntu/upload"
OUTPUT_FILE="$SCREENSHOTS_DIR/ff6-hyprland-preview.png"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Preview Generator         ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${RED}Error: ImageMagick is not installed.${NC}"
    echo -e "${YELLOW}Please install ImageMagick:${NC}"
    echo "  - Arch Linux: sudo pacman -S imagemagick"
    echo "  - Ubuntu/Debian: sudo apt install imagemagick"
    echo "  - Fedora: sudo dnf install ImageMagick"
    exit 1
fi

# Create screenshots directory if it doesn't exist
mkdir -p "$SCREENSHOTS_DIR"

# Generate a FF6-style background
echo -e "${BLUE}Generating FF6-style background...${NC}"
convert -size 1280x720 gradient:'#0a1a3f-#3a4a8f' \
    -fill '#1a2a5f' -draw "rectangle 20,20 1260,700" \
    -fill '#0a1a3f' -draw "rectangle 25,25 1255,695" \
    "$SCREENSHOTS_DIR/background.png"

# Add FF6-style border
echo -e "${BLUE}Adding FF6-style border...${NC}"
convert "$SCREENSHOTS_DIR/background.png" \
    -fill none -stroke white -strokewidth 2 \
    -draw "rectangle 20,20 1260,700" \
    "$SCREENSHOTS_DIR/background-border.png"

# Create waybar preview
echo -e "${BLUE}Creating waybar preview...${NC}"
convert -size 1240x50 gradient:'#1a2a5f-#2a3a6f' \
    -fill none -stroke white -strokewidth 1 \
    -draw "rectangle 0,0 1239,49" \
    "$SCREENSHOTS_DIR/waybar.png"

# Add text to waybar
convert "$SCREENSHOTS_DIR/waybar.png" \
    -fill white -font "DejaVu-Sans-Bold" -pointsize 14 \
    -draw "text 20,30 'Terra'" \
    -fill cyan -draw "text 20,45 'LV 12  HP 271/271  MP 118/120'" \
    -fill white -draw "text 300,30 'Magitek Elite'" \
    -fill white -draw "text 1000,30 'Items'" \
    -fill white -draw "text 1000,45 'Abilities'" \
    "$SCREENSHOTS_DIR/waybar-text.png"

# Create terminal preview
echo -e "${BLUE}Creating terminal preview...${NC}"
convert -size 600x400 xc:'#0a1a3f' \
    -fill none -stroke white -strokewidth 1 \
    -draw "rectangle 0,0 599,399" \
    "$SCREENSHOTS_DIR/terminal.png"

# Add character sprite to terminal if available
if [ -f "$SPRITES_DIR/terra.png" ]; then
    echo -e "${BLUE}Adding character sprite to terminal...${NC}"
    convert "$SCREENSHOTS_DIR/terminal.png" "$SPRITES_DIR/terra.png" \
        -geometry +50+50 -composite \
        "$SCREENSHOTS_DIR/terminal-sprite.png"
else
    # Create a simple sprite
    convert -size 64x64 xc:transparent \
        -fill '#00ff99' -draw "circle 32,32 32,48" \
        -fill '#ffcc00' -draw "rectangle 20,10 44,20" \
        "$SCREENSHOTS_DIR/terra-sprite.png"
    
    convert "$SCREENSHOTS_DIR/terminal.png" "$SCREENSHOTS_DIR/terra-sprite.png" \
        -geometry +50+50 -composite \
        "$SCREENSHOTS_DIR/terminal-sprite.png"
fi

# Add text to terminal
convert "$SCREENSHOTS_DIR/terminal-sprite.png" \
    -fill white -font "DejaVu-Sans-Mono" -pointsize 12 \
    -draw "text 150,100 'Terra joins your party!'" \
    -draw "text 50,200 'ubuntu@ff6:~$ '" \
    "$SCREENSHOTS_DIR/terminal-complete.png"

# Create rofi preview
echo -e "${BLUE}Creating rofi preview...${NC}"
convert -size 400x500 gradient:'#1a2a5f-#2a3a6f' \
    -fill none -stroke white -strokewidth 1 \
    -draw "rectangle 0,0 399,499" \
    "$SCREENSHOTS_DIR/rofi.png"

# Add text to rofi
convert "$SCREENSHOTS_DIR/rofi.png" \
    -fill white -font "DejaVu-Sans-Bold" -pointsize 14 \
    -draw "text 20,30 'Applications'" \
    -fill white -font "DejaVu-Sans" -pointsize 12 \
    -draw "text 20,70 'Firefox'" \
    -draw "text 20,100 'Terminal'" \
    -draw "text 20,130 'File Manager'" \
    -draw "text 20,160 'Settings'" \
    -draw "text 20,190 'Steam'" \
    "$SCREENSHOTS_DIR/rofi-text.png"

# Create wlogout preview
echo -e "${BLUE}Creating wlogout preview...${NC}"
convert -size 600x300 gradient:'#1a2a5f-#2a3a6f' \
    -fill none -stroke white -strokewidth 1 \
    -draw "rectangle 0,0 599,299" \
    "$SCREENSHOTS_DIR/wlogout.png"

# Add buttons to wlogout
convert "$SCREENSHOTS_DIR/wlogout.png" \
    -fill '#2a3a6f' -draw "rectangle 50,100 150,200" \
    -fill '#2a3a6f' -draw "rectangle 200,100 300,200" \
    -fill '#2a3a6f' -draw "rectangle 350,100 450,200" \
    -fill none -stroke white -strokewidth 1 \
    -draw "rectangle 50,100 150,200" \
    -draw "rectangle 200,100 300,200" \
    -draw "rectangle 350,100 450,200" \
    -fill white -font "DejaVu-Sans" -pointsize 12 \
    -draw "text 80,160 'Logout'" \
    -draw "text 230,160 'Reboot'" \
    -draw "text 370,160 'Shutdown'" \
    "$SCREENSHOTS_DIR/wlogout-buttons.png"

# Create cursor preview
echo -e "${BLUE}Creating cursor preview...${NC}"
if [ -f "$SPRITES_DIR/Ultima_Weapon_2_-_FF6.png" ]; then
    convert "$SPRITES_DIR/Ultima_Weapon_2_-_FF6.png" -resize 64x64 \
        "$SCREENSHOTS_DIR/cursor.png"
else
    # Create a simple sword cursor
    convert -size 64x64 xc:transparent \
        -fill none -stroke blue -strokewidth 2 \
        -draw "line 16,16 48,48 line 48,48 16,48 line 16,48 32,32" \
        -fill gold -draw "circle 32,32 32,36" \
        "$SCREENSHOTS_DIR/cursor.png"
fi

# Combine all elements into final preview
echo -e "${BLUE}Combining all elements into final preview...${NC}"
convert "$SCREENSHOTS_DIR/background-border.png" \
    "$SCREENSHOTS_DIR/waybar-text.png" -geometry +20+20 -composite \
    "$SCREENSHOTS_DIR/terminal-complete.png" -geometry +50+100 -composite \
    "$SCREENSHOTS_DIR/rofi-text.png" -geometry +700+100 -composite \
    "$SCREENSHOTS_DIR/wlogout-buttons.png" -geometry +50+350 -composite \
    "$SCREENSHOTS_DIR/cursor.png" -geometry +500+300 -composite \
    "$OUTPUT_FILE"

# Add title
convert "$OUTPUT_FILE" \
    -fill white -font "DejaVu-Sans-Bold" -pointsize 24 \
    -draw "text 400,680 'FF6-Themed Hyprland'" \
    "$OUTPUT_FILE"

# Clean up temporary files
echo -e "${BLUE}Cleaning up temporary files...${NC}"
rm -f "$SCREENSHOTS_DIR/background.png"
rm -f "$SCREENSHOTS_DIR/background-border.png"
rm -f "$SCREENSHOTS_DIR/waybar.png"
rm -f "$SCREENSHOTS_DIR/waybar-text.png"
rm -f "$SCREENSHOTS_DIR/terminal.png"
rm -f "$SCREENSHOTS_DIR/terminal-sprite.png"
rm -f "$SCREENSHOTS_DIR/terminal-complete.png"
rm -f "$SCREENSHOTS_DIR/rofi.png"
rm -f "$SCREENSHOTS_DIR/rofi-text.png"
rm -f "$SCREENSHOTS_DIR/wlogout.png"
rm -f "$SCREENSHOTS_DIR/wlogout-buttons.png"
rm -f "$SCREENSHOTS_DIR/cursor.png"
rm -f "$SCREENSHOTS_DIR/terra-sprite.png"

echo -e "${GREEN}Preview image generated: $OUTPUT_FILE${NC}"
