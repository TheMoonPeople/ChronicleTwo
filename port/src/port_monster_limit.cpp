#include "port_monster_limit.hpp"

#include <algorithm>

#include "monster.hpp"
#include "platform/config.hpp"

int PortMonsterActiveLimit() {
    const int cap = ConfigGet().expanded_dungeon_monsters ? static_cast<int>(MONSTER_ACTIVE_MAX) : 24;
    return std::min(cap, static_cast<int>(MONSTER_ACTIVE_MAX));
}

int PortMonsterVisiblePriorityLimit() {
    if (ConfigGet().expanded_dungeon_monsters) {
        return PortMonsterActiveLimit();
    }
    return 5;
}

bool PortDungeonMonsterExpandedView() {
    return ConfigGet().expanded_dungeon_monsters;
}
