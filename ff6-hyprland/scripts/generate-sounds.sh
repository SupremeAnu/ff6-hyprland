#!/bin/bash
# Script to generate FF6 sound effects
# Created: April 2025

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
SOUNDS_DIR="$HYPR_DIR/sounds"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Sound Effects Generator           ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if sox is installed
if ! command_exists sox; then
    echo -e "${RED}Error: Sox not installed. Cannot generate sound effects.${NC}"
    echo -e "${RED}Please install sox and try again.${NC}"
    exit 1
fi

# Create sounds directory
mkdir -p "$SOUNDS_DIR"

echo -e "${YELLOW}Generating FF6 sound effects...${NC}"

# Generate FF6-style cursor sound using SoX
echo -e "${YELLOW}Generating cursor sound...${NC}"
sox -n "$SOUNDS_DIR/cursor.wav" synth 0.05 sine 1200 fade 0 0.05 0.02 vol 0.5

# Generate FF6-style confirm sound using SoX
echo -e "${YELLOW}Generating confirm sound...${NC}"
sox -n "$SOUNDS_DIR/confirm.wav" synth 0.1 sine 800:1200 fade 0 0.1 0.03 vol 0.5

# Generate FF6-style menu open sound
echo -e "${YELLOW}Generating menu open sound...${NC}"
sox -n "$SOUNDS_DIR/menu_open.wav" synth 0.15 sine 600:900 fade 0 0.15 0.05 vol 0.5

# Generate FF6-style error sound
echo -e "${YELLOW}Generating error sound...${NC}"
sox -n "$SOUNDS_DIR/error.wav" synth 0.2 sine 300:200 fade 0 0.2 0.05 vol 0.5

# Generate FF6-style battle start sound
echo -e "${YELLOW}Generating battle start sound...${NC}"
sox -n "$SOUNDS_DIR/battle.wav" synth 0.3 sine 400:800:400 fade 0 0.3 0.1 vol 0.6

# Generate FF6-style victory sound
echo -e "${YELLOW}Generating victory sound...${NC}"
sox -n "$SOUNDS_DIR/victory.wav" synth 0.5 sine 600:900:1200 fade 0 0.5 0.2 vol 0.6

# Generate FF6-style save sound
echo -e "${YELLOW}Generating save sound...${NC}"
sox -n "$SOUNDS_DIR/save.wav" synth 0.4 sine 800:1000:1200 fade 0 0.4 0.1 vol 0.5

echo -e "${GREEN}All sound effects generated successfully!${NC}"
echo -e "${YELLOW}Sound files saved to: $SOUNDS_DIR${NC}"

# List generated files
echo -e "${YELLOW}Generated files:${NC}"
ls -la "$SOUNDS_DIR"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}FF6 sound effects generation complete!${NC}"
echo -e "${BLUE}=========================================${NC}"
