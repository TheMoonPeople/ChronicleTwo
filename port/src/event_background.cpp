#include "common.h"

#include <algorithm>
#include <cstdio>
#include <string>
#include <vector>

#include "asset_directory.hpp"
#include "dataread.hpp"
#include "event.hpp"
#include "event_background.hpp"
#include "event_func.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "runscript.hpp"

namespace {
/**
 * Owns complete event file bytes until the next event background batch replaces them.
 */
std::vector<std::vector<u_long128> > &EventFiles() {
    static std::vector<std::vector<u_long128> > files;
    return files;
}

/**
 * Reads a complete native file into its own aligned storage instead of the scene scratch arena.
 */
u32 *ReadEventFile(std::string &path, int &size, bool background) {
    size = 0;
    int expected = 0;
    if (!LoadFile2(path.data(), nullptr, &expected, LOAD_FILE_SIZE) || expected < 0) {
        return nullptr;
    }
    constexpr std::size_t sector_bytes = 2048;
    const auto            sectors = std::max<std::size_t>(1, (static_cast<std::size_t>(expected) + sector_bytes - 1) / sector_bytes);
    auto                 &storage = EventFiles().emplace_back(sectors * (sector_bytes / sizeof(u_long128)));
    const int             loaded = background ? LoadFileBG(path.data(), storage.data(), &size) : LoadFile2(path.data(), storage.data(), &size, LOAD_FILE_READ);
    if (!loaded) {
        EventFiles().pop_back();
        return nullptr;
    }
    return reinterpret_cast<u32 *>(storage.data());
}

/**
 * Reports event file access that conflicts with a streaming operation.
 */
bool CanReadEventFiles() {
    if (EdEventInfo.stream_reading != 1) {
        return true;
    }
    std::fprintf(stderr, "event: file access requested while a stream is open\n");
    return false;
}
} // namespace

PORT_OVERRIDE u32 *GetLoadBGBuff(char *name, int *size) {
    if (size) {
        *size = 0;
    }
    if (!name) {
        return nullptr;
    }
    std::string path(name);
    FileNameConvLanguage(path.data());
    int loaded_size = 0;
    if (auto *buffer = CheckLoadedBGFile(path.data(), &loaded_size)) {
        if (size) {
            *size = loaded_size;
        }
        return buffer;
    }
    if (EdEventInfo.pack_loaded == 1) {
        if (auto *buffer = AssetDirectoryRead(read_buffer, path.c_str(), &loaded_size)) {
            if (size) {
                *size = loaded_size;
            }
            return buffer;
        }
        EdEventInfo.pack_loaded = false;
    }
    if (!CanReadEventFiles()) {
        return nullptr;
    }
    auto *buffer = ReadEventFile(path, loaded_size, false);
    if (buffer && size) {
        *size = loaded_size;
    }
    return buffer;
}

PORT_OVERRIDE int _SET_LOADBG_FILE(RS_STACKDATA *stack, int argc) {
    if (argc < 0 || (argc && !stack) || !CanReadEventFiles()) {
        return false;
    }
    std::vector<std::string> paths;
    for (int index = 0; index < argc; ++index, ++stack) {
        const char *name = nullptr;
        if (stack->type == RS_INT) {
            if (index + 1 >= argc) {
                return false;
            }
            const int item = stack->val.i;
            ++index;
            ++stack;
            name = GetItemFilePath(item, rsGetStackInt(stack));
        } else if (stack->type == RS_STR) {
            name = stack->val.s;
        } else {
            continue;
        }
        if (!name) {
            return false;
        }
        paths.emplace_back(name);
        FileNameConvLanguage(paths.back().data());
    }
    StartReadBG();
    EventFiles().clear();
    for (auto &path : paths) {
        int size = 0;
        if (!ReadEventFile(path, size, true)) {
            return false;
        }
    }
    EdEventInfo.pack_loaded = false;
    return true;
}
