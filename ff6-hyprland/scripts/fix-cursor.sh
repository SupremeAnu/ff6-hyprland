#!/bin/bash
# FF6-Themed Hyprland Configuration - Fix Cursor Script
# This script ensures the AtmaWeapon cursor theme is properly installed and configured

# Create necessary directories
mkdir -p ~/.icons
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

# Check if AtmaWeapon cursor theme is already installed
if [ ! -d ~/.icons/AtmaWeapon ]; then
    echo "Installing AtmaWeapon cursor theme..."
    # Copy the cursor theme to the user's icons directory
    cp -r ~/.config/hyprland-crimson-config/cursor/AtmaWeapon ~/.icons/
else
    echo "AtmaWeapon cursor theme already installed."
fi

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

# Create a symbolic link to ensure the cursor theme is found
mkdir -p ~/.local/share/icons
ln -sf ~/.icons/AtmaWeapon ~/.local/share/icons/AtmaWeapon

# Update index.theme file to ensure proper cursor loading
cat > ~/.icons/default/index.theme << EOF
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=AtmaWeapon
EOF

# Ensure the cursor theme is set in Hyprland config
if ! grep -q "XCURSOR_THEME=AtmaWeapon" ~/.config/hypr/hyprland.conf; then
    echo "Adding cursor theme to Hyprland config..."
    echo "env = XCURSOR_THEME,AtmaWeapon" >> ~/.config/hypr/hyprland.conf
    echo "env = XCURSOR_SIZE,24" >> ~/.config/hypr/hyprland.conf
fi

echo "Cursor theme has been configured successfully!"
echo "Please restart Hyprland for changes to take effect."
