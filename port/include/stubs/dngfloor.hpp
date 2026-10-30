#pragma once
#include <scriptinterpreter.hpp>

class CDngFloorManager;
class mgCMemory;

/** The floor title text script still runs through retail's tag table, which reads these. */
extern SPI_TAG_PARAM     tree_map_tag[12] asm("DngFloor_TreeMapTag");
extern CDngFloorManager *tree_dngmap asm("DngFloor_TreeMap");
extern mgCMemory        *tree_spi_stack asm("DngFloor_TreeSpiStack");

/** Native map loading picks a negative room picture from these group bases, as RI_TEX does. */
extern int offsetTable_911[5] asm("DngFloor_TextureGroupBase");
