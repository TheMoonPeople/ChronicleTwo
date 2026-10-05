#pragma once

#include "common.h"

/**
 * @file
 * Declares the scene event runner, which loads and steps the event script of a town or dungeon scene and handles its skip, door and mode-change requests.
 */

class CCharacter2;
class ClsMes;
class CScene;
class mgCCamera;
class mgCMemory;

/**
 *
 * Requests an event script leaves for the loop that runs it, as EventLoop returns them.
 *
 */
enum EVENT_REQUEST {
    EVENT_REQUEST_NONE = 0,          /**< The event keeps running. */
    EVENT_REQUEST_END = 1,           /**< The event has finished. */
    EVENT_REQUEST_SUB_MODE = 2,      /**< The event hands control to a menu or other mode before resuming. */
    EVENT_REQUEST_GOTO = 3,          /**< The event leaves for walking or the dungeon. */
    EVENT_REQUEST_INTERIOR = 4,      /**< The event moves the player into an interior map. */
    EVENT_REQUEST_OUTSIDE = 7,       /**< The event moves the player out of an interior map. */
    EVENT_REQUEST_MAP_JUMP = 8,      /**< The event moves the player to another map. */
    EVENT_REQUEST_LOAD_SCRIPT = 15,  /**< The event loads and starts another script file. */
    EVENT_REQUEST_EDIT_MODE = 17,    /**< The event enters Georama mode. */
    EVENT_REQUEST_RESET_EDIT = 18,   /**< The event resets the town's edit event. */
    EVENT_REQUEST_RESTART_EDIT = 19, /**< The event restarts the town's edit event. */
};

/**
 *
 * How the running event script is advanced each frame.
 *
 */
enum EVENT_COMMAND_MODE {
    EVENT_COMMAND_RUN = 0,      /**< The script is resumed every frame. */
    EVENT_COMMAND_UNK_1 = 1,
    EVENT_COMMAND_UNK_2 = 2,
    EVENT_COMMAND_SUB_MODE = 3, /**< The script waits while a menu or other mode takes over. */
    EVENT_COMMAND_DOOR = 4,     /**< The door-opening sequence plays in place of the script. */
};

/**
 *
 * Progress of skipping a drama scene.
 *
 */
enum EVENT_SKIP_STATE {
    EVENT_SKIP_NONE = 0,       /**< The running event cannot be skipped. */
    EVENT_SKIP_ENABLED = 1,    /**< The skip button ends the running drama scene. */
    EVENT_SKIP_FADE_OUT = 2,   /**< The screen fades out before the skip. */
    EVENT_SKIP_WAIT_SOUND = 3, /**< The skip waits for the sound stream to close. */
};

/**
 * Scene the running event acts on.
 */
extern CScene *EventScene;

/**
 * Loads the town's NPC conversation text for the current chapter and language into a memory stack; returns 1 on success, 0 otherwise.
 *
 * @mangled LoadNpcTalkMes__FP9mgCMemory
 * @address 0x2576F0
 * @size 0x100
 */
int LoadNpcTalkMes(mgCMemory *memory);

/**
 * Forgets the loaded NPC conversation text.
 *
 * @mangled ResetNpcTalkMes__Fv
 * @address 0x2577F0
 * @size 0x20
 */
void ResetNpcTalkMes();

/**
 * Returns the type of the tour event currently under way in the town square, or 0 when there is none.
 *
 * @mangled GetSquareEvent__Fv
 * @address 0x257810
 * @size 0x60
 */
int GetSquareEvent();

/**
 * Prepares the event state for a scene and records the scene and the current projection.
 *
 * @mangled InitEvent__FP6CScene
 * @address 0x257870
 * @size 0x40
 */
void InitEvent(CScene *scene);

/**
 * Loads an event script program, allocating its stack and call data from a memory stack; with no program or memory, deletes the current program.
 *
 * @mangled SetEventScript__FPcPcP9mgCMemory
 * @address 0x2578B0
 * @size 0x90
 */
void SetEventScript(char *program, char *unused, mgCMemory *memory);

/**
 * Starts an entry of the loaded event script on a scene.
 *
 * @mangled RunEvent__FiP6CScene
 * @address 0x257940
 * @size 0x20
 */
int RunEvent(int entry, CScene *scene);

/**
 * Plays one frame of the door-opening sequence: the character's motion, the door sound, the fade and the camera; returns 1 when it has finished.
 *
 * @mangled EventDoorLoop__Fii
 * @address 0x257960
 * @size 0x390
 */
int EventDoorLoop(int frame, int use_scene_se);

/**
 * Runs the scene event requested by the last loaded script, returning its number, or -1 when none was requested.
 *
 * @mangled StartEventSyori__Fv
 * @address 0x257CF0
 * @size 0x60
 */
int StartEventSyori();

/**
 * Begins skipping the running drama scene by fading the screen out.
 *
 * @mangled SkipEventStart__Fv
 * @address 0x257D50
 * @size 0x50
 */
void SkipEventStart();

/**
 * Skips the running event: finishes its message windows, closes the sound stream and skips the script.
 *
 * @mangled SkipEvent__Fv
 * @address 0x257DA0
 * @size 0xC0
 */
void SkipEvent();

/**
 * Reports whether the running event can be skipped or is being skipped.
 *
 * @mangled CheckEventSkip__Fv
 * @address 0x257E60
 * @size 0x10
 */
bool CheckEventSkip();

/**
 * Runs one frame of the event script and its skip and door handling, and returns the event's request (an EVENT_REQUEST).
 *
 * @mangled EventLoop__Fv
 * @address 0x257E70
 * @size 0x4E0
 */
int EventLoop();

/**
 * Returns a message window of the event scene, or null when there is no event scene.
 *
 * @mangled GetEventMessage__Fi
 * @address 0x258350
 * @size 0x30
 */
ClsMes *GetEventMessage(int no);

/**
 * Returns the active camera of the event scene, or null when there is no event scene.
 *
 * @mangled GetActiveCamera__Fv
 * @address 0x258380
 * @size 0x30
 */
mgCCamera *GetActiveCamera();

/**
 * Returns a character of the event scene, or null when there is no event scene.
 *
 * @mangled GetCharacter__Fi
 * @address 0x2583B0
 * @size 0x30
 */
CCharacter2 *GetCharacter(int no);
