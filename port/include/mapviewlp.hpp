#pragma once

#include "common.h"

#include "mainloop.hpp"

/**
 * @file
 * Declares the entry, exit and per-frame functions of the debug map viewer.
 */

/**
 *
 * Entry hook for the debug map viewer.
 *
 *
 * @mangled MapViewInit__F13INIT_LOOP_ARG
 * @address 0x1A34C0
 * @size 0x10
 */
void MapViewInit(INIT_LOOP_ARG arg);

/**
 *
 * Exit hook for the debug map viewer.
 *
 *
 * @mangled MapViewExit__Fv
 * @address 0x1A34D0
 * @size 0x10
 */
void MapViewExit();

/**
 *
 * Returns to the main loop from the debug map viewer.
 *
 *
 * @mangled MapViewLoop__Fv
 * @address 0x1A34E0
 * @size 0x10
 */
int MapViewLoop();
