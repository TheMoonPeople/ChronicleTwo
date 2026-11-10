#pragma once

#include "common.h"

#include "collision.hpp"
#include "mg_drawenv.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the collision geometry of an edit part in the town editor,
 * which measures how parts overlap one another on the ground plane and
 * sorts their triangles into floors and walls.
 */

/**
 *
 * Holds the collision triangles of a town-editor part and answers the
 * placement questions the editor asks about them on the XZ plane.
 *
 */
class CEditCollision : public CCollisionMDT {
public:
    /**
     *
     * Copies the triangles of one area kind into other geometry, taking
     * the new array from a heap, and refreshes this geometry's bounds;
     * the other geometry is left empty when none match or no heap is given.
     *
     * @mangled Copy__14CEditCollisionFR14CEditCollisioniP9mgCMemory
     * @address 0x1A4680
     * @size 0x1F0
     */
    void Copy(CEditCollision &dest, int plane_no, mgCMemory *memory);

    /**
     *
     * Returns the total area of the triangles projected onto the XZ
     * plane.
     *
     * @mangled AreaXZ__14CEditCollisionFv
     * @address 0x1A4870
     * @size 0xB0
     */
    float AreaXZ();

    /**
     *
     * Measures how much a triangle covers this geometry on the XZ
     * plane, optionally writing the area and the bounds of the covered
     * region, and returns nonzero when they overlap.
     *
     * @mangled OverlapPoly3XZ__14CEditCollisionFPA4_fPfP9mgVu0FBOX
     * @address 0x1A4920
     * @size 0x1E0
     */
    int OverlapPoly3XZ(float (*triangle)[4], float *area, mgVu0FBOX *box);

    /**
     *
     * Returns the area by which another part's geometry, placed by a
     * matrix, covers this geometry on the XZ plane, optionally writing
     * the bounds of the covered region.
     *
     * @mangled OverlapXZ__14CEditCollisionFR14CEditCollisionPA4_fP9mgVu0FBOX
     * @address 0x1A4B00
     * @size 0x100
     */
    float OverlapXZ(CEditCollision &other, float (*matrix)[4], mgVu0FBOX *box);

    /**
     *
     * Measures how much a triangle covers the triangles of this
     * geometry, placed by a matrix, that lie at or below ground level,
     * optionally writing the area, and returns nonzero when they overlap.
     *
     * @mangled OverlapPoly3XZ__14CEditCollisionFPA4_fPA4_fPf
     * @address 0x1A4C00
     * @size 0x2F0
     */
    int OverlapPoly3XZ(float (*triangle)[4], float (*matrix)[4], float *area);

    /**
     *
     * Moves every triangle by a matrix, snapping heights to whole units
     * and recomputing the normals and the bounds.
     *
     * @mangled ApplyMatrix__14CEditCollisionFPA4_f
     * @address 0x1A4EF0
     * @size 0x140
     */
    void ApplyMatrix(float (*matrix)[4]);

    /**
     *
     * Removes the vertical triangles, keeping only the floors, and
     * recomputes the bounds.
     *
     * @mangled DeleteVerticalPoly__14CEditCollisionFv
     * @address 0x1A5030
     * @size 0x1A0
     */
    void DeleteVerticalPoly();

    /**
     *
     * Keeps only the vertical triangles, numbers the walls so that
     * triangles on the same plane share a number, and returns how many
     * walls there are.
     *
     * @mangled PickupVerticalPoly__14CEditCollisionFv
     * @address 0x1A51D0
     * @size 0x2F0
     */
    int PickupVerticalPoly();
};

STATIC_ASSERT(sizeof(CEditCollision) == 0x50);

/**
 *
 * Reports whether two boxes, each given by its largest and smallest
 * corners, overlap on the XZ plane.
 *
 * @mangled ClipBoxXZ__FPfPfPfPf
 * @address 0x1A4050
 * @size 0x50
 */
int ClipBoxXZ(float *max_a, float *min_a, float *max_b, float *min_b);

/**
 *
 * Returns the area of the region of the XZ plane covered by both of two
 * triangles, and when a box is given writes the bounds of that region
 * lifted onto the second triangle's plane.
 *
 * @mangled OverlapPoly3AreaXZ__FPA4_fPA4_fP9mgVu0FBOX
 * @address 0x1A40A0
 * @size 0x5E0
 */
float OverlapPoly3AreaXZ(float (*clipped)[4], float (*clipper)[4], mgVu0FBOX *box);
