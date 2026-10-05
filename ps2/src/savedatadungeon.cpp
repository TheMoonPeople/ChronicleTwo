#include "common.h"
#include "savedatadungeon.hpp"
#include <cstdio>
#include <cstring>

extern short limmit_table[];
// Code (.text)
extern const char at_79[];

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

    return (DNG_FLOOR_SAVE *)((u8 *)this + index * sizeof(DNG_FLOOR_SAVE) + 0x3C);
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
    printf(at_79, stage_id, prev_floor_id[stage_id], floor);
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/savedatadungeon", limmit_table__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/savedatadungeon", at_79__DATA);
