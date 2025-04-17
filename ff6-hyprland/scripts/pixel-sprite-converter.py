#!/usr/bin/env python3
# FF6 Pixel Sprite Converter for Terminal Display
# Converts pixel art sprites to terminal-friendly ASCII art
# Created: April 2025

import os
import sys
from PIL import Image

def load_sprite(image_path):
    """Load a sprite image and return the pixel data"""
    try:
        img = Image.open(image_path)
        return img
    except Exception as e:
        print(f"Error loading image: {e}")
        return None

def get_ansi_color(r, g, b):
    """Convert RGB to ANSI color code"""
    return f"\\033[38;2;{r};{g};{b}m"

def pixel_to_block(r, g, b, a=255):
    """Convert a pixel to a terminal block character with color"""
    if a < 50:  # Very transparent, return empty space
        return " "
    
    # Use different block characters based on alpha
    if a < 100:
        block = "░"  # Light shade
    elif a < 200:
        block = "▒"  # Medium shade
    else:
        block = "█"  # Full block
    
    # Get ANSI color code
    color = get_ansi_color(r, g, b)
    return f"{color}{block}\\033[0m"

def convert_sprite_to_ascii(img, scale=1):
    """Convert sprite image to ASCII art with ANSI colors"""
    if not img:
        return []
    
    width, height = img.size
    ascii_lines = []
    
    # Resize if scaling is needed
    if scale != 1:
        new_width = int(width * scale)
        new_height = int(height * scale)
        img = img.resize((new_width, new_height), Image.NEAREST)
        width, height = new_width, new_height
    
    # Convert to RGBA if not already
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # Process each pixel
    for y in range(height):
        line = ""
        for x in range(width):
            r, g, b, a = img.getpixel((x, y))
            line += pixel_to_block(r, g, b, a)
        ascii_lines.append(f'f"{line}"')
    
    return ascii_lines

def generate_sprite_code(character_name, ascii_lines):
    """Generate Python code for the sprite"""
    code = [f"'{character_name}': ["]
    for line in ascii_lines:
        code.append(f"    {line},")
    code.append("],")
    return code

def main():
    if len(sys.argv) < 3:
        print("Usage: python pixel-sprite-converter.py <image_path> <character_name> [scale]")
        return
    
    image_path = sys.argv[1]
    character_name = sys.argv[2]
    scale = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
    
    img = load_sprite(image_path)
    if not img:
        return
    
    ascii_lines = convert_sprite_to_ascii(img, scale)
    code = generate_sprite_code(character_name, ascii_lines)
    
    print("\n".join(code))
    
    # Save to output file
    output_dir = os.path.dirname(os.path.abspath(image_path))
    output_file = os.path.join(output_dir, f"{character_name.lower()}_sprite.txt")
    with open(output_file, "w") as f:
        f.write("\n".join(code))
    
    print(f"\nSprite code saved to {output_file}")

if __name__ == "__main__":
    main()
