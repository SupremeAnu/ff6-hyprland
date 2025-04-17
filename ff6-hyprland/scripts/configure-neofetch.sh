#!/bin/bash
# Script to install neofetch and configure it for FF6 character display
# This is optional but enhances the terminal experience

# Check if neofetch is already installed
if ! command -v neofetch &> /dev/null; then
    echo "Installing neofetch..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm neofetch
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y neofetch
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y neofetch
    else
        echo "Could not determine package manager. Please install neofetch manually."
        exit 1
    fi
else
    echo "Neofetch is already installed."
fi

# Create neofetch config directory if it doesn't exist
mkdir -p ~/.config/neofetch

# Create a custom neofetch config that works well with our FF6 theme
cat > ~/.config/neofetch/config.conf << 'EOF'
# Neofetch config file - FF6 Theme
# Modified for FF6-Hyprland configuration

print_info() {
    info title
    info underline

    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Resolution" resolution
    info "DE" de
    info "WM" wm
    info "WM Theme" wm_theme
    info "Theme" theme
    info "Icons" icons
    info "Terminal" term
    info "Terminal Font" term_font
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory

    info cols
}

# Use small FF6 character art instead of distro logo
# This is compatible with our FF6 theme
ascii_distro="auto"
ascii_colors=(4 1 8 6 8 7)
ascii_bold="on"

# Image backend - use kitty for best results with our theme
image_backend="kitty"
image_source="auto"

# Config for the FF6 color scheme
colors=(4 7 4 4 7 7)
bold="on"
underline_enabled="on"
underline_char="-"
separator=" >"

# Make the output more compact
block_range=(0 15)
color_blocks="on"
block_width=3
block_height=1

# Misc options
stdout="off"
EOF

echo "Neofetch configured with FF6 theme."
echo "You can run 'neofetch' to see system information with FF6 styling."
