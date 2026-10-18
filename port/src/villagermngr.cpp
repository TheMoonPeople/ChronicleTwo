#include "common.h"

#include "villagermngr.hpp"
#include "vlgr_info.hpp"

// Retail walks place[alternative][time] and the output arrays with 4-byte strides.
PORT_OVERRIDE int CVillagerMngr::GetAppearVlgr(int progress, int time, int map_no, int *villager_ids,
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
