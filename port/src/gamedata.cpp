#include "common.h"

#include <cstdio>
#include <cstring>
#include <string>

#include "arena_root.hpp"
#include "dataread.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mg_memory.hpp"
#include "native_config.hpp"
#include "platform/arena.hpp"
#include "scriptinterpreter.hpp"

extern SPI_TAG_PARAM PortGameDataTags[25] asm("GameData_Tags");
extern mgCMemory    *PortGameDataBuildStack asm("GameData_BuildStack");

namespace {
char message_root;
} // namespace

PORT_OVERRIDE int LoadGameDataAnalyze(char *name) {
    if (!name) {
        return 0;
    }
    SetCurrentDir(nullptr);
    return RunNativeConfig("menu/cfg7/" + std::string(name), PortGameDataTags) ? 1 : 0;
}

PORT_OVERRIDE int CGameData::LoadItemSystemMes(int language) {
    // This root is reinitialized on every language load. Cursor rebinding elsewhere
    // must preserve live sound records, so clearing belongs to this owner.
    auto *root = ArenaRoot(&message_root, 0x280, "ItemMessages");
    std::memset(root, 0, 0x2800 * kArenaHeadroom);
    mgCMemory memory;
    memory.stSetBuffer(root, 0x280 * kArenaHeadroom);
    auto *previous_stack = PortGameDataBuildStack;
    PortGameDataBuildStack = &memory;
    const auto path = "menu/cfg7/comdatmes" + std::to_string(language) + ".cfg.json";
    RunNativeConfig(path, PortGameDataTags);
    PortGameDataBuildStack = previous_stack;
    return 1;
}
