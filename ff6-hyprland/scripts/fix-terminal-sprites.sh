#!/bin/bash
# FF6-Themed Hyprland Configuration - Terminal Character Sprites Script
# This script ensures the FF6 character sprites display properly in the kitty terminal

# Create necessary directories
mkdir -p ~/.config/kitty

# Check if the FF6 sprite script is already installed
if [ ! -f ~/.config/kitty/ff_sprite.py ]; then
    echo "Installing FF6 character sprite script..."
    # Copy the sprite script to the user's kitty config directory
    cp -f ~/.config/hyprland-crimson-config/kitty/ff_sprite.py ~/.config/kitty/
else
    echo "Updating FF6 character sprite script..."
    cp -f ~/.config/hyprland-crimson-config/kitty/ff_sprite.py ~/.config/kitty/
fi

# Make the script executable
chmod +x ~/.config/kitty/ff_sprite.py

# Create a directory for sprites if it doesn't exist
mkdir -p ~/.config/kitty/sprites

# Copy the kitty configuration
if [ -f ~/.config/kitty/kitty.conf ]; then
    # Backup existing config
    cp ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak
fi

# Copy the new kitty configuration
cp -f ~/.config/hyprland-crimson-config/kitty/kitty.conf ~/.config/kitty/

# Create a test script to verify the sprites work
cat > ~/.config/kitty/test_sprite.sh << 'EOF'
#!/bin/bash
echo "Testing FF6 character sprites in kitty terminal..."
python3 ~/.config/kitty/ff_sprite.py
echo "If you see a character sprite above, the script is working correctly!"
echo "If not, please check the error messages and ensure Python and required packages are installed."
EOF

chmod +x ~/.config/kitty/test_sprite.sh

# Install required Python packages
pip3 install pillow --user

echo "FF6 character sprites have been configured successfully!"
echo "To test the sprites, run: ~/.config/kitty/test_sprite.sh"
echo "Or restart your kitty terminal to see the sprites automatically."
