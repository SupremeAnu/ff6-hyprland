#!/bin/bash
# FF6 Hyprland Sound Generator Script
# Generates FF6 sound effects for the configuration
# Created: April 2025

# Set up sound directory
SOUND_DIR="$(dirname "$0")/../sounds"
mkdir -p "$SOUND_DIR"

echo "Generating FF6 sound effects..."

# Generate FF6-style cursor sound using SoX
echo "Generating cursor sound..."
sox -n "$SOUND_DIR/cursor.wav" synth 0.05 sine 1200 fade 0 0.05 0.02 vol 0.5
echo "Cursor sound generated."

# Generate FF6-style confirm sound using SoX
echo "Generating confirm sound..."
sox -n "$SOUND_DIR/confirm.wav" synth 0.1 sine 800:1200 fade 0 0.1 0.03 vol 0.5
echo "Confirm sound generated."

# Generate FF6-style menu open sound
echo "Generating menu open sound..."
sox -n "$SOUND_DIR/menu_open.wav" synth 0.15 sine 600:900 fade 0 0.15 0.05 vol 0.5
echo "Menu open sound generated."

# Generate FF6-style error sound
echo "Generating error sound..."
sox -n "$SOUND_DIR/error.wav" synth 0.2 sine 300:200 fade 0 0.2 0.05 vol 0.5
echo "Error sound generated."

echo "All FF6 sound effects generated successfully."
echo "Sound files are located in: $SOUND_DIR"
