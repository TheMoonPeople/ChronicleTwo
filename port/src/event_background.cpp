#include "common.h"

#include <algorithm>
#include <cstdio>
#include <optional>
#include <span>
#include <string>
#include <vector>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "event.hpp"
#include "event_background.hpp"
#include "event_func.hpp"
#include "gamedata.hpp"
#include "log/log.hpp"
#include "mainloop.hpp"
#include "runscript.hpp"

namespace {
dc2::io::FileRead event_pack;

/**
 * Reports event file access that conflicts with a streaming operation.
 */
bool CanReadEventFiles() {
    if (EdEventInfo.stream_reading != 1) {
        return true;
    }
    CT_LOG_WARN(Event, "event: file access requested while a stream is open");
    return false;
}
} // namespace

dc2::io::FileRead dc2::event::ReadFile(std::string_view name) {
    if (name.empty() || name.contains(char{})) {
        return {};
    }
    std::string path(name);
    FileNameConvLanguage(path.data());
    if (auto queued = dc2::io::FindBackgroundReadInCurrentDir(path)) {
        return queued;
    }
    if (EdEventInfo.pack_loaded == 1 && event_pack) {
        if (const auto member = dc2::assets::ResolveDirectoryMember(event_pack, path)) {
            if (auto read = dc2::io::ReadFile("/" + *member)) {
                return read;
            }
        }
        ResetReadFiles();
    }
    return CanReadEventFiles() ? dc2::io::ReadFile(path) : dc2::io::FileRead{};
}

std::optional<std::string> dc2::event::ResolveFileSource(std::string_view name) {
    if (name.empty() || name.contains(char{})) {
        return std::nullopt;
    }
    if (const auto queued = dc2::io::FindBackgroundReadInCurrentDir(name); queued && !queued.Source().empty()) {
        return std::string(queued.Source());
    }
    if (EdEventInfo.pack_loaded && event_pack) {
        if (const auto member = dc2::assets::ResolveDirectoryMember(event_pack, name)) {
            if (const auto source = DataReadAssetPath(("/" + *member).c_str())) {
                return source;
            }
        }
    }
    const std::string terminated(name);
    return DataReadAssetPath(terminated.c_str());
}

bool dc2::event::LoadPack(std::string_view name) {
    auto read = ReadFile(name);
    if (!read) {
        return false;
    }
    event_pack = std::move(read);
    EdEventInfo.pack_loaded = true;
    return true;
}

void dc2::event::ResetReadFiles() {
    event_pack = {};
    EdEventInfo.pack_loaded = false;
}

int _SET_LOADBG_FILE(dc2::script::RunArguments stack, int argc) {
    if (argc < 0 || !CanReadEventFiles()) {
        return false;
    }
    std::vector<std::string> paths;
    for (int index = 0; index < argc; ++index, ++stack) {
        const char                *name = nullptr;
        std::optional<std::string> item_path;
        if (stack.At().type == RS_INT) {
            if (index + 1 >= argc) {
                return false;
            }
            const int item = dc2::script::RunInteger(stack);
            ++index;
            ++stack;
            item_path = ItemFilePath(item, dc2::script::RunInteger(stack));
            if (!item_path) {
                return false;
            }
            name = item_path->c_str();
        } else if (stack.At().type == RS_STR) {
            name = dc2::script::RunCString(stack);
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
    dc2::event::ResetReadFiles();
    for (auto &path : paths) {
        if (!dc2::io::QueueBackgroundRead(path)) {
            return false;
        }
    }
    EdEventInfo.pack_loaded = false;
    return true;
}
