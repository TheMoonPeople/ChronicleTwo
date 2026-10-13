#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define RECT WindowsRect
#include <windows.h>
#undef RECT
#else
#include <fcntl.h>
#include <unistd.h>
#ifdef __linux__
#include <sys/syscall.h>
#endif
#endif

#include <algorithm>
#include <array>
#include <cerrno>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <map>
#include <memory>
#include <set>

#include "platform/files.hpp"
#include "platform/paths.hpp"
#include "save_slots.hpp"

namespace fs = std::filesystem;

SaveSlotList SaveSlots;
bool         SaveSlotNew = false;

namespace {
constexpr char     kPrefix[] = "BESCES-51190dkcl";
constexpr char     kSecondCard[] = ".card2";
SaveSlotImportHook import_hook;

bool ImportStep(SaveSlotImportStage stage, const fs::path &from, const fs::path &to) {
    return !import_hook || import_hook(stage, from, to);
}

int CheckDigit(const char *bytes, std::size_t size) {
    int result = 0;
    for (std::size_t i = 0; i < size / 64; ++i) {
        result += static_cast<unsigned char>(bytes[i * 64]) % 255;
    }
    return result;
}

bool ListDirectory(const fs::path &path, std::vector<fs::path> &paths) {
    std::error_code        error;
    fs::directory_iterator iter(path, error), end;
    if (error == std::errc::no_such_file_or_directory) {
        return true;
    }
    if (error) {
        return false;
    }
    while (iter != end) {
        paths.push_back(iter->path());
        iter.increment(error);
        if (error) {
            return false;
        }
    }
    return true;
}

bool Import(const fs::path &from, const fs::path &to) {
    std::error_code error;
    if (!fs::is_regular_file(from, error)) {
        return false;
    }
    auto size = fs::file_size(from, error);
    // Large, unusable files remain visible at their original location. Reading a
    // malformed file must not exhaust memory while opening the menu.
    if (error || size > 16 * 1024 * 1024) {
        return false;
    }
    std::vector<char> bytes(static_cast<std::size_t>(size));
    if (FilesRead(from, bytes.data(), bytes.size()) != bytes.size()) {
        return false;
    }
    if (FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        return false;
    }
    return FilesWrite(to, bytes.data(), bytes.size(), false) == FilesResult::kWritten &&
           ImportStep(SaveSlotImportStage::Published, from, to);
}

enum class ByteComparison {
    Identical,
    Different,
    Unavailable
};

ByteComparison SameBytes(const fs::path &left, const fs::path &right) {
    std::error_code error;
    if (!fs::is_regular_file(left, error) || !fs::is_regular_file(right, error)) {
        return ByteComparison::Unavailable;
    }
    const auto size = fs::file_size(left, error);
    if (error) {
        return ByteComparison::Unavailable;
    }
    const auto other_size = fs::file_size(right, error);
    if (error) {
        return ByteComparison::Unavailable;
    }
    if (size != other_size) {
        return ByteComparison::Different;
    }
    std::ifstream a(left, std::ios::binary), b(right, std::ios::binary);
    if (!a || !b || !ImportStep(SaveSlotImportStage::Comparing, left, right)) {
        return ByteComparison::Unavailable;
    }
    std::array<char, 65536> x, y;
    for (std::uintmax_t remaining = size; remaining;) {
        const auto count = static_cast<std::streamsize>(std::min<std::uintmax_t>(remaining, x.size()));
        if (!a.read(x.data(), count) || !b.read(y.data(), count)) {
            return ByteComparison::Unavailable;
        }
        if (std::memcmp(x.data(), y.data(), static_cast<std::size_t>(count)) != 0) {
            return ByteComparison::Different;
        }
        remaining -= count;
    }
    return ByteComparison::Identical;
}

struct CachedHeader {
    std::uintmax_t     size;
    fs::file_time_type modified;
    SaveSlotState      state;
    SAVEDATA_INFO      info;
};

std::map<fs::path, CachedHeader> header_cache;

SaveSlotState ReadHeader(const fs::path &path, std::uintmax_t size, SAVEDATA_INFO &info) {
    if (size != sizeof(SAVEDATA_FORMAT)) {
        return SaveSlotState::WrongSize;
    }
    std::ifstream file(path, std::ios::binary);
    auto          image = std::make_unique<SAVEDATA_FORMAT>();
    // Read the retail header and only the two payload fields needed by the list.
    file.read(reinterpret_cast<char *>(image.get()), offsetof(SAVEDATA_FORMAT, save_data));
    file.seekg(offsetof(SAVEDATA_FORMAT, save_data) + offsetof(CSaveData, play_time));
    file.read(reinterpret_cast<char *>(&image->save_data.play_time), sizeof(image->save_data.play_time));
    file.seekg(offsetof(SAVEDATA_FORMAT, save_data) + offsetof(CSaveData, game_progress));
    file.read(reinterpret_cast<char *>(&image->save_data.game_progress), sizeof(image->save_data.game_progress));
    if (!file) {
        return SaveSlotState::Unreadable;
    }
    if (std::memcmp(image->version, "dc2Ver4", 8) != 0 &&
        std::memcmp(image->version, "dc2Ver2", 8) != 0) {
        return SaveSlotState::WrongVersion;
    }
    if (image->incomplete) {
        return SaveSlotState::Incomplete;
    }
    // Ver2 can be loaded and converted, but its raw header must not grant
    // unlocks, debug codes or newest-save priority before that conversion.
    info.state = std::memcmp(image->version, "dc2Ver4", 8) == 0 ? 1 : 0;
    info.map_no = image->map_no;
    info.program_loop_no = image->program_loop_no;
    info.dungeon_no = image->dungeon_no;
    info.floor_id = image->floor_id;
    info.progress = image->save_data.game_progress;
    info.play_time = image->save_data.play_time;
    info.unique_counter = info.state ? image->unique_counter : 0;
    info.omake_flag = info.state ? image->omake_flag : 0;
    info.costume_bit = info.state ? image->costume_bit : 0;
    info.debug_code = info.state ? image->debug_code : 0;
    info.fish_num = image->fish_num;
    return SaveSlotState::Ready;
}

SaveSlotState CachedInfo(const fs::path &path, SAVEDATA_INFO &info) {
    std::error_code error;
    if (!fs::is_regular_file(path, error)) {
        return SaveSlotState::Unreadable;
    }
    const auto size = fs::file_size(path, error);
    if (error) {
        return SaveSlotState::Unreadable;
    }
    const auto modified = fs::last_write_time(path, error);
    if (error) {
        return SaveSlotState::Unreadable;
    }
    const auto old = header_cache.find(path);
    if (old != header_cache.end() && old->second.size == size && old->second.modified == modified) {
        info = old->second.info;
        return old->second.state;
    }
    const auto state = ReadHeader(path, size, info);
    if (state != SaveSlotState::Unreadable) {
        header_cache[path] = {size, modified, state, info};
    }
    return state;
}

#ifndef _WIN32
bool SyncDirectory(const fs::path &path) {
    const int directory = open(path.c_str(), O_RDONLY | O_DIRECTORY | O_CLOEXEC);
    if (directory < 0) {
        return false;
    }
    int result;
    do {
        result = fsync(directory);
    } while (result != 0 && errno == EINTR);
    const bool synced = result == 0;
    return close(directory) == 0 && synced;
}
#endif

bool Archive(const fs::path &dir, bool second_card) {
    // Only the two archive parent directories are created. Entry contents move
    // as a whole, on the same filesystem, without a replace or delete fallback.
    const auto base = PathsSaveRoot() / "imported";
    const auto card = base / (second_card ? "mc1" : "mc0");
    if (FilesCreateDirectory(base) == FilesResult::kFailed ||
        FilesCreateDirectory(card) == FilesResult::kFailed) {
        return false;
    }
    for (unsigned suffix = 0;; ++suffix) {
        auto target = card / dir.filename();
        if (suffix) {
            target += "." + std::to_string(suffix);
        }
        if (!ImportStep(SaveSlotImportStage::BeforeArchive, dir, target)) {
            return false;
        }
#ifdef _WIN32
        const bool moved = MoveFileExW(dir.c_str(), target.c_str(), MOVEFILE_WRITE_THROUGH) != 0;
        const auto error = moved ? ERROR_SUCCESS : GetLastError();
        const bool exists = error == ERROR_FILE_EXISTS || error == ERROR_ALREADY_EXISTS;
#else
#if defined(__linux__) && defined(SYS_renameat2)
        const bool moved = syscall(SYS_renameat2, AT_FDCWD, dir.c_str(), AT_FDCWD, target.c_str(), 1) == 0;
#elif defined(__APPLE__)
        const bool moved = renamex_np(dir.c_str(), target.c_str(), RENAME_EXCL) == 0;
#else
        errno = ENOSYS;
        const bool moved = false;
#endif
        const bool exists = !moved && errno == EEXIST;
#endif
        if (exists) {
            continue;
        }
        if (!moved) {
            return false;
        }
        bool synced = ImportStep(SaveSlotImportStage::Archived, dir, target);
#ifndef _WIN32
        const bool source_synced = SyncDirectory(dir.parent_path());
        const bool target_synced = SyncDirectory(card);
        synced = synced && source_synced && target_synced;
#endif
        if (!synced) {
            std::fprintf(stderr, "save import: archive moved but directory sync failed: %s\n",
                         PathsDisplay(target).c_str());
        }
        // A reported sync failure after publication cannot roll back the move.
        // Both a persisted move and its pre-move state are recoverable on scan.
        return true;
    }
}

int FirstFree(const std::set<int> &occupied) {
    int number = 0;
    for (int used : occupied) {
        if (used == number) {
            ++number;
        } else if (used > number) {
            break;
        }
    }
    return number < 1000000000 ? number : -1;
}
} // namespace

fs::path SaveSlotsRoot() { return PathsSaveRoot() / "saves"; }

fs::path SaveSlotPath(int number, bool second_card) {
    return SaveSlotsRoot() / (std::string(kPrefix) + std::to_string(number) + (second_card ? kSecondCard : ""));
}

int SaveSlotNumber(const std::string &name, bool &second_card) {
    std::string_view text(name);
    second_card = text.ends_with(kSecondCard);
    if (second_card) {
        text.remove_suffix(sizeof(kSecondCard) - 1);
    }
    if (!text.starts_with(kPrefix)) {
        return -1;
    }
    text.remove_prefix(sizeof(kPrefix) - 1);
    if (text.empty() || text.size() > 9 || (text.size() > 1 && text.front() == '0')) {
        return -1;
    }
    int number = 0;
    for (char c : text) {
        if (c < '0' || c > '9') {
            return -1;
        }
        number = number * 10 + c - '0';
    }
    return number;
}

int SaveSlotFirstFree(const SaveSlotList &list) {
    return list.first_free;
}

int SaveSlotRows(const SaveSlotList &list, bool saving) {
    return static_cast<int>(list.saves.size()) + (saving && list.first_free >= 0 ? 1 : 0);
}

bool SaveSlotIsNew(const SaveSlotList &list, int row, bool saving) {
    return saving && list.first_free >= 0 && row == static_cast<int>(list.saves.size());
}

const char *SaveSlotStatus(SaveSlotState state) {
    switch (state) {
        case SaveSlotState::Ready:
            return "";
        case SaveSlotState::Unreadable:
            return "Cannot read save";
        case SaveSlotState::WrongSize:
            return "Unusable save (size)";
        case SaveSlotState::WrongVersion:
            return "Unsupported save version";
        case SaveSlotState::Incomplete:
            return "Incomplete save";
        case SaveSlotState::BadChecksum:
            return "Corrupt save";
    }
    return "Unusable save";
}

SaveSlotState SaveSlotRead(const fs::path &path, SAVEDATA_FORMAT &image) {
    std::error_code error;
    if (!fs::is_regular_file(path, error)) {
        return SaveSlotState::Unreadable;
    }
    auto size = fs::file_size(path, error);
    if (error) {
        return SaveSlotState::Unreadable;
    }
    if (size != sizeof(image)) {
        return SaveSlotState::WrongSize;
    }
    if (FilesRead(path, &image, sizeof(image)) != sizeof(image)) {
        return SaveSlotState::Unreadable;
    }
    const bool old_version = std::memcmp(image.version, "dc2Ver2", 8) == 0;
    if (!old_version && std::memcmp(image.version, "dc2Ver4", 8) != 0) {
        return SaveSlotState::WrongVersion;
    }
    if (image.incomplete) {
        return SaveSlotState::Incomplete;
    }
    // Retail accepts Ver2 without check digits before converting its cards.
    if (old_version) {
        return SaveSlotState::Ready;
    }
    const char *data = reinterpret_cast<const char *>(&image.save_data);
    // Retail permits zero check digits in older images.
    if ((image.check_digit && image.check_digit != CheckDigit(data, sizeof(CSaveData))) ||
        (image.check_digit_half && image.check_digit_half != CheckDigit(data, sizeof(CSaveData) / 2))) {
        return SaveSlotState::BadChecksum;
    }
    return SaveSlotState::Ready;
}

SaveSlotList SaveSlotScan() {
    SaveSlotList                             list;
    std::map<std::pair<int, bool>, fs::path> entries;
    std::vector<fs::path>                    paths;
    list.read_failed = !ListDirectory(SaveSlotsRoot(), paths);
    for (const auto &path : paths) {
        bool second;
        int  number = SaveSlotNumber(path.filename().string(), second);
        if (number >= 0) {
            entries[{number, second}] = path;
            list.occupied.insert(number);
        }
    }
    std::vector<std::pair<fs::path, bool> > legacy;
    for (int card = 0; card < 2; ++card) {
        paths.clear();
        if (!ListDirectory(PathsSaveRoot() / (card ? "mc1" : "mc0"), paths)) {
            list.read_failed = true;
        }
        for (const auto &dir : paths) {
            bool second;
            int  number = SaveSlotNumber(dir.filename().string(), second);
            if (number < 0 || second) {
                continue;
            }
            list.occupied.insert(number);
            legacy.emplace_back(dir, card != 0);
        }
    }
    // Reserve every legacy name, including unavailable payloads, before
    // allocating collision numbers. The archive is never enumerated here.
    std::ranges::sort(legacy);
    for (const auto &[dir, second_card] : legacy) {
        bool       second;
        int        number = SaveSlotNumber(dir.filename().string(), second);
        auto       key = std::make_pair(number, second_card);
        const auto source = dir / dir.filename();
        // Search all flat saves, even if the original number is now free. A
        // previous copy whose archive move failed needs no second publication.
        bool copied = false, comparison_unavailable = false;
        for (const auto &[flat_key, path] : entries) {
            if (path.parent_path() != SaveSlotsRoot()) {
                continue;
            }
            std::error_code error;
            const auto      status = fs::status(path, error);
            if (error) {
                comparison_unavailable = true;
                continue;
            }
            if (!fs::is_regular_file(status)) {
                continue;
            }
            const auto comparison = SameBytes(source, path);
            if (comparison == ByteComparison::Identical) {
                copied = true;
                break;
            }
            comparison_unavailable |= comparison == ByteComparison::Unavailable;
        }
        // An unreadable possible match is not proof that another copy is
        // needed. Defer publication, keeping every existing file and source.
        if (!copied && !comparison_unavailable && !list.read_failed) {
            if (entries.contains(key)) {
                number = FirstFree(list.occupied);
                if (number < 0) {
                    continue;
                }
                key = {number, second_card};
                list.occupied.insert(number);
            }
            const auto target = SaveSlotPath(number, second_card);
            copied = Import(source, target);
            std::error_code error;
            // Publication may have succeeded before a reported sync failure,
            // or a competitor may have taken the name. Keep either file.
            if (fs::exists(target, error)) {
                entries[key] = target;
                header_cache.erase(target);
            }
        }
        if (copied && Archive(dir, second_card)) {
            continue;
        }
        // An unsuccessful move leaves a separate source-backed row. An
        // identical duplicate is safe, and the next scan retries only the move.
        if (entries.contains(key)) {
            number = FirstFree(list.occupied);
            if (number < 0) {
                continue;
            }
            key = {number, second_card};
            list.occupied.insert(number);
        }
        entries[key] = source;
    }
    std::set<fs::path> seen;
    for (const auto &[key, path] : entries) {
        SaveSlot slot;
        slot.number = key.first;
        slot.second_card = key.second;
        slot.path = path;
        seen.insert(path);
        slot.state = CachedInfo(path, slot.info);
        if (slot.state == SaveSlotState::Unreadable) {
            continue;
        }
        slot.info.file_no = slot.number;
        list.saves.push_back(slot);
    }
    std::erase_if(header_cache, [&](const auto &entry) { return !seen.contains(entry.first); });
    list.first_free = list.read_failed ? -1 : FirstFree(list.occupied);
    return list;
}

FilesResult SaveSlotWrite(const fs::path &path, const SAVEDATA_FORMAT &image, bool replace) {
    const auto result = FilesWrite(path, &image, sizeof(image), replace);
    if (result == FilesResult::kWritten) {
        header_cache.erase(path);
    }
    return result;
}

FilesResult SaveSlotWrite(const SaveSlot &slot, const SAVEDATA_FORMAT &image) {
    const auto target = SaveSlotPath(slot.number, slot.second_card);
    if (slot.path == target) {
        return SaveSlotWrite(target, image, true);
    }
    // A still-listed card row is replaced only through a new flat file. The
    // original whole entry remains recoverable even when its move fails.
    if (FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        return FilesResult::kFailed;
    }
    const auto result = SaveSlotWrite(target, image, false);
    if (result == FilesResult::kWritten) {
        Archive(slot.path.parent_path(), slot.second_card);
    }
    return result;
}

void SaveSlotSetImportHook(SaveSlotImportHook hook) {
    import_hook = std::move(hook);
}
