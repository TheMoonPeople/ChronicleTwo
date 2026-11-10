#pragma once

#include "common.h"

u_long128 *ArenaRoot(const void *key, int quadwords, const char *name);
u_long128 *ArenaRootFromBuffer(const u_long128 *buffer, int quadwords, const char *name);
