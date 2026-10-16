#include "common.h"

#include <cstdio>
#include <cstring>

#include "asset_directory.hpp"
#include "dataread_port.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "platform/texture_catalog.hpp"

namespace {
/**
 * Classifies the direct resource selected by the event loader's current context.
 */
bool IsEventTexture(char *name) {
    int size = 0;
    if (const auto *loaded = CheckLoadedBGFile(name, &size)) {
        if (const auto path = DataReadBufferPath(loaded)) {
            return texture_catalog::Find(*path) != nullptr;
        }
    }
    if (EdEventInfo.pack_loaded && read_buffer) {
        if (const auto *member = AssetDirectoryRead(read_buffer, name, nullptr)) {
            if (const auto path = DataReadBufferPath(member)) {
                return texture_catalog::Find(*path) != nullptr;
            }
        }
    }
    const auto path = DataReadAssetPath(name);
    return path && texture_catalog::Find(*path);
}

/**
 * Replaces the English language marker while retaining the retail filename convention.
 */
void SelectLanguage(char *name, const char *extension) {
    char marker[16];
    std::snprintf(marker, sizeof(marker), "_1.%s", extension);
    if (auto *found = std::strstr(name, marker)) {
        std::sprintf(found, "_%d.%s", LanguageCode, extension);
    }
}
} // namespace

PORT_OVERRIDE void FileNameConvLanguage(char *name) {
    if (!name || LanguageCode < LANG_FRENCH || LanguageCode > LANG_SPANISH) {
        return;
    }
    SelectLanguage(name, "txt");
    SelectLanguage(name, "stb");
    if (std::strstr(name, "_1.json") && IsEventTexture(name)) {
        SelectLanguage(name, "json");
    }
}
