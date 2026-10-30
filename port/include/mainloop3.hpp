#pragma once

#include "common.h"

/**
 * @file
 * Declares the debug menus reached from the event-select screen (the future-map
 * select and the hard-disk install menu) and the screen shown when a hard-disk
 * read fails beyond recovery.
 */

/**
 *
 * Results of one frame of the future-map select menu, which the
 * event-select screen uses to decide whether to stay or leave.
 *
 */
// clang-format off
enum FutureMapSelectResult {
    FUTURE_MAP_SELECT_CONTINUE = 0, /**< The menu stays open. */
    FUTURE_MAP_SELECT_CHOSEN   = 1, /**< A map was chosen and the next loop has been started. */
    FUTURE_MAP_SELECT_CLOSED   = 2, /**< The menu was cancelled. */
};

// clang-format on

/**
 *
 * Results of one frame of the hard-disk debug menu, which the
 * event-select screen uses to decide whether to stay or leave.
 *
 */
// clang-format off
enum HDDMenuResult {
    HDD_MENU_CONTINUE = 0, /**< The menu stays open. */
    HDD_MENU_CLOSED   = 1, /**< The menu was cancelled. */
};

// clang-format on

/**
 *
 * Entries of the hard-disk debug menu, in the order they are listed,
 * as the selected-entry index holds them.
 *
 */
// clang-format off
enum HDDMenuItem {
    HDD_MENU_UNINSTALL = 0, /**< Removes the installed copy of the game from the hard disk. */
    HDD_MENU_INSTALL   = 1, /**< Installs the game onto the hard disk. */
    HDD_MENU_MOUNT     = 2, /**< Switches file reads between the disc and the hard disk. */
};

// clang-format on

/**
 *
 * Runs one frame of the debug menu that picks a future-era map and toggles
 * the analysis flags of its edit data, starting that map when one is chosen.
 *
 * @mangled FutureMapSelect__Fv
 * @address 0x320090
 * @size 0x464
 */
int FutureMapSelect();

/**
 *
 * Prepares the hard-disk debug menu, reading the drive's connection,
 * install and free-space state and keeping the memory the installer works in.
 *
 * @mangled InitHDDMenu__FP1
 * @address 0x320500
 * @size 0x50
 */
void InitHDDMenu(u_long128 *work);

/**
 *
 * Runs one frame of the hard-disk debug menu, which installs, uninstalls
 * or mounts the game's hard-disk copy and shows the install progress.
 *
 * @mangled HDDMenuLoop__Fv
 * @address 0x320550
 * @size 0x464
 */
int HDDMenuLoop();

/**
 *
 * Handles a hard-disk read error; for an unrecoverable one it stops all sound
 * and shows a repair message forever, otherwise it gives 0.
 *
 * @mangled EmergencyMessage__Fi
 * @address 0x3209C0
 * @size 0x2B4
 */
int EmergencyMessage(int error);
