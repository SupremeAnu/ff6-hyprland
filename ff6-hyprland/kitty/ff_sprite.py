#!/usr/bin/env python3
# Final Fantasy Sprite Display Script for Kitty Terminal
# Theme: Final Fantasy VI Menu Style with authentic character sprites
# Created: April 2025

import random
import datetime
import os
import sys

# ANSI color codes for more vibrant, authentic FF character colors
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
    
    # Custom colors for authentic FF character sprites
    TERRA_GREEN = "\033[38;2;0;180;0m"
    TERRA_HAIR = "\033[38;2;0;255;128m"
    LOCKE_BLUE = "\033[38;2;100;140;220m"
    LOCKE_SKIN = "\033[38;2;255;200;160m"
    EDGAR_BLUE = "\033[38;2;50;100;255m"
    EDGAR_HAIR = "\033[38;2;255;240;150m"
    SABIN_ORANGE = "\033[38;2;255;160;0m"
    SABIN_SKIN = "\033[38;2;255;190;140m"
    CYAN_BLUE = "\033[38;2;0;100;200m"
    CYAN_ARMOR = "\033[38;2;0;150;255m"
    SHADOW_PURPLE = "\033[38;2;100;0;100m"
    SHADOW_GRAY = "\033[38;2;100;100;100m"
    CELES_YELLOW = "\033[38;2;255;255;150m"
    CELES_ARMOR = "\033[38;2;200;200;255m"
    SETZER_COAT = "\033[38;2;180;180;180m"
    SETZER_HAIR = "\033[38;2;220;220;220m"
    RELM_RED = "\033[38;2;255;100;100m"
    RELM_YELLOW = "\033[38;2;255;255;100m"
    STRAGO_BLUE = "\033[38;2;100;100;255m"
    STRAGO_ROBE = "\033[38;2;80;80;200m"
    MOG_PINK = "\033[38;2;255;180;220m"
    MOG_FUR = "\033[38;2;255;220;240m"
    UMARO_BLUE = "\033[38;2;150;200;255m"
    UMARO_FUR = "\033[38;2;220;240;255m"
    GOGO_YELLOW = "\033[38;2;255;220;0m"
    GOGO_ROBE = "\033[38;2;255;180;0m"
    KEFKA_RED = "\033[38;2;255;50;50m"
    KEFKA_YELLOW = "\033[38;2;255;255;50m"
    KEFKA_GREEN = "\033[38;2;50;255;50m"
    KEFKA_BLUE = "\033[38;2;50;50;255m"
    KEFKA_PURPLE = "\033[38;2;200;50;200m"
    ULTROS_PURPLE = "\033[38;2;180;50;180m"
    ULTROS_PINK = "\033[38;2;255;150;220m"
    GILGAMESH_RED = "\033[38;2;220;50;50m"
    GILGAMESH_GRAY = "\033[38;2;150;150;150m"
    EXDEATH_BLUE = "\033[38;2;50;50;150m"
    EXDEATH_PURPLE = "\033[38;2;100;0;100m"
    GOLBEZ_PURPLE = "\033[38;2;120;0;120m"
    GOLBEZ_ARMOR = "\033[38;2;80;0;80m"
    GARLAND_BLUE = "\033[38;2;0;0;150m"
    GARLAND_ARMOR = "\033[38;2;50;50;100m"
    CHAOS_RED = "\033[38;2;200;0;0m"
    CHAOS_ORANGE = "\033[38;2;255;100;0m"

# More detailed and colorful Final Fantasy character sprites
ff_sprites = {
    # FF6 Characters
    "Terra": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.TERRA_HAIR}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.TERRA_HAIR}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.TERRA_HAIR}█{Colors.BLACK}▀{Colors.TERRA_HAIR}███{Colors.BLACK}▀{Colors.TERRA_HAIR}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.TERRA_GREEN}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.TERRA_GREEN}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.TERRA_GREEN}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.TERRA_GREEN}█{Colors.BLACK}▀▀▀{Colors.TERRA_GREEN}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.TERRA_GREEN}█{Colors.BLACK} {Colors.TERRA_GREEN}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Locke": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_YELLOW}▄▄{Colors.LOCKE_SKIN}███{Colors.BRIGHT_YELLOW}▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}█{Colors.BLACK}▀{Colors.LOCKE_SKIN}███{Colors.BLACK}▀{Colors.LOCKE_SKIN}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_BLUE}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.LOCKE_BLUE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_BLUE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.LOCKE_BLUE}█{Colors.BLACK}▀▀▀{Colors.LOCKE_BLUE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.LOCKE_BLUE}█{Colors.BLACK} {Colors.LOCKE_BLUE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Edgar": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.EDGAR_HAIR}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EDGAR_HAIR}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EDGAR_HAIR}█{Colors.BLACK}▀{Colors.EDGAR_HAIR}███{Colors.BLACK}▀{Colors.EDGAR_HAIR}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EDGAR_BLUE}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.EDGAR_BLUE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EDGAR_BLUE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.EDGAR_BLUE}█{Colors.BLACK}▀▀▀{Colors.EDGAR_BLUE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.EDGAR_BLUE}█{Colors.BLACK} {Colors.EDGAR_BLUE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Sabin": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.EDGAR_HAIR}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EDGAR_HAIR}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EDGAR_HAIR}█{Colors.BLACK}▀{Colors.EDGAR_HAIR}███{Colors.BLACK}▀{Colors.EDGAR_HAIR}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SABIN_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SABIN_ORANGE}▄{Colors.SABIN_SKIN}▀▀▀▀▀{Colors.SABIN_ORANGE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SABIN_ORANGE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.SABIN_ORANGE}█{Colors.BLACK}▀▀▀{Colors.SABIN_ORANGE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.SABIN_ORANGE}█{Colors.BLACK} {Colors.SABIN_ORANGE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Cyan": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.BLACK}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BLACK}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BLACK}█{Colors.BLACK}▀{Colors.BLACK}███{Colors.BLACK}▀{Colors.BLACK}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CYAN_ARMOR}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.CYAN_ARMOR}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CYAN_BLUE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.CYAN_BLUE}█{Colors.BLACK}▀▀▀{Colors.CYAN_BLUE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.CYAN_BLUE}█{Colors.BLACK} {Colors.CYAN_BLUE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Shadow": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.SHADOW_GRAY}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SHADOW_GRAY}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SHADOW_GRAY}█{Colors.RED}▀{Colors.SHADOW_GRAY}███{Colors.RED}▀{Colors.SHADOW_GRAY}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SHADOW_PURPLE}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.SHADOW_PURPLE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SHADOW_PURPLE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.SHADOW_PURPLE}█{Colors.BLACK}▀▀▀{Colors.SHADOW_PURPLE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.SHADOW_PURPLE}█{Colors.BLACK} {Colors.SHADOW_PURPLE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Celes": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.CELES_YELLOW}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CELES_YELLOW}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CELES_YELLOW}█{Colors.BLACK}▀{Colors.CELES_YELLOW}███{Colors.BLACK}▀{Colors.CELES_YELLOW}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CELES_ARMOR}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.CELES_ARMOR}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CELES_ARMOR}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.CELES_ARMOR}█{Colors.BLACK}▀▀▀{Colors.CELES_ARMOR}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.CELES_ARMOR}█{Colors.BLACK} {Colors.CELES_ARMOR}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Setzer": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.SETZER_HAIR}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SETZER_HAIR}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SETZER_HAIR}█{Colors.BLACK}▀{Colors.SETZER_HAIR}███{Colors.BLACK}▀{Colors.SETZER_HAIR}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SETZER_COAT}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.SETZER_COAT}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.SETZER_COAT}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.SETZER_COAT}█{Colors.BLACK}▀▀▀{Colors.SETZER_COAT}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.SETZER_COAT}█{Colors.BLACK} {Colors.SETZER_COAT}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Mog": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.MOG_FUR}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.MOG_FUR}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.MOG_FUR}█{Colors.RED}▀{Colors.MOG_FUR}███{Colors.RED}▀{Colors.MOG_FUR}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.MOG_FUR}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.MOG_PINK}▄{Colors.MOG_FUR}▀▀▀▀▀{Colors.MOG_PINK}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.MOG_PINK}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.MOG_PINK}█{Colors.BLACK}▀▀▀{Colors.MOG_PINK}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.MOG_PINK}█{Colors.BLACK} {Colors.MOG_PINK}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Kefka": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.KEFKA_YELLOW}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.KEFKA_YELLOW}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.KEFKA_YELLOW}█{Colors.BLACK}▀{Colors.KEFKA_YELLOW}███{Colors.BLACK}▀{Colors.KEFKA_YELLOW}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.WHITE}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.KEFKA_RED}▄{Colors.KEFKA_GREEN}▀{Colors.KEFKA_BLUE}▀{Colors.KEFKA_PURPLE}▀{Colors.KEFKA_RED}▀{Colors.KEFKA_GREEN}▀{Colors.KEFKA_RED}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.KEFKA_RED}██{Colors.KEFKA_GREEN}█{Colors.KEFKA_BLUE}█{Colors.KEFKA_PURPLE}█{Colors.KEFKA_RED}█{Colors.KEFKA_GREEN}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.KEFKA_RED}█{Colors.BLACK}▀▀▀{Colors.KEFKA_RED}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.KEFKA_RED}█{Colors.BLACK} {Colors.KEFKA_RED}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Ultros": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.ULTROS_PURPLE}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.ULTROS_PURPLE}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.ULTROS_PURPLE}█{Colors.WHITE}▀{Colors.ULTROS_PURPLE}███{Colors.WHITE}▀{Colors.ULTROS_PURPLE}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.ULTROS_PURPLE}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.ULTROS_PINK}▄{Colors.ULTROS_PURPLE}▀▀▀▀▀{Colors.ULTROS_PINK}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.ULTROS_PINK}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.ULTROS_PINK}█{Colors.BLACK}▀▀▀{Colors.ULTROS_PINK}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.ULTROS_PINK}█{Colors.BLACK} {Colors.ULTROS_PINK}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    
    # FF5 Characters
    "Bartz": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.BRIGHT_YELLOW}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_YELLOW}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_YELLOW}█{Colors.BLACK}▀{Colors.BRIGHT_YELLOW}███{Colors.BLACK}▀{Colors.BRIGHT_YELLOW}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_BLUE}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.BRIGHT_BLUE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_BLUE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.BRIGHT_BLUE}█{Colors.BLACK}▀▀▀{Colors.BRIGHT_BLUE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.BRIGHT_BLUE}█{Colors.BLACK} {Colors.BRIGHT_BLUE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Gilgamesh": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.GILGAMESH_GRAY}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GILGAMESH_GRAY}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GILGAMESH_GRAY}█{Colors.BLACK}▀{Colors.GILGAMESH_GRAY}███{Colors.BLACK}▀{Colors.GILGAMESH_GRAY}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GILGAMESH_GRAY}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GILGAMESH_RED}▄{Colors.GILGAMESH_GRAY}▀▀▀▀▀{Colors.GILGAMESH_RED}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GILGAMESH_RED}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.GILGAMESH_RED}█{Colors.BLACK}▀▀▀{Colors.GILGAMESH_RED}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.GILGAMESH_RED}█{Colors.BLACK} {Colors.GILGAMESH_RED}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Exdeath": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.EXDEATH_BLUE}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EXDEATH_BLUE}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EXDEATH_BLUE}█{Colors.RED}▀{Colors.EXDEATH_BLUE}███{Colors.RED}▀{Colors.EXDEATH_BLUE}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EXDEATH_BLUE}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EXDEATH_PURPLE}▄{Colors.EXDEATH_BLUE}▀▀▀▀▀{Colors.EXDEATH_PURPLE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.EXDEATH_PURPLE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.EXDEATH_PURPLE}█{Colors.BLACK}▀▀▀{Colors.EXDEATH_PURPLE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.EXDEATH_PURPLE}█{Colors.BLACK} {Colors.EXDEATH_PURPLE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    
    # FF4 Characters
    "Cecil": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.WHITE}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.WHITE}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.WHITE}█{Colors.BLACK}▀{Colors.WHITE}███{Colors.BLACK}▀{Colors.WHITE}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_CYAN}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.BRIGHT_CYAN}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_CYAN}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.BRIGHT_CYAN}█{Colors.BLACK}▀▀▀{Colors.BRIGHT_CYAN}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.BRIGHT_CYAN}█{Colors.BLACK} {Colors.BRIGHT_CYAN}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Golbez": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.GOLBEZ_ARMOR}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GOLBEZ_ARMOR}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GOLBEZ_ARMOR}█{Colors.RED}▀{Colors.GOLBEZ_ARMOR}███{Colors.RED}▀{Colors.GOLBEZ_ARMOR}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GOLBEZ_ARMOR}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GOLBEZ_PURPLE}▄{Colors.GOLBEZ_ARMOR}▀▀▀▀▀{Colors.GOLBEZ_PURPLE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GOLBEZ_PURPLE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.GOLBEZ_PURPLE}█{Colors.BLACK}▀▀▀{Colors.GOLBEZ_PURPLE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.GOLBEZ_PURPLE}█{Colors.BLACK} {Colors.GOLBEZ_PURPLE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    
    # FF1 Characters
    "Warrior of Light": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.BRIGHT_BLUE}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_BLUE}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_BLUE}█{Colors.BLACK}▀{Colors.BRIGHT_BLUE}███{Colors.BLACK}▀{Colors.BRIGHT_BLUE}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.LOCKE_SKIN}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_CYAN}▄{Colors.LOCKE_SKIN}▀▀▀▀▀{Colors.BRIGHT_CYAN}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.BRIGHT_CYAN}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.BRIGHT_CYAN}█{Colors.BLACK}▀▀▀{Colors.BRIGHT_CYAN}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.BRIGHT_CYAN}█{Colors.BLACK} {Colors.BRIGHT_CYAN}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Garland": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.GARLAND_ARMOR}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GARLAND_ARMOR}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GARLAND_ARMOR}█{Colors.RED}▀{Colors.GARLAND_ARMOR}███{Colors.RED}▀{Colors.GARLAND_ARMOR}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GARLAND_ARMOR}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GARLAND_BLUE}▄{Colors.GARLAND_ARMOR}▀▀▀▀▀{Colors.GARLAND_BLUE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.GARLAND_BLUE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.GARLAND_BLUE}█{Colors.BLACK}▀▀▀{Colors.GARLAND_BLUE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.GARLAND_BLUE}█{Colors.BLACK} {Colors.GARLAND_BLUE}█{Colors.BLACK}█      {Colors.RESET}"
    ],
    "Chaos": [
        f"{Colors.BLACK}       ▄▄▄▄▄       {Colors.RESET}",
        f"{Colors.BLACK}     ▄{Colors.CHAOS_RED}▀▀▀▀▀{Colors.BLACK}▄     {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CHAOS_RED}▄▄███▄▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CHAOS_RED}█{Colors.YELLOW}▀{Colors.CHAOS_RED}███{Colors.YELLOW}▀{Colors.CHAOS_RED}█{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CHAOS_RED}▀▀▀▀▀▀▀{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CHAOS_ORANGE}▄{Colors.CHAOS_RED}▀▀▀▀▀{Colors.CHAOS_ORANGE}▄{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}    █{Colors.CHAOS_ORANGE}███████{Colors.BLACK}█    {Colors.RESET}",
        f"{Colors.BLACK}     ▀{Colors.CHAOS_ORANGE}█{Colors.BLACK}▀▀▀{Colors.CHAOS_ORANGE}█{Colors.BLACK}▀     {Colors.RESET}",
        f"{Colors.BLACK}      █{Colors.CHAOS_ORANGE}█{Colors.BLACK} {Colors.CHAOS_ORANGE}█{Colors.BLACK}█      {Colors.RESET}"
    ]
}

def display_sprite_and_time():
    # Get current date and time in US format (24-hour)
    now = datetime.datetime.now()
    date_time = now.strftime("%m/%d/%Y %H:%M:%S")
    
    # Select a random character
    character_name = random.choice(list(ff_sprites.keys()))
    sprite = ff_sprites[character_name]
    
    # Create FF6-style menu box but with more authentic colors
    box_width = 40
    
    # Top border - using black for border instead of FF6 blue to make sprites stand out
    top_border = f"{Colors.BLACK}╔{'═' * (box_width - 2)}╗{Colors.RESET}"
    
    # Bottom border
    bottom_border = f"{Colors.BLACK}╚{'═' * (box_width - 2)}╝{Colors.RESET}"
    
    # Print the menu box
    print("\n" + top_border)
    
    # Print the sprite with side borders
    for line in sprite:
        padding = " " * ((box_width - 2 - len(line.strip())) // 2)
        print(f"{Colors.BLACK}║{Colors.RESET}{padding}{line}{padding}{Colors.BLACK}║{Colors.RESET}")
    
    # Print character name with side borders
    name_padding = " " * ((box_width - 2 - len(character_name)) // 2)
    print(f"{Colors.BLACK}║{Colors.RESET}{name_padding}{Colors.BRIGHT_WHITE}{Colors.BOLD}{character_name}{Colors.RESET}{name_padding}{Colors.BLACK}║{Colors.RESET}")
    
    # Print date/time with side borders
    time_padding = " " * ((box_width - 2 - len(date_time)) // 2)
    print(f"{Colors.BLACK}║{Colors.RESET}{time_padding}{Colors.WHITE}{date_time}{Colors.RESET}{time_padding}{Colors.BLACK}║{Colors.RESET}")
    
    # Print bottom border
    print(bottom_border + "\n")

if __name__ == "__main__":
    display_sprite_and_time()
