// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <vector>

#include "config_bridges.hpp"
#include "gamedata.hpp"
#include "record_bridges.hpp"

PORT_OVERRIDE void LoadGyorace() { PortLoadDebugGyoraceConfiguration(); }

namespace {

/**
 * Parses a debug_race_fish document, refusing names the fish records cannot hold.
 */
std::vector<NativeDebugRaceFish> ParseDebugRaceFish(const native_config::Json &document) {
    using namespace native_config;
    std::vector<NativeDebugRaceFish> fish;
    for (const auto &entry : Array(document, "fish")) {
        auto name = OptionalText(entry, "name");
        if (name && name->size() >= sizeof(BREEDFISH_USED::name)) {
            throw std::runtime_error("gyorace fish name is too long");
        }
        fish.push_back({.name = name.value_or(std::string{}), .has_name = name.has_value(), .item = Int(entry, "item"), .color = Int(entry, "color"), .kind = Int(entry, "kind"), .tactics = Int(entry, "tactics"), .battle = Int(entry, "battle"), .stamina = Int(entry, "stamina"), .boost = Int(entry, "boost"), .endurance = Int(entry, "endurance"), .tenacity = Int(entry, "tenacity")});
    }
    return fish;
}

} // namespace

bool PortReadDebugRaceFish(std::vector<NativeDebugRaceFish> &fish) {
    auto parsed = native_config::ReadGame<std::vector<NativeDebugRaceFish> >("host:gyorace.cfg.json", "debug_race_fish", ParseDebugRaceFish);
    if (!parsed) {
        return false;
    }
    fish = std::move(*parsed);
    return true;
}
