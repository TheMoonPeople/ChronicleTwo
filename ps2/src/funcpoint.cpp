#include "common.h"
#include <cstring>
#include "sound.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "funcpoint.hpp"

extern "C" void Initialize__10CFuncPointFv(void *point);
extern "C" int Check__10CFuncPointFP15CFuncPointCheck(CFuncPoint *point, CFuncPointCheck *check);
extern "C" int GetEnd__14CFuncPointMngrFv(void *);
extern "C" int GetStart__14CFuncPointMngrFi(void *, int);
extern "C" int GetLWMatrix__8mgCFrameFPA4_f(void *, float (*)[4]);
extern "C" int mgMulMatrix__FPA4_fPA4_fPA4_f(float (*)[4], float (*)[4], float (*)[4]);
int sndGetVolPan(float *, float *, float *, float *, float, float);
int sndGetVolPan(float *, float *, float *, float, float);

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
    time -= (int)(time / 24.0f) * 24.0f;
    if (time < 0.0f) {
        time += 24.0f;
    }
    return time;
}
float SubTime(float a, float b) {
    float t = LimitTime(a - b);
    if (t <= 12.0f) return t;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", Step__9CObjAnimeFP12CObjAnimeEnv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", SetParam__9CObjAnimeFPf);
void CObjAnime::GetParam(float *out_value) {
    CFuncPoint::AnimeData *settings = &func_point->anime;
    void *target = frame;
    if (target == NULL) {
        target = piece;
    }
    if (target == NULL) {
        target = parts;
    }
    if (target == NULL) {
        return;
    }
    *(u_long128 *)out_value = *(u_long128 *)param;
    switch (settings->unk_2c) {
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
    if (settings->unk_34 != 0) {
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
    char *piece_name = point->anime.piece_name;
    char *frame_name = point->anime.frame_name;
    CMapPiece *matched_piece = NULL;
    mgCFrame *matched_frame = NULL;
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
    *(u_long128 *)initial_value = *(u_long128 *)func_point->anime.param;
    SetParam(initial_value);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", Add__14CFuncPointMngrFiP9mgCMemory);

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", Reserve__14CFuncPointMngrFiP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", __ct__19CList_10CFuncPoint_Fv);
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
    int count = 1;
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
    int count = 0;
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
void CFuncPointMngr::GetEnd(void) {
    now = NULL;
}
CFuncPoint *CFuncPointMngr::Search(char *name) {
    CFuncPoint *first;
    CFuncPoint *next;
    int kind;
    CFuncPoint *point;

    kind = 1;
    do {
        GetStart(kind);
        first = Get();
        point = first;
        if (first != NULL) {
            do {
                if (strcasecmp(*(char **)point, name) == 0) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", GetLight__14CFuncPointMngrFPfP10CFuncPointiP15CFuncPointChecki);
void CFuncPointMngr::Step(int i, CFuncPointCheck *c) { this->UpdateFlag(i, c); }
int CFuncPointMngr::UpdateFlag(int type, CFuncPointCheck *check) {
    CFuncPoint *first;
    CFuncPoint *next;
    CFuncPoint *point;
    int active;
    int count;

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", UpdateStatus__14CFuncPointMngrFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", Copy__14CFuncPointMngrFR14CFuncPointMngrP9mgCMemory);
void CFuncPointMngr::Initialize() {
    for (int type = 0; type < FUNC_POINT_TYPE_NUM; type++) {
        list[type] = NULL;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", DrawFireEffect__FPA4_fP14CFuncPointMngrP15CFuncPointCheckfP10mgCTextureP10mgCTexture);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", DrawFireRaster__FPA4_fP14CFuncPointMngrP15CFuncPointCheckP11CFireRaster);
int GetSeSrcVolPan(
    float (*mat)[4], CFuncPointMngr *mgr, CFuncPointCheck *chk, int *kinds, float *vols, float *pans, int max) {
    struct {
        float v[3];
        unsigned int w;
    } q90;
    float v_a0[4];
    float m_b0[4][4];
    CFuncPoint *p;
    int n;

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
                *(u_long128 *)q90.v = *(u_long128 *)p->position;
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
                        sndGetVolPan(vols, pans, q90.v, v_a0, p->sound.unk_24, p->sound.unk_28);
                    } else {
                        *(u_long128 *)q90.v = *(u_long128 *)p->position;
                        q90.w = 0x3F800000;
                        sceVu0ApplyMatrix(q90.v, mat, q90.v);
                        sndGetVolPan(vols, pans, q90.v, p->sound.unk_24, p->sound.unk_28);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/funcpoint", GetLightAnimeWeight__FP10CFuncPointi);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/funcpoint", at_475__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/funcpoint", at_1118__3__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/funcpoint", __vt__14CFuncPointMngr__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/funcpoint", __vt__19CList_10CFuncPoint___DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(init_1175, 0x4);
INCLUDE_BSS(init_1204, 0x4);
INCLUDE_BSS(init_1208, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(sp_3d_1174, 0x50);
INCLUDE_BSS(frame_1203, 0x110);
INCLUDE_BSS(Bound_1206, 0xB0);
INCLUDE_BSS(attr_1207, 0x90);
