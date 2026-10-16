#pragma once

#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

// Rebuilds the index of the extracted data under root, the files that replace DATA.HD4. Each entry is a
// regular file keyed by its lower-cased path below root, as it sits on disk; lookups percent-encode
// bytes >= 0x80 and '%' the way dc2data's DiskName does before they reach the index. Root-level
// manifest.txt, dot entries, *.dc2tmp files and the movie/ and sound/ trees are left out. Logs its
// count to stderr.
void DataReadIndex(const std::filesystem::path &root);

/**
 * Returns the bounded byte count of a buffer filled by a native file read.
 */
std::size_t DataReadBufferSize(const void *buffer);
/**
 * Returns the actual root-relative filename whose bytes fill a loaded buffer.
 */
std::optional<std::string> DataReadBufferPath(const void *buffer);
#include "loaded_buffer_copy.hpp"
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
std::optional<std::filesystem::path> DataReadFind(const char *game_name);
/**
 * Returns the actual native URI selected by the game's device and current-directory rules.
 */
std::optional<std::string> DataReadAssetPath(const char *game_name);

// Sorted script keys from the existing index; does not walk the data tree again.
std::vector<std::string> DataReadScriptKeys();
/**
 * Lists directly indexed files immediately below a native resource directory.
 */
std::vector<std::string> DataReadNativeKeys(std::string_view directory);

struct ScriptTimingValidation {
    std::size_t              files = 0;
    double                   seconds = 0;
    std::vector<std::string> errors;
};

// Dry-run the same recipes as the loader over every indexed .stb, including datapack replacements.
ScriptTimingValidation DataReadValidateScriptTiming();

// Validate before gameplay starts; incompatible scripts are logged and refuse startup.
// Desktop runs also show an error dialog. False means the caller must exit with status 5.
bool DataReadPrepareScriptTiming(bool headless);
