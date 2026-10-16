#pragma once

#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <functional>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include "platform/texture_catalog.hpp"

namespace datapacks {

/**
 * Holds physical RGBA canvases while the catalog retains the game's logical dimensions.
 */
struct DecodedTexture {
    std::vector<std::vector<uint8_t> > levels;     /**< RGBA mip canvases, largest first. */
    uint32_t                           width = 0;  /**< Padded physical width of the base level. */
    uint32_t                           height = 0; /**< Padded physical height of the base level. */
};

/**
 * Loads the sibling datapacks/datapacks.json; later load_order folders take precedence.
 */
void Load(const std::filesystem::path &port_data_root);

/**
 * Clears all configured pack roots and their file indexes.
 */
void Clear();

/**
 * Finds a regular replacement for a relative game-data path, ignoring ASCII case.
 */
std::optional<std::filesystem::path> Resolve(const std::filesystem::path &relative);

/**
 * Returns the converted-data directory established by Load.
 */
const std::filesystem::path &Root();

/**
 * Lists safe replacement assets in priority order followed by the retail asset.
 */
std::vector<std::filesystem::path> Candidates(const std::filesystem::path &relative);
/**
 * Lists merged direct file and child-directory names through datapack priority.
 */
std::vector<std::filesystem::path> DirectoryMembers(const std::filesystem::path &relative);

/**
 * Finds the highest-priority replacement or the corresponding converted retail asset.
 */
std::optional<std::filesystem::path> Asset(const std::filesystem::path &relative);

/**
 * Decodes a catalog variant through PNG overlays, falling back to valid lower-priority assets.
 */
bool Decode(const texture_catalog::Entry &entry, std::size_t variant, DecodedTexture &decoded, std::string &error);

/**
 * Names decoded pixels by a semantic image identity and every possible source file's current stamp.
 */
std::string ImageDecodeKey(std::string_view identity, std::span<const std::filesystem::path> sources);
/**
 * Reuses immutable decoded image pixels within the shared 512 MiB least-recently-used cache.
 */
bool DecodeCached(std::string_view                                            identity,
                  const std::function<bool(DecodedTexture &, std::string &)> &decoder,
                  DecodedTexture &decoded, std::string &error);

} // namespace datapacks
