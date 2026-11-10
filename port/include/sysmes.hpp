#pragma once

#include "common.h"

#include "mg_memory.hpp"
#include "nd_meswin.hpp"

/**
 * @file
 * Declares the system message windows and the language-specific system
 * message files that every scene uses for prompts and notifications.
 */

/**
 *
 * First system message window.
 *
 */
extern ClsMes SystemMessage;

/**
 *
 * Second system message window.
 *
 */
extern ClsMes SystemMessage2;

/**
 *
 * Third system message window.
 *
 */
extern ClsMes SystemMessage3;

/**
 *
 * Language-specific general system message data.
 *
 */
extern short SystemMesBuffer[0x6800];

/**
 *
 * Language-specific system prompt message data.
 *
 */
extern short SysMesBuffer[0x9C40];

/**
 *
 * Memory stack reserved for the system message windows.
 *
 */
extern mgCMemory SystemMesStack;

/**
 *
 * Returns the first system message window.
 *
 * @mangled GetSystemMessage__Fv
 * @address 0x197BA0
 * @size 0x8
 */
ClsMes *GetSystemMessage();

/**
 *
 * Returns the system message window with the given index, the first one for any index other than 1 or 2.
 *
 * @mangled GetSystemMessage__Fi
 * @address 0x197BB0
 * @size 0x38
 */
ClsMes *GetSystemMessage(int index);

/**
 *
 * Loads the system.mes and sysmes.mes files for the current language into their buffers.
 *
 * @mangled LoadSystemMes__Fv
 * @address 0x197BF0
 * @size 0x184
 */
void LoadSystemMes();

/**
 *
 * Returns the message data loaded from system.mes.
 *
 * @mangled GetSystemMesBuffer__Fv
 * @address 0x197D80
 * @size 0xC
 */
dc2::text::MessageTable GetSystemMesBuffer();

/**
 *
 * Returns the message data loaded from sysmes.mes.
 *
 * @mangled GetSysMesBuffer__Fv
 * @address 0x197D90
 * @size 0xC
 */
dc2::text::MessageTable GetSysMesBuffer();

/**
 *
 * Resets all three system message windows.
 *
 * @mangled CreateSystemMes__Fv
 * @address 0x197DA0
 * @size 0x38
 */
void CreateSystemMes();

/**
 *
 * Resets one system message window to its default state and attaches the system message buffers to it.
 *
 * @mangled CreateSystemMes__Fii
 * @address 0x197DE0
 * @size 0x314
 */
void CreateSystemMes(int index, int unused);
