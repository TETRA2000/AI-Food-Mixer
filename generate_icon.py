#!/usr/bin/env python3
"""Generate iOS app icon for AI Food Mixer."""

from PIL import Image, ImageDraw, ImageFont
import math
import os

SIZE = 1024

def create_icon():
    img = Image.new("RGB", (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # --- Background: warm gradient (coral-orange to deep purple) ---
    for y in range(SIZE):
        t = y / SIZE
        # Top: warm orange (#FF6B35) -> Bottom: deep purple (#4A1A6B)
        r = int(255 * (1 - t) + 74 * t)
        g = int(107 * (1 - t) + 26 * t)
        b = int(53 * (1 - t) + 107 * t)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # --- Subtle radial glow in center ---
    overlay = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    overlay_draw = ImageDraw.Draw(overlay)
    cx, cy = SIZE // 2, SIZE // 2 - 30
    max_radius = 380
    for radius in range(max_radius, 0, -2):
        alpha = int(40 * (1 - radius / max_radius))
        overlay_draw.ellipse(
            [cx - radius, cy - radius, cx + radius, cy + radius],
            fill=(255, 255, 255, alpha),
        )
    img = Image.alpha_composite(img.convert("RGBA"), overlay)
    draw = ImageDraw.Draw(img)

    # --- Draw a mixing bowl shape ---
    # Bowl body (wide arc at bottom)
    bowl_cx, bowl_cy = SIZE // 2, SIZE // 2 + 60
    bowl_w, bowl_h = 520, 340

    # Bowl shadow
    shadow_offset = 15
    draw.ellipse(
        [
            bowl_cx - bowl_w // 2 - 10 + shadow_offset,
            bowl_cy - 20 + shadow_offset,
            bowl_cx + bowl_w // 2 + 10 + shadow_offset,
            bowl_cy + bowl_h // 2 + 40 + shadow_offset,
        ],
        fill=(0, 0, 0, 40),
    )

    # Bowl body - white with slight transparency
    draw.ellipse(
        [
            bowl_cx - bowl_w // 2,
            bowl_cy - 20,
            bowl_cx + bowl_w // 2,
            bowl_cy + bowl_h // 2 + 40,
        ],
        fill=(255, 255, 255, 230),
    )

    # Bowl inner (slightly darker to show depth)
    inner_margin = 30
    draw.ellipse(
        [
            bowl_cx - bowl_w // 2 + inner_margin,
            bowl_cy - 20 + inner_margin // 2,
            bowl_cx + bowl_w // 2 - inner_margin,
            bowl_cy + bowl_h // 2 + 40 - inner_margin,
        ],
        fill=(245, 240, 235, 220),
    )

    # Bowl rim highlight
    draw.arc(
        [
            bowl_cx - bowl_w // 2 + 5,
            bowl_cy - 25,
            bowl_cx + bowl_w // 2 - 5,
            bowl_cy + 30,
        ],
        start=180,
        end=360,
        fill=(255, 255, 255, 200),
        width=6,
    )

    # --- Food emoji symbols inside bowl (using text) ---
    # Try to load a font that supports emoji, fall back to drawing colored circles
    # We'll draw stylized food elements as colored shapes inside the bowl

    # Colorful food circles/shapes inside the bowl to represent ingredients
    food_items = [
        # (x_offset, y_offset, radius, color) - offsets from bowl center
        (-120, 30, 42, (255, 87, 87, 220)),    # Red (tomato/pepper)
        (-40, 60, 38, (76, 187, 23, 220)),     # Green (lettuce/herb)
        (50, 35, 44, (255, 193, 7, 220)),      # Yellow (cheese/corn)
        (140, 55, 36, (255, 138, 101, 220)),   # Salmon (shrimp)
        (-80, 90, 34, (156, 39, 176, 220)),    # Purple (eggplant)
        (100, 95, 32, (33, 150, 243, 220)),    # Blue (blueberry)
        (10, 100, 40, (255, 152, 0, 220)),     # Orange
        (-150, 75, 30, (255, 235, 59, 220)),   # Light yellow
    ]

    for dx, dy, r, color in food_items:
        x = bowl_cx + dx
        y = bowl_cy + dy
        # Draw a slightly glossy circle
        draw.ellipse([x - r, y - r, x + r, y + r], fill=color)
        # Highlight
        highlight_r = r // 3
        draw.ellipse(
            [x - r // 2, y - r // 2, x - r // 2 + highlight_r, y - r // 2 + highlight_r],
            fill=(255, 255, 255, 80),
        )

    # --- Sparkle/AI indicators (small stars around the bowl) ---
    def draw_star(draw, cx, cy, size, color):
        """Draw a 4-point star."""
        points = []
        for i in range(8):
            angle = math.pi / 4 * i - math.pi / 2
            r = size if i % 2 == 0 else size * 0.35
            px = cx + r * math.cos(angle)
            py = cy + r * math.sin(angle)
            points.append((px, py))
        draw.polygon(points, fill=color)

    # Sparkles around the top of the bowl
    sparkles = [
        (bowl_cx - 200, bowl_cy - 120, 28, (255, 255, 255, 200)),
        (bowl_cx + 210, bowl_cy - 100, 22, (255, 255, 255, 180)),
        (bowl_cx - 260, bowl_cy + 20, 18, (255, 255, 200, 160)),
        (bowl_cx + 270, bowl_cy + 40, 20, (255, 255, 200, 160)),
        (bowl_cx - 100, bowl_cy - 160, 16, (255, 255, 255, 150)),
        (bowl_cx + 120, bowl_cy - 170, 24, (255, 255, 255, 190)),
        (bowl_cx, bowl_cy - 190, 30, (255, 255, 255, 210)),
    ]

    for sx, sy, ss, sc in sparkles:
        draw_star(draw, sx, sy, ss, sc)

    # --- Swirl lines above bowl to suggest mixing/AI magic ---
    # Draw curved lines suggesting steam/magic
    for i, (offset, alpha) in enumerate([(-60, 120), (0, 160), (60, 120)]):
        points = []
        for t_int in range(0, 101, 2):
            t = t_int / 100.0
            x = bowl_cx + offset + 30 * math.sin(t * math.pi * 2)
            y = bowl_cy - 40 - t * 140
            points.append((x, y))
        if len(points) > 1:
            draw.line(points, fill=(255, 255, 255, alpha), width=4, joint="curve")

    # --- Convert to RGB (no alpha for iOS) ---
    final = Image.new("RGB", (SIZE, SIZE), (255, 255, 255))
    final = Image.alpha_composite(
        final.convert("RGBA"), img
    ).convert("RGB")

    return final


if __name__ == "__main__":
    icon = create_icon()

    # Save to AppIcon asset catalog
    icon_dir = "AI Food Mixer/Assets.xcassets/AppIcon.appiconset"

    # Light/default icon
    icon_path = os.path.join(icon_dir, "AppIcon.png")
    icon.save(icon_path, "PNG")
    print(f"Saved: {icon_path}")

    # Dark variant (darker background)
    dark_img = Image.new("RGB", (SIZE, SIZE))
    dark_draw = ImageDraw.Draw(dark_img)
    for y in range(SIZE):
        t = y / SIZE
        # Darker variant: deep teal to near-black
        r = int(20 * (1 - t) + 10 * t)
        g = int(60 * (1 - t) + 15 * t)
        b = int(80 * (1 - t) + 40 * t)
        dark_draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Reuse the icon but composite the elements on dark background
    dark_base = dark_img.convert("RGBA")
    # Get the icon elements (everything except background)
    # Simpler: just darken the existing icon
    from PIL import ImageEnhance
    dark_icon = ImageEnhance.Brightness(icon).enhance(0.6)
    # Boost saturation slightly
    dark_icon = ImageEnhance.Color(dark_icon).enhance(1.2)

    dark_path = os.path.join(icon_dir, "AppIcon-Dark.png")
    dark_icon.save(dark_path, "PNG")
    print(f"Saved: {dark_path}")

    # Tinted variant (monochrome-ish, desaturated)
    tinted_icon = ImageEnhance.Color(icon).enhance(0.3)
    tinted_icon = ImageEnhance.Brightness(tinted_icon).enhance(0.85)

    tinted_path = os.path.join(icon_dir, "AppIcon-Tinted.png")
    tinted_icon.save(tinted_path, "PNG")
    print(f"Saved: {tinted_path}")

    print("All icons generated successfully!")
