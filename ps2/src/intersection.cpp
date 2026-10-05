#include "common.h"
#include "intersection.hpp"
#include "mg_math.hpp"

#include <libvu0.h>

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/intersection", IntersectionPipeYPoly3__FPfPA4_fPfPA4_f);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/intersection", IntersectionBox__FPfPfP9mgVu0FBOXPA4_f);
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
