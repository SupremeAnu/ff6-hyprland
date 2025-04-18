# FF6-Themed Waybar Configuration

This package contains a complete waybar configuration themed after the Final Fantasy VI menu system.

## Features

- Multiple waybar bars styled after the FF6 menu
- Character portraits with system information (Terra, Gannon, Edgar)
- FF6-style menu options (Items, Abilities, Equip, etc.)
- Collapsible menu drawer with Steam shortcut
- Blue gradient background with white borders matching FF6 aesthetic
- System information displayed as character stats

## Installation

1. Run the installation script:
   ```
   ./install-ff6-waybar.sh
   ```

2. Restart waybar:
   ```
   ~/.config/waybar/restart-waybar.sh
   ```

## Configuration

The configuration consists of:

- `config.jsonc` - Main waybar configuration
- `style.css` - FF6-themed styling
- `modules/` - Module definitions for character stats and menu options
- `scripts/` - Helper scripts for character portraits and testing
- `sprites/` - Character sprite images

## Customization

You can customize the configuration by editing:

- `config.jsonc` to change the layout and modules
- `style.css` to adjust colors and styling
- Module files to change functionality

## Credits

- Original FF6 sprites and design by Square Enix
- Waybar configuration based on JaKooLit's Arch-Hyprland repository
