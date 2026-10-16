#pragma once
#include <menuchr.hpp>
#include "texture_color.hpp"

void PortRetailInitMainCharaBG(int, mgCMemory *, int) asm("MenuChr_InitMainCharaBG");
int PortRetailKeyMainCharaBG() asm("MenuChr_KeyMainCharaBG");
