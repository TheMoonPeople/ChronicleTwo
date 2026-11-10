#pragma once

/**
 * @file
 * Marks a value the PAL release changed from the NTSC release's to make up for
 * its 50 Hz fields. Native gameplay always uses the NTSC value at 60 Hz.
 * The PS2 build retains the original PAL tokens and byte identity.
 * Play time stays in the PAL release's 1/50 s units; NTSC play-time comparisons
 * convert the saved difference to 1/60 s units by multiplying by 6 / 5.
 */

#ifdef PORT
#define PAL_TIMING(pal, ntsc) (ntsc)
#else
#define PAL_TIMING(pal, ntsc) pal
#endif
