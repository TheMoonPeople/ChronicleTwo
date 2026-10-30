#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <iterator>
#include <map>
#include <optional>
#include <span>
#include <tuple>
#include <vector>

#include "dataread.hpp"
#include "font.hpp"
#include "log/game_output.hpp"
#include "log/log.hpp"
#include "mainloop.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "platform/config.hpp"
#include "platform/paths.hpp"
#include "platform/ttffont.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "text/bounded.hpp"
#include "text/outline.hpp"

/**
 *
 * Character codes for the external glyphs.
 *
 */
struct GaijiCodeTable {
    u16 code[24]; /**< External glyph codes. */
};

/**
 *
 * Wide character codes for the half-width kana glyphs.
 *
 */
struct HankakuKanaWideTable {
    u16 code[63]; /**< Wide kana codes. */
};

/**
 *
 * Single byte character codes for the half-width kana glyphs.
 *
 */
struct HankakuKanaTable {
    u8 code[63]; /**< Single byte kana codes. */
};

/**
 *
 * Owns the loaded font character table with its native alignment and object lifetime.
 *
 */
static FONT_TBL_BIN font_table{};

int GetGaijiW(int code) {
    if (code >= GAIJI_CODE_TOP && code < GAIJI_CODE_END) {

        int index = code - 0x8000;
        index -= 0x7D00;
        return GaijiDataTbl[index].w;
    }

    return 0;
}

int GetGaijiH(int code) {
    if (code >= GAIJI_CODE_TOP && code < GAIJI_CODE_END) {

        int index = code - 0x8000;
        index -= 0x7D00;
        return GaijiDataTbl[index].h;
    }

    return 0;
}

RECT GetRectFontTex(int font_no, int *tex_no) {
    int font = font_no;

    if (font_no >= 0xFDE0 && font_no < 0xFDF8) {
        if ((LanguageCode == 2 || LanguageCode == 3 || LanguageCode == 4) || LanguageCode == 5) {
            font = static_cast<u16>(GetFontNoFromFontGaijiCode(static_cast<u16>(font_no)));
        }
    }

    RECT rect = {0, 0, 0, 0};

    if (font < 0) {
        return rect;
    }

    if (font < 0x260) {
        *tex_no = 0;
    } else if (font < 0x4C0) {
        *tex_no = 1;
        font -= 0x260;
    } else if (font < 0x720) {
        *tex_no = 2;
        font -= 0x4C0;
    } else if (font < 0x980) {
        *tex_no = 3;
        font -= 0x720;
    } else {
        return rect;
    }

    rect.x = font % 32;
    rect.y = font / 32;
    rect.x *= 16;
    rect.y *= 20;
    rect.width = 16;
    rect.height = 20;
    return rect;
}

void MySetTexMini(int page, mgCDrawPrim *prim) {
    mgCTextureManager *tex_manager = &mgTexManager;

    if (page == 0) {
        prim->Texture(tex_manager->GetTexture("FontTex_s_0", -1));
    } else {
        prim->Texture(tex_manager->GetTexture("FontTex_s_1", -1));
    }
}

RECT GetRectFontTexMini(int code, int *page) {
    RECT rect = {0, 0, 0, 0};
    return rect;
}

u8 *GetYoyakuTblTop() {
    return font_table.yoyaku_tbl[0];
}

int LoadFontTblBin() {
    font_table = {};
    const auto bytes = std::span<u8>(reinterpret_cast<u8 *>(&font_table), sizeof(font_table));
    int        size = {};

    if (LanguageCode == 1) {
        LoadFile("meswin/fonttbl_1.bin", bytes, &size);
    } else {
        LoadFile("meswin/fonttbl_2.bin", bytes, &size);
    }

    if (size < static_cast<int>(offsetof(FONT_TBL_BIN, yoyaku_tbl)) ||
        font_table.yoyaku_num > std::size(font_table.yoyaku_tbl) ||
        static_cast<std::size_t>(font_table.yoyaku_num) >
            (static_cast<std::size_t>(size) - offsetof(FONT_TBL_BIN, yoyaku_tbl)) / sizeof(font_table.yoyaku_tbl[0]) ||
        font_table.half_font_num > font_table.yoyaku_num) {
        font_table = {};
        dc2::log::PrintGame("Invalid font table extent or character count\n");
        return 0;
    }

    return 1;
}

int GetYoyakuTblNum() {
    return font_table.yoyaku_num <= std::size(font_table.yoyaku_tbl) ? font_table.yoyaku_num : 0;
}

int GetKanjiTopNo() {
    return font_table.kanji_top_no;
}

int GetHalfFontNum() {
    return font_table.half_font_num;
}

int CFont::CheckKanjiFont(int font_no) {
    if (LanguageCode == 6) {
        return 0;
    }

    if (GetKanjiTopNo() == 0) {
        return 0;
    }

    if (font_no < GetKanjiTopNo()) {
        return 0;
    }

    return (font_no >= GetYoyakuTblNum()) ^ 1;
}

int CFont::CheckHalfFont(int font_no) {
    if (font_no == 0xFF02) {
        return 1;
    }

    if (LanguageCode != 1) {
        if ((font_no >= 0x5E) && (font_no < 0x9D)) {
            return 1;
        }

        if ((font_no >= 0x9D) && (font_no < 0xB5)) {
            return 0;
        }
    }

    if (font_no < 0) {
        return 0;
    }

    return (font_no >= GetHalfFontNum()) ^ 1;
}

void CFont::SetDrawSize(s32 width, s32 height) {
    draw_w = width;
    draw_h = height;
}

void CFont::SetClearance(s32 width, s32 height) {
    clearance_w = width;
    clearance_h = height;
}

void CFont::SetPos(s32 x, s32 y) {
    pos_x = x;
    pos_y = y;
}

void CFont::SetColor(s32 r, s32 g, s32 b, s32 a) {
    color.r = r;
    color.g = g;
    color.b = b;
    color.a = a;
}

void CFont::SetColor(RGBAQ_TYPE color) {
    this->color.r = color.r;
    this->color.g = color.g;
    this->color.b = color.b;
    this->color.a = color.a;
}

void CFont::SetColor(u32 packed_color) {
    RGBAQ_TYPE color = RgbqToUint(packed_color);
    SetColor(color);
}

void CFont::SetFuchi(s32 style) {
    fuchi = style;
}

void CFont::SetStr(char *text) {
    memset(this->str, 0, sizeof(this->str));

    if (strlen(text) >= 0x80U) {
        dc2::log::PrintGame("ERR:\x95\xB6\x8E\x9A\x90\x94\x82\xAA\x91\xBD\x82\xB7\x82\xAC\x82\xDC\x82\xB7\x81"
                            "B\n");
        return;
    }

    dc2::text::Copy(this->str, dc2::text::View(text));
}

u16 GetGaijiFontNo(const char *text) {
    if (text == nullptr || *text == '\0') {
        return 0;
    }
    for (const auto &entry : FconvCodeTbl) {
        if (entry.str != nullptr && entry.len > 0 &&
            std::strncmp(text, entry.str, static_cast<std::size_t>(entry.len)) == 0) {
            return entry.code;
        }
    }

    return 0;
}

int GetGaijiLen(u16 code) {
    int found = -1;
    int i = {};

    for (i = 0; i < 46; i++) {
        if (code == FconvCodeTbl[i].code) {
            found = i;
            break;
        }
    }

    if (found == -1) {
        return 0;
    }

    return FconvCodeTbl[found].len;
}

u16 GetAlphabeticalFontNo_uc(u8 ch) {
    HankakuKanaTable table = {
        {
         0xA1,
         0xAA,
         0xB0,
         0xBA,
         0xBF,
         0xC0,
         0xC1,
         0xC2,
         0xC3,
         0xC4,
         0xC5,
         0xC6,
         0xC7,
         0xC8,
         0xC9,
         0xCA,
         0xCB,
         0xCC,
         0xCD,
         0xCE,
         0xCF,
         0xD1,
         0xD2,
         0xD3,
         0xD4,
         0xD5,
         0xD6,
         0xD9,
         0xDA,
         0xDB,
         0xDC,
         0xDD,
         0xDF,
         0xE0,
         0xE1,
         0xE2,
         0xE3,
         0xE4,
         0xE5,
         0xE6,
         0xE7,
         0xE8,
         0xE9,
         0xEA,
         0xEB,
         0xEC,
         0xED,
         0xEE,
         0xEF,
         0xF1,
         0xF2,
         0xF3,
         0xF4,
         0xF5,
         0xF6,
         0xF9,
         0xFA,
         0xFB,
         0xFC,
         0xFD,
         0xFF,
         0xBD,
         0xBE,
         }
    };
    int i = {};

    if (LanguageCode == 1) {
        return 0;
    }

    u8 key = {};

    if (ch == 0x9C) {
        key = 0xBE;
    } else {
        key = ch;
    }

    for (i = 0; i < 63; i++) {
        if (key == table.code[i]) {
            return i + 0x5E;
        }
    }

    return 0;
}

u16 dc2::font::AlphabeticalCode(std::string_view text) {
    if (LanguageCode == LANG_ENGLISH || text.size() < 9 || !text.starts_with("[UNI0")) {
        return 0;
    }
    auto                                                                   code = text.substr(5, 4);
    constexpr std::array<std::pair<std::string_view, std::string_view>, 5> remaps{
        {{"11d]", "0e8]"}, {"129]", "0ea]"}, {"155]", "0e0]"}, {"171]", "0fb]"}, {"17f]", "0f9]"}}
    };
    for (const auto &[source, destination] : remaps) {
        if (code == source) {
            code = destination;
            break;
        }
    }
    for (std::size_t index = 0; index < std::size(alphabetical_chara_tbl); ++index) {
        if (code == std::string_view(alphabetical_chara_tbl[index], 4)) {
            return static_cast<u16>(index + 0x5E);
        }
    }
    return 0;
}

u16 GetFontGaijiFontNo(const char *text) {
    if (LanguageCode == 1 || text == nullptr || *text == '\0') {
        return 0;
    }

    for (const auto &entry : FontGaijiConvTbl) {
        if (entry.str != nullptr && entry.len > 0 &&
            std::strncmp(text, entry.str, static_cast<std::size_t>(entry.len)) == 0) {
            return entry.code;
        }
    }

    return 0;
}

u16 GetAlphabeticalFontNo_us(u16 code) {
    HankakuKanaWideTable table = {
        {
         0xFFA1,
         0xFFAA,
         0xFFB0,
         0xFFBA,
         0xFFBF,
         0xFFC0,
         0xFFC1,
         0xFFC2,
         0xFFC3,
         0xFFC4,
         0xFFC5,
         0xFFC6,
         0xFFC7,
         0xFFC8,
         0xFFC9,
         0xFFCA,
         0xFFCB,
         0xFFCC,
         0xFFCD,
         0xFFCE,
         0xFFCF,
         0xFFD1,
         0xFFD2,
         0xFFD3,
         0xFFD4,
         0xFFD5,
         0xFFD6,
         0xFFD9,
         0xFFDA,
         0xFFDB,
         0xFFDC,
         0xFFDD,
         0xFFDF,
         0xFFE0,
         0xFFE1,
         0xFFE2,
         0xFFE3,
         0xFFE4,
         0xFFE5,
         0xFFE6,
         0xFFE7,
         0xFFE8,
         0xFFE9,
         0xFFEA,
         0xFFEB,
         0xFFEC,
         0xFFED,
         0xFFEE,
         0xFFEF,
         0xFFF1,
         0xFFF2,
         0xFFF3,
         0xFFF4,
         0xFFF5,
         0xFFF6,
         0xFFF9,
         0xFFFA,
         0xFFFB,
         0xFFFC,
         0xFFFD,
         0xFFFF,
         0xFFBD,
         0xFFBE,
         }
    };
    int i = {};

    if (LanguageCode == 1) {
        return 0;
    }

    for (i = 0; i < 63; i++) {
        if (code == table.code[i]) {
            return i + 0x5E;
        }
    }

    return 0;
}

u16 GetFontNoFromFontGaijiCode(u16 code) {
    GaijiCodeTable table = {
        {
         0xFDE0,
         0xFDE1,
         0xFDE2,
         0xFDE3,
         0xFDE4,
         0xFDE5,
         0xFDE6,
         0xFDE7,
         0xFDE8,
         0xFDE9,
         0xFDEA,
         0xFDEB,
         0xFDEC,
         0xFDED,
         0xFDEE,
         0xFDEF,
         0xFDF0,
         0xFDF1,
         0xFDF2,
         0xFDF3,
         0xFDF4,
         0xFDF5,
         0xFDF6,
         0xFDF7,
         }
    };
    int i = {};

    if (LanguageCode == 1) {
        return 0;
    }

    for (i = 0; i < 24; i++) {
        if (code == table.code[i]) {
            return i + 0x9D;
        }
    }

    return 0;
}

int GetFontGaijiHankaku(u16 code) {
    if (code == 0xFDF3 || code == 0xFDF4 || code == 0xFDF5 ||
        code == 0xFDF6 || code == 0xFDF7) {
        return 1;
    }

    return 0;
}

int GetFontNo(const char *text) {
    if (text == nullptr || *text == '\0') {
        return -1;
    }
    if (text[0] == '\n') {
        return FONT_NO_NEWLINE;
    }

    int gaiji = GetFontGaijiFontNo(text);

    if (gaiji != 0) {
        return static_cast<u16>(gaiji);
    }

    const auto  code = static_cast<u16>(static_cast<u8>(text[1]) + (static_cast<u8>(text[0]) << 8));
    std::size_t low = 0;
    std::size_t high = static_cast<std::size_t>(GetYoyakuTblNum());
    while (low < high) {
        const auto  middle = low + (high - low) / 2;
        const auto &pair = font_table.yoyaku_tbl[middle];
        const auto  entry = static_cast<u16>(pair[1] + (pair[0] << 8));
        if (entry < code) {
            low = middle + 1;
        } else if (entry > code) {
            high = middle;
        } else {
            return static_cast<int>(middle);
        }
    }
    return -1;
}

int GetHalfFontNo(char c) {
    char buf[8];
    u16  no = GetAlphabeticalFontNo_uc(static_cast<unsigned char>(c));

    if (no != 0) {
        return no & 0xFFFF;
    }

    buf[1] = 0x20;
    buf[0] = c;
    return GetFontNo(buf);
}

int CFont::GetDigitNo(int font_no) {
    if (font_no == GetFontNo("\x82P")) {
        return 1;
    }

    if (font_no == GetFontNo("\x82Q")) {
        return 2;
    }

    if (font_no == GetFontNo("\x82R")) {
        return 3;
    }

    if (font_no == GetFontNo("\x82S")) {
        return 4;
    }

    if (font_no == GetFontNo("\x82T")) {
        return 5;
    }

    if (font_no == GetFontNo("\x82U")) {
        return 6;
    }

    if (font_no == GetFontNo("\x82V")) {
        return 7;
    }

    if (font_no == GetFontNo("\x82W")) {
        return 8;
    }

    if (font_no == GetFontNo("\x82X")) {
        return 9;
    }

    if (font_no == GetFontNo("\x82O")) {
        return 0;
    }

    return -1;
}

namespace {

// Font numbers FONT_NO_ALPHABETICAL_TOP on of the European page: the Latin-1 codes of
// alphabetical_chara_tbl, in its order, and Œ œ.
constexpr std::array<char32_t, ALPHABETICAL_CHARA_NUM> kAccented = {
    0xA1, 0xAA, 0xB0, 0xBA, 0xBF, 0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA,
    0xCB, 0xCC, 0xCD, 0xCE, 0xCF, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD,
    0xDF, 0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE,
    0xEF, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFF, 0x152, 0x153};

// Font numbers FONT_NO_FONT_GAIJI_TOP on: FontGaijiConvTbl's characters, ○ ● ↑ ↓ ← → ０-９ ： ＋ － ・ “ ” ‘ ’.
// The page draws the last five half-width, and the font keeps the half-width middle dot at U+FF65.
constexpr std::array<char32_t, FONT_GAIJI_CONV_NUM> kFontGaiji = {
    0x25CB, 0x25CF, 0x2191, 0x2193, 0x2190, 0x2192, 0xFF10, 0xFF11, 0xFF12, 0xFF13, 0xFF14, 0xFF15,
    0xFF16, 0xFF17, 0xFF18, 0xFF19, 0xFF1A, 0xFF0B, 0xFF0D, 0xFF65, 0x201C, 0x201D, 0x2018, 0x2019};

// The English page's full-width symbols the font draws: Shift-JIS code, then code point. The European
// page draws “ ” ’ ° half-width at the standard code points, so the English forms take 0xE001 on.

// clang-format off
constexpr std::pair<std::uint16_t, char32_t> kEnglishSymbols[] = {
    {0x8140, 0x3000}, {0x8141, 0x3001}, {0x8142, 0x3002}, {0x8143, 0xFF0C}, {0x8144, 0xFF0E}, {0x8145, 0x30FB},
    {0x8146, 0xFF1A}, {0x8147, 0xFF1B}, {0x8148, 0xFF1F}, {0x8149, 0xFF01}, {0x8151, 0xFF3F}, {0x8158, 0x3005},
    {0x815C, 0x2015}, {0x815E, 0xFF0F}, {0x8160, 0x301C}, {0x8162, 0xFF5C}, {0x8163, 0x2026}, {0x8164, 0x2025},
    {0x8166, 0xE004}, {0x8167, 0xE001}, {0x8168, 0xE002}, {0x8169, 0xFF08}, {0x816A, 0xFF09}, {0x816D, 0xFF3B},
    {0x816E, 0xFF3D}, {0x816F, 0xFF5B}, {0x8170, 0xFF5D}, {0x8175, 0x300C}, {0x8176, 0x300D}, {0x8177, 0x300E},
    {0x8178, 0x300F}, {0x8179, 0x3010}, {0x817A, 0x3011}, {0x817B, 0xFF0B}, {0x817C, 0x2212}, {0x817D, 0x00B1},
    {0x817E, 0x00D7}, {0x8181, 0xFF1D}, {0x8183, 0xFF1C}, {0x8184, 0xFF1E}, {0x818B, 0xE005}, {0x818F, 0xFFE5},
    {0x8190, 0xFF04}, {0x8193, 0xFF05}, {0x8194, 0xFF03}, {0x8195, 0xFF06}, {0x8196, 0xFF0A}, {0x8197, 0xFF20},
    {0x819B, 0x25CB}, {0x819C, 0x25CF}, {0x81A0, 0x25A1}, {0x81A1, 0x25A0}, {0x81A2, 0x25B3}, {0x81A8, 0x2192},
    {0x81A9, 0x2190}, {0x81AA, 0x2191}, {0x81AB, 0x2193}, {0x824F, 0xFF10}, {0x8250, 0xFF11}, {0x8251, 0xFF12},
    {0x8252, 0xFF13}, {0x8253, 0xFF14}, {0x8254, 0xFF15}, {0x8255, 0xFF16}, {0x8256, 0xFF17}, {0x8257, 0xFF18},
    {0x8258, 0xFF19}, {0x8260, 0xFF21}, {0x8261, 0xFF22}, {0x8262, 0xFF23}, {0x8263, 0xFF24}, {0x8264, 0xFF25},
    {0x8265, 0xFF26}, {0x8266, 0xFF27}, {0x8267, 0xFF28}, {0x8268, 0xFF29}, {0x8269, 0xFF2A}, {0x826A, 0xFF2B},
    {0x826B, 0xFF2C}, {0x826C, 0xFF2D}, {0x826D, 0xFF2E}, {0x826E, 0xFF2F}, {0x826F, 0xFF30}, {0x8270, 0xFF31},
    {0x8271, 0xFF32}, {0x8272, 0xFF33}, {0x8273, 0xFF34}, {0x8274, 0xFF35}, {0x8275, 0xFF36}, {0x8276, 0xFF37},
    {0x8277, 0xFF38}, {0x8278, 0xFF39}, {0x8279, 0xFF3A}, {0x8281, 0xFF41}, {0x8282, 0xFF42}, {0x8283, 0xFF43},
    {0x8284, 0xFF44}, {0x8285, 0xFF45}, {0x8286, 0xFF46}, {0x8287, 0xFF47}, {0x8288, 0xFF48}, {0x8289, 0xFF49},
    {0x828A, 0xFF4A}, {0x828B, 0xFF4B}, {0x828C, 0xFF4C}, {0x828D, 0xFF4D}, {0x828E, 0xFF4E}, {0x828F, 0xFF4F},
    {0x8290, 0xFF50}, {0x8291, 0xFF51}, {0x8292, 0xFF52}, {0x8293, 0xFF53}, {0x8294, 0xFF54}, {0x8295, 0xFF55},
    {0x8296, 0xFF56}, {0x8297, 0xFF57}, {0x8298, 0xFF58}, {0x8299, 0xFF59}, {0x829A, 0xFF5A}};
// clang-format on

constexpr float kUnitsPerEm = 1280.0f;
constexpr float kHalfWidth = 512.0f; // a half-width cell's advance, in font units
constexpr int   kShiftSteps = 4;     // a glyph is drawn at a quarter-pixel pen; its baseline at a whole pixel

// The live SubpixelPen's fraction of a logical pixel.
float pen_fraction = 0.0f;

bool Ready() { return dc2::font::FaceOf(dc2::font::Typeface::Message) != nullptr; }

// The loaded font table's codes, two bytes a font number.
std::span<const std::uint8_t> LoadedTable() {
    const int count = std::clamp(GetYoyakuTblNum(), 0, static_cast<int>(sizeof(FONT_TBL_BIN::yoyaku_tbl) / 2));
    return {GetYoyakuTblTop(), static_cast<std::size_t>(count) * 2};
}

// A glyph's fill, or one of the rims drawn for retail's outline styles.
enum class Layer {
    Fill,
    Thin,
    Thick,
    Glow,
};

struct Ink {
    gfx::TextureHandle texture = gfx::kNullTexture;
    int                width = 0, height = 0, x0 = 0, y0 = 0;
    std::size_t        bytes = 0;
    int                used = 0; // the frame that last drew it
};

// Character, em across and down in 1/16 px, pen shift, layer, and a rim's target pixels to a logical
// pixel across and down in 1/16.
using InkKey = std::tuple<char32_t, int, int, int, Layer, int, int>;

dc2::text::Outline OutlineOf(Layer layer) {
    switch (layer) {
        case Layer::Thick:
            return dc2::text::Outline::Thick;
        case Layer::Glow:
            return dc2::text::Outline::Glow;
        default:
            return dc2::text::Outline::Thin;
    }
}

// Glyph images are immutable, so a recorded frame never samples one that changed. Past the budget the
// longest unused are destroyed; a frame's list keeps any it still draws alive until it is done with it.
const Ink *GetInk(const InkKey &key) {
    static std::map<InkKey, Ink> cache;
    static std::size_t           bytes_used = 0;
    constexpr std::size_t        budget = std::size_t{32} * 1024 * 1024;
    const int                    frame = mgPortFrameCount();
    if (const auto found = cache.find(key); found != cache.end()) {
        found->second.used = frame;
        return found->second.texture == gfx::kNullTexture ? nullptr : &found->second;
    }
    const auto [ch, em_x, em_y, shift, layer, px_x, px_y] = key;
    Ink                        ink;
    std::vector<unsigned char> coverage;
    if (!dc2::font::FaceOf(dc2::font::Typeface::Message)
             ->RenderGlyph(ch, em_x / 16.0f, em_y / 16.0f, static_cast<float>(shift) / kShiftSteps, 0.0f, coverage,
                           ink.width, ink.height, ink.x0, ink.y0) ||
        ink.width <= 0 || ink.height <= 0) {
        // Remembered as missing: a character the font cannot draw, or a size it will not.
        cache.emplace(key, ink);
        return nullptr;
    }
    if (layer != Layer::Fill) {
        dc2::text::OutlineImage rim = dc2::text::OutlineRim(coverage, ink.width, ink.height, px_x / 16.0f, px_y / 16.0f, OutlineOf(layer));
        coverage = std::move(rim.alpha);
        ink.width += 2 * rim.margin_x;
        ink.height += 2 * rim.margin_y;
        ink.x0 -= rim.margin_x;
        ink.y0 -= rim.margin_y;
    }
    ink.bytes = static_cast<std::size_t>(ink.width + 2) * (ink.height + 2) * 4;
    while (bytes_used + ink.bytes > budget) {
        auto oldest = cache.end();
        for (auto it = cache.begin(); it != cache.end(); ++it) {
            if (it->second.texture != gfx::kNullTexture && it->second.used < frame &&
                (oldest == cache.end() || it->second.used < oldest->second.used)) {
                oldest = it;
            }
        }
        if (oldest == cache.end()) {
            return nullptr; // everything cached is on screen this frame
        }
        gfx::DestroyTexture(oldest->second.texture);
        bytes_used -= oldest->second.bytes;
        cache.erase(oldest);
    }
    // White with the coverage as alpha and a clear border, so the draw's colour tints it and linear
    // sampling at the quad's edge reads nothing.
    std::vector<unsigned char> rgba(ink.bytes, 0);
    for (int row = 0; row < ink.height; ++row) {
        for (int col = 0; col < ink.width; ++col) {
            const auto target = (static_cast<std::size_t>(row + 1) * (ink.width + 2) + col + 1) * 4;
            rgba[target] = rgba[target + 1] = rgba[target + 2] = 255;
            rgba[target + 3] = coverage[static_cast<std::size_t>(row) * ink.width + col];
        }
    }
    gfx::TextureDesc desc;
    desc.width = static_cast<std::uint32_t>(ink.width + 2);
    desc.height = static_cast<std::uint32_t>(ink.height + 2);
    ink.texture = gfx::CreateTexture(desc);
    if (ink.texture == gfx::kNullTexture) {
        return nullptr;
    }
    gfx::UpdateTextureNow(ink.texture, 0, 0, 0, desc.width, desc.height, rgba.data());
    bytes_used += ink.bytes;
    ink.used = frame;
    return &cache.insert_or_assign(key, ink).first->second;
}

// Where a font cell's glyph lands: its character, its em and pen in target pixels, and the mapping
// back to vertex units.
struct Placement {
    char32_t            ch = 0;
    float               em_x = 0, em_y = 0;
    float               pen_px = 0, base_px = 0;
    float               px_x = 0, px_y = 0; // target pixels to a logical pixel
    gfx::LogicalMapping mapping{};
    gfx::Vertex2D       origin{};
};

// The font cell `uv` of the retail font page drawn into `dst` (both position and size) moved by
// (dx, dy) logical pixels, or nothing for a cell the bitmap keeps. A space places nothing either.
std::optional<Placement> Place(const mgCDrawPrim &prim, int x, int y, int w, int h, int u, int v, int u_w, int v_h,
                               float dx, float dy) {
    if (!ConfigGet().font_sharp || u_w <= 0 || v_h <= 0 || w <= 0 || h <= 0 || u % FONT_TEX_CHAR_W != 0 ||
        v % FONT_TEX_CHAR_H != 0 || v_h != FONT_TEX_CHAR_H) {
        return std::nullopt;
    }
    Placement out;
    const int font_no = v / FONT_TEX_CHAR_H * FONT_TEX_COLUMNS + u / FONT_TEX_CHAR_W;
    out.ch = dc2::font::Character(LanguageCode, font_no, LoadedTable());
    if (out.ch == 0 || !Ready()) {
        return std::nullopt;
    }
    const dc2::font::Page page = dc2::font::PageOf(LanguageCode);
    out.mapping = gfx::GetUiMapping(mgPortCurrentTarget());
    // Logical pixels a texel: retail stretches the cell's texels over dst.
    const float        texel_x = static_cast<float>(w) / static_cast<float>(u_w);
    const float        texel_y = static_cast<float>(h) / static_cast<float>(v_h);
    const float        pen_x = static_cast<float>(x) + pen_fraction + dx + page.pen_x * texel_x;
    const float        base_y = static_cast<float>(y) + dy + page.baseline * texel_y;
    const std::uint8_t none[4] = {};
    // Vertex units a logical pixel, and the pen in target pixels.
    out.origin = mgPortPrimVertex(prim, pen_x, base_y, 0, 0, 0, none);
    const gfx::Vertex2D step = mgPortPrimVertex(prim, pen_x + 1, base_y + 1, 0, 0, 0, none);
    out.px_x = (step.x - out.origin.x) * out.mapping.scale_x;
    out.px_y = (step.y - out.origin.y) * out.mapping.scale_y;
    out.em_x = kUnitsPerEm * page.texels_per_unit_x * texel_x * out.px_x;
    out.em_y = kUnitsPerEm * page.texels_per_unit_y * texel_y * out.px_y;
    out.pen_px = out.origin.x * out.mapping.scale_x + out.mapping.offset_x;
    out.base_px = std::round(out.origin.y * out.mapping.scale_y + out.mapping.offset_y);
    if (!std::isfinite(out.em_x) || !std::isfinite(out.em_y) || !std::isfinite(out.pen_px) ||
        !std::isfinite(out.base_px) || !(out.px_x > 0) || !(out.px_y > 0)) {
        return std::nullopt;
    }
    return out;
}

// Draws one layer of a placed glyph in a colour (alpha 0x80 opaque); false where it cannot be drawn.
bool Draw(mgCDrawPrim &prim, const Placement &at, Layer layer, std::uint8_t r, std::uint8_t g, std::uint8_t b,
          std::uint8_t a) {
    if (at.ch == 0x20 || at.ch == 0x3000) {
        return true;
    }
    const float pen_whole = std::floor(at.pen_px);
    const int   shift = std::min(kShiftSteps - 1, static_cast<int>((at.pen_px - pen_whole) * kShiftSteps));
    const bool  rim = layer != Layer::Fill;
    const Ink  *ink = GetInk({at.ch, static_cast<int>(std::lround(at.em_x * 16)), static_cast<int>(std::lround(at.em_y * 16)),
                              shift, layer, rim ? static_cast<int>(std::lround(at.px_x * 16)) : 0,
                              rim ? static_cast<int>(std::lround(at.px_y * 16)) : 0});
    if (!ink) {
        return false;
    }
    // The image sits on whole target pixels, so each texel lands on one pixel and nothing is resampled.
    auto vertex = [&](float px, float py, float u, float v) {
        gfx::Vertex2D out = at.origin;
        out.x = (px - at.mapping.offset_x) / at.mapping.scale_x;
        out.y = (py - at.mapping.offset_y) / at.mapping.scale_y;
        out.u = u;
        out.v = v;
        out.color[0] = r;
        out.color[1] = g;
        out.color[2] = b;
        out.color[3] = a;
        return out;
    };
    const float                        left = pen_whole + static_cast<float>(ink->x0 - 1);
    const float                        top = at.base_px + static_cast<float>(ink->y0 - 1);
    const auto                         w = static_cast<float>(ink->width + 2);
    const auto                         h = static_cast<float>(ink->height + 2);
    const std::array<gfx::Vertex2D, 4> quad = {vertex(left, top, 0, 0), vertex(left + w, top, w, 0),
                                               vertex(left + w, top + h, w, h), vertex(left, top + h, 0, h)};
    gfx::TextureBinding                binding;
    binding.texture = ink->texture;
    binding.filter = gfx::Filter::Linear;
    mgPortPrimSubmitTexture(prim, quad, binding);
    return true;
}

std::uint8_t Alpha(int alpha, float share) {
    return static_cast<std::uint8_t>(std::clamp(static_cast<int>(std::lround(alpha * share)), 0, 255));
}

// Draws the outline styles as rims, and the white-and-blue style's blue as one extrusion where retail
// stacks two copies; false leaves the style, or a cell the bitmap keeps, to retail, whose remaining
// shadows are copies of the glyph and so already reach the painter through set2DSpriteEasyFont.
bool DrawSharpFuchi(mgCDrawPrim &prim, const RECT &dst, const RECT &uv, int style, int alpha) {
    auto place = [&](float dx, float dy) {
        return Place(prim, dst.x, dst.y, dst.width, dst.height, uv.x, uv.y, uv.width, uv.height, dx, dy);
    };
    auto rim = [&](Layer layer) {
        const auto at = place(0, 0);
        return at && Draw(prim, *at, layer, 0, 0, 0, Alpha(alpha, dc2::text::OutlineAlpha(OutlineOf(layer))));
    };
    switch (style) {
        case FUCHI_OUTLINE:
            return rim(Layer::Thin);
        case FUCHI_OUTLINE_THICK:
            return rim(Layer::Thick);
        case FUCHI_OUTLINE_WIDE:
            return rim(Layer::Glow);
        case FUCHI_SHADOW_WHITE_BLUE: {
            const auto highlight = place(1, 1);
            if (!highlight) {
                return false;
            }
            Draw(prim, *highlight, Layer::Fill, 255, 255, 255, Alpha(alpha, 255.0f / 128.0f));
            // Retail's copies a pixel and two up-left, and the quarter pixels between: one solid block.
            for (int step = 4; step <= 8; ++step) {
                const float offset = -step / 4.0f;
                if (const auto at = place(offset, offset)) {
                    Draw(prim, *at, Layer::Fill, 42, 43, 49, Alpha(alpha, 1.0f));
                }
            }
            return true;
        }
        default:
            return false;
    }
}

} // namespace

namespace dc2::font {
char32_t Character(int language, int font_no, std::span<const std::uint8_t> table) {
    if (language < LANG_ENGLISH || language > LANG_SPANISH || font_no < 0) {
        return 0;
    }
    if (language != LANG_ENGLISH && font_no >= FONT_NO_ALPHABETICAL_TOP) {
        if (font_no >= FONT_NO_FONT_GAIJI_END) {
            return 0;
        }
        return font_no >= FONT_NO_FONT_GAIJI_TOP ? kFontGaiji[font_no - FONT_NO_FONT_GAIJI_TOP]
                                                 : kAccented[font_no - FONT_NO_ALPHABETICAL_TOP];
    }
    if (static_cast<std::size_t>(font_no) >= table.size() / 2) {
        return 0;
    }
    const auto first = table[static_cast<std::size_t>(font_no) * 2];
    const auto second = table[static_cast<std::size_t>(font_no) * 2 + 1];
    if (second == 0x20 && first >= 0x20 && first <= 0x7E) {
        return first;
    }
    if (language != LANG_ENGLISH) {
        return 0;
    }
    const auto  code = static_cast<std::uint16_t>(first << 8 | second);
    const auto *found = std::ranges::lower_bound(kEnglishSymbols, code, {}, &std::pair<std::uint16_t, char32_t>::first);
    return found != std::end(kEnglishSymbols) && found->first == code ? found->second : 0;
}

// From scripts/font/message_font.json, which fit_message_font.py measured: the European page draws the
// font's master space as it is (64 units a texel, baseline at row 16); the English page draws it taller
// and narrower, its "english_page" affine.
Page PageOf(int language) {
    if (language == LANG_ENGLISH) {
        return {.texels_per_unit_x = 0.955f / 64.0f, .texels_per_unit_y = 1.335f / 64.0f, .pen_x = -40.4f / 64.0f, .baseline = 17.0f + 20.0f / 64.0f};
    }
    return {.texels_per_unit_x = 1.0f / 64.0f, .texels_per_unit_y = 1.0f / 64.0f, .pen_x = 0.0f, .baseline = 16.0f};
}

const ttffont::Face *FaceOf(Typeface typeface) {
    struct Slot {
        const char   *file = nullptr;
        const char   *text = nullptr;
        bool          tried = false;
        ttffont::Face face;
    };

    static Slot slots[] = {
        {.file = "ChronicleTwoMessage-Regular.ttf", .text = "message text"        },
        {.file = "ChronicleTwoMenu-Regular.ttf",    .text = "menu lettering"      },
        {.file = "ChronicleTwoBoard-Regular.ttf",   .text = "time board lettering"},
        {.file = "ChronicleTwoTitle-Regular.ttf",   .text = "title lettering"     },
    };
    Slot &slot = slots[static_cast<int>(typeface)];
    if (!slot.tried) {
        slot.tried = true;
        const auto      file = PathsExecutable().parent_path() / "fonts" / slot.file;
        std::error_code error;
        if (std::filesystem::is_regular_file(file, error) && slot.face.Load(file)) {
            CT_LOG_INFO(Gfx, "font: {} from {}", slot.text, PathsDisplay(file));
        } else {
            CT_LOG_INFO(Gfx, "font: {} is missing; keeping the original {}", PathsDisplay(file), slot.text);
        }
    }
    return slot.face.Loaded() ? &slot.face : nullptr;
}

bool Proportional() { return ConfigGet().font_sharp && Ready(); }

float HalfAdvance(int font_no) {
    if (!Proportional()) {
        return 1.0f;
    }
    const char32_t ch = Character(LanguageCode, font_no, LoadedTable());
    float          em = 0.0f;
    if (ch == 0 || !FaceOf(Typeface::Message)->GetAdvance(ch, em)) {
        return 1.0f;
    }
    return em * kUnitsPerEm / kHalfWidth;
}

SubpixelPen::SubpixelPen(float fraction) : previous(pen_fraction) { pen_fraction = fraction; }

SubpixelPen::~SubpixelPen() { pen_fraction = previous; }

} // namespace dc2::font

void set2DSpriteEasyFont(mgCDrawPrim *prim, mgRect<int> dst, mgRect<int> uv, RGBAQ_TYPE *color) {
    if (const auto at = Place(*prim, dst.left, dst.top, dst.right, dst.bottom, uv.left, uv.top, uv.right, uv.bottom, 0, 0);
        at && Draw(*prim, *at, Layer::Fill, color->r, color->g, color->b, color->a)) {
        return;
    }
    uv.right += uv.left;
    uv.bottom += uv.top;
    uv.right += 1;
    uv.bottom += 1;
    dst.right += dst.left;
    dst.bottom += dst.top;
    prim->Color(color->r, color->g, color->b, color->a);
    prim->TextureCrd(uv.left, uv.top);
    prim->Vertex(dst.left, dst.top, 0);
    prim->TextureCrd(uv.right, uv.bottom);
    prim->Vertex(dst.right, dst.bottom, 0);
}

void set2DSprite_Fuchi(mgCDrawPrim *prim, RECT destination, RECT texture, int style, int alpha) {
    if (DrawSharpFuchi(*prim, destination, texture, style, alpha)) {
        return;
    }

    RGBAQ_TYPE color{};

    switch (style) {
        case FUCHI_NONE:
            break;
        case FUCHI_SHADOW_WHITE:
            color.r = color.g = color.b = 255;
            color.a = alpha * 64 / 128;
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x + 1, destination.y + 1, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            break;
        case FUCHI_SHADOW_BLACK:
            color.r = color.g = color.b = 0;
            color.a = alpha * 64 / 128;
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x + 1, destination.y + 1, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            break;
        case FUCHI_OUTLINE: {
            int offsets[4][2] = {
                {0,  -1},
                {0,  1 },
                {1,  0 },
                {-1, 0 }
            };

            for (int point = 0; point < 4; point++) {
                color.r = color.g = color.b = 0;
                color.a = alpha * 128 / 128;
                set2DSpriteEasyFont(prim,
                                    mgRect<int>(destination.x + offsets[point][0], destination.y + offsets[point][1],
                                                destination.width, destination.height),
                                    mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            }

            break;
        }
        case FUCHI_SHADOW_DOUBLE:
            color.r = color.g = color.b = 64;
            color.a = alpha * 128 / 128;
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x + 1, destination.y + 1, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            color.r = color.g = color.b = 0;
            color.a = alpha * 128 / 128;
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x + 2, destination.y + 2, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            break;
        case FUCHI_SHADOW_BLACK_WIDE:
            color.r = color.g = color.b = 0;
            color.a = alpha * 128 / 128;
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x + 2, destination.y + 2, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            break;
        case FUCHI_OUTLINE_WIDE: {
            int offsets[4][2] = {
                {0,  -2},
                {0,  2 },
                {2,  0 },
                {-2, 0 }
            };
            color.r = color.g = color.b = 0;
            color.a = alpha * 32 / 128;

            for (int point = 0; point < 4; point++) {
                set2DSpriteEasyFont(prim,
                                    mgRect<int>(destination.x + offsets[point][0], destination.y + offsets[point][1],
                                                destination.width, destination.height),
                                    mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            }

            break;
        }
        case FUCHI_SHADOW_WHITE_BLUE:
            color.r = 255;
            color.g = 255;
            color.b = 255;
            color.a = alpha * 255 / 128;
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x + 1, destination.y + 1, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            color.r = 42;
            color.g = 43;
            color.b = 49;
            color.a = alpha * 128 / 128;
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x - 1, destination.y - 1, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            set2DSpriteEasyFont(prim,
                                mgRect<int>(destination.x - 2, destination.y - 2, destination.width, destination.height),
                                mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            break;
        case FUCHI_OUTLINE_THICK: {
            int offsets[12][2] = {
                {0,  -1},
                {0,  1 },
                {1,  0 },
                {-1, 0 },
                {-1, -1},
                {-1, 1 },
                {1,  -1},
                {1,  1 },
                {0,  -2},
                {0,  2 },
                {2,  0 },
                {-2, 0 }
            };

            for (int point = 0; point < 12; point++) {
                color.r = color.g = color.b = 0;
                color.a = alpha * 128 / 128;
                set2DSpriteEasyFont(prim,
                                    mgRect<int>(destination.x + offsets[point][0], destination.y + offsets[point][1],
                                                destination.width, destination.height),
                                    mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            }

            break;
        }
    }
}

void CFont::DrawChar(mgCDrawPrim *prim, char *text, int x, int y) {

    DrawChar(prim, GetFontNo(text), x, y, 1, color, static_cast<int>(alpha));
}

void MySetTex(char *texture_name, mgCDrawPrim *prim) {
    prim->Texture(mgTexManager.GetTexture(texture_name, -1));
}

void MySetTex(int font_page, mgCDrawPrim *prim) {
    if ((font_page == 0) || (font_page == 1)) {
        prim->Texture(GetFontTexture(font_page));
    }
}

void DrawGaiji_sub(mgCDrawPrim *prim, int glyph, int x, int y, RGBAQ_TYPE color, int line_height) {
    mgRect<int> dst;
    mgRect<int> src;
    int         index = glyph - 0xFD00;

    if (LanguageCode != 0) {
        if (index + 0xFD00 == 0xFD06) {
            index = 8;
        } else if (index + 0xFD00 == 0xFD08) {
            index = 6;
        }
    }

    int width = GaijiDataTbl[index].w;
    int height = GaijiDataTbl[index].h;
    int offset_x = GaijiDataTbl[index].off_x;
    int offset_y = GaijiDataTbl[index].off_y;
    src.Set(GaijiDataTbl[index].u, GaijiDataTbl[index].v, width, height);
    dst.Set(x + offset_x, y + offset_y + (line_height - height) / 2, width, height);
    set2DSpriteEasy(prim, dst, src, &color);
}

void CFont::DrawGaiji(mgCDrawPrim *prim, int glyph, int x, int y) {
    RGBAQ_TYPE neutral{};
    MySetTex("gaiji", prim);
    neutral.a = 0x80;
    neutral.b = 0x80;
    neutral.g = 0x80;
    neutral.r = 0x80;
    DrawGaiji_sub(prim, glyph, x, y, neutral, clearance_h);
}

void UpDateWH(s32 *width, s32 *height, s32 new_width, s32 new_height) {
    if (*width < new_width) {
        *width = new_width;
    }

    if (*height < new_height) {
        *height = new_height;
    }
}

namespace {
// Retail's half-width advance, a whole number of pixels.
float HalfCell(int clearance_w) {
    const int half = clearance_w / 2;
    return static_cast<float>(half);
}
} // namespace

// Each half-width character advances by its own width in the message font (dc2::font::HalfAdvance). The pen runs
// between pixels; each glyph is drawn at the whole pixel left of it and carries the rest in a SubpixelPen. The width
// rounds up, so the text stays inside what was measured.
void CFont::CalcDrawWH(char *text, int *width, int *height) {
    const auto len = static_cast<int>(strlen(text));
    float      max_width = 0;
    int        max_height = 0;
    float      pen_x = 0;
    int        pen_y = 0;
    int        pos = 0;
    auto       reach = [&](int bottom) {
        max_width = std::max(max_width, pen_x);
        max_height = std::max(max_height, bottom);
    };

    while (pos < len) {
        char *cursor = &text[pos];

        if (const int font_no = dc2::font::AlphabeticalCode(std::string_view(cursor, static_cast<std::size_t>(len - pos)));
            0 < font_no) {
            pen_x += HalfCell(clearance_w) * dc2::font::HalfAdvance(font_no);
            pos += 9;
            reach(pen_y + clearance_h);
        } else if (const u16 gaiji = GetFontGaijiFontNo(cursor); gaiji != 0) {
            pen_x += GetFontGaijiHankaku(gaiji) != 0 ? HalfCell(clearance_w) : static_cast<float>(clearance_w);
            pos += 2;
            reach(pen_y + clearance_h);
        } else if (const u16 gaiji_no = GetGaijiFontNo(cursor); gaiji_no >= 0xFD00 && gaiji_no < 0xFD32) {
            pen_x += static_cast<float>(GetGaijiW(gaiji_no));
            pos += GetGaijiLen(gaiji_no);
            reach(pen_y + GetGaijiH(gaiji_no));
        } else if (const int half = GetHalfFontNo(*cursor); half == FONT_NO_NEWLINE) {
            pen_x = 0;
            pos += 1;
            pen_y += clearance_h;
        } else if (CheckHalfFont(half) != 0) {
            pen_x += HalfCell(clearance_w) * dc2::font::HalfAdvance(half);
            pos += 1;
            reach(pen_y + clearance_h);
        } else {
            pen_x += static_cast<float>(clearance_w);
            pos += 2;
            reach(pen_y + clearance_h);
        }
    }

    *width = static_cast<int>(std::ceil(max_width));
    *height = max_height;
}

void CFont::DrawDirect(char *text, int x, int y) {
    SetPos(x, y);

    mgCDrawPrim prim;

    MySetPrim(&prim, 1, 0);

    int height = fptosi(offset_y);
    prim.offset_x = fptosi(offset_x) * 16;
    prim.offset_y = height * 16;
    prim.Begin(MG_PRIM_SPRITE);
    const auto len = static_cast<int>(strlen(text));
    float      pen_x = 0;
    int        pen_y = 0;
    int        pos = 0;
    // Draws at the whole pixel left of the pen, carrying the rest to the painter.
    auto at_pen = [&](auto draw) {
        const float                  exact = static_cast<float>(pos_x) + pen_x;
        const int                    whole = static_cast<int>(std::floor(exact));
        const dc2::font::SubpixelPen kerned(exact - static_cast<float>(whole));
        draw(whole);
    };

    while (pos < len) {
        char *cursor = &text[pos];

        if (const int font_no = dc2::font::AlphabeticalCode(std::string_view(cursor, static_cast<std::size_t>(len - pos)));
            0 < font_no) {
            at_pen([&](int at) { DrawChar(&prim, font_no, at, pos_y + pen_y, 1, color, static_cast<int>(alpha)); });
            pen_x += HalfCell(clearance_w) * dc2::font::HalfAdvance(font_no);
            pos += 9;
        } else if (const u16 gaiji = GetFontGaijiFontNo(cursor); gaiji != 0) {
            at_pen([&](int at) { DrawChar(&prim, gaiji & 0xFFFF, at, pos_y + pen_y, 1, color, static_cast<int>(alpha)); });
            pen_x += GetFontGaijiHankaku(gaiji) != 0 ? HalfCell(clearance_w) : static_cast<float>(clearance_w);
            pos += 2;
        } else if (const u16 gaiji_no = GetGaijiFontNo(cursor); gaiji_no >= 0xFD00 && gaiji_no < 0xFD32) {
            at_pen([&](int at) { DrawGaiji(&prim, gaiji_no, at, pos_y + pen_y); });
            pen_x += static_cast<float>(GetGaijiW(gaiji_no));
            pos += GetGaijiLen(gaiji_no);
        } else if (const int half = GetHalfFontNo(*cursor); half == FONT_NO_NEWLINE) {
            pen_x = 0;
            pos += 1;
            pen_y += clearance_h;
        } else if (CheckHalfFont(half) != 0) {
            at_pen([&](int at) { DrawChar(&prim, half, at, pos_y + pen_y, 1, color, static_cast<int>(alpha)); });
            pen_x += HalfCell(clearance_w) * dc2::font::HalfAdvance(half);
            pos += 1;
        } else {
            at_pen([&](int at) { DrawChar(&prim, cursor, at, pos_y + pen_y); });
            pen_x += static_cast<float>(clearance_w);
            pos += 2;
        }
    }

    prim.End();
}

void CFont::Preset(s32 preset) {
    switch (preset) {
        case 0:
        case 1:
            this->SetColor(0x80202020U);
            SetFuchi(FUCHI_SHADOW_BLACK);
            break;
        case 2:
        case 3:
            this->SetColor(0x80686A6BU);
            SetFuchi(FUCHI_OUTLINE_THICK);
            break;
        case 4:
            this->SetColor(0x80686A6BU);
            SetFuchi(FUCHI_SHADOW_BLACK_WIDE);
            break;
    }
}

void CFont::Init() {
    memset(str, 0, sizeof(str));
    SetFuchi(FUCHI_OUTLINE);
    color.a = 0x80;
    color.b = 0x80;
    color.g = 0x80;
    color.r = 0x80;
    alpha = 0x80;
    pos_y = 0;
    pos_x = 0;
    clearance_w = 15;
    clearance_h = 24;
    draw_w = 16;
    draw_h = 20;
    mini = 0;
    offset_x = 0.0f;
    offset_y = 0.0f;
}

/**
 *
 * Gives the texture rectangle and drawing offset of each external glyph.
 *
 */
GAIJI_DATA GaijiDataTbl[GAIJI_DATA_NUM] = {
    {0xFD00, 12,  176, 86,  22, 0,  -4},
    {0xFD01, 0,   154, 110, 22, 0,  -4},
    {0xFD02, 32,  132, 32,  22, 0,  -4},
    {0xFD03, 64,  132, 32,  22, 0,  -4},
    {0xFD04, 0,   132, 32,  22, 0,  -4},
    {0xFD05, 96,  132, 32,  22, 0,  -4},
    {0xFD06, 0,   22,  22,  22, -1, -3},
    {0xFD07, 22,  22,  22,  22, -1, -3},
    {0xFD08, 66,  22,  22,  22, -1, -3},
    {0xFD09, 44,  22,  22,  22, -1, -3},
    {0xFD0A, 0,   66,  22,  22, -2, -2},
    {0xFD0B, 22,  66,  22,  22, -2, -2},
    {0xFD0C, 44,  66,  22,  22, -2, -2},
    {0xFD0D, 0,   88,  22,  22, -2, -4},
    {0xFD0E, 22,  88,  22,  22, -2, -4},
    {0xFD0F, 44,  88,  22,  22, -2, -4},
    {0xFD10, 66,  66,  22,  22, -2, -4},
    {0xFD11, 66,  88,  22,  22, -2, -4},
    {0xFD12, 0,   204, 26,  26, 0,  -4},
    {0xFD13, 26,  204, 26,  26, 0,  -4},
    {0xFD14, 0,   230, 26,  26, 0,  -4},
    {0xFD15, 26,  230, 26,  26, 0,  -4},
    {0xFD16, 230, 118, 26,  26, 0,  -4},
    {0xFD17, 22,  110, 66,  22, 8,  0 },
    {0xFD18, 0,   44,  56,  22, 0,  0 },
    {0xFD19, 88,  224, 40,  32, 0,  0 },
    {0xFD1A, 88,  22,  22,  22, -2, -4},
    {0xFD1B, 0,   0,   0,   0,  0,  0 },
    {0xFD1C, 0,   0,   0,   0,  0,  0 },
    {0xFD1D, 0,   0,   0,   0,  0,  0 },
    {0xFD1E, 0,   0,   0,   0,  0,  0 },
    {0xFD1F, 0,   0,   0,   0,  0,  0 },
    {0xFD20, 0,   0,   0,   0,  0,  0 },
    {0xFD21, 100, 44,  12,  18, -6, -3},
    {0xFD22, 168, 232, 16,  24, 0,  0 },
    {0xFD23, 184, 232, 8,   24, 0,  0 },
    {0xFD24, 132, 104, 10,  16, 0,  0 },
    {0xFD25, 158, 240, 10,  16, 0,  0 },
    {0xFD26, 128, 122, 26,  18, 0,  0 },
    {0xFD27, 154, 122, 26,  18, 0,  0 },
    {0xFD28, 132, 238, 26,  18, 0,  0 },
    {0xFD29, 136, 200, 28,  30, 0,  -4},
    {0xFD2A, 164, 200, 28,  30, 0,  -4},
    {0xFD2B, 224, 144, 16,  22, 0,  -2},
    {0xFD2C, 240, 144, 16,  22, 0,  -2},
    {0xFD2D, 176, 170, 16,  30, 0,  0 },
    {0xFD2E, 204, 118, 26,  26, 0,  -3},
    {0xFD2F, 148, 110, 28,  30, 0,  0 },
    {0xFD30, 176, 110, 28,  30, 0,  0 },
    {0xFD31, 208, 144, 16,  20, 0,  0 },
    {0xFFFF, 222, 118, 34,  32, 0,  0 },
};
/**
 *
 * Converts named text tags to external glyph codes.
 *
 */
FCONV_CODE FconvCodeTbl[FCONV_CODE_NUM] = {
    {"[select]",    8,  0xFD00},
    {"[start]",     7,  0xFD01},
    {"[l1]",        4,  0xFD02},
    {"[r1]",        4,  0xFD03},
    {"[l2]",        4,  0xFD04},
    {"[r2]",        4,  0xFD05},
    {"(O)",         3,  0xFD06},
    {"(A)",         3,  0xFD07},
    {"(X)",         3,  0xFD08},
    {"(#)",         3,  0xFD09},
    {"[+]",         3,  0xFD0A},
    {"[-]",         3,  0xFD0B},
    {"[|]",         3,  0xFD0C},
    {"[!]",         3,  0xFD0D},
    {"[heart]",     7,  0xFD0E},
    {"[clef]",      6,  0xFD0F},
    {"[dame]",      6,  0xFD10},
    {"[sita]",      6,  0xFD11},
    {"[weapon]",    8,  0xFD12},
    {"[protector]", 11, 0xFD13},
    {"[material]",  10, 0xFD14},
    {"[tool]",      6,  0xFD15},
    {"[parts]",     7,  0xFD16},
    {"[hari]",      6,  0xFD17},
    {"[button]",    8,  0xFD18},
    {"[fish]",      6,  0xFD19},
    {"[(!)]",       5,  0xFD1A},
    {"[bulb]",      6,  0xFD21},
    {"[*]",         3,  0xFD22},
    {"[|~]",        4,  0xFD23},
    {"[cross]",     7,  0xFD24},
    {"[|>]",        4,  0xFD25},
    {"[hp]",        4,  0xFD26},
    {"[mp]",        4,  0xFD27},
    {"[lv]",        4,  0xFD28},
    {"(L)",         3,  0xFD29},
    {"(R)",         3,  0xFD2A},
    {"[bulb2]",     7,  0xFD2B},
    {"[bulb3]",     7,  0xFD2C},
    {"[tuck]",      6,  0xFD2D},
    {"[spectrum]",  10, 0xFD2E},
    {"(L3)",        4,  0xFD2F},
    {"(R3)",        4,  0xFD30},
    {"(regi)",      6,  0xFD31},
    {nullptr,       0,  0x0000},
    {nullptr,       0,  0x0000},
};
/**
 *
 * Converts encoded font tags to language-specific glyph codes.
 *
 */
FCONV_CODE FontGaijiConvTbl[FONT_GAIJI_CONV_NUM] = {
    {"\x81\x9B", 2, 0xFDE0},
    {"\x81\x9C", 2, 0xFDE1},
    {"\x81\xAA", 2, 0xFDE2},
    {"\x81\xAB", 2, 0xFDE3},
    {"\x81\xA9", 2, 0xFDE4},
    {"\x81\xA8", 2, 0xFDE5},
    {"\x82O",    2, 0xFDE6},
    {"\x82P",    2, 0xFDE7},
    {"\x82Q",    2, 0xFDE8},
    {"\x82R",    2, 0xFDE9},
    {"\x82S",    2, 0xFDEA},
    {"\x82T",    2, 0xFDEB},
    {"\x82U",    2, 0xFDEC},
    {"\x82V",    2, 0xFDED},
    {"\x82W",    2, 0xFDEE},
    {"\x82X",    2, 0xFDEF},
    {"\x81"
     "F",
     2,             0xFDF0},
    {"\x81{",    2, 0xFDF1},
    {"\x81|",    2, 0xFDF2},
    {"\x81"
     "E",
     2,             0xFDF3},
    {"\x81g",    2, 0xFDF4},
    {"\x81h",    2, 0xFDF5},
    {"\x81"
     "e",
     2,             0xFDF6},
    {"\x81"
     "f",
     2,             0xFDF7},
};
/**
 *
 * Gives the alphabetical tag payload for each half-width glyph.
 *
 */
char alphabetical_chara_tbl[ALPHABETICAL_CHARA_NUM][ALPHABETICAL_CHARA_LEN] = {
    "0a1]",
    "0aa]",
    "0b0]",
    "0ba]",
    "0bf]",
    "0c0]",
    "0c1]",
    "0c2]",
    "0c3]",
    "0c4]",
    "0c5]",
    "0c6]",
    "0c7]",
    "0c8]",
    "0c9]",
    "0ca]",
    "0cb]",
    "0cc]",
    "0cd]",
    "0ce]",
    "0cf]",
    "0d1]",
    "0d2]",
    "0d3]",
    "0d4]",
    "0d5]",
    "0d6]",
    "0d9]",
    "0da]",
    "0db]",
    "0dc]",
    "0dd]",
    "0df]",
    "0e0]",
    "0e1]",
    "0e2]",
    "0e3]",
    "0e4]",
    "0e5]",
    "0e6]",
    "0e7]",
    "0e8]",
    "0e9]",
    "0ea]",
    "0eb]",
    "0ec]",
    "0ed]",
    "0ee]",
    "0ef]",
    "0f1]",
    "0f2]",
    "0f3]",
    "0f4]",
    "0f5]",
    "0f6]",
    "0f9]",
    "0fa]",
    "0fb]",
    "0fc]",
    "0fd]",
    "0ff]",
    "152]",
    "153]",
};

void CFont::DrawChar(mgCDrawPrim *prim, int font_no, int x, int y, int outline,
                     RGBAQ_TYPE glyph_color, u8 alpha) {
    if (font_no < 0) {
        return;
    }
    int  page = 0;
    RECT source = mini ? GetRectFontTexMini(font_no, &page) : GetRectFontTex(font_no, &page);
    if (mini) {
        MySetTexMini(page, prim);
    } else {
        MySetTex(page, prim);
    }
    RECT destination{.x = x, .y = y, .width = draw_w, .height = draw_h};
    if (CheckHalfFont(font_no)) {
        destination.width /= 2;
        source.width /= 2;
    }
    if (outline) {
        set2DSprite_Fuchi(prim, destination, source, fuchi, alpha);
    }
    glyph_color.a = alpha * glyph_color.a / 128;
    set2DSpriteEasyFont(prim, {destination.x, destination.y, destination.width, destination.height},
                        {source.x, source.y, source.width, source.height}, &glyph_color);
}
