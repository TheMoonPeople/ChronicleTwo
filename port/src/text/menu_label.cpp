#include "text/menu_label.hpp"

#include "mainloop.hpp"
#include "menudraw.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/config.hpp"
#include "text/lettering.hpp"

namespace dc2::text {
namespace {

// The words the English atlas paints, by the name of their cell (Shift-JIS, as the menu's layout holds it), each
// offset from its lettering's pen and baseline where its painting has it. From scripts/font/menu_font.json's and
// board_font.json's "words", which fit_menu_font.py measured. The board's figures share one strip cell.
constexpr char kFigures[] = "\x8e\x9e\x8a\xd4\x90\x94"; // 時間数

constexpr MenuLabelWord kWords[] = {
    {.cell = "mi_item_ic",   .text = "Item",      .dx = 0.0f,    .dy = -0.25f },
    {.cell = "mi_chr_ic",    .text = "Character", .dx = 0.0f,    .dy = 0.312f },
    {.cell = "mi_invent_ic", .text = "Make",      .dx = -0.251f, .dy = -0.188f},
    {.cell = "mi_move_ic",   .text = "Move",      .dx = 0.188f,  .dy = -0.189f},
    {.cell = "mi_op_ic",     .text = "Options",   .dx = 0.0f,    .dy = 0.312f },
    {.cell = "mi_mn_ic",     .text = "Help",      .dx = -0.062f, .dy = -0.25f },
    {.cell = "mi_hatena_ic", .text = "???",       .dx = -0.562f, .dy = -0.625f},
};

constexpr MenuLabelWord kBoard[] = {
    {.cell = "\x93\xfa\x96\xda", .text = "Day",    .dx = 1.438f,  .dy = -0.625f},
    {.cell = "\x96\xa2\x97\x88", .text = "Future", .dx = 0.125f,  .dy = 0.125f },
    {.cell = "AM",               .text = "AM",     .dx = -1.312f, .dy = -2.875f},
    {.cell = "PM",               .text = "PM",     .dx = 0.188f,  .dy = -2.875f},
    {.cell = "::",               .text = ":",      .dx = -0.562f, .dy = -0.75f },
    {.cell = kFigures,           .text = "0",      .dx = 0.312f,  .dy = 0.938f },
    {.cell = kFigures,           .text = "1",      .dx = 0.0f,    .dy = 1.0f   },
    {.cell = kFigures,           .text = "2",      .dx = 0.125f,  .dy = 1.125f },
    {.cell = kFigures,           .text = "3",      .dx = 0.0f,    .dy = 1.0f   },
    {.cell = kFigures,           .text = "4",      .dx = -0.188f, .dy = 1.125f },
    {.cell = kFigures,           .text = "5",      .dx = -0.688f, .dy = 0.938f },
    {.cell = kFigures,           .text = "6",      .dx = -0.062f, .dy = 1.125f },
    {.cell = kFigures,           .text = "7",      .dx = 0.188f,  .dy = 0.938f },
    {.cell = kFigures,           .text = "8",      .dx = -0.438f, .dy = 1.0f   },
    {.cell = kFigures,           .text = "9",      .dx = 0.5f,    .dy = 0.938f },
};

// How each lettering is painted. The words are lit grey on a dark violet rim a texel and a third wide, with the
// rimmed letters again a texel and a half right and down as their shadow, fading to 75% of its strength as it
// leaves them; set by eye in the game over the painting's measured rim of a texel and a half and shadow of 1.25
// texels across. The time board's are lit a little darker, with no rim and a hard shadow a texel right and down.
constexpr LetteringStyle kStyles[] = {
    {.typeface = dc2::font::Typeface::Menu,  .rim = 1.3f, .shadow_x = 1.55f, .shadow_y = 1.5f, .shadow_floor = 0.75f, .fill = 217.0f, .dark = {29.0f, 24.0f, 34.0f}},
    {.typeface = dc2::font::Typeface::Board, .rim = 0.0f, .shadow_x = 1.0f,  .shadow_y = 1.0f, .shadow_floor = 1.0f,  .fill = 205.0f, .dark = {10.0f, 10.0f, 10.0f}},
};

// Whether the prim draws from the menu atlas, and the atlas's cell `name` is the rectangle `uv`.
bool AtlasCell(const mgCDrawPrim &prim, const char *name, mgRect<int> uv) {
    static char atlas_name[] = "mnmain";
    const auto *atlas = mgTexManager.GetTexture(atlas_name, -1);
    if (!prim.prim.TME || !atlas || prim.texture.tex0_bits != atlas->tex0_bits || !MenuPosData) {
        return false;
    }
    const MENU_BASETEXINFO *info = MenuPosData->GetTexGetInfo(const_cast<char *>(name));
    return info && info->rect.left == uv.left && info->rect.top == uv.top && info->rect.right == uv.right &&
           info->rect.bottom == uv.bottom;
}

bool Lettered() { return ConfigGet().font_sharp && LanguageCode == LANG_ENGLISH; }

// Draws `word` in its lettering into the cell the prim was about to draw into `put`, a cell of `cell_w` by
// `cell_h` texels; false where it cannot.
bool Draw(mgCDrawPrim &prim, mgRect<float> put, int cell_w, int cell_h, const MenuLabelWord &word, MenuLettering lettering) {
    if (cell_w <= 0 || cell_h <= 0) {
        return false;
    }
    // Logical pixels a texel: retail stretches the cell over put.
    const float             texel_x = put.right / static_cast<float>(cell_w);
    const float             texel_y = put.bottom / static_cast<float>(cell_h);
    const MenuLabelGeometry geometry = MenuLabelGeometryOf(lettering);
    return DrawLettering(prim, kStyles[static_cast<int>(lettering)], word.text, put.left + (geometry.start + word.dx) * texel_x,
                         put.top + (geometry.baseline + word.dy) * texel_y, geometry.em, geometry.em, texel_x, texel_y);
}

} // namespace

// From scripts/font/menu_font.json's and board_font.json's "global", which fit_menu_font.py measured; the em is
// the font's units per em over 64.
MenuLabelGeometry MenuLabelGeometryOf(MenuLettering lettering) {
    return lettering == MenuLettering::Words ? MenuLabelGeometry{.em = 18.0625f, .start = 0.812f, .baseline = 17.649f}
                                             : MenuLabelGeometry{.em = 17.90625f, .start = 1.125f, .baseline = 16.5f};
}

std::span<const MenuLabelWord> MenuLabelWords(MenuLettering lettering) {
    if (lettering == MenuLettering::Words) {
        return kWords;
    }
    return kBoard;
}

bool DrawMenuLabel(mgCDrawPrim &prim, mgRect<float> put, mgRect<int> uv) {
    if (!Lettered() || uv.right <= 0 || uv.bottom <= 0) {
        return false;
    }
    for (const MenuLettering lettering : {MenuLettering::Words, MenuLettering::Board}) {
        for (const MenuLabelWord &word : MenuLabelWords(lettering)) {
            if (word.cell != kFigures && AtlasCell(prim, word.cell, uv)) {
                return Draw(prim, put, uv.right, uv.bottom, word, lettering);
            }
        }
    }
    return false;
}

bool DrawMenuFigure(mgCDrawPrim &prim, mgRect<int> put, mgRect<int> uv) {
    if (!Lettered() || !MenuPosData) {
        return false;
    }
    // DrawMenuNumber cuts figure n from the strip: the strip cell's size, n cell widths right.
    static char             strip_name[] = "\x8e\x9e\x8a\xd4\x90\x94";
    const MENU_BASETEXINFO *strip = MenuPosData->GetTexGetInfo(strip_name);
    if (!strip || strip->rect.right <= 0 || uv.right != strip->rect.right || uv.bottom != strip->rect.bottom ||
        uv.top != strip->rect.top || (uv.left - strip->rect.left) % strip->rect.right != 0 ||
        !AtlasCell(prim, kFigures, {strip->rect.left, uv.top, uv.right, uv.bottom})) {
        return false;
    }
    const int index = (uv.left - strip->rect.left) / strip->rect.right;
    for (const MenuLabelWord &figure : MenuLabelWords(MenuLettering::Board)) {
        if (figure.cell == kFigures && figure.text.size() == 1 && figure.text[0] == '0' + index) {
            return Draw(prim, mgRect<float>(put.left, put.top, put.right, put.bottom), uv.right, uv.bottom, figure,
                        MenuLettering::Board);
        }
    }
    return false;
}

} // namespace dc2::text
