#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "swordeffect.hpp"
#include <cstdio>

extern char at_356[];

#ifdef NONMATCHING
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "mg_texture.hpp"
#include <cstdio>
#endif

#ifdef NONMATCHING
int CreatSmoothPassSW(float (*dst)[4], float (*src)[4], int num, int division, int start, int ring_size) {
    sceVu0FMATRIX coefficients;
    sceVu0FMATRIX points;
    sceVu0FMATRIX basis;
    float powers[4];
    float result[4];
    int control[4];
    if (num < 3) {
        return 0;
    }
    float quarter = 0.25f;
    float half = 0.5f;
    basis[0][0] = -quarter / half;
    basis[0][1] = 1.5f;
    basis[0][2] = (-half - quarter) / half;
    basis[0][3] = 0.5f;
    basis[1][0] = 1.0f;
    basis[1][1] = -1.25f / half;
    basis[1][2] = 2.0f;
    basis[1][3] = -half;
    basis[2][0] = basis[0][0];
    basis[2][1] = 0.0f;
    basis[2][2] = 0.5f;
    basis[2][3] = 0.0f;
    basis[3][0] = 0.0f;
    basis[3][1] = 1.0f;
    basis[3][2] = 0.0f;
    basis[3][3] = 0.0f;
    int written = 0;
    for (int segment = 0; segment < num - 1; segment++) {
        if (segment > 0 && segment < num - 2) {
            control[0] = segment - 1;
            control[1] = segment;
            control[2] = segment + 1;
            control[3] = segment + 2;
        } else {
            if (segment <= 0) {
                control[0] = 0;
                control[1] = 0;
                control[2] = 1;
                control[3] = 2;
            }
            if (segment >= num - 2) {
                control[0] = segment - 1;
                control[1] = segment;
                control[2] = segment + 1;
                control[3] = segment + 1;
            }
        }
        for (int row = 0; row < 4; row++) {
            control[row] += start;
            if (control[row] >= ring_size) {
                control[row] -= ring_size;
            }
            if (control[row] < 0) {
                control[row] += ring_size;
            }
        }
        float *p0 = src[control[0]];
        float *p1 = src[control[1]];
        float *p2 = src[control[2]];
        float *p3 = src[control[3]];
        points[0][0] = p0[0];
        points[0][1] = p0[1];
        points[0][2] = p0[2];
        points[0][3] = 0.0f;
        points[1][0] = p1[0];
        points[1][1] = p1[1];
        points[1][2] = p1[2];
        points[1][3] = 0.0f;
        points[2][0] = p2[0];
        points[2][1] = p2[1];
        points[2][2] = p2[2];
        points[2][3] = 0.0f;
        points[3][0] = p3[0];
        points[3][1] = p3[1];
        points[3][2] = p3[2];
        points[3][3] = 0.0f;
        sceVu0MulMatrix(coefficients, points, basis);
        float t = 0.0f;
        float step;
        while (t < 1.0f - (step = 1.0f / (division - 1.0f))) {
            powers[3] = 1.0f;
            powers[2] = t;
            powers[1] = t * t;
            powers[0] = t * powers[1];
            sceVu0ApplyMatrix(result, coefficients, powers);
            float *out = dst[written];
            out[0] = result[0];
            out[1] = result[1];
            out[2] = result[2];
            out[3] = 1.0f;
            t += step;
            written++;
        }
    }
    return written;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", CreatSmoothPassSW__FPA4_fPA4_fiiii);
#endif

#ifdef NONMATCHING
void CSWordAfterEffect::Draw() {
    if (!active || point_num <= 0) return;
    float opacity = alpha;
    int count = (int)((float)length * opacity);
    if (smooth_num < count) count = smooth_num;
    if (count <= 0) return;
    float alpha_step = opacity / (float)count;
    mgCDrawPrim prim;
    if (texture != NULL) mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *)NULL);
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(2);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.ZMask(-1);
    prim.Bilinear(1);
    prim.TextureMapEnable(texture != NULL);
    prim.Coord(1);
    prim.Shading(1);
    prim.DepthTestEnable(1);
    prim.DepthTest(1);
    prim.Begin(4);
    if (texture != NULL) prim.Texture(texture);
    float u_step = (float)tex_w / (float)count;
    float u = (float)tex_u;
    for (int point = 0; point < count; ++point) {
        int projected[4];
        if (mgTransWorldPrim(projected, smooth0[point])) {
            prim.Color(color0[0], color0[1], color0[2], (int)((float)color0[3] * opacity));
            if (texture != NULL) prim.TextureCrd((int)u, tex_v);
            prim.Vertex4(projected);
        }
        if (mgTransWorldPrim(projected, smooth1[point])) {
            int *edge_color = texture != NULL ? color0 : color1;
            prim.Color(edge_color[0], edge_color[1], edge_color[2], (int)((float)edge_color[3] * opacity));
            if (texture != NULL) prim.TextureCrd((int)u, tex_v + tex_h);
            prim.Vertex4(projected);
        }
        if (texture != NULL) u += u_step;
        opacity -= alpha_step;
    }
    prim.End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", Draw__17CSWordAfterEffectFv);
#endif
void CSWordAfterEffect::CreatPointList(void) {
    if (active != 0 && point_num > 0) {
        smooth_num =
            CreatSmoothPassSW(smooth0, point0, point_num, division, head_index, point_max);
        CreatSmoothPassSW(smooth1, point1, point_num, division, head_index, point_max);
        if (smooth_num != 0) {
            int i = 0;
            goto check;
        body:
            i++;
        check:
            if (i < point_num - 1)
                goto body;
        }
    }
}
void CSWordAfterEffect::SetTexture(int tex_no, mgCTexture *tex, int u0, int v0, int u1, int v1) {
    tex_block = tex_no;
    texture = tex;
    tex_u = u0;
    tex_v = v0;
    tex_w = u1;
    tex_h = v1;
    color0[0] = color0[1] = color0[2] = color0[3] = 0x80;
    color1[0] = color1[1] = color1[2] = color1[3] = 0x80;
}

void CSWordAfterEffect::SetTexture(int u, int v, int w, int h) {
    tex_u = u; tex_v = v; tex_w = w; tex_h = h;
}
void CSWordAfterEffect::StartEffect(mgCFrame *start, mgCFrame *end, int value8_c, int frames,
                                    int hold) {
    frame0 = start;
    frame1 = end;
    length = value8_c;
    hold_time = hold;
    active = 1;
    alpha = 1.0f;
    fade_speed = 1.0f / (float)frames;
    smooth_num = 0;
    point_num = 0;
    write_index = point_max - 1;
    head_index = point_max - 1;
    printf((char *)at_356);
}

void CSWordAfterEffect::AddPoint(float *first, float *second) {
    sceVu0CopyVector(point0[write_index], first);
    sceVu0CopyVector(point1[write_index], second);
    head_index = write_index;
    if (point_num < point_max) ++point_num;
    --write_index;
    if (write_index < 0) write_index = point_max - 1;
}
void CSWordAfterEffect::Step(void) {
    float edge_a[4];
    float edge_b[4];
    if (active == 0) {
        return;
    }
    if (frame0 == NULL || frame1 == NULL) {
        return;
    }
    frame0->GetWorldPosition0(edge_a);
    frame1->GetWorldPosition0(edge_b);
    AddPoint(edge_a, edge_b);
    if (hold_time > 0) {
        hold_time--;
        return;
    }
    alpha -= fade_speed;
    if (alpha <= 0.0f) {
        active = 0;
    }
}
void CSWordAfterEffect::Clear(void) {
    active = 0;
    frame1 = NULL;
    frame0 = NULL;
}
void CSWordAfterEffect::Initialize(mgCMemory *memory, int capacity, int subdivisions) {
    int point_size = capacity * 16;
    int smooth_size = capacity * (subdivisions + 2) * 16;
    frame1 = NULL;
    frame0 = NULL;
    point0 = (sceVu0FVECTOR *)memory->Alloc(point_size / 16 + 1);
    point1 = (sceVu0FVECTOR *)memory->Alloc(point_size / 16 + 1);
    smooth0 = (sceVu0FVECTOR *)memory->Alloc(smooth_size / 16 + 1);
    smooth1 = (sceVu0FVECTOR *)memory->Alloc(smooth_size / 16 + 1);
    color0[0] = 0x60;
    color0[1] = 0x40;
    color0[2] = 0x30;
    color0[3] = 0x80;
    color1[0] = 0x40;
    color1[1] = 0x30;
    color1[2] = 0x20;
    color1[3] = 0x40;
    texture = NULL;
    point_max = capacity;
    division = subdivisions;
    point_num = smooth_num = 0;
    head_index = write_index = capacity - 1;
    active = 0;
    fade_speed = alpha = 0.0f;
    hold_time = 0;
    length = 0x20;
}

void CSWordAfterEffect::Copy(CSWordAfterEffect &dst, mgCMemory *memory) {
    dst.frame0 = frame0;
    dst.frame1 = frame1;
    dst.point0 = point0;
    dst.point1 = point1;
    dst.smooth0 = smooth0;
    dst.smooth1 = smooth1;
    *(u_long128 *)dst.color0 = *(u_long128 *)color0;
    *(u_long128 *)dst.color1 = *(u_long128 *)color1;
    dst.unk_40 = unk_40;
    dst.unk_50 = unk_50;
    dst.division = division;
    dst.smooth_num = smooth_num;
    dst.tex_block = tex_block;
    dst.texture = texture;
    dst.tex_u = tex_u;
    dst.tex_v = tex_v;
    dst.tex_w = tex_w;
    dst.tex_h = tex_h;
    dst.point_max = point_max;
    dst.point_num = point_num;
    dst.write_index = write_index;
    dst.head_index = head_index;
    dst.active = active;
    dst.length = length;
    dst.hold_time = hold_time;
    dst.alpha = alpha;
    dst.fade_speed = fade_speed;
    if (memory != NULL) {
        int point_size = point_max * 16;
        int smooth_size = point_max * (division + 2) * 16;
        dst.point0 = (sceVu0FVECTOR *)memory->Alloc(point_size / 16 + 1);
        dst.point1 = (sceVu0FVECTOR *)memory->Alloc(point_size / 16 + 1);
        dst.smooth0 = (sceVu0FVECTOR *)memory->Alloc(smooth_size / 16 + 1);
        dst.smooth1 = (sceVu0FVECTOR *)memory->Alloc(smooth_size / 16 + 1);
    }
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/swordeffect", at_356__DATA);
