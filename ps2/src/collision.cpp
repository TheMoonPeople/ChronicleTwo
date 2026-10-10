#include "common.h"

#include <libvu0.h>

#include <cstring>

#include "collision.hpp"
#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

// Code (.text)
int CCollision::InsidePoint(float *point) {
    return mgClipBoxVertex(point, bbox.max, bbox.min) != 0;
}

/**
 *
 * Holds one quadword of collision polygon data for block copying.
 *
 */
struct CollisionQuad {
    float v[4]; /**< Four words copied together. */
};

/**
 *
 * Holds the five quadwords copied for one collision triangle.
 *
 */
struct CollisionTri {
    CollisionQuad q[5]; /**< Polygon data blocks. */
};

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u_int Align16Blocks(u_int n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

void CCollisionMDT::Copy(CCollisionMDT &dest, mgCMemory *memory) {
    int           i;
    CollisionTri *src;
    CollisionTri *dst;
    dest.bbox = bbox;
    dest.poly_count = poly_count;

    if (dest.poly_count <= 0) {
        dest.poly = NULL;
        return;
    }

    if (memory != NULL) {
        dest.poly = (CCPoly *) operator new[](
            dest.poly_count * 0x50,
            memory->Alloc(Align16Blocks(dest.poly_count * 0x50) + 2));
        i = 0;

        if (dest.poly != NULL) {

            for (; i < dest.poly_count; i++) {
                src = reinterpret_cast<CollisionTri *>(&poly[i]);
                dst = reinterpret_cast<CollisionTri *>(&dest.poly[i]);
                dst->q[0] = src->q[0];
                dst->q[1] = src->q[1];
                dst->q[2] = src->q[2];
                dst->q[3] = src->q[3];
                dst->q[4] = src->q[4];
            }
        }
    } else {
        dest.poly = poly;
    }
}

void CCollisionMDT::CreateBBox() {
    float   polygon_max[4];
    float   polygon_min[4];
    int     index;
    CCPoly *polygon;

    bbox.min[0] = 0.0f;
    bbox.max[0] = 0.0f;
    bbox.min[1] = 0.0f;
    bbox.max[1] = 0.0f;
    bbox.min[2] = 0.0f;
    bbox.max[2] = 0.0f;
    bbox.min[3] = 1.0f;
    bbox.max[3] = 1.0f;

    polygon = poly;

    if (polygon == NULL || poly_count <= 0) {
        return;
    }

    mgVectorMaxMin(bbox.max, bbox.min, polygon->vertex[0], polygon->vertex[1], polygon->vertex[2]);

    for (index = 0; index < poly_count; index++, polygon++) {
        mgVectorMaxMin(polygon_max, polygon_min, polygon->vertex[0], polygon->vertex[1], polygon->vertex[2]);
        mgVectorMaxMin(bbox.max, bbox.min, bbox.max, bbox.min, polygon_max, polygon_min);
    }
}

int CCollisionMDT::GetMaxY(float *position) {
    float   from[4];
    float   to[4];
    float   hit[4];
    int     i;
    int     found;
    CCPoly *cursor;
    float   max_y;

    cursor = poly;

    if (cursor == 0) {
        return 0;
    }

    if (!(position[0] <= bbox.max[0])) {
        return 0;
    }

    if (!(position[2] <= bbox.max[2])) {
        return 0;
    }

    if (position[0] < bbox.min[0]) {
        return 0;
    }

    if (position[2] < bbox.min[2]) {
        return 0;
    }

    from[0] = to[0] = position[0];
    from[2] = to[2] = position[2];
    from[1] = 0.0f;
    found = 0;
    max_y = -1e8f;
    to[1] = 1.0f;

    for (i = 0; i < poly_count; i++, cursor++) {
        if (mgIntersectionPoint_line_poly3(from, to, cursor->vertex[0], cursor->vertex[1], cursor->vertex[2], cursor->normal, hit) != 0) {
            found = 1;

            if (max_y < hit[1]) {
                max_y = hit[1];
            }
        }
    }

    position[1] = max_y;
    return found;
}

int CCollisionMDT::PickUpNearPoly(CCPoly *out, const mgVu0FBOX &box, int max) {
    sceVu0FVECTOR box_max;
    sceVu0FVECTOR box_min;
    sceVu0FVECTOR poly_max;
    sceVu0FVECTOR poly_min;
    int           i;
    float        *min_ptr;
    float        *max_ptr;
    int           count;
    CCPoly       *polygon;

    if (poly == NULL) {
        return 0;
    }

    if (!(box.min[0] <= bbox.max[0])) {
        return 0;
    }

    if (!(box.min[1] <= bbox.max[1])) {
        return 0;
    }

    if (!(box.min[2] <= bbox.max[2])) {
        return 0;
    }

    if (box.max[0] < bbox.min[0]) {
        return 0;
    }

    if (box.max[1] < bbox.min[1]) {
        return 0;
    }

    if (box.max[2] < bbox.min[2]) {
        return 0;
    }

    i = 0;
    count = 0;
    // Reload the maximum bounds after the overlap checks for the VU setup.
    const volatile mgVu0FBOX &volatile_box = box;
    box_max[0] = volatile_box.max[0];
    box_max[1] = volatile_box.max[1];
    box_max[2] = volatile_box.max[2];
    box_max[3] = 1.0f;
    box_min[0] = box.min[0];
    box_min[1] = box.min[1];
    box_min[2] = box.min[2];
    box_min[3] = 1.0f;
    max_ptr = box_max;
    min_ptr = box_min;

    asm {
        lqc2 vf10, 0(max_ptr)
        lqc2 vf11, 0(min_ptr)
    }
    polygon = poly;
    for (; i < poly_count; i++, polygon++) {
        mgVectorMaxMin(poly_max, poly_min, polygon->vertex[0], polygon->vertex[1], polygon->vertex[2]);

        if (mgClipBox(box_max, box_min, poly_max, poly_min)) {
            *reinterpret_cast<u_long128 *>(out->vertex[0]) = *reinterpret_cast<u_long128 *>(polygon->vertex[0]);
            *reinterpret_cast<u_long128 *>(out->vertex[1]) = *reinterpret_cast<u_long128 *>(polygon->vertex[1]);
            *reinterpret_cast<u_long128 *>(out->vertex[2]) = *reinterpret_cast<u_long128 *>(polygon->vertex[2]);
            out->ground_kind = polygon->ground_kind;
            out->foot_sound = polygon->foot_sound;
            out->area_kind = polygon->area_kind;
            out->ignore_mask = polygon->ignore_mask;
            out->parts_no = polygon->parts_no;
            out->attr = polygon->attr;
            out->attr_value = polygon->attr_value;
            *reinterpret_cast<u_long128 *>(out->normal) = *reinterpret_cast<u_long128 *>(polygon->normal);
            max--;
            count++;
            out++;

            if (max <= 0) {
                break;
            }
        }
    }

    return count;
}

int CCollision::Intersection(float *from, float *to, float *hit) {
    return 0;
}

int CColFrame::InsidePoint(float *point) {
    sceVu0FVECTOR local_point;
    sceVu0FMATRIX lw_matrix;
    sceVu0FMATRIX inverse_matrix;

    if (collision == 0) {
        return 0;
    }

    GetLWMatrix(lw_matrix);
    GetInverseMatrix(inverse_matrix);
    point[3] = 1.0f;
    sceVu0ApplyMatrix(local_point, inverse_matrix, point);
    return collision->InsidePoint(local_point);
}

/**
 *
 * Loads a matrix into the vector unit's registers vf10-vf13 for the
 * transforms trance_normal makes.
 *
 */
#pragma force_active on
#pragma global_optimizer off
/**
 *
 * Loads the matrix used to transform collision normals into VU0 registers.
 *
 */
static asm void pre_trance_normal(float (*matrix)[4]) {
    .set noreorder
    lqc2 vf10, 0(a0)
    lqc2 vf11, 0x10(a0)
    lqc2 vf12, 0x20(a0)
    jr ra
    lqc2 vf13, 0x30(a0)
}
#pragma global_optimizer reset

/**
 *
 * Transforms a triangle's corners in place by the matrix pre_trance_normal
 * loaded, and writes the unnormalised normal of the transformed triangle.
 *
 */
#pragma global_optimizer off
static asm void trance_normal(float *v0, float *v1, float *v2, float *normal) {
    .set noreorder
    lqc2 vf16, 0(a0)
    lqc2 vf17, 0x10(a0)
    lqc2 vf18, 0x20(a0)
    vmulax.xyzw ACC, vf10, vf16x
    vmadday.xyzw ACC, vf11, vf16y
    vmaddaz.xyzw ACC, vf12, vf16z
    vmaddw.xyzw vf16, vf13, vf16w
    vmulax.xyzw ACC, vf10, vf17x
    vmadday.xyzw ACC, vf11, vf17y
    vmaddaz.xyzw ACC, vf12, vf17z
    vmaddw.xyzw vf17, vf13, vf17w
    vmulax.xyzw ACC, vf10, vf18x
    vmadday.xyzw ACC, vf11, vf18y
    vmaddaz.xyzw ACC, vf12, vf18z
    vmaddw.xyzw vf18, vf13, vf18w
    vsub.xyzw vf20, vf17, vf16
    vsub.xyzw vf21, vf18, vf16
    sqc2 vf16, 0(a0)
    sqc2 vf17, 0(a1)
    sqc2 vf18, 0(a2)
    vnop
    vopmula.xyz ACC, vf20, vf21
    vopmsub.xyz vf22, vf21, vf20
    jr ra
    sqc2 vf22, 0(a3)
}
#pragma global_optimizer reset
#pragma force_active reset

int CColFrame::PickUpNearPoly(CCPoly *out, const mgVu0FBOX &box, int max) {
    sceVu0FVECTOR corners[8];
    sceVu0FVECTOR transformed[8];
    sceVu0FVECTOR max0;
    sceVu0FVECTOR min0;
    sceVu0FVECTOR max1;
    sceVu0FVECTOR min1;
    sceVu0FVECTOR bmin;
    sceVu0FVECTOR bmax;
    sceVu0FMATRIX world;
    sceVu0FMATRIX inverse;
    mgVu0FBOX     local_box;
    int           count;
    int           i;
    CColFrame    *node;
    int           added;

    count = 0;

    if (flags == COL_FRAME_FLAG_NO_CHILDREN) {
        return 0;
    }

    if (collision != NULL && (flags & COL_FRAME_FLAG_SELF)) {
        GetLWMatrix(world);
        GetInverseMatrix(inverse);
        *reinterpret_cast<u_long128 *>(bmin) = *reinterpret_cast<const u_long128 *>(box.min);
        *reinterpret_cast<u_long128 *>(bmax) = *reinterpret_cast<const u_long128 *>(box.max);
        corners[0][0] = bmin[0];
        corners[0][1] = bmin[1];
        corners[0][2] = bmin[2];
        corners[0][3] = 1.0f;
        corners[1][0] = bmax[0];
        corners[1][1] = bmin[1];
        corners[1][2] = bmin[2];
        corners[1][3] = 1.0f;
        corners[2][0] = bmin[0];
        corners[2][1] = bmax[1];
        corners[2][2] = bmin[2];
        corners[2][3] = 1.0f;
        corners[3][0] = bmax[0];
        corners[3][1] = bmax[1];
        corners[3][2] = bmin[2];
        corners[3][3] = 1.0f;
        corners[4][0] = bmin[0];
        corners[4][1] = bmin[1];
        corners[4][2] = bmax[2];
        corners[4][3] = 1.0f;
        corners[5][0] = bmax[0];
        corners[5][1] = bmin[1];
        corners[5][2] = bmax[2];
        corners[5][3] = 1.0f;
        corners[6][0] = bmin[0];
        corners[6][1] = bmax[1];
        corners[6][2] = bmax[2];
        corners[6][3] = 1.0f;
        corners[7][0] = bmax[0];
        corners[7][1] = bmax[1];
        corners[7][2] = bmax[2];
        corners[7][3] = 1.0f;
        mgApplyMatrixN(transformed, inverse, corners, 8);
        mgVectorMaxMin(max0, min0, transformed[0], transformed[1], transformed[2], transformed[3]);
        mgVectorMaxMin(max1, min1, transformed[4], transformed[5], transformed[6], transformed[7]);
        mgVectorMaxMin(local_box.max, local_box.min, max0, max1, min0, min1);
        count = collision->PickUpNearPoly(out, local_box, max);
        pre_trance_normal(world);

        for (i = 0; i < count; i++) {
            trance_normal(out->vertex[0], out->vertex[1], out->vertex[2], out->normal);
            out++;
        }
    }

    max -= count;

    if (max <= 0) {
        return count;
    }

    if (!(flags & COL_FRAME_FLAG_NO_CHILDREN)) {
        for (node = static_cast<CColFrame *>(child); node != NULL; node = static_cast<CColFrame *>(node->brother)) {
            if (!(flags & COL_FRAME_FLAG_UNK_4)) {
                added = node->PickUpNearPoly(out, box, max);
                out += added;
                count += added;
                max -= added;

                if (max <= 0) {
                    break;
                }
            }
        }
    }

    return count;
}

int CCollision::PickUpNearPoly(CCPoly *poly, const mgVu0FBOX &box, int max) {
    return 0;
}

int CColFrame::GetWorldBBox(mgVu0FBOX *box) {
    mgVu0FBOX *result = box;
    mgVu0FBOX  world_box;
    float      matrix[4][4];
    mgVu0FBOX  child_box;
    int        found = 0;
    mgCFrame  *node = this;

    if (collision != NULL && bound != NULL) {
        found = 1;
        GetLWMatrix(matrix);
        mgApplyMatrix(world_box.max, world_box.min, matrix, bound->max, bound->min);
    }

    for (node = node->child; node != NULL; node = node->brother) {
        if (node->GetWorldBBox(&child_box) != 0) {
            if (found == 0) {
                world_box = child_box;
            } else {
                mgVectorMaxMin(world_box.max, world_box.min, world_box.max, world_box.min, child_box.max,
                               child_box.min);
            }

            found = 1;
        }
    }

    *result = world_box;
    return found;
}

CColFrame *LoadCollisionFile(MDS_HEADER *header, mgCMemory *memory) {
    u_char        *data = (u_char *) header;
    sceVu0FMATRIX  matrix;
    sceVu0FVECTOR  max;
    sceVu0FVECTOR  min;
    u_int          i;
    int            column;
    u_char        *cursor;
    CColFrame     *frames;
    int            row;
    MDTOBJ_HEADER *object;
    CColFrame     *frame;
    int            offset;

    cursor = (u_char *) header;
    cursor += sizeof(MDS_HEADER);

    if (header->object_num == 0) {
        return 0;
    }

    frames = new ((u_long128 *) memory->Alloc(Align16Blocks(header->object_num * sizeof(CColFrame)) + 2)) CColFrame[header->object_num];

    i = 0;

    for (offset = 0; i < ((MDS_HEADER *) data)->object_num; offset += sizeof(CColFrame), i++) {
        object = (MDTOBJ_HEADER *) cursor;
        cursor += sizeof(MDTOBJ_HEADER);
        frame = (CColFrame *) ((u_char *) frames + offset);
        frame->Initialize();

        for (column = 0; column < 4; column++) {
            for (row = 0; row < 4; row++) {
                matrix[row][column] = object->matrix[row][column];
            }
        }

        frame->SetName(object->name);
        frame->SetTransMatrix(matrix);

        if (object->parent < 0) {
            frame->SetParent(0);
        } else {
            frame->SetParent(&frames[object->parent]);
        }

        if (object->mdt_ofs != 0) {
            u_int *model = (u_int *) (data + object->mdt_ofs);
            mgZeroVector(max);
            mgZeroVector(min);

            frame->collision = CreateCollisionMDT(model, memory);

            if (frame->collision != 0) {
                *(u_long128 *) max = *(u_long128 *) frame->collision->bbox.max;
                *(u_long128 *) min = *(u_long128 *) frame->collision->bbox.min;
            }

            frame->bound = new ((u_long128 *) memory->Alloc(sizeof(mgCFrame::BoundInfo) / 16 + 2)) mgCFrame::BoundInfo;
            frame->SetBBox(max, min);
        }
    }

    return frames;
}

void CColFrame::Initialize() {
    flags = COL_FRAME_FLAG_SELF;
    collision = 0;
    mgCFrame::Initialize();
}

CColFrame::CColFrame() {
    Initialize();
}

CCollisionMDT *CreateCollisionMDT(u_int *model, mgCMemory *memory) {
    MDT_HEADER    *header = (MDT_HEADER *) model;
    int            index_count;
    sceVu0FVECTOR *vertices;
    MDT_MATERIAL_ *materials;
    MDT_FACES     *faces;
    int            j;
    int            material_no;
    FACES_ID      *first_prim;
    CCPoly        *polys;
    int            poly_count;
    int            prim_num;
    CCollisionMDT *collision;
    CCPoly        *poly;
    int           *words;
    int            polygon_no;
    int            i;

    collision = new ((u_long128 *) memory->Alloc(Align16Blocks(sizeof(CCollisionMDT)) + 2)) CCollisionMDT;

    vertices = (sceVu0FVECTOR *) ((char *) header + header->vertex_ofs);
    materials = (MDT_MATERIAL_ *) ((char *) header + header->material_ofs);
    faces = (MDT_FACES *) ((char *) header + header->faces_ofs);
    prim_num = faces->prim_num;
    first_prim = (FACES_ID *) (faces + 1);

    poly_count = 0;
    words = (int *) first_prim;

    for (i = 0; i < prim_num; i++) {
        int type = words[0];

        if ((type & 7) == 4) {
            return 0;
        }

        if (type & 0x100) {
            return 0;
        }

        int face_num = words[1];
        words = (int *) &((FACES_ID *) words)->material;
        words++;
        poly_count += face_num / 3;
        words += face_num;
    }

    polys = (CCPoly *) memory->Alloc(poly_count * sizeof(CCPoly) / 16);

    if (polys == 0) {
        return 0;
    }

    polygon_no = 0;
    words = (int *) first_prim;

    for (i = 0; i < prim_num; i++) {
        index_count = words[1];
        words = (int *) &((FACES_ID *) words)->material;
        material_no = *words++;

        for (j = 0; j < index_count; j += 3) {
            poly = &polys[polygon_no++];
            *(u_long128 *) poly->vertex[0] = *(u_long128 *) vertices[words[0]];
            *(u_long128 *) poly->vertex[1] = *(u_long128 *) vertices[words[1]];
            *(u_long128 *) poly->vertex[2] = *(u_long128 *) vertices[words[2]];
            words += 3;

            if (material_no >= 0 && materials != 0) {
                poly->ground_kind = materials[material_no].diffuse[0] * 0.7f + 0.01f;
                poly->foot_sound = materials[material_no].diffuse[1] * 0.7f + 0.01f;
                poly->area_kind = materials[material_no].diffuse[2] * 0.7f + 0.01f;
                poly->ignore_mask = 1.0f - materials[material_no].diffuse[3];
            } else {
                memset(&poly->ground_kind, 0, 0x10);
            }

            mgPlaneNormal(poly->normal, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
        }
    }

    collision->poly = polys;
    collision->poly_count = poly_count;
    collision->CreateBBox();
    return collision;
}

// Defined in collision.hpp.
// Defined in collision.hpp.
// Defined in collision.hpp.
void CCollisionMDT::Initialize() {
    CCollision::Initialize();
    poly = 0;
    poly_count = 0;
}

// Defined in collision.hpp.
void CCollision::Copy(CCollision &dest, mgCMemory *memory) {
    dest.bbox = bbox;
}

// Defined in collision.hpp.
// Defined in collision.hpp.
// Defined in collision.hpp.
