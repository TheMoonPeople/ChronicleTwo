#include "common.h"
#include "drawwin.hpp"
#include "nd_meswin.hpp"
#include "mg_drawenv.hpp"
#include "nd_meswin.hpp"
#include "mg_drawprim.hpp"
#include "menudraw.hpp"

// Code (.text)
void CalcSelectCursorPos(RECT rect, int *out) {
    int left = rect.x + 0x17;
    int inner = rect.width - 0x2E;
    out[0] = left + inner * 5 / 20 - 0x1E;
    out[1] = rect.y + rect.height - 0x29;
    out[2] = left + inner * 15 / 20 - 0x1E;
    out[3] = out[1];
}
void OffsetYesNoWin(RECT *window, RECT *shadow) {
    if (window->width < 0xA6) {
        window->width = 0xA6;
        shadow->width = 0xA6;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/drawwin", DrawVersatileWin_yesno__FP11mgCDrawPrim4RECTP10RGBAQ_TYPEii);
void MyMenuHelpWinDraw(mgCDrawPrim *prim, RECT rect, int alpha) {
    mgRect<int> screen0;
    mgRect<int> texture0;
    mgRect<int> screen1;
    mgRect<int> texture1;
    mgRect<int> screen2;
    mgRect<int> texture2;
    mgRect<int> screen3;
    mgRect<int> texture3;
    mgRect<int> screen4;
    mgRect<int> texture4;
    mgRect<int> screen5;
    mgRect<int> texture5;
    mgRect<int> screen6;
    mgRect<int> texture6;
    mgRect<int> screen7;
    mgRect<int> texture7;
    mgRect<int> screen8;
    mgRect<int> texture8;
    RGBAQ_TYPE color;
    color.b = 0x80;
    color.g = 0x80;
    color.r = 0x80;
    color.a = alpha;
    int left = rect.x + 0x18;
    int right = rect.x + rect.width - 0x18;
    int top = rect.y + 0x16;
    int bottom = rect.y + rect.height - 0x16;
    int inner_width = rect.width - 0x30;
    int inner_height = rect.height - 0x2C;
    texture0.Set(0xC0, 0xA6, 0x18, 0x16);
    screen0.Set(rect.x, rect.y, 0x18, 0x16);
    set2DSprite(prim, screen0, texture0, &color);
    texture1.Set(0xD8, 0xA6, 0x10, 0x16);
    screen1.Set(left, rect.y, inner_width, 0x16);
    set2DSprite(prim, screen1, texture1, &color);
    texture2.Set(0xE8, 0xA6, 0x18, 0x16);
    screen2.Set(right, rect.y, 0x18, 0x16);
    set2DSprite(prim, screen2, texture2, &color);
    texture3.Set(0xC0, 0xBC, 0x18, 0x14);
    screen3.Set(rect.x, top, 0x18, inner_height);
    set2DSprite(prim, screen3, texture3, &color);
    texture4.Set(0xD8, 0xBC, 0x10, 0x14);
    screen4.Set(left, top, inner_width, inner_height);
    set2DSprite(prim, screen4, texture4, &color);
    texture5.Set(0xE8, 0xBC, 0x18, 0x14);
    screen5.Set(right, top, 0x18, inner_height);
    set2DSprite(prim, screen5, texture5, &color);
    texture6.Set(0xC0, 0xD0, 0x18, 0x16);
    screen6.Set(rect.x, bottom, 0x18, 0x16);
    set2DSprite(prim, screen6, texture6, &color);
    texture7.Set(0xD8, 0xD0, 0x10, 0x16);
    screen7.Set(left, bottom, inner_width, 0x16);
    set2DSprite(prim, screen7, texture7, &color);
    texture8.Set(0xE8, 0xD0, 0x18, 0x16);
    screen8.Set(right, bottom, 0x18, 0x16);
    set2DSprite(prim, screen8, texture8, &color);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/drawwin", MyMenuFloatingWinDraw__FP11mgCDrawPrim4RECTiiP10RGBAQ_TYPEP10RGBAQ_TYPE);
void DrawVersatileWin_1(mgCDrawPrim *prim, RECT rect, RGBAQ_TYPE *color, int alpha, int opaque) {
    mgRect<int> screen0;
    mgRect<int> texture0;
    mgRect<int> screen1;
    mgRect<int> texture1;
    mgRect<int> screen2;
    mgRect<int> texture2;
    mgRect<int> screen3;
    mgRect<int> texture3;
    mgRect<int> screen4;
    mgRect<int> texture4;
    mgRect<int> screen5;
    mgRect<int> texture5;
    mgRect<int> screen6;
    mgRect<int> texture6;
    mgRect<int> screen7;
    mgRect<int> texture7;
    MySetPrim(prim, 1, 0);
    int left = rect.x + 0x17;
    int right = rect.x + rect.width - 0x17;
    int inner_width = rect.width - 0x2E;
    int top = rect.y + 0x19;
    int inner_height = rect.height - 0x32;
    int bottom = rect.y + rect.height - 0x19;
    texture0.Set(data[0][0], data[0][1], data[0][2], data[0][3]);
    screen0.Set(rect.x, rect.y, 0x17, 0x19);
    set2DSprite(prim, screen0, texture0, color);
    texture1.Set(data[1][0], data[1][1], data[1][2], data[1][3]);
    screen1.Set(left, rect.y, inner_width, 0x19);
    set2DSprite(prim, screen1, texture1, color);
    texture2.Set(data[2][0], data[2][1], data[2][2], data[2][3]);
    screen2.Set(right, rect.y, 0x17, 0x19);
    set2DSprite(prim, screen2, texture2, color);
    texture3.Set(data[3][0], data[3][1], data[3][2], data[3][3]);
    screen3.Set(rect.x, top, 0x17, inner_height);
    set2DSprite(prim, screen3, texture3, color);
    int fill_alpha = 0x80;
    if (opaque == 0) {
        fill_alpha = alpha * 0x36 / 128;
    }
    FillRect(left - 10, top - 9, inner_width + 0x16, inner_height + 0x18, 0, 0, 0,
                        fill_alpha);
    texture4.Set(data[5][0], data[5][1], data[5][2], data[5][3]);
    screen4.Set(right, top, 0x17, inner_height);
    set2DSprite(prim, screen4, texture4, color);
    texture5.Set(data[15][0], data[15][1], data[15][2], data[15][3]);
    screen5.Set(rect.x, bottom, 0x17, 0x19);
    set2DSprite(prim, screen5, texture5, color);
    texture6.Set(data[16][0], data[16][1], data[16][2], data[16][3]);
    screen6.Set(left, bottom, inner_width, 0x19);
    set2DSprite(prim, screen6, texture6, color);
    texture7.Set(data[17][0], data[17][1], data[17][2], data[17][3]);
    screen7.Set(right, bottom, 0x17, 0x19);
    set2DSprite(prim, screen7, texture7, color);
}
void DrawVersatileWin_1(mgCDrawPrim *prim, RECT rect, RGBAQ_TYPE *color, int a) {
    DrawVersatileWin_1(prim, rect, color, a, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/drawwin", DrawVersatileWin_3__FP11mgCDrawPrim4RECTiP10RGBAQ_TYPEii);
void DrawVersatileWin_4(mgCDrawPrim *prim, RECT rect, RGBAQ_TYPE *color, int alpha, int opaque) {
    mgRect<int> screen0;
    mgRect<int> texture0;
    mgRect<int> screen1;
    mgRect<int> texture1;
    mgRect<int> screen2;
    mgRect<int> texture2;
    mgRect<int> screen3;
    mgRect<int> texture3;
    mgRect<int> screen4;
    mgRect<int> texture4;
    mgRect<int> screen5;
    mgRect<int> texture5;
    mgRect<int> screen6;
    mgRect<int> texture6;
    mgRect<int> screen7;
    mgRect<int> texture7;
    MySetPrim(prim, 1, 0);
    int left = rect.x + 0x17;
    int right = rect.x + rect.width - 0x17;
    int inner_width = rect.width - 0x2E;
    int top = rect.y + 0x19;
    int inner_height = rect.height - 0x32;
    int bottom = rect.y + rect.height - 0x19;
    texture0.Set(data[0x12][0], data[0x12][1], data[0x12][2], data[0x12][3]);
    screen0.Set(rect.x, rect.y, 0x17, 0x19);
    set2DSprite(prim, screen0, texture0, color);
    texture1.Set(data[0x13][0], data[0x13][1], data[0x13][2], data[0x13][3]);
    screen1.Set(left, rect.y, inner_width, 0x19);
    set2DSprite(prim, screen1, texture1, color);
    texture2.Set(data[0x14][0], data[0x14][1], data[0x14][2], data[0x14][3]);
    screen2.Set(right, rect.y, 0x17, 0x19);
    set2DSprite(prim, screen2, texture2, color);
    texture3.Set(data[3][0], data[3][1], data[3][2], data[3][3]);
    screen3.Set(rect.x, top, 0x17, inner_height);
    set2DSprite(prim, screen3, texture3, color);
    int fill_alpha = 0x80;
    if (opaque == 0) {
        fill_alpha = alpha * 0x36 / 128;
    }
    FillRect(left - 10, top - 0xD, inner_width + 0x16, inner_height + 0x1C, 0, 0, 0,
                        fill_alpha);
    texture4.Set(data[5][0], data[5][1], data[5][2], data[5][3]);
    screen4.Set(right, top, 0x17, inner_height);
    set2DSprite(prim, screen4, texture4, color);
    texture5.Set(data[15][0], data[15][1], data[15][2], data[15][3]);
    screen5.Set(rect.x, bottom, 0x17, 0x19);
    set2DSprite(prim, screen5, texture5, color);
    texture6.Set(data[16][0], data[16][1], data[16][2], data[16][3]);
    screen6.Set(left, bottom, inner_width, 0x19);
    set2DSprite(prim, screen6, texture6, color);
    texture7.Set(data[17][0], data[17][1], data[17][2], data[17][3]);
    screen7.Set(right, bottom, 0x17, 0x19);
    set2DSprite(prim, screen7, texture7, color);
}
void DrawVersatileWin_4(mgCDrawPrim *prim, RECT rect, RGBAQ_TYPE *color, int a) {
    DrawVersatileWin_4(prim, rect, color, a, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/drawwin", DrawDQFukidashi__FP11mgCDrawPrim4RECTiiP10RGBAQ_TYPEii);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/drawwin", data__DATA);
