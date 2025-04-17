#!/bin/bash
# FF6-themed Waybar Configuration - Packaging Script

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   FF6-themed Waybar Configuration   ${NC}"
echo -e "${BLUE}       Packaging Script              ${NC}"
echo -e "${BLUE}========================================${NC}"

# Create package directory
PACKAGE_DIR="/home/ubuntu/hyprland-crimson-config/waybar/package"
mkdir -p "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR/modules"
mkdir -p "$PACKAGE_DIR/scripts"
mkdir -p "$PACKAGE_DIR/sprites"

# Copy configuration files
echo -e "${YELLOW}Copying configuration files...${NC}"
cp -f /home/ubuntu/hyprland-crimson-config/waybar/config.jsonc "$PACKAGE_DIR/"
cp -f /home/ubuntu/hyprland-crimson-config/waybar/style.css "$PACKAGE_DIR/"
cp -f /home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-character-stats.jsonc "$PACKAGE_DIR/modules/"
cp -f /home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-options.jsonc "$PACKAGE_DIR/modules/"
cp -f /home/ubuntu/hyprland-crimson-config/waybar/modules/ff6-menu-drawer.jsonc "$PACKAGE_DIR/modules/"

# Copy scripts
echo -e "${YELLOW}Copying scripts...${NC}"
cp -f /home/ubuntu/hyprland-crimson-config/scripts/create-character-portraits.sh "$PACKAGE_DIR/scripts/"
cp -f /home/ubuntu/hyprland-crimson-config/scripts/test-ff6-waybar.sh "$PACKAGE_DIR/scripts/"
cp -f /home/ubuntu/hyprland-crimson-config/waybar/install-ff6-waybar.sh "$PACKAGE_DIR/"

# Copy sprites
echo -e "${YELLOW}Copying sprites...${NC}"
cp -f /home/ubuntu/hyprland-crimson-config/sprites/terra.png "$PACKAGE_DIR/sprites/"
cp -f /home/ubuntu/hyprland-crimson-config/sprites/locke.png "$PACKAGE_DIR/sprites/"
cp -f /home/ubuntu/hyprland-crimson-config/sprites/edgar.png "$PACKAGE_DIR/sprites/"

# Create README file
echo -e "${YELLOW}Creating README file...${NC}"
cat > "$PACKAGE_DIR/README.md" << 'EOF'
# FF6-Themed Waybar Configuration

This package contains a complete waybar configuration themed after the Final Fantasy VI menu system.

## Features

- Multiple waybar bars styled after the FF6 menu
- Character portraits with system information (Terra, Gannon, Edgar)
- FF6-style menu options (Items, Abilities, Equip, etc.)
- Collapsible menu drawer with Steam shortcut
- Blue gradient background with white borders matching FF6 aesthetic
- System information displayed as character stats

## Installation

1. Run the installation script:
   ```
   ./install-ff6-waybar.sh
   ```

2. Restart waybar:
   ```
   ~/.config/waybar/restart-waybar.sh
   ```

## Configuration

The configuration consists of:

- `config.jsonc` - Main waybar configuration
- `style.css` - FF6-themed styling
- `modules/` - Module definitions for character stats and menu options
- `scripts/` - Helper scripts for character portraits and testing
- `sprites/` - Character sprite images

## Customization

You can customize the configuration by editing:

- `config.jsonc` to change the layout and modules
- `style.css` to adjust colors and styling
- Module files to change functionality

## Credits

- Original FF6 sprites and design by Square Enix
- Waybar configuration based on JaKooLit's Arch-Hyprland repository
EOF

# Create installation script
echo -e "${YELLOW}Creating main installation script...${NC}"
cat > "$PACKAGE_DIR/install.sh" << 'EOF'
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
EOF

# Make scripts executable
chmod +x "$PACKAGE_DIR/install.sh"
chmod +x "$PACKAGE_DIR/install-ff6-waybar.sh"
chmod +x "$PACKAGE_DIR/scripts/create-character-portraits.sh"
chmod +x "$PACKAGE_DIR/scripts/test-ff6-waybar.sh"

# Create tarball
echo -e "${YELLOW}Creating tarball...${NC}"
cd /home/ubuntu/hyprland-crimson-config/waybar
tar -czvf /home/ubuntu/ff6-waybar-theme.tar.gz -C /home/ubuntu/hyprland-crimson-config/waybar/package .

echo -e "${GREEN}Packaging complete!${NC}"
echo -e "${YELLOW}Package created at:${NC} /home/ubuntu/ff6-waybar-theme.tar.gz"
echo -e "${BLUE}========================================${NC}"
