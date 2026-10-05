#include "common.h"
#include "intersection.hpp"
#include "mg_math.hpp"
#include "mg_drawenv.hpp"

#include <libvu0.h>

// Code (.text)
#ifdef NONMATCHING
int IntersectionPipeYPoly3(float *pipe, float (*poly)[4], float *normal, float (*hits)[4]) {
    sceVu0FVECTOR axis = {0.0f, normal[1], 0.0f, 0.0f};
    sceVu0FVECTOR tangent;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR side[2];
    sceVu0FVECTOR flat_poly[3];
    sceVu0FVECTOR flat_pipe;
    float radius = pipe[3];
    int count = 0;

    sceVu0OuterProduct(tangent, normal, axis);
    sceVu0OuterProduct(offset, normal, tangent);
    sceVu0Normalize(offset, offset);
    sceVu0ScaleVector(offset, offset, radius);
    sceVu0AddVector(side[0], pipe, offset);
    sceVu0SubVector(side[1], pipe, offset);
    for (int i = 0; i < 2; i++) {
        if (mgCheckPointPoly3_XZ(side[i], poly[0], poly[1], poly[2]) != 0) {
            sceVu0CopyVector(hits[count++], side[i]);
        }
    }
    sceVu0CopyVector(flat_pipe, pipe);
    flat_pipe[1] = 0.0f;
    for (int i = 0; i < 3; i++) {
        sceVu0CopyVector(flat_poly[i], poly[i]);
        flat_poly[i][1] = 0.0f;
        if (mgDistVectorXZ2(pipe, poly[i]) <= radius * radius) {
            sceVu0CopyVector(hits[count++], poly[i]);
        }
    }
    for (int i = 0; i < 3; i++) {
        count += mgIntersectionSphereLine(flat_pipe, flat_poly[i], flat_poly[(i + 1) % 3], hits + count);
    }
    if (count > 0) {
        float plane_height = sceVu0InnerProduct(normal, poly[0]);
        float inverse_y = 1.0f / normal[1];
        for (int i = 0; i < count; i++) {
            hits[i][1] = inverse_y * ((plane_height - normal[0] * hits[i][0]) - normal[2] * hits[i][2]);
        }
    }
    return count;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/intersection", IntersectionPipeYPoly3__FPfPA4_fPfPA4_f);
#endif
int IntersectionPipePoly3(float *pipe, float *axis, float (*tri)[4], float *offset, float (*hits_out)[4]) {
    float basis[4][4];
    float inverse[4][4];
    float helper[4];
    float pts[5][4];
    float hits[11][4];
    sceVu0Normalize(basis[1], axis);
    basis[1][3] = 0.0f;
    mgZeroVector(helper);
    float axis_y;
    if (basis[1][1] < 0.0f) {
        axis_y = -basis[1][1];
    } else {
        axis_y = basis[1][1];
    }
    if (axis_y < 0.9f) {
        helper[1] = 1.0f;
    } else {
        helper[2] = 1.0f;
    }
    sceVu0OuterProduct(basis[0], basis[1], helper);
    basis[0][3] = 0.0f;
    sceVu0OuterProduct(basis[2], basis[0], basis[1]);
    basis[2][3] = 0.0f;
    mgZeroVectorW(basis[3]);
    sceVu0TransposeMatrix(inverse, basis);
    *(u_long128 *)pts[0] = *(u_long128 *)tri[0];
    pts[0][3] = 1.0f;
    *(u_long128 *)pts[1] = *(u_long128 *)tri[1];
    pts[1][3] = 1.0f;
    *(u_long128 *)pts[2] = *(u_long128 *)tri[2];
    pts[2][3] = 1.0f;
    *(u_long128 *)pts[3] = *(u_long128 *)offset;
    pts[3][3] = 0.0f;
    *(u_long128 *)pts[4] = *(u_long128 *)pipe;
    pts[4][3] = 1.0f;
    mgApplyMatrixN(pts, inverse, pts, 5);
    mgPlaneNormal(pts[3], pts[0], pts[1], pts[2]);
    sceVu0Normalize(pts[3], pts[3]);
    pts[4][3] = pipe[3];
    int hit_count = IntersectionPipeYPoly3(pts[4], pts, pts[3], hits);
    if (hit_count == 0) {
        return 0;
    }
    for (int i = 0; i < hit_count; i++) {
        hits[i][3] = 1.0f;
    }
    mgApplyMatrixN(hits_out, basis, hits, hit_count);
    return hit_count;
}
int IntersectionSpherePoly3(float *sphere, float (*tri)[4], float *normal, float *out_push) {
    float to_center[4];
    float hits[2][4];
    float radius = sphere[3];
    float radius_squared = radius * radius;
    sceVu0SubVector(to_center, sphere, tri[0]);
    float height = sceVu0InnerProduct(normal, to_center);
    float distance;
    if (height < 0.0f) {
        distance = -height;
    } else {
        distance = height;
    }
    if (!(distance <= radius)) {
        return 0;
    }
    float push = -height;
    *(u_long128 *)to_center = *(u_long128 *)normal;
    sceVu0ScaleVector(to_center, to_center, push);
    sceVu0ScaleVector(out_push, to_center, -1.0f);
    push = (height < 0.0f) ? push : height;
    out_push[3] = push;
    mgAddVector(to_center, sphere);
    if (mgCheckPointPoly3_XYZ(to_center, tri[0], tri[1], tri[2], normal) != 0) {
        return 1;
    }
    if (mgDistVector2(sphere, tri[0]) <= radius_squared) {
        return 2;
    }
    if (mgDistVector2(sphere, tri[1]) <= radius_squared) {
        return 2;
    }
    if (mgDistVector2(sphere, tri[2]) <= radius_squared) {
        return 2;
    }
    if (mgIntersectionSphereLine(sphere, tri[0], tri[1], hits) > 0) {
        return 3;
    }
    if (mgIntersectionSphereLine(sphere, tri[1], tri[2], hits) > 0) {
        return 3;
    }
    if (mgIntersectionSphereLine(sphere, tri[2], tri[0], hits) > 0) {
        return 3;
    }
    return 0;
}
#ifdef NONMATCHING
int IntersectionBox(float *from, float *to, mgVu0FBOX *box, float (*hits)[4]) {
    sceVu0FVECTOR direction;
    sceVu0FVECTOR segment_max;
    sceVu0FVECTOR segment_min;
    sceVu0FVECTOR point;
    sceVu0FVECTOR candidates[6];
    int count = 0;
    sceVu0SubVector(direction, to, from);
    mgVectorMaxMin(segment_max, segment_min, from, to);
    for (int axis = 0; axis < 3; axis++) {
        for (int face = 0; face < 2; face++) {
            float plane = face == 0 ? box->min[axis] : box->max[axis];
            if (plane >= segment_max[axis] || plane <= segment_min[axis]) {
                continue;
            }
            sceVu0ScaleVector(point, direction, (plane - from[axis]) / direction[axis]);
            sceVu0AddVector(point, point, from);
            int side_axis = (axis + 1) % 3;
            int other_axis = (side_axis + 1) % 3;
            if (point[side_axis] < box->max[side_axis] && point[side_axis] > box->min[side_axis] &&
                point[other_axis] < box->max[other_axis] && point[other_axis] > box->min[other_axis]) {
                point[3] = mgDistVector(point, from);
                sceVu0CopyVector(candidates[count++], point);
            }
        }
    }
    for (int i = 0; i < count - 1; i++) {
        for (int j = i + 1; j < count; j++) {
            if (candidates[j][3] < candidates[i][3]) {
                sceVu0FVECTOR swap;
                sceVu0CopyVector(swap, candidates[i]);
                sceVu0CopyVector(candidates[i], candidates[j]);
                sceVu0CopyVector(candidates[j], swap);
            }
        }
    }
    int hit_count = count > 2 ? 2 : count;
    for (int i = 0; i < hit_count; i++) {
        sceVu0CopyVector(hits[i], candidates[i]);
    }
    return hit_count;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/intersection", IntersectionBox__FPfPfP9mgVu0FBOXPA4_f);
#endif
int IntersectionBox(float *start, float *end, mgVu0FBOX *box, float (*matrix)[4], float (*hits_out)[4]) {
    float local_start[4];
    float local_end[4];
    float hits[2][4];
    float inverse[4][4];
    *(u_long128 *)local_start = *(u_long128 *)start;
    local_start[3] = 1.0f;
    *(u_long128 *)local_end = *(u_long128 *)end;
    local_end[3] = 1.0f;
    mgInversMatrix(inverse, matrix);
    sceVu0ApplyMatrix(local_start, inverse, local_start);
    sceVu0ApplyMatrix(local_end, inverse, local_end);
    int hit_count = IntersectionBox(local_start, local_end, box, hits);
    for (int i = 0; i < hit_count; i++) {
        hits[i][3] = 1.0f;
        sceVu0ApplyMatrix(hits_out[i], matrix, hits[i]);
    }
    return hit_count;
}
int mt_test(RS_STACKDATA *stack, int argc) {
    return 1;
}

// Uninitialised data (.bss)
INCLUDE_BSS(at_161, 0x10);
