#!/bin/bash
# FF6 Hyprland Configuration Auto-Installer
# Created: April 2025

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
ROFI_DIR="$CONFIG_DIR/rofi"
KITTY_DIR="$CONFIG_DIR/kitty"
SWAPPY_DIR="$CONFIG_DIR/swappy"
SWAYNC_DIR="$CONFIG_DIR/swaync"
KVANTUM_DIR="$CONFIG_DIR/Kvantum"
GTK_DIR="$HOME/.config/gtk-3.0"
QT5CT_DIR="$CONFIG_DIR/qt5ct"
QT6CT_DIR="$CONFIG_DIR/qt6ct"
THUNAR_DIR="$CONFIG_DIR/Thunar"
CURSOR_DIR="$HOME/.local/share/icons"
FONTS_DIR="$HOME/.local/share/fonts"
DOTFILES_DIR="$HOME"

# Backup directory
BACKUP_DIR="$HOME/.config/hypr-ff6-backup-$(date +%Y%m%d%H%M%S)"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Final Fantasy VI Hyprland Installer   ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if a package is installed (for pacman)
package_installed() {
    pacman -Q "$1" &> /dev/null
}

# Function to install a package if not already installed
install_package() {
    if ! package_installed "$1"; then
        echo -e "${YELLOW}Installing $1...${NC}"
        if command_exists yay; then
            yay -S --noconfirm "$1"
        else
            sudo pacman -S --noconfirm "$1"
        fi
        echo -e "${GREEN}$1 installed.${NC}"
    else
        echo -e "${GREEN}$1 is already installed.${NC}"
    fi
}

# Function to backup existing config
backup_config() {
    if [ -d "$1" ]; then
        local backup_path="$BACKUP_DIR/$(basename "$1")"
        echo -e "${YELLOW}Backing up $1 to $backup_path${NC}"
        mkdir -p "$(dirname "$backup_path")"
        cp -r "$1" "$backup_path"
        echo -e "${GREEN}Backup created.${NC}"
    fi
}

# Function to create directory if it doesn't exist
create_dir() {
    if [ ! -d "$1" ]; then
        echo -e "${YELLOW}Creating directory $1${NC}"
        mkdir -p "$1"
        echo -e "${GREEN}Directory created.${NC}"
    fi
}

# Check if running on Arch Linux
if ! command_exists pacman; then
    echo -e "${RED}Error: This script is designed for Arch Linux.${NC}"
    echo -e "${YELLOW}You can still manually install the configuration files.${NC}"
    read -p "Do you want to continue with just the configuration files? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation aborted.${NC}"
        exit 1
    fi
fi

# Check if yay is installed, install if not
if ! command_exists yay; then
    echo -e "${YELLOW}Yay (AUR helper) not found. Installing...${NC}"
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd - > /dev/null
    echo -e "${GREEN}Yay installed.${NC}"
fi

# Ask for confirmation before proceeding
echo -e "${YELLOW}This script will install the FF6-themed Hyprland configuration.${NC}"
echo -e "${YELLOW}It will backup your existing configurations to $BACKUP_DIR${NC}"
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Installation aborted.${NC}"
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Install required packages
echo -e "${BLUE}Installing required packages...${NC}"
PACKAGES=(
    "hyprland"
    "waybar"
    "rofi-wayland"
    "kitty"
    "kvantum"
    "cava"
    "grim"
    "slurp"
    "swappy"
    "swww"
    "cliphist"
    "swaync"
    "swaybg"
    "wallust"
    "nwg-look"
    "gtk3"
    "qt5ct"
    "qt6ct"
    "thunar"
    "hyprlock"
    "papirus-icon-theme"
    "ttf-jetbrains-mono-nerd"
    "ttf-victor-mono"
    "ttf-fantasque-sans-mono"
    "polkit-kde-agent"
    "python"
    "python-pip"
    "btop"
    "pavucontrol"
    "networkmanager"
    "blueman"
    "xdg-desktop-portal-hyprland"
    "xdg-utils"
    "imagemagick"
    "wl-clipboard"
    "sox"
    "pulseaudio"
    "pulseaudio-utils"
)

for pkg in "${PACKAGES[@]}"; do
    install_package "$pkg"
done

# Install fonts if not already installed
echo -e "${BLUE}Checking fonts...${NC}"
create_dir "$FONTS_DIR"

# Check for required fonts and install if missing
FONT_PACKAGES=(
    "ttf-jetbrains-mono-nerd"
    "ttf-victor-mono"
    "ttf-fantasque-sans-mono"
)

for font_pkg in "${FONT_PACKAGES[@]}"; do
    if ! package_installed "$font_pkg"; then
        echo -e "${YELLOW}Installing font package $font_pkg...${NC}"
        if command_exists yay; then
            yay -S --noconfirm "$font_pkg"
        else
            sudo pacman -S --noconfirm "$font_pkg"
        fi
    else
        echo -e "${GREEN}Font package $font_pkg is already installed.${NC}"
    fi
done

# Update font cache
if command_exists fc-cache; then
    echo -e "${YELLOW}Updating font cache...${NC}"
    fc-cache -f
    echo -e "${GREEN}Font cache updated.${NC}"
fi

# Backup existing configurations
echo -e "${BLUE}Backing up existing configurations...${NC}"
backup_config "$HYPR_DIR"
backup_config "$WAYBAR_DIR"
backup_config "$ROFI_DIR"
backup_config "$KITTY_DIR"
backup_config "$SWAPPY_DIR"
backup_config "$SWAYNC_DIR"
backup_config "$KVANTUM_DIR"
backup_config "$GTK_DIR"
backup_config "$QT5CT_DIR"
backup_config "$QT6CT_DIR"
backup_config "$THUNAR_DIR"

# Create necessary directories
echo -e "${BLUE}Creating necessary directories...${NC}"
create_dir "$HYPR_DIR"
create_dir "$WAYBAR_DIR"
create_dir "$ROFI_DIR"
create_dir "$KITTY_DIR"
create_dir "$SWAPPY_DIR"
create_dir "$SWAYNC_DIR"
create_dir "$KVANTUM_DIR"
create_dir "$GTK_DIR"
create_dir "$QT5CT_DIR"
create_dir "$QT6CT_DIR"
create_dir "$THUNAR_DIR"
create_dir "$CURSOR_DIR"
create_dir "$HYPR_DIR/wallpapers"

# Extract and copy configuration files

# Copy configuration files directly from repository
echo -e "${BLUE}Installing FF6 Hyprland configuration...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a temporary directory for organization
TMP_DIR=$(mktemp -d)
echo -e "${YELLOW}Preparing configuration files...${NC}"

# Copy files to temporary directory for consistent structure
cp -r "$SCRIPT_DIR/"* "$TMP_DIR/"


# Create a temporary directory for extraction
TMP_DIR=$(mktemp -d)
tar -xzf "$CONFIG_ARCHIVE" -C "$TMP_DIR"

# Copy configuration files to their respective directories
echo -e "${YELLOW}Copying Hyprland configuration...${NC}"
cp -r "$TMP_DIR/hypr/"* "$HYPR_DIR/"

echo -e "${YELLOW}Copying Waybar configuration...${NC}"
cp -r "$TMP_DIR/waybar/"* "$WAYBAR_DIR/"

echo -e "${YELLOW}Copying Rofi configuration...${NC}"
cp -r "$TMP_DIR/rofi/"* "$ROFI_DIR/"

echo -e "${YELLOW}Copying Kitty configuration...${NC}"
cp -r "$TMP_DIR/kitty/"* "$KITTY_DIR/"

echo -e "${YELLOW}Copying Swappy configuration...${NC}"
cp -r "$TMP_DIR/swappy/"* "$SWAPPY_DIR/"

echo -e "${YELLOW}Copying SwayNC configuration...${NC}"
cp -r "$TMP_DIR/swaync/"* "$SWAYNC_DIR/"

echo -e "${YELLOW}Copying Kvantum configuration...${NC}"
cp -r "$TMP_DIR/kvantum/"* "$KVANTUM_DIR/"

echo -e "${YELLOW}Copying GTK configuration...${NC}"
cp -r "$TMP_DIR/gtk-themes/settings.ini" "$GTK_DIR/"

echo -e "${YELLOW}Copying Qt5ct configuration...${NC}"
cp -r "$TMP_DIR/qt5ct/"* "$QT5CT_DIR/"

echo -e "${YELLOW}Copying Qt6ct configuration...${NC}"
cp -r "$TMP_DIR/qt6ct/"* "$QT6CT_DIR/"

echo -e "${YELLOW}Copying Thunar configuration...${NC}"
cp -r "$TMP_DIR/thunar/"* "$THUNAR_DIR/"

echo -e "${YELLOW}Installing Atma Weapon cursor...${NC}"
mkdir -p "$CURSOR_DIR/AtmaWeapon"
cp -r "$TMP_DIR/cursor/AtmaWeapon/"* "$CURSOR_DIR/AtmaWeapon/"

# Make scripts executable
echo -e "${YELLOW}Making scripts executable...${NC}"
find "$HYPR_DIR" -name "*.sh" -exec chmod +x {} \;
find "$ROFI_DIR" -name "*.sh" -exec chmod +x {} \;
chmod +x "$KITTY_DIR/ff_sprite.py"

# Clean up temporary directory
rm -rf "$TMP_DIR"

# Generate FF6 sound effects
echo -e "${YELLOW}Generating FF6 sound effects...${NC}"
mkdir -p "$HYPR_DIR/sounds"
if [ -f "$SCRIPT_DIR/scripts/generate-sounds.sh" ]; then
    chmod +x "$SCRIPT_DIR/scripts/generate-sounds.sh"
    "$SCRIPT_DIR/scripts/generate-sounds.sh"
    echo -e "${GREEN}FF6 sound effects generated.${NC}"
else
    echo -e "${YELLOW}Generating sounds manually...${NC}"
    # Generate FF6-style cursor sound using SoX
    sox -n "$HYPR_DIR/sounds/cursor.wav" synth 0.1 sine 1200 fade 0 0.1 0.05
    # Generate FF6-style confirm sound using SoX
    sox -n "$HYPR_DIR/sounds/confirm.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
    echo -e "${GREEN}FF6 sound effects generated manually.${NC}"
fi

# Configure system interactions with FF6 sounds
echo -e "${YELLOW}Configuring system interactions with FF6 sounds...${NC}"
if [ -f "$SCRIPT_DIR/scripts/configure-sounds.sh" ]; then
    chmod +x "$SCRIPT_DIR/scripts/configure-sounds.sh"
    "$SCRIPT_DIR/scripts/configure-sounds.sh"
    echo -e "${GREEN}System interactions configured with FF6 sounds.${NC}"
else
    echo -e "${RED}Sound configuration script not found.${NC}"
fi

# Create a default wallpaper if none exists
if [ ! -f "$HYPR_DIR/wallpapers/current.png" ]; then
    echo -e "${YELLOW}Setting up default wallpaper...${NC}"
    # Try to download a FF6 wallpaper
    if command_exists curl; then
        mkdir -p "$HYPR_DIR/wallpapers"
        curl -s "https://wallpapercave.com/wp/wp2763910.jpg" -o "$HYPR_DIR/wallpapers/ff6_default.jpg"
        ln -sf "$HYPR_DIR/wallpapers/ff6_default.jpg" "$HYPR_DIR/wallpapers/current.png"
    else
        echo -e "${YELLOW}Could not download default wallpaper. Please set one manually.${NC}"
    fi
fi

# Set environment variables
echo -e "${YELLOW}Setting environment variables...${NC}"
ENV_FILES=("$HOME/.profile" "$HOME/.bash_profile" "$HOME/.zprofile" "$HOME/.config/hypr/env.conf")

# Create Hyprland environment file
create_dir "$(dirname "${ENV_FILES[3]}")"
touch "${ENV_FILES[3]}"

# Environment variables to set
ENV_VARS=(
    "QT_QPA_PLATFORMTHEME=qt5ct"
    "QT_QPA_PLATFORM=wayland"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION=1"
    "GDK_BACKEND=wayland,x11"
    "XCURSOR_THEME=AtmaWeapon"
    "XCURSOR_SIZE=24"
    "MOZ_ENABLE_WAYLAND=1"
    "XDG_CURRENT_DESKTOP=Hyprland"
    "XDG_SESSION_TYPE=wayland"
    "XDG_SESSION_DESKTOP=Hyprland"
)

# Add environment variables to all profile files
for ENV_FILE in "${ENV_FILES[@]}"; do
    if [[ "$ENV_FILE" == *"hypr/env.conf" ]]; then
        # For Hyprland env.conf, use the env format
        echo -e "${YELLOW}Setting up Hyprland environment variables in $ENV_FILE...${NC}"
        echo "# FF6 Hyprland Environment Variables" > "$ENV_FILE"
        for var in "${ENV_VARS[@]}"; do
            var_name="${var%%=*}"
            var_value="${var#*=}"
            echo "env = $var_name,$var_value" >> "$ENV_FILE"
        done
    else
        # For shell profile files, use export format
        if [ ! -f "$ENV_FILE" ]; then
            echo -e "${YELLOW}Creating $ENV_FILE...${NC}"
            touch "$ENV_FILE"
        fi
        
        echo -e "${YELLOW}Setting up environment variables in $ENV_FILE...${NC}"
        
        # Add a section marker if it doesn't exist
        if ! grep -q "# FF6 Hyprland Environment Variables" "$ENV_FILE"; then
            echo -e "\n# FF6 Hyprland Environment Variables" >> "$ENV_FILE"
        fi
        
        # Add environment variables if they don't exist
        for var in "${ENV_VARS[@]}"; do
            var_name="${var%%=*}"
            var_value="${var#*=}"
            if ! grep -q "export $var_name=" "$ENV_FILE"; then
                echo "export $var_name=$var_value" >> "$ENV_FILE"
            fi
        done
    fi
done

# Create a Hyprland session file for display managers
echo -e "${YELLOW}Creating Hyprland session file for display managers...${NC}"
XSESSIONS_DIR="/usr/share/xsessions"
WAYLAND_SESSIONS_DIR="/usr/share/wayland-sessions"

if [ -d "$XSESSIONS_DIR" ] && command_exists sudo; then
    HYPRLAND_DESKTOP="$XSESSIONS_DIR/hyprland.desktop"
    if [ ! -f "$HYPRLAND_DESKTOP" ]; then
        echo -e "${YELLOW}Creating $HYPRLAND_DESKTOP...${NC}"
        cat > /tmp/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland (FF6 Theme)
Comment=A dynamic tiling Wayland compositor with FF6 theme
Exec=Hyprland
Type=Application
EOF
        sudo mv /tmp/hyprland.desktop "$HYPRLAND_DESKTOP"
        sudo chmod 644 "$HYPRLAND_DESKTOP"
    fi
fi

if [ -d "$WAYLAND_SESSIONS_DIR" ] && command_exists sudo; then
    HYPRLAND_DESKTOP="$WAYLAND_SESSIONS_DIR/hyprland.desktop"
    if [ ! -f "$HYPRLAND_DESKTOP" ]; then
        echo -e "${YELLOW}Creating $HYPRLAND_DESKTOP...${NC}"
        cat > /tmp/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland (FF6 Theme)
Comment=A dynamic tiling Wayland compositor with FF6 theme
Exec=Hyprland
Type=Application
EOF
        sudo mv /tmp/hyprland.desktop "$HYPRLAND_DESKTOP"
        sudo chmod 644 "$HYPRLAND_DESKTOP"
    fi
fi

# Final validation
echo -e "${BLUE}Performing final validation...${NC}"
VALIDATION_FAILED=0

# Check if all required directories exist
for dir in "$HYPR_DIR" "$WAYBAR_DIR" "$ROFI_DIR" "$KITTY_DIR" "$SWAPPY_DIR" "$SWAYNC_DIR" "$KVANTUM_DIR" "$GTK_DIR" "$QT5CT_DIR" "$QT6CT_DIR" "$THUNAR_DIR"; do
    if [ ! -d "$dir" ]; then
        echo -e "${RED}Error: Directory $dir does not exist.${NC}"
        VALIDATION_FAILED=1
    fi
done

# Check if key configuration files exist
if [ ! -f "$HYPR_DIR/hyprland.conf" ]; then
    echo -e "${RED}Error: Hyprland configuration file not found.${NC}"
    VALIDATION_FAILED=1
fi

if [ ! -f "$WAYBAR_DIR/config-top.jsonc" ]; then
    echo -e "${RED}Error: Waybar top configuration file not found.${NC}"
    VALIDATION_FAILED=1
fi

if [ ! -f "$KITTY_DIR/kitty.conf" ]; then
    echo -e "${RED}Error: Kitty configuration file not found.${NC}"
    VALIDATION_FAILED=1
fi

# Check if sound files exist
if [ ! -f "$HYPR_DIR/sounds/cursor.wav" ]; then
    echo -e "${YELLOW}Warning: Cursor sound file not found. Will be generated on first run.${NC}"
fi

if [ ! -f "$HYPR_DIR/sounds/confirm.wav" ]; then
    echo -e "${YELLOW}Warning: Confirm sound file not found. Will be generated on first run.${NC}"
fi

# Check if scripts are executable
if [ ! -x "$HYPR_DIR/scripts/wallpaper-menu.sh" ] && [ -f "$HYPR_DIR/scripts/wallpaper-menu.sh" ]; then
    echo -e "${YELLOW}Warning: wallpaper-menu.sh is not executable. Fixing...${NC}"
    chmod +x "$HYPR_DIR/scripts/wallpaper-menu.sh"
fi

if [ ! -x "$KITTY_DIR/ff_sprite.py" ] && [ -f "$KITTY_DIR/ff_sprite.py" ]; then
    echo -e "${YELLOW}Warning: ff_sprite.py is not executable. Fixing...${NC}"
    chmod +x "$KITTY_DIR/ff_sprite.py"
fi

# Final status
if [ $VALIDATION_FAILED -eq 1 ]; then
    echo -e "${RED}Validation failed. Some components may not work correctly.${NC}"
    echo -e "${YELLOW}Please check the error messages above and fix the issues.${NC}"
else
    echo -e "${GREEN}Validation successful! All components are properly installed.${NC}"
fi

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}FF6 Hyprland Configuration Installation Complete!${NC}"
echo -e "${BLUE}=========================================${NC}"
echo
echo -e "${YELLOW}Your original configurations have been backed up to:${NC}"
echo -e "${BLUE}$BACKUP_DIR${NC}"
echo
echo -e "${YELLOW}To start using the FF6 Hyprland configuration:${NC}"
echo -e "${BLUE}1. Log out of your current session${NC}"
echo -e "${BLUE}2. Select Hyprland from your display manager${NC}"
echo -e "${BLUE}3. Log in${NC}"
echo
echo -e "${YELLOW}Keybindings:${NC}"
echo -e "${BLUE}Super + Enter${NC}: Open terminal (Magic)"
echo -e "${BLUE}Super + E${NC}: Open file manager (Items)"
echo -e "${BLUE}Super + D${NC}: Open application launcher (Rofi)"
echo -e "${BLUE}Super + NUM${NC}: Switch to workspace"
echo -e "${BLUE}Super + Shift + NUM${NC}: Move window to workspace"
echo
echo -e "${YELLOW}For customization options, see the README.md file.${NC}"
echo -e "${YELLOW}Enjoy your FF6-themed Hyprland experience!${NC}"

# Offer to edit configuration files
echo
read -p "Would you like to edit any configuration files now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    PS3="Select a file to edit (or 0 to exit): "
    options=(
        "hyprland.conf" 
        "animations.conf" 
        "keybinds.conf" 
        "colors.conf" 
        "waybar/config-top.jsonc" 
        "waybar/config-bottom.jsonc" 
        "waybar/style.css" 
        "kitty/kitty.conf" 
        "Exit"
    )
    
    select opt in "${options[@]}"; do
        case $opt in
            "Exit")
                break
                ;;
            *)
                if [ -n "$opt" ]; then
                    if [ "$opt" == "waybar/config-top.jsonc" ]; then
                        ${EDITOR:-nano} "$WAYBAR_DIR/config-top.jsonc"
                    elif [ "$opt" == "waybar/config-bottom.jsonc" ]; then
                        ${EDITOR:-nano} "$WAYBAR_DIR/config-bottom.jsonc"
                    elif [ "$opt" == "waybar/style.css" ]; then
                        ${EDITOR:-nano} "$WAYBAR_DIR/style.css"
                    elif [ "$opt" == "kitty/kitty.conf" ]; then
                        ${EDITOR:-nano} "$KITTY_DIR/kitty.conf"
                    else
                        ${EDITOR:-nano} "$HYPR_DIR/$opt"
                    fi
                    echo -e "${GREEN}File edited.${NC}"
                else
                    echo -e "${RED}Invalid option.${NC}"
                fi
                ;;
        esac
    done
fi

echo -e "${GREEN}Thank you for installing the FF6 Hyprland Configuration!${NC}"
