#include <array>

#include "config_bridges.hpp"
#include "native_config.hpp"

void PortLoadVillagerConfiguration(mgCMemory *memory) {
    vpiStack = memory;
    vpiInfo = nullptr;
    if (!RunNativeConfig("place.cfg.json", tag)) {
        return;
    }

    for (auto &progress : ProgressInfo) {
        progress.section = 0;
        progress.chapter = 0;
        progress.name = nullptr;
        progress.order = 0;
    }

    giGamePI = ProgressInfo;
    giStack = memory;
    ProgressNum = GAME_PROGRESS_MAX;
    if (!RunNativeConfig("npc_place4.cfg.json", gi_tag)) {
        return;
    }

    std::array<CVillagerPlace::ProgressInfo, GAME_PROGRESS_MAX> progress_table{};
    niProgInfo = progress_table.data();
    niStack = memory;
    niVlgr = nullptr;
    niProgNum = 0;
    niNowProgInfo = nullptr;
    niPlaceInfo = PlaceInfo;
    niPlaceInfoNum = PlaceInfoNum;
    RunNativeConfig("npc_place4.cfg.json", ni_tag);
}
