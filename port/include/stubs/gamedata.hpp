#pragma once
#include <gamedata.hpp>
#include <scriptinterpreter.hpp>

class mgCMemory;

// Share retail dispatch and name allocation with the native message arena.
extern SPI_TAG_PARAM gamedata_tag[25] asm("GameData_Tags");
extern mgCMemory    *gamedata_build_stack asm("GameData_BuildStack");
