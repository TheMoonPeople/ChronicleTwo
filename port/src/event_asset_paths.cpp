#include "common.h"

#include <cstdio>
#include <cstring>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "event.hpp"
#include "event_background.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "platform/texture_catalog.hpp"

namespace {
/**
 * Classifies the direct resource selected by the event loader's current context.
 */
bool IsEventTexture(char *name) {
    const auto path = dc2::event::ResolveFileSource(name);
    return path && texture_catalog::Find(*path) != nullptr;
}

/**
 * Replaces the English language marker while retaining the retail filename convention.
 */
void SelectLanguage(char *name, const char *extension) {
    char marker[16];
    std::snprintf(marker, sizeof(marker), "_1.%s", extension);
    if (auto *found = std::strstr(name, marker)) {
        // Localized language codes are one digit, so only the existing marker byte changes.
        found[1] = static_cast<char>('0' + LanguageCode);
    }
}
} // namespace

void FileNameConvLanguage(char *name) {
    if (!name || LanguageCode < LANG_FRENCH || LanguageCode > LANG_SPANISH) {
        return;
    }
    SelectLanguage(name, "txt");
    SelectLanguage(name, "stb");
    if (std::strstr(name, "_1.json") && IsEventTexture(name)) {
        SelectLanguage(name, "json");
    }
}
