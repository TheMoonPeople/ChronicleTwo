#include <format>

#include "config_bridges.hpp"
#include "native_config.hpp"

void PortLoadNPCConfiguration() {
    npc_spi_count_num = 0;
    RunNativeConfig(std::format("npc{}.cfg.json", LanguageCode), npc_spitag);
    NpcBaseDataTotalNum = npc_spi_count_num;
}
