#!/bin/bash

# Script to ensure FF6 character sprites display properly in kitty terminal
# This script sets up the necessary files and permissions for the kitty terminal

# Set colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up FF6 character sprites for kitty terminal...${NC}"

# Create necessary directories
mkdir -p ~/.config/kitty/sprites
echo -e "${GREEN}Created sprites directory${NC}"

# Copy sprite script and make it executable
cp -f /home/ubuntu/hyprland-crimson-config/kitty/ff_sprite.py ~/.config/kitty/
chmod +x ~/.config/kitty/ff_sprite.py
echo -e "${GREEN}Installed FF6 sprite script${NC}"

# Copy character images to sprites directory
if [ -d "/home/ubuntu/upload" ]; then
    cp -f /home/ubuntu/upload/*.png ~/.config/kitty/sprites/ 2>/dev/null
    echo -e "${GREEN}Copied character sprite images${NC}"
else
    echo -e "${RED}Character sprite images not found in /home/ubuntu/upload/${NC}"
    echo -e "${BLUE}Creating symbolic links to default locations...${NC}"
    
    # Create symbolic links to default locations if they exist
    for char in terra locke edgar celes setzer; do
        if [ -f "/home/ubuntu/hyprland-crimson-config/sprites/${char}.png" ]; then
            ln -sf "/home/ubuntu/hyprland-crimson-config/sprites/${char}.png" ~/.config/kitty/sprites/
        fi
    done
fi

# Update kitty.conf to use the FF6 theme
cat > ~/.config/kitty/kitty.conf << EOF
# Kitty Terminal Configuration
# Theme: Final Fantasy VI Menu Style

# Font configuration
font_family      JetBrains Mono Nerd Font
bold_font        JetBrains Mono Nerd Font Bold
italic_font      Victor Mono Italic
bold_italic_font Victor Mono Bold Italic
font_size        12.0

# Window configuration
window_padding_width 10
placement_strategy center
hide_window_decorations yes
background_opacity 0.9
dynamic_background_opacity yes
confirm_os_window_close 0

# Terminal bell
enable_audio_bell no
visual_bell_duration 0.1

# Cursor
cursor_shape beam
cursor_blink_interval 0.5

# Scrollback
scrollback_lines 10000

# Mouse
mouse_hide_wait 3.0
copy_on_select yes

# Performance
repaint_delay 10
input_delay 3
sync_to_monitor yes

# FF6 Menu Style Color scheme
foreground #ffffff
background #102080

# Black
color0 #000000
color8 #555555

# Blue (instead of Red for FF6 theme)
color1 #4080FF
color9 #6090FF

# Green
color2 #00aa00
color10 #00dd00

# Yellow
color3 #ffaa00
color11 #ffdd00

# Blue
color4 #2050C0
color12 #4080FF

# Magenta
color5 #aa00aa
color13 #ff00ff

# Cyan
color6 #00aaaa
color14 #00ffff

# White
color7 #aaaaaa
color15 #ffffff

# Cursor colors
cursor #4080FF
cursor_text_color #ffffff

# Selection colors
selection_foreground #102080
selection_background #ffffff

# URL underline color
url_color #4080FF

# Tab bar
tab_bar_edge bottom
tab_bar_style powerline
tab_powerline_style slanted
active_tab_foreground #ffffff
active_tab_background #4080FF
inactive_tab_foreground #aaaaaa
inactive_tab_background #2050C0

# Window borders
active_border_color #4080FF
inactive_border_color #2050C0

# Key mappings
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+s paste_from_selection
map ctrl+shift+equal change_font_size all +1.0
map ctrl+shift+minus change_font_size all -1.0
map ctrl+shift+0 change_font_size all 0

# Advanced
shell_integration enabled
term xterm-kitty
update_check_interval 0

# Run Final Fantasy sprite script on startup
startup_session none
shell_integration enabled

# Correct path to the FF6 sprite script
# This ensures the script runs when kitty starts
startup_command python3 ${HOME}/.config/kitty/ff_sprite.py
EOF

echo -e "${GREEN}Updated kitty configuration${NC}"

# Create a kitty startup script
cat > ~/.config/kitty/startup.sh << EOF
#!/bin/bash
# Kitty startup script for FF6 theme
python3 ~/.config/kitty/ff_sprite.py
EOF

chmod +x ~/.config/kitty/startup.sh
echo -e "${GREEN}Created kitty startup script${NC}"

# Create a zsh theme file if zsh is installed
if command -v zsh &> /dev/null; then
    mkdir -p ~/.oh-my-zsh/custom/themes
    cat > ~/.oh-my-zsh/custom/themes/ff6.zsh-theme << EOF
# FF6-themed ZSH prompt
# Based on the Final Fantasy VI menu system

# Colors
local blue="%{$fg[blue]%}"
local cyan="%{$fg[cyan]%}"
local green="%{$fg[green]%}"
local red="%{$fg[red]%}"
local yellow="%{$fg[yellow]%}"
local white="%{$fg[white]%}"
local reset="%{$reset_color%}"

# Git status
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${yellow}("
ZSH_THEME_GIT_PROMPT_SUFFIX="${yellow})${reset}"
ZSH_THEME_GIT_PROMPT_DIRTY="${red}*${reset}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Prompt components
local user_host="${cyan}%n${white}@${green}%m${reset}"
local current_dir="${blue}%~${reset}"
local return_code="%(?..${red}%? ↵${reset})"

# Main prompt
PROMPT="${white}╭─${reset}${user_host} ${current_dir} ${git_info}
${white}╰─${reset}${cyan}❯${reset} "
RPROMPT="${return_code}"

# Display FF6 character on terminal start
precmd() {
    if [ -f ~/.config/kitty/ff_sprite.py ]; then
        if [ -z "$FF6_SPRITE_SHOWN" ]; then
            python3 ~/.config/kitty/ff_sprite.py
            export FF6_SPRITE_SHOWN=1
        fi
    fi
}
EOF
    echo -e "${GREEN}Created FF6-themed ZSH prompt${NC}"
fi

echo -e "${BLUE}FF6 character sprites setup complete!${NC}"
echo -e "${BLUE}Restart your terminal or run 'kitty' to see the changes.${NC}"
