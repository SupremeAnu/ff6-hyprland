#!/bin/bash
# FF6 Hyprland Fix Window Switching Script
# Ensures Alt+Tab window switching works properly
# Created: April 2025

# Check if keybinds.conf exists
if [ ! -f "$HOME/.config/hypr/keybinds.conf" ]; then
    echo "Error: keybinds.conf not found!"
    exit 1
fi

# Add Alt+Tab window switching if not already present
if ! grep -q "bind = ALT, Tab," "$HOME/.config/hypr/keybinds.conf"; then
    echo "Adding Alt+Tab window switching to keybinds.conf..."
    echo "" >> "$HOME/.config/hypr/keybinds.conf"
    echo "# Window switching with Alt+Tab" >> "$HOME/.config/hypr/keybinds.conf"
    echo "bind = ALT, Tab, cyclenext," >> "$HOME/.config/hypr/keybinds.conf"
    echo "bind = ALT SHIFT, Tab, cyclenext, prev" >> "$HOME/.config/hypr/keybinds.conf"
    echo "Window switching keybinds added successfully!"
else
    echo "Alt+Tab window switching already configured."
fi

# Ensure Super+Q closes windows if not already present
if ! grep -q "bind = SUPER, Q," "$HOME/.config/hypr/keybinds.conf"; then
    echo "Adding Super+Q window closing to keybinds.conf..."
    echo "" >> "$HOME/.config/hypr/keybinds.conf"
    echo "# Close window with Super+Q" >> "$HOME/.config/hypr/keybinds.conf"
    echo "bind = SUPER, Q, killactive," >> "$HOME/.config/hypr/keybinds.conf"
    echo "Window closing keybind added successfully!"
else
    echo "Super+Q window closing already configured."
fi

echo "Window switching configuration complete!"
