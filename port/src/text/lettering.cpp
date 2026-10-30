#include "text/lettering.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <limits>
#include <map>
#include <string>
#include <tuple>
#include <vector>

#include "mg_drawprim.hpp"
#include "platform/ttffont.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "text/outline.hpp"

namespace dc2::text {
namespace {

constexpr char32_t kReplacement = 0xFFFD;
constexpr int      kShiftSteps = 4; // the text is drawn at a quarter-pixel pen; its baseline at a whole pixel

struct Image {
    gfx::TextureHandle texture = gfx::kNullTexture;
    int                width = 0, height = 0, x0 = 0, y0 = 0; // y0 from the baseline, x0 from the pen's pixel
    int                ink_left = 0, ink_right = 0;           // the fill's columns, from the pen's pixel
    int                used = 0;
};

// Style, text, em across and down in 1/16 px, pen shift, and target pixels to a texel across and down in 1/16.
using ImageKey = std::tuple<const LetteringStyle *, std::string, int, int, int, int, int>;

// The text lettered in its style: its fill over the dark of its rim and shadow, as one image whose colours are the
// painting's, so the draw's colour and fades tint it as they tinted the painting.
const Image *GetImage(const ttffont::Face &face, const ImageKey &key) {
    static std::map<ImageKey, Image> cache;
    const int                        frame = mgPortFrameCount();
    if (const auto found = cache.find(key); found != cache.end()) {
        found->second.used = frame;
        return found->second.texture == gfx::kNullTexture ? nullptr : &found->second;
    }
    // A screenful of words at the sizes the window has had; past that, those drawn longest ago go.
    while (cache.size() >= 128) {
        auto oldest = std::ranges::min_element(cache, {}, [](const auto &entry) { return entry.second.used; });
        if (oldest->second.used == frame) {
            break;
        }
        gfx::DestroyTexture(oldest->second.texture);
        cache.erase(oldest);
    }
    const auto &[style_ptr, text, em_x16, em_y16, shift, texel_x16, texel_y16] = key;
    const LetteringStyle &style = *style_ptr;
    const float           em_x = em_x16 / 16.0f;
    const float           em_y = em_y16 / 16.0f;
    const float           texel_x = texel_x16 / 16.0f;
    const float           texel_y = texel_y16 / 16.0f;
    Image                 image;

    struct Glyph {
        std::vector<unsigned char> alpha;
        int                        w = 0, h = 0, x0 = 0, y0 = 0;
    };

    std::vector<Glyph> glyphs;
    float              pen = static_cast<float>(shift) / kShiftSteps;
    int                left = std::numeric_limits<int>::max();
    int                top = std::numeric_limits<int>::max();
    int                right = std::numeric_limits<int>::min();
    int                bottom = std::numeric_limits<int>::min();
    for (std::size_t at = 0; at < text.size();) {
        const char32_t c = NextCharacter(text, at);
        const float    whole = std::floor(pen);
        const float    fraction = std::min(static_cast<float>(kShiftSteps - 1) / kShiftSteps,
                                           std::floor((pen - whole) * kShiftSteps) / kShiftSteps);
        Glyph          glyph;
        if (face.RenderGlyph(c, em_x, em_y, fraction, 0.0f, glyph.alpha, glyph.w, glyph.h, glyph.x0, glyph.y0) &&
            glyph.w > 0 && glyph.h > 0) {
            glyph.x0 += static_cast<int>(whole);
            left = std::min(left, glyph.x0);
            top = std::min(top, glyph.y0);
            right = std::max(right, glyph.x0 + glyph.w);
            bottom = std::max(bottom, glyph.y0 + glyph.h);
            glyphs.push_back(std::move(glyph));
        }
        float advance = 0.0f;
        face.GetAdvance(c, advance);
        pen += advance * em_x;
    }
    if (glyphs.empty()) {
        cache.emplace(key, image);
        return nullptr;
    }
    const int                 w = right - left;
    const int                 h = bottom - top;
    std::vector<std::uint8_t> fill(static_cast<std::size_t>(w) * h, 0);
    for (const Glyph &glyph : glyphs) {
        for (int row = 0; row < glyph.h; ++row) {
            for (int col = 0; col < glyph.w; ++col) {
                auto &to = fill[static_cast<std::size_t>(glyph.y0 - top + row) * w + glyph.x0 - left + col];
                to = std::max(to, glyph.alpha[static_cast<std::size_t>(row) * glyph.w + col]);
            }
        }
    }
    // The dark behind the fill: its rim (or, without one, the fill itself) and that again moved as its shadow.
    OutlineImage dark;
    if (style.rim > 0.0f) {
        dark = OutlineRimOf(fill, w, h, texel_x, texel_y, style.rim);
    } else {
        dark.alpha = fill;
    }
    const int dark_w = w + 2 * dark.margin_x;
    const int dark_h = h + 2 * dark.margin_y;
    const int shadow_x = static_cast<int>(std::lround(style.shadow_x * texel_x));
    const int shadow_y = static_cast<int>(std::lround(style.shadow_y * texel_y));
    image.width = dark_w + shadow_x;
    image.height = dark_h + shadow_y;
    image.x0 = left - dark.margin_x;
    image.y0 = top - dark.margin_y;
    image.ink_left = left;
    image.ink_right = right;
    auto dark_at = [&](int x, int y) -> float {
        return x < 0 || y < 0 || x >= dark_w || y >= dark_h ? 0.0f : dark.alpha[static_cast<std::size_t>(y) * dark_w + x] / 255.0f;
    };
    // The shadow fades with its distance (in texels) past the rim, over the length it is cast.
    const std::vector<float> distance =
        style.shadow_floor < 1.0f ? OutlineDistance(fill, w, h, texel_x, texel_y, dark.margin_x, dark.margin_y, image.width, image.height)
                                  : std::vector<float>{};
    const float cast = std::hypot(style.shadow_x, style.shadow_y);
    auto        shadow_at = [&](int x, int y) {
        if (shadow_x == 0 && shadow_y == 0) {
            return 0.0f;
        }
        float s = dark_at(x - shadow_x, y - shadow_y);
        if (!distance.empty() && s > 0.0f) {
            const float past = std::clamp((distance[static_cast<std::size_t>(y) * image.width + x] - style.rim) / cast, 0.0f, 1.0f);
            s *= 1.0f - (1.0f - style.shadow_floor) * past;
        }
        return s;
    };
    // White text in the message painter is tinted by the draw's colour; here the colours are the painting's, and
    // the draw's colour tints them the same way (0x80 leaves them as they are).
    std::vector<std::uint8_t> rgba(static_cast<std::size_t>(image.width + 2) * (image.height + 2) * 4, 0);
    for (int y = 0; y < image.height; ++y) {
        for (int x = 0; x < image.width; ++x) {
            const int   fx = x - dark.margin_x;
            const int   fy = y - dark.margin_y;
            const float f = fx < 0 || fy < 0 || fx >= w || fy >= h ? 0.0f : fill[static_cast<std::size_t>(fy) * w + fx] / 255.0f;
            const float d = std::max(style.rim > 0.0f ? dark_at(x, y) : 0.0f, shadow_at(x, y));
            const float a = f + d * (1.0f - f);
            if (a <= 0.0f) {
                continue;
            }
            auto *texel = &rgba[(static_cast<std::size_t>(y + 1) * (image.width + 2) + x + 1) * 4];
            for (int channel = 0; channel < 3; ++channel) {
                texel[channel] = static_cast<std::uint8_t>(std::lround((style.fill * f + style.dark[channel] * d * (1.0f - f)) / a));
            }
            texel[3] = static_cast<std::uint8_t>(std::lround(a * 255.0f));
        }
    }
    gfx::TextureDesc desc;
    desc.width = static_cast<std::uint32_t>(image.width + 2);
    desc.height = static_cast<std::uint32_t>(image.height + 2);
    image.texture = gfx::CreateTexture(desc);
    if (image.texture == gfx::kNullTexture) {
        return nullptr;
    }
    gfx::UpdateTextureNow(image.texture, 0, 0, 0, desc.width, desc.height, rgba.data());
    image.used = frame;
    return &cache.insert_or_assign(key, image).first->second;
}

} // namespace

char32_t NextCharacter(std::string_view text, std::size_t &at) {
    const auto lead = static_cast<unsigned char>(text[at++]);
    if (lead < 0x80) {
        return lead;
    }

    // The continuation bytes a lead byte takes, the payload bits it holds, and the least character it may encode.
    struct Lead {
        int      trail;
        char32_t bits;
        char32_t least;
    };

    Lead form{};
    if (lead >= 0xC2 && lead < 0xE0) {
        form = {.trail = 1, .bits = lead & 0x1Fu, .least = 0x80};
    } else if (lead >= 0xE0 && lead < 0xF0) {
        form = {.trail = 2, .bits = lead & 0x0Fu, .least = 0x800};
    } else if (lead >= 0xF0 && lead < 0xF5) {
        form = {.trail = 3, .bits = lead & 0x07u, .least = 0x10000};
    } else {
        return kReplacement;
    }
    if (at + static_cast<std::size_t>(form.trail) > text.size()) {
        return kReplacement;
    }
    char32_t c = form.bits;
    for (int i = 0; i < form.trail; ++i) {
        const auto next = static_cast<unsigned char>(text[at + static_cast<std::size_t>(i)]);
        if ((next & 0xC0) != 0x80) {
            return kReplacement;
        }
        c = (c << 6) | (next & 0x3Fu);
    }
    if (c < form.least || c > 0x10FFFF || (c >= 0xD800 && c < 0xE000)) {
        return kReplacement;
    }
    at += static_cast<std::size_t>(form.trail);
    return c;
}

float LetteringAdvance(dc2::font::Typeface typeface, std::string_view text) {
    const ttffont::Face *face = dc2::font::FaceOf(typeface);
    float                total = 0.0f;
    for (std::size_t at = 0; face && at < text.size();) {
        float advance = 0.0f;
        if (face->GetAdvance(NextCharacter(text, at), advance)) {
            total += advance;
        }
    }
    return total;
}

bool DrawLettering(mgCDrawPrim &prim, const LetteringStyle &style, std::string_view text, float x, float base_y,
                   float em_x, float em_y, float texel_x, float texel_y, LetteringAlign align) {
    const ttffont::Face *face = dc2::font::FaceOf(style.typeface);
    if (!face || text.empty() || !(em_x > 0) || !(em_y > 0) || !(texel_x > 0) || !(texel_y > 0)) {
        return false;
    }
    const float pen_x = align == LetteringAlign::Pen ? x : x - LetteringAdvance(style.typeface, text) * em_x * texel_x / 2;

    const std::uint8_t  none[4] = {};
    const gfx::Vertex2D origin = mgPortPrimVertex(prim, pen_x, base_y, 0, 0, 0, none);
    const gfx::Vertex2D step = mgPortPrimVertex(prim, pen_x + 1, base_y + 1, 0, 0, 0, none);
    const auto          mapping = gfx::GetUiMapping(mgPortCurrentTarget());
    const float         px_x = (step.x - origin.x) * mapping.scale_x; // target pixels a logical pixel
    const float         px_y = (step.y - origin.y) * mapping.scale_y;
    float               pen_px = origin.x * mapping.scale_x + mapping.offset_x;
    const float         base_px = std::round(origin.y * mapping.scale_y + mapping.offset_y);
    if (!std::isfinite(pen_px) || !std::isfinite(base_px) || !(px_x > 0) || !(px_y > 0)) {
        return false;
    }
    const auto key_of = [&](float pen) {
        const int shift = std::min(kShiftSteps - 1, static_cast<int>((pen - std::floor(pen)) * kShiftSteps));
        return ImageKey{&style, std::string(text), static_cast<int>(std::lround(em_x * texel_x * px_x * 16)),
                        static_cast<int>(std::lround(em_y * texel_y * px_y * 16)), shift,
                        static_cast<int>(std::lround(texel_x * px_x * 16)), static_cast<int>(std::lround(texel_y * px_y * 16))};
    };
    const Image *image = GetImage(*face, key_of(pen_px));
    if (image && align == LetteringAlign::InkCentre) {
        // The advances centred the pen; the ink's own bearings move it the rest of the way.
        const float centre_px = (x - pen_x) * px_x + pen_px;
        pen_px += centre_px - (std::floor(pen_px) + (image->ink_left + image->ink_right) / 2.0f);
        image = GetImage(*face, key_of(pen_px));
    }
    if (!image) {
        return false;
    }
    std::uint8_t color[4];
    mgPortPrimColor(prim, color);
    // The image sits on whole target pixels, so each texel lands on one pixel and nothing is resampled.
    auto vertex = [&](float vx, float vy, float u, float v) {
        gfx::Vertex2D out = origin;
        out.x = (vx - mapping.offset_x) / mapping.scale_x;
        out.y = (vy - mapping.offset_y) / mapping.scale_y;
        out.u = u;
        out.v = v;
        std::copy(color, color + 4, out.color);
        return out;
    };
    const float                        left = std::floor(pen_px) + static_cast<float>(image->x0 - 1);
    const float                        top = base_px + static_cast<float>(image->y0 - 1);
    const auto                         w = static_cast<float>(image->width + 2);
    const auto                         h = static_cast<float>(image->height + 2);
    const std::array<gfx::Vertex2D, 4> quad = {vertex(left, top, 0, 0), vertex(left + w, top, w, 0),
                                               vertex(left + w, top + h, w, h), vertex(left, top + h, 0, h)};
    gfx::TextureBinding                binding;
    binding.texture = image->texture;
    binding.filter = gfx::Filter::Linear;
    mgPortPrimSubmitTexture(prim, quad, binding);
    return true;
}

} // namespace dc2::text
