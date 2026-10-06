#pragma once

#include "common.h"

/**
 * @file
 * Declares the manager of the town editor's (Georama) part definitions:
 * the table of parts that can be placed, read from the edit information
 * script, and the tables of parts placed in the town from the start.
 */

class CEditPartsInfo;
class mgCMemory;

/**
 *
 * One edit part placed in the town by the map's data rather than by the player.
 *
 */
struct ePlaceData {
    s32   id;          /**< ID of the part's definition, CEditPartsInfo::id. */
    s32   angle;       /**< Placement angle step, as CEditMap::GetEditAngle takes it. */
    s32   unk_8;
    s32   unk_c;
    float position[3]; /**< Position the part is placed at. */
    s32   unk_1c;
};
STATIC_ASSERT(sizeof(ePlaceData) == 0x20);

/**
 *
 * Holds the definitions of the parts the town editor can place, and the parts placed from the start.
 *
 */
class CEditInfoMngr {
public:
    s32             parts_info_num; /**< Number of definitions in parts_info. */
    CEditPartsInfo *parts_info;     /**< Definitions of the parts that can be placed. */
    s32             fix_parts_num;  /**< Number of entries in fix_parts. */
    ePlaceData     *fix_parts;      /**< Fixed parts the map places. */
    s32             init_parts_num; /**< Number of entries in init_parts. */
    ePlaceData     *init_parts;     /**< Parts placed when a town is begun from nothing. */

    /**
     *
     * Empties the manager.
     *
     */
    CEditInfoMngr() {
        Initialize();
    }

    /**
     *
     * Empties the manager of all its tables.
     *
     * @mangled Initialize__13CEditInfoMngrFv
     * @address 0x2A92A0
     * @size 0x1C
     */
    void Initialize();

    /**
     *
     * Sets the table of part definitions and its length.
     *
     * @mangled SetePartsInfoTable__13CEditInfoMngrFP14CEditPartsInfoi
     * @address 0x2A92C0
     * @size 0xC
     */
    void SetePartsInfoTable(CEditPartsInfo *table, int num);

    /**
     *
     * Sets the table of fixed parts and its length.
     *
     * @mangled SeteFixPartsTable__13CEditInfoMngrFP10ePlaceDatai
     * @address 0x2A92D0
     * @size 0xC
     */
    void SeteFixPartsTable(ePlaceData *table, int num);

    /**
     *
     * Returns a part definition by its number in the table, or NULL for a number out of range.
     *
     * @mangled GetePartsInfo__13CEditInfoMngrFi
     * @address 0x2A92E0
     * @size 0x40
     */
    CEditPartsInfo *GetePartsInfo(int no);

    /**
     *
     * Returns the part definition whose editor name matches a name, or NULL.
     *
     * @mangled GetePartsInfo__13CEditInfoMngrFPc
     * @address 0x2A9320
     * @size 0x84
     */
    CEditPartsInfo *GetePartsInfo(char *name);

    /**
     *
     * Returns the part definition with an ID, or NULL.
     *
     * @mangled GetePartsInfoAtID__13CEditInfoMngrFi
     * @address 0x2A93B0
     * @size 0x68
     */
    CEditPartsInfo *GetePartsInfoAtID(int id);

    /**
     *
     * Returns the first part definition of a kind, or NULL.
     *
     * @mangled GetePartsInfoAtType__13CEditInfoMngrFi
     * @address 0x2A9420
     * @size 0x7C
     */
    CEditPartsInfo *GetePartsInfoAtType(int type);

    /**
     *
     * Runs the edit information script, building the part definitions in a heap.
     *
     * @mangled LoadEditInfo__13CEditInfoMngrFPciP9mgCMemory
     * @address 0x2A9DD0
     * @size 0x80
     */
    void LoadEditInfo(char *script, int size, mgCMemory *stack);
};
STATIC_ASSERT(sizeof(CEditInfoMngr) == 0x18);
