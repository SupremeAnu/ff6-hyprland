#!/usr/bin/env python3
# FF6 Character Sprite Display for Kitty Terminal
# Displays a random FF6 character sprite with time information
# Created: April 2025

import random
import time
import os
import sys
from datetime import datetime

# ANSI color codes for vibrant FF6 character colors
# Using authentic character-specific colors
COLORS = {
    # Character-specific colors
    'TERRA': '\033[38;2;107;234;89m',   # Green hair/magic
    'LOCKE': '\033[38;2;173;216;230m',  # Blue bandana
    'EDGAR': '\033[38;2;218;165;32m',   # Royal gold
    'SABIN': '\033[38;2;255;140;0m',    # Monk orange
    'CYAN': '\033[38;2;0;191;255m',     # Samurai blue
    'SHADOW': '\033[38;2;128;0;128m',   # Ninja purple
    'GAU': '\033[38;2;139;69;19m',      # Wild child brown
    'CELES': '\033[38;2;255;255;224m',  # Ice white/yellow
    'SETZER': '\033[38;2;192;192;192m', # Silver gambler
    'MOG': '\033[38;2;255;182;193m',    # Pink moogle
    'KEFKA': '\033[38;2;255;0;0m',      # Villain red
    'ULTROS': '\033[38;2;128;0;128m',   # Purple octopus
    'UMARO': '\033[38;2;173;216;230m',  # Ice blue yeti
    'GOGO': '\033[38;2;255;215;0m',     # Golden mimic
    'RELM': '\033[38;2;255;105;180m',   # Artist pink
    'STRAGO': '\033[38;2;65;105;225m',  # Blue mage
    # General colors
    'RESET': '\033[0m',
    'BOLD': '\033[1m',
    'TIME': '\033[38;2;255;215;0m',     # Gold for time display
    'DATE': '\033[38;2;135;206;250m',   # Light blue for date
}

# Character sprites in full color ASCII art
SPRITES = {
    'TERRA': [
        f"{COLORS['TERRA']}   ▄▄▄▄▄   ",
        f"{COLORS['TERRA']}  ▄██████▄ ",
        f"{COLORS['TERRA']} ▄███{COLORS['RESET']}▄▄{COLORS['TERRA']}███▄",
        f"{COLORS['TERRA']} ███{COLORS['RESET']}▀▀▀▀{COLORS['TERRA']}███",
        f"{COLORS['TERRA']} ▀███████▀ ",
        f"{COLORS['TERRA']}  ▀▀███▀▀  ",
        f"{COLORS['TERRA']}    ▄█▄    ",
        f"{COLORS['TERRA']}   ▄███▄   ",
        f"{COLORS['TERRA']}  ▄█████▄  ",
    ],
    'LOCKE': [
        f"{COLORS['LOCKE']}   ▄▄▄▄▄   ",
        f"{COLORS['LOCKE']}  ▄██████▄ ",
        f"{COLORS['LOCKE']} ▄███████▄ ",
        f"{COLORS['LOCKE']} ███{COLORS['RESET']}▄▄▄▄{COLORS['LOCKE']}███",
        f"{COLORS['LOCKE']} ▀███████▀ ",
        f"{COLORS['LOCKE']}  ▀▀███▀▀  ",
        f"{COLORS['LOCKE']}    ▄█▄    ",
        f"{COLORS['LOCKE']}   ▄███▄   ",
        f"{COLORS['LOCKE']}  ▄█████▄  ",
    ],
    'KEFKA': [
        f"{COLORS['KEFKA']}   ▄▄▄▄▄   ",
        f"{COLORS['KEFKA']}  ▄██████▄ ",
        f"{COLORS['KEFKA']} ▄███████▄ ",
        f"{COLORS['KEFKA']} ███{COLORS['RESET']}▀▀▀▀{COLORS['KEFKA']}███",
        f"{COLORS['KEFKA']} ▀███████▀ ",
        f"{COLORS['KEFKA']}  ▀▀███▀▀  ",
        f"{COLORS['KEFKA']}    ▄█▄    ",
        f"{COLORS['KEFKA']}   ▄███▄   ",
        f"{COLORS['KEFKA']}  ▄█████▄  ",
        f"{COLORS['KEFKA']}  SON OF A SUBMARINER!",
    ],
    'ULTROS': [
        f"{COLORS['ULTROS']}    ▄▄▄    ",
        f"{COLORS['ULTROS']}   ▄███▄   ",
        f"{COLORS['ULTROS']}  ▄█████▄  ",
        f"{COLORS['ULTROS']} ▄███████▄ ",
        f"{COLORS['ULTROS']} ███████████▄",
        f"{COLORS['ULTROS']} ▀█████████▀",
        f"{COLORS['ULTROS']}  ▀▀▀▀▀▀▀▀▀ ",
        f"{COLORS['ULTROS']}  SEAFOOD SOUP!",
    ],
    'MOOGLE': [
        f"{COLORS['MOG']}    ▄▄▄▄    ",
        f"{COLORS['MOG']}   ▄████▄   ",
        f"{COLORS['MOG']}  ▄██{COLORS['RESET']}▀▀{COLORS['MOG']}██▄  ",
        f"{COLORS['MOG']} ▄███{COLORS['RESET']}██{COLORS['MOG']}███▄ ",
        f"{COLORS['MOG']} ███{COLORS['RESET']}▄██▄{COLORS['MOG']}███ ",
        f"{COLORS['MOG']} ▀█████████▀ ",
        f"{COLORS['MOG']}  ▀▀▀▀▀▀▀▀▀  ",
        f"{COLORS['MOG']}  KUPO KUPO!  ",
    ],
    'CELES': [
        f"{COLORS['CELES']}   ▄▄▄▄▄   ",
        f"{COLORS['CELES']}  ▄██████▄ ",
        f"{COLORS['CELES']} ▄███████▄ ",
        f"{COLORS['CELES']} ███{COLORS['RESET']}▄▄▄▄{COLORS['CELES']}███",
        f"{COLORS['CELES']} ▀███████▀ ",
        f"{COLORS['CELES']}  ▀▀███▀▀  ",
        f"{COLORS['CELES']}    ▄█▄    ",
        f"{COLORS['CELES']}   ▄███▄   ",
        f"{COLORS['CELES']}  ▄█████▄  ",
    ],
}

def get_random_sprite():
    """Return a random character sprite"""
    character = random.choice(list(SPRITES.keys()))
    return SPRITES[character]

def get_time_info():
    """Get current time and date information"""
    now = datetime.now()
    time_str = now.strftime("%H:%M:%S")
    date_str = now.strftime("%A, %B %d, %Y")
    return time_str, date_str

def display_sprite_with_time():
    """Display a random sprite with time information"""
    sprite = get_random_sprite()
    time_str, date_str = get_time_info()
    
    # Print some space before the sprite
    print("\n\n")
    
    # Print the sprite
    for line in sprite:
        print(line)
    
    # Print time and date
    print(f"\n{COLORS['TIME']}{COLORS['BOLD']}Time: {time_str}{COLORS['RESET']}")
    print(f"{COLORS['DATE']}Date: {date_str}{COLORS['RESET']}")
    
    # Print some space after
    print("\n")

if __name__ == "__main__":
    try:
        display_sprite_with_time()
    except Exception as e:
        print(f"Error displaying FF6 sprite: {e}")
