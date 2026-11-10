#include "text/title_lettering.hpp"

#include <algorithm>

#include "font.hpp"
#include "mainloop.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/config.hpp"
#include "text/lettering.hpp"

namespace dc2::text {
namespace {

// Every plate is 208 by 52 texels inside a 210 by 54 cell, and every plate of one atlas has the same frame; only
// the lettering differs. The blank is cut from the plate whose lettering is shortest in every language (Extras on
// the title atlas, Italiano on the language atlas): its ends left of column 64 and from column 140, and its rows
// above 12 and from 36, hold no lettering in any of them, and its middle is a flat fill, so column 60 drawn across
// stands in for it. Outside the lettering the blank matches every painted plate of all five languages to within
// 0.0003 of full scale per channel. It is cut as the whole cell, the empty texel round the plate with it, so the
// plate's edge texels (the knob at its foot on the right) are inside the sprite as retail draws them, and a
// filtered draw does not soften them against the next cell.
constexpr int kCellW = 210, kCellH = 54;
constexpr int kLeft = 65, kRight = 69, kTop = 13, kBottom = 17, kFillColumn = 61;

constexpr TitleLabel kLanguage[] = {
    {.x = 0, .y = 0,   .w = 210, .h = 54, .plate_dy = 1, .text = {"English"} },
    {.x = 0, .y = 54,  .w = 210, .h = 54, .plate_dy = 1, .text = {"Français"}},
    {.x = 0, .y = 108, .w = 210, .h = 54, .plate_dy = 1, .text = {"Deutsch"} },
    {.x = 0, .y = 162, .w = 210, .h = 54, .plate_dy = 1, .text = {"Italiano"}},
    {.x = 0, .y = 216, .w = 210, .h = 54, .plate_dy = 1, .text = {"Español"} },
};

// The title atlas's buttons in English, French, German, Italian and Spanish, as title1..5.img paint them. The
// Options cell starts a texel into its plate (and takes a row of the Extras plate's rim below it); the plate is
// drawn where it is.
constexpr TitleLabel kMenu[] = {
    {.x = 302, .y = 40,  .w = 210, .h = 54, .plate_dy = 1,  .text = {"New Game", "Nouvelle partie", "Neues Spiel", "Nuova Partita", "Nueva partida"}                                   },
    {.x = 302, .y = 94,  .w = 210, .h = 54, .plate_dy = 1,  .text = {"Continue", "Continuer", "Fortsetzen", "Continua", "Continuar"}                                                   },
    {.x = 302, .y = 148, .w = 210, .h = 54, .plate_dy = 1,  .text = {"Install", "Installer", "Installieren", "Installa", "Instalar"}                                                   },
    {.x = 302, .y = 204, .w = 210, .h = 54, .plate_dy = -1, .text = {"Options", "Options", "Optionen", "Opzioni", "Opciones"}                                                          },
    {.x = 302, .y = 256, .w = 210, .h = 54, .plate_dy = 1,  .text = {"Extras", "Bonus", "Extras", "Extra", "Extras"}                                                                   },
    {.x = 92,  .y = 202, .w = 210, .h = 54, .plate_dy = 1,  .text = {"Free Race", "Compétition libre", "Freies Rennen", "Gara Aperta", "Carrera extra"}                                },
    {.x = 92,  .y = 256, .w = 210, .h = 54, .plate_dy = 1,  .text = {"Spheda Practice Area", "Terrain de spheda", "Spheda-Training", "Area Allenamento Spheda", "Entrenamiento Esfeda"}},
};

// TitleModeDraw's start_button_tbl: each language's Push START is a 196-texel strip ending at row 40.
constexpr TitleLabel kPushStart[] = {
    {.x = 0, .y = 22, .w = 196, .h = 18, .plate_dy = 0, .text = {"Push START button"}                                                                },
    {.x = 0, .y = 18, .w = 196, .h = 22, .plate_dy = 0, .text = {"", "Appuie sur la touche START", "START-Taste drücken", "", "Pulsa el botón START"}},
    {.x = 0, .y = 20, .w = 196, .h = 20, .plate_dy = 0, .text = {"", "", "", "Premi il tasto START"}                                                 },
};

// The lettering is ChronicleTwoTitle, ChronicleTwoMessage fitted to the English title atlas's buttons
// (scripts/font/title_font.json), lit grey (217, 85% white, by eye). The buttons' has a fine near-black (13, 95%
// black) stroke half a texel wide, about a pixel at 1080p, and that shape's shadow cast a texel and a half right
// and three quarters down, as the painting's dark lies mostly right of and below its strokes, shading off to 65% as
// it leaves them. The Push START line's is outlined a texel wide with the outline cast a texel right and down as
// well.
constexpr LetteringStyle kButton = {
    .typeface = dc2::font::Typeface::Title, .rim = 0.5f, .shadow_x = 1.5f, .shadow_y = 0.75f, .shadow_floor = 0.65f, .fill = 217.0f, .dark = {13.0f, 13.0f, 13.0f}
};
constexpr LetteringStyle kPrompt = {
    .typeface = dc2::font::Typeface::Title, .rim = 1.0f, .shadow_x = 1.0f, .shadow_y = 1.0f, .shadow_floor = 1.0f, .fill = 217.0f, .dark = {13.0f, 13.0f, 13.0f}
};

// Measured on the painted plates: the lettering's ink is centred half a texel left of the plate's middle, on the
// fitted baseline lowered by a pixel at 1080p (0.444 of a texel) by eye, at the fitted em (the font's units over 64; its narrowness is in the font). The language atlas
// paints its names an eighth wider. A label too long for the plate's flat middle is narrowed to fit, as the
// painting narrows it.
constexpr float kEm = 1971.0f / 64.0f, kBaseline = 33.688f + 0.444f, kLanguageWiden = 25.0f / 22.2f, kWidest = 166.0f;
// Push START: a 13-texel cap, as wide as ChronicleTwoMessage's at an em of 20 across, centred where the painted
// lines are, on row 37 of the atlas.
constexpr float kPromptEmY = 23.4f, kPromptEmX = 27.9f, kPromptWidest = 190.0f, kPromptCentre = 98.0f;
constexpr int   kPromptBaseline = 37;

bool Is(const mgCDrawPrim &prim, const char *name) {
    const auto *texture = mgTexManager.GetTexture(const_cast<char *>(name), -1);
    return texture && prim.texture.tex0_bits == texture->tex0_bits;
}

const TitleLabel *Find(std::span<const TitleLabel> labels, mgRect<int> cell) {
    const auto found = std::ranges::find_if(labels, [&](const TitleLabel &label) {
        return label.x == cell.left && label.y == cell.top && label.w == cell.right && label.h == cell.bottom;
    });
    return found == labels.end() ? nullptr : &*found;
}

float Fitted(std::string_view text, float em_x, float widest) {
    const float advance = LetteringAdvance(dc2::font::Typeface::Title, text);
    return advance * em_x > widest ? widest / advance : em_x;
}

// The blank plate's cell at (x, y), from the cell at (cell_x, cell_y) in the prim's texture.
void DrawPlate(mgCDrawPrim &prim, float x, float y, int cell_x, int cell_y) {
    for (const TitlePlatePiece &piece : TitlePlatePieces(cell_x, cell_y, kCellW, kCellH)) {
        prim.TextureCrd(static_cast<int>(piece.src_x), static_cast<int>(piece.src_y));
        prim.Vertex(x + piece.dst_x, y + piece.dst_y, 0.0f);
        prim.TextureCrd(static_cast<int>(piece.src_x + piece.src_w), static_cast<int>(piece.src_y + piece.src_h));
        prim.Vertex(x + piece.dst_x + piece.dst_w, y + piece.dst_y + piece.dst_h, 0.0f);
    }
}

bool DrawButton(mgCDrawPrim &prim, float x, float y, const TitleLabel &label, std::string_view text, int blank_x,
                int blank_y, float em_x) {
    if (text.empty() || !dc2::font::FaceOf(dc2::font::Typeface::Title)) {
        return false;
    }
    // The plate's cell: a texel round the plate, where the plate lies.
    const float cell_y = y + static_cast<float>(label.plate_dy - 1);
    DrawPlate(prim, x, cell_y, blank_x, blank_y);
    DrawLettering(prim, kButton, text, x + kCellW / 2.0f - 0.5f, cell_y + 1.0f + kBaseline,
                  Fitted(text, em_x, kWidest), kEm, 1.0f, 1.0f, LetteringAlign::InkCentre);
    return true;
}

} // namespace

std::array<TitlePlatePiece, 9> TitlePlatePieces(int cell_x, int cell_y, float w, float h) {
    const float left = std::min<float>(kLeft, w * kLeft / (kLeft + kRight));
    const float right = std::min<float>(kRight, w - left);
    const float top = std::min<float>(kTop, h * kTop / (kTop + kBottom));
    const float bottom = std::min<float>(kBottom, h - top);
    const float middle_w = w - left - right;
    const float middle_h = h - top - bottom;
    const auto  x = static_cast<float>(cell_x);
    const auto  y = static_cast<float>(cell_y);
    const float edge_w = kCellW - kLeft - kRight;
    const float edge_h = kCellH - kTop - kBottom;
    const float right_x = kCellW - kRight;
    const float bottom_y = kCellH - kBottom;
    return {
        {
         {.src_x = x, .src_y = y, .src_w = kLeft, .src_h = kTop, .dst_x = 0, .dst_y = 0, .dst_w = left, .dst_h = top},
         {.src_x = x + kLeft, .src_y = y, .src_w = edge_w, .src_h = kTop, .dst_x = left, .dst_y = 0, .dst_w = middle_w, .dst_h = top},
         {.src_x = x + right_x, .src_y = y, .src_w = kRight, .src_h = kTop, .dst_x = w - right, .dst_y = 0, .dst_w = right, .dst_h = top},
         {.src_x = x, .src_y = y + kTop, .src_w = kLeft, .src_h = edge_h, .dst_x = 0, .dst_y = top, .dst_w = left, .dst_h = middle_h},
         {.src_x = x + kFillColumn, .src_y = y + kTop, .src_w = 1, .src_h = edge_h, .dst_x = left, .dst_y = top, .dst_w = middle_w, .dst_h = middle_h},
         {.src_x = x + right_x, .src_y = y + kTop, .src_w = kRight, .src_h = edge_h, .dst_x = w - right, .dst_y = top, .dst_w = right, .dst_h = middle_h},
         {.src_x = x, .src_y = y + bottom_y, .src_w = kLeft, .src_h = kBottom, .dst_x = 0, .dst_y = h - bottom, .dst_w = left, .dst_h = bottom},
         {.src_x = x + kLeft, .src_y = y + bottom_y, .src_w = edge_w, .src_h = kBottom, .dst_x = left, .dst_y = h - bottom, .dst_w = middle_w, .dst_h = bottom},
         {.src_x = x + right_x, .src_y = y + bottom_y, .src_w = kRight, .src_h = kBottom, .dst_x = w - right, .dst_y = h - bottom, .dst_w = right, .dst_h = bottom},
         }
    };
}

std::span<const TitleLabel> TitleLanguageLabels() { return kLanguage; }

std::span<const TitleLabel> TitleMenuLabels() { return kMenu; }

std::span<const TitleLabel> TitlePushStartLabels() { return kPushStart; }

bool DrawTitleLettering(mgCDrawPrim &prim, float x, float y, mgRect<int> cell) {
    if (!ConfigGet().font_sharp || !prim.prim.TME) {
        return false;
    }
    if (Is(prim, "lang_select")) {
        const TitleLabel *label = Find(kLanguage, cell);
        return label && DrawButton(prim, x, y, *label, label->text[0], kLanguage[3].x, kLanguage[3].y, kEm * kLanguageWiden);
    }
    if (GetNowLoopNo() != LOOP_TITLE || LanguageCode < LANG_ENGLISH || LanguageCode > LANG_SPANISH || !Is(prim, "moji")) {
        return false;
    }
    const int language = LanguageCode - LANG_ENGLISH;
    if (const TitleLabel *label = Find(kMenu, cell)) {
        return DrawButton(prim, x, y, *label, label->text[language], kMenu[4].x, kMenu[4].y + kMenu[4].plate_dy - 1, kEm);
    }
    const TitleLabel      *label = Find(kPushStart, cell);
    const std::string_view text = label ? label->text[language] : std::string_view{};
    if (text.empty()) {
        return false;
    }
    return DrawLettering(prim, kPrompt, text, x + kPromptCentre, y + static_cast<float>(kPromptBaseline - label->y),
                         Fitted(text, kPromptEmX, kPromptWidest), kPromptEmY, 1.0f, 1.0f, LetteringAlign::InkCentre);
}

} // namespace dc2::text
