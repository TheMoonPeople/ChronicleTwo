#pragma once

#include "common.h"

#include "memcard.hpp"
#include "menusys.hpp"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"

/**
 *
 * Icon files stored with a memory card save.
 *
 */
struct SaveIconSet {
    MC_ICON_DATA file[3]; /**< Save icon images. */
};

STATIC_ASSERT(sizeof(SaveIconSet) == 0x78);

/**
 * @file
 * Declares the manual menu, which plays the explanation movies and shows the
 * picture pages of the game's manual, the option menu, the save and load
 * menu with its memory card handling, and the mini-game save menu.
 */

class CMenuPosDataForm;
class mgCTexture;
struct MENUFORMPARTS_TYPE;

/**
 *
 * Number of option lines the option menu has room for.
 *
 */
#define OPTION_ITEM_MAX 20

/**
 *
 * Number of choice buttons on one option line.
 *
 */
#define OPTION_BUTTON_NUM 3

/**
 *
 * Steps of the manual menu, as CBaseMenuClass::key_arg_no holds them.
 *
 */
// clang-format off
enum ManualMenuStep {
    MANUAL_STEP_SELECT   = 0, /**< The player picks a manual entry from the list. */
    MANUAL_STEP_FADE_OUT = 1, /**< The list fades out, then the entry's movie or pictures load. */
    MANUAL_STEP_PLAY     = 2, /**< The movie plays or the picture pages are shown. */
    MANUAL_STEP_CLOSE    = 3, /**< The movie or pictures fade out. */
    MANUAL_STEP_END      = 4, /**< The menu's own data is put back and the list returns. */
};

// clang-format on

/**
 *
 * Steps of the file list page of the save menu, as CSaveMenuClass::phase holds them.
 *
 */
// clang-format off
enum SaveListPhase {
    SAVE_LIST_PHASE_SELECT       = 0,  /**< The player picks a file. */
    SAVE_LIST_PHASE_CONFIRM_SAVE = 1,  /**< The player is asked to save to the chosen file. */
    SAVE_LIST_PHASE_SAVING       = 2,  /**< The save is written. */
    SAVE_LIST_PHASE_SAVE_DONE    = 3,  /**< The save has finished. */
    SAVE_LIST_PHASE_NOTICE       = 6,  /**< A message is shown until a button is pushed. */
    SAVE_LIST_PHASE_UNK_7        = 7,  /**< The file list waits without changing state. */
    SAVE_LIST_PHASE_MAKING_DIR   = 10, /**< The directory for a new file is made. */
    SAVE_LIST_PHASE_CONFIRM_LOAD = 50, /**< The player is asked to load the chosen file. */
    SAVE_LIST_PHASE_LOADING      = 51, /**< The save is read. */
    SAVE_LIST_PHASE_LOAD_DONE    = 52, /**< The load has finished. */
    SAVE_LIST_PHASE_LOAD_NOTICE  = 60, /**< A message is shown until a button is pushed, then the load is asked again. */
};

// clang-format on

/**
 *
 * Steps of the format page of the save menu, as CSaveMenuClass::phase holds them.
 *
 */
// clang-format off
enum SaveFormatPhase {
    SAVE_FORMAT_PHASE_ASK        = 0,  /**< The player is asked to format the card. */
    SAVE_FORMAT_PHASE_FORMATTING = 10, /**< The card is formatted. */
    SAVE_FORMAT_PHASE_DONE       = 20, /**< The format has finished. */
};

// clang-format on

/**
 *
 * What the save menu was opened to do, as CSaveMenuClass::mode holds it.
 *
 */
// clang-format off
enum SaveMenuMode {
    SAVE_MENU_MODE_SAVE         = 0, /**< Save the game during play. */
    SAVE_MENU_MODE_LOAD         = 1, /**< Load a game from the title screen. */
    SAVE_MENU_MODE_GYORACE_LOAD = 2, /**< Load the fish of a saved game for the fish race. */
};

// clang-format on

/**
 *
 * Input stages of the save menu, as CBaseMenuClass::step holds them.
 *
 */
enum SaveMenuStep {
    SAVE_MENU_STEP_READY = 0,  /**< Waits for opening to finish, or accepts slot selection. */
    SAVE_MENU_STEP_NOTICE = 1, /**< Waits for a chapter-eight notice or an exit confirmation. */
};

/**
 *
 * Result the save menu reports through MenuArg.end_code after loading.
 *
 */
enum SaveMenuEndCode {
    SAVE_MENU_END_LOAD = 10, /**< The saved game or its fish data has been loaded. */
};

/**
 *
 * Whether saving creates a new file or overwrites an existing one.
 *
 */
enum SaveFileKind {
    SAVE_FILE_OVERWRITE = 0, /**< Writes over the selected save file. */
    SAVE_FILE_NEW = 1,       /**< Creates the selected save file and its directory. */
};

/**
 *
 * Pages of the save menu, as CSaveMenuClass::page holds them.
 *
 */
// clang-format off
enum SaveMenuPage {
    SAVE_MENU_PAGE_NONE        = -1, /**< No page change is pending. */
    SAVE_MENU_PAGE_SLOT_SELECT = 0, /**< The player picks a memory card slot. */
    SAVE_MENU_PAGE_FILE_LIST   = 1, /**< The player picks a file on the card, and the file is saved or loaded. */
    SAVE_MENU_PAGE_CARD_INFO   = 2, /**< The card in the chosen slot is checked. */
    SAVE_MENU_PAGE_FILE_READ   = 3, /**< The files on the card are read. */
    SAVE_MENU_PAGE_FORMAT      = 4, /**< The player is asked to format an unformatted card. */
    SAVE_MENU_PAGE_UNK_5       = 5,
    SAVE_MENU_PAGE_ERROR       = 6, /**< A card error or lack of space is reported. */
};

// clang-format on

/**
 *
 * Phases of the mini-game save menu, as SubGameSaveOrLoadPhase holds them.
 *
 */
// clang-format off
enum SubGameSavePhase {
    SUB_SAVE_SLOT_SELECT       = 0,     /**< The player picks a memory card slot. */
    SUB_SAVE_CARD_CHECK        = 1,     /**< The card in the chosen slot is read. */
    SUB_SAVE_CARD_READY        = 2,     /**< The bonus data file of the card is looked for. */
    SUB_SAVE_QUIT_ASK          = 10,    /**< The player is asked to leave the menu. */
    SUB_SAVE_QUIT_ASK_LOAD     = 11,    /**< The player is asked to leave the menu, with a note on loading. */
    SUB_SAVE_OVERWRITE_ASK     = 100,   /**< The player is asked to overwrite the file on the card. */
    SUB_SAVE_WRITING           = 101,   /**< The bonus data is written. */
    SUB_SAVE_WRITE_DONE        = 102,   /**< The write has finished. */
    SUB_SAVE_WRITE_FAILED      = 110,   /**< The write failed. */
    SUB_SAVE_WRITE_FAILED_FULL = 111,   /**< The write failed for lack of room. */
    SUB_SAVE_SPACE_ASK         = 150,   /**< The player is told how much room a new file needs and asked to go on. */
    SUB_SAVE_DIR_MAKING        = 151,   /**< The directory for the file is made. */
    SUB_SAVE_FORMAT_ASK        = 160,   /**< The player is asked to format the card. */
    SUB_SAVE_FORMATTING        = 161,   /**< The card is formatted. */
    SUB_SAVE_NO_DATA           = 165,   /**< The card holds no data to load. */
    SUB_SAVE_LOAD_ASK          = 200,   /**< The player is asked to load the file. */
    SUB_SAVE_LOADING           = 201,   /**< The file is read. */
    SUB_SAVE_LOAD_DONE         = 202,   /**< The read has finished. */
    SUB_SAVE_LOAD_MISSING      = 250,   /**< The player is told the file is missing and asked to go on. */
    SUB_SAVE_CARD_ERROR        = 1000,  /**< A card error is reported. */
};

// clang-format on

/**
 *
 * The manual menu: a list of explanations that each play a movie, or show a
 * few picture pages, once the event that unlocks them has been seen.
 *
 */
class CManualMenu : public CBaseMenuClass {
public:
    s32                select;      /**< Manual entry the cursor is on. */
    s32                top;         /**< First entry shown in the list. */
    CScene::BGM_STATUS bgm_status;  /**< Music that was playing when an entry was opened, played again afterwards. */
    s32                pict_mode;   /**< Non-zero when the open entry shows picture pages rather than a movie. */
    s32                pict_num;    /**< Number of picture pages of the open entry. */
    s32                pict_page;   /**< Picture page shown. */
    mgCMemory          movie_stack; /**< Memory the movie streams through. */
    float              list_y;      /**< Screen y of the list, moving towards its place. */
    s32                cursor_jump; /**< Non-zero to put the cursor at its place at once rather than moving it. */

    /**
     *
     * Creates a manual menu at the first entry with an empty movie buffer.
     *
     */
    CManualMenu() {
        select = 0;
        top = 0;
        list_y = 400.0f;
        cursor_jump = 0;
        pict_mode = 0;
        pict_num = 0;
        key_arg_no = 0;
        movie_stack.stSetBuffer(NULL, 0);
    }

    /**
     *
     * Steps the menu one frame: picks an entry, plays its movie or turns its
     * picture pages, and closes. Gives 1 once it has closed.
     *
     * @mangled KeyStep__11CManualMenuFv
     * @address 0x2C5020
     * @size 0xB20
     */
    int KeyStep();

    /**
     *
     * Places the entry list, its messages and its scroll bar on the screen.
     *
     * @mangled CalcTex__11CManualMenuFv
     * @address 0x2C5B40
     * @size 0x3D0
     */
    void CalcTex();

    /**
     *
     * Moves the menu cursor to the entry it is on.
     *
     * @mangled CalcCursorPosition__11CManualMenuFv
     * @address 0x2C5F10
     * @size 0xD0
     */
    void CalcCursorPosition();
};

STATIC_ASSERT(sizeof(CManualMenu) == 0x178);

/**
 *
 * The option menu: a list of settings that are each picked from a row of
 * buttons, edited in a copy of the game's options.
 *
 */
class CMenuOption : public CBaseMenuClass {
public:
    float               list_y;                                     /**< Screen y of the list, moving towards its place. */
    s32                 choice_num[OPTION_ITEM_MAX];                /**< Number of choices of each option. */
    MENUFORMPARTS_TYPE *button[OPTION_ITEM_MAX][OPTION_BUTTON_NUM]; /**< Buttons of each option's choices. */
    s32                *value[OPTION_ITEM_MAX];                     /**< Setting in config that each option changes, or NULL. */
    s32                 unk_2A4[OPTION_ITEM_MAX];
    SV_CONFIG_OPTION    config;        /**< Options being edited, given to the game when the menu closes. */
    SV_CONFIG_OPTION    config_backup; /**< Options as they were when the menu opened. */
    s32                 select;        /**< Option the cursor is on. */
    s32                 top;           /**< First option shown in the list. */
    s32                 choice;        /**< Choice the cursor is on. */
    s32                 cursor_jump;   /**< Non-zero to put the cursor at its place at once rather than moving it. */

    /**
     *
     * Creates the option menu with its choices cleared.
     *
     */
    CMenuOption() {
        for (int i = 0; i < OPTION_ITEM_MAX; i++) {
            choice_num[i] = 1;
            button[i][0] = NULL;
            button[i][1] = NULL;
            button[i][2] = NULL;
            value[i] = NULL;
            unk_2A4[i] = 0;
        }

        list_y = 400.0f;
        select = 0;
        top = 0;
        choice = 0;
    }

    /**
     *
     * Steps the menu one frame: moves the cursor, changes the options and
     * closes. Gives 1 once it has closed.
     *
     * @mangled KeyStep__11CMenuOptionFv
     * @address 0x2C5FE0
     * @size 0x640
     */
    int KeyStep();

    /**
     *
     * Places the option list, its messages and its scroll bar on the screen.
     *
     * @mangled CalcTex__11CMenuOptionFv
     * @address 0x2C6620
     * @size 0x450
     */
    void CalcTex();

    /**
     *
     * Dims every button of one option's row.
     *
     * @mangled DefaultButton__11CMenuOptionFPP18MENUFORMPARTS_TYPE
     * @address 0x2C6A70
     * @size 0x50
     */
    void DefaultButton(MENUFORMPARTS_TYPE **row);

    /**
     *
     * Lights one button, marking it as the option's choice.
     *
     * @mangled EnableButton__11CMenuOptionFP18MENUFORMPARTS_TYPE
     * @address 0x2C6AC0
     * @size 0x20
     */
    void EnableButton(MENUFORMPARTS_TYPE *button);

    /**
     *
     * Lights the button of each option's current choice.
     *
     * @mangled UpdateOptionForm__11CMenuOptionFv
     * @address 0x2C6AE0
     * @size 0x350
     */
    void UpdateOptionForm();
};

STATIC_ASSERT(sizeof(CMenuOption) == 0x384);

/**
 *
 * The save menu: picks a memory card slot and a file on it, and saves the
 * game to it or loads the game from it.
 *
 */
class CSaveMenuClass : public CBaseMenuClass {
public:
    u8                  first_step;     /**< Non-zero until the menu's first frame has opened the slot choice. */
    s32                 select;         /**< File the cursor is on. */
    s32                 top;            /**< First file shown in the list. */
    u8                  list_jump;      /**< Non-zero to put the list at its place at once rather than moving it. */
    s32                 slot;           /**< Memory card slot chosen, 0 or 1. */
    s32                 mode;           /**< What the menu was opened to do, a SaveMenuMode. */
    s32                 page;           /**< Page shown, a SaveMenuPage. */
    s32                 phase;          /**< Step within the page. */
    s32                 save_kind;      /**< Kind of file write, a SaveFileKind, as EnvSetSave takes it. */
    s32                 dl_base;        /**< Progress of the card access already shown on the progress bar. */
    s32                 need_kb;        /**< Space the save needs, in kilobytes, as shown to the player. */
    s32                 save_kb;        /**< Size of the save data, in kilobytes. */
    s32                 check_kb;       /**< Space the save needs, in kilobytes, compared with the card's free space. */
    s32                 card_ok;        /**< Whether a usable card was in the slot when it was last checked. */
    s32                 card_changed;   /**< 1 when the card was found removed or changed during the file list. */
    s32                 chapter8_start; /**< 1 when the game is at the start of chapter 8, which asks before saving. */
    s32                 save_count;     /**< Number of times the game was saved while the menu was open. */
    s32                 unk_154;
    CScene::BGM_STATUS  bgm_status;       /**< Music that was playing when the menu opened, played again when it closes. */
    mgCTexture         *dl_tex;           /**< Texture of the progress bar. */
    CMenuPosDataForm   *title_form;       /**< Form of the menu title. */
    CMenuPosDataForm   *slot_form[2];     /**< Forms of the two memory card slots. */
    CMenuPosDataForm   *cursor_form;      /**< Form of the cursor. */
    CMenuPosDataForm   *list_form;        /**< Form of the file list. */
    CMenuPosDataForm   *scrlbar_form;     /**< Form of the file list's scroll bar. */
    MENUFORMPARTS_TYPE *scrlbar_parts[3]; /**< Top, middle and bottom parts of the scroll bar. */
    s32                 scrlbar_pos[2];   /**< Screen x and y offset of the scroll bar. */

    /**
     *
     * Creates the save menu at its first step with empty card and form state.
     *
     */
    CSaveMenuClass() {
        first_step = 1;
        slot = 0;
        list_jump = 0;
        top = 0;
        select = 0;
        mode = 0;
        dl_base = 0;
        save_kind = 1;
        need_kb = 0;
        save_kb = 0;
        check_kb = 0;
        chapter8_start = 0;
        save_count = 0;
        unk_154 = 0;
        dl_tex = NULL;
        title_form = NULL;
        for (int i = 0; i < 2; i++) {
            slot_form[i] = NULL;
        }
        cursor_form = NULL;
        list_form = NULL;
        scrlbar_form = NULL;
        scrlbar_parts[0] = NULL;
        scrlbar_parts[1] = NULL;
        scrlbar_parts[2] = NULL;
        scrlbar_pos[0] = 0;
        scrlbar_pos[1] = 9;
        card_ok = 0;
        card_changed = 0;
    }

    /**
     *
     * Shows the progress message of a save or load at the middle of the
     * screen.
     *
     * @mangled SetDlInfoMsg__14CSaveMenuClassFii
     * @address 0x2C7570
     * @size 0xA0
     */
    void SetDlInfoMsg(int load, int show);

    /**
     *
     * Starts saving to the chosen file: asks the memory card manager to make
     * a new file (kind 1) or overwrite the file (kind 0), and shows the
     * progress bar.
     *
     * @mangled EnvSetSave__14CSaveMenuClassFi
     * @address 0x2C7610
     * @size 0x100
     */
    void EnvSetSave(int kind);

    /**
     *
     * Steps the menu one frame: steps the memory card manager, moves through
     * the slot choice, file list, format and error pages, and closes. Gives 1
     * once it has closed.
     *
     * @mangled KeyStep__14CSaveMenuClassFv
     * @address 0x2C7710
     * @size 0x1A64
     */
    int KeyStep();
};

STATIC_ASSERT(sizeof(CSaveMenuClass) == 0x1A4);

/**
 *
 * Makes the message that tells how to go back from the save menu.
 *
 * @mangled InitMenuReturnMsg__FP9mgCMemory
 * @address 0x2C4260
 * @size 0xE0
 */
void InitMenuReturnMsg(mgCMemory *stack);

/**
 *
 * Turns the message that tells how to go back on or off; it is shown only
 * outside Japanese and only once it has been made.
 *
 * @mangled SetMenuReturnMsgCtrl__Fi
 * @address 0x2C4340
 * @size 0x30
 */
void SetMenuReturnMsgCtrl(int show);

/**
 *
 * Draws the message that tells how to go back, while it is turned on.
 *
 * @mangled DrawMenuReturnMsg__Fv
 * @address 0x2C4370
 * @size 0x50
 */
void DrawMenuReturnMsg();

/**
 *
 * Gives 1 for the two manual entries that the bonus mode opens in a dungeon
 * even before their event has been seen.
 *
 * @mangled CheckOmakeVtuto__Fi
 * @address 0x2C43C0
 * @size 0x70
 */
int CheckOmakeVtuto(int entry);

/**
 *
 * Opens the manual menu: makes the menu, reads its textures and form data
 * and fills the entry list.
 *
 * @mangled MenuManualInit__FP9mgCMemoryPii
 * @address 0x2C4480
 * @size 0x510
 */
void MenuManualInit(mgCMemory *memory, int *tex_block, int open_type);

/**
 *
 * Steps the manual menu one frame. Gives 1 once it has closed.
 *
 * @mangled MenuManualKey__Fv
 * @address 0x2C4990
 * @size 0x10
 */
int MenuManualKey();

/**
 *
 * Draws the manual menu, its movie or its picture page, and puts the
 * game's data back once a movie has finished.
 *
 * @mangled MenuManualDraw__Fv
 * @address 0x2C49A0
 * @size 0x680
 */
void MenuManualDraw();

/**
 *
 * Opens the option menu: makes the menu, reads its textures and form data,
 * and copies the game's options for editing.
 *
 * @mangled MenuOptionInit__FP9mgCMemoryPii
 * @address 0x2C6E30
 * @size 0x5C0
 */
void MenuOptionInit(mgCMemory *memory, int *tex_block, int open_type);

/**
 *
 * Steps the option menu one frame. Gives 1 once it has closed.
 *
 * @mangled MenuOptionKey__Fv
 * @address 0x2C73F0
 * @size 0x10
 */
int MenuOptionKey();

/**
 *
 * Draws the option menu.
 *
 * @mangled MenuOptionDraw__Fv
 * @address 0x2C7400
 * @size 0x10
 */
void MenuOptionDraw();

/**
 *
 * Sizes and places the three parts of a list's scroll bar for the list's
 * length, the number of lines shown and the first line shown.
 *
 * @mangled LocalFunc_AdjustScrlBar__FPP18MENUFORMPARTS_TYPEPiPiiffi
 * @address 0x2C7410
 * @size 0x160
 */
void LocalFunc_AdjustScrlBar(MENUFORMPARTS_TYPE **parts, int *pos, int *size, int top, float line_num, float show_num, int jump);

/**
 *
 * Draws the save menu's file list: a panel for each file and the file's
 * place, chapter and play time.
 *
 * @mangled SaveFileListDraw__FRiPfi
 * @address 0x2C9180
 * @size 0x740
 */
void SaveFileListDraw(int &tex_block, float *pos, int alpha);

/**
 *
 * Gives the map number of one of the dungeons, or 0 for a number out of
 * range.
 *
 * @mangled GetDngMapNo__Fi
 * @address 0x2C9980
 * @size 0x50
 */
int GetDngMapNo(int dungeon);

/**
 *
 * Keeps the saved map information so that ResetMapInfo can put it back, and
 * when a dungeon is given, records the game as being in that dungeon.
 *
 * @mangled SaveMapInfo__Fi
 * @address 0x2C99D0
 * @size 0xC0
 */
void SaveMapInfo(int dungeon);

/**
 *
 * Puts back the map information that SaveMapInfo kept.
 *
 * @mangled ResetMapInfo__Fv
 * @address 0x2C9A90
 * @size 0x50
 */
void ResetMapInfo();

/**
 *
 * Opens the save menu: makes the menu and the memory card manager, reads
 * the menu's textures and form data and stops the music.
 *
 * @mangled MenuSaveInit__FP9mgCMemoryPii
 * @address 0x2C9AE0
 * @size 0x6A0
 */
void MenuSaveInit(mgCMemory *memory, int *tex_block, int mode);

/**
 *
 * Steps the save menu one frame. Gives 1 once it has closed.
 *
 * @mangled MenuSaveKey__Fv
 * @address 0x2CA180
 * @size 0x10
 */
int MenuSaveKey();

/**
 *
 * Draws the save menu.
 *
 * @mangled MenuSaveDraw__Fv
 * @address 0x2CA190
 * @size 0x2B0
 */
void MenuSaveDraw();

/**
 *
 * Opens the mini-game save menu, which saves or loads the mini-game data:
 * makes the memory card manager and the mini-game data and reads the
 * menu's textures.
 *
 * @mangled SubGameSaveInit__FP9mgCMemoryPii
 * @address 0x2CA450
 * @size 0x3E0
 */
void SubGameSaveInit(mgCMemory *memory, int *tex_block, int mode);

/**
 *
 * Steps the mini-game save menu one frame. Gives 1 once it has closed.
 *
 * @mangled SubGameSaveKey__Fv
 * @address 0x2CA830
 * @size 0xE50
 */
int SubGameSaveKey();

/**
 *
 * Draws the mini-game save menu.
 *
 * @mangled SubGameSaveDraw__Fv
 * @address 0x2CB680
 * @size 0xB0
 */
void SubGameSaveDraw();

/**
 *
 * Map information of the save data, kept by SaveMapInfo for ResetMapInfo.
 *
 * @mangled MenuMapInfoSave
 * @address 0x1F3D008
 * @size 0xC
 */
extern u8 MenuMapInfoSave[0xC];
