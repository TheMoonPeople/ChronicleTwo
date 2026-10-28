#include "common.h"

#include "fishingobj.hpp"
#include "menu_world.hpp"
#include "stubs/fishingobj.hpp"

// The line hangs from the rod in the player's hands, so the paused menu picture leaves it out with the rod.
PORT_OVERRIDE void DrawFishingLine() {
    const menuworld::HeldGearScope scope;
    PortRetailDrawFishingLine();
}
