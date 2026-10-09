#pragma once

#include "common.h"

#include "subgame.hpp"

/**
 * @file
 * Declares the town-building mode's debug menu and its lighting editor, developer tools for
 * running events, starting sub games, saving and loading town layouts and tuning map lights.
 */

class CScene;
class CEditData;
class mgCMemory;

/**
 *
 * Pages of the town-building debug menu, cycled through with one button.
 *
 */
enum EDIT_DEBUG_PAGE {
    EDIT_DEBUG_PAGE_GENERAL = 0,   /**< Debug camera, events, sub games and other general switches. */
    EDIT_DEBUG_PAGE_EDIT_DATA = 1, /**< Clearing, saving and loading the town layout and its flags. */
    EDIT_DEBUG_PAGE_MAP = 2,       /**< Map jumps and reloading the fish-race configuration. */
    EDIT_DEBUG_PAGE_COUNT = 3,     /**< Number of debug menu pages. */
};

/**
 *
 * Entries of the general page of the town-building debug menu.
 *
 */
enum EDIT_DEBUG_GENERAL_ITEM {
    EDIT_DEBUG_GENERAL_DEBUG_CAMERA = 0,  /**< Edits the debug camera switch, 0 or 1. */
    EDIT_DEBUG_GENERAL_RUN_EVENT = 1,     /**< Chooses an event number and runs that event. */
    EDIT_DEBUG_GENERAL_GEORAMA_DEBUG = 2, /**< Edits the town-building debug switch, 0 or 1. */
    EDIT_DEBUG_GENERAL_CHARA_MOVE = 3,    /**< Edits the character movement debug setting, 0 to 2. */
    EDIT_DEBUG_GENERAL_SUB_GAME = 4,      /**< Chooses a sub game number and starts that sub game. */
    EDIT_DEBUG_GENERAL_PARAM_OFF = 5,     /**< Edits the switch that hides debug parameters, 0 or 1. */
    EDIT_DEBUG_GENERAL_INVENT_DEBUG = 6,  /**< Edits the inventory debug setting, 0 or 1. */
    EDIT_DEBUG_GENERAL_COUNT = 7,         /**< Number of entries on the general page. */
};

/**
 *
 * Entries of the town-layout page of the town-building debug menu.
 *
 */
enum EDIT_DEBUG_EDIT_DATA_ITEM {
    EDIT_DEBUG_EDIT_DATA_ALL_CLEAR = 0, /**< Removes every part placed on the town map. */
    EDIT_DEBUG_EDIT_DATA_SAVE_FILE = 1, /**< Writes the town layout to a numbered host file. */
    EDIT_DEBUG_EDIT_DATA_LOAD_FILE = 2, /**< Reads the town layout back from a numbered host file. */
    EDIT_DEBUG_EDIT_DATA_CONDITION = 3, /**< Shows and toggles one of the town's condition flags. */
    EDIT_DEBUG_EDIT_DATA_MAP_FLAG = 4,  /**< Shows and toggles one of the current map's flags. */
    EDIT_DEBUG_EDIT_DATA_COUNT = 5,     /**< Number of entries on the town-layout page. */
};

/**
 *
 * Entries of the map page of the town-building debug menu.
 *
 */
enum EDIT_DEBUG_MAP_ITEM {
    EDIT_DEBUG_MAP_MAP_JUMP = 0,     /**< Leaves the menu and jumps to the map whose number is chosen. */
    EDIT_DEBUG_MAP_LOAD_GYORACE = 1, /**< Reloads the fish-race racer configuration from the host. */
    EDIT_DEBUG_MAP_COUNT = 2,        /**< Number of entries on the map page. */
};

/**
 *
 * Pages of the lighting editor, each covering one group of a map's light settings.
 *
 */
enum LIGHTING_EDIT_PAGE {
    LIGHTING_EDIT_PAGE_BG_AMBIENT = 0, /**< Background colours and the ambient light colour. */
    LIGHTING_EDIT_PAGE_DIR_LIGHT = 1,  /**< One of the map's directional lights. */
    LIGHTING_EDIT_PAGE_FOG = 2,        /**< Fog near and far distances, colour and minimum and maximum. */
    LIGHTING_EDIT_PAGE_FILE = 3,       /**< Saving the light settings to a host file. */
    LIGHTING_EDIT_PAGE_COUNT = 4,      /**< Number of lighting editor pages. */
};

/**
 *
 * Rows shared by every lighting editor page, ahead of the page's own entries.
 *
 */
enum LIGHTING_EDIT_ROW {
    LIGHTING_EDIT_ROW_LIGHT_SET = 0, /**< Chooses the map's light set and moves the time of day to it. */
    LIGHTING_EDIT_ROW_PAGE = 1,      /**< Chooses the page, and on the directional light page the light. */
    LIGHTING_EDIT_ROW_ITEM = 2,      /**< First of the page's own entries. */
};

/**
 *
 * Entries of the directional light page of the lighting editor, counted from its first entry row.
 *
 */
enum LIGHTING_EDIT_DIR_ITEM {
    LIGHTING_EDIT_DIR_COLOR_R = 0,  /**< Red component of the light's colour. */
    LIGHTING_EDIT_DIR_COLOR_G = 1,  /**< Green component of the light's colour. */
    LIGHTING_EDIT_DIR_COLOR_B = 2,  /**< Blue component of the light's colour. */
    LIGHTING_EDIT_DIR_ROTATE_X = 3, /**< Turns the light about the x axis. */
    LIGHTING_EDIT_DIR_ROTATE_Y = 4, /**< Turns the light about the y axis. */
    LIGHTING_EDIT_DIR_ROTATE_Z = 5, /**< Turns the light about the z axis. */
    LIGHTING_EDIT_DIR_COUNT = 6,    /**< Number of entries on the directional light page. */
};

/**
 *
 * Entries of the fog page of the lighting editor, counted from its first entry row.
 *
 */
enum LIGHTING_EDIT_FOG_ITEM {
    LIGHTING_EDIT_FOG_NEAR = 0,  /**< Distance at which the fog takes its near value. */
    LIGHTING_EDIT_FOG_FAR = 1,   /**< Distance at which the fog takes its far value. */
    LIGHTING_EDIT_FOG_R = 2,     /**< Red component of the fog colour. */
    LIGHTING_EDIT_FOG_G = 3,     /**< Green component of the fog colour. */
    LIGHTING_EDIT_FOG_B = 4,     /**< Blue component of the fog colour. */
    LIGHTING_EDIT_FOG_MIN = 5,   /**< Fog value at the far distance. */
    LIGHTING_EDIT_FOG_MAX = 6,   /**< Fog value at the near distance. */
    LIGHTING_EDIT_FOG_COUNT = 7, /**< Number of entries on the fog page. */
};

/**
 *
 * State the town-building mode shares with its debug menu: the sub game start parameters,
 * the town layout being edited and a pending map jump.
 *
 */
struct EditDebugInfo : public SubGameInfo {
    CEditData *edit_data;    /**< Layout of the town being built, or NULL when none is loaded. */
    int        edit_data_no; /**< Index of that town layout in the save data. */
    int        jump_map_no;  /**< Map the debug menu asked to jump to, or -1 for none. */
};

STATIC_ASSERT(sizeof(EditDebugInfo) == 0x3C);

/**
 *
 * Closes the debug menu and returns it to its first entry with no
 * texture bank chosen.
 *
 * @mangled EditDebugInit__Fv
 * @address 0x1A8C80
 * @size 0x20
 */
void EditDebugInit();

/**
 *
 * Gives non-zero while the town-building debug menu is open.
 *
 * @mangled EditDebugMode__Fv
 * @address 0x1A8CA0
 * @size 0x10
 */
int EditDebugMode();

/**
 *
 * Opens the town-building debug menu, emptying the stack of the work
 * buffer it draws with and remembering the texture bank to use.
 *
 * @mangled EditDebugStart__FiP9mgCMemory
 * @address 0x1A8CB0
 * @size 0x20
 */
void EditDebugStart(int texb, mgCMemory *buffer);

/**
 *
 * Runs one frame of the town-building debug menu, drawing it and acting on
 * the pad, and gives 1 once the menu has closed.
 *
 * @mangled EditDebugLoop__FP6CSceneP13EditDebugInfo
 * @address 0x1A8D10
 * @size 0xAD0
 */
int EditDebugLoop(CScene *scene, EditDebugInfo *info);

/**
 *
 * Closes the debug menu and returns it to its first entry with no
 * texture bank chosen.
 *
 * @mangled EditDebugEnd__Fv
 * @address 0x1A97E0
 * @size 0x10
 */
void EditDebugEnd();

/**
 *
 * Leaves the lighting editor closed when the town-building mode
 * starts.
 *
 * @mangled InitLightingEdit__Fv
 * @address 0x1A97F0
 * @size 0x10
 */
void InitLightingEdit();

/**
 *
 * Closes the lighting editor when the town-building mode
 * ends.
 *
 * @mangled EndLightingEdit__Fv
 * @address 0x1A9800
 * @size 0x10
 */
void EndLightingEdit();

/**
 *
 * Gives non-zero while the lighting editor is
 * open.
 *
 * @mangled IsLightingEditMode__Fv
 * @address 0x1A9810
 * @size 0x10
 */
int IsLightingEditMode();

/**
 *
 * Runs one frame of the lighting editor, opening and closing it on the pad
 * and letting the current map's light and fog settings be changed and saved.
 *
 * @mangled LightingEdit__FP6CScene
 * @address 0x1A9820
 * @size 0x1524
 */
void LightingEdit(CScene *scene);
