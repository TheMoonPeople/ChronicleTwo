#pragma once

#include <scriptinterpreter.hpp>

class mgCMemory;

/** Native prize loading shares the original prize callbacks and allocation state. */
extern SPI_TAG_PARAM gyoprize_tag[4] asm("Aqua_FishPrizeTags");
extern mgCMemory    *fish_prize_buildstack asm("Aqua_FishPrizeBuildStack");
extern signed char   FishTournamentGoodsType asm("Aqua_FishTournamentGoodsType");
