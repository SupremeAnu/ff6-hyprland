#!/bin/bash
# Script to test all FF6 Hyprland configuration components
# Created: April 2025

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
KITTY_DIR="$CONFIG_DIR/kitty"
SOUNDS_DIR="$HYPR_DIR/sounds"
CURSOR_DIR="$HOME/.local/share/icons/AtmaWeapon"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Configuration Test       ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ $1 exists${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 does not exist${NC}"
        return 1
    fi
}

# Function to check if a directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓ $1 exists${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 does not exist${NC}"
        return 1
    fi
}

# Function to check if a command exists
command_exists() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓ $1 is installed${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 is not installed${NC}"
        return 1
    fi
}

# Function to check if a script is executable
check_executable() {
    if [ -x "$1" ]; then
        echo -e "${GREEN}✓ $1 is executable${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 is not executable${NC}"
        return 1
    fi
}

# Function to validate JSON file
validate_json() {
    if command -v jq &> /dev/null; then
        if jq empty "$1" 2>/dev/null; then
            echo -e "${GREEN}✓ $1 is valid JSON${NC}"
            return 0
        else
            echo -e "${RED}✗ $1 contains invalid JSON${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}! Cannot validate JSON (jq not installed)${NC}"
        return 2
    fi
}

# Test Hyprland configuration
echo -e "${BLUE}Testing Hyprland configuration...${NC}"
HYPR_ERRORS=0

check_file "$HYPR_DIR/hyprland.conf" || ((HYPR_ERRORS++))
check_file "$HYPR_DIR/animations.conf" || ((HYPR_ERRORS++))
check_file "$HYPR_DIR/colors.conf" || ((HYPR_ERRORS++))
check_file "$HYPR_DIR/keybinds.conf" || ((HYPR_ERRORS++))

# Test Waybar configuration
echo -e "\n${BLUE}Testing Waybar configuration...${NC}"
WAYBAR_ERRORS=0

check_file "$WAYBAR_DIR/config-top.jsonc" || ((WAYBAR_ERRORS++))
check_file "$WAYBAR_DIR/config-bottom.jsonc" || ((WAYBAR_ERRORS++))
check_file "$WAYBAR_DIR/style.css" || ((WAYBAR_ERRORS++))

# Validate Waybar JSON files
if check_file "$WAYBAR_DIR/config-top.jsonc"; then
    validate_json "$WAYBAR_DIR/config-top.jsonc" || ((WAYBAR_ERRORS++))
fi

if check_file "$WAYBAR_DIR/config-bottom.jsonc"; then
    validate_json "$WAYBAR_DIR/config-bottom.jsonc" || ((WAYBAR_ERRORS++))
fi

# Test Rofi configuration
echo -e "\n${BLUE}Testing Rofi configuration...${NC}"
ROFI_ERRORS=0

check_file "$ROFI_DIR/config.rasi" || ((ROFI_ERRORS++))
check_file "$ROFI_DIR/crimson-theme.rasi" || ((ROFI_ERRORS++))
check_dir "$ROFI_DIR/scripts" || ((ROFI_ERRORS++))
check_file "$ROFI_DIR/scripts/powermenu.sh" || ((ROFI_ERRORS++))
check_executable "$ROFI_DIR/scripts/powermenu.sh" || ((ROFI_ERRORS++))

# Test Kitty configuration
echo -e "\n${BLUE}Testing Kitty configuration...${NC}"
KITTY_ERRORS=0

check_file "$KITTY_DIR/kitty.conf" || ((KITTY_ERRORS++))
check_file "$KITTY_DIR/ff_sprite.py" || ((KITTY_ERRORS++))
check_executable "$KITTY_DIR/ff_sprite.py" || ((KITTY_ERRORS++))

# Test scripts
echo -e "\n${BLUE}Testing scripts...${NC}"
SCRIPT_ERRORS=0

check_file "$HYPR_DIR/scripts/configure-display.sh" || ((SCRIPT_ERRORS++))
check_executable "$HYPR_DIR/scripts/configure-display.sh" || ((SCRIPT_ERRORS++))

check_file "$HYPR_DIR/scripts/set-wallpaper.sh" || ((SCRIPT_ERRORS++))
check_executable "$HYPR_DIR/scripts/set-wallpaper.sh" || ((SCRIPT_ERRORS++))

check_file "$HYPR_DIR/scripts/wallpaper-menu.sh" || ((SCRIPT_ERRORS++))
check_executable "$HYPR_DIR/scripts/wallpaper-menu.sh" || ((SCRIPT_ERRORS++))

check_file "$HYPR_DIR/scripts/wallpaper-random.sh" || ((SCRIPT_ERRORS++))
check_executable "$HYPR_DIR/scripts/wallpaper-random.sh" || ((SCRIPT_ERRORS++))

check_file "$HYPR_DIR/scripts/keybindings-help.sh" || ((SCRIPT_ERRORS++))
check_executable "$HYPR_DIR/scripts/keybindings-help.sh" || ((SCRIPT_ERRORS++))

check_file "$HYPR_DIR/scripts/toggle-ff6-menu.sh" || ((SCRIPT_ERRORS++))
check_executable "$HYPR_DIR/scripts/toggle-ff6-menu.sh" || ((SCRIPT_ERRORS++))

# Test sound files
echo -e "\n${BLUE}Testing sound files...${NC}"
SOUND_ERRORS=0

check_dir "$SOUNDS_DIR" || ((SOUND_ERRORS++))
check_file "$SOUNDS_DIR/cursor.wav" || ((SOUND_ERRORS++))
check_file "$SOUNDS_DIR/confirm.wav" || ((SOUND_ERRORS++))
check_file "$SOUNDS_DIR/menu_open.wav" || ((SOUND_ERRORS++))
check_file "$SOUNDS_DIR/error.wav" || ((SOUND_ERRORS++))

check_file "$HYPR_DIR/scripts/play-sound.sh" || ((SOUND_ERRORS++))
check_executable "$HYPR_DIR/scripts/play-sound.sh" || ((SOUND_ERRORS++))

# Test cursor theme
echo -e "\n${BLUE}Testing cursor theme...${NC}"
CURSOR_ERRORS=0

check_dir "$CURSOR_DIR" || ((CURSOR_ERRORS++))
check_file "$CURSOR_DIR/cursor.theme" || ((CURSOR_ERRORS++))
check_dir "$CURSOR_DIR/cursors" || ((CURSOR_ERRORS++))

# Test required commands
echo -e "\n${BLUE}Testing required commands...${NC}"
COMMAND_ERRORS=0

command_exists "hyprctl" || ((COMMAND_ERRORS++))
command_exists "waybar" || ((COMMAND_ERRORS++))
command_exists "rofi" || ((COMMAND_ERRORS++))
command_exists "kitty" || ((COMMAND_ERRORS++))
command_exists "swww" || ((COMMAND_ERRORS++))
command_exists "swaync-client" || ((COMMAND_ERRORS++))
command_exists "sox" || ((COMMAND_ERRORS++))

# Test resolution detection
echo -e "\n${BLUE}Testing resolution detection...${NC}"
if command_exists "hyprctl"; then
    RESOLUTION=$(hyprctl monitors -j 2>/dev/null | jq -r '.[0].width, .[0].height' 2>/dev/null)
    WIDTH=$(echo "$RESOLUTION" | head -1)
    HEIGHT=$(echo "$RESOLUTION" | tail -1)
    
    if [[ "$WIDTH" =~ ^[0-9]+$ ]] && [[ "$HEIGHT" =~ ^[0-9]+$ ]]; then
        echo -e "${GREEN}✓ Detected resolution: ${WIDTH}x${HEIGHT}${NC}"
        
        if [ "$HEIGHT" -ge 2160 ]; then
            echo -e "${GREEN}✓ 4K display detected (${WIDTH}x${HEIGHT})${NC}"
        elif [ "$HEIGHT" -ge 1440 ]; then
            echo -e "${GREEN}✓ 1440p display detected (${WIDTH}x${HEIGHT})${NC}"
        else
            echo -e "${GREEN}✓ 1080p or lower display detected (${WIDTH}x${HEIGHT})${NC}"
        fi
    else
        echo -e "${RED}✗ Failed to detect resolution${NC}"
        ((COMMAND_ERRORS++))
    fi
else
    echo -e "${YELLOW}! Cannot test resolution detection (hyprctl not installed)${NC}"
fi

# Summary
echo -e "\n${BLUE}Test Summary:${NC}"
echo -e "Hyprland configuration: $([ $HYPR_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($HYPR_ERRORS errors)${NC}")"
echo -e "Waybar configuration: $([ $WAYBAR_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($WAYBAR_ERRORS errors)${NC}")"
echo -e "Rofi configuration: $([ $ROFI_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($ROFI_ERRORS errors)${NC}")"
echo -e "Kitty configuration: $([ $KITTY_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($KITTY_ERRORS errors)${NC}")"
echo -e "Scripts: $([ $SCRIPT_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($SCRIPT_ERRORS errors)${NC}")"
echo -e "Sound files: $([ $SOUND_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($SOUND_ERRORS errors)${NC}")"
echo -e "Cursor theme: $([ $CURSOR_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($CURSOR_ERRORS errors)${NC}")"
echo -e "Required commands: $([ $COMMAND_ERRORS -eq 0 ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL ($COMMAND_ERRORS errors)${NC}")"

TOTAL_ERRORS=$((HYPR_ERRORS + WAYBAR_ERRORS + ROFI_ERRORS + KITTY_ERRORS + SCRIPT_ERRORS + SOUND_ERRORS + CURSOR_ERRORS + COMMAND_ERRORS))

echo -e "\n${BLUE}=========================================${NC}"
if [ $TOTAL_ERRORS -eq 0 ]; then
    echo -e "${GREEN}All tests passed successfully!${NC}"
else
    echo -e "${RED}Tests completed with $TOTAL_ERRORS errors.${NC}"
fi
echo -e "${BLUE}=========================================${NC}"
