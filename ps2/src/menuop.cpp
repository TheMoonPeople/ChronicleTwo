#include "common.h"
#include "mw_runtime.h"

#include <cstddef>
#include <cstdio>
#include <cstring>

#include "actionchara.hpp"
#include "charasetup.hpp"
#include "dataread.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "memcard.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "movie.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Pairs two integer values used by menu operations.
 *
 */
struct IntPair {
    int a; /**< First value in the pair. */
    int b; /**< Second value in the pair. */
};

/**
 *
 * Stores a position on the menu screen.
 *
 */
struct ScreenPos {
    float x; /**< Horizontal screen coordinate. */
    float y; /**< Vertical screen coordinate. */
};

extern signed char        MovieViewFlag;
extern signed char        init_1254;
extern short              ManualMovieFadeCount_1253;
float                     MoviePreBattleBGMVol_Save;
float                     MoviePreBattleBGMVol;
extern char               at_1430__3[];
extern char               at_1431__3[];
extern char               at_1432__2[];
extern char               at_1433__3[];
extern char               at_1434__2[];
extern char               at_1435__2[];
extern char               at_1436__4[];
extern char               at_1437__3[];
extern char               at_1438__3[];
extern char               at_1439__3[];
extern char               at_1440__3[];
extern char               at_1441__2[];
CMenuPosDataForm         *LocalMenuBGForm;
CMenuPosDataForm         *LocalMenuClipForm;
extern signed char        manual_list_mesclstbl[5];
extern float              config_option_num_f;
extern char               at_1512__5[];
extern char               at_1513__5[];
extern char               at_1514__5[];
extern char               at_1515__2[];
extern char               at_1516__2[];
extern char               at_1517__3[];
extern char               at_1518__2[];
extern char               at_1519__2[];
CMovie                   *ManualMovie;
mgCTexture               *ManualMovieTex;
mgCMemory                 StaticMenuLocalStack;
mgCMemory                 StaticMenuLocalStack2;
extern short              Movie_BossFlag;
extern short              Movie_DungeonFlag;
extern short              MovieBgmBattleCheckStopFlag;
extern signed char        MovieBattleBGMPhase;
extern float              config_option_num_i;
extern IntPair            at_1614__2;
extern IntPair            at_1615__3;
extern IntPair            at_1616__2;
extern IntPair            at_1523__2;
extern char               at_1428__4[];
extern char               at_1429__3[];
extern char               at_1648__2[];
extern char               at_1649[];
extern char               at_1650__3[];
extern char               at_1651__2[];
extern char               at_1652__2[];
extern char               at_1653__2[];
extern char               at_1654__3[];
extern char               at_1655__4[];
extern char               at_1656__4[];
extern CMenuPosDataForm  *OptionButtonForm;
extern char               at_1900[];
extern char               at_1901[];
extern char               at_1902[];
extern char               at_1903[];
extern char               at_1904__2[];
extern char               at_1905__3[];
extern char               at_2603[];
extern char               at_2604[];
extern char               at_2605[];
extern char               at_1906__2[];
extern short              manual_boot_event_no[];
extern char              *submap_table_1022[];
extern char               at_1102[];
extern char               at_1103__3[];
extern char               at_1104__5[];
extern char               at_1105__2[];
extern char               at_1106__2[];
extern char               at_1107__3[];
extern char               at_1108[];
extern char               at_1109__2[];
extern char               at_1237__4[];
extern char               at_1238__2[];
extern short              fillw_1125[];
extern char               at_2895[];
extern CScene::BGM_STATUS SubGameDataBgm;
mgCMemory                 SaveMenuStack;
extern CDC2Mes           *SaveFileList[13];
extern char              *space_2549;
extern char               init_2550;
extern char              *b_2715[3];
extern char               at_2764[];
extern char               at_2765[];
extern char               at_2766[];
extern char               at_2767[];
extern char               at_2768[];
extern char               at_2769[];
extern char               at_2770__2[];
extern char               at_2771__2[];
extern char               at_2772__2[];
extern char               at_2773__2[];
extern char               at_2774__2[];
extern char               at_2775__2[];
extern short              SubGameSaveBlock[3];
extern signed char        SubGameSaveOrLoad;
extern short              SubGameSaveOrLoadPhase;
extern short              SubGameSaveLoadStatus;
extern signed char        SubGameMCPort;
int                       SubTrueTotalSaveFileSize;
int                       SubCheckTotalSaveFileSize;
mgCTexture               *Tex_SaveFile;
float                     SubSaveTileXY;
extern char               at_2821__2[];
extern char               at_2822[];
extern char               at_2823[];
extern char               at_2824[];
extern char               at_2825[];
extern char               at_2826__2[];
extern char               at_2827[];
extern char               at_2498[];
extern char               at_2499[];
extern char               at_2500[];
extern char               at_2501[];
extern char               at_2502[];
extern char               at_2503[];
extern char               at_2504__2[];
extern char               at_2505__2[];
extern char               at_2506__2[];
extern char               at_2507__2[];
extern char               at_2508__2[];
extern char               at_2509__2[];
extern char               at_2510__2[];
extern char               at_2511[];
extern char               at_2512__2[];
extern char               at_2513[];
extern char               at_2514[];
extern char               at_2515[];
extern char              *tbl_2023[2];
extern char              *tp_2083[4];
extern unsigned char      conv_2316[];
extern short              TreeMapSaveNum;
extern char               at_3198__2[];
extern char               at_3199__3[];
extern char               at_3200__2[];
extern char               at_3201__3[];
extern char               at_3202__3[];
extern char               at_3203[];
extern char               at_3204[];
extern char               at_3205[];
extern char               at_3206[];
extern char               at_3207[];
void                      InitMnOnePictTex();

CMemoryCardManager *MemoryCardPtr;
CSaveMenuClass     *SaveMenuPtr;
CMenuOption        *CMenuOptionPtr;
CManualMenu        *CManualPtr;
CDC2Mes            *MenuReturnMsg;
extern u8           MenuReturnMsgDrawFlag;
extern int          MnOnePictTex[8];
extern char        *dngmap_2627[];
char               *SubGameSaveCFGBuffer;
extern int          SubGameSaveCFGBufferSize;
extern SaveIconSet  at_2609__2;
extern short        MenuMapInfoSave_DngNo;

// Code (.text)
void InitMenuReturnMsg(mgCMemory *stack) {
    CDC2Mes *window;
    short   *system_mes;
    ClsMes  *mes;
    int      width;
    int      height;

    MenuReturnMsg = NULL;

    if (LanguageCode > 0) {
        window = new (stack->Alloc(0x2A7)) CDC2Mes;
        MenuReturnMsg = window;
        MenuReturnMsg->texture_block = MenuArg.mes_tex_block;
        MenuReturnMsg->buff = NULL;
        system_mes = GetSystemMesBuffer();
        MenuReturnMsg->SetMessData(system_mes, GetMenuMainMessageBuffer());
        MenuReturnMsg->MsgPreset(3);
        ((ClsMes *) MenuReturnMsg)->mes_no = -1;
        MenuReturnMsg->MakeMsg(0x5A);
        MenuReturnMsg->StepMsg();
        mes = MenuReturnMsg;
        width = mes->text_w;
        width += 0x20;
        height = mes->text_h;
        height += 0x1A;
        MenuReturnMsg->SetPutPos(0x100 - (width >> 1), (mgScreenHeight - height) - 0x18, width,
                                 height);
    }

    MenuReturnMsgDrawFlag = 0;
}

void SetMenuReturnMsgCtrl(int show) {
    MenuReturnMsgDrawFlag = show != 0;

    if (LanguageCode == 0) {
        MenuReturnMsgDrawFlag = 0;
    }

    if (MenuReturnMsg == NULL) {
        MenuReturnMsgDrawFlag = 0;
    }
}

void DrawMenuReturnMsg() {
    if ((MenuReturnMsgDrawFlag != 0) && (MenuReturnMsg != NULL)) {
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
        MenuReturnMsg->StepMsg();
        MenuReturnMsg->DrawMsg();
    }
}

int CheckOmakeVtuto(int entry) {
    if (OmakeFlag == 1) {
        if (GetNowLoopNo() == (int) LOOP_DUNGEON) {
            if (entry == 0x23 || entry == 0x24) {
                return 1;
            }
        }
    }

    return 0;
}

void InitMnOnePictTex() {
    MnOnePictTex[0] = 0;
    MnOnePictTex[1] = 0;
    MnOnePictTex[2] = 0;
    MnOnePictTex[3] = 0;
    MnOnePictTex[4] = 0;
    MnOnePictTex[5] = 0;
    MnOnePictTex[6] = 0;
    MnOnePictTex[7] = 0;
}

#ifdef NONMATCHING
void MenuManualInit(mgCMemory *memory, int *tex_block, int mode) {
    CManualMenu *menu;
    u_int       *pack;
    u_char      *menu_data;
    int          menu_data_size;
    short       *main_messages;
    CDC2Mes     *window;
    int          list;
    int          item;
    int          entry;
    int          number;
    int          unlocked;
    int          vtuto;
    int          map_no;
    int          i;
    int          free_size;
    int          block;
    signed char *list_tbl;

    free_size = memory->stGetRest();
    StaticMenuLocalStack.stSetBuffer(memory->stGetTop(), free_size);
    ManualMovie = (CMovie *) operator new(sizeof(CMovie), StaticMenuLocalStack.Alloc(0x2396));

    menu = new (StaticMenuLocalStack.Alloc(0x1A)) CManualMenu;

    CManualPtr = menu;
    menu->SetTexBlock(tex_block);
    InitMnOnePictTex();
    pack = (u_int *) memory->stack;
    block = CManualPtr->tex_block[0];
    mgTexManager.DeleteBlock(block);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile(pack, at_1102, NULL), block, NULL, NULL);
    block = CManualPtr->tex_block[1];
    mgTexManager.DeleteBlock(block);
    mgTexManager.EnterTexture(block, at_1103__3, NULL, 0x100, 0x200, 8, NULL, 0, 0);
    ManualMovieTex = mgTexManager.EnterTexture(block, at_1104__5, NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, NULL, 0, 0);
    menu_data = (u_char *) GetPackFile(pack, at_1105__2, &menu_data_size);

    if (menu_data != NULL) {
        MenuDataAnalyze((char *) menu_data, menu_data_size, &StaticMenuLocalStack);
    }

    StaticMenuLocalStack.Align64();
    free_size = StaticMenuLocalStack.stGetRest();
    StaticMenuLocalStack2.stSetBuffer(StaticMenuLocalStack.stGetTop(), free_size);
    AttachMessageForm();
    LocalMenuBGForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1106__2);
    LocalMenuClipForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1107__3);
    CManualPtr->script = (char *) GetPackFile(pack, at_1108, &CManualPtr->script_size);
    main_messages = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuDCMsg[2]->buff;
    MenuCommandAnalyzeInfo.mes_buff[1] = main_messages;
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = main_messages;
    MenuDCMsg[7]->SetMessData(GetSystemMesBuffer(), main_messages);
    MenuDCMsg[7]->MsgPreset(0x10);
    MenuDCMsg[7]->MakeMsg(0x11C6);
    CManualPtr->ExeScript(at_1109__2);
    list_tbl = manual_list_mesclstbl;

    for (list = 0, entry = 0; list < 5; list++, entry += 10) {
        window = MenuDCMsg[list_tbl[list]];
        window->value_half = 0;

        if (LanguageCode >= 2) {
            window->value_half = 1;
        }

        for (item = 0; item < 10; item++) {
            number = item + entry;
            window->MakeMsg(0x746);
            window->values[item] = number + 1;
            window->value_width[item] = 2;

            if (item >= 0 && item < 0x10) {
                window->item_mes[item] = 0x50;
            }

            unlocked = CheckBitFlagMenu(manual_boot_event_no[number]);
            vtuto = 0;

            if (CheckOmakeVtuto(number) != 0) {
                vtuto = 1;
            }

            if (unlocked != 0 || vtuto != 0) {
                if (item >= 0 && item < 0x10) {
                    window->item_mes[item] = number + 0x1194;
                }

                if ((number == 0x15 || number == 0x16) && item >= 0 && item < 0x14) {
                    window->line_color[item] = 0x80E0E060;
                }
            }
        }
    }

    Movie_DungeonFlag = GetNowLoopNo() == (int) LOOP_DUNGEON;
    Movie_BossFlag = 0;
    DNG_BATTLE_AREA *battle_area = &GetMainScene()->battle_area;

    if (battle_area != NULL) {
        Movie_BossFlag = battle_area->boss_map;
    }

    MovieBgmBattleCheckStopFlag = 0;

    if (Movie_DungeonFlag == 1 && Movie_BossFlag == 0) {
        map_no = MenuMainScene->now_map_no;

        for (i = 0; submap_table_1022[i] != NULL; i++) {
            if (map_no == SearchMapNo(submap_table_1022[i])) {
                Movie_BossFlag = 1;
            }
        }
    }

    MenuMainFrameModeSet(8, 1);
    MovieBattleBGMPhase = 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", MenuManualInit__FP9mgCMemoryPii);
#endif

int MenuManualKey() {
    return CManualPtr->KeyStep();
}

void MenuManualDraw() {
    CManualMenu      *menu;
    CUserDataManager *userData;
    u_long128        *effectBuffer;
    u_long128        *buffer;
    mgCTexture       *picture;
    int               closed;
    int               isTown;
    int               attribute;
    int               chrNo;
    CActionChara     *chara;

    menu = CManualPtr;
    closed = 0;
    switch (menu->key_arg_no) {
        case MANUAL_STEP_FADE_OUT + 1:
        case MANUAL_STEP_CLOSE:
        case MANUAL_STEP_END:
            mgCTextureManager *textures = &mgTexManager;
            if (menu->pict_mode != 0) {
                picture = (mgCTexture *) MnOnePictTex[menu->pict_page];
                if (picture != NULL) {
                    textures->ReloadTexture(picture->block, (sceVif1Packet *) NULL);
                    PrimQuad(picture, mgRect<int>(0, 0, 0x200, mgScreenHeight), mgRect<int>(0, 0, 0x200, 0x1A0), 0x80, 0x80, 0x80, 0x80);
                    DrawMenuFillBox(35.0f, (float) (mgScreenHeight - 0x28), (float) fillw_1125[LanguageCode],
                                    30.0f, 0x40, 0, 0, 0);
                    if (MenuDCMsg[7] != NULL) {
                        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
                        MenuDCMsg[7]->SetPutPos(0x28, mgScreenHeight - 0x24, -1, -1);
                        MenuDCMsg[7]->StepMsg();
                        MenuDCMsg[7]->DrawMsg();
                    }
                    if (CManualPtr->key_arg_no == MANUAL_STEP_END) {
                        closed = 1;
                    }
                }
            } else {
                ManualMovie->SwitchThread();
                textures->ReloadTexture(CManualPtr->tex_block[1], (sceVif1Packet *) NULL);
                CPreSprite prim;
                prim.Initialize(NULL, NULL);
                prim.Preset2D();
                prim.AlphaBlendEnable(0);
                prim.TextureMapEnable(1);
                prim.Begin(MG_PRIM_SPRITE);
                prim.Color(0, 0, 0, 0x80);
                prim.SetIRect(0, 0, mgScreenWidth, mgScreenHeight, 0, 0);
                prim.Texture(ManualMovieTex);
                prim.Color(0x80, 0x80, 0x80, 0x80);
                prim.SetIStretch(0, 0, mgScreenWidth, 0x1A0, 0, 0, 0x200, 0x1A0);
                prim.End();
                textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
                MovieCCDraw();
                if (CManualPtr->key_arg_no == MANUAL_STEP_END) {
                    ManualMovie->Term();
                    ManualMovie->SwitchThread();
                    sceGsSyncV(0);
                    sceGsSyncV(0);
                    sceGsSyncV(0);
                    userData = GetUserDataMan();
                    StaticMenuLocalStack2.stReset();
                    buffer = StaticMenuLocalStack2.stGetTop();
                    isTown = (u_char) !GetMenuLoopType();
                    textures->DeleteBlock(MenuArg.chara_tex_block);
                    MenuArg.chara_stack->stReset();
                    SetupMainUnit(buffer, MenuArg.chara_stack, MenuArg.base_chara_stack,
                                  MenuArg.chara_tex_block, GetMainScene(), userData,
                                  userData->active_chr_no, isTown);
                    MenuCharaSoundLoad(&StaticMenuLocalStack2, userData->active_chr_no, 0);
                    chara = (CActionChara *) GetMainScene()->GetCharacter(0);
                    MenuCharaSoundEnter(GetMainScene(), chara, 1);
                    if (userData->active_chr_no == USER_CHARA_MONSTER) {
                        StaticMenuLocalStack2.stReset();
                        MonsterEffectRead(&StaticMenuLocalStack2, userData->monster_id, 0);
                        StaticMenuLocalStack2.Align64();
                        StaticMenuLocalStack2.Alloc(0x280);
                        effectBuffer = StaticMenuLocalStack2.stGetTop();
                        MonsterEffectEnter(GetMainScene(), effectBuffer, 0xAA);
                    }
                    if (isTown == 0) {
                        chara->effect_man = FxScriptMan;
                        chrNo = GetUserDataMan()->active_chr_no;
                        attribute = GetUserDataMan()->GetCharaStatusAttirbute(chrNo);
                        if ((chrNo == 1 || chrNo == 0) && (attribute & 0x28)) {
                            chara->SetHold();
                        }
                    }
                    chara->Step();
                    SetMenuEtcFlag(1);
                    MenuMainTextureReadBuf.stReset();
                    LoadFileMenu(at_1237__4, MenuMainTextureReadBuf.stGetTop(), 1);
                    MenuBaseTextureReEnter();
                    closed = 1;
                }
            }
            break;
        case MANUAL_STEP_FADE_OUT:
        default:
            MenuPosData->FormDraw();
            break;
    }
    if (menu_debug_flag != 0) {
        DrawMenuFillBox(300.0f, 10.0f, 310.0f, 24.0f, 0x40, 0, 0, 0);
        CMenuFont menuFont;
        menuFont.DrawDirect(at_1238__2, 0x12C, 0xA);
    }
    if (closed != 0) {
        SetMenuFrameRate(1);
        StaticMenuLocalStack2.stReset();
        MenuMainScene->StopBGM(0);
        sceGsSyncV(0);
        sceGsSyncV(0);
        sceGsSyncV(0);
        CSnd.SndInReverb(1);
        MenuMainScene->LoadBGM(CManualPtr->bgm_status.load_no,
                               StaticMenuLocalStack2.stGetTop());
        MenuMainScene->SetActiveBgmStatus(&CManualPtr->bgm_status);
        if (Movie_DungeonFlag != 0) {
            if (MovieBgmBattleCheckStopFlag != 0) {
                MenuMainScene->battle_area.pause_flag |= DNG_PAUSE_BATTLE_MUSIC;
            } else {
                MenuMainScene->battle_area.pause_flag &= ~DNG_PAUSE_BATTLE_MUSIC;
            }
        }
        ReStartEnvSoundMenu();
        CManualPtr->FadeInMenu(0x32, 0.0f);
        CManualPtr->key_arg_no = 0;
    }
}

int CManualMenu::KeyStep() {
    int                finished;
    int                move_type;
    mgCTextureManager *textures;
    int                frame_end;
    int                pushed;
    mgCMemory         *chara;
    int                keys;
    int                prev_select;
    int                pressed;
    int                unlocked;
    int                viewable;
    int                i;
    int                movie_no;
    int                prev_page;
    int                close_now;
    int                stop_env;
    u_int              data_size;
    int                blocks;
    int                event_no;
    int                file_size;
    int                free_size;
    u_char            *img_data;
    u_long128         *buffer;
    int               *common_mode;
    CScene            *scene;
    DNG_BATTLE_AREA   *area;
    int                battle_stop;
    u_int              snd_id;

    finished = 0;
    move_type = 2;
    common_mode = GetCommonMenuModeID();

    if (mode == 2) {
        move_type = 0;
    }

    MenuPosData->StepMainMenuIconMove(common_mode, 8, move_type);
    frame_end = GetMenuMainFrameEndFlag();

    switch (mode) {
        case 1:
            if (ReadBGSync() == 0 && frame_end != 0) {
                MenuCommonInfo->key_enable = 1;
                MenuCommonInfo->CursorFadeIn(10.0f, 1);
                MenuCommonInfo->SetMoveMethod(2);
                mode = 0;
                cursor_jump = 1;
                MovieViewFlag = 1;
            }

            break;
        case 2:
            if (frame_end != 0) {
                ExeScript(at_1428__4);
                MenuCommonInfo->SetMoveMethod(2);
                finished = 1;
            }

            break;
        case 0:
            if (init_1254 == 0) {
                ManualMovieFadeCount_1253 = 0;
                init_1254 = 1;
            }

            MenuCommonInfo->CheckSelectKey();
            pushed = MenuCommonInfo->CheckPushButton();
            keys = MenuCommonInfo->CheckLRKey();

            switch (key_arg_no) {
                case MANUAL_STEP_SELECT:
                    prev_select = select;
                    MenuKeySelectCheck(MenuListSelectKeyCheck(keys, 10), &select, &top, 0, 0x2E,
                                       10, (int) MENU_CURSOR_LIMIT_CLAMP);

                    if (prev_select != select) {
                        MenuSePlay(0);
                    }

                    pressed = ConvertCheckPushButton(pushed);

                    if (pressed & 1) {
                        unlocked = CheckBitFlagMenu(manual_boot_event_no[select]);
                        viewable = 0;

                        if (CheckOmakeVtuto(select) != 0) {
                            viewable = 1;
                        }

                        if (MovieViewFlag != 0 && (unlocked != 0 || viewable != 0)) {
                            key_arg_no = MANUAL_STEP_FADE_OUT;
                            FadeOutMenu(0x3C, 0.0f);
                            MenuSePlay(1);
                            MovieBattleBGMPhase = 1;
                        } else {
                            MenuSePlay(5);
                        }
                    } else if (pressed & 2) {
                        ReturnMenuIntern(0);
                        MenuMainFrameModeSet(9, 0);
                        MenuCommonInfo->SetMoveMethod(-1);
                        ExeScript(at_1429__3);
                        mode = 2;
                    } else if (menu_debug_flag != 0 && (pressed & 8)) {
                        for (i = 0; i < (event_no = manual_boot_event_no[i]); i++) {
                            GetSaveData()->SetBitFlag(event_no, 1);
                        }
                    }

                    break;
                case MANUAL_STEP_FADE_OUT:
                    if (FadeCheckMenu() != 0) {
                        CSnd.SndInReverb(0);
                        stop_env = 1;

                        if (Movie_DungeonFlag != 0 && OmakeFlag == 0 && Movie_BossFlag != 1) {
                            stop_env = 0;
                        }

                        StopEnvSoundMenu(stop_env);
                        MovieBgmBattleCheckStopFlag = 0;

                        if (Movie_DungeonFlag != 0) {
                            scene = MenuMainScene;
                            MovieBgmBattleCheckStopFlag = battle_stop = scene->battle_area.pause_flag & DNG_PAUSE_BATTLE_MUSIC;

                            scene->battle_area.pause_flag |= DNG_PAUSE_BATTLE_MUSIC;
                        }

                        MenuMainScene->GetActiveBgmStatus(&bgm_status);
                        MenuMainScene->StopBGM(0);
                        sceGsSyncV(0);
                        StaticMenuLocalStack2.stack_used = 0;
                        StaticMenuLocalStack2.lock = 0;
                        sndStep(2.0f);

                        if (select == 0x18 || select == 0x19) {
                            MenuMainScene->LoadBGM(0x97, StaticMenuLocalStack2.stack +
                                                             StaticMenuLocalStack2.stack_used);
                        } else {
                            MenuMainScene->LoadBGM(0xC0, StaticMenuLocalStack2.stack +
                                                             StaticMenuLocalStack2.stack_used);
                        }

                        sndStep(2.0f);
                        MenuMainScene->PlayBGM(0, -1, 1.0f);
                        pict_mode = 0;
                        movie_no = select + 1;
                        textures = &mgTexManager;

                        if (movie_no == 0x16 || movie_no == 0x17) {
                            data_size = 0;
                            buffer = StaticMenuLocalStack2.stack + StaticMenuLocalStack2.stack_used;

                            if (movie_no == 0x16) {
                                data_size = LoadFileMenu(at_1430__3, buffer, 1);
                            }

                            if (movie_no == 0x17) {
                                data_size = LoadFileMenu(at_1431__3, buffer, 1);
                            }

                            if ((data_size & 0xF) != 0) {
                                blocks = (data_size >> 4) + 1;
                            } else {
                                blocks = data_size >> 4;
                            }

                            StaticMenuLocalStack2.Alloc(blocks);
                            img_data = (u_char *) GetPackFile((u_int *) buffer, at_1432__2, NULL);
                            textures->DeleteBlock(tex_block[2]);
                            textures->DeleteBlock(tex_block[3]);
                            textures->EnterIMGFile(img_data, tex_block[2], NULL, NULL);
                            pict_mode = 1;
                            pict_num = 6;
                            pict_page = 0;

                            if (movie_no == 0x17) {
                                pict_num = 3;
                            }

                            MnOnePictTex[0] = (int) textures->GetTexture(at_1433__3, -1);
                            MnOnePictTex[1] = (int) textures->GetTexture(at_1434__2, -1);
                            MnOnePictTex[2] = (int) textures->GetTexture(at_1435__2, -1);
                            MnOnePictTex[3] = (int) textures->GetTexture(at_1436__4, -1);
                            MnOnePictTex[4] = (int) textures->GetTexture(at_1437__3, -1);
                            MnOnePictTex[5] = (int) textures->GetTexture(at_1438__3, -1);
                            int first_page[2] = {0, 0};
                            first_page[0] = pict_page + 1;
                            first_page[1] = pict_num;
                            MenuDCMsg[7]->SetMsgVolumeNo(first_page, 2);
                        } else {
                            if (GetUserDataMan()->active_chr_no == 3) {
                                DeleteMonsterEffect();
                            }

                            if (movie_no == 0x15) {
                                movie_no = 0x2C;
                            } else if (movie_no >= 0x18) {
                                movie_no = select - 2;
                            }

                            textures->ReloadTexture(tex_block[1], (sceVif1Packet *) NULL);
                            movie_stack.stack_used = 0;
                            movie_stack.lock = 0;
                            chara = MenuArg.chara_stack;
                            chara->stack_used = 0;
                            chara->lock = 0;
                            chara->Align64();
                            buffer = chara->stack + chara->stack_used;
                            file_size = 0;
                            char name[0x40];
                            sprintf(name, at_1439__3, LanguageCode);
                            LoadFile2(name, buffer, &file_size, 0);
                            chara->Alloc(file_size / 16 + 1);
                            chara->Align64();
                            MovieCCInit((char *) buffer, file_size, select + 1);
                            free_size = chara->stGetRest();
                            movie_stack.stSetBuffer(chara->stGetTop(), free_size);
                            MenuMainTextureReadBuf.stack_used = 0;
                            MenuMainTextureReadBuf.lock = 0;
                            mgCMemory *streams[6] = {&StaticMenuLocalStack2, &movie_stack,
                                                     &movie_stack, &movie_stack,
                                                     &MenuMainTextureReadBuf, &movie_stack};
                            char       movie_name[0x28];

                            if (movie_no > 0x16) {
                                sprintf(movie_name, at_1440__3, movie_no);
                            } else {
                                sprintf(movie_name, at_1441__2, movie_no);
                            }

                            ManualMovie->Load(movie_name, streams, 0x200, 0x1A0, true, false,
                                              false);
                            ManualMovie->Play(at_1104__5);
                            ManualMovie->SwitchThread();

                            while (ManualMovie->IsStarted() == 0) {
                                ManualMovie->SwitchThread();
                            }

                            SetMenuFrameRate(2);
                        }

                        key_arg_no = MANUAL_STEP_PLAY;
                        ManualMovieFadeCount_1253 = 0;
                    }

                    break;
                case MANUAL_STEP_PLAY:
                    if (ManualMovieFadeCount_1253 < 3) {
                        ManualMovieFadeCount_1253++;

                        if (ManualMovieFadeCount_1253 == 3) {
                            MenuMainScene->fade.FadeIn(0x14);
                        }
                    } else if (pict_mode != 0) {
                        prev_page = pict_page;

                        if (keys & 4) {
                            pict_page = prev_page - 1;
                        }

                        if ((keys & 8) || (pushed & 1)) {
                            pict_page = pict_page + 1;
                        }

                        if (pict_page < 0) {
                            pict_page = pict_num - 1;
                        }

                        if (pict_num <= pict_page) {
                            pict_page = 0;
                        }

                        if (prev_page != pict_page) {
                            int turned_page[2] = {0, 0};
                            turned_page[0] = pict_page + 1;
                            turned_page[1] = pict_num;
                            MenuDCMsg[7]->SetMsgVolumeNo(turned_page, 2);
                            MenuSePlay(0);
                        }

                        if ((pushed & 2) != 0) {
                            FadeOutMenu(0x1E, 0.0f);
                            key_arg_no = MANUAL_STEP_CLOSE;
                            MenuSePlay(5);
                        }
                    } else {
                        close_now = -1;

                        if (ManualMovie->EndCheck() != 0 || (pushed & 0x10) || (pushed & 2)) {
                            close_now = 1;
                        }

                        if (close_now > 0) {
                            FadeOutMenu(0x1E, 0.0f);
                            key_arg_no = MANUAL_STEP_CLOSE;
                        }
                    }

                    break;
                case MANUAL_STEP_CLOSE:
                    if (FadeCheckMenu() != 0) {
                        key_arg_no = MANUAL_STEP_END;
                        MovieBattleBGMPhase = 3;
                    }

                    break;
            }

            break;
    }

    if (key_arg_no != MANUAL_STEP_PLAY) {
        MenuPosData->FormStep();
        CalcTex();
        CalcCursorPosition();
    }

    if (Movie_DungeonFlag != 0) {
        area = &MenuMainScene->battle_area;

        if (OmakeFlag == 0 && Movie_BossFlag != 1 && !(area->pause_flag & DNG_PAUSE_BATTLE_MUSIC)) {
            snd_id = EdEventInfo.snd_id[4];

            switch (MovieBattleBGMPhase) {
                case 0:
                    break;
                case 1:
                    MoviePreBattleBGMVol_Save = area->battle_bgm_vol;
                    sndSetSeVolf(snd_id, 0, 0.0f, 0);
                    MovieBattleBGMPhase++;
                    break;
                case 2:
                    CalcMenuAdd(&MoviePreBattleBGMVol, -0.025f, 0.0f);
                    sndSetSeVolf(snd_id, 0, MoviePreBattleBGMVol, 0);
                    break;
                case 3: {
                    float increment = 0.033333335f;
                    CalcMenuAdd(&MoviePreBattleBGMVol, increment, MoviePreBattleBGMVol_Save);
                    sndSetSeVolf(snd_id, 0, MoviePreBattleBGMVol, 0);
                    break;
                }
                case 4:
                    sndSetSeVolf(snd_id, 0, MoviePreBattleBGMVol_Save, 0);
                    break;
            }
        }
    }

    return finished;
}

void CManualMenu::CalcTex() {
    CMenuPosDataForm   *bg_form;
    int                 slide_in;
    int                 slide_in_flag;
    float              *left_top;
    int                 xy[2];
    float               speed;
    float               target;
    int                 column_shift;
    int                 shifted;
    signed char        *list_tbl;
    int                 list;
    CDC2Mes            *mes;
    CMenuPosDataForm   *panel;
    int                 item_pos[10][2];
    int                 item;
    int                 first_y;
    CMenuPosDataForm   *form;
    MENUFORMPARTS_TYPE *bar[3];
    int                 scroll_range[2];
    int                 visible_top;

    bg_form = LocalMenuBGForm;

    if (bg_form == NULL) {
        return;
    }

    slide_in = 0;
    slide_in_flag = 0;
    left_top = GetMenuMainFrameLeftTopPos(0);
    xy[0] = fptosi(left_top[0]);
    xy[1] = fptosi(480.0f + left_top[1]);

    if (GetMenuMainFrameEndFlag() == 0) {
        slide_in = 1;
        slide_in_flag = 1;
        bg_form->x = (float) xy[0];
        bg_form->y = (float) xy[1];
    } else {
        bg_form->x = (float) xy[0];
    }

    bg_form->GetPutPosXY(at_1512__5, xy[0], xy[1]);
    speed = 3.5f;

    if (mode == 2 || mode == 1) {
        speed = 1.0f;
    }

    target = (float) (xy[1] - top * 24);
    CalcMenu1(target, &list_y, speed, speed, 0);

    if ((float) xy[1] < list_y) {
        list_y = target;
    }

    xy[1] = fptosi(list_y);
    column_shift = 0;
    shifted = 0;
    list_tbl = manual_list_mesclstbl;

    for (list = 0; list < 5; list++) {
        first_y = xy[1];
        mes = MenuDCMsg[list_tbl[list]];
        panel = MenuMesForm[list_tbl[list]];

        for (item = 0; item < 10; item++) {
            item_pos[item][0] = xy[0] + column_shift;
            item_pos[item][1] = xy[1];
            xy[1] += 24;

            if (CheckNowEurope() != 0 && shifted == 0 && item >= 8) {
                column_shift = 8;
                shifted = 1;
            }
        }

        mes->SetMsgItemPos(&item_pos[0][0], 10);

        if (xy[1] < 0x48 || first_y > 0x186) {
            panel->draw_flag = 0;
        } else {
            panel->draw_flag = 1;
        }
    }

    bg_form->GetPutPosXY(at_1513__5, xy[0], xy[1]);
    form = MenuMesForm[3];

    if (form != NULL) {
        form->x = (float) xy[0];
        form->y = (float) xy[1];
    }

    bar[0] = bg_form->GetPartInfo(at_1514__5);
    bar[1] = bg_form->GetPartInfo(at_1515__2);
    bar[2] = bg_form->GetPartInfo(at_1516__2);
    bg_form->GetPutPosXY(at_1517__3, item_pos[0][0], item_pos[0][1]);
    MenuPosData->GetEtcTblValue(at_1518__2, scroll_range[0], scroll_range[1]);

    if (slide_in_flag == 0) {
        visible_top = top;
        LocalFunc_AdjustScrlBar(bar, &item_pos[0][0], scroll_range,
                                visible_top, 46.0f, 10.0f, slide_in);
    }

    if (LocalMenuClipForm != NULL) {
        LocalMenuBGForm->GetPutPosXY(at_1519__2, xy[0], xy[1]);
        form = LocalMenuClipForm;
        form->x = (float) xy[0];
        form->y = (float) xy[1];
    }
}

void CManualMenu::CalcCursorPosition() {
    IntPair position = at_1523__2;

    switch (key_arg_no) {
        case MANUAL_STEP_SELECT:
        case MANUAL_STEP_PLAY:
            break;
    }

    if (LocalMenuBGForm != NULL) {
        LocalMenuBGForm->GetPutPosXY(at_1512__5, position.a, position.b);
    }

    position.a -= 50;
    position.b += (select - top) * 24;
    MenuCommonInfo->MenuPosStep(&position.a, NULL);

    if (cursor_jump != 0) {
        MenuCommonInfo->MenuSetPos(position.a, position.b);
        cursor_jump = 0;
    }
}

int CMenuOption::KeyStep() {
    int finished;
    int move_type;
    int frame_end;
    int changed;
    int step;
    int keys;
    int pushed;
    int prev_choice;

    finished = 0;
    move_type = 2;

    if (mode == 2) {
        move_type = 0;
    }

    if (MenuArg.open_type == MENU_OPEN_OPTION) {
        move_type = 2;
    }

    MenuPosData->StepMainMenuIconMove(GetCommonMenuModeID(), 7,
                                      move_type);
    frame_end = GetMenuMainFrameEndFlag();

    switch (mode) {
        case 1:
            if (this->step == 0 && ReadBGSync() == 0 && frame_end != 0) {
                GamePad__2.KeyLock(0);
                MenuCommonInfo->SetWakuType(0);
                MenuCommonInfo->SetMoveMethod(2);
                cursor_jump = 1;
                mode = 0;
                CBaseMenuClass::ExeScript(at_1648__2);

                if (MenuArg.open_type == MENU_OPEN_OPTION) {
                    CBaseMenuClass::ExeScript(at_1649);
                    this->step = 1;
                    mode = 1;
                }
            }

            if (this->step == 1 && CBaseMenuClass::FadeCheckMenu() != 0) {
                this->step = 0;
                mode = 0;
            }

            break;
        case 2:
            if (MenuArg.open_type == MENU_OPEN_OPTION) {
                if (CBaseMenuClass::FadeCheckMenu() != 0) {
                    return 1;
                }

                break;
            }

            if (frame_end != 0) {
                CBaseMenuClass::ExeScript(at_1428__4);

                if (MenuConfigPtr != NULL) {
                    printf(at_1650__3, MenuConfigPtr->eye_reverse);
                    printf(at_1651__2, MenuConfigPtr->rot_normal);

                    if (MenuConfigPtr->sound_mode != 0) {
                        CSnd.SetStereoMode(0);
                    } else {
                        CSnd.SetStereoMode(1);
                    }
                }

                MenuCommonInfo->SetMoveMethod(2);
                finished = 1;
            }

            break;
        case 0:
            changed = 0;
            MenuCommonInfo->CheckSelectKey();
            pushed = MenuCommonInfo->CheckPushButton();
            keys = MenuCommonInfo->CheckLRKey();
            step = MenuListSelectKeyCheck(keys, 9);

            if (MenuKeySelectCheck(step, &select, &top, 0, fptosi(config_option_num_i), 9,
                                   (int) MENU_CURSOR_LIMIT_CLAMP) != 0) {
                changed = 1;
            }

            prev_choice = choice;

            if (keys & 4) {
                choice = prev_choice - 1;
            }

            if (keys & 8) {
                choice += 1;
            }

            if (choice < 0) {
                choice = 0;
            }

            if (choice_num[select] <= choice) {
                choice = choice_num[select] - 1;
            }

            if (prev_choice != choice) {
                changed = 1;
            }

            if (changed != 0) {
                MenuSePlay(0);
            }

            switch (ConvertCheckPushButton(pushed)) {
                case 1:
                    if (select == (int) OPTION_ITEM_CAPTIONS) {
                        config.caption_off = choice;
                    } else if (select == (int) OPTION_ITEM_PAUSE_OVERLAY) {
                        config.pause_overlay_off = choice;
                    } else if (select == (int) OPTION_ITEM_CAMERA_VERTICAL) {
                        config.eye_reverse = choice;
                    } else if (select == (int) OPTION_ITEM_CAMERA_ROTATION) {
                        config.rot_normal = choice;
                    } else if (select != (int) OPTION_ITEM_ANGER_COUNTER || config.enemy_hp != 1) {
                        *value[select] = choice;

                        if (select == (int) OPTION_ITEM_ENEMY_HP && choice == 1) {
                            *value[(int) OPTION_ITEM_ANGER_COUNTER] = 1;
                        }
                    }

                    UpdateOptionForm();
                    MenuSePlay(1);
                    break;
                case 8:
                    MenuSePlay(1);
                    InitSV_CONFIG_OPTION((&config));
                    UpdateOptionForm();
                    break;
                case 2:
                    mode = 2;
                    memcpy(MenuConfigPtr, &config, sizeof(config));
                    MenuCommonInfo->SetMoveMethod(-1);
                    MenuCommonInfo->SetWakuType(-1);

                    if (MenuArg.open_type == MENU_OPEN_OPTION) {
                        CBaseMenuClass::ExeScript(at_1652__2);
                    } else {
                        MenuMainFrameModeSet(9, 0);
                        ReturnMenuIntern(0);
                        MenuCommonInfo->SetWakuType(-1);
                        CBaseMenuClass::ExeScript(at_1429__3);
                    }

                    break;
            }

            break;
    }

    CalcTex();
    MenuPosData->FormStep();
    {
        IntPair pos = at_1614__2;
        IntPair size = at_1615__3;
        IntPair velocity = at_1616__2;
        int     limit[2];
        char    name[0x20];
        int     row_no;
        int     choice_no;

        switch (mode) {
            case 1:
                if (MenuArg.open_type != MENU_OPEN_OPTION) {
                    break;
                }
            case 0:
                row_no = select;
                choice_no = choice;

                if (row_no < 10) {
                    sprintf(name, at_1653__2, row_no, choice_no);
                } else {
                    sprintf(name, at_1654__3, row_no, choice_no);
                }

                OptionButtonForm->GetPutPosXY(name, pos.a, pos.b);
                pos.a -= 2;
                pos.b -= 3;
                sprintf(name, at_1655__4, select);
                MenuPosData->GetEtcTblValue(name, size.a, size.b);
                MenuCommonInfo->SetWakuWH(0, size.a, size.b);
                MenuPosData->GetEtcTblValue(at_1656__4, limit[0], limit[1]);

                if (pos.b < limit[0]) {
                    pos.b = limit[0];
                }

                if (limit[1] < pos.b) {
                    pos.b = limit[1];
                }

                MenuCommonInfo->MenuPosStep(&pos.a, &velocity.a);
                break;
        }

        if (cursor_jump != 0) {
            MenuCommonInfo->MenuSetPos(pos.a, pos.b);
            cursor_jump = 0;
        }
    }
    return finished;
}

void CMenuOption::CalcTex() {
    CMenuPosDataForm   *bg_form;
    int                 slide_in;
    int                 slide_in_flag;
    float              *left_top;
    int                 xy[2];
    float               speed;
    float               target;
    signed char        *list_tbl;
    int                 list;
    CMenuPosDataForm   *mes_form;
    CMenuPosDataForm   *clip_form;
    int                 item_pos[10][2];
    int                 item;
    CMenuPosDataForm   *form;
    MENUFORMPARTS_TYPE *bar[3];
    int                 scroll_range[2];

    bg_form = LocalMenuBGForm;

    if (bg_form == NULL) {
        return;
    }

    slide_in = 0;
    slide_in_flag = 0;
    left_top = GetMenuMainFrameLeftTopPos(0);
    xy[0] = fptosi(left_top[0]);
    xy[1] = fptosi(480.0f + left_top[1]);

    if (GetMenuMainFrameEndFlag() == 0) {
        slide_in = 1;
        slide_in_flag = 1;
        bg_form->x = (float) xy[0];
        bg_form->y = (float) xy[1];
    } else {
        bg_form->x = (float) xy[0];
    }

    bg_form->GetPutPosXY(at_1512__5, xy[0], xy[1]);
    speed = 3.5f;

    if (mode == 2) {
        speed = 2.0f;
    }

    target = (float) (xy[1] - top * 24);
    CalcMenu1(target, &list_y, speed, speed, 0);

    if ((float) xy[1] < list_y) {
        list_y = target;
    }

    xy[1] = fptosi(list_y);
    list_tbl = manual_list_mesclstbl;

    for (list = 0; list < 3; list++) {
        for (item = 0; item < 10; item++) {
            item_pos[item][0] = xy[0];
            item_pos[item][1] = xy[1];
            xy[1] += 24;
        }

        MenuDCMsg[list_tbl[list]]->SetMsgItemPos(&item_pos[0][0], 10);
    }

    form = OptionButtonForm;

    if (form != NULL) {
        xy[1] = fptosi(list_y - 3.0f);
        form->x = (float) xy[0];
        form->y = (float) xy[1];
    }

    bg_form->GetPutPosXY(at_1513__5, xy[0], xy[1]);
    mes_form = MenuMesForm[3];

    if (mes_form != NULL) {
        mes_form->x = (float) xy[0];
        mes_form->y = (float) xy[1];
    }

    bar[0] = bg_form->GetPartInfo(at_1514__5);
    bar[1] = bg_form->GetPartInfo(at_1515__2);
    bar[2] = bg_form->GetPartInfo(at_1516__2);
    bg_form->GetPutPosXY(at_1517__3, item_pos[0][0], item_pos[0][1]);
    MenuPosData->GetEtcTblValue(at_1518__2, scroll_range[0], scroll_range[1]);

    if (slide_in_flag == 0) {
        LocalFunc_AdjustScrlBar(
            bar, &item_pos[0][0], scroll_range, top, config_option_num_f, 9.0f, slide_in);
    }

    if (LocalMenuClipForm != NULL) {
        bg_form->GetPutPosXY(at_1519__2, xy[0], xy[1]);
        clip_form = LocalMenuClipForm;
        clip_form->x = (float) xy[0];
        clip_form->y = (float) xy[1];
    }
}

void CMenuOption::DefaultButton(MENUFORMPARTS_TYPE **row) {
    int i;

    for (i = 0; i < 3; i++) {
        if (row[i] != NULL) {
            row[i]->rgba[0] = 0x40;
            row[i]->rgba[1] = 0x40;
            row[i]->rgba[2] = 0x40;
        }
    }
}

void CMenuOption::EnableButton(MENUFORMPARTS_TYPE *button) {
    button->rgba[0] = 0x80;
    button->rgba[1] = 0x80;
    button->rgba[2] = 0x80;
}

void CMenuOption::UpdateOptionForm() {
    SV_CONFIG_OPTION    *config;
    MENUFORMPARTS_TYPE **row;
    int                  i;
    int                  offset;
    MENUFORMPARTS_TYPE **loop_row;

    if (OptionButtonForm != NULL) {
        config = &this->config;

        if (config != NULL) {
            row = this->button[(int) OPTION_ITEM_CURSOR_MEMORY];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->cursor_save]);
            }

            row = this->button[(int) OPTION_ITEM_VIBRATION];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->vibration]);
            }

            row = this->button[(int) OPTION_ITEM_MESSAGE_SPEED];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->message_speed]);
            }

            row = this->button[(int) OPTION_ITEM_SOUND_MODE];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->sound_mode]);
            }

            row = this->button[(int) OPTION_ITEM_TIME_SPEED];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->fast_time]);
            }

            loop_row = this->button[(int) OPTION_ITEM_MINIMAP];

            if (loop_row != NULL) {
                DefaultButton(loop_row);

                for (i = 0, offset = 0; i < 3; i++, offset += 4) {
                    if (config->map == i) {
                        EnableButton(*(MENUFORMPARTS_TYPE **) ((u8 *) loop_row + offset));
                    }
                }
            }

            row = this->button[(int) OPTION_ITEM_DAMAGE_NUMBERS];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->damage_off]);
            }

            row = this->button[(int) OPTION_ITEM_ENEMY_HP];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->enemy_hp]);
            }

            row = this->button[(int) OPTION_ITEM_ANGER_COUNTER];

            if (row != NULL) {
                DefaultButton(row);

                if (config->enemy_hp == 0) {
                    EnableButton(row[config->anger_counter]);
                }
            }

            row = this->button[9];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->unk_24]);
            }

            row = this->button[(int) OPTION_ITEM_MONSTER_NAME];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->monster_name]);
            }

            row = this->button[(int) OPTION_ITEM_DEPTH_OF_FIELD];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->dof_off]);
            }

            row = this->button[(int) OPTION_ITEM_CAPTIONS];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[(signed char) config->caption_off]);
            }

            row = this->button[(int) OPTION_ITEM_PAUSE_OVERLAY];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[(signed char) config->pause_overlay_off]);
            }

            row = this->button[(int) OPTION_ITEM_CAMERA_VERTICAL];

            if (LanguageCode > 0) {
                if (row != NULL) {
                    DefaultButton(row);
                    EnableButton(row[config->eye_reverse]);
                }

                row = this->button[(int) OPTION_ITEM_CAMERA_ROTATION];

                if (row != NULL) {
                    DefaultButton(row);
                    EnableButton(row[config->rot_normal]);
                }
            }
        }
    }
}

void MenuOptionInit(mgCMemory *memory, int *tex_block, int mode) {
    CMenuOption       *menu;
    u_int             *pack;
    u_char            *menu_data;
    int                menu_data_size;
    short             *main_messages;
    int                block;
    mgCTextureManager *textures;
    int                option;
    int                choice;
    int                free_size;
    char               prefix[0x20];
    char               name[0x20];

    free_size = memory->stGetRest();
    StaticMenuLocalStack.stSetBuffer(memory->stGetTop(), free_size);

    menu = new (StaticMenuLocalStack.Alloc(0x3B)) CMenuOption;

    CMenuOptionPtr = menu;
    menu->SetTexBlock(tex_block);
    CMenuOptionPtr->select = 0;
    CMenuOptionPtr->top = 0;
    config_option_num_i = 14.0f;
    config_option_num_f = 14.0f;

    if (LanguageCode > 0) {
        config_option_num_i = 16.0f;
        config_option_num_f = 16.0f;
    }

    pack = (u_int *) memory->stack;
    textures = &mgTexManager;
    block = CMenuOptionPtr->tex_block[0];
    textures->DeleteBlock(block);
    textures->EnterIMGFile((u_char *) GetPackFile(pack, at_1102, NULL), block, NULL, NULL);
    textures->EnterIMGFile((u_char *) GetPackFile(pack, at_1900, NULL), block, NULL, NULL);

    if (MenuArg.open_type == (int) MENU_OPEN_OPTION) {
        textures->EnterIMGFile((u_char *) GetMenuMainIMGPtr(), block, NULL, NULL);
    }

    menu_data = (u_char *) GetPackFile(pack, at_1901, &menu_data_size);

    if (menu_data != NULL) {
        MenuDataAnalyze((char *) menu_data, menu_data_size, &StaticMenuLocalStack);
    }

    AttachMessageForm();
    LocalMenuBGForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1106__2);
    LocalMenuClipForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1107__3);
    OptionButtonForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1902);

    for (option = 0; option < OPTION_ITEM_MAX; option++) {
        if (option < 10) {
            sprintf(prefix, at_1903, option);
        } else {
            sprintf(prefix, at_1904__2, option);
        }

        for (choice = 0; choice < OPTION_BUTTON_NUM; choice++) {
            CMenuOptionPtr->button[option][choice] = NULL;

            if (OptionButtonForm != NULL) {
                strcpy(name, prefix);
                strcat(name, at_1905__3);
                sprintf(name, name, choice);
                CMenuOptionPtr->button[option][choice] = OptionButtonForm->GetPartInfo(name);
            }
        }
    }

    memcpy(&CMenuOptionPtr->config, MenuConfigPtr, sizeof(CMenuOptionPtr->config));
    memcpy(&CMenuOptionPtr->config_backup, MenuConfigPtr, sizeof(CMenuOptionPtr->config_backup));
    CMenuOptionPtr->script = (char *) GetPackFile(pack, at_1906__2, &CMenuOptionPtr->script_size);
    CMenuOptionPtr->value[(int) OPTION_ITEM_CURSOR_MEMORY] = &CMenuOptionPtr->config.cursor_save;
    CMenuOptionPtr->value[(int) OPTION_ITEM_VIBRATION] = &CMenuOptionPtr->config.vibration;
    CMenuOptionPtr->value[(int) OPTION_ITEM_MESSAGE_SPEED] = &CMenuOptionPtr->config.message_speed;
    CMenuOptionPtr->value[(int) OPTION_ITEM_SOUND_MODE] = &CMenuOptionPtr->config.sound_mode;
    CMenuOptionPtr->value[(int) OPTION_ITEM_TIME_SPEED] = &CMenuOptionPtr->config.fast_time;
    CMenuOptionPtr->value[(int) OPTION_ITEM_MINIMAP] = &CMenuOptionPtr->config.map;
    CMenuOptionPtr->value[(int) OPTION_ITEM_DAMAGE_NUMBERS] = &CMenuOptionPtr->config.damage_off;
    CMenuOptionPtr->value[(int) OPTION_ITEM_ENEMY_HP] = &CMenuOptionPtr->config.enemy_hp;
    CMenuOptionPtr->value[(int) OPTION_ITEM_ANGER_COUNTER] = &CMenuOptionPtr->config.anger_counter;
    CMenuOptionPtr->value[9] = &CMenuOptionPtr->config.unk_24;
    CMenuOptionPtr->value[(int) OPTION_ITEM_MONSTER_NAME] = &CMenuOptionPtr->config.monster_name;
    CMenuOptionPtr->value[(int) OPTION_ITEM_DEPTH_OF_FIELD] = &CMenuOptionPtr->config.dof_off;

    for (int item = 0; (float) item < config_option_num_i; item++) {
        CMenuOptionPtr->choice_num[item] = 2;
    }

    CMenuOptionPtr->choice_num[(int) OPTION_ITEM_MINIMAP] = 3;
    CMenuOptionPtr->UpdateOptionForm();
    main_messages = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuDCMsg[2]->buff;
    MenuCommandAnalyzeInfo.mes_buff[1] = main_messages;
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = main_messages;
    CMenuOptionPtr->ExeScript(at_1109__2);
    MenuMainFrameModeSet(8, 1);
    MenuCommonInfo->SetMoveMethod(-1);
}

int MenuOptionKey() {
    return CMenuOptionPtr->KeyStep();
}

void MenuOptionDraw() {
    MenuPosData->FormDraw();
}

void LocalFunc_AdjustScrlBar(MENUFORMPARTS_TYPE **parts, int *pos, int *size, int top,
                             float line_num, float show_num, int jump) {
    if (parts[0] != NULL && parts[1] != NULL && parts[2] != NULL) {
        float visible_ratio = (float) size[1] / line_num;
        float bar_height = visible_ratio * show_num;
        parts[1]->h = (bar_height - parts[0]->h) - parts[2]->h;
        size[1] -= bar_height;
        float travel_lines = line_num - show_num;
        if (travel_lines < 1.0f) {
            travel_lines = 1.0f;
        }
        float pixels_per_line = (float) size[1] / travel_lines;
        CalcMenu1((float) pos[1] + pixels_per_line * (float) top, &parts[0]->y, 4.0f, 0.0f, jump);
        parts[1]->y = parts[0]->y + parts[0]->h;
        parts[2]->y = parts[1]->y + parts[1]->h;
    }
}

void CSaveMenuClass::SetDlInfoMsg(int load, int show) {
    int message_no = 0xC08;

    if (load == 1) {
        message_no = 0xC09;
    }

    MenuDCMsg[7]->MakeMsg(message_no);
    MenuDCMsg[7]->StepMsg();
    CMenuPosDataForm *form;
    (form = MenuMesForm[7])->x = (mgScreenWidth - MenuDCMsg[7]->line_w[0]) >> 1;
    form->y = 168.0f;
    MenuMesForm[7]->draw_flag = show != 0;
}

void CSaveMenuClass::EnvSetSave(int kind) {
    CDC2Mes *save_mes;
    int      func_no;
    int      size_kind;
    int      data_size;

    dl_base = 0;

    if (kind == 0) {
        func_no = 6;
        phase = 2;
        size_kind = 1;
    } else {
        func_no = 3;
        phase = 0xA;
        size_kind = 0;
    }

    MemoryCardPtr->file_no = select;
    MemoryCardPtr->SetFuncNo(func_no);
    data_size = MemoryCardPtr->GetSaveDataSize(size_kind);

    if (kind == 1) {
        data_size -= 0x1000;
    }

    save_mes = MenuDCMsg[2];
    save_mes->MsgPreset(0xA, LanguageCode);
    save_mes->push_button = 0;
    save_mes->SetAbsPos(8);
    save_mes->MakeMsg(0xBBF);
    save_mes->SetMsgVolumeNoOne(slot + 1);

    if (cursor_form != NULL) {
        cursor_form->draw_flag = 0;
    }

    InitMenuDl(dl_tex, data_size);
    SetDlInfoMsg(0, 1);
}

/**
 *
 * Returns the memory card state for a valid save menu port.
 *
 */
static inline MC_CARD_INFO *GetSaveMenuCard(int port) {
    CMemoryCardManager *mc = MemoryCardPtr;
    if (port == 0 || port == 1) {
        return &mc->card[port];
    }
    return NULL;
}
#ifdef NONMATCHING
int CSaveMenuClass::KeyStep(void) {
    int                 transferred;
    int                 finished;
    CDC2Mes            *fileMes;
    CDC2Mes            *titleMes;
    int                 stepResult;
    MC_ERROR_INFO      *error;
    int                 next;
    int                 refresh;
    int                 openDone;
    int                 moveKey;
    int                 selectKeys;
    bool                input_waiting;
    int                 pushed;
    int                 lrKeys;
    int                 answer;
    int                 cursorPos;
    int                 fileNo;
    int                 index;
    MC_CARD_INFO       *card;
    SAVEDATA_INFO      *info;
    int                 emptyMes;
    int                 row;
    int                 mapNo;
    int                 chapter;
    SAVEDATA_INFO      *rowInfo[13];
    CDC2Mes            *rowMes;
    int                 formPos[2];
    CMemoryCardManager *manager;

    finished = 0;
    stepResult = MemoryCardPtr->Step();
    fileMes = MenuDCMsg[2];
    titleMes = MenuDCMsg[3];
    error = &MemoryCardPtr->error;
    static int FormatCase = 0;
    if (DebugFlag != 0 && menu_debug_flag != 0) {
        GamePad__2.Down(PAD_L1);
    }
    refresh = 0;
    next = -1;
    switch (CBaseMenuClass::mode) {
        case 1:
            openDone = 0;
            if (step == 0) {
                if (first_step != 0) {
                    next = 0;
                }
                if (FadeCheckMenu() != 0) {
                    MenuCommonInfo->key_enable = 1;
                    save_kb = MemoryCardPtr->GetSaveDataSize(MC_SIZE_SAVE_TOTAL) / 1024;
                    check_kb = save_kb + 3;
                    need_kb = save_kb + 4;
                    FormatCase = 0;
                    chapter8_start = CheckStartChapter8(GetSaveData());
                    if (mode == SAVE_MENU_MODE_LOAD || mode == SAVE_MENU_MODE_GYORACE_LOAD) {
                        chapter8_start = 0;
                    }
                    if (chapter8_start == 1) {
                        ExeScript(at_2498);
                        step = 1;
                    } else {
                        openDone = 1;
                    }
                }
            } else if (step == 1 && MenuCommonInfo->CheckPushButton() != 0) {
                openDone = 1;
                ExeScript(at_2499);
            }
            if (openDone != 0) {
                CBaseMenuClass::mode = 0;
                step = 0;
            }
            break;
        case 2:
            if (FadeCheckMenu() != 0) {
                MemoryCardPtr->FinishForMC();
                if (mode == SAVE_MENU_MODE_SAVE) {
                    ResetMapInfo();
                    ReStartEnvSoundMenu();
                    MenuMainScene->StopBGM(0);
                    MenuMainScene->LoadBGM(bgm_status.load_no, SaveMenuStack.stGetTop());
                    MenuMainScene->SetActiveBgmStatus(&bgm_status);
                    MenuMainScene->StepSnd();
                }
                finished = 1;
            }
            break;
        default:
            static int DarkClonicleFileMax = 0;
            moveKey = 0;
            selectKeys = MenuCommonInfo->CheckSelectKey();
            pushed = MenuCommonInfo->CheckPushButton();
            lrKeys = MenuCommonInfo->CheckLRKey();
            if (selectKeys & 1) {
                moveKey -= 1;
            }
            if (selectKeys & 2) {
                moveKey += 1;
            }
            switch (page) {
                case SAVE_MENU_PAGE_SLOT_SELECT:
                    if (step == 0) {
                        int prevSlot = slot;
                        slot = prevSlot + moveKey;
                        if (slot < 0) {
                            slot = 0;
                        }
                        if (slot > 1) {
                            slot = 1;
                        }
                        if (slot != prevSlot) {
                            MenuSePlay(SYSTEM_SE_CURSOR);
                        }
                        if (cursor_form != NULL) {
                            cursor_form->SetAction(tbl_2023[slot]);
                        }
                        switch (ConvertCheckPushButton(pushed)) {
                            case 1:
                                MenuSePlay(SYSTEM_SE_DECIDE);
                                MemoryCardPtr->InitPlayDataInfo();
                                next = SAVE_MENU_PAGE_CARD_INFO;
                                MemoryCardPtr->port = slot;
                                break;
                            case 2:
                                MenuSePlay(5);
                                if (save_count <= 0 && chapter8_start == 1) {
                                    step = 1;
                                    ExeScript(at_2500);
                                } else {
                                    FadeOutMenu(0x28, 0.0f);
                                    CBaseMenuClass::mode = 2;
                                }
                                break;
                        }
                    } else if (step == 1) {
                        answer = fileMes->YesNoCursor2(0);
                        if (answer == 1) {
                            FadeOutMenu(0x28, 0.0f);
                            CBaseMenuClass::mode = 2;
                            MenuSePlay(SYSTEM_SE_DECIDE);
                        }
                        if (answer == 2) {
                            step = 0;
                            ExeScript(at_2501);
                        }
                    }
                    break;
                case SAVE_MENU_PAGE_CARD_INFO:
                    card = GetSaveMenuCard(slot);
                    if (stepResult != 0) {
                        if (McCheckMCPs2(card) == 0) {
                            next = SAVE_MENU_PAGE_ERROR;
                        } else {
                            MemoryCardPtr->SetFuncNo(MC_FUNC_GET_ALL_FILE_INFO);
                            next = SAVE_MENU_PAGE_FILE_READ;
                            InitMenuDl(NULL, 0);
                        }
                    }
                    break;
                case SAVE_MENU_PAGE_FILE_READ:
                    transferred = MemoryCardPtr->total_transferred;
                    StepMenuDl2(transferred);
                    card = GetSaveMenuCard(slot);
                    if (stepResult != 0) {
                        if (McCheckMCPs2(card) == 0) {
                            next = SAVE_MENU_PAGE_ERROR;
                        } else if (mode == SAVE_MENU_MODE_LOAD && card->formatted == 0) {
                            next = SAVE_MENU_PAGE_ERROR;
                        } else if (mode == SAVE_MENU_MODE_LOAD && MemoryCardPtr->CheckDataFileNum() <= 0) {
                            next = SAVE_MENU_PAGE_ERROR;
                        } else {
                            next = SAVE_MENU_PAGE_FILE_LIST;
                            index = MemoryCardPtr->GetUpdateFile();
                            if (index < 0) {
                                index = 0;
                            }
                            select = index;
                            top = select;
                            if (top > 10) {
                                top = 10;
                            }
                            InitMenuDl(NULL, 0);
                        }
                    }
                    break;
                case SAVE_MENU_PAGE_FILE_LIST:
                    card = GetSaveMenuCard(slot);
                    if ((phase == SAVE_LIST_PHASE_SELECT || phase == SAVE_LIST_PHASE_CONFIRM_SAVE ||
                         phase == SAVE_LIST_PHASE_CONFIRM_LOAD) &&
                        card_ok == 1 && card_ok != McCheckMCPs2(card)) {
                        next = SAVE_MENU_PAGE_ERROR;
                        card_changed = 1;
                        phase = SAVE_LIST_PHASE_SELECT;
                    } else {
                        static signed char input_wait_counter = 0;
                        switch (phase) {
                            case SAVE_LIST_PHASE_SELECT:
                                if ((lrKeys & 0x10) || (lrKeys & 0x40)) {
                                    moveKey -= 2;
                                } else if ((lrKeys & 0x20) || (lrKeys & 0x80)) {
                                    moveKey += 2;
                                }
                                if (MenuKeySelectCheck(moveKey, &select, &top, 0, 0xD, 3, (int) MENU_CURSOR_LIMIT_CLAMP) != 0) {
                                    MenuSePlay(SYSTEM_SE_CURSOR);
                                    input_wait_counter = 4;
                                }
                                if (cursor_form != NULL) {
                                    cursor_form->SetAction(tp_2083[select - top]);
                                }
                                info = &MemoryCardPtr->file_info[select];
                                input_wait_counter--;
                                if (input_wait_counter <= 0) {
                                    input_wait_counter = 0;
                                }
                                input_waiting = input_wait_counter > 0;
                                if (!input_waiting) {
                                    card_ok = McCheckMCPs2(card);
                                    switch (ConvertCheckPushButton(pushed)) {
                                        case 1:
                                            ExeScript(at_2502);
                                            if (McCheckMCPs2(card) == 0) {
                                                phase = SAVE_LIST_PHASE_SELECT;
                                                next = SAVE_MENU_PAGE_ERROR;
                                                MenuSePlay(SYSTEM_SE_DECIDE);
                                            } else {
                                                fileNo = select + 1;
                                                if (mode == SAVE_MENU_MODE_SAVE) {
                                                    if (card->formatted == 0) {
                                                        next = SAVE_MENU_PAGE_FORMAT;
                                                        FormatCase = 1;
                                                        phase = SAVE_LIST_PHASE_SELECT;
                                                        MenuSePlay(SYSTEM_SE_DECIDE);
                                                    } else {
                                                        input_wait_counter = 0;
                                                        if (info->state == 1) {
                                                            save_kind = 0;
                                                            fileMes->SetMsgVolumeNoOne(fileNo);
                                                            fileMes->MakeMsg(0xBC4);
                                                            fileMes->SetMsgCursor(1);
                                                            if (chapter8_start == 1) {
                                                                fileMes->MakeMsg(0xC44);
                                                            }
                                                            phase = SAVE_LIST_PHASE_CONFIRM_SAVE;
                                                        } else {
                                                            save_kind = 1;
                                                            if (card->free_size <= check_kb) {
                                                                next = SAVE_MENU_PAGE_ERROR;
                                                            } else {
                                                                fileMes->SetMsgVolumeNoOne(need_kb);
                                                                fileMes->MakeMsg(0xBC3);
                                                                fileMes->SetMsgCursor(1);
                                                                phase = SAVE_LIST_PHASE_CONFIRM_SAVE;
                                                            }
                                                        }
                                                        MenuSePlay(SYSTEM_SE_DECIDE);
                                                    }
                                                } else if (info->state == 1) {
                                                    phase = SAVE_LIST_PHASE_CONFIRM_LOAD;
                                                    if (mode == SAVE_MENU_MODE_GYORACE_LOAD) {
                                                        if (info->fish_num <= 0) {
                                                            ExeScript(at_2503);
                                                            fileMes->SetMsgVolumeNoOne(fileNo);
                                                            phase = SAVE_LIST_PHASE_NOTICE;
                                                            break;
                                                        }
                                                        int values[2] = {0, 0};
                                                        values[0] = fileNo;
                                                        values[1] = info->fish_num;
                                                        fileMes->SetMsgCursor(1);
                                                        fileMes->SetMsgVolumeNo(values, MES_VALUE_MAX);
                                                        fileMes->MakeMsg(0x13A9);
                                                    } else {
                                                        fileMes->SetMsgCursor(1);
                                                        fileMes->SetMsgVolumeNoOne(fileNo);
                                                        fileMes->MakeMsg(0xBE0);
                                                    }
                                                    MenuSePlay(SYSTEM_SE_DECIDE);
                                                } else {
                                                    ExeScript(at_2501);
                                                }
                                            }
                                            break;
                                        case 2:
                                            next = SAVE_MENU_PAGE_SLOT_SELECT;
                                            MenuMesForm[2]->draw_flag = 0;
                                            MenuSePlay(5);
                                            break;
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_CONFIRM_SAVE:
                                cursorPos = fileMes->GetMsgCursor();
                                answer = fileMes->YesNoCursor();
                                if (answer != cursorPos) {
                                    input_wait_counter = 6;
                                }
                                input_wait_counter--;
                                if (input_wait_counter <= 0) {
                                    input_wait_counter = 0;
                                }
                                input_waiting = input_wait_counter > 0;
                                if (!input_waiting) {
                                    switch (pushed) {
                                        case 1:
                                            if (answer == 0) {
                                                EnvSetSave(save_kind);
                                                MenuSePlay(SYSTEM_SE_DECIDE);
                                                break;
                                            }
                                        case 2:
                                            next = SAVE_MENU_PAGE_FILE_LIST;
                                            MenuMesForm[2]->draw_flag = 0;
                                            cursor_form->draw_flag = 0;
                                            MenuSePlay(5);
                                            break;
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_NOTICE:
                                if (pushed != 0) {
                                    next = SAVE_MENU_PAGE_FILE_LIST;
                                    ExeScript(at_2501);
                                }
                                break;
                            case SAVE_LIST_PHASE_UNK_7:
                                break;
                            case SAVE_LIST_PHASE_SAVING:
                                transferred = MemoryCardPtr->total_transferred;
                                StepMenuDl2(dl_base + transferred);
                                if (stepResult != 0) {
                                    if (error->code != 0) {
                                        printf(at_2504__2, error->code);
                                        next = SAVE_MENU_PAGE_ERROR;
                                    } else {
                                        save_count++;
                                        phase = SAVE_LIST_PHASE_SAVE_DONE;
                                        InitMenuDl(NULL, 0);
                                        fileMes->push_button = 1;
                                        fileMes->MakeMsg(0xBC0);
                                        if (chapter8_start == 1) {
                                            fileMes->MakeMsg(0xC45);
                                        }
                                        fileMes->SetAbsPos(5);
                                        refresh = 1;
                                        SetDlInfoMsg(0, 0);
                                        MenuSePlay(0x1F);
                                        TreeMapSaveNum++;
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_SAVE_DONE:
                                if (McCheckMCPs2(card) == 0) {
                                    phase = SAVE_LIST_PHASE_SELECT;
                                    next = SAVE_MENU_PAGE_ERROR;
                                    MenuSePlay(SYSTEM_SE_DECIDE);
                                } else if (pushed != 0) {
                                    phase = SAVE_LIST_PHASE_SELECT;
                                    refresh = 1;
                                    ExeScript(at_2505__2);
                                }
                                break;
                            case SAVE_LIST_PHASE_MAKING_DIR:
                                transferred = MemoryCardPtr->total_transferred;
                                StepMenuDl2(transferred);
                                if (stepResult != 0) {
                                    card = GetSaveMenuCard(slot);
                                    if (McCheckMCPs2(card) == 0) {
                                        next = SAVE_MENU_PAGE_ERROR;
                                        error->code = 6;
                                    } else {
                                        dl_base = MemoryCardPtr->total_transferred;
                                        MemoryCardPtr->SetFuncNo(MC_FUNC_SAVE);
                                        phase = SAVE_LIST_PHASE_SAVING;
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_CONFIRM_LOAD:
                                cursorPos = fileMes->GetMsgCursor();
                                answer = fileMes->YesNoCursor();
                                if (McCheckMCPs2(card) == 0 || card->formatted == 0) {
                                    next = SAVE_MENU_PAGE_ERROR;
                                    MenuSePlay(5);
                                } else {
                                    if (answer != cursorPos) {
                                        input_wait_counter = 6;
                                    }
                                    input_wait_counter--;
                                    if (input_wait_counter <= 0) {
                                        input_wait_counter = 0;
                                    }
                                    input_waiting = input_wait_counter > 0;
                                    if (!input_waiting) {
                                        switch (pushed) {
                                            case 1:
                                                if (answer == 0) {
                                                    MemoryCardPtr->file_no = select;
                                                    MemoryCardPtr->SetFuncNo(MC_FUNC_LOAD);
                                                    phase = SAVE_LIST_PHASE_LOADING;
                                                    ExeScript(at_2506__2);
                                                    fileMes->SetMsgVolumeNoOne(slot + 1);
                                                    fileMes->push_button = 0;
                                                    InitMenuDl(dl_tex, MemoryCardPtr->GetSaveDataSize(MC_SIZE_SAVE_FILE));
                                                    SetDlInfoMsg(1, 1);
                                                    break;
                                                }
                                            case 2:
                                                next = SAVE_MENU_PAGE_FILE_LIST;
                                                MenuSePlay(5);
                                                break;
                                        }
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_LOADING:
                                transferred = MemoryCardPtr->total_transferred;
                                StepMenuDl2(transferred);
                                if (stepResult != 0) {
                                    card = GetSaveMenuCard(slot);
                                    if (error->code != 0) {
                                        next = SAVE_MENU_PAGE_ERROR;
                                    } else if (McCheckMCPs2(card) == 0) {
                                        next = SAVE_MENU_PAGE_ERROR;
                                    } else {
                                        phase = SAVE_LIST_PHASE_LOAD_DONE;
                                        InitMenuDl(NULL, 0);
                                        fileMes->push_button = 1;
                                        fileMes->MakeMsg(0xBE2);
                                        fileMes->SetAbsPos(5);
                                        SetDlInfoMsg(1, 0);
                                        MenuSePlay(0x1F);
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_LOAD_DONE:
                                if (pushed != 0) {
                                    phase = SAVE_LIST_PHASE_CONFIRM_LOAD;
                                    ExeScript(at_2507__2);
                                    CBaseMenuClass::mode = 2;
                                    manager = MemoryCardPtr;
                                    MenuArg.end_code = 0xA;
                                    MenuArg.result[0] = manager->load_program_loop_no;
                                    MenuArg.result[1] = manager->load_map_no;
                                    MenuArg.result[2] = manager->load_dungeon_no;
                                    MenuArg.result[3] = manager->load_floor_id;
                                    MenuArg.result[4] = manager->load_dng_tree_flag;
                                }
                                break;
                            case SAVE_LIST_PHASE_LOAD_NOTICE:
                                if (pushed != 0) {
                                    phase = SAVE_LIST_PHASE_CONFIRM_LOAD;
                                    MenuSePlay(SYSTEM_SE_DECIDE);
                                }
                                break;
                        }
                    }
                    break;
                case SAVE_MENU_PAGE_FORMAT:
                    card = GetSaveMenuCard(slot);
                    if (card != NULL && phase != SAVE_FORMAT_PHASE_DONE && McCheckMCPs2(card) == 0) {
                        phase = SAVE_FORMAT_PHASE_ASK;
                        next = SAVE_MENU_PAGE_ERROR;
                    } else {
                        switch (phase) {
                            case SAVE_FORMAT_PHASE_ASK:
                                answer = fileMes->YesNoCursor2(0);
                                if (answer == 1) {
                                    refresh = 1;
                                    MemoryCardPtr->InitPlayDataInfo();
                                    MemoryCardPtr->SetFuncNo(MC_FUNC_FORMAT);
                                    fileMes->MsgPreset(0x12, LanguageCode);
                                    fileMes->SetMsgVolumeNoOne(slot + 1);
                                    fileMes->MakeMsg(0xBE8);
                                    fileMes->SetAbsPos(5);
                                    MenuSePlay(SYSTEM_SE_DECIDE);
                                    phase = SAVE_FORMAT_PHASE_FORMATTING;
                                }
                                if (answer == 2) {
                                    next = SAVE_MENU_PAGE_FILE_LIST;
                                    MenuSePlay(5);
                                }
                                break;
                            case SAVE_FORMAT_PHASE_FORMATTING:
                                if (stepResult != 0) {
                                    fileMes->MsgPreset(0xA, LanguageCode);
                                    fileMes->SetAbsPos(5);
                                    if (card->formatted == 0 || McCheckMCPs2(card) == 0) {
                                        fileMes->MakeMsg(0xBE5);
                                        phase = SAVE_FORMAT_PHASE_DONE;
                                    } else if (FormatCase == 0) {
                                        fileMes->MakeMsg(0xBE9);
                                        phase = SAVE_FORMAT_PHASE_DONE;
                                    } else {
                                        page = SAVE_MENU_PAGE_FILE_LIST;
                                        phase = SAVE_FORMAT_PHASE_FORMATTING;
                                        EnvSetSave(1);
                                    }
                                }
                                break;
                            case SAVE_FORMAT_PHASE_DONE:
                                if (pushed != 0) {
                                    MenuSePlay(SYSTEM_SE_DECIDE);
                                    next = SAVE_MENU_PAGE_SLOT_SELECT;
                                }
                                break;
                        }
                    }
                    break;
                case SAVE_MENU_PAGE_UNK_5:
                    switch (phase) {
                        case SAVE_FORMAT_PHASE_ASK:
                            if (pushed & 1) {
                                MemoryCardPtr->port = 0;
                                MemoryCardPtr->SetFuncNo(MC_FUNC_UNFORMAT);
                                MenuMesForm[2]->draw_flag = 1;
                                fileMes->MakeMsg(0xBF5);
                                phase = SAVE_FORMAT_PHASE_FORMATTING;
                            }
                            break;
                        case SAVE_FORMAT_PHASE_FORMATTING:
                            if (stepResult != 0) {
                                phase = SAVE_FORMAT_PHASE_DONE;
                                fileMes->MakeMsg(0xBF6);
                            }
                            break;
                        case SAVE_FORMAT_PHASE_DONE:
                            if (pushed != 0) {
                                next = SAVE_MENU_PAGE_SLOT_SELECT;
                                MenuMesForm[2]->draw_flag = 0;
                                MenuSePlay(SYSTEM_SE_DECIDE);
                            }
                            break;
                    }
                    break;
                case SAVE_MENU_PAGE_ERROR:
                    card = GetSaveMenuCard(slot);
                    if (card == NULL) {
                        next = SAVE_MENU_PAGE_SLOT_SELECT;
                    } else if (McCheckMCPs2(card) == 0) {
                        if (pushed != 0) {
                            next = SAVE_MENU_PAGE_SLOT_SELECT;
                            MenuSePlay(5);
                        }
                    } else if (card->type == 2) {
                        if (card->formatted == 0) {
                            if (mode == SAVE_MENU_MODE_LOAD) {
                                if (pushed != 0) {
                                    next = SAVE_MENU_PAGE_SLOT_SELECT;
                                    MenuSePlay(5);
                                }
                            } else {
                                answer = 0;
                                if (fileMes->mes_no == 0xBEB) {
                                    answer = fileMes->YesNoCursor();
                                }
                                switch (pushed) {
                                    case 1:
                                        if (fileMes->mes_no == 0xBEB && answer == 0) {
                                            next = SAVE_MENU_PAGE_FORMAT;
                                            MenuSePlay(SYSTEM_SE_DECIDE);
                                            break;
                                        }
                                    case 2:
                                        next = SAVE_MENU_PAGE_SLOT_SELECT;
                                        MenuSePlay(5);
                                        break;
                                }
                            }
                        } else if (mode == SAVE_MENU_MODE_LOAD && MemoryCardPtr->CheckDataFileNum() <= 0) {
                            if (pushed != 0) {
                                next = SAVE_MENU_PAGE_SLOT_SELECT;
                                MenuSePlay(5);
                            }
                        } else if (card->free_size <= check_kb) {
                            if (pushed != 0) {
                                next = SAVE_MENU_PAGE_SLOT_SELECT;
                                MenuSePlay(5);
                            }
                        } else if (pushed != 0) {
                            next = SAVE_MENU_PAGE_SLOT_SELECT;
                            MenuSePlay(5);
                        }
                    }
                    break;
            }
            break;
    }
    if (next == SAVE_MENU_PAGE_ERROR) {
        InitMenuDl(NULL, 0);
        MenuMesForm[7]->draw_flag = 0;
        card = GetSaveMenuCard(slot);
        if (card_changed == 1) {
            phase = 0;
            next = SAVE_MENU_PAGE_CARD_INFO;
            card_changed = 0;
        } else {
            if (McCheckMCPs2(card) == 0) {
                MenuMesForm[2]->draw_flag = 1;
                fileMes->MsgPreset(0xA, LanguageCode);
                fileMes->SetAbsPos(5);
                fileMes->MakeMsg(0xBE7);
                if (error->code == MC_ERROR_FILE) {
                    fileMes->MakeMsg(0xBC1);
                }
            } else if (card->formatted == 0) {
                fileMes->MsgPreset(0xA, LanguageCode);
                fileMes->SetAbsPos(5);
                fileMes->MakeMsg(0xBED);
                fileMes->SetMsgVolumeNoOne(slot + 1);
            } else if (mode == SAVE_MENU_MODE_LOAD && MemoryCardPtr->CheckDataFileNum() <= 0) {
                fileMes->MsgPreset(0xA, LanguageCode);
                fileMes->SetAbsPos(5);
                fileMes->MakeMsg(0xBE3);
                fileMes->SetMsgVolumeNoOne(slot + 1);
            } else if (card->free_size <= check_kb) {
                ExeScript(at_2508__2);
                int values[2] = {0, 0};
                values[0] = slot + 1;
                values[1] = need_kb;
                fileMes->SetMsgVolumeNo(values, 2);
            }
            if (error->code == MC_ERROR_LOAD) {
                MenuMesForm[7]->draw_flag = 0;
                MenuMesForm[2]->draw_flag = 1;
                fileMes->MsgPreset(0xA, LanguageCode);
                fileMes->SetAbsPos(5);
                fileMes->MakeMsg(0xBC6);
            }
        }
    }
    if (0 <= next || first_step != 0) {
        switch (next) {
            case SAVE_MENU_PAGE_SLOT_SELECT:
                phase = 0;
                ExeScript(at_2509__2);
                SetMenuReturnMsgCtrl(1);
                break;
            case SAVE_MENU_PAGE_CARD_INFO:
                MemoryCardPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                phase = 0;
                ExeScript(at_2510__2);
                fileMes->push_button = 0;
                slot_form[slot]->SetAction(at_2511);
                slot_form[!(bool) slot]->SetRGBACalcParam(3, -8, 0);
                if (slot == 0) {
                    MenuMesForm[5]->SetRGBACalcParam(3, -8, 0);
                }
                if (slot == 1) {
                    MenuMesForm[4]->SetRGBACalcParam(3, -8, 0);
                }
                SetMenuReturnMsgCtrl(0);
                break;
            case SAVE_MENU_PAGE_FILE_READ:
                phase = 0;
                break;
            case SAVE_MENU_PAGE_FILE_LIST:
                if (mode == SAVE_MENU_MODE_SAVE) {
                    phase = 0;
                    fileMes->MakeMsg(0xBBE);
                    titleMes->MakeMsg(0xC1D);
                }
                if (mode == SAVE_MENU_MODE_LOAD || mode == SAVE_MENU_MODE_GYORACE_LOAD) {
                    phase = 0;
                    fileMes->MsgPreset(0xB, LanguageCode);
                    titleMes->MakeMsg(0xC1E);
                }
                refresh = 1;
                list_jump = 1;
                MenuMesForm[2]->draw_flag = 0;
                cursor_form->draw_flag = 1;
                list_form->draw_flag = 1;
                scrlbar_form->draw_flag = 1;
                break;
            case SAVE_MENU_PAGE_FORMAT:
                phase = 0;
                ExeScript(at_2512__2);
                if (fileMes != NULL) {
                    fileMes->SetMsgVolumeNoOne(slot + 1);
                }
                break;
            case SAVE_MENU_PAGE_UNK_5:
                phase = 0;
                break;
            case SAVE_MENU_PAGE_ERROR:
                break;
        }
        first_step = 0;
        page = next;
    }
    if (refresh != 0) {
        card = GetSaveMenuCard(MemoryCardPtr->port);
        emptyMes = 0xC27;
        if (card != NULL && card->formatted != 0 && card->free_size <= check_kb) {
            emptyMes = 0xC28;
        }
        for (row = 0; row < 13; row++) {
            rowMes = SaveFileList[row];
            rowMes->ClsMes::mes_no = -1;
            rowInfo[row] = &MemoryCardPtr->file_info[row];
            info = rowInfo[row];
            if (info->state != 0) {
                mapNo = info->map_no;
                if (info->program_loop_no == 2) {
                    mapNo = conv_2316[info->dungeon_no];
                }
                if (mapNo == 0x29) {
                    mapNo = 0xB;
                }
                char *title[1] = {NULL};
                title[0] = GetMapTitle(mapNo);
                chapter = 0;
                if (info->progress >= 2) {
                    chapter = 1;
                }
                if (info->progress >= 4) {
                    chapter = info->progress - 2;
                }
                if (info->progress == 100) {
                    chapter = 0xB;
                }
                int itemNo[1] = {0};
                itemNo[0] = chapter + 0xC7F;
                rowMes->SetMsgItemNo(title, 1);
                rowMes->SetMsgItemNo(itemNo, 1);
                int slotNumber[1] = {0};
                slotNumber[0] = row + 1;
                int slotWidth[1] = {0};
                rowMes->SetMsgVolumeNo(slotNumber, slotWidth, 1);
                rowMes->MakeMsg(0xC26);
            } else {
                int slotNumber[1] = {0};
                slotNumber[0] = row + 1;
                int slotWidth[1] = {0};
                rowMes->SetMsgVolumeNo(slotNumber, slotWidth, 1);
                rowMes->MakeMsg(emptyMes);
            }
            rowMes->StepMsg();
        }
    }
    if (list_form != NULL) {
        float listPos[2] = {76.0f, 164.0f};
        CalcMenu1(listPos[1] - 80.0f * (float) top, &list_form->y, 4.0f, 4.0f, list_jump);
    }
    MenuPosData->FormStep();
    CDC2Mes *slot1Mes = MenuDCMsg[4];
    CDC2Mes *slot2Mes = MenuDCMsg[5];
    CDC2Mes *helpMes = MenuDCMsg[6];
    if (title_form != NULL) {
        titleMes->StepMsg();
        title_form->GetPutPosXY(at_2513, formPos[0], formPos[1]);
        titleMes->SetMovePosCenteringGyou(0, formPos[0], formPos[1]);
        title_form->GetPutPosXY(at_2514, formPos[0], formPos[1]);
        helpMes->SetMovePosCenteringGyou(0, formPos[0], formPos[1]);
    }
    if (slot_form[0] != NULL) {
        slot_form[0]->GetPutPosXY(at_2515, formPos[0], formPos[1]);
        slot1Mes->SetMovePosCenteringGyou(0, formPos[0], formPos[1]);
    }
    if (slot_form[1] != NULL) {
        slot_form[1]->GetPutPosXY(at_2515, formPos[0], formPos[1]);
        slot2Mes->SetMovePosCenteringGyou(0, formPos[0], formPos[1]);
    }
    int scrollRange[2] = {6, 250};
    LocalFunc_AdjustScrlBar(scrlbar_parts, scrlbar_pos, scrollRange, top, 13.0f, 3.0f, list_jump);
    if (list_jump != 0) {
        list_jump = 0;
    }
    return finished;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", KeyStep__14CSaveMenuClassFv);
#endif
void SaveFileListDraw(int &tex_block, float *pos, int alpha) {
    ScreenPos      linePos[13];
    SAVEDATA_INFO *info[13];
    mgRect<int>    nameRect;
    mgRect<int>    markRect;
    mgCDrawPrim   *prim;
    int            shadowAlpha;
    int            centerX;
    int            offset;
    int            i;
    int            row;
    CDC2Mes       *window;
    float          rowY;
    float          top;
    u_long         minutesTotal;
    u_long         minutes;

    if (alpha > 0 && Tex_SaveFile != NULL) {
        linePos[0].x = pos[0];
        linePos[0].y = pos[1];
        nameRect.Set(0, 0x42, 0x17E, 0x4A);
        markRect.Set(0, 0x8C, 0xEA, 6);
        if (LanguageCode > 0) {
            nameRect.right = 0x1CA;
            markRect.right = 0x14A;
        }
        shadowAlpha = alpha / 3;
        MenuReloadTexture(tex_block, SaveMenuPtr->tex_block[1]);
        prim = GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Tex_SaveFile);
        prim->Color(0x80, 0x80, 0x80, alpha);
        for (i = 0; i < 13; i++) {
            info[i] = &MemoryCardPtr->file_info[i];
            ScreenPos *line = &linePos[i];
            line->x = pos[0];
            line->y = pos[1] + 80.0f * (float) i;
            prim->Color(0, 0, 0, shadowAlpha);
            PrimQuad(prim, 3.0f + line->x, 3.0f + line->y, nameRect);
            prim->Color(0x80, 0x80, 0x80, alpha);
            PrimQuad(prim, line->x, line->y, nameRect);
            if (info[i]->state != 0) {
                float mark_x = 120.0f + line->x;
                float mark_y = 34.0f + line->y;
                PrimQuad(prim, mark_x, mark_y, markRect);
            }
        }
        prim->End();
        offset = 0xE0;
        if (LanguageCode > 0) {
            offset = 0x11A;
        }
        centerX = fptosi(pos[0] + (float) offset);
        CMenuFont font;
        char      timeText[0x80];
        char      hoursText[0x40];
        char      digitText[0x40];
        font.SetClearance(0xE, 0x14);
        MenuReloadTexture(tex_block, MenuArg.mes_tex_block);
        for (row = 0; row < 13; row++) {
            window = SaveFileList[row];
            ScreenPos *line = &linePos[row];
            int        textY = (int) (18.0f + line->y);
            window->line_pos[0][0] = (int) (18.0f + line->x);
            window->line_pos[0][1] = textY;
            window->line_pos_on[0] = 1;
            rowY = line->y;
            top = 18.0f + rowY;
            if (!(top < 100.0f) && !((float) mgScreenHeight < top)) {
                if (info[row]->state != 0) {
                    u_long seconds;
                    u_long hours;
                    int    tens;
                    u_long hundreds;
                    textY = fptosi(40.0f + rowY);
                    window->line_pos[1][0] = fptosi(520.0f + line->x);
                    window->line_pos[1][1] = textY;
                    window->line_pos_on[1] = 1;
                    seconds = info[row]->play_time / 50;
                    minutesTotal = seconds / 60;
                    hours = minutesTotal / 60;
                    minutes = minutesTotal % 60;
                    tens = (hours % 100 - hours % 10) / 10;
                    if (seconds >= 0x36E070) {
                        hours = 999;
                        tens = 9;
                        minutes = 59;
                    }
                    static char *space = at_2603;
                    hundreds = hours / 100;
                    if (CheckNowEurope() != 0) {
                        if (hundreds == 0) {
                            strcpy(hoursText, space);
                        } else {
                            sprintf(hoursText, at_1905__3, hundreds);
                        }
                        if (tens == 0 && hundreds == 0) {
                            strcat(hoursText, space);
                        } else {
                            sprintf(digitText, at_1905__3, tens % 10);
                            strcat(hoursText, digitText);
                        }
                        sprintf(timeText, at_2604, hoursText, hours % 10, minutes / 10,
                                minutes % 10);
                    } else {
                        if (hundreds == 0) {
                            strcpy(timeText, space);
                        } else {
                            strcpy(timeText, GetMenuBigNum((int) hundreds));
                        }
                        if (tens == 0 && hundreds == 0) {
                            strcat(timeText, space);
                        } else {
                            strcat(timeText, GetMenuBigNum(tens));
                        }
                        strcat(timeText, GetMenuBigNum((int) (hours % 10)));
                        strcat(timeText, at_2605);
                        strcat(timeText, GetMenuBigNum((int) (minutes / 10)));
                        strcat(timeText, GetMenuBigNum((int) minutes));
                    }
                    font.DrawDirect(timeText, fptosi(22.0f + line->x),
                                    fptosi(42.0f + line->y));
                    window->SetMovePosCenteringGyou(2, centerX, fptosi(1.0f + (10.0f + line->y)));
                    window->SetMovePosCenteringGyou(3, centerX + 0xD, fptosi(42.0f + line->y));
                } else {
                    window->SetMovePosCenteringGyou(1, centerX - 4, fptosi(24.0f + rowY));
                }
                window->SetMsgAlpha(alpha);
                window->StepMsg();
                window->DrawMsg();
            }
        }
    }
}

void SetMCIconData(u_int *pack, int slot) {
    SaveIconSet icons = at_2609__2;

    for (int i = 0; i < 3; i++) {
        MC_ICON_DATA *icon = &icons.file[i];
        icon->data = GetPackFile(pack, icon->name, &icon->size);
    }

    MemoryCardPtr->SetIconData(icons.file, slot);
}

int GetDngMapNo(int dungeon) {
    if (dungeon < 0) {
        return 0;
    }

    if (dungeon > 6) {
        return 0;
    }

    return SearchMapNo(dngmap_2627[dungeon]);
}

void SaveMapInfo(int dungeon) {
    memcpy(MenuMapInfoSave, &GetSaveData()->map_no, sizeof(MenuMapInfoSave));
    int saved_dungeon = *(int *) ((u8 *) GetSaveData() + offsetof(CSaveData, save_dungeon) + offsetof(CSaveDataDungeon, stage_id));
    MenuMapInfoSave_DngNo = saved_dungeon;

    if (0 <= dungeon) {
        short     *map_info = &GetSaveData()->map_no;
        CSaveData *save_data = GetSaveData();
        short      previous = *map_info;
        save_data->prev_map_no = previous;
        map_info = &GetSaveData()->map_no;
        *map_info = GetDngMapNo(dungeon);
        saved_dungeon = *(int *) ((u8 *) GetSaveData() + offsetof(CSaveData, save_dungeon) + offsetof(CSaveDataDungeon, stage_id));
        MenuMapInfoSave_DngNo = saved_dungeon;
        *(int *) ((u8 *) GetSaveData() + offsetof(CSaveData, save_dungeon) + offsetof(CSaveDataDungeon, stage_id)) = dungeon;
    }
}

void ResetMapInfo() {
    memcpy(&GetSaveData()->map_no, MenuMapInfoSave, sizeof(MenuMapInfoSave));
    short dungeon_no = MenuMapInfoSave_DngNo;
    *(int *) ((u8 *) GetSaveData() + offsetof(CSaveData, save_dungeon) + offsetof(CSaveDataDungeon, stage_id)) = dungeon_no;
}

void MenuSaveInit(mgCMemory *memory, int *tex_block, int mode) {
    CSaveMenuClass     *menu;
    CMemoryCardManager *card;
    u8                 *pack;
    unsigned int        script_size;
    unsigned int        blocks;
    short              *main_messages;
    CDC2Mes            *window;
    int                 mes_layout;
    int                 i;
    int                 part;
    int                 data_size;
    int                 free_size;

    free_size = memory->stGetRest();
    SaveMenuStack.stSetBuffer(memory->stGetTop(), free_size);

    menu = new (SaveMenuStack.Alloc(0x1D)) CSaveMenuClass;

    SaveMenuPtr = menu;

    card = new (SaveMenuStack.Alloc(0x112)) CMemoryCardManager;

    MemoryCardPtr = card;
    InitMenuReturnMsg(&SaveMenuStack);
    SetMenuReturnMsgCtrl(1);
    MemoryCardPtr->Initialize(&SaveMenuStack);
    MemoryCardPtr->SetBuff_Album(NULL);

    if (MemoryCardPtr->InitForMC() == 0) {
        SaveMenuStack.stAlloc64(0x800);
        SaveMenuPtr->SetTexBlock(tex_block);

        if (mode == 7) {
            SaveMenuPtr->mode = 0;
        }

        if (mode == 8) {
            SaveMenuPtr->mode = 1;
        }

        if (mode == 0x1E) {
            SaveMenuPtr->mode = 2;
        }

        SaveMenuStack.Align64();
        pack = (u8 *) (SaveMenuStack.stack + SaveMenuStack.stack_used);
        script_size = LoadFileMenu(at_2764, (u_long128 *) pack, 1);
        blocks = (script_size & 0xF) != 0 ? (script_size >> 4) + 1 : script_size >> 4;
        SaveMenuStack.Alloc(blocks);
        mgTexManager.EnterIMGFile((u_char *) GetPackFile((unsigned int *) pack, at_2765, NULL), SaveMenuPtr->tex_block[1],
                                  NULL, NULL);
        mgTexManager.EnterIMGFile((u_char *) GetPackFile((unsigned int *) pack, at_2766, NULL), SaveMenuPtr->tex_block[1],
                                  NULL, NULL);
        Tex_SaveFile = mgTexManager.GetTexture(at_2767, -1);
        SaveMenuPtr->dl_tex = GetMenuDlTexture();
        InitMenuDl(NULL, 0);
        main_messages = GetMenuMainMessageBuffer();
        window = MenuDCMsg[2];
        window->SetMessData(GetSystemMesBuffer(), main_messages);
        window = MenuDCMsg[3];
        window->SetMessData(main_messages, main_messages);
        window->MsgPreset(0x10, LanguageCode);
        window->MakeMsg(0xC1C);
        window = MenuDCMsg[4];
        window->SetMessData(main_messages, main_messages);
        window->MsgPreset(0x10, LanguageCode);
        window->MakeMsg(0xC1F);
        window = MenuDCMsg[5];
        window->SetMessData(main_messages, main_messages);
        window->MsgPreset(0x10, LanguageCode);
        window->MakeMsg(0xC20);
        window = MenuDCMsg[6];
        window->SetMessData(main_messages, main_messages);
        window->MsgPreset(0x10, LanguageCode);

        if (SaveMenuPtr->mode == 0) {
            window->MakeMsg(0xC3B);
        } else {
            window->MakeMsg(0xC3A);
        }

        MenuDCMsg[7]->SetMessData(main_messages, main_messages);
        MenuDCMsg[7]->MsgPreset(0x10);
        mes_layout = -4;

        if (CheckNowEurope() != 0) {
            mes_layout = 0;
        }

        for (i = 0; i < 13; i++) {
            window = new (SaveMenuStack.Alloc(0x2A7)) CDC2Mes;

            SaveFileList[i] = window;
            SaveFileList[i]->SetMessData(main_messages, main_messages);
            SaveFileList[i]->MsgPreset(0x10);
            SaveFileList[i]->value_zero = 1;
            SaveFileList[i]->value_space = mes_layout;
        }

        SetMCIconData((unsigned int *) pack, 2);
        char *data = (char *) GetPackFile((unsigned int *) pack, at_2768, &data_size);
        MenuDataAnalyze(data, data_size, &SaveMenuStack);
        SaveMenuPtr->script = (char *) GetPackFile((unsigned int *) pack, at_2769, &SaveMenuPtr->script_size);
        (MenuPosData)->AttachCommonTexInfo();
        MenuPosData->ResetTextureBlockNo(at_2767, SaveMenuPtr->tex_block[1]);
        MenuPosData->ResetTextureInfoAll();
        SaveMenuPtr->title_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2770__2);
        SaveMenuPtr->slot_form[0] = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2771__2);
        SaveMenuPtr->slot_form[1] = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2772__2);
        SaveMenuPtr->cursor_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2773__2);
        SaveMenuPtr->list_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2774__2);
        SaveMenuPtr->scrlbar_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2775__2);
        part = 0;

        if (SaveMenuPtr->scrlbar_form != NULL) {
            for (; part < 3; part++) {
                SaveMenuPtr->scrlbar_parts[part] =
                    SaveMenuPtr->scrlbar_form->GetPartInfo(b_2715[part]);
            }
        }

        AttachMessageForm();
        SaveMenuStack.Align64();

        if (SaveMenuPtr->mode == 0) {
            StopEnvSoundMenu(1);
            MenuMainScene->GetActiveBgmStatus(&SaveMenuPtr->bgm_status);
            MenuMainScene->StopBGM(0);
            MenuMainScene->LoadBGM(0x30, (SaveMenuStack.stack + SaveMenuStack.stack_used));
            MenuMainScene->PlayBGM(0, -1, 1.0f);
        }

        SaveMenuPtr->FadeInMenu(0x3C, 0.0f);
    }
}

int MenuSaveKey() {
    return SaveMenuPtr->KeyStep();
}

void MenuSaveDraw() {
    char text[0x200];
    MenuPosData->FormDraw();
    DrawMenuReturnMsg();

    if (DebugFlag != 0 && menu_debug_flag != 0) {
        CMenuFont menu_font;
        int       mode = SaveMenuPtr->mode;

        if (mode == 1 || mode == 2) {
            menu_font.SetStr(at_2821__2);
            menu_font.SetPos(0x14, 0x28);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        } else {
            menu_font.SetStr(at_2822);
            menu_font.SetPos(0x14, 0x28);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        }

        sprintf(text, at_2823, MemoryCardPtr->GetSaveDataSize(MC_SIZE_SAVE_TOTAL) / 1024);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x3C);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        sprintf(text, at_2824, 0x196);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x50);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        sprintf(text, at_2825, MemoryCardPtr->GetSaveDataSize(MC_SIZE_SAVE_KB));
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x64);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        sprintf(text, at_2826__2, MemoryCardPtr->GetIconDataSize() / 1024);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x78);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        MC_CARD_INFO *card;
        int           port = MemoryCardPtr->port;

        if (port == 0 || port == 1) {
            card = &MemoryCardPtr->card[port];
        } else {
            card = NULL;
        }

        sprintf(text, at_2827, card->type, card->formatted, card->free_size);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x8C);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
    }
}

void SubGameCFGAnalyze(char *command) {
    MenuCommandAnalyze(SubGameSaveCFGBuffer, SubGameSaveCFGBufferSize, command);
}

void SubGameSaveInit(mgCMemory *memory, int *tex_block, int mode) {
    CMemoryCardManager *card;
    CSubGameData       *sub_game;
    u8                 *pack;
    unsigned int        script_size;
    unsigned int        blocks;
    short              *main_messages;
    int                 free_size;

    free_size = memory->stGetRest();
    SaveMenuStack.stSetBuffer(memory->stGetTop(), free_size);

    if (mode == 0x1B) {
        SubGameSaveOrLoad = 1;
    }

    if (mode == 0x1A) {
        SubGameSaveOrLoad = 0;

        if (GetNowLoopNo() == (int) LOOP_DUNGEON) {
            GetSubGameSaveData()->GetSphidaData()->EnterScore();
        }
    }

    card = new (SaveMenuStack.Alloc(0x112)) CMemoryCardManager;

    MemoryCardPtr = card;
    MemoryCardPtr->Initialize(NULL);
    MemoryCardPtr->SetBuff_Album(NULL);
    MemoryCardPtr->InitForMC();
    MemoryCardPtr->port = 0;
    MemoryCardPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);

    sub_game = new (SaveMenuStack.Alloc(0x549)) CSubGameData;

    MemoryCardPtr->sub_game_data = sub_game;
    SaveMenuStack.Align64();
    SubGameMCPort = 0;
    SubGameSaveBlock[0] = tex_block[0];
    SubGameSaveBlock[1] = tex_block[1];
    SubGameSaveBlock[2] = tex_block[2];
    pack = (u8 *) (SaveMenuStack.stack + SaveMenuStack.stack_used);
    script_size = LoadFileMenu(at_2895, (u_long128 *) pack, 1);
    blocks = (script_size & 0xF) != 0 ? (script_size >> 4) + 1 : script_size >> 4;
    SaveMenuStack.Alloc(blocks);
    u_char            *textures = (u_char *) GetPackFile((unsigned int *) pack, at_2765, NULL);
    mgCTextureManager *texture_manager = &mgTexManager;

    if (textures != NULL) {
        texture_manager->EnterIMGFile(textures, SubGameSaveBlock[0], NULL, NULL);
    }

    SubGameSaveCFGBuffer = (char *) GetPackFile((unsigned int *) pack, at_2769, &SubGameSaveCFGBufferSize);
    Tex_SaveFile = texture_manager->GetTexture(at_2767, -1);
    MenuCommonInfo->key_enable = 1;
    SubGameSaveOrLoadPhase = 0;
    SubGameSaveLoadStatus = 0;
    SetMCIconData((unsigned int *) pack, 2);
    main_messages = GetMenuMainMessageBuffer();
    MenuDCMsg[0]->SetMessData(main_messages, main_messages);
    MenuDCMsg[0]->MsgPreset(0x12, LanguageCode);
    MenuDCMsg[0]->SetAbsPos(5);
    MenuDCMsg[0]->select_top = 2;
    MenuDCMsg[0]->SetMsgCursor(2);
    MenuDCMsg[0]->MakeMsg(SubGameSaveOrLoad + 0xC4E);

    if (GetNowLoopNo() == (int) LOOP_DUNGEON) {
        MenuMainScene->fade.FadeIn(0x28);
    }

    SubGameOmakeTempBuffer = (char *) SaveMenuStack.Alloc(0x1900);
    SubSaveTileXY = 0;
    SubTrueTotalSaveFileSize = MemoryCardPtr->GetSaveDataSize(MC_SIZE_OMAKE_KB);
    SubCheckTotalSaveFileSize = SubTrueTotalSaveFileSize + 3;
    SaveMenuStack.Align64();

    if (SubGameSaveOrLoad == 1) {
        MenuMainScene->GetActiveBgmStatus(&SubGameDataBgm);
        MenuMainScene->StopBGM(0);
        MenuMainScene->LoadBGM(0x30, (SaveMenuStack.stack + SaveMenuStack.stack_used));
        MenuMainScene->PlayBGM(0, -1, 1.0f);
    }

    if (SubGameSaveOrLoad == 0) {
        sub_game = GetSubGameSaveData();

        if (sub_game != NULL) {
            if (GetNowLoopNo() == (int) LOOP_DUNGEON) {
                sub_game->PlayEnable(1, 1);
            }

            if (GetNowLoopNo() == (int) LOOP_EDIT) {
                sub_game->PlayEnable(2, 1);
            }
        }
    }

    MenuMainScene->fade.Initialize();
}

/**
 *
 * Returns the memory card state for the selected subgame save port.
 *
 */
static inline MC_CARD_INFO *GetSubGameCard(CMemoryCardManager *manager) {
    int port = SubGameMCPort;

    if (port == 0 || port == 1) {
        return &manager->card[port];
    } else {
        return NULL;
    }
}

template <typename T>
static inline T Ident(T v) { return v; }

static inline int &SubGameFileExists(CMemoryCardManager *manager) {
    return manager->file_exists;
}

int SubGameSaveKey(void) {
    MC_CARD_INFO *card;
    u32           stepResult;
    int           pushed;
    CDC2Mes      *window;
    int           next;
    int           cursor;
    int           pressed;
    int           answer;
    int           slot;
    int           slotNo;

    if (SubGameSaveLoadStatus == 1 && MenuMainScene->fade.FadeCheck() != 0) {
        MemoryCardPtr->FinishForMC();
        if (SubGameSaveOrLoad == 1) {
            MenuMainScene->StopBGM(0);
            MenuMainScene->LoadBGM(SubGameDataBgm.load_no, SaveMenuStack.stack + SaveMenuStack.stack_used);
            MenuMainScene->SetActiveBgmStatus(&SubGameDataBgm);
        }
        return 1;
    }
    pushed = MenuCommonInfo->CheckPushButton();
    MC_ERROR_INFO *error;
    stepResult = MemoryCardPtr->Step();
    error = &MemoryCardPtr->error;
    window = MenuDCMsg[0];
    next = -1;
    switch (SubGameSaveOrLoadPhase) {
        case -1:
            break;
        case SUB_SAVE_SLOT_SELECT:
            pressed = ConvertCheckPushButton(pushed);
            if (pressed & 2) {
                MenuSePlay(5);
                if (GetNowLoopNo() == (int) LOOP_TITLE) {
                    next = SUB_SAVE_QUIT_ASK;
                }
                if (GetNowLoopNo() == (int) LOOP_EDIT || GetNowLoopNo() == (int) LOOP_DUNGEON) {
                    next = SUB_SAVE_QUIT_ASK_LOAD;
                }
            } else {
                cursor = window->AddMsgCursor2(2, 3, 0);
                if (pressed & 1) {
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    next = SUB_SAVE_CARD_CHECK;
                    SubGameMCPort = cursor - 2;
                }
            }
            break;
        case SUB_SAVE_CARD_CHECK:
            card = GetSubGameCard(MemoryCardPtr);
            if (stepResult != 0) {
                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_CARD_ERROR;
                } else {
                    next = SUB_SAVE_CARD_READY;
                }
            }
            break;
        case SUB_SAVE_CARD_READY:
            card = GetSubGameCard(MemoryCardPtr);
            if (stepResult != 0) {
                int &exists = SubGameFileExists(MemoryCardPtr);
                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_CARD_ERROR;
                } else if (card->formatted == 0) {
                    if (SubGameSaveOrLoad == 0) {
                        next = SUB_SAVE_FORMAT_ASK;
                    }
                    if (SubGameSaveOrLoad == 1) {
                        next = SUB_SAVE_NO_DATA;
                    }
                } else if (exists == 1) {
                    if (SubGameSaveOrLoad == 0) {
                        next = SUB_SAVE_OVERWRITE_ASK;
                    }
                    if (SubGameSaveOrLoad == 1) {
                        next = SUB_SAVE_LOAD_ASK;
                    }
                } else if (exists == 2) {
                    next = SUB_SAVE_WRITE_FAILED_FULL;
                } else {
                    if (SubGameSaveOrLoad == 0) {
                        next = SUB_SAVE_SPACE_ASK;
                    }
                    if (SubGameSaveOrLoad == 1) {
                        next = SUB_SAVE_LOAD_MISSING;
                    }
                }
            }
            break;
        case SUB_SAVE_QUIT_ASK:
        case SUB_SAVE_QUIT_ASK_LOAD:
            answer = window->YesNoCursor2(0);
            if (answer == 1) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                MenuArg.end_code = 0;
                SubGameSaveLoadStatus = 1;
                MenuArg.result[0] = 0;
                SubGameSaveOrLoadPhase = -1;
            }
            if (answer == 2) {
                MenuSePlay(5);
                next = SUB_SAVE_SLOT_SELECT;
            }
            break;
        case 50:
            break;
        case SUB_SAVE_OVERWRITE_ASK:
            card = GetSubGameCard(MemoryCardPtr);
            if (McCheckMCPs2(card) == 0) {
                next = SUB_SAVE_CARD_ERROR;
            } else {
                answer = window->YesNoCursor2(0);
                if (answer == 1) {
                    next = SUB_SAVE_WRITING;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
                if (answer == 2) {
                    next = SUB_SAVE_SLOT_SELECT;
                    MenuSePlay(5);
                }
            }
            break;
        case SUB_SAVE_WRITING:
            if (stepResult != 0) {
                card = GetSubGameCard(MemoryCardPtr);
                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_WRITE_FAILED;
                } else {
                    MenuSePlay(0x1F);
                    next = SUB_SAVE_WRITE_DONE;
                }
            }
            break;
        case SUB_SAVE_WRITE_DONE:
            if (pushed != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                SubGameSaveLoadStatus = 1;
            }
            break;
        case SUB_SAVE_WRITE_FAILED:
        case SUB_SAVE_WRITE_FAILED_FULL:
            if (pushed != 0) {
                next = SUB_SAVE_SLOT_SELECT;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            break;
        case SUB_SAVE_SPACE_ASK:
            card = GetSubGameCard(MemoryCardPtr);
            if (McCheckMCPs2(card) == 0) {
                next = SUB_SAVE_CARD_ERROR;
            } else {
                answer = window->YesNoCursor2(0);
                if (answer == 1) {
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    if (card->formatted == 0) {
                        next = SUB_SAVE_FORMAT_ASK;
                        break;
                    } else if (card->free_size < SubCheckTotalSaveFileSize) {
                        next = SUB_SAVE_CARD_ERROR;
                        break;
                    } else {
                        next = SUB_SAVE_DIR_MAKING;
                    }
                }
                if (answer == 2) {
                    next = SUB_SAVE_SLOT_SELECT;
                    MenuSePlay(5);
                }
            }
            break;
        case SUB_SAVE_DIR_MAKING:
            card = GetSubGameCard(MemoryCardPtr);
            if (stepResult != 0) {
                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_WRITE_FAILED;
                } else if (error->code == MC_ERROR_FILE) {
                    next = SUB_SAVE_WRITE_FAILED_FULL;
                } else {
                    next = SUB_SAVE_WRITING;
                }
            }
            break;
        case SUB_SAVE_FORMAT_ASK:
            card = GetSubGameCard(MemoryCardPtr);
            if (McCheckMCPs2(card) == 0) {
                next = SUB_SAVE_CARD_ERROR;
            } else {
                answer = window->YesNoCursor2(0);
                if (answer == 1) {
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    next = SUB_SAVE_FORMATTING;
                }
                if (answer == 2) {
                    MenuSePlay(5);
                    next = SUB_SAVE_SLOT_SELECT;
                }
            }
            break;
        case SUB_SAVE_FORMATTING:
            card = GetSubGameCard(MemoryCardPtr);
            if (stepResult != 0) {
                if (McCheckMCPs2(card) == 0) {
                    goto format_error;
                }
                next = SUB_SAVE_DIR_MAKING;
                if (card != NULL && card->formatted == 0) {
                format_error:
                    next = SUB_SAVE_CARD_ERROR;
                } else {
                    next = SUB_SAVE_DIR_MAKING;
                }
            }
            break;
        case SUB_SAVE_NO_DATA:
            if (pushed != 0) {
                next = SUB_SAVE_SLOT_SELECT;
                MenuSePlay(5);
                if (SubGameSaveOrLoad == 0) {
                    next = SUB_SAVE_FORMAT_ASK;
                }
                if (SubGameSaveOrLoad == 1) {
                    next = SUB_SAVE_LOAD_MISSING;
                }
            }
            break;
        case SUB_SAVE_LOAD_ASK:
            card = GetSubGameCard(MemoryCardPtr);
            if (McCheckMCPs2(card) == 0) {
                next = SUB_SAVE_CARD_ERROR;
            } else {
                answer = window->YesNoCursor2(0);
                if (answer == 1) {
                    next = SUB_SAVE_LOADING;
                    MemoryCardPtr->SetFuncNo(MC_FUNC_LOAD_OMAKE);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
                if (answer == 2) {
                    next = SUB_SAVE_SLOT_SELECT;
                    MenuSePlay(5);
                }
            }
            break;
        case SUB_SAVE_LOADING:
            card = GetSubGameCard(MemoryCardPtr);
            if (stepResult != 0) {
                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_CARD_ERROR;
                } else {
                    MenuSePlay(0x1F);
                    next = SUB_SAVE_LOAD_DONE;
                }
            }
            break;
        case SUB_SAVE_LOAD_DONE:
            if (pushed != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                MenuArg.end_code = 0x13;
                SubGameSaveLoadStatus = 1;
            }
            break;
        case SUB_SAVE_LOAD_MISSING:
            answer = window->YesNoCursor2(0);
            if (answer == 1) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                SubGameSaveLoadStatus = 1;
                MenuArg.end_code = 0x13;
            }
            if (answer == 2) {
                MenuSePlay(5);
                next = SUB_SAVE_SLOT_SELECT;
            }
            break;
        case SUB_SAVE_CARD_ERROR:
            if (pushed != 0) {
                card = GetSubGameCard(MemoryCardPtr);
                if (McCheckMCPs2(card) == 0) {
                    MenuSePlay(5);
                    next = SUB_SAVE_SLOT_SELECT;
                } else if (card->formatted == 0) {
                    MenuSePlay(5);
                    if (SubGameSaveOrLoad == 1) {
                        next = SUB_SAVE_LOAD_MISSING;
                    }
                    if (SubGameSaveOrLoad == 0) {
                        next = SUB_SAVE_FORMAT_ASK;
                    }
                } else {
                    MenuSePlay(5);
                    next = SUB_SAVE_SLOT_SELECT;
                }
            }
            break;
        case 1001:
            break;
    }
    if (0 <= next) {
        slot = SubGameMCPort;
        slotNo = slot + 1;
        switch (next) {
            case SUB_SAVE_SLOT_SELECT:
                window->MsgPreset(0x12, LanguageCode);
                window->SetAbsPos(5);
                window->select_top = 2;
                window->SetMsgCursor(2);
                window->MakeMsg(SubGameSaveOrLoad + 0xC4E);
                break;
            case SUB_SAVE_CARD_CHECK:
                MemoryCardPtr->port = slot;
                MemoryCardPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                SubGameCFGAnalyze(at_3198__2);
                window->select_top = 2;
                break;
            case SUB_SAVE_CARD_READY:
                MemoryCardPtr->SetFuncNo(MC_FUNC_CHECK_OMAKE);
                break;
            case SUB_SAVE_QUIT_ASK:
            case SUB_SAVE_QUIT_ASK_LOAD:
                window->MsgPreset(0xB, LanguageCode);
                window->SetAbsPos(5);
                window->SetMsgCursor(1);
                window->MakeMsg(0xC58);
                if (next == SUB_SAVE_QUIT_ASK_LOAD) {
                    window->MakeMsg(0xC5B);
                }
                break;
            case SUB_SAVE_OVERWRITE_ASK:
                SubGameCFGAnalyze(at_3199__3);
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_WRITING:
                if (window->mes_no != 0xC5C) {
                    SubGameCFGAnalyze(at_3200__2);
                }
                MemoryCardPtr->SetFuncNo(MC_FUNC_SAVE_OMAKE);
                break;
            case SUB_SAVE_WRITE_DONE:
                SubGameCFGAnalyze(at_3201__3);
                break;
            case SUB_SAVE_WRITE_FAILED:
            case SUB_SAVE_WRITE_FAILED_FULL:
                window->MsgPreset(0xA, LanguageCode);
                window->SetAbsPos(5);
                window->MakeMsg(0xBC1);
                if (next == SUB_SAVE_WRITE_FAILED_FULL) {
                    window->MakeMsg(0xC52);
                    window->SetMsgVolumeNoOne(slotNo);
                }
                break;
            case SUB_SAVE_SPACE_ASK:
                SubGameCFGAnalyze(at_3202__3);
                int values[2] = {0, 0};
                values[0] = slotNo;
                values[1] = SubCheckTotalSaveFileSize;
                window->SetMsgVolumeNo(values, 2);
                break;
            case SUB_SAVE_DIR_MAKING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_MAKE_OMAKE_DIR);
                SubGameCFGAnalyze(at_3200__2);
                break;
            case SUB_SAVE_FORMAT_ASK:
                SubGameCFGAnalyze(at_3203);
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_FORMATTING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_FORMAT);
                SubGameCFGAnalyze(at_3204);
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_NO_DATA:
                SubGameCFGAnalyze(at_3205);
                break;
            case SUB_SAVE_LOAD_ASK:
                SubGameCFGAnalyze(at_3206);
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_LOADING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_LOAD_OMAKE);
                window->MsgPreset(0x12, LanguageCode);
                window->SetAbsPos(5);
                window->MakeMsg(0xC5D);
                break;
            case SUB_SAVE_LOAD_DONE:
                SubGameCFGAnalyze(at_3207);
                break;
            case SUB_SAVE_LOAD_MISSING:
                window->MsgPreset(0xB, LanguageCode);
                window->SetAbsPos(5);
                window->SetMsgCursor(1);
                window->SetMsgVolumeNoOne(slotNo);
                window->MakeMsg(0xC59);
                break;
            case SUB_SAVE_CARD_ERROR:
                window->MsgPreset(0x12, LanguageCode);
                card = GetSubGameCard(Ident(MemoryCardPtr));
                if (SubGameSaveOrLoadPhase == SUB_SAVE_FORMATTING) {
                    window->MakeMsg(0xBE5);
                    window->SetMsgVolumeNoOne(slotNo);
                } else if (SubGameSaveOrLoadPhase == SUB_SAVE_LOADING) {
                    window->MsgPreset(0xA, LanguageCode);
                    window->MakeMsg(0xBC6);
                } else if (McCheckMCPs2(card) == 0) {
                    window->MakeMsg(0xBB9);
                    window->SetMsgVolumeNoOne(slotNo);
                } else if (card->free_size < SubCheckTotalSaveFileSize) {
                    window->MakeMsg(0xC50);
                    int values[2] = {0, 0};
                    values[0] = slotNo;
                    values[1] = SubCheckTotalSaveFileSize;
                    window->SetMsgVolumeNo(values, 0x10);
                }
                window->SetAbsPos(5);
                break;
            case 1001:
                break;
        }
        SubGameSaveOrLoadPhase = next;
    }
    if (SubGameSaveLoadStatus == 1) {
        MenuMainScene->fade.FadeOut(0x28, 0.0f, 0.0f, 0.0f);
    }
    SubSaveTileXY += 0.5f;
    if (0.0f <= SubSaveTileXY) {
        SubSaveTileXY -= 256.0f;
    }
    MenuDCMsg[0]->StepMsg();
    return 0;
}

void SubGameSaveDraw() {
    mgCTextureManager *textures = &mgTexManager;
    textures->ReloadTexture(SubGameSaveBlock[0], (sceVif1Packet *) 0);

    if (Tex_SaveFile != NULL) {
        mgCDrawPrim *prim = GetMenuPrim();
        mgRect<int>  rect;
        rect.Set(0x100, 0x100, 0x100, 0x100);
        DrawMenuTilePattern(prim, Tex_SaveFile, SubSaveTileXY, SubSaveTileXY, rect, 0, NULL);
    }

    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) 0);
    MenuDCMsg[0]->DrawMsg();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", manual_boot_event_no__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", submap_table_1022__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", fillw_1125__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1315__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", tp_2083__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", conv_2316__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2609__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", dngmap_2627__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", b_2715__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1023__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1024__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1025__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1026__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1027__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1028__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1029__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1030__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1031__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1032__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1033__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1034__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1035__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1036__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1037__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1038__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1039__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1040__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1041__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1042__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1043__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1102__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1103__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1104__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1105__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1106__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1107__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1108__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1109__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1237__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1238__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1428__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1429__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1430__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1431__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1432__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1433__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1434__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1435__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1436__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1437__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1438__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1439__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1440__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1441__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1512__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1513__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1514__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1515__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1516__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1517__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1518__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1519__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1648__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1649__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1650__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1651__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1652__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1653__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1654__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1655__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1656__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1900__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1901__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1902__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1903__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1904__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1905__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1906__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2024__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2025__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2084__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2085__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2086__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2498__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2499__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2500__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2501__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2502__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2503__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2504__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2505__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2506__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2507__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2508__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2509__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2510__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2511__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2512__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2513__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2514__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2515__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2518__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2517__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2603__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2604__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2605__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2628__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2629__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2630__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2631__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2632__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2633__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2634__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2764__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2765__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2766__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2767__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2768__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2769__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2770__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2771__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2772__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2773__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2774__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2775__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2821__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2822__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2823__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2824__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2825__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2826__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2827__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2895__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3198__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3199__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3200__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3201__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3202__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3203__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3204__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3205__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3206__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3207__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", __vt__14CSaveMenuClass__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", __vt__11CMenuOption__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", __vt__11CManualMenu__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", manual_list_mesclstbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", config_option_num_i__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", config_option_num_f__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1616__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", tbl_2023__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2335__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2342__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MenuReturnMsgDrawFlag, 0x4);
INCLUDE_BSS(MovieBattleBGMPhase, 0x4);
INCLUDE_BSS(Movie_DungeonFlag, 0x4);
INCLUDE_BSS(Movie_BossFlag, 0x4);
INCLUDE_BSS(MovieBgmBattleCheckStopFlag, 0x4);
INCLUDE_BSS(MovieViewFlag, 0x4);
INCLUDE_BSS(ManualMovieFadeCount_1253, 0x4);
INCLUDE_BSS(init_1254, 0x8);
INCLUDE_BSS(at_1306__5, 0x8);
INCLUDE_BSS(at_1342__3, 0x8);
INCLUDE_BSS(at_1523__2, 0x8);
INCLUDE_BSS(OptionButtonForm, 0x8);
INCLUDE_BSS(at_1614__2, 0x8);
INCLUDE_BSS(at_1615__3, 0x8);
INCLUDE_BSS(FormatCase_1968, 0x4);
INCLUDE_BSS(init_1969, 0x4);
INCLUDE_BSS(DarkClonicleFileMax_2004, 0x4);
INCLUDE_BSS(init_2005, 0x4);
INCLUDE_BSS(input_wait_counter_2067, 0x4);
INCLUDE_BSS(init_2068, 0x8);
INCLUDE_BSS(at_2115__3, 0x8);
INCLUDE_BSS(at_2276, 0x8);
INCLUDE_BSS(at_2319, 0x4);
INCLUDE_BSS(at_2326__2, 0x4);
INCLUDE_BSS(at_2327, 0x4);
INCLUDE_BSS(at_2328__2, 0x4);
INCLUDE_BSS(at_2330__2, 0x4);
INCLUDE_BSS(at_2331__2, 0x4);
INCLUDE_BSS(space_2549, 0x4);
INCLUDE_BSS(init_2550, 0x4);
INCLUDE_BSS(MenuMapInfoSave_DngNo, 0x4);
INCLUDE_BSS(SubGameSaveOrLoad, 0x4);
INCLUDE_BSS(SubGameSaveOrLoadPhase, 0x4);
INCLUDE_BSS(SubGameSaveLoadStatus, 0x4);
INCLUDE_BSS(SubGameMCPort, 0x4);
INCLUDE_BSS(SubGameSaveBlock, 0x8);
INCLUDE_BSS(SubGameSaveCFGBufferSize, 0x8);
INCLUDE_BSS(at_3070, 0x8);
INCLUDE_BSS(at_3091, 0x8);

// Uninitialised data (.bss)
INCLUDE_BSS(MnOnePictTex, 0x20);
INCLUDE_BSS(SaveFileList, 0x38);
INCLUDE_BSS(MenuMapInfoSave, 0x18);
INCLUDE_BSS(SubGameDataBgm, 0x20);
