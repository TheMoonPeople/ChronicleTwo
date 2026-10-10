#pragma once

#include "common.h"

#include <libvu0.h>

#include "dng_effect.hpp"
#include "runscript.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"

/**
 * @file
 * Declares the town and dungeon event state: the event information block
 * that event scripts fill in, the event object handles through which scripts
 * move characters, objects, sprites, frames and function points, the event
 * screen effects, the argument lists that event scripts load, and the
 * routines that set up, step, draw and finish an event.
 */

class CCharacter2;
class CEventSprite2;
class CEventSpriteMother;
class CFuncPoint;
class CMapParts;
class CMarker;
class CObject;
class CRain;
class mgCCamera;
class mgCFrame;
class mgCMemory;
class mgCTexture;
class ClsMes;

/**
 *
 * Extents of the running event's local state, mouth-animation names and sequence tables.
 *
 */
enum EventStorageExtent {
    EVENT_LOCAL_NUM = 0x40, /**< Words in each event-local flag and counter array. */
    PAKU_NAME_SIZE = 0x40,  /**< Bytes in each mouth-animation or motion name. */
    SEQ_NODE_NUM = 0x100,   /**< Command entries in each event sequence table. */
};

/**
 *
 * Numeric identifiers of external event script commands.
 *
 */
enum EventExternalCommand {
    EVENT_EXT_GET_PADON = 0,                       /**< Runs the _GET_PADON command. */
    EVENT_EXT_GET_PADDOWN = 1,                     /**< Runs the _GET_PADDOWN command. */
    EVENT_EXT_GET_PADUP = 2,                       /**< Runs the _GET_PADUP command. */
    EVENT_EXT_GET_APAD = 3,                        /**< Runs the _GET_APAD command. */
    EVENT_EXT_GOTO_INTERIOR = 6,                   /**< Runs the _GOTO_INTERIOR command. */
    EVENT_EXT_INITIALIZE = 8,                      /**< Runs the _INITIALIZE command. */
    EVENT_EXT_GOTO_OUTSIDE = 7,                    /**< Runs the _GOTO_OUTSIDE command. */
    EVENT_EXT_LOAD_CHARA = 9,                      /**< Runs the _LOAD_CHARA command. */
    EVENT_EXT_CHARA_ACTIVE = 10,                   /**< Runs the _CHARA_ACTIVE command. */
    EVENT_EXT_CLEAR_STACK = 11,                    /**< Runs the _CLEAR_STACK command. */
    EVENT_EXT_ASSIGN_STACK = 12,                   /**< Runs the _ASSIGN_STACK command. */
    EVENT_EXT_SET_FLAG = 13,                       /**< Runs the _SET_FLAG command. */
    EVENT_EXT_GET_FLAG = 14,                       /**< Runs the _GET_FLAG command. */
    EVENT_EXT_SET_CNT = 15,                        /**< Runs the _SET_CNT command. */
    EVENT_EXT_GET_CNT = 16,                        /**< Runs the _GET_CNT command. */
    EVENT_EXT_SET_CURRENT_DIR = 17,                /**< Runs the _SET_CURRENT_DIR command. */
    EVENT_EXT_DELETE_CHARA = 18,                   /**< Runs the _DELETE_CHARA command. */
    EVENT_EXT_LOAD_MOTION = 19,                    /**< Runs the _LOAD_MOTION command. */
    EVENT_EXT_MAP_JUMP = 20,                       /**< Runs the _MAP_JUMP command. */
    EVENT_EXT_SET_RAIN = 21,                       /**< Runs the _SET_RAIN command. */
    EVENT_EXT_DEL_EXT_MOTION = 22,                 /**< Runs the _DEL_EXT_MOTION command. */
    EVENT_EXT_SET_MARKER = 23,                     /**< Runs the _SET_MARKER command. */
    EVENT_EXT_SET_WORLD_COORD = 24,                /**< Runs the _SET_WORLD_COORD command. */
    EVENT_EXT_FINISH = 25,                         /**< Runs the _FINISH command. */
    EVENT_EXT_GET_DUN_WORLD_COORD = 26,            /**< Runs the _GET_DUN_WORLD_COORD command. */
    EVENT_EXT_LOAD_IMG = 27,                       /**< Runs the _LOAD_IMG command. */
    EVENT_EXT_DEL_IMG = 28,                        /**< Runs the _DEL_IMG command. */
    EVENT_EXT_SET_DNG_MAP = 29,                    /**< Runs the _SET_DNG_MAP command. */
    EVENT_EXT_LOAD_ITEM = 30,                      /**< Runs the _LOAD_ITEM command. */
    EVENT_EXT_GOTO_USE_ITEM = 31,                  /**< Runs the _GOTO_USE_ITEM command. */
    EVENT_EXT_SET_LOCAL_FLAG = 32,                 /**< Runs the _SET_LOCAL_FLAG command. */
    EVENT_EXT_GET_LOCAL_FLAG = 33,                 /**< Runs the _GET_LOCAL_FLAG command. */
    EVENT_EXT_GOTO_SELECT_PARTY = 34,              /**< Runs the _GOTO_SELECT_PARTY command. */
    EVENT_EXT_SET_LOADBG_FILE = 35,                /**< Runs the _SET_LOADBG_FILE command. */
    EVENT_EXT_CHECK_LOADBG_FILE = 36,              /**< Runs the _CHECK_LOADBG_FILE command. */
    EVENT_EXT_GET_TB_ITEMNO = 37,                  /**< Runs the _GET_TB_ITEMNO command. */
    EVENT_EXT_SET_TB_STATUS = 38,                  /**< Runs the _SET_TB_STATUS command. */
    EVENT_EXT_SET_TB_ANGLE = 39,                   /**< Runs the _SET_TB_ANGLE command. */
    EVENT_EXT_ADD_ITEM = 40,                       /**< Runs the _ADD_ITEM command. */
    EVENT_EXT_GET_ITEM_TYPE = 41,                  /**< Runs the _GET_ITEM_TYPE command. */
    EVENT_EXT_GET_ITEM_SPACE = 42,                 /**< Runs the _GET_ITEM_SPACE command. */
    EVENT_EXT_GET_ADJUST_POLYGON_SCALE = 43,       /**< Runs the _GET_ADJUST_POLYGON_SCALE command. */
    EVENT_EXT_LOAD_MOVIE = 44,                     /**< Runs the _LOAD_MOVIE command. */
    EVENT_EXT_INIT_LOCAL_CNT = 45,                 /**< Runs the _INIT_LOCAL_CNT command. */
    EVENT_EXT_SET_CROSSFADE = 46,                  /**< Runs the _SET_CROSSFADE command. */
    EVENT_EXT_SET_TIME = 47,                       /**< Runs the _SET_TIME command. */
    EVENT_EXT_SET_ACTIVE_LIGHT = 48,               /**< Runs the _SET_ACTIVE_LIGHT command. */
    EVENT_EXT_SET_PAKU_ANIM = 49,                  /**< Runs the _SET_PAKU_ANIM command. */
    EVENT_EXT_RESET_PAKU_ANIM = 50,                /**< Runs the _RESET_PAKU_ANIM command. */
    EVENT_EXT_TRG_PAKU_ANIM = 51,                  /**< Runs the _TRG_PAKU_ANIM command. */
    EVENT_EXT_RESET_CAMERA = 52,                   /**< Runs the _RESET_CAMERA command. */
    EVENT_EXT_GET_ACTIVE_CHR_NO = 53,              /**< Runs the _GET_ACTIVE_CHR_NO command. */
    EVENT_EXT_SET_ACTIVE_CHR_NO = 54,              /**< Runs the _SET_ACTIVE_CHR_NO command. */
    EVENT_EXT_DNG_SET_FLOOR_ID = 55,               /**< Runs the _DNG_SET_FLOOR_ID command. */
    EVENT_EXT_DNG_GET_FLOOR_ID = 56,               /**< Runs the _DNG_GET_FLOOR_ID command. */
    EVENT_EXT_SET_PAKU_MOTION = 57,                /**< Runs the _SET_PAKU_MOTION command. */
    EVENT_EXT_RESET_PAKU_MOTION = 58,              /**< Runs the _RESET_PAKU_MOTION command. */
    EVENT_EXT_TRG_PAKU_MOTION = 59,                /**< Runs the _TRG_PAKU_MOTION command. */
    EVENT_EXT_SET_BG_COLOR = 60,                   /**< Runs the _SET_BG_COLOR command. */
    EVENT_EXT_GOTO_DNG_MAP = 61,                   /**< Runs the _GOTO_DNG_MAP command. */
    EVENT_EXT_GOTO_DNG = 62,                       /**< Runs the _GOTO_DNG command. */
    EVENT_EXT_GOTO_EDIT = 63,                      /**< Runs the _GOTO_EDIT command. */
    EVENT_EXT_GET_MENU_PARAM = 64,                 /**< Runs the _GET_MENU_PARAM command. */
    EVENT_EXT_LOAD_CHARA_NPC = 65,                 /**< Runs the _LOAD_CHARA_NPC command. */
    EVENT_EXT_AUTO_SET_TREASURE_BOX = 66,          /**< Runs the _AUTO_SET_TREASURE_BOX command. */
    EVENT_EXT_AUTO_SET_MONSTER = 67,               /**< Runs the _AUTO_SET_MONSTER command. */
    EVENT_EXT_LOAD_DUNGEON_MAP_FILE = 68,          /**< Runs the _LOAD_DUNGEON_MAP_FILE command. */
    EVENT_EXT_LOAD_MONSTER_FILE = 69,              /**< Runs the _LOAD_MONSTER_FILE command. */
    EVENT_EXT_GET_NPC_STATUS = 70,                 /**< Runs the _GET_NPC_STATUS command. */
    EVENT_EXT_SET_NPC_STATUS = 71,                 /**< Runs the _SET_NPC_STATUS command. */
    EVENT_EXT_GET_NOW_PARTY_CHARA = 72,            /**< Runs the _GET_NOW_PARTY_CHARA command. */
    EVENT_EXT_SET_LOCAL_CNT = 73,                  /**< Runs the _SET_LOCAL_CNT command. */
    EVENT_EXT_GET_LOCAL_CNT = 74,                  /**< Runs the _GET_LOCAL_CNT command. */
    EVENT_EXT_GET_LOCAL_CNT2 = 75,                 /**< Runs the _GET_LOCAL_CNT2 command. */
    EVENT_EXT_GET_TRAIN_NPC_POS = 76,              /**< Runs the _GET_TRAIN_NPC_POS command. */
    EVENT_EXT_GOTO_DRAW_CHAPTER = 77,              /**< Runs the _GOTO_DRAW_CHAPTER command. */
    EVENT_EXT_SET_PROJECTION = 78,                 /**< Runs the _SET_PROJECTION command. */
    EVENT_EXT_GET_PROJECTION = 79,                 /**< Runs the _GET_PROJECTION command. */
    EVENT_EXT_SET_FADE_IN = 80,                    /**< Runs the _SET_FADE_IN command. */
    EVENT_EXT_SET_FADE_OUT = 81,                   /**< Runs the _SET_FADE_OUT command. */
    EVENT_EXT_DNG_DEBUG_COMMAND = 82,              /**< Runs the _DNG_DEBUG_COMMAND command. */
    EVENT_EXT_CD_SEEK = 83,                        /**< Runs the _CD_SEEK command. */
    EVENT_EXT_GET_ROT_LOOK_POS = 84,               /**< Runs the _GET_ROT_LOOK_POS command. */
    EVENT_EXT_SET_MOTION_BLUR = 85,                /**< Runs the _SET_MOTION_BLUR command. */
    EVENT_EXT_LOAD_SCRIPT = 86,                    /**< Runs the _LOAD_SCRIPT command. */
    EVENT_EXT_SET_TALK_CAMERA = 87,                /**< Runs the _SET_TALK_CAMERA command. */
    EVENT_EXT_HIT_EFFECT = 88,                     /**< Runs the _HIT_EFFECT command. */
    EVENT_EXT_COPY_CHARA = 89,                     /**< Runs the _COPY_CHARA command. */
    EVENT_EXT_GET_START_BUTTON = 90,               /**< Runs the _GET_START_BUTTON command. */
    EVENT_EXT_MOVE_INTERIOR = 91,                  /**< Runs the _MOVE_INTERIOR command. */
    EVENT_EXT_GET_MONSTER_TALK_DATA = 92,          /**< Runs the _GET_MONSTER_TALK_DATA command. */
    EVENT_EXT_FUNC_POINT_SHOW = 93,                /**< Runs the _FUNC_POINT_SHOW command. */
    EVENT_EXT_GET_NOW_MAP_NO = 94,                 /**< Runs the _GET_NOW_MAP_NO command. */
    EVENT_EXT_GET_NOW_SUBMAP_NO = 95,              /**< Runs the _GET_NOW_SUBMAP_NO command. */
    EVENT_EXT_GET_OLD_MAP_NO = 96,                 /**< Runs the _GET_OLD_MAP_NO command. */
    EVENT_EXT_GET_OLD_SUBMAP_NO = 97,              /**< Runs the _GET_OLD_SUBMAP_NO command. */
    EVENT_EXT_SET_RAIN_CHARA_NO = 98,              /**< Runs the _SET_RAIN_CHARA_NO command. */
    EVENT_EXT_GET_EDIT_PARTS_POS = 99,             /**< Runs the _GET_EDIT_PARTS_POS command. */
    EVENT_EXT_GET_CHARA_POS = 100,                 /**< Runs the _GET_CHARA_POS command. */
    EVENT_EXT_GET_CHARA_TALK_POS = 101,            /**< Runs the _GET_CHARA_TALK_POS command. */
    EVENT_EXT_TURN_CHARA = 102,                    /**< Runs the _TURN_CHARA command. */
    EVENT_EXT_SET_CHARA_POS = 103,                 /**< Runs the _SET_CHARA_POS command. */
    EVENT_EXT_SET_CHARA_ROT = 104,                 /**< Runs the _SET_CHARA_ROT command. */
    EVENT_EXT_GET_CHARA_ROT = 105,                 /**< Runs the _GET_CHARA_ROT command. */
    EVENT_EXT_SET_MOTION = 106,                    /**< Runs the _SET_MOTION command. */
    EVENT_EXT_SET_STEP = 107,                      /**< Runs the _SET_STEP command. */
    EVENT_EXT_SET_TEX_ANIM = 108,                  /**< Runs the _SET_TEX_ANIM command. */
    EVENT_EXT_SET_SCALE = 109,                     /**< Runs the _SET_SCALE command. */
    EVENT_EXT_SET_REFERENCE = 110,                 /**< Runs the _SET_REFERENCE command. */
    EVENT_EXT_DEL_REFERENCE = 111,                 /**< Runs the _DEL_REFERENCE command. */
    EVENT_EXT_SHADOW_CLIP_OFF = 112,               /**< Runs the _SHADOW_CLIP_OFF command. */
    EVENT_EXT_GET_COORDINATE_ANGLE = 113,          /**< Runs the _GET_COORDINATE_ANGLE command. */
    EVENT_EXT_GET_CHARA_WIDTH = 114,               /**< Runs the _GET_CHARA_WIDTH command. */
    EVENT_EXT_GET_CHARA_HEIGHT = 115,              /**< Runs the _GET_CHARA_HEIGHT command. */
    EVENT_EXT_GET_CHARA_WEIGHT = 116,              /**< Runs the _GET_CHARA_WEIGHT command. */
    EVENT_EXT_SET_CHARA_SHOW = 117,                /**< Runs the _SET_CHARA_SHOW command. */
    EVENT_EXT_GET_CHARA_SHOW = 118,                /**< Runs the _GET_CHARA_SHOW command. */
    EVENT_EXT_CHARA_DA_ENABLE = 119,               /**< Runs the _CHARA_DA_ENABLE command. */
    EVENT_EXT_GET_MOT_NOW_WAIT = 120,              /**< Runs the _GET_MOT_NOW_WAIT command. */
    EVENT_EXT_CHECK_MOTION_END = 121,              /**< Runs the _CHECK_MOTION_END command. */
    EVENT_EXT_ACTCHR_SET_MOTION = 122,             /**< Runs the _ACTCHR_SET_MOTION command. */
    EVENT_EXT_SET_CHARA_EX_SOUNDID = 123,          /**< Runs the _SET_CHARA_EX_SOUNDID command. */
    EVENT_EXT_ACTCHR_SOUND_INFO_COPY = 124,        /**< Runs the _ACTCHR_SOUND_INFO_COPY command. */
    EVENT_EXT_MES_MAKE = 192,                      /**< Runs the _MES_MAKE command. */
    EVENT_EXT_MES_CLOSE = 193,                     /**< Runs the _MES_CLOSE command. */
    EVENT_EXT_MES_NEXTPAGE = 194,                  /**< Runs the _MES_NEXTPAGE command. */
    EVENT_EXT_SET_MES_AUTOSET = 195,               /**< Runs the _SET_MES_AUTOSET command. */
    EVENT_EXT_SET_MES_SHIPPO = 196,                /**< Runs the _SET_MES_SHIPPO command. */
    EVENT_EXT_SET_MES_POS = 197,                   /**< Runs the _SET_MES_POS command. */
    EVENT_EXT_SET_MES_DRAWSPEED = 198,             /**< Runs the _SET_MES_DRAWSPEED command. */
    EVENT_EXT_SET_MES_CURSOR = 199,                /**< Runs the _SET_MES_CURSOR command. */
    EVENT_EXT_SET_MES_OKURI = 203,                 /**< Runs the _SET_MES_OKURI command. */
    EVENT_EXT_SET_MES_FUKIDASHI = 204,             /**< Runs the _SET_MES_FUKIDASHI command. */
    EVENT_EXT_CHECK_MES_COMPLETE = 200,            /**< Runs the _CHECK_MES_COMPLETE command. */
    EVENT_EXT_CHECK_MES_WAIT = 201,                /**< Runs the _CHECK_MES_WAIT command. */
    EVENT_EXT_CHECK_MES = 202,                     /**< Runs the _CHECK_MES command. */
    EVENT_EXT_SET_MES_WIN_FLAG = 205,              /**< Runs the _SET_MES_WIN_FLAG command. */
    EVENT_EXT_SET_CAMERA_POS = 206,                /**< Runs the _SET_CAMERA_POS command. */
    EVENT_EXT_GET_CAMERA_POS = 207,                /**< Runs the _GET_CAMERA_POS command. */
    EVENT_EXT_SET_CAMERA_REF = 208,                /**< Runs the _SET_CAMERA_REF command. */
    EVENT_EXT_GET_CAMERA_REF = 209,                /**< Runs the _GET_CAMERA_REF command. */
    EVENT_EXT_SET_CAMERA_SPEED = 210,              /**< Runs the _SET_CAMERA_SPEED command. */
    EVENT_EXT_CAMERA_STEP = 211,                   /**< Runs the _CAMERA_STEP command. */
    EVENT_EXT_SET_MES_WINDOW_MODE = 212,           /**< Runs the _SET_MES_WINDOW_MODE command. */
    EVENT_EXT_SET_MES_PRESET = 213,                /**< Runs the _SET_MES_PRESET command. */
    EVENT_EXT_SET_MES_ITEM_DIRECT = 214,           /**< Runs the _SET_MES_ITEM_DIRECT command. */
    EVENT_EXT_SET_MES_ITEM = 215,                  /**< Runs the _SET_MES_ITEM command. */
    EVENT_EXT_SET_MES_VALUE = 216,                 /**< Runs the _SET_MES_VALUE command. */
    EVENT_EXT_GET_MES_STATUS = 217,                /**< Runs the _GET_MES_STATUS command. */
    EVENT_EXT_GET_PARTY_CHARA_MES_NO = 218,        /**< Runs the _GET_PARTY_CHARA_MES_NO command. */
    EVENT_EXT_MES_SET_BUFF = 219,                  /**< Runs the _MES_SET_BUFF command. */
    EVENT_EXT_GET_MES_WINDOW_MODE = 220,           /**< Runs the _GET_MES_WINDOW_MODE command. */
    EVENT_EXT_GET_MES_VOICE = 222,                 /**< Runs the _GET_MES_VOICE command. */
    EVENT_EXT_SET_MES_QUESTION_GYOU = 223,         /**< Runs the _SET_MES_QUESTION_GYOU command. */
    EVENT_EXT_GET_MES_QUESTION_GYOU = 224,         /**< Runs the _GET_MES_QUESTION_GYOU command. */
    EVENT_EXT_SET_MES_CLOSE_CNT = 225,             /**< Runs the _SET_MES_CLOSE_CNT command. */
    EVENT_EXT_SET_MES_ETC = 226,                   /**< Runs the _SET_MES_ETC command. */
    EVENT_EXT_GET_MES_ETC = 227,                   /**< Runs the _GET_MES_ETC command. */
    EVENT_EXT_LOAD_MES = 228,                      /**< Runs the _LOAD_MES command. */
    EVENT_EXT_MES_SE_PLAY = 229,                   /**< Runs the _MES_SE_PLAY command. */
    EVENT_EXT_SET_MES_STR = 230,                   /**< Runs the _SET_MES_STR command. */
    EVENT_EXT_GET_MES_OKURI = 231,                 /**< Runs the _GET_MES_OKURI command. */
    EVENT_EXT_ASQ_INIT = 300,                      /**< Runs the _ASQ_INIT command. */
    EVENT_EXT_ASQ_SYNC_CHARA = 301,                /**< Runs the _ASQ_SYNC_CHARA command. */
    EVENT_EXT_ASQ_SET_POS = 302,                   /**< Runs the _ASQ_SET_POS command. */
    EVENT_EXT_ASQ_MOVE = 303,                      /**< Runs the _ASQ_MOVE command. */
    EVENT_EXT_ASQ_MOVE_STEP = 304,                 /**< Runs the _ASQ_MOVE_STEP command. */
    EVENT_EXT_ASQ_ROT_REF = 305,                   /**< Runs the _ASQ_ROT_REF command. */
    EVENT_EXT_ASQ_CLEAR_ROT = 307,                 /**< Runs the _ASQ_CLEAR_ROT command. */
    EVENT_EXT_ASQ_WAIT_ROT = 308,                  /**< Runs the _ASQ_WAIT_ROT command. */
    EVENT_EXT_ASQ_ROT_MOVE = 309,                  /**< Runs the _ASQ_ROT_MOVE command. */
    EVENT_EXT_ASQ_ROT_ANGLE = 306,                 /**< Runs the _ASQ_ROT_ANGLE command. */
    EVENT_EXT_ASQ_SET_ROT = 310,                   /**< Runs the _ASQ_SET_ROT command. */
    EVENT_EXT_ASQ_DELAY_ROT = 311,                 /**< Runs the _ASQ_DELAY_ROT command. */
    EVENT_EXT_ASQ_CHECK = 312,                     /**< Runs the _ASQ_CHECK command. */
    EVENT_EXT_ASQ_MOTION_TRG = 313,                /**< Runs the _ASQ_MOTION_TRG command. */
    EVENT_EXT_ASQ_MOTION_PLAY = 314,               /**< Runs the _ASQ_MOTION_PLAY command. */
    EVENT_EXT_ASQ_MOTION_STOP = 315,               /**< Runs the _ASQ_MOTION_STOP command. */
    EVENT_EXT_ASQ_MOTION_NEXT = 316,               /**< Runs the _ASQ_MOTION_NEXT command. */
    EVENT_EXT_ASQ_ANIME_TRG = 317,                 /**< Runs the _ASQ_ANIME_TRG command. */
    EVENT_EXT_ASQ_ANIME = 318,                     /**< Runs the _ASQ_ANIME command. */
    EVENT_EXT_ASQ_SE_PLAY = 319,                   /**< Runs the _ASQ_SE_PLAY command. */
    EVENT_EXT_IMG_SET_DRAW = 320,                  /**< Runs the _IMG_SET_DRAW command. */
    EVENT_EXT_IMG_SET_GET = 321,                   /**< Runs the _IMG_SET_GET command. */
    EVENT_EXT_IMG_SET_PUT = 322,                   /**< Runs the _IMG_SET_PUT command. */
    EVENT_EXT_IMG_SET_NAME = 323,                  /**< Runs the _IMG_SET_NAME command. */
    EVENT_EXT_IMG_SET_MOVE = 324,                  /**< Runs the _IMG_SET_MOVE command. */
    EVENT_EXT_IMG_SET_FADE = 325,                  /**< Runs the _IMG_SET_FADE command. */
    EVENT_EXT_IMG_SET_COLOR = 326,                 /**< Runs the _IMG_SET_COLOR command. */
    EVENT_EXT_SPRITE_INIT = 350,                   /**< Runs the _SPRITE_INIT command. */
    EVENT_EXT_SPRITE_SET_DRAW = 351,               /**< Runs the _SPRITE_SET_DRAW command. */
    EVENT_EXT_SPRITE_SET_TYPE = 352,               /**< Runs the _SPRITE_SET_TYPE command. */
    EVENT_EXT_SPRITE_SET_TEXTURE = 353,            /**< Runs the _SPRITE_SET_TEXTURE command. */
    EVENT_EXT_SPRITE_SET_POS = 354,                /**< Runs the _SPRITE_SET_POS command. */
    EVENT_EXT_SPRITE_SET_PUTSIZE = 355,            /**< Runs the _SPRITE_SET_PUTSIZE command. */
    EVENT_EXT_SPRITE_SET_UVSIZE = 356,             /**< Runs the _SPRITE_SET_UVSIZE command. */
    EVENT_EXT_SPRITE_SET_COLOR = 357,              /**< Runs the _SPRITE_SET_COLOR command. */
    EVENT_EXT_SPRITE_SET_SCALE = 358,              /**< Runs the _SPRITE_SET_SCALE command. */
    EVENT_EXT_SPRITE_SET_ALPHAB = 359,             /**< Runs the _SPRITE_SET_ALPHAB command. */
    EVENT_EXT_CMRS_CHECK = 400,                    /**< Runs the _CMRS_CHECK command. */
    EVENT_EXT_CMRS_INIT = 401,                     /**< Runs the _CMRS_INIT command. */
    EVENT_EXT_CMRS_PRDELAY = 402,                  /**< Runs the _CMRS_PRDELAY command. */
    EVENT_EXT_CMRS_SET_POS = 403,                  /**< Runs the _CMRS_SET_POS command. */
    EVENT_EXT_CMRS_SET_REF = 404,                  /**< Runs the _CMRS_SET_REF command. */
    EVENT_EXT_CMRS_MOVE = 405,                     /**< Runs the _CMRS_MOVE command. */
    EVENT_EXT_CMRS_MOVE_REF = 406,                 /**< Runs the _CMRS_MOVE_REF command. */
    EVENT_EXT_CMRS_INIT_PAS = 407,                 /**< Runs the _CMRS_INIT_PAS command. */
    EVENT_EXT_CMRS_SET_PAS_FRM = 408,              /**< Runs the _CMRS_SET_PAS_FRM command. */
    EVENT_EXT_CMRS_ADD_PAS = 409,                  /**< Runs the _CMRS_ADD_PAS command. */
    EVENT_EXT_CMRS_START_PAS = 410,                /**< Runs the _CMRS_START_PAS command. */
    EVENT_EXT_CMRS_PR_SLOWING = 423,               /**< Runs the _CMRS_PR_SLOWING command. */
    EVENT_EXT_CMRS_PR_KEEP = 427,                  /**< Runs the _CMRS_PR_KEEP command. */
    EVENT_EXT_CMRS_PR_RETURN = 428,                /**< Runs the _CMRS_PR_RETURN command. */
    EVENT_EXT_CMRS_AHDDELAY = 411,                 /**< Runs the _CMRS_AHDDELAY command. */
    EVENT_EXT_CMRS_SET_ANGLE = 412,                /**< Runs the _CMRS_SET_ANGLE command. */
    EVENT_EXT_CMRS_SET_HEIGHT = 413,               /**< Runs the _CMRS_SET_HEIGHT command. */
    EVENT_EXT_CMRS_SET_DIST = 414,                 /**< Runs the _CMRS_SET_DIST command. */
    EVENT_EXT_CMRS_SET_AHD = 415,                  /**< Runs the _CMRS_SET_AHD command. */
    EVENT_EXT_CMRS_MOVE_AHD = 416,                 /**< Runs the _CMRS_MOVE_AHD command. */
    EVENT_EXT_CMRS_SYNC_OBJ = 617,                 /**< Runs the _CMRS_SYNC_OBJ command. */
    EVENT_EXT_CMRS_RELEASE_OBJ = 618,              /**< Runs the _CMRS_RELEASE_OBJ command. */
    EVENT_EXT_CMRS_AHD_SLOWING = 424,              /**< Runs the _CMRS_AHD_SLOWING command. */
    EVENT_EXT_CMRS_AHD_KEEP = 425,                 /**< Runs the _CMRS_AHD_KEEP command. */
    EVENT_EXT_CMRS_AHD_RETURN = 426,               /**< Runs the _CMRS_AHD_RETURN command. */
    EVENT_EXT_CMRS_FADE_DELAY = 419,               /**< Runs the _CMRS_FADE_DELAY command. */
    EVENT_EXT_CMRS_FADE_INIT = 420,                /**< Runs the _CMRS_FADE_INIT command. */
    EVENT_EXT_CMRS_FADE_IN = 421,                  /**< Runs the _CMRS_FADE_IN command. */
    EVENT_EXT_CMRS_FADE_OUT = 422,                 /**< Runs the _CMRS_FADE_OUT command. */
    EVENT_EXT_CMRS_QUAKE_DELAY = 429,              /**< Runs the _CMRS_QUAKE_DELAY command. */
    EVENT_EXT_CMRS_QUAKE = 430,                    /**< Runs the _CMRS_QUAKE command. */
    EVENT_EXT_CMRS_MOVE2 = 431,                    /**< Runs the _CMRS_MOVE2 command. */
    EVENT_EXT_CMRS_MOVE_AHD2 = 432,                /**< Runs the _CMRS_MOVE_AHD2 command. */
    EVENT_EXT_CMRS_CHARA_DELAY = 433,              /**< Runs the _CMRS_CHARA_DELAY command. */
    EVENT_EXT_CMRS_CHARA_ATTACH = 434,             /**< Runs the _CMRS_CHARA_ATTACH command. */
    EVENT_EXT_CMRS_MOVE_POS = 435,                 /**< Runs the _CMRS_MOVE_POS command. */
    EVENT_EXT_CMRS_QUAKE2 = 436,                   /**< Runs the _CMRS_QUAKE2 command. */
    EVENT_EXT_OBJS_CHECK = 450,                    /**< Runs the _OBJS_CHECK command. */
    EVENT_EXT_OBJS_INIT = 451,                     /**< Runs the _OBJS_INIT command. */
    EVENT_EXT_OBJS_SYNC_OBJ = 452,                 /**< Runs the _OBJS_SYNC_OBJ command. */
    EVENT_EXT_OBJS_POS_DELAY = 453,                /**< Runs the _OBJS_POS_DELAY command. */
    EVENT_EXT_OBJS_SET_POS = 454,                  /**< Runs the _OBJS_SET_POS command. */
    EVENT_EXT_OBJS_MOVE = 455,                     /**< Runs the _OBJS_MOVE command. */
    EVENT_EXT_OBJS_MOVE2 = 488,                    /**< Runs the _OBJS_MOVE2 command. */
    EVENT_EXT_OBJS_INIT_PAS = 456,                 /**< Runs the _OBJS_INIT_PAS command. */
    EVENT_EXT_OBJS_SET_PAS_FRM = 457,              /**< Runs the _OBJS_SET_PAS_FRM command. */
    EVENT_EXT_OBJS_ADD_PAS = 458,                  /**< Runs the _OBJS_ADD_PAS command. */
    EVENT_EXT_OBJS_START_PAS = 459,                /**< Runs the _OBJS_START_PAS command. */
    EVENT_EXT_OBJS_JUMP = 473,                     /**< Runs the _OBJS_JUMP command. */
    EVENT_EXT_OBJS_SET_EOH_FRAME_POS = 483,        /**< Runs the _OBJS_SET_EOH_FRAME_POS command. */
    EVENT_EXT_OBJS_ADD_POS = 484,                  /**< Runs the _OBJS_ADD_POS command. */
    EVENT_EXT_OBJS_ATTACH_CAMERA = 489,            /**< Runs the _OBJS_ATTACH_CAMERA command. */
    EVENT_EXT_OBJS_ROT_DELAY = 460,                /**< Runs the _OBJS_ROT_DELAY command. */
    EVENT_EXT_OBJS_SET_ROT = 461,                  /**< Runs the _OBJS_SET_ROT command. */
    EVENT_EXT_OBJS_ROTATION = 462,                 /**< Runs the _OBJS_ROTATION command. */
    EVENT_EXT_OBJS_ROTATION2 = 490,                /**< Runs the _OBJS_ROTATION2 command. */
    EVENT_EXT_OBJS_REFERENCE = 463,                /**< Runs the _OBJS_REFERENCE command. */
    EVENT_EXT_OBJS_MOTION_DELAY = 464,             /**< Runs the _OBJS_MOTION_DELAY command. */
    EVENT_EXT_OBJS_SET_MOTION = 465,               /**< Runs the _OBJS_SET_MOTION command. */
    EVENT_EXT_OBJS_NEXT_MOTION = 466,              /**< Runs the _OBJS_NEXT_MOTION command. */
    EVENT_EXT_OBJS_MOTION_WAIT = 467,              /**< Runs the _OBJS_MOTION_WAIT command. */
    EVENT_EXT_OBJS_SET_STEP = 482,                 /**< Runs the _OBJS_SET_STEP command. */
    EVENT_EXT_OBJS_CHENGE_STEP = 469,              /**< Runs the _OBJS_CHENGE_STEP command. */
    EVENT_EXT_OBJS_SEQ_MOT_TRG = 468,              /**< Runs the _OBJS_SEQ_MOT_TRG command. */
    EVENT_EXT_OBJS_SEQ_MOT_TRG_WAIT = 472,         /**< Runs the _OBJS_SEQ_MOT_TRG_WAIT command. */
    EVENT_EXT_OBJS_RESET_MOTION = 476,             /**< Runs the _OBJS_RESET_MOTION command. */
    EVENT_EXT_OBJS_SET_MOTION_NOW_TIME = 479,      /**< Runs the _OBJS_SET_MOTION_NOW_TIME command. */
    EVENT_EXT_OBJS_SET_MOTION_WAIT_TIME = 481,     /**< Runs the _OBJS_SET_MOTION_WAIT_TIME command. */
    EVENT_EXT_OBJS_TEXA_DELAY = 470,               /**< Runs the _OBJS_TEXA_DELAY command. */
    EVENT_EXT_OBJS_TEX_ANIME = 471,                /**< Runs the _OBJS_TEX_ANIME command. */
    EVENT_EXT_OBJS_COLOR_DELAY = 474,              /**< Runs the _OBJS_COLOR_DELAY command. */
    EVENT_EXT_OBJS_SET_COLOR = 475,                /**< Runs the _OBJS_SET_COLOR command. */
    EVENT_EXT_OBJS_SCALE_DELAY = 477,              /**< Runs the _OBJS_SCALE_DELAY command. */
    EVENT_EXT_OBJS_SET_SCALE = 478,                /**< Runs the _OBJS_SET_SCALE command. */
    EVENT_EXT_OBJS_SE_DELAY = 485,                 /**< Runs the _OBJS_SE_DELAY command. */
    EVENT_EXT_OBJS_SE_PLAY = 486,                  /**< Runs the _OBJS_SE_PLAY command. */
    EVENT_EXT_OBJS_RESET_DA_POSITION = 487,        /**< Runs the _OBJS_RESET_DA_POSITION command. */
    EVENT_EXT_OBJS_NORMAL_DRIVE = 491,             /**< Runs the _OBJS_NORMAL_DRIVE command. */
    EVENT_EXT_GET_CONTENTS_POS = 501,              /**< Runs the _GET_CONTENTS_POS command. */
    EVENT_EXT_GET_BPOT_POS = 502,                  /**< Runs the _GET_BPOT_POS command. */
    EVENT_EXT_GET_BPOT_STATUS = 503,               /**< Runs the _GET_BPOT_STATUS command. */
    EVENT_EXT_GET_PERSON_STATUS = 504,             /**< Runs the _GET_PERSON_STATUS command. */
    EVENT_EXT_GET_CONTROL_CHRID = 505,             /**< Runs the _GET_CONTROL_CHRID command. */
    EVENT_EXT_GET_BEFORE_CAMERA_POS = 506,         /**< Runs the _GET_BEFORE_CAMERA_POS command. */
    EVENT_EXT_GET_BEFORE_CAMERA_REF = 507,         /**< Runs the _GET_BEFORE_CAMERA_REF command. */
    EVENT_EXT_SET_CAMERA_NEXT_REF = 508,           /**< Runs the _SET_CAMERA_NEXT_REF command. */
    EVENT_EXT_GOTO_MENU = 509,                     /**< Runs the _GOTO_MENU command. */
    EVENT_EXT_GET_MENU_STATUS = 510,               /**< Runs the _GET_MENU_STATUS command. */
    EVENT_EXT_LOAD_EQUIP = 511,                    /**< Runs the _LOAD_EQUIP command. */
    EVENT_EXT_GET_EQUIP_ITEMNO = 512,              /**< Runs the _GET_EQUIP_ITEMNO command. */
    EVENT_EXT_SET_TIME_STEP_ENABLE = 513,          /**< Runs the _SET_TIME_STEP_ENABLE command. */
    EVENT_EXT_SET_DOOR_MATERIAL = 514,             /**< Runs the _SET_DOOR_MATERIAL command. */
    EVENT_EXT_INIT_DRAMA_SCENE = 515,              /**< Runs the _INIT_DRAMA_SCENE command. */
    EVENT_EXT_SET_ACTIVE_CMRID = 516,              /**< Runs the _SET_ACTIVE_CMRID command. */
    EVENT_EXT_SET_BEFORE_CMRID = 517,              /**< Runs the _SET_BEFORE_CMRID command. */
    EVENT_EXT_DNGMAP_LOAD = 519,                   /**< Runs the _DNGMAP_LOAD command. */
    EVENT_EXT_DNGMAP_DELETE = 520,                 /**< Runs the _DNGMAP_DELETE command. */
    EVENT_EXT_DNGMAP_MOVE_PIECE = 521,             /**< Runs the _DNGMAP_MOVE_PIECE command. */
    EVENT_EXT_DNGMAP_ONOFF = 522,                  /**< Runs the _DNGMAP_ONOFF command. */
    EVENT_EXT_DNGMAP_SET_FADE = 523,               /**< Runs the _DNGMAP_SET_FADE command. */
    EVENT_EXT_GET_BEFORE_CAMERA_NEXT_POS = 524,    /**< Runs the _GET_BEFORE_CAMERA_NEXT_POS command. */
    EVENT_EXT_GET_BEFORE_CAMERA_NEXT_REF = 525,    /**< Runs the _GET_BEFORE_CAMERA_NEXT_REF command. */
    EVENT_EXT_SET_CAMERA_NEXT_POS = 526,           /**< Runs the _SET_CAMERA_NEXT_POS command. */
    EVENT_EXT_CHK_INTERSECTION_POINT = 527,        /**< Runs the _CHK_INTERSECTION_POINT command. */
    EVENT_EXT_SET_FCAMERA_FOLLOW = 528,            /**< Runs the _SET_FCAMERA_FOLLOW command. */
    EVENT_EXT_SET_FCAMERA_FOLLOW_A = 529,          /**< Runs the _SET_FCAMERA_FOLLOW_A command. */
    EVENT_EXT_SET_FCAMERA_FOLLOW_OFS = 530,        /**< Runs the _SET_FCAMERA_FOLLOW_OFS command. */
    EVENT_EXT_SET_FCAMERA_FOLLOW_FLAG = 531,       /**< Runs the _SET_FCAMERA_FOLLOW_FLAG command. */
    EVENT_EXT_FCAMERA_STEP = 532,                  /**< Runs the _FCAMERA_STEP command. */
    EVENT_EXT_SET_FCAMERA_ANGLE = 533,             /**< Runs the _SET_FCAMERA_ANGLE command. */
    EVENT_EXT_SET_FCAMERA_HEIGHT = 534,            /**< Runs the _SET_FCAMERA_HEIGHT command. */
    EVENT_EXT_SET_FCAMERA_DIST = 535,              /**< Runs the _SET_FCAMERA_DIST command. */
    EVENT_EXT_GET_REF_ANGLE = 536,                 /**< Runs the _GET_REF_ANGLE command. */
    EVENT_EXT_DNG_SET_STAGE_ID = 537,              /**< Runs the _DNG_SET_STAGE_ID command. */
    EVENT_EXT_DNG_GET_STAGE_ID = 538,              /**< Runs the _DNG_GET_STAGE_ID command. */
    EVENT_EXT_SET_CAMERA_CTRL = 539,               /**< Runs the _SET_CAMERA_CTRL command. */
    EVENT_EXT_GET_FCAMERA_ANGLE = 540,             /**< Runs the _GET_FCAMERA_ANGLE command. */
    EVENT_EXT_GET_FCAMERA_HEIGHT = 541,            /**< Runs the _GET_FCAMERA_HEIGHT command. */
    EVENT_EXT_GET_FCAMERA_DIST = 542,              /**< Runs the _GET_FCAMERA_DIST command. */
    EVENT_EXT_GET_INVENTION_ID = 543,              /**< Runs the _GET_INVENTION_ID command. */
    EVENT_EXT_FUNCTION_MAP_JUMP = 544,             /**< Runs the _FUNCTION_MAP_JUMP command. */
    EVENT_EXT_FUNCTION_DOOR_MODE = 545,            /**< Runs the _FUNCTION_DOOR_MODE command. */
    EVENT_EXT_GET_MONEY = 546,                     /**< Runs the _GET_MONEY command. */
    EVENT_EXT_ADD_MONEY = 547,                     /**< Runs the _ADD_MONEY command. */
    EVENT_EXT_GET_ITEM_NUM = 548,                  /**< Runs the _GET_ITEM_NUM command. */
    EVENT_EXT_CHECK_BUTTON = 549,                  /**< Runs the _CHECK_BUTTON command. */
    EVENT_EXT_GET_LANGUAGE = 550,                  /**< Runs the _GET_LANGUAGE command. */
    EVENT_EXT_CHECK_INVENT_ITEM = 551,             /**< Runs the _CHECK_INVENT_ITEM command. */
    EVENT_EXT_SET_AI = 552,                        /**< Runs the _SET_AI command. */
    EVENT_EXT_CHECK_INVENT_PHOTO = 553,            /**< Runs the _CHECK_INVENT_PHOTO command. */
    EVENT_EXT_GET_PHOTO_NUM = 554,                 /**< Runs the _GET_PHOTO_NUM command. */
    EVENT_EXT_SET_CONTENTS_ETC = 555,              /**< Runs the _SET_CONTENTS_ETC command. */
    EVENT_EXT_SET_STATUS = 556,                    /**< Runs the _SET_STATUS command. */
    EVENT_EXT_GOTO_SUBGAME = 557,                  /**< Runs the _GOTO_SUBGAME command. */
    EVENT_EXT_SET_GYORACE_ETC = 558,               /**< Runs the _SET_GYORACE_ETC command. */
    EVENT_EXT_GET_GYORACE_ETC = 559,               /**< Runs the _GET_GYORACE_ETC command. */
    EVENT_EXT_SET_SAVEDATA_ETC = 560,              /**< Runs the _SET_SAVEDATA_ETC command. */
    EVENT_EXT_GET_SAVEDATA_ETC = 561,              /**< Runs the _GET_SAVEDATA_ETC command. */
    EVENT_EXT_DEL_MONSTER = 562,                   /**< Runs the _DEL_MONSTER command. */
    EVENT_EXT_SET_MENU_ETC = 563,                  /**< Runs the _SET_MENU_ETC command. */
    EVENT_EXT_GET_MENU_ETC = 564,                  /**< Runs the _GET_MENU_ETC command. */
    EVENT_EXT_GET_ANALYZE = 565,                   /**< Runs the _GET_ANALYZE command. */
    EVENT_EXT_GET_DIORAMA_PERCENT = 566,           /**< Runs the _GET_DIORAMA_PERCENT command. */
    EVENT_EXT_GEORAMA_FUNC = 567,                  /**< Runs the _GEORAMA_FUNC command. */
    EVENT_EXT_GET_CHARA_ID = 568,                  /**< Runs the _GET_CHARA_ID command. */
    EVENT_EXT_SET_LOADBG_FILE_MONS_TALK = 569,     /**< Runs the _SET_LOADBG_FILE_MONS_TALK command. */
    EVENT_EXT_LOAD_MES_MONS_TALK = 570,            /**< Runs the _LOAD_MES_MONS_TALK command. */
    EVENT_EXT_GOTO_EDITMODE = 571,                 /**< Runs the _GOTO_EDITMODE command. */
    EVENT_EXT_GET_CHAPTER = 572,                   /**< Runs the _GET_CHAPTER command. */
    EVENT_EXT_GET_NPC_TRAIN_ETC = 573,             /**< Runs the _GET_NPC_TRAIN_ETC command. */
    EVENT_EXT_REGISTER_VILLAGER = 574,             /**< Runs the _REGISTER_VILLAGER command. */
    EVENT_EXT_EYE_VIEW_DRAW_ON_OFF = 575,          /**< Runs the _EYE_VIEW_DRAW_ON_OFF command. */
    EVENT_EXT_SET_QUEST_ETC = 576,                 /**< Runs the _SET_QUEST_ETC command. */
    EVENT_EXT_GET_QUEST_ETC = 577,                 /**< Runs the _GET_QUEST_ETC command. */
    EVENT_EXT_CHK_INTERSECTION_POINT_PIPE = 578,   /**< Runs the _CHK_INTERSECTION_POINT_PIPE command. */
    EVENT_EXT_GET_OLD_INTERIOR_MAP_NO = 579,       /**< Runs the _GET_OLD_INTERIOR_MAP_NO command. */
    EVENT_EXT_SET_EVENT_DATA = 581,                /**< Runs the _SET_EVENT_DATA command. */
    EVENT_EXT_STOPWATCH = 582,                     /**< Runs the _STOPWATCH command. */
    EVENT_EXT_SET_FUNC_ETC = 583,                  /**< Runs the _SET_FUNC_ETC command. */
    EVENT_EXT_GET_FISHINGTOURNAMENT_ETC = 584,     /**< Runs the _GET_FISHINGTOURNAMENT_ETC command. */
    EVENT_EXT_SET_CHARA_FAR_DIST = 585,            /**< Runs the _SET_CHARA_FAR_DIST command. */
    EVENT_EXT_SET_MODEL_LIGHT_SWITCH = 586,        /**< Runs the _SET_MODEL_LIGHT_SWITCH command. */
    EVENT_EXT_SET_MODEL_LIGHT_COLOR = 587,         /**< Runs the _SET_MODEL_LIGHT_COLOR command. */
    EVENT_EXT_GET_OMAKE_FLAG = 588,                /**< Runs the _GET_OMAKE_FLAG command. */
    EVENT_EXT_SET_WIND = 589,                      /**< Runs the _SET_WIND command. */
    EVENT_EXT_SET_OMAKE_FLAG = 590,                /**< Runs the _SET_OMAKE_FLAG command. */
    EVENT_EXT_SND_INIT_PORT = 600,                 /**< Runs the _SND_INIT_PORT command. */
    EVENT_EXT_SND_LOAD_SOUND = 601,                /**< Runs the _SND_LOAD_SOUND command. */
    EVENT_EXT_SND_SE_PLAY = 602,                   /**< Runs the _SND_SE_PLAY command. */
    EVENT_EXT_GET_SND_ID = 603,                    /**< Runs the _GET_SND_ID command. */
    EVENT_EXT_SND_SE_PAUSE = 604,                  /**< Runs the _SND_SE_PAUSE command. */
    EVENT_EXT_SND_SE_STOP = 605,                   /**< Runs the _SND_SE_STOP command. */
    EVENT_EXT_SND_SET_SE_VOL = 606,                /**< Runs the _SND_SET_SE_VOL command. */
    EVENT_EXT_SND_SET_SE_PAN = 607,                /**< Runs the _SND_SET_SE_PAN command. */
    EVENT_EXT_SND_SET_SE_PITCH = 608,              /**< Runs the _SND_SET_SE_PITCH command. */
    EVENT_EXT_SND_SE_ALL_STOP = 609,               /**< Runs the _SND_SE_ALL_STOP command. */
    EVENT_EXT_LOAD_BGM = 610,                      /**< Runs the _LOAD_BGM command. */
    EVENT_EXT_PLAY_BGM = 611,                      /**< Runs the _PLAY_BGM command. */
    EVENT_EXT_STOP_BGM = 612,                      /**< Runs the _STOP_BGM command. */
    EVENT_EXT_STREAM_OPEN = 613,                   /**< Runs the _STREAM_OPEN command. */
    EVENT_EXT_STREAM_PLAY = 614,                   /**< Runs the _STREAM_PLAY command. */
    EVENT_EXT_STREAM_STOP = 615,                   /**< Runs the _STREAM_STOP command. */
    EVENT_EXT_STREAM_STANDBY = 616,                /**< Runs the _STREAM_STANDBY command. */
    EVENT_EXT_STREAM_GET_STATUS = 619,             /**< Runs the _STREAM_GET_STATUS command. */
    EVENT_EXT_GET_SYS_SND_ID = 620,                /**< Runs the _GET_SYS_SND_ID command. */
    EVENT_EXT_STREAM_OPEN_CHECK = 621,             /**< Runs the _STREAM_OPEN_CHECK command. */
    EVENT_EXT_LOAD_SE_ENV = 622,                   /**< Runs the _LOAD_SE_ENV command. */
    EVENT_EXT_PLAY_ENV_BGM = 623,                  /**< Runs the _PLAY_ENV_BGM command. */
    EVENT_EXT_SYS_SE_PLAY = 624,                   /**< Runs the _SYS_SE_PLAY command. */
    EVENT_EXT_INIT_SE_SRC = 625,                   /**< Runs the _INIT_SE_SRC command. */
    EVENT_EXT_INIT_SE_ENV = 626,                   /**< Runs the _INIT_SE_ENV command. */
    EVENT_EXT_INIT_SE_BAS = 627,                   /**< Runs the _INIT_SE_BAS command. */
    EVENT_EXT_LOAD_SE_SRC = 628,                   /**< Runs the _LOAD_SE_SRC command. */
    EVENT_EXT_LOAD_SE_FOOT = 629,                  /**< Runs the _LOAD_SE_FOOT command. */
    EVENT_EXT_LOAD_SE_DOOR = 630,                  /**< Runs the _LOAD_SE_DOOR command. */
    EVENT_EXT_LOAD_SE_BOX = 631,                   /**< Runs the _LOAD_SE_BOX command. */
    EVENT_EXT_LOAD_SE_BATTLE = 632,                /**< Runs the _LOAD_SE_BATTLE command. */
    EVENT_EXT_SND_DELETE_PORT = 633,               /**< Runs the _SND_DELETE_PORT command. */
    EVENT_EXT_STOP_ENV_BGM = 634,                  /**< Runs the _STOP_ENV_BGM command. */
    EVENT_EXT_FADE_IN_BGM = 635,                   /**< Runs the _FADE_IN_BGM command. */
    EVENT_EXT_FADE_OUT_BGM = 636,                  /**< Runs the _FADE_OUT_BGM command. */
    EVENT_EXT_SET_BGM_VOL = 637,                   /**< Runs the _SET_BGM_VOL command. */
    EVENT_EXT_SND_SET_REVERB = 638,                /**< Runs the _SND_SET_REVERB command. */
    EVENT_EXT_SND_SET_ENV_VOL = 639,               /**< Runs the _SND_SET_ENV_VOL command. */
    EVENT_EXT_STREAM_SILENT_CHECK = 640,           /**< Runs the _STREAM_SILENT_CHECK command. */
    EVENT_EXT_AUTO_CHANGE_ENV = 641,               /**< Runs the _AUTO_CHANGE_ENV command. */
    EVENT_EXT_BGM_LOAD_CANCEL = 642,               /**< Runs the _BGM_LOAD_CANCEL command. */
    EVENT_EXT_SOUND_LOAD_CANCEL = 643,             /**< Runs the _SOUND_LOAD_CANCEL command. */
    EVENT_EXT_BGM_LOAD_ENABLE = 644,               /**< Runs the _BGM_LOAD_ENABLE command. */
    EVENT_EXT_SOUND_LOAD_ENABLE = 645,             /**< Runs the _SOUND_LOAD_ENABLE command. */
    EVENT_EXT_LOAD_SE_BASE = 646,                  /**< Runs the _LOAD_SE_BASE command. */
    EVENT_EXT_LOAD_SOUND = 647,                    /**< Runs the _LOAD_SOUND command. */
    EVENT_EXT_STREAM_CLOSE = 648,                  /**< Runs the _STREAM_CLOSE command. */
    EVENT_EXT_STREAM_OPEN2 = 649,                  /**< Runs the _STREAM_OPEN2 command. */
    EVENT_EXT_LOAD_BGM_PACK = 650,                 /**< Runs the _LOAD_BGM_PACK command. */
    EVENT_EXT_GET_BGM_NO = 651,                    /**< Runs the _GET_BGM_NO command. */
    EVENT_EXT_GET_MASTER_VOL = 652,                /**< Runs the _GET_MASTER_VOL command. */
    EVENT_EXT_SET_MASTER_VOL = 653,                /**< Runs the _SET_MASTER_VOL command. */
    EVENT_EXT_GET_BTL_BGM_VOL = 654,               /**< Runs the _GET_BTL_BGM_VOL command. */
    EVENT_EXT_SET_BTL_BGM_VOL = 655,               /**< Runs the _SET_BTL_BGM_VOL command. */
    EVENT_EXT_SND_IN_REVERB = 656,                 /**< Runs the _SND_IN_REVERB command. */
    EVENT_EXT_SND_STOP_SRC = 657,                  /**< Runs the _SND_STOP_SRC command. */
    EVENT_EXT_SND_PAUSE_BGM = 658,                 /**< Runs the _SND_PAUSE_BGM command. */
    EVENT_EXT_STREAM_OPEN3 = 659,                  /**< Runs the _STREAM_OPEN3 command. */
    EVENT_EXT_GET_ACTIVE_BGM_STATUS = 660,         /**< Runs the _GET_ACTIVE_BGM_STATUS command. */
    EVENT_EXT_SET_ACTIVE_BGM_STATUS = 661,         /**< Runs the _SET_ACTIVE_BGM_STATUS command. */
    EVENT_EXT_GET_BGM_STATUS_NOW_NO = 662,         /**< Runs the _GET_BGM_STATUS_NOW_NO command. */
    EVENT_EXT_GET_SE_STATUS = 663,                 /**< Runs the _GET_SE_STATUS command. */
    EVENT_EXT_SE_ALL_STOP = 664,                   /**< Runs the _SE_ALL_STOP command. */
    EVENT_EXT_SOUND_ALL_STOP = 665,                /**< Runs the _SOUND_ALL_STOP command. */
    EVENT_EXT_BGM_PLAY_CANCEL = 666,               /**< Runs the _BGM_PLAY_CANCEL command. */
    EVENT_EXT_BGM_PLAY_ENABLE = 667,               /**< Runs the _BGM_PLAY_ENABLE command. */
    EVENT_EXT_GET_DEF_BGM_NO = 668,                /**< Runs the _GET_DEF_BGM_NO command. */
    EVENT_EXT_SET_MOVIE_CC = 669,                  /**< Runs the _SET_MOVIE_CC command. */
    EVENT_EXT_REGISTER_VILLAGER2 = 670,            /**< Runs the _REGISTER_VILLAGER2 command. */
    EVENT_EXT_SET_FISHINGTOURNAMENT_ETC = 671,     /**< Runs the _SET_FISHINGTOURNAMENT_ETC command. */
    EVENT_EXT_EOH_SYNC_CHARA = 700,                /**< Runs the _EOH_SYNC_CHARA command. */
    EVENT_EXT_EOH_SYNC_OBJ = 701,                  /**< Runs the _EOH_SYNC_OBJ command. */
    EVENT_EXT_EOH_SET_POS = 702,                   /**< Runs the _EOH_SET_POS command. */
    EVENT_EXT_EOH_SET_ROT = 703,                   /**< Runs the _EOH_SET_ROT command. */
    EVENT_EXT_EOH_GET_POS = 704,                   /**< Runs the _EOH_GET_POS command. */
    EVENT_EXT_EOH_GET_ROT = 705,                   /**< Runs the _EOH_GET_ROT command. */
    EVENT_EXT_EOH_SET_MOTION = 706,                /**< Runs the _EOH_SET_MOTION command. */
    EVENT_EXT_EOH_SET_STEP = 707,                  /**< Runs the _EOH_SET_STEP command. */
    EVENT_EXT_EOH_SET_TEX_ANIM = 708,              /**< Runs the _EOH_SET_TEX_ANIM command. */
    EVENT_EXT_EOH_SET_SCALE = 709,                 /**< Runs the _EOH_SET_SCALE command. */
    EVENT_EXT_EOH_SET_SHOW = 710,                  /**< Runs the _EOH_SET_SHOW command. */
    EVENT_EXT_EOH_GET_SHOW = 711,                  /**< Runs the _EOH_GET_SHOW command. */
    EVENT_EXT_EOH_SET_FRAME_SHOW = 712,            /**< Runs the _EOH_SET_FRAME_SHOW command. */
    EVENT_EXT_EOH_SET_SHADOW = 713,                /**< Runs the _EOH_SET_SHADOW command. */
    EVENT_EXT_EOH_SET_TRANSLATE = 714,             /**< Runs the _EOH_SET_TRANSLATE command. */
    EVENT_EXT_EOH_SYNC_SPRITE = 715,               /**< Runs the _EOH_SYNC_SPRITE command. */
    EVENT_EXT_EOH_SET_FOOT_SOUND_ID = 716,         /**< Runs the _EOH_SET_FOOT_SOUND_ID command. */
    EVENT_EXT_EOH_SET_FRAME_STATUS = 717,          /**< Runs the _EOH_SET_FRAME_STATUS command. */
    EVENT_EXT_EOH_GET_FRAME_POS = 718,             /**< Runs the _EOH_GET_FRAME_POS command. */
    EVENT_EXT_EOH_SET_SOUND_ID = 719,              /**< Runs the _EOH_SET_SOUND_ID command. */
    EVENT_EXT_EOH_GET_FRAME_STATUS = 720,          /**< Runs the _EOH_GET_FRAME_STATUS command. */
    EVENT_EXT_EOH_SYNC_CHROBJ = 721,               /**< Runs the _EOH_SYNC_CHROBJ command. */
    EVENT_EXT_EOH_SET_FADE_FLAG = 722,             /**< Runs the _EOH_SET_FADE_FLAG command. */
    EVENT_EXT_EOH_RESET_DA_POSITION = 723,         /**< Runs the _EOH_RESET_DA_POSITION command. */
    EVENT_EXT_EOH_SET_SHADOW_FRAME_STATUS = 724,   /**< Runs the _EOH_SET_SHADOW_FRAME_STATUS command. */
    EVENT_EXT_EOH_SYNC_GEOSTONE = 725,             /**< Runs the _EOH_SYNC_GEOSTONE command. */
    EVENT_EXT_EOH_SYNC_SEARCH_CHARA = 726,         /**< Runs the _EOH_SYNC_SEARCH_CHARA command. */
    EVENT_EXT_EOH_NORMAL_DRIVE = 727,              /**< Runs the _EOH_NORMAL_DRIVE command. */
    EVENT_EXT_EOH_SYNC_EDIT_OBJ = 728,             /**< Runs the _EOH_SYNC_EDIT_OBJ command. */
    EVENT_EXT_EOH_SET_FRAME_ALPHA = 729,           /**< Runs the _EOH_SET_FRAME_ALPHA command. */
    EVENT_EXT_EOH_SYNC_FUNCP = 730,                /**< Runs the _EOH_SYNC_FUNCP command. */
    EVENT_EXT_EOH_SET_FOOT_SE_ID = 731,            /**< Runs the _EOH_SET_FOOT_SE_ID command. */
    EVENT_EXT_EOH_SYNC_DOOR_PARTS = 732,           /**< Runs the _EOH_SYNC_DOOR_PARTS command. */
    EVENT_EXT_SPHIDA_INIT = 750,                   /**< Runs the _SPHIDA_INIT command. */
    EVENT_EXT_SPHIDA_SET_UP = 751,                 /**< Runs the _SPHIDA_SET_UP command. */
    EVENT_EXT_SPHIDA_SET_PLAY_FLAG = 752,          /**< Runs the _SPHIDA_SET_PLAY_FLAG command. */
    EVENT_EXT_SPHIDA_SET_MINIMAP_FLAG = 753,       /**< Runs the _SPHIDA_SET_MINIMAP_FLAG command. */
    EVENT_EXT_SPHIDA_SET_MM_LINE_FLAG = 754,       /**< Runs the _SPHIDA_SET_MM_LINE_FLAG command. */
    EVENT_EXT_SPHIDA_SET_MM_LINE_POS = 755,        /**< Runs the _SPHIDA_SET_MM_LINE_POS command. */
    EVENT_EXT_SPHIDA_SET_PIN_POS = 756,            /**< Runs the _SPHIDA_SET_PIN_POS command. */
    EVENT_EXT_SPHIDA_GET_PIN_POS = 757,            /**< Runs the _SPHIDA_GET_PIN_POS command. */
    EVENT_EXT_SPHIDA_SET_BALL_POS = 758,           /**< Runs the _SPHIDA_SET_BALL_POS command. */
    EVENT_EXT_SPHIDA_GET_BALL_POS = 759,           /**< Runs the _SPHIDA_GET_BALL_POS command. */
    EVENT_EXT_SPHIDA_SET_PIN_COL = 760,            /**< Runs the _SPHIDA_SET_PIN_COL command. */
    EVENT_EXT_SPHIDA_GET_PIN_COL = 761,            /**< Runs the _SPHIDA_GET_PIN_COL command. */
    EVENT_EXT_SPHIDA_SET_BALL_COL = 762,           /**< Runs the _SPHIDA_SET_BALL_COL command. */
    EVENT_EXT_SPHIDA_GET_BALL_COL = 763,           /**< Runs the _SPHIDA_GET_BALL_COL command. */
    EVENT_EXT_SPHIDA_SET_PAR_COUNT = 764,          /**< Runs the _SPHIDA_SET_PAR_COUNT command. */
    EVENT_EXT_SPHIDA_GET_PAR_COUNT = 765,          /**< Runs the _SPHIDA_GET_PAR_COUNT command. */
    EVENT_EXT_SPHIDA_GET_MINI_LEVEL = 766,         /**< Runs the _SPHIDA_GET_MINI_LEVEL command. */
    EVENT_EXT_SPHIDA_GET_TEXB = 767,               /**< Runs the _SPHIDA_GET_TEXB command. */
    EVENT_EXT_SPHIDA_SET_STATUS_FLAG = 768,        /**< Runs the _SPHIDA_SET_STATUS_FLAG command. */
    EVENT_EXT_SPHIDA_RESET_POWGAGE = 769,          /**< Runs the _SPHIDA_RESET_POWGAGE command. */
    EVENT_EXT_SPHIDA_START_POWGAGE = 770,          /**< Runs the _SPHIDA_START_POWGAGE command. */
    EVENT_EXT_SPHIDA_TRIGGER_POWGAGE = 771,        /**< Runs the _SPHIDA_TRIGGER_POWGAGE command. */
    EVENT_EXT_SPHIDA_GET_SHOT_POW = 772,           /**< Runs the _SPHIDA_GET_SHOT_POW command. */
    EVENT_EXT_SPHIDA_GET_POWGAGE_CODE = 773,       /**< Runs the _SPHIDA_GET_POWGAGE_CODE command. */
    EVENT_EXT_SPHIDA_SET_POWGAGE_SAFE_LEVEL = 774, /**< Runs the _SPHIDA_SET_POWGAGE_SAFE_LEVEL command. */
    EVENT_EXT_SPHIDA_GET_CULB_DEF = 775,           /**< Runs the _SPHIDA_GET_CULB_DEF command. */
    EVENT_EXT_SPHIDA_SET_SPIN_MARK_POS = 776,      /**< Runs the _SPHIDA_SET_SPIN_MARK_POS command. */
    EVENT_EXT_SPHIDA_SET_CULB_NO = 777,            /**< Runs the _SPHIDA_SET_CULB_NO command. */
    EVENT_EXT_SPHIDA_CALC_CARRY = 778,             /**< Runs the _SPHIDA_CALC_CARRY command. */
    EVENT_EXT_SPHIDA_GET_PG_CURSOR_POS = 779,      /**< Runs the _SPHIDA_GET_PG_CURSOR_POS command. */
    EVENT_EXT_SPHIDA_SET_COL_MODEL = 780,          /**< Runs the _SPHIDA_SET_COL_MODEL command. */
    EVENT_EXT_SPHIDA_GET_PRIZE = 781,              /**< Runs the _SPHIDA_GET_PRIZE command. */
    EVENT_EXT_SPHIDA_SET_LAST_CHALLENGE = 782,     /**< Runs the _SPHIDA_SET_LAST_CHALLENGE command. */
    EVENT_EXT_SPHIDA_GET_LAST_CHALLENGE = 783,     /**< Runs the _SPHIDA_GET_LAST_CHALLENGE command. */
    EVENT_EXT_SPHIDA_GET_OMAKE_MODE = 784,         /**< Runs the _SPHIDA_GET_OMAKE_MODE command. */
    EVENT_EXT_SPHIDA_SET_NOW_HOLE = 785,           /**< Runs the _SPHIDA_SET_NOW_HOLE command. */
    EVENT_EXT_SPHIDA_GET_NOW_HOLE = 786,           /**< Runs the _SPHIDA_GET_NOW_HOLE command. */
    EVENT_EXT_SPHIDA_SET_SCORE = 787,              /**< Runs the _SPHIDA_SET_SCORE command. */
    EVENT_EXT_SPHIDA_GET_SCORE = 788,              /**< Runs the _SPHIDA_GET_SCORE command. */
    EVENT_EXT_ZERO_VECTOR = 1000,                  /**< Runs the _ZERO_VECTOR command. */
    EVENT_EXT_NORMAL_VECTOR = 1001,                /**< Runs the _NORMAL_VECTOR command. */
    EVENT_EXT_COPY_VECTOR = 1002,                  /**< Runs the _COPY_VECTOR command. */
    EVENT_EXT_ADD_VECTOR = 1003,                   /**< Runs the _ADD_VECTOR command. */
    EVENT_EXT_SUB_VECTOR = 1004,                   /**< Runs the _SUB_VECTOR command. */
    EVENT_EXT_SCALE_VECTOR = 1005,                 /**< Runs the _SCALE_VECTOR command. */
    EVENT_EXT_DIV_VECTOR = 1006,                   /**< Runs the _DIV_VECTOR command. */
    EVENT_EXT_DIST_VECTOR = 1007,                  /**< Runs the _DIST_VECTOR command. */
    EVENT_EXT_DIST_VECTOR2 = 1008,                 /**< Runs the _DIST_VECTOR2 command. */
    EVENT_EXT_SQRT = 1009,                         /**< Runs the _SQRT command. */
    EVENT_EXT_ATAN2F = 1010,                       /**< Runs the _ATAN2F command. */
    EVENT_EXT_ANGLE_CMP = 1011,                    /**< Runs the _ANGLE_CMP command. */
    EVENT_EXT_ANGLE_LIMIT = 1012,                  /**< Runs the _ANGLE_LIMIT command. */
    EVENT_EXT_GET_RAND = 1013,                     /**< Runs the _GET_RAND command. */
    EVENT_EXT_LINE_POINT_DIST = 1014,              /**< Runs the _LINE_POINT_DIST command. */
    EVENT_EXT_CREATE_SWORD_EFFECT = 1015,          /**< Runs the _CREATE_SWORD_EFFECT command. */
    EVENT_EXT_DELETE_SWORD_EFFECT = 1016,          /**< Runs the _DELETE_SWORD_EFFECT command. */
    EVENT_EXT_SWORD_EFFECT_COLOR = 1017,           /**< Runs the _SWORD_EFFECT_COLOR command. */
    EVENT_EXT_SWORD_EFFECT_ADD_POINT = 1018,       /**< Runs the _SWORD_EFFECT_ADD_POINT command. */
    EVENT_EXT_ADD_CHARA_POS = 1019,                /**< Runs the _ADD_CHARA_POS command. */
    EVENT_EXT_ADD_CHARA_ROT = 1020,                /**< Runs the _ADD_CHARA_ROT command. */
    EVENT_EXT_POST_TREASURE_BOX = 1021,            /**< Runs the _POST_TREASURE_BOX command. */
    EVENT_EXT_GET_PARTS_ORIGIN = 1022,             /**< Runs the _GET_PARTS_ORIGIN command. */
    EVENT_EXT_CTRLC_STEP = 1023,                   /**< Runs the _CTRLC_STEP command. */
    EVENT_EXT_CTRLC_SET_ROTATE = 1024,             /**< Runs the _CTRLC_SET_ROTATE command. */
    EVENT_EXT_CTRLC_MOVE_CAMERA = 1025,            /**< Runs the _CTRLC_MOVE_CAMERA command. */
    EVENT_EXT_CTRLC_SET_ROT_CANCEL = 1026,         /**< Runs the _CTRLC_SET_ROT_CANCEL command. */
    EVENT_EXT_CTRLC_MOVE_RANGE = 1027,             /**< Runs the _CTRLC_MOVE_RANGE command. */
    EVENT_EXT_GET_NEAR_TBOX_POS = 1028,            /**< Runs the _GET_NEAR_TBOX_POS command. */
    EVENT_EXT_CONV_CHRNO_S2L = 1029,               /**< Runs the _CONV_CHRNO_S2L command. */
    EVENT_EXT_SWE_INIT = 1030,                     /**< Runs the _SWE_INIT command. */
    EVENT_EXT_SWE_SET_COLOR = 1031,                /**< Runs the _SWE_SET_COLOR command. */
    EVENT_EXT_SWE_SET_TEXTURE = 1032,              /**< Runs the _SWE_SET_TEXTURE command. */
    EVENT_EXT_SWE_START_EFFECT = 1033,             /**< Runs the _SWE_START_EFFECT command. */
    EVENT_EXT_SET_CHARA_TYPE = 1034,               /**< Runs the _SET_CHARA_TYPE command. */
    EVENT_EXT_GET_EVENT_DATA = 1035,               /**< Runs the _GET_EVENT_DATA command. */
    EVENT_EXT_DNG_SET_PREV_FLOOR = 1036,           /**< Runs the _DNG_SET_PREV_FLOOR command. */
    EVENT_EXT_DNG_GET_PREV_FLOOR = 1037,           /**< Runs the _DNG_GET_PREV_FLOOR command. */
    EVENT_EXT_DNG_SET_FAST_FLOOR = 1038,           /**< Runs the _DNG_SET_FAST_FLOOR command. */
    EVENT_EXT_SET_FLOOR_INFO = 1039,               /**< Runs the _SET_FLOOR_INFO command. */
    EVENT_EXT_GET_FLOOR_INFO = 1040,               /**< Runs the _GET_FLOOR_INFO command. */
    EVENT_EXT_GET_NEXT_FLOOR = 1041,               /**< Runs the _GET_NEXT_FLOOR command. */
    EVENT_EXT_PAD_AUTO_REPEAT_OFF = 1042,          /**< Runs the _PAD_AUTO_REPEAT_OFF command. */
    EVENT_EXT_PAD_SET_AUTO_REPEAT = 1043,          /**< Runs the _PAD_SET_AUTO_REPEAT command. */
    EVENT_EXT_DNG_PAUSE = 1044,                    /**< Runs the _DNG_PAUSE command. */
    EVENT_EXT_DNG_CHECK_PAUSE = 1045,              /**< Runs the _DNG_CHECK_PAUSE command. */
    EVENT_EXT_DNG_RESET_TIMER = 1046,              /**< Runs the _DNG_RESET_TIMER command. */
    EVENT_EXT_DNG_GET_TIMER = 1047,                /**< Runs the _DNG_GET_TIMER command. */
    EVENT_EXT_LOAD_SKIN = 1048,                    /**< Runs the _LOAD_SKIN command. */
    EVENT_EXT_CHK_CAMERA_COL = 1049,               /**< Runs the _CHK_CAMERA_COL command. */
    EVENT_EXT_GET_PARTS_FUNC_POS = 1050,           /**< Runs the _GET_PARTS_FUNC_POS command. */
    EVENT_EXT_RANDOM_CIRCLE_GET_POS = 1051,        /**< Runs the _RANDOM_CIRCLE_GET_POS command. */
    EVENT_EXT_RANDOM_CIRCLE_OFF = 1052,            /**< Runs the _RANDOM_CIRCLE_OFF command. */
    EVENT_EXT_DNG_XCHG_MAP_LIGHT = 1053,           /**< Runs the _DNG_XCHG_MAP_LIGHT command. */
    EVENT_EXT_GEOSTONE_ANIME_OFF = 1054,           /**< Runs the _GEOSTONE_ANIME_OFF command. */
    EVENT_EXT_GEOSTONE_SET_FLAG = 1055,            /**< Runs the _GEOSTONE_SET_FLAG command. */
    EVENT_EXT_GEOSTONE_SET_REFERENCE = 1056,       /**< Runs the _GEOSTONE_SET_REFERENCE command. */
    EVENT_EXT_GEOSTONE_DEL_REFERENCE = 1057,       /**< Runs the _GEOSTONE_DEL_REFERENCE command. */
    EVENT_EXT_GET_ROBO_MOVE_TYPE = 1058,           /**< Runs the _GET_ROBO_MOVE_TYPE command. */
    EVENT_EXT_SET_EXIT_FLAG = 1059,                /**< Runs the _SET_EXIT_FLAG command. */
    EVENT_EXT_GET_EXIT_FLAG = 1060,                /**< Runs the _GET_EXIT_FLAG command. */
    EVENT_EXT_GET_E3_VERSION = 1061,               /**< Runs the _GET_E3_VERSION command. */
    EVENT_EXT_CHK_PAD_CTRL = 1062,                 /**< Runs the _CHK_PAD_CTRL command. */
    EVENT_EXT_CTRLC_STAY = 1063,                   /**< Runs the _CTRLC_STAY command. */
    EVENT_EXT_BSCN_SET_BLIGHT_RATE = 1064,         /**< Runs the _BSCN_SET_BLIGHT_RATE command. */
    EVENT_EXT_GET_RND_CIRCLE_TRAPID = 1065,        /**< Runs the _GET_RND_CIRCLE_TRAPID command. */
    EVENT_EXT_SET_RND_CIRCLE_STATUS = 1066,        /**< Runs the _SET_RND_CIRCLE_STATUS command. */
    EVENT_EXT_SET_STATUSBAR_SHOW = 1067,           /**< Runs the _SET_STATUSBAR_SHOW command. */
    EVENT_EXT_SET_PULL_ITEM = 1068,                /**< Runs the _SET_PULL_ITEM command. */
    EVENT_EXT_MENU_CHARA_CHENGE = 1069,            /**< Runs the _MENU_CHARA_CHENGE command. */
    EVENT_EXT_GET_EVENT_INFO_SNDID = 1070,         /**< Runs the _GET_EVENT_INFO_SNDID command. */
    EVENT_EXT_GET_PARTS_POS = 1071,                /**< Runs the _GET_PARTS_POS command. */
    EVENT_EXT_CANCEL_DRAMA_SCENE = 1072,           /**< Runs the _CANCEL_DRAMA_SCENE command. */
    EVENT_EXT_GET_RNDC_MOT_NOWT = 1073,            /**< Runs the _GET_RNDC_MOT_NOWT command. */
    EVENT_EXT_SET_CHARA_MOT_NOWT = 1074,           /**< Runs the _SET_CHARA_MOT_NOWT command. */
    EVENT_EXT_CHARA_NORMAL_DRIVE = 1075,           /**< Runs the _CHARA_NORMAL_DRIVE command. */
    EVENT_EXT_CHARA_RESET_DA = 1076,               /**< Runs the _CHARA_RESET_DA command. */
    EVENT_EXT_DNG_SETUP_MAIN_UNIT = 1077,          /**< Runs the _DNG_SETUP_MAIN_UNIT command. */
    EVENT_EXT_JOIN_PARTY_MEMBER = 1078,            /**< Runs the _JOIN_PARTY_MEMBER command. */
    EVENT_EXT_SET_CHARA_CHANGE_FLAG = 1079,        /**< Runs the _SET_CHARA_CHANGE_FLAG command. */
    EVENT_EXT_SET_CHARA_CHANGE_MASK = 1080,        /**< Runs the _SET_CHARA_CHANGE_MASK command. */
    EVENT_EXT_CHANGE_DIR = 1081,                   /**< Runs the _CHANGE_DIR command. */
    EVENT_EXT_SUB_ITEM = 1082,                     /**< Runs the _SUB_ITEM command. */
    EVENT_EXT_SET_CHARA_EQUIP = 1083,              /**< Runs the _SET_CHARA_EQUIP command. */
    EVENT_EXT_LOAD_PACK_FILE = 1084,               /**< Runs the _LOAD_PACK_FILE command. */
    EVENT_EXT_SET_BIT_CTRL = 1085,                 /**< Runs the _SET_BIT_CTRL command. */
    EVENT_EXT_GET_BIT_CTRL = 1086,                 /**< Runs the _GET_BIT_CTRL command. */
    EVENT_EXT_LOAD_ARG = 1087,                     /**< Runs the _LOAD_ARG command. */
    EVENT_EXT_GET_ITEM_HAVE_NUM = 1088,            /**< Runs the _GET_ITEM_HAVE_NUM command. */
    EVENT_EXT_SET_SKIP_BOTTON = 1089,              /**< Runs the _SET_SKIP_BOTTON command. */
    EVENT_EXT_SET_SKIP_FCOL = 1090,                /**< Runs the _SET_SKIP_FCOL command. */
    EVENT_EXT_GET_DEBUG_MODE = 1091,               /**< Runs the _GET_DEBUG_MODE command. */
    EVENT_EXT_GET_MAP_TYPE = 1092,                 /**< Runs the _GET_MAP_TYPE command. */
    EVENT_EXT_DNG_COLLISION_ALL_CLR = 1093,        /**< Runs the _DNG_COLLISION_ALL_CLR command. */
    EVENT_EXT_SET_MAP_DRAW = 1094,                 /**< Runs the _SET_MAP_DRAW command. */
    EVENT_EXT_CHECK_MC_LOAD = 1095,                /**< Runs the _CHECK_MC_LOAD command. */
    EVENT_EXT_SET_NOW_MAP_NO = 1096,               /**< Runs the _SET_NOW_MAP_NO command. */
    EVENT_EXT_GET_TBOX_PARAM = 1097,               /**< Runs the _GET_TBOX_PARAM command. */
    EVENT_EXT_CANCEL_LOAD_VILLAGER = 1098,         /**< Runs the _CANCEL_LOAD_VILLAGER command. */
    EVENT_EXT_CANCEL_NOW_LOADING = 1099,           /**< Runs the _CANCEL_NOW_LOADING command. */
    EVENT_EXT_ESM_INITIALIZE = 1100,               /**< Runs the _ESM_INITIALIZE command. */
    EVENT_EXT_ESM_INIT_FIX = 1101,                 /**< Runs the _ESM_INIT_FIX command. */
    EVENT_EXT_ESM_CLEAR = 1102,                    /**< Runs the _ESM_CLEAR command. */
    EVENT_EXT_ESM_LOAD_BASE = 1103,                /**< Runs the _ESM_LOAD_BASE command. */
    EVENT_EXT_ESM_CREATE = 1104,                   /**< Runs the _ESM_CREATE command. */
    EVENT_EXT_ESM_FINISH = 1105,                   /**< Runs the _ESM_FINISH command. */
    EVENT_EXT_ESM_DELETE = 1106,                   /**< Runs the _ESM_DELETE command. */
    EVENT_EXT_ESM_SET_VECT1 = 1107,                /**< Runs the _ESM_SET_VECT1 command. */
    EVENT_EXT_ESM_SET_VECT2 = 1108,                /**< Runs the _ESM_SET_VECT2 command. */
    EVENT_EXT_ESM_SET_TARGET_ID = 1109,            /**< Runs the _ESM_SET_TARGET_ID command. */
    EVENT_EXT_ESM_LOAD_BASE_PACK = 1110,           /**< Runs the _ESM_LOAD_BASE_PACK command. */
    EVENT_EXT_ESM_SET_VALUE = 1111,                /**< Runs the _ESM_SET_VALUE command. */
    EVENT_EXT_SET_CHARA_CONDITION = 1200,          /**< Runs the _SET_CHARA_CONDITION command. */
    EVENT_EXT_ADD_WHP = 1201,                      /**< Runs the _ADD_WHP command. */
    EVENT_EXT_ADD_HP_RATE = 1202,                  /**< Runs the _ADD_HP_RATE command. */
    EVENT_EXT_GET_TIME = 1203,                     /**< Runs the _GET_TIME command. */
    EVENT_EXT_CHECK_GET_ITEM_LIMIT = 1204,         /**< Runs the _CHECK_GET_ITEM_LIMIT command. */
    EVENT_EXT_CHECK_ITEM_OVER = 1205,              /**< Runs the _CHECK_ITEM_OVER command. */
    EVENT_EXT_GET_NOW_LOOP_NO = 1206,              /**< Runs the _GET_NOW_LOOP_NO command. */
    EVENT_EXT_IS_CLEAR_DESTROY = 1207,             /**< Runs the _IS_CLEAR_DESTROY command. */
    EVENT_EXT_IS_CLEAR_PRACTICE = 1208,            /**< Runs the _IS_CLEAR_PRACTICE command. */
    EVENT_EXT_IS_PLAY_SUB_GAME = 1209,             /**< Runs the _IS_PLAY_SUB_GAME command. */
    EVENT_EXT_RESET_SUBJECT_COUNTER = 1210,        /**< Runs the _RESET_SUBJECT_COUNTER command. */
    EVENT_EXT_SCR_EFF_INIT_RASTER = 1211,          /**< Runs the _SCR_EFF_INIT_RASTER command. */
    EVENT_EXT_SCR_EFF_START_RASTER = 1212,         /**< Runs the _SCR_EFF_START_RASTER command. */
    EVENT_EXT_SCR_EFF_STOP_RASTER = 1213,          /**< Runs the _SCR_EFF_STOP_RASTER command. */
    EVENT_EXT_SET_MPCHARA_MOTION = 1214,           /**< Runs the _SET_MPCHARA_MOTION command. */
    EVENT_EXT_FUNC_POINT_POS = 1215,               /**< Runs the _FUNC_POINT_POS command. */
    EVENT_EXT_CTRLC_ROT_BACK = 1216,               /**< Runs the _CTRLC_ROT_BACK command. */
    EVENT_EXT_PARTS_NAME_STRCMP = 1217,            /**< Runs the _PARTS_NAME_STRCMP command. */
    EVENT_EXT_GET_TRIAL_VERSION = 1218,            /**< Runs the _GET_TRIAL_VERSION command. */
    EVENT_EXT_SET_FLOOR_EPISODE = 1219,            /**< Runs the _SET_FLOOR_EPISODE command. */
    EVENT_EXT_FUNC_POINT_GET_POS = 1220,           /**< Runs the _FUNC_POINT_GET_POS command. */
    EVENT_EXT_FUNC_POINT_GET_ROT = 1221,           /**< Runs the _FUNC_POINT_GET_ROT command. */
    EVENT_EXT_ACTCHR_SET_DEF_MOTION = 1222,        /**< Runs the _ACTCHR_SET_DEF_MOTION command. */
    EVENT_EXT_ADD_FUSION_POINT = 1223,             /**< Runs the _ADD_FUSION_POINT command. */
    EVENT_EXT_GET_DEBUG_FLAG = 1224,               /**< Runs the _GET_DEBUG_FLAG command. */
    EVENT_EXT_MINIMAP_DOOR_ENABLE = 1225,          /**< Runs the _MINIMAP_DOOR_ENABLE command. */
    EVENT_EXT_DNG_CHECK_BOSS_MAP = 1226,           /**< Runs the _DNG_CHECK_BOSS_MAP command. */
    EVENT_EXT_DNG_RUN_EVENT = 1227,                /**< Runs the _DNG_RUN_EVENT command. */
    EVENT_EXT_CHECK_ENABLE_CHARA_CHANGE = 1228,    /**< Runs the _CHECK_ENABLE_CHARA_CHANGE command. */
    EVENT_EXT_INIT_SEPIA = 1229,                   /**< Runs the _INIT_SEPIA command. */
    EVENT_EXT_START_SEPIA = 1230,                  /**< Runs the _START_SEPIA command. */
    EVENT_EXT_END_SEPIA = 1231,                    /**< Runs the _END_SEPIA command. */
    EVENT_EXT_COPY_MONS2SCNCHR = 1232,             /**< Runs the _COPY_MONS2SCNCHR command. */
    EVENT_EXT_UNLOCK_STACK = 1233,                 /**< Runs the _UNLOCK_STACK command. */
    EVENT_EXT_RESET_EVENT_TRG = 1234,              /**< Runs the _RESET_EVENT_TRG command. */
    EVENT_EXT_SET_CHARA_NO = 1235,                 /**< Runs the _SET_CHARA_NO command. */
    EVENT_EXT_GET_CHARA_NO = 1236,                 /**< Runs the _GET_CHARA_NO command. */
    EVENT_EXT_SEARCH_CHARA_NO = 1237,              /**< Runs the _SEARCH_CHARA_NO command. */
    EVENT_EXT_GET_NEAR_RANDOM_STONE_POS = 1238,    /**< Runs the _GET_NEAR_RANDOM_STONE_POS command. */
    EVENT_EXT_INIT_MONO_FLASH = 1239,              /**< Runs the _INIT_MONO_FLASH command. */
    EVENT_EXT_START_MONO_FLASH = 1240,             /**< Runs the _START_MONO_FLASH command. */
    EVENT_EXT_END_MONO_FLASH = 1241,               /**< Runs the _END_MONO_FLASH command. */
    EVENT_EXT_DELETE_VILLAGER = 1242,              /**< Runs the _DELETE_VILLAGER command. */
    EVENT_EXT_DNG_SET_WEATHER = 1243,              /**< Runs the _DNG_SET_WEATHER command. */
    EVENT_EXT_SET_CHARA_MAXHP = 1244,              /**< Runs the _SET_CHARA_MAXHP command. */
    EVENT_EXT_SET_CHARA_DEFENCE = 1245,            /**< Runs the _SET_CHARA_DEFENCE command. */
    EVENT_EXT_PLACE_PARTS_NAME_STRCMP = 1246,      /**< Runs the _PLACE_PARTS_NAME_STRCMP command. */
    EVENT_EXT_GOTO_USE_ITEM2 = 1247,               /**< Runs the _GOTO_USE_ITEM2 command. */
    EVENT_EXT_DBG_SET_ANALYZE_FLAG = 1248,         /**< Runs the _DBG_SET_ANALYZE_FLAG command. */
    EVENT_EXT_ATRAMIRIA_ON_OFF = 1249,             /**< Runs the _ATRAMIRIA_ON_OFF command. */
    EVENT_EXT_ADD_YARIKOMI_MEDAL = 1250,           /**< Runs the _ADD_YARIKOMI_MEDAL command. */
    EVENT_EXT_SET_MAP_EFFECT_ID = 1251,            /**< Runs the _SET_MAP_EFFECT_ID command. */
    EVENT_EXT_GET_MAP_EFFECT_ID = 1252,            /**< Runs the _GET_MAP_EFFECT_ID command. */
    EVENT_EXT_DNG_FLOOR_INIT = 1253,               /**< Runs the _DNG_FLOOR_INIT command. */
    EVENT_EXT_DNG_FLOOR_FINISH = 1254,             /**< Runs the _DNG_FLOOR_FINISH command. */
    EVENT_EXT_CLEAR_RND_STONE = 1255,              /**< Runs the _CLEAR_RND_STONE command. */
    EVENT_EXT_GET_FLOOR_STATUS = 1256,             /**< Runs the _GET_FLOOR_STATUS command. */
    EVENT_EXT_SET_FLOOR_STATUS = 1257,             /**< Runs the _SET_FLOOR_STATUS command. */
    EVENT_EXT_AMG_GET_ATTR_STATUS = 1258,          /**< Runs the _AMG_GET_ATTR_STATUS command. */
    EVENT_EXT_SET_NEAR_DIST = 1259,                /**< Runs the _SET_NEAR_DIST command. */
    EVENT_EXT_SET_KEEP_TIME = 1260,                /**< Runs the _SET_KEEP_TIME command. */
    EVENT_EXT_GET_KEEP_TIME = 1261,                /**< Runs the _GET_KEEP_TIME command. */
    EVENT_EXT_GET_DOOR_PARTS_ID = 1262,            /**< Runs the _GET_DOOR_PARTS_ID command. */
    EVENT_EXT_CHECK_EQUEP_CHANGE = 1263,           /**< Runs the _CHECK_EQUEP_CHANGE command. */
    EVENT_EXT_ADD_HP_RATE2 = 1264,                 /**< Runs the _ADD_HP_RATE2 command. */
    EVENT_EXT_DNG_EFFECT_ALL_CLEAR = 1265,         /**< Runs the _DNG_EFFECT_ALL_CLEAR command. */
    EVENT_EXT_AUTO_CHENGE_BGM_VOL = 1266,          /**< Runs the _AUTO_CHENGE_BGM_VOL command. */
    EVENT_EXT_UDATA_GET_WHP = 1267,                /**< Runs the _UDATA_GET_WHP command. */
    EVENT_EXT_UDATA_ADD_WHP = 1268,                /**< Runs the _UDATA_ADD_WHP command. */
    EVENT_EXT_UDATA_GET_ABS = 1269,                /**< Runs the _UDATA_GET_ABS command. */
    EVENT_EXT_UDATA_ADD_ABS = 1270,                /**< Runs the _UDATA_ADD_ABS command. */
    EVENT_EXT_DNG_CREATE_EFFECT = 1271,            /**< Runs the _DNG_CREATE_EFFECT command. */
    EVENT_EXT_LEAVE_MONICA_ITEM_CHECK = 1272,      /**< Runs the _LEAVE_MONICA_ITEM_CHECK command. */
    EVENT_EXT_PAUSE_ENABLE_FLAG = 1273,            /**< Runs the _PAUSE_ENABLE_FLAG command. */
    EVENT_EXT_FORCE_BOOT_TOUR = 1274,              /**< Runs the _FORCE_BOOT_TOUR command. */
    EVENT_EXT_MT_TEST = 998,                       /**< Runs the _MT_TEST command. */
    EVENT_EXT_TEST = 999,                          /**< Runs the _TEST command. */
    EVENT_EXT_END = -1,                            /**< Ends the command definition table. */
};

/**
 *
 * Numeric identifiers of commands in event argument scripts.
 *
 */
enum EventArgumentCommand {
    EVENT_ARG_DATA = 0,      /**< Records one argument list. */
    EVENT_ARG_ID_OFFSET = 1, /**< Selects the next argument-list identifier. */
};

/**
 *
 * Kinds of game thing an event object handle refers to, as CEoh::type holds them.
 *
 */
enum EOH_TYPE {
    EOH_TYPE_NONE = -1,      /**< The handle refers to nothing. */
    EOH_TYPE_CHARA = 0,      /**< A scene character. */
    EOH_TYPE_OBJECT = 1,     /**< A map object. */
    EOH_TYPE_SPRITE = 2,     /**< An event sprite. */
    EOH_TYPE_FRAME = 3,      /**< A model frame. */
    EOH_TYPE_FUNC_POINT = 4, /**< A map function point. */
};

/**
 *
 * Number of event object handles an event can hold at once.
 *
 */
#define EOH_NUM 32

/**
 *
 * Progress of a raster (wavy screen) effect, as CRaster::state holds it.
 *
 */
enum RASTER_STATE {
    RASTER_OFF = 0,   /**< The effect is not drawn. */
    RASTER_START = 1, /**< The effect is moving towards its target strength. */
    RASTER_ON = 2,    /**< The effect is drawn at a steady strength. */
    RASTER_STOP = 3,  /**< The effect is fading out, and turns off once the fade ends. */
};

/**
 *
 * Number of movie captions an event can queue.
 *
 */
#define EVENT_CAPTION_NUM 18

/**
 *
 * State that the running town or dungeon event and its script share with the
 * game loops: the event's world coordinate, its requests to change map or mode,
 * skip, sound, stream, door, stopwatch and movie caption settings.
 *
 */
struct ED_EVENT_INFO {
    sceVu0FVECTOR      world_coord_pos; /**< Origin of the event's world coordinate. */
    sceVu0FVECTOR      world_coord_rot; /**< Rotation, in radians, of the event's world coordinate. */
    float              projection;      /**< Projection distance used while the event is drawn. */
    u8                 unk_24[0x40];
    int                jump_point;          /**< Entry point on the map an event moves the player to, or -1. */
    char               jump_map_name[0x20]; /**< Name of the map or interior an event moves the player to. */
    int                event_no;            /**< Event started after a map change or script load, or below zero for none. */
    char               script_name[0x40];   /**< Path of the event script file the event asks to load. */
    int                request;             /**< Request the event leaves for the game loop. @see EVENT_REQUEST. */
    int                command_mode;        /**< How the running script is advanced each frame. @see EVENT_COMMAND_MODE. */
    int                skip_state;          /**< Progress of skipping the drama scene. @see EVENT_SKIP_STATE. */
    int                skip_button;         /**< Pad button that skips the drama scene. */
    s32                unk_dc;
    float              skip_fade_color[4]; /**< Colour the screen fades to when the drama scene is skipped. */
    int                start_button;       /**< Pad button that the script reads as its start button. */
    int                snd_id[12];         /**< Sound bank handle loaded into each sound port. */
    int                last_snd_id;        /**< Sound bank handle loaded most recently. */
    s32                unk_128;
    float              env_bgm_volume;                        /**< Volume of the environment music the event started. */
    int                env_bgm_no;                            /**< Environment music the event started. */
    int                stream_playing;                        /**< Non-zero while a voice stream the event started is playing. */
    int                stream_from_fpl;                       /**< Non-zero when the open voice stream was opened from a voice pack. */
    int                func_iparam[16];                       /**< Integer parameters of the door mode: character number, entry point and sound effect. */
    float              func_fparam[16];                       /**< Float parameters of the door mode: position, facing, camera position and look-at offset. */
    int                monster_talk[3];                       /**< Talk data of the monster the player spoke to in the dungeon. */
    int                door_type;                             /**< Kind of door the door mode opens, choosing its sound effect. */
    int                interior_entrance;                     /**< Entrance of the interior an event moves the player into. */
    u64                stopwatch_start;                       /**< Play time at which the stopwatch started, or 0 while it is stopped. */
    s64                stopwatch_limit;                       /**< Time limit the stopwatch counts down from, or 0 to count up. */
    int                stopwatch_x;                           /**< Screen X position of the stopwatch. */
    int                stopwatch_y;                           /**< Screen Y position of the stopwatch. */
    int                stopwatch_style;                       /**< Layout the stopwatch is drawn in. */
    CMapParts         *dng_event_parts;                       /**< Dungeon map part the player triggered an event at. */
    int                dng_event_found;                       /**< Non-zero once a dungeon event part has been found. */
    int                pack_loaded;                           /**< Non-zero while the read buffer holds a pack file that loads search first. */
    int                map_draw;                              /**< Non-zero while the map is drawn behind the event. */
    int                stream_reading;                        /**< Non-zero while a stream reads the disc, so files may not be loaded. */
    int                stream_volume;                         /**< Volume the event plays its voice stream at. */
    int                caption_enable;                        /**< Non-zero while movie captions are drawn. */
    int                caption_start[EVENT_CAPTION_NUM];      /**< Movie frame at which each caption appears. */
    int                caption_frames[EVENT_CAPTION_NUM];     /**< Number of movie frames each caption stays. */
    char               caption_text[EVENT_CAPTION_NUM][0xE1]; /**< Text of each caption. */
    u8                 unk_126a[0x2];
    char              *npc_talk_text; /**< Loaded NPC conversation text of the town. */
    int                npc_talk_size; /**< Size of the loaded NPC conversation text. */
    CScene::BGM_STATUS bgm_status;    /**< Music state the event saved and can restore. */
    float              keep_time;     /**< Time of day the event saved. */
    u8                 unk_1294[0xC];
};

STATIC_ASSERT(sizeof(ED_EVENT_INFO) == 0x12A0);

/**
 *
 * One handle through which an event script refers to a character, object,
 * sprite, frame or function point by a small number.
 *
 */
class CEoh {
public:
    int type;        /**< Kind of thing the handle refers to. @see EOH_TYPE. */
    int scene_no;    /**< Scene character slot of a character handle. */
    int world_coord; /**< Non-zero when positions given to an object or function point are in the event's world coordinate. */

    union {
        CCharacter2   *chara;      /**< Character the handle refers to. */
        CObject       *object;     /**< Map object the handle refers to. */
        CEventSprite2 *sprite;     /**< Event sprite the handle refers to. */
        mgCFrame      *frame;      /**< Model frame the handle refers to. */
        CFuncPoint    *func_point; /**< Function point the handle refers to. */
    };

    /**
     *
     * Makes a handle that refers to nothing.
     *
     * @mangled __ct__4CEohFv
     * @address 0x2608F0
     * @size 0x30
     */
    CEoh();

    /**
     *
     * Points the handle at a map object; returns 1 when the type is EOH_TYPE_OBJECT and the object exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP7CObjecti
     * @address 0x260920
     * @size 0x40
     */
    int Set(int new_kind, CObject *object, int new_flag);

    /**
     *
     * Points the handle at a scene character; returns 1 when the type is EOH_TYPE_CHARA and the character exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiiP11CCharacter2
     * @address 0x260960
     * @size 0x40
     */
    int Set(int new_kind, int new_chara_no, CCharacter2 *chara);

    /**
     *
     * Points the handle at an event sprite; returns 1 when the type is EOH_TYPE_SPRITE and the sprite exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP13CEventSprite2
     * @address 0x2609A0
     * @size 0x40
     */
    int Set(int new_kind, CEventSprite2 *sprite);

    /**
     *
     * Points the handle at a model frame; returns 1 when the type is EOH_TYPE_FRAME and the frame exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP8mgCFrame
     * @address 0x2609E0
     * @size 0x40
     */
    int Set(int new_kind, mgCFrame *frame);

    /**
     *
     * Points the handle at a function point; returns 1 when the type is EOH_TYPE_FUNC_POINT and the point exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP10CFuncPoint
     * @address 0x260A20
     * @size 0x50
     */
    int Set(int new_kind, CFuncPoint *new_func_point);
};

STATIC_ASSERT(sizeof(CEoh) == 0x10);

/**
 *
 * The event's table of object handles, through which event scripts move,
 * turn, scale, show and animate whatever each handle refers to.
 *
 */
class CEohMother {
public:
    CEoh eoh[EOH_NUM]; /**< Handles, indexed by the number the script uses. */

    /**
     *
     * Makes a table in which every handle refers to nothing.
     *
     * @mangled __ct__10CEohMotherFv
     * @address 0x260CE0
     * @size 0x180
     */
    CEohMother();

    /**
     *
     * Points a handle at a map object; returns 1 on success, 0 for a bad handle number or object.
     *
     * @mangled Set__10CEohMotherFiiP7CObjecti
     * @address 0x260E60
     * @size 0x40
     */
    int Set(int slot, int type, CObject *object, int flag);

    /**
     *
     * Points a handle at a scene character; returns 1 on success, 0 for a bad handle number or character.
     *
     * @mangled Set__10CEohMotherFiiiP11CCharacter2
     * @address 0x260EA0
     * @size 0x40
     */
    int Set(int slot, int kind, int chara_no, CCharacter2 *chara);

    /**
     *
     * Points a handle at an event sprite; returns 1 on success, 0 for a bad handle number or sprite.
     *
     * @mangled Set__10CEohMotherFiiP13CEventSprite2
     * @address 0x260EE0
     * @size 0x40
     */
    int Set(int slot, int kind, CEventSprite2 *sprite);

    /**
     *
     * Points a handle at a model frame; returns 1 on success, 0 for a bad handle number or frame.
     *
     * @mangled Set__10CEohMotherFiiP8mgCFrame
     * @address 0x260F20
     * @size 0x40
     */
    int Set(int slot, int kind, mgCFrame *frame);

    /**
     *
     * Points a handle at a function point; returns 1 on success, 0 for a bad handle number or point.
     *
     * @mangled Set__10CEohMotherFiiP10CFuncPoint
     * @address 0x260F60
     * @size 0x40
     */
    int Set(int slot, int kind, CFuncPoint *func_point);

    /**
     *
     * Moves what a handle refers to, converting from the event's world coordinate where it applies; returns 1 on success.
     *
     * @mangled SetPos__10CEohMotherFifff
     * @address 0x260FA0
     * @size 0x2A0
     */
    int SetPos(int slot, float x, float y, float z);

    /**
     *
     * Turns what a handle refers to, adding the rotation of the event's world coordinate; returns 1 on success.
     *
     * @mangled SetRot__10CEohMotherFifff
     * @address 0x261240
     * @size 0x220
     */
    int SetRot(int slot, float x, float y, float z);

    /**
     *
     * Gives the position of what a handle refers to in the event's world coordinate; returns 1 on success.
     *
     * @mangled GetPos__10CEohMotherFiPf
     * @address 0x261460
     * @size 0x1C0
     */
    int GetPos(int slot, float *pos);

    /**
     *
     * Gives the rotation of what a handle refers to in the event's world coordinate; returns 1 on success.
     *
     * @mangled GetRot__10CEohMotherFiPf
     * @address 0x261620
     * @size 0x1E0
     */
    int GetRot(int slot, float *rot);

    /**
     *
     * Starts a motion on a character handle, optionally at a given time; returns 1 on success.
     *
     * @mangled SetMotion__10CEohMotherFiPcif
     * @address 0x261800
     * @size 0xE0
     */
    int SetMotion(int slot, char *name, int type, float blend);

    /**
     *
     * Returns whether the motion of a character handle has ended, or 0 for a handle that is not a character.
     *
     * @mangled CheckMotionEnd__10CEohMotherFi
     * @address 0x2618E0
     * @size 0xA0
     */
    int CheckMotionEnd(int slot);

    /**
     *
     * Asks the motion sequence of a character handle to move on; returns 1 on success.
     *
     * @mangled SetMotionTrg__10CEohMotherFi
     * @address 0x261980
     * @size 0x80
     */
    int SetMotionTrg(int slot);

    /**
     *
     * Returns the progress of the motion sequence of a character handle, or 0 when it has none.
     *
     * @mangled GetSeqStatus__10CEohMotherFi
     * @address 0x261A00
     * @size 0x70
     */
    int GetSeqStatus(int slot);

    /**
     *
     * Sets the speed at which a character handle's motion plays; returns 1 on success.
     *
     * @mangled SetStep__10CEohMotherFif
     * @address 0x261A70
     * @size 0x70
     */
    int SetStep(int slot, float step);

    /**
     *
     * Sets the speed at which a character handle blends into its next motion; returns 1 on success.
     *
     * @mangled SetChangeStep__10CEohMotherFif
     * @address 0x261AE0
     * @size 0x80
     */
    int SetChangeStep(int slot, float step);

    /**
     *
     * Puts the motion of a character handle back to its start; returns 1 on success.
     *
     * @mangled ResetMotion__10CEohMotherFi
     * @address 0x261B60
     * @size 0x70
     */
    int ResetMotion(int slot);

    /**
     *
     * Switches a texture animation of a character handle on or off, or all of them off; returns 1 on success.
     *
     * @mangled SetTexAnim__10CEohMotherFiiPc
     * @address 0x261BD0
     * @size 0xC0
     */
    int SetTexAnim(int slot, int on, char *name);

    /**
     *
     * Scales what a handle refers to; returns 1 on success.
     *
     * @mangled SetScale__10CEohMotherFifff
     * @address 0x261C90
     * @size 0x140
     */
    int SetScale(int slot, float x, float y, float z);

    /**
     *
     * Gives the scale of what a handle refers to; returns 1 on success.
     *
     * @mangled GetScale__10CEohMotherFiPf
     * @address 0x261DD0
     * @size 0x120
     */
    int GetScale(int slot, float *scale);

    /**
     *
     * Shows or hides what a handle refers to; returns 1 on success.
     *
     * @mangled SetShow__10CEohMotherFii
     * @address 0x261EF0
     * @size 0xD0
     */
    int SetShow(int slot, int show);

    /**
     *
     * Gives whether what a handle refers to is shown; returns 1 on success.
     *
     * @mangled GetShow__10CEohMotherFiPi
     * @address 0x261FC0
     * @size 0xF0
     */
    int GetShow(int slot, int *show);

    /**
     *
     * Returns the frame of a character handle's model with a given name, or null.
     *
     * @mangled SearchFrame__10CEohMotherFiPc
     * @address 0x2620B0
     * @size 0x70
     */
    mgCFrame *SearchFrame(int slot, char *name);

    /**
     *
     * Shows or hides a named frame of what a handle refers to; returns 1 on success.
     *
     * @mangled SetFrameShow__10CEohMotherFiPci
     * @address 0x262120
     * @size 0xE0
     */
    int SetFrameShow(int slot, char *name, int show);

    /**
     *
     * Turns the shadow of a character handle on or off; returns 1 on success.
     *
     * @mangled SetShadow__10CEohMotherFii
     * @address 0x262200
     * @size 0x80
     */
    int SetShadow(int slot, int enable);

    /**
     *
     * Shows or hides a named frame of a character handle's shadow model; returns 1 on success.
     *
     * @mangled SetShadowFrameShow__10CEohMotherFiPci
     * @address 0x262280
     * @size 0xB0
     */
    int SetShadowFrameShow(int slot, char *name, int show);

    /**
     *
     * Sets the translation of a frame handle or of a character handle's model; returns 1 on success.
     *
     * @mangled SetTranslate__10CEohMotherFiPf
     * @address 0x262330
     * @size 0xD0
     */
    int SetTranslate(int slot, float *pos);

    /**
     *
     * Sets the colour of an event sprite handle; returns 1 on success.
     *
     * @mangled SetColor__10CEohMotherFiPf
     * @address 0x262400
     * @size 0x70
     */
    int SetColor(int slot, float *color);

    /**
     *
     * Gives the colour of an event sprite handle; returns 1 on success.
     *
     * @mangled GetColor__10CEohMotherFiPf
     * @address 0x262470
     * @size 0x70
     */
    int GetColor(int slot, float *color);

    /**
     *
     * Returns the name of the motion a character handle is playing, or null.
     *
     * @mangled GetNowMotionName__10CEohMotherFi
     * @address 0x2624E0
     * @size 0x60
     */
    char *GetNowMotionName(int slot);

    /**
     *
     * Returns the state of the motion a character handle is playing, or 0.
     *
     * @mangled GetNowMotionStatus__10CEohMotherFi
     * @address 0x262540
     * @size 0x60
     */
    int GetNowMotionStatus(int slot);

    /**
     *
     * Moves the motion of a character handle to a time; returns 1 on success.
     *
     * @mangled SetMotionNowTime__10CEohMotherFif
     * @address 0x2625A0
     * @size 0xD0
     */
    int SetMotionNowTime(int slot, float time);

    /**
     *
     * Moves the motion of a character handle to a share of its length; returns 1 on success.
     *
     * @mangled SetMotionWaitTime__10CEohMotherFif
     * @address 0x262670
     * @size 0xD0
     */
    int SetMotionWaitTime(int slot, float rate);

    /**
     *
     * Sets the footstep sound of a character handle; returns 1 on success.
     *
     * @mangled SetFootSoundID__10CEohMotherFii
     * @address 0x262740
     * @size 0x60
     */
    int SetFootSoundID(int slot, int id);

    /**
     *
     * Gives the world position of a named frame of a character handle, in the event's world coordinate; returns 1 on success.
     *
     * @mangled GetFramePos__10CEohMotherFiPcPf
     * @address 0x2627A0
     * @size 0xB0
     */
    int GetFramePos(int slot, char *name, float *pos);

    /**
     *
     * Sets the sound bank a character handle plays its sound effects from; returns 1 on success.
     *
     * @mangled SetSoundID__10CEohMotherFiUi
     * @address 0x262850
     * @size 0x60
     */
    int SetSoundID(int slot, unsigned int id);

    /**
     *
     * Returns whether a named frame of what a handle refers to is shown, or 0.
     *
     * @mangled GetFrameShow__10CEohMotherFiPc
     * @address 0x2628B0
     * @size 0xD0
     */
    int GetFrameShow(int slot, char *name);

    /**
     *
     * Sets whether a character handle fades out when the camera comes close; returns 1 on success.
     *
     * @mangled SetFadeFlag__10CEohMotherFii
     * @address 0x262980
     * @size 0x70
     */
    int SetFadeFlag(int slot, int flag);

    /**
     *
     * Puts the dynamic-animation parts of a character handle back to rest; returns 1 on success.
     *
     * @mangled ResetDAPosition__10CEohMotherFi
     * @address 0x2629F0
     * @size 0x80
     */
    int ResetDAPosition(int slot);

    /**
     *
     * Steps the motion of a character handle once; returns 1 on success.
     *
     * @mangled NormalDrive__10CEohMotherFi
     * @address 0x262A70
     * @size 0x70
     */
    int NormalDrive(int slot);

    /**
     *
     * Applies the position of a character handle to its model; returns 1 on success.
     *
     * @mangled UpdatePosition__10CEohMotherFi
     * @address 0x262AE0
     * @size 0x70
     */
    int UpdatePosition(int slot);

    /**
     *
     * Sets the transparency of a named frame of what a handle refers to; returns 1 on success.
     *
     * @mangled SetFrameObjAlpha__10CEohMotherFiPcf
     * @address 0x262B50
     * @size 0x100
     */
    int SetFrameObjAlpha(int slot, char *name, float alpha);

    /**
     *
     * Sets the footstep sound effect of a character handle; returns 1 on success.
     *
     * @mangled SetFootSeId__10CEohMotherFii
     * @address 0x262C50
     * @size 0x70
     */
    int SetFootSeId(int slot, int stamp);
};

STATIC_ASSERT(sizeof(CEohMother) == 0x200);

/**
 *
 * One argument of an event script argument list: a tagged integer, float or string.
 *
 */
struct ARG_DATA {
    int type; /**< Kind of value held. @see RS_STACK_TYPE. */

    union {
        int   i; /**< Value of an integer. */
        float f; /**< Value of a float. */
        char *s; /**< Value of a string. */
    };
};

STATIC_ASSERT(sizeof(ARG_DATA) == 0x8);

/**
 *
 * One argument list that an event script loaded, found by its number.
 *
 */
struct ARG_LIST {
    int       id;      /**< Number the list is found by. */
    ARG_DATA *args;    /**< Arguments of the list. */
    int       arg_num; /**< Number of arguments. */
    ARG_LIST *next;    /**< Next list, or null. */
};

STATIC_ASSERT(sizeof(ARG_LIST) == 0x10);

/**
 *
 * The argument lists of an event, built by running an argument script that
 * hands each list to the event.
 *
 */
class CEventScriptArg {
public:
    int        next_id;  /**< Number the next list built is given. */
    ARG_LIST  *list;     /**< First list, or null. */
    int        list_num; /**< Number of lists. */
    mgCMemory *memory;   /**< Memory the lists and their strings are taken from. */

    CEventScriptArg();

    /**
     *
     * Runs an argument script program, which builds this object's argument lists.
     *
     * @mangled BuildArgData__15CEventScriptArgFPUi
     * @address 0x262EB0
     * @size 0x150
     */
    void BuildArgData(unsigned int *program);
};

STATIC_ASSERT(sizeof(CEventScriptArg) == 0x10);

/**
 *
 * A raster effect that waves the screen sideways line by line, its strength,
 * speed and pitch moving to targets over a number of frames.
 *
 */
class CRaster {
public:
    int   state;          /**< Progress of the effect. @see RASTER_STATE. */
    float amplitude;      /**< Distance, in pixels, lines are moved at most. */
    float amplitude_step; /**< Change of the amplitude each frame. */
    float speed;          /**< Angle, in radians, the wave moves each frame. */
    float speed_step;     /**< Change of the speed each frame. */
    float pitch;          /**< Angle, in radians, between one screen line and the next. */
    float pitch_step;     /**< Change of the pitch each frame. */
    float phase;          /**< Angle, in radians, of the wave at the top line. */
    s32   unk_20;
    int   frames; /**< Number of frames the current change lasts, or -1. */
    int   frame;  /**< Frames passed in the current change. */

    CRaster();

    /**
     *
     * Turns the effect off and clears its settings.
     *
     * @mangled Initialize__7CRasterFv
     * @address 0x263440
     * @size 0x40
     */
    void Initialize();

    /**
     *
     * Sets the amplitude, speed and pitch at once.
     *
     * @mangled SetParam__7CRasterFfff
     * @address 0x263480
     * @size 0x10
     */
    void SetParam(float amplitude, float speed, float pitch);

    /**
     *
     * Turns the effect on, moving to the given amplitude, speed and pitch over a number of frames; -1 keeps a setting.
     *
     * @mangled StartRaster__7CRasterFfffi
     * @address 0x263490
     * @size 0x150
     */
    void StartRaster(float target_amplitude, float target_speed, float target_pitch, int frames);

    /**
     *
     * Turns the effect off, moving to the given amplitude, speed and pitch over a number of frames; -1 keeps a setting.
     *
     * @mangled StopRaster__7CRasterFfffi
     * @address 0x2635E0
     * @size 0x150
     */
    void StopRaster(float target_amplitude, float target_speed, float target_pitch, int frames);

    /**
     *
     * Moves the settings one frame towards their targets.
     *
     * @mangled StepRaster__7CRasterFv
     * @address 0x263730
     * @size 0x150
     */
    void StepRaster();

    /**
     *
     * Redraws the frame buffer with each line moved by the wave.
     *
     * @mangled DrawRaster__7CRasterFv
     * @address 0x263880
     * @size 0x2A0
     */
    void DrawRaster();
};

STATIC_ASSERT(sizeof(CRaster) == 0x2C);

/**
 *
 * Full-screen effects an event can draw over the scene: the raster wave, a
 * sepia picture of the screen, and a flashing monochrome picture of it.
 *
 */
class CScreenEffect {
public:
    CRaster     raster;                /**< Raster wave effect. */
    mgCTexture *sepia_texture;         /**< Texture the sepia picture is captured into, or null. */
    int         sepia;                 /**< Non-zero while the sepia picture is drawn. */
    mgCTexture *mono_flash_texture[2]; /**< Textures the two monochrome pictures are captured into, or null. */
    int         mono_flash;            /**< Non-zero while the monochrome pictures are drawn. */
    int         mono_flash_interval;   /**< Number of frames each monochrome picture is shown. */
    int         mono_flash_frame;      /**< Frames the current monochrome picture has been shown. */
    int         mono_flash_no;         /**< Monochrome picture shown now, 0 or 1. */

    CScreenEffect();

    /**
     *
     * Turns every effect off and forgets the textures.
     *
     * @mangled Initialize__13CScreenEffectFv
     * @address 0x263B20
     * @size 0x50
     */
    void Initialize();

    /**
     *
     * Moves the raster wave one frame towards its targets.
     *
     * @mangled Step__13CScreenEffectFv
     * @address 0x263B70
     * @size 0x10
     */
    void Step();

    /**
     *
     * Draws the sepia picture, the monochrome pictures and the raster wave that are on.
     *
     * @mangled Draw__13CScreenEffectFv
     * @address 0x263B80
     * @size 0x290
     */
    void Draw();

    /**
     *
     * Turns the raster wave off and sets its amplitude, speed and pitch.
     *
     * @mangled InitRaster__13CScreenEffectFfff
     * @address 0x263E10
     * @size 0x60
     */
    void InitRaster(float amplitude, float speed, float pitch);

    /**
     *
     * Turns the raster wave on over a number of frames.
     *
     * @mangled StartRaster__13CScreenEffectFfffi
     * @address 0x263E70
     * @size 0x10
     */
    void StartRaster(float target_amplitude, float target_speed, float target_pitch, int frames);

    /**
     *
     * Turns the raster wave off over a number of frames.
     *
     * @mangled StopRaster__13CScreenEffectFfffi
     * @address 0x263E80
     * @size 0x10
     */
    void StopRaster(float target_amplitude, float target_speed, float target_pitch, int frames);

    /**
     *
     * Gives the texture, and the image memory behind it, that the sepia picture is captured into.
     *
     * @mangled SetSepiaTexture__13CScreenEffectFP10mgCTextureP1
     * @address 0x263E90
     * @size 0x20
     */
    void SetSepiaTexture(mgCTexture *texture, u_long128 *image);

    /**
     *
     * Captures the screen into the sepia texture, tinted sepia.
     *
     * @mangled CaptureSepiaScreen__13CScreenEffectFv
     * @address 0x263EB0
     * @size 0x280
     */
    void CaptureSepiaScreen();

    /**
     *
     * Turns the sepia picture on or off; it stays off without a texture.
     *
     * @mangled SetSepiaFlag__13CScreenEffectFi
     * @address 0x264130
     * @size 0x20
     */
    void SetSepiaFlag(int enabled);

    /**
     *
     * Gives the two textures, and the image memory behind them, that the monochrome pictures are captured into.
     *
     * @mangled SetMonoFlashTexture__13CScreenEffectFPP10mgCTexturePP1
     * @address 0x264150
     * @size 0x50
     */
    void SetMonoFlashTexture(mgCTexture **texture, u_long128 **vram_images);

    /**
     *
     * Captures the screen into the two monochrome textures.
     *
     * @mangled CaptureMonoFlashScreen__13CScreenEffectFv
     * @address 0x2641A0
     * @size 0x2D0
     */
    void CaptureMonoFlashScreen();

    /**
     *
     * Turns the monochrome flash on or off and sets how many frames each picture is shown.
     *
     * @mangled SetMonoFlashFlag__13CScreenEffectFii
     * @address 0x264470
     * @size 0x40
     */
    void SetMonoFlashFlag(int enabled, int interval);
};

STATIC_ASSERT(sizeof(CScreenEffect) == 0x4C);

/**
 *
 * Number of hit effects an event can show at once.
 *
 */
#define EVENT_HIT_EFFECT_NUM 5

/**
 *
 * Number of sparks each event hit effect can show.
 *
 */
#define EVENT_HIT_PARTICLE_NUM 0x40

/**
 *
 * Marker an event draws over a character's head.
 *
 */
extern CMarker EventMarker;

/**
 *
 * Script slot that receives the item the player picks in the item menu an event opened, or null.
 *
 */
extern RS_STACKDATA *p_use_item;

/**
 *
 * Non-zero while the event's world coordinate is applied to positions.
 *
 */
extern int SetWorldCoordFlg;

/**
 *
 * Event object handle whose texture animation follows the voice stream's mouth movement, or -1.
 *
 */
extern int PakuAnimEohNo;

/**
 *
 * Event object handle whose motion follows the voice stream's mouth movement, or -1.
 *
 */
extern int PakuMotionEohNo;

/**
 *
 * How the mouth motion is played.
 *
 */
extern int PakuMotionType;

/**
 *
 * How the second mouth motion is played.
 *
 */
extern int PakuMotionType2;

/**
 *
 * State the running event and its script share with the game loops.
 *
 */
extern ED_EVENT_INFO EdEventInfo;

/**
 *
 * Object handles of the running event.
 *
 */
extern CEohMother EventObjHandleMother;

/**
 *
 * Text sprites of the running event.
 *
 */
extern CEventSpriteMother esMother;

/**
 *
 * Flags local to the running event, 32 to a word.
 *
 */
extern u32 EventLocalFlag[EVENT_LOCAL_NUM];

/**
 *
 * Counters local to the running event.
 *
 */
extern int EventLocalCnt[EVENT_LOCAL_NUM];

/**
 *
 * Rain the running event shows.
 *
 */
extern CRain EventRain;

/**
 *
 * Spark buffers of the event's hit effects.
 *
 */
extern BattleEffectPrim Hit_para[EVENT_HIT_EFFECT_NUM][EVENT_HIT_PARTICLE_NUM];

/**
 *
 * Hit effects the running event shows.
 *
 */
extern CHitEffectImage HitEffect[EVENT_HIT_EFFECT_NUM];

/**
 *
 * Name of the texture animation that follows the voice stream's mouth movement.
 *
 */
extern char PakuAnimName[PAKU_NAME_SIZE];

/**
 *
 * Name of the second texture animation that follows the voice stream's mouth movement.
 *
 */
extern char PakuAnimName2[PAKU_NAME_SIZE];

/**
 *
 * Name of the motion that follows the voice stream's mouth movement.
 *
 */
extern char PakuMotionName[PAKU_NAME_SIZE];

/**
 *
 * Name of the second motion that follows the voice stream's mouth movement.
 *
 */
extern char PakuMotionName2[PAKU_NAME_SIZE];

/**
 *
 * Command entries of the event's camera sequence.
 *
 */
extern _SEN_CMR_SEQ cmr_seq_tbl[SEQ_NODE_NUM];

/**
 *
 * Command entries shared by the event's object sequences.
 *
 */
extern _SEN_OBJ_SEQ obj_seq_tbl[SEQ_NODE_NUM];

/**
 *
 * Full-screen effects of the running event.
 *
 */
extern CScreenEffect EventScreenEffect;

/**
 *
 * Multiplies a vector by the upper 3x3 of a matrix, giving a vector with w = 1.
 *
 * @mangled VectMatMul__FPfPfPA4_f
 * @address 0x260A70
 * @size 0xB0
 */
void VectMatMul(float *out, float *vec, float (*matrix)[4]);

/**
 *
 * Converts a position from the event's world coordinate into the map's.
 *
 * @mangled CalcPosWorldCoord__FPf
 * @address 0x260B20
 * @size 0x60
 */
void CalcPosWorldCoord(float *pos);

/**
 *
 * Converts a position from the map's coordinate into the event's world coordinate.
 *
 * @mangled CalcPosWorldCoordGyaku__FPf
 * @address 0x260B80
 * @size 0x80
 */
void CalcPosWorldCoordGyaku(float *pos);

/**
 *
 * Converts a camera's eye and look-at point from the event's world coordinate into the map's.
 *
 * @mangled SetCamWorldCoord__FP9mgCCamera
 * @address 0x260C00
 * @size 0x70
 */
void SetCamWorldCoord(mgCCamera *camera);

/**
 *
 * Converts a camera's eye and look-at point from the map's coordinate into the event's world coordinate.
 *
 * @mangled SetCamWorldCoordGyaku__FP9mgCCamera
 * @address 0x260C70
 * @size 0x70
 */
void SetCamWorldCoordGyaku(mgCCamera *camera);

/**
 *
 * Puts the event's world coordinate back onto the map's and stops applying it.
 *
 * @mangled InitWorldCoord__Fv
 * @address 0x2644B0
 * @size 0x50
 */
void InitWorldCoord();

/**
 *
 * Returns whether an event local flag is set, or 0 for a bad flag number.
 *
 * @mangled GetLocalFlag__Fi
 * @address 0x264500
 * @size 0x80
 */
int GetLocalFlag(int index);

/**
 *
 * Sets or clears an event local flag; returns the value set, or 0 for a bad flag number.
 *
 * @mangled SetLocalFlag__Fii
 * @address 0x264580
 * @size 0x90
 */
int SetLocalFlag(int index, int value);

/**
 *
 * Returns an event local counter, or -1 for a bad counter number.
 *
 * @mangled GetLocalCnt__Fi
 * @address 0x264610
 * @size 0x40
 */
int GetLocalCnt(int index);

/**
 *
 * Sets an event local counter; returns 1, or 0 for a bad counter number.
 *
 * @mangled SetLocalCnt__Fii
 * @address 0x264650
 * @size 0x40
 */
int SetLocalCnt(int index, int value);

/**
 *
 * Returns the number of the first event local counter that holds a value, or -1.
 *
 * @mangled GetLocalCnt2__Fi
 * @address 0x264690
 * @size 0x50
 */
int GetLocalCnt2(int value);

/**
 *
 * Clears every event local counter.
 *
 * @mangled InitLocalCnt__Fv
 * @address 0x2646E0
 * @size 0x50
 */
void InitLocalCnt();

/**
 *
 * Clears the requests, skip, sound, stream and door settings of the event information.
 *
 * @mangled EdEventInfoCommandInitialize__Fv
 * @address 0x264730
 * @size 0x110
 */
void EdEventInfoCommandInitialize();

/**
 *
 * Clears the event object handles, camera and object sequences, sprites, screen effects and argument lists.
 *
 * @mangled EventSeqInit__Fv
 * @address 0x264840
 * @size 0x1F0
 */
void EventSeqInit();

/**
 *
 * Prepares the event system when an event starts: its sound memory, the event map, the world coordinate and every event object.
 *
 * @mangled EdEventInit__Fv
 * @address 0x264A30
 * @size 0x2C0
 */
void EdEventInit();

/**
 *
 * Draws the event's stopwatch and its other timers.
 *
 * @mangled EventTimeDraw__Fv
 * @address 0x264CF0
 * @size 0xB60
 */
void EventTimeDraw();

/**
 *
 * Draws the event's rain, hit effects, sword and effect scripts, event map, sprites and screen effects.
 *
 * @mangled EdEventDraw__Fv
 * @address 0x265850
 * @size 0x100
 */
void EdEventDraw();

/**
 *
 * Draws the event sprites that are drawn before the scene.
 *
 * @mangled EdEventFirstDraw__Fv
 * @address 0x265950
 * @size 0x50
 */
void EdEventFirstDraw();

/**
 *
 * Puts every event object back to rest when an event ends; returns 1, or 0 when the scene has no camera.
 *
 * @mangled EdEventFinish__Fv
 * @address 0x2659A0
 * @size 0x2C0
 */
int EdEventFinish();

/**
 *
 * Steps the event's sequences, effects and background loading once; returns 1.
 *
 * @mangled EdEventStep__Fv
 * @address 0x265C60
 * @size 0xF0
 */
int EdEventStep();

/**
 *
 * Lets the running drama scene be skipped with the default button and fade colour.
 *
 * @mangled InitDramaScene__Fv
 * @address 0x265D50
 * @size 0x40
 */
void InitDramaScene();

/**
 *
 * Stops the running drama scene from being skipped.
 *
 * @mangled CancelDramaScene__Fv
 * @address 0x265D90
 * @size 0x10
 */
void CancelDramaScene();

/**
 *
 * Hands the item picked in a menu the event opened back to the waiting script.
 *
 * @mangled EdEventMenuExit__Fv
 * @address 0x265DA0
 * @size 0x20
 */
void EdEventMenuExit();

/**
 *
 * Does nothing.
 *
 * @mangled EdSetBrokenObject__Fv
 * @address 0x265E90
 * @size 0x10
 */
void EdSetBrokenObject();

/**
 *
 * Forgets the message files loaded into every event message window.
 *
 * @mangled ResetMesFileBuffAll__Fv
 * @address 0x265EA0
 * @size 0x50
 */
void ResetMesFileBuffAll();

/**
 *
 * Clears the event's sound handles and script path, the world coordinate, the requests and the screen effects before an event loop starts.
 *
 * @mangled EdEventLoopInit__Fv
 * @address 0x265DC0
 * @size 0xD0
 */
void EdEventLoopInit();

/**
 *
 * Prepares the event system when a map is entered: its effects, stopwatch and sprites.
 *
 * @mangled EdEventMapInit__Fv
 * @address 0x265EF0
 * @size 0x280
 */
void EdEventMapInit();

/**
 *
 * Stops the voice stream the event was playing.
 *
 * @mangled EdEventTermination__Fv
 * @address 0x266170
 * @size 0x70
 */
void EdEventTermination();

/**
 *
 * Forgets the event's message files and clears its sequences when an event ends.
 *
 * @mangled EdEventEnd__Fv
 * @address 0x2661E0
 * @size 0x30
 */
void EdEventEnd();

/**
 *
 * Returns the data of a file already read in the background from the current directory, or null, and gives its size.
 *
 * @mangled CheckLoadedBGFile__FPcPi
 * @address 0x266410
 * @size 0x80
 */
unsigned int *CheckLoadedBGFile(char *name, int *size);

/**
 *
 * Returns the data of a file, taken from the background-read files, the loaded pack file or the disc, or null, and gives its size.
 *
 * @mangled GetLoadBGBuff__FPcPi
 * @address 0x266490
 * @size 0x170
 */
unsigned int *GetLoadBGBuff(char *name, int *size);

/**
 *
 * Loads a character into a scene character slot from a pack file; returns non-zero on success.
 *
 * @mangled _LOAD_CHARA_sub__FiPPciPUii
 * @address 0x266790
 * @size 0x150
 */
int _LOAD_CHARA_sub(int stack_no, char **name, int chara_no, unsigned int *pack, int mode);

/**
 *
 * Loads a character into a scene character slot from a pack file; returns non-zero on success.
 *
 * @mangled _LOAD_CHARA_sub__FiPPciPUi
 * @address 0x2668E0
 * @size 0x10
 */
int _LOAD_CHARA_sub(int a, char **b, int c, unsigned int *data);

/**
 *
 * Loads a motion file for a scene character; returns non-zero on success.
 *
 * @mangled _LOAD_MOTION_sub__FiPciPUi
 * @address 0x267030
 * @size 0x120
 */
int _LOAD_MOTION_sub(int stack_no, char *name, int chara_no, unsigned int *pack);

/**
 *
 * Returns the configuration setting that turns movie captions off.
 *
 * @mangled GetConfigCaptionOff__Fv
 * @address 0x268110
 * @size 0x50
 */
int GetConfigCaptionOff();

/**
 *
 * Plays a movie file, drawing the event's captions over it; returns non-zero once it has played.
 *
 * @mangled LoadMovie__FPcP9mgCMemoryb
 * @address 0x268160
 * @size 0x8A0
 */
int LoadMovie(char *name, mgCMemory *memory, bool skip);

/**
 *
 * Loads a message file into a message window; returns non-zero on success.
 *
 * @mangled _LOAD_MES_sub__FPciP6ClsMes
 * @address 0x271400
 * @size 0x100
 */
int _LOAD_MES_sub(char *name, int no, ClsMes *mes);

/**
 *
 * Opens a voice stream from a voice pack; returns 1.
 *
 * @mangled CommandStreamOpenFromFPL__FiPcPc
 * @address 0x276B20
 * @size 0xC0
 */
int CommandStreamOpenFromFPL(int stream, char *name, char *base);

/**
 *
 * Opens a voice stream from a file; returns 1.
 *
 * @mangled CommandStreamOpen__FiPc
 * @address 0x276BE0
 * @size 0x70
 */
int CommandStreamOpen(int stream, char *name);

/**
 *
 * Writes the name of the voice pack holding a voice number; returns 1, or 0 when no pack holds it.
 *
 * @mangled VpkFileNameFromVoiceNo__FPci
 * @address 0x276C50
 * @size 0x150
 */
int VpkFileNameFromVoiceNo(char *name, int voice_no);

/**
 *
 * Plays the open voice stream at a volume, lowered by the reverb depth; returns 1.
 *
 * @mangled CommandStreamPlay__Fii
 * @address 0x276EC0
 * @size 0xE0
 */
int CommandStreamPlay(int stream, int volume);

/**
 *
 * Builds the path of a voice stream file without opening it; returns 1.
 *
 * @mangled CommandStreamOpen2__FiPc
 * @address 0x2778A0
 * @size 0x50
 */
int CommandStreamOpen2(int port, char *name);

/**
 *
 * Gives an event script interpreter the table of event external functions.
 *
 * @mangled SetEventFunc__FP10CRunScript
 * @address 0x281920
 * @size 0x190
 */
void SetEventFunc(CRunScript *script);

class CCameraControl;

/**
 *
 * Reads an event argument as an integer, converting a float argument when needed.
 *
 * @mangled GetArgInt__FP8ARG_DATA
 * @address 0x2632F0
 * @size 0x54
 */
int GetArgInt(ARG_DATA *arg);

/**
 *
 * Reads an event argument as a float, converting an integer argument when needed.
 *
 * @mangled GetArgFloat__FP8ARG_DATA
 * @address 0x263350
 * @size 0x50
 */
float GetArgFloat(ARG_DATA *arg);

/**
 *
 * Returns the string stored in an event argument.
 *
 * @mangled GetArgString__FP8ARG_DATA
 * @address 0x2633A0
 * @size 0x34
 */
char *GetArgString(ARG_DATA *arg);

/**
 *
 * Reads three event float arguments into a homogeneous vector.
 *
 * @mangled GetArgVector__FPfP8ARG_DATA
 * @address 0x2633E0
 * @size 0x60
 */
void GetArgVector(float *vec, ARG_DATA *arg);

/**
 *
 * Adds the selected language marker to a known event filename extension.
 *
 * @mangled FileNameConvLanguage__FPc
 * @address 0x262CC0
 * @size 0xD4
 */
void FileNameConvLanguage(char *name);
