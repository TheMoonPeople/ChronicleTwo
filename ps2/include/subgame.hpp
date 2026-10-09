#pragma once

#include "common.h"

/**
 * @file
 * Declares the sub game dispatcher, which starts, runs, draws and ends the mini-games played
 * inside a town or dungeon scene (fishing, the fish race and the buggy game), and the streamed
 * voice player those mini-games use.
 */

class CScene;
class mgCMemory;

/**
 *
 * Sub games the dispatcher can run, as passed to sgInitSubGame.
 *
 */
enum SUBGAME_TYPE {
    SUBGAME_NONE = 0,    /**< No sub game is running. */
    SUBGAME_FISHING = 1, /**< Fishing. */
    SUBGAME_GYORACE = 2, /**< The fish race. */
    SUBGAME_BUGGY = 3,   /**< The buggy game. */
    SUBGAME_UNUSED = 4,  /**< Accepted sub game with no handlers, which ends on its first frame. */
    SUBGAME_MAX = 5,
};

/**
 *
 * Steps of streaming one voice file, as sgCPlayVoice::step holds them.
 *
 */
enum SG_PLAY_VOICE_STEP {
    SG_PLAY_VOICE_IDLE = 0,    /**< No voice is open. */
    SG_PLAY_VOICE_OPEN = 1,    /**< A voice was chosen and its file is to be opened. */
    SG_PLAY_VOICE_OPENING = 2, /**< Waiting for the file to open before standing the stream by. */
    SG_PLAY_VOICE_STANDBY = 3, /**< Waiting for the stream to stand by. */
    SG_PLAY_VOICE_READY = 4,   /**< Ready, waiting for a play request. */
    SG_PLAY_VOICE_PLAYING = 5, /**< Playing until the stream stops. */
};

enum SUBGAME_CLEAR {
    SUBGAME_CHARA_BASE = 0x40,
    SUBGAME_CHARA_NUM = 0x28,
    SUBGAME_EFFECT_SLOT = 7,
};

/**
 *
 * Carries the scene and the mode-specific parameters into a sub game.
 *
 */
struct SubGameInfo {
    CScene    *scene;    /**< Scene in which the sub game runs. */
    int        texb;     /**< First texture block the sub game may load into, taken from the scene. */
    int        texb_num; /**< Number of texture blocks the sub game may use, taken from the scene. */
    int        unk_c;
    mgCMemory *menu_buff;    /**< Memory whose stack buffer fishing reuses for its reads, or NULL to use the scene's buffer. */
    int        dungeon;      /**< Non-zero when started from a dungeon, where the fishing motions load with the game data. */
    int        no_map_event; /**< Non-zero stops fishing from running map events where Max stands. */
    int        record_check; /**< Non-zero lets a landed fish set a fishing record. */
    int        rod_no;       /**< Item number of the fishing rod in use. */
    int        esa_no;       /**< Item number of the bait in use. */
    int        keep_bgm;     /**< Non-zero keeps the scene's BGM playing, as when fishing restarts with another rod. */
    mgCMemory *load_buff;    /**< Memory fishing loads its data into, or NULL to use a scene stack. */

    /**
     *
     * Clears the scene, the memory pointers and the mode flags.
     *
     */
    SubGameInfo() {
        keep_bgm = 0;
        dungeon = 0;
        scene = 0;
        menu_buff = 0;
        load_buff = 0;
        no_map_event = 0;
        record_check = 0;
    }
};

STATIC_ASSERT(sizeof(SubGameInfo) == 0x30);

/**
 *
 * Streams one numbered voice file through the sound stream, stepped once a frame.
 *
 */
class sgCPlayVoice {
public:
    int   step;    /**< Current SG_PLAY_VOICE_STEP. */
    int   file_no; /**< Number of the voice file, opened as "<file_no>.wav". */
    int   play;    /**< Non-zero once playing is requested. */
    float vol_r;   /**< Right stream volume, from 0 to 1. */
    float vol_l;   /**< Left stream volume, from 0 to 1. */

    /**
     *
     * Creates an idle player at full volume.
     *
     */
    sgCPlayVoice() {
        step = SG_PLAY_VOICE_IDLE;
        play = 0;
        vol_l = 1.0f;
        vol_r = 1.0f;
    }

    /**
     *
     * Chooses a voice file to stream, closing any voice still open, and
     * leaves it waiting for a play request.
     *
     * @mangled Open__12sgCPlayVoiceFi
     * @address 0x3097A0
     * @size 0x4C
     */
    void Open(int file_no);

    /**
     *
     * Sets the left and right volumes, each clamped to 0 to 1; a negative
     * right volume takes the left one.
     *
     * @mangled SetVol__12sgCPlayVoiceFff
     * @address 0x3097F0
     * @size 0x7C
     */
    void SetVol(float left, float right);

    /**
     *
     * Requests the opened voice to play once it is ready.
     *
     * @mangled Play__12sgCPlayVoiceFv
     * @address 0x309870
     * @size 0xC
     */
    void Play();

    /**
     *
     * Advances the voice through opening, standing by and playing, and
     * gives 0 once no voice is open or the voice has finished.
     *
     * @mangled Step__12sgCPlayVoiceFv
     * @address 0x309880
     * @size 0x134
     */
    int Step();

    /**
     *
     * Closes the stream if a voice is open and returns the player to idle.
     *
     * @mangled Close__12sgCPlayVoiceFv
     * @address 0x3099C0
     * @size 0x34
     */
    void Close();
};

STATIC_ASSERT(sizeof(sgCPlayVoice) == 0x14);

/**
 *
 * Ends any sub game and, when the scene has a main character, frees the
 * scene's sub game texture blocks, characters and effect.
 *
 * @mangled InitSubGame__FP6CScene
 * @address 0x308FC0
 * @size 0xB0
 */
void InitSubGame(CScene *scene);

/**
 *
 * Gives non-zero while a sub game is running.
 *
 * @mangled SubGameRunning__Fv
 * @address 0x309070
 * @size 0xC
 */
int SubGameRunning();

/**
 *
 * Gives the SUBGAME_TYPE of the running sub game.
 *
 * @mangled GetSubGameNo__Fv
 * @address 0x309080
 * @size 0x8
 */
int GetSubGameNo();

/**
 *
 * Gives the parameters of the running sub game.
 *
 * @mangled GetNowSubGameInfo__Fv
 * @address 0x309090
 * @size 0xC
 */
SubGameInfo *GetNowSubGameInfo();

/**
 *
 * Gives non-zero when the menu may be opened: always outside a sub game.
 *
 * @mangled sgMenuOpenEnable__Fv
 * @address 0x3090A0
 * @size 0x2C
 */
int sgMenuOpenEnable();

/**
 *
 * Sets whether the menu may be opened during the running sub game.
 *
 * @mangled sgSetMenuOpenEnableFlag__Fi
 * @address 0x3090D0
 * @size 0x8
 */
void sgSetMenuOpenEnableFlag(int value);

/**
 *
 * Gives non-zero when an item obtained in the sub game did not fit.
 *
 * @mangled sgGetItemOver__Fv
 * @address 0x3090E0
 * @size 0x8
 */
int sgGetItemOver();

/**
 *
 * Clears the flag of an item that did not fit.
 *
 * @mangled sgGetItemOverReset__Fv
 * @address 0x3090F0
 * @size 0x8
 */
void sgGetItemOverReset();

/**
 *
 * Raises the flag of an item that did not fit.
 *
 * @mangled sgGetItemOverFlagOn__Fv
 * @address 0x309100
 * @size 0xC
 */
void sgGetItemOverFlagOn();

/**
 *
 * Starts a sub game with a copy of the given parameters, taking the texture
 * blocks from the scene, and gives non-zero if it started.
 *
 * @mangled sgInitSubGame__FiP11SubGameInfo
 * @address 0x309110
 * @size 0x154
 */
int sgInitSubGame(int type, SubGameInfo *info);

/**
 *
 * Runs one frame of the running sub game, ending it when the sub game
 * reports that it has finished.
 *
 * @mangled sgLoopSubGame__Fv
 * @address 0x309270
 * @size 0xA8
 */
int sgLoopSubGame();

/**
 *
 * Runs the second per-frame pass of the running sub game.
 *
 * @mangled sgLoopSubGame2__Fv
 * @address 0x309320
 * @size 0x6C
 */
int sgLoopSubGame2();

/**
 *
 * Ends the running sub game normally.
 *
 * @mangled sgExitSubGame__Fv
 * @address 0x309390
 * @size 0x7C
 */
int sgExitSubGame();

/**
 *
 * Starts the running sub game again with new parameters.
 *
 * @mangled sgRestartSubGame__FP11SubGameInfo
 * @address 0x309410
 * @size 0x84
 */
int sgRestartSubGame(SubGameInfo *info);

/**
 *
 * Breaks off the running sub game.
 *
 * @mangled sgBreakSubGame__Fv
 * @address 0x3094A0
 * @size 0x7C
 */
int sgBreakSubGame();

/**
 *
 * Draws the running sub game's map layer.
 *
 * @mangled sgDrawSubGameMap__Fv
 * @address 0x309520
 * @size 0x4C
 */
int sgDrawSubGameMap();

/**
 *
 * Draws the running sub game's character shadows.
 *
 * @mangled sgDrawSubGameCharaShadow__Fv
 * @address 0x309570
 * @size 0x78
 */
int sgDrawSubGameCharaShadow();

/**
 *
 * Draws the running sub game's characters.
 *
 * @mangled sgDrawSubGameChara__Fv
 * @address 0x3095F0
 * @size 0x9C
 */
int sgDrawSubGameChara();

/**
 *
 * Draws the running sub game's effects.
 *
 * @mangled sgDrawSubGameEffect__Fv
 * @address 0x309690
 * @size 0x68
 */
int sgDrawSubGameEffect();

/**
 *
 * Draws the running sub game's 2D display.
 *
 * @mangled sgDrawSubGameSystem__Fv
 * @address 0x309700
 * @size 0x9C
 */
int sgDrawSubGameSystem();
