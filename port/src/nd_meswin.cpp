#include "common.h"

#include "drawwin.hpp"
#include "mg_drawprim.hpp"
#include "nd_meswin.hpp"

namespace {

/**
 *
 * Draws one textured part of a versatile message frame.
 *
 */
void DrawWindowPart(mgCDrawPrim *prim, VersatileWinPart part, int x, int y, int width, int height,
                    RGBAQ_TYPE *color) {
    if (width <= 0 || height <= 0) {
        return;
    }
    mgRect<int> screen;
    mgRect<int> texture;
    screen.Set(x, y, width, height);
    texture.Set(data[part][0], data[part][1], data[part][2], data[part][3]);
    set2DSprite(prim, screen, texture, color);
}

} // namespace

// The gaiji frame exposes the backing at the top and left edges of its opening. Move those edges outward
// without shortening the right and bottom edges of the original rectangle.
PORT_OVERRIDE void FillRect(int x, int y, int w, int h, int r, int g, int b, int a) {
    mgCDrawPrim drawer;
    drawer.Initialize(nullptr, nullptr);
    drawer.AlphaBlendEnable(1);
    drawer.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    drawer.AlphaTestEnable(1);
    drawer.AlphaTest(1, 0);
    drawer.DepthTestEnable(0);
    drawer.ZMask(MG_Z_MASK_MASKED);
    drawer.Bilinear(0);
    drawer.TextureMapEnable(0);
    drawer.Begin(MG_PRIM_SPRITE);
    drawer.Color(r, g, b, a);
    drawer.Vertex(x - 1, y - 1, 0);
    drawer.Vertex(x + w, y + h, 0);
    drawer.End();
}

PORT_OVERRIDE void DrawVersatileWin_3(mgCDrawPrim *prim, RECT win, int select_y, RGBAQ_TYPE *color, int alpha,
                                      int opaque) {
    MySetPrim(prim, MES_PRIM_SPRITE, 0);
    const int band_top = select_y - 7;
    const int band_bottom = select_y + 7;
    const int inside_x = win.x + 0x17;
    const int right_x = win.x + win.width - 0x17;
    const int inside_width = win.width - 0x2E;
    const int side_y = win.y + 0x19;
    const int bottom_y = win.y + win.height - 0x19;
    const int side_height = band_top - side_y;
    const int lower_height = bottom_y - band_bottom;

    DrawWindowPart(prim, VWIN_TOP_L, win.x, win.y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_TOP_C, inside_x, win.y, inside_width, 0x19, color);
    DrawWindowPart(prim, VWIN_TOP_R, right_x, win.y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_SIDE_L, win.x, side_y, 0x17, side_height, color);
    if (side_height + 0xD > 0 && inside_width + 0x16 > 0) {
        const int fill_alpha = opaque != 0 ? 0x80 : alpha * 0x36 / 128;
        FillRect(inside_x - 0xA, side_y - 9, inside_width + 0x16, side_height + 0xD, 0, 0, 0, fill_alpha);
    }
    DrawWindowPart(prim, VWIN_SIDE_R, right_x, side_y, 0x17, side_height, color);
    DrawWindowPart(prim, VWIN_BAND_L, win.x, band_top, 0x17, 0xE, color);
    DrawWindowPart(prim, VWIN_BAND_C, inside_x, band_top, inside_width, 0xE, color);
    DrawWindowPart(prim, VWIN_BAND_R, right_x, band_top, 0x17, 0xE, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_L, win.x, band_bottom, 0x17, lower_height, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_C, inside_x, band_bottom, inside_width, lower_height, color);
    DrawWindowPart(prim, VWIN_LOWER_SIDE_R, right_x, band_bottom, 0x17, lower_height, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_L, win.x, bottom_y, 0x17, 0x19, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_C, inside_x, bottom_y, inside_width, 0x19, color);
    DrawWindowPart(prim, VWIN_LOWER_BOTTOM_R, right_x, bottom_y, 0x17, 0x19, color);
}
