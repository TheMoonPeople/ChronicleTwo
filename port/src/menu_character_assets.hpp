#pragma once

#include <cstddef>
#include <filesystem>
#include <string>
#include <string_view>

class mgCMemory;

namespace menu_character {
/**
 * Gives a reset menu character arena enough native storage for its selected profile.
 */
bool PrepareArena(mgCMemory &memory, const std::filesystem::path &model, std::string_view profile,
                  std::string &error, std::size_t extra_quadwords = 0);
} // namespace menu_character

/**
 * Sizes a reset costume slot from the actual loaded character asset before construction.
 */
void PortPrepareMenuCharacterArena(mgCMemory &memory, const void *model, const char *profile, int part);
