// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <cstddef>
#include <cstring>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

#include "mapselect.hpp"
#include "stubs/mapselect.hpp"

namespace {

/**
 * Names, type and identifiers one MAP_NAME row gives a map.
 */
struct MapNameEntry {
    std::optional<std::string> name;        /**< CP932 file name of the map; empty or none stores null. */
    std::optional<std::string> title;       /**< CP932 name shown to the player; empty or none stores null. */
    std::optional<std::string> add_path;    /**< CP932 additional path; empty or none stores null. */
    int                        type;        /**< Kind of map. */
    int                        sel_type;    /**< Map selection category. */
    std::optional<int>         snd_data_id; /**< Sound data of the map, or none for -1. */
    std::optional<int>         area_no;     /**< Area of the map, or none to leave it 0. */
};

/**
 * Typed contents of a map_names document.
 */
struct MapNames {
    int                       count; /**< MAP_NAME_NUM count, which sizes the table. */
    std::vector<MapNameEntry> maps;  /**< Maps in table order. */
};

/**
 * Bytes a string of the table takes in the string storage: none for a missing or empty one.
 */
std::size_t StoredBytes(const std::optional<std::string> &text) {
    return text && !text->empty() ? text->size() + 1 : 0;
}

/**
 * Quadwords of MapNameBuff the table of a count takes before its strings.
 */
std::size_t TableQuadwords(int count) {
    return ((static_cast<std::size_t>(count) + 1) * sizeof(MAP_NAME_INFO) >> 4) + 1;
}

/**
 * Parses a map_names document, refusing one whose table or strings would not fit MapNameBuff.
 */
MapNames ParseMapNames(const native_config::Json &document) {
    using namespace native_config;
    MapNames names{.count = Int(document, "count"), .maps = {}};
    if (names.count < 0) {
        throw std::runtime_error("negative map name count");
    }
    std::size_t string_bytes = 0;
    for (const auto &map : Array(document, "maps")) {
        MapNameEntry entry{.name = OptionalText(map, "name"), .title = OptionalText(map, "title"), .add_path = OptionalText(map, "add_path"), .type = Int(map, "type"), .sel_type = Int(map, "sel_type"), .snd_data_id = OptionalInt(map, "snd_data_id"), .area_no = OptionalInt(map, "area_no")};
        string_bytes += StoredBytes(entry.name) + StoredBytes(entry.title) + StoredBytes(entry.add_path);
        names.maps.push_back(std::move(entry));
    }
    // Retail clears count + 1 entries; later rows would overwrite the strings.
    if (names.maps.size() > static_cast<std::size_t>(names.count) + 1) {
        throw std::runtime_error("more map names than the table holds");
    }
    if (TableQuadwords(names.count) + (string_bytes / 16) + 1 > MAP_NAME_BUFF_SIZE) {
        throw std::runtime_error("map names exceed the map name buffer");
    }
    return names;
}

/**
 * Copies a string into the string storage, as mlMAP_NAME does, giving null for a missing or empty one.
 */
char *StoreString(std::optional<std::string> &text) {
    if (!text || text->empty()) {
        return nullptr;
    }
    char *copy = CharBuff + pCharBuff;
    std::memcpy(copy, text->c_str(), text->size() + 1);
    pCharBuff += static_cast<int>(text->size()) + 1;
    return copy;
}

} // namespace

PORT_OVERRIDE void LoadMapName(int language, u_long128 * /*buffer*/) {
    MapNameNum = 0;
    const auto path = "map/map" + std::to_string(language) + ".cfg.json";
    auto       names = native_config::ReadGame<MapNames>(path.c_str(), "map_names", ParseMapNames);
    if (!names) {
        return;
    }

    pMapNameBuff = 0;
    pCharBuff = 0;
    MapNameNum = names->count;
    map_name = reinterpret_cast<MAP_NAME_INFO *>(MapNameBuff + (pMapNameBuff * 16));
    pMapNameBuff += static_cast<int>(TableQuadwords(names->count));
    CharBuff = MapNameBuff + (pMapNameBuff * 16);
    std::memset(map_name, 0, (static_cast<std::size_t>(names->count) + 1) * sizeof(MAP_NAME_INFO));
    now_no = 0;

    for (auto &entry : names->maps) {
        MAP_NAME_INFO *info = &map_name[now_no++];
        info->name = StoreString(entry.name);
        info->title = StoreString(entry.title);
        info->add_path = StoreString(entry.add_path);
        info->type = entry.type;
        info->sel_type = entry.sel_type;
        info->snd_data_id = entry.snd_data_id.value_or(-1);
        if (entry.area_no) {
            info->area_no = *entry.area_no;
        }
    }
    pMapNameBuff += (pCharBuff / 16) + 1;
}
