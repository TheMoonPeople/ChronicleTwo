#pragma once

#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

#include "loaded_buffer_copy.hpp"
#include "platform/vfs.hpp"

// Rebuilds the index of the converted data that replaces DATA.HD4: <root>/../data.zip, or else root.
// Keys are lower-cased relative paths with bytes >= 0x80 and '%' percent-encoded as
// dc2data's DiskName does; root-level manifests, dot entries, *.dc2tmp and the movie/ and sound/ trees
// are left out.
void DataReadIndex(const std::filesystem::path &root);

/**
 * Returns the bounded byte count of a buffer filled by a native file read.
 */
std::size_t DataReadBufferSize(const void *buffer);
/**
 * Returns the actual root-relative filename whose bytes fill a loaded buffer.
 */
std::optional<std::string> DataReadBufferPath(const void *buffer);
/**
 * Records the byte extent of a directly loaded native file or unchanged archive member.
 */
void DataReadRegisterBuffer(const void *buffer, std::size_t size);
/**
 * Registers the actual filename and byte extent of a directly loaded native asset.
 */
void DataReadRegisterAsset(const void *buffer, std::string_view path, std::size_t size);

// The file a game path names, through the same device, current-directory and version rules the
// loaders use; empty when the index holds no such file.
std::optional<vfs::Ref> DataReadFind(const char *game_name);
/**
 * Returns the actual native URI selected by the game's device and current-directory rules.
 */
std::optional<std::string> DataReadAssetPath(const char *game_name);

/**
 * Lists directly indexed files immediately below a native resource directory.
 */
std::vector<std::string> DataReadNativeKeys(std::string_view directory);
