#!/usr/bin/env python3
"""
Create a circular avatar with geometric background pattern
Similar style to ava_gen2.png
"""

from PIL import Image, ImageDraw
import math

def create_geometric_background(size):
    """Create a geometric background with diagonal stripes"""
    img = Image.new('RGB', (size, size), '#1a1f2e')
    draw = ImageDraw.Draw(img)

    # Define colors for the geometric pattern (dark blue/teal tones)
    colors = ['#1a1f2e', '#2a3f5f', '#1e3a5f', '#2d4a6f']

    # Create diagonal stripe pattern
    stripe_width = size // 4
    for i in range(-size, size * 2, stripe_width):
        # Draw diagonal rectangles
        color = colors[i % len(colors)]
        points = [
            (i, 0),
            (i + stripe_width, 0),
            (i + stripe_width + size, size),
            (i + size, size)
        ]
        draw.polygon(points, fill=color)

    return img

def create_circular_avatar(input_path, output_path, final_size=500, transparent=False):
    """
    Create a circular avatar from an input image with geometric background or transparent

    Args:
        input_path: Path to input image
        output_path: Path to save output image
        final_size: Final size of the square output image
        transparent: If True, use transparent background outside circle
    """
    # Load the source image
    img = Image.open(input_path)

    # Convert to RGB if necessary
    if img.mode != 'RGB':
        img = img.convert('RGB')

    # Get dimensions
    width, height = img.size

    # Calculate crop box to get a square centered on the image
    # Assume face is in the upper-center portion
    if width > height:
        # Landscape - crop sides
        left = (width - height) // 2
        top = 0
        right = left + height
        bottom = height
    else:
        # Portrait - crop top and bottom, favor top portion for headshot
        left = 0
        top = max(0, (height - width) // 4)  # Slight offset to get face better
        right = width
        bottom = top + width

    # Crop to square
    img_square = img.crop((left, top, right, bottom))

    # Resize to final size
    img_square = img_square.resize((final_size, final_size), Image.Resampling.LANCZOS)

    # Create circular mask
    mask = Image.new('L', (final_size, final_size), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, final_size, final_size), fill=255)

    if transparent:
        # Create transparent background (RGBA)
        output = Image.new('RGBA', (final_size, final_size), (0, 0, 0, 0))

        # Convert portrait to RGBA
        img_square = img_square.convert('RGBA')

        # Paste the circular portrait onto transparent background using the mask
        output.paste(img_square, (0, 0), mask)
    else:
        # Create geometric background
        background = create_geometric_background(final_size)

        # Create output image
        output = background.copy()

        # Paste the circular portrait onto the background using the mask
        output.paste(img_square, (0, 0), mask)

    # Save the result
    output.save(output_path, 'PNG', quality=95)
    print(f"Avatar created successfully: {output_path}")
    print(f"Size: {final_size}x{final_size} pixels")
    print(f"Transparent background: {transparent}")

if __name__ == '__main__':
    # Process the image
    input_image = '/Users/alexk/workspace/website/tmp/image.jpg'
    output_image = '/Users/alexk/workspace/website/assets/ava_gen3.png'

    # Create with transparent background outside the circle
    create_circular_avatar(input_image, output_image, final_size=500, transparent=True)
