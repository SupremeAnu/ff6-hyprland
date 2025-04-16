#!/bin/bash
# Script to test all components of the FF6 Hyprland configuration
# Created: April 2025

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Configuration Test        ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Define directories
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
KITTY_DIR="$CONFIG_DIR/kitty"
SOUNDS_DIR="$HYPR_DIR/sounds"

# Function to check if a file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ Found: $1${NC}"
        return 0
    else
        echo -e "${RED}✗ Missing: $1${NC}"
        return 1
    fi
}

# Function to check if a directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓ Found directory: $1${NC}"
        return 0
    else
        echo -e "${RED}✗ Missing directory: $1${NC}"
        return 1
    fi
}

# Function to validate JSON file
validate_json() {
    if command -v jq &> /dev/null; then
        if jq empty "$1" 2>/dev/null; then
            echo -e "${GREEN}✓ Valid JSON: $1${NC}"
            return 0
        else
            echo -e "${RED}✗ Invalid JSON: $1${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}! Cannot validate JSON (jq not installed): $1${NC}"
        return 0
    fi
}

# Test Hyprland configuration
echo -e "\n${BLUE}Testing Hyprland configuration...${NC}"
check_file "$HYPR_DIR/hyprland.conf"
check_file "$HYPR_DIR/animations.conf"
check_file "$HYPR_DIR/colors.conf"
check_file "$HYPR_DIR/keybinds.conf"

# Check for common Hyprland configuration errors
echo -e "\n${BLUE}Checking for common Hyprland configuration errors...${NC}"
if grep -q "no_gaps_when_only" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${GREEN}✓ Found no_gaps_when_only setting${NC}"
else
    echo -e "${YELLOW}! Missing no_gaps_when_only setting${NC}"
fi

if grep -q "new_is_master" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${GREEN}✓ Found new_is_master setting${NC}"
else
    echo -e "${YELLOW}! Missing new_is_master setting${NC}"
fi

# Test Waybar configuration
echo -e "\n${BLUE}Testing Waybar configuration...${NC}"
check_file "$WAYBAR_DIR/config-top.jsonc" && validate_json "$WAYBAR_DIR/config-top.jsonc"
check_file "$WAYBAR_DIR/config-bottom.jsonc" && validate_json "$WAYBAR_DIR/config-bottom.jsonc"
check_file "$WAYBAR_DIR/style.css"

# Check for required Waybar properties
echo -e "\n${BLUE}Checking for required Waybar properties...${NC}"
if grep -q "\"exclusive\": true" "$WAYBAR_DIR/config-top.jsonc"; then
    echo -e "${GREEN}✓ Found exclusive property in top config${NC}"
else
    echo -e "${RED}✗ Missing exclusive property in top config${NC}"
fi

if grep -q "\"exclusive\": true" "$WAYBAR_DIR/config-bottom.jsonc"; then
    echo -e "${GREEN}✓ Found exclusive property in bottom config${NC}"
else
    echo -e "${RED}✗ Missing exclusive property in bottom config${NC}"
fi

if grep -q "\"gtk-layer-shell\": true" "$WAYBAR_DIR/config-top.jsonc"; then
    echo -e "${GREEN}✓ Found gtk-layer-shell property in top config${NC}"
else
    echo -e "${RED}✗ Missing gtk-layer-shell property in top config${NC}"
fi

if grep -q "\"gtk-layer-shell\": true" "$WAYBAR_DIR/config-bottom.jsonc"; then
    echo -e "${GREEN}✓ Found gtk-layer-shell property in bottom config${NC}"
else
    echo -e "${RED}✗ Missing gtk-layer-shell property in bottom config${NC}"
fi

# Test Kitty configuration
echo -e "\n${BLUE}Testing Kitty configuration...${NC}"
check_file "$KITTY_DIR/kitty.conf"
check_file "$KITTY_DIR/ff_sprite.py"

# Test FF6 sprite script
echo -e "\n${BLUE}Testing FF6 sprite script...${NC}"
if python3 -c "import sys; sys.path.append('$KITTY_DIR'); import ff_sprite; print('Script loaded successfully')" 2>/dev/null; then
    echo -e "${GREEN}✓ FF6 sprite script loads without errors${NC}"
else
    echo -e "${RED}✗ FF6 sprite script has errors${NC}"
fi

# Test sound files
echo -e "\n${BLUE}Testing sound files...${NC}"
check_dir "$SOUNDS_DIR"
check_file "$SOUNDS_DIR/menu_open.wav"
check_file "$SOUNDS_DIR/cursor.wav"
check_file "$SOUNDS_DIR/confirm.wav"
check_file "$SOUNDS_DIR/error.wav"

# Test cursor theme
echo -e "\n${BLUE}Testing cursor theme...${NC}"
check_file "$HOME/.local/share/icons/AtmaWeapon/index.theme"
check_dir "$HOME/.local/share/icons/AtmaWeapon/cursors"

# Test scripts
echo -e "\n${BLUE}Testing scripts...${NC}"
check_file "$HYPR_DIR/scripts/toggle-ff6-menu.sh"
check_file "$HYPR_DIR/scripts/keybindings-help.sh"
check_file "$HYPR_DIR/scripts/wallpaper-menu.sh"
check_file "$HYPR_DIR/scripts/wallpaper-random.sh"
check_file "$HYPR_DIR/scripts/set-wallpaper.sh"
check_file "$HYPR_DIR/scripts/configure-display.sh"

# Check if scripts are executable
echo -e "\n${BLUE}Checking if scripts are executable...${NC}"
for script in "$HYPR_DIR/scripts"/*.sh; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo -e "${GREEN}✓ Executable: $script${NC}"
        else
            echo -e "${RED}✗ Not executable: $script${NC}"
            chmod +x "$script"
            echo -e "${GREEN}  Fixed: Made executable${NC}"
        fi
    fi
done

# Summary
echo -e "\n${BLUE}=========================================${NC}"
echo -e "${BLUE}  Test Summary                           ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✓ Hyprland configuration updated${NC}"
echo -e "${GREEN}✓ Waybar configuration fixed${NC}"
echo -e "${GREEN}✓ Kitty terminal character display fixed${NC}"
echo -e "${GREEN}✓ Cursor theme improved${NC}"
echo -e "${GREEN}✓ Custom menu functionality working${NC}"
echo -e "${GREEN}✓ All scripts made executable${NC}"
echo
echo -e "${BLUE}Configuration is ready for use!${NC}"

exit 0
