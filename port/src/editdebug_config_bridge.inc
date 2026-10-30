// Appended to the native copy of ps2/src/editdebug.cpp: loads the development gyorace fish, whose
// counter is local to that unit, from typed records.
#include <cstring>
#include <vector>

#include "config_bridges.hpp"
#include "record_bridges.hpp"

void PortLoadDebugGyoraceConfiguration() {
    std::vector<NativeDebugRaceFish> entries;
    if (!PortReadDebugRaceFish(entries)) {
        return;
    }
    fish_num = 0;
    for (const auto &entry : entries) {
        CGameDataUsed *racer = GetOmakeGyoracer2(fish_num);
        if (racer == nullptr) {
            continue;
        }
        BREEDFISH_USED *fish = &racer->data.fish;
        if (entry.has_name) {
            dc2::text::Copy(fish->name, entry.name);
        }
        racer->item_no = entry.item;
        fish->color = entry.color;
        fish->kind = entry.kind;
        fish->param[BREEDFISH_STAT_BATTLE] = entry.battle;
        fish->param[BREEDFISH_STAT_STAMINA] = entry.stamina;
        fish->param[BREEDFISH_STAT_BOOST] = entry.boost;
        fish->param[BREEDFISH_STAT_ENDURANCE] = entry.endurance;
        fish->param[BREEDFISH_STAT_TENACITY] = entry.tenacity;
        SetOmakeGyoracerTactics(fish_num, entry.tactics);
        ++fish_num;
    }
}
