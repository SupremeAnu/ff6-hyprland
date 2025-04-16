#!/bin/bash

# Test Configuration Script for FF6 Hyprland
# This script tests the FF6 Hyprland configuration to ensure everything works correctly

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Configuration Test       ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
KITTY_DIR="$CONFIG_DIR/kitty"
SWAYNC_DIR="$CONFIG_DIR/swaync"

# Check if Hyprland config exists
if [ ! -d "$HYPR_DIR" ]; then
  echo -e "${RED}Hyprland configuration not found at $HYPR_DIR${NC}"
  echo -e "${YELLOW}Please run the installer first${NC}"
  exit 1
fi

# Function to check if a file exists and is not empty
check_file() {
  local file="$1"
  local description="$2"
  
  if [ -f "$file" ]; then
    if [ -s "$file" ]; then
      echo -e "${GREEN}✓ $description found and not empty${NC}"
      return 0
    else
      echo -e "${RED}✗ $description exists but is empty${NC}"
      return 1
    fi
  else
    echo -e "${RED}✗ $description not found${NC}"
    return 1
  fi
}

# Function to check if a directory exists
check_dir() {
  local dir="$1"
  local description="$2"
  
  if [ -d "$dir" ]; then
    echo -e "${GREEN}✓ $description directory found${NC}"
    return 0
  else
    echo -e "${RED}✗ $description directory not found${NC}"
    return 1
  fi
}

# Function to check if a package is installed
check_package() {
  local package="$1"
  
  if command -v "$package" &> /dev/null || pacman -Q "$package" &> /dev/null; then
    echo -e "${GREEN}✓ $package is installed${NC}"
    return 0
  else
    echo -e "${RED}✗ $package is not installed${NC}"
    return 1
  fi
}

# Function to check if a service is running
check_service() {
  local service="$1"
  local process_name="${2:-$service}"
  
  if pgrep -x "$process_name" &> /dev/null; then
    echo -e "${GREEN}✓ $service is running${NC}"
    return 0
  else
    echo -e "${YELLOW}! $service is not running${NC}"
    return 1
  fi
}

# Create a test report directory
TEST_DIR="$HOME/.config/hypr/test-reports"
mkdir -p "$TEST_DIR"
TEST_REPORT="$TEST_DIR/test-report-$(date +%Y%m%d-%H%M%S).txt"

# Redirect output to both console and file
exec > >(tee -a "$TEST_REPORT") 2>&1

echo "FF6 Hyprland Configuration Test Report" > "$TEST_REPORT"
echo "Date: $(date)" >> "$TEST_REPORT"
echo "----------------------------------------" >> "$TEST_REPORT"

# Test Hyprland configuration files
echo -e "\n${BLUE}Testing Hyprland configuration files...${NC}"
check_file "$HYPR_DIR/hyprland.conf" "Hyprland main configuration"
check_file "$HYPR_DIR/animations.conf" "Hyprland animations configuration"
check_file "$HYPR_DIR/colors.conf" "Hyprland colors configuration"
check_file "$HYPR_DIR/keybinds.conf" "Hyprland keybindings configuration"

# Test Waybar configuration files
echo -e "\n${BLUE}Testing Waybar configuration files...${NC}"
check_dir "$WAYBAR_DIR" "Waybar"
check_file "$WAYBAR_DIR/config-top.jsonc" "Waybar top bar configuration"
check_file "$WAYBAR_DIR/config-bottom.jsonc" "Waybar bottom bar configuration"
check_file "$WAYBAR_DIR/style.css" "Waybar style"

# Test Rofi configuration files
echo -e "\n${BLUE}Testing Rofi configuration files...${NC}"
check_dir "$ROFI_DIR" "Rofi"
check_file "$ROFI_DIR/config.rasi" "Rofi configuration"
check_file "$ROFI_DIR/ff6-theme.rasi" "Rofi FF6 theme"

# Test Kitty configuration files
echo -e "\n${BLUE}Testing Kitty configuration files...${NC}"
check_dir "$KITTY_DIR" "Kitty"
check_file "$KITTY_DIR/kitty.conf" "Kitty configuration"
check_file "$KITTY_DIR/ff_sprite.py" "Kitty FF sprite script"

# Test SwayNC configuration files
echo -e "\n${BLUE}Testing SwayNC configuration files...${NC}"
check_dir "$SWAYNC_DIR" "SwayNC"
check_file "$SWAYNC_DIR/config.json" "SwayNC configuration"

# Test script files
echo -e "\n${BLUE}Testing script files...${NC}"
check_file "$HYPR_DIR/scripts/autostart.sh" "Autostart script"
check_file "$HYPR_DIR/scripts/wallpaper-menu.sh" "Wallpaper menu script"
check_file "$HYPR_DIR/scripts/wallpaper-random.sh" "Random wallpaper script"
check_file "$HYPR_DIR/scripts/set-wallpaper.sh" "Set wallpaper script"

# Test sound files
echo -e "\n${BLUE}Testing sound files...${NC}"
check_file "$HYPR_DIR/sounds/cursor.wav" "Cursor sound effect"
check_file "$HYPR_DIR/sounds/confirm.wav" "Confirm sound effect"

# Test required packages
echo -e "\n${BLUE}Testing required packages...${NC}"
check_package "hyprland"
check_package "waybar"
check_package "rofi"
check_package "kitty"
check_package "swaync"
check_package "swww"
check_package "cliphist"
check_package "grim"
check_package "slurp"
check_package "swappy"
check_package "kvantum"
check_package "qt5ct"
check_package "qt6ct"
check_package "thunar"
check_package "sox"

# Test running services
echo -e "\n${BLUE}Testing running services...${NC}"
check_service "waybar"
check_service "swaync"
check_service "swww"
check_service "polkit-kde-authentication-agent-1" "polkit-kde-auth"
check_service "wl-paste"

# Check for FF6 theme elements in configuration files
echo -e "\n${BLUE}Testing FF6 theme elements...${NC}"

# Check for FF6 blue gradient in colors.conf
if grep -q "ff6_blue" "$HYPR_DIR/colors.conf"; then
  echo -e "${GREEN}✓ FF6 blue gradient colors found in colors.conf${NC}"
else
  echo -e "${RED}✗ FF6 blue gradient colors not found in colors.conf${NC}"
fi

# Check for white borders in colors.conf
if grep -q "border_active = \$ff6_white" "$HYPR_DIR/colors.conf" || grep -q "col.active_border = rgb(FFFFFF)" "$HYPR_DIR/colors.conf"; then
  echo -e "${GREEN}✓ White borders configuration found in colors.conf${NC}"
else
  echo -e "${RED}✗ White borders configuration not found in colors.conf${NC}"
fi

# Check for FF6 terminology in waybar config
if grep -q "Magic" "$WAYBAR_DIR/config-top.jsonc" && grep -q "Relics" "$WAYBAR_DIR/config-top.jsonc"; then
  echo -e "${GREEN}✓ FF6 terminology found in waybar configuration${NC}"
else
  echo -e "${RED}✗ FF6 terminology not found in waybar configuration${NC}"
fi

# Check for FF6 blue gradient in waybar style
if grep -q "linear-gradient.*rgba(10, 16, 96" "$WAYBAR_DIR/style.css"; then
  echo -e "${GREEN}✓ FF6 blue gradient found in waybar style${NC}"
else
  echo -e "${RED}✗ FF6 blue gradient not found in waybar style${NC}"
fi

# Check for FF6 character sprites in kitty config
if grep -q "ff_sprite.py" "$KITTY_DIR/kitty.conf"; then
  echo -e "${GREEN}✓ FF6 character sprites configuration found in kitty.conf${NC}"
else
  echo -e "${RED}✗ FF6 character sprites configuration not found in kitty.conf${NC}"
fi

# Check for Atma Weapon cursor
if [ -d "$HOME/.local/share/icons/AtmaWeapon" ]; then
  echo -e "${GREEN}✓ Atma Weapon cursor theme found${NC}"
else
  echo -e "${YELLOW}! Atma Weapon cursor theme not found${NC}"
fi

# Generate a summary
echo -e "\n${BLUE}Test Summary${NC}"
TOTAL_TESTS=$(grep -c "✓\|✗\|!" "$TEST_REPORT")
PASSED_TESTS=$(grep -c "✓" "$TEST_REPORT")
FAILED_TESTS=$(grep -c "✗" "$TEST_REPORT")
WARNING_TESTS=$(grep -c "!" "$TEST_REPORT")

echo -e "Total tests: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
echo -e "Warnings: ${YELLOW}$WARNING_TESTS${NC}"

# Calculate success percentage
SUCCESS_PERCENT=$((PASSED_TESTS * 100 / TOTAL_TESTS))
echo -e "Success rate: ${GREEN}$SUCCESS_PERCENT%${NC}"

# Provide recommendations based on test results
echo -e "\n${BLUE}Recommendations:${NC}"
if [ $FAILED_TESTS -eq 0 ] && [ $WARNING_TESTS -eq 0 ]; then
  echo -e "${GREEN}All tests passed! Your FF6 Hyprland configuration is working perfectly.${NC}"
elif [ $FAILED_TESTS -eq 0 ] && [ $WARNING_TESTS -gt 0 ]; then
  echo -e "${YELLOW}Your FF6 Hyprland configuration is mostly working, but there are some warnings to address.${NC}"
  echo -e "Run the following scripts to fix potential issues:"
  echo -e "  - ${BLUE}$HYPR_DIR/scripts/fix-configuration.sh${NC}"
  echo -e "  - ${BLUE}$HYPR_DIR/scripts/configure-services.sh${NC}"
else
  echo -e "${RED}Your FF6 Hyprland configuration has some issues that need to be fixed.${NC}"
  echo -e "Run the following scripts to fix the issues:"
  echo -e "  - ${BLUE}$HYPR_DIR/scripts/fix-configuration.sh${NC}"
  echo -e "  - ${BLUE}$HYPR_DIR/scripts/configure-display.sh${NC}"
  echo -e "  - ${BLUE}$HYPR_DIR/scripts/configure-services.sh${NC}"
  echo -e "Then restart Hyprland with: ${BLUE}hyprctl dispatch exit${NC}"
fi

echo -e "\n${BLUE}=========================================${NC}"
echo -e "${GREEN}  Configuration Test Complete!         ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "Test report saved to: ${YELLOW}$TEST_REPORT${NC}"
