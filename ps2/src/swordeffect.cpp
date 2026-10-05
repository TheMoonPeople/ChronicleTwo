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

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", CreatSmoothPassSW__FPA4_fPA4_fiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", Draw__17CSWordAfterEffectFv);
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
void CSWordAfterEffect::SetTexture(int u0, int v0, int u1, int v1) {
    tex_u = u0;
    tex_v = v0;
    tex_w = u1;
    tex_h = v1;
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
void CSWordAfterEffect::AddPoint(float *edge_a, float *edge_b) {
    sceVu0CopyVector(point0[write_index], edge_a);
    sceVu0CopyVector(point1[write_index], edge_b);
    head_index = write_index;
    int count = point_num;
    if (count < point_max) {
        point_num = count + 1;
    }
    write_index -= 1;
    if (write_index < 0) {
        write_index = point_max - 1;
    }
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", Initialize__17CSWordAfterEffectFP9mgCMemoryii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/swordeffect", Copy__17CSWordAfterEffectFR17CSWordAfterEffectP9mgCMemory);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/swordeffect", at_356__DATA);
