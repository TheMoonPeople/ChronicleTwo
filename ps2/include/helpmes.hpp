#pragma once

#include "common.h"

/**
 * @file
 * Declares the help message: the single message window that shows a line of
 * guidance from the help message file at the bottom of the screen, or an
 * error notice in a menu frame, for a set number of frames.
 */

/**
 *
 * Request for the help message window: which message to show, where, and for how long.
 *
 */
struct HELP_MES_INFO {
    s32 show;          /**< Non-zero while a help message is requested. */
    s32 created;       /**< Non-zero once the window has been set up for the requested message. */
    s32 time;          /**< Frames left before the request ends by itself; zero or less to keep it. */
    s32 mes_no;        /**< Message of the help message file to show; -1 for none. */
    s32 x;             /**< Screen x of the window's frame when fukidashi_pos is negative. */
    s32 y;             /**< Screen y of the window's frame when fukidashi_pos is negative. */
    s32 fukidashi_pos; /**< Screen slot the window is forced into; negative to place it at x and y. */
};

STATIC_ASSERT(sizeof(HELP_MES_INFO) == 0x1C);

/**
 *
 * Reads the help message file of the current language into a buffer and keeps a copy of it.
 *
 * @mangled LoadHelpMes__FP1
 * @address 0x31E310
 * @size 0x90
 */
void LoadHelpMes(u_long128 *buffer);


/**
 *
 * Resets the help message window and clears any request, once the help message file is loaded.
 *
 * @mangled CreateHelpMes__Fi
 * @address 0x31E3B0
 * @size 0x43C
 */
void CreateHelpMes(int tex_no);

/**
 *
 * Sets the window up for a new request, advances it, and ends the request when its time runs out.
 *
 * @mangled StepHelpMes__Fv
 * @address 0x31E7F0
 * @size 0x10C
 */
void StepHelpMes();

/**
 *
 * Keeps the help message window from being drawn on the next frame.
 *
 * @mangled ShowOffOnceHelpMes__Fv
 * @address 0x31E900
 * @size 0xC
 */
void ShowOffOnceHelpMes();

/**
 *
 * Draws the help message window while a help message is requested.
 *
 * @mangled DrawHelpMes__Fv
 * @address 0x31E910
 * @size 0x94
 */
void DrawHelpMes();

/**
 *
 * Requests a help message without a frame at the bottom left of the screen for a number of frames.
 *
 * @mangled ShowHelpMes__Fii
 * @address 0x31E9B0
 * @size 0x88
 */
void ShowHelpMes(int mes_no, int time);

/**
 *
 * Requests a help message in a menu frame as an error notice and plays the error sound.
 *
 * @mangled ShowErrorHelpMes__Fii
 * @address 0x31EA40
 * @size 0x8C
 */
void ShowErrorHelpMes(int mes_no, int time);
