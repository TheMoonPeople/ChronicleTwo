#include "common.h"

#include <string>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "native_config.hpp"
#include "scriptinterpreter.hpp"

extern SPI_TAG_PARAM PortGameConfigTags[] asm("MainLoop_ConfigTags");
extern SPI_TAG_PARAM PortMonsterLanguageTags[2] asm("Monster_LanguageTags");
extern SPI_TAG_PARAM PortFishPrizeTags[4] asm("Aqua_FishPrizeTags");
extern mgCMemory    *PortFishPrizeBuildStack asm("Aqua_FishPrizeBuildStack");
extern signed char   PortFishTournamentGoodsType asm("Aqua_FishTournamentGoodsType");

PORT_OVERRIDE void LoadGameConfig(char *path) {
    if (!path) {
        SetCurrentDir(nullptr);
    }
    if (path || DataReadAssetPath("game.cfg.json")) {
        RunNativeConfig(path ? path : "game.cfg.json", PortGameConfigTags);
    }
    if (!path) {
        SetCurrentDir(nullptr);
    }
}

PORT_OVERRIDE void LoadMonsterLanguage(int language) {
    RunNativeConfig("dungeon/cfg_file/mosdata" + std::to_string(language) + ".cfg.json", PortMonsterLanguageTags);
}

PORT_OVERRIDE int LoadFishPrize(int goods_type, mgCMemory *pool) {
    InitFishPrize();
    PortFishTournamentGoodsType = goods_type >= 0 && goods_type < 2 ? goods_type : 0;
    PortFishPrizeBuildStack = pool;
    RunNativeConfig(PortFishTournamentGoodsType == 0 ? "gyop.cfg.json" : "uofp.cfg.json", PortFishPrizeTags);
    RefreshFishPrize();
    return 1;
}
