#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "effect.hpp"
#include "mg_sprite.hpp"
#include "scriptinterpreter.hpp"
#include "effectlist.hpp"
#include <cstring>

extern "C" int fptosi(float value);
extern "C" void __ct__11mgCDrawPrimFv(void *);

void DivSpriteScreen(mgCDrawPrim &prim);
void DivSpriteScreen(mgCDrawPrim &prim, int left, int right, int mode);

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effectlist", LoadEFPFile__11CEffectListFPcPUiiP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effectlist", __ct__11mgC3DSpriteFv);
int CEffectList::SaerchEffectIndex(char *name) {
    int i;

    for (i = 0; i < effect_num; i++) {
        if (strcmp(name, managers[i].name) == 0) {
            return i;
        }
    }
    return -1;
}
mgC3DSprite *CEffectList::GetEffectVisual(int index) {
    if (index < 0 || index >= effect_num) {
        return NULL;
    }
    return sprites + index;
}
void CEffectList::Step(void) {
    int i;

    for (i = 0; i < effect_num; i++) {
        managers[i].Ctrl();
        managers[i].Step(1);
    }
}
void CEffectList::CreatePacket(void) {
    int i;

    for (i = 0; i < effect_num; i++) {
        managers[i].CreatePacket(sprites + i);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effectlist", CreatePacket__14CEffectManagerFP11mgC3DSprite);
void CFadeInOut::Initialize(void) {
    alpha = 0.0f;
    b = 0.0f;
    g = 0.0f;
    r = 0.0f;
    mode = 0;
    speed = 0.0f;
    end = 0;
    cross = 0;
    cross_texture = NULL;
    blur_alpha = 0;
}
void CFadeInOut::ResetFade(void) {
    mode = 0;
    alpha = 0.0f;
    cross = 0;
}
void CFadeInOut::FadeIn(int frames, float r, float g, float b) {
    if ((mode == 0) || (frames < 0)) {
        alpha = 128.0f;
    }
    mode = 1;
    end = 0;
    if (frames < 0) {
        speed = 0.0f;
    } else {
        speed = 128.0f / (float)frames;
    }
    this->r = r;
    this->g = g;
    this->b = b;
    cross = 0;
}
void CFadeInOut::FadeIn(int frames) {
    if (mode >= 0) {
        FadeIn(frames, 0.0f, 0.0f, 0.0f);
    } else {
        FadeIn(frames, r, g, b);
    }
}
void CFadeInOut::FadeOut(int frames, float r, float g, float b) {
    if ((mode == 0) || (frames < 0)) {
        alpha = 0.0f;
    }
    mode = -1;
    end = 0;
    if (frames < 0) {
        speed = 0.0f;
    } else {
        speed = 128.0f / (float)frames;
    }
    this->r = r;
    this->g = g;
    this->b = b;
    cross = 0;
}
void CFadeInOut::CrossFade(int duration, float alpha) {
    CrossFadeIn(0, duration, alpha);
}
void CFadeInOut::CrossFadeIn(int mode, int frames, float value) {
    cross_type = mode;
    FadeIn(frames, 128.0f, 128.0f, 128.0f);
    cross = 1;
    cross_alpha_rate = value;
}
void CFadeInOut::CrossFadeOut(int mode, int frames, float value) {
    cross_type = mode;
    FadeOut(frames, 128.0f, 128.0f, 128.0f);
    alpha = 0.0f;
    cross = 1;
    cross_alpha_rate = value;
}
int CFadeInOut::FadeCheck() { return this->end; }
int CFadeInOut::NowFade(void) {
    return mode != 0;
}
int CFadeInOut::FadeStep(void) {
    if (mode == 0) {
        return 1;
    }
    if (mode > 0) {
        alpha -= speed;
        if (alpha <= 0.0f) {
            alpha = 0.0f;
            mode = 0;
            end = 1;
        }
    } else {
        alpha += speed;
        if (!(alpha < 128.0f)) {
            alpha = 128.0f;
            end = 1;
        }
    }
    if (end != 0 && cross != 0 && cross_type == CROSS_FADE_WIPE) {
        alpha = 0.0f;
    }
    return end;
}
void CFadeInOut::SetCrossTexture(mgCTexture *texture, u_long128 *image) {
    if (texture != NULL) {
        cross_texture = texture;

        (*(mgCTexture *volatile *)&cross_texture)->image[0] = image;
    }
}
void CFadeInOut::CaptureScreen(void) {
    if (cross_texture == NULL || cross_texture->image[0] == NULL) {
        return;
    }
    mgCTexture back_buffer;

    mgGetFrameBackBuffer(&back_buffer);
    mgStoreImage(&back_buffer, cross_texture->image[0]);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effectlist", DivSpriteScreen__FR11mgCDrawPrim);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effectlist", DivSpriteScreen__FR11mgCDrawPrimiii);
void CFadeInOut::Draw(void) {
    u_char prim[0x120];
    u_char prim2[0x120];

    if (alpha > 0.0f) {
        __ct__11mgCDrawPrimFv(prim);
        ((mgCDrawPrim *)prim)->Initialize(NULL, NULL);
        ((mgCDrawPrim *)prim)->DepthTestEnable(0);
        ((mgCDrawPrim *)prim)->AlphaTestEnable(0);
        ((mgCDrawPrim *)prim)->AlphaBlendEnable(1);
        ((mgCDrawPrim *)prim)->AlphaBlend(1);
        ((mgCDrawPrim *)prim)->ZMask(-1);
        if (cross != 0) {
            if (cross_texture != NULL) {
                cross_texture->tex0.bits.tcc = 0;
                mgTexManager.ReloadTexture(cross_texture->block, (sceVif1Packet *)NULL);
                ((mgCDrawPrim *)prim)->TextureMapEnable(1);
                if (cross_type == CROSS_FADE_WIPE) {
                    ((mgCDrawPrim *)prim)->Begin2();
                    ((mgCDrawPrim *)prim)->BeginPrim2(6);
                    ((mgCDrawPrim *)prim)->Texture(cross_texture);

                    ((mgCDrawPrim *)prim)->Direct(0x3B, 0x8080 | ((u_long)0x80 << 32));
                    ((mgCDrawPrim *)prim)->Color(0x80, 0x80, 0x80, 0x80);
                    ((mgCDrawPrim *)prim)->EndPrim2();
                    if (mode > 0) {
                        DivSpriteScreen(*(mgCDrawPrim *)prim, 0,
                                        fptosi((alpha / 128.0f) * (float)mgScreenWidth), 0);
                    } else {
                        int width = mgScreenWidth;

                        DivSpriteScreen(*(mgCDrawPrim *)prim, fptosi((alpha / 128.0f) * (float)width),
                                        width, 1);
                    }
                    ((mgCDrawPrim *)prim)->End2();
                } else {
                    int b;
                    int g;
                    int r;

                    ((mgCDrawPrim *)prim)->Begin2();
                    ((mgCDrawPrim *)prim)->BeginPrim2(6);
                    ((mgCDrawPrim *)prim)->Texture(cross_texture);

                    ((mgCDrawPrim *)prim)->Direct(0x3B, 0x8080 | ((u_long)0x80 << 32));
                    r = fptosi(this->r);
                    g = fptosi(this->g);
                    b = fptosi(this->b);
                    ((mgCDrawPrim *)prim)->Color(r, g, b, fptosi(alpha * cross_alpha_rate));
                    ((mgCDrawPrim *)prim)->EndPrim2();
                    DivSpriteScreen(*(mgCDrawPrim *)prim);
                    ((mgCDrawPrim *)prim)->End2();
                }
            }
        } else {
            int b;
            int g;
            int r;

            ((mgCDrawPrim *)prim)->TextureMapEnable(0);
            ((mgCDrawPrim *)prim)->Begin2();
            ((mgCDrawPrim *)prim)->BeginPrim2(6);
            r = fptosi(this->r);
            g = fptosi(this->g);
            b = fptosi(this->b);
            ((mgCDrawPrim *)prim)->Color(r, g, b, fptosi(alpha));
            ((mgCDrawPrim *)prim)->EndPrim2();
            DivSpriteScreen(*(mgCDrawPrim *)prim);
            ((mgCDrawPrim *)prim)->End2();
        }
    }
    if (blur_alpha != 0) {
        __ct__11mgCDrawPrimFv(prim2);
        ((mgCDrawPrim *)prim2)->Initialize(NULL, NULL);
        mgCTexture back_tex;

        mgGetFrameBackBuffer(&back_tex);
        back_tex.tex0.bits.tcc = 0;
        ((mgCDrawPrim *)prim2)->TextureMapEnable(1);
        ((mgCDrawPrim *)prim2)->AlphaBlendEnable(1);
        ((mgCDrawPrim *)prim2)->AlphaBlend(1);
        ((mgCDrawPrim *)prim2)->DepthTestEnable(0);
        ((mgCDrawPrim *)prim2)->ZMask(-1);
        ((mgCDrawPrim *)prim2)->Begin(6);

        ((mgCDrawPrim *)prim2)->Direct( 0x3B, 0x80 | ((u_long)0x80 << 32));
        ((mgCDrawPrim *)prim2)->Texture(&back_tex);
        ((mgCDrawPrim *)prim2)->Color(0x80, 0x80, 0x80, blur_alpha);
        ((mgCDrawPrim *)prim2)->TextureCrd(0, 0);
        ((mgCDrawPrim *)prim2)->Vertex(0, 0, 0);
        ((mgCDrawPrim *)prim2)->TextureCrd(back_tex.width, back_tex.height);
        ((mgCDrawPrim *)prim2)->Vertex(back_tex.width, back_tex.height, 0);
        ((mgCDrawPrim *)prim2)->End();
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effectlist", at_393__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effectlist", at_260__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effectlist", at_261__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effectlist", at_589__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_392, 0x10);
INCLUDE_BSS(at_564__2, 0x10);
INCLUDE_BSS(at_565, 0x10);
INCLUDE_BSS(at_566, 0x10);
INCLUDE_BSS(at_586, 0x10);
INCLUDE_BSS(at_587, 0x10);
INCLUDE_BSS(at_588, 0x10);
