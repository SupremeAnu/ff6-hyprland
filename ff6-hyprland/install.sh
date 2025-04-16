#!/bin/bash
# FF6 Hyprland Configuration Auto-Installer
# Created: April 2025
# Credits: Some components adapted from JaKooLit's Hyprland-Dots (https://github.com/JaKooLit/Hyprland-Dots)

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

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        echo -e "${GREEN}Detected distribution: $DISTRO${NC}"
        return 0
    else
        echo -e "${YELLOW}Warning: Unable to detect distribution. Assuming Arch Linux.${NC}"
        DISTRO="arch"
        return 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if a package is installed (for different package managers)
package_installed() {
    local pkg="$1"
    
    case "$DISTRO" in
        arch|manjaro|endeavouros|garuda)
            pacman -Q "$pkg" &> /dev/null
            return $?
            ;;
        debian|ubuntu|pop|linuxmint)
            dpkg -l "$pkg" &> /dev/null
            return $?
            ;;
        fedora|centos|rhel)
            rpm -q "$pkg" &> /dev/null
            return $?
            ;;
        *)
            # Fallback method - try to check if the command exists
            if [[ "$pkg" == *-* ]]; then
                # For packages with hyphens, try to check the command after the last hyphen
                local cmd=$(echo "$pkg" | rev | cut -d'-' -f1 | rev)
                command_exists "$cmd" && return 0
            else
                command_exists "$pkg" && return 0
            fi
            return 1
            ;;
    esac
}

# Function to get equivalent package name for different distributions
get_package_name() {
    local pkg="$1"
    
    case "$DISTRO" in
        arch|manjaro|endeavouros|garuda)
            echo "$pkg"
            ;;
        debian|ubuntu|pop|linuxmint)
            case "$pkg" in
                "hyprland") echo "hyprland" ;;
                "waybar") echo "waybar" ;;
                "rofi-wayland") echo "rofi" ;;
                "kitty") echo "kitty" ;;
                "kvantum") echo "qt5-style-kvantum" ;;
                "cava") echo "cava" ;;
                "grim") echo "grim" ;;
                "slurp") echo "slurp" ;;
                "swappy") echo "swappy" ;;
                "swww") echo "swww" ;;
                "cliphist") echo "cliphist" ;;
                "swaync") echo "swaync" ;;
                "swaybg") echo "swaybg" ;;
                "wallust") echo "wallust" ;;
                "nwg-look") echo "nwg-look" ;;
                "gtk3") echo "libgtk-3-0" ;;
                "qt5ct") echo "qt5ct" ;;
                "qt6ct") echo "qt6ct" ;;
                "thunar") echo "thunar" ;;
                "hyprlock") echo "hyprlock" ;;
                "papirus-icon-theme") echo "papirus-icon-theme" ;;
                "ttf-jetbrains-mono-nerd") echo "fonts-jetbrains-mono" ;;
                "ttf-victor-mono") echo "fonts-victor-mono" ;;
                "ttf-fantasque-sans-mono") echo "fonts-fantasque-sans" ;;
                "polkit-kde-agent") echo "polkit-kde-agent-1" ;;
                "python") echo "python3" ;;
                "python-pip") echo "python3-pip" ;;
                "btop") echo "btop" ;;
                "pavucontrol") echo "pavucontrol" ;;
                "networkmanager") echo "network-manager" ;;
                "blueman") echo "blueman" ;;
                "xdg-desktop-portal-hyprland") echo "xdg-desktop-portal-hyprland" ;;
                "xdg-utils") echo "xdg-utils" ;;
                "imagemagick") echo "imagemagick" ;;
                "wl-clipboard") echo "wl-clipboard" ;;
                "sox") echo "sox" ;;
                "pulseaudio") echo "pulseaudio" ;;
                "pulseaudio-utils") echo "pulseaudio-utils" ;;
                "jq") echo "jq" ;;
                "yad") echo "yad" ;;
                "zenity") echo "zenity" ;;
                "xcursor-themes") echo "xcursor-themes" ;;
                "xorg-xcursorgen") echo "x11-apps" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        fedora|centos|rhel)
            case "$pkg" in
                "hyprland") echo "hyprland" ;;
                "waybar") echo "waybar" ;;
                "rofi-wayland") echo "rofi" ;;
                "kitty") echo "kitty" ;;
                "kvantum") echo "kvantum" ;;
                "cava") echo "cava" ;;
                "grim") echo "grim" ;;
                "slurp") echo "slurp" ;;
                "swappy") echo "swappy" ;;
                "swww") echo "swww" ;;
                "cliphist") echo "cliphist" ;;
                "swaync") echo "swaync" ;;
                "swaybg") echo "swaybg" ;;
                "wallust") echo "wallust" ;;
                "nwg-look") echo "nwg-look" ;;
                "gtk3") echo "gtk3" ;;
                "qt5ct") echo "qt5ct" ;;
                "qt6ct") echo "qt6ct" ;;
                "thunar") echo "thunar" ;;
                "hyprlock") echo "hyprlock" ;;
                "papirus-icon-theme") echo "papirus-icon-theme" ;;
                "ttf-jetbrains-mono-nerd") echo "jetbrains-mono-fonts-all" ;;
                "ttf-victor-mono") echo "victor-mono-fonts" ;;
                "ttf-fantasque-sans-mono") echo "fantasque-sans-mono-fonts" ;;
                "polkit-kde-agent") echo "polkit-kde-authentication-agent-1" ;;
                "python") echo "python3" ;;
                "python-pip") echo "python3-pip" ;;
                "btop") echo "btop" ;;
                "pavucontrol") echo "pavucontrol" ;;
                "networkmanager") echo "NetworkManager" ;;
                "blueman") echo "blueman" ;;
                "xdg-desktop-portal-hyprland") echo "xdg-desktop-portal-hyprland" ;;
                "xdg-utils") echo "xdg-utils" ;;
                "imagemagick") echo "ImageMagick" ;;
                "wl-clipboard") echo "wl-clipboard" ;;
                "sox") echo "sox" ;;
                "pulseaudio") echo "pulseaudio" ;;
                "pulseaudio-utils") echo "pulseaudio-utils" ;;
                "jq") echo "jq" ;;
                "yad") echo "yad" ;;
                "zenity") echo "zenity" ;;
                "xcursor-themes") echo "xcursor-themes" ;;
                "xorg-xcursorgen") echo "xcursorgen" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        *)
            echo "$pkg"
            ;;
    esac
}

# Function to install a package if not already installed
install_package() {
    local pkg="$1"
    local distro_pkg=$(get_package_name "$pkg")
    
    if ! package_installed "$distro_pkg"; then
        echo -e "${YELLOW}Installing $distro_pkg...${NC}"
        
        case "$DISTRO" in
            arch|manjaro|endeavouros|garuda)
                if command_exists yay; then
                    yay -S --needed --noconfirm "$distro_pkg" || {
                        echo -e "${YELLOW}Warning: Failed to install $distro_pkg with yay. Skipping...${NC}"
                        return 1
                    }
                else
                    sudo pacman -S --needed --noconfirm "$distro_pkg" || {
                        echo -e "${YELLOW}Warning: Failed to install $distro_pkg with pacman. Skipping...${NC}"
                        return 1
                    }
                fi
                ;;
            debian|ubuntu|pop|linuxmint)
                sudo apt update && sudo apt install -y "$distro_pkg" || {
                    echo -e "${YELLOW}Warning: Failed to install $distro_pkg with apt. Skipping...${NC}"
                    return 1
                }
                ;;
            fedora)
                sudo dnf install -y "$distro_pkg" || {
                    echo -e "${YELLOW}Warning: Failed to install $distro_pkg with dnf. Skipping...${NC}"
                    return 1
                }
                ;;
            centos|rhel)
                sudo yum install -y "$distro_pkg" || {
                    echo -e "${YELLOW}Warning: Failed to install $distro_pkg with yum. Skipping...${NC}"
                    return 1
                }
                ;;
            *)
                echo -e "${RED}Error: No supported package manager found for $DISTRO. Please install $distro_pkg manually.${NC}"
                return 1
                ;;
        esac
        echo -e "${GREEN}$distro_pkg installed.${NC}"
    else
        echo -e "${GREEN}$distro_pkg is already installed.${NC}"
    fi
}

# Function to check for audio package conflicts
check_audio_conflicts() {
    local audio_system=""
    
    # Check for PulseAudio
    if package_installed "pulseaudio" || command_exists pulseaudio; then
        audio_system="pulseaudio"
    fi
    
    # Check for PipeWire
    if package_installed "pipewire" || package_installed "pipewire-pulse" || command_exists pipewire; then
        if [ -n "$audio_system" ]; then
            echo -e "${YELLOW}Warning: Both PulseAudio and PipeWire detected.${NC}"
            echo -e "${YELLOW}This may cause conflicts. It's recommended to use only one audio system.${NC}"
            
            read -p "Do you want to use PipeWire and remove PulseAudio? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${YELLOW}Removing PulseAudio and configuring PipeWire...${NC}"
                
                case "$DISTRO" in
                    arch|manjaro|endeavouros|garuda)
                        sudo pacman -R --noconfirm pulseaudio pulseaudio-bluetooth || true
                        install_package "pipewire"
                        install_package "pipewire-pulse"
                        install_package "pipewire-alsa"
                        install_package "wireplumber"
                        ;;
                    debian|ubuntu|pop|linuxmint)
                        sudo apt remove --purge -y pulseaudio pulseaudio-utils pulseaudio-module-bluetooth || true
                        sudo apt install -y pipewire pipewire-pulse wireplumber
                        ;;
                    fedora|centos|rhel)
                        sudo dnf remove -y pulseaudio pulseaudio-utils || true
                        sudo dnf install -y pipewire pipewire-pulseaudio wireplumber
                        ;;
                esac
                
                audio_system="pipewire"
                echo -e "${GREEN}Audio system configured to use PipeWire.${NC}"
            else
                echo -e "${GREEN}Keeping PulseAudio as the audio system.${NC}"
                audio_system="pulseaudio"
            fi
        else
            audio_system="pipewire"
        fi
    fi
    
    # If no audio system detected, install PipeWire as default
    if [ -z "$audio_system" ]; then
        echo -e "${YELLOW}No audio system detected. Installing PipeWire...${NC}"
        
        case "$DISTRO" in
            arch|manjaro|endeavouros|garuda)
                install_package "pipewire"
                install_package "pipewire-pulse"
                install_package "pipewire-alsa"
                install_package "wireplumber"
                ;;
            debian|ubuntu|pop|linuxmint)
                sudo apt install -y pipewire pipewire-pulse wireplumber
                ;;
            fedora|centos|rhel)
                sudo dnf install -y pipewire pipewire-pulseaudio wireplumber
                ;;
        esac
        
        audio_system="pipewire"
        echo -e "${GREEN}Audio system configured to use PipeWire.${NC}"
    fi
    
    echo -e "${GREEN}Using $audio_system as the audio system.${NC}"
    return 0
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

# Detect distribution
detect_distro

# Check if yay is installed, install if not (Arch Linux only)
if [[ "$DISTRO" == "arch" || "$DISTRO" == "manjaro" || "$DISTRO" == "endeavouros" || "$DISTRO" == "garuda" ]] && ! command_exists yay; then
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

# Check for audio conflicts
check_audio_conflicts

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
    "jq"
    "yad"
    "zenity"
    "xcursor-themes"
    "xorg-xcursorgen"
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
create_dir "$HYPR_DIR/scripts"
create_dir "$HYPR_DIR/sounds"

# Copy configuration files
echo -e "${BLUE}Copying configuration files...${NC}"

# Function to copy files with error handling
copy_config() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$src" ]; then
        echo -e "${YELLOW}Copying $src to $dest${NC}"
        mkdir -p "$(dirname "$dest")"
        cp -r "$src" "$dest"
        echo -e "${GREEN}Copy successful.${NC}"
    else
        echo -e "${RED}Error: Source file/directory $src not found.${NC}"
        return 1
    fi
}

# Copy Hyprland configuration
copy_config "hypr/hyprland.conf" "$HYPR_DIR/hyprland.conf"
copy_config "hypr/animations.conf" "$HYPR_DIR/animations.conf"
copy_config "hypr/colors.conf" "$HYPR_DIR/colors.conf"
copy_config "hypr/keybinds.conf" "$HYPR_DIR/keybinds.conf"

# Copy scripts
for script in hypr/scripts/*.sh; do
    if [ -f "$script" ]; then
        copy_config "$script" "$HYPR_DIR/scripts/$(basename "$script")"
        chmod +x "$HYPR_DIR/scripts/$(basename "$script")"
    fi
done

# Copy waybar configuration
copy_config "waybar/config-top.jsonc" "$WAYBAR_DIR/config-top.jsonc"
copy_config "waybar/config-bottom.jsonc" "$WAYBAR_DIR/config-bottom.jsonc"
copy_config "waybar/style.css" "$WAYBAR_DIR/style.css"

# Copy rofi configuration
copy_config "rofi/config.rasi" "$ROFI_DIR/config.rasi"
copy_config "rofi/ff6-theme.rasi" "$ROFI_DIR/ff6-theme.rasi"
create_dir "$ROFI_DIR/scripts"
for script in rofi/scripts/*.sh; do
    if [ -f "$script" ]; then
        copy_config "$script" "$ROFI_DIR/scripts/$(basename "$script")"
        chmod +x "$ROFI_DIR/scripts/$(basename "$script")"
    fi
done

# Copy kitty configuration
copy_config "kitty/kitty.conf" "$KITTY_DIR/kitty.conf"
copy_config "kitty/ff_sprite.py" "$KITTY_DIR/ff_sprite.py"
chmod +x "$KITTY_DIR/ff_sprite.py"

# Copy swappy configuration
copy_config "swappy/config" "$SWAPPY_DIR/config"

# Copy swaync configuration
copy_config "swaync/config.json" "$SWAYNC_DIR/config.json"

# Copy kvantum configuration
copy_config "kvantum/kvantum.kvconfig" "$KVANTUM_DIR/kvantum.kvconfig"

# Copy GTK configuration
copy_config "gtk-themes/settings.ini" "$GTK_DIR/settings.ini"

# Copy QT5CT configuration
copy_config "qt5ct/qt5ct.conf" "$QT5CT_DIR/qt5ct.conf"

# Copy QT6CT configuration
copy_config "qt6ct/qt6ct.conf" "$QT6CT_DIR/qt6ct.conf"

# Copy Thunar configuration
copy_config "thunar/uca.xml" "$THUNAR_DIR/uca.xml"

# Create cursor theme
echo -e "${BLUE}Creating cursor theme...${NC}"
if [ -f "scripts/create-atma-cursor.sh" ]; then
    chmod +x "scripts/create-atma-cursor.sh"
    ./scripts/create-atma-cursor.sh
else
    echo -e "${YELLOW}Warning: Cursor theme script not found. Skipping cursor theme creation.${NC}"
fi

# Generate sound effects
echo -e "${BLUE}Generating sound effects...${NC}"
if [ -f "scripts/generate-sounds.sh" ]; then
    chmod +x "scripts/generate-sounds.sh"
    ./scripts/generate-sounds.sh
else
    echo -e "${YELLOW}Warning: Sound generation script not found. Skipping sound generation.${NC}"
fi

# Configure sound effects
echo -e "${BLUE}Configuring sound effects...${NC}"
if [ -f "scripts/configure-sounds.sh" ]; then
    chmod +x "scripts/configure-sounds.sh"
    ./scripts/configure-sounds.sh
else
    echo -e "${YELLOW}Warning: Sound configuration script not found. Skipping sound configuration.${NC}"
fi

# Configure display
echo -e "${BLUE}Configuring display...${NC}"
if [ -f "scripts/configure-display.sh" ]; then
    chmod +x "scripts/configure-display.sh"
    ./scripts/configure-display.sh
else
    echo -e "${YELLOW}Warning: Display configuration script not found. Skipping display configuration.${NC}"
fi

# Fix window switching
echo -e "${BLUE}Fixing window switching...${NC}"
if [ -f "scripts/fix-window-switching.sh" ]; then
    chmod +x "scripts/fix-window-switching.sh"
    ./scripts/fix-window-switching.sh
else
    echo -e "${YELLOW}Warning: Window switching script not found. Skipping window switching fix.${NC}"
fi

# Test configuration
echo -e "${BLUE}Testing configuration...${NC}"
if [ -f "scripts/test-all.sh" ]; then
    chmod +x "scripts/test-all.sh"
    ./scripts/test-all.sh
else
    echo -e "${YELLOW}Warning: Test script not found. Skipping configuration testing.${NC}"
fi

# Create default wallpaper
echo -e "${BLUE}Setting up default wallpaper...${NC}"
if [ -f "hypr/scripts/set-wallpaper.sh" ]; then
    chmod +x "hypr/scripts/set-wallpaper.sh"
    ./hypr/scripts/set-wallpaper.sh
else
    echo -e "${YELLOW}Warning: Wallpaper script not found. Skipping wallpaper setup.${NC}"
fi

# Final message
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}FF6 Hyprland configuration installed successfully!${NC}"
echo -e "${YELLOW}Please log out and select Hyprland from your display manager to start using your new configuration.${NC}"
echo -e "${YELLOW}Use Super+H to view keybindings help.${NC}"
echo -e "${BLUE}=========================================${NC}"
