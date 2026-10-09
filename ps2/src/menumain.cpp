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
#include "event_func.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "inventmn.hpp"
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
#include "nowload.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

extern int          MenuEtcSpecialCode;
extern signed char  MenuLoopType;
extern mgCDrawPrim *MenuPrim;
int                 CommonMenuModeID2[8];
extern int (*menu_keyfunctbl[])();
extern void (*menu_drawfunctbl[])();
extern char workchr_1622[0x60];
void        MenuPolygonSetEnv();
void        MenuPolygonEnvReset();
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

extern CMenuInter      *CMenuInterPt;
extern u_long128       *MenuMainSubDataPackAdr;
extern char            *fname_1858[2];
extern MovePoint        at_1865;
extern MovePoint        at_1866;
extern MovePoint        at_1867;
extern MovePoint        at_2209__3;
extern char             at_1930[];
extern char             at_1931[];
extern char             at_1932[];
extern char             at_1933[];
extern char             at_1934[];
extern char             at_1935[];
extern char             at_1936[];
extern char             at_1937[];
extern char             at_1938[];
extern CMenuInter       CMenuInterStatic;
extern CDC2Mes         *MenuInterMes;
extern signed char      MenuInterMesDrawFlag;
extern char             at_2003[];
extern char             at_1684[];
extern char             at_2004__2[];
extern char             at_2439[];
extern char             at_2440[];
extern int              loopnumtbl_2360[2];
extern u8               MenuDoubleDrawCheck;
extern u8               ManualMenuOkFlag;
extern u8               HatumeiMenuOkFlag;
extern u8               WorldMapOkFlag;
extern u8               DngMoveMenuOkFlag;
extern short            MenuTopicAlphaCalc;
extern char             at_1028__4[];
extern char             at_1630__3[12];
extern char             at_1635__2[12];
extern char             at_1640[12];
extern int              old_light_menu;
extern mgCDrawPrim      MenuPrimFix;
extern float            SndPortVol_Enemy;
extern float            menu_old_chara_position[4];
extern float            menu_old_chara_rotation[4];
extern int              MenuBGMVolume_Save;
extern mgCMemory        MenuMainStack;
extern MenuKeyPageTable at_1514__4;
extern signed char      refresh_cnt_1523;
extern signed char      init_1524;
extern char             at_1598__2[];
extern char             at_1599__2[];
extern u8               menu_basedgRef[16];
extern u8               menu_basedgCamPos[16];
extern char             at_1624__3[9];
extern char             at_1625__3[0x15];
extern char            *menu_main_cfgname_1620[2];
int                     CommonMenuModeID[2][8] = {
    {MENU_MODE_ITEM, MENU_MODE_CHARA_CHANGE, MENU_MODE_INVENT, MENU_MODE_WORLD_MOVE,
     MENU_MODE_OPTION, MENU_MODE_MANUAL, -1, 0},
    {MENU_MODE_ITEM, MENU_MODE_CHARA_CHANGE, MENU_MODE_INVENT, MENU_MODE_DNG_TREE_MAP,
     MENU_MODE_OPTION, MENU_MODE_MANUAL, -1, 0},
};
extern char             *acttbl_1682[2];
extern CMenuPosDataForm *MenuAreaBrdForm;
extern CMenuPosDataForm *MenuTimeBrdForm;
extern AreaNameItems     at_1697__2;
extern BoardPosition     at_1698__2;
extern LanguageWidths    at_1699__2;
extern char             *MenuAreaName;
extern char              at_1736__2[];
extern char              at_1737[];
extern char              at_1738[];
extern char              at_1739[];
extern char              at_1740[];
extern char              at_1741[];
extern char              at_1742[];
extern short             MenuTopicType;
extern mgCTexture       *TopicTex;
extern float             menu_maintopic_colortbl[4][4];
extern float             menu_maintopic_colortbl_shadow[4][4];
extern int               MenuTopicAlpha;
extern short             MenuTopicLength;
extern int               TopicFontX;
extern char             *topic_tbl_1777[7][3];
extern CMenuFont         TopicFont;
extern MonsterTableEntry monster_table[];
extern mgCMemory         MenuMainStack_Next;
extern char              at_1956[];
extern char              at_1957[];
extern char              at_1958[];
extern char              at_2344[];
extern char              at_2345[];
extern char              at_2450[];
extern char             *filetbl_2141[];

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

void *menu_GetBattleAreaScene() {
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

    image = (u8 *) GetMenuMainIMGPtr();

    if (image != NULL) {
        mgTexManager.EnterIMGFile(image,
                                  block, NULL, NULL);
        MenuPosData->ResetTextureBlockNo(at_1028__4, block);
    }
}

void SetMenuFrameRate(int value) {
    mgFrameRate = value;
}

void SetMenuKeyCtrlEnv(int layout) {
    GamePad__2.AutoRepeatOff();
    GamePad__2.MenuModeOff();

    if (layout == 0) {
        GamePad__2.SetAutoRepeat(PAD_UP | PAD_RIGHT | PAD_DOWN | PAD_LEFT, 15, 4);
        GamePad__2.MenuModeOn(120);
    } else if (layout != 1 && layout == 2) {
        GamePad__2.SetAutoRepeat(PAD_UP | PAD_RIGHT | PAD_DOWN | PAD_LEFT | PAD_L1 | PAD_R1, 15, 4);
        GamePad__2.MenuModeOn(120);
    }
}

void DisablePadReset(int disable) {
    DNG_BATTLE_AREA *scene;

    if (GetNowLoopNo() == (int) LOOP_DUNGEON) {
        scene = (DNG_BATTLE_AREA *) menu_GetBattleAreaScene();

        if (scene != NULL) {
            if (disable != 0) {
                scene->pause_flag |= DNG_PAUSE_PAD_RESET;
            } else {
                scene->pause_flag &= ~DNG_PAUSE_PAD_RESET;
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
    SndPortVol_Enemy = sndGetPortVol((int) SND_PORT_ENEMY);
    sndSetPortVol((int) SND_PORT_ENEMY, 0.0f);
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
    if (CheckItemOver() > 0 && (MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_TOWN || MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_DUNGEON)) {
        MenuCommonInfo->open_type += (int) MENU_OPEN_ITEM_OVER;
        ItemOverFlowCheckFlag = 1;
    }
    MenuLoopType = (int) MENU_LOOP_TOWN;
    if (MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_DUNGEON || MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_DUNGEON_ITEM_OVER ||
        MenuCommonInfo->open_type == (int) MENU_OPEN_CHARA_CHANGE_DUNGEON || MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_CHARA_BG_DUNGEON) {
        MenuLoopType = (int) MENU_LOOP_DUNGEON;
    }
    SetCommonMenuModeID();
    int sound = -1;
    CMenuInterPt = NULL;
    MenuInterMesDrawFlag = 0;
    MenuInterMes = NULL;
    switch (MenuCommonInfo->open_type) {
        case MENU_OPEN_MAIN_TOWN:
        case MENU_OPEN_MAIN_DUNGEON:
            sound = 1;
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 1);
            break;
        case MENU_OPEN_GEORAMA:
            sound = 1;
            MenuGeoramaInit(menu_stack, MenuCommonInfo->open_type);
            break;
        case MENU_OPEN_DNG_TREE_MAP:
            TreeMapSaveNum = 0;
            TreeMapSaveFlag = 1;
            MenuCommonInfo->now_mode = (int) MENU_MODE_DNG_TREE_MAP;
            DngTreeMapInit(menu_stack, texture_blocks, MenuCommonInfo->open_type, MenuArg.param[0]);
            break;
        case MENU_OPEN_CHARA_CHANGE:
        case MENU_OPEN_CHARA_CHANGE_DUNGEON:
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 0);
            while (ReadBGSync() != 0) {
            }
            CMenuInterPt->InitEnd();
            ReturnMenuIntern(1);
            NextMenuInit((int) MENU_MODE_CHARA_CHANGE, &MenuMainStack_Next, &texture_blocks[3]);
            MenuCommonInfo->now_mode = (int) MENU_MODE_CHARA_CHANGE;
            MenuMainScene->fade.FadeIn(30);
            break;
        case MENU_OPEN_SHOP:
            MenuShopInit(menu_stack, texture_blocks, 6);
            break;
        case MENU_OPEN_USE_ITEM:
            sound = 1;
        case MENU_OPEN_USE_ITEM_B:
            MenuScreenBlackBeltSet(0);
            MenuCommonInfo->now_mode = (int) MENU_MODE_ITEM_SELECT;
            MenuItemSelectInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            break;
        case MENU_OPEN_INVENT:
            sound = 1;
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 1);
            NextMenuInit((int) MENU_MODE_INVENT_DIRECT, menu_stack, &texture_blocks[3]);
            MenuCommonInfo->now_mode = (int) MENU_MODE_INVENT_DIRECT;
            break;
        case MENU_OPEN_CHAPTER:
            MenuCommonInfo->now_mode = (int) MENU_MODE_CHAPTER;
            MenuChapterInit(menu_stack, texture_blocks, 11, MenuArg.param[0]);
            break;
        case MENU_OPEN_SAVE:
        case MENU_OPEN_TITLE_SAVE:
            SetDngTreeFlag(0);
            if (MenuCommonInfo->open_type == (int) MENU_OPEN_SAVE) {
                SaveMapInfo(-1);
                NowProgramLoopNo = GetNowLoopNo();
                MenuCommonInfo->now_mode = (int) MENU_MODE_SAVE;
            }
            if (MenuCommonInfo->open_type == (int) MENU_OPEN_TITLE_SAVE) {
                MenuCommonInfo->now_mode = (int) MENU_MODE_TITLE_SAVE;
            }
            MenuSaveInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            break;
        case MENU_OPEN_SUBGAME_SAVE:
        case MENU_OPEN_TITLE_SUBGAME_SAVE:
            MenuCommonInfo->now_mode = (int) MENU_MODE_SUBGAME_SAVE;
            SubGameSaveInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            break;
        case MENU_OPEN_REMOVAL:
            MenuScreenBlackBeltSet(0);
            MenuRemovalInit(menu_stack, texture_blocks);
            MenuCommonInfo->now_mode = (int) MENU_MODE_REMOVAL;
            break;
        case MENU_OPEN_WORLD_MOVE:
        case MENU_OPEN_WORLD_MOVE_B:
            WorldMoveInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            MenuCommonInfo->now_mode = (int) MENU_MODE_WORLD_MOVE;
            break;
        case MENU_OPEN_NAME_REGIST:
            Nameregi_Target.target = 2;
            NameRegistInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            MenuCommonInfo->now_mode = (int) MENU_MODE_NAME_REGIST;
            break;
        case MENU_OPEN_GYORACE_FISH_SEL:
            MenuScreenBlackBeltSet(0);
            sound = 1;
            MenuGyoraceFishSelInit(menu_stack, texture_blocks, MenuCommonInfo->open_type);
            MenuCommonInfo->now_mode = (int) MENU_MODE_GYORACE_FISH_SEL;
            break;
        case MENU_OPEN_MAIN_TOWN_ITEM_OVER:
        case MENU_OPEN_MAIN_DUNGEON_ITEM_OVER:
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 0);
            while (ReadBGSync() != 0) {
            }
            CMenuInterPt->InitEnd();
            CMenuInterPt->ReadBGTexture(2, 1);
            while (CMenuInterPt->ReadBGTexture(2, 0) == 0) {
            }
            ReturnMenuIntern(1);
            NextMenuInit((int) MENU_MODE_ITEM, &MenuMainStack_Next, &texture_blocks[3]);
            MenuMainScene->fade.FadeIn(40);
            MenuCommonInfo->now_mode = (int) MENU_MODE_ITEM;
            break;
        case MENU_OPEN_OPTION:
            GamePad__2.KeyLock(1);
            MenuInternInit(menu_stack, MenuCommonInfo->open_type, 0);
            while (ReadBGSync() != 0) {
            }
            CMenuInterPt->InitEnd();
            CMenuInterPt->ReadBGTexture(7, 1);
            while (CMenuInterPt->ReadBGTexture(7, 0) == 0) {
            }
            ReturnMenuIntern(1);
            NextMenuInit((int) MENU_MODE_OPTION, &MenuMainStack_Next, &texture_blocks[3]);
            break;
        case MENU_OPEN_COSTUME:
            MenuCostumeInit(menu_stack, texture_blocks, 0);
            MenuCommonInfo->now_mode = (int) MENU_MODE_COSTUME;
            break;
        case MENU_OPEN_MAIN_CHARA_BG_DUNGEON:
        case MENU_OPEN_MAIN_CHARA_BG: {
            int town = 0;
            if (MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_CHARA_BG) {
                town = 1;
            }
            MenuScreenBlackBeltSet(0);
            InitMainCharaBG(MenuArg.param[0], menu_stack, town);
            MenuCommonInfo->now_mode = (int) MENU_MODE_MAIN_CHARA_BG;
            break;
        }
        case MENU_OPEN_GYORACE:
            MenuScreenBlackBeltSet(0);
            GyoraceMenuInit(menu_stack, texture_blocks, 0);
            sound = 1;
            MenuCommonInfo->now_mode = (int) MENU_MODE_GYORACE;
            break;
        case MENU_OPEN_SPHIDA:
            SphidaMenuInit(menu_stack, texture_blocks, 0);
            sound = 1;
            MenuCommonInfo->now_mode = (int) MENU_MODE_SPHIDA;
            break;
        case MENU_OPEN_SPHIDA_SCORE_VIEW:
            MenuScreenBlackBeltSet(0);
            SphidaScoreViewInit(menu_stack, texture_blocks, 0);
            MenuCommonInfo->now_mode = (int) MENU_MODE_SPHIDA_SCORE_VIEW;
            break;
        case MENU_OPEN_MONSTER_BOOK:
            MonsterBookInit(menu_stack, texture_blocks, 1);
            MenuCommonInfo->now_mode = (int) MENU_MODE_MONSTER_BOOK;
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
    CScene      *camera;
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

    sndSetPortVol((int) SND_PORT_ENEMY, SndPortVol_Enemy);
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

                if (GetMenuLoopType() == (int) MENU_LOOP_DUNGEON) {
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
    scene = (CScene *) GetMainScene();
    camera = (CScene *) scene->GetCamera(scene->active_camera);

    if (camera != NULL) {
        ((mgCCamera *) camera)->GetCameraMatrix(view_matrix);
        ((mgCCamera *) camera)->GetPos(pos);
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
    MenuKeyPageTable page_table;

    MenuWorldTrans();
    MenuPolygonSetEnv();
    ReadBG();
    MenuCommonInfo->SelDataInit();
    MenuMainFrameStep();
    MenuAreaBoardNameStep();

    if (DebugFlag != 0 && GamePad__2.Down(PAD_R3) != 0) {
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
                        page_table = at_1514__4;
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
            if (MenuCommonInfo->now_mode == (int) MENU_MODE_CHARA_CHANGE) {
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
        case MENU_MODE_ITEM:
            MenuItemInit(memory, args, page);
            break;
        case MENU_MODE_CHARA_CHANGE:
            MenuCharaChangeInit(memory, args, page);
            break;
        case MENU_MODE_INVENT:
        case MENU_MODE_INVENT_DIRECT:
            MenuInventInit(memory, args, page);
            break;
        case MENU_MODE_DNG_TREE_MAP:
            dungeon_mode = 0;

            if (MenuMainScene != NULL) {
                dungeon_mode = MenuSaveDataDungeonPtr->stage_id;
            }

            if (TreeMapCallDungeonSubMap != 0) {
                map_name = MenuMainScene->GetMapName(MenuMainScene->active_map);

                if (strcmp(map_name, at_1598__2) == 0) {
                    dungeon_mode = 1;
                }

                if (strcmp(map_name, at_1599__2) == 0) {
                    dungeon_mode = 3;
                }
            }

            DngTreeMapInit(memory, args, page, dungeon_mode);
            break;
        case MENU_MODE_AQUA:
            MenuAquaInit(memory, args, page);
            break;
        case MENU_MODE_WORLD_MOVE:
            WorldMoveInit(memory, args, page);
            break;
        case MENU_MODE_MANUAL:
            MenuManualInit(memory, args, page);
            break;
        case MENU_MODE_OPTION:
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

    sprintf(workchr_1622, at_1624__3, LanguageCode);
    strcat(workchr_1622, menu_main_cfgname_1620[index]);
    printf(at_1625__3, &local);
    return workchr_1622;
}

short *GetMenuMainMessageBuffer() {
    int size;

    return (short *) GetPackFile(MenuArg.pack, at_1630__3, &size);
}

u_int *GetMenuMainIMGPtr() {
    return GetPackFile(MenuArg.pack, at_1635__2, 0);
}

u_int *GetMenuMainPosCfgBuffer(int *size) {
    return GetPackFile(MenuArg.pack, at_1640, size);
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

            if (CommonMenuModeID2[i] == (int) MENU_MODE_WORLD_MOVE && (bit_ctrl & 0x10)) {
                CommonMenuModeID2[i] = (int) MENU_MODE_DNG_TREE_MAP;
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
    AreaNameItems  names;
    BoardPosition  position;
    LanguageWidths widths;
    CDC2Mes       *message;
    float          hours;
    float          minutes;
    int            day;

    if (MenuAreaBrdForm != NULL) {
        names = at_1697__2;
        names.name[0] = MenuAreaName;
        message = MenuDCMsg[1];
        message->MakeMsg(0x32);
        message->SetMsgItemNo(names.name, 1);
        message->GetStrWidth(names.name[0]);
        position = at_1698__2;
        MenuAreaBrdForm->GetNextMovePos(position.value);
        widths = at_1699__2;
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

            MenuTimeBrdForm->SetNumber(at_1736__2, day);

            if (MenuNowMapType == 5 || MenuNowMapType == 6) {
                MenuTimeBrdForm->SetPartDrawFlag(at_1737, false);
                MenuTimeBrdForm->SetPartDrawFlag(at_1738, false);
                MenuTimeBrdForm->SetPartDrawFlag(at_1739, false);
                MenuTimeBrdForm->SetPartDrawFlag(at_1740, false);
                MenuTimeBrdForm->SetPartDrawFlag(at_1741, false);
            } else {
                MenuTimeBrdForm->SetPartDrawFlag(at_1742, false);

                if (LanguageCode == 3) {
                    MenuTimeBrdForm->SetPartDrawFlag(at_1737, false);
                    MenuTimeBrdForm->SetPartDrawFlag(at_1738, false);
                } else if (12.0f <= hours) {
                    MenuTimeBrdForm->SetPartDrawFlag(at_1737, false);
                    MenuTimeBrdForm->SetPartDrawFlag(at_1738, true);
                    hours -= 12.0f;
                } else {
                    MenuTimeBrdForm->SetPartDrawFlag(at_1737, true);
                    MenuTimeBrdForm->SetPartDrawFlag(at_1738, false);
                }
            }

            if (LanguageCode != 3 && LanguageCode > 0 && hours == 0.0f) {
                hours = 12.0f;
            }

            MenuTimeBrdForm->SetNumber(at_1739, (int) hours);
            MenuTimeBrdForm->SetNumber(at_1740, (int) minutes);
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
    char *topic_text = (char *) &TopicFont;
    ((CFont *) topic_text)->CalcDrawWH(topic_text, &width, &height);
    MenuTopicLength = width;
    TopicFontX = 30;
}

void DrawMenuTopic() {
    mgRect<int> box;
    float       x;
    float       y;
    float       w;
    float       h;

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
        mgCDrawPrim       *prim = GetMenuPrim();
        manager->ReloadTexture(TopicTex->block, (sceVif1Packet *) NULL);
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
        manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
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
        menu_maintopic_colortbl_shadow[0][3] = menu_maintopic_colortbl_shadow[2][3] = 64.0f * (float) MenuTopicAlpha / 128.0f;
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

    if (open_type == (int) MENU_OPEN_INVENT) {
        MenuCommonInfo->now_mode = (int) MENU_MODE_MAIN_TOWN;
    } else {
        open_type = GetMenuLoopType();
        CMenuInterPt->mode_list = GetCommonMenuModeID();
        MenuCommonInfo->now_mode = open_type;
    }

    MenuMainImageDataEnter(MenuCommonInfo->tex_block[1]);
    MenuInterMes = new ((u_long128 *) stack->Alloc(0x2A7)) CDC2Mes;
    int   script_size;
    char *config = (char *) GetMenuMainPosCfgBuffer(&script_size);
    char *script = (char *) (stack->stack + stack->stack_used) + (stack->stack_size - stack->stack_used) * 16 - 0x32000;
    memcpy(script, config, script_size);
    MenuDataAnalyze(script, script_size, stack);
    AttachMessageForm();
    MenuAreaBrdForm = MenuPosData->GetFormInfo(at_1930);
    MenuTimeBrdForm = MenuPosData->GetFormInfo(at_1931);

    if (early_game != 0) {
        if (MenuTimeBrdForm != NULL) {
            MenuTimeBrdForm->draw_flag = 0;
            MenuTimeBrdForm = NULL;
        }
    }

    MenuFormMI2 = MenuPosData->GetFormInfo(at_1932);
    TopicTex = mgTexManager.GetTexture(at_1028__4, -1);
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
        if (GetNowLoopNo() == (int) LOOP_DUNGEON) {
            ManualMenuOkFlag = 1;
        }
    }

    WorldMapOkFlag = 1;
    DngMoveMenuOkFlag = 1;

    if (early_game != 0) {
        WorldMapOkFlag = 0;
        DngMoveMenuOkFlag = 0;
    }

    if (open_type != (int) MENU_OPEN_INVENT) {
        MenuMainSubDataPackAdr = stack->stack + stack->stack_used;
        MenuCommonReadData(stack, fname_1858, 0);
        MenuMainFrameModeSet(0, 1);
        int icon_count = 0;

        for (int k = 0; 0 <= CMenuInterPt->mode_list[k]; k++) {
            icon_count++;
        }

        MovePoint origin = at_1865;
        MovePoint pos = at_1866;
        MovePoint step = at_1867;

        for (int icon = 0; icon < icon_count; icon++) {
            char *name = (char *) GetMenuMainIconChar(CMenuInterPt->mode_list[icon]);
            pos.y = origin.y + step.y * icon;
            MenuPosData->SetFormPos(name, &pos.x);
        }

        bool              shown = true;
        bool              hidden = false;
        CMenuPosDataForm *form = MenuPosData->GetFormInfo(at_1933);

        if (form != NULL) {
            if (HatumeiMenuOkFlag == 0) {
                shown = false;
                hidden = true;
            }

            form->SetPartDrawFlag(at_1934, shown);
            form->SetPartDrawFlag(at_1935, hidden);
        }

        bool              manual_hidden;
        CMenuPosDataForm *manual_form = MenuPosData->GetFormInfo(at_1936);

        if (manual_form != NULL) {
            bool manual_shown = true;
            manual_hidden = false;

            if (ManualMenuOkFlag == 0) {
                manual_shown = false;
                manual_hidden = true;
            }

            manual_form->SetPartDrawFlag(at_1934, manual_shown);
            manual_form->SetPartDrawFlag(at_1935, manual_hidden);
        }

        bool              world_hidden;
        CMenuPosDataForm *world_form = MenuPosData->GetFormInfo(at_1937);

        if (world_form != NULL) {
            bool world_shown = true;
            world_hidden = false;

            if (WorldMapOkFlag == 0) {
                world_shown = false;
                world_hidden = true;
            }

            world_form->SetPartDrawFlag(at_1934, world_shown);
            world_form->SetPartDrawFlag(at_1935, world_hidden);

            if (GetMenuLoopType() == MENU_LOOP_DUNGEON) {
                world_form->draw_flag = 0;
            }
        }

        bool              floor_hidden;
        CMenuPosDataForm *floor_form = MenuPosData->GetFormInfo(at_1938);

        if (floor_form != NULL) {
            bool floor_shown = true;
            floor_hidden = false;

            if (DngMoveMenuOkFlag == 0) {
                floor_shown = false;
                floor_hidden = true;
            }

            floor_form->SetPartDrawFlag(at_1934, floor_shown);
            floor_form->SetPartDrawFlag(at_1935, floor_hidden);

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
    mgTexManager.EnterIMGFile((u8 *) GetPackFile(pack, at_1956, 0), block, 0, 0);
    mgTexManager.EnterIMGFile((u8 *) GetPackFile(pack, at_1957, &size), block, 0, 0);
    u8 *image = (u8 *) GetPackFile(pack, at_1958, 0);

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
    tex->EnterIMGFile((u8 *) GetPackFile(pack, at_1956, 0), block, 0, 0);
    tex->EnterIMGFile((u8 *) GetPackFile(pack, at_1957, &size), block, 0, 0);
    u8 *image = (u8 *) GetPackFile(pack, at_1958, 0);

    if (image) {
        tex->EnterIMGFile(image, block, 0, 0);
    }

    (MenuPosData)->AttachCommonTexInfo();
    MenuPosData->ResetTextureInfoAll();
}

void CMenuInter::InitEnd() {
    int                base_block = MenuCommonInfo->tex_block[1];
    mgCTextureManager *manager = &mgTexManager;
    BG_READ_INFO      *base_data = GetReadBGFile(0);

    if (base_data != NULL) {
        MenuCommonBaseDataEnter(&MenuMainStack, (u_int *) base_data->buffer, base_data->size, base_block);
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
    CMenuPosDataForm *board = MenuPosData->GetFormInfo(at_2003);

    if (board != NULL) {
        int pos[2] = {(int) (board->x - 30.0f), (int) (4.0f + board->y)};
        SetFormPoint(MenuCommonInfo->cursor_form, (int) (board->x - 30.0f), (int) (4.0f + board->y));
        MenuCommonInfo->cursor_form->SetNextMovePos(pos, 2);
        CMenuPosDataForm *next_form = MenuPosData->GetFormInfo(at_2004__2);

        if (next_form != NULL) {
            pos[0] = (int) board->x;
            pos[1] = (int) (4.0f + board->y);
            SetFormPoint(next_form, (int) board->x, (int) (4.0f + board->y));
            next_form->SetNextMovePos(pos, 2);
        }
    }

    ReturnMenuIntern(0);
    MenuEtcInfo.tex_block = MenuArg.mes_tex_block;
    MenuEtcInfo.tex = manager->GetTexture(at_1028__4, -1);
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

int MenuInternSelectKey() {
    int  result = 0;
    int  select_key = MenuCommonInfo->CheckSelectKey();
    int  push = MenuCommonInfo->CheckPushButton();
    int  old_select = CMenuInterPt->select_no;
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

    if (MenuKeySelectCheck(direction, &CMenuInterPt->select_no, NULL, 0, CMenuInterPt->select_num, CMenuInterPt->select_num, (int) MENU_CURSOR_LIMIT_WRAP) != 0 &&
        CMenuInterPt->step == MENU_INTER_STEP_SELECT) {
        moved = 1;
        MenuSePlay(SYSTEM_SE_CURSOR);
        CMenuInterPt->help_update = moved;
    }

    int *mode_list = CMenuInterPt->mode_list;
    int  closing = 0;

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

    CMenuPosDataForm *icon_form = MenuPosData->GetFormInfo((char *) GetMenuMainIconChar(mode));

    if (old_select != CMenuInterPt->select_no && abs(old_select - CMenuInterPt->select_no) > 1) {
        CMenuInterPt->cursor_jump = 1;
    }

    if (icon_form != NULL) {
        MovePoint pos = at_2209__3;
        pos.x = (int) (icon_form->x - 42.0f);
        pos.y = (int) icon_form->y;
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
                    MenuActiveSaveData->SetBitFlag(SAVE_FLAG_TOURNAMENT_STARTED, 1);
                    MenuActiveSaveData->SetBitFlag(SAVE_FLAG_TOURNAMENT_CYCLE, 1);
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
                    MenuMesForm[0]->SetAction(at_1684);
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
void MenuInternSelectDraw() {
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
            strcpy(text, "\211\275\202\340\213\326\216\176\012\202\263\202\352\202\304\202\242\202\334\202\271\202\361");
        }

        font.DrawDirect(text, 360, 60);
        DrawMenuFillBox(300.0f, 350.0f, 190.0f, 60.0f, 0x40, 0, 0, 0);
        font.DrawDirect("\201\233\072\101\144\144\040\104\141\171\012\201\176\072\126\151\145\167\040\117\160\145\156\151\156\147\012\201\242\201\106\102\157\157\164\040\106\151\163\150\105\166\145\156\164", 300, 350);
    }
}

void CopyActiveItemAndWeapon(int slot, int weapon_slot) {
    mgCTexture *textures[2];

    mgCTextureManager *manager = &mgTexManager;
    textures[0] = manager->GetTexture(at_2344, -1);
    textures[1] = manager->GetTexture(at_2345, -1);

    if (textures[0] == NULL || textures[1] == NULL) {
        return;
    }

    CopyActiveIconTexture(textures, slot, 0);
    manager->ReloadTexture(-1, (sceVif1Packet *) 0);
}

int CopyActiveIconTexture(mgCTexture **textures, int chara_no, u_int *unused) {
    CUserDataManager *user = GetUserDataMan();
    int               offset;

    if (user == NULL) {
        return 0;
    }

    mgCTextureManager *manager = &mgTexManager;
    u_long128         *icon_clut[2];
    mgCTexture        *icon_sheet[2];
    icon_sheet[0] = manager->GetTexture(at_2439, -1);
    icon_sheet[1] = manager->GetTexture(at_2440, -1);
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

        u8  transparent;
        u8 *dest;
        u8 *pixels;
        u8 *source;
        int x;
        int i;
        int slot;
        manager->ReloadCLUT(textures[sheet], (sceVif1Packet *) NULL);
        memcpy(textures[sheet]->clut, icon_clut[sheet], 0x400);
        transparent = 0;

        for (i = 0; i < 0x100; ++i) {
            if (((u8 *) textures[sheet]->clut)[i * 4 + 3] == 0) {
                transparent = i;
                break;
            }
        }

        pixels = (u8 *) textures[sheet]->image[0];

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
                source = (u8 *) icon_sheet[sheet]->image[0];
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
    menu_font.SetStr(at_2450);
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
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_keyfunctbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_drawfunctbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_basedgRef__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_basedgCamPos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1699__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_maintopic_colortbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_maintopic_colortbl_shadow__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", topic_tbl_1777__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", filetbl_2141__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", monster_table__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1028__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1440__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1598__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1599__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1621__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1624__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1625__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1630__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1635__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1640__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1683__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1684__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1736__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1737__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1738__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1739__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1740__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1741__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1742__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1778__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1779__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1780__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1781__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1782__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1783__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1784__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1785__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1786__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1787__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1788__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1789__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1859__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1930__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1931__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1932__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1933__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1934__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1935__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1936__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1937__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1938__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1956__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1957__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1958__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2003__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2004__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2142__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2143__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2144__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2145__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2146__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2344__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2345__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2439__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2440__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2450__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", MenuPrim__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", MenuPrevEndCode__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", MenuBGTextureBlock__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", MenuItemIconTextureBlock__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1514__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_main_cfgname_1620__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", acttbl_1682__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", MenuTopicAlpha__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", fname_1858__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1865__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1866__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_1867__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", loopnumtbl_2360__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MenuMainScene, 0x4);
INCLUDE_BSS(MenuActiveSaveData, 0x4);
INCLUDE_BSS(MenuUserDataManPtr, 0x4);
INCLUDE_BSS(MenuSystemDataPtr, 0x4);
INCLUDE_BSS(MenuConfigPtr, 0x4);
INCLUDE_BSS(MenuSaveDataDungeonPtr, 0x4);
INCLUDE_BSS(MenuFishAquarium, 0x4);
INCLUDE_BSS(MenuNowMapNo, 0x4);
INCLUDE_BSS(MenuNowMapType, 0x4);
INCLUDE_BSS(MenuMainSubDataPackAdr, 0x4);
INCLUDE_BSS(CMenuInterPt, 0x4);
INCLUDE_BSS(MenuInterMes, 0x4);
INCLUDE_BSS(MenuInterMesDrawFlag, 0x4);
INCLUDE_BSS(MenuAreaBrdForm, 0x4);
INCLUDE_BSS(MenuTimeBrdForm, 0x4);
INCLUDE_BSS(MenuAreaName, 0x4);
INCLUDE_BSS(MenuNowTime, 0x4);
INCLUDE_BSS(SndPortVol_Enemy, 0x4);
INCLUDE_BSS(ItemOverFlowCheckFlag, 0x4);
INCLUDE_BSS(MenuDrawEnv, 0x4);
INCLUDE_BSS(MenuCommonInfo, 0x4);
INCLUDE_BSS(MenuLoopType, 0x4);
INCLUDE_BSS(MenuEtcSpecialCode, 0x4);
INCLUDE_BSS(MenuEtcInfo, 0x8);
INCLUDE_BSS(MenuMoveItemPtr, 0x4);
INCLUDE_BSS(MenuBGMVolume_Save, 0x4);
INCLUDE_BSS(MenuFormMI2, 0x4);
INCLUDE_BSS(MenuItemCommandCounter, 0x4);
INCLUDE_BSS(menu_debug_flag, 0x4);
INCLUDE_BSS(MenuTopicAlphaCalc, 0x4);
INCLUDE_BSS(TopicTex, 0x4);
INCLUDE_BSS(old_light_menu, 0x4);
INCLUDE_BSS(HatumeiMenuOkFlag, 0x4);
INCLUDE_BSS(WorldMapOkFlag, 0x4);
INCLUDE_BSS(ManualMenuOkFlag, 0x4);
INCLUDE_BSS(DngMoveMenuOkFlag, 0x4);
INCLUDE_BSS(MenuDoubleDrawCheck, 0x4);
INCLUDE_BSS(refresh_cnt_1523, 0x4);
INCLUDE_BSS(init_1524, 0x8);
INCLUDE_BSS(at_1697__2, 0x8);
INCLUDE_BSS(at_1698__2, 0x8);
INCLUDE_BSS(MenuTopicType, 0x4);
INCLUDE_BSS(MenuTopicLength, 0x4);
INCLUDE_BSS(TopicFontX, 0x8);
INCLUDE_BSS(at_1976, 0x8);
INCLUDE_BSS(at_2209__3, 0x8);

// Uninitialised data (.bss)
mgCMemory MenuMainStack;
mgCMemory MenuMainStack_Next;
INCLUDE_BSS(CMenuInterStatic, 0x20);
mgCDrawPrim MenuPrimFix;
INCLUDE_BSS(MenuItemUse, 0x20);
mgCMemory MenuMainTextureReadBuf;
mgCMemory MenuSoundBuffer;
INCLUDE_BSS(MenuArg, 0xA0);
INCLUDE_BSS(menu_old_chara_position, 0x10);
INCLUDE_BSS(menu_old_chara_rotation, 0x10);
INCLUDE_BSS(workchr_1622, 0x60);
CMenuFont TopicFont;
INCLUDE_BSS(at_2351, 0x20);
