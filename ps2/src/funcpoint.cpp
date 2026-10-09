#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdlib>
#include <cstring>

#include "funcpoint.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mglib.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "water.hpp"


// Code (.text)
int CheckTime(float time, float start, float end) {
    int outside;

    if (!(end <= start)) {
        if (time < start) {
            return 0;
        }

        outside = 1;

        if (time < end) {
            outside = 0;
        }

        return outside ^ 1;
    }

    if (!(start <= end)) {
        if (!(time < start)) {
            return 1;
        }

        if (!(time < end)) {
            return 0;
        }

        return 1;
    }

    return 1;
}

float LimitTime(float time) {
    if (!(time < 0.0f) && time < 24.0f) {
        return time;
    }

    time -= (int) (time / 24.0f) * 24.0f;

    if (time < 0.0f) {
        time += 24.0f;
    }

    return time;
}

float SubTime(float a, float b) {
    float t = LimitTime(a - b);

    if (t <= 12.0f) {
        return t;
    }

    return 24.0f - t;
}

void CFuncPoint::Initialize() {
    name = NULL;
    type = FUNC_POINT_NONE;
    unk_8 = 0;
    unk_c = 0;
    enable = 1;
    start = end = 0.0f;
    memset(data, 0, sizeof(data));
    mgZeroVector(position);
    mgZeroVector(rotation);
    scale[0] = scale[1] = scale[2] = 1.0f;
    scale[3] = 0.0f;
}

int CFuncPoint::Check(CFuncPointCheck *check) {
    if (enable == 0) {
        return 0;
    }

    if (check != NULL) {
        return CheckTime(check->time, start, end);
    }

    return 1;
}

/**
 *
 * Checks whether a moving point has passed its target on any axis.
 *
 */
int CheckOver(float *current, float *speed, float *end) {
    for (int index = 0; index < 3; index++) {
        if (!(speed[index] <= 0.0f)) {
            if (!(current[index] < end[index])) {
                return 1;
            }
        }

        if (speed[index] < 0.0f) {
            if (current[index] <= end[index]) {
                return 1;
            }
        }
    }

    return 0;
}

void CObjAnime::Step(CObjAnimeEnv *env) {
    CFuncPoint::AnimeData *settings = &func_point->anime;
    float                  speed[4];
    float                  delta[4];
    float                  target[4];
    float                  matrix[4][4];
    float                  inverse[4][4];

    if (stop != 0) {
        return;
    }

    *(u_long128 *) speed = *(u_long128 *) settings->speed;

    if (back != 0) {
        sceVu0ScaleVector(speed, speed, -1.0f);
    }

    mgCObject *object = frame;

    if (object == NULL) {
        object = piece;
    }

    if (object == NULL) {
        object = parts;
    }

    if (object == NULL) {
        return;
    }

    GetParam(param);

    switch (settings->mode) {
        case OBJ_ANIME_MODE_NONE:
            break;
        case OBJ_ANIME_MODE_LOOP:
            mgAddVector(param, speed);
            break;
        case OBJ_ANIME_MODE_STOP:
            mgAddVector(param, speed);

            if (CheckOver(param, speed, settings->end)) {
                *(u_long128 *) param = *(u_long128 *) settings->end;
            }

            break;
        case OBJ_ANIME_MODE_RANDOM:
            sceVu0SubVector(delta, settings->end, settings->param);
            delta[0] *= (float) rand() / 2147483648.0f;
            delta[1] *= (float) rand() / 2147483648.0f;
            delta[2] *= (float) rand() / 2147483648.0f;
            sceVu0AddVector(param, settings->param, delta);
            break;
        case OBJ_ANIME_MODE_REPEAT:
            mgAddVector(param, speed);

            if (CheckOver(param, speed, settings->end)) {
                *(u_long128 *) param = *(u_long128 *) settings->param;
            }

            break;
        case OBJ_ANIME_MODE_PINGPONG:
        case OBJ_ANIME_MODE_PINGPONG_ONCE:
            mgAddVector(param, speed);

            if (back != 0) {
                if (CheckOver(param, speed, settings->param)) {
                    *(u_long128 *) param = *(u_long128 *) settings->param;
                    back = 0;

                    if (settings->mode == OBJ_ANIME_MODE_PINGPONG_ONCE) {
                        stop = 1;
                    }
                }
            } else {
                if (CheckOver(param, speed, settings->end)) {
                    *(u_long128 *) param = *(u_long128 *) settings->end;
                    back = 1;
                }
            }

            break;
        case OBJ_ANIME_MODE_LOOK:
            if (settings->kind == OBJ_ANIME_PARAM_ROTATION && env != NULL && parts != NULL) {
                *(u_long128 *) target = *(u_long128 *) env->chara_pos;

                if (piece != NULL) {
                    target[3] = 1.0f;

                    if (frame == NULL) {
                        parts->GetLWMatrix(matrix);
                    } else {
                        mgCFrame *root = piece->frame;

                        if (root != NULL) {
                            root->ChangeParam();
                            parts->UpDatePosition();
                            root->SetReference(&parts->frame);
                            frame->ChangeParam();
                            frame->SetRotation(0.0f, 0.0f, 0.0f);
                            frame->GetLWMatrix(matrix);
                            root->DeleteReference();
                        }
                    }

                    mgInversMatrix(inverse, matrix);
                    sceVu0ApplyMatrix(target, inverse, target);
                } else {
                    target[0] -= parts->position[0];
                    target[1] -= parts->position[1];
                    target[2] -= parts->position[2];
                }

                param[1] = 180.0f * atan2f(target[0], target[2]) / 3.1415927f;
                param[0] = 180.0f * -atan2f(target[1], sqrtf(target[0] * target[0] + target[2] * target[2])) / 3.1415927f;

                for (int axis = 0; axis < 3; axis++) {
                    if (param[axis] <= settings->param[axis]) {
                        param[axis] = settings->param[axis];
                    }

                    if (!(param[axis] <= settings->end[axis])) {
                        param[axis] = settings->end[axis];
                    }
                }
            }

            break;
        case OBJ_ANIME_MODE_CLOCK_MINUTE:
            if (env != NULL) {
                param[1] = 360.0f * -env->time;
            }

            break;
        case OBJ_ANIME_MODE_CLOCK_HOUR:
            if (env != NULL) {
                param[1] = 360.0f * (-env->time / 12.0f);
            }

            break;
        case OBJ_ANIME_MODE_TIME:
            if (env != NULL) {
                float weight;

                if (CheckTime(env->time, settings->speed[0], settings->speed[1])) {
                    weight = 1.0f;
                } else {
                    float fade = settings->speed[2];
                    weight = 0.0f;

                    if (!(fade <= 0.0f)) {
                        float before = SubTime(settings->speed[0], env->time);
                        float after = SubTime(env->time, settings->speed[1]);

                        if (!(before < 0.0f) && before <= fade) {
                            weight = 1.0f - before / fade;
                        }

                        if (!(after < 0.0f) && after <= fade) {
                            weight = 1.0f - after / fade;
                        }
                    }
                }

                param[0] = settings->param[0] + weight * (settings->end[0] - settings->param[0]);
                param[1] = settings->param[1] + weight * (settings->end[1] - settings->param[1]);
                param[2] = settings->param[2] + weight * (settings->end[2] - settings->param[2]);
            }

            break;
    }

    SetParam(param);
}

void CObjAnime::SetParam(float *value) {
    CFuncPoint::AnimeData *settings = &func_point->anime;
    *(u_long128 *) param = *(u_long128 *) value;

    if (settings->uniform != 0) {
        param[1] = param[0];
        param[2] = param[0];
    }

    mgCObject *target = frame;
    CObject   *owner = piece;

    if (target == NULL) {
        target = piece;
    }

    if (target == NULL) {
        target = parts;
    }

    if (target != NULL) {
        if (owner == NULL) {
            owner = parts;
        }

        switch (settings->kind) {
            case OBJ_ANIME_PARAM_POSITION:
                param[3] = 1.0f;

                if (settings->piece_space != 0) {
                    if (owner != NULL) {
                        float matrix[4][4];
                        float position[4];
                        owner->GetMatrix(matrix);
                        sceVu0ApplyMatrix(position, matrix, param);
                        target->SetPosition(position);
                    } else {
                        target->SetPosition(param);
                    }
                } else {
                    target->SetPosition(param);
                }

                break;
            case OBJ_ANIME_PARAM_ROTATION:
                if (!(param[0] <= 360000.0f)) {
                    param[0] -= 360000.0f;
                }

                if (param[0] < -360000.0f) {
                    param[0] += 360000.0f;
                }

                if (!(param[1] <= 360000.0f)) {
                    param[1] -= 360000.0f;
                }

                if (param[1] < -360000.0f) {
                    param[1] += 360000.0f;
                }

                if (!(param[2] <= 360000.0f)) {
                    param[2] -= 360000.0f;
                }

                if (param[2] < -360000.0f) {
                    param[2] += 360000.0f;
                }

                param[0] = mgAngleLimit(3.1415927f * param[0] / 180.0f);
                param[1] = mgAngleLimit(3.1415927f * param[1] / 180.0f);
                param[2] = mgAngleLimit(3.1415927f * param[2] / 180.0f);
                param[3] = 0.0f;
                target->SetRotation(param);
                break;
            case OBJ_ANIME_PARAM_SCALE:
                param[3] = 0.0f;
                target->SetScale(param);
                break;
            case OBJ_ANIME_PARAM_COLOR:
                if (frame != NULL) {
                    mgCFrameAttr *attr = frame->attr;

                    if (attr != NULL) {
                        attr->no_light = 1;
                        attr->color[0] = param[0];
                        attr->color[1] = param[1];
                        attr->color[2] = param[2];
                    }
                }

                break;
            case OBJ_ANIME_PARAM_ALPHA:
                if (frame != NULL) {
                    mgCFrameAttr *attr = frame->attr;

                    if (attr != NULL) {
                        attr->obj_alpha = param[0];
                    }
                }

                break;
        }
    }
}

void CObjAnime::GetParam(float *out_value) {
    CFuncPoint::AnimeData *settings = &func_point->anime;
    void                  *target = frame;

    if (target == NULL) {
        target = piece;
    }

    if (target == NULL) {
        target = parts;
    }

    if (target == NULL) {
        return;
    }

    *(u_long128 *) out_value = *(u_long128 *) param;

    switch (settings->kind) {
        case OBJ_ANIME_PARAM_POSITION:
            break;
        case OBJ_ANIME_PARAM_ROTATION:
            out_value[0] = 180.0f * out_value[0] / 3.1415927f;
            out_value[1] = 180.0f * out_value[1] / 3.1415927f;
            out_value[2] = 180.0f * out_value[2] / 3.1415927f;
            out_value[3] = 0.0f;
            break;
        case OBJ_ANIME_PARAM_SCALE:
        case OBJ_ANIME_PARAM_COLOR:
            break;
    }

    if (settings->uniform != 0) {
        out_value[1] = out_value[0];
        out_value[2] = out_value[0];
    }
}

int CObjAnime::AssignFuncAnime(CFuncPoint *point, CMapParts *map_parts) {
    if (point->type != FUNC_POINT_ANIME) {
        return 0;
    }

    if (map_parts == NULL) {
        return 0;
    }

    frame = NULL;
    piece = NULL;
    parts = NULL;
    func_point = NULL;
    back = 0;
    stop = 0;
    func_point = point;
    char      *piece_name = point->anime.piece_name;
    char      *frame_name = point->anime.frame_name;
    CMapPiece *matched_piece = NULL;
    mgCFrame  *matched_frame = NULL;

    if (piece_name != NULL && map_parts != NULL) {
        matched_piece = map_parts->SearchPiece(piece_name);
    }

    if (frame_name != NULL && matched_piece != NULL) {
        mgCFrame *piece_frame = matched_piece->frame;

        if (piece_frame != NULL) {
            matched_frame = piece_frame->SearchFrame(frame_name);
        }
    }

    frame = matched_frame;
    piece = matched_piece;
    parts = map_parts;

    if (matched_frame != NULL) {
        matched_frame->SetRotType(MG_FRAME_ROT_LOCAL_ORIGIN);
    }

    sceVu0FVECTOR initial_value;
    *(u_long128 *) initial_value = *(u_long128 *) func_point->anime.param;
    SetParam(initial_value);
    return 1;
}
#ifdef NONMATCHING
CFuncPoint *CFuncPointMngr::Add(int type, mgCMemory *stack) {
    CList<CFuncPoint> *node = new ((u_long128 *) stack->Alloc(0x20)) CList<CFuncPoint>;
    if (node == NULL) {
        return NULL;
    }
    node->data.Initialize();
    return Add(type, node);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", Add__14CFuncPointMngrFiP9mgCMemory);
#endif

CFuncPoint *CFuncPointMngr::Add(int type, CList<CFuncPoint> *node) {
    if (node == NULL) {
        return NULL;
    }

    if (type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return NULL;
    }

    CList<CFuncPoint> *last = list[type];

    if (last == NULL) {
        list[type] = node;
    } else {
        while (last != NULL) {
            CList<CFuncPoint> *next = last->next;

            if (next == NULL) {
                break;
            }

            last = next;
        }

        last->next = node;

        if (node != NULL) {
            node->prev = last;
        }
    }

    node->data.type = type;
    return &node->data;
}
static inline u_int Align16Blocks(u_int n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }
    return n >> 4;
}
void CFuncPointMngr::Reserve(int num, mgCMemory *stack) {
    CList<CFuncPoint> *nodes = new (stack->Alloc(Align16Blocks(num * sizeof(CList<CFuncPoint>)) + 2)) CList<CFuncPoint>[num];
    if (num > 0) {
        for (int index = 0; index < num; index++) {
            Add(FUNC_POINT_NONE, &nodes[index]);
        }
    }
}
template <>
void CList<CFuncPoint>::Initialize() {
    prev = NULL;
    next = NULL;
}

CList<CFuncPoint> *CFuncPointMngr::GetReserve() {
    CList<CFuncPoint> *node = list[FUNC_POINT_NONE];

    if (node == NULL) {
        return NULL;
    }

    CList<CFuncPoint> *first;
    CList<CFuncPoint> *next;
    CList<CFuncPoint> *previous = node->prev;

    if (previous != NULL) {
        next = node->next;
        previous->next = next;

        if (next != NULL) {
            next->prev = previous;
        }

        first = node->prev;

        while ((previous = first->prev) != NULL) {
            first = previous;
        }
    } else {
        if (node->next != NULL) {
            node->next->prev = NULL;
        }

        first = node->next;
    }

    node->prev = NULL;
    node->next = NULL;
    list[FUNC_POINT_NONE] = first;
    return node;
}

CFuncPoint *CFuncPointMngr::AddFromReserve(int kind) {
    CList<CFuncPoint> *node;

    node = GetReserve();

    if (node == NULL) {
        return NULL;
    }

    node->data.Initialize();
    return Add(kind, node);
}

int CFuncPointMngr::GetNum(int type) {
    if (type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return 0;
    }

    CList<CFuncPoint> *node = list[type];

    if (node == NULL) {
        return 0;
    }

    CList<CFuncPoint> *next = node->next;
    int                count = 1;

    if (next != NULL) {
        do {
            next = next->next;
            count++;
        } while (next != NULL);
    }

    return count;
}

int CFuncPointMngr::GetEventNum(int event_flag) {
    int count = 0;
    GetStart(FUNC_POINT_EVENT);
    CFuncPoint *point = Get();

    if (point != NULL) {
        do {
            if (point->event.flag & event_flag) {
                count += 1;
            }

            point = Get();
        } while (point != NULL);
    }

    GetEnd();
    return count;
}

int CFuncPointMngr::EnableFuncNum(int type) {
    if (type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return 0;
    }

    CList<CFuncPoint> *node = list[type];
    int                count = 0;

    while (node != NULL) {
        if (node->data.active != 0) {
            count++;
        }

        node = node->next;
    }

    return count;
}

void CFuncPointMngr::GetStart(int type) {
    now = NULL;

    if (type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return;
    }

    now = list[type];
}

CFuncPoint *CFuncPointMngr::Get() {
    CList<CFuncPoint> *node = now;

    if (node == NULL) {
        return NULL;
    }

    CFuncPoint *point = &node->data;
    now = node->next;
    return point;
}

void CFuncPointMngr::GetEnd() {
    now = NULL;
}

CFuncPoint *CFuncPointMngr::Search(char *name) {
    CFuncPoint *first;
    CFuncPoint *next;
    int         kind;
    CFuncPoint *point;

    kind = 1;

    do {
        GetStart(kind);
        first = Get();
        point = first;

        if (first != NULL) {
            do {
                if (strcasecmp(point->name, name) == 0) {
                    return point;
                }

                next = Get();
                point = next;
            } while (next != NULL);
        }

        GetEnd();
        kind += 1;
    } while (kind < 0xA);

    return NULL;
}
int CFuncPointMngr::GetLight(float *sphere, CFuncPoint *out_lights, int max, CFuncPointCheck *check, int mode) {
    float distance[64];
    int count;
    int skip_unlit;
    CFuncPoint *point;
    CFuncPoint *next;
    int i;
    CFuncPoint *candidate[64];
    int j;
    CFuncPoint *first;

    if (max <= 0) {
        return 0;
    }
    count = 0;
    skip_unlit = 0;
    if (mode & 1) {
        skip_unlit = 1;
    }
    GetStart(FUNC_POINT_PLIGHT);
    first = Get();
    point = first;
    if (first != NULL) {
        do {
            if (count >= 0x40) {
                break;
            }
            if (point->active != 0 && point->plight.light_type == FUNC_PLIGHT_POINT) {
                if (skip_unlit) {
                    if (point->plight.light_chara == 0) {
                        goto next_plight;
                    }
                } else if (point->plight.no_map_light != 0) {
                    goto next_plight;
                }
                float dist = mgDistVector(sphere, point->position);
                if (dist < point->plight.range + sphere[3]) {
                    distance[count] = dist;
                    candidate[count] = point;
                    count++;
                }
            }
        next_plight:
            next = Get();
            point = next;
        } while (next != NULL);
    }
    GetEnd();
    if ((mode & 3) == 3) {
        GetStart(FUNC_POINT_FIRE);
        first = Get();
        point = first;
        if (first != NULL) {
            do {
                if (count >= 0x40) {
                    break;
                }
                if (point->fire.cast_light != 0 && point->active != 0) {
                    float dist = mgDistVector(sphere, point->position);
                    if (dist <= 300.0f) {
                        distance[count] = dist;
                        candidate[count] = point;
                        count++;
                    }
                }
                next = Get();
                point = next;
            } while (next != NULL);
        }
        GetEnd();
        GetStart(FUNC_POINT_FLARE);
        first = Get();
        point = first;
        if (first != NULL) {
            do {
                if (count >= 0x40) {
                    break;
                }
                if (point->fire.cast_light != 0 && point->active != 0) {
                    float dist = mgDistVector(sphere, point->position);
                    if (dist <= 300.0f) {
                        distance[count] = dist;
                        candidate[count] = point;
                        count++;
                    }
                }
                next = Get();
                point = next;
            } while (next != NULL);
        }
        GetEnd();
    }
    if (count <= 0) {
        return 0;
    }
    if (count < max) {
        max = count;
    }
    for (i = 0; i < max; i++) {
        for (j = i + 1; j < count; j++) {
            if (!(distance[i] <= distance[j])) {
                float swap_distance = distance[i];
                CFuncPoint *swap_point = candidate[i];
                distance[i] = distance[j];
                candidate[i] = candidate[j];
                distance[j] = swap_distance;
                candidate[j] = swap_point;
            }
        }
    }
    for (i = 0; i < max; i++) {
        CFuncPoint *light = candidate[i];
        CFuncPoint *out = &out_lights[i];
        float *color = light->fire.color;
        switch (light->type) {
            case FUNC_POINT_PLIGHT:
                *out = *light;
                break;
            case FUNC_POINT_FIRE:
            case FUNC_POINT_FLARE: {
                *out = *light;
                out->type = FUNC_POINT_PLIGHT;
                sceVu0ScaleVector(out->plight.color, color, 1.0f);
                out->plight.power = 60.0f * light->scale[1];
                out->plight.range = 8.0f * out->plight.power;
                out->plight.light_type = FUNC_PLIGHT_POINT;
                out->plight.light_chara = 1;
                out->plight.unk_40 = 1;
                out->plight.unk_44 = 0;
                out->plight.flicker_type = FUNC_PLIGHT_FLICKER_RANDOM;
                out->plight.flicker_depth = 0.2f;
                break;
            }
        }
    }
    return max;
}
void CFuncPointMngr::Step(int i, CFuncPointCheck *c) { this->UpdateFlag(i, c); }

int CFuncPointMngr::UpdateFlag(int type, CFuncPointCheck *check) {
    CFuncPoint *first;
    CFuncPoint *next;
    CFuncPoint *point;
    int         active;
    int         count;

    GetStart(type);
    count = 0;
    first = Get();
    point = first;

    if (first != NULL) {
        do {
            active = point->Check(check);
            point->active = active;

            if (active != 0) {
                count += 1;
            }

            next = Get();
            point = next;
        } while (next != NULL);
    }

    GetEnd();
    return count;
}

void CFuncPointMngr::UpdateStatus() {
    for (int type = FUNC_POINT_EFFECT; type < FUNC_POINT_TYPE_NUM; type++) {
        GetStart(type);
        u32         status = 0;
        CFuncPoint *point = Get();

        while (point != NULL) {
            flag |= FUNC_POINT_MNGR_ANY;

            switch (type) {
                case FUNC_POINT_EFFECT:
                    status |= FUNC_POINT_MNGR_EFFECT;
                    break;
                case FUNC_POINT_FLARE:
                    status |= FUNC_POINT_MNGR_BURN | FUNC_POINT_MNGR_FLARE;

                    if (point->fire.cast_light != 0) {
                        status |= FUNC_POINT_MNGR_LIGHT;
                    }

                    break;
                case FUNC_POINT_FIRE:
                    status |= FUNC_POINT_MNGR_BURN | FUNC_POINT_MNGR_FIRE | FUNC_POINT_MNGR_SOUND;

                    if (point->fire.cast_light != 0) {
                        status |= FUNC_POINT_MNGR_LIGHT;
                    }

                    break;
                case FUNC_POINT_PLIGHT:
                    status |= FUNC_POINT_MNGR_PLIGHT;

                    if (point->plight.light_type == FUNC_PLIGHT_POINT) {
                        status |= FUNC_POINT_MNGR_LIGHT;
                    }

                    break;
                case FUNC_POINT_SOUND:
                    status |= FUNC_POINT_MNGR_SOUND;
                    break;
                case FUNC_POINT_EVENT:
                    status |= FUNC_POINT_MNGR_EVENT;
                    break;
            }

            flag |= status;
            point = Get();
        }

        GetEnd();
    }
}

/**
 *
 * Raw settings copied between function points.
 *
 */
struct FuncPointSettings {
    int word[0x14]; /**< Settings words. */
};

int CFuncPointMngr::Copy(CFuncPointMngr &dest, mgCMemory *stack) {
    dest.Initialize();

    for (int type = 0; type < FUNC_POINT_TYPE_NUM; type++) {
        CList<CFuncPoint> *node = list[type];

        while (node != NULL) {
            CFuncPoint *copy = dest.Add(type, stack);

            if (copy == NULL) {
                break;
            }

            CFuncPoint *source = &node->data;
            copy->name = source->name;
            copy->type = source->type;
            copy->unk_8 = source->unk_8;
            copy->unk_c = source->unk_c;
            copy->enable = source->enable;
            copy->start = source->start;
            copy->end = source->end;
            *(FuncPointSettings *) copy->data = *(FuncPointSettings *) source->data;
            copy->invent.neta_no = source->invent.neta_no;
            copy->invent.unk_24 = source->invent.unk_24;
            copy->invent.range = source->invent.range;
            copy->invent.angle = source->invent.angle;
            copy->invent.box = source->invent.box;
            copy->frame = source->frame;
            *(mgVec4 *) copy->position = *(mgVec4 *) source->position;
            *(mgVec4 *) copy->rotation = *(mgVec4 *) source->rotation;
            *(mgVec4 *) copy->scale = *(mgVec4 *) source->scale;
            copy->active = source->active;
            node = node->next;
        }
    }

    return 1;
}

void CFuncPointMngr::Initialize() {
    for (int type = 0; type < FUNC_POINT_TYPE_NUM; type++) {
        list[type] = NULL;
    }
}

void DrawFireEffect(float (*lw_matrix)[4], CFuncPointMngr *mngr, CFuncPointCheck *check, float rate, mgCTexture *fire_tex, mgCTexture *light_tex) {
    float       camera[4];
    float       to_camera[4];
    float       inverse[4][4];
    CFuncPoint *first;
    CFuncPoint *next;
    CFuncPoint *point;

    if (mngr != NULL) {
        int fire_num = mngr->EnableFuncNum(FUNC_POINT_FIRE);
        int flare_num = mngr->EnableFuncNum(FUNC_POINT_FLARE);

        if (fire_num != 0 || flare_num != 0) {
            mgGetCameraPos(camera);
            camera[3] = 1.0f;
            mgInversMatrix(inverse, lw_matrix);
            sceVu0ApplyMatrix(camera, inverse, camera);
            static mgC3DSprite sp_3d;
            mgC3DSprite       *sprite = &sp_3d;
            mgCDrawEnv         env = *mgGetpDrawEnv(0);
            float              uv0[4];
            float              uv1[4];
            float              size[4];
            float              position[4];
            float              color[4];

            if (fire_num > 0) {
                sceGsTest *test = &env.test;
                test->bits.zte = 1;
                test->bits.ztst = 2;
                env.SetZBuf(MG_ZBUF_NO_WRITE);
                env.SetAlpha(MG_ALPHA_MACRO_ADD);
                sprite->BeginCreatePacket(0, NULL);
                sprite->CPSetDrawEnv(&env);
                mgZeroVector(uv0);
                mgZeroVector(uv1);
                uv1[1] = 128.0f;
                uv1[0] = 128.0f;
                mgZeroVector(size);
                sprite->CPSetTexture(fire_tex);
                sprite->BeginCPSprite();
                mngr->GetStart(FUNC_POINT_FIRE);
                first = mngr->Get();
                point = first;

                if (first != NULL) {
                    do {
                        if (point->active != 0) {
                            size[0] = 20.0f * point->scale[0];
                            size[1] = 20.0f * point->scale[1];
                            *(u_long128 *) position = *(u_long128 *) point->position;
                            position[1] += 0.4f * size[1];
                            sprite->CPSetSprite(position, size, point->fire.color, uv0, uv1);
                        }

                        next = mngr->Get();
                        point = next;
                    } while (next != NULL);
                }

                mngr->GetEnd();
                sprite->EndCPSprite();
                sprite->EndCreatePacket();
                mgDrawDirect(sprite, lw_matrix);
            }

            if (fire_num > 0 || flare_num > 0) {
                sprite->BeginCreatePacket(0, NULL);
                env.SetZBuf(MG_ZBUF_NO_WRITE);
                env.SetAlpha(MG_ALPHA_MACRO_ADD);
                sprite->CPSetDrawEnv(&env);
                sprite->CPSetTexture(light_tex);
                sprite->BeginCPSprite();
                mgZeroVector(uv0);
                mgZeroVector(uv1);
                uv1[1] = 64.0f;
                uv1[0] = 64.0f;
                float fire_size = 30.0f * (1.0f + 0.05f * ((float) rand() / 2147483648.0f - 0.5f));
                float flare_size = 20.0f * (1.0f + 0.05f * ((float) rand() / 2147483648.0f - 0.5f));
                color[3] = 128.0f;
                mngr->GetStart(FUNC_POINT_FIRE);
                first = mngr->Get();
                point = first;

                if (first != NULL) {
                    do {
                        if (point->fire.effect_off == 0 && point->active != 0) {
                            size[0] = fire_size * point->scale[0];
                            size[1] = fire_size * point->scale[1];
                            *(u_long128 *) position = *(u_long128 *) point->position;
                            sceVu0SubVector(to_camera, camera, position);
                            sceVu0Normalize(to_camera, to_camera);
                            sceVu0ScaleVector(to_camera, to_camera, 10.0f);
                            mgAddVector(position, to_camera);
                            position[3] = 1.0f;
                            position[1] += 0.3f * size[1];
                            color[0] = point->fire.color[0];
                            color[1] = 0.5f * point->fire.color[1];
                            color[2] = 0.25f * point->fire.color[2];
                            sprite->CPSetSprite(position, size, color, uv0, uv1);
                        }

                        next = mngr->Get();
                        point = next;
                    } while (next != NULL);
                }

                mngr->GetEnd();
                mngr->GetStart(FUNC_POINT_FLARE);
                first = mngr->Get();
                point = first;

                if (first != NULL) {
                    do {
                        if (point->active != 0) {
                            size[0] = flare_size * point->scale[0];
                            size[1] = flare_size * point->scale[1];
                            *(u_long128 *) position = *(u_long128 *) point->position;
                            sceVu0SubVector(to_camera, camera, position);
                            sceVu0Normalize(to_camera, to_camera);
                            sceVu0ScaleVector(to_camera, to_camera, 10.0f);
                            mgAddVector(position, to_camera);
                            position[3] = 1.0f;
                            sprite->CPSetSprite(position, size, point->fire.color, uv0, uv1);
                        }

                        next = mngr->Get();
                        point = next;
                    } while (next != NULL);
                }

                mngr->GetEnd();
                sprite->EndCPSprite();
                sprite->EndCreatePacket();
                static mgCFrame            frame;
                static mgCFrame::BoundInfo Bound;
                frame.bound = &Bound;
                frame.SetTransMatrix(lw_matrix);
                static mgCFrameAttr attr;
                frame.visual = sprite;
                attr.no_cull = 1;
                attr.draw = 3;
                attr.fog = 2;
                frame.attr = &attr;
                mgDrawDirect(&frame);
            }
        }
    }
}

void DrawFireRaster(float (*lw_matrix)[4], CFuncPointMngr *mngr, CFuncPointCheck *check, CFireRaster *raster) {
    float       position[4];
    CFuncPoint *first;
    CFuncPoint *next;
    CFuncPoint *point;

    if (raster != NULL) {
        mngr->GetStart(FUNC_POINT_FIRE);
        first = mngr->Get();
        point = first;

        if (first != NULL) {
            do {
                if (point->active != 0 && point->fire.heat_haze != 0) {
                    *(u_long128 *) position = *(u_long128 *) point->position;
                    position[3] = 1.0f;
                    sceVu0ApplyMatrix(position, lw_matrix, position);
                    position[1] += 10.0f * point->scale[1];
                    float distance = mgGetDistFromCamera(position);

                    if (!(distance < 40.0f) && distance <= 400.0f) {
                        raster->Draw(position, point->scale);
                    }
                }

                next = mngr->Get();
                point = next;
            } while (next != NULL);
        }

        mngr->GetEnd();
    }
}

int GetSeSrcVolPan(
    float (*mat)[4], CFuncPointMngr *mgr, CFuncPointCheck *chk, int *kinds, float *vols, float *pans, int max) {
    struct {
        float        v[3];
        unsigned int w;
    } q90;

    float       v_a0[4];
    float       m_b0[4][4];
    CFuncPoint *p;
    int         n;

    n = 0;
    mgr->UpdateFlag(2, chk);
    mgr->GetStart(2);
    p = mgr->Get();

    if (p != NULL) {
        do {
            if (p->active != 0) {
                if (n >= max) {
                    return n;
                }

                *(u_long128 *) q90.v = *(u_long128 *) p->position;
                q90.w = 0x3F800000;
                sceVu0ApplyMatrix(q90.v, mat, q90.v);
                sndGetVolPan(vols, pans, q90.v, 10.0f, 1200.0f);

                if (*vols > 0.01f) {
                    vols++;
                    *kinds = 2;
                    pans++;
                    n++;
                    kinds++;
                }
            }

            p = mgr->Get();
        } while (p != NULL);
    }

    mgr->GetEnd();

    if (mgr->UpdateFlag(8, chk) > 0) {
        mgr->GetStart(8);

        if ((p = mgr->Get()) != NULL) {
            do {
                if (p->active != 0) {
                    if (n >= max) {
                        return n;
                    }

                    if (p->sound.shape == 1) {
                        p->frame.GetLWMatrix(m_b0);
                        mgMulMatrix(m_b0, m_b0, mat);
                        sceVu0ApplyMatrix(q90.v, m_b0, p->sound.start);
                        sceVu0ApplyMatrix(v_a0, m_b0, p->sound.end);
                        sndGetVolPan(vols, pans, q90.v, v_a0, p->sound.near_dist, p->sound.far_dist);
                    } else {
                        *(u_long128 *) q90.v = *(u_long128 *) p->position;
                        q90.w = 0x3F800000;
                        sceVu0ApplyMatrix(q90.v, mat, q90.v);
                        sndGetVolPan(vols, pans, q90.v, p->sound.near_dist, p->sound.far_dist);
                    }

                    if (*vols > 0.01f) {
                        vols++;
                        pans++;
                        n++;
                        *kinds = p->sound.se_no;
                        kinds++;
                    }
                }
            } while ((p = mgr->Get()) != NULL);
        }

        mgr->GetEnd();
    }

    return n;
}
#pragma divbyzerocheck on
float GetLightAnimeWeight(CFuncPoint *point, int frame) {
    float depth = point->plight.flicker_depth;
    int period = fptosi(point->plight.flicker_period);
    float weight = 1.0f;
    int phase;
    switch (point->type) {
        case FUNC_POINT_PLIGHT:
            switch (point->plight.flicker_type) {
                case FUNC_PLIGHT_FLICKER_NONE:
                    return weight;
                case FUNC_PLIGHT_FLICKER_RANDOM:
                    return weight * (1.0f - depth + depth * (float)rand() / 2147483648.0f);
                case FUNC_PLIGHT_FLICKER_SINE:
                    if (period > 0) {
                        phase = frame % period;
                        return weight * (1.0f - 0.5f * depth * (1.0f + sinf(6.2831855f * (float)phase / (float)period)));
                    }
                    return weight;
                case FUNC_PLIGHT_FLICKER_SAW:
                    if (period > 0) {
                        phase = frame % period;
                        return weight * (1.0f - depth * (float)phase / (float)period);
                    }
                    return weight;
            }
            break;
        case FUNC_POINT_FIRE:
        case FUNC_POINT_FLARE:
            return 0.7f + 0.3f * (float)rand() / 2147483648.0f;
    }
    return weight;
}
#pragma divbyzerocheck reset
