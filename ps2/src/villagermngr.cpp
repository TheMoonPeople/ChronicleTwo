#include "common.h"
#include "mg_memory.hpp"
#include "villagermngr.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "vlgr_info.hpp"

#include <cmath>

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
CVillagerPlaceInfo::Node *CVillagerPlaceInfo::Add(mgCMemory *stack) {
    Node *node = new (stack->Alloc(4)) Node;
    if (node == NULL) {
        return NULL;
    }
    node->next = NULL;
    node->type = 0;
    if (route == NULL) {
        route = node;
        return node;
    }
    Node *last = route;
    while (last->next != NULL) {
        last = last->next;
    }
    last->next = node;
    return node;
}
void CVillagerMngr::Initialize() {
    data_num = 32;
    for (int index = 0; index < data_num; ++index) {
        data[index].Initialize();
    }
    stop = 0;
}
CVillagerData *CVillagerMngr::GetData(int no) {
    if (no < 0 || no >= data_num) {
        return NULL;
    }
    return &data[no];
}
void CVillagerMngr::Stay(int chara_id) {
    CVillagerData *villager = GetData(chara_id);
    if (villager != NULL) {
        villager->stay++;
    }
}
void CVillagerMngr::CancelStay(int chara_id) {
    CVillagerData *villager = GetData(chara_id);
    if (villager != NULL) {
        --villager->stay;
        if (villager->stay < 0) {
            villager->stay = 0;
        }
    }
}
void CVillagerMngr::ExMode(int chara_id) {
    CVillagerData *villager = GetData(chara_id);
    if (villager != NULL) {
        if (villager->ex_mode == 0) {
            villager->ex_mode = 1;
            villager->ex_step = 1;
        }
        villager->ex_time = 0;
    }
}
int CVillagerMngr::SearchDataIDatCharaID(int chara_id) {
    for (int index = 0; index < data_num; ++index) {
        if (data[index].chara_id == chara_id) {
            return index;
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
    for (int index = 0; index < data_num; ++index) {
        if (data[index].chara_id == chara_id) {
            data[index].Initialize();
        }
    }
}
CVillagerData *CVillagerMngr::NewData() {
    for (int index = 0; index < data_num; ++index) {
        if (data[index].vlgr_id < 0) {
            return &data[index];
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
#ifdef NONMATCHING
void CVillagerMngr::Step() {
    for (int index = 0; index < data_num; ++index) {
        CVillagerData *villager = GetData(index);
        if (villager == NULL || villager->vlgr_id < 0 || villager->place == NULL) {
            continue;
        }
        CVillagerPlaceInfo *place = villager->place;
        if (villager->ex_mode == 0) {
            if (villager->stay > 0 || stop != 0) {
                continue;
            }
            if (place->route == NULL) {
                villager->rot[1] = mgAngleInterpolate(villager->rot[1], place->pos[3], 8.0f,
                                                       MG_INTERPOLATE_FRACTION);
                if (mgAngleCmp(villager->rot[1], place->pos[3], 0.1f) == 0) {
                    villager->req_motion = place->motion;
                    villager->rot[1] = place->pos[3];
                } else {
                    villager->req_motion = VLGR_MOTION_WALK;
                }
                continue;
            }
            if (villager->route == NULL) {
                villager->route = place->route;
                villager->route_time = 0;
            }
            CVillagerPlaceInfo::Node *node = villager->route;
            if (node == NULL) {
                continue;
            }
            if (node->type == VLGR_ROUTE_MOVE) {
                sceVu0FVECTOR target;
                sceVu0FVECTOR current;
                sceVu0FVECTOR direction;
                sceVu0CopyVector(target, node->pos);
                sceVu0CopyVector(current, villager->pos);
                float facing = villager->rot[1];
                sceVu0SubVector(direction, target, current);
                if (mgDistVectorXZ(direction) < 10.0f) {
                    villager->route = node->next;
                    villager->route_time = 0;
                }
                sceVu0Normalize(direction, direction);
                float target_angle = mgAngleLimit(atan2f(direction[0], direction[2]));
                float next_angle = mgAngleInterpolate(facing, target_angle, 8.0f,
                                                       MG_INTERPOLATE_FRACTION);
                float speed = place->move_speed;
                if (speed <= 0.0f) {
                    speed = 0.8f;
                }
                sceVu0ScaleVector(direction, direction, speed);
                direction[3] = 0.0f;
                mgAddVector(current, direction);
                sceVu0CopyVector(villager->pos, current);
                villager->rot[1] = next_angle;
                villager->req_motion = place->move_motion;
            } else if (node->type == VLGR_ROUTE_WAIT) {
                if (villager->route_time == 0) {
                    villager->req_motion = node->wait.motion;
                }
                ++villager->route_time;
                bool done = villager->route_time > node->wait.time;
                if (node->wait.motion_end == 1 && villager->motion_end != 0) {
                    done = true;
                }
                if (done) {
                    villager->route = node->next;
                    villager->route_time = 0;
                }
            }
            continue;
        }
        switch (villager->ex_step) {
        case VLGR_EX_STEP_START:
            villager->ex_step = VLGR_EX_STEP_IN;
            villager->req_motion = VLGR_MOTION_CAMERA_IN;
            villager->motion_flag = 2;
            villager->parts_mode = 1;
            break;
        case VLGR_EX_STEP_IN:
            villager->req_motion = VLGR_MOTION_NONE;
            if (villager->motion_end != 0) {
                villager->req_motion = VLGR_MOTION_CAMERA;
                villager->motion_flag = 4;
                villager->ex_step = VLGR_EX_STEP_HOLD;
            }
            break;
        case VLGR_EX_STEP_HOLD:
            villager->req_motion = VLGR_MOTION_CAMERA;
            if (villager->ex_time > 3) {
                villager->ex_step = VLGR_EX_STEP_OUT;
                villager->parts_mode = 2;
                villager->req_motion = VLGR_MOTION_CAMERA_OUT;
                villager->motion_flag = 2;
            }
            break;
        case VLGR_EX_STEP_OUT:
            if (villager->motion_end != 0) {
                villager->ex_step = VLGR_EX_STEP_RESTORE;
                villager->req_motion = place->motion;
            }
            break;
        case VLGR_EX_STEP_RESTORE:
            villager->ex_step = VLGR_EX_STEP_END;
            villager->parts_mode = 2;
            break;
        case VLGR_EX_STEP_END:
            villager->ex_mode = 0;
            villager->parts_mode = 0;
            break;
        }
        if ((villager->ex_step == VLGR_EX_STEP_OUT || villager->ex_step == VLGR_EX_STEP_IN) &&
            villager->now_motion != VLGR_MOTION_CAMERA_OUT &&
            villager->now_motion != VLGR_MOTION_CAMERA &&
            villager->now_motion != VLGR_MOTION_CAMERA_IN) {
            villager->ex_step = VLGR_EX_STEP_END;
        }
        if (villager->ex_time == 0) {
            sceVu0FVECTOR camera_direction;
            mgGetDirFromCamera(camera_direction, villager->pos);
            float camera_angle = mgAngleLimit(atan2f(camera_direction[0], camera_direction[2]) - 3.1415927f);
            villager->rot[1] = mgAngleInterpolate(villager->rot[1], camera_angle, 4.0f,
                                                   MG_INTERPOLATE_FRACTION);
        }
        ++villager->ex_time;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/villagermngr", Step__13CVillagerMngrFv);
#endif
#ifdef NONMATCHING
int CVillagerMngr::GetAppearVlgr(int progress, int time, int map_no, int *villager_ids,
                                CVillagerPlaceInfo **places) {
    if (map_no < 0) {
        return 0;
    }
    int table_count;
    CVillagerPlace *table = GetVlgrPlaceTable(&table_count);
    if (progress < 2) {
        progress = 1;
        time = VLGR_TIME_NOON;
    }
    GAME_PROGRESS_INFO *current = GetGameProgressInfo(progress);
    if (current == NULL) {
        return 0;
    }
    int found = 0;
    for (int villager_id = 0; villager_id < table_count; ++villager_id) {
        CVillagerPlace &entry = table[villager_id];
        bool handled = false;
        if (entry.prog_num > 0 && entry.prog_info != NULL) {
            for (int point = entry.prog_num - 1; point >= 0; --point) {
                CVillagerPlace::ProgressInfo &schedule = entry.prog_info[point];
                GAME_PROGRESS_INFO *point_info = GetGameProgressInfo(schedule.progress);
                if (point_info == NULL || current->order < point_info->order) {
                    continue;
                }
                if (schedule.progress == progress || schedule.after == 1) {
                    for (int alternative = 0; alternative < 4; ++alternative) {
                        CVillagerPlaceInfo *place = schedule.place[alternative][time];
                        if (place != NULL) {
                            handled = true;
                            if (place->map_no == map_no) {
                                villager_ids[found] = villager_id;
                                places[found] = place;
                                ++found;
                            }
                        }
                    }
                    if (handled) {
                        break;
                    }
                }
            }
            if (!handled && entry.prog_info[0].progress == 1) {
                for (int alternative = 0; alternative < 4; ++alternative) {
                    CVillagerPlaceInfo *place = entry.prog_info[0].place[alternative][time];
                    if (place != NULL && place->map_no == map_no) {
                        villager_ids[found] = villager_id;
                        places[found] = place;
                        ++found;
                    }
                }
            }
        }
    }
    return found;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/villagermngr", GetAppearVlgr__13CVillagerMngrFiiiPiPP18CVillagerPlaceInfo);
#endif
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
