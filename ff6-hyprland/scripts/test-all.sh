#!/bin/bash
# Script to test the FF6 Hyprland configuration
# Part of FF6 Hyprland Configuration

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

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Configuration Tester     ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a file exists
check_file() {
    local file="$1"
    local name="$2"
    
    echo -ne "${YELLOW}Checking $name file... ${NC}"
    if [ -f "$file" ]; then
        echo -e "${GREEN}Found${NC}"
        return 0
    else
        echo -e "${RED}Not found${NC}"
        return 1
    fi
}

# Function to check if a directory exists
check_dir() {
    local dir="$1"
    local name="$2"
    
    echo -ne "${YELLOW}Checking $name directory... ${NC}"
    if [ -d "$dir" ]; then
        echo -e "${GREEN}Found${NC}"
        return 0
    else
        echo -e "${RED}Not found${NC}"
        return 1
    fi
}

# Function to validate JSON/JSONC file
validate_json() {
    local file="$1"
    local name="$2"
    
    echo -ne "${YELLOW}Validating $name JSON... ${NC}"
    if [ -f "$file" ]; then
        # Remove comments from JSONC files
        local json_content=$(cat "$file" | sed 's|//.*||g')
        
        # Check if jq is installed
        if command -v jq &> /dev/null; then
            if echo "$json_content" | jq . &> /dev/null; then
                echo -e "${GREEN}Valid${NC}"
                return 0
            else
                echo -e "${RED}Invalid${NC}"
                echo -e "${RED}JSON validation error in $file${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}Skipped (jq not installed)${NC}"
            return 0
        fi
    else
        echo -e "${RED}File not found${NC}"
        return 1
    fi
}

# Function to test Hyprland configuration
test_hyprland_config() {
    echo -e "${BLUE}Testing Hyprland configuration...${NC}"
    
    # Check if hyprctl is available
    if command -v hyprctl &> /dev/null; then
        echo -ne "${YELLOW}Validating hyprland.conf... ${NC}"
        if hyprctl reload 2>&1 | grep -q "error"; then
            echo -e "${RED}Invalid${NC}"
            hyprctl reload 2>&1 | grep "error"
            return 1
        else
            echo -e "${GREEN}Valid${NC}"
        fi
    else
        echo -e "${YELLOW}Skipping Hyprland validation (hyprctl not available)${NC}"
    fi
    
    # Check for required configuration files
    check_file "$HYPR_DIR/hyprland.conf" "main config"
    check_file "$HYPR_DIR/animations.conf" "animations config"
    check_file "$HYPR_DIR/colors.conf" "colors config"
    check_file "$HYPR_DIR/keybinds.conf" "keybinds config"
    
    # Check for required scripts
    check_file "$HYPR_DIR/scripts/set-wallpaper.sh" "wallpaper script"
    check_file "$HYPR_DIR/scripts/wallpaper-menu.sh" "wallpaper menu script"
    check_file "$HYPR_DIR/scripts/wallpaper-random.sh" "random wallpaper script"
    check_file "$HYPR_DIR/scripts/toggle-ff6-menu.sh" "FF6 menu toggle script"
    check_file "$HYPR_DIR/scripts/keybindings-help.sh" "keybindings help script"
    
    # Check for shadow syntax
    echo -ne "${YELLOW}Checking shadow syntax... ${NC}"
    if grep -q "shadow {" "$HYPR_DIR/hyprland.conf"; then
        echo -e "${GREEN}Valid${NC}"
    else
        echo -e "${RED}Invalid${NC}"
        echo -e "${RED}Shadow syntax is outdated. Run update-installer.sh to fix.${NC}"
        return 1
    fi
    
    # Check for blur syntax
    echo -ne "${YELLOW}Checking blur syntax... ${NC}"
    if grep -q "blur {" "$HYPR_DIR/hyprland.conf"; then
        echo -e "${GREEN}Valid${NC}"
    else
        echo -e "${RED}Invalid${NC}"
        echo -e "${RED}Blur syntax is outdated. Run update-installer.sh to fix.${NC}"
        return 1
    fi
    
    return 0
}

# Function to test Waybar configuration
test_waybar_config() {
    echo -e "${BLUE}Testing Waybar configuration...${NC}"
    
    # Check for required configuration files
    check_file "$WAYBAR_DIR/config-top.jsonc" "top config"
    check_file "$WAYBAR_DIR/config-bottom.jsonc" "bottom config"
    check_file "$WAYBAR_DIR/style.css" "style"
    
    # Validate JSON files
    validate_json "$WAYBAR_DIR/config-top.jsonc" "top config"
    validate_json "$WAYBAR_DIR/config-bottom.jsonc" "bottom config"
    
    # Check for hyprland/workspaces module
    echo -ne "${YELLOW}Checking for hyprland/workspaces module... ${NC}"
    if grep -q "hyprland/workspaces" "$WAYBAR_DIR/config-top.jsonc" || grep -q "hyprland/workspaces" "$WAYBAR_DIR/config-bottom.jsonc"; then
        echo -e "${GREEN}Found${NC}"
    else
        echo -e "${RED}Not found${NC}"
        echo -e "${RED}hyprland/workspaces module is missing. Run update-installer.sh to fix.${NC}"
        return 1
    fi
    
    # Check for required properties
    echo -ne "${YELLOW}Checking for required Waybar properties... ${NC}"
    if grep -q "exclusive" "$WAYBAR_DIR/config-top.jsonc" && grep -q "passthrough" "$WAYBAR_DIR/config-top.jsonc" && grep -q "gtk-layer-shell" "$WAYBAR_DIR/config-top.jsonc"; then
        echo -e "${GREEN}Found${NC}"
    else
        echo -e "${RED}Missing${NC}"
        echo -e "${RED}Required Waybar properties are missing. Run update-installer.sh to fix.${NC}"
        return 1
    fi
    
    return 0
}

# Function to test Rofi configuration
test_rofi_config() {
    echo -e "${BLUE}Testing Rofi configuration...${NC}"
    
    # Check for required configuration files
    check_file "$ROFI_DIR/config.rasi" "config"
    check_file "$ROFI_DIR/ff6-theme.rasi" "FF6 theme"
    check_file "$ROFI_DIR/scripts/powermenu.sh" "power menu script"
    
    return 0
}

# Function to test Kitty configuration
test_kitty_config() {
    echo -e "${BLUE}Testing Kitty configuration...${NC}"
    
    # Check for required configuration files
    check_file "$KITTY_DIR/kitty.conf" "config"
    check_file "$KITTY_DIR/ff_sprite.py" "FF6 sprite script"
    
    # Test FF6 sprite script
    echo -ne "${YELLOW}Testing FF6 sprite script... ${NC}"
    if python3 "$KITTY_DIR/ff_sprite.py" &> /dev/null; then
        echo -e "${GREEN}Working${NC}"
    else
        echo -e "${RED}Error${NC}"
        echo -e "${RED}FF6 sprite script has errors.${NC}"
        return 1
    fi
    
    return 0
}

# Function to test sound effects
test_sound_effects() {
    echo -e "${BLUE}Testing sound effects...${NC}"
    
    # Check for required sound files
    check_file "$SOUNDS_DIR/cursor.wav" "cursor sound"
    check_file "$SOUNDS_DIR/confirm.wav" "confirm sound"
    check_file "$SOUNDS_DIR/menu_open.wav" "menu open sound"
    check_file "$SOUNDS_DIR/error.wav" "error sound"
    
    # Test playing sounds if sox is installed
    if command -v play &> /dev/null; then
        echo -ne "${YELLOW}Testing sound playback... ${NC}"
        if play -q "$SOUNDS_DIR/cursor.wav" &> /dev/null; then
            echo -e "${GREEN}Working${NC}"
        else
            echo -e "${RED}Error${NC}"
            echo -e "${RED}Sound playback failed.${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}Skipping sound playback test (sox not installed)${NC}"
    fi
    
    return 0
}

# Run all tests
test_hyprland_config
test_waybar_config
test_rofi_config
test_kitty_config
test_sound_effects

# Run dotfile validation
if [ -f "scripts/validate-dotfiles.sh" ]; then
    echo -e "${BLUE}Running dotfile validation...${NC}"
    ./scripts/validate-dotfiles.sh
else
    echo -e "${RED}Dotfile validation script not found.${NC}"
fi

# Final message
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Configuration testing complete!${NC}"
echo -e "${YELLOW}If any issues were found, please run the update-installer.sh script to fix them.${NC}"
echo -e "${BLUE}=========================================${NC}"
