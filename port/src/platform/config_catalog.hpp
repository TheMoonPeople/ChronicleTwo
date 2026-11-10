#pragma once

#include <string_view>
#include <vector>

#include "platform/vfs.hpp"

/**
 * Locates gameplay JSON documents (configurations and subtitles) through datapack priority.
 */
namespace config_catalog {
/**
 * Tests whether a converted-data-relative JSON path has a document in the base data or a datapack.
 */
bool Contains(std::string_view path);
/**
 * Lists gameplay/ candidates of a logical JSON path in datapack priority order; an unsafe path has none.
 */
std::vector<vfs::Ref> Paths(std::string_view path);
} // namespace config_catalog
