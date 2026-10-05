#include "common.h"
#include "drawwin.hpp"
#include "nd_meswin.hpp"
#include "mg_drawenv.hpp"
#include "nd_meswin.hpp"
#include "mg_drawprim.hpp"
#include "menudraw.hpp"

#define DrawWindowPart(prim, part, x, y, width, height, color) \
    do { \
        mgRect<int> screen; \
        mgRect<int> texture; \
        texture.Set(data[part][0], data[part][1], data[part][2], data[part][3]); \
        screen.Set(x, y, width, height); \
        set2DSprite(prim, screen, texture, color); \
    } while (0)

#define DrawWindowTile(prim, x, y, width, height, tex_x, tex_y, tex_width, tex_height, color) \
    do { \
        mgRect<int> screen; \
        mgRect<int> texture; \
        texture.Set(tex_x, tex_y, tex_width, tex_height); \
        screen.Set(x, y, width, height); \
        set2DSprite(prim, screen, texture, color); \
    } while (0)

#define DrawWindowRow(prim, part, win, y, height, color) \
    do { \
        DrawWindowPart(prim, part, win.x, y, 0x17, height, color); \
        DrawWindowPart(prim, part + 1, win.x + 0x17, y, win.width - 0x2E, height, color); \
        DrawWindowPart(prim, part + 2, win.x + win.width - 0x17, y, 0x17, height, color); \
    } while (0)

#define WindowFillAlpha(alpha, opaque) ((opaque) ? 0x80 : (alpha) * 0x36 / 128)

// Code (.text)
void CalcSelectCursorPos(RECT rect, int *out) {
    int left = rect.x + 0x17;
    int inner = rect.width - 0x2E;
    out[0] = left + inner * 5 / 20 - 0x1E;
    out[1] = rect.y + rect.height - 0x29;
    out[2] = left + inner * 15 / 20 - 0x1E;
    out[3] = out[1];
}
void OffsetYesNoWin(RECT *win, RECT *shadow) {
    if (win->width < 0xA6) {
        win->width = 0xA6;
        shadow->width = 0xA6;
    }
}
void DrawVersatileWin_yesno(mgCDrawPrim *prim, RECT win, RGBAQ_TYPE *color, int alpha, int opaque) {
    MySetPrim(prim, 1, 0);
    int inside_width = win.width - 0x2E;
    int inside_x = win.x + 0x17;
    int right_x = win.x + win.width - 0x17;
    int top_y = win.y;
    int side_y = win.y + 0x19;
    int side_height = win.height - 0x50;
    int band_y = win.y + win.height - 0x37;
    int lower_y = win.y + win.height - 0x29;
    int bottom_y = win.y + win.height - 0x19;
    DrawWindowPart(prim, VWIN_TOP_L, win.x, top_y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_TOP_L + 1, inside_x, top_y, inside_width, 0x19, color);
    DrawWindowPart(prim, VWIN_TOP_L + 2, right_x, top_y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_SIDE_L, win.x, side_y, 0x17, side_height, color);
    int fill_alpha = 0x80;
    if (opaque == 0) {
        fill_alpha = alpha * 0x36 / 128;
    }
    FillRect(inside_x - 0xA, side_y - 9, inside_width + 0x16, side_height + 0xD,
             0, 0, 0, fill_alpha);
    DrawWindowPart(prim, VWIN_SIDE_R, right_x, side_y, 0x17, side_height, color);
    DrawWindowPart(prim, VWIN_BAND_L, win.x, band_y, 0x17, 0xE, color);
    DrawWindowPart(prim, VWIN_BAND_L + 1, inside_x, band_y, inside_width, 0xE, color);
    DrawWindowPart(prim, VWIN_BAND_L + 2, right_x, band_y, 0x17, 0xE, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_L, win.x, lower_y, 0x17, 0x10, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_L + 1, inside_x, lower_y, inside_width, 0x10, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_L + 2, right_x, lower_y, 0x17, 0x10, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_L, win.x, bottom_y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_L + 1, inside_x, bottom_y, inside_width, 0x19, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_L + 2, right_x, bottom_y, 0x17, 0x19, color);
}
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
#ifdef NONMATCHING
void MyMenuFloatingWinDraw(mgCDrawPrim *prim, RECT win, int point_x, int point_y,
                           RGBAQ_TYPE *frame_color, RGBAQ_TYPE *fill_color) {
    int top_y;
    int inside_x;
    int side_y;
    int inside_width;
    int right_edge;
    int inside_height;
    int right_x;
    int bottom_edge;
    int bottom_y;
    inside_x = win.x + 7;
    right_edge = win.x + win.width;
    inside_height = win.height - 18;
    inside_width = win.width - 14;
    right_x = right_edge - 7;
    top_y = win.y;
    side_y = win.y + 9;
    bottom_edge = win.y + win.height;
    bottom_y = win.y + (win.height - 9);
    MySetPrim(prim, 1, 0);
    DrawWindowTile(prim, win.x, top_y, 7, 9, 0xa0, 0x0, 0x7, 0x9, fill_color);
    DrawWindowTile(prim, inside_x, top_y, inside_width, 9, 0xa7, 0x0, 0x22, 0x9, fill_color);
    DrawWindowTile(prim, right_x, top_y, 7, 9, 0xc9, 0x0, 0x7, 0x9, fill_color);
    DrawWindowTile(prim, win.x, side_y, 7, inside_height, 0xa0, 0x9, 0x7, 0x1e, fill_color);
    DrawWindowTile(prim, inside_x, side_y, inside_width, inside_height, 0xa7, 0x9, 0x22, 0x1e, fill_color);
    DrawWindowTile(prim, right_x, side_y, 7, inside_height, 0xc9, 0x9, 0x7, 0x1e, fill_color);
    DrawWindowTile(prim, win.x, bottom_y, 7, 9, 0xa0, 0x27, 0x7, 0x9, fill_color);
    DrawWindowTile(prim, inside_x, bottom_y, inside_width, 9, 0xa7, 0x27, 0x22, 0x9, fill_color);
    DrawWindowTile(prim, right_x, bottom_y, 7, 9, 0xc9, 0x27, 0x7, 0x9, fill_color);
    DrawWindowTile(prim, win.x, top_y, 7, 9, 0x70, 0x0, 0x7, 0x9, frame_color);
    DrawWindowTile(prim, inside_x, top_y, inside_width, 9, 0x77, 0x0, 0x22, 0x9, frame_color);
    DrawWindowTile(prim, right_x, top_y, 7, 9, 0x99, 0x0, 0x7, 0x9, frame_color);
    DrawWindowTile(prim, win.x, side_y, 7, inside_height, 0x70, 0x9, 0x7, 0x1e, frame_color);
    DrawWindowTile(prim, right_x, side_y, 7, inside_height, 0x99, 0x9, 0x7, 0x1e, frame_color);
    DrawWindowTile(prim, win.x, bottom_y, 7, 9, 0x70, 0x27, 0x7, 0x9, frame_color);
    DrawWindowTile(prim, inside_x, bottom_y, inside_width, 9, 0x77, 0x27, 0x22, 0x9, frame_color);
    DrawWindowTile(prim, right_x, bottom_y, 7, 9, 0x99, 0x27, 0x7, 0x9, frame_color);
    MySetPrim(prim, 4, 0);
    if (point_x < win.x) {
        DrawWindowTile(prim, win.x - 13, point_y - 10, 0x15, 0x15, 0xA6, 0x45, 0x15, 0x15, fill_color);
        DrawWindowTile(prim, win.x - 13, point_y - 10, 0x15, 0x15, 0xA6, 0x30, 0x15, 0x15, frame_color);
    } else if (point_x > right_edge) {
        DrawWindowTile(prim, top_y = right_edge - 8, point_y - 10, 0x15, 0x15, 0xBB, 0x45, 0x15, 0x15, fill_color);
        DrawWindowTile(prim, top_y, point_y - 10, 0x15, 0x15, 0xBB, 0x30, 0x15, 0x15, frame_color);
    } else if (point_y < top_y) {
        DrawWindowTile(prim, point_x - 10, top_y -= 13, 0x15, 0x15, 0x7C, 0x45, 0x15, 0x15, fill_color);
        DrawWindowTile(prim, point_x - 10, top_y, 0x15, 0x15, 0x7C, 0x30, 0x15, 0x15, frame_color);
    } else if (point_y > bottom_edge) {
        DrawWindowTile(prim, point_x - 10, top_y = bottom_edge - 8, 0x15, 0x15, 0x91, 0x45, 0x15, 0x15, fill_color);
        DrawWindowTile(prim, point_x - 10, top_y, 0x15, 0x15, 0x91, 0x30, 0x15, 0x15, frame_color);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/drawwin", MyMenuFloatingWinDraw__FP11mgCDrawPrim4RECTiiP10RGBAQ_TYPEP10RGBAQ_TYPE);
#endif
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
void DrawVersatileWin_1(mgCDrawPrim *prim, RECT win, RGBAQ_TYPE *color, int alpha) {
    DrawVersatileWin_1(prim, win, color, alpha, 0);
}
void DrawVersatileWin_3(mgCDrawPrim *prim, RECT win, int select_y, RGBAQ_TYPE *color, int alpha, int opaque) {
    MySetPrim(prim, 1, 0);
    int band_top = select_y - 7;
    int band_bottom = select_y + 7;
    int inside_x = win.x + 0x17;
    int right_x = win.x + win.width - 0x17;
    int inside_width = win.width - 0x2E;
    int top_y = win.y;
    int side_y = win.y + 0x19;
    int bottom_y = win.y + win.height - 0x19;
    int side_height = band_top - (win.height + 0x19);
    int lower_height = bottom_y - band_bottom;
    DrawWindowPart(prim, VWIN_TOP_L, win.x, top_y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_TOP_L + 1, inside_x, top_y, inside_width, 0x19, color);
    DrawWindowPart(prim, VWIN_TOP_L + 2, right_x, top_y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_SIDE_L, win.x, side_y, 0x17, side_height, color);
    int fill_alpha = 0x80;
    if (opaque == 0) {
        fill_alpha = alpha * 0x36 / 128;
    }
    FillRect(inside_x - 0xA, side_y - 9, inside_width + 0x16, side_height + 0xD,
             0, 0, 0, fill_alpha);
    DrawWindowPart(prim, VWIN_SIDE_R, right_x, side_y, 0x17, side_height, color);
    DrawWindowPart(prim, VWIN_BAND_L, win.x, band_top, 0x17, 0xE, color);
    DrawWindowPart(prim, VWIN_BAND_L + 1, inside_x, band_top, inside_width, 0xE, color);
    DrawWindowPart(prim, VWIN_BAND_L + 2, right_x, band_top, 0x17, 0xE, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_L, win.x, band_bottom, 0x17, lower_height, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_L + 1, inside_x, band_bottom, inside_width, lower_height, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_L + 2, right_x, band_bottom, 0x17, lower_height, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_L, win.x, bottom_y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_L + 1, inside_x, bottom_y, inside_width, 0x19, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_L + 2, right_x, bottom_y, 0x17, 0x19, color);
}
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
void DrawVersatileWin_4(mgCDrawPrim *prim, RECT win, RGBAQ_TYPE *color, int alpha) {
    DrawVersatileWin_4(prim, win, color, alpha, 0);
}
void DrawDQFukidashi(mgCDrawPrim *prim, RECT win, int tail_x, int tail_y,
                     RGBAQ_TYPE *color, int tail_on, int mode) {
    int inside_x = win.x + 0x10;
    int inside_width = win.width - 0x20;
    int right_x = win.x + win.width - 0x10;
    int side_y = win.y + 0x10;
    int bottom_y = win.y + win.height - 0x10;
    int side_height = win.height - 0x20;
    MySetPrim(prim, 1, 0);
    DrawWindowTile(prim, win.x, win.y, 0x10, 0x10, 0, 0xD0, 0x10, 0x10, color);
    if (tail_on) {
        int end_x = inside_x + inside_width;
        if (tail_x - 8 < inside_x) tail_x = inside_x + 8;
        if (tail_x + 8 > end_x) tail_x = end_x - 8;
        DrawWindowTile(prim, inside_x, win.y, tail_x - 8 - inside_x, 0x10,
                       0x10, 0xD0, 0x10, 0x10, color);
        DrawWindowTile(prim, tail_x - 8, win.y - 0x10, 0x10, 0x20,
                       0x30, 0xD0, 0x10, 0x20, color);
        DrawWindowTile(prim, tail_x + 8, win.y, inside_x + inside_width - (tail_x + 8),
                       0x10, 0x10, 0xD0, 0x10, 0x10, color);
    } else {
        DrawWindowTile(prim, inside_x, win.y, inside_width, 0x10,
                       0x10, 0xD0, 0x10, 0x10, color);
    }
    DrawWindowTile(prim, right_x, win.y, 0x10, 0x10, 0x20, 0xD0, 0x10, 0x10, color);
    DrawWindowTile(prim, win.x, side_y, 0x10, side_height,
                   0, 0xE0, 0x10, 0x10, color);
    DrawWindowTile(prim, inside_x, side_y, inside_width, side_height,
                   0x10, 0xE0, 0x10, 0x10, color);
    DrawWindowTile(prim, right_x, side_y, 0x10, side_height,
                   0x20, 0xE0, 0x10, 0x10, color);
    DrawWindowTile(prim, win.x, bottom_y, 0x10, 0x10, 0, 0xF0, 0x10, 0x10, color);
    DrawWindowTile(prim, inside_x, bottom_y, inside_width, 0x10,
                   0x10, 0xF0, 0x10, 0x10, color);
    DrawWindowTile(prim, right_x, bottom_y, 0x10, 0x10, 0x20, 0xF0, 0x10, 0x10, color);
}
// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/drawwin", data__DATA);
