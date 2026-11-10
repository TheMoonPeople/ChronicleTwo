#include "script_text.hpp"

#include <array>
#include <cstring>
#include <mutex>
#include <optional>
#include <set>
#include <string>

#include "log/log.hpp"

namespace script_text {
namespace {

/** Latin-1 Spanish lesson corrections describing the sphere's red and blue colour rules. */
constexpr std::array<Edit, 3> kE314Spanish{
    {
     {.retail = "No tienes que acordarte de nada m\xe1s.", .text = "Tienes que acordarte de otra cosa m\xe1s."},
     {.retail = "De azul a rojo, de negro a azul.", .text = "De azul a rojo, de rojo a azul."},
     {.retail = "cambiar\xe1 el color a negro.", .text = "cambiar\xe1 el color."},
     }
};

/**
 * Associates an event message file with its exact text corrections.
 */
struct Messages {
    const char           *path;  /**< Root-relative message filename. */
    std::span<const Edit> edits; /**< Corrections required for this file. */
};

/** Event files with exact passage corrections. */
constexpr std::array<Messages, 1> kMessages{
    {
     {.path = "event/e300/e314/e314_5.txt", .edits = kE314Spanish},
     }
};

/**
 * Folds an asset path to its lower-case, forward-slash key without a leading slash.
 */
std::string Key(std::string_view asset_path) {
    std::string key;
    key.reserve(asset_path.size());
    for (char c : asset_path) {
        const char folded = c == '\\' ? '/' : (c >= 'A' && c <= 'Z' ? static_cast<char>(c - 'A' + 'a') : c);
        if (folded == '/' && key.empty()) {
            continue;
        }
        key.push_back(folded);
    }
    return key;
}

/**
 * Finds event message corrections by normalized asset path.
 */
std::span<const Edit> FindEdits(std::string_view key) {
    const std::string normalised = Key(key);
    for (const Messages &messages : kMessages) {
        if (normalised == messages.path) {
            return messages.edits;
        }
    }
    return {};
}

/**
 * Returns corrected event text only when every expected passage occurs exactly once.
 */
std::optional<std::string> Edited(std::string text, std::span<const Edit> edits) {
    for (const Edit &edit : edits) {
        const std::size_t at = text.find(edit.retail);
        if (at == std::string::npos || text.find(edit.retail, at + 1) != std::string::npos) {
            return std::nullopt;
        }
        text.replace(at, std::strlen(edit.retail), edit.text);
    }
    return text;
}

/**
 * Reports the first correction result for each asset.
 */
void LogOnce(std::string_view key, bool matched) {
    static std::mutex            mutex;
    static std::set<std::string> logged;
    std::scoped_lock             lock(mutex);
    if (!logged.emplace(key).second) {
        return;
    }
    if (matched) {
        CT_LOG_INFO(Script, "script text: {}: Spanish text", key);
    } else {
        CT_LOG_WARN(Script, "script text: {} does not match the PAL file; its text is left unchanged", key);
    }
}

} // namespace

std::span<const Edit> Edits(std::string_view key) {
    return FindEdits(key);
}

std::size_t Extra(std::string_view key) {
    std::ptrdiff_t growth = 0;
    for (const Edit &edit : FindEdits(key)) {
        growth += static_cast<std::ptrdiff_t>(std::strlen(edit.text)) - static_cast<std::ptrdiff_t>(std::strlen(edit.retail));
    }
    return growth > 0 ? static_cast<std::size_t>(growth) : 0;
}

std::size_t Patch(std::string_view key, unsigned char *bytes, std::size_t size) {
    const auto edits = FindEdits(key);
    if (edits.empty()) {
        return size;
    }
    const auto text = Edited(std::string(reinterpret_cast<const char *>(bytes), size), edits);
    if (!text) {
        LogOnce(key, false);
        return size;
    }
    std::memcpy(bytes, text->data(), text->size());
    if (text->size() < size) {
        std::memset(bytes + text->size(), 0, size - text->size());
    }
    LogOnce(key, true);
    return text->size();
}

} // namespace script_text
