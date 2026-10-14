#include "common.h"

#include <SDL3/SDL.h>
#include <eekernel.h>
#include <sifdev.h>

#include <algorithm>
#include <array>
#include <cassert>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "platform/texture_catalog.hpp"
#include "script_timing.hpp"
#include "texture_source.hpp"

namespace fs = std::filesystem;

// Replacements own the state they touch: a port unit cannot see ps2/src's statics, so the current
// directory, the background queue and the file cache live here.

namespace {

constexpr std::size_t kSector = DATAREAD_SECTOR_SIZE;
constexpr std::size_t kExpectedFiles = 10240;

// The index replaces DATA.HD4, which never listed these: manifest.txt and the movie/ and sound/ trees
// are dc2data output that their own subsystems read, not dataread.
constexpr std::array<std::string_view, 5> kExcludedRootNames = {"manifest.txt", "manifest.json", "movie", "sound", "port_data"};

struct IndexedFile {
    fs::path path;
    bool     replaced = false; // a datapack file stands in for the extracted one
};

std::unordered_map<std::string, IndexedFile> file_index;
std::unordered_set<std::string>              undecoded_script_warnings;
bool                                         index_built;

std::string current_dir;

struct CacheSlot {
    u_long128  *address = nullptr;
    int         size = 0;
    int         ref_count = 0;
    std::string key;
};

CacheSlot    cache_slots[FILE_CACHE_MAX];
u_long128   *cache_base;
u_long128   *cache_next;
int          cache_type = FILE_CACHE_NONE;

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
    return std::any_of(kExcludedRootNames.begin(), kExcludedRootNames.end(), [name](std::string_view excluded) {
        return std::equal(excluded.begin(), excluded.end(), name.begin(), name.end(),
                          [](char a, char b) { return FoldChar(a) == FoldChar(b); });
    });
}

// Root-anchored names skip the current directory; retail joined it in ahead of the name and the disc
// never matched the resulting "dir//name". Slash runs are collapsed when the key is built, so names
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

    std::replace(text.begin(), text.end(), '\\', '/');

    if (std::size_t semicolon = text.rfind(';'); semicolon != std::string::npos) {
        std::string_view version = std::string_view(text).substr(semicolon + 1);
        if (!version.empty() && std::all_of(version.begin(), version.end(), [](char c) { return c >= '0' && c <= '9'; })) {
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
    return found == file_index.end() ? nullptr : &found->second;
}

// Sized on demand: stat-ing every file while indexing costs about a millisecond per file on the 9p
// mounts the host data lives on, and only the files a game opens need a size.
std::optional<std::uintmax_t> FileSize(const IndexedFile &file) {
    std::error_code error;
    std::uintmax_t  size = fs::file_size(file.path, error);
    if (error) {
        return std::nullopt;
    }
    return size;
}

int ReadWhole(const IndexedFile &file, void *buffer) {
    std::optional<std::uintmax_t> sized = FileSize(file);
    if (!sized || *sized > static_cast<std::uintmax_t>(INT32_MAX)) {
        return -1;
    }
    std::ifstream stream(file.path, std::ios::binary);
    if (!stream) {
        return -1;
    }
    stream.read(static_cast<char *>(buffer), static_cast<std::streamsize>(*sized));
    if (static_cast<std::uintmax_t>(stream.gcount()) != *sized) {
        return -1;
    }
    std::size_t size = static_cast<std::size_t>(*sized);
    ZeroSectorTail(buffer, size);
    return static_cast<int>(size);
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
    if (const auto *source = texture_catalog::Find(key)) {
        if (buffer && !size_only) {
            // A converted texture source is an opaque runtime handle. No IMG/TIM2 bytes are made
            // available to the game; source identity travels alongside copies via texture_source.
            constexpr std::array<char, 16> handle = {'K', 'Z', 'T', 'X', ':', 'a', 's', 's', 'e', 't', 0, 0, 0, 0, 0, 0};
            std::memcpy(buffer, handle.data(), handle.size());
            ZeroSectorTail(buffer, handle.size());
            TextureSourceRegister(buffer, source->source, handle.size());
        }
        return 16;
    }
    if (IsHostName(name)) {
        int size = ReadSaveFile(name, buffer, size_only);
        if (size >= 0) {
            if (buffer && !size_only) {
                TextureSourceRegister(buffer, key, static_cast<std::size_t>(size));
            }
            return size;
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
            TextureSourceRegister(buffer, key, static_cast<std::size_t>(size));
        }
        return size;
    }
    std::optional<std::uintmax_t> sized = FileSize(*file);
    if (!sized || *sized > static_cast<std::uintmax_t>(INT32_MAX)) {
        return -1;
    }
    return static_cast<int>(*sized);
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
u_long128 *AlignCacheAddress(u_long128 *address) {
    std::uintptr_t value = reinterpret_cast<std::uintptr_t>(address);
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

void BuildIndex(const fs::path &root) {
    file_index.clear();
    index_built = true;

    std::error_code error;
    if (!fs::is_directory(root, error)) {
        std::fprintf(stderr, "dataread: indexed 0 files under %s (not a directory)\n", PathsDisplay(root).c_str());
        return;
    }

    // The disc holds about 8.8k files; reserving up front avoids rehashing while the index fills.
    file_index.reserve(kExpectedFiles);

    // A trailing separator would make lexically_relative climb out of the root.
    fs::path base = root.has_filename() ? root : root.parent_path();
    fs::recursive_directory_iterator it(root,
                                        fs::directory_options::follow_directory_symlink |
                                            fs::directory_options::skip_permission_denied,
                                        error);
    for (const fs::recursive_directory_iterator end; !error && it != end; it.increment(error)) {
        const fs::directory_entry &entry = *it;
        if (it.depth() == 0 && IsExcludedRootName(PathsDisplay(entry.path().filename()))) {
            it.disable_recursion_pending();
            continue;
        }
        std::error_code entry_error;
        if (!entry.is_regular_file(entry_error) || entry_error) {
            continue;
        }
        std::string relative = entry.path().lexically_relative(base).generic_string();
        std::string key;
        key.reserve(relative.size());
        for (char c : relative) {
            key.push_back(FoldChar(c));
        }
        const auto replacement = datapacks::Resolve(fs::path(relative));
        file_index.insert_or_assign(std::move(key), IndexedFile{replacement.value_or(entry.path()), replacement.has_value()});
    }

    if (error) {
        std::fprintf(stderr, "dataread: walking %s stopped: %s\n", PathsDisplay(root).c_str(), error.message().c_str());
    }
    std::fprintf(stderr, "dataread: indexed %zu files under %s\n", file_index.size(), PathsDisplay(root).c_str());
}

} // namespace

void DataReadIndex(const fs::path &root) {
    TextureSourceClear();
    std::string error;
    const fs::path data_root = root.has_filename() ? root : root.parent_path();
    const fs::path catalog = data_root.parent_path() / "port_data" / "catalog.json";
    if (!texture_catalog::Load(catalog, error) && fs::exists(catalog)) {
        std::fprintf(stderr, "dataread: %s\n", error.c_str());
    }
    datapacks::Load(catalog.parent_path());
    BuildIndex(root);
}

std::optional<fs::path> DataReadFind(const char *game_name) {
    if (!game_name) {
        return std::nullopt;
    }
    const IndexedFile *file = Lookup(IndexKey(game_name));
    if (!file) {
        return std::nullopt;
    }
    return file->path;
}

std::vector<std::string> DataReadScriptKeys() {
    std::vector<std::string> keys;
    for (const auto &[key, file] : file_index) {
        if (key.ends_with(".stb")) {
            keys.push_back(key);
        }
    }
    std::sort(keys.begin(), keys.end());
    return keys;
}

ScriptTimingValidation DataReadValidateScriptTiming() {
    ScriptTimingValidation report;
    const auto                 start = std::chrono::steady_clock::now();
    const auto                 keys = DataReadScriptKeys();
    std::vector<unsigned char> bytes;
    script_timing::Options     options;
    options.write = false;
    for (const std::string &key : keys) {
        report.files++;
        const IndexedFile &file = file_index.at(key);
        const auto         size = FileSize(file);
        std::string        error;
        if (!size || *size > static_cast<std::uintmax_t>(INT32_MAX)) {
            error = "cannot read script size";
        } else {
            bytes.resize(std::max(kSector, PaddedSize(static_cast<std::size_t>(*size))));
            const int read = ReadWhole(file, bytes.data());
            if (read < 0) {
                error = "cannot read script";
            } else {
                const auto result = script_timing::Apply(key, bytes.data(), static_cast<std::size_t>(read), options);
                if (!result.ok) {
                    error = result.error;
                } else if (!result.decoded && undecoded_script_warnings.insert(key).second) {
                    std::fprintf(stderr, "script timing startup: warning: %s is an unlisted, undecodable script; leaving it unchanged (%s)\n",
                                 key.c_str(), result.error.c_str());
                }
            }
        }
        if (!error.empty()) {
            report.errors.push_back(key + (file.replaced ? " [datapack]: " : ": ") + error);
        }
    }
    report.seconds = std::chrono::duration<double>(std::chrono::steady_clock::now() - start).count();
    return report;
}

bool DataReadPrepareScriptTiming(bool headless) {
    const auto report = DataReadValidateScriptTiming();
    std::fprintf(stderr, "script timing startup: %zu scripts, %zu mismatches, %.3f seconds\n",
                 report.files, report.errors.size(), report.seconds);
    if (report.errors.empty()) {
        return true;
    }
    std::string message = "These scripts cannot use NTSC gameplay timing:\n\n";
    for (std::size_t i = 0; i < report.errors.size(); ++i) {
        std::fprintf(stderr, "script timing startup: %s\n", report.errors[i].c_str());
        if (i < 8) {
            message += report.errors[i] + "\n";
        }
    }
    if (report.errors.size() > 8) {
        message += "\nAdditional mismatches are listed in the log.\n";
    }
    std::fprintf(stderr, "script timing startup: NTSC timing unavailable; refusing startup\n");
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

PORT_OVERRIDE void SetCurrentDir(char *dir) {
    if (!dir) {
        current_dir.clear();
        return;
    }
    if (*dir == '/') {
        dir++;
    }
    current_dir = dir;
}

PORT_OVERRIDE void GetCurrentDir(char *out_dir) {
    std::memcpy(out_dir, current_dir.c_str(), current_dir.size() + 1);
}

PORT_OVERRIDE void ChangeDir(char *dir) {
    current_dir.clear();
    if (dir) {
        if (*dir == '/') {
            dir++;
        }
        current_dir += dir;
    }
}

PORT_OVERRIDE void InitReadBG() {
    for (BG_READ_INFO &info : bg_slots) {
        info.busy = 0;
    }
}

// The copy happens now, but the slot stays pending so callers polling ReadBGSync see retail's issue and
// complete states.
PORT_OVERRIDE int LoadFileBG(char *name, u_long128 *buffer, int *out_size) {
    if (out_size) {
        *out_size = 0;
    }
    if (!name || *name == '\0' || !buffer) {
        return 0;
    }
    TextureSourceForget(buffer);

    BG_READ_INFO *info = BgFreeSlot();
    if (!info) {
        return 0;
    }

    int size = 0;

    if (CacheSlot *cached = CacheFind(CacheKey(name))) {
        std::memcpy(buffer, cached->address, static_cast<std::size_t>(cached->size));
        TextureSourceCopy(cached->address, buffer, static_cast<std::size_t>(cached->size));
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
// visible until StartReadBG; kept as it is.
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
        std::fprintf(stderr, "File open error \"%s\"\n \n \n", path);
        Exit(0);
    }
    return 1;
}

PORT_OVERRIDE int LoadFile2(char *path, void *buffer, int *out_size, int mode) {
    if (out_size) {
        *out_size = 0;
    }
    if (!path || *path == '\0' || (mode != LOAD_FILE_SIZE && !buffer)) {
        return 0;
    }
    if (mode != LOAD_FILE_SIZE) {
        TextureSourceForget(buffer);
    }

    if (CacheSlot *cached = CacheFind(CacheKey(path))) {
        if (mode != LOAD_FILE_SIZE) {
            std::memcpy(buffer, cached->address, static_cast<std::size_t>(cached->size));
            TextureSourceCopy(cached->address, buffer, static_cast<std::size_t>(cached->size));
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
    TextureSourceRegister(cached->address, IndexKey(path), static_cast<std::size_t>(cached->size));
    return cached->address;
}

// Writes go through the host file server, which maps host0: to the save root.
PORT_OVERRIDE int WriteFile(char *path, void *buffer, int size) {
    if (!path || size < 0) {
        return 0;
    }
    if (std::string_view(path).starts_with("net:")) {
        std::fprintf(stderr, "dataread: no network socket on the host, not writing %s\n", path);
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
