#pragma once

#include <optional>
#include <string>
#include <string_view>

namespace legacy_encoding {
/**
 * Encodes readable JSON text as the CP932 bytes expected by the game's fonts and identifiers.
 */
std::string GameText(std::string_view utf8);

/**
 * Decodes the game's CP932 bytes as UTF-8 text, or nullopt when they are not valid CP932.
 */
std::optional<std::string> ReadableText(std::string_view cp932);
} // namespace legacy_encoding
