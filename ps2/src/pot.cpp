#include "common.h"

#include <cmath>
#include <cstdio>

#include "character.hpp"
#include "collision.hpp"
#include "dng_main.hpp"
#include "effscript.hpp"
#include "mainloop.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "pot.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "sound.hpp"

// Code (.text)
void CalcReflectionVector(float *incoming, float *surface, float *reflected) {
    float normal[4];
    float dx;
    float dy;
    float dz;
    float dot;
    sceVu0Normalize(normal, surface);
    normal[3] = 1.0f;
    dx = -1.0f * incoming[0];
    dy = -1.0f * incoming[1];
    dz = -1.0f * incoming[2];
    dot = dx * normal[0] + dy * normal[1] + dz * normal[2];
    reflected[0] = 2.0f * normal[0] * dot - dx;
    reflected[1] = 2.0f * normal[1] * dot - dy;
    reflected[2] = 2.0f * normal[2] * dot - dz;
    reflected[3] = 1.0f;
}

void CFragment::Draw(float *camera_pos, float obj_alpha) {
    if (active != 0 && frame != NULL) {
        mgCFrameAttr *attr = frame->attr;
        float         relative[4];

        if (attr != NULL) {
            attr->draw |= 1;
            attr->obj_alpha = obj_alpha;
            frame->attr = attr;
        }

        sceVu0SubVector(relative, position, camera_pos);
        frame->SetPosition(relative);
        frame->SetRotation(rotation);
    }
}

void CFragment::Step(CCPoly *polys, int poly_count) {
    float next_position[4];
    float hit_position[4];
    float reflected[4];
    int   hit_indices[32];
    float hit_points[64][4];
    int   hit;
    int   hit_count;
    int   moved;
    int   i;
    int   axis;
    float delta_x;
    float delta_z;

    if (active != 0) {
        moved = 1;
        next_position[0] = position[0] + velocity[0];
        next_position[1] = position[1] + velocity[1];
        next_position[2] = position[2] + velocity[2];
        next_position[3] = 1.0f;
        mgDistVector(velocity);
        hit = CheckHit(polys, poly_count, position, next_position, hit_position, moved, 4);

        if (0 <= hit) {
            moved = 0;
            CalcReflectionVector(velocity, polys[hit].normal, reflected);
            sceVu0ScaleVector(reflected, reflected, 0.5f);
            reflected[3] = 1.0f;
        } else {
            hit_count = CheckHits(polys, poly_count, position, next_position, 0x20, hit_indices,
                                  hit_points, moved, 0);

            if (hit_count != 0) {
                for (i = 0; i < hit_count; i++) {
                    s16 kind = polys[hit_indices[i]].area_kind;

                    switch (kind) {
                        case 1:
                        case 7: {
                            CEffectScriptMan *effects =
                                GetMainScene()->GetEffect(0);

                            if (effects != NULL) {
                                effects->CreateEffSpt("\x91\xAB\x90\x85\x83\x70\x83\x56\x83\x83", -1, 0);
                                effects->SetScriptVect1(hit_points[i], -1, -1);
                            }

                            break;
                        }
                    }
                }
            }
        }

        delta_x = next_position[0] - position[0];
        delta_z = next_position[2] - position[2];

        if (moved != 0) {
            position[0] = next_position[0];
            position[1] = next_position[1];
            position[2] = next_position[2];
            position[3] = 1.0f;
            velocity[0] += gravity[0];
            velocity[1] += gravity[1];
            velocity[2] += gravity[2];
            velocity[3] = 1.0f;
        } else {
            position[0] = hit_position[0];
            position[1] = hit_position[1];
            position[2] = hit_position[2];
            position[3] = 1.0f;
            velocity[0] = reflected[0];
            velocity[1] = reflected[1];
            velocity[2] = reflected[2];
            velocity[3] = 1.0f;
        }

        rotation[0] = rotation[0] - 0.0625f * delta_x;
        rotation[1] = 0.0f;
        rotation[2] -= 0.0625f * delta_z;

        for (axis = 0; axis < 3; axis++) {
            if (rotation[axis] < -3.1415927f) {
                rotation[axis] += 6.2831855f;
            }

            if (3.1415927f < rotation[axis]) {
                rotation[axis] -= 6.2831855f;
            }
        }
    }
}

void CFragment::Set(float *pos, float *vel) {
    active = 1;
    sceVu0CopyVector(position, pos);
    sceVu0CopyVector(velocity, vel);
    gravity[0] = 0.0f;
    gravity[1] = -0.5f;
    gravity[2] = 0.0f;
    gravity[3] = 1.0f;
}

void CFragment::Init() {
    no = -1;
    active = 0;
    InitVector(position);
    InitVector(velocity);
    InitVector(gravity);
    InitVector(rotation);
    frame = NULL;
}

void CBPot::Clash(float *hit_position, float *unused, float *normal) {
    float shard_velocity[4];
    float shard_position[4];
    int   i;
    int   direction_index;
    int   fragment_index;
    timer = BPOT_BREAK_TIME;
    sceVu0CopyVector(position, hit_position);

    if (this->parts != NULL) {
        this->parts->Show(1);
        this->parts->SetPosition(hit_position);
    }

    i = 0;

    if (this->frame != NULL) {
        mgCFrameAttr *attr = this->frame->attr;

        if (attr != NULL) {
            attr->draw |= 1;
            this->frame->attr = attr;
        }

        this->frame->SetPosition(hit_position);
        i = 0;
    }

    direction_index = 0;
    fragment_index = 0;

    for (; i < fragment_num; i++) {
        float *source = offset[direction_index];
        sceVu0ScaleVector(shard_velocity, source, 0.25f);
        shard_velocity[3] = 1.0f;
        sceVu0AddVector(shard_velocity, shard_velocity, normal);
        shard_velocity[3] = 1.0f;
        sceVu0AddVector(shard_position, hit_position, offset[direction_index]);
        shard_position[3] = 1.0f;
        fragment[fragment_index].Set(shard_position, shard_velocity);
        direction_index++;
        fragment_index++;
    }
}

void CBPot::Step() {
    mgVu0FBOX box;
    CCPoly    polys[0x200];
    float     fade;
    int       poly_count;
    int       i;
    int       j;

    if (timer > 1) {
        box.max[0] = 100.0f + position[0];
        box.min[0] = position[0] - 100.0f;
        box.max[1] = 100.0f + position[1];
        box.min[1] = position[1] - 100.0f;
        box.max[2] = 100.0f + position[2];
        box.min[2] = position[2] - 100.0f;
        box.max[3] = 1.0f;
        box.min[3] = 1.0f;
        poly_count = GetMainScene()->GetColPoly(polys, box, 0x200);
        timer--;

        for (i = 0; i < fragment_num; i++) {
            fragment[i].Step(polys, poly_count);
        }
    } else if (timer == 1) {
        if (this->parts != NULL) {
            this->parts->Show(0);
        }
    }

    fade = 1.0f;

    if (timer < BPOT_FADE_TIME) {
        fade = (float) timer / 30.0f;
    }

    for (j = 0; j < fragment_num; j++) {
        fragment[j].Draw(position, fade);
    }
}

int CBPot::SetObject2(int kind, CMapParts *map_parts) {
    char  name[0x20];
    char *prefix;
    int   found;
    int   i;

    if (map_parts == NULL) {
        return 0;
    }

    this->parts = map_parts;

    if (kind == 0) {
        type = BPOT_TYPE_BOX;
    } else if (kind == 5) {
        type = BPOT_TYPE_ROCK1;
    } else if (kind > 0 && kind < 5) {
        type = BPOT_TYPE_ROCK0;
    } else if (kind == 6) {
        type = BPOT_TYPE_ROCK0;
    } else {
        return 0;
    }

    if (type == BPOT_TYPE_BOX) {
        fragment_num = 12;
        prefix = "box";
        offset = box_offset;
    } else if (type == BPOT_TYPE_ROCK0) {
        fragment_num = 10;
        prefix = "rock";
        offset = iwa0_offset;
    } else if (type == BPOT_TYPE_ROCK1) {
        fragment_num = 9;
        prefix = "rock";
        offset = iwa1_offset;
    } else {
        return 0;
    }

    piece = this->parts->SearchPiece("rnd_obj02-m0");

    if (piece == NULL) {
        return 0;
    }

    this->frame = piece->frame;

    if (this->frame == NULL) {
        return 0;
    }

    found = 0;

    for (i = 0; i < fragment_num; i++) {
        if (i >= BPOT_FRAGMENT_MAX) {
            return found;
        }

        mgCFrame *frame;
        sprintf(name, "%s%02d", prefix, i + 1);
        frame = this->frame->SearchFrame(name);

        if (frame != NULL) {
            fragment[i].no = found;
            fragment[i].frame = frame;
            found++;
        }
    }

    return found;
}

void CBPot::Init() {
    int i;
    this->parts = NULL;
    piece = NULL;
    this->frame = NULL;
    InitVector(position);
    timer = 0;
    type = BPOT_TYPE_NONE;
    fragment_num = 0;

    for (i = 0; i < BPOT_FRAGMENT_MAX; i++) {
        fragment[i].Init();
    }

    offset = NULL;
}

void CPot::HoldStep() {
    if (parts != NULL) {

        parts->GetPosition(position);
        sceVu0CopyVector(prev_hold_pos, hold_pos);
        sceVu0CopyVector(hold_pos, position);
    }
}

int CPot::FlyStep() {
    float     next_position[4];
    float     normal[4];
    float     hit_position[4];
    float     reflected[4];
    mgVu0FBOX bounds;
    CCPoly    polys[512];
    int       hit_indices[32];
    float     hit_points[64][4];

    if (parts == NULL) {
        return POT_STEP_NONE;
    }

    fly_time++;

    if (fly_time >= POT_FLY_TIME_MAX) {
        Init(0);
        return POT_STEP_TIMEOUT;
    }

    int moved = 1;
    next_position[0] = position[0] + velocity[0];
    next_position[1] = position[1] + velocity[1];
    next_position[2] = position[2] + velocity[2];
    next_position[3] = 1.0f;
    mgDistVector(velocity);
    CMapPiece *piece = parts->SearchPiece("rnd_obj01-a");

    if (piece != NULL) {
        piece->Show(0);
    }

    bounds.max[0] = 100.0f + position[0];
    bounds.min[0] = position[0] - 100.0f;
    bounds.max[1] = 100.0f + position[1];
    bounds.min[1] = position[1] - 100.0f;
    bounds.max[2] = 100.0f + position[2];
    bounds.min[2] = position[2] - 100.0f;
    bounds.max[3] = 1.0f;
    bounds.min[3] = 1.0f;
    int poly_count = GetMainScene()->GetColPoly(polys, bounds, 512);
    int hit = CheckHit(polys, poly_count, position, next_position, hit_position, 1, 4);

    if (0 <= hit) {
        moved = 0;
        sceVu0CopyVector(normal, polys[hit].normal);
        CalcReflectionVector(velocity, polys[hit].normal, reflected);
        sceVu0ScaleVector(reflected, reflected, 0.5f);
        reflected[3] = 1.0f;
    } else {
        int hit_count = CheckHits(polys, poly_count, position, next_position, 32,
                                  hit_indices, hit_points, 1, 0);

        if (hit_count != 0) {
            for (int i = 0; i < hit_count; i++) {
                switch (polys[hit_indices[i]].area_kind) {
                    case 1:
                    case 7: {
                        CEffectScriptMan *effects = GetMainScene()->GetEffect(0);

                        if (effects != NULL) {
                            effects->CreateEffSpt("\x91\xAB\x90\x85\x83\x70\x83\x56\x83\x83", -1, 0);
                            effects->SetScriptVect1(hit_points[i], -1, -1);
                        }

                        break;
                    }
                }
            }
        }
    }

    if (moved != 0) {
        position[0] = next_position[0];
        position[1] = next_position[1];
        position[2] = next_position[2];
        position[3] = 1.0f;
        velocity[0] += gravity[0];
        velocity[1] += gravity[1];
        velocity[2] += gravity[2];
        velocity[3] = 1.0f;
        parts->SetPosition(position);
        return POT_STEP_NONE;
    }

    position[0] = hit_position[0];
    position[1] = hit_position[1];
    position[2] = hit_position[2];
    position[3] = 1.0f;
    u32 se_handle = GetMainScene()->se_battle_id;

    if (BTsubo2.type == BPOT_TYPE_BOX) {
        sndSePlay(se_handle, 0x39, 0);
    } else if (BTsubo2.type == BPOT_TYPE_ROCK0) {
        sndSePlay(se_handle, 0x3A, 0);
    } else if (BTsubo2.type == BPOT_TYPE_ROCK1) {
        sndSePlay(se_handle, 0x3B, 0);
    }

    BTsubo2.Clash(position, normal, reflected);
    sceVu0CopyVector(break_pos, position);
    float parts_position[4];
    parts->GetPosition(parts_position);
    parts_position[1] -= 1000.0f;
    parts->SetPosition(parts_position);
    Init(1);
    return POT_STEP_BREAK;
}

void CPot::Clear() {
    if (parts != NULL) {
        float parts_position[4];
        sceVu0CopyVector(break_pos, position);
        parts->GetPosition(parts_position);
        parts_position[1] -= 1000.0f;
        parts->SetPosition(parts_position);
        Init(1);
    }
}

void CPot::Bakuhatsu(float *position_, float *normal) {
    if (parts != NULL) {
        u32 se_handle = GetMainScene()->se_battle_id;

        if (BTsubo2.type == BPOT_TYPE_BOX) {
            sndSePlay(se_handle, 0x39, 0);
        } else if (BTsubo2.type == BPOT_TYPE_ROCK0) {
            sndSePlay(se_handle, 0x3A, 0);
        } else if (BTsubo2.type == BPOT_TYPE_ROCK1) {
            sndSePlay(se_handle, 0x3B, 0);
        }

        BTsubo2.Clash(position, position_, normal);
        Clear();
    }
}

int CPot::Step() {
    int result;

    switch (state) {
        case (int) POT_STATE_HOLD:
            HoldStep();
            break;
        case (int) POT_STATE_FLY:
            result = FlyStep();

            if (result == (int) POT_STEP_BREAK) {
                return (int) POT_STEP_BREAK;
            }

            if (result == (int) POT_STEP_TIMEOUT) {
                return (int) POT_STEP_TIMEOUT;
            }
        default:
            break;
    }

    return (int) POT_STEP_NONE;
}

void CPot::Throw() {
    if (parts != NULL) {
        float player_position[4];
        state = (int) POT_STATE_FLY;
        fly_time = 0;
        position[0] = hold_pos[0];
        position[1] = hold_pos[1];
        position[2] = hold_pos[2];
        position[3] = 1.0f;
        CCharacter2 *player = GetMainScene()->GetCharacter(0);

        if (player != NULL) {
            player->GetRotation(player_position);
            velocity[0] = 10.0 * sin(player_position[1]);
            velocity[1] = 2.5f;
            velocity[2] = 10.0 * cos(player_position[1]);
            velocity[3] = 1.0f;
        }

        gravity[0] = 0.0f;
        gravity[1] = -0.5f;
        gravity[2] = 0.0f;
        gravity[3] = 1.0f;
    }
}

void CPot::Hold(CMapParts *map_parts) {
    Init(0);
    parts = map_parts;
    state = (int) POT_STATE_HOLD;
    HoldStep();
}

void CPot::Init(int keep_velocity) {
    state = (int) POT_STATE_NONE;
    parts = NULL;
    InitVector(position);

    if (keep_velocity != 1) {
        InitVector(velocity);
    }

    InitVector(gravity);
    InitVector(hold_pos);
    InitVector(prev_hold_pos);

    if (keep_velocity != 1) {
        InitVector(break_pos);
    }

    fly_time = 0;
}

// Initialised data (.data)
/**
 *
 * Starting offsets of the twelve pieces of a broken box.
 *
 */
float box_offset[12][4] __attribute__((aligned(16))) = {
    {-5.2f,       9.2f, -5.2f,       1.0f},
    {5.0f,        9.4f, 5.2f,        1.0f},
    {-5.2f,       0.0f, 5.2f,        1.0f},
    {-5.2f,       0.0f, -5.2f,       1.0f},
    {5.2f,        5.0f, 0.0f,        1.0f},
    {0.0f,        5.0f, -5.2f,       1.0f},
    {5.6f,        5.0f, 3.0f,        1.0f},
    {-3.0f,       5.6f, 2.2f,        1.0f},
    {3.1999998f,  6.8f, 3.6000001f,  1.0f},
    {-3.6000001f, 0.0f, -2.8f,       1.0f},
    {-4.0f,       3.0f, 3.0f,        1.0f},
    {5.6f,        5.0f, -3.1999998f, 1.0f}
};

/**
 *
 * Starting offsets of the ten pieces of the first broken rock.
 *
 */
float iwa0_offset[10][4] __attribute__((aligned(16))) = {
    {-4.4f,      11.2f,      4.2f,        1.0f},
    {-3.7f,      10.8f,      -2.3999999f, 1.0f},
    {-4.6f,      4.7999997f, 4.0f,        1.0f},
    {-2.2f,      2.0f,       2.0f,        1.0f},
    {-4.6f,      3.8f,       -2.6f,       1.0f},
    {2.0f,       10.8f,      4.0f,        1.0f},
    {2.8f,       11.0f,      -3.0f,       1.0f},
    {2.0f,       4.0f,       4.0f,        1.0f},
    {3.1999998f, 4.7999997f, -3.1999998f, 1.0f},
    {2.0f,       2.0f,       -3.0f,       1.0f}
};

/**
 *
 * Starting offsets of the nine pieces of the second broken rock.
 *
 */
float iwa1_offset[9][4] __attribute__((aligned(16))) = {
    {-4.364f, 12.022f, 0.022f,      1.0f},
    {-0.844f, 12.524f, 3.802f,      1.0f},
    {3.512f,  12.996f, 1.848f,      1.0f},
    {2.762f,  12.198f, 3.0379999f,  1.0f},
    {-2.33f,  11.232f, -3.3000002f, 1.0f},
    {2.216f,  5.976f,  0.168f,      1.0f},
    {-2.112f, 2.664f,  -1.778f,     1.0f},
    {1.562f,  1.33f,   0.49199998f, 1.0f},
    {-1.768f, 4.292f,  -1.7939999f, 1.0f}
};
