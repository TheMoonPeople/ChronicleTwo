#include "common.h"

#include <cstdio>
#include <cstring>

#include "arena_root.hpp"
#include "dataread.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "scriptinterpreter.hpp"

extern SPI_TAG_PARAM PortGameDataTags[25] asm("GameData_Tags");
extern mgCMemory    *PortGameDataBuildStack asm("GameData_BuildStack");

namespace {
char message_root;
} // namespace

PORT_OVERRIDE int CGameData::LoadItemSystemMes(int language) {
    // This root is reinitialized on every language load. Cursor rebinding elsewhere
    // must preserve live sound records, so clearing belongs to this owner.
    auto *root = ArenaRoot(&message_root, 0x280, "ItemMessages");
    std::memset(root, 0, 0x2800 * kArenaHeadroom);
    mgCMemory memory;
    memory.stSetBuffer(root, 0x280 * kArenaHeadroom);
    auto *previous_stack = PortGameDataBuildStack;
    PortGameDataBuildStack = &memory;
    alignas(64) u_long128 script_buffer[0x780];
    char                  path[0x40];
    std::snprintf(path, sizeof(path), "menu/cfg7/comdatmes%d.cfg", language);
    int size = 0;
    if (LoadFile2(path, script_buffer, &size, 0)) {
        CScriptInterpreter interpreter;
        interpreter.SetTag(PortGameDataTags);
        interpreter.SetScript(reinterpret_cast<char *>(script_buffer), size);
        interpreter.Run();
    }
    PortGameDataBuildStack = previous_stack;
    return 1;
}
