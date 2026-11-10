#include "common.h"

#include <libvu0.h>

#include <array>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <limits>
#include <stdexcept>
#include <vector>

#include "dng_main.hpp"
#include "font.hpp"
#include "gameutil.hpp"
#include "intersection.hpp"
#include "log/game_output.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"

static mgCFrame *OldSkinFrame;

/**
 *
 * Blends rotation quaternion keys and writes the resulting rotation.
 *
 */
static void QuatSlerp(float *q0, float *q1, float t, float *out) {
    float cos_theta = {};
    float scale0 = {};
    float scale1 = {};
    float theta = {};
    float inv_sin = {};

    cos_theta =
        (q0[3] * q1[3]) + ((q0[1] * q1[1]) + (q0[2] * q1[2])) + (q0[0] * q1[0]);
    scale1 = t;

    if (cos_theta < 0.0f) {
        q1[0] = -q1[0];
        cos_theta = -cos_theta;
        q1[1] = -q1[1];
        q1[2] = -q1[2];
        q1[3] = -q1[3];
    }

    if (cos_theta < 0.01f) {
        out[1] = q1[1];
        out[2] = q1[2];
        out[3] = q1[3];
        out[0] = q1[0];
    } else {
        if (!((1.0f - cos_theta) <= 0.01f)) {
            theta = acosf(cos_theta);
            inv_sin = 1.0f / sinf(theta);
            scale0 = inv_sin * sinf((1.0f - scale1) * theta);
            scale1 = inv_sin * sinf(scale1 * theta);
        } else {
            scale0 = 1.0f - scale1;
        }

        out[1] = (scale0 * q0[1]) + (scale1 * q1[1]);
        out[2] = (scale0 * q0[2]) + (scale1 * q1[2]);
        out[3] = (scale0 * q0[3]) + (scale1 * q1[3]);
        out[0] = (scale0 * q0[0]) + (scale1 * q1[0]);
    }
}

Mot_List *MotionProc(mgCFrame *root, float time, Mot_List *list,
                     mgCCamera *camera) {
    unsigned int frame_no = time;
    int          high = {};
    int          low = {};
    int          middle = {};
    unsigned int count = list->key_count;
    low = 0;
    high = count;
    int            next = {};
    mgCFrame      *frame = {};
    unsigned int   vertex = {};
    int            driven = {};
    int            key = {};
    sceVu0FVECTOR *vertices = {};
    unsigned int   key_frame = {};
    float          t = {};
    float          one_minus_t = {};
    float          value[4];
    float          rotation[4];
    float          from[4];
    float          to[4];

    if (low < high) {
        do {
            middle = (low + high) >> 1;

            if (list->key_frames[middle] <= frame_no) {
                low = middle + 1;
            } else {
                high = middle;
            }
        } while (low < high);
    }

    key = low - 1;
    next = key + 1;

    if (next > count - 1) {
        next = key;
    }

    key_frame = list->key_frames[key];
    t = (time - static_cast<float>(key_frame)) /
        static_cast<float>(list->key_frames[next] - key_frame);
    frame = root->GetFrame(list->frame);

    switch (list->type) {
        case MOTION_KEY_ROTATION:
            sceVu0CopyVector(from, list->values[key]);
            sceVu0CopyVector(to, list->values[next]);

            if (!(t <= 0.001f) && t < 0.999f) {
                QuatSlerp(list->values[key], list->values[next], t, rotation);
                frame->SetTransMatrix(rotation);
            } else {
                if (t <= 0.001f) {
                    frame->SetTransMatrix(from);
                }

                if (!(t < 0.999f)) {
                    frame->SetTransMatrix(to);
                }
            }

            break;
        case MOTION_KEY_SCALE:
            if (!(t <= 0.001f) && t < 0.999f) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
            } else {
                if (t <= 0.001f) {
                    sceVu0CopyVectorXYZ(value, list->values[key]);
                }

                if (!(t < 0.999f)) {
                    sceVu0CopyVectorXYZ(value, list->values[next]);
                }
            }

            frame->SetScale(value[0], value[1], value[2]);
            break;
        case MOTION_KEY_TRANSLATION:
            if (!(t <= 0.001f) && t < 0.999f) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
            } else {
                if (t <= 0.001f) {
                    sceVu0CopyVectorXYZ(value, list->values[key]);
                }

                if (!(t < 0.999f)) {
                    sceVu0CopyVectorXYZ(value, list->values[next]);
                }
            }

            frame->trans_matrix[3][0] = value[0];
            frame->trans_matrix[3][1] = value[1];
            frame->trans_matrix[3][2] = value[2];
            frame->changed = 1;
            break;
        case MOTION_KEY_VERTEX: {
            driven = list->frame;
            vertices = ((mgCVisualMDT *) frame->visual)->vertex;

            do {
                if (!(t <= 0.001f) && t < 0.999f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        vertex = static_cast<unsigned int>(list->target) - 1;
                        sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
                        sceVu0CopyVectorXYZ(vertices[vertex], value);
                        list = list->next;

                        if (list != nullptr) {
                            node = list;
                        } else {
                            return nullptr;
                        }
                    }

                    break;
                }

                if (t <= 0.001f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[key]);
                        list = list->next;

                        if (list != nullptr) {
                            node = list;
                        } else {
                            return nullptr;
                        }
                    }
                }

                if (!(t < 0.999f)) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[next]);
                        list = list->next;

                        if (list != nullptr) {
                            node = list;
                        } else {
                            return nullptr;
                        }
                    }
                }
            } while (0);

            return list;
        }
        case MOTION_KEY_CAMERA_POSITION:
            if (camera != nullptr) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
                root->GetWorldPosition(value, value);
                camera->SetPos(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_CAMERA_TARGET:

            if (camera != nullptr) {
                root->GetWorldPosition(value, value);
                camera->SetRef(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_MATERIAL_ALPHA: {
            one_minus_t = 1.0f - t;
            mgMaterial *materials = frame->visual->GetpMaterial();

            materials[list->target].diffuse[3] =
                1.0f - (one_minus_t * list->values[key][0] + t * list->values[next][0]);
            break;
        }
        case MOTION_KEY_MATERIAL_COLOR: {
            mgMaterial *materials = frame->visual->GetpMaterial();

            sceVu0InterVectorXYZ(materials[list->target].diffuse, list->values[next],
                                 list->values[key], t);
            frame->attr->unk_28 = 2;
            break;
        }
        case MOTION_KEY_CAMERA_ROLL:
            if (camera != nullptr) {
                one_minus_t = 1.0f - t;
                camera->SetRoll(
                    -((one_minus_t * list->values[key][0] + t * list->values[next][0]) /
                      180.0f * PI));
            }

            break;
        case MOTION_KEY_CAMERA_FOV:
            if (camera != nullptr) {
                one_minus_t = 1.0f - t;
                mgSetProjection(1.0f /
                                tanf((one_minus_t * list->values[key][0] +
                                      t * list->values[next][0]) *
                                     0.5f / 180.0f * PI) *
                                480.0f * 0.5f);
            }

            break;
        case MOTION_KEY_VISIBLE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = 0;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE | MG_FRAME_DRAW_SKIP_CHILDREN;
            }

            break;
        case MOTION_KEY_VISIBLE_TREE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE;
            }

            break;
    }

    return list->next;
}

Mot_List *MotionProc(mgCFrame *root, unsigned int from_frame,
                     unsigned int to_frame, float blend, Mot_List *list,
                     mgCCamera *camera) {
    int       high = {};
    int       low = {};
    int       key = {};
    int       next = {};
    mgCFrame *frame = {};
    float     one_minus_blend = {};
    float     value[4];
    float     rotation[4];
    float     from[4];
    float     to[4];
    {
        int high = list->key_count;
        int low = 0;
        int middle = {};

        while (low < high) {
            key = (middle = (low + high) >> 1);

            if (list->key_frames[key] <= from_frame) {
                low = key + 1;
            } else {
                high = key;
            }
        }

        key = low - 1;
    }
    {
        high = list->key_count;
        low = 0;

        while (low < high) {
            next = (low + high) >> 1;

            if (list->key_frames[next] <= to_frame) {
                low = next + 1;
            } else {
                high = next;
            }
        }

        next = low - 1;
    }
    frame = root->GetFrame(list->frame);

    switch (list->type) {
        case MOTION_KEY_ROTATION:
            sceVu0CopyVector(from, list->values[key]);
            sceVu0CopyVector(to, list->values[next]);

            if (!(blend <= 0.0001f) && blend < 0.9999f) {
                QuatSlerp(from, to, blend, rotation);
                frame->SetTransMatrix(rotation);
            } else {
                if (blend <= 0.0001f) {
                    frame->SetTransMatrix(from);
                }

                if (!(blend < 0.9999f)) {
                    frame->SetTransMatrix(to);
                }
            }

            break;
        case MOTION_KEY_SCALE:
            sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
            frame->SetScale(value[0], value[1], value[2]);
            break;
        case MOTION_KEY_TRANSLATION:
            sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
            frame->trans_matrix[3][0] = value[0];
            frame->trans_matrix[3][1] = value[1];
            frame->trans_matrix[3][2] = value[2];
            frame->changed = 1;
            break;
        case MOTION_KEY_VERTEX: {
            int            vertex = {};
            int            driven = list->frame;
            sceVu0FVECTOR *vertices = ((mgCVisualMDT *) frame->visual)->vertex;

            do {
                if (!(blend <= 0.0001f) && blend < 0.9999f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        vertex = static_cast<unsigned int>(list->target) - 1;
                        sceVu0InterVectorXYZ(value, list->values[next], list->values[key],
                                             blend);
                        sceVu0CopyVectorXYZ(vertices[vertex], value);
                        list = list->next;

                        if (list != nullptr) {
                            node = list;
                        } else {
                            return nullptr;
                        }
                    }

                    break;
                }

                if (blend <= 0.0001f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[key]);
                        list = list->next;

                        if (list != nullptr) {
                            node = list;
                        } else {
                            return nullptr;
                        }
                    }
                }

                if (!(blend < 0.9999f)) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[next]);
                        list = list->next;

                        if (list != nullptr) {
                            node = list;
                        } else {
                            return nullptr;
                        }
                    }
                }
            } while (0);

            return list;
        }
        case MOTION_KEY_CAMERA_POSITION:
            if (camera != nullptr) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
                root->GetWorldPosition(value, value);
                camera->SetPos(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_CAMERA_TARGET:
            if (camera != nullptr) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
                root->GetWorldPosition(value, value);
                camera->SetRef(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_MATERIAL_ALPHA: {
            one_minus_blend = 1.0f - blend;
            mgMaterial *materials = frame->visual->GetpMaterial();

            materials[list->target].diffuse[3] =
                1.0f - (one_minus_blend * list->values[key][0] +
                        blend * list->values[next][0]);
            frame->attr->unk_28 = 2;
            break;
        }
        case MOTION_KEY_MATERIAL_COLOR: {
            mgMaterial *materials = frame->visual->GetpMaterial();

            sceVu0InterVectorXYZ(materials[list->target].diffuse, list->values[next],
                                 list->values[key], blend);
            frame->attr->unk_28 = 2;
            break;
        }
        case MOTION_KEY_CAMERA_ROLL:
            if (camera != nullptr) {
                one_minus_blend = 1.0f - blend;
                camera->SetRoll(-((one_minus_blend * list->values[key][0] +
                                   blend * list->values[next][0]) /
                                  180.0f * PI));
            }

            break;
        case MOTION_KEY_CAMERA_FOV:
            if (camera != nullptr) {
                one_minus_blend = 1.0f - blend;
                mgSetProjection(1.0f /
                                tanf((one_minus_blend * list->values[key][0] +
                                      blend * list->values[next][0]) *
                                     0.5f / 180.0f * PI) *
                                480.0f * 0.5f);
            }

            break;
        case MOTION_KEY_VISIBLE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = 0;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE | MG_FRAME_DRAW_SKIP_CHILDREN;
            }

            break;
        case MOTION_KEY_VISIBLE_TREE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE;
            }

            break;
    }

    return list->next;
}

Mot_List *MotionProc3(mgCFrame *root, tagMOTION_TYPE *motion,
                      std::span<tagFRAME_INF> frame_info, Mot_List *list) {
    if (list == nullptr) {
        return nullptr;
    }
    if (root == nullptr || motion == nullptr || frame_info.empty() ||
        list->frame < 0 ||
        static_cast<std::size_t>(list->frame) >= frame_info.size() ||
        motion->base_matrices == nullptr ||
        (list->key_count != 0 &&
         (list->values == nullptr || list->key_frames == nullptr))) {
        return list->next;
    }

    static std::vector<std::array<float, 4>> deform_vertices;
    static sceVu0FVECTOR                    *vert;
    static sceVu0FVECTOR                    *nml;
    static sceVu0FMATRIX                     tmp_SkinMatrix;
    static sceVu0FMATRIX                     tmp_SkinMatrix_inv;
    static sceVu0FMATRIX                     tmp_ChrMatrix;
    static sceVu0FMATRIX                     tmp_BaseSkinMatrix;
    static sceVu0FMATRIX                     tmp_BaseSkinMatrix_inv;
    float                                    deform[4][4];
    float                                    rotate[4][4];
    float                                    bone_matrix[4][4];
    float                                    bone_in_skin[4][4];
    float                                    skin_bone[4][4];
    float                                    bone_in_skin_inv[4][4];
    float                                    bone_base[4][4];
    float                                    normal[4];
    mgCFrame                                *bone = {};
    mgCFrame                                *skin = {};
    int                                      vertex = {};

    if (list->type != MOTION_KEY_SKIN_WEIGHTED) {
        return list->next;
    }
    if (root == nullptr || motion == nullptr || frame_info.empty() ||
        motion->base_matrices == nullptr ||
        (list->key_count != 0 &&
         (list->values == nullptr || list->key_frames == nullptr))) {
        return list->next;
    }

    bone = root->GetFrame(list->target);
    skin = root->GetFrame(list->frame);
    if (bone == nullptr || skin == nullptr || skin->visual == nullptr ||
        skin->attr == nullptr) {
        return list->next;
    }
    auto       *visual = static_cast<mgCVisualMDT *>(skin->visual);
    const auto &info = frame_info[list->frame];
    if (visual->vertex_num < 0 || visual->normal_num < 0 ||
        info.vertex_count > static_cast<unsigned>(visual->vertex_num) ||
        info.normal_count > static_cast<unsigned>(visual->normal_num) ||
        (info.vertex_count != 0 &&
         (visual->vertex == nullptr || info.base_vertices == nullptr)) ||
        (info.normal_count != 0 &&
         (visual->normal == nullptr || info.base_normals == nullptr))) {
        return list->next;
    }

    if (OldSkinFrame != skin) {
        OldSkinFrame = skin;
        vert = visual->vertex;
        nml = visual->normal;
        deform_vertices.assign(info.vertex_count, {0.0f, 0.0f, 0.0f, 1.0f});

        skin->attr->unk_28 = 1;
        skin->GetLWMatrix(tmp_SkinMatrix);
        root->GetLWMatrix(tmp_ChrMatrix);
        sceVu0InversMatrix(tmp_SkinMatrix_inv, tmp_SkinMatrix);
        mgMulMatrix(tmp_BaseSkinMatrix, tmp_ChrMatrix,
                    motion->base_matrices[list->frame]);
        mgInversMatrix(tmp_BaseSkinMatrix_inv, tmp_BaseSkinMatrix);
    }

    sceVu0UnitMatrix(bone_matrix);
    sceVu0UnitMatrix(tmp_SkinMatrix);
    bone->GetLWMatrix(bone_matrix);
    mgMulMatrix(bone_base, tmp_ChrMatrix, motion->base_matrices[list->target]);
    mgMulMatrix(bone_in_skin, tmp_BaseSkinMatrix_inv, bone_base);
    mgInversMatrix(bone_in_skin_inv, bone_in_skin);
    mgMulMatrix(skin_bone, tmp_SkinMatrix_inv, bone_matrix);
    mgMulMatrix(deform, skin_bone, bone_in_skin_inv);

    sceVu0CopyMatrix(rotate, deform);
    rotate[3][0] = 0.0f;
    rotate[3][1] = 0.0f;
    rotate[3][2] = 0.0f;

    for (unsigned int index = 0; index < list->key_count; index++) {
        float weight[4] = {0.0f, 0.0f, 0.0f, 0.0f};

        weight[0] = 0.01f * list->values[index][0];

        if (!(weight[0] <= 0.0f)) {
            if (list->key_frames[index] >= deform_vertices.size()) {
                continue;
            }
            vertex = static_cast<int>(list->key_frames[index]);
            testVUnew(deform, info.base_vertices[vertex], weight,
                      deform_vertices[vertex].data(), vert[vertex]);
            if (static_cast<unsigned>(vertex) < info.normal_count) {
                sceVu0ApplyMatrix(normal, rotate, info.base_normals[vertex]);
                sceVu0InterVectorXYZ(nml[vertex], normal, info.base_normals[vertex],
                                     weight[0]);
            }
        }
    }

    return list->next;
}

void SetMotionTime(mgCFrame *root, tagMOTION_TYPE *motion, float time,
                   mgCCamera *camera);

void ChangeMotion(mgCFrame *root, tagMOTION_TYPE *motion,
                  unsigned int from_frame, unsigned int to_frame, float blend,
                  mgCCamera *camera);

void DeformMesh(mgCFrame *root, tagMOTION_TYPE *motion,
                std::span<tagFRAME_INF> frame_info, bool with_normals) {
    if (root == nullptr || motion == nullptr || frame_info.empty()) {
        return;
    }
    Mot_List *list = motion->skin_list;

    if (with_normals) {
        while (list != nullptr) {
            list = MotionProc3(root, motion, frame_info, list);
        }
    } else {
        while (list != nullptr) {
            list = MotionProc2(root, motion, frame_info, list);
        }
    }

    OldSkinFrame = nullptr;
}

void ChangeWeight(Mot_List *list, mgCMemory *memory, u8 *data, int frame_no,
                  std::span<tagFRAME_INF> frame_info, mgCVisualMDT *mesh,
                  mgCFrame *frame, mgCFrame *source_frame);

int CreateAnimeDataEX(tagMOTION_TYPE *motion, mgCMemory *memory,
                      MOTION_FILE_INFO *info);

std::optional<int> dc2::animation::FrameInfoQuadwords(std::size_t frame_count) {
    constexpr std::size_t padding = 10;
    if (frame_count >
        (std::numeric_limits<std::size_t>::max() / sizeof(tagFRAME_INF)) -
            padding) {
        return std::nullopt;
    }
    const std::size_t bytes = (frame_count + padding) * sizeof(tagFRAME_INF);
    const std::size_t quadwords = bytes / sizeof(u_long128) + 1;
    if (quadwords > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return std::nullopt;
    }
    return static_cast<int>(quadwords);
}

void AnimeDataInit(mgCFrame *root, tagMOTION_TYPE *motion, mgCMemory *memory,
                   tagFRAME_INF **frame_info) {
    if (root == nullptr || motion == nullptr || memory == nullptr ||
        frame_info == nullptr || memory->stack == nullptr || memory->lock != 0 ||
        memory->stack_used < 0 || memory->stack_used > memory->stack_size) {
        throw std::invalid_argument("invalid animation frame storage");
    }
    const int  count = root->GetFrameNum();
    const auto blocks =
        count > 0
            ? dc2::animation::FrameInfoQuadwords(static_cast<std::size_t>(count))
            : std::nullopt;
    if (!blocks) {
        throw std::length_error(
            "animation frame count exceeds arena allocation range");
    }
    const auto address = reinterpret_cast<std::uintptr_t>(memory->stGetTop());
    const auto misalignment = address & 0x3F;
    if ((misalignment & 0xF) != 0) {
        throw std::invalid_argument("unaligned animation frame storage");
    }
    const int alignment_quadwords =
        misalignment == 0
            ? 0
            : static_cast<int>((64 - misalignment) / sizeof(u_long128));
    if (static_cast<long long>(memory->stGetRest()) <=
        static_cast<long long>(*blocks) + alignment_quadwords) {
        throw std::length_error("animation frame table exceeds arena capacity");
    }
    memory->Align64();
    auto *table = dc2::memory::NewArray<tagFRAME_INF>(
        *memory, static_cast<std::size_t>(count) + 10);
    if (table == nullptr) {
        throw std::length_error("animation frame table allocation failed");
    }
    if (!AnimeDataInit(root, motion, memory,
                       std::span(table, static_cast<std::size_t>(count)))) {
        throw std::invalid_argument("invalid animation frame or mesh data");
    }
    motion->frame_info = table;
    *frame_info = table;
}

int AnimeDataInit(mgCFrame *frame, tagMOTION_TYPE *motion, mgCMemory *memory,
                  std::span<tagFRAME_INF> frame_info);

int CheckHit(CCPoly *polys, int count, float *from, float *to, float *hit_point,
             int nearest, int ignore_mask) {
    CollisionInfo info{};

    info.unk_08 = 0;
    info.unk_0C = 0;
    info.count = count;
    info.polys = polys;
    return CheckHit(&info, from, to, hit_point, nearest, ignore_mask);
}

int CheckHitVertical(CCPoly *polys, int count, float *from, float height,
                     float *hit_point, int ignore_mask) {
    CollisionInfo info{};

    info.unk_08 = 0;
    info.unk_0C = 0;
    info.count = count;
    info.polys = polys;
    return CheckHitVertical(&info, from, height, hit_point, ignore_mask);
}

int CheckHitVertical(CollisionInfo *collision, float *pos, float dy, float *hit,
                     int mask);

int CheckHits(CCPoly *polys, int count, float *from, float *to, int max_hits,
              int *hit_polys, float (*hit_points)[4], int sort,
              int ignore_mask) {
    CollisionInfo info{};

    info.unk_08 = 0;
    info.unk_0C = 0;
    info.count = count;
    info.polys = polys;
    return CheckHits(&info, from, to, max_hits, hit_polys, hit_points, sort,
                     ignore_mask);
}

int CheckHitsPipeY(CCPoly *polys, int count, float *from, float height,
                   int max_hits, int *hit_polys, sceVu0FVECTOR *hit_points,
                   int sort, int ignore_mask) {
    float   best[4];
    float   poly_min[4];
    float   poly_max[4];
    float   pipe_max[4];
    float   pipe_min[4];
    float   top[4];
    float   points[11][4];
    float   swap[4];
    CCPoly *poly = {};
    float   radius = {};
    float   normal_y = {};
    int     point_count = {};
    int     j = {};
    int     found = {};
    int     hits = {};
    int     i = {};
    int     index = {};

    hits = 0;
    radius = from[3];
    std::memcpy(top, from, sizeof(top));
    top[1] += height;
    mgVectorMaxMin(pipe_max, pipe_min, from, top);
    pipe_max[0] += radius;
    pipe_max[2] += radius;
    pipe_min[0] -= radius;
    pipe_min[2] -= radius;
    poly = polys;

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & ignore_mask) {
            continue;
        }

        normal_y = (poly->normal[1] < 0.0f) ? -poly->normal[1] : poly->normal[1];

        if (normal_y < 0.01f) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1],
                       poly->vertex[2]);

        if (pipe_max[0] < poly_min[0] || pipe_max[1] < poly_min[1] ||
            pipe_max[2] < poly_min[2]) {
            continue;
        }

        if (!(pipe_min[0] <= poly_max[0]) || !(pipe_min[1] <= poly_max[1]) ||
            !(pipe_min[2] <= poly_max[2])) {
            continue;
        }

        point_count =
            IntersectionPipeYPoly3(from, poly->vertex, poly->normal, points);

        if (point_count <= 0) {
            continue;
        }

        found = false;

        for (j = 0; j < point_count; j++) {
            if (points[j][1] <= pipe_max[1] && !(points[j][1] < pipe_min[1])) {
                if (!found) {
                    std::memcpy(best, points[j], sizeof(best));
                    found = true;
                } else if (!(points[j][1] <= best[1])) {
                    std::memcpy(best, points[j], sizeof(best));
                }
            }
        }

        if (!found) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], best);
        hit_points[hits][3] = mgDistVector(from, best);
        hits++;
    }

    if (sort == 0) {
        return hits;
    }

    {
        if (sort > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }

        if (sort < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }
    }

    return hits;
}

int CheckHitsPipe(CCPoly *polys, int count, sceVu0FVECTOR from, float *to,
                  int max_hits, int *hit_polys, sceVu0FVECTOR *hit_points,
                  int sort, int ignore_mask) {
    float   best[4];
    float   poly_min[4];
    float   poly_max[4];
    float   pipe_max[4];
    float   pipe_min[4];
    float   dir[4];
    float   points[11][4];
    float   offset[4];
    float   swap[4];
    CCPoly *poly = {};
    float   radius = {};
    float   length = {};
    float   along = {};
    int     point_count = {};
    int     j = {};
    int     found = {};
    int     hits = {};
    int     i = {};
    int     index = {};

    hits = 0;
    radius = from[3];
    length = mgDistVector(from, to);
    mgVectorMaxMin(pipe_max, pipe_min, from, to);
    sceVu0SubVector(dir, to, from);
    sceVu0Normalize(dir, dir);
    pipe_max[0] += radius;
    pipe_max[1] += radius;
    pipe_max[2] += radius;
    pipe_min[0] -= radius;
    pipe_min[1] -= radius;
    pipe_min[2] -= radius;
    poly = polys;

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & ignore_mask) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1],
                       poly->vertex[2]);

        if (pipe_max[0] < poly_min[0] || pipe_max[1] < poly_min[1] ||
            pipe_max[2] < poly_min[2]) {
            continue;
        }

        if (!(pipe_min[0] <= poly_max[0]) || !(pipe_min[1] <= poly_max[1]) ||
            !(pipe_min[2] <= poly_max[2])) {
            continue;
        }

        point_count =
            IntersectionPipePoly3(from, dir, poly->vertex, poly->normal, points);

        if (point_count <= 0) {
            continue;
        }

        found = false;

        for (j = 0; j < point_count; j++) {
            sceVu0SubVector(offset, points[j], from);
            along = sceVu0InnerProduct(offset, dir);
            points[j][3] = along;

            if (!(along < 0.0f) && along <= length) {
                if (!found) {
                    std::memcpy(best, points[j], sizeof(best));
                    found = true;
                } else if (points[j][3] < best[3]) {
                    std::memcpy(best, points[j], sizeof(best));
                }
            }
        }

        if (!found) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], best);
        hits++;
    }

    if (sort == 0) {
        return hits;
    }

    {
        if (sort > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }

        if (sort < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }
    }

    return hits;
}

int CheckHitsSphere(CCPoly *polys, int count, float *sphere, int max_hits,
                    int *hit_polys, sceVu0FVECTOR *hit_points, int sort,
                    int ignore_mask) {
    float   push[4];
    float   poly_min[4];
    float   poly_max[4];
    float   sphere_max[4];
    float   sphere_min[4];
    float   normal[4];
    float   swap[4];
    int     i = {};
    int     hits = {};
    CCPoly *poly = {};
    int     j = {};
    int     index = {};

    hits = 0;
    float radius = sphere[3];
    std::memcpy(sphere_max, sphere, sizeof sphere_max);
    std::memcpy(sphere_min, sphere, sizeof sphere_min);
    sphere_max[0] += radius;
    sphere_max[1] += radius;
    sphere_max[2] += radius;
    sphere_min[0] -= radius;
    sphere_min[1] -= radius;
    sphere_min[2] -= radius;
    poly = polys;

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & ignore_mask) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1],
                       poly->vertex[2]);

        if (sphere_max[0] < poly_min[0] || sphere_max[1] < poly_min[1] ||
            sphere_max[2] < poly_min[2]) {
            continue;
        }

        if (!(sphere_min[0] <= poly_max[0]) || !(sphere_min[1] <= poly_max[1]) ||
            !(sphere_min[2] <= poly_max[2])) {
            continue;
        }

        sceVu0Normalize(normal, poly->normal);

        if (IntersectionSpherePoly3(sphere, poly->vertex, normal, push) ==
            SPHERE_POLY3_NONE) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], push);
        hits++;
    }

    if (sort == 0) {
        return hits;
    }

    {
        if (sort > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }

        if (sort < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }
    }

    return hits;
}

int MoveCheck(float *pos, float *vel, float *out, MoveCheckInfo *info,
              CCPoly *polys, int count, int mask) {
    float         point[4];
    float         start[4];
    float         end[4];
    float         dir[4];
    int           hit_index[64];
    sceVu0FVECTOR hit_point[64];
    float         scratch[4];

    CCPoly foot{};

    float foot_probe[4];
    float probe[4];
    float radius = {};
    float margin = {};
    int   tries = {};
    int   wall_sides = {};

    radius = info->radius;

    if (radius <= 0.0f) {
        radius = 15.0f;
    }

    out[0] = pos[0];
    out[1] = pos[1];
    out[2] = pos[2];
    sceVu0Normalize(dir, vel);
    sceVu0ScaleVector(dir, dir, 0.3f * radius);
    start[0] = pos[0];
    start[1] = 10.0f + pos[1];
    start[2] = pos[2];
    end[0] = start[0] + vel[0];
    end[1] = start[1] + vel[1];
    end[2] = start[2] + vel[2];
    start[3] = 4.0f;
    sceVu0AddVector(scratch, end, dir);
    tries = 0;

    do {
        if (CheckHitsPipe(polys, count, start, end, 0x40, hit_index, hit_point, 1,
                          mask) <= 0) {
            start[0] = end[0];
            start[1] = end[1];
            start[2] = end[2];
            end[0] = start[0];
            end[1] = start[1] - 10.0f;
            end[2] = start[2];
            break;
        }

        vel[0] *= 0.5f;
        vel[2] *= 0.5f;
        tries++;
        end[0] = start[0] + vel[0];
        end[1] = start[1] + vel[1];
        end[2] = start[2] + vel[2];
    } while (tries < 2);

    info->ground_found = false;
    info->landed = false;
    margin = 4.0f;

    if (vel[1] > 0.1f) {
        margin = 0.0f;
    }

    sceVu0CopyVector(foot_probe, start);

    if (!info->skip_ground) {
        if (GetFootPoly(foot_probe, 20.0f, &foot, point, polys, count, mask)) {
            sceVu0Normalize(foot.normal, foot.normal);
            info->ground_poly = foot;
            info->second_poly = foot;
            info->ground_found = true;
            info->landed = false;
            std::memcpy(info->ground_point, point, sizeof info->ground_point);

            if (!(point[1] <= start[1] + vel[1] - 10.0f - margin)) {
                info->landed = true;
            }
        }
    }

    if (info->landed) {
        out[0] = point[0];
        out[1] = point[1];
        out[2] = point[2];
    } else {
        out[0] = end[0];
        out[1] = end[1];
        out[2] = end[2];
    }

    std::memcpy(probe, out, sizeof probe);
    probe[1] += 5.0f;
    wall_sides = CheckWidth(polys, count, probe, radius, end, mask);
    info->width_result = wall_sides;

    if (wall_sides) {
        probe[0] = end[0];
        probe[2] = end[2];
    }

    probe[3] = 4.0f;

    if (CheckWidthPipe(polys, count, probe, radius, end, mask)) {
        out[0] = end[0];
        out[2] = end[2];
    } else {
        out[0] = probe[0];
        out[2] = probe[2];
    }

    if (!info->skip_ground) {
        sceVu0CopyVector(foot_probe, start);

        if (GetFootPoly(foot_probe, 20.0f, &foot, point, polys, count, mask)) {
            std::memcpy(info->ground_point, point, sizeof info->ground_point);

            if (!(point[1] <= start[1] + vel[1] - 10.0f - margin)) {
                out[1] = point[1];
            }
        }
    }

    GetCPolyAttr(info, pos, out, 34.0f, polys, count, mask);
    return 0;
}

int GetFootPoly(float *pos, float depth, CCPoly *found, sceVu0FVECTOR ground,
                CCPoly *polys, int count, int ignore_mask) {
    s16           poly_ignore_mask{};
    u16           parts_no{};
    s16           attribute{};
    int           hit_polys[32];
    sceVu0FVECTOR from;
    sceVu0FVECTOR to;
    sceVu0FVECTOR hit_points[64];
    float         attribute_value{};
    int           hits = {};
    int           found_ground = {};
    int           i = {};
    float         normal_y = {};
    sceVu0CopyVector(from, pos);
    sceVu0CopyVector(to, pos);
    from[3] = 4.0f;
    to[1] -= depth;
    hits = CheckHitsPipeY(polys, count, from, -depth, 32, hit_polys, hit_points,
                          1, ignore_mask);

    if (hits == 0) {
        return false;
    }

    int ground_kind = 0;
    int foot_sound = 0;
    int area_kind = 0;
    found_ground = false;

    for (i = 0; i < hits; i++) {
        sceVu0FVECTOR normal;
        sceVu0Normalize(normal, polys[hit_polys[i]].normal);
        normal_y = (normal[1] < 0.0f) ? -normal[1] : normal[1];

        if (normal_y < 0.05f) {
            continue;
        }

        *found = polys[hit_polys[i]];
        sceVu0CopyVector(ground, hit_points[i]);
        found_ground = true;
        ground[0] = from[0];
        ground[2] = from[2];
        ground_kind = found->ground_kind;
        foot_sound = found->foot_sound;
        area_kind = found->area_kind;
        poly_ignore_mask = found->ignore_mask;
        parts_no = found->parts_no;
        attribute = found->attr;
        attribute_value = found->attr_value;
        break;
    }

    for (i = 0; i < hits; i++) {
        short *poly = &polys[hit_polys[i]].ground_kind;

        if (ground_kind == 0) {
            ground_kind = poly[0];
        }

        if (foot_sound == 0) {
            foot_sound = poly[1];
        }

        if (area_kind == 0) {
            area_kind = poly[2];
        }
    }

    found->ground_kind = ground_kind;
    found->foot_sound = foot_sound;
    found->area_kind = area_kind;
    found->ignore_mask = poly_ignore_mask;
    found->parts_no = parts_no;
    found->attr = attribute;
    found->attr_value = attribute_value;
    return found_ground;
}

void GetCPolyAttr(MoveCheckInfo *info, float *from, float *to, float dy,
                  CCPoly *polys, int count, int unused) {
    int   hit_index[32];
    float probe_from[4];
    float probe_to[4];
    float hit_point[64][4];
    int   hits = {};
    int   i = {};
    s16   kind = {};

    info->in_water = false;
    info->crossed_area = false;
    hits = CheckHits(polys, count, from, to, 0x20, hit_index, hit_point, 1, 0);

    for (i = 0; i < hits; i++) {
        kind = polys[hit_index[i]].area_kind;

        switch (kind) {
            case COL_AREA_WATER:
            case COL_AREA_FISHING_WATER:
                info->crossed_area = true;
                info->signed_distance = mgDistVector(from, to);

                if (!(from[1] <= to[1])) {
                    info->signed_distance *= -1.0f;
                }

                std::memcpy(info->crossed_point, hit_point[i], sizeof(hit_point[i]));
                break;
        }
    }

    sceVu0CopyVector(probe_from, to);
    sceVu0CopyVector(probe_to, to);
    probe_from[1] += dy;
    hits = CheckHits(polys, count, probe_from, probe_to, 0x20, hit_index,
                     hit_point, 1, 0);

    if (hits == 0) {
        return;
    }

    for (i = 0; i < hits; i++) {
        kind = polys[hit_index[i]].area_kind;

        switch (kind) {
            case COL_AREA_WATER:
            case COL_AREA_FISHING_WATER:
                info->in_water = true;
                std::memcpy(info->water_surface, hit_point[i], sizeof(hit_point[i]));
                break;
        }
    }
}

int CheckWidth(CCPoly *polys, int count, float *pos, float radius, float *out,
               int mask) {
    float probe_end[4];
    float hit_first[4];
    float hit_second[4];
    float probe[4];
    float normal[4];
    int   sides = {};
    int   saw_first = {};
    int   saw_second = {};
    int   index = {};
    float diagonal = {};

    diagonal = radius / 1.4142135f;
    sides = 0;
    sceVu0CopyVector(probe, pos);
    sceVu0CopyVector(out, pos);
    saw_second = false;
    saw_first = false;
    probe_end[0] = probe[0] + diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] + diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            saw_first = true;
            sides |= CHECK_WIDTH_SIDE_POS_X | CHECK_WIDTH_SIDE_POS_Z;
        }
    }

    probe_end[0] = probe[0] - diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] - diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_NEG_X | CHECK_WIDTH_SIDE_NEG_Z;
            saw_second = true;
        }
    }

    if (saw_first && saw_second) {
        out[0] = 0.5f * (hit_first[0] + hit_second[0]);
        out[2] = 0.5f * (hit_first[2] + hit_second[2]);
    } else {
        if (saw_first) {
            out[0] = hit_first[0] - diagonal;
            out[2] = hit_first[2] - diagonal;
        }

        if (saw_second) {
            out[0] = hit_second[0] + diagonal;
            out[2] = hit_second[2] + diagonal;
        }
    }

    sceVu0CopyVector(probe, out);
    saw_second = false;
    saw_first = false;
    probe_end[0] = probe[0] + diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] - diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            saw_first = true;
            sides |= CHECK_WIDTH_SIDE_POS_X | CHECK_WIDTH_SIDE_NEG_Z;
        }
    }

    probe_end[0] = probe[0] - diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] + diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_NEG_X | CHECK_WIDTH_SIDE_POS_Z;
            saw_second = true;
        }
    }

    if (saw_first && saw_second) {
        out[0] = 0.5f * (hit_first[0] + hit_second[0]);
        out[2] = 0.5f * (hit_first[2] + hit_second[2]);
    } else {
        if (saw_first) {
            out[0] = hit_first[0] - diagonal;
            out[2] = hit_first[2] + diagonal;
        }

        if (saw_second) {
            out[0] = hit_second[0] + diagonal;
            out[2] = hit_second[2] - diagonal;
        }
    }

    sceVu0CopyVector(probe, out);
    saw_second = false;
    saw_first = false;
    probe_end[0] = probe[0] + radius;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2];
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            saw_first = true;
            sides |= CHECK_WIDTH_SIDE_POS_X;
        }
    }

    probe_end[0] = probe[0] - radius;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2];
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_NEG_X;
            saw_second = true;
        }
    }

    if (saw_first && saw_second) {
        out[0] = 0.5f * (hit_first[0] + hit_second[0]);
    } else {
        if (saw_first) {
            out[0] = hit_first[0] - radius;
        }

        if (saw_second) {
            out[0] = hit_second[0] + radius;
        }
    }

    sceVu0CopyVector(probe, out);
    saw_second = false;
    saw_first = false;
    probe_end[0] = probe[0];
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] + radius;
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_POS_Z;
            saw_first = true;
        }
    }

    probe_end[0] = probe[0];
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] - radius;
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_NEG_Z;
            saw_second = true;
        }
    }

    if (saw_first && saw_second) {
        out[2] = 0.5f * (hit_first[2] + hit_second[2]);
    } else {
        if (saw_first) {
            out[2] = hit_first[2] - radius;
        }

        if (saw_second) {
            out[2] = hit_second[2] + radius;
        }
    }

    return sides;
}

int CheckWidthPipe(CCPoly *polys, int count, float *pos, float radius,
                   float *out, int mask) {
    float         probe_end[4];
    float         hit_high[4];
    float         hit_low[4];
    float         probe[4];
    float         normal[4];
    int           hit_index[32];
    sceVu0FVECTOR hit_point[32];
    int           sides = {};
    int           has_high = {};
    int           has_low = {};
    float         reach = {};
    int           hit = {};

    reach = radius;
    reach *= 0.8f;
    sides = 0;
    sceVu0CopyVector(probe, pos);
    probe[1] += 3.0f * pos[3];
    sceVu0CopyVector(out, pos);
    probe_end[3] = probe[3];
    has_low = false;
    has_high = false;
    probe_end[1] = probe[1];
    probe_end[0] = probe[0] + reach;
    probe_end[2] = probe[2];

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point,
                      1, mask) > 0) {
        hit = hit_index[0];
        std::memcpy(hit_high, hit_point[0], sizeof(hit_high));
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            has_high = true;
            sides |= CHECK_WIDTH_SIDE_POS_X;
        }
    }

    probe_end[0] = probe[0] - reach;
    probe_end[2] = probe[2];

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point,
                      1, mask) > 0) {
        hit = hit_index[0];
        std::memcpy(hit_low, hit_point[0], sizeof(hit_low));
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_NEG_X;
            has_low = true;
        }
    }

    if (has_high && has_low) {
        out[0] = 0.5f * (hit_high[0] + hit_low[0]);
    } else {
        if (has_high) {
            out[0] = hit_high[0] - reach;
        }

        if (has_low) {
            out[0] = hit_low[0] + reach;
        }
    }

    has_low = false;
    has_high = false;
    probe[0] = out[0];
    probe[2] = out[2];
    probe_end[0] = probe[0];
    probe_end[2] = probe[2] + reach;

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point,
                      1, mask) > 0) {
        hit = hit_index[0];
        std::memcpy(hit_high, hit_point[0], sizeof(hit_high));
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_POS_Z;
            has_high = true;
        }
    }

    probe_end[0] = probe[0];
    probe_end[2] = probe[2] - reach;

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point,
                      1, mask) > 0) {
        hit = hit_index[0];
        std::memcpy(hit_low, hit_point[0], sizeof(hit_low));
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= CHECK_WIDTH_SIDE_NEG_Z;
            has_low = true;
        }
    }

    if (has_high && has_low) {
        out[2] = 0.5f * (hit_high[2] + hit_low[2]);
    } else {
        if (has_high) {
            out[2] = hit_high[2] - reach;
        }

        if (has_low) {
            out[2] = hit_low[2] + reach;
        }
    }

    return sides;
}

int CreateCharaCPoly(CCPoly *polys, int max_polys, float *pos, float *target,
                     float distance, float half_size) {
    sceVu0FVECTOR direction;
    sceVu0FVECTOR centre;
    sceVu0FVECTOR upper_left;
    sceVu0FVECTOR upper_right;
    sceVu0FVECTOR lower_left;
    sceVu0FVECTOR lower_right;
    float         wall_distance = {};

    if (max_polys < 2) {
        return 0;
    }

    sceVu0SubVector(direction, target, pos);
    direction[1] = 0.0f;
    wall_distance = mgDistVector(direction);

    if (wall_distance > distance) {
        wall_distance = distance;
    }

    if (wall_distance < distance) {
        wall_distance -= 1.0f;
    }

    sceVu0Normalize(direction, direction);
    upper_left[1] = half_size;
    upper_left[0] = -direction[2] * half_size;
    upper_left[2] = direction[0] * half_size;
    upper_left[3] = 1.0f;
    sceVu0CopyVector(upper_right, upper_left);
    upper_right[0] = -upper_left[0];
    upper_right[2] = -upper_left[2];
    sceVu0CopyVector(lower_left, upper_left);
    lower_left[1] = -half_size;
    sceVu0CopyVector(lower_right, upper_right);
    lower_right[1] = -half_size;
    sceVu0ScaleVector(centre, direction, wall_distance);
    sceVu0AddVector(centre, centre, pos);
    sceVu0AddVector(upper_left, upper_left, centre);
    sceVu0AddVector(upper_right, upper_right, centre);
    sceVu0AddVector(lower_left, lower_left, centre);
    sceVu0AddVector(lower_right, lower_right, centre);
    polys[0] = CCPoly{};
    sceVu0CopyVector(polys[0].vertex[0], upper_left);
    sceVu0CopyVector(polys[0].vertex[1], upper_right);
    sceVu0CopyVector(polys[0].vertex[2], lower_left);
    sceVu0CopyVector(polys[0].normal, direction);
    polys[1] = CCPoly{};
    sceVu0CopyVector(polys[1].vertex[0], lower_left);
    sceVu0CopyVector(polys[1].vertex[1], upper_right);
    sceVu0CopyVector(polys[1].vertex[2], lower_right);
    sceVu0CopyVector(polys[1].normal, direction);
    return 2;
}

float LinerInterpolation(float from, float to, float rate) {
    return from + (rate * (to - from));
}

int LinerInterpolationI(int from, int to, int step, int steps) {
    return from + step * (to - from) / steps;
}

void RollPos(float *center, float *point, float angle, float *out) {
    float px = {};
    float cx = center[0];
    float cy = center[1];
    px = point[0];
    float dy = point[1];
    float t = {};
    float dx = {};
    t = (dx = px - cx) * cosf(angle);
    out[0] = cx + (t - (dy -= cy) * sinf(angle));
    t = dx * sinf(angle);
    out[1] = cy - (t + dy * cosf(angle));
}

s32 CheckPosInOutForRect(RECT *rect, s32 x, s32 y) {
    s32 left = rect->x;

    if (x < left) {
        return false;
    }

    if ((left + rect->width) < x) {
        return false;
    }

    s32 top = rect->y;

    if (y < top) {
        return false;
    }

    return (top + rect->height) >= y;
}

float GetDisPosToRect(RECT *rect, int x, int y) {
    float distance_x = {};
    float distance_y = {};

    distance_x = rect->x + rect->width / 2 - x;
    distance_y = rect->y + rect->height / 2 - y;
    return sqrt(distance_x * distance_x + distance_y * distance_y);
}

s32 CheckPosInOutFor2P(float x0, float y0, float x1, float y1, float x,
                       float y) {
    float min_x = {};
    float max_x = {};
    float max_y = {};
    float min_y = {};
    s32   outside = {};

    max_x = x1;
    max_y = y1;
    min_x = max_x;

    if (x0 < max_x) {
        min_x = x0;
    } else {
        max_x = x0;
    }

    min_y = max_y;

    if (y0 < max_y) {
        min_y = y0;
    } else {
        max_y = y0;
    }

    if (x < min_x) {
        return false;
    }

    if (max_x < x) {
        return false;
    }

    if (y < min_y) {
        return false;
    }

    outside = true;

    if (!(max_y < y)) {
        outside = false;
    }

    return outside ^ 1;
}

int CalcIntersectionPointLineAndLine(float ax0, float ay0, float ax1, float ay1,
                                     float bx0, float by0, float bx1, float by1,
                                     float *out_x, float *out_y) {
    float slope_a = 0.0f;
    float slope_b = 0.0f;
    float relative_x = {};
    float relative_y = {};

    if (ax0 == ax1 && bx0 == bx1) {
        return false;
    }

    if (ax0 != ax1) {
        slope_a = (ay1 - ay0) / (ax1 - ax0);
    }

    if (bx0 != bx1) {
        slope_b = (by1 - by0) / (bx1 - bx0);
    }

    if (slope_a == slope_b) {
        return false;
    }

    if (ax0 == ax1) {
        *out_x = ax0;
        *out_y = slope_b * (ax0 - bx0);
        return true;
    } else if (bx0 == bx1) {
        *out_x = bx0;
        *out_y = slope_a * (bx0 - ax0);
        return true;
    } else {
        relative_x = ((by0 - ay0) - slope_b * (bx0 - ax0)) / (slope_a - slope_b);
        *out_x = relative_x + ax0;
        relative_y = relative_x * slope_a;
        *out_y = relative_y + ay0;
        return true;
    }
}

s32 CalcIntersectionPoint2PAnd2P(float ax0, float ay0, float ax1, float ay1,
                                 float bx0, float by0, float bx1, float by1,
                                 float *out_x, float *out_y) {
    if (CalcIntersectionPointLineAndLine(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1,
                                         out_x, out_y) == 0) {
        return false;
    }

    if (CheckPosInOutFor2P(ax0, ay0, ax1, ay1, *out_x, *out_y) == 0) {
        return false;
    }

    return CheckPosInOutFor2P(bx0, by0, bx1, by1, *out_x, *out_y) != 0;
}

#include "common.h"

#include <cstdio>
#include <cstring>

#include "assets/data_registry.hpp"
#include "character_motion.hpp"
#include "collision.hpp"
#include "gameutil.hpp"
#include "log/log.hpp"
#include "mg_math.hpp"
#include "platform/model_assets.hpp"

void SetMotionTime(mgCFrame *root, tagMOTION_TYPE *motion, float time,
                   mgCCamera *camera) {
    if (root == nullptr || motion == nullptr) {
        return;
    }
    character_motion::Pose(*root, *motion, time, camera);
}

void ChangeMotion(mgCFrame *root, tagMOTION_TYPE *motion,
                  unsigned int from_frame, unsigned int to_frame, float blend,
                  mgCCamera *camera) {
    if (root == nullptr || motion == nullptr) {
        return;
    }
    character_motion::Blend(*root, *motion, static_cast<float>(from_frame),
                            static_cast<float>(to_frame), blend, camera);
}

// Retail motion files never reach native profiles, which load named glTF
// actions instead.
int CreateAnimeDataEX(tagMOTION_TYPE * /*unused*/, mgCMemory * /*unused*/,
                      MOTION_FILE_INFO * /*unused*/) {
    CT_LOG_ERROR(Data, "animation: retail motion data is not supported; profiles "
                       "load named glTF actions");
    return false;
}

void ChangeWeight(Mot_List *list, mgCMemory *memory, u8 *data, int frame_no,
                  std::span<tagFRAME_INF> frame_info, mgCVisualMDT *mesh,
                  mgCFrame *frame, mgCFrame *source_frame) {
    if (!list || !memory || !data || !frame || !source_frame ||
        frame_info.empty() || frame_no < 0 ||
        static_cast<std::size_t>(frame_no) >= frame_info.size()) {
        return;
    }
    Mot_List *previous = list;
    for (auto *channel = list; channel;) {
        auto *next = channel->next;
        if (channel->frame == frame_no) {
            previous->next = next;
        } else {
            previous = channel;
        }
        channel = next;
    }
    try {
        tagMOTION_TYPE replacement{};
        std::string    error;
        const auto     path = DataReadBufferPath(data);
        if (!path) {
            CT_LOG_ERROR(Data, "animation: direct glTF weight path required");
            return;
        }
        if (!model_assets::LoadAnimation(std::filesystem::path(*path), replacement,
                                         *memory, std::nullopt, std::nullopt, 0,
                                         std::nullopt, error)) {
            throw std::runtime_error(error);
        }
        auto *head = replacement.skin_list;
        previous->next = head;
        for (auto *channel = head; channel; channel = channel->next) {
            channel->frame = frame_no;
            auto *target = source_frame->GetFrame(channel->target);
            channel->target = target ? frame->SearchFrameID(target->name) : -1;
        }
        if (!mesh) {
            return;
        }
        if (mesh->vertex_num < 0 || mesh->normal_num < 0 ||
            (mesh->vertex_num > 0 && mesh->vertex == nullptr) ||
            (mesh->normal_num > 0 && mesh->normal == nullptr) ||
            mesh->vertex_num >= std::numeric_limits<int>::max() ||
            mesh->normal_num >= std::numeric_limits<int>::max()) {
            throw std::runtime_error("invalid animation mesh dimensions");
        }
        auto      &info = frame_info[frame_no];
        const auto required = static_cast<std::size_t>(mesh->vertex_num) +
                              static_cast<std::size_t>(mesh->normal_num);
        if (required >=
            dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
            throw std::runtime_error("animation mesh exceeds arena capacity");
        }
        info.vertex_count = mesh->vertex_num;
        info.normal_count = mesh->normal_num;
        info.base_vertices =
            mesh->vertex_num > 0
                ? dc2::memory::NewArray<sceVu0FVECTOR>(
                      *memory, static_cast<std::size_t>(mesh->vertex_num))
                : nullptr;
        info.base_normals =
            mesh->normal_num > 0
                ? dc2::memory::NewArray<sceVu0FVECTOR>(
                      *memory, static_cast<std::size_t>(mesh->normal_num))
                : nullptr;
        if ((mesh->vertex_num > 0 && !info.base_vertices) ||
            (mesh->normal_num > 0 && !info.base_normals)) {
            throw std::runtime_error("animation mesh allocation failed");
        }
        if (mesh->vertex_num > 0) {
            std::memcpy(info.base_vertices, mesh->vertex,
                        static_cast<std::size_t>(mesh->vertex_num) *
                            sizeof(sceVu0FVECTOR));
        }
        if (mesh->normal_num > 0) {
            std::memcpy(info.base_normals, mesh->normal,
                        static_cast<std::size_t>(mesh->normal_num) *
                            sizeof(sceVu0FVECTOR));
        }
    } catch (const std::exception &error) {
        CT_LOG_ERROR(Data, "animation: {}", error.what());
    }
}

int CheckHitVertical(CollisionInfo *collision, float *position, float dy,
                     float *hit, int mask) {
    if (collision == nullptr || collision->polys == nullptr ||
        collision->count == 0) {
        return -1;
    }
    // Translation changes only y, including for callers using a non-unit w.
    float end[4] = {position[0], position[1] + dy, position[2], position[3]};
    int   best = -1;
    float best_y = 0.0f;
    for (int i = 0; i < collision->count; ++i) {
        CCPoly &poly = collision->polys[i];
        if ((poly.ignore_mask & mask) ||
            !mgIntersectionPoint_line_poly3(position, end, poly.vertex[0],
                                            poly.vertex[1], poly.vertex[2],
                                            poly.normal, hit)) {
            continue;
        }
        const bool nearer =
            dy <= 0.0f ? !(position[1] <= hit[1]) && (best < 0 || best_y <= hit[1])
                       : position[1] < hit[1] && (best < 0 || !(best_y < hit[1]));
        if (nearer) {
            best = i;
            best_y = hit[1];
        }
    }
    if (best >= 0) {
        hit[1] = best_y;
    }
    return best;
}

#include "common.h"

#include <cstring>
#include <utility>
#include <vector>

#include "gameutil.hpp"
#include "mg_math.hpp"
#include "stubs/gameutil.hpp"
#include "vu0_lanes.hpp"

namespace {
// Retail clears OldSkinFrame after each skin pass; DeformMesh is its only
// caller, so clearing at the motion's first skin list starts every pass from
// the same state.
mgCFrame *cached_skin_frame;

// One vertex's accumulated deformation, aligned like the quadword it replaces.
struct alignas(16) DeformVertex {
    float xyzw[4];
};

// Accumulated deformation of each vertex of the skin being deformed. Retail's
// 800-entry def_vrtx took its vertex numbers from the mesh's key lists
// unchecked; this table is sized to the skin's vertices.
std::vector<DeformVertex> deform_vertices;

// Whether the segment from..to, bounded by seg_max/seg_min, crosses poly; the
// crossing is stored in point.
bool SegmentCrossesPoly(CCPoly &poly, float *from, float *to,
                        const float *seg_max, const float *seg_min,
                        float *point) {
    float poly_min[4];
    float poly_max[4];
    float offset[4];

    mgVectorMaxMin(poly_max, poly_min, poly.vertex[0], poly.vertex[1],
                   poly.vertex[2]);

    if (seg_max[0] < poly_min[0] || seg_max[1] < poly_min[1] ||
        seg_max[2] < poly_min[2]) {
        return false;
    }

    if (!(seg_min[0] <= poly_max[0]) || !(seg_min[1] <= poly_max[1]) ||
        !(seg_min[2] <= poly_max[2])) {
        return false;
    }

    sceVu0SubVector(offset, from, poly.vertex[0]);
    const float d0 = sceVu0InnerProduct(poly.normal, offset);
    sceVu0SubVector(offset, to, poly.vertex[0]);
    const float d1 = sceVu0InnerProduct(poly.normal, offset);

    if ((d0 > 0.0f && d1 > 0.0f) || (d0 < 0.0f && d1 < 0.0f)) {
        return false;
    }

    return mgIntersectionPoint_line_poly3(from, to, poly.vertex[0],
                                          poly.vertex[1], poly.vertex[2],
                                          poly.normal, point) != 0;
}
} // namespace

void testVUnew(float (*matrix)[4], float *vertex, float *weight, float *accum,
               float *out) {
    float transformed[4];
    vu0::Transform(transformed, matrix, vertex);

    float result[4];

    for (int lane = 0; lane < 3; lane++) {
        result[lane] = accum[lane] + transformed[lane] * weight[0];
    }

    // The xyz-masked vmulx leaves w holding matrix row 2 from the lqc2 above, and
    // the full-width vadd adds that into the accumulator's w.
    result[3] = accum[3] + matrix[2][3];

    std::memcpy(accum, result, sizeof(result));
    std::memcpy(out, result, sizeof(result));
}

Mot_List *MotionProc2(mgCFrame *root, tagMOTION_TYPE *motion,
                      std::span<tagFRAME_INF> frame_info, Mot_List *list) {
    if (list == nullptr) {
        return nullptr;
    }
    if (root == nullptr || motion == nullptr || frame_info.empty() ||
        list->frame < 0 ||
        static_cast<std::size_t>(list->frame) >= frame_info.size() ||
        motion->base_matrices == nullptr ||
        (list->key_count != 0 &&
         (list->values == nullptr || list->key_frames == nullptr))) {
        return list->next;
    }

    static sceVu0FVECTOR *vert;
    static sceVu0FMATRIX  tmp_SkinMatrix;
    static sceVu0FMATRIX  tmp_SkinMatrix_inv;
    static sceVu0FMATRIX  tmp_ChrMatrix;
    static sceVu0FMATRIX  tmp_BaseSkinMatrix;
    static sceVu0FMATRIX  tmp_BaseSkinMatrix_inv;
    float                 deform[4][4];
    float                 bone_matrix[4][4];
    float                 bone_in_skin[4][4];
    float                 skin_bone[4][4];
    float                 bone_in_skin_inv[4][4];
    float                 bone_base[4][4];
    float                 moved[4];
    float                 weight[4];
    mgCFrame             *bone = nullptr;
    mgCFrame             *skin = nullptr;
    unsigned int          i = 0;
    int                   vertex = 0;

    if (list == motion->skin_list) {
        cached_skin_frame = nullptr;
    }

    if (list->key_count == 0) {
        return list->next;
    }

    bone = root->GetFrame(list->target);
    skin = root->GetFrame(list->frame);
    if (bone == nullptr || skin == nullptr || skin->visual == nullptr) {
        return list->next;
    }
    const auto *mesh = static_cast<mgCVisualMDT *>(skin->visual);
    const auto &info = frame_info[static_cast<std::size_t>(list->frame)];
    if (mesh->vertex_num < 0 ||
        info.vertex_count > static_cast<u32>(mesh->vertex_num) ||
        (info.vertex_count != 0 &&
         (mesh->vertex == nullptr || info.base_vertices == nullptr))) {
        return list->next;
    }

    if (cached_skin_frame != skin) {
        cached_skin_frame = skin;
        vert = static_cast<mgCVisualMDT *>(skin->visual)->vertex;

        deform_vertices.assign(frame_info[list->frame].vertex_count,
                               DeformVertex{
                                   {0.0f, 0.0f, 0.0f, 1.0f}
        });

        skin->GetLWMatrix(tmp_SkinMatrix);
        root->GetLWMatrix(tmp_ChrMatrix);
        mgInversMatrix(tmp_SkinMatrix_inv, tmp_SkinMatrix);
        mgMulMatrix(tmp_BaseSkinMatrix, tmp_ChrMatrix,
                    motion->base_matrices[list->frame]);
        mgInversMatrix(tmp_BaseSkinMatrix_inv, tmp_BaseSkinMatrix);
    }

    sceVu0UnitMatrix(bone_matrix);
    sceVu0UnitMatrix(tmp_SkinMatrix);
    bone->GetLWMatrix(bone_matrix);
    mgMulMatrix(bone_base, tmp_ChrMatrix, motion->base_matrices[list->target]);
    mgMulMatrix(bone_in_skin, tmp_BaseSkinMatrix_inv, bone_base);
    mgInversMatrix(bone_in_skin_inv, bone_in_skin);
    mgMulMatrix(skin_bone, tmp_SkinMatrix_inv, bone_matrix);
    mgMulMatrix(deform, skin_bone, bone_in_skin_inv);

    for (i = 0; i < list->key_count; i++) {
        weight[0] = 0.01f * list->values[i][0];
        if (list->key_frames[i] >= deform_vertices.size()) {
            continue;
        }
        vertex = static_cast<int>(list->key_frames[i]);
        float *accum = deform_vertices[vertex].xyzw;

        if (list->type == MOTION_KEY_SKIN_WEIGHTED) {
            testVUnew(deform, frame_info[list->frame].base_vertices[vertex], weight,
                      accum, vert[vertex]);
        } else {
            sceVu0ApplyMatrix(moved, deform,
                              frame_info[list->frame].base_vertices[vertex]);
            moved[3] = 0.0f;
            accum[0] += moved[0];
            accum[1] += moved[1];
            accum[2] += moved[2];
            accum[0] = vu0::Div(accum[0], accum[3]);
            accum[1] = vu0::Div(accum[1], accum[3]);
            accum[2] = vu0::Div(accum[2], accum[3]);
            sceVu0CopyVectorXYZ(vert[vertex], accum);
            accum[3] += 1.0f;
        }
    }

    return list->next;
}

int CheckHit(CollisionInfo *collision, float *from, float *to, float *hit,
             int closest, int mask) {
    if (collision == nullptr) {
        return 0;
    }

    float seg_max[4];
    float seg_min[4];
    mgVectorMaxMin(seg_max, seg_min, from, to);

    CCPoly   *poly = collision->polys;
    const int count = collision->count;
    if (poly == nullptr || count == 0) {
        return -1;
    }

    int   best = -1;
    bool  has_best = false;
    float best_dist = 0.0f;
    for (int i = 0; i < count; i++, poly++) {
        float point[4];
        if ((poly->ignore_mask & mask) ||
            !SegmentCrossesPoly(*poly, from, to, seg_max, seg_min, point)) {
            continue;
        }

        if (closest == 0) {
            best = i;
            sceVu0CopyVector(hit, point);
            break;
        }

        const float diff[3] = {from[0] - point[0], from[1] - point[1],
                               from[2] - point[2]};
        const float dist =
            (diff[0] * diff[0]) + (diff[1] * diff[1]) + (diff[2] * diff[2]);
        if (!has_best || !(best_dist <= dist)) {
            best_dist = dist;
            best = i;
            sceVu0CopyVector(hit, point);
        }
        has_best = true;
    }

    return best;
}

int CheckHits(CollisionInfo *info, float *from, float *to, int max_hits,
              int *hit_polys, float (*hit_points)[4], int sort,
              int ignore_mask) {
    float seg_max[4];
    float seg_min[4];
    mgVectorMaxMin(seg_max, seg_min, from, to);

    int     hits = 0;
    CCPoly *poly = info->polys;
    for (int i = 0; i < info->count; i++, poly++) {
        float point[4];
        if ((poly->ignore_mask & ignore_mask) ||
            !SegmentCrossesPoly(*poly, from, to, seg_max, seg_min, point)) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], point);
        hit_points[hits][3] = mgDistVector(from, point);
        hits++;
    }

    if (sort == 0) {
        return hits;
    }

    // Retail sorts ascending whatever the sign of sort.
    for (int i = 0; i < hits - 1; i++) {
        for (int j = i + 1; j < hits; j++) {
            if (!(hit_points[i][3] <= hit_points[j][3])) {
                std::swap(hit_polys[i], hit_polys[j]);
                float swap[4];
                sceVu0CopyVector(swap, hit_points[i]);
                sceVu0CopyVector(hit_points[i], hit_points[j]);
                sceVu0CopyVector(hit_points[j], swap);
            }
        }
    }

    return hits;
}
