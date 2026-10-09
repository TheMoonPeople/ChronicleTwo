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
 * External function numbers understood by the action-script interpreter.
 *
 */
enum ACTION_EXT_NUMBER {
    ACTION_EXT_END = -1,                /**< Ends the external function definition list. */
    ACTION_EXT_INIT_SCRIPT = 0,         /**< Selects _INIT_SCRIPT. */
    ACTION_EXT_PROG_SET = 1,            /**< Selects _PROG_SET. */
    ACTION_EXT_PROG_GET = 2,            /**< Selects _PROG_GET. */
    ACTION_EXT_GET_ATTK_TYPE = 3,       /**< Selects _GET_ATTK_TYPE. */
    ACTION_EXT_GET_MOVE_TYPE = 4,       /**< Selects _GET_MOVE_TYPE. */
    ACTION_EXT_SET_MOVE_SPEED = 5,      /**< Selects _SET_MOVE_SPEED. */
    ACTION_EXT_SET_PALLET = 30,         /**< Selects _SET_PALLET. */
    ACTION_EXT_CHECK_EQUIP = 31,        /**< Selects _CHECK_EQUIP. */
    ACTION_EXT_CAMERA_QUAKE = 32,       /**< Selects _CAMERA_QUAKE. */
    ACTION_EXT_CHECK_PAUSE = 33,        /**< Selects _CHECK_PAUSE. */
    ACTION_EXT_GET_STATUS_ATTR = 34,    /**< Selects _GET_STATUS_ATTR. */
    ACTION_EXT_SE_PLAY = 35,            /**< Selects _SE_PLAY. */
    ACTION_EXT_SE_LOOP_PLAY = 36,       /**< Selects _SE_LOOP_PLAY. */
    ACTION_EXT_GET_SHOT_TYPE = 37,      /**< Selects _GET_SHOT_TYPE. */
    ACTION_EXT_GET_MONS_ID = 38,        /**< Selects _GET_MONS_ID. */
    ACTION_EXT_GET_FRONT_VEC = 39,      /**< Selects _GET_FRONT_VEC. */
    ACTION_EXT_GET_PADON = 40,          /**< Selects _GET_PADON. */
    ACTION_EXT_GET_PADDOWN = 41,        /**< Selects _GET_PADDOWN. */
    ACTION_EXT_GET_PADUP = 42,          /**< Selects _GET_PADUP. */
    ACTION_EXT_GET_BTN = 43,            /**< Selects _GET_BTN. */
    ACTION_EXT_GET_PAD_HISTORY = 45,    /**< Selects _GET_PAD_HISTORY. */
    ACTION_EXT_RESET_PAD_HISTORY = 46,  /**< Selects _RESET_PAD_HISTORY. */
    ACTION_EXT_GET_ACUMU_PAD = 47,      /**< Selects _GET_ACUMU_PAD. */
    ACTION_EXT_RESET_ACUMU_PAD = 48,    /**< Selects _RESET_ACUMU_PAD. */
    ACTION_EXT_RUN_MAIN_MOVE = 49,      /**< Selects _RUN_MAIN_MOVE. */
    ACTION_EXT_RUN_SHROW_MOVE = 50,     /**< Selects _RUN_SHROW_MOVE. */
    ACTION_EXT_RUN_TAME_MOVE = 51,      /**< Selects _RUN_TAME_MOVE. */
    ACTION_EXT_RUN_HOLD_MOVE = 52,      /**< Selects _RUN_HOLD_MOVE. */
    ACTION_EXT_SET_MENU_FLAG = 59,      /**< Selects _SET_MENU_FLAG. */
    ACTION_EXT_GET_POS = 53,            /**< Selects _GET_POS. */
    ACTION_EXT_GET_ROT = 61,            /**< Selects _GET_ROT. */
    ACTION_EXT_CHECK_FRONT_KEY = 54,    /**< Selects _CHECK_FRONT_KEY. */
    ACTION_EXT_CHECK_BACK_KEY = 55,     /**< Selects _CHECK_BACK_KEY. */
    ACTION_EXT_SET_BLOW_ANGLE = 56,     /**< Selects _SET_BLOW_ANGLE. */
    ACTION_EXT_SET_BLOW_MOVE = 57,      /**< Selects _SET_BLOW_MOVE. */
    ACTION_EXT_BLOW_START = 58,         /**< Selects _BLOW_START. */
    ACTION_EXT_RUN_ROBO_MOVE = 60,      /**< Selects _RUN_ROBO_MOVE. */
    ACTION_EXT_SET_DMG2 = 71,           /**< Selects _SET_DMG2. */
    ACTION_EXT_SET_OBJ = 72,            /**< Selects _SET_OBJ. */
    ACTION_EXT_SET_BODY = 73,           /**< Selects _SET_BODY. */
    ACTION_EXT_SW_EFFECT = 75,          /**< Selects _SW_EFFECT. */
    ACTION_EXT_SET_SND = 76,            /**< Selects _SET_SND. */
    ACTION_EXT_SET_ACCUME_FX = 77,      /**< Selects _SET_ACCUME_FX. */
    ACTION_EXT_SET_ACCUME_FLAG = 78,    /**< Selects _SET_ACCUME_FLAG. */
    ACTION_EXT_GET_MONSTER_NOWSTS = 90, /**< Selects _GET_MONSTER_NOWSTS. */
    ACTION_EXT_SET_MURDEROUS = 91,      /**< Selects _SET_MURDEROUS. */
    ACTION_EXT_GET_TRG_DISTANCE = 92,   /**< Selects _GET_TRG_DISTANCE. */
    ACTION_EXT_SET_TRG_ANGLE = 93,      /**< Selects _SET_TRG_ANGLE. */
    ACTION_EXT_SET_GUARD_FLAG = 94,     /**< Selects _SET_GUARD_FLAG. */
    ACTION_EXT_SET_MUTEKI = 95,         /**< Selects _SET_MUTEKI. */
    ACTION_EXT_CHECK_HAND_OBJ = 96,     /**< Selects _CHECK_HAND_OBJ. */
    ACTION_EXT_SET_ITEM_USED = 97,      /**< Selects _SET_ITEM_USED. */
    ACTION_EXT_THROW_HAND_OBJECT = 98,  /**< Selects _THROW_HAND_OBJECT. */
    ACTION_EXT_CHECK_CATCH = 99,        /**< Selects _CHECK_CATCH. */
    ACTION_EXT_RELEASE_OBJ = 100,       /**< Selects _RELEASE_OBJ. */
    ACTION_EXT_SET_SHOT = 101,          /**< Selects _SET_SHOT. */
    ACTION_EXT_SET_SPECIAL_SHOT = 105,  /**< Selects _SET_SPECIAL_SHOT. */
    ACTION_EXT_SHOT = 102,              /**< Selects _SHOT. */
    ACTION_EXT_GET_OBJECT_POS = 103,    /**< Selects _GET_OBJECT_POS. */
    ACTION_EXT_SET_DIR_GUN = 104,       /**< Selects _SET_DIR_GUN. */
    ACTION_EXT_GET_NOW_HP_RATE = 106,   /**< Selects _GET_NOW_HP_RATE. */
    ACTION_EXT_SET_BOMB = 107,          /**< Selects _SET_BOMB. */
    ACTION_EXT_GET_ACTION_CODE = 108,   /**< Selects _GET_ACTION_CODE. */
    ACTION_EXT_GET_ATTK_POINT = 109,    /**< Selects _GET_ATTK_POINT. */
    ACTION_EXT_GET_RING_COLOR = 110,    /**< Selects _GET_RING_COLOR. */
    ACTION_EXT_SET_MOS = 130,           /**< Selects _SET_MOS. */
    ACTION_EXT_CHECK_MOS_END = 131,     /**< Selects _CHECK_MOS_END. */
    ACTION_EXT_NOW_MOS_WAIT = 132,      /**< Selects _NOW_MOS_WAIT. */
    ACTION_EXT_GET_MOS_STATUS = 133,    /**< Selects _GET_MOS_STATUS. */
    ACTION_EXT_SET_XCHG_STEP = 134,     /**< Selects _SET_XCHG_STEP. */
    ACTION_EXT_SET_MOS_STEP = 135,      /**< Selects _SET_MOS_STEP. */
    ACTION_EXT_TRG_ON_MOS = 136,        /**< Selects _TRG_ON_MOS. */
    ACTION_EXT_RESET_MOS = 137,         /**< Selects _RESET_MOS. */
    ACTION_EXT_SET_DEFAULT_MOS = 138,   /**< Selects _SET_DEFAULT_MOS. */
    ACTION_EXT_SET_NEBA2 = 140,         /**< Selects _SET_NEBA2. */
    ACTION_EXT_NOW_MOS_CHGWAIT = 139,   /**< Selects _NOW_MOS_CHGWAIT. */
    ACTION_EXT_ESM_CREATE = 150,        /**< Selects _ESM_CREATE. */
    ACTION_EXT_ESM_SET_VECT1 = 151,     /**< Selects _ESM_SET_VECT1. */
    ACTION_EXT_ESM_SET_VECT2 = 152,     /**< Selects _ESM_SET_VECT2. */
    ACTION_EXT_ESM_FINISH = 153,        /**< Selects _ESM_FINISH. */
    ACTION_EXT_ESM_DELETE = 154,        /**< Selects _ESM_DELETE. */
    ACTION_EXT_ESM_SET_VALUE = 155,     /**< Selects _ESM_SET_VALUE. */
};

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
 *
 * Scene in which the running action script's character acts, set each time
 * a character runs its action script.
 *
 */
extern CScene *nowScene__2;

/**
 *
 * Character, camera and items that the action script's external functions
 * work with, set each time a character runs its action script.
 *
 */
extern ACTION_INFO action_info;

/**
 *
 * Gives an action character's interpreter its program, an operand stack and
 * call stack taken from an arena, and the action external-function table.
 *
 * @mangled SetActionScript__FP10CRunScriptPcP9mgCMemory
 * @address 0x2D6A40
 * @size 0x90
 */
int SetActionScript(CRunScript *script, char *program, mgCMemory *memory);

/**
 *
 * Builds the action external-function table out of the list of external
 * functions, stopping the game on a number listed twice.
 *
 * @mangled SetActionExtendTable__Fv
 * @address 0x2D6AD0
 * @size 0x130
 */
void SetActionExtendTable();
