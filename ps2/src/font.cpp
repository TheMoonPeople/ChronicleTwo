#include "common.h"
#include "font.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include <cstdio>
#include <cstring>

extern "C" void __ct__11mgCDrawPrimFv(void *);

struct GaijiCodeTable {
    u16 code[24];
};
struct HankakuKanaWideTable {
    u16 code[63];
};
struct HankakuKanaTable {
    u8 code[63];
};
extern mgRect<int> at_784__2;
extern char at_812__3[];
extern char at_813__3[];
extern char FontTblBinBuff[];
extern char at_848__4[];
extern char at_849__3[];
extern char at_850__3[];
extern char at_936__5[26];
extern HankakuKanaTable at_1041__5;
extern char at_1089[];
extern char at_1090[];
extern char at_1091[];
extern char at_1092[];
extern char at_1093__2[];
extern char at_1094[];
extern char at_1095__2[];
extern char at_1096[];
extern char at_1097[];
extern char at_1098[];
extern char at_1099[];
extern HankakuKanaWideTable at_1120;
extern GaijiCodeTable at_1137__2;
extern char at_988__4[];
extern char at_989__3[];
extern char at_990__4[];
extern char at_991__5[];
extern char at_992__4[];
extern char at_993__3[];
extern char at_994__3[];
extern char at_995__3[];
extern char at_996__3[];
extern char at_997__3[];
extern const unsigned char at_1543[6];
extern mgRect<int> at_817__4;
extern "C" int fptosi(float value);

// Code (.text)
int GetGaijiW(int code) {
    if (code >= GAIJI_CODE_TOP && code < GAIJI_CODE_END) {

        s16 *first_width = &GaijiDataTbl[0].w;
        return *(s16 *)((u8 *)first_width + (code - 0x8000 - 0x7D00) * sizeof(GAIJI_DATA));
    }
    return 0;
}
int GetGaijiH(int code) {
    if (code >= GAIJI_CODE_TOP && code < GAIJI_CODE_END) {

        s16 *first_height = &GaijiDataTbl[0].h;
        return *(s16 *)((u8 *)first_height + (code - 0x8000 - 0x7D00) * sizeof(GAIJI_DATA));
    }
    return 0;
}
extern "C" RECT GetRectFontTex__FiPi(int code, int *page) {
    int font = code;
    if (code >= 0xFDE0 && code < 0xFDF8) {
        if ((LanguageCode == 2 || LanguageCode == 3 || LanguageCode == 4) || LanguageCode == 5) {
            font = (u16)GetFontNoFromFontGaijiCode((u16)code);
        }
    }
    struct {
        int left;
        int top;
        int right;
        int bottom;
    } __attribute__((aligned(16))) rect = *(typeof(rect) *)&at_784__2;
    if (font < 0) {
        return *(RECT *)&rect;
    }
    if (font < 0x260) {
        *page = 0;
    } else if (font < 0x4C0) {
        *page = 1;
        font -= 0x260;
    } else if (font < 0x720) {
        *page = 2;
        font -= 0x4C0;
    } else if (font < 0x980) {
        *page = 3;
        font -= 0x720;
    } else {
        return *(RECT *)&rect;
    }
    rect.left = font % 32;
    rect.top = font / 32;
    rect.left *= 16;
    rect.top *= 20;
    rect.right = 16;
    rect.bottom = 20;
    return *(RECT *)&rect;
}
void MySetTexMini(int page, mgCDrawPrim *prim) {
    mgCTextureManager *texManager = &mgTexManager;
    if (page == 0) {
        prim->Texture(texManager->GetTexture(at_812__3, -1));
    } else {
        prim->Texture(texManager->GetTexture(at_813__3, -1));
    }
}
RECT GetRectFontTexMini(int code, int *page) {
    return *(RECT *)&at_817__4;
}
#pragma global_optimizer off
char *My_strncpy(char *dst, const char *src, u32 count) {
    s8 *out = (s8 *)dst;
    const s8 *in = (const s8 *)src;
    u32 i = 0;
    s8 c;
    while (i < count) {
        if (*in == '[') {
            while ((c = *in) != ']') {
                *out = c;
                out++;
                in++;
            }
        }
        i++;
        *out = *in;
        in++;
        out++;
    }
    return dst;
}
#pragma global_optimizer reset
u8 *GetYoyakuTblTop() {
    return (u8 *)((FONT_TBL_BIN *)FontTblBinBuff)->yoyaku_tbl;
}
int LoadFontTblBin() {
    int size;
    if (LanguageCode == 1) {
        LoadFile(at_848__4, FontTblBinBuff, &size);
    } else {
        LoadFile(at_849__3, FontTblBinBuff, &size);
    }
    if (size > 0x1000) {
        printf(at_850__3);
        return 0;
    }
    return 1;
}
int GetYoyakuTblNum() {
    return ((FONT_TBL_BIN *)FontTblBinBuff)->yoyaku_num;
}
int GetKanjiTopNo() {
    return ((FONT_TBL_BIN *)FontTblBinBuff)->kanji_top_no;
}
int GetHalfFontNum() {
    u16 *p = (u16 *)FontTblBinBuff;
    return *p;
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
    memset(this->str, 0, 0x80);
    if (strlen(text) >= 0x80U) {
        printf(at_936__5);
        return;
    }
    strcpy(this->str, text);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/font", GetGaijiFontNo__FPc);
int GetGaijiLen(u16 code) {
    int found = -1;
    int i;
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
    HankakuKanaTable table = at_1041__5;
    int i;
    if (LanguageCode == 1) {
        return 0;
    }
    u8 key;
    if (ch == 0x9C) {
        key = 0xBE;
    } else
        key = ch;
    for (i = 0; i < 63; i++) {
        if (key == table.code[i]) {
            return i + 0x5E;
        }
    }
    return 0;
}
u16 GetAlphabeticalFontNo_cp(char *text) {
    char code[12];
    int i;
    if (LanguageCode == 1) {
        return 0;
    }
    if (strncmp(text, at_1089, 5) != 0) {
        return 0;
    }
    strncpy(code, text + 5, 5);
    if (strncmp(code, at_1090, 4) == 0) {
        strncpy(code, at_1091, 4);
    }
    if (strncmp(code, at_1092, 4) == 0) {
        strncpy(code, at_1093__2, 4);
    }
    if (strncmp(code, at_1094, 4) == 0) {
        strncpy(code, at_1095__2, 4);
    }
    if (strncmp(code, at_1096, 4) == 0) {
        strncpy(code, at_1097, 4);
    }
    if (strncmp(code, at_1098, 4) == 0) {
        strncpy(code, at_1099, 4);
    }
    for (i = 0; i < 63; i++) {
        if (strncmp(code, alphabetical_chara_tbl[i], 4) == 0) {
            return i + 0x5E;
        }
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/font", GetFontGaijiFontNo__FPc);
u16 GetAlphabeticalFontNo_us(u16 code) {
    HankakuKanaWideTable table = at_1120;
    int i;
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
    GaijiCodeTable table = at_1137__2;
    int i;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/font", GetFontGaijiHankaku__FUs);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/font", GetFontNo__FPc);
extern "C" int GetHalfFontNo__Fc(int ch) {
    char buf[8];
    u16 no = GetAlphabeticalFontNo_uc(ch & 0xFF);
    if (no != 0)
        return no & 0xFFFF;
    buf[1] = 0x20;
    buf[0] = ch;
    return GetFontNo(buf);
}
int CFont::GetDigitNo(int font_no) {
    if (font_no == GetFontNo(at_989__3)) {
        return 1;
    }
    if (font_no == GetFontNo(at_990__4)) {
        return 2;
    }
    if (font_no == GetFontNo(at_991__5)) {
        return 3;
    }
    if (font_no == GetFontNo(at_992__4)) {
        return 4;
    }
    if (font_no == GetFontNo(at_993__3)) {
        return 5;
    }
    if (font_no == GetFontNo(at_994__3)) {
        return 6;
    }
    if (font_no == GetFontNo(at_995__3)) {
        return 7;
    }
    if (font_no == GetFontNo(at_996__3)) {
        return 8;
    }
    if (font_no == GetFontNo(at_997__3)) {
        return 9;
    }
    if (font_no == GetFontNo(at_988__4)) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/font", set2DSprite_Fuchi__FP11mgCDrawPrim4RECT4RECTii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/font", DrawChar__5CFontFP11mgCDrawPrimiiii10RGBAQ_TYPEUc);
void CFont::DrawChar(mgCDrawPrim *prim, char *text, int x, int y) {

    DrawChar(prim, GetFontNo(text), x, y, 1, color, (int)alpha);
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
    int index = glyph - 0xFD00;
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
    RGBAQ_TYPE neutral;
    MySetTex((char *)at_1543, prim);
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
    int *height_out = height;
    int len = strlen(text);
    int max_width = 0;
    int max_height = 0;
    int pen_x = 0;
    int pen_y = 0;
    int pos = 0;
    s8 *cursor;
    int font_no;
    u16 gaiji_no;
    u16 gaiji;
    int half;
    if (0 < len) {
        do {
            cursor = (s8 *)text + pos;
            if (0 < GetAlphabeticalFontNo_cp((char *)cursor)) {
                pen_x += clearance_w / 2;
                pos += 9;
                UpDateWH(&max_width, &max_height, pen_x, pen_y + clearance_h);
            } else {
                gaiji = GetFontGaijiFontNo((char *)cursor);
                if (gaiji != 0) {
                    if (GetFontGaijiHankaku(gaiji) != 0) {
                        pen_x += clearance_w / 2;
                    } else {
                        pen_x += clearance_w;
                    }
                    pos += 2;
                    UpDateWH(&max_width, &max_height, pen_x, pen_y + clearance_h);
                } else {
                    gaiji_no = GetGaijiFontNo((char *)cursor);
                    if (gaiji_no >= 0xFD00 && gaiji_no < 0xFD32) {
                        pen_x += GetGaijiW(gaiji_no);
                        pos += GetGaijiLen(gaiji_no);
                        UpDateWH(&max_width, &max_height, pen_x, pen_y + GetGaijiH(gaiji_no));
                    } else {
                        half = GetHalfFontNo__Fc(*cursor);
                        if (half == -2) {
                            pen_x = 0;
                            pos += 1;
                            pen_y += clearance_h;
                        } else if (CheckHalfFont(half) != 0) {
                            pen_x += clearance_w / 2;
                            pos += 1;
                            UpDateWH(&max_width, &max_height, pen_x, pen_y + clearance_h);
                        } else {
                            if (CheckKanjiFont(GetFontNo((char *)cursor)) != 0) {
                                pen_x += clearance_w;
                            } else if (CheckKanjiFont(GetFontNo((char *)cursor + 2)) != 0) {
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
#pragma optimization_level 4
void CFont::DrawDirect(char *text, int x, int y) {
    SetPos(x, y);
    union {
        mgCDrawPrim prim;
        struct {
            u8 padding[0x110];
            int size_x;
            int size_y;
            u8 tail[8];
        } sizes;
    } local;
    MySetPrim(&local.prim, 1, 0);

    int height = fptosi(*(float *)((u8 *)this + 0xB4));
    local.sizes.size_x = fptosi(*(float *)((u8 *)this + 0xB0)) * 16;
    local.sizes.size_y = height * 16;
    (&local.prim)->Begin(6);
    int len = strlen(text);
    int pen_x = 0;
    int pen_y = 0;
    int pos = 0;
    u16 gaiji_no;
    u16 gaiji;
    int font_no;
    int half;
    s8 *cursor;
    if (0 < len) {
        do {
            cursor = (s8 *)text + pos;
            font_no = GetAlphabeticalFontNo_cp((char *)cursor);
            if (0 < font_no) {
                DrawChar(&local.prim, font_no, pos_x + pen_x, pos_y + pen_y, 1, color, (int)alpha);
                pen_x += clearance_w / 2;
                pos += 9;
            } else {
                gaiji = GetFontGaijiFontNo((char *)cursor);
                if (gaiji != 0) {
                    DrawChar(&local.prim, gaiji & 0xFFFF, pos_x + pen_x, pos_y + pen_y, 1, color,
                             (int)alpha);
                    if (GetFontGaijiHankaku(gaiji) != 0) {
                        pen_x += clearance_w / 2;
                    } else {
                        pen_x += clearance_w;
                    }
                    pos += 2;
                } else {
                    gaiji_no = GetGaijiFontNo((char *)cursor);
                    if (gaiji_no >= 0xFD00 && gaiji_no < 0xFD32) {
                        DrawGaiji(&local.prim, gaiji_no, pos_x + pen_x, pos_y + pen_y);
                        pen_x += GetGaijiW(gaiji_no);
                        pos += GetGaijiLen(gaiji_no);
                    } else {
                        half = GetHalfFontNo__Fc(*cursor);
                        if (half == -2) {
                            pen_x = 0;
                            pos += 1;
                            pen_y += clearance_h;
                        } else if (CheckHalfFont(half) != 0) {
                            DrawChar(&local.prim, half, pos_x + pen_x, pos_y + pen_y, 1, color,
                                     (int)alpha);
                            pen_x += clearance_w / 2;
                            pos += 1;
                        } else {
                            DrawChar(&local.prim, (char *)cursor, pos_x + pen_x, pos_y + pen_y);
                            if (CheckKanjiFont(GetFontNo((char *)cursor)) != 0) {
                                pen_x += clearance_w;
                            } else if (CheckKanjiFont(GetFontNo((char *)cursor + 2)) != 0) {
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
    (&local.prim)->End();
}
#pragma optimization_level reset
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
    unk_b0 = 0.0f;
    unk_b4 = 0.0f;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", GaijiDataTbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", FconvCodeTbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", FontGaijiConvTbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", alphabetical_chara_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1041__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1120__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1137__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1255__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1264__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1272__2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_812__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_813__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_848__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_849__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_850__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_936__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_938__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_939__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_940__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_941__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_942__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_943__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_944__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_945__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_946__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_947__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_948__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_949__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_950__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_951__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_952__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_953__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_954__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_955__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_956__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_957__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_958__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_959__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_960__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_961__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_962__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_963__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_964__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_965__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_966__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_967__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_968__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_969__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_970__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_971__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_972__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_973__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_974__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_975__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_976__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_977__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_978__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_979__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_980__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_981__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_982__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_983__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_984__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_985__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_986__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_987__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_988__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_989__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_990__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_991__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_992__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_993__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_994__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_995__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_996__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_997__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_998__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_999__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1000__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1001__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1002__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1003__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1004__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1005__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1089__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1090__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1091__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1092__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1093__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1094__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1095__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1096__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1097__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1098__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1099__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1448__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/font", at_1543__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(FontTblBinBuff, 0x1000);
INCLUDE_BSS(at_784__2, 0x10);
INCLUDE_BSS(at_817__4, 0x10);
INCLUDE_BSS(at_1466__6, 0x10);
