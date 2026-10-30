#include "common.h"

#include <cmath>

#include "character.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "villagermngr.hpp"
#include "vlgr_info.hpp"

void CVillagerPlace::ProgressInfo::Init() {
    progress = 0;
    place[0][1] = nullptr;
    place[0][0] = nullptr;
    place[1][1] = nullptr;
    place[1][0] = nullptr;
    place[2][1] = nullptr;
    place[2][0] = nullptr;
    place[3][1] = nullptr;
    place[3][0] = nullptr;
}

void CVillagerData::Initialize() {
    chara_id = -1;
    vlgr_id = -1;
    unk_c = 0;
    unk_8 = -1;
    stay = 0;
    unk_10 = 0;
    place = nullptr;
    route = nullptr;
    route_time = 0;
    req_motion = 0;
    ex_mode = false;
    ex_step = 0;
    ex_time = 0;
    motion_flag = 0;
    motion_end = 0;
    parts_mode = VLGR_PARTS_MODE_NONE;
    mgZeroVectorW(pos);
    mgZeroVector(rot);
}

CVillagerPlaceInfo::Node *CVillagerPlaceInfo::Add(mgCMemory *stack) {
    if (stack == nullptr) {
        return nullptr;
    }
    Node *node = dc2::memory::NewObject<Node>(*stack);

    if (node == nullptr) {
        return nullptr;
    }

    node->next = nullptr;
    node->type = 0;

    if (route == nullptr) {
        route = node;
        return node;
    }

    Node *last = route;

    while (last->next != nullptr) {
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
        return nullptr;
    }

    return &data[no];
}

void CVillagerMngr::Stay(int chara_id) {
    CVillagerData *villager = GetData(chara_id);

    if (villager != nullptr) {
        villager->stay++;
    }
}

void CVillagerMngr::CancelStay(int chara_id) {
    CVillagerData *villager = GetData(chara_id);

    if (villager != nullptr) {
        --villager->stay;

        if (villager->stay < 0) {
            villager->stay = 0;
        }
    }
}

void CVillagerMngr::ExMode(int chara_id) {
    CVillagerData *villager = GetData(chara_id);

    if (villager != nullptr) {
        if (villager->ex_mode == 0) {
            villager->ex_mode = true;
            villager->ex_step = VLGR_EX_STEP_START;
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

    if (villager == nullptr) {
        return false;
    }

    villager->Initialize();
    villager->vlgr_id = vlgr_id;
    villager->chara_id = chara_id;
    villager->place = place;

    if (place != nullptr) {
        *reinterpret_cast<u_long128 *>(villager->pos) = *reinterpret_cast<u_long128 *>(place->pos);
        villager->pos[3] = 1.0f;
        mgZeroVector(villager->rot);
        villager->rot[1] = place->pos[3];
    }

    return true;
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

    return nullptr;
}

int CVillagerMngr::CheckStay(int chara_id) {
    CVillagerData *villager = GetData(chara_id);

    if (villager == nullptr) {
        return false;
    }

    if (villager->ex_mode != 0) {
        return false;
    }

    if (stop != 0) {
        return true;
    }

    return villager->stay;
}

/**
 *
 * Views a vector as floats or as one quadword for whole-vector copies.
 *
 */
union VillagerVector {
    float     v[4]; /**< Components of the vector. */
    u_long128 qw;   /**< The vector as one quadword. */
};

void CVillagerMngr::Step() {
    float          camera_direction[4];
    VillagerVector target{};
    VillagerVector current{};
    float          direction[4];

    for (int index = 0; index < data_num; ++index) {
        CVillagerData *villager = GetData(index);

        if (villager != nullptr && villager->vlgr_id >= 0) {
            CVillagerPlaceInfo *place = villager->place;

            if (place != nullptr) {
                if (villager->ex_mode != 0) {
                    switch (villager->ex_step) {
                        case VLGR_EX_STEP_START:
                            villager->ex_step = VLGR_EX_STEP_IN;
                            villager->req_motion = VLGR_MOTION_CAMERA_IN;
                            villager->motion_flag = CHARA_MOTION_HOLD;
                            villager->parts_mode = VLGR_PARTS_MODE_POSE;
                            break;
                        case VLGR_EX_STEP_IN:
                            villager->req_motion = VLGR_MOTION_NONE;

                            if (villager->motion_end != 0) {
                                villager->req_motion = VLGR_MOTION_CAMERA;
                                villager->motion_flag = CHARA_MOTION_RESTART;
                                villager->ex_step = VLGR_EX_STEP_HOLD;
                            }

                            break;
                        case VLGR_EX_STEP_HOLD:
                            villager->req_motion = VLGR_MOTION_CAMERA;

                            if (villager->ex_time > 3) {
                                villager->ex_step = VLGR_EX_STEP_OUT;
                                villager->parts_mode = VLGR_PARTS_MODE_NORMAL;
                                villager->req_motion = VLGR_MOTION_CAMERA_OUT;
                                villager->motion_flag = CHARA_MOTION_HOLD;
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
                            villager->parts_mode = VLGR_PARTS_MODE_NORMAL;
                            break;
                        case VLGR_EX_STEP_END:
                            villager->ex_mode = false;
                            villager->parts_mode = VLGR_PARTS_MODE_NONE;
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
                        villager->rot[1] = mgAngleInterpolate(villager->rot[1], mgAngleLimit(atan2f(camera_direction[0], camera_direction[2]) - PI), 4.0f, MG_INTERPOLATE_FRACTION);
                    }

                    ++villager->ex_time;
                } else if (villager->stay <= 0 && stop == 0) {
                    CVillagerPlaceInfo::Node *route = place->route;

                    if (route == nullptr) {
                        villager->rot[1] = mgAngleInterpolate(villager->rot[1], place->pos[3], 8.0f, MG_INTERPOLATE_FRACTION);

                        if (mgAngleCmp(villager->rot[1], villager->place->pos[3], 0.1f) == 0) {
                            villager->req_motion = villager->place->motion;
                            villager->rot[1] = villager->place->pos[3];
                        } else {
                            villager->req_motion = VLGR_MOTION_WALK;
                        }
                    } else {
                        if (villager->route == nullptr) {
                            villager->route = route;
                            villager->route_time = 0;
                        }

                        CVillagerPlaceInfo::Node *node = villager->route;
                        if (node != nullptr) {
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
                                    target = *reinterpret_cast<VillagerVector *>(node->pos);
                                    current = *reinterpret_cast<VillagerVector *>(villager->pos);
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
                                    *reinterpret_cast<VillagerVector *>(villager->pos) = current;
                                    villager->rot[1] = next_angle;
                                    villager->req_motion = villager->place->move_motion;
                                    break;
                                }
                            }
                            continue;
                        }
                    }
                }
            }
        }
    }
}

int CVillagerMngr::GetTalkRect(int chara_id, float *rect) {
    CVillagerMngr      *mngr = this;
    int                 index = {};
    CVillagerData      *villager = {};
    CVillagerPlaceInfo *place = {};
    int                 is_empty = {};

    rect[3] = 0.0f;
    index = mngr->SearchDataIDatCharaID(chara_id);

    if (index < 0) {
        return false;
    }

    villager = mngr->GetData(index);

    if (villager == nullptr) {
        return false;
    }

    place = villager->place;

    if (place == nullptr) {
        return false;
    }

    *reinterpret_cast<u_long128 *>(rect) = *reinterpret_cast<u_long128 *>(place->talk_offset);

    if (mgDistVector(rect) != 0.0f) {
        is_empty = false;
    } else {
        is_empty = true;
    }

    return is_empty ^ 1;
}

#include "common.h"

#include "villagermngr.hpp"
#include "vlgr_info.hpp"

// Retail walks place[alternative][time] and the output arrays with 4-byte strides.
int CVillagerMngr::GetAppearVlgr(int progress, int time, int map_no, int *villager_ids,
                                 CVillagerPlaceInfo **places) {
    if (map_no < 0) {
        return 0;
    }

    int             table_count = 0;
    CVillagerPlace *entry = GetVlgrPlaceTable(&table_count);
    int             found = 0;

    if (progress < 2) {
        time = 0;
        progress = 1;
    }

    const GAME_PROGRESS_INFO *current = GetGameProgressInfo(progress);
    if (current == nullptr) {
        return 0;
    }

    for (int villager_id = 0; villager_id < table_count; villager_id++, entry++) {
        if (entry->prog_num <= 0 || entry->prog_info == nullptr) {
            continue;
        }

        // Records the schedule's places on this map; returns whether it has any place at this time.
        const auto collect = [&](const CVillagerPlace::ProgressInfo &schedule) {
            bool any = false;
            for (const auto *alternative : schedule.place) {
                CVillagerPlaceInfo *place = alternative[time];
                if (place == nullptr) {
                    continue;
                }
                any = true;
                if (place->map_no == map_no) {
                    places[found] = place;
                    villager_ids[found] = villager_id;
                    found++;
                }
            }
            return any;
        };

        // The latest reached schedule with a place at this time wins.
        bool handled = false;
        for (int point = entry->prog_num - 1; point >= 0 && !handled; point--) {
            const CVillagerPlace::ProgressInfo &schedule = entry->prog_info[point];
            const GAME_PROGRESS_INFO           *point_info = GetGameProgressInfo(schedule.progress);
            if (point_info == nullptr || current->order < point_info->order) {
                continue;
            }
            if (schedule.progress != progress && schedule.after != 1) {
                break;
            }
            handled = collect(schedule);
        }

        if (!handled && entry->prog_info[0].progress == 1) {
            collect(entry->prog_info[0]);
        }
    }

    return found;
}
