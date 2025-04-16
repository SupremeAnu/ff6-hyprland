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

# Configure display resolution
echo -e "${YELLOW}Configuring display resolution...${NC}"
if [ -f "$HYPR_DIR/scripts/configure-display.sh" ]; then
    chmod +x "$HYPR_DIR/scripts/configure-display.sh"
    echo -e "${GREEN}Display configuration script is ready.${NC}"
    echo -e "${YELLOW}It will run automatically when Hyprland starts.${NC}"
else
    echo -e "${RED}Warning: Display configuration script not found.${NC}"
    echo -e "${RED}Resolution detection and scaling may not work correctly.${NC}"
fi

# Create Atma Weapon cursor if it doesn't exist
if [ ! -d "$CURSOR_DIR/AtmaWeapon" ] || [ ! -f "$CURSOR_DIR/AtmaWeapon/cursor.theme" ]; then
    echo -e "${YELLOW}Creating Atma Weapon cursor...${NC}"
    if [ -f "$SCRIPT_DIR/scripts/create-atma-cursor.sh" ]; then
        chmod +x "$SCRIPT_DIR/scripts/create-atma-cursor.sh"
        "$SCRIPT_DIR/scripts/create-atma-cursor.sh"
        echo -e "${GREEN}Atma Weapon cursor created.${NC}"
    else
        echo -e "${RED}Warning: Cursor creation script not found.${NC}"
        echo -e "${RED}Cursor theme may not work correctly.${NC}"
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
    if [ -f "$ENV_FILE" ]; then
        echo -e "${YELLOW}Updating $ENV_FILE...${NC}"
        
        # Add each environment variable if it doesn't exist
        for ENV_VAR in "${ENV_VARS[@]}"; do
            VAR_NAME=$(echo "$ENV_VAR" | cut -d= -f1)
            if ! grep -q "^export $VAR_NAME=" "$ENV_FILE"; then
                echo "export $ENV_VAR" >> "$ENV_FILE"
            fi
        done
    fi
done

# Final steps and verification
echo -e "${BLUE}Verifying installation...${NC}"

# Check if critical files exist
MISSING_FILES=0
CRITICAL_FILES=(
    "$HYPR_DIR/hyprland.conf"
    "$WAYBAR_DIR/config-top.jsonc"
    "$WAYBAR_DIR/config-bottom.jsonc"
    "$WAYBAR_DIR/style.css"
    "$ROFI_DIR/config.rasi"
    "$KITTY_DIR/kitty.conf"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: Critical file $file is missing!${NC}"
        MISSING_FILES=$((MISSING_FILES+1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo -e "${RED}Warning: $MISSING_FILES critical files are missing.${NC}"
    echo -e "${RED}The installation may not work correctly.${NC}"
else
    echo -e "${GREEN}All critical files are present.${NC}"
fi

# Run test script if available
if [ -f "$SCRIPT_DIR/scripts/test-all.sh" ]; then
    echo -e "${YELLOW}Running test script...${NC}"
    chmod +x "$SCRIPT_DIR/scripts/test-all.sh"
    "$SCRIPT_DIR/scripts/test-all.sh"
fi

# Installation complete
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}FF6 Hyprland configuration installed successfully!${NC}"
echo -e "${BLUE}=========================================${NC}"
echo
echo -e "${YELLOW}To start Hyprland, log out and select Hyprland from your display manager.${NC}"
echo -e "${YELLOW}Or run 'Hyprland' from a TTY.${NC}"
echo
echo -e "${YELLOW}Press Super+H to view keybindings help.${NC}"
echo -e "${YELLOW}Press Super+Q to close windows.${NC}"
echo -e "${YELLOW}Press Super+Shift+Q to exit Hyprland.${NC}"
echo
echo -e "${BLUE}Enjoy your FF6-themed Hyprland experience!${NC}"
