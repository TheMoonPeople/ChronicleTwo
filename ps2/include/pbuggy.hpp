#pragma once

#include "common.h"

/**
 * @file
 * Declares the buggy sub game, in which the player drives a buggy armed with a gun and bombs
 * to defend a train, entered through the sub game dispatcher as sub game 3.
 */

struct SubGameInfo;

/**
 *
 * Loads the buggy sub game's characters, textures, effects, sound and BGM; gives 1 on success, 0 on failure.
 *
 * @mangled sgInitBuggy__FP11SubGameInfo
 * @address 0x318B70
 * @size 0x994
 */
int sgInitBuggy(SubGameInfo *info);

/**
 *
 * Releases the buggy sub game's voice, texture blocks, characters, effects and BGM; gives 1 once released.
 *
 * @mangled sgExitBuggy__FP11SubGameInfo
 * @address 0x319510
 * @size 0xE0
 */
int sgExitBuggy(SubGameInfo *info);

/**
 *
 * Advances the buggy sub game by one frame; gives 1 once the game has ended and been released.
 *
 * @mangled sgLoopBuggy__FP11SubGameInfo
 * @address 0x3195F0
 * @size 0x230
 */
int sgLoopBuggy(SubGameInfo *info);

/**
 *
 * Draws the buggy sub game's characters; always gives 1.
 *
 * @mangled sgDrawBuggy__FP11SubGameInfo
 * @address 0x319820
 * @size 0x80
 */
int sgDrawBuggy(SubGameInfo *info);

/**
 *
 * Draws the buggy's gun fire and gun hit effects while they are active; always gives 1.
 *
 * @mangled sgEffectDrawBuggy__FP11SubGameInfo
 * @address 0x3198A0
 * @size 0x90
 */
int sgEffectDrawBuggy(SubGameInfo *info);

/**
 *
 * Draws the shadows of the buggy sub game's characters; always gives 1.
 *
 * @mangled sgDrawShadowBuggy__FP11SubGameInfo
 * @address 0x319930
 * @size 0x60
 */
int sgDrawShadowBuggy(SubGameInfo *info);

/**
 *
 * Draws the buggy sub game's train and buggy health gauges; always gives 1.
 *
 * @mangled sgSystemDrawBuggy__FP11SubGameInfo
 * @address 0x319990
 * @size 0x420
 */
int sgSystemDrawBuggy(SubGameInfo *info);
