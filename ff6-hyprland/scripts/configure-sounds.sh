#!/bin/bash
# FF6 Hyprland Sound Configuration Script
# Configures audio and generates FF6 sound effects
# Created: April 2025

# Set up sound directory
SOUND_DIR="$HOME/.config/hypr/sounds"
mkdir -p "$SOUND_DIR"

echo "Configuring FF6 sound effects..."

# Generate FF6-style cursor sound using SoX
if ! [ -f "$SOUND_DIR/cursor.wav" ]; then
    echo "Generating cursor sound..."
    sox -n "$SOUND_DIR/cursor.wav" synth 0.05 sine 1200 fade 0 0.05 0.02 vol 0.5
    echo "Cursor sound generated."
fi

# Generate FF6-style confirm sound using SoX
if ! [ -f "$SOUND_DIR/confirm.wav" ]; then
    echo "Generating confirm sound..."
    sox -n "$SOUND_DIR/confirm.wav" synth 0.1 sine 800:1200 fade 0 0.1 0.03 vol 0.5
    echo "Confirm sound generated."
fi

# Generate FF6-style menu open sound
if ! [ -f "$SOUND_DIR/menu_open.wav" ]; then
    echo "Generating menu open sound..."
    sox -n "$SOUND_DIR/menu_open.wav" synth 0.15 sine 600:900 fade 0 0.15 0.05 vol 0.5
    echo "Menu open sound generated."
fi

# Generate FF6-style error sound
if ! [ -f "$SOUND_DIR/error.wav" ]; then
    echo "Generating error sound..."
    sox -n "$SOUND_DIR/error.wav" synth 0.2 sine 300:200 fade 0 0.2 0.05 vol 0.5
    echo "Error sound generated."
fi

# Configure system audio
echo "Configuring system audio..."

# Ensure PulseAudio is running
if ! pgrep -x "pulseaudio" > /dev/null; then
    echo "Starting PulseAudio..."
    pulseaudio --start
fi

# Set default audio settings
pactl set-sink-volume @DEFAULT_SINK@ 80%
pactl set-sink-mute @DEFAULT_SINK@ 0

# Configure audio for Hyprland
echo "Configuring Hyprland audio integration..."

# Create swaync config directory if it doesn't exist
mkdir -p "$HOME/.config/swaync"

# Configure swaync to use FF6 sounds
cat > "$HOME/.config/swaync/config.json" << EOF
{
  "positionX": "right",
  "positionY": "top",
  "control-center-margin-top": 10,
  "control-center-margin-bottom": 10,
  "control-center-margin-right": 10,
  "control-center-margin-left": 0,
  "notification-icon-size": 64,
  "notification-body-image-height": 100,
  "notification-body-image-width": 200,
  "timeout": 10,
  "timeout-low": 5,
  "timeout-critical": 0,
  "fit-to-screen": true,
  "control-center-width": 500,
  "control-center-height": 600,
  "notification-window-width": 500,
  "keyboard-shortcuts": true,
  "image-visibility": "when-available",
  "transition-time": 200,
  "hide-on-clear": false,
  "hide-on-action": true,
  "script-fail-notify": true,
  "scripts": {
    "example-script": {
      "exec": "echo 'example notification'",
      "urgency": "Normal"
    }
  },
  "notification-visibility": {
    "example-name": {
      "state": "muted",
      "urgency": "Low",
      "app-name": "example-app"
    }
  },
  "widgets": [
    "title",
    "dnd",
    "notifications"
  ],
  "widget-config": {
    "title": {
      "text": "FF6 Notifications",
      "clear-all-button": true,
      "button-text": "Clear All"
    },
    "dnd": {
      "text": "Do Not Disturb"
    },
    "label": {
      "max-lines": 5,
      "text": "Label Text"
    },
    "mpris": {
      "image-size": 96,
      "image-radius": 12
    }
  },
  "sounds": {
    "critical": "$SOUND_DIR/error.wav",
    "notification": "$SOUND_DIR/cursor.wav",
    "action": "$SOUND_DIR/confirm.wav"
  }
}
EOF

# Configure Hyprland to play sounds on certain actions
cat > "$HOME/.config/hypr/scripts/play-sound.sh" << EOF
#!/bin/bash
# Script to play FF6 sounds for Hyprland actions

SOUND_DIR="$HOME/.config/hypr/sounds"

case "\$1" in
    "cursor")
        paplay "\$SOUND_DIR/cursor.wav" &
        ;;
    "confirm")
        paplay "\$SOUND_DIR/confirm.wav" &
        ;;
    "menu_open")
        paplay "\$SOUND_DIR/menu_open.wav" &
        ;;
    "error")
        paplay "\$SOUND_DIR/error.wav" &
        ;;
    *)
        echo "Unknown sound: \$1"
        ;;
esac
EOF

# Make the script executable
chmod +x "$HOME/.config/hypr/scripts/play-sound.sh"

# Create a script to test sounds
cat > "$HOME/.config/hypr/scripts/test-sounds.sh" << EOF
#!/bin/bash
# Script to test FF6 sounds

SOUND_DIR="$HOME/.config/hypr/sounds"

echo "Testing FF6 sounds..."
echo "Playing cursor sound..."
paplay "\$SOUND_DIR/cursor.wav"
sleep 1

echo "Playing confirm sound..."
paplay "\$SOUND_DIR/confirm.wav"
sleep 1

echo "Playing menu open sound..."
paplay "\$SOUND_DIR/menu_open.wav"
sleep 1

echo "Playing error sound..."
paplay "\$SOUND_DIR/error.wav"
sleep 1

echo "Sound test complete."
EOF

# Make the test script executable
chmod +x "$HOME/.config/hypr/scripts/test-sounds.sh"

# Update waybar config to play sounds on click
sed -i 's/"on-click": "rofi -show drun",/"on-click": "~\/.config\/hypr\/scripts\/play-sound.sh confirm \&\& rofi -show drun",/g' "$HOME/.config/waybar/config-top.jsonc"
sed -i 's/"on-click": "kitty",/"on-click": "~\/.config\/hypr\/scripts\/play-sound.sh confirm \&\& kitty",/g' "$HOME/.config/waybar/config-top.jsonc"
sed -i 's/"on-click": "firefox",/"on-click": "~\/.config\/hypr\/scripts\/play-sound.sh confirm \&\& firefox",/g' "$HOME/.config/waybar/config-top.jsonc"
sed -i 's/"on-click": "~\/.config\/hypr\/scripts\/wallpaper-menu.sh",/"on-click": "~\/.config\/hypr\/scripts\/play-sound.sh menu_open \&\& ~\/.config\/hypr\/scripts\/wallpaper-menu.sh",/g' "$HOME/.config/waybar/config-top.jsonc"
sed -i 's/"on-click": "~\/.config\/hypr\/scripts\/powermenu.sh",/"on-click": "~\/.config\/hypr\/scripts\/play-sound.sh menu_open \&\& ~\/.config\/hypr\/scripts\/powermenu.sh",/g' "$HOME/.config/waybar/config-top.jsonc"

# Update keybinds to play sounds
sed -i '/bind = SUPER, D, exec, rofi -show drun/c\bind = SUPER, D, exec, ~/.config/hypr/scripts/play-sound.sh confirm \&\& rofi -show drun' "$HOME/.config/hypr/keybinds.conf"
sed -i '/bind = SUPER, Return, exec, kitty/c\bind = SUPER, Return, exec, ~/.config/hypr/scripts/play-sound.sh confirm \&\& kitty' "$HOME/.config/hypr/keybinds.conf"
sed -i '/bind = SUPER, E, exec, thunar/c\bind = SUPER, E, exec, ~/.config/hypr/scripts/play-sound.sh confirm \&\& thunar' "$HOME/.config/hypr/keybinds.conf"

echo "Audio configuration complete."
echo "Run ~/.config/hypr/scripts/test-sounds.sh to test the FF6 sounds."
