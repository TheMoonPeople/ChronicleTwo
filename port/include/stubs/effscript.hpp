#pragma once

#include <effscript.hpp>

// Retail's sprite commands, kept under these names: port/src/effscript.cpp renews the recovery effect's sprite
// incarnations around them.
int PortRetailSptAssignSprite(RS_STACKDATA *stack, int argument_count) asm("EffScript_SptAssignSprite");
int PortRetailSptInitSprite(RS_STACKDATA *stack, int argument_count) asm("EffScript_SptInitSprite");
