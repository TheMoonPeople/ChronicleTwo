#include "memcard.hpp"

#include <algorithm>
#include <cstring>
#include <limits>
#include <memory>
#include <utility>

#include "mainloop.hpp"
#include "platform/files.hpp"
#include "platform/paths.hpp"
#include "play_time.hpp"
#include "save_slots.hpp"
#include "title.hpp"
#include "userdata.hpp"

namespace {
CMemoryCardManager *active_manager;
int                 dungeon_tree_flag;

int Digit(const CSaveData &save, std::size_t size) {
    const auto *bytes = reinterpret_cast<const unsigned char *>(&save);
    int         digit = 0;
    for (std::size_t i = 0; i < size / 64; ++i) {
        digit += bytes[i * 64] % 255;
    }
    return digit;
}

unsigned long long MaxUniqueCounter(const SaveSlotList &list) {
    unsigned long long newest = 0;
    for (const auto &slot : list.saves) {
        if (slot.state == SaveSlotState::Ready && slot.info.state) {
            newest = std::max(newest, slot.info.unique_counter);
        }
    }
    return newest;
}

// The current floor's entry state: the whole save as the floor's load event reached DNG_FLOOR_INIT, before any of
// the floor's own events. It owns its copy of every town's layout, as the live layouts are found by the address of
// the live save's town records.
std::unique_ptr<SaveDocument> floor_entry;

// The stage and floor a save is on, or -1 for the floor when its stage is out of range.
std::pair<int, int> FloorOf(const CSaveData &save) {
    const auto &dungeon = save.save_dungeon;
    if (dungeon.stage_id < 0 || dungeon.stage_id >= SAVE_DUNGEON_NUM) {
        return {dungeon.stage_id, -1};
    }
    return {dungeon.stage_id, dungeon.floor_id[dungeon.stage_id]};
}

// Builds the retail save image; no PC metadata is embedded in the payload.
void BuildImage(SAVEDATA_FORMAT &image, int program_loop_no, unsigned long long newest) {
    auto &save = *GetSaveData();
    std::memset(&image, 0, sizeof(image));
    std::strcpy(image.version, "dc2Ver4");
    std::memcpy(&image.save_data, &save, sizeof(save));
    if (save.GetBitFlag(SAVE_FLAG_COSTUME_UNLOCK)) {
        image.costume_bit = save.user_data.GetCostumeBit();
        image.omake_flag |= OMAKE_ENABLE_COSTUME | OMAKE_ENABLE_DUNGEON;
    }
    if (save.GetBitFlag(SAVE_FLAG_FINNY_FRENZY_UNLOCKED)) {
        image.omake_flag |= OMAKE_ENABLE_GYORACE;
    }
    image.dng_tree_flag = dungeon_tree_flag;
    image.unique_counter = newest == std::numeric_limits<unsigned long long>::max() ? newest : newest + 1;
    image.progress = save.game_progress;
    image.fish_num = save.user_data.CountFish();
    image.program_loop_no = program_loop_no;
    image.map_no = save.map_no;
    image.dungeon_no = save.save_dungeon.stage_id;
    if (image.dungeon_no >= 0 && image.dungeon_no < SAVE_DUNGEON_NUM) {
        image.floor_id = save.save_dungeon.floor_id[image.dungeon_no];
    }
    image.check_digit_half = Digit(image.save_data, sizeof(CSaveData) / 2);
    image.check_digit = Digit(image.save_data, sizeof(CSaveData));
}

// Every save's, the autosave's included, so that the newest save is the one written last.
u64 NewestCounter() {
    return MaxUniqueCounter(SaveSlotScan(true));
}

// The game as it stands: the retail image and the layouts the towns keep beside their records.
std::unique_ptr<SaveDocument> BuildDocument(int program_loop_no, unsigned long long newest) {
    auto document = std::make_unique<SaveDocument>();
    BuildImage(document->image, program_loop_no, newest);
    const auto &save = *GetSaveData();
    for (std::size_t i = 0; i < document->towns.size(); ++i) {
        if (const TownLayout *town = PortFindTownLayout(save.edit_data[i])) {
            document->towns[i] = *town;
        }
    }
    return document;
}
} // namespace

bool SaveSlotWriteAutosave(int program_loop_no, const AutosaveSpawn *spawn) {
    if ((program_loop_no != LOOP_EDIT && program_loop_no != LOOP_DUNGEON) ||
        FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        return false;
    }
    // A floor's events can change flags whose effects live only in the running floor (a boss that an arrival
    // scene sets loose, say). The floor load event that loading runs replays those events only from the
    // state before them, so a dungeon autosave is the game as the floor's load event began.
    if (program_loop_no == LOOP_DUNGEON && !SaveSlotHasFloorEntry()) {
        return false;
    }
    const auto list = SaveSlotScan(true);
    const auto newest = MaxUniqueCounter(list);
    if (list.read_failed || newest == std::numeric_limits<u64>::max()) {
        return false;
    }
    if (program_loop_no == LOOP_DUNGEON) {
        // Only the counter belongs to the write; the save data, the towns' layouts and the header are the entry's.
        floor_entry->image.unique_counter = newest + 1;
        return SaveSlotWrite(SaveSlotAutosavePath(), *floor_entry, true) == FilesResult::kWritten;
    }
    auto document = BuildDocument(program_loop_no, newest);
    if (spawn != nullptr) {
        if (spawn->map_no != document->image.map_no) {
            return false;
        }
        document->spawn = *spawn;
        document->spawn->counter = document->image.unique_counter;
    }
    return SaveSlotWrite(SaveSlotAutosavePath(), *document, true) == FilesResult::kWritten;
}

void SaveSlotRecordFloorEntry() {
    if (GetSaveData() == nullptr) {
        floor_entry.reset();
        return;
    }
    floor_entry = BuildDocument(LOOP_DUNGEON, 0);
    // Loading resumes on the floor itself, never on the floor list.
    floor_entry->image.dng_tree_flag = 0;
}

void SaveSlotForgetFloorEntry() { floor_entry.reset(); }

bool SaveSlotHasFloorEntry() {
    const CSaveData *save = GetSaveData();
    if (!floor_entry || save == nullptr) {
        return false;
    }
    const auto floor = FloorOf(floor_entry->image.save_data);
    return floor.second >= 0 && floor == FloorOf(*save);
}

CMemoryCardManager *SaveSlotManager() { return active_manager; }

PORT_OVERRIDE void SetDngTreeFlag(int flag) { dungeon_tree_flag = flag; }

PORT_OVERRIDE int CMemoryCardManager::InitForMC() {
    active_manager = this;
    SaveSlotNew = false;
    // libmc reports the second card only once its folder exists. Creating it gives the photo album
    // and the Extras data two working slots, as with two inserted cards.
    FilesCreateDirectory(PathsSaveRoot() / "mc1");
    return sceMcInit() == sceMcIniSucceed ? 0 : 1;
}

PORT_OVERRIDE int CMemoryCardManager::GetAllSaveFileInfo() {
    return SaveSlotRefresh(*this, true);
}

int SaveSlotRefresh(CMemoryCardManager &manager, bool include_autosave) {
    SaveSlots = SaveSlotScan(include_autosave);
    manager.InitError();
    std::memset(manager.file_info, 0, sizeof(manager.file_info));
    // A compatibility view for non-menu retail callers; save selection, title unlocks and newest-save
    // queries use the complete catalog.
    for (std::size_t i = 0; i < SaveSlots.saves.size() && i < MC_SAVE_FILE_NUM; ++i) {
        manager.file_info[i] = SaveSlots.saves[i].info;
    }
    if (SaveSlots.read_failed) {
        manager.error.code = MC_ERROR_FILE;
    }
    manager.total_transferred = 0;
    return MC_STEP_DONE;
}

PORT_OVERRIDE unsigned long long CMemoryCardManager::CheckMaxUniqueCounter() {
    return MaxUniqueCounter(SaveSlots);
}

PORT_OVERRIDE int CMemoryCardManager::GetUpdateFile() {
    int                row = -1;
    unsigned long long newest = 0;
    for (std::size_t i = 0; i < SaveSlots.saves.size(); ++i) {
        const auto &slot = SaveSlots.saves[i];
        if (slot.state == SaveSlotState::Ready && slot.info.state && (row < 0 || slot.info.unique_counter > newest)) {
            row = static_cast<int>(i);
            newest = slot.info.unique_counter;
        }
    }
    return row;
}

PORT_OVERRIDE int CMemoryCardManager::CheckDataFileNum() {
    return static_cast<int>(std::count_if(SaveSlots.saves.begin(), SaveSlots.saves.end(),
                                          [](const SaveSlot &slot) { return slot.state == SaveSlotState::Ready; }));
}

PORT_OVERRIDE u32 CMemoryCardManager::CheckOmake(u_long *out_mask) {
    unsigned int flags = 0;
    for (const auto &slot : SaveSlots.saves) {
        if (slot.state != SaveSlotState::Ready || !slot.info.state) {
            continue;
        }
        flags |= slot.info.omake_flag;
        if (out_mask) {
            *out_mask |= slot.info.costume_bit;
        }
    }
    return flags;
}

PORT_OVERRIDE int CMemoryCardManager::CheckDebugCode() {
    int code = 0;
    for (const auto &slot : SaveSlots.saves) {
        if (slot.state == SaveSlotState::Ready && slot.info.state && slot.info.debug_code > 0) {
            code = slot.info.debug_code;
        }
    }
    return code;
}

PORT_OVERRIDE int CMemoryCardManager::SaveToMc(int row) {
    InitError();
    total_transferred = transferred = 0;
    if (!save_buffer || SaveSlots.read_failed || row < 0 ||
        (!SaveSlotNew && std::cmp_greater_equal(row, SaveSlots.saves.size()))) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    if ((!SaveSlotNew && SaveSlots.saves[row].autosave) ||
        FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }

    // A confirmed overwrite stays valid even when an unrelated legacy-card root is unreadable.
    const auto newest = std::max(CheckMaxUniqueCounter(), NewestCounter());
    if (newest == std::numeric_limits<u64>::max()) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    const auto document = BuildDocument(NowProgramLoopNo, newest);
    std::memcpy(static_cast<void *>(save_buffer), &document->image, sizeof(*save_buffer));

    std::filesystem::path path;
    FilesResult           result = FilesResult::kFailed;
    if (SaveSlotNew) {
        // Rescan and write without replacing, so a competing process cannot turn New Save into an
        // unconfirmed overwrite.
        for (int attempt = 0; attempt < 100; ++attempt) {
            auto current = SaveSlotScan();
            if (current.read_failed) {
                break;
            }
            int number = SaveSlotFirstFree(current);
            if (number < 0) {
                break;
            }
            path = SaveSlotPath(number);
            result = SaveSlotWrite(path, *document, false);
            if (result != FilesResult::kExists) {
                break;
            }
        }
    } else {
        const auto &slot = SaveSlots.saves[row];
        path = SaveSlotPath(slot.number, slot.second_card);
        // A legacy row can still be replaced, but the original image is never modified.
        result = SaveSlotWrite(slot, *document);
    }
    SaveSlotNew = false;
    if (result != FilesResult::kWritten) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    SaveSlotRefresh(*this, false);
    // A refresh error describes the listing, not the write that succeeded.
    InitError();
    for (std::size_t i = 0; i < SaveSlots.saves.size(); ++i) {
        if (SaveSlots.saves[i].path == path) {
            file_no = static_cast<int>(i);
        }
    }
    total_transferred = transferred = sizeof(*save_buffer);
    return MC_STEP_DONE;
}

PORT_OVERRIDE int CMemoryCardManager::LoadFromMc(int row) {
    InitError();
    total_transferred = transferred = 0;
    SaveSlotSetPendingSpawn(std::nullopt);
    auto document = std::make_unique<SaveDocument>();
    if (row < 0 || std::cmp_greater_equal(row, SaveSlots.saves.size()) ||
        SaveSlotRead(SaveSlots.saves[row].path, *document) != SaveSlotState::Ready) {
        error.code = MC_ERROR_LOAD;
        return MC_STEP_DONE;
    }
    // SaveSlotRead has validated and converted the save; the retail photo address rebinding runs when its menu opens.
    const auto &image = document->image;
    auto       *save = GetSaveData();
    std::memcpy(static_cast<void *>(save), &image.save_data, sizeof(*save));
    for (std::size_t i = 0; i < document->towns.size(); ++i) {
        PortTownLayout(save->edit_data[i]) = std::move(document->towns[i]);
    }
    load_program_loop_no = image.program_loop_no;
    load_map_no = image.map_no;
    load_dungeon_no = image.dungeon_no;
    load_floor_id = image.floor_id;
    load_dng_tree_flag = image.dng_tree_flag;
    if (SaveSlots.saves[row].autosave && image.program_loop_no == LOOP_EDIT && document->spawn &&
        document->spawn->map_no == image.map_no) {
        SaveSlotSetPendingSpawn(document->spawn);
    }
    if (save->tour.base_day <= 0 && save->GetBitFlag(SAVE_FLAG_FISHING_CONTEST_UNLOCKED)) {
        save->tour.base_day = 7;
    }
    PlayTimeReset();
    total_transferred = transferred = sizeof(image);
    return MC_STEP_DONE;
}
