#pragma once

#include "common.h"

#include <libvu0.h>

#include <cstring>

#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the collision triangle, the collision geometry that answers
 * queries against a bounded set of triangles, and the frame that places
 * collision geometry in the frame hierarchy.
 */

/**
 *
 * Bits of CColFrame::flags that choose which geometry a query visits.
 *
 */
// clang-format off
enum ColFrameFlag {
    COL_FRAME_FLAG_SELF        = 0x1, /**< The frame's own collision geometry is queried. */
    COL_FRAME_FLAG_NO_CHILDREN = 0x2, /**< The frame's children are not queried; alone, nothing is queried. */
    COL_FRAME_FLAG_UNK_4       = 0x4,
};

// clang-format on

/**
 *
 * Kinds of area that a map collision triangle marks, as CCPoly::area_kind holds them.
 *
 */
enum CCPolyAreaKind {
    COL_AREA_NONE = 0,          /**< Ordinary ground. */
    COL_AREA_WATER = 1,         /**< Water surface that characters splash in. */
    COL_AREA_FLAT = 5,          /**< Flat floor on which events place objects. */
    COL_AREA_FISHING_WATER = 7, /**< Water surface that characters splash in and that a fishing line passes through. */
    COL_AREA_HEALING = 8,       /**< Healing spot that restores the player's characters except the ridepod. */
    COL_AREA_EDIT_WALK = 9,     /**< Ground from which edit mode lets the player walk out. */
    COL_AREA_NO_PLACE = 11,     /**< Surface that stops the search for a flat floor below it. */
};

/**
 *
 * Parts of CCPoly::parts_no for a polygon taken from a placed Georama part.
 *
 */
enum CCPolyPartsNo {
    CCPOLY_PARTS_EDIT = 0x8000,      /**< The polygon belongs to a placed Georama part. */
    CCPOLY_PARTS_SLOT_MASK = 0x7FFF, /**< Placed-part slot of such a polygon. */
};

/**
 *
 * Stores a collision triangle, its plane normal, and the surface
 * attributes it was given by its material.
 *
 */
struct CCPoly {
    sceVu0FVECTOR vertex[3];   /**< Corners of the triangle. */
    sceVu0FVECTOR normal;      /**< Normal of the triangle's plane. */
    short         ground_kind; /**< What the surface is made of. */
    short         foot_sound;  /**< Sound the character's feet play on it. */
    short         area_kind;   /**< Kind of area the surface marks, a CCPolyAreaKind on map collision. */
    short         ignore_mask; /**< Collision query modes that pass through the surface. */
    u_short       parts_no;    /**< Index of the map part the triangle was gathered from. @see CCPolyPartsNo */
    short         attr;        /**< Surface attribute returned by ground collision queries. */
    float         attr_value;  /**< Value associated with the surface attribute. */
};

STATIC_ASSERT(sizeof(CCPoly) == 0x50);

/**
 *
 * Provides the common query interface and bounds for collision
 * geometry; on its own it is an empty box that only answers whether a
 * point lies inside it.
 *
 */
class CCollision {
public:
    int       unk_00{};
    mgVu0FBOX bbox{}; /**< Bounds of the geometry, in the geometry's own space. */

    /**
     *
     * Creates empty geometry with cleared bounds.
     *
     * @mangled __ct__10CCollisionFv
     * @address 0x1647D0
     * @size 0x34
     */
    CCollision() { CCollision::Initialize(); }

    /**
     *
     * Recomputes the bounds from the geometry; the empty box has none.
     *
     * @mangled CreateBBox__10CCollisionFv
     * @address 0x148A50
     * @size 0x8
     */
    virtual void CreateBBox() {}

    /**
     *
     * Reports whether a point lies inside the bounds.
     *
     * @mangled InsidePoint__10CCollisionFPf
     * @address 0x147890
     * @size 0x2C
     */
    virtual int InsidePoint(float *point);

    /**
     *
     * Finds the height of the highest surface under or over a point,
     * writing it to the point's Y; the empty box finds none.
     *
     * @mangled GetMaxY__10CCollisionFPf
     * @address 0x148A60
     * @size 0x8
     */
    virtual int GetMaxY(float *position) { return 0; }

    /**
     *
     * Finds where a segment first meets the geometry; the empty box
     * never meets it.
     *
     * @mangled Intersection__10CCollisionFPfPfPf
     * @address 0x147EF0
     * @size 0x8
     */
    virtual int Intersection(float *from, float *to, float *hit);

    /**
     *
     * Copies the triangles whose bounds meet a box into an array, and
     * returns how many were copied; the empty box has none.
     *
     * @mangled PickUpNearPoly__10CCollisionFP6CCPolyRC9mgVu0FBOXi
     * @address 0x1482A0
     * @size 0x8
     */
    virtual int PickUpNearPoly(CCPoly *poly, const mgVu0FBOX &box, int max);

    /**
     *
     * Copies the bounds into another piece of geometry.
     *
     * @mangled Copy__10CCollisionFR10CCollisionP9mgCMemory
     * @address 0x148A40
     * @size 0x10
     */
    virtual void Copy(CCollision &dest, mgCMemory *memory);

    /**
     *
     * Clears the bounds.
     *
     * @mangled Initialize__10CCollisionFv
     * @address 0x148A70
     * @size 0x14
     */
    virtual void Initialize() {
        unk_00 = 0;
        memset(static_cast<void *>(&bbox), 0, sizeof(bbox));
    }
};

STATIC_ASSERT(sizeof(CCollision) == 0x40);

/**
 *
 * Implements collision queries over the triangles built from an MDT
 * model.
 *
 */
class CCollisionMDT : public CCollision {
public:
    CCPoly *poly;       /**< Triangles the geometry is made of. */
    int     poly_count; /**< Number of triangles in poly. */

    /**
     *
     * Creates geometry with no triangles and cleared bounds.
     *
     */
    CCollisionMDT() {
        CCollision::Initialize();
        poly = nullptr;
        poly_count = 0;
    }

    /**
     *
     * Recomputes the bounds so that they enclose every triangle.
     *
     * @mangled CreateBBox__13CCollisionMDTFv
     * @address 0x147A60
     * @size 0xE0
     */
    void CreateBBox() override;

    /**
     *
     * Finds the height of the highest triangle above or below a point
     * inside the bounds, writing it to the point's Y; returns nonzero
     * when one is found.
     *
     * @mangled GetMaxY__13CCollisionMDTFPf
     * @address 0x147B40
     * @size 0x16C
     */
    int GetMaxY(float *position) override;

    /**
     *
     * Copies at most a given number of triangles whose bounds meet a
     * box into an array, and returns how many were copied.
     *
     * @mangled PickUpNearPoly__13CCollisionMDTFP6CCPolyRC9mgVu0FBOXi
     * @address 0x147CB0
     * @size 0x238
     */
    int PickUpNearPoly(CCPoly *poly, const mgVu0FBOX &box, int max) override;

    /**
     *
     * Clears the bounds and drops the triangles.
     *
     * @mangled Initialize__13CCollisionMDTFv
     * @address 0x148A00
     * @size 0x3C
     */
    void Initialize() override;

    /**
     *
     * Copies the bounds and triangles into other geometry; the triangles
     * are duplicated in a heap when one is given, and shared otherwise.
     *
     * @mangled Copy__13CCollisionMDTFR13CCollisionMDTP9mgCMemory
     * @address 0x1478C0
     * @size 0x1A0
     */
    virtual void Copy(CCollisionMDT &dest, mgCMemory *memory);
};

STATIC_ASSERT(sizeof(CCollisionMDT) == 0x50);

/**
 *
 * Places collision geometry in the frame hierarchy, so that queries
 * made in world space reach the geometry of the frame and its children.
 *
 */
class CColFrame : public mgCFrame {
public:
    u_int       flags{};     /**< Which geometry a query visits. @see ColFrameFlag. */
    CCollision *collision{}; /**< Geometry held by this frame, or null. */

    /**
     *
     * Creates a frame that holds no geometry.
     *
     * @mangled __ct__9CColFrameFv
     * @address 0x1485F0
     * @size 0x44
     */
    CColFrame();

    /**
     *
     * Gives the frame the geometry it holds.
     *
     * @mangled SetCollision__9CColFrameFP10CCollision
     * @address 0x1647C0
     * @size 0x8
     */
    void SetCollision(CCollision *col) { collision = col; }

    /**
     *
     * Reports whether a world-space point lies inside the bounds of the
     * frame's geometry.
     *
     * @mangled InsidePoint__9CColFrameFPf
     * @address 0x147F00
     * @size 0x7C
     */
    int InsidePoint(float *point);

    /**
     *
     * Copies at most a given number of triangles of this frame and its
     * children whose bounds meet a world-space box into an array, moved
     * into world space, and returns how many were copied.
     *
     * @mangled PickUpNearPoly__9CColFrameFP6CCPolyRC9mgVu0FBOXi
     * @address 0x148010
     * @size 0x290
     */
    int PickUpNearPoly(CCPoly *poly, const mgVu0FBOX &box, int max);

    /**
     *
     * Resets the frame to query its own geometry and hold none.
     *
     * @mangled Initialize__9CColFrameFv
     * @address 0x1485E0
     * @size 0x10
     */
    void Initialize() override;

    /**
     *
     * Computes the world-space bounds of the frame's geometry and its
     * children's, and returns nonzero when there are any.
     *
     * @mangled GetWorldBBox__9CColFrameFP9mgVu0FBOX
     * @address 0x1482B0
     * @size 0xF8
     */
    int GetWorldBBox(mgVu0FBOX *box) override;

    /**
     *
     * Draws nothing, since collision geometry is never seen.
     *
     * @mangled Draw__9CColFrameFP14mgCDrawManager
     * @address 0x1489F0
     * @size 0x8
     */
    virtual int Draw(mgCDrawManager *manager) { return 0; }

    /**
     *
     * Draws nothing, since collision geometry is never seen.
     *
     * @mangled Draw__9CColFrameFPUiP14mgCDrawManager
     * @address 0x1489E0
     * @size 0x8
     */
    virtual int Draw(u_int *packet, mgCDrawManager *manager) { return 0; }
};

STATIC_ASSERT(sizeof(CColFrame) == 0x120);

/**
 *
 * Builds the frame hierarchy of a collision model, giving each frame
 * that has geometry the triangles of its MDT model, and returns the
 * array of frames.
 *
 * @mangled LoadCollisionFile__FP10MDS_HEADERP9mgCMemory
 * @address 0x1483B0
 * @size 0x230
 */
CColFrame *LoadCollisionFile(MDS_HEADER *header, mgCMemory *memory);

/**
 *
 * Builds collision geometry from the triangle lists of an MDT model,
 * or returns null when a primitive list is of a kind it does not read
 * or the triangles cannot be allocated.
 *
 * @mangled CreateCollisionMDT__FPUiP9mgCMemory
 * @address 0x148640
 * @size 0x3A0
 */
CCollisionMDT *CreateCollisionMDT(u_int *model, mgCMemory *memory);
