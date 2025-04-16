#!/bin/bash

# Screenshot and Clipboard Functionality Script for FF6 Hyprland
# This script sets up screenshot and clipboard functionality

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Screenshot & Clipboard   ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
SCRIPTS_DIR="$HYPR_DIR/scripts"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Check if Hyprland config exists
if [ ! -d "$HYPR_DIR" ]; then
  echo -e "${RED}Hyprland configuration not found at $HYPR_DIR${NC}"
  echo -e "${YELLOW}Please run the installer first${NC}"
  exit 1
fi

# Create scripts directory if it doesn't exist
mkdir -p "$SCRIPTS_DIR"

# Create screenshots directory
mkdir -p "$SCREENSHOT_DIR"
echo -e "${GREEN}✓ Created screenshots directory at $SCREENSHOT_DIR${NC}"

# Create screenshot script
SCREENSHOT_SCRIPT="$SCRIPTS_DIR/screenshot.sh"

echo -e "${BLUE}Creating screenshot script...${NC}"

cat > "$SCREENSHOT_SCRIPT" << 'EOF'
#!/bin/bash

# FF6 Hyprland Screenshot Script
# This script takes screenshots with FF6-themed notifications

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

# Play sound effect if available
if [ -f "$HOME/.config/hypr/sounds/confirm.wav" ]; then
  paplay "$HOME/.config/hypr/sounds/confirm.wav" &
fi

# Function to show notification
show_notification() {
  local title="$1"
  local message="$2"
  
  if command -v notify-send &> /dev/null; then
    notify-send -i "$HOME/.config/hypr/icons/screenshot.png" "$title" "$message"
  fi
}

# Check for arguments
case "$1" in
  "area")
    # Screenshot selected area
    grim -g "$(slurp)" "$FILENAME"
    if [ $? -eq 0 ]; then
      show_notification "Area Screenshot" "Saved to $FILENAME"
      # Copy to clipboard
      wl-copy < "$FILENAME"
    else
      show_notification "Screenshot Failed" "Could not capture area screenshot"
    fi
    ;;
    
  "window")
    # Screenshot active window
    GEOMETRY=$(hyprctl activewindow -j | jq -r '.at[0], " ", .at[1], " ", .size[0], " ", .size[1]' | awk '{print $1","$2" "$3"x"$4}')
    grim -g "$GEOMETRY" "$FILENAME"
    if [ $? -eq 0 ]; then
      show_notification "Window Screenshot" "Saved to $FILENAME"
      # Copy to clipboard
      wl-copy < "$FILENAME"
    else
      show_notification "Screenshot Failed" "Could not capture window screenshot"
    fi
    ;;
    
  "clipboard")
    # Screenshot to clipboard only
    grim - | wl-copy
    if [ $? -eq 0 ]; then
      show_notification "Screenshot" "Copied to clipboard"
    else
      show_notification "Screenshot Failed" "Could not copy to clipboard"
    fi
    ;;
    
  *)
    # Full screenshot
    grim "$FILENAME"
    if [ $? -eq 0 ]; then
      show_notification "Screenshot" "Saved to $FILENAME"
      # Copy to clipboard
      wl-copy < "$FILENAME"
    else
      show_notification "Screenshot Failed" "Could not capture screenshot"
    fi
    ;;
esac
EOF

chmod +x "$SCREENSHOT_SCRIPT"
echo -e "${GREEN}✓ Created screenshot script${NC}"

# Create clipboard script
CLIPBOARD_SCRIPT="$SCRIPTS_DIR/clipboard.sh"

echo -e "${BLUE}Creating clipboard script...${NC}"

cat > "$CLIPBOARD_SCRIPT" << 'EOF'
#!/bin/bash

# FF6 Hyprland Clipboard Script
# This script manages clipboard history with FF6-themed UI

# Initialize cliphist if not already running
if ! pgrep -x "wl-paste" > /dev/null; then
  wl-paste --type text --watch cliphist store &
  wl-paste --type image --watch cliphist store &
fi

# Play sound effect if available
if [ -f "$HOME/.config/hypr/sounds/cursor.wav" ]; then
  paplay "$HOME/.config/hypr/sounds/cursor.wav" &
fi

# Function to show notification
show_notification() {
  local title="$1"
  local message="$2"
  
  if command -v notify-send &> /dev/null; then
    notify-send -i "$HOME/.config/hypr/icons/clipboard.png" "$title" "$message"
  fi
}

# Check for arguments
case "$1" in
  "clear")
    # Clear clipboard history
    cliphist wipe
    show_notification "Clipboard" "History cleared"
    ;;
    
  "delete")
    # Delete selected item from history
    cliphist list | rofi -dmenu -p "Select item to delete" -theme-str 'window {transparency: "real"; background-color: rgba(10, 16, 96, 0.8); width: 50%; border: 2px solid white; border-radius: 10px;}' | cliphist delete
    show_notification "Clipboard" "Item deleted from history"
    ;;
    
  *)
    # Show clipboard history
    SELECTED=$(cliphist list | rofi -dmenu -p "Clipboard History" -theme-str 'window {transparency: "real"; background-color: rgba(10, 16, 96, 0.8); width: 50%; border: 2px solid white; border-radius: 10px;}')
    
    if [ -n "$SELECTED" ]; then
      # Play sound effect if available
      if [ -f "$HOME/.config/hypr/sounds/confirm.wav" ]; then
        paplay "$HOME/.config/hypr/sounds/confirm.wav" &
      fi
      
      cliphist decode <<< "$SELECTED" | wl-copy
      show_notification "Clipboard" "Item copied to clipboard"
    fi
    ;;
esac
EOF

chmod +x "$CLIPBOARD_SCRIPT"
echo -e "${GREEN}✓ Created clipboard script${NC}"

# Update keybinds.conf with screenshot and clipboard keybindings
KEYBINDS_CONF="$HYPR_DIR/keybinds.conf"

if [ -f "$KEYBINDS_CONF" ]; then
  echo -e "${BLUE}Updating keybinds.conf with screenshot and clipboard keybindings...${NC}"
  
  # Check if screenshot and clipboard keybindings already exist
  if grep -q "# Screenshot Bindings" "$KEYBINDS_CONF" && grep -q "# Clipboard History" "$KEYBINDS_CONF"; then
    echo -e "${YELLOW}Screenshot and clipboard keybindings already exist in keybinds.conf${NC}"
  else
    # Backup existing keybinds.conf
    cp "$KEYBINDS_CONF" "$KEYBINDS_CONF.bak"
    
    # Update screenshot keybindings
    sed -i '/# Screenshot Bindings/,/# Clipboard History/c\
# Screenshot Bindings\
bind = , Print, exec, '"$SCRIPTS_DIR"'/screenshot.sh\
bind = $mainMod, Print, exec, '"$SCRIPTS_DIR"'/screenshot.sh area\
bind = ALT, Print, exec, '"$SCRIPTS_DIR"'/screenshot.sh window\
bind = CTRL, Print, exec, '"$SCRIPTS_DIR"'/screenshot.sh clipboard\
\
# Clipboard History\
bind = $mainMod, V, exec, '"$SCRIPTS_DIR"'/clipboard.sh\
bind = $mainMod SHIFT, V, exec, '"$SCRIPTS_DIR"'/clipboard.sh delete\
bind = $mainMod CTRL, V, exec, '"$SCRIPTS_DIR"'/clipboard.sh clear' "$KEYBINDS_CONF"
    
    echo -e "${GREEN}✓ Updated keybinds.conf with screenshot and clipboard keybindings${NC}"
  fi
else
  echo -e "${RED}keybinds.conf not found at $KEYBINDS_CONF${NC}"
  echo -e "${YELLOW}Please run the fix-window-switching.sh script first${NC}"
fi

# Create grimblast configuration
GRIMBLAST_CONF="$CONFIG_DIR/grimblast/config"
mkdir -p "$CONFIG_DIR/grimblast"

echo -e "${BLUE}Creating grimblast configuration...${NC}"

cat > "$GRIMBLAST_CONF" << 'EOF'
# grimblast configuration
# https://github.com/hyprwm/contrib/tree/main/grimblast

# Default screenshot directory
savedir="$HOME/Pictures/Screenshots"

# Default filename
filename="screenshot_%Y%m%d_%H%M%S.png"

# Default editor
editor="swappy"
EOF

echo -e "${GREEN}✓ Created grimblast configuration${NC}"

# Create swappy configuration
SWAPPY_CONF="$CONFIG_DIR/swappy/config"
mkdir -p "$CONFIG_DIR/swappy"

echo -e "${BLUE}Creating swappy configuration...${NC}"

cat > "$SWAPPY_CONF" << 'EOF'
# swappy configuration
# https://github.com/jtheoof/swappy

[Default]
save_dir=$HOME/Pictures/Screenshots
save_filename_format=screenshot_%Y%m%d_%H%M%S.png
show_panel=true
line_size=5
text_size=20
text_font=JetBrains Mono Nerd Font
paint_mode=brush
early_exit=false
fill_shape=false
EOF

echo -e "${GREEN}✓ Created swappy configuration${NC}"

# Update autostart script to initialize clipboard history
AUTOSTART_SCRIPT="$HYPR_DIR/scripts/autostart.sh"

if [ -f "$AUTOSTART_SCRIPT" ]; then
  echo -e "${BLUE}Updating autostart script to initialize clipboard history...${NC}"
  
  # Check if clipboard history initialization already exists
  if grep -q "# Start clipboard manager" "$AUTOSTART_SCRIPT"; then
    echo -e "${YELLOW}Clipboard history initialization already exists in autostart script${NC}"
  else
    # Backup existing autostart script
    cp "$AUTOSTART_SCRIPT" "$AUTOSTART_SCRIPT.bak"
    
    # Add clipboard history initialization
    sed -i '/# Start clipboard manager/,/else/c\
# Start clipboard manager\
if ! pgrep -x "wl-paste" > /dev/null; then\
    log_message "Starting clipboard manager"\
    wl-paste --type text --watch cliphist store &\
    wl-paste --type image --watch cliphist store &\
else\
    log_message "Clipboard manager already running"\
fi' "$AUTOSTART_SCRIPT"
    
    echo -e "${GREEN}✓ Updated autostart script to initialize clipboard history${NC}"
  fi
else
  echo -e "${RED}autostart.sh not found at $AUTOSTART_SCRIPT${NC}"
  echo -e "${YELLOW}Please run the configure-services.sh script first${NC}"
fi

# Update installer script to include screenshot and clipboard functionality
INSTALLER_SCRIPT="/home/ubuntu/ff6-hyprland-git/install.sh"

if [ -f "$INSTALLER_SCRIPT" ]; then
  echo -e "${BLUE}Updating installer script to include screenshot and clipboard functionality...${NC}"
  
  # Check if screenshot and clipboard functionality already exists
  if grep -q "# Configure screenshot and clipboard functionality" "$INSTALLER_SCRIPT"; then
    echo -e "${YELLOW}Screenshot and clipboard functionality already exists in installer script${NC}"
  else
    # Add screenshot and clipboard functionality to installer script
    sed -i '/# Test configuration/i\
# Configure screenshot and clipboard functionality\
echo -e "${BLUE}Configuring screenshot and clipboard functionality...${NC}"\
log_message "Configuring screenshot and clipboard functionality"\
\
if [ -f "$SCRIPT_DIR/scripts/screenshot-clipboard.sh" ]; then\
  echo -e "${YELLOW}Running screenshot-clipboard.sh...${NC}"\
  log_message "Running screenshot-clipboard.sh"\
  bash "$SCRIPT_DIR/scripts/screenshot-clipboard.sh"\
else\
  echo -e "${YELLOW}screenshot-clipboard.sh not found, skipping${NC}"\
  log_message "screenshot-clipboard.sh not found, skipping"\
fi\
\
' "$INSTALLER_SCRIPT"
    
    echo -e "${GREEN}✓ Updated installer script to include screenshot and clipboard functionality${NC}"
  fi
else
  echo -e "${RED}install.sh not found at $INSTALLER_SCRIPT${NC}"
  echo -e "${YELLOW}Please check the path to the installer script${NC}"
fi

# Copy this script to the scripts directory for the installer to use
cp "$0" "$HYPR_DIR/scripts/screenshot-clipboard.sh"
chmod +x "$HYPR_DIR/scripts/screenshot-clipboard.sh"

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}  Screenshot & Clipboard Setup Complete!${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}Please restart Hyprland to apply the changes.${NC}"
echo -e "${YELLOW}You can do this by logging out and back in, or by running:${NC}"
echo -e "${BLUE}hyprctl dispatch exit${NC}"
