#include "common.h"

#include <cstdio>
#include <cstring>
#include <limits>

#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "visualmotion.hpp"

void mgCVisualMotionMDT::Initialize() {
    mgCVisualMDT::Initialize();

    for (int bone_index = 0; bone_index < 32; bone_index++) {
        bone[bone_index] = -1;
    }

    vu1_base = 0x7C;
    vu1_offset = 0x94;
    weight_num = 0;
    weight = nullptr;
    base_matrix = nullptr;
    frame_id = 0;
}

/**
 *
 * Header of a vertex weight block in motion data.
 *
 */
struct VertexWeightBlock {
    u_int frame_id; /**< Frame to which the weights belong. */
    int   bone_id;  /**< Bone that weights the vertices. */
    u_int unk_08[2];
    u_int count; /**< Number of weight entries. */
    u_int next;  /**< Offset of the next block. */
    u_int unk_18[2];
};

/**
 *
 * Weight of one vertex for a bone in motion data.
 *
 */
struct VertexWeightEntry {
    u_int vertex_id; /**< Vertex that receives the weight. */
    u_int unk_04[3];
    float weight; /**< Bone's influence on the vertex. */
    u_int unk_14[3];
};

mgVertexWeight::mgVertexWeight() {
    memset(this, 0, sizeof(*this));
}

void mgCVisualMotionMDT::ChangeWeight(mgCFrame **new_frames, float (*matrix)[4][4], int count) {
    for (int bone_index = 0; bone_index < 32; bone_index++) {
        int old = bone[bone_index];

        if (old < 0) {
            break;
        }

        bone[bone_index] = (*new_frames)->SearchFrameID(this->frame[old]->name);
    }

    this->frame = new_frames;
    this->base_matrix = matrix;
    this->frame_id = count;
}

/**
 *
 * Header for the vertex streams written to a motion packet.
 *
 */
struct mgVertexBatchHeader {
    int stream_count[3]; /**< Number of entries in each vertex stream. */
    int type;            /**< Vertex batch type. */
};

u_long128 *SetData0(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *normal_out = {};
    u_long128           *uv_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = count;
    header->stream_count[1] = count;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *normal_base = packet + 1;
    normal_out = count + normal_base;
    uv_out = normal_out + count;
    weight_out = uv_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        *uv_out++ = uv[cursor[2]];
        cursor += 3;
    }

    *index = cursor;
    return weight_out;
}

u_long128 *SetData1(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *normal_out = {};
    u_long128           *uv_out = {};
    u_long128           *colour_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = count;
    header->stream_count[1] = count;
    header->stream_count[2] = count;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    uv_out = normal_out + count;
    colour_out = uv_out + count;
    weight_out = colour_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        *uv_out++ = uv[cursor[2]];
        *colour_out++ = colour[cursor[3]];
        cursor += 4;
    }

    *index = cursor;
    return weight_out;
}

u_long128 *SetData2(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *normal_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    weight_out = normal_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        cursor += 2;
    }

    *index = cursor;
    return weight_out;
}

u_long128 *SetData3(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *normal_out = {};
    u_long128           *colour_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = count;
    header->stream_count[1] = count;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    colour_out = normal_out + count;
    weight_out = colour_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        *colour_out++ = colour[cursor[2]];
        cursor += 3;
    }

    *index = cursor;
    return weight_out;
}

u_long128 *SetData4(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *uv_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    uv_out = count + stream_base;
    weight_out = uv_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        *uv_out++ = uv[cursor[1]];
        cursor += 2;
    }

    *index = cursor;
    return weight_out;
}

u_long128 *SetData5(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *uv_out = {};
    u_long128           *colour_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = count;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    uv_out = count + stream_base;
    colour_out = uv_out + count;
    weight_out = colour_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        *uv_out++ = uv[cursor[1]];
        *colour_out++ = colour[cursor[2]];
        cursor += 3;
    }

    *index = cursor;
    return weight_out;
}

u_long128 *SetData6(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = 0;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    weight_out = count + stream_base;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        cursor += 1;
    }

    *index = cursor;
    return weight_out;
}

u_long128 *SetData7(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = reinterpret_cast<mgVertexBatchHeader *>(packet);
    u_long128           *vertex_out = {};
    u_long128           *colour_out = {};
    u_long128           *weight_out = {};
    int                 *cursor = {};

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    colour_out = count + stream_base;
    weight_out = colour_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[0];
        weight_out[1] = (reinterpret_cast<u_long128 *>(&weight[cursor[0]]))[1];
        weight_out += 2;
        *colour_out++ = colour[cursor[1]];
        cursor += 2;
    }

    *index = cursor;
    return weight_out;
}

static u_long128 *(*set_data_func[8])(int, int, int **, u_long128 *, u_long128 *, u_long128 *, u_long128 *, u_long128 *, mgVertexWeight *) = {
    SetData0, SetData1, SetData2, SetData3, SetData4, SetData5, SetData6, SetData7};

int mgCVisualMotionMDT::CreateRenderInfoPacket(u_int         *packet, float (*matrix)[4],
                                               mgRENDER_INFO *render_info) {
    render_info->motion = 1;
    int size = mgCVisualMDT::CreateRenderInfoPacket(packet, matrix, render_info);
    render_info->motion = 0;
    return size;
}

void mgCVisualMotionMDT::SetBaseBox(float *box_max, float *box_min) {
    std::memmove(base_box.max, box_max, sizeof(float) * 4);
    box_max[3] = 1.0f;
    std::memmove(base_box.min, box_min, sizeof(float) * 4);
    box_min[3] = 1.0f;
}

int mgCVisualMotionMDT::CreateBBox(float *box_max, float *box_min, float (*matrix)[4]) {
    float  merged_max[4];
    float  merged_min[4];
    float  frame_max[4];
    float  frame_min[4];
    float  center[4];
    float  corners[8][4];
    float  transformed[8][4];
    float  origins[8][4];
    float *bounds[4];
    float  inverse_matrix[4][4];
    float  inverse_root[4][4];
    float  root_local[4][4];
    float  root_matrix[4][4];
    float  slot_matrix[4][4];
    float  slot_inverse[4][4];
    float  frame_matrix[4][4];
    int    slot_count = {};
    int    i = {};
    int    slot = {};
    int    corner = {};

    slot_count = 0;

    do {
        if (bone[slot_count] < 0) {
            break;
        }

        slot_count += 1;
    } while (slot_count < 0x20);

    if (slot_count == 0) {
        return false;
    }

    sceVu0AddVector(center, base_box.max, base_box.min);
    sceVu0ScaleVector(center, center, 0.5f);
    bounds[0] = base_box.max;
    bounds[1] = base_box.min;

    for (corner = 0; corner < 8; corner++) {
        corners[corner][3] = 1.0f;
        corners[corner][0] = bounds[(corner & 1) != 0][0];
        corners[corner][1] = bounds[(corner & 2) != 0][1];
        corners[corner][2] = bounds[(corner & 4) != 0][2];
        mgZeroVector(origins[corner]);
    }

    mgInversMatrix(inverse_matrix, matrix);
    frame[0]->GetLWMatrix(root_matrix);
    mgMulMatrix(inverse_root, root_matrix, base_matrix[frame_id]);
    mgInversMatrix(root_local, inverse_root);
    i = 0;

    if (0 < slot_count) {
        do {
            slot = bone[i];

            if (frame[slot] != nullptr) {
                frame[slot]->GetLWMatrix(frame_matrix);
                mgMulMatrix(slot_matrix, root_matrix, base_matrix[slot]);
                mgMulMatrix(slot_matrix, root_local, slot_matrix);
                mgInversMatrix(slot_inverse, slot_matrix);
                mgMulMatrix(frame_matrix, inverse_matrix, frame_matrix);
                mgMulMatrix(frame_matrix, frame_matrix, slot_inverse);
                mgApplyMatrixN(transformed, frame_matrix, corners, 8);

                if (i == 0) {
                    mgVectorMinMaxN(merged_max, merged_min, transformed, 8);
                } else {
                    mgVectorMinMaxN(frame_max, frame_min, transformed, 8);
                    mgVectorMaxMin(merged_max, merged_min, merged_max, merged_min, frame_max,
                                   frame_min);
                }
            }

            i += 1;
        } while (i < slot_count);
    }

    std::memmove(box_max, merged_max, sizeof(float) * 4);
    std::memmove(box_min, merged_min, sizeof(float) * 4);
    box_max[3] = 1.0f;
    box_min[3] = 1.0f;
    return true;
}

mgCVisual *mgCVisualMotionMDT::Copy(mgCMemory *memory) {
    if (!clone_inputs.Matches(this)) {
        return nullptr;
    }
    if (memory == nullptr || material_num < 0 || (material_num > 0 && material == nullptr)) {
        return nullptr;
    }
    constexpr auto object_blocks = (sizeof(mgCVisualMotionMDT) + 15) / 16 + 2;
    if (memory->stGetRest() <= static_cast<int>(object_blocks)) {
        return nullptr;
    }
    auto *storage = memory->Alloc(static_cast<int>(object_blocks));
    if (storage == nullptr) {
        return nullptr;
    }
    auto *copy = new (storage) mgCVisualMotionMDT;

    *copy = *this;

    if (material_num > 0) {
        const std::size_t bytes = static_cast<std::size_t>(material_num) * sizeof(mgMaterial);
        const std::size_t blocks = (bytes + 15) / 16 + 2;
        if (blocks > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
            memory->stGetRest() <= 0 || blocks >= static_cast<std::size_t>(memory->stGetRest())) {
            return nullptr;
        }
        auto *materials = memory->Alloc(static_cast<int>(blocks));
        if (materials == nullptr) {
            return nullptr;
        }
        copy->material = new (materials) mgMaterial[material_num];
    }

    for (int material_index = 0; material_index < material_num; material_index++) {
        copy->material[material_index] = material[material_index];
    }

    if (!dc2::render::VisualCloneInputs::Publish(*memory, *copy, dc2::render::VisualCloneKind::MotionMdt)) {
        return nullptr;
    }
    return copy;
}

int mgCVisualMotionMDT::Iam() {
    return MG_VISUAL_KIND_MOTION_MDT;
}

#include "common.h"

#include <cstdio>
#include <stdexcept>
#include <utility>

#include "assets/data_registry.hpp"
#include "gameutil.hpp"
#include "log/log.hpp"
#include "mg_dataset.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"
#include "render/visual_mesh.hpp"
#include "visualmotion.hpp"

int mgCVisualMotionMDT::DataAssignMotionMDT(MDT_HEADER *header, mgCVMotionData *motion,
                                            mgCMemory         *memory, mgCMemory         */*work*/,
                                            mgCTextureManager *textures) {
    if (!header || !memory) {
        CT_LOG_ERROR(Gfx, "animation: native glTF source required for skinned visual assignment");
        return 0;
    }
    char               empty[] = "";
    mgCreateVisualType types[] = {
        {.type = MG_VISUAL_CREATE_MOTION_MDT, .name = empty  },
        {.type = MG_VISUAL_CREATE_END,        .name = nullptr}
    };
    mgLoadData load{};
    load.memory = memory;
    load.texture_manager = textures;
    load.visual_type = types;
    std::string error;
    const auto  path = DataReadBufferPath(header);
    if (!path) {
        CT_LOG_ERROR(Gfx, "animation: direct glTF visual path required");
        return 0;
    }
    auto *root = model_assets::LoadModel(std::filesystem::path(*path), load, error);
    auto *selected = root && motion && motion->frame_id >= 0 && motion->frame_id < root->frame_num ? root->GetFrame(motion->frame_id) : root;
    if (!selected || !selected->visual || selected->visual->Iam() != MG_VISUAL_KIND_MOTION_MDT) {
        CT_LOG_ERROR(Gfx, "animation: {}", error.empty() ? "native skinned visual absent" : error.c_str());
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

void mgCVisualMotionMDT::CreateVertexWeight(u_int *data, int selected_frame, mgCMemory *memory) {
    weight = nullptr;
    weight_num = 0;
    for (int &slot : bone) {
        slot = -1;
    }
    if (!data || !memory || vertex_num <= 0) {
        CT_LOG_ERROR(Gfx, "animation: native weight source identity required");
        return;
    }
    try {
        const std::size_t bytes = static_cast<std::size_t>(vertex_num) * sizeof(mgVertexWeight);
        const std::size_t blocks = (bytes + 15) / 16 + 2;
        if (blocks > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
            memory->stGetRest() <= 0 || blocks >= static_cast<std::size_t>(memory->stGetRest())) {
            throw std::runtime_error("native visual weight count exceeds arena limits");
        }
        auto *storage = memory->Alloc(static_cast<int>(blocks));
        if (storage == nullptr) {
            throw std::runtime_error("native visual weight arena is unavailable");
        }
        weight_num = vertex_num;
        weight = new (storage) mgVertexWeight[vertex_num]{};
        int            slots = 0;
        tagMOTION_TYPE resource{};
        std::string    error;
        const auto     path = DataReadBufferPath(data);
        if (!path) {
            CT_LOG_ERROR(Gfx, "animation: direct glTF weight path required");
            return;
        }
        const bool loaded = model_assets::LoadAnimation(std::filesystem::path(*path), resource, *memory, std::nullopt, std::nullopt, 0, std::nullopt, error);
        if (!loaded) {
            throw std::runtime_error(error);
        }
        for (auto *channel = resource.skin_list; channel; channel = channel->next) {
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
                if (std::cmp_greater_equal(channel->key_frames[key], weight_num)) {
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
        CT_LOG_ERROR(Gfx, "animation: {}", error.what());
    }
}

int mgCVisualMotionMDT::CreateFaceMotionPacket(u_int * /*packet*/, mgCFace *face, mgCVMotionData * /*motion*/) {
    if (face != nullptr) {
        mgVisualPortRefreshFace(this, face);
    }
    return 0;
}

int mgCVisualMotionMDT::CreateExtRenderInfoPacket(u_int * /*packet*/, float (*matrix)[4],
                                                  mgRENDER_INFO * /*info*/) {
    if (model_assets::ApplySkin(*this, matrix)) {
        return 0;
    }
    if (frame == nullptr || base_matrix == nullptr) {
        return 0;
    }

    int slot_count = 0;
    while (slot_count < 32 && bone[slot_count] >= 0) {
        ++slot_count;
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

    gfx::Prog0Palette &palette = mgVisualPortCurrentPalette();

    for (int i = 0; i < slot_count; i++) {
        const int slot = bone[i];
        if (frame[slot] == nullptr) {
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
                palette.bones[i][row][col] = bone_matrix[col][row];
            }
        }
    }

    return 0;
}
