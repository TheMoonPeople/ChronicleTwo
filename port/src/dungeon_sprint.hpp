#pragma once

class CActionChara;

// Runs the retail dungeon key step with R2 taken from its first-person toggle while the player walks the
// floor: holding R2 sprints, and a quick release hands retail its press (port/src/sprint.hpp).
int DungeonSprintMainKey(int (*retail)());

// Scales the velocity and motion speed that the retail HumanMoveIF just set, while sprinting and not
// locked on. Called after every retail HumanMoveIF.
void DungeonSprintMove(CActionChara *chara);
