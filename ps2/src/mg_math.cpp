#include "common.h"

#include <libvu0.h>

#include <cmath>
#include <cstdlib>

#include "mg_drawenv.hpp"
#include "mg_math.hpp"

int         Check_Point_Poly3(float x, float y, float x0, float y0, float x1, float y1, float x2, float y2);
static void MulMatrix3(float (*matrix)[4], float (*second)[4], float (*third)[4]);

// Code (.text)
asm void mgFotI4(int *out, float *in) {
    .set noreorder
    lqc2 vf1, 0x0(a1)
    vftoi4.xyzw vf1, vf1
    jr ra
    sqc2 vf1, 0x0(a0)
}
asm void mgCreateBox8(float (*corners)[4], float *max, float *min) {
    .set noreorder
    lqc2 vf1, 0x0(a1)
    lqc2 vf2, 0x0(a2)
    vaddx.xyzw vf3, vf2, vf0x
    vaddx.xyzw vf4, vf2, vf0x
    vaddx.xyzw vf5, vf2, vf0x
    vaddx.xyzw vf6, vf1, vf0x
    vaddx.xyzw vf7, vf1, vf0x
    vaddx.xyzw vf8, vf1, vf0x
    sqc2 vf2, 0x0(a0)
    sqc2 vf1, 0x70(a0)
    vaddx.x vf3, vf1, vf0x
    vaddx.y vf4, vf1, vf0x
    vaddx.z vf5, vf1, vf0x
    vaddx.x vf6, vf2, vf0x
    vaddx.y vf7, vf2, vf0x
    vaddx.z vf8, vf2, vf0x
    sqc2 vf3, 0x10(a0)
    sqc2 vf4, 0x20(a0)
    sqc2 vf5, 0x40(a0)
    sqc2 vf6, 0x60(a0)
    sqc2 vf7, 0x50(a0)
    jr ra
    sqc2 vf8, 0x30(a0)
}

void mgZeroVector(float *vector) {
    *reinterpret_cast<u_long128 *>(vector) = 0;
}

asm void mgZeroVectorW(float *vector) {
    .set noreorder
    jr ra
    sqc2 vf0, 0x0(a0)
}
asm int mgClipBoxVertex(float *point, float *max, float *min) {
    .set noreorder
    lqc2 vf1, 0x0(a0)
    lqc2 vf10, 0x0(a1)
    lqc2 vf11, 0x0(a2)
    ctc2.ni zero, vi16
    vsub.xyz vf25, vf10, vf1
    vsub.xyz vf25, vf1, vf11
    vnop
    vnop
    vnop
    vnop
    vnop
    cfc2.ni v0, vi16
    andi v0, v0, 0x80
    xor v0, v0, zero
    jr ra
    sltiu v0, v0, 0x1
}
asm int mgClipBox(float *max0, float *min0, float *max1, float *min1) {
    .set noreorder
    lqc2 vf10, 0x0(a0)
    lqc2 vf11, 0x0(a1)
    lqc2 vf1, 0x0(a2)
    lqc2 vf2, 0x0(a3)
    ctc2.ni zero, vi16
    vsub.xyz vf25, vf10, vf2
    vsub.xyz vf25, vf1, vf11
    vnop
    vnop
    vnop
    vnop
    vnop
    cfc2.ni v0, vi16
    andi v0, v0, 0x80
    xor v0, v0, zero
    jr ra
    sltiu v0, v0, 0x1
}
asm int mgClipBoxW(float *max0, float *min0, float *max1, float *min1) {
    .set noreorder
    lqc2 vf10, 0x0(a0)
    lqc2 vf11, 0x0(a1)
    lqc2 vf1, 0x0(a2)
    lqc2 vf2, 0x0(a3)
    ctc2.ni zero, vi16
    vsub.xyw vf25, vf10, vf2
    vsub.xyw vf25, vf1, vf11
    vnop
    vnop
    vnop
    vnop
    vnop
    cfc2.ni v0, vi16
    andi v0, v0, 0x80
    xor v0, v0, zero
    jr ra
    sltiu v0, v0, 0x1
}
asm int mgClipInBox(float *max0, float *min0, float *max1, float *min1) {
    .set noreorder
    lqc2 vf10, 0x0(a0)
    lqc2 vf11, 0x0(a1)
    lqc2 vf1, 0x0(a2)
    lqc2 vf2, 0x0(a3)
    ctc2.ni zero, vi16
    vsub.xyz vf25, vf1, vf10
    vsub.xyz vf25, vf11, vf2
    vnop
    vnop
    vnop
    vnop
    vnop
    cfc2.ni v0, vi16
    andi v0, v0, 0x80
    xor v0, v0, zero
    jr ra
    sltiu v0, v0, 0x1
}
#ifdef NONMATCHING
int mgClipInBoxW(float *max0, float *min0, float *max1, float *min1) {
    for (int axis = 0; axis < 3; ++axis) {
        int i = axis == 2 ? 3 : axis;
        if (max1[i] - max0[i] < 0.0f || min0[i] - min1[i] < 0.0f) {
            return 0;
        }
    }
    return 1;
}
#else
asm int mgClipInBoxW(float *max0, float *min0, float *max1, float *min1) {
    .set noreorder
    lqc2 vf10, 0x0(a0)
    lqc2 vf11, 0x0(a1)
    lqc2 vf1, 0x0(a2)
    lqc2 vf2, 0x0(a3)
    ctc2.ni zero, vi16
    vsub.xyw vf25, vf1, vf10
    vsub.xyw vf25, vf11, vf2
    vnop
    vnop
    vnop
    vnop
    vnop
    cfc2.ni v0, vi16
    andi v0, v0, 0x80
    xor v0, v0, zero
    jr ra
    sltiu v0, v0, 0x1
}
#endif
asm void mgAddVector(float *vector, float *add) {
    .set noreorder
    lqc2 vf15, 0x0(a0)
    lqc2 vf16, 0x0(a1)
    vadd.xyzw vf15, vf15, vf16
    jr ra
    sqc2 vf15, 0x0(a0)
}
asm void mgSubVector(float *vector, float *sub) {
    .set noreorder
    lqc2 vf15, 0x0(a0)
    lqc2 vf16, 0x0(a1)
    vsub.xyzw vf15, vf15, vf16
    jr ra
    sqc2 vf15, 0x0(a0)
}

void mgNormalizeVector(float *out, float *in, float length) {
    sceVu0FVECTOR unit;

    sceVu0Normalize(unit, in);
    sceVu0ScaleVector(out, unit, length);
}

asm void mgVectorMin(float *min, float *a, float *b) {
    .set noreorder
    lqc2 vf15, 0x0(a1)
    lqc2 vf16, 0x0(a2)
    vmini.xyzw vf18, vf15, vf16
    jr ra
    sqc2 vf18, 0x0(a0)
}
asm void mgVectorMin(float *min, float *a, float *b, float *c, float *d) {
    .set noreorder
    lqc2 vf15, 0x0(a1)
    lqc2 vf16, 0x0(a2)
    lqc2 vf17, 0x0(a3)
    lqc2 vf18, 0x0(t0)
    vmini.xyzw vf20, vf15, vf16
    vmini.xyzw vf20, vf20, vf17
    vmini.xyzw vf20, vf20, vf18
    jr ra
    sqc2 vf20, 0x0(a0)
}
asm void mgVectorMaxMin(float *max, float *min, float *a, float *b) {
    .set noreorder
    lqc2 vf15, 0x0(a2)
    lqc2 vf16, 0x0(a3)
    vmax.xyzw vf18, vf15, vf16
    vmini.xyzw vf20, vf15, vf16
    sqc2 vf18, 0x0(a0)
    jr ra
    sqc2 vf20, 0x0(a1)
}
asm void mgVectorMaxMin(float *max, float *min, float *a, float *b, float *c) {
    .set noreorder
    lqc2 vf15, 0x0(a2)
    lqc2 vf16, 0x0(a3)
    lqc2 vf17, 0x0(t0)
    vmax.xyzw vf18, vf15, vf16
    vmini.xyzw vf20, vf15, vf16
    vmax.xyzw vf19, vf18, vf17
    vmini.xyzw vf21, vf20, vf17
    sqc2 vf19, 0x0(a0)
    jr ra
    sqc2 vf21, 0x0(a1)
}
asm void mgVectorMaxMin(float *max, float *min, float *a, float *b, float *c, float *d) {
    .set noreorder
    lqc2 vf15, 0x0(a2)
    lqc2 vf16, 0x0(a3)
    lqc2 vf17, 0x0(t0)
    lqc2 vf18, 0x0(t1)
    vmax.xyzw vf20, vf15, vf16
    vmini.xyzw vf21, vf15, vf16
    vmax.xyzw vf20, vf20, vf17
    vmini.xyzw vf21, vf21, vf17
    vmax.xyzw vf20, vf20, vf18
    vmini.xyzw vf21, vf21, vf18
    sqc2 vf20, 0x0(a0)
    jr ra
    sqc2 vf21, 0x0(a1)
}
asm void mgBoxMaxMin(mgVu0FBOX *box, mgVu0FBOX *other) {
    .set noreorder
    lqc2 vf15, 0x0(a0)
    lqc2 vf16, 0x10(a0)
    lqc2 vf17, 0x0(a1)
    lqc2 vf18, 0x10(a1)
    vmax.xyzw vf20, vf15, vf16
    vmini.xyzw vf21, vf15, vf16
    vmax.xyzw vf20, vf20, vf17
    vmini.xyzw vf21, vf21, vf17
    vmax.xyzw vf20, vf20, vf18
    vmini.xyzw vf21, vf21, vf18
    sqc2 vf20, 0x0(a0)
    jr ra
    sqc2 vf21, 0x10(a0)
}
asm void mgPlaneNormal(float *normal, float *v0, float *v1, float *v2) {
    .set noreorder
    lqc2 vf15, 0x0(a1)
    lqc2 vf16, 0x0(a2)
    lqc2 vf17, 0x0(a3)
    vsub.xyzw vf10, vf16, vf15
    vsub.xyzw vf11, vf17, vf15
    vopmula.xyz ACC, vf10, vf11
    vopmsub.xyz vf12, vf11, vf10
    jr ra
    sqc2 vf12, 0x0(a0)
}

float mgDistPlanePoint(float *normal, float *on_plane, float *point) {
    sceVu0FVECTOR offset;

    sceVu0SubVector(offset, point, on_plane);
    return sceVu0InnerProduct(normal, offset);
}

float mgDistLinePoint(float *point, float *start, float *end, float *nearest) {
    float to_start[4];
    float to_end[4];
    float offset[4];
    float foot[4];
    float along[4];
    float line_length;
    float t;
    float dist_start;
    float dist_end;
    sceVu0SubVector(to_start, start, point);
    sceVu0SubVector(to_end, end, point);
    sceVu0SubVector(along, to_end, to_start);
    line_length = mgDistVector(along);
    line_length = line_length * line_length;
    t = -sceVu0InnerProduct(to_start, along) / line_length;

    if (t < 0.0f || !(t <= 1.0f)) {
        dist_start = mgDistVector(point, start);
        dist_end = mgDistVector(point, end);

        if (dist_start < dist_end) {
            sceVu0CopyVector(nearest, start);
            return dist_start;
        }

        sceVu0CopyVector(nearest, end);
        return dist_end;
    }

    sceVu0ScaleVector(foot, along, t);
    sceVu0AddVector(foot, to_start, foot);
    sceVu0AddVector(nearest, foot, point);
    return mgDistVector(foot);
}

float mgReflectionPlane(float *normal, float *on_plane, float *point, float *reflection) {
    sceVu0FVECTOR step;
    float         distance;

    distance = 2.0f * mgDistPlanePoint(normal, on_plane, point);
    sceVu0ScaleVector(step, normal, -distance);
    sceVu0SubVector(reflection, on_plane, point);
    sceVu0SubVector(reflection, reflection, step);
    return distance;
}

int mgIntersectionSphereLine0(float radius, float *from, float *to, float (*hits)[4]) {
    float delta[4];
    float scaled[4];
    float a;
    float b;
    float c;
    float discriminant;
    float root;
    float t1;
    float t2;
    int   count;

    // Solves |from + line * t|^2 = radius^2 for t within the segment.
    sceVu0SubVector(delta, to, from);
    a = mgDistVector2(delta);
    b = sceVu0InnerProduct(delta, from);
    c = mgDistVector2(from) - radius * radius;
    discriminant = b * b - a * c;

    if (discriminant < 0.0f) {
        return 0;
    }

    root = sqrtf(discriminant);
    count = 0;
    t1 = (-b - root) / a;
    t2 = (-b + root) / a;

    if (!(t1 < 0.0f) && t1 <= 1.0f) {
        sceVu0ScaleVector(scaled, delta, t1);
        sceVu0AddVector(hits[0], from, scaled);
        count++;
    }

    // A grazing line touches the sphere once.
    if (discriminant == 0.0f) {
        return 1;
    }

    if (!(t2 < 0.0f)) {
        if (t2 <= 1.0f) {
            sceVu0ScaleVector(scaled, delta, t2);
            sceVu0AddVector(hits[count], from, scaled);
            count++;
        }
    }

    return count;
}

int mgIntersectionSphereLine(float *sphere, float *from, float *to, float (*hits)[4]) {
    sceVu0FVECTOR local_from;
    sceVu0FVECTOR local_to;
    float         radius;
    int           count;
    int           i;

    radius = sphere[3];
    sceVu0SubVector(local_from, from, sphere);
    sceVu0SubVector(local_to, to, sphere);
    count = mgIntersectionSphereLine0(radius, local_from, local_to, hits);

    for (i = 0; i < count; i++) {
        mgAddVector(hits[i], sphere);
    }

    return count;
}

int mgIntersectionPoint_line_poly3(float *from, float *to, float *v0, float *v1, float *v2, float *normal, float *hit) {
    sceVu0FVECTOR line;
    sceVu0FVECTOR e0;
    sceVu0FVECTOR e1;
    sceVu0FVECTOR e2;
    float         above;
    float         along;

    sceVu0SubVector(line, to, from);
    sceVu0SubVector(e0, v0, from);
    sceVu0SubVector(e1, v1, from);
    sceVu0SubVector(e2, v2, from);
    above = -sceVu0InnerProduct(normal, e0);
    along = sceVu0InnerProduct(normal, line);

    if (along == 0.0f) {
        return 0;
    }

    sceVu0ScaleVector(hit, line, -above / along);
    sceVu0AddVector(hit, hit, from);
    return mgCheckPointPoly3_XYZ(hit, v0, v1, v2, normal);
}

int mgCheckPointPoly3_XYZ(float *point, float *v0, float *v1, float *v2, float *normal) {
    sceVu0FVECTOR p0;
    sceVu0FVECTOR p1;
    sceVu0FVECTOR p2;
    sceVu0FVECTOR e0;
    sceVu0FVECTOR e1;
    sceVu0FVECTOR e2;
    sceVu0FVECTOR c0;
    sceVu0FVECTOR c1;
    sceVu0FVECTOR c2;
    float         d0;
    float         d1;
    float         d2;

    sceVu0SubVector(p0, point, v0);
    sceVu0SubVector(p1, point, v1);
    sceVu0SubVector(p2, point, v2);
    sceVu0SubVector(e0, v1, v0);
    sceVu0SubVector(e1, v2, v1);
    sceVu0SubVector(e2, v0, v2);
    sceVu0OuterProduct(c0, e0, p0);
    sceVu0OuterProduct(c1, e1, p1);
    sceVu0OuterProduct(c2, e2, p2);
    d0 = sceVu0InnerProduct(c0, normal);
    d1 = sceVu0InnerProduct(c1, normal);
    d2 = sceVu0InnerProduct(c2, normal);

    if (d0 >= 0.0f && d1 >= 0.0f && d2 >= 0.0f) {
        return 1;
    }

    if (d0 <= 0.0f && d1 <= 0.0f && d2 <= 0.0f) {
        return 1;
    }

    return 0;
}

int mgCheckPointPoly3_XZ(float *point, float *v0, float *v1, float *v2) {
    return Check_Point_Poly3(point[0], point[2], v0[0], v0[2], v1[0], v1[2], v2[0], v2[2]);
}

/**
 *
 * Returns where a 2D point lies relative to a 2D triangle, as an mgPointPoly3Result.
 *
 */
int Check_Point_Poly3(float x, float y, float x0, float y0, float x1, float y1, float x2, float y2) {
    float edge_20;
    float edge_12;
    float edge_01;
    float min_x;
    float max_x;
    float min_y;
    float max_y;

    min_x = (x0 < x1) ? ((x0 < x2) ? x0 : x2) : ((x1 < x2) ? x1 : x2);

    if (!(min_x <= x)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    max_x = (x0 > x1) ? ((x0 > x2) ? x0 : x2) : ((x1 > x2) ? x1 : x2);

    if (!(x <= max_x)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    min_y = (y0 < y1) ? ((y0 < y2) ? y0 : y2) : ((y1 < y2) ? y1 : y2);

    if (!(min_y <= y)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    max_y = (y0 > y1) ? ((y0 > y2) ? y0 : y2) : ((y1 > y2) ? y1 : y2);

    if (!(y <= max_y)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    edge_01 = ((x1 - x0) * (y - y0)) - ((y1 - y0) * (x - x0));
    edge_12 = ((x2 - x1) * (y - y1)) - ((y2 - y1) * (x - x1));
    edge_20 = ((x0 - x2) * (y - y2)) - ((y0 - y2) * (x - x2));

    if (edge_01 == 0.0f) {
        return MG_POINT_POLY3_EDGE_01;
    }

    if (edge_12 == 0.0f) {
        return MG_POINT_POLY3_EDGE_12;
    }

    if (edge_20 == 0.0f) {
        return MG_POINT_POLY3_EDGE_20;
    }

    if (!(edge_01 <= 0.0f) && !(edge_12 <= 0.0f) && !(edge_20 <= 0.0f)) {
        return MG_POINT_POLY3_INSIDE;
    }

    if (edge_01 < 0.0f) {
        if (edge_12 < 0.0f) {
            if (edge_20 < 0.0f) {
                return MG_POINT_POLY3_INSIDE;
            }
        }
    }

    return MG_POINT_POLY3_OUTSIDE;
}

asm float mgDistVector(float *vector) {
    .set noreorder
    lqc2 vf4, 0x0(a0)
    vmul.xyz vf4, vf4, vf4
    vmr32.xy vf5, vf4
    vmr32.x vf6, vf5
    vadd.x vf7, vf4, vf5
    vadd.x vf5, vf6, vf7
    vsqrt Q, vf5x
    vwaitq
    cfc2.ni v0, vi22
    mtc1 v0, f0
    jr ra
    nop
}
asm float mgDistVectorXZ(float *vector) {
    .set noreorder
    lqc2 vf4, 0x0(a0)
    vmul.xyz vf4, vf4, vf4
    vmr32.xy vf5, vf4
    vmr32.x vf6, vf5
    vadd.x vf7, vf4, vf6
    vsqrt Q, vf7x
    vwaitq
    cfc2.ni v0, vi22
    mtc1 v0, f0
    jr ra
    nop
}
asm float mgDistVector2(float *vector) {
    .set noreorder
    lqc2 vf4, 0x0(a0)
    vmul.xyz vf4, vf4, vf4
    vmr32.xy vf5, vf4
    vmr32.x vf6, vf5
    vadd.x vf7, vf4, vf5
    vadd.x vf5, vf6, vf7
    qmfc2.ni v0, vf5
    mtc1 v0, f0
    jr ra
    nop
}
asm float mgDistVector(float *a, float *b) {
    .set noreorder
    lqc2 vf2, 0x0(a0)
    lqc2 vf3, 0x0(a1)
    vsub.xyz vf4, vf3, vf2
    vmul.xyz vf4, vf4, vf4
    vmr32.xy vf5, vf4
    vmr32.x vf6, vf5
    vadd.x vf7, vf4, vf5
    vadd.x vf5, vf6, vf7
    vsqrt Q, vf5x
    vwaitq
    cfc2.ni v0, vi22
    mtc1 v0, f0
    jr ra
    nop
}
asm float mgDistVectorXZ(float *a, float *b) {
    .set noreorder
    lqc2 vf2, 0x0(a0)
    lqc2 vf3, 0x0(a1)
    vsub.xyz vf4, vf3, vf2
    vmul.xyz vf4, vf4, vf4
    vmr32.xy vf5, vf4
    vmr32.x vf6, vf5
    vadd.x vf7, vf4, vf6
    vsqrt Q, vf7x
    vwaitq
    cfc2.ni v0, vi22
    mtc1 v0, f0
    jr ra
    nop
}
asm float mgDistVector2(float *a, float *b) {
    .set noreorder
    lqc2 vf2, 0x0(a0)
    lqc2 vf3, 0x0(a1)
    vsub.xyz vf4, vf3, vf2
    vmul.xyz vf4, vf4, vf4
    vmr32.xy vf5, vf4
    vmr32.x vf6, vf5
    vadd.x vf7, vf4, vf5
    vadd.x vf5, vf6, vf7
    qmfc2.ni v0, vf5
    mtc1 v0, f0
    jr ra
    nop
}
asm float mgDistVectorXZ2(float *a, float *b) {
    .set noreorder
    lqc2 vf2, 0x0(a0)
    lqc2 vf3, 0x0(a1)
    vsub.xyz vf4, vf3, vf2
    vmul.xyz vf4, vf4, vf4
    vmr32.xy vf5, vf4
    vmr32.x vf6, vf5
    vadd.x vf7, vf4, vf6
    qmfc2.ni v0, vf7
    mtc1 v0, f0
    jr ra
    nop
}
asm void mgUnitMatrix(float (*matrix)[4]) {
    .set noreorder
    vmr32.xyzw vf1, vf0
    vmr32.xyzw vf2, vf1
    vmr32.xyzw vf3, vf2
    sqc2 vf0, 0x30(a0)
    sqc2 vf1, 0x20(a0)
    sqc2 vf2, 0x10(a0)
    jr ra
    sqc2 vf3, 0x0(a0)
}
asm void mgZeroMatrix(float (*matrix)[4]) {
    .set noreorder
    vsub.xyzw vf1, vf1, vf1
    sqc2 vf1, 0x30(a0)
    sqc2 vf1, 0x20(a0)
    sqc2 vf1, 0x10(a0)
    jr ra
    sqc2 vf1, 0x0(a0)
}
/**
 *
 * Multiplies a matrix in place by two further matrices.
 *
 */
#ifdef NONMATCHING
static void MulMatrix3(float (*matrix)[4], float (*second)[4], float (*third)[4]) {
    float intermediate[4][4];
    mgMulMatrix(intermediate, matrix, second);
    mgMulMatrix(matrix, intermediate, third);
}
#else
static asm void MulMatrix3(float (*matrix)[4], float (*second)[4], float (*third)[4]) {
    .set noreorder
    lqc2 vf1, 0x0(a0)
    lqc2 vf2, 0x10(a0)
    lqc2 vf3, 0x20(a0)
    lqc2 vf4, 0x30(a0)
    lqc2 vf5, 0x0(a1)
    lqc2 vf6, 0x10(a1)
    lqc2 vf7, 0x20(a1)
    lqc2 vf8, 0x30(a1)
    lqc2 vf9, 0x0(a2)
    lqc2 vf10, 0x10(a2)
    lqc2 vf11, 0x20(a2)
    lqc2 vf12, 0x30(a2)
    vmulax.xyzw ACC, vf1, vf5x
    vmadday.xyzw ACC, vf2, vf5y
    vmaddaz.xyzw ACC, vf3, vf5z
    vmaddw.xyzw vf20, vf4, vf5w
    vmulax.xyzw ACC, vf1, vf6x
    vmadday.xyzw ACC, vf2, vf6y
    vmaddaz.xyzw ACC, vf3, vf6z
    vmaddw.xyzw vf21, vf4, vf6w
    vmulax.xyzw ACC, vf1, vf7x
    vmadday.xyzw ACC, vf2, vf7y
    vmaddaz.xyzw ACC, vf3, vf7z
    vmaddw.xyzw vf22, vf4, vf7w
    vmulax.xyzw ACC, vf1, vf8x
    vmadday.xyzw ACC, vf2, vf8y
    vmaddaz.xyzw ACC, vf3, vf8z
    vmaddw.xyzw vf23, vf4, vf8w
    vmulax.xyzw ACC, vf20, vf9x
    vmadday.xyzw ACC, vf21, vf9y
    vmaddaz.xyzw ACC, vf22, vf9z
    vmaddw.xyzw vf1, vf23, vf9w
    vmulax.xyzw ACC, vf20, vf10x
    vmadday.xyzw ACC, vf21, vf10y
    vmaddaz.xyzw ACC, vf22, vf10z
    vmaddw.xyzw vf2, vf23, vf10w
    vmulax.xyzw ACC, vf20, vf11x
    vmadday.xyzw ACC, vf21, vf11y
    vmaddaz.xyzw ACC, vf22, vf11z
    vmaddw.xyzw vf3, vf23, vf11w
    vmulax.xyzw ACC, vf20, vf12x
    vmadday.xyzw ACC, vf21, vf12y
    vmaddaz.xyzw ACC, vf22, vf12z
    vmaddw.xyzw vf4, vf23, vf12w
    sqc2 vf1, 0x0(a0)
    sqc2 vf2, 0x10(a0)
    sqc2 vf3, 0x20(a0)
    jr ra
    sqc2 vf4, 0x30(a0)
}
#endif
#ifdef NONMATCHING
void mgMulMatrix(float (*product)[4], float (*left_matrix)[4], float (*right_matrix)[4]) {
    float result[4][4];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            result[i][j] = 0.0f;
            for (int k = 0; k < 4; ++k) {
                result[i][j] += left_matrix[i][k] * right_matrix[k][j];
            }
        }
    }
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            product[i][j] = result[i][j];
        }
    }
}
#else
asm void mgMulMatrix(float (*product)[4], float (*left_matrix)[4], float (*right_matrix)[4]) {
    .set noreorder
    lqc2 vf1, 0x0(a1)
    lqc2 vf2, 0x10(a1)
    lqc2 vf3, 0x20(a1)
    lqc2 vf4, 0x30(a1)
    lqc2 vf5, 0x0(a2)
    lqc2 vf6, 0x10(a2)
    lqc2 vf7, 0x20(a2)
    lqc2 vf8, 0x30(a2)
    vmulax.xyzw ACC, vf1, vf5x
    vmadday.xyzw ACC, vf2, vf5y
    vmaddaz.xyzw ACC, vf3, vf5z
    vmaddw.xyzw vf20, vf4, vf5w
    vmulax.xyzw ACC, vf1, vf6x
    vmadday.xyzw ACC, vf2, vf6y
    vmaddaz.xyzw ACC, vf3, vf6z
    vmaddw.xyzw vf21, vf4, vf6w
    vmulax.xyzw ACC, vf1, vf7x
    vmadday.xyzw ACC, vf2, vf7y
    vmaddaz.xyzw ACC, vf3, vf7z
    vmaddw.xyzw vf22, vf4, vf7w
    vmulax.xyzw ACC, vf1, vf8x
    vmadday.xyzw ACC, vf2, vf8y
    vmaddaz.xyzw ACC, vf3, vf8z
    vmaddw.xyzw vf23, vf4, vf8w
    sqc2 vf20, 0x0(a0)
    sqc2 vf21, 0x10(a0)
    sqc2 vf22, 0x20(a0)
    jr ra
    sqc2 vf23, 0x30(a0)
}
#endif
#ifdef NONMATCHING
void mgInversMatrix(float (*inverse)[4], float (*matrix)[4]) {
    float cof[3][3];
    for (int i = 0; i < 3; ++i) {
        int i1 = (i + 1) % 3, i2 = (i + 2) % 3;
        for (int j = 0; j < 3; ++j) {
            int j1 = (j + 1) % 3, j2 = (j + 2) % 3;
            cof[i][j] = matrix[i1][j1] * matrix[i2][j2] - matrix[i1][j2] * matrix[i2][j1];
        }
    }
    float det = matrix[0][0] * cof[0][0] + matrix[0][1] * cof[0][1] + matrix[0][2] * cof[0][2];
    float inv_det = 1.0f / det;
    float result[4][4];
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            result[i][j] = cof[j][i] * inv_det;
        }
    }
    for (int i = 0; i < 3; ++i) {
        result[i][3] = 0.0f;
    }
    for (int j = 0; j < 3; ++j) {
        result[3][j] = -(matrix[3][0] * result[0][j] + matrix[3][1] * result[1][j] + matrix[3][2] * result[2][j]);
    }
    result[3][3] = 1.0f;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            inverse[i][j] = result[i][j];
        }
    }
}
#else
asm void mgInversMatrix(float (*inverse)[4], float (*matrix)[4]) {
    .set noreorder
    lqc2 vf1, 0x0(a1)
    lqc2 vf2, 0x10(a1)
    lqc2 vf3, 0x20(a1)
    lqc2 vf4, 0x30(a1)
    vmuly.x vf5, vf1, vf2y
    vmuly.x vf6, vf3, vf1y
    vmuly.x vf7, vf2, vf3y
    vmuly.x vf8, vf1, vf3y
    vmuly.x vf9, vf2, vf1y
    vmuly.x vf10, vf3, vf2y
    vmulaz.x ACC, vf5, vf3z
    vmaddaz.x ACC, vf6, vf2z
    vmaddaz.x ACC, vf7, vf1z
    vmsubaz.x ACC, vf8, vf2z
    vmsubaz.x ACC, vf9, vf3z
    vmsubz.x vf15, vf10, vf1z
    vsub.xyzw vf5, vf5, vf5
    vsub.xyzw vf6, vf6, vf6
    vsub.xyzw vf7, vf7, vf7
    vaddx.xyzw vf8, vf0, vf0x
    vdiv Q, vf0w, vf15x
    vmulaz.y ACC, vf2, vf3z
    vmsubz.y vf10, vf3, vf2z
    vmulaz.y ACC, vf3, vf1z
    vmsubz.y vf11, vf1, vf3z
    vmulaz.y ACC, vf1, vf2z
    vmsubz.y vf12, vf2, vf1z
    vmulax.z ACC, vf2, vf3x
    vmsubx.z vf10, vf3, vf2x
    vmulax.z ACC, vf3, vf1x
    vmsubx.z vf11, vf1, vf3x
    vmulax.z ACC, vf1, vf2x
    vmsubx.z vf12, vf2, vf1x
    vmulay.x ACC, vf2, vf3y
    vmsuby.x vf10, vf3, vf2y
    vmulay.x ACC, vf3, vf1y
    vmsuby.x vf11, vf1, vf3y
    vmulay.x ACC, vf1, vf2y
    vmsuby.x vf12, vf2, vf1y
    vaddy.x vf5, vf5, vf10y
    vaddy.y vf5, vf5, vf11y
    vaddy.z vf5, vf5, vf12y
    vaddz.x vf6, vf6, vf10z
    vaddz.y vf6, vf6, vf11z
    vaddz.z vf6, vf6, vf12z
    vaddx.x vf7, vf7, vf10x
    vaddx.y vf7, vf7, vf11x
    vaddx.z vf7, vf7, vf12x
    vmulq.xyzw vf5, vf5, Q
    vmulq.xyzw vf6, vf6, Q
    vmulq.xyzw vf7, vf7, Q
    vmulax.xyzw ACC, vf5, vf4x
    vmadday.xyzw ACC, vf6, vf4y
    vmaddz.xyzw vf8, vf7, vf4z
    vsub.xyz vf8, vf0, vf8
    vaddx.w vf8, vf0, vf0x
    sqc2 vf5, 0x0(a0)
    sqc2 vf6, 0x10(a0)
    sqc2 vf7, 0x20(a0)
    jr ra
    sqc2 vf8, 0x30(a0)
}
#endif

void mgRotMatrixX(float (*matrix)[4], float angle_x) {
    mgUnitMatrix(matrix);
    matrix[2][2] = cosf(angle_x);
    matrix[1][1] = matrix[2][2];
    matrix[1][2] = sinf(angle_x);
    matrix[2][1] = -matrix[1][2];
}

void mgRotMatrixY(float (*matrix)[4], float angle_y) {
    mgUnitMatrix(matrix);
    matrix[2][2] = cosf(angle_y);
    matrix[0][0] = matrix[2][2];
    matrix[2][0] = sinf(angle_y);
    matrix[0][2] = -matrix[2][0];
}

void mgRotMatrixZ(float (*matrix)[4], float angle_z) {
    mgUnitMatrix(matrix);
    matrix[1][1] = cosf(angle_z);
    matrix[0][0] = matrix[1][1];
    matrix[0][1] = sinf(angle_z);
    matrix[1][0] = -matrix[0][1];
}

void mgRotMatrixXYZ(float (*matrix)[4], float *rotation) {
    sceVu0FMATRIX rotate_x;
    sceVu0FMATRIX rotate_y;

    mgRotMatrixX(rotate_x, rotation[0]);
    mgRotMatrixY(rotate_y, rotation[1]);
    mgRotMatrixZ(matrix, rotation[2]);
    MulMatrix3(matrix, rotate_y, rotate_x);
}

void mgCreateMatrixPY(float (*matrix)[4], float *position, float angle_y) {
    mgUnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, angle_y);
    *(u_long128 *) matrix[3] = *(u_long128 *) position;
    matrix[3][3] = 1.0f;
}

void mgLookAtMatrixZ(float (*matrix)[4], float *direction) {
    sceVu0FMATRIX pitch;
    sceVu0FMATRIX yaw;
    sceVu0FVECTOR unit;
    sceVu0FVECTOR flat;
    float         ground;
    float         cosine;
    float         sine;

    sceVu0UnitMatrix(yaw);
    sceVu0CopyMatrix(pitch, yaw);
    sceVu0Normalize(unit, direction);
    sceVu0CopyVector(flat, unit);
    flat[1] = 0.0f;
    ground = mgDistVector(flat);

    if (ground == 0.0f) {
        cosine = 0.0f;
        sine = 1.0f;
    } else {
        cosine = unit[0] / ground;
        sine = unit[2] / ground;
    }

    pitch[1][1] = ground;
    pitch[2][2] = ground;
    yaw[0][2] = -cosine;
    yaw[2][0] = cosine;
    yaw[0][0] = sine;
    yaw[2][2] = sine;
    pitch[2][1] = unit[1];
    pitch[1][2] = -unit[1];
    mgMulMatrix(matrix, yaw, pitch);
}

#pragma optimization_level 3

void mgShadowMatrix(float (*matrix)[4], float *light_direction, float *on_plane, float *plane_normal) {
    float light_dir[4];
    float plane_point[4];
    float normal_copy[4];
    float dot;
    float facing;
    float nx;
    float inv_dot;
    float ly;
    float ny;
    float lx;
    float lz;
    float scale;
    float nz;
    light_dir[0] = light_direction[0];
    light_dir[1] = light_direction[1];
    light_dir[2] = light_direction[2];
    light_dir[3] = 0.0f;
    sceVu0CopyVector(plane_point, on_plane);
    sceVu0CopyVector(normal_copy, plane_normal);
    dot = sceVu0InnerProduct(normal_copy, plane_point);

    // A plane through the origin cannot be scaled to n.x = 1, so it is moved slightly first.
    if (dot == 0.0f) {
        plane_point[0] -= 0.1f * normal_copy[0];
        plane_point[1] -= 0.1f * normal_copy[1];
        plane_point[2] -= 0.1f * normal_copy[2];
        dot = sceVu0InnerProduct(normal_copy, plane_point);
    }

    inv_dot = 1.0f / dot;
    nx = normal_copy[0] * inv_dot;
    ny = normal_copy[1] * inv_dot;
    nz = normal_copy[2] * inv_dot;
    sceVu0Normalize(light_dir, light_dir);
    lx = light_dir[0];
    ly = light_dir[1];
    lz = light_dir[2];
    facing = nx * lx + ny * ly + nz * lz;
    scale = -1.0f / facing;
    matrix[0][0] = scale * (nx * lx - facing);
    matrix[1][0] = scale * (ny * lx);
    matrix[2][0] = scale * (nz * lx);
    matrix[3][0] = scale * -lx;
    matrix[0][1] = scale * (nx * ly);
    matrix[1][1] = scale * (ny * ly - facing);
    matrix[2][1] = scale * (nz * ly);
    matrix[3][1] = scale * -ly;
    matrix[0][2] = scale * (nx * lz);
    matrix[1][2] = scale * (ny * lz);
    matrix[2][2] = scale * (nz * lz - facing);
    matrix[3][2] = scale * -lz;
    matrix[0][3] = 0.0f;
    matrix[1][3] = 0.0f;
    matrix[2][3] = 0.0f;
    matrix[3][3] = scale * -facing;
}

#pragma optimization_level reset
#pragma schedule off
#pragma global_optimizer off
#ifdef NONMATCHING
void mgApplyMatrixN(float (*out)[4], float (*matrix)[4], float (*in)[4], int count) {
    for (int i = 0; i < count; ++i) {
        float vector[4] = {in[i][0], in[i][1], in[i][2], in[i][3]};
        for (int axis = 0; axis < 4; ++axis) {
            out[i][axis] = matrix[0][axis] * vector[0] + matrix[1][axis] * vector[1] + matrix[2][axis] * vector[2] + matrix[3][axis] * vector[3];
        }
    }
}
#else
asm void mgApplyMatrixN(float (*out)[4], float (*matrix)[4], float (*in)[4], int count) {
    .set noreorder
    addi a3, a3, -0x1
    lqc2 vf16, 0x0(a2)
    lqc2 vf10, 0x0(a1)
    lqc2 vf11, 0x10(a1)
    lqc2 vf12, 0x20(a1)
    lqc2 vf13, 0x30(a1)
    nop
transform_vectors:
    vmulax.xyzw ACC, vf10, vf16x
    vmadday.xyzw ACC, vf11, vf16y
    vmaddaz.xyzw ACC, vf12, vf16z
    vmaddw.xyzw vf17, vf13, vf16w
    addi a3, a3, -0x1
    addi a0, a0, 0x10
    addi a2, a2, 0x10
    sqc2 vf17, -0x10(a0)
    lqc2 vf16, 0x0(a2)
    bgez a3, transform_vectors
    vnop
    jr ra
    nop
}
#endif
#pragma global_optimizer reset
#pragma schedule reset
#pragma global_optimizer off
#ifdef NONMATCHING
void mgApplyMatrixN_MaxMin(float (*out)[4], float (*matrix)[4], float (*in)[4], int count,
                           float *max, float *min) {
    mgApplyMatrixN(out, matrix, in, count);
    for (int axis = 0; axis < 4; ++axis) {
        max[axis] = out[0][axis];
        min[axis] = out[0][axis];
    }
    for (int i = 1; i < count; ++i) {
        for (int axis = 0; axis < 4; ++axis) {
            if (max[axis] < out[i][axis]) {
                max[axis] = out[i][axis];
            }
            if (min[axis] > out[i][axis]) {
                min[axis] = out[i][axis];
            }
        }
    }
}
#else
asm void mgApplyMatrixN_MaxMin(float (*out)[4], float (*matrix)[4], float (*in)[4], int count,
                           float *max, float *min) {
    .set noreorder
    addi a3, a3, -0x1
    lqc2 vf16, 0x0(a2)
    lqc2 vf10, 0x0(a1)
    lqc2 vf11, 0x10(a1)
    lqc2 vf12, 0x20(a1)
    lqc2 vf13, 0x30(a1)
    vmulax.xyzw ACC, vf10, vf16x
    vmadday.xyzw ACC, vf11, vf16y
    vmaddaz.xyzw ACC, vf12, vf16z
    vmaddw.xyzw vf17, vf13, vf16w
    addi a3, a3, -0x1
    addi a0, a0, 0x10
    addi a2, a2, 0x10
    sqc2 vf17, -0x10(a0)
    lqc2 vf16, 0x0(a2)
    vaddx.xyzw vf20, vf17, vf0x
    vaddx.xyzw vf21, vf17, vf0x
transform_and_bound_vectors:
    vmulax.xyzw ACC, vf10, vf16x
    vmadday.xyzw ACC, vf11, vf16y
    vmaddaz.xyzw ACC, vf12, vf16z
    vmaddw.xyzw vf17, vf13, vf16w
    addi a3, a3, -0x1
    addi a0, a0, 0x10
    addi a2, a2, 0x10
    sqc2 vf17, -0x10(a0)
    lqc2 vf16, 0x0(a2)
    vmax.xyzw vf20, vf20, vf17
    bgez a3, transform_and_bound_vectors
    vmini.xyzw vf21, vf21, vf17
    nop
    sqc2 vf20, 0x0(t0)
    jr ra
    sqc2 vf21, 0x0(t1)
}
#endif
#pragma global_optimizer reset
#pragma global_optimizer off
#ifdef NONMATCHING
void mgVectorMinMaxN(float *max, float *min, float (*vectors)[4], int count) {
    for (int axis = 0; axis < 4; ++axis) {
        max[axis] = vectors[0][axis];
        min[axis] = vectors[0][axis];
    }
    for (int i = 1; i < count; ++i) {
        for (int axis = 0; axis < 4; ++axis) {
            if (max[axis] < vectors[i][axis]) {
                max[axis] = vectors[i][axis];
            }
            if (min[axis] > vectors[i][axis]) {
                min[axis] = vectors[i][axis];
            }
        }
    }
}
#else
asm void mgVectorMinMaxN(float *max, float *min, float (*vectors)[4], int count) {
    .set noreorder
    addi a3, a3, -0x1
    lqc2 vf10, 0x0(a2)
    vmove.xyzw vf11, vf10
    lqc2 vf16, 0x10(a2)
    vnop
    vnop
    vnop
update_bounds:
    vmax.xyzw vf10, vf10, vf16
    vmini.xyzw vf11, vf11, vf16
    addi a3, a3, -0x1
    addi a2, a2, 0x10
    lqc2 vf16, 0x0(a2)
    vnop
    bgez a3, update_bounds
    nop
    nop
    vnop
    vnop
    vnop
    sqc2 vf10, 0x0(a0)
    jr ra
    sqc2 vf11, 0x0(a1)
}
#endif
#pragma global_optimizer reset

void mgApplyMatrix(float *max, float *min, float (*matrix)[4], float *box_max, float *box_min) {
    sceVu0FVECTOR corners[8];

    mgCreateBox8(corners, box_max, box_min);
    mgApplyMatrixN_MaxMin(corners, matrix, corners, 8, max, min);
}

void mgVectorInterpolate(float *out, float *from, float *to, float step, int mode) {
    sceVu0FVECTOR gap;

    sceVu0SubVector(gap, to, from);

    switch (mode) {
        case MG_INTERPOLATE_STEP:
            if (mgDistVector(gap) < step) {
                *(u_long128 *) out = *(u_long128 *) to;
                break;
            }

            sceVu0Normalize(gap, gap);
            sceVu0ScaleVector(gap, gap, step);
            sceVu0AddVector(out, from, gap);
            break;
        case MG_INTERPOLATE_FRACTION:
            out[0] = from[0] + gap[0] / step;
            out[1] = from[1] + gap[1] / step;
            out[2] = from[2] + gap[2] / step;
            break;
    }
}

float mgAngleInterpolate(float from, float to, float step, int mode) {
    float delta;
    float offset;
    float result;

    // Angles are kept in (-pi, pi]; one whole turn brings a sum or difference back into range.
    delta = to - from;

    if (delta > 3.1415927f) {
        delta -= 6.2831855f;
    }

    if (delta <= -3.1415927f) {
        delta += 6.2831855f;
    }

    offset = 0.0f;

    if (mode == MG_INTERPOLATE_STEP && (delta < 0.0f ? -delta : delta) < step) {
        return to;
    }

    switch (mode) {
        case MG_INTERPOLATE_STEP:
            if (delta < 0.0f) {
                if (step < delta) {
                    return to;
                }

                offset -= step;
            }

            if (delta >= 0.0f) {
                if (step > delta) {
                    return to;
                }

                offset += step;
            }

            break;
        case MG_INTERPOLATE_FRACTION:
            offset = delta / step;
            break;
    }

    result = from + offset;

    if (result > 3.1415927f) {
        result -= 6.2831855f;
    }

    if (result <= -3.1415927f) {
        result += 6.2831855f;
    }

    return result;
}

int mgAngleCmp(float a, float b, float tolerance) {
    float delta;

    delta = a - b;

    if (delta == 0.0f) {
        return 0;
    }

    if (delta > 3.1415927f) {
        delta -= 6.2831855f;
    }

    if (delta < -3.1415927f) {
        delta += 6.2831855f;
    }

    if (delta > tolerance) {
        return 1;
    }

    if (delta < -tolerance) {
        return -1;
    }

    return 0;
}

float mgAngleLimit(float angle) {
    if (angle < 3.1415927f && angle > -3.1415927f) {
        return angle;
    }

    angle -= 6.2831855f * (int) (angle / 6.2831855f);

    if (angle > 3.1415927f) {
        angle -= 6.2831855f;
    }

    if (angle < -3.1415927f) {
        angle += 6.2831855f;
    }

    return angle;
}

float mgRnd() {
    return (float) rand() / 2147483648.0f;
}

float mgNRnd() {
    // The sum of twelve uniform samples has unit variance about six.
    return mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() - 6.0f;
}

void mgCreateSinTable() {
    int i;

    sin_table_num = 1024.0f;
    sin_table_unit_1 = 162.97466f;

    for (i = 0; i < 1024; i++) {
        SinTable[i] = sinf(3.1415927f * (2.0f * (float) i) / sin_table_num);
    }
}

float mgSinf(float angle) {
    if (angle >= 0.0f) {
        return SinTable[(int) (angle * sin_table_unit_1) % 1024];
    }

    return -SinTable[(int) (-angle * sin_table_unit_1) % 1024];
}

float mgCosf(float angle) {
    return mgSinf(1.5707964f + angle);
}

// Small initialised data (.sdata)
float sin_table_num = 1024.0f;

float sin_table_unit_1 = 162.97466f;

// Uninitialised data (.bss)
float SinTable[1024];
