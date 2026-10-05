#pragma once

#include "common.h"

/**
 * @file
 * Declares what a scene uses to place, step and draw its villagers and the
 * game objects of its maps: the meanings of a character slot's status bits,
 * the character slots set aside for villagers and game objects, the motions
 * a villager plays, and the table of game objects placed on each map.
 */

/**
 * Status bits of a scene character slot, above the SCENE_DATA_STATUS bits,
 * that decide how the slot's character and its shadow are drawn.
 */
enum SCENE_CHARA_STATUS {
    SCENE_CHARA_NO_SHADOW   = 1 << 3, /**< The character's shadow is not drawn. */
    SCENE_CHARA_HIDE        = 1 << 4, /**< Neither the character nor its shadow is drawn. */
    SCENE_CHARA_EXCLAMATION = 1 << 5, /**< An exclamation mark is drawn above the character. */
    SCENE_CHARA_NO_LIGHTING = 1 << 6, /**< The character is drawn without the scene's character lighting and the map's lights. */
    SCENE_CHARA_NO_FADE     = 1 << 7, /**< The character is drawn with its fade turned off. */
    SCENE_CHARA_NO_DIST     = 1 << 8, /**< The character is drawn without its near and far draw distances. */
    SCENE_CHARA_NO_MODEL    = 1 << 9, /**< The character is not drawn; its shadow still is. */
};

/**
 * Scene character slots set aside for villagers and for the game objects of
 * a map, and the counts of each range.
 */
enum SCENE_VILLAGER_SLOT {
    SCENE_VILLAGER_SLOT_TOP       = 8,    /**< First slot of the villagers of the main map. */
    SCENE_VILLAGER_SLOT_NUM       = 16,   /**< Number of slots for the villagers of the main map. */
    SCENE_SUB_VILLAGER_SLOT_TOP   = 0x18, /**< First slot of the villagers of the sub map. */
    SCENE_SUB_VILLAGER_SLOT_NUM   = 8,    /**< Number of slots for the villagers of the sub map. */
    SCENE_TALK_SLOT_END           = 0x40, /**< End of the slots searched for a character to talk to or look at. */
    SCENE_GAMEOBJ_SLOT_TG         = 0x78, /**< Slot of the circle of a coloured marker game object. */
    SCENE_GAMEOBJ_SLOT_TG_BASE    = 0x79, /**< Slot of the base of a coloured marker game object. */
    SCENE_GAMEOBJ_SLOT_SAVEPOINT  = 0x7A, /**< Slot of the save point game object. */
    SCENE_GAMEOBJ_SLOT_BOOK       = 0x7B, /**< Slot of the book that stands with the save point. */
    SCENE_CHARA_SLOT_NUM          = 0x80, /**< Number of character slots of a scene. */
};

/**
 * Memory stacks of a scene that villagers are loaded into.
 */
enum SCENE_VILLAGER_STACK {
    SCENE_STACK_VILLAGER     = 2, /**< Stack of the villagers of the main map. */
    SCENE_STACK_SUB_VILLAGER = 4, /**< Stack of the villagers of the sub map. */
};

/**
 * Motions a villager plays, numbered as the motion names a villager's
 * character holds them under.
 */
enum VILLAGER_MOTION {
    VILLAGER_MOTION_NONE       = -1, /**< No motion. */
    VILLAGER_MOTION_STAND      = 0,  /**< Standing ("立ち"). */
    VILLAGER_MOTION_WALK       = 1,  /**< Walking ("歩き"). */
    VILLAGER_MOTION_RUN        = 2,  /**< Running ("走り"). */
    VILLAGER_MOTION_TALK       = 3,  /**< Talking ("会話"). */
    VILLAGER_MOTION_SIT        = 4,  /**< Sitting ("座り"); standing is played instead by a villager without it. */
    VILLAGER_MOTION_CAMERA_IN  = 5,  /**< Turning to the camera ("カメラ入り"). */
    VILLAGER_MOTION_CAMERA     = 6,  /**< Facing the camera ("カメラ"). */
    VILLAGER_MOTION_CAMERA_OUT = 7,  /**< Turning back from the camera ("カメラ戻り"). */
    VILLAGER_MOTION_SPECIAL    = 8,  /**< The villager's own special motion ("特別"). */
    VILLAGER_MOTION_NUM        = 9,  /**< Number of villager motions. */
};

/**
 * Kinds of game object placed on a map, each loaded as two characters.
 */
enum GAMEOBJ_TYPE {
    GAMEOBJ_TYPE_NONE      = 0, /**< Ends the game object table. */
    GAMEOBJ_TYPE_TG_RED    = 1, /**< Red marker (effect/tg_maru_red.chr over effect/tg_sita_red.chr); not loaded in chapter 8. */
    GAMEOBJ_TYPE_TG_BLUE   = 2, /**< Blue marker (effect/tg_maru_blue.chr over effect/tg_sita_blue.chr); not loaded in chapter 8. */
    GAMEOBJ_TYPE_SAVEPOINT = 3, /**< Save point (effect/savepoint.chr) with its book (effect/book.chr). */
};

/**
 * Most places a single game object table entry can put its game object at.
 */
#define GAMEOBJ_PLACE_MAX 4

/**
 * Place of one game object on its map.
 */
struct GAMEOBJ_PLACE {
    float pos[3]; /**< Position of the game object on the map. */
    float rot_y;  /**< Rotation, in radians, of the game object about the vertical axis. */
};

STATIC_ASSERT(sizeof(GAMEOBJ_PLACE) == 0x10);

/**
 * Entry of the game object table, giving the kind of game object a map
 * shows and the places it shows it at.
 */
struct GAMEOBJ_INFO {
    s32           map_no;                   /**< Number of the map the game object is on; below zero ends the table. */
    s32           type;                     /**< Kind of game object (GAMEOBJ_TYPE). */
    s32           place_num;                /**< Number of entries of place in use. */
    s32           unk_c;
    GAMEOBJ_PLACE place[GAMEOBJ_PLACE_MAX]; /**< Places the game object is drawn at. */
};

STATIC_ASSERT(sizeof(GAMEOBJ_INFO) == 0x50);

class CCharacter2;
class mgCFrame;

int GetChrFileSize(unsigned int *pack, int file_size);
int GetObjectNameList(char *names, CCharacter2 *chara, mgCFrame **frames, int max);
int GetMotionID(char *name);
void SetCharaMotion(CCharacter2 *chara, int motion_id, int mode);
