#!/bin/bash
# Power menu script for rofi
# Theme: Crimson Gradient
# Created: April 2025

# Options
shutdown="⏻ Shutdown"
reboot=" Reboot"
lock=" Lock"
suspend="󰤄 Suspend"
logout="󰗽 Logout"

# Get answer from user
chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$lock" "$suspend" "$logout" | rofi -dmenu -i -theme-str '@import "crimson-theme.rasi"' -p "Power Menu")

# Execute the chosen option
case "$chosen" in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$lock")
        hyprlock
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$logout")
        hyprctl dispatch exit
        ;;
esac
