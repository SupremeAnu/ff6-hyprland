#!/usr/bin/env python3
# FF6 Character Sprite Display for Kitty Terminal
# Displays a random FF6 character sprite with time information
# Created: April 2025
# Enhanced with inspiration from Pokemon color scripts

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
    # Additional colors for details
    'SKIN': '\033[38;2;255;222;173m',   # Skin tone
    'HAIR_BROWN': '\033[38;2;139;69;19m', # Brown hair
    'HAIR_BLONDE': '\033[38;2;255;215;0m', # Blonde hair
    'ARMOR': '\033[38;2;169;169;169m',  # Silver armor
    'CLOTH': '\033[38;2;220;220;220m',  # White cloth
    'FIRE': '\033[38;2;255;69;0m',      # Fire magic
    'ICE': '\033[38;2;135;206;250m',    # Ice magic
    'LIGHTNING': '\033[38;2;255;255;0m', # Lightning magic
    'ESPER': '\033[38;2;138;43;226m',   # Esper/magic
}

# Enhanced character sprites with more detail and color
SPRITES = {
    'TERRA': [
        f"{COLORS['TERRA']}      ▄▄▄▄▄▄      ",
        f"{COLORS['TERRA']}    ▄████████▄    ",
        f"{COLORS['TERRA']}   ████{COLORS['ESPER']}▄▄▄▄{COLORS['TERRA']}████   ",
        f"{COLORS['TERRA']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['TERRA']}████  ",
        f"{COLORS['TERRA']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['TERRA']}███  ",
        f"{COLORS['TERRA']}  ▀█████████████▀  ",
        f"{COLORS['TERRA']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['TERRA']}      ▄▄███▄▄      ",
        f"{COLORS['TERRA']}     ▄███████▄     ",
        f"{COLORS['TERRA']}    ▄█████████▄    ",
        f"{COLORS['TERRA']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['ESPER']}  ✧ Esper Power ✧  {COLORS['RESET']}",
    ],
    'LOCKE': [
        f"{COLORS['LOCKE']}      ▄▄▄▄▄▄      ",
        f"{COLORS['LOCKE']}    ▄████████▄    ",
        f"{COLORS['LOCKE']}   ████{COLORS['HAIR_BROWN']}▄▄▄▄{COLORS['LOCKE']}████   ",
        f"{COLORS['LOCKE']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['LOCKE']}████  ",
        f"{COLORS['LOCKE']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['LOCKE']}███  ",
        f"{COLORS['LOCKE']}  ▀█████████████▀  ",
        f"{COLORS['LOCKE']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['LOCKE']}      ▄▄███▄▄      ",
        f"{COLORS['LOCKE']}     ▄███████▄     ",
        f"{COLORS['LOCKE']}    ▄█████████▄    ",
        f"{COLORS['LOCKE']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['LOCKE']}  ⚔ Treasure Hunter ⚔  {COLORS['RESET']}",
    ],
    'EDGAR': [
        f"{COLORS['EDGAR']}      ▄▄▄▄▄▄      ",
        f"{COLORS['EDGAR']}    ▄████████▄    ",
        f"{COLORS['EDGAR']}   ████{COLORS['HAIR_BLONDE']}▄▄▄▄{COLORS['EDGAR']}████   ",
        f"{COLORS['EDGAR']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['EDGAR']}████  ",
        f"{COLORS['EDGAR']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['EDGAR']}███  ",
        f"{COLORS['EDGAR']}  ▀█████████████▀  ",
        f"{COLORS['EDGAR']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['EDGAR']}      ▄▄███▄▄      ",
        f"{COLORS['EDGAR']}     ▄███████▄     ",
        f"{COLORS['EDGAR']}    ▄█████████▄    ",
        f"{COLORS['EDGAR']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['EDGAR']}  ♔ King of Figaro ♔  {COLORS['RESET']}",
    ],
    'SABIN': [
        f"{COLORS['SABIN']}      ▄▄▄▄▄▄      ",
        f"{COLORS['SABIN']}    ▄████████▄    ",
        f"{COLORS['SABIN']}   ████{COLORS['HAIR_BLONDE']}▄▄▄▄{COLORS['SABIN']}████   ",
        f"{COLORS['SABIN']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['SABIN']}████  ",
        f"{COLORS['SABIN']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['SABIN']}███  ",
        f"{COLORS['SABIN']}  ▀█████████████▀  ",
        f"{COLORS['SABIN']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['SABIN']}      ▄▄███▄▄      ",
        f"{COLORS['SABIN']}     ▄███████▄     ",
        f"{COLORS['SABIN']}    ▄█████████▄    ",
        f"{COLORS['SABIN']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['SABIN']}  ☯ Blitz Master ☯  {COLORS['RESET']}",
    ],
    'CYAN': [
        f"{COLORS['CYAN']}      ▄▄▄▄▄▄      ",
        f"{COLORS['CYAN']}    ▄████████▄    ",
        f"{COLORS['CYAN']}   ████{COLORS['HAIR_BROWN']}▄▄▄▄{COLORS['CYAN']}████   ",
        f"{COLORS['CYAN']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['CYAN']}████  ",
        f"{COLORS['CYAN']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['CYAN']}███  ",
        f"{COLORS['CYAN']}  ▀█████████████▀  ",
        f"{COLORS['CYAN']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['CYAN']}      ▄▄███▄▄      ",
        f"{COLORS['CYAN']}     ▄███████▄     ",
        f"{COLORS['CYAN']}    ▄█████████▄    ",
        f"{COLORS['CYAN']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['CYAN']}  ⚔ Samurai of Doma ⚔  {COLORS['RESET']}",
    ],
    'SHADOW': [
        f"{COLORS['SHADOW']}      ▄▄▄▄▄▄      ",
        f"{COLORS['SHADOW']}    ▄████████▄    ",
        f"{COLORS['SHADOW']}   ████████████   ",
        f"{COLORS['SHADOW']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['SHADOW']}████  ",
        f"{COLORS['SHADOW']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['SHADOW']}███  ",
        f"{COLORS['SHADOW']}  ▀█████████████▀  ",
        f"{COLORS['SHADOW']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['SHADOW']}      ▄▄███▄▄      ",
        f"{COLORS['SHADOW']}     ▄███████▄     ",
        f"{COLORS['SHADOW']}    ▄█████████▄    ",
        f"{COLORS['SHADOW']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['SHADOW']}  ⚔ Assassin's Blade ⚔  {COLORS['RESET']}",
    ],
    'CELES': [
        f"{COLORS['CELES']}      ▄▄▄▄▄▄      ",
        f"{COLORS['CELES']}    ▄████████▄    ",
        f"{COLORS['CELES']}   ████{COLORS['HAIR_BLONDE']}▄▄▄▄{COLORS['CELES']}████   ",
        f"{COLORS['CELES']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['CELES']}████  ",
        f"{COLORS['CELES']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['CELES']}███  ",
        f"{COLORS['CELES']}  ▀█████████████▀  ",
        f"{COLORS['CELES']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['CELES']}      ▄▄███▄▄      ",
        f"{COLORS['CELES']}     ▄███████▄     ",
        f"{COLORS['CELES']}    ▄█████████▄    ",
        f"{COLORS['CELES']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['CELES']}  ❄ Runic Knight ❄  {COLORS['RESET']}",
    ],
    'KEFKA': [
        f"{COLORS['KEFKA']}      ▄▄▄▄▄▄      ",
        f"{COLORS['KEFKA']}    ▄████████▄    ",
        f"{COLORS['KEFKA']}   ████{COLORS['RESET']}▄▄▄▄{COLORS['KEFKA']}████   ",
        f"{COLORS['KEFKA']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['KEFKA']}████  ",
        f"{COLORS['KEFKA']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['KEFKA']}███  ",
        f"{COLORS['KEFKA']}  ▀█████████████▀  ",
        f"{COLORS['KEFKA']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['KEFKA']}      ▄▄███▄▄      ",
        f"{COLORS['KEFKA']}     ▄███████▄     ",
        f"{COLORS['KEFKA']}    ▄█████████▄    ",
        f"{COLORS['KEFKA']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['KEFKA']}  ☠ Son of a Submariner! ☠  {COLORS['RESET']}",
    ],
    'ULTROS': [
        f"{COLORS['ULTROS']}       ▄▄▄▄▄       ",
        f"{COLORS['ULTROS']}     ▄███████▄     ",
        f"{COLORS['ULTROS']}    ▄█████████▄    ",
        f"{COLORS['ULTROS']}   ▄███████████▄   ",
        f"{COLORS['ULTROS']}  ▄█████████████▄  ",
        f"{COLORS['ULTROS']} ▄███████████████▄ ",
        f"{COLORS['ULTROS']} ███████████████████▄",
        f"{COLORS['ULTROS']} ▀█████████████████▀",
        f"{COLORS['ULTROS']}  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀  ",
        f"{COLORS['ULTROS']}  ☠ Seafood Soup! ☠  {COLORS['RESET']}",
    ],
    'MOG': [
        f"{COLORS['MOG']}      ▄▄▄▄▄▄      ",
        f"{COLORS['MOG']}    ▄████████▄    ",
        f"{COLORS['MOG']}   ████{COLORS['RESET']}▀▀▀▀{COLORS['MOG']}████   ",
        f"{COLORS['MOG']}  ████{COLORS['RESET']}▄▄▄▄▄▄{COLORS['MOG']}████  ",
        f"{COLORS['MOG']}  ███{COLORS['RESET']}▄▄▄▄▄▄▄▄{COLORS['MOG']}███  ",
        f"{COLORS['MOG']}  ▀█████████████▀  ",
        f"{COLORS['MOG']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['MOG']}      ▄▄███▄▄      ",
        f"{COLORS['MOG']}     ▄███████▄     ",
        f"{COLORS['MOG']}    ▄█████████▄    ",
        f"{COLORS['MOG']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['MOG']}  ♪ Kupo Kupo! ♪  {COLORS['RESET']}",
    ],
    'SETZER': [
        f"{COLORS['SETZER']}      ▄▄▄▄▄▄      ",
        f"{COLORS['SETZER']}    ▄████████▄    ",
        f"{COLORS['SETZER']}   ████{COLORS['HAIR_BLONDE']}▄▄▄▄{COLORS['SETZER']}████   ",
        f"{COLORS['SETZER']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['SETZER']}████  ",
        f"{COLORS['SETZER']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['SETZER']}███  ",
        f"{COLORS['SETZER']}  ▀█████████████▀  ",
        f"{COLORS['SETZER']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['SETZER']}      ▄▄███▄▄      ",
        f"{COLORS['SETZER']}     ▄███████▄     ",
        f"{COLORS['SETZER']}    ▄█████████▄    ",
        f"{COLORS['SETZER']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['SETZER']}  ♠ Wandering Gambler ♠  {COLORS['RESET']}",
    ],
    'GAU': [
        f"{COLORS['GAU']}      ▄▄▄▄▄▄      ",
        f"{COLORS['GAU']}    ▄████████▄    ",
        f"{COLORS['GAU']}   ████{COLORS['HAIR_BROWN']}▄▄▄▄{COLORS['GAU']}████   ",
        f"{COLORS['GAU']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['GAU']}████  ",
        f"{COLORS['GAU']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['GAU']}███  ",
        f"{COLORS['GAU']}  ▀█████████████▀  ",
        f"{COLORS['GAU']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['GAU']}      ▄▄███▄▄      ",
        f"{COLORS['GAU']}     ▄███████▄     ",
        f"{COLORS['GAU']}    ▄█████████▄    ",
        f"{COLORS['GAU']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['GAU']}  ☯ Wild Child ☯  {COLORS['RESET']}",
    ],
    'RELM': [
        f"{COLORS['RELM']}      ▄▄▄▄▄▄      ",
        f"{COLORS['RELM']}    ▄████████▄    ",
        f"{COLORS['RELM']}   ████{COLORS['HAIR_BLONDE']}▄▄▄▄{COLORS['RELM']}████   ",
        f"{COLORS['RELM']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['RELM']}████  ",
        f"{COLORS['RELM']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['RELM']}███  ",
        f"{COLORS['RELM']}  ▀█████████████▀  ",
        f"{COLORS['RELM']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['RELM']}      ▄▄███▄▄      ",
        f"{COLORS['RELM']}     ▄███████▄     ",
        f"{COLORS['RELM']}    ▄█████████▄    ",
        f"{COLORS['RELM']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['RELM']}  🎨 Sketch Artist 🎨  {COLORS['RESET']}",
    ],
    'STRAGO': [
        f"{COLORS['STRAGO']}      ▄▄▄▄▄▄      ",
        f"{COLORS['STRAGO']}    ▄████████▄    ",
        f"{COLORS['STRAGO']}   ████{COLORS['HAIR_BROWN']}▄▄▄▄{COLORS['STRAGO']}████   ",
        f"{COLORS['STRAGO']}  ████{COLORS['SKIN']}▀▀▀▀▀▀{COLORS['STRAGO']}████  ",
        f"{COLORS['STRAGO']}  ███{COLORS['SKIN']}▄{COLORS['RESET']}▀▀▀▀{COLORS['SKIN']}▄{COLORS['STRAGO']}███  ",
        f"{COLORS['STRAGO']}  ▀█████████████▀  ",
        f"{COLORS['STRAGO']}    ▀▀▀█████▀▀▀    ",
        f"{COLORS['STRAGO']}      ▄▄███▄▄      ",
        f"{COLORS['STRAGO']}     ▄███████▄     ",
        f"{COLORS['STRAGO']}    ▄█████████▄    ",
        f"{COLORS['STRAGO']}    ▀▀▀▀▀▀▀▀▀▀▀    ",
        f"{COLORS['STRAGO']}  ✧ Blue Mage ✧  {COLORS['RESET']}",
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
