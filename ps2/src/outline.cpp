#include "common.h"
#include "outline.hpp"

#include "mg_math.hpp"

// Code (.text)
void COutLineDraw::Initialize() {
    mgZeroVector(unk_10.max);
    mgZeroVector(unk_10.min);
    frame = NULL;
    texture = NULL;
    width = 0.0f;
    depth_from_pos = 0;
    color[0] = 80.0f;
    color[1] = 60.0f;
    color[2] = 0.0f;
    color[3] = 128.0f;
    enable = 1;
    hide_edge = 0;
    next = NULL;
}
void COutLineDraw::SetFrame(mgCFrame *new_frame) {
    frame = new_frame;
}
int COutLineDraw::Draw(float *pos, float scale, float alpha) {

    *(u_long128 *)this->pos = *(u_long128 *)pos;
    return Draw(scale, alpha);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/outline", Draw__12COutLineDrawFff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/outline", DrawDivSprite__FP11mgCDrawPrim9mgRect_i_P10mgCTexturePiiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/outline", DrawDivSprite4__FP11mgCDrawPrim9mgRect_i_P10mgCTexturePiii);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/outline", at_338__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_299__2, 0x10);
INCLUDE_BSS(at_300__2, 0x10);
INCLUDE_BSS(at_325, 0x10);
INCLUDE_BSS(at_395, 0x10);
INCLUDE_BSS(at_396, 0x10);
INCLUDE_BSS(at_398, 0x10);
INCLUDE_BSS(at_399, 0x10);
