#pragma once

#include "common.h"

#include <libvu0.h>

#include "actionchara.hpp"
#include "character.hpp"
#include "gamedata.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the base class of the menus, the shared key and cursor handling of the menu system, the item menu and the
 * item choice that an event asks for.
 */
/**
 *
 * Kind of place an item is moved from or to, as MENU_SWAPITEM_INFO::type holds it.
 *
 */
// clang-format off
enum MENU_SWAP_TYPE {
    MENU_SWAP_TYPE_NONE        = -1, /**< No slot. */
    MENU_SWAP_TYPE_ACTIVE_ITEM = 0,  /**< One of a character's active item slots. */
    MENU_SWAP_TYPE_EQUIP       = 1,  /**< One of a character's equipment slots. */
    MENU_SWAP_TYPE_ROBO_PART   = 2,  /**< One of the ridepod's part slots. */
    MENU_SWAP_TYPE_ITEM_BOARD  = 3,  /**< A place on the inventory board. */
    MENU_SWAP_TYPE_INVENT_ITEM = 4,  /**< A place of the inventory listed by the invention menu. */
    MENU_SWAP_TYPE_VIEW_WEAPON = 7,  /**< The weapon shown on the weapon page. */
    MENU_SWAP_TYPE_UNK_9       = 9,
    MENU_SWAP_TYPE_ACTIVE_ESA  = 10, /**< The bait on the fishing rod. */
};

// clang-format on

/**
 *
 * Weapon ability bits displayed by the item-menu status icons and debug labels.
 *
 */
// clang-format off
enum MENU_WEAPON_ABILITY {
    MENU_WEAPON_ABILITY_RICH        = 0x001, /**< Rich ability flag. */
    MENU_WEAPON_ABILITY_POOR        = 0x002, /**< Poor ability flag. */
    MENU_WEAPON_ABILITY_POISON      = 0x004, /**< Poison ability flag. */
    MENU_WEAPON_ABILITY_STOP        = 0x008, /**< Stop ability flag. */
    MENU_WEAPON_ABILITY_STEAL       = 0x010, /**< Steal ability flag. */
    MENU_WEAPON_ABILITY_BREAK_EASY  = 0x020, /**< Break easy ability flag. */
    MENU_WEAPON_ABILITY_BREAK_HARD  = 0x040, /**< Break hard ability flag. */
    MENU_WEAPON_ABILITY_DRAIN       = 0x080, /**< Drain ability flag. */
    MENU_WEAPON_ABILITY_HEAL        = 0x100, /**< Heal ability flag. */
    MENU_WEAPON_ABILITY_DARK        = 0x200, /**< Dark ability flag. */
    MENU_WEAPON_ABILITY_CRITICAL    = 0x400, /**< Critical ability flag. */
    MENU_WEAPON_ABILITY_ABS2        = 0x800, /**< ABS2 ability flag. */
};

// clang-format on

/**
 *
 * Cursor layouts of the item menu, as CBaseMenuClass::key_arg_no holds them for CMenuItemInfo.
 *
 */
// clang-format off
enum ITEM_MENU_PANEL {
    ITEM_MENU_PANEL_ACTIVE_ITEMS      = 0,  /**< Active items of the shown character. */
    ITEM_MENU_PANEL_EQUIPMENT         = 1,  /**< Equipment of the shown character. */
    ITEM_MENU_PANEL_BAG               = 2,  /**< The inventory board. */
    ITEM_MENU_PANEL_CHARA             = 3,  /**< The character of a character page, to use the carried item on. */
    ITEM_MENU_PANEL_WEAPON            = 4,  /**< The weapon of the weapon page. */
    ITEM_MENU_PANEL_WEAPON_STATS      = 5,  /**< Parameters of the weapon page. */
    ITEM_MENU_PANEL_RIDEPOD           = 6,  /**< The ridepod of the ridepod page, to use the carried item on. */
    ITEM_MENU_PANEL_RIDEPOD_PARTS     = 7,  /**< Parts of the ridepod page. */
    ITEM_MENU_PANEL_MONSTER           = 8,  /**< The monster of the monster page, to use the carried item on. */
    ITEM_MENU_PANEL_FISHING_ROD       = 9,  /**< The fishing rod of the fishing rod page. */
    ITEM_MENU_PANEL_FISHING_ROD_STATS = 10, /**< Parameters of the fishing rod page. */
    ITEM_MENU_PANEL_FISHING_BAIT      = 11, /**< The bait on Max's fishing rod. */
    ITEM_MENU_PANEL_NUM               = 12, /**< Number of cursor layouts. */
};

// clang-format on

/**
 *
 * Commands offered for an item, numbered from ITEM_MENU_COMMAND_MSG_BASE as their messages are.
 *
 */
// clang-format off
enum ITEM_MENU_COMMAND {
    ITEM_MENU_COMMAND_NONE                    = 0,    /**< No command. */
    ITEM_MENU_COMMAND_THROW_AWAY              = 1,    /**< Throws the item away. */
    ITEM_MENU_COMMAND_EQUIP                   = 2,    /**< Equips the item on its character. */
    ITEM_MENU_COMMAND_STATUS                  = 3,    /**< Shows the status page of the item. */
    ITEM_MENU_COMMAND_REPAIR                  = 4,    /**< Repairs the item with the repair powder it needs. */
    ITEM_MENU_COMMAND_SET_ACTIVE_ITEM         = 5,    /**< Puts the item into an active item slot. */
    ITEM_MENU_COMMAND_UNEQUIP                 = 6,    /**< Moves the equipment back into the inventory. */
    ITEM_MENU_COMMAND_REMOVE_ACTIVE_ITEM      = 7,    /**< Moves the active item back into the inventory. */
    ITEM_MENU_COMMAND_INFO                    = 8,    /**< Shows the status page of the item, as ITEM_MENU_COMMAND_STATUS does. */
    ITEM_MENU_COMMAND_SPECTRUMIZE             = 9,    /**< Turns the item into a synth sphere. */
    ITEM_MENU_COMMAND_EQUIP_RIDEPOD_PART      = 10,   /**< Fits the part to the ridepod. */
    ITEM_MENU_COMMAND_OPEN_AQUARIUM           = 11,   /**< Opens the aquarium. */
    ITEM_MENU_COMMAND_OPEN_MONSTER_BOX        = 12,   /**< Opens the monster badge box. */
    ITEM_MENU_COMMAND_GIFT_BOX_CONTENTS       = 13,   /**< Takes an item out of the gift box. */
    ITEM_MENU_COMMAND_PUT_IN_AQUARIUM         = 14,   /**< Puts the fish into the aquarium. */
    ITEM_MENU_COMMAND_USE_ON_MAX              = 15,   /**< Uses the item on Max. */
    ITEM_MENU_COMMAND_USE_ON_MONICA           = 16,   /**< Uses the item on Monica. */
    ITEM_MENU_COMMAND_USE_ON_RIDEPOD          = 17,   /**< Offered on the ridepod page in place of the character commands; does nothing. */
    ITEM_MENU_COMMAND_USE_ON_MONSTER          = 18,   /**< Uses the item on Monica's monster form. */
    ITEM_MENU_COMMAND_USE_ON_PRIMARY_WEAPON   = 19,   /**< Uses the item on the character's first weapon. */
    ITEM_MENU_COMMAND_USE_ON_SECONDARY_WEAPON = 20,   /**< Uses the item on the character's second weapon. */
    ITEM_MENU_COMMAND_REPAIR_RIDEPOD          = 21,   /**< Repairs the ridepod with the item. */
    ITEM_MENU_COMMAND_RECHARGE_RIDEPOD        = 22,   /**< Refills the ridepod's energy with ridepod fuel. */
    ITEM_MENU_COMMAND_VIEW_BUILD_UP           = 23,   /**< Shows what the weapon can be built up into. */
    ITEM_MENU_COMMAND_SET_BAIT                = 24,   /**< Puts the item on the fishing rod as bait. */
    ITEM_MENU_COMMAND_SET_LURE                = 25,   /**< Puts the item on the lure rod as a lure. */
    ITEM_MENU_COMMAND_RENAME                  = 26,   /**< Gives the item or the ridepod a new name. */
    ITEM_MENU_COMMAND_REMOVE_BAIT             = 27,   /**< Takes the bait off the fishing rod. */
    ITEM_MENU_COMMAND_REMOVE_LURE             = 28,   /**< Takes the lure off the lure rod. */
    ITEM_MENU_COMMAND_VIEW_QUESTS             = 29,   /**< Opens the quest list. */
    ITEM_MENU_COMMAND_TAKE_ONE                = 30,   /**< Picks up one of the item onto the cursor. */
    ITEM_MENU_COMMAND_TAKE_BAIT               = 32,   /**< Takes the bait off the fishing rod, as ITEM_MENU_COMMAND_REMOVE_BAIT does. */
    ITEM_MENU_COMMAND_TAKE_LURE               = 33,   /**< Takes the lure off the lure rod, as ITEM_MENU_COMMAND_REMOVE_LURE does. */
    ITEM_MENU_COMMAND_ENABLE_RIDEPOD_VOICE    = 34,   /**< Turns the ridepod's voice unit on. */
    ITEM_MENU_COMMAND_DISABLE_RIDEPOD_VOICE   = 35,   /**< Turns the ridepod's voice unit off. */
    ITEM_MENU_COMMAND_USE_ON_CORE             = 37,   /**< Uses the item on the ridepod's core. */
    ITEM_MENU_COMMAND_VIEW_SCOOP_MEMO         = 38,   /**< Opens the scoop memo. */
    ITEM_MENU_COMMAND_BOIL_FISH               = 42,   /**< Boils the fish. */
    ITEM_MENU_COMMAND_ESCAPE_DUNGEON          = 43,   /**< Uses the item up to leave the dungeon, after asking. */
    ITEM_MENU_COMMAND_BREAK_SEAL              = 44,   /**< Uses the item up to break the seals of the dungeon floor. */
    ITEM_MENU_COMMAND_SHOW_FISH_CODE          = 45,   /**< Shows the fish's password for Finny Frenzy. */
    ITEM_MENU_COMMAND_VIEW_FISHING_ROD        = 46,   /**< Opens the page that spends the fishing rod's points. */
    ITEM_MENU_COMMAND_OPEN_MONSTER_BOOK       = 47,   /**< Opens the monster book. */
    ITEM_MENU_COMMAND_MSG_BASE                = 5000, /**< Message number of command 0; each command's message is this plus the command. */
};

// clang-format on

/**
 *
 * What a menu is asking the player, as CBaseMenuClass::mode holds it while a question is open.
 *
 */
// clang-format off
enum MENU_ASK_MODE {
    MENU_ASK_MODE_NONE         = 0,  /**< No question is open; the menu takes its own keys. */
    MENU_ASK_MODE_OPEN         = 1,  /**< The menu has just been created and is still preparing itself. */
    MENU_ASK_MODE_CLOSE        = 2,  /**< The item choice is fading out to close. */
    MENU_ASK_MODE_HOW_MUCH     = 3,  /**< Asking how many of an item to move. */
    MENU_ASK_MODE_ITEM_COMMAND = 4,  /**< Choosing a command for an item. */
    MENU_ASK_MODE_CREATE       = 5,  /**< Asking whether to create an object; runs IsCreateObject. */
    MENU_ASK_MODE_MAKE         = 6,  /**< Asking how many objects to make; runs IsMakeObject. */
    MENU_ASK_MODE_SPECTOL      = 7,  /**< Spectrumising an item. */
    MENU_ASK_MODE_FUSION       = 8,  /**< Fusing spectrumised attachments into a weapon. */
    MENU_ASK_MODE_TRUSH        = 9,  /**< Throwing an item away. */
    MENU_ASK_MODE_ITEM_USE_NUM = 10, /**< Using up an item. */
    MENU_ASK_MODE_GIFT_BOX     = 11, /**< Taking an item out of a gift box. */
    MENU_ASK_MODE_EXTEND       = 12, /**< A question of the derived menu; runs IsAskExtend. */
    MENU_ASK_MODE_ITEM_OVER    = 13, /**< The item menu is telling the player to throw away items over the limit. */
    MENU_ASK_MODE_ROD_POINTS   = 15, /**< The item menu is spending a fishing rod's points on its parameters. */
};

// clang-format on

/**
 *
 * Bits of the direction keys, as CMenuKeyFunc::CheckSelectKey and CMenuKeyFunc::CheckLRKey return them.
 *
 */
// clang-format off
enum MENU_SELECT_KEY {
    MENU_SELECT_KEY_UP    = 0x1,  /**< Up on the directional pad. */
    MENU_SELECT_KEY_DOWN  = 0x2,  /**< Down on the directional pad. */
    MENU_SELECT_KEY_LEFT  = 0x4,  /**< Left on the directional pad. */
    MENU_SELECT_KEY_RIGHT = 0x8,  /**< Right on the directional pad. */
    MENU_SELECT_KEY_L1    = 0x10, /**< The L1 button. */
    MENU_SELECT_KEY_R1    = 0x20, /**< The R1 button. */
    MENU_SELECT_KEY_L2    = 0x40, /**< The L2 button. */
    MENU_SELECT_KEY_R2    = 0x80, /**< The R2 button. */
};

// clang-format on

/**
 *
 * Bits of the face and shoulder buttons, as MenuCheckPushButton returns them.
 *
 */
// clang-format off
enum MENU_PUSH_BUTTON {
    MENU_PUSH_BUTTON_DECIDE   = 0x1,  /**< The button that confirms, which depends on the language. */
    MENU_PUSH_BUTTON_CANCEL   = 0x2,  /**< The button that cancels, which depends on the language. */
    MENU_PUSH_BUTTON_TRIANGLE = 0x4,  /**< The triangle button. */
    MENU_PUSH_BUTTON_SQUARE   = 0x8,  /**< The square button. */
    MENU_PUSH_BUTTON_START    = 0x10, /**< The start button. */
    MENU_PUSH_BUTTON_SELECT   = 0x20, /**< The select button. */
    MENU_PUSH_BUTTON_R3       = 0x40, /**< The right stick button. */
    MENU_PUSH_BUTTON_L3       = 0x80, /**< The left stick button. */
};

// clang-format on

/**
 *
 * What a cursor does when a move passes the end of its range, as MenuKeySelectCheck takes it.
 *
 */
// clang-format off
enum MENU_CURSOR_LIMIT {
    MENU_CURSOR_LIMIT_CLAMP  = 0, /**< Stops at the end. */
    MENU_CURSOR_LIMIT_WRAP   = 1, /**< Wraps round to the other end. */
    MENU_CURSOR_LIMIT_EXIT   = 2, /**< Stops at the end and reports that the cursor leaves the layout. */
    MENU_CURSOR_LIMIT_REJECT = 3, /**< Undoes the move and reports it as blocked. */
};

// clang-format on

/**
 *
 * How a cursor move ended, as MenuKeySelectCheck returns it.
 *
 */
// clang-format off
enum MENU_CURSOR_RESULT {
    MENU_CURSOR_UNCHANGED = 0, /**< The cursor did not move. */
    MENU_CURSOR_MOVED     = 1, /**< The cursor moved. */
    MENU_CURSOR_EXIT      = 3, /**< The move passed the end of a range that exits. */
    MENU_CURSOR_BLOCKED   = 4, /**< The move was undone at the end of a range that rejects it. */
};

// clang-format on

/**
 *
 * How the cursor of a key layout moves, as MENU_INPUTKEY_ARG::type holds it.
 *
 */
// clang-format off
enum MENU_INPUTKEY_TYPE {
    MENU_INPUTKEY_TYPE_LINE = 0, /**< The cursor moves along one list. */
    MENU_INPUTKEY_TYPE_GLID = 1, /**< The cursor moves over a grid of rows and columns. */
};

// clang-format on

/**
 *
 * Question of the item menu while CBaseMenuClass::mode is MENU_ASK_MODE_EXTEND, as MENU_ASKMODE_PARA::ask_mode holds it.
 *
 */
// clang-format off
enum MENU_ITEM_EXTEND_KIND {
    MENU_ITEM_EXTEND_NONE     = 0, /**< No question is open. */
    MENU_ITEM_EXTEND_REPAIR   = 1, /**< The repair effect is running. */
    MENU_ITEM_EXTEND_BUILD_UP = 2, /**< A weapon build-up is being chosen or shown. */
};

// clang-format on

/**
 *
 * Screens opened from the item menu, as CMenuItemInfo::sub_menu holds them.
 *
 */
// clang-format off
enum MENU_ITEM_SUB_MENU {
    MENU_ITEM_SUB_MENU_NONE         = -1, /**< The item menu itself. */
    MENU_ITEM_SUB_MENU_AQUARIUM     = 0,  /**< The aquarium. */
    MENU_ITEM_SUB_MENU_MONSTER_BOX  = 1,  /**< The monster badge box. */
    MENU_ITEM_SUB_MENU_NAME_REGIST  = 2,  /**< Naming an item or the ridepod. */
    MENU_ITEM_SUB_MENU_QUEST_LIST   = 3,  /**< The quest list. */
    MENU_ITEM_SUB_MENU_SCOOP_MEMO   = 4,  /**< The scoop memo. */
    MENU_ITEM_SUB_MENU_MONSTER_BOOK = 5,  /**< The monster book. */
};

// clang-format on

/**
 *
 * Kind of place in a row of an item move table, as the first entry of each row passed to CommonSetMoveItemClass holds it.
 *
 */
// clang-format off
enum MENU_MOVE_PLACE {
    MENU_MOVE_PLACE_CHARA    = 0, /**< A slot of a character or the ridepod; the row gives the character, MENU_MOVE_LIST and slot. */
    MENU_MOVE_PLACE_BAG      = 1, /**< A place on the inventory board, given by the row's last entry. */
    MENU_MOVE_PLACE_CURSOR   = 2, /**< The item the cursor carries. */
    MENU_MOVE_PLACE_TEMP     = 3, /**< The split-off copy of a stack, moved as if from the inventory board. */
    MENU_MOVE_PLACE_OVERFLOW = 4, /**< A place of the overflow board, given by the row's last entry. */
    MENU_MOVE_PLACE_BAIT     = 5, /**< The bait on the fishing rod. */
};

// clang-format on

/**
 *
 * List of a character that a MENU_MOVE_PLACE_CHARA row names in its third entry.
 *
 */
// clang-format off
enum MENU_MOVE_LIST {
    MENU_MOVE_LIST_ACTIVE_ITEM = 0, /**< The character's active items. */
    MENU_MOVE_LIST_EQUIP       = 1, /**< The character's equipment, or the ridepod's parts. */
    MENU_MOVE_LIST_BAIT        = 2, /**< The bait slot. */
};

// clang-format on

/**
 *
 * Whether the carried item may be put down at the cursor, as CMenuKeyFunc::EnableSwapNowPos returns it.
 *
 */
// clang-format off
enum MENU_SWAP_CHECK {
    MENU_SWAP_CHECK_OK          = 0, /**< The carried item can be put down here. */
    MENU_SWAP_CHECK_WRONG_ITEM  = 1, /**< The carried item does not belong here. */
    MENU_SWAP_CHECK_REFUSED     = 2, /**< Refused; EnableSwapNowPos does not return it. */
    MENU_SWAP_CHECK_NO_CAPACITY = 3, /**< The ridepod part does not fit the ridepod's capacity. */
    MENU_SWAP_CHECK_HOW_MUCH    = 4, /**< The player is asked how many of the stack to take. */
    MENU_SWAP_CHECK_USE_ITEM    = 5, /**< The carried item is used on the item here. */
    MENU_SWAP_CHECK_STATUS      = 8, /**< The character's status prevents changing equipment. */
    MENU_SWAP_CHECK_INVALID     = 9, /**< The place cannot take the item. */
};

// clang-format on

/**
 *
 * How an exchange of items went, as MenuDataSwap and CMenuKeyFunc::MenuSwapItem return it.
 *
 */
// clang-format off
enum MENU_SWAP_RESULT {
    MENU_SWAP_RESULT_FAILED = 0,               /**< The requested exchange cannot run. */
    MENU_SWAP_RESULT_NORMAL = 1,               /**< The exchange uses the ordinary completion path. */
    MENU_SWAP_RESULT_DESTINATION_OCCUPIED = 2, /**< The general exchange starts with an occupied destination. */
    MENU_SWAP_RESULT_DESTINATION_EMPTY = 3,    /**< The general exchange places an item in an empty destination. */
    MENU_SWAP_RESULT_GIFT_BOX = 4,             /**< The destination handles gift-box insertion. */
    MENU_SWAP_RESULT_STACK = 5,                /**< Matching stackable items handle the exchange. */
    MENU_SWAP_RESULT_AQUARIUM = 7,             /**< The aquarium handles the source fish. */
};

// clang-format on

/**
 *
 * Shape of the inventory board.
 *
 */
// clang-format off
enum MENU_ITEM_BOARD {
    MENU_ITEM_BOARD_COLUMNS = 6, /**< Places in each row of the inventory board. */
    MENU_ITEM_BOARD_ROWS    = 5, /**< Rows of the inventory board shown at once. */
};

// clang-format on

/**
 *
 * Size of the inventory as the item menus walk it.
 *
 */
enum MENU_BAG {
    MENU_BAG_PLACE_MAX = 150, /**< Places of the inventory: the item board followed by its overflow places. */
};

/**
 *
 * Where an item that is being moved came from, so that it can be put back or swapped.
 *
 */
struct MENU_SWAPITEM_INFO {
    s16 flag;  /**< Non-zero once the source has been recorded. */
    s16 type;  /**< Kind of place the item came from. @see MENU_SWAP_TYPE */
    s16 no;    /**< Slot within that place. */
    s16 chara; /**< Character owning that place; -1 for none. */

    /**
     *
     * Records where an item came from.
     *
     * @mangled Set__18MENU_SWAPITEM_INFOFiiii
     * @address 0x23CAE0
     * @size 0x14
     */
    void Set(int type, int no, int chara, int flag);
};

STATIC_ASSERT(sizeof(MENU_SWAPITEM_INFO) == 0x8);

/**
 *
 * Contents of the question box a menu opens: the commands on offer and what they act on.
 *
 */

struct MENU_ASKMODE_PARA {
    s16 unk_0{};
    s16 mes_no{};  /**< Message window that shows the commands. */
    s16 cmd_num{}; /**< Number of commands on offer. */
    s16 unk_6{};

    int cmd_msg[8]{};   /**< Message number of each command. */
    u32 cmd_color[8]{}; /**< Colour of each command; 0x80202020 marks one that cannot be chosen. */
    s16 cmd_shade[8]{}; /**< Shading values passed to the item command text builder. */
    s16 cmd_mark[8]{};  /**< Marks commands that are ready, including weapons that can be built up. */

    s16               arg0{}; /**< Value that depends on the question, such as the character an item belongs to. */
    s16               arg1{}; /**< Second value that depends on the question. */
    s16               unk_6C{};
    s16               unk_6E{};
    s16               ask_mode{}; /**< Question of the derived menu while mode is MENU_ASK_MODE_EXTEND. @see MENU_ITEM_EXTEND_KIND */
    s32               unk_74{};
    CMenuPosDataForm *form{};  /**< Form the question was opened from. */
    CGameDataUsed    *item{};  /**< Item the question acts on. */
    CGameDataUsed    *item2{}; /**< Second item the question acts on, such as the weapon to fuse into. */
    s32               unk_84{};
    s32               unk_88{};
    s32               unk_8C{};
    s32               unk_90{};

    /**
     *
     * Creates an empty question.
     *
     * @mangled __ct__17MENU_ASKMODE_PARAFv
     * @address 0x23CAB0
     * @size 0x30
     */
    MENU_ASKMODE_PARA();

    /**
     *
     * Clears every value of the question.
     *
     * @mangled Initialize__17MENU_ASKMODE_PARAFv
     * @address 0x23CAA0
     * @size 0xC
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(MENU_ASKMODE_PARA) == 0x94);

/**
 *
 * Outcome of an item command, handed to the menu's ItemCmdAfter to act on.
 *
 */
struct ITEMCMD_RET_PARA {
    s16            se_no;           /**< Sound effect played once the command has run, or -1 for none. @see SYSTEM_SE */
    s8             menu_cmd;        /**< Item command that was chosen, or -1 / -2 when none was. @see ITEM_MENU_COMMAND */
    s8             chara;           /**< Character the item is equipped on. */
    s16            result;          /**< Value the command returned, such as what using the item did. */
    s16            detail;          /**< Further outcome of the command, such as the item number used or why equipping failed. */
    s16            no_equipped_rod; /**< Non-zero when a bait command acted on a fishing rod that is not equipped. */
    s16            num;             /**< Number of items used by the returned command. */
    CGameDataUsed *item;            /**< Item the command acted on. */
    CGameDataUsed *item2;           /**< Second item the command acted on. */
};

STATIC_ASSERT(sizeof(ITEMCMD_RET_PARA) == 0x14);

/**
 *
 * Pointers into the player's data that the item menu reads.
 *
 */
class CMENU_USERPARAM {
public:
    CHARA_DATA       *chara[2]{};  /**< Data of the two main characters. */
    ROBO_DATA        *robo{};      /**< Data of the ridepod. */
    MOS_CHANGE_PARAM *monster{};   /**< Monster badge data of the monster form in use. */
    CGameDataUsed    *used_data{}; /**< The player's inventory. */
    MOS_CHANGE_PARAM *monster1{};  /**< Monster badge data of the second monster badge slot. */

    /**
     *
     * Creates the pointers cleared.
     *
     */
    CMENU_USERPARAM() { Initialize(); }

    /**
     *
     * Clears every pointer.
     *
     * @mangled Initialize__15CMENU_USERPARAMFv
     * @address 0x23C9F0
     * @size 0x1C
     */
    void Initialize();

    /**
     *
     * Points every pointer at the player's current data.
     *
     * @mangled AttachInfo__15CMENU_USERPARAMFv
     * @address 0x23CA10
     * @size 0x88
     */
    void AttachInfo();
};

STATIC_ASSERT(sizeof(CMENU_USERPARAM) == 0x18);

/**
 *
 * One cursor layout of the item menu: the limits the cursor moves within and what each direction does at the edges.
 *
 */
struct MENU_INPUTKEY_ARG {
    s16 step[4];      /**< Amount the cursor moves for up, down, left and right. */
    int type;         /**< How the cursor moves. @see MENU_INPUTKEY_TYPE */
    s16 min;          /**< Lowest cursor position. */
    s16 max;          /**< Position one past the highest in a list. */
    u8  disp_lines;   /**< Number of rows on screen at once. */
    u8  disp_columns; /**< Number of columns on screen at once. */
    u8  rows;         /**< Number of rows of a grid. */
    u8  columns;      /**< Number of columns of a grid. */
    s16 limit[4];     /**< What each direction does at an edge, as MenuKeySelectCheck takes it. @see MENU_CURSOR_LIMIT */
    s16 exit_no[4];   /**< Layout each direction leaves to when it passes an edge, or -1. @see ITEM_MENU_PANEL */
};

STATIC_ASSERT(sizeof(MENU_INPUTKEY_ARG) == 0x24);

/**
 *
 * Base of every menu screen: its state, its texture blocks, its question box and the item being worked on.
 *
 */
class CBaseMenuClass {
public:
    s16                mode;            /**< Question that is open. @see MENU_ASK_MODE */
    s16                step;            /**< Step within the open question. */
    u8                 opened;          /**< Non-zero once the menu has run its opening script. */
    s16                message_type;    /**< Message type used by the open question. */
    char              *script;          /**< Menu command script of the screen. */
    int                script_size;     /**< Size of the menu command script in bytes. */
    s32                fade_alpha;      /**< Alpha the screen fades with; 0x80 while it is fully shown. */
    s16                key_arg_no;      /**< Cursor layout in use, as an index into the screen's layout table. @see ITEM_MENU_PANEL */
    int                tex_block[16]{}; /**< Texture blocks the screen uses, ending at the first negative one. */
    MENU_ASKMODE_PARA  ask_para;        /**< Contents of the open question. */
    MENU_SWAPITEM_INFO swap_info;       /**< Where the item being moved came from. */
    s16                cmd_arg_pos;     /**< Kind of place of the item the command list was opened for. @see MENU_SWAP_TYPE */
    s32                unk_F8;
    s32                make_item_no;  /**< Identifier of the item selected for creation. */
    int                make_num;      /**< Number of objects chosen to make. */
    s32                make_space_no; /**< Free inventory slot for the item being created. */
    s8                 make_cursor;   /**< Row the cursor is on in the make question; 0 is the number. */
    s16                make_num_max;  /**< Number of objects that can be made at most. */

    /**
     *
     * Creates the menu with an empty question and no texture blocks.
     *
     * @mangled __ct__14CBaseMenuClassFv
     * @address 0x239500
     * @size 0xF0
     */
    CBaseMenuClass();

    /**
     *
     * Answers the create question; returns non-zero to create the object.
     *
     * @mangled IsCreateObject__14CBaseMenuClassFii
     * @address 0x1F3D00
     * @size 0x8
     */
    virtual int IsCreateObject(int select_key, int push_button) { return 1; }

    /**
     *
     * Answers the make question; returns non-zero once the question is over.
     *
     * @mangled IsMakeObject__14CBaseMenuClassFii
     * @address 0x1F3D10
     * @size 0x8
     */
    virtual int IsMakeObject(int select_key, int push_button) { return 0; }

    /**
     *
     * Runs a question that the derived menu adds; returns non-zero once it is over.
     *
     * @mangled IsAskExtend__14CBaseMenuClassFii
     * @address 0x1F3D20
     * @size 0x8
     */
    virtual int IsAskExtend(int select_key, int push_button) { return 0; }

    /**
     *
     * Acts on the outcome of an item command after it has run.
     *
     * @mangled ItemCmdAfter__14CBaseMenuClassFiP16ITEMCMD_RET_PARA
     * @address 0x1F3D30
     * @size 0x8
     */
    virtual int ItemCmdAfter(int cmd_ret, ITEMCMD_RET_PARA *ret) { return 0; }

    /**
     *
     * Runs once the menu has finished opening.
     *
     * @mangled InitEnd__14CBaseMenuClassFv
     * @address 0x1FF8D0
     * @size 0x8
     */
    virtual void InitEnd() {}

    /**
     *
     * Runs as the menu closes.
     *
     * @mangled ExitEnd__14CBaseMenuClassFv
     * @address 0x1F3D40
     * @size 0x8
     */
    virtual void ExitEnd() {}

    /**
     *
     * Takes the texture blocks the screen may use, up to the first one that is not positive.
     *
     * @mangled SetTexBlock__14CBaseMenuClassFPi
     * @address 0x2395F0
     * @size 0x50
     */
    void SetTexBlock(int *blocks);

    /**
     *
     * Empties every texture block of the screen.
     *
     * @mangled DeleteTexBlock__14CBaseMenuClassFv
     * @address 0x239640
     * @size 0x8
     */
    void DeleteTexBlock();

    /**
     *
     * Checks whether an item has any command to offer; returns non-zero when it has.
     *
     * @mangled MenuItemCommnadSelectPrepare__14CBaseMenuClassFP13CGameDataUsedii
     * @address 0x239650
     * @size 0x7C
     */
    int MenuItemCommnadSelectPrepare(CGameDataUsed *item, int place, int chara);

    /**
     *
     * Opens the command list for an item; returns non-zero when it opened.
     *
     * @mangled MenuItemMoveItemCommand__14CBaseMenuClassFP13CGameDataUsediiP16CMenuPosDataFormi
     * @address 0x2396D0
     * @size 0x22C
     */
    int MenuItemMoveItemCommand(CGameDataUsed *item, int place, int mes_no, CMenuPosDataForm *form, int chara);

    /**
     *
     * Moves the cursor of the command list and runs the command that is chosen.
     *
     * @mangled MenuItemCommandSelect__14CBaseMenuClassFii
     * @address 0x239900
     * @size 0xFF4
     */
    int MenuItemCommandSelect(int select_key, int push_button);
    /**
     *
     * Processes the command list after quick-slot input has been handled.
     *
     */
    int MenuItemCommandSelectCore(int select_key, int push_button);

    /**
     *
     * Places the command list window next to the item it was opened for.
     *
     * @mangled SetItemCmdMsgPos__14CBaseMenuClassFPi
     * @address 0x23A900
     * @size 0x480
     */
    void SetItemCmdMsgPos(int *pos);

    /**
     *
     * Runs the question of how many of an item to move.
     *
     * @mangled MenuItemAskMode_HowMuch__14CBaseMenuClassFii
     * @address 0x23AEF0
     * @size 0xF8
     */
    void MenuItemAskMode_HowMuch(int select_key, int push_button);

    /**
     *
     * Opens the question of fusing a spectrumised attachment into a weapon.
     *
     * @mangled CheckSpectolFusion__14CBaseMenuClassFP13CGameDataUsediP16CMenuPosDataForm
     * @address 0x23B0A0
     * @size 0x278
     */
    int CheckSpectolFusion(CGameDataUsed *item, int panel, CMenuPosDataForm *form);

    /**
     *
     * Runs the spectrumise question.
     *
     * @mangled IsSpectolTrans__14CBaseMenuClassFii
     * @address 0x23B440
     * @size 0x410
     */
    int IsSpectolTrans(int select_key, int push_button);

    /**
     *
     * Runs the fusion question.
     *
     * @mangled IsSpectolFusion__14CBaseMenuClassFii
     * @address 0x23B850
     * @size 0x2C4
     */
    int IsSpectolFusion(int select_key, int push_button);

    /**
     *
     * Runs the question of throwing an item away.
     *
     * @mangled IsTrush__14CBaseMenuClassFii
     * @address 0x23BC10
     * @size 0x1F8
     */
    int IsTrush(int select_key, int push_button);

    /**
     *
     * Uses up an item on a target and closes the question.
     *
     * @mangled IsItemUseNum__14CBaseMenuClassFiiiP13CGameDataUsedP14CItemUseTarget
     * @address 0x23BE10
     * @size 0xA4
     */
    int IsItemUseNum(int mes_no, int select_key, int push_button, CGameDataUsed *item, CItemUseTarget *target);

    /**
     *
     * Runs the choice of which item to take out of a gift box.
     *
     * @mangled SelectInGiftBox__14CBaseMenuClassFii
     * @address 0x23BEC0
     * @size 0x1B0
     */
    int SelectInGiftBox(int select_key, int push_button);

    /**
     *
     * Opens the question of how many of an item to move.
     *
     * @mangled SetAskHowMuchItemNum__14CBaseMenuClassFP18MENU_SWAPITEM_INFOP13CGameDataUsed
     * @address 0x23C130
     * @size 0xAC
     */
    void SetAskHowMuchItemNum(MENU_SWAPITEM_INFO *info, CGameDataUsed *item);

    /**
     *
     * Copies the contents of a question into the menu, or clears them when there is none.
     *
     * @mangled SetAskParam__14CBaseMenuClassFP17MENU_ASKMODE_PARA
     * @address 0x23C1E0
     * @size 0x188
     */
    void SetAskParam(MENU_ASKMODE_PARA *para);

    /**
     *
     * Runs a named command of the screen's menu command script.
     *
     * @mangled ExeScript__14CBaseMenuClassFPc
     * @address 0x23C370
     * @size 0x14
     */
    void ExeScript(char *script);

    /**
     *
     * Runs whichever question is open; returns what that question returned.
     *
     * @mangled ExtendCommand__14CBaseMenuClassFii
     * @address 0x23C390
     * @size 0x178
     */
    int ExtendCommand(int select_key, int push_button);

    /**
     *
     * Moves the cursor of the make question; returns the direction the number moved in.
     *
     * @mangled SelectMakeObject__14CBaseMenuClassFi
     * @address 0x23C510
     * @size 0x118
     */
    int SelectMakeObject(int select_key);

    /**
     *
     * Closes the open question and plays a sound effect.
     *
     * @mangled IsAskEnd__14CBaseMenuClassFiP16CMenuPosDataForm
     * @address 0x23C630
     * @size 0x3C
     */
    void IsAskEnd(int se_no, CMenuPosDataForm *form);

    /**
     *
     * Starts fading the menu scene in.
     *
     * @mangled FadeInMenu__14CBaseMenuClassFif
     * @address 0x23C670
     * @size 0x2C
     */
    void FadeInMenu(int frames, float unused);

    /**
     *
     * Starts fading the menu scene out to black.
     *
     * @mangled FadeOutMenu__14CBaseMenuClassFif
     * @address 0x23C6A0
     * @size 0x38
     */
    void FadeOutMenu(int frames, float unused);

    /**
     *
     * Checks whether the menu scene is still fading.
     *
     * @mangled FadeCheckMenu__14CBaseMenuClassFv
     * @address 0x23C6E0
     * @size 0xC
     */
    int FadeCheckMenu();

    /**
     *
     * Draws the effects of a spectrumise or fusion in progress.
     *
     * @mangled EffectDrawCheck__14CBaseMenuClassFP16CMenuPosDataForm
     * @address 0x247620
     * @size 0x218
     */
    void EffectDrawCheck(CMenuPosDataForm *form);
};

STATIC_ASSERT(sizeof(CBaseMenuClass) == 0x110);

/**
 *
 * Holds the menu's key input, cursor, held item and music state.
 *
 */
class CMenuKeyFunc {
public:
    u8     frame_parity{};   /**< Alternates each menu frame to pace updates. */
    u8     key_enable{};     /**< Non-zero while the menu takes key input. */
    u8     key_input{};      /**< Non-zero once a direction key has been pressed. */
    u32    select_key{};     /**< Direction keys pressed this frame. @see MENU_SELECT_KEY */
    int    push_button{};    /**< Buttons pressed this frame. @see MENU_PUSH_BUTTON */
    int    tex_block[16]{};  /**< Texture blocks the menu system may use. */
    s32    tex_block_end{};  /**< Always -1, ending the list of texture blocks. */
    s16    open_type{};      /**< What the menu was opened as. @see MenuOpenType */
    int    now_mode{};       /**< Menu mode that is running. @see MenuModeID */
    int    next_mode{};      /**< Menu mode waiting to start, or -1. @see MenuModeID */
    s16    up_arrow_cnt{};   /**< Frames the up arrow of the how-many board stays lit. */
    s16    down_arrow_cnt{}; /**< Frames the down arrow of the how-many board stays lit. */
    u_int *pack{};           /**< Pack file of menu data. */
    int    pack_size{};      /**< Size of the pack file in bytes. */
    s16    waku_type{};      /**< Frame drawn around the cursor, or negative for none. */
    s32    unk_6C{};

    int cursor{};   /**< Selected row in the current menu. */
    int top_line{}; /**< First visible row in the current menu. */

    int                 save_cursor{};   /**< Cursor position saved by SelDataInit. */
    int                 save_top_line{}; /**< First row shown saved by SelDataInit. */
    u8                  return_item{};   /**< Set once the held item has been put back. */
    u8                  unk_81[0xF]{};
    mgRect<int>         rect;        /**< Rectangle of the menu system. */
    CUserDataManager   *user_data{}; /**< Player data the menu acts on. */
    u8                  unk_A4[0x1C]{};
    CGameDataUsed       have_item;       /**< Item the cursor is carrying. */
    MENU_SWAPITEM_INFO  have_swap{};     /**< Where the carried item came from. */
    MENU_INPUTKEY_ARG  *key_arg{};       /**< Cursor layout in use. */
    CMenuPosDataForm   *cursor_form{};   /**< Form of the cursor. */
    CMenuPosDataForm   *waku_form{};     /**< Form of the frame around the cursor. */
    CMenuPosDataForm   *how_much_form{}; /**< Form of the how-many board. */
    MENUFORMPARTS_TYPE *have_icon{};     /**< Icon of the carried item on the cursor. */
    MENUFORMPARTS_TYPE *have_shadow{};   /**< Shadow of the carried item's icon. */
    MENUFORMPARTS_TYPE *have_num{};      /**< Count of the carried item. */
    int                 bgm_vol{};       /**< Background music volume before the menu faded it. */
    int                 bgm_step{};      /**< Amount the volume changes each frame. */
    s16                 bgm_target{};    /**< Volume the fade ends at. */
    s16                 bgm_fading{};    /**< Non-zero while the volume is fading. */
    s32                 unk_15C{};

    /**
     *
     * Creates the menu system state cleared.
     *
     */
    CMenuKeyFunc();

    /**
     *
     * Clears every value and forgets every form.
     *
     * @mangled Initialize__12CMenuKeyFuncFv
     * @address 0x23E110
     * @size 0xD0
     */
    void Initialize();

    /**
     *
     * Looks up the forms and parts of the cursor, its frame and the how-many board.
     *
     * @mangled AttachFuncData__12CMenuKeyFuncFv
     * @address 0x23E1E0
     * @size 0xA8
     */
    void AttachFuncData();

    /**
     *
     * Returns the party character that is active.
     *
     * @mangled GetActiveCharaNo__12CMenuKeyFuncFv
     * @address 0x23E290
     * @size 0xC
     */
    int GetActiveCharaNo();

    /**
     *
     * Moves the cursor and its frame towards a position; returns non-zero once the cursor is there.
     *
     * @mangled MenuPosStep__12CMenuKeyFuncFPiPi
     * @address 0x23E2A0
     * @size 0x1DC
     */
    int MenuPosStep(int *pos, int *offset);

    /**
     *
     * Puts the cursor and its frame onto a position at once.
     *
     * @mangled MenuSetPos__12CMenuKeyFuncFii
     * @address 0x23E480
     * @size 0x30
     */
    void MenuSetPos(int x, int y);

    /**
     *
     * Stops the cursor and its frame from moving.
     *
     * @mangled MenuPosStop__12CMenuKeyFuncFv
     * @address 0x23E4B0
     * @size 0x18
     */
    void MenuPosStop();

    /**
     *
     * Lets the cursor and its frame move again.
     *
     * @mangled MenuPosPlay__12CMenuKeyFuncFv
     * @address 0x23E4D0
     * @size 0x14
     */
    void MenuPosPlay();

    /**
     *
     * Sets how the cursor and its frame move to a new position.
     *
     * @mangled SetMoveMethod__12CMenuKeyFuncFi
     * @address 0x23E4F0
     * @size 0xC
     */
    void SetMoveMethod(int method);

    /**
     *
     * Sets how the frame around the cursor moves to a new position.
     *
     * @mangled SetWakuMoveMethod__12CMenuKeyFuncFi
     * @address 0x23E500
     * @size 0xC
     */
    void SetWakuMoveMethod(int method);

    /**
     *
     * Gives the screen position of the carried item's icon.
     *
     * @mangled GetItemPos__12CMenuKeyFuncFPi
     * @address 0x23E510
     * @size 0x18
     */
    void GetItemPos(int *pos);

    /**
     *
     * Chooses which frame is drawn around the cursor; a negative type hides it.
     *
     * @mangled SetWakuType__12CMenuKeyFuncFi
     * @address 0x23E530
     * @size 0xA4
     */
    void SetWakuType(int type);

    /**
     *
     * Sets the width and height of one frame around the cursor.
     *
     * @mangled SetWakuWH__12CMenuKeyFuncFiii
     * @address 0x23E5E0
     * @size 0x7C
     */
    void SetWakuWH(int part, int width, int height);

    /**
     *
     * Sets the two counters that shake the cursor.
     *
     * @mangled SetVibeCnt__12CMenuKeyFuncFii
     * @address 0x23E660
     * @size 0x44
     */
    void SetVibeCnt(int count0, int rate);

    /**
     *
     * Sets how far the parts of the cursor shake.
     *
     * @mangled SetVibeR__12CMenuKeyFuncFii
     * @address 0x23E6B0
     * @size 0x90
     */
    void SetVibeR(int strength, int speed);

    /**
     *
     * Gives the screen position of the cursor.
     *
     * @mangled GetCursorPos__12CMenuKeyFuncFPi
     * @address 0x23E740
     * @size 0x18
     */
    void GetCursorPos(int *pos);

    /**
     *
     * Gives the first row of the list that is shown.
     *
     */
    int GetTopLine() { return top_line; }

    /**
     *
     * Starts fading the cursor and its frame in.
     *
     * @mangled CursorFadeIn__12CMenuKeyFuncFfi
     * @address 0x23E760
     * @size 0x84
     */
    void CursorFadeIn(float speed, int steps);

    /**
     *
     * Starts fading the cursor and its frame out.
     *
     * @mangled CursorFadeOut__12CMenuKeyFuncFfi
     * @address 0x23E7F0
     * @size 0x84
     */
    void CursorFadeOut(float speed, int steps);

    /**
     *
     * Checks whether the carried item may be put down at the cursor.
     *
     * @mangled EnableSwapNowPos__12CMenuKeyFuncFP18MENU_SWAPITEM_INFO
     * @address 0x23E880
     * @size 0x628
     */
    int EnableSwapNowPos(MENU_SWAPITEM_INFO *swap);

    /**
     *
     * Picks up every one of an item onto the cursor; returns non-zero when it did.
     *
     * @mangled GetItemAll__12CMenuKeyFuncFP13CGameDataUsedP18MENU_SWAPITEM_INFO
     * @address 0x23EEB0
     * @size 0x88
     */
    int GetItemAll(CGameDataUsed *item, MENU_SWAPITEM_INFO *info);

    /**
     *
     * Clears the keys pressed and saves the cursor position.
     *
     * @mangled SelDataInit__12CMenuKeyFuncFv
     * @address 0x2405B0
     * @size 0x20
     */
    void SelDataInit();

    /**
     *
     * Reads the directional pad; returns the direction keys pressed. @see MENU_SELECT_KEY
     *
     * @mangled CheckSelectKey__12CMenuKeyFuncFv
     * @address 0x2405D0
     * @size 0xC4
     */
    int CheckSelectKey();

    /**
     *
     * Reads the shoulder buttons; returns the one pressed. @see MENU_SELECT_KEY
     *
     * @mangled CheckLRKey__12CMenuKeyFuncFv
     * @address 0x2406A0
     * @size 0xB0
     */
    int CheckLRKey();

    /**
     *
     * Reads the face buttons; returns the one pressed. @see MENU_PUSH_BUTTON
     *
     * @mangled CheckPushButton__12CMenuKeyFuncFv
     * @address 0x2408C0
     * @size 0x3C
     */
    int CheckPushButton();

    /**
     *
     * Reads one or both analogue sticks into a direction; returns 1.0.
     *
     * @mangled CheckAnalogKey__12CMenuKeyFuncFiPf
     * @address 0x240900
     * @size 0x10C
     */
    float CheckAnalogKey(int stick, float *dir);

    /**
     *
     * Returns whether a direction key has been pressed since the keys were last cleared.
     *
     * @mangled CheckKeyInput__12CMenuKeyFuncFv
     * @address 0x240A10
     * @size 0x2C
     */
    u8 CheckKeyInput();

    /**
     *
     * Reads the keys of the debug controls into two values.
     *
     * @mangled GetDebugInputKey__12CMenuKeyFuncFRiRi
     * @address 0x240A40
     * @size 0x204
     */
    int GetDebugInputKey(int &held, int &pressed);

    /**
     *
     * Swaps some of an item with the item the cursor carries; returns how the swap went.
     *
     * @mangled MenuSwapItem__12CMenuKeyFuncFP13CGameDataUsedP18MENU_SWAPITEM_INFOib
     * @address 0x240C50
     * @size 0xDC
     */
    int MenuSwapItem(CGameDataUsed *item, MENU_SWAPITEM_INFO *swap, int quantity, bool flag);

    /**
     *
     * Puts the carried item back where it came from; returns how the swap went.
     *
     * @mangled ReturnItemMenu__12CMenuKeyFuncFi
     * @address 0x240E30
     * @size 0x170
     */
    int ReturnItemMenu(int hide);

    /**
     *
     * Empties the cursor of any carried item.
     *
     * @mangled InitHaveData__12CMenuKeyFuncFv
     * @address 0x240FA0
     * @size 0x50
     */
    void InitHaveData();

    /**
     *
     * Shows or hides the carried item on the cursor and updates its icon and count.
     *
     * @mangled SetHaveItemInfo__12CMenuKeyFuncFii
     * @address 0x240FF0
     * @size 0x1A8
     */
    void SetHaveItemInfo(int visible, int detail);

    /**
     *
     * Moves the cursor of a list layout; returns the layout to leave to, or -1.
     *
     * @mangled menu_inputkey_limmit_check_line__12CMenuKeyFuncFi
     * @address 0x2411A0
     * @size 0xF0
     */
    int menu_inputkey_limmit_check_line(int select_key);

    /**
     *
     * Moves the cursor of a grid layout; returns the layout to leave to, or -1.
     *
     * @mangled menu_inputkey_limmit_check_glid__12CMenuKeyFuncFi
     * @address 0x241290
     * @size 0x174
     */
    int menu_inputkey_limmit_check_glid(int select_key);

    /**
     *
     * Moves the cursor within the current layout; returns the layout to leave to, or -1.
     *
     * @mangled CheckMoveSelect__12CMenuKeyFuncFi
     * @address 0x241410
     * @size 0x5C
     */
    int CheckMoveSelect(int select_key);

    /**
     *
     * Starts fading the background music down to a volume.
     *
     * @mangled FadeOutMenuBGMVol__12CMenuKeyFuncFii
     * @address 0x241470
     * @size 0x68
     */
    void FadeOutMenuBGMVol(int step, int volume);

    /**
     *
     * Starts fading the background music back up to its volume before the menu.
     *
     * @mangled FadeInMenuBGMVol__12CMenuKeyFuncFi
     * @address 0x2414E0
     * @size 0x18
     */
    void FadeInMenuBGMVol(int step);

    /**
     *
     * Steps the background music fade; returns non-zero while it is still fading.
     *
     * @mangled StepMenuBGM__12CMenuKeyFuncFv
     * @address 0x241500
     * @size 0x9C
     */
    s16 StepMenuBGM();
};

STATIC_ASSERT(sizeof(CMenuKeyFunc) == 0x160);

/**
 *
 * Pages of the item menu, as CMenuItemInfo::view_mode holds them.
 *
 */
// clang-format off
enum MENU_ITEM_VIEW {
    MENU_ITEM_VIEW_MAX = 0,         /**< Max's equipment. */
    MENU_ITEM_VIEW_MONICA = 1,      /**< Monica's equipment. */
    MENU_ITEM_VIEW_WEAPON = 2,      /**< The weapon being viewed. */
    MENU_ITEM_VIEW_ROBO = 3,        /**< The ridepod's parts. */
    MENU_ITEM_VIEW_MONSTER = 4,     /**< The monster Monica has transformed into. */
    MENU_ITEM_VIEW_FISHING_ROD = 5, /**< The fishing rod being viewed. */
};

// clang-format on

/**
 *
 * The item menu: the party's equipment, the inventory, the ridepod and monster forms, and the commands on items.
 *
 */
class CMenuItemInfo : public CBaseMenuClass {
public:
    s16                 view_mode{};              /**< Page that is shown. @see MENU_ITEM_VIEW */
    s16                 active_chara_view_mode{}; /**< Page of the active character, which the menu turns back to. @see MENU_ITEM_VIEW */
    s16                 sub_view{};               /**< Sub-page that is shown within the page. */
    s16                 view_chara{};             /**< Character whose model is shown. */
    s16                 load_item_no{};           /**< Item list the menu loads models for. */
    s16                 mos_id{};                 /**< Monster form in use when the menu opened. */
    s32                 unk_11C{};
    s16                 equip_list[8]{};    /**< Item numbers of the equipment of the shown character. */
    u8                  equip_flag[8]{};    /**< Flags of the equipment of the shown character. */
    s16                 load_weapon_no{};   /**< Item number of the weapon whose model is loaded. */
    u8                  reset_cursor_pos{}; /**< Non-zero when the item menu cursor must return to its initial position. */
    sceVu0FVECTOR       camera_ref{};       /**< Point the menu camera looks at. */
    sceVu0FVECTOR       camera_pos{};       /**< Position of the menu camera. */
    u8                  viewing_weapon{};   /**< Non-zero while the menu shows a weapon model. */
    u8                  unk_161[0xB]{};
    u8                  repair_running{};     /**< Non-zero while the weapon repair effect runs. */
    u8                  effect_pos{};         /**< Non-zero once the place of the item effect is known. */
    u8                  sound_loaded{};       /**< Non-zero once the shown character's voices are loaded. */
    u8                  sound_load{};         /**< Non-zero when the shown character's voices must be loaded. */
    u8                  item_consumed{};      /**< Non-zero after the current item has been consumed. */
    s16                 equipped_model_no{};  /**< Model number of the equipped item shown by the menu. */
    s16                 chara_reload{};       /**< Non-zero when the displayed character must be reloaded. */
    s16                 sub_menu{};           /**< Screen opened from the item menu that is running, or -1 for the item menu itself. @see MENU_ITEM_SUB_MENU */
    s16                 next_sub_menu{};      /**< Screen to open from the item menu, or -1 for none. @see MENU_ITEM_SUB_MENU */
    CGameDataUsed      *view_weapon{};        /**< Weapon whose status is shown. */
    CMenuPosDataForm   *view_form[6]{};       /**< Forms of the pages. */
    s16                 status_check_ready{}; /**< Non-zero when the special status check can be accepted. */
    CMenuPosDataForm   *item_board_form{};    /**< Form of the inventory board. */
    s32                 unk_1A0{};
    CMenuPosDataForm   *money_form{};         /**< Form of the money board. */
    CMenuPosDataForm   *chara_poly_form[2]{}; /**< Forms behind the two character models. */
    CMenuPosDataForm   *fill_form{};          /**< Form that fills the main page. */
    MENUFORMPARTS_TYPE *item_board_icon{};    /**< Icon part of the inventory board. */
    MENUFORMPARTS_TYPE *wep_parts[2][16]{};   /**< Parts of the two weapon slots of each character page, from index 4. */
    u8                  unk_238[0x68]{};
    MENUFORMPARTS_TYPE *robo_parts[6]{};    /**< Parts of the ridepod page. */
    MENUFORMPARTS_TYPE *hp_bar[2]{};        /**< Life bar of each character page. */
    MENUFORMPARTS_TYPE *item_parts[2][3]{}; /**< Item icons of each character page. */
    MENUFORMPARTS_TYPE *item_num[2][3]{};   /**< Item counts of each character page. */
    MENUFORMPARTS_TYPE *voice_part{};       /**< Voice part of the ridepod page. */
    CActionChara       *build_up_chara{};   /**< Model of the weapon being built up. */
    s32                 build_loading{};    /**< Non-zero while a build-up item model is loading. */
    s16                 unk_2FC{};
    s16                 debug_item_no{};    /**< Item number the debug controls show. */
    u8                  debug_item_count{}; /**< Number of items selected by the debug item controls. */
    CGameDataUsed       debug_item;         /**< Item the debug controls show. */

    /**
     *
     * Acts on the outcome of an item command after it has run.
     *
     * @mangled ItemCmdAfter__13CMenuItemInfoFiP16ITEMCMD_RET_PARA
     * @address 0x2432E0
     * @size 0x11D8
     */
    int ItemCmdAfter(int cmd_ret, ITEMCMD_RET_PARA *ret) override;

    /**
     *
     * Opens the question of an item command that the item menu adds.
     *
     * @mangled IsAskExtend__13CMenuItemInfoFii
     * @address 0x2444C0
     * @size 0xA68
     */
    int IsAskExtend(int select_key, int push_button) override;

    /**
     *
     * Puts back any carried item and stores the equipment as the menu closes.
     *
     * @mangled ExitEnd__13CMenuItemInfoFv
     * @address 0x245730
     * @size 0x334
     */
    void ExitEnd() override;

    /**
     *
     * Sets the menu back to its first page.
     *
     * @mangled Initialize__13CMenuItemInfoFv
     * @address 0x2421A0
     * @size 0xEC
     */
    void Initialize();

    /**
     *
     * Copies the equipment of a character, the ridepod or nobody into the equipment list.
     *
     * @mangled SetEquipListNo__13CMenuItemInfoFi
     * @address 0x242290
     * @size 0xCC
     */
    void SetEquipListNo(int list_no);

    /**
     *
     * Checks whether the equipment has changed since the list was copied.
     *
     * @mangled CheckEquipListNo__13CMenuItemInfoFi
     * @address 0x242360
     * @size 0x1F0
     */
    int CheckEquipListNo(int list_no);

    /**
     *
     * Loads the shown character's voices when they are needed; returns non-zero when it did.
     *
     * @mangled CheckSoundLoad__13CMenuItemInfoFv
     * @address 0x242550
     * @size 0x70
     */
    int CheckSoundLoad();

    /**
     *
     * Returns the item at the cursor, or null for an empty place.
     *
     * @mangled SearchNowPosItemExist__13CMenuItemInfoFv
     * @address 0x2425C0
     * @size 0x154
     */
    CGameDataUsed *SearchNowPosItemExist();

    /**
     *
     * Puts the carried item back when no model needs loading.
     *
     * @mangled IsCancelNoneLoadItem__13CMenuItemInfoFv
     * @address 0x242720
     * @size 0x17C
     */
    void IsCancelNoneLoadItem();

    /**
     *
     * Puts the carried item back when a model needs loading; returns non-zero when it did.
     *
     * @mangled IsCancelLoadItem__13CMenuItemInfoFv
     * @address 0x2428A0
     * @size 0x280
     */
    int IsCancelLoadItem();

    /**
     *
     * Remembers which weapon is shown before the carried item is swapped.
     *
     * @mangled SaveViewWeaponStatus__13CMenuItemInfoFv
     * @address 0x242B20
     * @size 0xA0
     */
    void SaveViewWeaponStatus();

    /**
     *
     * Points the shown weapon at where it went after a swap.
     *
     * @mangled CheckViewWeaponStatus__13CMenuItemInfoFi
     * @address 0x242BC0
     * @size 0x5C
     */
    void CheckViewWeaponStatus(int revert);

    /**
     *
     * Turns back to the page of the active character.
     *
     * @mangled ReturnActiveCharaViewMode__13CMenuItemInfoFi
     * @address 0x242C20
     * @size 0x154
     */
    int ReturnActiveCharaViewMode(int mode);

    /**
     *
     * Opens the weapon build-up view for a weapon.
     *
     * @mangled NextModeBuildUpInfo__13CMenuItemInfoFP13CGameDataUsed
     * @address 0x242D80
     * @size 0x1CC
     */
    void NextModeBuildUpInfo(CGameDataUsed *weapon);

    /**
     *
     * Equips an item on a character straight from the inventory; returns non-zero when it did.
     *
     * @mangled EquipDirect__13CMenuItemInfoFiP13CGameDataUsedRi
     * @address 0x242F50
     * @size 0x2CC
     */
    int EquipDirect(int chara, CGameDataUsed *item, int &slot);

    /**
     *
     * Marks the shown character's voices for loading when its weapon has changed.
     *
     * @mangled CheckLoadInfo__13CMenuItemInfoFi
     * @address 0x243220
     * @size 0xB8
     */
    void CheckLoadInfo(int chara);

    /**
     *
     * Enters the menu's textures from a pack file.
     *
     * @mangled EnterDataMenu__13CMenuItemInfoFPUi
     * @address 0x2454E0
     * @size 0x174
     */
    void EnterDataMenu(unsigned int *pack);

    /**
     *
     * Returns the character that item commands act on for the shown page.
     *
     * @mangled GetActiveCharaIDForItemCmd__13CMenuItemInfoFv
     * @address 0x245660
     * @size 0x78
     */
    int GetActiveCharaIDForItemCmd();

    /**
     *
     * Returns the party character that is active.
     *
     * @mangled GetActiveCharaNo__13CMenuItemInfoFv
     * @address 0x2456E0
     * @size 0x4C
     */
    int GetActiveCharaNo();

    /**
     *
     * Looks up the forms and parts of every page.
     *
     * @mangled AttachFormInfo__13CMenuItemInfoFv
     * @address 0x245A70
     * @size 0x444
     */
    void AttachFormInfo();

    /**
     *
     * Allocates the work memory of the menu.
     *
     * @mangled MenuModeMalloc__13CMenuItemInfoFP9mgCMemory
     * @address 0x245EC0
     * @size 0x3B8
     */
    void MenuModeMalloc(mgCMemory *stack);

    /**
     *
     * Updates every form of the shown page.
     *
     * @mangled CalcTex__13CMenuItemInfoFv
     * @address 0x246280
     * @size 0xCF8
     */
    void CalcTex();

    /**
     *
     * Moves the cursor onto the place it points at.
     *
     * @mangled CalcCursorPosition__13CMenuItemInfoFv
     * @address 0x246F80
     * @size 0x698
     */
    void CalcCursorPosition();

    /**
     *
     * Acts on the buttons pressed while no question is open.
     *
     * @mangled PushKey__13CMenuItemInfoFii
     * @address 0x24A890
     * @size 0x1B94
     */
    int PushKey(int pad, int trigger);

    /**
     *
     * Chooses which item list models are loaded for.
     *
     * @mangled CheckLoadItemNo__13CMenuItemInfoFv
     * @address 0x24EA00
     * @size 0x7C
     */
    void CheckLoadItemNo();

    /**
     *
     * Starts reading the models of a page; returns non-zero when it started.
     *
     * @mangled ModelReadStart__13CMenuItemInfoFiii
     * @address 0x24EA80
     * @size 0x434
     */
    int ModelReadStart(int mode, int check_item, int restart_read);

    /**
     *
     * Shows the build-up mark of a character's weapon.
     *
     * @mangled WeaponBuildCheck__13CMenuItemInfoFP12CActionCharaii
     * @address 0x24EEC0
     * @size 0x204
     */
    void WeaponBuildCheck(CActionChara *chara, int chara_no, int tex_block);

    /**
     *
     * Checks whether the models of a page have been read; returns non-zero once they have.
     *
     * @mangled ModelReadEndCheck__13CMenuItemInfoFv
     * @address 0x24F0D0
     * @size 0x4CC
     */
    int ModelReadEndCheck();

    /**
     *
     * Gives the screen position at which the effect of an item is shown.
     *
     * @mangled SearchEffectDisplayPosition__13CMenuItemInfoFPiP13CGameDataUsed
     * @address 0x24F5A0
     * @size 0x1A0
     */
    void SearchEffectDisplayPosition(int *pos, CGameDataUsed *item);

    /**
     *
     * Starts the effect of an item that has been used or spectrumised.
     *
     * @mangled SetItemEffect__13CMenuItemInfoFv
     * @address 0x24F740
     * @size 0x40C
     */
    void SetItemEffect();

    /**
     *
     * Turns the page on a shoulder button and returns zero.
     *
     * @mangled LRCheck__13CMenuItemInfoFi
     * @address 0x24FB50
     * @size 0x370
     */
    int LRCheck(int key);

    /**
     *
     * Moves the cursor and acts on the buttons while no question is open.
     *
     * @mangled KeyStepLocal__13CMenuItemInfoFiii
     * @address 0x2507B0
     * @size 0x230
     */
    void KeyStepLocal(int select_key, int push_button, int flag);

    /**
     *
     * Runs one frame of the menu's key handling; returns non-zero once the menu is over.
     *
     * @mangled KeyStep__13CMenuItemInfoFv
     * @address 0x2509E0
     * @size 0x5CC
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CMenuItemInfo) == 0x370);

/**
 *
 * Shape of the grid of the item choice.
 *
 */
enum ITEM_SELECT_GRID {
    ITEM_SELECT_COLUMNS = 5, /**< Items in each row of the item choice. */
};

/**
 *
 * The item choice that an event asks for: a grid of the inventory to pick one item from.
 *
 */
class CItemSelect : public CBaseMenuClass {
public:
    int            item_num;                         /**< Number of items in the list. */
    CGameDataUsed *item_list[MENU_BAG_PLACE_MAX]{};  /**< Items that can be chosen. */
    s8             limit_disp[MENU_BAG_PLACE_MAX]{}; /**< Non-zero for each listed item that is shown as unavailable. */
    s16            alpha_step;                       /**< Amount the alpha changes each frame. */
    int            alpha;                            /**< Alpha the list is drawn with. */
    int            bg_alpha;                         /**< Alpha the background is drawn with. */
    s32            unk_40C{};
    mgRect<float>  list_rect; /**< Rectangle of the list. */
    mgRect<float>  item_rect; /**< Rectangle of one item in the list. */
    float          cursor_x;  /**< Drawn position of the cursor, which eases towards the item it is on. */
    float          cursor_y;  /**< Drawn position of the cursor, which eases towards the item it is on. */
    float          scroll;    /**< Drawn scroll of the list, which eases towards the first row shown. */
    mgCTexture    *texture;   /**< Texture the list is drawn with. */
    int            cursor;    /**< Item the cursor is on. */
    int            top_line;  /**< First row shown. */
    float          line_num;  /**< Number of rows of the list. */
    s32            unk_44C{};

    /**
     *
     * Creates the list of the items that can be chosen, placed at the bottom of the screen.
     *
     */
    CItemSelect();

    /**
     *
     * Lists every item of the inventory that can be chosen.
     *
     * @mangled SetPtrList__11CItemSelectFv
     * @address 0x251780
     * @size 0x15C
     */
    void SetPtrList();

    /**
     *
     * Returns the item at a place in the list, or null.
     *
     * @mangled GetExistThisPosData__11CItemSelectFi
     * @address 0x2518E0
     * @size 0x38
     */
    CGameDataUsed *GetExistThisPosData(int pos);

    /**
     *
     * Uses up one of the chosen item when the event asks for it.
     *
     * @mangled CheckUse__11CItemSelectFP13CGameDataUsed
     * @address 0x251920
     * @size 0x7C
     */
    void CheckUse(CGameDataUsed *item);

    /**
     *
     * Runs one frame of the choice's key handling; returns non-zero once it is over.
     *
     * @mangled KeyStep__11CItemSelectFv
     * @address 0x2519A0
     * @size 0x524
     */
    int KeyStep();

    /**
     *
     * Draws the list and the cursor.
     *
     * @mangled Draw__11CItemSelectFv
     * @address 0x251ED0
     * @size 0xA04
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CItemSelect) == 0x450);

/**
 *
 * Arrows and marks drawn around the cursor of the item menu.
 *
 */
struct MENU_ITEM_CURSOR_INFO {
    u8  enable;     /**< Non-zero while the marks are drawn. */
    u8  arrow[5];   /**< Non-zero for each arrow that is drawn. */
    u8  chara_mark; /**< Non-zero when the mark on the character is drawn. */
    u8  unk_7;
    int counter; /**< Frame counter that makes the marks bob. */
};

STATIC_ASSERT(sizeof(MENU_ITEM_CURSOR_INFO) == 0xC);

/**
 *
 * State of the weapon build-up view and the choice of a build-up within it.
 *
 */
struct BUILDUP_WEAPON_INFO {
    s16            monster_mode; /**< Selects the monster form build-up view. */
    s8             mode;         /**< Phase of the build-up view. */
    s8             select_no;    /**< Selected build-up choice. */
    s16            build_up;     /**< Number of available build-up choices. */
    s16            unk_6;
    int            select_num;   /**< Number of choices returned by CheckBuildUp. */
    int            weapon_no[3]; /**< Weapon IDs offered as build-up results. */
    int            enable[3];    /**< Availability of each build-up result. */
    CGameDataUsed *weapon;       /**< Weapon being built up. */
    s32            unk_28;
    CDataWeapon   *weapon_data[3]; /**< Data for the offered build-up weapons. */
    s32            unk_38[3];
};

STATIC_ASSERT(sizeof(BUILDUP_WEAPON_INFO) == 0x44);

/**
 *
 * Prepares a fishing rod for the fishing game; returns 0 for an item that is no fishing
 * rod, 1 for a rod that cannot be equipped and 2 for one that was.
 *
 * @mangled CheckEquipFishRod__FP13CGameDataUsed
 * @address 0x23B3D0
 * @size 0x6C
 */
int CheckEquipFishRod(CGameDataUsed *item);

/**
 *
 * Checks whether the throw-away command is offered for an item.
 *
 * @mangled IsDispTrushCommand__FP13CGameDataUsed
 * @address 0x23BB20
 * @size 0xE8
 */
int IsDispTrushCommand(CGameDataUsed *item);

/**
 *
 * Opens the throw-away question for an item.
 *
 * @mangled SetPreCmdTrush__FP14CBaseMenuClassiP13CGameDataUsedP16CMenuPosDataForm
 * @address 0x23C6F0
 * @size 0x128
 */
void SetPreCmdTrush(CBaseMenuClass *menu, int panel, CGameDataUsed *item, CMenuPosDataForm *form);

/**
 *
 * Opens the spectrumise question for an item.
 *
 * @mangled SetPreCmdSpectolBreak__FP14CBaseMenuClassiP16CMenuPosDataFormP13CGameDataUsedP13CGameDataUsed
 * @address 0x23C820
 * @size 0xDC
 */
void SetPreCmdSpectolBreak(CBaseMenuClass *menu, int panel, CMenuPosDataForm *form, CGameDataUsed *item,
                           CGameDataUsed *target);

/**
 *
 * Opens the choice of which item to take out of a gift box.
 *
 * @mangled SetPreCmdGiftBoxSelect__FP14CBaseMenuClassP13CGameDataUsed
 * @address 0x23C900
 * @size 0x58
 */
void SetPreCmdGiftBoxSelect(CBaseMenuClass *menu, CGameDataUsed *item);

/**
 *
 * Checks whether a ridepod part fits the ridepod's capacity and is not broken.
 *
 * @mangled IsEnableChangeRoboParts__FP13CGameDataUsed
 * @address 0x23CB00
 * @size 0x134
 */
int IsEnableChangeRoboParts(CGameDataUsed *part);

/**
 *
 * Records the attachment and the weapon of a fusion.
 *
 * @mangled SetSpectolInfo__FP13CGameDataUsedP13CGameDataUsed
 * @address 0x23CC40
 * @size 0xC
 */
void SetSpectolInfo(CGameDataUsed *item, CGameDataUsed *part);

/**
 *
 * Steps the colour of the fusion effect and copies it into a colour when asked.
 *
 * @mangled FusionColor__FiiPf
 * @address 0x23CF40
 * @size 0x20C
 */
void FusionColor(int fusing, int apply, float *color);

/**
 *
 * Gives the ridepod's capacity, counting the carried part; returns the capacity in use.
 *
 * @mangled CheckNowRoboUseCapacity__FPi
 * @address 0x23D460
 * @size 0x68
 */
int CheckNowRoboUseCapacity(int *capacity);

/**
 *
 * Makes the source record of an item being moved from a table of places.
 *
 * @mangled ExchangeItemInfoMake__FP18MENU_SWAPITEM_INFOPA4_iii
 * @address 0x23D4D0
 * @size 0x10C
 */
int ExchangeItemInfoMake(MENU_SWAPITEM_INFO *info, int (*row)[4], int mode, int is_equip);

/**
 *
 * Scrolls a list so that a row is shown.
 *
 * @mangled MenuCheckLine__FPiii
 * @address 0x23D5E0
 * @size 0x50
 */
void MenuCheckLine(int *top_line, int cursor, int visible_rows);

/**
 *
 * Moves a cursor by a step within limits and scrolls its list; returns how the move ended.
 *
 * @mangled MenuKeySelectCheck__FiPiPiiiii
 * @address 0x23D630
 * @size 0x178
 */
int MenuKeySelectCheck(int step, int *cursor, int *scroll, int min, int max, int visible, int limit_mode);

/**
 *
 * Moves the cursor of a list on the directional pad; returns whether it moved.
 *
 * @mangled MenuListKeyCheck__FiPiPiiiii
 * @address 0x23D7B0
 * @size 0xFC
 */
int MenuListKeyCheck(int keys, int *cursor, int *top_line, int count, int visible_rows, int key_pair, int wrap_kind);

/**
 *
 * Moves the cursor of a grid on the directional pad; returns whether it moved.
 *
 * @mangled MenuGlidKeyCheck__FiPiPiPiPiPii
 * @address 0x23D8B0
 * @size 0x2F4
 */
int MenuGlidKeyCheck(int select_key, int *pos, int *top_line, int *size, int *disp, int *limit, int max);

/**
 *
 * Turns up, down, L1 and R1 into a step of a list cursor; L1 and R1 move a page.
 *
 * @mangled MenuListSelectKeyCheck__Fii
 * @address 0x23DBB0
 * @size 0x50
 */
int MenuListSelectKeyCheck(int keys, int page_size);

/**
 *
 * Moves the cursor of the inventory board; returns whether it moved.
 *
 * @mangled MenuItemBrdKey__FiPiPii
 * @address 0x23DC00
 * @size 0x180
 */
int MenuItemBrdKey(int keys, int *cursor, int *scroll, int board);

/**
 *
 * Reads the face buttons; returns the one pressed. @see MENU_PUSH_BUTTON
 *
 * @mangled MenuCheckPushButton__Fv
 * @address 0x240750
 * @size 0x124
 */
int MenuCheckPushButton();

/**
 *
 * Turns the triangle bit of a button value into the cancel bit for languages that cancel with triangle.
 *
 * @mangled ConvertCheckPushButton__Fi
 * @address 0x240880
 * @size 0x34
 */
int ConvertCheckPushButton(int buttons);

/**
 *
 * Returns the item at the place a source record names, or null.
 *
 * @mangled GetGameDataUsedForSWAPINFO__FP18MENU_SWAPITEM_INFO
 * @address 0x240D30
 * @size 0x100
 */
CGameDataUsed *GetGameDataUsedForSWAPINFO(MENU_SWAPITEM_INFO *info);

/**
 *
 * Marks inventory and active items whose owned totals reach their item limits.
 *
 * @mangled CheckEnableHaveItemNum__Fv
 * @address 0x2415A0
 * @size 0x34C
 */
void CheckEnableHaveItemNum();

/**
 *
 * Moves the cursor of the item-move screen.
 *
 * @mangled MenuMoveItemPos__FPiPii
 * @address 0x244F30
 * @size 0x1CC
 */
void MenuMoveItemPos(int *row, int *pos, int phase);

/**
 *
 * Sets up the item-move screen from a table of places.
 *
 * @mangled CommonSetMoveItemClass__FPA4_i
 * @address 0x245100
 * @size 0x3D8
 */
void CommonSetMoveItemClass(int (*table)[4]);

/**
 *
 * Opens the item menu.
 *
 * @mangled MenuItemInit__FP9mgCMemoryPii
 * @address 0x247840
 * @size 0x5C4
 */
int MenuItemInit(mgCMemory *stack, int *tex_block, int mode);

/**
 *
 * Checks whether a weapon can be built up, and gives what it can become; returns non-zero when it can.
 *
 * @mangled CheckBuildUp__FP13CGameDataUsedPiPiPi
 * @address 0x24D1C0
 * @size 0x2C
 */
int CheckBuildUp(CGameDataUsed *weapon, int *result0, int *result1, int *result2);

/**
 *
 * Builds up a weapon into another; returns non-zero when it did.
 *
 * @mangled BuildUpWeaponTrans__FP13CGameDataUsedi
 * @address 0x24D1F0
 * @size 0x370
 */
int BuildUpWeaponTrans(CGameDataUsed *item, int item_no);

/**
 *
 * Draws the weapon build-up view.
 *
 * @mangled MenuWeaponBuildUpDraw__FRi
 * @address 0x24D680
 * @size 0xE80
 */
void MenuWeaponBuildUpDraw(int &tex_block);

/**
 *
 * Draws the status of the shown character.
 *
 * @mangled MenuCharaStatusDraw__FRi
 * @address 0x24FFF0
 * @size 0x28C
 */
void MenuCharaStatusDraw(int &tex_block);

/**
 *
 * Draws the arrows and marks around the cursor of the item menu.
 *
 * @mangled MenuItemInfoCursorDraw__FRi
 * @address 0x250280
 * @size 0x524
 */
void MenuItemInfoCursorDraw(int &tex_block);

/**
 *
 * Runs one frame of the item menu's key handling; returns non-zero once the menu is over.
 *
 * @mangled MenuItemKey__Fv
 * @address 0x250FB0
 * @size 0x570
 */
int MenuItemKey();

/**
 *
 * Draws the item menu.
 *
 * @mangled MenuItemDraw__Fv
 * @address 0x251520
 * @size 0x260
 */
void MenuItemDraw();

/**
 *
 * Opens the item choice that an event asks for.
 *
 * @mangled MenuItemSelectInit__FP9mgCMemoryPii
 * @address 0x2528E0
 * @size 0x288
 */
void MenuItemSelectInit(mgCMemory *stack, int *tex_block, int mode);

/**
 *
 * Runs one frame of the item choice; returns non-zero once it is over.
 *
 * @mangled MenuItemSelectKey__Fv
 * @address 0x252B70
 * @size 0x28
 */
int MenuItemSelectKey();

/**
 *
 * Draws the item choice.
 *
 * @mangled MenuItemSelectDraw__Fv
 * @address 0x252BA0
 * @size 0x144
 */
void MenuItemSelectDraw();

/**
 *
 * Checks whether fishing is available on the current map and battle state.
 *
 * @mangled CheckFishCondition__Fv
 * @address 0x23C960
 * @size 0x88
 */
int CheckFishCondition();

/**
 *
 * Initializes the second spectol information panel when present.
 *
 * @mangled InitSpectol__Fv
 * @address 0x23CC50
 * @size 0x28
 */
void InitSpectol();

/**
 *
 * Applies an attachment's spectol values to a weapon and counts raised stats.
 *
 * @mangled AfterSpectolFusion__FP13CGameDataUsedP13CGameDataUsed
 * @address 0x23CC80
 * @size 0x2B4
 */
int AfterSpectolFusion(CGameDataUsed *item, CGameDataUsed *part);

/**
 *
 * Saves the source item state and consumes the amount converted to spectol.
 *
 * @mangled TransSpectolDataSave__FP13CGameDataUsedi
 * @address 0x23D3E0
 * @size 0x7C
 */
void TransSpectolDataSave(CGameDataUsed *item, int count);

/**
 *
 * Fills an item's available command messages in an ask-mode parameter record.
 *
 * @mangled GetItemCommandMsg__FP13CGameDataUsedP17MENU_ASKMODE_PARAii
 * @address 0x23EF40
 * @size 0x20
 */
int GetItemCommandMsg(CGameDataUsed *item, MENU_ASKMODE_PARA *param, int place, int chara);

/**
 *
 * Builds the commands, colors, values, and markers available for an item.
 *
 * @mangled GetItemCommandMsg__FP13CGameDataUsedPiPUiPsPsii
 * @address 0x23EF60
 * @size 0x1644
 */
int GetItemCommandMsg(CGameDataUsed *item, int *cmds, u32 *colors, short *values, short *marks, int place,
                      int chara);

/**
 *
 * Updates an attachment or weapon form with current and changed status values.
 *
 * @mangled MenuFormUpdataAttachInfo__FP16CMenuPosDataFormP13CGameDataUsediiPs
 * @address 0x241D80
 * @size 0x334
 */
void MenuFormUpdataAttachInfo(CMenuPosDataForm *form, CGameDataUsed *item, int item_no, int reset,
                              s16 *before);

/**
 *
 * Assigns an item's number to a visible information form part.
 *
 * @mangled local_item_infoview_set__FP18MENUFORMPARTS_TYPEP13CGameDataUsed
 * @address 0x24C430
 * @size 0x24
 */
void local_item_infoview_set(MENUFORMPARTS_TYPE *part, CGameDataUsed *item);

/**
 *
 * Updates a character's equipped weapon indicators and warning colors.
 *
 * @mangled MenuItemCharaActWepInfoDraw__FP16CMenuPosDataFormP13CGameDataUsedii
 * @address 0x24C460
 * @size 0x45C
 */
void MenuItemCharaActWepInfoDraw(CMenuPosDataForm *form, CGameDataUsed *equip, int chara_no, int flag);

/**
 *
 * Updates a character's visible health and equipment preview forms.
 *
 * @mangled MenuItemCharaViewCheck__FP10CHARA_DATAii
 * @address 0x24C8C0
 * @size 0x258
 */
void MenuItemCharaViewCheck(CHARA_DATA *chara, int chara_no, int flag);

/**
 *
 * Updates monster transformation status and health on its menu form.
 *
 * @mangled MenuPosFormValueSetMonster__FP16MOS_CHANGE_PARAMP10CHARA_DATA
 * @address 0x24CFC0
 * @size 0x200
 */
void MenuPosFormValueSetMonster(MOS_CHANGE_PARAM *monster, CHARA_DATA *chara);

/**
 *
 * Updates the weapon upgrade status form for a selected weapon.
 *
 * @mangled MenuWeaponStatusInfoFormSet__FP13CGameDataUsedP11CDataWeapon
 * @address 0x24E500
 * @size 0x290
 */
void MenuWeaponStatusInfoFormSet(CGameDataUsed *item, CDataWeapon *data);

/**
 *
 * Looks up the destination cursor layout and row for a preview page selection.
 *
 * @mangled MenuItemSelectDiffer__Fi
 * @address 0x24E790
 * @size 0x268
 */
int MenuItemSelectDiffer(int select);

/**
 *
 * Sets the item information cursor indicators for the active menu mode.
 *
 * @mangled MenuItemInfoCursorSet__Fi
 * @address 0x24FEC0
 * @size 0x128
 */
void MenuItemInfoCursorSet(int mode);

/**
 *
 * Sound effect played after a swap, for each way a swap can go.
 *
 * @mangled menu_item_swap_sndtbl
 * @address 0x355A60
 * @size 0x10
 */
extern s16 menu_item_swap_sndtbl[8];

/**
 *
 * Inventory place of the item being spectrumised, or -1.
 *
 * @mangled trans_spectol_pos
 * @address 0x37CA64
 * @size 0x4
 */
extern int trans_spectol_pos;

/**
 *
 * Weapon repair effect of the item menu.
 *
 * @mangled MenuRepairMan
 * @address 0x37DC1C
 * @size 0x4
 */
extern CRepairManager *MenuRepairMan;

/**
 *
 * Flags, per character and active item slot, marking active items whose owned totals reach the item limit.
 *
 * @mangled menu_chara_activeItem_limmit_check
 * @address 0x37DC28
 * @size 0x6
 */
extern u8 menu_chara_activeItem_limmit_check[2][3];

/**
 *
 * Non-zero while the character status texture is not drawn.
 *
 * @mangled MenuStatusMode
 * @address 0x37DC44
 * @size 0x1
 */
extern s8 MenuStatusMode;

/**
 *
 * Texture of the character status.
 *
 * @mangled MenuStatusTex
 * @address 0x37DC48
 * @size 0x4
 */
extern mgCTexture *MenuStatusTex;

/**
 *
 * Target that an item command uses an item on.
 *
 * @mangled MenuItemUseTarget
 * @address 0x37DC50
 * @size 0x8
 */
extern CItemUseTarget MenuItemUseTarget;

/**
 *
 * Effects of a spectrumise or fusion in progress.
 *
 * @mangled MenuEffect
 * @address 0x37DC60
 * @size 0x8
 */
extern CMenuEffect *MenuEffect[];

/**
 *
 * Attachment and weapon of a fusion in progress.
 *
 * @mangled SpectolInfo
 * @address 0x37DC70
 * @size 0x8
 */
extern CGameDataUsed *SpectolInfo[2];

/**
 *
 * Character model the fusion effect plays on.
 *
 * @mangled SpectolFusionTargetChara
 * @address 0x37DC7C
 * @size 0x4
 */
extern CCharacter2 *SpectolFusionTargetChara;

/**
 *
 * Kind of place of the item that the command list was opened for.
 *
 * @mangled MenuItemCmdArgPos
 * @address 0x37DC84
 * @size 0x2
 */
extern s16 MenuItemCmdArgPos;

/**
 *
 * Side the command list window opens on, or -1.
 *
 * @mangled MenuItemCommandDir
 * @address 0x37DC94
 * @size 0x4
 */
extern int MenuItemCommandDir;

/**
 *
 * Frame counter of the spectrumise effect.
 *
 * @mangled trans_spectol_cnt
 * @address 0x37DCB4
 * @size 0x4
 */
extern float trans_spectol_cnt;

/**
 *
 * Non-zero while the shown character model turns.
 *
 * @mangled itemmenu_chr_rotflag
 * @address 0x37DCC4
 * @size 0x1
 */
extern s8 itemmenu_chr_rotflag;

/**
 *
 * Texture of the weapon build-up board.
 *
 * @mangled Tex_BuildUpBoard
 * @address 0x37DD50
 * @size 0x4
 */
extern mgCTexture *Tex_BuildUpBoard;

/**
 *
 * Pointers into the player's data that the item menu reads.
 *
 * @mangled MenuUserParam
 * @address 0x1EFC8F0
 * @size 0x18
 */
extern CMENU_USERPARAM MenuUserParam;

/**
 *
 * Arrows and marks drawn around the cursor of the item menu.
 *
 * @mangled MenuItemCursorInfo
 * @address 0x1EFCAE0
 * @size 0xC
 */
extern MENU_ITEM_CURSOR_INFO MenuItemCursorInfo;

/**
 *
 * Memory that character data shown by the item menu is loaded into.
 *
 * @mangled MenuCharaLoadStack
 * @address 0x1EFCC20
 * @size 0x30
 */
extern mgCMemory MenuCharaLoadStack;

/**
 *
 * State of the weapon build-up view.
 *
 * @mangled BuildUpWeaponInfo
 * @address 0x1EFCC50
 * @size 0x44
 */
extern BUILDUP_WEAPON_INFO BuildUpWeaponInfo;

/**
 *
 * Copy of a weapon before a fusion, to compare with afterwards.
 *
 * @mangled SepectolFusionBeforeAfterCheck
 * @address 0x1EFCD10
 * @size 0x6C
 */
extern CGameDataUsed SepectolFusionBeforeAfterCheck;

/**
 *
 * Screen position of each build-up name in the weapon build-up view.
 *
 * @mangled BuildUpNameXY
 * @address 0x1EFCF58
 * @size 0xC
 */
extern s16 BuildUpNameXY[3][2];

/**
 *
 * Question contents handed to the menus that open a question.
 *
 * @mangled MenuAskParam
 * @address 0x1EFC850
 * @size 0x94
 */
extern MENU_ASKMODE_PARA MenuAskParam;

/**
 *
 * Memory the active character's model, skin and outline are read into when the menu closes.
 *
 * @mangled MainCharaReadStack
 * @address 0x1EFC910
 * @size 0x30
 */
extern mgCMemory MainCharaReadStack;

/**
 *
 * Work memory of the item menu.
 *
 * @mangled MenuItemMainMemory
 * @address 0x1EFCB60
 * @size 0x30
 */
extern mgCMemory MenuItemMainMemory;

/**
 *
 * Memory holding the item menu's pack file.
 *
 * @mangled MenuItemBGDataMemory
 * @address 0x1EFCB90
 * @size 0x30
 */
extern mgCMemory MenuItemBGDataMemory;

/**
 *
 * Memory of the screens opened from the item menu.
 *
 * @mangled MenuItemMemory
 * @address 0x1EFCBC0
 * @size 0x30
 */
extern mgCMemory MenuItemMemory;

/**
 *
 * Memory of the item menu's models, effects and move animations.
 *
 * @mangled MenuItemMemory2
 * @address 0x1EFCBF0
 * @size 0x30
 */
extern mgCMemory MenuItemMemory2;

/**
 *
 * Copy of the attachment of a fusion, or of the fishing rod before its points are spent.
 *
 * @mangled SpectolInfoStay
 * @address 0x1EFCCA0
 * @size 0x6C
 */
extern CGameDataUsed SpectolInfoStay;

/**
 *
 * Copy of an item before it was spectrumised.
 *
 * @mangled SpectolTransBefore
 * @address 0x1EFCDA0
 * @size 0x6C
 */
extern CGameDataUsed SpectolTransBefore;

/**
 *
 * Split-off part of a stack that is being moved.
 *
 * @mangled MenuMoveTempGameDataUsed
 * @address 0x1EFCE90
 * @size 0x6C
 */
extern CGameDataUsed MenuMoveTempGameDataUsed;

/**
 *
 * The item menu.
 *
 * @mangled class_menu_item_info
 * @address 0x1EFCFA0
 * @size 0x370
 */
extern CMenuItemInfo class_menu_item_info;

/**
 *
 * Memory of the item menu's debug model viewer.
 *
 * @mangled MenuDebugStack
 * @address 0x1EFD310
 * @size 0x30
 */
extern mgCMemory MenuDebugStack;

namespace dc2::menu {
/**
 * Constructs the owned inventory repair controller and retires its predecessor's member arenas.
 */
CRepairManager &CreateInventoryRepairManager();

/**
 * Releases the inventory repair controller before its supporting menu arenas are reused.
 */
void ResetInventoryRepairManager();
} // namespace dc2::menu
