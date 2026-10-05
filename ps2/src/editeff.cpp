#include "common.h"
#include <cmath>
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mapparts.hpp"
#include "editeff.hpp"
#include "editparts.hpp"
#include "mg_drawenv.hpp"
#include "mglib.hpp"

extern void *__vt__9mgCObject[];
extern void *__vt__7CObject[];
extern void *__vt__9CMapParts[];
extern void *__vt__14CFuncPointMngr[];
extern "C" void *__ct__8mgCFrameFv(void *);

static const float paint_color_max = 255.0f;
const int color_channels = 3;
const int star_particle_max = 0x40;
const int paint_effects_size = 0x400;
const int parts_buffer_size = 0x5DC;
const int effect_idle = 0;
const int effect_started = 1;
const int effect_falling = 2;
const int effect_finished = 3;
const int star_effect_count = 3;
const int paint_effect_count = 1;
const int paint_particle_count = 24;
const int place_anime_count = 3;

extern char at_821__5[];
extern sceVu0FVECTOR at_1112__3;

extern u32 EffectFlag;
extern u32 EffectState;
extern CPaintEffect *PaintEffect;
extern CStarEffect _StarEffect[star_effect_count];
extern mgCMemory CurPartsBuff;
extern mgCTextureManager mgTexManager;
extern CPlaceAnime PlaceAnime[place_anime_count];

// Code (.text)
void EditSetEffectBuffer(mgCMemory *memory) {
    mgCTexture *texture = mgTexManager.GetTexture(at_821__5, -1);
    int i;
    int offset;

    for (i = 0, offset = 0; i < star_effect_count; offset += sizeof(CStarEffect), i++) {
        CStarEffect *star = (CStarEffect *)((u8 *)_StarEffect + offset);
        u32 bytes;
        int *count;
        u32 blocks;
        star->CObject::Initialize();
        star->particle_max = star_particle_max;
        star->particle_num = 0;
        bytes = star->particle_max << 5;
        count = &star->particle_max;
        if (bytes & 0xF) {
            blocks = (bytes >> 4) + 1;
        } else {
            blocks = bytes >> 4;
        }
        star->particle = (EditStarParticle *)operator new[](
            *count << 5, (u_long128 *)memory->Alloc(blocks + 2));
        star->texture = texture;
    }
    PaintEffect = new ((u_long128 *)memory->Alloc(0x42)) CPaintEffect[1];
    CurPartsBuff.stSetBuffer((u_long128 *)memory->Alloc(parts_buffer_size),
                             parts_buffer_size);
}
CPaintEffect::CPaintEffect() {}
void EditInitPlaceEffect(void) {
    int i;
    CPaintEffect *paint;

    for (i = 0; i < star_effect_count; i++) {
        _StarEffect[i].state = effect_idle;
    }
    EffectFlag = 0;
    EffectState = 0;
    paint = PaintEffect;
    if (paint != NULL) {
        paint->state = effect_idle;
        paint->shape = 0;
    }
}
int EditPlaceEffect(CEditParts *parts, float *position) {
    CStarEffect *effect = NULL;
    int oldest_frame = 0;
    int index = 0;
    int byte_offset = 0;
    for (; index < star_effect_count; ++index, byte_offset += sizeof(CStarEffect)) {
        CStarEffect *candidate = (CStarEffect *)((u8 *)_StarEffect + byte_offset);
        if (candidate->state == effect_idle) {
            effect = &_StarEffect[index];
            break;
        }
        if (candidate->frame > oldest_frame) {
            oldest_frame = candidate->frame;
            effect = candidate;
        }
    }
    if (effect == NULL) {
        return 0;
    }
    EffectFlag = 1;
    mgVu0FBOX bounds;
    float spread[4];
    if (parts == NULL || !parts->GetBBox(&bounds)) {
        return 0;
    }
    sceVu0SubVector(spread, bounds.max, bounds.min);
    spread[0] = 0.5f * spread[0];
    for (int axis = 1; axis < 3; ++axis) {
        spread[axis] = 0.5f * spread[axis];
    }
    float radius = mgDistVectorXZ(spread);
    if (!(radius <= 300.0f)) {
        radius = 300.0f;
    }
    int particle_count = 10;
    particle_count += radius / (300.0f / 54.0f);
    spread[0] = radius;
    spread[2] = radius;
    effect->ParamInit(spread, particle_count);
    effect->SetPosition(position);
    effect->size = 1.0f + radius / 300.0f;
    return 1;
}
int EditPaintEffect(CEditParts *parts, float *position, float *color, int shape) {
    CPaintEffect *paint;
    CPaintEffect *candidate;
    mgCTexture *texture;
    float size;
    int i;
    int j;

    if (PaintEffect == NULL) {
        return 0;
    }
    paint = NULL;
    for (i = 0; i < paint_effect_count; i++) {
        if (PaintEffect[i].state == effect_idle) {
            paint = &PaintEffect[i];
        }
    }
    if (paint == NULL) {
        return 0;
    }
    texture = mgTexManager.GetTexture(at_821__5, -1);
    size = 1.0f;
    if (shape != 0) {
        size = 2.0f;
    }
    EffectFlag = 1;
    paint->ParamInit(size);
    paint->SetPosition(position);
    *(u_long128 *)paint->color = *(u_long128 *)color;
    sceVu0ScaleVector(paint->color, paint->color, 1.2f);
    for (j = 0; j < color_channels; j++) {
        if (!(paint->color[j] <= paint_color_max)) {
            paint->color[j] = paint_color_max;
        }
    }
    if (shape != 0) {
        paint->shape = 1;
        paint->wait = 0;
    }
    paint->texture = texture;
    return 1;
}
void EditPEffectStep(void) {
    int i;
    int j;

    if (EffectFlag != 0) {
        for (i = 0; i < star_effect_count; i++) {
            _StarEffect[i].Step();
        }

        for (j = 0; j < paint_effect_count; j++) {
            PaintEffect[j].Step();
        }
    }
}
void EditPEffectDraw(int unused) {
    int i;
    int j;

    if (EffectFlag == 0) {
        return;
    }
    for (i = 0; i < star_effect_count; i++) {
        _StarEffect[i].Draw();
    }
    for (j = 0; j < paint_effect_count; j++) {

        PaintEffect[j].Draw();
    }
}
int EditGetPEffectState(void) {
    int result = effect_idle;
    int i;
    for (i = 0; i < star_effect_count; i++) {
        int state = _StarEffect[i].state;
        if (state != effect_idle) {
            if (state != effect_finished) {
                return 1;
            }
            result = effect_finished;
        }
    }
    return result;
}
int EditPEffectEndCheck(void) {
    if (EditGetPEffectState() == 3) {
        EditInitPlaceEffect();
        return 3;
    }
    return (EditGetPEffectState() == 0) ^ 1;
}
void CStarEffect::ParamInit(float *spread, int count) {
    int i;
    float radius;
    float theta;
    sceVu0FVECTOR p;
    u_long128 q;

    sceVu0ScaleVector(spread, spread, 0.12f);
    state = effect_started;
    for (i = 0; i < particle_max; i++) {
        radius = 0.5f * spread[0] * (1.0f + mgRnd());
        theta = 6.2831855f * mgRnd();
        p[0] = radius * sinf(theta);
        p[1] = spread[1] * mgRnd();
        p[2] = radius * cosf(theta);
        p[3] = 1.0f;

        q = *(volatile u_long128 *)&p;
        *(u_long128 *)particle[i].position = q;
        particle[i].shape = i % 2;
    }
    scale[0] = scale[1] = scale[2] = 1.0f;
    mgZeroVector(rotation);
    position[1] = 0.0f;
    spin_speed = 0.0f;
    rise_speed = 0.0f;
    frame = 0;
    alpha = 1.0f;
    star_angle = 0.0f;
    particle_num = count;
    if (particle_num >= particle_max) {
        particle_num = particle_max;
    }
    size = 1.0f;
}
void CStarEffect::Step() {
    float current;
    float next;

    if (state != effect_idle) {
        current = scale[0];
        next = current + (10.0f - current) / 9.0f;
        scale[2] = next;
        scale[1] = next;
        scale[0] = next;
        if (frame > 10) {
            if (frame < 30) {
                spin_speed += 0.008f;
                rise_speed += 0.21f;
            }
            alpha -= 0.05f;
            if (alpha < 0.0f) {
                alpha = 0.0f;
                state = effect_finished;
            }
        }
        rotation[1] = mgAngleLimit(rotation[1] + spin_speed);
        star_angle += mgAngleLimit(0.2f + rotation[1]);
        position[1] += rise_speed;
        frame += 1;
    }
}
int CStarEffect::Draw() {
    if (state == effect_idle || state == effect_finished) {
        return 0;
    }
    sprite.Initialize();
    mgC3DSprite *billboard = &sprite;
    mgCDrawEnv draw_env = *mgGetpDrawEnv(0);
    sceGsTest *test = &draw_env.test;
    test->bits.zte = 1;
    test->bits.ztst = 2;
    draw_env.SetZBuf(MG_ZBUF_NO_WRITE);
    draw_env.SetAlpha(MG_ALPHA_MACRO_ADD);
    billboard->BeginCreatePacket(MG_3DSPRITE_MODE_ROTATE, NULL);
    billboard->CPSetDrawEnv(&draw_env);
    billboard->CPSetTexture(texture);
    billboard->BeginCPSprite();
    float star_size[2][4] = {{0.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 0.0f}};
    star_size[0][0] = 25.0f * size;
    star_size[0][1] = 25.0f * size;
    star_size[0][2] = star_angle;
    star_size[1][0] = 15.0f * size;
    star_size[1][1] = 15.0f * size;
    star_size[1][2] = 0.5f * star_angle;
    float uv_start[2][4] = {{0.0f, 0.0f, 0.0f, 0.0f}, {32.0f, 5.0f, 0.0f, 0.0f}};
    float uv_end[2][4] = {{32.0f, 31.0f, 0.0f, 0.0f}, {48.0f, 15.0f, 0.0f, 0.0f}};
    float star_color[4] = {128.0f, 128.0f, 128.0f, 0.0f};
    star_color[3] = 128.0f * alpha;
    for (int index = 0; index < particle_num; ++index) {
        EditStarParticle *star = &particle[index];
        float star_position[4];
        sceVu0MulVector(star_position, star->position, scale);
        star_position[3] = 1.0f;
        billboard->CPSetSprite(star_position, star_size[star->shape], star_color,
                               uv_start[star->shape], uv_end[star->shape]);
    }
    billboard->EndCPSprite();
    billboard->EndCreatePacket();
    float matrix[4][4];
    mgCreateMatrixPY(matrix, position, rotation[1]);
    int fog_enabled = mgGetFogEnable();
    mgFogEnable(0);
    int result = mgDrawDirect(billboard, matrix);
    mgFogEnable(fog_enabled);
    return result;
}
void CPaintEffect::ParamInit(float size) {
    int i;

    state = effect_started;
    for (i = 0; i < paint_particle_count; i++) {
        mgZeroVector(drop[i]);
        drop[i][3] = size * (0.5f + 0.5f * mgRnd());
        drop[i][1] = 10.0f;
        drop_speed[i][0] = 8.0f * (mgRnd() - 0.5f);
        drop_speed[i][1] = 2.0f;
        drop_speed[i][2] = 8.0f * (mgRnd() - 0.5f);
        drop_speed[i][3] = 0.0f;
    }
    alpha = 1.0f;
    wait = 10;
}
void CPaintEffect::Step() {
    int i;

    if (state == effect_idle || state == effect_finished) {
        return;
    }
    wait--;
    if (wait > 0) {
        return;
    }
    state = effect_falling;
    for (i = 0; i < paint_particle_count; i++) {
        drop_speed[i][1] -= 0.3f;
        mgAddVector(drop[i], drop_speed[i]);
    }
    alpha -= 0.05f;
    if (alpha < 0.0f) {
        state = effect_idle;
    }
}
int CPaintEffect::Draw() {
    if (state == effect_idle || state == effect_finished || state == effect_started) {
        return 0;
    }
    sprite.Initialize();
    mgC3DSprite *billboard = &sprite;
    mgCDrawEnv draw_env = *mgGetpDrawEnv(0);
    sceGsTest *test = &draw_env.test;
    test->bits.zte = 1;
    test->bits.ztst = 2;
    draw_env.SetZBuf(MG_ZBUF_NO_WRITE);
    draw_env.SetAlpha(MG_ALPHA_MACRO_BLEND);
    billboard->BeginCreatePacket(MG_3DSPRITE_MODE_UPRIGHT, NULL);
    billboard->CPSetDrawEnv(&draw_env);
    billboard->CPSetTexture(texture);
    billboard->BeginCPSprite();
    float uv_start[2][4] = {{0.0f, 32.0f, 0.0f, 0.0f}, {32.0f, 32.0f, 0.0f, 0.0f}};
    float uv_end[2][4] = {{32.0f, 63.0f, 0.0f, 0.0f}, {63.0f, 63.0f, 0.0f, 0.0f}};
    float drop_color[4];
    *(u_long128 *)drop_color = *(u_long128 *)color;
    drop_color[3] = 128.0f * alpha;
    for (int index = 0; index < paint_particle_count; ++index) {
        float drop_position[4];
        float drop_size[4];
        float drop_scale = drop[index][3];
        *(u_long128 *)drop_position = *(u_long128 *)drop[index];
        drop_position[3] = 1.0f;
        *(u_long128 *)drop_size = *(u_long128 *)at_1112__3;
        drop_size[0] = 10.0f * drop_scale;
        drop_size[1] = drop_size[0];
        billboard->CPSetSprite(drop_position, drop_size, drop_color, uv_start[shape], uv_end[shape]);
    }
    billboard->EndCPSprite();
    billboard->EndCreatePacket();
    float matrix[4][4];
    mgCreateMatrixPY(matrix, position, rotation[1]);
    int fog_enabled = mgGetFogEnable();
    mgFogEnable(0);
    int result = mgDrawDirect(billboard, matrix);
    mgFogEnable(fog_enabled);
    return result;
}
void EditInitPlaceAnime(void) {
    int i;

    for (i = 0; i < place_anime_count; i++) {
        PlaceAnime[i].state = effect_idle;
        PlaceAnime[i].type = 0;
        PlaceAnime[i].parts = NULL;
    }
}
int EditNowPlaceAnime(void) {
    int i;
    for (i = 0; i < place_anime_count; i++) {
        int state = PlaceAnime[i].state;
        if (state != effect_finished && state != effect_idle) {
            return 1;
        }
    }
    return 0;
}
int EditSetPlaceAnime(int kind, CMapParts *parts) {
    CPlaceAnime *slot;
    CMapParts *target;
    int oldest;
    int i;
    int offset;
    CPlaceAnime *candidate;
    if (parts == NULL || kind == 0) {
        return 0;
    }
    slot = NULL;
    target = (CMapParts *)parts;
    if (kind == 3) {
        for (i = 0, offset = 0; i < place_anime_count; i++, offset += sizeof(CPlaceAnime)) {
            candidate = (CPlaceAnime *)((u8 *)PlaceAnime + offset);
            if (candidate->state == effect_idle) {
                slot = candidate;
                if (candidate->type == 3) {
                    break;
                }
            }
        }
        if (slot != NULL) {
            slot->state = 0;
            slot->type = 0;
            slot->parts = NULL;
            CurPartsBuff.stack_used = 0;
            CurPartsBuff.lock = 0;
            if ((target = (CMapParts *)operator new(sizeof(CMapParts), (u_long128 *)CurPartsBuff.Alloc(0x33))) != NULL) {
                *(void **)target = __vt__9mgCObject;
                ((mgCObject *)target)->Initialize();
                *(void **)target = __vt__7CObject;
                ((mgCObject *)target)->Initialize();
                *(void **)target = __vt__9CMapParts;
                __ct__8mgCFrameFv(&target->frame);
                *(void **)((u8 *)&target->func_point_mngr + 0x30) = __vt__14CFuncPointMngr;
                target->func_point_mngr.Initialize();
                *(int *)&target->func_check.time = 0;
                ((mgCObject *)target)->Initialize();
            }
            if (target == NULL) {
                return 0;
            }
            parts->Copy(*target, &CurPartsBuff);
        }
    } else {
        oldest = 0;
        for (i = 0, offset = 0; i < place_anime_count; i++, offset += sizeof(CPlaceAnime)) {
            candidate = (CPlaceAnime *)((u8 *)PlaceAnime + offset);
            if (candidate->state == effect_idle) {
                slot = &PlaceAnime[i];
                break;
            }
            if (oldest < candidate->frame) {
                oldest = candidate->frame;
                slot = candidate;
            }
        }
    }
    if (slot == NULL) {
        return 0;
    }
    slot->state = 1;
    slot->type = kind;
    slot->parts = (CMapParts *)target;
    slot->parts->GetPosition(slot->position);
    slot->parts->GetRotation(slot->rotation);
    slot->parts->GetScale(slot->scale);
    slot->frame = 0;
    slot->power = 1.0f;
    slot->height_speed = 6.0f;
    slot->height = 0.0f;
    slot->phase = 0;
    return 1;
}
void EditPlaceAnime(void) {
    int i;

    for (i = 0; i < place_anime_count; i++) {
        PlaceAnime[i].Step();
    }
}
void EditPlaceAnime2(void) {
    int i;

    for (i = 0; i < place_anime_count; i++) {
        PlaceAnime[i].Step2();
    }
}
void EditPlaceAnimeDraw(void) {
    int i;

    for (i = 0; i < place_anime_count; i++) {
        PlaceAnime[i].Draw();
    }
}
void CPlaceAnime::Step() {
    int finished;
    float squash;

    if (state == effect_idle || state == effect_finished) {
        return;
    }
    if (parts == NULL || type == 0) {
        return;
    }
    parts->GetPosition(base_position);
    parts->GetRotation(base_rotation);
    parts->GetScale(base_scale);
    finished = 0;
    if (type == 1) {
        height_speed = height_speed - 1.2f;
        height += height_speed;
        if (height < 0.0f) {
            height = 0.0f;
            height_speed = 0.0f;
        }
        rotation[0] = 0.4f * power * sinf(6.2831855f * ((float)frame / 30.0f));
        rotation[2] =
            0.4f * power * cosf(6.2831855f * ((float)frame / 30.0f) + 1.5707964f * power);
        frame++;
        power = 0.92f * power;
        if (frame > 60) {
            finished = 1;
        }
    } else if (type == 2) {
        switch (phase) {
            case 0:
                height_speed = height_speed - 1.2f;
                height += height_speed;
                if (height < 0.0f) {
                    height = 0.0f;
                    phase++;

                    case 1:
                        height = 0.0f;
                        squash = 1.0f + 0.2f * power * sinf(6.2831855f * ((float)frame / 30.0f));
                        scale[2] = squash;
                        scale[0] = squash;
                        scale[1] = 2.0f - squash;
                        frame++;
                        power = 0.97f * power;
                        if (frame > 15) {
                            finished = 1;
                        }
                }
                break;
        }
    } else if (type == 3) {
        height += 20.0f;
        scale[0] -= 0.1f;
        scale[2] -= 0.1f;
        if (scale[0] < 0.0f) {
            scale[0] = 0.0f;
        }
        if (scale[2] < 0.0f) {
            scale[2] = 0.0f;
        }
        frame++;
        if (frame > 10) {
            finished = 1;
        }
    } else {
        finished = 1;
    }
    if (finished != 0) {
        state = effect_idle;
        return;
    }
    position[1] = base_position[1] + height;
    parts->SetPosition(position);
    parts->SetRotation(rotation);
    parts->SetScale(scale);
}
void CPlaceAnime::Step2() {
    if (state == effect_idle || state == effect_finished) {
        return;
    }
    if (parts == NULL || type == 0) {
        return;
    }
    parts->SetPosition(base_position);
    parts->SetRotation(base_rotation);
    parts->SetScale(base_scale);
}
void CPlaceAnime::Draw() {
    if (state == effect_idle || state == effect_finished) {
        return;
    }
    if (parts == NULL || type != 3) {
        return;
    }
    parts->Draw();
}
int EditGetPlaceAnimeState(void) {
    int result = effect_idle;
    int i;
    for (i = 0; i < place_anime_count; i++) {
        int state = PlaceAnime[i].state;
        if (state != effect_idle) {
            if (state != effect_finished) {
                return 1;
            }
            result = effect_finished;
        }
    }
    return result;
}
int EditPlaceAnimeEndCheck(void) {
    if (EditGetPlaceAnimeState() == 3) {
        EditInitPlaceAnime();
        return 3;
    }
    return (EditGetPlaceAnimeState() == 0) ^ 1;
}
CStarEffect::CStarEffect() {}

// Static initialiser (.init)
extern "C" void *__construct_array(void *array, void *(*constructor)(void *),
                                  void *destructor, unsigned int element_size, unsigned int count);
extern "C" void *__ct__11CStarEffectFv(void *effect);
extern "C" void __sinit_editeff_cpp() {
    __construct_array(_StarEffect, __ct__11CStarEffectFv, NULL, sizeof(CStarEffect), star_effect_count);
    CurPartsBuff.Init();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", at_1038__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", at_1039__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", at_1040__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", at_1106__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", at_1107__4__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", at_821__5__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", D_0037B070__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", __vt__12CPaintEffect__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editeff", __vt__11CStarEffect__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(EffectFlag, 0x4);
INCLUDE_BSS(EffectState, 0x4);
INCLUDE_BSS(PaintEffect, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(_StarEffect, 0x300);
INCLUDE_BSS(CurPartsBuff, 0x30);
INCLUDE_BSS(at_1037__6, 0x20);
INCLUDE_BSS(at_1112__3, 0x10);
INCLUDE_BSS(PlaceAnime, 0x1B0);
