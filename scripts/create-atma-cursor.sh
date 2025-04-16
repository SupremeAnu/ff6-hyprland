#!/bin/bash
# Create Atma Weapon Cursor from Final Fantasy 6
# Theme: Final Fantasy VI Menu Style
# Created: April 2025

# Create cursor directory
CURSOR_DIR="/home/ubuntu/hyprland-crimson-config/cursor"
mkdir -p "$CURSOR_DIR"
mkdir -p "$CURSOR_DIR/AtmaWeapon"

# Create cursor theme index file
cat > "$CURSOR_DIR/AtmaWeapon/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=Atma Weapon Sword Cursor from Final Fantasy 6
Inherits=Adwaita
EOF

# Create cursor directory
mkdir -p "$CURSOR_DIR/AtmaWeapon/cursors"

# Create SVG for Atma Weapon cursor
cat > "$CURSOR_DIR/AtmaWeapon/atma_weapon.svg" << EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">
  <defs>
    <linearGradient id="blueGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4080FF;stop-opacity:1" />
      <stop offset="60%" style="stop-color:#2050C0;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#102080;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Atma Weapon Sword from FF6 -->
  <g transform="translate(0,0) scale(0.8)">
    <!-- Sword Handle -->
    <rect x="14" y="22" width="4" height="8" fill="#8B4513" />
    <rect x="13" y="22" width="6" height="2" fill="#DAA520" />
    
    <!-- Sword Guard -->
    <rect x="11" y="20" width="10" height="2" fill="#DAA520" />
    
    <!-- Sword Blade -->
    <path d="M16 2 L19 20 L13 20 Z" fill="url(#blueGradient)" />
    
    <!-- Sword Glow -->
    <path d="M16 2 L19 20 L13 20 Z" fill="none" stroke="#4080FF" stroke-width="0.5" opacity="0.7" />
    
    <!-- Sword Highlight -->
    <path d="M16 2 L17 20" fill="none" stroke="#FFFFFF" stroke-width="0.5" opacity="0.5" />
  </g>
  
  <!-- Hotspot marker (invisible in actual cursor) -->
  <circle cx="16" cy="4" r="1" fill="#FF0000" opacity="0" />
</svg>
EOF

# Create X11 cursor configuration file
cat > "$CURSOR_DIR/AtmaWeapon/cursor.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=Atma Weapon Sword Cursor from Final Fantasy 6
Inherits=Adwaita
EOF

echo "Created Atma Weapon cursor theme files"
echo "To use this cursor, you'll need to install xcursorgen and convert the SVG to X11 cursor format"
echo "Then update your GTK and Hyprland configurations to use the new cursor theme"

# Update GTK settings to use the new cursor theme
sed -i 's/gtk-cursor-theme-name=Adwaita/gtk-cursor-theme-name=AtmaWeapon/g' "/home/ubuntu/hyprland-crimson-config/gtk-themes/settings.ini"

# Update Hyprland configuration to use the new cursor theme
cat >> "/home/ubuntu/hyprland-crimson-config/hypr/hyprland.conf" << EOF

# Custom cursor theme
env = XCURSOR_THEME,AtmaWeapon
env = XCURSOR_SIZE,24
EOF

echo "Configuration files updated to use the Atma Weapon cursor theme"

# Create a simple cursor configuration file for X11
cat > "$CURSOR_DIR/AtmaWeapon/cursors/left_ptr" << EOF
Xcur 0 0 16 4
32 32 16 4 1 0 0 atma_weapon.svg
EOF

echo "Created cursor configuration file"
