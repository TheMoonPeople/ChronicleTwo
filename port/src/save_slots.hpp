#pragma once

#include <filesystem>
#include <functional>
#include <optional>
#include <set>
#include <string>
#include <vector>

#include "memcard.hpp"
#include "platform/files.hpp"

enum class SaveSlotState {
    Ready,
    Unreadable,
    WrongSize,
    WrongVersion,
    Incomplete,
    BadChecksum
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
    // Includes unreadable flat names and unarchived legacy entries from both cards.
    std::set<int> occupied;
    int           first_free = 0;
    bool          read_failed = false;
};

extern SaveSlotList SaveSlots;
extern bool         SaveSlotNew;

// Where the player stood when a town autosave was written. Retail saves hold only the map, and loading a town save
// starts at the map's save point, so the PC keeps the spot in a file beside the autosave, tied to it by its counter.
struct AutosaveSpawn {
    u64   counter = 0;
    int   map_no = -1;
    float position[4] = {};
    float rotation[4] = {};
    float camera_pos[4] = {};
    float camera_ref[4] = {};
};

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
std::filesystem::path SaveSlotAutosaveSpawnPath(u64 counter);

/**
 * Publishes validated town spawn metadata before its matching autosave image.
 */
bool SaveSlotWriteSpawn(const AutosaveSpawn &spawn);
/**
 * Reads finite, versioned spawn data belonging to the selected save image.
 */
std::optional<AutosaveSpawn> SaveSlotReadSpawn(u64 counter, int map_no);
/**
 * Removes obsolete spawn sidecars after an autosave has been published.
 */
void          SaveSlotPruneSpawns(std::optional<u64> keep);
int           SaveSlotNumber(const std::string &name, bool &second_card);
int           SaveSlotFirstFree(const SaveSlotList &list);
int           SaveSlotRows(const SaveSlotList &list, bool saving);
bool          SaveSlotIsNew(const SaveSlotList &list, int row, bool saving);
const char   *SaveSlotStatus(SaveSlotState state);
SaveSlotState SaveSlotRead(const std::filesystem::path &path, SAVEDATA_FORMAT &image);
SaveSlotList  SaveSlotScan(bool include_autosave = true);
/**
 * Refreshes the manager and its compatibility table with the requested save rows.
 */
int SaveSlotRefresh(CMemoryCardManager &manager, bool include_autosave);

// The manager initialized for the currently active menu. The catalog uses rows as
// operation IDs; display numbers and filenames are kept in SaveSlot, never in a
// retail fixed-size table.
CMemoryCardManager *SaveSlotManager();

FilesResult SaveSlotWrite(const std::filesystem::path &path, const SAVEDATA_FORMAT &image, bool replace);

// Writes the game as it stands over the autosave, as a town save or, for LOOP_DUNGEON, as a save the
// title resumes on the current floor; false if the write failed, the autosave then keeping what it held.
// A town save given a spawn also records it, so that loading the autosave returns the player to that spot.
bool SaveSlotWriteAutosave(int program_loop_no, AutosaveSpawn *spawn = nullptr);

// A legacy row publishes a new flat file, then attempts to archive its entry.
FilesResult SaveSlotWrite(const SaveSlot &slot, const SAVEDATA_FORMAT &image);

// Deterministic filesystem interleavings for import regressions. An empty hook
// uses the OS operations; false models a reported failure at that boundary.
enum class SaveSlotImportStage {
    Comparing,
    Published,
    BeforeArchive,
    Archived
};
using SaveSlotImportHook = std::function<bool(SaveSlotImportStage, const std::filesystem::path &, const std::filesystem::path &)>;
void SaveSlotSetImportHook(SaveSlotImportHook hook);
