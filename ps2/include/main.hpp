#pragma once

#include "common.h"

/**
 * @file
 * Declares the program entry point, which brings up the hardware and the IOP and runs the game.
 */

/**
 * Raises the main thread's priority, initialises the graphics, CD and IOP
 * modules, runs the main loop, then shuts the hardware down and returns 0.
 *
 * @mangled main
 * @address 0x15D7B0
 * @size 0x80
 */
int main();

/**
 * Initialises the Metrowerks C/C++ runtime (static constructors and library state).
 *
 * @mangled mwInit
 * @address 0x100190
 * @size 0x24
 */
extern "C" void mwInit();

/**
 * VU1 microprogram that draws water surfaces.
 */
extern u_long128 Vu_prog_wtr[];
