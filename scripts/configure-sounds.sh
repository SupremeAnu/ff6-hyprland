#!/bin/bash
# Configure system interactions with FF6 sounds
# Theme: Final Fantasy VI Menu Style
# Created: April 2025

# Create directory for sounds
mkdir -p ~/.config/hypr/sounds

# Copy sound files
cp -f ~/.config/hypr/sounds/cursor.wav ~/.config/hypr/sounds/
cp -f ~/.config/hypr/sounds/confirm.wav ~/.config/hypr/sounds/

# Configure Hyprland to play sounds on interactions
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# Add sound configuration section if it doesn't exist
if ! grep -q "# FF6 Sound Effects" "$HYPR_CONF"; then
    cat >> "$HYPR_CONF" << EOF

# FF6 Sound Effects
exec-once = paplay ~/.config/hypr/sounds/confirm.wav # Play sound at startup

# Bind sounds to window actions
bind = SUPER, Return, exec, kitty && paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER, E, exec, thunar && paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER, D, exec, rofi -show drun && paplay ~/.config/hypr/sounds/confirm.wav

# Add sound to workspace switching
bind = SUPER, 1, workspace, 1, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 2, workspace, 2, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 3, workspace, 3, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 4, workspace, 4, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 5, workspace, 5, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 6, workspace, 6, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 7, workspace, 7, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 8, workspace, 8, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 9, workspace, 9, paplay ~/.config/hypr/sounds/cursor.wav
bind = SUPER, 0, workspace, 10, paplay ~/.config/hypr/sounds/cursor.wav

# Add sound to window movement
bind = SUPER SHIFT, 1, movetoworkspace, 1, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 2, movetoworkspace, 2, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 3, movetoworkspace, 3, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 4, movetoworkspace, 4, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 5, movetoworkspace, 5, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 6, movetoworkspace, 6, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 7, movetoworkspace, 7, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 8, movetoworkspace, 8, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 9, movetoworkspace, 9, paplay ~/.config/hypr/sounds/confirm.wav
bind = SUPER SHIFT, 0, movetoworkspace, 10, paplay ~/.config/hypr/sounds/confirm.wav
EOF
fi

# Configure Waybar to play sounds on clicks
WAYBAR_TOP="$HOME/.config/waybar/config-top.jsonc"

# Update Waybar configuration to include sound on click
sed -i 's/"on-click": "/"on-click": "paplay ~/.config\/hypr\/sounds\/confirm.wav \&\& /g' "$WAYBAR_TOP"
sed -i 's/"on-click-right": "/"on-click-right": "paplay ~/.config\/hypr\/sounds\/cursor.wav \&\& /g' "$WAYBAR_TOP"

echo "FF6 sound effects configured for system interactions!"
