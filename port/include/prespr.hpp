#pragma once

#include "common.h"

#include "mg_drawprim.hpp"

/**
 * @file
 * Declares the 2D sprite primitive builder used to draw screen-space
 * interface and effect sprites.
 */

/**
 *
 * Primitive builder preset for 2D sprites, with helpers that write
 * textured rectangles, the scissor area and the blend equation.
 *
 */
class CPreSprite : public mgCDrawPrim {
public:
    u8 unk_120[0x10]{};

    /**
     *
     * Sets the drawing state for 2D sprites: normal alpha blending, the
     * alpha test, no depth test or depth writes, and unfiltered texturing.
     *
     * @mangled Preset2D__10CPreSpriteFv
     * @address 0x1E9260
     * @size 0x80
     */
    void Preset2D();

    /**
     *
     * Writes a sprite of the given screen rectangle textured with an
     * equally sized texel rectangle starting at the given coordinates.
     *
     * @mangled SetIRect__10CPreSpriteFiiiiii
     * @address 0x1E92E0
     * @size 0xB0
     */
    void SetIRect(int x, int y, int w, int h, int u, int v);

    /**
     *
     * Writes a sprite of the given screen rectangle textured with a texel
     * rectangle of its own size, stretched to fit.
     *
     * @mangled SetIStretch__10CPreSpriteFiiiiiiii
     * @address 0x1E9390
     * @size 0xC0
     */
    void SetIStretch(int x, int y, int w, int h, int u, int v, int tw, int th);

    /**
     *
     * Writes the SCISSOR register so that drawing is limited to the given
     * screen rectangle.
     *
     * @mangled SetScirror__10CPreSpriteFiiii
     * @address 0x1E9450
     * @size 0x60
     */
    void SetScirror(int x, int y, int w, int h);

    /**
     *
     * Writes the ALPHA register for a blend equation, an mgALPHA_BLEND
     * value from normal to none; other values write nothing.
     *
     * @mangled SetAlphaBlend__10CPreSpriteFi
     * @address 0x1E94B0
     * @size 0xD0
     */
    void SetAlphaBlend(int mode);
};

STATIC_ASSERT(sizeof(CPreSprite) == 0x130);
