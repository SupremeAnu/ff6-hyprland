#!/bin/bash

# Script to configure display resolution and adjust UI scaling
# For FF6-themed Hyprland configuration
# Created: April 2025

# Detect screen resolution
get_resolution() {
    hyprctl monitors -j | jq -r '.[0].width, .[0].height'
}

# Set up variables
RESOLUTION=$(get_resolution)
WIDTH=$(echo "$RESOLUTION" | head -1)
HEIGHT=$(echo "$RESOLUTION" | tail -1)
CONFIG_DIR="$HOME/.config/hypr"
WAYBAR_DIR="$HOME/.config/waybar"

echo "Detected resolution: ${WIDTH}x${HEIGHT}"

# Create backup of current configs if they don't exist
if [ ! -f "$CONFIG_DIR/hyprland.conf.bak" ]; then
    cp "$CONFIG_DIR/hyprland.conf" "$CONFIG_DIR/hyprland.conf.bak"
fi

if [ ! -f "$WAYBAR_DIR/style.css.bak" ]; then
    cp "$WAYBAR_DIR/style.css" "$WAYBAR_DIR/style.css.bak"
fi

# Configure for different resolutions
if [ "$HEIGHT" -ge 2160 ]; then
    # 4K resolution (3840x2160 or higher)
    echo "Configuring for 4K display..."
    
    # Update Hyprland config
    sed -i 's/gaps_in = [0-9]\+/gaps_in = 8/' "$CONFIG_DIR/hyprland.conf"
    sed -i 's/gaps_out = [0-9]\+/gaps_out = 15/' "$CONFIG_DIR/hyprland.conf"
    sed -i 's/border_size = [0-9]\+/border_size = 3/' "$CONFIG_DIR/hyprland.conf"
    
    # Update Waybar config
    sed -i 's/"height": [0-9]\+/"height": 40/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"height": [0-9]\+/"height": 40/' "$WAYBAR_DIR/config-bottom.jsonc"
    sed -i 's/"margin-top": [0-9]\+/"margin-top": 10/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"margin-bottom": [0-9]\+/"margin-bottom": 10/' "$WAYBAR_DIR/config-bottom.jsonc"
    sed -i 's/"icon-size": [0-9]\+/"icon-size": 24/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"icon-size": [0-9]\+/"icon-size": 24/' "$WAYBAR_DIR/config-bottom.jsonc"
    
    # Update Waybar style
    sed -i 's/font-size: [0-9]\+px/font-size: 16px/' "$WAYBAR_DIR/style.css"
    
    # Set environment variables for scaling
    echo "env = GDK_SCALE,2" >> "$CONFIG_DIR/hyprland.conf"
    echo "env = XCURSOR_SIZE,32" >> "$CONFIG_DIR/hyprland.conf"

elif [ "$HEIGHT" -ge 1440 ]; then
    # 1440p resolution
    echo "Configuring for 1440p display..."
    
    # Update Hyprland config
    sed -i 's/gaps_in = [0-9]\+/gaps_in = 6/' "$CONFIG_DIR/hyprland.conf"
    sed -i 's/gaps_out = [0-9]\+/gaps_out = 12/' "$CONFIG_DIR/hyprland.conf"
    sed -i 's/border_size = [0-9]\+/border_size = 2/' "$CONFIG_DIR/hyprland.conf"
    
    # Update Waybar config
    sed -i 's/"height": [0-9]\+/"height": 34/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"height": [0-9]\+/"height": 34/' "$WAYBAR_DIR/config-bottom.jsonc"
    sed -i 's/"margin-top": [0-9]\+/"margin-top": 8/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"margin-bottom": [0-9]\+/"margin-bottom": 8/' "$WAYBAR_DIR/config-bottom.jsonc"
    sed -i 's/"icon-size": [0-9]\+/"icon-size": 20/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"icon-size": [0-9]\+/"icon-size": 20/' "$WAYBAR_DIR/config-bottom.jsonc"
    
    # Update Waybar style
    sed -i 's/font-size: [0-9]\+px/font-size: 14px/' "$WAYBAR_DIR/style.css"
    
    # Set environment variables for scaling
    echo "env = GDK_SCALE,1" >> "$CONFIG_DIR/hyprland.conf"
    echo "env = XCURSOR_SIZE,24" >> "$CONFIG_DIR/hyprland.conf"

else
    # 1080p resolution or lower
    echo "Configuring for 1080p display..."
    
    # Update Hyprland config
    sed -i 's/gaps_in = [0-9]\+/gaps_in = 5/' "$CONFIG_DIR/hyprland.conf"
    sed -i 's/gaps_out = [0-9]\+/gaps_out = 10/' "$CONFIG_DIR/hyprland.conf"
    sed -i 's/border_size = [0-9]\+/border_size = 2/' "$CONFIG_DIR/hyprland.conf"
    
    # Update Waybar config
    sed -i 's/"height": [0-9]\+/"height": 30/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"height": [0-9]\+/"height": 30/' "$WAYBAR_DIR/config-bottom.jsonc"
    sed -i 's/"margin-top": [0-9]\+/"margin-top": 6/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"margin-bottom": [0-9]\+/"margin-bottom": 6/' "$WAYBAR_DIR/config-bottom.jsonc"
    sed -i 's/"icon-size": [0-9]\+/"icon-size": 16/' "$WAYBAR_DIR/config-top.jsonc"
    sed -i 's/"icon-size": [0-9]\+/"icon-size": 16/' "$WAYBAR_DIR/config-bottom.jsonc"
    
    # Update Waybar style
    sed -i 's/font-size: [0-9]\+px/font-size: 12px/' "$WAYBAR_DIR/style.css"
    
    # Set environment variables for scaling
    echo "env = GDK_SCALE,1" >> "$CONFIG_DIR/hyprland.conf"
    echo "env = XCURSOR_SIZE,24" >> "$CONFIG_DIR/hyprland.conf"
fi

# Handle multiple monitors if detected
MONITOR_COUNT=$(hyprctl monitors -j | jq length)
if [ "$MONITOR_COUNT" -gt 1 ]; then
    echo "Multiple monitors detected ($MONITOR_COUNT). Configuring..."
    
    # Create monitor configuration
    MONITOR_CONFIG="$CONFIG_DIR/monitors.conf"
    echo "# Monitor configuration - auto-generated" > "$MONITOR_CONFIG"
    
    # Get monitor information
    MONITORS=$(hyprctl monitors -j)
    
    # Process each monitor
    for i in $(seq 0 $(($MONITOR_COUNT-1))); do
        NAME=$(echo "$MONITORS" | jq -r ".[$i].name")
        WIDTH=$(echo "$MONITORS" | jq -r ".[$i].width")
        HEIGHT=$(echo "$MONITORS" | jq -r ".[$i].height")
        X=$(echo "$MONITORS" | jq -r ".[$i].x")
        Y=$(echo "$MONITORS" | jq -r ".[$i].y")
        
        # Add monitor to config
        echo "monitor=$NAME,$WIDTH"x"$HEIGHT,$X"x"$Y,1" >> "$MONITOR_CONFIG"
        
        # Assign workspaces to monitors
        if [ "$i" -eq 0 ]; then
            echo "workspace=1,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=2,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=3,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=4,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=5,monitor:$NAME" >> "$MONITOR_CONFIG"
        else
            echo "workspace=6,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=7,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=8,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=9,monitor:$NAME" >> "$MONITOR_CONFIG"
            echo "workspace=10,monitor:$NAME" >> "$MONITOR_CONFIG"
        fi
    done
    
    # Make sure the monitor config is sourced
    if ! grep -q "source = $MONITOR_CONFIG" "$CONFIG_DIR/hyprland.conf"; then
        echo "source = $MONITOR_CONFIG" >> "$CONFIG_DIR/hyprland.conf"
    fi
fi

# Restart Waybar to apply changes
killall waybar
waybar &

echo "Display configuration complete!"
