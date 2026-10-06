#pragma once

#include "common.h"

#include <libvu0.h>
#include <cstring>

/**
 * @file
 * Declares an occluder: a four-cornered plane of a map that hides the placed
 * parts lying wholly behind it as seen from the camera.
 */

/**
 *
 * A four-cornered occluding plane and the view-space volume it hides from the eye.
 *
 */
class COcclusion {
public:
    COcclusion() { memset(this, 0, sizeof(COcclusion)); }

    int enable;                   /**< Non-zero while the occluder is in use. */
    u8 unk_4[0xC];
    sceVu0FVECTOR vertex[4];      /**< Corners of the occluder in world space. */
    int setup;                    /**< Non-zero once the view-space planes have been built. */
    u8 unk_54[0xC];
    sceVu0FVECTOR plane;          /**< Plane of the occluder in view space, facing away from the eye, with its distance term in w. */
    sceVu0FVECTOR side_plane[4];  /**< Planes through the eye and each edge of the occluder, facing inwards, in view space. */
    sceVu0FVECTOR view_min;       /**< Per-component minimum of the corners in view space; z is the nearest depth. */

    /**
     *
     * Builds the view-space planes of the occluder from its corners.
     *
     * @mangled Setup__10COcclusionFPA4_f
     * @address 0x2DAE90
     * @size 0x1F0
     */
    void Setup(sceVu0FMATRIX view_matrix);

    /**
     *
     * Gives back non-zero when the occluder wholly hides a view-space sphere.
     *
     * @mangled CheckSphere__10COcclusionFPf
     * @address 0x2DB080
     * @size 0x130
     */
    int CheckSphere(sceVu0FVECTOR sphere);
};
STATIC_ASSERT(sizeof(COcclusion) == 0xC0);
