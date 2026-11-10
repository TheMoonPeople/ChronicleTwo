#pragma once

#include <npccfg.hpp>

/** Native party-character loading fills the party-character table. */
extern int           NpcBaseDataTotalNum asm("Npccfg_NpcBaseDataTotalNum");
extern NPC_BASE_DATA NpcBaseData[180] asm("Npccfg_NpcBaseData");
