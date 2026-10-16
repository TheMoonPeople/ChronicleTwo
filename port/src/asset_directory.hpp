#pragma once

#include "common.h"

#include <optional>
#include <string>

/**
 * Returns the actual native directory named by a bounded versioned pack.json buffer.
 */
std::optional<std::string> AssetDirectoryPath(const void *directory);
/**
 * Reads an explicitly named file or child directory from a native asset directory.
 */
u_int *AssetDirectoryRead(const void *directory, const char *name, int *out_size);
/**
 * Reads one directly contained native file or directory by its deterministic directory index.
 */
u_int *AssetDirectoryRead(const void *directory, int index, char **out_name, int *out_size);
/**
 * Reads direct native members selected by glTF, typed JSON kind, or actual file extension.
 */
int AssetDirectoryReadExtension(const void *directory, const char *kind, u_int **files, int max_files, int *sizes, char **names);
/**
 * Counts directly contained native files and child directories, excluding metadata sidecars.
 */
int AssetDirectoryCount(const void *directory);
/**
 * Selects an explicitly local member name from a caller's full resource path.
 */
const char *AssetMemberName(const char *path);
