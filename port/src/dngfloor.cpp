#include "common.h"

#include <algorithm>
#include <cstdio>
#include <memory>

#include "dataread.hpp"
#include "dngfloor.hpp"
#include "menucommon.hpp"

namespace {

// Retail's stack scratch, which flrtitle<n>.txt still has to fit.
constexpr int kRetailScratch = 0xA000;

} // namespace

// Retail reads dmap<n>.cfg and dflr<n>.cfg into a 40 KiB scratch on the stack. The converted tables are
// bigger (Mt. Gundor's dmap4.cfg is about 93 KiB), so reading one there ran over the stack and crashed
// on the way to that dungeon or its floor map. The scratch is sized to the files instead. The names are
// the converted ones: the build rewrites retail literals in ps2/src, not in a port override.
PORT_OVERRIDE void CDngFloorManager::LoadDataTable(int dungeon, mgCMemory *memory) {
    char menu_path[0x40];
    int  size = 0;

    if (memory == NULL) {
        return;
    }

    if (dungeon < 0 || dungeon >= DNGMAP_DUNGEON_NUM) {
        dungeon = 0;
    }

    Initialize();
    dng_no = dungeon;

    char table_paths[2][0x60];
    std::snprintf(table_paths[0], sizeof table_paths[0], "menu/dngmap/dmap%d.cfg.json", dungeon);
    std::snprintf(table_paths[1], sizeof table_paths[1], "menu/dngmap/dflr%d.cfg.json", dungeon);

    int largest = kRetailScratch;
    for (char *table : table_paths) {
        int table_size = 0;
        if (LoadFile2(table, NULL, &table_size, LOAD_FILE_SIZE)) {
            largest = std::max(largest, table_size);
        }
    }

    // Room for the reader's sector padding and MenuCalcBufAlignment's rounding.
    const std::size_t bytes = static_cast<std::size_t>(largest) + DATAREAD_SECTOR_SIZE + 64;
    const auto scratch = std::make_unique<u_long128[]>(bytes / sizeof(u_long128) + 1);
    u8        *data = (u8 *) MenuCalcBufAlignment(scratch.get());

    for (char *table : table_paths) {
        size = 0;
        LoadFile2(table, data, &size, LOAD_FILE_READ);

        if (size > 0) {
            AnalyzeFile((char *) data, size, memory);
        }
    }

    std::sprintf(menu_path, "flrtitle%d.txt", dungeon);
    size = LoadFileMenu(menu_path, (u_long128 *) data, MENU_FILE_LOAD_DIRECT);

    if (size > 0) {
        AnalyzeFile((char *) data, size, memory);
    }
}
