#!/bin/bash
# Script to update the installer to include validation and fix common issues
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

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Installer Updater        ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if Waybar is running
check_waybar_running() {
    if pgrep -x "waybar" > /dev/null; then
        echo -e "${GREEN}Waybar is running.${NC}"
        return 0
    else
        echo -e "${RED}Waybar is not running.${NC}"
        return 1
    fi
}

# Function to restart Waybar
restart_waybar() {
    echo -e "${YELLOW}Restarting Waybar...${NC}"
    killall waybar 2>/dev/null
    sleep 1
    waybar -c "$WAYBAR_DIR/config-top.jsonc" & disown
    waybar -c "$WAYBAR_DIR/config-bottom.jsonc" & disown
    echo -e "${GREEN}Waybar restarted.${NC}"
}

# Function to check Hyprland configuration
check_hyprland_config() {
    echo -e "${YELLOW}Checking Hyprland configuration...${NC}"
    if command -v hyprctl &> /dev/null; then
        ERRORS=$(hyprctl reload 2>&1 | grep -c "error")
        if [ "$ERRORS" -gt 0 ]; then
            echo -e "${RED}Found $ERRORS errors in Hyprland configuration.${NC}"
            hyprctl reload 2>&1 | grep "error"
            return 1
        else
            echo -e "${GREEN}Hyprland configuration is valid.${NC}"
            return 0
        fi
    else
        echo -e "${RED}Hyprland is not installed or not in PATH.${NC}"
        return 1
    fi
}

# Function to fix common Hyprland configuration issues
fix_hyprland_config() {
    echo -e "${YELLOW}Fixing common Hyprland configuration issues...${NC}"
    
    # Check for decoration shadow syntax
    if grep -q "drop_shadow" "$HYPR_DIR/hyprland.conf" && ! grep -q "shadow {" "$HYPR_DIR/hyprland.conf"; then
        echo -e "${YELLOW}Fixing decoration shadow syntax...${NC}"
        sed -i 's/drop_shadow = true/shadow {\n    enabled = true/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/shadow_range = \([0-9]*\)/    range = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/shadow_render_power = \([0-9]*\)/    render_power = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/shadow_ignore_window = \(true\|false\)/    ignore_window = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/shadow_offset = \([0-9]* [0-9]*\)/    offset = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/shadow_scale = \([0-9.]*\)/    scale = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/col.shadow = \(0x[0-9a-fA-F]*\)/    color = \1\n}/g' "$HYPR_DIR/hyprland.conf"
        echo -e "${GREEN}Decoration shadow syntax fixed.${NC}"
    fi
    
    # Check for blur syntax
    if grep -q "blur =" "$HYPR_DIR/hyprland.conf" && ! grep -q "blur {" "$HYPR_DIR/hyprland.conf"; then
        echo -e "${YELLOW}Fixing blur syntax...${NC}"
        sed -i 's/blur = \(true\|false\)/blur {\n    enabled = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/blur_size = \([0-9]*\)/    size = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/blur_passes = \([0-9]*\)/    passes = \1/g' "$HYPR_DIR/hyprland.conf"
        sed -i 's/blur_new_optimizations = \(true\|false\)/    new_optimizations = \1\n}/g' "$HYPR_DIR/hyprland.conf"
        echo -e "${GREEN}Blur syntax fixed.${NC}"
    fi
    
    echo -e "${GREEN}Hyprland configuration fixes applied.${NC}"
}

# Function to check Waybar configuration
check_waybar_config() {
    echo -e "${YELLOW}Checking Waybar configuration...${NC}"
    
    # Check top config
    if [ -f "$WAYBAR_DIR/config-top.jsonc" ]; then
        if grep -q "wlr/taskbar" "$WAYBAR_DIR/config-top.jsonc"; then
            echo -e "${RED}Found outdated wlr/taskbar module in top config.${NC}"
            return 1
        fi
    else
        echo -e "${RED}Waybar top config not found.${NC}"
        return 1
    fi
    
    # Check bottom config
    if [ -f "$WAYBAR_DIR/config-bottom.jsonc" ]; then
        if ! grep -q "hyprland/workspaces" "$WAYBAR_DIR/config-bottom.jsonc"; then
            echo -e "${RED}Missing hyprland/workspaces module in bottom config.${NC}"
            return 1
        fi
    else
        echo -e "${RED}Waybar bottom config not found.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Waybar configuration is valid.${NC}"
    return 0
}

# Function to fix common Waybar configuration issues
fix_waybar_config() {
    echo -e "${YELLOW}Fixing common Waybar configuration issues...${NC}"
    
    # Fix top config
    if [ -f "$WAYBAR_DIR/config-top.jsonc" ]; then
        if grep -q "wlr/taskbar" "$WAYBAR_DIR/config-top.jsonc"; then
            echo -e "${YELLOW}Replacing wlr/taskbar with hyprland/workspaces in top config...${NC}"
            sed -i 's/"wlr\/taskbar"/"hyprland\/workspaces"/g' "$WAYBAR_DIR/config-top.jsonc"
            echo -e "${GREEN}Top config fixed.${NC}"
        fi
        
        # Add required properties if missing
        if ! grep -q "exclusive" "$WAYBAR_DIR/config-top.jsonc"; then
            echo -e "${YELLOW}Adding exclusive property to top config...${NC}"
            sed -i '/"position": "top",/a \    "exclusive": true,' "$WAYBAR_DIR/config-top.jsonc"
        fi
        
        if ! grep -q "passthrough" "$WAYBAR_DIR/config-top.jsonc"; then
            echo -e "${YELLOW}Adding passthrough property to top config...${NC}"
            sed -i '/"exclusive": true,/a \    "passthrough": false,' "$WAYBAR_DIR/config-top.jsonc"
        fi
        
        if ! grep -q "gtk-layer-shell" "$WAYBAR_DIR/config-top.jsonc"; then
            echo -e "${YELLOW}Adding gtk-layer-shell property to top config...${NC}"
            sed -i '/"passthrough": false,/a \    "gtk-layer-shell": true,' "$WAYBAR_DIR/config-top.jsonc"
        fi
    fi
    
    # Fix bottom config
    if [ -f "$WAYBAR_DIR/config-bottom.jsonc" ]; then
        # Add required properties if missing
        if ! grep -q "exclusive" "$WAYBAR_DIR/config-bottom.jsonc"; then
            echo -e "${YELLOW}Adding exclusive property to bottom config...${NC}"
            sed -i '/"position": "bottom",/a \    "exclusive": true,' "$WAYBAR_DIR/config-bottom.jsonc"
        fi
        
        if ! grep -q "passthrough" "$WAYBAR_DIR/config-bottom.jsonc"; then
            echo -e "${YELLOW}Adding passthrough property to bottom config...${NC}"
            sed -i '/"exclusive": true,/a \    "passthrough": false,' "$WAYBAR_DIR/config-bottom.jsonc"
        fi
        
        if ! grep -q "gtk-layer-shell" "$WAYBAR_DIR/config-bottom.jsonc"; then
            echo -e "${YELLOW}Adding gtk-layer-shell property to bottom config...${NC}"
            sed -i '/"passthrough": false,/a \    "gtk-layer-shell": true,' "$WAYBAR_DIR/config-bottom.jsonc"
        fi
        
        # Add persistent workspaces if missing
        if ! grep -q "persistent-workspaces" "$WAYBAR_DIR/config-bottom.jsonc"; then
            echo -e "${YELLOW}Adding persistent-workspaces to bottom config...${NC}"
            sed -i '/"sort-by-number": true,/a \        "persistent-workspaces": {\n            "*": 5\n        }' "$WAYBAR_DIR/config-bottom.jsonc"
        fi
    fi
    
    echo -e "${GREEN}Waybar configuration fixes applied.${NC}"
}

# Check and fix Hyprland configuration
if ! check_hyprland_config; then
    fix_hyprland_config
    check_hyprland_config
fi

# Check and fix Waybar configuration
if ! check_waybar_config; then
    fix_waybar_config
    check_waybar_config
fi

# Restart Waybar if it was running
if check_waybar_running; then
    restart_waybar
fi

# Run dotfile validation
if [ -f "scripts/validate-dotfiles.sh" ]; then
    echo -e "${YELLOW}Running dotfile validation...${NC}"
    chmod +x "scripts/validate-dotfiles.sh"
    ./scripts/validate-dotfiles.sh
else
    echo -e "${RED}Dotfile validation script not found.${NC}"
fi

# Final message
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Installer update complete!${NC}"
echo -e "${YELLOW}The installer has been updated to include validation and fix common issues.${NC}"
echo -e "${BLUE}=========================================${NC}"
