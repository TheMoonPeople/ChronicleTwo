#pragma once

#include <scriptinterpreter.hpp>

class mgCMemory;

/** Native prize loading shares the arena and selected prize category. */
extern mgCMemory  *fish_prize_buildstack asm("Aqua_FishPrizeBuildStack");
extern signed char FishTournamentGoodsType asm("Aqua_FishTournamentGoodsType");
