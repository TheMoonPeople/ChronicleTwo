#include "common.h"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "editcoll.hpp"

extern "C" int fptosi(float value);

#pragma global_optimizer off
// Code (.text)
int ClipBoxXZ(float *max_a, float *min_a, float *max_b, float *min_b) {
    register int status;
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
        cfc2.ni status, vi16
    }
    return (status & 0x80) == 0;
}
#pragma global_optimizer reset
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editcoll", OverlapPoly3AreaXZ__FPA4_fPA4_fP9mgVu0FBOX);
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
int CEditCollision::OverlapPoly3XZ(float (*triangle)[4], float *depth, mgVu0FBOX *box) {
    float tri_max[4];
    float tri_min[4];
    mgVu0FBOX overlapBox;
    float poly_max[4];
    float poly_min[4];
    float *poly;
    float total;
    int hits;
    int i;
    poly = (float *)this->poly;
    if (poly == NULL) {
        return 0;
    }
    mgVectorMaxMin(tri_max, tri_min, triangle[0], triangle[1], triangle[2]);
    if (depth != NULL) {
        *depth = 0.0f;
    }
    if (box != NULL) {
        mgZeroVectorW(box->max);
        mgZeroVectorW(box->min);
    }
    if (ClipBoxXZ(tri_max, tri_min, bbox.max, bbox.min) == 0) {
        return 0;
    }
    total = 0.0f;
    hits = 0;
    i = 0;
    while (i < poly_count) {
        float area;
        mgVectorMaxMin(poly_max, poly_min, poly, poly + 4, poly + 8);
        if (ClipBoxXZ(tri_max, tri_min, poly_max, poly_min) != 0) {
            area = OverlapPoly3AreaXZ(triangle, (float(*)[4])poly, &overlapBox);
            area = (area < 0.0f) ? -area : area;
            total += area;
            if ((double)area > 0.0) {
                if (box != NULL) {
                    if (hits == 0) {
                        *box = overlapBox;
                    } else {
                        mgBoxMaxMin(box, &overlapBox);
                    }
                }
                hits++;
            }
        }
        i++;
        poly += 20;
    }
    if (depth != NULL) {
        *depth = total;
    }
    if (!(total <= 0.0f)) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editcoll", OverlapPoly3XZ__14CEditCollisionFPA4_fPA4_fPf);
void CEditCollision::ApplyMatrix(float (*matrix)[4]) {
    CCPoly *poly;
    int i;
    int corner;
    int off;
    float *height;
    poly = this->poly;
    if (poly != NULL) {
        for (i = 0; i < poly_count; i++, poly++) {
            mgApplyMatrixN((float(*)[4])poly, matrix, (float(*)[4])poly, 3);
            corner = 0;
            off = 0;
            do {

                height = (float *)((u8 *)poly + off) + 1;
                if (*height > 0.0f) {
                    *height = (float)fptosi(0.5f + *height);
                } else {
                    *height = (float)fptosi(*height - 0.5f);
                }
                corner++;
                off += 0x10;
            } while (corner < 3);
            mgPlaneNormal(poly->normal, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
            sceVu0Normalize(poly->normal, poly->normal);
        }
        CreateBBox();
    }
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
