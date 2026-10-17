#include "common.h"

#include <cstring>

#include "map.hpp"
#include "map_port.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mg_memory.hpp"

PORT_OVERRIDE void CMap::SetPlacePartsBuff(mgCMemory *memory, int capacity) {
    const std::size_t parts_bytes = sizeof(CMapParts) * capacity;
    place_parts = new (memory->Alloc((parts_bytes + 15) / 16 + 2)) CMapParts[capacity];
    const std::size_t pointers_bytes = sizeof(CMapParts *) * capacity;
    draw_parts = new (memory->Alloc((pointers_bytes + 15) / 16 + 2)) CMapParts *[capacity];
    place_parts_max = capacity;
    ClearPlaceParts();
}

namespace {
struct TreasureFlagFix {
    const char *map_name;
    const char *point_name;
    int         retail_flag;
    int         fixed_flag;
};

// Retail gives Starlight Temple's item19 and item11 the same opened flag, so opening one hides the other (issue #25).
// No other chest of f02 uses flag 9.
constexpr TreasureFlagFix kTreasureFlagFixes[] = {
    {"f02", "item11", 7, 9},
};
} // namespace

void PortSplitTreasureBoxFlags(CMap *map, const char *map_name) {
    if (map == nullptr || map_name == nullptr) {
        return;
    }
    for (const auto &fix : kTreasureFlagFixes) {
        if (std::strcmp(fix.map_name, map_name) != 0) {
            continue;
        }
        CMapTreasureBox *box = map->tr_box;
        for (int i = 0; box != nullptr && i < map->tr_box_num; i++, box++) {
            const char *point = box->func_point != nullptr ? box->func_point->name : nullptr;
            if (box->flag_no == fix.retail_flag && point != nullptr && std::strcmp(point, fix.point_name) == 0) {
                box->flag_no = fix.fixed_flag;
            }
        }
    }
}
