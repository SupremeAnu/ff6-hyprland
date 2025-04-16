#!/bin/bash

# FF6 Hyprland Configuration Test Script
# This script tests all functionality of the FF6 Hyprland configuration

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
SCRIPTS_DIR="/home/ubuntu/ff6-hyprland-git/scripts"

# Function to check if a file exists
check_file() {
  local file="$1"
  local description="$2"
  
  if [ -f "$file" ]; then
    echo -e "${GREEN}✓ $description exists: $file${NC}"
    return 0
  else
    echo -e "${RED}✗ $description does not exist: $file${NC}"
    return 1
  fi
}

# Function to check if a directory exists
check_directory() {
  local directory="$1"
  local description="$2"
  
  if [ -d "$directory" ]; then
    echo -e "${GREEN}✓ $description exists: $directory${NC}"
    return 0
  else
    echo -e "${RED}✗ $description does not exist: $directory${NC}"
    return 1
  fi
}

# Function to check if a command exists
check_command() {
  local command="$1"
  local description="$2"
  
  if command -v "$command" &> /dev/null; then
    echo -e "${GREEN}✓ $description is installed: $command${NC}"
    return 0
  else
    echo -e "${RED}✗ $description is not installed: $command${NC}"
    return 1
  fi
}

# Function to check if a string exists in a file
check_string_in_file() {
  local file="$1"
  local string="$2"
  local description="$3"
  
  if [ -f "$file" ] && grep -q "$string" "$file"; then
    echo -e "${GREEN}✓ $description found in $file${NC}"
    return 0
  else
    echo -e "${RED}✗ $description not found in $file${NC}"
    return 1
  fi
}

# Function to check if a script is executable
check_executable() {
  local script="$1"
  local description="$2"
  
  if [ -x "$script" ]; then
    echo -e "${GREEN}✓ $description is executable: $script${NC}"
    return 0
  else
    echo -e "${RED}✗ $description is not executable: $script${NC}"
    return 1
  fi
}

echo -e "${BLUE}Testing directory structure...${NC}"
check_directory "$HYPR_DIR" "Hyprland config directory"
check_directory "$WAYBAR_DIR" "Waybar config directory"
check_directory "$ROFI_DIR" "Rofi config directory"
check_directory "$KITTY_DIR" "Kitty config directory"
check_directory "$SWAYNC_DIR" "SwayNC config directory"
check_directory "$SCRIPTS_DIR" "Scripts directory"

echo -e "\n${BLUE}Testing Hyprland configuration files...${NC}"
check_file "$HYPR_DIR/hyprland.conf" "Hyprland main config"
check_file "$HYPR_DIR/animations.conf" "Hyprland animations config"
check_file "$HYPR_DIR/colors.conf" "Hyprland colors config"
check_file "$HYPR_DIR/keybinds.conf" "Hyprland keybindings config"

echo -e "\n${BLUE}Testing Waybar configuration files...${NC}"
check_file "$WAYBAR_DIR/config-top.jsonc" "Waybar top bar config"
check_file "$WAYBAR_DIR/config-bottom.jsonc" "Waybar bottom bar config"
check_file "$WAYBAR_DIR/style.css" "Waybar style"

echo -e "\n${BLUE}Testing Rofi configuration files...${NC}"
check_file "$ROFI_DIR/config.rasi" "Rofi config"
check_file "$ROFI_DIR/ff6-theme.rasi" "Rofi FF6 theme"

echo -e "\n${BLUE}Testing Kitty configuration files...${NC}"
check_file "$KITTY_DIR/kitty.conf" "Kitty config"
check_file "$KITTY_DIR/ff_sprite.py" "Kitty FF6 sprite script"

echo -e "\n${BLUE}Testing SwayNC configuration files...${NC}"
check_file "$SWAYNC_DIR/config.json" "SwayNC config"

echo -e "\n${BLUE}Testing scripts...${NC}"
check_executable "$SCRIPTS_DIR/fix-configuration.sh" "Fix configuration script"
check_executable "$SCRIPTS_DIR/configure-display.sh" "Configure display script"
check_executable "$SCRIPTS_DIR/configure-services.sh" "Configure services script"
check_executable "$SCRIPTS_DIR/test-configuration.sh" "Test configuration script"
check_executable "$SCRIPTS_DIR/create-wallpapers.sh" "Create wallpapers script"
check_executable "$SCRIPTS_DIR/create-icons.sh" "Create icons script"
check_executable "$SCRIPTS_DIR/fix-window-switching.sh" "Fix window switching script"
check_executable "$SCRIPTS_DIR/screenshot-clipboard.sh" "Screenshot and clipboard script"

echo -e "\n${BLUE}Testing installer script...${NC}"
check_executable "/home/ubuntu/ff6-hyprland-git/install.sh" "Installer script"

echo -e "\n${BLUE}Testing keybindings...${NC}"
check_string_in_file "$HYPR_DIR/keybinds.conf" "bind = \$mainMod, Return, exec, \$terminal" "Terminal keybinding"
check_string_in_file "$HYPR_DIR/keybinds.conf" "bind = \$mainMod, E, exec, \$fileManager" "File manager keybinding"
check_string_in_file "$HYPR_DIR/keybinds.conf" "bind = \$mainMod, D, exec, \$menu" "Application launcher keybinding"
check_string_in_file "$HYPR_DIR/keybinds.conf" "bind = \$mainMod, Q, killactive" "Close application keybinding"
check_string_in_file "$HYPR_DIR/keybinds.conf" "bind = \$mainMod, H, exec, \$helpMenu" "Help menu keybinding"
check_string_in_file "$HYPR_DIR/keybinds.conf" "bind = , Print, exec" "Screenshot keybinding"
check_string_in_file "$HYPR_DIR/keybinds.conf" "bind = \$mainMod, V, exec" "Clipboard keybinding"

echo -e "\n${BLUE}Testing FF6 theme...${NC}"
check_string_in_file "$HYPR_DIR/colors.conf" "rgba(10, 16, 96" "FF6 blue color"
check_string_in_file "$WAYBAR_DIR/style.css" "background: linear-gradient" "Gradient background"
check_string_in_file "$ROFI_DIR/ff6-theme.rasi" "background-color: rgba(10, 16, 96" "FF6 theme background"

echo -e "\n${BLUE}Testing required packages...${NC}"
check_command "hyprland" "Hyprland"
check_command "waybar" "Waybar"
check_command "rofi" "Rofi"
check_command "kitty" "Kitty"
check_command "swaync" "SwayNC"
check_command "swww" "SWWW"
check_command "grim" "Grim"
check_command "slurp" "Slurp"
check_command "wl-copy" "wl-clipboard"
check_command "cliphist" "Cliphist"

echo -e "\n${BLUE}Testing sound effects...${NC}"
check_directory "$HYPR_DIR/sounds" "Sound effects directory"
check_file "$HYPR_DIR/sounds/cursor.wav" "Cursor sound effect"
check_file "$HYPR_DIR/sounds/confirm.wav" "Confirm sound effect"

echo -e "\n${BLUE}Testing wallpapers...${NC}"
check_directory "$HYPR_DIR/wallpapers" "Wallpapers directory"

echo -e "\n${BLUE}Testing icons...${NC}"
check_directory "$HYPR_DIR/icons" "Icons directory"

echo -e "\n${BLUE}Testing cursor...${NC}"
check_directory "$HYPR_DIR/cursor/AtmaWeapon" "Atma Weapon cursor directory"

echo -e "\n${BLUE}=========================================${NC}"
echo -e "${GREEN}  FF6 Hyprland Configuration Test Complete${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Create a summary report
REPORT_FILE="/home/ubuntu/ff6-hyprland-git/test-report.md"

cat > "$REPORT_FILE" << EOF
# FF6 Hyprland Configuration Test Report

## Test Results

### Directory Structure
- Hyprland config directory: $([ -d "$HYPR_DIR" ] && echo "✓" || echo "✗")
- Waybar config directory: $([ -d "$WAYBAR_DIR" ] && echo "✓" || echo "✗")
- Rofi config directory: $([ -d "$ROFI_DIR" ] && echo "✓" || echo "✗")
- Kitty config directory: $([ -d "$KITTY_DIR" ] && echo "✓" || echo "✗")
- SwayNC config directory: $([ -d "$SWAYNC_DIR" ] && echo "✓" || echo "✗")
- Scripts directory: $([ -d "$SCRIPTS_DIR" ] && echo "✓" || echo "✗")

### Hyprland Configuration Files
- Hyprland main config: $([ -f "$HYPR_DIR/hyprland.conf" ] && echo "✓" || echo "✗")
- Hyprland animations config: $([ -f "$HYPR_DIR/animations.conf" ] && echo "✓" || echo "✗")
- Hyprland colors config: $([ -f "$HYPR_DIR/colors.conf" ] && echo "✓" || echo "✗")
- Hyprland keybindings config: $([ -f "$HYPR_DIR/keybinds.conf" ] && echo "✓" || echo "✗")

### Waybar Configuration Files
- Waybar top bar config: $([ -f "$WAYBAR_DIR/config-top.jsonc" ] && echo "✓" || echo "✗")
- Waybar bottom bar config: $([ -f "$WAYBAR_DIR/config-bottom.jsonc" ] && echo "✓" || echo "✗")
- Waybar style: $([ -f "$WAYBAR_DIR/style.css" ] && echo "✓" || echo "✗")

### Rofi Configuration Files
- Rofi config: $([ -f "$ROFI_DIR/config.rasi" ] && echo "✓" || echo "✗")
- Rofi FF6 theme: $([ -f "$ROFI_DIR/ff6-theme.rasi" ] && echo "✓" || echo "✗")

### Kitty Configuration Files
- Kitty config: $([ -f "$KITTY_DIR/kitty.conf" ] && echo "✓" || echo "✗")
- Kitty FF6 sprite script: $([ -f "$KITTY_DIR/ff_sprite.py" ] && echo "✓" || echo "✗")

### SwayNC Configuration Files
- SwayNC config: $([ -f "$SWAYNC_DIR/config.json" ] && echo "✓" || echo "✗")

### Scripts
- Fix configuration script: $([ -x "$SCRIPTS_DIR/fix-configuration.sh" ] && echo "✓" || echo "✗")
- Configure display script: $([ -x "$SCRIPTS_DIR/configure-display.sh" ] && echo "✓" || echo "✗")
- Configure services script: $([ -x "$SCRIPTS_DIR/configure-services.sh" ] && echo "✓" || echo "✗")
- Test configuration script: $([ -x "$SCRIPTS_DIR/test-configuration.sh" ] && echo "✓" || echo "✗")
- Create wallpapers script: $([ -x "$SCRIPTS_DIR/create-wallpapers.sh" ] && echo "✓" || echo "✗")
- Create icons script: $([ -x "$SCRIPTS_DIR/create-icons.sh" ] && echo "✓" || echo "✗")
- Fix window switching script: $([ -x "$SCRIPTS_DIR/fix-window-switching.sh" ] && echo "✓" || echo "✗")
- Screenshot and clipboard script: $([ -x "$SCRIPTS_DIR/screenshot-clipboard.sh" ] && echo "✓" || echo "✗")

### Installer Script
- Installer script: $([ -x "/home/ubuntu/ff6-hyprland-git/install.sh" ] && echo "✓" || echo "✗")

## Recommendations

1. If any tests failed (marked with ✗), please run the corresponding fix script:
   - For configuration issues: \`./scripts/fix-configuration.sh\`
   - For display issues: \`./scripts/configure-display.sh\`
   - For service issues: \`./scripts/configure-services.sh\`
   - For window switching issues: \`./scripts/fix-window-switching.sh\`
   - For screenshot and clipboard issues: \`./scripts/screenshot-clipboard.sh\`

2. If wallpapers or icons are missing, run:
   - \`./scripts/create-wallpapers.sh\`
   - \`./scripts/create-icons.sh\`

3. For a complete reinstallation, run:
   - \`./install.sh\`

## Next Steps

1. Clone the repository to your system
2. Run the installer script
3. Log out and select Hyprland from your display manager
4. Enjoy your FF6-themed Hyprland desktop!
EOF

echo -e "${BLUE}Test report created at: $REPORT_FILE${NC}"
echo -e "${YELLOW}Please check the report for any issues and recommendations.${NC}"
