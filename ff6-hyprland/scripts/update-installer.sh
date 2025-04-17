#!/bin/bash
# Script to update the installer with all necessary dependencies
# Part of FF6 Hyprland Configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
INSTALLER_PATH="/home/ubuntu/hyprland-crimson-config/install.sh"
BACKUP_PATH="/home/ubuntu/hyprland-crimson-config/install.sh.bak"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Installer Update                  ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Backup the original installer
echo -e "${YELLOW}Backing up original installer...${NC}"
cp "$INSTALLER_PATH" "$BACKUP_PATH"
echo -e "${GREEN}Backup created at $BACKUP_PATH${NC}"

# Update the installer with additional dependencies
echo -e "${YELLOW}Updating installer with additional dependencies...${NC}"

# Add Python and PIL/Pillow to the package list
sed -i '/^PACKAGES=(/,/)/ s/)$/    "python"\n    "python-pip"\n    "imagemagick"\n    "jq"\n)/' "$INSTALLER_PATH"

# Add a section to install PIL/Pillow after the package installation
PILLOW_INSTALL_CODE='
# Install Python packages
echo -e "${BLUE}Installing Python packages...${NC}"
if command -v pip3 &> /dev/null; then
    echo -e "${YELLOW}Installing Pillow for sprite conversion...${NC}"
    pip3 install --user Pillow
    echo -e "${GREEN}Pillow installed.${NC}"
else
    echo -e "${YELLOW}Warning: pip3 not found. Skipping Pillow installation.${NC}"
    echo -e "${YELLOW}You may need to install Pillow manually for sprite conversion.${NC}"
fi
'

# Find the position to insert the code (after package installation)
INSERT_LINE=$(grep -n "if \[ \$INSTALL_ERRORS -gt 0 \]; then" "$INSTALLER_PATH" | cut -d: -f1)
if [ -n "$INSERT_LINE" ]; then
    # Insert the code after the package installation section
    sed -i "${INSERT_LINE}i\\${PILLOW_INSTALL_CODE}" "$INSTALLER_PATH"
    echo -e "${GREEN}Added Python package installation section.${NC}"
else
    echo -e "${RED}Error: Could not find the appropriate position to insert code.${NC}"
    echo -e "${YELLOW}Please add the following code manually after package installation:${NC}"
    echo -e "$PILLOW_INSTALL_CODE"
fi

# Add a section to run the sprite integration script
SPRITE_INTEGRATION_CODE='
# Integrate FF6 sprites
echo -e "${BLUE}Integrating FF6 sprites...${NC}"
if [ -f "$DOTFILES_DIR/.config/hypr/scripts/integrate-sprites.sh" ]; then
    chmod +x "$DOTFILES_DIR/.config/hypr/scripts/integrate-sprites.sh"
    "$DOTFILES_DIR/.config/hypr/scripts/integrate-sprites.sh"
    echo -e "${GREEN}FF6 sprites integrated.${NC}"
else
    echo -e "${YELLOW}Warning: Sprite integration script not found.${NC}"
    echo -e "${YELLOW}You may need to run the script manually after installation.${NC}"
fi
'

# Find the position to insert the code (before the final message)
INSERT_LINE=$(grep -n "echo -e \"${GREEN}Installation completed successfully!\"" "$INSTALLER_PATH" | cut -d: -f1)
if [ -n "$INSERT_LINE" ]; then
    # Insert the code before the final message
    sed -i "${INSERT_LINE}i\\${SPRITE_INTEGRATION_CODE}" "$INSTALLER_PATH"
    echo -e "${GREEN}Added sprite integration section.${NC}"
else
    echo -e "${RED}Error: Could not find the appropriate position to insert code.${NC}"
    echo -e "${YELLOW}Please add the following code manually before the final message:${NC}"
    echo -e "$SPRITE_INTEGRATION_CODE"
fi

# Add a section to run the waybar fix script
WAYBAR_FIX_CODE='
# Fix waybar configuration
echo -e "${BLUE}Fixing waybar configuration...${NC}"
if [ -f "$DOTFILES_DIR/.config/hypr/scripts/launch-waybar.sh" ]; then
    chmod +x "$DOTFILES_DIR/.config/hypr/scripts/launch-waybar.sh"
    echo -e "${GREEN}Waybar launch script is ready.${NC}"
else
    echo -e "${YELLOW}Creating waybar launch script...${NC}"
    mkdir -p "$DOTFILES_DIR/.config/hypr/scripts"
    cat > "$DOTFILES_DIR/.config/hypr/scripts/launch-waybar.sh" << '\''EOF'\''
#!/bin/bash

# Kill any existing waybar instances
killall waybar 2>/dev/null

# Wait a moment to ensure previous instances are closed
sleep 0.5

# Launch waybar with proper environment
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Launch waybar in the background
waybar &

# Log the launch
echo "Waybar launched at $(date)" >> ~/.config/hypr/waybar-launch.log
EOF
    chmod +x "$DOTFILES_DIR/.config/hypr/scripts/launch-waybar.sh"
    echo -e "${GREEN}Waybar launch script created.${NC}"
fi

# Update hyprland.conf to use the launch script
if [ -f "$DOTFILES_DIR/.config/hypr/hyprland.conf" ]; then
    if grep -q "^exec-once = waybar" "$DOTFILES_DIR/.config/hypr/hyprland.conf"; then
        sed -i '\''s|^exec-once = waybar.*|exec-once = ~/.config/hypr/scripts/launch-waybar.sh|g'\'' "$DOTFILES_DIR/.config/hypr/hyprland.conf"
    else
        echo "exec-once = ~/.config/hypr/scripts/launch-waybar.sh" >> "$DOTFILES_DIR/.config/hypr/hyprland.conf"
    fi
    echo -e "${GREEN}Updated hyprland.conf to use the waybar launch script.${NC}"
fi
'

# Find the position to insert the code (before the sprite integration)
INSERT_LINE=$(grep -n "# Integrate FF6 sprites" "$INSTALLER_PATH" | cut -d: -f1)
if [ -n "$INSERT_LINE" ]; then
    # Insert the code before the sprite integration
    sed -i "${INSERT_LINE}i\\${WAYBAR_FIX_CODE}" "$INSTALLER_PATH"
    echo -e "${GREEN}Added waybar fix section.${NC}"
else
    echo -e "${RED}Error: Could not find the appropriate position to insert code.${NC}"
    echo -e "${YELLOW}Please add the following code manually before the sprite integration:${NC}"
    echo -e "$WAYBAR_FIX_CODE"
fi

# Final summary
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Installer update complete!${NC}"
echo -e "${YELLOW}The installer now includes all necessary dependencies and scripts.${NC}"
echo -e "${BLUE}=========================================${NC}"
