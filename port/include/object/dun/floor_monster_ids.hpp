#pragma once

#include <vector>

/**
 * The monster ids dungeon's placement list (dungeon/cfg_file/mos_place<dungeon>) puts on floor, in list order, as
 * CreatMonsterFloorInfo reads them.
 */
std::vector<int> PortFloorMonsterIds(int dungeon, int floor);
