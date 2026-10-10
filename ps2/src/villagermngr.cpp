#include "common.h"

#include <cmath>

#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "villagermngr.hpp"
#include "vlgr_info.hpp"

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
        *(u_long128 *) villager->pos = *(u_long128 *) place->pos;
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

union VillagerVector {
    float     v[4];
    u_long128 qw;
};

void CVillagerMngr::Step() {
    float          camera_direction[4];
    VillagerVector target;
    VillagerVector current;
    float          direction[4];

    for (int index = 0; index < data_num; ++index) {
        CVillagerData *villager = GetData(index);

        if (villager != NULL && villager->vlgr_id >= 0) {
            CVillagerPlaceInfo *place = villager->place;

            if (place != NULL) {
                if (villager->ex_mode != 0) {
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
                                villager->req_motion = villager->place->motion;
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

                    switch (villager->ex_step) {
                        case VLGR_EX_STEP_IN:
                        case VLGR_EX_STEP_OUT:
                            int motion = villager->now_motion;

                            if (motion != VLGR_MOTION_CAMERA_OUT && motion != VLGR_MOTION_CAMERA && motion != VLGR_MOTION_CAMERA_IN) {
                                villager->ex_step = VLGR_EX_STEP_END;
                            }

                            break;
                    }

                    if (villager->ex_time == 0) {
                        mgGetDirFromCamera(camera_direction, villager->pos);
                        villager->rot[1] = mgAngleInterpolate(villager->rot[1], mgAngleLimit(atan2f(camera_direction[0], camera_direction[2]) - 3.1415927f), 4.0f, MG_INTERPOLATE_FRACTION);
                    }

                    ++villager->ex_time;
                } else if (villager->stay <= 0 && stop == 0) {
                    CVillagerPlaceInfo::Node *route = place->route;

                    if (route == NULL) {
                        villager->rot[1] = mgAngleInterpolate(villager->rot[1], place->pos[3], 8.0f, MG_INTERPOLATE_FRACTION);

                        if (mgAngleCmp(villager->rot[1], villager->place->pos[3], 0.1f) == 0) {
                            villager->req_motion = villager->place->motion;
                            villager->rot[1] = villager->place->pos[3];
                        } else {
                            villager->req_motion = VLGR_MOTION_WALK;
                        }
                    } else {
                        if (villager->route == NULL) {
                            villager->route = route;
                            villager->route_time = 0;
                        }

                        CVillagerPlaceInfo::Node *node;
                        goto check_route;
                    route_step:
                        switch (node->type) {
                            case VLGR_ROUTE_WAIT: {
                                if (villager->route_time == 0) {
                                    villager->req_motion = node->wait.motion;
                                }

                                ++villager->route_time;
                                node = villager->route;
                                int done = villager->route_time > node->wait.time;

                                switch (node->wait.motion_end) {
                                    case 1:
                                        if (villager->motion_end != 0) {
                                            done = 1;
                                        }

                                        break;
                                }

                                switch (done) {
                                    case 0:
                                        break;
                                    default:
                                        villager->route = node->next;
                                        villager->route_time = 0;
                                }

                                break;
                            }
                            case VLGR_ROUTE_MOVE: {
                                target = *(VillagerVector *) node->pos;
                                current = *(VillagerVector *) villager->pos;
                                float facing = villager->rot[1];
                                sceVu0SubVector(direction, target.v, current.v);

                                if (mgDistVectorXZ(direction) < 10.0f) {
                                    villager->route = villager->route->next;
                                    villager->route_time = 0;
                                }

                                sceVu0Normalize(direction, direction);
                                float next_angle = mgAngleInterpolate(facing, mgAngleLimit(atan2f(direction[0], direction[2])), 8.0f, MG_INTERPOLATE_FRACTION);
                                float speed = villager->place->move_speed;

                                if (speed <= 0.0f) {
                                    speed = 0.8f;
                                }

                                sceVu0ScaleVector(direction, direction, speed);
                                direction[3] = 0.0f;
                                mgAddVector(current.v, direction);
                                *(VillagerVector *) villager->pos = current;
                                villager->rot[1] = next_angle;
                                villager->req_motion = villager->place->move_motion;
                                break;
                            }
                        }
                        goto next_villager;
                    check_route:
                        node = villager->route;

                        if (node != NULL) {
                            goto route_step;
                        }
                    }
                }
            }
        }

    next_villager:;
    }
}

int CVillagerMngr::GetAppearVlgr(int progress, int time, int map_no, int *villager_ids,
                                 CVillagerPlaceInfo **places) {
    int                           table_count;
    CVillagerPlace               *entry;
    GAME_PROGRESS_INFO           *current;
    int                           found;
    int                           villager_id;
    int                           handled;
    int                           point;
    int                           selected;
    int                           alternative;
    int                           alternative_offset;
    int                           output_offset;
    int                           output_position;
    int                           fallback_alternative;
    int                           fallback_offset;
    int                           fallback_output_position;
    CVillagerPlace::ProgressInfo *schedule;
    GAME_PROGRESS_INFO           *point_info;
    CVillagerPlaceInfo           *place;

    if (map_no < 0) {
        return 0;
    }

    entry = GetVlgrPlaceTable(&table_count);
    found = 0;

    if (progress < 2) {
        time = 0;
        progress = 1;
    }

    current = GetGameProgressInfo(progress);

    if (current == NULL) {
        return 0;
    }

    for (villager_id = 0; villager_id < table_count; villager_id++, entry++) {
        if (entry->prog_num > 0) {
            if (entry->prog_info != NULL) {
                point = entry->prog_num - 1;
                handled = 0;

                if (point >= 0) {
                    output_offset = found * sizeof(int);

                    do {
                        schedule = &entry->prog_info[point];
                        point_info = GetGameProgressInfo(schedule->progress);

                        if (point_info != NULL && current->order >= point_info->order) {
                            if (schedule->progress == progress || (schedule->after != 0 && schedule->after == 1)) {
                                selected = 0;
                                alternative = 0;
                                alternative_offset = 0;
                                output_position = output_offset;

                                do {
                                    place = *(CVillagerPlaceInfo **) ((u8 *) (time * sizeof(void *)) + (int) schedule + alternative_offset + 8);

                                    if (place != NULL) {
                                        handled = 1;
                                        selected = 1;

                                        if (map_no >= 0 && place->map_no == map_no) {
                                            *(CVillagerPlaceInfo **) ((u8 *) places + output_position) = place;
                                            *(int *) ((u8 *) villager_ids + output_position) = villager_id;
                                            output_position += sizeof(int);
                                            output_offset += sizeof(int);
                                            found++;
                                        }
                                    }

                                    alternative++;
                                    alternative_offset += 8;
                                } while (alternative < 4);

                                if (selected != 0) {
                                    break;
                                }
                            } else {
                                break;
                            }
                        }

                        point--;
                    } while (point >= 0);
                }

                if (handled == 0 && entry->prog_num > 0) {
                    schedule = entry->prog_info;

                    if (schedule->progress == 1) {
                        fallback_alternative = 0;
                        fallback_offset = 0;
                        fallback_output_position = found * sizeof(int);

                        do {
                            place = *(CVillagerPlaceInfo **) ((u8 *) (time * sizeof(void *)) + (int) schedule + fallback_offset + 8);

                            if (place != NULL && map_no >= 0 && place->map_no == map_no) {
                                *(CVillagerPlaceInfo **) ((u8 *) places + fallback_output_position) = place;
                                *(int *) ((u8 *) villager_ids + fallback_output_position) = villager_id;
                                fallback_output_position += sizeof(int);
                                found++;
                            }

                            fallback_alternative++;
                            fallback_offset += 8;
                        } while (fallback_alternative < 4);
                    }
                }
            }
        }
    }

    return found;
}

int CVillagerMngr::GetTalkRect(int chara_id, float *rect) {
    CVillagerMngr      *mngr = this;
    int                 index;
    CVillagerData      *villager;
    CVillagerPlaceInfo *place;
    int                 is_empty;

    rect[3] = 0.0f;
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

    *(u_long128 *) rect = *(u_long128 *) place->talk_offset;

    if (mgDistVector(rect) != 0.0f) {
        is_empty = 0;
    } else {
        is_empty = 1;
    }

    return is_empty ^ 1;
}
