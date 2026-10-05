#include "common.h"
#include "mg_memory.hpp"
#include "villagermngr.hpp"
#include "mg_math.hpp"

// Code (.text)
void CVillagerPlace::ProgressInfo::Init() {
    progress = 0;
    place[0][1] = NULL;
    place[0][0] = NULL;
    place[1][1] = NULL;
    place[1][0] = NULL;
    place[2][1] = NULL;
    place[2][0] = NULL;
    place[3][1] = NULL;
    place[3][0] = NULL;
}
void CVillagerData::Initialize() {
    chara_id = -1;
    vlgr_id = -1;
    unk_c = 0;
    unk_8 = -1;
    stay = 0;
    unk_10 = 0;
    place = NULL;
    route = NULL;
    route_time = 0;
    req_motion = 0;
    ex_mode = 0;
    ex_step = 0;
    ex_time = 0;
    motion_flag = 0;
    motion_end = 0;
    parts_mode = 0;
    mgZeroVectorW(pos);
    mgZeroVector(rot);
}
CVillagerPlaceInfo::Node *CVillagerPlaceInfo::Add(mgCMemory *memory) {
    CVillagerPlaceInfo::Node *node =
        (CVillagerPlaceInfo::Node *)operator new(sizeof(CVillagerPlaceInfo::Node), (u_long128 *)memory->Alloc(4));
    if (node == NULL) {
        return NULL;
    }
    node->next = NULL;
    node->type = 0;
    CVillagerPlaceInfo::Node *last;
    CVillagerPlaceInfo::Node *following;
    last = route;
    if (last == NULL) {
        route = node;
        return node;
    }
    while ((following = last->next) != NULL) {
        last = following;
    }
    last->next = node;
    return node;
}
void CVillagerMngr::Initialize() {
    data_num = 0x20;
    for (int i = 0; i < data_num; i++) {
        data[i].Initialize();
    }
    stop = 0;
}
CVillagerData *CVillagerMngr::GetData(int index) {
    if (index < 0 || index >= data_num) {
        return NULL;
    }
    return &data[index];
}
void CVillagerMngr::Stay(int chara_id) {
    CVillagerData *villager = GetData(chara_id);
    if (villager != NULL) {
        villager->stay++;
    }
}
void CVillagerMngr::CancelStay(int index) {
    CVillagerData *villager = GetData(index);
    if (villager != NULL) {
        villager->stay = villager->stay - 1;
        if (villager->stay < 0) {
            villager->stay = 0;
        }
    }
}
void CVillagerMngr::ExMode(int index) {
    CVillagerData *villager = GetData(index);
    if (villager != NULL) {
        if (villager->ex_mode == 0) {
            villager->ex_mode = 1;
            villager->ex_step = 1;
        }
        villager->ex_time = 0;
    }
}
int CVillagerMngr::SearchDataIDatCharaID(int chara_id) {
    for (int i = 0; i < data_num; i++) {
        if (data[i].chara_id == chara_id) {
            return i;
        }
    }
    return -1;
}
int CVillagerMngr::Register(int vlgr_id, int chara_id, CVillagerPlaceInfo *place) {
    CVillagerData *villager = NewData();
    if (villager == NULL) {
        return 0;
    }
    villager->Initialize();
    villager->vlgr_id = vlgr_id;
    villager->chara_id = chara_id;
    villager->place = place;
    if (place != NULL) {
        sceVu0CopyVector(villager->pos, place->pos);
        villager->pos[3] = 1.0f;
        mgZeroVector(villager->rot);
        villager->rot[1] = place->pos[3];
    }
    return 1;
}
void CVillagerMngr::DeleteCharaID(int chara_id) {
    for (int i = 0; i < data_num; i++) {
        if (data[i].chara_id == chara_id) {
            data[i].Initialize();
        }
    }
}
CVillagerData *CVillagerMngr::NewData() {
    for (int i = 0; i < data_num; i++) {
        if (data[i].vlgr_id < 0) {
            return &data[i];
        }
    }
    return NULL;
}
int CVillagerMngr::CheckStay(int chara_id) {
    CVillagerData *villager = GetData(chara_id);
    if (villager == NULL) {
        return 0;
    }
    if (villager->ex_mode != 0) {
        return 0;
    }
    if (stop != 0) {
        return 1;
    }
    return villager->stay;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/villagermngr", Step__13CVillagerMngrFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/villagermngr", GetAppearVlgr__13CVillagerMngrFiiiPiPP18CVillagerPlaceInfo);
int CVillagerMngr::GetTalkRect(int chara_id, float *rect) {
    CVillagerMngr *mngr = this;
    int index;
    CVillagerData *villager;
    CVillagerPlaceInfo *place;
    int is_empty;

    *(int *)&rect[3] = 0;
    index = mngr->SearchDataIDatCharaID(chara_id);
    if (index < 0) {
        return 0;
    }
    villager = mngr->GetData(index);
    if (villager == NULL) {
        return 0;
    }
    place = villager->place;
    if (place == NULL) {
        return 0;
    }

    *(u_long128 *)rect = *(u_long128 *)place->talk_offset;

    if (mgDistVector(rect) != 0.0f) {
        is_empty = 0;
    } else {
        is_empty = 1;
    }
    return is_empty ^ 1;
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/villagermngr", at_513__DATA);
