#pragma once

#include "common.h"

/**
 * @file
 * Declares the dungeon debug menu: an on-screen list of debug commands that
 * starts events, loads enemies, switches debug views and changes sound and
 * effect settings while the player is in a dungeon.
 */

/**
 * Lines of the dungeon debug menu, in the order in which the menu lists
 * them. Each line has a value that the pad changes and that the menu's
 * accept button acts on.
 */
enum DNG_DEBUG_COMMAND {
    DNG_DEBUG_CMD_RUN_EVENT    = 0,  /**< Runs the event script whose number is the line's value. */
    DNG_DEBUG_CMD_ENEMY_LOADER = 1,  /**< Loads the monster whose ID is the line's value next to the player. */
    DNG_DEBUG_CMD_DEBUG_CAMERA = 2,  /**< Debug camera setting of the main loop's debug information. */
    DNG_DEBUG_CMD_CHARA_MOVE   = 3,  /**< Character movement setting of the main loop's debug information. */
    DNG_DEBUG_CMD_ENEMY_RESET  = 4,  /**< Removes every monster and sets the monster manager up again. */
    DNG_DEBUG_CMD_LOCK_ON_MODE = 5,  /**< Lock-on mode of the battle area scene. */
    DNG_DEBUG_CMD_INFORMATION  = 6,  /**< Selects the system parameter window that the dungeon draws. */
    DNG_DEBUG_CMD_SKIP_FLOOR   = 7,  /**< Gives the player the items that open the current floor's exit. */
    DNG_DEBUG_CMD_SOUND_FLAG   = 8,  /**< Pauses or plays the dungeon music. */
    DNG_DEBUG_CMD_MONSTER_TALK = 9,  /**< Monster talk setting. */
    DNG_DEBUG_CMD_EFFECT_ID    = 10, /**< Effect ID setting. */
    DNG_DEBUG_CMD_EFFECT_VOL   = 11, /**< Effect volume setting. */
    DNG_DEBUG_CMD_NUM          = 12  /**< Number of lines in the menu. */
};

/**
 * State of the dungeon debug menu and the settings it keeps between the
 * times that it is open. The dungeon reads it after the menu closes to run
 * the command that the menu chose.
 */
struct DNG_DEBUG_INFO {
    s16   active;           /**< Non-zero while the menu is open. */
    s16   cursor;           /**< Line of the menu that the cursor is on, a DNG_DEBUG_COMMAND. */
    s16   command;          /**< Command that the dungeon runs after the menu closes, or -1 for none. */
    s16   event_no;         /**< Event script that the dungeon runs for DNG_DEBUG_CMD_RUN_EVENT. */
    s32   saved_pause_flag; /**< Battle area pause_flag from before the menu opened. */
    s32   first_enemy_load; /**< Non-zero until the menu has loaded one enemy, which clears the monster heap first. */
    s32   sound_flag;       /**< Zero to keep the dungeon music and battle sounds stopped. */
    s32   monster_talk;     /**< Monster talk setting. */
    s32   effect_id;        /**< Effect ID setting. */
    float effect_vol;       /**< Effect volume setting. */
};
STATIC_ASSERT(sizeof(DNG_DEBUG_INFO) == 0x20);

/**
 * State and settings of the dungeon debug menu.
 */
extern DNG_DEBUG_INFO dbinfo;

/**
 * Returns the state and settings of the dungeon debug menu.
 *
 * @mangled dngGetDebugInfo__Fv
 * @address 0x1BBE10
 * @size 0x10
 */
DNG_DEBUG_INFO *dngGetDebugInfo();

/**
 * Closes the debug menu, puts its settings to their defaults and sets up
 * the font that it draws with.
 *
 * @mangled dngDebugInit__Fv
 * @address 0x1BBE20
 * @size 0x70
 */
void dngDebugInit();

/**
 * Opens the debug menu: loads the menu's values from the settings they
 * control, turns on pad auto-repeat and holds the battle area scene in the
 * debug mode.
 *
 * @mangled dngDebugStart__Fv
 * @address 0x1BBE90
 * @size 0xF0
 */
void dngDebugStart();

/**
 * Draws the debug menu, with the name of the monster that the enemy
 * loader line selects, while the menu is open.
 *
 * @mangled dngDebugDraw__Fv
 * @address 0x1BBF80
 * @size 0x320
 */
void dngDebugDraw();

/**
 * Moves the cursor, changes the values and runs the commands of the debug
 * menu from the pad, closing the menu when a command needs it.
 *
 * @return 0 when the menu is closed, otherwise 1.
 *
 * @mangled dngDebugKey__Fv
 * @address 0x1BC350
 * @size 0x3A0
 */
int dngDebugKey();

/**
 * Draws the system parameter window that the debug menu's information
 * line selects, if any.
 *
 * @mangled DrawDebugWindow__Fv
 * @address 0x1BCE70
 * @size 0x50
 */
void DrawDebugWindow();


void DBGCMD_ReloadEnemy(int monster_id, int reset);
