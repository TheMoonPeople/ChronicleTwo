#include "common.h"

#include <cstdio>
#include <cstring>

#include "savedatadungeon.hpp"

/**
 * Number of saved floor records in each dungeon.
 */
static short limmit_table[7] = {9, 16, 25, 21, 23, 29, 39};

// Code (.text)

DNG_FLOOR_SAVE *CSaveDataDungeon::GetFloorInfoPtr(int dungeon, int floor) {
    if (dungeon < 0 || dungeon >= 7) {
        return NULL;
    }

    if (floor < 0 || floor >= limmit_table[dungeon]) {
        return NULL;
    }

    int index = 0;

    for (int i = 0; i < dungeon; i++) {
        index += limmit_table[i];
    }

    index += floor;

    return &floor_info[index];
}

void CSaveDataDungeon::Initialize() {
    memset(floor_info, 0, sizeof(floor_info));

    for (int i = 0; i < 7; i++) {
        DNG_FLOOR_SAVE *info = GetFloorInfoPtr(i, 0);

        if (info) {
            info->visit_count = 1;
            info->flag = 3;
        }

        info = GetFloorInfoPtr(i, 1);

        if (info) {
            info->flag = 1;
        }
    }

    for (int i = 0; i < 7; i++) {
        prev_floor_id[i] = -1;
    }

    for (int i = 0; i < 7; i++) {
        floor_id[i] = 1;
    }

    stage_id = 0;
}

void CSaveDataDungeon::SetFloorID(int floor) {
    prev_floor_id[stage_id] = floor_id[stage_id];
    floor_id[stage_id] = floor;
    printf("[%d] FLOOR :::    %d ----->> %d \n", stage_id, prev_floor_id[stage_id], floor);
}
