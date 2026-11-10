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
#include <cerrno>
#include <cmath>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <map>
#include <memory>
#include <ranges>
#include <set>
#include <string>
#include <string_view>
#include <tuple>
#include <utility>
#include <vector>

#include "inventmn.hpp"
#include "log/log.hpp"
#include "platform/files.hpp"
#include "platform/paths.hpp"
#include "save_slots.hpp"
#include "userdata.hpp"

namespace fs = std::filesystem;

SaveSlotList SaveSlots;
bool         SaveSlotNew = false;

namespace {
std::optional<AutosaveSpawn> pending_spawn;
constexpr char               kPrefix[] = "BESCES-51190dkcl";
constexpr char               kSecondCard[] = ".card2";
constexpr char               kJson[] = ".json";
constexpr char               kAutosave[] = "autosave";
constexpr char               kVersion2[] = "dc2Ver2";
constexpr char               kVersion4[] = "dc2Ver4";
SaveSlotImportHook           import_hook;

bool ValidSpawn(const AutosaveSpawn &spawn) {
    if (spawn.counter == 0 || spawn.map_no < 0 || spawn.map_no >= 256) {
        return false;
    }
    for (const auto *vector : {spawn.position, spawn.rotation, spawn.camera_pos, spawn.camera_ref}) {
        if (!std::all_of(vector, vector + 4, [](float value) { return std::isfinite(value); })) {
            return false;
        }
    }
    return true;
}

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
    fs::directory_iterator iter(path, error);
    fs::directory_iterator end;
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

bool IsJson(const fs::path &path) {
    return path.extension() == kJson;
}

SaveSlotState JsonState(SaveJsonError error) {
    switch (error) {
        case SaveJsonError::None:
            return SaveSlotState::Ready;
        case SaveJsonError::UnsupportedVersion:
            return SaveSlotState::WrongVersion;
        case SaveJsonError::BadChecksum:
            return SaveSlotState::BadChecksum;
        case SaveJsonError::NotJson:
        case SaveJsonError::WrongSchema:
        case SaveJsonError::BadValue:
            break;
    }
    return SaveSlotState::Invalid;
}

// Files too large to be a save are refused before they are read.
SaveSlotState ReadJsonText(const fs::path &path, std::uintmax_t size, std::string &text) {
    if (size > kSaveJsonMaxBytes) {
        return SaveSlotState::WrongSize;
    }
    text.resize(static_cast<std::size_t>(size));
    if (FilesRead(path, text.data(), text.size()) != text.size()) {
        return SaveSlotState::Unreadable;
    }
    return SaveSlotState::Ready;
}

// Reads a legacy image of the port's host layout and converts it as loading it would: a Ver2 image's cards through
// the retail routine, and the towns' layouts out of their records.
SaveSlotState ReadImage(const fs::path &path, std::uintmax_t size, SaveDocument &document) {
    if (size != sizeof(SAVEDATA_FORMAT)) {
        return SaveSlotState::WrongSize;
    }
    auto image = std::make_unique<SAVEDATA_FORMAT>();
    if (FilesRead(path, image.get(), sizeof(*image)) != sizeof(*image)) {
        return SaveSlotState::Unreadable;
    }
    const bool old_version = std::memcmp(image->version, kVersion2, sizeof(kVersion2)) == 0;
    if (!old_version && std::memcmp(image->version, kVersion4, sizeof(kVersion4)) != 0) {
        return SaveSlotState::WrongVersion;
    }
    if (image->incomplete) {
        return SaveSlotState::Incomplete;
    }
    // Retail accepts Ver2 without check digits, and older images with zero digits.
    const char *data = reinterpret_cast<const char *>(&image->save_data);
    if (!old_version && ((image->check_digit && image->check_digit != CheckDigit(data, sizeof(CSaveData))) ||
                         (image->check_digit_half && image->check_digit_half != CheckDigit(data, sizeof(CSaveData) / 2)))) {
        return SaveSlotState::BadChecksum;
    }
    std::memcpy(static_cast<void *>(&document.image), image.get(), sizeof(*image));
    // A Ver2 header grants no unlocks, debug code or newest-save priority until the converted save is saved again.
    if (old_version) {
        TranslateInventUserData(image->save_data.GetUserDataManager()->GetInventUserData(),
                                document.image.save_data.GetUserDataManager()->GetInventUserData());
        std::memcpy(document.image.version, kVersion4, sizeof(kVersion4));
        document.image.unique_counter = 0;
        document.image.omake_flag = 0;
        document.image.costume_bit = 0;
        document.image.debug_code = 0;
    }
    for (std::size_t i = 0; i < document.towns.size(); ++i) {
        document.towns[i] = TownLayoutFromRecord(image->save_data.edit_data[i]);
        document.image.save_data.edit_data[i].InitPlaceData();
    }
    for (auto &photo : document.image.save_data.GetUserDataManager()->GetInventUserData()->photo) {
        photo.image = nullptr;
    }
    document.spawn.reset();
    return SaveSlotState::Ready;
}

SaveSlotState ReadImageHeader(const fs::path &path, std::uintmax_t size, SAVEDATA_INFO &info) {
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
    if (std::memcmp(image->version, kVersion4, sizeof(kVersion4)) != 0 &&
        std::memcmp(image->version, kVersion2, sizeof(kVersion2)) != 0) {
        return SaveSlotState::WrongVersion;
    }
    if (image->incomplete) {
        return SaveSlotState::Incomplete;
    }
    // Ver2 can be loaded and converted, but its raw header must not grant
    // unlocks, debug codes or newest-save priority before that conversion.
    info.state = std::memcmp(image->version, kVersion4, sizeof(kVersion4)) == 0 ? 1 : 0;
    info.map_no = static_cast<s16>(image->map_no);
    info.program_loop_no = static_cast<s16>(image->program_loop_no);
    info.dungeon_no = static_cast<s16>(image->dungeon_no);
    info.floor_id = static_cast<s16>(image->floor_id);
    info.progress = static_cast<s16>(image->save_data.game_progress);
    info.play_time = image->save_data.play_time;
    info.unique_counter = info.state ? image->unique_counter : 0;
    info.omake_flag = info.state ? image->omake_flag : 0;
    info.costume_bit = info.state ? image->costume_bit : 0;
    info.debug_code = info.state ? image->debug_code : 0;
    info.fish_num = image->fish_num;
    return SaveSlotState::Ready;
}

SaveSlotState ReadHeader(const fs::path &path, std::uintmax_t size, SAVEDATA_INFO &info) {
    if (!IsJson(path)) {
        return ReadImageHeader(path, size, info);
    }
    std::string text;
    if (const auto state = ReadJsonText(path, size, text); state != SaveSlotState::Ready) {
        return state;
    }
    return JsonState(SaveJsonReadHeader(text, info));
}

struct CachedHeader {
    std::uintmax_t     size{};
    fs::file_time_type modified;
    SaveSlotState      state{};
    SAVEDATA_INFO      info{};
};

std::map<fs::path, CachedHeader> header_cache;

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
        header_cache[path] = {.size = size, .modified = modified, .state = state, .info = info};
    }
    return state;
}

#ifndef _WIN32
bool SyncDirectory(const fs::path &path) {
    const int directory = open(path.c_str(), O_RDONLY | O_DIRECTORY | O_CLOEXEC);
    if (directory < 0) {
        return false;
    }
    int result = {};
    do {
        result = fsync(directory);
    } while (result != 0 && errno == EINTR);
    const bool synced = result == 0;
    return close(directory) == 0 && synced;
}
#endif

/**
 * A legacy save: a flat image in saves/, or the payload of an entry on a card.
 */
struct LegacySave {
    fs::path source;      /**< The image itself. */
    int      number{};    /**< File number of its name. */
    bool     second_card; /**< From mc1, or named as from it. */

    [[nodiscard]] bool Flat() const {
        return source.parent_path() == SaveSlotsRoot();
    }

    // A flat image moves alone; a card entry moves whole, icons included.
    [[nodiscard]] fs::path Moved() const {
        return Flat() ? source : source.parent_path();
    }

    [[nodiscard]] std::string_view Group() const {
        if (Flat()) {
            return "flat";
        }
        return second_card ? "mc1" : "mc0";
    }
};

bool Archive(const LegacySave &legacy) {
    // Only the archive directories are created. Originals move whole, on the same filesystem, without a replace or
    // delete fallback.
    const auto base = PathsSaveRoot() / "imported";
    const auto group = base / legacy.Group();
    const auto moved = legacy.Moved();
    if (FilesCreateDirectory(base) == FilesResult::kFailed || FilesCreateDirectory(group) == FilesResult::kFailed) {
        return false;
    }
    for (unsigned suffix = 0;; ++suffix) {
        auto target = group / moved.filename();
        if (suffix) {
            target += "." + std::to_string(suffix);
        }
        if (!ImportStep(SaveSlotImportStage::BeforeArchive, moved, target)) {
            return false;
        }
#ifdef _WIN32
        const bool done = MoveFileExW(moved.c_str(), target.c_str(), MOVEFILE_WRITE_THROUGH) != 0;
        const auto error = done ? ERROR_SUCCESS : GetLastError();
        const bool exists = error == ERROR_FILE_EXISTS || error == ERROR_ALREADY_EXISTS;
#else
#if defined(__linux__) && defined(SYS_renameat2)
        const bool done = syscall(SYS_renameat2, AT_FDCWD, moved.c_str(), AT_FDCWD, target.c_str(), 1) == 0;
#elif defined(__APPLE__)
        const bool done = renamex_np(moved.c_str(), target.c_str(), RENAME_EXCL) == 0;
#else
        errno = ENOSYS;
        const bool done = false;
#endif
        const bool exists = !done && errno == EEXIST;
#endif
        if (exists) {
            continue;
        }
        if (!done) {
            return false;
        }
        bool synced = ImportStep(SaveSlotImportStage::Archived, moved, target);
#ifndef _WIN32
        const bool source_synced = SyncDirectory(moved.parent_path());
        const bool target_synced = SyncDirectory(group);
        synced = synced && source_synced && target_synced;
#endif
        if (!synced) {
            CT_LOG_WARN(Save, "save import: archive moved but directory sync failed: {}", PathsDisplay(target));
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

/**
 * What the list shows of a converted save, to recognise it among the JSON saves.
 */
auto Identity(const SAVEDATA_INFO &info) {
    return std::tuple{info.unique_counter, info.play_time, info.progress, info.map_no, info.program_loop_no,
                      info.dungeon_no, info.floor_id, info.fish_num};
}

SAVEDATA_INFO ConvertedInfo(const SAVEDATA_FORMAT &image) {
    SAVEDATA_INFO info{};
    info.map_no = static_cast<s16>(image.map_no);
    info.program_loop_no = static_cast<s16>(image.program_loop_no);
    info.dungeon_no = static_cast<s16>(image.dungeon_no);
    info.floor_id = static_cast<s16>(image.floor_id);
    info.progress = static_cast<s16>(image.save_data.game_progress);
    info.play_time = image.save_data.play_time;
    info.unique_counter = image.unique_counter;
    info.fish_num = image.fish_num;
    return info;
}

/**
 * Whether a JSON save already holds a legacy save: one whose listed header is the converted save's.
 */
bool AlreadyConverted(const std::map<std::pair<int, bool>, fs::path> &entries, const SAVEDATA_INFO &converted) {
    return std::ranges::any_of(entries | std::views::values, [&](const fs::path &path) {
        SAVEDATA_INFO info{};
        return IsJson(path) && CachedInfo(path, info) == SaveSlotState::Ready && Identity(info) == Identity(converted);
    });
}

/**
 * Converts a legacy save into a new JSON save once and archives it; a legacy save that stays is listed itself.
 */
void ImportLegacy(const LegacySave &legacy, SaveSlotList &list, std::map<std::pair<int, bool>, fs::path> &entries) {
    auto document = std::make_unique<SaveDocument>();
    if (SaveSlotRead(legacy.source, *document) == SaveSlotState::Ready) {
        bool imported = AlreadyConverted(entries, ConvertedInfo(document->image));
        if (!imported && !list.read_failed) {
            auto key = std::make_pair(legacy.number, legacy.second_card);
            if (entries.contains(key)) {
                const int number = FirstFree(list.occupied);
                if (number < 0) {
                    return;
                }
                key.first = number;
                list.occupied.insert(number);
            }
            const auto target = SaveSlotPath(key.first, key.second);
            imported = FilesCreateDirectory(SaveSlotsRoot()) != FilesResult::kFailed &&
                       SaveSlotWrite(target, *document, false) == FilesResult::kWritten &&
                       ImportStep(SaveSlotImportStage::Published, legacy.source, target);
            std::error_code error;
            // Publication may have succeeded before a reported failure, or a competitor took the name. Keep either.
            if (fs::exists(target, error)) {
                entries[key] = target;
            }
        }
        if (imported && Archive(legacy)) {
            return;
        }
    }
    // An unconverted or unarchived legacy save stays a row of its own, at its number when that is free.
    auto key = std::make_pair(legacy.number, legacy.second_card);
    if (entries.contains(key)) {
        const int number = FirstFree(list.occupied);
        if (number < 0) {
            return;
        }
        key.first = number;
        list.occupied.insert(number);
    }
    entries[key] = legacy.source;
}

// The legacy autosave becomes the JSON autosave unless one exists, which is newer; either way it is archived.
void ImportLegacyAutosave() {
    const LegacySave legacy{.source = SaveSlotsRoot() / kAutosave, .number = -1, .second_card = false};
    std::error_code  error;
    if (!fs::is_regular_file(legacy.source, error)) {
        return;
    }
    if (!fs::exists(SaveSlotAutosavePath(), error)) {
        auto document = std::make_unique<SaveDocument>();
        if (SaveSlotRead(legacy.source, *document) != SaveSlotState::Ready ||
            SaveSlotWrite(SaveSlotAutosavePath(), *document, false) != FilesResult::kWritten) {
            return;
        }
    }
    Archive(legacy);
}
} // namespace

void SaveSlotSetPendingSpawn(std::optional<AutosaveSpawn> spawn) {
    pending_spawn = spawn && ValidSpawn(*spawn) ? spawn : std::nullopt;
}

std::optional<AutosaveSpawn> SaveSlotTakePendingSpawn(int map_no) {
    auto spawn = std::exchange(pending_spawn, std::nullopt);
    if (spawn && spawn->map_no == map_no) {
        return spawn;
    }
    return std::nullopt;
}

fs::path SaveSlotsRoot() { return PathsSaveRoot() / "saves"; }

fs::path SaveSlotPath(int number, bool second_card) {
    return SaveSlotsRoot() / (std::string(kPrefix) + std::to_string(number) + (second_card ? kSecondCard : "") + kJson);
}

fs::path SaveSlotAutosavePath() { return SaveSlotsRoot() / (std::string(kAutosave) + kJson); }

int SaveSlotNumber(const std::string &name, bool &second_card) {
    std::string_view text(name);
    if (text.ends_with(kJson)) {
        text.remove_suffix(sizeof(kJson) - 1);
    }
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
    return saving && list.first_free >= 0 && std::cmp_equal(row, list.saves.size());
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
        case SaveSlotState::Invalid:
            return "Unusable save (contents)";
    }
    return "Unusable save";
}

namespace {

SaveSlotState ReadDocument(const fs::path &path, SaveDocument &document) {
    std::error_code error;
    if (!fs::is_regular_file(path, error)) {
        return SaveSlotState::Unreadable;
    }
    const auto size = fs::file_size(path, error);
    if (error) {
        return SaveSlotState::Unreadable;
    }
    if (!IsJson(path)) {
        return ReadImage(path, size, document);
    }
    std::string text;
    if (const auto state = ReadJsonText(path, size, text); state != SaveSlotState::Ready) {
        return state;
    }
    return JsonState(SaveJsonRead(text, document));
}

} // namespace

SaveSlotState SaveSlotRead(const fs::path &path, SaveDocument &document) {
    const SaveSlotState state = ReadDocument(path, document);
    CT_LOG_DEBUG(Save, "save slots: read {}: {}", PathsDisplay(path),
                 state == SaveSlotState::Ready ? "ready" : SaveSlotStatus(state));
    return state;
}

SaveSlotList SaveSlotScan(bool include_autosave) {
    SaveSlotList                             list;
    std::map<std::pair<int, bool>, fs::path> entries;
    std::vector<LegacySave>                  legacy;
    std::vector<fs::path>                    paths;
    list.read_failed = !ListDirectory(SaveSlotsRoot(), paths);
    std::ranges::sort(paths);
    for (const auto &path : paths) {
        bool second = false;
        int  number = SaveSlotNumber(path.filename().string(), second);
        if (number < 0) {
            continue;
        }
        list.occupied.insert(number);
        if (IsJson(path)) {
            entries[{number, second}] = path;
        } else {
            legacy.push_back({.source = path, .number = number, .second_card = second});
        }
    }
    for (int card = 0; card < 2; ++card) {
        paths.clear();
        if (!ListDirectory(PathsSaveRoot() / (card ? "mc1" : "mc0"), paths)) {
            list.read_failed = true;
        }
        std::ranges::sort(paths);
        for (const auto &dir : paths) {
            bool second = false;
            int  number = SaveSlotNumber(dir.filename().string(), second);
            if (number < 0 || second || IsJson(dir)) {
                continue;
            }
            // Every legacy name reserves its number before any conversion picks one. The archive is never listed.
            list.occupied.insert(number);
            legacy.push_back({.source = dir / dir.filename(), .number = number, .second_card = card != 0});
        }
    }
    for (const auto &save : legacy) {
        ImportLegacy(save, list, entries);
    }
    ImportLegacyAutosave();
    std::set<fs::path> seen;
    if (include_autosave) {
        SaveSlot slot;
        slot.number = -1;
        slot.autosave = true;
        slot.path = SaveSlotAutosavePath();
        std::error_code error;
        if (!fs::exists(slot.path, error) && fs::exists(SaveSlotsRoot() / kAutosave, error)) {
            slot.path = SaveSlotsRoot() / kAutosave;
        }
        seen.insert(slot.path);
        slot.state = CachedInfo(slot.path, slot.info);
        if (slot.state != SaveSlotState::Unreadable) {
            slot.info.file_no = slot.number;
            list.saves.push_back(slot);
        }
    }
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

FilesResult SaveSlotWrite(const fs::path &path, const SaveDocument &document, bool replace) {
    const std::string text = SaveJsonWrite(document);
    const auto        result = FilesWrite(path, text.data(), text.size(), replace);
    if (result == FilesResult::kWritten) {
        header_cache.erase(path);
    }
    CT_LOG_DEBUG(Save, "save slots: write {}: {}", PathsDisplay(path),
                 result == FilesResult::kWritten ? "written" : "not written");
    return result;
}

FilesResult SaveSlotWrite(const SaveSlot &slot, const SaveDocument &document) {
    const auto target = SaveSlotPath(slot.number, slot.second_card);
    if (slot.path == target) {
        return SaveSlotWrite(target, document, true);
    }
    // A still-listed legacy row is replaced only through a new JSON file. The original remains recoverable even when
    // its move fails.
    if (FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        return FilesResult::kFailed;
    }
    const auto result = SaveSlotWrite(target, document, false);
    if (result == FilesResult::kWritten) {
        Archive({.source = slot.path, .number = slot.number, .second_card = slot.second_card});
    }
    return result;
}

void SaveSlotSetImportHook(SaveSlotImportHook hook) {
    import_hook = std::move(hook);
}
