#pragma once

#include "common.h"

/**
 * @file
 * Declares the table of maps read from the map configuration script, which
 * gives every map its file name, title, type and sound data, together with
 * the debug screens built on it: the map selection list, the save data
 * editor and the event viewer, and the switch that shows or hides the
 * Atlamillia on a character's model.
 */

class mgCMemory;
class CCharacter2;

/**
 *
 * Categories of the debug map selection list, as a map's sel_type holds them.
 *
 */
// clang-format off
enum MapSelType {
    MAP_SEL_NEW         = 0, /**< "New". */
    MAP_SEL_GEORAMA     = 1, /**< "Georama". */
    MAP_SEL_PALM_BLINKS = 2, /**< "PalmBlinks". */
    MAP_SEL_SUBMAP      = 3, /**< "Submap". */
    MAP_SEL_FUTURE      = 4, /**< "Future". */
    MAP_SEL_DUNGEON     = 5, /**< "Dungeon". */
    MAP_SEL_EVENT       = 6, /**< "Event". */
    MAP_SEL_SPECIAL     = 7, /**< "Special". */
    MAP_SEL_TYPE_NUM    = 8, /**< Number of categories. */
};

// clang-format on

/**
 *
 * Screens of the debug map selection, as SelectMode holds them.
 *
 */
// clang-format off
enum MapSelectMode {
    MAP_SELECT_MODE_CANCEL = -1, /**< The selection was left without choosing a map. */
    MAP_SELECT_MODE_TYPE   = 0,  /**< Choosing a category. */
    MAP_SELECT_MODE_MAP    = 1,  /**< Choosing a map of the chosen category. */
    MAP_SELECT_MODE_DECIDE = 2,  /**< A map was chosen and its name stored in SelectMapName. */
};

// clang-format on

/**
 *
 * Results of MapSelectLoop.
 *
 */
// clang-format off
enum MapSelectResult {
    MAP_SELECT_CONTINUE = 0, /**< The selection stays open. */
    MAP_SELECT_CANCEL   = 1, /**< The selection was left without choosing a map. */
    MAP_SELECT_DECIDE   = 2, /**< A map was chosen. */
};

// clang-format on

/**
 *
 * Rows of the debug save data editor, as SedSel holds them.
 *
 */
// clang-format off
enum SaveDataEditItem {
    SED_PROGRESS  = 0, /**< Game progress step. */
    SED_TIME      = 1, /**< Time of day, in hours. */
    SED_FLAG      = 2, /**< One bit flag of the save data. */
    SED_GEO_COMP  = 3, /**< Georama completion of one town. */
    SED_PLAY_TIME = 4, /**< Whether play time is counted. */
    SED_CONFIG    = 5, /**< Caption setting of the configuration. */
    SED_ITEM_NUM  = 6, /**< Number of rows. */
};

// clang-format on

/**
 *
 * Results of EventViewLoop.
 *
 */
// clang-format off
enum EventViewResult {
    EVENT_VIEW_CONTINUE = 0, /**< The event list stays open. */
    EVENT_VIEW_START    = 1, /**< An event was chosen and its mode entered. */
    EVENT_VIEW_CANCEL   = 2, /**< The event list was left. */
};

// clang-format on

/**
 *
 * Sizes of the tables the map and event lists are kept in.
 *
 */
// clang-format off
enum {
    MAP_NAME_BUFF_SIZE = 0x800, /**< Quadwords of MapNameBuff, holding the map table and its strings. */
    SELECT_MAP_MAX     = 0x80,  /**< Maps one category of the map selection can list. */
    EVENT_VIEW_MAX     = 0x200, /**< Events the event viewer can list. */
};

// clang-format on

/**
 *
 * One map of the map table, set by a MAP_NAME tag of the map configuration script.
 *
 */
struct MAP_NAME_INFO {
    char *name;        /**< File name of the map, by which SearchMapNo finds it. */
    char *title;       /**< Name of the map shown to the player, or null. */
    char *add_path;    /**< Additional path given with the map, or null. */
    int   type;        /**< Kind of map; 1 for a georama map that has edit data. */
    int   sel_type;    /**< Category of the map selection list. @see MapSelType */
    int   snd_data_id; /**< Sound data the map loads, or -1 for none. */
    int   area_no;     /**< Area the map belongs to. */
};

STATIC_ASSERT(sizeof(MAP_NAME_INFO) == 0x1C);

/**
 *
 * One entry of the debug event viewer's list, read from the event view file.
 *
 */
struct EVENT_VIEW_INFO {
    char *name;   /**< First text shown for the event in the list. */
    char *detail; /**< Second text shown for the event in the list. */
    int   unk_8;
    int   event_no; /**< Event run when the mode is entered. */
    int   map_no;   /**< Map, or dungeon when dungeon is set, the event takes place in, or -1 when unknown. */
    int   floor_no; /**< Dungeon floor the event takes place on. */
    int   dungeon;  /**< Non-zero when the event is entered through the dungeon mode rather than the town mode. */
};

STATIC_ASSERT(sizeof(EVENT_VIEW_INFO) == 0x1C);

/**
 *
 * Entries of the debug event viewer's list, allocated by LoadEventViewData.
 *
 */
extern EVENT_VIEW_INFO *EventInfo;

/**
 *
 * Non-zero to start the event viewer's list at its first boss battle event.
 *
 */
extern int BossBattleSelFlag;

/**
 *
 * Loads the map configuration script of a language and builds the map
 * table from it.
 *
 * @mangled LoadMapName__FiP1
 * @address 0x2D6E70
 * @size 0xB0
 */
void LoadMapName(int language, u_long128 *buffer);

/**
 *
 * Builds the directory of a map's files from its name, one level per
 * leading part of the name, followed by the name itself; returns path.
 *
 * @mangled GetMapPath__FPcPc
 * @address 0x2D6F60
 * @size 0xF0
 */
void GetMapPath(char *path, char *name);

/**
 *
 * Returns the kind of a map, or -1 for a map number outside the table.
 *
 * @mangled GetMapType__Fi
 * @address 0x2D7050
 * @size 0x30
 */
int GetMapType(int map_no);

/**
 *
 * Returns the area a map belongs to, or -1 for a map number outside the table.
 *
 * @mangled GetMapAreaNo__Fi
 * @address 0x2D7080
 * @size 0x30
 */
int GetMapAreaNo(int map_no);

/**
 *
 * Returns the map selection category of a map, or 0 for a map number
 * outside the table. @see MapSelType
 *
 * @mangled GetMapSelType__Fi
 * @address 0x2D70B0
 * @size 0x30
 */
int GetMapSelType(int map_no);

/**
 *
 * Returns the sound data a map loads, or -1 for none or for a map number
 * outside the table.
 *
 * @mangled GetMapSndDataID__Fi
 * @address 0x2D70E0
 * @size 0x30
 */
int GetMapSndDataID(int map_no);

/**
 *
 * Returns the file name of a map and stores its title in title when that
 * is not null; a map number outside the table gives the name chosen on
 * the map selection screen.
 *
 * @mangled GetMapName__FiPPc
 * @address 0x2D7110
 * @size 0x50
 */
char *GetMapName(int map_no, char **title);

/**
 *
 * Returns the number of the map with a file name, or -1 when there is none.
 *
 * @mangled SearchMapNo__FPc
 * @address 0x2D7160
 * @size 0x90
 */
int SearchMapNo(char *name);

/**
 *
 * Returns the title of a map, or null for a map number outside the table.
 *
 * @mangled GetMapTitle__Fi
 * @address 0x2D71F0
 * @size 0x30
 */
char *GetMapTitle(int map_no);

/**
 *
 * Returns the additional path of a map, or null for a map number outside
 * the table.
 *
 * @mangled GetAddMapPath__Fi
 * @address 0x2D7220
 * @size 0x30
 */
char *GetAddMapPath(int map_no);

/**
 *
 * Reads the map list file and sorts its maps into the categories of the
 * debug map selection.
 *
 * @mangled InitMapSelect__FP9mgCMemory
 * @address 0x2D7250
 * @size 0x290
 */
void InitMapSelect(mgCMemory *stack);

/**
 *
 * Runs one frame of the debug map selection. @see MapSelectResult
 *
 * @mangled MapSelectLoop__Fv
 * @address 0x2D7AC0
 * @size 0x70
 */
int MapSelectLoop();

/**
 *
 * Prepares the debug save data editor; there is nothing to prepare.
 *
 * @mangled InitSaveDataEdit__FP9mgCMemory
 * @address 0x2D7B30
 * @size 0x10
 */
void InitSaveDataEdit(mgCMemory *stack);

/**
 *
 * Runs one frame of the debug save data editor, returning non-zero when
 * it is left.
 *
 * @mangled SaveDataEditLoop__Fv
 * @address 0x2D7B40
 * @size 0x750
 */
int SaveDataEditLoop();

/**
 *
 * Runs one frame of the debug event viewer, entering the mode of the
 * chosen event. @see EventViewResult
 *
 * @mangled EventViewLoop__Fv
 * @address 0x2D8290
 * @size 0x2F0
 */
int EventViewLoop();

/**
 *
 * Reads the event view file and builds the event viewer's list from it.
 *
 * @mangled LoadEventViewData__FP1P9mgCMemory
 * @address 0x2D8580
 * @size 0x210
 */
void LoadEventViewData(u_long128 *buffer, mgCMemory *stack);

/**
 *
 * Shows or hides the Atlamillia frames of a character's model: type 0
 * switches "atoramiria" and "himo", type 1 "atoramiria" and type 2 "atora".
 *
 * @mangled AtraMiriaOnOff__FiP11CCharacter2i
 * @address 0x2D8930
 * @size 0x170
 */
void AtraMiriaOnOff(int mode, CCharacter2 *chara, int enable);
