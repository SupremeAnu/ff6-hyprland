#!/bin/bash
# Script to create Atma Weapon cursor theme for FF6 Hyprland
# Created: April 2025

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CURSOR_DIR="$HOME/.local/share/icons/AtmaWeapon"
TEMP_DIR="/tmp/atma_cursor"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Atma Weapon Cursor Theme Generator    ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if required commands are installed
if ! command_exists convert; then
    echo -e "${RED}Error: ImageMagick (convert) is not installed. Cannot create cursor theme.${NC}"
    echo -e "${RED}Please install ImageMagick and try again.${NC}"
    exit 1
fi

# Create directories
mkdir -p "$CURSOR_DIR/cursors"
mkdir -p "$TEMP_DIR"

echo -e "${YELLOW}Creating Atma Weapon cursor theme...${NC}"

# Create cursor.theme file
cat > "$CURSOR_DIR/cursor.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6-themed cursor based on the Atma Weapon
Inherits=Adwaita
EOF

echo -e "${GREEN}Created cursor.theme file.${NC}"

# Create index.theme file
cat > "$CURSOR_DIR/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6-themed cursor based on the Atma Weapon
Inherits=Adwaita
Directories=cursors
EOF

echo -e "${GREEN}Created index.theme file.${NC}"

# Function to create a cursor
create_cursor() {
    local name="$1"
    local size="$2"
    local hotspot_x="$3"
    local hotspot_y="$4"
    local color="$5"
    local output="$6"
    
    # Create a sword-shaped cursor
    convert -size "${size}x${size}" xc:transparent \
        -fill "$color" \
        -draw "polygon ${hotspot_x},${hotspot_y} $((hotspot_x+size/4)),$((hotspot_y-size/3)) $((hotspot_x+size/2)),$((hotspot_y-size/4)) $((hotspot_x+size/3)),$((hotspot_y+size/3))" \
        -draw "line $((hotspot_x+size/4)),$((hotspot_y-size/3)) $((hotspot_x+size/3)),$((hotspot_y-size/2))" \
        "$TEMP_DIR/$name.png"
    
    # Convert to cursor format
    if command_exists xcursorgen; then
        # Create config file for xcursorgen
        echo "$size $hotspot_x $hotspot_y $TEMP_DIR/$name.png 0" > "$TEMP_DIR/$name.cfg"
        
        # Generate cursor
        xcursorgen "$TEMP_DIR/$name.cfg" "$output"
        echo -e "${GREEN}Created cursor: $name${NC}"
    else
        echo -e "${RED}Error: xcursorgen is not installed. Cannot create cursor.${NC}"
        echo -e "${RED}Please install xcursorgen and try again.${NC}"
        exit 1
    fi
}

# Create default cursor
create_cursor "default" 32 16 16 "#4080FF" "$CURSOR_DIR/cursors/left_ptr"

# Create symlinks for all cursor types
echo -e "${YELLOW}Creating cursor symlinks...${NC}"

# List of cursor names that should use the default cursor
CURSOR_SYMLINKS=(
    "arrow"
    "top_left_arrow"
    "right_ptr"
    "context-menu"
    "default"
    "pointer"
    "pointing_hand"
    "hand1"
    "hand2"
    "openhand"
    "closedhand"
    "dnd-none"
    "dnd-copy"
    "dnd-move"
    "dnd-link"
    "help"
    "question_arrow"
    "whats_this"
    "progress"
    "wait"
    "watch"
    "cell"
    "crosshair"
    "text"
    "vertical-text"
    "alias"
    "copy"
    "move"
    "no-drop"
    "not-allowed"
    "grab"
    "grabbing"
    "e-resize"
    "n-resize"
    "ne-resize"
    "nw-resize"
    "s-resize"
    "se-resize"
    "sw-resize"
    "w-resize"
    "ew-resize"
    "ns-resize"
    "nesw-resize"
    "nwse-resize"
    "col-resize"
    "row-resize"
    "all-scroll"
    "zoom-in"
    "zoom-out"
)

# Create symlinks
for cursor in "${CURSOR_SYMLINKS[@]}"; do
    if [ "$cursor" != "left_ptr" ]; then
        ln -sf "left_ptr" "$CURSOR_DIR/cursors/$cursor"
    fi
done

echo -e "${GREEN}Created cursor symlinks.${NC}"

# Create text cursor
create_cursor "text_cursor" 32 16 16 "#FF8000" "$CURSOR_DIR/cursors/xterm"

# Create symlinks for text cursor
TEXT_CURSOR_SYMLINKS=(
    "ibeam"
    "text"
)

for cursor in "${TEXT_CURSOR_SYMLINKS[@]}"; do
    if [ "$cursor" != "xterm" ]; then
        ln -sf "xterm" "$CURSOR_DIR/cursors/$cursor"
    fi
done

# Create busy cursor
create_cursor "busy_cursor" 32 16 16 "#FF0000" "$CURSOR_DIR/cursors/watch"

# Create symlinks for busy cursor
BUSY_CURSOR_SYMLINKS=(
    "wait"
    "progress"
)

for cursor in "${BUSY_CURSOR_SYMLINKS[@]}"; do
    if [ "$cursor" != "watch" ]; then
        ln -sf "watch" "$CURSOR_DIR/cursors/$cursor"
    fi
done

# Create hand cursor
create_cursor "hand_cursor" 32 16 16 "#00FF00" "$CURSOR_DIR/cursors/hand"

# Create symlinks for hand cursor
HAND_CURSOR_SYMLINKS=(
    "pointer"
    "pointing_hand"
    "hand1"
    "hand2"
)

for cursor in "${HAND_CURSOR_SYMLINKS[@]}"; do
    if [ "$cursor" != "hand" ]; then
        ln -sf "hand" "$CURSOR_DIR/cursors/$cursor"
    fi
done

# Clean up temporary files
rm -rf "$TEMP_DIR"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Atma Weapon cursor theme created successfully!${NC}"
echo -e "${YELLOW}Cursor theme installed to: $CURSOR_DIR${NC}"
echo -e "${BLUE}=========================================${NC}"

# Set cursor theme
echo -e "${YELLOW}Setting cursor theme...${NC}"

# Update GTK settings
GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"
mkdir -p "$(dirname "$GTK_SETTINGS")"

if [ -f "$GTK_SETTINGS" ]; then
    # Check if cursor theme is already set
    if grep -q "gtk-cursor-theme-name" "$GTK_SETTINGS"; then
        # Update existing setting
        sed -i 's/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=AtmaWeapon/' "$GTK_SETTINGS"
    else
        # Add setting
        echo "gtk-cursor-theme-name=AtmaWeapon" >> "$GTK_SETTINGS"
    fi
else
    # Create new settings file
    cat > "$GTK_SETTINGS" << EOF
[Settings]
gtk-cursor-theme-name=AtmaWeapon
gtk-cursor-theme-size=24
EOF
fi

echo -e "${GREEN}GTK cursor theme set.${NC}"

# Update environment variables
ENV_FILES=("$HOME/.profile" "$HOME/.bash_profile" "$HOME/.zprofile" "$HOME/.config/hypr/env.conf")

for ENV_FILE in "${ENV_FILES[@]}"; do
    if [ -f "$ENV_FILE" ]; then
        # Check if cursor theme is already set
        if grep -q "XCURSOR_THEME=" "$ENV_FILE"; then
            # Update existing setting
            sed -i 's/XCURSOR_THEME=.*/XCURSOR_THEME=AtmaWeapon/' "$ENV_FILE"
        else
            # Add setting
            echo "export XCURSOR_THEME=AtmaWeapon" >> "$ENV_FILE"
        fi
        
        # Check if cursor size is already set
        if grep -q "XCURSOR_SIZE=" "$ENV_FILE"; then
            # Update existing setting
            sed -i 's/XCURSOR_SIZE=.*/XCURSOR_SIZE=24/' "$ENV_FILE"
        else
            # Add setting
            echo "export XCURSOR_SIZE=24" >> "$ENV_FILE"
        fi
    fi
done

echo -e "${GREEN}Environment variables set.${NC}"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Atma Weapon cursor theme setup complete!${NC}"
echo -e "${YELLOW}Log out and back in for changes to take effect.${NC}"
echo -e "${BLUE}=========================================${NC}"
