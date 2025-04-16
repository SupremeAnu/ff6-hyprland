# Final Fantasy VI Themed Hyprland Configuration

A comprehensive Hyprland configuration with a Final Fantasy VI menu-inspired theme featuring red and black gradients, vibrant full-color FF6 character sprites, and the Atma Weapon cursor.

![FF6 Theme Preview](samples/theme_preview.html)

## Features

- **FF6 Menu Style Theme**: Red and black gradient backgrounds with themed borders across all UI elements
- **Full-Color FF6 Character Sprites**: Authentic, vibrant character sprites from FF1-6 displayed in terminal
- **Atma Weapon Cursor**: Custom cursor from FF6
- **FF6 Sound Effects**: Original FF6 sound effects for notifications and system interactions
- **FF6 Terminology**: Waybar elements renamed to match FF6 game terms (Magic, Items, Relics, etc.)
- **Paired Function Icons**: Each icon handles two functions (left/right click)
- **Responsive Design**: Automatically adapts to different screen resolutions (1080p, 1440p, 4K)
- **Consistent Theming**: All applications follow the FF6 aesthetic

## Components

- **Hyprland**: Window manager with animations and keybindings
- **Waybar**: Top and bottom bars with FF6-themed elements
- **Rofi**: Application launcher with FF6 menu style
- **Kitty**: Terminal with full-color FF6 character sprites
- **SwayNC**: Notifications with FF6 styling and sound effects
- **GTK/Qt Theming**: Consistent FF6 theme across all applications

## Installation

### Automatic Installation

The easiest way to install is using the provided installer script:

```bash
# Make the installer executable
chmod +x install.sh

# Run the installer
./install.sh
```

The installer will:
1. Detect your distribution and install all required dependencies
2. Back up your existing configurations
3. Set up all the FF6-themed configuration files
4. Create the Atma Weapon cursor theme
5. Generate FF6 sound effects
6. Configure your display settings automatically
7. Test the configuration to ensure everything works properly

### Manual Installation

If you prefer to install manually:

1. Install required dependencies:
   ```bash
   # For Arch Linux
   yay -S hyprland waybar rofi-wayland kitty kvantum cava grim slurp swappy swww cliphist swaync swaybg wallust nwg-look gtk3 qt5ct qt6ct thunar hyprlock papirus-icon-theme ttf-jetbrains-mono-nerd ttf-victor-mono ttf-fantasque-sans-mono polkit-kde-agent python python-pip btop pavucontrol networkmanager blueman xdg-desktop-portal-hyprland xdg-utils imagemagick wl-clipboard sox jq yad zenity xcursor-themes xorg-xcursorgen
   
   # For Debian/Ubuntu
   sudo apt install hyprland waybar rofi kitty qt5-style-kvantum cava grim slurp swappy swww cliphist swaync swaybg wallust nwg-look libgtk-3-0 qt5ct qt6ct thunar hyprlock papirus-icon-theme fonts-jetbrains-mono fonts-victor-mono fonts-fantasque-sans polkit-kde-agent-1 python3 python3-pip btop pavucontrol network-manager blueman xdg-desktop-portal-hyprland xdg-utils imagemagick wl-clipboard sox jq yad zenity xcursor-themes x11-apps
   
   # For Fedora
   sudo dnf install hyprland waybar rofi kitty kvantum cava grim slurp swappy swww cliphist swaync swaybg wallust nwg-look gtk3 qt5ct qt6ct thunar hyprlock papirus-icon-theme jetbrains-mono-fonts-all victor-mono-fonts fantasque-sans-mono-fonts polkit-kde-authentication-agent-1 python3 python3-pip btop pavucontrol NetworkManager blueman xdg-desktop-portal-hyprland xdg-utils ImageMagick wl-clipboard sox jq yad zenity xcursor-themes xcursorgen
   ```

2. Copy the configuration files to your config directories:
   ```bash
   mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/.config/kitty ~/.config/swappy ~/.config/swaync ~/.config/Kvantum ~/.config/gtk-3.0 ~/.config/qt5ct ~/.config/qt6ct ~/.config/Thunar
   
   cp -r hypr/* ~/.config/hypr/
   cp -r waybar/* ~/.config/waybar/
   cp -r rofi/* ~/.config/rofi/
   cp -r kitty/* ~/.config/kitty/
   cp -r swappy/* ~/.config/swappy/
   cp -r swaync/* ~/.config/swaync/
   cp -r kvantum/* ~/.config/Kvantum/
   cp -r gtk-themes/* ~/.config/gtk-3.0/
   cp -r qt5ct/* ~/.config/qt5ct/
   cp -r qt6ct/* ~/.config/qt6ct/
   cp -r thunar/* ~/.config/Thunar/
   ```

3. Set up the Atma Weapon cursor:
   ```bash
   chmod +x scripts/create-atma-cursor.sh
   ./scripts/create-atma-cursor.sh
   ```

4. Generate FF6 sound effects:
   ```bash
   chmod +x scripts/generate-sounds.sh
   ./scripts/generate-sounds.sh
   ```

5. Configure your display settings:
   ```bash
   chmod +x scripts/configure-display.sh
   ./scripts/configure-display.sh
   ```

6. Validate your configuration:
   ```bash
   chmod +x scripts/validate-dotfiles.sh
   ./scripts/validate-dotfiles.sh
   ```

7. Log out and log back in to Hyprland to apply the configuration.

## Troubleshooting

If you encounter any issues with the configuration:

1. Run the validation script to check for missing files or configurations:
   ```bash
   ~/.config/hypr/scripts/validate-dotfiles.sh
   ```

2. Run the installer update script to fix common issues:
   ```bash
   ~/.config/hypr/scripts/update-installer.sh
   ```

3. Common issues and solutions:
   - **Waybar not appearing**: Make sure waybar is installed and the config files are in the correct location
   - **Hyprland configuration errors**: Run the update-installer.sh script to fix outdated syntax
   - **Cursor theme not working**: Run the create-atma-cursor.sh script again
   - **Sound effects not working**: Run the generate-sounds.sh and configure-sounds.sh scripts

## Keybindings

Press **Super + H** to display a help overlay with all keybindings.

Common keybindings:
- **Super + Enter**: Open terminal (Magic)
- **Super + E**: Open file manager (Items)
- **Super + D**: Open application launcher (Rofi)
- **Super + Q**: Close active window
- **Super + NUM**: Switch to workspace
- **Super + Shift + NUM**: Move window to workspace
- **Alt + Tab**: Switch between windows
- **Super + Print**: Take screenshot menu

## Waybar Shortcuts

### Top Bar
- **FF6 Logo**: Left click for app menu, right click for window overview
- **Magic/Items**: Left click for terminal, right click for file manager
- **Relics/Config**: Left click for browser, right click for theme settings
- **Espers/Wallpaper**: Left click for wallpaper menu, right click for random wallpaper
- **Save/Lock**: Left click for power menu, right click to lock screen

### Bottom Bar
- **Character Names**: Workspaces named after FF6 characters
- **Chocobo/Magitek**: Network connections
- **Updates**: System update button

## Customization

### Changing Wallpapers
Use the Espers menu in the top bar or run:
```bash
~/.config/hypr/scripts/wallpaper-menu.sh
```

### Switching Between Light/Dark Theme
Click the Config icon in the top bar or run:
```bash
~/.config/hypr/scripts/theme-toggle.sh
```

### Adjusting Display Settings
If you change your monitor setup, run:
```bash
~/.config/hypr/scripts/configure-display.sh
```

## Credits

- Final Fantasy VI is property of Square Enix
- Fonts: JetBrains Mono Nerd, Victor Mono, and Fantastique Sans Mono Nerd
- Some components adapted from JaKooLit's Hyprland-Dots (https://github.com/JaKooLit/Hyprland-Dots)
- Special thanks to the Hyprland community

## License

This configuration is provided under the MIT License. See the LICENSE file for details.
