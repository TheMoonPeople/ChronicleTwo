#pragma once

#include "common.h"

/**
 * @file
 * Declares the transfer of files over the network socket, the device that
 * paths with the "net:" prefix name.
 */

/**
 *
 * Returns zero because network socket file loading is unavailable.
 *
 * @mangled LoadFileSocket__FPcPUi
 * @address 0x28D1D0
 * @size 0x10
 */
int LoadFileSocket(char *path, unsigned int *data);

/**
 *
 * Provides the network socket file-writing hook without writing data.
 *
 * @mangled WriteFileSocket__FPcPUii
 * @address 0x28D1E0
 * @size 0x10
 */
void WriteFileSocket(char *path, unsigned int *data, int size);
