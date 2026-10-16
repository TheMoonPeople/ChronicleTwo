#include "vlgr_info.hpp"

#include "config_bridges.hpp"

PORT_OVERRIDE void LoadGameInfo(mgCMemory *memory) {
    PortLoadVillagerConfiguration(memory);
}
