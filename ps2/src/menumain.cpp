#include "charasetup.hpp"
#include "dynamicanime.hpp"
#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include "dngfloor.hpp"
#include "map.hpp"
#include "menushop.hpp"
#include "menusystemdata.hpp"
#include "menuop.hpp"
#include "editmenu.hpp"
#include "dngmenu.hpp"
#include "menuchr.hpp"
#include "font.hpp"
#include "sysmes.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "common.h"
#include "menumain.hpp"
#include "nameregi.hpp"
#include "menucapt.hpp"
#include "gamepad.hpp"
#include "menuaqua.hpp"
#include "menumap.hpp"
#include "mapselect.hpp"

extern "C" int
EnterIMGFile__17mgCTextureManagerFPUciP9mgCMemoryP15mgCEnterIMGInfo(mgCTextureManager *, u8 *, int,
                                                                    mgCMemory *, mgCEnterIMGInfo *);

extern "C" void *__ct__9CMenuFontFv(void *font);
extern "C" void DrawDirect__5CFontFPcii(void *font, char *text, int x, int y);
extern int MenuEtcSpecialCode;
extern signed char MenuLoopType;
extern mgCDrawPrim *MenuPrim;
extern int CommonMenuModeID2[8];
extern int (*menu_keyfunctbl[])(void);
extern void (*menu_drawfunctbl[])(void);
extern char workchr_1622[0x60];
extern "C" void sceVu0UnitMatrix(float (*matrix)[4]);
extern "C" void sceVu0MulMatrix(float (*out)[4], float (*left)[4], float (*right)[4]);
extern "C" void GetPos__9mgCCameraFPf(mgCCamera *camera, float *pos);
extern "C" void SetSpeed__9mgCCameraFff(mgCCamera *camera, float speed, float rate);
extern "C" void SetNextRef__9mgCCameraFPf(mgCCamera *camera, float *ref);
extern "C" void SetNextPos__9mgCCameraFPf(mgCCamera *camera, float *pos);
extern "C" int GetStrWidth__6ClsMesFPc(CDC2Mes *mes, char *text);
extern "C" int
EnterIMGFile__17mgCTextureManagerFPUciP9mgCMemoryP15mgCEnterIMGInfo(mgCTextureManager *, u8 *, int,
                                                                    mgCMemory *, mgCEnterIMGInfo *);
int CheckItemTable(int itemNo, int *photos);
void GetPhotoNameStr(int photoNo, char *name);
void MenuPolygonSetEnv(void);
void MenuPolygonEnvReset(void);
int PauseEnable(int enable);
void SetupUnitMan(CScene *scene, CUserDataManager *userData, int unit, ROBO_INFO_DATA *robo);
void EdEventMenuExit(void);
void MenuInventInit(mgCMemory *memory, int *args, int page);
void MenuAquaInit(mgCMemory *memory, int *args, int page);
short CheckEventDay(int *day);
void MenuWorldTrans(void);
void MenuDebugModeDraw(void);
void DrawMenuTopic(void);

static inline void SetFormPoint(CMenuPosDataForm *form, int x, int y) {
    form->x = (float)x;
    form->y = (float)y;
}

struct MovePoint {
    int x;
    int y;
};

struct MenuKeyPageTable {
    int next[2];
};
struct AreaNameItems {
    char *name[2];
};
struct BoardPosition {
    int value[2];
};
struct LanguageWidths {
    int value[9];
};
struct MonsterTableEntry {
    short nameNo;
    short messageNo;
};

extern CMenuInter *CMenuInterPt;
extern u_long128 *MenuMainSubDataPackAdr;
extern char *fname_1858[2];
extern MovePoint at_1865;
extern MovePoint at_1866;
extern MovePoint at_1867;
extern char at_1930[];
extern char at_1931[];
extern char at_1932[];
extern char at_1933[];
extern char at_1934[];
extern char at_1935[];
extern char at_1936[];
extern char at_1937[];
extern char at_1938[];
extern CMenuInter CMenuInterStatic;
extern int OmakeFlag;
extern CDC2Mes *MenuInterMes;
extern signed char MenuInterMesDrawFlag;
extern char at_2329[];
extern char at_2330[];
extern char at_2331[];
extern char at_2332[];
extern char at_2333__2[];
extern char at_2334__2[];
extern char at_2335[];
extern char at_2003[];
extern char at_1684[];
extern char at_2004__2[];
extern char at_2439[];
extern char at_2440[];
extern int loopnumtbl_2360[2];
extern u8 MenuDoubleDrawCheck;
extern u8 ManualMenuOkFlag;
extern u8 HatumeiMenuOkFlag;
extern u8 WorldMapOkFlag;
extern u8 DngMoveMenuOkFlag;
extern short MenuTopicAlphaCalc;
extern char at_1028__4[];
extern char at_1630__3[12];
extern char at_1635__2[12];
extern char at_1640[12];
extern int old_light_menu;
extern mgCDrawPrim MenuPrimFix;
extern float SndPortVol_Enemy;
extern float menu_old_chara_position[4];
extern float menu_old_chara_rotation[4];
extern int MenuBGMVolume_Save;
extern mgCMemory MenuMainStack;
extern int (*menu_keyfunctbl[])(void);
extern MenuKeyPageTable at_1514__4;
extern signed char refresh_cnt_1523;
extern signed char init_1524;
extern char at_1598__2[];
extern char at_1599__2[];
extern u8 menu_basedgRef[16];
extern u8 menu_basedgCamPos[16];
extern char at_1624__3[9];
extern char at_1625__3[0x15];
extern char *menu_main_cfgname_1620[2];
extern int CommonMenuModeID[2][8];
extern char *acttbl_1682[2];
extern CMenuPosDataForm *MenuAreaBrdForm;
extern CMenuPosDataForm *MenuTimeBrdForm;
extern AreaNameItems at_1697__2;
extern BoardPosition at_1698__2;
extern LanguageWidths at_1699__2;
extern char *MenuAreaName;
extern char at_1736__2[];
extern char at_1737[];
extern char at_1738[];
extern char at_1739[];
extern char at_1740[];
extern char at_1741[];
extern char at_1742[];
extern short MenuTopicType;
extern mgCTexture *TopicTex;
extern float menu_maintopic_colortbl[4][4];
extern float menu_maintopic_colortbl_shadow[4][4];
extern int MenuTopicAlpha;
extern short MenuTopicLength;
extern int TopicFontX;
extern char *topic_tbl_1777[7][3];
extern "C" char *GetMapName__6CSceneFi(CScene *scene, int index);
extern CMenuFont TopicFont;
extern CGamePad GamePad__2;
extern CDC2Mes *MenuDCMsg[9];
extern MonsterTableEntry monster_table[];
extern mgCMemory MenuMainStack_Next;
extern char at_1956[];
extern char at_1957[];
extern char at_1958[];
extern char at_2344[];
extern char at_2345[];
extern char at_2450[];
extern char *filetbl_2141[];
int ReadBGSync(void);

// Code (.text)
void MenuScreenBlackBeltSet(int enable) {
}
int GetMenuLoopType(void) {
    return MenuLoopType;
}
int CheckTrushMenu(void) {
    short mode = MenuCommonInfo->open_type;
    if (mode == 0x10 || mode == 0x11) {
        return 1;
    }
    return 0;
}
CSaveDataDungeon *menu_GetSaveDataDungeon(void) {
    CSaveData *saveData;

    saveData = GetSaveData();
    if (saveData != NULL) {
        return &saveData->save_dungeon;
    }
    return NULL;
}
void *menu_GetBattleAreaScene(void) {
    CScene *scene;

    scene = GetMainScene();
    if (scene != NULL) {
        return &scene->battle_area;
    }
    return NULL;
}
CMenuSystemData *GetMenuSysData(void) {
    CSaveData *saveData;

    saveData = GetSaveData();
    if (saveData != NULL) {
        return &saveData->menu_system_data;
    }
    return NULL;
}
int CheckBitFlagMenu(int flag) {
    CSaveData *saveData;

    saveData = GetSaveData();
    if (saveData != NULL) {
        return saveData->GetBitFlag(flag);
    }
    return 0;
}
int CheckShortFlagMenu(int flag) {
    CSaveData *saveData;

    saveData = GetSaveData();
    if (saveData != NULL) {
        return saveData->GetShortFlag(flag);
    }
    return 0;
}
int CheckStartChapter8(CSaveData *saveData) {
    if (saveData == NULL) {
        return 0;
    }
    if (saveData->GetBitFlag(0x2E0) == 1) {
        if (!saveData->GetBitFlag(0x320)) {
            return 1;
        }
    }
    return 0;
}
void InitMenuEtcSpecialFlag(void) {
    MenuEtcSpecialCode = 0;
}
int SetMenuEtcFlag(int flags) {
    MenuEtcSpecialCode |= flags;
    return MenuEtcSpecialCode;
}
int GetMenuEtcFlag(void) {
    return MenuEtcSpecialCode;
}
mgCDrawPrim *GetMenuPrim(void) {
    return MenuPrim;
}
void MenuMainImageDataEnter(int block) {
    u8 *image;

    image = (u8*)GetMenuMainIMGPtr();
    if (image != NULL) {
        EnterIMGFile__17mgCTextureManagerFPUciP9mgCMemoryP15mgCEnterIMGInfo(&mgTexManager, image,
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
        scene = (DNG_BATTLE_AREA*)menu_GetBattleAreaScene();
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
void MakeMenuTopic();
int MenuInternInit(mgCMemory *, int, int);
extern float light_1062[4][4];
extern float lightcolor_1063[4][4];
extern "C" mgCCamera *__ct__9mgCCameraFf(mgCCamera *, float);
extern "C" CGameDataUsed *__ct__13CGameDataUsedFv(CGameDataUsed *);

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
    MENU_DRAW_ENV *draw_env;
    if ((draw_env = (MENU_DRAW_ENV *)operator new(sizeof(MENU_DRAW_ENV), MenuMainStack.Alloc(15))) != NULL) {
        __ct__9mgCCameraFf(&draw_env->camera, 8.0f);
    }
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
    CMenuKeyFunc *common;
    if ((common = (CMenuKeyFunc *)operator new(sizeof(CMenuKeyFunc), MenuMainStack.Alloc(0x18))) != NULL) {
        common->rect.Set(0, 0, 0, 0);
        __ct__13CGameDataUsedFv(&common->have_item);
        common->have_swap.Set(-1, 0, -1, 0);
        common->Initialize();
    }
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
        while (ReadBGSync() != 0) {}
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
        while (ReadBGSync() != 0) {}
        CMenuInterPt->InitEnd();
        CMenuInterPt->ReadBGTexture(2, 1);
        while (CMenuInterPt->ReadBGTexture(2, 0) == 0) {}
        ReturnMenuIntern(1);
        NextMenuInit(2, &MenuMainStack_Next, &texture_blocks[3]);
        MenuMainScene->fade.FadeIn(40);
        MenuCommonInfo->now_mode = 2;
        break;
    case 18:
        GamePad__2.KeyLock(1);
        MenuInternInit(menu_stack, MenuCommonInfo->open_type, 0);
        while (ReadBGSync() != 0) {}
        CMenuInterPt->InitEnd();
        CMenuInterPt->ReadBGTexture(7, 1);
        while (CMenuInterPt->ReadBGTexture(7, 0) == 0) {}
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
int MenuMainExit(void) {
    CCharacter2 *chara;
    int i;
    int activeChara;
    int isFishingMenu;
    CScene *scene;
    CScene *camera;
    float viewMatrix[4][4];
    float pos[4];
    float worldMatrix[4][4];
    float identity[4][4];

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
    activeChara = MenuUserDataManPtr->active_chr_no;
    GetBattleCharaInfo();
    if (MenuArg.end_code == 1) {
        activeChara = MenuArg.result[0];
        SetMenuEtcFlag(1);
    }
    (*(CUserDataManager **)((u8 *)MenuCommonInfo + 0xA0))->SetActiveChrNo(activeChara);
    if (MenuMainScene != NULL) {
        chara = (CCharacter2 *)MenuMainScene->GetCharacter(0);
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
    isFishingMenu = (MenuArg.end_code == 5) | (MenuArg.end_code == 6);
    if (activeChara == 0) {
        if (MenuUserParam.chara[0]->equip[0].IsFishingRod() != 0) {
            if (isFishingMenu == 0) {
                MenuArg.end_code = 11;
                MenuArg.result[0] = MenuUserDataManPtr->GetFishingRodNo();
                MenuArg.result[1] = MenuUserDataManPtr->GetFishBait();
                if (GetMenuLoopType() == 1) {
                    chara = (CCharacter2 *)MenuMainScene->GetCharacter(1);
                    if (chara != NULL) {
                        chara->DeleteImage();
                        ((CActionChara *)chara)->Initialize(NULL);
                    }
                    SetupUnitMan(MenuMainScene, MenuUserDataManPtr, activeChara, NULL);
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
    scene = (CScene *)GetMainScene();
    camera = (CScene *)scene->GetCamera(scene->active_camera);
    if (camera != NULL) {
        ((mgCCamera *)camera)->GetCameraMatrix(viewMatrix);
        GetPos__9mgCCameraFPf((mgCCamera *)camera, pos);
        sceVu0UnitMatrix(identity);
        sceVu0MulMatrix(worldMatrix, identity, viewMatrix);
        mgSetViewMatrix(worldMatrix, pos);
    }
    return 1;
}
int MenuMainLoop(void) {
    int next_mode = MenuMainKey();
    MenuMainDraw();
    return next_mode;
}
int MenuMainKey(void) {
    int result;
    short page;
    int menu;
    MenuKeyPageTable pageTable;

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
                        pageTable = at_1514__4;
                        MenuCommonInfo->now_mode = pageTable.next[page];
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
    MenuCommonInfo->unk_0 ^= 1;
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
void MenuMainDraw(void) {
    mgCDrawPrim *prim;
    int nextPage;

    if (MenuDoubleDrawCheck == 0) {
        prim = (mgCDrawPrim *)GetMenuPrim();
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
        nextPage = MenuCommonInfo->next_mode;
        if (nextPage >= 0) {
            if (MenuCommonInfo->now_mode != nextPage) {
                MenuCommonInfo->now_mode = nextPage;
                MenuCommonInfo->next_mode = -1;
            }
        }
        MenuDoubleDrawCheck = 1;
    }
}
int NextMenuInit(int menu, mgCMemory *memory, int *args) {
    int page;
    int known;
    int dungeonMode;
    char *mapName;

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
            dungeonMode = 0;
            if (MenuMainScene != NULL) {
                dungeonMode = MenuSaveDataDungeonPtr->stage_id;
            }
            if (TreeMapCallDungeonSubMap != 0) {
                mapName = GetMapName__6CSceneFi(MenuMainScene, MenuMainScene->active_map);
                if (strcmp(mapName, at_1598__2) == 0) {
                    dungeonMode = 1;
                }
                if (strcmp(mapName, at_1599__2) == 0) {
                    dungeonMode = 3;
                }
            }
            DngTreeMapInit(memory, args, page, dungeonMode);
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
    *(u_long128 *)MenuDrawEnv->ref = *(u_long128 *)menu_basedgRef;
    *(u_long128 *)MenuDrawEnv->pos = *(u_long128 *)menu_basedgCamPos;
    MenuDrawEnv->speed = roll;
    MenuDrawEnv->camera.Resume();
}
void MenuWorldTrans(void) {
    mgCCamera *camera;
    float viewMatrix[4][4];
    float pos[4];
    float worldMatrix[4][4];
    float identity[4][4];

    mgSetProjection(MenuDrawEnv->projection);
    camera = &MenuDrawEnv->camera;
    MenuDrawEnv->camera.GetCameraMatrix(viewMatrix);
    GetPos__9mgCCameraFPf(camera, pos);
    float rate = -1.0f;
    SetSpeed__9mgCCameraFff(camera, MenuDrawEnv->speed, rate);
    SetNextRef__9mgCCameraFPf(camera, MenuDrawEnv->ref);
    SetNextPos__9mgCCameraFPf(camera, MenuDrawEnv->pos);
    camera->Step(1);
    sceVu0UnitMatrix(identity);
    sceVu0MulMatrix(worldMatrix, identity, viewMatrix);
    mgSetViewMatrix(worldMatrix, pos);
}
void MenuPolygonSetEnv(void) {
    mgGetAmbient(MenuDrawEnv->old_ambient);
    mgSetAmbient(MenuDrawEnv->ambient);
}
void MenuPolygonEnvReset(void) {
    mgSetAmbient(MenuDrawEnv->old_ambient);
}
char *GetMenuCfgFileName(int index, int unused) {
    int local;

    sprintf(workchr_1622, at_1624__3, LanguageCode);
    strcat(workchr_1622, menu_main_cfgname_1620[index]);
    printf(at_1625__3, &local);
    return workchr_1622;
}
short *GetMenuMainMessageBuffer(void) {
    int size;

    return (short *)GetPackFile(MenuArg.pack, at_1630__3, &size);
}
u_int *GetMenuMainIMGPtr(void) {
    return GetPackFile(MenuArg.pack, at_1635__2, 0);
}
u_int *GetMenuMainPosCfgBuffer(int *size) {
    return GetPackFile(MenuArg.pack, at_1640, size);
}
extern "C" int GetBitCtrl__9CSaveDataFv(CSaveData *);
void SetCommonMenuModeID(void) {
    int table;
    int bitCtrl;
    int i;

    table = MenuCommonInfo->open_type;
    bitCtrl = GetBitCtrl__9CSaveDataFv(GetSaveData());
    if (table == 0x10) {
        table = 0;
    }
    if (table == 0x11) {
        table = 1;
    }
    if ((unsigned int)table < 2) {
        for (i = 0; i < 8; i++) {
            CommonMenuModeID2[i] = CommonMenuModeID[table][i];
            if (CommonMenuModeID2[i] == 6 && (bitCtrl & 0x10)) {
                CommonMenuModeID2[i] = 11;
                TreeMapCallDungeonSubMap = 1;
            }
        }
    }
}
int *GetCommonMenuModeID(void) {
    return CommonMenuModeID2;
}
int CursorSaveOptionState(void) {
    CSaveData *saveData = GetSaveData();
    int r = 0;
    if (saveData != NULL)
        r = (u8)!*(int *)&saveData->config;
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
void MenuAreaBoardNameStep(void) {
    AreaNameItems names;
    BoardPosition position;
    LanguageWidths widths;
    CDC2Mes *message;
    float hours;
    float minutes;
    int day;

    if (MenuAreaBrdForm != NULL) {
        names = at_1697__2;
        names.name[0] = MenuAreaName;
        message = MenuDCMsg[1];
        message->MakeMsg(0x32);
        message->SetMsgItemNo(names.name, 1);
        GetStrWidth__6ClsMesFPc(message, names.name[0]);
        position = at_1698__2;
        MenuAreaBrdForm->GetNextMovePos(position.value);
        widths = at_1699__2;
        message->SetMovePosCenteringGyou(0, position.value[0] + widths.value[LanguageCode],
                                         position.value[1] + 7);
        if (MenuTimeBrdForm != NULL) {
            hours = (int)MenuNowTime;
            minutes = (int)(60.0f * (MenuNowTime - hours));
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
            MenuTimeBrdForm->SetNumber(at_1739, (int)hours);
            MenuTimeBrdForm->SetNumber(at_1740, (int)minutes);
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
    int tour_event = GetSaveData()->CheckNowTourEvent();
    int tour_type = GetSaveData()->CheckNowTourType();
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
        *remaining_hours = (3 - days_into_cycle) * 24 - (int)time;
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
void MakeMenuTopic(void) {
    char text[0x80];
    int day;
    int height;
    int width;

    MenuTopicType = 0;
    MenuTopicAlpha = 0;
    MenuTopicAlphaCalc = 0;
    day = 0;
    MenuTopicType = CheckEventDay(&day);
    sprintf(text, topic_tbl_1777[LanguageCode][MenuTopicType], day);
    TopicFont.SetStr(text);
    char *topicText = (char *)&TopicFont;
    ((CFont *)topicText)->CalcDrawWH(topicText, &width, &height);
    MenuTopicLength = width;
    TopicFontX = 30;
}
#ifdef NONMATCHING
void DrawMenuTopic(void) {
    mgRect<int> box;
    mgRect<int> title_rect;
    mgRect<float> fill[4];

    if (MenuTopicType > 0 && MenuNowMapType != 5) {
        if (MenuNowMapType == 6) {
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
            prim->Begin(6);
            prim->Texture(TopicTex);
            prim->Color(0x80, 0x80, 0x80, MenuTopicAlpha);
            int title_width = 0x28;
            if (LanguageCode == 3) {
                title_width = 0x32;
            }
            title_rect.Set(0x66, 0, title_width, 0xC);
            PrimQuad(prim, 22.0f, 22.0f, title_rect);
            prim->End();
            manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
            SetSpriteEnv(prim, 1);
            prim->Begin(6);
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
            prim->Begin(4);
            fill[0].Set(20.0f, 36.0f, 40.0f, 24.0f);
            PrimFillRect4(prim, fill[0], menu_maintopic_colortbl_shadow[0], menu_maintopic_colortbl_shadow[1], menu_maintopic_colortbl_shadow[2], menu_maintopic_colortbl_shadow[3]);
            prim->End();
            prim->Begin(4);
            fill[1].Set(162.0f, 36.0f, 40.0f, 24.0f);
            PrimFillRect4(prim, fill[1], menu_maintopic_colortbl_shadow[1], menu_maintopic_colortbl_shadow[0], menu_maintopic_colortbl_shadow[3], menu_maintopic_colortbl_shadow[2]);
            prim->End();
            prim->Begin(4);
            fill[2].Set(20.0f, 36.0f, 90.0f, 24.0f);
            PrimFillRect4(prim, fill[2], menu_maintopic_colortbl[1], menu_maintopic_colortbl[0], menu_maintopic_colortbl[3], menu_maintopic_colortbl[2]);
            prim->End();
            prim->Begin(4);
            fill[3].Set(110.0f, 36.0f, 90.0f, 24.0f);
            PrimFillRect4(prim, fill[3], menu_maintopic_colortbl[0], menu_maintopic_colortbl[1], menu_maintopic_colortbl[2], menu_maintopic_colortbl[3]);
            prim->End();
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", DrawMenuTopic__Fv);
#endif
#ifdef NONMATCHING
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
    MenuInterMes = new ((u_long128 *)stack->Alloc(0x2A7)) CDC2Mes;
    int script_size;
    char *script = (char *)(stack->stack + stack->stack_used) + (stack->stack_size - stack->stack_used) * 16 - 0x32000;
    memcpy(script, GetMenuMainPosCfgBuffer(&script_size), script_size);
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
    MenuDCMsg[1]->cursor = 0;
    MenuDCMsg[1]->cursor_on = 1;
    MenuMesForm[0]->draw_flag = 1;
    MenuMesForm[1]->draw_flag = 1;
    MenuInterMesDrawFlag = 0;
    MenuPosData->AttachCommonTexInfo();
    HatumeiMenuOkFlag = 0;
    if (MenuUserDataManPtr->GetNumSameItem(0x171) > 0) {
        HatumeiMenuOkFlag = 1;
    }
    ManualMenuOkFlag = 0;
    if (MenuUserDataManPtr->GetNumSameItem(0x167) > 0) {
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
        while (CMenuInterPt->mode_list[icon_count] >= 0) {
            icon_count++;
        }
        MovePoint origin = at_1865;
        MovePoint pos = at_1866;
        MovePoint step = at_1867;
        for (int icon = 0; icon < icon_count; icon++) {
            char *name = (char *)GetMenuMainIconChar(CMenuInterPt->mode_list[icon]);
            pos.y = origin.y + step.y * icon;
            MenuPosData->SetFormPos(name, &pos.x);
        }
        int shown = 1;
        int hidden = 0;
        CMenuPosDataForm *form = MenuPosData->GetFormInfo(at_1933);
        if (form != NULL) {
            if (HatumeiMenuOkFlag == 0) {
                shown = 0;
                hidden = 1;
            }
            form->SetPartDrawFlag(at_1934, shown);
            form->SetPartDrawFlag(at_1935, hidden);
        }
        CMenuPosDataForm *manual_form = MenuPosData->GetFormInfo(at_1936);
        if (manual_form != NULL) {
            bool manual_hidden = false;
            int manual_shown = 1;
            if (ManualMenuOkFlag == 0) {
                manual_hidden = true;
                manual_shown = 0;
            }
            manual_form->SetPartDrawFlag(at_1934, manual_shown);
            manual_form->SetPartDrawFlag(at_1935, manual_hidden);
        }
        CMenuPosDataForm *world_form = MenuPosData->GetFormInfo(at_1937);
        if (world_form != NULL) {
            bool world_hidden = false;
            int world_shown = 1;
            if (WorldMapOkFlag == 0) {
                world_hidden = true;
                world_shown = 0;
            }
            world_form->SetPartDrawFlag(at_1934, world_shown);
            world_form->SetPartDrawFlag(at_1935, world_hidden);
            if (GetMenuLoopType() == MENU_LOOP_DUNGEON) {
                world_form->draw_flag = 0;
            }
        }
        CMenuPosDataForm *floor_form = MenuPosData->GetFormInfo(at_1938);
        if (floor_form != NULL) {
            bool floor_hidden = false;
            int floor_shown = 1;
            if (DngMoveMenuOkFlag == 0) {
                floor_hidden = true;
                floor_shown = 0;
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuInternInit__FP9mgCMemoryii);
#endif
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
void MenuCommonBaseDataEnter(mgCMemory *palletMemory, unsigned int *pack, int packSize, int block) {
    mgCTextureManager *tex = &mgTexManager;
    int size;
    MenuMainTextureReadBuf.stSetBuffer((u_long128 *)pack, packSize / 16);
    mgTexManager.EnterIMGFile((u8*)GetPackFile(pack, at_1956, 0), block, 0, 0);
    mgTexManager.EnterIMGFile((u8*)GetPackFile(pack, at_1957, &size), block, 0, 0);
    u8 *image = (u8*)GetPackFile(pack, at_1958, 0);
    if (image) {
        tex->EnterIMGFile(image, block, 0, 0);
    }
    ((CMenuPosDataManage *)MenuPosData)->AttachCommonTexInfo();
    MenuItemIconTextureBlock = block;
    ((CMenuPosDataManage *)MenuPosData)->MallocPallet(palletMemory);
    ((CMenuPosDataManage *)MenuPosData)->SearchTransPalletNo();
    MenuPosData->ResetTextureInfoAll();
}
void MenuBaseTextureReEnter() {
    mgCTextureManager *tex = &mgTexManager;
    int block = MenuCommonInfo->tex_block[1];
    tex->DeleteBlock(block);
    MenuMainImageDataEnter(block);
    unsigned int *pack = (unsigned int *)MenuMainTextureReadBuf.stack;
    int size;
    tex->EnterIMGFile((u8*)GetPackFile(pack, at_1956, 0), block, 0, 0);
    tex->EnterIMGFile((u8*)GetPackFile(pack, at_1957, &size), block, 0, 0);
    u8 *image = (u8*)GetPackFile(pack, at_1958, 0);
    if (image) {
        tex->EnterIMGFile(image, block, 0, 0);
    }
    ((CMenuPosDataManage *)MenuPosData)->AttachCommonTexInfo();
    MenuPosData->ResetTextureInfoAll();
}
#ifdef NONMATCHING
void CMenuInter::InitEnd() {
    int base_block = MenuCommonInfo->tex_block[1];
    mgCTextureManager *manager = &mgTexManager;
    BG_READ_INFO *base_data = GetReadBGFile(0);
    if (base_data != NULL) {
        MenuCommonBaseDataEnter(&MenuMainStack, (u_int *)base_data->buffer, base_data->size, base_block);
        help_update = 1;
        MenuMainStack.Align64();
        int remain = MenuMainStack.stack_size - MenuMainStack.stack_used;
        MenuMainStack_Next.stSetBuffer(MenuMainStack.stack + MenuMainStack.stack_used, remain);
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
        MovePoint pos = {0, 0};
        pos.x = (int)(board->x - 30.0f);
        pos.y = (int)(4.0f + board->y);
        SetFormPoint(MenuCommonInfo->cursor_form, (int)(board->x - 30.0f), (int)(4.0f + board->y));
        MenuCommonInfo->cursor_form->SetNextMovePos(&pos.x, 2);
        CMenuPosDataForm *next_form = MenuPosData->GetFormInfo(at_2004__2);
        if (next_form != NULL) {
            pos.x = (int)board->x;
            pos.y = (int)(4.0f + board->y);
            SetFormPoint(next_form, (int)board->x, (int)(4.0f + board->y));
            next_form->SetNextMovePos(&pos.x, 2);
        }
    }
    ReturnMenuIntern(0);
    MenuEtcInfo.tex_block = MenuArg.mes_tex_block;
    MenuEtcInfo.tex = manager->GetTexture(at_1028__4, -1);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", InitEnd__10CMenuInterFv);
#endif
#ifdef NONMATCHING
void CMenuInter::PushOk() {
    int mode = mode_list[select_no];
    MenuCommonInfo->SetWakuType(-1);
    int show_message = 0;
    int message_no = -1;
    int enable = 1;
    switch (mode) {
    default:
        enable = 0;
        break;
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
            enable = 0;
            if (CheckBitFlagMenu(0x258) == 1) {
                if (CheckBitFlagMenu(0x2E0) == 0) {
                    message_no = 0x2E;
                }
                enable = 0;
            }
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
    }
    if (show_message != 0) {
        step = MENU_INTER_STEP_MESSAGE;
        MenuInterMes->Init();
        MenuInterMes->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        MenuInterMes->MsgPreset(10);
        MenuInterMes->MakeMsg(message_no);
        MenuInterMes->SetAbsPos(5);
        MenuInterMesDrawFlag = 1;
        if (MenuCommonInfo->cursor_form != NULL) {
            MenuCommonInfo->cursor_form->draw_flag = 0;
        }
    }
    if (enable != 0) {
        next_mode = mode;
        MenuCommonInfo->key_enable = 0;
        MenuCommonInfo->CursorFadeOut(1.0f, 0);
        MenuSePlay(0x13);
        bg_read_wait = 0;
        if (MenuFormMI2 != NULL) {
            MenuFormMI2->rate_x = 4.0f;
            MenuFormMI2->rate_y = 4.0f;
            if (next_mode == MENU_MODE_CHARA_CHANGE) {
                MenuFormMI2->rate_x = 4.0f;
                MenuFormMI2->rate_y = 12.0f;
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", PushOk__10CMenuInterFv);
#endif
int CMenuInter::ReadBGTexture(int bgNo, int restart) {
    char name[0x80];
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
        entry = &filetbl_2141[bgNo - 2];
        if (strlen(*entry) != 0) {
            unsigned int size;
            strcpy(name, *entry);
            size = LoadFileMenu(
                name, (u_long128 *)(MenuMainStack_Next.stack + MenuMainStack_Next.stack_used), 0);
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
#ifdef NONMATCHING
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
        MenuSePlay(0);
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
    CMenuPosDataForm *icon_form = MenuPosData->GetFormInfo((char *)GetMenuMainIconChar(mode));
    if (old_select != CMenuInterPt->select_no && abs(old_select - CMenuInterPt->select_no) >= 2) {
        CMenuInterPt->cursor_jump = 1;
    }
    if (icon_form != NULL) {
        int pos[2] = {0, 0};
        pos[0] = (int)(icon_form->x - 42.0f);
        pos[1] = (int)icon_form->y;
        MenuCommonInfo->MenuPosStep(pos, NULL);
        if (CMenuInterPt->cursor_jump != 0) {
            MenuCommonInfo->MenuSetPos(pos[0], pos[1]);
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
            MenuSePlay(1);
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
                     ((CFadeInOut *)((u8 *)MenuMainScene + 0x2C70))->FadeCheck() != 0)) {
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
            if (GamePad__2.Down(0x20) != 0) {
                MenuActiveSaveData->day += 1;
                MenuSePlay(1);
            }
            if (GamePad__2.Down(0x40) != 0) {
                MenuActiveSaveData->SetBitFlag(0x36, 1);
            }
            if (GamePad__2.Down(0x10) != 0) {
                MenuActiveSaveData->SetBitFlag(0x36, 1);
                MenuActiveSaveData->SetBitFlag(0x158, 1);
                MenuActiveSaveData->SetBitFlag(0x1A8, 1);
                MenuActiveSaveData->ForceBootTour(MenuActiveSaveData->day, 1);
            }
            GamePad__2.Down(0x80);
            return 0;
        }
        switch (push) {
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
        case 8:
        case 4:
        case 1:
            CMenuInterPt->PushOk();
            break;
        }
        break;
    }
    MenuPosData->FormStep();
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuInternSelectKey__Fv);
#endif
#ifdef NONMATCHING
void MenuInternSelectDraw(void) {

    MenuPosData->FormDraw();
    if (MenuInterMesDrawFlag != 0 && MenuInterMes != NULL) {
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)0);
        MenuInterMes->DrawMsg();
    }
    DrawMenuTopic();
    if (menu_debug_flag != 0) {
        float box_w = (float)(mgScreenWidth - 360);
        DrawMenuFillBox(360.0f, 60.0f, box_w, 80.0f, 0x40, 0, 0, 0);
        CMenuFont font;
        char text[0x100];
        text[0] = 0;
        int bit_ctrl = MenuActiveSaveData->GetBitCtrl();
        if (bit_ctrl & 1) {
            strcat(text, at_2329);
        }
        if (bit_ctrl & 2) {
            strcat(text, at_2330);
        }
        if (bit_ctrl & 4) {
            strcat(text, at_2331);
        }
        if (bit_ctrl & 8) {
            strcat(text, at_2332);
        }
        if (bit_ctrl & 0x10) {
            strcat(text, at_2333__2);
        }
        if (bit_ctrl == 0) {
            strcpy(text, at_2334__2);
        }
        font.DrawDirect(text, 360, 60);
        float help_x = 300.0f, help_w = 190.0f;
        DrawMenuFillBox(help_x, 350.0f, help_w, 60.0f, 0x40, 0, 0, 0);
        font.DrawDirect(at_2335, 300, 350);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuInternSelectDraw__Fv);
#endif
void CopyActiveItemAndWeapon(int slot, int weaponSlot) {
    mgCTexture *textures[2];

    mgCTextureManager *manager = &mgTexManager;
    textures[0] = manager->GetTexture(at_2344, -1);
    textures[1] = manager->GetTexture(at_2345, -1);
    if (textures[0] == NULL || textures[1] == NULL) {
        return;
    }
    CopyActiveIconTexture(textures, slot, 0);
    manager->ReloadTexture(-1, (sceVif1Packet *)0);
}
#ifdef NONMATCHING
int CopyActiveIconTexture(mgCTexture **textures, int chara_no, u_int *unused) {
    CUserDataManager *user = GetUserDataMan();
    if (user == NULL) {
        return 0;
    }
    mgCTextureManager *manager = &mgTexManager;
    u_long128 *icon_clut[2];
    mgCTexture *icon_sheet[2];
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
        u8 transparent;
        int row;
        u8 *source;
        int slot;
        int offset;
        u8 *dest;
        u8 *pixels;
        manager->ReloadCLUT(textures[sheet], (sceVif1Packet *)NULL);
        memcpy(textures[sheet]->clut, icon_clut[sheet], 0x400);
        transparent = 0;
        for (int index = 0; index < 0x100; ++index) {
            if (((u8 *)textures[sheet]->clut)[index * 4 + 3] == 0) {
                transparent = index;
                break;
            }
        }
        pixels = (u8 *)textures[sheet]->image[0];
        offset = 0;
        for (slot = 0; slot < loopnumtbl_2360[sheet]; ++slot, offset += 0x20) {
            if (slot < 2) {
                dest = pixels + offset;
            } else {
                dest = pixels + (slot - 2) * 0x20 + 0x800;
            }
            int item_no = items[sheet * 4 + slot];
            if (item_no <= 0) {
                for (row = 0; row < 0x20; ++row) {
                    for (int x = 0; x < 0x20; x += 8) {
                        dest[x] = transparent;
                        dest[x + 1] = transparent;
                        dest[x + 2] = transparent;
                        dest[x + 3] = transparent;
                        dest[x + 4] = transparent;
                        dest[x + 5] = transparent;
                        dest[x + 6] = transparent;
                        dest[x + 7] = transparent;
                    }
                    dest += 0x40;
                }
            } else {
                int icon_no = GetItemIconNo(item_no);
                source = (u8 *)icon_sheet[sheet]->image[0] + (icon_no % 8) * 0x20 + (icon_no / 8) * 0x2000;
                for (row = 0; row < 0x20; ++row) {
                    memcpy(dest, source, 0x20);
                    dest += 0x40;
                    source += 0x100;
                }
            }
        }
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", CopyActiveIconTexture__FPP10mgCTextureiPUi);
#endif
void MenuDebugModeDraw() {

    float margin = 6.0f, width = 110.0f, height = 24.0f;
    struct {
        u8 prefix[0x94];
        int x;
        int y;
        u8 tail[0x1C];
    } menuFont;
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)0);
    DrawMenuFillBox(margin, margin, width, height, 0x5C, 0, 0, 0);
    __ct__9CMenuFontFv(&menuFont);
    ((CFont *)&menuFont)->SetStr(at_2450);
    ((CFont *)&menuFont)->SetPos(6, 6);
    DrawDirect__5CFontFPcii(&menuFont, (char *)&menuFont, menuFont.x, menuFont.y);
}
void BookshelfMessageMake(ClsMes *message, int baseWindow, int itemNo, int monsterNo) {

    int photos[5];
    char name[0x80];
    int windowNo;
    short chara;
    if (message != NULL) {
        windowNo = 0;
        chara = GetUserDataMan()->active_chr_no;
        if (chara == 0) {
            windowNo = 0xBBB;
            if (0 < itemNo) {
                CheckItemTable(itemNo, photos);
                GetPhotoNameStr(photos[0], name);
                strcpy(message->name[0], name);
                GetPhotoNameStr(photos[1], name);
                strcpy(message->name[1], name);
                GetPhotoNameStr(photos[2], name);
                strcpy(message->name[2], name);
                windowNo = baseWindow + 0xBB8;
            }
        }
        if (chara == 1) {
            windowNo = baseWindow + 0xBC5;
            if (0 <= monsterNo) {
                char *monsterName;
                char *monsterText;
                if (monsterNo > 9) {
                    monsterNo = 0;
                }
                int messageNo = monster_table[monsterNo].messageNo;
                monsterName = GetMonsterName(monster_table[monsterNo].nameNo);
                monsterText = GetItemMessage(messageNo);
                if (monsterName != NULL) {
                    strcpy(message->name[0], monsterName);
                }
                if (monsterText != NULL) {
                    strcpy(message->name[1], monsterText);
                }
                windowNo = baseWindow + 0xBC2;
                if (monsterNo == 8 || monsterNo == 1) {
                    windowNo += 10;
                }
            }
        }
        message->MakeMesWin(windowNo);
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", light_1062__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", lightcolor_1063__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_keyfunctbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_drawfunctbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_basedgRef__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", menu_basedgCamPos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", CommonMenuModeID__DATA);
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
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2329__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2330__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2331__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2332__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2333__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2334__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", at_2335__DATA);
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
INCLUDE_BSS(CommonMenuModeID2, 0x20);
CMenuFont TopicFont;
INCLUDE_BSS(at_2351, 0x20);
