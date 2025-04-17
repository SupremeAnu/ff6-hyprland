#!/bin/bash
# FF6-themed Waybar Configuration - Main Installation Script

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

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create necessary directories
mkdir -p ~/.config/waybar
mkdir -p ~/.config/waybar/modules
mkdir -p ~/.config/waybar/sprites
mkdir -p ~/.config/hypr/scripts

# Copy configuration files
echo -e "${YELLOW}Copying configuration files...${NC}"
cp -f "$SCRIPT_DIR/config.jsonc" ~/.config/waybar/
cp -f "$SCRIPT_DIR/style.css" ~/.config/waybar/
cp -f "$SCRIPT_DIR/modules/"* ~/.config/waybar/modules/

# Copy sprites
echo -e "${YELLOW}Copying sprites...${NC}"
cp -f "$SCRIPT_DIR/sprites/"* ~/.config/waybar/sprites/

# Copy and make scripts executable
echo -e "${YELLOW}Setting up scripts...${NC}"
cp -f "$SCRIPT_DIR/scripts/create-character-portraits.sh" ~/.config/hypr/scripts/
chmod +x ~/.config/hypr/scripts/create-character-portraits.sh
bash ~/.config/hypr/scripts/create-character-portraits.sh

# Create restart script
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
