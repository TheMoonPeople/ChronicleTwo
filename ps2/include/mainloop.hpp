#pragma once

#include "common.h"
#include "gamepad.hpp"
#include "sound.hpp"

/**
 * @file
 * Declares the game's top-level loop, which switches between the title,
 * the town editor, the dungeon and the debug modes, together with the
 * shared state it owns: the main scene, the save data, the controller,
 * the language, the debug menu settings and the pause menu.
 */

class CFont;
class CScene;
class CSaveData;
class CSubGameData;
class CPadControl;
class mgCMemory;
class mgCTexture;


/**
 * Modes the main loop can run, as LoopNo holds them and as they index
 * LoopInit, LoopMain and LoopExit.
 */
// clang-format off
enum MainLoopMode {
    LOOP_MENU          = 0,  /**< Debug start menu. */
    LOOP_EDIT          = 1,  /**< Town and georama editing. */
    LOOP_DUNGEON       = 2,  /**< Dungeon exploration. */
    LOOP_TITLE         = 3,  /**< Title screen, the mode the game boots into. */
    LOOP_CHARA_VIEWER  = 4,  /**< Debug character viewer. */
    LOOP_TEX_VIEWER    = 5,  /**< Debug texture viewer. */
    LOOP_MAP_VIEW      = 6,  /**< Debug map viewer. */
    LOOP_SOUND_VIEWER  = 7,  /**< Debug sound viewer. */
    LOOP_MOVIE_VIEW    = 8,  /**< Debug movie viewer. */
    LOOP_SV_CONV_VIEW  = 9,  /**< Save data conversion screen. */
    LOOP_MODE_NUM      = 10, /**< Number of modes; any other LoopNo ends the game. */
};

// clang-format on
/**
 * Languages the game can run in, as LanguageCode holds them.
 */
// clang-format off
enum LanguageCodeNo {
    LANG_JAPANESE = 0, /**< Japanese. */
    LANG_ENGLISH  = 1, /**< English. */
    LANG_FRENCH   = 2, /**< French, the language the game starts in. */
    LANG_GERMAN   = 3, /**< German. */
    LANG_ITALIAN  = 4, /**< Italian. */
    LANG_SPANISH  = 5, /**< Spanish, the last language the debug menu offers. */
    LANG_CHINESE  = 6, /**< Chinese, named by the debug menu only. */
    LANG_KOREAN   = 7, /**< Korean, named by the debug menu only. */
};

// clang-format on
/**
 * Controller input recording modes, as CaptureMode holds them.
 */
// clang-format off
enum MainCaptureMode {
    CAPTURE_OFF         = 0, /**< Input is neither recorded nor replayed. */
    CAPTURE_RECORD      = 1, /**< Input is recorded while the mode runs. */
    CAPTURE_PLAY        = 2, /**< The recorded input is replayed. */
    CAPTURE_PLAY_SCREEN = 3, /**< The recorded input is replayed and the screen is captured. */
    CAPTURE_MODE_NUM    = 4, /**< Number of modes the debug menu cycles through. */
};

// clang-format on
/**
 * Screens of the debug start menu, as menu_mode holds them.
 */
// clang-format off
enum DebugMenuMode {
    DEBUG_MENU_TOP            = 0, /**< List of modes and debug settings. */
    DEBUG_MENU_MAP_SELECT     = 1, /**< Map selection. */
    DEBUG_MENU_EVENT_SELECT   = 2, /**< Chapter, event and extra selection, the only screen without DebugFlag. */
    DEBUG_MENU_SAVE_DATA_EDIT = 3, /**< Save data editor. */
};

// clang-format on
/**
 * Steps of the pause menu, as PauseMenuMode holds them.
 */
// clang-format off
enum PauseMenuStep {
    PAUSE_MENU_OPEN     = 0, /**< Opening; becomes PAUSE_MENU_SELECT on the next frame. */
    PAUSE_MENU_SELECT   = 1, /**< Choosing between continuing and quitting. */
    PAUSE_MENU_FADE_OUT = 2, /**< Fading the screen to black after quitting was chosen. */
    PAUSE_MENU_END      = 3, /**< Faded out; the mode is to be left. */
};

// clang-format on
/**
 * Results of PauseMenu.
 */
// clang-format off
enum PauseMenuResult {
    PAUSE_MENU_STAY   = 0, /**< The pause menu stays open. */
    PAUSE_MENU_RESUME = 1, /**< The pause menu closes and play resumes. */
    PAUSE_MENU_QUIT   = 2, /**< The current mode is to be left. */
};

// clang-format on
/**
 * Value MasterDebugCode takes when the four shoulder buttons are held at boot.
 */
// clang-format off
enum MasterDebugCodeValue {
    MASTER_DEBUG_CODE = 0x5D44, /**< Unlocks the debug options of the title screen. */
};

// clang-format on
/**
 *
 * Parameters that the main loop hands to a mode when it enters it.
 *
 */
struct INIT_LOOP_ARG {
    int map_no;       /**< Map or dungeon the mode starts in, or -1 for none. */
    int selected_map_no;
    u8 unk_8[0x3C];
    int floor_no;     /**< Dungeon floor to start on, or -1 for the saved one. */
    int event_no;     /**< Event to run on entry, or -1 for none. */
    int unk_4c;
};
STATIC_ASSERT(sizeof(INIT_LOOP_ARG) == 0x50);

/**
 *
 * Debug switches that the debug menus of the editor and the dungeon change.
 *
 */
struct DEBUG_INFO {
    int debug_camera;  /**< Non-zero to move the camera freely. */
    int chara_move;    /**< Debug character movement level, from 0 to 2. */
    int georama_debug; /**< Non-zero to lift the georama placement conditions. */
    int param_off;     /**< Non-zero to hide the parameter display. */
    int invent_debug;  /**< 1 to show the invention debug display. */
};
STATIC_ASSERT(sizeof(DEBUG_INFO) == 0x14);

/**
 *
 * One row of the logical button table that InitPadTable registers with CPadControl.
 *
 */
struct PAD_TABLE_ENTRY {
    int no;      /**< Logical button number, or -1 to end the table. */
    int trigger; /**< 0 to report while held, 0x10000 when pressed, 0x20000 when released. */
    int button;  /**< Controller buttons the logical button reads. @see PadButton */
};
STATIC_ASSERT(sizeof(PAD_TABLE_ENTRY) == 0xC);

/**
 *
 * One row of the logical stick axis table that InitPadTable registers with CPadControl.
 *
 */
struct ANALOG_TABLE_ENTRY {
    int no;   /**< Logical axis number, or -1 to end the table. */
    int axis; /**< Stick axis read: 1 left X, 2 left Y, 3 right X, 4 right Y. */
};
STATIC_ASSERT(sizeof(ANALOG_TABLE_ENTRY) == 0x8);

/**
 * Prepares a main loop mode when the main loop enters it.
 */
typedef void (*LOOP_INIT_FUNC)(INIT_LOOP_ARG arg);

/**
 * Runs one frame of a main loop mode, returning non-zero to leave it.
 */
typedef int (*LOOP_MAIN_FUNC)();

/**
 * Releases a main loop mode when the main loop leaves it.
 */
typedef void (*LOOP_EXIT_FUNC)();

/**
 * Entry function of each main loop mode. @see MainLoopMode
 */
extern LOOP_INIT_FUNC LoopInit[LOOP_MODE_NUM];

/**
 * Per-frame function of each main loop mode. @see MainLoopMode
 */
extern LOOP_MAIN_FUNC LoopMain[LOOP_MODE_NUM];

/**
 * Exit function of each main loop mode. @see MainLoopMode
 */
extern LOOP_EXIT_FUNC LoopExit[LOOP_MODE_NUM];

/**
 * Priority the main thread runs at.
 */
extern int MainThreadPriority;

/**
 * Scratch buffer that the running mode reads files into.
 */
extern u_long128 *read_buffer;

/**
 * Sound bank number of the system sound effects, or -1 when they failed to load.
 */
extern u32 SystemSND_ID;

/**
 * Sound controller shared by the game loops and chapter menu.
 */
extern CSound CSnd;

/**
 * Non-zero while the debug features are on.
 */
extern int DebugFlag;

/**
 * Event that the debug menu starts maps with, set by the START_EVENT tag of game.cfg.
 */
extern int DefStartEventNo;

/**
 * Language the game runs in. @see LanguageCodeNo
 */
extern int LanguageCode;

/**
 * Non-zero while an extra (omake) mode of the title screen is being played.
 */
extern int OmakeFlag;

/**
 * Debug unlock code entered at boot. @see MasterDebugCodeValue
 */
extern int MasterDebugCode;

/**
 * Controller the whole game reads.
 */
extern CGamePad GamePad;

/** Controller instance used by the game's main loop and pause screen. */
extern CGamePad GamePad__2;

/**
 * Logical button and stick table built over GamePad__2.
 */
extern CPadControl PadCtrl;

/**
 * Debug switches shared by the editor and the dungeon.
 */
extern DEBUG_INFO DebugInfo;

/**
 * Returns the font the debug menus draw with.
 *
 * @mangled GetDebugFont__Fv
 * @address 0x191DF0
 * @size 0x10
 */
CFont *GetDebugFont();

/**
 * Returns the controller input recording mode. @see MainCaptureMode
 *
 * @mangled GetCaptureMode__Fv
 * @address 0x191E00
 * @size 0x10
 */
int GetCaptureMode();

/**
 * Returns the sound bank number of the system sound effects.
 *
 * @mangled GetSystemSndID__Fv
 * @address 0x191E10
 * @size 0x10
 */
int GetSystemSndID();

/**
 * Returns the scene every mode draws and plays sound through.
 *
 * @mangled GetMainScene__Fv
 * @address 0x191E20
 * @size 0x10
 */
CScene *GetMainScene();

/**
 * Returns the save data the game is played with.
 *
 * @mangled GetSaveData__Fv
 * @address 0x191E30
 * @size 0x10
 */
CSaveData *GetSaveData();

/**
 * Returns the save data of the extra mini-games, or null when none is set up.
 *
 * @mangled GetSubGameSaveData__Fv
 * @address 0x191E40
 * @size 0x10
 */
CSubGameData *GetSubGameSaveData();

/**
 * Resets the save data to the state of a new game.
 *
 * @mangled InitSaveData__Fv
 * @address 0x191E50
 * @size 0x30
 */
void InitSaveData();

/**
 * Returns the VRAM address textures are placed from, 0x20 past the top address mglib reports.
 *
 * @mangled GetVramTopAddress__Fv
 * @address 0x191E80
 * @size 0x20
 */
int GetVramTopAddress();

/**
 * Returns the memory stack the modes allocate their working memory from.
 *
 * @mangled GetMainStack__Fv
 * @address 0x191EA0
 * @size 0x10
 */
mgCMemory *GetMainStack();

/**
 * Selects the mode the main loop switches to when the current one ends,
 * and the parameters it is entered with.
 *
 * @mangled NextLoop__Fi13INIT_LOOP_ARG
 * @address 0x191EB0
 * @size 0xA0
 */
void NextLoop(int loop_no, INIT_LOOP_ARG arg);

/**
 * Returns the mode the main loop is running. @see MainLoopMode
 *
 * @mangled GetNowLoopNo__Fv
 * @address 0x191F50
 * @size 0x10
 */
int GetNowLoopNo();

/**
 * Returns the parameters the running mode was entered with.
 *
 * @mangled GetNowInitArg__Fv
 * @address 0x191F60
 * @size 0x10
 */
INIT_LOOP_ARG *GetNowInitArg();

/**
 * Marks the start of a frame for an external profiler; empty in the retail build.
 *
 * @mangled cat_start__Fv
 * @address 0x191F70
 * @size 0x10
 */
void cat_start();

/**
 * Marks the end of a frame for an external profiler; empty in the retail build.
 *
 * @mangled cat_end__Fv
 * @address 0x191F80
 * @size 0x10
 */
void cat_end();

/**
 * Sizes the texture manager's tables from a memory manager and resets it
 * to place textures from the top of free VRAM.
 *
 * @mangled SetTextureTable__FiiP9mgCMemory
 * @address 0x191F90
 * @size 0x50
 */
void SetTextureTable(int block_max, int texture_max, mgCMemory *memory);

/**
 * Turns counting of the play time on or off.
 *
 * @mangled PlayTimeCount__Fi
 * @address 0x192190
 * @size 0x10
 */
void PlayTimeCount(int enable);

/**
 * Returns non-zero while the play time is being counted.
 *
 * @mangled GetPlayTimeCountFlag__Fv
 * @address 0x1921A0
 * @size 0x10
 */
int GetPlayTimeCountFlag();

/**
 * Switches the game to another language, reloading every message, name
 * and font that depends on it. @see LanguageCodeNo
 *
 * @mangled LanguageChange__FiP1
 * @address 0x1921B0
 * @size 0xC0
 */
void LanguageChange(int language, u_long128 *buffer);

/**
 * Sets up the hardware, the game data and the system sounds, then runs
 * one mode after another until a mode selects a number past the last mode.
 *
 * @mangled MainLoop__Fv
 * @address 0x192270
 * @size 0xCC0
 */
void MainLoop();

/**
 * Returns the font texture with the given index, or null when the index is out of range.
 *
 * @mangled GetFontTexture__Fi
 * @address 0x194210
 * @size 0x30
 */
mgCTexture *GetFontTexture(int index);

/**
 * Loads the font texture image of the current language into the font buffer.
 *
 * @mangled LoadFontTexture__Fv
 * @address 0x194240
 * @size 0x170
 */
void LoadFontTexture();

/**
 * Enters the loaded font texture image into a block of the texture manager.
 *
 * @mangled ReLoadFontTexture__Fi
 * @address 0x1943B0
 * @size 0x110
 */
void ReLoadFontTexture(int block);

/**
 * Ends a kiosk demo when asked to quit; empty in the retail build.
 *
 * @mangled demQuit__Fv
 * @address 0x1944C0
 * @size 0x10
 */
void demQuit();

/**
 * Ends a kiosk demo when its time runs out; empty in the retail build.
 *
 * @mangled demoQuitTimeOut__Fv
 * @address 0x1944D0
 * @size 0x10
 */
void demoQuitTimeOut();

/**
 * Reports a kiosk demo attract sequence interrupted by the player; empty in the retail build.
 *
 * @mangled demoAttractInterrupted__Fv
 * @address 0x1944E0
 * @size 0x10
 */
void demoAttractInterrupted();

/**
 * Reports a kiosk demo attract sequence played to its end; empty in the retail build.
 *
 * @mangled demoAttractComplete__Fv
 * @address 0x1944F0
 * @size 0x10
 */
void demoAttractComplete();

/**
 * Fades out the E3 show demo when its time runs out; empty in the retail build.
 *
 * @mangled FadeOutForE3__Fv
 * @address 0x194500
 * @size 0x10
 */
void FadeOutForE3();

/**
 * Returns non-zero when the time limit of a show demo has run out; always 0 in the retail build.
 *
 * @mangled TimeLimitCheck__Fv
 * @address 0x194510
 * @size 0x10
 */
int TimeLimitCheck();

/**
 * Resets the pause menu's message window and state so that it opens afresh.
 *
 * @mangled InitPauseMenu__Fi
 * @address 0x194520
 * @size 0x400
 */
void InitPauseMenu(int value);

/**
 * Runs and draws one frame of the pause menu. @see PauseMenuResult
 *
 * @mangled PauseMenu__Fv
 * @address 0x194920
 * @size 0x2B0
 */
int PauseMenu();

/**
 * Runs a debug configuration script, game.cfg from the root directory when
 * no file is named, whose tags set up the save data and the debug settings.
 *
 * @mangled LoadGameConfig__FPc
 * @address 0x194BD0
 * @size 0xB0
 */
void LoadGameConfig(char *file_name);
