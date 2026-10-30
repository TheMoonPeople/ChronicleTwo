#pragma once

/**
 * @file
 * Marks a value the PAL release changed from the NTSC release's to make up for
 * its 50 Hz fields. Native gameplay always uses the NTSC value at 60 Hz.
 * Play time stays in the PAL release's 1/50 s units; NTSC play-time comparisons
 * convert the saved difference to 1/60 s units by multiplying by 6 / 5.
 */

#define PAL_TIMING(pal, ntsc) (ntsc)
