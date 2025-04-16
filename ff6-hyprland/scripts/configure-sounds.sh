#!/bin/bash
# Script to configure sound effects for FF6-themed Hyprland
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
echo -e "${BLUE}  FF6 Sound Effects Configuration       ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Detect audio system
detect_audio_system() {
    if command_exists pipewire || command_exists pw-play; then
        echo "pipewire"
    elif command_exists pulseaudio || command_exists paplay; then
        echo "pulseaudio"
    else
        echo "unknown"
    fi
}

# Create directory if it doesn't exist
create_dir() {
    if [ ! -d "$1" ]; then
        echo -e "${YELLOW}Creating directory $1${NC}"
        mkdir -p "$1"
        echo -e "${GREEN}Directory created.${NC}"
    fi
}

# Create sounds directory
create_dir "$SOUNDS_DIR"

# Check if sound files exist
if [ ! -f "$SOUNDS_DIR/cursor.wav" ] || [ ! -f "$SOUNDS_DIR/confirm.wav" ]; then
    echo -e "${YELLOW}Sound files not found. Generating...${NC}"
    
    # Check if sox is installed
    if ! command_exists sox; then
        echo -e "${RED}Error: Sox not installed. Cannot generate sound effects.${NC}"
        echo -e "${RED}Please install sox and try again.${NC}"
        exit 1
    fi
    
    # Generate FF6-style cursor sound using SoX
    sox -n "$SOUNDS_DIR/cursor.wav" synth 0.05 sine 1200 fade 0 0.05 0.02 vol 0.5
    
    # Generate FF6-style confirm sound using SoX
    sox -n "$SOUNDS_DIR/confirm.wav" synth 0.1 sine 800:1200 fade 0 0.1 0.03 vol 0.5
    
    # Generate FF6-style menu open sound
    sox -n "$SOUNDS_DIR/menu_open.wav" synth 0.15 sine 600:900 fade 0 0.15 0.05 vol 0.5
    
    # Generate FF6-style error sound
    sox -n "$SOUNDS_DIR/error.wav" synth 0.2 sine 300:200 fade 0 0.2 0.05 vol 0.5
    
    echo -e "${GREEN}Sound effects generated.${NC}"
else
    echo -e "${GREEN}Sound files already exist.${NC}"
fi

# Detect audio system
AUDIO_SYSTEM=$(detect_audio_system)
echo -e "${YELLOW}Detected audio system: $AUDIO_SYSTEM${NC}"

# Create sound player script based on detected audio system
echo -e "${YELLOW}Creating sound player script...${NC}"

cat > "$HYPR_DIR/scripts/play-sound.sh" << EOF
#!/bin/bash
# Script to play FF6 sounds for Hyprland actions
# Auto-generated for $AUDIO_SYSTEM audio system

SOUND_DIR="\$HOME/.config/hypr/sounds"

case "\$1" in
    "cursor")
        SOUND="\$SOUND_DIR/cursor.wav"
        ;;
    "confirm")
        SOUND="\$SOUND_DIR/confirm.wav"
        ;;
    "menu_open")
        SOUND="\$SOUND_DIR/menu_open.wav"
        ;;
    "error")
        SOUND="\$SOUND_DIR/error.wav"
        ;;
    *)
        echo "Unknown sound: \$1"
        exit 1
        ;;
esac

# Check if sound file exists
if [ ! -f "\$SOUND" ]; then
    echo "Sound file \$SOUND not found!"
    exit 1
fi

# Play sound based on detected audio system
EOF

# Add appropriate play command based on detected audio system
if [ "$AUDIO_SYSTEM" = "pipewire" ]; then
    cat >> "$HYPR_DIR/scripts/play-sound.sh" << EOF
# Using PipeWire
if command -v pw-play &> /dev/null; then
    pw-play "\$SOUND" &
elif command -v paplay &> /dev/null; then
    paplay "\$SOUND" &
elif command -v aplay &> /dev/null; then
    aplay "\$SOUND" &
else
    echo "No compatible audio player found!"
    exit 1
fi
EOF
elif [ "$AUDIO_SYSTEM" = "pulseaudio" ]; then
    cat >> "$HYPR_DIR/scripts/play-sound.sh" << EOF
# Using PulseAudio
if command -v paplay &> /dev/null; then
    paplay "\$SOUND" &
elif command -v aplay &> /dev/null; then
    aplay "\$SOUND" &
else
    echo "No compatible audio player found!"
    exit 1
fi
EOF
else
    cat >> "$HYPR_DIR/scripts/play-sound.sh" << EOF
# Using fallback method
if command -v paplay &> /dev/null; then
    paplay "\$SOUND" &
elif command -v aplay &> /dev/null; then
    aplay "\$SOUND" &
elif command -v play &> /dev/null; then
    play "\$SOUND" &
else
    echo "No compatible audio player found!"
    exit 1
fi
EOF
fi

# Make script executable
chmod +x "$HYPR_DIR/scripts/play-sound.sh"
echo -e "${GREEN}Sound player script created.${NC}"

# Create Hyprland keybind sound configuration
echo -e "${YELLOW}Creating Hyprland keybind sound configuration...${NC}"

cat > "$HYPR_DIR/sounds.conf" << EOF
# FF6 Sound Effects Configuration
# Auto-generated for $AUDIO_SYSTEM audio system

# Bind sounds to various Hyprland events
bind = , escape, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, Return, exec, ~/.config/hypr/scripts/play-sound.sh confirm
bind = SUPER, Q, exec, ~/.config/hypr/scripts/play-sound.sh confirm
bind = SUPER, Space, exec, ~/.config/hypr/scripts/play-sound.sh menu_open
bind = SUPER, Tab, exec, ~/.config/hypr/scripts/play-sound.sh cursor

# Add sound to workspace switching
bind = SUPER, 1, workspace, 1, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 2, workspace, 2, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 3, workspace, 3, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 4, workspace, 4, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 5, workspace, 5, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 6, workspace, 6, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 7, workspace, 7, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 8, workspace, 8, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 9, workspace, 9, exec, ~/.config/hypr/scripts/play-sound.sh cursor
bind = SUPER, 0, workspace, 10, exec, ~/.config/hypr/scripts/play-sound.sh cursor
EOF

echo -e "${GREEN}Hyprland keybind sound configuration created.${NC}"

# Make sure sounds.conf is sourced in hyprland.conf
if ! grep -q "source = ~/.config/hypr/sounds.conf" "$HYPR_DIR/hyprland.conf"; then
    echo -e "${YELLOW}Adding sounds.conf to hyprland.conf...${NC}"
    echo "source = ~/.config/hypr/sounds.conf" >> "$HYPR_DIR/hyprland.conf"
    echo -e "${GREEN}sounds.conf added to hyprland.conf.${NC}"
else
    echo -e "${GREEN}sounds.conf already included in hyprland.conf.${NC}"
fi

# Create test script
echo -e "${YELLOW}Creating sound test script...${NC}"

cat > "$HYPR_DIR/scripts/test-sounds.sh" << EOF
#!/bin/bash
# Script to test FF6 sound effects
# Auto-generated for $AUDIO_SYSTEM audio system

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

SOUND_DIR="\$HOME/.config/hypr/sounds"
PLAYER="\$HOME/.config/hypr/scripts/play-sound.sh"

echo -e "\${YELLOW}Testing FF6 sound effects...\${NC}"

echo -e "\${YELLOW}Playing cursor sound...\${NC}"
\$PLAYER cursor
sleep 1

echo -e "\${YELLOW}Playing confirm sound...\${NC}"
\$PLAYER confirm
sleep 1

echo -e "\${YELLOW}Playing menu_open sound...\${NC}"
\$PLAYER menu_open
sleep 1

echo -e "\${YELLOW}Playing error sound...\${NC}"
\$PLAYER error
sleep 1

echo -e "\${GREEN}Sound test complete.\${NC}"
EOF

chmod +x "$HYPR_DIR/scripts/test-sounds.sh"
echo -e "${GREEN}Sound test script created.${NC}"

# Configure SwayNC to use FF6 sounds
if [ -d "$CONFIG_DIR/swaync" ]; then
    echo -e "${YELLOW}Configuring SwayNC to use FF6 sounds...${NC}"
    
    # Check if config.json exists
    if [ -f "$CONFIG_DIR/swaync/config.json" ]; then
        # Backup original config
        cp "$CONFIG_DIR/swaync/config.json" "$CONFIG_DIR/swaync/config.json.bak"
        
        # Update sound configuration
        jq '.notification-sound = "'$SOUNDS_DIR'/confirm.wav"' "$CONFIG_DIR/swaync/config.json.bak" > "$CONFIG_DIR/swaync/config.json"
        echo -e "${GREEN}SwayNC configured to use FF6 sounds.${NC}"
    else
        echo -e "${YELLOW}SwayNC config.json not found. Creating...${NC}"
        cat > "$CONFIG_DIR/swaync/config.json" << EOF
{
  "notification-sound": "$SOUNDS_DIR/confirm.wav",
  "notification-critical-sound": "$SOUNDS_DIR/error.wav"
}
EOF
        echo -e "${GREEN}SwayNC config.json created with FF6 sounds.${NC}"
    fi
else
    echo -e "${YELLOW}SwayNC configuration directory not found. Skipping SwayNC configuration.${NC}"
fi

# Run test script
echo -e "${YELLOW}Testing sound configuration...${NC}"
"$HYPR_DIR/scripts/test-sounds.sh"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}FF6 sound effects configuration complete!${NC}"
echo -e "${BLUE}=========================================${NC}"
