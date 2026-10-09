#include "common.h"
#include "mw_runtime.h"

#include "editcoll.hpp"
#include "mapload.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"

/**
 *
 * Holds one quadword of editable collision polygon data.
 *
 */
struct CollisionRow {
    float value[4]; /**< Four words copied together. */
};

#pragma global_optimizer off
#include <libvu0.h>

// Code (.text)
int ClipBoxXZ(float *max_a, float *min_a, float *max_b, float *min_b) {
    int flags;
    asm {
        lqc2 vf10, 0(max_a)
        lqc2 vf11, 0(min_a)
        lqc2 vf1, 0(max_b)
        lqc2 vf2, 0(min_b)
        vnop
        vnop
        vnop
        ctc2.ni zero, vi16
        vsub.xz vf25, vf10, vf2
        vsub.xz vf25, vf1, vf11
        vnop
        vnop
        vnop
        vnop
        vnop
        cfc2.ni flags, vi16
    }
    return (flags & 0x80) == 0;
}
#pragma global_optimizer reset

float OverlapPoly3AreaXZ(sceVu0FVECTOR *clipped, sceVu0FVECTOR *clipper, mgVu0FBOX *box) {
    int   count = 3;
    int   source = 0;
    int   edge;
    int   output_count;
    int   index;
    int   first_inside;
    int   second_inside;
    float area;
    float vertices[2][7][4];
    float boundary[4][4];
    float vertex[4];
    float edge_delta[4];
    float segment_delta[4];
    float first_offset[4];
    float second_offset[4];
    float intersection[4];
    float normal_first[4];
    float normal_second[4];
    float normal[4];
    *(u_long128 *) vertices[0][0] = *(u_long128 *) clipped[0];
    vertices[0][0][1] = 0.0f;
    *(u_long128 *) vertices[0][1] = *(u_long128 *) clipped[1];
    vertices[0][1][1] = 0.0f;
    *(u_long128 *) vertices[0][2] = *(u_long128 *) clipped[2];
    vertices[0][2][1] = 0.0f;
    *(u_long128 *) vertices[0][3] = *(u_long128 *) clipped[0];
    vertices[0][3][1] = 0.0f;
    *(u_long128 *) boundary[0] = *(u_long128 *) clipper[0];
    boundary[0][1] = 0.0f;
    *(u_long128 *) boundary[1] = *(u_long128 *) clipper[1];
    boundary[1][1] = 0.0f;
    *(u_long128 *) boundary[2] = *(u_long128 *) clipper[2];
    boundary[2][1] = 0.0f;
    *(u_long128 *) boundary[3] = *(u_long128 *) clipper[0];
    boundary[3][1] = 0.0f;
    for (edge = 0; edge < 3; edge++) {
        sceVu0SubVector(edge_delta, boundary[edge + 1], boundary[edge]);
        output_count = 0;
        for (index = 0; index < count; index++) {
            sceVu0SubVector(segment_delta, vertices[source][index + 1], vertices[source][index]);
            first_inside = 0;
            second_inside = 0;
            sceVu0SubVector(first_offset, vertices[source][index], boundary[edge]);
            sceVu0SubVector(second_offset, vertices[source][index + 1], boundary[edge]);
            if (!(-edge_delta[0] * first_offset[2] + edge_delta[2] * first_offset[0] < 0.0f)) {
                *(u_long128 *) vertices[!source][output_count] = *(u_long128 *) vertices[source][index];
                output_count++;
                first_inside = 1;
            }
            if (!(-edge_delta[0] * second_offset[2] + edge_delta[2] * second_offset[0] < 0.0f)) {
                second_inside = 1;
            }
            if ((first_inside != 0 && second_inside != 0) || (first_inside == 0 && second_inside == 0)) {
                continue;
            }
            sceVu0SubVector(first_offset, vertices[source][index], boundary[edge]);
            float denominator = segment_delta[0] * edge_delta[2] - segment_delta[2] * edge_delta[0];
            if (0.0f != denominator) {
                float ratio = edge_delta[0] * first_offset[2] - edge_delta[2] * first_offset[0];
                ratio /= denominator;
                sceVu0ScaleVector(intersection, segment_delta, ratio);
                mgAddVector(intersection, vertices[source][index]);
                *(u_long128 *) vertices[!source][output_count] = *(u_long128 *) intersection;
                output_count++;
            }
        }
        source = !source;
        count = output_count;
        *(u_long128 *) vertices[source][count] = *(u_long128 *) vertices[source][0];
    }
    if (count < 3) {
        return 0.0f;
    }
    area = 0.0f;
    for (int k = 0; k < count; k++) {
        area += -vertices[source][k][0] * vertices[source][k + 1][2] + vertices[source][k + 1][0] * vertices[source][k][2];
    }
    area *= 0.5f;
    if (box != NULL) {
        sceVu0SubVector(normal_first, clipper[1], clipper[0]);
        sceVu0SubVector(normal_second, clipper[2], clipper[1]);
        sceVu0OuterProduct(normal, normal_first, normal_second);
        normal[3] = -sceVu0InnerProduct(normal, clipper[0]);
        for (int n = 0; n < count; n++) {
            *(u_long128 *) vertex = *(u_long128 *) vertices[source][n];
            vertices[source][n][1] = -(vertex[0] * normal[0] + vertex[2] * normal[2] + normal[3]) / normal[1];
            if (n == 0) {
                *(u_long128 *) box->min = *(u_long128 *) box->max = *(u_long128 *) vertices[source][n];
            } else {
                mgVectorMaxMin(box->max, box->min, box->max, box->min, vertices[source][n]);
            }
        }
    }
    return area;
}
void CEditCollision::Copy(CEditCollision &dest, int plane_no, mgCMemory *memory) {

    int     count;
    int     i;
    u32     size;
    int     copied;
    u32     blocks;
    int     src_off;
    int     dst_off;
    CCPoly *src;
    CCPoly *dst;
    count = 0;

    for (i = 0; i < poly_count; i++) {
        if (plane_no == poly[i].area_kind) {
            count++;
        }
    }

    if (count <= 0 || memory == NULL) {
        dest.poly_count = 0;
        dest.poly = NULL;
        return;
    }

    size = count * sizeof(CCPoly);
    dest.poly_count = count;

    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }

    dest.poly = new (memory->Alloc(blocks + 2)) CCPoly[count];
    copied = 0;

    if (dest.poly != NULL) {
        src_off = 0;
        dst_off = 0;

        while (copied < poly_count) {
            src = (CCPoly *) ((u8 *) poly + src_off);

            if (plane_no == src->area_kind) {
                dst = (CCPoly *) ((u8 *) dest.poly + dst_off);
                dst_off += sizeof(CCPoly);
                ((CollisionRow *) dst)[0] = ((CollisionRow *) src)[0];
                ((CollisionRow *) dst)[1] = ((CollisionRow *) src)[1];
                ((CollisionRow *) dst)[2] = ((CollisionRow *) src)[2];
                ((CollisionRow *) dst)[3] = ((CollisionRow *) src)[3];
                ((CollisionRow *) dst)[4] = ((CollisionRow *) src)[4];
            }

            src_off += sizeof(CCPoly);
            copied++;
        }
    }

    CreateBBox();
}

float CEditCollision::AreaXZ() {
    float total;
    CCPoly *poly;
    int i;
    int count;
    count = poly_count;
    poly = this->poly;
    total = 0.0f;

    for (i = 0; i < count; i++) {
        float area;
        float bx;
        float bz;
        float cz;
        float ax;
        float az;
        float cx;
        ax = poly->vertex[0][0];
        bz = poly->vertex[1][2];
        bx = poly->vertex[1][0];
        az = poly->vertex[0][2];
        cz = poly->vertex[2][2];
        cx = poly->vertex[2][0];
        float sum = -ax * bz + bx * az;
        sum += -bx * cz + cx * bz;
        sum += -cx * az + ax * cz;
        area = 0.5f * sum;
        total += (area < 0.0f) ? -area : area;
        poly++;
    }

    return total;
}

int CEditCollision::OverlapPoly3XZ(float (*triangle)[4], float *area, mgVu0FBOX *box) {
    sceVu0FVECTOR tri_max;
    sceVu0FVECTOR tri_min;
    mgVu0FBOX     overlap_box;
    sceVu0FVECTOR poly_max;
    sceVu0FVECTOR poly_min;
    CCPoly       *p;
    float         overlap;
    float         total;
    int           overlap_count;
    int           i;

    p = poly;

    if (p == NULL) {
        return 0;
    }

    mgVectorMaxMin(tri_max, tri_min, triangle[0], triangle[1], triangle[2]);

    if (area != NULL) {
        *area = 0.0f;
    }

    if (box != NULL) {
        mgZeroVectorW(box->max);
        mgZeroVectorW(box->min);
    }

    if (!ClipBoxXZ(tri_max, tri_min, bbox.max, bbox.min)) {
        return 0;
    }

    total = 0.0f;
    overlap_count = 0;

    for (i = 0; i < poly_count; i++, p++) {
        mgVectorMaxMin(poly_max, poly_min, p->vertex[0], p->vertex[1], p->vertex[2]);

        if (ClipBoxXZ(tri_max, tri_min, poly_max, poly_min)) {
            overlap = OverlapPoly3AreaXZ(triangle, p->vertex, &overlap_box);
            overlap = overlap < 0.0f ? -overlap : overlap;
            total += overlap;

            if (overlap > 0.0) {
                if (box != NULL) {
                    if (overlap_count == 0) {
                        *box = overlap_box;
                    } else {
                        mgBoxMaxMin(box, &overlap_box);
                    }
                }

                overlap_count++;
            }
        }
    }

    if (area != NULL) {
        *area = total;
    }

    if (total > 0.0f) {
        return 1;
    }

    return 0;
}

float CEditCollision::OverlapXZ(CEditCollision &other, float (*matrix)[4], mgVu0FBOX *box) {
    float     triangle[3][4];
    float     depth;
    mgVu0FBOX tri_box;
    int       started;
    CCPoly   *poly;
    int   i;
    int   count;
    float total;
    i = 0;
    count = other.poly_count;
    total = 0.0f;
    poly = other.poly;
    started = 0;

    if (0 < count) {
        do {
            mgApplyMatrixN(triangle, matrix, poly->vertex, 3);

            if (OverlapPoly3XZ(triangle, &depth, &tri_box) != 0) {
                total += depth;

                if (box != NULL) {
                    if (started == 0) {
                        started = 1;
                        *box = tri_box;
                    } else {
                        mgBoxMaxMin(box, &tri_box);
                    }
                }
            }

            i++;
            poly++;
        } while (i < count);
    }

    return total;
}

int CEditCollision::OverlapPoly3XZ(float (*triangle)[4], float (*matrix)[4], float *area) {
    float tri_max[4];
    float tri_min[4];
    float transformed_max[4];
    float transformed_min[4];
    float transformed[3][4];
    CCPoly *source = poly;
    int index;
    float total;
    if (source == NULL) return 0;
    mgVectorMaxMin(tri_max, tri_min, triangle[0], triangle[1], triangle[2]);
    if (area != NULL) *area = 0.0f;
    mgApplyMatrix(transformed_max, transformed_min, matrix, bbox.max, bbox.min);
    if (!ClipBoxXZ(tri_max, tri_min, transformed_max, transformed_min)) return 0;
    total = 0.0f;
    for (index = 0; index < poly_count; index++, source++) {
        mgApplyMatrixN(transformed, matrix, source->vertex, 3);
        if (!mgAbs(transformed[0][1] > 0.1f) && !mgAbs(transformed[1][1] > 0.1f) && !mgAbs(transformed[2][1] > 0.1f)) {
            total += mgAbs(OverlapPoly3AreaXZ(triangle, transformed, NULL));
        }
    }
    if (area != NULL) *area = total;
    if (!(total <= 0.0f)) return 1;
    return 0;
}

void CEditCollision::ApplyMatrix(float (*matrix)[4]) {
    CCPoly *p;
    int     i;
    int     j;

    p = poly;

    if (p == NULL) {
        return;
    }

    for (i = 0; i < poly_count; i++, p++) {
        mgApplyMatrixN(p->vertex, matrix, p->vertex, 3);

        // Heights are rounded to the nearest whole unit.
        for (j = 0; j < 3; j++) {
            if (p->vertex[j][1] > 0.0f) {
                p->vertex[j][1] = (int) (p->vertex[j][1] + 0.5f);
            } else {
                p->vertex[j][1] = (int) (p->vertex[j][1] - 0.5f);
            }
        }

        mgPlaneNormal(p->normal, p->vertex[0], p->vertex[1], p->vertex[2]);
        sceVu0Normalize(p->normal, p->normal);
    }

    CreateBBox();
}

void CEditCollision::DeleteVerticalPoly() {
    float   normal[4];
    CCPoly *poly;
    int     i;
    CCPoly *slot;
    CCPoly *last;
    int     remaining;
    poly = this->poly;

    if (poly != NULL) {
        for (i = 0; i < poly_count; i++) {
            slot = &poly[i];
            sceVu0Normalize(normal, slot->normal);
            float up = normal[1];
            up = (up < 0.0f) ? -up : up;

            if (up < 0.01f) {
                remaining = poly_count;

                if (remaining == 0) {
                    break;
                }

                i--;
                poly_count = remaining - 1;
                last = &this->poly[poly_count];
                ((CollisionRow *) slot)[0] = ((CollisionRow *) last)[0];
                ((CollisionRow *) slot)[1] = ((CollisionRow *) last)[1];
                ((CollisionRow *) slot)[2] = ((CollisionRow *) last)[2];
                ((CollisionRow *) slot)[3] = ((CollisionRow *) last)[3];
                ((CollisionRow *) slot)[4] = ((CollisionRow *) last)[4];
            }
        }

        CreateBBox();
    }
}

int CEditCollision::PickupVerticalPoly() {
    float   normal[4];
    float   normal_a[4];
    float   normal_b[4];
    CCPoly *poly;
    int     i;
    CCPoly *slot;
    CCPoly *last;
    int     remaining;
    int     planes;
    int     k;
    CCPoly *same;
    int     j;
    int     off;
    CCPoly *cur;
    poly = this->poly;

    if (poly == NULL) {
        return 0;
    }

    for (i = 0; i < poly_count; i++) {
        slot = &poly[i];
        sceVu0Normalize(normal, slot->normal);
        float up = normal[1];
        up = (up < 0.0f) ? -up : up;

        if (up > 0.01f) {
            remaining = poly_count;

            if (remaining == 0) {
                break;
            }

            i--;
            poly_count = remaining - 1;
            last = &this->poly[poly_count];
            ((CollisionRow *) slot)[0] = ((CollisionRow *) last)[0];
            ((CollisionRow *) slot)[1] = ((CollisionRow *) last)[1];
            ((CollisionRow *) slot)[2] = ((CollisionRow *) last)[2];
            ((CollisionRow *) slot)[3] = ((CollisionRow *) last)[3];
            ((CollisionRow *) slot)[4] = ((CollisionRow *) last)[4];
        }
    }

    CreateBBox();
    cur = this->poly;
    planes = 0;

    for (k = 0; k < poly_count; k++, cur++) {
        same = NULL;
        j = 0;

        if (0 < k) {
            off = 0;

            do {
                sceVu0Normalize(normal_a, cur->normal);

                sceVu0Normalize(normal_b, ((CCPoly *) ((u8 *) this->poly + off))->normal);

                if (mgDistVector(normal_a, normal_b) <= 0.01f) {
                    float dot_a = sceVu0InnerProduct(normal_a, cur->vertex[0]);
                    float diff =
                        dot_a - sceVu0InnerProduct(normal_b,
                                                   ((CCPoly *) ((u8 *) this->poly + off))->vertex[0]);
                    diff = (diff < 0.0f) ? -diff : diff;

                    if (diff <= 0.01f) {
                        same = &this->poly[j];
                        break;
                    }
                }

                j++;
                off += sizeof(CCPoly);
            } while (j < k);
        }

        if (same != NULL) {
            cur->ignore_mask = same->ignore_mask;
        } else {
            cur->ignore_mask = planes;
            planes++;
        }
    }

    return planes;
}
