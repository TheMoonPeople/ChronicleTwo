#pragma once

#include <cstddef>
#include <optional>
#include <string>

/**
 * Records the actual filename of bytes loaded into a game-owned buffer.
 */
void TextureSourceRegister(const void *buffer, std::string source, std::size_t size = 0);
/**
 * Drops the source identity associated with one native buffer.
 */
void TextureSourceForget(const void *buffer);
/**
 * Clears filenames associated with loaded buffers.
 */
void TextureSourceClear();
/**
 * Returns the actual filename associated with a loaded buffer.
 */
std::optional<std::string> TextureSourceLookup(const void *buffer);
/**
 * Transfers a resource identity when native code copies its buffer.
 */
void TextureSourceCopy(const void *from, const void *to, std::size_t size);
