#pragma once

#include "common.h"

#include "mainloop.hpp"

/**
 * @file
 * Declares the entry, exit and per-frame functions of the debug character viewer.
 */

/**
 *
 * Entry hook for the character viewer, with no setup work.
 *
 * @mangled InitCharaViewerMain__F13INIT_LOOP_ARG
 * @address 0x1A3460
 * @size 0x10
 */
void InitCharaViewerMain(INIT_LOOP_ARG arg);

/**
 *
 * Exit hook for the character viewer.
 *
 * @mangled FinishCharaVieweMain__Fv
 * @address 0x1A3470
 * @size 0x10
 */
void FinishCharaVieweMain();

/**
 *
 * Runs one frame of the character viewer, and returns 1 so that the main loop leaves it at once.
 *
 * @mangled LoopCharaViewerMain__Fv
 * @address 0x1A3480
 * @size 0x10
 */
int LoopCharaViewerMain();
