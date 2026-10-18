// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <array>
#include <cstring>
#include <optional>
#include <string>
#include <type_traits>
#include <vector>

#include "fishing.hpp"
#include "mg_memory.hpp"
#include "stubs/fishing.hpp"

namespace {

/**
 * Number of shape parameters of a fishing place.
 */
constexpr std::size_t kAreaParams = std::extent_v<decltype(FISH_PLACE_MAP::area_param)>;

/**
 * Number of fish entries of a fishing place.
 */
constexpr int kPlaceFish = std::extent_v<decltype(FISH_PLACE_MAP::fish)>;

/**
 * Area of a fishing place.
 */
struct PlaceArea {
    int                            area_type; /**< Shape of the area. */
    std::optional<std::string>     name;      /**< Name of the place, CP932. */
    std::array<float, kAreaParams> params;    /**< Shape parameters. */
};

/**
 * One fish that can bite at a place.
 */
struct PlaceFish {
    int   fish;      /**< Index of the fish. */
    float rate;      /**< Weight of the fish. */
    float wait_bias; /**< Bite-wait bias. */
};

/**
 * One fishing place of a fishing_places document.
 */
struct PlaceMap {
    int                      map;       /**< Map holding the place. */
    std::optional<int>       exclusive; /**< Whether its fish replace the others, when given. */
    std::optional<PlaceArea> place;     /**< Area, when given. */
    std::vector<PlaceFish>   fish;      /**< Fish in script order. */
};

/**
 * Typed contents of a fishing_places document.
 */
struct FishingPlaces {
    int                   count; /**< Entries of the place table. */
    std::vector<PlaceMap> maps;  /**< Places in script order. */
};

/**
 * Parses a fishing_places document.
 */
FishingPlaces ParseFishingPlaces(const native_config::Json &document) {
    using namespace native_config;
    FishingPlaces places{.count = Int(document, "count"), .maps = {}};
    if (places.count < 0) {
        throw std::runtime_error("negative fishing place count");
    }
    for (const auto &map : Array(document, "maps")) {
        PlaceMap entry{.map = Int(map, "map"), .exclusive = OptionalInt(map, "exclusive"), .place = std::nullopt, .fish = {}};
        if (map.contains("place")) {
            const auto &place = At(map, "place");
            entry.place = PlaceArea{.area_type = Int(place, "area_type"), .name = OptionalText(place, "name"), .params = Floats<kAreaParams>(place, "params")};
        }
        for (const auto &fish : Array(map, "fish")) {
            entry.fish.push_back({.fish = Int(fish, "fish"), .rate = Float(fish, "rate"), .wait_bias = Float(fish, "wait_bias")});
        }
        places.maps.push_back(std::move(entry));
    }
    return places;
}

} // namespace

PORT_OVERRIDE void LoadFishPlaceData(char *script, int /*size*/, mgCMemory *stack) {
    FishPlaceMapNum = 0;
    FishPlaceMap = nullptr;
    const auto places = native_config::ReadBuffer<FishingPlaces>(script, "fishing_places", ParseFishingPlaces);
    if (!places) {
        return;
    }
    FishPlaceMapNum = places->count;
    const u_int bytes = static_cast<u_int>(FishPlaceMapNum) * sizeof(FISH_PLACE_MAP);
    const u_int blocks = (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
    FishPlaceMap = new (stack->Alloc(static_cast<int>(blocks + 2))) FISH_PLACE_MAP[FishPlaceMapNum];
    int filled = 0;
    for (const auto &entry : places->maps) {
        // FISH_MAP past the table leaves no current place, so the rest of the entry does nothing.
        if (filled >= FishPlaceMapNum || FishPlaceMap == nullptr) {
            continue;
        }
        FISH_PLACE_MAP *map = &FishPlaceMap[filled];
        std::memset(static_cast<void *>(map), 0, sizeof(FISH_PLACE_MAP));
        map->map_no = entry.map;
        if (entry.exclusive) {
            map->exclusive = *entry.exclusive;
        }
        if (entry.place) {
            map->area_type = entry.place->area_type >= 0 && entry.place->area_type < FISH_PLACE_AREA_COUNT ? entry.place->area_type : 0;
            if (entry.place->name && !entry.place->name->empty()) {
                std::string name = *entry.place->name;
                map->name = mgCopyString(name.data(), stack);
            }
            for (std::size_t index = 0; index < kAreaParams; ++index) {
                map->area_param[index] = entry.place->params[index];
            }
        }
        for (const auto &fish : entry.fish) {
            if (map->fish_num >= kPlaceFish) {
                continue;
            }
            FISH_PLACE *place = &map->fish[map->fish_num++];
            place->fish_no = fish.fish;
            place->rate = fish.rate;
            place->wait_bias = fish.wait_bias;
        }
        ++filled;
    }
}
