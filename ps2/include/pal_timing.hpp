#pragma once

/**
 * @file
 * Marks a value the PAL release changed from the NTSC release's to make up for
 * its 50 Hz fields.
 *
 * `PAL_TIMING(pal, ntsc)` is the PAL value in the PS2 build, which is the PAL
 * release, so the build's tokens are the PAL source's. The port takes the value
 * of the gameplay timing it runs (`game.timing`), latched once at start-up.
 * Play time stays in the PAL release's 1/50 s units in both timings, so the
 * NTSC value of a play-time difference compared with NTSC's 1/60 s limits is
 * the difference times 6 / 5.
 */

#ifdef PORT
#include <cassert>

extern bool PortTimingIsPal;
extern bool PortTimingLatched;

inline bool PortPalTiming() {
    assert(PortTimingLatched && "gameplay timing must be latched before use");
    return PortTimingIsPal;
}

#define PAL_TIMING(pal, ntsc) (PortPalTiming() ? (pal) : (ntsc))
#else
#define PAL_TIMING(pal, ntsc) pal
#endif
