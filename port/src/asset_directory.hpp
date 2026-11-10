#pragma once

#include "common.h"

#include <optional>
#include <string>
#include <string_view>
#include <vector>

#include "dataread.hpp"

/**
 * Returns the actual native directory named by a bounded versioned pack.json buffer.
 */
std::optional<std::string> AssetDirectoryPath(const void *directory);
/**
 * Reads an explicitly named native file, relocated texture or child directory.
 */
u_int *AssetDirectoryRead(const void *directory, const char *name, int *out_size);
/**
 * Reads one directly contained native file or directory by its deterministic directory index.
 */
u_int *AssetDirectoryRead(const void *directory, int index, char **out_name, int *out_size);
/**
 * Reads direct native members selected by glTF, typed JSON kind, or actual file extension.
 */
int AssetDirectoryReadExtension(const void *directory, const char *kind, u_int **outputs, int max_files, int *sizes, char **names);
/**
 * Counts logical direct members, including relocated textures and excluding metadata sidecars.
 */
int AssetDirectoryCount(const void *directory);

namespace dc2::assets {
/**
 * Selects the bounded final component of a resource path using either path separator.
 */
std::string_view MemberName(std::string_view path);

/**
 * Owns a directory member's initialized native contents and logical enumeration name.
 */
struct DirectoryMember {
    std::string  name; /**< Logical direct member name independent of its source path. */
    io::FileRead read; /**< Owns the complete initialized native member contents. */
};

/**
 * Reads deterministic direct native members selected by document kind or file extension.
 */
std::vector<DirectoryMember> ReadDirectoryMembers(const io::FileRead &directory, std::string_view kind = {});
/**
 *
 * Gives the native directory of an owned, bounded and validated pack document.
 *
 */
std::optional<std::string> DirectoryPath(const io::FileRead &directory);
/**
 *
 * Resolves a member using an owned directory document and its explicit source identity.
 *
 */
std::optional<std::string> ResolveDirectoryMember(const io::FileRead &directory, std::string_view name);
/**
 *
 * Owns a validated member read from an owned directory document.
 *
 */
io::FileRead ReadDirectoryMember(const io::FileRead &directory, std::string_view name);
} // namespace dc2::assets
