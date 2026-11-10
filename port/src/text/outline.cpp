#include "text/outline.hpp"

#include <algorithm>
#include <cmath>

namespace dc2::text {
namespace {

// Measured against retail's copies at 8x (docs/PC.md "Message font"): the rim radius whose ink equals
// theirs, with a half-pixel soft edge, and for the faint wide style a glow fading out at 2.5 pixels.
constexpr float kFeather = 0.5f;
constexpr float kThinRadius = 0.85f;
constexpr float kThickRadius = 1.67f;
constexpr float kGlowReach = 2.5f;
constexpr float kGlowAlpha = 0.312f;

// Squared distance along one line to the nearest zero of f, samples `spacing` apart (Felzenszwalb and
// Huttenlocher's lower envelope of parabolas). f holds 0 inside and kOutside elsewhere; doubles keep the
// envelope exact where kOutside dwarfs the distances.
constexpr double kOutside = 1e12;

void Distance1D(std::span<const double> f, double spacing, std::vector<double> &out, std::vector<int> &v,
                std::vector<double> &z) {
    const int n = static_cast<int>(f.size());
    out.resize(n);
    v.resize(n);
    z.resize(n + 1);
    auto position = [&](int q) { return static_cast<double>(q) * spacing; };
    auto meet = [&](int q, int r) {
        const double p = position(q);
        const double s = position(r);
        return ((f[q] + p * p) - (f[r] + s * s)) / (2.0 * (p - s));
    };
    int k = 0;
    v[0] = 0;
    z[0] = -1e300;
    z[1] = 1e300;
    for (int q = 1; q < n; ++q) {
        double s = meet(q, v[k]);
        while (s <= z[k]) {
            --k;
            s = meet(q, v[k]);
        }
        ++k;
        v[k] = q;
        z[k] = s;
        z[k + 1] = 1e300;
    }
    k = 0;
    for (int q = 0; q < n; ++q) {
        while (z[k + 1] < position(q)) {
            ++k;
        }
        const double d = position(q) - position(v[k]);
        out[q] = d * d + f[v[k]];
    }
}

// Each pixel of a w x h image's distance in logical pixels from the glyph's edge, the glyph's coverage (width x
// height) sitting margin_x, margin_y in from its corner; 0 inside the glyph.
std::vector<float> Distances(std::span<const std::uint8_t> coverage, int width, int height, float px_x, float px_y,
                             int margin_x, int margin_y, int w, int h) {
    // The glyph is the pixels at least half covered; distances run in logical pixels.
    std::vector<double> field(static_cast<std::size_t>(w) * h, kOutside);
    for (int row = 0; row < height; ++row) {
        for (int col = 0; col < width; ++col) {
            if (coverage[static_cast<std::size_t>(row) * width + col] >= 128) {
                field[static_cast<std::size_t>(row + margin_y) * w + col + margin_x] = 0.0;
            }
        }
    }
    std::vector<double> line;
    std::vector<double> out;
    std::vector<double> z;
    std::vector<int>    v;
    for (int row = 0; row < h; ++row) {
        line.assign(field.begin() + static_cast<std::ptrdiff_t>(row) * w, field.begin() + static_cast<std::ptrdiff_t>(row + 1) * w);
        Distance1D(line, 1.0 / px_x, out, v, z);
        std::ranges::copy(out, field.begin() + static_cast<std::ptrdiff_t>(row) * w);
    }
    line.resize(h);
    for (int col = 0; col < w; ++col) {
        for (int row = 0; row < h; ++row) {
            line[row] = field[static_cast<std::size_t>(row) * w + col];
        }
        Distance1D(line, 1.0 / px_y, out, v, z);
        for (int row = 0; row < h; ++row) {
            field[static_cast<std::size_t>(row) * w + col] = out[row];
        }
    }
    // A pixel centre half a pixel inside the glyph's edge is what the transform calls zero.
    const float        half_pixel = 0.5f / std::sqrt(px_x * px_y);
    std::vector<float> distance(field.size());
    for (std::size_t at = 0; at < field.size(); ++at) {
        distance[at] = std::max(0.0f, static_cast<float>(std::sqrt(field[at])) - half_pixel);
    }
    return distance;
}

template <typename Opacity>
OutlineImage Rim(std::span<const std::uint8_t> coverage, int width, int height, float px_x, float px_y, float reach,
                 Opacity opacity) {
    OutlineImage image;
    if (width <= 0 || height <= 0 || !(px_x > 0.0f) || !(px_y > 0.0f) ||
        coverage.size() < static_cast<std::size_t>(width) * height) {
        return image;
    }
    image.margin_x = static_cast<int>(std::ceil(reach * px_x)) + 1;
    image.margin_y = static_cast<int>(std::ceil(reach * px_y)) + 1;
    const int                w = width + 2 * image.margin_x;
    const int                h = height + 2 * image.margin_y;
    const std::vector<float> distance = Distances(coverage, width, height, px_x, px_y, image.margin_x, image.margin_y, w, h);
    image.alpha.assign(static_cast<std::size_t>(w) * h, 0);
    for (int row = 0; row < h; ++row) {
        for (int col = 0; col < w; ++col) {
            const std::size_t at = static_cast<std::size_t>(row) * w + col;
            float             a = opacity(distance[at]);
            const int         gx = col - image.margin_x;
            const int         gy = row - image.margin_y;
            if (gx >= 0 && gx < width && gy >= 0 && gy < height) {
                a = std::max(a, coverage[static_cast<std::size_t>(gy) * width + gx] / 255.0f);
            }
            image.alpha[at] = static_cast<std::uint8_t>(std::lround(a * 255.0f));
        }
    }
    return image;
}

} // namespace

float OutlineOpacity(Outline outline, float distance) {
    switch (outline) {
        case Outline::Thin:
            return std::clamp((kThinRadius + kFeather / 2 - distance) / kFeather, 0.0f, 1.0f);
        case Outline::Thick:
            return std::clamp((kThickRadius + kFeather / 2 - distance) / kFeather, 0.0f, 1.0f);
        case Outline::Glow:
            return std::clamp(1.0f - distance / kGlowReach, 0.0f, 1.0f);
    }
    return 0.0f;
}

float OutlineReach(Outline outline) {
    switch (outline) {
        case Outline::Thin:
            return kThinRadius + kFeather / 2;
        case Outline::Thick:
            return kThickRadius + kFeather / 2;
        case Outline::Glow:
            return kGlowReach;
    }
    return 0.0f;
}

float OutlineAlpha(Outline outline) { return outline == Outline::Glow ? kGlowAlpha : 1.0f; }

OutlineImage OutlineRim(std::span<const std::uint8_t> coverage, int width, int height, float px_x, float px_y,
                        Outline outline) {
    return Rim(coverage, width, height, px_x, px_y, OutlineReach(outline),
               [outline](float d) { return OutlineOpacity(outline, d); });
}

OutlineImage OutlineRimOf(std::span<const std::uint8_t> coverage, int width, int height, float px_x, float px_y,
                          float radius) {
    return Rim(coverage, width, height, px_x, px_y, radius + kFeather / 2,
               [radius](float d) { return std::clamp((radius + kFeather / 2 - d) / kFeather, 0.0f, 1.0f); });
}

std::vector<float> OutlineDistance(std::span<const std::uint8_t> coverage, int width, int height, float px_x,
                                   float px_y, int margin_x, int margin_y, int image_width, int image_height) {
    if (width <= 0 || height <= 0 || !(px_x > 0.0f) || !(px_y > 0.0f) ||
        coverage.size() < static_cast<std::size_t>(width) * height || margin_x < 0 || margin_y < 0 ||
        image_width < width + margin_x || image_height < height + margin_y) {
        return {};
    }
    return Distances(coverage, width, height, px_x, px_y, margin_x, margin_y, image_width, image_height);
}

} // namespace dc2::text
