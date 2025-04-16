#!/bin/bash

# Create FF6-themed icons
# This script generates and organizes FF6-themed icons for the Hyprland configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Creating FF6-themed Icons             ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Create icons directory
ICONS_DIR="$(dirname "$0")/../icons"
mkdir -p "$ICONS_DIR"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${RED}ImageMagick is not installed. Please install it first.${NC}"
    echo -e "${YELLOW}You can install it with: sudo pacman -S imagemagick${NC}"
    exit 1
fi

# Create FF6-themed app icons
echo -e "${BLUE}Creating FF6-themed app icons...${NC}"

# Terminal icon (Magic)
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "rectangle 30,40 98,45 rectangle 30,55 98,60 rectangle 30,70 98,75 rectangle 30,85 98,90" "$ICONS_DIR/terminal.png"
echo -e "${GREEN}✓ Created terminal icon${NC}"

# File manager icon (Items)
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "rectangle 30,30 98,98" -fill "#2040A0" -draw "rectangle 40,40 88,45 rectangle 40,55 88,60 rectangle 40,70 88,75 rectangle 40,85 88,90" "$ICONS_DIR/filemanager.png"
echo -e "${GREEN}✓ Created file manager icon${NC}"

# Browser icon (Relics)
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "circle 64,64 64,100" -fill "#2040A0" -draw "circle 64,64 64,90" "$ICONS_DIR/browser.png"
echo -e "${GREEN}✓ Created browser icon${NC}"

# Settings icon (Config)
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "circle 64,64 64,40" -fill "#2040A0" -draw "circle 64,64 64,30" -fill white -draw "rectangle 60,20 68,108" -draw "rectangle 20,60 108,68" "$ICONS_DIR/settings.png"
echo -e "${GREEN}✓ Created settings icon${NC}"

# Wallpaper icon (Espers)
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "rectangle 25,25 103,103" -fill "#2040A0" -draw "rectangle 30,30 98,98" -fill "#0A1060" -draw "path 'M 30,30 L 60,60 L 40,98 L 30,98 Z'" -fill "#0A1060" -draw "circle 80,50 90,60" "$ICONS_DIR/wallpaper.png"
echo -e "${GREEN}✓ Created wallpaper icon${NC}"

# Power menu icon (Save)
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "circle 64,64 64,30" -draw "rectangle 60,30 68,55" "$ICONS_DIR/power.png"
echo -e "${GREEN}✓ Created power menu icon${NC}"

# Steam icon
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "path 'M 30,50 C 30,30 98,30 98,50 L 98,80 C 98,100 30,100 30,80 Z'" -fill "#2040A0" -draw "path 'M 35,55 C 35,40 93,40 93,55 L 93,75 C 93,90 35,90 35,75 Z'" "$ICONS_DIR/steam.png"
echo -e "${GREEN}✓ Created Steam icon${NC}"

# Help icon
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -font "DejaVu-Sans-Bold" -pointsize 80 -gravity center -draw "text 0,0 '?'" "$ICONS_DIR/help.png"
echo -e "${GREEN}✓ Created help icon${NC}"

# Screenshot icon
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "rectangle 25,25 103,103" -fill "#2040A0" -draw "rectangle 30,30 98,98" -fill white -draw "circle 80,50 90,60" "$ICONS_DIR/screenshot.png"
echo -e "${GREEN}✓ Created screenshot icon${NC}"

# Clipboard icon
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "rectangle 35,25 93,103" -fill "#2040A0" -draw "rectangle 40,40 88,98" -fill white -draw "rectangle 45,45 83,55 rectangle 45,65 83,75 rectangle 45,85 83,95" "$ICONS_DIR/clipboard.png"
echo -e "${GREEN}✓ Created clipboard icon${NC}"

# Create FF6 logo
echo -e "${BLUE}Creating FF6 logo...${NC}"
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -font "DejaVu-Sans-Bold" -pointsize 40 -gravity center -draw "text 0,-20 'FF'" -pointsize 30 -draw "text 0,20 'VI'" "$ICONS_DIR/ff6_logo.png"
echo -e "${GREEN}✓ Created FF6 logo${NC}"

# Create Arch Linux logo
echo -e "${BLUE}Creating Arch Linux logo...${NC}"
convert -size 128x128 xc:none -fill "#0A1060" -draw "roundrectangle 10,10 118,118 10,10" -fill "#2040A0" -draw "roundrectangle 15,15 113,113 8,8" -fill white -draw "path 'M 64,20 L 20,108 L 40,108 L 50,90 L 78,90 L 88,108 L 108,108 Z M 64,40 L 80,80 L 48,80 Z'" "$ICONS_DIR/arch_logo.png"
echo -e "${GREEN}✓ Created Arch Linux logo${NC}"

# Create cursor directory
CURSOR_DIR="$(dirname "$0")/../cursor/AtmaWeapon"
mkdir -p "$CURSOR_DIR"

# Create Atma Weapon cursor
echo -e "${BLUE}Creating Atma Weapon cursor...${NC}"
convert -size 32x32 xc:none -fill white -draw "path 'M 16,0 L 20,0 L 20,24 L 24,20 L 24,28 L 16,28 L 16,20 L 12,24 L 12,0 Z'" -draw "path 'M 16,0 L 12,0 L 12,24 L 8,20 L 8,28 L 16,28 L 16,20 L 20,24 L 20,0 Z'" "$CURSOR_DIR/cursor.png"
echo -e "${GREEN}✓ Created Atma Weapon cursor${NC}"

# Create cursor config files
echo -e "${BLUE}Creating cursor config files...${NC}"

# Create index.theme
cat > "$CURSOR_DIR/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6 Atma Weapon Cursor Theme
EOF
echo -e "${GREEN}✓ Created index.theme${NC}"

# Create cursors directory
mkdir -p "$CURSOR_DIR/cursors"

# Create cursor config
cat > "$CURSOR_DIR/cursor.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6 Atma Weapon Cursor Theme
Inherits=Adwaita
EOF
echo -e "${GREEN}✓ Created cursor.theme${NC}"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}  Icons Created Successfully!           ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}Icons saved to: $ICONS_DIR${NC}"
echo -e "${YELLOW}Cursor saved to: $CURSOR_DIR${NC}"
