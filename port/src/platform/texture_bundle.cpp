#include "platform/texture_bundle.hpp"

#include <nlohmann/json.hpp>

#include <stdexcept>

#include "platform/model_assets.hpp"

namespace texture_bundle {
std::optional<std::size_t> FindSet(const nlohmann::json &game, std::string_view entry) {
    const auto                &sets = (game.contains("resources") ? game.at("resources") : game).at("texture_sets");
    std::optional<std::size_t> found;
    for (std::size_t index = 0; index < sets.size(); ++index) {
        for (const auto &picture : sets.at(index).at("document").at("entries")) {
            if (picture.value("name", std::string{}) != entry) {
                continue;
            }
            if (found && *found != index) {
                throw std::runtime_error("ambiguous embedded texture name: " + std::string(entry));
            }
            found = index;
        }
    }
    return found;
}

bool Enter(const std::filesystem::path &path, std::string_view entry, mgCTextureManager &manager,
           int block, mgCMemory *memory, std::string &error, bool optional) {
    try {
        const auto game = model_assets::ReadGameplay(path, error);
        if (!game) {
            return false;
        }
        const auto index = FindSet(*game, entry);
        if (!index) {
            if (optional) {
                error.clear();
                return true;
            }
            error = "embedded texture missing: " + std::string(entry) + " in " + path.generic_string();
            return false;
        }
        return model_assets::LoadTextureSet(path, *index, manager, block, memory, error);
    } catch (const std::exception &exception) {
        error = exception.what();
        return false;
    }
}
} // namespace texture_bundle
