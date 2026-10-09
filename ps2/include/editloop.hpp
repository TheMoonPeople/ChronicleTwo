#pragma once

#include "common.h"

/**
 * @file
 * Declares the town main-loop mode, which walks the player through a town and switches between walking and Georama editing.
 */

class ClsMes;
class mgCMemory;

/**
 *
 * Parameters that the main loop hands to a mode when it enters it.
 *
 */
struct INIT_LOOP_ARG;

/**
 *
 * Phases of the town loop, as its LoopMode variable holds them.
 *
 */
enum EditLoopMode {
    EDIT_LOOP_WALK = 1,          /**< The player walks the town. */
    EDIT_LOOP_EDIT = 2,          /**< The town is being edited in Georama mode. */
    EDIT_LOOP_WALK_MENU = 3,     /**< The main menu is open over walking. */
    EDIT_LOOP_EDIT_PRE_MENU = 4, /**< Georama mode is waiting for its parts animation before opening the menu. */
    EDIT_LOOP_EDIT_MENU = 5,     /**< The main menu is open over Georama mode. */
    EDIT_LOOP_WAIT_READ = 6,     /**< Waiting for a background file read before walking resumes. */
};

/**
 *
 * Owners of the player's control in the town loop, as its ControlMode variable holds them.
 *
 */
enum EditControlMode {
    EDIT_CONTROL_PLAYER = 1,     /**< The player controls the character or the Georama cursor. */
    EDIT_CONTROL_EVENT = 2,      /**< A scene event script is running. */
    EDIT_CONTROL_EVENT_EDIT = 3, /**< The debug event editor is running. */
    EDIT_CONTROL_DEBUG = 4,      /**< The debug edit menu is running. */
};

/**
 *
 * Reports whether the town loop is in Georama mode, including the wait before its menu opens.
 *
 * @mangled IsEditMode__Fv
 * @address 0x1AAF80
 * @size 0x30
 */
int IsEditMode();

/**
 *
 * Lays out the packet and data buffers for a kind of map: 0 the initial buffers, 1 a normal map, 2 a larger map of type 1.
 *
 * @mangled SetDataPacket__Fi
 * @address 0x1AB070
 * @size 0x240
 */
void SetDataPacket(int mode);

/**
 *
 * Prepares the town loop when the main loop enters it: memory, scene, camera, characters, map and starting event.
 *
 * @mangled EditInit__F13INIT_LOOP_ARG
 * @address 0x1AB320
 * @size 0x1BB8
 */
void EditInit(INIT_LOOP_ARG arg);

/**
 *
 * Releases the town loop when the main loop leaves it, stopping its sounds, font, reads and sub-game.
 *
 * @mangled EditExit__Fv
 * @address 0x1AD000
 * @size 0x60
 */
void EditExit();

/**
 *
 * Runs one frame of the town loop, and returns non-zero when the main loop is to leave it.
 *
 * @mangled EditLoop__Fv
 * @address 0x1AD120
 * @size 0x22CC
 */
int EditLoop();

/**
 *
 * Steps the town's events, characters, sounds, effects and message windows for one frame; returns 0 when an event start had to wait.
 *
 * @mangled EditStep__Fv
 * @address 0x1AF4C0
 * @size 0x33C
 */
int EditStep();

/**
 *
 * Draws one frame of the town: the scene, the Georama interface and the message windows; returns 0.
 *
 * @mangled EditDraw__Fv
 * @address 0x1AF800
 * @size 0xD6C
 */
int EditDraw();

/**
 *
 * Burns the Georama parts of the main map (map 3), returning their parts and residents to the player; returns 1 when the map was processed.
 *
 * @mangled BurnEditParts__Fv
 * @address 0x1B0680
 * @size 0x150
 */
int BurnEditParts();

/**
 *
 * Loads a town map with its villagers, sounds and events; returns 1 on success and 0 when the map is unknown.
 *
 * @mangled EditMapJump__Fi
 * @address 0x1B08F0
 * @size 0x710
 */
int EditMapJump(int map_no);

/**
 *
 * Enters an interior map of the town, optionally removing the outdoor villagers; returns 1.
 *
 * @mangled EditGotoInterior__Fii
 * @address 0x1B1000
 * @size 0x140
 */
int EditGotoInterior(int interior_no, int delete_villager);

/**
 *
 * Leaves an interior map and returns to the town outside; the argument is unused; returns 1.
 *
 * @mangled EditExitInterior__Fi
 * @address 0x1B1140
 * @size 0x120
 */
int EditExitInterior(int arg);

/**
 *
 * Stores the current town's Georama layout into the save data and re-analyses the town.
 *
 * @mangled EditDataSave__Fv
 * @address 0x1B1260
 * @size 0x120
 */
void EditDataSave();

/**
 *
 * Restores the current town's Georama layout from the save data.
 *
 * @mangled EditDataLoad__Fv
 * @address 0x1B1380
 * @size 0x200
 */
void EditDataLoad();

/**
 *
 * Records the town's sixteen Georama analysis flags so later changes can be detected.
 *
 * @mangled KeepEditAnalyze__Fv
 * @address 0x1B1580
 * @size 0x80
 */
void KeepEditAnalyze();

/**
 *
 * Reports whether any Georama analysis flag differs from the recorded ones, before chapter 8.
 *
 * @mangled EditAnalyzeChanged__Fv
 * @address 0x1B1600
 * @size 0xB0
 */
int EditAnalyzeChanged();

/** End of the 3,200,000-byte read buffer that the town loop sets up. */
extern u_long128 *read_buffer_end;

/** Message window that the town's events speak through. */
extern ClsMes EventMes1;

/** Memory block holding the loaded event script. */
extern mgCMemory ScriptBuffer;

/** Memory block used when a town event loads another script. */
extern mgCMemory ScriptBuffer__2;
