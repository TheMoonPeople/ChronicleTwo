#pragma once

#include "common.h"

/**
 * @file
 * Declares the program entry point, which brings up the hardware and the IOP and runs the game.
 */

/**
 *
 * Raises the main thread's priority, starts the hardware, the IOP modules and the CD file system, runs the main loop, then shuts the hardware down.
 *
 * @mangled main
 * @address 0x15D7B0
 * @size 0x80
 */
int main();

/**
 *
 * VU1 microprogram that draws water surfaces.
 *
 */
extern u_long128 Vu_prog_wtr[];
