#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"

#include "colprim.hpp"

#include "character.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "scenesnd.hpp"
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
void CColPrim::SetCoord(float *position, float new_radius) {
    position[3] = 1.0f;
    if (step_count == 0) {
        sceVu0CopyVector(pos[0], position);
        sceVu0CopyVector(old_pos[0], position);
        sceVu0CopyVector(origin, position);
    } else {
        sceVu0CopyVector(old_pos[0], pos[0]);
        sceVu0CopyVector(pos[0], position);
    }
    radius = new_radius;
    coord_type = COLPRIM_COORD_VECTOR;
}
void CColPrim::SetCoord(float *start, float *end, float new_radius) {
    start[3] = 1.0f;
    end[3] = 1.0f;
    if (step_count == 0) {
        sceVu0CopyVector(pos[0], start);
        sceVu0CopyVector(pos[1], end);
        sceVu0CopyVector(old_pos[0], start);
        sceVu0CopyVector(old_pos[1], end);
        sceVu0CopyVector(origin, start);
    } else {
        sceVu0CopyVector(old_pos[0], pos[0]);
        sceVu0CopyVector(old_pos[1], pos[1]);
        sceVu0CopyVector(pos[0], start);
        sceVu0CopyVector(pos[1], end);
    }
    radius = new_radius;
    coord_type = COLPRIM_COORD_VECTOR;
}
void CColPrim::SetCoord(mgCFrame *start, float new_radius) {
    frame[0] = start;
    frame[1] = NULL;
    radius = new_radius;
    coord_type = COLPRIM_COORD_FRAME;
    if (step_count == 0 && start) start->GetWorldPosition0(origin);
}
void CColPrim::SetCoord(mgCFrame *start, mgCFrame *end, float new_radius) {
    frame[0] = start;
    frame[1] = end;
    radius = new_radius;
    coord_type = COLPRIM_COORD_FRAME;
    if (step_count == 0 && start) start->GetWorldPosition0(origin);
}
#ifdef NONMATCHING
int CColPrim::IsHit(CScene *scene, int chara_id) {
    if (!active || !param) return 0;
    CCharacter2 *chara = scene->GetCharacter(chara_id);
    if (!chara) return 0;
    int chara_type = scene->GetType(1, chara_id);
    if (chara_type == 1 && !(target & DAMAGE_TARGET_PLAYER)) return 0;
    if (chara_type == 3 && !(target & DAMAGE_TARGET_MONSTER)) return 0;
    if (chara_id != -1 && (hit_mask & (1ULL << (chara_id & 31)))) return 0;

    sceVu0FVECTOR starts[4], ends[4], displacement;
    int segment_count = 0;
    if (param->shape & DAMAGE_SHAPE_POINT) {
        sceVu0CopyVector(starts[segment_count++], pos[0]);
        if ((param->shape & DAMAGE_SHAPE_TRAIL) && step_count > 0) {
            sceVu0SubVector(displacement, old_pos[0], pos[0]);
            sceVu0ScaleVector(displacement, displacement, 0.5f);
            sceVu0AddVector(starts[segment_count++], displacement, pos[0]);
        }
    }
    if (param->shape & DAMAGE_SHAPE_LINE) {
        sceVu0CopyVector(starts[segment_count], pos[0]);
        sceVu0CopyVector(ends[segment_count++], pos[1]);
        if ((param->shape & DAMAGE_SHAPE_TRAIL) && step_count > 0) {
            sceVu0CopyVector(starts[segment_count], pos[0]);
            sceVu0CopyVector(ends[segment_count++], old_pos[0]);
            sceVu0SubVector(displacement, pos[0], pos[1]);
            sceVu0ScaleVector(displacement, displacement, 0.5f);
            sceVu0AddVector(starts[segment_count], pos[1], displacement);
            sceVu0SubVector(displacement, old_pos[0], old_pos[1]);
            sceVu0ScaleVector(displacement, displacement, 0.5f);
            sceVu0AddVector(ends[segment_count++], old_pos[1], displacement);
        }
    }

    sceVu0FVECTOR entry_position;
    for (int entry_no = 0;; ++entry_no) {
        CHARA_ENTRY_OBJECT *entry = chara->GetEntryObjectPos(2, entry_no, entry_position);
        if (!entry) break;
        if (!entry->enable) continue;
        bool hit = false;
        float hit_radius = 2.0f * (radius + entry->unk_04);
        if (param->shape & DAMAGE_SHAPE_POINT) {
            for (int i = 0; i < segment_count; ++i) {
                if (mgDistVector(starts[i], entry_position) <= hit_radius) {
                    sceVu0CopyVector(hit_pos, entry_position);
                    if (param->shape & DAMAGE_SHAPE_TRAIL)
                        sceVu0SubVector(hit_vec, pos[0], old_pos[0]);
                    else sceVu0SubVector(hit_vec, entry_position, starts[i]);
                    hit_vec[1] = 0.0f;
                    sceVu0Normalize(hit_vec, hit_vec);
                    hit = true;
                    break;
                }
            }
        }
        if (param->shape & DAMAGE_SHAPE_LINE) {
            for (int i = 0; i < segment_count; ++i) {
                if (mgDistLinePoint(entry_position, starts[i], ends[i], hit_pos) <= hit_radius) {
                    sceVu0SubVector(hit_vec, pos[1], old_pos[1]);
                    hit = true;
                    break;
                }
            }
        }
        if (hit) {
            if (chara_id != -1 && !param->multi_hit) hit_mask |= 1ULL << (chara_id & 31);
            ++hit_num;
            return 1;
        }
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/colprim", IsHit__8CColPrimFP6CScenei);
#endif
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
void CColPrim::GetReversVec(float *out_vector) {
    if (active && param) sceVu0SubVector(out_vector, old_pos[0], pos[0]);
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
    for (int i = 0; i < COLPRIM_MAX; ++i)
        if (!prim[i].active) { prim[i].id = i; return &prim[i]; }
    return NULL;
}
CColPrim *CColPrimMan::GetID2Prim(int id) {
    if (id < 0 || id >= COLPRIM_MAX) return NULL;
    prim[id].id = id;
    return &prim[id];
}
int CColPrimMan::ActivePrimNum() {
    int count = 0;
    for (int i = 0; i < COLPRIM_MAX; ++i) if (prim[i].active) ++count;
    return count;
}
void CColPrimMan::Delete(int owner) {
    for (int i = 0; i < COLPRIM_MAX; ++i) prim[i].Delete(owner);
}
CColPrim *CColPrimMan::CheckHit(int chara_id) {
    for (int i = 0; i < COLPRIM_MAX; ++i)
        if (prim[i].IsHit(scene, chara_id)) return &prim[i];
    return NULL;
}
CColPrim *CColPrimMan::IsReversVec(CColPrim *attack) {
    for (int i = 0; i < COLPRIM_MAX; ++i)
        if (attack->id != i && prim[i].IsReversVec(attack)) return &prim[i];
    return NULL;
}
void CColPrimMan::Step() {
    for (int i = 0; i < COLPRIM_MAX; ++i) prim[i].Step();
}
void CColPrimMan::Initialize(CScene *new_scene) {
    scene = new_scene;
    for (int i = 0; i < COLPRIM_MAX; ++i) { prim[i].Initialize(); prim[i].id = i; }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/colprim", Damage_Param_Table__DATA);
