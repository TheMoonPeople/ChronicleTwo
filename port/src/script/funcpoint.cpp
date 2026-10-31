#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <utility>

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

int CheckTime(float time, float start, float end) {
    int outside = {};

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

    time -= static_cast<int>(time / 24.0f) * 24.0f;

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

int CFuncPoint::Check(CFuncPointCheck *check) {
    if (enable == 0) {
        return 0;
    }

    if (check != nullptr) {
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

    std::memmove(speed, settings->speed, sizeof(float) * 4);

    if (back != 0) {
        sceVu0ScaleVector(speed, speed, -1.0f);
    }

    mgCObject *object = frame;

    if (object == nullptr) {
        object = piece;
    }

    if (object == nullptr) {
        object = parts;
    }

    if (object == nullptr) {
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
                std::memmove(param, settings->end, sizeof(float) * 4);
            }

            break;
        case OBJ_ANIME_MODE_RANDOM:
            sceVu0SubVector(delta, settings->end, settings->param);
            delta[0] *= static_cast<float>(rand()) / 2147483648.0f;
            delta[1] *= static_cast<float>(rand()) / 2147483648.0f;
            delta[2] *= static_cast<float>(rand()) / 2147483648.0f;
            sceVu0AddVector(param, settings->param, delta);
            break;
        case OBJ_ANIME_MODE_REPEAT:
            mgAddVector(param, speed);

            if (CheckOver(param, speed, settings->end)) {
                std::memmove(param, settings->param, sizeof(float) * 4);
            }

            break;
        case OBJ_ANIME_MODE_PINGPONG:
        case OBJ_ANIME_MODE_PINGPONG_ONCE:
            mgAddVector(param, speed);

            if (back != 0) {
                if (CheckOver(param, speed, settings->param)) {
                    std::memmove(param, settings->param, sizeof(float) * 4);
                    back = 0;

                    if (settings->mode == OBJ_ANIME_MODE_PINGPONG_ONCE) {
                        stop = 1;
                    }
                }
            } else {
                if (CheckOver(param, speed, settings->end)) {
                    std::memmove(param, settings->end, sizeof(float) * 4);
                    back = 1;
                }
            }

            break;
        case OBJ_ANIME_MODE_LOOK:
            if (settings->kind == OBJ_ANIME_PARAM_ROTATION && env != nullptr && parts != nullptr) {
                std::memmove(target, env->chara_pos, sizeof(float) * 4);

                if (piece != nullptr) {
                    target[3] = 1.0f;

                    if (frame == nullptr) {
                        parts->GetLWMatrix(matrix);
                    } else {
                        mgCFrame *root = piece->frame;

                        if (root != nullptr) {
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

                param[1] = 180.0f * atan2f(target[0], target[2]) / PI;
                param[0] = 180.0f * -atan2f(target[1], sqrtf(target[0] * target[0] + target[2] * target[2])) / PI;

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
            if (env != nullptr) {
                param[1] = 360.0f * -env->time;
            }

            break;
        case OBJ_ANIME_MODE_CLOCK_HOUR:
            if (env != nullptr) {
                param[1] = 360.0f * (-env->time / 12.0f);
            }

            break;
        case OBJ_ANIME_MODE_TIME:
            if (env != nullptr) {
                float weight = {};

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
    std::memmove(param, value, sizeof(float) * 4);

    if (settings->uniform != 0) {
        param[1] = param[0];
        param[2] = param[0];
    }

    mgCObject *target = frame;
    CObject   *owner = piece;

    if (target == nullptr) {
        target = piece;
    }

    if (target == nullptr) {
        target = parts;
    }

    if (target != nullptr) {
        if (owner == nullptr) {
            owner = parts;
        }

        switch (settings->kind) {
            case OBJ_ANIME_PARAM_POSITION:
                param[3] = 1.0f;

                if (settings->piece_space != 0) {
                    if (owner != nullptr) {
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

                param[0] = mgAngleLimit(PI * param[0] / 180.0f);
                param[1] = mgAngleLimit(PI * param[1] / 180.0f);
                param[2] = mgAngleLimit(PI * param[2] / 180.0f);
                param[3] = 0.0f;
                target->SetRotation(param);
                break;
            case OBJ_ANIME_PARAM_SCALE:
                param[3] = 0.0f;
                target->SetScale(param);
                break;
            case OBJ_ANIME_PARAM_COLOR:
                if (frame != nullptr) {
                    mgCFrameAttr *attr = frame->attr;

                    if (attr != nullptr) {
                        attr->no_light = 1;
                        attr->color[0] = param[0];
                        attr->color[1] = param[1];
                        attr->color[2] = param[2];
                    }
                }

                break;
            case OBJ_ANIME_PARAM_ALPHA:
                if (frame != nullptr) {
                    mgCFrameAttr *attr = frame->attr;

                    if (attr != nullptr) {
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

    if (target == nullptr) {
        target = piece;
    }

    if (target == nullptr) {
        target = parts;
    }

    if (target == nullptr) {
        return;
    }

    std::memmove(out_value, param, sizeof(float) * 4);

    switch (settings->kind) {
        case OBJ_ANIME_PARAM_POSITION:
            break;
        case OBJ_ANIME_PARAM_ROTATION:
            out_value[0] = 180.0f * out_value[0] / PI;
            out_value[1] = 180.0f * out_value[1] / PI;
            out_value[2] = 180.0f * out_value[2] / PI;
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

    if (map_parts == nullptr) {
        return 0;
    }

    frame = nullptr;
    piece = nullptr;
    parts = nullptr;
    func_point = nullptr;
    back = 0;
    stop = 0;
    func_point = point;
    char      *piece_name = point->anime.piece_name;
    char      *frame_name = point->anime.frame_name;
    CMapPiece *matched_piece = nullptr;
    mgCFrame  *matched_frame = nullptr;

    if (piece_name != nullptr && map_parts != nullptr) {
        matched_piece = map_parts->SearchPiece(piece_name);
    }

    if (frame_name != nullptr && matched_piece != nullptr) {
        mgCFrame *piece_frame = matched_piece->frame;

        if (piece_frame != nullptr) {
            matched_frame = piece_frame->SearchFrame(frame_name);
        }
    }

    frame = matched_frame;
    piece = matched_piece;
    parts = map_parts;

    if (matched_frame != nullptr) {
        matched_frame->SetRotType(MG_FRAME_ROT_LOCAL_ORIGIN);
    }

    sceVu0FVECTOR initial_value;
    std::memmove(initial_value, func_point->anime.param, sizeof(float) * 4);
    SetParam(initial_value);
    return 1;
}

CFuncPoint *CFuncPointMngr::Add(int type, mgCMemory *stack) {
    if (stack == nullptr || type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return nullptr;
    }
    auto *node = dc2::memory::NewObject<CList<CFuncPoint>>(*stack);
    if (node == nullptr) {
        return nullptr;
    }
    return Add(type, node);
}

CFuncPoint *CFuncPointMngr::Add(int type, CList<CFuncPoint> *node) {
    if (node == nullptr) {
        return nullptr;
    }

    if (type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return nullptr;
    }

    CList<CFuncPoint> *last = list[type];

    if (last == nullptr) {
        list[type] = node;
    } else {
        while (last != nullptr) {
            CList<CFuncPoint> *next = last->next;

            if (next == nullptr) {
                break;
            }

            last = next;
        }

        last->next = node;

        if (node != nullptr) {
            node->prev = last;
        }
    }

    if (node->data.type != type) {
        switch (type) {
            case FUNC_POINT_EFFECT:
                node->data.effect = {};
                break;
            case FUNC_POINT_FIRE:
            case FUNC_POINT_FLARE:
                node->data.fire = {};
                break;
            case FUNC_POINT_PLIGHT:
                node->data.plight = {};
                break;
            case FUNC_POINT_ANIME:
                node->data.anime = {};
                break;
            case FUNC_POINT_EVENT:
                node->data.event = {};
                break;
            case FUNC_POINT_INVENT:
                node->data.invent = {};
                break;
            case FUNC_POINT_SOUND:
                node->data.sound = {};
                break;
            case FUNC_POINT_NONE:
            case FUNC_POINT_POS:
                node->data.anime = {};
                break;
        }
    }
    node->data.type = type;
    return &node->data;
}

void CFuncPointMngr::Reserve(int num, mgCMemory *stack) {
    if (num <= 0 || stack == nullptr || stack->lock != 0) {
        return;
    }
    const std::size_t bytes = static_cast<std::size_t>(num) * sizeof(CList<CFuncPoint>);
    const std::size_t blocks = (bytes + 15) / 16 + 2;
    if (blocks > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        stack->stGetRest() <= 0 || blocks >= static_cast<std::size_t>(stack->stGetRest())) {
        return;
    }
    auto *storage = stack->Alloc(static_cast<int>(blocks));
    if (storage == nullptr) {
        return;
    }
    auto *nodes = new (storage) CList<CFuncPoint>[num];
    for (int index = 0; index < num; index++) {
        Add(FUNC_POINT_NONE, &nodes[index]);
    }
}

template <>
void CList<CFuncPoint>::Initialize() {
    prev = nullptr;
    next = nullptr;
}

CList<CFuncPoint> *CFuncPointMngr::GetReserve() {
    CList<CFuncPoint> *node = list[FUNC_POINT_NONE];

    if (node == nullptr) {
        return nullptr;
    }

    CList<CFuncPoint> *first = {};
    CList<CFuncPoint> *next = {};
    CList<CFuncPoint> *previous = node->prev;

    if (previous != nullptr) {
        next = node->next;
        previous->next = next;

        if (next != nullptr) {
            next->prev = previous;
        }

        first = node->prev;

        while ((previous = first->prev) != nullptr) {
            first = previous;
        }
    } else {
        if (node->next != nullptr) {
            node->next->prev = nullptr;
        }

        first = node->next;
    }

    node->prev = nullptr;
    node->next = nullptr;
    list[FUNC_POINT_NONE] = first;
    return node;
}

CFuncPoint *CFuncPointMngr::AddFromReserve(int kind) {
    CList<CFuncPoint> *node = {};

    node = GetReserve();

    if (node == nullptr) {
        return nullptr;
    }

    node->data.Initialize();
    return Add(kind, node);
}

int CFuncPointMngr::GetNum(int type) {
    if (type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return 0;
    }

    CList<CFuncPoint> *node = list[type];

    if (node == nullptr) {
        return 0;
    }

    CList<CFuncPoint> *next = node->next;
    int                count = 1;

    if (next != nullptr) {
        do {
            next = next->next;
            count++;
        } while (next != nullptr);
    }

    return count;
}

int CFuncPointMngr::GetEventNum(int event_flag) {
    int count = 0;
    GetStart(FUNC_POINT_EVENT);
    CFuncPoint *point = Get();

    if (point != nullptr) {
        do {
            if (point->event.flag & event_flag) {
                count += 1;
            }

            point = Get();
        } while (point != nullptr);
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

    while (node != nullptr) {
        if (node->data.active != 0) {
            count++;
        }

        node = node->next;
    }

    return count;
}

void CFuncPointMngr::GetStart(int type) {
    now = nullptr;

    if (type < 0 || type >= FUNC_POINT_TYPE_NUM) {
        return;
    }

    now = list[type];
}

CFuncPoint *CFuncPointMngr::Get() {
    CList<CFuncPoint> *node = now;

    if (node == nullptr) {
        return nullptr;
    }

    CFuncPoint *point = &node->data;
    now = node->next;
    return point;
}

void CFuncPointMngr::GetEnd() {
    now = nullptr;
}

CFuncPoint *CFuncPointMngr::Search(char *name) {
    CFuncPoint *first = {};
    CFuncPoint *next = {};
    int         kind = {};
    CFuncPoint *point = {};

    kind = 1;

    do {
        GetStart(kind);
        first = Get();
        point = first;

        if (first != nullptr) {
            do {
                if (strcasecmp(point->name, name) == 0) {
                    return point;
                }

                next = Get();
                point = next;
            } while (next != nullptr);
        }

        GetEnd();
        kind += 1;
    } while (kind < 0xA);

    return nullptr;
}

int CFuncPointMngr::GetLight(float *sphere, CFuncPoint *out_lights, int max, CFuncPointCheck *check, int mode) {
    float       distance[64];
    int         count = {};
    int         skip_unlit = {};
    CFuncPoint *point = {};
    CFuncPoint *next = {};
    int         i = {};
    CFuncPoint *candidate[64];
    int         j = {};
    CFuncPoint *first = {};

    if (max <= 0) {
        return 0;
    }

    count = 0;
    skip_unlit = 0;

    if (mode & FUNC_POINT_LIGHT_CHARA) {
        skip_unlit = 1;
    }

    GetStart(FUNC_POINT_PLIGHT);
    first = Get();
    point = first;

    if (first != nullptr) {
        do {
            if (count >= 0x40) {
                break;
            }

            if (point->active != 0 && point->plight.light_type == FUNC_PLIGHT_POINT) {
                if (skip_unlit) {
                    if (point->plight.light_chara == 0) {
                        continue;
                    }
                } else if (point->plight.no_map_light != 0) {
                    continue;
                }

                float dist = mgDistVector(sphere, point->position);

                if (dist < point->plight.range + sphere[3]) {
                    distance[count] = dist;
                    candidate[count] = point;
                    count++;
                }
            }
        } while ((point = Get()) != nullptr);
    }

    GetEnd();

    if ((mode & (FUNC_POINT_LIGHT_CHARA | FUNC_POINT_LIGHT_FIRE)) == (FUNC_POINT_LIGHT_CHARA | FUNC_POINT_LIGHT_FIRE)) {
        GetStart(FUNC_POINT_FIRE);
        first = Get();
        point = first;

        if (first != nullptr) {
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
            } while (next != nullptr);
        }

        GetEnd();
        GetStart(FUNC_POINT_FLARE);
        first = Get();
        point = first;

        if (first != nullptr) {
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
            } while (next != nullptr);
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
                float       swap_distance = distance[i];
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

        switch (light->type) {
            case FUNC_POINT_PLIGHT:
                *out = *light;
                break;
            case FUNC_POINT_FIRE:
            case FUNC_POINT_FLARE: {
                float color[4];
                sceVu0CopyVector(color, light->fire.color);
                *out = *light;
                out->plight = {};
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
    CFuncPoint *first = {};
    CFuncPoint *next = {};
    CFuncPoint *point = {};
    int         active = {};
    int         count = {};

    GetStart(type);
    count = 0;
    first = Get();
    point = first;

    if (first != nullptr) {
        do {
            active = point->Check(check);
            point->active = active;

            if (active != 0) {
                count += 1;
            }

            next = Get();
            point = next;
        } while (next != nullptr);
    }

    GetEnd();
    return count;
}

void CFuncPointMngr::UpdateStatus() {
    for (int type = FUNC_POINT_EFFECT; type < FUNC_POINT_TYPE_NUM; type++) {
        GetStart(type);
        u32         status = 0;
        CFuncPoint *point = Get();

        while (point != nullptr) {
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

void CFuncPointMngr::Initialize() {
    for (int type = 0; type < FUNC_POINT_TYPE_NUM; type++) {
        list[type] = nullptr;
    }
}

void DrawFireEffect(float (*lw_matrix)[4], CFuncPointMngr *mngr, CFuncPointCheck *check, float rate, mgCTexture *fire_tex, mgCTexture *light_tex) {
    float       camera[4];
    float       to_camera[4];
    float       inverse[4][4];
    CFuncPoint *first = {};
    CFuncPoint *next = {};
    CFuncPoint *point = {};

    if (mngr != nullptr) {
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
                sprite->BeginCreatePacket(0, nullptr);
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

                if (first != nullptr) {
                    do {
                        if (point->active != 0) {
                            size[0] = 20.0f * point->scale[0];
                            size[1] = 20.0f * point->scale[1];
                            std::memmove(position, point->position, sizeof(float) * 4);
                            position[1] += 0.4f * size[1];
                            sprite->CPSetSprite(position, size, point->fire.color, uv0, uv1);
                        }

                        next = mngr->Get();
                        point = next;
                    } while (next != nullptr);
                }

                mngr->GetEnd();
                sprite->EndCPSprite();
                sprite->EndCreatePacket();
                mgDrawDirect(sprite, lw_matrix);
            }

            if (fire_num > 0 || flare_num > 0) {
                sprite->BeginCreatePacket(0, nullptr);
                env.SetZBuf(MG_ZBUF_NO_WRITE);
                env.SetAlpha(MG_ALPHA_MACRO_ADD);
                sprite->CPSetDrawEnv(&env);
                sprite->CPSetTexture(light_tex);
                sprite->BeginCPSprite();
                mgZeroVector(uv0);
                mgZeroVector(uv1);
                uv1[1] = 64.0f;
                uv1[0] = 64.0f;
                float fire_size = 30.0f * (1.0f + 0.05f * (static_cast<float>(rand()) / 2147483648.0f - 0.5f));
                float flare_size = 20.0f * (1.0f + 0.05f * (static_cast<float>(rand()) / 2147483648.0f - 0.5f));
                color[3] = 128.0f;
                mngr->GetStart(FUNC_POINT_FIRE);
                first = mngr->Get();
                point = first;

                if (first != nullptr) {
                    do {
                        if (point->fire.effect_off == 0 && point->active != 0) {
                            size[0] = fire_size * point->scale[0];
                            size[1] = fire_size * point->scale[1];
                            std::memmove(position, point->position, sizeof(float) * 4);
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
                    } while (next != nullptr);
                }

                mngr->GetEnd();
                mngr->GetStart(FUNC_POINT_FLARE);
                first = mngr->Get();
                point = first;

                if (first != nullptr) {
                    do {
                        if (point->active != 0) {
                            size[0] = flare_size * point->scale[0];
                            size[1] = flare_size * point->scale[1];
                            std::memmove(position, point->position, sizeof(float) * 4);
                            sceVu0SubVector(to_camera, camera, position);
                            sceVu0Normalize(to_camera, to_camera);
                            sceVu0ScaleVector(to_camera, to_camera, 10.0f);
                            mgAddVector(position, to_camera);
                            position[3] = 1.0f;
                            sprite->CPSetSprite(position, size, point->fire.color, uv0, uv1);
                        }

                        next = mngr->Get();
                        point = next;
                    } while (next != nullptr);
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
                attr.fog = MG_FOG_BLACK;
                frame.attr = &attr;
                mgDrawDirect(&frame);
            }
        }
    }
}

namespace {
// The heat haze's frame copy, until a raster needs it.
void (*pending_fire_grab)() = nullptr;
} // namespace

void dc2::effects::DeferFireGrab(void (*grab)()) {
    pending_fire_grab = grab;
}

void dc2::effects::CancelFireGrab() {
    pending_fire_grab = nullptr;
}

void DrawFireRaster(float (*lw_matrix)[4], CFuncPointMngr *mngr, CFuncPointCheck *check, CFireRaster *raster) {
    float       position[4];
    CFuncPoint *first = {};
    CFuncPoint *next = {};
    CFuncPoint *point = {};

    if (raster != nullptr) {
        mngr->GetStart(FUNC_POINT_FIRE);
        first = mngr->Get();
        point = first;

        if (first != nullptr) {
            do {
                if (point->active != 0 && point->fire.heat_haze != 0) {
                    std::memmove(position, point->position, sizeof(float) * 4);
                    position[3] = 1.0f;
                    sceVu0ApplyMatrix(position, lw_matrix, position);
                    position[1] += 10.0f * point->scale[1];
                    float distance = mgGetDistFromCamera(position);

                    if (!(distance < 40.0f) && distance <= 400.0f) {
                        if (pending_fire_grab != nullptr) {
                            std::exchange(pending_fire_grab, nullptr)();
                        }
                        raster->Draw(position, point->scale);
                    }
                }

                next = mngr->Get();
                point = next;
            } while (next != nullptr);
        }

        mngr->GetEnd();
    }
}

int GetSeSrcVolPan(
    float (*mat)[4], CFuncPointMngr *mgr, CFuncPointCheck *chk, int *kinds, float *vols, float *pans, int max) {
    struct {
        float        v[3];
        unsigned int w;
    } q90{};

    float       v_a0[4];
    float       m_b0[4][4];
    CFuncPoint *p = {};
    int         n = {};

    n = 0;
    mgr->UpdateFlag(2, chk);
    mgr->GetStart(2);
    p = mgr->Get();

    if (p != nullptr) {
        do {
            if (p->active != 0) {
                if (n >= max) {
                    return n;
                }

                std::memmove(q90.v, p->position, sizeof(float) * 4);
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
        } while (p != nullptr);
    }

    mgr->GetEnd();

    if (mgr->UpdateFlag(8, chk) > 0) {
        mgr->GetStart(8);

        if ((p = mgr->Get()) != nullptr) {
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
                        std::memmove(q90.v, p->position, sizeof(float) * 4);
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
            } while ((p = mgr->Get()) != nullptr);
        }

        mgr->GetEnd();
    }

    return n;
}

float GetLightAnimeWeight(CFuncPoint *point, int frame) {
    float depth = point->plight.flicker_depth;
    int   period = fptosi(point->plight.flicker_period);
    float weight = 1.0f;
    int   phase = {};

    switch (point->type) {
        case FUNC_POINT_PLIGHT:
            switch (point->plight.flicker_type) {
                case FUNC_PLIGHT_FLICKER_NONE:
                    return weight;
                case FUNC_PLIGHT_FLICKER_RANDOM:
                    return weight * (1.0f - depth + depth * static_cast<float>(rand()) / 2147483648.0f);
                case FUNC_PLIGHT_FLICKER_SINE:
                    if (period > 0) {
                        phase = frame % period;
                        return weight * (1.0f - 0.5f * depth * (1.0f + sinf(TWO_PI * static_cast<float>(phase) / static_cast<float>(period))));
                    }

                    return weight;
                case FUNC_PLIGHT_FLICKER_SAW:
                    if (period > 0) {
                        phase = frame % period;
                        return weight * (1.0f - depth * static_cast<float>(phase) / static_cast<float>(period));
                    }

                    return weight;
            }

            break;
        case FUNC_POINT_FIRE:
        case FUNC_POINT_FLARE:
            return 0.7f + 0.3f * static_cast<float>(rand()) / 2147483648.0f;
    }

    return weight;
}

#include "common.h"

#include <cstddef>
#include <cstring>

#include "funcpoint.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"

void CFuncPoint::Initialize() {
    name = nullptr;
    active = 0;
    type = FUNC_POINT_NONE;
    unk_8 = flag_no = 0;
    enable = 1;
    start = end = 0.0f;
    anime = {};
    mgZeroVector(position);
    mgZeroVector(rotation);
    scale[0] = scale[1] = scale[2] = 1.0f;
    scale[3] = 0.0f;
}

int CFuncPointMngr::Copy(CFuncPointMngr &dest, mgCMemory *stack) {
    dest.Initialize();
    for (int kind = 0; kind < FUNC_POINT_TYPE_NUM; ++kind) {
        for (auto *node = list[kind]; node != nullptr; node = node->next) {
            auto *copy = dest.Add(kind, stack);
            if (copy == nullptr) {
                dest.Initialize();
                return 0;
            }
            auto &source = node->data;
            *copy = source;
        }
    }
    return 1;
}
