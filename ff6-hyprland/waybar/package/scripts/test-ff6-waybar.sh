#!/bin/bash
# FF6-themed Waybar Configuration - Test and Validation Script

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   FF6-themed Waybar Configuration   ${NC}"
echo -e "${BLUE}       Test and Validation Script     ${NC}"
echo -e "${BLUE}========================================${NC}"

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

# Initialize counters
total_checks=0
passed_checks=0

# Check waybar configuration files
echo -e "\n${YELLOW}Checking waybar configuration files...${NC}"
check_file "/home/ubuntu/hyprland-crimson-config/waybar/config.jsonc" && ((passed_checks++))
check_file "/home/ubuntu/hyprland-crimson-config/waybar/style.css" && ((passed_checks++))
((total_checks+=2))

# Check module files
echo -e "\n${YELLOW}Checking waybar module files...${NC}"
check_file "/home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-character-stats.jsonc" && ((passed_checks++))
check_file "/home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-options.jsonc" && ((passed_checks++))
check_file "/home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-drawer.jsonc" && ((passed_checks++))
((total_checks+=3))

# Check character portrait files
echo -e "\n${YELLOW}Checking character portrait files...${NC}"
check_file "/home/ubuntu/hyprland-crimson-config/scripts/create-character-portraits.sh" && ((passed_checks++))
((total_checks+=1))

# Check if sprites directory exists
echo -e "\n${YELLOW}Checking sprites directory...${NC}"
check_dir "/home/ubuntu/hyprland-crimson-config/sprites" && ((passed_checks++))
((total_checks+=1))

# Check if sprite files exist
echo -e "\n${YELLOW}Checking sprite files...${NC}"
check_file "/home/ubuntu/hyprland-crimson-config/sprites/terra.png" && ((passed_checks++))
check_file "/home/ubuntu/hyprland-crimson-config/sprites/locke.png" && ((passed_checks++))
check_file "/home/ubuntu/hyprland-crimson-config/sprites/edgar.png" && ((passed_checks++))
((total_checks+=3))

# Validate JSON syntax in config files
echo -e "\n${YELLOW}Validating JSON syntax in config files...${NC}"
if jq . "/home/ubuntu/hyprland-crimson-config/waybar/config.jsonc" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Valid JSON syntax in config.jsonc"
    ((passed_checks++))
else
    echo -e "${RED}✗${NC} Invalid JSON syntax in config.jsonc"
fi
((total_checks+=1))

if jq . "/home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-character-stats.jsonc" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Valid JSON syntax in ff6-character-stats.jsonc"
    ((passed_checks++))
else
    echo -e "${RED}✗${NC} Invalid JSON syntax in ff6-character-stats.jsonc"
fi
((total_checks+=1))

if jq . "/home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-options.jsonc" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Valid JSON syntax in ff6-menu-options.jsonc"
    ((passed_checks++))
else
    echo -e "${RED}✗${NC} Invalid JSON syntax in ff6-menu-options.jsonc"
fi
((total_checks+=1))

if jq . "/home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-drawer.jsonc" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Valid JSON syntax in ff6-menu-drawer.jsonc"
    ((passed_checks++))
else
    echo -e "${RED}✗${NC} Invalid JSON syntax in ff6-menu-drawer.jsonc"
fi
((total_checks+=1))

# Create installation script
echo -e "\n${YELLOW}Creating installation script...${NC}"
cat > /home/ubuntu/hyprland-crimson-config/waybar/install-ff6-waybar.sh << 'EOF'
#!/bin/bash
# FF6-themed Waybar Configuration - Installation Script

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   FF6-themed Waybar Configuration   ${NC}"
echo -e "${BLUE}       Installation Script           ${NC}"
echo -e "${BLUE}========================================${NC}"

# Create necessary directories
mkdir -p ~/.config/waybar
mkdir -p ~/.config/waybar/modules

# Copy configuration files
echo -e "${YELLOW}Copying configuration files...${NC}"
cp -f /home/ubuntu/hyprland-crimson-config/waybar/config.jsonc ~/.config/waybar/
cp -f /home/ubuntu/hyprland-crimson-config/waybar/style.css ~/.config/waybar/
mkdir -p ~/.config/waybar/modules
cp -f /home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-character-stats.jsonc ~/.config/waybar/modules/
cp -f /home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-options.jsonc ~/.config/waybar/modules/
cp -f /home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-drawer.jsonc ~/.config/waybar/modules/

# Set up character portraits
echo -e "${YELLOW}Setting up character portraits...${NC}"
bash /home/ubuntu/hyprland-crimson-config/scripts/create-character-portraits.sh

# Create a script to restart waybar
cat > ~/.config/waybar/restart-waybar.sh << 'EOFINNER'
#!/bin/bash
killall waybar
sleep 1
waybar -c ~/.config/waybar/config.jsonc &
EOFINNER

chmod +x ~/.config/waybar/restart-waybar.sh

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}To start the FF6-themed waybar, run:${NC}"
echo -e "  ~/.config/waybar/restart-waybar.sh"
echo -e "${BLUE}========================================${NC}"
EOF

chmod +x /home/ubuntu/hyprland-crimson-config/waybar/install-ff6-waybar.sh
echo -e "${GREEN}✓${NC} Created installation script"
((passed_checks++))
((total_checks+=1))

# Calculate percentage
percentage=$((passed_checks * 100 / total_checks))

# Print summary
echo -e "\n${BLUE}========================================${NC}"
echo -e "${YELLOW}Validation Summary:${NC}"
echo -e "Passed checks: ${GREEN}$passed_checks${NC} / ${BLUE}$total_checks${NC} (${GREEN}$percentage%${NC})"

if [ $passed_checks -eq $total_checks ]; then
    echo -e "${GREEN}All checks passed! The FF6-themed waybar configuration is complete.${NC}"
else
    echo -e "${YELLOW}Some checks failed. Please fix the issues before using the configuration.${NC}"
fi
echo -e "${BLUE}========================================${NC}"

# Return success if all checks passed
if [ $passed_checks -eq $total_checks ]; then
    exit 0
else
    exit 1
fi
