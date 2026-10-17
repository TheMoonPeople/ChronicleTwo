#include "common.h"

#include "mainloop.hpp"
#include "map_port.hpp"
#include "mapselect.hpp"
#include "scene.hpp"

void UpdateTrBoxFlag(int map_no);
void PortRetailUpdateTrBoxFlag(int map_no) asm("EditLoop_UpdateTrBoxFlag");

// Retail, after the chests that share another chest's opened flag get their own.
PORT_OVERRIDE void UpdateTrBoxFlag(int map_no) {
    CScene *scene = GetMainScene();
    PortSplitTreasureBoxFlags(scene->GetMap(scene->active_map), GetMapName(map_no, nullptr));
    PortRetailUpdateTrBoxFlag(map_no);
}
