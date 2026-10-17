#pragma once

#ifdef PORT

#include <cstddef>

#include "nd_meswin.hpp"

int PortRetailSyntheticSysMesId(int retail_row);

u16 *PortRetailSystemMessageOverride(int line_id);

void PortRetailClearSystemMessageOverrides();
void PortRetailRegisterSystemMessageOverride(int line_id, const char *label);

// After LoadSystemMes and font tables are ready, append host option labels to system.mes.
void PortRetailInstallHostOptionSystemLines();

// Retail option column 0 uses allmenu.mes message 2050 (inline lines, not item_mes slots).
constexpr int kRetailOptionMenuMessageColumn0 = 2050;

// Replace one logical line inside a menu message (GetMenuMainMessageBuffer layout).
bool PortRetailReplaceMenuMessageLine(short *menu_table, int message_id, int line_index, const char *label);

#endif
