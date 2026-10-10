#pragma once

#include "common.h"

#include "font.hpp"

/**
 * @file
 * Declares the menu frame drawers: the functions that build the message
 * window's menu-style frames (the versatile windows, the yes/no window, the
 * help window, the floating window and the bottom speech bubble) out of
 * sprites cut from the message window's texture.
 */

class mgCDrawPrim;

/**
 *
 * Rows of data: the texture rectangles the versatile windows are cut from.
 *
 */
// clang-format off
enum VersatileWinPart {
    VWIN_TOP_L          = 0,  /**< Top-left corner. */
    VWIN_TOP_C          = 1,  /**< Top edge, stretched across the width. */
    VWIN_TOP_R          = 2,  /**< Top-right corner. */
    VWIN_SIDE_L         = 3,  /**< Left edge, stretched down the height. */
    VWIN_SIDE_C         = 4,  /**< Inside of the frame. */
    VWIN_SIDE_R         = 5,  /**< Right edge, stretched down the height. */
    VWIN_BAND_L         = 6,  /**< Left end of the band across the frame. */
    VWIN_BAND_C         = 7,  /**< Middle of the band across the frame. */
    VWIN_BAND_R         = 8,  /**< Right end of the band across the frame. */
    VWIN_LOWER_SIDE_L   = 9,  /**< Left edge below the band. */
    VWIN_LOWER_SIDE_C   = 10, /**< Inside of the frame below the band. */
    VWIN_LOWER_SIDE_R   = 11, /**< Right edge below the band. */
    VWIN_LOWER_BOTTOM_L = 12, /**< Bottom-left corner of a frame with a band. */
    VWIN_LOWER_BOTTOM_C = 13, /**< Bottom edge of a frame with a band. */
    VWIN_LOWER_BOTTOM_R = 14, /**< Bottom-right corner of a frame with a band. */
    VWIN_BOTTOM_L       = 15, /**< Bottom-left corner of a plain frame. */
    VWIN_BOTTOM_C       = 16, /**< Bottom edge of a plain frame. */
    VWIN_BOTTOM_R       = 17, /**< Bottom-right corner of a plain frame. */
    VWIN_TOP4_L         = 18, /**< Top-left corner of the fourth style. */
    VWIN_TOP4_C         = 19, /**< Top edge of the fourth style. */
    VWIN_TOP4_R         = 20, /**< Top-right corner of the fourth style. */
    VWIN_PART_MAX       = 21, /**< Rows of data. */
};

// clang-format on

/**
 *
 * Works out where the yes and no cursors of a yes/no window sit.
 *
 * @mangled CalcSelectCursorPos__F4RECTPi
 * @address 0x2DB1B0
 * @size 0xC0
 */
void CalcSelectCursorPos(RECT rect, int *out);

/**
 *
 * Widens a yes/no window and its shadow to the width the two choices need.
 *
 * @mangled OffsetYesNoWin__FP4RECTP4RECT
 * @address 0x2DB270
 * @size 0x20
 */
void OffsetYesNoWin(RECT *win, RECT *shadow);

/**
 *
 * Draws a versatile window with a band above the yes and no choices.
 *
 * @mangled DrawVersatileWin_yesno__FP11mgCDrawPrim4RECTP10RGBAQ_TYPEii
 * @address 0x2DB290
 * @size 0x5D0
 */
void DrawVersatileWin_yesno(mgCDrawPrim *prim, RECT win, RGBAQ_TYPE *color, int alpha, int opaque);

/**
 *
 * Draws the help window's frame.
 *
 * @mangled MyMenuHelpWinDraw__FP11mgCDrawPrim4RECTi
 * @address 0x2DB860
 * @size 0x330
 */
void MyMenuHelpWinDraw(mgCDrawPrim *prim, RECT rect, int alpha);

/**
 *
 * Draws the floating window, with a pointer on the side facing a point outside it.
 *
 * @mangled MyMenuFloatingWinDraw__FP11mgCDrawPrim4RECTiiP10RGBAQ_TYPEP10RGBAQ_TYPE
 * @address 0x2DBB90
 * @size 0x800
 */
void MyMenuFloatingWinDraw(mgCDrawPrim *prim, RECT win, int point_x, int point_y, RGBAQ_TYPE *frame_color,
                           RGBAQ_TYPE *fill_color);

/**
 *
 * Draws a plain versatile window.
 *
 * @mangled DrawVersatileWin_1__FP11mgCDrawPrim4RECTP10RGBAQ_TYPEii
 * @address 0x2DC390
 * @size 0x3C0
 */
void DrawVersatileWin_1(mgCDrawPrim *prim, RECT rect, RGBAQ_TYPE *color, int alpha, int opaque);

/**
 *
 * Draws a plain versatile window with a translucent fill.
 *
 * @mangled DrawVersatileWin_1__FP11mgCDrawPrim4RECTP10RGBAQ_TYPEi
 * @address 0x2DC750
 * @size 0x50
 */
void DrawVersatileWin_1(mgCDrawPrim *prim, RECT win, RGBAQ_TYPE *color, int alpha);

/**
 *
 * Draws a versatile window with a band behind the selected line.
 *
 * @mangled DrawVersatileWin_3__FP11mgCDrawPrim4RECTiP10RGBAQ_TYPEii
 * @address 0x2DC7A0
 * @size 0x5E0
 */
void DrawVersatileWin_3(mgCDrawPrim *prim, RECT win, int select_y, RGBAQ_TYPE *color, int alpha, int opaque);

/**
 *
 * Draws a versatile window of the fourth style.
 *
 * @mangled DrawVersatileWin_4__FP11mgCDrawPrim4RECTP10RGBAQ_TYPEii
 * @address 0x2DCD80
 * @size 0x3C0
 */
void DrawVersatileWin_4(mgCDrawPrim *prim, RECT rect, RGBAQ_TYPE *color, int alpha, int opaque);

/**
 *
 * Draws a versatile window of the fourth style with a translucent fill.
 *
 * @mangled DrawVersatileWin_4__FP11mgCDrawPrim4RECTP10RGBAQ_TYPEi
 * @address 0x2DD140
 * @size 0x50
 */
void DrawVersatileWin_4(mgCDrawPrim *prim, RECT win, RGBAQ_TYPE *color, int alpha);

/**
 *
 * Draws the speech bubble at the bottom of the screen, with its tail along the top edge.
 *
 * @mangled DrawDQFukidashi__FP11mgCDrawPrim4RECTiiP10RGBAQ_TYPEii
 * @address 0x2DD190
 * @size 0x440
 */
void DrawDQFukidashi(mgCDrawPrim *prim, RECT win, int tail_x, int tail_y, RGBAQ_TYPE *color, int tail_on,
                     int mode);

/** Texture rectangles of the versatile windows' parts: x, y, width and height, by VersatileWinPart. */
extern s32 data[VWIN_PART_MAX][4];
