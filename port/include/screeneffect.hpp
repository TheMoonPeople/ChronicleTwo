#pragma once

#include "common.h"

#include "mg_texture.hpp"

/**
 * @file
 * Declares the full-screen post effects: depth of field blur and the sun's lens flare.
 */

/**
 *
 * Blurs the parts of the frame lying beyond each given depth by drawing a
 * shrunken copy of the frame buffer back over the screen, depth tested
 * against those depths, once per level.
 *
 * @mangled DepthOfField__FiPfP10mgCTexturef
 * @address 0x17F760
 * @size 0x740
 */
void DepthOfField(int levels, float *depths, mgCTexture *work_texture, float strength);

/**
 *
 * Draws the glare of a light source over the whole screen, fading as its
 * screen position moves away from the centre, using two work textures
 * from the given texture bank.
 *
 * @mangled LensFlare__FPiPfiPcPc
 * @address 0x17FEA0
 * @size 0xB40
 */
void LensFlare(int *screen, float *color, int bank, char *texture_a, char *texture_b);
