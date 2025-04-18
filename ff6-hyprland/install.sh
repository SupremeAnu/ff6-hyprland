#!/bin/bash
# FF6 Hyprland Configuration Auto-Installer
# Created: April 2025
# Credits: Some components adapted from JaKooLit's Hyprland-Dots (https://github.com/JaKooLit/Hyprland-Dots)

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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
WALLUST_DIR="$CONFIG_DIR/wallust"
WLOGOUT_DIR="$CONFIG_DIR/wlogout"

# Backup directory
BACKUP_DIR="$HOME/.config/hypr-ff6-backup-$(date +%Y%m%d%H%M%S)"

# Error tracking
ERROR_LOG="$HOME/ff6-hyprland-install-errors.log"
INSTALL_ERRORS=0
MISSING_FILES=0

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Final Fantasy VI Hyprland Installer   ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to log errors
log_error() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $message" >> "$ERROR_LOG"
    echo -e "${RED}ERROR: $message${NC}"
}

# Function to log warnings
log_warning() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $message" >> "$ERROR_LOG"
    echo -e "${YELLOW}WARNING: $message${NC}"
}

# Function to log info
log_info() {
    local message="$1"
    echo -e "${BLUE}INFO: $message${NC}"
}

# Function to log success
log_success() {
    local message="$1"
    echo -e "${GREEN}SUCCESS: $message${NC}"
}

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        log_success "Detected distribution: $DISTRO"
        return 0
    else
        log_warning "Unable to detect distribution. Assuming Arch Linux."
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
                "wlogout") echo "wlogout" ;;
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
                "wlogout") echo "wlogout" ;;
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
        log_info "Installing $distro_pkg..."
        
        case "$DISTRO" in
            arch|manjaro|endeavouros|garuda)
                if command_exists yay; then
                    yay -S --needed --noconfirm "$distro_pkg" || {
                        log_warning "Failed to install $distro_pkg with yay. Trying pacman..."
                        sudo pacman -S --needed --noconfirm "$distro_pkg" || {
                            log_error "Failed to install $distro_pkg with pacman. Skipping..."
                            return 1
                        }
                    }
                else
                    sudo pacman -S --needed --noconfirm "$distro_pkg" || {
                        log_error "Failed to install $distro_pkg with pacman. Skipping..."
                        return 1
                    }
                fi
                ;;
            debian|ubuntu|pop|linuxmint)
                sudo apt update && sudo apt install -y "$distro_pkg" || {
                    log_error "Failed to install $distro_pkg with apt. Skipping..."
                    return 1
                }
                ;;
            fedora)
                sudo dnf install -y "$distro_pkg" || {
                    log_error "Failed to install $distro_pkg with dnf. Skipping..."
                    return 1
                }
                ;;
            centos|rhel)
                sudo yum install -y "$distro_pkg" || {
                    log_error "Failed to install $distro_pkg with yum. Skipping..."
                    return 1
                }
                ;;
            *)
                log_error "No supported package manager found for $DISTRO. Please install $distro_pkg manually."
                return 1
                ;;
        esac
        log_success "$distro_pkg installed."
    else
        log_success "$distro_pkg is already installed."
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
            log_warning "Both PulseAudio and PipeWire detected. This may cause conflicts."
            log_info "It's recommended to use only one audio system."
            
            read -p "Do you want to use PipeWire and remove PulseAudio? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Removing PulseAudio and configuring PipeWire..."
                
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
                log_success "Audio system configured to use PipeWire."
            else
                log_success "Keeping PulseAudio as the audio system."
                audio_system="pulseaudio"
            fi
        else
            audio_system="pipewire"
        fi
    fi
    
    # If no audio system detected, install PipeWire as default
    if [ -z "$audio_system" ]; then
        log_info "No audio system detected. Installing PipeWire..."
        
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
        log_success "Audio system configured to use PipeWire."
    fi
    
    log_success "Using $audio_system as the audio system."
    return 0
}

# Function to backup existing config
backup_config() {
    if [ -d "$1" ]; then
        local backup_path="$BACKUP_DIR/$(basename "$1")"
        log_info "Backing up $1 to $backup_path"
        mkdir -p "$(dirname "$backup_path")"
        cp -r "$1" "$backup_path"
        log_success "Backup created."
    fi
}

# Function to create directory if it doesn't exist
create_dir() {
    if [ ! -d "$1" ]; then
        log_info "Creating directory $1"
        mkdir -p "$1"
        if [ $? -eq 0 ]; then
            log_success "Directory created."
        else
            log_error "Failed to create directory $1"
            return 1
        fi
    fi
    return 0
}

# Function to install Python packages
install_python_packages() {
    log_info "Installing required Python packages..."
    
    # Check if pip is installed
    if ! command_exists pip && ! command_exists pip3; then
        log_info "pip not found. Installing..."
        install_package "python-pip"
    fi
    
    # Use pip3 if available, otherwise use pip
    local PIP_CMD="pip"
    if command_exists pip3; then
        PIP_CMD="pip3"
    fi
    
    # Install required Python packages
    log_info "Installing Pillow (Python Imaging Library)..."
    $PIP_CMD install --user Pillow || {
        log_warning "Failed to install Pillow with pip. Trying system package..."
        install_package "python-pillow"
    }
    
    log_success "Python packages installed."
}

# Function to install FF6 sound effects
install_sound_effects() {
    log_info "Installing FF6 sound effects..."
    create_dir "$SOUNDS_DIR" || return 1
    
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
        log_info "sox not found. Installing..."
        install_package "sox"
    fi
    
    # Generate sound effects using sox
    log_info "Generating FF6-style sound effects..."
    
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
    sox -n "$SOUNDS_DIR/cancel.wav" synth 0.2 sine 500 fade 0 0.2 0.1
    
    # Check if all sound effects were created
    local MISSING_SOUNDS=0
    for sound in "${SOUND_EFFECTS[@]}"; do
        if [ ! -f "$SOUNDS_DIR/$sound" ]; then
            log_error "Failed to create sound effect: $sound"
            MISSING_SOUNDS=$((MISSING_SOUNDS+1))
        fi
    done
    
    if [ $MISSING_SOUNDS -eq 0 ]; then
        log_success "All FF6 sound effects created."
    else
        log_warning "$MISSING_SOUNDS sound effects could not be created."
    fi
}

# Function to install FF6 sprites
install_ff6_sprites() {
    log_info "Installing FF6 character sprites..."
    create_dir "$SPRITES_DIR" || return 1
    
    # Check if sprites already exist
    if [ -f "$SPRITES_DIR/terra.png" ] && [ -f "$SPRITES_DIR/locke.png" ] && [ -f "$SPRITES_DIR/edgar.png" ]; then
        log_success "FF6 character sprites already exist."
        return 0
    fi
    
    # Check if source sprites exist in upload directory
    if [ -d "/home/ubuntu/upload" ]; then
        log_info "Copying sprites from upload directory..."
        cp -f /home/ubuntu/upload/*.png "$SPRITES_DIR/" 2>/dev/null
        
        # Check if sprites were copied
        if [ -f "$SPRITES_DIR/terra.png" ] || [ -f "$SPRITES_DIR/locke.png" ] || [ -f "$SPRITES_DIR/edgar.png" ]; then
            log_success "FF6 character sprites copied from upload directory."
            return 0
        fi
    fi
    
    # If sprites don't exist, create a script to generate them
    log_info "Creating sprite generation script..."
    local SPRITE_SCRIPT="$KITTY_DIR/ff_sprite.py"
    
    cat > "$SPRITE_SCRIPT" << 'EOF'
#!/usr/bin/env python3
"""
FF6 Character Sprite Display for Kitty Terminal
This script displays FF6 character sprites in the kitty terminal.
"""

import os
import sys
import random
from pathlib import Path

# Try to import Pillow for image processing
try:
    from PIL import Image
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

# Check if running in kitty terminal
def is_kitty():
    return 'KITTY_WINDOW_ID' in os.environ

# Function to display image in kitty terminal
def display_image_kitty(image_path):
    if not os.path.exists(image_path):
        return False
    
    # Use kitty's icat command to display the image
    os.system(f"kitty +kitten icat --align left {image_path}")
    return True

# ASCII art fallbacks for characters
ASCII_SPRITES = {
    "terra": """
    /\\//\\
   ( o.o )
    > ^ <
    /   \\
    """,
    "locke": """
    /^^^^\\
   ( o  o )
    \\ -- /
     |  |
    """,
    "edgar": """
    /====\\
   ( ^  ^ )
    \\ -- /
     |__|
    """,
    "celes": """
    /~~~~\\
   ( o  o )
    \\ -- /
     \\__/
    """,
    "setzer": """
    /----\\
   ( -  - )
    \\ -- /
     |__|
    """
}

def main():
    # Define paths to look for sprites
    home = str(Path.home())
    sprite_paths = [
        f"{home}/.config/sprites",
        f"{home}/.config/kitty/sprites",
        "/home/ubuntu/upload",
        "/home/ubuntu/hyprland-crimson-config/sprites"
    ]
    
    # List of character names
    characters = ["terra", "locke", "edgar", "celes", "setzer"]
    
    # Select a random character
    character = random.choice(characters)
    
    # Try to display image if in kitty terminal
    if is_kitty():
        # Try to find the sprite image
        for sprite_dir in sprite_paths:
            for ext in [".png", ".jpg", ".jpeg"]:
                sprite_path = f"{sprite_dir}/{character}{ext}"
                if os.path.exists(sprite_path):
                    if display_image_kitty(sprite_path):
                        print(f"\n\n{character.capitalize()} joins your party!\n")
                        return
        
        # If we get here, no image was found or displayed
        print(f"\n{ASCII_SPRITES[character]}\n{character.capitalize()} joins your party!\n")
    else:
        # Fallback to ASCII art
        print(f"\n{ASCII_SPRITES[character]}\n{character.capitalize()} joins your party!\n")

if __name__ == "__main__":
    main()
EOF
        
    # Make the script executable
    chmod +x "$SPRITE_SCRIPT"
    
    # Run the script to generate sprites
    log_info "Generating FF6 character sprites..."
    python3 "$SPRITE_SCRIPT"
    
    log_success "FF6 character sprites created."
}

# Function to install FF6 cursor theme
install_ff6_cursor() {
    log_info "Installing FF6 Ultima Weapon cursor theme..."
    
    # Create cursor directories
    local CURSOR_THEME_DIR="$CURSOR_DIR/UltimaWeapon"
    create_dir "$CURSOR_THEME_DIR/cursors" || return 1
    
    # Check if ImageMagick is installed
    if ! command_exists convert; then
        log_info "ImageMagick not found. Installing..."
        install_package "imagemagick"
    fi
    
    # Check if xcursorgen is installed
    if ! command_exists xcursorgen; then
        log_info "xcursorgen not found. Installing..."
        install_package "xorg-xcursorgen"
    fi
    
    # Check if source image exists
    local SOURCE_IMAGE=""
    if [ -f "/home/ubuntu/upload/Ultima_Weapon_2_-_FF6.png" ]; then
        SOURCE_IMAGE="/home/ubuntu/upload/Ultima_Weapon_2_-_FF6.png"
        log_info "Using Ultima Weapon image from upload directory."
    elif [ -f "/home/ubuntu/upload/FF6Cursor.png" ]; then
        SOURCE_IMAGE="/home/ubuntu/upload/FF6Cursor.png"
        log_info "Using FF6Cursor image from upload directory."
    fi
    
    # Create a script to generate the cursor
    local CURSOR_SCRIPT="$CURSOR_THEME_DIR/generate_cursor.sh"
    cat > "$CURSOR_SCRIPT" << EOF
#!/bin/bash
# Generate FF6 Ultima Weapon cursor

# Set directories
THEME_DIR="$1"
CURSORS_DIR="\$THEME_DIR/cursors"
TEMP_DIR="\$THEME_DIR/temp"

# Create temporary directory
mkdir -p "\$TEMP_DIR"

# Create cursor config file
cat > "\$TEMP_DIR/cursor.in" << EOC
24 12 12 left_ptr.png
EOC

# Create the cursor image
if [ -n "$SOURCE_IMAGE" ]; then
    # Use the source image if available
    convert "$SOURCE_IMAGE" -resize 24x24 -background none "\$TEMP_DIR/left_ptr.png"
else
    # Create a simple sword cursor using ImageMagick
    convert -size 24x24 xc:transparent -fill none -stroke blue -strokewidth 1 \\
        -draw "line 6,6 18,18 line 18,18 6,18 line 6,18 12,12" \\
        -fill gold -draw "circle 12,12 12,14" \\
        "\$TEMP_DIR/left_ptr.png"
fi

# Generate the cursor
xcursorgen "\$TEMP_DIR/cursor.in" "\$CURSORS_DIR/left_ptr"

# Create symlinks for all cursor types
cd "\$CURSORS_DIR"
for CURSOR in arrow default top_left_arrow; do
    ln -sf left_ptr "\$CURSOR"
done

# Additional cursor types
for CURSOR in bottom_left_corner bottom_right_corner bottom_side left_side right_side top_left_corner top_right_corner top_side; do
    ln -sf left_ptr "\$CURSOR"
done

for CURSOR in center_ptr context-menu copy crosshair fleur help move pointer progress text vertical-text wait; do
    ln -sf left_ptr "\$CURSOR"
done

for CURSOR in all-scroll col-resize e-resize n-resize ne-resize nw-resize row-resize s-resize se-resize sw-resize w-resize; do
    ln -sf left_ptr "\$CURSOR"
done

# Clean up
rm -rf "\$TEMP_DIR"

echo "FF6 Ultima Weapon cursor theme created successfully!"
EOF
    
    # Make the script executable
    chmod +x "$CURSOR_SCRIPT"
    
    # Run the script to generate the cursor
    log_info "Generating FF6 Ultima Weapon cursor..."
    bash "$CURSOR_SCRIPT" "$CURSOR_THEME_DIR"
    
    # Create index.theme file
    cat > "$CURSOR_THEME_DIR/index.theme" << EOF
[Icon Theme]
Name=UltimaWeapon
Comment=FF6 Ultima Weapon Cursor Theme
Inherits=Adwaita
EOF
    
    log_success "FF6 Ultima Weapon cursor theme installed."
}

# Function to fix rofi, wallust, and wlogout configurations
fix_configurations() {
    log_info "Fixing FF6-themed configurations for rofi, wallust, and wlogout..."
    
    # Fix rofi configuration
    log_info "Fixing rofi configuration..."
    create_dir "$ROFI_DIR/themes" || return 1
    
    # Copy rofi configuration files
    cp -f /home/ubuntu/hyprland-crimson-config/rofi/config.rasi "$ROFI_DIR/"
    cp -f /home/ubuntu/hyprland-crimson-config/rofi/shared-fonts.rasi "$ROFI_DIR/"
    cp -f /home/ubuntu/hyprland-crimson-config/rofi/ff6.rasi "$ROFI_DIR/"
    cp -f /home/ubuntu/hyprland-crimson-config/rofi/ff6-theme.rasi "$ROFI_DIR/" 2>/dev/null
    cp -f /home/ubuntu/hyprland-crimson-config/rofi/themes/ff6-menu.rasi "$ROFI_DIR/themes/"
    
    # Check if files were copied
    if [ -f "$ROFI_DIR/config.rasi" ] && [ -f "$ROFI_DIR/themes/ff6-menu.rasi" ]; then
        log_success "Rofi configuration fixed."
    else
        log_error "Failed to fix rofi configuration."
        return 1
    fi
    
    # Fix wallust configuration
    log_info "Fixing wallust configuration..."
    create_dir "$WALLUST_DIR/templates" || return 1
    
    # Copy wallust configuration files
    cp -f /home/ubuntu/hyprland-crimson-config/wallust/wallust.toml "$WALLUST_DIR/"
    cp -rf /home/ubuntu/hyprland-crimson-config/wallust/templates/* "$WALLUST_DIR/templates/"
    
    # Create FF6-themed color templates for wallust
    cat > "$WALLUST_DIR/templates/colors-hyprland.conf" << EOF
$color0 = rgb(0a1a3f)
$color1 = rgb(1a2a5f)
$color2 = rgb(3a4a8f)
$color3 = rgb(4a5aaf)
$color4 = rgb(5a6acf)
$color5 = rgb(6a7aef)
$color6 = rgb(8a9aff)
$color7 = rgb(ffffff)
$color8 = rgb(d0d0ff)
$color9 = rgb(ffff80)
$color10 = rgb(00ffff)
$color11 = rgb(ff8080)
$color12 = rgb(80ff80)
$color13 = rgb(ff80ff)
$color14 = rgb(80ffff)
$color15 = rgb(ffffff)
EOF
    
    # Check if files were created
    if [ -f "$WALLUST_DIR/wallust.toml" ] && [ -f "$WALLUST_DIR/templates/colors-hyprland.conf" ]; then
        log_success "Wallust configuration fixed."
    else
        log_error "Failed to fix wallust configuration."
        return 1
    fi
    
    # Fix wlogout configuration
    log_info "Fixing wlogout configuration..."
    create_dir "$WLOGOUT_DIR" || return 1
    
    # Copy wlogout configuration files
    cp -f /home/ubuntu/hyprland-crimson-config/wlogout/style.css "$WLOGOUT_DIR/"
    cp -f /home/ubuntu/hyprland-crimson-config/wlogout/layout "$WLOGOUT_DIR/"
    
    # Check if files were copied
    if [ -f "$WLOGOUT_DIR/style.css" ] && [ -f "$WLOGOUT_DIR/layout" ]; then
        log_success "Wlogout configuration fixed."
    else
        log_error "Failed to fix wlogout configuration."
        return 1
    fi
    
    # Create a script to apply wallust colors
    log_info "Creating wallust application script..."
    create_dir "$HYPR_DIR/scripts" || return 1
    
    cat > "$HYPR_DIR/scripts/apply-wallust.sh" << EOF
#!/bin/bash
# Apply wallust colors to all components

# Generate colors from wallpaper
wallust -g $HYPR_DIR/wallpapers/ff6-gradient.png

# Apply colors to Hyprland
if [ -f ~/.config/hypr/wallust/wallust-hyprland.conf ]; then
    echo "source = ~/.config/hypr/wallust/wallust-hyprland.conf" > ~/.config/hypr/colors.conf
fi

# Restart waybar to apply new colors
killall waybar
~/.config/hypr/scripts/launch-waybar.sh &
EOF
    
    chmod +x "$HYPR_DIR/scripts/apply-wallust.sh"
    
    # Create FF6 gradient wallpaper if it doesn't exist
    log_info "Creating FF6 gradient wallpaper..."
    create_dir "$HYPR_DIR/wallpapers" || return 1
    
    if [ ! -f "$HYPR_DIR/wallpapers/ff6-gradient.png" ]; then
        # Create a simple gradient wallpaper using convert (ImageMagick)
        if command_exists convert; then
            convert -size 1920x1080 gradient:'#0a1a3f-#3a4a8f' "$HYPR_DIR/wallpapers/ff6-gradient.png"
            log_success "Created FF6 gradient wallpaper."
        else
            log_warning "ImageMagick not found, cannot create gradient wallpaper."
            log_info "Please install ImageMagick or create a gradient wallpaper manually."
        fi
    fi
    
    log_success "FF6-themed configurations fixed successfully!"
    return 0
}

# Function to fix terminal configuration
fix_terminal_configuration() {
    log_info "Fixing terminal configuration..."
    
    # Create necessary directories
    create_dir "$KITTY_DIR" || return 1
    create_dir "$KITTY_DIR/sprites" || return 1
    
    # Copy kitty configuration files
    cp -f /home/ubuntu/hyprland-crimson-config/kitty/kitty.conf "$KITTY_DIR/"
    cp -f /home/ubuntu/hyprland-crimson-config/kitty/ff_sprite.py "$KITTY_DIR/"
    chmod +x "$KITTY_DIR/ff_sprite.py"
    
    # Copy character sprites if available
    if [ -d "/home/ubuntu/upload" ]; then
        cp -f /home/ubuntu/upload/*.png "$KITTY_DIR/sprites/" 2>/dev/null
        log_success "Copied character sprite images."
    else
        log_warning "Character sprite images not found in /home/ubuntu/upload/"
        log_info "Creating symbolic links to default locations..."
        
        # Create symbolic links to default locations if they exist
        for char in terra locke edgar celes setzer; do
            if [ -f "/home/ubuntu/hyprland-crimson-config/sprites/${char}.png" ]; then
                ln -sf "/home/ubuntu/hyprland-crimson-config/sprites/${char}.png" "$KITTY_DIR/sprites/"
            fi
        done
    fi
    
    # Create a kitty startup script
    cat > "$KITTY_DIR/startup.sh" << EOF
#!/bin/bash
# Kitty startup script for FF6 theme
python3 ~/.config/kitty/ff_sprite.py
EOF
    
    chmod +x "$KITTY_DIR/startup.sh"
    
    # Create a zsh theme file if zsh is installed
    if command_exists zsh; then
        create_dir "$HOME/.oh-my-zsh/custom/themes" || true
        cat > "$HOME/.oh-my-zsh/custom/themes/ff6.zsh-theme" << EOF
# FF6-themed ZSH prompt
# Based on the Final Fantasy VI menu system

# Colors
local blue="%{$fg[blue]%}"
local cyan="%{$fg[cyan]%}"
local green="%{$fg[green]%}"
local red="%{$fg[red]%}"
local yellow="%{$fg[yellow]%}"
local white="%{$fg[white]%}"
local reset="%{$reset_color%}"

# Git status
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${yellow}("
ZSH_THEME_GIT_PROMPT_SUFFIX="${yellow})${reset}"
ZSH_THEME_GIT_PROMPT_DIRTY="${red}*${reset}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Prompt components
local user_host="${cyan}%n${white}@${green}%m${reset}"
local current_dir="${blue}%~${reset}"
local return_code="%(?..${red}%? ↵${reset})"

# Main prompt
PROMPT="${white}╭─${reset}${user_host} ${current_dir} ${git_info}
${white}╰─${reset}${cyan}❯${reset} "
RPROMPT="${return_code}"

# Display FF6 character on terminal start
precmd() {
    if [ -f ~/.config/kitty/ff_sprite.py ]; then
        if [ -z "$FF6_SPRITE_SHOWN" ]; then
            python3 ~/.config/kitty/ff_sprite.py
            export FF6_SPRITE_SHOWN=1
        fi
    fi
}
EOF
        log_success "Created FF6-themed ZSH prompt."
    fi
    
    log_success "Terminal configuration fixed."
    return 0
}

# Function to verify installation
verify_installation() {
    log_info "Verifying installation..."
    MISSING_FILES=0
    
    # Check critical files
    CRITICAL_FILES=(
        "$HYPR_DIR/hyprland.conf"
        "$WAYBAR_DIR/config.jsonc"
        "$WAYBAR_DIR/style.css"
        "$KITTY_DIR/kitty.conf"
        "$KITTY_DIR/ff_sprite.py"
        "$ROFI_DIR/config.rasi"
        "$ROFI_DIR/themes/ff6-menu.rasi"
        "$WLOGOUT_DIR/style.css"
        "$WLOGOUT_DIR/layout"
    )
    
    for file in "${CRITICAL_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            log_error "Critical file $file is missing!"
            MISSING_FILES=$((MISSING_FILES+1))
        fi
    done
    
    if [ $MISSING_FILES -eq 0 ]; then
        log_success "All critical files are present."
        return 0
    else
        log_error "$MISSING_FILES critical files are missing. Installation may be incomplete."
        return 1
    fi
}

# Detect distribution
detect_distro

# Check if yay is installed, install if not (Arch Linux only)
if [[ "$DISTRO" == "arch" || "$DISTRO" == "manjaro" || "$DISTRO" == "endeavouros" || "$DISTRO" == "garuda" ]] && ! command_exists yay; then
    log_info "Yay (AUR helper) not found. Installing..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd - > /dev/null
    log_success "Yay installed."
fi

# Ask for confirmation before proceeding
echo -e "${YELLOW}This script will install the FF6-themed Hyprland configuration.${NC}"
echo -e "${YELLOW}It will backup your existing configurations to $BACKUP_DIR${NC}"
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_error "Installation aborted by user."
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Check for audio conflicts
check_audio_conflicts

# Install required packages
log_info "Installing required packages..."
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
    "wlogout"
    
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
    log_warning "$INSTALL_ERRORS packages could not be installed. Some features may not work correctly."
    read -p "Do you want to continue with the installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Installation aborted by user."
        exit 1
    fi
fi

# Install Python packages
install_python_packages

# Install fonts if not already installed
log_info "Checking fonts..."
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
    log_info "Updating font cache..."
    fc-cache -f
    log_success "Font cache updated."
fi

# Backup existing configurations
log_info "Backing up existing configurations..."
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
backup_config "$WALLUST_DIR"
backup_config "$WLOGOUT_DIR"

# Create necessary directories
log_info "Creating configuration directories..."
create_dir "$HYPR_DIR"
create_dir "$WAYBAR_DIR"
create_dir "$WAYBAR_DIR/modules"
create_dir "$ROFI_DIR"
create_dir "$ROFI_DIR/themes"
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
create_dir "$WALLUST_DIR"
create_dir "$WALLUST_DIR/templates"
create_dir "$WLOGOUT_DIR"

# Install FF6 sound effects
install_sound_effects

# Install FF6 sprites
install_ff6_sprites

# Install FF6 cursor theme
install_ff6_cursor

# Fix configurations
fix_configurations

# Fix terminal configuration
fix_terminal_configuration

# Copy configuration files
log_info "Copying configuration files..."

# Copy Hyprland configuration files
log_info "Copying Hyprland configuration files..."
cp -r /home/ubuntu/hyprland-crimson-config/hypr/* "$HYPR_DIR/"

# Copy Waybar configuration files
log_info "Copying Waybar configuration files..."
cp -r /home/ubuntu/hyprland-crimson-config/waybar/* "$WAYBAR_DIR/"

# Copy Kitty configuration files
log_info "Copying Kitty configuration files..."
cp -r /home/ubuntu/hyprland-crimson-config/kitty/* "$KITTY_DIR/"

# Copy AGS configuration files
log_info "Copying AGS configuration files..."
cp -r /home/ubuntu/hyprland-crimson-config/ags/* "$AGS_DIR/"

# Copy XDG portal configuration files
log_info "Copying XDG portal configuration files..."
cp -r /home/ubuntu/hyprland-crimson-config/xdg/* "$XDG_DIR/"

# Copy Swappy configuration files
log_info "Copying Swappy configuration files..."
cp -r /home/ubuntu/hyprland-crimson-config/swappy/* "$SWAPPY_DIR/"

# Copy Swaync configuration files
log_info "Copying Swaync configuration files..."
cp -r /home/ubuntu/hyprland-crimson-config/swaync/* "$SWAYNC_DIR/"

# Make scripts executable
log_info "Making scripts executable..."
find "$HYPR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$WAYBAR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$KITTY_DIR" -type f -name "*.py" -exec chmod +x {} \;
find "$AGS_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;

# Set up autostart for Hyprland
log_info "Setting up autostart for Hyprland..."
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
log_info "Setting up environment variables..."
ENV_FILE="$HOME/.profile"

# Check if .profile exists, create if not
if [ ! -f "$ENV_FILE" ]; then
    touch "$ENV_FILE"
fi

# Add environment variables if not already present
if ! grep -q "HYPRLAND_FF6_THEME" "$ENV_FILE"; then
    log_info "Adding environment variables to $ENV_FILE..."
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
export XCURSOR_THEME=UltimaWeapon
export XCURSOR_SIZE=24
EOF
    log_success "Environment variables added."
fi

# Verify installation
verify_installation

# Final message
echo -e "${BLUE}=========================================${NC}"
if [ $MISSING_FILES -eq 0 ] && [ $INSTALL_ERRORS -eq 0 ]; then
    log_success "FF6-themed Hyprland configuration installed successfully!"
    log_success "You can now start Hyprland by typing 'Hyprland' in a TTY session."
    log_success "Or log out and select Hyprland from your display manager."
elif [ $MISSING_FILES -eq 0 ] && [ $INSTALL_ERRORS -gt 0 ]; then
    log_warning "FF6-themed Hyprland configuration installed with warnings."
    log_warning "Some packages could not be installed. Some features may not work correctly."
    log_warning "You can try installing the missing packages manually."
    log_info "Check the error log at $ERROR_LOG for details."
else
    log_error "FF6-themed Hyprland configuration installation incomplete."
    log_error "Please check the error log at $ERROR_LOG and try again."
fi
echo -e "${BLUE}=========================================${NC}"

# Play confirmation sound if available
if [ -f "$SOUNDS_DIR/confirm.wav" ] && command_exists paplay; then
    paplay "$SOUNDS_DIR/confirm.wav"
fi

exit 0
