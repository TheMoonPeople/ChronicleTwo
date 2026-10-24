#pragma once

/**
 * Marks the end of a game frame for the hang watchdog. With DC2_HANG_ABORT_SECONDS set, a game thread that ends no
 * frame for that many seconds is reported: on Apple arm64 its stack goes to stderr every that many seconds, elsewhere
 * it is aborted so the crash report records where it stopped. Unset, this does nothing.
 */
void HangWatchdogFrame();
