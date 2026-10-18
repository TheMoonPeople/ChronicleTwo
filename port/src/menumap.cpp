// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <array>
#include <optional>
#include <string>
#include <vector>

#include "mapselect.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menumap.hpp"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "stubs/menumap.hpp"

namespace {

/**
 * One travel place of a world_map document.
 */
struct PositionEntry {
    int index;   /**< Slot in the place table. */
    int map;     /**< Map the place leads to. */
    int loop;    /**< Game loop the place leads to. */
    int area;    /**< World-map area the place belongs to. */
    int dungeon; /**< Dungeon the place leads to. */
    int floor;   /**< Dungeon floor to start on. */
    int flag;    /**< Event flag that opens the place. */
    int type;    /**< Kind of place. */
};

/**
 * One area of a world_map document.
 */
struct AreaEntry {
    int                        area;      /**< Area number and slot in the area table. */
    int                        map;       /**< Map the area represents. */
    int                        x;         /**< Screen x of the mark. */
    int                        y;         /**< Screen y of the mark, before the PAL stretch. */
    int                        name_x;    /**< Screen x of the name window. */
    int                        name_y;    /**< Screen y of the name window, before the PAL stretch. */
    int                        name_side; /**< Side the name window is placed on. */
    std::optional<std::string> title;     /**< Area name, CP932. */
};

/**
 * Typed contents of a world_map document.
 */
struct WorldMap {
    int                        positions_capacity; /**< Entries of the place table. */
    std::vector<PositionEntry> positions;          /**< Places in script order. */
    int                        areas_capacity;     /**< Entries of the area table. */
    std::vector<AreaEntry>     areas;              /**< Areas in script order. */
};

/**
 * Parses a world_map document.
 */
WorldMap ParseWorldMap(const native_config::Json &document) {
    using namespace native_config;
    WorldMap map{.positions_capacity = Int(document, "positions_capacity"), .positions = {}, .areas_capacity = Int(document, "areas_capacity"), .areas = {}};
    if (map.positions_capacity < 0 || map.areas_capacity < 0 || map.positions_capacity > 0x7FFF || map.areas_capacity > 0x7FFF) {
        throw std::runtime_error("world-map table size out of range");
    }
    for (const auto &pos : Array(document, "positions")) {
        map.positions.push_back({.index = Int(pos, "index"), .map = Int(pos, "map"), .loop = Int(pos, "loop"), .area = Int(pos, "area"), .dungeon = Int(pos, "dungeon"), .floor = Int(pos, "floor"), .flag = Int(pos, "flag"), .type = Int(pos, "type")});
    }
    for (const auto &area : Array(document, "areas")) {
        auto title = OptionalText(area, "title");
        // ConvertFontCode writes into a 0x100-byte buffer and can double a byte.
        if (title && title->size() >= 0x80) {
            throw std::runtime_error("world-map area title is too long");
        }
        map.areas.push_back({.area = Int(area, "area"), .map = Int(area, "map"), .x = Int(area, "x"), .y = Int(area, "y"), .name_x = Int(area, "name_x"), .name_y = Int(area, "name_y"), .name_side = Int(area, "name_side"), .title = std::move(title)});
    }
    return map;
}

/**
 * Gives the number of quadwords that hold a byte count.
 */
u32 Quadwords(u32 bytes) {
    return (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
}

/**
 * Fills one travel place as the POS tag does.
 */
void ApplyPosition(const PositionEntry &entry) {
    if (entry.index < 0 || entry.index >= spi_wmappos_tblnum) {
        return;
    }
    std::array<char, 0x100> converted{};
    WMAP_POS_DATA          *pos = &spi_wmappos_tbl[entry.index];
    pos->map_no = entry.map;
    pos->loop_no = static_cast<s16>(entry.loop);
    pos->area_no = static_cast<s16>(entry.area);
    pos->dng_no = static_cast<s16>(entry.dungeon);
    pos->floor = static_cast<s8>(entry.floor);
    ConvertFontCode(GetMapTitle(pos->map_no), converted.data());
    pos->name = mgCopyString(converted.data(), spi_wmapstack);
    pos->flag_no = static_cast<s16>(entry.flag);
    pos->enable = CheckBitFlagMenu(pos->flag_no) != 0 ? 1 : 0;
    pos->type = static_cast<s8>(entry.type);
    if (pos->type == WMAP_POS_TYPE_GEORAMA && CheckBitFlagMenu(SAVE_FLAG_CHAPTER_8) != 0) {
        pos->enable = 0;
    }
}

/**
 * Fills one area and gathers its places as the AREA tag does.
 */
void ApplyArea(const AreaEntry &entry) {
    if (entry.area < 0 || entry.area >= spi_wmaparea_tblnum) {
        return;
    }
    std::array<char, 0x100> converted{};
    WMAP_AREA_DATA         *area = &spi_wmaparea_tbl[entry.area];
    area->area_no = entry.area;
    area->map_no = static_cast<s16>(entry.map);
    area->x = entry.x;
    area->name_x = entry.name_x;
    area->name_side = entry.name_side;
    // The PAL screen is taller than the coordinates the script gives.
    area->y = static_cast<int>(1.15f * static_cast<float>(entry.y));
    area->name_y = static_cast<int>(1.15f * static_cast<float>(entry.name_y));
    std::string title = entry.title.value_or(std::string{});
    // A missing title converts as empty text rather than through a null pointer.
    ConvertFontCode(title.data(), converted.data());
    area->name = mgCopyString(converted.data(), spi_wmapstack);
    area->enable = 0;
    int position_count = 0;
    for (int index = 0; index < spi_wmappos_tblnum && position_count < WMAP_AREA_POS_MAX; ++index) {
        WMAP_POS_DATA *pos = &spi_wmappos_tbl[index];
        if (pos->area_no == entry.area) {
            area->pos[position_count++] = pos;
            if (pos->enable != 0) {
                area->enable = 1;
            }
        }
    }
    if (area->area_no == 8 && CheckBitFlagMenu(SAVE_FLAG_WORLD_MAP_4) != 0) {
        area->enable = 0;
    }
    if (CheckBitFlagMenu(SAVE_FLAG_CHAPTER_8_STARTED) != 0 && (area->area_no == 6 || area->area_no == 7)) {
        area->enable = 0;
    }
    if (area->enable != 0) {
        ++MapEnableNum;
    }
    for (int slot = position_count; slot < WMAP_AREA_POS_MAX; ++slot) {
        area->pos[slot] = nullptr;
    }
}

} // namespace

PORT_OVERRIDE void worldmap_analyze(mgCMemory *stack, char *script, int /*size*/) {
    spi_wmapstack = stack;
    spi_wmappos_tbl = nullptr;
    MapEnableNum = 0;
    const auto map = native_config::ReadBuffer<WorldMap>(script, "world_map", ParseWorldMap);
    if (!map) {
        return;
    }
    spi_wmappos_tblnum = static_cast<short>(map->positions_capacity);
    spi_wmappos_tbl = reinterpret_cast<WMAP_POS_DATA *>(stack->Alloc(static_cast<int>(Quadwords(spi_wmappos_tblnum * sizeof(WMAP_POS_DATA)))));
    if (spi_wmappos_tbl == nullptr) {
        spi_wmappos_tblnum = 0;
    }
    for (const auto &pos : map->positions) {
        ApplyPosition(pos);
    }
    spi_wmaparea_tblnum = static_cast<short>(map->areas_capacity);
    spi_wmaparea_tbl = reinterpret_cast<WMAP_AREA_DATA *>(stack->Alloc(static_cast<int>(Quadwords(spi_wmaparea_tblnum * sizeof(WMAP_AREA_DATA)))));
    if (spi_wmaparea_tbl == nullptr) {
        spi_wmaparea_tblnum = 0;
    }
    for (const auto &area : map->areas) {
        ApplyArea(area);
    }
}
