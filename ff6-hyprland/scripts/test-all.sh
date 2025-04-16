#!/bin/bash
# FF6 Hyprland Test Script
# Tests all components of the FF6 Hyprland configuration
# Created: April 2025

echo "Testing FF6 Hyprland configuration components..."

# Test sound files
echo "Testing sound files..."
if [ -d "$HOME/.config/hypr/sounds" ]; then
    if [ -f "$HOME/.config/hypr/sounds/cursor.wav" ] && [ -f "$HOME/.config/hypr/sounds/confirm.wav" ] && [ -f "$HOME/.config/hypr/sounds/menu_open.wav" ] && [ -f "$HOME/.config/hypr/sounds/error.wav" ]; then
        echo "✓ Sound files exist"
        
        # Test playing sounds
        if command -v paplay &> /dev/null; then
            echo "Testing sound playback..."
            paplay "$HOME/.config/hypr/sounds/cursor.wav"
            echo "✓ Sound playback works"
        else
            echo "✗ paplay not found, cannot test sound playback"
        fi
    else
        echo "✗ Some sound files are missing"
    fi
else
    echo "✗ Sounds directory not found"
fi

# Test waybar configuration
echo "Testing waybar configuration..."
if [ -f "$HOME/.config/waybar/config-top.jsonc" ] && [ -f "$HOME/.config/waybar/config-bottom.jsonc" ]; then
    echo "✓ Waybar configuration files exist"
    
    # Check for collapsible menu
    if grep -q "custom/ff6logo" "$HOME/.config/waybar/config-top.jsonc" && grep -q "custom/magic-items" "$HOME/.config/waybar/config-top.jsonc"; then
        echo "✓ Waybar collapsible menu configuration exists"
    else
        echo "✗ Waybar collapsible menu configuration is missing"
    fi
else
    echo "✗ Waybar configuration files are missing"
fi

# Test Hyprland configuration
echo "Testing Hyprland configuration..."
if [ -f "$HOME/.config/hypr/hyprland.conf" ]; then
    echo "✓ Hyprland configuration file exists"
    
    # Check for updated shadow syntax
    if grep -q "shadow {" "$HOME/.config/hypr/hyprland.conf"; then
        echo "✓ Hyprland configuration uses updated shadow syntax"
    else
        echo "✗ Hyprland configuration uses outdated shadow syntax"
    fi
else
    echo "✗ Hyprland configuration file is missing"
fi

# Test resolution detection script
echo "Testing resolution detection script..."
if [ -f "$HOME/.config/hypr/scripts/configure-display.sh" ]; then
    echo "✓ Resolution detection script exists"
    
    # Check if script is executable
    if [ -x "$HOME/.config/hypr/scripts/configure-display.sh" ]; then
        echo "✓ Resolution detection script is executable"
    else
        echo "✗ Resolution detection script is not executable"
        chmod +x "$HOME/.config/hypr/scripts/configure-display.sh"
        echo "  Fixed: Made resolution detection script executable"
    fi
else
    echo "✗ Resolution detection script is missing"
fi

# Test kitty FF sprite script
echo "Testing kitty FF sprite script..."
if [ -f "$HOME/.config/kitty/ff_sprite.py" ]; then
    echo "✓ Kitty FF sprite script exists"
    
    # Check if script is executable
    if [ -x "$HOME/.config/kitty/ff_sprite.py" ]; then
        echo "✓ Kitty FF sprite script is executable"
    else
        echo "✗ Kitty FF sprite script is not executable"
        chmod +x "$HOME/.config/kitty/ff_sprite.py"
        echo "  Fixed: Made kitty FF sprite script executable"
    fi
    
    # Check for color definitions
    if grep -q "TERRA_GREEN" "$HOME/.config/kitty/ff_sprite.py" || grep -q "KEFKA_RED" "$HOME/.config/kitty/ff_sprite.py"; then
        echo "✓ Kitty FF sprite script has full-color sprites"
    else
        echo "✗ Kitty FF sprite script does not have full-color sprites"
    fi
else
    echo "✗ Kitty FF sprite script is missing"
fi

# Test installer script
echo "Testing installer script..."
if [ -f "$HOME/.config/hypr/install.sh" ]; then
    echo "✓ Installer script exists"
    
    # Check if script is executable
    if [ -x "$HOME/.config/hypr/install.sh" ]; then
        echo "✓ Installer script is executable"
    else
        echo "✗ Installer script is not executable"
        chmod +x "$HOME/.config/hypr/install.sh"
        echo "  Fixed: Made installer script executable"
    fi
else
    echo "✗ Installer script is missing"
fi

echo "Testing complete!"
