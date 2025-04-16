#!/bin/bash

# Autostart Services Script for FF6 Hyprland
# This script ensures all required services are running for the FF6 Hyprland configuration

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Services Configuration   ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
AUTOSTART_SCRIPT="$HYPR_DIR/scripts/autostart.sh"

# Check if Hyprland config exists
if [ ! -d "$HYPR_DIR" ]; then
  echo -e "${RED}Hyprland configuration not found at $HYPR_DIR${NC}"
  echo -e "${YELLOW}Please run the installer first${NC}"
  exit 1
fi

# Create scripts directory if it doesn't exist
mkdir -p "$HYPR_DIR/scripts"

# Create autostart script
echo -e "${BLUE}Creating autostart script...${NC}"

cat > "$AUTOSTART_SCRIPT" << 'EOF'
#!/bin/bash

# FF6 Hyprland Autostart Script
# This script ensures all necessary components are started

# Log file
LOG_DIR="$HOME/.config/hypr/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/autostart-$(date +%Y%m%d-%H%M%S).log"

# Function to log messages
log_message() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

log_message "Starting FF6 Hyprland autostart script"

# Wait for desktop to fully load
sleep 2
log_message "Desktop environment loaded, starting services"

# Start Waybar if not running
if ! pgrep -x "waybar" > /dev/null; then
    log_message "Starting Waybar"
    waybar &
else
    log_message "Waybar already running"
fi

# Start notification daemon if not running
if ! pgrep -x "swaync" > /dev/null; then
    log_message "Starting SwayNC notification daemon"
    swaync &
else
    log_message "SwayNC already running"
fi

# Start wallpaper daemon if not running
if ! pgrep -x "swww" > /dev/null; then
    log_message "Starting SWWW wallpaper daemon"
    swww init &
    sleep 1
else
    log_message "SWWW already running"
fi

# Set wallpaper
if [ -f "$HOME/.config/hypr/wallpapers/current.png" ]; then
    log_message "Setting current wallpaper"
    swww img "$HOME/.config/hypr/wallpapers/current.png" --transition-type grow --transition-pos 0.5,0.5 &
elif [ -f "$HOME/.config/hypr/wallpapers/ff6_default.jpg" ]; then
    log_message "Setting default FF6 wallpaper"
    swww img "$HOME/.config/hypr/wallpapers/ff6_default.jpg" --transition-type grow --transition-pos 0.5,0.5 &
else
    # Create a default FF6-style wallpaper if none exists
    log_message "No wallpaper found, creating default FF6-style wallpaper"
    mkdir -p "$HOME/.config/hypr/wallpapers"
    
    # Try to use ImageMagick to create a default wallpaper
    if command -v convert > /dev/null; then
        convert -size 1920x1080 gradient:"#0A1060-#2040A0" -fill white -draw "rectangle 10,10 1910,1070" -blur 0x2 "$HOME/.config/hypr/wallpapers/ff6_default.jpg"
        swww img "$HOME/.config/hypr/wallpapers/ff6_default.jpg" --transition-type grow --transition-pos 0.5,0.5 &
    fi
fi

# Start clipboard manager
if ! pgrep -x "wl-paste" > /dev/null; then
    log_message "Starting clipboard manager"
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
else
    log_message "Clipboard manager already running"
fi

# Start polkit agent
if command -v polkit-kde-authentication-agent-1 > /dev/null; then
    if ! pgrep -x "polkit-kde-auth" > /dev/null; then
        log_message "Starting polkit authentication agent"
        /usr/lib/polkit-kde-authentication-agent-1 &
    else
        log_message "Polkit authentication agent already running"
    fi
elif command -v lxpolkit > /dev/null; then
    if ! pgrep -x "lxpolkit" > /dev/null; then
        log_message "Starting lxpolkit authentication agent"
        lxpolkit &
    else
        log_message "lxpolkit already running"
    fi
fi

# Generate sound effects if they don't exist
if [ ! -f "$HOME/.config/hypr/sounds/cursor.wav" ] || [ ! -f "$HOME/.config/hypr/sounds/confirm.wav" ]; then
    log_message "Generating FF6 sound effects"
    mkdir -p "$HOME/.config/hypr/sounds"
    if command -v sox > /dev/null; then
        sox -n "$HOME/.config/hypr/sounds/cursor.wav" synth 0.1 sine 1200 fade 0 0.1 0.05
        sox -n "$HOME/.config/hypr/sounds/confirm.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
    else
        log_message "Sox not found, cannot generate sound effects"
    fi
fi

# Apply FF6 cursor theme
if [ -d "$HOME/.local/share/icons/AtmaWeapon" ]; then
    log_message "Applying Atma Weapon cursor theme"
    gsettings set org.gnome.desktop.interface cursor-theme 'AtmaWeapon'
else
    log_message "Atma Weapon cursor theme not found"
fi

# Start network applet if available
if command -v nm-applet > /dev/null; then
    if ! pgrep -x "nm-applet" > /dev/null; then
        log_message "Starting network manager applet"
        nm-applet --indicator &
    else
        log_message "Network manager applet already running"
    fi
fi

# Start blueman applet if bluetooth is available
if command -v blueman-applet > /dev/null && [ -d "/sys/class/bluetooth" ]; then
    if ! pgrep -x "blueman-applet" > /dev/null; then
        log_message "Starting Bluetooth applet"
        blueman-applet &
    else
        log_message "Bluetooth applet already running"
    fi
fi

# Start battery monitor if on a laptop
if [ -d "/sys/class/power_supply/BAT0" ] || [ -d "/sys/class/power_supply/BAT1" ]; then
    log_message "Laptop detected, ensuring battery monitoring is active"
    # Battery monitoring is handled by waybar
fi

log_message "FF6 Hyprland autostart completed successfully"
EOF

# Make autostart script executable
chmod +x "$AUTOSTART_SCRIPT"

# Update Hyprland config to include autostart script
HYPRLAND_CONF="$HYPR_DIR/hyprland.conf"

if [ ! -f "$HYPRLAND_CONF" ]; then
  echo -e "${RED}Hyprland configuration file not found at $HYPRLAND_CONF${NC}"
  exit 1
fi

# Check if autostart script is already included
if grep -q "exec-once = $AUTOSTART_SCRIPT" "$HYPRLAND_CONF"; then
  echo -e "${BLUE}Autostart script is already included in hyprland.conf${NC}"
else
  # Add autostart script to exec-once section
  if grep -q "^exec-once =" "$HYPRLAND_CONF"; then
    # Add after the last exec-once line
    sed -i "/^exec-once =/a exec-once = $AUTOSTART_SCRIPT" "$HYPRLAND_CONF"
  else
    # Add to the end of the file
    echo "" >> "$HYPRLAND_CONF"
    echo "# Autostart script" >> "$HYPRLAND_CONF"
    echo "exec-once = $AUTOSTART_SCRIPT" >> "$HYPRLAND_CONF"
  fi
  echo -e "${GREEN}Added autostart script to hyprland.conf${NC}"
fi

# Create a default FF6-style wallpaper
echo -e "${BLUE}Creating default FF6-style wallpaper...${NC}"
mkdir -p "$HYPR_DIR/wallpapers"

if command -v convert > /dev/null; then
  convert -size 1920x1080 gradient:"#0A1060-#2040A0" -fill white -draw "rectangle 10,10 1910,1070" -blur 0x2 "$HYPR_DIR/wallpapers/ff6_default.jpg"
  echo -e "${GREEN}Created default FF6-style wallpaper${NC}"
else
  echo -e "${YELLOW}ImageMagick not found, skipping default wallpaper creation${NC}"
fi

# Create sounds directory and generate FF6 sound effects
echo -e "${BLUE}Generating FF6 sound effects...${NC}"
mkdir -p "$HYPR_DIR/sounds"

if command -v sox > /dev/null; then
  sox -n "$HYPR_DIR/sounds/cursor.wav" synth 0.1 sine 1200 fade 0 0.1 0.05
  sox -n "$HYPR_DIR/sounds/confirm.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
  echo -e "${GREEN}Generated FF6 sound effects${NC}"
else
  echo -e "${YELLOW}Sox not found, skipping sound effect generation${NC}"
fi

# Create logs directory
mkdir -p "$HYPR_DIR/logs"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}  Services Configuration Complete!     ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}Please restart Hyprland to apply the changes.${NC}"
echo -e "${YELLOW}You can do this by logging out and back in, or by running:${NC}"
echo -e "${BLUE}hyprctl dispatch exit${NC}"
