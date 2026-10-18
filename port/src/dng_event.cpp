// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <format>
#include <iterator>
#include <ranges>
#include <span>
#include <vector>

#include "collision_assets.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "dng_event.hpp"
#include "dng_event_port.hpp"
#include "dng_main.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "monster_memory.hpp"
#include "platform/arena.hpp"
#include "runscript.hpp"
#include "save_slots.hpp"
#include "scene.hpp"
#include "snd_mngr.hpp"

// Retail's body is empty. Every dungeon's floor load event (1010) calls it once the floor is chosen and before the
// floor's own events, which makes it the state a dungeon autosave keeps.
PORT_OVERRIDE void DungeonFloorInit() { SaveSlotRecordFloorEntry(); }

PORT_OVERRIDE void CTreasureBoxManager::SetCollisionModel(u32 *model, mgCMemory *memory) {
    const auto path = DataReadBufferPath(model);
    col_frame = path ? LoadCollisionModel(*path, memory, "tbox_a") : nullptr;
}

void PrepareMonsterMemory(CMonsterMan &manager) {
    // Model copies grow individual slots when their source character is known.
    constexpr int quadwords = kMonsterScriptQuadwords + 4;
    for (int index = 0; index < PortMonsterActiveLimit(); ++index) {
        auto &slot = manager.memory[index];
        std::snprintf(slot.name, sizeof(slot.name), "monster slot %d", index);
        auto *buffer = reinterpret_cast<u_long128 *>(ArenaBlock(&slot, static_cast<std::size_t>(quadwords) * sizeof(u_long128)));
        slot.stSetBuffer(buffer, quadwords);
        slot.stReset();
    }
}

PORT_OVERRIDE void LoadMonsterFile() {
    if (!ActiveMonster) {
        return;
    }
    ActiveMonster->Initialize(DngMainScene);
    DngMainScene->AssignStack(3);
    DngMainScene->ClearStack(3);
    auto *memory = DngMainScene->GetStack(3);
    if (!memory) {
        return;
    }
    PrepareMonsterMemory(*ActiveMonster);
    sndInitPort(5);
    auto &locate = ActiveMonster->locate;
    locate.num = locate.put_num = locate.put_flag = 0;
    for (int i = 0; i < MONSTER_LOCATE_MAX; ++i) {
        locate.param[i] = -1;
        locate.monster_id[i] = -1;
    }
    char path[76];
    std::snprintf(path, sizeof path, "dungeon/cfg_file/mos_place%d.cfg.json", DngSaveDataDungeon->stage_id);
    int size = 0;
    LoadFile(path, BuffReadData, &size);
    CreatMonsterFloorInfo(reinterpret_cast<char *>(BuffReadData), size);
    for (int i = 0; i < locate.num; ++i) {
        const int id = locate.monster_id[i];
        if (ActiveMonster->SearchBaseIndex(id) < 0) {
            ActiveMonster->EntryRefer(id, memory);
        }
    }
}

PORT_OVERRIDE void LoadMonsterFile(int monster_id, int initialize) {
    CScene      *scene = DngMainScene;
    CMonsterMan *manager = ActiveMonster;

    if (manager == nullptr) {
        return;
    }

    if (initialize != 0) {
        manager->Initialize(scene);
        scene->AssignStack(3);
        scene->ClearStack(3);
    }

    mgCMemory *memory = scene->GetStack(3);
    if (memory == nullptr) {
        return;
    }

    if (initialize != 0) {
        // Retail places these at +4 with a 0x30 stride; host pointers enlarge both fields.
        PrepareMonsterMemory(*manager);
        sndInitPort(5);
    }

    if (manager->SearchBaseIndex(monster_id) < 0) {
        manager->EntryRefer(monster_id, memory);
    }
}

// Retail's definition returns void against the fixed-up declaration (scripts/port/header_fixups.py).
PORT_OVERRIDE int CRedMarkModel::Draw() {
    float position[4];
    float saved_position[4];

    if (draw_request != 0) {
        GetPosition(position);
        GetPosition(saved_position);
        position[1] += 2.0f * sinf(angle);
        SetPosition(position);
        CObjectFrame::DrawDirect();
        SetPosition(saved_position);
        draw_request = false;
    }

    return 0;
}

namespace {

/**
 * Whether an index lies inside an array.
 */
template <typename Array>
bool Inside(const Array &array, int index) {
    return index >= 0 && static_cast<std::size_t>(index) < std::size(array);
}

/**
 * One monster of a floor's placement list.
 */
struct MonsterPlacement {
    int monster_id; /**< Monster kind. */
    int param;      /**< Value given to the monster. */
};

/**
 * Monsters placed on one floor of a monster_floors document.
 */
struct MonsterFloor {
    int                           floor;    /**< Floor the list belongs to. */
    std::vector<MonsterPlacement> monsters; /**< Monsters to place, in script order. */
};

/**
 * Parses a monster_floors document.
 */
std::vector<MonsterFloor> ParseMonsterFloors(const native_config::Json &document) {
    using namespace native_config;
    std::vector<MonsterFloor> floors;
    for (const auto &floor : Array(document, "floors")) {
        auto &entry = floors.emplace_back(MonsterFloor{.floor = Int(floor, "floor"), .monsters = {}});
        for (const auto &monster : Array(floor, "monsters")) {
            entry.monsters.push_back({.monster_id = Int(monster, "monster_id"), .param = Int(monster, "param")});
        }
    }
    return floors;
}

/**
 * The floor's placement list: the last block for it, which replaces any earlier one as FLS restarts the list.
 */
const MonsterFloor *FloorPlacements(const std::vector<MonsterFloor> &floors, int floor) {
    const MonsterFloor *found = nullptr;
    for (const auto &entry : floors) {
        if (entry.floor == floor) {
            found = &entry;
        }
    }
    return found;
}

/**
 * One item of a treasure box group.
 */
struct TreasureItem {
    int item_no; /**< Item that the box holds. */
    int rank;    /**< Value of the item. */
    int num;     /**< Number of the item. */
};

/**
 * One item group of a treasure_boxes document.
 */
struct TreasureGroup {
    int                       group_id; /**< Identifier that the floors use to name the group. */
    int                       item_num; /**< Item count the script gives the group. */
    std::vector<TreasureItem> items;    /**< Items of the group, in script order. */
};

/**
 * Groups that one floor draws from in a treasure_boxes document.
 */
struct TreasureFloor {
    int              floor;    /**< Floor number. */
    std::vector<int> group_id; /**< Identifiers of the groups the floor draws from. */
};

/**
 * Typed contents of a treasure_boxes document.
 */
struct TreasureTable {
    std::vector<TreasureGroup> groups;      /**< Item groups, in script order. */
    int                        floor_start; /**< Value of the script's FLOOR_START. */
    std::vector<TreasureFloor> floors;      /**< Floor assignments, in script order. */
};

/**
 * Parses a treasure_boxes document.
 */
TreasureTable ParseTreasureTable(const native_config::Json &document) {
    using namespace native_config;
    TreasureTable table{.groups = {}, .floor_start = Int(document, "floor_start"), .floors = {}};
    for (const auto &group : Array(document, "groups")) {
        auto &entry = table.groups.emplace_back(TreasureGroup{.group_id = Int(group, "group_id"), .item_num = Int(group, "item_num"), .items = {}});
        for (const auto &item : Array(group, "items")) {
            entry.items.push_back({.item_no = Int(item, "item_no"), .rank = Int(item, "rank"), .num = Int(item, "num")});
        }
    }
    for (const auto &floor : Array(document, "floors")) {
        table.floors.push_back({.floor = Int(floor, "floor"), .group_id = IntList(floor, "group_id")});
    }
    return table;
}

} // namespace

PORT_OVERRIDE void CreatMonsterFloorInfo(char *script, int /*length*/) {
    const auto floors = native_config::ReadBuffer<std::vector<MonsterFloor> >(script, "monster_floors", ParseMonsterFloors);
    if (!floors || ActiveMonster == nullptr) {
        return;
    }

    const MonsterFloor *floor = FloorPlacements(*floors, DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id]);
    if (floor == nullptr) {
        return;
    }

    auto &locate = ActiveMonster->locate;
    locate.num = 0;
    // Retail writes past the list for more than MONSTER_LOCATE_MAX monsters; the port drops the rest.
    for (const auto &monster : floor->monsters) {
        if (!Inside(locate.monster_id, locate.num)) {
            break;
        }
        locate.monster_id[locate.num] = static_cast<s16>(monster.monster_id);
        locate.param[locate.num] = static_cast<s16>(monster.param);
        locate.num++;
    }
}

std::vector<int> PortFloorMonsterIds(int dungeon, int floor) {
    const auto floors = native_config::Read<std::vector<MonsterFloor> >(
        std::format("dungeon/cfg_file/mos_place{}.cfg.json", dungeon), "monster_floors", ParseMonsterFloors);
    const MonsterFloor *entry = floors ? FloorPlacements(*floors, floor) : nullptr;
    std::vector<int>    ids;
    if (entry != nullptr) {
        // CreatMonsterFloorInfo keeps the first MONSTER_LOCATE_MAX.
        for (const auto &monster : entry->monsters | std::views::take(MONSTER_LOCATE_MAX)) {
            ids.push_back(monster.monster_id);
        }
    }
    return ids;
}

PORT_OVERRIDE void CreatTresuarBoxInfo(TRESURE_BOX_FLOOR_INFO *table, char *script, int /*length*/) {
    table->group_num = 0;
    table->floor_start = 0;
    table->rank_max = 0;
    table->rank_min = 100;

    if (const auto loaded = native_config::ReadBuffer<TreasureTable>(script, "treasure_boxes", ParseTreasureTable)) {
        // The group list starts empty, as GROUP_START leaves it.
        table->group_num = -1;
        // Retail indexes the groups, their items and the floors with script values, without the table's
        // limits; the port keeps what fits and drops the rest.
        for (const auto &source : loaded->groups) {
            if (!Inside(table->group, table->group_num + 1)) {
                break;
            }
            auto &group = table->group[++table->group_num];
            group.group_id = source.group_id;
            group.item_num = std::clamp(source.item_num, 0, static_cast<int>(std::size(group.item)));
            for (std::size_t i = 0; i < source.items.size() && i < std::size(group.item); ++i) {
                group.item[i].item_no = source.items[i].item_no;
                group.item[i].rank = source.items[i].rank;
                group.item[i].num = source.items[i].num;
            }
        }
        table->floor_start = loaded->floor_start;
        for (const auto &source : loaded->floors) {
            if (!Inside(table->floor, source.floor)) {
                continue;
            }
            auto     &floor = table->floor[source.floor];
            const int count = std::min(static_cast<int>(source.group_id.size()), static_cast<int>(std::size(floor.group_id)));
            floor.group_num = count;
            std::copy_n(source.group_id.begin(), count, floor.group_id);
        }
    }

    table->group_num += 1;
}
