#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"

#include "colprim.hpp"

#include <cstring>

// Code (.text)
int CColPrim::SetDamage(char *name, int owner_id) {
    int index = 0;
    DAMAGE_PARAM *param = Damage_Param_Table;
    for (;;) {
        if (((signed char *)param->name)[0] == 0) {
            return 0;
        }
        if (strcmp(param->name, name) == 0) {
            Initialize();
            param_no = index;
            active = 1;
            this->param = param;
            owner = owner_id;
            damage = param->damage;
            step_count = 0;
            coord_type = 1;
            attacker = -1;
            range = 10000.0f;
            memcpy(element, param->element, 0x10);
            status = param->status;
            if (param->target & 1) {
                if (owner_id == 0) {
                    target = 4;
                } else {
                    target = 2;
                }
            } else {
                target = param->target;
            }
            return 1;
        }
        index++;
        param++;
    }
}
void CColPrim::SetCoord(float *new_point, float new_radius) {
    new_point[3] = 1.0f;
    if (step_count == 0) {
        sceVu0CopyVector(pos[0], new_point);
        sceVu0CopyVector(old_pos[0], new_point);
        sceVu0CopyVector(origin, new_point);
    } else {
        sceVu0CopyVector(old_pos[0], pos[0]);
        sceVu0CopyVector(pos[0], new_point);
    }
    radius = new_radius;
    coord_type = 1;
}
void CColPrim::SetCoord(float *new_start, float *new_end, float new_radius) {
    new_start[3] = 1.0f;
    new_end[3] = 1.0f;
    if (step_count == 0) {
        sceVu0CopyVector(pos[0], new_start);
        sceVu0CopyVector(pos[1], new_end);
        sceVu0CopyVector(old_pos[0], new_start);
        sceVu0CopyVector(old_pos[1], new_end);
        sceVu0CopyVector(origin, new_start);
    } else {
        sceVu0CopyVector(old_pos[0], pos[0]);
        sceVu0CopyVector(old_pos[1], pos[1]);
        sceVu0CopyVector(pos[0], new_start);
        sceVu0CopyVector(pos[1], new_end);
    }
    radius = new_radius;
    coord_type = 1;
}
void CColPrim::SetCoord(mgCFrame *frame, float new_radius) {
    this->frame[0] = frame;
    this->frame[1] = 0;
    radius = new_radius;
    coord_type = 2;
    if ((step_count == 0) && (frame != NULL)) {
        frame->GetWorldPosition0(origin);
    }
}
void CColPrim::SetCoord(mgCFrame *new_start_frame, mgCFrame *new_end_frame, float new_radius) {
    frame[0] = new_start_frame;
    frame[1] = new_end_frame;
    radius = new_radius;
    coord_type = 2;
    if ((step_count == 0) && (new_start_frame != NULL)) {
        new_start_frame->GetWorldPosition0(origin);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/colprim", IsHit__8CColPrimFP6CScenei);
int CColPrim::IsReversVec(CColPrim *other) {
    if (active == 0) {
        return 0;
    }
    if (param == 0) {
        return 0;
    }
    if (other->attacker != 0) {
        return 0;
    }
    other->pos[0][3] = 1.0f;
    pos[0][3] = 1.0f;
    if (mgDistVector(pos[0], other->pos[0]) <= 2.0f * (radius + 2.0f * other->radius)) {
        return 1;
    }
    return 0;
}
void CColPrim::GetReversVec(float *result) {
    if ((active != 0) && (param != 0))
        sceVu0SubVector(result, old_pos[0], pos[0]);
}
void CColPrim::DebugDraw() {}
int CColPrim::Step(void) {
    if (active == 0) {
        return 0;
    }

    if (coord_type & COLPRIM_COORD_FRAME) {
        for (int i = 0; i < 2; i++) {
            if (step_count != 0) {
                sceVu0CopyVector(old_pos[i], pos[i]);
            }
            if (frame[i] != 0) {
                frame[i]->GetWorldPosition0(pos[i]);
            }
            if (step_count == 0) {
                sceVu0CopyVector(old_pos[i], pos[i]);
            }
        }
    }
    step_count++;
    int limit = life;
    if (limit != -1) {
        if (step_count >= limit) {
            active = 0;
        }
    }
    return 1;
}
void CColPrim::Delete(int id) {
    if (active != 0) {
        if (id == -1) {
            active = 0;
        } else if (owner == id) {
            active = 0;
        }
    }
}
void CColPrim::Initialize(void) {
    active = 0;
    owner = -1;
    hit_mask = 0;
    step_count = 0;
    life = -1;
    hit_num = 0;
    reversed = 0;
    has_gift = 0;
    unk_34 = 0;
    frame[1] = NULL;
    frame[0] = NULL;
    radius = 0;
    unk_8c = -1;
}
CColPrim *CColPrimMan::GetPrim() {
    for (int i = 0; i < COLPRIM_MAX; i++) {
        if (prim[i].active == 0) {
            prim[i].id = i;
            return &prim[i];
        }
    }
    return 0;
}

CColPrim *CColPrimMan::GetID2Prim(int id) {
    if (id < 0 || id >= COLPRIM_MAX) {
        return 0;
    }
    prim[id].id = id;
    return &prim[id];
}

int CColPrimMan::ActivePrimNum() {
    int count = 0;
    for (int i = 0; i < COLPRIM_MAX; i++) {
        if (prim[i].active != 0) {
            count++;
        }
    }
    return count;
}

void CColPrimMan::Delete(int id) {
    for (int i = 0; i < COLPRIM_MAX; i++) {
        prim[i].Delete(id);
    }
}

CColPrim *CColPrimMan::CheckHit(int type) {
    for (int i = 0; i < COLPRIM_MAX; i++) {
        if (prim[i].IsHit(scene, type) != 0) {
            return &prim[i];
        }
    }
    return 0;
}

CColPrim *CColPrimMan::IsReversVec(CColPrim *other) {
    for (int i = 0; i < COLPRIM_MAX; i++) {
        if (other->id != i && prim[i].IsReversVec(other) != 0) {
            return &prim[i];
        }
    }
    return 0;
}

void CColPrimMan::Step() {
    for (int i = 0; i < COLPRIM_MAX; i++) {
        prim[i].Step();
    }
}

void CColPrimMan::Initialize(CScene *new_scene) {
    scene = new_scene;
    for (int i = 0; i < COLPRIM_MAX; i++) {
        prim[i].Initialize();
        prim[i].id = i;
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/colprim", Damage_Param_Table__DATA);
