#include "asset_directory.hpp"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cstring>
#include <limits>
#include <map>
#include <memory>
#include <vector>

#include "dataread_port.hpp"
#include "platform/datapacks.hpp"
#include "texture_source.hpp"

namespace {
namespace fs = std::filesystem;
using Json = nlohmann::json;

/**
 * Retains aligned actual native file bytes and their stable directory-entry name.
 */
struct File {
    std::vector<u_long128> bytes;    /**< Sector-padded native file storage. */
    std::string            name;     /**< Actual filename returned by directory enumeration. */
    int                    size = 0; /**< Bounded native file byte count. */
};

/**
 * Retains native file storage while game consumers reference directory members.
 */
std::map<std::string, std::unique_ptr<File> > files;

/**
 * Produces a case-insensitive key for actual filesystem names.
 */
std::string Key(std::string value) {
    for (auto &character : value) {
        if (character >= 'A' && character <= 'Z') {
            character += 'a' - 'A';
        }
    }
    return value;
}

/**
 * Accepts relative filenames without parent traversal or alternate filesystem roots.
 */
bool Relative(const fs::path &path) {
    const auto name = path.generic_string();
    if (path.empty() || path.is_absolute() || path.has_root_name() || path.has_root_directory() || name.find(':') != std::string::npos || name.find('\0') != std::string::npos) {
        return false;
    }
    for (const auto &part : path) {
        if (part == "." || part == ".." || part.empty()) {
            return false;
        }
    }
    return true;
}

/**
 * Lists actual direct native files and child directories without gameplay sidecars.
 */
std::vector<fs::path> Members(const std::string &directory) {
    auto members = datapacks::DirectoryMembers(directory);
    std::erase_if(members, [](const auto &path) {
        const auto name = Key(path.filename().generic_string());
        return name == "pack.json" || name.ends_with(".game.json");
    });
    return members;
}

/**
 * Reads a directly selected actual file, recording its physical relative path and byte extent.
 */
File *Read(fs::path relative, std::string_view kind = {}) {
    auto candidates = datapacks::Candidates(relative);
    if (candidates.empty()) {
        relative /= "pack.json";
        candidates = datapacks::Candidates(relative);
    }
    for (const auto &path : candidates) {
        const auto size = vfs::Size(path);
        if (!size || *size > static_cast<std::uint64_t>(std::numeric_limits<int>::max())) {
            continue;
        }
        const auto key = path.Display();
        auto      &file = files[key];
        if (!file) {
            file = std::make_unique<File>();
        }
        if (!file->bytes.empty()) {
            TextureSourceForget(file->bytes.data());
            DataReadRegisterBuffer(file->bytes.data(), 0);
        }
        const auto padded = std::max<std::size_t>(2048, (static_cast<std::size_t>(*size) + 2047) / 2048 * 2048);
        file->bytes.resize(padded / sizeof(u_long128));
        std::memset(file->bytes.data(), 0, padded);
        if (!vfs::ReadInto(path, file->bytes.data(), static_cast<std::size_t>(*size))) {
            continue;
        }
        if (relative.filename() == "pack.json" || kind == "texture" || kind == "commands") {
            const auto *begin = reinterpret_cast<const char *>(file->bytes.data());
            const auto  data = Json::parse(begin, begin + *size, nullptr, false);
            if (data.is_discarded() || !data.is_object()) {
                continue;
            }
            if (relative.filename() == "pack.json") {
                if (!data.contains("schema_version") || data["schema_version"] != 1 || !data.contains("kind") || data["kind"] != "asset_directory") {
                    continue;
                }
            } else if (kind == "texture") {
                if (!data.contains("schema_version") || data["schema_version"] != 3 || !data.contains("entries") || !data["entries"].is_array() || !data.contains("groups") || !data["groups"].is_array()) {
                    continue;
                }
            } else if (!data.contains("schema_version") || data["schema_version"] != 1 || !data.contains("commands") || !data["commands"].is_array()) {
                continue;
            }
        }
        file->size = static_cast<int>(*size);
        file->name = (relative.filename() == "pack.json" ? relative.parent_path() : relative).filename().generic_string();
        DataReadRegisterAsset(file->bytes.data(), relative.generic_string(), static_cast<std::size_t>(*size));
        return file.get();
    }
    return nullptr;
}

/**
 * Selects a native typed JSON document or an actual file extension.
 */
bool Kind(const fs::path &path, std::string_view kind, File *&file) {
    const auto extension = Key(path.extension().generic_string());
    if (kind != "texture" && kind != "commands") {
        return extension == "." + std::string(kind);
    }
    if (extension != ".json") {
        return false;
    }
    file = Read(path, kind);
    if (!file) {
        return false;
    }
    const auto *begin = reinterpret_cast<const char *>(file->bytes.data());
    const auto  data = Json::parse(begin, begin + file->size, nullptr, false);
    if (data.is_discarded() || !data.is_object() || !data.contains("schema_version") || !data["schema_version"].is_number_integer()) {
        return false;
    }
    if (kind == "texture") {
        return data["schema_version"] == 3 && data.contains("entries") && data["entries"].is_array() && data.contains("groups") && data["groups"].is_array();
    }
    return data["schema_version"] == 1 && data.contains("commands") && data["commands"].is_array();
}
} // namespace

std::optional<std::string> AssetDirectoryPath(const void *directory) {
    const auto path = DataReadBufferPath(directory);
    const auto size = DataReadBufferSize(directory);
    if (!path || Key(fs::path(*path).filename().generic_string()) != "pack.json") {
        return std::nullopt;
    }
    const auto *begin = static_cast<const char *>(directory);
    auto        valid = [](const Json &data) { return !data.is_discarded() && data.is_object() && data.contains("schema_version") && data["schema_version"] == 1 && data.contains("kind") && data["kind"] == "asset_directory"; };
    bool        accepted = size > 0 && valid(Json::parse(begin, begin + size, nullptr, false));
    if (!accepted) {
        for (const auto &candidate : datapacks::Candidates(*path)) {
            std::vector<uint8_t> bytes;
            if (!datapacks::ReadFileBytes(candidate, bytes)) {
                continue;
            }
            if (valid(Json::parse(bytes, nullptr, false))) {
                accepted = true;
                break;
            }
        }
    }
    if (!accepted) {
        return std::nullopt;
    }
    const auto parent = fs::path(*path).parent_path();
    return Relative(parent) ? std::optional<std::string>(parent.generic_string()) : std::nullopt;
}

u_int *AssetDirectoryRead(const void *directory, const char *name, int *out_size) {
    if (out_size) {
        *out_size = 0;
    }
    const auto parent = AssetDirectoryPath(directory);
    if (!parent || !name) {
        return nullptr;
    }
    std::string normalized(name);
    std::replace(normalized.begin(), normalized.end(), '\\', '/');
    const fs::path member(normalized);
    if (!Relative(member)) {
        return nullptr;
    }
    auto path = fs::path(*parent) / member;
    if (!member.has_parent_path()) {
        const auto requested = Key(member.generic_string());
        for (const auto &candidate : Members(*parent)) {
            if (Key(candidate.filename().generic_string()) == requested) {
                path = candidate;
                break;
            }
        }
    }
    auto *file = Read(path);
    if (!file) {
        return nullptr;
    }
    if (out_size) {
        *out_size = file->size;
    }
    return reinterpret_cast<u_int *>(file->bytes.data());
}

u_int *AssetDirectoryRead(const void *directory, int index, char **out_name, int *out_size) {
    if (out_size) {
        *out_size = 0;
    }
    if (out_name) {
        *out_name = nullptr;
    }
    const auto parent = AssetDirectoryPath(directory);
    if (!parent || index < 0) {
        return nullptr;
    }
    const auto members = Members(*parent);
    if (static_cast<std::size_t>(index) >= members.size()) {
        return nullptr;
    }
    auto *file = Read(members[index]);
    if (!file) {
        return nullptr;
    }
    if (out_size) {
        *out_size = file->size;
    }
    if (out_name) {
        *out_name = file->name.data();
    }
    return reinterpret_cast<u_int *>(file->bytes.data());
}

int AssetDirectoryReadExtension(const void *directory, const char *kind, u_int **outputs, int max_files, int *sizes, char **names) {
    const auto parent = AssetDirectoryPath(directory);
    if (!parent || !kind || max_files <= 0) {
        return 0;
    }
    const auto selected = Key(kind);
    int        count = 0;
    for (const auto &member : Members(*parent)) {
        File *file = nullptr;
        if (!Kind(member, selected, file)) {
            continue;
        }
        if (!file) {
            file = Read(member);
        }
        if (!file) {
            continue;
        }
        if (outputs) {
            outputs[count] = reinterpret_cast<u_int *>(file->bytes.data());
        }
        if (sizes) {
            sizes[count] = file->size;
        }
        if (names) {
            names[count] = file->name.data();
        }
        if (++count == max_files) {
            break;
        }
    }
    return count;
}

int AssetDirectoryCount(const void *directory) {
    const auto parent = AssetDirectoryPath(directory);
    return parent ? static_cast<int>(Members(*parent).size()) : 0;
}
