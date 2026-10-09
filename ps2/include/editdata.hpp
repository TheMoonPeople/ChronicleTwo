#pragma once

#include "common.h"

#include <cstring>

#include "editmap.hpp"

/**
 * @file
 * Declares the saved layout of a Georama town (the parts placed, their
 * houses, how they rest on each other and the river grids) and the town
 * analysis that turns that layout into the conditions and requests the
 * town's future depends on, read from the geo%d.cfg script.
 */

class CEditParts;

/**
 *
 * Number of Georama maps that keep a saved layout and an analysis script.
 *
 */
#define EDIT_ANALYZE_MAP_MAX 5

/**
 *
 * Number of conditions an analysis script can name for one map.
 *
 */
#define EDIT_ANALYZE_CONDITION_MAX 64

/**
 *
 * Number of requests (analysis entries) an analysis script can give one map.
 *
 */
#define EDIT_ANALYZE_DATA_MAX 16

/**
 *
 * Number of condition numbers one request can depend on, including the
 * terminating -1.
 *
 */
#define EDIT_ANALYZE_CON_NO_MAX 8

/**
 *
 * Deepest a request may recurse through the requests its conditions depend on.
 *
 */
#define EDIT_ANALYZE_DEPTH_MAX 64

/**
 *
 * Number of placed parts a saved layout holds.
 *
 */
#define EDIT_DATA_PARTS_MAX 300

/**
 *
 * Number of houses a saved layout holds.
 *
 */
#define EDIT_DATA_HOUSE_MAX 32

/**
 *
 * Number of placement log entries a saved layout holds.
 *
 */
#define EDIT_DATA_PLACE_LOG_MAX 0x800

/**
 *
 * Number of bytes a saved layout keeps its river grids in.
 *
 */
#define EDIT_DATA_GRID_SIZE 0x400

/**
 *
 * Number of colours of a placed part that a saved layout keeps.
 *
 */
#define EDIT_DATA_COLOR_MAX 4

/**
 *
 * One request of a town's analysis: the conditions it needs, the share of
 * the town's future it is worth, and the map parts it shows and hides,
 * filled in by the ANALYZE, CON_NO, PERCENT, ON_PARTS and OFF_PARTS tags.
 *
 */
class EditAnalyzeDataSrc {
public:
    char *message;                         /**< Text of the request, or NULL for an unused entry. */
    s16   percent;                         /**< Share of the town's future the request is worth once met. */
    s16   geo_floor;                       /**< Dungeon floor (dungeon * 100 + floor) whose geostone reveals the request, or 0 or below when always known. */
    s8    con_no[EDIT_ANALYZE_CON_NO_MAX]; /**< Conditions the request needs, ended by -1. */
    s32   unk_10;
    char *on_parts;  /**< Names of the map parts shown while the request is met. */
    char *off_parts; /**< Names of the map parts hidden while the request is met. */

    /**
     *
     * Empties the request.
     *
     * @mangled Init__18EditAnalyzeDataSrcFv
     * @address 0x2ACCD0
     * @size 0x40
     */
    void Init();
};

STATIC_ASSERT(sizeof(EditAnalyzeDataSrc) == 0x1C);

/**
 *
 * Analysis of one Georama map read from its GEO_ANALYZE block: the names
 * of its conditions and the requests made from them.
 *
 */
class EditAnalyzeSrc {
public:
    char              *condition[EDIT_ANALYZE_CONDITION_MAX]; /**< Name of each condition, or NULL for an unused one. */
    s16                geo_floor[EDIT_ANALYZE_CONDITION_MAX]; /**< Dungeon floor (dungeon * 100 + floor) whose geostone reveals each condition, or 0 or below when always known. */
    EditAnalyzeDataSrc data[EDIT_ANALYZE_DATA_MAX];           /**< Requests of the map. */

    /**
     *
     * Creates an empty analysis.
     *
     * @mangled __ct__14EditAnalyzeSrcFv
     * @address 0x2AEEE0
     * @size 0x28
     */
    EditAnalyzeSrc();

    /**
     *
     * Empties every condition and request of the analysis.
     *
     * @mangled Init__14EditAnalyzeSrcFv
     * @address 0x2ACD10
     * @size 0xC0
     */
    void Init();
};

STATIC_ASSERT(sizeof(EditAnalyzeSrc) == 0x340);

/**
 *
 * Part placed in a saved town layout: which part it is, where it stands,
 * how it is turned and painted and which house it has.
 *
 */
struct EditDataParts {
    s32 id;                            /**< Definition ID of the part, or 0 for an unused entry. */
    s8  state;                         /**< How the part stood in the town, EditPartsState. */
    s8  angle;                         /**< Turn of the part, in EDIT_ANGLE_MAX steps. */
    s16 pos[3];                        /**< Position of the part on the edit map. */
    u8  color[EDIT_DATA_COLOR_MAX][3]; /**< Paint colours of the part, 0x80 for full intensity. */
    s16 house_no;                      /**< Number of the part's house plus one, or 0 for none. */
    u8  unk_1a[0xA];

    /**
     *
     * Creates an unused entry.
     *
     */
    EditDataParts() {
        memset(this, 0, sizeof(EditDataParts));
    }
};

STATIC_ASSERT(sizeof(EditDataParts) == 0x24);

/**
 *
 * Header the saved bytes of a river grid start with, followed by one byte for
 * each cell.
 *
 */
struct EditDataGrid {
    u8  num_x;  /**< Number of cells along the X axis. */
    u8  num_z;  /**< Number of cells along the Z axis. */
    s16 pos[3]; /**< Position of the grid on the edit map. */
    u8  unk_8[0x10];
};

STATIC_ASSERT(sizeof(EditDataGrid) == 0x18);

/**
 *
 * House of a saved town layout, recording a villager who lives in it.
 *
 */
struct EditDataHouse {
    s16 npc_no; /**< First villager who lives in the house. */
    u8  unk_2[0xE];

    /**
     *
     * Creates an empty house.
     *
     */
    EditDataHouse() {
        memset(this, 0, sizeof(EditDataHouse));
    }
};

STATIC_ASSERT(sizeof(EditDataHouse) == 0x10);

/**
 *
 * Analysis state of one town: which conditions hold and which requests and
 * conditions the player has been told about.
 *
 */
struct EditDataAnalyze {
    s8 data_open[EDIT_ANALYZE_DATA_MAX];           /**< Non-zero for each request the player has been told about. */
    s8 condition[EDIT_ANALYZE_CONDITION_MAX];      /**< Non-zero for each condition the town meets. */
    s8 condition_open[EDIT_ANALYZE_CONDITION_MAX]; /**< Non-zero for each condition the player has been told about. */
    u8 unk_90[0x40];

    /**
     *
     * Creates a state with no condition met or known.
     *
     */
    EditDataAnalyze() {
        memset(this, 0, sizeof(EditDataAnalyze));
    }
};

STATIC_ASSERT(sizeof(EditDataAnalyze) == 0xD0);

/**
 *
 * Saved layout of one Georama town, kept in the save data for each map:
 * its placed parts, houses, placement log and river grids, the culture
 * points the layout earned and the state of the town's analysis.
 *
 */
class CEditData {
public:
    s32             save_count;                         /**< Number of times the layout has been saved; 0 while the map's starting parts are still to be placed. */
    s32             culture_point;                      /**< Culture points the layout earned when it was last saved. */
    s32             parts_max;                          /**< Number of entries in parts. */
    EditDataParts   parts[EDIT_DATA_PARTS_MAX];         /**< Parts placed in the town. */
    s32             house_max;                          /**< Number of entries in house. */
    EditDataHouse   house[EDIT_DATA_HOUSE_MAX];         /**< Houses of the town. */
    EditPlaceLog    place_log[EDIT_DATA_PLACE_LOG_MAX]; /**< Which placed part rests on which, by index into parts. */
    u8              grid[EDIT_DATA_GRID_SIZE];          /**< River grids: for each grid, its size and position and then one byte per cell with bit 0 set for river. */
    EditDataAnalyze analyze;                            /**< State of the town's analysis. */
    u8              unk_5110[0x400];

    /**
     *
     * Creates an empty layout.
     *
     * @mangled __ct__9CEditDataFv
     * @address 0x195960
     * @size 0x94
     */
    CEditData();

    /**
     *
     * Empties the layout and the analysis state.
     *
     * @mangled Initialize__9CEditDataFv
     * @address 0x2ACEB0
     * @size 0x44
     */
    void Initialize();

    /**
     *
     * Empties the placed parts, houses, placement log and river grids.
     *
     * @mangled InitPlaceData__9CEditDataFv
     * @address 0x2ACF00
     * @size 0x128
     */
    void InitPlaceData();

    /**
     *
     * Counts the placed parts with a given definition ID.
     *
     * @mangled GetPartsNumID__9CEditDataFi
     * @address 0x2AE330
     * @size 0x54
     */
    int GetPartsNumID(int id);

    /**
     *
     * Works out whether a request is met, first working out every condition
     * it needs that is itself decided by another request; gives back
     * non-zero when it is met.
     *
     * @mangled Analyze__9CEditDataFiiPii
     * @address 0x2AE390
     * @size 0x12C
     */
    s8 Analyze(int entry, int area, int *pending, int depth);

    /**
     *
     * Sets every condition of a map: those whose con_src entry is below
     * zero from con_value, and the rest from the request that con_src
     * names.
     *
     * @mangled Analize__9CEditDataFiPiPi
     * @address 0x2AE4C0
     * @size 0xCC
     */
    void Analize(int area, int *flags, int *pending);

    /**
     *
     * Gets a request of a map's analysis, or NULL.
     *
     * @mangled GetAnalyzeData__9CEditDataFii
     * @address 0x2AE590
     * @size 0xC
     */
    EditAnalyzeDataSrc *GetAnalyzeData(int area, int entry);

    /**
     *
     * Gets a map's analysis, or NULL.
     *
     * @mangled GetAnalyzeSrc__9CEditDataFi
     * @address 0x2AE5A0
     * @size 0x44
     */
    EditAnalyzeSrc *GetAnalyzeSrc(int index);

    /**
     *
     * Adds up the shares of the town's future of every request met.
     *
     * @mangled GetAnalyzePercent__9CEditDataFi
     * @address 0x2AE5F0
     * @size 0xAC
     */
    int GetAnalyzePercent(int area);

    /**
     *
     * Gives back non-zero when every condition of a request is met, filling
     * in the request's condition numbers and whether each is met.
     *
     * @mangled GetAnalyzeFlag__9CEditDataFiiPiPi
     * @address 0x2AE6A0
     * @size 0x98
     */
    int GetAnalyzeFlag(int area, int entry, int *condition_nos, int *condition_values);

    /**
     *
     * Gives back non-zero when every condition of a request is met.
     *
     * @mangled GetAnalyzeFlag__9CEditDataFii
     * @address 0x2AE740
     * @size 0x20
     */
    int GetAnalyzeFlag(int map_no, int data_no);

    /**
     *
     * Sets whether a condition is met, for debugging.
     *
     * @mangled dbgSetContintionFlag__9CEditDataFiii
     * @address 0x2AE760
     * @size 0x2C
     */
    void dbgSetContintionFlag(int map_no, int flag_no, int value);

    /**
     *
     * Sets whether every condition of a request is met, for debugging.
     *
     * @mangled dbgSetAnalyzeFlag__9CEditDataFiii
     * @address 0x2AE790
     * @size 0x88
     */
    void dbgSetAnalyzeFlag(int map_no, int data_no, int flag);

    /**
     *
     * Sets whether every condition is met, for debugging.
     *
     * @mangled dbgSetAllContintionFlag__9CEditDataFii
     * @address 0x2AE820
     * @size 0x3C
     */
    void dbgSetAllContintionFlag(int map_no, int flag);

    /**
     *
     * Gives back whether a condition is met, for debugging, copying the
     * condition's name to name when name is not NULL.
     *
     * @mangled dbgGetContintionFlag__9CEditDataFiiPc
     * @address 0x2AE860
     * @size 0xA4
     */
    int dbgGetContintionFlag(int area, int flag_no, char *name);
};

STATIC_ASSERT(sizeof(CEditData) == 0x5510);

/**
 *
 * Reads the analysis script of every Georama map for a language.
 *
 * @mangled LoadEditAnalyzeData__FiP1
 * @address 0x2AE910
 * @size 0xD8
 */
void LoadEditAnalyzeData(int area_no, u_long128 *dest);

/**
 *
 * Gets the number of polygons a Georama map's town may draw, or 0.
 *
 * @mangled GetMaxPolyn__Fi
 * @address 0x2AEE00
 * @size 0x68
 */
int GetMaxPolyn(int map_no);

/**
 *
 * Gets the drawing memory a Georama map's town may use, or 0.
 *
 * @mangled GetMaxDrawMem__Fi
 * @address 0x2AEE70
 * @size 0x68
 */
int GetMaxDrawMem(int map_no);
