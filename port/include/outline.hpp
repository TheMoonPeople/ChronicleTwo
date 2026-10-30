#pragma once

#include "common.h"

#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_texture.hpp"

/**
 * @file
 * Declares the character outline: a coloured edge drawn around one frame of a
 * character model by rendering the frame into an off-screen texture and
 * compositing that texture back onto the screen, offset in four directions.
 */

/**
 *
 * One outline attached to a frame of a character, kept in the character's
 * list of outlines and drawn in place of that frame.
 *
 */
class COutLineDraw {
public:
    COutLineDraw *next; /**< Following outline of the same character, or NULL. */
    mgVu0FBOX     unk_10{};
    mgCTexture   *texture{};        /**< Off-screen texture the frame is rendered into before compositing. */
    mgCFrame     *frame{};          /**< Frame of the character model the outline is drawn around. */
    float         width{};          /**< Thickness of the edge, in pixels; zero draws the frame with no outline. */
    int           depth_from_pos{}; /**< Non-zero to composite the frame at the screen depth of pos. */
    sceVu0FVECTOR pos{};            /**< World position of the character the outline belongs to. */
    sceVu0FVECTOR color{};          /**< Colour of the edge: red, green and blue from 0 to 255, then alpha. */
    int           enable{};         /**< Non-zero when the outline and its frame are drawn at all. */
    int           hide_edge{};      /**< Non-zero to composite the frame without drawing the edge around it. */

    /**
     *
     * Creates an outline with no frame and the default edge colour.
     *
     */
    COutLineDraw() {
        next = nullptr;
        Initialize();
    }

    /**
     *
     * Resets the outline: no frame or texture, zero width, the default edge
     * colour, drawing enabled and no following outline.
     *
     * @mangled Initialize__12COutLineDrawFv
     * @address 0x17D680
     * @size 0x70
     */
    void Initialize();

    /**
     *
     * Sets the frame of the character model the outline is drawn around.
     *
     * @mangled SetFrame__12COutLineDrawFP8mgCFrame
     * @address 0x17D6F0
     * @size 0x10
     */
    void SetFrame(mgCFrame *frame);

    /**
     *
     * Records the character's world position and draws the frame with its
     * outline; returns what drawing the frame returned.
     *
     * @mangled Draw__12COutLineDrawFPfff
     * @address 0x17D700
     * @size 0x10
     */
    int Draw(float *pos, float scale, float alpha);

    /**
     *
     * Draws the frame into the off-screen texture and composites it onto the
     * screen with an edge whose width shrinks with scale and whose opacity
     * follows alpha; returns what drawing the frame returned, or 0.
     *
     * @mangled Draw__12COutLineDrawFff
     * @address 0x17D710
     * @size 0x620
     */
    int Draw(float scale, float alpha);
};

STATIC_ASSERT(sizeof(COutLineDraw) == 0x70);
