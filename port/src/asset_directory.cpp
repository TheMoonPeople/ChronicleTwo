#include "asset_directory.hpp"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cstring>
#include <limits>
#include <map>
#include <memory>
#include <vector>

#include "dataread_port.hpp"
#include "luau_runtime.hpp"
#include "platform/datapacks.hpp"
#include "platform/vfs.hpp"
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
    if (path.empty() || path.is_absolute() || path.has_root_name() || path.has_root_directory() || name.contains(':') || name.contains('\0')) {
        return false;
    }
    return std::ranges::all_of(path, [](const auto &part) { return part != "." && part != ".." && !part.empty(); });
}

constexpr std::string_view kAssetDirectory = "asset_directory";

/**
 * Parses a file's bytes as JSON, discarding malformed documents.
 */
Json Parse(const File &file, int size) {
    const auto *begin = reinterpret_cast<const char *>(file.bytes.data());
    return Json::parse(begin, begin + size, nullptr, false);
}

/**
 * Validates a typed native document: an asset directory's pack.json, a texture table or a configuration.
 */
bool Valid(const Json &data, std::string_view kind) {
    if (data.is_discarded() || !data.is_object() || !data.contains("schema_version")) {
        return false;
    }
    const auto &version = data["schema_version"];
    if (kind == "texture") {
        return version == 3 && data.contains("entries") && data["entries"].is_array() && data.contains("groups") &&
               data["groups"].is_array();
    }
    if (kind == "commands") {
        // Configurations are native semantic documents of a named kind.
        return version == 2 && data.contains("kind") && data["kind"].is_string();
    }
    if (version != 1 || !data.contains("kind") || data["kind"] != "asset_directory" ||
        std::ranges::any_of(data.items(), [](const auto &item) { return item.key() != "schema_version" && item.key() != "kind" && item.key() != "texture_members"; })) {
        return false;
    }
    if (!data.contains("texture_members")) {
        return true;
    }
    if (!data["texture_members"].is_array()) {
        return false;
    }
    std::map<std::string, bool> names;
    for (const auto &member : data["texture_members"]) {
        if (!member.is_object() || member.size() != 2 || !member.contains("name") || !member["name"].is_string() ||
            !member.contains("path") || !member["path"].is_string()) {
            return false;
        }
        const fs::path name(member["name"].get<std::string>());
        const fs::path path(member["path"].get<std::string>());
        if (!Relative(name) || name.has_parent_path() || Key(name.extension().generic_string()) != ".json" ||
            !Relative(path) || !path.generic_string().starts_with("textures/") || Key(path.extension().generic_string()) != ".json" ||
            !names.emplace(Key(name.generic_string()), true).second) {
            return false;
        }
    }
    return true;
}

/**
 * Fills a member's storage with bytes and records its logical lookup path, releasing the bytes it held before.
 */
File *Store(const std::string &key, const fs::path &relative, std::string_view bytes) {
    auto &file = files[key];
    if (!file) {
        file = std::make_unique<File>();
    }
    if (!file->bytes.empty()) {
        TextureSourceForget(file->bytes.data());
        DataReadRegisterBuffer(file->bytes.data(), 0);
    }
    const auto padded = std::max<std::size_t>(2048, (bytes.size() + 2047) / 2048 * 2048);
    file->bytes.resize(padded / sizeof(u_long128));
    std::memset(file->bytes.data(), 0, padded);
    std::memcpy(file->bytes.data(), bytes.data(), bytes.size());
    file->size = static_cast<int>(bytes.size());
    file->name = relative.filename().generic_string();
    DataReadRegisterAsset(file->bytes.data(), relative.generic_string(), bytes.size());
    return file.get();
}

/**
 * Reads a selected asset, recording its logical lookup path and byte extent. A script member with a Luau module reads
 * as the handle naming it.
 */
File *Read(fs::path relative, std::string_view kind = {}) {
    if (Key(relative.extension().generic_string()) == ".stb") {
        if (const auto module = luau_runtime::ModuleForScript(vfs::FoldKey(relative.generic_string()))) {
            return Store("luau:" + Key(relative.generic_string()), relative, luau_runtime::MakeHandle(*module));
        }
    }
    auto candidates = Key(relative.extension().generic_string()) == ".json" ? datapacks::GameplayCandidates(relative) : datapacks::Candidates(relative);
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
        const std::string_view document = relative.filename() == "pack.json" ? kAssetDirectory : kind;
        if (!document.empty() && !Valid(Parse(*file, static_cast<int>(*size)), document)) {
            continue;
        }
        file->size = static_cast<int>(*size);
        file->name = (relative.filename() == "pack.json" ? relative.parent_path() : relative).filename().generic_string();
        DataReadRegisterAsset(file->bytes.data(), relative.generic_string(), static_cast<std::size_t>(*size));
        return file.get();
    }
    return nullptr;
}

/**
 * Identifies a logical PACK member and its native asset lookup path.
 */
struct Member {
    fs::path    path; /**< Logical native file or child-directory lookup path. */
    std::string name; /**< Logical name returned to PACK consumers. */
};

/**
 * Merges texture membership, gameplay documents and native files in deterministic name order.
 */
std::vector<Member> Members(const std::string &directory) {
    std::map<std::string, Member> members;
    if (auto *marker = Read(fs::path(directory) / "pack.json", kAssetDirectory)) {
        const auto data = Parse(*marker, marker->size);
        if (data.contains("texture_members")) {
            for (const auto &member : data["texture_members"]) {
                auto name = member["name"].get<std::string>();
                members.emplace(Key(name), Member{.path = fs::path(member["path"].get<std::string>()), .name = name});
            }
        }
    }
    for (const auto &path : datapacks::DirectoryMembers(directory)) {
        const auto name = path.filename().generic_string();
        const auto key = Key(name);
        if (key != "pack.json" && !key.ends_with(".game.json")) {
            members.insert_or_assign(key, Member{.path = path, .name = name});
        }
    }
    for (const auto &path : datapacks::DirectoryMembers(fs::path("gameplay") / directory)) {
        const auto name = path.filename().generic_string();
        const auto key = Key(name);
        if (key.ends_with(".json")) {
            members.insert_or_assign(key, Member{.path = fs::path(directory) / name, .name = name});
        }
    }
    std::vector<Member> result;
    result.reserve(members.size());
    for (auto &[key, member] : members) {
        result.push_back(std::move(member));
    }
    return result;
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
    const auto data = Parse(*file, file->size);
    return Valid(data, kind) && data["schema_version"].is_number_integer();
}
} // namespace

std::optional<std::string> AssetDirectoryPath(const void *directory) {
    const auto path = DataReadBufferPath(directory);
    const auto size = DataReadBufferSize(directory);
    if (!path || Key(fs::path(*path).filename().generic_string()) != "pack.json") {
        return std::nullopt;
    }
    const auto *begin = static_cast<const char *>(directory);
    bool        accepted = size > 0 && Valid(Json::parse(begin, begin + size, nullptr, false), kAssetDirectory);
    if (!accepted) {
        for (const auto &candidate : datapacks::Candidates(*path)) {
            std::vector<uint8_t> bytes;
            if (!datapacks::ReadFileBytes(candidate, bytes)) {
                continue;
            }
            if (Valid(Json::parse(bytes, nullptr, false), kAssetDirectory)) {
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
    std::ranges::replace(normalized, '\\', '/');
    const fs::path member(normalized);
    if (!Relative(member)) {
        return nullptr;
    }
    auto path = fs::path(*parent) / member;
    if (!member.has_parent_path()) {
        const auto requested = Key(member.generic_string());
        for (const auto &candidate : Members(*parent)) {
            if (Key(candidate.name) == requested) {
                path = candidate.path;
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
    auto *file = Read(members[index].path);
    if (file) {
        file->name = members[index].name;
    }
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
        if (!Kind(member.path, selected, file)) {
            continue;
        }
        if (!file) {
            file = Read(member.path);
        }
        if (!file) {
            continue;
        }
        file->name = member.name;
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
