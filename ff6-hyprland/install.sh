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
    if command_exists pacman; then
        pacman -Q "$1" &> /dev/null
        return $?
    elif command_exists apt; then
        dpkg -l "$1" &> /dev/null
        return $?
    elif command_exists dnf; then
        dnf list installed "$1" &> /dev/null
        return $?
    else
        echo -e "${YELLOW}Warning: Unable to determine package manager. Assuming package $1 is not installed.${NC}"
        return 1
    fi
}

# Function to install a package if not already installed
install_package() {
    if ! package_installed "$1"; then
        echo -e "${YELLOW}Installing $1...${NC}"
        if command_exists yay; then
            yay -S --needed --noconfirm "$1" || {
                echo -e "${YELLOW}Warning: Failed to install $1 with yay. Skipping...${NC}"
                return 1
            }
        elif command_exists pacman; then
            sudo pacman -S --needed --noconfirm "$1" || {
                echo -e "${YELLOW}Warning: Failed to install $1 with pacman. Skipping...${NC}"
                return 1
            }
        elif command_exists apt; then
            sudo apt install -y "$1" || {
                echo -e "${YELLOW}Warning: Failed to install $1 with apt. Skipping...${NC}"
                return 1
            }
        elif command_exists dnf; then
            sudo dnf install -y "$1" || {
                echo -e "${YELLOW}Warning: Failed to install $1 with dnf. Skipping...${NC}"
                return 1
            }
        else
            echo -e "${RED}Error: No supported package manager found. Please install $1 manually.${NC}"
            return 1
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
    echo -e "${YELLOW}Warning: This script is optimized for Arch Linux.${NC}"
    echo -e "${YELLOW}Some features may not work correctly on other distributions.${NC}"
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation aborted.${NC}"
        exit 1
    fi
fi

# Check if yay is installed, install if not (Arch Linux only)
if command_exists pacman && ! command_exists yay; then
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

# Install packages with error handling
INSTALL_ERRORS=0
for pkg in "${PACKAGES[@]}"; do
    if ! install_package "$pkg"; then
        INSTALL_ERRORS=$((INSTALL_ERRORS+1))
    fi
done

if [ $INSTALL_ERRORS -gt 0 ]; then
    echo -e "${YELLOW}Warning: $INSTALL_ERRORS packages could not be installed.${NC}"
    echo -e "${YELLOW}Some features may not work correctly.${NC}"
    read -p "Do you want to continue with the installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation aborted.${NC}"
        exit 1
    fi
fi

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
    install_package "$font_pkg"
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
create_dir "$HYPR_DIR/sounds"

# Determine the source of configuration files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ARCHIVE="$SCRIPT_DIR/ff6-hyprland-config.tar.gz"
CONFIG_DIR_SOURCE="$SCRIPT_DIR"

echo -e "${BLUE}Installing FF6 Hyprland configuration...${NC}"

# Check if we're running from within the extracted repository
if [ -d "$SCRIPT_DIR/hypr" ] && [ -d "$SCRIPT_DIR/waybar" ] && [ -d "$SCRIPT_DIR/rofi" ]; then
    echo -e "${GREEN}Using configuration files from the current directory...${NC}"
    
    # Copy configuration files directly from the repository
    echo -e "${YELLOW}Copying Hyprland configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/hypr/"* "$HYPR_DIR/"
    
    echo -e "${YELLOW}Copying Waybar configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/waybar/"* "$WAYBAR_DIR/"
    
    echo -e "${YELLOW}Copying Rofi configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/rofi/"* "$ROFI_DIR/"
    
    echo -e "${YELLOW}Copying Kitty configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/kitty/"* "$KITTY_DIR/"
    
    echo -e "${YELLOW}Copying Swappy configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/swappy/"* "$SWAPPY_DIR/"
    
    echo -e "${YELLOW}Copying SwayNC configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/swaync/"* "$SWAYNC_DIR/"
    
    echo -e "${YELLOW}Copying Kvantum configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/kvantum/"* "$KVANTUM_DIR/"
    
    echo -e "${YELLOW}Copying GTK configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/gtk-themes/settings.ini" "$GTK_DIR/"
    
    echo -e "${YELLOW}Copying Qt5ct configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/qt5ct/"* "$QT5CT_DIR/"
    
    echo -e "${YELLOW}Copying Qt6ct configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/qt6ct/"* "$QT6CT_DIR/"
    
    echo -e "${YELLOW}Copying Thunar configuration...${NC}"
    cp -r "$CONFIG_DIR_SOURCE/thunar/"* "$THUNAR_DIR/"
    
    echo -e "${YELLOW}Installing Atma Weapon cursor...${NC}"
    create_dir "$CURSOR_DIR/AtmaWeapon"
    cp -r "$CONFIG_DIR_SOURCE/cursor/AtmaWeapon/"* "$CURSOR_DIR/AtmaWeapon/"
    
    # Copy sound files if they exist
    if [ -d "$CONFIG_DIR_SOURCE/sounds" ]; then
        echo -e "${YELLOW}Copying sound files...${NC}"
        cp -r "$CONFIG_DIR_SOURCE/sounds/"* "$HYPR_DIR/sounds/"
    fi
    
elif [ -f "$CONFIG_ARCHIVE" ]; then
    echo -e "${GREEN}Using configuration files from archive...${NC}"
    
    # Create a temporary directory for extraction
    TMP_DIR=$(mktemp -d)
    tar -xzf "$CONFIG_ARCHIVE" -C "$TMP_DIR"
    
    # Copy configuration files from the extracted archive
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
    create_dir "$CURSOR_DIR/AtmaWeapon"
    cp -r "$TMP_DIR/cursor/AtmaWeapon/"* "$CURSOR_DIR/AtmaWeapon/"
    
    # Copy sound files if they exist
    if [ -d "$TMP_DIR/sounds" ]; then
        echo -e "${YELLOW}Copying sound files...${NC}"
        cp -r "$TMP_DIR/sounds/"* "$HYPR_DIR/sounds/"
    fi
    
    # Clean up temporary directory
    rm -rf "$TMP_DIR"
else
    echo -e "${RED}Error: Configuration files not found!${NC}"
    echo -e "${RED}Please make sure you're running this script from the FF6 Hyprland configuration directory.${NC}"
    echo -e "${RED}or that the ff6-hyprland-config.tar.gz file is in the same directory as this script.${NC}"
    exit 1
fi

# Make scripts executable
echo -e "${YELLOW}Making scripts executable...${NC}"
find "$HYPR_DIR" -name "*.sh" -exec chmod +x {} \;
find "$ROFI_DIR" -name "*.sh" -exec chmod +x {} \;
if [ -f "$KITTY_DIR/ff_sprite.py" ]; then
    chmod +x "$KITTY_DIR/ff_sprite.py"
fi

# Generate FF6 sound effects if they don't exist
echo -e "${YELLOW}Checking FF6 sound effects...${NC}"
if [ ! -f "$HYPR_DIR/sounds/cursor.wav" ] || [ ! -f "$HYPR_DIR/sounds/confirm.wav" ]; then
    echo -e "${YELLOW}Generating FF6 sound effects...${NC}"
    
    if [ -f "$SCRIPT_DIR/scripts/generate-sounds.sh" ]; then
        chmod +x "$SCRIPT_DIR/scripts/generate-sounds.sh"
        "$SCRIPT_DIR/scripts/generate-sounds.sh"
        echo -e "${GREEN}FF6 sound effects generated.${NC}"
    elif command_exists sox; then
        echo -e "${YELLOW}Generating sounds manually...${NC}"
        # Generate FF6-style cursor sound using SoX
        sox -n "$HYPR_DIR/sounds/cursor.wav" synth 0.05 sine 1200 fade 0 0.05 0.02 vol 0.5
        # Generate FF6-style confirm sound using SoX
        sox -n "$HYPR_DIR/sounds/confirm.wav" synth 0.1 sine 800:1200 fade 0 0.1 0.03 vol 0.5
        # Generate FF6-style menu open sound
        sox -n "$HYPR_DIR/sounds/menu_open.wav" synth 0.15 sine 600:900 fade 0 0.15 0.05 vol 0.5
        # Generate FF6-style error sound
        sox -n "$HYPR_DIR/sounds/error.wav" synth 0.2 sine 300:200 fade 0 0.2 0.05 vol 0.5
        echo -e "${GREEN}FF6 sound effects generated manually.${NC}"
    else
        echo -e "${RED}Warning: Sox not installed and sound files not found. Sound effects will not be available.${NC}"
    fi
else
    echo -e "${GREEN}FF6 sound effects already exist.${NC}"
fi

# Configure system interactions with FF6 sounds
echo -e "${YELLOW}Configuring system interactions with FF6 sounds...${NC}"
if [ -f "$SCRIPT_DIR/scripts/configure-sounds.sh" ]; then
    chmod +x "$SCRIPT_DIR/scripts/configure-sounds.sh"
    "$SCRIPT_DIR/scripts/configure-sounds.sh"
    echo -e "${GREEN}System interactions configured with FF6 sounds.${NC}"
else
    echo -e "${YELLOW}Sound configuration script not found. Using default configuration.${NC}"
    
    # Create a basic sound player script
    cat > "$HYPR_DIR/scripts/play-sound.sh" << EOF
#!/bin/bash
# Script to play FF6 sounds for Hyprland actions

SOUND_DIR="\$HOME/.config/hypr/sounds"

case "\$1" in
    "cursor")
        paplay "\$SOUND_DIR/cursor.wav" &
        ;;
    "confirm")
        paplay "\$SOUND_DIR/confirm.wav" &
        ;;
    "menu_open")
        paplay "\$SOUND_DIR/menu_open.wav" &
        ;;
    "error")
        paplay "\$SOUND_DIR/error.wav" &
        ;;
    *)
        echo "Unknown sound: \$1"
        ;;
esac
EOF
    chmod +x "$HYPR_DIR/scripts/play-sound.sh"
    echo -e "${GREEN}Basic sound player script created.${NC}"
fi

# Create a default wallpaper if none exists
if [ ! -f "$HYPR_DIR/wallpapers/current.png" ]; then
    echo -e "${YELLOW}Setting up default wallpaper...${NC}"
    # Try to download a FF6 wallpaper
    if command_exists curl; then
        mkdir -p "$HYPR_DIR/wallpapers"
        curl -s "https://wallpapercave.com/wp/wp2763910.jpg" -o "$HYPR_DIR/wallpapers/ff6_default.jpg"
        ln -sf "$HYPR_DIR/wallpapers/ff6_default.jpg" "$HYPR_DIR/wallpapers/current.png"
        echo -e "${GREEN}Default wallpaper downloaded and set.${NC}"
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

# Ensure cursor theme is properly set up
echo -e "${YELLOW}Setting up cursor theme...${NC}"
if [ -d "$CURSOR_DIR/AtmaWeapon" ]; then
    # Create index.theme file if it doesn't exist
    if [ ! -f "$CURSOR_DIR/AtmaWeapon/index.theme" ]; then
        cat > "$CURSOR_DIR/AtmaWeapon/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6-themed cursor from Atma Weapon
Inherits=Adwaita
EOF
    fi
    
    # Create cursor.theme file if it doesn't exist
    if [ ! -f "$CURSOR_DIR/AtmaWeapon/cursor.theme" ]; then
        cat > "$CURSOR_DIR/AtmaWeapon/cursor.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6-themed cursor from Atma Weapon
EOF
    fi
    
    # Create cursors directory if it doesn't exist
    create_dir "$CURSOR_DIR/AtmaWeapon/cursors"
    
    # Create a basic cursor if none exists
    if [ -z "$(ls -A "$CURSOR_DIR/AtmaWeapon/cursors" 2>/dev/null)" ]; then
        echo -e "${YELLOW}Creating basic cursor files...${NC}"
        if command_exists convert; then
            # Create a simple cursor image
            convert -size 24x24 xc:transparent -fill "#4080FF" -draw "circle 12,12 12,2" "$CURSOR_DIR/AtmaWeapon/atma_weapon.png"
            
            # Create cursor files if xcursorgen is available
            if command_exists xcursorgen; then
                echo "24 12 12 atma_weapon.png" > "$CURSOR_DIR/AtmaWeapon/cursor.config"
                xcursorgen "$CURSOR_DIR/AtmaWeapon/cursor.config" "$CURSOR_DIR/AtmaWeapon/cursors/left_ptr"
                # Create symlinks for other cursor types
                cd "$CURSOR_DIR/AtmaWeapon/cursors"
                for cursor in arrow default pointer; do
                    ln -sf left_ptr "$cursor"
                done
            fi
        fi
    fi
    
    # Update user's cursor configuration
    echo -e "${YELLOW}Updating user cursor configuration...${NC}"
    mkdir -p "$HOME/.icons"
    ln -sf "$CURSOR_DIR/AtmaWeapon" "$HOME/.icons/"
    
    # Update GTK cursor theme
    if [ -f "$GTK_DIR/settings.ini" ]; then
        if grep -q "gtk-cursor-theme-name" "$GTK_DIR/settings.ini"; then
            sed -i 's/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=AtmaWeapon/' "$GTK_DIR/settings.ini"
        else
            echo "gtk-cursor-theme-name=AtmaWeapon" >> "$GTK_DIR/settings.ini"
        fi
    else
        mkdir -p "$GTK_DIR"
        echo "[Settings]" > "$GTK_DIR/settings.ini"
        echo "gtk-cursor-theme-name=AtmaWeapon" >> "$GTK_DIR/settings.ini"
    fi
    
    echo -e "${GREEN}Cursor theme set up successfully.${NC}"
else
    echo -e "${RED}Error: Cursor theme directory not found or could not be created.${NC}"
    echo -e "${YELLOW}Cursor theme will not be available.${NC}"
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

# Check cursor theme
if [ ! -d "$CURSOR_DIR/AtmaWeapon" ] || [ -z "$(ls -A "$CURSOR_DIR/AtmaWeapon/cursors" 2>/dev/null)" ]; then
    echo -e "${YELLOW}Warning: Cursor theme may not be properly installed.${NC}"
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
echo -e "${BLUE}Super + H${NC}: Show keybindings help"
echo -e "${BLUE}Super + NUM${NC}: Switch to workspace"
echo -e "${BLUE}Super + Shift + NUM${NC}: Move window to workspace"
echo -e "${BLUE}Alt + Tab${NC}: Switch between windows"
echo
echo -e "${YELLOW}For customization options, see the README.md file.${NC}"
echo -e "${YELLOW}Enjoy your FF6-themed Hyprland experience!${NC}"
