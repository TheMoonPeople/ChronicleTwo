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
    if (num < 3) return 0;
    sceVu0FMATRIX basis = {
        {-0.5f, 1.5f, -1.5f, 0.5f},
        {1.0f, -2.5f, 2.0f, -0.5f},
        {-0.5f, 0.0f, 0.5f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f}
    };
    int written = 0;
    for (int segment = 0; segment < num - 1; ++segment) {
        int control[4];
        control[0] = segment > 0 ? segment - 1 : 0;
        control[1] = segment;
        control[2] = segment + 1;
        control[3] = segment < num - 2 ? segment + 2 : segment + 1;
        sceVu0FMATRIX points;
        for (int row = 0; row < 4; ++row) {
            int index = start + control[row];
            if (index >= ring_size) index -= ring_size;
            if (index < 0) index += ring_size;
            points[row][0] = src[index][0];
            points[row][1] = src[index][1];
            points[row][2] = src[index][2];
            points[row][3] = 0.0f;
        }
        sceVu0FMATRIX coefficients;
        sceVu0MulMatrix(coefficients, points, basis);
        float t = 0.0f;
        while (t < 1.0f - 1.0f / (division - 1.0f)) {
            float powers[4] = {t * t * t, t * t, t, 1.0f};
            sceVu0ApplyMatrix(dst[written], coefficients, powers);
            dst[written][3] = 1.0f;
            t += 1.0f / (division - 1.0f);
            ++written;
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
#ifdef NONMATCHING
void CSWordAfterEffect::Initialize(mgCMemory *memory, int capacity, int subdivisions) {
    frame0 = NULL; frame1 = NULL;
    int point_words = capacity + 1;
    point0 = (sceVu0FVECTOR *)memory->Alloc(point_words);
    point1 = (sceVu0FVECTOR *)memory->Alloc(point_words);
    int smooth_words = capacity * (subdivisions + 2) + 1;
    smooth0 = (sceVu0FVECTOR *)memory->Alloc(smooth_words);
    smooth1 = (sceVu0FVECTOR *)memory->Alloc(smooth_words);
    color0[0] = 0x60; color0[1] = 0x40; color0[2] = 0x30; color0[3] = 0x80;
    color1[0] = 0x40; color1[1] = 0x30; color1[2] = 0x20; color1[3] = 0x40;
    texture = NULL;
    point_max = capacity; division = subdivisions;
    smooth_num = point_num = 0;
    write_index = head_index = capacity - 1;
    active = 0; alpha = fade_speed = 0.0f;
    hold_time = 0; length = 0x20;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", Initialize__17CSWordAfterEffectFP9mgCMemoryii);
#endif

#ifdef NONMATCHING
void CSWordAfterEffect::Copy(CSWordAfterEffect &dst, mgCMemory *memory) {
    dst.frame0 = frame0; dst.frame1 = frame1;
    dst.point0 = point0; dst.point1 = point1;
    dst.smooth0 = smooth0; dst.smooth1 = smooth1;
    sceVu0CopyVector((float *)dst.color0, (float *)color0);
    sceVu0CopyVector((float *)dst.color1, (float *)color1);
    for (int component = 0; component < 4; ++component) dst.unk_40[component] = unk_40[component];
    for (int component = 0; component < 2; ++component) dst.unk_50[component] = unk_50[component];
    dst.division = division; dst.smooth_num = smooth_num;
    dst.tex_block = tex_block; dst.texture = texture;
    dst.tex_u = tex_u; dst.tex_v = tex_v; dst.tex_w = tex_w; dst.tex_h = tex_h;
    dst.point_max = point_max; dst.point_num = point_num;
    dst.write_index = write_index; dst.head_index = head_index;
    dst.active = active; dst.length = length; dst.hold_time = hold_time;
    dst.alpha = alpha; dst.fade_speed = fade_speed;
    if (memory != NULL) {
        int point_words = point_max + 1;
        dst.point0 = (sceVu0FVECTOR *)memory->Alloc(point_words);
        dst.point1 = (sceVu0FVECTOR *)memory->Alloc(point_words);
        int smooth_words = point_max * (division + 2) + 1;
        dst.smooth0 = (sceVu0FVECTOR *)memory->Alloc(smooth_words);
        dst.smooth1 = (sceVu0FVECTOR *)memory->Alloc(smooth_words);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", Copy__17CSWordAfterEffectFR17CSWordAfterEffectP9mgCMemory);
#endif

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/swordeffect", at_356__DATA);
