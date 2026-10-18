#include "kazarov_bridge/rust/lib.h"

#include <SDL3/SDL.h>
#include <nlohmann/json.hpp>

#include <cstdio>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <fstream>
#include <print>
#include <string>
#include <system_error>

#include "exitcodes.hpp"
#include "kazarov/data_version.hpp"
#include "platform/firstrun.hpp"
#include "platform/paths.hpp"

namespace fs = std::filesystem;

namespace {

std::string FlatpakHint(const std::string &where) {
    const char *id = std::getenv("FLATPAK_ID");
    if (id == nullptr || *id == '\0') {
        return "";
    }
    return "\nInside the Flatpak, from a shell: flatpak run --filesystem=<folder of the image>:ro --command=dc2data " +
           std::string(id) + " extract <disc image> " + where + "\n";
}

} // namespace

bool FirstRunDataMissing(const fs::path &root) {
    // The data is <game-root>/data.zip, or the unified data/ directory.
    std::error_code error;
    const auto      game_root = root.parent_path();
    const bool      archive = fs::is_regular_file(game_root / "data.zip", error);
    const bool      directories = fs::is_directory(root, error);
    if ((!archive && !directories) || !fs::is_regular_file(game_root / "data.json", error)) {
        return true;
    }
    std::ifstream marker(game_root / "data.json");
    const auto    parsed = nlohmann::json::parse(marker, nullptr, false);
    return !parsed.is_object() || !parsed.contains("schema_version") || !parsed["schema_version"].is_number_integer() ||
           parsed["schema_version"] != 1 || !parsed.contains("data_version") ||
           !parsed["data_version"].is_number_integer() || parsed["data_version"] != KAZAROV_DATA_VERSION;
}

std::string FirstRunDataMessage(const fs::path &root) {
    const std::string where = PathsDisplay(root);
    return "No current Dark Chronicle data at " + where + ".\n\n"
                                                          "Extract it once from the disc with:\n"
                                                          "  dc2data extract <disc image or folder> " +
           where + "\n\n"
                   "The source is an image of the Dark Chronicle disc, or a folder holding DATA.HD4, DATA.DAT, SOUND.HD3 and SOUND.DAT.\n\n"
                   "Or point the game at an existing extraction with --data <dir> or the DC2_DATA environment variable.\n" +
           FlatpakHint(where);
}

void FirstRunRequireData(const fs::path &root, bool headless) {
    if (!FirstRunDataMissing(root)) {
        return;
    }
    const std::string text = FirstRunDataMessage(root);
    std::fputs(text.c_str(), stderr);
    if (!headless) {
        try {
            const auto path = root.u8string();
            if (kazarov::setup_data("Dark Chronicle — Game data", std::string(
                                                                      reinterpret_cast<const char *>(path.data()), path.size())) &&
                !FirstRunDataMissing(root)) {
                return;
            }
        } catch (const std::exception &error) {
            std::println(stderr, "Game data setup: {}", error.what());
            SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Dark Chronicle", error.what(), nullptr);
        }
    }
    std::exit(kExitNoData);
}
