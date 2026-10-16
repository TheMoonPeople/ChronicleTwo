#include "quick_loadout_art.hpp"

#include <algorithm>
#include <cmath>
#include <vector>

namespace {

struct Color {
    float r, g, b, a;
};

Color Rgb(int r, int g, int b, float a = 1.0f) { return {r / 255.0f, g / 255.0f, b / 255.0f, a}; }

Color Mix(const Color &from, const Color &to, float t) {
    t = std::clamp(t, 0.0f, 1.0f);
    return {from.r + (to.r - from.r) * t, from.g + (to.g - from.g) * t, from.b + (to.b - from.b) * t,
            from.a + (to.a - from.a) * t};
}

float Length(float x, float y) { return std::sqrt(x * x + y * y); }

// Signed distances in board units, negative inside.
float RoundRect(float x, float y, float x0, float y0, float x1, float y1, float r) {
    const float cx = (x0 + x1) * 0.5f, cy = (y0 + y1) * 0.5f;
    const float qx = std::fabs(x - cx) - ((x1 - x0) * 0.5f - r);
    const float qy = std::fabs(y - cy) - ((y1 - y0) * 0.5f - r);
    return Length(std::max(qx, 0.0f), std::max(qy, 0.0f)) + std::min(std::max(qx, qy), 0.0f) - r;
}

float Circle(float x, float y, float cx, float cy, float r) { return Length(x - cx, y - cy) - r; }

float Segment(float x, float y, float ax, float ay, float bx, float by) {
    const float px = x - ax, py = y - ay, dx = bx - ax, dy = by - ay;
    const float len2 = dx * dx + dy * dy;
    const float t = len2 > 0.0f ? std::clamp((px * dx + py * dy) / len2, 0.0f, 1.0f) : 0.0f;
    return Length(px - dx * t, py - dy * t);
}

struct Point {
    float x, y;
};
using Stroke = std::vector<Point>;

float StrokeDistance(const std::vector<Stroke> &strokes, float x, float y) {
    float best = 1e9f;
    for (const Stroke &stroke : strokes) {
        for (size_t i = 0; i + 1 < stroke.size(); i++) {
            best = std::min(best, Segment(x, y, stroke[i].x, stroke[i].y, stroke[i + 1].x, stroke[i + 1].y));
        }
    }
    return best;
}

class Canvas {
  public:
    Canvas(int scale)
        : scale_(static_cast<float>(scale)), width_(static_cast<int>(kQuickLoadoutArtWidth) * scale),
          height_(static_cast<int>(kQuickLoadoutArtHeight) * scale), pixels_(static_cast<size_t>(width_ * height_)) {}

    // Paints the shape whose distance sdf gives, within the box, with the colour paint gives at each point (and the
    // distance there); the edge is smoothed over a pixel.
    template <class Sdf, class Paint>
    void Fill(float bx0, float by0, float bx1, float by1, Sdf sdf, Paint paint) {
        const int i0 = std::max(0, static_cast<int>(std::floor(bx0 * scale_)) - 1);
        const int j0 = std::max(0, static_cast<int>(std::floor(by0 * scale_)) - 1);
        const int i1 = std::min(width_, static_cast<int>(std::ceil(bx1 * scale_)) + 1);
        const int j1 = std::min(height_, static_cast<int>(std::ceil(by1 * scale_)) + 1);
        for (int j = j0; j < j1; j++) {
            for (int i = i0; i < i1; i++) {
                const float x = (i + 0.5f) / scale_, y = (j + 0.5f) / scale_;
                const float d = sdf(x, y);
                const float cover = std::clamp(0.5f - d * scale_, 0.0f, 1.0f);
                if (cover <= 0.0f) {
                    continue;
                }
                const Color src = paint(x, y, d);
                const float a = src.a * cover;
                Color      &dst = pixels_[static_cast<size_t>(j * width_ + i)];
                dst.r = src.r * a + dst.r * (1.0f - a); // premultiplied
                dst.g = src.g * a + dst.g * (1.0f - a);
                dst.b = src.b * a + dst.b * (1.0f - a);
                dst.a = a + dst.a * (1.0f - a);
            }
        }
    }

    QuickLoadoutArt Finish() const {
        QuickLoadoutArt art;
        art.width = width_;
        art.height = height_;
        art.rgba.resize(pixels_.size() * 4);
        for (size_t n = 0; n < pixels_.size(); n++) {
            const Color &c = pixels_[n];
            const float  inv = c.a > 0.0f ? 1.0f / c.a : 0.0f;
            art.rgba[n * 4 + 0] = static_cast<uint8_t>(std::lround(std::clamp(c.r * inv, 0.0f, 1.0f) * 255.0f));
            art.rgba[n * 4 + 1] = static_cast<uint8_t>(std::lround(std::clamp(c.g * inv, 0.0f, 1.0f) * 255.0f));
            art.rgba[n * 4 + 2] = static_cast<uint8_t>(std::lround(std::clamp(c.b * inv, 0.0f, 1.0f) * 255.0f));
            art.rgba[n * 4 + 3] = static_cast<uint8_t>(std::lround(std::clamp(c.a, 0.0f, 1.0f) * 255.0f));
        }
        return art;
    }

  private:
    float              scale_;
    int                width_, height_;
    std::vector<Color> pixels_;
};

// Copper, lit from above: a dark rim on the edges, a bright line inside it and a warm gradient from top to bottom.
// depth is how far the point is inside the shape; y0, y1 the shape's top and bottom.
Color Copper(float y, float depth, float y0, float y1) {
    const Color top = Rgb(246, 168, 62), bottom = Rgb(168, 94, 30);
    Color       c = Mix(top, bottom, (y - y0) / (y1 - y0));
    if (depth < 2.6f) {
        c = Mix(Rgb(255, 214, 140), c, (depth - 1.4f) / 1.4f);
    }
    if (depth < 1.5f) {
        c = Mix(Rgb(64, 34, 12), c, (depth - 0.5f) / 1.0f);
    }
    return c;
}

// A copper ring between outer and inner (inner's distance is negative inside the hole).
template <class Outer, class Inner>
void CopperRing(Canvas &canvas, float x0, float y0, float x1, float y1, Outer outer, Inner inner) {
    canvas.Fill(
        x0, y0, x1, y1, [&](float x, float y) { return std::max(outer(x, y), -inner(x, y)); },
        [&](float, float y, float d) { return Copper(y, -d, y0, y1); });
}

void Bolt(Canvas &canvas, float cx, float cy) {
    const float r = 7.0f;
    canvas.Fill(
        cx - r, cy - r, cx + r, cy + r, [&](float x, float y) { return Circle(x, y, cx, cy, r); },
        [&](float x, float y, float d) {
            const float light = std::clamp(1.0f - Length(x - (cx - 2.2f), y - (cy - 2.4f)) / 6.5f, 0.0f, 1.0f);
            Color       c = Mix(Rgb(52, 52, 58), Rgb(205, 205, 215), light * light);
            return d > -1.1f ? Mix(Rgb(24, 20, 18), c, -d / 1.1f) : c;
        });
}

// The disc behind a face button's symbol, in a slot's top left corner.
void Disc(Canvas &canvas, float cx, float cy) {
    const float r = 25.0f, hole = 20.0f;
    CopperRing(
        canvas, cx - r, cy - r, cx + r, cy + r, [&](float x, float y) { return Circle(x, y, cx, cy, r); },
        [&](float x, float y) { return Circle(x, y, cx, cy, hole); });
    canvas.Fill(
        cx - hole, cy - hole, cx + hole, cy + hole, [&](float x, float y) { return Circle(x, y, cx, cy, hole); },
        [&](float x, float y, float d) {
            const Color c = Mix(Rgb(30, 25, 25), Rgb(64, 56, 56), 1.0f - Length(x - cx, y - (cy - 4.0f)) / hole);
            return d > -2.0f ? Mix(Rgb(16, 12, 10), c, -d / 2.0f) : c;
        });
}

// A face button's symbol in its colour, drawn as strokes about (cx, cy): 0 Triangle, 1 Square, 2 Cross, 3 Circle.
void Symbol(Canvas &canvas, int slot, float cx, float cy) {
    static const Color kColor[4] = {Rgb(64, 226, 160), Rgb(232, 120, 216), Rgb(112, 160, 244), Rgb(244, 98, 98)};
    std::vector<Stroke> strokes;
    float               ring = -1.0f; // the circle's radius
    switch (slot) {
    case 0:
        strokes.push_back({{cx, cy - 10.0f}, {cx + 10.0f, cy + 7.0f}, {cx - 10.0f, cy + 7.0f}, {cx, cy - 10.0f}});
        break;
    case 1:
        strokes.push_back({{cx - 8.5f, cy - 8.5f},
                           {cx + 8.5f, cy - 8.5f},
                           {cx + 8.5f, cy + 8.5f},
                           {cx - 8.5f, cy + 8.5f},
                           {cx - 8.5f, cy - 8.5f}});
        break;
    case 2:
        strokes.push_back({{cx - 9.0f, cy - 9.0f}, {cx + 9.0f, cy + 9.0f}});
        strokes.push_back({{cx + 9.0f, cy - 9.0f}, {cx - 9.0f, cy + 9.0f}});
        break;
    default:
        ring = 9.5f;
        break;
    }
    const float width = 2.2f;
    auto        distance = [&](float x, float y) {
        return ring > 0.0f ? std::fabs(Length(x - cx, y - cy) - ring) : StrokeDistance(strokes, x, y);
    };
    const Color color = kColor[slot];
    // A soft glow of the colour, then the stroke itself with a lighter core.
    canvas.Fill(
        cx - 16, cy - 16, cx + 16, cy + 16, [&](float x, float y) { return distance(x, y) - width - 2.5f; },
        [&](float, float, float d) { return Color{color.r, color.g, color.b, 0.25f * std::clamp(-d / 2.5f, 0.0f, 1.0f)}; });
    canvas.Fill(
        cx - 16, cy - 16, cx + 16, cy + 16, [&](float x, float y) { return distance(x, y) - width; },
        [&](float, float, float d) { return Mix(color, Rgb(255, 255, 255), 0.45f * std::clamp(-d / width, 0.0f, 1.0f)); });
}

// "QUICK LOADOUT" in strokes: each letter in a box 0.7 wide and 1 tall, y down.
void Arc(Stroke &stroke, float cx, float cy, float rx, float ry, float from, float to) {
    const int steps = 18;
    for (int n = 0; n <= steps; n++) {
        const float t = (from + (to - from) * n / steps) * 3.14159265f / 180.0f;
        stroke.push_back({cx + rx * std::cos(t), cy + ry * std::sin(t)});
    }
}

std::vector<Stroke> Letter(char letter, float &advance) {
    std::vector<Stroke> strokes;
    advance = 0.7f;
    Stroke s;
    switch (letter) {
    case 'Q':
        Arc(s, 0.35f, 0.5f, 0.35f, 0.5f, 0, 360);
        strokes.push_back(s);
        strokes.push_back({{0.42f, 0.68f}, {0.74f, 1.02f}});
        break;
    case 'U':
        s.push_back({0.0f, 0.0f});
        Arc(s, 0.35f, 0.62f, 0.35f, 0.38f, 180, 0);
        s.push_back({0.7f, 0.0f});
        strokes.push_back(s);
        break;
    case 'I':
        advance = 0.12f;
        strokes.push_back({{0.06f, 0.0f}, {0.06f, 1.0f}});
        break;
    case 'C':
        Arc(s, 0.37f, 0.5f, 0.35f, 0.5f, 42, 318);
        strokes.push_back(s);
        break;
    case 'K':
        advance = 0.62f;
        strokes.push_back({{0.0f, 0.0f}, {0.0f, 1.0f}});
        strokes.push_back({{0.62f, 0.0f}, {0.0f, 0.6f}});
        strokes.push_back({{0.2f, 0.42f}, {0.64f, 1.0f}});
        break;
    case 'L':
        advance = 0.56f;
        strokes.push_back({{0.0f, 0.0f}, {0.0f, 1.0f}, {0.56f, 1.0f}});
        break;
    case 'O':
        Arc(s, 0.35f, 0.5f, 0.35f, 0.5f, 0, 360);
        strokes.push_back(s);
        break;
    case 'A':
        advance = 0.74f;
        strokes.push_back({{0.0f, 1.0f}, {0.37f, 0.0f}, {0.74f, 1.0f}});
        strokes.push_back({{0.14f, 0.66f}, {0.6f, 0.66f}});
        break;
    case 'D':
        s.push_back({0.0f, 0.0f});
        s.push_back({0.0f, 1.0f});
        s.push_back({0.28f, 1.0f});
        Arc(s, 0.28f, 0.5f, 0.42f, 0.5f, 90, -90);
        s.push_back({0.0f, 0.0f});
        strokes.push_back(s);
        break;
    case 'T':
        advance = 0.66f;
        strokes.push_back({{0.0f, 0.0f}, {0.66f, 0.0f}});
        strokes.push_back({{0.33f, 0.0f}, {0.33f, 1.0f}});
        break;
    default:
        advance = 0.45f; // space
        break;
    }
    return strokes;
}

void Title(Canvas &canvas, const char *text, float cx, float cy, float height) {
    const float gap = 0.32f;
    float       total = 0.0f;
    for (const char *c = text; *c != '\0'; c++) {
        float advance;
        Letter(*c, advance);
        total += advance + (c[1] != '\0' ? gap : 0.0f);
    }
    std::vector<Stroke> strokes;
    float               pen = cx - total * height * 0.5f;
    const float         top = cy - height * 0.5f;
    for (const char *c = text; *c != '\0'; c++) {
        float advance;
        for (Stroke &stroke : Letter(*c, advance)) {
            for (Point &p : stroke) {
                p = {pen + p.x * height, top + p.y * height};
            }
            strokes.push_back(stroke);
        }
        pen += (advance + gap) * height;
    }
    const float x0 = cx - total * height * 0.5f - 6.0f, x1 = cx + total * height * 0.5f + 6.0f;
    const float y0 = top - 6.0f, y1 = top + height + 6.0f;
    const float width = height * 0.11f, outline = 1.7f;
    canvas.Fill(
        x0, y0 + 1.2f, x1, y1 + 1.2f, [&](float x, float y) { return StrokeDistance(strokes, x, y - 1.2f) - width - outline; },
        [&](float, float, float) { return Rgb(10, 6, 4); });
    canvas.Fill(
        x0, y0, x1, y1, [&](float x, float y) { return StrokeDistance(strokes, x, y) - width; },
        [&](float, float y, float) { return Mix(Rgb(255, 255, 255), Rgb(226, 222, 214), (y - top) / height); });
}

} // namespace

QuickLoadoutArt QuickLoadoutDrawPanel(int scale) {
    Canvas canvas(scale);

    // The copper frame and its grey plate.
    const float fx0 = 4.0f, fy0 = 28.0f, fx1 = 377.0f, fy1 = 302.0f;
    canvas.Fill(
        fx0, fy0, fx1, fy1, [&](float x, float y) { return RoundRect(x, y, fx0, fy0, fx1, fy1, 16.0f); },
        [&](float, float y, float d) { return Copper(y, -d, fy0, fy1); });
    const float px0 = 13.0f, py0 = 39.0f, px1 = 368.0f, py1 = 293.0f;
    canvas.Fill(
        px0, py0, px1, py1, [&](float x, float y) { return RoundRect(x, y, px0, py0, px1, py1, 9.0f); },
        [&](float, float y, float d) {
            const Color c = Mix(Rgb(140, 140, 140), Rgb(116, 116, 116), (y - py0) / (py1 - py0));
            return d > -3.0f ? Mix(Rgb(70, 66, 62), c, -d / 3.0f) : c;
        });

    // The title tab across the top edge.
    const float tx0 = 44.0f, ty0 = 3.0f, tx1 = 337.0f, ty1 = 41.0f;
    CopperRing(
        canvas, tx0, ty0, tx1, ty1, [&](float x, float y) { return RoundRect(x, y, tx0, ty0, tx1, ty1, 13.0f); },
        [&](float x, float y) { return RoundRect(x, y, tx0 + 5.0f, ty0 + 5.0f, tx1 - 5.0f, ty1 - 5.0f, 8.0f); });
    canvas.Fill(
        tx0 + 5.0f, ty0 + 5.0f, tx1 - 5.0f, ty1 - 5.0f,
        [&](float x, float y) { return RoundRect(x, y, tx0 + 5.0f, ty0 + 5.0f, tx1 - 5.0f, ty1 - 5.0f, 8.0f); },
        [&](float, float y, float d) {
            const Color c = Mix(Rgb(92, 80, 80), Rgb(58, 49, 49), (y - ty0 - 5.0f) / (ty1 - ty0 - 10.0f));
            return d > -1.5f ? Mix(Rgb(24, 18, 16), c, -d / 1.5f) : c;
        });
    Title(canvas, "QUICK LOADOUT", (tx0 + tx1) * 0.5f, (ty0 + ty1) * 0.5f, 20.0f);

    Bolt(canvas, 17.0f, 43.0f);
    Bolt(canvas, 364.0f, 43.0f);
    Bolt(canvas, 17.0f, 290.0f);
    Bolt(canvas, 364.0f, 290.0f);

    // The slots: a copper rim round a dark brown well, and the button's disc on the top left corner.
    for (int slot = 0; slot < 4; slot++) {
        const QuickLoadoutArtRect &r = kQuickLoadoutSlotArt[slot];
        const float                rim = 5.0f;
        CopperRing(
            canvas, r.x0 - rim, r.y0 - rim, r.x1 + rim, r.y1 + rim,
            [&](float x, float y) { return RoundRect(x, y, r.x0 - rim, r.y0 - rim, r.x1 + rim, r.y1 + rim, 15.0f); },
            [&](float x, float y) { return RoundRect(x, y, r.x0, r.y0, r.x1, r.y1, 10.0f); });
        canvas.Fill(
            r.x0, r.y0, r.x1, r.y1, [&](float x, float y) { return RoundRect(x, y, r.x0, r.y0, r.x1, r.y1, 10.0f); },
            [&](float x, float y, float d) {
                // Shaded deeper along the top and left, where the rim overhangs it.
                const Color c = Mix(Rgb(76, 66, 66), Rgb(64, 54, 54), (y - r.y0) / (r.y1 - r.y0));
                const float shade = std::min({-d / 4.0f, (y - r.y0) / 7.0f + 0.3f, (x - r.x0) / 7.0f + 0.3f});
                return Mix(Rgb(40, 31, 29), c, shade);
            });
    }
    for (int slot = 0; slot < 4; slot++) {
        const QuickLoadoutArtRect &r = kQuickLoadoutSlotArt[slot];
        const float                cx = r.x0 + 22.0f, cy = r.y0 + 17.0f;
        Disc(canvas, cx, cy);
        static const int kSymbol[4] = {1, 0, 2, 3}; // the panel's Square, Triangle, Cross, Circle
        Symbol(canvas, kSymbol[slot], cx, cy);
    }
    return canvas.Finish();
}
