#pragma once

#include <string_view>

struct SPI_TAG_PARAM;

/**
 * Executes a direct JSON configuration through the game's tag callbacks without caller-owned file storage.
 */
bool RunNativeConfig(std::string_view game_name, SPI_TAG_PARAM *tags);
