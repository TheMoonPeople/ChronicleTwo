#pragma once

#include "common.h"

#ifdef PORT

void PortSetDungeonReadBuffer(u_long128 *base, int quadwords);
bool PortDungeonReadBufferContains(const void *ptr);
void PortAssertDungeonReadCursor(const void *cursor);

#endif
