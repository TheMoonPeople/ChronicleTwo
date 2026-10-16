#include "config_bridges.hpp"
#include "native_config.hpp"

void PortLoadDebugGyoraceConfiguration() {
    fish_num = 0;
    SPI_TAG_PARAM tags[2] = {
        {"GYOFISH", tagGyoFish},
        {nullptr,   nullptr   }
    };
    RunNativeConfig("host:gyorace.cfg.json", tags);
}
