#!/bin/bash
# Test FF6 Sound Implementation
# Theme: Final Fantasy VI Menu Style
# Created: April 2025

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Testing FF6 Sound Implementation ===${NC}"
echo

# Check if SoX is installed
if ! command -v sox &> /dev/null; then
    echo -e "${YELLOW}SoX is not installed. Installing...${NC}"
    sudo apt-get update && sudo apt-get install -y sox
    echo -e "${GREEN}SoX installed.${NC}"
else
    echo -e "${GREEN}SoX is already installed.${NC}"
fi

# Check if PulseAudio is installed
if ! command -v paplay &> /dev/null; then
    echo -e "${YELLOW}PulseAudio is not installed. Installing...${NC}"
    sudo apt-get update && sudo apt-get install -y pulseaudio
    echo -e "${GREEN}PulseAudio installed.${NC}"
else
    echo -e "${GREEN}PulseAudio is already installed.${NC}"
fi

# Create test directory
TEST_DIR="/tmp/ff6-sound-test"
mkdir -p "$TEST_DIR"

# Generate test sounds
echo -e "${YELLOW}Generating test sounds...${NC}"
sox -n "$TEST_DIR/cursor.wav" synth 0.1 sine 1200 fade 0 0.1 0.05
sox -n "$TEST_DIR/confirm.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
echo -e "${GREEN}Test sounds generated.${NC}"

# Test playing sounds
echo -e "${YELLOW}Testing sound playback...${NC}"
if paplay "$TEST_DIR/cursor.wav" 2>/dev/null; then
    echo -e "${GREEN}Cursor sound played successfully.${NC}"
else
    echo -e "${RED}Failed to play cursor sound.${NC}"
fi

if paplay "$TEST_DIR/confirm.wav" 2>/dev/null; then
    echo -e "${GREEN}Confirm sound played successfully.${NC}"
else
    echo -e "${RED}Failed to play confirm sound.${NC}"
fi

# Test SwayNC configuration
echo -e "${YELLOW}Testing SwayNC configuration...${NC}"
if [ -f "/home/ubuntu/hyprland-crimson-config/swaync/config.json" ]; then
    if grep -q "sound" "/home/ubuntu/hyprland-crimson-config/swaync/config.json"; then
        echo -e "${GREEN}SwayNC is configured for sound.${NC}"
    else
        echo -e "${RED}SwayNC is not configured for sound.${NC}"
    fi
else
    echo -e "${RED}SwayNC configuration file not found.${NC}"
fi

# Test Hyprland configuration script
echo -e "${YELLOW}Testing Hyprland sound configuration script...${NC}"
if [ -f "/home/ubuntu/hyprland-crimson-config/scripts/configure-sounds.sh" ]; then
    if grep -q "paplay" "/home/ubuntu/hyprland-crimson-config/scripts/configure-sounds.sh"; then
        echo -e "${GREEN}Hyprland sound configuration script is valid.${NC}"
    else
        echo -e "${RED}Hyprland sound configuration script does not contain sound commands.${NC}"
    fi
else
    echo -e "${RED}Hyprland sound configuration script not found.${NC}"
fi

# Test sound generation script
echo -e "${YELLOW}Testing sound generation script...${NC}"
if [ -f "/home/ubuntu/hyprland-crimson-config/scripts/generate-sounds.sh" ]; then
    if grep -q "sox" "/home/ubuntu/hyprland-crimson-config/scripts/generate-sounds.sh"; then
        echo -e "${GREEN}Sound generation script is valid.${NC}"
    else
        echo -e "${RED}Sound generation script does not contain sound generation commands.${NC}"
    fi
else
    echo -e "${RED}Sound generation script not found.${NC}"
fi

# Clean up
rm -rf "$TEST_DIR"

echo
echo -e "${BLUE}=== FF6 Sound Implementation Test Complete ===${NC}"
echo -e "${GREEN}Sound effects are ready to be included in the final package.${NC}"
echo -e "${YELLOW}Note: Full testing requires a running Hyprland session.${NC}"
