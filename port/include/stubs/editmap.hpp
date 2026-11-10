#pragma once

class CEditHouse;
class CEditMap;
class mgCMemory;

/** Edit part slots a town can hold: EditPlaceLog numbers them in an s16. */
inline constexpr int kPortEditSlotCeiling = 32767;

/** Applies a georama map's native editor settings in place of the editor-parts script's run. */
void PortApplyEditMapConfig(CEditMap *map, char *script, int size, mgCMemory *stack);

/** Number of houses a town has handed out since its houses were last cleared. */
int PortEditHouseCount(const CEditMap &map);

/** Returns a town's house by number, adding cleared houses up to it, or nullptr outside the slot ceiling. */
CEditHouse *PortEditHouse(CEditMap &map, int index);

/** Constructs edit part slots, and their placement log entries, until a town has at least the given number. */
void PortEditReserveSlots(CEditMap &map, int slots);
