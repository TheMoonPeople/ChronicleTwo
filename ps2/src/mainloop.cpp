#include "common.h"

#include <libgraph.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "charaviewlp.hpp"
#include "convviewlp.hpp"
#include "dng_main.hpp"
#include "editloop.hpp"
#include "mapviewlp.hpp"
#include "movieviewlp.hpp"
#include "sndviewlp.hpp"
#include "texviewlp.hpp"
#include "dataread.hpp"
#include "editdata.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "helpmes.hpp"
#include "inventmn.hpp"
#include "main.hpp"
#include "mainloop.hpp"
#include "mainloop3.hpp"
#include "mapselect.hpp"
#include "menuchr.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "nowload.hpp"
#include "npccfg.hpp"
#include "padcontrol.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "title.hpp"
#include "userdata.hpp"
#include "visualmotion.hpp"
#include "vlgr_info.hpp"
#include "water.hpp"

extern INIT_LOOP_ARG NextInitArg;
extern INIT_LOOP_ARG PrevInitArg;
/**
 * Mode entered after the current main loop finishes.
 */
static int           NextLoopNo;
/**
 * Mode active before the current main loop.
 */
static int           PrevLoopNo;
/**
 * Whether input replay also captures screen images.
 */
static int           CaptureScreen;
/**
 * Selected pause-menu command.
 */
static int           PauseSel;
/**
 * Stage of the pause menu.
 */
static int           PauseMenuMode;
/**
 * Whether leaving the pause menu has started.
 */
static int           exit_start;
/**
 * Opacity of the pause-menu screen fade.
 */
static float         BlackFade;
/**
 * Opacity of the pause-menu message fade.
 */
static float         BlackFade2;
extern CSaveData     SaveData;
extern ClsMes        PauseMes;
extern mgCMemory     SystemSeStack;
/**
 * Main memory arena for game resources.
 */
u_long128            main_buffer[0x1A0000];
/**
 * Memory backing the system sound-effect loader.
 */
static u_long128     SystemSeBuff[400];
/**
 * Memory backing configuration and villager data.
 */
static u_long128     InfoBuff[5000];
static void MenuInit(INIT_LOOP_ARG arg);
static void MenuExit();
static int           MenuLoop();
static int           EventSelect();
static int           gcALL_GEO_PARTS(SPI_STACK *stack, int argc);
LOOP_INIT_FUNC LoopInit[LOOP_MODE_NUM] = {
    MenuInit,
    EditInit,
    InitDungeonMain,
    TitleInit,
    InitCharaViewerMain,
    InitTextuerViewerMain,
    MapViewInit,
    InitSoundViewerMain,
    MovieViewInit,
    SVConvViewInit,
};
LOOP_MAIN_FUNC LoopMain[LOOP_MODE_NUM] = {
    MenuLoop,
    EditLoop,
    LoopDungeonMain,
    TitleLoop,
    LoopCharaViewerMain,
    LoopTextuerViewerMain,
    MapViewLoop,
    LoopSoundViewerMain,
    MovieViewLoop,
    SVConvViewLoop,
};
LOOP_EXIT_FUNC LoopExit[LOOP_MODE_NUM] = {
    MenuExit,
    EditExit,
    FinishDungeonMain,
    TitleExit,
    FinishCharaVieweMain,
    FinishTextuerVieweMain,
    MapViewExit,
    FinishSoundVieweMain,
    MovieViewExit,
    SVConvViewExit,
};
/**
 * Language-adjusted mappings from logical controls to pad buttons.
 */
static PAD_TABLE_ENTRY pad_table[] = {
    {PAD_BTN_CONFIRM, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {PAD_BTN_CANCEL, PAD_CTRL_TRIGGER_DOWN, PAD_CROSS},
    {PAD_BTN_R1_HELD, PAD_CTRL_TRIGGER_ON, PAD_R1},
    {PAD_BTN_L1_HELD, PAD_CTRL_TRIGGER_ON, PAD_L1},
    {4, PAD_CTRL_TRIGGER_DOWN, PAD_L2},
    {PAD_BTN_MENU, PAD_CTRL_TRIGGER_DOWN, PAD_TRIANGLE},
    {6, PAD_CTRL_TRIGGER_DOWN, PAD_R2},
    {PAD_BTN_UP, PAD_CTRL_TRIGGER_DOWN, PAD_UP},
    {PAD_BTN_DOWN, PAD_CTRL_TRIGGER_DOWN, PAD_DOWN},
    {PAD_BTN_RIGHT, PAD_CTRL_TRIGGER_DOWN, PAD_RIGHT},
    {PAD_BTN_LEFT, PAD_CTRL_TRIGGER_DOWN, PAD_LEFT},
    {11, PAD_CTRL_TRIGGER_ON, PAD_UP},
    {12, PAD_CTRL_TRIGGER_ON, PAD_DOWN},
    {13, PAD_CTRL_TRIGGER_ON, PAD_RIGHT},
    {14, PAD_CTRL_TRIGGER_ON, PAD_LEFT},
    {PAD_BTN_START, PAD_CTRL_TRIGGER_DOWN, PAD_START},
    {16, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {17, PAD_CTRL_TRIGGER_DOWN, PAD_CROSS},
    {19, PAD_CTRL_TRIGGER_ON, PAD_CIRCLE},
    {20, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {PAD_BTN_PAUSE, PAD_CTRL_TRIGGER_DOWN, PAD_START},
    {PAD_BTN_EVENT_SKIP, PAD_CTRL_TRIGGER_DOWN, PAD_TRIANGLE},
    {PAD_BTN_QUICK_CHANGE, PAD_CTRL_TRIGGER_DOWN, PAD_L3},
    {24, PAD_CTRL_TRIGGER_DOWN, PAD_R3},
    {PAD_BTN_ACTION_CONFIRM, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {PAD_BTN_ACTION_SQUARE, PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE},
    {PAD_BTN_ACTION_CANCEL, PAD_CTRL_TRIGGER_DOWN, PAD_CROSS},
    {53, PAD_CTRL_TRIGGER_ON, PAD_L1},
    {54, PAD_CTRL_TRIGGER_ON, PAD_R1},
    {55, PAD_CTRL_TRIGGER_DOWN, PAD_SELECT},
    {PAD_BTN_ACTION_HELD, PAD_CTRL_TRIGGER_ON, PAD_CIRCLE},
    {PAD_BTN_EDIT_TURN_DECREASE, PAD_CTRL_TRIGGER_DOWN, PAD_R2},
    {PAD_BTN_EDIT_TURN_INCREASE, PAD_CTRL_TRIGGER_DOWN, PAD_L2},
    {PAD_BTN_EDIT_PLACE, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {PAD_BTN_EDIT_REMOVE, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {PAD_BTN_EDIT_PAINT, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {PAD_BTN_EDIT_PAINT_ALL, PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE},
    {PAD_BTN_EDIT_WALL_NEXT, PAD_CTRL_TRIGGER_DOWN, PAD_R2},
    {PAD_BTN_EDIT_WALL_PREVIOUS, PAD_CTRL_TRIGGER_DOWN, PAD_L2},
    {18, PAD_CTRL_TRIGGER_DOWN, PAD_R1},
    {PAD_BTN_EDIT_SWITCH, PAD_CTRL_TRIGGER_DOWN, PAD_SELECT},
    {PAD_BTN_EDIT_MAGNET, PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE},
    {120, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE},
    {121, PAD_CTRL_TRIGGER_ON, PAD_CIRCLE},
    {122, PAD_CTRL_TRIGGER_ON, PAD_SQUARE},
    {-1, -1, -1},
};
/**
 * Mappings from logical analog controls to pad stick axes.
 */
static ANALOG_TABLE_ENTRY analog_table[] = {
    {PAD_ANALOG_LEFT_X, PAD_CTRL_AXIS_LX},
    {PAD_ANALOG_LEFT_Y, PAD_CTRL_AXIS_LY},
    {PAD_ANALOG_RIGHT_X, PAD_CTRL_AXIS_RX},
    {PAD_ANALOG_RIGHT_Y, PAD_CTRL_AXIS_RY},
    {4, PAD_CTRL_AXIS_LY},
    {5, PAD_CTRL_AXIS_LX},
    {6, PAD_CTRL_AXIS_RX},
    {7, PAD_CTRL_AXIS_RY},
    {-1, -1},
};

extern CFont     Font;
extern mgCMemory MainBuffer;
/**
 * Active page of the debug menu.
 */
static int       menu_mode;
void             InitEventSelect();

/**
 * Values selected by the debug menu and game configuration tags.
 */
static int SelectArg[32] = {0};

/**
 * Save data used by the current game mode.
 */
static CSaveData    *ActiveSaveData;
/**
 * Selected input capture or replay mode.
 */
static int           CaptureMode;
/**
 * Currently active main-loop mode.
 */
static int           LoopNo;
/**
 * Whether vertical blank advances the saved play time.
 */
static int           PlayTimeCountFlag;
/**
 * Save-data arena for the active extra game.
 */
static CSubGameData *SubGameSaveData;
/**
 * Whether the event-selection sub-menu is open.
 */
static int           event_view;
/**
 * Whether the future-map sub-menu is open.
 */
static int           future_sel;
/**
 * Whether the hard-disk debug menu is open.
 */
static int           hdd_sel;
extern CScene        MainScene;
extern INIT_LOOP_ARG InitArg;
extern mgCMemory     InfoStack;

extern mgCMemory   MenuBuffer;
/**
 * Font texture pages loaded for the current language.
 */
static mgCTexture *FontTex[1];
/**
 * Texture image data for each font page.
 */
static TM2_head   *FontDataAdr[1];
/**
 * Image storage used when loading font texture pages.
 */
static u8            font_buff[0xD000];

static int gcMAP_NO(SPI_STACK *stack, int argument_count);
static int gcPROGRESS(SPI_STACK *stack, int argument_count);
static int gcBIT_FLAG_ON(SPI_STACK *stack, int argument_count);
static int gcBIT_FLAG_OFF(SPI_STACK *stack, int argument_count);
static int gcSTART_EVENT(SPI_STACK *stack, int argument_count);
static int gcGEO_COMPLETE(SPI_STACK *stack, int argument_count);
static int gcGEO_DEBUG(SPI_STACK *stack, int argument_count);
static int gcITEM_SET(SPI_STACK *stack, int argument_count);
static int gcGET_ITEM(SPI_STACK *stack, int argument_count);
static int gcGET_N_ITEM(SPI_STACK *stack, int argument_count);
static int gcEQUIP(SPI_STACK *stack, int argument_count);
static int gcDEFENSE(SPI_STACK *stack, int argument_count);
static int gcHP(SPI_STACK *stack, int argument_count);
static int gcALL_GEO_PARTS(SPI_STACK *stack, int argument_count);
static int gcPARAM_DRAW(SPI_STACK *stack, int argument_count);
static int gcOPTION(SPI_STACK *stack, int argument_count);
static int gcMONICA(SPI_STACK *stack, int argument_count);
static int gcSTEVE(SPI_STACK *stack, int argument_count);
static int gcMONSTER(SPI_STACK *stack, int argument_count);
static int gcPARTY(SPI_STACK *stack, int argument_count);
static int gcACTIVE_CHARA(SPI_STACK *stack, int argument_count);

/**
 * Tags accepted by the main game configuration parser.
 */
static SPI_TAG_PARAM tag__3[] = {
    {"MAP_NO", gcMAP_NO},
    {"PROGRESS", gcPROGRESS},
    {"BIT_FLAG_ON", gcBIT_FLAG_ON},
    {"BIT_FLAG_OFF", gcBIT_FLAG_OFF},
    {"START_EVENT", gcSTART_EVENT},
    {"GEO_COMPLETE", gcGEO_COMPLETE},
    {"GEO_DEBUG", gcGEO_DEBUG},
    {"ITEM_SET", gcITEM_SET},
    {"GET_ITEM", gcGET_ITEM},
    {"GET_N_ITEM", gcGET_N_ITEM},
    {"EQUIP", gcEQUIP},
    {"DEFENSE", gcDEFENSE},
    {"DEFENCE", gcDEFENSE},
    {"HP", gcHP},
    {"ALL_GEO_PARTS", gcALL_GEO_PARTS},
    {"PARAM_DRAW", gcPARAM_DRAW},
    {"OPTION", gcOPTION},
    {"MONICA", gcMONICA},
    {"STEVE", gcSTEVE},
    {"MONSTER", gcMONSTER},
    {"PARTY", gcPARTY},
    {"ACTIVE_CHARA", gcACTIVE_CHARA},
    {NULL, NULL},
};

// Code (.text)
CFont *GetDebugFont() {
    return &Font;
}

int GetCaptureMode() {
    return CaptureMode;
}

s32 GetSystemSndID() {
    return SystemSND_ID;
}

CScene *GetMainScene() {
    return &MainScene;
}

CSaveData *GetSaveData() {
    return ActiveSaveData;
}

CSubGameData *GetSubGameSaveData() {
    return SubGameSaveData;
}

void InitSaveData() {
    GetSaveData()->Initialize();
}

int GetVramTopAddress() {
    return mgGetTopVRAMAddress() + 0x20;
}

mgCMemory *GetMainStack() {
    return &MainBuffer;
}

void NextLoop(int loop_no, INIT_LOOP_ARG arg) {
    NextLoopNo = loop_no;
    NextInitArg = arg;
}

int GetNowLoopNo() {
    return LoopNo;
}

INIT_LOOP_ARG *GetNowInitArg() {
    return &InitArg;
}

void cat_start() {}

void cat_end() {}

void SetTextureTable(int table_size, int table_count, mgCMemory *memory) {
    mgTexManager.SetTableBuffer(table_count, table_size, memory);
    mgTexManager.Initialize(GetVramTopAddress(), -1);
}

/**
 *
 * Registers the logical controller bindings for the selected language.
 *
 */
static void InitPadTable(int language) {
    int confirm[2] = {PAD_CIRCLE, PAD_CROSS};
    int cancel[2] = {PAD_CROSS, PAD_CIRCLE};
    int language_index;
    int i;

    language_index = 0;

    if (language != LANG_JAPANESE) {
        language_index = 1;
    }

    PadCtrl.Initialize();

    for (i = 0; pad_table[i].no >= 0; i++) {
        switch (pad_table[i].no) {
            case 0:
            case 0x10:
            case 0x14:
            case 0x32:
            case 0x38:
            case 0x66:
            case 0x67:
            case 0x68:
            case 0x78:
            case 0x79:
                pad_table[i].button = confirm[language_index];
                break;
            case 1:
            case 0x11:
            case 0x34:
                pad_table[i].button = cancel[language_index];
                break;
        }

        PadCtrl.RegisterBtn(pad_table[i].no, pad_table[i].button, pad_table[i].trigger);
    }

    for (i = 0; analog_table[i].no >= 0; i++) {
        PadCtrl.RegisterAnalog(analog_table[i].no, analog_table[i].axis);
    }
}

/**
 *
 * Advances saved play time once per video synchronization when counting is enabled.
 *
 */
static void VSyncCallBack(int unused) {
    if (PlayTimeCountFlag != 0) {
        s64        ticks = GetSaveData()->play_time;
        CSaveData *save = GetSaveData();
        save->play_time = ticks + 1;
    }
}

void PlayTimeCount(int value) {
    PlayTimeCountFlag = value;
}

int GetPlayTimeCountFlag() {
    return PlayTimeCountFlag;
}

void LanguageChange(int language, u_long128 *buffer) {
    LanguageCode = language;
    GameItemDataManage.LoadItemSystemMes(language);
    LoadHelpMes(read_buffer);
    LoadMapName(LanguageCode, read_buffer);
    LanguageEquipChange();
    LoadNPCCfg();
    LoadSystemMes();
    LoadFontTex2Img();
    LoadGaijiImg();
    LoadFontTexture();
    LoadFontTblBin();
    LoadEditAnalyzeData(LanguageCode, read_buffer);
    LoadFilePictureName();
    LoadMonsterLanguage(LanguageCode);
    InfoStack.stack_used = 0;
    InfoStack.lock = 0;
    LoadGameInfo(&InfoStack);
    InitPauseData();
    InitPadTable(LanguageCode);
}

void MainLoop() {
    // Microprogram addresses loaded when the main game loop starts.
    static u_long128 *vu_prog[16];

    mgCMemory        *memory;
    mgCMemory        *read_memory;
    CUserDataManager *user_data;
    u_long128        *file_buffer;
    int               file_size;
    int               mode_finished;
    int               buffer_address;
    int               alignment;

    memory = GetMainStack();
    memory->stSetBuffer(main_buffer, 0x1A0000);
    memory->stack_used = 0;
    memory->lock = 0;
    SaveData.Initialize();
    ActiveSaveData = &SaveData;
    SubGameSaveData = NULL;
    DebugFlag = 0;
    GamePad__2.Init();
    InitFileCache(NULL, 0);
    mgInit(MG_SCREEN_MODE_512X480, 3);
    PlayTimeCountFlag = 0;
    mgInitVSyncCallBack((int (*)(int)) VSyncCallBack);
    LanguageCode = LANG_FRENCH;
    SCElogoFade(0, memory);
    LoopNo = LOOP_TITLE;
    DebugFlag = 0;
    DebugInfo.chara_move = 0;
    /**
     * Whether the debug performance meter is displayed.
     */
    static int pmeter_flag = 0;

    pmeter_flag = 0;
    GamePad__2.WaitEnable();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    MasterDebugCode = 0;
    DebugFlag = 0;

    if (GamePad__2.On2(PAD_R1) && GamePad__2.On2(PAD_R2) && GamePad__2.On2(PAD_L1) && GamePad__2.On2(PAD_L2)) {
        MasterDebugCode = MASTER_DEBUG_CODE;
    }

    GamePad__2.DebugKeyLock(1);
    sceGsSyncV(0);
    GamePad__2.UpDate();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    mgSetUserVuProg(vu_prog, 16);
    mgSetUserVuProgAdr(0, Vu_prog_wtr);
    InitPadTable(LanguageCode);
    GameItemDataManage.LoadData();
    GameItemDataManage.LoadItemSystemMes(LanguageCode);
    LoadSystemMes();
    CreateSystemMes();
    LoadFontTexture();
    LoadGaijiImg();
    LoadFontTblBin();
    LoadFontTex2Img();
    LoadNPCCfg();
    InfoStack.stSetBuffer(InfoBuff, 5000);
    LoadGameInfo(&InfoStack);
    InitPauseData();
    InitSaveData();
    user_data = NULL;

    if (ActiveSaveData != NULL) {
        user_data = &ActiveSaveData->user_data;
    }

    LoadMonsterLanguage(LanguageCode);
    InitPadTable(LanguageCode);
    LanguageEquipChange();
    DebugGetItem(user_data, 0);
    CaptureMode = CAPTURE_OFF;
    sndInitMngr();
    MainScene.InitSnd();
    SetCurrentDir(NULL);
    SystemSeStack.stSetBuffer(SystemSeBuff, 400);
    SystemSeStack.stack_used = 0;
    SystemSeStack.lock = 0;
    read_memory = GetMainStack();
    buffer_address = (int) (read_memory->stack + read_memory->stack_used);
    alignment = buffer_address % 64;

    if (alignment != 0) {
        buffer_address += ((64 - alignment) / 16) * 16;
    }

    file_buffer = (u_long128 *) buffer_address;
    SystemSND_ID = -1;

    if (LoadFile2("snd2/SY_000.snd", file_buffer, NULL, 0)) {
        SystemSND_ID = sndLoadSound(SND_PORT_SYSTEM, (u_int *) file_buffer, &SystemSeStack);
    }

    if (LoadFile2("snd2/rev.bin", file_buffer, &file_size, 0)) {
        MainScene.LoadSndRevInfo((char *) file_buffer, file_size);
    }

    if (LoadFile2("snd2/MAP_index.txt", file_buffer, &file_size, 0)) {
        MainScene.LoadSndFileInfo((char *) file_buffer, file_size);
    }

    LoadHelpMes(file_buffer);
    LoadMapName(LanguageCode, file_buffer);
    LoadEditAnalyzeData(LanguageCode, file_buffer);
    LoadFilePictureName();
    Font.Init();
    Font.Preset(FONT_PRESET_SHADOWED);
    Font.SetFuchi(0);
    Font.SetClearance(15, 18);
    CreateGamePadThread(&GamePad__2);
    LoadGameConfig(NULL);
    SetIoErrCallBack(EmergencyMessage);
    SCElogoFade(1, memory);

    while (1) {
        if (LoopNo == LOOP_TITLE || OmakeFlag != 0) {
            SubGameSaveData = (CSubGameData *) main_buffer;
            memory->stSetBuffer(main_buffer + 5000, 0x19EC78);
            memory->stack_used = 0;
            memory->lock = 0;
        }

        printf("main_data remain = %dkb\n", ((memory->stack_size - memory->stack_used) * 16) / 1024);

        if (LoopNo < 0 || LoopNo >= LOOP_MODE_NUM) {
            break;
        }

        if (DebugFlag == 0 && LoopNo == LOOP_MENU) {
            LoopNo = LOOP_TITLE;
        }

        if (CaptureMode == CAPTURE_RECORD) {
            GamePad__2.CaptureStart();
            srand(9999);
        }

        if (CaptureMode == CAPTURE_PLAY || CaptureMode == CAPTURE_PLAY_SCREEN) {
            if (CaptureMode != CAPTURE_OFF) {
                GamePad__2.LoadCapture();
            }

            GamePad__2.CapturePlay();
            srand(9999);
        }

        mgFrameRate = 2;
        CaptureScreen = 0;
        GetMainScene()->save_data = GetSaveData();
        float now_time = GetSaveData()->now_time;
        GetMainScene()->SetTime(now_time);
        GetMainScene()->day = GetSaveData()->day;

        if (GetSaveData()->game_progress == 2) {
            CSaveData *save = GetSaveData();
            save->now_time = 22.0f;
            GetMainScene()->SetTime(22.0f);
            GetMainScene()->time_step = 0;
        }

        if (LoopNo == LOOP_TITLE) {
            sndSeAllStop(-1);
            sndDeletePort(SND_PORT_BGM);
            MainScene.InitSnd();
        }

        printf("##### %d\n", mgGetVSyncCount());
        LoopInit[LoopNo](InitArg);
        INIT_LOOP_ARG next_arg;

        NextLoop(LOOP_MENU, next_arg);

        while (1) {
            if (GamePad__2.On(PAD_CIRCLE)) {
                cat_start();
            }

            if (LoopNo != LOOP_MENU) {
                GetMainScene()->save_data = GetSaveData();
                float now_time = GetSaveData()->now_time;
                GetMainScene()->SetTime(now_time);
                GetMainScene()->day = GetSaveData()->day;

                if (GetSaveData()->game_progress == 2) {
                    CSaveData *save = GetSaveData();
                    save->now_time = 22.0f;
                    GetMainScene()->SetTime(22.0f);
                    GetMainScene()->time_step = 0;
                }
            }

            SV_CONFIG_OPTION *config = &GetSaveData()->config;
            GamePad__2.VibrationEnable(!config->vibration);

            if (GamePad__2.Down2(PAD_L1)) {
                pmeter_flag = !pmeter_flag;
            }

            mgPerformanceMeter(pmeter_flag);

            if (GamePad__2.Down2(PAD_CIRCLE)) {
                DebugFlag = !DebugFlag;
            }

            mgBeginFrame(NULL);
            mode_finished = LoopMain[LoopNo]();
            sndStep(mgGetNowFrameRate());
            MainScene.StepSnd();
            GamePad__2.UpDate();
            PadCtrl.Update(&GamePad__2);
            mgCDrawPrim frame_border;
            frame_border.Initialize(NULL, NULL);
            frame_border.DepthTestEnable(0);
            frame_border.AlphaTestEnable(0);
            frame_border.AlphaBlendEnable(0);
            frame_border.TextureMapEnable(0);
            frame_border.ZMask(MG_Z_MASK_MASKED);
            frame_border.Begin(MG_PRIM_LINE_STRIP);
            frame_border.Color(0, 0, 0, 0x80);
            frame_border.Vertex(0, 0, 0);
            frame_border.Vertex(mgScreenWidth - 1, 0, 0);
            frame_border.Vertex(mgScreenWidth - 1, mgScreenHeight - 1, 0);
            frame_border.Vertex(0, mgScreenHeight - 1, 0);
            frame_border.Vertex(0, 0, 0);
            frame_border.End();
            mgEndFrame(NULL);

            if (mode_finished != 0) {
                PauseCancel();
                break;
            }

            if (GamePad__2.On(PAD_CIRCLE)) {
                cat_end();
            }

            switch (LoopNo) {
                case LOOP_EDIT:
                case LOOP_DUNGEON:
                case LOOP_TITLE: {
                    /**
                     * Whether the debug frame-advance pause is enabled.
                     */
                    static int pause = 0;

                    if (GamePad__2.Down2(PAD_SELECT)) {
                        pause = 1;
                    }

                    while (pause != 0) {
                        sceGsSyncV(0);
                        GamePad__2.UpDate();

                        if (GamePad__2.Down(PAD_START) || GamePad__2.Down2(PAD_SELECT)) {
                            pause = 0;
                            break;
                        }

                        if (GamePad__2.Down2(PAD_START)) {
                            mgStoreFrameImage();
                        }

                        if (GamePad__2.Down(PAD_RIGHT | PAD_CIRCLE) || GamePad__2.Down2(PAD_RIGHT)) {
                            break;
                        }
                    }

                    break;
                }
            }

            while (PauseLoop() != 0) {
            }

            PauseCount();
        }

        LoopExit[LoopNo]();

        if (LoopNo != LOOP_MENU) {
            if (CaptureMode != CAPTURE_OFF) {
                GamePad__2.SaveCapture();
            }

            CaptureMode = CAPTURE_OFF;
        }

        PrevLoopNo = LoopNo;
        PrevInitArg = InitArg;
        LoopNo = NextLoopNo;
        InitArg = NextInitArg;
        GamePad__2.CaptureEnd();
        sceGsSyncV(0);
        GamePad__2.UpDate();
        sceGsSyncV(0);
        GamePad__2.UpDate();

        while (sceGsSyncV(0) != 0) {
        }
    }

    sndSeAllStop(-1);
    sndStopVoice(0);
    sndStopVoice(1);
    sceGsSyncV(0);
    sndStep(2.0f);
    sceGsSyncV(0);
    sndStep(2.0f);
    GamePad__2.Close();
}

/**
 * Prepares rendering and resource buffers for the main debug menu.
 */
void MenuInit(INIT_LOOP_ARG arg) {
    mgCMemory *main_stack;
    u_long128 *packet_a;
    u_long128 *packet_b;

    sndSeAllStop(-1);
    sndDeletePort(0);
    MainScene.InitBGM();
    MainScene.InitSeEnv();
    MainScene.InitSeSrc();
    menu_mode = 0;
    mgInitFont();
    main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;

    /**
     * Packet buffer for the first debug-menu draw buffer.
     */
    static mgCMemory buf0;

    /**
     * Packet buffer for the second debug-menu draw buffer.
     */
    static mgCMemory buf1;

    /**
     * Data buffer for the first debug-menu draw buffer.
     */
    static mgCMemory dbuf0;

    /**
     * Data buffer for the second debug-menu draw buffer.
     */
    static mgCMemory dbuf1;

    packet_a = main_stack->stAlloc64(0x2710);
    packet_b = main_stack->stAlloc64(0x2710);
    mgInitVif1Packet(packet_a, packet_b, 0x27100);
    buf0.stSetBuffer(main_stack->stAlloc64(0x2710), 0x2710);
    buf1.stSetBuffer(main_stack->stAlloc64(0x2710), 0x2710);
    dbuf0.stSetBuffer(main_stack->stAlloc64(0xC350), 0xC350);
    dbuf1.stSetBuffer(main_stack->stAlloc64(0xC350), 0xC350);
    MenuBuffer.stSetBuffer(main_stack->stAlloc64(0x7A120), 0x7A120);
    read_buffer = main_stack->stAlloc64(0x186A0);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    GamePad__2.SetAutoRepeat(0xF000, 0xF, 4);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
    SetTextureTable(0x64, 0x14, &MenuBuffer);

    if (DebugFlag == 0) {
        InitEventSelect();
    }

    mgTexManager.DeleteBlock(1);
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 1, NULL, NULL);
    ReLoadFontTexture(1);
    mgTexManager.EnterIMGFile(GetFontTex2ImgPtr(), 1, NULL, NULL);
    LoadEventViewData(read_buffer, &MenuBuffer);
}
/**
 *
 * Runs the debug mode selection menu and its configuration screens.
 *
 */
static int MenuLoop() {
    // Rows displayed by the main debug menu.
    static char *menu[] = {
        "game start ", "map        ", "dungeon    ", "title      ",
        "chrview    ", "texview    ", "mapview    ", "sound view ",
        "movie view ", "Language   ", "Item       ", "Save Data  ",
        "Load cfg   ", "Convert Save Data ", ""
    };

    mgCTextureManager *textures = &mgTexManager;
    int map_result;

    textures->ReloadTexture(1, (sceVif1Packet *)NULL);
    if (DebugFlag == 0) {
        menu_mode = DEBUG_MENU_EVENT_SELECT;
    }
    if (menu_mode == DEBUG_MENU_MAP_SELECT) {
        map_result = MapSelectLoop();
        if (map_result == 2) {
            INIT_LOOP_ARG arg;

            arg.map_no = -1;
            arg.event_no = DefStartEventNo;
            NextLoop(LOOP_EDIT, arg);
            return 1;
        }
        if (map_result == 1) {
            menu_mode = DEBUG_MENU_TOP;
            return 0;
        }
        return 0;
    }
    if (menu_mode == DEBUG_MENU_EVENT_SELECT) {
        textures->ReloadTexture(1, (sceVif1Packet *)NULL);
        return EventSelect() != 0;
    }
    if (menu_mode == DEBUG_MENU_SAVE_DATA_EDIT) {
        if (SaveDataEditLoop()) {
            menu_mode = DEBUG_MENU_TOP;
        }
        return 0;
    }
    char *language[] = {
        "Japanese", "English", "French", "German",
        "Italian", "Spanish", "Chinese", "Korean"
    };
    char *item_set[] = {"Presentation", "GameStart", "StartDebug", "WeaponOnly"};
    int   item_set_no[] = {0, 1, 2, 6};
    char  text[2048];
    char  config_name[64];
    int   row = 0;
    static int select = 0;
    char *cursor[] = {" ", ">"};
    int  *menu_arguments = SelectArg;
    char *text_end;

    if (GamePad__2.Down(PAD_DOWN)) {
        select++;
    }
    if (GamePad__2.Down(PAD_UP)) {
        select--;
    }
    if (select < 0) {
        select = DEBUG_ROW_CONVERT_SAVE;
    }
    if (select >= DEBUG_ROW_NUM) {
        select = 0;
    }
    if (GamePad__2.Down(PAD_RIGHT)) {
        menu_arguments[select]++;
    }
    if (GamePad__2.Down(PAD_LEFT)) {
        menu_arguments[select]--;
    }
    if (GamePad__2.Down(PAD_R1)) {
        menu_arguments[select] += 10;
    }
    if (GamePad__2.Down(PAD_L1)) {
        menu_arguments[select] -= 10;
    }
    int step = 100;
    if (select == 1) {
        step = 100;
    }
    if (GamePad__2.Down(PAD_R2)) {
        menu_arguments[select] += step;
    }
    if (GamePad__2.Down(PAD_L2)) {
        menu_arguments[select] -= step;
    }
    if (menu_arguments[select] < -1) {
        menu_arguments[select] = -1;
    }
    if (select == DEBUG_ROW_LANGUAGE) {
        if (menu_arguments[select] > LANG_SPANISH) {
            menu_arguments[select] = LANG_SPANISH;
        }
        if (menu_arguments[select] < 0) {
            menu_arguments[select] = 0;
        }
    }
    text_end = text;
    text_end += sprintf(text_end, "\nDark Chronicle %s\n", "Ver0.334");
    switch (CaptureMode) {
        case CAPTURE_RECORD:
            text_end += sprintf(text_end, "Capture Input Key\n");
            break;
        case CAPTURE_PLAY:
            text_end += sprintf(text_end, "Play Input Key\n");
            break;
        case CAPTURE_PLAY_SCREEN:
            text_end += sprintf(text_end, "Play Input Key and Capture Screen\n");
            break;
        default:
            text_end += sprintf(text_end, "\n");
            break;
    }
    if (GamePad__2.Down(PAD_SELECT)) {
        CaptureMode++;
    }
    if (CaptureMode > CAPTURE_PLAY_SCREEN) {
        CaptureMode = CAPTURE_OFF;
    }
    while (menu[row][0] != '\0') {
        if (row == DEBUG_ROW_ITEM_SET) {
            text_end += sprintf(text_end, "%s%s%s\n", cursor[row == select], menu[row], item_set[menu_arguments[row]]);
        } else if (row == DEBUG_ROW_LANGUAGE) {
            text_end += sprintf(text_end, "%s%s%s (now %s)\n", cursor[row == select], menu[row], language[menu_arguments[row]], language[LanguageCode]);
        } else if (row <= 0) {
            text_end += sprintf(text_end, "%s%s\n", cursor[row == select], menu[row]);
        } else {
            text_end += sprintf(text_end, "%s%s%d\n", cursor[row == select], menu[row], menu_arguments[row]);
        }
        if (++row >= DEBUG_ROW_NUM) {
            break;
        }
    }
    Font.DrawDirect(text, 10, 10);
    if (GamePad__2.Down(PAD_CIRCLE)) {
        if (select == DEBUG_ROW_EVENT_SELECT) {
            InitEventSelect();
            return 0;
        } else if (select == DEBUG_ROW_LANGUAGE) {
            LanguageChange(menu_arguments[select], read_buffer);
            return 0;
        } else if (select == DEBUG_ROW_ITEM_SET) {
            CUserDataManager *user = &GetSaveData()->user_data;
            DebugGetItem(user, item_set_no[menu_arguments[select]]);
            return 0;
        } else if (select == DEBUG_ROW_SAVE_DATA) {
            InitSaveDataEdit(&MenuBuffer);
            menu_mode = DEBUG_MENU_SAVE_DATA_EDIT;
            return 0;
        } else if (select == DEBUG_ROW_LOAD_CFG) {
            sprintf(config_name, "dbg/game%d.cfg", menu_arguments[select]);
            InitSaveData();
            LoadGameConfig(config_name);
            return 0;
        } else {
            if (menu_arguments[select] < 0 && select == LOOP_EDIT) {
                InitMapSelect(&MenuBuffer);
                menu_mode = DEBUG_MENU_MAP_SELECT;
                return 0;
            }
            if (select == DEBUG_ROW_CONVERT_SAVE) {
                INIT_LOOP_ARG arg;

                NextLoop(LOOP_SV_CONV_VIEW, arg);
            } else {
                INIT_LOOP_ARG arg;

                arg.map_no = menu_arguments[select];
                arg.event_no = DefStartEventNo;
                NextLoop(select, arg);
            }
            return 1;
        }
    }
    return 0;
}
/**
 * Releases debug-menu input repeat and font state.
 */
void MenuExit() {
    GamePad__2.AutoRepeatOff();
    mgCloseFont();
}

void InitEventSelect() {
    event_view = 0;
    future_sel = 0;
    menu_mode = 2;
    hdd_sel = 0;
}

/**
 *
 * Runs the debug chapter, event, map and extra-mode selection screen.
 *
 */
static int EventSelect() {
    // Persistent row values selected by the chapter and event debug menu.
    static int menu_sel[11] = {0};

    // Rows displayed by the chapter and event debug menu.
    static char *menu[12] = {
        "It begins in the beginning:",
        "From each chapter(normal) :",
        "From each chapter(debug)  :",
        "sub game                  :",
        "PalmBrink's               :",
        "event                     :",
        "boss battle               :",
        "future map                :",
        "diorama map               :",
        "HDD                       :",
        "extra                     :",
        ""
    };

    int           result;

    if (event_view != 0) {
        result = EventViewLoop();
        if (result == EVENT_VIEW_CONTINUE) {
            return 0;
        } else if (result == EVENT_VIEW_START) {
            return 1;
        } else if (result == EVENT_VIEW_CANCEL) {
            event_view = 0;
        }
        return 0;
    }
    if (future_sel != 0) {
        result = FutureMapSelect();
        if (result == FUTURE_MAP_SELECT_CONTINUE) {
            return 0;
        } else if (result == FUTURE_MAP_SELECT_CHOSEN) {
            return 1;
        } else if (result == FUTURE_MAP_SELECT_CLOSED) {
            future_sel = 0;
        }
        return 0;
    }
    if (hdd_sel != 0) {
        result = HDDMenuLoop();
        if (result == 0) {
            return 0;
        } else if (result > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    char          display[1024];
    char         *subgame_name[3] = { "Spheda", "GyoRace", "Fishing" };
    int           row = 0;
    char         *map_name;
    static int    select = 0;
    int           loop_no;
    int           monica;
    char         *text = display;
    char         *cursor[2] = { "  ", ">>" };

    if (GamePad__2.Down(PAD_DOWN)) {
        select++;
    }
    if (GamePad__2.Down(PAD_UP)) {
        select--;
    }
    if (select < 0) {
        select = 10;
    }
    if (select >= 11) {
        select = 0;
    }
    if (GamePad__2.Down(PAD_RIGHT)) {
        menu_sel[select]++;
    }
    if (GamePad__2.Down(PAD_LEFT)) {
        menu_sel[select]--;
    }
    switch (select) {
        case 1:
        case 2:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }
            if (menu_sel[select] > 6) {
                menu_sel[select] = 6;
            }
            break;
        case 3:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }
            if (menu_sel[select] > 2) {
                menu_sel[select] = 2;
            }
            break;
        case 8:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }
            if (menu_sel[select] > 4) {
                menu_sel[select] = 4;
            }
            break;
        case 10:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }
            if (menu_sel[select] > 1) {
                menu_sel[select] = 1;
            }
            break;
    }

    text += sprintf(text, "\n\x83\x5F\x81\x5B\x83\x4E\x83\x4E\x83\x8D\x83\x6A\x83\x4E\x83\x8B\x83\x56\x83\x58\x83\x65\x83\x80\x92\xB2\x90\xAE" "ROM %s %s\n", "2003/07/29", "Ver0.334");
    for (; menu[row][0] != '\0'; row++) {
        text += sprintf(text, "%s%s", cursor[row == select], menu[row]);
        switch (row) {
            case 1:
            case 2:
                text += sprintf(text, "%d\x8F\xCD", menu_sel[row] + 1);
                break;
            case 3:
            case 10:
                text += sprintf(text, "%s", subgame_name[menu_sel[row]]);
                break;
            case 8:
                if (GetMapName(menu_sel[row], &map_name)) {
                    text += sprintf(text, "%s", map_name);
                }
                break;
        }
        text += sprintf(text, "\n");
    }
    text += sprintf(text, "\n");
    switch (select) {
        case 2:
        case 1:
            sprintf(text, "\x95\xFB\x8C\xFC\x83\x4C\x81\x5B\x8D\xB6\x89\x45\x82\xC5\x8F\xCD\x91\x49\x91\xF0\n");
            break;
        case 3:
            sprintf(text, "\x95\xFB\x8C\xFC\x83\x4C\x81\x5B\x8D\xB6\x89\x45\x82\xC5\x83\x54\x83\x75\x83\x51\x81\x5B\x83\x80\x82\xCC\x8E\xED\x97\xDE\x91\x49\x91\xF0\n");
            break;
    }
    Font.DrawDirect(display, 10, 10);

    if (GamePad__2.Down(PAD_CROSS)) {
        menu_mode = DEBUG_MENU_TOP;
        return 0;
    }
    if (GamePad__2.Down(PAD_CIRCLE)) {
        INIT_LOOP_ARG arg;
        char config_name[64] = "";
        char config_path[64];

        loop_no = LOOP_EDIT;
        monica = 0;
        switch (select) {
            case 0:
                arg.map_no = 0;
                loop_no = LOOP_TITLE;
                config_name[0] = '\0';
                break;
            case 1:
            case 2:
                {
                    switch (menu_sel[select]) {
                        case 0:
                            arg.floor_no = 1;
                            loop_no = LOOP_DUNGEON;
                            arg.map_no = 0;
                            break;
                        case 1:
                            arg.map_no = 15;
                            arg.event_no = 502;
                            break;
                        case 2:
                            arg.map_no = 54;
                            arg.event_no = 502;
                            break;
                        case 3:
                            arg.map_no = 83;
                            arg.event_no = 100;
                            break;
                        case 4:
                            arg.map_no = 87;
                            arg.event_no = 100;
                            break;
                        case 5:
                            arg.map_no = 110;
                            arg.event_no = 100;
                            break;
                        case 6:
                            arg.map_no = 109;
                            arg.event_no = 502;
                            break;
                    }
                    if (menu_sel[select] >= 2) {
                        monica = 1;
                    }
                    if (select == 1) {
                        sprintf(config_name, "cap%d.cfg", menu_sel[select] + 1);
                    } else {
                        sprintf(config_name, "db_cap%d.cfg", menu_sel[select] + 1);
                    }
                    break;
                }
            case 3:
                {
                    int subgame = menu_sel[select];
                    switch (subgame) {
                        case 0:
                            arg.floor_no = 1;
                            arg.event_no = 4000;
                            arg.map_no = 2;
                            loop_no = LOOP_DUNGEON;
                            break;
                        case 1:
                            arg.map_no = 95;
                            break;
                        case 2:
                            arg.map_no = 65;
                            break;
                    }
                    sprintf(config_name, "sg%d.cfg", subgame);
                    break;
                }
            case 4:
                sprintf(config_name, "pb.cfg");
                arg.map_no = 10;
                break;
            case 6:
                BossBattleSelFlag = 1;
            case 5:
                event_view = 1;
                return 0;
            case 7:
                future_sel = 1;
                return 0;
            case 8:
                arg.map_no = menu_sel[select];
                sprintf(config_name, "geo.cfg");
                break;
            case 9:
                hdd_sel = 1;
                InitHDDMenu(MenuBuffer.stack + MenuBuffer.stack_used);
                return 0;
            case 10:
                InitSaveData();
                InitOmakeEnv(menu_sel[select], &arg, &loop_no);
                NextLoop(loop_no, arg);
                return 1;
        }
        sprintf(config_path, "dbg/%s", config_name);
        InitSaveData();
        LoadGameConfig(config_path);
        if (monica != 0) {
            GetSaveData()->user_data.JoinPartyMember(USER_CHARA_MONICA);
            GetSaveData()->user_data.EnableCharaChange(USER_CHARA_MONICA);
        }
        NextLoop(loop_no, arg);
        return 1;
    }
    return 0;
}
mgCTexture *GetFontTexture(int page) {
    if ((page < 0) || (page > 0)) {
        return 0;
    }

    return FontTex[page];
}

void LoadFontTexture() {
    u8   scratch[0x35000];
    char path[0x40];
    char file_name[0x20];
    int  size;
    u8  *buffer;
    int  page;
    u32  misalign;

    buffer = scratch;
    FontTex[0] = 0;
    misalign = (u32) buffer & 3;
    FontDataAdr[0] = 0;

    if (misalign != 0) {
        buffer += (4 - misalign) * 0x10;
    }

    page = 0;

    do {
        if (LanguageCode == 0) {
            sprintf(file_name, "FontTex_%d.tm2", page);
        } else if (LanguageCode == 1) {
            if (page == 0) {
                sprintf(file_name, "FontTex_1_0.tm2", page);
            }
        } else if (page == 0) {
            sprintf(file_name, "FontTex_2_0.tm2");
        }

        sprintf(path, "meswin/%s", file_name);

        if (LoadFile2(path, buffer, &size, 0) != 0) {
            FontDataAdr[page] = (TM2_head *) font_buff;

            if (FontDataAdr[page] == 0) {
                return;
            }

            memcpy(FontDataAdr[page], buffer, size);
        }

        page += 1;
    } while (page <= 0);
}

void ReLoadFontTexture(int texture_no) {
    char file_name[0x20];
    int  page;

    for (page = 0; page <= 0; page++) {
        if (FontDataAdr[page] != NULL) {
            if (LanguageCode == 0) {
                sprintf(file_name, "FontTex_%d.tm2", page);
            } else if (LanguageCode == 1) {
                if (page == 0) {
                    sprintf(file_name, "FontTex_1_0.tm2", page);
                }
            } else if (page == 0) {
                sprintf(file_name, "FontTex_2_0.tm2");
            }

            if (&mgTexManager == NULL) {
                return;
            }

            FontTex[page] = mgTexManager.EnterTexture(texture_no, file_name, FontDataAdr[page], 0, 0);
        }
    }
}

void demQuit() {}

void demoQuitTimeOut() {}

void demoAttractInterrupted() {}

void demoAttractComplete() {}

void FadeOutForE3() {}

int TimeLimitCheck() { return 0; }

void InitPauseMenu(int value) {
    PauseMes.Init();
    PauseMes.Preset(MES_PRESET_SMALL_FUKIDASHI);
    PauseMes.texture_block = value;
    PauseMes.SetWindowMode(MES_WIN_YESNO);
    BlackFade = 0.0f;
    PauseSel = 1;
    BlackFade2 = 0.0f;
    PauseMenuMode = PAUSE_MENU_OPEN;
    exit_start = 0;
}

int PauseMenu() {
    int result;
    int previous_select;

    result = PAUSE_MENU_STAY;

    switch (PauseMenuMode) {
        case PAUSE_MENU_OPEN:
            PauseMenuMode = PAUSE_MENU_SELECT;
            break;
        case PAUSE_MENU_SELECT:
            previous_select = PauseSel;

            if (PadCtrl.Btn(9)) {
                PauseSel = 1;
            }

            if (PadCtrl.Btn(10)) {
                PauseSel = 0;
            }

            if (PadCtrl.Analog(PAD_ANALOG_LEFT_X) > 0.8f) {
                PauseSel = 1;
            }

            if (PadCtrl.Analog(PAD_ANALOG_LEFT_X) < -0.8f) {
                PauseSel = 0;
            }

            int selected = PauseSel;

            if (PauseMes.select < 0) {
                PauseMes.cursor_time = 0;
            }

            PauseMes.select = selected;

            if (previous_select != PauseSel) {
                sndSePlay(GetSystemSndID(), 0, 0);
            }

            if (PadCtrl.Btn(0)) {
                if (PauseSel == 0) {
                    BlackFade = 0.0f;
                    PauseMenuMode = PAUSE_MENU_FADE_OUT;
                    sndSePlay(GetSystemSndID(), 1, 0);
                } else {
                    result = PAUSE_MENU_RESUME;
                }
            }

            if (GamePad__2.Down(PAD_START)) {
                result = PAUSE_MENU_RESUME;
            }

            break;
        case PAUSE_MENU_FADE_OUT:
            BlackFade += 0.03f;

            if (BlackFade >= 1.0f) {
                BlackFade = 1.0f;
                PauseMenuMode = PAUSE_MENU_END;
            }

            break;
        case PAUSE_MENU_END:
            result = PAUSE_MENU_QUIT;
            break;
    }

    mgCDrawPrim prim;

    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.AlphaBlendEnable(1);
    prim.ZMask(MG_Z_MASK_WRITE);
    prim.TextureMapEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0, 0, 0, 0x40);
    prim.Vertex(0, 0, 0);
    prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim.End();
    PauseMes.fukidashi_pos = 5;
    PauseMes.Step();
    PauseMes.DrawMesWin();
    return result;
}

void LoadGameConfig(char *path) {
    u8  script[0x4000];
    int size;

    if (path == NULL) {
        SetCurrentDir("");

        if (LoadFile2("game.cfg", script, &size, 0) == 0) {
            SetCurrentDir(NULL);
            return;
        }

        SetCurrentDir(NULL);
    } else if (LoadFile2(path, script, &size, 0) == 0) {
        return;
    }

    CScriptInterpreter interpreter;
    interpreter.SetTag(tag__3);
    interpreter.SetScript((char *) script, size);
    interpreter.Run();
}

int gcMAP_NO(SPI_STACK *stack, int arg) {
    int map_no;

    if (stack->type == 0) {
        map_no = SearchMapNo(spiGetStackString(stack));
    } else {
        map_no = spiGetStackInt(stack);
    }

    SelectArg[LOOP_EDIT] = map_no;
    return 1;
}

int gcPROGRESS(SPI_STACK *stack, int arg) {
    int        value = spiGetStackInt(stack);
    CSaveData *save = GetSaveData();
    save->game_progress = value;
    return 0;
}

int gcBIT_FLAG_ON(SPI_STACK *stack, int count) {
    CSaveData *save_data;
    int        i;

    for (i = 0; i < count; i++) {
        save_data = GetSaveData();
        save_data->SetBitFlag(spiGetStackInt(stack++), 1);
    }

    return 0;
}

int gcBIT_FLAG_OFF(SPI_STACK *stack, int count) {
    CSaveData *save_data;
    int        i;

    for (i = 0; i < count; i++) {
        save_data = GetSaveData();
        save_data->SetBitFlag(spiGetStackInt(stack++), 0);
    }

    return 0;
}

int gcSTART_EVENT(SPI_STACK *stack, int arg_count) {
    DefStartEventNo = spiGetStackInt(stack);
    return 0;
}

int gcGEO_COMPLETE(SPI_STACK *stack, int count) {
    int        i;
    int        index;
    CEditData *edit_data;

    DebugInfo.georama_debug = 1;

    for (i = 0; i < count; i++) {
        index = spiGetStackInt(stack++);
        edit_data = GetSaveData()->GetEditData(index);

        if (edit_data != 0) {
            edit_data->dbgSetAllContintionFlag(index, 1);
        }
    }

    return 1;
}

int gcGEO_DEBUG(SPI_STACK *stack, int arg_count) {
    DebugInfo.georama_debug = 1;
    return 1;
}

int gcITEM_SET(SPI_STACK *stack, int arg_count) {
    CUserDataManager *user_data;

    user_data = &GetSaveData()->user_data;
    DebugGetItem(user_data, spiGetStackInt(stack));
    return 1;
}

int gcGET_ITEM(SPI_STACK *stack, int count) {
    int               i;
    CUserDataManager *user_data;

    for (i = 0; i < count; i++) {
        user_data = &GetSaveData()->user_data;
        user_data->GetItem(spiGetStackInt(stack++), 1);
    }

    return 1;
}

int gcGET_N_ITEM(SPI_STACK *stack, int count) {
    int               item_no;
    int               i;
    CUserDataManager *user_data;

    for (i = 0; i < count; i++) {
        user_data = &GetSaveData()->user_data;
        item_no = spiGetStackInt(stack++);
        user_data->GetItem(item_no, spiGetStackInt(stack++));
    }

    return 1;
}

int gcEQUIP(SPI_STACK *stack, int arg_count) {
    int               chara_no;
    int               item_no;
    CUserDataManager *user_data;
    user_data = &GetSaveData()->user_data;
    chara_no = spiGetStackInt(stack++);
    item_no = spiGetStackInt(stack);
    user_data->SetChrEquip(chara_no, item_no);
    return 1;
}

int gcDEFENSE(SPI_STACK *stack, int arg_count) {
    int         chara_no;
    int         defence;
    CHARA_DATA *chara;

    chara_no = spiGetStackInt(stack++);
    defence = spiGetStackInt(stack);
    chara = GetSaveData()->user_data.GetCharaDataPtr(chara_no);

    if (chara != NULL) {
        chara->defence = defence;
    }

    return 1;
}

int gcHP(SPI_STACK *stack, int arg_count) {
    int         chara_no;
    int         hp;
    CHARA_DATA *chara;

    chara_no = spiGetStackInt(stack++);
    hp = spiGetStackInt(stack);
    chara = GetSaveData()->user_data.GetCharaDataPtr(chara_no);

    if (chara != NULL) {
        chara->hp.max = hp;
        chara->hp.now = hp;
    }

    return 1;
}

/**
 *
 * Unlocks Geostones and town conditions and grants Georama materials.
 *
 */
static int gcALL_GEO_PARTS(SPI_STACK *stack, int argc) {
    CSaveDataDungeon *dungeon;
    DNG_FLOOR_SAVE   *floor;
    CEditData        *edit;
    int               mode;
    int               stage;
    int               floor_no;
    int               town;
    int               i;

    mode = 0;

    if (argc > 0) {
        mode = spiGetStackInt(stack);
    }

    dungeon = &GetSaveData()->save_dungeon;

    for (stage = 0; stage < SAVE_DUNGEON_NUM; stage++) {
        for (floor_no = 0; floor_no < 40; floor_no++) {
            floor = dungeon->GetFloorInfoPtr(stage, floor_no);

            if (floor != NULL) {
                floor->flag |= DNG_FLOOR_FLAG_GEOSTONE_FOUND | DNG_FLOOR_FLAG_GEOSTONE_READ;
            }
        }
    }

    for (town = 0; town < SAVE_EDIT_DATA_MAX; town++) {
        edit = GetSaveData()->GetEditData(town);

        if (edit != NULL) {
            for (i = 0; i < EDIT_ANALYZE_DATA_MAX; i++) {
                edit->analyze.data_open[i] = 1;
            }

            for (i = 0; i < EDIT_ANALYZE_CONDITION_MAX; i++) {
                edit->analyze.condition_open[i] = 1;
            }
        }
    }

    if (mode == 0) {
        for (i = 0; i < 999; i++) {
            GetSaveData()->SetBuildPartsNum(i, 30);
        }
    }

    if (mode == 1) {
        for (i = 210; i < 245; i++) {
            GetSaveData()->GetItem(i, 99);
        }
    }

    return 1;
}

int gcPARAM_DRAW(SPI_STACK *stack, int arg_count) {
    DebugInfo.param_off = !spiGetStackInt(stack);
    return 1;
}

int gcOPTION(SPI_STACK *stack, int arg) {
    char             *name;
    SV_CONFIG_OPTION *options;
    SPI_STACK        *value;

    value = stack + 1;
    name = spiGetStackString(stack);

    if (name == NULL) {
        return 0;
    }

    options = &GetSaveData()->config;

    if (strcmp(name, "MonsterName") == 0) {
        options->monster_name = spiGetStackInt(value);
    } else if (strcmp(name, "Map") == 0) {
        options->map = spiGetStackInt(value);
    } else if (strcmp(name, "EnemyHP") == 0) {
        options->enemy_hp = spiGetStackInt(value);
    } else if (strcmp(name, "AngerCounter") == 0) {
        options->anger_counter = spiGetStackInt(value);
    }

    return 1;
}

int gcMONICA(SPI_STACK *stack, int arg_count) {
    CUserDataManager *manager;

    manager = GetUserDataMan();

    if (manager) {
        manager->JoinPartyMember(1);
    }

    return 1;
}

int gcSTEVE(SPI_STACK *stack, int mode) {
    CUserDataManager *manager;

    manager = GetUserDataMan();

    if (manager == NULL) {
        return 0;
    }

    manager->JoinPartyMember(2);
    manager->GetItemNotOver(0xF6, 1);

    if (mode == 2) {
        manager->DeleteItem(0xF6, 1);
        manager->GetItemNotOver(GetRidePodCore(spiGetStackInt(stack)), 1);
    }

    return 1;
}

int gcMONSTER(SPI_STACK *stack, int arg_count) {
    int               sp7_c;
    CUserDataManager *manager;
    int               i;
    int               monster_id;
    int               badge_no;
    MOS_CHANGE_PARAM *badge;

    manager = GetUserDataMan();

    if (manager == NULL) {
        return 0;
    }

    manager->JoinPartyMember(3);
    manager->GetItemNotOver(0x134, 1);

    for (i = 0; i < arg_count; i++) {
        monster_id = spiGetStackInt(stack++);
        badge_no = get_gajji_id_from_monster_progress_table(monster_id, &sp7_c) + 1;
        manager->monster_box.EnableChange(badge_no);
        badge = manager->monster_box.GetMonsterBajjiData(badge_no);

        if (badge != NULL) {
            badge->class_level = sp7_c;
            badge->monster_id = monster_id;
            badge->progress = GetMonsterProgressTableNo(sp7_c, monster_id);
        }

        manager->monster_id = monster_id;
    }

    return 1;
}

int gcPARTY(SPI_STACK *stack, int arg_count) {
    int               chara_no;
    CUserDataManager *manager;

    chara_no = spiGetStackInt(stack);

    if (chara_no <= 0 || chara_no > 0x1A) {
        return 0;
    }

    manager = GetUserDataMan();

    if (manager != NULL) {
        manager->JoinPartyChara(chara_no, 0x80, 1);
        manager->SetPartyCharaStatus(chara_no, 1);
    }

    return 1;
}

int gcACTIVE_CHARA(SPI_STACK *stack, int arg_count) {
    int               chara_no;
    CUserDataManager *manager;

    chara_no = spiGetStackInt(stack);

    if (chara_no < 0) {
        chara_no = 0;
    }

    if (chara_no > 1) {
        chara_no = 1;
    }

    manager = GetUserDataMan();

    if (manager) {
        manager->SetActiveChrNo(chara_no);
    }

    return 1;
}

CUserDataManager::CUserDataManager() {}

CEditData::CEditData() {
    Initialize();
}

// Small initialised data (.sdata)
int MainThreadPriority = 1;

// Small uninitialised data (.sbss)
u_long128 *read_buffer;
u32 SystemSND_ID;
int DebugFlag;
int DefStartEventNo;
int LanguageCode;
int OmakeFlag;
int MasterDebugCode;
CSound CSnd;

// Uninitialised data (.bss)
CGamePad GamePad__2;
CPadControl PadCtrl;
DEBUG_INFO    DebugInfo;
/**
 * Font used by debug screens.
 */
CFont         Font;
/**
 * Initialization arguments for the current game mode.
 */
INIT_LOOP_ARG InitArg;
/**
 * Initialization arguments for the next game mode.
 */
INIT_LOOP_ARG NextInitArg;
/**
 * Initialization arguments for the previous game mode.
 */
INIT_LOOP_ARG PrevInitArg;
/**
 * Main allocator over the game resource arena.
 */
static mgCMemory MainBuffer;
/**
 * Scene used by the main game modes.
 */
CScene           MainScene;
/**
 * Allocator for system sound-effect resources.
 */
mgCMemory SystemSeStack;
/**
 * Allocator for configuration and villager records.
 */
mgCMemory InfoStack;
/**
 * Main save-data object owned by the game loop.
 */
CSaveData SaveData;
/**
 * Allocator for the debug menu resources.
 */
mgCMemory MenuBuffer;
/**
 * Message window used by the pause menu.
 */
ClsMes PauseMes;
