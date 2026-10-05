#pragma once

#include "common.h"

/**
 * @file
 * Declares the routines that give an action character's interpreter its
 * program and the action external-function table, and the state that the
 * action script's external functions act on while a character's script runs.
 */

class CActionChara;
class CRunScript;
class CScene;
class mgCCameraFollow;
class mgCMemory;
struct RUN_SCRIPT_ENV;

/**
 *
 * The character whose action script is running, and what its external functions work with.
 *
 */
struct ACTION_INFO {
    CActionChara    *chara;  /**< Character whose script is running, and on which the external functions act. */
    mgCCameraFollow *camera; /**< Scene's main camera, whose angle turns stick input into world directions. */
    RUN_SCRIPT_ENV  *env;    /**< Throwable items that the dungeon gives the running script. */
    u8               unk_c[4];
};

STATIC_ASSERT(sizeof(ACTION_INFO) == 0x10);

/**
 * Scene in which the running action script's character acts, set each time
 * a character runs its action script.
 */
extern CScene *nowScene__2;

/**
 * Scene used by character action scripts; nowScene is the separate scene used by runscript_opcodes.
 */
extern CScene *nowScene__2;

/**
 * Character, camera and items that the action script's external functions
 * work with, set each time a character runs its action script.
 */
extern ACTION_INFO action_info;

/**
 * Gives an action character's interpreter its program, an operand stack and
 * call stack taken from an arena, and the action external-function table.
 *
 * @mangled SetActionScript__FP10CRunScriptPcP9mgCMemory
 * @address 0x2D6A40
 * @size 0x90
 */
int SetActionScript(CRunScript *script, char *program, mgCMemory *memory);

/**
 * Builds the action external-function table out of the list of external
 * functions, stopping the game on a number listed twice.
 *
 * @mangled SetActionExtendTable__Fv
 * @address 0x2D6AD0
 * @size 0x130
 */
void SetActionExtendTable();
