#!/bin/bash
# FF6 Ultima Weapon Cursor Theme Generator
# This script creates a custom cursor theme based on the Ultima Weapon from Final Fantasy VI

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directories
CURSOR_DIR="$HOME/.local/share/icons"
THEME_NAME="UltimaWeapon"
THEME_DIR="$CURSOR_DIR/$THEME_NAME"
CURSORS_DIR="$THEME_DIR/cursors"
TEMP_DIR="$THEME_DIR/temp"
SOURCE_DIR="/home/ubuntu/upload"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Ultima Weapon Cursor Generator    ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check for required tools
check_requirements() {
    echo -e "${BLUE}Checking requirements...${NC}"
    
    local MISSING=0
    
    # Check for ImageMagick
    if ! command_exists convert; then
        echo -e "${RED}Error: ImageMagick (convert) is not installed.${NC}"
        echo -e "${YELLOW}Please install ImageMagick:${NC}"
        echo "  - Arch Linux: sudo pacman -S imagemagick"
        echo "  - Ubuntu/Debian: sudo apt install imagemagick"
        echo "  - Fedora: sudo dnf install ImageMagick"
        MISSING=1
    fi
    
    # Check for xcursorgen
    if ! command_exists xcursorgen; then
        echo -e "${RED}Error: xcursorgen is not installed.${NC}"
        echo -e "${YELLOW}Please install xcursorgen:${NC}"
        echo "  - Arch Linux: sudo pacman -S xorg-xcursorgen"
        echo "  - Ubuntu/Debian: sudo apt install x11-apps"
        echo "  - Fedora: sudo dnf install xcursorgen"
        MISSING=1
    fi
    
    if [ $MISSING -eq 1 ]; then
        echo -e "${RED}Missing required tools. Please install them and try again.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}All requirements satisfied.${NC}"
}

# Create directories
create_directories() {
    echo -e "${BLUE}Creating directories...${NC}"
    
    mkdir -p "$CURSORS_DIR"
    mkdir -p "$TEMP_DIR"
    
    echo -e "${GREEN}Directories created.${NC}"
}

# Find source images
find_source_images() {
    echo -e "${BLUE}Looking for source images...${NC}"
    
    # Check for Ultima Weapon image (main cursor)
    if [ -f "$SOURCE_DIR/Ultima_Weapon_2_-_FF6.png" ]; then
        ULTIMA_IMAGE="$SOURCE_DIR/Ultima_Weapon_2_-_FF6.png"
        echo -e "${GREEN}Found Ultima Weapon image (main cursor): $ULTIMA_IMAGE${NC}"
    else
        echo -e "${YELLOW}Warning: Ultima Weapon image not found in $SOURCE_DIR${NC}"
        ULTIMA_IMAGE=""
    fi
    
    # Check for FF6 Cursor image (text cursor)
    if [ -f "$SOURCE_DIR/FF6Cursor.png" ]; then
        CURSOR_IMAGE="$SOURCE_DIR/FF6Cursor.png"
        echo -e "${GREEN}Found FF6 Cursor image (text cursor): $CURSOR_IMAGE${NC}"
    else
        echo -e "${YELLOW}Warning: FF6 Cursor image not found in $SOURCE_DIR${NC}"
        CURSOR_IMAGE=""
    fi
    
    # If neither image is found, exit with error
    if [ -z "$ULTIMA_IMAGE" ] && [ -z "$CURSOR_IMAGE" ]; then
        echo -e "${RED}Error: No source images found. Please provide at least one of:${NC}"
        echo "  - $SOURCE_DIR/Ultima_Weapon_2_-_FF6.png"
        echo "  - $SOURCE_DIR/FF6Cursor.png"
        exit 1
    fi
}

# Process images for cursor
process_images() {
    echo -e "${BLUE}Processing images for cursor...${NC}"
    
    # Process Ultima Weapon image for main cursor
    if [ -n "$ULTIMA_IMAGE" ]; then
        echo -e "${CYAN}Processing Ultima Weapon image for main cursor${NC}"
        
        # Create cursor sizes (24x24, 32x32, 48x48, 64x64)
        for size in 24 32 48 64; do
            # Calculate hotspot (tip of the sword, approximately 1/4 from left, 1/4 from top)
            hotspot_x=$((size / 4))
            hotspot_y=$((size / 4))
            
            # Create cursor config file
            echo "$size $hotspot_x $hotspot_y main_$size.png" > "$TEMP_DIR/main_$size.in"
            
            # Resize source image
            convert "$ULTIMA_IMAGE" -resize ${size}x${size} -background none "$TEMP_DIR/main_$size.png"
            
            echo -e "${GREEN}Created ${size}x${size} main cursor image${NC}"
        done
    else
        echo -e "${YELLOW}Warning: No Ultima Weapon image found, using fallback for main cursor${NC}"
        
        # Create a fallback sword cursor using ImageMagick
        for size in 24 32 48 64; do
            # Calculate hotspot
            hotspot_x=$((size / 4))
            hotspot_y=$((size / 4))
            
            # Create cursor config file
            echo "$size $hotspot_x $hotspot_y main_$size.png" > "$TEMP_DIR/main_$size.in"
            
            # Create a simple sword cursor
            convert -size ${size}x${size} xc:transparent -fill none -stroke blue -strokewidth $((size / 16)) \
                -draw "line $((size / 4)),$((size / 4)) $((size * 3 / 4)),$((size * 3 / 4)) line $((size * 3 / 4)),$((size * 3 / 4)) $((size / 4)),$((size * 3 / 4)) line $((size / 4)),$((size * 3 / 4)) $((size / 2)),$((size / 2))" \
                -fill gold -draw "circle $((size / 2)),$((size / 2)) $((size / 2)),$((size / 2 + size / 8))" \
                "$TEMP_DIR/main_$size.png"
            
            echo -e "${GREEN}Created ${size}x${size} fallback main cursor image${NC}"
        done
    fi
    
    # Process FF6 Cursor image for text cursor
    if [ -n "$CURSOR_IMAGE" ]; then
        echo -e "${CYAN}Processing FF6 Cursor image for text cursor${NC}"
        
        # Create cursor sizes (24x24, 32x32, 48x48, 64x64)
        for size in 24 32 48 64; do
            # Calculate hotspot (center of the image)
            hotspot_x=$((size / 2))
            hotspot_y=$((size / 2))
            
            # Create cursor config file
            echo "$size $hotspot_x $hotspot_y text_$size.png" > "$TEMP_DIR/text_$size.in"
            
            # Resize source image
            convert "$CURSOR_IMAGE" -resize ${size}x${size} -background none "$TEMP_DIR/text_$size.png"
            
            echo -e "${GREEN}Created ${size}x${size} text cursor image${NC}"
        done
    else
        echo -e "${YELLOW}Warning: No FF6 Cursor image found, using fallback for text cursor${NC}"
        
        # Create a fallback text cursor using ImageMagick
        for size in 24 32 48 64; do
            # Calculate hotspot
            hotspot_x=$((size / 2))
            hotspot_y=$((size / 2))
            
            # Create cursor config file
            echo "$size $hotspot_x $hotspot_y text_$size.png" > "$TEMP_DIR/text_$size.in"
            
            # Create a simple text cursor
            convert -size ${size}x${size} xc:transparent -fill none -stroke cyan -strokewidth $((size / 16)) \
                -draw "line $((size / 4)),$((size / 2)) $((size * 3 / 4)),$((size / 2))" \
                -draw "line $((size / 2)),$((size / 4)) $((size / 2)),$((size * 3 / 4))" \
                "$TEMP_DIR/text_$size.png"
            
            echo -e "${GREEN}Created ${size}x${size} fallback text cursor image${NC}"
        done
    fi
}

# Generate cursor files
generate_cursors() {
    echo -e "${BLUE}Generating cursor files...${NC}"
    
    # Generate main cursor for each size
    for size in 24 32 48 64; do
        xcursorgen "$TEMP_DIR/main_$size.in" "$CURSORS_DIR/left_ptr_$size"
        echo -e "${GREEN}Generated ${size}x${size} main cursor${NC}"
    done
    
    # Generate text cursor for each size
    for size in 24 32 48 64; do
        xcursorgen "$TEMP_DIR/text_$size.in" "$CURSORS_DIR/text_$size"
        echo -e "${GREEN}Generated ${size}x${size} text cursor${NC}"
    done
    
    # Create the main cursor by linking to the 32x32 version
    ln -sf left_ptr_32 "$CURSORS_DIR/left_ptr"
    
    # Create the text cursor by linking to the 32x32 version
    ln -sf text_32 "$CURSORS_DIR/text"
    ln -sf text_32 "$CURSORS_DIR/ibeam"
    ln -sf text_32 "$CURSORS_DIR/xterm"
    
    # Create symlinks for all cursor types
    cd "$CURSORS_DIR"
    
    # Basic cursor types (use main cursor)
    for cursor in arrow default top_left_arrow; do
        ln -sf left_ptr "$cursor"
    done
    
    # Corner and side cursors (use main cursor)
    for cursor in bottom_left_corner bottom_right_corner bottom_side left_side right_side top_left_corner top_right_corner top_side; do
        ln -sf left_ptr "$cursor"
    done
    
    # Special cursors (use main cursor)
    for cursor in center_ptr context-menu copy crosshair fleur help move pointer progress vertical-text wait; do
        ln -sf left_ptr "$cursor"
    done
    
    # Resize cursors (use main cursor)
    for cursor in all-scroll col-resize e-resize n-resize ne-resize nw-resize row-resize s-resize se-resize sw-resize w-resize; do
        ln -sf left_ptr "$cursor"
    done
    
    echo -e "${GREEN}Created all cursor symlinks${NC}"
}

# Create theme index file
create_theme_index() {
    echo -e "${BLUE}Creating theme index file...${NC}"
    
    cat > "$THEME_DIR/index.theme" << EOF
[Icon Theme]
Name=UltimaWeapon
Comment=FF6 Ultima Weapon Cursor Theme
Inherits=Adwaita
EOF
    
    echo -e "${GREEN}Theme index file created${NC}"
}

# Set as default cursor theme
set_as_default() {
    echo -e "${BLUE}Setting as default cursor theme...${NC}"
    
    # Create or update .Xresources
    if [ -f "$HOME/.Xresources" ]; then
        # Check if cursor theme is already set
        if grep -q "Xcursor.theme:" "$HOME/.Xresources"; then
            # Update existing setting
            sed -i "s/Xcursor.theme:.*/Xcursor.theme: $THEME_NAME/" "$HOME/.Xresources"
        else
            # Add new setting
            echo "Xcursor.theme: $THEME_NAME" >> "$HOME/.Xresources"
        fi
    else
        # Create new .Xresources file
        echo "Xcursor.theme: $THEME_NAME" > "$HOME/.Xresources"
    fi
    
    # Update .profile
    if [ -f "$HOME/.profile" ]; then
        # Check if cursor theme is already set
        if grep -q "XCURSOR_THEME=" "$HOME/.profile"; then
            # Update existing setting
            sed -i "s/XCURSOR_THEME=.*/XCURSOR_THEME=$THEME_NAME/" "$HOME/.profile"
        else
            # Add new setting
            echo "export XCURSOR_THEME=$THEME_NAME" >> "$HOME/.profile"
        fi
    else
        # Create new .profile file
        echo "export XCURSOR_THEME=$THEME_NAME" > "$HOME/.profile"
    fi
    
    # Update GTK settings
    GTK_CONFIG_DIR="$HOME/.config/gtk-3.0"
    mkdir -p "$GTK_CONFIG_DIR"
    
    if [ -f "$GTK_CONFIG_DIR/settings.ini" ]; then
        # Check if cursor theme is already set
        if grep -q "gtk-cursor-theme-name" "$GTK_CONFIG_DIR/settings.ini"; then
            # Update existing setting
            sed -i "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$THEME_NAME/" "$GTK_CONFIG_DIR/settings.ini"
        else
            # Add new setting
            echo "gtk-cursor-theme-name=$THEME_NAME" >> "$GTK_CONFIG_DIR/settings.ini"
        fi
    else
        # Create new settings.ini file
        cat > "$GTK_CONFIG_DIR/settings.ini" << EOF
[Settings]
gtk-cursor-theme-name=$THEME_NAME
EOF
    fi
    
    # Update Hyprland config if it exists
    HYPR_CONFIG_DIR="$HOME/.config/hypr"
    if [ -d "$HYPR_CONFIG_DIR" ]; then
        if [ -f "$HYPR_CONFIG_DIR/hyprland.conf" ]; then
            # Check if cursor theme is already set
            if grep -q "cursor_theme" "$HYPR_CONFIG_DIR/hyprland.conf"; then
                # Update existing setting
                sed -i "s/cursor_theme.*/cursor_theme = $THEME_NAME/" "$HYPR_CONFIG_DIR/hyprland.conf"
            else
                # Add new setting to the env section
                if grep -q "\[env\]" "$HYPR_CONFIG_DIR/hyprland.conf"; then
                    # Add to existing env section
                    sed -i "/\[env\]/a cursor_theme = $THEME_NAME" "$HYPR_CONFIG_DIR/hyprland.conf"
                else
                    # Create new env section
                    echo -e "\n[env]\ncursor_theme = $THEME_NAME" >> "$HYPR_CONFIG_DIR/hyprland.conf"
                fi
            fi
        fi
    fi
    
    echo -e "${GREEN}Set as default cursor theme${NC}"
}

# Clean up temporary files
cleanup() {
    echo -e "${BLUE}Cleaning up temporary files...${NC}"
    
    rm -rf "$TEMP_DIR"
    
    echo -e "${GREEN}Cleanup complete${NC}"
}

# Main function
main() {
    check_requirements
    create_directories
    find_source_images
    process_images
    generate_cursors
    create_theme_index
    set_as_default
    cleanup
    
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${GREEN}FF6 Ultima Weapon cursor theme created successfully!${NC}"
    echo -e "${CYAN}Theme installed to: $THEME_DIR${NC}"
    echo -e "${CYAN}Main cursor: Ultima Weapon image${NC}"
    echo -e "${CYAN}Text cursor: FF6 Cursor image${NC}"
    echo -e "${CYAN}Log out and log back in for the changes to take effect.${NC}"
    echo -e "${BLUE}=========================================${NC}"
}

# Run the main function
main
