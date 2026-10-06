#pragma once

#include "common.h"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include <cstring>

/**
 * @file
 * Declares the title main loop mode: the attract movie, the title screen and
 * its menu, the memory card check, the copyright and logo display, the hard
 * disk installer and the boot-time language selection.
 */

struct INIT_LOOP_ARG;

/**
 * Screens of the title mode, as TITLE_INFO::mode and TITLE_INFO::next_mode
 * hold them.
 */
// clang-format off
enum TitleMode {
    TITLE_MODE_NONE         = -1, /**< No screen change is pending; only held by next_mode. */
    TITLE_MODE_RUSH_MOVIE   = 0,  /**< Attract movie. */
    TITLE_MODE_TITLE        = 1,  /**< Title screen and its menu. */
    TITLE_MODE_MENU         = 2,  /**< Main menu opened from the title menu. */
    TITLE_MODE_MC_CHECK     = 3,  /**< Memory card check at boot. */
    TITLE_MODE_COPYRIGHT    = 4,  /**< Copyright and logo movie display. */
    TITLE_MODE_HDD_INSTALL  = 5,  /**< Hard disk installer. */
    TITLE_MODE_TITLE_RETURN = 6,  /**< Return to the title screen keeping the menu cursor; only held by next_mode. */
    TITLE_MODE_SUBGAME_MENU = 7,  /**< Mini-game save menu opened from the extras menu. */
    TITLE_MODE_LANG_SELECT  = 8,  /**< Language selection. */
};
// clang-format on

/**
 * Steps of the title screen, as TitlePhase holds them.
 */
// clang-format off
enum TitlePhaseNo {
    TITLE_PHASE_WAIT          = -2, /**< Waiting before the title fades in. */
    TITLE_PHASE_FADE_IN       = -1, /**< Fading the title in. */
    TITLE_PHASE_PUSH_START    = 0,  /**< Waiting for START. */
    TITLE_PHASE_MENU          = 1,  /**< Choosing from the title menu. */
    TITLE_PHASE_NEW_GAME      = 2,  /**< Fading out to start a new game. */
    TITLE_PHASE_CONTINUE      = 3,  /**< Fading out to the load menu. */
    TITLE_PHASE_OPTION        = 4,  /**< Fading out to the option menu. */
    TITLE_PHASE_HDD_INSTALL   = 5,  /**< Fading out to the hard disk installer. */
    TITLE_PHASE_UNUSED_6      = 6,  /**< Tested alongside the fade-out steps but never entered. */
    TITLE_PHASE_OMAKE_MENU    = 10, /**< Choosing from the extras menu. */
    TITLE_PHASE_OMAKE         = 11, /**< Fading out to the mini-game save menu. */
    TITLE_PHASE_MC_MESSAGE    = 20, /**< Showing a memory card message; tested but never entered. */
};
// clang-format on

/**
 * Rows of the title menu, as TITLE_INFO::select holds them.
 */
// clang-format off
enum TitleMenuItem {
    TITLE_MENU_NEW_GAME    = 0, /**< Starts a new game. */
    TITLE_MENU_CONTINUE    = 1, /**< Loads a saved game. */
    TITLE_MENU_OMAKE       = 2, /**< Extras, enabled by OmakePlayEnableAttr. */
    TITLE_MENU_OPTION      = 3, /**< Option menu. */
    TITLE_MENU_HDD_INSTALL = 4, /**< Hard disk installer, offered only when TitleHDDCheckFlag is set. */
};
// clang-format on

/**
 * Results of TitleModeKey and RushMovieKey, which TitleLoop acts on.
 */
// clang-format off
enum TitleKeyResult {
    TITLE_KEY_NONE          = 0,    /**< Nothing to do. */
    TITLE_KEY_START_GAME    = 1,    /**< Leave the attract movie for the title screen, or start a new game. */
    TITLE_KEY_RUSH_MOVIE    = 2,    /**< Play the attract movie, or end the title after an attract-only boot. */
    TITLE_KEY_CONTINUE      = 3,    /**< Open the load menu. */
    TITLE_KEY_OPTION        = 4,    /**< Open the option menu. */
    TITLE_KEY_NEW_GAME      = 5,    /**< Open the costume menu on fresh save data for a new game. */
    TITLE_KEY_HDD_INSTALL   = 6,    /**< Open the hard disk installer. */
    TITLE_KEY_DEMO_QUIT     = 10,   /**< End the title for a demo disc quit request. */
    TITLE_KEY_DEMO_TIMEOUT  = 11,   /**< End the title for a demo disc time-out. */
    TITLE_KEY_OMAKE         = 1000, /**< Open the mini-game save menu. */
};
// clang-format on

/**
 * Steps of the attract movie, as RUSH_INFO::phase holds them.
 */
// clang-format off
enum RushPhase {
    RUSH_PHASE_INIT     = 0, /**< Loading and starting the movie. */
    RUSH_PHASE_PLAY     = 1, /**< Playing. */
    RUSH_PHASE_FADE_OUT = 2, /**< Fading out after the movie ended or was skipped. */
    RUSH_PHASE_END      = 3, /**< Ended; the movie is released on the next draw. */
};
// clang-format on

/**
 * Steps of the copyright and logo display, as TitleCopyRightDispPhase
 * holds them; the negative steps show the trial disc message.
 */
// clang-format off
enum CopyRightPhase {
    COPYRIGHT_PHASE_DELAY          = -10, /**< Waiting before the copyright fades in. */
    COPYRIGHT_PHASE_TRIAL_WAIT     = -3,  /**< Waiting for the running fade to end before the trial disc message. */
    COPYRIGHT_PHASE_TRIAL_SHOW     = -2,  /**< Showing the trial disc message. */
    COPYRIGHT_PHASE_TRIAL_FADE_OUT = -1,  /**< Fading the trial disc message out. */
    COPYRIGHT_PHASE_FADE_IN        = 0,   /**< Fading the copyright in. */
    COPYRIGHT_PHASE_SHOW           = 1,   /**< Showing the copyright. */
    COPYRIGHT_PHASE_FADE_OUT       = 2,   /**< Fading the copyright out. */
    COPYRIGHT_PHASE_MOVIE_LOAD     = 3,   /**< Starting the logo movie. */
    COPYRIGHT_PHASE_MOVIE          = 4,   /**< Playing the logo movie. */
    COPYRIGHT_PHASE_MOVIE_END      = 5,   /**< Releasing the logo movie. */
    COPYRIGHT_PHASE_END            = 6,   /**< Finished. */
};
// clang-format on

/**
 * Steps of the hard disk installer, as HDDPhase holds them.
 */
// clang-format off
enum HddInstallPhase {
    HDD_PHASE_FADE_IN       = 0,  /**< Fading the installer in. */
    HDD_PHASE_EXIT          = 1,  /**< Fading out to the title screen. */
    HDD_PHASE_SELECT        = 2,  /**< Choosing whether to install. */
    HDD_PHASE_CONFIRM       = 3,  /**< Answering a yes or no question. */
    HDD_PHASE_INSTALL       = 4,  /**< Installing. */
    HDD_PHASE_RESULT        = 5,  /**< Showing the result of the installation. */
    HDD_PHASE_CANCEL_ASK    = 6,  /**< Asking whether to cancel the installation. */
    HDD_PHASE_CANCEL        = 7,  /**< Waiting for the installation to stop. */
    HDD_PHASE_CANCELLED     = 8,  /**< Showing that the installation was cancelled. */
    HDD_PHASE_IMAGE_FADE    = 9,  /**< Fading out the illustrations shown during the installation. */
    HDD_PHASE_ERROR         = 10, /**< Showing why installation is not possible. */
};
// clang-format on

/**
 * Questions the hard disk installer asks in HDD_PHASE_CONFIRM, as
 * HDDConfirmType holds them.
 */
// clang-format off
enum HddConfirmType {
    HDD_CONFIRM_INSTALL = 0, /**< Whether to install. */
    HDD_CONFIRM_EXIT    = 1, /**< Whether to leave the installer. */
};
// clang-format on

/**
 * Steps of the memory card check, as TitleMCCheckPhase holds them; steps
 * 0 to 2 check the card in port 1 and steps 3 to 5 the card in port 2.
 */
// clang-format off
enum TitleMcCheckPhase {
    TITLE_MC_PHASE_CARD_1  = 0, /**< Checking that a card is in port 1. */
    TITLE_MC_PHASE_FILES_1 = 1, /**< Counting the save files and extras on the card in port 1. */
    TITLE_MC_PHASE_OMAKE_1 = 2, /**< Reading the mini-game data on the card in port 1. */
    TITLE_MC_PHASE_CARD_2  = 3, /**< Checking that a card is in port 2. */
    TITLE_MC_PHASE_FILES_2 = 4, /**< Counting the save files and extras on the card in port 2. */
    TITLE_MC_PHASE_OMAKE_2 = 5, /**< Reading the mini-game data on the card in port 2. */
    TITLE_MC_PHASE_END     = 6, /**< Both cards checked; showing a message if one is needed. */
};
// clang-format on

/**
 * Steps of the title screen's background camera, as TitleCameraPhase holds
 * them.
 */
// clang-format off
enum TitleCameraPhaseNo {
    TITLE_CAMERA_APPROACH = 0, /**< Moving in and rising. */
    TITLE_CAMERA_HOLD     = 1, /**< Holding still. */
    TITLE_CAMERA_ORBIT    = 2, /**< Turning once around the scene. */
};
// clang-format on

/**
 * Steps of the language selection, as title_lang_phase holds them.
 */
// clang-format off
enum TitleLangPhase {
    TITLE_LANG_FADE_IN  = 0, /**< Fading the screen in. */
    TITLE_LANG_SELECT   = 1, /**< Choosing a language. */
    TITLE_LANG_FADE_OUT = 2, /**< Fading the screen out. */
};
// clang-format on

/**
 * Extras that InitOmakeEnv prepares.
 */
// clang-format off
enum OmakeType {
    OMAKE_TYPE_DUNGEON = 0, /**< Extra played in the dungeon mode, starting with event 6000. */
    OMAKE_TYPE_GYORACE = 1, /**< Fish race extra played in the town mode. */
};
// clang-format on

/**
 * Bits of OmakePlayEnableAttr, gathered from the memory cards.
 */
// clang-format off
enum OmakePlayEnableBit {
    OMAKE_ENABLE_GYORACE = 0x01, /**< The fish race extra may be played. */
    OMAKE_ENABLE_DUNGEON = 0x02, /**< The dungeon extra may be played. */
    OMAKE_ENABLE_COSTUME = 0x80, /**< A new game is given the costumes in CostumeOptionEnv. */
};
// clang-format on

/**
 *
 * State of the title mode that TitleInit allocates, shared by the title
 * screen, its menus and the screens it switches between.
 *
 */
struct TITLE_INFO {
    TITLE_INFO() {
        memset(this, 0, sizeof(TITLE_INFO));
        InitSV_CONFIG_OPTION(&config);
    }
    int mode;                        /**< Screen being shown. @see TitleMode */
    int next_mode;                   /**< Screen to switch to at the end of the frame, or TITLE_MODE_NONE. @see TitleMode */
    s16 select;                      /**< Row chosen in the title menu. @see TitleMenuItem */
    s16 omake_select;                /**< Row chosen in the extras menu. */
    s16 omake_dungeon;               /**< Non-zero when the extras menu lists the dungeon extra. */
    s16 omake_gyorace;               /**< Non-zero when the extras menu lists the fish race extra. */
    s16 omake_num;                   /**< Number of rows in the extras menu. */
    s16 unk_12;
    float push_alpha;                /**< Alpha of the PUSH START prompt, pulsed by CalcPushAlpha. */
    int wait_count;                  /**< Frames left in TITLE_PHASE_WAIT. */
    float title_alpha;               /**< Alpha of the title picture and the PUSH START prompt. */
    float menu_alpha;                /**< Alpha of the title menu rows. */
    float omake_alpha;               /**< Alpha of the extras menu rows. */
    float cursor_alpha;              /**< Alpha of the menu cursor. */
    int cursor_count;                /**< Frame counter driving the cursor's wobble. */
    float cursor_x;                  /**< Horizontal position of the menu cursor. */
    float cursor_y;                  /**< Vertical position of the menu cursor, eased towards the chosen row. */
    int idle_count;                  /**< Frames without input on the title screen, compared with TitleRushWaitCount. */
    u8 unk_3c[0xC];
    SV_CONFIG_OPTION config;         /**< Game options, exchanged with the save data around the menus. */
    mgCMemory chara_stack[5];        /**< Memory for the party characters' base data while a menu is open. */
    CScene::BGM_STATUS bgm_status;   /**< Background music that was playing before a menu or the installer changed it. */
};
STATIC_ASSERT(sizeof(TITLE_INFO) == 0x194);

/**
 *
 * State of the attract movie.
 *
 */
struct RUSH_INFO {
    int phase;        /**< Step of the movie. @see RushPhase */
    s16 count;        /**< Frames since the movie started. */
    s16 movie_no;     /**< Movie number handed to InitRushMovie. */
    float push_alpha; /**< Alpha of the PUSH START prompt over the movie. */
    int unk_c;
    int unk_10;
    s8 skipped;       /**< Non-zero when the player skipped the movie. */
};
STATIC_ASSERT(sizeof(RUSH_INFO) == 0x18);

/**
 *
 * State of the hard disk and of the installation, as the installer and
 * the title menu see it.
 *
 */
struct HDD_INFO {
    HDD_INFO() : connect(0), app_install(0), install_space(0) {}
    int connect;       /**< Result of HddConectCheck: positive when a hard disk is usable, zero when there is none. */
    int hdd_state;     /**< State HddConectCheck reports through its argument. */
    int app_install;   /**< Result of CheckAppInstallForTitle: positive when the game is installed, negative on error. */
    int install_space; /**< Result of CheckInstallSpace: positive when there is room to install, negative on error. */
    int unk_10;
    int installing;    /**< Non-zero once the installation thread has been started. */
    int result;        /**< Last result of StepInstallThread once the installation stopped. */
    int progress;      /**< Installation progress in percent. */
    void *work;        /**< Work buffer handed to CreateInstallThread. */
};
STATIC_ASSERT(sizeof(HDD_INFO) == 0x24);

/**
 * Returns whether an extra was started from the title screen since the
 * title mode was last entered.
 *
 * @mangled CheckOmakeFlag__Fv
 * @address 0x2A2F20
 * @size 0x10
 */
int CheckOmakeFlag();

/**
 * Sets up the save data and the main loop arguments for an extra, and
 * gives the main loop mode the extra runs in.
 *
 * @mangled InitOmakeEnv__FiP13INIT_LOOP_ARGPi
 * @address 0x2A2F30
 * @size 0xE0
 */
void InitOmakeEnv(int type, INIT_LOOP_ARG *arg, int *loop_no);

/**
 * Prepares the title mode when the main loop enters it: render and memory
 * setup, the title state, and the first screen to show.
 *
 * @mangled TitleInit__F13INIT_LOOP_ARG
 * @address 0x2A3010
 * @size 0x320
 */
void TitleInit(INIT_LOOP_ARG arg);

/**
 * Releases the title mode when the main loop leaves it, recording whether
 * an extra was started.
 *
 * @mangled TitleExit__Fv
 * @address 0x2A3DC0
 * @size 0x70
 */
void TitleExit();

/**
 * Runs and draws one frame of the title mode, and returns non-zero once
 * the main loop is to leave it.
 *
 * @mangled TitleLoop__Fv
 * @address 0x2A3E30
 * @size 0xB90
 */
int TitleLoop();

/**
 * Loads the language selection screen into the given memory and resets its
 * state.
 *
 * @mangled TitleLangSelInit__FP9mgCMemory
 * @address 0x2A8DA0
 * @size 0x100
 */
void TitleLangSelInit(mgCMemory *stack);

/**
 * Runs one frame of the language selection, and returns the chosen
 * language once it has faded out, or 0 before then. @see LanguageCodeNo
 *
 * @mangled TitleLangSelKey__Fv
 * @address 0x2A8EA0
 * @size 0x150
 */
int TitleLangSelKey();

/**
 * Draws the language selection: the language rows, the cursor and the
 * fade.
 *
 * @mangled TitleLangSelDraw__Fv
 * @address 0x2A9000
 * @size 0x270
 */
void TitleLangSelDraw();

/**
 * Title menu row chosen on entering the title screen; set to
 * TITLE_MENU_CONTINUE when a memory card holds a save file.
 */
extern int TitleSelectInit;

/**
 * Non-zero when a memory card checked at boot holds the debug code.
 */
extern u8 MasterDebugModeOn;

/**
 * Costume bits that the memory cards unlock for a new game.
 */
extern u_long CostumeOptionEnv;
