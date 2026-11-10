#pragma once

#include <array>
#include <cstddef>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

#include "editdata.hpp"
#include "memcard.hpp"
#include "savedata.hpp"

/**
 * One placed part of a town's Georama layout.
 */
struct TownPart {
    s32                                                id{};       /**< Definition ID, or 0 for an unused entry. */
    s8                                                 state{};    /**< EditPartsState the part stood in. */
    s8                                                 angle{};    /**< Turn, in EDIT_ANGLE_MAX steps. */
    std::array<s16, 3>                                 pos{};      /**< Position on the edit map, in whole units. */
    std::array<std::array<u8, 3>, EDIT_DATA_COLOR_MAX> color{};    /**< Paint colours, 0x80 for full intensity. */
    s32                                                house_no{}; /**< Number of the part's house plus one, or 0 for none. */
};

/**
 * One house of a town.
 */
struct TownHouse {
    s16 npc_no{}; /**< First villager who lives in the house. */
};

/**
 * One river grid of a town.
 */
struct TownGrid {
    s32                num_x{}; /**< Cells along the X axis. */
    s32                num_z{}; /**< Cells along the Z axis. */
    std::array<s16, 3> pos{};   /**< Position of the grid on the edit map, in whole units. */
    std::vector<u8>    cells;   /**< One byte per cell, X major, with bit 0 set for river. */
};

/**
 * A town's Georama layout, with no limit on its parts, houses or log.
 */
struct TownLayout {
    std::vector<TownPart>     parts;     /**< Placed parts, in slot order. */
    std::vector<TownHouse>    houses;    /**< Houses, by number. */
    std::vector<EditPlaceLog> place_log; /**< Which part rests on which, by index into parts. */
    std::vector<TownGrid>     grids;     /**< River grids, in the map's grid order. */
};

using TownLayouts = std::array<TownLayout, SAVE_EDIT_DATA_MAX>;

/**
 * Where the player stood when a town autosave was written; loading the autosave returns them there.
 */
struct AutosaveSpawn {
    u64   counter = 0;        /**< Unique counter of the save the spawn belongs to. */
    int   map_no = -1;        /**< Main map of the spawn. */
    float position[4] = {};   /**< Player position. */
    float rotation[4] = {};   /**< Player rotation. */
    float camera_pos[4] = {}; /**< Camera position. */
    float camera_ref[4] = {}; /**< Camera target. */
};

/**
 * A whole save: the retail image, the towns' layouts kept beside it, and the PC's own data.
 */
struct SaveDocument {
    SAVEDATA_FORMAT              image{}; /**< Header and save data; the edit data's layout arrays are unused. */
    TownLayouts                  towns;   /**< Layout of each town's Georama, by edit data number. */
    std::optional<AutosaveSpawn> spawn;   /**< Player spot of a town autosave. */
};

/**
 * Why a save file could not be read.
 */
enum class SaveJsonError {
    None,               /**< Read. */
    NotJson,            /**< The text is not JSON. */
    WrongSchema,        /**< The document is not a save, or lacks a required key. */
    UnsupportedVersion, /**< The save's schema version is newer than this build reads. */
    BadChecksum,        /**< The stored checksum does not match the contents. */
    BadValue,           /**< A value is out of range, non-finite or malformed. */
};

/** Schema version written into new saves. */
inline constexpr int kSaveJsonSchemaVersion = 1;

/** Save files larger than this are refused before they are parsed. */
inline constexpr std::size_t kSaveJsonMaxBytes = std::size_t{64} * 1024 * 1024;

/**
 * Writes a save document as pretty-printed JSON with its checksum.
 */
std::string SaveJsonWrite(const SaveDocument &document);

/**
 * Reads a whole save document, checking its checksum when it has one.
 */
SaveJsonError SaveJsonRead(std::string_view text, SaveDocument &document);

/**
 * Reads only what the save list shows: the header and the play time and progress.
 */
SaveJsonError SaveJsonReadHeader(std::string_view text, SAVEDATA_INFO &info);

/**
 * The live layout of the town whose save record is given, created empty when it has none.
 */
TownLayout &PortTownLayout(const CEditData &data);

/**
 * The live layout of the town whose save record is given, or nullptr when it has none.
 */
const TownLayout *PortFindTownLayout(const CEditData &data);

/**
 * Forgets the live layout of the town whose save record is given.
 */
void PortClearTownLayout(const CEditData &data);

/**
 * Decodes the layout that a retail save record holds.
 */
TownLayout TownLayoutFromRecord(const CEditData &data);
