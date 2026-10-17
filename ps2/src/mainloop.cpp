#include "common.h"

#include <libgraph.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "charaviewlp.hpp"
#include "convviewlp.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "editdata.hpp"
#include "editloop.hpp"
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
#include "mapviewlp.hpp"
#include "menuchr.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "movieviewlp.hpp"
#include "nd_meswin.hpp"
#include "nowload.hpp"
#include "npccfg.hpp"
#include "padcontrol.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sndviewlp.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "texviewlp.hpp"
#include "title.hpp"
#include "userdata.hpp"
#include "visualmotion.hpp"
#include "vlgr_info.hpp"
#include "water.hpp"

/**
 * Mode entered after the current main loop finishes.
 */
static int NextLoopNo;
/**
 * Mode active before the current main loop.
 */
static int PrevLoopNo;
/**
 * Whether input replay also captures screen images.
 */
static int CaptureScreen;
/**
 * Selected pause-menu command.
 */
static int PauseSel;
/**
 * Stage of the pause menu.
 */
static int PauseMenuMode;
/**
 * Whether leaving the pause menu has started.
 */
static int exit_start;
/**
 * Opacity of the pause-menu screen fade.
 */
static float BlackFade;
/**
 * Opacity of the pause-menu message fade.
 */
static float     BlackFade2;
#ifdef PORT
#include "port_memory_budget.hpp"
#define MAIN_BUFFER_QUADWORDS PORT_MAIN_BUFFER_QUADWORDS
#else
#define MAIN_BUFFER_QUADWORDS 0x1A0000
#endif

/**
 * Main memory arena for game resources.
 */
u_long128 main_buffer[MAIN_BUFFER_QUADWORDS];
/**
 * Memory backing the system sound-effect loader.
 */
static u_long128 SystemSeBuff[400];
/**
 * Memory backing configuration and villager data.
 */
static u_long128 InfoBuff[5000];
static void      MenuInit(INIT_LOOP_ARG arg);
static void      MenuExit();
static int       MenuLoop();
static int       EventSelect();
LOOP_INIT_FUNC   LoopInit[LOOP_MODE_NUM] = {
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
    {PAD_BTN_CONFIRM,            PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_CANCEL,             PAD_CTRL_TRIGGER_DOWN, PAD_CROSS   },
    {PAD_BTN_R1_HELD,            PAD_CTRL_TRIGGER_ON,   PAD_R1      },
    {PAD_BTN_L1_HELD,            PAD_CTRL_TRIGGER_ON,   PAD_L1      },
    {PAD_BTN_L2,                 PAD_CTRL_TRIGGER_DOWN, PAD_L2      },
    {PAD_BTN_MENU,               PAD_CTRL_TRIGGER_DOWN, PAD_TRIANGLE},
    {PAD_BTN_R2,                 PAD_CTRL_TRIGGER_DOWN, PAD_R2      },
    {PAD_BTN_UP,                 PAD_CTRL_TRIGGER_DOWN, PAD_UP      },
    {PAD_BTN_DOWN,               PAD_CTRL_TRIGGER_DOWN, PAD_DOWN    },
    {PAD_BTN_RIGHT,              PAD_CTRL_TRIGGER_DOWN, PAD_RIGHT   },
    {PAD_BTN_LEFT,               PAD_CTRL_TRIGGER_DOWN, PAD_LEFT    },
    {11,                         PAD_CTRL_TRIGGER_ON,   PAD_UP      },
    {12,                         PAD_CTRL_TRIGGER_ON,   PAD_DOWN    },
    {13,                         PAD_CTRL_TRIGGER_ON,   PAD_RIGHT   },
    {14,                         PAD_CTRL_TRIGGER_ON,   PAD_LEFT    },
    {PAD_BTN_START,              PAD_CTRL_TRIGGER_DOWN, PAD_START   },
    {PAD_BTN_CONFIRM_2,          PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_CANCEL_2,           PAD_CTRL_TRIGGER_DOWN, PAD_CROSS   },
    {19,                         PAD_CTRL_TRIGGER_ON,   PAD_CIRCLE  },
    {PAD_BTN_EVENT_SKIP_2,       PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_PAUSE,              PAD_CTRL_TRIGGER_DOWN, PAD_START   },
    {PAD_BTN_EVENT_SKIP,         PAD_CTRL_TRIGGER_DOWN, PAD_TRIANGLE},
    {PAD_BTN_QUICK_CHANGE,       PAD_CTRL_TRIGGER_DOWN, PAD_L3      },
    {24,                         PAD_CTRL_TRIGGER_DOWN, PAD_R3      },
    {PAD_BTN_ACTION_CONFIRM,     PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_ACTION_SQUARE,      PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE  },
    {PAD_BTN_ACTION_CANCEL,      PAD_CTRL_TRIGGER_DOWN, PAD_CROSS   },
    {PAD_BTN_L1_HELD_2,          PAD_CTRL_TRIGGER_ON,   PAD_L1      },
    {PAD_BTN_R1_HELD_2,          PAD_CTRL_TRIGGER_ON,   PAD_R1      },
    {55,                         PAD_CTRL_TRIGGER_DOWN, PAD_SELECT  },
    {PAD_BTN_ACTION_HELD,        PAD_CTRL_TRIGGER_ON,   PAD_CIRCLE  },
    {PAD_BTN_EDIT_TURN_DECREASE, PAD_CTRL_TRIGGER_DOWN, PAD_R2      },
    {PAD_BTN_EDIT_TURN_INCREASE, PAD_CTRL_TRIGGER_DOWN, PAD_L2      },
    {PAD_BTN_EDIT_PLACE,         PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_EDIT_REMOVE,        PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_EDIT_PAINT,         PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_EDIT_PAINT_ALL,     PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE  },
    {PAD_BTN_EDIT_WALL_NEXT,     PAD_CTRL_TRIGGER_DOWN, PAD_R2      },
    {PAD_BTN_EDIT_WALL_PREVIOUS, PAD_CTRL_TRIGGER_DOWN, PAD_L2      },
    {18,                         PAD_CTRL_TRIGGER_DOWN, PAD_R1      },
    {PAD_BTN_EDIT_SWITCH,        PAD_CTRL_TRIGGER_DOWN, PAD_SELECT  },
    {PAD_BTN_EDIT_MAGNET,        PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE  },
    {PAD_BTN_FISH_ACTION,        PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE  },
    {PAD_BTN_FISH_REEL,          PAD_CTRL_TRIGGER_ON,   PAD_CIRCLE  },
    {PAD_BTN_FISH_REEL_FAST,     PAD_CTRL_TRIGGER_ON,   PAD_SQUARE  },
    {-1,                         -1,                    -1          },
};
/**
 * Mappings from logical analog controls to pad stick axes.
 */
static ANALOG_TABLE_ENTRY analog_table[] = {
    {PAD_ANALOG_LEFT_X,    PAD_CTRL_AXIS_LX},
    {PAD_ANALOG_LEFT_Y,    PAD_CTRL_AXIS_LY},
    {PAD_ANALOG_RIGHT_X,   PAD_CTRL_AXIS_RX},
    {PAD_ANALOG_RIGHT_Y,   PAD_CTRL_AXIS_RY},
    {PAD_ANALOG_LEFT_Y_2,  PAD_CTRL_AXIS_LY},
    {PAD_ANALOG_LEFT_X_2,  PAD_CTRL_AXIS_LX},
    {PAD_ANALOG_RIGHT_X_2, PAD_CTRL_AXIS_RX},
    {PAD_ANALOG_RIGHT_Y_2, PAD_CTRL_AXIS_RY},
    {-1,                   -1              },
};

extern CFont     Font;
extern mgCMemory MainBuffer;
/**
 * Active page of the debug menu.
 */
static int menu_mode;
static void InitEventSelect();

/**
 * Values selected by the debug menu and game configuration tags.
 */
static int SelectArg[32] = {0};

/**
 * Save data used by the current game mode.
 */
static CSaveData *ActiveSaveData;
/**
 * Selected input capture or replay mode.
 */
static int CaptureMode;
/**
 * Currently active main-loop mode.
 */
static int LoopNo;
/**
 * Whether vertical blank advances the saved play time.
 */
static int PlayTimeCountFlag;
/**
 * Save-data arena for the active extra game.
 */
static CSubGameData *SubGameSaveData;
/**
 * Whether the event-selection sub-menu is open.
 */
static int event_view;
/**
 * Whether the future-map sub-menu is open.
 */
static int future_sel;
/**
 * Whether the hard-disk debug menu is open.
 */
static int           hdd_sel;
extern CScene        MainScene;

/**
 * Font texture pages loaded for the current language.
 */
static mgCTexture *FontTex[1];
/**
 * Texture image data for each font page.
 */
static TM2_head *FontDataAdr[1];
/**
 * Image storage used when loading font texture pages.
 */
static u8 font_buff[0xD000];

static int gcMAP_NO(SPI_STACK *stack, int arg_count);
static int gcPROGRESS(SPI_STACK *stack, int arg_count);
static int gcBIT_FLAG_ON(SPI_STACK *stack, int arg_count);
static int gcBIT_FLAG_OFF(SPI_STACK *stack, int arg_count);
static int gcSTART_EVENT(SPI_STACK *stack, int arg_count);
static int gcGEO_COMPLETE(SPI_STACK *stack, int arg_count);
static int gcGEO_DEBUG(SPI_STACK *stack, int arg_count);
static int gcITEM_SET(SPI_STACK *stack, int arg_count);
static int gcGET_ITEM(SPI_STACK *stack, int arg_count);
static int gcGET_N_ITEM(SPI_STACK *stack, int arg_count);
static int gcEQUIP(SPI_STACK *stack, int arg_count);
static int gcDEFENSE(SPI_STACK *stack, int arg_count);
static int gcHP(SPI_STACK *stack, int arg_count);
static int gcALL_GEO_PARTS(SPI_STACK *stack, int arg_count);
static int gcPARAM_DRAW(SPI_STACK *stack, int arg_count);
static int gcOPTION(SPI_STACK *stack, int arg_count);
static int gcMONICA(SPI_STACK *stack, int arg_count);
static int gcSTEVE(SPI_STACK *stack, int arg_count);
static int gcMONSTER(SPI_STACK *stack, int arg_count);
static int gcPARTY(SPI_STACK *stack, int arg_count);
static int gcACTIVE_CHARA(SPI_STACK *stack, int arg_count);

/**
 * Tags accepted by the main game configuration parser.
 */
static SPI_TAG_PARAM tag__3[] = {
    {"MAP_NO",        gcMAP_NO       },
    {"PROGRESS",      gcPROGRESS     },
    {"BIT_FLAG_ON",   gcBIT_FLAG_ON  },
    {"BIT_FLAG_OFF",  gcBIT_FLAG_OFF },
    {"START_EVENT",   gcSTART_EVENT  },
    {"GEO_COMPLETE",  gcGEO_COMPLETE },
    {"GEO_DEBUG",     gcGEO_DEBUG    },
    {"ITEM_SET",      gcITEM_SET     },
    {"GET_ITEM",      gcGET_ITEM     },
    {"GET_N_ITEM",    gcGET_N_ITEM   },
    {"EQUIP",         gcEQUIP        },
    {"DEFENSE",       gcDEFENSE      },
    {"DEFENCE",       gcDEFENSE      },
    {"HP",            gcHP           },
    {"ALL_GEO_PARTS", gcALL_GEO_PARTS},
    {"PARAM_DRAW",    gcPARAM_DRAW   },
    {"OPTION",        gcOPTION       },
    {"MONICA",        gcMONICA       },
    {"STEVE",         gcSTEVE        },
    {"MONSTER",       gcMONSTER      },
    {"PARTY",         gcPARTY        },
    {"ACTIVE_CHARA",  gcACTIVE_CHARA },
    {NULL,            NULL           },
};

CFont *GetDebugFont() {
    return &Font;
}

int GetCaptureMode() {
    return CaptureMode;
}

int GetSystemSndID() {
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
            case PAD_BTN_CONFIRM:
            case PAD_BTN_CONFIRM_2:
            case PAD_BTN_EVENT_SKIP_2:
            case PAD_BTN_ACTION_CONFIRM:
            case PAD_BTN_ACTION_HELD:
            case PAD_BTN_EDIT_PLACE:
            case PAD_BTN_EDIT_REMOVE:
            case PAD_BTN_EDIT_PAINT:
            case PAD_BTN_FISH_ACTION:
            case PAD_BTN_FISH_REEL:
                pad_table[i].button = confirm[language_index];
                break;
            case PAD_BTN_CANCEL:
            case PAD_BTN_CANCEL_2:
            case PAD_BTN_ACTION_CANCEL:
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

void PlayTimeCount(int enable) {
    PlayTimeCountFlag = enable;
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
    /**
     *
     * Microprogram addresses loaded when the main game loop starts.
     *
     */
    static u_long128 *vu_prog[16];

    mgCMemory        *memory;
    mgCMemory        *read_memory;
    CUserDataManager *user_data;
    u_long128        *file_buffer;
    int               file_size;
    int               mode_finished;
    sptr              buffer_address;
    int               alignment;

    memory = GetMainStack();
    memory->stSetBuffer(main_buffer, MAIN_BUFFER_QUADWORDS);
    memory->stack_used = 0;
    memory->lock = 0;
    SaveData.Initialize();
    ActiveSaveData = &SaveData;
    SubGameSaveData = NULL;
    DebugFlag = false;
    GamePad__2.Init();
    InitFileCache(NULL, 0);
    mgInit(MG_SCREEN_MODE_512X480, 3);
    PlayTimeCountFlag = false;
    mgInitVSyncCallBack((int (*)(int)) VSyncCallBack);
    LanguageCode = LANG_FRENCH;
    SCElogoFade(0, memory);
    LoopNo = LOOP_TITLE;
    DebugFlag = false;
    DebugInfo.chara_move = 0;
    /**
     *
     * Whether the debug performance meter is displayed.
     *
     */
    static int pmeter_flag = false;

    pmeter_flag = false;
    GamePad__2.WaitEnable();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    MasterDebugCode = 0;
    DebugFlag = false;

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
    buffer_address = (sptr) (read_memory->stack + read_memory->stack_used);
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
            memory->stSetBuffer(&main_buffer[5000], MAIN_BUFFER_QUADWORDS - 5000);
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
        CaptureScreen = false;
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
            frame_border.DepthTestEnable(false);
            frame_border.AlphaTestEnable(false);
            frame_border.AlphaBlendEnable(false);
            frame_border.TextureMapEnable(false);
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
                     *
                     * Whether the debug frame-advance pause is enabled.
                     *
                     */
                    static int pause = false;

                    if (GamePad__2.Down2(PAD_SELECT)) {
                        pause = true;
                    }

                    while (pause != 0) {
                        sceGsSyncV(0);
                        GamePad__2.UpDate();

                        if (GamePad__2.Down(PAD_START) || GamePad__2.Down2(PAD_SELECT)) {
                            pause = false;
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
 *
 * Prepares rendering and resource buffers for the main debug menu.
 *
 */
void MenuInit(INIT_LOOP_ARG arg) {
    mgCMemory *main_stack;
    u_long128 *packet_a;
    u_long128 *packet_b;

    sndSeAllStop(-1);
    sndDeletePort(SND_PORT_BGM);
    MainScene.InitBGM();
    MainScene.InitSeEnv();
    MainScene.InitSeSrc();
    menu_mode = DEBUG_MENU_TOP;
    mgInitFont();
    main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;

    /**
     *
     * Packet buffer for the first debug-menu draw buffer.
     *
     */
    static mgCMemory buf0;

    /**
     *
     * Packet buffer for the second debug-menu draw buffer.
     *
     */
    static mgCMemory buf1;

    /**
     *
     * Data buffer for the first debug-menu draw buffer.
     *
     */
    static mgCMemory dbuf0;

    /**
     *
     * Data buffer for the second debug-menu draw buffer.
     *
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
    GamePad__2.SetAutoRepeat(PAD_UP | PAD_RIGHT | PAD_DOWN | PAD_LEFT, 0xF, 4);
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
    /**
     *
     * Rows displayed by the main debug menu.
     *
     */
    static char *menu[] = {
        "game start ", "map        ", "dungeon    ", "title      ",
        "chrview    ", "texview    ", "mapview    ", "sound view ",
        "movie view ", "Language   ", "Item       ", "Save Data  ",
        "Load cfg   ", "Convert Save Data ", ""};

    mgCTextureManager *textures = &mgTexManager;
    int                map_result;

    textures->ReloadTexture(1, (sceVif1Packet *) NULL);

    if (DebugFlag == 0) {
        menu_mode = DEBUG_MENU_EVENT_SELECT;
    }

    if (menu_mode == DEBUG_MENU_MAP_SELECT) {
        map_result = MapSelectLoop();

        if (map_result == MAP_SELECT_DECIDE) {
            INIT_LOOP_ARG arg;

            arg.map_no = -1;
            arg.event_no = DefStartEventNo;
            NextLoop(LOOP_EDIT, arg);
            return true;
        }

        if (map_result == MAP_SELECT_CANCEL) {
            menu_mode = DEBUG_MENU_TOP;
            return false;
        }

        return false;
    }

    if (menu_mode == DEBUG_MENU_EVENT_SELECT) {
        textures->ReloadTexture(1, (sceVif1Packet *) NULL);
        return EventSelect() != 0;
    }

    if (menu_mode == DEBUG_MENU_SAVE_DATA_EDIT) {
        if (SaveDataEditLoop()) {
            menu_mode = DEBUG_MENU_TOP;
        }

        return false;
    }

    char *language[] = {
        "Japanese", "English", "French", "German",
        "Italian", "Spanish", "Chinese", "Korean"};
    char      *item_set[] = {"Presentation", "GameStart", "StartDebug", "WeaponOnly"};
    int        item_set_no[] = {0, 1, 2, 6};
    char       text[2048];
    char       config_name[64];
    int        row = 0;
    static int select = 0;
    char      *cursor[] = {" ", ">"};
    int       *menu_arguments = SelectArg;
    char      *text_end;

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

    if (select == LOOP_EDIT) {
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
            return false;
        } else if (select == DEBUG_ROW_LANGUAGE) {
            LanguageChange(menu_arguments[select], read_buffer);
            return false;
        } else if (select == DEBUG_ROW_ITEM_SET) {
            CUserDataManager *user = &GetSaveData()->user_data;
            DebugGetItem(user, item_set_no[menu_arguments[select]]);
            return false;
        } else if (select == DEBUG_ROW_SAVE_DATA) {
            InitSaveDataEdit(&MenuBuffer);
            menu_mode = DEBUG_MENU_SAVE_DATA_EDIT;
            return false;
        } else if (select == DEBUG_ROW_LOAD_CFG) {
            sprintf(config_name, "dbg/game%d.cfg", menu_arguments[select]);
            InitSaveData();
            LoadGameConfig(config_name);
            return false;
        } else {
            if (menu_arguments[select] < 0 && select == LOOP_EDIT) {
                InitMapSelect(&MenuBuffer);
                menu_mode = DEBUG_MENU_MAP_SELECT;
                return false;
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

            return true;
        }
    }

    return false;
}

/**
 *
 * Releases debug-menu input repeat and font state.
 *
 */
void MenuExit() {
    GamePad__2.AutoRepeatOff();
    mgCloseFont();
}

/**
 *
 * Opens the debug event selection screen with none of its sub-screens open.
 *
 */
void InitEventSelect() {
    event_view = false;
    future_sel = false;
    menu_mode = DEBUG_MENU_EVENT_SELECT;
    hdd_sel = false;
}

/**
 *
 * Runs the debug chapter, event, map and extra-mode selection screen.
 *
 */
static int EventSelect() {
    /**
     *
     * Persistent row values selected by the chapter and event debug menu.
     *
     */
    static int menu_sel[DEBUG_EVENT_ROW_NUM] = {0};

    /**
     *
     * Rows displayed by the chapter and event debug menu.
     *
     */
    static char *menu[DEBUG_EVENT_ROW_NUM + 1] = {
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
        ""};

    int result;

    if (event_view != 0) {
        result = EventViewLoop();

        if (result == EVENT_VIEW_CONTINUE) {
            return false;
        } else if (result == EVENT_VIEW_START) {
            return true;
        } else if (result == EVENT_VIEW_CANCEL) {
            event_view = false;
        }

        return false;
    }

    if (future_sel != 0) {
        result = FutureMapSelect();

        if (result == FUTURE_MAP_SELECT_CONTINUE) {
            return false;
        } else if (result == FUTURE_MAP_SELECT_CHOSEN) {
            return true;
        } else if (result == FUTURE_MAP_SELECT_CLOSED) {
            future_sel = false;
        }

        return false;
    }

    if (hdd_sel != 0) {
        result = HDDMenuLoop();

        if (result == 0) {
            return false;
        } else if (result > 0) {
            return true;
        } else {
            return false;
        }
    }

    char       display[1024];
    char      *subgame_name[DEBUG_SUB_GAME_NUM] = {"Spheda", "GyoRace", "Fishing"};
    int        row = 0;
    char      *map_name;
    static int select = 0;
    int        loop_no;
    int        monica;
    char      *text = display;
    char      *cursor[2] = {"  ", ">>"};

    if (GamePad__2.Down(PAD_DOWN)) {
        select++;
    }

    if (GamePad__2.Down(PAD_UP)) {
        select--;
    }

    if (select < 0) {
        select = DEBUG_EVENT_ROW_EXTRA;
    }

    if (select >= DEBUG_EVENT_ROW_NUM) {
        select = 0;
    }

    if (GamePad__2.Down(PAD_RIGHT)) {
        menu_sel[select]++;
    }

    if (GamePad__2.Down(PAD_LEFT)) {
        menu_sel[select]--;
    }

    switch (select) {
        case DEBUG_EVENT_ROW_CHAPTER:
        case DEBUG_EVENT_ROW_CHAPTER_DEBUG:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }

            if (menu_sel[select] > 6) {
                menu_sel[select] = 6;
            }

            break;
        case DEBUG_EVENT_ROW_SUB_GAME:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }

            if (menu_sel[select] > DEBUG_SUB_GAME_FISHING) {
                menu_sel[select] = DEBUG_SUB_GAME_FISHING;
            }

            break;
        case DEBUG_EVENT_ROW_DIORAMA_MAP:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }

            if (menu_sel[select] > 4) {
                menu_sel[select] = 4;
            }

            break;
        case DEBUG_EVENT_ROW_EXTRA:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }

            if (menu_sel[select] > 1) {
                menu_sel[select] = 1;
            }

            break;
    }

    text += sprintf(text, "\n\x83\x5F\x81\x5B\x83\x4E\x83\x4E\x83\x8D\x83\x6A\x83\x4E\x83\x8B\x83\x56\x83\x58\x83\x65\x83\x80\x92\xB2\x90\xAE"
                          "ROM %s %s\n",
                    "2003/07/29", "Ver0.334");

    for (; menu[row][0] != '\0'; row++) {
        text += sprintf(text, "%s%s", cursor[row == select], menu[row]);

        switch (row) {
            case DEBUG_EVENT_ROW_CHAPTER:
            case DEBUG_EVENT_ROW_CHAPTER_DEBUG:
                text += sprintf(text, "%d\x8F\xCD", menu_sel[row] + 1);
                break;
            case DEBUG_EVENT_ROW_SUB_GAME:
            case DEBUG_EVENT_ROW_EXTRA:
                text += sprintf(text, "%s", subgame_name[menu_sel[row]]);
                break;
            case DEBUG_EVENT_ROW_DIORAMA_MAP:
                if (GetMapName(menu_sel[row], &map_name)) {
                    text += sprintf(text, "%s", map_name);
                }

                break;
        }

        text += sprintf(text, "\n");
    }

    text += sprintf(text, "\n");

    switch (select) {
        case DEBUG_EVENT_ROW_CHAPTER_DEBUG:
        case DEBUG_EVENT_ROW_CHAPTER:
            sprintf(text, "\x95\xFB\x8C\xFC\x83\x4C\x81\x5B\x8D\xB6\x89\x45\x82\xC5\x8F\xCD\x91\x49\x91\xF0\n");
            break;
        case DEBUG_EVENT_ROW_SUB_GAME:
            sprintf(text, "\x95\xFB\x8C\xFC\x83\x4C\x81\x5B\x8D\xB6\x89\x45\x82\xC5\x83\x54\x83\x75\x83\x51\x81\x5B\x83\x80\x82\xCC\x8E\xED\x97\xDE\x91\x49\x91\xF0\n");
            break;
    }

    Font.DrawDirect(display, 10, 10);

    if (GamePad__2.Down(PAD_CROSS)) {
        menu_mode = DEBUG_MENU_TOP;
        return false;
    }

    if (GamePad__2.Down(PAD_CIRCLE)) {
        INIT_LOOP_ARG arg;
        char          config_name[64] = "";
        char          config_path[64];

        loop_no = LOOP_EDIT;
        monica = false;

        switch (select) {
            case DEBUG_EVENT_ROW_BEGINNING:
                arg.map_no = 0;
                loop_no = LOOP_TITLE;
                config_name[0] = '\0';
                break;
            case DEBUG_EVENT_ROW_CHAPTER:
            case DEBUG_EVENT_ROW_CHAPTER_DEBUG: {
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
                    monica = true;
                }

                if (select == DEBUG_EVENT_ROW_CHAPTER) {
                    sprintf(config_name, "cap%d.cfg", menu_sel[select] + 1);
                } else {
                    sprintf(config_name, "db_cap%d.cfg", menu_sel[select] + 1);
                }

                break;
            }
            case DEBUG_EVENT_ROW_SUB_GAME: {
                int subgame = menu_sel[select];

                switch (subgame) {
                    case DEBUG_SUB_GAME_SPHEDA:
                        arg.floor_no = 1;
                        arg.event_no = 4000;
                        arg.map_no = 2;
                        loop_no = LOOP_DUNGEON;
                        break;
                    case DEBUG_SUB_GAME_GYORACE:
                        arg.map_no = 95;
                        break;
                    case DEBUG_SUB_GAME_FISHING:
                        arg.map_no = 65;
                        break;
                }

                sprintf(config_name, "sg%d.cfg", subgame);
                break;
            }
            case DEBUG_EVENT_ROW_PALM_BRINKS:
                sprintf(config_name, "pb.cfg");
                arg.map_no = 10;
                break;
            case DEBUG_EVENT_ROW_BOSS_BATTLE:
                BossBattleSelFlag = true;
            case DEBUG_EVENT_ROW_EVENT:
                event_view = true;
                return false;
            case DEBUG_EVENT_ROW_FUTURE_MAP:
                future_sel = true;
                return false;
            case DEBUG_EVENT_ROW_DIORAMA_MAP:
                arg.map_no = menu_sel[select];
                sprintf(config_name, "geo.cfg");
                break;
            case DEBUG_EVENT_ROW_HDD:
                hdd_sel = true;
                InitHDDMenu(MenuBuffer.stack + MenuBuffer.stack_used);
                return false;
            case DEBUG_EVENT_ROW_EXTRA:
                InitSaveData();
                InitOmakeEnv(menu_sel[select], &arg, &loop_no);
                NextLoop(loop_no, arg);
                return true;
        }

        sprintf(config_path, "dbg/%s", config_name);
        InitSaveData();
        LoadGameConfig(config_path);

        if (monica != 0) {
            GetSaveData()->user_data.JoinPartyMember(USER_CHARA_MONICA);
            GetSaveData()->user_data.EnableCharaChange(USER_CHARA_MONICA);
        }

        NextLoop(loop_no, arg);
        return true;
    }

    return false;
}

mgCTexture *GetFontTexture(int page) {
    if (page < 0 || page > 0) {
        return NULL;
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
    FontTex[0] = NULL;
    misalign = (uptr) buffer & 3;
    FontDataAdr[0] = NULL;

    if (misalign != 0) {
        buffer += (4 - misalign) * 0x10;
    }

    page = 0;

    do {
        if (LanguageCode == LANG_JAPANESE) {
            sprintf(file_name, "FontTex_%d.tm2", page);
        } else if (LanguageCode == LANG_ENGLISH) {
            if (page == 0) {
                sprintf(file_name, "FontTex_1_0.tm2", page);
            }
        } else if (page == 0) {
            sprintf(file_name, "FontTex_2_0.tm2");
        }

        sprintf(path, "meswin/%s", file_name);

        if (LoadFile2(path, buffer, &size, 0) != 0) {
            FontDataAdr[page] = (TM2_head *) font_buff;

            if (FontDataAdr[page] == NULL) {
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
            if (LanguageCode == LANG_JAPANESE) {
                sprintf(file_name, "FontTex_%d.tm2", page);
            } else if (LanguageCode == LANG_ENGLISH) {
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

void InitPauseMenu(int texture_block) {
    PauseMes.Init();
    PauseMes.Preset(MES_PRESET_SMALL_FUKIDASHI);
    PauseMes.texture_block = texture_block;
    PauseMes.SetWindowMode(MES_WIN_YESNO);
    BlackFade = 0.0f;
    PauseSel = PAUSE_CHOICE_CONTINUE;
    BlackFade2 = 0.0f;
    PauseMenuMode = PAUSE_MENU_OPEN;
    exit_start = false;
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

            if (PadCtrl.Btn(PAD_BTN_RIGHT)) {
                PauseSel = PAUSE_CHOICE_CONTINUE;
            }

            if (PadCtrl.Btn(PAD_BTN_LEFT)) {
                PauseSel = PAUSE_CHOICE_QUIT;
            }

            if (PadCtrl.Analog(PAD_ANALOG_LEFT_X) > 0.8f) {
                PauseSel = PAUSE_CHOICE_CONTINUE;
            }

            if (PadCtrl.Analog(PAD_ANALOG_LEFT_X) < -0.8f) {
                PauseSel = PAUSE_CHOICE_QUIT;
            }

            int selected; selected = PauseSel;

            if (PauseMes.select < 0) {
                PauseMes.cursor_time = 0;
            }

            PauseMes.select = selected;

            if (previous_select != PauseSel) {
                sndSePlay(GetSystemSndID(), SYSTEM_SE_CURSOR, 0);
            }

            if (PadCtrl.Btn(PAD_BTN_CONFIRM)) {
                if (PauseSel == PAUSE_CHOICE_QUIT) {
                    BlackFade = 0.0f;
                    PauseMenuMode = PAUSE_MENU_FADE_OUT;
                    sndSePlay(GetSystemSndID(), SYSTEM_SE_DECIDE, 0);
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
    prim.DepthTestEnable(false);
    prim.AlphaBlendEnable(true);
    prim.ZMask(MG_Z_MASK_WRITE);
    prim.TextureMapEnable(false);
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

/**
 *
 * Sets the map the debug menu starts the editor in, by name or number.
 *
 */
int gcMAP_NO(SPI_STACK *stack, int arg_count) {
    int map_no;

    if (stack->type == SPI_STACK_TYPE_STRING) {
        map_no = SearchMapNo(spiGetStackString(stack));
    } else {
        map_no = spiGetStackInt(stack);
    }

    SelectArg[LOOP_EDIT] = map_no;
    return 1;
}

/**
 *
 * Sets the story progress of the save data.
 *
 */
int gcPROGRESS(SPI_STACK *stack, int arg_count) {
    int        value = spiGetStackInt(stack);
    CSaveData *save = GetSaveData();
    save->game_progress = value;
    return 0;
}

/**
 *
 * Sets each listed bit flag of the save data.
 *
 */
int gcBIT_FLAG_ON(SPI_STACK *stack, int arg_count) {
    CSaveData *save_data;
    int        i;

    for (i = 0; i < arg_count; i++) {
        save_data = GetSaveData();
        save_data->SetBitFlag(spiGetStackInt(stack++), true);
    }

    return 0;
}

/**
 *
 * Clears each listed bit flag of the save data.
 *
 */
int gcBIT_FLAG_OFF(SPI_STACK *stack, int arg_count) {
    CSaveData *save_data;
    int        i;

    for (i = 0; i < arg_count; i++) {
        save_data = GetSaveData();
        save_data->SetBitFlag(spiGetStackInt(stack++), false);
    }

    return 0;
}

/**
 *
 * Sets the event the debug menu starts maps with.
 *
 */
int gcSTART_EVENT(SPI_STACK *stack, int arg_count) {
    DefStartEventNo = spiGetStackInt(stack);
    return 0;
}

/**
 *
 * Lifts the georama conditions and opens every condition of each listed town.
 *
 */
int gcGEO_COMPLETE(SPI_STACK *stack, int arg_count) {
    int        i;
    int        index;
    CEditData *edit_data;

    DebugInfo.georama_debug = true;

    for (i = 0; i < arg_count; i++) {
        index = spiGetStackInt(stack++);
        edit_data = GetSaveData()->GetEditData(index);

        if (edit_data != NULL) {
            edit_data->dbgSetAllContintionFlag(index, 1);
        }
    }

    return 1;
}

/**
 *
 * Lifts the georama placement conditions.
 *
 */
int gcGEO_DEBUG(SPI_STACK *stack, int arg_count) {
    DebugInfo.georama_debug = true;
    return 1;
}

/**
 *
 * Gives the player one of the debug item sets.
 *
 */
int gcITEM_SET(SPI_STACK *stack, int arg_count) {
    CUserDataManager *user_data;

    user_data = &GetSaveData()->user_data;
    DebugGetItem(user_data, spiGetStackInt(stack));
    return 1;
}

/**
 *
 * Gives the player one of each listed item.
 *
 */
int gcGET_ITEM(SPI_STACK *stack, int arg_count) {
    int               i;
    CUserDataManager *user_data;

    for (i = 0; i < arg_count; i++) {
        user_data = &GetSaveData()->user_data;
        user_data->GetItem(spiGetStackInt(stack++), 1);
    }

    return 1;
}

/**
 *
 * Gives the player each listed item in the listed quantity.
 *
 */
int gcGET_N_ITEM(SPI_STACK *stack, int arg_count) {
    int               item_no;
    int               i;
    CUserDataManager *user_data;

    for (i = 0; i < arg_count; i++) {
        user_data = &GetSaveData()->user_data;
        item_no = spiGetStackInt(stack++);
        user_data->GetItem(item_no, spiGetStackInt(stack++));
    }

    return 1;
}

/**
 *
 * Equips an item on a character.
 *
 */
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

/**
 *
 * Sets a character's defence.
 *
 */
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

/**
 *
 * Sets a character's maximum and current hit points.
 *
 */
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
static int gcALL_GEO_PARTS(SPI_STACK *stack, int arg_count) {
    CSaveDataDungeon *dungeon;
    DNG_FLOOR_SAVE   *floor;
    CEditData        *edit;
    int               mode;
    int               stage;
    int               floor_no;
    int               town;
    int               i;

    mode = 0;

    if (arg_count > 0) {
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
                edit->analyze.data_open[i] = true;
            }

            for (i = 0; i < EDIT_ANALYZE_CONDITION_MAX; i++) {
                edit->analyze.condition_open[i] = true;
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

/**
 *
 * Shows or hides the parameter display.
 *
 */
int gcPARAM_DRAW(SPI_STACK *stack, int arg_count) {
    DebugInfo.param_off = !spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets one of the named game options.
 *
 */
int gcOPTION(SPI_STACK *stack, int arg_count) {
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

/**
 *
 * Adds Monica to the party.
 *
 */
int gcMONICA(SPI_STACK *stack, int arg_count) {
    CUserDataManager *manager;

    manager = GetUserDataMan();

    if (manager != NULL) {
        manager->JoinPartyMember(USER_CHARA_MONICA);
    }

    return 1;
}

/**
 *
 * Adds the ridepod to the party and gives its core, optionally swapping in the core of another ridepod.
 *
 */
int gcSTEVE(SPI_STACK *stack, int arg_count) {
    CUserDataManager *manager;

    manager = GetUserDataMan();

    if (manager == NULL) {
        return 0;
    }

    manager->JoinPartyMember(USER_CHARA_ROBO);
    manager->GetItemNotOver(ITEM_ID_CORE, 1);

    if (arg_count == 2) {
        manager->DeleteItem(ITEM_ID_CORE, 1);
        manager->GetItemNotOver(GetRidePodCore(spiGetStackInt(stack)), 1);
    }

    return 1;
}

/**
 *
 * Adds monster transformation to the party and enables each listed monster badge.
 *
 */
int gcMONSTER(SPI_STACK *stack, int arg_count) {
    int               class_level;
    CUserDataManager *manager;
    int               i;
    int               monster_id;
    int               badge_no;
    MOS_CHANGE_PARAM *badge;

    manager = GetUserDataMan();

    if (manager == NULL) {
        return 0;
    }

    manager->JoinPartyMember(USER_CHARA_MONSTER);
    manager->GetItemNotOver(ITEM_ID_BADGE_BOX, 1);

    for (i = 0; i < arg_count; i++) {
        monster_id = spiGetStackInt(stack++);
        badge_no = get_gajji_id_from_monster_progress_table(monster_id, &class_level) + 1;
        manager->monster_box.EnableChange(badge_no);
        badge = manager->monster_box.GetMonsterBajjiData(badge_no);

        if (badge != NULL) {
            badge->class_level = class_level;
            badge->monster_id = monster_id;
            badge->progress = GetMonsterProgressTableNo(class_level, monster_id);
        }

        manager->monster_id = monster_id;
    }

    return 1;
}

/**
 *
 * Adds a townsperson (party character) to the party.
 *
 */
int gcPARTY(SPI_STACK *stack, int arg_count) {
    int               chara_no;
    CUserDataManager *manager;

    chara_no = spiGetStackInt(stack);

    if (chara_no <= 0 || chara_no > 0x1A) {
        return 0;
    }

    manager = GetUserDataMan();

    if (manager != NULL) {
        manager->JoinPartyChara(chara_no, PARTY_CHARA_STATUS_JOIN, 1);
        manager->SetPartyCharaStatus(chara_no, PARTY_CHARA_STATUS_IN_PARTY);
    }

    return 1;
}

/**
 *
 * Selects the active character, Max or Monica.
 *
 */
int gcACTIVE_CHARA(SPI_STACK *stack, int arg_count) {
    int               chara_no;
    CUserDataManager *manager;

    chara_no = spiGetStackInt(stack);

    if (chara_no < USER_CHARA_MAX) {
        chara_no = USER_CHARA_MAX;
    }

    if (chara_no > USER_CHARA_MONICA) {
        chara_no = USER_CHARA_MONICA;
    }

    manager = GetUserDataMan();

    if (manager != NULL) {
        manager->SetActiveChrNo(chara_no);
    }

    return 1;
}

CUserDataManager::CUserDataManager() {}

CEditData::CEditData() {
    Initialize();
}

int MainThreadPriority = 1;

u_long128 *read_buffer;
u32        SystemSND_ID;
int        DebugFlag;
int        DefStartEventNo;
int        LanguageCode;
int        OmakeFlag;
int        MasterDebugCode;
CSound     CSnd;

CGamePad    GamePad__2;
CPadControl PadCtrl;
DEBUG_INFO  DebugInfo;
/**
 * Font used by debug screens.
 */
CFont Font;
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
CScene MainScene;
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
