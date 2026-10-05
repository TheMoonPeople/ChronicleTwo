#include "common.h"
#include "mg_math.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_memory.hpp"
#include "dbg_font.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include <cstdio>
#include <cstring>


// Code (.text)
unsigned long SjisToJis(unsigned long sjis) {
    unsigned long hi = (sjis >> 8) & 0xFF;
    unsigned long lo = sjis & 0xFF;

    if (hi >= 0x81 && hi < 0xA0) {
        hi -= 0x81;
    } else if (hi >= 0xE0 && hi < 0xF0) {
        hi += 0xFFFFFFFFFFFFFF3FUL;
    }
    hi <<= 1;
    if (lo >= 0x40 && lo < 0x7F) {
        lo -= 0x40;
    } else if (lo >= 0x80 && lo < 0x9F) {
        lo += 0xFFFFFFFFFFFFFFBFUL;
    } else if (lo >= 0x9F && lo < 0xFD) {
        lo -= 0x9F;
        hi += 1;
    }
    return ((hi + 1) << 8) + lo + 0x2021;
}
unsigned long SjisToSerno(unsigned long sjis) {
    unsigned long jis = SjisToJis(sjis);
    unsigned long offset = 0xFFFFFFFFFFFFFFDFUL;
    unsigned long row = (jis >> 8) + offset;

    return row * 94 + ((jis & 0xFF) + offset);
}
int ascii2serno(u8 ch) {
    int code;

    code = ch & 0xFF;
    switch (code) {
        case 0xA1:
            return 0x212C;
        case 0xA2:
            return 0x215F;
        case 0xA3:
            return 0x2160;
        case 0xA4:
            return 0x212B;
        case 0xA5:
            return 0x212F;
        case 0xDE:
            return 0x2134;
        case 0xDF:
            return 0x2135;
        case 0xA7:
            return 0x21E6;
        case 0xA8:
            return 0x21E8;
        case 0xA9:
            return 0x21EA;
        case 0xAA:
            return 0x21EC;
        case 0xAB:
            return 0x21EE;
        case 0xAC:
            return 0x2228;
        case 0xAD:
            return 0x222A;
        case 0xAE:
            return 0x222C;
        case 0xAF:
            return 0x2208;
        case 0xB1:
            return 0x21E7;
        case 0xB2:
            return 0x21E9;
        case 0xB3:
            return 0x21EB;
        case 0xB4:
            return 0x21ED;
        case 0xB5:
            return 0x21EF;
        case 0xB6:
            return 0x21F0;
        case 0xB7:
            return 0x21F2;
        case 0xB8:
            return 0x21F4;
        case 0xB9:
            return 0x21F6;
        case 0xBA:
            return 0x21F8;
        case 0xBB:
            return 0x21FA;
        case 0xBC:
            return 0x21FC;
        case 0xBD:
            return 0x21FE;
        case 0xBE:
            return 0x2200;
        case 0xBF:
            return 0x2202;
        case 0xC0:
            return 0x2204;
        case 0xC1:
            return 0x2206;
        case 0xC2:
            return 0x2209;
        case 0xC3:
            return 0x220B;
        case 0xC4:
            return 0x220D;
        case 0xC5:
            return 0x220F;
        case 0xC6:
            return 0x2210;
        case 0xC7:
            return 0x2211;
        case 0xC8:
            return 0x2212;
        case 0xC9:
            return 0x2213;
        case 0xCA:
            return 0x2214;
        case 0xCB:
            return 0x2217;
        case 0xCC:
            return 0x221A;
        case 0xCD:
            return 0x221D;
        case 0xCE:
            return 0x2220;
        case 0xCF:
            return 0x2223;
        case 0xD0:
            return 0x2224;
        case 0xD1:
            return 0x2225;
        case 0xD2:
            return 0x2226;
        case 0xD3:
            return 0x2227;
        case 0xD4:
            return 0x2229;
        case 0xD5:
            return 0x222B;
        case 0xD6:
            return 0x222D;
        case 0xD7:
            return 0x222E;
        case 0xD8:
            return 0x222F;
        case 0xD9:
            return 0x2230;
        case 0xDA:
            return 0x2231;
        case 0xDB:
            return 0x2232;
        case 0xDC:
            return 0x2234;
        case 0xA6:
            return 0x2237;
        case 0xDD:
            return 0x2238;
        case 0xA0:
        default:
            return 0x227E;
    }
}
dbgCJISFont::dbgCJISFont() {
    Initialize();
}
void dbgCJISFont::Initialize(void) {
    texture_id[DBG_FONT_SHEET_FULL_WIDTH_0] = texture_id[DBG_FONT_SHEET_FULL_WIDTH_1] = texture_id[DBG_FONT_SHEET_HALF_WIDTH] = loaded_texture_id = -1;
    texture_name[DBG_FONT_SHEET_FULL_WIDTH_0][0] = texture_name[DBG_FONT_SHEET_FULL_WIDTH_1][0] = texture_name[DBG_FONT_SHEET_HALF_WIDTH][0] = 0;
    x = y = 0;
    char_width = char_height = 16;
    buffer[0] = 0;
    color[0] = color[1] = color[2] = color[3] = 128;
    back_enable = 0;
    back_color[0] = back_color[1] = back_color[2] = 0;
    back_color[3] = 64;
    shadow_enable = 0;
}
void dbgCJISFont::InitTexture(int full0_id, char *full0_name, int full1_id, char *full1_name, int half_id, char *half_name) {
    texture_id[DBG_FONT_SHEET_FULL_WIDTH_0] = full0_id;
    texture_id[DBG_FONT_SHEET_FULL_WIDTH_1] = full1_id;
    texture_id[DBG_FONT_SHEET_HALF_WIDTH] = half_id;
    strcpy(texture_name[DBG_FONT_SHEET_FULL_WIDTH_0], full0_name);
    strcpy(texture_name[DBG_FONT_SHEET_FULL_WIDTH_1], full1_name);
    strcpy(texture_name[DBG_FONT_SHEET_HALF_WIDTH], half_name);
}
void dbgCJISFont::Clear(void) {
    buffer[0] = 0;
}
#ifdef NONMATCHING
void dbgCJISFont::__putc(unsigned long serno) {
    if (serno >= DBG_FONT_SERNO_END) return;
    int sheet = DBG_FONT_SHEET_FULL_WIDTH_0;
    int glyph_width = 16;
    if (serno >= DBG_FONT_SERNO_HALF_WIDTH) {
        sheet = DBG_FONT_SHEET_HALF_WIDTH;
        serno -= DBG_FONT_SERNO_HALF_WIDTH;
        glyph_width = 9;
    } else if (serno >= DBG_FONT_SERNO_SHEET_1) {
        sheet = DBG_FONT_SHEET_FULL_WIDTH_1;
        serno -= DBG_FONT_SERNO_SHEET_1;
    }
    if (loaded_texture_id != texture_id[sheet]) mgTexManager.ReloadTexture(texture_id[sheet], (sceVif1Packet *)NULL);
    mgCTexture *texture = mgTexManager.GetTexture(texture_name[sheet], -1);
    loaded_texture_id = texture_id[sheet];
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.AlphaTestEnable(0);
    prim.AlphaBlendEnable(1);
    int advance = char_width - (16 - (glyph_width - 1));
    if (back_enable) {
        prim.Begin(6);
        prim.Color(back_color[0], back_color[1], back_color[2], back_color[3]);
        prim.Vertex(x - 1, y - 1, 0);
        prim.Vertex(x + advance, y + char_height + 1, 0);
        prim.End();
    }
    prim.TextureMapEnable(1);
    int tex_x = (serno & 63) * 16;
    int tex_y = (serno >> 6) * 16;
    if (shadow_enable) {
        prim.Begin(6);
        prim.Texture(texture);
        prim.Color(0, 0, 0, 128);
        prim.TextureCrd(tex_x + 1, tex_y + 1);
        prim.Vertex(x - 1, y - 1, 0);
        prim.TextureCrd(tex_x + glyph_width - 1, tex_y + 15);
        prim.Vertex(x + advance, y + char_height + 1, 0);
        prim.End();
    }
    prim.Begin(6);
    prim.Texture(texture);
    prim.Color(color[0], color[1], color[2], color[3]);
    prim.TextureCrd(tex_x + 1, tex_y + 1);
    prim.Vertex(x, y, 0);
    prim.TextureCrd(tex_x + glyph_width - ((serno & 63) == 63), tex_y + 16 - ((serno >> 6) == 63));
    prim.Vertex(x + advance, y + char_height, 0);
    prim.End();
    x += advance + 2;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dbg_font", __putc__11dbgCJISFontFUl);
#endif
#ifdef NONMATCHING
void dbgCJISFont::PrintDirect(int start_x, int start_y, char *format, ...) {
    char text[0x408];
    // The runtime's varargs forwarding needs a target-specific argument-list type.
    sprintf(text, "%s", format);
    x = start_x;
    y = start_y;
    prev_serno = 0;
    for (char *cursor = text; *cursor != 0;) {
        unsigned char first = (unsigned char)*cursor;
        if (first & 0x80) {
            if (first >= 0xA1 && first < 0xE0) {
                unsigned long serno = ascii2serno(first);
                if ((serno == DBG_FONT_SERNO_DAKUTEN || serno == DBG_FONT_SERNO_HANDAKUTEN) && prev_serno != 0) {
                    serno = prev_serno + (serno == DBG_FONT_SERNO_DAKUTEN ? 1 : 2);
                    prev_serno = 0;
                    x -= char_width - 8;
                } else {
                    prev_serno = serno;
                }
                __putc(serno);
                ++cursor;
            } else {
                unsigned long sjis = ((unsigned long)first << 8) | (unsigned char)cursor[1];
                __putc(SjisToSerno(sjis));
                cursor += 2;
            }
        } else if (first == '\n') {
            y += char_height;
            x = 0;
            ++cursor;
        } else if (first == '\t') {
            x += char_width * 2;
            ++cursor;
        } else if (strncmp(cursor, "ESC[$", 5) == 0) {
            back_enable = ~back_enable;
            cursor += 5;
        } else if (strncmp(cursor, "ESC[#", 5) == 0) {
            shadow_enable = ~shadow_enable;
            cursor += 5;
        } else {
            __putc(first + 0x204D);
            ++cursor;
        }
    }
    loaded_texture_id = -1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dbg_font", PrintDirect__11dbgCJISFontFiiPce);
#endif

// Static initialiser (.init)
#ifdef NONMATCHING
extern "C" void __sinit_dbg_font_cpp() {
    new ((u_long128 *)&JisFont) dbgCJISFont;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dbg_font", __sinit_dbg_font_cpp);
#endif

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", at_288__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", at_419__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", at_420__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", D_0037AFF0__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(JisFont, 0x8B0);
