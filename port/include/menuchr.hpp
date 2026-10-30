#pragma once

#include "common.h"

#include <libvu0.h>

#include <optional>
#include <string>

#include "actionchara.hpp"
#include "character.hpp"
#include "gamedata.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "nd_meswin.hpp"
#include "npccfg.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the character menus: the party change screen with its townsperson
 * and monster box, the costume screen, the monster book, and the background
 * loading of the character, ridepod and monster models that the menus show.
 */

/**
 *
 * Sizes of the character menus' tables.
 *
 */
enum {
    MENU_CHARA_LOAD_MAX = 7,         /**< Models that the menus load at once, in MenuCharaBuild2 and MenuActionChara. */
    MENU_LOAD_ITEM_MAX = 12,         /**< Equipment numbers held in MenuLoadItemNo. */
    MONSTER_PROGRESS_NUM = 19,       /**< Rows of monster_progress_tbl. */
    MONSTER_PROGRESS_LEVEL_NUM = 4,  /**< Monster forms one row of monster_progress_tbl lists. */
    CHR_CNG_STAR_NUM = 256,          /**< Sparkles drawn around the party change ring. */
    CHR_CNG_CLUT_NUM = 256,          /**< Colours of the darkened copy of the party change palette. */
    CHR_CNG_CLUT_BAND_NUM = 32,      /**< Brightness bands the darkened party change palette is reduced to. */
    CHR_CNG_NPC_COMMAND_NUM = 4,     /**< Commands the party change screen lists for the townsperson. */
    MOS_SELECT_BADGE_NUM = 12,       /**< Monster badges the monster box shows. */
    MOS_SELECT_LEVEL_MAX = 16,       /**< Forms a badge can grow into, as listed by get_monster_tbl_bajjilevel. */
    COSTUME_LIST_NUM = 3,            /**< Costume lists of the costume screen. */
    COSTUME_LIST_MAX = 8,            /**< Costumes one list of the costume screen holds. */
    MOS_BOOK_LIST_MAX = 0x180,       /**< Monster numbers the monster book can list. */
    MOS_BOOK_DROP_ITEM_NUM = 3,      /**< Dropped items the monster book shows for one monster. */
    CHR_CNG_GAUGE_NUM = 3,           /**< Health gauges of the party change screen: Max, Monica and the ridepod. */
    CHR_CNG_GIFT_BAIT_MAX = 32,      /**< Bait numbers that Fabio's gift can be chosen from. */
    MOS_SELECT_BADGE_KIND_NUM = 10,  /**< Badges of the monster box that hold a family of monsters. */
    MOS_SELECT_GRID_COLUMNS = 4,     /**< Columns of monster badges. */
    MOS_SELECT_GRID_ROWS = 3,        /**< Rows of monster badges. */
    MONSTER_EFFECT_NUM = 4,          /**< Effect files a monster transformation reads, as MOS_HENGE_PARAM::effect_name lists them. */
    MONSTER_EFFECT_TEX_BLOCK = 0xAA, /**< Texture block of the effects of a monster transformation. */
    MOS_BOOK_MEMO_NUM = 0x119,       /**< Monster memo numbers that the monster book goes through. */
    MOS_BOOK_MONSTER_NUM = 0x14A,    /**< Entries of the monster table searched for a memo number. */
    MOS_BOOK_AFFINITY_NUM = 8,       /**< Resistance or weakness icons the monster book can show. */
    MOS_BOOK_LOAD_DELAY = 20,        /**< Frames the monster book waits before it reads the monster's model. */
    MOS_BOOK_SHOW_WAIT_MAX = 20,     /**< Highest count of frames that the monster book's model has been shown. */
};

/**
 *
 * Steps of a party member change, as CMenuChrCngMenu::change_phase holds them.
 *
 */
enum CHR_CNG_PHASE {
    CHR_CNG_PHASE_NONE = 0,  /**< No change is running. */
    CHR_CNG_PHASE_LOAD = 1,  /**< The new character's model is loading. */
    CHR_CNG_PHASE_ENTER = 2, /**< The model has loaded and its sounds are loading. */
    CHR_CNG_PHASE_DONE = 3,  /**< The new character has been put into the scene. */
};

/**
 *
 * Screen that the party change screen opens over itself, as CMenuChrCngMenu::sub_menu holds it.
 *
 */
enum CHR_CNG_SUB_MENU {
    CHR_CNG_SUB_MENU_NONE = -1,       /**< The party change screen itself runs. */
    CHR_CNG_SUB_MENU_MONSTER_BOX = 1, /**< The monster box runs. */
};

/**
 *
 * How the monster box closed, as CMenuMosSelect::KeyStep returns it.
 *
 */
enum MOS_SELECT_RESULT {
    MOS_SELECT_RESULT_NONE = 0,   /**< The monster box is still open. */
    MOS_SELECT_RESULT_CLOSE = 1,  /**< The player left the monster box. */
    MOS_SELECT_RESULT_CHANGE = 2, /**< Monica turned into the chosen monster. */
};

/**
 *
 * Value of CMenuChrCngMenu::select that is not a USER_CHARA character.
 *
 */
enum CHR_CNG_SELECT {
    CHR_CNG_SELECT_NPC = 4, /**< The townsperson in the party; 0 to 3 are the USER_CHARA characters. */
};

/**
 *
 * Pages of the party change screen, as CBaseMenuClass::key_arg_no holds them for CMenuChrCngMenu.
 *
 */
enum CHR_CNG_PAGE {
    CHR_CNG_PAGE_SELECT = 0,   /**< The cursor picks a character. */
    CHR_CNG_PAGE_CONFIRM = 1,  /**< A change of character waits for its yes/no answer. */
    CHR_CNG_PAGE_NPC_JOIN = 2, /**< A townsperson has just joined and speaks; any button opens their page. */
    CHR_CNG_PAGE_NPC = 3,      /**< The townsperson's page, with their abilities and the item board. */
};

/**
 *
 * Steps of the party change screen, as CBaseMenuClass::step holds them on CHR_CNG_PAGE_SELECT.
 *
 */
enum CHR_CNG_STEP {
    CHR_CNG_STEP_SELECT = 0,    /**< The cursor moves over the characters. */
    CHR_CNG_STEP_NPC_MENU = 1,  /**< The townsperson asks whether to open their page or to leave the party. */
    CHR_CNG_STEP_NPC_LEAVE = 2, /**< Leaving the party waits for its yes/no answer. */
};

/**
 *
 * Steps of the townsperson's page, as CBaseMenuClass::step holds them on CHR_CNG_PAGE_NPC.
 *
 */
enum CHR_CNG_NPC_STEP {
    CHR_CNG_NPC_STEP_COMMAND = 0,        /**< An ability is chosen. */
    CHR_CNG_NPC_STEP_NO_POINT = 1,       /**< The townsperson says that their points are too few; a button returns. */
    CHR_CNG_NPC_STEP_RESULT = 2,         /**< The townsperson speaks after the ability; a button returns. */
    CHR_CNG_NPC_STEP_GOT_ITEM = 3,       /**< The townsperson's gift has been received; no keys are taken. */
    CHR_CNG_NPC_STEP_CONFIRM = 10,       /**< Using the ability waits for its yes/no answer. */
    CHR_CNG_NPC_STEP_IDLE = 11,          /**< No keys are taken. */
    CHR_CNG_NPC_STEP_REPAIR_SELECT = 20, /**< Cedric's item board picks the item to repair. */
};

/**
 *
 * What CMenuChrCngMenu::KeyChangeMain does after reading the keys.
 *
 */
enum CHR_CNG_ACTION {
    CHR_CNG_ACTION_CLOSED = -1,         /**< The screen closes after the townsperson's ability. */
    CHR_CNG_ACTION_NONE = 0,            /**< Nothing. */
    CHR_CNG_ACTION_REJECT = 5,          /**< Rejects the key with the cancel sound. */
    CHR_CNG_ACTION_CHANGE = 20,         /**< Changes to the chosen character. */
    CHR_CNG_ACTION_NPC_PAGE = 30,       /**< Opens the townsperson's page. */
    CHR_CNG_ACTION_NPC_MENU = 34,       /**< Asks whether to open the townsperson's page or to send them away. */
    CHR_CNG_ACTION_CLOSE = 40,          /**< Closes the screen. */
    CHR_CNG_ACTION_MONSTER_BOX = 50,    /**< Opens the monster box. */
    CHR_CNG_ACTION_NPC_PAGE_END = 60,   /**< Leaves the townsperson's page. */
    CHR_CNG_ACTION_ASK_CHANGE = 70,     /**< Asks whether to change to the character under the cursor and starts loading them. */
    CHR_CNG_ACTION_CHANGE_CANCEL = 80,  /**< Drops the change of character. */
    CHR_CNG_ACTION_USE_ABILITY = 90,    /**< Uses the chosen ability. */
    CHR_CNG_ACTION_ABILITY = 100,       /**< Asks whether to use the chosen ability. */
    CHR_CNG_ACTION_REPAIR_WEAPON = 200, /**< Opens Cedric's item board of weapons. */
    CHR_CNG_ACTION_REPAIR_ARM = 201,    /**< Opens Cedric's item board of ridepod arms. */
    CHR_CNG_ACTION_REPAIR_ENERGY = 202, /**< Opens Cedric's item board of energy packs. */
};

/**
 *
 * Townspeople who can join the party, by party character number.
 *
 */
enum PARTY_NPC {
    PARTY_NPC_CEDRIC = 1,             /**< Cedric, who repairs weapons and ridepod arms and recharges the ridepod. */
    PARTY_NPC_BORNEO = 2,             /**< Borneo. */
    PARTY_NPC_GORDON = 3,             /**< Gordon. */
    PARTY_NPC_DONNY = 4,              /**< Donny. */
    PARTY_NPC_PARN = 5,               /**< Parn, who takes the party out of the dungeon. */
    PARTY_NPC_DR_DELL = 6,            /**< Dr. Dell, who cures the ailments of Max and Monica. */
    PARTY_NPC_FERDINAND = 7,          /**< Ferdinand, who gives an item. */
    PARTY_NPC_CLAIRE = 8,             /**< Claire. */
    PARTY_NPC_PAU = 9,                /**< Pau, whose model the party change screen scales down further. */
    PARTY_NPC_STEWART = 10,           /**< Stewart. */
    PARTY_NPC_ADEL = 11,              /**< Adel. */
    PARTY_NPC_AUNT_POLLY = 12,        /**< Aunt Polly, who gives an item. */
    PARTY_NPC_ERIK = 13,              /**< Erik, who gives three of an item. */
    PARTY_NPC_SHERIFF_BLINKHORN = 14, /**< Sheriff Blinkhorn. */
    PARTY_NPC_MILANE = 15,            /**< Milane. */
    PARTY_NPC_GERALD = 16,            /**< Gerald. */
    PARTY_NPC_MAYOR_NEED = 17,        /**< Mayor Need. */
    PARTY_NPC_PRIEST_BRUNO = 18,      /**< Priest Bruno, who revives Max and Monica. */
    PARTY_NPC_RUFIO = 19,             /**< Rufio, whose ability works only in a dungeon. */
    PARTY_NPC_FABIO = 20,             /**< Fabio, who gives three of a fishing bait. */
    PARTY_NPC_OLIVIE = 21,            /**< Olivie, who powers up Max and Monica. */
    PARTY_NPC_JULIA = 22,             /**< Julia, who stuns the monsters nearby. */
    PARTY_NPC_MINA = 23,              /**< Mina, who heals Max and Monica and cures their ailments. */
    PARTY_NPC_CORINNE = 24,           /**< Corinne. */
    PARTY_NPC_GRANNY_ROSA = 25,       /**< Granny Rosa, who gives an item. */
    PARTY_NPC_LIN = 26,               /**< Lin, the last townsperson, who cannot be sent away. */
};

/**
 *
 * Settings the party change screen's debug keys change, as MenuDebugChangeSelectMode holds them.
 *
 */
enum MENU_DEBUG_CHANGE_MODE {
    MENU_DEBUG_CHANGE_PARTY = 0,  /**< Buttons add characters to the party or remove them. */
    MENU_DEBUG_CHANGE_ENABLE = 1, /**< Buttons allow or forbid changing to characters. */
    MENU_DEBUG_CHANGE_MASK = 2,   /**< Buttons set or clear the characters' change mask bits. */
};

/**
 *
 * Message numbers of the monster box's badge commands.
 *
 */
enum MOS_SELECT_COMMAND_MSG {
    MOS_SELECT_CMD_TRANSFORM = 0x14B6,    /**< Turns Monica into one of the badge's monsters. */
    MOS_SELECT_CMD_STATUS = 0x14B7,       /**< Shows the status of the badge's monster. */
    MOS_SELECT_CMD_CLASS_CHANGE = 0x14B8, /**< Moves the badge on to a higher class of monster. */
};

/**
 *
 * Pages of the monster box, as CBaseMenuClass::key_arg_no holds them for CMenuMosSelect.
 *
 */
enum MOS_SELECT_PAGE {
    MOS_SELECT_PAGE_BADGE = 0,   /**< The cursor moves over the badges. */
    MOS_SELECT_PAGE_COMMAND = 1, /**< A command of the chosen badge is picked and run. */
    MOS_SELECT_PAGE_STATUS = 2,  /**< The status of the badge's monster forms is shown. */
};

/**
 *
 * Steps of the badge command page, as CBaseMenuClass::step holds them on MOS_SELECT_PAGE_COMMAND.
 *
 */
enum MOS_SELECT_COMMAND_STEP {
    MOS_SELECT_STEP_COMMAND = 0,            /**< A badge command is chosen. */
    MOS_SELECT_STEP_ERROR = 1,              /**< A message that the command is not possible waits for a button. */
    MOS_SELECT_STEP_CLASS_SELECT = 10,      /**< The monster to change class to is chosen. */
    MOS_SELECT_STEP_CLASS_CONFIRM = 11,     /**< The class change waits for its yes/no answer. */
    MOS_SELECT_STEP_CLASS_EFFECT = 12,      /**< The class-change effect loads and plays. */
    MOS_SELECT_STEP_CLASS_DONE = 13,        /**< The class change's end message waits for a button. */
    MOS_SELECT_STEP_CLASS_REWARD = 14,      /**< The monster-drop reward message waits for a button. */
    MOS_SELECT_STEP_CLASS_LAST_REWARD = 15, /**< The last class's item reward message waits for a button. */
    MOS_SELECT_STEP_FORM_SELECT = 20,       /**< The monster form to transform into is chosen. */
};

/**
 *
 * What CMenuMosSelect::KeyStep does after reading the keys.
 *
 */
enum MOS_SELECT_ACTION {
    MOS_SELECT_ACTION_NONE = 0,              /**< Nothing. */
    MOS_SELECT_ACTION_REJECT = 5,            /**< Rejects the key with the cancel sound. */
    MOS_SELECT_ACTION_TRANSFORM = 10,        /**< Turns Monica into the monster form chosen in the form list. */
    MOS_SELECT_ACTION_CANNOT_TRANSFORM = 11, /**< Shows that the transformation is not possible. */
    MOS_SELECT_ACTION_FORM_LIST = 12,        /**< Opens the list of the badge's monster forms to transform into. */
    MOS_SELECT_ACTION_STATUS = 20,           /**< Opens the status page of the badge's monster. */
    MOS_SELECT_ACTION_CLASS_CHANGE = 30,     /**< Opens the list of monsters the badge can change class to. */
    MOS_SELECT_ACTION_BADGES = 500,          /**< Returns to the badge selection. */
    MOS_SELECT_ACTION_COMMANDS = 600,        /**< Opens the chosen badge's command window. */
    MOS_SELECT_ACTION_CLOSE = 1000,          /**< Closes the monster box. */
};

/**
 *
 * Steps of loading the monster that the monster box shows, as CMenuMosSelect::load_phase holds them.
 *
 */
enum MOS_SELECT_LOAD_PHASE {
    MOS_SELECT_LOAD_NONE = -1,  /**< No monster is shown. */
    MOS_SELECT_LOAD_WAIT = 0,   /**< Counts load_wait down, then starts reading the model. */
    MOS_SELECT_LOAD_BUILD = 1,  /**< Builds the model once it has been read. */
    MOS_SELECT_LOAD_SHOWN = 2,  /**< The model is shown. */
    MOS_SELECT_LOAD_EFFECT = 3, /**< Enters the transformation effects of Monica's new form once they have been read. */
    MOS_SELECT_LOAD_DONE = 4,   /**< Monica's new form and its effects are in the scene. */
};

/**
 *
 * Steps of loading the monster that the monster book shows, as CMosBookMenu::load_phase holds them.
 *
 */
enum MOS_BOOK_LOAD_PHASE {
    MOS_BOOK_LOAD_NONE = 0,  /**< Nothing is loading. */
    MOS_BOOK_LOAD_START = 1, /**< Another monster was picked; the wait restarts. */
    MOS_BOOK_LOAD_WAIT = 2,  /**< Waits MOS_BOOK_LOAD_DELAY frames, then starts reading the model. */
    MOS_BOOK_LOAD_BUILD = 3, /**< Builds the model once it has been read. */
    MOS_BOOK_LOAD_SHOWN = 4, /**< The model is shown. */
};

/**
 *
 * Commands of the monster book's keys.
 *
 */
enum MOS_BOOK_COMMAND {
    MOS_BOOK_COMMAND_NONE = -1,       /**< No command. */
    MOS_BOOK_COMMAND_CLOSE = 10,      /**< Closes the book. */
    MOS_BOOK_COMMAND_TURN_PAGE = 100, /**< Shows another monster. */
};

/**
 *
 * Lines of the costume screen past its costume lists, as CMenuCostumeSel::select holds them.
 *
 */
enum COSTUME_SELECT {
    COSTUME_SELECT_CHARA = 3, /**< Finishes with the character; 0 to 2 are the costume lists. */
    COSTUME_SELECT_EXIT = 4,  /**< Shown while Monica is dressed; ends the screen and puts her default costumes back. */
};

/**
 *
 * Steps of loading the character the costume screen shows, as MenuCosutumeLoadPhase holds them.
 *
 */
enum COSTUME_LOAD_PHASE {
    COSTUME_LOAD_NONE = 0,      /**< Nothing is loading. */
    COSTUME_LOAD_START = 1,     /**< Starts reading the character in the chosen costumes. */
    COSTUME_LOAD_BUILD = 2,     /**< Builds the model once it has been read. */
    COSTUME_LOAD_SHOW_WAIT = 3, /**< Steps the hidden model for 15 frames. */
    COSTUME_LOAD_SHOWN = 4,     /**< The model is shown and can be turned. */
};

/**
 *
 * How the menus' background model loading puts the models it reads, as MENU_LOAD_INFO::mode holds it.
 *
 */
enum MENU_LOAD_MODE {
    MENU_LOAD_MODE_MENU = 0,   /**< Into the menu's own models, and into the scene's when update_scene is set. */
    MENU_LOAD_MODE_INVENT = 1, /**< Max's thinking model and two equipment slots, into the menu's models, for the invention menu. */
    MENU_LOAD_MODE_SCENE = 2,  /**< Into the scene's characters only, as a change of character does. */
    MENU_LOAD_MODE_THINK = 3,  /**< As MENU_LOAD_MODE_MENU with Max's thinking model, for the costume screen. */
    MENU_LOAD_MODE_BOOK = 4,   /**< Monster models from the monster book's folder. */
};

/**
 *
 * Slots of MenuCharaBuild2 and MenuActionChara that a character's model is loaded into.
 *
 */
enum MENU_CHARA_SLOT {
    MENU_CHARA_SLOT_BODY = 0,    /**< The character's body. */
    MENU_CHARA_SLOT_SKIN = 1,    /**< Skin of the equipment in MenuLoadItemNo[4], put on the body. */
    MENU_CHARA_SLOT_EQUIP_0 = 2, /**< Equipment in MenuLoadItemNo[0], which carries the sword trail. */
    MENU_CHARA_SLOT_EQUIP_1 = 3, /**< Equipment in MenuLoadItemNo[1]. */
    MENU_CHARA_SLOT_EQUIP_2 = 4, /**< Equipment in MenuLoadItemNo[2]. */
    MENU_CHARA_SLOT_EQUIP_3 = 5, /**< Equipment in MenuLoadItemNo[3], put on the body as its "skin3" skin. */
    MENU_CHARA_SLOT_SCRIPT = 6,  /**< Action script of the character. */
};

/**
 *
 * Files of a monster that GetMonsterModelFile gives the path of, as its kind argument holds them.
 *
 */
enum MONSTER_FILE_KIND {
    MONSTER_FILE_MODEL = 0,  /**< The model, "<model>.gltf". */
    MONSTER_FILE_SOUND = 1,  /**< The sounds, "snd2/mon/EN_<number>.sound.json". */
    MONSTER_FILE_SCRIPT = 2, /**< The action script of the transformation, "<script>.stb". */
    MONSTER_FILE_CONFIG = 3, /**< The model profile basename. */
};

/**
 *
 * What ReadMainCharaBG reports about the quick change.
 *
 */
enum MAIN_CHARA_BG_READ {
    MAIN_CHARA_BG_READ_IDLE = 0, /**< Nothing to load, or the refused quick change waits for a button. */
    MAIN_CHARA_BG_READ_BUSY = 1, /**< The character is loading. */
    MAIN_CHARA_BG_READ_DONE = 2, /**< The character is in the scene, or the refused quick change was dismissed. */
};

/**
 *
 * Steps at which the menus' model step functions act.
 *
 */
enum MENU_ENV_STEP {
    MENU_ENV_STEP_SUN_MOON = 0x38,    /**< MenuTimeStepEnvFunc shows the sun or the moon. */
    MENU_ENV_STEP_WEAPON_TURN = 0x58, /**< MenuWeaponRealStepEnvFunc turns the weapon's moving part. */
};

/**
 *
 * Background read of one model file for a menu, with the file name and the character that receives it.
 *
 */
struct MENU_BGREAD_INFO2 {
    char          name[0x20]; /**< Name of the model, which also names its textures. */
    char          path[0x50]; /**< Path of the file being read. */
    s8            reading;    /**< Non-zero while the file is being read. */
    CActionChara *chara;      /**< Character the model was put into, or NULL. */
};

/**
 *
 * One sparkle that drifts around the party change ring.
 *
 */
struct CHR_CNG_STAR {
    float life;  /**< Counts down by one each frame. */
    float alpha; /**< Alpha the sparkle is drawn with; the sparkle is drawn while it is above zero. */
    float x;     /**< Horizontal offset from the ring's corner. */
    float y;     /**< Vertical offset from the ring's corner. */
    float unk_10;
    float unk_14;
};

STATIC_ASSERT(sizeof(CHR_CNG_STAR) == 0x18);

/**
 *
 * One colour of the party change palette, a byte per channel.
 *
 */
struct CHR_CNG_CLUT_COLOR {
    u8 r; /**< Red intensity. */
    u8 g; /**< Green intensity. */
    u8 b; /**< Blue intensity. */
    u8 a; /**< Alpha. */
};

STATIC_ASSERT(sizeof(CHR_CNG_CLUT_COLOR) == 0x4);

/**
 *
 * The party change screen: picks who is at the front, shows the townsperson
 * who travels with the party and lets them use their ability, and opens the
 * monster box.
 *
 */
class CMenuChrCngMenu : public CBaseMenuClass {
public:
    int                     select;      /**< Character the cursor is on: a USER_CHARA, or CHR_CNG_SELECT_NPC. */
    int                     last_select; /**< Character the cursor was last moved to. */
    s32                     unk_118;
    s16                     open_wait;                              /**< Frames left before the screen takes keys. */
    u8                      set_cursor;                             /**< Non-zero to put the cursor on its place at once. */
    u8                      change_ready;                           /**< Non-zero once a change of character may be loaded. */
    s16                     change_phase;                           /**< Step of the change of character. @see CHR_CNG_PHASE */
    s16                     change_chara;                           /**< Character being changed to. */
    u32                     enable_change;                          /**< Bits of the characters that can be changed to. */
    u32                     party_member;                           /**< Bits of the characters in the party. */
    u8                      close_on_end;                           /**< Non-zero to close the menu once the townsperson's ability ends. */
    u8                      got_item;                               /**< Non-zero once the townsperson's ability has given an item. */
    int                     gift_item;                              /**< Item the townsperson's ability gives. */
    int                     gift_num;                               /**< Number of gift_item given. */
    int                     item_brd_select;                        /**< Slot of the item board the cursor is on. */
    int                     item_brd_pos;                           /**< Scroll position of the item board. */
    CMenuPosDataForm       *form;                                   /**< Form of the screen. */
    MENUFORMPARTS_TYPE     *gauge_part[CHR_CNG_GAUGE_NUM]{};        /**< Health gauge part of Max, Monica and the ridepod. */
    COMMON_GAGE            *gauge[CHR_CNG_GAUGE_NUM]{};             /**< Health of Max, Monica and the ridepod. */
    MENU_ETCINFO           *chara_pos[CHR_CNG_SELECT_NPC + 1]{};    /**< Place of each character's icon, by select. */
    CMenuPosDataForm       *npc_mes_form;                           /**< Form that holds the townsperson's speech. */
    CMenuPosDataForm       *npc_sub_form;                           /**< Form that moves with the townsperson's speech. */
    CMenuPosDataForm       *npc_chara_form;                         /**< Form that shows the townsperson's model. */
    CMenuPosDataForm       *npc_sub_form2;                          /**< Second form that moves with the townsperson's speech. */
    MENUFORMPARTS_TYPE     *cmd_part[4]{};                          /**< Parts the townsperson's commands are placed at. */
    MENUFORMPARTS_TYPE     *point_gauge_part;                       /**< Gauge of the townsperson's ability points. */
    mgCMemory               npc_model_stack;                        /**< Memory the townsperson's model file is read into. */
    mgCMemory               npc_build_stack;                        /**< Memory the townsperson's model is built in. */
    PARTY_CHARA_INFO       *party_info;                             /**< Party record of the townsperson. */
    NPC_BASE_DATA          *npc_data;                               /**< Definition of the townsperson. */
    int                     item_brd_arrived;                       /**< Non-zero once the item board has reached its place. */
    s8                      face_state;                             /**< State of the townsperson's face: -1 none, 0 loading, 1 entered. */
    u8                      face_loaded;                            /**< How the face file was read. @see MenuFileLoadMode */
    s16                     face_chara;                             /**< Townsperson whose face is loaded, or below zero for none. */
    u8                     *face_img;                               /**< Face image file of the townsperson. */
    u8                      npc_loading;                            /**< Non-zero while the townsperson's model is loading. */
    u8                      npc_loaded;                             /**< Non-zero once the townsperson's model is in place. */
    CActionChara           *npc_chara;                              /**< Model of the townsperson, or NULL. */
    int                     npc_wait;                               /**< Frames the townsperson's model has been shown, up to 21. */
    int                     npc_show;                               /**< Non-zero while the townsperson's model is drawn in its form. */
    float                   npc_y;                                  /**< Height of the townsperson's model. */
    int                     npc_no;                                 /**< Townsperson in the party, or zero or below for none. */
    int                     npc_mes_talk{};                         /**< Message that the townsperson says on the screen. */
    int                     npc_mes_cmd{};                          /**< Message of the townsperson's command question. */
    int                     npc_mes_cancel{};                       /**< Message the townsperson says when their ability is cancelled. */
    int                     npc_cmd_mes[CHR_CNG_NPC_COMMAND_NUM]{}; /**< Message of each of the townsperson's commands. */
    s32                     unk_23C;
    float                   cursor_wave;      /**< Angle that bobs the character under the cursor. */
    dc2::text::MessageTable sys_mes{};        /**< System message data. */
    dc2::text::MessageTable mes_data{};       /**< Message data of the screen. */
    s16                     sub_menu;         /**< Screen opened over this one. @see CHR_CNG_SUB_MENU */
    s16                     sub_menu_next;    /**< Screen to open over this one once the fade ends. @see CHR_CNG_SUB_MENU */
    int                     star_stop_wait{}; /**< Frames left while every sparkle fades out. */
    s16                     star_spawn{};     /**< Non-zero to keep making sparkles while the screen closes. */
    s16                     star_fade;        /**< State of the ring: -1 none, 0 fading in, 1 fading out. */
    float                   star_x{};         /**< Screen x of the ring's corner. */
    float                   star_y{};         /**< Screen y of the ring's corner. */
    float                   unk_260{};
    float                   star_size{};     /**< Size of the ring. */
    float                   star_angle{};    /**< Angle the ring has turned through. */
    float                   star_alpha{};    /**< Alpha of the ring, from 0 to 128. */
    int                     star_fade_out{}; /**< 1 to fade the ring out. */
    float                   star_wave{};     /**< Angle that makes the ring's circles throb. */
    float                   star_pulse{};    /**< Angle that makes the ring's outer circle pulse. */
    s32                     unk_27C{};
    CHR_CNG_STAR            star[CHR_CNG_STAR_NUM]{}; /**< Sparkles around the ring. */

    union {
        struct {
            CHR_CNG_CLUT_COLOR clut[CHR_CNG_CLUT_NUM]; /**< Darkened copy of the screen's palette, drawn for those not in the party. */
            u8                 unk_1E80[0x100];
        } palette{}; /**< Palette entries and adjacent reserved space. */

        u8 clut_storage[0x500]; /**< Palette bytes and adjacent reserved space cleared together. */
    };

    /**
     *
     * Initializes the party change menu and clears its model work stacks.
     *
     */
    CMenuChrCngMenu();

    /**
     *
     * Finds the screen's forms, the parts of its main form and its icon places.
     *
     * @mangled AttachForm__15CMenuChrCngMenuFv
     * @address 0x2B4920
     * @size 0x17C
     */
    void AttachForm();

    /**
     *
     * Enters the screen's textures and layout from its pack file and fills it with the party's state.
     *
     * @mangled EnterDataMenu__15CMenuChrCngMenuFPUc
     * @address 0x2B4AA0
     * @size 0x608
     */
    void EnterDataMenu(u8 *pack);

    /**
     *
     * Reads the face image of the townsperson in the party, at once or in the background.
     *
     * @mangled LoadNPCFaceData__15CMenuChrCngMenuFP9mgCMemoryi
     * @address 0x2B50B0
     * @size 0xF4
     */
    void LoadNPCFaceData(mgCMemory *memory, int load_mode);

    /**
     *
     * Enters the townsperson's face image once it has been read.
     *
     * @mangled EnterNPCFaceData__15CMenuChrCngMenuFv
     * @address 0x2B51B0
     * @size 0x84
     */
    void EnterNPCFaceData();

    /**
     *
     * Creates the townsperson's model and starts reading its file; returns non-zero if the read started.
     *
     * @mangled LoadBGNPCModel__15CMenuChrCngMenuFi
     * @address 0x2B5240
     * @size 0x1E0
     */
    int LoadBGNPCModel(int restart_read);

    /**
     *
     * Builds the townsperson's model once read, then moves and shows it; returns 1 on the frame it is built.
     *
     * @mangled CheckBGNPCModel__15CMenuChrCngMenuFv
     * @address 0x2B5420
     * @size 0x2C8
     */
    int CheckBGNPCModel();

    /**
     *
     * Handles the keys of the screen and of the townsperson's ability; returns 0.
     *
     * @mangled KeyChangeMain__15CMenuChrCngMenuFv
     * @address 0x2B5760
     * @size 0x21A0
     */
    int KeyChangeMain();

    /**
     *
     * Moves the screen's parts, the ring and its sparkles for this frame.
     *
     * @mangled CalcTex__15CMenuChrCngMenuFv
     * @address 0x2B7900
     * @size 0x9B8
     */
    void CalcTex();

    /**
     *
     * Runs the change of character; returns 2 once the new character is in the scene.
     *
     * @mangled CheckChrChange__15CMenuChrCngMenuFv
     * @address 0x2B82C0
     * @size 0x1E4
     */
    int CheckChrChange();

    /**
     *
     * Runs the screen for one frame; returns non-zero once it has closed.
     *
     * @mangled MenuLocalLoop__15CMenuChrCngMenuFv
     * @address 0x2B84B0
     * @size 0x4D4
     */
    int MenuLocalLoop();

    /**
     *
     * Clears the ring and every sparkle.
     *
     * @mangled InitStarInfo__15CMenuChrCngMenuFv
     * @address 0x2B8990
     * @size 0x74
     */
    void InitStarInfo();

    /**
     *
     * Shows the health of Max, Monica and the ridepod and hides those not in the party.
     *
     * @mangled UpdataLife__15CMenuChrCngMenuFv
     * @address 0x2B8A10
     * @size 0x178
     */
    void UpdataLife();
};

STATIC_ASSERT(sizeof(CMenuChrCngMenu) == 0x1F80);

/**
 *
 * The monster box: shows Monica's monster badges, lets one be grown into a
 * stronger form, and turns Monica into the chosen monster.
 *
 */
class CMenuMosSelect : public CBaseMenuClass {
public:
    sceVu0FVECTOR           camera_pos{}; /**< Camera position kept to give back when the box closes. */
    sceVu0FVECTOR           camera_ref{}; /**< Camera look-at point kept to give back when the box closes. */
    int                     result;       /**< How the box closed. @see MOS_SELECT_RESULT */
    dc2::text::MessageTable mes_data{};   /**< Message data of the box. */
    int                     select;       /**< Badge the cursor is on. */
    int                     top;          /**< First row of badges shown. */
    MOS_CHANGE_PARAM       *badge;        /**< Monica's badges. */
    MOS_CHANGE_PARAM       *select_badge; /**< Badge being worked on. */
    u8                      unk_148[8]{};
    CDC2Mes                 mes;      /**< Message window of the box's questions. */
    int                     mes_show; /**< Non-zero while mes is drawn. */
    s32                     unk_2BA4{};
    ClsMes                  info_win;      /**< Window that describes the badge under the cursor. */
    int                     info_win_show; /**< Non-zero while info_win is drawn. */
    s32                     unk_5504;
    int                     set_cursor;                            /**< Non-zero to put the cursor on its place at once. */
    int                     level_num{};                           /**< Number of entries in level_monster. */
    int                     level_monster[MOS_SELECT_LEVEL_MAX]{}; /**< Monsters the badge can grow into. */
    int                     change_wait;                           /**< Frames counted while the badge grows. */
    int                     view_monster;                          /**< Monster to show, or -1 for none. */
    int                     pick_monster;                          /**< Monster picked to show. */
    int                     load_monster;                          /**< Monster whose model is loaded, or -1 for none. */
    int                     level_max;                             /**< Non-zero when the badge is at its highest form. */
    s8                      skip_draw;                             /**< Toggled each frame to step the shown model every other frame. */
    CMenuPosDataForm       *badge_form;                            /**< Form of the badges. */
    CMenuPosDataForm       *info_form;                             /**< Form of the badge description. */
    CMenuPosDataForm       *model_form;                            /**< Form that shows the monster's model. */
    u8                      model_side{};                          /**< Side the monster's model stands at: 0 shown, 1 moved aside. */
    sceVu0FVECTOR           model_pos{};                           /**< Position of the monster's model. */
    CActionChara            monster[1];                            /**< Model of the monster shown. */
    CActionChara            effect;                                /**< Model of the growth effect. */
    mgCMemory               effect_stack;                          /**< Memory the growth effect is built in. */
    mgCMemory               unk_7620;
    u_long128              *effect_data;  /**< File of the growth effect's model. */
    u32                    *effect_sound; /**< Sounds of the growth effect. */
    s16                     effect_show;  /**< Non-zero while the growth effect plays. */
    s16                     effect_frame; /**< Frames the growth effect has played. */
    s32                     unk_765C;
    s16                     load_wait;  /**< Frames left before the shown monster's model is loaded. */
    s16                     load_phase; /**< Step of loading the shown monster's model. @see MOS_SELECT_LOAD_PHASE */

    /**
     *
     * Initializes the monster box, its message windows, and the default badge selection.
     *
     */
    CMenuMosSelect();

    /**
     *
     * Finds the box's forms and shows the badges Monica has.
     *
     * @mangled AttachForm__14CMenuMosSelectFv
     * @address 0x2BA570
     * @size 0xF4
     */
    void AttachForm();

    /**
     *
     * Loads, builds and moves the model of the monster under the cursor.
     *
     * @mangled CheckLoadBGMonster__14CMenuMosSelectFv
     * @address 0x2BAA10
     * @size 0x40C
     */
    int CheckLoadBGMonster();

    /**
     *
     * Moves the cursor towards the badge it is on.
     *
     * @mangled CalcCursorPosition__14CMenuMosSelectFv
     * @address 0x2BAE80
     * @size 0xC8
     */
    void CalcCursorPosition();

    /**
     *
     * Moves the box's parts for this frame.
     *
     * @mangled CalcTex__14CMenuMosSelectFv
     * @address 0x2BAF50
     * @size 0x25C
     */
    void CalcTex();

    /**
     *
     * Moves the cursor over the badges and picks the monster to show.
     *
     * @mangled KeyNormalMode__14CMenuMosSelectFiii
     * @address 0x2BB1B0
     * @size 0xC0
     */
    int KeyNormalMode(int keys, int lr_keys, int buttons);

    /**
     *
     * Runs the box for one frame; returns how it closed, or 0 while it runs. @see MOS_SELECT_RESULT
     *
     * @mangled KeyStep__14CMenuMosSelectFv
     * @address 0x2BB890
     * @size 0x19F0
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CMenuMosSelect) == 0x7670);

/**
 *
 * The costume screen: dresses Max or Monica in the costumes they have and shows them turning.
 *
 */
class CMenuCostumeSel : public CBaseMenuClass {
public:
    mgCCameraFollow camera; /**< Camera that looks at the character. */
    int             select; /**< Line the cursor is on: a costume list, or a COSTUME_SELECT line. */
    s32             unk_1D4{};
    s16             costume_num[COSTUME_LIST_NUM]{};                    /**< Number of costumes in each list of list. */
    s16             costume_select[COSTUME_LIST_NUM]{};                 /**< Costume picked in each list of list. */
    s16             costume_list[COSTUME_LIST_NUM][COSTUME_LIST_MAX]{}; /**< Costumes the character has, by kind. */
    s16            *list[COSTUME_LIST_NUM]{};                           /**< List shown on each line, as an entry of costume_list. */
    s32             unk_220;
    float           tile_scroll;           /**< Scroll of the background tiles. */
    mgCMemory       stack;                 /**< Memory of the screen's data. */
    s16             chara;                 /**< Character being dressed, USER_CHARA_MAX or USER_CHARA_MONICA. */
    int             monica_enabled;        /**< 1 when Monica can be dressed too. */
    sceVu0FVECTOR   chara_pos{};           /**< Position of the character's model. */
    float           costume_rotation[4]{}; /**< Rotation restored to the character model while dressing it. */
    s32             unk_280;
    int             cursor_show;    /**< Non-zero while the cursor is drawn. */
    int             change_chara;   /**< Non-zero while the other character is loading. */
    float           line_wave[3]{}; /**< Angle that bobs each costume line. */
    int             load_wait;      /**< Frames counted while a costume loads. */
    int             loading;        /**< Non-zero while a costume is loading. */
    int             wait_load;      /**< Non-zero while the screen waits for a load to end. */
    int             show_help;      /**< Non-zero while the help is drawn. */
    s32             unk_2A8{};
    s32             unk_2AC{};
    float           cursor_x{};      /**< Screen x of the cursor. */
    float           cursor_y{};      /**< Screen y of the cursor. */
    float           cursor_wave{};   /**< Angle that bobs the cursor. */
    float           cursor_wave_y{}; /**< Phase of the costume cursor's vertical bob. */
    CHARA_DATA     *chara_data;      /**< Status of the character being dressed. */
    mgCTexture     *tile_tex;        /**< Texture of the background tiles. */
    mgCTexture     *cursor_tex;      /**< Texture of the cursor. */

    /**
     *
     * Initializes the costume screen with its camera and Max's default model place.
     *
     */
    CMenuCostumeSel();

    /**
     *
     * Lists the costumes a character has of each kind and puts each list's cursor on the costume worn.
     *
     * @mangled UpdateCostumeList__15CMenuCostumeSelFiUl
     * @address 0x2C0A80
     * @size 0x1A0
     */
    void UpdateCostumeList(int chara_no, unsigned long long chara_flag);

    /**
     *
     * Reads the screen's pack file and enters its textures and layout.
     *
     * @mangled LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi
     * @address 0x2C0C60
     * @size 0x390
     */
    void LoadMenuData(mgCMemory *stack, int *tex_block);

    /**
     *
     * Runs the screen for one frame; returns non-zero once it has closed.
     *
     * @mangled KeyStep__15CMenuCostumeSelFv
     * @address 0x2C0FF0
     * @size 0x9D8
     */
    int KeyStep();

    /**
     *
     * Draws the screen.
     *
     * @mangled Draw__15CMenuCostumeSelFv
     * @address 0x2C19D0
     * @size 0x8D4
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CMenuCostumeSel) == 0x2D0);

/**
 *
 * The monster book: lists every monster defeated and shows its model and description.
 *
 */
class CMosBookMenu : public CBaseMenuClass {
public:
    bool              ready = false;  /**< Whether the book resources and model workspaces are initialized. */
    mgCCamera         camera;         /**< Camera that looks at the monster. */
    float             bg_scroll;      /**< Scroll of the background, from 0 to 256. */
    mgCMemory         stack;          /**< Memory the monster's model is read and built in. */
    int               tex_block_no{}; /**< Texture block of the monster's model. */
    CActionChara     *monster;        /**< Model of the monster shown, or NULL. */
    s32               unk_1BC;
    s32               unk_1C0;
    s32               unk_1C4;
    s32               unk_1C8;
    s32               unk_1CC;
    int               load_phase;                                /**< Step of loading the monster's model. @see MOS_BOOK_LOAD_PHASE */
    int               load_wait;                                 /**< Frames counted before the monster's model is loaded. */
    int               show_wait;                                 /**< Frames the monster's model has been built, up to 20. */
    s8                skip_draw;                                 /**< Toggled each frame to step the model every other frame. */
    int               select;                                    /**< Entry of list the cursor is on. */
    BASE_MONSTER_TBL *monster_info;                              /**< Definition of the monster shown. */
    int               list[MOS_BOOK_LIST_MAX]{};                 /**< Monster numbers of the monsters defeated, then -1. */
    int               list_num;                                  /**< Number of monsters in list. */
    char              area_name[0x40]{};                         /**< Name of the place the monster lives. */
    char              name[0x40]{};                              /**< Name of the monster. */
    char              type_name[0x40]{};                         /**< Name of the monster's kind. */
    char              weak_name[0x58]{};                         /**< Names of the attributes the monster is weak to. */
    u32               hp{};                                      /**< Health of the monster. */
    u32               abs{};                                     /**< Absorption points the monster gives. */
    int               kill_num{};                                /**< Number of the monster defeated. */
    u32               strong_bit{};                              /**< Bits of the attributes the monster resists. */
    u32               weak_bit{};                                /**< Bits of the attributes the monster is weak to. */
    char              drop_item[MOS_BOOK_DROP_ITEM_NUM][0x21]{}; /**< Names of the items the monster drops. */

    /**
     *
     * Constructs the book with its model camera at the default speed.
     *
     */
    CMosBookMenu() : camera(8.0f) {
        bg_scroll = 0.0f;
        monster = nullptr;
        unk_1BC = 0;
        unk_1C0 = 0;
        unk_1C4 = 0;
        unk_1C8 = 0;
        unk_1CC = 0;
        load_phase = 0;
        show_wait = 0;
        load_wait = 0;
        monster_info = nullptr;
        select = 0;
        skip_draw = 0;
        list_num = 0;

        for (int i = 0; i < MOS_BOOK_LIST_MAX; i++) {
            list[i] = -1;
        }

        InitMonsterInfo();
        camera.SetPos(0.0f, 0.0f, 100.0f);
        camera.SetRef(0.0f, 0.0f, 0.0f);
    }

    /**
     *
     * Clears the description of the monster shown.
     *
     * @mangled InitMonsterInfo__12CMosBookMenuFv
     * @address 0x2C2610
     * @size 0x34
     */
    void InitMonsterInfo();

    /**
     *
     * Fills the description from a monster's definition.
     *
     * @mangled SetMonsterInfo__12CMosBookMenuFP16BASE_MONSTER_TBL
     * @address 0x2C2650
     * @size 0x308
     */
    void SetMonsterInfo(BASE_MONSTER_TBL *monster);

    /**
     *
     * Finishes opening the book: enters its textures, lists the monsters defeated and shows the first.
     *
     * @mangled InitEnd__12CMosBookMenuFv
     * @address 0x2C2960
     * @size 0x224
     */
    void InitEnd() override;

    /**
     *
     * Draws the book.
     *
     * @mangled Draw__12CMosBookMenuFv
     * @address 0x2C2B90
     * @size 0xEC4
     */
    void Draw();

    /**
     *
     * Runs the book for one frame; returns non-zero once it has closed.
     *
     * @mangled KeyStep__12CMosBookMenuFv
     * @address 0x2C3A60
     * @size 0x54C
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CMosBookMenu) == 0x980);

/**
 *
 * Monster forms of each badge: a badge number, then the monster of each of its four forms.
 *
 */
extern s16 monster_progress_tbl[MONSTER_PROGRESS_NUM][1 + MONSTER_PROGRESS_LEVEL_NUM];

/**
 *
 * Memory stacks of the main characters, which the menus load character sounds into.
 *
 */
extern mgCMemory *MorattaStack;

/**
 *
 * Texture of the party change ring.
 *
 */
extern mgCTexture *MenuCharaChangeBase_Tex;

/**
 *
 * Copy of the ring's texture that draws with the darkened palette.
 *
 */
extern mgCTexture *MenuCharaChangeCLUT_Tex;

/**
 *
 * Texture of the party change sparkles.
 *
 */
extern mgCTexture *MenuCharaChangeStar_Tex;

/**
 *
 * Sound data of the character whose sounds the menus load.
 *
 */
extern u32 *CharaSndBuffer;

/**
 *
 * Background reads of the models that the menus show.
 *
 */
extern MENU_BGREAD_INFO2 *MenuCharaBuild2[MENU_CHARA_LOAD_MAX];

/**
 *
 * Characters of the menu scene that the loaded models are put into.
 *
 */
extern CActionChara *MenuActionChara[MENU_CHARA_LOAD_MAX];

/**
 *
 * Memory of each character of MenuActionChara.
 *
 */
extern mgCMemory MenuActionCharaBuffer[MENU_CHARA_LOAD_MAX];

/**
 *
 * Equipment numbers whose models the menus load for the character shown.
 *
 */
extern s16 MenuLoadItemNo[MENU_LOAD_ITEM_MAX];

/**
 *
 * Memory containing the party change menu models.
 *
 */
extern mgCMemory MenuChangeMemory;

/**
 *
 * Memory containing the monster book menu and its resources.
 *
 */
extern mgCMemory MosBookStack;

/**
 *
 * Memory containing monster model background loads for the menu.
 *
 */
extern mgCMemory MenuMonChangeLoadStack;

/**
 *
 * Memory remaining for monster selection menu background loads.
 *
 */
extern mgCMemory MenuMosLoadStack;

/**
 *
 * Memory containing the initial party change menu textures.
 *
 */
extern mgCMemory ChrChangeInitTextureStack;

/**
 *
 * Memory the party change screen reads the townsperson's face into.
 *
 */
extern mgCMemory MenuChangeNpcMemory;

/**
 *
 * Memory of the sword effects that the menus show.
 *
 */
extern mgCMemory SwordEffectStack;

/**
 *
 * Memory stack reserved for building the monster box's models; nothing uses it.
 *
 */
extern mgCMemory MenuMosBuildStack;

/**
 *
 * Clears a background read.
 *
 * @mangled InitMenuBGReadInfo2__FP17MENU_BGREAD_INFO2
 * @address 0x2B41F0
 * @size 0x14
 */
void InitMenuBGReadInfo2(MENU_BGREAD_INFO2 *info);

/**
 *
 * Returns non-zero while any of the menus' background reads is reading.
 *
 * @mangled MenuLoadFileCheck__FPP17MENU_BGREAD_INFO2
 * @address 0x2B4210
 * @size 0x48
 */
int MenuLoadFileCheck(MENU_BGREAD_INFO2 **slots);

/**
 *
 * Allocates the background reads of MenuCharaBuild2 that a table of flags asks for.
 *
 * @mangled MenuBGReadInfo2Malloc__FP9mgCMemoryPi
 * @address 0x2B4260
 * @size 0x9C
 */
void MenuBGReadInfo2Malloc(mgCMemory *memory, int *wanted);

/**
 *
 * Gives the load step of a character's model part.
 *
 * @mangled ConvertCharaLoadDataPhase__Fii
 * @address 0x2B4300
 * @size 0x24
 */
s16 ConvertCharaLoadDataPhase(int chara_no, int slot);

/**
 *
 * Tells whether the menu was opened from a dungeon; returns non-zero if so.
 *
 * @mangled CheckBattleLoop__Fv
 * @address 0x2B4330
 * @size 0x4C
 */
int CheckBattleLoop();

/**
 *
 * Fills MenuLoadItemNo with the equipment of Max, Monica or the ridepod.
 *
 * @mangled SetMenuLoadItemNo__Fi
 * @address 0x2B4380
 * @size 0x114
 */
void SetMenuLoadItemNo(int who);

/**
 *
 * Divides a memory stack among MenuActionCharaBuffer and puts the remainder into another stack.
 *
 * @mangled MenuMemoryAdjust__FP9mgCMemoryP9mgCMemoryP9mgCMemoryi
 * @address 0x2B4670
 * @size 0xF0
 */
void MenuMemoryAdjust(mgCMemory *pool, mgCMemory *rest, mgCMemory *buffers, int chara);

/**
 *
 * Removes the effects of a monster transformation.
 *
 * @mangled DeleteMonsterEffect__Fv
 * @address 0x2B4760
 * @size 0x54
 */
void DeleteMonsterEffect();

/**
 *
 * Places a townsperson's speech at the parts of a form.
 *
 * @mangled SetMessagePositionNPCForm__FP16CMenuPosDataFormP7CDC2Mes
 * @address 0x2B47C0
 * @size 0xE4
 */
void SetMessagePositionNPCForm(CMenuPosDataForm *form, CDC2Mes *mes);

/**
 *
 * Places a townsperson's speech over their model.
 *
 * @mangled AdjustNPCTalk__FP7CDC2MesP11CCharacter2
 * @address 0x2B48B0
 * @size 0x6C
 */
void AdjustNPCTalk(CDC2Mes *mes, CCharacter2 *npc);

/**
 *
 * Clears the scene's weapon models before Max or Monica is loaded in their town model.
 *
 * @mangled EditCharaPrepare__Fv
 * @address 0x2B56F0
 * @size 0x64
 */
void EditCharaPrepare();

/**
 *
 * Draws the party change ring and its sparkles.
 *
 * @mangled MenuCharaChangeStarDraw__Fv
 * @address 0x2B8B90
 * @size 0x5BC
 */
void MenuCharaChangeStarDraw();

/**
 *
 * Opens the party change screen.
 *
 * @mangled MenuCharaChangeInit__FP9mgCMemoryPii
 * @address 0x2B9150
 * @size 0x4F0
 */
int MenuCharaChangeInit(mgCMemory *memory, int *tex_block, int mode);

/**
 *
 * Runs the party change screen for one frame; returns non-zero once it has closed.
 *
 * @mangled MenuCharaChangeKey__Fv
 * @address 0x2B9640
 * @size 0x2F8
 */
int MenuCharaChangeKey();

/**
 *
 * Draws the party change screen.
 *
 * @mangled MenuCharaChangeDraw__Fv
 * @address 0x2B9940
 * @size 0x7B0
 */
void MenuCharaChangeDraw();

/**
 *
 * Gives a monster's name, or NULL.
 *
 * @mangled GetMonsterName__Fi
 * @address 0x2BA0F0
 * @size 0x30
 */
char *GetMonsterName(int monster_no);

/**
 *
 * Gives the badge whose forms include a monster, and the form, or -1.
 *
 * @mangled get_gajji_id_from_monster_progress_table__FiPi
 * @address 0x2BA120
 * @size 0x88
 */
int get_gajji_id_from_monster_progress_table(int progress_no, int *column_out);

/**
 *
 * Gives the row of monster_progress_tbl whose form of a level is a monster, or -1.
 *
 * @mangled GetMonsterProgressTableNo__Fii
 * @address 0x2BA1B0
 * @size 0x4C
 */
int GetMonsterProgressTableNo(int column, int value);

/**
 *
 * Lists the monsters a badge can grow into from a form; returns how many.
 *
 * @mangled get_monster_tbl_bajjilevel__FPiiii
 * @address 0x2BA200
 * @size 0x178
 */
int get_monster_tbl_bajjilevel(int *list, int monster_id, int value, int column);

/**
 *
 * Gives the row of monster_progress_tbl of a badge.
 *
 * @mangled get_default_monster_progresstbl__Fi
 * @address 0x2BA380
 * @size 0x44
 */
int get_default_monster_progresstbl(int id);

/**
 *
 * Gives the path of a monster's model, sound, transformation script or configuration file when available.
 */
std::optional<std::string> GetMonsterModelFile(int monster_id, MONSTER_FILE_KIND kind);

/**
 *
 * Scales a monster's model to the size the menus show it at.
 *
 * @mangled MonsterScaleCheck__FP11CCharacter2
 * @address 0x2BA670
 * @size 0x68
 */
void MonsterScaleCheck(CCharacter2 *chara);

/**
 *
 * Reads the effect files of a monster transformation; returns how many are read.
 *
 * @mangled MonsterEffectRead__FP9mgCMemoryii
 * @address 0x2BA6E0
 * @size 0x210
 */
int MonsterEffectRead(mgCMemory *stack, int monster_no, int background);

/**
 *
 * Builds the effects of a monster transformation once read into a texture block; returns non-zero on success.
 *
 * @mangled MonsterEffectEnter__FP6CSceneP1i
 * @address 0x2BA8F0
 * @size 0x11C
 */
int MonsterEffectEnter(CScene *scene, u_long128 *buffer, int tex_block);

/**
 *
 * Gives the place of a badge of the monster box's form.
 *
 * @mangled GetBajjiPosition__FP16CMenuPosDataFormiiPi
 * @address 0x2BAE20
 * @size 0x58
 */
void GetBajjiPosition(CMenuPosDataForm *form, int slot, int unused, int *pos);

/**
 *
 * Opens the monster box.
 *
 * @mangled MenuMonsterBoxInit__FP9mgCMemoryPii
 * @address 0x2BB270
 * @size 0x620
 */
void MenuMonsterBoxInit(mgCMemory *stack, int *tex_block, int mode);

/**
 *
 * Runs the monster box for one frame. @see MOS_SELECT_RESULT
 *
 * @mangled MenuMonsterBoxKey__Fv
 * @address 0x2BD280
 * @size 0x8
 */
int MenuMonsterBoxKey();

/**
 *
 * Draws the monster box.
 *
 * @mangled MenuMonsterBoxDraw__Fv
 * @address 0x2BD290
 * @size 0x22C
 */
void MenuMonsterBoxDraw();

/**
 *
 * Shows the parts of a menu model that suit the time of day.
 *
 * @mangled MenuTimeStepEnvFunc__FP6CSceneP12CActionCharai
 * @address 0x2BD4C0
 * @size 0xEC
 */
void MenuTimeStepEnvFunc(CScene *scene, CActionChara *chara, int step);

/**
 *
 * Turns the moving part of a weapon shown in a menu.
 *
 * @mangled MenuWeaponRealStepEnvFunc__FP12CActionCharai
 * @address 0x2BD5B0
 * @size 0x94
 */
void MenuWeaponRealStepEnvFunc(CActionChara *chara, int step);

/**
 *
 * Starts reading the model of Max or Monica and their equipment; returns the size read.
 *
 * @mangled MenuItemCharaDataLoad__FP9mgCMemoryiPP17MENU_BGREAD_INFO2i
 * @address 0x2BD650
 * @size 0x4AC
 */
int MenuItemCharaDataLoad(mgCMemory *stack, int chara_no, MENU_BGREAD_INFO2 **info, int restart_read);

/**
 *
 * Builds the model of Max or Monica and their equipment once read; returns non-zero once built.
 *
 * @mangled MenuItemCharaDataLoadEndCheck__FPP17MENU_BGREAD_INFO2P9mgCMemoryPP12CActionCharaiii
 * @address 0x2BDE50
 * @size 0x644
 */
int MenuItemCharaDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int chara_no,
                                  int tex_block, int scene_tex_block);

/**
 *
 * Reads the sounds of a character; returns the size read.
 *
 * @mangled MenuCharaSoundLoad__FP9mgCMemoryii
 * @address 0x2BE4A0
 * @size 0xFC
 */
u32 MenuCharaSoundLoad(mgCMemory *stack, int chara_no, int background);

/**
 *
 * Gives a character the sounds read by MenuCharaSoundLoad.
 *
 * @mangled MenuCharaSoundEnter__FP6CSceneP12CActionCharai
 * @address 0x2BE5A0
 * @size 0xC0
 */
void MenuCharaSoundEnter(CScene *scene, CActionChara *chara, int open_port);

/**
 *
 * Starts reading the model of an item; returns the size read.
 *
 * @mangled MenuItemChrLoad__FP9mgCMemoryiiP17MENU_BGREAD_INFO2i
 * @address 0x2BE660
 * @size 0x11C
 */
u32 MenuItemChrLoad(mgCMemory *stack, int item_no, int variant, MENU_BGREAD_INFO2 *info, int restart_read);

/**
 *
 * Builds the model of an item once read; returns non-zero once built.
 *
 * @mangled MenuItemChrLoadEndCheck__FP17MENU_BGREAD_INFO2P12CActionCharaP9mgCMemoryi
 * @address 0x2BE780
 * @size 0xF8
 */
int MenuItemChrLoadEndCheck(MENU_BGREAD_INFO2 *info, CActionChara *chara, mgCMemory *memory, int tex_block);

/**
 *
 * Starts reading the ridepod's model and parts; returns the size read.
 *
 * @mangled MenuItemRoboDataLoad__FP9mgCMemoryPP17MENU_BGREAD_INFO2i
 * @address 0x2BE880
 * @size 0x31C
 */
int MenuItemRoboDataLoad(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int restart_read);

/**
 *
 * Removes the outline texture of a menu model.
 *
 * @mangled DeleteOutLineMenu__FP12CActionCharai
 * @address 0x2BEBA0
 * @size 0x70
 */
void DeleteOutLineMenu(CActionChara *chara, int alternate);

/**
 *
 * Builds the ridepod's model and parts once read; returns non-zero once built.
 *
 * @mangled MenuItemRoboDataLoadEndCheck__FPP17MENU_BGREAD_INFO2P9mgCMemoryPP12CActionCharaii
 * @address 0x2BEC10
 * @size 0x840
 */
int MenuItemRoboDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int tex_block,
                                 int scene_tex_block);

/**
 *
 * Switches off the light of a ridepod part.
 *
 * @mangled MenuRoboPartsLightOff__FP8mgCFrame
 * @address 0x2BF450
 * @size 0x34
 */
void MenuRoboPartsLightOff(mgCFrame *frame);

/**
 *
 * Starts reading a monster's model; returns the size read.
 *
 * @mangled MenuMonsterLoadBG__FP9mgCMemoryPP17MENU_BGREAD_INFO2ii
 * @address 0x2BF490
 * @size 0x1E4
 */
int MenuMonsterLoadBG(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int monster_no, int restart_read);

/**
 *
 * Builds a monster's model once read; returns non-zero once built.
 *
 * @mangled MenuMonsterLoadBGCheck__FPP17MENU_BGREAD_INFO2PP12CActionCharaii
 * @address 0x2BF680
 * @size 0x340
 */
int MenuMonsterLoadBGCheck(MENU_BGREAD_INFO2 **info, CActionChara **chara, int tex_block, int scene_tex_block);

/**
 *
 * Finishes the models built by MenuItemCharaDataLoadEndCheck.
 *
 * @mangled MenuItemCharaDataLoadEndCheckAfter__FPP17MENU_BGREAD_INFO2i
 * @address 0x2BF9C0
 * @size 0x368
 */
void MenuItemCharaDataLoadEndCheckAfter(MENU_BGREAD_INFO2 **info, int chara_no);

/**
 *
 * Starts the quick change to Max or Monica from the field.
 *
 * @mangled InitMainCharaBG__FiP9mgCMemoryi
 * @address 0x2BFD30
 * @size 0x4C4
 */
void InitMainCharaBG(int chara_no, mgCMemory *stack, int town);

/**
 *
 * Loads the character of the quick change; returns 2 once it is in the scene.
 *
 * @mangled ReadMainCharaBG__Fv
 * @address 0x2C0200
 * @size 0x4D0
 */
int ReadMainCharaBG();

/**
 *
 * Runs the quick change for one frame; returns non-zero once it has ended.
 *
 * @mangled KeyMainCharaBG__Fv
 * @address 0x2C06D0
 * @size 0xE8
 */
int KeyMainCharaBG();

/**
 *
 * Draws the quick change.
 *
 * @mangled DrawMainCharaBG__Fv
 * @address 0x2C07C0
 * @size 0x10C
 */
void DrawMainCharaBG();

/**
 *
 * Reads the model of a townsperson; returns non-zero if it was read.
 *
 * @mangled MenuNPCModelLoad__FP9mgCMemoryii
 * @address 0x2C08D0
 * @size 0xCC
 */
int MenuNPCModelLoad(mgCMemory *memory, int chara_no, int background);

/**
 *
 * Builds the townsperson's model once read; returns non-zero once built.
 *
 * @mangled MenuNPCLoadCheck__FP12CActionCharaP9mgCMemoryi
 * @address 0x2C09A0
 * @size 0xD8
 */
int MenuNPCLoadCheck(CActionChara *chara, mgCMemory *memory, int tex_block);

/**
 *
 * Gives the place of a costume in a costume list, or 0 if it is not there.
 *
 * @mangled CosutmeSelDefaultSet__FiPs
 * @address 0x2C0C20
 * @size 0x3C
 */
int CosutmeSelDefaultSet(int costume_id, short *costume_list);

/**
 *
 * Opens the costume screen.
 *
 * @mangled MenuCostumeInit__FP9mgCMemoryPii
 * @address 0x2C22B0
 * @size 0x2D8
 */
void MenuCostumeInit(mgCMemory *stack, int *tex_block, int mode);

/**
 *
 * Runs the costume screen for one frame; returns non-zero once it has closed.
 *
 * @mangled MenuCostumeKey__Fv
 * @address 0x2C2590
 * @size 0x8
 */
int MenuCostumeKey();

/**
 *
 * Draws the costume screen.
 *
 * @mangled MenuCostumeDraw__Fv
 * @address 0x2C25A0
 * @size 0x8
 */
void MenuCostumeDraw();

/**
 *
 * Gives the monster table entry of a monster memo number, or NULL.
 *
 * @mangled GetMonsterBaseInfoForMonsterMemoIndex__Fi
 * @address 0x2C25B0
 * @size 0x54
 */
BASE_MONSTER_TBL *GetMonsterBaseInfoForMonsterMemoIndex(int memo_index);

/**
 *
 * Opens the monster book.
 *
 * @mangled MonsterBookInit__FP9mgCMemoryPii
 * @address 0x2C3FB0
 * @size 0x1D8
 */
void MonsterBookInit(mgCMemory *memory, int *tex_block, int mode);

/**
 *
 * Runs the monster book for one frame; returns non-zero once it has closed.
 *
 * @mangled MonsterBookKey__Fv
 * @address 0x2C4190
 * @size 0x8
 */
int MonsterBookKey();

/**
 *
 * Draws the monster book.
 *
 * @mangled MonsterBookDraw__Fv
 * @address 0x2C41A0
 * @size 0x94
 */
void MonsterBookDraw();

/**
 *
 * State of the menus' background model loading.
 *
 */
struct MENU_LOAD_INFO {
    s8 mode;          /**< Where the loaded models go. @see MENU_LOAD_MODE */
    s8 town_model;    /**< Non-zero to load the town model of Max or Monica instead of the dungeon one. */
    s8 load_all;      /**< Non-zero to read every slot at once rather than one slot a frame. */
    s8 chara_no;      /**< Character being loaded. */
    s8 request_phase; /**< Slot asked for, or below zero for each slot in turn. */
    s8 load_phase;    /**< Slot being read when the slots are read in turn. @see MENU_CHARA_SLOT */
    s8 target_flags;
    s8 update_scene; /**< Non-zero when loading also updates the main scene's characters and stacks. */
};

STATIC_ASSERT(sizeof(MENU_LOAD_INFO) == 8);

/**
 *
 * State of the menus' background model loading.
 *
 */
extern MENU_LOAD_INFO MenuLoadInfo;

namespace dc2::menu {
/**
 *
 * Destroys the active monster book before its model arenas are reclaimed.
 *
 */
void ResetMonsterBook();
} // namespace dc2::menu
