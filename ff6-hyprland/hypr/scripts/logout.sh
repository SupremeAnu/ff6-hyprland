#!/bin/bash
# FF6-Themed Hyprland Configuration - Logout Script
# This script provides a logout/power menu with FF6 styling

# Check if wlogout is installed
if ! command -v wlogout &> /dev/null; then
    echo "wlogout is not installed. Please install it first."
    exit 1
fi

# Create wlogout configuration directory if it doesn't exist
mkdir -p ~/.config/wlogout

# Create FF6-themed wlogout style
cat > ~/.config/wlogout/style.css << 'EOF'
* {
    background-image: none;
    font-family: "JetBrains Mono Nerd Font", sans-serif;
}

window {
    background-color: rgba(10, 26, 63, 0.9);
    border: 2px solid #ffffff;
    border-radius: 8px;
}

button {
    color: #ffffff;
    background-color: #1a2a5f;
    border: 1px solid #d0d0ff;
    border-radius: 6px;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    margin: 5px;
}

button:focus, button:active, button:hover {
    background-color: #4a5aaf;
    color: #ffff80;
    border: 1px solid #ffffff;
    outline-style: none;
}

#lock {
    background-image: image(url("/usr/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
}

#logout {
    background-image: image(url("/usr/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
}

#suspend {
    background-image: image(url("/usr/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
}

#hibernate {
    background-image: image(url("/usr/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
}

#shutdown {
    background-image: image(url("/usr/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
}

#reboot {
    background-image: image(url("/usr/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
}
EOF

# Create wlogout layout configuration
cat > ~/.config/wlogout/layout << 'EOF'
{
    "label" : "lock",
    "action" : "$HOME/.config/hypr/scripts/lockscreen.sh",
    "text" : "Lock",
    "keybind" : "l"
}
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Hibernate",
    "keybind" : "h"
}
{
    "label" : "logout",
    "action" : "hyprctl dispatch exit 0",
    "text" : "Logout",
    "keybind" : "e"
}
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Shutdown",
    "keybind" : "s"
}
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Suspend",
    "keybind" : "u"
}
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Reboot",
    "keybind" : "r"
}
EOF

# Play FF6 menu sound effect if available
if [ -f "$HOME/.config/hypr/sounds/menu.wav" ]; then
    paplay "$HOME/.config/hypr/sounds/menu.wav" &
fi

# Launch wlogout with FF6 styling
wlogout -b 2 -c 0 -r 0 -m 0 --protocol layer-shell

exit 0
