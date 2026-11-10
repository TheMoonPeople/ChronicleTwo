#pragma once

#include <filesystem>
#include <functional>
#include <optional>
#include <set>
#include <string>
#include <vector>

#include "memcard.hpp"
#include "platform/files.hpp"
#include "save_json.hpp"

enum class SaveSlotState {
    Ready,
    Unreadable,
    WrongSize,
    WrongVersion,
    Incomplete,
    BadChecksum,
    Invalid
};

struct SaveSlot {
    int                   number = 0; // Retail file number, from zero; independent of the row in the list.
    bool                  second_card = false;
    bool                  autosave = false;
    std::filesystem::path path;
    SaveSlotState         state = SaveSlotState::Unreadable;
    SAVEDATA_INFO         info = {};
};

struct SaveSlotList {
    std::vector<SaveSlot> saves;
    // Includes unreadable save names and the legacy images, flat or on either card, not yet converted.
    std::set<int> occupied;
    int           first_free = 0;
    bool          read_failed = false;
};

extern SaveSlotList SaveSlots;
extern bool         SaveSlotNew;

/**
 * Replaces or clears the validated spawn awaiting the town's first controllable frame.
 */
void SaveSlotSetPendingSpawn(std::optional<AutosaveSpawn> spawn);
/**
 * Consumes a pending spawn once, discarding it when the active map differs.
 */
std::optional<AutosaveSpawn> SaveSlotTakePendingSpawn(int map_no);

std::filesystem::path SaveSlotsRoot();
std::filesystem::path SaveSlotPath(int number, bool second_card = false);
std::filesystem::path SaveSlotAutosavePath();

/**
 * The file number of a save name or legacy save name, with or without the .json extension, or -1.
 */
int         SaveSlotNumber(const std::string &name, bool &second_card);
int         SaveSlotFirstFree(const SaveSlotList &list);
int         SaveSlotRows(const SaveSlotList &list, bool saving);
bool        SaveSlotIsNew(const SaveSlotList &list, int row, bool saving);
const char *SaveSlotStatus(SaveSlotState state);
/**
 * Reads a whole save: a JSON file, or a legacy image converted in memory.
 */
SaveSlotState SaveSlotRead(const std::filesystem::path &path, SaveDocument &document);
/**
 * Lists the saves, after converting each legacy image, flat or on a card, into a JSON file once.
 */
SaveSlotList SaveSlotScan(bool include_autosave = true);
/**
 * Refreshes the manager and its compatibility table with the requested save rows.
 */
int SaveSlotRefresh(CMemoryCardManager &manager, bool include_autosave);

// The manager initialized for the currently active menu. The catalog uses rows as
// operation IDs; display numbers and filenames are kept in SaveSlot, never in a
// retail fixed-size table.
CMemoryCardManager *SaveSlotManager();

FilesResult SaveSlotWrite(const std::filesystem::path &path, const SaveDocument &document, bool replace);

/**
 * Writes the current town save and optional spawn or the recorded dungeon floor-entry save, preserving the
 * previous autosave if writing fails or the dungeon floor has no recorded entry state.
 */
bool SaveSlotWriteAutosave(int program_loop_no, const AutosaveSpawn *spawn = nullptr);

/**
 * Keeps the whole save as it stands, the save data and every town's layout, as the current floor's entry state.
 * The floor load event (1010) calls DNG_FLOOR_INIT before any of the floor's own events, which is when the port
 * records it.
 */
void SaveSlotRecordFloorEntry();
/**
 * Drops the recorded floor entry state. Each game loop starts without one, and the floor's first controllable
 * frame drops it whether or not it was written.
 */
void SaveSlotForgetFloorEntry();
/**
 * Whether the recorded entry state belongs to the stage and floor the game is on.
 */
bool SaveSlotHasFloorEntry();

// A legacy row publishes a new JSON file, then attempts to archive its original.
FilesResult SaveSlotWrite(const SaveSlot &slot, const SaveDocument &document);

// Deterministic filesystem interleavings for import regressions. An empty hook
// uses the OS operations; false models a reported failure at that boundary.
enum class SaveSlotImportStage {
    Published,
    BeforeArchive,
    Archived
};
using SaveSlotImportHook = std::function<bool(SaveSlotImportStage, const std::filesystem::path &, const std::filesystem::path &)>;
void SaveSlotSetImportHook(SaveSlotImportHook hook);
