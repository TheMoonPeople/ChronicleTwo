#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "dataread.hpp"
#include "gaiji.hpp"
#include "gamepad.hpp"
#include "hddinstall.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mapjump.hpp"
#include "mapload.hpp"
#include "mapselect.hpp"
#include "memcard.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "movie.hpp"
#include "nd_meswin.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "sceneload.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "title.hpp"
#include "userdata.hpp"
#include "wavetable.hpp"

/**
 *
 * Records whether an extra was selected during the current title session.
 *
 */
static s16 TitleOmakeFlag;

extern TITLE_INFO      *TitleInfo;
extern float            TitleProjection;
void                    TitleMCCheckDraw();
void                    TitleCopyRightDraw();
void                    RushMovieDraw();
void                    TitleModeDraw();
void                    TitleMapDraw();
s32                     DCTitleStep(s32 phase);
int                     TitleMCCheckKey();
static int              TitleModeKey();
void                    TitleCopyRightInit();
int                     TitleCopyRightStep();
void                    TitleHDDInstallInit();
int                     TitleHDDInstallKey();
int                     CheckHDDInstall();
int                     RushMovieKey();
void                    TitleDraw();
void                    DrawMenuDl(int x, int y, int width, int alpha, float rate);
int                     GetSelectLanguageNo();
void                    TitleHDDInstallDraw();
extern CScene          *TitleScene;

/**
 *
 * Selects the title screen input and transition phase.
 *
 */
static s16 TitlePhase;

/**
 *
 * Identifies the memory card port selected for the title save menu.
 *
 */
static s16 TitleMCActivePort;

/**
 *
 * Holds the E3 trial menu selection.
 *
 */
static int E3Select;

/**
 *
 * Holds the vertical position of the E3 title sprite.
 *
 */
static float E3_Title_SpriteY;

/**
 *
 * Holds the vertical position of the E3 trial sprite.
 *
 */
static float E3_Trial_SpriteY;

/**
 *
 * Controls drawing of the E3 trial information board.
 *
 */
static int E3ModeBoardDrawFlag;

/**
 *
 * Holds the E3 trial information board alpha.
 *
 */
static int E3ModeBoardDrawAlpha;

/**
 *
 * Holds the trial title black overlay alpha.
 *
 */
static int Trial_TitleBlackFadeAlpha;

/**
 *
 * Selects the attract movie requested by the demo runner.
 *
 */
static s8 DCSelectedMovie;

/**
 *
 * Records whether the shortened first-boot attract delay has been applied.
 *
 */
static u8 TitleRushWaitCountBoot;

/**
 *
 * Selects the title map camera movement phase.
 *
 */
static int TitleCameraPhase;

extern u8               TitleMCFuncFlag;
extern u8               TitleMCCheckNow;
extern s16              TitleMainMCCheckPhase;
extern mgCCameraFollow *TitleCamera;
extern mgCCamera       *TitleCamera2;
extern CWaveTable      *WaveTable__3;
extern CMap            *TitleMap;
extern s8               DCRuncherMode;
extern int              DCRuncherCounter;
extern u_int            TitleEventSound;
extern mgCTexture      *Tex_TitleBG;
extern mgCTexture      *Tex_Chronicle;
extern mgCTexture      *Tex_Logo;
extern mgCTexture      *Tex_Plate;
extern mgCTexture      *Tex_TitleLight;
extern mgCTexture      *Tex_TitleCursor;
extern mgCTexture      *Tex_TrialMsg;
extern mgCTexture      *Tex_TitleBG2;
extern char             at_1221__4[];
extern char             at_1222__4[];
extern char             at_1223__4[];
extern char             at_1224__4[];
extern char             at_1225__4[];
extern char             at_1226__4[];
extern char             at_1227__3[];
extern char             at_1228__3[];
extern char             at_1229__2[];
extern char             at_1230__2[];
extern char             at_1231__2[];
extern char             at_1232__2[];
extern char             at_1233[];
extern char             at_1235[];
extern char             at_1236[];
extern char             at_1237__2[];
extern char             at_1238[];
extern char             at_1239__2[];
extern MC_ICON_DATA     MC_ICON_Data[3];
void                    TitleModeInit();
void                    CalcPushAlpha(int index, float *alpha);
void                    TitleMCCheckInit(int boot_mode);
int                     CheckAppInstallForTitle();
extern mgCTexture      *RushStart;
extern s8               TitleBootEventNo;
extern u8               GameBootInit;
extern u8               TitleHDDCheckFlag;
static void             TitleBootInit();

/**
 *
 * Memory stack the title screen allocates its scene, resources and buffers from.
 *
 */
static mgCMemory DataBuffer;

/**
 *
 * Memory stack the title map loads into.
 *
 */
static mgCMemory TitleMapBuffer;

/**
 *
 * Work memory stack of the title scene.
 *
 */
static mgCMemory TitleWorkBuffer;

/**
 *
 * Memory stack the title scene reads files through.
 *
 */
static mgCMemory Stack_ReadBuff;

/**
 *
 * Memory stack the menu loads character data into while the title screen runs.
 *
 */
static mgCMemory Stack_MenuCharaBuff_Fix;

/**
 *
 * Hard disk state shown and acted on by the title screen.
 *
 */
static HDD_INFO HDDINFO;

/**
 *
 * Memory stack reserved for the language selection screen.
 *
 */
static mgCMemory lang_stack;
extern CMovie          *RushMovie;
extern mgCTexture      *RushWork;

/**
 *
 * Holds the attract movie playback, skip and fade state.
 *
 */
static RUSH_INFO RushInfo;

/**
 *
 * Records whether the attract movie START debug indicator is drawn.
 *
 */
static s8 debug_start_drawflag;

extern char             at_1234[];

/**
 *
 * Selects the copyright and publisher logo display phase.
 *
 */
static s8 TitleCopyRightDispPhase;

/**
 *
 * Counts frames during the copyright and publisher logo display.
 *
 */
static s16 TitleCopyRightDispCounter;

/**
 *
 * Selects the rising or falling half of the PUSH START alpha pulse.
 *
 */
static s16 TitlePushStart_AlphaPlus;

/**
 *
 * Points to the installation progress bar texture.
 *
 */
static mgCTexture *HDDDlBar;

/**
 *
 * Selects the hard disk installation screen phase.
 *
 */
static s16 HDDPhase;

/**
 *
 * Selects the hard disk installation confirmation action.
 *
 */
static s16 HDDConfirmType;

/**
 *
 * Identifies the current hard disk installation slideshow image.
 *
 */
static s16 HDDnowDisplayImageNo;

/**
 *
 * Enables drawing of the installation progress bar.
 *
 */
static u8 HDDDlBarDrawFlag;

/**
 *
 * Selects the installation dialog in place of the slideshow overlay.
 *
 */
static u8 HDDMesDrawFlag;

/**
 *
 * Points to the loaded installation message data.
 *
 */
static s16 *HDDMesDataBuff;

/**
 *
 * Points to the installation confirmation and status dialog.
 *
 */
static CDC2Mes *HDDMes;

/**
 *
 * Points to the installation progress caption dialog.
 *
 */
static CDC2Mes *HDDMes2;

/**
 *
 * Points to the installation screen background texture.
 *
 */
static mgCTexture *HDDBGTex;

/**
 *
 * Points to the installation screen controls and cursor texture.
 *
 */
static mgCTexture *HDDSysImage;

/**
 *
 * Holds the installation menu selection.
 *
 */
static s16 HDDModeSelect;

/**
 *
 * Holds the ten installation slideshow textures.
 *
 */
static mgCTexture *HDDImage[10];

/**
 *
 * Holds the alpha of each installation slideshow image.
 *
 */
static int HDDImageAlpha[10];

/**
 *
 * Counts frames in the current title map camera phase.
 *
 */
static int TitleCameraPhaseCounter;

/**
 *
 * Accumulates the title map camera rotation.
 *
 */
static float TitleCameraAddAngle;

/**
 *
 * Records a request to skip the publisher logo display.
 *
 */
static s8 TitleSkipLogoFlag;

/**
 *
 * Points to the title memory card check message window.
 *
 */
static ClsMes *TitleMCCheckMes;

extern CMemoryCardManager *TitleMCCheck;

/**
 *
 * Selects the boot-specific memory card check behavior.
 *
 */
static u8 TitleMCCheckBootMode;

/**
 *
 * Identifies the memory card port currently being checked.
 *
 */
static s16 TitleMCCheckPort;

/**
 *
 * Selects the current memory card check operation.
 *
 */
static s16 TitleMCCheckPhase;

/**
 *
 * Holds the extras and costume unlock bits collected from memory cards.
 *
 */
static s32 OmakePlayEnableAttr;

/**
 *
 * Points to the language menu row and cursor texture.
 *
 */
static mgCTexture *lang_tex;

/**
 *
 * Counts frames for the language menu cursor wobble.
 *
 */
static int title_lang_cursor_cnt;

/**
 *
 * Holds the black overlay alpha for language menu transitions.
 *
 */
static int title_lang_fadealpha;

/**
 *
 * Selects the language menu fade and input phase.
 *
 */
static int title_lang_phase;

/**
 *
 * Holds the selected language menu row.
 *
 */
static int title_lang_select;

/**
 *
 * Holds the eased language menu cursor coordinates.
 *
 */
static float title_lang_curxy[2];

/**
 *
 * Rounds a byte count up to the number of 16-byte memory blocks it occupies.
 *
 */
static inline u_int Align16Blocks(u_int size) {
    if (size & 0xF) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

/**
 *
 * Records whether a boot memory card contains the debug unlock code.
 *
 */
u8 MasterDebugModeOn;

/**
 *
 * Holds the costume bits unlocked by the memory cards.
 *
 */
u_long CostumeOptionEnv;

/**
 *
 * Sets the number of idle title frames before the attract movie starts.
 *
 */
static int TitleRushWaitCount = 750;

/**
 *
 * Holds the number of save files found on each memory card.
 *
 */
static s16 TitleMCCheckFileFind[2] = {0, 0};

/**
 *
 * Holds the inserted-card state captured for each memory card port.
 *
 */
static u8 TitleMCCheckInport[2] = {0, 0};

// Code (.text)
/**
 *
 * Seeds title-screen random choices from the current vertical sync count.
 *
 */
void title_init_rand() {
    srand(mgGetVSyncCount());
}

/**
 *
 * Applies the saved sound channel setting to the sound manager.
 *
 */
void SetSoundMode() {
    CSaveData *save = GetSaveData();

    if (save != NULL) {
        SV_CONFIG_OPTION *config = &save->config;

        if (config != NULL) {
            if (config->sound_mode == 0) {
                CSnd.SetStereoMode(1);
                return;
            }
        }

        CSnd.SetStereoMode(0);
    }
}

/**
 *
 * Clears the title extras flags before processing title input.
 *
 */
void InitTitleOmakeFlag() {
    TitleOmakeFlag = 0;
    OmakeFlag = 0;
}

/**
 *
 * Marks a title extra as selected.
 *
 */
void TitleOmakeOn() {
    TitleOmakeFlag = 1;
}

int CheckOmakeFlag() {
    return TitleOmakeFlag;
}

void InitOmakeEnv(int type, INIT_LOOP_ARG *arg, int *loop_no) {
    int map_no = -1;
    int mode = 0;
    int item_mode = 0;
    int event_no = 0;
    int floor_no = 0;

    if (type == OMAKE_TYPE_GYORACE) {
        item_mode = 0x10;
        event_no = 0x64;
        map_no = SearchMapNo("i03h04");
        mode = 1;
    }

    if (type == OMAKE_TYPE_DUNGEON) {
        event_no = 6000;
        map_no = 0;
        floor_no = 0;
        item_mode = 0xF;
        mode = 2;
    }

    if (loop_no != NULL) {
        *loop_no = mode;
    }

    if (arg != NULL) {
        arg->event_no = event_no;
        arg->map_no = map_no;
        arg->floor_no = floor_no;
    }

    OmakeFlag = 1;
    DebugGetItem(&GetSaveData()->user_data, item_mode);
}

void TitleInit(INIT_LOOP_ARG arg) {
    mgInitFont();
    mgInitLighting();
    mgInitActiveLighting();
    SetCurrentDir(NULL);
    TitleScene = GetMainScene();
    TitleScene->Initialize();
    DNG_BATTLE_AREA *area = &TitleScene->battle_area;

    if (area != NULL) {
        area->battle_clear = 1;
        area->battle_bgm_state = 0;
        area->battle_bgm_vol = 0.0f;
        area->camera_mode = 0;
        area->pause_flag = 0;
        area->timer = 0;
        area->minimap_reveal = 0;
        area->quake_count = 0;
        area->script.running = 0;
        area->subject_counter = 0;
        area->practice_actions = 0;
        area->floor_status = 0;
        area->weather = 0;
        area->lock_on_mode = 0;
    }

    InitTitleOmakeFlag();
    PlayTimeCount(0);
    TitleHDDCheckFlag = 1;

    if (LanguageCode > 0) {
        TitleHDDCheckFlag = 0;
    }

    TitleBootEventNo = arg.event_no;
    mgCMemory *main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;
    mgCMemory  packet0;
    mgCMemory  packet1;
    mgCMemory  data0;
    mgCMemory  data1;
    u_long128 *vif0 = main_stack->stAlloc64(10000);
    u_long128 *vif1 = main_stack->stAlloc64(10000);
    mgInitVif1Packet(vif0, vif1, 160000);
    packet0.stSetBuffer(main_stack->stAlloc64(30000), 30000);
    packet1.stSetBuffer(main_stack->stAlloc64(30000), 30000);
    data0.stSetBuffer(main_stack->stAlloc64(60000), 60000);
    data1.stSetBuffer(main_stack->stAlloc64(60000), 60000);
    DataBuffer.stSetBuffer(main_stack->stAlloc64(1000000), 1300000);
    mgSetPacketBuffer(&packet0, &packet1);
    mgSetDataBuffer(&data0, &data1, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(0x73, 0x60, &DataBuffer);
    DataBuffer.Align64();
    TitleInfo = new (DataBuffer.Alloc(0x1C)) TITLE_INFO;
    GamePad__2.SetAutoRepeat(0x5000, 0xF, 4);
    GamePad__2.MenuModeOn(0x78);

    if (GameBootInit == 0) {
        TitleBootEventNo = 0;
        TitleBootInit();
        TitleInfo->mode = TITLE_MODE_MC_CHECK;
        TitleInfo->next_mode = TITLE_MODE_NONE;
        return;
    }

    TitleBootInit();
}
#ifdef NONMATCHING

#pragma inline_depth(8)

/**
 *
 * Loads the title scene, menu resources, sound, and boot-time memory card state.
 *
 */
static void TitleBootInit() {
    RushMovie = new ((u_long128 *) DataBuffer.Alloc(0x2396)) CMovie;
    TitleMCFuncFlag = 1;
    TitleMCCheckNow = 0;
    TitleMainMCCheckPhase = 0;
    TitleMCCheck = new ((u_long128 *) DataBuffer.Alloc(0x112)) CMemoryCardManager;
    TitleMCCheck->Initialize(&DataBuffer);
    TitleCamera = new ((u_long128 *) DataBuffer.Alloc(0xE)) mgCCameraFollow(40.0f, 30.0f, 0.0f, 8.0f);
    TitleCamera2 = new ((u_long128 *) DataBuffer.Alloc(9)) mgCCamera(8.0f);
    WaveTable__3 = new ((u_long128 *) DataBuffer.Alloc(0x123)) CWaveTable;
    mgCTextureManager *textures = &mgTexManager;
    DataBuffer.Align64();
    u_long128 *map_top = DataBuffer.stGetTop();
    TitleMapBuffer.stSetBuffer(map_top, 0x40000);
    DataBuffer.Alloc(0x60000);
    TitleWorkBuffer.stSetBuffer(DataBuffer.stGetTop(), 0x2800);
    DataBuffer.Alloc(0x2800);
    TitleProjection = 800.0f;
    TitleScene->read_buff = map_top;
    TitleScene->AssignCamera(0, TitleCamera, NULL);
    TitleScene->AssignCamera(1, TitleCamera2, NULL);
    TitleScene->active_camera = 0;
    TitleScene->before_camera = 0;
    TitleScene->SetStack(1, &TitleMapBuffer);
    TitleScene->work_stack = &TitleWorkBuffer;
    u8 *map_buffer = (u8 *) DataBuffer.stGetTop();
    int map_no = SearchMapNo(at_1221__4);
    TitleScene->active_map = 0;
    MapJumpMapInfo    main_map;
    SCN_LOADMAP_INFO2 load_info;
    main_map.stack_no = 1;
    main_map.map_no = 0;
    main_map.efp_tex_block = 0x64;
    main_map.tex_block = 0;
    main_map.load_buf = map_buffer;
    SetMainMapInfo(&main_map);
    GetLoadMapInfo(&load_info, map_no);
    load_info.sky_tex_block = 0x6B;
    load_info.load_sky = 1;
    load_info.place_parts_max = 0x190;
    TitleScene->DeleteMap(0, 1);
    TitleScene->LoadMap(0, &load_info, 0);
    TitleScene->SetNowMapNo(map_no);
    TitleScene->SetActive(2, 0);
    TitleMap = TitleScene->GetMap(TitleScene->active_map);
    int file_size;
    if (LoadFile2(at_1222__4, DataBuffer.stAllocTest(1), &file_size, 0) != 0) {
        textures->EnterIMGFile((u_char *) DataBuffer.Alloc(Align16Blocks(file_size)), 0x6A, NULL, NULL);
    }
    textures->EnterTexture(0x6A, at_1223__4, NULL, mgScreenWidth, mgScreenHeight, 0x20, 0, 0, 0);
    char lang_file[0x40];
    sprintf(lang_file, at_1224__4, LanguageCode);
    LoadFile2(lang_file, map_buffer, &file_size, 0);
    DataBuffer.Alloc(Align16Blocks(file_size));
    textures->EnterIMGFile(map_buffer, 0x40, NULL, NULL);
    Tex_TitleBG = textures->GetTexture(at_1225__4, -1);
    Tex_Chronicle = textures->GetTexture(at_1226__4, -1);
    Tex_Logo = textures->GetTexture(at_1227__3, -1);
    Tex_Plate = textures->GetTexture(at_1228__3, -1);
    Tex_TitleLight = textures->GetTexture(at_1229__2, -1);
    Tex_TitleCursor = textures->GetTexture(at_1230__2, -1);
    Tex_TrialMsg = textures->GetTexture(at_1231__2, -1);
    Tex_TitleBG2 = textures->GetTexture(at_1232__2, -1);
    DataBuffer.Align64();
    u_long128 *save_pack = &DataBuffer.stGetTop()[0x4100];
    if (LoadFileMenu(at_1233, save_pack, MENU_FILE_LOAD_DIRECT) != 0) {
        for (int i = 0; i < 3; i++) {
            u_int *icon_file = GetPackFile((u_int *) save_pack, MC_ICON_Data[i].name, &MC_ICON_Data[i].size);
            MC_ICON_Data[i].data = DataBuffer.Alloc(Align16Blocks(MC_ICON_Data[i].size));
            memcpy(MC_ICON_Data[i].data, icon_file, MC_ICON_Data[i].size);
        }
    }
    TitleMCCheck->SetIconData(MC_ICON_Data, 0);
    textures->DeleteBlock(0x43);
    RushWork = textures->EnterTexture(0x43, at_1234, NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0, 0);
    DataBuffer.Align64();
    u_long128 *push_start_img = DataBuffer.stGetTop();
    if (LoadFile2(at_1235, push_start_img, &file_size, 0) != 0) {
        textures->EnterIMGFile((u_char *) push_start_img, 0x43, NULL, NULL);
    }
    RushStart = textures->GetTexture(at_1236, 0x43);
    DataBuffer.Alloc(Align16Blocks(file_size));
    mgCMemory snd_memory;
    snd_memory.stSetBuffer(DataBuffer.stGetTop(), 0x280);
    DataBuffer.Alloc(0x280);
    DataBuffer.Align64();
    textures->EnterIMGFile(GetGaijiImgPtr(), 0x46, NULL, NULL);
    ReLoadFontTexture(0x46);
    textures->EnterIMGFile(GetFontTex2ImgPtr(), 0x46, NULL, NULL);
    DataBuffer.Align64();
    MenuArg.mes_tex_block = 0x46;
    MenuArg.scene = TitleScene;
    MenuArg.tex_block_top = 0x54;
    MenuArg.tex_block_num = 0x10;
    MenuArg.pack = (u_int *) DataBuffer.stGetTop();
    file_size = LoadFileMenu(at_1237__2, (u_long128 *) MenuArg.pack, MENU_FILE_LOAD_DIRECT);
    DataBuffer.Alloc(Align16Blocks(file_size));
    DataBuffer.Align64();
    CActionChara *chara = new ((u_long128 *) DataBuffer.Alloc(0x105)) CActionChara;
    chara->Initialize(NULL);
    TitleScene->AssignChara(0, chara, at_1238);
    DataBuffer.Align64();
    u_long128 *sound_buffer = DataBuffer.stGetTop();
    TitleScene->LoadSound(0x1F4, sound_buffer);
    TitleScene->StopEnvBGM();
    sndWaitTransBd();
    LoadFile2(at_1239__2, sound_buffer, &file_size, 0);
    sndInitPort(4);
    TitleEventSound = sndLoadSound(4, (u_int *) sound_buffer, &snd_memory);
    DataBuffer.Align64();
    Stack_ReadBuff.stSetBuffer(DataBuffer.stGetTop(), DataBuffer.stGetRest());
    read_buffer = Stack_ReadBuff.stGetTop();
    TitleScene->read_buff = read_buffer;
    TitleScene->fade.Initialize();
    DCRuncherMode = 0;
    DCRuncherCounter = 0;
    if (TitleBootEventNo == 1) {
        TitleInfo->mode = TITLE_MODE_RUSH_MOVIE;
        TitleInfo->next_mode = TITLE_MODE_NONE;
    } else if (TitleBootEventNo == 0) {
        if (GameBootInit == 0) {
            TitleInfo->mode = TITLE_MODE_MC_CHECK;
            TitleInfo->next_mode = TITLE_MODE_NONE;
            if (TitleHDDCheckFlag != 0) {
                HDDINFO.connect = HddConectCheck(&HDDINFO.hdd_state);
                HDDINFO.app_install = CheckAppInstallForTitle();
                HDDINFO.install_space = CheckInstallSpace();
            }
            TitleMCCheck->InitForMC();
            TitleMCCheckInit(1);
            GameBootInit = 1;
        } else {
            TitleInfo->mode = TITLE_MODE_TITLE;
            TitleInfo->next_mode = TITLE_MODE_NONE;
            TitleModeInit();
            TitleInfo->select = TitleSelectInit;
        }
    }
}

#pragma inline_depth reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/title", TitleBootInit__Fv);
#endif
void TitleExit() {
    if (CheckOmakeFlag() != 0) {
        OmakeFlag = 1;
    }

    printf("OMAKE : %d\n", OmakeFlag);
    sndSeAllStop(-1);
    GamePad__2.AutoRepeatOff();
    GamePad__2.MenuModeOff();
    mgFrameRate = 2;
    mgCloseFont();
}

int TitleLoop() {
    if (DebugFlag != 0 && GamePad__2.On(0x800) != 0 && GamePad__2.On(0x100) != 0) {
        mgCloseFont();

        if (TitleInfo->mode == TITLE_MODE_RUSH_MOVIE) {
            RushMovie->Term();
            RushMovie->SwitchThread();
        }

        return 1;
    }

    int result = 0;
    int next_loop = 0;
    int menu_closed = 0;

    switch (TitleInfo->mode) {
        case TITLE_MODE_LANG_SELECT:
            if (TitleLangSelKey() != 0) {
                TitleInfo->next_mode = TITLE_MODE_MC_CHECK;
            }

            break;
        case TITLE_MODE_MC_CHECK:
            if (TitleMCCheckKey() != 0) {
                TitleMCCheck->FinishForMC();
                TitleInfo->next_mode = TITLE_MODE_COPYRIGHT;
            }

            break;
        case TITLE_MODE_COPYRIGHT:
            if (TitleCopyRightStep() != 0) {
                TitleInfo->next_mode = TITLE_MODE_TITLE;
            }

            break;
        case TITLE_MODE_RUSH_MOVIE: {
            int rush = RushMovieKey();

            if (rush != 0) {
                TitleInfo->next_mode = TITLE_MODE_TITLE;

                if (rush == TITLE_KEY_RUSH_MOVIE) {
                    next_loop = 3;
                    TitleInfo->next_mode = TITLE_MODE_NONE;
                }

                if (rush == TITLE_KEY_DEMO_TIMEOUT) {
                    next_loop = 5;
                }
            }

            break;
        }
        case TITLE_MODE_TITLE:
            result = TitleModeKey();

            if (result != 0) {
                TitleMCCheck->FinishForMC();
            }

            if (result == TITLE_KEY_START_GAME) {
                next_loop = 1;
            }

            if (result == TITLE_KEY_RUSH_MOVIE) {
                result = 0;
                TitleInfo->next_mode = TITLE_MODE_RUSH_MOVIE;
                RushInfo.movie_no = 0;
            }

            if (result == TITLE_KEY_CONTINUE || result == TITLE_KEY_OPTION || result == TITLE_KEY_NEW_GAME) {
                TitleInfo->next_mode = TITLE_MODE_MENU;

                if (result == TITLE_KEY_NEW_GAME) {
                    InitSaveData();
                    DebugGetItem(NULL, 1);
                    MenuArg.param[0] = 0;
                    MenuArg.open_type = 0x14;
                    GetUserDataMan()->SetChrEquipDirect(1, 0x7F);
                    GetUserDataMan()->SetChrEquipDirect(1, 0x85);
                    GetUserDataMan()->SetChrEquipDirect(1, 0x10A);
                    GetUserDataMan()->SetChrEquipDirect(1, 0x6E);
                    GetUserDataMan()->SetChrEquipDirect(1, 0x5B);

                    if (OmakePlayEnableAttr & OMAKE_ENABLE_COSTUME) {
                        MenuArg.param[0] = 1;
                        GetUserDataMan()->SetCostumeBit(CostumeOptionEnv);
                    }
                }

                if (result == TITLE_KEY_CONTINUE) {
                    MenuArg.open_type = 8;
                }

                if (result == TITLE_KEY_OPTION) {
                    MenuArg.open_type = 0x12;
                }

                result = 0;
            }

            if (result == TITLE_KEY_HDD_INSTALL) {
                result = 0;
                TitleInfo->next_mode = TITLE_MODE_HDD_INSTALL;
            }

            if (result == TITLE_KEY_OMAKE) {
                MenuArg.param[0] = 0;
                result = 0;
                MenuArg.open_type = 0x1B;
                TitleInfo->next_mode = TITLE_MODE_SUBGAME_MENU;
            }

            if (result == TITLE_KEY_DEMO_QUIT) {
                next_loop = 4;
            }

            if (result == TITLE_KEY_DEMO_TIMEOUT) {
                next_loop = 5;
            }

            break;
        case TITLE_MODE_MENU:
        case TITLE_MODE_SUBGAME_MENU:
            result = MenuMainKey();

            if (result != 0) {
                if (TitleInfo->mode != TITLE_MODE_SUBGAME_MENU) {
                    TitleScene->StopBGM(0);
                    TitleScene->LoadBGM(TitleInfo->bgm_status.load_no, Stack_ReadBuff.stGetTop());
                    TitleScene->SetActiveBgmStatus(&TitleInfo->bgm_status);
                    TitleScene->PlayEnvBgm();
                }

                result = 0;

                if (MenuArg.end_code == 10) {
                    next_loop = 2;
                } else if (MenuArg.end_code == 12) {
                    next_loop = 1;
                } else if (MenuArg.end_code == 19) {
                    next_loop = 11;
                } else {
                    memcpy(&TitleInfo->config, &GetSaveData()->config, sizeof(SV_CONFIG_OPTION));
                    TitleInfo->next_mode = TITLE_MODE_TITLE_RETURN;
                }

                menu_closed = 1;
            }

            break;
        case TITLE_MODE_HDD_INSTALL:
            result = TitleHDDInstallKey();

            if (result != 0) {
                TitleInfo->next_mode = TITLE_MODE_TITLE_RETURN;
                result = 0;
                TitleScene->PlayEnvBgm();
            }

            break;
    }

    TitleScene->fade.FadeStep();
    TitleDraw();
    TitleScene->fade.Draw();

    if (0 < next_loop) {
        title_init_rand();
    }

    if (menu_closed != 0) {
        MenuMainExit();
        GamePad__2.SetAutoRepeat(0x5000, 0xF, 4);
        GamePad__2.MenuModeOn(0x78);
    }

    if (next_loop == 1) {
        TitleScene->skip_load_bgm = 1;
        TitleScene->StopEnvBGM();
        INIT_LOOP_ARG arg;
        arg.event_no = 0x3F2;
        arg.map_no = 0;
        arg.floor_no = 0x14;
        NextLoop(2, arg);
        PlayTimeCount(1);
        memcpy(&GetSaveData()->config, &TitleInfo->config, sizeof(SV_CONFIG_OPTION));
        CUserDataManager *user = GetUserDataMan();
        user->SetChrEquipDirect(0, MenuArg.result[0]);
        user->SetChrEquipDirect(0, MenuArg.result[1]);
        user->SetChrEquipDirect(0, MenuArg.result[2]);
        user->LeavePartyMember(0);
        user->JoinPartyMember(1);
        user->EnableCharaChange(1);
        user->SetActiveChrNo(1);

        if (CheckHDDInstall() != 0) {
            ChangeHddFile();
        }

        return 1;
    }

    if (next_loop == 2) {
        INIT_LOOP_ARG arg;
        CSaveData    *save = GetSaveData();
        int           loop_no = MenuArg.result[0];
        int           event_no = 100;
        int           floor_no = 0;
        int           map_no = MenuArg.result[1];
        int           dng_map_no = -1;

        if (map_no == 10) {
            map_no = save->sub_map_no;

            if (map_no < 10 || map_no > 14) {
                map_no = 10;
            }
        }

        if (loop_no == 2) {
            map_no = MenuArg.result[2];
            floor_no = MenuArg.result[3];

            if (MenuArg.result[4] == 1) {
                event_no = 1000;
                dng_map_no = GetDngMapNo(map_no);
            } else {
                arg.mc_load = 1;
                event_no = 0x3F2;
            }
        }

        if (loop_no == 1) {
            arg.mc_load = 1;
        }

        if (CheckStartChapter8(save) != 0) {
            map_no = SearchMapNo("m02");
        }

        if ((s8) save->skip_load_bgm != 0) {
            TitleScene->skip_load_bgm = 1;
            save->skip_load_bgm = 0;
        }

        SetSoundMode();
        PlayTimeCount(1);
        TitleScene->StopEnvBGM();
        arg.map_no = map_no;
        arg.event_no = event_no;
        arg.floor_no = floor_no;
        NextLoop(loop_no, arg);

        if (CheckHDDInstall() != 0) {
            ChangeHddFile();
        }

        TitleScene->SetNowMapNo(save->prev_map_no);

        if (0 <= dng_map_no) {
            TitleScene->SetNowMapNo(dng_map_no);
        }

        return 1;
    }

    if (next_loop == 3) {
        if (RushInfo.skipped == 0) {
            demoAttractComplete();
        }

        if (RushInfo.skipped == 1) {
            demoAttractInterrupted();
        }

        return 1;
    }

    if (next_loop == 4) {
        demQuit();
        return 1;
    }

    if (next_loop == 5) {
        demoQuitTimeOut();
        return 1;
    }

    if (next_loop == 11) {
        int omake_type = OMAKE_TYPE_DUNGEON;

        if (TitleInfo->omake_num == 2) {
            if (TitleInfo->omake_select == 1) {
                omake_type = OMAKE_TYPE_GYORACE;
            }
        } else {
            if (OmakePlayEnableAttr & OMAKE_ENABLE_DUNGEON) {
                omake_type = OMAKE_TYPE_DUNGEON;
            }

            if (OmakePlayEnableAttr & OMAKE_ENABLE_GYORACE) {
                omake_type = OMAKE_TYPE_GYORACE;
            }
        }

        InitSaveData();
        memcpy(&GetSaveData()->config, &TitleInfo->config, sizeof(SV_CONFIG_OPTION));
        SetSoundMode();
        PlayTimeCount(1);
        TitleScene->StopEnvBGM();
        INIT_LOOP_ARG arg;
        int           loop_no;
        InitOmakeEnv(omake_type, &arg, &loop_no);
        GyoraceSubGameInitData();

        if (omake_type == OMAKE_TYPE_DUNGEON) {
            TitleScene->skip_load_bgm = 1;
        }

        TitleOmakeOn();
        NextLoop(loop_no, arg);
        return 1;
    }

    if (TitleInfo->next_mode > TITLE_MODE_NONE) {
        switch (TitleInfo->next_mode) {
            case TITLE_MODE_RUSH_MOVIE:
                RushInfo.phase = RUSH_PHASE_INIT;
                break;
            case TITLE_MODE_COPYRIGHT:
                TitleCopyRightInit();
                break;
            case TITLE_MODE_MC_CHECK:
                TitleBootEventNo = 0;
                GetMainScene()->read_buff = DataBuffer.stGetTop();
                u_long128 *language_buffer = DataBuffer.stGetTop();
                read_buffer = language_buffer;
                LanguageChange(GetSelectLanguageNo(), language_buffer);
                TitleBootInit();
                TitleInfo->next_mode = TITLE_MODE_MC_CHECK;
                break;
            case TITLE_MODE_TITLE:
            case TITLE_MODE_TITLE_RETURN: {
                s16 select = TitleInfo->select;
                TitleModeInit();
                TitleInfo->select = TitleSelectInit;

                if (TitleInfo->next_mode == TITLE_MODE_TITLE_RETURN) {
                    TitleInfo->select = select;
                    TitleInfo->menu_alpha = 128.0f;
                    TitleInfo->cursor_alpha = 128.0f;
                    TitleInfo->title_alpha = 0.0f;
                    TitlePhase = TITLE_PHASE_MENU;
                }

                TitleInfo->next_mode = TITLE_MODE_TITLE;
                break;
            }
            case TITLE_MODE_MENU:
            case TITLE_MODE_SUBGAME_MENU: {
                TitleScene->StopEnvBGM();

                if (TitleInfo->next_mode == TITLE_MODE_MENU) {
                    TitleScene->GetActiveBgmStatus(&TitleInfo->bgm_status);
                    TitleScene->StopBGM(0);
                    TitleScene->LoadBGM(0x30, TitleScene->read_buff);
                    TitleScene->PlayBGM(0, -1, 1.0f);
                } else {
                    CSubGameData *sub_game = GetSubGameSaveData();

                    if (sub_game != NULL) {
                        sub_game->Initialize();
                    }
                }

                TitleProjection = 800.0f;
                memcpy(&GetSaveData()->config, &TitleInfo->config, sizeof(SV_CONFIG_OPTION));
                Stack_ReadBuff.stReset();
                mgCMemory  menu_stack;
                int        rest = Stack_ReadBuff.stGetRest();
                u_long128 *top = Stack_ReadBuff.stGetTop();
                menu_stack.stSetBuffer(top, rest);
                Stack_ReadBuff.Alloc(0x40000);
                MenuArg.stack = &menu_stack;
                MenuArg.chara_stack = &Stack_MenuCharaBuff_Fix;
                MenuArg.base_chara_stack = TitleInfo->chara_stack;
                MenuMainInit(&MenuArg);
                break;
            }
            case TITLE_MODE_HDD_INSTALL:
                TitleScene->StopEnvBGM();
                TitleHDDInstallInit();
                break;
        }

        mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
        TitleInfo->mode = TitleInfo->next_mode;
        TitleInfo->next_mode = TITLE_MODE_NONE;
    }

    return result;
}

/**
 *
 * Draws the title phase currently selected by the title state.
 *
 */
void TitleDraw() {
    mgSetRenderInfo(TitleProjection, 3.0f, 30000.0f);

    switch (TitleInfo->mode) {
        case TITLE_MODE_LANG_SELECT:
            TitleLangSelDraw();
            break;
        case TITLE_MODE_MC_CHECK:
            TitleMCCheckDraw();
            break;
        case TITLE_MODE_COPYRIGHT:
            TitleCopyRightDraw();
            break;
        case TITLE_MODE_RUSH_MOVIE:
            RushMovieDraw();
            break;
        case TITLE_MODE_TITLE:
            TitleModeDraw();
            break;
        case TITLE_MODE_MENU:
        case TITLE_MODE_SUBGAME_MENU:
            MenuMainDraw();
            break;
        case TITLE_MODE_HDD_INSTALL:
            TitleHDDInstallDraw();
            break;
    }
}

/**
 *
 * Loads and starts the opening movie and resets its skip and fade state.
 *
 */
void InitRushMovie(int movie_no) {
    mgFrameRate = 2;
    TitleScene->StopEnvBGM();
    Stack_ReadBuff.stReset();
    mgTexManager.ReloadTexture(0x43, (sceVif1Packet *) NULL);
    mgCMemory  memory;
    int        remaining = Stack_ReadBuff.stGetRest();
    u_long128 *buffer = Stack_ReadBuff.stGetTop();
    memory.stSetBuffer(buffer, remaining);
    RushMovie->Load("RUSH.PSS", &memory, 512, 416, true, false);
    RushMovie->Play(at_1234);
    RushMovie->SwitchThread();

    while (RushMovie->IsStarted() == 0) {
        RushMovie->SwitchThread();
    }

    RushInfo.count = 0;
    RushInfo.unk_10 = 0x3FFF;
    RushInfo.skipped = 0;
    RushInfo.unk_c = 0;
    TitleScene->fade.Initialize();
    RushInfo.push_alpha = 0.0f;
    TitlePushStart_AlphaPlus = 1;
    debug_start_drawflag = 0;
}

/**
 *
 * Advances the opening movie and handles skip input and its exit result.
 *
 */
int RushMovieKey() {
    switch (RushInfo.phase) {
        case RUSH_PHASE_INIT:
            InitRushMovie(RushInfo.movie_no);
            break;
        case RUSH_PHASE_PLAY: {
            int end = 0;
            int pressed = 0;

            if (GamePad__2.Down(PAD_START) || GamePad__2.Down(PAD_CIRCLE) || GamePad__2.Down(PAD_CROSS)) {
                pressed = 1;
                RushInfo.skipped = pressed;
                DCSelectedMovie = pressed;
            }

            if ((RushInfo.count > 0 && pressed) || RushMovie->EndCheck()) {
                end = 1;
            }

            if (DebugFlag != 0 && GamePad__2.Down(PAD_R1 | PAD_R2)) {
                debug_start_drawflag ^= 1;
            }

            if (end) {
                TitleScene->fade.Initialize();
                TitleScene->fade.FadeOut(50, 0.0f, 0.0f, 0.0f);
                RushInfo.phase = RUSH_PHASE_FADE_OUT;
            }

            break;
        }
        case RUSH_PHASE_FADE_OUT:
            if (TitleScene->fade.FadeCheck() || RushMovie->EndCheck()) {
                RushInfo.phase = RUSH_PHASE_END;

                if (DCRuncherMode != 0) {
                    if (DCSelectedMovie == 0 && LanguageCode == 1) {
                        return TITLE_KEY_DEMO_TIMEOUT;
                    }

                    if (DCSelectedMovie == 1) {
                        DCRuncherCounter = 0;
                    }
                }

                if (TitleBootEventNo == 1) {
                    return TITLE_KEY_RUSH_MOVIE;
                }

                return TITLE_KEY_START_GAME;
            }

            break;
        case RUSH_PHASE_END:
            break;
    }

    RushInfo.count++;

    if (RushInfo.count > 750) {
        CalcPushAlpha(1, &RushInfo.push_alpha);
    }

    return 0;
}

/**
 *
 * Draws the opening movie and its overlays for the current movie phase.
 *
 */
void RushMovieDraw() {
    mgTexManager.ReloadTexture(0x43, (sceVif1Packet *) NULL);
    RushMovie->SwitchThread();

    switch (RushInfo.phase) {
        case RUSH_PHASE_INIT:
            RushInfo.phase = RUSH_PHASE_PLAY;
            break;
        case RUSH_PHASE_FADE_OUT:
        case RUSH_PHASE_PLAY:
        case RUSH_PHASE_END: {
            CPreSprite sprite;
            sprite.Initialize(NULL, NULL);
            sprite.Preset2D();
            sprite.AlphaBlendEnable(0);
            sprite.TextureMapEnable(1);
            sprite.Begin(MG_PRIM_SPRITE);
            sprite.Color(0, 0, 0, 128);
            sprite.SetIRect(0, 0, mgScreenWidth, mgScreenHeight, 0, 0);
            sprite.Texture(RushWork);
            sprite.Color(128, 128, 128, 128);
            sprite.SetIStretch(0, 0, mgScreenWidth, mgScreenHeight, 0, 0, mgScreenWidth, 416);
            sprite.End();
            break;
        }
    }

    if (RushInfo.phase == RUSH_PHASE_END) {
        RushInfo.phase = RUSH_PHASE_INIT;
        RushMovie->Term();
        RushMovie->SwitchThread();
    }
}

/**
 *
 * Sets up the title menu, its scene, cursor, and initial fade.
 *
 */
void TitleModeInit() {
    TitleScene->PlayEnvBgm();
    mgFrameRate = 1;
    TitleInfo->select = 0;
    TitlePhase = TITLE_PHASE_WAIT;
    TitleInfo->idle_count = 0;
    TitleScene->fade.Initialize();
    TitleScene->fade.FadeIn(100);
    TitleScene->fade.FadeStep();
    TitleInfo->menu_alpha = 0.0f;
    TitleInfo->cursor_alpha = 0.0f;
    TitleInfo->wait_count = 200;
    TitleInfo->title_alpha = 0.0f;
    TitleInfo->omake_alpha = 0.0f;
    TitleInfo->push_alpha = 0.0f;
    Stack_ReadBuff.stack_used = 0;
    TitlePushStart_AlphaPlus = 0;
    Stack_ReadBuff.lock = 0;
    TitleMCCheck->InitForMC();
    TitleMCActivePort = 0;
    TitleMCCheck->port = 0;
    TitleMCCheck->SetFuncNo(MC_FUNC_SEARCH_TYPE);
    E3Select = 0;
    E3_Title_SpriteY = 34.0f;
    E3ModeBoardDrawFlag = 0;
    E3_Trial_SpriteY = 236.0f;
    E3ModeBoardDrawAlpha = 0;
    TitleRushWaitCount = 1250;
    Trial_TitleBlackFadeAlpha = 0;
    DCSelectedMovie = 0;

    if (TitleRushWaitCountBoot == 0) {
        TitleRushWaitCount = 750;
        TitleRushWaitCountBoot = 1;
    }

    TitleCameraPhase = 0;
    TitleProjection = 480.0f;

    if (TitleCamera != NULL) {
        TitleCamera->FollowOn();
        sceVu0FVECTOR position = {1.2f, 2.3f, 550.0f, 1.0f};
        sceVu0FVECTOR follow = {-70.1f, 280.8f, -493.0f, 1.0f};
        TitleCamera->SetPos(position);
        TitleCamera->SetNextPos(position);
        TitleCamera->SetFollow(follow[0], follow[1], follow[2]);
        TitleCamera->SetDistance(1300.0f);
        TitleCamera->SetHeight(-214.0f);
        TitleCamera->SetAngle(0.0f);
        TitleCamera->Resume();
        TitleCamera->Step(-1);
    }

    if (TitleCamera2 != NULL) {
        TitleCamera2->Resume();
    }
}

/**
 *
 * Updates card detection, title menu input, fades, and attract-movie timing.
 *
 */
static int TitleModeKey() {
    int start_pushed;
    int start;
    int push;
    int result = TITLE_KEY_NONE;
    int step = DCTitleStep(1);
    if (TitleInfo->idle_count > TitleRushWaitCount || step == 2) {
        if (TitleScene->fade.FadeCheck() != 0) {
            result = TITLE_KEY_RUSH_MOVIE;
        }
        return result;
    }
    if (step == 1) {
        TitleScene->fade.FadeOut(0x28, 0.0f, 0.0f, 0.0f);
        return TITLE_KEY_NONE;
    }
    if (TitlePhase <= TITLE_PHASE_MENU || TitlePhase == TITLE_PHASE_PUSH_START || TitlePhase == TITLE_PHASE_OMAKE_MENU ||
        TitlePhase == TITLE_PHASE_MC_MESSAGE) {
        CMemoryCardManager *card_manager = TitleMCCheck;
        MC_CARD_INFO       *cards[2];
        u8                  inport[2];
        cards[0] = &card_manager->card[0];
        cards[1] = &card_manager->card[1];
        inport[0] = TitleMCCheckInport[0];
        inport[1] = TitleMCCheckInport[1];
        if (TitleMCCheckNow != 0) {
            switch (TitleMainMCCheckPhase) {
                case 0:
                    TitleMCCheckInit(0);
                    TitleMainMCCheckPhase = 1;
                    break;
                case 1:
                    if (TitleMCCheckKey() != 0) {
                        TitleMCCheckMes = NULL;
                        TitleMCCheckNow = 0;
                        TitleMCActivePort = 0;
                        TitleMCCheck->port = 0;
                        TitleMCCheck->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                        TitleInfo->omake_select = 0;
                        if (TitlePhase == TITLE_PHASE_OMAKE_MENU) {
                            TitlePhase = TITLE_PHASE_MENU;
                            TitleInfo->select = TITLE_MENU_OMAKE;
                            TitleInfo->omake_alpha = 0.0f;
                        }
                    }
                    break;
            }
            return TITLE_KEY_NONE;
        }
        int port_done = card_manager->Step();
        int card_lost = 0;
        if (inport[0] != McCheckMCPs2(cards[0])) {
            TitleMCCheckInport[0] = 0;
            card_lost = 1;
        }
        if (inport[1] != McCheckMCPs2(cards[1])) {
            memset(cards[1], 0, sizeof(MC_CARD_INFO));
            TitleMCCheckInport[1] = 0;
            card_lost = 1;
        }
        if (card_lost != 0) {
            TitleMainMCCheckPhase = 0;
            TitleMCCheckNow = 1;
            TitleMCActivePort = 0;
            return TITLE_KEY_NONE;
        }
        if (port_done != 0) {
            if (TitleMCActivePort == 0) {
                TitleMCActivePort = 1;
            } else {
                TitleMCActivePort = 0;
            }
            TitleMCCheck->port = TitleMCActivePort;
            TitleMCCheck->SetFuncNo(MC_FUNC_SEARCH_TYPE);
        }
    }
    push = ConvertCheckPushButton(MenuCheckPushButton());
    if (TitlePhase <= TITLE_PHASE_PUSH_START) {
        TitleInfo->idle_count++;
    }
    start = push & MENU_PUSH_BUTTON_START;
    start_pushed = 0;
    if (start != 0) {
        start_pushed = 1;
    }
    int fade_done = TitleScene->fade.FadeCheck();
    switch (TitlePhase) {
        case TITLE_PHASE_WAIT:
            TitlePushStart_AlphaPlus = 0;
            if (start_pushed != 0) {
                TitlePhase = TITLE_PHASE_PUSH_START;
                TitleInfo->title_alpha = 128.0f;
                TitlePushStart_AlphaPlus = 1;
                sndSePlay(TitleEventSound, 0, 0);
            }
            TitleInfo->wait_count--;
            if (TitleInfo->wait_count <= 0) {
                TitlePhase = TITLE_PHASE_FADE_IN;
            }
            break;
        case TITLE_PHASE_FADE_IN:
            TitlePushStart_AlphaPlus = 0;
            if (TitleInfo->title_alpha < 128.0f) {
                CalcMenuAdd(&TitleInfo->title_alpha, 0.53f, 128.0f);
            }
            if (start_pushed != 0) {
                sndSePlay(TitleEventSound, 0, 0);
                TitleInfo->title_alpha = 128.0f;
            }
            if (128.0f <= TitleInfo->title_alpha) {
                TitlePhase = TITLE_PHASE_PUSH_START;
                TitlePushStart_AlphaPlus = 1;
            }
            break;
        case TITLE_PHASE_PUSH_START:
            CalcMenuAdd(&TitleInfo->menu_alpha, -12.0f, 0.0f);
            CalcMenuAdd(&TitleInfo->cursor_alpha, -12.0f, 0.0f);
            CalcMenuAdd(&TitleInfo->title_alpha, 8.0f, 128.0f);
            CalcMenuAdd(&TitleInfo->omake_alpha, -8.0f, 0.0f);
            if (start_pushed != 0) {
                sndSePlay(TitleEventSound, 0, 0);
                TitlePhase = TITLE_PHASE_MENU;
                TitleInfo->idle_count = 0;
            }
            break;
        case TITLE_PHASE_MENU: {
            TitlePushStart_AlphaPlus = 0;
            int old_select = TitleInfo->select;
            CalcMenuAdd(&TitleInfo->title_alpha, -8.0f, 0.0f);
            CalcMenuAdd(&TitleInfo->menu_alpha, 12.0f, 128.0f);
            CalcMenuAdd(&TitleInfo->cursor_alpha, 12.0f, 128.0f);
            if (GamePad__2.Down(PAD_UP) != 0) {
                TitleInfo->select--;
            }
            if (GamePad__2.Down(PAD_DOWN) != 0) {
                TitleInfo->select++;
            }
            if (TitleInfo->select < 0) {
                TitleInfo->select = 0;
            }
            if (TitleHDDCheckFlag != 0) {
                if (TitleInfo->select > TITLE_MENU_HDD_INSTALL) {
                    TitleInfo->select = TITLE_MENU_HDD_INSTALL;
                }
            } else {
                if (TitleInfo->select > TITLE_MENU_OPTION) {
                    TitleInfo->select = TITLE_MENU_OPTION;
                }
            }
            if (old_select != TitleInfo->select) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                TitleInfo->idle_count = 0;
            }
            if ((push & MENU_PUSH_BUTTON_DECIDE) || start != 0) {
                if (TitleInfo->select == TITLE_MENU_NEW_GAME) {
                    TitlePhase = TITLE_PHASE_NEW_GAME;
                    TitleScene->fade.FadeOut(0x28, 0.0f, 0.0f, 0.0f);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    TitleInfo->menu_alpha = 128.0f;
                    TitleInfo->cursor_alpha = 128.0f;
                } else if (TitleInfo->select == TITLE_MENU_CONTINUE) {
                    TitlePhase = TITLE_PHASE_CONTINUE;
                    TitleScene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                } else if (TitleInfo->select == TITLE_MENU_HDD_INSTALL) {
                    if (0 < HDDINFO.connect) {
                        TitlePhase = TITLE_PHASE_HDD_INSTALL;
                        TitleScene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    } else {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    }
                } else if (TitleInfo->select == TITLE_MENU_OPTION) {
                    TitlePhase = TITLE_PHASE_OPTION;
                    TitleScene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                } else if (TitleInfo->select == TITLE_MENU_OMAKE && OmakePlayEnableAttr != 0) {
                    TitlePhase = TITLE_PHASE_OMAKE_MENU;
                    TitleInfo->omake_alpha = 128.0f;
                    TitleInfo->omake_select = 0;
                    TitleInfo->omake_num = 0;
                    TitleInfo->omake_dungeon = 0;
                    TitleInfo->omake_gyorace = 0;
                    if (OmakePlayEnableAttr & OMAKE_ENABLE_DUNGEON) {
                        TitleInfo->omake_num++;
                        TitleInfo->omake_dungeon = 1;
                    }
                    if (OmakePlayEnableAttr & OMAKE_ENABLE_GYORACE) {
                        TitleInfo->omake_num++;
                        TitleInfo->omake_gyorace = 1;
                    }
                    MenuSePlay(SYSTEM_SE_DECIDE);
                } else {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
            } else if (push & MENU_PUSH_BUTTON_CANCEL) {
                TitlePhase = TITLE_PHASE_PUSH_START;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
        }
        case TITLE_PHASE_NEW_GAME:
            TitlePushStart_AlphaPlus = 0;
            if (fade_done != 0) {
                return TITLE_KEY_NEW_GAME;
            }
            break;
        case TITLE_PHASE_CONTINUE:
            TitlePushStart_AlphaPlus = 0;
            if (fade_done != 0) {
                return TITLE_KEY_CONTINUE;
            }
            break;
        case TITLE_PHASE_OPTION:
        case TITLE_PHASE_UNUSED_6:
        case TITLE_PHASE_OMAKE:
            TitlePushStart_AlphaPlus = 0;
            if (fade_done != 0) {
                if (TitlePhase == TITLE_PHASE_OPTION) {
                    return TITLE_KEY_OPTION;
                }
                if (TitlePhase == TITLE_PHASE_OMAKE) {
                    return TITLE_KEY_OMAKE;
                }
            }
            break;
        case TITLE_PHASE_HDD_INSTALL:
            TitlePushStart_AlphaPlus = 0;
            if (fade_done != 0) {
                return TITLE_KEY_HDD_INSTALL;
            }
            break;
        case TITLE_PHASE_OMAKE_MENU: {
            TitlePushStart_AlphaPlus = 0;
            CalcMenuAdd(&TitleInfo->menu_alpha, -8.0f, 0.0f);
            CalcMenuAdd(&TitleInfo->cursor_alpha, 3.0f, 128.0f);
            int old_select = TitleInfo->omake_select;
            if (GamePad__2.Down(PAD_UP) != 0) {
                TitleInfo->omake_select--;
            }
            if (GamePad__2.Down(PAD_DOWN) != 0) {
                TitleInfo->omake_select++;
            }
            if (TitleInfo->omake_select < 0) {
                TitleInfo->omake_select = 0;
            }
            if (TitleInfo->omake_num <= TitleInfo->omake_select) {
                TitleInfo->omake_select = TitleInfo->omake_num - 1;
            }
            if (old_select != TitleInfo->omake_select) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                TitleInfo->idle_count = 0;
            }
            if (push & MENU_PUSH_BUTTON_DECIDE) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                TitlePhase = TITLE_PHASE_OMAKE;
                TitleScene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
            } else if (push & MENU_PUSH_BUTTON_CANCEL) {
                TitlePhase = TITLE_PHASE_MENU;
                TitleInfo->omake_alpha = 0.0f;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
        }
        case TITLE_PHASE_MC_MESSAGE:
            if ((push & MENU_PUSH_BUTTON_CANCEL) || (push & MENU_PUSH_BUTTON_DECIDE)) {
                TitlePhase = TITLE_PHASE_MENU;
                TitleMCCheckMes = NULL;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
    }
    CalcPushAlpha(0, &TitleInfo->push_alpha);
    if (TitleInfo->idle_count == TitleRushWaitCount) {
        TitleScene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
    }
    return TITLE_KEY_NONE;
}
void TitleModeDraw() {
    // PUSH START texture rectangles indexed by the selected language.
    static MENU_SHORT_RECT start_button_tbl[7] = {
        {0, 22, 196, 18},
        {0, 22, 196, 18},
        {0, 18, 196, 22},
        {0, 18, 196, 22},
        {0, 20, 196, 20},
        {0, 18, 196, 22},
        {0, 22, 196, 18},
    };

    // Texture origins for the five title menu rows.
    static s16 btn_tblxy[5][2] = {
        {302, 40},
        {302, 94},
        {302, 256},
        {302, 204},
        {302, 148},
    };

    int i;
    int x;
    int y;
    int row_num;
    int row_y[2];
    int row;
    TitleMapDraw();
    mgTexManager.ReloadTexture(0x40, (sceVif1Packet *) NULL);
    mgCDrawPrim prim;
    SetSpriteEnv(&prim, 0);
    float left = 0.0f;
    float top = 24.0f;
    float title_alpha = TitleInfo->title_alpha;
    PrimQuad(Tex_Chronicle, 0.0f, top, mgRect<int>(0, 0, 0x200, 0x1A0), fptosi(TitleInfo->title_alpha), 0x80, 0x80, 0x80);
    mgRect<int> start_rect(start_button_tbl[LanguageCode].left, start_button_tbl[LanguageCode].top,
                           start_button_tbl[LanguageCode].right, start_button_tbl[LanguageCode].bottom);

    if (LanguageCode == 0) {
        prim.Bilinear(1);
        prim.Begin(6);
        prim.Texture(Tex_Logo);
        prim.Color(0x80, 0x80, 0x80, fptosi(TitleInfo->push_alpha));
        PrimQuad(&prim, 162.0f, 338.0f, start_rect);
        prim.Color(0x80, 0x80, 0x80, fptosi(TitleInfo->title_alpha));
        PrimQuad(&prim, 84.0f, 384.0f, mgRect<int>(0, 0, 0x166, 0x16));
        prim.End();
    } else {
        prim.Bilinear(0);
        prim.Begin(6);
        prim.Texture(Tex_Logo);
        prim.Color(0x80, 0x80, 0x80, fptosi(TitleInfo->push_alpha));
        PrimQuad(&prim, 162.0f, (float) (mgScreenHeight - 0x6C), start_rect);
        prim.Color(0x80, 0x80, 0x80, fptosi(TitleInfo->title_alpha));
        PrimQuad(&prim, left, (float) (mgScreenHeight - 0x38), mgRect<int>(0, 0x180, 0x200, 0x30));
        prim.End();
    }

    mgRect<int> button_rect(0x12E, 0x28, 0xD2, 0x36);
    float       cursor_goal_y = 0.0f;
    y = 0x4C;
    row_num = 5;
    x = (mgScreenWidth - button_rect.right) >> 1;

    if (TitleHDDCheckFlag == 0) {
        y = 0x64;
        row_num = 4;
    }

    prim.Bilinear(1);
    prim.Begin(6);
    prim.Texture(Tex_Logo);

    for (i = 0; i < row_num; i++) {
        prim.Color(0, 0, 0, fptosi(TitleInfo->menu_alpha / 3.0f));
        PrimQuad(&prim, (float) (x + 4), (float) (y + 4), button_rect);

        if ((i == TITLE_MENU_HDD_INSTALL && HDDINFO.connect == 0) || (i == TITLE_MENU_OMAKE && OmakePlayEnableAttr == 0)) {
            prim.Color(0x48, 0x48, 0x48, fptosi(TitleInfo->menu_alpha));
        } else {
            prim.Color(0x80, 0x80, 0x80, fptosi(TitleInfo->menu_alpha));
        }

        button_rect.left = btn_tblxy[i][0];
        button_rect.top = btn_tblxy[i][1];
        PrimQuad(&prim, (float) x, (float) y, button_rect);

        if (i == TitleInfo->select) {
            cursor_goal_y = (float) y;
        }

        y += 0x3A;
    }

    prim.End();

    if (0.0f < TitleInfo->omake_alpha) {
        prim.TextureMapEnable(1);
        prim.Begin(6);
        prim.Texture(Tex_Logo);
        row = 0;
        row_y[0] = 0xD0 - TitleInfo->omake_num * 0x1B;
        row_y[1] = row_y[0] + 0x3C;
        cursor_goal_y = (float) row_y[TitleInfo->omake_select];
        prim.Color(0x80, 0x80, 0x80, (int) TitleInfo->omake_alpha);

        if (OmakePlayEnableAttr & 2) {
            mgRect<int> dungeon_rect(0x5C, 0x100, 0xD2, 0x36);
            PrimQuad(&prim, 151.0f, (float) row_y[row++], dungeon_rect);
        }

        if (OmakePlayEnableAttr & 1) {
            mgRect<int> gyorace_rect(0x5C, 0xCA, 0xD2, 0x36);
            PrimQuad(&prim, 151.0f, (float) row_y[row], gyorace_rect);
        }

        prim.End();
    }

    TitleInfo->cursor_x = (float) (x - 0x20);
    CalcMenu1(cursor_goal_y, &TitleInfo->cursor_y, 4.0f, 0.0f, 0);

    if (TitleInfo->cursor_y <= 60.0f) {
        TitleInfo->cursor_y = cursor_goal_y;
    }

    float sway_x = mgAngleLimit(0.05235988f * (float) TitleInfo->cursor_count);
    float sway_y = mgAngleLimit(0.10471976f * (float) TitleInfo->cursor_count);
    float cursor_x = TitleInfo->cursor_x + 6.0f * cosf(sway_x);
    float cursor_y = 11.0f + TitleInfo->cursor_y + 4.0f * sinf(sway_y);

    if (TitleMCCheckNow == 0) {
        PrimQuad(Tex_Logo, cursor_x, cursor_y, mgRect<int>(0, 0x28, 0x28, 0x18), fptosi(TitleInfo->cursor_alpha), 0x80, 0x80, 0x80);
    }

    if (TitleMCCheckNow != 0 || TitlePhase == 0x14) {
        TitleMCCheckDraw();
    }

    TitleInfo->cursor_count++;

    if (TitleInfo->cursor_count > 10000000) {
        TitleInfo->cursor_count = 0;
    }
}

void TitleMapDraw() {
    float              pos[4];
    float              ref[4];
    float              view[4][4];
    mgCTextureManager *textures = &mgTexManager;

    mgFogEnable(1);
    mgCCamera *camera = TitleScene->GetCamera(TitleScene->active_camera);
    camera->Step(1);
    camera->GetCameraMatrix(view);
    camera->GetPos(pos);
    camera->GetRef(ref);
    mgSetViewMatrix(view, pos);
    CMapLightingInfo  info;
    CMapLightingInfo *lighting = &info;

    if (TitleMap != NULL) {
        TitleMap->GetLightInfo(lighting);

        if (lighting != NULL) {
            lighting->ambient[0] *= 1.5f;
            lighting->ambient[1] *= 1.5f;
            lighting->ambient[2] *= 1.5f;

            if (255.0f < lighting->ambient[0]) {
                lighting->ambient[0] = 255.0f;
            }

            if (255.0f < lighting->ambient[1]) {
                lighting->ambient[1] = 255.0f;
            }

            if (255.0f < lighting->ambient[2]) {
                lighting->ambient[2] = 255.0f;
            }
        }

        if (lighting != NULL) {
            mgFogEnable(lighting->fog_enable);

            if (lighting->fog_enable != 0) {
                mgSetFogParam(lighting->fog.near_dist, lighting->fog.far_dist, lighting->fog.r, lighting->fog.g, lighting->fog.b, lighting->fog.far_value, lighting->fog.near_value);
            }

            mgSetLight(lighting->light_dir, lighting->light_color);
            mgSetAmbient(lighting->ambient);

            if (lighting->plight_enable != 0) {
                mgPlightEnable(1);

                for (int light = 0; light < 4; light++) {
                    mgSetPlight(light, &lighting->point_light[light]);
                }
            }

            mgSetBackGround(lighting->bg_color);
        }
    }

    int texture_group;

    if (TitleMap != NULL) {
        int texture_order[72];
        TitleWorkBuffer.stack_used = 0;
        TitleWorkBuffer.lock = 0;

        for (int block = 0; block < 64; block++) {
            texture_order[block] = block;
        }

        texture_order[64] = -1;
        mgBeginDraw(&TitleWorkBuffer, texture_order, NULL);
        float view_pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
        int   texture_blocks[128];
        TitleMap->PreDraw(view_pos);
        TitleMap->Draw();
        mgCTexture *water = textures->GetTexture("water", -1);
        int         water_block = -1;

        if (water != NULL) {
            water_block = water->block;
            WaveTable__3->GetEffect();
        }

        mgPreEndDraw(NULL);

        for (int group = 0; group < 6; group++) {
            int i;
            int block;
            int block_count;
            block_count = TitleScene->GetTextureBlockNo(group, texture_blocks, 128);

            for (i = 0; block_count > i; i++) {
                int index = block_count - i - 1;
                block = texture_blocks[index];

                if (0 != mgEndDrawReloadTexture(block, NULL) && texture_blocks[index] == water_block) {
                    WaveTable__3->CreateTexture(water);
                }

                mgEndDraw(block, NULL);
            }
        }

        mgSetPkTextureRepeat(0);
    }

    for (texture_group = 6; texture_group < 16; texture_group++) {
        int later_blocks[128];
        int i;
        int block;
        int block_count;
        block_count = TitleScene->GetTextureBlockNo(texture_group, later_blocks, 128);

        for (i = 0; block_count > i; i++) {
            block = later_blocks[i];
            mgEndDrawReloadTexture(block, NULL);
            mgEndDraw(block, NULL);
        }
    }

    mgSetPkTextureRepeat(0);
    mgCTexture      *screen = textures->GetTexture(at_1223__4, 0x6A);
    mgCTexture      *overlay = textures->GetTexture("ref", 0x6A);
    mgCCameraFollow *follow = (mgCCameraFollow *) camera;
    mgCCamera       *water_camera = TitleScene->GetCamera(TitleScene->active_camera);

    if (TitleMap != NULL) {
        TitleMap->DrawWater(water_camera, screen, overlay);
    }

    switch (TitleCameraPhase) {
        case 0: {
            follow->AddDistance(-0.25f);
            float distance = follow->GetDistance();

            if (distance < 1100.0f) {
                follow->AddHeight(0.04f);
            }

            if (distance < 1000.0f) {
                follow->AddHeight(0.05f);
            }

            if (distance < 900.0f) {
                follow->AddHeight(0.05f);
            }

            if (distance < 800.0f) {
                TitleCameraPhaseCounter = 0;
                TitleCameraAddAngle = 0.0f;
                TitleCameraPhase++;
            }

            break;
        }
        case 1:
            TitleCameraPhaseCounter++;

            if ((u_int) TitleCameraPhaseCounter > 250) {
                follow->FollowOff();
                TitleCameraPhaseCounter = 0;
                TitleCameraAddAngle = 0.0f;
                TitleCameraPhase++;
            }

            break;
        case 2: {
            float follow_pos[4];
            float follow_ref[4];
            float distance = follow->GetDistance();
            follow->GetPos(follow_pos);
            follow->GetRef(follow_ref);
            float angle = mgAngleLimit(TitleCameraAddAngle);
            follow_ref[0] = follow_pos[0] + distance * sinf(angle);
            follow_ref[2] = follow_pos[2] - distance * cosf(angle);
            follow->SetAngle(angle);
            follow->SetRef(follow_ref);
            TitleCameraAddAngle += 0.0008726647f;

            if (!(TitleCameraAddAngle < 6.2831855f)) {
                TitleCameraPhaseCounter = 0;
                TitleCameraPhase = 1;
                TitleScene->active_camera = 0;
                follow->FollowOn();
            }

            break;
        }
    }
}

/**
 *
 * Updates the pulsing alpha used by the title start prompt.
 *
 */
void CalcPushAlpha(int index, float *alpha) {
    // Sets the rising alpha pulse speed for the title and attract movie prompts.
    static s8 cnttbl[2] = {2, 4};

    if (TitlePushStart_AlphaPlus != 0) {
        *alpha += cnttbl[index];

        if (128.0f <= *alpha) {
            *alpha = 128.0f;
            TitlePushStart_AlphaPlus = 0;
        }
    } else {
        *alpha -= cnttbl[index] + 2;

        if (*alpha < 0.0f) {
            *alpha = 0.0f;
            TitlePushStart_AlphaPlus = 1;
        }
    }
}

/**
 *
 * Starts the title memory card check for the selected boot mode.
 *
 */
void TitleMCCheckInit(int boot_mode) {
    TitleMCCheckBootMode = boot_mode != 0;
    OmakePlayEnableAttr = 0;
    CostumeOptionEnv = 0;

    if (&TitleMCCheck->card[0] != NULL) {
        memset(&TitleMCCheck->card[0], 0, sizeof(MC_CARD_INFO));
    }

    if (&TitleMCCheck->card[1] != NULL) {
        memset(&TitleMCCheck->card[1], 0, sizeof(MC_CARD_INFO));
    }

    TitleMCCheckPort = 0;
    TitleMCCheck->port = 0;
    TitleMCCheck->SetFuncNo(MC_FUNC_SEARCH_TYPE);
    TitleMCCheckFileFind[0] = 0;
    TitleMCCheckInport[0] = 0;
    TitleMCCheckPhase = TITLE_MC_PHASE_CARD_1;
    TitleMCCheckFileFind[1] = 0;
    TitleMCCheckInport[1] = 0;
    TitleMCCheckMes = GetSystemMessage(0);
    TitleMCCheckMes->texture_block = 0x46;
    TitleMCCheckMes->Preset(MES_PRESET_WINDOW);
    TitleMCCheckMes->SetWindowMode(4);
    TitleMCCheckMes->fukidashi_pos = 8;
    TitleMCCheckMes->mes_no = -1;

    if (TitleMCCheckMes != NULL) {
        TitleMCCheckMes->MakeMesWin(0x66);
    }
}

int TitleMCCheckKey() {
    MC_CARD_INFO *cards[2];
    u8            inserted[2];
    cards[0] = &TitleMCCheck->card[0];
    cards[1] = &TitleMCCheck->card[1];
    int busy = TitleMCCheck->Step();
    inserted[0] = McCheckMCPs2(cards[0]) != 0;
    inserted[1] = McCheckMCPs2(cards[1]) != 0;
    int result = -1;

    switch (TitleMCCheckPhase) {
        case TITLE_MC_PHASE_CARD_1:
        case TITLE_MC_PHASE_CARD_2:
            if (busy) {
                if (inserted[TitleMCCheckPort] == 1) {
                    TitleMCCheckInport[TitleMCCheckPort] = 1;
                    TitleMCCheckPhase++;
                    TitleMCCheck->port = TitleMCCheckPort;
                    TitleMCCheck->InitPlayDataInfo();
                    TitleMCCheck->SetFuncNo(MC_FUNC_GET_ALL_FILE_INFO);
                } else {
                    TitleMCCheckInport[TitleMCCheckPort] = 0;
                    TitleMCCheck->InitPlayDataInfo();
                    TitleMCCheckPort++;
                    TitleMCCheckPhase += 3;

                    if (TitleMCCheckPort > 1) {
                        result = TITLE_MC_PHASE_END;
                    } else {
                        TitleMCCheck->port = TitleMCCheckPort;
                        TitleMCCheck->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                    }
                }
            }

            break;
        case TITLE_MC_PHASE_FILES_1:
        case TITLE_MC_PHASE_FILES_2:
            if (busy) {
                TitleMCCheckFileFind[TitleMCCheckPort] = TitleMCCheck->CheckDataFileNum();
                u_long costume_bit = 0;
                OmakePlayEnableAttr |= TitleMCCheck->CheckOmake(&costume_bit);
                CostumeOptionEnv |= costume_bit;

                if (TitleMCCheckBootMode != 0 && MasterDebugModeOn == 0) {
                    MasterDebugModeOn = TitleMCCheck->CheckDebugCode() != 0;
                }

                TitleMCCheck->SetFuncNo(MC_FUNC_CHECK_OMAKE);
                TitleMCCheckPhase++;
            }

            break;
        case TITLE_MC_PHASE_OMAKE_1:
        case TITLE_MC_PHASE_OMAKE_2:
            if (busy) {
                CMemoryCardManager *manager = TitleMCCheck;
                int                *found = &manager->file_exists;

                if (*found != 0) {
                    if (found[1] & 1) {
                        OmakePlayEnableAttr |= 2;
                    }

                    if (found[1] & 2) {
                        OmakePlayEnableAttr |= 1;
                    }
                }

                TitleMCCheckPort++;

                if (TitleMCCheckPort > 1) {
                    result = TITLE_MC_PHASE_END;
                } else {
                    TitleMCCheck->port = TitleMCCheckPort;
                    TitleMCCheck->SetFuncNo(MC_FUNC_SEARCH_TYPE);
                }

                TitleMCCheckPhase++;
            }

            break;
        case TITLE_MC_PHASE_END:
            if (TitleMCCheckBootMode == 1) {
                int push = MenuCheckPushButton();

                if (push & MENU_PUSH_BUTTON_DECIDE) {
                    if (LanguageCode == 0) {
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }

                    return 1;
                }

                if (push & MENU_PUSH_BUTTON_CANCEL) {
                    result = 0;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
            } else {
                return 1;
            }

            break;
    }

    switch (result) {
        case 0:
            TitleMCCheckPort = 0;
            TitleMCCheck->port = 0;
            TitleMCCheck->SetFuncNo(MC_FUNC_SEARCH_TYPE);
            TitleMCCheckPort = 0;
            TitleMCCheckPhase = 0;
            TitleMCCheckMes->MakeMesWin(0x66);
            break;
        case TITLE_MC_PHASE_END:
            if (!inserted[0] && !inserted[1]) {
                if (TitleMCCheckBootMode != 0) {
                    TitleMCCheckMes->MakeMesWin(0x64);
                }
            } else {
                int need_size = TitleMCCheck->GetSaveDataSize(0) / 1024 + 3;
                int has_space = 0;

                for (int i = 0; i < 2; i++) {
                    if ((inserted[i] && McCheckMCPs2Boot(cards[i], need_size) != 0) || 0 < TitleMCCheckFileFind[i]) {
                        has_space = 1;
                    }
                }

                int unformatted = 0;

                if ((cards[0]->present != 0 && cards[0]->type == 2 && cards[0]->formatted == 0) ||
                    (cards[1]->present != 0 && cards[1]->type == 2 && cards[1]->formatted == 0)) {
                    unformatted = 1;
                }

                if (TitleMCCheckFileFind[0] != 0 || TitleMCCheckFileFind[1] != 0) {
                    TitleSelectInit = 1;
                }

                if (TitleMCCheckBootMode != 0 && MasterDebugCode == MASTER_DEBUG_CODE && MasterDebugModeOn != 0) {
                    GamePad__2.DebugKeyLock(0);
                }

                if (has_space || unformatted) {
                    return 1;
                }

                if (TitleMCCheckBootMode != 0) {
                    TitleMCCheckMes->MakeMesWin(0x65);
                }
            }

            TitleMCCheckPhase = TITLE_MC_PHASE_END;
            break;
    }

    return 0;
}

/**
 *
 * Draws the title memory card check message.
 *
 */
void TitleMCCheckDraw() {
    if (TitleMCCheckMes != NULL) {
        mgTexManager.ReloadTexture(0x46, (sceVif1Packet *) NULL);
        TitleMCCheckMes->Step();
        TitleMCCheckMes->DrawMesWin();
    }
}

/**
 *
 * Returns the demo runner title transition result for a phase.
 *
 */
s32 DCTitleStep(s32 phase) {
    return 0;
}

/**
 *
 * Resets the copyright display and begins its opening fade.
 *
 */
void TitleCopyRightInit() {
    TitleCopyRightDispPhase = 0;
    TitleCopyRightDispCounter = 0;
    TitleScene->fade.Initialize();
    TitleCopyRightDispPhase = COPYRIGHT_PHASE_FADE_OUT;
    TitleScene->fade.FadeOut(1, 0.0f, 0.0f, 0.0f);
}

/**
 *
 * Advances the copyright display and reports when it ends.
 *
 */
int TitleCopyRightStep() {
    switch (TitleCopyRightDispPhase) {
        case COPYRIGHT_PHASE_DELAY:
            TitleCopyRightDispCounter++;

            if (TitleCopyRightDispCounter > 25) {
                TitleCopyRightDispCounter = 0;
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_FADE_IN;
                TitleScene->fade.FadeIn(50);
            }

            break;
        case COPYRIGHT_PHASE_TRIAL_WAIT:
            if (TitleScene->fade.FadeCheck() != 0) {
                TitleCopyRightDispCounter = 0;
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_TRIAL_SHOW;
            }

            break;
        case COPYRIGHT_PHASE_TRIAL_SHOW:
            TitleCopyRightDispCounter++;

            if (TitleCopyRightDispCounter > 75) {
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_TRIAL_FADE_OUT;
                TitleScene->fade.FadeOut(20, 0.0f, 0.0f, 0.0f);
            }

            break;
        case COPYRIGHT_PHASE_TRIAL_FADE_OUT:
            if (TitleScene->fade.FadeCheck() != 0) {
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_FADE_IN;
                TitleScene->fade.FadeIn(30);
            }

            break;
        case COPYRIGHT_PHASE_FADE_IN:
            if (TitleScene->fade.FadeCheck() != 0) {
                TitleCopyRightDispCounter = 0;
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_SHOW;
            }

            break;
        case COPYRIGHT_PHASE_SHOW:
            TitleCopyRightDispCounter++;

            if (TitleCopyRightDispCounter >= 75) {
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_FADE_OUT;
                TitleScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
            }

            break;
        case COPYRIGHT_PHASE_FADE_OUT:
            if (TitleScene->fade.FadeCheck() != 0) {
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_MOVIE_LOAD;
                mgTexManager.ReloadTexture(0x43, (sceVif1Packet *) NULL);
                mgCMemory memory;
                Stack_ReadBuff.stReset();
                int        remaining = Stack_ReadBuff.stGetRest();
                u_long128 *buffer = Stack_ReadBuff.stGetTop();
                memory.stSetBuffer(buffer, remaining);
                DrawMenuFillBox(0x80, 0, 0, 0);
                RushMovie->Load("L5LOGO.PSS", &memory, 512, 416, true, false);
                RushMovie->Play(at_1234);
                RushMovie->SwitchThread();

                while (RushMovie->IsStarted() == 0) {
                    RushMovie->SwitchThread();
                }

                TitleSkipLogoFlag = 0;
            }

            break;
        case COPYRIGHT_PHASE_MOVIE_LOAD:
            TitleScene->fade.Initialize();
            TitleCopyRightDispPhase = COPYRIGHT_PHASE_MOVIE;
            break;
        case COPYRIGHT_PHASE_MOVIE:
            if (TitleSkipLogoFlag == 0 && (GamePad__2.Down(0x20) != 0 || GamePad__2.Down(0x800) != 0)) {
                TitleSkipLogoFlag = 1;
                TitleScene->fade.FadeOut(20, 0.0f, 0.0f, 0.0f);
            }

            if (RushMovie->EndCheck() != 0 || (TitleSkipLogoFlag != 0 && TitleScene->fade.FadeCheck() != 0)) {
                TitleCopyRightDispPhase = COPYRIGHT_PHASE_MOVIE_END;
                TitleScene->fade.FadeOut(-1, 0.0f, 0.0f, 0.0f);
            }

            break;
        case COPYRIGHT_PHASE_MOVIE_END:
            TitleCopyRightDispPhase = COPYRIGHT_PHASE_END;
            TitleScene->fade.FadeOut(-1, 0.0f, 0.0f, 0.0f);
            break;
        case COPYRIGHT_PHASE_END:
            return 1;
    }

    return 0;
}

/**
 *
 * Draws the copyright and trial disc messages for the current display phase.
 *
 */
void TitleCopyRightDraw() {
    if (Tex_Logo == NULL) {
        return;
    }

    mgCTextureManager *texture_manager = &mgTexManager;

    switch (TitleCopyRightDispPhase) {
        case COPYRIGHT_PHASE_TRIAL_SHOW:
        case COPYRIGHT_PHASE_TRIAL_FADE_OUT:
            if (Tex_TrialMsg != NULL) {
                texture_manager->ReloadTexture(Tex_TrialMsg->block, (sceVif1Packet *) NULL);
                PrimQuad(Tex_TrialMsg, 0.0f, 0.0f, mgRect<int>(0, 0, 0x200, 0x1A0), 0x80, 0x80, 0x80, 0x80);
            }

            break;
        case COPYRIGHT_PHASE_FADE_IN:
        case COPYRIGHT_PHASE_SHOW:
        case COPYRIGHT_PHASE_FADE_OUT: {
            texture_manager->ReloadTexture(Tex_Logo->block, (sceVif1Packet *) NULL);
            PrimQuad(Tex_Logo, 0.0f, 176.0f, mgRect<int>(0, 0x144, 0x200, 0x3C), 0x80, 0x80, 0x80, 0x80);
            break;
        }
        case COPYRIGHT_PHASE_MOVIE:
        case COPYRIGHT_PHASE_MOVIE_END: {
            texture_manager->ReloadTexture(0x43, (sceVif1Packet *) NULL);
            RushMovie->SwitchThread();
            CPreSprite prim;
            prim.Initialize(NULL, NULL);
            prim.Preset2D();
            prim.AlphaBlendEnable(0);
            prim.TextureMapEnable(1);
            prim.Begin(6);
            prim.Color(0, 0, 0, 0x80);
            prim.SetIRect(0, 0, mgScreenWidth, mgScreenHeight, 0, 0);
            prim.Texture(RushWork);
            prim.Color(0x80, 0x80, 0x80, 0x80);
            prim.SetIStretch(0, 0, mgScreenWidth, mgScreenHeight, 0, 0, mgScreenWidth, 0x1A0);
            prim.End();

            if (TitleCopyRightDispPhase == COPYRIGHT_PHASE_MOVIE_END) {
                RushMovie->Term();
                RushMovie->SwitchThread();
                DrawMenuFillBox(0x80, 0, 0, 0);
            }

            break;
        }
    }
}

void TitleHDDInstallInit() {
    char               image_name[32];
    char               message_path[0x4C];
    int                file_size;
    mgCMemory         *stack;
    mgCTextureManager *textures = &mgTexManager;
    stack = &Stack_ReadBuff;

    HDDnowDisplayImageNo = 0;
    HDDMesDrawFlag = 0;
    HDDPhase = 0;
    HDDConfirmType = 0;
    HDDModeSelect = 0;
    stack->stack_used = 0;
    stack->lock = 0;
    textures->DeleteBlock(0x4A);
    textures->DeleteBlock(0x4B);
    textures->DeleteBlock(0x4C);
    stack->Align64();
    u_char *buffer = (u_char *) stack->stGetTop();
    LoadFile2("title/hdd0.img", buffer, &file_size, 0);
    textures->EnterIMGFile(buffer, 0x4A, NULL, NULL);
    stack->Alloc(Align16Blocks(file_size));
    buffer = (u_char *) stack->stGetTop();
    LoadFile2("title/hdd1.img", buffer, &file_size, 0);
    textures->EnterIMGFile(buffer, 0x4B, NULL, NULL);
    stack->Alloc(Align16Blocks(file_size));

    for (int i = 0; i < 10; i++) {
        int number = i + 1;

        if (number >= 10) {
            sprintf(image_name, "hdd_illust%d", number);
        } else {
            sprintf(image_name, "hdd_illust0%d", number);
        }

        HDDImage[i] = textures->GetTexture(image_name, -1);
        HDDImageAlpha[i] = 0;
    }

    HDDDlBar = textures->GetTexture("hdddl", -1);
    HDDSysImage = Tex_Logo;
    buffer = (u_char *) stack->stGetTop();

    if (LoadFile2("title/hddb.img", buffer, &file_size, 0) != 0) {
        textures->EnterIMGFile(buffer, 0x4C, NULL, NULL);
        stack->Alloc(Align16Blocks(file_size));
    }

    HDDBGTex = textures->GetTexture("book", -1);
    HDDMes = new (stack->Alloc(0x2A7)) CDC2Mes;
    HDDMes2 = new (stack->Alloc(0x2A7)) CDC2Mes;
    HDDMes->texture_block = 0x46;
    HDDMes2->texture_block = 0x46;
    stack->Align64();
    HDDMesDataBuff = (s16 *) stack->stGetTop();
    sprintf(message_path, "title/hddchk%d.mes", LanguageCode);

    if (LoadFile2(message_path, HDDMesDataBuff, &file_size, 0) != 0) {
        HDDMes->SetMessData(GetSystemMesBuffer(), HDDMesDataBuff);
        HDDMes2->SetMessData(GetSystemMesBuffer(), HDDMesDataBuff);
        stack->Alloc(Align16Blocks(file_size + 1));
    }

    HDDDlBarDrawFlag = 0;
    HDDINFO.connect = HddConectCheck(&HDDINFO.hdd_state);
    HDDINFO.app_install = CheckAppInstallForTitle();
    HDDINFO.install_space = CheckInstallSpace();
    HDDINFO.unk_10 = 0;
    HDDINFO.installing = 0;
    HDDINFO.result = 0;
    HDDINFO.work = stack->stGetTop();
    stack->Alloc(0x70000);
    stack->Align64();
    TitleScene->GetActiveBgmStatus(&TitleInfo->bgm_status);
    TitleScene->StopBGM(0);
    TitleScene->LoadBGM(0x32, stack->stGetTop());
    TitleScene->fade.FadeIn(0x28);
}

/**
 *
 * Advances hard drive installation and handles input to leave the screen.
 *
 */
int TitleHDDInstallKey() {
    int next_phase = -1;
    int push = MenuCheckPushButton();

    switch (HDDPhase) {
        case HDD_PHASE_FADE_IN:
            if (TitleScene->fade.FadeCheck() != 0) {
                next_phase = HDD_PHASE_SELECT;
            }

            break;
        case HDD_PHASE_EXIT:
            if (TitleScene->fade.FadeCheck() != 0) {
                TitleScene->StopBGM(0);
                TitleScene->LoadBGM(TitleInfo->bgm_status.load_no, Stack_ReadBuff.stGetTop());
                TitleScene->SetActiveBgmStatus(&TitleInfo->bgm_status);
                return 1;
            }

            break;
        case HDD_PHASE_SELECT: {
            for (int i = 0; i < 10; i++) {
                CalcMenuAdd(&HDDImageAlpha[i], -12, 0);
            }

            int old_select = HDDModeSelect;

            if (GamePad__2.Down(0x1000) != 0) {
                HDDModeSelect--;
            }

            if (GamePad__2.Down(0x4000) != 0) {
                HDDModeSelect++;
            }

            if (HDDModeSelect < 0) {
                HDDModeSelect = 0;
            }

            if (0 < HDDModeSelect) {
                HDDModeSelect = 0;
            }

            if (old_select != HDDModeSelect) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }

            if (push & 1) {
                if (HDDModeSelect == 0) {
                    HDDConfirmType = HDD_CONFIRM_INSTALL;
                    next_phase = HDD_PHASE_CONFIRM;

                    if (0 < HDDINFO.connect && (HDDINFO.hdd_state == 1 || HDDINFO.hdd_state == 3)) {
                        next_phase = HDD_PHASE_ERROR;
                    } else if (HDDINFO.connect == 0) {
                        next_phase = HDD_PHASE_ERROR;
                    } else if (0 < HDDINFO.app_install) {
                        next_phase = HDD_PHASE_ERROR;
                    } else if (HDDINFO.app_install < 0) {
                        next_phase = HDD_PHASE_ERROR;
                    } else if (HDDINFO.install_space <= 0) {
                        next_phase = HDD_PHASE_ERROR;
                    }
                }

                MenuSePlay(SYSTEM_SE_DECIDE);
            } else if (push & 2) {
                HDDConfirmType = HDD_CONFIRM_EXIT;
                next_phase = HDD_PHASE_CONFIRM;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case HDD_PHASE_CONFIRM: {
            int answer = HDDMes->YesNoCursor2(0);
            int choice = 0;

            if (answer == 1) {
                choice = 1;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            if (answer == 2) {
                choice = 2;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            if (HDDConfirmType == HDD_CONFIRM_EXIT) {
                if (choice == 1) {
                    next_phase = HDD_PHASE_EXIT;
                }

                if (choice == 2) {
                    next_phase = HDD_PHASE_SELECT;
                }
            }

            if (HDDConfirmType == HDD_CONFIRM_INSTALL) {
                if (choice == 1) {
                    next_phase = HDD_PHASE_INSTALL;
                }

                if (choice == 2) {
                    next_phase = HDD_PHASE_SELECT;
                }
            }

            break;
        }
        case HDD_PHASE_INSTALL: {
            int status = StepInstallThread();
            HDDINFO.progress = fptosi(GetInstallProgress());
            HDDnowDisplayImageNo = HDDINFO.progress / 10;

            if (HDDnowDisplayImageNo < 0) {
                HDDnowDisplayImageNo = 0;
            }

            if (HDDnowDisplayImageNo > 9) {
                HDDnowDisplayImageNo = 9;
            }

            for (int i = 0; i < 10; i++) {
                if (i <= HDDnowDisplayImageNo) {
                    CalcMenuAdd(&HDDImageAlpha[i], 2, 0x80);
                }
            }

            if (status <= 0) {
                HDDINFO.result = status;
                next_phase = HDD_PHASE_RESULT;
                MenuSePlay(0x1F);
            } else if (push & 2) {
                next_phase = HDD_PHASE_CANCEL_ASK;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case HDD_PHASE_RESULT:
            if (GamePad__2.Down(0x20) != 0 || GamePad__2.Down(0x40) != 0) {
                next_phase = HDD_PHASE_SELECT;

                if (0 < HDDINFO.connect && 0 < HDDINFO.app_install && HDDINFO.result == 0) {
                    next_phase = HDD_PHASE_EXIT;
                }

                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
        case HDD_PHASE_CANCEL_ASK: {
            int answer = HDDMes->YesNoCursor2(0);

            if (answer == 1) {
                next_phase = HDD_PHASE_CANCEL;
            }

            if (answer == 2) {
                InstallPause();
                HDDDlBarDrawFlag = 1;
                HDDMesDrawFlag = 0;
                HDDPhase = HDD_PHASE_INSTALL;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case HDD_PHASE_CANCEL:
            if (StepInstallThread() <= 0) {
                DeleteInstallThread();
                next_phase = HDD_PHASE_CANCELLED;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
        case HDD_PHASE_CANCELLED:
            if (push != 0) {
                next_phase = HDD_PHASE_IMAGE_FADE;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
        case HDD_PHASE_IMAGE_FADE:
            if (0 < CalcMenuAdd(&HDDImageAlpha[HDDnowDisplayImageNo], -4, 0)) {
                next_phase = HDD_PHASE_SELECT;
            }

            break;
        case HDD_PHASE_ERROR:
            if (GamePad__2.Down(0x20) != 0 || GamePad__2.Down(0x40) != 0) {
                next_phase = HDD_PHASE_SELECT;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
    }

    if (0 <= next_phase) {
        switch (next_phase) {
            case HDD_PHASE_SELECT:
                HDDMesDrawFlag = 0;
                break;
            case HDD_PHASE_ERROR:
                HDDMesDrawFlag = 1;
                HDDMes->MsgPreset(10);
                HDDMes->SetAbsPos(5);

                if (HDDINFO.connect == 0) {
                    HDDMes->MakeMsg(0x66);

                    if (HDDINFO.hdd_state == 3) {
                        HDDMes->MakeMsg(0x66);
                    }
                } else if (0 < HDDINFO.connect && HDDINFO.hdd_state == 1) {
                    HDDMes->MakeMsg(0x6A);
                } else if (0 < HDDINFO.app_install) {
                    HDDMes->MakeMsg(0x65);
                } else if (HDDINFO.app_install < 0) {
                    HDDMes->MakeMsg(0x6B);
                } else if (HDDINFO.install_space == 0) {
                    HDDMes->MakeMsg(0x68);
                } else {
                    HDDMes->MakeMsg(0x67);
                }

                break;
            case HDD_PHASE_CONFIRM:
                HDDMesDrawFlag = 1;

                if (HDDConfirmType == HDD_CONFIRM_EXIT) {
                    HDDMes->MsgPreset(11);
                    HDDMes->SetAbsPos(5);
                    HDDMes->MakeMsg(2);
                    HDDMes->SetMsgCursor(1);
                } else {
                    next_phase = HDD_PHASE_ERROR;

                    if (HDDINFO.connect == 0) {
                        HDDMes->MsgPreset(10);
                        HDDMes->SetAbsPos(5);

                        if (HDDINFO.hdd_state == 3) {
                            HDDMes->MakeMsg(0x66);
                        }

                        if (HDDINFO.hdd_state == 1) {
                            HDDMes->MakeMsg(0x6A);
                        }
                    } else if (0 < HDDINFO.app_install) {
                        HDDMes->MsgPreset(10);
                        HDDMes->MakeMsg(0x65);
                        HDDMes->SetAbsPos(5);
                    } else if (HDDINFO.app_install < 0) {
                        HDDMes->MsgPreset(10);
                        HDDMes->SetAbsPos(5);
                        HDDMes->MakeMsg(0x67);

                        if (HDDINFO.app_install == -1000 || HDDINFO.app_install == -1001) {
                            HDDMes->MakeMsg(0x6B);
                        }
                    } else if (HDDINFO.install_space == 0) {
                        HDDMes->MsgPreset(10);
                        HDDMes->SetAbsPos(5);
                        HDDMes->MakeMsg(1);
                    } else if (HDDINFO.install_space < 0) {
                        HDDMes->MsgPreset(10);
                        HDDMes->SetAbsPos(5);
                        HDDMes->MakeMsg(0x64);
                    } else {
                        next_phase = HDD_PHASE_CONFIRM;
                        HDDMes->MsgPreset(11);
                        HDDMes->MakeMsg(10);
                        HDDMes->SetAbsPos(5);
                        HDDMes->SetMsgCursor(1);
                    }
                }

                break;
            case HDD_PHASE_EXIT:
                HDDMesDrawFlag = 0;
                TitleScene->fade.FadeOut(0x28, 0.0f, 0.0f, 0.0f);
                break;
            case HDD_PHASE_INSTALL:
                if (CreateInstallThread((u_long128 *) HDDINFO.work, 0x70000) != 0) {
                    TitleScene->PlayBGM(0, -1, 1.0f);
                    HDDINFO.progress = 0;
                    HDDDlBarDrawFlag = 1;
                    HDDINFO.installing = 1;
                    HDDMesDrawFlag = 0;
                    HDDMes2->MsgPreset(0x12);
                    HDDMes2->SetAbsPos(8);
                    HDDMes2->MakeMsg(0x7B);
                    StepInstallThread();
                } else {
                    HDDMes->MsgPreset(10);
                    HDDMes->SetAbsPos(5);
                    HDDMes->MakeMsg(0x64);
                    next_phase = HDD_PHASE_ERROR;
                }

                break;
            case HDD_PHASE_RESULT:
                DeleteInstallThread();
                HDDINFO.connect = HddConectCheck(&HDDINFO.hdd_state);
                HDDINFO.app_install = CheckAppInstallForTitle();
                HDDINFO.install_space = CheckInstallSpace();
                HDDDlBarDrawFlag = 0;
                HDDMesDrawFlag = 1;
                HDDMes->MsgPreset(10);
                HDDMes->SetAbsPos(5);
                HDDMes->SetMsgCursor(-1);

                if (HDDINFO.result < 0) {
                    HDDMes->MakeMsg(0xC8);
                } else if (0 < HDDINFO.connect && 0 < HDDINFO.app_install && HDDINFO.result == 0) {
                    HDDMes->MakeMsg(0x1E);
                } else {
                    HDDMes->MakeMsg(0xC8);
                }

                break;
            case HDD_PHASE_CANCEL_ASK:
                InstallPause();
                HDDMes->MsgPreset(11);
                HDDMes->SetAbsPos(5);
                HDDMes->MakeMsg(0x78);
                HDDMes->SetMsgCursor(1);
                HDDDlBarDrawFlag = 0;
                HDDMesDrawFlag = 1;
                break;
            case HDD_PHASE_CANCEL:
                InstallPause();
                InstallCancel();
                HDDMesDrawFlag = 1;
                HDDDlBarDrawFlag = 0;
                HDDMes->MsgPreset(0x12);
                HDDMes->SetAbsPos(5);
                HDDMes->MakeMsg(0x79);
                break;
            case HDD_PHASE_CANCELLED:
                HDDMes->MakeMsg(0x15);
                break;
            case HDD_PHASE_IMAGE_FADE:
                HDDMesDrawFlag = 0;

                for (int i = 0; i < HDDnowDisplayImageNo; i++) {
                    HDDImageAlpha[i] = 0;
                }

                break;
        }

        HDDPhase = next_phase;
    }

    return 0;
}

void DrawMenuDl(int x, int y, int width, int alpha, float rate) {
    // Left, center and right texture rectangles for the three installation panel rows.
    static short table[3][12] = {
        {0, 0, 32, 32, 32, 0, 32, 32, 64, 0, 32, 32},
        {0, 32, 32, 16, 32, 32, 32, 16, 64, 32, 32, 16},
        {0, 48, 32, 76, 32, 48, 32, 76, 64, 48, 32, 76},
    };

    mgCDrawPrim prim;
    mgRect<int> frame_tex;
    mgRect<int> bar_tex;
    mgRect<int> frame_put;
    mgRect<int> bar_put;
    mgRect<int> shadow_put;
    mgRect<int> body_put;

    SetSpriteEnv(&prim, 0);
    prim.Begin(6);
    prim.Texture(HDDDlBar);
    prim.Color(0x80, 0x80, 0x80, alpha);
    frame_tex.Set(0x74, 0, 0xC, 0xC);
    bar_tex.Set(0x6D, 1, 6, 0xA);
    frame_put.Set(x + 4, y + 0x2E, width - 0xA, 0xE);
    PrimQuad(&prim, frame_put, frame_tex);
    prim.End();
    prim.Begin(6);
    int   end_width = table[0][2] - 0x14 + table[1][4];
    float inner = ((float) width - (float) end_width) - 2.0f;
    int   bar_width = (int) (inner * rate);

    if (rate < 1.0f) {
        prim.Color(0x80, 0x80, 0x80, alpha);
    } else {
        prim.Color(0x40, 0x94, 0x40, alpha);
    }

    bar_put.Set(x + 0x17, y + 0x2F, bar_width, 0xA);
    PrimQuad(&prim, bar_put, bar_tex);
    prim.End();
    prim.Bilinear(0);
    prim.Begin(6);

    for (int i = 0; i < 3; i++) {
        prim.Color(0, 0, 0, alpha >> 2);
        shadow_put.Set(x + 4, y + 4, width, table[i][3]);
        Menu3DivideTextureDraw(&prim, shadow_put, table[i], 1);
        prim.Color(0x80, 0x80, 0x80, alpha);
        body_put.Set(x, y, width, table[i][3]);
        Menu3DivideTextureDraw(&prim, body_put, table[i], 1);
        y += table[i][3];
    }

    prim.End();
}

/**
 *
 * Draws the hard drive installation image, progress, and messages.
 *
 */
void TitleHDDInstallDraw() {
    // Installation progress captions indexed by the selected language.
    static char *infomsg[7] = {
        " ",
        "Now installing.",
        "Installing...",
        "Installing...",
        "Installing...",
        "Installing...",
        "Installing...",
    };

    mgCTextureManager *textures = &mgTexManager;

    if (HDDBGTex != NULL) {
        textures->ReloadTexture(HDDBGTex->block, (sceVif1Packet *) NULL);
        PrimQuad(HDDBGTex, mgRect<int>(0, 0, 0x200, 0x1A0), mgRect<int>(0, 0, 0x200, 0x1A0), 0x80, 0x80, 0x80, 0x80);
    }

    if (HDDSysImage != NULL && HDDMesDrawFlag == 0) {
        textures->ReloadTexture(HDDSysImage->block, (sceVif1Packet *) NULL);
        float       cursor[2] = {160.0f, 180.0f};
        PrimQuad(HDDSysImage, cursor[0], cursor[1], mgRect<int>(0x12E, 0x94, 0xD2, 0x36), 0x80, 0x80, 0x80, 0x80);

        static int count = 0;

        // The frame counter advances through a float add, as retail does.
        count += 1.0f;

        if (1000000.0f < (float) count) {
            count = 0;
        }

        cursor[0] -= 30.0f;
        cursor[1] += 12.0f;
        cursor[0] += 6.0f * cosf(0.05235988f * (float) count);
        cursor[1] += 4.0f * sinf(0.10471976f * (float) count);
        PrimQuad(HDDSysImage, cursor[0], cursor[1], mgRect<int>(0, 0x28, 0x28, 0x20), 0x80, 0x80, 0x80, 0x80);
    }

    int block = -1;

    if (HDDImage[HDDnowDisplayImageNo] != NULL) {
        for (int i = 0; i < 10; i++) {
            if (block != HDDImage[i]->block) {
                textures->ReloadTexture(HDDImage[i]->block, (sceVif1Packet *) NULL);
                block = HDDImage[i]->block;
            }

            PrimQuad(HDDImage[i], 0.0f, 0.0f, mgRect<int>(0, 0, 0x200, 0x1A0), HDDImageAlpha[i], 0x80, 0x80, 0x80);
        }
    }

    if (HDDDlBarDrawFlag != 0) {
        if (HDDDlBar != NULL) {
            textures->ReloadTexture(HDDDlBar->block, (sceVif1Packet *) NULL);
            DrawMenuDl(0x88, 0x9C, 0xF0, 0x80, (float) HDDINFO.progress / 100.0f);
            textures->ReloadTexture(0x46, (sceVif1Packet *) NULL);

            CMenuFont font;
            font.SetStr(infomsg[LanguageCode]);
            font.SetPos(0xA6, 0xAE);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            if (HDDMes2 != NULL) {
                HDDMes2->StepMsg();
                HDDMes2->DrawMsg();
            }
        }
    }

    if (HDDMesDrawFlag != 0) {
        if (HDDMes != NULL) {
            textures->ReloadTexture(HDDMes->texture_block, (sceVif1Packet *) NULL);
            HDDMes->StepMsg();
            HDDMes->DrawMsg();
        }
    }
}

/**
 *
 * Checks whether the title can use an installed game image.
 *
 */
int CheckAppInstallForTitle() {
    if (GetMainFileDev() == 3) {
        return 1;
    }

    return CheckAppInstall();
}

/**
 *
 * Checks for a connected hard drive with an installed game image.
 *
 */
int CheckHDDInstall() {
    if (0 < HddConectCheck(NULL)) {
        if (0 < CheckAppInstallForTitle()) {
            return 1;
        }
    }

    return 0;
}

void TitleLangSelInit(mgCMemory *memory) {
    int file_size;
    u8 *buffer;

    GamePad__2.SetAutoRepeat(0x5000, 0xF, 4);
    GamePad__2.MenuModeOn(0x78);
    title_lang_select = 0;
    mgFrameRate = 1;
    buffer = reinterpret_cast<u8 *>(memory->stGetTop());
    LoadFile2("title/lang_select.img", buffer, &file_size, 0);
    memory->Alloc(file_size / 16 + 1);
    mgTexManager.EnterIMGFile(buffer, 1, NULL, NULL);
    lang_tex = mgTexManager.GetTexture("lang_select", -1);
    title_lang_phase = 0;
    title_lang_curxy[0] = 100.0f;
    title_lang_fadealpha = 0x80;
    title_lang_curxy[1] = 100.0f;
    title_lang_cursor_cnt = 0;
}

int TitleLangSelKey() {
    switch (title_lang_phase) {
        case 0:
            title_lang_fadealpha -= 6;

            if (title_lang_fadealpha <= 0) {
                title_lang_fadealpha = 0;
                title_lang_phase += 1;
            }

            break;
        case 1:
            if (GamePad__2.Down(PAD_UP) != 0) {
                title_lang_select -= 1;
            }

            if (GamePad__2.Down(PAD_DOWN) != 0) {
                title_lang_select += 1;
            }

            if (title_lang_select < 0) {
                title_lang_select = 4;
            }

            if (title_lang_select > 4) {
                title_lang_select = 0;
            }

            if (GamePad__2.Down(0x40) != 0) {
                title_lang_phase += 1;
            }

            break;
        case 2:
            title_lang_fadealpha += 6;

            if (title_lang_fadealpha >= 0x80) {
                title_lang_fadealpha = 0x80;
                mgTexManager.DeleteBlock(0);
                mgFrameRate = 2;
                lang_tex = 0;
                GamePad__2.AutoRepeatOff();
                GamePad__2.MenuModeOff();
                return title_lang_select + 1;
            }

            break;
    }

    return 0;
}

/**
 *
 * Returns the language number selected by the title language menu.
 *
 */
int GetSelectLanguageNo() {
    return title_lang_select + 1;
}

void TitleLangSelDraw() {
    if (lang_tex != NULL) {
        mgTexManager.ReloadTexture(lang_tex->block, (sceVif1Packet *) NULL);
        int         x = mgScreenWidth / 2 - 0x69;
        float       cursor_goal_x = (float) (x - 0x26);
        int         y = 0x46;
        int         i = 0;
        int         tex_y = 0;
        float       cursor_goal_y = 0.0f;
        mgRect<int> row_rect;
        mgRect<int> cursor_rect;

        for (; i < 5; i++) {
            if (i == title_lang_select) {
                cursor_goal_y = 12.0f + (float) y;
            }

            row_rect.Set(0, tex_y, 0xD2, 0x36);
            PrimQuad(lang_tex, (float) x, (float) y, row_rect, 0x80, 0x80, 0x80, 0x80);
            y += 0x3C;
            tex_y += 0x36;
        }

        CalcMenu1(cursor_goal_x, &title_lang_curxy[0], 4.0f, 0.0f, 0);
        CalcMenu1(cursor_goal_y, &title_lang_curxy[1], 4.0f, 0.0f, 0);
        float sway_x = mgAngleLimit(0.05235988f * (float) title_lang_cursor_cnt);
        float sway_y = mgAngleLimit(0.10471976f * (float) title_lang_cursor_cnt);
        float cursor_x = title_lang_curxy[0] + 6.0f * cosf(sway_x);
        float cursor_y = 10.0f + title_lang_curxy[1] + 4.0f * sinf(sway_y);
        cursor_rect.Set(0xD8, 0x168, 0x28, 0x18);
        PrimQuad(lang_tex, cursor_x, cursor_y, cursor_rect, 0x80, 0x80, 0x80, 0x80);
        title_lang_cursor_cnt++;

        if (title_lang_cursor_cnt > 10000000) {
            title_lang_cursor_cnt = 0;
        }

        DrawMenuFillBox(0.0f, 0.0f, 512.0f, 448.0f, title_lang_fadealpha, 0, 0, 0);
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", MC_ICON_Data__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1221__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1222__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1223__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1224__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1225__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1226__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1227__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1228__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1229__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1230__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1231__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1232__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1233__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1234__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1235__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1236__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1237__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1238__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", at_1239__2__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", TitleProjection__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/title", TitleHDDCheckFlag__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(TitleSelectInit, 0x4);
INCLUDE_BSS(TitleMap, 0x4);
INCLUDE_BSS(TitleCamera, 0x4);
INCLUDE_BSS(TitleCamera2, 0x4);
INCLUDE_BSS(WaveTable__3, 0x4);
INCLUDE_BSS(GameBootInit, 0x4);
INCLUDE_BSS(TitleBootEventNo, 0x4);
INCLUDE_BSS(DCRuncherMode, 0x4);
INCLUDE_BSS(DCRuncherCounter, 0x4);
INCLUDE_BSS(TitleInfo, 0x4);
INCLUDE_BSS(TitleMCFuncFlag, 0x4);
INCLUDE_BSS(TitleMCCheckNow, 0x4);
INCLUDE_BSS(TitleMainMCCheckPhase, 0x4);
INCLUDE_BSS(TitleMCCheck, 0x4);
INCLUDE_BSS(Tex_TitleBG, 0x4);
INCLUDE_BSS(Tex_Chronicle, 0x4);
INCLUDE_BSS(Tex_Logo, 0x4);
INCLUDE_BSS(Tex_Plate, 0x4);
INCLUDE_BSS(Tex_TitleLight, 0x4);
INCLUDE_BSS(Tex_TitleCursor, 0x4);
INCLUDE_BSS(Tex_TrialMsg, 0x4);
INCLUDE_BSS(Tex_TitleBG2, 0x4);
INCLUDE_BSS(RushMovie, 0x4);
INCLUDE_BSS(RushStart, 0x4);
INCLUDE_BSS(RushWork, 0x4);
INCLUDE_BSS(TitleScene, 0x4);
INCLUDE_BSS(TitleEventSound, 0x4);
