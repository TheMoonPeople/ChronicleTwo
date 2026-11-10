#include "common.h"

#include <libgraph.h>

#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <format>
#include <memory>
#include <span>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <vector>

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
#include "memory/tracked_copy.hpp"
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
int NextLoopNo;
/**
 * Mode active before the current main loop.
 */
int PrevLoopNo;
/**
 * Whether input replay also captures screen images.
 */
int CaptureScreen;
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
static float BlackFade2;
/**
 * Main memory arena for game resources.
 */
u_long128 main_buffer[0x1A0000];
/**
 * Memory backing the system sound-effect loader.
 */
u_long128 SystemSeBuff[400];
/**
 * Memory backing configuration and villager data.
 */
u_long128      InfoBuff[5000];
static void    MenuInit(INIT_LOOP_ARG arg);
static void    MenuExit();
static int     MenuLoop();
static int     EventSelect();
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
static int  menu_mode;
static void InitEventSelect();

/**
 * Values selected by the debug menu and game configuration tags.
 */
int SelectArg[32] = {0};

/**
 * Save data used by the current game mode.
 */
CSaveData *ActiveSaveData;
/**
 * Selected input capture or replay mode.
 */
int CaptureMode;
/**
 * Currently active main-loop mode.
 */
int LoopNo;
/**
 * Whether vertical blank advances the saved play time.
 */
int PlayTimeCountFlag;
/**
 * Save-data arena for the active extra game.
 */
CSubGameData *SubGameSaveData;
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
static int    hdd_sel;
extern CScene MainScene;

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
alignas(TM2_head) static u8 font_buff[0xD000];

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

void InitSaveData();

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
    int language_index = {};
    int i = {};

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
    LoadHelpMes();
    LoadMapName(LanguageCode, read_buffer);
    LanguageEquipChange();
    LoadNPCCfg();
    LoadSystemMes();
    LoadGaijiImg();
    LoadFontTexture();
    LoadFontTblBin();
    LoadEditAnalyzeData(LanguageCode, read_buffer);
    LoadFilePictureName();
    LoadMonsterLanguage(LanguageCode);
    InfoStack.stReset();
    LoadGameInfo(&InfoStack);
    InitPauseData();
    InitPadTable(LanguageCode);
}

void MainLoop();

/**
 *
 * Prepares rendering and resource buffers for the main debug menu.
 *
 */
void MenuInit(INIT_LOOP_ARG arg) {
    mgCMemory *main_stack = {};
    u_long128 *packet_a = {};
    u_long128 *packet_b = {};

    sndSeAllStop(-1);
    sndDeletePort(SND_PORT_BGM);
    MainScene.InitBGM();
    MainScene.InitSeEnv();
    MainScene.InitSeSrc();
    menu_mode = DEBUG_MENU_TOP;
    mgInitFont();
    main_stack = GetMainStack();
    if (main_stack == nullptr) {
        throw std::length_error("debug menu arena is unavailable");
    }
    main_stack->stReset();
    const auto reserve = [main_stack](int quadwords) {
        auto *storage = main_stack->stAlloc64(quadwords);
        if (storage == nullptr) {
            throw std::length_error("debug menu arena exhausted");
        }
        return storage;
    };

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

    packet_a = reserve(0x2710);
    packet_b = reserve(0x2710);
    mgInitVif1Packet(packet_a, packet_b, 0x27100);
    buf0.stSetChildBuffer(*main_stack, reserve(0x2710), 0x2710);
    buf1.stSetChildBuffer(*main_stack, reserve(0x2710), 0x2710);
    dbuf0.stSetChildBuffer(*main_stack, reserve(0xC350), 0xC350);
    dbuf1.stSetChildBuffer(*main_stack, reserve(0xC350), 0xC350);
    MenuBuffer.stSetChildBuffer(*main_stack, reserve(0x7A120), 0x7A120);
    BindReadBuffer(std::span<u8>(reinterpret_cast<u8 *>(reserve(0x186A0)),
                                 static_cast<std::size_t>(0x186A0) * sizeof(u_long128)),
                   *main_stack);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    GamePad__2.SetAutoRepeat(PAD_UP | PAD_RIGHT | PAD_DOWN | PAD_LEFT, 0xF, 4);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
    SetTextureTable(0x64, 0x14, &MenuBuffer);

    if (DebugFlag == 0) {
        InitEventSelect();
    }

    mgTexManager.DeleteBlock(1);
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 1, nullptr, nullptr);
    ReLoadFontTexture(1);
    LoadEventViewData(ReadBufferBytes(), &MenuBuffer);
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
    int                map_result = {};

    textures->ReloadTexture(1, (sceVif1Packet *) nullptr);

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
        textures->ReloadTexture(1, (sceVif1Packet *) nullptr);
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
    char       *item_set[] = {"Presentation", "GameStart", "StartDebug", "WeaponOnly"};
    int         item_set_no[] = {0, 1, 2, 6};
    std::string text;
    std::string config_name;
    int         row = 0;
    static int  select = 0;
    char       *cursor[] = {" ", ">"};
    int        *menu_arguments = SelectArg;

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

    menu_arguments[DEBUG_ROW_ITEM_SET] = std::clamp(menu_arguments[DEBUG_ROW_ITEM_SET], 0, 3);

    text = "\nDark Chronicle Ver0.334\n";

    switch (CaptureMode) {
        case CAPTURE_RECORD:
            text += "Capture Input Key\n";
            break;
        case CAPTURE_PLAY:
            text += "Play Input Key\n";
            break;
        case CAPTURE_PLAY_SCREEN:
            text += "Play Input Key and Capture Screen\n";
            break;
        default:
            text += '\n';
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
            text += std::format("{}{}{}\n", cursor[row == select], menu[row], item_set[menu_arguments[row]]);
        } else if (row == DEBUG_ROW_LANGUAGE) {
            text += std::format("{}{}{} (now {})\n", cursor[row == select], menu[row], language[menu_arguments[row]], language[std::clamp(LanguageCode, 0, 7)]);
        } else if (row <= 0) {
            text += std::format("{}{}\n", cursor[row == select], menu[row]);
        } else {
            text += std::format("{}{}{}\n", cursor[row == select], menu[row], menu_arguments[row]);
        }

        if (++row >= DEBUG_ROW_NUM) {
            break;
        }
    }

    Font.DrawDirect(text.data(), 10, 10);

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
            config_name = std::format("dbg/game{}.cfg.json", menu_arguments[select]);
            InitSaveData();
            LoadGameConfig(config_name.data());
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

    int result = {};

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

    std::string display;
    char       *subgame_name[DEBUG_SUB_GAME_NUM] = {"Spheda", "GyoRace", "Fishing"};
    int         row = 0;
    char       *map_name = {};
    static int  select = 0;
    int         loop_no = {};
    int         monica = {};
    char       *cursor[2] = {"  ", ">>"};

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

    display = "\n\x83\x5F\x81\x5B\x83\x4E\x83\x4E\x83\x8D\x83\x6A\x83\x4E\x83\x8B\x83\x56\x83\x58\x83\x65\x83\x80\x92\xB2\x90\xAE"
              "ROM 2003/07/29 Ver0.334\n";

    for (; menu[row][0] != '\0'; row++) {
        display += std::format("{}{}", cursor[row == select], menu[row]);

        switch (row) {
            case DEBUG_EVENT_ROW_CHAPTER:
            case DEBUG_EVENT_ROW_CHAPTER_DEBUG:
                display += std::format("{}\x8F\xCD", menu_sel[row] + 1);
                break;
            case DEBUG_EVENT_ROW_SUB_GAME:
            case DEBUG_EVENT_ROW_EXTRA:
                display += subgame_name[menu_sel[row]];
                break;
            case DEBUG_EVENT_ROW_DIORAMA_MAP:
                if (GetMapName(menu_sel[row], &map_name)) {
                    display += map_name != nullptr ? map_name : "";
                }

                break;
        }

        display += '\n';
    }

    display += '\n';

    switch (select) {
        case DEBUG_EVENT_ROW_CHAPTER_DEBUG:
        case DEBUG_EVENT_ROW_CHAPTER:
            display += "\x95\xFB\x8C\xFC\x83\x4C\x81\x5B\x8D\xB6\x89\x45\x82\xC5\x8F\xCD\x91\x49\x91\xF0\n";
            break;
        case DEBUG_EVENT_ROW_SUB_GAME:
            display += "\x95\xFB\x8C\xFC\x83\x4C\x81\x5B\x8D\xB6\x89\x45\x82\xC5\x83\x54\x83\x75\x83\x51\x81\x5B\x83\x80\x82\xCC\x8E\xED\x97\xDE\x91\x49\x91\xF0\n";
            break;
    }

    Font.DrawDirect(display.data(), 10, 10);

    if (GamePad__2.Down(PAD_CROSS)) {
        menu_mode = DEBUG_MENU_TOP;
        return false;
    }

    if (GamePad__2.Down(PAD_CIRCLE)) {
        INIT_LOOP_ARG arg;
        std::string   config_name;

        loop_no = LOOP_EDIT;
        monica = false;

        switch (select) {
            case DEBUG_EVENT_ROW_BEGINNING:
                arg.map_no = 0;
                loop_no = LOOP_TITLE;
                config_name.clear();
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
                    config_name = std::format("cap{}.cfg.json", menu_sel[select] + 1);
                } else {
                    config_name = std::format("db_cap{}.cfg.json", menu_sel[select] + 1);
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

                config_name = std::format("sg{}.cfg.json", subgame);
                break;
            }
            case DEBUG_EVENT_ROW_PALM_BRINKS:
                config_name = "pb.cfg.json";
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
                config_name = "geo.cfg.json";
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

        std::string config_path = "dbg/" + config_name;
        InitSaveData();
        LoadGameConfig(config_path.data());

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
        return nullptr;
    }

    return FontTex[page];
}

void LoadFontTexture() {
    int page = {};
    FontTex[0] = nullptr;
    FontDataAdr[0] = nullptr;

    page = 0;

    do {
        std::string file_name;
        if (LanguageCode == LANG_JAPANESE) {
            file_name = std::format("FontTex_{}.json", page);
        } else if (LanguageCode == LANG_ENGLISH) {
            if (page == 0) {
                file_name = "FontTex_1_0.json";
            }
        } else if (page == 0) {
            file_name = "FontTex_2_0.json";
        }

        std::string path = "textures/meswin/" + file_name;
        int         size = 0;
        if (LoadFile2(path.data(), std::span<u8>{}, &size, LOAD_FILE_SIZE) != 0 &&
            size >= 0 && static_cast<std::size_t>(size) <= sizeof(font_buff)) {
            const auto      sector = static_cast<std::size_t>(DATAREAD_SECTOR_SIZE);
            const auto      capacity = std::max(sector, (static_cast<std::size_t>(size) + sector - 1) / sector * sector);
            std::vector<u8> buffer(capacity);
            if (LoadFile2(path.data(), std::span<u8>(buffer), &size, LOAD_FILE_READ) != 0 &&
                size >= 0 && static_cast<std::size_t>(size) <= sizeof(font_buff)) {
                FontDataAdr[page] = reinterpret_cast<TM2_head *>(font_buff);
                dc2::memory::CopyTrackedBytes(FontDataAdr[page], buffer.data(), static_cast<std::size_t>(size));
            }
        }

        page += 1;
    } while (page <= 0);
}

void ReLoadFontTexture(int texture_no) {
    int page = {};

    for (page = 0; page <= 0; page++) {
        if (FontDataAdr[page] != nullptr) {
            std::string file_name;
            if (LanguageCode == LANG_JAPANESE) {
                file_name = std::format("FontTex_{}.json", page);
            } else if (LanguageCode == LANG_ENGLISH) {
                if (page == 0) {
                    file_name = "FontTex_1_0.json";
                }
            } else if (page == 0) {
                file_name = "FontTex_2_0.json";
            }

            if (&mgTexManager == nullptr) {
                return;
            }

            FontTex[page] = mgTexManager.EnterTexture(texture_no, file_name.data(), FontDataAdr[page], 0, 0);
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
    int result = {};
    int previous_select = {};
    int selected = {};

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

            selected = PauseSel;

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

    prim.Initialize(nullptr, nullptr);
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

void LoadGameConfig(char *path);

CUserDataManager::CUserDataManager() {}

CEditData::CEditData() {
    Initialize();
}

int MainThreadPriority = 1;

u_long128 *read_buffer;

namespace {
/** Current read buffer's logical owner and exact backing allocation. */
dc2::memory::ArenaBuffer active_read_buffer;
} // namespace

void BindReadBuffer(std::span<u8> storage, mgCMemory &owner, mgCMemory *backing) {
    if (!storage.empty() && reinterpret_cast<std::uintptr_t>(storage.data()) % alignof(u_long128) != 0) {
        storage = {};
    }
    active_read_buffer = dc2::memory::ArenaBuffer::Bind(owner, storage, backing);
    read_buffer = reinterpret_cast<u_long128 *>(active_read_buffer.Bytes().data());
}

std::span<u8> ReadBufferBytes() {
    const auto storage = active_read_buffer.Bytes();
    return reinterpret_cast<u8 *>(read_buffer) == storage.data() ? storage : std::span<u8>{};
}

dc2::memory::ArenaBuffer ReadBufferLease() {
    return ReadBufferBytes().empty() ? dc2::memory::ArenaBuffer{} : active_read_buffer;
}

u32    SystemSND_ID;
int    DebugFlag;
int    DefStartEventNo;
int    LanguageCode;
int    OmakeFlag;
int    MasterDebugCode;
CSound CSnd;

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
mgCMemory MainBuffer;
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

#include "common.h"

#include <libgraph.h>

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <optional>
#include <print>
#include <utility>

#include "arena_root.hpp"
#include "crash/crash.hpp"
#include "dataread.hpp"
#include "debug_mode.hpp"
#include "dng_main.hpp"
#include "editdata.hpp"
#include "editloop.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "helpmes.hpp"
#include "inventmn.hpp"
#include "item_icon3d.hpp"
#include "log/log.hpp"
#include "main.hpp"
#include "mainloop.hpp"
#include "mainloop3.hpp"
#include "mapjump.hpp"
#include "mapselect.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nowload.hpp"
#include "npccfg.hpp"
#include "object/character/quick_change_presentation.hpp"
#include "object/menu/loading_screen.hpp"
#include "object/world/town_control.hpp"
#include "padcontrol.hpp"
#include "platform/arena.hpp"
#include "platform/arena_usage.hpp"
#include "platform/config.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"
#include "play_time.hpp"
#include "quick_loadout.hpp"
#include "render/renderer.hpp"
#include "save_slots.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "test_hooks.hpp"
#include "userdata.hpp"
#include "vlgr_info.hpp"

int PortVSyncCallBack(int unused) asm("MainLoop_VSyncCallBack");

bool PortAutosave = false;

namespace {

std::optional<std::pair<int, int>> autosaved_floor;
std::optional<int>                 autosaved_map;

bool AutosaveEnabled() {
    return PortAutosave && ConfigGet().autosave && PortCaptureMode == CAPTURE_OFF;
}

void WriteAutosave(int program_loop_no, AutosaveSpawn *spawn = nullptr) {
    if (!SaveSlotWriteAutosave(program_loop_no, spawn)) {
        CT_LOG_ERROR(Save, "autosave: could not write {}", PathsDisplay(SaveSlotAutosavePath()));
    }
}

/**
 * Writes or discards the floor-entry save on the floor's first controllable frame.
 */
void AutosaveFloor() {
    const auto *save = GetSaveData();
    if (!save || !PortDungeonFieldControl() || save->save_dungeon.stage_id < 0 || save->save_dungeon.stage_id >= SAVE_DUNGEON_NUM) {
        return;
    }
    const auto &dungeon = save->save_dungeon;
    const auto  floor = std::pair{dungeon.stage_id, static_cast<int>(dungeon.floor_id[dungeon.stage_id])};
    if (floor == autosaved_floor) {
        return;
    }
    autosaved_floor = floor;
    if (!SaveSlotHasFloorEntry()) {
        // A floor entered without the load event's DNG_FLOOR_INIT has no entry state to resume from.
        CT_LOG_DEBUG(Save, "autosave: stage {} floor {} has no entry state; not saved", floor.first, floor.second);
    } else if (!AutosaveEnabled()) {
        CT_LOG_DEBUG(Save, "autosave: off at stage {} floor {}; not saved", floor.first, floor.second);
    } else {
        WriteAutosave(LOOP_DUNGEON);
    }
    SaveSlotForgetFloorEntry();
}

// Save on the first controllable exterior frame of each town map.
void AutosaveTown() {
    if (!GetSaveData() || !PortTownFieldControl() || InInterior()) {
        return;
    }
    CScene      *scene = GetMainScene();
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);
    mgCCamera   *camera = scene->GetCamera(scene->active_camera);
    const int    map = scene->GetNowMapNo();
    if (!chara || !camera || map < 0) {
        return;
    }
    if (auto spawn = SaveSlotTakePendingSpawn(GetSaveData()->map_no)) {
        chara->SetPosition(spawn->position);
        chara->SetRotation(spawn->rotation);
        chara->ResetDAPosition();
        chara->Step();
        chara->StepDA(10);
        camera->SetPos(spawn->camera_pos);
        camera->SetRef(spawn->camera_ref);
        autosaved_map = map;
        return;
    }
    if (AutosaveEnabled() && map != autosaved_map) {
        autosaved_map = map;
        AutosaveSpawn spawn;
        spawn.map_no = GetSaveData()->map_no;
        chara->GetPosition(spawn.position);
        chara->GetRotation(spawn.rotation);
        camera->GetPos(spawn.camera_pos);
        camera->GetRef(spawn.camera_ref);
        WriteAutosave(LOOP_EDIT, &spawn);
    }
}

// Names the mode being entered and its entry arguments in a crash report.
void RecordCrashContext(int mode, const INIT_LOOP_ARG &arg) {
    static constexpr std::string_view kModeNames[LOOP_MODE_NUM] = {
        "menu",
        "edit",
        "dungeon",
        "title",
        "chara viewer",
        "texture viewer",
        "map viewer",
        "sound viewer",
        "movie viewer",
        "save conversion",
    };
    CT_LOG_DEBUG(Main, "mainloop: mode {} (map {}, floor {}, event {})", kModeNames[mode], arg.map_no, arg.floor_no,
                 arg.event_no);
    CrashContextSet(CrashKey::Loop, kModeNames[mode]);
    CrashContextSetInt(CrashKey::Map, arg.map_no);
    CrashContextSetInt(CrashKey::Floor, arg.floor_no);
    CrashContextSetInt(CrashKey::Event, arg.event_no);
}

} // namespace

bool PortDungeonFieldControl() {
    const auto *scene = GetMainScene();
    return DngStatus.mode == DNG_STATUS_FIELD && scene && !scene->event_run && !GamePad__2.key_lock && BattleAreaScene &&
           !(BattleAreaScene->pause_flag & (DNG_PAUSE_PLAYER_STEP | DNG_PAUSE_FIELD_STEP));
}

bool PortTownFieldControl() {
    const CScene *scene = GetMainScene();
    return scene && !IsEditMode() && PortTownLoopMode == EDIT_LOOP_WALK && PortTownControlMode == EDIT_CONTROL_PLAYER &&
           !PortTownLockChara && !PortTownPause && !scene->event_run && !GamePad__2.key_lock && !SubGameRunning();
}

void PortAutosaveResetArrival() {
    autosaved_floor.reset();
    autosaved_map.reset();
    SaveSlotForgetFloorEntry();
}

void PortAutosaveStep(int program_loop_no) {
    if (program_loop_no == LOOP_DUNGEON) {
        AutosaveFloor();
    } else if (program_loop_no == LOOP_EDIT) {
        AutosaveTown();
    }
}

extern u_long128 main_buffer[0x1A0000];
extern CScene    MainScene;
extern CFont     Font;

namespace {
constexpr int kSubGameQuads = std::max(5000, static_cast<int>((sizeof(CSubGameData) + 15) / 16));
} // namespace

int PortPlayTimeVSyncCallback(int /*unused*/) {
    if (PortPlayTimeCountFlag != 0) {
        GetSaveData()->play_time += PlayTimeTick(true);
    }
    return 0;
}

void InitSaveData() {
    GetSaveData()->Initialize();
    SaveSlotSetPendingSpawn(std::nullopt);
    PlayTimeReset();
}

void PortDrawFrameBorder() {
    const auto  edge = mgPortVisibleExtent();
    mgCDrawPrim frame_border;
    frame_border.Initialize(nullptr, nullptr);
    frame_border.DepthTestEnable(false);
    frame_border.AlphaTestEnable(false);
    frame_border.AlphaBlendEnable(false);
    frame_border.TextureMapEnable(false);
    frame_border.ZMask(MG_Z_MASK_MASKED);
    frame_border.Begin(MG_PRIM_LINE_STRIP);
    frame_border.Color(0, 0, 0, 0x80);
    frame_border.Vertex(edge.left, edge.top, 0.0f);
    frame_border.Vertex(edge.right - 1, edge.top, 0.0f);
    frame_border.Vertex(edge.right - 1, edge.bottom - 1, 0.0f);
    frame_border.Vertex(edge.left, edge.bottom - 1, 0.0f);
    frame_border.Vertex(edge.left, edge.top, 0.0f);
    frame_border.End();
}

void MainLoop() {
    static u_long128 *vu_prog[16];

    mgCMemory        *memory = nullptr;
    mgCMemory        *read_memory = nullptr;
    CUserDataManager *user_data = nullptr;
    u_long128        *file_buffer = nullptr;
    int               file_size = 0;
    int               mode_finished = 0;
    std::uintptr_t    buffer_address = 0;
    std::uintptr_t    alignment = 0;
    u_long128        *main_arena = ArenaRoot(&main_buffer, 0x1A0000, "MainBuffer");

    memory = GetMainStack();
    memory->stSetBuffer(main_arena, 0x1A0000 * kArenaHeadroom);
    memory->stReset();
    SaveData.Initialize();
    PlayTimeReset();
    PortActiveSaveData = &SaveData;
    PortSubGameSaveData = nullptr;
    DebugFlag = false;
    GamePad__2.Init();
    InitFileCache({}, FILE_CACHE_NONE);
    mgInit(MG_SCREEN_MODE_512X480, 3);
    PortPlayTimeCountFlag = false;
    mgInitVSyncCallBack(PortPlayTimeVSyncCallback);
    LanguageCode = GameHasJump() ? LANG_ENGLISH : LANG_FRENCH;
    CrashContextSet(CrashKey::Loop, "boot");
    if (!GameHasJump()) {
        SCElogoFade(0, memory);
    }
    PortLoopNo = LOOP_TITLE;
    DebugFlag = false;
    DebugInfo.chara_move = 0;

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
    DebugModeBoot(GameDebugEnabled());

    GamePad__2.DebugKeyLock(1);
    sceGsSyncV(0);
    GamePad__2.UpDate();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    mgSetUserVuProg(vu_prog, 16);
    mgSetUserVuProgAdr(0, Vu_prog_wtr);
    PortInitPadTable(LanguageCode);
    GameItemDataManage.LoadData();
    GameItemDataManage.LoadItemSystemMes(LanguageCode);
    LoadSystemMes();
    CreateSystemMes();
    LoadFontTexture();
    LoadGaijiImg();
    LoadFontTblBin();
    LoadNPCCfg();
    InfoStack.stSetBuffer(ArenaRoot(PortInfoBuff, 5000, "InfoStack"), 5000 * kArenaHeadroom);
    LoadGameInfo(&InfoStack);
    InitPauseData();
    InitSaveData();
    user_data = nullptr;

    if (PortActiveSaveData != nullptr) {
        user_data = &PortActiveSaveData->user_data;
    }

    LoadMonsterLanguage(LanguageCode);
    PortInitPadTable(LanguageCode);
    LanguageEquipChange();
    DebugGetItem(user_data, 0);
    PortCaptureMode = CAPTURE_OFF;
    sndInitMngr();
    MainScene.InitSnd();
    SetCurrentDir(nullptr);
    SystemSeStack.stSetBuffer(ArenaRoot(PortSystemSeBuff, 400, "SystemSeStack"), 400 * kArenaHeadroom);
    SystemSeStack.stReset();
    read_memory = GetMainStack();
    buffer_address = reinterpret_cast<std::uintptr_t>(read_memory->stack + read_memory->stack_used);
    alignment = buffer_address % 64;

    if (alignment != 0) {
        buffer_address += ((64 - alignment) / 16) * 16;
    }

    file_buffer = reinterpret_cast<u_long128 *>(buffer_address);
    const auto arena_end = reinterpret_cast<std::uintptr_t>(read_memory->stack + read_memory->stack_size);
    const auto available = buffer_address < arena_end ? arena_end - buffer_address : 0;
    const auto file_destination = std::span<u8>(reinterpret_cast<u8 *>(file_buffer), available);
    SystemSND_ID = -1;

    char sy_path[] = "snd2/sy_000.sound.json";
    char rev_path[] = "snd2/rev.json";
    char map_index_path[] = "snd2/map_index.json";

    if (LoadFile2(sy_path, file_destination, nullptr, LOAD_FILE_READ)) {
        SystemSND_ID = sndLoadSound(SND_PORT_SYSTEM, reinterpret_cast<u_int *>(file_buffer), &SystemSeStack);
    }

    if (LoadFile2(rev_path, file_destination, &file_size, LOAD_FILE_READ)) {
        MainScene.LoadSndRevInfo(reinterpret_cast<char *>(file_buffer), file_size);
    }

    if (LoadFile2(map_index_path, file_destination, &file_size, LOAD_FILE_READ)) {
        MainScene.LoadSndFileInfo(reinterpret_cast<char *>(file_buffer), file_size);
    }

    LoadHelpMes();
    LoadMapName(LanguageCode, file_buffer);
    LoadEditAnalyzeData(LanguageCode, file_buffer);
    LoadFilePictureName();
    Font.Init();
    Font.Preset(FONT_PRESET_SHADOWED);
    Font.SetFuchi(0);
    Font.SetClearance(15, 18);
    CreateGamePadThread(&GamePad__2);
    LoadGameConfig(nullptr);
    SetIoErrCallBack(EmergencyMessage);
    if (!GameHasJump() && !PortSkipIntro()) {
        SCElogoFade(1, memory);
    }
    GamePrepareJump(PortLoopNo, InitArg);

    while (true) {
        if (PortLoopNo == LOOP_TITLE || OmakeFlag != 0) {
            if (PortSubGameSaveData == nullptr) {
                static_assert(std::is_trivially_destructible_v<CSubGameData>);
                static_assert(alignof(CSubGameData) <= alignof(u_long128));
                PortSubGameSaveData = std::construct_at(reinterpret_cast<CSubGameData *>(main_arena));
            }
            memory->stSetBuffer(&main_arena[kSubGameQuads], 0x1A0000 * kArenaHeadroom - kSubGameQuads);
            memory->stReset();
        }

        std::println("main_data remain = {}kb", ((memory->stack_size - memory->stack_used) * 16) / 1024);

        if (PortLoopNo < 0 || PortLoopNo >= LOOP_MODE_NUM) {
            break;
        }

        if (DebugFlag == 0 && PortLoopNo == LOOP_MENU) {
            PortLoopNo = LOOP_TITLE;
        }

        if (PortCaptureMode == CAPTURE_RECORD) {
            GamePad__2.CaptureStart();
            srand(9999);
        }

        if (PortCaptureMode == CAPTURE_PLAY || PortCaptureMode == CAPTURE_PLAY_SCREEN) {
            if (PortCaptureMode != CAPTURE_OFF) {
                GamePad__2.LoadCapture();
            }

            GamePad__2.CapturePlay();
            srand(9999);
        }

        mgFrameRate = 2;
        PortCaptureScreen = false;
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

        if (PortLoopNo == LOOP_TITLE) {
            sndSeAllStop(-1);
            sndDeletePort(SND_PORT_BGM);
            MainScene.InitSnd();
        }

        std::println("##### {}", mgGetVSyncCount());
        // Every mode change passes here, including the LOOP_MENU->LOOP_TITLE redirect above and the PortNextLoopNo hand-off below.
        mgPortCutInterpolation();
        PortCancelQuickChangeBanner();
        PortQuickLoadoutReset();
        ItemIcons3DReset();
        RecordCrashContext(PortLoopNo, InitArg);
        LoopInit[PortLoopNo](InitArg);
        GameGiveOnArrival(PortLoopNo);
        PortAutosaveResetArrival();
        // Presses made while the last mode ended and this one loaded belong to neither.
        DebugModeDiscardMenuKey();
        INIT_LOOP_ARG next_arg;

        NextLoop(LOOP_MENU, next_arg);

        bool developer_menu_requested = false;
        auto request_developer_menu = [&] {
            if (!GameDeveloperMenuRequested(PortLoopNo)) {
                return false;
            }
            developer_menu_requested = true;
            PauseEnd();
            PauseCancel();
            return true;
        };

        while (true) {
            request_developer_menu();
            if (developer_menu_requested) {
                DebugFlag = 1;
                GamePad__2.KeyLock(0);
                if (PortLoopNo == LOOP_EDIT) {
                    PreExitLoop(GetMainScene());
                } else if (PortLoopNo == LOOP_DUNGEON || PortLoopNo == LOOP_TITLE) {
                    // These loops own cleanup that their LoopExit callbacks do not perform.
                    const int buttons = GamePad__2.pad[0].button;
                    GamePad__2.pad[0].button = PAD_START | PAD_SELECT;
                    if (PortLoopNo == LOOP_DUNGEON) {
                        DngStatus.mode = DNG_STATUS_EXIT;
                    }
                    mgBeginFrame(nullptr);
                    LoopMain[PortLoopNo]();
                    mgEndFrame(nullptr);
                    GamePad__2.pad[0].button = buttons;
                }
                PauseCancel();
                INIT_LOOP_ARG menu_arg;
                NextLoop(LOOP_MENU, menu_arg);
                break;
            }
            if (GamePad__2.On(PAD_CIRCLE)) {
                cat_start();
            }

            if (PortLoopNo != LOOP_MENU) {
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

            if (GamePad__2.Down2(PAD_CIRCLE) ||
                (GameDebugEnabled() && DebugModeToggleChord(GamePad__2.GetPadOn(), GamePad__2.GetPadDown()))) {
                DebugFlag = !DebugFlag;
            }

            // Taken every tick, so a press made where the key does nothing is dropped rather than kept for later.
            if (DebugModeTakeMenuKey(mgPortFrameCount()) && GameDebugEnabled()) {
                DebugModeMenuKey(PortLoopNo);
            }

            GameDebugFrame(PortLoopNo);
            const int tick_frame = mgPortFrameCount();
            mgBeginFrame(nullptr);
            mode_finished = LoopMain[PortLoopNo]();
            PortFinishQuickChange();
            sndStep(mgGetNowFrameRate());
            MainScene.StepSnd();
            GamePad__2.UpDate();
            PortQuickLoadoutPad();
            PadCtrl.Update(&GamePad__2);
            PortStepQuickChangeEffect();
            PortDrawQuickChangeBanner();
            PortDrawFrameBorder();
            mgEndFrame(nullptr);
            DebugModeEndMenuKeyTick(tick_frame, mgPortFrameCount());

            if (mode_finished != 0) {
                PauseCancel();
                break;
            }
            PortAutosaveStep(PortLoopNo);
            GamePerfStep(PortLoopNo);

            if (GamePad__2.On(PAD_CIRCLE)) {
                cat_end();
            }

            switch (PortLoopNo) {
                case LOOP_EDIT:
                case LOOP_DUNGEON:
                case LOOP_TITLE: {
                    static int pause = false;

                    if (GameDebugPauseRequested(GamePad__2)) {
                        pause = true;
                    }
                    // The frame pause waits on sceGsSyncV, which ends no frame, so its presses are dropped here.
                    const bool frame_paused = pause != 0;

                    while (pause != 0) {
                        sceGsSyncV(0);
                        GamePad__2.UpDate();

                        // Modified Start is reserved for frame capture while paused.
                        if (!GamePad__2.On2(PAD_START) && request_developer_menu()) {
                            pause = false;
                            break;
                        }

                        if (GameDebugPauseResumeRequested(GamePad__2)) {
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
                    if (frame_paused) {
                        DebugModeDiscardMenuKey();
                    }

                    break;
                }
            }

            bool paused = false;
            while (!developer_menu_requested && PauseLoop() != 0) {
                paused = true;
                request_developer_menu();
            }
            if (paused) {
                DebugModeDiscardMenuKey();
            }

            PauseCount();
        }

        LoopExit[PortLoopNo]();
        MemoryLogPeaks();

        if (PortLoopNo != LOOP_MENU) {
            if (PortCaptureMode != CAPTURE_OFF) {
                GamePad__2.SaveCapture();
            }

            PortCaptureMode = CAPTURE_OFF;
        }

        PortPrevLoopNo = PortLoopNo;
        PrevInitArg = InitArg;
        PortLoopNo = PortNextLoopNo;
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
