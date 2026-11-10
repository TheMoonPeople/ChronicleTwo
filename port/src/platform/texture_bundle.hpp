#pragma once

#include <nlohmann/json_fwd.hpp>

#include <cstddef>
#include <filesystem>
#include <optional>
#include <string>
#include <string_view>

class mgCMemory;
class mgCTextureManager;

namespace texture_bundle {
/**
 * Selects the texture set containing an authored native texture name.
 */
std::optional<std::size_t> FindSet(const nlohmann::json &game, std::string_view entry);
/**
 * Registers one named embedded texture set from a directly selected glTF bundle.
 */
bool Enter(const std::filesystem::path &path, std::string_view entry, mgCTextureManager &manager,
           int block, mgCMemory *memory, std::string &error, bool optional = false);
} // namespace texture_bundle
