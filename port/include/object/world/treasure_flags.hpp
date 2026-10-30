#pragma once

#include <string_view>

class CMap;

// Gives a town's chests their own opened flags where retail data gives two chests the same one.
void PortSplitTreasureBoxFlags(CMap &map, std::string_view map_name);
