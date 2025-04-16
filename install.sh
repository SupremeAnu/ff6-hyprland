#!/bin/bash

# FF6 Hyprland Configuration Installer
# This script installs and configures the FF6-themed Hyprland environment

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}=========================================================${NC}"
echo -e "${BLUE}  ███████╗███████╗ ██████╗    ██╗  ██╗██╗   ██╗██████╗  ${NC}"
echo -e "${BLUE}  ██╔════╝██╔════╝██╔════╝    ██║  ██║╚██╗ ██╔╝██╔══██╗ ${NC}"
echo -e "${BLUE}  █████╗  █████╗  ███████╗    ███████║ ╚████╔╝ ██████╔╝ ${NC}"
echo -e "${BLUE}  ██╔══╝  ██╔══╝  ██╔═══██╗   ██╔══██║  ╚██╔╝  ██╔══██╗ ${NC}"
echo -e "${BLUE}  ██║     ██║     ╚██████╔╝██╗██║  ██║   ██║   ██║  ██║ ${NC}"
echo -e "${BLUE}  ╚═╝     ╚═╝      ╚═════╝ ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ${NC}"
echo -e "${BLUE}=========================================================${NC}"
echo -e "${CYAN}  Final Fantasy VI Themed Hyprland Configuration         ${NC}"
echo -e "${BLUE}=========================================================${NC}"
echo

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Please do not run this script as root${NC}"
  exit 1
fi

# Create log directory
mkdir -p "$HOME/.config/hypr/logs"
LOG_FILE="$HOME/.config/hypr/logs/install-$(date +%Y%m%d-%H%M%S).log"

# Function to log messages
log_message() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

log_message "Starting FF6 Hyprland installation"

# Function to check if a package is installed
is_package_installed() {
  if command -v "$1" &> /dev/null || pacman -Q "$1" &> /dev/null; then
    return 0
  else
    return 1
  fi
}

# Function to install a package if not already installed
install_package() {
  local package="$1"
  
  if is_package_installed "$package"; then
    echo -e "${GREEN}✓ $package is already installed${NC}"
    log_message "$package is already installed"
    return 0
  else
    echo -e "${YELLOW}Installing $package...${NC}"
    log_message "Installing $package"
    
    # Check if yay is installed for AUR packages
    if command -v yay &> /dev/null; then
      yay -S --noconfirm "$package"
    elif command -v paru &> /dev/null; then
      paru -S --noconfirm "$package"
    else
      sudo pacman -S --noconfirm "$package"
    fi
    
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}✓ $package installed successfully${NC}"
      log_message "$package installed successfully"
      return 0
    else
      echo -e "${RED}✗ Failed to install $package${NC}"
      log_message "Failed to install $package"
      return 1
    fi
  fi
}

# Function to backup existing configuration
backup_config() {
  local config_dir="$1"
  local backup_dir="$HOME/.config/hypr/backups/$(date +%Y%m%d-%H%M%S)"
  
  if [ -d "$config_dir" ]; then
    echo -e "${YELLOW}Backing up existing $config_dir...${NC}"
    log_message "Backing up existing $config_dir"
    
    mkdir -p "$backup_dir"
    cp -r "$config_dir" "$backup_dir/"
    
    echo -e "${GREEN}✓ Backed up to $backup_dir/$(basename "$config_dir")${NC}"
    log_message "Backed up to $backup_dir/$(basename "$config_dir")"
    return 0
  else
    echo -e "${YELLOW}No existing $config_dir to backup${NC}"
    log_message "No existing $config_dir to backup"
    return 1
  fi
}

# Check for required dependencies
echo -e "${BLUE}Checking for required dependencies...${NC}"
log_message "Checking for required dependencies"

# Install git if not already installed
install_package "git"

# Install base packages
BASE_PACKAGES=(
  "hyprland"
  "waybar"
  "rofi-wayland"
  "kitty"
  "swaync"
  "swww"
  "cliphist"
  "grim"
  "slurp"
  "swappy"
  "wl-clipboard"
  "polkit-kde-agent"
  "xdg-desktop-portal-hyprland"
  "qt5ct"
  "qt6ct"
  "kvantum"
  "thunar"
  "imagemagick"
  "sox"
  "jq"
  "wget"
  "curl"
  "unzip"
  "python"
  "python-pip"
  "network-manager-applet"
  "wayland"
  "wlroots"
  "xorg-xwayland"
  "polkit"
  "pipewire"
  "wireplumber"
  "pipewire-alsa"
  "pipewire-pulse"
  "pipewire-jack"
  "qt5-wayland"
  "qt6-wayland"
  "wofi"
  "swayidle"
  "swaylock"
  "swaybg"
  "wlogout"
  "dunst"
  "mpd"
  "mpv"
  "viewnior"
  "btop"
  "fastfetch"
  "mako"
)

OPTIONAL_PACKAGES=(
  "nwg-look"
  "cava"
  "pavucontrol"
  "blueman"
  "brightnessctl"
  "hyprpicker-git"
  "hyprshot"
  "grimblast-git"
)

# Install base packages
echo -e "${BLUE}Installing required packages...${NC}"
log_message "Installing required packages"

for package in "${BASE_PACKAGES[@]}"; do
  install_package "$package"
done

# Ask if user wants to install optional packages
echo -e "${BLUE}Would you like to install optional packages?${NC}"
echo -e "${YELLOW}These include: ${OPTIONAL_PACKAGES[*]}${NC}"
read -p "Install optional packages? (y/n): " install_optional

if [[ "$install_optional" =~ ^[Yy]$ ]]; then
  echo -e "${BLUE}Installing optional packages...${NC}"
  log_message "Installing optional packages"
  
  for package in "${OPTIONAL_PACKAGES[@]}"; do
    install_package "$package"
  done
fi

# Create config directories if they don't exist
echo -e "${BLUE}Creating configuration directories...${NC}"
log_message "Creating configuration directories"

CONFIG_DIRS=(
  "$HOME/.config/hypr"
  "$HOME/.config/waybar"
  "$HOME/.config/rofi"
  "$HOME/.config/kitty"
  "$HOME/.config/swaync"
  "$HOME/.config/swappy"
  "$HOME/.local/share/icons"
)

for dir in "${CONFIG_DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    echo -e "${GREEN}✓ Created $dir${NC}"
    log_message "Created $dir"
  else
    echo -e "${GREEN}✓ $dir already exists${NC}"
    log_message "$dir already exists"
  fi
done

# Backup existing configurations
echo -e "${BLUE}Backing up existing configurations...${NC}"
log_message "Backing up existing configurations"

backup_config "$HOME/.config/hypr"
backup_config "$HOME/.config/waybar"
backup_config "$HOME/.config/rofi"
backup_config "$HOME/.config/kitty"
backup_config "$HOME/.config/swaync"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy configuration files
echo -e "${BLUE}Copying configuration files...${NC}"
log_message "Copying configuration files"

# Copy Hyprland configuration
echo -e "${YELLOW}Copying Hyprland configuration...${NC}"
log_message "Copying Hyprland configuration"
cp -r "$SCRIPT_DIR/hypr/"* "$HOME/.config/hypr/"

# Copy Waybar configuration
echo -e "${YELLOW}Copying Waybar configuration...${NC}"
log_message "Copying Waybar configuration"
cp -r "$SCRIPT_DIR/waybar/"* "$HOME/.config/waybar/"

# Copy Rofi configuration
echo -e "${YELLOW}Copying Rofi configuration...${NC}"
log_message "Copying Rofi configuration"
cp -r "$SCRIPT_DIR/rofi/"* "$HOME/.config/rofi/"

# Copy Kitty configuration
echo -e "${YELLOW}Copying Kitty configuration...${NC}"
log_message "Copying Kitty configuration"
cp -r "$SCRIPT_DIR/kitty/"* "$HOME/.config/kitty/"

# Copy SwayNC configuration
echo -e "${YELLOW}Copying SwayNC configuration...${NC}"
log_message "Copying SwayNC configuration"
cp -r "$SCRIPT_DIR/swaync/"* "$HOME/.config/swaync/"

# Copy Swappy configuration
echo -e "${YELLOW}Copying Swappy configuration...${NC}"
log_message "Copying Swappy configuration"
cp -r "$SCRIPT_DIR/swappy/"* "$HOME/.config/swappy/"

# Copy Kvantum configuration
echo -e "${YELLOW}Copying Kvantum configuration...${NC}"
log_message "Copying Kvantum configuration"
mkdir -p "$HOME/.config/Kvantum"
cp -r "$SCRIPT_DIR/kvantum/"* "$HOME/.config/Kvantum/"

# Copy GTK themes
echo -e "${YELLOW}Copying GTK themes...${NC}"
log_message "Copying GTK themes"
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"
cp -r "$SCRIPT_DIR/gtk-themes/"* "$HOME/.config/gtk-3.0/"
cp -r "$SCRIPT_DIR/gtk-themes/"* "$HOME/.config/gtk-4.0/"

# Copy Qt5ct configuration
echo -e "${YELLOW}Copying Qt5ct configuration...${NC}"
log_message "Copying Qt5ct configuration"
mkdir -p "$HOME/.config/qt5ct"
cp -r "$SCRIPT_DIR/qt5ct/"* "$HOME/.config/qt5ct/"

# Copy Qt6ct configuration
echo -e "${YELLOW}Copying Qt6ct configuration...${NC}"
log_message "Copying Qt6ct configuration"
mkdir -p "$HOME/.config/qt6ct"
cp -r "$SCRIPT_DIR/qt6ct/"* "$HOME/.config/qt6ct/"

# Copy Thunar configuration
echo -e "${YELLOW}Copying Thunar configuration...${NC}"
log_message "Copying Thunar configuration"
mkdir -p "$HOME/.config/Thunar"
cp -r "$SCRIPT_DIR/thunar/"* "$HOME/.config/Thunar/"

# Make scripts executable
echo -e "${BLUE}Making scripts executable...${NC}"
log_message "Making scripts executable"

find "$HOME/.config/hypr/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config/rofi/scripts" -type f -name "*.sh" -exec chmod +x {} \;
chmod +x "$HOME/.config/kitty/ff_sprite.py"

# Create Atma Weapon cursor
echo -e "${BLUE}Creating Atma Weapon cursor...${NC}"
log_message "Creating Atma Weapon cursor"

if [ -f "$SCRIPT_DIR/scripts/create-atma-cursor.sh" ]; then
  bash "$SCRIPT_DIR/scripts/create-atma-cursor.sh"
else
  echo -e "${YELLOW}Atma Weapon cursor script not found, skipping${NC}"
  log_message "Atma Weapon cursor script not found, skipping"
fi

# Run fix scripts
echo -e "${BLUE}Running fix scripts...${NC}"
log_message "Running fix scripts"

# Fix configuration
if [ -f "$SCRIPT_DIR/scripts/fix-configuration.sh" ]; then
  echo -e "${YELLOW}Running fix-configuration.sh...${NC}"
  log_message "Running fix-configuration.sh"
  bash "$SCRIPT_DIR/scripts/fix-configuration.sh"
else
  echo -e "${YELLOW}fix-configuration.sh not found, skipping${NC}"
  log_message "fix-configuration.sh not found, skipping"
fi

# Configure display
if [ -f "$SCRIPT_DIR/scripts/configure-display.sh" ]; then
  echo -e "${YELLOW}Running configure-display.sh...${NC}"
  log_message "Running configure-display.sh"
  bash "$SCRIPT_DIR/scripts/configure-display.sh"
else
  echo -e "${YELLOW}configure-display.sh not found, skipping${NC}"
  log_message "configure-display.sh not found, skipping"
fi

# Configure services
if [ -f "$SCRIPT_DIR/scripts/configure-services.sh" ]; then
  echo -e "${YELLOW}Running configure-services.sh...${NC}"
  log_message "Running configure-services.sh"
  bash "$SCRIPT_DIR/scripts/configure-services.sh"
else
  echo -e "${YELLOW}configure-services.sh not found, skipping${NC}"
  log_message "configure-services.sh not found, skipping"
fi

# Download wallpapers
echo -e "${BLUE}Downloading wallpapers...${NC}"
log_message "Downloading wallpapers"

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
mkdir -p "$WALLPAPER_DIR"

# Try to download wallpapers from JaKooLit's repo
if command -v wget &> /dev/null; then
  echo -e "${YELLOW}Downloading wallpapers from JaKooLit's repo...${NC}"
  log_message "Downloading wallpapers from JaKooLit's repo"
  
  wget -q --spider https://github.com/JaKooLit/Wallpapers/archive/refs/heads/main.zip
  
  if [ $? -eq 0 ]; then
    wget -O /tmp/wallpapers.zip https://github.com/JaKooLit/Wallpapers/archive/refs/heads/main.zip
    unzip -q /tmp/wallpapers.zip -d /tmp
    cp -r /tmp/Wallpapers-main/* "$WALLPAPER_DIR/"
    rm -rf /tmp/wallpapers.zip /tmp/Wallpapers-main
    echo -e "${GREEN}✓ Wallpapers downloaded successfully${NC}"
    log_message "Wallpapers downloaded successfully"
  else
    echo -e "${YELLOW}Could not download wallpapers from JaKooLit's repo${NC}"
    log_message "Could not download wallpapers from JaKooLit's repo"
    
    # Try to download Evangelion wallpapers as fallback
    echo -e "${YELLOW}Downloading Evangelion wallpapers as fallback...${NC}"
    log_message "Downloading Evangelion wallpapers as fallback"
    
    if [ -f "$SCRIPT_DIR/hypr/scripts/download-evangelion-wallpapers.sh" ]; then
      bash "$SCRIPT_DIR/hypr/scripts/download-evangelion-wallpapers.sh"
    else
      echo -e "${YELLOW}download-evangelion-wallpapers.sh not found, skipping${NC}"
      log_message "download-evangelion-wallpapers.sh not found, skipping"
    fi
  fi
else
  echo -e "${YELLOW}wget not found, skipping wallpaper download${NC}"
  log_message "wget not found, skipping wallpaper download"
fi

# Create a default FF6-style wallpaper if no wallpapers were downloaded
if [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
  echo -e "${YELLOW}No wallpapers downloaded, creating default FF6-style wallpaper...${NC}"
  log_message "No wallpapers downloaded, creating default FF6-style wallpaper"
  
  if command -v convert &> /dev/null; then
    convert -size 1920x1080 gradient:"#0A1060-#2040A0" -fill white -draw "rectangle 10,10 1910,1070" -blur 0x2 "$WALLPAPER_DIR/ff6_default.jpg"
    echo -e "${GREEN}✓ Created default FF6-style wallpaper${NC}"
    log_message "Created default FF6-style wallpaper"
  else
    echo -e "${YELLOW}ImageMagick not found, skipping default wallpaper creation${NC}"
    log_message "ImageMagick not found, skipping default wallpaper creation"
  fi
fi

# Generate sound effects
echo -e "${BLUE}Generating sound effects...${NC}"
log_message "Generating sound effects"

SOUNDS_DIR="$HOME/.config/hypr/sounds"
mkdir -p "$SOUNDS_DIR"

if command -v sox &> /dev/null; then
  echo -e "${YELLOW}Generating FF6 sound effects...${NC}"
  log_message "Generating FF6 sound effects"
  
  sox -n "$SOUNDS_DIR/cursor.wav" synth 0.1 sine 1200 fade 0 0.1 0.05
  sox -n "$SOUNDS_DIR/confirm.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
  
  echo -e "${GREEN}✓ Generated FF6 sound effects${NC}"
  log_message "Generated FF6 sound effects"
else
  echo -e "${YELLOW}Sox not found, skipping sound effect generation${NC}"
  log_message "Sox not found, skipping sound effect generation"
fi

# Test configuration
echo -e "${BLUE}Testing configuration...${NC}"
log_message "Testing configuration"

if [ -f "$SCRIPT_DIR/scripts/test-configuration.sh" ]; then
  echo -e "${YELLOW}Running test-configuration.sh...${NC}"
  log_message "Running test-configuration.sh"
  bash "$SCRIPT_DIR/scripts/test-configuration.sh"
else
  echo -e "${YELLOW}test-configuration.sh not found, skipping${NC}"
  log_message "test-configuration.sh not found, skipping"
fi

# Create desktop entry for Hyprland
echo -e "${BLUE}Creating desktop entry for Hyprland...${NC}"
log_message "Creating desktop entry for Hyprland"

DESKTOP_ENTRY_DIR="$HOME/.local/share/wayland-sessions"
mkdir -p "$DESKTOP_ENTRY_DIR"

cat > "$DESKTOP_ENTRY_DIR/hyprland-ff6.desktop" << EOF
[Desktop Entry]
Name=Hyprland (FF6 Theme)
Comment=A dynamic tiling Wayland compositor with FF6 theme
Exec=Hyprland
Type=Application
EOF

echo -e "${GREEN}✓ Created desktop entry for Hyprland${NC}"
log_message "Created desktop entry for Hyprland"

# Set environment variables
echo -e "${BLUE}Setting environment variables...${NC}"
log_message "Setting environment variables"

ENV_FILE="$HOME/.config/hypr/env.conf"

cat > "$ENV_FILE" << EOF
# FF6 Hyprland Environment Variables

# XDG
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Toolkit Backend Variables
env = GDK_BACKEND,wayland,x11
env = QT_QPA_PLATFORM,wayland;xcb
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland

# XWayland
env = XWAYLAND_NO_GLAMOR,1

# QT Variables
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_QPA_PLATFORMTHEME,qt5ct

# Theming
env = GTK_THEME,FF6-Theme
env = XCURSOR_THEME,AtmaWeapon
env = XCURSOR_SIZE,24

# NVIDIA (uncomment if using NVIDIA GPU)
#env = LIBVA_DRIVER_NAME,nvidia
#env = GBM_BACKEND,nvidia-drm
#env = __GLX_VENDOR_LIBRARY_NAME,nvidia
#env = WLR_NO_HARDWARE_CURSORS,1
EOF

echo -e "${GREEN}✓ Set environment variables${NC}"
log_message "Set environment variables"

# Final message
echo -e "${BLUE}=========================================================${NC}"
echo -e "${GREEN}  FF6 Hyprland Configuration Installed Successfully!    ${NC}"
echo -e "${BLUE}=========================================================${NC}"
echo
echo -e "${YELLOW}Installation log saved to: $LOG_FILE${NC}"
echo
echo -e "${CYAN}To start Hyprland:${NC}"
echo -e "  1. Log out of your current session"
echo -e "  2. Select 'Hyprland (FF6 Theme)' from your display manager"
echo -e "  3. Log in"
echo
echo -e "${CYAN}Keyboard shortcuts:${NC}"
echo -e "  • ${MAGENTA}Super + Enter${NC}: Open terminal"
echo -e "  • ${MAGENTA}Super + E${NC}: Open file manager"
echo -e "  • ${MAGENTA}Super + D${NC}: Open application launcher"
echo -e "  • ${MAGENTA}Super + NUM${NC}: Switch to workspace NUM"
echo -e "  • ${MAGENTA}Super + Shift + NUM${NC}: Move window to workspace NUM"
echo -e "  • ${MAGENTA}Super + H${NC}: Show help menu"
echo
echo -e "${CYAN}If you encounter any issues:${NC}"
echo -e "  • Run the fix scripts in ~/.config/hypr/scripts/"
echo -e "  • Check the test report in ~/.config/hypr/test-reports/"
echo
echo -e "${BLUE}Enjoy your Final Fantasy VI themed Hyprland experience!${NC}"
log_message "Installation completed successfully"
