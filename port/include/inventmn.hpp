#pragma once

#include "common.h"

#include <span>

#include "actionchara.hpp"
#include "dataread.hpp"
#include "memcard.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the invention menu: the photos the player takes with the camera,
 * the ideas ("neta") and scoops learnt from them, the album saved on the memory
 * card, the invention recipes that combine three ideas into an item, and the
 * menu in which the player browses photos, thinks up inventions and builds them.
 */

// clang-format off

/**
 *
 * Page of the invention menu shown, as held in key_arg_no.
 *
 */
enum INVENT_MENU_MODE {
    INVENT_MODE_THINK              = 0,  /**< Idea board, on which three ideas are combined into an invention. */
    INVENT_MODE_THINK_ALBUM_BUTTON = 1,  /**< Album-access button beside the idea board. */
    INVENT_MODE_CARD_LIST          = 2,  /**< List of the invention cards made so far. */
    INVENT_MODE_ITEM_LIST          = 3,  /**< List of the items the player carries. */
    INVENT_MODE_THINK_WITH_ALBUM   = 4,  /**< Idea board while the album is open beside it. */
    INVENT_MODE_ALBUM_VIEW         = 5,  /**< Album of photos kept on the memory card. */
    INVENT_MODE_PHOTO_VIEW         = 6,  /**< Photos carried by the player. */
    INVENT_MODE_PHOTO_ALBUM_BUTTON = 7,  /**< Album-access button beside the photo-only board. */
    INVENT_MODE_MEMO_BUTTON        = 8,  /**< Closed idea notebook above the idea board. */
    INVENT_MODE_MEMO_LIST          = 9,  /**< Idea words listed in the opened idea notebook. */
    INVENT_MODE_MEMO_ARROW         = 10, /**< Arrow between the idea board and the idea notebook. */
    INVENT_MODE_MEMO_CORK          = 11  /**< Cork tab above the opened idea notebook's word list. */
};

/**
 *
 * Inventory-specific states of the shared menu question flow.
 *
 */
enum INVENT_MENU_ASK_MODE {
    MENU_ASK_MODE_PHOTO_NETA   = 13, /**< Adds a selected photo to the idea board. */
    MENU_ASK_MODE_ALBUM_ACCESS = 14  /**< Runs the memory-card album access flow. */
};

/**
 *
 * Field of a photo that CheckInventPhoto compares against.
 *
 */
enum INVENT_PHOTO_CHECK {
    INVENT_PHOTO_CHECK_NETA    = 0, /**< Idea or scoop the photo shows. */
    INVENT_PHOTO_CHECK_NPC     = 2, /**< Townsperson the photo shows. */
    INVENT_PHOTO_CHECK_MONSTER = 3  /**< Monster the photo shows. */
};

// clang-format on

// clang-format off

/**
 *
 * Sizes of the invention menu's fixed tables.
 *
 */
enum INVENT_TABLE_SIZE {
    INVENT_PHOTO_NUM       = 30, /**< Photos the player can carry. */
    INVENT_ALBUM_PHOTO_NUM = 50, /**< Photos the memory card album holds. */
    INVENT_SCOOP_TABLE_NUM = 53, /**< Rows of the scoop table. */
};

// clang-format on

// clang-format off

/**
 *
 * Number ranges of the ideas and scoops held in neta_id fields.
 *
 */
enum INVENT_NETA_ID {
    INVENT_NETA_ID_SCOOP     = 1000,  /**< First scoop number; smaller positive numbers are ideas. */
    INVENT_NETA_ID_SCOOP_END = 10000, /**< One past the last scoop number. */
    INVENT_NETA_ID_DUMMY     = 30000, /**< Placeholder entry of the picture name file, which is dropped on loading. */
};

// clang-format on

// clang-format off

/**
 *
 * Keys PictureSeiton sorts the photos by, as pict_seiton_case holds them.
 *
 */
enum INVENT_PHOTO_SORT {
    INVENT_PHOTO_SORT_NETA    = 0, /**< By the idea or scoop shown. */
    INVENT_PHOTO_SORT_MAP     = 1, /**< By the map the photo was taken on. */
    INVENT_PHOTO_SORT_NPC     = 2, /**< By the townsperson shown. */
    INVENT_PHOTO_SORT_MONSTER = 3, /**< By the monster shown. */
    INVENT_PHOTO_SORT_NUM     = 4, /**< Number of sort keys; the key cycles back to the first. */
};

// clang-format on

// clang-format off

/**
 *
 * Picture numbers drawn by PictureDraw, as the menu form parts hold them in etc_info.
 *
 */
enum INVENT_PICTURE_NO {
    INVENT_PICTURE_ALBUM = 50,   /**< Picture number of the first album photo; lower numbers are carried photos. */
    INVENT_PICTURE_MEMO  = 1000, /**< Picture number of the idea notebook icon. */
};

// clang-format on

// clang-format off

/**
 *
 * Where an idea on the idea board was taken from, as neta_select_type holds it.
 *
 */
enum INVENT_NETA_SOURCE {
    INVENT_NETA_SOURCE_NONE  = -1, /**< The slot holds no idea. */
    INVENT_NETA_SOURCE_PHOTO = 0,  /**< A carried photo. */
    INVENT_NETA_SOURCE_MEMO  = 1,  /**< A line of the idea notebook. */
};

// clang-format on

// clang-format off

/**
 *
 * State of an idea board slot, as neta_select_state holds it.
 *
 */
enum INVENT_NETA_SLOT_STATE {
    INVENT_NETA_SLOT_EMPTY     = -1, /**< Nothing is shown in the slot. */
    INVENT_NETA_SLOT_RETURNING = 0,  /**< The idea was taken off and moves back to its photo or notebook line. */
    INVENT_NETA_SLOT_PLACED    = 1,  /**< The idea sits on the board's selection circle. */
};

// clang-format on

// clang-format off

/**
 *
 * Stages of loading the menu characters, as chara_load_step holds them.
 *
 */
enum INVENT_CHARA_LOAD_STEP {
    INVENT_CHARA_LOAD_OFF   = -1, /**< No character is loaded or shown. */
    INVENT_CHARA_LOAD_START = 0,  /**< Starts loading the characters. */
    INVENT_CHARA_LOAD_WAIT  = 1,  /**< Waits for the loads, then builds the characters. */
    INVENT_CHARA_LOAD_READY = 2,  /**< The characters are built and animated each frame. */
};

// clang-format on

// clang-format off

/**
 *
 * Colour fades of the invention flash, as gradation_mode holds them.
 *
 */
enum INVENT_GRADATION {
    INVENT_GRADATION_OFF   = 0, /**< The flash strips are hidden. */
    INVENT_GRADATION_GROW  = 1, /**< The flash strips grow from the middle of the screen. */
    INVENT_GRADATION_ON    = 2, /**< The flash strips are shown at full strength. */
    INVENT_GRADATION_COLOR = 3, /**< The flash strips fade to the colours of the result. */
};

// clang-format on

// clang-format off

/**
 *
 * Steps of thinking up an invention, as step holds them while IsCreateObject runs.
 *
 */
enum INVENT_CREATE_STEP {
    INVENT_CREATE_STEP_ASK        = 0, /**< Asking whether to think up an invention. */
    INVENT_CREATE_STEP_WAIT_START = 1, /**< Thinking until the wait and the first loads are over. */
    INVENT_CREATE_STEP_SHOW_READY = 2, /**< Waiting for the thinking motion to end before revealing the result. */
    INVENT_CREATE_STEP_SHOW       = 3, /**< Showing the result until a button is pressed. */
    INVENT_CREATE_STEP_AFTER      = 4, /**< Showing that the invention was already made until a button is pressed. */
};

// clang-format on

// clang-format off

/**
 *
 * Stages of loading and playing the invention result, as create_load_state holds them.
 *
 */
enum INVENT_CREATE_LOAD {
    INVENT_CREATE_LOAD_STOPPED     = -2, /**< Nothing is loaded or played. */
    INVENT_CREATE_LOAD_SOUND_MSG   = -1, /**< Waits for the thinking sound to load, then plays it. */
    INVENT_CREATE_LOAD_MODEL       = 0,  /**< Starts loading the menu character's result model and the effect pack. */
    INVENT_CREATE_LOAD_MODEL_DONE  = 1,  /**< Builds the result model and effect, and starts loading the invented item's model. */
    INVENT_CREATE_LOAD_ITEM_MODEL  = 2,  /**< Builds the invented item's model. */
    INVENT_CREATE_LOAD_SOUND_BANK  = 3,  /**< Starts loading the result sound bank. */
    INVENT_CREATE_LOAD_SOUND_PORT  = 4,  /**< Opens the menu sound port. */
    INVENT_CREATE_LOAD_JINGLE_OPEN = 5,  /**< Counts down, opening and then playing the result jingle. */
    INVENT_CREATE_LOAD_JINGLE_PLAY = 6,  /**< Waits for the jingle to end and closes its stream. */
    INVENT_CREATE_LOAD_DONE        = 7,  /**< Everything is loaded and played. */
};

// clang-format on

// clang-format off

/**
 *
 * Messages that announce the result of thinking up an invention.
 *
 */
enum INVENT_CREATE_MSG {
    INVENT_CREATE_MSG_CREATED       = 0x25F, /**< A new invention was thought up. */
    INVENT_CREATE_MSG_NOTHING       = 0x260, /**< The ideas make nothing. */
    INVENT_CREATE_MSG_PARTIAL_MATCH = 0x265, /**< Two of the ideas match a recipe, hinting at the third. */
};

// clang-format on

// clang-format off

/**
 *
 * Steps of building an invention, as step holds them while IsMakeObject runs.
 *
 */
enum INVENT_MAKE_STEP {
    INVENT_MAKE_STEP_SELECT     = 0,  /**< Choosing how many to build. */
    INVENT_MAKE_STEP_EFFECT     = 1,  /**< Playing the building effect, then adding the items. */
    INVENT_MAKE_STEP_RESULT     = 2,  /**< Showing the items built until a button is pressed. */
    INVENT_MAKE_STEP_ERROR      = 3,  /**< Showing why nothing can be built until a button is pressed. */
    INVENT_MAKE_STEP_LOAD_SOUND = 10, /**< Waiting for the building sound to load. */
};

// clang-format on

// clang-format off

/**
 *
 * Steps of learning the ideas of the carried photos, as step holds them while PhotoNetaEnter runs.
 *
 */
enum INVENT_NETA_ENTER_STEP {
    INVENT_NETA_ENTER_ASK        = 0,  /**< Asking whether to learn the new ideas. */
    INVENT_NETA_ENTER_EFFECT     = 1,  /**< Playing the star effect over the photos. */
    INVENT_NETA_ENTER_LEARNT     = 2,  /**< Showing the ideas learnt until a button is pressed. */
    INVENT_NETA_ENTER_ASK_DELETE = 3,  /**< Asking whether to delete the photos whose ideas were learnt. */
    INVENT_NETA_ENTER_DELETED    = 4,  /**< Showing that the photos were deleted until a button is pressed. */
    INVENT_NETA_ENTER_NOTHING    = 10, /**< Showing that no photo has a new idea until a button is pressed. */
};

// clang-format on

// clang-format off

/**
 *
 * Whether the album memory card access loads or saves the album, as album_save_mode holds it.
 *
 */
enum INVENT_ALBUM_SAVE_MODE {
    INVENT_ALBUM_LOAD = 0, /**< The album is loaded from the card. */
    INVENT_ALBUM_SAVE = 1, /**< The album is saved to the card. */
};

// clang-format on

// clang-format off

/**
 *
 * Steps of reading or writing the album on the memory card, as step holds them while IsAccessAlbum runs.
 *
 */
enum INVENT_ALBUM_STEP {
    INVENT_ALBUM_STEP_SLOT_SELECT       = 0,   /**< Choosing the slot to load the album from. */
    INVENT_ALBUM_STEP_ALLOCATE          = 1,   /**< Allocating the album and the card manager, then searching the card. */
    INVENT_ALBUM_STEP_SEARCH            = 2,   /**< Waiting for the card search, then choosing to load, save or format. */
    INVENT_ALBUM_STEP_CHECK_ALBUM       = 3,   /**< Waiting for the check for an album on the card. */
    INVENT_ALBUM_STEP_LOAD              = 5,   /**< Loading the album, showing its progress. */
    INVENT_ALBUM_STEP_LOADED            = 6,   /**< Showing the load result until a button is pressed. */
    INVENT_ALBUM_STEP_LOAD_ERROR        = 100, /**< Showing that the card is full or failed until a button is pressed. */
    INVENT_ALBUM_STEP_LOAD_RETRY        = 110, /**< Showing a missing card or a read error, then choosing a slot again. */
    INVENT_ALBUM_STEP_ASK_SAVE          = 200, /**< Asking whether to save the album. */
    INVENT_ALBUM_STEP_SAVE_SLOT_SELECT  = 201, /**< Choosing the slot to save the album to. */
    INVENT_ALBUM_STEP_SAVE_SEARCH       = 202, /**< Waiting for the card search before saving. */
    INVENT_ALBUM_STEP_SAVE_CHECK_ALBUM  = 203, /**< Waiting for the check for an album before saving. */
    INVENT_ALBUM_STEP_SAVE              = 205, /**< Saving the album, showing its progress. */
    INVENT_ALBUM_STEP_SAVED             = 206, /**< Showing that the album was saved until a button is pressed. */
    INVENT_ALBUM_STEP_ASK_LEAVE         = 220, /**< Asking whether to leave without saving. */
    INVENT_ALBUM_STEP_ASK_NEW_ALBUM     = 230, /**< Asking whether to create a new album on the card. */
    INVENT_ALBUM_STEP_MAKE_DIR_SEARCH   = 231, /**< Waiting for the card search before creating the album directory. */
    INVENT_ALBUM_STEP_MAKE_DIR          = 232, /**< Creating the album directory, showing its progress. */
    INVENT_ALBUM_STEP_ASK_RECOVER       = 240, /**< Asking whether to take the chosen album photos back. */
    INVENT_ALBUM_STEP_RECOVER_NO_SPACE  = 241, /**< Showing that too few photo slots are free until a button is pressed. */
    INVENT_ALBUM_STEP_CANCEL_NOTICE     = 250, /**< Waiting for a button, then cancelling. */
    INVENT_ALBUM_STEP_SAVE_ERROR        = 300, /**< Showing that saving failed until a button is pressed. */
    INVENT_ALBUM_STEP_ASK_LEAVE_FAILED  = 301, /**< Asking whether to leave after saving failed. */
    INVENT_ALBUM_STEP_ASK_FORMAT        = 500, /**< Asking whether to format the card. */
    INVENT_ALBUM_STEP_FORMAT_SEARCH     = 501, /**< Waiting for the card search before formatting. */
    INVENT_ALBUM_STEP_FORMAT            = 502, /**< Formatting the card. */
    INVENT_ALBUM_STEP_FORMATTED         = 503, /**< Showing the format result until a button is pressed. */
};

// clang-format on

// clang-format off

/**
 *
 * Memory card work that IsAccessAlbum starts at the end of a frame.
 *
 */
enum INVENT_ALBUM_ACCESS {
    INVENT_ALBUM_ACCESS_NONE      = -2, /**< Nothing is started. */
    INVENT_ALBUM_ACCESS_NEW_ALBUM = -1, /**< Searches the card before creating a new album. */
    INVENT_ALBUM_ACCESS_MAKE_DIR  = 0,  /**< Creates the album directory. */
    INVENT_ALBUM_ACCESS_SAVE_NEW  = 1,  /**< Saves the album into the directory just created. */
    INVENT_ALBUM_ACCESS_SAVE      = 2,  /**< Saves the album over the existing one. */
    INVENT_ALBUM_ACCESS_SAVED     = 3,  /**< Reports the result of saving. */
};

// clang-format on

// clang-format off

/**
 *
 * Outcomes of loading the album that IsAccessAlbum reports at the end of a frame.
 *
 */
enum INVENT_ALBUM_LOAD_RESULT {
    INVENT_ALBUM_LOAD_RETRY    = -1, /**< Returns to choosing a slot. */
    INVENT_ALBUM_LOAD_NONE     = 0,  /**< Nothing to report. */
    INVENT_ALBUM_LOAD_DONE     = 1,  /**< The album was loaded. */
    INVENT_ALBUM_LOAD_NO_ALBUM = 2,  /**< There is no album; an empty one is shown. */
    INVENT_ALBUM_LOAD_OTHER    = 3,  /**< Reported with the slot number (LOADEND3). */
};

// clang-format on

// clang-format off

/**
 *
 * Commands that MenuInventPushKey derives from the buttons pressed on a page of the menu.
 *
 */
enum INVENT_KEY_COMMAND {
    INVENT_KEY_COMMAND_IGNORE       = -1,  /**< The button does nothing on this page. */
    INVENT_KEY_COMMAND_NONE         = 0,   /**< No button was pressed. */
    INVENT_KEY_COMMAND_REJECT       = 5,   /**< The button is refused with the cancel sound. */
    INVENT_KEY_COMMAND_ITEM_COMMAND = 10,  /**< Opens the command window of the carried item under the cursor. */
    INVENT_KEY_COMMAND_SWAP_ITEM    = 20,  /**< Picks up or swaps the carried item under the cursor. */
    INVENT_KEY_COMMAND_GET_ITEM_ALL = 30,  /**< Takes everything out of the item under the cursor. */
    INVENT_KEY_COMMAND_SORT_PHOTOS  = 40,  /**< Sorts the photos of the current page. */
    INVENT_KEY_COMMAND_UNUSED       = 50,  /**< Does nothing. */
    INVENT_KEY_COMMAND_RETURN_HELD  = 52,  /**< Puts the held item back where it came from. */
    INVENT_KEY_COMMAND_LEAVE        = 54,  /**< Puts the held item back, or leaves the menu when none is held. */
    INVENT_KEY_COMMAND_SET_IDEA     = 60,  /**< Places the photo or notebook idea under the cursor on the idea board. */
    INVENT_KEY_COMMAND_REMOVE_IDEA  = 65,  /**< Takes the last idea off the board, or leaves the page when the board is empty. */
    INVENT_KEY_COMMAND_BACK         = 66,  /**< Takes the last idea off the board, or returns to the previous page when the board is empty. */
    INVENT_KEY_COMMAND_THINK        = 70,  /**< Thinks up an invention from the ideas on the board. */
    INVENT_KEY_COMMAND_MAKE         = 80,  /**< Asks how many of the invention under the cursor to build. */
    INVENT_KEY_COMMAND_EXTEND       = 90,  /**< Opens the command window of the photo under the cursor. */
    INVENT_KEY_COMMAND_LEARN_IDEAS  = 91,  /**< Learns the ideas shown by the carried photos. */
    INVENT_KEY_COMMAND_OPEN_MEMO    = 100, /**< Opens the idea notebook. */
    INVENT_KEY_COMMAND_CLOSE_MEMO   = 105, /**< Closes the idea notebook. */
    INVENT_KEY_COMMAND_SAVE_ALBUM   = 110, /**< Saves the album to the memory card. */
};

// clang-format on

/**
 *
 * Row of the scoop table: a scoop, the event flag that reveals it and its text.
 *
 */
struct SCOOP_DATA {
    short scoop_id; /**< Idea number of the scoop, from INVENT_NETA_ID_SCOOP. */
    short flag_no;  /**< Menu bit flag whose setting makes the scoop known. */
    s8    info_no;  /**< Index of the scoop's record in CScoopDataManager. */
    u8    unk_5[3];
    char *text; /**< Description of the scoop, read from the scoop text file. */
    int   unk_c;
    int   unk_10;
};

STATIC_ASSERT(sizeof(SCOOP_DATA) == 0x14);

/**
 *
 * Name of a photographed idea, read from the picture name file.
 *
 */
struct PIC_NAME_INFO {
    u16   neta_id;  /**< Idea the name belongs to. */
    short sort_key; /**< Third value of the picture name entry, stored but not read. */
    char *name;     /**< Name of the idea. */
};

STATIC_ASSERT(sizeof(PIC_NAME_INFO) == 0x8);

/**
 *
 * Material an invention consumes when it is built.
 *
 */
struct INVENT_MATERIAL {
    short item_id; /**< Item consumed. */
    u8    num;     /**< Number of the item consumed per invention built. */
    u8    unk_3;
};

STATIC_ASSERT(sizeof(INVENT_MATERIAL) == 0x4);

/**
 *
 * Materials of an invention recipe and their number.
 *
 */
struct INVENT_MATERIAL_LIST {
    INVENT_MATERIAL *material; /**< Materials consumed in building the invention. */
    short            num;      /**< Number of materials in the recipe. */
    u8               unk_6[2];
};

STATIC_ASSERT(sizeof(INVENT_MATERIAL_LIST) == 0x8);

/**
 *
 * Materials required to make an invented item.
 *
 */
struct MakeItemNeeds {
    /**
     *
     * One material and the quantity required.
     *
     */
    struct Need {
        int item_id; /**< Required item. */
        int amount;  /**< Number required. */
    };

    int  num;     /**< Number of entries in need. */
    Need need[4]; /**< Materials required. */
};

STATIC_ASSERT(sizeof(MakeItemNeeds) == 0x24);

/**
 *
 * One invention recipe and the material list used to build it.
 *
 */
struct INVENT_DATA_INFO {
    short item_id;    /**< Item the invention produces, or -1 for an unset row. */
    short neta_id[3]; /**< Ideas that combine into the invention. */

    INVENT_MATERIAL_LIST materials; /**< Materials consumed in building the invention. */

    short unk_10;
    u8    unk_12[2];
    float model_pos[3]; /**< Position the produced item's model is shown at when built. */
    float model_scale;  /**< Scale the produced item's model is shown at when built. */
};

STATIC_ASSERT(sizeof(INVENT_DATA_INFO) == 0x24);

/**
 *
 * Album kept on the memory card: fifty photos with their pixels.
 *
 */
class CDC2AlbumData {
public:
    char              photo_work[INVENT_ALBUM_PHOTO_NUM][0x2000]{}; /**< Pixels of the album's photos. */
    USER_PICTURE_INFO photo[INVENT_ALBUM_PHOTO_NUM]{};              /**< Photos of the album. */
    u8                unk_644b0[0x800]{};

    /**
     *
     * Creates an empty album.
     *
     */
    CDC2AlbumData() { Initialize(); }

    /**
     *
     * Clears the album and points each photo at its pixels.
     *
     * @mangled Initialize__13CDC2AlbumDataFv
     * @address 0x1FFF00
     * @size 0x38
     */
    void Initialize();

    /**
     *
     * Points each photo at its pixels in photo_work.
     *
     * @mangled RelateAlbumPicData__13CDC2AlbumDataFv
     * @address 0x1FFF40
     * @size 0x70
     */
    void RelateAlbumPicData();

    /**
     *
     * Empties a photo slot of the album.
     *
     * @mangled DeletePhotoData__13CDC2AlbumDataFi
     * @address 0x1FFFB0
     * @size 0x3C
     */
    void DeletePhotoData(int index);

    /**
     *
     * Returns a photo slot of the album, or NULL for an index out of range.
     *
     * @mangled GetAlbumPhotoInfo__13CDC2AlbumDataFi
     * @address 0x1FFFF0
     * @size 0x40
     */
    USER_PICTURE_INFO *GetAlbumPhotoInfo(int slot);
};

STATIC_ASSERT(sizeof(CDC2AlbumData) == 0x64CB0);

/**
 *
 * Invention recipes read from the invention list file.
 *
 */
class CInventDataManage {
public:
    short             num;   /**< Number of recipes. */
    INVENT_DATA_INFO *table; /**< Recipes. */

    /**
     *
     * Empties the recipe list.
     *
     */
    void Clear() {
        num = 0;
        table = nullptr;
    }

    /**
     *
     * Returns the recipe producing an item, or NULL when there is none.
     *
     * @mangled GetInventDataInfoByItemID__17CInventDataManageFi
     * @address 0x2013B0
     * @size 0x54
     */
    INVENT_DATA_INFO *GetInventDataInfoByItemID(int item_id);

    /**
     *
     * Returns the item invented from three ideas, or -1 when they make nothing, flagging when two or more match.
     *
     * @mangled CheckInventEnable__17CInventDataManageFPiPi
     * @address 0x201410
     * @size 0x174
     */
    int CheckInventEnable(int *ids, int *combined);

    /**
     *
     * Stores the number of materials of an item's recipe followed by each material and the amount needed for a count.
     *
     * @mangled HowMuchZairyouMakeItem__17CInventDataManageFiiPi
     * @address 0x201590
     * @size 0xD8
     */
    int HowMuchZairyouMakeItem(int item_id, int count, int *needs);

    /**
     *
     * Removes from the player's items the materials used to build a count of an item.
     *
     * @mangled DeleteUserUsedItem__17CInventDataManageFii
     * @address 0x201670
     * @size 0xAC
     */
    int DeleteUserUsedItem(int item_id, int count);

    /**
     *
     * Returns non-zero when the player carries the materials to build a count of an item.
     *
     * @mangled CheckMakeItem__17CInventDataManageFiiP13CGameDataUsed
     * @address 0x201720
     * @size 0x8C
     */
    int CheckMakeItem(int item_id, int count, CGameDataUsed *item);

    /**
     *
     * Reads the recipes from an invention list script, returning non-zero when there was one.
     *
     * @mangled LoadAnalyzeInventFile__17CInventDataManageFPci
     * @address 0x201AC0
     * @size 0x80
     */
    int LoadAnalyzeInventFile(char *script, int size);
};

STATIC_ASSERT(sizeof(CInventDataManage) == 0x8);

/**
 *
 * Invention menu: the photo, album, idea board, invention card and item pages and the building of inventions.
 *
 */
class CMenuInvent : public CBaseMenuClass {
public:
    short                 photo_only;         /**< 1 when the menu was opened to show the photos alone. */
    short                 album_open;         /**< 1 while the memory-card album workflow is active. */
    int                   card_cursor;        /**< Invention card under the cursor. */
    int                   card_top;           /**< Invention card at the top of the list. */
    int                   item_cursor;        /**< Carried item under the cursor. */
    int                   item_top;           /**< Carried item at the top of the list. */
    int                   photo_cursor;       /**< Carried photo under the cursor. */
    int                   photo_top;          /**< Row of carried photos at the top of the board. */
    int                   album_cursor;       /**< Album photo under the cursor. */
    int                   album_top;          /**< Row of album photos at the top of the board. */
    int                   memo_cursor;        /**< Idea notebook line under the cursor. */
    int                   memo_top;           /**< Idea notebook line at the top of the list. */
    MENUFORM_MAKEBRD_INFO make_board{};       /**< Materials shown on the building board. */
    CGameDataUsed         create_item;        /**< Item shown for the invention card under the cursor. */
    MC_ICON_DATA          icon_data[3];       /**< Memory card icons of the album save. */
    u8                    card_scroll_dir;    /**< 1 when the card list last scrolled down, 0 when it last scrolled up; picks the list top drawn while scrolling. */
    u8                    album_scroll_reset; /**< Requests a reset of album scrolling. */
    u8                    unk_24e[2]{};
    float                 album_scroll_x; /**< Horizontal album scroll position. */
    float                 album_scroll_y; /**< Vertical album scroll position. */
    u8                    album_enable{}; /**< Non-zero when the player carries the album item. */
    u8                    unk_259[3]{};
    float                 photo_scroll;                     /**< Vertical scroll of the photo board. */
    float                 photo_bar;                        /**< Position of the photo board's scroll bar. */
    float                 photo_pos[INVENT_PHOTO_NUM][2]{}; /**< Position of each slot on the photo board. */
    u8                    memo_scroll_reset{};              /**< Requests a reset of notebook scrolling. */
    u8                    unk_355[3]{};
    float                 memo_scroll{}; /**< Vertical scroll of the idea notebook. */
    float                 memo_bar{};    /**< Position of the notebook scroll bar. */
    int                   blink_count;   /**< Frames elapsed in the cursor blink cycle. */
    u8                    unk_364[0xC]{};
    float                 neta_color[4]{};                      /**< Colour of the frame of a photo showing an idea. */
    float                 scoop_color[4]{};                     /**< Colour of the frame of a photo showing a scoop. */
    short                 neta_effect_time;                     /**< Steps elapsed after the idea star effect finishes. */
    short                 memo_sort_mode{};                     /**< Ordering selected for the idea notebook. */
    u_int                *create_sound_buffer;                  /**< Loaded sound data for the invention sequence. */
    mgCMemory             data_stack;                           /**< Memory the menu layout data is read into. */
    mgCTexture           *photo_tex[INVENT_PHOTO_NUM]{};        /**< Texture of each carried photo. */
    mgCTexture           *album_tex[INVENT_ALBUM_PHOTO_NUM]{};  /**< Texture of each album photo. */
    s8                    album_flag[INVENT_ALBUM_PHOTO_NUM]{}; /**< State of each album photo, -1 for an empty slot. */
    u8                    unk_53a[2]{};
    mgCMemory             chara_stack;             /**< Memory the menu characters are built in. */
    u8                   *create_model_file{};     /**< Loaded model data for the item being built. */
    u8                   *create_motion_file{};    /**< Loaded motion data for the item being built. */
    CActionChara         *create_chara;            /**< Model of the item being built. */
    void                 *load_sound_buffer{};     /**< Loaded sound data for the menu character sequence. */
    INVENT_MATERIAL_LIST *make_material{};         /**< Materials of the recipe being built. */
    short                 create_success;          /**< Non-zero when thinking up the invention succeeded; indexes the result's model, sound and colour tables. */
    short                 create_item_id;          /**< Item being built. */
    int                   create_partial_match;    /**< Non-zero when the selected ideas match two parts of a recipe. */
    int                   create_photo_neta[3]{};  /**< Idea identifiers associated with the selected photos. */
    int                   create_missing_slot;     /**< Slot of the idea missing from a partial recipe match. */
    char                  create_photo_name[32]{}; /**< Name displayed for the selected invention photo. */
    s8                    blink_time;              /**< Step counter that alternates the missing idea highlight. */
    u8                    unk_5b9[3]{};
    int                   neta_circle_snap;       /**< Snap state of the idea board selection circle. */
    float                 neta_flash_angle;       /**< Angle of the idea flash effect. */
    u8                    new_neta_photo[0x20]{}; /**< Non-zero for each carried photo whose idea the idea board confirmation teaches. */
    float                 create_spin_angle{};    /**< Rotation angle of the newly created item model. */
    float                 create_scale{};         /**< Scale of the model of the item being built. */
    float                 create_wobble_amp{};    /**< Amplitude of the created item model's scale wobble. */
    float                 create_wobble_phase{};  /**< Phase of the created item model's scale wobble. */
    u8                    create_show_phase;      /**< Stage of the created item model's reveal animation. */
    u8                    unk_5f5[3]{};
    float                 create_scale_in;     /**< Scale reached during the created item model's reveal. */
    s8                    create_load_state{}; /**< Stage of loading and playing the invention result, an INVENT_CREATE_LOAD. */
    u8                    unk_5fd[3]{};
    int                   create_timer{};     /**< Countdown for opening and playing the invention jingle. */
    short                 jingle_state{};     /**< Non-zero while the invention jingle plays during the result display. */
    short                 jingle_pending{};   /**< Non-zero until the result message appears during the jingle. */
    short                 jingle_time{};      /**< Steps elapsed since the invention jingle began. */
    short                 create_wait_time{}; /**< Steps remaining before the invention reveal can begin. */
    short                 neta_select_num;    /**< Number of ideas placed on the idea board. */
    u8                    unk_60e[2]{};
    int                   neta_select_index[3]{}; /**< Photo slot or notebook line of each idea on the board, or -1. */
    s8                    neta_select_type[3]{};  /**< Source of each idea on the board, an INVENT_NETA_SOURCE. */
    s8                    neta_select_state[3]{}; /**< State of each idea board slot, an INVENT_NETA_SLOT_STATE. */
    s8                    neta_flash[3]{};        /**< Non-zero for each idea board slot whose form flashes. */
    u8                    unk_625[3]{};
    float                 neta_circle_radius; /**< Radius of the idea board selection circle. */
    float                 neta_circle_angle;  /**< Angle of the idea board selection circle. */
    dc2::io::FileRead     chara_read_info;    /**< Background read of the extra character data. */
    s8                    chara_load_step;    /**< Stage of loading the menu characters, an INVENT_CHARA_LOAD_STEP. */
    u8                    unk_635[3]{};
    CActionChara         *sub_chara;     /**< Character attached to the menu character. */
    CActionChara         *create_effect; /**< Effect character shown during item creation. */
    s8                    unk_640{};
    u8                    unk_641{};
    short                 unk_642{};
    u8                    unk_644[4]{};
    float                 unk_648{};
    s8                    arrow_count; /**< Animation frame of the selection arrow. */
    u8                    unk_64d[3]{};
    float                 effect_sway;       /**< Horizontal sway of the creation effect. */
    float                 effect_bob;        /**< Vertical bob of the creation effect. */
    float                 effect_bob_angle;  /**< Phase of the creation effect bob. */
    int                   effect_bob_count;  /**< Cycles of the creation effect bob. */
    float                 effect_sway_angle; /**< Phase of the creation effect sway. */
    u8                    unk_664[0xC]{};
    float                 chara_pos[4]{};      /**< Position of the displayed character. */
    float                 chara_make_pos[4]{}; /**< Target position of the character during creation. */
    int                   line_pos[50][2]{};   /**< Points of the random line drawn by the menu forms. */
    u8                    unk_820[0x528]{};
    mgCMemory             item_model_memory;                      /**< Memory used to load the newly created item model. */
    int                   download_base;                          /**< Bytes transferred before the current memory card operation began. */
    int                   album_save_mode{};                      /**< Whether the album memory card access loads or saves, an INVENT_ALBUM_SAVE_MODE. */
    float                 neta_effect_pos[INVENT_PHOTO_NUM][2]{}; /**< Screen position of each new idea's star effect. */
    short                 neta_effect_alpha[INVENT_PHOTO_NUM]{};  /**< Alpha of each new idea's star effect. */
    int                   gradation_mode;                         /**< Colour fade of the invention flash being run, an INVENT_GRADATION. */
    int                   gradation_height;                       /**< Height reached by the invention flash colour gradient. */
    u8                    card_scroll_reset{};                    /**< Requests a reset of invention card scrolling. */
    u8                    photo_scroll_reset{};                   /**< Requests a reset of photo board scrolling. */
    u8                    cursor_snap{};                          /**< Requests an immediate move to the cursor target position. */
    u8                    unk_eb7{};
    CMenuPosDataForm     *bg_form{};              /**< Background form. */
    CMenuPosDataForm     *itembrd_form{};         /**< Item board form. */
    CMenuPosDataForm     *neta_board_form{};      /**< Idea board form. */
    MENUFORMPARTS_TYPE   *neta_board_bar[3]{};    /**< Scroll bar parts of the idea board. */
    MENUFORMPARTS_TYPE   *neta_board_arrow{};     /**< Up arrow part of the idea board. */
    MENUFORMPARTS_TYPE   *neta_memo_arrow{};      /**< Notebook arrow part of the idea board. */
    CMenuPosDataForm     *makebrd_form{};         /**< Building board form. */
    CMenuPosDataForm     *card_list_title_form{}; /**< Invention card list title form. */
    CMenuPosDataForm     *card_list_form{};       /**< Invention card list form. */
    CMenuPosDataForm     *album_sw_form{};        /**< Album switch form. */
    CMenuPosDataForm     *album_big_form{};       /**< Enlarged album photo form. */
    CMenuPosDataForm     *neta_memo_form{};       /**< Idea notebook form. */
    CMenuPosDataForm     *neta_form[3]{};         /**< Form of each idea slot on the idea board. */
    u8                    unk_efc[4]{};
    CMenuPosDataForm     *neta_name_form[3]{}; /**< Name form of each idea slot on the idea board. */
    u8                    unk_f0c[4]{};
    CMenuPosDataForm     *poly_chr_form[2]{};  /**< Forms the menu characters are drawn in. */
    CMenuPosDataForm     *invent_okeff_form{}; /**< Invention success effect form. */
    CMenuPosDataForm     *dload_form{};        /**< Loading form. */
    CMenuPosDataForm     *recbrd_form{};       /**< Camera record board form. */
    CMenuPosDataForm     *kakudai_pic_form{};  /**< Enlarged photo form. */
    MENUFORMPARTS_TYPE   *kakudai_pic{};       /**< Picture part of the enlarged photo form. */
    u8                    unk_f2c[4]{};

    /**
     *
     * Creates the menu page with empty boards and the default photo slot positions.
     *
     */
    CMenuInvent();

    /**
     *
     * Marks the album photos as empty, or, from the album, only those slots without a photo.
     *
     * @mangled InitPhotoNetaBoardToAlbum__11CMenuInventFi
     * @address 0x201EE0
     * @size 0xA8
     */
    void InitPhotoNetaBoardToAlbum(int source);

    /**
     *
     * Walks the album photo states without effect.
     *
     * @mangled CheckRecoverPhotoNum__11CMenuInventFv
     * @address 0x201F90
     * @size 0x38
     */
    int CheckRecoverPhotoNum();

    /**
     *
     * Looks up the menu's forms and form parts by name.
     *
     * @mangled AttachFormInfo__11CMenuInventFv
     * @address 0x201FD0
     * @size 0x2C4
     */
    void AttachFormInfo();

    /**
     *
     * Advances loading of the menu characters by one stage.
     *
     * @mangled LoadCharaCheck__11CMenuInventFv
     * @address 0x2022A0
     * @size 0x4D8
     */
    void LoadCharaCheck();

    /**
     *
     * Returns the photo under the cursor on the photo or album page, or NULL on another page.
     *
     * @mangled GetNowSelectedPictInfo__11CMenuInventFv
     * @address 0x202780
     * @size 0x68
     */
    USER_PICTURE_INFO *GetNowSelectedPictInfo();

    /**
     *
     * Returns the first photo of the current page's photos, storing their number, or NULL on another page.
     *
     * @mangled GetPhotoInfoFromMode__11CMenuInventFPi
     * @address 0x2027F0
     * @size 0x7C
     */
    USER_PICTURE_INFO *GetPhotoInfoFromMode(int *slot_count);

    /**
     *
     * Clears the idea board's slots, or re-shows the ideas placed on it.
     *
     * @mangled InitNetaCircle__11CMenuInventFi
     * @address 0x202870
     * @size 0xE4
     */
    void InitNetaCircle(int show);

    /**
     *
     * Places a photo or notebook idea in the next slot of the idea board.
     *
     * @mangled SetNetaCircle__11CMenuInventFii
     * @address 0x202960
     * @size 0x3A0
     */
    int SetNetaCircle(int type, int index);

    /**
     *
     * Takes the last idea off the idea board, returning its photo slot or notebook line, or -1 when the board is empty.
     *
     * @mangled CancelNetaCircle__11CMenuInventFi
     * @address 0x202D00
     * @size 0x124
     */
    int CancelNetaCircle(int mode);

    /**
     *
     * Returns the idea in a slot of the idea board, or 0 for an empty slot.
     *
     * @mangled GetNowSelectNetaID__11CMenuInventFi
     * @address 0x202E30
     * @size 0xAC
     */
    int GetNowSelectNetaID(int slot);

    /**
     *
     * Returns non-zero when a photo has already been placed on the idea board.
     *
     * @mangled SelectedNetaPhotoAlready__11CMenuInventFi
     * @address 0x202EE0
     * @size 0x48
     */
    int SelectedNetaPhotoAlready(int neta_id);

    /**
     *
     * Returns non-zero when a notebook line is empty or has already been placed on the idea board.
     *
     * @mangled SelectedNetaMemoListAlready__11CMenuInventFi
     * @address 0x202F30
     * @size 0x6C
     */
    int SelectedNetaMemoListAlready(int neta_id);

    /**
     *
     * Fills the camera record board with the photo count, ideas, scoops, experience and level.
     *
     * @mangled UpdataRecordBoard__11CMenuInventFv
     * @address 0x202FA0
     * @size 0x19C
     */
    void UpdataRecordBoard();

    /**
     *
     * Switches to a page of the menu, running the page's form scripts.
     *
     * @mangled PrepareNextMode__11CMenuInventFi
     * @address 0x203140
     * @size 0x208
     */
    void PrepareNextMode(int mode);

    /**
     *
     * Returns the item under the cursor on the card or item list, or NULL on another page.
     *
     * @mangled SearchNowPosItemExist__11CMenuInventFv
     * @address 0x203350
     * @size 0x94
     */
    CGameDataUsed *SearchNowPosItemExist();

    /**
     *
     * Runs the form script that swaps between the card list and item list layouts.
     *
     * @mangled CreateModeSwapForm__11CMenuInventFi
     * @address 0x2033F0
     * @size 0x38
     */
    void CreateModeSwapForm(int side);

    /**
     *
     * Starts a colour fade of the invention flash.
     *
     * @mangled GradationSet__11CMenuInventFi
     * @address 0x203430
     * @size 0x3BC
     */
    void GradationSet(int mode);

    /**
     *
     * Advances the colour fade of the invention flash by one frame.
     *
     * @mangled GradationStep__11CMenuInventFv
     * @address 0x2037F0
     * @size 0x2F4
     */
    void GradationStep();

    /**
     *
     * Finishes opening the menu.
     *
     * @mangled InitEnd__11CMenuInventFv
     * @address 0x203AF0
     * @size 0xB4
     */
    void InitEnd() override;

    /**
     *
     * Finishes closing the menu, saving the cursor positions.
     *
     * @mangled ExitEnd__11CMenuInventFv
     * @address 0x203BB0
     * @size 0x9C
     */
    void ExitEnd() override;

    /**
     *
     * Enters the menu's textures, layout and invention list from the menu pack file.
     *
     * @mangled EnterDataMenu__11CMenuInventFPUc
     * @address 0x203C50
     * @size 0x1B0
     */
    void EnterDataMenu(const dc2::io::FileRead &directory);

    /**
     *
     * Handles the result of an item command chosen in the menu.
     *
     * @mangled ItemCmdAfter__11CMenuInventFiP16ITEMCMD_RET_PARA
     * @address 0x203E00
     * @size 0x8C
     */
    int ItemCmdAfter(int command, ITEMCMD_RET_PARA *para) override;

    /**
     *
     * Runs one frame of building an invention: its model, sound and messages.
     *
     * @mangled IsCreateObject__11CMenuInventFii
     * @address 0x203E90
     * @size 0x1588
     */
    int IsCreateObject(int mode, int arg) override;

    /**
     *
     * Fills the building board with the materials of the item under the cursor.
     *
     * @mangled CalcMakeBrd__11CMenuInventFi
     * @address 0x205420
     * @size 0x1A4
     */
    void CalcMakeBrd(int message);

    /**
     *
     * Returns how many lines of the invention card list can be selected, at least five.
     *
     * @mangled EnableSelectMaxCardList__11CMenuInventFv
     * @address 0x2055D0
     * @size 0x30
     */
    int EnableSelectMaxCardList();

    /**
     *
     * Moves the cursor to the selected entry of the current page.
     *
     * @mangled CalcCursorPosition__11CMenuInventFv
     * @address 0x205600
     * @size 0x474
     */
    void CalcCursorPosition();

    /**
     *
     * Runs one frame of the make-item prompt.
     *
     * @mangled IsMakeObject__11CMenuInventFii
     * @address 0x205A80
     * @size 0x5A0
     */
    int IsMakeObject(int keys, int button) override;

    /**
     *
     * Updates the scroll positions and textures of the current page.
     *
     * @mangled CalcTex__11CMenuInventFv
     * @address 0x206020
     * @size 0x139C
     */
    void CalcTex();

    /**
     *
     * Opens the command window for the entry under the cursor.
     *
     * @mangled BootExtendCommand__11CMenuInventFv
     * @address 0x2073C0
     * @size 0x3AC
     */
    void BootExtendCommand();

    /**
     *
     * Runs one frame of a confirmation prompt opened from the command window.
     *
     * @mangled IsAskExtend__11CMenuInventFii
     * @address 0x207770
     * @size 0x83C
     */
    int IsAskExtend(int mode, int button) override;

    /**
     *
     * Learns the idea shown by a photo, playing the star effect over it.
     *
     * @mangled PhotoNetaEnter__11CMenuInventFii
     * @address 0x207FB0
     * @size 0x304
     */
    void PhotoNetaEnter(int index, int button);

    /**
     *
     * Runs one frame of reading or writing the album on the memory card.
     *
     * @mangled IsAccessAlbum__11CMenuInventFv
     * @address 0x2082D0
     * @size 0x13E8
     */
    void IsAccessAlbum();

    /**
     *
     * Stores the screen position of a slot of the photo board.
     *
     * @mangled GetNetaBoardCursorPosition__11CMenuInventFiPi
     * @address 0x2096C0
     * @size 0x94
     */
    void GetNetaBoardCursorPosition(int slot, int *pos);

    /**
     *
     * Stores the screen position of a visible line of the idea notebook.
     *
     * @mangled GetNetaMemoCursorPosition__11CMenuInventFiPi
     * @address 0x209760
     * @size 0x68
     */
    void GetNetaMemoCursorPosition(int slot, int *pos);

    /**
     *
     * Rebuilds the lines of the idea notebook from the ideas learnt.
     *
     * @mangled UpdataNetaMemoStr__11CMenuInventFv
     * @address 0x209900
     * @size 0x194
     */
    void UpdataNetaMemoStr();

    /**
     *
     * Moves to another page of the menu, carrying the cursor position across.
     *
     * @mangled NextDifferentMode__11CMenuInventFii
     * @address 0x20C000
     * @size 0x158
     */
    void NextDifferentMode(int next, int arg);
};

STATIC_ASSERT(sizeof(CMenuInvent) == 0xF30);

/**
 *
 * Returns the invention part of the save data, or NULL when there is no save data.
 *
 * @mangled GetInventUserDataPtr__Fv
 * @address 0x1FF8E0
 * @size 0x38
 */
CInventUserData *GetInventUserDataPtr();

/**
 *
 * Empties a photo slot.
 *
 * @mangled Init_USER_PICTURE_INFO__FP17USER_PICTURE_INFO
 * @address 0x1FF920
 * @size 0x30
 */
void Init_USER_PICTURE_INFO(USER_PICTURE_INFO *photo);

/**
 *
 * Copies what a photo shows, leaving the destination's pixels in place.
 *
 * @mangled Copy_USER_PICTURE_INFO__FP17USER_PICTURE_INFOP17USER_PICTURE_INFO
 * @address 0x1FF950
 * @size 0x58
 */
void Copy_USER_PICTURE_INFO(USER_PICTURE_INFO *src, USER_PICTURE_INFO *dst);

/**
 *
 * Sorts photos and their pixels by one of four keys, moving to the next key on each call.
 *
 * @mangled PictureSeiton__FP17USER_PICTURE_INFOPci
 * @address 0x1FF9B0
 * @size 0x358
 */
void PictureSeiton(USER_PICTURE_INFO *photos, char *work_base, int count);

/**
 *
 * Enters a 64x64 texture for each photo, pointed at the photo's pixels.
 *
 * @mangled AttachPictTex__FiPP10mgCTextureP17USER_PICTURE_INFOi
 * @address 0x1FFD10
 * @size 0x130
 */
void AttachPictTex(int block, mgCTexture **textures, USER_PICTURE_INFO *info, int count);

/**
 *
 * Stores the indices of the photos that show no idea, returning how many there are.
 *
 * @mangled CheckPhotoDataNoNeed__FP17USER_PICTURE_INFOiPi
 * @address 0x1FFE40
 * @size 0x58
 */
int CheckPhotoDataNoNeed(USER_PICTURE_INFO *photos, int count, int *unneeded);

/**
 *
 * Returns non-zero when the first character is active and has item 0x171 equipped, which lets photos be taken.
 *
 * @mangled IsTakePhoto__Fv
 * @address 0x1FFEA0
 * @size 0x54
 */
int IsTakePhoto();

/**
 *
 * Converts the invention cards of an older save layout into the current one.
 *
 * @mangled TranslateInventUserData__FP15CInventUserDataP15CInventUserData
 * @address 0x200960
 * @size 0xC0
 */
void TranslateInventUserData(CInventUserData *old_data, CInventUserData *new_data);

/**
 *
 * Returns the scoop table row of a scoop, or NULL when it is not in the table.
 *
 * @mangled GetScoopDataTable__Fi
 * @address 0x200A20
 * @size 0x4C
 */
SCOOP_DATA *GetScoopDataTable(int scoop_id);

/**
 *
 * Returns a scoop table row by index, or NULL for an index out of range.
 *
 * @mangled GetScoopDataTableIndex__Fi
 * @address 0x200A70
 * @size 0x3C
 */
SCOOP_DATA *GetScoopDataTableIndex(int index);

/**
 *
 * Clears the texts of every scoop table row.
 *
 * @mangled InitScoopString__Fv
 * @address 0x200AB0
 * @size 0xC8
 */
void InitScoopString();

/**
 *
 * Reads the scoop texts from a script, copying them into memory.
 *
 * @mangled AnalyzeScoopString__FP9mgCMemoryPci
 * @address 0x200BE0
 * @size 0x70
 */
void AnalyzeScoopString(mgCMemory *stack, char *script, int size);

/**
 *
 * Reads the names of the photographed ideas from the picture name file.
 *
 * @mangled LoadFilePictureName__Fv
 * @address 0x201070
 * @size 0x9C
 */
void LoadFilePictureName();

/**
 *
 * Returns the name of what a photo shows: its idea, townsperson, monster or map, or NULL for none.
 *
 * @mangled GetPhotoName__FP17USER_PICTURE_INFO
 * @address 0x201110
 * @size 0xE4
 */
char *GetPhotoName(USER_PICTURE_INFO *info);

/**
 *
 * Copies the name of an idea, returning non-zero when it has none.
 *
 * @mangled GetPhotoNameStr__FiPc
 * @address 0x201200
 * @size 0x50
 */
int GetPhotoNameStr(int neta_id, std::span<char> destination);

/**
 *
 * Returns the title of a photo, with the idea or scoop mark before an idea's name, or NULL for none.
 *
 * @mangled GetPhotoNameCheck__FP17USER_PICTURE_INFO
 * @address 0x201250
 * @size 0x9C
 */
char *GetPhotoNameCheck(USER_PICTURE_INFO *info);

/**
 *
 * Returns non-zero when the player has the three ideas of an item's recipe, from photos or the notebook.
 *
 * @mangled CheckInventItem__Fi
 * @address 0x201B40
 * @size 0x1A8
 */
int CheckInventItem(int item_id);

/**
 *
 * Stores the three ideas of an item's recipe, returning their number, or 0 when the item has no recipe.
 *
 * @mangled CheckItemTable__FiPi
 * @address 0x201CF0
 * @size 0xD0
 */
int CheckItemTable(int item_id, int *neta_ids);

/**
 *
 * Returns how many carried photos show an idea, townsperson or monster, as chosen by an INVENT_PHOTO_CHECK.
 *
 * @mangled CheckInventPhoto__Fii
 * @address 0x201DC0
 * @size 0x114
 */
int CheckInventPhoto(int id, int kind);

/**
 *
 * Draws the invention card shown while building an invention.
 *
 * @mangled MenuInventCreateCardDraw__FRiPf
 * @address 0x209BF0
 * @size 0x260
 */
void MenuInventCreateCardDraw(int &tex_block, float *pos);

/**
 *
 * Draws a photo in its frame, tinted by what it shows.
 *
 * @mangled PictureDraw__FP10mgCTextureP17USER_PICTURE_INFOfffiiii
 * @address 0x209E50
 * @size 0x43C
 */
void PictureDraw(mgCTexture *tex, USER_PICTURE_INFO *photo, float x, float y, float scale, int alpha, int red,
                 int blue, int green);

/**
 *
 * Draws one picture by number at a rectangle's corner: a carried photo (0 to 29), an album photo (50 to 99) or the invention memo (1000).
 *
 * @mangled PictureDraw__FRi9mgRect_f_ifPUc
 * @address 0x20A380
 * @size 0x174
 */
void PictureDraw(int &tex_block, mgRect<float> rect, int picture_no, float scale, unsigned char *rgba);

/**
 *
 * Draws the board of carried photos.
 *
 * @mangled MenuInventPictureBoardDraw__FPfRii
 * @address 0x20A500
 * @size 0x498
 */
void MenuInventPictureBoardDraw(float *pos, int &tex_block, int mode);

/**
 *
 * Draws the board of album photos.
 *
 * @mangled MenuInventAlbumPictureDraw__FPfRi
 * @address 0x20A9A0
 * @size 0x1F4
 */
void MenuInventAlbumPictureDraw(float *origin, int &loaded_tex);

/**
 *
 * Draws the idea notebook.
 *
 * @mangled MenuInventNetaMemoDraw__FPfRi
 * @address 0x20ABA0
 * @size 0x410
 */
void MenuInventNetaMemoDraw(float *origin, int &loaded_tex);

/**
 *
 * Opens the invention menu, building it and its characters in a menu memory.
 *
 * @mangled MenuInventInit__FP9mgCMemoryPii
 * @address 0x20AFB0
 * @size 0x1048
 */
int MenuInventInit(mgCMemory *memory, int *tex_block, int arg);

/**
 *
 * Runs one frame of the invention menu's input.
 *
 * @mangled MenuInventKey__Fv
 * @address 0x20DBE0
 * @size 0x824
 */
int MenuInventKey();

/**
 *
 * Draws one frame of the invention menu.
 *
 * @mangled MenuInventDraw__Fv
 * @address 0x20E410
 * @size 0x48
 */
void MenuInventDraw();

namespace dc2::menu {
/**
 * Constructs the owned invention controller and retires the previous controller.
 */
CMenuInvent &CreateInventionMenu();

/**
 * Releases the invention controller before its supporting menu arenas are reused.
 */
void ResetInventionMenu();
} // namespace dc2::menu
