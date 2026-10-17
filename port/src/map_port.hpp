#pragma once

class CMap;

// Gives a town's chests their own opened flags where retail data gives two chests the same one.
void PortSplitTreasureBoxFlags(CMap *map, const char *map_name);
