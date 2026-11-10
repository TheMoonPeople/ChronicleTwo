#include "common.h"

#include <libvu0.h>

#include <cstring>

#include "collision.hpp"
#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"

int CCollision::InsidePoint(float *point) {
    return mgClipBoxVertex(point, bbox.max, bbox.min) != 0;
}

/**
 *
 * Holds one quadword of collision polygon data for block copying.
 *
 */
struct CollisionQuad {
    float v[4]; /**< Four words copied together. */
};

/**
 *
 * Holds the five quadwords copied for one collision triangle.
 *
 */
struct CollisionTri {
    CollisionQuad q[5]; /**< Polygon data blocks. */
};

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u_int Align16Blocks(u_int n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

void CCollisionMDT::Copy(CCollisionMDT &dest, mgCMemory *memory) {
    int           i = {};
    CollisionTri *src = {};
    CollisionTri *dst = {};
    dest.bbox = bbox;
    dest.poly_count = poly_count;

    if (dest.poly_count <= 0) {
        dest.poly = nullptr;
        return;
    }

    if (memory != nullptr) {
        dest.poly = new (memory->Alloc(Align16Blocks(dest.poly_count * sizeof(CCPoly)) + 2)) CCPoly[dest.poly_count];
        i = 0;

        if (dest.poly != nullptr) {

            for (; i < dest.poly_count; i++) {
                src = reinterpret_cast<CollisionTri *>(&poly[i]);
                dst = reinterpret_cast<CollisionTri *>(&dest.poly[i]);
                dst->q[0] = src->q[0];
                dst->q[1] = src->q[1];
                dst->q[2] = src->q[2];
                dst->q[3] = src->q[3];
                dst->q[4] = src->q[4];
            }
        }
    } else {
        dest.poly = poly;
    }
}

void CCollisionMDT::CreateBBox() {
    float   polygon_max[4];
    float   polygon_min[4];
    int     index = {};
    CCPoly *polygon = {};

    bbox.min[0] = 0.0f;
    bbox.max[0] = 0.0f;
    bbox.min[1] = 0.0f;
    bbox.max[1] = 0.0f;
    bbox.min[2] = 0.0f;
    bbox.max[2] = 0.0f;
    bbox.min[3] = 1.0f;
    bbox.max[3] = 1.0f;

    polygon = poly;

    if (polygon == nullptr || poly_count <= 0) {
        return;
    }

    mgVectorMaxMin(bbox.max, bbox.min, polygon->vertex[0], polygon->vertex[1], polygon->vertex[2]);

    for (index = 0; index < poly_count; index++, polygon++) {
        mgVectorMaxMin(polygon_max, polygon_min, polygon->vertex[0], polygon->vertex[1], polygon->vertex[2]);
        mgVectorMaxMin(bbox.max, bbox.min, bbox.max, bbox.min, polygon_max, polygon_min);
    }
}

int CCollisionMDT::GetMaxY(float *position) {
    float   from[4];
    float   to[4];
    float   hit[4];
    int     i = {};
    int     found = {};
    CCPoly *cursor = {};
    float   max_y = {};

    cursor = poly;

    if (cursor == nullptr) {
        return false;
    }

    if (!(position[0] <= bbox.max[0])) {
        return false;
    }

    if (!(position[2] <= bbox.max[2])) {
        return false;
    }

    if (position[0] < bbox.min[0]) {
        return false;
    }

    if (position[2] < bbox.min[2]) {
        return false;
    }

    from[0] = to[0] = position[0];
    from[2] = to[2] = position[2];
    from[1] = 0.0f;
    found = false;
    max_y = -1e8f;
    to[1] = 1.0f;

    for (i = 0; i < poly_count; i++, cursor++) {
        if (mgIntersectionPoint_line_poly3(from, to, cursor->vertex[0], cursor->vertex[1], cursor->vertex[2], cursor->normal, hit) != 0) {
            found = true;

            if (max_y < hit[1]) {
                max_y = hit[1];
            }
        }
    }

    position[1] = max_y;
    return found;
}

int CCollision::Intersection(float *from, float *to, float *hit) {
    return 0;
}

int CColFrame::InsidePoint(float *point) {
    sceVu0FVECTOR local_point;
    sceVu0FMATRIX lw_matrix;
    sceVu0FMATRIX inverse_matrix;

    if (collision == nullptr) {
        return false;
    }

    GetLWMatrix(lw_matrix);
    GetInverseMatrix(inverse_matrix);
    point[3] = 1.0f;
    sceVu0ApplyMatrix(local_point, inverse_matrix, point);
    return collision->InsidePoint(local_point);
}

int CColFrame::PickUpNearPoly(CCPoly *out, const mgVu0FBOX &box, int max) {
    sceVu0FVECTOR corners[8];
    sceVu0FVECTOR transformed[8];
    sceVu0FVECTOR max0;
    sceVu0FVECTOR min0;
    sceVu0FVECTOR max1;
    sceVu0FVECTOR min1;
    sceVu0FVECTOR bmin;
    sceVu0FVECTOR bmax;
    sceVu0FMATRIX world;
    sceVu0FMATRIX inverse;
    mgVu0FBOX     local_box{};
    int           count = {};
    int           i = {};
    CColFrame    *node = {};
    int           added = {};

    count = 0;

    if (flags == COL_FRAME_FLAG_NO_CHILDREN) {
        return 0;
    }

    if (collision != nullptr && (flags & COL_FRAME_FLAG_SELF)) {
        GetLWMatrix(world);
        GetInverseMatrix(inverse);
        std::memmove(bmin, box.min, sizeof(float) * 4);
        std::memmove(bmax, box.max, sizeof(float) * 4);
        corners[0][0] = bmin[0];
        corners[0][1] = bmin[1];
        corners[0][2] = bmin[2];
        corners[0][3] = 1.0f;
        corners[1][0] = bmax[0];
        corners[1][1] = bmin[1];
        corners[1][2] = bmin[2];
        corners[1][3] = 1.0f;
        corners[2][0] = bmin[0];
        corners[2][1] = bmax[1];
        corners[2][2] = bmin[2];
        corners[2][3] = 1.0f;
        corners[3][0] = bmax[0];
        corners[3][1] = bmax[1];
        corners[3][2] = bmin[2];
        corners[3][3] = 1.0f;
        corners[4][0] = bmin[0];
        corners[4][1] = bmin[1];
        corners[4][2] = bmax[2];
        corners[4][3] = 1.0f;
        corners[5][0] = bmax[0];
        corners[5][1] = bmin[1];
        corners[5][2] = bmax[2];
        corners[5][3] = 1.0f;
        corners[6][0] = bmin[0];
        corners[6][1] = bmax[1];
        corners[6][2] = bmax[2];
        corners[6][3] = 1.0f;
        corners[7][0] = bmax[0];
        corners[7][1] = bmax[1];
        corners[7][2] = bmax[2];
        corners[7][3] = 1.0f;
        mgApplyMatrixN(transformed, inverse, corners, 8);
        mgVectorMaxMin(max0, min0, transformed[0], transformed[1], transformed[2], transformed[3]);
        mgVectorMaxMin(max1, min1, transformed[4], transformed[5], transformed[6], transformed[7]);
        mgVectorMaxMin(local_box.max, local_box.min, max0, max1, min0, min1);
        count = collision->PickUpNearPoly(out, local_box, max);
        pre_trance_normal(world);

        for (i = 0; i < count; i++) {
            trance_normal(out->vertex[0], out->vertex[1], out->vertex[2], out->normal);
            out++;
        }
    }

    max -= count;

    if (max <= 0) {
        return count;
    }

    if (!(flags & COL_FRAME_FLAG_NO_CHILDREN)) {
        for (node = static_cast<CColFrame *>(child); node != nullptr; node = static_cast<CColFrame *>(node->brother)) {
            if (!(flags & COL_FRAME_FLAG_UNK_4)) {
                added = node->PickUpNearPoly(out, box, max);
                out += added;
                count += added;
                max -= added;

                if (max <= 0) {
                    break;
                }
            }
        }
    }

    return count;
}

int CCollision::PickUpNearPoly(CCPoly *poly, const mgVu0FBOX &box, int max) {
    return 0;
}

int CColFrame::GetWorldBBox(mgVu0FBOX *box) {
    mgVu0FBOX *result = box;
    mgVu0FBOX  world_box{};
    float      matrix[4][4];
    mgVu0FBOX  child_box{};
    int        found = false;
    mgCFrame  *node = this;

    if (collision != nullptr && bound != nullptr) {
        found = true;
        GetLWMatrix(matrix);
        mgApplyMatrix(world_box.max, world_box.min, matrix, bound->max, bound->min);
    }

    for (node = node->child; node != nullptr; node = node->brother) {
        if (node->GetWorldBBox(&child_box) != 0) {
            if (!found) {
                world_box = child_box;
            } else {
                mgVectorMaxMin(world_box.max, world_box.min, world_box.max, world_box.min, child_box.max,
                               child_box.min);
            }

            found = true;
        }
    }

    *result = world_box;
    return found;
}

CColFrame *LoadCollisionFile(MDS_HEADER *header, mgCMemory *memory);

void CColFrame::Initialize() {
    flags = COL_FRAME_FLAG_SELF;
    collision = nullptr;
    mgCFrame::Initialize();
}

CColFrame::CColFrame() {
    Initialize();
}

CCollisionMDT *CreateCollisionMDT(u_int *model, mgCMemory *memory);

void CCollisionMDT::Initialize() {
    CCollision::Initialize();
    poly = nullptr;
    poly_count = 0;
}

void CCollision::Copy(CCollision &dest, mgCMemory *memory) {
    dest.bbox = bbox;
}

#include "common.h"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "collision.hpp"
#include "collision_assets.hpp"
#include "log/log.hpp"
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
    std::ranges::copy(polygons, collision->poly);
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
        {.type = MG_VISUAL_CREATE_MDT, .name = default_name},
        {.type = MG_VISUAL_CREATE_END, .name = nullptr     }
    };
    mgLoadData load{};
    load.memory = memory;
    load.visual_type = visual_types;
    std::string error;
    auto       *frames = scene.empty() ? model_assets::LoadModel(path, load, error)
                                       : model_assets::LoadModelScene(path, scene, load, error);
    if (!frames) {
        CT_LOG_ERROR(Data, "collision: {}", error);
    }
    return frames;
}
} // namespace

CColFrame *LoadCollisionFile(MDS_HEADER *header, mgCMemory *memory) {
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

CCollisionMDT *CreateCollisionMDT(u_int *model, mgCMemory *memory) {
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

#include "common.h"

#include <cstring>

#include "collision.hpp"
#include "mg_math.hpp"
#include "stubs/collision.hpp"
#include "vu0_lanes.hpp"

namespace {

// Retail parks the matrix in vf10-vf13 between pre_trance_normal and the trance_normal calls after it.
float trance_matrix[4][4];

} // namespace

int CCollisionMDT::PickUpNearPoly(CCPoly *out, const mgVu0FBOX &box, int max) {
    sceVu0FVECTOR box_max;
    sceVu0FVECTOR box_min;
    sceVu0FVECTOR poly_max;
    sceVu0FVECTOR poly_min;
    int           i = 0;
    int           count = 0;
    CCPoly       *polygon = nullptr;

    if (poly == nullptr) {
        return 0;
    }

    if (!(box.min[0] <= bbox.max[0])) {
        return 0;
    }

    if (!(box.min[1] <= bbox.max[1])) {
        return 0;
    }

    if (!(box.min[2] <= bbox.max[2])) {
        return 0;
    }

    if (box.max[0] < bbox.min[0]) {
        return 0;
    }

    if (box.max[1] < bbox.min[1]) {
        return 0;
    }

    if (box.max[2] < bbox.min[2]) {
        return 0;
    }

    i = 0;
    count = 0;
    const volatile mgVu0FBOX &volatile_box = box;
    box_max[0] = volatile_box.max[0];
    box_max[1] = volatile_box.max[1];
    box_max[2] = volatile_box.max[2];
    box_max[3] = 1.0f;
    box_min[0] = box.min[0];
    box_min[1] = box.min[1];
    box_min[2] = box.min[2];
    box_min[3] = 1.0f;
    polygon = poly;
    for (; i < poly_count; i++, polygon++) {
        mgVectorMaxMin(poly_max, poly_min, polygon->vertex[0], polygon->vertex[1], polygon->vertex[2]);

        if (mgClipBox(box_max, box_min, poly_max, poly_min)) {
            std::memcpy(out->vertex[0], polygon->vertex[0], sizeof(sceVu0FVECTOR));
            std::memcpy(out->vertex[1], polygon->vertex[1], sizeof(sceVu0FVECTOR));
            std::memcpy(out->vertex[2], polygon->vertex[2], sizeof(sceVu0FVECTOR));
            out->ground_kind = polygon->ground_kind;
            out->foot_sound = polygon->foot_sound;
            out->area_kind = polygon->area_kind;
            out->ignore_mask = polygon->ignore_mask;
            out->parts_no = polygon->parts_no;
            out->attr = polygon->attr;
            out->attr_value = polygon->attr_value;
            std::memcpy(out->normal, polygon->normal, sizeof(sceVu0FVECTOR));
            max--;
            count++;
            out++;

            if (max <= 0) {
                break;
            }
        }
    }

    return count;
}

void pre_trance_normal(float (*matrix)[4]) {
    std::memcpy(trance_matrix, matrix, sizeof(trance_matrix));
}

// Retail loads the three corners from v0 onward and stores them back through v0, v1 and v2; every
// caller passes contiguous corners, so the reads and the writes agree.
void trance_normal(float *v0, float *v1, float *v2, float *normal) {
    float corners[3][4];
    float transformed[3][4];

    std::memcpy(corners, v0, sizeof(corners));

    for (int corner = 0; corner < 3; corner++) {
        vu0::Transform(transformed[corner], trance_matrix, corners[corner]);
    }

    std::memcpy(v0, transformed[0], sizeof(transformed[0]));
    std::memcpy(v1, transformed[1], sizeof(transformed[1]));
    std::memcpy(v2, transformed[2], sizeof(transformed[2]));

    float edge0[3];
    float edge1[3];

    for (int lane = 0; lane < 3; lane++) {
        edge0[lane] = transformed[1][lane] - transformed[0][lane];
        edge1[lane] = transformed[2][lane] - transformed[0][lane];
    }

    normal[0] = edge0[1] * edge1[2] - edge1[1] * edge0[2];
    normal[1] = edge0[2] * edge1[0] - edge1[2] * edge0[0];
    normal[2] = edge0[0] * edge1[1] - edge1[0] * edge0[1];
    // vopmsub.xyz never writes w, so the retail store takes a stale lane; zero is the deterministic stand-in.
    normal[3] = 0.0f;
}
