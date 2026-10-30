#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <map>
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
#include "text/glyph_mapping.hpp"

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

u16 GetAlphabeticalFontNo_cp(char *text) {
    char code[12];
    int  i = {};

    if (LanguageCode == 1) {
        return 0;
    }

    if (strncmp(text, "[UNI0", 5) != 0) {
        return 0;
    }

    strncpy(code, &text[5], 5);

    if (strncmp(code, "11d]", 4) == 0) {
        strncpy(code, "0e8]", 4);
    }

    if (strncmp(code, "129]", 4) == 0) {
        strncpy(code, "0ea]", 4);
    }

    if (strncmp(code, "155]", 4) == 0) {
        strncpy(code, "0e0]", 4);
    }

    if (strncmp(code, "171]", 4) == 0) {
        strncpy(code, "0fb]", 4);
    }

    if (strncmp(code, "17f]", 4) == 0) {
        strncpy(code, "0f9]", 4);
    }

    for (i = 0; i < 63; i++) {
        if (strncmp(code, alphabetical_chara_tbl[i], 4) == 0) {
            return i + 0x5E;
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

void set2DSpriteEasyFont(mgCDrawPrim *prim, mgRect<int> dst, mgRect<int> uv, RGBAQ_TYPE *color) {
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

void CFont::CalcDrawWH(char *text, int *width, int *height) {
    int  *height_out = height;
    int   len = strlen(text);
    int   max_width = 0;
    int   max_height = 0;
    int   pen_x = 0;
    int   pen_y = 0;
    int   pos = 0;
    char *cursor = {};
    int   font_no = {};
    u16   gaiji_no = {};
    u16   gaiji = {};
    int   half = {};

    if (0 < len) {
        do {
            cursor = &text[pos];

            if (0 < GetAlphabeticalFontNo_cp(cursor)) {
                pen_x += clearance_w / 2;
                pos += 9;
                UpDateWH(&max_width, &max_height, pen_x, pen_y + clearance_h);
            } else {
                gaiji = GetFontGaijiFontNo(cursor);

                if (gaiji != 0) {
                    if (GetFontGaijiHankaku(gaiji) != 0) {
                        pen_x += clearance_w / 2;
                    } else {
                        pen_x += clearance_w;
                    }

                    pos += 2;
                    UpDateWH(&max_width, &max_height, pen_x, pen_y + clearance_h);
                } else {
                    gaiji_no = GetGaijiFontNo(cursor);

                    if (gaiji_no >= 0xFD00 && gaiji_no < 0xFD32) {
                        pen_x += GetGaijiW(gaiji_no);
                        pos += GetGaijiLen(gaiji_no);
                        UpDateWH(&max_width, &max_height, pen_x, pen_y + GetGaijiH(gaiji_no));
                    } else {
                        half = GetHalfFontNo(*cursor);

                        if (half == -2) {
                            pen_x = 0;
                            pos += 1;
                            pen_y += clearance_h;
                        } else if (CheckHalfFont(half) != 0) {
                            pen_x += clearance_w / 2;
                            pos += 1;
                            UpDateWH(&max_width, &max_height, pen_x, pen_y + clearance_h);
                        } else {
                            if (CheckKanjiFont(GetFontNo(cursor)) != 0) {
                                pen_x += clearance_w;
                            } else if (CheckKanjiFont(GetFontNo(&cursor[2])) != 0) {
                                pen_x += clearance_w;
                            } else {
                                pen_x += clearance_w;
                            }

                            pos += 2;
                            UpDateWH(&max_width, &max_height, pen_x, pen_y + clearance_h);
                        }
                    }
                }
            }
        } while (pos < len);
    }

    *width = max_width;
    *height_out = max_height;
}

void CFont::DrawDirect(char *text, int x, int y) {
    SetPos(x, y);

    mgCDrawPrim prim;

    MySetPrim(&prim, 1, 0);

    int height = fptosi(offset_y);
    prim.offset_x = fptosi(offset_x) * 16;
    prim.offset_y = height * 16;
    prim.Begin(MG_PRIM_SPRITE);
    int   len = strlen(text);
    int   pen_x = 0;
    int   pen_y = 0;
    int   pos = 0;
    u16   gaiji_no = {};
    u16   gaiji = {};
    int   font_no = {};
    int   half = {};
    char *cursor = {};

    if (0 < len) {
        do {
            cursor = &text[pos];
            font_no = GetAlphabeticalFontNo_cp(cursor);

            if (0 < font_no) {
                DrawChar(&prim, font_no, pos_x + pen_x, pos_y + pen_y, 1, color, static_cast<int>(alpha));
                pen_x += clearance_w / 2;
                pos += 9;
            } else {
                gaiji = GetFontGaijiFontNo(cursor);

                if (gaiji != 0) {
                    DrawChar(&prim, gaiji & 0xFFFF, pos_x + pen_x, pos_y + pen_y, 1, color,
                             static_cast<int>(alpha));

                    if (GetFontGaijiHankaku(gaiji) != 0) {
                        pen_x += clearance_w / 2;
                    } else {
                        pen_x += clearance_w;
                    }

                    pos += 2;
                } else {
                    gaiji_no = GetGaijiFontNo(cursor);

                    if (gaiji_no >= 0xFD00 && gaiji_no < 0xFD32) {
                        DrawGaiji(&prim, gaiji_no, pos_x + pen_x, pos_y + pen_y);
                        pen_x += GetGaijiW(gaiji_no);
                        pos += GetGaijiLen(gaiji_no);
                    } else {
                        half = GetHalfFontNo(*cursor);

                        if (half == -2) {
                            pen_x = 0;
                            pos += 1;
                            pen_y += clearance_h;
                        } else if (CheckHalfFont(half) != 0) {
                            DrawChar(&prim, half, pos_x + pen_x, pos_y + pen_y, 1, color,
                                     static_cast<int>(alpha));
                            pen_x += clearance_w / 2;
                            pos += 1;
                        } else {
                            DrawChar(&prim, cursor, pos_x + pen_x, pos_y + pen_y);

                            if (CheckKanjiFont(GetFontNo(cursor)) != 0) {
                                pen_x += clearance_w;
                            } else if (CheckKanjiFont(GetFontNo(&cursor[2])) != 0) {
                                pen_x += clearance_w;
                            } else {
                                pen_x += clearance_w;
                            }

                            pos += 2;
                        }
                    }
                }
            }
        } while (pos < len);
    }

    (&prim)->End();
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

char32_t FontPortCharacter(int language, int glyph, std::span<const std::uint8_t> table) {
    if (language == LANG_JAPANESE || glyph < 0 || glyph >= FONT_NO_ALPHABETICAL_TOP ||
        static_cast<std::size_t>(glyph) >= table.size() / 2) {
        return 0;
    }
    const auto first = table[static_cast<std::size_t>(glyph) * 2];
    const auto second = table[static_cast<std::size_t>(glyph) * 2 + 1];
    return first >= 0x20 && first <= 0x7e && second == 0x20 ? first : 0;
}

namespace {

bool Ready() {
    static bool tried = false;
    static bool loaded = false;
    if (!tried) {
        tried = true;
        const std::array roots = {PathsSaveRoot(), PathsExecutable().parent_path()};
        for (const auto &root : roots) {
            const auto      file = root / "lang" / "font.ttf";
            std::error_code error;
            if (!std::filesystem::is_regular_file(file, error)) {
                continue;
            }
            // This opt-in path accepts a trusted user font. The shared rasterizer is not a font validator.
            const auto bytes = std::filesystem::file_size(file, error);
            if (!error && bytes >= 12 && bytes <= 32 * 1024 * 1024) {
                loaded = ttffont::Load(file);
            }
            if (loaded) {
                CT_LOG_INFO(Gfx, "font: sharp ASCII text from {}", PathsDisplay(file));
            }
            break; // A present save override wins, including when it cannot be loaded.
        }
        if (!loaded) {
            CT_LOG_INFO(Gfx, "font: no usable lang/font.ttf; keeping original text (docs/PC.md)");
        }
    }
    return loaded;
}

struct Ink {
    gfx::TextureHandle texture = gfx::kNullTexture;
    int                width = 0, height = 0, x = 0, y = 0;
};

// Immutable images avoid overwriting any glyph a recorded or interpolated frame still references.
// RendererShutdown releases them. No runtime font reload or eviction; allocation failure keeps retail.
const Ink *GetInk(char32_t ch, int pixels) {
    static std::map<std::pair<char32_t, int>, Ink> cache;
    static std::size_t                             bytes_used = 0;
    constexpr std::size_t                          budget = 16 * 1024 * 1024;
    const auto                                     key = std::make_pair(ch, pixels);
    if (const auto found = cache.find(key); found != cache.end()) {
        return found->second.texture == gfx::kNullTexture ? nullptr : &found->second;
    }
    if (cache.size() >= 2048) {
        return nullptr;
    }
    Ink                        ink;
    std::vector<unsigned char> coverage;
    if (!ttffont::RenderGlyph(ch, pixels, coverage, ink.width, ink.height, ink.x, ink.y) ||
        ink.width <= 0 || ink.height <= 0 || ink.width > 512 || ink.height > 512) {
        cache.emplace(key, ink);
        return nullptr;
    }
    const auto bytes = static_cast<std::size_t>(ink.width + 2) * (ink.height + 2) * 4;
    if (bytes > budget - bytes_used) {
        cache.emplace(key, ink);
        return nullptr;
    }
    std::vector<unsigned char> rgba(bytes, 0);
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
    if (ink.texture != gfx::kNullTexture) {
        gfx::UpdateTextureNow(ink.texture, 0, 0, 0, desc.width, desc.height, rgba.data());
        bytes_used += bytes;
    }
    const auto [entry, inserted] = cache.emplace(key, ink);
    return entry->second.texture == gfx::kNullTexture ? nullptr : &entry->second;
}

bool DrawSharp(const CFont &font, mgCDrawPrim &prim, int glyph, int x, int y, int outline,
               RGBAQ_TYPE color, unsigned char alpha) {
    if (!ConfigGet().font_sharp || font.mini != 0 || font.draw_w <= 0 || font.draw_h <= 0) {
        return false;
    }
    const int      count = std::clamp(GetYoyakuTblNum(), 0, 0x7fc);
    const char32_t ch = FontPortCharacter(LanguageCode, glyph, {GetYoyakuTblTop(), static_cast<std::size_t>(count) * 2});
    if (ch == 0 || !Ready()) {
        return false;
    }
    if (ch == 0x20) {
        return true;
    }
    const auto  cell_w = static_cast<float>(font.draw_w / 2);
    const auto  cell_h = static_cast<float>(font.draw_h);
    const auto  metrics = ttffont::GetMetrics();
    const float line = metrics.ascent + metrics.descent;
    if (!(line > 0.0f) || !(metrics.advance > 0.0f) || cell_w <= 0.0f) {
        return false;
    }
    const float em = std::min(cell_h * 0.9f / line, cell_w / metrics.advance);
    const auto  mapping = gfx::GetUiMapping(mgPortCurrentTarget());
    const float scale = std::max(mapping.scale_x, mapping.scale_y);
    if (!(em > 0.0f) || !std::isfinite(em) || !std::isfinite(scale) || !(scale > 0.0f)) {
        return false;
    }
    // Round up to a small bucket: at least one raster pixel per output pixel, few resize cache entries.
    const int pixels = static_cast<int>(std::ceil(std::min(em * scale, 512.0f) / 8.0f)) * 8;
    if (pixels < 8 || em * scale > 512.0f) {
        return false;
    }
    const Ink *ink = GetInk(ch, pixels);
    if (!ink) {
        return false;
    }
    const float unit = em / pixels;
    const float ink_w = ink->width * unit;
    const float width = std::min(cell_w, ink_w);
    const float height = ink->height * unit;
    // One common baseline; fit ink into the cell without using TTF advances to move the game pen.
    const float                left = x + (cell_w - width) * 0.5f;
    const float                top = y + (cell_h - em * line) * 0.5f + em * metrics.ascent + ink->y * unit;
    std::vector<gfx::Vertex2D> quads;
    quads.reserve(52);
    auto quad = [&](float dx, float dy, int r, int g, int b, int a) {
        const std::uint8_t tint[] = {static_cast<std::uint8_t>(r), static_cast<std::uint8_t>(g),
                                     static_cast<std::uint8_t>(b), static_cast<std::uint8_t>(a)};
        auto               vertex = [&](float px, float py, float u, float v) {
            quads.push_back(mgPortPrimVertex(prim, px + dx, py + dy, 0, u, v, tint));
        };
        vertex(left, top, 1, 1);
        vertex(left + width, top, 1 + ink->width, 1);
        vertex(left + width, top + height, 1 + ink->width, 1 + ink->height);
        vertex(left, top + height, 1, 1 + ink->height);
    };
    auto cross = [&](int distance, int opacity) {
        quad(0, -distance, 0, 0, 0, opacity);
        quad(0, distance, 0, 0, 0, opacity);
        quad(distance, 0, 0, 0, 0, opacity);
        quad(-distance, 0, 0, 0, 0, opacity);
    };
    if (outline != 0) {
        switch (font.fuchi) {
            case FUCHI_SHADOW_WHITE:
                quad(1, 1, 255, 255, 255, alpha * 64 / 128);
                break;
            case FUCHI_SHADOW_BLACK:
                quad(1, 1, 0, 0, 0, alpha * 64 / 128);
                break;
            case FUCHI_OUTLINE:
                cross(1, alpha);
                break;
            case FUCHI_SHADOW_DOUBLE:
                quad(1, 1, 64, 64, 64, alpha);
                quad(2, 2, 0, 0, 0, alpha);
                break;
            case FUCHI_SHADOW_BLACK_WIDE:
                quad(2, 2, 0, 0, 0, alpha);
                break;
            case FUCHI_OUTLINE_WIDE:
                cross(2, alpha * 32 / 128);
                break;
            case FUCHI_SHADOW_WHITE_BLUE:
                quad(1, 1, 255, 255, 255, alpha * 255 / 128);
                quad(-1, -1, 42, 43, 49, alpha);
                quad(-2, -2, 42, 43, 49, alpha);
                break;
            case FUCHI_OUTLINE_THICK:
                cross(1, alpha);
                quad(-1, -1, 0, 0, 0, alpha);
                quad(-1, 1, 0, 0, 0, alpha);
                quad(1, -1, 0, 0, 0, alpha);
                quad(1, 1, 0, 0, 0, alpha);
                cross(2, alpha);
                break;
        }
    }
    quad(0, 0, color.r, color.g, color.b, alpha * color.a / 128);
    gfx::TextureBinding binding;
    binding.texture = ink->texture;
    mgPortPrimSubmitTexture(prim, quads, binding);
    return true;
}

} // namespace

void CFont::DrawChar(mgCDrawPrim *prim, int font_no, int x, int y, int outline,
                     RGBAQ_TYPE glyph_color, u8 alpha) {
    if (font_no < 0) {
        return;
    }
    if (DrawSharp(*this, *prim, font_no, x, y, outline, glyph_color, alpha)) {
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
