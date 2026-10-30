#include "common.h"

#include <eekernel.h>
#include <libcdvd.h>
#include <sifdev.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "dataread.hpp"
#include "filesocket.hpp"
#include "hddinstall.hpp"
#include "memory/tracked_copy.hpp"
#include "mglib.hpp"
#include "text/bounded.hpp"

/**
 *
 * Root directory restored when changing the file device or current directory.
 *
 */
static char TopDir[256] = "";

/**
 *
 * Directory prepended to file names without an explicit device prefix.
 *
 */
static char CurrentDir__2[256] = "";

/**
 *
 * Device selected for file names without a device prefix.
 *
 */
static int DefaultFileDev = FILE_DEV_CDROM;

/**
 *
 * Callback receiving failed hard-disk file operation results.
 *
 */
static int (*error_cb)(int);

/**
 *
 * Pack-file buffer cleared when initializing the disc file index.
 *
 */
static u_int *packfile_buff;

int GetMainFileDev() {
    return DefaultFileDev;
}

int ChangeHddFile();

int ChangeDefaultFile() {
    if (DefaultFileDev != FILE_DEV_HDD) {
        return 0;
    }

    UmountHDDFileSystem();
    DefaultFileDev = FILE_DEV_CDROM;
    dc2::text::Copy(TopDir, dc2::text::View(""));
    dc2::text::Copy(CurrentDir__2, dc2::text::View(""));
    return 1;
}

void SetIoErrCallBack(int (*callback)(int)) {
    error_cb = callback;
}

void SetCurrentDir(char *dir);

void ChangeDir(char *dir);

void InitReadBG();

void StartReadBG() {
    InitReadBG();
}

void ReadBG();

int ReadBGSync();

void BreakReadBG();

void InitCDFile();

void InitFileCache(dc2::memory::ArenaBuffer storage, int type);

void DeleteFileCache() {
    InitFileCache({}, FILE_CACHE_NONE);
}

int LoadFileCacheBG(char *path);

u_long128 *SearchFileCache(char *path, int *out_size);

int WriteFile(char *path, void *buffer, int size);

u_int *AssetDirectoryRead(u_int *pack, char *name, int *out_size);

u_int *AssetDirectoryRead(u_int *pack, int index, char **out_name, int *out_size);

int AssetDirectoryReadExtension(u_int *pack, char *extension, u_int **files, int max_files, int *sizes, char **names);

int AssetDirectoryCount(u_int *pack);

std::pair<std::string, std::string> DivPathName(std::string_view path) {
    const auto slash = path.rfind('/');
    if (slash == std::string_view::npos || slash == 0) {
        return {{}, std::string(path)};
    }
    return {std::string(path.substr(0, slash + 1)), std::string(path.substr(slash + 1))};
}

DataReadPathNameExt DivPathNameExt(std::string_view path) {
    auto [directory, name] = DivPathName(path);
    const auto dot = name.find('.');
    if (dot == std::string::npos) {
        return {std::move(directory), std::move(name), {}};
    }
    std::string extension = name.substr(dot + 1);
    name.resize(dot);
    return {std::move(directory), std::move(name), std::move(extension)};
}

#include "common.h"

#include <SDL3/SDL.h>
#include <eekernel.h>
#include <sifdev.h>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <limits>
#include <mutex>
#include <optional>
#include <print>
#include <span>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "assets/data_registry.hpp"
#include "character_motion.hpp"
#include "crash/crash.hpp"
#include "dataread.hpp"
#include "log/log.hpp"
#include "luau_runtime.hpp"
#include "platform/archive_mount.hpp"
#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "platform/texture_catalog.hpp"
#include "platform/vfs.hpp"
#include "profile.hpp"
#include "script_text.hpp"
#include "texture_source.hpp"

namespace dc2::io {
/**
 *
 * Keeps loaded file bytes and their registrations alive independently of queue membership.
 *
 */
struct FileReadState {
    FileReadState() = default;
    FileReadState(const FileReadState &) = delete;
    FileReadState &operator=(const FileReadState &) = delete;
    FileReadState(FileReadState &&) = delete;
    FileReadState              &operator=(FileReadState &&) = delete;
    std::string                 source;               /**< Copied native source identity independent of pointer registries. */
    std::vector<u8>             storage;              /**< Sector-padded owned file bytes. */
    std::string                 name;                 /**< Exact full queued filename. */
    int                         size = 0;             /**< Initialized transformed file length. */
    bool                        issued = false;       /**< Whether completion polling issued this read. */
    bool                        cache_backed = false; /**< Queue context explicitly supplied by the file-cache producer. */
    bool                        cancelled = false;    /**< Whether the queue removed this unfinished read. */
    bool                        done = false;         /**< Whether completion polling completed this read. */
    std::shared_ptr<const void> extent_registration;  /**< Exact owned buffer bound registration. */
    std::shared_ptr<const void> source_registration;  /**< Exact owned source registration. */
};
} // namespace dc2::io

namespace fs = std::filesystem;

// Replacements own the state they touch: a port unit cannot see ps2/src's statics, so the current
// directory, the background queue and the file cache live here.

namespace {

constexpr std::size_t kSector = DATAREAD_SECTOR_SIZE;
constexpr std::size_t kExpectedFiles = 10240;

// The index replaces DATA.HD4, which never listed these: manifest.txt and the movie/ and sound/ trees
// are converted data that their own subsystems read, not dataread.
constexpr std::array<std::string_view, 4> kExcludedRootNames = {"manifest.txt", "manifest.json", "movie", "sound"};

struct IndexedFile {
    vfs::Ref    file;             /**< Data file supplying the bytes. */
    bool        replaced = false; /**< A datapack file stands in for the extracted one. */
    std::string relative;         /**< Logical asset filename, including directory metadata files. */
};

std::unordered_map<std::string, IndexedFile> file_index;
bool                                         index_built;

/** Byte bounds for actual file contents loaded into game-owned arenas. */
/**
 *
 * Identifies one registered initialized byte extent without owning its caller's storage.
 *
 */
struct BufferExtent {
    std::size_t   size = 0;     /**< Initialized byte count. */
    std::uint64_t identity = 0; /**< Registration identity renewed on every replacement. */
};

/**
 *
 * Serializes byte-bound registrations while owned cleanup tokens may outlive global handles.
 *
 */
struct BufferRegistry {
    std::mutex                                     mutex;
    std::unordered_map<const void *, BufferExtent> extents;
    std::uint64_t                                  next_identity = 1;
};

std::shared_ptr<BufferRegistry> BufferRegistrations() {
    static auto registry = std::make_shared<BufferRegistry>();
    return registry;
}

std::uint64_t RegisterExtent(const void *buffer, std::size_t size) {
    const auto            registry = BufferRegistrations();
    const std::lock_guard lock(registry->mutex);
    if (registry->next_identity == std::numeric_limits<std::uint64_t>::max()) {
        std::abort();
    }
    const auto identity = registry->next_identity++;
    registry->extents.insert_or_assign(buffer, BufferExtent{size, identity});
    return identity;
}

void ForgetExtent(const void *buffer) {
    const auto            registry = BufferRegistrations();
    const std::lock_guard lock(registry->mutex);
    registry->extents.erase(buffer);
}

void ClearExtents() {
    const auto            registry = BufferRegistrations();
    const std::lock_guard lock(registry->mutex);
    registry->extents.clear();
}

/**
 *
 * Releases only its own extent registration after the owning input is destroyed.
 *
 */
struct ExtentRegistration {
    std::shared_ptr<BufferRegistry> registry;
    const void                     *buffer;
    std::uint64_t                   identity;

    ExtentRegistration(const void *address [[clang::lifetimebound]], std::size_t size)
        : registry(BufferRegistrations()), buffer(address), identity(RegisterExtent(address, size)) {}

    ExtentRegistration(const ExtentRegistration &) = delete;
    ExtentRegistration &operator=(const ExtentRegistration &) = delete;

    ~ExtentRegistration() {
        const std::lock_guard lock(registry->mutex);
        const auto            found = registry->extents.find(buffer);
        if (found != registry->extents.end() && found->second.identity == identity) {
            registry->extents.erase(found);
        }
    }
};

std::string current_dir;

struct CacheSlot {
    u_long128  *address = nullptr;
    int         size = 0;
    std::string key;
};

CacheSlot                cache_slots[FILE_CACHE_MAX];
dc2::memory::ArenaBuffer cache_storage;
std::size_t              cache_next = 0;
int                      cache_type = FILE_CACHE_NONE;

std::array<std::shared_ptr<dc2::io::FileReadState>, BG_READ_MAX> owned_bg_slots;

/**
 *
 * Retires cached pointers when the allocation or either owner generation ends.
 *
 */
void ClearCache() {
    for (auto &request : owned_bg_slots) {
        if (request && request->cache_backed) {
            request->cancelled = !request->done;
            request.reset();
        }
    }
    for (auto &slot : cache_slots) {
        slot = {};
    }
    cache_storage = {};
    cache_next = 0;
    cache_type = FILE_CACHE_NONE;
}

/**
 *
 * Exposes cache storage only while its exact allocation remains live.
 *
 */
std::span<u8> CacheBytes() {
    if (cache_type == FILE_CACHE_NONE) {
        return {};
    }
    const auto bytes = cache_storage.Bytes();
    if (bytes.empty()) {
        ClearCache();
    }
    return bytes;
}

char FoldChar(char c) {
    return c >= 'A' && c <= 'Z' ? static_cast<char>(c + ('a' - 'A')) : c;
}

std::size_t PaddedSize(std::size_t size) {
    return (size + kSector - 1) / kSector * kSector;
}

// The disc fills the tail of its last sector with whatever follows the file, so the tail is zeroed
// here: the result must not depend on the caller's buffer.
void ZeroSectorTail(void *buffer, std::size_t size) {
    const auto padding = PaddedSize(size) - size;
    if (padding != 0) {
        std::memset(static_cast<char *>(buffer) + size, 0, padding);
    }
}

/**
 * Invalidates motion data in a main-thread load destination, including any sector padding.
 */
void ReportDestination(void *buffer, std::size_t bytes) {
    if (bytes != 0) {
        character_motion::ForgetStorage(buffer, static_cast<char *>(buffer) + bytes);
    }
}

bool IsExcludedRootName(std::string_view name) {
    if (name.starts_with('.') || name.ends_with(".dc2tmp")) {
        return true;
    }
    return std::ranges::any_of(kExcludedRootNames, [name](std::string_view excluded) {
        return std::ranges::equal(excluded, name, [](char a, char b) { return FoldChar(a) == FoldChar(b); });
    });
}

// Root-anchored names skip the current directory; retail joins it in ahead of the name and the disc
// never matches the resulting "dir//name". Slash runs are collapsed when the key is built, so names
// that differ only in doubled slashes still match.
std::string IndexKey(std::string_view name) {
    std::string text;
    std::size_t colon = name.find(':');
    std::size_t separator = name.find_first_of("/\\");

    if (name.size() >= 2 && name[1] == ':') {
        text = name;
    } else if (colon != std::string_view::npos && colon < separator) {
        text = name.substr(colon + 1);
    } else if (!name.empty() && (name[0] == '/' || name[0] == '\\')) {
        text = name;
    } else {
        text = current_dir + std::string(name);
    }

    std::ranges::replace(text, '\\', '/');

    if (std::size_t semicolon = text.rfind(';'); semicolon != std::string::npos) {
        std::string_view version = std::string_view(text).substr(semicolon + 1);
        if (!version.empty() && std::ranges::all_of(version, [](char c) { return c >= '0' && c <= '9'; })) {
            text.erase(semicolon);
        }
    }

    // Same encoding as dc2data's DiskName, in lower case because the index keys are folded.
    std::string key;
    key.reserve(text.size());
    for (unsigned char c : text) {
        if (c == '/' && (key.empty() || key.back() == '/')) {
            continue;
        }
        if (c >= 0x80 || c == '%') {
            char hex[4];
            std::snprintf(hex, sizeof hex, "%%%02x", static_cast<unsigned>(c));
            key += hex;
        } else {
            key.push_back(FoldChar(static_cast<char>(c)));
        }
    }
    return key;
}

// Only the explicit host spellings: retail's GetDevType matches these exactly and sends anything else
// to the default device.
bool IsHostName(std::string_view name) {
    return name.starts_with("host:") || name.starts_with("host0:");
}

// A host name and the disc name it indexes to can be different files, so they never share a cache slot.
std::string CacheKey(std::string_view name) {
    std::string key = IndexKey(name);
    return IsHostName(name) ? "host:" + key : key;
}

const IndexedFile *Lookup(const std::string &key) {
    if (!index_built) {
        InitCDFile();
    }
    auto found = file_index.find(key);
    if (found == file_index.end()) {
        found = file_index.find(key + "/pack.json");
    }
    if (found == file_index.end()) {
        if (const auto candidates = config_catalog::Paths(key); !candidates.empty()) {
            const auto &candidate = candidates.front();
            const auto  relative = key.starts_with("gameplay/") ? key.substr(9) : key;
            return &file_index.emplace(key, IndexedFile{.file = candidate, .replaced = datapacks::IsReplacement(candidate), .relative = relative}).first->second;
        }
        for (const auto &relative : {key, key + "/pack.json"}) {
            if (const auto replacement = datapacks::Resolve(relative)) {
                return &file_index.emplace(relative, IndexedFile{.file = *replacement, .replaced = true, .relative = relative}).first->second;
            }
        }
        // A texture outside any PACK is published below textures/ in its retail directory, while scripts
        // still name it beside that directory, as every boss title card does.
        if (key.ends_with(".json") && !key.starts_with("textures/")) {
            return Lookup("textures/" + key);
        }
    }
    return found == file_index.end() ? nullptr : &found->second;
}

// Sized on demand: stat-ing every file while indexing costs about a millisecond per file on the 9p
// mounts the host data lives on, and only the files a game opens need a size. Empty when the size is
// unknown or does not fit the game's int.
// The game reads a model file into its own buffer only to hand that buffer to a model loader, which
// finds the glTF by the buffer's registered name and reads it itself. A glTF bundle holds every action
// its characters play and can be tens of megabytes, so it occupies one zeroed sector of the buffer.
bool NameOnly(const IndexedFile &file) {
    return file.relative.ends_with(".gltf");
}

std::optional<int> FileSize(const IndexedFile &file) {
    std::optional<std::uintmax_t> size = vfs::Size(file.file);
    if (size && NameOnly(file)) {
        size = std::min<std::uintmax_t>(*size, kSector);
    }
    if (!size || *size > static_cast<std::uintmax_t>(INT32_MAX)) {
        return std::nullopt;
    }
    return static_cast<int>(*size);
}

// Reads a whole file into a sector-padded buffer without recording the buffer, so it is safe off the main thread.
int ReadUnregistered(const IndexedFile &file, void *buffer, std::size_t capacity) {
    CT_PROFILE_ZONE("Read asset");
    CT_PROFILE_TEXT(file.relative.data(), file.relative.size());
    const std::optional<int> size = FileSize(file);
    if (!size) {
        return -1;
    }
    if (PaddedSize(static_cast<std::size_t>(*size)) > capacity) {
        return -1;
    }
    if (*size == 0) {
        return 0;
    }
    if (NameOnly(file)) {
        std::memset(buffer, 0, static_cast<std::size_t>(*size));
    } else if (!vfs::ReadInto(file.file, buffer, static_cast<std::size_t>(*size))) {
        return -1;
    }
    ZeroSectorTail(buffer, static_cast<std::size_t>(*size));
    return *size;
}

/**
 * Reads and records a sector-padded file buffer on the main thread.
 */
int ReadWhole(const IndexedFile &file, void *buffer, std::size_t capacity) {
    if (const std::optional<int> size = FileSize(file)) {
        if (PaddedSize(static_cast<std::size_t>(*size)) > capacity) {
            return -1;
        }
        ReportDestination(buffer, PaddedSize(static_cast<std::size_t>(*size)));
    }
    const int size = ReadUnregistered(file, buffer, capacity);
    if (size >= 0) {
        static_cast<void>(RegisterExtent(buffer, static_cast<std::size_t>(size)));
    }
    return size;
}

/**
 * Corrects PAL text and records the complete patched buffer extent.
 */
int PatchScriptText(const std::string &key, void *buffer, int size) {
    if (size < 0 || !key.ends_with(".txt")) {
        return size;
    }
    const auto extra = script_text::Extra(key);
    if (extra > 0) {
        ReportDestination(static_cast<unsigned char *>(buffer) + size, extra);
    }
    const auto patched = static_cast<int>(script_text::Patch(key, static_cast<unsigned char *>(buffer), static_cast<std::size_t>(size)));
    static_cast<void>(RegisterExtent(buffer, static_cast<std::size_t>(patched)));
    return patched;
}

// sceOpen maps host0: onto the save tree, so this reads back whatever WriteFile put there. -1 when the
// save tree does not have the file, which sends the caller on to the data index.
int ReadSaveFile(const char *name, void *buffer, bool size_only, std::size_t capacity) {
    int fd = sceOpen(name, SCE_RDONLY);
    if (fd < 0) {
        return -1;
    }
    int  size = sceLseek(fd, 0, SCE_SEEK_END);
    bool ok = size >= 0;
    if (ok && !size_only && PaddedSize(static_cast<std::size_t>(size)) > capacity) {
        sceClose(fd);
        return -1;
    }
    if (ok && !size_only) {
        ReportDestination(buffer, PaddedSize(static_cast<std::size_t>(size)));
        ok = sceLseek(fd, 0, SCE_SEEK_SET) >= 0 && sceRead(fd, buffer, size) == size;
    }
    sceClose(fd);
    if (!ok) {
        return -1;
    }
    if (!size_only) {
        ZeroSectorTail(buffer, static_cast<std::size_t>(size));
    }
    return size;
}

// The save tree is searched before the index for host names, so a file WriteFile wrote shadows the
// extracted copy. Returns -1 when neither has the name.
int ResolveFile(const char *name, const std::string &key, void *buffer, bool size_only,
                std::size_t capacity) {
    if (!index_built) {
        InitCDFile();
    }
    if (IsHostName(name)) {
        int size = ReadSaveFile(name, buffer, size_only, capacity);
        if (size >= 0) {
            if (buffer && !size_only) {
                TextureSourceRegister(buffer, key, static_cast<std::size_t>(size));
                static_cast<void>(RegisterExtent(buffer, static_cast<std::size_t>(size)));
            }
            return size;
        }
    }

    // A script loads as a handle naming its Luau module, which CRunScript::load runs; one without a module is missing.
    if (key.ends_with(".stb")) {
        const auto module = luau_runtime::ModuleForScript(key);
        if (!module) {
            return -1;
        }
        const std::string handle = luau_runtime::MakeHandle(*module);
        if (!size_only && handle.size() > capacity) {
            return -1;
        }
        if (buffer && !size_only) {
            ReportDestination(buffer, handle.size());
            std::memcpy(buffer, handle.data(), handle.size());
        }
        return static_cast<int>(handle.size());
    }

    const IndexedFile *file = Lookup(key);
    if (!file) {
        return -1;
    }
    const auto raw_size = FileSize(*file);
    const auto extra = script_text::Extra(key);
    if (!raw_size || std::cmp_greater(extra, std::numeric_limits<int>::max() - *raw_size)) {
        return -1;
    }
    if (!size_only) {
        if (static_cast<std::size_t>(*raw_size) + extra > capacity) {
            return -1;
        }
        int size = ReadWhole(*file, buffer, capacity);
        if (size >= 0) {
            if (static_cast<std::size_t>(size) + extra > capacity) {
                return -1;
            }
            size = PatchScriptText(key, buffer, size);
            TextureSourceRegister(buffer, file->relative, static_cast<std::size_t>(size));
        }
        return size;
    }
    return *raw_size + static_cast<int>(extra);
}

CacheSlot *CacheFind(const std::string &key) {
    if (CacheBytes().empty()) {
        return nullptr;
    }
    for (CacheSlot &slot : cache_slots) {
        if (slot.address && slot.key == key) {
            return &slot;
        }
    }
    return nullptr;
}

int CacheRecord(const std::string &key, u_long128 *address, int size) {
    for (CacheSlot &slot : cache_slots) {
        if (!slot.address) {
            slot.address = address;
            slot.size = size;
            slot.key = key;
            return 1;
        }
    }
    return 0;
}

std::shared_ptr<dc2::io::FileReadState> *BgFreeSlot() {
    for (auto &read : owned_bg_slots) {
        if (!read) {
            return &read;
        }
    }
    return nullptr;
}

// Indexes every base data file outside the excluded root names, with any datapack replacement already resolved.
void BuildIndex(const std::shared_ptr<const vfs::Mount> &base, const fs::path &root) {
    file_index.clear();
    index_built = true;
    if (!base) {
        CT_LOG_INFO(Data, "dataread: indexed 0 files under {} (no data)", PathsDisplay(root));
        return;
    }

    // The disc holds about 8.8k files and the converted data about 64k; reserving avoids rehashing while it fills.
    const std::size_t count = base->Count();
    file_index.reserve(std::max(kExpectedFiles, count));
    for (std::size_t index = 0; index < count; ++index) {
        std::string relative = base->Name(index);
        if (IsExcludedRootName(std::string_view(relative).substr(0, relative.find('/')))) {
            continue;
        }
        if (relative.starts_with("gameplay/")) {
            relative.erase(0, 9);
            auto candidates = config_catalog::Paths(relative);
            if (!candidates.empty()) {
                const bool replaced = datapacks::IsReplacement(candidates.front());
                auto       key = vfs::FoldKey(relative);
                file_index.insert_or_assign(std::move(key), IndexedFile{.file = std::move(candidates.front()), .replaced = replaced, .relative = std::move(relative)});
            }
            continue;
        }
        std::string key = vfs::FoldKey(relative);
        auto        replacement = datapacks::Resolve(fs::path(std::u8string(relative.begin(), relative.end())));
        const bool  replaced = replacement.has_value();
        file_index.insert_or_assign(std::move(key), IndexedFile{.file = replaced ? std::move(*replacement) : vfs::Ref(base, index), .replaced = replaced, .relative = std::move(relative)});
    }
    CT_LOG_INFO(Data, "dataread: indexed {} files under {}", file_index.size(), PathsDisplay(root));
}

} // namespace

void DataReadIndex(const fs::path &root) {
    CT_PROFILE_ZONE("Index game assets");
    const auto start = std::chrono::steady_clock::now();
    TextureSourceClear();
    ClearExtents();
    const fs::path data_root = root.has_filename() ? root : root.parent_path();
    const fs::path archive = data_root.parent_path() / "data.zip";

    // Archive and directory mounts expose the same unified asset namespace.
    std::shared_ptr<const vfs::Mount> base;
    fs::path                          location = data_root;
    std::error_code                   error;
    if (fs::is_regular_file(archive, error)) {
        location = archive;
        try {
            base = ArchiveMountOpen(archive);
        } catch (const std::exception &exception) {
            CT_LOG_ERROR(Data, "dataread: {}: {}", PathsDisplay(archive), exception.what());
        }
    } else {
        base = vfs::OpenDirectory(data_root);
    }
    if (base) {
        texture_catalog::Load(base);
    } else {
        texture_catalog::Clear();
    }
    datapacks::Load(base, data_root);
    texture_catalog::SetCandidateResolver(datapacks::Candidates);
    BuildIndex(base, location);
    CT_LOG_INFO(Data, "dataread: index ready in {:.3f} seconds",
                std::chrono::duration<double>(std::chrono::steady_clock::now() - start).count());
}

std::size_t DataReadBufferSize(const void *buffer) {
    const auto            registry = BufferRegistrations();
    const std::lock_guard lock(registry->mutex);
    const auto            found = registry->extents.find(buffer);
    return found == registry->extents.end() ? 0 : found->second.size;
}

std::optional<std::string> DataReadBufferPath(const void *buffer) {
    return TextureSourceLookup(buffer);
}

void DataReadRegisterBuffer(const void *buffer, std::size_t size) {
    if (buffer) {
        static_cast<void>(RegisterExtent(buffer, size));
    }
}

void DataReadRegisterAsset(const void *buffer, std::string_view path, std::size_t size) {
    DataReadRegisterBuffer(buffer, size);
    TextureSourceRegister(buffer, std::string(path), size);
}

void DataReadCopyBuffer(const void *source, void *destination, std::size_t size) {
    const auto count = DataReadBufferSize(source);
    if (count > 0 && count <= size) {
        static_cast<void>(RegisterExtent(destination, count));
    } else {
        ForgetExtent(destination);
    }
}

std::optional<vfs::Ref> DataReadFind(const char *game_name) {
    if (!game_name) {
        return std::nullopt;
    }
    const auto key = IndexKey(game_name);
    if (IsExcludedRootName(std::string_view(key).substr(0, key.find('/')))) {
        return std::nullopt;
    }
    if (const auto candidates = config_catalog::Paths(key); !candidates.empty()) {
        return candidates.front();
    }
    const IndexedFile *file = Lookup(key);
    if (!file) {
        return std::nullopt;
    }
    return file->file;
}

std::optional<std::string> DataReadAssetPath(const char *game_name) {
    if (game_name) {
        if (const auto *file = Lookup(IndexKey(game_name))) {
            return file->relative;
        }
    }
    return std::nullopt;
}

std::vector<std::string> DataReadNativeKeys(std::string_view directory) {
    const auto                      prefix = IndexKey("/" + std::string(directory)) + "/";
    std::unordered_set<std::string> found;
    for (const auto &[key, file] : file_index) {
        if (!key.starts_with(prefix)) {
            continue;
        }
        const auto member = key.substr(prefix.size());
        const auto separator = member.find('/');
        if (separator == std::string::npos) {
            if (member != "pack.json" && !member.ends_with(".game.json")) {
                found.insert(key);
            }
        } else if (member.substr(separator + 1) == "pack.json") {
            found.insert(prefix + member.substr(0, separator));
        }
    }
    std::vector<std::string> keys(found.begin(), found.end());
    std::ranges::sort(keys);
    return keys;
}

void InitCDFile() {
    DataReadIndex(PathsDataRoot());
}

int ChangeHddFile() {
    // The extracted data is the only device on the host; there is no hard-disk installation to mount.
    return 0;
}

// Callers copy the directory into buffers of 108 bytes (FishIMGReplace) and append file names to it
// in 128-byte paths (MenuMonsterLoadBGCheck appends "dungeon/act_script/" and a script name), so a
// directory is held to 63 bytes.
void SetCurrentDir(char *dir) {
    constexpr std::size_t directory_limit = 0x3F;
    if (!dir) {
        current_dir.clear();
        return;
    }
    if (*dir == '/') {
        dir++;
    }
    const std::string_view directory(dir);
    if (directory.size() > directory_limit) {
        CT_LOG_WARN(Data, "dataread: current directory longer than {} bytes ignored: {}", directory_limit, dir);
        return;
    }
    current_dir = directory;
}

std::string GetCurrentDir() {
    return current_dir;
}

void ChangeDir(char *dir) {
    SetCurrentDir(dir);
}

void InitReadBG() {
    for (auto &owned : owned_bg_slots) {
        if (owned && !owned->done) {
            owned->cancelled = true;
        }
        owned.reset();
    }
}

// The copy happens now, but the slot stays pending so callers polling ReadBGSync see retail's issue and
// complete states.
int LoadFileBG(char *name, std::span<u8> destination, int *out_size) {
    auto      *buffer = destination.data();
    const auto capacity = destination.size();
    CT_PROFILE_ZONE("Load background asset");
    if (out_size) {
        *out_size = 0;
    }
    if (!name || *name == '\0' || !buffer) {
        return 0;
    }
    const std::string composed = current_dir + name;
    TextureSourceForget(buffer);
    ForgetExtent(buffer);

    auto *info = BgFreeSlot();
    if (!info) {
        return 0;
    }

    int size = 0;

    if (CacheSlot *cached = CacheFind(CacheKey(name))) {
        if (static_cast<std::size_t>(cached->size) > capacity) {
            return 0;
        }
        ReportDestination(buffer, static_cast<std::size_t>(cached->size));
        dc2::memory::CopyTrackedBytes(buffer, cached->address, static_cast<std::size_t>(cached->size));
        size = cached->size;
        TextureSourceCopy(cached->address, buffer, static_cast<std::size_t>(size));
        static_cast<void>(RegisterExtent(buffer, static_cast<std::size_t>(size)));
    } else {
        size = ResolveFile(name, IndexKey(name), buffer, false, capacity);
        if (size < 0) {
            return 0;
        }
    }

    auto owned = std::make_shared<dc2::io::FileReadState>();
    owned->size = size;
    owned->name = composed;
    const auto padded = std::max<std::size_t>(DATAREAD_SECTOR_SIZE, PaddedSize(static_cast<std::size_t>(size)));
    owned->storage.resize(padded);
    if (reinterpret_cast<std::uintptr_t>(owned->storage.data()) % alignof(u_long128) != 0) {
        return 0;
    }
    if (size > 0) {
        std::memcpy(owned->storage.data(), buffer, static_cast<std::size_t>(size));
    }
    owned->extent_registration = std::make_shared<ExtentRegistration>(owned->storage.data(), static_cast<std::size_t>(size));
    if (const auto source = DataReadBufferPath(buffer)) {
        owned->source = *source;
        owned->source_registration = dc2::assets::RegisterOwnedSource(owned->storage.data(), *source);
    }
    *info = std::move(owned);

    if (out_size) {
        *out_size = size;
    }
    return 1;
}

dc2::io::FileRead::FileRead(std::shared_ptr<FileReadState> value) : state(std::move(value)) {}

dc2::io::FileRead::operator bool() const { return state != nullptr; }

std::span<u8> dc2::io::FileRead::Bytes() const & {
    return state ? std::span(state->storage).first(static_cast<std::size_t>(state->size)) : std::span<u8>{};
}

std::span<const u8> dc2::io::FileRead::PaddedBytes() const & {
    return state ? std::span<const u8>(state->storage) : std::span<const u8>{};
}

int dc2::io::FileRead::Size() const { return state ? state->size : 0; }

std::string_view dc2::io::FileRead::Name() const & { return state ? std::string_view(state->name) : std::string_view{}; }

std::string_view dc2::io::FileRead::Source() const & { return state ? std::string_view(state->source) : std::string_view{}; }

bool dc2::io::FileRead::Issued() const { return state && state->issued; }

bool dc2::io::FileRead::Done() const { return state && state->done; }

bool dc2::io::FileRead::Retain(const dc2::memory::ArenaBuffer &consumer) const {
    return state && consumer.Retain(state);
}

bool dc2::io::FileRead::Cancelled() const { return state && state->cancelled; }

dc2::io::FileRead dc2::io::FindBackgroundRead(std::string_view name) {
    static_cast<void>(CacheBytes());
    if (name.contains(char{})) {
        return {};
    }
    const std::string terminated(name);
    for (const auto &state : owned_bg_slots) {
        if (state && strcasecmp(state->name.c_str(), terminated.c_str()) == 0) {
            return FileRead(state);
        }
    }
    return {};
}

dc2::io::FileRead dc2::io::FindBackgroundRead(int index) {
    static_cast<void>(CacheBytes());
    return index >= 0 && index < BG_READ_MAX ? FileRead(owned_bg_slots[index]) : FileRead{};
}

namespace {
/**
 * Selects game-ready transformations or complete native resource file contents.
 */
enum class OwnedFileMode {
    GameData,
    ResourceContents
};

/**
 * Builds independently owned aligned storage with the exact source and extent registrations.
 */
std::shared_ptr<dc2::io::FileReadState> ReadOwnedFile(std::string_view name, OwnedFileMode mode) {
    if (name.empty() || name.contains(char{})) {
        return {};
    }
    std::string path(name);
    auto        read = std::make_shared<dc2::io::FileReadState>();
    read->name = GetCurrentDir() + path;
    int actual = 0;
    if (mode == OwnedFileMode::ResourceContents) {
        if (!index_built) {
            InitCDFile();
        }
        const auto *file = Lookup(IndexKey(path));
        if (file == nullptr || !vfs::Read(file->file, read->storage, std::numeric_limits<int>::max()) ||
            read->storage.size() > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
            return {};
        }
        actual = static_cast<int>(read->storage.size());
        read->source = file->relative;
        read->storage.resize(std::max<std::size_t>(DATAREAD_SECTOR_SIZE, PaddedSize(read->storage.size())));
    } else {
        int expected = 0;
        if (!LoadFile2(path.data(), {}, &expected, LOAD_FILE_SIZE) || expected < 0) {
            return {};
        }
        read->storage.resize(std::max<std::size_t>(DATAREAD_SECTOR_SIZE, PaddedSize(static_cast<std::size_t>(expected))));
        if (reinterpret_cast<std::uintptr_t>(read->storage.data()) % alignof(u_long128) != 0) {
            return {};
        }
        const auto destination = std::span(read->storage);
        if (!LoadFile2(path.data(), destination, &actual, LOAD_FILE_READ) || actual < 0 || static_cast<std::size_t>(actual) > destination.size()) {
            ForgetExtent(destination.data());
            TextureSourceForget(destination.data());
            return {};
        }
        if (const auto source = DataReadBufferPath(destination.data())) {
            read->source = *source;
        }
    }
    if (reinterpret_cast<std::uintptr_t>(read->storage.data()) % alignof(u_long128) != 0) {
        return {};
    }
    const auto destination = std::span(read->storage);
    std::ranges::fill(destination.subspan(static_cast<std::size_t>(actual)), u8{});
    read->size = actual;
    read->issued = true;
    read->done = true;
    read->extent_registration = std::make_shared<ExtentRegistration>(destination.data(), static_cast<std::size_t>(actual));
    if (!read->source.empty()) {
        read->source_registration = dc2::assets::RegisterOwnedSource(destination.data(), read->source);
    }
    return read;
}
} // namespace

dc2::io::FileRead dc2::io::ReadFile(std::string_view name) {
    return FileRead(ReadOwnedFile(name, OwnedFileMode::GameData));
}

dc2::io::FileRead dc2::io::ReadResourceFile(std::string_view name) {
    return FileRead(ReadOwnedFile(name, OwnedFileMode::ResourceContents));
}

dc2::io::FileRead dc2::io::QueueBackgroundRead(std::string_view name) {
    auto *slot = BgFreeSlot();
    if (slot == nullptr || name.empty() || name.contains(char{})) {
        return {};
    }
    const std::string composed = GetCurrentDir() + std::string(name);
    auto              read = ReadFile(name);
    if (!read) {
        return {};
    }
    read.state->issued = false;
    read.state->done = false;
    read.state->name = composed;
    *slot = read.state;
    return read;
}

// One state change per call, as retail: a pending slot is issued first and completed on a later call.
// Callers that poll ReadBGSync rely on observing the issued-but-not-done state.
void ReadBG() {
    for (const auto &read : owned_bg_slots) {
        if (!read || read->done) {
            continue;
        }
        if (!read->issued) {
            read->issued = true;
        } else {
            read->done = true;
        }
        return;
    }
}

int ReadBGSync() {
    ReadBG();
    return std::ranges::any_of(owned_bg_slots, [](const auto &read) {
        return read && (!read->issued || !read->done);
    })
               ? 1
               : 0;
}

// Retail returns without emptying the queue when no read is outstanding, so finished slots stay
// visible until StartReadBG.
void BreakReadBG() {
    if (!ReadBGSync()) {
        return;
    }
    InitReadBG();
}

int LoadFile(char *path, std::span<u8> destination, int *out_size) {
    if (!LoadFile2(path, destination, out_size, LOAD_FILE_READ)) {
        CT_LOG_CRITICAL(Data, "File open error \"{}\"\n \n ", path);
        Exit(EXIT_FAILURE);
    }
    return 1;
}

static int LoadFile2WithCapacity(char *path, void *buffer, std::size_t capacity, int *out_size, int mode) {
    CT_PROFILE_ZONE("Load asset");
    if (out_size) {
        *out_size = 0;
    }
    if (!path || *path == '\0' || (mode != LOAD_FILE_SIZE && !buffer)) {
        return 0;
    }
    CrashContextSet(CrashKey::LastAsset, path);
    CT_LOG_TRACE(Data, "dataread: load {} (mode {})", path, mode);
    if (mode != LOAD_FILE_SIZE) {
        TextureSourceForget(buffer);
        ForgetExtent(buffer);
    }

    if (CacheSlot *cached = CacheFind(CacheKey(path))) {
        if (mode != LOAD_FILE_SIZE) {
            if (static_cast<std::size_t>(cached->size) > capacity) {
                return 0;
            }
            ReportDestination(buffer, static_cast<std::size_t>(cached->size));
            dc2::memory::CopyTrackedBytes(buffer, cached->address, static_cast<std::size_t>(cached->size));
        }
        if (mode == LOAD_FILE_READ) {
        }
        if (out_size) {
            *out_size = cached->size;
        }
        return 1;
    }

    int size = ResolveFile(path, IndexKey(path), buffer, mode == LOAD_FILE_SIZE, capacity);
    if (size < 0) {
        return 0;
    }
    if (out_size) {
        *out_size = size;
    }
    return 1;
}

int LoadFile2(char *path, std::span<u8> destination, int *out_size, int mode) {
    return LoadFile2WithCapacity(path, destination.data(), destination.size(), out_size, mode);
}

void InitFileCache(dc2::memory::ArenaBuffer storage, int type) {
    ClearCache();
    if (type != FILE_CACHE_DOWN && type != FILE_CACHE_UP) {
        return;
    }
    const auto bytes = storage.Bytes();
    if (bytes.empty()) {
        return;
    }
    const auto address = reinterpret_cast<std::uintptr_t>(bytes.data());
    if (type == FILE_CACHE_UP) {
        const std::size_t padding = (64 - address % 64) % 64;
        if (padding >= bytes.size()) {
            return;
        }
        cache_next = padding;
    } else {
        const std::size_t tail = (address % 64 + bytes.size() % 64) % 64;
        const std::size_t guard = tail == 0 ? 64 : tail;
        if (guard > bytes.size()) {
            return;
        }
        cache_next = bytes.size() - guard;
    }
    cache_storage = storage;
    cache_type = type;
}

int LoadFileCacheBG(char *path) {
    const auto bytes = CacheBytes();
    if (!path || *path == char{} || bytes.empty()) {
        return 0;
    }
    const std::string key = CacheKey(path);
    if (CacheSlot *cached = CacheFind(key)) {
        return 1;
    }
    if (std::ranges::none_of(cache_slots, [](const auto &slot) { return slot.address == nullptr; })) {
        return 0;
    }
    int size = ResolveFile(path, IndexKey(path), nullptr, true, 0);
    if (size < 0) {
        return 0;
    }
    const std::size_t required = PaddedSize(static_cast<std::size_t>(size));
    std::size_t       offset = cache_next;
    if (cache_type == FILE_CACHE_DOWN) {
        if (required > offset) {
            return 0;
        }
        offset -= required;
    } else if (required > bytes.size() - offset) {
        return 0;
    }
    const auto destination = bytes.subspan(offset, required);
    auto      *queued = BgFreeSlot();
    if (queued == nullptr || !LoadFileBG(path, destination, &size)) {
        return 0;
    }
    (*queued)->cache_backed = true;
    auto *buffer = reinterpret_cast<u_long128 *>(destination.data());
    if (!CacheRecord(key, buffer, size)) {
        return 0;
    }
    cache_next = cache_type == FILE_CACHE_DOWN ? offset : offset + required;
    return 1;
}

u_long128 *SearchFileCache(char *path, int *out_size) {
    if (out_size) {
        *out_size = 0;
    }
    if (!path) {
        return nullptr;
    }
    CacheSlot *cached = CacheFind(CacheKey(path));
    if (!cached) {
        return nullptr;
    }
    if (out_size) {
        *out_size = cached->size;
    }
    if (const auto *file = Lookup(IndexKey(path))) {
        TextureSourceRegister(cached->address, file->relative, static_cast<std::size_t>(cached->size));
    }
    return cached->address;
}

// Writes go through the host file server, which maps host0: to the save root.
int WriteFile(char *path, void *buffer, int size) {
    if (!path || size < 0) {
        return 0;
    }
    if (std::string_view(path).starts_with("net:")) {
        CT_LOG_WARN(Data, "dataread: no network socket on the host, not writing {}", path);
        return 0;
    }

    int fd = sceOpen(path, SCE_WRONLY | SCE_CREAT | SCE_TRUNC);
    if (fd < 0) {
        return 0;
    }
    int written = sceWrite(fd, buffer, size);
    sceClose(fd);
    return written == size;
}
