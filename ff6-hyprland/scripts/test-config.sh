#!/bin/bash
# Script to test the FF6-themed Hyprland configuration

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Testing FF6-themed Hyprland Config    ${NC}"
echo -e "${BLUE}=========================================${NC}"

# Test 1: Check if waybar configuration files exist
echo -e "${YELLOW}Testing waybar configuration files...${NC}"
if [ -f "$HOME/.config/hyprland-crimson-config/waybar/config.jsonc" ]; then
    echo -e "${GREEN}✓ waybar/config.jsonc exists${NC}"
else
    echo -e "${RED}✗ waybar/config.jsonc is missing${NC}"
fi

if [ -d "$HOME/.config/hyprland-crimson-config/waybar/modules" ]; then
    echo -e "${GREEN}✓ waybar/modules directory exists${NC}"
    
    # Check for specific module files
    for module in ff6-character-stats.jsonc ff6-menu-options.jsonc ff6-menu-drawer.jsonc; do
        if [ -f "$HOME/.config/hyprland-crimson-config/waybar/modules/$module" ]; then
            echo -e "${GREEN}  ✓ $module exists${NC}"
        else
            echo -e "${RED}  ✗ $module is missing${NC}"
        fi
    done
else
    echo -e "${RED}✗ waybar/modules directory is missing${NC}"
fi

if [ -f "$HOME/.config/hyprland-crimson-config/waybar/style.css" ]; then
    echo -e "${GREEN}✓ waybar/style.css exists${NC}"
else
    echo -e "${RED}✗ waybar/style.css is missing${NC}"
fi

# Test 2: Check if wlogout configuration files exist
echo -e "\n${YELLOW}Testing wlogout configuration files...${NC}"
if [ -d "$HOME/.config/hyprland-crimson-config/wlogout" ]; then
    echo -e "${GREEN}✓ wlogout directory exists${NC}"
    
    # Check for specific wlogout files
    for file in style.css layout; do
        if [ -f "$HOME/.config/hyprland-crimson-config/wlogout/$file" ]; then
            echo -e "${GREEN}  ✓ $file exists${NC}"
        else
            echo -e "${RED}  ✗ $file is missing${NC}"
        fi
    done
else
    echo -e "${RED}✗ wlogout directory is missing${NC}"
fi

# Test 3: Check if launch scripts exist and are executable
echo -e "\n${YELLOW}Testing launch scripts...${NC}"
if [ -f "$HOME/.config/hyprland-crimson-config/hypr/scripts/launch-waybar.sh" ]; then
    echo -e "${GREEN}✓ launch-waybar.sh exists${NC}"
    if [ -x "$HOME/.config/hyprland-crimson-config/hypr/scripts/launch-waybar.sh" ]; then
        echo -e "${GREEN}  ✓ launch-waybar.sh is executable${NC}"
    else
        echo -e "${RED}  ✗ launch-waybar.sh is not executable${NC}"
    fi
else
    echo -e "${RED}✗ launch-waybar.sh is missing${NC}"
fi

if [ -f "$HOME/.config/hyprland-crimson-config/hypr/scripts/logout.sh" ]; then
    echo -e "${GREEN}✓ logout.sh exists${NC}"
    if [ -x "$HOME/.config/hyprland-crimson-config/hypr/scripts/logout.sh" ]; then
        echo -e "${GREEN}  ✓ logout.sh is executable${NC}"
    else
        echo -e "${RED}  ✗ logout.sh is not executable${NC}"
    fi
else
    echo -e "${RED}✗ logout.sh is missing${NC}"
fi

# Test 4: Check if hyprland.conf includes the launch-waybar.sh script
echo -e "\n${YELLOW}Testing hyprland.conf configuration...${NC}"
if grep -q "launch-waybar.sh" "$HOME/.config/hyprland-crimson-config/hypr/hyprland.conf"; then
    echo -e "${GREEN}✓ hyprland.conf includes launch-waybar.sh${NC}"
else
    echo -e "${RED}✗ hyprland.conf does not include launch-waybar.sh${NC}"
fi

# Test 5: Validate JSON syntax in waybar config files
echo -e "\n${YELLOW}Validating waybar JSON syntax...${NC}"
if command -v jq &> /dev/null; then
    if jq empty "$HOME/.config/hyprland-crimson-config/waybar/config.jsonc" 2>/dev/null; then
        echo -e "${GREEN}✓ config.jsonc has valid JSON syntax${NC}"
    else
        echo -e "${RED}✗ config.jsonc has invalid JSON syntax${NC}"
    fi
    
    for module in ff6-character-stats.jsonc ff6-menu-options.jsonc ff6-menu-drawer.jsonc; do
        if [ -f "$HOME/.config/hyprland-crimson-config/waybar/modules/$module" ]; then
            if jq empty "$HOME/.config/hyprland-crimson-config/waybar/modules/$module" 2>/dev/null; then
                echo -e "${GREEN}  ✓ $module has valid JSON syntax${NC}"
            else
                echo -e "${RED}  ✗ $module has invalid JSON syntax${NC}"
            fi
        fi
    done
else
    echo -e "${YELLOW}  ! jq not installed, skipping JSON validation${NC}"
fi

echo -e "\n${BLUE}=========================================${NC}"
echo -e "${GREEN}Testing completed!${NC}"
echo -e "${BLUE}=========================================${NC}"
