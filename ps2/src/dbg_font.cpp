#include "common.h"
#include "mg_math.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_memory.hpp"
#include "dbg_font.hpp"
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dbg_font", __putc__11dbgCJISFontFUl);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dbg_font", PrintDirect__11dbgCJISFontFiiPce);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dbg_font", __sinit_dbg_font_cpp);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", at_288__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", at_419__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", at_420__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dbg_font", D_0037AFF0__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(JisFont, 0x8B0);
