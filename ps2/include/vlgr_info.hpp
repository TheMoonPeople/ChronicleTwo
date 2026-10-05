#pragma once

#include "common.h"
#include "villagermngr.hpp"

/**
 * @file
 * Declares the town villager tables read from the game's configuration
 * scripts: the story progress points, the villager places, which place each
 * villager uses at each point of the story, and each villager's model and
 * house.
 */

class mgCMemory;

/**
 *
 * Sizes of the fixed tables the configuration scripts are read into.
 *
 */
enum {
    VLGR_PLACE_MAX    = 0x200, /**< Number of villager numbers a place table is held for. */
    GAME_PROGRESS_MAX = 0x100  /**< Number of story progress points. */
};

/**
 *
 * Style of house a villager lives in, which picks the suffix added to the house's map name.
 *
 */
enum VLGR_HOUSE_TYPE {
    VLGR_HOUSE_NONE = -1, /**< The villager has no house. */
    VLGR_HOUSE_A    = 0,  /**< House map with the "ia" suffix. */
    VLGR_HOUSE_B    = 1,  /**< House map with the "ib" suffix. */
    VLGR_HOUSE_C    = 2,  /**< House map with the "ic" suffix. */
    VLGR_HOUSE_D    = 3   /**< House map with the "id" suffix. */
};

/**
 *
 * One point of the story's progress, as listed in the villager configuration script.
 *
 */
struct GAME_PROGRESS_INFO {
    s16   chapter; /**< Chapter of the story the point is in. */
    s16   section; /**< Section of the chapter the point is in. */
    s32   order;   /**< Position of the point in the story, compared to tell earlier points from later ones. */
    char *name;    /**< Name of the point, shown by the save data editor. */
};
STATIC_ASSERT(sizeof(GAME_PROGRESS_INFO) == 0xC);

/**
 *
 * The model and look of one villager, as listed in the villager configuration script.
 *
 */
class CVillagerInfo {
public:
    s32   vlgr_id;     /**< Number of the villager, or -1 for an unused entry. */
    char *model_name;  /**< Name of the villager's character model file. */
    s32   house_type;  /**< Style of the villager's house, a VLGR_HOUSE_TYPE. */
    char *show_frames; /**< Semicolon-separated names of the model frames drawn, or NULL. */
    char *hide_frames; /**< Semicolon-separated names of the model frames hidden, or NULL. */
    s32   unk_14;
    s32   unk_18;

    /**
     *
     * Clears the entry, leaving it unused with no model.
     *
     * @mangled __ct__13CVillagerInfoFv
     * @address 0x31F0A0
     * @size 0x30
     */
    CVillagerInfo();
};
STATIC_ASSERT(sizeof(CVillagerInfo) == 0x1C);

int vpiGetMotionID(char *name);

/**
 *
 * Returns a villager place by its number, or NULL for a number out of range.
 *
 * @mangled GetVlgrPlaceInfo__Fi
 * @address 0x31EAD0
 * @size 0x40
 */
CVillagerPlaceInfo *GetVlgrPlaceInfo(int place_no);

/**
 *
 * Returns the table of places each villager uses through the story, giving its length.
 *
 * @mangled GetVlgrPlaceTable__FPi
 * @address 0x31EB10
 * @size 0x20
 */
CVillagerPlace *GetVlgrPlaceTable(int *num);

/**
 *
 * Returns the model and look of a villager by its number, or NULL when it is not listed.
 *
 * @mangled GetVillagerInfo__Fi
 * @address 0x31EB30
 * @size 0xC0
 */
CVillagerInfo *GetVillagerInfo(int vlgr_id);

/**
 *
 * Writes the path of a villager's character model file, giving whether the villager is listed.
 *
 * @mangled GetVillagerModelName__FiPc
 * @address 0x31EBF0
 * @size 0x50
 */
int GetVillagerModelName(int vlgr_id, char *name);

/**
 *
 * Reads the villagers' place schedules and models from a configuration script.
 *
 * @mangled LoadNPCInfo__FPciP9mgCMemory
 * @address 0x31F210
 * @size 0x90
 */
void LoadNPCInfo(char *script, int size, mgCMemory *stack);

/**
 *
 * Reads the villager places from a configuration script.
 *
 * @mangled LoadPlaceInfo__FPciP9mgCMemory
 * @address 0x31F2A0
 * @size 0x70
 */
void LoadPlaceInfo(char *script, int size, mgCMemory *stack);

/**
 *
 * Loads the villager places, story progress points and villager schedules from their files.
 *
 * @mangled LoadGameInfo__FP9mgCMemory
 * @address 0x31F960
 * @size 0x1C0
 */
void LoadGameInfo(mgCMemory *stack);

/**
 *
 * Returns a story progress point by its number, or NULL for a number out of range.
 *
 * @mangled GetGameProgressInfo__Fi
 * @address 0x31FB20
 * @size 0x40
 */
GAME_PROGRESS_INFO *GetGameProgressInfo(int progress);

/**
 *
 * Returns the chapter a story progress point is in, or 0 for a number out of range.
 *
 * @mangled GetGameChapter__Fi
 * @address 0x31FB60
 * @size 0x30
 */
int GetGameChapter(int progress);

/**
 *
 * Returns the number of story progress points.
 *
 * @mangled GetGameProgressNum__Fv
 * @address 0x31FB90
 * @size 0x10
 */
int GetGameProgressNum();
