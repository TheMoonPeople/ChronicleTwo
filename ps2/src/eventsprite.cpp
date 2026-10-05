#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "actionchara.hpp"
#include "scene.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "cameracontrol.hpp"
#include "eventsprite.hpp"
#include <cstring>

// Code (.text)
float ParabolicInitialVectorY(float start_y, float end_y, float gravity, float frames) {
    return ((2.0f * (end_y - start_y)) - (frames * (gravity * frames))) / (2.0f * frames);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/eventsprite", CalcPosParabolicJump__FPfPfPffff);
void CMarker::Draw(void) {
    if (this->count > 0) {
        this->count = this->count - 1;
    }
}
void CMarker::Set(int count) {
    this->count = count;
}
void CMarker::Init() {
    return Set(0);
}
void CEventSprite::SetName(char *name) {
    strcpy(this->name, name);
}
void CEventSprite::SetDraw(int draw) {
    this->draw = draw;
}
void CEventSprite::SetGet(int x, int y, int w, int h) {
    get[0] = x;
    get[1] = y;
    get[2] = w;
    get[3] = h;
}
void CEventSprite::SetPut(int x, int y, int w, int h) {
    put[0] = x;
    put[1] = y;
    put[2] = w;
    put[3] = h;
}
void CEventSprite::SetMove(int x, int y, int frames) {
    anime[0] = EVENT_SPRITE_ANIME_NONE;
    anime[1] = -1;
    anime[2] = -1;
    anime[3] = -1;
    anime[0] = EVENT_SPRITE_ANIME_MOVE;
    anime[1] = x;
    anime[2] = y;
    anime[3] = frames;
}
void CEventSprite::SetFade(int fade_in, int frames) {
    anime[0] = -1;
    anime[1] = -1;
    anime[2] = -1;
    anime[3] = -1;
    anime[0] = 1;
    if (fade_in != 0) {
        anime[1] = 0x80;
    } else {
        anime[1] = 0;
    }
    anime[2] = frames;
}
void CEventSprite::SetColor(int r, int g, int b, int a) {
    color[0] = r;
    color[1] = g;
    color[2] = b;
    color[3] = a;
}
void CEventSprite::Step() {
    switch (anime[0]) {
        case 0:
            if (anime[3] == 0) {
                put[0] = anime[1];
                put[1] = anime[2];
            }
            if (put[0] == anime[1] && put[1] == anime[2]) {
                anime[0] = -1;
                anime[1] = -1;
                anime[2] = -1;
                anime[3] = -1;
                return;
            }
            put[0] = LinerInterpolationI(put[0], anime[1], 1, anime[3] + 1);
            put[1] = LinerInterpolationI(put[1], anime[2], 1, anime[3] + 1);
            anime[3] -= 1;
            break;
        case 1:
            if (anime[2] <= 0) {
                color[3] = anime[1];
            }
            if (color[3] == anime[1]) {
                anime[0] = -1;
                anime[1] = -1;
                anime[2] = -1;
                anime[3] = -1;
                return;
            }
            color[3] = LinerInterpolationI(color[3], anime[1], 1, anime[2] + 1);
            anime[2] -= 1;
            break;
    }
}
extern "C" void __ct__11mgCDrawPrimFv(void *);
void CEventSprite::Draw() {
    u8 drawer[0x120];
    if (draw != 0) {
        __ct__11mgCDrawPrimFv(drawer);
        mgCDrawPrim *prim = (mgCDrawPrim *)drawer;
        mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *)NULL);
        mgCTexture *texture = mgTexManager.GetTexture(name, -1);
        if (texture != NULL) {
            prim->Initialize(NULL, NULL);
            prim->AlphaBlendEnable(1);
            prim->AlphaBlend(1);
            prim->AlphaTestEnable(1);
            prim->AlphaTest(1, 0);
            prim->DepthTestEnable(0);
            prim->ZMask(-1);
            prim->Shading(0);
            prim->TextureMapEnable(1);
            prim->Bilinear(0);
            prim->AntiAliasing(1);
            prim->Begin(6);
            prim->Texture(texture);
            prim->Color(color[0], color[1], color[2], color[3]);
            prim->TextureCrd(get[0], get[1]);
            prim->Vertex(put[0], put[1], 0);
            prim->TextureCrd(get[0] + get[2], get[1] + get[3]);
            prim->Vertex(put[0] + put[2], put[1] + put[3], 0);
            prim->End();
        }
    }
}
void CEventSprite::Init(void) {
    draw = 0;
    tex_block = 0;
    memset(name, 0, sizeof(name));
    memset(color, 0, sizeof(color));
    memset(get, 0, sizeof(get));
    memset(put, 0, sizeof(put));
    memset(anime, -1, sizeof(anime));
}
int CEventSpriteMother::SetName(int index, char *name) {
    if (index < 0 || index >= 8) {
        return 0;
    }
    sprite[index].SetName(name);
    return 1;
}
int CEventSpriteMother::SetDraw(int index, int draw) {
    if (index < 0 || index >= 8) {
        return 0;
    }
    sprite[index].SetDraw(draw);
    return 1;
}
int CEventSpriteMother::SetGet(int index, int a, int b, int c, int d) {
    if (index < 0 || index >= 8) {
        return 0;
    }
    sprite[index].SetGet(a, b, c, d);
    return 1;
}
int CEventSpriteMother::SetPut(int index, int a, int b, int c, int d) {
    if (index < 0 || index >= 8) {
        return 0;
    }
    sprite[index].SetPut(a, b, c, d);
    return 1;
}
int CEventSpriteMother::SetMove(int index, int a, int b, int c) {
    if (index < 0 || index >= 8) {
        return 0;
    }
    sprite[index].SetMove(a, b, c);
    return 1;
}
int CEventSpriteMother::SetFade(int index, int a, int b) {
    if (index < 0 || index >= 8) {
        return 0;
    }
    sprite[index].SetFade(a, b);
    return 1;
}
int CEventSpriteMother::SetColor(int index, int a, int b, int c, int d) {
    if (index < 0 || index >= 8) {
        return 0;
    }
    sprite[index].SetColor(a, b, c, d);
    return 1;
}
void CEventSpriteMother::Step() {
    for (int i = 0; i < 8; i++) {
        sprite[i].Step();
    }
}
void CEventSpriteMother::Draw() {
    for (int i = 0; i < 8; i++) {
        sprite[i].Draw();
    }
}
int CEventSpriteMother::Set(int index, int value) {
    if (index < 0) {
        return 0;
    }
    if (index >= 8) {
        return 0;
    }
    sprite[index].Init();
    sprite[index].SetDraw(0);
    sprite[index].tex_block = value;
    sprite[index].color[0] = 0x80;
    sprite[index].color[1] = 0x80;
    sprite[index].color[2] = 0x80;
    sprite[index].color[3] = 0x80;
    return 1;
}
void CEventSpriteMother::Init() {
    for (int i = 0; i < 8; i++) {
        sprite[i].Init();
    }
}
CEventSprite2::CEventSprite2() {
    Initialize();
}
void CEventSprite2::Initialize(void) {
    draw_flag = 0;
    sprite_type = -1;
    tex_block = -1;
    memset(tex_name, 0, sizeof(tex_name));
    alpha_blend = 1;
    mgZeroVector(pos);
    color[3] = 128.0f;
    color[2] = 128.0f;
    color[1] = 128.0f;
    color[0] = 128.0f;
    put_h = 0;
    put_w = 0;
    uv_y = 0;
    uv_x = 0;
    uv_h = 0;
    uv_w = 0;
    scale_y = 1.0f;
    scale_x = 1.0f;
    rot_z = 0;
}
void CEventSprite2::SetTexture(char *name, int slot) {
    strcpy(tex_name, name);
    tex_block = slot;
}
void CEventSprite2::SetDrawFlag(int draw_flag) {
    this->draw_flag = draw_flag;
}
void CEventSprite2::SetSpriteType(int sprite_type) {
    this->sprite_type = sprite_type;
}
void CEventSprite2::SetPosition(float *pos) {
    sceVu0CopyVector(this->pos, pos);
}
void CEventSprite2::SetColor(float *new_color) {
    sceVu0CopyVector(color, new_color);
}
void CEventSprite2::SetPutSize(int w, int h) {
    put_w = w;
    put_h = h;
}
void CEventSprite2::SetUvSize(int u, int v, int width, int height) {
    uv_x = u;
    uv_y = v;
    uv_w = width;
    uv_h = height;
}
void CEventSprite2::SetScale(float scale_x, float scale_y) {
    this->scale_x = scale_x;
    this->scale_y = scale_y;
}
void CEventSprite2::GetScale(float *out_x, float *out_y) {
    *out_x = scale_x;
    *out_y = scale_y;
}
void CEventSprite2::GetPosition(float *out) {
    sceVu0CopyVector(out, pos);
}
void CEventSprite2::GetColor(float *out) {
    sceVu0CopyVector(out, color);
}
int CEventSprite2::GetType(void) {
    return sprite_type;
}
void CEventSprite2::SetAlphaBlend(int alpha_blend) {
    this->alpha_blend = alpha_blend;
}
void CEventSprite2::SetRotZ(float rot_z) {
    this->rot_z = rot_z;
}
float CEventSprite2::GetRotZ(void) {
    return rot_z;
}
void CEventSprite2::NormalDraw(void) {
    if (draw_flag == EVENT_SPRITE2_DRAW_NORMAL) {
        this->Draw();
    }
}
void CEventSprite2::FirstDraw(void) {
    if (draw_flag == EVENT_SPRITE2_DRAW_FIRST) {
        this->Draw();
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/eventsprite", Draw__13CEventSprite2Fv);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventsprite", at_1069__4__DATA);
