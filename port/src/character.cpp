#include "common.h"

#include <cstdio>

#include "character.hpp"
#include "dataread_port.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"

PORT_OVERRIDE void CCharacter2::LoadChrFile(u32 *data, char *profile, mgCMemory *model,
                                            mgCMemory *motion, mgCMemory *images, int block, CCharacter2 *parent, int outline) {
    model_assets::CharacterLoadOptions options{model, motion, images, &mgTexManager, parent, block, outline != 0};
    std::string                        error;
    const auto                         path = DataReadBufferPath(data);
    if (!path) {
        std::fprintf(stderr, "character: direct glTF path required\n");
        return;
    }
    const bool loaded = model_assets::LoadCharacter(*this, std::filesystem::path(*path), profile ? profile : "", options, error);
    if (!loaded) {
        std::fprintf(stderr, "character: %s\n", error.c_str());
    }
}

PORT_OVERRIDE void CCharacter2::LoadSkin(u32 *data, char *profile, char *name, mgCMemory *memory, int block) {
    model_assets::CharacterLoadOptions options{memory, memory, memory, &mgTexManager, nullptr, block, false};
    std::string                        error;
    const auto                         path = DataReadBufferPath(data);
    if (!path) {
        std::fprintf(stderr, "character skin: direct glTF path required\n");
        return;
    }
    const bool loaded = model_assets::LoadSkin(*this, std::filesystem::path(*path), profile ? profile : "", name ? name : "", options, error);
    if (!loaded) {
        std::fprintf(stderr, "character skin: %s\n", error.c_str());
    }
}

PORT_OVERRIDE void CCharacter2::DeleteExtMotion() {
    // Drop each extension before reselecting the base motion, preserving its pose transition.
    for (int slot = 1; slot < CHARA_MOTION_SET_MAX; ++slot) {
        motion[slot].frame_info = shadow_motion[slot].frame_info = nullptr;
        key_list[slot] = nullptr;
        seq_list[slot] = nullptr;
        key_num[slot] = 0;
        if (auto *base = GetKeyListIndexPtr(0, nullptr)) {
            SetMotion(base->name, CHARA_MOTION_RESTART);
        }
        if (next_key != nullptr) {
            posed_key = next_key;
            frame = static_cast<float>(next_key->start_frame);
        }
    }
    if (tex_anime_group_start > 0) {
        for (int group = tex_anime_group_start; group < tex_anime_group_num; ++group) {
            mgTexManager.DeleteTexAnimeGroup(texture_block, group);
        }
    } else {
        mgTexManager.DeleteTexAnime(texture_block);
    }
    model_assets::DeleteCharacterTextures(*this, 1, CHARA_IMAGE_MAX - 1);
    for (int slot = 1; slot < CHARA_IMAGE_MAX; ++slot) {
        auto *archive = images[slot];
        if (archive == nullptr) {
            continue;
        }
        images[slot] = nullptr;
    }
    for (int slot = 1; slot < CHARA_MOTION_SET_MAX; ++slot) {
        se_list[slot] = nullptr;
        se_num[slot] = 0;
    }
}

PORT_OVERRIDE void CCharacter2::DeleteImage() {
    int group_count = 0;
    mgTexManager.GetGroupNameList(texture_block, &group_count);
    if (tex_anime_group_start > 0) {
        for (int group = tex_anime_group_start; group < tex_anime_group_num; ++group) {
            mgTexManager.DeleteTexAnimeGroup(texture_block, group);
        }
    }
    model_assets::DeleteCharacterTextures(*this, 0, 0);
    if (images[0]) {
        images[0] = nullptr;
    }
}
