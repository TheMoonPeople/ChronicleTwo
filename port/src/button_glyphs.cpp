#include "button_glyphs.hpp"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <map>
#include <vector>

#include "platform/glyphs.hpp"
#include "platform/input.hpp"
#include "platform/settings.hpp"

namespace {

struct Rect {
    int x = 0;
    int y = 0;
    int w = 0;
    int h = 0;
};

using Cells = std::map<std::string, Rect, std::less<> >;

// Where the retail art keeps its PS2 symbols, in texels of the logical texture. Every language's
// gaiji sheet (meswin/<language>/gaiji.img, the message font's symbols) shares one layout; the skip
// prompt (img/<language>/skip.img) keeps its triangle in one place. glyphs.json's "targets" adds or
// moves cells without a rebuild.
const std::map<std::string, Cells, std::less<> > &BuiltinTargets() {
    static const std::map<std::string, Cells, std::less<> > targets = {
        {"gaiji",
         {
             {"select_label", {2, 2, 52, 17}},
             {"start_label", {62, 2, 44, 17}},
             {"circle", {1, 23, 20, 20}},
             {"triangle", {23, 23, 20, 20}},
             {"square", {45, 23, 20, 20}},
             {"cross", {67, 23, 20, 20}},
             {"dpad", {2, 68, 18, 18}},
             {"dpad_ud", {24, 68, 18, 18}},
             {"dpad_lr", {46, 68, 18, 18}},
             {"l2", {5, 134, 22, 17}},
             {"l1", {37, 134, 22, 17}},
             {"r1", {69, 134, 22, 17}},
             {"r2", {101, 134, 22, 17}},
             {"start", {14, 157, 24, 15}},
             {"start_label@pill", {44, 156, 45, 19}},
             {"select", {14, 179, 24, 16}},
             {"select_label@pill", {44, 177, 52, 19}},
             {"lstick", {137, 202, 26, 27}},
             {"rstick", {165, 201, 26, 28}},
         }                                       },
        {"skip",  {{"triangle", {8, 26, 20, 19}}}},
    };
    return targets;
}

struct State {
    bool                                       indexed = false;
    std::map<std::string, Cells, std::less<> > targets;
};

State &Get() {
    static State state;
    return state;
}

bool ReadRect(const nlohmann::json &value, Rect &rect) {
    if (!value.is_array() || value.size() != 4) {
        return false;
    }
    for (const auto &number : value) {
        if (!number.is_number_integer()) {
            return false;
        }
    }
    rect = {value[0].get<int>(), value[1].get<int>(), value[2].get<int>(), value[3].get<int>()};
    return rect.x >= 0 && rect.y >= 0 && rect.w > 0 && rect.h > 0;
}

/**
 * Combines retail texture cells with overrides from the shared glyph index.
 */
void Index() {
    auto &state = Get();
    if (state.indexed) {
        return;
    }
    state.indexed = true;
    state.targets = BuiltinTargets();
    for (const auto &[texture, cells] : glyphs::TargetCells().items()) {
        if (!cells.is_object()) {
            continue;
        }
        for (const auto &[glyph, value] : cells.items()) {
            Rect cell;
            if (ReadRect(value, cell)) {
                state.targets[texture][glyph] = cell;
            }
        }
    }
}

// The pad button whose binding names a keycap of the keyboard style.
const char *Action(std::string_view glyph) {
    static constexpr std::array<const char *, 12> kActions = {"cross", "circle", "square", "triangle", "l1",
                                                              "r1", "l2", "r2", "start", "select", "l3", "r3"};
    for (const char *action : kActions) {
        if (glyph == action) {
            return action;
        }
    }
    if (glyph == "start_label") {
        return "start";
    }
    if (glyph == "select_label") {
        return "select";
    }
    return nullptr;
}

// The style's symbol for a target cell, or nullptr. A target named glyph@place is a second cell of
// the same glyph. A label cell standing alone falls back to its button's symbol; one beside its
// button (@pill) does not, so the symbol is not drawn twice.
bool Symbol(const std::string &style, std::string_view target, glyphs::CpuImage &image) {
    const auto        at = target.find('@');
    const std::string glyph(target.substr(0, at));
    if (glyphs::FindNamedPixels(style.c_str(), glyph.c_str(), image)) {
        return true;
    }
    if (at == std::string_view::npos && (glyph == "start_label" || glyph == "select_label")) {
        const auto button = glyph.substr(0, glyph.find('_'));
        return glyphs::FindNamedPixels(style.c_str(), button.c_str(), image);
    }
    return false;
}

// Box-filters the symbol into the cell's physical texels, aspect kept and centred, over a cleared cell.
void Paste(const glyphs::CpuImage &image, const Rect &cell, uint32_t scale,
           datapacks::DecodedTexture &decoded, std::size_t mip) {
    const uint32_t canvas_width = std::max(1u, decoded.width >> mip);
    const uint32_t canvas_height = std::max(1u, decoded.height >> mip);
    const double   unit = static_cast<double>(scale) / static_cast<double>(1u << mip);
    const int      x0 = static_cast<int>(cell.x * unit);
    const int      y0 = static_cast<int>(cell.y * unit);
    const int      x1 = std::min(static_cast<int>(canvas_width), static_cast<int>((cell.x + cell.w) * unit));
    const int      y1 = std::min(static_cast<int>(canvas_height), static_cast<int>((cell.y + cell.h) * unit));
    if (x1 <= x0 || y1 <= y0) {
        return;
    }
    const int src_x = std::clamp(image.x, 0, image.atlas_width - 1);
    const int src_y = std::clamp(image.y, 0, image.atlas_height - 1);
    const int src_w = std::min(image.width, image.atlas_width - src_x);
    const int src_h = std::min(image.height, image.atlas_height - src_y);
    if (src_w <= 0 || src_h <= 0) {
        return;
    }
    const double  fit = std::min(static_cast<double>(x1 - x0) / src_w, static_cast<double>(y1 - y0) / src_h);
    const double  draw_w = src_w * fit;
    const double  draw_h = src_h * fit;
    const double  left = x0 + (x1 - x0 - draw_w) / 2.0;
    const double  top = y0 + (y1 - y0 - draw_h) / 2.0;
    auto         &level = decoded.levels[mip];
    constexpr int k_taps = 4;
    for (int y = y0; y < y1; ++y) {
        for (int x = x0; x < x1; ++x) {
            double sum[4] = {};
            for (int ty = 0; ty < k_taps; ++ty) {
                for (int tx = 0; tx < k_taps; ++tx) {
                    const double u = (x + (tx + 0.5) / k_taps - left) / fit;
                    const double v = (y + (ty + 0.5) / k_taps - top) / fit;
                    if (u < 0.0 || v < 0.0 || u >= src_w || v >= src_h) {
                        continue;
                    }
                    const auto  *texel = &image.rgba[(static_cast<std::size_t>(src_y + static_cast<int>(v)) * image.atlas_width +
                                                      src_x + static_cast<int>(u)) *
                                                     4];
                    const double alpha = texel[3] / 255.0;
                    sum[0] += texel[0] * alpha;
                    sum[1] += texel[1] * alpha;
                    sum[2] += texel[2] * alpha;
                    sum[3] += alpha;
                }
            }
            auto *out = &level[(static_cast<std::size_t>(y) * canvas_width + x) * 4];
            if (sum[3] <= 0.0) {
                out[0] = out[1] = out[2] = out[3] = 0;
                continue;
            }
            out[0] = static_cast<uint8_t>(std::clamp(sum[0] / sum[3] + 0.5, 0.0, 255.0));
            out[1] = static_cast<uint8_t>(std::clamp(sum[1] / sum[3] + 0.5, 0.0, 255.0));
            out[2] = static_cast<uint8_t>(std::clamp(sum[2] / sum[3] + 0.5, 0.0, 255.0));
            out[3] = static_cast<uint8_t>(std::clamp(sum[3] / (k_taps * k_taps) * 255.0 + 0.5, 0.0, 255.0));
        }
    }
}

// The skip prompt's triangle moves with the width of each language's word (English and French at
// x 8, Spanish 4, Italian 5, German 1). Its green triangle is found in the decoded pixels and the cell
// follows it; the built-in cell is the English one, whose triangle box is centred at (18, 34.5).
Rect LocateSkipTriangle(const Rect &cell, uint32_t scale, const datapacks::DecodedTexture &decoded) {
    constexpr double kCenterX = 18.0;
    constexpr double kCenterY = 34.5;
    const auto      &level = decoded.levels.front();
    const int        width = static_cast<int>(decoded.width);
    const int        top = std::max(0, static_cast<int>((cell.y - 4) * scale));
    const int        bottom = std::min(static_cast<int>(decoded.height), static_cast<int>((cell.y + cell.h + 4) * scale));
    int              min_x = width, max_x = -1, min_y = bottom, max_y = -1;
    for (int y = top; y < bottom; ++y) {
        for (int x = 0; x < width; ++x) {
            const uint8_t *texel = &level[(static_cast<std::size_t>(y) * width + x) * 4];
            if (texel[3] > 128 && texel[1] > 100 && texel[1] > texel[0] + 40 && texel[1] > texel[2] + 40) {
                min_x = std::min(min_x, x);
                max_x = std::max(max_x, x);
                min_y = std::min(min_y, y);
                max_y = std::max(max_y, y);
            }
        }
    }
    if (max_x < 0) {
        return cell;
    }
    const double center_x = (min_x + max_x + 1) / 2.0 / scale;
    const double center_y = (min_y + max_y + 1) / 2.0 / scale;
    Rect         moved = cell;
    moved.x = std::max(0, cell.x + static_cast<int>(std::lround(center_x - kCenterX)));
    moved.y = std::max(0, cell.y + static_cast<int>(std::lround(center_y - kCenterY)));
    return moved;
}

void Clear(const Rect &cell, uint32_t scale, datapacks::DecodedTexture &decoded, std::size_t mip) {
    const uint32_t canvas_width = std::max(1u, decoded.width >> mip);
    const uint32_t canvas_height = std::max(1u, decoded.height >> mip);
    const double   unit = static_cast<double>(scale) / static_cast<double>(1u << mip);
    const int      x1 = std::min(static_cast<int>(canvas_width), static_cast<int>((cell.x + cell.w) * unit));
    const int      y1 = std::min(static_cast<int>(canvas_height), static_cast<int>((cell.y + cell.h) * unit));
    for (int y = static_cast<int>(cell.y * unit); y < y1; ++y) {
        for (int x = static_cast<int>(cell.x * unit); x < x1; ++x) {
            std::fill_n(&decoded.levels[mip][(static_cast<std::size_t>(y) * canvas_width + x) * 4], 4, uint8_t{0});
        }
    }
}

} // namespace

std::string ButtonGlyphsStyle() {
    auto style = glyphs::CurrentStyle();
    if (style == "keyboard") {
        for (const char *action : {"cross", "circle", "square", "triangle", "l1", "r1", "l2", "r2", "start", "select", "l3", "r3"}) {
            style += "|" + InputPrimaryBindingName(action);
        }
    }
    return style;
}

bool ButtonGlyphsTarget(std::string_view texture_name) {
    Index();
    return Get().targets.contains(texture_name);
}

void ButtonGlyphsApply(std::string_view texture_name, int logical_width, int logical_height,
                       datapacks::DecodedTexture &decoded) {
    Index();
    State     &state = Get();
    const auto target = state.targets.find(texture_name);
    if (target == state.targets.end() || decoded.levels.empty() || logical_width <= 0 || logical_height <= 0) {
        return;
    }
    const std::string name = glyphs::CurrentStyle();
    if (name.empty()) {
        return;
    }
    glyphs::CpuImage atlas;
    if (!glyphs::FindAtlasPixels(name.c_str(), atlas)) {
        return;
    }
    uint32_t retail_width = 1;
    while (retail_width < static_cast<uint32_t>(logical_width)) {
        retail_width <<= 1;
    }
    const uint32_t scale = std::max(1u, decoded.width / retail_width);
    for (const auto &[glyph, target_cell] : target->second) {
        const Rect cell = texture_name == "skip" && glyph == "triangle"
                              ? LocateSkipTriangle(target_cell, scale, decoded)
                              : target_cell;
        if (cell.x + cell.w > logical_width || cell.y + cell.h > logical_height) {
            continue;
        }
        glyphs::CpuImage image;
        bool             found = false;
        if (name == "keyboard") {
            if (const char *action = Action(std::string_view(glyph).substr(0, glyph.find('@')))) {
                const auto key = InputPrimaryBindingName(action);
                if (!key.empty()) {
                    found = glyphs::FindNamedPixels(name.c_str(), key.c_str(), image);
                }
            }
        }
        if (!found) {
            found = Symbol(name, glyph, image);
        }
        if (!found) {
            // A word beside its button (START by the pill) the style has no art for: the symbol alone.
            if (glyph.find('@') != std::string::npos) {
                for (std::size_t mip = 0; mip < decoded.levels.size(); ++mip) {
                    Clear(cell, scale, decoded, mip);
                }
            }
            continue;
        }
        for (std::size_t mip = 0; mip < decoded.levels.size(); ++mip) {
            Paste(image, cell, scale, decoded, mip);
        }
    }
}

void ButtonGlyphsReset() {
    Get() = State{};
    glyphs::Reset();
}
