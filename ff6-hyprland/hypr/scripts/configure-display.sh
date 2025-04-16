#!/bin/bash
# FF6 Hyprland Display Configuration Script
# Automatically detects resolution and configures Hyprland accordingly
# Created: April 2025

# Get primary monitor information
PRIMARY_MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
RESOLUTION=$(hyprctl monitors -j | jq -r '.[0].width, "x", .[0].height' | tr -d '\n')
REFRESH_RATE=$(hyprctl monitors -j | jq -r '.[0].refreshRate')

# Check if multiple monitors are connected
MONITOR_COUNT=$(hyprctl monitors -j | jq '. | length')

echo "Detected primary monitor: $PRIMARY_MONITOR"
echo "Resolution: $RESOLUTION"
echo "Refresh rate: $REFRESH_RATE Hz"
echo "Monitor count: $MONITOR_COUNT"

# Configure based on resolution
if [[ "$RESOLUTION" == *"3840x2160"* ]] || [[ "$RESOLUTION" == *"4096x2160"* ]]; then
    # 4K resolution settings
    echo "Configuring for 4K resolution"
    
    # Set monitor configuration
    hyprctl keyword monitor "$PRIMARY_MONITOR,highres,auto,1"
    
    # Adjust scaling
    hyprctl keyword xwayland:force_zero_scaling true
    
    # Adjust UI elements for 4K
    hyprctl keyword general:gaps_in 8
    hyprctl keyword general:gaps_out 16
    hyprctl keyword general:border_size 3
    
    # Adjust decoration settings
    hyprctl keyword decoration:rounding 14
    hyprctl keyword decoration:shadow:range 20
    
    # Set cursor size
    hyprctl keyword env XCURSOR_SIZE 32
    
    # Configure waybar for 4K
    sed -i 's/"height": 30,/"height": 48,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"height": 24,/"height": 40,/g' ~/.config/waybar/config-bottom.jsonc
    sed -i 's/"icon-size": 18,/"icon-size": 28,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"icon-size": 16,/"icon-size": 24,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"icon-size": 16,/"icon-size": 24,/g' ~/.config/waybar/config-bottom.jsonc
    
    # Restart waybar to apply changes
    killall waybar
    waybar &
    
elif [[ "$RESOLUTION" == *"2560x1440"* ]]; then
    # 1440p resolution settings
    echo "Configuring for 1440p resolution"
    
    # Set monitor configuration
    hyprctl keyword monitor "$PRIMARY_MONITOR,highres,auto,1"
    
    # Adjust scaling
    hyprctl keyword xwayland:force_zero_scaling true
    
    # Adjust UI elements for 1440p
    hyprctl keyword general:gaps_in 6
    hyprctl keyword general:gaps_out 12
    hyprctl keyword general:border_size 2
    
    # Adjust decoration settings
    hyprctl keyword decoration:rounding 12
    hyprctl keyword decoration:shadow:range 18
    
    # Set cursor size
    hyprctl keyword env XCURSOR_SIZE 24
    
    # Configure waybar for 1440p
    sed -i 's/"height": 48,/"height": 36,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"height": 40,/"height": 30,/g' ~/.config/waybar/config-bottom.jsonc
    sed -i 's/"icon-size": 28,/"icon-size": 22,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"icon-size": 24,/"icon-size": 20,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"icon-size": 24,/"icon-size": 20,/g' ~/.config/waybar/config-bottom.jsonc
    
    # Restart waybar to apply changes
    killall waybar
    waybar &
    
else
    # 1080p or other resolution settings
    echo "Configuring for 1080p/standard resolution"
    
    # Set monitor configuration
    hyprctl keyword monitor "$PRIMARY_MONITOR,preferred,auto,1"
    
    # Adjust scaling
    hyprctl keyword xwayland:force_zero_scaling true
    
    # Adjust UI elements for 1080p
    hyprctl keyword general:gaps_in 5
    hyprctl keyword general:gaps_out 10
    hyprctl keyword general:border_size 2
    
    # Adjust decoration settings
    hyprctl keyword decoration:rounding 10
    hyprctl keyword decoration:shadow:range 15
    
    # Set cursor size
    hyprctl keyword env XCURSOR_SIZE 24
    
    # Configure waybar for 1080p
    sed -i 's/"height": 48,/"height": 30,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"height": 40,/"height": 24,/g' ~/.config/waybar/config-bottom.jsonc
    sed -i 's/"icon-size": 28,/"icon-size": 18,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"icon-size": 24,/"icon-size": 16,/g' ~/.config/waybar/config-top.jsonc
    sed -i 's/"icon-size": 24,/"icon-size": 16,/g' ~/.config/waybar/config-bottom.jsonc
    
    # Restart waybar to apply changes
    killall waybar
    waybar &
fi

# Configure multiple monitors if detected
if [ "$MONITOR_COUNT" -gt 1 ]; then
    echo "Configuring multiple monitors"
    
    # Get secondary monitor information
    SECONDARY_MONITORS=$(hyprctl monitors -j | jq -r '.[1:] | .[] | .name')
    
    # Configure each secondary monitor
    for monitor in $SECONDARY_MONITORS; do
        echo "Configuring secondary monitor: $monitor"
        hyprctl keyword monitor "$monitor,preferred,auto,1"
    done
fi

echo "Display configuration complete"
