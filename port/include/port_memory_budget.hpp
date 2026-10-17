#pragma once

#ifdef PORT

#include <cassert>

#include "mg_memory.hpp"
#include "monster.hpp"

/** Extra logical quadwords per bumped `mem_table` model/metadata stack (see `charasetup.cpp`). */
#define CHARA_MODEL_LOAD_DELTA 12000

constexpr int kRetailHumanStack0Qw = 68500;
constexpr int kRetailHumanStack1Qw = 40000;

/** Minimum tail on dungeon stack 1 after floor map load, before `AssignStack(2|3)`. */
constexpr int DUNGEON_STAGE_STACK2_MIN = 65536;
/** Monster pools on stack 3 (`LoadMonsterFile` uses 4000 qw per active slot). */
constexpr int DUNGEON_STAGE_STACK3_MIN = MONSTER_ACTIVE_MAX * 4000 + 8192;
constexpr int DUNGEON_STAGE_TAIL_MARGIN = 4096;

constexpr int RETAIL_DNG_BUFF_READ_QUADWORDS = 200000;
/** Staging for chained `.map`/`.cfg`/`.mpk`/`.sky` loads in `LoadMapData` (no retail bounds check). */
constexpr int PORT_DNG_BUFF_READ_QUADWORDS = 1000000;
constexpr int PORT_BUFF_READ_EXTRA_QW = PORT_DNG_BUFF_READ_QUADWORDS - RETAIL_DNG_BUFF_READ_QUADWORDS;

/** Compensate `MainBuffer` for character deltas, `BuffStageMain` tail, and larger `BuffReadData`. */
constexpr int PORT_MAIN_BUFFER_EXTRA_QW = CHARA_MODEL_LOAD_DELTA * 2 + 65536 + PORT_BUFF_READ_EXTRA_QW;
constexpr int PORT_MAIN_BUFFER_QUADWORDS = 0x1A0000 + PORT_MAIN_BUFFER_EXTRA_QW;

inline void PortCheckDungeonStageRestAfterMap(mgCMemory *map_stack) {
    if (map_stack == nullptr) {
        return;
    }
    const int rest = map_stack->stGetRest();
    const int need = DUNGEON_STAGE_STACK2_MIN + DUNGEON_STAGE_STACK3_MIN + DUNGEON_STAGE_TAIL_MARGIN;
    assert(rest >= need);
}

#endif
