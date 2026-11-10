#include "common.h"
#include "mw_runtime.h"

#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "charasetup.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "dngmenu.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "log/game_output.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "memcard.hpp"
#include "memory/tracked_copy.hpp"
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
#include "text/bounded.hpp"
#include "userdata.hpp"

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
static short manual_boot_event_no[50] = {
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 104, 108, 277, 277, 105, 105, 207, 207,
    207, 207, 220, 48, SAVE_FLAG_FISHING_CONTEST_UNLOCKED, 314, 314, 250, 250, 250,
    250, 250, 250, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, SAVE_FLAG_FINNY_FRENZY_UNLOCKED, -1, -1, -1, -1};

/**
 *
 * Map names treated as boss areas when the manual menu pauses dungeon music.
 *
 */
static char *submap_table_1022[22] = {
    "s06", "d01b01", "d02b01", "d02b03", "s17", "s56", "d03b01",
    "d03b02", "s19", "s20", "d05b01", "s52", "s54", "s61",
    "s62", "s63", "s69", "s13", "s14", "s15", "s16",
    nullptr};

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
    "d01f01", "d02f01", "d03f01", "d04f01", "d05f01", "d06f01", "d07f01"};

/**
 *
 * Names of the three save-menu scrollbar parts.
 *
 */
static char *b_2715[3] = {
    "bar0", "bar1", "bar2"};

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
float config_option_num_i = 16.0f;

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
 * Step of the battle music volume while a manual movie plays. @see MovieBattleBGMStep
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
 * What the mini-game save menu does. @see SubGameSaveMode
 *
 */
static signed char SubGameSaveOrLoad;

/**
 *
 * Current phase of the mini-game save or load. @see SubGameSavePhase
 *
 */
static short SubGameSaveOrLoadPhase;

/**
 *
 * Non-zero once the mini-game save menu is closing.
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

void dc2::menu::ResetSaveMenuManager() {
    dc2::mc::RetireManager(MemoryCardPtr);
}

/**
 *
 * Active save and load menu.
 *
 */
CSaveMenuClass *SaveMenuPtr;

/**
 *
 * Active option menu.
 *
 */
CMenuOption *CMenuOptionPtr;

/**
 *
 * Active manual menu.
 *
 */
CManualMenu *CManualPtr;

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

void InitMenuReturnMsg(mgCMemory *stack) {
    CDC2Mes                *window = {};
    dc2::text::MessageTable system_mes{};
    ClsMes                 *mes = {};
    int                     width = {};
    int                     height = {};

    MenuReturnMsg = nullptr;

    if (LanguageCode > LANG_JAPANESE) {
        window = new (stack->Alloc((sizeof(CDC2Mes) + 15) / 16 + 2)) CDC2Mes;
        MenuReturnMsg = window;
        MenuReturnMsg->texture_block = MenuArg.mes_tex_block;
        MenuReturnMsg->buff = nullptr;
        system_mes = GetSystemMesBuffer();
        MenuReturnMsg->SetMessData(system_mes, GetMenuMainMessageBuffer());
        MenuReturnMsg->MsgPreset(3);
        MenuReturnMsg->ClsMes::mes_no = -1;
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

    MenuReturnMsgDrawFlag = false;
}

void SetMenuReturnMsgCtrl(int show) {
    MenuReturnMsgDrawFlag = show != 0;

    if (LanguageCode == LANG_JAPANESE) {
        MenuReturnMsgDrawFlag = false;
    }

    if (MenuReturnMsg == nullptr) {
        MenuReturnMsgDrawFlag = false;
    }
}

void DrawMenuReturnMsg() {
    if ((MenuReturnMsgDrawFlag) && (MenuReturnMsg != nullptr)) {
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
        MenuReturnMsg->StepMsg();
        MenuReturnMsg->DrawMsg();
    }
}

int CheckOmakeVtuto(int entry) {
    if (OmakeFlag == 1) {
        if (GetNowLoopNo() == LOOP_DUNGEON) {
            if (entry == 0x23 || entry == 0x24) {
                return true;
            }
        }
    }

    return false;
}

void InitMnOnePictTex() {
    MnOnePictTex[0] = nullptr;
    MnOnePictTex[1] = nullptr;
    MnOnePictTex[2] = nullptr;
    MnOnePictTex[3] = nullptr;
    MnOnePictTex[4] = nullptr;
    MnOnePictTex[5] = nullptr;
    MnOnePictTex[6] = nullptr;
    MnOnePictTex[7] = nullptr;
}

void MenuManualInit(mgCMemory *memory, int *tex_block, int open_type) {
    CManualMenu            *menu = {};
    u_int                  *pack = {};
    u_char                 *menu_data = {};
    int                     menu_data_size = {};
    dc2::text::MessageTable main_messages{};
    CDC2Mes                *window = {};
    int                     list = {};
    int                     item = {};
    int                     entry = {};
    int                     number = {};
    int                     unlocked = {};
    int                     vtuto = {};
    int                     map_no = {};
    int                     i = {};
    int                     free_size = {};
    int                     block = {};
    signed char            *list_tbl = {};

    free_size = memory->stGetRest();
    StaticMenuLocalStack.stShareBuffer(*memory, std::span(memory->stGetTop(), static_cast<std::size_t>(free_size)));
    ManualMovie = dc2::memory::NewObject<CMovie>(StaticMenuLocalStack);
    if (ManualMovie == nullptr) {
        std::exit(EXIT_FAILURE);
    }

    menu = dc2::memory::NewObject<CManualMenu>(StaticMenuLocalStack);
    if (menu == nullptr) {
        std::exit(EXIT_FAILURE);
    }

    CManualPtr = menu;
    menu->SetTexBlock(tex_block);
    InitMnOnePictTex();
    pack = reinterpret_cast<u_int *>(memory->stack);
    block = CManualPtr->tex_block[0];
    mgTexManager.DeleteBlock(block);
    mgTexManager.EnterIMGFile(reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "op_bg.json", nullptr)), block, nullptr, nullptr);
    block = CManualPtr->tex_block[1];
    mgTexManager.DeleteBlock(block);
    mgTexManager.EnterTexture(block, "manumovieworkdm", nullptr, 0x100, 0x200, 8, nullptr, 0, 0);
    ManualMovieTex = mgTexManager.EnterTexture(block, "manumoviework", nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0, 0);
    menu_data = reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "manual.cfg.json", &menu_data_size));

    if (menu_data != nullptr) {
        MenuDataAnalyze(reinterpret_cast<char *>(menu_data), menu_data_size, &StaticMenuLocalStack);
    }

    StaticMenuLocalStack.Align64();
    free_size = StaticMenuLocalStack.stGetRest();
    StaticMenuLocalStack2.stShareBuffer(StaticMenuLocalStack, std::span(StaticMenuLocalStack.stGetTop(), static_cast<std::size_t>(free_size)));
    AttachMessageForm();
    LocalMenuBGForm = MenuPosData->GetFormInfo("op_bg");
    LocalMenuClipForm = MenuPosData->GetFormInfo("clip0");
    CManualPtr->script = reinterpret_cast<char *>(AssetDirectoryRead(pack, "manual_com.cfg.json", &CManualPtr->script_size));
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

        if (LanguageCode >= LANG_FRENCH) {
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
            vtuto = false;

            if (CheckOmakeVtuto(number)) {
                vtuto = true;
            }

            if (unlocked || vtuto) {
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

    if (battle_area != nullptr) {
        Movie_BossFlag = battle_area->boss_map;
    }

    MovieBgmBattleCheckStopFlag = 0;

    if (Movie_DungeonFlag == 1 && Movie_BossFlag == 0) {
        map_no = MenuMainScene->now_map_no;

        for (i = 0; submap_table_1022[i] != nullptr; i++) {
            if (map_no == SearchMapNo(submap_table_1022[i])) {
                Movie_BossFlag = 1;
            }
        }
    }

    MenuMainFrameModeSet(MENU_MAIN_FRAME_LEAVE_UP, true);
    MovieBattleBGMPhase = MOVIE_BATTLE_BGM_IDLE;
}

int MenuManualKey() {
    return CManualPtr->KeyStep();
}

void MenuManualDraw() {
    CManualMenu       *menu = {};
    CUserDataManager  *user_data = {};
    u_long128         *effect_buffer = {};
    u_long128         *buffer = {};
    mgCTexture        *picture = {};
    int                closed = {};
    int                is_town = {};
    int                attribute = {};
    int                chr_no = {};
    CActionChara      *chara = {};
    mgCTextureManager *textures = {};

    menu = CManualPtr;
    closed = false;

    switch (menu->key_arg_no) {
        case MANUAL_STEP_PLAY:
        case MANUAL_STEP_CLOSE:
        case MANUAL_STEP_END:
            textures = &mgTexManager;

            if (menu->pict_mode) {
                picture = MnOnePictTex[menu->pict_page];

                if (picture != nullptr) {
                    textures->ReloadTexture(picture->block, (sceVif1Packet *) nullptr);
                    PrimQuad(picture, mgRect<int>(0, 0, 0x200, mgScreenHeight), mgRect<int>(0, 0, 0x200, 0x1A0), 0x80, 0x80, 0x80, 0x80);
                    DrawMenuFillBox(35.0f, static_cast<float>(mgScreenHeight - 0x28), static_cast<float>(fillw_1125[LanguageCode]),
                                    30.0f, 0x40, 0, 0, 0);

                    if (MenuDCMsg[7] != nullptr) {
                        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
                        MenuDCMsg[7]->SetPutPos(0x28, mgScreenHeight - 0x24, -1, -1);
                        MenuDCMsg[7]->StepMsg();
                        MenuDCMsg[7]->DrawMsg();
                    }

                    if (CManualPtr->key_arg_no == MANUAL_STEP_END) {
                        closed = true;
                    }
                }
            } else {
                ManualMovie->SwitchThread();
                textures->ReloadTexture(CManualPtr->tex_block[1], (sceVif1Packet *) nullptr);
                CPreSprite prim;
                prim.Initialize(nullptr, nullptr);
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
                textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
                MovieCCDraw();

                if (CManualPtr->key_arg_no == MANUAL_STEP_END) {
                    ManualMovie->Term();
                    ManualMovie->SwitchThread();
                    sceGsSyncV(0);
                    sceGsSyncV(0);
                    sceGsSyncV(0);
                    user_data = GetUserDataMan();
                    StaticMenuLocalStack2.stReset();
                    buffer = StaticMenuLocalStack2.stGetTop();
                    is_town = static_cast<u_char>(!GetMenuLoopType());
                    textures->DeleteBlock(MenuArg.chara_tex_block);
                    MenuArg.chara_stack->stReset();
                    SetupMainUnit(dc2::memory::RemainingBytes(StaticMenuLocalStack2), MenuArg.chara_stack, MenuArg.base_chara_stack,
                                  MenuArg.chara_tex_block, GetMainScene(), user_data,
                                  user_data->active_chr_no, is_town);
                    MenuCharaSoundLoad(&StaticMenuLocalStack2, user_data->active_chr_no, 0);
                    chara = static_cast<CActionChara *>(GetMainScene()->GetCharacter(0));
                    MenuCharaSoundEnter(GetMainScene(), chara, 1);

                    if (user_data->active_chr_no == USER_CHARA_MONSTER) {
                        StaticMenuLocalStack2.stReset();
                        MonsterEffectRead(&StaticMenuLocalStack2, user_data->monster_id, 0);
                        StaticMenuLocalStack2.Align64();
                        StaticMenuLocalStack2.Alloc(0x280);
                        effect_buffer = StaticMenuLocalStack2.stGetTop();
                        MonsterEffectEnter(GetMainScene(), effect_buffer, MONSTER_EFFECT_TEX_BLOCK);
                    }

                    if (!is_town) {
                        chara->effect_man = FxScriptMan;
                        chr_no = GetUserDataMan()->active_chr_no;
                        attribute = GetUserDataMan()->GetCharaStatusAttirbute(chr_no);

                        if ((chr_no == USER_CHARA_MONICA || chr_no == USER_CHARA_MAX) && (attribute & (CHARA_STATUS_STOP | CHARA_STATUS_STONE))) {
                            chara->SetHold();
                        }
                    }

                    chara->Step();
                    SetMenuEtcFlag(MENU_ETC_FLAG_CHARA_RELOAD);
                    MenuMainTextureReadBuf.stReset();
                    LoadFileMenu("mb2.pac", dc2::memory::RemainingBytes(MenuMainTextureReadBuf), MENU_FILE_LOAD_DIRECT);
                    MenuBaseTextureReEnter();
                    closed = true;
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
        CMenuFont menu_font;
        menu_font.DrawDirect("(#):All Open", 0x12C, 0xA);
    }

    if (closed) {
        SetMenuFrameRate(1);
        StaticMenuLocalStack2.stReset();
        MenuMainScene->StopBGM(0);
        sceGsSyncV(0);
        sceGsSyncV(0);
        sceGsSyncV(0);
        CSnd.SndInReverb(1);
        MenuMainScene->LoadBGM(CManualPtr->bgm_status.load_no,
                               dc2::memory::RemainingBytes(StaticMenuLocalStack2));
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
        CManualPtr->key_arg_no = MANUAL_STEP_SELECT;
    }
}

int CManualMenu::KeyStep() {
    int                finished = {};
    int                move_type = {};
    mgCTextureManager *textures = {};
    int                frame_end = {};
    int                pushed = {};
    mgCMemory         *chara_stack = {};
    int                keys = {};
    int                prev_select = {};
    int                pressed = {};
    int                unlocked = {};
    int                viewable = {};
    int                i = {};
    int                movie_no = {};
    int                prev_page = {};
    int                close_now = {};
    int                stop_env = {};
    u_int              data_size = {};
    int                blocks = {};
    int                event_no = {};
    int                file_size = {};
    u_char            *img_data = {};
    u_long128         *buffer = {};
    int               *common_mode = {};
    CScene            *scene = {};
    DNG_BATTLE_AREA   *area = {};
    int                battle_stop = {};
    u_int              snd_id = {};

    finished = false;
    move_type = 2;
    common_mode = GetCommonMenuModeID();

    if (mode == MENU_ASK_MODE_CLOSE) {
        move_type = 0;
    }

    MenuPosData->StepMainMenuIconMove(common_mode, MENU_MODE_MANUAL, move_type);
    frame_end = GetMenuMainFrameEndFlag();

    switch (mode) {
        case MENU_ASK_MODE_OPEN:
            if (ReadBGSync() == 0 && frame_end != 0) {
                MenuCommonInfo->key_enable = true;
                MenuCommonInfo->CursorFadeIn(10.0f, 1);
                MenuCommonInfo->SetMoveMethod(2);
                mode = MENU_ASK_MODE_NONE;
                cursor_jump = true;
                MovieViewFlag = true;
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            if (frame_end != 0) {
                ExeScript("\x8FI\x97\xB9\x8F\x88\x97\x9D");
                MenuCommonInfo->SetMoveMethod(2);
                finished = true;
            }

            break;
        case MENU_ASK_MODE_NONE:
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
                                       10, MENU_CURSOR_LIMIT_CLAMP);

                    if (prev_select != select) {
                        MenuSePlay(SYSTEM_SE_CURSOR);
                    }

                    pressed = ConvertCheckPushButton(pushed);

                    if (pressed & MENU_PUSH_BUTTON_DECIDE) {
                        unlocked = CheckBitFlagMenu(manual_boot_event_no[select]);
                        viewable = false;

                        if (CheckOmakeVtuto(select)) {
                            viewable = true;
                        }

                        if (MovieViewFlag && (unlocked || viewable)) {
                            key_arg_no = MANUAL_STEP_FADE_OUT;
                            FadeOutMenu(0x3C, 0.0f);
                            MenuSePlay(SYSTEM_SE_DECIDE);
                            MovieBattleBGMPhase = MOVIE_BATTLE_BGM_MUTE;
                        } else {
                            MenuSePlay(SYSTEM_SE_CANCEL);
                        }
                    } else if (pressed & MENU_PUSH_BUTTON_CANCEL) {
                        ReturnMenuIntern(0);
                        MenuMainFrameModeSet(MENU_MAIN_FRAME_RETURN_UP, false);
                        MenuCommonInfo->SetMoveMethod(-1);
                        ExeScript("PREEND");
                        mode = MENU_ASK_MODE_CLOSE;
                    } else if (menu_debug_flag != 0 && (pressed & MENU_PUSH_BUTTON_SQUARE)) {
                        for (i = 0; i < (event_no = manual_boot_event_no[i]); i++) {
                            GetSaveData()->SetBitFlag(event_no, 1);
                        }
                    }

                    break;
                case MANUAL_STEP_FADE_OUT:
                    if (FadeCheckMenu() != 0) {
                        CSnd.SndInReverb(0);
                        stop_env = true;

                        if (Movie_DungeonFlag != 0 && OmakeFlag == 0 && Movie_BossFlag != 1) {
                            stop_env = false;
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
                        StaticMenuLocalStack2.stClearUsed();
                        StaticMenuLocalStack2.stSetLocked(false);
                        sndStep(2.0f);

                        if (select == 0x18 || select == 0x19) {
                            MenuMainScene->LoadBGM(0x97, dc2::memory::RemainingBytes(StaticMenuLocalStack2));
                        } else {
                            MenuMainScene->LoadBGM(0xC0, dc2::memory::RemainingBytes(StaticMenuLocalStack2));
                        }

                        sndStep(2.0f);
                        MenuMainScene->PlayBGM(0, -1, 1.0f);
                        pict_mode = false;
                        movie_no = select + 1;
                        textures = &mgTexManager;

                        if (movie_no == 0x16 || movie_no == 0x17) {
                            data_size = 0;
                            buffer = StaticMenuLocalStack2.stack + StaticMenuLocalStack2.stack_used;

                            if (movie_no == 0x16) {
                                data_size = LoadFileMenu("mntx.pac", dc2::memory::AvailableFrom(StaticMenuLocalStack2, buffer), MENU_FILE_LOAD_DIRECT);
                            }

                            if (movie_no == 0x17) {
                                data_size = LoadFileMenu("mntx2.pac", dc2::memory::AvailableFrom(StaticMenuLocalStack2, buffer), MENU_FILE_LOAD_DIRECT);
                            }

                            if ((data_size & 0xF) != 0) {
                                blocks = (data_size >> 4) + 1;
                            } else {
                                blocks = data_size >> 4;
                            }

                            StaticMenuLocalStack2.Alloc(blocks);
                            img_data = reinterpret_cast<u_char *>(AssetDirectoryRead(reinterpret_cast<u_int *>(buffer), "mntx.json", nullptr));
                            textures->DeleteBlock(tex_block[2]);
                            textures->DeleteBlock(tex_block[3]);
                            textures->EnterIMGFile(img_data, tex_block[2], nullptr, nullptr);
                            pict_mode = true;
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
                            if (GetUserDataMan()->active_chr_no == USER_CHARA_MONSTER) {
                                DeleteMonsterEffect();
                            }

                            if (movie_no == 0x15) {
                                movie_no = 0x2C;
                            } else if (movie_no >= 0x18) {
                                movie_no = select - 2;
                            }

                            textures->ReloadTexture(tex_block[1], (sceVif1Packet *) nullptr);
                            chara_stack = MenuArg.chara_stack;
                            chara_stack->stClearUsed();
                            chara_stack->stSetLocked(false);
                            chara_stack->Align64();
                            buffer = chara_stack->stack + chara_stack->stack_used;
                            file_size = 0;
                            char name[0x40];
                            std::snprintf(name, sizeof(name), "menu/%d/help.cfg.json", LanguageCode);
                            LoadFile2(name, dc2::memory::AvailableFrom(*chara_stack, buffer), &file_size, 0);
                            chara_stack->Alloc(file_size / 16 + 1);
                            chara_stack->Align64();
                            MovieCCInit(reinterpret_cast<char *>(buffer), file_size, select + 1);
                            char movie_name[0x28];

                            if (movie_no > 0x16) {
                                std::snprintf(movie_name, sizeof(movie_name), "TUTO2\\VTUTO%d.mp4", movie_no);
                            } else {
                                std::snprintf(movie_name, sizeof(movie_name), "TUTO\\VTUTO%d.mp4", movie_no);
                            }

                            ManualMovie->Load(movie_name, 0x200, 0x1A0, true, false);
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
                    } else if (pict_mode) {
                        prev_page = pict_page;

                        if (keys & MENU_SELECT_KEY_LEFT) {
                            pict_page = prev_page - 1;
                        }

                        if ((keys & MENU_SELECT_KEY_RIGHT) || (pushed & MENU_PUSH_BUTTON_DECIDE)) {
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
                            MenuSePlay(SYSTEM_SE_CURSOR);
                        }

                        if ((pushed & MENU_PUSH_BUTTON_CANCEL) != 0) {
                            FadeOutMenu(0x1E, 0.0f);
                            key_arg_no = MANUAL_STEP_CLOSE;
                            MenuSePlay(SYSTEM_SE_CANCEL);
                        }
                    } else {
                        close_now = -1;

                        if (ManualMovie->EndCheck() != 0 || (pushed & MENU_PUSH_BUTTON_START) || (pushed & MENU_PUSH_BUTTON_CANCEL)) {
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
                        MovieBattleBGMPhase = MOVIE_BATTLE_BGM_FADE_IN;
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
                case MOVIE_BATTLE_BGM_IDLE:
                    break;
                case MOVIE_BATTLE_BGM_MUTE:
                    MoviePreBattleBGMVol_Save = area->battle_bgm_vol;
                    sndSetSeVolf(snd_id, 0, 0.0f, 0);
                    MovieBattleBGMPhase++;
                    break;
                case MOVIE_BATTLE_BGM_FADE_OUT:
                    CalcMenuAdd(&MoviePreBattleBGMVol, -0.025f, 0.0f);
                    sndSetSeVolf(snd_id, 0, MoviePreBattleBGMVol, 0);
                    break;
                case MOVIE_BATTLE_BGM_FADE_IN: {
                    float increment = 0.033333335f;
                    CalcMenuAdd(&MoviePreBattleBGMVol, increment, MoviePreBattleBGMVol_Save);
                    sndSetSeVolf(snd_id, 0, MoviePreBattleBGMVol, 0);
                    break;
                }
                case MOVIE_BATTLE_BGM_RESTORE:
                    sndSetSeVolf(snd_id, 0, MoviePreBattleBGMVol_Save, 0);
                    break;
            }
        }
    }

    return finished;
}

void CManualMenu::CalcTex() {
    CMenuPosDataForm   *bg_form = {};
    int                 slide_in = {};
    int                 slide_in_flag = {};
    float              *left_top = {};
    int                 xy[2];
    float               speed = {};
    float               target = {};
    int                 column_shift = {};
    int                 shifted = {};
    signed char        *list_tbl = {};
    int                 list = {};
    CDC2Mes            *mes = {};
    CMenuPosDataForm   *panel = {};
    int                 item_pos[10][2];
    int                 item = {};
    int                 first_y = {};
    CMenuPosDataForm   *form = {};
    MENUFORMPARTS_TYPE *bar[3];
    int                 scroll_range[2];
    int                 visible_top = {};

    bg_form = LocalMenuBGForm;

    if (bg_form == nullptr) {
        return;
    }

    slide_in = false;
    slide_in_flag = false;
    left_top = GetMenuMainFrameLeftTopPos(0);
    xy[0] = fptosi(left_top[0]);
    xy[1] = fptosi(480.0f + left_top[1]);

    if (GetMenuMainFrameEndFlag() == 0) {
        slide_in = true;
        slide_in_flag = true;
        bg_form->x = static_cast<float>(xy[0]);
        bg_form->y = static_cast<float>(xy[1]);
    } else {
        bg_form->x = static_cast<float>(xy[0]);
    }

    bg_form->GetPutPosXY("base_msg", xy[0], xy[1]);
    speed = 3.5f;

    if (mode == MENU_ASK_MODE_CLOSE || mode == MENU_ASK_MODE_OPEN) {
        speed = 1.0f;
    }

    target = static_cast<float>(xy[1] - top * 24);
    CalcMenu1(target, &list_y, speed, speed, 0);

    if (static_cast<float>(xy[1]) < list_y) {
        list_y = target;
    }

    xy[1] = fptosi(list_y);
    column_shift = 0;
    shifted = false;
    list_tbl = manual_list_mesclstbl;

    for (list = 0; list < 5; list++) {
        first_y = xy[1];
        mes = MenuDCMsg[list_tbl[list]];
        panel = MenuMesForm[list_tbl[list]];

        for (item = 0; item < 10; item++) {
            item_pos[item][0] = xy[0] + column_shift;
            item_pos[item][1] = xy[1];
            xy[1] += 24;

            if (CheckNowEurope() != 0 && !shifted && item >= 8) {
                column_shift = 8;
                shifted = true;
            }
        }

        mes->SetMsgItemPos(&item_pos[0][0], 10);

        if (xy[1] < 0x48 || first_y > 0x186) {
            panel->draw_flag = false;
        } else {
            panel->draw_flag = true;
        }
    }

    bg_form->GetPutPosXY("info_msg", xy[0], xy[1]);
    form = MenuMesForm[3];

    if (form != nullptr) {
        form->x = static_cast<float>(xy[0]);
        form->y = static_cast<float>(xy[1]);
    }

    bar[0] = bg_form->GetPartInfo("bar0");
    bar[1] = bg_form->GetPartInfo("bar1");
    bar[2] = bg_form->GetPartInfo("bar2");
    bg_form->GetPutPosXY("scrlbase", item_pos[0][0], item_pos[0][1]);
    MenuPosData->GetEtcTblValue("manualbarwh", scroll_range[0], scroll_range[1]);

    if (!slide_in_flag) {
        visible_top = top;
        LocalFunc_AdjustScrlBar(bar, &item_pos[0][0], scroll_range,
                                visible_top, 46.0f, 10.0f, slide_in);
    }

    if (LocalMenuClipForm != nullptr) {
        LocalMenuBGForm->GetPutPosXY("msg_clip", xy[0], xy[1]);
        form = LocalMenuClipForm;
        form->x = static_cast<float>(xy[0]);
        form->y = static_cast<float>(xy[1]);
    }
}

void CManualMenu::CalcCursorPosition() {
    IntPair position = {0, 0};

    switch (key_arg_no) {
        case MANUAL_STEP_SELECT:
        case MANUAL_STEP_PLAY:
            break;
    }

    if (LocalMenuBGForm != nullptr) {
        LocalMenuBGForm->GetPutPosXY("base_msg", position.x, position.y);
    }

    position.x -= 50;
    position.y += (select - top) * 24;
    MenuCommonInfo->MenuPosStep(&position.x, nullptr);

    if (cursor_jump) {
        MenuCommonInfo->MenuSetPos(position.x, position.y);
        cursor_jump = false;
    }
}

int CMenuOption::KeyStep() {
    int finished = {};
    int move_type = {};
    int frame_end = {};
    int changed = {};
    int movement = {};
    int keys = {};
    int pushed = {};
    int prev_choice = {};

    finished = false;
    move_type = 2;

    if (mode == MENU_ASK_MODE_CLOSE) {
        move_type = 0;
    }

    if (MenuArg.open_type == MENU_OPEN_OPTION) {
        move_type = 2;
    }

    MenuPosData->StepMainMenuIconMove(GetCommonMenuModeID(), MENU_MODE_OPTION,
                                      move_type);
    frame_end = GetMenuMainFrameEndFlag();

    switch (mode) {
        case MENU_ASK_MODE_OPEN:
            if (step == 0 && ReadBGSync() == 0 && frame_end != 0) {
                GamePad__2.KeyLock(0);
                MenuCommonInfo->SetWakuType(0);
                MenuCommonInfo->SetMoveMethod(2);
                cursor_jump = true;
                mode = MENU_ASK_MODE_NONE;
                CBaseMenuClass::ExeScript("INITEND");

                if (MenuArg.open_type == MENU_OPEN_OPTION) {
                    CBaseMenuClass::ExeScript("TITLE_INITEND");
                    step = 1;
                    mode = MENU_ASK_MODE_OPEN;
                }
            }

            if (step == 1 && CBaseMenuClass::FadeCheckMenu() != 0) {
                step = 0;
                mode = MENU_ASK_MODE_NONE;
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            if (MenuArg.open_type == MENU_OPEN_OPTION) {
                if (CBaseMenuClass::FadeCheckMenu() != 0) {
                    return true;
                }

                break;
            }

            if (frame_end != 0) {
                CBaseMenuClass::ExeScript("\x8FI\x97\xB9\x8F\x88\x97\x9D");

                if (MenuConfigPtr != nullptr) {
                    dc2::log::PrintGame("cam_ctrl[0]  : %d\n", MenuConfigPtr->eye_reverse);
                    dc2::log::PrintGame("cam_ctrl[1]  : %d\n", MenuConfigPtr->rot_normal);

                    if (MenuConfigPtr->sound_mode != 0) {
                        CSnd.SetStereoMode(0);
                    } else {
                        CSnd.SetStereoMode(1);
                    }
                }

                MenuCommonInfo->SetMoveMethod(2);
                finished = true;
            }

            break;
        case MENU_ASK_MODE_NONE:
            changed = false;
            MenuCommonInfo->CheckSelectKey();
            pushed = MenuCommonInfo->CheckPushButton();
            keys = MenuCommonInfo->CheckLRKey();
            movement = MenuListSelectKeyCheck(keys, 9);

            if (MenuKeySelectCheck(movement, &select, &top, 0, fptosi(config_option_num_i), 9,
                                   MENU_CURSOR_LIMIT_CLAMP) != 0) {
                changed = true;
            }

            prev_choice = choice;

            if (keys & MENU_SELECT_KEY_LEFT) {
                choice = prev_choice - 1;
            }

            if (keys & MENU_SELECT_KEY_RIGHT) {
                choice += 1;
            }

            if (choice < 0) {
                choice = 0;
            }

            if (choice_num[select] <= choice) {
                choice = choice_num[select] - 1;
            }

            if (prev_choice != choice) {
                changed = true;
            }

            if (changed) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }

            switch (ConvertCheckPushButton(pushed)) {
                case MENU_PUSH_BUTTON_DECIDE:
                    if (select == OPTION_ITEM_CAPTIONS) {
                        config.caption_off = choice;
                    } else if (select == OPTION_ITEM_PAUSE_OVERLAY) {
                        config.pause_overlay_off = choice;
                    } else if (select == OPTION_ITEM_CAMERA_VERTICAL) {
                        config.eye_reverse = choice;
                    } else if (select == OPTION_ITEM_CAMERA_ROTATION) {
                        config.rot_normal = choice;
                    } else if (select != OPTION_ITEM_ANGER_COUNTER || config.enemy_hp != 1) {
                        *value[select] = choice;

                        if (select == OPTION_ITEM_ENEMY_HP && choice == 1) {
                            *value[OPTION_ITEM_ANGER_COUNTER] = 1;
                        }
                    }

                    UpdateOptionForm();
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    break;
                case MENU_PUSH_BUTTON_SQUARE:
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    InitSV_CONFIG_OPTION(&config);
                    UpdateOptionForm();
                    break;
                case MENU_PUSH_BUTTON_CANCEL:
                    mode = MENU_ASK_MODE_CLOSE;
                    dc2::memory::CopyTrackedBytes(MenuConfigPtr, &config, sizeof(config));
                    MenuCommonInfo->SetMoveMethod(-1);
                    MenuCommonInfo->SetWakuType(-1);

                    if (MenuArg.open_type == MENU_OPEN_OPTION) {
                        CBaseMenuClass::ExeScript("PREEND_T");
                    } else {
                        MenuMainFrameModeSet(MENU_MAIN_FRAME_RETURN_UP, false);
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
        int     row_no = {};
        int     choice_no = {};

        switch (mode) {
            case MENU_ASK_MODE_OPEN:
                if (MenuArg.open_type != MENU_OPEN_OPTION) {
                    break;
                }
            case MENU_ASK_MODE_NONE:
                row_no = select;
                choice_no = choice;

                if (row_no < 10) {
                    std::snprintf(name, sizeof(name), "INDEX0%d%d", row_no, choice_no);
                } else {
                    std::snprintf(name, sizeof(name), "INDEX%d%d", row_no, choice_no);
                }

                OptionButtonForm->GetPutPosXY(name, pos.x, pos.y);
                pos.x -= 2;
                pos.y -= 3;
                std::snprintf(name, sizeof(name), "op_waku%d", select);
                MenuPosData->GetEtcTblValue(name, size.x, size.y);
                MenuCommonInfo->SetWakuWH(0, size.x, size.y);
                MenuPosData->GetEtcTblValue("op_cursorlimmit", limit[0], limit[1]);
                if (LocalMenuBGForm != nullptr) {
                    int base[2];
                    LocalMenuBGForm->GetPutPosXY("base_msg", base[0], base[1]);
                    limit[1] = PortOptionCursorBottom(limit[1], pos.y, fptosi(list_y - 3.0f), base[1] - top * 24 - 3);
                }

                if (pos.y < limit[0]) {
                    pos.y = limit[0];
                }

                if (limit[1] < pos.y) {
                    pos.y = limit[1];
                }

                MenuCommonInfo->MenuPosStep(&pos.x, &velocity.x);
                break;
        }

        if (cursor_jump) {
            MenuCommonInfo->MenuSetPos(pos.x, pos.y);
            cursor_jump = false;
        }
    }
    return finished;
}

void CMenuOption::CalcTex() {
    CMenuPosDataForm   *bg_form = {};
    int                 slide_in = {};
    int                 slide_in_flag = {};
    float              *left_top = {};
    int                 xy[2];
    float               speed = {};
    float               target = {};
    signed char        *list_tbl = {};
    int                 list = {};
    CMenuPosDataForm   *mes_form = {};
    CMenuPosDataForm   *clip_form = {};
    int                 item_pos[10][2];
    int                 item = {};
    CMenuPosDataForm   *form = {};
    MENUFORMPARTS_TYPE *bar[3];
    int                 scroll_range[2];

    bg_form = LocalMenuBGForm;

    if (bg_form == nullptr) {
        return;
    }

    slide_in = false;
    slide_in_flag = false;
    left_top = GetMenuMainFrameLeftTopPos(0);
    xy[0] = fptosi(left_top[0]);
    xy[1] = fptosi(480.0f + left_top[1]);

    if (GetMenuMainFrameEndFlag() == 0) {
        slide_in = true;
        slide_in_flag = true;
        bg_form->x = static_cast<float>(xy[0]);
        bg_form->y = static_cast<float>(xy[1]);
    } else {
        bg_form->x = static_cast<float>(xy[0]);
    }

    bg_form->GetPutPosXY("base_msg", xy[0], xy[1]);
    speed = 3.5f;

    if (mode == MENU_ASK_MODE_CLOSE) {
        speed = 2.0f;
    }

    target = static_cast<float>(xy[1] - top * 24);
    CalcMenu1(target, &list_y, speed, speed, 0);

    if (static_cast<float>(xy[1]) < list_y) {
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

    if (form != nullptr) {
        xy[1] = fptosi(list_y - 3.0f);
        form->x = static_cast<float>(xy[0]);
        form->y = static_cast<float>(xy[1]);
    }

    bg_form->GetPutPosXY("info_msg", xy[0], xy[1]);
    mes_form = MenuMesForm[3];

    if (mes_form != nullptr) {
        mes_form->x = static_cast<float>(xy[0]);
        mes_form->y = static_cast<float>(xy[1]);
    }

    bar[0] = bg_form->GetPartInfo("bar0");
    bar[1] = bg_form->GetPartInfo("bar1");
    bar[2] = bg_form->GetPartInfo("bar2");
    bg_form->GetPutPosXY("scrlbase", item_pos[0][0], item_pos[0][1]);
    MenuPosData->GetEtcTblValue("manualbarwh", scroll_range[0], scroll_range[1]);

    if (!slide_in_flag) {
        LocalFunc_AdjustScrlBar(
            bar, &item_pos[0][0], scroll_range, top, config_option_num_f, 9.0f, slide_in);
    }

    if (LocalMenuClipForm != nullptr) {
        bg_form->GetPutPosXY("msg_clip", xy[0], xy[1]);
        clip_form = LocalMenuClipForm;
        clip_form->x = static_cast<float>(xy[0]);
        clip_form->y = static_cast<float>(xy[1]);
    }
}

void CMenuOption::DefaultButton(MENUFORMPARTS_TYPE **row) {
    int i = {};

    for (i = 0; i < OPTION_BUTTON_NUM; i++) {
        if (row[i] != nullptr) {
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
    SV_CONFIG_OPTION    *config = {};
    MENUFORMPARTS_TYPE **row = {};
    int                  i = {};
    int                  offset = {};
    MENUFORMPARTS_TYPE **loop_row = {};

    if (OptionButtonForm != nullptr) {
        config = &this->config;

        if (config != nullptr) {
            row = button[OPTION_ITEM_CURSOR_MEMORY];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->cursor_save]);
            }

            row = button[OPTION_ITEM_VIBRATION];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->vibration]);
            }

            row = button[OPTION_ITEM_MESSAGE_SPEED];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->message_speed]);
            }

            row = button[OPTION_ITEM_SOUND_MODE];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->sound_mode]);
            }

            row = button[OPTION_ITEM_TIME_SPEED];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->fast_time]);
            }

            loop_row = button[OPTION_ITEM_MINIMAP];

            if (loop_row != nullptr) {
                DefaultButton(loop_row);

                for (i = 0, offset = 0; i < OPTION_BUTTON_NUM; i++, offset += sizeof(MENUFORMPARTS_TYPE *)) {
                    if (config->map == i) {
                        EnableButton(*reinterpret_cast<MENUFORMPARTS_TYPE **>(reinterpret_cast<u8 *>(loop_row) + offset));
                    }
                }
            }

            row = button[OPTION_ITEM_DAMAGE_NUMBERS];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->damage_off]);
            }

            row = button[OPTION_ITEM_ENEMY_HP];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->enemy_hp]);
            }

            row = button[OPTION_ITEM_ANGER_COUNTER];

            if (row != nullptr) {
                DefaultButton(row);

                if (config->enemy_hp == 0) {
                    EnableButton(row[config->anger_counter]);
                }
            }

            row = button[OPTION_ITEM_UNK_9];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->unk_24]);
            }

            row = button[OPTION_ITEM_MONSTER_NAME];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->monster_name]);
            }

            row = button[OPTION_ITEM_DEPTH_OF_FIELD];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->dof_off]);
            }

            row = button[OPTION_ITEM_CAPTIONS];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->caption_off]);
            }

            row = button[OPTION_ITEM_PAUSE_OVERLAY];

            if (row != nullptr) {
                DefaultButton(row);
                EnableButton(row[config->pause_overlay_off]);
            }

            row = button[OPTION_ITEM_CAMERA_VERTICAL];

            if (LanguageCode > LANG_JAPANESE) {
                if (row != nullptr) {
                    DefaultButton(row);
                    EnableButton(row[config->eye_reverse]);
                }

                row = button[OPTION_ITEM_CAMERA_ROTATION];

                if (row != nullptr) {
                    DefaultButton(row);
                    EnableButton(row[config->rot_normal]);
                }
            }
        }
    }
}

void MenuOptionInit(mgCMemory *memory, int *tex_block, int open_type) {
    CMenuOption            *menu = {};
    u_int                  *pack = {};
    u_char                 *menu_data = {};
    int                     menu_data_size = {};
    dc2::text::MessageTable main_messages{};
    int                     block = {};
    mgCTextureManager      *textures = {};
    int                     option = {};
    int                     choice = {};
    int                     free_size = {};
    char                    prefix[0x20];
    char                    name[0x20];

    free_size = memory->stGetRest();
    StaticMenuLocalStack.stShareBuffer(*memory, std::span(memory->stGetTop(), static_cast<std::size_t>(free_size)));

    menu = new (StaticMenuLocalStack.Alloc((sizeof(CMenuOption) + 15) / 16 + 2)) CMenuOption;

    CMenuOptionPtr = menu;
    menu->SetTexBlock(tex_block);
    CMenuOptionPtr->select = 0;
    CMenuOptionPtr->top = 0;
    config_option_num_i = 14.0f;
    config_option_num_f = 14.0f;

    if (LanguageCode > LANG_JAPANESE) {
        config_option_num_i = 16.0f;
        config_option_num_f = 16.0f;
    }

    pack = reinterpret_cast<u_int *>(memory->stack);
    textures = &mgTexManager;
    block = CMenuOptionPtr->tex_block[0];
    textures->DeleteBlock(block);
    textures->EnterIMGFile(reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "op_bg.json", nullptr)), block, nullptr, nullptr);
    textures->EnterIMGFile(reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "option.json", nullptr)), block, nullptr, nullptr);

    if (MenuArg.open_type == MENU_OPEN_OPTION) {
        textures->EnterIMGFile(GetMenuMainIMGPtr(), block, nullptr, nullptr);
    }

    menu_data = reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "option.cfg.json", &menu_data_size));

    if (menu_data != nullptr) {
        MenuDataAnalyze(reinterpret_cast<char *>(menu_data), menu_data_size, &StaticMenuLocalStack);
    }

    AttachMessageForm();
    LocalMenuBGForm = MenuPosData->GetFormInfo("op_bg");
    LocalMenuClipForm = MenuPosData->GetFormInfo("clip0");
    OptionButtonForm = MenuPosData->GetFormInfo("Op_Switch");

    for (option = 0; option < OPTION_ITEM_MAX; option++) {
        if (option < 10) {
            std::snprintf(prefix, sizeof(prefix), "INDEX0%d", option);
        } else {
            std::snprintf(prefix, sizeof(prefix), "INDEX%d", option);
        }

        for (choice = 0; choice < OPTION_BUTTON_NUM; choice++) {
            CMenuOptionPtr->button[option][choice] = nullptr;

            if (OptionButtonForm != nullptr) {
                std::snprintf(name, sizeof(name), "%s%d", prefix, choice);
                CMenuOptionPtr->button[option][choice] = OptionButtonForm->GetPartInfo(name);
            }
        }
    }

    dc2::memory::CopyTrackedBytes(&CMenuOptionPtr->config, MenuConfigPtr, sizeof(CMenuOptionPtr->config));
    dc2::memory::CopyTrackedBytes(&CMenuOptionPtr->config_backup, MenuConfigPtr, sizeof(CMenuOptionPtr->config_backup));
    CMenuOptionPtr->script = reinterpret_cast<char *>(AssetDirectoryRead(pack, "opt_com.cfg.json", &CMenuOptionPtr->script_size));
    CMenuOptionPtr->value[OPTION_ITEM_CURSOR_MEMORY] = &CMenuOptionPtr->config.cursor_save;
    CMenuOptionPtr->value[OPTION_ITEM_VIBRATION] = &CMenuOptionPtr->config.vibration;
    CMenuOptionPtr->value[OPTION_ITEM_MESSAGE_SPEED] = &CMenuOptionPtr->config.message_speed;
    CMenuOptionPtr->value[OPTION_ITEM_SOUND_MODE] = &CMenuOptionPtr->config.sound_mode;
    CMenuOptionPtr->value[OPTION_ITEM_TIME_SPEED] = &CMenuOptionPtr->config.fast_time;
    CMenuOptionPtr->value[OPTION_ITEM_MINIMAP] = &CMenuOptionPtr->config.map;
    CMenuOptionPtr->value[OPTION_ITEM_DAMAGE_NUMBERS] = &CMenuOptionPtr->config.damage_off;
    CMenuOptionPtr->value[OPTION_ITEM_ENEMY_HP] = &CMenuOptionPtr->config.enemy_hp;
    CMenuOptionPtr->value[OPTION_ITEM_ANGER_COUNTER] = &CMenuOptionPtr->config.anger_counter;
    CMenuOptionPtr->value[OPTION_ITEM_UNK_9] = &CMenuOptionPtr->config.unk_24;
    CMenuOptionPtr->value[OPTION_ITEM_MONSTER_NAME] = &CMenuOptionPtr->config.monster_name;
    CMenuOptionPtr->value[OPTION_ITEM_DEPTH_OF_FIELD] = &CMenuOptionPtr->config.dof_off;

    for (int item = 0; static_cast<float>(item) < config_option_num_i; item++) {
        CMenuOptionPtr->choice_num[item] = 2;
    }

    CMenuOptionPtr->choice_num[OPTION_ITEM_MINIMAP] = 3;
    CMenuOptionPtr->UpdateOptionForm();
    main_messages = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuDCMsg[2]->buff;
    MenuCommandAnalyzeInfo.mes_buff[1] = main_messages;
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = main_messages;
    CMenuOptionPtr->ExeScript("MSG\x8F\x89\x8A\xFA\x89\xBB");
    MenuMainFrameModeSet(MENU_MAIN_FRAME_LEAVE_UP, true);
    MenuCommonInfo->SetMoveMethod(-1);
}

int MenuOptionKey();

void MenuOptionDraw();

void LocalFunc_AdjustScrlBar(MENUFORMPARTS_TYPE **parts, int *pos, int *size, int top,
                             float line_num, float show_num, int jump) {
    if (parts[0] != nullptr && parts[1] != nullptr && parts[2] != nullptr) {
        float visible_ratio = static_cast<float>(size[1]) / line_num;
        float bar_height = visible_ratio * show_num;
        parts[1]->h = (bar_height - parts[0]->h) - parts[2]->h;
        size[1] -= bar_height;
        float travel_lines = line_num - show_num;

        if (travel_lines < 1.0f) {
            travel_lines = 1.0f;
        }

        float pixels_per_line = static_cast<float>(size[1]) / travel_lines;
        CalcMenu1(static_cast<float>(pos[1]) + pixels_per_line * static_cast<float>(top), &parts[0]->y, 4.0f, 0.0f, jump);
        parts[1]->y = parts[0]->y + parts[0]->h;
        parts[2]->y = parts[1]->y + parts[1]->h;
    }
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

    return nullptr;
}

void SaveFileListDraw(int &tex_block, float *pos, int alpha);

void SetMCIconData(const dc2::io::FileRead &directory, int slot) {
    SaveIconSet icons = {
        {{"dc2_ic.gltf"},
         {"dc2_ic_c.gltf"},
         {"dc2_ic_d.gltf"}}
    };

    for (int i = 0; i < 3; i++) {
        MC_ICON_DATA *icon = &icons.file[i];
        icon->resource = dc2::assets::ReadDirectoryMember(directory, icon->name);
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
    dc2::memory::CopyTrackedBytes(MenuMapInfoSave, &GetSaveData()->map_no, sizeof(MenuMapInfoSave));
    int saved_dungeon = GetSaveData()->save_dungeon.stage_id;
    MenuMapInfoSave_DngNo = saved_dungeon;

    if (0 <= dungeon) {
        short     *map_info = &GetSaveData()->map_no;
        CSaveData *save_data = GetSaveData();
        short      previous = *map_info;
        save_data->prev_map_no = previous;
        map_info = &GetSaveData()->map_no;
        *map_info = GetDngMapNo(dungeon);
        saved_dungeon = GetSaveData()->save_dungeon.stage_id;
        MenuMapInfoSave_DngNo = saved_dungeon;
        GetSaveData()->save_dungeon.stage_id = dungeon;
    }
}

void ResetMapInfo() {
    dc2::memory::CopyTrackedBytes(&GetSaveData()->map_no, MenuMapInfoSave, sizeof(MenuMapInfoSave));
    short dungeon_no = MenuMapInfoSave_DngNo;
    GetSaveData()->save_dungeon.stage_id = dungeon_no;
}

void MenuSaveInit(mgCMemory *memory, int *tex_block, int open_type) {
    CSaveMenuClass         *menu = {};
    CMemoryCardManager     *card = {};
    u_int                  *pack = {};
    unsigned int            script_size = {};
    unsigned int            blocks = {};
    dc2::text::MessageTable main_messages{};
    CDC2Mes                *window = {};
    int                     mes_layout = {};
    int                     i = {};
    int                     part = {};
    int                     data_size = {};

    if (memory == nullptr || !SaveMenuStack.stShareStack(*memory)) {
        return;
    }

    menu = dc2::memory::NewObject<CSaveMenuClass>(SaveMenuStack);
    if (menu == nullptr) {
        return;
    }

    SaveMenuPtr = menu;

    card = dc2::mc::CreateManager(SaveMenuStack, MemoryCardPtr);
    if (card == nullptr) {
        return;
    }

    MemoryCardPtr = card;
    InitMenuReturnMsg(&SaveMenuStack);
    SetMenuReturnMsgCtrl(true);
    MemoryCardPtr->Initialize(&SaveMenuStack);
    MemoryCardPtr->SetBuff_Album(nullptr);

    if (MemoryCardPtr->InitForMC() == 0) {
        SaveMenuStack.stAlloc64(0x800);
        SaveMenuPtr->SetTexBlock(tex_block);

        if (open_type == MENU_OPEN_SAVE) {
            SaveMenuPtr->mode = SAVE_MENU_MODE_SAVE;
        }

        if (open_type == MENU_OPEN_TITLE_SAVE) {
            SaveMenuPtr->mode = SAVE_MENU_MODE_LOAD;
        }

        if (open_type == MENU_OPEN_GYORACE_LOAD) {
            SaveMenuPtr->mode = SAVE_MENU_MODE_GYORACE_LOAD;
        }

        SaveMenuStack.Align64();
        pack = reinterpret_cast<u_int *>(SaveMenuStack.stGetTop());
        script_size = LoadFileMenu("save.pac", dc2::memory::AvailableFrom(SaveMenuStack, pack), MENU_FILE_LOAD_DIRECT);
        blocks = (script_size & 0xF) != 0 ? (script_size >> 4) + 1 : script_size >> 4;
        SaveMenuStack.Alloc(blocks);
        mgTexManager.EnterIMGFile(reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "img.json", nullptr)), SaveMenuPtr->tex_block[1],
                                  nullptr, nullptr);
        mgTexManager.EnterIMGFile(reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "frametex.json", nullptr)), SaveMenuPtr->tex_block[1],
                                  nullptr, nullptr);
        Tex_SaveFile = mgTexManager.GetTexture("save", -1);
        SaveMenuPtr->dl_tex = GetMenuDlTexture();
        InitMenuDl(nullptr, 0);
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

        if (SaveMenuPtr->mode == SAVE_MENU_MODE_SAVE) {
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
            window = dc2::memory::NewObject<CDC2Mes>(SaveMenuStack);
            if (window == nullptr) {
                std::exit(EXIT_FAILURE);
            }

            SaveFileList[i] = window;
            SaveFileList[i]->SetMessData(main_messages, main_messages);
            SaveFileList[i]->MsgPreset(0x10);
            SaveFileList[i]->value_zero = 1;
            SaveFileList[i]->value_space = mes_layout;
        }

        SetMCIconData(dc2::menu::ReadMenuFile("save.pac"), 2);
        char *data = reinterpret_cast<char *>(AssetDirectoryRead(pack, "save.cfg.json", &data_size));
        MenuDataAnalyze(data, data_size, &SaveMenuStack);
        SaveMenuPtr->script = reinterpret_cast<char *>(AssetDirectoryRead(pack, "save_com.cfg.json", &SaveMenuPtr->script_size));
        MenuPosData->AttachCommonTexInfo();
        MenuPosData->ResetTextureBlockNo("save", SaveMenuPtr->tex_block[1]);
        MenuPosData->ResetTextureInfoAll();
        SaveMenuPtr->title_form = MenuPosData->GetFormInfo("TITLE");
        SaveMenuPtr->slot_form[0] = MenuPosData->GetFormInfo("SLOT1");
        SaveMenuPtr->slot_form[1] = MenuPosData->GetFormInfo("SLOT2");
        SaveMenuPtr->cursor_form = MenuPosData->GetFormInfo("CURSOR");
        SaveMenuPtr->list_form = MenuPosData->GetFormInfo("LIST");
        SaveMenuPtr->scrlbar_form = MenuPosData->GetFormInfo("SCRLBAR");
        part = 0;

        if (SaveMenuPtr->scrlbar_form != nullptr) {
            for (; part < 3; part++) {
                SaveMenuPtr->scrlbar_parts[part] =
                    SaveMenuPtr->scrlbar_form->GetPartInfo(b_2715[part]);
            }
        }

        AttachMessageForm();
        SaveMenuStack.Align64();

        if (SaveMenuPtr->mode == SAVE_MENU_MODE_SAVE) {
            StopEnvSoundMenu(1);
            MenuMainScene->GetActiveBgmStatus(&SaveMenuPtr->bgm_status);
            MenuMainScene->StopBGM(0);
            MenuMainScene->LoadBGM(0x30, dc2::memory::RemainingBytes(SaveMenuStack));
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

        if (mode == SAVE_MENU_MODE_LOAD || mode == SAVE_MENU_MODE_GYORACE_LOAD) {
            menu_font.SetStr("MODE STATE : LOAD");
            menu_font.SetPos(0x14, 0x28);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        } else {
            menu_font.SetStr("MODE STATE : SAVE");
            menu_font.SetPos(0x14, 0x28);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        }

        std::snprintf(text, sizeof(text), "SAVEFILE TOTALSIZE : %d K\n", MemoryCardPtr->GetSaveDataSize(MC_SIZE_SAVE_TOTAL) / 1024);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x3C);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        std::snprintf(text, sizeof(text), "          SAVEDATA : %d K\n", 0x196);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x50);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        std::snprintf(text, sizeof(text), "         ALBUMDATA : %d K\n", MemoryCardPtr->GetSaveDataSize(MC_SIZE_SAVE_KB));
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x64);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        std::snprintf(text, sizeof(text), "          ICONDATA : %d K\n", MemoryCardPtr->GetIconDataSize() / 1024);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x78);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        MC_CARD_INFO *card = {};
        int           port = MemoryCardPtr->port;

        if (port == 0 || port == 1) {
            card = &MemoryCardPtr->card[port];
        } else {
            card = nullptr;
        }

        std::snprintf(text, sizeof(text), "Slot 0\nType:%d\nformat:%d\nclusta%d\n", card->type, card->formatted, card->free_size);
        menu_font.SetStr(text);
        menu_font.SetPos(0x14, 0x8C);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
    }
}

void SubGameCFGAnalyze(char *command) {
    if (command != nullptr) {
        dc2::menu::AnalyzeCommands(SubGameSaveCFGBuffer, SubGameSaveCFGBufferSize, command);
    }
}

void SubGameSaveInit(mgCMemory *memory, int *tex_block, int open_type) {
    CMemoryCardManager     *card = {};
    CSubGameData           *sub_game = {};
    u_int                  *pack = {};
    unsigned int            script_size = {};
    unsigned int            blocks = {};
    dc2::text::MessageTable main_messages{};

    if (memory == nullptr || !SaveMenuStack.stShareStack(*memory)) {
        return;
    }

    if (open_type == MENU_OPEN_TITLE_SUBGAME_SAVE) {
        SubGameSaveOrLoad = SUB_SAVE_MODE_LOAD;
    }

    if (open_type == MENU_OPEN_SUBGAME_SAVE) {
        SubGameSaveOrLoad = SUB_SAVE_MODE_SAVE;

        if (GetNowLoopNo() == LOOP_DUNGEON) {
            GetSubGameSaveData()->GetSphidaData()->EnterScore();
        }
    }

    card = dc2::mc::CreateManager(SaveMenuStack, MemoryCardPtr);
    if (card == nullptr) {
        return;
    }

    MemoryCardPtr = card;
    MemoryCardPtr->Initialize(nullptr);
    MemoryCardPtr->SetBuff_Album(nullptr);
    MemoryCardPtr->InitForMC();
    MemoryCardPtr->port = 0;
    MemoryCardPtr->SetFuncNo(MC_FUNC_SEARCH_TYPE);

    sub_game = dc2::memory::NewObject<CSubGameData>(SaveMenuStack);
    if (sub_game == nullptr) {
        dc2::mc::RetireManager(MemoryCardPtr);
        return;
    }

    MemoryCardPtr->sub_game_data = sub_game;
    SaveMenuStack.Align64();
    SubGameMCPort = 0;
    SubGameSaveBlock[0] = tex_block[0];
    SubGameSaveBlock[1] = tex_block[1];
    SubGameSaveBlock[2] = tex_block[2];
    pack = reinterpret_cast<u_int *>(SaveMenuStack.stGetTop());
    script_size = LoadFileMenu("subsave.pac", dc2::memory::AvailableFrom(SaveMenuStack, pack), MENU_FILE_LOAD_DIRECT);
    blocks = (script_size & 0xF) != 0 ? (script_size >> 4) + 1 : script_size >> 4;
    SaveMenuStack.Alloc(blocks);
    u_char            *textures = reinterpret_cast<u_char *>(AssetDirectoryRead(pack, "img.json", nullptr));
    mgCTextureManager *texture_manager = &mgTexManager;

    if (textures != nullptr) {
        texture_manager->EnterIMGFile(textures, SubGameSaveBlock[0], nullptr, nullptr);
    }

    SubGameSaveCFGBuffer = reinterpret_cast<char *>(AssetDirectoryRead(pack, "save_com.cfg.json", &SubGameSaveCFGBufferSize));
    Tex_SaveFile = texture_manager->GetTexture("save", -1);
    MenuCommonInfo->key_enable = true;
    SubGameSaveOrLoadPhase = SUB_SAVE_SLOT_SELECT;
    SubGameSaveLoadStatus = false;
    SetMCIconData(dc2::menu::ReadMenuFile("subsave.pac"), 2);
    main_messages = GetMenuMainMessageBuffer();
    MenuDCMsg[0]->SetMessData(main_messages, main_messages);
    MenuDCMsg[0]->MsgPreset(0x12, LanguageCode);
    MenuDCMsg[0]->SetAbsPos(5);
    MenuDCMsg[0]->select_top = 2;
    MenuDCMsg[0]->SetMsgCursor(2);
    MenuDCMsg[0]->MakeMsg(SubGameSaveOrLoad + 0xC4E);

    if (GetNowLoopNo() == LOOP_DUNGEON) {
        MenuMainScene->fade.FadeIn(0x28);
    }

    if (auto *temporary = dc2::memory::NewArray<u8>(SaveMenuStack, std::size_t{0x1900} * 16)) {
        SubGameOmakeTempBuffer = dc2::memory::ArenaBuffer::Bind(SaveMenuStack, std::span(temporary, std::size_t{0x1900} * 16));
    } else {
        SubGameOmakeTempBuffer = {};
    }
    SubSaveTileXY = 0.0f;
    SubTrueTotalSaveFileSize = MemoryCardPtr->GetSaveDataSize(MC_SIZE_OMAKE_KB);
    SubCheckTotalSaveFileSize = SubTrueTotalSaveFileSize + 3;
    SaveMenuStack.Align64();

    if (SubGameSaveOrLoad == SUB_SAVE_MODE_LOAD) {
        MenuMainScene->GetActiveBgmStatus(&SubGameDataBgm);
        MenuMainScene->StopBGM(0);
        MenuMainScene->LoadBGM(0x30, dc2::memory::RemainingBytes(SaveMenuStack));
        MenuMainScene->PlayBGM(0, -1, 1.0f);
    }

    if (SubGameSaveOrLoad == SUB_SAVE_MODE_SAVE) {
        sub_game = GetSubGameSaveData();

        if (sub_game != nullptr) {
            if (GetNowLoopNo() == LOOP_DUNGEON) {
                sub_game->PlayEnable(1, 1);
            }

            if (GetNowLoopNo() == LOOP_EDIT) {
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
        return nullptr;
    }
}

template <typename T>
static inline T Ident(T v) { return v; }

static inline int &SubGameFileExists(CMemoryCardManager *manager) {
    return manager->file_exists;
}

int SubGameSaveKey() {
    if (MemoryCardPtr == nullptr) {
        return 1;
    }
    MC_CARD_INFO *card = {};
    u32           step_result = {};
    int           pushed = {};
    CDC2Mes      *window = {};
    int           next = {};
    int           cursor = {};
    int           pressed = {};
    int           answer = {};
    int           slot = {};
    int           slot_no = {};

    if (SubGameSaveLoadStatus == 1 && MenuMainScene->fade.FadeCheck() != 0) {
        MemoryCardPtr->FinishForMC();

        if (SubGameSaveOrLoad == SUB_SAVE_MODE_LOAD) {
            MenuMainScene->StopBGM(0);
            MenuMainScene->LoadBGM(SubGameDataBgm.load_no, dc2::memory::RemainingBytes(SaveMenuStack));
            MenuMainScene->SetActiveBgmStatus(&SubGameDataBgm);
        }

        return 1;
    }

    pushed = MenuCommonInfo->CheckPushButton();
    MC_ERROR_INFO *error = {};
    step_result = MemoryCardPtr->Step();
    error = &MemoryCardPtr->error;
    window = MenuDCMsg[0];
    next = -1;

    switch (SubGameSaveOrLoadPhase) {
        case SUB_SAVE_CLOSING:
            break;
        case SUB_SAVE_SLOT_SELECT:
            pressed = ConvertCheckPushButton(pushed);

            if (pressed & MENU_PUSH_BUTTON_CANCEL) {
                MenuSePlay(SYSTEM_SE_CANCEL);

                if (GetNowLoopNo() == LOOP_TITLE) {
                    next = SUB_SAVE_QUIT_ASK;
                }

                if (GetNowLoopNo() == LOOP_EDIT || GetNowLoopNo() == LOOP_DUNGEON) {
                    next = SUB_SAVE_QUIT_ASK_LOAD;
                }
            } else {
                cursor = window->AddMsgCursor2(2, 3, 0);

                if (pressed & MENU_PUSH_BUTTON_DECIDE) {
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    next = SUB_SAVE_CARD_CHECK;
                    SubGameMCPort = cursor - 2;
                }
            }

            break;
        case SUB_SAVE_CARD_CHECK:
            card = GetSubGameCard(MemoryCardPtr);

            if (step_result != MC_STEP_BUSY) {
                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_CARD_ERROR;
                } else {
                    next = SUB_SAVE_CARD_READY;
                }
            }

            break;
        case SUB_SAVE_CARD_READY:
            card = GetSubGameCard(MemoryCardPtr);

            if (step_result != MC_STEP_BUSY) {
                int &exists = SubGameFileExists(MemoryCardPtr);

                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_CARD_ERROR;
                } else if (card->formatted == 0) {
                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_SAVE) {
                        next = SUB_SAVE_FORMAT_ASK;
                    }

                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_LOAD) {
                        next = SUB_SAVE_NO_DATA;
                    }
                } else if (exists == 1) {
                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_SAVE) {
                        next = SUB_SAVE_OVERWRITE_ASK;
                    }

                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_LOAD) {
                        next = SUB_SAVE_LOAD_ASK;
                    }
                } else if (exists == 2) {
                    next = SUB_SAVE_WRITE_FAILED_FULL;
                } else {
                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_SAVE) {
                        next = SUB_SAVE_SPACE_ASK;
                    }

                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_LOAD) {
                        next = SUB_SAVE_LOAD_MISSING;
                    }
                }
            }

            break;
        case SUB_SAVE_QUIT_ASK:
        case SUB_SAVE_QUIT_ASK_LOAD:
            answer = window->YesNoCursor2(0);

            if (answer == MES_YESNO_YES) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                MenuArg.end_code = MENU_END_NONE;
                SubGameSaveLoadStatus = true;
                MenuArg.result[0] = 0;
                SubGameSaveOrLoadPhase = SUB_SAVE_CLOSING;
            }

            if (answer == MES_YESNO_NO) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                next = SUB_SAVE_SLOT_SELECT;
            }

            break;
        case SUB_SAVE_UNUSED_50:
            break;
        case SUB_SAVE_OVERWRITE_ASK:
            card = GetSubGameCard(MemoryCardPtr);

            if (McCheckMCPs2(card) == 0) {
                next = SUB_SAVE_CARD_ERROR;
            } else {
                answer = window->YesNoCursor2(0);

                if (answer == MES_YESNO_YES) {
                    next = SUB_SAVE_WRITING;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }

                if (answer == MES_YESNO_NO) {
                    next = SUB_SAVE_SLOT_SELECT;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
            }

            break;
        case SUB_SAVE_WRITING:
            if (step_result != MC_STEP_BUSY) {
                card = GetSubGameCard(MemoryCardPtr);

                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_WRITE_FAILED;
                } else {
                    MenuSePlay(SYSTEM_SE_COMPLETE);
                    next = SUB_SAVE_WRITE_DONE;
                }
            }

            break;
        case SUB_SAVE_WRITE_DONE:
            if (pushed != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                SubGameSaveLoadStatus = true;
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

                if (answer == MES_YESNO_YES) {
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

                if (answer == MES_YESNO_NO) {
                    next = SUB_SAVE_SLOT_SELECT;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
            }

            break;
        case SUB_SAVE_DIR_MAKING:
            card = GetSubGameCard(MemoryCardPtr);

            if (step_result != MC_STEP_BUSY) {
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

                if (answer == MES_YESNO_YES) {
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    next = SUB_SAVE_FORMATTING;
                }

                if (answer == MES_YESNO_NO) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    next = SUB_SAVE_SLOT_SELECT;
                }
            }

            break;
        case SUB_SAVE_FORMATTING:
            card = GetSubGameCard(MemoryCardPtr);

            if (step_result != MC_STEP_BUSY) {
                if (McCheckMCPs2(card) == 0 || (card != nullptr && card->formatted == 0)) {
                    next = SUB_SAVE_CARD_ERROR;
                } else {
                    next = SUB_SAVE_DIR_MAKING;
                }
            }

            break;
        case SUB_SAVE_NO_DATA:
            if (pushed != 0) {
                next = SUB_SAVE_SLOT_SELECT;
                MenuSePlay(SYSTEM_SE_CANCEL);

                if (SubGameSaveOrLoad == SUB_SAVE_MODE_SAVE) {
                    next = SUB_SAVE_FORMAT_ASK;
                }

                if (SubGameSaveOrLoad == SUB_SAVE_MODE_LOAD) {
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

                if (answer == MES_YESNO_YES) {
                    next = SUB_SAVE_LOADING;
                    MemoryCardPtr->SetFuncNo(MC_FUNC_LOAD_OMAKE);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }

                if (answer == MES_YESNO_NO) {
                    next = SUB_SAVE_SLOT_SELECT;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
            }

            break;
        case SUB_SAVE_LOADING:
            card = GetSubGameCard(MemoryCardPtr);

            if (step_result != MC_STEP_BUSY) {
                if (McCheckMCPs2(card) == 0) {
                    next = SUB_SAVE_CARD_ERROR;
                } else {
                    MenuSePlay(SYSTEM_SE_COMPLETE);
                    next = SUB_SAVE_LOAD_DONE;
                }
            }

            break;
        case SUB_SAVE_LOAD_DONE:
            if (pushed != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                MenuArg.end_code = MENU_END_SUBGAME_LOAD;
                SubGameSaveLoadStatus = true;
            }

            break;
        case SUB_SAVE_LOAD_MISSING:
            answer = window->YesNoCursor2(0);

            if (answer == MES_YESNO_YES) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                SubGameSaveLoadStatus = true;
                MenuArg.end_code = MENU_END_SUBGAME_LOAD;
            }

            if (answer == MES_YESNO_NO) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                next = SUB_SAVE_SLOT_SELECT;
            }

            break;
        case SUB_SAVE_CARD_ERROR:
            if (pushed != 0) {
                card = GetSubGameCard(MemoryCardPtr);

                if (McCheckMCPs2(card) == 0) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    next = SUB_SAVE_SLOT_SELECT;
                } else if (card->formatted == 0) {
                    MenuSePlay(SYSTEM_SE_CANCEL);

                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_LOAD) {
                        next = SUB_SAVE_LOAD_MISSING;
                    }

                    if (SubGameSaveOrLoad == SUB_SAVE_MODE_SAVE) {
                        next = SUB_SAVE_FORMAT_ASK;
                    }
                } else {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    next = SUB_SAVE_SLOT_SELECT;
                }
            }

            break;
        case SUB_SAVE_UNUSED_1001:
            break;
    }

    if (0 <= next) {
        slot = SubGameMCPort;
        slot_no = slot + 1;

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
                window->SetMsgVolumeNoOne(slot_no);
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
                    window->SetMsgVolumeNoOne(slot_no);
                }

                break;
            case SUB_SAVE_SPACE_ASK: {
                SubGameCFGAnalyze("OM_ISNEWSAVE");
                int values[2] = {0, 0};
                values[0] = slot_no;
                values[1] = SubCheckTotalSaveFileSize;
                window->SetMsgVolumeNo(values, 2);
                break;
            }
            case SUB_SAVE_DIR_MAKING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_MAKE_OMAKE_DIR);
                SubGameCFGAnalyze("OM_NEWSAVE");
                break;
            case SUB_SAVE_FORMAT_ASK:
                SubGameCFGAnalyze("OM_ISFORMAT");
                window->SetMsgVolumeNoOne(slot_no);
                break;
            case SUB_SAVE_FORMATTING:
                MemoryCardPtr->SetFuncNo(MC_FUNC_FORMAT);
                SubGameCFGAnalyze("OM_FORMAT");
                window->SetMsgVolumeNoOne(slot_no);
                break;
            case SUB_SAVE_NO_DATA:
                SubGameCFGAnalyze("OM_NOTFORMAT");
                break;
            case SUB_SAVE_LOAD_ASK:
                SubGameCFGAnalyze("OM_ISLOAD");
                window->SetMsgVolumeNoOne(slot_no);
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
                window->SetMsgVolumeNoOne(slot_no);
                window->MakeMsg(0xC59);
                break;
            case SUB_SAVE_CARD_ERROR:
                window->MsgPreset(0x12, LanguageCode);
                card = GetSubGameCard(Ident(MemoryCardPtr));

                if (SubGameSaveOrLoadPhase == SUB_SAVE_FORMATTING) {
                    window->MakeMsg(0xBE5);
                    window->SetMsgVolumeNoOne(slot_no);
                } else if (SubGameSaveOrLoadPhase == SUB_SAVE_LOADING) {
                    window->MsgPreset(0xA, LanguageCode);
                    window->MakeMsg(0xBC6);
                } else if (McCheckMCPs2(card) == 0) {
                    window->MakeMsg(0xBB9);
                    window->SetMsgVolumeNoOne(slot_no);
                } else if (card->free_size < SubCheckTotalSaveFileSize) {
                    window->MakeMsg(0xC50);
                    int values[2] = {0, 0};
                    values[0] = slot_no;
                    values[1] = SubCheckTotalSaveFileSize;
                    window->SetMsgVolumeNo(values, MES_VALUE_MAX);
                }

                window->SetAbsPos(5);
                break;
            case SUB_SAVE_UNUSED_1001:
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
    textures->ReloadTexture(SubGameSaveBlock[0], (sceVif1Packet *) nullptr);

    if (Tex_SaveFile != nullptr) {
        mgCDrawPrim *prim = GetMenuPrim();
        mgRect<int>  rect;
        rect.Set(0x100, 0x100, 0x100, 0x100);
        DrawMenuTilePattern(prim, Tex_SaveFile, SubSaveTileXY, SubSaveTileXY, rect, 0, nullptr);
    }

    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
    MenuDCMsg[0]->DrawMsg();
}

/**
 *
 * Map information saved while the save menu temporarily changes the active map.
 *
 */
u8 MenuMapInfoSave[0xC];

#include "common.h"

#include <algorithm>

#include "stubs/menuop.hpp"

// Retail clamps the Options cursor to op_cursorlimmit while the list scrolls. PAL's bottom limit lies
// above the ninth shown row, so this moves it down to the selected row's place in the settled list:
// the cursor's y less how far the button form still has to move. It never moves the limit up.
int PortOptionCursorBottom(int limit, int cursor_y, int form_y, int rest_form_y) {
    return std::max(limit, cursor_y - form_y + rest_form_y);
}
