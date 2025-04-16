#!/usr/bin/env python3
# Final Fantasy Sprite Display Script for Kitty Terminal
# Theme: Final Fantasy VI Menu Style
# Created: April 2025

import random
import datetime
import os
import sys

# ANSI color codes
class Colors:
    RESET = "\033[0m"
    BLACK = "\033[30m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN = "\033[36m"
    WHITE = "\033[37m"
    BRIGHT_BLACK = "\033[90m"
    BRIGHT_RED = "\033[91m"
    BRIGHT_GREEN = "\033[92m"
    BRIGHT_YELLOW = "\033[93m"
    BRIGHT_BLUE = "\033[94m"
    BRIGHT_MAGENTA = "\033[95m"
    BRIGHT_CYAN = "\033[96m"
    BRIGHT_WHITE = "\033[97m"
    BOLD = "\033[1m"
    
    # FF6 specific colors
    FF6_BLUE_LIGHT = "\033[38;2;64;128;255m"
    FF6_BLUE_MID = "\033[38;2;32;80;192m"
    FF6_BLUE_DARK = "\033[38;2;16;32;128m"

# Final Fantasy VI character sprites (ASCII art)
ff6_sprites = {
    "Terra": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.GREEN}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.GREEN}█{Colors.BRIGHT_GREEN}▄▄▄▄{Colors.GREEN}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.GREEN}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.GREEN}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Locke": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_CYAN}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_CYAN}█{Colors.BRIGHT_BLACK}▄▄▄▄{Colors.BRIGHT_CYAN}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_CYAN}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_CYAN}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Edgar": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_BLUE}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_BLUE}█{Colors.YELLOW}▄▄▄▄{Colors.BRIGHT_BLUE}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_BLUE}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_BLUE}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Sabin": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.YELLOW}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.YELLOW}█{Colors.BRIGHT_YELLOW}▄▄▄▄{Colors.YELLOW}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.YELLOW}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.YELLOW}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Cyan": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_BLACK}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_BLACK}█{Colors.BRIGHT_WHITE}▄▄▄▄{Colors.BRIGHT_BLACK}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_BLACK}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_BLACK}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Shadow": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_BLACK}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_BLACK}█{Colors.BRIGHT_RED}▄▄▄▄{Colors.BRIGHT_BLACK}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_BLACK}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_BLACK}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Gau": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.YELLOW}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.YELLOW}█{Colors.BRIGHT_GREEN}▄▄▄▄{Colors.YELLOW}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.YELLOW}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.YELLOW}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Celes": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_YELLOW}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_YELLOW}█{Colors.BRIGHT_BLUE}▄▄▄▄{Colors.BRIGHT_YELLOW}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_YELLOW}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_YELLOW}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Setzer": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_WHITE}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_WHITE}█{Colors.BRIGHT_MAGENTA}▄▄▄▄{Colors.BRIGHT_WHITE}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_WHITE}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_WHITE}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Mog": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_WHITE}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_WHITE}█{Colors.BRIGHT_RED}▄▄▄▄{Colors.BRIGHT_WHITE}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_WHITE}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_WHITE}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Kefka": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.BRIGHT_WHITE}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_WHITE}█{Colors.BRIGHT_RED}▄▄▄▄{Colors.BRIGHT_WHITE}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.BRIGHT_YELLOW}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.BRIGHT_MAGENTA}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ],
    "Ultros": [
        f"{Colors.FF6_BLUE_LIGHT}    ▄▄▄▄    {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   █{Colors.MAGENTA}▀▀▀▀{Colors.FF6_BLUE_LIGHT}█   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.MAGENTA}█{Colors.BRIGHT_WHITE}▄▄▄▄{Colors.MAGENTA}█{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}  █{Colors.MAGENTA}█████{Colors.FF6_BLUE_LIGHT}█  {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}   ▀{Colors.MAGENTA}███{Colors.FF6_BLUE_LIGHT}▀   {Colors.RESET}",
        f"{Colors.FF6_BLUE_LIGHT}    █ █    {Colors.RESET}"
    ]
}

def display_sprite_and_time():
    # Get current date and time in US format (24-hour)
    now = datetime.datetime.now()
    date_time = now.strftime("%m/%d/%Y %H:%M:%S")
    
    # Select a random character
    character_name = random.choice(list(ff6_sprites.keys()))
    sprite = ff6_sprites[character_name]
    
    # Create FF6-style menu box
    box_width = 40
    
    # Top border
    top_border = f"{Colors.FF6_BLUE_LIGHT}╔{'═' * (box_width - 2)}╗{Colors.RESET}"
    
    # Bottom border
    bottom_border = f"{Colors.FF6_BLUE_LIGHT}╚{'═' * (box_width - 2)}╝{Colors.RESET}"
    
    # Print the FF6-style menu box
    print("\n" + top_border)
    
    # Print the sprite with side borders
    for line in sprite:
        padding = " " * ((box_width - 2 - len(line.strip())) // 2)
        print(f"{Colors.FF6_BLUE_LIGHT}║{Colors.RESET}{padding}{line}{padding}{Colors.FF6_BLUE_LIGHT}║{Colors.RESET}")
    
    # Print character name with side borders
    name_padding = " " * ((box_width - 2 - len(character_name)) // 2)
    print(f"{Colors.FF6_BLUE_LIGHT}║{Colors.RESET}{name_padding}{Colors.BRIGHT_WHITE}{Colors.BOLD}{character_name}{Colors.RESET}{name_padding}{Colors.FF6_BLUE_LIGHT}║{Colors.RESET}")
    
    # Print date/time with side borders
    time_padding = " " * ((box_width - 2 - len(date_time)) // 2)
    print(f"{Colors.FF6_BLUE_LIGHT}║{Colors.RESET}{time_padding}{Colors.FF6_BLUE_LIGHT}{date_time}{Colors.RESET}{time_padding}{Colors.FF6_BLUE_LIGHT}║{Colors.RESET}")
    
    # Print bottom border
    print(bottom_border + "\n")

if __name__ == "__main__":
    display_sprite_and_time()
