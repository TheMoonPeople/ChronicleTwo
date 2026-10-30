#include "common.h"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

ClsMes *GetSystemMessage() {
    return GetSystemMessage(0);
}

ClsMes *GetSystemMessage(int index) {
    if (index == 2) {
        return &SystemMessage3;
    }

    if (index == 1) {
        return &SystemMessage2;
    }

    return &SystemMessage;
}

namespace dc2::text {
namespace {
MessageTable system_messages;   /**< Owned immutable system message document. */
MessageTable ordinary_messages; /**< Owned immutable scene message document. */

/**
 * Parses only the initialized bytes returned by a bounded message-file read.
 */
MessageTable LoadMessageTable(std::string path, std::span<u8> destination) {
    int size = 0;
    if (!LoadFile(path.data(), destination, &size) || size <= 0 || static_cast<std::size_t>(size) > destination.size()) {
        return {};
    }
    return MessageTable::Parse(std::as_bytes(destination.first(static_cast<std::size_t>(size))));
}
} // namespace
} // namespace dc2::text

void LoadSystemMes() {
    const auto suffix = LanguageCode == LANG_JAPANESE ? std::string{} : "_" + std::to_string(LanguageCode >= LANG_ENGLISH && LanguageCode <= LANG_SPANISH ? LanguageCode : LANG_ENGLISH);
    dc2::text::system_messages = dc2::text::LoadMessageTable("meswin/system" + suffix + ".mes",
                                                             {reinterpret_cast<u8 *>(SystemMesBuffer), sizeof SystemMesBuffer});
    dc2::text::ordinary_messages = dc2::text::LoadMessageTable("meswin/sysmes" + suffix + ".mes",
                                                               {reinterpret_cast<u8 *>(SysMesBuffer), sizeof SysMesBuffer});
}

dc2::text::MessageTable GetSystemMesBuffer() {
    return dc2::text::system_messages;
}

dc2::text::MessageTable GetSysMesBuffer() {
    return dc2::text::ordinary_messages;
}

void CreateSystemMes() {
    CreateSystemMes(0, 0);
    CreateSystemMes(1, 0);
    CreateSystemMes(2, 0);
}

void CreateSystemMes(int index, int unused) {
    GetSystemMessage(index)->Init();
    GetSystemMessage(index)->Preset(5);
    GetSystemMessage(index)->SetBuff(GetSysMesBuffer());
    GetSystemMessage(index)->SetBuff_system(GetSystemMesBuffer());
}

/**
 *
 * Memory the system message windows allocate from.
 *
 */
mgCMemory SystemMesStack;

/**
 *
 * System-text buffer shared by the system message windows.
 *
 */
short SystemMesBuffer[0x6800];

/**
 *
 * Message buffer shared by the system message windows.
 *
 */
short SysMesBuffer[0x9C40];

/**
 *
 * First system message window.
 *
 */
ClsMes SystemMessage;

/**
 *
 * Second system message window.
 *
 */
ClsMes SystemMessage2;

/**
 *
 * Third system message window.
 *
 */
ClsMes SystemMessage3;
