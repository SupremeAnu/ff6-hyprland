# FF6 Hyprland Configuration - Project Resume

## Project Overview

This project involved creating a comprehensive Hyprland configuration themed after Final Fantasy VI, featuring the iconic blue menu gradients, character sprites, and sound effects from the game. The configuration includes custom waybar layouts, rofi themes, and various scripts to enhance the user experience.

![FF6 Theme Preview](samples/theme_preview.html)

## Key Features Implemented

### Visual Elements
- **FF6 Menu Style Theme**: Blue gradient backgrounds with white borders across all UI elements
- **Full-Color Character Sprites**: Vibrant, authentic FF1-6 character sprites in the terminal
- **Atma Weapon Cursor**: Custom cursor inspired by the legendary FF6 weapon
- **Responsive Design**: Automatic scaling between 1080p, 1440p, and 4K resolutions

### Audio Elements
- **FF6 Sound Effects**: Authentic game-inspired sounds for cursor movement, confirmation, and menus
- **Audio Integration**: Sounds triggered by system events and user interactions

### Functionality
- **Split Waybar Configuration**: Top and bottom bars with FF6-themed elements and terminology
- **Collapsible Menu**: Functional menu system in the top-left of waybar
- **Keybindings Help**: Overlay showing all available keyboard shortcuts
- **Window Switching**: Improved Alt+Tab functionality for easy navigation

## Technical Improvements

### Installation Process
- **Flexible Configuration Source**: Installer can use files from repository or archive
- **Cross-Distribution Support**: Works on Arch, Debian, and Fedora-based systems
- **Improved Package Checking**: Prevents conflicts with pre-installed software
- **Comprehensive Error Handling**: Graceful recovery from installation issues

### Configuration Files
- **Updated Hyprland Syntax**: Fixed decoration and shadow configuration for latest Hyprland version
- **Resolution Detection**: Script to automatically configure UI elements based on screen resolution
- **Cursor Generation**: Comprehensive cursor theme creation with all necessary cursor types
- **Sound Configuration**: Proper audio setup with fallback options

## Project Challenges

1. **Hyprland Configuration Errors**: Updated to latest syntax for decoration and shadow settings
2. **Resolution Detection**: Implemented dynamic configuration based on screen resolution
3. **Audio Configuration**: Created and integrated FF6-style sound effects
4. **Cursor Functionality**: Developed comprehensive cursor theme with proper symlinks
5. **Package Management**: Improved installation process to prevent conflicts

## Future Enhancements

- Additional FF6 character sprites and animations
- More extensive sound effect integration
- Dynamic theme switching based on time of day
- Additional FF6-themed wallpapers and visual elements

## Technical Stack

- **Window Manager**: Hyprland
- **Status Bar**: Waybar
- **Terminal**: Kitty
- **Application Launcher**: Rofi
- **Notification System**: SwayNC
- **Image Handling**: ImageMagick, SWWW
- **Audio**: PulseAudio, SoX
- **Scripting**: Bash, Python

## Installation

The configuration can be installed using the provided installer script:

```bash
# Clone the repository
git clone https://github.com/yourusername/ff6-hyprland-config.git

# Navigate to the directory
cd ff6-hyprland-config

# Run the installer
./install.sh
```

For detailed usage instructions, please refer to the README.md file.
