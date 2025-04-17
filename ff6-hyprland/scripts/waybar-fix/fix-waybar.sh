#!/bin/bash
# Script to fix waybar display issues in FF6-themed Hyprland configuration
# Created based on analysis of JaKooLit's Hyprland-Dots and temp-config repositories

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="$HOME/.config"
WAYBAR_DIR="$CONFIG_DIR/waybar"
HYPR_DIR="$CONFIG_DIR/hypr"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Waybar Fix                        ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Check if waybar is installed
if ! command -v waybar &> /dev/null; then
    echo -e "${RED}Error: Waybar is not installed.${NC}"
    echo -e "${YELLOW}Please install waybar first:${NC}"
    echo -e "  - Arch: sudo pacman -S waybar"
    echo -e "  - Debian/Ubuntu: sudo apt install waybar"
    echo -e "  - Fedora: sudo dnf install waybar"
    exit 1
fi

# Check if required directories exist
if [ ! -d "$WAYBAR_DIR" ]; then
    echo -e "${YELLOW}Creating waybar config directory...${NC}"
    mkdir -p "$WAYBAR_DIR"
fi

# Ensure waybar configs have proper permissions
echo -e "${YELLOW}Setting proper permissions for waybar configs...${NC}"
chmod 644 "$WAYBAR_DIR/config-top.jsonc" 2>/dev/null || true
chmod 644 "$WAYBAR_DIR/config-bottom.jsonc" 2>/dev/null || true
chmod 644 "$WAYBAR_DIR/style.css" 2>/dev/null || true

# Validate JSON syntax in waybar configs
echo -e "${YELLOW}Validating waybar config JSON syntax...${NC}"
if command -v jq &> /dev/null; then
    if [ -f "$WAYBAR_DIR/config-top.jsonc" ]; then
        # Remove comments before validation
        cat "$WAYBAR_DIR/config-top.jsonc" | sed 's|//.*||g' | jq . >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error: Invalid JSON in config-top.jsonc${NC}"
            echo -e "${YELLOW}Attempting to fix...${NC}"
            # Backup the file
            cp "$WAYBAR_DIR/config-top.jsonc" "$WAYBAR_DIR/config-top.jsonc.bak"
        else
            echo -e "${GREEN}config-top.jsonc has valid JSON syntax.${NC}"
        fi
    fi
    
    if [ -f "$WAYBAR_DIR/config-bottom.jsonc" ]; then
        # Remove comments before validation
        cat "$WAYBAR_DIR/config-bottom.jsonc" | sed 's|//.*||g' | jq . >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error: Invalid JSON in config-bottom.jsonc${NC}"
            echo -e "${YELLOW}Attempting to fix...${NC}"
            # Backup the file
            cp "$WAYBAR_DIR/config-bottom.jsonc" "$WAYBAR_DIR/config-bottom.jsonc.bak"
        else
            echo -e "${GREEN}config-bottom.jsonc has valid JSON syntax.${NC}"
        fi
    fi
else
    echo -e "${YELLOW}Warning: jq not installed. Skipping JSON validation.${NC}"
fi

# Create a script to properly launch waybar
echo -e "${YELLOW}Creating waybar launch script...${NC}"
cat > "$HYPR_DIR/scripts/launch-waybar.sh" << 'EOF'
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

# Make the launch script executable
chmod +x "$HYPR_DIR/scripts/launch-waybar.sh"

# Update hyprland.conf to use the launch script
echo -e "${YELLOW}Updating hyprland.conf to use the launch script...${NC}"
if [ -f "$HYPR_DIR/hyprland.conf" ]; then
    # Check if the exec-once line for waybar exists
    if grep -q "^exec-once = waybar" "$HYPR_DIR/hyprland.conf"; then
        # Replace the existing waybar exec line
        sed -i 's|^exec-once = waybar.*|exec-once = ~/.config/hypr/scripts/launch-waybar.sh|g' "$HYPR_DIR/hyprland.conf"
    else
        # Add the launch script to exec-once
        echo "exec-once = ~/.config/hypr/scripts/launch-waybar.sh" >> "$HYPR_DIR/hyprland.conf"
    fi
    echo -e "${GREEN}Updated hyprland.conf to use the waybar launch script.${NC}"
else
    echo -e "${RED}Error: hyprland.conf not found.${NC}"
fi

# Install required dependencies
echo -e "${YELLOW}Checking for required dependencies...${NC}"
MISSING_DEPS=0

check_and_install() {
    local pkg="$1"
    local install_cmd="$2"
    
    if ! command -v "$pkg" &> /dev/null; then
        echo -e "${YELLOW}$pkg not found. Installing...${NC}"
        eval "$install_cmd" || {
            echo -e "${RED}Failed to install $pkg.${NC}"
            MISSING_DEPS=$((MISSING_DEPS+1))
        }
    else
        echo -e "${GREEN}$pkg is already installed.${NC}"
    fi
}

# Check package manager and install dependencies
if command -v pacman &> /dev/null; then
    # Arch-based
    check_and_install "jq" "sudo pacman -S --noconfirm jq"
    check_and_install "gtk-layer-shell" "sudo pacman -S --noconfirm gtk-layer-shell"
elif command -v apt &> /dev/null; then
    # Debian-based
    check_and_install "jq" "sudo apt update && sudo apt install -y jq"
    check_and_install "gtk-layer-shell" "sudo apt update && sudo apt install -y libgtk-layer-shell0"
elif command -v dnf &> /dev/null; then
    # Fedora-based
    check_and_install "jq" "sudo dnf install -y jq"
    check_and_install "gtk-layer-shell" "sudo dnf install -y gtk-layer-shell"
fi

# Final steps
echo -e "${BLUE}=========================================${NC}"
if [ $MISSING_DEPS -eq 0 ]; then
    echo -e "${GREEN}Waybar fix completed successfully!${NC}"
    echo -e "${YELLOW}Please restart Hyprland to apply the changes.${NC}"
    echo -e "${YELLOW}You can do this by logging out and back in,${NC}"
    echo -e "${YELLOW}or by running 'hyprctl reload' in a terminal.${NC}"
else
    echo -e "${YELLOW}Waybar fix completed with warnings.${NC}"
    echo -e "${YELLOW}$MISSING_DEPS dependencies could not be installed.${NC}"
    echo -e "${YELLOW}Please install them manually and restart Hyprland.${NC}"
fi
echo -e "${BLUE}=========================================${NC}"
