#pragma once

#include "common.h"

#include "mg_memory.hpp"

/**
 * @file
 * Declares the loading screen, which draws a progress bar from its own thread
 * while a town or dungeon loads, the pause screen, and the boot logo fade.
 */

class CScene;

/**
 *
 * Stages of the loading-screen thread, as its loop step holds them.
 *
 */
// clang-format off
enum NowLoadingStep {
    NOW_LOADING_STEP_NONE  = -1, /**< No loading screen has been created. */
    NOW_LOADING_STEP_START = 0,  /**< Thread created and about to start drawing. */
    NOW_LOADING_STEP_DRAW  = 1,  /**< Drawing the progress bar each frame. */
    NOW_LOADING_STEP_END   = 2,  /**< Bar full and ending requested; the thread only yields. */
};

// clang-format on

/**
 *
 * Settings a loop gives the loading screen: the texture block its image is
 * entered into, the memory the image is loaded into, and how many steps fill the bar.
 *
 */
struct NowLoadingInfo {
    int       tex_block; /**< Texture block the loading image is entered into, reloaded and deleted from. */
    int       unk_4;
    mgCMemory memory;     /**< Memory the loading image is read into and allocated from. */
    int       step_count; /**< Number of progress steps that fill the bar. */

    /**
     *
     * Creates settings with no texture block, an empty memory manager and no
     * progress steps.
     *
     * @mangled __ct__14NowLoadingInfoFv
     * @address 0x30ECB0
     * @size 0x40
     */
    NowLoadingInfo();
};

STATIC_ASSERT(sizeof(NowLoadingInfo) == 0x3C);

/**
 *
 * What a loop tells the pause screen when it pauses: whether the running event
 * can be skipped, and the scene whose music resumes afterwards.
 *
 */
struct PAUSE_INFO {
    int     event_skip; /**< Non-zero while a skippable event runs, offering the skip button. */
    CScene *scene;      /**< Scene whose background music is replayed when the pause ends. */
};

STATIC_ASSERT(sizeof(PAUSE_INFO) == 0x8);

/**
 *
 * Yields the processor to the next thread of the same priority, passing control
 * between the loading-screen thread and the loader.
 *
 * @mangled SwitchNowLoadingThread__Fv
 * @address 0x30E5C0
 * @size 0x10
 */
void SwitchNowLoadingThread();

/**
 *
 * Makes the next loading screen request be ignored instead of shown.
 *
 * @mangled CancelNowLoading__Fv
 * @address 0x30E960
 * @size 0x10
 */
void CancelNowLoading();

/**
 *
 * Loads the loading image for the current language and starts the thread that
 * draws the loading screen, unless the request was cancelled.
 *
 * @mangled CreateNowLoading__FP14NowLoadingInfo
 * @address 0x30E970
 * @size 0x210
 */
void CreateNowLoading(NowLoadingInfo *info);

/**
 *
 * Advances the loading screen's progress bar target by one step.
 *
 * @mangled NowLoadingBarStep__Fv
 * @address 0x30EB80
 * @size 0x80
 */
void NowLoadingBarStep();

/**
 *
 * Sends the loading screen's progress bar to full at a fixed speed.
 *
 * @mangled NowLoadingBarSteEnd__Fv
 * @address 0x30EC00
 * @size 0x20
 */
void NowLoadingBarSteEnd();

/**
 *
 * Waits for the progress bar to fill, then ends the loading-screen thread and
 * releases its texture block.
 *
 * @mangled DeleteNowLoading__Fv
 * @address 0x30EC20
 * @size 0x90
 */
void DeleteNowLoading();

/**
 *
 * Loads the language's skip-button image used by the pause screen, returning
 * non-zero when it loaded and fits.
 *
 * @mangled InitPauseData__Fv
 * @address 0x30ECF0
 * @size 0xD0
 */
int InitPauseData();

/**
 *
 * Resets the pause state and makes a texture block hold the pause screen's
 * frame capture and skip-button image, returning 1.
 *
 * @mangled InitPause__Fi
 * @address 0x30EDC0
 * @size 0xB0
 */
int InitPause(int tex_block);

/**
 *
 * Allows or forbids pausing, returning the previous setting.
 *
 * @mangled PauseEnable__Fi
 * @address 0x30EE70
 * @size 0x10
 */
int PauseEnable(int enable);

/**
 *
 * Reports whether the game is paused.
 *
 * @mangled GetPauseFlag__Fv
 * @address 0x30EE80
 * @size 0x10
 */
int GetPauseFlag();

/**
 *
 * Pauses the game when pausing is allowed and the last pause ended long enough
 * ago, returning non-zero when it paused.
 *
 * @mangled PauseStart__FP10PAUSE_INFO
 * @address 0x30EE90
 * @size 0x60
 */
int PauseStart(PAUSE_INFO *info);

/**
 *
 * Drops a pending pause without resuming its sound.
 *
 * @mangled PauseCancel__Fv
 * @address 0x30EEF0
 * @size 0x10
 */
void PauseCancel();

/**
 *
 * Ends the pause and resumes the music, streams, sequences, play-time count and
 * volume that the pause stopped.
 *
 * @mangled PauseEnd__Fv
 * @address 0x30EF00
 * @size 0xD0
 */
void PauseEnd();

/**
 *
 * Draws one frame of the pause screen and handles its buttons, returning
 * non-zero while the game stays paused.
 *
 * @mangled PauseLoop__Fv
 * @address 0x30EFD0
 * @size 0x4B0
 */
int PauseLoop();

/**
 *
 * Counts down the frames before the game may be paused again.
 *
 * @mangled PauseCount__Fv
 * @address 0x30F480
 * @size 0x30
 */
void PauseCount();

/**
 *
 * Fades the boot logo in after the title language is chosen, or fades it out,
 * setting up the graphics buffers from a memory manager.
 *
 * @mangled SCElogoFade__FiP9mgCMemory
 * @address 0x30F4B0
 * @size 0x3E0
 */
void SCElogoFade(int fade_out, mgCMemory *memory);
