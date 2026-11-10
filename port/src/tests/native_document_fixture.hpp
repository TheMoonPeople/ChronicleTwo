#pragma once

#include <nlohmann/json.hpp>

#include <filesystem>
#include <fstream>

namespace dc::test {

/**
 * Writes native fixture assets with character settings in their loose gameplay sidecar.
 */
inline void WriteNativeDocument(const std::filesystem::path &path, nlohmann::json document) {
    std::filesystem::create_directories(path.parent_path());
    if (document.value("kind", "") == "character") {
        nlohmann::json gameplay{
            {"schema_version", 1},
            {"kind", "character_gameplay"},
            {"profiles", document.value("profiles", nlohmann::json::object())}
        };
        for (const auto *field : {"game_names", "default_profile"}) {
            if (document.contains(field)) {
                gameplay[field] = document.at(field);
                document.erase(field);
            }
        }
        document.erase("profiles");
        auto gameplay_path = path;
        gameplay_path.replace_extension();
        gameplay_path.replace_extension(".character.json");
        std::ofstream(gameplay_path, std::ios::binary) << gameplay.dump(2);
    }
    std::ofstream(path, std::ios::binary) << document.dump(2);
}

} // namespace dc::test
