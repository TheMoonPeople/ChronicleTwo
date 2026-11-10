#pragma once

#include "monster.hpp"
#include "runscript.hpp"

/** Quadwords reserved for a monster's two native interpreter stacks and the strict arena end. */
inline constexpr int kMonsterScriptQuadwords = (128 * sizeof(RS_STACKDATA) + 15) / 16 +
                                               (512 * sizeof(RS_CALLDATA) + 15) / 16 + 1;

/**
 *
 * Gives every active monster slot its own native arena for model and script copies.
 */
void PrepareMonsterMemory(CMonsterMan &manager);

// Reads game.more_monsters for the floor being set up, and returns the priority limit: how many of the nearest
// monsters show and act.
int PortMonsterLatchLimits();
// Monster slots the current floor uses: retail's 24, or MONSTER_ACTIVE_MAX with game.more_monsters.
int PortMonsterActiveLimit();
