#include "charasetup.hpp"
#include "dynamicanime.hpp"
#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstring>
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
void WorldMoveInit(mgCMemory *memory, int *args, int page);
short CheckEventDay(int *day);
void MenuWorldTrans(void);
void MenuDebugModeDraw(void);

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
extern u8 MenuDoubleDrawCheck;
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
extern int MenuTopicAlpha;
extern short MenuTopicLength;
extern int TopicFontX;
extern char *topic_tbl_1777[7][3];
extern "C" char *GetMapName__6CSceneFi(CScene *scene, int index);
extern CFont TopicFont;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuMainInit__FP13MENU_INIT_ARG);
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
u8 CursorSaveOptionState(void) {
    CSaveData *saveData = GetSaveData();
    u8 r = 0;
    if (saveData != NULL)
        r = !*(int *)&saveData->config;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", CheckEventDay__FPi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", DrawMenuTopic__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuInternInit__FP9mgCMemoryii);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", InitEnd__10CMenuInterFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", PushOk__10CMenuInterFv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuInternSelectKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", MenuInternSelectDraw__Fv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", CopyActiveIconTexture__FPP10mgCTextureiPUi);
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

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumain", __sinit_menumain_cpp);

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

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumain", D_0037B030__DATA);

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
INCLUDE_BSS(MenuMainStack, 0x30);
INCLUDE_BSS(MenuMainStack_Next, 0x30);
INCLUDE_BSS(CMenuInterStatic, 0x20);
INCLUDE_BSS(MenuPrimFix, 0x120);
INCLUDE_BSS(MenuItemUse, 0x20);
INCLUDE_BSS(MenuMainTextureReadBuf, 0x30);
INCLUDE_BSS(MenuSoundBuffer, 0x30);
INCLUDE_BSS(MenuArg, 0xA0);
INCLUDE_BSS(menu_old_chara_position, 0x10);
INCLUDE_BSS(menu_old_chara_rotation, 0x10);
INCLUDE_BSS(workchr_1622, 0x60);
INCLUDE_BSS(CommonMenuModeID2, 0x20);
INCLUDE_BSS(TopicFont, 0xC0);
INCLUDE_BSS(at_2351, 0x20);
