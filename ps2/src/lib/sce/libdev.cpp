#include "common.h"

extern void sceDevFontSetColor(void *, int, int, int, int);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevFontDefault);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevFontIdle);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevFontSetColor);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsInit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsOpen);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsClose);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsRef);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsDraw);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsDrawS);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsClear);

void sceDevConsSetColor(char *c, int r, int g, int b, int a) {
    sceDevFontSetColor(c + 0x18, r & 0xFF, g & 0xFF, b & 0xFF, a & 0xFF);
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsPrintf);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsLocate);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsPut);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsGet);

void sceDevConsAttribute(unsigned char *c, int a) {
    c[12] = a;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsClearBox);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsMove);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsRollup);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsMessage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsFrame);

unsigned euc2jis(unsigned c) {
    return (c & 0xFFFF) ^ 0x8080;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sjis2jis);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevFontRefDirectImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevFontRefStrN);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsPutc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsGetc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevConsPiece);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevFontKnj2Chr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", chaGifPkOpenGifTag2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", chaMemAlloc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", chaMemFree);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceDevFont);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", s_Pool__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", sceFont8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_L__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_R__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_U__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_D__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_LU__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_LD__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_RU__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_RD__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_HL__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", CHA_DEV_FONT_PIECE_VL__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libdev", fontMask__DATA);

INCLUDE_BSS(s_Cons, 0x170);
