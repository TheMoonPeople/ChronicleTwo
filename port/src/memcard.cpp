#include "memcard.hpp"

#include <algorithm>
#include <cstring>
#include <limits>
#include <memory>

#include "inventmn.hpp"
#include "mainloop.hpp"
#include "platform/files.hpp"
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
} // namespace

CMemoryCardManager *SaveSlotManager() { return active_manager; }

PORT_OVERRIDE void SetDngTreeFlag(int flag) { dungeon_tree_flag = flag; }

PORT_OVERRIDE int CMemoryCardManager::InitForMC() {
    active_manager = this;
    SaveSlotNew = false;
    return sceMcInit() == sceMcIniSucceed ? 0 : 1;
}

PORT_OVERRIDE int CMemoryCardManager::GetAllSaveFileInfo() {
    SaveSlots = SaveSlotScan();
    InitError();
    std::memset(file_info, 0, sizeof(file_info));
    // Retain the small compatibility view for non-menu retail callers. All save
    // selection, title unlocks and newest-save queries use the complete catalog.
    for (std::size_t i = 0; i < SaveSlots.saves.size() && i < MC_SAVE_FILE_NUM; ++i) {
        file_info[i] = SaveSlots.saves[i].info;
    }
    if (SaveSlots.read_failed) {
        error.code = MC_ERROR_FILE;
    }
    total_transferred = 0;
    return MC_STEP_DONE;
}

PORT_OVERRIDE unsigned long long CMemoryCardManager::CheckMaxUniqueCounter() {
    unsigned long long newest = 0;
    for (const auto &slot : SaveSlots.saves) {
        if (slot.state == SaveSlotState::Ready && slot.info.state) {
            newest = std::max(newest, slot.info.unique_counter);
        }
    }
    return newest;
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
        (!SaveSlotNew && row >= static_cast<int>(SaveSlots.saves.size()))) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    if (FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }

    auto &image = *save_buffer;
    auto &save = *GetSaveData();
    // The port's existing save image, unchanged: no PC metadata is embedded in
    // the payload. Publish it only after the complete header and digits exist.
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
    auto newest = CheckMaxUniqueCounter();
    image.unique_counter = newest == std::numeric_limits<unsigned long long>::max() ? newest : newest + 1;
    image.progress = save.game_progress;
    image.fish_num = save.user_data.CountFish();
    image.program_loop_no = NowProgramLoopNo;
    image.map_no = save.map_no;
    image.dungeon_no = save.save_dungeon.stage_id;
    if (image.dungeon_no >= 0 && image.dungeon_no < SAVE_DUNGEON_NUM) {
        image.floor_id = save.save_dungeon.floor_id[image.dungeon_no];
    }
    image.check_digit_half = Digit(image.save_data, sizeof(CSaveData) / 2);
    image.check_digit = Digit(image.save_data, sizeof(CSaveData));

    std::filesystem::path path;
    FilesResult           result = FilesResult::kFailed;
    if (SaveSlotNew) {
        // Rescan at publication, and still use no-replace: a competing process
        // cannot turn New Save into an unconfirmed overwrite.
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
            result = SaveSlotWrite(path, image, false);
            if (result != FilesResult::kExists) {
                break;
            }
        }
    } else {
        const auto &slot = SaveSlots.saves[row];
        path = SaveSlotPath(slot.number, slot.second_card);
        // Failed imports can still be loaded and explicitly replaced, but the
        // original card payload is never modified.
        result = SaveSlotWrite(slot, image);
    }
    SaveSlotNew = false;
    if (result != FilesResult::kWritten) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    GetAllSaveFileInfo();
    // Publication has succeeded durably. A catalog refresh error describes the
    // listing, not the write that just completed.
    InitError();
    for (std::size_t i = 0; i < SaveSlots.saves.size(); ++i) {
        if (SaveSlots.saves[i].path == path) {
            file_no = static_cast<int>(i);
        }
    }
    total_transferred = transferred = sizeof(image);
    return MC_STEP_DONE;
}

PORT_OVERRIDE int CMemoryCardManager::LoadFromMc(int row) {
    InitError();
    total_transferred = transferred = 0;
    auto image = std::make_unique<SAVEDATA_FORMAT>();
    if (row < 0 || row >= static_cast<int>(SaveSlots.saves.size()) ||
        SaveSlotRead(SaveSlots.saves[row].path, *image) != SaveSlotState::Ready) {
        error.code = MC_ERROR_LOAD;
        return MC_STEP_DONE;
    }
    // Validate every byte before touching live game state. The retail photo
    // address rebinding still runs when its menu opens.
    auto *save = GetSaveData();
    std::memcpy(save, &image->save_data, sizeof(*save));
    if (std::memcmp(image->version, "dc2Ver2", 8) == 0) {
        TranslateInventUserData(image->save_data.GetUserDataManager()->GetInventUserData(),
                                save->GetUserDataManager()->GetInventUserData());
    }
    load_program_loop_no = image->program_loop_no;
    load_map_no = image->map_no;
    load_dungeon_no = image->dungeon_no;
    load_floor_id = image->floor_id;
    load_dng_tree_flag = image->dng_tree_flag;
    if (save->tour.base_day <= 0 && save->GetBitFlag(SAVE_FLAG_FISHING_CONTEST_UNLOCKED)) {
        save->tour.base_day = 7;
    }
    total_transferred = transferred = sizeof(*image);
    return MC_STEP_DONE;
}
