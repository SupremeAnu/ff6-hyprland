#!/bin/bash
# FF6-Themed Hyprland Configuration - Master Installation Script
# This script automates the installation of the complete FF6-themed Hyprland configuration

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   FF6-Themed Hyprland Configuration   ${NC}"
echo -e "${BLUE}       Master Installation Script       ${NC}"
echo -e "${BLUE}========================================${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install packages based on the detected distribution
install_dependencies() {
    echo -e "\n${YELLOW}Installing dependencies...${NC}"
    
    # Detect the Linux distribution
    if command_exists apt; then
        # Debian/Ubuntu
        echo -e "${BLUE}Debian/Ubuntu detected.${NC}"
        sudo apt update
        sudo apt install -y hyprland waybar rofi kitty python3-pip python3-pillow wlogout swaybg swaylock swayidle swaync thunar nemo pavucontrol blueman network-manager-gnome
    elif command_exists pacman; then
        # Arch Linux
        echo -e "${BLUE}Arch Linux detected.${NC}"
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm hyprland waybar rofi kitty python-pip python-pillow wlogout swaybg swaylock swayidle swaync thunar nemo pavucontrol blueman network-manager-applet
    elif command_exists dnf; then
        # Fedora
        echo -e "${BLUE}Fedora detected.${NC}"
        sudo dnf update -y
        sudo dnf install -y hyprland waybar rofi kitty python3-pip python3-pillow wlogout swaybg swaylock swayidle swaync thunar nemo pavucontrol blueman network-manager-applet
    elif command_exists zypper; then
        # openSUSE
        echo -e "${BLUE}openSUSE detected.${NC}"
        sudo zypper refresh
        sudo zypper install -y hyprland waybar rofi kitty python3-pip python3-Pillow wlogout swaybg swaylock swayidle swaync thunar nemo pavucontrol blueman network-manager-applet
    else
        echo -e "${RED}Unsupported distribution. Please install the required packages manually.${NC}"
        echo "Required packages: hyprland waybar rofi kitty python3-pip python3-pillow wlogout swaybg swaylock swayidle swaync thunar nemo pavucontrol blueman"
        return 1
    fi
    
    # Install Python packages
    pip3 install --user pillow
    
    echo -e "${GREEN}Dependencies installed successfully.${NC}"
    return 0
}

# Function to create necessary directories
create_directories() {
    echo -e "\n${YELLOW}Creating necessary directories...${NC}"
    
    # Create config directories
    mkdir -p ~/.config/hypr
    mkdir -p ~/.config/waybar
    mkdir -p ~/.config/waybar/modules
    mkdir -p ~/.config/rofi
    mkdir -p ~/.config/rofi/themes
    mkdir -p ~/.config/kitty
    mkdir -p ~/.config/swaync
    mkdir -p ~/.config/swaylock
    mkdir -p ~/.config/wlogout
    mkdir -p ~/.icons
    mkdir -p ~/.local/share/icons
    mkdir -p ~/.config/gtk-3.0
    mkdir -p ~/.config/gtk-4.0
    
    echo -e "${GREEN}Directories created successfully.${NC}"
}

# Function to backup existing configurations
backup_configs() {
    echo -e "\n${YELLOW}Backing up existing configurations...${NC}"
    
    # Create backup directory
    backup_dir=~/config-backup-$(date +%Y%m%d-%H%M%S)
    mkdir -p "$backup_dir"
    
    # Backup existing configurations
    [ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$backup_dir/hypr"
    [ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$backup_dir/waybar"
    [ -d ~/.config/rofi ] && cp -r ~/.config/rofi "$backup_dir/rofi"
    [ -d ~/.config/kitty ] && cp -r ~/.config/kitty "$backup_dir/kitty"
    [ -d ~/.config/swaync ] && cp -r ~/.config/swaync "$backup_dir/swaync"
    [ -d ~/.config/swaylock ] && cp -r ~/.config/swaylock "$backup_dir/swaylock"
    [ -d ~/.config/wlogout ] && cp -r ~/.config/wlogout "$backup_dir/wlogout"
    
    echo -e "${GREEN}Configurations backed up to $backup_dir${NC}"
}

# Function to install the Hyprland configuration
install_hyprland_config() {
    echo -e "\n${YELLOW}Installing Hyprland configuration...${NC}"
    
    # Copy Hyprland configuration files
    cp -r "$(dirname "$0")/../hypr/"* ~/.config/hypr/
    
    # Make scripts executable
    find ~/.config/hypr/scripts -type f -name "*.sh" -exec chmod +x {} \;
    
    echo -e "${GREEN}Hyprland configuration installed successfully.${NC}"
}

# Function to install the Waybar configuration
install_waybar_config() {
    echo -e "\n${YELLOW}Installing Waybar configuration...${NC}"
    
    # Copy Waybar configuration files
    cp "$(dirname "$0")/../waybar/config.jsonc" ~/.config/waybar/
    cp "$(dirname "$0")/../waybar/style.css" ~/.config/waybar/
    cp -r "$(dirname "$0")/../waybar/modules/"* ~/.config/waybar/modules/
    
    echo -e "${GREEN}Waybar configuration installed successfully.${NC}"
}

# Function to install the Rofi configuration
install_rofi_config() {
    echo -e "\n${YELLOW}Installing Rofi configuration...${NC}"
    
    # Copy Rofi configuration files
    cp "$(dirname "$0")/../rofi/config.rasi" ~/.config/rofi/
    cp "$(dirname "$0")/../rofi/shared-fonts.rasi" ~/.config/rofi/
    cp -r "$(dirname "$0")/../rofi/themes/"* ~/.config/rofi/themes/
    
    echo -e "${GREEN}Rofi configuration installed successfully.${NC}"
}

# Function to install the Kitty configuration
install_kitty_config() {
    echo -e "\n${YELLOW}Installing Kitty configuration...${NC}"
    
    # Copy Kitty configuration files
    cp "$(dirname "$0")/../kitty/kitty.conf" ~/.config/kitty/
    cp "$(dirname "$0")/../kitty/ff_sprite.py" ~/.config/kitty/
    chmod +x ~/.config/kitty/ff_sprite.py
    
    echo -e "${GREEN}Kitty configuration installed successfully.${NC}"
}

# Function to install the cursor theme
install_cursor_theme() {
    echo -e "\n${YELLOW}Installing cursor theme...${NC}"
    
    # Copy cursor theme
    cp -r "$(dirname "$0")/../cursor/AtmaWeapon" ~/.icons/
    
    # Create symbolic link
    ln -sf ~/.icons/AtmaWeapon ~/.local/share/icons/AtmaWeapon
    
    # Configure GTK to use the cursor theme
    cat > ~/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=Sans 10
gtk-cursor-theme-name=AtmaWeapon
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
EOF
    
    # Copy the same settings for GTK-4.0
    cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
    
    # Create Xresources file to set cursor theme
    cat > ~/.Xresources << EOF
Xcursor.theme: AtmaWeapon
Xcursor.size: 24
EOF
    
    # Update Xresources
    xrdb -merge ~/.Xresources
    
    # Update index.theme file to ensure proper cursor loading
    mkdir -p ~/.icons/default
    cat > ~/.icons/default/index.theme << EOF
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=AtmaWeapon
EOF
    
    echo -e "${GREEN}Cursor theme installed successfully.${NC}"
}

# Function to generate wallpapers
generate_wallpapers() {
    echo -e "\n${YELLOW}Generating wallpapers...${NC}"
    
    # Run the wallpaper generation script
    python3 "$(dirname "$0")/generate-wallpapers.sh"
    
    echo -e "${GREEN}Wallpapers generated successfully.${NC}"
}

# Function to create a desktop entry
create_desktop_entry() {
    echo -e "\n${YELLOW}Creating desktop entry...${NC}"
    
    # Create desktop entry directory
    mkdir -p ~/.local/share/wayland-sessions
    
    # Create desktop entry file
    cat > ~/.local/share/wayland-sessions/hyprland-ff6.desktop << EOF
[Desktop Entry]
Name=Hyprland (FF6 Theme)
Comment=A dynamic tiling Wayland compositor with FF6 theme
Exec=Hyprland
Type=Application
EOF
    
    echo -e "${GREEN}Desktop entry created successfully.${NC}"
}

# Main installation function
main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}Please do not run this script as root.${NC}"
        exit 1
    fi
    
    # Ask for confirmation
    echo -e "${YELLOW}This script will install the FF6-themed Hyprland configuration.${NC}"
    echo -e "${YELLOW}It will backup your existing configurations before making any changes.${NC}"
    read -p "Do you want to continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation cancelled.${NC}"
        exit 1
    fi
    
    # Backup existing configurations
    backup_configs
    
    # Ask if dependencies should be installed
    echo -e "${YELLOW}Do you want to install the required dependencies?${NC}"
    echo -e "${YELLOW}This requires sudo privileges.${NC}"
    read -p "Install dependencies? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_dependencies
    else
        echo -e "${YELLOW}Skipping dependency installation.${NC}"
        echo -e "${YELLOW}Please ensure you have the required packages installed.${NC}"
    fi
    
    # Create necessary directories
    create_directories
    
    # Install configurations
    install_hyprland_config
    install_waybar_config
    install_rofi_config
    install_kitty_config
    install_cursor_theme
    
    # Generate wallpapers
    generate_wallpapers
    
    # Create desktop entry
    create_desktop_entry
    
    # Run the validation script
    echo -e "\n${YELLOW}Validating installation...${NC}"
    if "$(dirname "$0")/validate-config.sh"; then
        echo -e "${GREEN}Installation validated successfully.${NC}"
    else
        echo -e "${RED}Installation validation failed. Please check the errors above.${NC}"
    fi
    
    # Print completion message
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${GREEN}FF6-themed Hyprland configuration installed successfully!${NC}"
    echo -e "${YELLOW}To start Hyprland with the FF6 theme, log out and select 'Hyprland (FF6 Theme)' from the login screen.${NC}"
    echo -e "${YELLOW}Or run 'Hyprland' from a TTY.${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Run the main function
main
