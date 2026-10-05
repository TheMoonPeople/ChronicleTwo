#include "common.h"
#include "savedata.hpp"
#include "subgame.hpp"
#include "scenesnd.hpp"
#include "gamedata.hpp"
#include "editdata.hpp"
#include "gamepad.hpp"
#include "mapselect.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "npccfg.hpp"
#include "scriptinterpreter.hpp"
#include "visualmotion.hpp"
#include "vlgr_info.hpp"
#include "water.hpp"
#include "dataread.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "helpmes.hpp"
#include "nowload.hpp"
#include "snd_mngr.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#include "mainloop.hpp"
#include <cstring>
#include <cstdio>

#include <cstdlib>
#include <libgraph.h>
#include "inventmn.hpp"
#include "main.hpp"
#include "mainloop3.hpp"
#include "menuchr.hpp"
#include "mg_drawprim.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "scene.hpp"
#include "title.hpp"

#ifdef NONMATCHING
extern INIT_LOOP_ARG NextInitArg;
extern INIT_LOOP_ARG PrevInitArg;
extern int NextLoopNo;
extern int PrevLoopNo;
extern int CaptureScreen;
extern int PauseSel;
extern int PauseMenuMode;
extern int exit_start;
extern float BlackFade;
extern float BlackFade2;
extern CSaveData SaveData;
extern ClsMes PauseMes;
extern mgCMemory SystemSeStack;
extern u_long128 main_buffer[0x1A0000];
extern u_long128 SystemSeBuff[400];
extern u_long128 InfoBuff[5000];
static int MenuLoop();
static int EventSelect();
static int gcALL_GEO_PARTS(SPI_STACK *stack, int argc);
extern void (*LoopInit[])(INIT_LOOP_ARG);
extern int (*LoopMain[])();
extern void (*LoopExit[])();
static PAD_TABLE_ENTRY pad_table[] = {
    { 0, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 1, PAD_CTRL_TRIGGER_DOWN, PAD_CROSS },
    { 2, PAD_CTRL_TRIGGER_ON, PAD_R1 },
    { 3, PAD_CTRL_TRIGGER_ON, PAD_L1 },
    { 4, PAD_CTRL_TRIGGER_DOWN, PAD_L2 },
    { 5, PAD_CTRL_TRIGGER_DOWN, PAD_TRIANGLE },
    { 6, PAD_CTRL_TRIGGER_DOWN, PAD_R2 },
    { 7, PAD_CTRL_TRIGGER_DOWN, PAD_UP },
    { 8, PAD_CTRL_TRIGGER_DOWN, PAD_DOWN },
    { 9, PAD_CTRL_TRIGGER_DOWN, PAD_RIGHT },
    { 10, PAD_CTRL_TRIGGER_DOWN, PAD_LEFT },
    { 11, PAD_CTRL_TRIGGER_ON, PAD_UP },
    { 12, PAD_CTRL_TRIGGER_ON, PAD_DOWN },
    { 13, PAD_CTRL_TRIGGER_ON, PAD_RIGHT },
    { 14, PAD_CTRL_TRIGGER_ON, PAD_LEFT },
    { 15, PAD_CTRL_TRIGGER_DOWN, PAD_START },
    { 16, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 17, PAD_CTRL_TRIGGER_DOWN, PAD_CROSS },
    { 19, PAD_CTRL_TRIGGER_ON, PAD_CIRCLE },
    { 20, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 21, PAD_CTRL_TRIGGER_DOWN, PAD_START },
    { 22, PAD_CTRL_TRIGGER_DOWN, PAD_TRIANGLE },
    { 23, PAD_CTRL_TRIGGER_DOWN, PAD_L3 },
    { 24, PAD_CTRL_TRIGGER_DOWN, PAD_R3 },
    { 50, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 51, PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE },
    { 52, PAD_CTRL_TRIGGER_DOWN, PAD_CROSS },
    { 53, PAD_CTRL_TRIGGER_ON, PAD_L1 },
    { 54, PAD_CTRL_TRIGGER_ON, PAD_R1 },
    { 55, PAD_CTRL_TRIGGER_DOWN, PAD_SELECT },
    { 56, PAD_CTRL_TRIGGER_ON, PAD_CIRCLE },
    { 100, PAD_CTRL_TRIGGER_DOWN, PAD_R2 },
    { 101, PAD_CTRL_TRIGGER_DOWN, PAD_L2 },
    { 102, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 103, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 104, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 107, PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE },
    { 105, PAD_CTRL_TRIGGER_DOWN, PAD_R2 },
    { 106, PAD_CTRL_TRIGGER_DOWN, PAD_L2 },
    { 18, PAD_CTRL_TRIGGER_DOWN, PAD_R1 },
    { 108, PAD_CTRL_TRIGGER_DOWN, PAD_SELECT },
    { 109, PAD_CTRL_TRIGGER_DOWN, PAD_SQUARE },
    { 120, PAD_CTRL_TRIGGER_DOWN, PAD_CIRCLE },
    { 121, PAD_CTRL_TRIGGER_ON, PAD_CIRCLE },
    { 122, PAD_CTRL_TRIGGER_ON, PAD_SQUARE },
    { -1, -1, -1 },
};

/**
 * Binds the game's logical stick inputs to controller axes.
 */
static ANALOG_TABLE_ENTRY analog_table[] = {
    { 0, PAD_CTRL_AXIS_LX },
    { 1, PAD_CTRL_AXIS_LY },
    { 2, PAD_CTRL_AXIS_RX },
    { 3, PAD_CTRL_AXIS_RY },
    { 4, PAD_CTRL_AXIS_LY },
    { 5, PAD_CTRL_AXIS_LX },
    { 6, PAD_CTRL_AXIS_RX },
    { 7, PAD_CTRL_AXIS_RY },
    { -1, -1 },
};
#endif

void LoadFilePictureName();
extern "C" void LoadEditAnalyzeData__FiP1(...);
int get_gajji_id_from_monster_progress_table(int monster_no, int *level);
int GetMonsterProgressTableNo(int level, int monster_no);

extern CFont Font;
extern mgCMemory MainBuffer;
extern int menu_mode;
void InitEventSelect();

extern INIT_LOOP_ARG SelectArg;

extern CSaveData *ActiveSaveData;
extern int CaptureMode;
extern int LoopNo;
extern int PlayTimeCountFlag;
extern CSubGameData *SubGameSaveData;
extern int event_view;
extern int future_sel;
extern int hdd_sel;
extern CScene MainScene;
extern INIT_LOOP_ARG InitArg;
extern mgCMemory InfoStack;
extern "C" int InitPadTable__Fi(int);

extern mgCMemory MenuBuffer;
extern mgCMemory buf0_1224;
extern mgCMemory buf1_1227;
extern mgCMemory dbuf0_1230;
extern mgCMemory dbuf1_1233;
extern s8 init_1225;
extern s8 init_1228;
extern s8 init_1231;
extern s8 init_1234;
extern mgCTexture *FontTex;
extern u32 FontDataAdr;
extern char at_1654[];
extern char at_1655[];
extern char at_1656[];
extern u8 font_buff[];
extern char at_1657[];
extern char at_1296[];
extern char at_1856[];

extern SPI_TAG_PARAM tag__3[];
extern char at_2082[];
extern char at_2083[];
extern char at_2084[];
extern char at_2085[];

// Code (.text)
CFont *GetDebugFont(void) {
    return &Font;
}
int GetCaptureMode(void) {
    return CaptureMode;
}
s32 GetSystemSndID(void) {
    return SystemSND_ID;
}
CScene *GetMainScene(void) {
    return &MainScene;
}
CSaveData *GetSaveData(void) {
    return ActiveSaveData;
}
CSubGameData *GetSubGameSaveData(void) {
    return SubGameSaveData;
}
void InitSaveData(void) {
    GetSaveData()->Initialize();
}
int GetVramTopAddress(void) {
    return mgGetTopVRAMAddress() + 0x20;
}
mgCMemory *GetMainStack(void) {
    return &MainBuffer;
}
#ifdef NONMATCHING
void NextLoop(int loop_no, INIT_LOOP_ARG arg) {
    NextLoopNo = loop_no;
    NextInitArg = arg;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", NextLoop__Fi13INIT_LOOP_ARG);
#endif
int GetNowLoopNo(void) {
    return LoopNo;
}
INIT_LOOP_ARG *GetNowInitArg(void) {
    return &InitArg;
}
void cat_start() {}
void cat_end() {}
void SetTextureTable(int table_size, int table_count, mgCMemory *memory) {
    mgTexManager.SetTableBuffer(table_count, table_size, memory);
    mgTexManager.Initialize(GetVramTopAddress(), -1);
}
#ifdef NONMATCHING
/**
 * Registers the logical controller bindings for the selected language.
 */
static void InitPadTable(int language) {
    int confirm[2] = { PAD_CIRCLE, PAD_CROSS };
    int cancel[2]  = { PAD_CROSS, PAD_CIRCLE };
    int language_index;
    int i;

    language_index = language != LANG_JAPANESE;
    PadCtrl.Initialize();
    for (i = 0; pad_table[i].no >= 0; i++) {
        switch (pad_table[i].no) {
            case 0x34:
            case 0x11:
            case 1:
                pad_table[i].button = cancel[language_index];
                break;
            case 0x79:
            case 0x78:
            case 0x68:
            case 0x67:
            case 0x66:
            case 0x38:
            case 0x32:
            case 0x14:
            case 0x10:
            case 0:
                pad_table[i].button = confirm[language_index];
                break;
        }
        PadCtrl.RegisterBtn(pad_table[i].no, pad_table[i].button, pad_table[i].trigger);
    }
    for (i = 0; analog_table[i].no >= 0; i++) {
        PadCtrl.RegisterAnalog(analog_table[i].no, analog_table[i].axis);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", InitPadTable__Fi);
#endif
extern "C" void VSyncCallBack__Fi__3(int unused) {
    if (PlayTimeCountFlag != 0) {
        s64 ticks = GetSaveData()->play_time;
        CSaveData *save = GetSaveData();
        save->play_time = ticks + 1;
    }
}
void PlayTimeCount(int value) {
    PlayTimeCountFlag = value;
}
int GetPlayTimeCountFlag(void) {
    return PlayTimeCountFlag;
}
extern "C" void LanguageChange__FiP1(int language) {
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
    LoadEditAnalyzeData__FiP1((u32)LanguageCode, (u_long128 *)read_buffer);
    LoadFilePictureName();
    LoadMonsterLanguage(LanguageCode);
    InfoStack.stack_used = 0;
    InfoStack.lock = 0;
    LoadGameInfo(&InfoStack);
    InitPauseData();
    InitPadTable__Fi(LanguageCode);
}
#ifdef NONMATCHING
void MainLoop() {
    mgCMemory        *memory;
    mgCMemory        *read_memory;
    CUserDataManager *user_data;
    u_long128        *file_buffer;
    int               file_size;
    int               mode_finished;
    int               buffer_address;
    int               alignment;
    static u_long128 *vu_prog[16];

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
    mgInitVSyncCallBack((int (*)(int))VSyncCallBack__Fi__3);
    LanguageCode = LANG_FRENCH;
    SCElogoFade(0, memory);
    LoopNo = LOOP_TITLE;
    DebugFlag = 0;
    DebugInfo.chara_move = 0;
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
    buffer_address = (int)(read_memory->stack + read_memory->stack_used);
    alignment = buffer_address % 64;
    if (alignment != 0) {
        buffer_address += ((64 - alignment) / 16) * 16;
    }
    file_buffer = (u_long128 *)buffer_address;
    SystemSND_ID = -1;
    if (LoadFile2("snd2/SY_000.snd", file_buffer, NULL, 0)) {
        SystemSND_ID = sndLoadSound(SND_PORT_SYSTEM, (u_int *)file_buffer, &SystemSeStack);
    }
    if (LoadFile2("snd2/rev.bin", file_buffer, &file_size, 0)) {
        MainScene.LoadSndRevInfo((char *)file_buffer, file_size);
    }
    if (LoadFile2("snd2/MAP_index.txt", file_buffer, &file_size, 0)) {
        MainScene.LoadSndFileInfo((char *)file_buffer, file_size);
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
            SubGameSaveData = (CSubGameData *)main_buffer;
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
        GetMainScene()->SetTime(GetSaveData()->now_time);
        GetMainScene()->day = GetSaveData()->day;
        if (GetSaveData()->game_progress == 2) {
            GetSaveData()->now_time = 22.0f;
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
        memset(&next_arg, 0, sizeof(next_arg));
        NextLoop(LOOP_MENU, next_arg);

        while (1) {
            if (GamePad__2.On(PAD_CIRCLE)) {
                cat_start();
            }
            if (LoopNo != LOOP_MENU) {
                GetMainScene()->save_data = GetSaveData();
                GetMainScene()->SetTime(GetSaveData()->now_time);
                GetMainScene()->day = GetSaveData()->day;
                if (GetSaveData()->game_progress == 2) {
                    GetSaveData()->now_time = 22.0f;
                    GetMainScene()->SetTime(22.0f);
                    GetMainScene()->time_step = 0;
                }
            }
            GamePad__2.VibrationEnable(GetSaveData()->config.vibration == 0);
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
            frame_border.ZMask(-1);
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
            if (LoopNo == LOOP_TITLE || LoopNo == LOOP_DUNGEON || LoopNo == LOOP_EDIT) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", MainLoop__Fv);
#endif
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
    if (init_1225 == 0) {
        buf0_1224.Init();
        init_1225 = 1;
    }
    if (init_1228 == 0) {
        buf1_1227.Init();
        init_1228 = 1;
    }
    if (init_1231 == 0) {
        dbuf0_1230.Init();
        init_1231 = 1;
    }
    if (init_1234 == 0) {
        dbuf1_1233.Init();
        init_1234 = 1;
    }
    packet_a = main_stack->stAlloc64(0x2710);
    packet_b = main_stack->stAlloc64(0x2710);
    mgInitVif1Packet(packet_a, packet_b, 0x27100);
    buf0_1224.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x2710), 0x2710);
    buf1_1227.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x2710), 0x2710);
    dbuf0_1230.stSetBuffer((u_long128 *)main_stack->stAlloc64(0xC350), 0xC350);
    dbuf1_1233.stSetBuffer((u_long128 *)main_stack->stAlloc64(0xC350), 0xC350);
    MenuBuffer.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x7A120), 0x7A120);
    read_buffer = (u_long128 *)main_stack->stAlloc64(0x186A0);
    mgSetPacketBuffer(&buf0_1224, &buf1_1227);
    mgSetDataBuffer(&dbuf0_1230, &dbuf1_1233, 1);
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
#ifdef NONMATCHING
/**
 * Runs the debug mode selection menu and its configuration screens.
 */
static int MenuLoop() {
    int *menu_arguments = (int *)&SelectArg;
    static char *menu[] = {
        "game start ", "map        ", "dungeon    ", "title      ",
        "chrview    ", "texview    ", "mapview    ", "sound view ",
        "movie view ", "Language   ", "Item       ", "Save Data  ",
        "Load cfg   ", "Convert Save Data ", "", NULL
    };
    char *language[] = {
        "Japanese", "English", "French", "German",
        "Italian", "Spanish", "Chinese", "Korean"
    };
    char *item_set[] = {"Presentation", "GameStart", "StartDebug", "WeaponOnly"};
    int   item_set_no[] = {0, 1, 2, 6};
    char *cursor[] = {" ", ">"};
    char  text[2048];
    char  config_name[64];
    char *text_end;
    int   row;
    int   map_result;

    mgTexManager.ReloadTexture(1, (sceVif1Packet *)NULL);
    if (DebugFlag == 0) {
        menu_mode = DEBUG_MENU_EVENT_SELECT;
    }
    switch (menu_mode) {
        case DEBUG_MENU_MAP_SELECT:
            map_result = MapSelectLoop();
            if (map_result == 2) {
                INIT_LOOP_ARG arg;
                memset(&arg, 0, sizeof(arg));
                arg.map_no = -1;
                arg.event_no = DefStartEventNo;
                NextLoop(LOOP_EDIT, arg);
                return 1;
            }
            if (map_result == 1) {
                menu_mode = DEBUG_MENU_TOP;
            }
            return 0;
        case DEBUG_MENU_EVENT_SELECT:
            mgTexManager.ReloadTexture(1, (sceVif1Packet *)NULL);
            return EventSelect() != 0;
        case DEBUG_MENU_SAVE_DATA_EDIT:
            if (SaveDataEditLoop()) {
                menu_mode = DEBUG_MENU_TOP;
            }
            return 0;
    }
    static int select = 0;

    if (GamePad__2.Down(PAD_DOWN)) {
        select++;
    }
    if (GamePad__2.Down(PAD_UP)) {
        select--;
    }
    if (select < 0) {
        select = 13;
    }
    if (select >= 14) {
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
    if (GamePad__2.Down(PAD_R2)) {
        menu_arguments[select] += 100;
    }
    if (GamePad__2.Down(PAD_L2)) {
        menu_arguments[select] -= 100;
    }
    if (menu_arguments[select] < -1) {
        menu_arguments[select] = -1;
    }
    if (select == 9) {
        if (menu_arguments[select] >= 6) {
            menu_arguments[select] = 5;
        }
        if (menu_arguments[select] < 0) {
            menu_arguments[select] = 0;
        }
    }
    text_end = text + sprintf(text, "\nDark Chronicle %s\n", "Ver0.334");
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
    if (CaptureMode >= CAPTURE_MODE_NUM) {
        CaptureMode = CAPTURE_OFF;
    }
    for (row = 0; row < 14 && menu[row][0] != '\0'; row++) {
        if (row == 10) {
            text_end += sprintf(text_end, "%s%s%s\n", cursor[row == select], menu[row], item_set[menu_arguments[row]]);
        } else if (row == 9) {
            text_end += sprintf(text_end, "%s%s%s (now %s)\n", cursor[row == select], menu[row], language[menu_arguments[row]], language[LanguageCode]);
        } else if (row <= 0) {
            text_end += sprintf(text_end, "%s%s\n", cursor[row == select], menu[row]);
        } else {
            text_end += sprintf(text_end, "%s%s%d\n", cursor[row == select], menu[row], menu_arguments[row]);
        }
    }
    Font.DrawDirect(text, 10, 10);
    if (!GamePad__2.Down(PAD_CIRCLE)) {
        return 0;
    }
    switch (select) {
        case 0:
            InitEventSelect();
            return 0;
        case 9:
            LanguageChange(menu_arguments[select], read_buffer);
            return 0;
        case 10:
            DebugGetItem(&GetSaveData()->user_data, item_set_no[menu_arguments[select]]);
            return 0;
        case 11:
            InitSaveDataEdit(&MenuBuffer);
            menu_mode = DEBUG_MENU_SAVE_DATA_EDIT;
            return 0;
        case 12:
            sprintf(config_name, "dbg/game%d.cfg", menu_arguments[select]);
            InitSaveData();
            LoadGameConfig(config_name);
            return 0;
        default:
            if (menu_arguments[select] < 0 && select == 1) {
                InitMapSelect(&MenuBuffer);
                menu_mode = DEBUG_MENU_MAP_SELECT;
                return 0;
            }
            if (select == 13) {
                INIT_LOOP_ARG arg;
                memset(&arg, 0, sizeof(arg));

                NextLoop(LOOP_SV_CONV_VIEW, arg);
            } else {
                INIT_LOOP_ARG arg;
                memset(&arg, 0, sizeof(arg));

                arg.map_no = menu_arguments[select];
                arg.event_no = DefStartEventNo;
                NextLoop(select, arg);
            }
            return 1;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", MenuLoop__Fv);
#endif
void MenuExit(void) {
    GamePad__2.AutoRepeatOff();
    mgCloseFont();
}
void InitEventSelect(void) {
    event_view = 0;
    future_sel = 0;
    menu_mode = 2;
    hdd_sel = 0;
}
#ifdef NONMATCHING
/**
 * Runs the debug chapter, event, map and extra-mode selection screen.
 */
static int EventSelect() {
    static int   menu_sel[11];
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
    static int    select = 0;
    char         *subgame_name[3] = { "Spheda", "GyoRace", "Fishing" };
    char         *cursor[2] = { "  ", ">>" };
    char         *map_name;
    char         *text;
    char          display[1024];

    char          config_path[64];
    int           result;
    int           row;
    int           chapter;
    int           subgame;
    int           loop_no;
    int           monica;

    if (event_view != 0) {
        result = EventViewLoop();
        switch (result) {
            case EVENT_VIEW_CONTINUE:
                return 0;
            case EVENT_VIEW_START:
                return 1;
            case EVENT_VIEW_CANCEL:
                event_view = 0;
                break;
        }
        return 0;
    }
    if (future_sel != 0) {
        result = FutureMapSelect();
        switch (result) {
            case FUTURE_MAP_SELECT_CONTINUE:
                return 0;
            case FUTURE_MAP_SELECT_CHOSEN:
                return 1;
            case FUTURE_MAP_SELECT_CLOSED:
                future_sel = 0;
                break;
        }
        return 0;
    }
    if (hdd_sel != 0) {
        result = HDDMenuLoop();
        if (result == 0) {
            return 0;
        }
        return result > 0;
    }

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
            if (menu_sel[select] >= 7) {
                menu_sel[select] = 6;
            }
            break;
        case 3:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }
            if (menu_sel[select] >= 3) {
                menu_sel[select] = 2;
            }
            break;
        case 8:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }
            if (menu_sel[select] >= 5) {
                menu_sel[select] = 4;
            }
            break;
        case 10:
            if (menu_sel[select] < 0) {
                menu_sel[select] = 0;
            }
            if (menu_sel[select] >= 2) {
                menu_sel[select] = 1;
            }
            break;
    }

    text = display;
    text += sprintf(text, "\n\x83\x5F\x81\x5B\x83\x4E\x83\x4E\x83\x8D\x83\x6A\x83\x4E\x83\x8B\x83\x56\x83\x58\x83\x65\x83\x80\x92\xB2\x90\xAE" "ROM %s %s\n", "2003/07/29", "Ver0.334");
    for (row = 0; menu[row][0] != '\0'; row++) {
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
        case 1:
        case 2:
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
    if (!GamePad__2.Down(PAD_CIRCLE)) {
        return 0;
    }

    INIT_LOOP_ARG arg;
    memset(&arg, 0, sizeof(arg));
    char config_name[64] = "";

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
            chapter = menu_sel[select];
            switch (chapter) {
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
            if (chapter >= 2) {
                monica = 1;
            }
            if (select == 1) {
                sprintf(config_name, "cap%d.cfg", chapter + 1);
            } else {
                sprintf(config_name, "db_cap%d.cfg", chapter + 1);
            }
            break;
        case 3:
            subgame = menu_sel[select];
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", EventSelect__Fv);
#endif
mgCTexture *GetFontTexture(int page) {
    if ((page < 0) || (page > 0)) {
        return 0;
    }
    return *(&FontTex + page);
}
void LoadFontTexture(void) {
    u8 scratch[0x35000];
    char path[0x40];
    char file_name[0x20];
    int size;
    u8 *buffer;
    int page;
    u32 misalign;

    buffer = scratch;
    FontTex = 0;
    misalign = (u32)buffer & 3;
    FontDataAdr = 0;
    if (misalign != 0) {
        buffer += (4 - misalign) * 0x10;
    }
    page = 0;
    do {
        if (LanguageCode == 0) {
            sprintf(file_name, at_1654, page);
        } else if (LanguageCode == 1) {
            if (page == 0) {
                sprintf(file_name, at_1655, page);
            }
        } else if (page == 0) {
            sprintf(file_name, at_1656);
        }
        sprintf(path, at_1657, file_name);
        if (LoadFile2(path, buffer, &size, 0) != 0) {
            (&FontDataAdr)[page] = (u32)font_buff;
            if ((&FontDataAdr)[page] == 0) {
                return;
            }
            memcpy((void *)(&FontDataAdr)[page], buffer, size);
        }
        page += 1;
    } while (page <= 0);
}
void ReLoadFontTexture(int texture_no) {
    char file_name[0x20];
    int page;
    int offset;
    TM2_head **font_data;

    offset = 0;
    page = 0;
    do {
        font_data = (TM2_head **)((u8 *)&FontDataAdr + offset);
        if (*font_data != NULL) {
            if (LanguageCode == 0) {
                sprintf(file_name, at_1654, page);
            } else if (LanguageCode == 1) {
                if (page == 0) {
                    sprintf(file_name, at_1655, page);
                }
            } else if (page == 0) {
                sprintf(file_name, at_1656);
            }
            if (&mgTexManager == NULL) {
                return;
            }
            *(mgCTexture **)((u8 *)&FontTex + offset) = mgTexManager.EnterTexture(texture_no, file_name, *font_data, 0, 0);
        }
        page += 1;
        offset += 4;
    } while (page <= 0);
}
void demQuit() {}
void demoQuitTimeOut() {}
void demoAttractInterrupted() {}
void demoAttractComplete() {}
void FadeOutForE3() {}
int TimeLimitCheck() { return 0; }
#ifdef NONMATCHING
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", InitPauseMenu__Fi);
#endif
#ifdef NONMATCHING
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
            if (PadCtrl.Analog(0) > 0.8f) {
                PauseSel = 1;
            }
            if (PadCtrl.Analog(0) < -0.8f) {
                PauseSel = 0;
            }
            if (PauseMes.select < 0) {
                PauseMes.cursor_time = 0;
            }
            PauseMes.select = PauseSel;
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
    prim.ZMask(1);
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", PauseMenu__Fv);
#endif
extern "C" void *__ct__18CScriptInterpreterFv(void *);
extern "C" int SetScript__18CScriptInterpreterFPci(...);
void LoadGameConfig(char *path) {
    u8 script[0x4000];
    u8 interpreter[sizeof(CScriptInterpreter)];
    int size;

    if (path == NULL) {
        SetCurrentDir(at_1296);
        if (LoadFile2(at_1856, script, &size, 0) == 0) {
            SetCurrentDir(NULL);
            return;
        }
        SetCurrentDir(NULL);
        goto run;
    }
    if (LoadFile2(path, script, &size, 0) != 0) {
    run:

        __ct__18CScriptInterpreterFv(interpreter);
        ((CScriptInterpreter *)interpreter)->SetTag(tag__3);
        SetScript__18CScriptInterpreterFPci(interpreter, (char *)script, size);
        ((CScriptInterpreter *)interpreter)->Run();
    }
}
int gcMAP_NO(SPI_STACK *stack, int arg) {
    int map_no;
    if (stack->type == 0) {
        map_no = SearchMapNo(spiGetStackString(stack));
    } else {
        map_no = spiGetStackInt(stack);
    }
    SelectArg.selected_map_no = map_no;
    return 1;
}
int gcPROGRESS(SPI_STACK *stack, int arg) {
    int value = spiGetStackInt(stack);
    CSaveData *save = GetSaveData();
    save->game_progress = value;
    return 0;
}
int gcBIT_FLAG_ON(SPI_STACK *stack, int count) {
    CSaveData *save_data;
    int i;

    for (i = 0; i < count; i++) {
        save_data = GetSaveData();
        save_data->SetBitFlag(spiGetStackInt(stack++), 1);
    }
    return 0;
}
int gcBIT_FLAG_OFF(SPI_STACK *stack, int count) {
    CSaveData *save_data;
    int i;

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
    int i;
    int index;
    void *edit_data;

    DebugInfo.georama_debug = 1;
    for (i = 0; i < count; i++) {
        index = spiGetStackInt(stack++);
        edit_data = GetSaveData()->GetEditData(index);
        if (edit_data != 0) {
            ((CEditData *)edit_data)->dbgSetAllContintionFlag(index, 1);
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
    int i;
    CUserDataManager *user_data;

    for (i = 0; i < count; i++) {
        user_data = &GetSaveData()->user_data;
        user_data->GetItem(spiGetStackInt(stack++), 1);
    }
    return 1;
}
int gcGET_N_ITEM(SPI_STACK *stack, int count) {
    int item_no;
    int i;
    CUserDataManager *user_data;

    for (i = 0; i < count; i++) {
        user_data = &GetSaveData()->user_data;
        item_no = spiGetStackInt(stack++);
        user_data->GetItem(item_no, spiGetStackInt(stack++));
    }
    return 1;
}
int gcEQUIP(SPI_STACK *stack, int arg_count) {
    int chara_no;
    int item_no;
    CUserDataManager *user_data;
    user_data = &GetSaveData()->user_data;
    chara_no = spiGetStackInt(stack++);
    item_no = spiGetStackInt(stack);
    user_data->SetChrEquip(chara_no, item_no);
    return 1;
}
int gcDEFENSE(SPI_STACK *stack, int arg_count) {
    int chara_no;
    int defence;
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
    int chara_no;
    int hp;
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
#ifdef NONMATCHING
/**
 * Unlocks Geostones and town conditions and grants Georama materials.
 */
static int gcALL_GEO_PARTS(SPI_STACK *stack, int argc) {
    CSaveDataDungeon *dungeon;
    DNG_FLOOR_SAVE   *floor;
    CEditData        *edit;
    int              mode;
    int              stage;
    int              floor_no;
    int              town;
    int              i;

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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", gcALL_GEO_PARTS__FP9SPI_STACKi);
#endif
int gcPARAM_DRAW(SPI_STACK *stack, int arg_count) {
    DebugInfo.param_off = !spiGetStackInt(stack);
    return 1;
}
int gcOPTION(SPI_STACK *stack, int arg) {
    char *name;
    SV_CONFIG_OPTION *options;
    SPI_STACK *value;

    value = stack + 1;
    name = (char *)spiGetStackString(stack);
    if (name == NULL) {
        return 0;
    }
    options = &GetSaveData()->config;
    if (strcmp(name, at_2082) == 0) {
        options->monster_name = spiGetStackInt(value);
    } else if (strcmp(name, at_2083) == 0) {
        options->map = spiGetStackInt(value);
    } else if (strcmp(name, at_2084) == 0) {
        options->enemy_hp = spiGetStackInt(value);
    } else if (strcmp(name, at_2085) == 0) {
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
    int sp7C;
    CUserDataManager *manager;
    int i;
    int monster_id;
    int badge_no;
    MOS_CHANGE_PARAM *badge;

    manager = GetUserDataMan();
    if (manager == NULL) {
        return 0;
    }
    manager->JoinPartyMember(3);
    manager->GetItemNotOver(0x134, 1);
    for (i = 0; i < arg_count; i++) {
        monster_id = spiGetStackInt(stack++);
        badge_no = get_gajji_id_from_monster_progress_table(monster_id, &sp7C) + 1;
        manager->monster_box.EnableChange(badge_no);
        badge = manager->monster_box.GetMonsterBajjiData(badge_no);
        if (badge != NULL) {
            badge->class_level = sp7C;
            badge->monster_id = monster_id;
            badge->progress = GetMonsterProgressTableNo(sp7C, monster_id);
        }
        manager->monster_id = monster_id;
    }
    return 1;
}
int gcPARTY(SPI_STACK *stack, int arg_count) {
    int chara_no;
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
    int chara_no;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", __ct__16CUserDataManagerFv);
extern "C" CEditData *__ct__9CEditDataFv(CEditData *self) {
    char *entry;
    char *cursor;
    char *entry2;
    char *cursor2;

    cursor = (char *)self->parts;
    entry = cursor;
    do {
        memset(entry, 0, 0x24);
        cursor += 0x24;
        entry = cursor;
    } while ((u32)cursor < (u32)&self->house_max);
    cursor2 = (char *)self->house;
    entry2 = cursor2;
    do {
        memset(entry2, 0, 0x10);
        cursor2 += 0x10;
        entry2 = cursor2;
    } while ((u32)cursor2 < (u32)self->place_log);
    memset(&self->analyze, 0, sizeof(self->analyze));
    self->Initialize();
    return self;
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", __sinit_mainloop_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", LoopInit__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", LoopMain__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", LoopExit__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", pad_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", analog_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", SelectArg__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", menu_1281__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1305__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1310__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1311__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", menu_sel_1452__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1456__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", menu_1457__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", tag__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1212__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1213__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1214__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1215__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1216__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1282__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1283__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1284__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1285__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1286__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1287__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1288__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1289__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1290__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1291__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1292__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1293__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1294__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1295__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1296__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1297__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1298__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1299__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1300__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1301__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1302__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1303__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1304__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1306__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1307__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1308__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1309__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1315__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1316__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1408__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1409__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1410__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1411__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1412__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1413__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1414__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1415__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1416__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1417__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1418__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1453__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1454__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1455__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1458__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1459__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1460__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1461__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1462__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1463__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1464__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1465__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1466__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1467__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1468__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1472__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1473__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1582__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1583__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1584__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1585__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1586__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1587__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1588__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1589__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1590__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1591__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1592__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1593__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1594__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1596__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1595__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1654__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1655__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1656__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1657__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1823__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1824__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1825__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1826__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1827__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1828__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1829__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1830__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1831__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1832__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1833__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1834__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1835__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1836__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1837__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1838__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1839__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1840__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1841__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1842__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1843__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1844__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1856__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2082__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2083__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2084__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2085__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", D_0037AFF8__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", MainThreadPriority__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_973__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_974__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1317__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1474__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(read_buffer, 0x4);
INCLUDE_BSS(SystemSND_ID, 0x4);
INCLUDE_BSS(DebugFlag, 0x4);
INCLUDE_BSS(DefStartEventNo, 0x4);
INCLUDE_BSS(LanguageCode, 0x4);
INCLUDE_BSS(OmakeFlag, 0x4);
INCLUDE_BSS(MasterDebugCode, 0x4);
INCLUDE_BSS(LoopNo, 0x4);
INCLUDE_BSS(NextLoopNo, 0x4);
INCLUDE_BSS(PrevLoopNo, 0x4);
INCLUDE_BSS(CaptureMode, 0x4);
INCLUDE_BSS(CaptureScreen, 0x4);
INCLUDE_BSS(CSnd, 0x4);
INCLUDE_BSS(ActiveSaveData, 0x4);
INCLUDE_BSS(SubGameSaveData, 0x4);
INCLUDE_BSS(PlayTimeCountFlag, 0x4);
INCLUDE_BSS(pmeter_flag_1037, 0x4);
INCLUDE_BSS(init_1038, 0x4);
INCLUDE_BSS(pause_1108, 0x4);
INCLUDE_BSS(init_1109, 0x4);
INCLUDE_BSS(menu_mode, 0x4);
INCLUDE_BSS(init_1225, 0x4);
INCLUDE_BSS(init_1228, 0x4);
INCLUDE_BSS(init_1231, 0x4);
INCLUDE_BSS(init_1234, 0x4);
INCLUDE_BSS(select_1312, 0x4);
INCLUDE_BSS(init_1313, 0x4);
INCLUDE_BSS(event_view, 0x4);
INCLUDE_BSS(future_sel, 0x4);
INCLUDE_BSS(hdd_sel, 0x4);
INCLUDE_BSS(select_1469, 0x4);
INCLUDE_BSS(init_1470, 0x4);
INCLUDE_BSS(FontTex, 0x4);
INCLUDE_BSS(FontDataAdr, 0x4);
INCLUDE_BSS(BlackFade, 0x4);
INCLUDE_BSS(BlackFade2, 0x4);
INCLUDE_BSS(exit_start, 0x4);
INCLUDE_BSS(PauseSel, 0x4);
INCLUDE_BSS(PauseMenuMode, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(GamePad__2, 0x480);
INCLUDE_BSS(PadCtrl, 0x510);
INCLUDE_BSS(DebugInfo, 0x20);
INCLUDE_BSS(Font, 0xC0);
INCLUDE_BSS(InitArg, 0x50);
INCLUDE_BSS(NextInitArg, 0x50);
INCLUDE_BSS(PrevInitArg, 0x50);
INCLUDE_BSS(main_buffer, 0x1A00000);
static INCLUDE_BSS(MainBuffer, 0x30);
INCLUDE_BSS(MainScene, 0x10550);
INCLUDE_BSS(SystemSeBuff, 0x1900);
INCLUDE_BSS(SystemSeStack, 0x30);
INCLUDE_BSS(InfoBuff, 0x13880);
INCLUDE_BSS(InfoStack, 0x30);
INCLUDE_BSS(SaveData, 0x65930);
INCLUDE_BSS(vu_prog_1048, 0x40);
INCLUDE_BSS(MenuBuffer, 0x30);
INCLUDE_BSS(buf0_1224, 0x30);
INCLUDE_BSS(buf1_1227, 0x30);
INCLUDE_BSS(dbuf0_1230, 0x30);
INCLUDE_BSS(dbuf1_1233, 0x30);
INCLUDE_BSS(at_1529, 0x40);
INCLUDE_BSS(font_buff, 0xD000);
INCLUDE_BSS(PauseMes, 0x2960);
