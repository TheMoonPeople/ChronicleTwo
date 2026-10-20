#include "common.h"

#include <algorithm>
#include <limits>

#include "dataread_port.hpp"
#include "platform/model_assets.hpp"
#include "scenevillager.hpp"

PORT_OVERRIDE int GetChrFileSize(u32 *model, int /*unused*/) {
    const auto path = DataReadBufferPath(model);
    if (!path) {
        return std::numeric_limits<int>::max();
    }
    std::string error;
    const auto  estimate = model_assets::EstimateCharacterMemory(*path, {}, error);
    if (!estimate) {
        return std::numeric_limits<int>::max();
    }
    const auto bytes = (*estimate + 1023) / 1024 * 1024;
    return static_cast<int>(std::min<std::size_t>(bytes, std::numeric_limits<int>::max()));
}
