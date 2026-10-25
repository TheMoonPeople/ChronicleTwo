#include "common.h"

#include "actionchara.hpp"
#include "dungeon_sprint.hpp"
#include "menu_world.hpp"

// The player's effects are tagged while the dungeon pause frame is recorded, so the playerless picture drops them.
PORT_OVERRIDE void CActionChara::DrawEffect() {
    const menuworld::PlayerEffectScope scope(this == menuworld::PausingPlayer());
    PortRetailDrawEffect();
}

// Holding R2 sprints on foot; the retail step sets the walk, which the sprint then scales.
PORT_OVERRIDE int CActionChara::HumanMoveIF() {
    const int result = PortRetailHumanMoveIF();
    DungeonSprintMove(this);
    return result;
}
