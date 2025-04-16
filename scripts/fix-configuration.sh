#!/bin/bash

# Fix for FF6 Hyprland Configuration Issues
# This script addresses theming, animations, waybar, and autorun issues

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  FF6 Hyprland Configuration Fix Tool   ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Please do not run this script as root${NC}"
  exit 1
fi

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"

# Check if Hyprland config exists
if [ ! -d "$HYPR_DIR" ]; then
  echo -e "${RED}Hyprland configuration not found at $HYPR_DIR${NC}"
  echo -e "${YELLOW}Please run the installer first${NC}"
  exit 1
fi

# Fix Hyprland animations and borders
echo -e "${YELLOW}Fixing Hyprland animations and borders...${NC}"

# Update animations.conf
cat > "$HYPR_DIR/animations.conf" << 'EOF'
# FF6-themed animations configuration
# Theme: Final Fantasy VI Menu Style

animations {
    enabled = true
    
    # Define bezier curves for smooth animations
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    bezier = linear, 0.0, 0.0, 1.0, 1.0
    bezier = ff6Open, 0.1, 0.8, 0.2, 1.0
    bezier = ff6Close, 0.3, 0.0, 0.8, 0.1
    
    # Animation configs
    animation = windows, 1, 5, ff6Open, slide
    animation = windowsOut, 1, 5, ff6Close, slide
    animation = border, 1, 10, linear
    animation = borderangle, 1, 100, linear, loop
    animation = fade, 1, 5, linear
    animation = workspaces, 1, 5, ff6Open
    animation = specialWorkspace, 1, 5, ff6Open, slidevert
}
EOF

# Update colors.conf
cat > "$HYPR_DIR/colors.conf" << 'EOF'
# FF6-themed colors configuration
# Theme: Final Fantasy VI Menu Style

# FF6 blue gradient with white borders
$ff6_dark_blue = rgb(0A1060)
$ff6_blue = rgb(102080)
$ff6_light_blue = rgb(2040A0)
$ff6_white = rgb(FFFFFF)
$ff6_highlight = rgb(4080FF)

# General colors
$background = $ff6_dark_blue
$foreground = $ff6_white
$border_active = $ff6_white
$border_inactive = $ff6_blue

# Apply colors to Hyprland
general {
    # Border colors
    col.active_border = $border_active
    col.inactive_border = $border_inactive
    
    # Border size and animation
    border_size = 2
    
    # Gaps
    gaps_in = 5
    gaps_out = 10
    
    # Layout
    layout = dwindle
}

# Window decoration
decoration {
    # Rounded corners
    rounding = 10
    
    # Blur
    blur {
        enabled = true
        size = 5
        passes = 2
    }
    
    # Shadows
    drop_shadow = true
    shadow_range = 15
    shadow_render_power = 2
    shadow_ignore_window = true
    col.shadow = rgba(0A106066)
    
    # Dim inactive windows
    dim_inactive = true
    dim_strength = 0.1
    
    # Border animation
    active_opacity = 1.0
    inactive_opacity = 0.95
}
EOF

# Update hyprland.conf to ensure it sources the correct files
if ! grep -q "source = ./colors.conf" "$HYPR_DIR/hyprland.conf"; then
    # Backup original
    cp "$HYPR_DIR/hyprland.conf" "$HYPR_DIR/hyprland.conf.bak"
    
    # Add source lines if they don't exist
    echo -e "\n# Source FF6 theme files" >> "$HYPR_DIR/hyprland.conf"
    echo "source = ./colors.conf" >> "$HYPR_DIR/hyprland.conf"
    echo "source = ./animations.conf" >> "$HYPR_DIR/hyprland.conf"
fi

# Fix Waybar autostart
echo -e "${YELLOW}Fixing Waybar autostart...${NC}"

# Ensure waybar is started in hyprland.conf
if ! grep -q "waybar" "$HYPR_DIR/hyprland.conf"; then
    echo -e "\n# Autostart applications" >> "$HYPR_DIR/hyprland.conf"
    echo "exec-once = waybar" >> "$HYPR_DIR/hyprland.conf"
fi

# Create a startup script to ensure all components run
echo -e "${YELLOW}Creating autostart script...${NC}"

mkdir -p "$HYPR_DIR/scripts"
cat > "$HYPR_DIR/scripts/autostart.sh" << 'EOF'
#!/bin/bash

# FF6 Hyprland Autostart Script
# This script ensures all necessary components are started

# Wait for desktop to fully load
sleep 2

# Start Waybar if not running
if ! pgrep -x "waybar" > /dev/null; then
    waybar &
fi

# Start notification daemon if not running
if ! pgrep -x "swaync" > /dev/null; then
    swaync &
fi

# Start wallpaper daemon if not running
if ! pgrep -x "swww" > /dev/null; then
    swww init &
fi

# Set wallpaper
if [ -f "$HOME/.config/hypr/wallpapers/current.png" ]; then
    swww img "$HOME/.config/hypr/wallpapers/current.png" &
elif [ -f "$HOME/.config/hypr/wallpapers/ff6_default.jpg" ]; then
    swww img "$HOME/.config/hypr/wallpapers/ff6_default.jpg" &
fi

# Start clipboard manager
if ! pgrep -x "cliphist" > /dev/null; then
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
fi

# Start polkit agent
if command -v polkit-kde-authentication-agent-1 > /dev/null; then
    /usr/lib/polkit-kde-authentication-agent-1 &
fi

# Generate sound effects if they don't exist
if [ ! -f "$HOME/.config/hypr/sounds/cursor.wav" ] || [ ! -f "$HOME/.config/hypr/sounds/confirm.wav" ]; then
    mkdir -p "$HOME/.config/hypr/sounds"
    if command -v sox > /dev/null; then
        sox -n "$HOME/.config/hypr/sounds/cursor.wav" synth 0.1 sine 1200 fade 0 0.1 0.05
        sox -n "$HOME/.config/hypr/sounds/confirm.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
    fi
fi

# Apply FF6 cursor theme
if [ -d "$HOME/.local/share/icons/AtmaWeapon" ]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'AtmaWeapon'
fi

echo "FF6 Hyprland autostart completed"
EOF

chmod +x "$HYPR_DIR/scripts/autostart.sh"

# Add autostart script to hyprland.conf
if ! grep -q "autostart.sh" "$HYPR_DIR/hyprland.conf"; then
    echo "exec-once = $HYPR_DIR/scripts/autostart.sh" >> "$HYPR_DIR/hyprland.conf"
fi

# Fix Waybar configuration
echo -e "${YELLOW}Fixing Waybar configuration...${NC}"

# Ensure Waybar directory exists
mkdir -p "$WAYBAR_DIR"

# Create Waybar style.css with proper FF6 theme
cat > "$WAYBAR_DIR/style.css" << 'EOF'
/* FF6-themed Waybar style
   Theme: Final Fantasy VI Menu Style */

/* Global styling */
* {
    font-family: "JetBrains Mono Nerd Font", "Victor Mono", "Fantastique Sans Mono Nerd", sans-serif;
    font-size: 14px;
    border-radius: 0;
    transition-property: background-color;
    transition-duration: 0.5s;
}

/* Main bar styling */
window#waybar {
    background: linear-gradient(135deg, rgba(10, 16, 96, 0.9) 0%, rgba(16, 32, 128, 0.9) 100%);
    color: #ffffff;
    border-bottom: 2px solid #ffffff;
}

/* Top bar */
#waybar.top {
    border-radius: 0 0 10px 10px;
    border: 2px solid #ffffff;
    border-top: none;
}

/* Bottom bar */
#waybar.bottom {
    border-radius: 10px 10px 0 0;
    border: 2px solid #ffffff;
    border-bottom: none;
}

/* Modules styling */
#workspaces,
#mode,
#clock,
#pulseaudio,
#network,
#cpu,
#memory,
#temperature,
#backlight,
#battery,
#custom-power,
#tray {
    background: rgba(16, 32, 128, 0.5);
    padding: 0 10px;
    margin: 5px 2px;
    border: 1px solid #ffffff;
    border-radius: 10px;
}

/* Workspaces */
#workspaces button {
    padding: 0 5px;
    color: #ffffff;
    background: transparent;
    border: none;
    border-radius: 10px;
}

#workspaces button.active {
    background: rgba(64, 128, 255, 0.4);
    border: 1px solid #ffffff;
}

#workspaces button:hover {
    background: rgba(64, 128, 255, 0.2);
    border: 1px solid #ffffff;
    box-shadow: inherit;
    text-shadow: inherit;
}

/* Clock */
#clock {
    font-weight: bold;
}

/* System indicators */
#cpu {
    color: #ffffff;
}

#memory {
    color: #ffffff;
}

#battery {
    color: #ffffff;
}

#battery.charging {
    color: #8aff80;
}

#battery.warning:not(.charging) {
    color: #ffb380;
}

#battery.critical:not(.charging) {
    color: #ff8080;
}

/* Custom modules */
#custom-launcher,
#custom-power {
    font-size: 16px;
    padding: 0 10px;
}

/* Window title */
#window {
    font-weight: bold;
    margin: 0 4px;
}

/* Tooltip styling */
tooltip {
    background: rgba(10, 16, 96, 0.9);
    border: 2px solid #ffffff;
    border-radius: 10px;
}

tooltip label {
    color: #ffffff;
}
EOF

# Create Waybar top config
cat > "$WAYBAR_DIR/config-top.jsonc" << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 4,
    "margin-top": 0,
    "margin-bottom": 0,
    
    "modules-left": [
        "custom/ff6",
        "custom/magic",
        "custom/relics",
        "custom/espers"
    ],
    
    "modules-center": [
        "clock"
    ],
    
    "modules-right": [
        "cpu",
        "memory",
        "battery",
        "pulseaudio",
        "custom/power"
    ],
    
    "custom/ff6": {
        "format": " FF6",
        "tooltip": "Left click: Applications Menu | Right click: Window Overview",
        "on-click": "rofi -show drun",
        "on-click-right": "hyprctl dispatch workspace empty"
    },
    
    "custom/magic": {
        "format": " Magic",
        "tooltip": "Left click: Terminal (Magic) | Right click: File Manager (Items)",
        "on-click": "kitty",
        "on-click-right": "thunar"
    },
    
    "custom/relics": {
        "format": " Relics",
        "tooltip": "Left click: Browser (Relics) | Right click: Theme Settings (Config)",
        "on-click": "firefox",
        "on-click-right": "nwg-look"
    },
    
    "custom/espers": {
        "format": " Espers",
        "tooltip": "Left click: Wallpaper Menu | Right click: Random Wallpaper",
        "on-click": "~/.config/hypr/scripts/wallpaper-menu.sh",
        "on-click-right": "~/.config/hypr/scripts/wallpaper-random.sh"
    },
    
    "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%Y-%m-%d %H:%M:%S}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "interval": 1
    },
    
    "cpu": {
        "format": "HP {usage}%",
        "tooltip": true,
        "interval": 2
    },
    
    "memory": {
        "format": "MP {percentage}%",
        "tooltip": true,
        "interval": 2
    },
    
    "battery": {
        "states": {
            "good": 95,
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-plugged": " {capacity}%",
        "format-alt": "{time} {icon}",
        "format-icons": ["", "", "", "", ""]
    },
    
    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": " Muted",
        "format-icons": {
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    },
    
    "custom/power": {
        "format": "Save",
        "tooltip": "Left click: Power Menu | Right click: Lock Screen",
        "on-click": "~/.config/rofi/scripts/powermenu.sh",
        "on-click-right": "swaylock"
    }
}
EOF

# Create Waybar bottom config
cat > "$WAYBAR_DIR/config-bottom.jsonc" << 'EOF'
{
    "layer": "top",
    "position": "bottom",
    "height": 30,
    "spacing": 4,
    "margin-top": 0,
    "margin-bottom": 0,
    
    "modules-left": [
        "hyprland/workspaces"
    ],
    
    "modules-center": [
        "hyprland/window"
    ],
    
    "modules-right": [
        "network",
        "custom/updates"
    ],
    
    "hyprland/workspaces": {
        "format": "{name}",
        "on-click": "activate",
        "all-outputs": true,
        "sort-by-number": true,
        "format-icons": {
            "1": "Terra",
            "2": "Locke",
            "3": "Edgar",
            "4": "Sabin",
            "5": "Cyan",
            "6": "Gau",
            "7": "Celes",
            "8": "Setzer",
            "9": "Shadow",
            "10": "Mog"
        },
        "persistent-workspaces": {
            "1": [],
            "2": [],
            "3": [],
            "4": []
        }
    },
    
    "hyprland/window": {
        "format": "{}",
        "max-length": 50,
        "separate-outputs": true
    },
    
    "network": {
        "format-wifi": "Chocobo {essid}",
        "format-ethernet": "Magitek {ipaddr}",
        "format-linked": "Magitek (No IP)",
        "format-disconnected": "Disconnected",
        "format-alt": "{ifname}: {ipaddr}/{cidr}",
        "tooltip-format": "{ifname} via {gwaddr}",
        "on-click": "nm-connection-editor"
    },
    
    "custom/updates": {
        "format": "Updates {}",
        "exec": "checkupdates | wc -l",
        "exec-if": "[ $(checkupdates | wc -l) -gt 0 ]",
        "interval": 3600,
        "on-click": "kitty -e sudo pacman -Syu"
    }
}
EOF

# Make sure Waybar is executable
chmod +x "$(which waybar)" 2>/dev/null || true

echo -e "${GREEN}Fixes applied successfully!${NC}"
echo -e "${YELLOW}Please restart Hyprland to apply the changes.${NC}"
echo -e "${YELLOW}You can do this by logging out and back in, or by running:${NC}"
echo -e "${BLUE}hyprctl dispatch exit${NC}"
echo
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}  FF6 Hyprland Configuration Fixed!    ${NC}"
echo -e "${BLUE}=========================================${NC}"
