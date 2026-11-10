#pragma once

#include "common.h"

#include "mainloop.hpp"

/**
 * @file
 * Declares the entry, exit and per-frame functions of the debug texture viewer.
 */

/**
 *
 * Parameters that the main loop hands to a mode when it enters it.
 *
 */

/**
 *
 * Entry hook for the debug texture viewer.
 *
 *
 * @mangled InitTextuerViewerMain__F13INIT_LOOP_ARG
 * @address 0x1A3490
 * @size 0x10
 */
void InitTextuerViewerMain(INIT_LOOP_ARG arg);

/**
 *
 * Exit hook for the debug texture viewer.
 *
 *
 * @mangled FinishTextuerVieweMain__Fv
 * @address 0x1A34A0
 * @size 0x10
 */
void FinishTextuerVieweMain();

/**
 *
 * Returns to the main loop from the debug texture viewer.
 *
 *
 * @mangled LoopTextuerViewerMain__Fv
 * @address 0x1A34B0
 * @size 0x10
 */
int LoopTextuerViewerMain();
