#include "common.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "charasetup.hpp"
#include "dataread.hpp"
#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "dynamicanime.hpp"
#include "editmenu.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "inventmn.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mapselect.hpp"
#include "menuaqua.hpp"
#include "menucapt.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menumap.hpp"
#include "menuop.hpp"
#include "menushop.hpp"
#include "menusys.hpp"
#include "menusystemdata.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nameregi.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Storage for the current menu forms and resources.
 *
 */
static mgCMemory MenuMainStack;

/**
 *
 * Storage prepared for the next sub-menu.
 *
 */
static mgCMemory MenuMainStack_Next;

/**
 *
 * Primitive builder used by menu drawing.
 *
 */
static mgCDrawPrim MenuPrimFix;

/**
 *
 * Memory over the shared menu texture pack.
 *
 */
mgCMemory MenuMainTextureReadBuf;

/**
 *
 * Memory used to read menu sounds.
 *
 */
mgCMemory MenuSoundBuffer;

/**
 *
 * Font used to draw the scrolling topic message.
 *
 */
static CMenuFont TopicFont;

/**
 *
 * Primitive builder currently used by the menu.
 *
 */
static mgCDrawPrim *MenuPrim = &MenuPrimFix;

/**
 *
 * Processes selection and closing of the top menu.
 *
 */
int MenuInternSelectKey();

/**
 *
 * Draws the top menu and its messages.
 *
 */
void MenuInternSelectDraw();

/**
 *
 * Key handler for each menu mode.
 *
 */
static int (*menu_keyfunctbl[MENU_MODE_NUM])() = {
    MenuInternSelectKey,
    MenuInternSelectKey,
    MenuItemKey,
    MenuGeoramaKey,
    MenuCharaChangeKey,
    MenuInventKey,
    WorldMoveKey,
    MenuOptionKey,
    MenuManualKey,
    NULL,
    MenuMonsterBoxKey,
    DngTreeMapKey,
    MenuShopKey,
    MenuSaveKey,
    MenuSaveKey,
    MenuItemSelectKey,
    MenuInventKey,
    MenuChapterKey,
    MenuAquaKey,
    MenuRemovalKey,
    NameRegistKey,
    MenuGyoraceFishSelKey,
    MenuNPCQuestViewKey,
    MenuCostumeKey,
    KeyMainCharaBG,
    GyoraceMenuKey,
    SphidaMenuKey,
    MonsterBookKey,
    SubGameSaveKey,
    SphidaScoreViewKey
};

/**
 *
 * Draw handler for each menu mode.
 *
 */
static void (*menu_drawfunctbl[MENU_MODE_NUM])() = {
    MenuInternSelectDraw,
    MenuInternSelectDraw,
    MenuItemDraw,
    MenuGeoramaDraw,
    MenuCharaChangeDraw,
    MenuInventDraw,
    WorldMoveDraw,
    MenuOptionDraw,
    MenuManualDraw,
    NULL,
    MenuMonsterBoxDraw,
    DngTreeMapDraw,
    MenuShopDraw,
    MenuSaveDraw,
    MenuSaveDraw,
    MenuItemSelectDraw,
    MenuInventDraw,
    MenuChapterDraw,
    MenuAquaDraw,
    MenuRemovalDraw,
    NameRegistDraw,
    MenuGyoraceFishSelDraw,
    MenuNPCQuestViewDraw,
    MenuCostumeDraw,
    DrawMainCharaBG,
    GyoraceMenuDraw,
    SphidaMenuDraw,
    MonsterBookDraw,
    SubGameSaveDraw,
    SphidaScoreViewDraw
};

int         CheckItemTable(int item_no, int *photos);
void        MenuPolygonSetEnv();
void        MenuPolygonEnvReset();
int         PauseEnable(int enable);
void        EdEventMenuExit();
short       CheckEventDay(int *remaining_hours);
void        MenuWorldTrans();
void        MenuDebugModeDraw();
void        DrawMenuTopic();

static inline void SetCursorPos(CMenuKeyFunc *keys, int *pos) {
    keys->MenuSetPos(pos[0], pos[1]);
}

/**
 *
 * Sets a menu form's position from integer screen coordinates.
 *
 */
static inline void SetFormPoint(CMenuPosDataForm *form, int x, int y) {
    form->x = (float) x;
    form->y = (float) y;
}

/**
 *
 * Stores a destination point for menu movement.
 *
 */
struct MovePoint {
    int x; /**< Horizontal coordinate of the destination. */
    int y; /**< Vertical coordinate of the destination. */
};

/**
 *
 * Stores menu pages reached by the page keys.
 *
 */
struct MenuKeyPageTable {
    int next[2]; /**< Page destinations for the two page keys. */
};

/**
 *
 * Pairs names used for a menu area.
 *
 */
struct AreaNameItems {
    char *name[2]; /**< Names for the two area entries. */
};

/**
 *
 * Stores the two coordinates of a menu board.
 *
 */
struct BoardPosition {
    int value[2]; /**< Horizontal and vertical board coordinates. */
};

/**
 *
 * Stores menu widths for supported languages.
 *
 */
struct LanguageWidths {
    int value[9]; /**< Width values indexed by language. */
};

/**
 *
 * Pairs a monster name with its message.
 *
 */
struct MonsterTableEntry {
    short name_no;    /**< Message number for the monster name. */
    short message_no; /**< Message number for the monster description. */
};

/**
 *
 * Images entered for the top-menu icon sheet.
 *
 */
static char *fname_1858[2] = {
    "mb2.pac",
    NULL
};

/**
 *
 * Number of equipment icons copied for each player character.
 *
 */
static int loopnumtbl_2360[2] = {
    3, 2
};

extern u8                menu_basedgRef[16];
extern u8                menu_basedgCamPos[16];

/**
 *
 * Main menu resource packs selected by layout mode.
 *
 */
static char *menu_main_cfgname_1620[2] = {
    "men0.pac",
    "men0.pac"
};

/**
 *
 * Sub-menu destinations for town and dungeon top menus.
 *
 */
static int CommonMenuModeID[2][8] = {
    {MENU_MODE_ITEM, MENU_MODE_CHARA_CHANGE, MENU_MODE_INVENT, MENU_MODE_WORLD_MOVE,
     MENU_MODE_OPTION, MENU_MODE_MANUAL, -1},
    {MENU_MODE_ITEM, MENU_MODE_CHARA_CHANGE, MENU_MODE_INVENT, MENU_MODE_DNG_TREE_MAP,
     MENU_MODE_OPTION, MENU_MODE_MANUAL, -1}
};

/**
 *
 * Actions that move the area and time boards into or out of the menu.
 *
 */
static char *acttbl_1682[2] = {
    "\x92\x86\x82\xD6",
    "\x8A\x4F\x82\xD6"
};

/**
 *
 * Foreground colors of the topic ticker's edge gradient.
 *
 */
static float menu_maintopic_colortbl[4][4] = {
    {86.0f, 169.0f, 104.0f, 64.0f},
    {86.0f, 169.0f, 104.0f, 0.0f},
    {86.0f, 169.0f, 104.0f, 64.0f},
    {86.0f, 169.0f, 104.0f, 0.0f}
};

/**
 *
 * Shadow colors of the topic ticker's edge gradient.
 *
 */
static float menu_maintopic_colortbl_shadow[4][4] = {
    {42.0f, 34.0f, 20.0f, 110.0f},
    {42.0f, 34.0f, 20.0f, 0.0f},
    {42.0f, 34.0f, 20.0f, 110.0f},
    {42.0f, 34.0f, 20.0f, 0.0f}
};

/**
 *
 * Current opacity of the scrolling topic ticker.
 *
 */
static int MenuTopicAlpha = 128;

/**
 *
 * Topic messages selected by language and category.
 *
 */
static char *topic_tbl_1777[7][3] = {
    {"", " ", " "},
    {"", "Fishing Contest: %d hr(s). to go", "Finny Frenzy: %d hr(s). to go"},
    {"", "Tournoi de p[UNI00ea]che : encore %d h(s)", "Meill. nageoires : encore %d h(s)"},
    {"", "Angelturnier: Noch %d Std.", "Fl.-Fieber: Noch %d Std."},
    {"", "Torneo di Pesca: ancora %d ora/e", "Pinna Sprint: ancora %d ora/e"},
    {"", "Concurso Pesca: %d h. para salir", "Finny Frenzy: %d h. para salir"},
    {"", "Concurso Pesca: %d h. para salir", "Finny Frenzy: %d h. para salir"}
};

/**
 *
 * Monster names and descriptions displayed by bookshelves.
 *
 */
static MonsterTableEntry monster_table[11] = {
    {0, 269},
    {220, 280},
    {8, 318},
    {0, 0},
    {164, 211},
    {72, 225},
    {124, 234},
    {44, 289},
    {176, 276},
    {236, 189},
    {0, 0}
};

/**
 *
 * Message resources selected by sub-menu mode.
 *
 */
static char *filetbl_2141[17] = {
    "itemmn0.pac",
    "",
    "chrchg0.pac",
    "inv2_bg.pac",
    "",
    "op1.pac",
    "manual1.pac",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    ""
};

/**
 *
 * Scene that the menu opens over.
 *
 */
CScene *MenuMainScene;

/**
 *
 * Save data that the menu shows and changes.
 *
 */
CSaveData *MenuActiveSaveData;

/**
 *
 * Player data within the active save data.
 *
 */
CUserDataManager *MenuUserDataManPtr;

/**
 *
 * Menu system record within the active save data.
 *
 */
CMenuSystemData *MenuSystemDataPtr;

/**
 *
 * Option settings within the active save data.
 *
 */
SV_CONFIG_OPTION *MenuConfigPtr;

/**
 *
 * Dungeon progress record within the active save data.
 *
 */
CSaveDataDungeon *MenuSaveDataDungeonPtr;

/**
 *
 * Aquarium within the active save data.
 *
 */
CFishAquarium *MenuFishAquarium;

/**
 *
 * Map that the menu was opened on.
 *
 */
s16 MenuNowMapNo;

/**
 *
 * Type of the map that the menu was opened on.
 *
 */
s16 MenuNowMapType;

/**
 *
 * Time of day, in hours, shown on the time board.
 *
 */
float MenuNowTime;

/**
 *
 * Non-zero when the menu opened because items overflow.
 *
 */
s8 ItemOverFlowCheckFlag;

/**
 *
 * Camera and lighting that the menu draws its models with.
 *
 */
MENU_DRAW_ENV *MenuDrawEnv;

/**
 *
 * Key handling and state shared by every menu mode.
 *
 */
CMenuKeyFunc *MenuCommonInfo;

/**
 *
 * Texture block and texture that the top menu shares with the menu modes.
 *
 */
MENU_ETC_INFO MenuEtcInfo;

/**
 *
 * Item being moved between lists.
 *
 */
CMenuMoveItem *MenuMoveItemPtr;

/**
 *
 * Form named mi2 in the main menu layout, whose move speed the top menu sets.
 *
 */
CMenuPosDataForm *MenuFormMI2;

/**
 *
 * Frames the menu has run, wrapping after ten million.
 *
 */
int MenuItemCommandCounter;

/**
 *
 * Non-zero while the menu debug display is on.
 *
 */
int menu_debug_flag;

/**
 *
 * Item use state shared by the item menus.
 *
 */
CMenuItemUse MenuItemUse;

/**
 *
 * Arguments the main menu uses when a game loop passes none.
 *
 */
MENU_INIT_ARG MenuArg;

/**
 *
 * Resource pack containing the active sub-menu background.
 *
 */
static u_long128 *MenuMainSubDataPackAdr;

/**
 *
 * Active top-menu state.
 *
 */
static CMenuInter *CMenuInterPt;

/**
 *
 * Help and restriction messages for the selected sub-menu.
 *
 */
static CDC2Mes *MenuInterMes;

/**
 *
 * Whether the top-menu message window is visible.
 *
 */
static signed char MenuInterMesDrawFlag;

/**
 *
 * Board showing the current area name.
 *
 */
static CMenuPosDataForm *MenuAreaBrdForm;

/**
 *
 * Board showing the current day and time.
 *
 */
static CMenuPosDataForm *MenuTimeBrdForm;

/**
 *
 * Name displayed on the menu area board.
 *
 */
static char *MenuAreaName;

/**
 *
 * Enemy sound volume restored when the menu closes.
 *
 */
static float SndPortVol_Enemy;

/**
 *
 * Game loop mode that opened the menu.
 *
 */
static signed char MenuLoopType;

/**
 *
 * Additional result code returned by the menu.
 *
 */
static int MenuEtcSpecialCode;

/**
 *
 * Background-music volume restored when the menu closes.
 *
 */
static int MenuBGMVolume_Save;

/**
 *
 * Fade direction of the topic ticker.
 *
 */
static short MenuTopicAlphaCalc;

/**
 *
 * Texture atlas containing the topic ticker backing.
 *
 */
static mgCTexture *TopicTex;

/**
 *
 * Lighting state restored when the menu closes.
 *
 */
static int old_light_menu;

/**
 *
 * Whether invention is available in the top menu.
 *
 */
static u8 HatumeiMenuOkFlag;

/**
 *
 * Whether the world map is available in the top menu.
 *
 */
static u8 WorldMapOkFlag;

/**
 *
 * Whether the help menu is available in the top menu.
 *
 */
static u8 ManualMenuOkFlag;

/**
 *
 * Whether the dungeon map is available in the top menu.
 *
 */
static u8 DngMoveMenuOkFlag;

/**
 *
 * Whether this frame has already drawn the menu.
 *
 */
static u8 MenuDoubleDrawCheck;

/**
 *
 * Frames elapsed since the last player-data refresh.
 *
 */
static signed char refresh_cnt_1523;

/**
 *
 * Whether the player-data refresh counter is initialized.
 *
 */
static signed char init_1524;

/**
 *
 * Topic message category selected for the ticker.
 *
 */
static short MenuTopicType;

/**
 *
 * Width of the scrolling topic message.
 *
 */
static short MenuTopicLength;

/**
 *
 * Horizontal position of the scrolling topic message.
 *
 */
static int TopicFontX;

/**
 *
 * Storage for the top-menu state.
 *
 */
static CMenuInter CMenuInterStatic;

/**
 *
 * Player position restored when the menu closes.
 *
 */
float menu_old_chara_position[4];

/**
 *
 * Player rotation restored when the menu closes.
 *
 */
float menu_old_chara_rotation[4];

/**
 *
 * Path buffer used to locate the menu configuration.
 *
 */
static char workchr_1622[0x60];

/**
 *
 * Sub-menu destinations after availability filtering.
 *
 */
static int CommonMenuModeID2[8];

/**
 *
 * End code of the previously closed menu.
 *
 */
int MenuPrevEndCode = -1;

/**
 *
 * Texture block of the active sub-menu background.
 *
 */
int MenuBGTextureBlock = -1;

/**
 *
 * Texture block containing menu item icons.
 *
 */
int MenuItemIconTextureBlock = -1;

// Code (.text)
void MenuScreenBlackBeltSet(int enable) {
}

int GetMenuLoopType() {
    return MenuLoopType;
}

int CheckTrushMenu() {
    short mode = MenuCommonInfo->open_type;

    if (mode == 0x10 || mode == 0x11) {
        return 1;
    }

    return 0;
}

CSaveDataDungeon *menu_GetSaveDataDungeon() {
    CSaveData *save_data;

    save_data = GetSaveData();

    if (save_data != NULL) {
        return &save_data->save_dungeon;
    }

    return NULL;
}

DNG_BATTLE_AREA *menu_GetBattleAreaScene() {
    CScene *scene;

    scene = GetMainScene();

    if (scene != NULL) {
        return &scene->battle_area;
    }

    return NULL;
}

CMenuSystemData *GetMenuSysData() {
    CSaveData *save_data;

    save_data = GetSaveData();

    if (save_data != NULL) {
        return &save_data->menu_system_data;
    }

    return NULL;
}

int CheckBitFlagMenu(int flag) {
    CSaveData *save_data;

    save_data = GetSaveData();

    if (save_data != NULL) {
        return save_data->GetBitFlag(flag);
    }

    return 0;
}

int CheckShortFlagMenu(int flag) {
    CSaveData *save_data;

    save_data = GetSaveData();

    if (save_data != NULL) {
        return save_data->GetShortFlag(flag);
    }

    return 0;
}

int CheckStartChapter8(CSaveData *save_data) {
    if (save_data == NULL) {
        return 0;
    }

    if (save_data->GetBitFlag(0x2E0) == 1) {
        if (!save_data->GetBitFlag(0x320)) {
            return 1;
        }
    }

    return 0;
}

void InitMenuEtcSpecialFlag() {
    MenuEtcSpecialCode = 0;
}

int SetMenuEtcFlag(int flags) {
    MenuEtcSpecialCode |= flags;
    return MenuEtcSpecialCode;
}

int GetMenuEtcFlag() {
    return MenuEtcSpecialCode;
}

mgCDrawPrim *GetMenuPrim() {
    return MenuPrim;
}

void MenuMainImageDataEnter(int block) {
    u8 *image;

    image = GetMenuMainIMGPtr();

    if (image != NULL) {
        mgTexManager.EnterIMGFile(image,
                                  block, NULL, NULL);
        MenuPosData->ResetTextureBlockNo("mnmain", block);
    }
}

void SetMenuFrameRate(int value) {
    mgFrameRate = value;
}

void SetMenuKeyCtrlEnv(int layout) {
    GamePad__2.AutoRepeatOff();
    GamePad__2.MenuModeOff();

    if (layout == 0) {
        GamePad__2.SetAutoRepeat(0xF000, 15, 4);
        GamePad__2.MenuModeOn(120);
    } else if (layout != 1 && layout == 2) {
        GamePad__2.SetAutoRepeat(0xF00C, 15, 4);
        GamePad__2.MenuModeOn(120);
    }
}

void DisablePadReset(int disable) {
    DNG_BATTLE_AREA *scene;

    if (GetNowLoopNo() == 2) {
        scene = menu_GetBattleAreaScene();

        if (scene != NULL) {
            if (disable != 0) {
                scene->pause_flag |= 0x8000;
            } else {
                scene->pause_flag &= ~0x8000;
            }
        }
    }
}
#ifdef NONMATCHING
void         MakeMenuTopic();
int          MenuInternInit(mgCMemory *, int, int);
extern float light_1062[4][4];
extern float lightcolor_1063[4][4];

int MenuMainInit(MENU_INIT_ARG *arg) {
    MENU_INIT_ARG *init_arg = arg;
    if (arg == NULL) {
        init_arg = &MenuArg;
    }
    SetMenuFrameRate(1);
    old_light_menu = mgActiveLighting(3, 0);
    mgInitActiveLighting();
    SetMenuKeyCtrlEnv(0);
    PauseEnable(0);
    DisablePadReset(1);
    menu_debug_flag = 0;
    MenuMainStack.stSetBuffer(init_arg->stack->stGetTop(), init_arg->stack->stGetSize());
    MenuMainStack_Next.stReset();
    MENU_DRAW_ENV *draw_env = new (MenuMainStack.Alloc(15)) MENU_DRAW_ENV;
    MenuDrawEnv = draw_env;
    draw_env->camera.Resume();
    MenuCamInit(1.0f);
    MenuDrawEnv->projection = 800.0f;
    MenuDrawEnv->old_projection = mgGetProjection();
    MenuDrawEnv->ambient[0] = 80.0f;
    MenuDrawEnv->ambient[1] = 80.0f;
    MenuDrawEnv->ambient[2] = 80.0f;
    MenuDrawEnv->ambient[3] = 128.0f;
    mgSetLight(light_1062, lightcolor_1063);
    MenuPosData = new (MenuMainStack.Alloc(0x5E)) CMenuPosDataManage;
    MenuPosData->InitializeCMenuPosDataManage();
    CMenuKeyFunc *common = new (MenuMainStack.Alloc(0x18)) CMenuKeyFunc;
    MenuCommonInfo = common;
    memset(MenuCommonInfo, 0, sizeof(CMenuKeyFunc));
    MenuCommonInfo->next_mode = -1;
    MenuCommonInfo->have_item.Init();
    MenuSoundBuffer.stSetBuffer(MenuMainStack.stGetTop(), 0x140);
    MenuMainStack.Alloc(0x140);
    MenuSePlayUsedFlag = 0;
    MenuCommonInfo->user_data = MenuArg.user_data;
    MenuPrevEndCode = MenuArg.end_code;
    MenuArg.end_code = 0;
    MenuCommonInfo->pack = init_arg->pack;
    MenuCommonInfo->pack_size = init_arg->pack_size;
    mgCTextureManager *texture_manager = &mgTexManager;
    for (int i = 0; i < init_arg->tex_block_num && i < 16; i++) {
        MenuCommonInfo->tex_block[i] = init_arg->tex_block_top + i;
        texture_manager->DeleteBlock(MenuCommonInfo->tex_block[i]);
    }
    MenuCommonInfo->unk_4C = -1;
    MenuBGTextureBlock = -1;
    MenuItemIconTextureBlock = -1;
    MenuCommonInfo->open_type = init_arg->open_type;
    MorattaStack = MenuArg.base_chara_stack;
    CUserDataManager *user;
    MenuActiveSaveData = GetSaveData();
    MenuUserDataManPtr = NULL;
    MenuConfigPtr = NULL;
    MenuSystemDataPtr = NULL;
    MenuSaveDataDungeonPtr = NULL;
    MenuFishAquarium = NULL;
    if (MenuActiveSaveData != NULL) {
        user = MenuActiveSaveData->GetUserDataManager();
        MenuUserDataManPtr = user;
        MenuConfigPtr = MenuActiveSaveData->GetConfig();
        MenuSystemDataPtr = &MenuActiveSaveData->menu_system_data;
        MenuSaveDataDungeonPtr = &MenuActiveSaveData->save_dungeon;
        int active_chara_no = user->active_chr_no;
        MenuFishAquarium = &user->aquarium;
        MenuArg.active_chara_no = active_chara_no;
    }
    MenuCommonInfo->user_data = MenuUserDataManPtr;
    MenuMainScene = GetMainScene();
    MenuNowMapNo = MenuMainScene->GetNowMapNo();
    MenuNowMapType = GetMapType(MenuNowMapNo);
    CCharacter2 *chara = MenuMainScene->GetCharacter(0);
    if (chara != NULL) {
        chara->GetPosition(menu_old_chara_position);
        chara->GetRotation(menu_old_chara_rotation);
    }
    UserDataRefresh();
    MenuNowTime = MenuMainScene->time;
    MakeMenuTopic();
    if (CheckBitFlagMenu(0x68) == 0) {
        if (CheckBitFlagMenu(4) == 1) {
            MenuNowTime = 18.25f;
            int event = CheckShortFlagMenu(5);
            if (event == 1) {
                MenuNowTime = 20.92f;
            }
            if (event == 2) {
                MenuNowTime = 21.25f;
            }
            if (event == 3) {
                MenuNowTime = 21.5f;
            }
        } else {
            if (CheckBitFlagMenu(0x66) == 1) {
                MenuNowTime = 0.0f;
            }
            if (CheckBitFlagMenu(0x67) == 1) {
                MenuNowTime = 1.0f;
            }
        }
    }
    MenuBGMVolume_Save = MenuMainScene->GetVolBGM();
    MenuAreaName = GetMapTitle(MenuNowMapNo);
    if (MenuNowMapNo == 10) {
        int map = MenuMainScene->now_sub_map_no;
        if (map < 0) {
            map = 10;
        }
        MenuAreaName = GetMapTitle(map);
    }
    SndPortVol_Enemy = sndGetPortVol(5);
    sndSetPortVol(5, 0.0f);
    MenuPrim->Initialize(NULL, NULL);
    mgCDrawPrim *prim = MenuPrim;
    prim->offset_x = 0;
    prim->offset_y = 0;
    short *system_messages = GetSystemMesBuffer();
    short *menu_messages = GetMenuMainMessageBuffer();
    for (int i = 0; i < 9; i++) {
        MenuMainStack.Align64();
        MenuDCMsg[i] = new (MenuMainStack.Alloc(0x2A7)) CDC2Mes;
        CDC2Mes *message = MenuDCMsg[i];
        message->Init();
        message->texture_block = MenuArg.mes_tex_block;
        message->buff = NULL;
        message->SetMessData(system_messages, menu_messages);
    }
    InitSpectolRasterTable(&MenuMainStack);
    MenuCursorReverseFlag = 0;
    MenuUserParam.AttachInfo();
    MenuItemUse.Initialize();
    MenuAreaBrdForm = NULL;
    MenuTimeBrdForm = NULL;
    TopicTex = NULL;
    InitMenuEtcSpecialFlag();
    SetModeMenuDrawItemBoard(0);
    TreeMapSaveFlag = 0;
    TreeMapCallDungeonSubMap = 0;
    TreeMapCalledWorldMap = 0;
    int *texture_blocks = MenuCommonInfo->tex_block;
    MenuMainStack.Align64();
    mgCMemory *menu_stack = &MenuMainStack;
    ItemOverFlowCheckFlag = 0;
    if (CheckItemOver() > 0 && (MenuCommonInfo->open_type == 0 || MenuCommonInfo->open_type == 1)) {
        MenuCommonInfo->open_type += 16;
        ItemOverFlowCheckFlag = 1;
    }
    MenuLoopType = 0;
    if (MenuCommonInfo->open_type == 1 || MenuCommonInfo->open_type == 17 ||
        MenuCommonInfo->open_type == 14 || MenuCommonInfo->open_type == 21) {
        MenuLoopType = 1;
    }
    SetCommonMenuModeID();
    int sound = -1;
    CMenuInterPt = NULL;
    MenuInterMesDrawFlag = 0;
    MenuInterMes = NULL;
    switch (MenuCommonInfo->open_type) {
        case 0:
        case 1:
            sound = 1;
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 1);
            break;
        case 2:
            sound = 1;
            MenuGeoramaInit(menu_stack, MenuCommonInfo->open_type);
            break;
        case 3:
            TreeMapSaveNum = 0;
            TreeMapSaveFlag = 1;
            MenuCommonInfo->now_mode = 11;
            DngTreeMapInit(menu_stack, texture_blocks, MenuCommonInfo->open_type, MenuArg.param[0]);
            break;
        case 4:
        case 14:
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 0);
            while (ReadBGSync() != 0) {
            }
            CMenuInterPt->InitEnd();
            ReturnMenuIntern(1);
            NextMenuInit(4, &MenuMainStack_Next, &texture_blocks[3]);
            MenuCommonInfo->now_mode = 4;
            MenuMainScene->fade.FadeIn(30);
            break;
        case 6:
            MenuShopInit(menu_stack, texture_blocks, 6);
            break;
        case 9:
            sound = 1;
        case 22:
            MenuScreenBlackBeltSet(0);
            MenuCommonInfo->now_mode = 15;
            MenuItemSelectInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            break;
        case 10:
            sound = 1;
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 1);
            NextMenuInit(16, menu_stack, &texture_blocks[3]);
            MenuCommonInfo->now_mode = 16;
            break;
        case 11:
            MenuCommonInfo->now_mode = 17;
            MenuChapterInit(menu_stack, texture_blocks, 11, MenuArg.param[0]);
            break;
        case 7:
        case 8:
            SetDngTreeFlag(0);
            if (MenuCommonInfo->open_type == 7) {
                SaveMapInfo(-1);
                NowProgramLoopNo = GetNowLoopNo();
                MenuCommonInfo->now_mode = 13;
            }
            if (MenuCommonInfo->open_type == 8) {
                MenuCommonInfo->now_mode = 14;
            }
            MenuSaveInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            break;
        case 26:
        case 27:
            MenuCommonInfo->now_mode = 28;
            SubGameSaveInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            break;
        case 12:
            MenuScreenBlackBeltSet(0);
            MenuRemovalInit(menu_stack, texture_blocks);
            MenuCommonInfo->now_mode = 19;
            break;
        case 13:
        case 19:
            WorldMoveInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            MenuCommonInfo->now_mode = 6;
            break;
        case 5:
            Nameregi_Target.target = 2;
            NameRegistInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            MenuCommonInfo->now_mode = 20;
            break;
        case 15:
            MenuScreenBlackBeltSet(0);
            sound = 1;
            MenuGyoraceFishSelInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            MenuCommonInfo->now_mode = 21;
            break;
        case 16:
        case 17:
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 0);
            while (ReadBGSync() != 0) {
            }
            CMenuInterPt->InitEnd();
            CMenuInterPt->ReadBGTexture(2, 1);
            while (CMenuInterPt->ReadBGTexture(2, 0) == 0) {
            }
            ReturnMenuIntern(1);
            NextMenuInit(2, &MenuMainStack_Next, &texture_blocks[3]);
            MenuMainScene->fade.FadeIn(40);
            MenuCommonInfo->now_mode = 2;
            break;
        case 18:
            GamePad__2.KeyLock(1);
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 0);
            while (ReadBGSync() != 0) {
            }
            CMenuInterPt->InitEnd();
            CMenuInterPt->ReadBGTexture(7, 1);
            while (CMenuInterPt->ReadBGTexture(7, 0) == 0) {
            }
            ReturnMenuIntern(1);
            NextMenuInit(7, &MenuMainStack_Next, &texture_blocks[3]);
            break;
        case 20:
            MenuCostumeInit(menu_stack, texture_blocks, 0);
            MenuCommonInfo->now_mode = 23;
            break;
        case 21:
        case 29: {
            int town = 0;
            if (MenuCommonInfo->open_type == 29) {
                town = 1;
            }
            MenuScreenBlackBeltSet(0);
            InitMainCharaBG(MenuArg.param[0], menu_stack, town);
            MenuCommonInfo->now_mode = 24;
            break;
        }
        case 23:
            MenuScreenBlackBeltSet(0);
            GyoraceMenuInit(menu_stack, texture_blocks, 0);
            sound = 1;
            MenuCommonInfo->now_mode = 25;
            break;
        case 24:
            SphidaMenuInit(menu_stack, texture_blocks, 0);
            sound = 1;
            MenuCommonInfo->now_mode = 26;
            break;
        case 28:
            MenuScreenBlackBeltSet(0);
            SphidaScoreViewInit(menu_stack, texture_blocks, 0);
            MenuCommonInfo->now_mode = 29;
            break;
        case 25:
            MonsterBookInit(menu_stack, texture_blocks, 1);
            MenuCommonInfo->now_mode = 27;
            break;
    }
    MenuSePlay(sound);
    return MenuCommonInfo->open_type;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuMainInit__FP13MENU_INIT_ARG);
#endif
int MenuMainExit() {
    CCharacter2 *chara;
    int          i;
    int          active_chara;
    int          is_fishing_menu;
    CScene      *scene;
    mgCCamera   *camera;
    float        view_matrix[4][4];
    float        pos[4];
    float        world_matrix[4][4];
    float        identity[4][4];

    mgActiveLighting(old_light_menu, 0);
    MenuDeleteTextureBlock(MenuCommonInfo->tex_block);
    PauseEnable(1);
    DisablePadReset(0);
    MenuPrimFix.Initialize(NULL, NULL);
    MenuPrimFix.offset_x = 0;
    MenuPrimFix.offset_y = 0;

    if (MenuSePlayUsedFlag != 0) {
        sndInitPort(8);
    }

    sndSetPortVol(5, SndPortVol_Enemy);
    active_chara = MenuUserDataManPtr->active_chr_no;
    GetBattleCharaInfo();

    if (MenuArg.end_code == 1) {
        active_chara = MenuArg.result[0];
        SetMenuEtcFlag(1);
    }

    MenuCommonInfo->user_data->SetActiveChrNo(active_chara);

    if (MenuMainScene != NULL) {
        chara = MenuMainScene->GetCharacter(0);

        if (chara != NULL) {
            chara->SetPosition(menu_old_chara_position);
            chara->SetRotation(menu_old_chara_rotation);
        }

        if ((MenuArg.end_code == 1 || MenuArg.end_code == 21) && chara != NULL) {
            chara->UpdatePosition();
            i = 0;

            if (chara->dynamic_anime_num != 0) {
                while (i < chara->dynamic_anime_num) {
                    chara->dynamic_anime[i].ResetPosition();
                    i++;
                }
            }

            (&MenuMainScene->fade)->FadeOut(-1, 0.0f, 0.0f, 0.0f);
        }

        MenuMainScene->SetVolBGM(MenuBGMVolume_Save);
    }

    is_fishing_menu = (MenuArg.end_code == 5) | (MenuArg.end_code == 6);

    if (active_chara == 0) {
        if (MenuUserParam.chara[0]->equip[0].IsFishingRod() != 0) {
            if (is_fishing_menu == 0) {
                MenuArg.end_code = 11;
                MenuArg.result[0] = MenuUserDataManPtr->GetFishingRodNo();
                MenuArg.result[1] = MenuUserDataManPtr->GetFishBait();

                if (GetMenuLoopType() == 1) {
                    chara = MenuMainScene->GetCharacter(1);

                    if (chara != NULL) {
                        chara->DeleteImage();
                        ((CActionChara *) chara)->Initialize(NULL);
                    }

                    SetupUnitMan(MenuMainScene, MenuUserDataManPtr, active_chara, NULL);
                }
            } else {
                ReEquipFishingGameWeapon();
            }
        }
    }

    MenuPrevEndCode = -1;
    SetMenuKeyCtrlEnv(1);
    MenuPosData->ClearPos();
    MenuMainStack.stack_used = 0;
    MenuPosData = NULL;
    MenuMainStack.lock = 0;
    SetDngTreeFlag(0);
    SetMenuFrameRate(2);
    CMenuInterPt = NULL;
    menu_debug_flag = 0;
    EdEventMenuExit();
    mgSetProjection(MenuDrawEnv->old_projection);
    scene = GetMainScene();
    camera = scene->GetCamera(scene->active_camera);

    if (camera != NULL) {
        camera->GetCameraMatrix(view_matrix);
        camera->GetPos(pos);
        sceVu0UnitMatrix(identity);
        sceVu0MulMatrix(world_matrix, identity, view_matrix);
        mgSetViewMatrix(world_matrix, pos);
    }

    return 1;
}

int MenuMainLoop() {
    int next_mode = MenuMainKey();
    MenuMainDraw();
    return next_mode;
}

int MenuMainKey() {
    int              result;
    short            page;
    int              menu;

    MenuWorldTrans();
    MenuPolygonSetEnv();
    ReadBG();
    MenuCommonInfo->SelDataInit();
    MenuMainFrameStep();
    MenuAreaBoardNameStep();

    if (DebugFlag != 0 && GamePad__2.Down(0x400) != 0) {
        menu_debug_flag ^= 1;
    }

    result = menu_keyfunctbl[MenuCommonInfo->now_mode]();

    switch (result) {
        case 1:
            page = MenuCommonInfo->open_type;

            switch (page) {
                case 0:
                case 1: {
                    menu = MenuCommonInfo->now_mode;

                    if (menu >= 2 && menu < 12) {
                        MenuKeyPageTable page_table = {{MENU_MODE_MAIN_TOWN, MENU_MODE_MAIN_DUNGEON}};
                        MenuCommonInfo->now_mode = page_table.next[page];
                        MenuCommonInfo->key_enable = 1;

                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 1;
                        }

                        MenuCommonInfo->CursorFadeIn(10.0f, 1);
                        MenuCommonInfo->SetVibeCnt(60, 30);
                        CMenuInterPt->cursor_jump = 1;
                        MenuPosData->FormInfoClear(10, 80);
                        MenuPosData->InitDrawList();
                        result = 0;
                        CMenuInterPt->step = 0;
                        CMenuInterPt->help_update = 1;
                        (&MenuCommonInfo->cursor)[0] = CMenuInterPt->select_no;

                        if (menu == 11 || menu == 6) {
                            (&MenuMainScene->fade)->FadeIn(40);
                            ReturnMenuIntern(0);
                        }

                        MenuTopicAlphaCalc = 0;
                    }
                } break;
            }

            break;
        case 2:
            if (MenuCommonInfo->now_mode == 4) {
                (&MenuMainScene->fade)->FadeIn(40);
            }

            break;
    }

    MenuItemCommandCounter++;

    if (MenuItemCommandCounter > 10000000) {
        MenuItemCommandCounter = 0;
    }

    MenuCommonInfo->frame_parity ^= 1;
    MenuCommonInfo->StepMenuBGM();
    MenuDrawParamStep();

    if (init_1524 == 0) {
        refresh_cnt_1523 = 0;
        init_1524 = 1;
    }

    refresh_cnt_1523++;

    if (refresh_cnt_1523 >= 25) {
        refresh_cnt_1523 = 0;
        UserDataRefresh();
    }

    MenuDoubleDrawCheck = 0;
    return result;
}

void MenuMainDraw() {
    mgCDrawPrim *prim;
    int          next_page;

    if (MenuDoubleDrawCheck == 0) {
        prim = GetMenuPrim();
        prim->offset_x = 0;
        prim->offset_y = 0;
        DrawMenuFillBox(0x80, 0, 0, 0);
        prim->offset_x = 0;
        prim->offset_y = 0;
        menu_drawfunctbl[MenuCommonInfo->now_mode]();

        if (menu_debug_flag != 0) {
            MenuDebugModeDraw();
        }

        MenuPolygonEnvReset();
        (&MenuMainScene->fade)->Draw();
        next_page = MenuCommonInfo->next_mode;

        if (next_page >= 0) {
            if (MenuCommonInfo->now_mode != next_page) {
                MenuCommonInfo->now_mode = next_page;
                MenuCommonInfo->next_mode = -1;
            }
        }

        MenuDoubleDrawCheck = 1;
    }
}

int NextMenuInit(int menu, mgCMemory *memory, int *args) {
    int   page;
    int   known;
    int   dungeon_mode;
    char *map_name;

    page = MenuCommonInfo->open_type;
    known = 1;

    switch (menu) {
        case 2:
            MenuItemInit(memory, args, page);
            break;
        case 4:
            MenuCharaChangeInit(memory, args, page);
            break;
        case 5:
        case 16:
            MenuInventInit(memory, args, page);
            break;
        case 11:
            dungeon_mode = 0;

            if (MenuMainScene != NULL) {
                dungeon_mode = MenuSaveDataDungeonPtr->stage_id;
            }

            if (TreeMapCallDungeonSubMap != 0) {
                map_name = MenuMainScene->GetMapName(MenuMainScene->active_map);

                if (strcmp(map_name, "s05") == 0) {
                    dungeon_mode = 1;
                }

                if (strcmp(map_name, "d04b01") == 0) {
                    dungeon_mode = 3;
                }
            }

            DngTreeMapInit(memory, args, page, dungeon_mode);
            break;
        case 18:
            MenuAquaInit(memory, args, page);
            break;
        case 6:
            WorldMoveInit(memory, args, page);
            break;
        case 8:
            MenuManualInit(memory, args, page);
            break;
        case 7:
            MenuOptionInit(memory, args, page);
            break;
        default:
            known = 0;
            break;
    }

    if (known != 0) {
        MenuCommonInfo->next_mode = menu;
    } else {
        MenuCommonInfo->next_mode = -1;
    }

    return known;
}

void MenuCamInit(float roll) {
    *(u_long128 *) MenuDrawEnv->ref = *(u_long128 *) menu_basedgRef;
    *(u_long128 *) MenuDrawEnv->pos = *(u_long128 *) menu_basedgCamPos;
    MenuDrawEnv->speed = roll;
    MenuDrawEnv->camera.Resume();
}

void MenuWorldTrans() {
    mgCCamera *camera;
    float      view_matrix[4][4];
    float      pos[4];
    float      world_matrix[4][4];
    float      identity[4][4];

    mgSetProjection(MenuDrawEnv->projection);
    camera = &MenuDrawEnv->camera;
    MenuDrawEnv->camera.GetCameraMatrix(view_matrix);
    camera->GetPos(pos);
    camera->SetSpeed(MenuDrawEnv->speed, -1.0f);
    camera->SetNextRef(MenuDrawEnv->ref);
    camera->SetNextPos(MenuDrawEnv->pos);
    camera->Step(1);
    sceVu0UnitMatrix(identity);
    sceVu0MulMatrix(world_matrix, identity, view_matrix);
    mgSetViewMatrix(world_matrix, pos);
}

void MenuPolygonSetEnv() {
    mgGetAmbient(MenuDrawEnv->old_ambient);
    mgSetAmbient(MenuDrawEnv->ambient);
}

void MenuPolygonEnvReset() {
    mgSetAmbient(MenuDrawEnv->old_ambient);
}

char *GetMenuCfgFileName(int index, int unused) {
    int local;

    sprintf(workchr_1622, "menu/%d/", LanguageCode);
    strcat(workchr_1622, menu_main_cfgname_1620[index]);
    printf("menu_stack ptr : %p\n", &local);
    return workchr_1622;
}

short *GetMenuMainMessageBuffer() {
    int size;

    return (short *) GetPackFile(MenuArg.pack, "allmenu.mes", &size);
}

u_char *GetMenuMainIMGPtr() {
    return (u_char *) GetPackFile(MenuArg.pack, "frametex.img", 0);
}

char *GetMenuMainPosCfgBuffer(int *size) {
    return (char *) GetPackFile(MenuArg.pack, "menu0.cfg", size);
}

void SetCommonMenuModeID() {
    int table;
    int bit_ctrl;
    int i;

    table = MenuCommonInfo->open_type;
    bit_ctrl = GetSaveData()->GetBitCtrl();

    if (table == 0x10) {
        table = 0;
    }

    if (table == 0x11) {
        table = 1;
    }

    if ((unsigned int) table < 2) {
        for (i = 0; i < 8; i++) {
            CommonMenuModeID2[i] = CommonMenuModeID[table][i];

            if (CommonMenuModeID2[i] == 6 && (bit_ctrl & 0x10)) {
                CommonMenuModeID2[i] = 11;
                TreeMapCallDungeonSubMap = 1;
            }
        }
    }
}

int *GetCommonMenuModeID() {
    return CommonMenuModeID2;
}

int CursorSaveOptionState() {
    CSaveData *save_data = GetSaveData();
    int        r = 0;

    if (save_data != NULL) {
        r = (u8) !*(int *) &save_data->config;
    }

    return r;
}

void ReturnMenuIntern(int index) {
    char *action = acttbl_1682[index];

    if (MenuAreaBrdForm != NULL) {
        MenuAreaBrdForm->SetAction(action);
    }

    if (MenuTimeBrdForm != NULL) {
        MenuTimeBrdForm->SetAction(action);
    }
}

void MenuAreaBoardNameStep() {
    CDC2Mes       *message;
    float          hours;
    float          minutes;
    int            day;

    if (MenuAreaBrdForm != NULL) {
        AreaNameItems names = {{NULL, NULL}};
        names.name[0] = MenuAreaName;
        message = MenuDCMsg[1];
        message->MakeMsg(0x32);
        message->SetMsgItemNo(names.name, 1);
        message->GetStrWidth(names.name[0]);
        BoardPosition position = {{0, 0}};
        MenuAreaBrdForm->GetNextMovePos(position.value);
        LanguageWidths widths = {{98, 122, 122, 122, 122, 122, 122, 122, 122}};
        message->SetMovePosCenteringGyou(0, position.value[0] + widths.value[LanguageCode],
                                         position.value[1] + 7);

        if (MenuTimeBrdForm != NULL) {
            hours = (int) MenuNowTime;
            minutes = (int) (60.0f * (MenuNowTime - hours));

            if (minutes < 0.0f) {
                minutes = 0.0f;
            }

            if (59.0f < minutes) {
                minutes = 59.0f;
            }

            day = MenuActiveSaveData->day + 1;

            if (day > 9999) {
                day = 9999;
            }

            MenuTimeBrdForm->SetNumber("\x93\xFA\x8A\xD4", day);

            if (MenuNowMapType == 5 || MenuNowMapType == 6) {
                MenuTimeBrdForm->SetPartDrawFlag("AM", false);
                MenuTimeBrdForm->SetPartDrawFlag("PM", false);
                MenuTimeBrdForm->SetPartDrawFlag("\x8E\x9E", false);
                MenuTimeBrdForm->SetPartDrawFlag("\x95\xAA", false);
                MenuTimeBrdForm->SetPartDrawFlag(";", false);
            } else {
                MenuTimeBrdForm->SetPartDrawFlag("\x96\xA2\x97\x88", false);

                if (LanguageCode == 3) {
                    MenuTimeBrdForm->SetPartDrawFlag("AM", false);
                    MenuTimeBrdForm->SetPartDrawFlag("PM", false);
                } else if (12.0f <= hours) {
                    MenuTimeBrdForm->SetPartDrawFlag("AM", false);
                    MenuTimeBrdForm->SetPartDrawFlag("PM", true);
                    hours -= 12.0f;
                } else {
                    MenuTimeBrdForm->SetPartDrawFlag("AM", true);
                    MenuTimeBrdForm->SetPartDrawFlag("PM", false);
                }
            }

            if (LanguageCode != 3 && LanguageCode > 0 && hours == 0.0f) {
                hours = 12.0f;
            }

            MenuTimeBrdForm->SetNumber("\x8E\x9E", (int) hours);
            MenuTimeBrdForm->SetNumber("\x95\xAA", (int) minutes);
        }
    }
}

short CheckEventDay(int *remaining_hours) {
    int day = GetSaveData()->day;
    int event_index = GetSaveData()->CheckEventDay(day);

    if (event_index < 0) {
        return 0;
    }

    float time = GetSaveData()->now_time;
    int   tour_event = GetSaveData()->CheckNowTourEvent();
    int   tour_type = GetSaveData()->CheckNowTourType();

    if (remaining_hours != NULL) {
        *remaining_hours = 0;
    }

    int days_into_cycle = event_index % 10;

    if (days_into_cycle > 2) {
        return 0;
    }

    if (tour_event == 0) {
        return 0;
    }

    if (remaining_hours != NULL) {
        *remaining_hours = (3 - days_into_cycle) * 24 - (int) time;
    }

    if (tour_type == 0) {
        return 0;
    }

    if (tour_type == 1) {
        return 1;
    }

    if (tour_type == 2) {
        return 2;
    }

    return 0;
}

void MakeMenuTopic() {
    char text[0x80];
    int  day;
    int  height;
    int  width;

    MenuTopicType = 0;
    MenuTopicAlpha = 0;
    MenuTopicAlphaCalc = 0;
    day = 0;
    MenuTopicType = CheckEventDay(&day);
    sprintf(text, topic_tbl_1777[LanguageCode][MenuTopicType], day);
    TopicFont.SetStr(text);
    TopicFont.CalcDrawWH(TopicFont.str, &width, &height);
    MenuTopicLength = width;
    TopicFontX = 30;
}
void DrawMenuTopic(void) {
    mgRect<int> box;
    float x;
    float y;
    float w;
    float h;

    if (MenuTopicType <= 0 || MenuNowMapType == 5 || MenuNowMapType == 6) {
        return;
    }
    if (MenuTopicAlphaCalc == 0) {
        CalcMenuAdd(&MenuTopicAlpha, 4, 0x80);
    } else if (MenuTopicAlphaCalc == 1) {
        CalcMenuAdd(&MenuTopicAlpha, -18, 0);
    }
    box.Set(20, 36, 200, 60);
    if (MenuTopicAlpha > 0) {
        mgCTextureManager *manager = &mgTexManager;
        mgCDrawPrim *prim = GetMenuPrim();
        manager->ReloadTexture(TopicTex->block, (sceVif1Packet *)NULL);
        SetSpriteEnv(prim, 0);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(TopicTex);
        prim->Color(0x80, 0x80, 0x80, MenuTopicAlpha);
        int title_width = 0x28;
        if (LanguageCode == 3) {
            title_width = 0x32;
        }
        PrimQuad(prim, 22.0f, 22.0f, mgRect<int>(0x66, 0, title_width, 0xC));
        prim->End();
        manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        SetSpriteEnv(prim, 1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Color(0x2A, 0x22, 0x1E, MenuTopicAlpha * 6 / 10);
        prim->Vertex(box.left - 2, box.top - 2, 0);
        prim->Vertex(box.right + 2, box.bottom + 2, 0);
        prim->End();
        SetMenuScissor(box);
        TopicFontX--;
        if (TopicFontX < 0x1E - MenuTopicLength) {
            TopicFontX = 0xD2;
        }
        TopicFont.alpha = MenuTopicAlpha;
        TopicFont.SetPos(TopicFontX, 0x26);
        TopicFont.DrawDirect(TopicFont.str, TopicFont.pos_x, TopicFont.pos_y);
        ResetMenuScissor();
        menu_maintopic_colortbl_shadow[0][3] = menu_maintopic_colortbl_shadow[2][3] = 64.0f * (float)MenuTopicAlpha / 128.0f;
        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
        h = 24.0f;
        w = 40.0f;
        x = 20.0f;
        y = 36.0f;
        mgRect<float> fill0(x, y, w, h);
        PrimFillRect4(prim, fill0, menu_maintopic_colortbl_shadow[0], menu_maintopic_colortbl_shadow[1], menu_maintopic_colortbl_shadow[2], menu_maintopic_colortbl_shadow[3]);
        prim->End();
        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
        h = 24.0f;
        w = 40.0f;
        x = 162.0f;
        y = 36.0f;
        mgRect<float> fill1(x, y, w, h);
        PrimFillRect4(prim, fill1, menu_maintopic_colortbl_shadow[1], menu_maintopic_colortbl_shadow[0], menu_maintopic_colortbl_shadow[3], menu_maintopic_colortbl_shadow[2]);
        prim->End();
        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
        h = 24.0f;
        w = 90.0f;
        x = 20.0f;
        y = 36.0f;
        mgRect<float> fill2(x, y, w, h);
        PrimFillRect4(prim, fill2, menu_maintopic_colortbl[1], menu_maintopic_colortbl[0], menu_maintopic_colortbl[3], menu_maintopic_colortbl[2]);
        prim->End();
        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
        h = 24.0f;
        w = 90.0f;
        x = 110.0f;
        y = 36.0f;
        mgRect<float> fill3(x, y, w, h);
        PrimFillRect4(prim, fill3, menu_maintopic_colortbl[0], menu_maintopic_colortbl[1], menu_maintopic_colortbl[2], menu_maintopic_colortbl[3]);
        prim->End();
    }
}
int MenuInternInit(mgCMemory *stack, int open_type, int capture) {
    MenuArg.end_code = 0;
    if (capture != 0) {
        MenuCapture(MenuCommonInfo->tex_block[0], stack, 1);
    }
    int early_game = 1;
    if (CheckBitFlagMenu(0x36) != 0) {
        early_game = 0;
    }
    CMenuInterPt = &CMenuInterStatic;
    CMenuInterPt->Initialize(0);
    if (open_type == 10) {
        MenuCommonInfo->now_mode = 0;
    } else {
        open_type = GetMenuLoopType();
        CMenuInterPt->mode_list = GetCommonMenuModeID();
        MenuCommonInfo->now_mode = open_type;
    }
    MenuMainImageDataEnter(MenuCommonInfo->tex_block[1]);
    MenuInterMes = new (stack->Alloc(0x2A7)) CDC2Mes;
    int script_size;
    char *config = GetMenuMainPosCfgBuffer(&script_size);
    char *script = (char *)(stack->stack + stack->stack_used) + (stack->stack_size - stack->stack_used) * 16 - 0x32000;
    memcpy(script, config, script_size);
    MenuDataAnalyze(script, script_size, stack);
    AttachMessageForm();
    MenuAreaBrdForm = MenuPosData->GetFormInfo("areaboard");
    MenuTimeBrdForm = MenuPosData->GetFormInfo("timeboard");
    if (early_game != 0) {
        if (MenuTimeBrdForm != NULL) {
            MenuTimeBrdForm->draw_flag = 0;
            MenuTimeBrdForm = NULL;
        }
    }
    MenuFormMI2 = MenuPosData->GetFormInfo("mi2");
    TopicTex = mgTexManager.GetTexture("mnmain", -1);
    MenuDCMsg[0]->MsgPreset(3);
    MenuDCMsg[1]->MsgPreset(5);
    MenuDCMsg[1]->value_sign = 0;
    MenuDCMsg[1]->value_zero = 1;
    MenuMesForm[0]->draw_flag = 1;
    MenuMesForm[1]->draw_flag = 1;
    MenuInterMesDrawFlag = 0;
    MenuPosData->AttachCommonTexInfo();
    HatumeiMenuOkFlag = 0;
    if (0 < MenuUserDataManPtr->GetNumSameItem(0x171)) {
        HatumeiMenuOkFlag = 1;
    }
    ManualMenuOkFlag = 0;
    if (0 < MenuUserDataManPtr->GetNumSameItem(0x167)) {
        ManualMenuOkFlag = 1;
    }
    if (OmakeFlag == 1) {
        if (GetNowLoopNo() == 2) {
            ManualMenuOkFlag = 1;
        }
    }
    WorldMapOkFlag = 1;
    DngMoveMenuOkFlag = 1;
    if (early_game != 0) {
        WorldMapOkFlag = 0;
        DngMoveMenuOkFlag = 0;
    }
    if (open_type != 10) {
        MenuMainSubDataPackAdr = stack->stack + stack->stack_used;
        MenuCommonReadData(stack, fname_1858, 0);
        MenuMainFrameModeSet(0, 1);
        int icon_count = 0;
        for (int k = 0; 0 <= CMenuInterPt->mode_list[k]; k++) {
            icon_count++;
        }
        MovePoint origin = {50, 40};
        MovePoint pos = {-260, 0};
        MovePoint step = {20, 40};
        for (int icon = 0; icon < icon_count; icon++) {
            char *name = GetMenuMainIconChar(CMenuInterPt->mode_list[icon]);
            pos.y = origin.y + step.y * icon;
            MenuPosData->SetFormPos(name, &pos.x);
        }
        bool shown = true;
        bool hidden = false;
        CMenuPosDataForm *form = MenuPosData->GetFormInfo("mi3");
        if (form != NULL) {
            if (HatumeiMenuOkFlag == 0) {
                shown = false;
                hidden = true;
            }
            form->SetPartDrawFlag("mi0", shown);
            form->SetPartDrawFlag("mi1", hidden);
        }
        bool manual_hidden;
        CMenuPosDataForm *manual_form = MenuPosData->GetFormInfo("mi6");
        if (manual_form != NULL) {
            bool manual_shown = true;
            manual_hidden = false;
            if (ManualMenuOkFlag == 0) {
                manual_shown = false;
                manual_hidden = true;
            }
            manual_form->SetPartDrawFlag("mi0", manual_shown);
            manual_form->SetPartDrawFlag("mi1", manual_hidden);
        }
        bool world_hidden;
        CMenuPosDataForm *world_form = MenuPosData->GetFormInfo("mi4");
        if (world_form != NULL) {
            bool world_shown = true;
            world_hidden = false;
            if (WorldMapOkFlag == 0) {
                world_shown = false;
                world_hidden = true;
            }
            world_form->SetPartDrawFlag("mi0", world_shown);
            world_form->SetPartDrawFlag("mi1", world_hidden);
            if (GetMenuLoopType() == MENU_LOOP_DUNGEON) {
                world_form->draw_flag = 0;
            }
        }
        bool floor_hidden;
        CMenuPosDataForm *floor_form = MenuPosData->GetFormInfo("mi9");
        if (floor_form != NULL) {
            bool floor_shown = true;
            floor_hidden = false;
            if (DngMoveMenuOkFlag == 0) {
                floor_shown = false;
                floor_hidden = true;
            }
            floor_form->SetPartDrawFlag("mi0", floor_shown);
            floor_form->SetPartDrawFlag("mi1", floor_hidden);
            if (GetMenuLoopType() == MENU_LOOP_TOWN) {
                floor_form->draw_flag = 0;
            }
        }
    }
    CMenuInterPt->help_update = 1;
    CMenuInterPt->step = MENU_INTER_STEP_OPEN;
    MenuCommonInfo->cursor = -1;
    MenuCommonInfo->AttachFuncData();
    MenuCommonInfo->key_enable = 0;
    if (MenuCommonInfo->cursor_form != NULL) {
        MenuCommonInfo->cursor_form->draw_flag = 0;
    }
    MenuCommonInfo->SetWakuType(-1);
    return 1;
}
void CMenuInter::Initialize(int unused) {
    step = 1;
    select_no = 0;
    select_num = 6;
    mode_list = NULL;
    bg_read_step = 0;
    bg_read_wait = 30;
    cursor_jump = 1;
    next_mode = -1;
    help_update = 0;
}

void MenuCommonBaseDataEnter(mgCMemory *pallet_memory, unsigned int *pack, int pack_size, int block) {
    mgCTextureManager *tex = &mgTexManager;
    int                size;
    MenuMainTextureReadBuf.stSetBuffer((u_long128 *) pack, pack_size / 16);
    mgTexManager.EnterIMGFile((u8 *) GetPackFile(pack, "edmenu.img", 0), block, 0, 0);
    mgTexManager.EnterIMGFile((u8 *) GetPackFile(pack, "allitem.img", &size), block, 0, 0);
    u8 *image = (u8 *) GetPackFile(pack, "spectre.img", 0);

    if (image) {
        tex->EnterIMGFile(image, block, 0, 0);
    }

    (MenuPosData)->AttachCommonTexInfo();
    MenuItemIconTextureBlock = block;
    (MenuPosData)->MallocPallet(pallet_memory);
    (MenuPosData)->SearchTransPalletNo();
    MenuPosData->ResetTextureInfoAll();
}

void MenuBaseTextureReEnter() {
    mgCTextureManager *tex = &mgTexManager;
    int                block = MenuCommonInfo->tex_block[1];
    tex->DeleteBlock(block);
    MenuMainImageDataEnter(block);
    unsigned int *pack = (unsigned int *) MenuMainTextureReadBuf.stack;
    int           size;
    tex->EnterIMGFile((u8 *) GetPackFile(pack, "edmenu.img", 0), block, 0, 0);
    tex->EnterIMGFile((u8 *) GetPackFile(pack, "allitem.img", &size), block, 0, 0);
    u8 *image = (u8 *) GetPackFile(pack, "spectre.img", 0);

    if (image) {
        tex->EnterIMGFile(image, block, 0, 0);
    }

    (MenuPosData)->AttachCommonTexInfo();
    MenuPosData->ResetTextureInfoAll();
}
void CMenuInter::InitEnd() {
    int base_block = MenuCommonInfo->tex_block[1];
    mgCTextureManager *manager = &mgTexManager;
    BG_READ_INFO *base_data = GetReadBGFile(0);
    if (base_data != NULL) {
        MenuCommonBaseDataEnter(&MenuMainStack, (u_int *)base_data->buffer, base_data->size, base_block);
        help_update = 1;
        MenuMainStack.Align64();
        int remain = MenuMainStack.stGetRest();
        MenuMainStack_Next.stSetBuffer(MenuMainStack.stGetTop(), remain);
    }
    MenuCommonInfo->cursor = 0;
    step = 0;
    MenuCommonInfo->key_enable = 1;
    CMenuPosDataForm *cursor_form_ptr = MenuCommonInfo->cursor_form;
    if (cursor_form_ptr != NULL) {
        cursor_form_ptr->draw_flag = 1;
    }
    MenuCommonInfo->CursorFadeIn(10.0f, 1);
    MenuCommonInfo->SetWakuType(-1);
    CMenuPosDataForm *board = MenuPosData->GetFormInfo("mi00");
    if (board != NULL) {
        int pos[2] = {(int)(board->x - 30.0f), (int)(4.0f + board->y)};
        SetFormPoint(MenuCommonInfo->cursor_form, (int)(board->x - 30.0f), (int)(4.0f + board->y));
        MenuCommonInfo->cursor_form->SetNextMovePos(pos, 2);
        CMenuPosDataForm *next_form = MenuPosData->GetFormInfo("cur_waku0");
        if (next_form != NULL) {
            pos[0] = (int)board->x;
            pos[1] = (int)(4.0f + board->y);
            SetFormPoint(next_form, (int)board->x, (int)(4.0f + board->y));
            next_form->SetNextMovePos(pos, 2);
        }
    }
    ReturnMenuIntern(0);
    MenuEtcInfo.tex_block = MenuArg.mes_tex_block;
    MenuEtcInfo.tex = manager->GetTexture("mnmain", -1);
}
void CMenuInter::PushOk() {
    int mode = mode_list[select_no];
    MenuCommonInfo->SetWakuType(-1);
    int show_message = 0;
    int message_no = -1;
    int enable = 1;
    switch (mode) {
    case MENU_MODE_MANUAL:
        if (ManualMenuOkFlag == 0) {
            enable = 0;
        }
        break;
    case MENU_MODE_INVENT:
        if (HatumeiMenuOkFlag == 0) {
            enable = 0;
        }
        break;
    case MENU_MODE_ITEM:
    case MENU_MODE_CHARA_CHANGE:
    case MENU_MODE_AQUA:
    case MENU_MODE_OPTION:
        break;
    case MENU_MODE_WORLD_MOVE:
        if (MenuNowMapType == 5 || MenuNowMapType == 6) {
            show_message = 1;
            message_no = 0x28;
            if (CheckBitFlagMenu(0x258) == 1) {
                if (CheckBitFlagMenu(0x2E0) == 0) {
                    message_no = 0x2E;
                }
            }
            enable = 0;
        } else if (WorldMapOkFlag == 0) {
            enable = 0;
        } else if (MenuActiveSaveData->GetBitCtrl() & 1) {
            show_message = enable;
            message_no = 0x2A;
            enable = 0;
        } else {
            MenuMainScene->fade.FadeOut(0x28, 0.0f, 0.0f, 0.0f);
        }
        break;
    case MENU_MODE_DNG_TREE_MAP:
        if (DngMoveMenuOkFlag == 0) {
            enable = 0;
        } else if (MenuActiveSaveData->GetBitCtrl() & 1) {
            show_message = enable;
            message_no = 0x2A;
            enable = 0;
        } else {
            MenuMainScene->fade.FadeOut(0x28, 0.0f, 0.0f, 0.0f);
        }
        break;
    default:
        enable = 0;
        break;
    }
    if (show_message != 0) {
        step = MENU_INTER_STEP_MESSAGE;
        MenuInterMes->Init();
        MenuInterMes->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        MenuInterMes->MsgPreset(10);
        MenuInterMes->MakeMsg(message_no);
        MenuInterMes->SetAbsPos(5);
        MenuInterMesDrawFlag = 1;
        CMenuKeyFunc *common = MenuCommonInfo;
        if (common->cursor_form != NULL) {
            common->cursor_form->draw_flag = 0;
        }
    }
    if (enable != 0) {
        next_mode = mode;
        MenuCommonInfo->key_enable = 0;
        MenuCommonInfo->CursorFadeOut(1.0f, 0);
        MenuSePlay(0x13);
        bg_read_wait = 0;
        CMenuPosDataForm *form = MenuFormMI2;
        if (form != NULL) {
            form->rate_x = 4.0f;
            form->rate_y = 4.0f;
            if (next_mode == MENU_MODE_CHARA_CHANGE) {
                CMenuPosDataForm *current = MenuFormMI2;
                current->rate_x = 4.0f;
                current->rate_y = 12.0f;
            }
        }
        if (next_mode != MENU_MODE_DNG_TREE_MAP && next_mode != MENU_MODE_WORLD_MOVE) {
            ReturnMenuIntern(1);
            MenuTopicAlphaCalc = 1;
        }
    } else {
        next_mode = -1;
        MenuCommonInfo->next_mode = -1;
        MenuSePlay(5);
    }
}
int CMenuInter::ReadBGTexture(int bg_no, int restart) {
    char   name[0x80];
    char **entry;

    if (restart != 0) {
        bg_read_wait = 30;
        bg_read_step = 0;
    }

    if (0 < bg_read_wait) {
        bg_read_wait -= 1;
    }

    if (bg_read_step == 0 && bg_read_wait <= 0) {
        BreakReadBG();
        StartReadBG();
        MenuMainStack_Next.stack_used = 0;
        MenuMainStack_Next.lock = 0;
        entry = &filetbl_2141[bg_no - 2];

        if (strlen(*entry) != 0) {
            unsigned int size;
            strcpy(name, *entry);
            size = LoadFileMenu(
                name, (MenuMainStack_Next.stack + MenuMainStack_Next.stack_used), 0);
            MenuMainStack_Next.Alloc((size & 15) ? (size >> 4) + 1 : size >> 4);
            bg_read_step = 1;
        } else {
            MenuMainStack_Next.stack_used = 0;
            MenuMainStack_Next.lock = 0;
            bg_read_step = 2;
        }
    } else if (bg_read_step == 1) {
        ReadBG();

        if (ReadBGSync() == 0) {
            bg_read_step = 2;
        }
    }

    return bg_read_step == 2;
}
int MenuInternSelectKey(void) {
    int result = 0;
    int select_key = MenuCommonInfo->CheckSelectKey();
    int push = MenuCommonInfo->CheckPushButton();
    int old_select = CMenuInterPt->select_no;
    char moved = 0;
    if (CMenuInterPt->step == MENU_INTER_STEP_MESSAGE) {
        select_key = 0;
    }
    int direction = 0;
    if (select_key & 1) {
        direction -= 1;
    }
    if (select_key & 2) {
        direction += 1;
    }
    if (MenuKeySelectCheck(direction, &CMenuInterPt->select_no, NULL, 0, CMenuInterPt->select_num, CMenuInterPt->select_num, 1) != 0 &&
        CMenuInterPt->step == MENU_INTER_STEP_SELECT) {
        moved = 1;
        MenuSePlay(SYSTEM_SE_CURSOR);
        CMenuInterPt->help_update = moved;
    }
    int *mode_list = CMenuInterPt->mode_list;
    int closing = 0;
    if (CMenuInterPt->step == MENU_INTER_STEP_CLOSE) {
        closing = 1;
    }
    int mode = -1;
    if (CMenuInterPt->select_no >= 0) {
        mode = mode_list[CMenuInterPt->select_no];
    }
    int next_mode = CMenuInterPt->next_mode;
    if (next_mode == MENU_MODE_CHARA_CHANGE || next_mode == MENU_MODE_DNG_TREE_MAP || next_mode == MENU_MODE_WORLD_MOVE) {
        closing = 0;
    }
    if ((next_mode != MENU_MODE_DNG_TREE_MAP && next_mode != MENU_MODE_WORLD_MOVE) || GetMenuMainFrameEndFlag() == 0) {
        MenuPosData->StepMainMenuIconMove(mode_list, mode, closing);
    }
    CMenuPosDataForm *icon_form = MenuPosData->GetFormInfo(GetMenuMainIconChar(mode));
    if (old_select != CMenuInterPt->select_no && abs(old_select - CMenuInterPt->select_no) > 1) {
        CMenuInterPt->cursor_jump = 1;
    }
    if (icon_form != NULL) {
        MovePoint pos = {0, 0};
        pos.x = (int)(icon_form->x - 42.0f);
        pos.y = (int)icon_form->y;
        MenuCommonInfo->MenuPosStep(&pos.x, NULL);
        if (CMenuInterPt->cursor_jump != 0) {
            SetCursorPos(MenuCommonInfo, &pos.x);
            CMenuInterPt->cursor_jump = 0;
        }
    }
    MenuCommonInfo->SetWakuType(-1);
    if (CMenuInterPt->help_update != 0) {
        if (CMenuInterPt->select_no >= 0) {
            mode = mode_list[CMenuInterPt->select_no];
            int message = mode + 10;
            if ((mode == MENU_MODE_INVENT && HatumeiMenuOkFlag == 0) || (mode == MENU_MODE_MANUAL && ManualMenuOkFlag == 0) ||
                (mode == MENU_MODE_WORLD_MOVE && WorldMapOkFlag == 0) || (mode == MENU_MODE_DNG_TREE_MAP && DngMoveMenuOkFlag == 0)) {
                message = 30;
            }
            MenuDCMsg[0]->MakeMsg(message);
        }
        CMenuInterPt->help_update = 0;
    }
    int frame_end = GetMenuMainFrameEndFlag();
    switch (CMenuInterPt->step) {
    case MENU_INTER_STEP_OPEN:
        if (frame_end != 0 && ReadBGSync() == 0) {
            CMenuInterPt->InitEnd();
            SetMenuFrameRate(1);
        }
        break;
    case MENU_INTER_STEP_CLOSE:
        if (frame_end != 0) {
            result = 1;
        }
        break;
    case MENU_INTER_STEP_MESSAGE:
        MenuInterMes->StepMsg();
        if (push != 0) {
            MenuSePlay(SYSTEM_SE_DECIDE);
            MenuInterMesDrawFlag = 0;
            CMenuInterPt->step = MENU_INTER_STEP_SELECT;
            if (MenuCommonInfo->cursor_form != NULL) {
                MenuCommonInfo->cursor_form->draw_flag = 1;
            }
        }
        break;
    default:
        if (mode >= 0) {
            CMenuInterPt->ReadBGTexture(mode, moved);
            next_mode = CMenuInterPt->next_mode;
            if (next_mode >= 0 && CMenuInterPt->bg_read_step >= MENU_INTER_BG_READ_DONE) {
                if ((next_mode != MENU_MODE_DNG_TREE_MAP && next_mode != MENU_MODE_WORLD_MOVE) ||
                    ((next_mode == MENU_MODE_DNG_TREE_MAP || next_mode == MENU_MODE_WORLD_MOVE) &&
                     MenuMainScene->fade.FadeCheck() != 0)) {
                    MenuMainStack_Next.Align64();
                    if (NextMenuInit(CMenuInterPt->next_mode, &MenuMainStack_Next, &MenuCommonInfo->tex_block[3]) != 0) {
                        if (CMenuInterPt->next_mode != MENU_MODE_DNG_TREE_MAP && CMenuInterPt->next_mode != MENU_MODE_WORLD_MOVE) {
                            MenuSePlay(2);
                        }
                    }
                    CMenuInterPt->next_mode = -1;
                }
            }
        }
        if (menu_debug_flag != 0) {
            if (GamePad__2.Down(PAD_CIRCLE) != 0) {
                MenuActiveSaveData->day += 1;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            if (GamePad__2.Down(PAD_CROSS) != 0) {
                MenuActiveSaveData->SetBitFlag(0x36, 1);
            }
            if (GamePad__2.Down(PAD_TRIANGLE) != 0) {
                MenuActiveSaveData->SetBitFlag(0x36, 1);
                MenuActiveSaveData->SetBitFlag(SAVE_FLAG_FISHING_CONTEST_UNLOCKED, 1);
                MenuActiveSaveData->SetBitFlag(SAVE_FLAG_FINNY_FRENZY_UNLOCKED, 1);
                MenuActiveSaveData->ForceBootTour(MenuActiveSaveData->day, 1);
            }
            GamePad__2.Down(PAD_SQUARE);
            return 0;
        }
        switch (push) {
        case 1:
        case 4:
        case 8:
            CMenuInterPt->PushOk();
            break;
        case 2:
            CMenuInterPt->step = MENU_INTER_STEP_CLOSE;
            CMenuInterPt->select_no = -1;
            MenuTopicAlphaCalc = 1;
            MenuCommonInfo->key_enable = 0;
            MenuCommonInfo->cursor = -1;
            MenuCommonInfo->SetWakuType(-1);
            if (MenuCommonInfo->cursor_form != NULL) {
                MenuCommonInfo->cursor_form->draw_flag = 0;
            }
            ReturnMenuIntern(1);
            MenuMainFrameModeSet(1, 1);
            MenuMesForm[0]->SetAction("\x8A\x4F\x82\xD6");
            MenuSePlay(5);
            break;
        }
        break;
    }
    MenuPosData->FormStep();
    return result;
}
/**
 * Draws the internal menu's message, topic ticker and debug status.
 */
void MenuInternSelectDraw(void) {
    MenuPosData->FormDraw();
    if (MenuInterMesDrawFlag != 0 && MenuInterMes != NULL) {
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, static_cast<sceVif1Packet *>(NULL));
        MenuInterMes->DrawMsg();
    }
    DrawMenuTopic();
    if (menu_debug_flag != 0) {
        DrawMenuFillBox(360.0f, 60.0f, static_cast<float>(mgScreenWidth - 360), 80.0f, 0x40, 0, 0, 0);
        CMenuFont font;
        char      text[0x100];
        text[0] = 0;
        int bit_ctrl = MenuActiveSaveData->GetBitCtrl();
        if (bit_ctrl & MENU_DEBUG_BIT_CTRL_NO_MOVE) {
            strcat(text, "Not Move\n");
        }
        if (bit_ctrl & MENU_DEBUG_BIT_CTRL_NO_GEORAMA) {
            strcat(text, "Not Georama\n");
        }
        if (bit_ctrl & MENU_DEBUG_BIT_CTRL_NO_FISHING) {
            strcat(text, "Not Fishing\n");
        }
        if (bit_ctrl & MENU_DEBUG_BIT_CTRL_ATRA_OFF) {
            strcat(text, "Atra OFF\n");
        }
        if (bit_ctrl & MENU_DEBUG_BIT_CTRL_BOOT_TREEMAP) {
            strcat(text, "Boot Treemap\n");
        }
        if (bit_ctrl == 0) {
            strcpy(text, "\x89\xBD\x82\xE0\x8B\xD6\x8E~\n\x82\xB3\x82\xEA\x82\xC4\x82\xA2\x82\xDC\x82\xB9\x82\xF1");
        }
        font.DrawDirect(text, 360, 60);
        DrawMenuFillBox(300.0f, 350.0f, 190.0f, 60.0f, 0x40, 0, 0, 0);
        font.DrawDirect("\x81\x9B:Add Day\n\x81~:View Opening\n\x81\xA2\x81" "FBoot FishEvent", 300, 350);
    }
}

void CopyActiveItemAndWeapon(int slot, int weapon_slot) {
    mgCTexture *textures[2];

    mgCTextureManager *manager = &mgTexManager;
    textures[0] = manager->GetTexture("icon_dmy1", -1);
    textures[1] = manager->GetTexture("icon_dmy2", -1);

    if (textures[0] == NULL || textures[1] == NULL) {
        return;
    }

    CopyActiveIconTexture(textures, slot, 0);
    manager->ReloadTexture(-1, (sceVif1Packet *) 0);
}
int CopyActiveIconTexture(mgCTexture **textures, int chara_no, u_int *unused) {
    CUserDataManager *user = GetUserDataMan();
    int offset;
    if (user == NULL) {
        return 0;
    }
    mgCTextureManager *manager = &mgTexManager;
    u_long128 *icon_clut[2];
    mgCTexture *icon_sheet[2];
    icon_sheet[0] = manager->GetTexture("itemicon", -1);
    icon_sheet[1] = manager->GetTexture("wepicon", -1);
    icon_clut[0] = icon_sheet[0]->clut;
    icon_clut[1] = icon_sheet[1]->clut;
    int items[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    int part;
    if (chara_no < 2) {
        CHARA_DATA *chara = user->GetCharaDataPtr(chara_no);
        if (chara == NULL) {
            return 0;
        }
        items[0] = chara->active_item[0].item_no;
        items[1] = chara->active_item[1].item_no;
        items[2] = chara->active_item[2].item_no;
        items[4] = chara->equip[0].item_no;
        items[5] = chara->equip[1].item_no;
        items[6] = chara->equip[2].item_no;
        items[7] = chara->equip[3].item_no;
    } else if (chara_no == 2) {
        items[4] = user->robo_data.parts[2].item_no;
        items[5] = user->robo_data.parts[0].item_no;
    }
    for (int sheet = 0; sheet < 2; ++sheet) {
        if (textures[sheet] == NULL) {
            continue;
        }
        u8 transparent;
        u8 *dest;
        u8 *pixels;
        u8 *source;
        int x;
        int i;
        int slot;
        manager->ReloadCLUT(textures[sheet], (sceVif1Packet *)NULL);
        memcpy(textures[sheet]->clut, icon_clut[sheet], 0x400);
        transparent = 0;
        for (i = 0; i < 0x100; ++i) {
            if (((u8 *)textures[sheet]->clut)[i * 4 + 3] == 0) {
                transparent = i;
                break;
            }
        }
        pixels = (u8 *)textures[sheet]->image[0];
        for (slot = 0, offset = 0; slot < loopnumtbl_2360[sheet]; offset += 0x20, ++slot) {
            if (slot < 2) {
                dest = pixels + offset;
            } else {
                dest = pixels + (slot - 2) * 0x20 + 0x800;
            }
            int item_no = items[sheet * 4 + slot];
            if (item_no <= 0) {
                for (i = 0; i < 0x20; ++i) {
                    for (x = 0; x < 0x20; ++x) {
                        dest[x] = transparent;
                    }
                    dest += 0x40;
                }
            } else {
                int icon_no = GetItemIconNo(item_no);
                source = (u8 *)icon_sheet[sheet]->image[0];
                source += (icon_no % 8) * 0x20 + (icon_no / 8) * 0x2000;
                for (i = 0; i < 0x20; ++i) {
                    memcpy(dest, source, 0x20);
                    dest += 0x40;
                    source += 0x100;
                }
            }
        }
    }
    return 1;
}
void MenuDebugModeDraw() {

    float margin = 6.0f, width = 110.0f, height = 24.0f;
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) 0);
    DrawMenuFillBox(margin, margin, width, height, 0x5C, 0, 0, 0);
    CMenuFont menu_font;
    menu_font.SetStr("MenuDebugMode");
    menu_font.SetPos(6, 6);
    menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
}

void BookshelfMessageMake(ClsMes *message, int base_window, int item_no, int monster_no) {

    int   photos[5];
    char  name[0x80];
    int   window_no;
    short chara;

    if (message != NULL) {
        window_no = 0;
        chara = GetUserDataMan()->active_chr_no;

        if (chara == 0) {
            window_no = 0xBBB;

            if (0 < item_no) {
                CheckItemTable(item_no, photos);
                GetPhotoNameStr(photos[0], name);
                strcpy(message->name[0], name);
                GetPhotoNameStr(photos[1], name);
                strcpy(message->name[1], name);
                GetPhotoNameStr(photos[2], name);
                strcpy(message->name[2], name);
                window_no = base_window + 0xBB8;
            }
        }

        if (chara == 1) {
            window_no = base_window + 0xBC5;

            if (0 <= monster_no) {
                char *monster_name;
                char *monster_text;

                if (monster_no > 9) {
                    monster_no = 0;
                }

                int message_no = monster_table[monster_no].message_no;
                monster_name = GetMonsterName(monster_table[monster_no].name_no);
                monster_text = GetItemMessage(message_no);

                if (monster_name != NULL) {
                    strcpy(message->name[0], monster_name);
                }

                if (monster_text != NULL) {
                    strcpy(message->name[1], monster_text);
                }

                window_no = base_window + 0xBC2;

                if (monster_no == 8 || monster_no == 1) {
                    window_no += 10;
                }
            }
        }

        message->MakeMesWin(window_no);
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", light_1062__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", lightcolor_1063__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_basedgRef__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_basedgCamPos__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1440__2__DATA);
