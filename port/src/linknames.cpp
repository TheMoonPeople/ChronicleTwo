#include "common.h"

#include <eekernel.h>

#include "main.hpp"
#include "mglib.hpp"

// Placeholders for the retail VU microcode, which the port replaces (docs/vu1); they only give the
// stored addresses something to resolve to. Any upload aborts in the DMA stubs.
u_long128 My_dma_start0[1] = {};
u_long128 Vu_progmain[1] = {};
u_long128 Vu_prog0[1] = {};
u_long128 Vu_prog_sdw[1] = {};
u_long128 Vu_prog_3dsp[1] = {};
u_long128 Vu_prog_wtr[1] = {};

// Retail's linker script value, kept resolvable for the gp fields the game fills.
void *_gp = nullptr;
