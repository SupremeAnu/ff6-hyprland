#!/bin/bash
# Create FF6-style sound effects for notifications and system interactions
# Theme: Final Fantasy VI Menu Style
# Created: April 2025

# Create directory for sounds
mkdir -p /home/ubuntu/hyprland-crimson-config/sounds

# Generate FF6-style cursor sound using SoX
echo "Generating FF6 cursor sound..."
sox -n /home/ubuntu/hyprland-crimson-config/sounds/cursor.wav synth 0.1 sine 1200 fade 0 0.1 0.05

# Generate FF6-style confirm sound using SoX
echo "Generating FF6 confirm sound..."
sox -n /home/ubuntu/hyprland-crimson-config/sounds/confirm.wav synth 0.15 sine 800:1200 fade 0 0.15 0.05

echo "Sound effects created successfully!"
