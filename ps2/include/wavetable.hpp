#pragma once

#include "common.h"

/**
 * @file
 * Declares the water surface ripple simulation that animates water textures.
 */

class mgCTexture;

/**
 *
 * Size of the ripple grid along each side.
 *
 */
enum {
    WAVE_TABLE_DIM = 24 /**< Number of grid points along each side of a ripple height field. */
};

/**
 *
 * Simulates small ripples on a square height field and draws the shading
 * of the ripples into a texture, so that water surfaces appear to move.
 *
 */
class CWaveTable {
public:
    union {
        float height[2][WAVE_TABLE_DIM][WAVE_TABLE_DIM]; /**< Two ripple height fields: the current one and the one from the step before. */
        float cells[2][WAVE_TABLE_DIM * WAVE_TABLE_DIM]; /**< Each height field as one row-major array of grid points. */
    };
    int   current;                                   /**< Index (0 or 1) of the height field that holds the current heights. */

    /**
     *
     * Creates a table whose two height fields are flat and whose current
     * height field is the first one.
     *
     * @mangled __ct__10CWaveTableFv
     * @address 0x1A34F0
     * @size 0x90
     */
    CWaveTable();

    /**
     *
     * Destroys the table.
     *
     * @mangled __dt__10CWaveTableFv
     * @address 0x1A3580
     * @size 0x50
     */
    virtual ~CWaveTable();

    /**
     *
     * Draws the slope shading of the current height field into a 24 or 32
     * bit texture as grey strips, then darkens the whole texture.
     *
     * @mangled CreateTexture__10CWaveTableFP10mgCTexture
     * @address 0x1A35D0
     * @size 0x420
     */
    void CreateTexture(mgCTexture *texture);

    /**
     *
     * Advances the ripples by one step, disturbing random grid points of the
     * current height field every fifth call before the step.
     *
     * @mangled GetEffect__10CWaveTableFv
     * @address 0x1A39F0
     * @size 0x150
     */
    void GetEffect();

    /**
     *
     * Computes the next heights of the inner grid points from the current
     * and previous height fields with a damped wave equation, writing them
     * over the previous height field.
     *
     * @mangled Effect__10CWaveTableFv
     * @address 0x1A3B40
     * @size 0x510
     */
    void Effect();
};

STATIC_ASSERT(sizeof(CWaveTable) == 0x1208);
