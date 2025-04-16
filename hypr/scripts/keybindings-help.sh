#!/bin/bash

# FF6 Hyprland Keybindings Help Overlay
# This script displays a help overlay with all available keybindings

# Use rofi to create a semi-transparent overlay
rofi -theme-str 'window {transparency: "real"; background-color: rgba(10, 16, 96, 0.5); width: 70%; height: 80%; border: 2px solid white; border-radius: 10px;}' \
     -theme-str 'mainbox {background-color: transparent;}' \
     -theme-str 'textbox {background-color: transparent; text-color: white; font: "JetBrains Mono Nerd Font 12";}' \
     -dmenu \
     -p "FF6 Hyprland Keybindings" \
     -mesg "
<span size='x-large' weight='bold'>FF6 Hyprland Keybindings</span>

<span weight='bold'>== General ==</span>
<span weight='bold'>Super + Enter</span>       Terminal (Magic)
<span weight='bold'>Super + E</span>           File Manager (Items)
<span weight='bold'>Super + D</span>           Application Launcher (Relics)
<span weight='bold'>Super + H</span>           This Help Menu
<span weight='bold'>Super + Q</span>           Close Active Window
<span weight='bold'>Super + F</span>           Toggle Fullscreen
<span weight='bold'>Super + Space</span>       Toggle Floating Window
<span weight='bold'>Super + P</span>           Power Menu (Save)

<span weight='bold'>== Workspaces ==</span>
<span weight='bold'>Super + 1-9</span>         Switch to Workspace 1-9
<span weight='bold'>Super + Shift + 1-9</span> Move Window to Workspace 1-9
<span weight='bold'>Super + Tab</span>         Cycle Through Workspaces
<span weight='bold'>Super + Shift + Tab</span> Cycle Through Workspaces (Reverse)

<span weight='bold'>== Window Management ==</span>
<span weight='bold'>Super + Left/Right/Up/Down</span>       Focus Window in Direction
<span weight='bold'>Super + Shift + Left/Right/Up/Down</span> Move Window in Direction
<span weight='bold'>Super + Ctrl + Left/Right/Up/Down</span> Resize Window
<span weight='bold'>Super + Mouse Drag</span>  Move Floating Window
<span weight='bold'>Super + Scroll</span>      Cycle Through Windows

<span weight='bold'>== Screenshots ==</span>
<span weight='bold'>Print</span>               Screenshot Full Screen
<span weight='bold'>Super + Print</span>       Screenshot Selected Area
<span weight='bold'>Alt + Print</span>         Screenshot Current Window
<span weight='bold'>Ctrl + Print</span>        Screenshot to Clipboard

<span weight='bold'>== Clipboard ==</span>
<span weight='bold'>Super + V</span>           Show Clipboard History
<span weight='bold'>Super + C</span>           Copy to Clipboard
<span weight='bold'>Super + X</span>           Cut to Clipboard

<span weight='bold'>== Media Controls ==</span>
<span weight='bold'>Volume Up/Down</span>      Adjust Volume
<span weight='bold'>Mute</span>                Toggle Mute
<span weight='bold'>Play/Pause</span>          Media Play/Pause
<span weight='bold'>Next/Prev</span>           Next/Previous Track

<span weight='bold'>== FF6 Theme Controls ==</span>
<span weight='bold'>Super + Shift + W</span>   Change Wallpaper
<span weight='bold'>Super + Shift + T</span>   Toggle Light/Dark Theme
<span weight='bold'>Super + Shift + S</span>   Toggle Sound Effects

<span weight='bold'>Press Esc to close this window</span>
" \
     -theme ff6-theme
