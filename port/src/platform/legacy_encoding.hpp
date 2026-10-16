#pragma once

#include <string>
#include <string_view>

namespace legacy_encoding {
/**
 * Encodes readable JSON text as the CP932 bytes expected by the game's fonts and identifiers.
 */
std::string GameText(std::string_view utf8);
} // namespace legacy_encoding
