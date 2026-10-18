// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <optional>
#include <print>
#include <string>
#include <vector>

#include "asset_directory.hpp"
#include "collision_assets.hpp"
#include "dataread_port.hpp"
#include "mdslist.hpp"
#include "mg_dataset.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"

namespace {
/**
 * Copies a retained gameplay name into the model's native allocation arena.
 */
char *CopyName(mgCMemory &memory, const std::string &name) {
    auto *copy = reinterpret_cast<char *>(memory.Alloc(static_cast<int>((name.size() + 16) / 16 + 2)));
    std::memcpy(copy, name.c_str(), name.size() + 1);
    return copy;
}

/**
 * One model of a model_list document.
 */
struct ModelEntry {
    std::optional<std::string> model;    /**< Model file in the pack, or nothing for a missing name. */
    std::optional<int>         type;     /**< Script model type, when given. */
    std::optional<float>       far_dist; /**< Far clip distance, when given. */
    int                        far_fade; /**< Whether the model fades at its far clip. */
};

/**
 * Parses a model_list document.
 */
std::vector<ModelEntry> ParseModelList(const native_config::Json &document) {
    using namespace native_config;
    std::vector<ModelEntry> models;
    for (const auto &model : Array(document, "models")) {
        ModelEntry entry{.model = GameText(At(model, "model")), .type = OptionalInt(model, "type"), .far_dist = std::nullopt, .far_fade = 0};
        if (model.contains("far_clip")) {
            const auto &clip = At(model, "far_clip");
            entry.far_dist = Float(clip, "distance");
            entry.far_fade = Int(clip, "fade");
        }
        models.push_back(std::move(entry));
    }
    return models;
}

/**
 * Converts a script model type to its stored model category; 3 and 4 both load a character.
 */
int ModelType(int type) {
    switch (type) {
        case 0:
            return MDS_TYPE_MODEL;
        case 1:
            return MDS_TYPE_COLLISION;
        case 2:
            return MDS_TYPE_CAMERA_COLLISION;
        case 3:
        case 4:
            return MDS_TYPE_CHARA;
        default:
            return type;
    }
}
} // namespace

PORT_OVERRIDE void CMdsList::LoadPCPFile(char *label, u_int *source, mgCMemory *memory, int scissor) {
    if (!memory) {
        return;
    }
    const auto parent = AssetDirectoryPath(source);
    if (!parent) {
        return;
    }
    const auto models = native_config::Read<std::vector<ModelEntry> >(*parent + "/info.cfg.json", "model_list", ParseModelList);
    if (!models) {
        return;
    }
    std::string error;
    const auto  files = datapacks::DirectoryMembers(*parent);
    const auto  capacity = std::count_if(files.begin(), files.end(), [](const auto &file) { return std::filesystem::path(file).extension() == ".gltf"; });
    if (capacity > MDS_PCP_ENTRY_MAX) {
        std::println(stderr, "model list: too many native models");
        return;
    }
    name = label ? CopyName(*memory, label) : nullptr;
    num = static_cast<int>(capacity);
    list = num > 0 ? new (memory->Alloc(static_cast<int>((num * sizeof(CMdsInfo) + 15) / 16 + 2))) CMdsInfo[num] : nullptr;
    int next = 0;
    for (const auto &model : *models) {
        // MDS past the table, or naming a model already listed, leaves no current entry.
        if (next >= num || (model.model && GetList(const_cast<char *>(model.model->c_str())))) {
            continue;
        }
        CMdsInfo *current = &list[next++];
        current->Initialize();
        current->name = model.model ? CopyName(*memory, *model.model) : nullptr;
        if (model.type) {
            current->type = ModelType(*model.type);
        }
        if (model.far_dist) {
            current->far_dist = *model.far_dist;
            current->far_fade = model.far_fade;
        }
        if (current->name == nullptr) {
            continue;
        }
        const auto path = *parent + "/" + std::filesystem::path(current->name).filename().generic_string();
        if (current->type == MDS_TYPE_MODEL) {
            mgLoadData load{};
            load.memory = memory;
            current->frame = model_assets::LoadModel(path, load, error);
        } else if (current->type == MDS_TYPE_COLLISION || current->type == MDS_TYPE_CAMERA_COLLISION) {
            current->frame = LoadCollisionModel(path, memory);
        } else if (current->type == MDS_TYPE_CHARA) {
            auto *character = new (memory->Alloc(static_cast<int>((sizeof(CCharacter2) + 15) / 16 + 2))) CCharacter2;
            character->Initialize();
            model_assets::CharacterLoadOptions options{.model_memory = memory, .motion_memory = memory, .image_memory = memory, .textures = &mgTexManager, .parent = nullptr, .texture_block = -1, .outline = false};
            if (model_assets::LoadCharacter(*character, path, "info", options, error)) {
                current->chara = character;
                current->frame = character->CObjectFrame::frame;
            }
        }
        if (scissor && current->frame) {
            mgCFrameAttr attributes{};
            attributes.clip_enable = 1;
            current->frame->SetAttrParam(attributes, 1, MG_FRAME_ATTR_CLIP);
        }
    }
}
