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
AGS_DIR="$CONFIG_DIR/ags"
XDG_DIR="$CONFIG_DIR/xdg-desktop-portal"
SOUNDS_DIR="$HYPR_DIR/sounds"
SPRITES_DIR="$CONFIG_DIR/sprites"

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
                "hypridle") echo "hypridle" ;;
                "ags") echo "aylurs-gtk-shell" ;;
                "papirus-icon-theme") echo "papirus-icon-theme" ;;
                "ttf-jetbrains-mono-nerd") echo "fonts-jetbrains-mono" ;;
                "ttf-victor-mono") echo "fonts-victor-mono" ;;
                "ttf-fantasque-sans-mono") echo "fonts-fantasque-sans" ;;
                "polkit-kde-agent") echo "polkit-kde-agent-1" ;;
                "python") echo "python3" ;;
                "python-pip") echo "python3-pip" ;;
                "python-pillow") echo "python3-pil" ;;
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
                "brightnessctl") echo "brightnessctl" ;;
                "pamixer") echo "pamixer" ;;
                "nodejs") echo "nodejs" ;;
                "npm") echo "npm" ;;
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
                "hypridle") echo "hypridle" ;;
                "ags") echo "aylurs-gtk-shell" ;;
                "papirus-icon-theme") echo "papirus-icon-theme" ;;
                "ttf-jetbrains-mono-nerd") echo "jetbrains-mono-fonts-all" ;;
                "ttf-victor-mono") echo "victor-mono-fonts" ;;
                "ttf-fantasque-sans-mono") echo "fantasque-sans-mono-fonts" ;;
                "polkit-kde-agent") echo "polkit-kde-authentication-agent-1" ;;
                "python") echo "python3" ;;
                "python-pip") echo "python3-pip" ;;
                "python-pillow") echo "python3-pillow" ;;
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
                "brightnessctl") echo "brightnessctl" ;;
                "pamixer") echo "pamixer" ;;
                "nodejs") echo "nodejs" ;;
                "npm") echo "npm" ;;
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

# Function to install Python packages
install_python_packages() {
    echo -e "${BLUE}Installing required Python packages...${NC}"
    
    # Check if pip is installed
    if ! command_exists pip && ! command_exists pip3; then
        echo -e "${YELLOW}pip not found. Installing...${NC}"
        install_package "python-pip"
    fi
    
    # Use pip3 if available, otherwise use pip
    local PIP_CMD="pip"
    if command_exists pip3; then
        PIP_CMD="pip3"
    fi
    
    # Install required Python packages
    echo -e "${YELLOW}Installing Pillow (Python Imaging Library)...${NC}"
    $PIP_CMD install --user Pillow || {
        echo -e "${YELLOW}Warning: Failed to install Pillow with pip. Trying system package...${NC}"
        install_package "python-pillow"
    }
    
    echo -e "${GREEN}Python packages installed.${NC}"
}

# Function to install FF6 sound effects
install_sound_effects() {
    echo -e "${BLUE}Installing FF6 sound effects...${NC}"
    create_dir "$SOUNDS_DIR"
    
    # Define sound effects
    local SOUND_EFFECTS=(
        "cursor_move.wav"
        "menu_open.wav"
        "menu_close.wav"
        "menu_select.wav"
        "confirm.wav"
        "cancel.wav"
    )
    
    # Check if sox is installed for sound generation
    if ! command_exists sox; then
        echo -e "${YELLOW}sox not found. Installing...${NC}"
        install_package "sox"
    fi
    
    # Generate sound effects using sox
    echo -e "${YELLOW}Generating FF6-style sound effects...${NC}"
    
    # Cursor move sound (short beep)
    sox -n "$SOUNDS_DIR/cursor_move.wav" synth 0.1 sine 1000 fade 0 0.1 0.05
    
    # Menu open sound (ascending tones)
    sox -n "$SOUNDS_DIR/menu_open.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
    
    # Menu close sound (descending tones)
    sox -n "$SOUNDS_DIR/menu_close.wav" synth 0.15 sine 1200:800 fade 0 0.15 0.05
    
    # Menu select sound (two-tone beep)
    sox -n "$SOUNDS_DIR/menu_select.wav" synth 0.1 sine 1200 synth 0.1 sine 1600 fade 0 0.2 0.05
    
    # Confirm sound (happy chime)
    sox -n "$SOUNDS_DIR/confirm.wav" synth 0.1 sine 1000 synth 0.1 sine 1200 synth 0.1 sine 1500 fade 0 0.3 0.1
    
    # Cancel sound (error beep)
    sox -n "$SOUNDS_DIR/cancel.wav" synth 0.2 sine 800:400 fade 0 0.2 0.05
    
    echo -e "${GREEN}Sound effects installed.${NC}"
}

# Function to install FF6 sprites
install_ff6_sprites() {
    echo -e "${BLUE}Installing FF6 character sprites...${NC}"
    create_dir "$SPRITES_DIR"
    
    # Check if the sprites directory is empty
    if [ -z "$(ls -A "$SPRITES_DIR" 2>/dev/null)" ]; then
        echo -e "${YELLOW}No sprites found. Creating default FF6 sprites...${NC}"
        
        # Check if Python and Pillow are installed
        if ! command_exists python && ! command_exists python3; then
            echo -e "${YELLOW}Python not found. Installing...${NC}"
            install_package "python"
        fi
        
        # Install Pillow if not already installed
        install_python_packages
        
        # Create a simple script to generate placeholder sprites
        local SPRITE_SCRIPT="$SPRITES_DIR/generate_sprites.py"
        cat > "$SPRITE_SCRIPT" << 'EOF'
#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os

# Define character colors
CHARACTERS = {
    "terra": {"hair": (0, 255, 128), "skin": (255, 200, 150), "outfit": (255, 0, 0)},
    "locke": {"hair": (200, 200, 100), "skin": (255, 200, 150), "outfit": (0, 0, 255)},
    "edgar": {"hair": (255, 255, 0), "skin": (255, 200, 150), "outfit": (0, 0, 200)},
    "sabin": {"hair": (255, 255, 0), "skin": (255, 200, 150), "outfit": (150, 100, 0)},
    "celes": {"hair": (255, 255, 150), "skin": (255, 200, 150), "outfit": (0, 100, 255)},
    "setzer": {"hair": (200, 200, 200), "skin": (255, 200, 150), "outfit": (100, 0, 100)},
    "shadow": {"hair": (50, 50, 50), "skin": (255, 200, 150), "outfit": (0, 0, 0)},
    "cyan": {"hair": (0, 0, 100), "skin": (255, 200, 150), "outfit": (100, 0, 0)},
    "gau": {"hair": (150, 150, 0), "skin": (255, 200, 150), "outfit": (0, 150, 0)},
    "mog": {"hair": (255, 255, 255), "skin": (255, 200, 255), "outfit": (255, 100, 200)},
}

# Create sprites directory
sprites_dir = os.path.dirname(os.path.abspath(__file__))

# Generate simple pixel art sprites for each character
for name, colors in CHARACTERS.items():
    # Create a 24x32 pixel image (typical FF sprite size)
    img = Image.new('RGBA', (24, 32), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw a simple character silhouette
    # Head
    draw.rectangle([(8, 2), (16, 10)], fill=colors["skin"], outline=(0, 0, 0))
    # Hair
    draw.rectangle([(7, 1), (17, 5)], fill=colors["hair"], outline=(0, 0, 0))
    # Body
    draw.rectangle([(7, 11), (17, 24)], fill=colors["outfit"], outline=(0, 0, 0))
    # Arms
    draw.rectangle([(5, 12), (7, 20)], fill=colors["skin"], outline=(0, 0, 0))
    draw.rectangle([(17, 12), (19, 20)], fill=colors["skin"], outline=(0, 0, 0))
    # Legs
    draw.rectangle([(8, 25), (11, 31)], fill=colors["outfit"], outline=(0, 0, 0))
    draw.rectangle([(13, 25), (16, 31)], fill=colors["outfit"], outline=(0, 0, 0))
    
    # Save the sprite
    img.save(os.path.join(sprites_dir, f"{name}.png"))
    print(f"Created sprite for {name}")

print("All sprites generated successfully!")
EOF
        
        # Make the script executable
        chmod +x "$SPRITE_SCRIPT"
        
        # Run the script to generate sprites
        echo -e "${YELLOW}Generating FF6 character sprites...${NC}"
        python3 "$SPRITE_SCRIPT"
        
        echo -e "${GREEN}FF6 character sprites created.${NC}"
    else
        echo -e "${GREEN}FF6 character sprites already exist.${NC}"
    fi
}

# Function to install FF6 cursor theme
install_ff6_cursor() {
    echo -e "${BLUE}Installing FF6 Atma Weapon cursor theme...${NC}"
    
    # Create cursor directories
    local CURSOR_THEME_DIR="$CURSOR_DIR/AtmaWeapon"
    create_dir "$CURSOR_THEME_DIR/cursors"
    
    # Check if ImageMagick is installed
    if ! command_exists convert; then
        echo -e "${YELLOW}ImageMagick not found. Installing...${NC}"
        install_package "imagemagick"
    fi
    
    # Check if xcursorgen is installed
    if ! command_exists xcursorgen; then
        echo -e "${YELLOW}xcursorgen not found. Installing...${NC}"
        install_package "xorg-xcursorgen"
    fi
    
    # Create a simple script to generate the cursor
    local CURSOR_SCRIPT="$CURSOR_THEME_DIR/generate_cursor.sh"
    cat > "$CURSOR_SCRIPT" << 'EOF'
#!/bin/bash
# Generate FF6 Atma Weapon cursor

# Set directories
THEME_DIR="$1"
CURSORS_DIR="$THEME_DIR/cursors"
TEMP_DIR="$THEME_DIR/temp"

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Create cursor config file
cat > "$TEMP_DIR/cursor.in" << EOC
24 12 12 left_ptr.png
EOC

# Create a simple sword cursor using ImageMagick
convert -size 24x24 xc:transparent -fill none -stroke blue -strokewidth 1 \
    -draw "line 6,6 18,18 line 18,18 6,18 line 6,18 12,12" \
    -fill gold -draw "circle 12,12 12,14" \
    "$TEMP_DIR/left_ptr.png"

# Generate the cursor
xcursorgen "$TEMP_DIR/cursor.in" "$CURSORS_DIR/left_ptr"

# Create symlinks for all cursor types
cd "$CURSORS_DIR"
for CURSOR in arrow default top_left_arrow; do
    ln -sf left_ptr "$CURSOR"
done

# Clean up
rm -rf "$TEMP_DIR"

echo "FF6 Atma Weapon cursor theme created successfully!"
EOF
    
    # Make the script executable
    chmod +x "$CURSOR_SCRIPT"
    
    # Run the script to generate the cursor
    echo -e "${YELLOW}Generating FF6 Atma Weapon cursor...${NC}"
    bash "$CURSOR_SCRIPT" "$CURSOR_THEME_DIR"
    
    # Create index.theme file
    cat > "$CURSOR_THEME_DIR/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6 Atma Weapon Cursor Theme
Inherits=Adwaita
EOF
    
    echo -e "${GREEN}FF6 Atma Weapon cursor theme installed.${NC}"
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
    # Core Hyprland packages
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
    
    # Lock screen and idle management
    "hyprlock"
    "hypridle"
    
    # Desktop portal
    "xdg-desktop-portal-hyprland"
    "xdg-utils"
    
    # AGS (Aylur's GTK Shell)
    "ags"
    "nodejs"
    "npm"
    
    # Themes and appearance
    "gtk3"
    "qt5ct"
    "qt6ct"
    "papirus-icon-theme"
    
    # Fonts
    "ttf-jetbrains-mono-nerd"
    "ttf-victor-mono"
    "ttf-fantasque-sans-mono"
    
    # System utilities
    "polkit-kde-agent"
    "thunar"
    "python"
    "python-pip"
    "python-pillow"
    "btop"
    "pavucontrol"
    "networkmanager"
    "blueman"
    
    # Media and graphics
    "imagemagick"
    "wl-clipboard"
    "sox"
    
    # Hardware control
    "brightnessctl"
    "pamixer"
    
    # Miscellaneous utilities
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

# Install Python packages
install_python_packages

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
backup_config "$AGS_DIR"
backup_config "$XDG_DIR"

# Create necessary directories
echo -e "${BLUE}Creating configuration directories...${NC}"
create_dir "$HYPR_DIR"
create_dir "$WAYBAR_DIR"
create_dir "$WAYBAR_DIR/modules"
create_dir "$ROFI_DIR"
create_dir "$KITTY_DIR"
create_dir "$SWAPPY_DIR"
create_dir "$SWAYNC_DIR"
create_dir "$KVANTUM_DIR"
create_dir "$GTK_DIR"
create_dir "$QT5CT_DIR"
create_dir "$QT6CT_DIR"
create_dir "$THUNAR_DIR"
create_dir "$AGS_DIR"
create_dir "$AGS_DIR/modules"
create_dir "$AGS_DIR/user"
create_dir "$XDG_DIR"
create_dir "$HYPR_DIR/themes"
create_dir "$HYPR_DIR/wallpapers"
create_dir "$HYPR_DIR/scripts"
create_dir "$HYPR_DIR/sounds"
create_dir "$SPRITES_DIR"

# Install FF6 sound effects
install_sound_effects

# Install FF6 sprites
install_ff6_sprites

# Install FF6 cursor theme
install_ff6_cursor

# Copy configuration files
echo -e "${BLUE}Copying configuration files...${NC}"

# Copy Hyprland configuration files
echo -e "${YELLOW}Copying Hyprland configuration files...${NC}"
cp -r hypr/* "$HYPR_DIR/"

# Copy Waybar configuration files
echo -e "${YELLOW}Copying Waybar configuration files...${NC}"
cp -r waybar/* "$WAYBAR_DIR/"

# Copy Kitty configuration files
echo -e "${YELLOW}Copying Kitty configuration files...${NC}"
cp -r kitty/* "$KITTY_DIR/"

# Copy AGS configuration files
echo -e "${YELLOW}Copying AGS configuration files...${NC}"
cp -r ags/* "$AGS_DIR/"

# Copy XDG portal configuration files
echo -e "${YELLOW}Copying XDG portal configuration files...${NC}"
cp -r xdg/* "$XDG_DIR/"

# Make scripts executable
echo -e "${BLUE}Making scripts executable...${NC}"
find "$HYPR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$WAYBAR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$KITTY_DIR" -type f -name "*.py" -exec chmod +x {} \;
find "$AGS_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;

# Set up autostart for Hyprland
echo -e "${BLUE}Setting up autostart for Hyprland...${NC}"
create_dir "$HOME/.config/autostart"

# Create desktop entry for Hyprland
cat > "$HOME/.config/autostart/hyprland.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Hyprland
Exec=Hyprland
Terminal=false
Categories=System;
EOF

# Set up environment variables
echo -e "${BLUE}Setting up environment variables...${NC}"
ENV_FILE="$HOME/.profile"

# Check if .profile exists, create if not
if [ ! -f "$ENV_FILE" ]; then
    touch "$ENV_FILE"
fi

# Add environment variables if not already present
if ! grep -q "HYPRLAND_FF6_THEME" "$ENV_FILE"; then
    echo -e "${YELLOW}Adding environment variables to $ENV_FILE...${NC}"
    cat >> "$ENV_FILE" << EOF

# Hyprland FF6 Theme environment variables
export HYPRLAND_FF6_THEME=1
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland,x11
export MOZ_ENABLE_WAYLAND=1
export XCURSOR_THEME=AtmaWeapon
export XCURSOR_SIZE=24
EOF
    echo -e "${GREEN}Environment variables added.${NC}"
fi

# Final setup and verification
echo -e "${BLUE}Performing final setup and verification...${NC}"

# Verify all required files are present
echo -e "${YELLOW}Verifying installation...${NC}"
MISSING_FILES=0

# Check critical files
CRITICAL_FILES=(
    "$HYPR_DIR/hyprland.conf"
    "$HYPR_DIR/colors.conf"
    "$HYPR_DIR/animations.conf"
    "$WAYBAR_DIR/config-top.jsonc"
    "$WAYBAR_DIR/config-bottom.jsonc"
    "$WAYBAR_DIR/style.css"
    "$KITTY_DIR/kitty.conf"
    "$KITTY_DIR/ff_sprite.py"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: Critical file $file is missing!${NC}"
        MISSING_FILES=$((MISSING_FILES+1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo -e "${RED}Error: $MISSING_FILES critical files are missing. Installation may be incomplete.${NC}"
    echo -e "${YELLOW}Please check the installation logs and try again.${NC}"
else
    echo -e "${GREEN}All critical files are present.${NC}"
fi

# Final message
echo -e "${BLUE}=========================================${NC}"
if [ $MISSING_FILES -eq 0 ] && [ $INSTALL_ERRORS -eq 0 ]; then
    echo -e "${GREEN}FF6-themed Hyprland configuration installed successfully!${NC}"
    echo -e "${GREEN}You can now start Hyprland by typing 'Hyprland' in a TTY session.${NC}"
    echo -e "${GREEN}Or log out and select Hyprland from your display manager.${NC}"
elif [ $MISSING_FILES -eq 0 ] && [ $INSTALL_ERRORS -gt 0 ]; then
    echo -e "${YELLOW}FF6-themed Hyprland configuration installed with warnings.${NC}"
    echo -e "${YELLOW}Some packages could not be installed. Some features may not work correctly.${NC}"
    echo -e "${YELLOW}You can try installing the missing packages manually.${NC}"
else
    echo -e "${RED}FF6-themed Hyprland configuration installation incomplete.${NC}"
    echo -e "${RED}Please check the installation logs and try again.${NC}"
fi
echo -e "${BLUE}=========================================${NC}"

# Play confirmation sound if available
if [ -f "$SOUNDS_DIR/confirm.wav" ] && command_exists paplay; then
    paplay "$SOUNDS_DIR/confirm.wav"
fi

exit 0
