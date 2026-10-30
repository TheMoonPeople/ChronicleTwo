#pragma once

#include <cstddef>
#include <span>
#include <string_view>

namespace script_text {

/**
 * Describes an exact replacement in a Latin-1 event message file.
 */
struct Edit {
    const char *retail; /**< Passage that must occur exactly once. */
    const char *text;   /**< Corrected passage. */
};

/**
 * Returns exact passage corrections for an event message file.
 */
std::span<const Edit> Edits(std::string_view key);

/**
 * Returns the maximum additional bytes required to hold an asset's corrected text.
 */
std::size_t Extra(std::string_view key);

/**
 * Corrects matching PAL event text and returns its actual size, leaving mismatched files unchanged.
 * The buffer must hold size plus Extra(key) bytes; shortened text is zero-filled to size. Script text is corrected
 * when the scripts are translated (tools/luau/script_text.json).
 */
std::size_t Patch(std::string_view key, unsigned char *bytes, std::size_t size);

} // namespace script_text
