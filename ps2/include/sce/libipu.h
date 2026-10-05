#pragma once

#include "common.h"

/**
 * Saved state of the IPU and its two DMA channels, captured while a
 * stream's transfers are suspended so they can be resumed later.
 */
typedef struct sceIpuDmaEnv {
    u_int d4madr;  /**< Channel 4 (to IPU) memory address. */
    u_int d4tadr;  /**< Channel 4 (to IPU) tag address. */
    u_int d4qwc;   /**< Channel 4 (to IPU) quadword count. */
    u_int d4chcr;  /**< Channel 4 (to IPU) control register. */
    u_int d3madr;  /**< Channel 3 (from IPU) memory address. */
    u_int d3qwc;   /**< Channel 3 (from IPU) quadword count. */
    u_int d3chcr;  /**< Channel 3 (from IPU) control register. */
    u_int ipubp;   /**< IPU bit-stream pointer register. */
    u_int ipuctrl; /**< IPU control register. */
} sceIpuDmaEnv;

/**
 * One 16x16 macroblock of decoded pixels in 32-bit RGBA.
 */
typedef struct sceIpuRGB32 {
    u_int c[16 * 16]; /**< Pixels of the macroblock, row by row. */
} sceIpuRGB32;
