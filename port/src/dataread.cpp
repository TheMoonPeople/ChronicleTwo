#include "common.h"

#include <SDL3/SDL.h>
#include <eekernel.h>
#include <sifdev.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <cassert>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <optional>
#include <print>
#include <span>
#include <string>
#include <string_view>
#include <thread>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "bounded_text.hpp"
#include "crash/crash.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "log/log.hpp"
#include "luau_runtime.hpp"
#include "platform/archive_mount.hpp"
#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "platform/texture_catalog.hpp"
#include "platform/vfs.hpp"
#include "profile.hpp"
#include "script_timing.hpp"
#include "texture_copy.hpp"
#include "texture_source.hpp"

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
std::unordered_set<std::string>              undecoded_script_warnings;
bool                                         index_built;
/** Byte bounds for actual file contents loaded into game-owned arenas. */
std::unordered_map<const void *, std::size_t> loaded_buffers;

std::string current_dir;

struct CacheSlot {
    u_long128  *address = nullptr;
    int         size = 0;
    int         ref_count = 0;
    std::string key;
};

CacheSlot  cache_slots[FILE_CACHE_MAX];
u_long128 *cache_base;
u_long128 *cache_next;
int        cache_type = FILE_CACHE_NONE;

BG_READ_INFO bg_slots[BG_READ_MAX];

char FoldChar(char c) {
    return c >= 'A' && c <= 'Z' ? static_cast<char>(c + ('a' - 'A')) : c;
}

std::size_t PaddedSize(std::size_t size) {
    return (size + kSector - 1) / kSector * kSector;
}

// The disc fills the tail of its last sector with whatever follows the file, so the tail is zeroed
// here: the result must not depend on the caller's buffer.
void ZeroSectorTail(void *buffer, std::size_t size) {
    std::memset(static_cast<char *>(buffer) + size, 0, PaddedSize(size) - size);
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
int ReadUnregistered(const IndexedFile &file, void *buffer) {
    CT_PROFILE_ZONE("Read asset");
    CT_PROFILE_TEXT(file.relative.data(), file.relative.size());
    const std::optional<int> size = FileSize(file);
    if (!size) {
        return -1;
    }
    if (NameOnly(file)) {
        std::memset(buffer, 0, static_cast<std::size_t>(*size));
    } else if (!vfs::ReadInto(file.file, buffer, static_cast<std::size_t>(*size))) {
        return -1;
    }
    ZeroSectorTail(buffer, static_cast<std::size_t>(*size));
    return *size;
}

int ReadWhole(const IndexedFile &file, void *buffer) {
    const int size = ReadUnregistered(file, buffer);
    if (size >= 0) {
        loaded_buffers[buffer] = static_cast<std::size_t>(size);
    }
    return size;
}

// The NTSC timing converts scripts before any loader or cache sees them, including datapack scripts.
bool ConvertScriptTiming(const std::string &key, void *buffer, int size) {
    if (size < 0 || !key.ends_with(".stb")) {
        return true;
    }
    const bool ok = ScriptTimingPatch(key.c_str(), static_cast<unsigned char *>(buffer), static_cast<std::size_t>(size));
    assert(ok && "script changed after startup timing validation");
    return ok;
}

// sceOpen maps host0: onto the save tree, so this reads back whatever WriteFile put there. -1 when the
// save tree does not have the file, which sends the caller on to the data index.
int ReadSaveFile(const char *name, void *buffer, bool size_only) {
    int fd = sceOpen(name, SCE_RDONLY);
    if (fd < 0) {
        return -1;
    }
    int  size = sceLseek(fd, 0, SCE_SEEK_END);
    bool ok = size >= 0;
    if (ok && !size_only) {
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
int ResolveFile(const char *name, const std::string &key, void *buffer, bool size_only) {
    if (!index_built) {
        InitCDFile();
    }
    if (IsHostName(name)) {
        int size = ReadSaveFile(name, buffer, size_only);
        if (size >= 0) {
            if (buffer && !size_only) {
                TextureSourceRegister(buffer, key, static_cast<std::size_t>(size));
                loaded_buffers[buffer] = static_cast<std::size_t>(size);
            }
            return size;
        }
    }

    // Scripts with a Luau module load as a handle naming it; CRunScript::load runs the module instead.
    if (key.ends_with(".stb")) {
        if (const auto module = luau_runtime::ModuleForScript(key)) {
            const std::string handle = luau_runtime::MakeHandle(*module);
            if (buffer && !size_only) {
                std::memcpy(buffer, handle.data(), handle.size());
            }
            return static_cast<int>(handle.size());
        }
    }

    const IndexedFile *file = Lookup(key);
    if (!file) {
        return -1;
    }
    if (!size_only) {
        const int size = ReadWhole(*file, buffer);
        if (size >= 0) {
            if (!ConvertScriptTiming(key, buffer, size)) {
                return -1;
            }
            TextureSourceRegister(buffer, file->relative, static_cast<std::size_t>(size));
        }
        return size;
    }
    return FileSize(*file).value_or(-1);
}

CacheSlot *CacheFind(const std::string &key) {
    if (!cache_base) {
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
            slot.ref_count = 1;
            slot.key = key;
            return 1;
        }
    }
    return 0;
}

// Retail rounds the cache base to a 64-byte boundary; the address is kept as a pointer, not truncated.
u_long128 *AlignCacheAddress(const u_long128 *address) {
    auto value = reinterpret_cast<std::uintptr_t>(address);
    value = (value + 63) & ~static_cast<std::uintptr_t>(63);
    return reinterpret_cast<u_long128 *>(value);
}

BG_READ_INFO *BgFreeSlot() {
    for (BG_READ_INFO &info : bg_slots) {
        if (!info.busy) {
            return &info;
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
    loaded_buffers.clear();
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
    const auto found = loaded_buffers.find(buffer);
    return found == loaded_buffers.end() ? 0 : found->second;
}

std::optional<std::string> DataReadBufferPath(const void *buffer) {
    return TextureSourceLookup(buffer);
}

void DataReadRegisterBuffer(const void *buffer, std::size_t size) {
    if (buffer) {
        loaded_buffers[buffer] = size;
    }
}

void DataReadRegisterAsset(const void *buffer, std::string_view path, std::size_t size) {
    DataReadRegisterBuffer(buffer, size);
    TextureSourceRegister(buffer, std::string(path), size);
}

void DataReadCopyBuffer(const void *source, void *destination, std::size_t size) {
    const auto count = DataReadBufferSize(source);
    if (count > 0 && count <= size) {
        loaded_buffers[destination] = count;
    } else {
        loaded_buffers.erase(destination);
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

std::vector<std::string> DataReadScriptKeys() {
    std::vector<std::string> keys;
    for (const auto &[key, file] : file_index) {
        if (key.ends_with(".stb")) {
            keys.push_back(key);
        }
    }
    std::ranges::sort(keys);
    return keys;
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

namespace {

// Scripts are independent, so validation reads and decodes them on several threads.
constexpr std::size_t kScriptTimingThreads = 16;

/**
 * One script's validation outcome.
 */
struct ScriptTimingOutcome {
    std::string error;             /**< Mismatch or read failure; empty when the script is usable. */
    bool        undecoded = false; /**< An unlisted script the decoder rejects, which loads unchanged. */
    std::string reason;            /**< The decoder's rejection of an undecoded script. */
};

ScriptTimingOutcome CheckScriptTiming(const std::string &key, const IndexedFile &file, std::vector<unsigned char> &bytes) {
    ScriptTimingOutcome outcome{};
    const auto          size = FileSize(file);
    if (!size) {
        outcome.error = "cannot read script size";
        return outcome;
    }
    bytes.resize(std::max(kSector, PaddedSize(static_cast<std::size_t>(*size))));
    const int read = ReadUnregistered(file, bytes.data());
    if (read < 0) {
        outcome.error = "cannot read script";
        return outcome;
    }
    script_timing::Options options;
    options.write = false;
    const auto result = script_timing::Apply(key, bytes.data(), static_cast<std::size_t>(read), options);
    if (!result.ok) {
        outcome.error = result.error;
    } else if (!result.decoded) {
        outcome.undecoded = true;
        outcome.reason = result.error;
    }
    return outcome;
}

} // namespace

ScriptTimingValidation DataReadValidateScriptTiming() {
    CT_PROFILE_ZONE("Validate script timing");
    ScriptTimingValidation report;
    const auto             start = std::chrono::steady_clock::now();
    const auto             keys = DataReadScriptKeys();

    // The workers see only this snapshot, never the index itself.
    std::vector<const IndexedFile *> files;
    files.reserve(keys.size());
    for (const std::string &key : keys) {
        files.push_back(&file_index.at(key));
    }
    std::vector<ScriptTimingOutcome> outcomes(keys.size());
    std::atomic<std::size_t>         next = 0;
    const auto                       work = [&] {
        std::vector<unsigned char> bytes;
        for (std::size_t i = next++; i < keys.size(); i = next++) {
            outcomes[i] = CheckScriptTiming(keys[i], *files[i], bytes);
        }
    };
    const std::size_t threads =
        std::max<std::size_t>(1, std::min<std::size_t>({std::thread::hardware_concurrency(), kScriptTimingThreads, keys.size()}));
    {
        std::vector<std::jthread> helpers;
        for (std::size_t i = 1; i < threads; ++i) {
            helpers.emplace_back(work);
        }
        work();
    }

    // Reported in key order, as a single pass would.
    for (std::size_t i = 0; i < keys.size(); ++i) {
        const std::string         &key = keys[i];
        const ScriptTimingOutcome &outcome = outcomes[i];
        report.files++;
        if (outcome.undecoded && undecoded_script_warnings.insert(key).second) {
            CT_LOG_WARN(Script, "script timing startup: warning: {} is an unlisted, undecodable script; leaving it unchanged ({})",
                        key, outcome.reason);
        }
        if (!outcome.error.empty()) {
            report.errors.push_back(key + (files[i]->replaced ? " [datapack]: " : ": ") + outcome.error);
        }
    }
    report.seconds = std::chrono::duration<double>(std::chrono::steady_clock::now() - start).count();
    return report;
}

bool DataReadPrepareScriptTiming(bool headless) {
    const auto report = DataReadValidateScriptTiming();
    CT_LOG_INFO(Script, "script timing startup: {} scripts, {} mismatches, {:.3f} seconds",
                report.files, report.errors.size(), report.seconds);
    if (report.errors.empty()) {
        return true;
    }
    std::string message = "These scripts cannot use NTSC gameplay timing:\n\n";
    for (std::size_t i = 0; i < report.errors.size(); ++i) {
        CT_LOG_ERROR(Script, "script timing startup: {}", report.errors[i]);
        if (i < 8) {
            message += report.errors[i] + "\n";
        }
    }
    if (report.errors.size() > 8) {
        message += "\nAdditional mismatches are listed in the log.\n";
    }
    CT_LOG_ERROR(Script, "script timing startup: NTSC timing unavailable; refusing startup");
    if (!headless) {
        message += "\nThe game cannot start with this script data. See the log for details.";
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Dark Chronicle - Script timing", message.c_str(), nullptr);
    }
    return false;
}

PORT_OVERRIDE void InitCDFile() {
    DataReadIndex(PathsDataRoot());
}

PORT_OVERRIDE int ChangeHddFile() {
    // The extracted data is the only device on the host; there is no hard-disk installation to mount.
    return 0;
}

// Callers copy the directory into buffers of 108 bytes (FishIMGReplace) and append file names to it
// in 128-byte paths (MenuMonsterLoadBGCheck appends "dungeon/act_script/" and a script name), so a
// directory is held to 63 bytes.
PORT_OVERRIDE void SetCurrentDir(char *dir) {
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

PORT_OVERRIDE void GetCurrentDir(char *out_dir) {
    constexpr std::size_t smallest_caller_buffer = 0x6C;
    bounded_text::Copy(std::span(out_dir, smallest_caller_buffer), current_dir);
}

PORT_OVERRIDE void ChangeDir(char *dir) {
    SetCurrentDir(dir);
}

PORT_OVERRIDE void InitReadBG() {
    for (BG_READ_INFO &info : bg_slots) {
        info.busy = 0;
    }
}

// The copy happens now, but the slot stays pending so callers polling ReadBGSync see retail's issue and
// complete states.
PORT_OVERRIDE int LoadFileBG(char *name, u_long128 *buffer, int *out_size) {
    CT_PROFILE_ZONE("Load background asset");
    if (out_size) {
        *out_size = 0;
    }
    if (!name || *name == '\0' || !buffer) {
        return 0;
    }
    TextureSourceForget(buffer);
    loaded_buffers.erase(buffer);

    BG_READ_INFO *info = BgFreeSlot();
    if (!info) {
        return 0;
    }

    int size = 0;

    if (CacheSlot *cached = CacheFind(CacheKey(name))) {
        PortTextureSourceCopy(buffer, cached->address, static_cast<std::size_t>(cached->size));
        cached->ref_count--;
        size = cached->size;
    } else {
        size = ResolveFile(name, IndexKey(name), buffer, false);
        if (size < 0) {
            return 0;
        }
    }

    std::string composed = current_dir + name;
    std::snprintf(info->name, sizeof info->name, "%s", composed.c_str());
    info->busy = 1;
    info->dev = FILE_DEV_CDROM;
    info->issued = 0;
    info->done = 0;
    info->buffer = buffer;
    info->size = size;
    info->sector = 0;
    info->sectors = size_to_sector(size);

    if (out_size) {
        *out_size = size;
    }
    return 1;
}

PORT_OVERRIDE BG_READ_INFO *GetReadBGFile(char *name) {
    for (BG_READ_INFO &info : bg_slots) {
        if (info.busy && strcasecmp(name, info.name) == 0) {
            return &info;
        }
    }
    return nullptr;
}

PORT_OVERRIDE BG_READ_INFO *GetReadBGFile(int index) {
    if (index < 0 || index >= BG_READ_MAX) {
        return nullptr;
    }
    return bg_slots[index].busy ? &bg_slots[index] : nullptr;
}

// One state change per call, as retail: a pending slot is issued first and completed on a later call.
// Callers that poll ReadBGSync rely on observing the issued-but-not-done state.
PORT_OVERRIDE void ReadBG() {
    for (BG_READ_INFO &info : bg_slots) {
        if (!info.busy || info.done) {
            continue;
        }
        if (!info.issued) {
            info.issued = 1;
        } else {
            info.done = 1;
        }
        return;
    }
}

PORT_OVERRIDE int ReadBGSync() {
    ReadBG();
    for (const BG_READ_INFO &info : bg_slots) {
        if (info.busy && (!info.issued || !info.done)) {
            return 1;
        }
    }
    return 0;
}

// Retail returns without emptying the queue when no read is outstanding, so finished slots stay
// visible until StartReadBG.
PORT_OVERRIDE void BreakReadBG() {
    if (!ReadBGSync()) {
        return;
    }
    InitReadBG();
}

// Retail stops the game when a file cannot be loaded; the port matches it so a missing file fails at
// the load that needs it.
PORT_OVERRIDE int LoadFile(char *path, void *buffer, int *out_size) {
    if (!LoadFile2(path, buffer, out_size, LOAD_FILE_READ)) {
        CT_LOG_CRITICAL(Data, "File open error \"{}\"\n \n ", path);
        Exit(0);
    }
    return 1;
}

PORT_OVERRIDE int LoadFile2(char *path, void *buffer, int *out_size, int mode) {
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
        loaded_buffers.erase(buffer);
    }

    if (CacheSlot *cached = CacheFind(CacheKey(path))) {
        if (mode != LOAD_FILE_SIZE) {
            PortTextureSourceCopy(buffer, cached->address, static_cast<std::size_t>(cached->size));
        }
        if (mode == LOAD_FILE_READ) {
            cached->ref_count--;
        }
        if (out_size) {
            *out_size = cached->size;
        }
        return 1;
    }

    int size = ResolveFile(path, IndexKey(path), buffer, mode == LOAD_FILE_SIZE);
    if (size < 0) {
        return 0;
    }
    if (out_size) {
        *out_size = size;
    }
    return 1;
}

PORT_OVERRIDE void InitFileCache(u_long128 *address, int type) {
    cache_base = nullptr;
    for (CacheSlot &slot : cache_slots) {
        slot = CacheSlot{};
    }

    if (type == FILE_CACHE_DOWN || type == FILE_CACHE_UP) {
        cache_base = AlignCacheAddress(address);
        cache_next = cache_base;
        if (type == FILE_CACHE_DOWN) {
            cache_next -= 4;
        }
        cache_type = type;
    }
}

PORT_OVERRIDE int LoadFileCacheBG(char *path) {
    if (!path || *path == '\0' || !cache_base) {
        return 0;
    }

    std::string key = CacheKey(path);
    if (CacheSlot *cached = CacheFind(key)) {
        cached->ref_count++;
        return 1;
    }

    int size = ResolveFile(path, IndexKey(path), nullptr, true);
    if (size < 0) {
        return 0;
    }
    std::size_t quadwords = PaddedSize(static_cast<std::size_t>(size)) / 16;

    u_long128 *buffer = cache_next;
    if (cache_type == FILE_CACHE_DOWN) {
        cache_next -= quadwords;
        buffer = cache_next;
    } else if (cache_type == FILE_CACHE_UP) {
        cache_next += quadwords;
    }

    if (!LoadFileBG(path, buffer, nullptr)) {
        return 0;
    }
    return CacheRecord(key, buffer, size);
}

PORT_OVERRIDE u_long128 *SearchFileCache(char *path, int *out_size) {
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
PORT_OVERRIDE int WriteFile(char *path, void *buffer, int size) {
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
