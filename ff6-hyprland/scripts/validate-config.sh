#!/bin/bash
# FF6-Themed Hyprland Configuration - Validation Script
# This script validates that all components are properly configured

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base project directory
PROJECT_DIR="/home/ubuntu/hyprland-crimson-config"

# Function to check if a file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} File exists: $1"
        return 0
    else
        echo -e "${RED}✗${NC} File missing: $1"
        return 1
    fi
}

# Function to check if a directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} Directory exists: $1"
        return 0
    else
        echo -e "${RED}✗${NC} Directory missing: $1"
        return 1
    fi
}

# Function to check if a script is executable
check_executable() {
    if [ -x "$1" ]; then
        echo -e "${GREEN}✓${NC} Script is executable: $1"
        return 0
    else
        echo -e "${RED}✗${NC} Script is not executable: $1"
        return 1
    fi
}

# Print header
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   FF6-Themed Hyprland Configuration   ${NC}"
echo -e "${BLUE}          Validation Script            ${NC}"
echo -e "${BLUE}========================================${NC}"

# Initialize counters
total_checks=0
passed_checks=0

# Check Hyprland configuration
echo -e "\n${YELLOW}Checking Hyprland configuration...${NC}"
check_file "$PROJECT_DIR/hypr/hyprland.conf" && ((passed_checks++))
check_file "$PROJECT_DIR/hypr/keybinds.conf" && ((passed_checks++))
check_file "$PROJECT_DIR/hypr/animations.conf" && ((passed_checks++))
check_file "$PROJECT_DIR/hypr/colors.conf" && ((passed_checks++))
((total_checks+=4))

# Check Waybar configuration
echo -e "\n${YELLOW}Checking Waybar configuration...${NC}"
check_file "$PROJECT_DIR/waybar/config.jsonc" && ((passed_checks++))
check_file "$PROJECT_DIR/waybar/style.css" && ((passed_checks++))
check_dir "$PROJECT_DIR/waybar/modules" && ((passed_checks++))
check_file "$PROJECT_DIR/waybar/modules/standard.jsonc" && ((passed_checks++))
check_file "$PROJECT_DIR/waybar/modules/workspaces.jsonc" && ((passed_checks++))
check_file "$PROJECT_DIR/waybar/modules/custom.jsonc" && ((passed_checks++))
check_file "$PROJECT_DIR/waybar/modules/ff6-menu.jsonc" && ((passed_checks++))
((total_checks+=7))

# Check Rofi configuration
echo -e "\n${YELLOW}Checking Rofi configuration...${NC}"
check_file "$PROJECT_DIR/rofi/config.rasi" && ((passed_checks++))
check_file "$PROJECT_DIR/rofi/shared-fonts.rasi" && ((passed_checks++))
check_file "$PROJECT_DIR/rofi/themes/ff6-menu.rasi" && ((passed_checks++))
check_executable "$PROJECT_DIR/scripts/rofi-theme.sh" && ((passed_checks++))
((total_checks+=4))

# Check Cursor configuration
echo -e "\n${YELLOW}Checking Cursor configuration...${NC}"
check_dir "$PROJECT_DIR/cursor/AtmaWeapon" && ((passed_checks++))
check_file "$PROJECT_DIR/cursor/AtmaWeapon/cursor.theme" && ((passed_checks++))
check_dir "$PROJECT_DIR/cursor/AtmaWeapon/cursors" && ((passed_checks++))
check_executable "$PROJECT_DIR/scripts/fix-cursor.sh" && ((passed_checks++))
((total_checks+=4))

# Check Terminal configuration
echo -e "\n${YELLOW}Checking Terminal configuration...${NC}"
check_file "$PROJECT_DIR/kitty/kitty.conf" && ((passed_checks++))
check_file "$PROJECT_DIR/kitty/ff_sprite.py" && ((passed_checks++))
check_executable "$PROJECT_DIR/scripts/fix-terminal-sprites.sh" && ((passed_checks++))
((total_checks+=3))

# Check Wallpaper configuration
echo -e "\n${YELLOW}Checking Wallpaper configuration...${NC}"
check_dir "$PROJECT_DIR/wallpapers" && ((passed_checks++))
check_executable "$PROJECT_DIR/scripts/generate-wallpapers.sh" && ((passed_checks++))
((total_checks+=2))

# Check Scripts
echo -e "\n${YELLOW}Checking Scripts...${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/toggle-ff6-menu.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script to toggle the FF6 menu${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/toggle-theme.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script to toggle between light and dark themes${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/wallpaper-switcher.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script to switch wallpapers${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/volume.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script to control volume${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/brightness.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script to control brightness${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/lockscreen.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script to lock the screen${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/logout.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script for logout menu${NC}"
check_executable "$PROJECT_DIR/hypr/scripts/launch-waybar.sh" && ((passed_checks++)) || echo -e "${YELLOW}Note: Create this script to launch waybar${NC}"
((total_checks+=8))

# Calculate percentage
percentage=$((passed_checks * 100 / total_checks))

# Print summary
echo -e "\n${BLUE}========================================${NC}"
echo -e "${YELLOW}Validation Summary:${NC}"
echo -e "Passed checks: ${GREEN}$passed_checks${NC} / ${BLUE}$total_checks${NC} (${GREEN}$percentage%${NC})"

if [ $passed_checks -eq $total_checks ]; then
    echo -e "${GREEN}All checks passed! The FF6-themed Hyprland configuration is complete.${NC}"
else
    echo -e "${YELLOW}Some checks failed. Please fix the issues before using the configuration.${NC}"
    echo -e "${YELLOW}Note: You may need to create missing scripts or run the installation script.${NC}"
fi
echo -e "${BLUE}========================================${NC}"

# Return success if all checks passed
if [ $passed_checks -eq $total_checks ]; then
    exit 0
else
    exit 1
fi
