#include "common.h"
#include "mw_runtime.h"

#include <cstdio>
#include <cstring>

#include "actionchara.hpp"
#include "charasetup.hpp"
#include "dataread.hpp"
#include "dngmenu.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "memcard.hpp"
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
#include "menuaqua.hpp"

/**
 *
 * Stores the horizontal and vertical components of a menu position, size or velocity.
 *
 */
struct IntPair {
    int x; /**< Horizontal component. */
    int y; /**< Vertical component. */
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

/**
 *
 * Event flags unlocking each manual entry, followed by the end sentinel.
 *
 */
static short manual_boot_event_no[47] = {
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 104, 108, 277, 277, 105, 105, 207, 207,
    207, 207, 220, 48, SAVE_FLAG_FISHING_CONTEST_UNLOCKED, 314, 314, 250, 250, 250,
    250, 250, 250, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, -1
};

/**
 *
 * Map names treated as boss areas when the manual menu pauses dungeon music.
 *
 */
static char *submap_table_1022[22] = {
    "s06", "d01b01", "d02b01", "d02b03", "s17", "s56", "d03b01",
    "d03b02", "s19", "s20", "d05b01", "s52", "s54", "s61",
    "s62", "s63", "s69", "s13", "s14", "s15", "s16",
    NULL
};

/**
 *
 * Picture-page help box width for each language.
 *
 */
static short fillw_1125[8] = {310, 356, 356, 356, 356, 356, 356, 310};

/**
 *
 * Dungeon map numbers used in save file location messages.
 *
 */
static unsigned char conv_2316[9] = {55, 57, 58, 64, 79, 97, 160};

/**
 *
 * Entrance map names for the seven dungeons.
 *
 */
static char *dngmap_2627[7] = {
    "d01f01", "d02f01", "d03f01", "d04f01", "d05f01", "d06f01", "d07f01"
};

/**
 *
 * Names of the three save-menu scrollbar parts.
 *
 */
static char *b_2715[3] = {
    "bar0", "bar1", "bar2"
};

/**
 *
 * Message classes displaying the five manual and option list columns.
 *
 */
static signed char manual_list_mesclstbl[5] = {2, 4, 5, 6, 8};

/**
 *
 * Number of selectable option rows, converted to an integer for navigation.
 *
 */
static float config_option_num_i = 16.0f;

/**
 *
 * Number of option rows used to size the scrollbar.
 *
 */
static float config_option_num_f = 16.0f;

/**
 *
 * Whether a manual entry can start playing.
 *
 */
static signed char MovieViewFlag;

/**
 *
 * Battle music volume saved before a manual movie.
 *
 */
static float MoviePreBattleBGMVol_Save;

/**
 *
 * Battle music volume animated during a manual movie.
 *
 */
static float MoviePreBattleBGMVol;

/**
 *
 * Background form shared by the manual and option menus.
 *
 */
static CMenuPosDataForm *LocalMenuBGForm;

/**
 *
 * Clipping form shared by the manual and option menus.
 *
 */
static CMenuPosDataForm *LocalMenuClipForm;

/**
 *
 * Movie player used by the manual menu.
 *
 */
static CMovie *ManualMovie;

/**
 *
 * Texture receiving the manual movie frames.
 *
 */
static mgCTexture *ManualMovieTex;

/**
 *
 * Memory used by the manual and option menu resources.
 *
 */
mgCMemory StaticMenuLocalStack;

/**
 *
 * Memory used by manual movies and restored character resources.
 *
 */
mgCMemory StaticMenuLocalStack2;

/**
 *
 * Whether the manual menu was opened in a boss area.
 *
 */
static short Movie_BossFlag;

/**
 *
 * Whether the manual menu was opened in a dungeon.
 *
 */
static short Movie_DungeonFlag;

/**
 *
 * Saved battle music pause flag restored after a manual movie.
 *
 */
static short MovieBgmBattleCheckStopFlag;

/**
 *
 * Phase of battle music volume changes during a manual movie.
 *
 */
static signed char MovieBattleBGMPhase;

/**
 *
 * Form containing the option choice buttons.
 *
 */
static CMenuPosDataForm *OptionButtonForm;

/**
 *
 * Music state saved while the mini-game save menu is open.
 *
 */
static CScene::BGM_STATUS SubGameDataBgm;

/**
 *
 * Memory used by the save and mini-game save menus.
 *
 */
mgCMemory SaveMenuStack;

/**
 *
 * Message windows for the thirteen save file rows.
 *
 */
static CDC2Mes *SaveFileList[13];

/**
 *
 * Texture blocks used by the mini-game save menu.
 *
 */
static short SubGameSaveBlock[3];

/**
 *
 * Whether the mini-game menu saves rather than loads.
 *
 */
static signed char SubGameSaveOrLoad;

/**
 *
 * Current phase of the mini-game save or load operation.
 *
 */
static short SubGameSaveOrLoadPhase;

/**
 *
 * Completion status of the mini-game save or load operation.
 *
 */
static short SubGameSaveLoadStatus;

/**
 *
 * Memory card port selected for the mini-game data.
 *
 */
static signed char SubGameMCPort;

/**
 *
 * Size of the mini-game save data in kilobytes.
 *
 */
static int SubTrueTotalSaveFileSize;

/**
 *
 * Card space required for the mini-game save data and directory.
 *
 */
static int SubCheckTotalSaveFileSize;

/**
 *
 * Texture containing the save menu panels and background.
 *
 */
static mgCTexture *Tex_SaveFile;

/**
 *
 * Animated background tile offset in the mini-game save menu.
 *
 */
static float SubSaveTileXY;

void InitMnOnePictTex();

/**
 *
 * Memory card manager used by the save menus.
 *
 */
static CMemoryCardManager *MemoryCardPtr;

/**
 *
 * Active save and load menu.
 *
 */
static CSaveMenuClass *SaveMenuPtr;

/**
 *
 * Active option menu.
 *
 */
static CMenuOption *CMenuOptionPtr;

/**
 *
 * Active manual menu.
 *
 */
static CManualMenu *CManualPtr;

/**
 *
 * Localized message describing how to return from the menu.
 *
 */
static CDC2Mes *MenuReturnMsg;

/**
 *
 * Whether the return message is drawn.
 *
 */
static u8 MenuReturnMsgDrawFlag;

/**
 *
 * Textures of the manual entry picture pages.
 *
 */
static mgCTexture *MnOnePictTex[8];

/**
 *
 * Loaded mini-game save menu configuration.
 *
 */
static char *SubGameSaveCFGBuffer;

/**
 *
 * Size of the loaded mini-game save menu configuration.
 *
 */
static int SubGameSaveCFGBufferSize;

/**
 *
 * Dungeon number saved while map information is replaced.
 *
 */
static short MenuMapInfoSave_DngNo;

static const int kDungeonNoOffset = 0x1C5B4;

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
        if (GetNowLoopNo() == 2) {
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
    ManualMovie = (CMovie *) operator new(0x23940, StaticMenuLocalStack.Alloc(0x2396));

    menu = new (StaticMenuLocalStack.Alloc(0x1A)) CManualMenu;

    CManualPtr = menu;
    menu->SetTexBlock(tex_block);
    InitMnOnePictTex();
    pack = (u_int *) memory->stack;
    block = CManualPtr->tex_block[0];
    mgTexManager.DeleteBlock(block);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile(pack, "op_bg.img", NULL), block, NULL, NULL);
    block = CManualPtr->tex_block[1];
    mgTexManager.DeleteBlock(block);
    mgTexManager.EnterTexture(block, "manumovieworkdm", NULL, 0x100, 0x200, 8, NULL, 0, 0);
    ManualMovieTex = mgTexManager.EnterTexture(block, "manumoviework", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, NULL, 0, 0);
    menu_data = (u_char *) GetPackFile(pack, "manual.cfg", &menu_data_size);

    if (menu_data != NULL) {
        MenuDataAnalyze((char *) menu_data, menu_data_size, &StaticMenuLocalStack);
    }

    StaticMenuLocalStack.Align64();
    free_size = StaticMenuLocalStack.stGetRest();
    StaticMenuLocalStack2.stSetBuffer(StaticMenuLocalStack.stGetTop(), free_size);
    AttachMessageForm();
    LocalMenuBGForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("op_bg");
    LocalMenuClipForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("clip0");
    CManualPtr->script = (char *) GetPackFile(pack, "manual_com.cfg", &CManualPtr->script_size);
    main_messages = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuDCMsg[2]->buff;
    MenuCommandAnalyzeInfo.mes_buff[1] = main_messages;
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = main_messages;
    MenuDCMsg[7]->SetMessData(GetSystemMesBuffer(), main_messages);
    MenuDCMsg[7]->MsgPreset(0x10);
    MenuDCMsg[7]->MakeMsg(0x11C6);
    CManualPtr->ExeScript("MSG\x8f\x89\x8a\xfa\x89\xbb");
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

            if (item >= 0 && item < MES_ITEM_MAX) {
                window->item_mes[item] = 0x50;
            }

            unlocked = CheckBitFlagMenu(manual_boot_event_no[number]);
            vtuto = 0;

            if (CheckOmakeVtuto(number) != 0) {
                vtuto = 1;
            }

            if (unlocked != 0 || vtuto != 0) {
                if (item >= 0 && item < MES_ITEM_MAX) {
                    window->item_mes[item] = number + 0x1194;
                }

                if ((number == 0x15 || number == 0x16) && item >= 0 && item < MES_LINE_MAX) {
                    window->line_color[item] = 0x80E0E060;
                }
            }
        }
    }

    Movie_DungeonFlag = GetNowLoopNo() == LOOP_DUNGEON;
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

int MenuManualKey() {
    return CManualPtr->KeyStep();
}
void MenuManualDraw() {
    CManualMenu *menu;
    CUserDataManager *userData;
    u_long128 *effectBuffer;
    u_long128 *buffer;
    mgCTexture *picture;
    int closed;
    int isTown;
    int attribute;
    int chrNo;
    CActionChara *chara;

    menu = CManualPtr;
    closed = 0;
    switch (menu->key_arg_no) {
    case MANUAL_STEP_FADE_OUT + 1:
    case MANUAL_STEP_CLOSE:
    case MANUAL_STEP_END:
        mgCTextureManager *textures = &mgTexManager;
        if (menu->pict_mode != 0) {
            picture = MnOnePictTex[menu->pict_page];
            if (picture != NULL) {
                textures->ReloadTexture(picture->block, (sceVif1Packet *)NULL);
                PrimQuad(picture, mgRect<int>(0, 0, 0x200, mgScreenHeight), mgRect<int>(0, 0, 0x200, 0x1A0), 0x80, 0x80, 0x80, 0x80);
                DrawMenuFillBox(35.0f, (float)(mgScreenHeight - 0x28), (float)fillw_1125[LanguageCode],
                                30.0f, 0x40, 0, 0, 0);
                if (MenuDCMsg[7] != NULL) {
                    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
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
            textures->ReloadTexture(CManualPtr->tex_block[1], (sceVif1Packet *)NULL);
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
            textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
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
                isTown = (u_char)!GetMenuLoopType();
                textures->DeleteBlock(MenuArg.chara_tex_block);
                MenuArg.chara_stack->stReset();
                SetupMainUnit(buffer, MenuArg.chara_stack, MenuArg.base_chara_stack,
                              MenuArg.chara_tex_block, GetMainScene(), userData,
                              userData->active_chr_no, isTown);
                MenuCharaSoundLoad(&StaticMenuLocalStack2, userData->active_chr_no, 0);
                chara = (CActionChara *)GetMainScene()->GetCharacter(0);
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
                LoadFileMenu("mb2.pac", MenuMainTextureReadBuf.stGetTop(), 1);
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
        menuFont.DrawDirect("(#):All Open", 0x12C, 0xA);
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
                MenuMainScene->battle_area.pause_flag |= 0x4000;
            } else {
                MenuMainScene->battle_area.pause_flag &= ~0x4000;
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
                ExeScript("\x8FI\x97\xB9\x8F\x88\x97\x9D");
                MenuCommonInfo->SetMoveMethod(2);
                finished = 1;
            }

            break;
        case 0:
            /**
             *
             * Counts playback frames before the manual movie fades in.
             *
             */
            static short ManualMovieFadeCount = 0;

            MenuCommonInfo->CheckSelectKey();
            pushed = MenuCommonInfo->CheckPushButton();
            keys = MenuCommonInfo->CheckLRKey();

            switch (key_arg_no) {
                case MANUAL_STEP_SELECT:
                    prev_select = select;
                    MenuKeySelectCheck(MenuListSelectKeyCheck(keys, 10), &select, &top, 0, 0x2E,
                                       10, 0);

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
                        ExeScript("PREEND");
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
                            MovieBgmBattleCheckStopFlag = battle_stop = scene->battle_area.pause_flag & 0x4000;

                            scene->battle_area.pause_flag |= 0x4000;
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
                                data_size = LoadFileMenu("mntx.pac", buffer, 1);
                            }

                            if (movie_no == 0x17) {
                                data_size = LoadFileMenu("mntx2.pac", buffer, 1);
                            }

                            if ((data_size & 0xF) != 0) {
                                blocks = (data_size >> 4) + 1;
                            } else {
                                blocks = data_size >> 4;
                            }

                            StaticMenuLocalStack2.Alloc(blocks);
                            img_data = (u_char *) GetPackFile((u_int *) buffer, "mntx.img", NULL);
                            textures->DeleteBlock(tex_block[2]);
                            textures->DeleteBlock(tex_block[3]);
                            textures->EnterIMGFile(img_data, tex_block[2], NULL, NULL);
                            pict_mode = 1;
                            pict_num = 6;
                            pict_page = 0;

                            if (movie_no == 0x17) {
                                pict_num = 3;
                            }

                            MnOnePictTex[0] = textures->GetTexture("mntx0", -1);
                            MnOnePictTex[1] = textures->GetTexture("mntx1", -1);
                            MnOnePictTex[2] = textures->GetTexture("mntx2", -1);
                            MnOnePictTex[3] = textures->GetTexture("mntx3", -1);
                            MnOnePictTex[4] = textures->GetTexture("mntx4", -1);
                            MnOnePictTex[5] = textures->GetTexture("mntx5", -1);
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
                            sprintf(name, "menu/%d/help.cfg", LanguageCode);
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
                                sprintf(movie_name, "TUTO2\\VTUTO%d.PSS", movie_no);
                            } else {
                                sprintf(movie_name, "TUTO\\VTUTO%d.PSS", movie_no);
                            }

                            ManualMovie->Load(movie_name, streams, 0x200, 0x1A0, true, false,
                                              false);
                            ManualMovie->Play("manumoviework");
                            ManualMovie->SwitchThread();

                            while (ManualMovie->IsStarted() == 0) {
                                ManualMovie->SwitchThread();
                            }

                            SetMenuFrameRate(2);
                        }

                        key_arg_no = MANUAL_STEP_PLAY;
                        ManualMovieFadeCount = 0;
                    }

                    break;
                case MANUAL_STEP_PLAY:
                    if (ManualMovieFadeCount < 3) {
                        ManualMovieFadeCount++;

                        if (ManualMovieFadeCount == 3) {
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

        if (OmakeFlag == 0 && Movie_BossFlag != 1 && !(area->pause_flag & 0x4000)) {
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

    bg_form->GetPutPosXY("base_msg", xy[0], xy[1]);
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

    bg_form->GetPutPosXY("info_msg", xy[0], xy[1]);
    form = MenuMesForm[3];

    if (form != NULL) {
        form->x = (float) xy[0];
        form->y = (float) xy[1];
    }

    bar[0] = bg_form->GetPartInfo("bar0");
    bar[1] = bg_form->GetPartInfo("bar1");
    bar[2] = bg_form->GetPartInfo("bar2");
    bg_form->GetPutPosXY("scrlbase", item_pos[0][0], item_pos[0][1]);
    MenuPosData->GetEtcTblValue("manualbarwh", scroll_range[0], scroll_range[1]);

    if (slide_in_flag == 0) {
        visible_top = top;
        LocalFunc_AdjustScrlBar(bar, &item_pos[0][0], scroll_range,
                                visible_top, 46.0f, 10.0f, slide_in);
    }

    if (LocalMenuClipForm != NULL) {
        LocalMenuBGForm->GetPutPosXY("msg_clip", xy[0], xy[1]);
        form = LocalMenuClipForm;
        form->x = (float) xy[0];
        form->y = (float) xy[1];
    }
}

void CManualMenu::CalcCursorPosition() {
    IntPair position = {0, 0};

    switch (key_arg_no) {
        case MANUAL_STEP_SELECT:
        case MANUAL_STEP_PLAY:
            break;
    }

    if (LocalMenuBGForm != NULL) {
        LocalMenuBGForm->GetPutPosXY("base_msg", position.x, position.y);
    }

    position.x -= 50;
    position.y += (select - top) * 24;
    MenuCommonInfo->MenuPosStep(&position.x, NULL);

    if (cursor_jump != 0) {
        MenuCommonInfo->MenuSetPos(position.x, position.y);
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
                CBaseMenuClass::ExeScript("INITEND");

                if (MenuArg.open_type == MENU_OPEN_OPTION) {
                    CBaseMenuClass::ExeScript("TITLE_INITEND");
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
                CBaseMenuClass::ExeScript("\x8FI\x97\xB9\x8F\x88\x97\x9D");

                if (MenuConfigPtr != NULL) {
                    printf("cam_ctrl[0]  : %d\n", MenuConfigPtr->eye_reverse);
                    printf("cam_ctrl[1]  : %d\n", MenuConfigPtr->rot_normal);

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
                                   0) != 0) {
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
                    if (select == 12) {
                        config.caption_off = choice;
                    } else if (select == 13) {
                        config.unk_35 = choice;
                    } else if (select == 14) {
                        config.eye_reverse = choice;
                    } else if (select == 15) {
                        config.rot_normal = choice;
                    } else if (select != 8 || config.enemy_hp != 1) {
                        *value[select] = choice;

                        if (select == 7 && choice == 1) {
                            *value[8] = 1;
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
                    memcpy(MenuConfigPtr, &config, 0x40);
                    MenuCommonInfo->SetMoveMethod(-1);
                    MenuCommonInfo->SetWakuType(-1);

                    if (MenuArg.open_type == MENU_OPEN_OPTION) {
                        CBaseMenuClass::ExeScript("PREEND_T");
                    } else {
                        MenuMainFrameModeSet(9, 0);
                        ReturnMenuIntern(0);
                        MenuCommonInfo->SetWakuType(-1);
                        CBaseMenuClass::ExeScript("PREEND");
                    }

                    break;
            }

            break;
    }

    CalcTex();
    MenuPosData->FormStep();
    {
        IntPair pos = {0, 0};
        IntPair size = {0, 0};
        IntPair velocity = {-48, 0};
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
                    sprintf(name, "INDEX0%d%d", row_no, choice_no);
                } else {
                    sprintf(name, "INDEX%d%d", row_no, choice_no);
                }

                OptionButtonForm->GetPutPosXY(name, pos.x, pos.y);
                pos.x -= 2;
                pos.y -= 3;
                sprintf(name, "op_waku%d", select);
                MenuPosData->GetEtcTblValue(name, size.x, size.y);
                MenuCommonInfo->SetWakuWH(0, size.x, size.y);
                MenuPosData->GetEtcTblValue("op_cursorlimmit", limit[0], limit[1]);

                if (pos.y < limit[0]) {
                    pos.y = limit[0];
                }

                if (limit[1] < pos.y) {
                    pos.y = limit[1];
                }

                MenuCommonInfo->MenuPosStep(&pos.x, &velocity.x);
                break;
        }

        if (cursor_jump != 0) {
            MenuCommonInfo->MenuSetPos(pos.x, pos.y);
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

    bg_form->GetPutPosXY("base_msg", xy[0], xy[1]);
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

    bg_form->GetPutPosXY("info_msg", xy[0], xy[1]);
    mes_form = MenuMesForm[3];

    if (mes_form != NULL) {
        mes_form->x = (float) xy[0];
        mes_form->y = (float) xy[1];
    }

    bar[0] = bg_form->GetPartInfo("bar0");
    bar[1] = bg_form->GetPartInfo("bar1");
    bar[2] = bg_form->GetPartInfo("bar2");
    bg_form->GetPutPosXY("scrlbase", item_pos[0][0], item_pos[0][1]);
    MenuPosData->GetEtcTblValue("manualbarwh", scroll_range[0], scroll_range[1]);

    if (slide_in_flag == 0) {
        LocalFunc_AdjustScrlBar(
            bar, &item_pos[0][0], scroll_range, top, config_option_num_f, 9.0f, slide_in);
    }

    if (LocalMenuClipForm != NULL) {
        bg_form->GetPutPosXY("msg_clip", xy[0], xy[1]);
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
            row = this->button[0];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->cursor_save]);
            }

            row = this->button[1];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->vibration]);
            }

            row = this->button[2];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->message_speed]);
            }

            row = this->button[3];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->sound_mode]);
            }

            row = this->button[4];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->fast_time]);
            }

            loop_row = this->button[5];

            if (loop_row != NULL) {
                DefaultButton(loop_row);

                for (i = 0, offset = 0; i < 3; i++, offset += 4) {
                    if (config->map == i) {
                        EnableButton(*(MENUFORMPARTS_TYPE **) ((u8 *) loop_row + offset));
                    }
                }
            }

            row = this->button[6];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->damage_off]);
            }

            row = this->button[7];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->enemy_hp]);
            }

            row = this->button[8];

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

            row = this->button[10];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->monster_name]);
            }

            row = this->button[11];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->dof_off]);
            }

            row = this->button[12];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->caption_off]);
            }

            row = this->button[13];

            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->unk_35]);
            }

            row = this->button[14];

            if (LanguageCode > 0) {
                if (row != NULL) {
                    DefaultButton(row);
                    EnableButton(row[config->eye_reverse]);
                }

                row = this->button[15];

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
    textures->EnterIMGFile((u_char *) GetPackFile(pack, "op_bg.img", NULL), block, NULL, NULL);
    textures->EnterIMGFile((u_char *) GetPackFile(pack, "option.img", NULL), block, NULL, NULL);

    if (MenuArg.open_type == 0x12) {
        textures->EnterIMGFile(GetMenuMainIMGPtr(), block, NULL, NULL);
    }

    menu_data = (u_char *) GetPackFile(pack, "option.cfg", &menu_data_size);

    if (menu_data != NULL) {
        MenuDataAnalyze((char *) menu_data, menu_data_size, &StaticMenuLocalStack);
    }

    AttachMessageForm();
    LocalMenuBGForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("op_bg");
    LocalMenuClipForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("clip0");
    OptionButtonForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("Op_Switch");

    for (option = 0; option < OPTION_ITEM_MAX; option++) {
        if (option < 10) {
            sprintf(prefix, "INDEX0%d", option);
        } else {
            sprintf(prefix, "INDEX%d", option);
        }

        for (choice = 0; choice < OPTION_BUTTON_NUM; choice++) {
            CMenuOptionPtr->button[option][choice] = NULL;

            if (OptionButtonForm != NULL) {
                strcpy(name, prefix);
                strcat(name, "%d");
                sprintf(name, name, choice);
                CMenuOptionPtr->button[option][choice] = OptionButtonForm->GetPartInfo(name);
            }
        }
    }

    memcpy(&CMenuOptionPtr->config, MenuConfigPtr, 0x40);
    memcpy(&CMenuOptionPtr->config_backup, MenuConfigPtr, 0x40);
    CMenuOptionPtr->script = (char *) GetPackFile(pack, "opt_com.cfg", &CMenuOptionPtr->script_size);
    CMenuOptionPtr->value[0] = &CMenuOptionPtr->config.cursor_save;
    CMenuOptionPtr->value[1] = &CMenuOptionPtr->config.vibration;
    CMenuOptionPtr->value[2] = &CMenuOptionPtr->config.message_speed;
    CMenuOptionPtr->value[3] = &CMenuOptionPtr->config.sound_mode;
    CMenuOptionPtr->value[4] = &CMenuOptionPtr->config.fast_time;
    CMenuOptionPtr->value[5] = &CMenuOptionPtr->config.map;
    CMenuOptionPtr->value[6] = &CMenuOptionPtr->config.damage_off;
    CMenuOptionPtr->value[7] = &CMenuOptionPtr->config.enemy_hp;
    CMenuOptionPtr->value[8] = &CMenuOptionPtr->config.anger_counter;
    CMenuOptionPtr->value[9] = &CMenuOptionPtr->config.unk_24;
    CMenuOptionPtr->value[10] = &CMenuOptionPtr->config.monster_name;
    CMenuOptionPtr->value[11] = &CMenuOptionPtr->config.dof_off;

    for (int item = 0; (float) item < config_option_num_i; item++) {
        CMenuOptionPtr->choice_num[item] = 2;
    }

    CMenuOptionPtr->choice_num[5] = 3;
    CMenuOptionPtr->UpdateOptionForm();
    main_messages = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuDCMsg[2]->buff;
    MenuCommandAnalyzeInfo.mes_buff[1] = main_messages;
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = main_messages;
    CMenuOptionPtr->ExeScript("MSG\x8F\x89\x8A\xFA\x89\xBB");
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
        float visible_ratio = (float)size[1] / line_num;
        float bar_height = visible_ratio * show_num;
        parts[1]->h = (bar_height - parts[0]->h) - parts[2]->h;
        size[1] -= bar_height;
        float travel_lines = line_num - show_num;
        if (travel_lines < 1.0f) {
            travel_lines = 1.0f;
        }
        float pixels_per_line = (float)size[1] / travel_lines;
        CalcMenu1((float)pos[1] + pixels_per_line * (float)top, &parts[0]->y, 4.0f, 0.0f, jump);
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

int CSaveMenuClass::KeyStep() {
    int                 transferred;
    int                 finished;
    CDC2Mes            *file_mes;
    CDC2Mes            *title_mes;
    int                 step_result;
    MC_ERROR_INFO      *error;
    int                 next;
    int                 refresh;
    int                 open_done;
    int                 move_key;
    int                 select_keys;
    bool                input_waiting;
    int                 pushed;
    int                 lr_keys;
    int                 answer;
    int                 cursor_pos;
    int                 file_no;
    int                 index;
    MC_CARD_INFO       *card;
    SAVEDATA_INFO      *info;
    int                 empty_mes;
    int                 row;
    int                 map_no;
    int                 chapter;
    SAVEDATA_INFO      *row_info[13];
    CDC2Mes            *row_mes;
    int                 form_pos[9][2];
    CMemoryCardManager *manager;

    finished = 0;
    step_result = MemoryCardPtr->Step();
    file_mes = MenuDCMsg[2];
    title_mes = MenuDCMsg[3];
    error = &MemoryCardPtr->error;
    /**
     *
     * Records whether formatting continues into the pending save.
     *
     */
    static int FormatCase = 0;
    if (DebugFlag != 0 && menu_debug_flag != 0) {
        GamePad__2.Down(PAD_L1);
    }
    refresh = 0;
    next = SAVE_MENU_PAGE_NONE;
    switch (CBaseMenuClass::mode) {
        case MENU_ASK_MODE_OPEN:
            open_done = 0;
            if (step == SAVE_MENU_STEP_READY) {
                if (first_step != 0) {
                    next = SAVE_MENU_PAGE_SLOT_SELECT;
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
                        ExeScript("CLR_SV_INITMSG");
                        step = SAVE_MENU_STEP_NOTICE;
                    } else {
                        open_done = 1;
                    }
                }
            } else if (step == SAVE_MENU_STEP_NOTICE && MenuCommonInfo->CheckPushButton() != 0) {
                open_done = 1;
                ExeScript("CLR_SV_ENDMSG");
            }
            if (open_done != 0) {
                CBaseMenuClass::mode = MENU_ASK_MODE_NONE;
                step = SAVE_MENU_STEP_READY;
            }
            break;
        case MENU_ASK_MODE_CLOSE:
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
            /**
             *
             * Stores the file-count value for the save-menu pages.
             *
             */
            static int DarkClonicleFileMax = 0;
            move_key = 0;
            select_keys = MenuCommonInfo->CheckSelectKey();
            pushed = MenuCommonInfo->CheckPushButton();
            lr_keys = MenuCommonInfo->CheckLRKey();
            if (select_keys & MENU_SELECT_KEY_UP) {
                move_key -= 1;
            }
            if (select_keys & MENU_SELECT_KEY_DOWN) {
                move_key += 1;
            }
            switch (page) {
                case SAVE_MENU_PAGE_SLOT_SELECT:
                    if (step == SAVE_MENU_STEP_READY) {
                        int prev_slot = slot;
                        slot = prev_slot + move_key;
                        if (slot < 0) {
                            slot = 0;
                        }
                        if (slot > 1) {
                            slot = 1;
                        }
                        if (slot != prev_slot) {
                            MenuSePlay(SYSTEM_SE_CURSOR);
                        }
                        /**
                         *
                         * Cursor actions selecting the two memory card slots.
                         *
                         */
                        static char *tbl[2] = {"slot1", "slot2"};
                        if (cursor_form != NULL) {
                            cursor_form->SetAction(tbl[slot]);
                        }
                        switch (ConvertCheckPushButton(pushed)) {
                            case MENU_PUSH_BUTTON_DECIDE:
                                MenuSePlay(SYSTEM_SE_DECIDE);
                                MemoryCardPtr->InitPlayDataInfo();
                                next = SAVE_MENU_PAGE_CARD_INFO;
                                MemoryCardPtr->port = slot;
                                break;
                            case MENU_PUSH_BUTTON_CANCEL:
                                MenuSePlay(SYSTEM_SE_CANCEL);
                                if (save_count <= 0 && chapter8_start == 1) {
                                    step = SAVE_MENU_STEP_NOTICE;
                                    ExeScript("CLR_SV_CONFIRM");
                                } else {
                                    FadeOutMenu(0x28, 0.0f);
                                    CBaseMenuClass::mode = MENU_ASK_MODE_CLOSE;
                                }
                                break;
                        }
                    } else if (step == SAVE_MENU_STEP_NOTICE) {
                        answer = file_mes->YesNoCursor2(0);
                        if (answer == MES_YESNO_YES) {
                            FadeOutMenu(0x28, 0.0f);
                            CBaseMenuClass::mode = MENU_ASK_MODE_CLOSE;
                            MenuSePlay(SYSTEM_SE_DECIDE);
                        }
                        if (answer == MES_YESNO_NO) {
                            step = SAVE_MENU_STEP_READY;
                            ExeScript("MES2_CNL");
                        }
                    }
                    break;
                case SAVE_MENU_PAGE_CARD_INFO:
                    card = GetSaveMenuCard(slot);
                    if (step_result != MC_STEP_BUSY) {
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
                    if (step_result != MC_STEP_BUSY) {
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
                        /**
                         *
                         * Delays confirmation after the file or yes/no cursor moves.
                         *
                         */
                        static signed char input_wait_counter = 0;
                        switch (phase) {
                            case SAVE_LIST_PHASE_SELECT:
                                if ((lr_keys & MENU_SELECT_KEY_L1) || (lr_keys & MENU_SELECT_KEY_L2)) {
                                    move_key -= 2;
                                } else if ((lr_keys & MENU_SELECT_KEY_R1) || (lr_keys & MENU_SELECT_KEY_R2)) {
                                    move_key += 2;
                                }
                                if (MenuKeySelectCheck(move_key, &select, &top, 0, 13, 3, 0) != 0) {
                                    MenuSePlay(SYSTEM_SE_CURSOR);
                                    input_wait_counter = 4;
                                }
                                /**
                                 *
                                 * Cursor actions selecting the three visible save file rows.
                                 *
                                 */
                                static char *tp[3] = {"list0", "list1", "list2"};
                                if (cursor_form != NULL) {
                                    cursor_form->SetAction(tp[select - top]);
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
                                        case MENU_PUSH_BUTTON_DECIDE:
                                            ExeScript("FILE_OKBTN");
                                            if (McCheckMCPs2(card) == 0) {
                                                phase = SAVE_LIST_PHASE_SELECT;
                                                next = SAVE_MENU_PAGE_ERROR;
                                                MenuSePlay(SYSTEM_SE_DECIDE);
                                            } else {
                                                file_no = select + 1;
                                                if (mode == SAVE_MENU_MODE_SAVE) {
                                                    if (card->formatted == 0) {
                                                        next = SAVE_MENU_PAGE_FORMAT;
                                                        FormatCase = 1;
                                                        phase = SAVE_LIST_PHASE_SELECT;
                                                        MenuSePlay(SYSTEM_SE_DECIDE);
                                                    } else {
                                                        input_wait_counter = 0;
                                                        if (info->state == 1) {
                                                            save_kind = SAVE_FILE_OVERWRITE;
                                                            file_mes->SetMsgVolumeNoOne(file_no);
                                                            file_mes->MakeMsg(0xBC4);
                                                            file_mes->SetMsgCursor(1);
                                                            if (chapter8_start == 1) {
                                                                file_mes->MakeMsg(0xC44);
                                                            }
                                                            phase = SAVE_LIST_PHASE_CONFIRM_SAVE;
                                                        } else {
                                                            save_kind = SAVE_FILE_NEW;
                                                            if (card->free_size <= check_kb) {
                                                                next = SAVE_MENU_PAGE_ERROR;
                                                            } else {
                                                                file_mes->SetMsgVolumeNoOne(need_kb);
                                                                file_mes->MakeMsg(0xBC3);
                                                                file_mes->SetMsgCursor(1);
                                                                phase = SAVE_LIST_PHASE_CONFIRM_SAVE;
                                                            }
                                                        }
                                                        MenuSePlay(SYSTEM_SE_DECIDE);
                                                    }
                                                } else if (info->state == 1) {
                                                    phase = SAVE_LIST_PHASE_CONFIRM_LOAD;
                                                    if (mode == SAVE_MENU_MODE_GYORACE_LOAD) {
                                                        if (info->fish_num <= 0) {
                                                            ExeScript("NOT_FISH");
                                                            file_mes->SetMsgVolumeNoOne(file_no);
                                                            phase = SAVE_LIST_PHASE_NOTICE;
                                                            break;
                                                        }
                                                        int values[2] = {0, 0};
                                                        values[0] = file_no;
                                                        values[1] = info->fish_num;
                                                        file_mes->SetMsgCursor(1);
                                                        file_mes->SetMsgVolumeNo(values, MES_VALUE_MAX);
                                                        file_mes->MakeMsg(0x13A9);
                                                    } else {
                                                        file_mes->SetMsgCursor(1);
                                                        file_mes->SetMsgVolumeNoOne(file_no);
                                                        file_mes->MakeMsg(0xBE0);
                                                    }
                                                    MenuSePlay(SYSTEM_SE_DECIDE);
                                                } else {
                                                    ExeScript("MES2_CNL");
                                                }
                                            }
                                            break;
                                        case MENU_PUSH_BUTTON_CANCEL:
                                            next = SAVE_MENU_PAGE_SLOT_SELECT;
                                            MenuMesForm[2]->draw_flag = 0;
                                            MenuSePlay(SYSTEM_SE_CANCEL);
                                            break;
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_CONFIRM_SAVE:
                                cursor_pos = file_mes->GetMsgCursor();
                                answer = file_mes->YesNoCursor();
                                if (answer != cursor_pos) {
                                    input_wait_counter = 6;
                                }
                                input_wait_counter--;
                                if (input_wait_counter <= 0) {
                                    input_wait_counter = 0;
                                }
                                input_waiting = input_wait_counter > 0;
                                if (!input_waiting) {
                                    switch (pushed) {
                                        case MENU_PUSH_BUTTON_DECIDE:
                                            if (answer == 0) {
                                                EnvSetSave(save_kind);
                                                MenuSePlay(SYSTEM_SE_DECIDE);
                                                break;
                                            }
                                        case MENU_PUSH_BUTTON_CANCEL:
                                            next = SAVE_MENU_PAGE_FILE_LIST;
                                            MenuMesForm[2]->draw_flag = 0;
                                            cursor_form->draw_flag = 0;
                                            MenuSePlay(SYSTEM_SE_CANCEL);
                                            break;
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_NOTICE:
                                if (pushed != 0) {
                                    next = SAVE_MENU_PAGE_FILE_LIST;
                                    ExeScript("MES2_CNL");
                                }
                                break;
                            case SAVE_LIST_PHASE_UNK_7:
                                break;
                            case SAVE_LIST_PHASE_SAVING:
                                transferred = MemoryCardPtr->total_transferred;
                                StepMenuDl2(dl_base + transferred);
                                if (step_result != MC_STEP_BUSY) {
                                    if (error->code != MC_ERROR_NONE) {
                                        printf("mc_err_info->info : %d\n", error->code);
                                        next = SAVE_MENU_PAGE_ERROR;
                                    } else {
                                        save_count++;
                                        phase = SAVE_LIST_PHASE_SAVE_DONE;
                                        InitMenuDl(NULL, 0);
                                        file_mes->push_button = 1;
                                        file_mes->MakeMsg(0xBC0);
                                        if (chapter8_start == 1) {
                                            file_mes->MakeMsg(0xC45);
                                        }
                                        file_mes->SetAbsPos(5);
                                        refresh = 1;
                                        SetDlInfoMsg(0, 0);
                                        MenuSePlay(SYSTEM_SE_COMPLETE);
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
                                    ExeScript("SAVEEND");
                                }
                                break;
                            case SAVE_LIST_PHASE_MAKING_DIR:
                                transferred = MemoryCardPtr->total_transferred;
                                StepMenuDl2(transferred);
                                if (step_result != MC_STEP_BUSY) {
                                    card = GetSaveMenuCard(slot);
                                    if (McCheckMCPs2(card) == 0) {
                                        next = SAVE_MENU_PAGE_ERROR;
                                        error->code = MC_ERROR_FILE;
                                    } else {
                                        dl_base = MemoryCardPtr->total_transferred;
                                        MemoryCardPtr->SetFuncNo(MC_FUNC_SAVE);
                                        phase = SAVE_LIST_PHASE_SAVING;
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_CONFIRM_LOAD:
                                cursor_pos = file_mes->GetMsgCursor();
                                answer = file_mes->YesNoCursor();
                                if (McCheckMCPs2(card) == 0 || card->formatted == 0) {
                                    next = SAVE_MENU_PAGE_ERROR;
                                    MenuSePlay(SYSTEM_SE_CANCEL);
                                } else {
                                    if (answer != cursor_pos) {
                                        input_wait_counter = 6;
                                    }
                                    input_wait_counter--;
                                    if (input_wait_counter <= 0) {
                                        input_wait_counter = 0;
                                    }
                                    input_waiting = input_wait_counter > 0;
                                    if (!input_waiting) {
                                        switch (pushed) {
                                            case MENU_PUSH_BUTTON_DECIDE:
                                                if (answer == 0) {
                                                    MemoryCardPtr->file_no = select;
                                                    MemoryCardPtr->SetFuncNo(MC_FUNC_LOAD);
                                                    phase = SAVE_LIST_PHASE_LOADING;
                                                    ExeScript("LOADSTART");
                                                    file_mes->SetMsgVolumeNoOne(slot + 1);
                                                    file_mes->push_button = 0;
                                                    InitMenuDl(dl_tex, MemoryCardPtr->GetSaveDataSize(MC_SIZE_SAVE_FILE));
                                                    SetDlInfoMsg(1, 1);
                                                    break;
                                                }
                                            case MENU_PUSH_BUTTON_CANCEL:
                                                next = SAVE_MENU_PAGE_FILE_LIST;
                                                MenuSePlay(SYSTEM_SE_CANCEL);
                                                break;
                                        }
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_LOADING:
                                transferred = MemoryCardPtr->total_transferred;
                                StepMenuDl2(transferred);
                                if (step_result != MC_STEP_BUSY) {
                                    card = GetSaveMenuCard(slot);
                                    if (error->code != MC_ERROR_NONE) {
                                        next = SAVE_MENU_PAGE_ERROR;
                                    } else if (McCheckMCPs2(card) == 0) {
                                        next = SAVE_MENU_PAGE_ERROR;
                                    } else {
                                        phase = SAVE_LIST_PHASE_LOAD_DONE;
                                        InitMenuDl(NULL, 0);
                                        file_mes->push_button = 1;
                                        file_mes->MakeMsg(0xBE2);
                                        file_mes->SetAbsPos(5);
                                        SetDlInfoMsg(1, 0);
                                        MenuSePlay(SYSTEM_SE_COMPLETE);
                                    }
                                }
                                break;
                            case SAVE_LIST_PHASE_LOAD_DONE:
                                if (pushed != 0) {
                                    phase = SAVE_LIST_PHASE_CONFIRM_LOAD;
                                    ExeScript("LOADEND");
                                    CBaseMenuClass::mode = MENU_ASK_MODE_CLOSE;
                                    manager = MemoryCardPtr;
                                    MenuArg.end_code = SAVE_MENU_END_LOAD;
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
                                answer = file_mes->YesNoCursor2(0);
                                if (answer == MES_YESNO_YES) {
                                    refresh = 1;
                                    MemoryCardPtr->InitPlayDataInfo();
                                    MemoryCardPtr->SetFuncNo(MC_FUNC_FORMAT);
                                    file_mes->MsgPreset(MENU_SCRIPT_MES_GENERAL_2, LanguageCode);
                                    file_mes->SetMsgVolumeNoOne(slot + 1);
                                    file_mes->MakeMsg(0xBE8);
                                    file_mes->SetAbsPos(5);
                                    MenuSePlay(SYSTEM_SE_DECIDE);
                                    phase = SAVE_FORMAT_PHASE_FORMATTING;
                                }
                                if (answer == MES_YESNO_NO) {
                                    next = SAVE_MENU_PAGE_FILE_LIST;
                                    MenuSePlay(SYSTEM_SE_CANCEL);
                                }
                                break;
                            case SAVE_FORMAT_PHASE_FORMATTING:
                                if (step_result != MC_STEP_BUSY) {
                                    file_mes->MsgPreset(MENU_SCRIPT_MES_GENERAL, LanguageCode);
                                    file_mes->SetAbsPos(5);
                                    if (card->formatted == 0 || McCheckMCPs2(card) == 0) {
                                        file_mes->MakeMsg(0xBE5);
                                        phase = SAVE_FORMAT_PHASE_DONE;
                                    } else if (FormatCase == 0) {
                                        file_mes->MakeMsg(0xBE9);
                                        phase = SAVE_FORMAT_PHASE_DONE;
                                    } else {
                                        page = SAVE_MENU_PAGE_FILE_LIST;
                                        phase = SAVE_FORMAT_PHASE_FORMATTING;
                                        EnvSetSave(SAVE_FILE_NEW);
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
                            if (pushed & MENU_PUSH_BUTTON_DECIDE) {
                                MemoryCardPtr->port = 0;
                                MemoryCardPtr->SetFuncNo(MC_FUNC_UNFORMAT);
                                MenuMesForm[2]->draw_flag = 1;
                                file_mes->MakeMsg(0xBF5);
                                phase = SAVE_FORMAT_PHASE_FORMATTING;
                            }
                            break;
                        case SAVE_FORMAT_PHASE_FORMATTING:
                            if (step_result != MC_STEP_BUSY) {
                                phase = SAVE_FORMAT_PHASE_DONE;
                                file_mes->MakeMsg(0xBF6);
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
                            MenuSePlay(SYSTEM_SE_CANCEL);
                        }
                    } else if (card->type == sceMcTypePS2) {
                        if (card->formatted == 0) {
                            if (mode == SAVE_MENU_MODE_LOAD) {
                                if (pushed != 0) {
                                    next = SAVE_MENU_PAGE_SLOT_SELECT;
                                    MenuSePlay(SYSTEM_SE_CANCEL);
                                }
                            } else {
                                answer = 0;
                                if (file_mes->mes_no == 0xBEB) {
                                    answer = file_mes->YesNoCursor();
                                }
                                switch (pushed) {
                                    case MENU_PUSH_BUTTON_DECIDE:
                                        if (file_mes->mes_no == 0xBEB && answer == 0) {
                                            next = SAVE_MENU_PAGE_FORMAT;
                                            MenuSePlay(SYSTEM_SE_DECIDE);
                                            break;
                                        }
                                    case MENU_PUSH_BUTTON_CANCEL:
                                        next = SAVE_MENU_PAGE_SLOT_SELECT;
                                        MenuSePlay(SYSTEM_SE_CANCEL);
                                        break;
                                }
                            }
                        } else if (mode == SAVE_MENU_MODE_LOAD && MemoryCardPtr->CheckDataFileNum() <= 0) {
                            if (pushed != 0) {
                                next = SAVE_MENU_PAGE_SLOT_SELECT;
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            }
                        } else if (card->free_size <= check_kb) {
                            if (pushed != 0) {
                                next = SAVE_MENU_PAGE_SLOT_SELECT;
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            }
                        } else if (pushed != 0) {
                            next = SAVE_MENU_PAGE_SLOT_SELECT;
                            MenuSePlay(SYSTEM_SE_CANCEL);
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
            phase = SAVE_LIST_PHASE_SELECT;
            next = SAVE_MENU_PAGE_CARD_INFO;
            card_changed = 0;
        } else {
            if (McCheckMCPs2(card) == 0) {
                MenuMesForm[2]->draw_flag = 1;
                file_mes->MsgPreset(MENU_SCRIPT_MES_GENERAL, LanguageCode);
                file_mes->SetAbsPos(5);
                file_mes->MakeMsg(0xBE7);
                if (error->code == MC_ERROR_FILE) {
                    file_mes->MakeMsg(0xBC1);
                }
            } else if (card->formatted == 0) {
                file_mes->MsgPreset(MENU_SCRIPT_MES_GENERAL, LanguageCode);
                file_mes->SetAbsPos(5);
                file_mes->MakeMsg(0xBED);
                file_mes->SetMsgVolumeNoOne(slot + 1);
            } else if (mode == SAVE_MENU_MODE_LOAD && MemoryCardPtr->CheckDataFileNum() <= 0) {
                file_mes->MsgPreset(MENU_SCRIPT_MES_GENERAL, LanguageCode);
                file_mes->SetAbsPos(5);
                file_mes->MakeMsg(0xBE3);
                file_mes->SetMsgVolumeNoOne(slot + 1);
            } else if (card->free_size <= check_kb) {
                ExeScript("SIZE_NOT");
                int values[2] = {0, 0};
                values[0] = slot + 1;
                values[1] = need_kb;
                file_mes->SetMsgVolumeNo(values, 2);
            }
            if (error->code == MC_ERROR_LOAD) {
                MenuMesForm[7]->draw_flag = 0;
                MenuMesForm[2]->draw_flag = 1;
                file_mes->MsgPreset(MENU_SCRIPT_MES_GENERAL, LanguageCode);
                file_mes->SetAbsPos(5);
                file_mes->MakeMsg(0xBC6);
            }
        }
    }
    if (0 <= next || first_step != 0) {
        switch (next) {
            case SAVE_MENU_PAGE_SLOT_SELECT:
                phase = 0;
                ExeScript("NEXT_SLOT");
                SetMenuReturnMsgCtrl(1);
                break;
            case SAVE_MENU_PAGE_CARD_INFO:
                MemoryCardPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                phase = 0;
                ExeScript("GET_CARDINFO");
                file_mes->push_button = 0;
                slot_form[slot]->SetAction("\x8F\xE3\x82\xD6");
                slot_form[!slot]->SetRGBACalcParam(3, -8, 0);
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
                    phase = SAVE_LIST_PHASE_SELECT;
                    file_mes->MakeMsg(0xBBE);
                    title_mes->MakeMsg(0xC1D);
                }
                if (mode == SAVE_MENU_MODE_LOAD || mode == SAVE_MENU_MODE_GYORACE_LOAD) {
                    phase = SAVE_LIST_PHASE_SELECT;
                    file_mes->MsgPreset(MENU_SCRIPT_MES_YESNO, LanguageCode);
                    title_mes->MakeMsg(0xC1E);
                }
                refresh = 1;
                list_jump = 1;
                MenuMesForm[2]->draw_flag = 0;
                cursor_form->draw_flag = 1;
                list_form->draw_flag = 1;
                scrlbar_form->draw_flag = 1;
                break;
            case SAVE_MENU_PAGE_FORMAT:
                phase = SAVE_FORMAT_PHASE_ASK;
                ExeScript("FORMAT");
                if (file_mes != NULL) {
                    file_mes->SetMsgVolumeNoOne(slot + 1);
                }
                break;
            case SAVE_MENU_PAGE_UNK_5:
                phase = SAVE_FORMAT_PHASE_ASK;
                break;
            case SAVE_MENU_PAGE_ERROR:
                break;
        }
        first_step = 0;
        page = next;
    }
    if (refresh != 0) {
        card = GetSaveMenuCard(MemoryCardPtr->port);
        empty_mes = 0xC27;
        if (card != NULL && card->formatted != 0 && card->free_size <= check_kb) {
            empty_mes = 0xC28;
        }
        for (row = 0; row < 13; row++) {
            row_mes = SaveFileList[row];
            row_mes->ClsMes::mes_no = -1;
            row_info[row] = &MemoryCardPtr->file_info[row];
            info = row_info[row];
            if (info->state != 0) {
                map_no = info->map_no;
                if (info->program_loop_no == LOOP_DUNGEON) {
                    map_no = conv_2316[info->dungeon_no];
                }
                if (map_no == 0x29) {
                    map_no = 0xB;
                }
                char *title[1] = {NULL};
                title[0] = GetMapTitle(map_no);
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
                int item_no[1] = {0};
                item_no[0] = chapter + 0xC7F;
                row_mes->SetMsgItemNo(title, 1);
                row_mes->SetMsgItemNo(item_no, 1);
                int slot_number[1] = {0};
                slot_number[0] = row + 1;
                int slot_width[1] = {0};
                row_mes->SetMsgVolumeNo(slot_number, slot_width, 1);
                row_mes->MakeMsg(0xC26);
            } else {
                int slot_number[1] = {0};
                slot_number[0] = row + 1;
                int slot_width[1] = {0};
                row_mes->SetMsgVolumeNo(slot_number, slot_width, 1);
                row_mes->MakeMsg(empty_mes);
            }
            row_mes->StepMsg();
        }
    }
    if (list_form != NULL) {
        float list_pos[2] = {76.0f, 164.0f};
        CalcMenu1(list_pos[1] - 80.0f * (float) top, &list_form->y, 4.0f, 4.0f, list_jump);
    }
    MenuPosData->FormStep();
    CDC2Mes *slot1_mes = MenuDCMsg[4];
    CDC2Mes *slot2_mes = MenuDCMsg[5];
    CDC2Mes *help_mes = MenuDCMsg[6];
    if (title_form != NULL) {
        title_mes->StepMsg();
        title_form->GetPutPosXY("msgpos", form_pos[0][0], form_pos[0][1]);
        title_mes->SetMovePosCenteringGyou(0, form_pos[0][0], form_pos[0][1]);
        title_form->GetPutPosXY("msgpos_sub0", form_pos[0][0], form_pos[0][1]);
        help_mes->SetMovePosCenteringGyou(0, form_pos[0][0], form_pos[0][1]);
    }
    if (slot_form[0] != NULL) {
        slot_form[0]->GetPutPosXY("msg_b", form_pos[0][0], form_pos[0][1]);
        slot1_mes->SetMovePosCenteringGyou(0, form_pos[0][0], form_pos[0][1]);
    }
    if (slot_form[1] != NULL) {
        slot_form[1]->GetPutPosXY("msg_b", form_pos[0][0], form_pos[0][1]);
        slot2_mes->SetMovePosCenteringGyou(0, form_pos[0][0], form_pos[0][1]);
    }
    int scroll_range[2] = {6, 250};
    LocalFunc_AdjustScrlBar(scrlbar_parts, scrlbar_pos, scroll_range, top, 13.0f, 3.0f, list_jump);
    if (list_jump != 0) {
        list_jump = 0;
    }
    return finished;
}

void SaveFileListDraw(int &tex_block, float *pos, int alpha) {
    ScreenPos linePos[13];
    SAVEDATA_INFO *info[13];
    mgRect<int> nameRect;
    mgRect<int> markRect;
    mgCDrawPrim *prim;
    int shadowAlpha;
    int centerX;
    int offset;
    int i;
    int row;
    CDC2Mes *window;
    float rowY;
    float top;
    u_long minutesTotal;
    u_long minutes;

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
            line->y = pos[1] + 80.0f * (float)i;
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
        centerX = fptosi(pos[0] + (float)offset);
        CMenuFont font;
        char timeText[0x80];
        char hoursText[0x40];
        char digitText[0x40];
        font.SetClearance(0xE, 0x14);
        MenuReloadTexture(tex_block, MenuArg.mes_tex_block);
        for (row = 0; row < 13; row++) {
            window = SaveFileList[row];
            ScreenPos *line = &linePos[row];
            int textY = (int)(18.0f + line->y);
            window->line_pos[0][0] = (int)(18.0f + line->x);
            window->line_pos[0][1] = textY;
            window->line_pos_on[0] = 1;
            rowY = line->y;
            top = 18.0f + rowY;
            if (!(top < 100.0f) && !((float)mgScreenHeight < top)) {
                if (info[row]->state != 0) {
                    u_long seconds;
                    u_long hours;
                    int tens;
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
                    static char *space = " ";
                    hundreds = hours / 100;
                    if (CheckNowEurope() != 0) {
                        if (hundreds == 0) {
                            strcpy(hoursText, space);
                        } else {
                            sprintf(hoursText, "%d", hundreds);
                        }
                        if (tens == 0 && hundreds == 0) {
                            strcat(hoursText, space);
                        } else {
                            sprintf(digitText, "%d", tens % 10);
                            strcat(hoursText, digitText);
                        }
                        sprintf(timeText, "%s%d:%d%d", hoursText, hours % 10, minutes / 10,
                                minutes % 10);
                    } else {
                        if (hundreds == 0) {
                            strcpy(timeText, space);
                        } else {
                            strcpy(timeText, GetMenuBigNum((int)hundreds));
                        }
                        if (tens == 0 && hundreds == 0) {
                            strcat(timeText, space);
                        } else {
                            strcat(timeText, GetMenuBigNum(tens));
                        }
                        strcat(timeText, GetMenuBigNum((int)(hours % 10)));
                        strcat(timeText, ":");
                        strcat(timeText, GetMenuBigNum((int)(minutes / 10)));
                        strcat(timeText, GetMenuBigNum((int)minutes));
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
    SaveIconSet icons = {{
        {"dc2_ic.ico"},
        {"dc2_ic_c.ico"},
        {"dc2_ic_d.ico"}
    }};

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
    memcpy(MenuMapInfoSave, &GetSaveData()->map_no, 0xC);
    int saved_dungeon = *(int *) ((u8 *) GetSaveData() + kDungeonNoOffset);
    MenuMapInfoSave_DngNo = saved_dungeon;

    if (0 <= dungeon) {
        short     *map_info = &GetSaveData()->map_no;
        CSaveData *save_data = GetSaveData();
        short      previous = *map_info;
        save_data->prev_map_no = previous;
        map_info = &GetSaveData()->map_no;
        *map_info = GetDngMapNo(dungeon);
        saved_dungeon = *(int *) ((u8 *) GetSaveData() + kDungeonNoOffset);
        MenuMapInfoSave_DngNo = saved_dungeon;
        *(int *) ((u8 *) GetSaveData() + kDungeonNoOffset) = dungeon;
    }
}

void ResetMapInfo() {
    memcpy(&GetSaveData()->map_no, MenuMapInfoSave, 0xC);
    short dungeon_no = MenuMapInfoSave_DngNo;
    *(int *) ((u8 *) GetSaveData() + kDungeonNoOffset) = dungeon_no;
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
        script_size = LoadFileMenu("save.pac", (u_long128 *) pack, 1);
        blocks = (script_size & 0xF) != 0 ? (script_size >> 4) + 1 : script_size >> 4;
        SaveMenuStack.Alloc(blocks);
        mgTexManager.EnterIMGFile((u_char *) GetPackFile((unsigned int *) pack, "img.img", NULL), SaveMenuPtr->tex_block[1],
                                  NULL, NULL);
        mgTexManager.EnterIMGFile((u_char *) GetPackFile((unsigned int *) pack, "frametex.img", NULL), SaveMenuPtr->tex_block[1],
                                  NULL, NULL);
        Tex_SaveFile = mgTexManager.GetTexture("save", -1);
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
        char *data = (char *) GetPackFile((unsigned int *) pack, "save.cfg", &data_size);
        MenuDataAnalyze(data, data_size, &SaveMenuStack);
        SaveMenuPtr->script = (char *) GetPackFile((unsigned int *) pack, "save_com.cfg", &SaveMenuPtr->script_size);
        (MenuPosData)->AttachCommonTexInfo();
        MenuPosData->ResetTextureBlockNo("save", SaveMenuPtr->tex_block[1]);
        MenuPosData->ResetTextureInfoAll();
        SaveMenuPtr->title_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("TITLE");
        SaveMenuPtr->slot_form[0] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("SLOT1");
        SaveMenuPtr->slot_form[1] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("SLOT2");
        SaveMenuPtr->cursor_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("CURSOR");
        SaveMenuPtr->list_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("LIST");
        SaveMenuPtr->scrlbar_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("SCRLBAR");
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
            menu_font.SetStr("MODE STATE : LOAD");
            menu_font.SetPos(0x14, 0x28);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        } else {
            menu_font.SetStr("MODE STATE : SAVE");
            menu_font.SetPos(0x14, 0x28);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        }

        sprintf(text, "SAVEFILE TOTALSIZE : %d K\n", MemoryCardPtr->GetSaveDataSize(0) / 1024);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x3C);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        sprintf(text, "          SAVEDATA : %d K\n", 0x196);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x50);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        sprintf(text, "         ALBUMDATA : %d K\n", MemoryCardPtr->GetSaveDataSize(5));
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x64);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        sprintf(text, "          ICONDATA : %d K\n", MemoryCardPtr->GetIconDataSize() / 1024);
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

        sprintf(text, "Slot 0\nType:%d\nformat:%d\nclusta%d\n", card->type, card->formatted, card->free_size);
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

        if (GetNowLoopNo() == 2) {
            GetSubGameSaveData()->GetSphidaData()->EnterScore();
        }
    }

    card = new (SaveMenuStack.Alloc(0x112)) CMemoryCardManager;

    MemoryCardPtr = card;
    MemoryCardPtr->Initialize(NULL);
    MemoryCardPtr->SetBuff_Album(NULL);
    MemoryCardPtr->InitForMC();
    MemoryCardPtr->port = 0;
    MemoryCardPtr->SetFuncNo(0);

    sub_game = new (SaveMenuStack.Alloc(0x549)) CSubGameData;

    MemoryCardPtr->sub_game_data = sub_game;
    SaveMenuStack.Align64();
    SubGameMCPort = 0;
    SubGameSaveBlock[0] = tex_block[0];
    SubGameSaveBlock[1] = tex_block[1];
    SubGameSaveBlock[2] = tex_block[2];
    pack = (u8 *) (SaveMenuStack.stack + SaveMenuStack.stack_used);
    script_size = LoadFileMenu("subsave.pac", (u_long128 *) pack, 1);
    blocks = (script_size & 0xF) != 0 ? (script_size >> 4) + 1 : script_size >> 4;
    SaveMenuStack.Alloc(blocks);
    u_char            *textures = (u_char *) GetPackFile((unsigned int *) pack, "img.img", NULL);
    mgCTextureManager *texture_manager = &mgTexManager;

    if (textures != NULL) {
        texture_manager->EnterIMGFile(textures, SubGameSaveBlock[0], NULL, NULL);
    }

    SubGameSaveCFGBuffer = (char *) GetPackFile((unsigned int *) pack, "save_com.cfg", &SubGameSaveCFGBufferSize);
    Tex_SaveFile = texture_manager->GetTexture("save", -1);
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

    if (GetNowLoopNo() == 2) {
        MenuMainScene->fade.FadeIn(0x28);
    }

    SubGameOmakeTempBuffer = (char *) SaveMenuStack.Alloc(0x1900);
    SubSaveTileXY = 0;
    SubTrueTotalSaveFileSize = MemoryCardPtr->GetSaveDataSize(9);
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
            if (GetNowLoopNo() == 2) {
                sub_game->PlayEnable(1, 1);
            }

            if (GetNowLoopNo() == 1) {
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
template <typename T> static inline T Ident(T v) { return v; }
static inline int &SubGameFileExists(CMemoryCardManager *manager) {
    return manager->file_exists;
}
int SubGameSaveKey(void) {
    MC_CARD_INFO *card;
    u32 stepResult;
    int pushed;
    CDC2Mes *window;
    int next;
    int cursor;
    int pressed;
    int answer;
    int slot;
    int slotNo;

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
        case - 1:
            break;
        case SUB_SAVE_SLOT_SELECT:
            pressed = ConvertCheckPushButton(pushed);
            if (pressed & 2) {
                MenuSePlay(5);
                if (GetNowLoopNo() == 3) {
                    next = SUB_SAVE_QUIT_ASK;
                }
                if (GetNowLoopNo() == 1 || GetNowLoopNo() == 2) {
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
                SubGameCFGAnalyze("OM_PH1");
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
                SubGameCFGAnalyze("OM_ISSAVE");
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_WRITING:
                if (window->mes_no != 0xC5C) {
                    SubGameCFGAnalyze("OM_NEWSAVE");
                }
                MemoryCardPtr->SetFuncNo(MC_FUNC_SAVE_OMAKE);
                break;
            case SUB_SAVE_WRITE_DONE:
                SubGameCFGAnalyze("OM_SAVEEND");
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
                SubGameCFGAnalyze("OM_ISNEWSAVE");
                int values[2] = { 0, 0 };
                values[0] = slotNo;
                values[1] = SubCheckTotalSaveFileSize;
                window->SetMsgVolumeNo(values, 2);
                break;
            case SUB_SAVE_DIR_MAKING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_MAKE_OMAKE_DIR);
                SubGameCFGAnalyze("OM_NEWSAVE");
                break;
            case SUB_SAVE_FORMAT_ASK:
                SubGameCFGAnalyze("OM_ISFORMAT");
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_FORMATTING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_FORMAT);
                SubGameCFGAnalyze("OM_FORMAT");
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_NO_DATA:
                SubGameCFGAnalyze("OM_NOTFORMAT");
                break;
            case SUB_SAVE_LOAD_ASK:
                SubGameCFGAnalyze("OM_ISLOAD");
                window->SetMsgVolumeNoOne(slotNo);
                break;
            case SUB_SAVE_LOADING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_LOAD_OMAKE);
                window->MsgPreset(0x12, LanguageCode);
                window->SetAbsPos(5);
                window->MakeMsg(0xC5D);
                break;
            case SUB_SAVE_LOAD_DONE:
                SubGameCFGAnalyze("OM_LOADEND");
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
                    int values[2] = { 0, 0 };
                    values[0] = slotNo;
                    values[1] = SubCheckTotalSaveFileSize;
                    window->SetMsgVolumeNo(values, MES_VALUE_MAX);
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

// Uninitialised data (.bss)
/**
 *
 * Map information saved while the save menu temporarily changes the active map.
 *
 */
u8 MenuMapInfoSave[0xC];
