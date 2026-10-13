#pragma once

/**
 * @file
 * Marks a value the PAL release changed from the NTSC release's to make up for
 * its 50 Hz fields.
 *
 * `PAL_TIMING(pal, ntsc)` is the PAL value in the PS2 build, which is the PAL
 * release, so the build's tokens are the PAL source's. The port takes the value
 * of the gameplay timing it runs (`game.timing`), latched once at start-up.
 */

#ifdef PORT
bool PortPalTiming();
#define PAL_TIMING(pal, ntsc) (PortPalTiming() ? (pal) : (ntsc))
#else
#define PAL_TIMING(pal, ntsc) pal
#endif
