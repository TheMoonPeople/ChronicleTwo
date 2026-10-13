#pragma once

#include <filesystem>
#include <optional>
#include <string>
#include <vector>

// Rebuilds the index of the extracted data under root, the files that replace DATA.HD4. Each entry is a
// regular file keyed by its lower-cased path below root, as it sits on disk; lookups percent-encode
// bytes >= 0x80 and '%' the way dc2data's DiskName does before they reach the index. Root-level
// manifest.txt, dot entries, *.dc2tmp files and the movie/ and sound/ trees are left out. Logs its
// count to stderr.
void DataReadIndex(const std::filesystem::path &root);

// The file a game path names, through the same device, current-directory and version rules the
// loaders use; empty when the index holds no such file.
std::optional<std::filesystem::path> DataReadFind(const char *game_name);

// Sorted script keys from the existing index; does not walk the data tree again.
std::vector<std::string> DataReadScriptKeys();

struct ScriptTimingValidation {
    std::size_t              files = 0;
    double                   seconds = 0;
    std::vector<std::string> errors;
};

// Dry-run the same recipes as the loader over every indexed .stb, including datapack replacements.
ScriptTimingValidation DataReadValidateScriptTiming();

// Before gameplay starts, offer PAL/50 for incompatible scripts. Headless runs report and fail.
// False means startup must quit, either by desktop choice or a headless mismatch.
bool DataReadPrepareScriptTiming(bool headless);
