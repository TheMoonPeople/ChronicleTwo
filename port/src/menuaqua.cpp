#include "common.h"

#include <cstdio>
#include <string>

#include "character.hpp"
#include "dataread_port.hpp"
#include "menuaqua.hpp"
#include "platform/model_assets.hpp"
#include "userdata.hpp"

PORT_OVERRIDE int FishIMGReplace(u_long128 *data, CCharacter2 *character, int item_no, BREEDFISH_USED *fish) {
    if (!data || !character || !fish || (fish->flags & BREEDFISH_FLAG_ELECTRIC)) {
        return 0;
    }
    char path[128];
    if (!GetFishImgPath(path, item_no, fish)) {
        return 0;
    }
    const auto relative = DataReadAssetPath(("/" + std::string(path)).c_str());
    if (!relative) {
        return 0;
    }
    std::string error;
    if (!model_assets::ReplaceCharacterTextureDocument(*character, *relative, error)) {
        std::fprintf(stderr, "fish texture: %s\n", error.c_str());
    }
    return 0;
}
