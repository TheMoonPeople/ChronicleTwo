#pragma once

#include "common.h"

#include "mainloop.hpp"

/**
 * @file
 * Declares the entry, exit and per-frame functions of the debug sound viewer.
 */

/**
 *
 * Entry hook for the debug sound viewer.
 *
 *
 * @mangled InitSoundViewerMain__F13INIT_LOOP_ARG
 * @address 0x2A9270
 * @size 0x10
 */
void InitSoundViewerMain(INIT_LOOP_ARG arg);

/**
 *
 * Exit hook for the debug sound viewer.
 *
 *
 * @mangled FinishSoundVieweMain__Fv
 * @address 0x2A9280
 * @size 0x10
 */
void FinishSoundVieweMain();

/**
 *
 * Returns to the main loop from the debug sound viewer.
 *
 *
 * @mangled LoopSoundViewerMain__Fv
 * @address 0x2A9290
 * @size 0x10
 */
int LoopSoundViewerMain();
