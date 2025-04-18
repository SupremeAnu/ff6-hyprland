#!/bin/bash
# FF6-Themed Hyprland Configuration Test Script
# Tests all components of the FF6-themed Hyprland configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
KITTY_DIR="$CONFIG_DIR/kitty"
SWAPPY_DIR="$CONFIG_DIR/swappy"
SWAYNC_DIR="$CONFIG_DIR/swaync"
WLOGOUT_DIR="$CONFIG_DIR/wlogout"
WALLUST_DIR="$CONFIG_DIR/wallust"
CURSOR_DIR="$HOME/.local/share/icons/UltimaWeapon"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6-Themed Hyprland Configuration Test ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a file exists
check_file() {
    local file="$1"
    local description="$2"
    
    echo -ne "${CYAN}Checking $description... ${NC}"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}FOUND${NC}"
        return 0
    else
        echo -e "${RED}MISSING${NC}"
        return 1
    fi
}

# Function to check if a directory exists
check_dir() {
    local dir="$1"
    local description="$2"
    
    echo -ne "${CYAN}Checking $description... ${NC}"
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}FOUND${NC}"
        return 0
    else
        echo -e "${RED}MISSING${NC}"
        return 1
    fi
}

# Function to check if a command exists
check_command() {
    local cmd="$1"
    local description="$2"
    
    echo -ne "${CYAN}Checking $description... ${NC}"
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}FOUND${NC}"
        return 0
    else
        echo -e "${RED}MISSING${NC}"
        return 1
    fi
}

# Function to check if a string exists in a file
check_string_in_file() {
    local file="$1"
    local string="$2"
    local description="$3"
    
    echo -ne "${CYAN}Checking $description... ${NC}"
    
    if [ -f "$file" ] && grep -q "$string" "$file"; then
        echo -e "${GREEN}FOUND${NC}"
        return 0
    else
        echo -e "${RED}MISSING${NC}"
        return 1
    fi
}

# Test Hyprland configuration
test_hyprland() {
    echo -e "${BLUE}Testing Hyprland configuration...${NC}"
    
    local errors=0
    
    # Check main configuration file
    check_file "$HYPR_DIR/hyprland.conf" "Hyprland main configuration" || ((errors++))
    
    # Check important scripts
    check_file "$HYPR_DIR/scripts/launch-waybar.sh" "Waybar launch script" || ((errors++))
    check_file "$HYPR_DIR/scripts/logout.sh" "Logout script" || ((errors++))
    
    # Check for proper configuration
    check_string_in_file "$HYPR_DIR/hyprland.conf" "source = ./keybinds.conf" "Keybinds configuration" || ((errors++))
    check_string_in_file "$HYPR_DIR/hyprland.conf" "no_gaps_when_only = false" "Proper dwindle settings" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Hyprland configuration test passed!${NC}"
    else
        echo -e "${RED}Hyprland configuration test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Test Waybar configuration
test_waybar() {
    echo -e "${BLUE}Testing Waybar configuration...${NC}"
    
    local errors=0
    
    # Check main configuration files
    check_file "$WAYBAR_DIR/config.jsonc" "Waybar main configuration" || ((errors++))
    check_file "$WAYBAR_DIR/style.css" "Waybar style" || ((errors++))
    
    # Check modules
    check_dir "$WAYBAR_DIR/modules" "Waybar modules directory" || ((errors++))
    
    # Check for FF6 styling
    check_string_in_file "$WAYBAR_DIR/style.css" "background: linear-gradient" "FF6 gradient background" || ((errors++))
    check_string_in_file "$WAYBAR_DIR/style.css" "border-radius" "FF6 border styling" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Waybar configuration test passed!${NC}"
    else
        echo -e "${RED}Waybar configuration test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Test Kitty configuration
test_kitty() {
    echo -e "${BLUE}Testing Kitty configuration...${NC}"
    
    local errors=0
    
    # Check main configuration file
    check_file "$KITTY_DIR/kitty.conf" "Kitty main configuration" || ((errors++))
    
    # Check FF6 sprite script
    check_file "$KITTY_DIR/ff_sprite.py" "FF6 sprite script" || ((errors++))
    
    # Check for proper configuration
    check_string_in_file "$KITTY_DIR/kitty.conf" "background" "Kitty background color" || ((errors++))
    check_string_in_file "$KITTY_DIR/kitty.conf" "foreground" "Kitty foreground color" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Kitty configuration test passed!${NC}"
    else
        echo -e "${RED}Kitty configuration test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Test Rofi configuration
test_rofi() {
    echo -e "${BLUE}Testing Rofi configuration...${NC}"
    
    local errors=0
    
    # Check main configuration file
    check_file "$ROFI_DIR/config.rasi" "Rofi main configuration" || ((errors++))
    
    # Check FF6 theme
    check_file "$ROFI_DIR/themes/ff6-menu.rasi" "FF6 menu theme" || ((errors++))
    
    # Check for proper configuration
    check_string_in_file "$ROFI_DIR/config.rasi" "themes/ff6-menu.rasi" "FF6 theme reference" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Rofi configuration test passed!${NC}"
    else
        echo -e "${RED}Rofi configuration test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Test Wlogout configuration
test_wlogout() {
    echo -e "${BLUE}Testing Wlogout configuration...${NC}"
    
    local errors=0
    
    # Check main configuration files
    check_file "$WLOGOUT_DIR/layout" "Wlogout layout" || ((errors++))
    check_file "$WLOGOUT_DIR/style.css" "Wlogout style" || ((errors++))
    
    # Check for FF6 styling
    check_string_in_file "$WLOGOUT_DIR/style.css" "background" "Wlogout background" || ((errors++))
    check_string_in_file "$WLOGOUT_DIR/style.css" "border-radius" "Wlogout border styling" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Wlogout configuration test passed!${NC}"
    else
        echo -e "${RED}Wlogout configuration test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Test Wallust configuration
test_wallust() {
    echo -e "${BLUE}Testing Wallust configuration...${NC}"
    
    local errors=0
    
    # Check main configuration file
    check_file "$WALLUST_DIR/wallust.toml" "Wallust main configuration" || ((errors++))
    
    # Check templates directory
    check_dir "$WALLUST_DIR/templates" "Wallust templates directory" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Wallust configuration test passed!${NC}"
    else
        echo -e "${RED}Wallust configuration test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Test cursor theme
test_cursor() {
    echo -e "${BLUE}Testing cursor theme...${NC}"
    
    local errors=0
    
    # Check cursor directory
    check_dir "$CURSOR_DIR" "UltimaWeapon cursor directory" || ((errors++))
    
    # Check cursors directory
    check_dir "$CURSOR_DIR/cursors" "Cursors directory" || ((errors++))
    
    # Check index.theme file
    check_file "$CURSOR_DIR/index.theme" "Cursor theme index" || ((errors++))
    
    # Check main cursor file
    check_file "$CURSOR_DIR/cursors/left_ptr" "Main cursor file" || ((errors++))
    
    # Check text cursor file
    check_file "$CURSOR_DIR/cursors/text" "Text cursor file" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Cursor theme test passed!${NC}"
    else
        echo -e "${RED}Cursor theme test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Test required commands
test_commands() {
    echo -e "${BLUE}Testing required commands...${NC}"
    
    local errors=0
    
    # Check for required commands
    check_command "hyprland" "Hyprland" || ((errors++))
    check_command "waybar" "Waybar" || ((errors++))
    check_command "kitty" "Kitty terminal" || ((errors++))
    check_command "rofi" "Rofi launcher" || ((errors++))
    check_command "wlogout" "Wlogout" || ((errors++))
    check_command "convert" "ImageMagick" || ((errors++))
    check_command "python3" "Python 3" || ((errors++))
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Required commands test passed!${NC}"
    else
        echo -e "${RED}Required commands test failed with $errors errors.${NC}"
    fi
    
    return $errors
}

# Run all tests
run_all_tests() {
    echo -e "${BLUE}Running all tests...${NC}"
    
    local total_errors=0
    
    # Run individual tests
    test_hyprland
    total_errors=$((total_errors + $?))
    
    test_waybar
    total_errors=$((total_errors + $?))
    
    test_kitty
    total_errors=$((total_errors + $?))
    
    test_rofi
    total_errors=$((total_errors + $?))
    
    test_wlogout
    total_errors=$((total_errors + $?))
    
    test_wallust
    total_errors=$((total_errors + $?))
    
    test_cursor
    total_errors=$((total_errors + $?))
    
    test_commands
    total_errors=$((total_errors + $?))
    
    # Print summary
    echo -e "${BLUE}=========================================${NC}"
    if [ $total_errors -eq 0 ]; then
        echo -e "${GREEN}All tests passed successfully!${NC}"
        echo -e "${GREEN}FF6-themed Hyprland configuration is ready to use.${NC}"
    else
        echo -e "${RED}Tests completed with $total_errors errors.${NC}"
        echo -e "${YELLOW}Please fix the issues before using the configuration.${NC}"
        echo -e "${CYAN}Run the fix-configurations.sh script to attempt automatic fixes.${NC}"
    fi
    echo -e "${BLUE}=========================================${NC}"
    
    return $total_errors
}

# Main function
main() {
    run_all_tests
    return $?
}

# Run the main function
main
