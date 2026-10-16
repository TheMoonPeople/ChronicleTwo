#include "common.h"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

#include "collision.hpp"
#include "collision_assets.hpp"
#include "dataread_port.hpp"
#include "mg_math.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"
#include "texture_source.hpp"

namespace {
/**
 * Allocates an aligned native object array from the game's arena.
 */
template <typename T>
T *Allocate(mgCMemory &memory, std::size_t count = 1) {
    return new (memory.Alloc((sizeof(T) * count + 15) / 16 + 2)) T[count];
}

/**
 * Creates collision polygons from a native glTF visual and its material controls.
 */
CCollisionMDT *BuildCollision(const mgCVisualMDT &visual, mgCMemory &memory) {
    std::vector<CCPoly> polygons;
    for (auto *group = visual.face_group; group; group = group->next) {
        for (auto *face = group->face; face; face = face->next) {
            if ((face->type & MG_FACE_PRIM_MASK) == MG_PRIM_TRIANGLE_STRIP || (face->type & MG_FACE_COLOUR)) {
                return nullptr;
            }
            for (int corner = 0; corner + 2 < face->vertex_num; corner += 3) {
                CCPoly polygon{};
                for (int vertex = 0; vertex < 3; ++vertex) {
                    const int index = face->index[(corner + vertex) * face->index_stride];
                    if (index < 0 || index >= visual.vertex_num) {
                        return nullptr;
                    }
                    std::memcpy(polygon.vertex[vertex], visual.vertex[index], sizeof(sceVu0FVECTOR));
                }
                if (face->material >= 0 && face->material < visual.material_num) {
                    const auto &diffuse = visual.material[face->material].diffuse;
                    polygon.ground_kind = diffuse[0] * 0.7f + 0.01f;
                    polygon.foot_sound = diffuse[1] * 0.7f + 0.01f;
                    polygon.area_kind = diffuse[2] * 0.7f + 0.01f;
                    polygon.ignore_mask = 1.0f - diffuse[3];
                }
                mgPlaneNormal(polygon.normal, polygon.vertex[0], polygon.vertex[1], polygon.vertex[2]);
                polygons.push_back(polygon);
            }
        }
    }
    auto *collision = Allocate<CCollisionMDT>(memory);
    collision->poly_count = static_cast<int>(polygons.size());
    collision->poly = Allocate<CCPoly>(memory, polygons.size());
    std::copy(polygons.begin(), polygons.end(), collision->poly);
    collision->CreateBBox();
    return collision;
}

/**
 * Loads collision geometry directly from a bounded glTF file buffer.
 */
mgCFrame *LoadGeometry(const std::filesystem::path &path, mgCMemory *memory, std::string_view scene = {}) {
    if (!memory) {
        return nullptr;
    }
    char               default_name[] = "";
    mgCreateVisualType visual_types[] = {
        {MG_VISUAL_CREATE_MDT, default_name},
        {MG_VISUAL_CREATE_END, nullptr     }
    };
    mgLoadData load{};
    load.memory = memory;
    load.visual_type = visual_types;
    std::string error;
    auto       *frames = scene.empty() ? model_assets::LoadModel(path, load, error)
                                       : model_assets::LoadModelScene(path, scene, load, error);
    if (!frames) {
        std::fprintf(stderr, "collision: %s\n", error.c_str());
    }
    return frames;
}
} // namespace

PORT_OVERRIDE CColFrame *LoadCollisionFile(MDS_HEADER *header, mgCMemory *memory) {
    const auto path = DataReadBufferPath(header);
    return path ? LoadCollisionModel(*path, memory) : nullptr;
}

CColFrame *LoadCollisionModel(const std::filesystem::path &path, mgCMemory *memory, std::string_view scene) {
    auto *native = LoadGeometry(path, memory, scene);
    if (!native || native->frame_num <= 0) {
        return nullptr;
    }
    const auto count = static_cast<std::size_t>(native->frame_num);
    auto      *frames = Allocate<CColFrame>(*memory, count);
    for (std::size_t index = 0; index < count; ++index) {
        auto &source = *native->frame_list[index];
        auto &frame = frames[index];
        frame.SetName(source.name);
        float local_matrix[4][4];
        source.GetLocalMatrix(local_matrix);
        frame.SetTransMatrix(local_matrix);
        if (source.parent) {
            for (std::size_t parent = 0; parent < count; ++parent) {
                if (native->frame_list[parent] == source.parent) {
                    frame.SetParent(&frames[parent]);
                    break;
                }
            }
        }
        if (source.visual) {
            frame.collision = BuildCollision(*static_cast<mgCVisualMDT *>(source.visual), *memory);
            if (frame.collision) {
                frame.bound = Allocate<mgCFrame::BoundInfo>(*memory);
                frame.SetBBox(frame.collision->bbox.max, frame.collision->bbox.min);
            }
        }
    }
    return frames;
}

PORT_OVERRIDE CCollisionMDT *CreateCollisionMDT(u_int *model, mgCMemory *memory) {
    const auto path = DataReadBufferPath(model);
    auto      *frames = path ? LoadGeometry(*path, memory) : nullptr;
    if (!frames) {
        return nullptr;
    }
    for (int index = 0; index < frames->frame_num; ++index) {
        if (auto *visual = frames->frame_list[index]->visual) {
            return BuildCollision(*static_cast<mgCVisualMDT *>(visual), *memory);
        }
    }
    return nullptr;
}
