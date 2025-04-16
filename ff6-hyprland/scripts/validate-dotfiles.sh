#!/bin/bash
# Script to validate and fix dotfile placement
# Part of FF6 Hyprland Configuration

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
CURSOR_DIR="$HOME/.local/share/icons/AtmaWeapon"
FONTS_DIR="$HOME/.local/share/fonts"
SOUNDS_DIR="$HYPR_DIR/sounds"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Dotfile Validator        ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a directory exists
check_dir() {
    local dir="$1"
    local name="$2"
    
    echo -ne "${YELLOW}Checking $name directory... ${NC}"
    if [ -d "$dir" ]; then
        echo -e "${GREEN}Found${NC}"
        return 0
    else
        echo -e "${RED}Not found${NC}"
        return 1
    fi
}

# Function to check if a file exists
check_file() {
    local file="$1"
    local name="$2"
    
    echo -ne "${YELLOW}Checking $name file... ${NC}"
    if [ -f "$file" ]; then
        echo -e "${GREEN}Found${NC}"
        return 0
    else
        echo -e "${RED}Not found${NC}"
        return 1
    fi
}

# Function to create directory if it doesn't exist
create_dir() {
    local dir="$1"
    
    if [ ! -d "$dir" ]; then
        echo -e "${YELLOW}Creating directory $dir${NC}"
        mkdir -p "$dir"
        echo -e "${GREEN}Directory created.${NC}"
    fi
}

# Function to create symbolic link
create_symlink() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$src" ]; then
        echo -e "${YELLOW}Creating symbolic link from $src to $dest${NC}"
        ln -sf "$src" "$dest"
        echo -e "${GREEN}Symbolic link created.${NC}"
    else
        echo -e "${RED}Error: Source file/directory $src not found.${NC}"
        return 1
    fi
}

# Check all required directories
echo -e "${BLUE}Checking required directories...${NC}"
check_dir "$HYPR_DIR" "Hyprland" || create_dir "$HYPR_DIR"
check_dir "$WAYBAR_DIR" "Waybar" || create_dir "$WAYBAR_DIR"
check_dir "$ROFI_DIR" "Rofi" || create_dir "$ROFI_DIR"
check_dir "$KITTY_DIR" "Kitty" || create_dir "$KITTY_DIR"
check_dir "$SWAPPY_DIR" "Swappy" || create_dir "$SWAPPY_DIR"
check_dir "$SWAYNC_DIR" "SwayNC" || create_dir "$SWAYNC_DIR"
check_dir "$KVANTUM_DIR" "Kvantum" || create_dir "$KVANTUM_DIR"
check_dir "$GTK_DIR" "GTK" || create_dir "$GTK_DIR"
check_dir "$QT5CT_DIR" "Qt5ct" || create_dir "$QT5CT_DIR"
check_dir "$QT6CT_DIR" "Qt6ct" || create_dir "$QT6CT_DIR"
check_dir "$THUNAR_DIR" "Thunar" || create_dir "$THUNAR_DIR"
check_dir "$CURSOR_DIR" "Cursor" || create_dir "$CURSOR_DIR"
check_dir "$HYPR_DIR/scripts" "Hyprland scripts" || create_dir "$HYPR_DIR/scripts"
check_dir "$HYPR_DIR/wallpapers" "Hyprland wallpapers" || create_dir "$HYPR_DIR/wallpapers"
check_dir "$SOUNDS_DIR" "Sound effects" || create_dir "$SOUNDS_DIR"
check_dir "$ROFI_DIR/scripts" "Rofi scripts" || create_dir "$ROFI_DIR/scripts"

# Check critical configuration files
echo -e "${BLUE}Checking critical configuration files...${NC}"
check_file "$HYPR_DIR/hyprland.conf" "Hyprland main config"
check_file "$HYPR_DIR/animations.conf" "Hyprland animations config"
check_file "$HYPR_DIR/colors.conf" "Hyprland colors config"
check_file "$HYPR_DIR/keybinds.conf" "Hyprland keybinds config"
check_file "$WAYBAR_DIR/config-top.jsonc" "Waybar top config"
check_file "$WAYBAR_DIR/config-bottom.jsonc" "Waybar bottom config"
check_file "$WAYBAR_DIR/style.css" "Waybar style"
check_file "$ROFI_DIR/config.rasi" "Rofi config"
check_file "$ROFI_DIR/ff6-theme.rasi" "Rofi FF6 theme"
check_file "$KITTY_DIR/kitty.conf" "Kitty config"
check_file "$KITTY_DIR/ff_sprite.py" "Kitty FF6 sprite script"

# Check script files
echo -e "${BLUE}Checking script files...${NC}"
check_file "$HYPR_DIR/scripts/set-wallpaper.sh" "Wallpaper setter script"
check_file "$HYPR_DIR/scripts/wallpaper-menu.sh" "Wallpaper menu script"
check_file "$HYPR_DIR/scripts/wallpaper-random.sh" "Random wallpaper script"
check_file "$HYPR_DIR/scripts/toggle-ff6-menu.sh" "FF6 menu toggle script"
check_file "$HYPR_DIR/scripts/keybindings-help.sh" "Keybindings help script"
check_file "$ROFI_DIR/scripts/powermenu.sh" "Power menu script"

# Check sound files
echo -e "${BLUE}Checking sound files...${NC}"
check_file "$SOUNDS_DIR/cursor.wav" "Cursor sound" || echo -e "${YELLOW}Warning: Cursor sound file missing. Run generate-sounds.sh to create it.${NC}"
check_file "$SOUNDS_DIR/confirm.wav" "Confirm sound" || echo -e "${YELLOW}Warning: Confirm sound file missing. Run generate-sounds.sh to create it.${NC}"
check_file "$SOUNDS_DIR/menu_open.wav" "Menu open sound" || echo -e "${YELLOW}Warning: Menu open sound file missing. Run generate-sounds.sh to create it.${NC}"
check_file "$SOUNDS_DIR/error.wav" "Error sound" || echo -e "${YELLOW}Warning: Error sound file missing. Run generate-sounds.sh to create it.${NC}"

# Check cursor theme
echo -e "${BLUE}Checking cursor theme...${NC}"
check_file "$CURSOR_DIR/cursors/left_ptr" "Cursor left_ptr" || echo -e "${YELLOW}Warning: Cursor theme files missing. Run create-atma-cursor.sh to create them.${NC}"

# Check if Hyprland is properly installed
echo -e "${BLUE}Checking Hyprland installation...${NC}"
if command -v hyprctl &> /dev/null; then
    echo -e "${GREEN}Hyprland is installed.${NC}"
    
    # Check Hyprland version
    HYPR_VERSION=$(hyprctl version | grep "Hyprland" | awk '{print $2}')
    echo -e "${GREEN}Hyprland version: $HYPR_VERSION${NC}"
else
    echo -e "${RED}Error: Hyprland is not installed or not in PATH.${NC}"
fi

# Check if Waybar is properly installed
echo -e "${BLUE}Checking Waybar installation...${NC}"
if command -v waybar &> /dev/null; then
    echo -e "${GREEN}Waybar is installed.${NC}"
    
    # Check Waybar version
    WAYBAR_VERSION=$(waybar --version | head -n 1)
    echo -e "${GREEN}Waybar version: $WAYBAR_VERSION${NC}"
else
    echo -e "${RED}Error: Waybar is not installed or not in PATH.${NC}"
fi

# Check if environment variables are set
echo -e "${BLUE}Checking environment variables...${NC}"
if grep -q "XCURSOR_THEME=AtmaWeapon" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${GREEN}XCURSOR_THEME is properly set in hyprland.conf.${NC}"
else
    echo -e "${RED}Error: XCURSOR_THEME is not properly set in hyprland.conf.${NC}"
fi

# Final summary
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Dotfile validation complete!${NC}"
echo -e "${YELLOW}If any issues were found, please run the installer again or fix them manually.${NC}"
echo -e "${BLUE}=========================================${NC}"
