#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "dng_debug.hpp"
#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
#include "dng_status.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapload.hpp"
#include "menucommon.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "prespr.hpp"
#include "quest.hpp"
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_seseq.hpp"
#include "water.hpp"

static const char at_1107__2[] = "br = %.2f\n";
static int        chill_tex_rect_910[6][3] = {
    {0,  0,  32},
    {32, 0,  32},
    {0,  32, 32},
    {32, 32, 32},
    {64, 0,  64},
    {0,  64, 64},
};

// Code (.text)
/**
 *
 * Converts an effect strength byte to a float capped at one.
 *
 */
float trans_effect_rate(int rate) {
    float f = (float) rate / 255.0f;

    if (1.0f < f) {
        f = 1.0f;
    }

    return f;
}

/**
 *
 * Copies three vector components to or from a homogeneous SCE vector.
 *
 */
static void trans_float_to_sceVector(float *sce, float *vec, int to_vec) {
    if (to_vec == 0) {
        sce[0] = vec[0];
        sce[1] = vec[1];
        sce[2] = vec[2];
        sce[3] = 1.0f;
    } else {
        vec[0] = sce[0];
        vec[1] = sce[1];
        vec[2] = sce[2];
    }
}

void CChillAfterHit::Initialize() {
    active = 0;
    piece_num = 0;
    rate = 0;
    memset(piece, 0, sizeof(piece));
    mgZeroVector(center);
}

void CChillAfterHit::SetPos(float *pos, float size, int strength) {
    CHILL_AFTER_HIT_PIECE *p;
    int                    i;
    float                  speed_boost;
    float                  launch_speed;

    if (strength < 32) {
        return;
    }

    Initialize();
    active = 1;
    p = piece;
    rate = trans_effect_rate(strength);

    if (45.0f < size) {
        size = 45.0f;
    }

    piece_num = 24;

    if (rate <= 0.5f) {
        piece_num = fptosi(16.0f * (0.5f + rate)) + 8;
        launch_speed = 3.5f + 2.5f * rate;
        speed_boost = 4.4f * rate;
    } else {
        launch_speed = 4.5f + 3.0f * rate;
        speed_boost = 5.6f * rate;
    }

    if (piece_num > 24) {
        piece_num = 24;
    }

    *(u_long128 *) center = *(u_long128 *) pos;
    size = 8.0f + size / 13.5f + speed_boost;
    i = 0;

    do {
        p->velocity[0] = fRand(1.2f) - 0.6f;
        p->velocity[2] = fRand(1.2f) - 0.6f;
        p->velocity[1] = fRand(0.65f) - 0.15f;
        sceVu0ScaleVector(p->velocity, p->velocity, size);
        sceVu0AddVector(p->pos, pos, p->velocity);
        p->velocity[3] = 1.0f;
        p->damping = 0.76f * (0.85f + fRand(0.21f));
        p->size = launch_speed * (0.8f + fRand(0.3f * rate));
        p->alpha = iRand(60) + 72;
        p->fade_speed = iRand(8) + 9;
        p->rect = iRand(5);
        p->move_time = iRand(8) + 16;
        p->angle = fRand(6.2831855f) - 3.1415927f;
        p->spin = 3.1415927f / (9.0f + 2.0f * fRand(rate));

        if (iRand(10) % 2 != 0) {
            p->spin = -p->spin;
        }

        p->trail_num = -1;
        i++;
        p++;
    } while (i < 24);
}

void CChillAfterHit::Step() {
    int                    i;
    int                    any_alive;
    CHILL_AFTER_HIT_PIECE *p;

    if (active != 0) {
        any_alive = 0;
        p = piece;
        i = 0;

        while (i < piece_num) {
            if (p->alpha > 0) {
                sceVu0ScaleVector(p->velocity, p->velocity, p->damping);
                p->velocity[3] = 1.0f;

                if (mgDistVector(p->velocity) < 0.7f) {
                    mgZeroVector(p->velocity);
                    p->move_time = 0;
                }

                if (p->trail_num <= 0) {
                    p->trail_num += 1;
                }

                p->trail[1][0] = p->trail[0][0];
                p->trail[1][1] = p->trail[0][1];
                p->trail[1][2] = p->trail[0][2];
                p->trail[0][0] = p->pos[0];
                p->trail[0][1] = p->pos[1];
                p->trail[0][2] = p->pos[2];

                if (0 < p->move_time) {
                    sceVu0AddVector(p->pos, p->pos, p->velocity);
                    p->move_time -= 1;
                    p->angle = mgAngleLimit(p->angle + p->spin);
                    p->spin *= 0.6f;
                } else {
                    p->alpha -= p->fade_speed;
                    p->pos[1] = p->pos[1] - 0.2f;
                }

                p->pos[3] = 1.0f;

                if (0 < p->alpha) {
                    any_alive = 1;
                }
            }

            i++;
            p++;
        }

        if (any_alive == 0) {
            active = 0;
        }
    }
}

static inline void LocalPrimCorner(int *out, float *corner, float *center, float half_w, float half_h, float angle, float scale) {
    float shift_x;
    float reach_y;
    float reach_x;
    float shift_y;

    reach_x = scale;
    reach_y = scale;
    reach_x *= half_w;
    reach_y *= half_h;
    shift_x = reach_x * cosf(angle) - reach_y * sinf(angle);
    shift_y = reach_x * sinf(angle) + reach_y * cosf(angle);
    *(u_long128 *) corner = *(u_long128 *) center;
    corner[0] += shift_x;
    corner[1] += shift_y;
    out[0] = (int) (16.0f * corner[0]);
    out[1] = (int) (16.0f * corner[1]);
    out[2] = (int) corner[2];
    out[3] = 0;
}

int LocalTransWorldPrimPos(int (*corners)[4], float *pos, float width, float height, float angle) {
    float screen[4];
    float corner[4][4];
    float half_w = width * mgRenderInfo.view_screen[0][0];
    float half_h = height * mgRenderInfo.view_screen[1][1];

    sceVu0ApplyMatrix(screen, mgRenderInfo.world_screen, pos);

    if (screen[3] < 1.0f) {
        return 0;
    }

    float inv_w = 1.0f / screen[3];
    screen[0] *= inv_w;
    screen[1] *= inv_w;
    screen[2] *= inv_w;
    half_w *= inv_w;
    half_h *= inv_w;
    half_w *= 0.5f;
    half_h *= 0.5f;
    angle += 1.5707964f;
    LocalPrimCorner(corners[0], corner[0], screen, half_w, half_h, angle, 1.0f);
    angle = mgAngleLimit(angle - 1.5707964f);
    LocalPrimCorner(corners[1], corner[1], screen, half_w, half_h, angle, 1.0f);
    angle = mgAngleLimit(angle - 1.5707964f);
    LocalPrimCorner(corners[2], corner[2], screen, half_w, half_h, angle, 1.0f);
    float last = mgAngleLimit(angle - 1.5707964f);
    LocalPrimCorner(corners[3], corner[3], screen, half_w, half_h, last, 1.0f);

    if (corner[0][0] < 0.0f || !(corner[0][0] <= 4095.0f)) {
        return 0;
    }

    if (corner[0][1] < 0.0f || !(corner[0][1] <= 4095.0f)) {
        return 0;
    }

    return 1;
}

void CChillAfterHit::Draw() {
    float vec[4];
    int   sprite0[4];
    int   sprite1[4];

    if (TEX_ExFx_ICE != 0 && active != 0) {
        CPreSprite             prim;
        int                    quad[4][4];
        int                    trail_quad[4][4];
        int                    j;
        int                    i;
        CHILL_AFTER_HIT_PIECE *p;
        int                   *rect;
        int                    alpha;
        int                    trail_offset;
        float                  size;
        int                    side;
        prim.Initialize(0, 0);
        prim.Preset2D();
        prim.Coord(1);
        prim.DepthTestEnable(1);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.Bilinear(1);
        prim.TextureMapEnable(1);
        p = piece;
        prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
        i = 0;

        while (i < piece_num) {
            if (p->alpha > 0) {
                size = p->size;

                if (LocalTransWorldPrimPos(quad, p->pos, size, size, p->angle) != 0) {
                    prim.Begin(MG_PRIM_TRIANGLE_FAN);
                    prim.Texture(TEX_ExFx_ICE);
                    alpha = p->alpha;
                    j = 0;
                    trail_offset = 0;
                    rect = chill_tex_rect_910[p->rect];

                    while (j < p->trail_num) {

                        trans_float_to_sceVector(vec, (float *) ((u8 *) p + trail_offset + 0x38), 0);
                        size = p->size;
                        LocalTransWorldPrimPos(trail_quad, vec, size, size, p->angle);
                        prim.Color(0x80, 0x80, 0xB6, alpha);
                        prim.TextureCrd(rect[0], rect[1]);
                        prim.Vertex4(trail_quad[0]);
                        prim.TextureCrd(rect[0] + rect[2], rect[1]);
                        prim.Vertex4(trail_quad[1]);
                        side = rect[2];
                        side = rect[2];
                        prim.TextureCrd(rect[0] + side, rect[1] + side);
                        prim.Vertex4(trail_quad[2]);
                        prim.TextureCrd(rect[0], rect[1] + rect[2]);
                        prim.Vertex4(trail_quad[3]);
                        prim.Flush();
                        alpha = alpha >> 1;
                        trail_offset += 0xC;
                        j++;
                    }

                    prim.Color(0x80, 0x80, 0xB6, p->alpha);
                    prim.TextureCrd(rect[0], rect[1]);
                    prim.Vertex4(quad[0]);
                    prim.TextureCrd(rect[0] + rect[2], rect[1]);
                    prim.Vertex4(quad[1]);
                    side = rect[2];
                    prim.TextureCrd(rect[0] + side, rect[1] + side);
                    prim.Vertex4(quad[2]);
                    prim.TextureCrd(rect[0], rect[1] + rect[2]);
                    prim.Vertex4(quad[3]);
                    prim.End();
                    prim.Begin(MG_PRIM_SPRITE);
                    sceVu0ScaleVector(vec, p->velocity, 0.05f);
                    sceVu0SubVector(vec, p->pos, vec);
                    vec[3] = 1.0f;
                    size = 1.2f * p->size;
                    mgTransWorldPrim3DSprite(sprite0, sprite1, vec, size, size, 0);
                    prim.Color(0x80, 0x80, 0x94, p->alpha);
                    prim.TextureCrd(0x40, 0x40);
                    prim.Vertex4(sprite0);
                    prim.TextureCrd(0x80, 0x40);
                    prim.Vertex4(sprite1);
                    prim.End();
                }
            }

            i++;
            p++;
        }
    }
}

void CFireAfterHit::Initialize() {
    active = 0;
    flame_num = 0;
    time = 0;
    rate = 0.0f;
    memset(flame, 0, sizeof(flame));
    memset(trail, 0, sizeof(trail));
}

void CFireAfterHit::SetPos(float *pos, float size, int strength) {
    FIRE_AFTER_HIT_FLAME *e;
    FIRE_AFTER_HIT_TRAIL(*trails)
    [6];
    int i;
    int trail_offset;

    if (strength < 32) {
        return;
    }

    Initialize();
    rate = trans_effect_rate(strength);

    if (45.0f < size) {
        size = 45.0f;
    }

    flame_num = fptosi(4.0f + 10.0f * rate);

    if (flame_num > 14) {
        flame_num = 14;
    }

    e = flame;
    trails = trail;
    size = 8.0f + size / 14.0f;
    active = 1;
    i = 0;
    trail_offset = 0;

    while (i < flame_num) {
        e->velocity[0] = fRand(1.0f) - 0.5f;
        e->velocity[2] = fRand(1.0f) - 0.5f;
        e->velocity[1] = 0.3f + fRand(0.3f);
        e->size = 1.0f;
        sceVu0ScaleVector(e->velocity, e->velocity, size);
        sceVu0AddVector(e->pos, pos, e->velocity);
        e->size = 7.5f * (0.8f + fRand(rate));
        e->alpha = iRand(40) + 97;
        e->age = fptosi((1.3f - rate) * fRand(4.0f));

        trans_float_to_sceVector(e->pos, (float *) ((u8 *) trails + trail_offset), 1);
        e->trail_head += 1;
        e->fade_speed = iRand(10) + 4;
        e->delay = iRand(3);
        trail_offset += 0x78;
        i++;
        e++;
    }
}

void CFireAfterHit::Step() {
    int                   i;
    int                   j;
    int                   any_alive;
    FIRE_AFTER_HIT_FLAME *e;
    FIRE_AFTER_HIT_TRAIL *row;
    int                   trail_offset;
    int                   spawned;

    if (active != 0) {
        any_alive = 0;
        e = flame;
        i = 0;
        trail_offset = 0;

        while (i < flame_num) {
            if (0 < e->delay) {
                e->delay -= 1;
            } else {

                row = (FIRE_AFTER_HIT_TRAIL *) ((u8 *) this + trail_offset + 0x2B0);
                spawned = 0;
                j = 0;

                do {
                    if (j == e->trail_head && spawned == 0 && e->age < 13) {
                        trans_float_to_sceVector(e->pos, row->pos, 1);
                        row->alpha = fptosi(0.5f * (128.0f - (float) e->alpha)) + 32;

                        if (row->alpha < 32) {
                            row->alpha = 32;
                        }

                        if (row->alpha >= 128) {
                            row->alpha = 128;
                        }

                        row->size = 1.35f * e->size;
                        e->trail_head += 1;
                        spawned = 1;

                        if (e->trail_head >= 6) {
                            e->trail_head = 0;
                        }
                    } else {
                        row->size += 0.2f;
                        row->alpha -= 3;

                        if (row->alpha <= 0) {
                            row->alpha = 0;
                        }
                    }

                    if (0 < row->alpha) {
                        any_alive = 1;
                    }

                    j++;
                    row++;
                } while (j < 6);

                if (0 < e->alpha) {
                    any_alive = 1;
                    e->alpha -= e->fade_speed;
                }

                e->velocity[0] *= 0.94f;
                e->velocity[2] *= 0.94f;
                e->velocity[1] -= 0.5f;

                if (e->velocity[1] < -4.5f) {
                    e->velocity[1] = -4.5f;
                }

                e->size *= 0.94f;
                sceVu0AddVector(e->pos, e->pos, e->velocity);
                e->pos[3] = 1.0f;
                e->age += 1;
            }

            trail_offset += 0x78;
            i++;
            e++;
        }

        time += 1;

        if (any_alive == 0) {
            active = 0;
        }
    }
}

static int gb_tbl_1052[3] = {86, 48, 32};

void CFireAfterHit::Draw() {
    float                 vec[4];
    int                   i;
    int                   middle;
    int                   tail_alpha;
    int                   k;
    int                   newest;
    int                   puff0[4];
    int                   oldest;
    int                   puff1[4];
    int                   main0[4];
    int                   main1[4];
    FIRE_AFTER_HIT_FLAME *fire;

    if (active == 0) {
        return;
    }

    if (TEX_ExFx_FIRE == NULL) {
        return;
    }

    FIRE_AFTER_HIT_TRAIL *puff = &trail[0][0];
    CPreSprite            prim;
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_SUB);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(TEX_ExFx_FIRE);
    int puff_num = flame_num * FIRE_AFTER_HIT_TRAIL_MAX;

    for (i = 0; i < puff_num; i++) {
        if (puff->alpha > 0) {
            trans_float_to_sceVector(vec, puff->pos, 0);
            mgTransWorldPrim3DSprite(puff0, puff1, vec, puff->size, puff->size, 0);
            prim.Color(0x80, 0x80, 0x80, puff->alpha);
            prim.TextureCrd(0x40, 0x40);
            prim.Vertex4(puff0);
            prim.TextureCrd(0x80, 0x80);
            prim.Vertex4(puff1);
        }

        puff++;
    }

    prim.End();
    fire = flame;
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(TEX_ExFx_FIRE);

    for (i = 0; i < flame_num; i++, fire++) {
        if (fire->alpha > 0 && !(0 < fire->delay)) {
            if (mgTransWorldPrim3DSprite(main0, main1, fire->pos, fire->size, fire->size, 0) != 0) {
                if (fire->age >= 3) {
                    puff = trail[i];
                    oldest = fire->trail_head - 3;
                    middle = fire->trail_head - 2;
                    newest = fire->trail_head - 1;

                    if (oldest < 0) {
                        oldest += FIRE_AFTER_HIT_TRAIL_MAX;
                    }

                    if (middle < 0) {
                        middle += FIRE_AFTER_HIT_TRAIL_MAX;
                    }

                    if (newest < 0) {
                        newest += FIRE_AFTER_HIT_TRAIL_MAX;
                    }

                    FIRE_AFTER_HIT_TRAIL *recent[3] = {&puff[oldest], &puff[middle], &puff[newest]};

                    for (k = 0; k < 3; k++) {
                        trans_float_to_sceVector(vec, recent[k]->pos, 0);
                        mgTransWorldPrim3DSprite(puff0, puff1, vec, recent[k]->size, recent[k]->size, 0);
                        prim.Color(0x80, gb_tbl_1052[k], gb_tbl_1052[k], fire->alpha);
                        prim.TextureCrd(0x40, 0);
                        prim.Vertex4(puff0);
                        prim.TextureCrd(0x80, 0x40);
                        prim.Vertex4(puff1);
                    }
                }

                prim.Color(0x80, 0x80, 0x80, fire->alpha);
                prim.TextureCrd(0, 0);
                prim.Vertex4(main0);
                prim.TextureCrd(0x40, 0x40);
                prim.Vertex4(main1);
                sceVu0ScaleVector(vec, fire->velocity, 0.05f);
                sceVu0SubVector(vec, fire->pos, vec);
                vec[3] = 1.0f;
                mgTransWorldPrim3DSprite(puff0, puff1, vec, 1.75f * fire->size, 1.75f * fire->size, 0);
                tail_alpha = fire->alpha * 2;

                if (tail_alpha > 0xFF) {
                    tail_alpha = 0xFF;
                }

                prim.Color(0x80, 0x80, 0x80, tail_alpha);
                prim.TextureCrd(0x40, 0);
                prim.Vertex4(puff0);
                prim.TextureCrd(0x80, 0x40);
                prim.Vertex4(puff1);
            }
        }
    }

    prim.End();
}

void CTornado::SetPos(float *pos, float size, float strength) {
    TORNADO_PIECE *p;
    int            i;

    if (strength < 32.0f) {
        return;
    }

    active = 1;
    live_num = 18;
    pos[3] = 1.0f;
    sceVu0CopyVector(center, pos);
    rate = strength / 255.0f;
    live_num = fptosi(14.0f * rate) + 4;
    printf(at_1107__2, (double) rate);
    p = piece;

    for (i = 0; i < 18; i++) {
        p[i].life = 0;
    }

    for (i = 0; i < live_num; i++) {
        sceVu0CopyVector(p->pos, center);
        p->pos[1] += fRand(0.5f * size);
        p->life = iRand(15) + 15;
        p->angle = fRand(6.2831855f) - 3.1415927f;
        p->alpha = 1.0f;
        p->scale = 0.1f * size;
        p->rise = 0.05f * size;
        p++;
    }
}

void CTornado::Draw() {
    TORNADO_PIECE *p;
    int            i;

    if (active != 0 && model != 0) {
        mgCFrameAttr attr;

        attr.no_light = 1;
        attr.z_write = -1;
        attr.alpha_blend = 2;
        p = piece;

        for (i = 0; i < 18; i++) {
            if (p->life <= 0) {
                p++;
                continue;
            }

            model->SetPosition(p->pos);
            float size = p->scale;
            ((mgCFrame *) model)->SetScale(size, 0.25f + 4.0f * rate, size);
            model->SetRotation(0.0f, p->angle, 0.0f);
            attr.color[0] = 180.0f;
            attr.color[1] = 180.0f;
            attr.color[2] = 180.0f;
            attr.color[3] = 250.0f * p->alpha;
            model->SetAttrParam(attr, 1, MG_FRAME_ATTR_COLOR);
            mgDrawDirect(model);
            p++;
        }
    }
}

void CTornado::Step() {
    TORNADO_PIECE *p;
    int            i;

    if (active != 0) {
        p = piece;

        for (i = 0; i < 18; i++) {
            if (p->life <= 0) {
                p++;
                continue;
            }

            p->pos[1] += p->rise;
            p->angle += 0.19634955f;
            p->angle = mgAngleLimit(p->angle);

            if (p->life < 10) {
                p->scale += 0.2f;
                p->alpha = p->alpha - 0.1f;

                if (p->alpha <= 0.0f) {
                    p->alpha = 0.0f;
                }
            }

            p->life = p->life - 1;

            if (p->life <= 0) {
                live_num -= 1;
            }

            p++;
        }

        if (live_num <= 0) {
            active = 0;
        }
    }
}

void CTornado::Initialize() {
    TORNADO_PIECE *p;
    int            i;
    active = 0;
    live_num = 0;
    p = piece;

    for (i = 0; i < 18; i++) {
        p->life = 0;
        p++;
    }
}

void CThunder::SetPos(float *pos, float width, float power) {
    if (power < 32.0f) {
        return;
    }

    active = 1;
    live_num = THUNDER_SPARK_MAX;
    float span = 2.0f * width;
    frame.SetPosition(pos);
    rate = power / 255.0f;
    live_num = fptosi(32.0f * rate) + 8;
    THUNDER_SPARK *bolt = spark;

    for (int i = 0; i < THUNDER_SPARK_MAX; i += 8) {
        bolt->life = 0.0f;
        bolt->life = 0.0f;
        bolt->life = 0.0f;
        bolt->life = 0.0f;
        bolt->life = 0.0f;
        bolt->life = 0.0f;
        bolt->life = 0.0f;
        bolt->life = 0.0f;
    }

    for (int i = 0; i < live_num; i++) {
        bolt->pos[0] = fRand(span) - span / 2.0f;
        bolt->pos[1] = fRand(span / 3.0f);
        bolt->pos[2] = fRand(span) - span / 2.0f;
        bolt->pos[3] = 1.0f;
        bolt->velocity[0] = fRand(1.0f) - 0.5f;
        bolt->velocity[1] = fRand(1.0f) - 0.5f;
        bolt->velocity[2] = fRand(1.0f) - 0.5f;
        bolt->velocity[3] = 0.0f;
        bolt->life = (float) (iRand(5) + 20);
        bolt->spin = fRand(0.3926991f);
        bolt->angle = fRand(3.1415927f);
        bolt->frame = iRand(6);
        bolt->scale = 1.0f;
        bolt++;
    }
}

static float thn_tbl[6][4] = {
    {4.0f, 3.0f, 0.0f, 0.0f},
    {4.0f, 3.0f, 0.0f, 0.0f},
    {4.0f, 3.0f, 0.0f, 0.0f},
    {3.0f, 2.0f, 0.0f, 0.0f},
    {3.0f, 2.0f, 0.0f, 0.0f},
    {4.5f, 3.5f, 0.0f, 0.0f},
};
static float thn_uv[6][4] = {
    {0.0f,  0.0f,  32.0f, 32.0f},
    {32.0f, 0.0f,  32.0f, 32.0f},
    {0.0f,  32.0f, 32.0f, 32.0f},
    {32.0f, 32.0f, 32.0f, 32.0f},
    {0.0f,  64.0f, 32.0f, 32.0f},
    {0.0f,  96.0f, 64.0f, 32.0f},
};

static inline void ClearSprite(mgC3DSprite *sprite) {
    sprite->packet = 0;
    sprite->unk_00 = 0;
    sprite->draw_env = 0;
    sprite->texture_manager = 0;
    sprite->vu1_offset = 0;
    sprite->vu1_base = 0;
}

void CThunder::Draw() {
    if (active == 0) {
        return;
    }

    if (live_num <= 0) {
        return;
    }

    mgC3DSprite  sprite;
    mgC3DSprite *packet = &sprite;
    ClearSprite(&sprite);
    mgCDrawEnv env = *mgGetpDrawEnv(0);
    sceGsTest *test = &env.test;
    test->bits.zte = 1;
    test->bits.ztst = 2;
    env.SetZBuf(MG_ZBUF_NO_WRITE);
    env.SetAlpha(MG_ALPHA_MACRO_ADD);
    packet->BeginCreatePacket(1, NULL);
    packet->CPSetDrawEnv(&env);
    packet->CPSetTexture(TEX_ExFx_THUN);
    THUNDER_SPARK *bolt = spark;

    for (int i = 0; i < THUNDER_SPARK_MAX; i++) {
        if (bolt->life <= 0.0f) {
            bolt++;
            continue;
        }

        float size[4];
        size[0] = (0.2f + 0.8f * rate) * (bolt->scale * (4.0f * thn_tbl[bolt->frame][0]));
        size[1] = (0.2f + 0.8f * rate) * (bolt->scale * (4.0f * thn_tbl[bolt->frame][1]));
        float *angle = &size[2];
        *angle = bolt->angle;
        *angle = mgAngleLimit(*angle);
        float uv0[4] = {0.0f, 0.0f, 0.0f, 0.0f};
        float uv1[4] = {32.0f, 32.0f, 0.0f, 0.0f};
        uv0[0] = thn_uv[bolt->frame][0];
        uv0[1] = thn_uv[bolt->frame][1];
        uv1[0] = uv0[0] + thn_uv[bolt->frame][2];
        uv1[1] = uv0[1] + thn_uv[bolt->frame][3];
        float color[4] = {128.0f, 128.0f, 128.0f, 96.0f};
        packet->BeginCPSprite();
        packet->CPSetSprite(bolt->pos, size, color, uv0, uv1);
        packet->EndCPSprite();
        bolt++;
    }

    packet->EndCreatePacket();

    if (live_num > 0) {
        mgCFrame *frame_ptr = &frame;
        frame_ptr->SetVisual(&sprite);
        mgDrawDirect(&frame);
    }
}

void CThunder::Step() {
    if (active != 0) {
        THUNDER_SPARK *bolt = spark;

        if (live_num > 0) {
            for (int i = 0; i < THUNDER_SPARK_MAX; i++) {
                if (bolt->life <= 0.0f) {
                    bolt++;
                    continue;
                }

                sceVu0AddVector(bolt->pos, bolt->pos, bolt->velocity);
                bolt->frame = iRand(6);
                bolt->angle += bolt->spin;

                if (bolt->life < 10.0f) {
                    bolt->scale -= 0.1f;

                    if (bolt->scale < 0.0f) {
                        bolt->scale = 0.0f;
                    }
                }

                bolt->life -= 1.0f;

                if (bolt->life <= 0.0f) {
                    live_num--;
                }

                bolt++;
            }

            if (live_num <= 0) {
                active = 0;
            }
        }
    }
}

void CThunder::Initialize() {
    active = 0;
    live_num = 0;
    frame.attr = &attr;
}

void CSparcEffect::Draw() {
    if (state != (int) SPARC_EFFECT_OFF && model[0] != 0) {
        mgCFrameAttr attr;
        float        sx = 2.0f;
        float        sz = 1.0f;

        attr.no_light = 1;

        switch ((s64) color) {
            case 0:
                attr.color[0] = 255.0f;
                attr.color[1] = 64.0f;
                attr.color[2] = 0.0f;
                attr.color[3] = alpha;
                break;
            case 1:
                attr.color[0] = 160.0f;
                attr.color[1] = 220.0f;
                attr.color[2] = 250.0f;
                attr.color[3] = alpha;
                break;
            case 2:
                attr.color[0] = 200.0f;
                attr.color[1] = 160.0f;
                attr.color[2] = 250.0f;
                attr.color[3] = alpha;
                break;
            case 3:
                attr.color[0] = 128.0f;
                attr.color[1] = 255.0f;
                attr.color[2] = 128.0f;
                attr.color[3] = alpha;
                break;
        }

        model[0]->SetAttrParam(attr, 1, MG_FRAME_ATTR_COLOR);
        model[1]->SetAttrParam(attr, 1, MG_FRAME_ATTR_COLOR);
        model[2]->SetAttrParam(attr, 1, MG_FRAME_ATTR_COLOR);
        model[0]->SetPosition(pos);
        model[0]->SetScale(sx, sx, sz);
        model[1]->SetPosition(pos);
        model[1]->SetScale(sx, sx, sz);
        model[2]->SetPosition(pos);
        model[2]->SetScale(sx, sx, sz);

        switch ((s64) pattern) {
            case 0:
                mgDrawDirect(model[0]);
                mgDrawDirect(model[1]);
                break;
            case 1:
                mgDrawDirect(model[1]);
                mgDrawDirect(model[2]);
                break;
            case 2:
                mgDrawDirect(model[0]);
                mgDrawDirect(model[2]);
                break;
        }
    }
}

void CSparcEffect::Step() {
    if (state != (int) SPARC_EFFECT_OFF) {
        switch ((s64) state) {
            case (int) SPARC_EFFECT_FADE_IN:
                alpha += alpha_max / 4.0f;

                if (!(alpha < alpha_max)) {
                    state = (int) SPARC_EFFECT_FADE_OUT;
                }

                break;
            case (int) SPARC_EFFECT_FADE_OUT:
                alpha -= alpha_max / 8.0f;

                if (alpha <= 0.0f) {
                    alpha = 0.0f;
                    state = (int) SPARC_EFFECT_OFF;
                }

                break;
        }
    }
}

void CSparcEffect::Initialize() {
    state = (int) SPARC_EFFECT_OFF;
}

void CMiniEffPrim::SetPrim(float *pos, int kind) {
    sceVu0CopyVector(this->pos, pos);
    this->state = (int) MINI_EFF_PRIM_RISING;
    this->alpha = 1.0f;
    this->size = 1.0f + fRand(2.0f);
    this->color = kind;
}

void CMiniEffPrim::Draw(CPreSprite *sprite) {
    int corner0[4];
    int corner1[4];
    int u0;
    int v0;
    int u1;
    int v1;

    if (state != (int) MINI_EFF_PRIM_FREE && sprite != 0) {
        if (color == 0) {
            sprite->Color(0x80, 0xB4, 0x80, fptosi(128.0f * alpha));
            u0 = 0x20;
            v0 = 0x40;
            u1 = 0x2F;
            v1 = 0x4F;
        }

        if (color == 1) {
            sprite->Color(0xFA, 0xDC, 0x40, fptosi(128.0f * alpha));
            u0 = 0x20;
            v0 = 0x40;
            u1 = 0x2F;
            v1 = 0x4F;
        }

        if (mgTransWorldPrim3DSprite(corner0, corner1, pos, size, size, 0) != 0) {
            sprite->TextureCrd(u0, v0);
            sprite->Vertex4(corner0);
            sprite->TextureCrd(u1, v1);
            sprite->Vertex4(corner1);
        }
    }
}

int CMiniEffPrim::Step() {
    if (state == (int) MINI_EFF_PRIM_FREE) {
        return 0;
    }

    if (state == (int) MINI_EFF_PRIM_RISING) {
        alpha -= 0.0625f;
        pos[1] -= 0.5f;

        if (alpha <= 0.0f) {
            state = (int) MINI_EFF_PRIM_FREE;
            return 1;
        }
    }

    return 0;
}

void CMiniEffPrim::Initialize() {
    state = (int) MINI_EFF_PRIM_FREE;
}

void CMiniEffPrimMan::CreatPrim(float *pos, int kind) {
    for (int i = 0; i < MINI_EFF_PRIM_MAX; i++) {
        if (prim[i].state == (int) MINI_EFF_PRIM_FREE) {
            prim[i].SetPrim(pos, kind);
            active_num++;
            return;
        }
    }
}

void CMiniEffPrimMan::Draw() {
    if (active_num > 0) {
        draw_prim.Initialize(0, 0);
        draw_prim.Preset2D();
        draw_prim.Coord(1);
        draw_prim.DepthTestEnable(1);
        draw_prim.ZMask(MG_Z_MASK_MASKED);
        draw_prim.Bilinear(1);
        draw_prim.TextureMapEnable(1);
        draw_prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
        draw_prim.Begin(MG_PRIM_SPRITE);
        draw_prim.Texture(TEX_SystemEffect1);

        for (int i = 0; i < MINI_EFF_PRIM_MAX; i++) {
            prim[i].Draw(&draw_prim);
        }

        draw_prim.End();
    }
}

void CMiniEffPrimMan::Step() {
    if (active_num > 0) {
        for (int i = 0; i < MINI_EFF_PRIM_MAX; i++) {
            if (prim[i].Step() != 0) {
                active_num--;
            }
        }
    }
}

void CMiniEffPrimMan::Initialize() {
    for (int i = 0; i < MINI_EFF_PRIM_MAX; i++) {
        prim[i].Initialize();
    }

    active_num = 0;
}

void CPalletAnime::SetAnim(s16 red, s16 green, s16 blue, s16 pulse_num, s16 duration, s16 repeats) {
    this->red = red;
    this->green = green;
    this->blue = blue;
    this->pulse_num = pulse_num;
    this->duration = duration;
    elapsed = 0;
    this->repeats = repeats;
}

int CPalletAnime::CreatPallet(float *out, float *base) {
    if (duration <= 0) {
        return 0;
    }

    int period = duration / this->pulse_num;

    if (period <= 0) {
        return 0;
    }

    float ratio = (float) (elapsed % period);
    ratio = ratio / (float) period;
    float blend = sinf(3.1415927f * ratio);
    out[0] = base[0] + blend * ((float) red - base[0]);
    out[1] = base[1] + blend * ((float) green - base[1]);
    out[2] = base[2] + blend * ((float) blue - base[2]);
    out[3] = 128.0f;
    return 1;
}

void CPalletAnime::Step() {
    s16 repeat_left;

    if ((duration > 0) && (elapsed += 1, ((elapsed < duration) == 0))) {
        repeat_left = repeats;

        if (repeat_left == -1) {
            elapsed = 0;
            return;
        }

        if (repeat_left > 0) {
            repeats = repeat_left - 1;
            elapsed = 0;
            return;
        }

        duration = 0;
    }
}

void CPalletAnime::Initialize() {
    duration = 0;
    elapsed = 0;
}

void CHealingEffectMan::Draw(mgCCamera *camera) {
    float camera_pos[4];
    int   corner0[4];
    int   corner1[4];
    float identity[4][4];
    float rotation[4][4];
    int   glow_alpha;
    int   halo_alpha;

    if (active != 0) {
        camera->GetPos(camera_pos);
        sceVu0UnitMatrix(identity);

        switch (mode) {
            case (int) HEALING_EFFECT_IDLE:
                glow_alpha = 0x80;
                halo_alpha = 0x40;
                break;
            case (int) HEALING_EFFECT_OFF:
                halo_alpha = 0;
                glow_alpha = 0;
                break;
            case (int) HEALING_EFFECT_SPENT: {
                float fade_in = 1.0f - (brightness - 1.0f);
                glow_alpha = fptosi(255.0f * fade_in);
                halo_alpha = fptosi(180.0f * fade_in);
                break;
            }
            case (int) HEALING_EFFECT_RECHARGE: {
                float fade_out = brightness;
                glow_alpha = fptosi(128.0f * fade_out);
                halo_alpha = fptosi(64.0f * fade_out);
                break;
            }
        }

        float distance = mgDistVector(camera_pos, center);

        if (distance <= 640.0f) {
            float distance_fade = 1.0f;

            if (!(distance <= 320.0f)) {
                distance_fade = 1.0f - (distance - 320.0f) / 320.0f;
            }

            glow_alpha = fptosi((float) glow_alpha * distance_fade);
            halo_alpha = fptosi((float) halo_alpha * distance_fade);

            CPreSprite prim;
            prim.Initialize(0, 0);
            prim.Preset2D();
            prim.Coord(1);
            prim.DepthTestEnable(1);
            prim.ZMask(MG_Z_MASK_MASKED);
            prim.Bilinear(1);
            prim.TextureMapEnable(1);
            prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
            prim.Begin(MG_PRIM_SPRITE);
            prim.Texture(TEX_SystemEffect1);
            HEALING_LIGHT *particle = light;

            for (int i = 0; i < HEALING_LIGHT_MAX; i++, particle++) {
                particle->pos[0] = 0.0f;
                particle->pos[1] = particle->bob_height * sinf(particle->bob_phase);
                particle->pos[2] = particle->radius;
                sceVu0RotMatrixY(rotation, identity, particle->angle);
                sceVu0ApplyMatrix(particle->pos, rotation, particle->pos);
                sceVu0AddVector(particle->pos, particle->pos, center);
                particle->pos[1] += 8.0f;
                particle->pos[3] = 1.0f;
                float glow_size = 3.0f * brightness;

                if (mgTransWorldPrim3DSprite(corner0, corner1, particle->pos, glow_size, glow_size,
                                             0) != 0) {
                    prim.Color(0x5A, 0x80, 0x40, glow_alpha);
                    prim.TextureCrd(0, 0x20);
                    prim.Vertex4(corner0);
                    prim.TextureCrd(0x1F, 0x3F);
                    prim.Vertex4(corner1);
                }

                float halo_size = 30.0f * brightness;

                if (mgTransWorldPrim3DSprite(corner0, corner1, particle->pos, halo_size, halo_size,
                                             0) != 0) {
                    prim.Color(0x5A, 0x80, 0x5A, halo_alpha);
                    prim.TextureCrd(0x40, 0x40);
                    prim.Vertex4(corner0);
                    prim.TextureCrd(0x7F, 0x7F);
                    prim.Vertex4(corner1);
                }
            }

            prim.End();
        }
    }
}

void CHealingEffectMan::Step() {
    if (active != 0) {
        switch (mode) {
            case (int) HEALING_EFFECT_SPENT:
                brightness += 0.033333335f;

                if (!(brightness < 2.0f)) {
                    mode = (int) HEALING_EFFECT_OFF;
                    brightness = 0.0f;
                }

                break;
            case (int) HEALING_EFFECT_RECHARGE:
                brightness += 0.033333335f;

                if (!(brightness < 1.0f)) {
                    mode = (int) HEALING_EFFECT_IDLE;
                    brightness = 1.0f;
                }

                break;
        }

        HEALING_LIGHT *particle = light;

        for (int i = 0; i < HEALING_LIGHT_MAX; i++, particle++) {
            particle->angle += particle->spin;

            if (!(particle->angle <= 3.1415927f)) {
                particle->angle -= 6.2831855f;
            }

            if (particle->angle < -3.1415927f) {
                particle->angle += 6.2831855f;
            }

            particle->bob_phase += particle->bob_speed;

            if (!(particle->bob_phase <= 3.1415927f)) {
                particle->bob_phase -= 6.2831855f;
            }
        }
    }
}

void CHealingEffectMan::SetMode(int mode) {
    this->mode = mode;
}

void CHealingEffectMan::Set(float *pos) {
    sceVu0CopyVector(this->center, pos);
    this->active = 1;
    this->mode = (int) HEALING_EFFECT_IDLE;
    this->brightness = 1.0f;
}

void CHealingEffectMan::Initialize() {
    active = 0;
    mode = (int) HEALING_EFFECT_IDLE;
    HEALING_LIGHT *particle = light;

    for (int i = 0; i < HEALING_LIGHT_MAX; i++, particle++) {
        particle->radius = fRand(80.0f) - 40.0f;

        if (particle->radius < 0.0f) {
            particle->radius -= 20.0f;
        } else {
            particle->radius += 20.0f;
        }

        particle->angle = fRand(3.1415927f);
        particle->bob_height = fRand(8.0f);
        particle->bob_phase = fRand(3.1415927f / 32.0f);
        particle->bob_speed = fRand(3.1415927f / 32.0f);
        particle->spin = fRand(3.1415927f / 48.0f) - 3.1415927f / 96.0f;
    }
}

void CSwordLuminous::Draw() {
    float hilt_pos[4];
    float tip_pos[4];
    float step[4];

    if (mode == (int) SWORD_LUMINOUS_OFF || tip_frame == 0 || root_frame == 0) {
        return;
    }

    tip_frame->GetWorldPosition0(hilt_pos);
    root_frame->GetWorldPosition0(tip_pos);
    sceVu0SubVector(step, hilt_pos, tip_pos);
    float length = mgDistVector(step);
    sceVu0Normalize(step, step);
    sceVu0ScaleVector(step, step, length / 16.0f);

    CPreSprite prim;
    int        corner0[4];
    int        corner1[4];
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(TEX_SystemEffect1);
    prim.Color(0x80, 0x80, 0xFF, 0x18);
    float size = 12.0f + 4.0f * sinf(pulse);
    int   i = 0;

    do {
        if (mgTransWorldPrim3DSprite(corner0, corner1, tip_pos, size, size, 0) != 0) {
            prim.TextureCrd(0x80, 0x40);
            prim.Vertex4(corner0);
            prim.TextureCrd(0xA0, 0x60);
            prim.Vertex4(corner1);
        }

        sceVu0AddVector(tip_pos, tip_pos, step);
        i++;
    } while (i < 0x10);

    prim.End();
}

void CSwordLuminous::Step() {
    if (mode == (int) SWORD_LUMINOUS_OFF) {
        return;
    }

    switch (mode) {
        case (int) SWORD_LUMINOUS_FADE_IN:
            fade += 0.0625f;

            if (fade > 1.0f) {
                fade = 1.0f;
            }

            break;
        case (int) SWORD_LUMINOUS_ON:
            break;
        case (int) SWORD_LUMINOUS_FADE_OUT:
            fade -= 0.03125f;

            if (fade <= 0.0f) {
                mode = (int) SWORD_LUMINOUS_OFF;
            }

            break;
    }

    pulse += 0.10471976f;

    if (pulse > 3.1415927f) {
        pulse -= 3.1415927f;
    }
}

void CSWordAfterImage::Draw() {
    int screen[4];

    if (smooth_num > 0) {
        CPreSprite prim;
        float      edge[4];
        float      edge_end[4];

        prim.Initialize(0, 0);
        prim.Preset2D();
        prim.TextureMapEnable(0);
        prim.Coord(1);
        prim.Shading(1);
        prim.DepthTestEnable(1);
        prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
        prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
        prim.Begin(MG_PRIM_TRIANGLE_STRIP);

        for (int i = 0; i < smooth_num; i++) {
            sceVu0SubVector(edge, smooth_back[i], smooth_edge[i]);
            sceVu0ScaleVector(edge, edge, 0.7f);
            sceVu0AddVector(edge_end, smooth_edge[i], edge);
            edge_end[3] = 1.0f;
            float alpha = smooth_life[i];

            if (alpha < 0.0f) {
                alpha = 0.0f;
            }

            if (mgTransWorldPrim(screen, smooth_edge[i]) != 0) {
                prim.Color(edge_color[0], edge_color[1], edge_color[2], fptosi((float) edge_color[3] * alpha));
                prim.Vertex4(screen);
            }

            if (mgTransWorldPrim(screen, edge_end) != 0) {
                prim.Color(back_color[0], back_color[1], back_color[2], fptosi((float) back_color[3] * alpha));
                prim.Vertex4(screen);
            }
        }

        prim.End();
    }
}

void CSWordAfterImage::CreatPointList() {
    if (point_num <= 0) {
        return;
    }

    smooth_num = CreatSmoothPass(smooth_edge, edge_point, point_num, division, head_index, point_max);
    CreatSmoothPass(smooth_back, back_point, point_num, division, head_index, point_max);

    if (smooth_num == 0) {
        return;
    }

    int out = 0;

    for (int i = 0; i < point_num - 1; i++) {
        int from = i + head_index;
        int to = i + head_index + 1;

        if (!(from < point_max)) {
            from -= point_max;
        }

        if (from < 0) {
            from += point_max;
        }

        if (!(to < point_max)) {
            to -= point_max;
        }

        if (to < 0) {
            to += point_max;
        }

        float fade_from = life[from];
        float fade_to = life[to];
        smooth_life[out] = fade_from;
        (&smooth_life[out])[division - 1] = fade_to;

        for (int j = 1; j < division; j++) {
            (&smooth_life[out])[j] = fade_from + (float) j * ((fade_to - fade_from) / (float) division);
        }

        out += division;
    }
}

void CSWordAfterImage::AddPoint(float *tip, float *base, float fade) {
    sceVu0CopyVector(this->edge_point[this->write_index], tip);
    sceVu0CopyVector(this->back_point[this->write_index], base);
    this->life[this->write_index] = fade;
    this->head_index = this->write_index;

    if (this->point_num < this->point_max) {
        this->point_num++;
    }

    this->write_index--;

    if (this->write_index < 0) {
        this->write_index = this->point_max - 1;
    }

    this->active = 1;
}

void CSWordAfterImage::Step() {
    if (active != 0) {
        int index = head_index;

        for (int i = 0; i < point_num; i++) {
            life[index] -= 0.1f;

            if (life[index] <= 0.0f) {
                point_num--;
            }

            index++;

            if (index >= point_max) {
                index -= point_max;
            }

            if (index < 0) {
                index += point_max;
            }
        }

        if (point_num <= 0) {
            active = 0;
        }
    }
}

#pragma opt_propagation off

void CSWordAfterImage::Initialize(mgCMemory *memory, int capacity, int divisions) {
    int smooth_bytes;
    int smooth_capacity;
    int point_bytes;
    point_bytes = capacity << 4;
    smooth_capacity = capacity * (divisions + 2);
    smooth_bytes = smooth_capacity << 4;
    edge_point = (sceVu0FVECTOR *) memory->Alloc(point_bytes / 16 + 1);
    back_point = (sceVu0FVECTOR *) memory->Alloc(point_bytes / 16 + 1);
    int smooth_blocks = smooth_bytes / 16 + 1;
    smooth_edge = (sceVu0FVECTOR *) memory->Alloc(smooth_blocks);
    smooth_back = (sceVu0FVECTOR *) memory->Alloc(smooth_blocks);
    life = (float *) memory->Alloc(capacity * 4 / 16 + 1);
    smooth_life = (float *) memory->Alloc(smooth_capacity * 4 / 16 + 1);
    edge_color[0] = 96;
    edge_color[1] = 64;
    edge_color[2] = 48;
    edge_color[3] = 180;
    back_color[0] = 64;
    back_color[1] = 48;
    back_color[2] = 32;
    back_color[3] = 96;
    point_max = capacity;
    division = divisions;
    smooth_num = 0;
    point_num = 0;
    write_index = capacity - 1;
    head_index = capacity - 1;
    active = 0;
}

#pragma opt_propagation reset

void CAfterWire::SetMode(int mode) {
    this->mode = mode;
    write_index = 0;
    newest = 0;
    point_num = 0;
    oldest = 0;
}

void CAfterWire::SetPos(float *pos) {
    sceVu0CopyVector(point[write_index], pos);
    newest = write_index;
    write_index++;

    if (write_index > AFTER_WIRE_POINT_MAX - 1) {
        write_index = 0;
    }

    oldest = newest + 1;

    if (oldest > AFTER_WIRE_POINT_MAX) {
        oldest = 0;
    }

    if (point_num < AFTER_WIRE_POINT_MAX) {
        oldest = 0;
    }

    if (point_num < AFTER_WIRE_POINT_MAX) {
        point_num++;
    }
}

void CAfterWire::DrawWire(float (*smooth)[4]) {
    int vertex[4];

    if (mode != 0 && point_num >= 2) {
        smooth_num = CreatSmoothPass(smooth, point, point_num, 4, oldest, AFTER_WIRE_POINT_MAX);

        CPreSprite prim;
        prim.Initialize(0, 0);
        prim.Preset2D();
        prim.TextureMapEnable(0);
        prim.Coord(1);
        prim.Shading(1);
        prim.DepthTestEnable(1);
        prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
        prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
        prim.Begin(MG_PRIM_LINE_STRIP);
        float alpha = 0.0f;

        for (int i = 0; i < smooth_num; smooth++, i++) {
            if (mgTransWorldPrim(vertex, *smooth) != 0) {
                prim.Color(0x50, 0x50, 0xFF, fptosi(128.0f * alpha));
                prim.Vertex4(vertex);
            }

            alpha += 1.0f / smooth_num;
        }

        prim.End();
    }
}

void CAfterWire::StepWire() {
    if (mode != 0 && point_num < 2) {
        return;
    }
}

void CHitEffectImage::SethitEffect(float *hit_pos, float *hit_dir, float hit_spread, float hit_speed,
                                   float hit_power, float hit_gravity, int spark_life, int count) {
    float center[4];
    int   spark_num = count;
    sceVu0CopyVector(origin, hit_pos);
    sceVu0CopyVector(direction, hit_dir);
    sceVu0Normalize(direction, direction);

    if (spark_max < spark_num) {
        spark_num = spark_max;
    }

    spread = hit_spread;
    distance = hit_speed;
    slow = hit_power;
    gravity = hit_gravity;
    live_num = spark_num;
    sceVu0ScaleVectorXYZ(center, direction, hit_speed);
    center[0] += origin[0];
    center[1] += origin[1];
    center[2] += origin[2];
    this->spark_num = spark_num;
    BattleEffectPrim *spark = this->spark;
    int               i = 0;

    if (0 < spark_num) {
        do {
            float x = (center[0] + 2.0f * (hit_spread * mgRnd())) - hit_spread;
            float y = (center[1] + 2.0f * (hit_spread * mgRnd())) - hit_spread;
            float z = (center[2] + 2.0f * (hit_spread * mgRnd())) - hit_spread;
            spark->velocity[0] = x - origin[0];
            spark->velocity[1] = y - origin[1];
            spark->velocity[2] = z - origin[2];
            spark->velocity[3] = 1.0f;
            sceVu0Normalize(spark->velocity, spark->velocity);
            spark->pos[0] = (origin[0] + 3.0f * mgRnd()) - 3.0f;
            spark->pos[1] = (origin[1] + 3.0f * mgRnd()) - 3.0f;
            spark->pos[2] = (origin[2] + 3.0f * mgRnd()) - 3.0f;
            spark->pos[3] = 1.0f;
            spark->life = spark_life + fptosi((float) spark_life * mgRnd()) - spark_life / 2;
            spark->alpha = 1.0f;
            spark->alpha_step = 1.0f / (float) spark->life;
            spark->speed = hit_speed / (float) spark->life;
            spark->rate = hit_power * (0.5f * mgRnd());
            spark->size = 32.0f + 200.0f * mgRnd();
            spark++;
            i++;
        } while (i < spark_num);
    }

    tex_rect.left = 0;
    tex_rect.top = 0;
    tex_rect.right = 0x1F;
    tex_rect.bottom = 0x1F;
    sprite_size = 5.0f;
}

void CHitEffectImage::Step() {
    if (live_num > 0) {
        BattleEffectPrim *spark = this->spark;

        for (int i = 0; i < spark_num; i++) {

            if (spark->life > 0) {
                float move[4];
                sceVu0ScaleVectorXYZ(move, spark->velocity, spark->speed);
                spark->pos[0] += move[0];
                spark->pos[1] += move[1];
                spark->pos[2] += move[2];
                spark->velocity[1] -= gravity;

                if (!(spark->speed <= 0.0f)) {
                    spark->speed -= spark->rate;
                }

                spark->life--;
                spark->alpha -= spark->alpha_step;

                if (spark->life <= 0) {
                    live_num--;
                }

                spark++;
            }
        }
    }
}

void CHitEffectImage::Draw() {
    if (live_num > 0) {
        switch (kind) {
            case HIT_EFFECT_BOARD:
                this->DrawBord();
                return;
            case HIT_EFFECT_SPARK_SHORT:
                this->DrawSpark(3.0f);
                return;
            case HIT_EFFECT_SPARK_LONG:
                this->DrawSpark(9.0f);
                break;
        }
    }
}

void CHitEffectImage::DrawBord() {
    CPreSprite prim;
    int        corner0[4];
    int        corner_b_r[4];
    int        corner_t_l[4];
    int        corner1[4];

    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.Bilinear(1);
    prim.Coord(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_TRIANGLE);
    prim.Texture(TEX_SystemEffect1);
    prim.AlphaTestEnable(1);
    BattleEffectPrim *spark = this->spark;
    int               i;

    for (i = 0; i < spark_num; i++) {
        if (spark->life > 0) {
            prim.Color(0x80, 0x80, 0x80, fptosi(128.0f * spark->alpha));
            int w = tex_rect.right - 1;
            int h = tex_rect.bottom - 1;
            int u = tex_rect.left;
            int v = tex_rect.top;

            if (mgTransWorldPrim3DSprite(corner0, corner1, spark->pos, sprite_size, sprite_size, 0) != 0) {
                corner_b_r[0] = corner1[0];
                corner_b_r[1] = corner0[1];
                corner_b_r[2] = corner0[2];
                corner_b_r[3] = corner0[3];
                corner_t_l[0] = corner0[0];
                corner_t_l[1] = corner1[1];
                corner_t_l[2] = corner1[2];
                corner_t_l[3] = corner1[3];
                prim.TextureCrd(u, v);
                prim.Vertex4(corner0);
                prim.TextureCrd(u + w, v);
                prim.Vertex4(corner_b_r);
                prim.TextureCrd(u, v + h);
                prim.Vertex4(corner_t_l);
                prim.TextureCrd(u, v + h);
                prim.Vertex4(corner_t_l);
                prim.TextureCrd(u + w, v);
                prim.Vertex4(corner_b_r);
                prim.TextureCrd(u + w, v + h);
                prim.Vertex4(corner1);
            }

            spark++;
        }
    }

    switch (i) {
        case 0:
        default:
            prim.End();
    }
}

void CHitEffectImage::DrawSpark(float size) {
    CPreSprite prim;
    int        tail_screen[4];
    int        tip_screen[4];
    float      tip[4];

    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.TextureMapEnable(0);
    prim.Coord(1);
    prim.Shading(1);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_LINE);

    BattleEffectPrim *spark = this->spark;

    for (int i = 0; i < spark_num; i++) {
        if (spark->life > 0) {
            prim.Color(0x80, 0x80, 0x80, 0x80);
            tip[0] = spark->pos[0] + spark->velocity[0] * size;
            tip[1] = spark->pos[1] + spark->velocity[1] * size;
            tip[2] = spark->pos[2] + spark->velocity[2] * size;
            tip[3] = 1.0f;
            int visible = mgTransWorldPrim(tail_screen, spark->pos);
            visible += mgTransWorldPrim(tip_screen, tip);

            if (visible == 2) {
                prim.Color(0x20, 0x20, 0, 0x20);
                prim.Vertex4(tail_screen);
                prim.Color(0xFF, 0xFF, 0x80, 0xFF);
                prim.Vertex4(tip_screen);
            }

            spark++;
        }
    }

    prim.End();
}

void CFlushEffect::Draw() {
    if (active != 0) {
        CPreSprite prim;
        int        corner0[4];
        int        corner_b_r[4];
        int        corner_t_l[4];
        int        corner1[4];

        prim.Initialize(0, 0);
        prim.Preset2D();
        prim.DepthTestEnable(1);
        prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
        prim.Bilinear(1);
        prim.Coord(1);
        prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
        prim.Begin(MG_PRIM_TRIANGLE);
        prim.Texture(TEX_SystemEffect2);
        prim.AlphaTestEnable(1);

        if (mgTransWorldPrim3DSprite(corner0, corner1, pos, size, size, 0) != 0) {
            corner_b_r[0] = corner1[0];
            corner_b_r[1] = corner0[1];
            corner_b_r[2] = corner0[2];
            corner_b_r[3] = corner0[3];
            corner_t_l[0] = corner0[0];
            corner_t_l[1] = corner1[1];
            corner_t_l[2] = corner1[2];
            corner_t_l[3] = corner1[3];
            prim.Color(0x80, 0x80, 0x80, alpha);
            prim.TextureCrd(tex_u, tex_v);
            prim.Vertex4(corner0);
            prim.TextureCrd(tex_u + tex_size, tex_v);
            prim.Vertex4(corner_b_r);
            prim.TextureCrd(tex_u, tex_v + tex_size);
            prim.Vertex4(corner_t_l);
            prim.TextureCrd(tex_u, tex_v + tex_size);
            prim.Vertex4(corner_t_l);
            prim.TextureCrd(tex_u + tex_size, tex_v);
            prim.Vertex4(corner_b_r);
            prim.TextureCrd(tex_u + tex_size, tex_v + tex_size);
            prim.Vertex4(corner1);
        }

        prim.End();
    }
}

void CFlushEffect::Step() {
    switch (active) {
        case 0:
            break;
        default:
            if (follow != NULL) {
                follow->GetWorldPosition0(pos);
            }

            size += grow;
            alpha -= (short) fade_speed;

            if (alpha <= 0) {
                alpha = 0;
                active = 0;
                follow = NULL;
            }

            break;
    }
}

void CPowerLine::CreatPrim() {
    float             range = radius;
    BattleEffectPrim *streak = prim + next;
    streak->pos[0] = 2.0f * (range * mgRnd()) - range;
    streak->pos[1] = 0.2f * (height * mgRnd());
    range = radius;
    streak->pos[2] = 2.0f * (range * mgRnd()) - range;
    streak->speed = rise;
    float prim_size = this->prim_size;
    streak->size = prim_size / 2.0f + prim_size * mgRnd() / 2.0f;
    streak->life = prim_life;
    next++;

    if (next >= prim_max) {
        next = 0;
    }

    live_num++;
}

void CPowerLine::Step() {
    if ((duration > 0 || live_num > 0) && source != 0) {
        BattleEffectPrim *streak = this->prim;

        for (int i = 0; i < prim_max; i++) {
            if (streak->life > 0) {
                streak->pos[1] += streak->speed;
                streak->life--;

                if (streak->life <= 0) {
                    live_num--;
                }
            }

            streak++;
        }

        source->GetPosition(pos);

        if (duration > 0 && elapsed < duration) {
            elapsed++;

            if (elapsed >= duration) {
                duration = 0;
            }

            CreatPrim();
        }
    }
}

void CPowerLine::Draw() {
    if (duration > 0 || live_num > 0) {
        CPreSprite sprite;
        float      center[4];
        int        corner0[4];
        int        corner_b_r[4];
        int        corner_t_l[4];
        int        corner1[4];
        sprite.Initialize(0, 0);
        sprite.Preset2D();
        sprite.DepthTestEnable(1);
        sprite.DepthTest(MG_DEPTH_TEST_GEQUAL);
        sprite.Bilinear(1);
        sprite.Coord(1);
        sprite.AlphaBlend(MG_ALPHA_BLEND_ADD);
        sprite.Begin(MG_PRIM_TRIANGLE);
        sprite.Texture(TEX_SystemEffect1);
        sprite.AlphaTestEnable(1);
        BattleEffectPrim *streak = this->prim;

        for (int i = 0; i < prim_max; i++) {
            if (streak->life <= 0) {
                streak++;
                continue;
            }

            int   tex_u = tex_rect.left;
            int   tex_v = tex_rect.top;
            float width = 20.0f;
            float sprite_height = 0.2f;
            sceVu0AddVector(center, &streak->pos[0], pos);
            center[3] = 1.0f;

            if (mgTransWorldPrim3DSprite(corner0, corner1, center, sprite_height, width, 0) != 0) {
                corner_b_r[0] = corner1[0];
                corner_b_r[1] = corner0[1];
                corner_b_r[2] = corner0[2];
                corner_b_r[3] = corner0[3];
                corner_t_l[0] = corner0[0];
                corner_t_l[1] = corner1[1];
                corner_t_l[2] = corner1[2];
                corner_t_l[3] = corner1[3];
                sprite.Color(color[0], color[1], color[2], color[3]);
                sprite.TextureCrd(tex_u, tex_v);
                sprite.Vertex4(corner0);
                sprite.TextureCrd(tex_u + 0xF, tex_v);
                sprite.Vertex4(corner_b_r);
                sprite.TextureCrd(tex_u, tex_v + 0x1F);
                sprite.Vertex4(corner_t_l);
                sprite.TextureCrd(tex_u, tex_v + 0x1F);
                sprite.Vertex4(corner_t_l);
                sprite.TextureCrd(tex_u + 0xF, tex_v);
                sprite.Vertex4(corner_b_r);
                sprite.TextureCrd(tex_u + 0xF, tex_v + 0x1F);
                sprite.Vertex4(corner1);
            }

            streak++;
        }

        sprite.End();
    }
}

void CDeadEffect::SetDeadEffect(float *pos, float value14, float value10, float value18, int value1_c) {
    sceVu0CopyVector(this->pos, pos);
    this->radius = value14;
    this->height = value10;
    this->size = value18;
    this->duration = value1_c;
    this->elapsed = 0;
}

void CDeadEffect::CreatPrim(int kind) {
    if (prim != NULL) {
        BattleEffectPrim *particle = &prim[next];
        particle->kind = kind;
        float range = radius;
        particle->pos[0] = 2.0f * (range * mgRnd()) - range;
        particle->pos[1] = 0.3f * (height * mgRnd());
        range = radius;
        particle->pos[2] = 2.0f * (range * mgRnd()) - range;
        particle->velocity[0] = 8.0f * mgRnd() - 4.0f;
        particle->velocity[1] = 1.0f + 0.5f * mgRnd();
        particle->velocity[2] = 8.0f * mgRnd() - 4.0f;

        if (kind == DEAD_EFFECT_FLECK_CLOUD) {
            particle->life = fptosi(10.0f * mgRnd()) + 20;
            particle->life_max = particle->life;
            particle->speed = 0.2f;
            particle->size = 1.5f + size * mgRnd();
            particle->rate = 32.0f + 8.0f * mgRnd();
        }

        if (kind == DEAD_EFFECT_FLECK_GLITTER) {
            particle->life = fptosi(10.0f * mgRnd()) + 20;
            particle->life_max = particle->life;
            particle->speed = 0.2f;
            particle->size = 0.1f + size * (0.8f * mgRnd());
            particle->rate = 32.0f + 64.0f * mgRnd();
        }

        next += 1;

        if (next >= prim_max) {
            next = 0;
        }

        live_num += 1;
    }
}

void CDeadEffect::Step() {
    if (duration > 0 || live_num > 0) {
        BattleEffectPrim *spark = prim;

        for (int i = 0; i < prim_max; spark++, i++) {
            if (spark->life > 0) {
                spark->pos[0] += spark->velocity[0];
                spark->pos[1] += spark->velocity[1];
                spark->pos[2] += spark->velocity[2];
                spark->velocity[0] = spark->velocity[0] - 0.2f * spark->velocity[0];
                spark->velocity[2] = spark->velocity[2] - 0.2f * spark->velocity[2];

                if (spark->kind == DEAD_EFFECT_FLECK_GLITTER) {
                    spark->size = spark->size - 0.01f;
                }

                spark->life = spark->life - 1;

                if (spark->life <= 0) {
                    live_num -= 1;
                }
            }
        }

        if (duration > 0) {
            if (elapsed < duration) {
                elapsed++;

                if (elapsed >= duration) {
                    duration = 0;
                }

                if (elapsed == 1) {
                    int n = 0;

                    do {
                        CreatPrim(DEAD_EFFECT_FLECK_CLOUD);
                        n += 1;
                    } while (n < 10);
                }

                CreatPrim(DEAD_EFFECT_FLECK_CLOUD);
                CreatPrim(DEAD_EFFECT_FLECK_GLITTER);
            }
        }
    }
}

void CDeadEffect::Draw() {
    if (duration <= 0 && live_num <= 0) {
        return;
    }

    CPreSprite prim_draw;
    float      world[4];
    int        corner0[4];
    int        corner_b_r[4];
    int        corner_t_l[4];
    int        corner1[4];

    prim_draw.Initialize(0, 0);
    prim_draw.Preset2D();
    prim_draw.DepthTestEnable(1);
    prim_draw.DepthTest(1);
    prim_draw.Bilinear(1);
    prim_draw.Coord(1);
    prim_draw.AlphaBlend(2);
    prim_draw.Begin(3);
    prim_draw.Texture(TEX_SystemEffect1);
    prim_draw.AlphaTestEnable(1);
    int               u;
    int               v;
    int               span;
    BattleEffectPrim *fleck = prim;

    for (int i = 0; i < prim_max; i++) {
        if (fleck->life <= 0) {
            fleck++;
            continue;
        }

        if (fleck->kind == DEAD_EFFECT_FLECK_CLOUD) {
            u = 0x80;
            v = 0x40;
            span = 0x1F;
        }

        if (fleck->kind == DEAD_EFFECT_FLECK_GLITTER) {
            u = 0xA0;
            v = 0x40;
            span = 0x1F;

            if (fleck->life % 3 == 1) {
                v = 0x60;
            }
        }

        sceVu0AddVector(world, fleck->pos, pos);
        world[3] = 1.0f;
        float fade = sinf(3.1415927f * ((float) fleck->life / (float) fleck->life_max));

        if (mgTransWorldPrim3DSprite(corner0, corner1, world, 15.0f * fleck->size,
                                     1.5f * (12.0f * fleck->size), 0) != 0) {
            corner_b_r[0] = corner1[0];
            corner_b_r[1] = corner0[1];
            corner_b_r[2] = corner0[2];
            corner_b_r[3] = corner0[3];
            corner_t_l[0] = corner0[0];
            corner_t_l[1] = corner1[1];
            corner_t_l[2] = corner1[2];
            corner_t_l[3] = corner1[3];

            switch (i % 7) {
                case 0:
                    prim_draw.Color(0x80, 0, 0, (int) (fleck->rate * fade));
                    break;
                case 1:
                    prim_draw.Color(0, 0x80, 0, (int) (fleck->rate * fade));
                    break;
                case 2:
                    prim_draw.Color(0, 0, 0x80, (int) (fleck->rate * fade));
                    break;
                case 3:
                    prim_draw.Color(0, 0x80, 0x80, (int) (fleck->rate * fade));
                    break;
                case 4:
                    prim_draw.Color(0x80, 0x80, 0, (int) (fleck->rate * fade));
                    break;
                case 5:
                    prim_draw.Color(0x80, 0, 0x80, (int) (fleck->rate * fade));
                    break;
                case 6:
                    prim_draw.Color(0x80, 0x80, 0x80, (int) (fleck->rate * fade));
                    break;
            }

            prim_draw.TextureCrd(u, v);
            prim_draw.Vertex4(corner0);
            prim_draw.TextureCrd(u + span, v);
            prim_draw.Vertex4(corner_b_r);
            prim_draw.TextureCrd(u, v + span);
            prim_draw.Vertex4(corner_t_l);
            prim_draw.TextureCrd(u, v + span);
            prim_draw.Vertex4(corner_t_l);
            prim_draw.TextureCrd(u + span, v);
            prim_draw.Vertex4(corner_b_r);
            prim_draw.TextureCrd(u + span, v + span);
            prim_draw.Vertex4(corner1);
        }

        fleck++;
    }

    prim_draw.End();
}

void CMapEffect_Sprite::Set(float *spawn_pos) {
    sceVu0CopyVector(pos, spawn_pos);
    sceVu0CopyVector(target, spawn_pos);
    target[3] = 1.0f;
    pos[3] = 1.0f;
    target[0] = target[0] + 3.0f * ((600.0f * (float) rand()) / 2.1474836e9f - 300.0f);
    target[2] += 3.0f * ((600.0f * (float) rand()) / 2.1474836e9f - 300.0f);
    life = fptosi(90.0f + (150.0f * (float) rand()) / 2.1474836e9f);
    life_max = life;
    bob_angle = (6.0f * (float) rand()) / 2.1474836e9f - 3.0f;
    bob_height = 0.4f + (2.0f * (float) rand()) / 2.1474836e9f;
    speed = 0.4f + (float) rand() / 2.1474836e9f;
    direction[0] = target[0] - pos[0];
    direction[1] = target[1] - pos[1];
    direction[2] = target[2] - pos[2];
    direction[3] = 1.0f;
    sceVu0Normalize(direction, direction);
}

void CMapEffect_Sprite::Step(mgCCamera *camera) {
    float camera_pos[4];
    float move[4];

    if (life > 0) {
        camera->GetPos(camera_pos);
        move[0] = target[0] - pos[0];
        move[1] = target[1] - pos[1];
        move[2] = target[2] - pos[2];
        move[3] = 1.0f;
        sceVu0Normalize(move, move);
        move[0] += (move[0] + direction[0]) / 16.0f;
        move[1] = move[1] + (move[1] + direction[1]) / 16.0f;
        move[2] = move[2] + (move[2] + direction[2]) / 16.0f;
        sceVu0ScaleVectorXYZ(move, move, speed);
        pos[0] += move[0];
        pos[1] += move[1];
        pos[2] += move[2];
        bob_angle += 0.05235988f;

        if (!(bob_angle <= 3.1415927f)) {
            bob_angle -= 6.2831855f;
        }

        if (mgDistVector(target, pos) < 2.0f) {
            target[0] = pos[0] + 2.0f * ((600.0f * (float) rand()) / 2.1474836e9f - 300.0f);
            target[2] = pos[2] + 2.0f * ((600.0f * (float) rand()) / 2.1474836e9f - 300.0f);
            speed = 0.4f + (0.8f * (float) rand()) / 2.1474836e9f;
        }

        if (!(mgDistVector(pos, camera_pos) <= 600.0f)) {
            life = 0;
        }

        life -= 1;
    }
}

void CMapEffect_Sprite::Draw(mgCCamera *camera, CPreSprite *sprite) {
    float world[4];
    int   corner0[4];
    int   corner_b_r[4];
    int   corner_t_l[4];
    int   corner1[4];
    int   u;
    int   v;
    int   span;
    int   alpha;
    float size;

    if (life > 0) {
        sceVu0CopyVector(world, pos);
        world[1] += 10.0f * (bob_height * sinf(bob_angle));
        int kind = type;
        alpha = 0x10;

        if (kind == MAP_EFFECT_D01) {
            if (life < 0x40) {
                alpha = fptosi(0.25f * (float) life);
            } else if (life_max - life < 0x40) {
                alpha = fptosi(0.25f * (float) (life_max - life));
            }

            u = 0;
            size = 100.0f;
            v = 0xA1;
            span = 0x5E;
        }

        if (kind == MAP_EFFECT_D02) {
            alpha = 0x80;

            if (life < 0x14) {
                alpha = life * 6;
            }

            u = 0x20;
            size = 5.0f;
            v = 0;
            span = 0x1F;
        }

        if (kind == MAP_EFFECT_D03) {
            if (life < 0x40) {
                alpha = fptosi(0.25f * (float) life);
            } else if (life_max - life < 0x40) {
                alpha = fptosi(0.25f * (float) (life_max - life));
            }

            alpha *= 3.0f;
            u = 0;
            v = 0xA1;
            size = 100.0f;
            span = 0x5E;
        }

        if (mgTransWorldPrim3DSprite(corner0, corner1, world, size, size, 0) != 0) {
            corner_b_r[0] = corner1[0];
            corner_b_r[1] = corner0[1];
            corner_b_r[2] = corner0[2];
            corner_b_r[3] = corner0[3];
            corner_t_l[0] = corner0[0];
            corner_t_l[1] = corner1[1];
            corner_t_l[2] = corner1[2];
            corner_t_l[3] = corner1[3];
            sprite->Color(0x80, 0x80, 0x80, alpha);
            sprite->TextureCrd(u, v);
            sprite->Vertex4(corner0);
            sprite->TextureCrd(u + span, v);
            sprite->Vertex4(corner_b_r);
            sprite->TextureCrd(u, v + span);
            sprite->Vertex4(corner_t_l);
            sprite->TextureCrd(u, v + span);
            sprite->Vertex4(corner_t_l);
            sprite->TextureCrd(u + span, v);
            sprite->Vertex4(corner_b_r);
            sprite->TextureCrd(u + span, v + span);
            sprite->Vertex4(corner1);
        }
    }
}

void CMapEffectsManeger::Init_LightBoll(mgCMemory *memory, int count) {
    sprite_num = count;
    u32 blocks;

    if (((u32) count * (int) sizeof(CMapEffect_Sprite)) & 0xF) {
        blocks = (((u32) count * (int) sizeof(CMapEffect_Sprite)) >> 4) + 1;
    } else {
        blocks = ((u32) count * (int) sizeof(CMapEffect_Sprite)) >> 4;
    }

    void *block = memory->Alloc(blocks + 2);
    sprite = (CMapEffect_Sprite *) __construct_new_array(
        operator new[](count *(int) sizeof(CMapEffect_Sprite) + 0x10, (u_long128 *) block), 0, 0,
        (int) sizeof(CMapEffect_Sprite), count);

    for (int i = 0; i < count; i++) {
        sprite[i].life = 0;
    }
}

void CMapEffectsManeger::Step(mgCCamera *camera) {
    float spawn[4];
    float camera_pos[4];
    float camera_ref[4];
    float forward[4];
    float to_spawn[4];

    if (type < 0 || type >= 3) {
        return;
    }

    camera->GetPos(camera_pos);
    camera->GetRef(camera_ref);
    forward[0] = camera_ref[0] - camera_pos[0];
    forward[1] = camera_ref[1] - camera_pos[1];
    forward[2] = camera_ref[2] - camera_pos[2];
    forward[3] = 1.0f;
    sceVu0Normalize(forward, forward);

    if (spawn_wait > 0) {
        spawn_wait--;
    }

    live_num = 0;

    for (int i = 0; i < sprite_num; i++) {
        if (sprite[i].life > 0) {
            live_num++;
        }
    }

    if (live_num < sprite_num && spawn_wait <= 0) {
        for (int i = 0; i < sprite_num; i++) {
            if (sprite[i].life <= 0) {
                spawn[0] = camera_pos[0] + ((800.0f * (float) rand()) / 2.1474836e9f - 400.0f);
                spawn[1] = 5.0f + (camera_pos[1] + (50.0f * (float) rand()) / 2.1474836e9f);
                spawn[2] = camera_pos[2] + ((800.0f * (float) rand()) / 2.1474836e9f - 400.0f);
                spawn[3] = 1.0f;
                to_spawn[0] = spawn[0] - camera_pos[0];
                to_spawn[1] = spawn[1] - camera_pos[1];
                to_spawn[2] = spawn[2] - camera_pos[2];
                to_spawn[3] = 1.0f;
                sceVu0Normalize(to_spawn, to_spawn);

                if (!(sceVu0InnerProduct(forward, to_spawn) <= 0.25f)) {
                    if (type == 2) {
                        spawn[1] -= 130.0f;
                    }

                    sprite[i].Set(spawn);
                    CMapEffect_Sprite *slot = sprite + i;
                    slot->type = type;
                    spawn_wait = fptosi(1.0f + (5.0f * (float) rand()) / 2.1474836e9f);
                }

                break;
            }
        }
    }

    for (int i = 0; i < sprite_num; i++) {
        if (sprite[i].life > 0) {
            sprite[i].Step(camera);
        }
    }
}

#pragma opt_propagation off

void CMapEffectsManeger::Draw(mgCCamera *camera) {
    int                 byte_offset;
    mgCCamera          *draw_camera = camera;
    CMapEffectsManeger *manager = this;
    CPreSprite          primitive;

    if (manager->type < 0 || manager->type >= 3) {
        return;
    }

    primitive.Initialize(NULL, NULL);
    primitive.Preset2D();

    if (manager->type == 0) {
        primitive.DepthTestEnable(0);
    }

    if (manager->type == 1) {
        primitive.DepthTestEnable(1);
        primitive.DepthTest(MG_DEPTH_TEST_GEQUAL);
    }

    if (manager->type == 2) {
        primitive.DepthTestEnable(1);
        primitive.DepthTest(MG_DEPTH_TEST_GEQUAL);
    }

    primitive.Bilinear(1);
    primitive.Coord(1);
    primitive.AlphaBlend(MG_ALPHA_BLEND_ADD);
    primitive.AlphaTestEnable(1);
    primitive.Begin(MG_PRIM_TRIANGLE);
    primitive.Texture(TEX_SystemEffect1);
    int index;
    index = 0;
    byte_offset = 0;

    for (; index < manager->sprite_num; index++) {
        CMapEffect_Sprite *entry = (CMapEffect_Sprite *) ((u8 *) manager->sprite + byte_offset);

        if (entry->life > 0) {
            entry->Draw(draw_camera, &primitive);
        }

        byte_offset += sizeof(CMapEffect_Sprite);
    }

    primitive.End();
}

#pragma opt_propagation reset

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 15) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

int BattleEffectMan::AllocEffect(int kind, mgCMemory *memory, int num) {
    switch (kind) {
        case BATTLE_EFFECT_HIT: {
            u_int prim_bytes = num * 0x20 * sizeof(BattleEffectPrim);
            hit_prim = (BattleEffectPrim *) operator new[](prim_bytes, memory->Alloc(align16_blocks(prim_bytes) + 2));
            u_int hit_bytes = num * sizeof(CHitEffectImage);
            hit = new (memory->Alloc(align16_blocks(hit_bytes) + 2)) CHitEffectImage[num];
            hit_num = 0;

            if (hit == NULL || hit_prim == NULL) {
                return 0;
            }

            hit_num = num;

            for (int i = 0; i < num; i++) {
                CHitEffectImage *effect = hit + i;
                effect->spark = hit_prim + i * 0x20;
                effect->spark_max = 0x20;
                effect->live_num = 0;
                effect->spark_num = 0;
                effect->kind = 0;
            }

            break;
        }
        case BATTLE_EFFECT_FLUSH: {
            flush = (CFlushEffect *) __construct_new_array(
                operator new[](num *(int) sizeof(CFlushEffect) + 16, memory->Alloc(align16_blocks(num * sizeof(CFlushEffect)) + 2)), NULL, NULL,
                sizeof(CFlushEffect), num);
            flush_num = 0;

            if (flush == NULL) {
                return 0;
            }

            flush_num = num;

            for (int i = 0; i < num; i++) {
                CFlushEffect *effect = flush + i;
                effect->active = 0;
                effect->follow = NULL;
            }

            break;
        }
        case BATTLE_EFFECT_POWER_LINE: {
            u_int prim_bytes = num * 0x14 * sizeof(BattleEffectPrim);
            power_prim = (BattleEffectPrim *) operator new[](prim_bytes, memory->Alloc(align16_blocks(prim_bytes) + 2));
            u_int power_bytes = num * sizeof(CPowerLine);
            power = new (memory->Alloc(align16_blocks(power_bytes) + 2)) CPowerLine[num];
            power_num = 0;

            if (power == NULL) {
                return 0;
            }

            power_num = num;

            for (int i = 0; i < num; i++) {
                BattleEffectPrim *streaks = power_prim + i * 0x14;
                CPowerLine       *line = power + i;
                line->source = NULL;
                line->prim = streaks;
                line->prim_max = 0x14;
                line->duration = 0;
                line->next = 0;
                line->live_num = 0;
            }

            break;
        }
        case BATTLE_EFFECT_DEAD: {
            u_int prim_bytes = num * 0x30 * sizeof(BattleEffectPrim);
            dead_prim = (BattleEffectPrim *) operator new[](prim_bytes, memory->Alloc(align16_blocks(prim_bytes) + 2));
            u_int dead_bytes = num * sizeof(CDeadEffect);
            dead = (CDeadEffect *) __construct_new_array(
                operator new[](num *(int) sizeof(CDeadEffect) + 16, memory->Alloc(align16_blocks(dead_bytes) + 2)), NULL, NULL,
                sizeof(CDeadEffect), num);
            memset(dead_prim, 0x37, num * 0xF00);
            memset(dead, 0x37, dead_bytes);
            dead_num = 0;

            if (dead == NULL) {
                return 0;
            }

            dead_num = num;

            for (int i = 0; i < num; i++) {
                CDeadEffect      *effect = &dead[i];
                BattleEffectPrim *prim = &dead_prim[i * 0x30];
                effect->prim = prim;
                effect->prim_max = 0x30;
                effect->radius = 10.0f;
                effect->height = 10.0f;
                effect->size = 1.0f;
                effect->elapsed = 0;
                effect->duration = 0;
                effect->next = 0;
                effect->live_num = 0;
            }

            break;
        }
        case BATTLE_EFFECT_CHARA: {
            u_int chara_bytes = num * sizeof(CCharacter2);
            chara = new (memory->Alloc(align16_blocks(chara_bytes) + 2)) CCharacter2[num];
            u_int slot_bytes = num * sizeof(BattleEffectChara);
            chara_slot = (BattleEffectChara *) operator new[](slot_bytes, memory->Alloc(align16_blocks(slot_bytes) + 2));
            chara_num = num;

            for (int i = 0; i < num; i++) {
                BattleEffectChara *slot = chara_slot + i;
                slot->chara = chara + i;
                slot->unk_4 = 0;
                slot->unk_8 = 0;
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

CPowerLine::CPowerLine() {
    tex_rect.Set(0, 0, 0, 0);
    color[0] = 0x80;
    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
}

CHitEffectImage::CHitEffectImage() {
    tex_rect.Set(0, 0, 0, 0);
}

void BattleEffectMan::Step() {

    int              hit_no;
    int              flush_no;
    int              line_no;
    int              dead_no;
    CHitEffectImage *hit;
    CFlushEffect    *flush;
    CPowerLine      *line;
    CDeadEffect     *dead;

    hit = this->hit;

    if (hit != 0) {
        for (hit_no = 0; hit_no < hit_num; hit_no++) {
            hit->Step();
            hit++;
        }
    }

    flush = this->flush;

    if (flush != 0) {
        for (flush_no = 0; flush_no < flush_num; flush_no++) {
            flush->Step();
            flush++;
        }
    }

    line = power;

    if (line != 0) {
        for (line_no = 0; line_no < power_num; line_no++) {
            line->Step();
            line++;
        }
    }

    dead = this->dead;

    if (dead != 0) {
        for (dead_no = 0; dead_no < dead_num; dead_no++) {
            dead->Step();
            dead++;
        }
    }
}

void BattleEffectMan::Draw() {

    int              hit_no;
    int              flush_no;
    int              line_no;
    int              dead_no;
    CHitEffectImage *hit;
    CFlushEffect    *flush;
    CPowerLine      *line;
    CDeadEffect     *dead;

    hit = this->hit;

    if (hit != 0) {
        for (hit_no = 0; hit_no < hit_num; hit_no++) {
            hit->Draw();
            hit++;
        }
    }

    flush = this->flush;

    if (flush != 0) {
        for (flush_no = 0; flush_no < flush_num; flush_no++) {
            flush->Draw();
            flush++;
        }
    }

    line = power;

    if (line != 0) {
        for (line_no = 0; line_no < power_num; line_no++) {
            line->Draw();
            line++;
        }
    }

    dead = this->dead;

    if (dead != 0) {
        for (dead_no = 0; dead_no < dead_num; dead_no++) {
            dead->Draw();
            dead++;
        }
    }
}

void CWeaponElement::Initialize() {
    int i;

    for (i = 0; i < WEAPON_ELEMENT_SPARK_MAX; i++) {
        size[i] = 1.0f;
        alpha[i] = 1.0f;
    }

    on = 0;
}

void CWeaponElement::Set(float (*base)[4], float *center, float level, int element_type, float spread) {
    power = 0.01f * (1.0f + level);
    kind = element_type;
    this->spread = spread;
    origin = base;

    switch (element_type) {
        case WEAPON_ELEMENT_COLD:
        default:
            Init_Cold(center);
            break;
        case WEAPON_ELEMENT_WIND:
            Init_Wind(center);
            break;
        case WEAPON_ELEMENT_FIRE:
            Init_Fire(center);
            break;
        case WEAPON_ELEMENT_THUNDER:
            Init_Thunder(center);
            break;
    }

    on = 1;
}

void CWeaponElement::Step() {
    if (on != 0) {
        switch (kind) {
            case WEAPON_ELEMENT_COLD:
            default:
                this->Step_Cold();
                return;
            case WEAPON_ELEMENT_WIND:
                this->Step_Wind();
                return;
            case WEAPON_ELEMENT_FIRE:
                this->Step_Fire();
                return;
            case WEAPON_ELEMENT_THUNDER:
                this->Step_Thunder();
                break;
        }
    }
}

void CWeaponElement::Draw() {
    if (on != 0) {
        switch (kind) {
            case WEAPON_ELEMENT_COLD:
            default:
                this->Draw_Cold();
                return;
            case WEAPON_ELEMENT_WIND:
                this->Draw_Wind();
                return;
            case WEAPON_ELEMENT_FIRE:
                this->Draw_Fire();
                return;
            case WEAPON_ELEMENT_THUNDER:
                this->Draw_Thunder();
                break;
        }
    }
}

void CWeaponElement::Init_Cold(float *center) {
    int j;
    int i;

    count = fptosi(12.0f * power) + 2;

    if (count > WEAPON_ELEMENT_SPARK_MAX) {
        count = WEAPON_ELEMENT_SPARK_MAX;
    }

    spawn_budget = fptosi(10.0f * power) + 5;
    spawn_delay_max = 12 - fptosi(6.0f * power);
    spawn_delay = 0;
    frame_timer = 4;
    spread *= (float) (0.8 + 0.4f * power);
    scale = 0.5f + 0.7f * power;

    for (i = 0; i < WEAPON_ELEMENT_SPARK_MAX; i++) {
        shrink[i] = 0.0f;
        alpha[i] = 0.0f;
    }

    for (j = 0; j < count; j++) {
        size[j] = 3.0f + (6.0f * (float) rand()) / 2.1474836e9f;
        shrink[j] = 1.0f;
        alpha[j] = 1.0f + (48.0f * (float) rand()) / 2.1474836e9f;
        fading[j] = 0;
        offset[j][0] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][1] = spread / 2.0f + (spread * (float) rand()) / 2.1474836e9f;
        offset[j][2] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][3] = 1.0f;
        frame[j] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
    }
}

void CWeaponElement::Step_Cold() {
    int dead;
    int i;
    int j;

    dead = 0;
    i = 0;

    do {
        if (alpha[i] <= 0.0f) {
            dead += 1;
        } else {
            offset[i][1] -= 0.2f + (0.6f * (float) rand()) / 2.1474836e9f;
            shrink[i] -= 0.01f;

            if (shrink[i] <= 0.0f) {
                shrink[i] = 0.0f;
                alpha[i] = 0.0f;
            }

            if (frame_timer == 4) {
                frame[i] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
            }

            if (fading[i] != 0) {
                alpha[i] -= 12.0f;

                if (alpha[i] <= 0.0f) {
                    alpha[i] = 0.0f;
                }
            } else {
                alpha[i] += 24.0f;

                if (!(alpha[i] < 128.0f)) {
                    fading[i] = 1;
                }
            }
        }

        i += 1;
    } while (i < WEAPON_ELEMENT_SPARK_MAX);

    frame_timer -= 1;

    if (frame_timer == 0) {
        frame_timer = 4;
    }

    if (spawn_budget > 0) {
        spawn_budget -= 2;
        spawn_delay -= 1;

        if (spawn_delay <= 0) {
            for (j = 0; j < WEAPON_ELEMENT_SPARK_MAX; j++) {
                if (alpha[j] == 0.0f) {
                    size[j] = 3.0f + (6.0f * (float) rand()) / 2.1474836e9f;
                    shrink[j] = 1.0f;
                    alpha[j] = 1.0f + (48.0f * (float) rand()) / 2.1474836e9f;
                    fading[j] = 0;
                    offset[j][0] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][1] = spread / 2.0f + (spread * (float) rand()) / 2.1474836e9f;
                    offset[j][2] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][3] = 1.0f;
                    frame[j] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
                    spawn_delay = fptosi(((float) spawn_delay_max * (float) rand()) / 2.1474836e9f) + 1;
                    break;
                }
            }
        }
    }

    if (dead >= WEAPON_ELEMENT_SPARK_MAX) {
        on = 0;
    }
}

void CWeaponElement::Draw_Cold() {
    float base[4];

    struct {
        float v[3];
        int   w;
    } pos;

    mgCTexture *tex;
    int         i;

    tex = mgTexManager.GetTexture("effect02", -1);
    sceVu0CopyVector(base, *origin);
    pos.w = 0x3F800000;

    CPreSprite prim;
    int        quad_a[4];
    int        quad_b[4];

    prim.Initialize(NULL, NULL);
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(tex);

    for (i = 0; i < WEAPON_ELEMENT_SPARK_MAX; i++) {
        int    tex_row = frame[i];
        float *particle_alpha = &alpha[i];

        if (*particle_alpha > 0.0f) {
            float sprite_size = scale * (this->size[i] * shrink[i]);
            pos.v[0] = base[0] + offset[i][0];
            pos.v[1] = base[1] + offset[i][1];
            pos.v[2] = base[2] + offset[i][2];

            if (mgTransWorldPrim3DSprite(quad_a, quad_b, pos.v, sprite_size, sprite_size, 0) != 0) {
                prim.Color(0x80, 0x80, 0x80, fptosi(*particle_alpha));
                prim.TextureCrd(0xA0, tex_row);
                prim.Vertex4(quad_a);
                prim.TextureCrd(0xD0, tex_row + 0x30);
                prim.Vertex4(quad_b);
            }
        }
    }

    prim.End();
}

void CWeaponElement::Init_Wind(float *center) {
    int i;
    int j;

    count = fptosi(10.0f * power) + 1;
    spawn_budget = fptosi(20.0f * power) + 10;
    spawn_delay_max = 8 - fptosi(4.0f * power);
    spawn_delay = 0;
    frame_timer = 4;
    spread *= (float) (0.8 + 0.4f * power);
    scale = 0.5f + 1.3f * (0.7f * power);

    for (i = 0; i < WEAPON_ELEMENT_SPARK_MAX; i++) {
        shrink[i] = 0.0f;
        alpha[i] = 0.0f;
    }

    for (j = 0; j < count; j++) {
        size[j] = 2.0f + (4.0f * (float) rand()) / 2.1474836e9f;
        shrink[j] = 1.0f;
        alpha[j] = 1.0f + (48.0f * (float) rand()) / 2.1474836e9f;
        fading[j] = 0;
        offset[j][0] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][1] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][2] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][3] = 1.0f;
        sceVu0CopyVector(&velocity[j][0], &offset[j][0]);
        sceVu0Normalize(&velocity[j][0], &velocity[j][0]);
        sceVu0ScaleVector(&velocity[j][0], &velocity[j][0], (0.3f * (float) rand()) / 2.1474836e9f);
        spin[j] = (2.0f * (3.1415927f * (float) rand())) / 2.1474836e9f - 3.1415927f;
        spin_speed[j] = 0.09817477f + (0.19634955f * (float) rand()) / 2.1474836e9f;
        frame[j] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
    }
}

void CWeaponElement::Step_Wind() {
    int dead;
    int i;
    int j;

    dead = 0;
    i = 0;

    do {
        if (alpha[i] <= 0.0f) {
            dead += 1;
        } else {
            if (fading[i] != 0) {
                alpha[i] -= 4.0f;

                if (alpha[i] <= 0.0f) {
                    alpha[i] = 0.0f;
                }
            } else {
                alpha[i] += 32.0f;

                if (!(alpha[i] < 128.0f)) {
                    fading[i] = 1;
                }
            }

            if (frame_timer == 4) {
                frame[i] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
            }

            spin[i] += spin_speed[i];

            if (!(spin[i] <= 3.1415927f)) {
                spin[i] -= 6.2831855f;
            }

            offset[i][0] += velocity[i][0];
            offset[i][1] += 0.2f;
            offset[i][2] += velocity[i][2];
        }

        i += 1;
    } while (i < WEAPON_ELEMENT_SPARK_MAX);

    frame_timer -= 1;

    if (frame_timer == 0) {
        frame_timer = 4;
    }

    if (spawn_budget > 0) {
        spawn_budget -= 1;
        spawn_delay -= 1;

        if (spawn_delay <= 0) {
            for (j = 0; j < WEAPON_ELEMENT_SPARK_MAX; j++) {
                if (alpha[j] == 0.0f) {
                    size[j] = 2.0f + (4.0f * (float) rand()) / 2.1474836e9f;
                    shrink[j] = 1.0f;
                    alpha[j] = 1.0f + (48.0f * (float) rand()) / 2.1474836e9f;
                    fading[j] = 0;
                    offset[j][0] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][1] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][2] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][3] = 1.0f;
                    sceVu0CopyVector(&velocity[j][0], &offset[j][0]);
                    sceVu0Normalize(&velocity[j][0], &velocity[j][0]);
                    sceVu0ScaleVector(&velocity[j][0], &velocity[j][0],
                                      (0.3f * (float) rand()) / 2.1474836e9f);
                    spin[j] = (2.0f * (3.1415927f * (float) rand())) / 2.1474836e9f - 3.1415927f;
                    spin_speed[j] = 0.09817477f + (0.19634955f * (float) rand()) / 2.1474836e9f;
                    frame[j] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
                    spawn_delay = fptosi(((float) spawn_delay_max * (float) rand()) / 2.1474836e9f) + 1;
                    break;
                }
            }
        }
    }

    if (dead >= WEAPON_ELEMENT_SPARK_MAX) {
        on = 0;
    }
}

void CWeaponElement::Draw_Wind() {
    float base[4];

    struct {
        float v[3];
        int   w;
    } pos;

    mgCTexture *tex;
    int         i;

    tex = mgTexManager.GetTexture("effect02", -1);
    sceVu0CopyVector(base, *origin);
    pos.w = 0x3F800000;

    CPreSprite prim;
    float      identity[4][4];
    float      rotation[4][4];
    int        quad_a[4];
    int        quad_b[4];

    prim.Initialize(NULL, NULL);
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(tex);

    for (i = 0; i < WEAPON_ELEMENT_SPARK_MAX; i++) {
        int    tex_row = frame[i];
        float *particle_alpha = &alpha[i];

        if (*particle_alpha > 0.0f) {
            float sprite_size = scale * (this->size[i] * shrink[i]);
            sceVu0UnitMatrix(identity);
            sceVu0RotMatrixY(rotation, identity, spin[i]);
            sceVu0ApplyMatrix(pos.v, rotation, &offset[i][0]);
            pos.v[0] += base[0];
            pos.v[1] += base[1];
            pos.v[2] += base[2];

            if (mgTransWorldPrim3DSprite(quad_a, quad_b, pos.v, sprite_size, sprite_size, 0) != 0) {
                prim.Color(0x80, 0x80, 0x80, fptosi(*particle_alpha));
                prim.TextureCrd(0x60, tex_row);
                prim.Vertex4(quad_a);
                prim.TextureCrd(0xA0, tex_row + 0x30);
                prim.Vertex4(quad_b);
            }
        }
    }

    prim.End();
}

void CWeaponElement::Init_Fire(float *center) {
    int i;
    int j;

    count = fptosi(12.0f * power) + 2;

    if (count > WEAPON_ELEMENT_SPARK_MAX) {
        count = WEAPON_ELEMENT_SPARK_MAX;
    }

    spawn_budget = fptosi(10.0f * power) + 5;
    spawn_delay_max = 6 - fptosi(3.0f * power);
    spawn_delay = 0;
    frame_timer = 4;
    spread *= (float) (0.8 + 0.4f * power);
    scale = 0.5f + 0.7f * power;
    sceVu0CopyVector(fire_pos, center);

    for (i = 0; i < WEAPON_ELEMENT_SPARK_MAX; i++) {
        shrink[i] = 0.0f;
        alpha[i] = 0.0f;
    }

    for (j = 0; j < count; j++) {
        size[j] = 2.0f + (6.0f * (float) rand()) / 2.1474836e9f;
        shrink[j] = 1.0f;
        alpha[j] = 1.0f + (48.0f * (float) rand()) / 2.1474836e9f;
        fading[j] = 0;
        offset[j][0] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][1] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][2] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
        offset[j][3] = 1.0f;
        frame[j] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
    }
}

void CWeaponElement::Step_Fire() {
    int dead;
    int i;
    int j;

    dead = 0;
    i = 0;

    do {
        if (alpha[i] <= 0.0f) {
            dead += 1;
        } else {
            offset[i][1] += 0.02f + (1.2f * (float) rand()) / 2.1474836e9f;
            shrink[i] -= 0.01f;

            if (shrink[i] <= 0.0f) {
                shrink[i] = 0.0f;
                alpha[i] = 0.0f;
            }

            if (frame_timer == 4) {
                frame[i] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
            }

            if (fading[i] != 0) {
                alpha[i] -= 8.0f;

                if (alpha[i] <= 0.0f) {
                    alpha[i] = 0.0f;
                }
            } else {
                alpha[i] += 16.0f;

                if (!(alpha[i] < 128.0f)) {
                    fading[i] = 1;
                }
            }
        }

        i += 1;
    } while (i < WEAPON_ELEMENT_SPARK_MAX);

    frame_timer -= 1;

    if (frame_timer == 0) {
        frame_timer = 4;
    }

    if (spawn_budget > 0) {
        spawn_budget -= 1;
        spawn_delay -= 1;

        if (spawn_delay <= 0) {
            for (j = 0; j < WEAPON_ELEMENT_SPARK_MAX; j++) {
                if (alpha[j] == 0.0f) {
                    size[j] = 2.0f + (6.0f * (float) rand()) / 2.1474836e9f;
                    shrink[j] = 1.0f;
                    alpha[j] = 1.0f + (48.0f * (float) rand()) / 2.1474836e9f;
                    fading[j] = 0;
                    offset[j][0] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][1] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][2] = (2.0f * (spread * (float) rand())) / 2.1474836e9f - spread;
                    offset[j][3] = 1.0f;
                    frame[j] = fptosi((5.0f * (float) rand()) / 2.1474836e9f) * 0x30;
                    spawn_delay = fptosi(((float) spawn_delay_max * (float) rand()) / 2.1474836e9f) + 1;
                    break;
                }
            }
        }
    }

    if (dead >= WEAPON_ELEMENT_SPARK_MAX) {
        on = 0;
    }
}

void CWeaponElement::Draw_Fire() {
    float base[4];

    struct {
        float v[3];
        int   w;
    } pos;

    mgCTexture *tex;
    int         i;

    tex = mgTexManager.GetTexture("effect02", -1);
    sceVu0CopyVector(base, fire_pos);
    pos.w = 0x3F800000;

    CPreSprite prim;
    int        quad_a[4];
    int        quad_b[4];

    prim.Initialize(NULL, NULL);
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(tex);

    for (i = 0; i < WEAPON_ELEMENT_SPARK_MAX; i++) {
        int    tex_row = frame[i];
        float *particle_alpha = &alpha[i];

        if (*particle_alpha > 0.0f) {
            float sprite_size = scale * (this->size[i] * shrink[i]);
            pos.v[0] = base[0] + offset[i][0];
            pos.v[1] = base[1] + offset[i][1];
            pos.v[2] = base[2] + offset[i][2];

            if (mgTransWorldPrim3DSprite(quad_a, quad_b, pos.v, sprite_size, sprite_size, 0) != 0) {
                prim.Color(0x80, 0x80, 0x80, fptosi(*particle_alpha));
                prim.TextureCrd(0x30, tex_row);
                prim.Vertex4(quad_a);
                prim.TextureCrd(0x60, tex_row + 0x30);
                prim.Vertex4(quad_b);
            }
        }
    }

    prim.End();
}

void CWeaponElement::Init_Thunder(float *center) {
    float scaled[4];
    float dir[4];
    int   i;
    int   j;

    count = fptosi(18.0f * power) + 6;
    bolt_count = fptosi(7.0f * power) + 1;

    if (count > WEAPON_ELEMENT_SPARK_MAX) {
        count = WEAPON_ELEMENT_SPARK_MAX;
    }

    if (bolt_count > WEAPON_ELEMENT_BOLT_MAX) {
        bolt_count = WEAPON_ELEMENT_BOLT_MAX;
    }

    spread *= (float) (0.8 + 0.4f * power);

    for (i = 0; i < count; i++) {
        velocity[i][0] = (8.0f * (float) rand()) / 2.1474836e9f - 4.0f;
        velocity[i][1] = (8.0f * (float) rand()) / 2.1474836e9f - 4.0f;
        velocity[i][2] = (8.0f * (float) rand()) / 2.1474836e9f - 4.0f;
        sceVu0Normalize(dir, &velocity[i][0]);
        sceVu0ScaleVectorXYZ(scaled, dir, spread);
        offset[i][0] = center[0] + velocity[i][0] + (scaled[0] * (float) rand()) / 2.1474836e9f;
        offset[i][1] = center[1] + velocity[i][1] + (scaled[1] * (float) rand()) / 2.1474836e9f;
        offset[i][2] = center[2] + velocity[i][2] + (scaled[2] * (float) rand()) / 2.1474836e9f;
        offset[i][3] = 1.0f;
        sceVu0ScaleVectorXYZ(&velocity[i][0], dir, (0.3f * (float) rand()) / 2.1474836e9f);
        size[i] = 0.5f + (2.5f * (float) rand()) / 2.1474836e9f;
        shrink[i] = 1.0f;
        alpha[i] = 96.0f + (float) fptosi((64.0f * (float) rand()) / 2.1474836e9f);
    }

    for (j = 0; j < bolt_count; j++) {
        bolt_head[j] = fptosi(((float) count * (float) rand()) / 2.1474836e9f);
        bolt_tail[j] = fptosi(((float) count * (float) rand()) / 2.1474836e9f);
        bolt_timer[j] = fptosi((6.0f * (float) rand()) / 2.1474836e9f) * 3 + 3;
        bolt_frame[j] = fptosi((4.0f * (float) rand()) / 2.1474836e9f);
    }
}

void CWeaponElement::Step_Thunder() {
    int dead;
    int i;
    int j;

    dead = 0;

    for (i = 0; i < count; i++) {
        if (alpha[i] <= 0.0f) {
            dead += 1;
        } else {
            offset[i][0] += velocity[i][0];
            offset[i][1] += velocity[i][1];
            offset[i][2] += velocity[i][2];
            shrink[i] -= 0.01f;
            alpha[i] -= 4.0f;

            if (alpha[i] <= 3.0f) {
                alpha[i] = 0.0f;
            }
        }
    }

    if (dead >= count) {
        on = 0;
        return;
    }

    for (j = 0; j < bolt_count; j++) {
        bolt_timer[j] -= 1;

        if (bolt_timer[j] <= 0) {
            bolt_head[j] = (int) (((float) count * (float) rand()) / 2.1474836e9f);
            bolt_tail[j] = (int) (((float) count * (float) rand()) / 2.1474836e9f);
            bolt_timer[j] = (int) ((6.0f * (float) rand()) / 2.1474836e9f) * 3 + 3;
            bolt_frame[j] = (int) ((4.0f * (float) rand()) / 2.1474836e9f);
        } else if (bolt_timer[j] % 3 == 0) {
            bolt_frame[j] += 1;

            if (bolt_frame[j] >= 4) {
                bolt_frame[j] = 0;
            }
        }
    }
}

void CWeaponElement::Draw_Thunder() {
    int         quad[4][4];
    float       base[4];
    mgCTexture *tex;
    int         i;
    int         j;

    tex = mgTexManager.GetTexture("effect02", -1);
    sceVu0CopyVector(base, *origin);
    CPreSprite prim;
    int        quad_a[4];
    int        quad_b[4];
    prim.Initialize(NULL, NULL);
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(tex);

    for (i = 0; i < count; i++) {
        if (alpha[i] > 0.0f) {
            float spark_size = size[i] * shrink[i];

            if (mgTransWorldPrim3DSprite(quad_a, quad_b, offset[i], spark_size, spark_size / 2.0f, 0) != 0) {
                prim.Color(0x80, 0x80, 0x80, fptosi(alpha[i]));
                prim.TextureCrd(0, 0);
                prim.Vertex4(quad_a);
                prim.TextureCrd(0x30, 0x30);
                prim.Vertex4(quad_b);
            }
        }
    }

    prim.End();
    int bolt_uv[4][2] = {
        {0,    0x30},
        {0x18, 0x30},
        {0,    0x98},
        {0,    0x98}
    };
    float head[4];
    float tail[4];
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_TRIANGLE_STRIP);
    prim.Texture(tex);

    for (j = 0; j < bolt_count; j++) {
        sceVu0CopyVector(head, offset[bolt_head[j]]);
        head[1] += 1.0f;
        mgTransWorldPrim(quad[0], head);
        head[1] -= 2.0f;
        mgTransWorldPrim(quad[1], head);
        sceVu0CopyVector(tail, offset[bolt_tail[j]]);
        head[1] += 1.0f;
        mgTransWorldPrim(quad[2], head);
        head[1] -= 2.0f;
        mgTransWorldPrim(quad[3], head);
        int   u = bolt_uv[bolt_frame[j]][0];
        int   v = bolt_uv[bolt_frame[j]][1];
        float bolt_alpha = 1.6f * alpha[bolt_head[j]];
        prim.Color(0x80, 0x80, 0x80, bolt_alpha);
        prim.TextureCrd(u, v);
        prim.Vertex4(quad[0]);
        prim.TextureCrd(u + 0x18, v);
        prim.Vertex4(quad[1]);
        prim.TextureCrd(u, v + 0x68);
        prim.Vertex4(quad[2]);
        prim.TextureCrd(u + 0x18, v + 0x68);
        prim.Vertex4(quad[3]);
        sceVu0SubVector(tail, head, base);
        sceVu0Normalize(tail, tail);
        sceVu0ScaleVector(tail, tail, fRand(15.0f));
        sceVu0AddVector(tail, tail, offset[j]);
        tail[1] += 1.0f;
        mgTransWorldPrim(quad[0], tail);
        tail[1] -= 2.0f;
        mgTransWorldPrim(quad[1], tail);
        prim.TextureCrd(u, v);
        prim.Vertex4(quad[0]);
        prim.TextureCrd(u + 0x18, v);
        prim.Vertex4(quad[1]);
        prim.TextureCrd(u, v + 0x68);
        prim.Vertex4(quad[2]);
        prim.TextureCrd(u + 0x18, v + 0x68);
        prim.Vertex4(quad[3]);
    }

    prim.End();
}

int CreatSmoothPass(sceVu0FVECTOR *out, sceVu0FVECTOR *ring, int point_num, int division, int start, int ring_size) {
    sceVu0FMATRIX coefficients;
    sceVu0FMATRIX points;
    sceVu0FMATRIX basis;
    float         powers[4];
    float         result[4];
    int           control[4];

    if (point_num < 3) {
        return 0;
    }

    float quarter = 0.25f;
    float half;
    half = 0.5f;
    basis[3][0] = 0.0f;
    basis[1][0] = 1.0f;
    basis[2][1] = 0.0f;
    basis[0][0] = -quarter / half;
    basis[0][1] = 1.5f;
    basis[2][0] = basis[0][0];
    basis[1][1] = -(quarter + 1.0f) / half;
    basis[3][1] = 1.0f;
    basis[3][2] = 0.0f;
    basis[0][2] = (-half - quarter) / half;
    basis[2][2] = half;
    basis[1][2] = 2.0f;
    basis[0][3] = half;
    basis[1][3] = -basis[0][3];
    basis[2][3] = 0.0f;
    basis[3][3] = 0.0f;
    int written = 0;

    for (int segment = 0; segment < point_num - 1; segment++) {
        if (segment > 0 && segment < point_num - 2) {
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

            if (segment >= point_num - 2) {
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

        float *p0 = ring[control[0]];
        float *p1 = ring[control[1]];
        float *p2 = ring[control[2]];
        float *p3 = ring[control[3]];
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
            powers[0] = t * (t * t);
            powers[3] = 1.0f;
            powers[1] = t * t;
            powers[2] = t;
            sceVu0ApplyMatrix(result, coefficients, powers);

            for (int j = 0; j < 3; j++) {
                out[written][j] = result[j];
            }

            out[written][3] = 1.0f;
            t += step;
            written++;
        }
    }

    return written;
}

float unitRotation(mgCFrame *frame, float target, float speed) {
    float rot[4];
    float diff;
    float abs_diff;

    frame->GetRotation(rot);
    diff = target - rot[1];
    abs_diff = diff;

    if (diff <= 0.0f) {
        abs_diff = -1.0f * diff;
    }

    if (abs_diff <= 3.1415927f) {
        if (abs_diff <= 3.1415927f / speed) {
            diff = 0.0f;
        }
    } else if (6.2831855f - abs_diff <= 3.1415927f / speed) {
        diff = 0.0f;
    }

    if (!(diff <= 0.0f)) {
        if (diff <= 3.1415927f) {
            rot[1] += 3.1415927f / (2.0f * speed);
        } else {
            rot[1] -= 3.1415927f / speed;
        }
    }

    if (diff < 0.0f) {
        if (!(diff < -3.1415927f)) {
            rot[1] -= 3.1415927f / (2.0f * speed);
        } else {
            rot[1] += 3.1415927f / speed;
        }
    }

    if (diff == 0.0f) {
        rot[1] = target;
    }

    if (rot[1] <= -3.1415927f) {
        rot[1] += 6.2831855f;
    }

    if (!(rot[1] < 3.1415927f)) {
        rot[1] -= 6.2831855f;
    }

    return rot[1];
}

int iRand(int limit) {
    return (int) (((float) limit * (float) rand()) / 2.1474836e9f);
}

float fRand(float limit) {
    return (limit * (float) rand()) / 2.1474836e9f;
}
