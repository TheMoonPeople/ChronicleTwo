// Appended to the native copy of ps2/src/fishing.cpp: hands out the fishing game's own models, which are file
// statics of that unit, so the paused menu picture can leave the gear in the player's hands out with the player.
#include <array>

#include "config_bridges.hpp"

std::array<const CCharacter2 *, 6> PortFishingGear() {
    return {UkiRod, LureRod, Uki, Lure, Hari, EsaChara};
}
