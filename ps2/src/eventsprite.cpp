#include "common.h"

#include <cmath>
#include <cstring>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "eventsprite.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "scene.hpp"

// Code (.text)
float ParabolicInitialVectorY(float start_y, float end_y, float gravity, float frames) {
    return ((2.0f * (end_y - start_y)) - (frames * (gravity * frames))) / (2.0f * frames);
}

void CalcPosParabolicJump(float *pos, float *start, float *end, float gravity, float frames, float frame) {
    float y = start[1];
    float velocity = ParabolicInitialVectorY(start[1], end[1], gravity, 1.0f + frames);

    for (int i = 0; i < (int) frame; i++) {
        velocity += gravity;
        y += velocity;
    }

    float rate = frame / frames;
    pos[0] = LinerInterpolation(start[0], end[0], rate);
    pos[1] = y;
    pos[2] = LinerInterpolation(start[2], end[2], rate);
    pos[3] = 1.0f;
}

void CMarker::Draw() {
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

void CEventSprite::Draw() {
    if (draw != 0) {
        mgCDrawPrim  drawer;
        mgCDrawPrim *prim = &drawer;
        mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) NULL);
        mgCTexture *texture = mgTexManager.GetTexture(name, -1);

        if (texture != NULL) {
            prim->Initialize(NULL, NULL);
            prim->AlphaBlendEnable(1);
            prim->AlphaBlend(MG_ALPHA_BLEND_NORMAL);
            prim->AlphaTestEnable(1);
            prim->AlphaTest(1, 0);
            prim->DepthTestEnable(0);
            prim->ZMask(MG_Z_MASK_MASKED);
            prim->Shading(0);
            prim->TextureMapEnable(1);
            prim->Bilinear(0);
            prim->AntiAliasing(1);
            prim->Begin(MG_PRIM_SPRITE);
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

void CEventSprite::Init() {
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

void CEventSprite2::Initialize() {
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

int CEventSprite2::GetType() {
    return sprite_type;
}

void CEventSprite2::SetAlphaBlend(int alpha_blend) {
    this->alpha_blend = alpha_blend;
}

void CEventSprite2::SetRotZ(float rot_z) {
    this->rot_z = rot_z;
}

float CEventSprite2::GetRotZ() {
    return rot_z;
}

void CEventSprite2::NormalDraw() {
    if (draw_flag == EVENT_SPRITE2_DRAW_NORMAL) {
        this->Draw();
    }
}

void CEventSprite2::FirstDraw() {
    if (draw_flag == EVENT_SPRITE2_DRAW_FIRST) {
        this->Draw();
    }
}

void CEventSprite2::Draw() {
    mgCTextureManager *textures = &mgTexManager;
    textures->ReloadTexture(tex_block, (sceVif1Packet *) NULL);
    mgCTexture *texture;

    if (strcmp(tex_name, "") == 0) {
        texture = NULL;
    } else {
        texture = textures->GetTexture(tex_name, -1);
    }

    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_ALWAYS);

    if (texture != NULL) {
        prim.TextureMapEnable(1);
    } else {
        prim.TextureMapEnable(0);
    }

    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(alpha_blend);
    prim.AlphaTestEnable(0);
    prim.Bilinear(1);
    float width = put_w * scale_x;
    float height = put_h * scale_y;

    switch (sprite_type) {
        case 0:
            prim.Coord(0);
            width /= 2.0f;
            height /= 2.0f;

            if (rot_z != 0.0f) {
                float x0 = -width * cosf(rot_z) - -height * sinf(rot_z);
                float y0 = -width * sinf(rot_z) + -height * cosf(rot_z);
                float x1 = width * cosf(rot_z) - -height * sinf(rot_z);
                float y1 = width * sinf(rot_z) + -height * cosf(rot_z);
                float x2 = -width * cosf(rot_z) - height * sinf(rot_z);
                float y2 = -width * sinf(rot_z) + height * cosf(rot_z);
                float x3 = width * cosf(rot_z) - height * sinf(rot_z);
                float y3 = width * sinf(rot_z) + height * cosf(rot_z);
                prim.Begin(MG_PRIM_TRIANGLE_STRIP);

                if (texture != NULL) {
                    prim.Texture(texture);
                    prim.Color(color);
                    prim.TextureCrd(uv_x, uv_y);
                    prim.Vertex(pos[0] + x0, pos[1] + y0, 0.0f);
                    prim.TextureCrd(uv_x + uv_w, uv_y);
                    prim.Vertex(pos[0] + x1, pos[1] + y1, 0.0f);
                    prim.TextureCrd(uv_x, uv_y + uv_h);
                    prim.Vertex(pos[0] + x2, pos[1] + y2, 0.0f);
                    prim.TextureCrd(uv_x + uv_w, uv_y + uv_h);
                    prim.Vertex(pos[0] + x3, pos[1] + y3, 0.0f);
                } else {
                    prim.Color(color);
                    prim.Vertex(pos[0] + x0, pos[1] + y0, 0.0f);
                    prim.Vertex(pos[0] + x1, pos[1] + y1, 0.0f);
                    prim.Vertex(pos[0] + x2, pos[1] + y2, 0.0f);
                    prim.Vertex(pos[0] + x3, pos[1] + y3, 0.0f);
                }

                prim.End();
            } else {
                prim.Begin(MG_PRIM_SPRITE);

                if (texture != NULL) {
                    prim.Texture(texture);
                    prim.Color(color);
                    prim.TextureCrd(uv_x, uv_y);
                    prim.Vertex(pos[0] - width, pos[1] - height, 0.0f);
                    prim.TextureCrd(uv_x + uv_w, uv_y + uv_h);
                    prim.Vertex(pos[0] + width, pos[1] + height, 0.0f);
                } else {
                    prim.Color(color);
                    prim.Vertex(pos[0] - width, pos[1] - height, 0.0f);
                    prim.Vertex(pos[0] + width, pos[1] + height, 0.0f);
                }
            }

            prim.End();
            break;
        case 1:
            prim.DepthTestEnable(1);
            prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
            prim.ZMask(MG_Z_MASK_MASKED);
            prim.Bilinear(0);
            prim.Coord(1);
            pos[3] = 1.0f;
            int top_left[4];
            int bottom_right[4];

            if (mgTransWorldPrim3DSprite(top_left, bottom_right, pos, width, height, 0)) {
                prim.Begin(MG_PRIM_SPRITE);

                if (texture != NULL) {
                    prim.Texture(texture);
                    prim.Color(color);
                    prim.TextureCrd(uv_x, uv_y);
                    prim.Vertex4(top_left);
                    prim.TextureCrd(uv_x + uv_w, uv_y + uv_h);
                    prim.Vertex4(bottom_right);
                } else {
                    prim.Color(color);
                    prim.Vertex4(top_left);
                    prim.Vertex4(bottom_right);
                }

                prim.End();
            }

            break;
        default:
            draw_flag = 0;
            break;
    }
}
