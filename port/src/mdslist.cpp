#include "common.h"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <variant>

#include "asset_directory.hpp"
#include "collision_assets.hpp"
#include "dataread_port.hpp"
#include "mdslist.hpp"
#include "mg_dataset.hpp"
#include "mglib.hpp"
#include "platform/config_catalog.hpp"
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
 * Reads a model-list integer with the command interpreter's default conversion.
 */
int Integer(const config_catalog::Command &command, std::size_t index) {
    if (index < command.arguments.size()) {
        if (const auto *value = std::get_if<int>(&command.arguments[index].value)) {
            return *value;
        }
        if (const auto *value = std::get_if<float>(&command.arguments[index].value)) {
            return static_cast<int>(*value);
        }
    }
    return 0;
}

/**
 * Reads a model-list distance with the command interpreter's numeric conversion.
 */
float Real(const config_catalog::Command &command, std::size_t index) {
    if (index < command.arguments.size()) {
        if (const auto *value = std::get_if<float>(&command.arguments[index].value)) {
            return *value;
        }
        if (const auto *value = std::get_if<int>(&command.arguments[index].value)) {
            return static_cast<float>(*value);
        }
    }
    return 0;
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
    std::string error;
    const auto  document = config_catalog::Find(*parent + "/info.cfg.json", error);
    if (!document) {
        std::fprintf(stderr, "model list: %s\n", error.c_str());
        return;
    }
    const auto files = datapacks::DirectoryMembers(*parent);
    const auto capacity = std::count_if(files.begin(), files.end(), [](const auto &file) { return std::filesystem::path(file).extension() == ".gltf"; });
    if (capacity > MDS_PCP_ENTRY_MAX) {
        std::fprintf(stderr, "model list: too many native models\n");
        return;
    }
    name = label ? CopyName(*memory, label) : nullptr;
    num = static_cast<int>(capacity);
    list = num > 0 ? new (memory->Alloc(static_cast<int>((num * sizeof(CMdsInfo) + 15) / 16 + 2))) CMdsInfo[num] : nullptr;
    CMdsInfo *current = nullptr;
    int       next = 0;
    for (const auto &command : document->commands) {
        if (command.name == "MDS") {
            current = nullptr;
            if (next >= num || command.arguments.empty()) {
                continue;
            }
            const auto *model_name = std::get_if<std::string>(&command.arguments.front().value);
            if (!model_name || GetList(const_cast<char *>(model_name->c_str()))) {
                continue;
            }
            current = &list[next++];
            current->name = CopyName(*memory, *model_name);
        } else if (current && command.name == "TYPE") {
            const int type = Integer(command, 0);
            switch (type) {
                case 0:
                    current->type = MDS_TYPE_MODEL;
                    break;
                case 1:
                    current->type = MDS_TYPE_COLLISION;
                    break;
                case 2:
                    current->type = MDS_TYPE_CAMERA_COLLISION;
                    break;
                case 3:
                case 4:
                    current->type = MDS_TYPE_CHARA;
                    break;
                default:
                    current->type = type;
                    break;
            }
        } else if (current && command.name == "FAR_CLIP") {
            current->far_dist = Real(command, 0);
            current->far_fade = Integer(command, 1);
        } else if (current && command.name == "MDS_END") {
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
                model_assets::CharacterLoadOptions options{memory, memory, memory, &mgTexManager, nullptr, -1, false};
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
}
