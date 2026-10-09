#pragma once

#include "common.h"

#include "runscript.hpp"

/**
 * @file
 * Declares the external functions a monster's script can call, the table
 * that maps script function numbers to them, and the routines that give a
 * monster's interpreter its program and that table.
 */

class CActiveMonster;
class mgCMemory;

/**
 *
 * External function numbers accepted by monster scripts.
 *
 */
enum RS_MONSTER_EXTFUNC {
    RS_MONSTER_EXT_END = -1,                       /**< Terminates the callback metadata table. */
    RS_MONSTER_EXT_NORMAL_VECTOR = 0,              /**< Normalizes a three-component vector held in script output slots. */
    RS_MONSTER_EXT_COPY_VECTOR = 1,                /**< Copies three numeric script arguments into vector output slots. */
    RS_MONSTER_EXT_ADD_VECTOR = 2,                 /**< Adds a three-component script vector to vector output slots. */
    RS_MONSTER_EXT_SUB_VECTOR = 3,                 /**< Subtracts a three-component script vector from vector output slots. */
    RS_MONSTER_EXT_SCALE_VECTOR = 4,               /**< Scales vector output slots by a numeric script argument. */
    RS_MONSTER_EXT_DIV_VECTOR = 5,                 /**< Divides vector output slots by a nonzero numeric script argument. */
    RS_MONSTER_EXT_ANGLE_CMP = 6,                  /**< Writes whether an angle is within a requested tolerance of another angle. */
    RS_MONSTER_EXT_ANGLE_LIMIT = 7,                /**< Wraps an angle output slot into the supported angle range. */
    RS_MONSTER_EXT_SQRT = 8,                       /**< Writes the square root of a script argument to an output slot. */
    RS_MONSTER_EXT_ATAN2F = 9,                     /**< Writes the angle of two script arguments to an output slot. */
    RS_MONSTER_EXT_ND_TEST = 10,                   /**< Accepts the test opcode without changing script state. */
    RS_MONSTER_EXT_GET_DIST_VECTOR = 11,           /**< Writes the length of a vector supplied by script arguments. */
    RS_MONSTER_EXT_GET_DIST_VECTOR2 = 12,          /**< Writes the distance between two positions supplied by script arguments. */
    RS_MONSTER_EXT_CALC_IP_CIRCLE_LINE = 13,       /**< Writes the intersections of a horizontal line and circle. */
    RS_MONSTER_EXT_GET_ANGLE_INNER = 14,           /**< Writes the dot product of two horizontal directions built from angles. */
    RS_MONSTER_EXT_MY_SE_PLAY = 21,                /**< Plays a positional sound effect from the active monster sound bank. */
    RS_MONSTER_EXT_MY_SE_STOP = 22,                /**< Stops a sound effect from the active monster sound bank. */
    RS_MONSTER_EXT_MONS_SE_PLAY = 23,              /**< Plays a sound from a selected monster sound bank. */
    RS_MONSTER_EXT_MONS_SE_STOP = 24,              /**< Stops a sound from a selected monster sound bank. */
    RS_MONSTER_EXT_MONS_SE_LOOP = 65,              /**< Controls a looped sound on a selected monster. */
    RS_MONSTER_EXT_SET_CAMERA_NEXT_REF = 25,       /**< Disables active camera control and sets its next focus point. */
    RS_MONSTER_EXT_SET_CAMERA_FOLLOW = 26,         /**< Enables or disables active camera follow and control. */
    RS_MONSTER_EXT_SET_CAMERA_NEXT_POS = 27,       /**< Disables active camera control and sets its next eye position. */
    RS_MONSTER_EXT_SET_CAMERA_MODE = 28,           /**< Sets the current battle-area camera mode value. */
    RS_MONSTER_EXT_SET_CAMERA_SPEED = 29,          /**< Sets the active camera movement speed. */
    RS_MONSTER_EXT_CAMERA_QUAKE = 30,              /**< Starts a battle-area camera quake with amplitude and duration. */
    RS_MONSTER_EXT_SET_CAMERA_CTRL_PARAM1 = 31,    /**< Updates active camera distance and near/far height limits. */
    RS_MONSTER_EXT_SET_CAMERA_CTRL_PARAM2 = 32,    /**< Updates active camera height and ground clearance limits. */
    RS_MONSTER_EXT_RESET_CAMERA_CTRL_PARAM = 33,   /**< Restores default active camera control distances and heights. */
    RS_MONSTER_EXT_GET_RND = 35,                   /**< Writes a random integer below the requested range. */
    RS_MONSTER_EXT_GET_RNDF = 36,                  /**< Writes a float holding a random integer below the requested range. */
    RS_MONSTER_EXT_V_PUSH = 37,                    /**< Stores an integer or float in a monster-local or shared script variable. */
    RS_MONSTER_EXT_V_POP = 38,                     /**< Reads a monster-local or shared script variable into an output slot. */
    RS_MONSTER_EXT_GET_MONSTER_NUM = 39,           /**< Writes the number of active monsters. */
    RS_MONSTER_EXT_GET_MONSTER_INDEX = 40,         /**< Writes the active monster instance identifier to an output slot. */
    RS_MONSTER_EXT_GET_MONSTER_ID = 41,            /**< Writes the active monster reference number to an output slot. */
    RS_MONSTER_EXT_GET_USERID = 42,                /**< Writes the active monster character type to an output slot. */
    RS_MONSTER_EXT_GET_USER_MONS_ID = 43,          /**< Writes the matching user monster identifier when the active user is a monster. */
    RS_MONSTER_EXT_RESET_TIMER = 44,               /**< Resets the current battle area timer. */
    RS_MONSTER_EXT_GET_TIMER = 45,                 /**< Writes the current battle area timer value. */
    RS_MONSTER_EXT_CREATE_MONSTER = 46,            /**< Creates a monster of the requested kind at an optional position and rotation. */
    RS_MONSTER_EXT_RUN_EVENT_SCRIPT = 47,          /**< Sets the event script number requested by the active monster. */
    RS_MONSTER_EXT_GET_FRAME_POS = 48,             /**< Writes the world position of a named frame on the active monster. */
    RS_MONSTER_EXT_GET_OBJ_POS = 49,               /**< Writes the world position of a named character object. */
    RS_MONSTER_EXT_GET_MAPOBJ_POS = 50,            /**< Writes the world position of a named frame on the linked map piece. */
    RS_MONSTER_EXT_SET_PAUSE = 51,                 /**< Sets or clears battle-area pause bits selected by a mask. */
    RS_MONSTER_EXT_CHECK_PAUSE = 52,               /**< Writes the active battle-area pause bits selected by a mask. */
    RS_MONSTER_EXT_GET_BIT_FLAG = 53,              /**< Writes a persistent dungeon save flag value. */
    RS_MONSTER_EXT_SET_BIT_FLAG = 54,              /**< Sets a persistent dungeon save flag value. */
    RS_MONSTER_EXT_GET_ATT_TYPE = 55,              /**< Writes the active monster attack type. */
    RS_MONSTER_EXT_GET_USER_ATTR = 56,             /**< Writes the active battle character attribute. */
    RS_MONSTER_EXT_TRANS_RESERV_IMG = 57,          /**< Copies a reserved monster image into its active image buffer. */
    RS_MONSTER_EXT_GET_STS_ATTR = 58,              /**< Writes active monster status attribute bits selected by a mask. */
    RS_MONSTER_EXT_V_PUSH2 = 59,                   /**< Stores an integer or float in the active monster secondary variable table. */
    RS_MONSTER_EXT_V_POP2 = 60,                    /**< Reads an active monster secondary variable into an output slot. */
    RS_MONSTER_EXT_SET_LOCKON_MODE = 61,           /**< Sets the battle area lock-on mode. */
    RS_MONSTER_EXT_SET_MOTION_BLUR = 62,           /**< Sets the current scene motion blur setting. */
    RS_MONSTER_EXT_GET_EVENT_INFO = 64,            /**< Writes the event stopwatch limit for its supported selector. */
    RS_MONSTER_EXT_MONS_VOL_CTRL = 66,             /**< Sets whether active monster sounds use positional volume. */
    RS_MONSTER_EXT_GET_DIST = 70,                  /**< Writes the distance from the active monster to a script position. */
    RS_MONSTER_EXT_SEARCH_AREA = 71,               /**< Searches from the active monster along a rotated horizontal direction. */
    RS_MONSTER_EXT_SEARCH_AREA2 = 108,             /**< Searches the scene along a segment between two script positions. */
    RS_MONSTER_EXT_GET_PLACE_POS = 72,             /**< Writes the active monster configured place position. */
    RS_MONSTER_EXT_SET_PLACE_POS = 73,             /**< Sets the active monster configured place position. */
    RS_MONSTER_EXT_GET_INDEX_POS = 74,             /**< Finds an active monster by instance identifier and writes its position. */
    RS_MONSTER_EXT_GET_POS = 75,                   /**< Writes the active monster position to three output slots. */
    RS_MONSTER_EXT_SET_POS = 76,                   /**< Teleports the active monster to a script position. */
    RS_MONSTER_EXT_GET_ROT = 77,                   /**< Writes rotation of the active monster or a selected monster. */
    RS_MONSTER_EXT_SET_ROT = 78,                   /**< Sets active monster rotation and clears its turn speed. */
    RS_MONSTER_EXT_SET_NEXT_ROT = 79,              /**< Sets the active monster target facing and turn speed. */
    RS_MONSTER_EXT_SET_NEXT_POS = 80,              /**< Sets an active monster movement target, speed, and arrival distance. */
    RS_MONSTER_EXT_CHK_MOVE_END = 81,              /**< Writes whether the active monster is within arrival distance of its target. */
    RS_MONSTER_EXT_RESET_MOVE = 82,                /**< Stops active monster movement by clearing its movement speed. */
    RS_MONSTER_EXT_GET_TARGET_POS = 83,            /**< Writes the target position and optionally its distance from the monster. */
    RS_MONSTER_EXT_GET_TARGET_DIST = 84,           /**< Writes the distance from the active monster to its target. */
    RS_MONSTER_EXT_GET_TARGET_ANGLE = 85,          /**< Writes the horizontal angle from the active monster to its target. */
    RS_MONSTER_EXT_GET_TARGET_REF_POS = 86,        /**< Writes a point at a given angle and distance from the target. */
    RS_MONSTER_EXT_GET_REF_DIR = 87,               /**< Classifies a point as ahead, behind, left, or right of the monster. */
    RS_MONSTER_EXT_GET_REFANGLE_POS = 88,          /**< Writes a point offset from the monster along its rotated facing direction. */
    RS_MONSTER_EXT_GET_TARGET_ROT = 89,            /**< Writes the current target character rotation to three output slots. */
    RS_MONSTER_EXT_GET_REF_ANGLE = 90,             /**< Writes the horizontal angle from the monster toward a script position. */
    RS_MONSTER_EXT_GET_HIGH = 91,                  /**< Writes zero when grounded or the monster height when airborne. */
    RS_MONSTER_EXT_GET_NEAR_MONS_POS = 92,         /**< Writes the nearest other monster position and distance. */
    RS_MONSTER_EXT_GET_TARGET_OLD_POS = 93,        /**< Writes the previous position of the active monster target. */
    RS_MONSTER_EXT_GET_TARGET_SPEED = 94,          /**< Writes the distance the active monster target moved since its previous position. */
    RS_MONSTER_EXT_CALC_MOVE_NEXT_POS = 95,        /**< Writes the next position along a requested move and its calculation result. */
    RS_MONSTER_EXT_GET_POSREF_ANGLE = 96,          /**< Writes yaw or full rotation from one position toward another. */
    RS_MONSTER_EXT_GET_ACTIVE_MONS_POS = 97,       /**< Writes a selected monster position and optionally its distance from the active monster. */
    RS_MONSTER_EXT_GET_ACTIVE_MONS_ROT = 98,       /**< Writes the rotation of a selected active monster. */
    RS_MONSTER_EXT_GET_ACTIVE_MONS_DIST = 99,      /**< Writes the distance to a selected active monster. */
    RS_MONSTER_EXT_GET_ACTIVE_MONS_ANGLE = 100,    /**< Writes the yaw angle of a selected active monster. */
    RS_MONSTER_EXT_GET_REF_ROT = 101,              /**< Writes pitch and yaw from the monster toward a script position. */
    RS_MONSTER_EXT_GET_REF_ROT2 = 102,             /**< Writes yaw or the normalized direction between two script positions. */
    RS_MONSTER_EXT_FLYING_SEARCH_AREA = 103,       /**< Searches from the monster along a horizontal flight direction. */
    RS_MONSTER_EXT_GET_HIGH2 = 104,                /**< Writes the height above collision geometry below a script position. */
    RS_MONSTER_EXT_GET_RANGE_MONS_ID = 105,        /**< Writes the ranked identifier of a different-type monster within range. */
    RS_MONSTER_EXT_GET_ENTRY_OBJ_POS = 106,        /**< Writes the position of a selected entry object on a monster. */
    RS_MONSTER_EXT_SET_OBJ = 110,                  /**< Registers a named object on the active monster at a requested index. */
    RS_MONSTER_EXT_SET_BODY = 111,                 /**< Prints the body command diagnostic. */
    RS_MONSTER_EXT_SET_DMG = 112,                  /**< Prints the damage command diagnostic. */
    RS_MONSTER_EXT_SET_DMG2 = 113,                 /**< Registers a damage hit using named motion and entry-object frames. */
    RS_MONSTER_EXT_LINK_MAP_TO_OBJECT = 114,       /**< Links the active monster to a named map part. */
    RS_MONSTER_EXT_LINK_OBJECT_TO_PIECE = 115,     /**< Links the active monster to a named piece of a map part. */
    RS_MONSTER_EXT_LOAD_EFFECT_SCRIPT = 116,       /**< Loads an effect script by number or name into the monster effect manager. */
    RS_MONSTER_EXT_SET_SCOOP = 117,                /**< Configures the active monster scoop trigger or motion interval. */
    RS_MONSTER_EXT_LOAD_RESERV_IMG = 118,          /**< Loads an image file into one of the active monster reserved image slots. */
    RS_MONSTER_EXT_SET_PRIORITY_LIMMIT = 119,      /**< Sets the active monster priority limit within its supported range. */
    RS_MONSTER_EXT_SET_MODEL_LIGHT_SWITCH = 120,   /**< Enables or disables model lighting on the root or a named frame. */
    RS_MONSTER_EXT_SET_MODEL_LIGHT_COLOR = 121,    /**< Sets model lighting color on the root or a named frame. */
    RS_MONSTER_EXT_SET_ALPHA = 122,                /**< Sets the active monster alpha value. */
    RS_MONSTER_EXT_SET_SCALE = 123,                /**< Sets the active monster scale from three script arguments. */
    RS_MONSTER_EXT_SET_INDEX_ALPHA = 124,          /**< Finds an active monster by instance identifier and sets its alpha value. */
    RS_MONSTER_EXT_SET_PALLET_ANIM = 125,          /**< Configures the active monster palette pulse color, timing, and repeat count. */
    RS_MONSTER_EXT_RESET_PALLET_ANIM = 126,        /**< Stops the active monster palette pulse and clears its elapsed time. */
    RS_MONSTER_EXT_SET_ATTRIB = 127,               /**< Sets or clears active monster attribute bits selected by a mask. */
    RS_MONSTER_EXT_SET_STATUS = 128,               /**< Sets or clears character status bits for the active monster in the scene. */
    RS_MONSTER_EXT_SET_INT_FLAG = 129,             /**< Sets or clears a bit mask on the active monster. */
    RS_MONSTER_EXT_SET_ACT_STATUS = 130,           /**< Sets the active monster action status value. */
    RS_MONSTER_EXT_SET_MUTEKI = 131,               /**< Sets the active monster invulnerability duration. */
    RS_MONSTER_EXT_SET_GRAVITY = 132,              /**< Rejects the gravity configuration opcode without changing monster state. */
    RS_MONSTER_EXT_SET_COLLISION = 133,            /**< Rejects the collision configuration opcode without changing monster state. */
    RS_MONSTER_EXT_GET_GEKIRIN = 134,              /**< Writes the active monster gekirin value. */
    RS_MONSTER_EXT_GET_PRIORITY = 135,             /**< Writes the active monster priority. */
    RS_MONSTER_EXT_SET_CLIP_DIST = 136,            /**< Sets the active monster clip distance from a script scale. */
    RS_MONSTER_EXT_SET_PIYORI_MARK = 137,          /**< Marks the current monster stun time and updates its stun effect. */
    RS_MONSTER_EXT_CHECK_PIYORI = 138,             /**< Writes the active monster stun mark value. */
    RS_MONSTER_EXT_GET_SCALE = 139,                /**< Writes the active monster scale to three output slots. */
    RS_MONSTER_EXT_GET_MONS_WIDTH = 140,           /**< Writes the monster collision radius, using a default for nonpositive values. */
    RS_MONSTER_EXT_BLOW_START = 150,               /**< Starts a monster knockback with scaled speed, deceleration, and duration. */
    RS_MONSTER_EXT_SET_DEAD_START = 151,           /**< Marks the monster dead and spawns its money, badge, and item rewards. */
    RS_MONSTER_EXT_SET_DEAD_OFF = 152,             /**< Creates monster death effects and weapon experience pickups. */
    RS_MONSTER_EXT_SET_SHROW_END = 153,            /**< Clears the monster catch state when its throw ends. */
    RS_MONSTER_EXT_GET_BASE_ATTACK = 160,          /**< Writes the active monster attack value. */
    RS_MONSTER_EXT_SET_DEF_RATE = 161,             /**< Scales active monster defense from its table value. */
    RS_MONSTER_EXT_SET_MONSTER_LIFE = 162,         /**< Sets the active monster life from an absolute value or fraction of maximum life. */
    RS_MONSTER_EXT_GET_MONSTER_LIFE = 163,         /**< Writes current monster life as an integer or fraction of maximum life. */
    RS_MONSTER_EXT_GET_NO_DAMAGE_CNT = 164,        /**< Writes the active monster damage immunity countdown. */
    RS_MONSTER_EXT_GET_ACTIVE_MONS_LIFEI = 165,    /**< Writes the integer life of a selected active monster. */
    RS_MONSTER_EXT_GET_ACTIVE_MONS_LIFEF = 166,    /**< Writes the life fraction of a selected active monster. */
    RS_MONSTER_EXT_SET_ACTIVE_MONS_LIFEI = 167,    /**< Sets the integer life of a selected active monster. */
    RS_MONSTER_EXT_SET_ACTIVE_MONS_LIFEF = 168,    /**< Sets a selected active monster life from a fraction of its maximum. */
    RS_MONSTER_EXT_GET_ACTIVE_MONS_MAX_LIFE = 169, /**< Writes the maximum life of a selected active monster. */
    RS_MONSTER_EXT_SET_DAMAGE_SCORE = 170,         /**< Shows a damage number above the selected monster. */
    RS_MONSTER_EXT_GET_MONS_GRADE = 171,           /**< Writes the grade of a selected active monster. */
    RS_MONSTER_EXT_SET_ESCAPE_RATE = 173,          /**< Scales the selected monster escape rates from their base values. */
    RS_MONSTER_EXT_SET_GUARD_RATE = 172,           /**< Scales the selected monster guard rate from its base value. */
    RS_MONSTER_EXT_SET_EXT_PARAM_RATE = 174,       /**< Scales selected monster extension parameters from their base values. */
    RS_MONSTER_EXT_GET_BOSS_FLAG = 175,            /**< Writes whether the active monster base data marks it as a boss. */
    RS_MONSTER_EXT_SET_INDEXOBJ_SIZE = 176,        /**< Sets the size value on a selected monster entry object. */
    RS_MONSTER_EXT_GET_INDEXOBJ_SIZE = 177,        /**< Writes the size value from a selected monster entry object. */
    RS_MONSTER_EXT_RESET_MOTION = 180,             /**< Resets the active monster motion. */
    RS_MONSTER_EXT_SET_MOS = 182,                  /**< Starts a named monster motion with optional step and mode. */
    RS_MONSTER_EXT_CHECK_MOS_END = 183,            /**< Writes whether the current or named monster motion has finished. */
    RS_MONSTER_EXT_NOW_MOS_WAIT = 184,             /**< Writes the frame wait of the current or named monster motion. */
    RS_MONSTER_EXT_GET_MOS_STATUS = 185,           /**< Writes the status of the current or named monster motion. */
    RS_MONSTER_EXT_ESM_CREATE = 191,               /**< Creates a named effect for this monster and optionally returns its slot. */
    RS_MONSTER_EXT_ESM_FINISH = 192,               /**< Sets an effect script program for this monster effect slot. */
    RS_MONSTER_EXT_ESM_DELETE = 193,               /**< Deletes an effect from this monster effect slot. */
    RS_MONSTER_EXT_ESM_SET_VECT1 = 194,            /**< Sets the first effect script vector for this monster. */
    RS_MONSTER_EXT_ESM_GET_VECT1 = 195,            /**< Writes the first effect script vector to output slots. */
    RS_MONSTER_EXT_ESM_SET_VECT2 = 196,            /**< Sets the second effect script vector for this monster. */
    RS_MONSTER_EXT_ESM_GET_VECT2 = 197,            /**< Writes the second effect script vector to output slots. */
    RS_MONSTER_EXT_ESM_SET_TARGET_ID = 198,        /**< Sets an effect target identifier for this monster. */
    RS_MONSTER_EXT_ESM_GET_TARGET_ID = 199,        /**< Writes an effect target identifier and returns the manager lookup status. */
    RS_MONSTER_EXT_ESM_SET_USER_ID = 200,          /**< Sets an effect user identifier for this monster. */
    RS_MONSTER_EXT_ESM_GET_USER_ID = 201,          /**< Writes an effect user identifier to an output slot. */
    RS_MONSTER_EXT_ESM_SET_VALUE = 202,            /**< Sets an integer or float parameter on a monster effect slot. */
    RS_MONSTER_EXT_SW_EFFECT = 203,                /**< Configures a sword effect for a monster motion and pair of frames. */
    RS_MONSTER_EXT_ESM_GET_NOTUESD_TEXB = 204,     /**< Writes an unused texture block number from the effect manager. */
    RS_MONSTER_EXT_ESM_ADD_TEXB = 205,             /**< Advances the effect manager texture block reservation. */
    RS_MONSTER_EXT_SHOT_ROCKET_LAUNCHER = 206,     /**< Launches a monster rocket with position, direction, optional homing, and damage. */
    RS_MONSTER_EXT_ESM_ALL_CLEAR = 207,            /**< Clears effects associated with the requested character identifier. */
    RS_MONSTER_EXT_SET_MAPOBJ_SHOW = 63,           /**< Shows or hides a named map part or one of its pieces. */
    RS_MONSTER_EXT_LIMIT = 256,                    /**< Number of callback dispatch slots. */
};

/**
 *
 * Pairs one external function a monster script can call with the number
 * the script calls it by.
 *
 */
struct RS_EXTFUNC_INFO {
    int (*func)(RS_STACKDATA *, int); /**< External function to run; null ends the list. */
    int no;                           /**< Number the script calls the function by. */
};

STATIC_ASSERT(sizeof(RS_EXTFUNC_INFO) == 0x8);

/**
 *
 * Monster whose script is running, and on which the external functions
 * act unless they are given a monster of their own.
 *
 */
extern CActiveMonster *nowMonster;

/**
 *
 * Gives a monster's interpreter its program, an operand stack and call
 * stack taken from an arena, and the monster external-function table.
 *
 * @mangled SetMonsterScript__FP10CRunScriptPcP9mgCMemory
 * @address 0x1E90A0
 * @size 0x88
 */
int SetMonsterScript(CRunScript *script, char *program, mgCMemory *memory);

/**
 *
 * Builds the monster external-function table out of the list of
 * external functions, stopping the game on a number listed twice.
 *
 * @mangled SetMonsterExtendTable__Fv
 * @address 0x1E9130
 * @size 0x12C
 */
void SetMonsterExtendTable();
