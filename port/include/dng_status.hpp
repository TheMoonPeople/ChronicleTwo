#pragma once

#include "common.h"

#include "mg_tanime.hpp"
#include "mg_texture.hpp"

/**
 * @file
 * Declares the dungeon status board: the panels at the screen edge that show
 * the hit points, weapon durability and absorption points, active items and
 * status effects of the unit the player controls in a dungeon.
 */

/**
 *
 * Colour and alpha a sprite is drawn with, each in the 0 to 0x80 range of the GS.
 *
 */
struct SP_RGBA {
    int r; /**< Red intensity. */
    int g; /**< Green intensity. */
    int b; /**< Blue intensity. */
    int a; /**< Alpha. */
};

STATIC_ASSERT(sizeof(SP_RGBA) == 0x10);

/**
 *
 * Draws a non-negative number as a row of digit sprites cut from a texture,
 * leaving out leading zeros, and optionally aligning the row to its right end
 * so that it fills the space of the full digit count.
 *
 * @mangled PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA
 * @address 0x1BCEC0
 * @size 0x2A0
 */
void PrintV(int x, int y, int value, mgCTexture *texture, mgRect<int> rect, int digit_count, int right_align,
            int spacing, SP_RGBA *color);

/**
 *
 * Draws a five-digit counter, leading zeros included, with the digit sprites
 * of the system frame texture; it shows the robot's absorption points.
 *
 * @mangled DrawDrumCounter__Fiii
 * @address 0x1BD160
 * @size 0x200
 */
void DrawDrumCounter(int x, int y, int value);

/**
 *
 * Draws the status board of the main characters, slid in by rate: hit points,
 * both weapons' durability and absorption points, the active item slots with
 * their cursor, the magic sword counter and the status effect icons.
 *
 * @mangled DrawMainUnitStatusBord__Ff
 * @address 0x1BD800
 * @size 0x12A0
 */
void DrawMainUnitStatusBord(float rate);

/**
 *
 * Draws the status board of the robot, slid in by rate: hit points, weapon
 * durability and the absorption point counter.
 *
 * @mangled DrawRoboUnitStatusBord__Ff
 * @address 0x1BEAA0
 * @size 0x890
 */
void DrawRoboUnitStatusBord(float rate);

/**
 *
 * Draws the status board of a monster the player has turned into, once
 * rate has reached 1: its hit points and its weapon durability.
 *
 * @mangled DrawMonsterUnitStatusBord__Ff
 * @address 0x1BF330
 * @size 0x670
 */
void DrawMonsterUnitStatusBord(float rate);

/**
 *
 * Clears the low-gauge warnings and draws the status board matching the
 * kind of unit the player now controls.
 *
 * @mangled DrawStatusBord__Fv
 * @address 0x1BF9A0
 * @size 0xA0
 */
void DrawStatusBord();
