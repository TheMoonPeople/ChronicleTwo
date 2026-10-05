#include "common.h"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "editcoll.hpp"

extern "C" int fptosi(float value);

#pragma global_optimizer off
#include <libvu0.h>

#include "mg_math.hpp"
#include "mg_memory.hpp"

// Code (.text)
int ClipBoxXZ(float *max_a, float *min_a, float *max_b, float *min_b) {
    register int status;

    // Only the sign flags of the two subtractions matter: any negative component means apart.
    asm {
        lqc2 $vf10, 0x0($4)
        lqc2 $vf11, 0x0($5)
        lqc2 $vf1, 0x0($6)
        lqc2 $vf2, 0x0($7)
        vnop
        vnop
        vnop
        ctc2.ni $0, $vi16
        vsub.xz $vf25, $vf10, $vf2
        vsub.xz $vf25, $vf1, $vf11
        vnop
        vnop
        vnop
        vnop
        vnop
        cfc2.ni status, $vi16
    }

    return (status & MG_VU0_STATUS_SIGN_STICKY) == 0;
}
#pragma global_optimizer reset

#ifdef NONMATCHING
float OverlapPoly3AreaXZ(float (*clipped)[4], float (*clipper)[4], mgVu0FBOX *box) {
    float vertices[2][7][4];
    int count = 3;
    for (int i = 0; i < 3; ++i) {
        for (int component = 0; component < 4; ++component) {
            vertices[0][i][component] = clipped[i][component];
        }
        vertices[0][i][1] = 0.0f;
    }
    int source = 0;
    for (int edge = 0; edge < 3; ++edge) {
        int target = source ^ 1;
        int output_count = 0;
        float edge_x = clipper[edge + 1 < 3 ? edge + 1 : 0][0] - clipper[edge][0];
        float edge_z = clipper[edge + 1 < 3 ? edge + 1 : 0][2] - clipper[edge][2];
        for (int i = 0; i < count; ++i) {
            float *first = vertices[source][i];
            float *second = vertices[source][i + 1 < count ? i + 1 : 0];
            float first_side = edge_x * (first[2] - clipper[edge][2]) - edge_z * (first[0] - clipper[edge][0]);
            float second_side = edge_x * (second[2] - clipper[edge][2]) - edge_z * (second[0] - clipper[edge][0]);
            if (first_side >= 0.0f) {
                for (int component = 0; component < 4; ++component)
                    vertices[target][output_count][component] = first[component];
                output_count++;
            }
            if ((first_side >= 0.0f) != (second_side >= 0.0f)) {
                float factor = first_side / (first_side - second_side);
                for (int component = 0; component < 4; ++component)
                    vertices[target][output_count][component] = first[component] + factor * (second[component] - first[component]);
                output_count++;
            }
        }
        count = output_count;
        source = target;
        if (count == 0) break;
    }
    if (count < 3) return 0.0f;
    float area = 0.0f;
    for (int i = 0; i < count; ++i) {
        float *first = vertices[source][i];
        float *second = vertices[source][i + 1 < count ? i + 1 : 0];
        area += second[0] * first[2] - first[0] * second[2];
    }
    if (box != NULL) {
        float e0x = clipper[1][0] - clipper[0][0];
        float e0y = clipper[1][1] - clipper[0][1];
        float e0z = clipper[1][2] - clipper[0][2];
        float e1x = clipper[2][0] - clipper[1][0];
        float e1y = clipper[2][1] - clipper[1][1];
        float e1z = clipper[2][2] - clipper[1][2];
        float nx = e0y * e1z - e0z * e1y;
        float ny = e0z * e1x - e0x * e1z;
        float nz = e0x * e1y - e0y * e1x;
        float distance = -(nx * clipper[0][0] + ny * clipper[0][1] + nz * clipper[0][2]);
        for (int i = 0; i < count; ++i) {
            float *vertex = vertices[source][i];
            vertex[1] = -(nx * vertex[0] + nz * vertex[2] + distance) / ny;
            if (i == 0) {
                for (int component = 0; component < 4; ++component)
                    box->max[component] = box->min[component] = vertex[component];
            } else {
                mgVectorMaxMin(box->max, box->min, box->max, box->min, vertex);
            }
        }
    }
    return area * 0.5f;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editcoll", OverlapPoly3AreaXZ__FPA4_fPA4_fP9mgVu0FBOX);
#endif
void CEditCollision::Copy(CEditCollision &dest, int plane_no, mgCMemory *memory) {

    int count;
    int i;
    int off;
    u32 size;
    int copied;
    u32 blocks;
    int src_off;
    int dst_off;
    CCPoly *src;
    CCPoly *dst;
    off = 0;
    count = 0;
    i = 0;
    while (i < poly_count) {
        if (plane_no == ((CCPoly *)((u8 *)poly + off))->area_kind) {
            count++;
        }
        off += sizeof(CCPoly);
        i++;
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
    dest.poly = new ((u_long128 *)memory->Alloc(blocks + 2)) CCPoly[count];
    copied = 0;
    if (dest.poly != NULL) {
        src_off = 0;
        dst_off = 0;
        while (copied < poly_count) {
            src = (CCPoly *)((u8 *)poly + src_off);
            if (plane_no == src->area_kind) {
                dst = (CCPoly *)((u8 *)dest.poly + dst_off);
                dst_off += sizeof(CCPoly);
                *dst = *src;
            }
            src_off += sizeof(CCPoly);
            copied++;
        }
    }
    CreateBBox();
}
float CEditCollision::AreaXZ() {
    float total;
    float(*poly)[4];
    int i;
    int count;
    count = poly_count;
    poly = (float(*)[4])this->poly;
    total = 0.0f;
    for (i = 0; i < count; i++) {
        float area;
        float bx;
        float bz;
        float cz;
        float ax;
        float az;
        float cx;
        ax = poly[0][0];
        bz = poly[1][2];
        bx = poly[1][0];
        az = poly[0][2];
        cz = poly[2][2];
        cx = poly[2][0];
        float sum = -ax * bz + bx * az;
        sum += -bx * cz + cx * bz;
        sum += -cx * az + ax * cz;
        area = 0.5f * sum;
        total += (area < 0.0f) ? -area : area;
        poly += 5;
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
    float triangle[3][4];
    float depth;
    mgVu0FBOX triBox;
    int started;
    float(*poly)[4];
    int i;
    int count;
    float total;
    i = 0;
    count = other.poly_count;
    total = 0.0f;
    poly = (float(*)[4])other.poly;
    started = 0;
    if (0 < count) {
        do {
            mgApplyMatrixN(triangle, matrix, poly, 3);
            if (OverlapPoly3XZ(triangle, &depth, &triBox) != 0) {
                total += depth;
                if (box != NULL) {
                    if (started == 0) {
                        started = 1;
                        *box = triBox;
                    } else {
                        mgBoxMaxMin(box, &triBox);
                    }
                }
            }
            i++;
            poly += 5;
        } while (i < count);
    }
    return total;
}

#ifdef NONMATCHING
int CEditCollision::OverlapPoly3XZ(float (*triangle)[4], float (*matrix)[4], float *area) {
    if (poly == NULL) return 0;
    float tri_max[4], tri_min[4], transformed_max[4], transformed_min[4];
    mgVectorMaxMin(tri_max, tri_min, triangle[0], triangle[1], triangle[2]);
    if (area != NULL) *area = 0.0f;
    mgApplyMatrix(transformed_max, transformed_min, matrix, bbox.max, bbox.min);
    if (!ClipBoxXZ(tri_max, tri_min, transformed_max, transformed_min)) return 0;
    float total = 0.0f;
    for (int i = 0; i < poly_count; ++i) {
        float transformed[3][4];
        mgApplyMatrixN(transformed, matrix, poly[i].vertex, 3);
        if (transformed[0][1] <= 0.1f && transformed[1][1] <= 0.1f && transformed[2][1] <= 0.1f) {
            float overlap = OverlapPoly3AreaXZ(triangle, transformed, NULL);
            if (overlap < 0.0f) overlap = -overlap;
            total += overlap;
        }
    }
    if (area != NULL) *area = total;
    return total > 0.0f;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editcoll", OverlapPoly3XZ__14CEditCollisionFPA4_fPA4_fPf);
#endif

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
                p->vertex[j][1] = (int)(p->vertex[j][1] + 0.5f);
            } else {
                p->vertex[j][1] = (int)(p->vertex[j][1] - 0.5f);
            }
        }

        mgPlaneNormal(p->normal, p->vertex[0], p->vertex[1], p->vertex[2]);
        sceVu0Normalize(p->normal, p->normal);
    }

    CreateBBox();
}
void CEditCollision::DeleteVerticalPoly() {
    float normal[4];
    CCPoly *poly;
    int i;
    CCPoly *slot;
    CCPoly *last;
    int remaining;
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
                last = &poly[poly_count];
                *slot = *last;
            }
        }
        CreateBBox();
    }
}
int CEditCollision::PickupVerticalPoly() {
    float normal[4];
    float normal_a[4];
    float normal_b[4];
    CCPoly *poly;
    int i;
    CCPoly *slot;
    CCPoly *last;
    int remaining;
    int planes;
    int k;
    CCPoly *same;
    int j;
    int off;
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
            last = &poly[poly_count];
                *slot = *last;
        }
    }
    CreateBBox();
    cur = poly;
    planes = 0;
    for (k = 0; k < poly_count; k++, cur++) {
        same = NULL;
        j = 0;
        if (0 < k) {
            off = 0;
            do {
                sceVu0Normalize(normal_a, cur->normal);

                sceVu0Normalize(normal_b, ((CCPoly *)((u8 *)poly + off))->normal);
                if (mgDistVector(normal_a, normal_b) <= 0.01f) {
                    float dot_a = sceVu0InnerProduct(normal_a, cur->vertex[0]);
                    float diff =
                        dot_a - sceVu0InnerProduct(normal_b,
                                                  ((CCPoly *)((u8 *)poly + off))->vertex[0]);
                    diff = (diff < 0.0f) ? -diff : diff;
                    if (diff <= 0.01f) {
                        same = &poly[j];
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
