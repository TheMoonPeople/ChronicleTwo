#!/usr/bin/env python3
"""Draw the quick loadout panel: four slots under a title bar, in the style of the dungeon's active item board (gold
tube lines with a dark rim around plum fills darkening upwards). Everything is drawn here from shapes, nothing taken
from the game.

    quick_loadout_panel.py <out.png>

The slot and title positions it uses are kSlotArt, kTitleX and kTitleY in port/src/quick_loadout.cpp.
"""

import math
import sys

import numpy as np
from PIL import Image

WIDTH, HEIGHT = 381, 305
SCALE = 4  # drawn this many times larger, then shrunk, for smooth edges

TITLE = (56, 8, 325, 38)
SLOTS = [(22, 50, 186, 168), (195, 50, 359, 168), (22, 178, 186, 296), (195, 178, 359, 296)]
SLOT_RADIUS = 20
DISC_RADIUS = 15.5
DISC_INSET = 17

LINE = 1.7  # half the gold line's width
RIM = 1.3  # the dark rim around it
GOLD_MIDDLE = np.array([255, 224, 140], float)
GOLD_EDGE = np.array([172, 90, 16], float)
RIM_COLOR = np.array([34, 8, 0], float)
FILL_TOP = np.array([54, 41, 47], float)
FILL_BOTTOM = np.array([122, 100, 100], float)
DISC_TOP = np.array([26, 20, 24], float)
DISC_BOTTOM = np.array([66, 52, 56], float)

# Square, Triangle, Cross, Circle.
GLYPH_COLORS = [(240, 118, 196), (80, 214, 156), (132, 164, 248), (248, 98, 110)]
GLYPH_LINE = 1.5

ys, xs = np.mgrid[0:HEIGHT * SCALE, 0:WIDTH * SCALE].astype(np.float32)
xs = (xs + 0.5) / SCALE
ys = (ys + 0.5) / SCALE

color = np.zeros((HEIGHT * SCALE, WIDTH * SCALE, 3), np.float32)
alpha = np.zeros((HEIGHT * SCALE, WIDTH * SCALE), np.float32)


def coverage(d):
    # Signed distance in panel pixels to the fraction covered, over one drawn pixel.
    return np.clip(0.5 - d * SCALE, 0.0, 1.0)


def paint(c, a):
    global color, alpha
    a = a[..., None] if a.ndim == 2 else a
    c = np.broadcast_to(c, color.shape)
    color = c * a + color * (1 - a)
    alpha[:] = a[..., 0] + alpha * (1 - a[..., 0])


def rounded_rect(x0, y0, x1, y1, r):
    cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    qx = np.abs(xs - cx) - ((x1 - x0) / 2 - r)
    qy = np.abs(ys - cy) - ((y1 - y0) / 2 - r)
    return np.hypot(np.maximum(qx, 0), np.maximum(qy, 0)) + np.minimum(np.maximum(qx, qy), 0) - r


def circle(cx, cy, r):
    return np.hypot(xs - cx, ys - cy) - r


def segment(ax, ay, bx, by):
    px, py = xs - ax, ys - ay
    dx, dy = bx - ax, by - ay
    t = np.clip((px * dx + py * dy) / (dx * dx + dy * dy), 0, 1)
    return np.hypot(px - t * dx, py - t * dy)


def polyline(points):
    d = None
    for (ax, ay), (bx, by) in zip(points, points[1:]):
        s = segment(ax, ay, bx, by)
        d = s if d is None else np.minimum(d, s)
    return d


def gradient(top, bottom, y0, y1):
    t = np.clip((ys - y0) / (y1 - y0), 0, 1)[..., None]
    return top + (bottom - top) * t


def gold_line(distance):
    # distance: unsigned distance to the line's middle.
    paint(RIM_COLOR, coverage(distance - LINE - RIM) * 0.85)
    t = np.clip(distance / LINE, 0, 1)[..., None]
    paint(GOLD_MIDDLE + (GOLD_EDGE - GOLD_MIDDLE) * t ** 1.2, coverage(distance - LINE))


def shape(d, top, bottom, y0, y1):
    paint(RIM_COLOR, coverage(d - LINE - RIM) * 0.85)
    paint(gradient(top, bottom, y0, y1), coverage(d))
    gold_line(np.abs(d))


def curl(x, y, side):
    # A small scroll at the end of a bar, as on the active item board: a spiral turning inwards.
    points = []
    for i in range(40):
        a = i / 39 * 1.7 * math.pi
        r = 7.5 * (1 - i / 39 * 0.6)
        points.append((x + side * (r * math.cos(a + math.pi / 2) * -1), y - 7.5 + r * math.sin(a + math.pi / 2)))
    return polyline(points)


def glyph(slot, cx, cy):
    if slot == 0:
        d = np.abs(rounded_rect(cx - 6, cy - 6, cx + 6, cy + 6, 0.5))
    elif slot == 1:
        h = 7.5
        corners = [(cx, cy - h), (cx + h * 0.95, cy + h * 0.65), (cx - h * 0.95, cy + h * 0.65), (cx, cy - h)]
        d = polyline(corners)
    elif slot == 2:
        d = np.minimum(segment(cx - 6, cy - 6, cx + 6, cy + 6), segment(cx - 6, cy + 6, cx + 6, cy - 6))
    else:
        d = np.abs(circle(cx, cy, 6.5))
    glow = np.array(GLYPH_COLORS[slot], float)
    paint(glow, coverage(d - GLYPH_LINE - 1.5) * 0.25)
    paint(glow, coverage(d - GLYPH_LINE))


def main() -> None:
    # The joints holding the pieces together, under them: short bars like those between the board's circles.
    tx0, ty0, tx1, ty1 = TITLE
    joints = [(98, ty1 - 4, 110, SLOTS[0][1] + 4), (271, ty1 - 4, 283, SLOTS[1][1] + 4),
              (98, SLOTS[0][3] - 4, 110, SLOTS[2][1] + 4), (271, SLOTS[1][3] - 4, 283, SLOTS[3][1] + 4),
              (SLOTS[0][2] - 4, 103, SLOTS[1][0] + 4, 115), (SLOTS[2][2] - 4, 231, SLOTS[3][0] + 4, 243)]
    for x0, y0, x1, y1 in joints:
        shape(rounded_rect(x0, y0, x1, y1, 2), FILL_TOP, FILL_BOTTOM, y0, y1)

    for slot, (x0, y0, x1, y1) in enumerate(SLOTS):
        shape(rounded_rect(x0, y0, x1, y1, SLOT_RADIUS), FILL_TOP, FILL_BOTTOM, y0, y1)
    for slot, (x0, y0, x1, y1) in enumerate(SLOTS):
        cx, cy = x0 + DISC_INSET, y0 + DISC_INSET
        shape(circle(cx, cy, DISC_RADIUS), DISC_TOP, DISC_BOTTOM, cy - DISC_RADIUS, cy + DISC_RADIUS)
        glyph(slot, cx, cy)

    shape(rounded_rect(tx0, ty0, tx1, ty1, (ty1 - ty0) / 2), FILL_TOP, FILL_BOTTOM, ty0, ty1)
    gold_line(curl(tx0 - 1, ty1, -1))
    gold_line(curl(tx1 + 1, ty1, 1))

    # Shrink to the panel's size, averaging the colours by their coverage.
    premultiplied = np.dstack([color * alpha[..., None], alpha])
    small = premultiplied.reshape(HEIGHT, SCALE, WIDTH, SCALE, 4).mean(axis=(1, 3))
    a = small[..., 3:]
    rgb = np.where(a > 0, small[..., :3] / np.maximum(a, 1e-6), 0)
    out = np.dstack([rgb, a * 255]).round().clip(0, 255).astype(np.uint8)
    Image.fromarray(out, "RGBA").save(sys.argv[1], optimize=True)


if __name__ == "__main__":
    main()
