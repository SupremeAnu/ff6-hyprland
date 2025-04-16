#!/bin/bash

# Create FF6-themed wallpapers
# This script generates FF6-themed wallpapers for the Hyprland configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Creating FF6-themed Wallpapers        ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Create wallpapers directory
WALLPAPER_DIR="$(dirname "$0")/../wallpapers"
mkdir -p "$WALLPAPER_DIR"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${RED}ImageMagick is not installed. Please install it first.${NC}"
    echo -e "${YELLOW}You can install it with: sudo pacman -S imagemagick${NC}"
    exit 1
fi

# Create FF6 menu-style wallpaper
echo -e "${BLUE}Creating FF6 menu-style wallpaper...${NC}"
convert -size 1920x1080 gradient:"#0A1060-#2040A0" -fill white -draw "rectangle 10,10 1910,1070" -blur 0x2 "$WALLPAPER_DIR/ff6_menu.jpg"
echo -e "${GREEN}✓ Created FF6 menu-style wallpaper${NC}"

# Create FF6 battle background-style wallpaper
echo -e "${BLUE}Creating FF6 battle background-style wallpaper...${NC}"
convert -size 1920x1080 gradient:"#102050-#304080" -fill none -stroke white -strokewidth 2 -draw "path 'M 0,300 L 1920,200 M 0,600 L 1920,500 M 0,900 L 1920,800'" "$WALLPAPER_DIR/ff6_battle.jpg"
echo -e "${GREEN}✓ Created FF6 battle background-style wallpaper${NC}"

# Create FF6 world map-style wallpaper
echo -e "${BLUE}Creating FF6 world map-style wallpaper...${NC}"
convert -size 1920x1080 gradient:"#103070-#205090" -fill "#205090" -draw "rectangle 100,100 1820,980" -blur 0x5 "$WALLPAPER_DIR/ff6_world.jpg"
echo -e "${GREEN}✓ Created FF6 world map-style wallpaper${NC}"

# Create FF6 character-based wallpaper (simplified)
echo -e "${BLUE}Creating FF6 character-based wallpaper...${NC}"
convert -size 1920x1080 gradient:"#0A1060-#2040A0" -fill white -draw "rectangle 10,10 1910,1070" -blur 0x2 -fill none -stroke white -strokewidth 2 -draw "rectangle 100,100 500,500 rectangle 600,100 1000,500 rectangle 1100,100 1500,500 rectangle 100,600 500,1000 rectangle 600,600 1000,1000 rectangle 1100,600 1500,1000" "$WALLPAPER_DIR/ff6_characters.jpg"
echo -e "${GREEN}✓ Created FF6 character-based wallpaper${NC}"

# Set default wallpaper
echo -e "${BLUE}Setting default wallpaper...${NC}"
cp "$WALLPAPER_DIR/ff6_menu.jpg" "$WALLPAPER_DIR/current.jpg"
echo -e "${GREEN}✓ Set default wallpaper${NC}"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}  Wallpapers Created Successfully!      ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}Wallpapers saved to: $WALLPAPER_DIR${NC}"
echo -e "${YELLOW}Use swww to set these wallpapers:${NC}"
echo -e "${BLUE}swww img $WALLPAPER_DIR/ff6_menu.jpg${NC}"
