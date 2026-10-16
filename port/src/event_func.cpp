#include "common.h"

#include <nlohmann/json.hpp>

#include <cstdio>
#include <cstring>
#include <map>

#include "dataread_port.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"
#include "scene.hpp"

PORT_OVERRIDE int _LOAD_CHARA_sub(int stack_no, char **name, int chara_no, u32 *model, int mode) {
    if (!EventScene || !name) {
        return 0;
    }
    if (!*name) {
        const auto path = DataReadBufferPath(model);
        if (!path) {
            return 0;
        }
        std::string error;
        const auto  game = model_assets::ReadGameplay(*path, error);
        if (!game) {
            std::fprintf(stderr, "character: %s\n", error.c_str());
            return 0;
        }
        static std::map<std::string, std::string> selected_profiles;
        auto                                     &profile = selected_profiles[*path];
        profile = game->value("default_profile", std::string{});
        if (profile.empty()) {
            return 0;
        }
        *name = profile.data();
    }
    auto     *memory = EventScene->GetStack(stack_no);
    const int texture_block = EventScene->GetCharaTexb(chara_no);
    if (!memory || texture_block < 0) {
        return 0;
    }
    mgTexManager.DeleteBlock(texture_block);
    if (chara_no >= 8) {
        std::snprintf(mgTexManager.name_suffix, sizeof(mgTexManager.name_suffix), "ev%d", chara_no);
    }
    const int result = EventScene->LoadChara(chara_no, model, *name, memory, memory, memory, texture_block, mode);
    if (chara_no >= 8) {
        mgTexManager.name_suffix[0] = 0;
    }
    EventScene->SetType(SCENE_DATA_CHARA, chara_no, SCENE_CHARA_TYPE_EVENT);
    return result;
}
