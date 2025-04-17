#!/bin/bash
# Script to integrate FF6 sprite images into the configuration
# Part of FF6 Hyprland Configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
KITTY_DIR="$CONFIG_DIR/kitty"
SPRITES_DIR="$HYPR_DIR/sprites"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Sprite Integration               ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Check if Python and PIL are installed
echo -e "${YELLOW}Checking for Python and PIL/Pillow...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed.${NC}"
    echo -e "${YELLOW}Please install Python 3 first:${NC}"
    echo -e "  - Arch: sudo pacman -S python"
    echo -e "  - Debian/Ubuntu: sudo apt install python3"
    echo -e "  - Fedora: sudo dnf install python3"
    exit 1
fi

# Check for PIL/Pillow
python3 -c "import PIL" &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}PIL/Pillow not found. Installing...${NC}"
    if command -v pip3 &> /dev/null; then
        pip3 install Pillow
    else
        echo -e "${RED}Error: pip3 not found. Please install pip3 first:${NC}"
        echo -e "  - Arch: sudo pacman -S python-pip"
        echo -e "  - Debian/Ubuntu: sudo apt install python3-pip"
        echo -e "  - Fedora: sudo dnf install python3-pip"
        exit 1
    fi
else
    echo -e "${GREEN}PIL/Pillow is already installed.${NC}"
fi

# Create sprites directory if it doesn't exist
if [ ! -d "$SPRITES_DIR" ]; then
    echo -e "${YELLOW}Creating sprites directory...${NC}"
    mkdir -p "$SPRITES_DIR"
fi

# Copy sprite images to the sprites directory
echo -e "${YELLOW}Copying sprite images...${NC}"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_SPRITES_DIR="$SCRIPT_DIR/../sprites"

if [ -d "$REPO_SPRITES_DIR" ]; then
    cp -r "$REPO_SPRITES_DIR"/* "$SPRITES_DIR"/ 2>/dev/null || true
    echo -e "${GREEN}Sprite images copied to $SPRITES_DIR${NC}"
else
    echo -e "${YELLOW}Warning: Sprite directory not found in repository.${NC}"
fi

# Check if the pixel sprite converter script exists
CONVERTER_SCRIPT="$SCRIPT_DIR/pixel-sprite-converter.py"
if [ -f "$CONVERTER_SCRIPT" ]; then
    echo -e "${YELLOW}Copying pixel sprite converter script...${NC}"
    cp "$CONVERTER_SCRIPT" "$HYPR_DIR/scripts/" 2>/dev/null || true
    chmod +x "$HYPR_DIR/scripts/pixel-sprite-converter.py" 2>/dev/null || true
    echo -e "${GREEN}Pixel sprite converter script copied.${NC}"
else
    echo -e "${YELLOW}Warning: Pixel sprite converter script not found.${NC}"
fi

# Generate sprite code for kitty terminal
echo -e "${YELLOW}Generating sprite code for kitty terminal...${NC}"
SPRITE_CODE_DIR="$HYPR_DIR/sprite_code"
mkdir -p "$SPRITE_CODE_DIR"

# Process each sprite image
for sprite in "$SPRITES_DIR"/*.png; do
    if [ -f "$sprite" ]; then
        filename=$(basename "$sprite")
        character_name="${filename%.*}"
        echo -e "${YELLOW}Processing $character_name sprite...${NC}"
        
        if [ -f "$HYPR_DIR/scripts/pixel-sprite-converter.py" ]; then
            python3 "$HYPR_DIR/scripts/pixel-sprite-converter.py" "$sprite" "${character_name^^}" 1.0
            if [ -f "$(dirname "$sprite")/${character_name}_sprite.txt" ]; then
                mv "$(dirname "$sprite")/${character_name}_sprite.txt" "$SPRITE_CODE_DIR/"
                echo -e "${GREEN}Generated sprite code for $character_name${NC}"
            fi
        else
            echo -e "${YELLOW}Warning: Pixel sprite converter script not available.${NC}"
        fi
    fi
done

# Update kitty configuration to use the sprites
echo -e "${YELLOW}Updating kitty configuration...${NC}"
if [ -f "$KITTY_DIR/ff_sprite.py" ]; then
    # Backup the original script
    cp "$KITTY_DIR/ff_sprite.py" "$KITTY_DIR/ff_sprite.py.bak"
    
    # Create a new script that includes the generated sprite code
    cat > "$KITTY_DIR/ff_sprite_updated.py" << 'EOF'
#!/usr/bin/env python3
# FF6 Character Sprite Display for Kitty Terminal
# Displays a random FF6 character sprite with time information
# Created: April 2025
# Enhanced with authentic FF6 sprites

import random
import time
import os
import sys
from datetime import datetime

# ANSI color codes for vibrant FF6 character colors
# Using authentic character-specific colors
COLORS = {
    # Character-specific colors
    'TERRA': '\033[38;2;107;234;89m',   # Green hair/magic
    'LOCKE': '\033[38;2;173;216;230m',  # Blue bandana
    'EDGAR': '\033[38;2;218;165;32m',   # Royal gold
    'SABIN': '\033[38;2;255;140;0m',    # Monk orange
    'CYAN': '\033[38;2;0;191;255m',     # Samurai blue
    'SHADOW': '\033[38;2;128;0;128m',   # Ninja purple
    'GAU': '\033[38;2;139;69;19m',      # Wild child brown
    'CELES': '\033[38;2;255;255;224m',  # Ice white/yellow
    'SETZER': '\033[38;2;192;192;192m', # Silver gambler
    'MOG': '\033[38;2;255;182;193m',    # Pink moogle
    'KEFKA': '\033[38;2;255;0;0m',      # Villain red
    'ULTROS': '\033[38;2;128;0;128m',   # Purple octopus
    'UMARO': '\033[38;2;173;216;230m',  # Ice blue yeti
    'GOGO': '\033[38;2;255;215;0m',     # Golden mimic
    'RELM': '\033[38;2;255;105;180m',   # Artist pink
    'STRAGO': '\033[38;2;65;105;225m',  # Blue mage
    # General colors
    'RESET': '\033[0m',
    'BOLD': '\033[1m',
    'TIME': '\033[38;2;255;215;0m',     # Gold for time display
    'DATE': '\033[38;2;135;206;250m',   # Light blue for date
    # Additional colors for details
    'SKIN': '\033[38;2;255;222;173m',   # Skin tone
    'HAIR_BROWN': '\033[38;2;139;69;19m', # Brown hair
    'HAIR_BLONDE': '\033[38;2;255;215;0m', # Blonde hair
    'ARMOR': '\033[38;2;169;169;169m',  # Silver armor
    'CLOTH': '\033[38;2;220;220;220m',  # White cloth
    'FIRE': '\033[38;2;255;69;0m',      # Fire magic
    'ICE': '\033[38;2;135;206;250m',    # Ice magic
    'LIGHTNING': '\033[38;2;255;255;0m', # Lightning magic
    'ESPER': '\033[38;2;138;43;226m',   # Esper/magic
}

# Default sprites in case generated ones are not available
SPRITES = {
    'TERRA': [
        f"{COLORS['TERRA']}      ▄▄▄▄▄▄      ",
        f"{COLORS['TERRA']}    ▄████████▄    ",
        f"{COLORS['TERRA']}   ████{COLORS['ESPER']}▄▄▄▄{COLORS['TERRA']}████   ",
        f"{COLORS['TERRA']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['TERRA']}████  ",
        f"{COLORS['TERRA']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['TERRA']}███  ",
        f"{COLORS['TERRA']}  ▀█████████████▀  ",
        f"{COLORS['TERRA']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['TERRA']}      ▄▄███▄▄      ",
        f"{COLORS['TERRA']}     ▄███████▄     ",
        f"{COLORS['TERRA']}    ▄█████████▄    ",
        f"{COLORS['TERRA']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['ESPER']}  ✧ Esper Power ✧  {COLORS['RESET']}",
    ],
    'LOCKE': [
        f"{COLORS['LOCKE']}      ▄▄▄▄▄▄      ",
        f"{COLORS['LOCKE']}    ▄████████▄    ",
        f"{COLORS['LOCKE']}   ████{COLORS['HAIR_BROWN']}▄▄▄▄{COLORS['LOCKE']}████   ",
        f"{COLORS['LOCKE']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['LOCKE']}████  ",
        f"{COLORS['LOCKE']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['LOCKE']}███  ",
        f"{COLORS['LOCKE']}  ▀█████████████▀  ",
        f"{COLORS['LOCKE']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['LOCKE']}      ▄▄███▄▄      ",
        f"{COLORS['LOCKE']}     ▄███████▄     ",
        f"{COLORS['LOCKE']}    ▄█████████▄    ",
        f"{COLORS['LOCKE']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['LOCKE']}  ⚔ Treasure Hunter ⚔  {COLORS['RESET']}",
    ],
}

# Try to load generated sprite code
def load_generated_sprites():
    """Load generated sprite code if available"""
    sprite_code_dir = os.path.expanduser("~/.config/hypr/sprite_code")
    if not os.path.exists(sprite_code_dir):
        return
    
    for sprite_file in os.listdir(sprite_code_dir):
        if sprite_file.endswith("_sprite.txt"):
            character_name = sprite_file.split("_")[0].upper()
            try:
                with open(os.path.join(sprite_code_dir, sprite_file), 'r') as f:
                    content = f.read()
                    # Extract the sprite lines
                    lines = content.split("\n")
                    if len(lines) > 2:  # At least character name and one line
                        sprite_lines = []
                        for line in lines[1:-1]:  # Skip first and last line
                            line = line.strip()
                            if line.endswith(","):
                                line = line[:-1]
                            if line.startswith("    f\"") and line.endswith("\""):
                                sprite_lines.append(eval(line[4:]))
                        
                        if sprite_lines:
                            SPRITES[character_name] = sprite_lines
                            print(f"Loaded sprite for {character_name}")
            except Exception as e:
                print(f"Error loading sprite for {character_name}: {e}")

# Try to load generated sprites
try:
    load_generated_sprites()
except Exception as e:
    print(f"Error loading generated sprites: {e}")

def get_random_sprite():
    """Return a random character sprite"""
    character = random.choice(list(SPRITES.keys()))
    return SPRITES[character]

def get_time_info():
    """Get current time and date information"""
    now = datetime.now()
    time_str = now.strftime("%H:%M:%S")
    date_str = now.strftime("%A, %B %d, %Y")
    return time_str, date_str

def display_sprite_with_time():
    """Display a random sprite with time information"""
    sprite = get_random_sprite()
    time_str, date_str = get_time_info()
    
    # Print some space before the sprite
    print("\n\n")
    
    # Print the sprite
    for line in sprite:
        print(line)
    
    # Print time and date
    print(f"\n{COLORS['TIME']}{COLORS['BOLD']}Time: {time_str}{COLORS['RESET']}")
    print(f"{COLORS['DATE']}Date: {date_str}{COLORS['RESET']}")
    
    # Print some space after
    print("\n")

if __name__ == "__main__":
    try:
        display_sprite_with_time()
    except Exception as e:
        print(f"Error displaying FF6 sprite: {e}")
EOF

    # Replace the original script with the updated one
    mv "$KITTY_DIR/ff_sprite_updated.py" "$KITTY_DIR/ff_sprite.py"
    chmod +x "$KITTY_DIR/ff_sprite.py"
    echo -e "${GREEN}Updated kitty configuration to use the sprites.${NC}"
else
    echo -e "${YELLOW}Warning: ff_sprite.py not found in kitty configuration.${NC}"
fi

# Final summary
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}FF6 sprite integration complete!${NC}"
echo -e "${YELLOW}The sprites will be displayed in the kitty terminal on startup.${NC}"
echo -e "${BLUE}=========================================${NC}"
