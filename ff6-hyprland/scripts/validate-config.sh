#!/bin/bash
# Script to test and validate the FF6-themed Hyprland configuration
# Part of FF6 Hyprland Configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="/home/ubuntu/hyprland-crimson-config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
KITTY_DIR="$CONFIG_DIR/kitty"
SCRIPTS_DIR="$CONFIG_DIR/scripts"
SPRITES_DIR="$CONFIG_DIR/sprites"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Configuration Validator  ${NC}"
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

# Function to validate JSON syntax
validate_json() {
    local file="$1"
    local name="$2"
    
    echo -ne "${YELLOW}Validating $name JSON syntax... ${NC}"
    if [ -f "$file" ]; then
        # Remove comments before validation
        cat "$file" | sed 's|//.*||g' | jq . >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Valid${NC}"
            return 0
        else
            echo -e "${RED}Invalid${NC}"
            return 1
        fi
    else
        echo -e "${RED}File not found${NC}"
        return 1
    fi
}

# Check main directories
echo -e "${BLUE}Checking main directories...${NC}"
check_dir "$CONFIG_DIR" "Configuration root"
check_dir "$HYPR_DIR" "Hyprland configuration"
check_dir "$WAYBAR_DIR" "Waybar configuration"
check_dir "$KITTY_DIR" "Kitty configuration"
check_dir "$SCRIPTS_DIR" "Scripts"
check_dir "$SPRITES_DIR" "Sprites"

# Check critical configuration files
echo -e "${BLUE}Checking critical configuration files...${NC}"
check_file "$HYPR_DIR/hyprland.conf" "Hyprland main config"
check_file "$HYPR_DIR/animations.conf" "Hyprland animations config"
check_file "$HYPR_DIR/colors.conf" "Hyprland colors config"
check_file "$WAYBAR_DIR/config-top.jsonc" "Waybar top config"
check_file "$WAYBAR_DIR/config-bottom.jsonc" "Waybar bottom config"
check_file "$KITTY_DIR/kitty.conf" "Kitty config"
check_file "$KITTY_DIR/ff_sprite.py" "Kitty FF6 sprite script"

# Check script files
echo -e "${BLUE}Checking script files...${NC}"
check_file "$SCRIPTS_DIR/integrate-sprites.sh" "Sprite integration script"
check_file "$SCRIPTS_DIR/pixel-sprite-converter.py" "Pixel sprite converter script"
check_file "$SCRIPTS_DIR/update-installer.sh" "Installer update script"
check_file "$SCRIPTS_DIR/waybar-fix/fix-waybar.sh" "Waybar fix script"

# Validate JSON syntax
echo -e "${BLUE}Validating JSON syntax...${NC}"
validate_json "$WAYBAR_DIR/config-top.jsonc" "Waybar top config"
validate_json "$WAYBAR_DIR/config-bottom.jsonc" "Waybar bottom config"

# Check for Python and dependencies
echo -e "${BLUE}Checking Python and dependencies...${NC}"
echo -ne "${YELLOW}Checking Python installation... ${NC}"
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}Found${NC}"
    
    echo -ne "${YELLOW}Checking PIL/Pillow installation... ${NC}"
    python3 -c "import PIL" &> /dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Found${NC}"
    else
        echo -e "${RED}Not found${NC}"
        echo -e "${YELLOW}Warning: PIL/Pillow is required for sprite conversion.${NC}"
    fi
else
    echo -e "${RED}Not found${NC}"
    echo -e "${YELLOW}Warning: Python is required for sprite conversion.${NC}"
fi

# Check for sprite files
echo -e "${BLUE}Checking sprite files...${NC}"
SPRITE_COUNT=$(ls -1 "$SPRITES_DIR"/*.png 2>/dev/null | wc -l)
echo -e "${YELLOW}Found $SPRITE_COUNT sprite files in $SPRITES_DIR${NC}"
if [ $SPRITE_COUNT -eq 0 ]; then
    echo -e "${RED}Warning: No sprite files found.${NC}"
fi

# Check Hyprland configuration for errors
echo -e "${BLUE}Checking Hyprland configuration for errors...${NC}"
echo -ne "${YELLOW}Checking for 'new_is_master = true' setting... ${NC}"
if grep -q "new_is_master = true" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${GREEN}Found${NC}"
else
    echo -e "${RED}Not found${NC}"
    echo -e "${YELLOW}Warning: 'new_is_master = true' setting is missing in hyprland.conf.${NC}"
fi

# Check waybar launch script
echo -e "${BLUE}Checking waybar launch script...${NC}"
echo -ne "${YELLOW}Checking for waybar launch script in hyprland.conf... ${NC}"
if grep -q "exec-once = .*launch-waybar.sh" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${GREEN}Found${NC}"
else
    echo -e "${RED}Not found${NC}"
    echo -e "${YELLOW}Warning: Waybar launch script is not configured in hyprland.conf.${NC}"
fi

# Final summary
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Validation complete!${NC}"
echo -e "${YELLOW}Please review any warnings or errors above.${NC}"
echo -e "${BLUE}=========================================${NC}"
