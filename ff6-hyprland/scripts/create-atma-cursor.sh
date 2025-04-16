#!/bin/bash
# Script to create the Atma Weapon cursor theme
# Based on the FF6 Ultima Weapon sprite
# Created: April 2025

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Creating Atma Weapon Cursor Theme      ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Define directories
CURSOR_DIR="$HOME/.local/share/icons/AtmaWeapon"
CURSOR_SRC="$HOME/.config/hypr/cursors"

# Create cursor directories
mkdir -p "$CURSOR_DIR/cursors"

# Create cursor theme index file
cat > "$CURSOR_DIR/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6 Atma Weapon Cursor Theme
Inherits=Adwaita
EOF

echo -e "${GREEN}Creating Atma Weapon cursor theme...${NC}"

# Create cursor image (24x24 pixels)
cat > /tmp/atma_cursor.xbm << EOF
#define atma_cursor_width 24
#define atma_cursor_height 24
static unsigned char atma_cursor_bits[] = {
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};
EOF

cat > /tmp/atma_cursor_mask.xbm << EOF
#define atma_cursor_mask_width 24
#define atma_cursor_mask_height 24
static unsigned char atma_cursor_mask_bits[] = {
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};
EOF

# Create a PNG version of the cursor using ImageMagick if available
if command -v convert &> /dev/null; then
    # Create a blue sword cursor similar to Ultima Weapon from FF6
    convert -size 24x24 xc:transparent \
        -fill "#0000FF" -stroke "#000080" -strokewidth 1 \
        -draw "line 2,2 22,22" \
        -draw "line 3,2 22,21" \
        -draw "line 2,3 21,22" \
        -fill "#4080FF" -stroke "#4080FF" -strokewidth 1 \
        -draw "line 4,4 20,20" \
        -fill "#80C0FF" -stroke "#80C0FF" -strokewidth 1 \
        -draw "line 6,6 18,18" \
        -fill "#FFFFFF" -stroke "#FFFFFF" -strokewidth 1 \
        -draw "line 8,8 16,16" \
        -fill "#FFC000" -stroke "#804000" -strokewidth 1 \
        -draw "rectangle 20,20 23,23" \
        /tmp/atma_cursor.png

    # Create cursor files using xcursorgen if available
    if command -v xcursorgen &> /dev/null; then
        # Create config file for xcursorgen
        echo "24 12 12 /tmp/atma_cursor.png" > /tmp/atma_cursor.config
        
        # Generate cursor files
        xcursorgen /tmp/atma_cursor.config "$CURSOR_DIR/cursors/left_ptr"
        
        # Create symlinks for different cursor types
        cd "$CURSOR_DIR/cursors"
        ln -sf left_ptr arrow
        ln -sf left_ptr default
        ln -sf left_ptr pointer
        ln -sf left_ptr top_left_arrow
        ln -sf left_ptr text
        ln -sf left_ptr ibeam
        ln -sf left_ptr vertical-text
        ln -sf left_ptr hand
        ln -sf left_ptr hand1
        ln -sf left_ptr hand2
        ln -sf left_ptr pointer-move
        ln -sf left_ptr all-scroll
        ln -sf left_ptr grab
        ln -sf left_ptr grabbing
        ln -sf left_ptr fleur
        ln -sf left_ptr size_ver
        ln -sf left_ptr size_hor
        ln -sf left_ptr size_bdiag
        ln -sf left_ptr size_fdiag
        ln -sf left_ptr size_all
        ln -sf left_ptr crosshair
        ln -sf left_ptr wait
        ln -sf left_ptr watch
        ln -sf left_ptr progress
        ln -sf left_ptr not-allowed
        ln -sf left_ptr no-drop
        ln -sf left_ptr copy
        ln -sf left_ptr move
        ln -sf left_ptr link
        ln -sf left_ptr context-menu
        ln -sf left_ptr help
        ln -sf left_ptr zoom-in
        ln -sf left_ptr zoom-out
        
        echo -e "${GREEN}Cursor theme created successfully at $CURSOR_DIR${NC}"
    else
        echo -e "${YELLOW}Warning: xcursorgen not found. Using fallback cursor.${NC}"
        # Copy default cursor as fallback
        cp /usr/share/icons/Adwaita/cursors/left_ptr "$CURSOR_DIR/cursors/"
        cd "$CURSOR_DIR/cursors"
        ln -sf left_ptr arrow
        ln -sf left_ptr default
    fi
else
    echo -e "${YELLOW}Warning: ImageMagick not found. Using fallback cursor.${NC}"
    # Copy default cursor as fallback
    cp /usr/share/icons/Adwaita/cursors/left_ptr "$CURSOR_DIR/cursors/"
    cd "$CURSOR_DIR/cursors"
    ln -sf left_ptr arrow
    ln -sf left_ptr default
fi

# Clean up temporary files
rm -f /tmp/atma_cursor.xbm /tmp/atma_cursor_mask.xbm /tmp/atma_cursor.png /tmp/atma_cursor.config

# Update user's cursor configuration
if [ -d "$HOME/.config/gtk-3.0" ]; then
    if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
        # Check if cursor theme is already set
        if grep -q "gtk-cursor-theme-name" "$HOME/.config/gtk-3.0/settings.ini"; then
            # Update existing cursor theme
            sed -i 's/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=AtmaWeapon/' "$HOME/.config/gtk-3.0/settings.ini"
        else
            # Add cursor theme setting
            echo "gtk-cursor-theme-name=AtmaWeapon" >> "$HOME/.config/gtk-3.0/settings.ini"
        fi
    else
        # Create settings.ini file
        mkdir -p "$HOME/.config/gtk-3.0"
        echo "[Settings]" > "$HOME/.config/gtk-3.0/settings.ini"
        echo "gtk-cursor-theme-name=AtmaWeapon" >> "$HOME/.config/gtk-3.0/settings.ini"
    fi
fi

# Update Hyprland environment variables
if [ -d "$HOME/.config/hypr" ]; then
    # Check if hyprland.conf exists
    if [ -f "$HOME/.config/hypr/hyprland.conf" ]; then
        # Check if cursor theme is already set
        if grep -q "XCURSOR_THEME" "$HOME/.config/hypr/hyprland.conf"; then
            # Update existing cursor theme
            sed -i 's/env = XCURSOR_THEME,.*/env = XCURSOR_THEME,AtmaWeapon/' "$HOME/.config/hypr/hyprland.conf"
        else
            # Add cursor theme setting
            echo "env = XCURSOR_THEME,AtmaWeapon" >> "$HOME/.config/hypr/hyprland.conf"
            echo "env = XCURSOR_SIZE,24" >> "$HOME/.config/hypr/hyprland.conf"
        fi
    fi
fi

echo -e "${GREEN}Cursor theme configuration complete!${NC}"
echo -e "${BLUE}Please restart Hyprland for changes to take effect.${NC}"

exit 0
