#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_camera.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the main menu: the arguments a game loop opens it with, the camera
 * and light set-up it draws with, the top menu that picks a sub-menu, and the
 * per-frame entry points that run whichever menu mode is active.
 */

/**
 * Identifies status flags displayed by the internal menu's debug panel.
 */
enum MENU_DEBUG_BIT_CTRL {
    MENU_DEBUG_BIT_CTRL_NO_MOVE = 0x01, /**< Displays the movement restriction. */
    MENU_DEBUG_BIT_CTRL_NO_GEORAMA = 0x02, /**< Displays the georama restriction. */
    MENU_DEBUG_BIT_CTRL_NO_FISHING = 0x04, /**< Displays the fishing restriction. */
    MENU_DEBUG_BIT_CTRL_ATRA_OFF = 0x08, /**< Displays the Atra OFF status. */
    MENU_DEBUG_BIT_CTRL_BOOT_TREEMAP = 0x10, /**< Displays the Boot Treemap status. */
};

class CDC2Mes;
class CFishAquarium;
class CMenuItemUse;
class CMenuKeyFunc;
class CMenuMoveItem;
class CMenuPosDataForm;
class CMenuSystemData;
class CSaveData;
class CSaveDataDungeon;
class CScene;
class CUserDataManager;
class ClsMes;
class mgCDrawPrim;
class mgCTexture;
struct DNG_BATTLE_AREA;
struct SV_CONFIG_OPTION;

/**
 *
 * Menu modes, as the mode the main menu runs and the index into its key and draw function tables.
 *
 */
// clang-format off
enum MenuModeID {
    MENU_MODE_MAIN_TOWN         = 0,  /**< Top menu opened in a town. */
    MENU_MODE_MAIN_DUNGEON      = 1,  /**< Top menu opened in a dungeon. */
    MENU_MODE_ITEM              = 2,  /**< Item menu. */
    MENU_MODE_GEORAMA           = 3,  /**< Georama menu. */
    MENU_MODE_CHARA_CHANGE      = 4,  /**< Party character change menu. */
    MENU_MODE_INVENT            = 5,  /**< Invention menu. */
    MENU_MODE_WORLD_MOVE        = 6,  /**< World map move menu. */
    MENU_MODE_OPTION            = 7,  /**< Option menu. */
    MENU_MODE_MANUAL            = 8,  /**< Manual menu. */
    MENU_MODE_MONSTER_BOX       = 10, /**< Monster box menu. */
    MENU_MODE_DNG_TREE_MAP      = 11, /**< Dungeon floor map menu. */
    MENU_MODE_SHOP              = 12, /**< Shop menu. */
    MENU_MODE_SAVE              = 13, /**< Save menu opened during play. */
    MENU_MODE_TITLE_SAVE        = 14, /**< Save menu opened from the title screen. */
    MENU_MODE_ITEM_SELECT       = 15, /**< Item choice that an event asks for. */
    MENU_MODE_INVENT_DIRECT     = 16, /**< Invention menu opened without the top menu. */
    MENU_MODE_CHAPTER           = 17, /**< Chapter title display. */
    MENU_MODE_AQUA              = 18, /**< Aquarium menu. */
    MENU_MODE_REMOVAL           = 19, /**< Georama removal menu. */
    MENU_MODE_NAME_REGIST       = 20, /**< Name entry. */
    MENU_MODE_GYORACE_FISH_SEL  = 21, /**< Fish choice for a fish race. */
    MENU_MODE_NPC_QUEST_VIEW    = 22, /**< Townsfolk request view. */
    MENU_MODE_COSTUME           = 23, /**< Costume menu. */
    MENU_MODE_MAIN_CHARA_BG     = 24, /**< Main character display. */
    MENU_MODE_GYORACE           = 25, /**< Fish race menu. */
    MENU_MODE_SPHIDA            = 26, /**< Spheda menu. */
    MENU_MODE_MONSTER_BOOK      = 27, /**< Monster book. */
    MENU_MODE_SUBGAME_SAVE      = 28, /**< Mini-game save menu. */
    MENU_MODE_SPHIDA_SCORE_VIEW = 29, /**< Spheda score view. */
    MENU_MODE_NUM               = 30, /**< Number of entries in the key and draw function tables. */
};
// clang-format on

/**
 *
 * What a game loop asks the main menu to open, as MENU_INIT_ARG::open_type holds it.
 *
 */
// clang-format off
enum MenuOpenType {
    MENU_OPEN_MAIN_TOWN               = 0,  /**< Top menu in a town. */
    MENU_OPEN_MAIN_DUNGEON            = 1,  /**< Top menu in a dungeon. */
    MENU_OPEN_GEORAMA                 = 2,  /**< Georama menu. */
    MENU_OPEN_DNG_TREE_MAP            = 3,  /**< Dungeon floor map, saving the chosen floor. */
    MENU_OPEN_CHARA_CHANGE            = 4,  /**< Party character change in a town. */
    MENU_OPEN_NAME_REGIST             = 5,  /**< Name entry. */
    MENU_OPEN_SHOP                    = 6,  /**< Shop. */
    MENU_OPEN_SAVE                    = 7,  /**< Save menu during play. */
    MENU_OPEN_TITLE_SAVE              = 8,  /**< Save menu from the title screen. */
    MENU_OPEN_USE_ITEM                = 9,  /**< Item choice that an event asks for, with an opening sound. */
    MENU_OPEN_INVENT                  = 10, /**< Invention menu. */
    MENU_OPEN_CHAPTER                 = 11, /**< Chapter title display. */
    MENU_OPEN_REMOVAL                 = 12, /**< Georama removal menu. */
    MENU_OPEN_WORLD_MOVE              = 13, /**< World map move menu. */
    MENU_OPEN_CHARA_CHANGE_DUNGEON    = 14, /**< Party character change in a dungeon. */
    MENU_OPEN_GYORACE_FISH_SEL        = 15, /**< Fish choice for a fish race. */
    MENU_OPEN_MAIN_TOWN_ITEM_OVER     = 16, /**< Top menu in a town, going straight to the item menu because items overflow. */
    MENU_OPEN_MAIN_DUNGEON_ITEM_OVER  = 17, /**< Top menu in a dungeon, going straight to the item menu because items overflow. */
    MENU_OPEN_OPTION                  = 18, /**< Option menu. */
    MENU_OPEN_WORLD_MOVE_B            = 19, /**< World map move menu, under a second request number. */
    MENU_OPEN_COSTUME                 = 20, /**< Costume menu. */
    MENU_OPEN_MAIN_CHARA_BG_DUNGEON   = 21, /**< Main character display in a dungeon. */
    MENU_OPEN_USE_ITEM_B              = 22, /**< Item choice that an event asks for, without an opening sound. */
    MENU_OPEN_GYORACE                 = 23, /**< Fish race menu. */
    MENU_OPEN_SPHIDA                  = 24, /**< Spheda menu. */
    MENU_OPEN_MONSTER_BOOK            = 25, /**< Monster book. */
    MENU_OPEN_SUBGAME_SAVE            = 26, /**< Mini-game save menu during play. */
    MENU_OPEN_TITLE_SUBGAME_SAVE      = 27, /**< Mini-game save menu from the title screen. */
    MENU_OPEN_SPHIDA_SCORE_VIEW       = 28, /**< Spheda score view. */
    MENU_OPEN_MAIN_CHARA_BG           = 29, /**< Main character display in a town. */
    MENU_OPEN_NUM                     = 30, /**< Number of open requests. */
    MENU_OPEN_ITEM_OVER               = 16, /**< Added to a top-menu request when items overflow. */
};
// clang-format on

/**
 *
 * Where the main menu was opened, as GetMenuLoopType returns it.
 *
 */
// clang-format off
enum MenuLoopType {
    MENU_LOOP_TOWN    = 0, /**< Opened in a town; the world map is offered. */
    MENU_LOOP_DUNGEON = 1, /**< Opened in a dungeon; the floor map is offered. */
};
// clang-format on

/**
 *
 * Phases of the top menu, as CMenuInter::step holds them.
 *
 */
// clang-format off
enum MenuInterStep {
    MENU_INTER_STEP_SELECT  = 0,  /**< The player picks a sub-menu. */
    MENU_INTER_STEP_OPEN    = 1,  /**< The menu frame opens and the base textures load. */
    MENU_INTER_STEP_CLOSE   = 2,  /**< The menu frame closes before the menu ends. */
    MENU_INTER_STEP_MESSAGE = 13, /**< A message says that the chosen sub-menu cannot be used. */
};
// clang-format on

/**
 *
 * Progress of a sub-menu's background texture read, as CMenuInter::bg_read_step holds it.
 *
 */
// clang-format off
enum MenuInterBGReadStep {
    MENU_INTER_BG_READ_WAIT = 0, /**< Waiting for the read to start. */
    MENU_INTER_BG_READ_BUSY = 1, /**< The file is being read. */
    MENU_INTER_BG_READ_DONE = 2, /**< The file is in memory, or there is none. */
};
// clang-format on

/**
 *
 * Arguments that a game loop fills in to open the main menu, and that the menu fills in with what the player chose.
 *
 */
struct MENU_INIT_ARG {
    mgCMemory        *stack;            /**< Memory whose free stack space the menu builds its work area in. */
    mgCMemory        *chara_stack;      /**< Memory that character models shown by the menu are read into. */
    mgCMemory        *base_chara_stack; /**< Memory holding the party characters' base data. */
    s16               chara_tex_block;  /**< Texture block of the characters the menu shows. */
    s16               unk_0E;
    s32               unk_10;
    s32               unk_14;
    CScene           *scene;           /**< Scene that the menu opens over. */
    CUserDataManager *user_data;       /**< Player data that the menu shows and changes. */
    u_int            *pack;            /**< Pack file of menu data loaded by the game loop. */
    int               pack_size;       /**< Size of the pack file in bytes. */
    int               open_type;       /**< What to open. @see MenuOpenType */
    int               tex_block_top;   /**< First texture block the menu may use. */
    int               tex_block_num;   /**< Number of texture blocks the menu may use. */
    int               mes_tex_block;   /**< Texture block of the message font. */
    int               active_chara_no; /**< Party character that is active. */
    int               end_code;        /**< How the menu ended, for the game loop to act on. */
    int               result[5];       /**< Values that the menu hands back with its end code. */
    s32               unk_54;
    int               param[16]; /**< Values that an event passes to the menu it opens. */
};

STATIC_ASSERT(sizeof(MENU_INIT_ARG) == 0x98);

/**
 *
 * Camera and lighting that the main menu draws its models with.
 *
 */
struct MENU_DRAW_ENV {
    mgCCamera     camera; /**< Camera that menu models are viewed through. */
    u8            unk_70[0x10];
    sceVu0FVECTOR ref;            /**< Point that the camera looks at. */
    sceVu0FVECTOR pos;            /**< Position of the camera. */
    float         speed;          /**< Number of steps the camera takes to reach its next position. */
    float         projection;     /**< Projection distance used while the menu draws. */
    float         old_projection; /**< Projection distance to restore when the menu ends. */
    s32           unk_AC;
    sceVu0FVECTOR old_ambient; /**< Ambient light to restore after menu models are drawn. */
    sceVu0FVECTOR ambient;     /**< Ambient light that menu models are drawn with. */

    /**
     *
     * Creates the menu camera with its initial movement speed.
     *
     */
    MENU_DRAW_ENV() : camera(8.0f) {}
};

STATIC_ASSERT(sizeof(MENU_DRAW_ENV) == 0xD0);

/**
 *
 * Texture block and texture that the top menu shares with the menu modes.
 *
 */
struct MENU_ETC_INFO {
    int         tex_block; /**< Texture block of the message font. */
    mgCTexture *tex;       /**< Main menu texture. */
};

STATIC_ASSERT(sizeof(MENU_ETC_INFO) == 0x8);

/**
 *
 * Top menu, which shows the sub-menu icons, lets the player pick one, and reads its background.
 *
 */
class CMenuInter {
public:
    int  select_no;    /**< Cursor position among the sub-menu icons; -1 while the menu closes. */
    int  select_num;   /**< Cursor limit that the selection check is given. */
    int  next_mode;    /**< Sub-menu picked and waiting to open, or -1. @see MenuModeID */
    int *mode_list;    /**< Sub-menus offered, in icon order, ended by -1. @see MenuModeID */
    s16  step;         /**< Phase of the top menu. @see MenuInterStep */
    s8   bg_read_step; /**< Progress of the background read. @see MenuInterBGReadStep */
    s8   bg_read_wait; /**< Frames to wait before the background read starts. */
    s8   cursor_jump;  /**< Non-zero moves the cursor straight to its new icon instead of sliding. */
    u8   help_update;  /**< Non-zero rewrites the help message for the icon under the cursor. */

    /**
     *
     * Puts the top menu in its opening phase, with the cursor on the first icon.
     *
     * @mangled Initialize__10CMenuInterFi
     * @address 0x237AD0
     * @size 0x40
     */
    void Initialize(int unused);

    /**
     *
     * Enters the base textures once the menu frame has opened, and lets the player pick.
     *
     * @mangled InitEnd__10CMenuInterFv
     * @address 0x237D30
     * @size 0x270
     */
    void InitEnd();

    /**
     *
     * Opens the sub-menu under the cursor, or explains why it cannot be used.
     *
     * @mangled PushOk__10CMenuInterFv
     * @address 0x237FA0
     * @size 0x5A0
     */
    void PushOk();

    /**
     *
     * Steps the background read of a sub-menu and reports whether it has finished.
     *
     * @mangled ReadBGTexture__10CMenuInterFii
     * @address 0x238540
     * @size 0x160
     */
    int ReadBGTexture(int bg_no, int restart);
};

STATIC_ASSERT(sizeof(CMenuInter) == 0x18);

/**
 *
 * Shows or hides the black bars at the top and bottom of the screen; it does nothing.
 *
 * @mangled MenuScreenBlackBeltSet__Fi
 * @address 0x234C80
 * @size 0x10
 */
void MenuScreenBlackBeltSet(int flag);

/**
 *
 * Returns where the main menu was opened. @see MenuLoopType
 *
 * @mangled GetMenuLoopType__Fv
 * @address 0x234C90
 * @size 0x10
 */
int GetMenuLoopType();

/**
 *
 * Reports whether the menu was opened because items overflow.
 *
 * @mangled CheckTrushMenu__Fv
 * @address 0x234CA0
 * @size 0x30
 */
int CheckTrushMenu();

/**
 *
 * Returns the dungeon progress record of the current save data, or null.
 *
 * @mangled menu_GetSaveDataDungeon__Fv
 * @address 0x234CD0
 * @size 0x40
 */
CSaveDataDungeon *menu_GetSaveDataDungeon();

/**
 *
 * Returns the dungeon area state of the main scene, or null.
 *
 * @mangled menu_GetBattleAreaScene__Fv
 * @address 0x234D10
 * @size 0x30
 */
DNG_BATTLE_AREA *menu_GetBattleAreaScene();

/**
 *
 * Returns the menu system record of the current save data, or null.
 *
 * @mangled GetMenuSysData__Fv
 * @address 0x234D40
 * @size 0x40
 */
CMenuSystemData *GetMenuSysData();

/**
 *
 * Returns a bit flag of the current save data, or 0 when there is none.
 *
 * @mangled CheckBitFlagMenu__Fi
 * @address 0x234D80
 * @size 0x40
 */
int CheckBitFlagMenu(int flag_no);

/**
 *
 * Returns a short flag of the current save data, or 0 when there is none.
 *
 * @mangled CheckShortFlagMenu__Fi
 * @address 0x234DC0
 * @size 0x50
 */
int CheckShortFlagMenu(int flag_no);

/**
 *
 * Reports whether a save is at the start of chapter 8.
 *
 * @mangled CheckStartChapter8__FP9CSaveData
 * @address 0x234E10
 * @size 0x70
 */
int CheckStartChapter8(CSaveData *save);

/**
 *
 * Clears the flags that tell the game loop what else the menu did.
 *
 * @mangled InitMenuEtcSpecialFlag__Fv
 * @address 0x234E80
 * @size 0x10
 */
void InitMenuEtcSpecialFlag();

/**
 *
 * Adds flags that tell the game loop what else the menu did, and returns them all.
 *
 * @mangled SetMenuEtcFlag__Fi
 * @address 0x234E90
 * @size 0x20
 */
int SetMenuEtcFlag(int flag);

/**
 *
 * Returns the flags that tell the game loop what else the menu did.
 *
 * @mangled GetMenuEtcFlag__Fv
 * @address 0x234EB0
 * @size 0x10
 */
int GetMenuEtcFlag();

/**
 *
 * Returns the primitive drawer that the menu draws with.
 *
 * @mangled GetMenuPrim__Fv
 * @address 0x234EC0
 * @size 0x10
 */
mgCDrawPrim *GetMenuPrim();

/**
 *
 * Enters the main menu frame textures into a texture block.
 *
 * @mangled MenuMainImageDataEnter__Fi
 * @address 0x234ED0
 * @size 0x60
 */
void MenuMainImageDataEnter(int tex_block);

/**
 *
 * Sets the number of vertical blanks per frame while the menu runs.
 *
 * @mangled SetMenuFrameRate__Fi
 * @address 0x234F30
 * @size 0x10
 */
void SetMenuFrameRate(int value);

/**
 *
 * Sets the pad's auto-repeat and menu mode: 0 for menus, 1 for none, 2 for menus with shoulder buttons.
 *
 * @mangled SetMenuKeyCtrlEnv__Fi
 * @address 0x234F40
 * @size 0xB0
 */
void SetMenuKeyCtrlEnv(int layout);

/**
 *
 * Opens the main menu as a game loop asks; a null argument uses MenuArg. Returns the open request.
 *
 * @mangled MenuMainInit__FP13MENU_INIT_ARG
 * @address 0x235060
 * @size 0xED0
 */
int MenuMainInit(MENU_INIT_ARG *arg);

/**
 *
 * Closes the main menu and restores the game loop's sound, characters and camera.
 *
 * @mangled MenuMainExit__Fv
 * @address 0x235F30
 * @size 0x350
 */
int MenuMainExit();

/**
 *
 * Runs and draws one frame of the main menu, and returns non-zero when it ends.
 *
 * @mangled MenuMainLoop__Fv
 * @address 0x236280
 * @size 0x30
 */
int MenuMainLoop();

/**
 *
 * Runs one frame of the active menu mode, and returns non-zero when the menu ends.
 *
 * @mangled MenuMainKey__Fv
 * @address 0x2362B0
 * @size 0x290
 */
int MenuMainKey();

/**
 *
 * Draws one frame of the active menu mode, and switches to a mode that was asked for.
 *
 * @mangled MenuMainDraw__Fv
 * @address 0x236540
 * @size 0xE0
 */
void MenuMainDraw();

/**
 *
 * Opens a sub-menu and makes it the next menu mode; returns 0 for a mode it cannot open. @see MenuModeID
 *
 * @mangled NextMenuInit__FiP9mgCMemoryPi
 * @address 0x236620
 * @size 0x200
 */
int NextMenuInit(int menu, mgCMemory *memory, int *args);

/**
 *
 * Puts the menu camera at its default position, moving over a number of steps.
 *
 * @mangled MenuCamInit__Ff
 * @address 0x236820
 * @size 0x50
 */
void MenuCamInit(float roll);

/**
 *
 * Returns the name of a menu configuration file in the current language's directory.
 *
 * @mangled GetMenuCfgFileName__Fii
 * @address 0x236970
 * @size 0x70
 */
char *GetMenuCfgFileName(int index, int unused);

/**
 *
 * Returns the main menu's messages from the menu pack file.
 *
 * @mangled GetMenuMainMessageBuffer__Fv
 * @address 0x2369E0
 * @size 0x30
 */
short *GetMenuMainMessageBuffer();

/**
 *
 * Returns the main menu frame image from the menu pack file.
 *
 * @mangled GetMenuMainIMGPtr__Fv
 * @address 0x236A10
 * @size 0x20
 */
u_char *GetMenuMainIMGPtr();

/**
 *
 * Returns the main menu layout file from the menu pack file, and its size.
 *
 * @mangled GetMenuMainPosCfgBuffer__FPi
 * @address 0x236A30
 * @size 0x20
 */
char *GetMenuMainPosCfgBuffer(int *size);

/**
 *
 * Chooses the sub-menus that the top menu offers, from where it was opened.
 *
 * @mangled SetCommonMenuModeID__Fv
 * @address 0x236A50
 * @size 0xC0
 */
void SetCommonMenuModeID();

/**
 *
 * Returns the sub-menus that the top menu offers, ended by -1. @see MenuModeID
 *
 * @mangled GetCommonMenuModeID__Fv
 * @address 0x236B10
 * @size 0x10
 */
int *GetCommonMenuModeID();

/**
 *
 * Reports whether the first option setting of the current save data, the cursor memory setting, is zero.
 *
 * @mangled CursorSaveOptionState__Fv
 * @address 0x236B20
 * @size 0x50
 */
int CursorSaveOptionState();

/**
 *
 * Slides the area and time boards in (0) or out (1).
 *
 * @mangled ReturnMenuIntern__Fi
 * @address 0x236B70
 * @size 0x50
 */
void ReturnMenuIntern(int index);

/**
 *
 * Updates the area name, day and time shown on the area and time boards.
 *
 * @mangled MenuAreaBoardNameStep__Fv
 * @address 0x236BC0
 * @size 0x340
 */
void MenuAreaBoardNameStep();

/**
 *
 * Enters the shared menu textures from a pack file into a texture block, and sets up the menu palettes.
 *
 * @mangled MenuCommonBaseDataEnter__FP9mgCMemoryPUiii
 * @address 0x237B10
 * @size 0x130
 */
void MenuCommonBaseDataEnter(mgCMemory *pallet_memory, u_int *pack, int pack_size, int tex_block);

/**
 *
 * Enters the main menu frame and shared menu textures again after a sub-menu has replaced them.
 *
 * @mangled MenuBaseTextureReEnter__Fv
 * @address 0x237C40
 * @size 0xF0
 */
void MenuBaseTextureReEnter();

/**
 *
 * Draws a character's equipped item and weapon icons into the active item and weapon textures.
 *
 * @mangled CopyActiveItemAndWeapon__Fii
 * @address 0x238E60
 * @size 0xB0
 */
void CopyActiveItemAndWeapon(int slot, int unused);

/**
 *
 * Draws a character's equipped item and weapon icons into two textures, and returns 0 when there is no player data.
 *
 * @mangled CopyActiveIconTexture__FPP10mgCTextureiPUi
 * @address 0x238F10
 * @size 0x340
 */
int CopyActiveIconTexture(mgCTexture **tex, int chara_no, u_int *unused);

/**
 *
 * Opens the message window for a bookshelf, naming the photos or the monster it holds.
 *
 * @mangled BookshelfMessageMake__FP6ClsMesiii
 * @address 0x2392F0
 * @size 0x180
 */
void BookshelfMessageMake(ClsMes *mes, int base_window, int item_no, int monster_no);

/** Scene that the menu opens over. */
extern CScene *MenuMainScene;

/** Save data that the menu shows and changes. */
extern CSaveData *MenuActiveSaveData;

/** Player data within the active save data. */
extern CUserDataManager *MenuUserDataManPtr;

/** Menu system record within the active save data. */
extern CMenuSystemData *MenuSystemDataPtr;

/** Option settings within the active save data. */
extern SV_CONFIG_OPTION *MenuConfigPtr;

/** Dungeon progress record within the active save data. */
extern CSaveDataDungeon *MenuSaveDataDungeonPtr;

/** Aquarium within the active save data. */
extern CFishAquarium *MenuFishAquarium;

/** Map that the menu was opened on. */
extern s16 MenuNowMapNo;

/** Type of the map that the menu was opened on. */
extern s16 MenuNowMapType;

/** Time of day, in hours, shown on the time board. */
extern float MenuNowTime;

/** Non-zero when the menu opened because items overflow. */
extern s8 ItemOverFlowCheckFlag;

/** Camera and lighting that the menu draws its models with. */
extern MENU_DRAW_ENV *MenuDrawEnv;

/** Key handling and state shared by every menu mode. */
extern CMenuKeyFunc *MenuCommonInfo;

/** Texture block and texture that the top menu shares with the menu modes. */
extern MENU_ETC_INFO MenuEtcInfo;

/** Item being moved between lists. */
extern CMenuMoveItem *MenuMoveItemPtr;

/** Form named mi2 in the main menu layout, whose move speed the top menu sets. */
extern CMenuPosDataForm *MenuFormMI2;

/** Frames the menu has run, wrapping after ten million. */
extern int MenuItemCommandCounter;

/** Non-zero while the menu debug display is on. */
extern int menu_debug_flag;

/** End code of the previous menu, or -1. */
extern int MenuPrevEndCode;

/** Texture block of the active sub-menu's background, or -1. */
extern int MenuBGTextureBlock;

/** Texture block of the item icons, or -1. */
extern int MenuItemIconTextureBlock;

/** Item use state shared by the item menus. */
extern CMenuItemUse MenuItemUse;

/** Memory over the shared menu texture pack. */
extern mgCMemory MenuMainTextureReadBuf;

/** Memory that menu sounds are read into. */
extern mgCMemory MenuSoundBuffer;

/** Arguments the main menu uses when a game loop passes none. */
extern MENU_INIT_ARG MenuArg;
