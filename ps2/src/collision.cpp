#include "common.h"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mglib.hpp"
#include "collision.hpp"

#include <cstring>
#include <libvu0.h>

#include "mg_dataset.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"

// Code (.text)
int CCollision::InsidePoint(float *point) {
    return mgClipBoxVertex(point, bbox.max, bbox.min) != 0;
}

void CCollisionMDT::Copy(CCollisionMDT &dest, mgCMemory *memory) {
    int i;

    dest.bbox = bbox;
    dest.poly_count = poly_count;

    if (dest.poly_count < 1) {
        dest.poly = 0;
    } else if (memory == 0) {
        dest.poly = poly;
    } else {
        dest.poly = new ((u_long128 *)memory->Alloc(dest.poly_count * sizeof(CCPoly) / 16 + 2)) CCPoly[dest.poly_count];

        if (dest.poly != 0) {
            for (i = 0; i < dest.poly_count; i++) {
                dest.poly[i] = poly[i];
            }
        }
    }
}

#ifdef NONMATCHING
void CCollisionMDT::CreateBBox() {
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;
    CCPoly       *p;
    int           i;

    bbox.min[0] = 0.0f;
    bbox.max[0] = 0.0f;
    bbox.min[1] = 0.0f;
    bbox.max[1] = 0.0f;
    bbox.min[2] = 0.0f;
    bbox.max[2] = 0.0f;
    bbox.min[3] = 1.0f;
    bbox.max[3] = 1.0f;

    p = poly;
    if (p != 0 && poly_count > 0) {
        mgVectorMaxMin(bbox.max, bbox.min, p->vertex[0], p->vertex[1], p->vertex[2]);

        for (i = 0; i < poly_count; i++, p++) {
            mgVectorMaxMin(max, min, p->vertex[0], p->vertex[1], p->vertex[2]);
            mgVectorMaxMin(bbox.max, bbox.min, bbox.max, bbox.min, max, min);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/collision", CreateBBox__13CCollisionMDTFv);
#endif

#ifdef NONMATCHING
int CCollisionMDT::GetMaxY(float *position) {
    sceVu0FVECTOR from;
    sceVu0FVECTOR to;
    sceVu0FVECTOR hit;
    CCPoly       *p;
    float         max_y;
    int           found;
    int           i;

    p = poly;
    if (p == 0) {
        return 0;
    }

    if (position[0] > bbox.max[0]) {
        return 0;
    }

    if (position[2] > bbox.max[2]) {
        return 0;
    }

    if (position[0] < bbox.min[0]) {
        return 0;
    }

    if (position[2] < bbox.min[2]) {
        return 0;
    }

    // A vertical line through the point, which meets every triangle above or below it.
    from[0] = position[0];
    from[1] = 0.0f;
    from[2] = position[2];
    to[0] = position[0];
    to[1] = 1.0f;
    to[2] = position[2];

    found = 0;
    max_y = -1e8f;

    for (i = 0; i < poly_count; i++, p++) {
        if (mgIntersectionPoint_line_poly3(from, to, p->vertex[0], p->vertex[1], p->vertex[2], p->normal, hit) != 0) {
            found = 1;
            if (hit[1] > max_y) {
                max_y = hit[1];
            }
        }
    }

    position[1] = max_y;
    return found;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/collision", GetMaxY__13CCollisionMDTFPf);
#endif

#ifdef NONMATCHING
int CCollisionMDT::PickUpNearPoly(CCPoly *out, const mgVu0FBOX &box, int max) {
    sceVu0FVECTOR query_max;
    sceVu0FVECTOR query_min;
    sceVu0FVECTOR poly_max;
    sceVu0FVECTOR poly_min;
    CCPoly       *p;
    int           num;
    int           i;

    if (poly == 0) {
        return 0;
    }

    if (box.min[0] > bbox.max[0]) {
        return 0;
    }

    if (box.min[1] > bbox.max[1]) {
        return 0;
    }

    if (box.min[2] > bbox.max[2]) {
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

    num = 0;

    query_max[0] = box.max[0];
    query_max[1] = box.max[1];
    query_max[2] = box.max[2];
    query_max[3] = 1.0f;
    query_min[0] = box.min[0];
    query_min[1] = box.min[1];
    query_min[2] = box.min[2];
    query_min[3] = 1.0f;

    {
        register float *held_max = query_max;
        register float *held_min = query_min;

        // Parks the query box in vf10/vf11 for the duration of the search.
        asm {
            lqc2 $vf10, 0x0(held_max)
            lqc2 $vf11, 0x0(held_min)
        }
    }

    p = poly;
    for (i = 0; i < poly_count; i++, p++) {
        mgVectorMaxMin(poly_max, poly_min, p->vertex[0], p->vertex[1], p->vertex[2]);

        if (mgClipBox(query_max, query_min, poly_max, poly_min) != 0) {
            max--;
            num++;
            *out = *p;
            out++;

            if (max < 1) {
                return num;
            }
        }
    }

    return num;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/collision", PickUpNearPoly__13CCollisionMDTFP6CCPolyRC9mgVu0FBOXi);
#endif

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
 * Loads a matrix into the vector unit's registers vf10-vf13 for the
 * transforms trance_normal makes.
 */
void pre_trance_normal(float (*matrix)[4]) {
    asm {
        lqc2 $vf10, 0x0($4)
        lqc2 $vf11, 0x10($4)
        lqc2 $vf12, 0x20($4)
        lqc2 $vf13, 0x30($4)
    }
}

/**
 * Transforms a triangle's corners in place by the matrix pre_trance_normal
 * loaded, and writes the unnormalised normal of the transformed triangle.
 */
void trance_normal(float *v0, float *v1, float *v2, float *normal) {
    asm {
        lqc2 $vf16, 0x0($4)
        lqc2 $vf17, 0x10($4)
        lqc2 $vf18, 0x20($4)
        vmulax.xyzw $ACC, $vf10, $vf16x
        vmadday.xyzw $ACC, $vf11, $vf16y
        vmaddaz.xyzw $ACC, $vf12, $vf16z
        vmaddw.xyzw $vf16, $vf13, $vf16w
        vmulax.xyzw $ACC, $vf10, $vf17x
        vmadday.xyzw $ACC, $vf11, $vf17y
        vmaddaz.xyzw $ACC, $vf12, $vf17z
        vmaddw.xyzw $vf17, $vf13, $vf17w
        vmulax.xyzw $ACC, $vf10, $vf18x
        vmadday.xyzw $ACC, $vf11, $vf18y
        vmaddaz.xyzw $ACC, $vf12, $vf18z
        vmaddw.xyzw $vf18, $vf13, $vf18w
        vsub.xyzw $vf20, $vf17, $vf16
        vsub.xyzw $vf21, $vf18, $vf16
        sqc2 $vf16, 0x0($4)
        sqc2 $vf17, 0x0($5)
        sqc2 $vf18, 0x0($6)
        vnop
        vopmula.xyz $ACC, $vf20, $vf21
        vopmsub.xyz $vf22, $vf21, $vf20
        sqc2 $vf22, 0x0($7)
    }
}

#ifdef NONMATCHING
int CColFrame::PickUpNearPoly(CCPoly *out, const mgVu0FBOX &box, int max) {
    sceVu0FVECTOR corner[8];
    sceVu0FVECTOR local_corner[8];
    sceVu0FVECTOR low_max;
    sceVu0FVECTOR low_min;
    sceVu0FVECTOR high_max;
    sceVu0FVECTOR high_min;
    sceVu0FVECTOR min;
    sceVu0FVECTOR max_corner;
    sceVu0FMATRIX lw_matrix;
    sceVu0FMATRIX inverse_matrix;
    mgVu0FBOX     local_box;
    CColFrame    *frame;
    int           num;
    int           remain;
    int           picked;
    int           i;

    num = 0;
    if (flags == COL_FRAME_FLAG_NO_CHILDREN) {
        return 0;
    }

    if (collision != 0 && (flags & COL_FRAME_FLAG_SELF)) {
        GetLWMatrix(lw_matrix);
        GetInverseMatrix(inverse_matrix);

        *(u_long128 *)min = *(u_long128 *)box.min;
        *(u_long128 *)max_corner = *(u_long128 *)box.max;

        // The eight corners of the world-space box, taken into the frame's space.
        for (i = 0; i < 8; i++) {
            corner[i][0] = (i & 1) ? max_corner[0] : min[0];
            corner[i][1] = (i & 2) ? max_corner[1] : min[1];
            corner[i][2] = (i & 4) ? max_corner[2] : min[2];
            corner[i][3] = 1.0f;
        }

        mgApplyMatrixN(local_corner, inverse_matrix, corner, 8);
        mgVectorMaxMin(low_max, low_min, local_corner[0], local_corner[1], local_corner[2], local_corner[3]);
        mgVectorMaxMin(high_max, high_min, local_corner[4], local_corner[5], local_corner[6], local_corner[7]);
        mgVectorMaxMin(local_box.max, local_box.min, low_max, high_max, low_min, high_min);

        num = collision->PickUpNearPoly(out, local_box, max);

        // The triangles found are in the frame's space; move them back into world space.
        pre_trance_normal(lw_matrix);
        for (i = 0; i < num; i++, out++) {
            trance_normal(out->vertex[0], out->vertex[1], out->vertex[2], out->normal);
        }
    }

    remain = max - num;
    if (remain > 0 && !(flags & COL_FRAME_FLAG_NO_CHILDREN)) {
        for (frame = (CColFrame *)child; frame != 0; frame = (CColFrame *)frame->brother) {
            if (!(flags & COL_FRAME_FLAG_UNK_4)) {
                picked = frame->PickUpNearPoly(out, box, remain);
                num += picked;
                remain -= picked;
                out += picked;

                if (remain < 1) {
                    return num;
                }
            }
        }
    }

    return num;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/collision", PickUpNearPoly__9CColFrameFP6CCPolyRC9mgVu0FBOXi);
#endif

int CCollision::PickUpNearPoly(CCPoly *poly, const mgVu0FBOX &box, int max) {
    return 0;
}

int CColFrame::GetWorldBBox(mgVu0FBOX *box) {
    mgVu0FBOX     world_box;
    mgVu0FBOX     child_box;
    sceVu0FMATRIX lw_matrix;
    mgCFrame     *frame;
    int           found;

    found = 0;
    if (collision != 0 && bound != 0) {
        found = 1;
        GetLWMatrix(lw_matrix);
        mgApplyMatrix(world_box.max, world_box.min, lw_matrix, bound->max, bound->min);
    }

    for (frame = child; frame != 0; frame = frame->brother) {
        if (frame->GetWorldBBox(&child_box) != 0) {
            if (found == 0) {
                world_box = child_box;
            } else {
                mgVectorMaxMin(world_box.max, world_box.min, world_box.max, world_box.min, child_box.max, child_box.min);
            }
            found = 1;
        }
    }

    *box = world_box;
    return found;
}

#ifdef NONMATCHING
CColFrame *LoadCollisionFile(MDS_HEADER *header, mgCMemory *memory) {
    sceVu0FMATRIX  matrix;
    sceVu0FVECTOR  max;
    sceVu0FVECTOR  min;
    CColFrame     *frames;
    CColFrame     *frame;
    MDTOBJ_HEADER *object;
    u_int          i;
    int            row;
    int            column;

    if (header->object_num == 0) {
        return 0;
    }

    frames = new ((u_long128 *)memory->Alloc(header->object_num * sizeof(CColFrame) / 16 + 2)) CColFrame[header->object_num];

    // The object records follow the scene header directly, one fixed-size record each.
    object = (MDTOBJ_HEADER *)(header + 1);
    for (i = 0; i < header->object_num; i++, object++) {
        frame = &frames[i];
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
            mgZeroVector(max);
            mgZeroVector(min);

            frame->collision = CreateCollisionMDT((u_int *)((char *)header + object->mdt_ofs), memory);
            if (frame->collision != 0) {
                max[0] = frame->collision->bbox.max[0];
                max[1] = frame->collision->bbox.max[1];
                max[2] = frame->collision->bbox.max[2];
                max[3] = frame->collision->bbox.max[3];
                min[0] = frame->collision->bbox.min[0];
                min[1] = frame->collision->bbox.min[1];
                min[2] = frame->collision->bbox.min[2];
                min[3] = frame->collision->bbox.min[3];
            }

            frame->bound = new ((u_long128 *)memory->Alloc(sizeof(mgCFrame::BoundInfo) / 16 + 2)) mgCFrame::BoundInfo;
            frame->SetBBox(max, min);
        }
    }

    return frames;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/collision", LoadCollisionFile__FP10MDS_HEADERP9mgCMemory);
#endif

void CColFrame::Initialize() {
    flags = COL_FRAME_FLAG_SELF;
    collision = 0;
    mgCFrame::Initialize();
}

CColFrame::CColFrame() {
    Initialize();
}

#ifdef NONMATCHING
CCollisionMDT *CreateCollisionMDT(u_int *model, mgCMemory *memory) {
    CCollisionMDT *collision;
    MDT_HEADER    *header;
    MDT_FACES     *faces;
    FACES_ID      *first_prim;
    FACES_ID      *prim;
    sceVu0FVECTOR *vertices;
    MDT_MATERIAL_ *materials;
    MDT_MATERIAL_ *material;
    CCPoly        *polys;
    CCPoly        *poly;
    int           *index;
    int            prim_num;
    int            poly_count;
    int            index_count;
    int            material_no;
    int            i;
    int            j;

    collision = new ((u_long128 *)memory->Alloc(sizeof(CCollisionMDT) / 16 + 2)) CCollisionMDT;

    header = (MDT_HEADER *)model;
    vertices = (sceVu0FVECTOR *)((char *)model + header->vertex_ofs);
    materials = (MDT_MATERIAL_ *)((char *)model + header->material_ofs);
    faces = (MDT_FACES *)((char *)model + header->faces_ofs);
    prim_num = faces->prim_num;
    first_prim = (FACES_ID *)(faces + 1);

    // Count the triangles, refusing primitive kinds that are not plain triangle lists.
    poly_count = 0;
    prim = first_prim;
    for (i = 0; i < prim_num; i++) {
        if ((prim->type & 7) == 4) {
            return 0;
        }

        if (prim->type & 0x100) {
            return 0;
        }

        poly_count += prim->face_num / 3;
        prim = (FACES_ID *)&prim->index[prim->face_num];
    }

    polys = (CCPoly *)memory->Alloc(poly_count * sizeof(CCPoly) / 16);
    if (polys == 0) {
        return 0;
    }

    poly = polys;
    prim = first_prim;
    for (i = 0; i < prim_num; i++) {
        index_count = prim->face_num;
        material_no = prim->material;
        index = prim->index;

        for (j = 0; j < index_count; j += 3, index += 3, poly++) {
            *(u_long128 *)poly->vertex[0] = *(u_long128 *)vertices[index[0]];
            *(u_long128 *)poly->vertex[1] = *(u_long128 *)vertices[index[1]];
            *(u_long128 *)poly->vertex[2] = *(u_long128 *)vertices[index[2]];

            if (material_no < 0 || materials == 0) {
                // Clears every surface attribute, from ground_kind through unk_4c.
                memset(&poly->ground_kind, 0, 0x10);
            } else {
                material = &materials[material_no];
                poly->ground_kind = material->diffuse[0] * 0.7f + 0.01f;
                poly->foot_sound = material->diffuse[1] * 0.7f + 0.01f;
                poly->area_kind = material->diffuse[2] * 0.7f + 0.01f;
                poly->ignore_mask = 1.0f - material->diffuse[3];
            }

            mgPlaneNormal(poly->normal, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
        }

        prim = (FACES_ID *)index;
    }

    collision->poly = polys;
    collision->poly_count = poly_count;
    collision->CreateBBox();
    return collision;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/collision", CreateCollisionMDT__FPUiP9mgCMemory);
#endif

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
// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/collision", __vt__9CColFrame__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/collision", __vt__13CCollisionMDT__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/collision", __vt__10CCollision__DATA);
