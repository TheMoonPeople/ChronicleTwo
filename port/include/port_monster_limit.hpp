#pragma once

int PortMonsterActiveLimit();
// Nearest monsters allowed in view / ThinkHost (retail priority_limit is 5).
int PortMonsterVisiblePriorityLimit();
// When true, skip retail rank-based view fade (show all active dungeon monsters in range).
bool PortDungeonMonsterExpandedView();
