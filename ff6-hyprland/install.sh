#!/bin/bash
# FF6 Hyprland Configuration Auto-Installer
# Created: April 2025
# Credits: Some components adapted from JaKooLit's Hyprland-Dots (https://github.com/JaKooLit/Hyprland-Dots)

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
KITTY_DIR="$CONFIG_DIR/kitty"
SWAPPY_DIR="$CONFIG_DIR/swappy"
SWAYNC_DIR="$CONFIG_DIR/swaync"
KVANTUM_DIR="$CONFIG_DIR/Kvantum"
GTK_DIR="$HOME/.config/gtk-3.0"
QT5CT_DIR="$CONFIG_DIR/qt5ct"
QT6CT_DIR="$CONFIG_DIR/qt6ct"
THUNAR_DIR="$CONFIG_DIR/Thunar"
CURSOR_DIR="$HOME/.local/share/icons"
FONTS_DIR="$HOME/.local/share/fonts"
DOTFILES_DIR="$HOME"
AGS_DIR="$CONFIG_DIR/ags"
XDG_DIR="$CONFIG_DIR/xdg-desktop-portal"
SOUNDS_DIR="$HYPR_DIR/sounds"
SPRITES_DIR="$CONFIG_DIR/sprites"

# Backup directory
BACKUP_DIR="$HOME/.config/hypr-ff6-backup-$(date +%Y%m%d%H%M%S)"

# Print header
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Final Fantasy VI Hyprland Installer   ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        echo -e "${GREEN}Detected distribution: $DISTRO${NC}"
        return 0
    else
        echo -e "${YELLOW}Warning: Unable to detect distribution. Assuming Arch Linux.${NC}"
        DISTRO="arch"
        return 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if a package is installed (for different package managers)
package_installed() {
    local pkg="$1"
    
    case "$DISTRO" in
        arch|manjaro|endeavouros|garuda)
            pacman -Q "$pkg" &> /dev/null
            return $?
            ;;
        debian|ubuntu|pop|linuxmint)
            dpkg -l "$pkg" &> /dev/null
            return $?
            ;;
        fedora|centos|rhel)
            rpm -q "$pkg" &> /dev/null
            return $?
            ;;
        *)
            # Fallback method - try to check if the command exists
            if [[ "$pkg" == *-* ]]; then
                # For packages with hyphens, try to check the command after the last hyphen
                local cmd=$(echo "$pkg" | rev | cut -d'-' -f1 | rev)
                command_exists "$cmd" && return 0
            else
                command_exists "$pkg" && return 0
            fi
            return 1
            ;;
    esac
}

# Function to get equivalent package name for different distributions
get_package_name() {
    local pkg="$1"
    
    case "$DISTRO" in
        arch|manjaro|endeavouros|garuda)
            echo "$pkg"
            ;;
        debian|ubuntu|pop|linuxmint)
            case "$pkg" in
                "hyprland") echo "hyprland" ;;
                "waybar") echo "waybar" ;;
                "rofi-wayland") echo "rofi" ;;
                "kitty") echo "kitty" ;;
                "kvantum") echo "qt5-style-kvantum" ;;
                "cava") echo "cava" ;;
                "grim") echo "grim" ;;
                "slurp") echo "slurp" ;;
                "swappy") echo "swappy" ;;
                "swww") echo "swww" ;;
                "cliphist") echo "cliphist" ;;
                "swaync") echo "swaync" ;;
                "swaybg") echo "swaybg" ;;
                "wallust") echo "wallust" ;;
                "nwg-look") echo "nwg-look" ;;
                "gtk3") echo "libgtk-3-0" ;;
                "qt5ct") echo "qt5ct" ;;
                "qt6ct") echo "qt6ct" ;;
                "thunar") echo "thunar" ;;
                "hyprlock") echo "hyprlock" ;;
                "hypridle") echo "hypridle" ;;
                "ags") echo "aylurs-gtk-shell" ;;
                "papirus-icon-theme") echo "papirus-icon-theme" ;;
                "ttf-jetbrains-mono-nerd") echo "fonts-jetbrains-mono" ;;
                "ttf-victor-mono") echo "fonts-victor-mono" ;;
                "ttf-fantasque-sans-mono") echo "fonts-fantasque-sans" ;;
                "polkit-kde-agent") echo "polkit-kde-agent-1" ;;
                "python") echo "python3" ;;
                "python-pip") echo "python3-pip" ;;
                "python-pillow") echo "python3-pil" ;;
                "btop") echo "btop" ;;
                "pavucontrol") echo "pavucontrol" ;;
                "networkmanager") echo "network-manager" ;;
                "blueman") echo "blueman" ;;
                "xdg-desktop-portal-hyprland") echo "xdg-desktop-portal-hyprland" ;;
                "xdg-utils") echo "xdg-utils" ;;
                "imagemagick") echo "imagemagick" ;;
                "wl-clipboard") echo "wl-clipboard" ;;
                "sox") echo "sox" ;;
                "pulseaudio") echo "pulseaudio" ;;
                "pulseaudio-utils") echo "pulseaudio-utils" ;;
                "jq") echo "jq" ;;
                "yad") echo "yad" ;;
                "zenity") echo "zenity" ;;
                "xcursor-themes") echo "xcursor-themes" ;;
                "xorg-xcursorgen") echo "x11-apps" ;;
                "brightnessctl") echo "brightnessctl" ;;
                "pamixer") echo "pamixer" ;;
                "nodejs") echo "nodejs" ;;
                "npm") echo "npm" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        fedora|centos|rhel)
            case "$pkg" in
                "hyprland") echo "hyprland" ;;
                "waybar") echo "waybar" ;;
                "rofi-wayland") echo "rofi" ;;
                "kitty") echo "kitty" ;;
                "kvantum") echo "kvantum" ;;
                "cava") echo "cava" ;;
                "grim") echo "grim" ;;
                "slurp") echo "slurp" ;;
                "swappy") echo "swappy" ;;
                "swww") echo "swww" ;;
                "cliphist") echo "cliphist" ;;
                "swaync") echo "swaync" ;;
                "swaybg") echo "swaybg" ;;
                "wallust") echo "wallust" ;;
                "nwg-look") echo "nwg-look" ;;
                "gtk3") echo "gtk3" ;;
                "qt5ct") echo "qt5ct" ;;
                "qt6ct") echo "qt6ct" ;;
                "thunar") echo "thunar" ;;
                "hyprlock") echo "hyprlock" ;;
                "hypridle") echo "hypridle" ;;
                "ags") echo "aylurs-gtk-shell" ;;
                "papirus-icon-theme") echo "papirus-icon-theme" ;;
                "ttf-jetbrains-mono-nerd") echo "jetbrains-mono-fonts-all" ;;
                "ttf-victor-mono") echo "victor-mono-fonts" ;;
                "ttf-fantasque-sans-mono") echo "fantasque-sans-mono-fonts" ;;
                "polkit-kde-agent") echo "polkit-kde-authentication-agent-1" ;;
                "python") echo "python3" ;;
                "python-pip") echo "python3-pip" ;;
                "python-pillow") echo "python3-pillow" ;;
                "btop") echo "btop" ;;
                "pavucontrol") echo "pavucontrol" ;;
                "networkmanager") echo "NetworkManager" ;;
                "blueman") echo "blueman" ;;
                "xdg-desktop-portal-hyprland") echo "xdg-desktop-portal-hyprland" ;;
                "xdg-utils") echo "xdg-utils" ;;
                "imagemagick") echo "ImageMagick" ;;
                "wl-clipboard") echo "wl-clipboard" ;;
                "sox") echo "sox" ;;
                "pulseaudio") echo "pulseaudio" ;;
                "pulseaudio-utils") echo "pulseaudio-utils" ;;
                "jq") echo "jq" ;;
                "yad") echo "yad" ;;
                "zenity") echo "zenity" ;;
                "xcursor-themes") echo "xcursor-themes" ;;
                "xorg-xcursorgen") echo "xcursorgen" ;;
                "brightnessctl") echo "brightnessctl" ;;
                "pamixer") echo "pamixer" ;;
                "nodejs") echo "nodejs" ;;
                "npm") echo "npm" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        *)
            echo "$pkg"
            ;;
    esac
}

# Function to install a package if not already installed
install_package() {
    local pkg="$1"
    local distro_pkg=$(get_package_name "$pkg")
    
    if ! package_installed "$distro_pkg"; then
        echo -e "${YELLOW}Installing $distro_pkg...${NC}"
        
        case "$DISTRO" in
            arch|manjaro|endeavouros|garuda)
                if command_exists yay; then
                    yay -S --needed --noconfirm "$distro_pkg" || {
                        echo -e "${YELLOW}Warning: Failed to install $distro_pkg with yay. Skipping...${NC}"
                        return 1
                    }
                else
                    sudo pacman -S --needed --noconfirm "$distro_pkg" || {
                        echo -e "${YELLOW}Warning: Failed to install $distro_pkg with pacman. Skipping...${NC}"
                        return 1
                    }
                fi
                ;;
            debian|ubuntu|pop|linuxmint)
                sudo apt update && sudo apt install -y "$distro_pkg" || {
                    echo -e "${YELLOW}Warning: Failed to install $distro_pkg with apt. Skipping...${NC}"
                    return 1
                }
                ;;
            fedora)
                sudo dnf install -y "$distro_pkg" || {
                    echo -e "${YELLOW}Warning: Failed to install $distro_pkg with dnf. Skipping...${NC}"
                    return 1
                }
                ;;
            centos|rhel)
                sudo yum install -y "$distro_pkg" || {
                    echo -e "${YELLOW}Warning: Failed to install $distro_pkg with yum. Skipping...${NC}"
                    return 1
                }
                ;;
            *)
                echo -e "${RED}Error: No supported package manager found for $DISTRO. Please install $distro_pkg manually.${NC}"
                return 1
                ;;
        esac
        echo -e "${GREEN}$distro_pkg installed.${NC}"
    else
        echo -e "${GREEN}$distro_pkg is already installed.${NC}"
    fi
}

# Function to check for audio package conflicts
check_audio_conflicts() {
    local audio_system=""
    
    # Check for PulseAudio
    if package_installed "pulseaudio" || command_exists pulseaudio; then
        audio_system="pulseaudio"
    fi
    
    # Check for PipeWire
    if package_installed "pipewire" || package_installed "pipewire-pulse" || command_exists pipewire; then
        if [ -n "$audio_system" ]; then
            echo -e "${YELLOW}Warning: Both PulseAudio and PipeWire detected.${NC}"
            echo -e "${YELLOW}This may cause conflicts. It's recommended to use only one audio system.${NC}"
            
            read -p "Do you want to use PipeWire and remove PulseAudio? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${YELLOW}Removing PulseAudio and configuring PipeWire...${NC}"
                
                case "$DISTRO" in
                    arch|manjaro|endeavouros|garuda)
                        sudo pacman -R --noconfirm pulseaudio pulseaudio-bluetooth || true
                        install_package "pipewire"
                        install_package "pipewire-pulse"
                        install_package "pipewire-alsa"
                        install_package "wireplumber"
                        ;;
                    debian|ubuntu|pop|linuxmint)
                        sudo apt remove --purge -y pulseaudio pulseaudio-utils pulseaudio-module-bluetooth || true
                        sudo apt install -y pipewire pipewire-pulse wireplumber
                        ;;
                    fedora|centos|rhel)
                        sudo dnf remove -y pulseaudio pulseaudio-utils || true
                        sudo dnf install -y pipewire pipewire-pulseaudio wireplumber
                        ;;
                esac
                
                audio_system="pipewire"
                echo -e "${GREEN}Audio system configured to use PipeWire.${NC}"
            else
                echo -e "${GREEN}Keeping PulseAudio as the audio system.${NC}"
                audio_system="pulseaudio"
            fi
        else
            audio_system="pipewire"
        fi
    fi
    
    # If no audio system detected, install PipeWire as default
    if [ -z "$audio_system" ]; then
        echo -e "${YELLOW}No audio system detected. Installing PipeWire...${NC}"
        
        case "$DISTRO" in
            arch|manjaro|endeavouros|garuda)
                install_package "pipewire"
                install_package "pipewire-pulse"
                install_package "pipewire-alsa"
                install_package "wireplumber"
                ;;
            debian|ubuntu|pop|linuxmint)
                sudo apt install -y pipewire pipewire-pulse wireplumber
                ;;
            fedora|centos|rhel)
                sudo dnf install -y pipewire pipewire-pulseaudio wireplumber
                ;;
        esac
        
        audio_system="pipewire"
        echo -e "${GREEN}Audio system configured to use PipeWire.${NC}"
    fi
    
    echo -e "${GREEN}Using $audio_system as the audio system.${NC}"
    return 0
}

# Function to backup existing config
backup_config() {
    if [ -d "$1" ]; then
        local backup_path="$BACKUP_DIR/$(basename "$1")"
        echo -e "${YELLOW}Backing up $1 to $backup_path${NC}"
        mkdir -p "$(dirname "$backup_path")"
        cp -r "$1" "$backup_path"
        echo -e "${GREEN}Backup created.${NC}"
    fi
}

# Function to create directory if it doesn't exist
create_dir() {
    if [ ! -d "$1" ]; then
        echo -e "${YELLOW}Creating directory $1${NC}"
        mkdir -p "$1"
        echo -e "${GREEN}Directory created.${NC}"
    fi
}

# Function to install Python packages
install_python_packages() {
    echo -e "${BLUE}Installing required Python packages...${NC}"
    
    # Check if pip is installed
    if ! command_exists pip && ! command_exists pip3; then
        echo -e "${YELLOW}pip not found. Installing...${NC}"
        install_package "python-pip"
    fi
    
    # Use pip3 if available, otherwise use pip
    local PIP_CMD="pip"
    if command_exists pip3; then
        PIP_CMD="pip3"
    fi
    
    # Install required Python packages
    echo -e "${YELLOW}Installing Pillow (Python Imaging Library)...${NC}"
    $PIP_CMD install --user Pillow || {
        echo -e "${YELLOW}Warning: Failed to install Pillow with pip. Trying system package...${NC}"
        install_package "python-pillow"
    }
    
    echo -e "${GREEN}Python packages installed.${NC}"
}

# Function to install FF6 sound effects
install_sound_effects() {
    echo -e "${BLUE}Installing FF6 sound effects...${NC}"
    create_dir "$SOUNDS_DIR"
    
    # Define sound effects
    local SOUND_EFFECTS=(
        "cursor_move.wav"
        "menu_open.wav"
        "menu_close.wav"
        "menu_select.wav"
        "confirm.wav"
        "cancel.wav"
    )
    
    # Check if sox is installed for sound generation
    if ! command_exists sox; then
        echo -e "${YELLOW}sox not found. Installing...${NC}"
        install_package "sox"
    fi
    
    # Generate sound effects using sox
    echo -e "${YELLOW}Generating FF6-style sound effects...${NC}"
    
    # Cursor move sound (short beep)
    sox -n "$SOUNDS_DIR/cursor_move.wav" synth 0.1 sine 1000 fade 0 0.1 0.05
    
    # Menu open sound (ascending tones)
    sox -n "$SOUNDS_DIR/menu_open.wav" synth 0.15 sine 800:1200 fade 0 0.15 0.05
    
    # Menu close sound (descending tones)
    sox -n "$SOUNDS_DIR/menu_close.wav" synth 0.15 sine 1200:800 fade 0 0.15 0.05
    
    # Menu select sound (two-tone beep)
    sox -n "$SOUNDS_DIR/menu_select.wav" synth 0.1 sine 1200 synth 0.1 sine 1600 fade 0 0.2 0.05
    
    # Confirm sound (happy chime)
    sox -n "$SOUNDS_DIR/confirm.wav" synth 0.1 sine 1000 synth 0.1 sine 1200 synth 0.1 sine 1500 fade 0 0.3 0.1
    
    # Cancel sound (negative tone)
    sox -n "$SOUNDS_DIR/cancel.wav" synth 0.15 sine 1000:700 fade 0 0.15 0.05
    
    echo -e "${GREEN}FF6 sound effects created.${NC}"
}

# Function to install FF6 sprites
install_ff6_sprites() {
    echo -e "${BLUE}Installing FF6 character sprites...${NC}"
    create_dir "$SPRITES_DIR"
    
    # Check if sprites already exist
    if [ ! -f "$SPRITES_DIR/terra.png" ] || [ ! -f "$SPRITES_DIR/locke.png" ] || [ ! -f "$SPRITES_DIR/edgar.png" ]; then
        # Create a Python script to generate sprites
        local SPRITE_SCRIPT="$SPRITES_DIR/generate_sprites.py"
        cat > "$SPRITE_SCRIPT" << 'EOF'
#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os

# Define sprite directory
sprite_dir = os.path.dirname(os.path.abspath(__file__))

# Function to create a simple FF6-style sprite
def create_sprite(filename, primary_color, secondary_color, hair_color):
    # Create a transparent image
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw face
    draw.ellipse((8, 6, 24, 22), fill=primary_color)
    
    # Draw hair
    draw.rectangle((6, 4, 26, 12), fill=hair_color)
    
    # Draw eyes
    draw.ellipse((12, 12, 15, 14), fill=(0, 0, 0))
    draw.ellipse((19, 12, 22, 14), fill=(0, 0, 0))
    
    # Draw mouth
    draw.line((14, 18, 18, 18), fill=(0, 0, 0), width=1)
    
    # Draw body
    draw.rectangle((10, 22, 22, 30), fill=secondary_color)
    
    # Save the sprite
    img.save(os.path.join(sprite_dir, filename))
    print(f"Created sprite: {filename}")

# Create Terra sprite (green hair)
create_sprite("terra.png", (255, 223, 196), (255, 0, 0), (0, 200, 100))

# Create Locke sprite (blonde)
create_sprite("locke.png", (255, 223, 196), (0, 0, 255), (240, 220, 130))

# Create Edgar sprite (blonde)
create_sprite("edgar.png", (255, 223, 196), (0, 100, 200), (240, 220, 130))

# Create Celes sprite (blonde)
create_sprite("celes.png", (255, 223, 196), (255, 255, 255), (240, 220, 130))

# Create Setzer sprite (silver hair)
create_sprite("setzer.png", (255, 223, 196), (100, 0, 100), (200, 200, 200))

print("All sprites generated successfully!")
EOF
        
        # Make the script executable
        chmod +x "$SPRITE_SCRIPT"
        
        # Run the script to generate sprites
        echo -e "${YELLOW}Generating FF6 character sprites...${NC}"
        python3 "$SPRITE_SCRIPT"
        
        echo -e "${GREEN}FF6 character sprites created.${NC}"
    else
        echo -e "${GREEN}FF6 character sprites already exist.${NC}"
    fi
}

# Function to install FF6 cursor theme
install_ff6_cursor() {
    echo -e "${BLUE}Installing FF6 Atma Weapon cursor theme...${NC}"
    
    # Create cursor directories
    local CURSOR_THEME_DIR="$CURSOR_DIR/AtmaWeapon"
    create_dir "$CURSOR_THEME_DIR/cursors"
    
    # Check if ImageMagick is installed
    if ! command_exists convert; then
        echo -e "${YELLOW}ImageMagick not found. Installing...${NC}"
        install_package "imagemagick"
    fi
    
    # Check if xcursorgen is installed
    if ! command_exists xcursorgen; then
        echo -e "${YELLOW}xcursorgen not found. Installing...${NC}"
        install_package "xorg-xcursorgen"
    fi
    
    # Create a simple script to generate the cursor
    local CURSOR_SCRIPT="$CURSOR_THEME_DIR/generate_cursor.sh"
    cat > "$CURSOR_SCRIPT" << 'EOF'
#!/bin/bash
# Generate FF6 Atma Weapon cursor

# Set directories
THEME_DIR="$1"
CURSORS_DIR="$THEME_DIR/cursors"
TEMP_DIR="$THEME_DIR/temp"

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Create cursor config file
cat > "$TEMP_DIR/cursor.in" << EOC
24 12 12 left_ptr.png
EOC

# Create a simple sword cursor using ImageMagick
convert -size 24x24 xc:transparent -fill none -stroke blue -strokewidth 1 \
    -draw "line 6,6 18,18 line 18,18 6,18 line 6,18 12,12" \
    -fill gold -draw "circle 12,12 12,14" \
    "$TEMP_DIR/left_ptr.png"

# Generate the cursor
xcursorgen "$TEMP_DIR/cursor.in" "$CURSORS_DIR/left_ptr"

# Create symlinks for all cursor types
cd "$CURSORS_DIR"
for CURSOR in arrow default top_left_arrow; do
    ln -sf left_ptr "$CURSOR"
done

# Clean up
rm -rf "$TEMP_DIR"

echo "FF6 Atma Weapon cursor theme created successfully!"
EOF
    
    # Make the script executable
    chmod +x "$CURSOR_SCRIPT"
    
    # Run the script to generate the cursor
    echo -e "${YELLOW}Generating FF6 Atma Weapon cursor...${NC}"
    bash "$CURSOR_SCRIPT" "$CURSOR_THEME_DIR"
    
    # Create index.theme file
    cat > "$CURSOR_THEME_DIR/index.theme" << EOF
[Icon Theme]
Name=AtmaWeapon
Comment=FF6 Atma Weapon Cursor Theme
Inherits=Adwaita
EOF
    
    echo -e "${GREEN}FF6 Atma Weapon cursor theme installed.${NC}"
}

# Function to install FF6-themed waybar configuration
install_ff6_waybar() {
    echo -e "${BLUE}Installing FF6-themed waybar configuration...${NC}"
    
    # Create necessary directories
    create_dir "$WAYBAR_DIR"
    create_dir "$WAYBAR_DIR/modules"
    create_dir "$WAYBAR_DIR/portraits"
    
    # Copy waybar configuration files
    echo -e "${YELLOW}Copying waybar configuration files...${NC}"
    
    # Main configuration files
    cp -f waybar/config.jsonc "$WAYBAR_DIR/"
    cp -f waybar/style.css "$WAYBAR_DIR/"
    
    # Module files
    cp -f waybar/modules/ff6-character-stats.jsonc "$WAYBAR_DIR/modules/"
    cp -f waybar/modules/ff6-menu-options.jsonc "$WAYBAR_DIR/modules/"
    cp -f waybar/modules/ff6-menu-drawer.jsonc "$WAYBAR_DIR/modules/"
    
    # Copy character sprites for portraits if they exist
    if [ -d "$SPRITES_DIR" ]; then
        echo -e "${YELLOW}Copying character sprites for waybar portraits...${NC}"
        cp -f "$SPRITES_DIR/terra.png" "$WAYBAR_DIR/portraits/" 2>/dev/null || true
        cp -f "$SPRITES_DIR/locke.png" "$WAYBAR_DIR/portraits/gannon.png" 2>/dev/null || true
        cp -f "$SPRITES_DIR/edgar.png" "$WAYBAR_DIR/portraits/" 2>/dev/null || true
    fi
    
    # Create API server script for system information
    echo -e "${YELLOW}Creating system API server for character portraits...${NC}"
    cat > "$WAYBAR_DIR/modules/system-api-server.py" << 'EOF'
#!/usr/bin/env python3
import http.server
import socketserver
import json
import psutil
import os
import subprocess
import threading
import time

PORT = 9000

# Cache for system data
cache = {
    'cpu': {'usage': 0},
    'memory': {'used': 0, 'total': 0},
    'disk': {'used': 0, 'total': 0},
    'network': {'activity': 0},
    'temperature': {'temperature': 0},
    'workspace': {'active': 1},
    'battery': {'percentage': 100}
}

# Update system data in background
def update_system_data():
    while True:
        try:
            # CPU usage
            cache['cpu']['usage'] = psutil.cpu_percent()
            
            # Memory usage
            mem = psutil.virtual_memory()
            cache['memory']['used'] = mem.used / (1024 * 1024 * 1024)  # GB
            cache['memory']['total'] = mem.total / (1024 * 1024 * 1024)  # GB
            
            # Disk usage
            disk = psutil.disk_usage('/')
            cache['disk']['used'] = disk.used / (1024 * 1024 * 1024)  # GB
            cache['disk']['total'] = disk.total / (1024 * 1024 * 1024)  # GB
            
            # Network activity (simplified)
            net_io = psutil.net_io_counters()
            cache['network']['activity'] = (net_io.bytes_sent + net_io.bytes_recv) / (1024 * 1024)  # MB
            
            # Temperature (simplified)
            if hasattr(psutil, "sensors_temperatures"):
                temps = psutil.sensors_temperatures()
                if temps and 'coretemp' in temps:
                    cache['temperature']['temperature'] = temps['coretemp'][0].current
            
            # Active workspace (using hyprctl)
            try:
                result = subprocess.run(['hyprctl', 'activeworkspace', '-j'], 
                                       capture_output=True, text=True, check=True)
                workspace_data = json.loads(result.stdout)
                cache['workspace']['active'] = workspace_data.get('id', 1)
            except:
                cache['workspace']['active'] = 1
            
            # Battery percentage
            if hasattr(psutil, "sensors_battery"):
                battery = psutil.sensors_battery()
                if battery:
                    cache['battery']['percentage'] = battery.percent
        except Exception as e:
            print(f"Error updating system data: {e}")
        
        time.sleep(2)  # Update every 2 seconds

# Start background thread for updating system data
update_thread = threading.Thread(target=update_system_data, daemon=True)
update_thread.start()

class SystemAPIHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        
        path = self.path.strip('/')
        
        if path in cache:
            self.wfile.write(json.dumps(cache[path]).encode())
        else:
            self.wfile.write(json.dumps({'error': 'Not found'}).encode())
    
    def log_message(self, format, *args):
        # Suppress log messages
        return

def run_server():
    with socketserver.TCPServer(("localhost", PORT), SystemAPIHandler) as httpd:
        print(f"Serving at port {PORT}")
        httpd.serve_forever()

if __name__ == "__main__":
    run_server()
EOF
    
    # Make the API server executable
    chmod +x "$WAYBAR_DIR/modules/system-api-server.py"
    
    # Create launch script for waybar
    echo -e "${YELLOW}Creating waybar launch script...${NC}"
    cat > "$HYPR_DIR/scripts/launch-waybar.sh" << 'EOF'
#!/bin/bash
# Script to launch waybar with FF6 theme

# Kill any existing waybar instances
killall waybar

# Wait a moment
sleep 0.5

# Start the system API server if it's not already running
if ! pgrep -f "system-api-server.py" > /dev/null; then
    ~/.config/waybar/modules/system-api-server.py &
fi

# Launch waybar with the FF6 configuration
waybar -c ~/.config/waybar/config.jsonc &

# Play menu open sound if available
if [ -f ~/.config/hypr/sounds/menu_open.wav ] && command -v paplay >/dev/null 2>&1; then
    paplay ~/.config/hypr/sounds/menu_open.wav &
fi

exit 0
EOF
    
    # Make the launch script executable
    chmod +x "$HYPR_DIR/scripts/launch-waybar.sh"
    
    # Create HTML files for character portraits
    echo -e "${YELLOW}Creating HTML files for character portraits...${NC}"
    
    # Terra portrait
    cat > "$WAYBAR_DIR/modules/terra-portrait.html" << 'EOF'
<div class="character-portrait">
  <img src="~/.config/waybar/portraits/terra.png" alt="Terra" width="48" height="48"/>
  <div class="character-info">
    <div class="name">Terra</div>
    <div class="stats">
      <div class="stat"><span class="label">LV</span> <span class="value" id="cpu-level">0</span></div>
      <div class="stat"><span class="label">HP</span> <span class="value" id="memory-used">0</span>/<span id="memory-total">0</span></div>
      <div class="stat"><span class="label">MP</span> <span class="value" id="disk-used">0</span>/<span id="disk-total">0</span></div>
    </div>
  </div>
</div>
<script>
  // Update CPU level (1-99 based on CPU usage)
  function updateCpuLevel() {
    fetch('http://localhost:9000/cpu')
      .then(response => response.json())
      .then(data => {
        const level = Math.max(1, Math.min(99, Math.floor(data.usage)));
        document.getElementById('cpu-level').textContent = level;
      })
      .catch(error => console.error('Error fetching CPU data:', error));
  }
  
  // Update memory stats
  function updateMemory() {
    fetch('http://localhost:9000/memory')
      .then(response => response.json())
      .then(data => {
        document.getElementById('memory-used').textContent = Math.floor(data.used);
        document.getElementById('memory-total').textContent = Math.floor(data.total);
      })
      .catch(error => console.error('Error fetching memory data:', error));
  }
  
  // Update disk stats
  function updateDisk() {
    fetch('http://localhost:9000/disk')
      .then(response => response.json())
      .then(data => {
        document.getElementById('disk-used').textContent = Math.floor(data.used);
        document.getElementById('disk-total').textContent = Math.floor(data.total);
      })
      .catch(error => console.error('Error fetching disk data:', error));
  }
  
  // Update all stats every 5 seconds
  setInterval(() => {
    updateCpuLevel();
    updateMemory();
    updateDisk();
  }, 5000);
  
  // Initial update
  updateCpuLevel();
  updateMemory();
  updateDisk();
</script>
EOF
    
    # Gannon portrait
    cat > "$WAYBAR_DIR/modules/gannon-portrait.html" << 'EOF'
<div class="character-portrait">
  <img src="~/.config/waybar/portraits/gannon.png" alt="Gannon" width="48" height="48"/>
  <div class="character-info">
    <div class="name">Gannon</div>
    <div class="stats">
      <div class="stat"><span class="label">LV</span> <span class="value" id="network-level">0</span></div>
      <div class="stat"><span class="label">HP</span> <span class="value" id="temperature">0</span>/<span id="temperature-max">100</span></div>
    </div>
  </div>
</div>
<script>
  // Update network level (1-99 based on network activity)
  function updateNetworkLevel() {
    fetch('http://localhost:9000/network')
      .then(response => response.json())
      .then(data => {
        // Calculate level based on network activity (simplified)
        const level = Math.max(1, Math.min(99, Math.floor(data.activity * 100)));
        document.getElementById('network-level').textContent = level;
      })
      .catch(error => console.error('Error fetching network data:', error));
  }
  
  // Update temperature
  function updateTemperature() {
    fetch('http://localhost:9000/temperature')
      .then(response => response.json())
      .then(data => {
        document.getElementById('temperature').textContent = Math.floor(data.temperature);
      })
      .catch(error => console.error('Error fetching temperature data:', error));
  }
  
  // Update all stats every 5 seconds
  setInterval(() => {
    updateNetworkLevel();
    updateTemperature();
  }, 5000);
  
  // Initial update
  updateNetworkLevel();
  updateTemperature();
</script>
EOF
    
    # Edgar portrait
    cat > "$WAYBAR_DIR/modules/edgar-portrait.html" << 'EOF'
<div class="character-portrait">
  <img src="~/.config/waybar/portraits/edgar.png" alt="Edgar" width="48" height="48"/>
  <div class="character-info">
    <div class="name">Edgar</div>
    <div class="stats">
      <div class="stat"><span class="label">LV</span> <span class="value" id="workspace-level">0</span></div>
      <div class="stat"><span class="label">HP</span> <span class="value" id="battery-level">0</span>/<span id="battery-max">100</span></div>
    </div>
  </div>
</div>
<script>
  // Update workspace level (based on active workspace)
  function updateWorkspaceLevel() {
    fetch('http://localhost:9000/workspace')
      .then(response => response.json())
      .then(data => {
        document.getElementById('workspace-level').textContent = data.active;
      })
      .catch(error => console.error('Error fetching workspace data:', error));
  }
  
  // Update battery level
  function updateBatteryLevel() {
    fetch('http://localhost:9000/battery')
      .then(response => response.json())
      .then(data => {
        document.getElementById('battery-level').textContent = Math.floor(data.percentage);
      })
      .catch(error => console.error('Error fetching battery data:', error));
  }
  
  // Update all stats every 5 seconds
  setInterval(() => {
    updateWorkspaceLevel();
    updateBatteryLevel();
  }, 5000);
  
  // Initial update
  updateWorkspaceLevel();
  updateBatteryLevel();
</script>
EOF
    
    # Update hyprland.conf to use the new waybar launch script
    if [ -f "$HYPR_DIR/hyprland.conf" ]; then
        echo -e "${YELLOW}Updating hyprland.conf to use the FF6-themed waybar...${NC}"
        
        # Check if exec-once for waybar already exists
        if grep -q "exec-once = waybar" "$HYPR_DIR/hyprland.conf"; then
            # Replace existing waybar exec line
            sed -i 's|exec-once = waybar.*|exec-once = ~/.config/hypr/scripts/launch-waybar.sh|g' "$HYPR_DIR/hyprland.conf"
        else
            # Add waybar launch to exec-once section
            if grep -q "# Autostart" "$HYPR_DIR/hyprland.conf"; then
                # Add after Autostart comment
                sed -i '/# Autostart/a exec-once = ~/.config/hypr/scripts/launch-waybar.sh' "$HYPR_DIR/hyprland.conf"
            else
                # Add to end of file
                echo "exec-once = ~/.config/hypr/scripts/launch-waybar.sh" >> "$HYPR_DIR/hyprland.conf"
            fi
        fi
    fi
    
    echo -e "${GREEN}FF6-themed waybar configuration installed successfully!${NC}"
}

# Detect distribution
detect_distro

# Check if yay is installed, install if not (Arch Linux only)
if [[ "$DISTRO" == "arch" || "$DISTRO" == "manjaro" || "$DISTRO" == "endeavouros" || "$DISTRO" == "garuda" ]] && ! command_exists yay; then
    echo -e "${YELLOW}Yay (AUR helper) not found. Installing...${NC}"
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd - > /dev/null
    echo -e "${GREEN}Yay installed.${NC}"
fi

# Ask for confirmation before proceeding
echo -e "${YELLOW}This script will install the FF6-themed Hyprland configuration.${NC}"
echo -e "${YELLOW}It will backup your existing configurations to $BACKUP_DIR${NC}"
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Installation aborted.${NC}"
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Check for audio conflicts
check_audio_conflicts

# Install required packages
echo -e "${BLUE}Installing required packages...${NC}"
PACKAGES=(
    # Core Hyprland packages
    "hyprland"
    "waybar"
    "rofi-wayland"
    "kitty"
    "kvantum"
    "cava"
    "grim"
    "slurp"
    "swappy"
    "swww"
    "cliphist"
    "swaync"
    "swaybg"
    "wallust"
    "nwg-look"
    
    # Lock screen and idle management
    "hyprlock"
    "hypridle"
    
    # Desktop portal
    "xdg-desktop-portal-hyprland"
    "xdg-utils"
    
    # AGS (Aylur's GTK Shell)
    "ags"
    "nodejs"
    "npm"
    
    # Themes and appearance
    "gtk3"
    "qt5ct"
    "qt6ct"
    "papirus-icon-theme"
    
    # Fonts
    "ttf-jetbrains-mono-nerd"
    "ttf-victor-mono"
    "ttf-fantasque-sans-mono"
    
    # System utilities
    "polkit-kde-agent"
    "thunar"
    "python"
    "python-pip"
    "python-pillow"
    "btop"
    "pavucontrol"
    "networkmanager"
    "blueman"
    
    # Media and graphics
    "imagemagick"
    "wl-clipboard"
    "sox"
    
    # Hardware control
    "brightnessctl"
    "pamixer"
    
    # Miscellaneous utilities
    "jq"
    "yad"
    "zenity"
    "xcursor-themes"
    "xorg-xcursorgen"
)

# Install packages with error handling
INSTALL_ERRORS=0
for pkg in "${PACKAGES[@]}"; do
    if ! install_package "$pkg"; then
        INSTALL_ERRORS=$((INSTALL_ERRORS+1))
    fi
done

if [ $INSTALL_ERRORS -gt 0 ]; then
    echo -e "${YELLOW}Warning: $INSTALL_ERRORS packages could not be installed.${NC}"
    echo -e "${YELLOW}Some features may not work correctly.${NC}"
    read -p "Do you want to continue with the installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation aborted.${NC}"
        exit 1
    fi
fi

# Install Python packages
install_python_packages

# Install fonts if not already installed
echo -e "${BLUE}Checking fonts...${NC}"
create_dir "$FONTS_DIR"

# Check for required fonts and install if missing
FONT_PACKAGES=(
    "ttf-jetbrains-mono-nerd"
    "ttf-victor-mono"
    "ttf-fantasque-sans-mono"
)

for font_pkg in "${FONT_PACKAGES[@]}"; do
    install_package "$font_pkg"
done

# Update font cache
if command_exists fc-cache; then
    echo -e "${YELLOW}Updating font cache...${NC}"
    fc-cache -f
    echo -e "${GREEN}Font cache updated.${NC}"
fi

# Backup existing configurations
echo -e "${BLUE}Backing up existing configurations...${NC}"
backup_config "$HYPR_DIR"
backup_config "$WAYBAR_DIR"
backup_config "$ROFI_DIR"
backup_config "$KITTY_DIR"
backup_config "$SWAPPY_DIR"
backup_config "$SWAYNC_DIR"
backup_config "$KVANTUM_DIR"
backup_config "$GTK_DIR"
backup_config "$QT5CT_DIR"
backup_config "$QT6CT_DIR"
backup_config "$THUNAR_DIR"
backup_config "$AGS_DIR"
backup_config "$XDG_DIR"

# Create necessary directories
echo -e "${BLUE}Creating configuration directories...${NC}"
create_dir "$HYPR_DIR"
create_dir "$WAYBAR_DIR"
create_dir "$WAYBAR_DIR/modules"
create_dir "$ROFI_DIR"
create_dir "$KITTY_DIR"
create_dir "$SWAPPY_DIR"
create_dir "$SWAYNC_DIR"
create_dir "$KVANTUM_DIR"
create_dir "$GTK_DIR"
create_dir "$QT5CT_DIR"
create_dir "$QT6CT_DIR"
create_dir "$THUNAR_DIR"
create_dir "$AGS_DIR"
create_dir "$AGS_DIR/modules"
create_dir "$AGS_DIR/user"
create_dir "$XDG_DIR"
create_dir "$HYPR_DIR/themes"
create_dir "$HYPR_DIR/wallpapers"
create_dir "$HYPR_DIR/scripts"
create_dir "$HYPR_DIR/sounds"
create_dir "$SPRITES_DIR"

# Install FF6 sound effects
install_sound_effects

# Install FF6 sprites
install_ff6_sprites

# Install FF6 cursor theme
install_ff6_cursor

# Copy configuration files
echo -e "${BLUE}Copying configuration files...${NC}"

# Copy Hyprland configuration files
echo -e "${YELLOW}Copying Hyprland configuration files...${NC}"
cp -r hypr/* "$HYPR_DIR/"

# Install FF6-themed waybar configuration
install_ff6_waybar

# Copy Kitty configuration files
echo -e "${YELLOW}Copying Kitty configuration files...${NC}"
cp -r kitty/* "$KITTY_DIR/"

# Copy AGS configuration files
echo -e "${YELLOW}Copying AGS configuration files...${NC}"
cp -r ags/* "$AGS_DIR/"

# Copy XDG portal configuration files
echo -e "${YELLOW}Copying XDG portal configuration files...${NC}"
cp -r xdg/* "$XDG_DIR/"

# Make scripts executable
echo -e "${BLUE}Making scripts executable...${NC}"
find "$HYPR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$WAYBAR_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
find "$KITTY_DIR" -type f -name "*.py" -exec chmod +x {} \;
find "$AGS_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;

# Set up autostart for Hyprland
echo -e "${BLUE}Setting up autostart for Hyprland...${NC}"
create_dir "$HOME/.config/autostart"

# Create desktop entry for Hyprland
cat > "$HOME/.config/autostart/hyprland.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Hyprland
Exec=Hyprland
Terminal=false
Categories=System;
EOF

# Set up environment variables
echo -e "${BLUE}Setting up environment variables...${NC}"
ENV_FILE="$HOME/.profile"

# Check if .profile exists, create if not
if [ ! -f "$ENV_FILE" ]; then
    touch "$ENV_FILE"
fi

# Add environment variables if not already present
if ! grep -q "HYPRLAND_FF6_THEME" "$ENV_FILE"; then
    echo -e "${YELLOW}Adding environment variables to $ENV_FILE...${NC}"
    cat >> "$ENV_FILE" << EOF

# Hyprland FF6 Theme environment variables
export HYPRLAND_FF6_THEME=1
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland,x11
export MOZ_ENABLE_WAYLAND=1
export XCURSOR_THEME=AtmaWeapon
export XCURSOR_SIZE=24
EOF
    echo -e "${GREEN}Environment variables added.${NC}"
fi

# Final setup and verification
echo -e "${BLUE}Performing final setup and verification...${NC}"

# Verify all required files are present
echo -e "${YELLOW}Verifying installation...${NC}"
MISSING_FILES=0

# Check critical files
CRITICAL_FILES=(
    "$HYPR_DIR/hyprland.conf"
    "$HYPR_DIR/colors.conf"
    "$HYPR_DIR/animations.conf"
    "$WAYBAR_DIR/config.jsonc"
    "$WAYBAR_DIR/style.css"
    "$WAYBAR_DIR/modules/ff6-character-stats.jsonc"
    "$WAYBAR_DIR/modules/ff6-menu-options.jsonc"
    "$WAYBAR_DIR/modules/ff6-menu-drawer.jsonc"
    "$KITTY_DIR/kitty.conf"
    "$KITTY_DIR/ff_sprite.py"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: Critical file $file is missing!${NC}"
        MISSING_FILES=$((MISSING_FILES+1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo -e "${RED}Error: $MISSING_FILES critical files are missing. Installation may be incomplete.${NC}"
    echo -e "${YELLOW}Please check the installation logs and try again.${NC}"
else
    echo -e "${GREEN}All critical files are present.${NC}"
fi

# Final message
echo -e "${BLUE}=========================================${NC}"
if [ $MISSING_FILES -eq 0 ] && [ $INSTALL_ERRORS -eq 0 ]; then
    echo -e "${GREEN}FF6-themed Hyprland configuration installed successfully!${NC}"
    echo -e "${GREEN}You can now start Hyprland by typing 'Hyprland' in a TTY session.${NC}"
    echo -e "${GREEN}Or log out and select Hyprland from your display manager.${NC}"
elif [ $MISSING_FILES -eq 0 ] && [ $INSTALL_ERRORS -gt 0 ]; then
    echo -e "${YELLOW}FF6-themed Hyprland configuration installed with warnings.${NC}"
    echo -e "${YELLOW}Some packages could not be installed. Some features may not work correctly.${NC}"
    echo -e "${YELLOW}You can try installing the missing packages manually.${NC}"
else
    echo -e "${RED}FF6-themed Hyprland configuration installation incomplete.${NC}"
    echo -e "${RED}Please check the installation logs and try again.${NC}"
fi
echo -e "${BLUE}=========================================${NC}"

# Play confirmation sound if available
if [ -f "$SOUNDS_DIR/confirm.wav" ] && command_exists paplay; then
    paplay "$SOUNDS_DIR/confirm.wav"
fi

exit 0
