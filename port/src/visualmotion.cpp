#include "common.h"

#include <cstdio>
#include <stdexcept>

#include "dataread_port.hpp"
#include "gameutil.hpp"
#include "mg_dataset.hpp"
#include "mg_math.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"
#include "visualmotion.hpp"

PORT_OVERRIDE int mgCVisualMotionMDT::DataAssignMotionMDT(MDT_HEADER *header, mgCVMotionData *motion,
                                                          mgCMemory *memory, mgCMemory *work,
                                                          mgCTextureManager *textures) {
    if (!header || !memory) {
        std::fprintf(stderr, "animation: native glTF source required for skinned visual assignment\n");
        return 0;
    }
    char               empty[] = "";
    mgCreateVisualType types[] = {
        {MG_VISUAL_CREATE_MOTION_MDT, empty  },
        {MG_VISUAL_CREATE_END,        nullptr}
    };
    mgLoadData load{};
    load.memory = memory;
    load.texture_manager = textures;
    load.visual_type = types;
    std::string error;
    const auto  path = DataReadBufferPath(header);
    if (!path) {
        std::fprintf(stderr, "animation: direct glTF visual path required\n");
        return 0;
    }
    auto *root = model_assets::LoadModel(std::filesystem::path(*path), load, error);
    auto *selected = root && motion && motion->frame_id >= 0 && motion->frame_id < root->frame_num ? root->GetFrame(motion->frame_id) : root;
    if (!selected || !selected->visual || selected->visual->Iam() != MG_VISUAL_KIND_MOTION_MDT) {
        std::fprintf(stderr, "animation: %s\n", error.empty() ? "native skinned visual absent" : error.c_str());
        return 0;
    }
    *this = *static_cast<mgCVisualMotionMDT *>(selected->visual);
    if (motion) {
        if (motion->frame) {
            frame = motion->frame;
        }
        if (motion->base_matrix) {
            base_matrix = motion->base_matrix;
        }
        frame_id = motion->frame_id;
    }
    return 1;
}

PORT_OVERRIDE void mgCVisualMotionMDT::CreateVertexWeight(u_int *data, int selected_frame, mgCMemory *memory) {
    weight = nullptr;
    weight_num = 0;
    for (int &slot : bone) {
        slot = -1;
    }
    if (!data || !memory) {
        std::fprintf(stderr, "animation: native weight source identity required\n");
        return;
    }
    try {
        weight_num = vertex_num;
        weight = new (memory->Alloc((vertex_num * sizeof(mgVertexWeight) + 15) / 16 + 2)) mgVertexWeight[vertex_num]{};
        int            slots = 0;
        tagMOTION_TYPE resource{};
        std::string    error;
        const auto     path = DataReadBufferPath(data);
        if (!path) {
            std::fprintf(stderr, "animation: direct glTF weight path required\n");
            return;
        }
        const bool loaded = model_assets::LoadAnimation(std::filesystem::path(*path), resource, *memory, std::nullopt, std::nullopt, 0, std::nullopt, error);
        if (!loaded) {
            throw std::runtime_error(error);
        }
        auto *channels = resource.skin_list;
        for (auto *channel = channels; channel; channel = channel->next) {
            if (channel->frame != selected_frame || !channel->key_count) {
                continue;
            }
            int slot = 0;
            while (slot < slots && bone[slot] != channel->target) {
                ++slot;
            }
            if (slot == slots) {
                if (slots == 32) {
                    throw std::runtime_error("native visual exceeds 32 bones");
                }
                bone[slots++] = channel->target;
            }
            for (u32 key = 0; key < channel->key_count; ++key) {
                if (channel->key_frames[key] >= static_cast<u32>(weight_num)) {
                    throw std::runtime_error("native vertex weight index out of range");
                }
                auto &value = weight[channel->key_frames[key]];
                int   influence = 0;
                while (influence < 4 && value.weight[influence] != 0) {
                    ++influence;
                }
                if (influence < 4) {
                    value.matrix[influence] = slot * 4;
                    value.weight[influence] = channel->values[key][0] / 100.0f;
                }
            }
        }
        for (int vertex = 0; vertex < weight_num; ++vertex) {
            auto &value = weight[vertex];
            float total = value.weight[0] + value.weight[1] + value.weight[2] + value.weight[3];
            if (total > 0 && total < 1) {
                for (auto &component : value.weight) {
                    component /= total;
                }
            }
            if (total == 0) {
                value.weight[0] = 1;
            }
        }
    } catch (const std::exception &error) {
        weight = nullptr;
        weight_num = 0;
        std::fprintf(stderr, "animation: %s\n", error.what());
    }
}

PORT_OVERRIDE int mgCVisualMotionMDT::CreateFaceMotionPacket(u_int *packet, mgCFace *face, mgCVMotionData *motion) {
    if (face != NULL) {
        mgVisualPortRefreshFace(this, face);
    }
    return 0;
}

PORT_OVERRIDE int mgCVisualMotionMDT::CreateExtRenderInfoPacket(u_int         *packet, float (*matrix)[4],
                                                                mgRENDER_INFO *info) {
    if (model_assets::ApplySkin(*this, matrix)) {
        return 0;
    }
    if (frame == NULL || base_matrix == NULL) {
        return 0;
    }

    int slot_count = 0;
    while (slot_count < 0x20 && bone[slot_count] >= 0) {
        slot_count += 1;
    }

    if (slot_count == 0) {
        return 0;
    }

    float inverse_matrix[4][4];
    float root_matrix[4][4];
    float inverse_root[4][4];
    float root_local[4][4];
    float slot_matrix[4][4];
    float slot_inverse[4][4];
    float frame_matrix[4][4];
    float bone_matrix[4][4];

    mgInversMatrix(inverse_matrix, matrix);
    frame[0]->GetLWMatrix(root_matrix);
    mgMulMatrix(inverse_root, root_matrix, base_matrix[frame_id]);
    mgInversMatrix(root_local, inverse_root);

    gfx::Prog0Constants &prog0 = mgVisualPortCurrentProg0();

    for (int i = 0; i < slot_count; i++) {
        const int slot = bone[i];
        if (frame[slot] == NULL) {
            continue;
        }

        frame[slot]->GetLWMatrix(frame_matrix);
        mgMulMatrix(slot_matrix, root_matrix, base_matrix[slot]);
        mgMulMatrix(slot_matrix, root_local, slot_matrix);
        mgInversMatrix(slot_inverse, slot_matrix);
        mgMulMatrix(frame_matrix, inverse_matrix, frame_matrix);
        mgMulMatrix(bone_matrix, frame_matrix, slot_inverse);

        for (int row = 0; row < 3; row++) {
            for (int col = 0; col < 4; col++) {
                prog0.bones[i][row][col] = bone_matrix[col][row];
            }
        }
    }

    return 0;
}
