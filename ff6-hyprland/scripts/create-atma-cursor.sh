#!/bin/bash
# FF6 Hyprland Cursor Creation Script
# Creates Atma Weapon cursor theme for FF6 Hyprland configuration
# Created: April 2025

echo "Creating Atma Weapon cursor theme..."

# Set up directories
CURSOR_DIR="$HOME/.local/share/icons/AtmaWeapon"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_DIR=$(mktemp -d)

# Create cursor directory structure
mkdir -p "$CURSOR_DIR/cursors"

# Check for required tools
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick (convert) is required but not installed."
    echo "Please install ImageMagick and try again."
    exit 1
fi

if ! command -v xcursorgen &> /dev/null; then
    echo "Error: xcursorgen is required but not installed."
    echo "Please install xcursorgen and try again."
    exit 1
fi

# Create cursor theme files
cat > "$CURSOR_DIR/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6-themed cursor from Atma Weapon
Inherits=Adwaita
EOF

cat > "$CURSOR_DIR/cursor.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6-themed cursor from Atma Weapon
EOF

# Create cursor images
echo "Creating cursor images..."

# Function to create a cursor
create_cursor() {
    local name=$1
    local hotspot_x=$2
    local hotspot_y=$3
    local size=$4
    local color=$5
    local shape=$6
    
    # Create cursor image
    case "$shape" in
        "pointer")
            # Create a sword-like pointer (Atma Weapon inspired)
            convert -size ${size}x${size} xc:transparent \
                -fill "$color" \
                -draw "polygon $(($hotspot_x-2)),$(($hotspot_y-2)) $(($hotspot_x+8)),$(($hotspot_y+8)) $(($hotspot_x+2)),$(($hotspot_y+12)) $(($hotspot_x-4)),$(($hotspot_y+4))" \
                -draw "line $(($hotspot_x-2)),$(($hotspot_y-2)) $(($hotspot_x-6)),$(($hotspot_y-6))" \
                "$TEMP_DIR/${name}_${size}.png"
            ;;
        "beam")
            # Create a text cursor (I-beam)
            convert -size ${size}x${size} xc:transparent \
                -fill "$color" \
                -draw "rectangle $(($hotspot_x-1)),$(($hotspot_y-10)) $(($hotspot_x+1)),$(($hotspot_y+10))" \
                -draw "line $(($hotspot_x-5)),$(($hotspot_y-10)) $(($hotspot_x+5)),$(($hotspot_y-10))" \
                -draw "line $(($hotspot_x-5)),$(($hotspot_y+10)) $(($hotspot_x+5)),$(($hotspot_y+10))" \
                "$TEMP_DIR/${name}_${size}.png"
            ;;
        "hand")
            # Create a hand cursor
            convert -size ${size}x${size} xc:transparent \
                -fill "$color" \
                -draw "circle $(($hotspot_x)),$(($hotspot_y)) $(($hotspot_x+6)),$(($hotspot_y))" \
                -draw "rectangle $(($hotspot_x-6)),$(($hotspot_y)) $(($hotspot_x+6)),$(($hotspot_y+10))" \
                -draw "rectangle $(($hotspot_x-8)),$(($hotspot_y+8)) $(($hotspot_x-4)),$(($hotspot_y+12))" \
                -draw "rectangle $(($hotspot_x-4)),$(($hotspot_y+8)) $(($hotspot_x)),$(($hotspot_y+14))" \
                -draw "rectangle $(($hotspot_x)),$(($hotspot_y+8)) $(($hotspot_x+4)),$(($hotspot_y+14))" \
                -draw "rectangle $(($hotspot_x+4)),$(($hotspot_y+8)) $(($hotspot_x+8)),$(($hotspot_y+12))" \
                "$TEMP_DIR/${name}_${size}.png"
            ;;
        "wait")
            # Create a wait cursor (hourglass)
            convert -size ${size}x${size} xc:transparent \
                -fill "$color" \
                -draw "polygon $(($hotspot_x-8)),$(($hotspot_y-8)) $(($hotspot_x+8)),$(($hotspot_y-8)) $(($hotspot_x)),$(($hotspot_y)) $(($hotspot_x+8)),$(($hotspot_y+8)) $(($hotspot_x-8)),$(($hotspot_y+8)) $(($hotspot_x)),$(($hotspot_y))" \
                -draw "line $(($hotspot_x-8)),$(($hotspot_y-8)) $(($hotspot_x-8)),$(($hotspot_y+8))" \
                -draw "line $(($hotspot_x+8)),$(($hotspot_y-8)) $(($hotspot_x+8)),$(($hotspot_y+8))" \
                "$TEMP_DIR/${name}_${size}.png"
            ;;
        *)
            # Default to a simple pointer
            convert -size ${size}x${size} xc:transparent \
                -fill "$color" \
                -draw "polygon $(($hotspot_x-2)),$(($hotspot_y-2)) $(($hotspot_x+8)),$(($hotspot_y+8)) $(($hotspot_x+2)),$(($hotspot_y+12)) $(($hotspot_x-4)),$(($hotspot_y+4))" \
                "$TEMP_DIR/${name}_${size}.png"
            ;;
    esac
    
    # Create cursor config file
    echo "$size $hotspot_x $hotspot_y $TEMP_DIR/${name}_${size}.png" > "$TEMP_DIR/${name}.config"
}

# Create cursor config files for different cursor types
# Format: create_cursor name hotspot_x hotspot_y size color shape

# Main cursor (left_ptr)
create_cursor "left_ptr" 10 10 24 "#4080FF" "pointer"
create_cursor "text" 12 12 24 "#4080FF" "beam"
create_cursor "pointer" 10 10 24 "#4080FF" "pointer"
create_cursor "hand2" 12 8 24 "#4080FF" "hand"
create_cursor "wait" 12 12 24 "#4080FF" "wait"

# Generate cursors
echo "Generating cursor files..."
xcursorgen "$TEMP_DIR/left_ptr.config" "$CURSOR_DIR/cursors/left_ptr"
xcursorgen "$TEMP_DIR/text.config" "$CURSOR_DIR/cursors/text"
xcursorgen "$TEMP_DIR/pointer.config" "$CURSOR_DIR/cursors/pointer"
xcursorgen "$TEMP_DIR/hand2.config" "$CURSOR_DIR/cursors/hand2"
xcursorgen "$TEMP_DIR/wait.config" "$CURSOR_DIR/cursors/wait"

# Create symlinks for other cursor types
cd "$CURSOR_DIR/cursors"
for cursor in arrow default; do
    ln -sf left_ptr "$cursor"
done

for cursor in ibeam xterm; do
    ln -sf text "$cursor"
done

for cursor in hand pointing_hand; do
    ln -sf hand2 "$cursor"
done

for cursor in progress watch; do
    ln -sf wait "$cursor"
done

# Save the Atma Weapon SVG for reference
cat > "$CURSOR_DIR/atma_weapon.svg" << EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
  <title>Atma Weapon Cursor</title>
  <style>
    .sword { fill: #4080FF; stroke: #102080; stroke-width: 1; }
  </style>
  <g>
    <path class="sword" d="M 30,30 L 70,70 L 50,80 L 20,40 Z" />
    <path class="sword" d="M 30,30 L 10,10" />
  </g>
</svg>
EOF

# Clean up
rm -rf "$TEMP_DIR"

echo "Atma Weapon cursor theme created successfully!"
echo "Cursor theme is located at: $CURSOR_DIR"
echo
echo "To use the cursor theme:"
echo "1. Make sure the XCURSOR_THEME environment variable is set to 'AtmaWeapon'"
echo "2. Make sure the cursor theme is properly configured in your GTK settings"
echo "3. Log out and log back in to apply the changes"
