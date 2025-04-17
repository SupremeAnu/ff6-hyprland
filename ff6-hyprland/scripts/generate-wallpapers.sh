#!/usr/bin/env python3
# FF6-Themed Hyprland Configuration - Gradient Wallpaper Generator
# This script creates a gradient wallpaper that matches the FF6 color scheme

import os
import sys
from PIL import Image, ImageDraw

def create_gradient_wallpaper(output_path, width, height, color1, color2, direction='vertical'):
    """
    Create a gradient wallpaper with the specified colors and direction.
    
    Args:
        output_path: Path to save the wallpaper
        width: Width of the wallpaper
        height: Height of the wallpaper
        color1: Starting color in RGB tuple format
        color2: Ending color in RGB tuple format
        direction: 'vertical', 'horizontal', or 'diagonal'
    """
    # Create a new image with the specified dimensions
    img = Image.new('RGB', (width, height), color=color1)
    draw = ImageDraw.Draw(img)
    
    # Create the gradient
    if direction == 'vertical':
        for y in range(height):
            # Calculate the ratio of the current position
            ratio = y / height
            # Interpolate between the two colors
            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            # Draw a line with the interpolated color
            draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    elif direction == 'horizontal':
        for x in range(width):
            # Calculate the ratio of the current position
            ratio = x / width
            # Interpolate between the two colors
            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            # Draw a line with the interpolated color
            draw.line([(x, 0), (x, height)], fill=(r, g, b))
    
    elif direction == 'diagonal':
        for x in range(width):
            for y in range(height):
                # Calculate the ratio of the current position
                ratio = (x + y) / (width + height)
                # Interpolate between the two colors
                r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
                g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
                b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
                # Set the pixel color
                img.putpixel((x, y), (r, g, b))
    
    # Save the image
    img.save(output_path)
    print(f"Wallpaper saved to {output_path}")

def main():
    # Create directory if it doesn't exist
    wallpaper_dir = os.path.expanduser("~/.config/hypr/wallpapers")
    os.makedirs(wallpaper_dir, exist_ok=True)
    
    # FF6 color scheme
    ff6_dark_blue = (10, 26, 63)      # #0a1a3f - Dark blue from FF6 menu
    ff6_blue = (26, 42, 95)           # #1a2a5f - Blue from FF6 menu
    ff6_light_blue = (58, 74, 143)    # #3a4a8f - Light blue from FF6 menu
    ff6_highlight = (74, 90, 175)     # #4a5aaf - Highlight blue from FF6 menu
    
    # Create wallpapers with different resolutions and directions
    resolutions = [
        (1920, 1080),  # Full HD
        (2560, 1440),  # 2K
        (3840, 2160)   # 4K
    ]
    
    for width, height in resolutions:
        # Vertical gradient (dark blue to light blue)
        output_path = os.path.join(wallpaper_dir, f"ff6_gradient_vertical_{width}x{height}.png")
        create_gradient_wallpaper(output_path, width, height, ff6_dark_blue, ff6_light_blue, 'vertical')
        
        # Horizontal gradient (dark blue to light blue)
        output_path = os.path.join(wallpaper_dir, f"ff6_gradient_horizontal_{width}x{height}.png")
        create_gradient_wallpaper(output_path, width, height, ff6_dark_blue, ff6_light_blue, 'horizontal')
        
        # Diagonal gradient (dark blue to light blue)
        output_path = os.path.join(wallpaper_dir, f"ff6_gradient_diagonal_{width}x{height}.png")
        create_gradient_wallpaper(output_path, width, height, ff6_dark_blue, ff6_light_blue, 'diagonal')
    
    # Set the default wallpaper
    default_wallpaper = os.path.join(wallpaper_dir, "ff6_gradient_vertical_1920x1080.png")
    current_wallpaper = os.path.join(wallpaper_dir, "current.png")
    
    # Create a symlink to the default wallpaper
    if os.path.exists(current_wallpaper):
        os.remove(current_wallpaper)
    os.symlink(default_wallpaper, current_wallpaper)
    
    print("Default wallpaper set to:", default_wallpaper)
    print("All wallpapers generated successfully!")

if __name__ == "__main__":
    main()
