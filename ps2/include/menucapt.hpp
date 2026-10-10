#pragma once

#include "common.h"

/**
 * @file
 * Declares the chapter title screen the main menu shows between chapters:
 * the chapter's background and logo pictures, the narration stream that
 * plays over them, and the fades in and out.
 */

class mgCMemory;

/**
 *
 * Stages of the chapter title screen, as MenuChapterMode holds them.
 *
 */
// clang-format off
enum MenuChapterModeID {
    MENU_CHAPTER_MODE_FADE_IN  = 0, /**< Screen fades in and the logo appears; the narration starts. */
    MENU_CHAPTER_MODE_SHOW     = 1, /**< Title shown while the narration and the sound effect play. */
    MENU_CHAPTER_MODE_FADE_OUT = 2, /**< Screen fades out; the title ends once the fade is done. */
};

// clang-format on

/**
 *
 * Working state of the chapter title screen, allocated from the chapter's memory stack.
 *
 */
struct MENU_CHAPTER_INFO {
    int   tex_block[2]; /**< Texture blocks the menu lends the screen; the chapter pictures go into the first. */
    u8    unk_8[0x10];
    int   show_cnt;   /**< Frames spent in MENU_CHAPTER_MODE_SHOW. */
    float logo_alpha; /**< Alpha the chapter logo is drawn with, raised to 128 while fading in. */
};

STATIC_ASSERT(sizeof(MENU_CHAPTER_INFO) == 0x20);

/**
 *
 * Opens the chapter title screen: loads the chapter's pictures, sound effect and narration stream, and begins the fade-in.
 *
 * @mangled MenuChapterInit__FP9mgCMemoryPiii
 * @address 0x2AEF10
 * @size 0x0x2D8
 */
void MenuChapterInit(mgCMemory *stack, int *tex_block, int open_type, int chapter);

/**
 *
 * Steps the chapter title screen by one frame; returns 1 once it has faded out and is finished.
 *
 * @mangled MenuChapterKey__Fv
 * @address 0x2AF1F0
 * @size 0x200
 */
int MenuChapterKey();

/**
 *
 * Draws the chapter title screen: its background and the chapter logo.
 *
 * @mangled MenuChapterDraw__Fv
 * @address 0x2AF3F0
 * @size 0x0x1B4
 */
void MenuChapterDraw();
