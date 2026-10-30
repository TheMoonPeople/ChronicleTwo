#pragma once

/**
 * Unlocks retail debug controls when the configured debug mode is enabled.
 */
void DebugModeBoot(bool debug_mode);

/**
 * Detects a new pad-one R3 press with all four shoulders held and the debug code unlocked.
 */
bool DebugModeToggleChord(int pad1_held, int pad1_pressed);

/**
 * Returns the current mode's debug-menu buttons when gameplay or its debug menu can receive them.
 */
int DebugModeMenuButtons(int loop);

/**
 * Enables the debug flag and delivers a fresh debug-menu button press to an eligible mode.
 */
bool DebugModeMenuKey(int loop);

/**
 * Drains mode-debug-menu presses and accepts them only between consecutive gameplay ticks outside binding capture.
 */
bool DebugModeTakeMenuKey(int frame);

/**
 * Records whether a gameplay tick completed without an intervening loading frame.
 */
void DebugModeEndMenuKeyTick(int begin_frame, int end_frame);

/**
 * Discards pending mode-debug-menu presses after a pause or mode transition.
 */
void DebugModeDiscardMenuKey();
