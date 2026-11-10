#pragma once

#include "common.h"

/**
 * @file
 * Declares the interface to the hard-disk installer, which copies the game
 * onto the PlayStation 2 hard disk and mounts the installed copy.
 * In this build every function is an empty stub that reports nothing found.
 */

/**
 *
 * Reports whether a usable hard disk is connected, storing the drive's
 * state through a pointer that may be NULL; positive when one is usable.
 *
 * @mangled HddConectCheck__FPi
 * @address 0x320C80
 * @size 0x10
 */
int HddConectCheck(int *state);

/**
 *
 * Reports whether the game is installed on the hard disk; positive when
 * it is, negative on an error.
 *
 * @mangled CheckAppInstall__Fv
 * @address 0x320C90
 * @size 0x10
 */
int CheckAppInstall();

/**
 *
 * Reports whether the hard disk has room to install the game; positive
 * when it has, negative on an error.
 *
 * @mangled CheckInstallSpace__Fv
 * @address 0x320CA0
 * @size 0x10
 */
int CheckInstallSpace();

/**
 *
 * Mounts the hard-disk partition that holds the installed game so that
 * files are read from it; positive on success.
 *
 * @mangled MountHDDFileSystem__Fv
 * @address 0x320CB0
 * @size 0x10
 */
int MountHDDFileSystem();

/**
 *
 * Unmounts the hard-disk partition that holds the installed game,
 * returning file reads to the disc.
 *
 * @mangled UmountHDDFileSystem__Fv
 * @address 0x320CC0
 * @size 0x10
 */
int UmountHDDFileSystem();

/**
 *
 * Starts the thread that copies the game onto the hard disk, working in
 * a buffer of a given size in bytes; non-zero when the thread was started.
 *
 * @mangled CreateInstallThread__FP1i
 * @address 0x320CD0
 * @size 0x10
 */
int CreateInstallThread(u_long128 *work, int work_size);

/**
 *
 * Removes the installation thread
 * once the installation has stopped.
 *
 * @mangled DeleteInstallThread__Fv
 * @address 0x320CE0
 * @size 0x10
 */
void DeleteInstallThread();

/**
 *
 * Advances the installation by one frame; positive while it is still
 * running, otherwise the final result, zero on success.
 *
 * @mangled StepInstallThread__Fv
 * @address 0x320CF0
 * @size 0x10
 */
int StepInstallThread();

/**
 *
 * Pauses a running installation,
 * or resumes a paused one.
 *
 * @mangled InstallPause__Fv
 * @address 0x320D00
 * @size 0x10
 */
int InstallPause();

/**
 *
 * Asks the installation thread to stop; StepInstallThread reports
 * when it has.
 *
 * @mangled InstallCancel__Fv
 * @address 0x320D10
 * @size 0x10
 */
void InstallCancel();

/**
 *
 * Gives how far the installation has got,
 * in percent.
 *
 * @mangled GetInstallProgress__Fv
 * @address 0x320D20
 * @size 0x10
 */
float GetInstallProgress();

/**
 *
 * Removes the installed copy of the game from the hard disk, giving the
 * result code that the hard-disk debug menu shows as its error code.
 *
 * @mangled UninstallApp__Fv
 * @address 0x320D30
 * @size 0x10
 */
int UninstallApp();
