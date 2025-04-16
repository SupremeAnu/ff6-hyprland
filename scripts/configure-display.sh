#!/bin/bash

# Display Configuration Script for FF6 Hyprland
# This script detects monitor configuration and sets up appropriate display settings

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Display Configuration    ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
MONITOR_CONF="$HYPR_DIR/monitors.conf"

# Check if Hyprland config exists
if [ ! -d "$HYPR_DIR" ]; then
  echo -e "${RED}Hyprland configuration not found at $HYPR_DIR${NC}"
  echo -e "${YELLOW}Please run the installer first${NC}"
  exit 1
fi

# Create monitors.conf if it doesn't exist
if [ ! -f "$MONITOR_CONF" ]; then
  touch "$MONITOR_CONF"
fi

# Function to detect monitors using hyprctl
detect_monitors() {
  if command -v hyprctl &> /dev/null; then
    echo -e "${BLUE}Detecting monitors using hyprctl...${NC}"
    MONITORS=$(hyprctl monitors -j 2>/dev/null)
    
    if [ $? -ne 0 ]; then
      echo -e "${YELLOW}hyprctl not available or not running. Using fallback method.${NC}"
      return 1
    fi
    
    # Count monitors
    MONITOR_COUNT=$(echo "$MONITORS" | grep -c '"name":')
    
    if [ "$MONITOR_COUNT" -gt 0 ]; then
      echo -e "${GREEN}Detected $MONITOR_COUNT monitor(s) using hyprctl${NC}"
      return 0
    else
      echo -e "${YELLOW}No monitors detected using hyprctl. Using fallback method.${NC}"
      return 1
    fi
  else
    echo -e "${YELLOW}hyprctl not found. Using fallback method.${NC}"
    return 1
  fi
}

# Function to detect monitors using xrandr (fallback)
detect_monitors_fallback() {
  if command -v xrandr &> /dev/null; then
    echo -e "${BLUE}Detecting monitors using xrandr...${NC}"
    CONNECTED_MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)
    MONITOR_COUNT=$(echo "$CONNECTED_MONITORS" | wc -l)
    
    if [ "$MONITOR_COUNT" -gt 0 ]; then
      echo -e "${GREEN}Detected $MONITOR_COUNT monitor(s) using xrandr${NC}"
      return 0
    else
      echo -e "${YELLOW}No monitors detected using xrandr. Using manual configuration.${NC}"
      return 1
    fi
  else
    echo -e "${YELLOW}xrandr not found. Using manual configuration.${NC}"
    return 1
  fi
}

# Function to configure monitors
configure_monitors() {
  echo -e "${BLUE}Configuring monitors...${NC}"
  
  # Try to detect monitors using hyprctl first
  if ! detect_monitors; then
    # If hyprctl fails, try xrandr
    if ! detect_monitors_fallback; then
      # If both fail, use manual configuration
      echo -e "${YELLOW}Could not automatically detect monitors. Using manual configuration.${NC}"
      MONITOR_COUNT=1
    fi
  fi
  
  # Backup existing configuration
  if [ -f "$MONITOR_CONF" ]; then
    cp "$MONITOR_CONF" "$MONITOR_CONF.bak"
    echo -e "${BLUE}Backed up existing monitor configuration to $MONITOR_CONF.bak${NC}"
  fi
  
  # Clear the monitor configuration file
  echo "# FF6 Hyprland Monitor Configuration" > "$MONITOR_CONF"
  echo "# Generated on $(date)" >> "$MONITOR_CONF"
  echo "" >> "$MONITOR_CONF"
  
  if [ "$MONITOR_COUNT" -eq 1 ]; then
    # Single monitor configuration
    echo -e "${BLUE}Configuring for single monitor setup${NC}"
    
    # Ask for resolution if not detected
    read -p "Enter your monitor resolution (e.g., 1920x1080, or press Enter for auto): " RESOLUTION
    
    if [ -z "$RESOLUTION" ]; then
      echo "monitor=,preferred,auto,1" >> "$MONITOR_CONF"
      echo "# Default configuration for single monitor" >> "$MONITOR_CONF"
    else
      WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
      HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)
      echo "monitor=,${WIDTH}x${HEIGHT},auto,1" >> "$MONITOR_CONF"
      echo "# Custom resolution for single monitor" >> "$MONITOR_CONF"
    fi
    
  else
    # Multiple monitor configuration
    echo -e "${BLUE}Configuring for multi-monitor setup ($MONITOR_COUNT monitors)${NC}"
    
    # Default configuration for multiple monitors
    echo "# Multi-monitor configuration" >> "$MONITOR_CONF"
    
    if command -v hyprctl &> /dev/null; then
      # Get monitor information from hyprctl
      MONITORS_JSON=$(hyprctl monitors -j 2>/dev/null)
      
      if [ $? -eq 0 ]; then
        # Extract monitor names
        MONITOR_NAMES=$(echo "$MONITORS_JSON" | grep -o '"name": "[^"]*' | cut -d'"' -f4)
        
        # Configure each monitor
        i=0
        echo "$MONITOR_NAMES" | while read -r MONITOR_NAME; do
          if [ -n "$MONITOR_NAME" ]; then
            if [ $i -eq 0 ]; then
              # Primary monitor
              echo "monitor=$MONITOR_NAME,preferred,auto,1" >> "$MONITOR_CONF"
              echo "# Primary monitor: $MONITOR_NAME" >> "$MONITOR_CONF"
            else
              # Secondary monitors
              echo "monitor=$MONITOR_NAME,preferred,auto,1" >> "$MONITOR_CONF"
              echo "# Secondary monitor: $MONITOR_NAME" >> "$MONITOR_CONF"
            fi
            i=$((i+1))
          fi
        done
      else
        # Fallback to generic configuration
        echo "monitor=,preferred,auto,1" >> "$MONITOR_CONF"
        echo "# Default configuration for primary monitor" >> "$MONITOR_CONF"
        echo "monitor=,preferred,auto,1,mirror,eDP-1" >> "$MONITOR_CONF"
        echo "# Default configuration for secondary monitors" >> "$MONITOR_CONF"
      fi
    else
      # Fallback to generic configuration
      echo "monitor=,preferred,auto,1" >> "$MONITOR_CONF"
      echo "# Default configuration for primary monitor" >> "$MONITOR_CONF"
      echo "monitor=,preferred,auto,1,mirror,eDP-1" >> "$MONITOR_CONF"
      echo "# Default configuration for secondary monitors" >> "$MONITOR_CONF"
    fi
  fi
  
  # Add workspace configuration
  echo "" >> "$MONITOR_CONF"
  echo "# Workspace assignment" >> "$MONITOR_CONF"
  
  if [ "$MONITOR_COUNT" -gt 1 ]; then
    # Multiple monitors - assign workspaces
    echo "workspace=1,monitor:0" >> "$MONITOR_CONF"
    echo "workspace=2,monitor:0" >> "$MONITOR_CONF"
    echo "workspace=3,monitor:0" >> "$MONITOR_CONF"
    echo "workspace=4,monitor:0" >> "$MONITOR_CONF"
    echo "workspace=5,monitor:0" >> "$MONITOR_CONF"
    echo "workspace=6,monitor:1" >> "$MONITOR_CONF"
    echo "workspace=7,monitor:1" >> "$MONITOR_CONF"
    echo "workspace=8,monitor:1" >> "$MONITOR_CONF"
    echo "workspace=9,monitor:1" >> "$MONITOR_CONF"
    echo "workspace=10,monitor:1" >> "$MONITOR_CONF"
  else
    # Single monitor - all workspaces on one monitor
    echo "# All workspaces on single monitor" >> "$MONITOR_CONF"
  fi
  
  # Add FF6 theme-specific display settings
  echo "" >> "$MONITOR_CONF"
  echo "# FF6 theme-specific display settings" >> "$MONITOR_CONF"
  echo "general {" >> "$MONITOR_CONF"
  echo "    gaps_in = 5" >> "$MONITOR_CONF"
  echo "    gaps_out = 10" >> "$MONITOR_CONF"
  echo "    border_size = 2" >> "$MONITOR_CONF"
  echo "    col.active_border = rgb(FFFFFF)" >> "$MONITOR_CONF"
  echo "    col.inactive_border = rgb(102080)" >> "$MONITOR_CONF"
  echo "}" >> "$MONITOR_CONF"
  
  echo -e "${GREEN}Monitor configuration completed and saved to $MONITOR_CONF${NC}"
}

# Function to update Hyprland config to include monitor configuration
update_hyprland_config() {
  HYPRLAND_CONF="$HYPR_DIR/hyprland.conf"
  
  if [ ! -f "$HYPRLAND_CONF" ]; then
    echo -e "${RED}Hyprland configuration file not found at $HYPRLAND_CONF${NC}"
    return 1
  fi
  
  # Check if monitors.conf is already sourced
  if grep -q "source = ./monitors.conf" "$HYPRLAND_CONF"; then
    echo -e "${BLUE}monitors.conf is already sourced in hyprland.conf${NC}"
  else
    # Add source line at the beginning of the file
    sed -i '1s/^/source = ./monitors.conf\n\n/' "$HYPRLAND_CONF"
    echo -e "${GREEN}Added monitors.conf to hyprland.conf${NC}"
  fi
}

# Main execution
configure_monitors
update_hyprland_config

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}  Display Configuration Complete!      ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}Please restart Hyprland to apply the changes.${NC}"
echo -e "${YELLOW}You can do this by logging out and back in, or by running:${NC}"
echo -e "${BLUE}hyprctl dispatch exit${NC}"
