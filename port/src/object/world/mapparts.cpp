#include "common.h"

#include <algorithm>
#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <memory>
#include <utility>

#include "character.hpp"
#include "collision.hpp"
#include "funcpoint.hpp"
#include "log/game_output.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "occlusion.hpp"
#include "text/bounded.hpp"

/**
 *
 * Centre and radius of a bounding sphere.
 *
 */
struct SphereVec {
    float v[3]; /**< Centre coordinates. */
    float w;    /**< Radius. */
};

/**
 *
 * Map part vector viewed as floats or a quadword.
 *
 */
union PartsVector {
    float     values[4]; /**< Floating point components. */
    u_long128 quad;      /**< The same components as one quadword. */
};

#include <libvu0.h>

#include <cmath>

#include "intersection.hpp"

namespace {
using PieceBindings = std::vector<dc2::world::PieceBinding>;
std::atomic<std::uint64_t> next_part_assignment{1}; /**< Monotonic identities of initialized and copied part assignments. */

void TracePartFailure(const char *reason, std::string_view name) {
    static std::atomic<unsigned> emitted{};
    const auto                  *enabled = std::getenv("DC2_SWITCH_MODEL_TRACE");
    if (enabled == nullptr || std::strcmp(enabled, "1") != 0 || emitted.fetch_add(1, std::memory_order_relaxed) >= 32) {
        return;
    }
    dc2::log::PrintGame("switch-model: %s name=%.*s\n", reason, static_cast<int>(std::min<std::size_t>(name.size(), 128)), name.empty() ? "" : name.data());
}

/**
 * Issues an identity independent of source object addresses and arena reuse.
 */
std::uint64_t NewPartAssignment() {
    return next_part_assignment.fetch_add(1, std::memory_order_relaxed);
}
} // namespace

dc2::world::PieceView dc2::world::PieceView::Capture(mgCMemory &producer, CList<CMapPiece> &node) {
    PieceView result;
    result.node_storage = dc2::memory::ArenaBuffer::Bind(producer, std::span(reinterpret_cast<u8 *>(&node), sizeof(node)));
    const auto offset = static_cast<std::size_t>(reinterpret_cast<u8 *>(&node.data) - reinterpret_cast<u8 *>(&node));
    result.piece_storage = result.node_storage.Subspan(offset, sizeof(node.data));
    if (result.node_storage.Bytes().size() != sizeof(node) || result.piece_storage.Bytes().size() != sizeof(node.data)) {
        return {};
    }
    result.material_count = node.data.material_num;
    if (result.material_count < 0) {
        return {};
    }
    if (result.material_count > 0) {
        if (node.data.material == nullptr) {
            return {};
        }
        result.material_storage = dc2::memory::ArenaBuffer::Bind(
            producer, std::span(reinterpret_cast<u8 *>(node.data.material), static_cast<std::size_t>(result.material_count) * sizeof(PieceMaterial)));
    }
    result.frame_graph = node.data.frame_graph;
    return result.Get() != nullptr ? result : PieceView{};
}

CMapPiece *dc2::world::PieceView::Get() const {
    const auto node = node_storage.Bytes();
    const auto object = piece_storage.Bytes();
    if (node.size() != sizeof(CList<CMapPiece>) || object.size() != sizeof(CMapPiece)) {
        return nullptr;
    }
    auto *piece = reinterpret_cast<CMapPiece *>(object.data());
    if (piece->material_num != material_count) {
        return nullptr;
    }
    if (material_count > 0) {
        const auto materials = material_storage.Bytes();
        if (materials.size() != static_cast<std::size_t>(material_count) * sizeof(PieceMaterial) || materials.data() != reinterpret_cast<u8 *>(piece->material)) {
            return nullptr;
        }
    }
    if (!frame_graph.HasValue()) {
        return !piece->frame_graph.HasValue() && piece->frame == nullptr && piece->chara == nullptr ? piece : nullptr;
    }
    return piece->frame_graph.SameIdentity(frame_graph) && frame_graph.Matches(piece->frame, piece->chara) ? piece : nullptr;
}

bool CMapParts::PublishPieceBindings(std::vector<dc2::world::PieceBinding> bindings) {
    piece_bindings = {};
    assignment_token = NewPartAssignment();
    if (bindings.empty()) {
        return piece_list == nullptr;
    }
    if (bindings.front().view.NodeStorage().Bytes().data() != reinterpret_cast<u8 *>(piece_list)) {
        return false;
    }
    for (const auto &binding : bindings) {
        if (binding.view.Get() == nullptr) {
            return false;
        }
    }
    const auto anchor = bindings.front().view.NodeStorage();
    piece_bindings = dc2::memory::ArenaResource::Store(anchor, std::make_shared<PieceBindings>(std::move(bindings)));
    return piece_bindings.IsLive();
}

dc2::world::PieceView CMapParts::FindPieceView(std::string_view name) const {
    const auto bindings = piece_bindings.Acquire<PieceBindings>();
    if (bindings == nullptr) {
        return {};
    }
    for (const auto &binding : *bindings) {
        if (binding.name == name && binding.view.Get() != nullptr) {
            return binding.view;
        }
    }
    return {};
}

bool CMapParts::HasStandaloneFrame() const {
    return frame.parent == nullptr && frame.child == nullptr && frame.brother == nullptr && frame.elder == nullptr;
}

void CMapParts::Initialize() {
    int i = {};

    piece_list = nullptr;
    piece_bindings = {};
    assignment_token = NewPartAssignment();
    name[0] = 0;
    parts_name[0] = 0;
    frame.Initialize();
    in_screen = 1;
    lod_num = 0;
    minimap_tile = 0;
    lod_dist = nullptr;
    lod_blend = 0;
    color_num = 4;
    func_point_mngr.Initialize();
    func_check.time = 0;
    no_plight = 0;
    no_light = 0;
    group_no = -1;
    move_flag = 0;
    anime_list = nullptr;
    bound_valid = 0;
    mgZeroVectorW(bound_box.max);
    mgZeroVectorW(bound_box.min);
    mgZeroVector(bound_sphere);

    for (i = 0; i < color_num; i++) {
        mgZeroVector(color[i]);
    }

    col_bound_valid = 0;
    mgZeroVectorW(col_bound_box.max);
    mgZeroVectorW(col_bound_box.min);
    mgZeroVector(col_bound_sphere);
    need_step = 0;
    fixed_time = -1.0f;
    CObject::Initialize();
}

void CMapParts::SetName(char *new_name) {
    if (new_name == nullptr || static_cast<u32>(strlen(new_name)) > 0x1F) {
        return;
    }

    dc2::text::Copy(name, dc2::text::View(new_name));
}

void CMapParts::SetPartsName(char *new_name) {
    if (new_name == nullptr || static_cast<u32>(strlen(new_name)) > 0x1F) {
        return;
    }

    dc2::text::Copy(parts_name, dc2::text::View(new_name));
}

void CMapParts::AddPiece(CList<CMapPiece> *node) {
    if (node == nullptr) {
        return;
    }

    if (node->data.type & 4) {
        need_step = 1;
    }

    CList<CMapPiece> *last = piece_list;

    if (last == nullptr) {
        piece_list = node;
        return;
    }

    CList<CMapPiece> *next = {};

    if (last != nullptr) {
        do {
            next = last->next;

            if (next == nullptr) {
                break;
            }

            last = next;
        } while (next);
    }

    last->next = node;

    if (node != nullptr) {
        node->prev = last;
    }
}

CMapPiece *CMapParts::SearchPiece(const char *piece_name) {
    return piece_name != nullptr ? FindPieceView(piece_name).Get() : nullptr;
}

CMapPiece *CMapParts::SearchPieceColType(int col_type) {
    const auto bindings = piece_bindings.Acquire<PieceBindings>();
    if (bindings == nullptr) {
        return nullptr;
    }
    for (const auto &binding : *bindings) {
        auto *piece = binding.view.Get();
        if (piece != nullptr && piece->col_type == col_type) {
            return piece;
        }
    }

    return nullptr;
}

int CMapParts::GetPoly(int kind, CCPoly *poly, mgVu0FBOX &box, int max) {
    CList<CMapPiece> *node = {};
    int               total = {};
    CMapPiece        *piece = {};
    mgCFrame         *piece_frame = {};
    int               found = {};

    if (this->GetShow() == 0) {
        return 0;
    }

    node = piece_list;
    this->UpDatePosition();
    total = 0;

    if (node != nullptr) {
        do {
            piece = &node->data;

            if (piece != nullptr) {
                piece_frame = piece->frame;

                if (piece_frame != nullptr) {
                    if (piece_frame->parent == nullptr) {
                        piece_frame->SetReference(&frame);
                        found = piece->GetPoly(kind, poly, box, max);
                        poly += found;
                        max -= found;
                        total += found;
                        piece_frame->DeleteReference();

                        if (max <= 0) {
                            break;
                        }
                    }
                }
            }

            node = node->next;
        } while (node != nullptr);
    }

    return total;
}

int CMapParts::GetColPoly(CCPoly *poly, mgVu0FBOX &box, int max) {
    return GetPoly(MDS_TYPE_COLLISION, poly, box, max);
}

int CMapParts::GetCameraPoly(CCPoly *poly, mgVu0FBOX &box, int max) {
    return GetPoly(MDS_TYPE_CAMERA_COLLISION, poly, box, max);
}

void CMapParts::UpDatePosition() {
    if (changed) {
        frame.SetPosition(position);
        frame.SetRotation(rotation);
        frame.SetScale(scale);
        changed = 0;
    }
}

int CMapParts::SetColor(int no, float *rgba) {
    if (no < 0 || no >= color_num) {
        return 0;
    }

    std::memmove(color[no], rgba, sizeof(float) * 4);
    color[no][3] = 1.0f;
    return 1;
}

int CMapParts::GetColor(int no, float *out_rgba) {
    if (no < 0 || no >= color_num) {
        return 0;
    }

    std::memmove(out_rgba, color[no], sizeof(float) * 4);
    return 1;
}

int CMapParts::GetDefColor(int id, float *out_color) {
    CList<CMapPiece> *node = {};
    int               i = {};
    CMapPiece        *piece = {};
    int               material_count = {};
    PieceMaterial    *material = {};

    if (id < 0 || id >= color_num) {
        return 0;
    }

    for (node = piece_list; node != nullptr; node = node->next) {
        piece = &node->data;
        material_count = piece->material_num;

        for (i = 0; i < material_count; i++) {
            material = piece->GetMaterial(i);

            if (material != nullptr && material->material != nullptr && id == material->color_no) {
                sceVu0CopyVector(out_color, material->color);
                return 1;
            }
        }
    }

    return 0;
}

void CMapParts::UpdateColor() {
    int               id = {};
    CList<CMapPiece> *node = {};
    int               j = {};
    CMapPiece        *piece = {};
    int               material_count = {};
    PieceMaterial    *material = {};

    for (id = 0; id < color_num; id++) {
        node = piece_list;

        if (color[id][3] > 0.0f) {
            for (; node != nullptr; node = node->next) {
                piece = &node->data;
                material_count = piece->material_num;

                for (j = 0; j < material_count; j++) {
                    material = piece->GetMaterial(j);

                    if (material != nullptr && material->material != nullptr && id == material->color_no) {
                        sceVu0CopyVectorXYZ(material->color, color[id]);
                    }
                }
            }
        }
    }
}

int CMapParts::PreDraw() {
    float alpha = {};

    if (!CObject::PreDraw()) {
        return 0;
    }

    UpDatePosition();
    return FarClip(mgGetDistFromCamera(position), &alpha);
}

int CMapParts::DrawSub(int direct) {
    sceVu0FMATRIX     no_lights;
    sceVu0FVECTOR     light_position;
    sceVu0FVECTOR     ambient;
    sceVu0FVECTOR     light_color;
    sceVu0FVECTOR     plight_color;
    int               light_no = {};
    int               plight_no = {};
    int               pass = {};
    int               draw_num = {};
    CFuncPoint       *point = {};
    CList<CMapPiece> *node = {};
    CMapPiece        *piece = {};
    float             weight = {};
    float             ambient_alpha = {};
    int               lighting_set = {};
    int               old_lighting = {};
    int               plight_enable = {};
    mgCFrame         *piece_frame = {};

    if (!PreDraw()) {
        return 0;
    }

    light_no = 3;
    lighting_set = 0;
    old_lighting = -1;
    plight_no = light_no;
    plight_enable = mgGetPlightEnable();

    if (no_light) {
        mgZeroMatrix(no_lights);
        old_lighting = mgActiveLighting(3, 1);
        mgSetLight(no_lights, no_lights);
        mgResetPlight();
        lighting_set = 1;
    }

    if (no_plight) {
        mgPlightEnable(0);
    }

    if (func_point_mngr.flag & FUNC_POINT_MNGR_PLIGHT) {
        func_point_mngr.GetStart(FUNC_POINT_PLIGHT);

        if ((point = func_point_mngr.Get()) != nullptr) {
            do {
                if (!point->active) {
                    continue;
                }

                if (!lighting_set) {
                    old_lighting = mgActiveLighting(3, 1);
                    lighting_set = 1;
                }

                weight = 1.0f;
                weight *= GetLightAnimeWeight(point, func_check.anime_frame);

                switch (point->plight.light_type) {
                    case FUNC_PLIGHT_DIRECTIONAL:
                        if (light_no >= 0) {
                            frame.GetWorldDir(light_position, point->position);
                            sceVu0Normalize(light_position, light_position);
                            sceVu0ScaleVector(light_color, point->plight.color, weight);
                            light_color[3] = 128.0f;
                            mgSetLight(light_no, light_position, light_color);
                            light_no--;
                        }

                        break;

                    case FUNC_PLIGHT_AMBIENT:
                        mgGetAmbient(ambient);
                        ambient[0] = point->plight.color[0] * weight;
                        ambient[1] = point->plight.color[1] * weight;
                        ambient[2] = point->plight.color[2] * weight;
                        mgSetAmbient(ambient);
                        break;

                    case FUNC_PLIGHT_POINT:
                        mgPlightEnable(1);

                        if (plight_no >= 0 && point->plight.no_map_light == 0) {
                            frame.GetWorldPosition(light_position, point->position);
                            float plight_weight = GetLightAnimeWeight(point, 0);
                            sceVu0ScaleVector(plight_color, point->plight.color, plight_weight * weight);
                            mgSetPlight(plight_no, light_position, plight_color, point->plight.power, -1.0f);
                            plight_no--;
                        }

                        break;

                    case 3:
                        mgGetAmbient(ambient);
                        ambient_alpha = ambient[3];
                        sceVu0ScaleVector(light_color, point->plight.color, weight);
                        mgAddVector(ambient, light_color);
                        ambient[3] = ambient_alpha;
                        mgSetAmbient(ambient);
                        break;
                }
            } while ((point = func_point_mngr.Get()) != nullptr);
        }
    }

    draw_num = 0;

    for (pass = 0; pass < 1; pass++) {
        node = piece_list;

        if (node != nullptr) {
            do {
                piece = &node->data;

                if (CheckTime(func_check.time, piece->time_start, piece->time_end)) {
                    piece->draw_off &= ~1;
                } else {
                    piece->draw_off |= 1;
                }

                piece_frame = piece->frame;

                if (piece_frame != nullptr && piece_frame->parent == nullptr) {
                    piece_frame->SetReference(&frame);

                    if (direct == 0) {
                        draw_num += piece->Draw();
                    } else {
                        draw_num += piece->DrawDirect();
                    }

                    piece_frame->DeleteReference();
                }

                node = node->next;
            } while (node != nullptr);
        }
    }

    if (lighting_set) {
        mgActiveLighting(old_lighting, 0);
    }

    mgPlightEnable(plight_enable);
    return draw_num;
}

void CMapParts::DrawStep() {
    CList<CMapPiece> *node = {};
    CMapPiece        *piece = {};

    UpDatePosition();
    CObject::DrawStep();

    for (node = piece_list; node != nullptr; node = node->next) {
        piece = node->pGetData();
        piece->UpDatePosition();
        piece->DrawStep();
    }
}

int CMapParts::CreateBoundBox() {
    mgVu0FBOX         box{};
    CList<CMapPiece> *node = {};
    CMapPiece        *piece = {};
    int               found = {};
    int               col_found = {};
    int               first = {};
    int               col_first = {};

    found = 0;
    first = 1;
    col_found = 0;
    col_first = first;

    for (node = piece_list; node != nullptr; node = node->next) {
        piece = node->pGetData();

        if (piece == nullptr || piece->frame == nullptr || !piece->GetBoundBox(&box)) {
            continue;
        }

        if (piece->type & MDS_TYPE_COLLISION) {
            if (col_first) {
                col_bound_box = box;
                col_first = 0;
            } else {
                mgVectorMaxMin(col_bound_box.max, col_bound_box.min, col_bound_box.max, col_bound_box.min, box.max, box.min);
            }

            col_found = 1;
        } else {
            if (first) {
                bound_box = box;
                first = 0;
            } else {
                mgVectorMaxMin(bound_box.max, bound_box.min, bound_box.max, bound_box.min, box.max, box.min);
            }

            found = 1;
        }
    }

    sceVu0AddVector(bound_sphere, bound_box.min, bound_box.max);
    sceVu0ScaleVector(bound_sphere, bound_sphere, 0.5f);
    bound_sphere[3] = 0.5f * mgDistVector(bound_box.min, bound_box.max);

    sceVu0AddVector(col_bound_sphere, col_bound_box.min, col_bound_box.max);
    sceVu0ScaleVector(col_bound_sphere, col_bound_sphere, 0.5f);
    col_bound_sphere[3] = 0.5f * mgDistVector(col_bound_box.min, col_bound_box.max);

    bound_valid = found;
    col_bound_valid = col_found;
    return found | col_found;
}

int CMapParts::CheckColBox(mgVu0FBOX *box) {
    sceVu0FMATRIX lw_matrix;
    sceVu0FVECTOR sphere;
    mgVu0FBOX     world_box{};

    if (!col_bound_valid) {
        return 0;
    }

    GetLWMatrix(lw_matrix);
    std::memmove(sphere, col_bound_sphere, sizeof(float) * 4);
    sphere[3] = 1.0f;
    sceVu0ApplyMatrix(sphere, lw_matrix, sphere);
    sphere[3] = col_bound_sphere[3];

    // The sphere is tested first, on X and Z only.
    if (sphere[0] + sphere[3] < box->min[0]) {
        return 0;
    }

    if (sphere[0] - sphere[3] > box->max[0]) {
        return 0;
    }

    if (sphere[2] + sphere[3] < box->min[2]) {
        return 0;
    }

    if (sphere[2] - sphere[3] > box->max[2]) {
        return 0;
    }

    mgApplyMatrix(world_box.max, world_box.min, lw_matrix, col_bound_box.max, col_bound_box.min);
    return mgClipBox(world_box.max, world_box.min, box->max, box->min) != 0;
}

int CMapParts::GetBBox(mgVu0FBOX *box) {
    int has_box = {};

    has_box = bound_valid;

    if (has_box == 0) {
        return has_box;
    }

    (*box = bound_box);
    return bound_valid;
}

int CMapParts::GetBoundBox(mgVu0FBOX *out_box) {
    sceVu0FMATRIX lw_matrix;

    if (!bound_valid) {
        return 0;
    }

    GetLWMatrix(lw_matrix);
    mgApplyMatrix(out_box->max, out_box->min, lw_matrix, bound_box.max, bound_box.min);
    return 1;
}

int CMapParts::GetBoundSphere(float *sphere) {
    sceVu0FMATRIX matrix;
    float         sphere_center[4];
    float         radius = {};

    if (bound_valid == 0) {
        return 0;
    }

    GetLWMatrix(matrix);
    *reinterpret_cast<PartsVector *>(sphere_center) = *reinterpret_cast<PartsVector *>(bound_sphere);
    radius = bound_sphere[3];
    sphere_center[3] = 1.0f;
    sceVu0ApplyMatrix(sphere, matrix, sphere_center);
    sphere[3] = radius;
    return bound_valid;
}

void CMapParts::GetLWMatrix(sceVu0FMATRIX out_matrix) {
    if (!HasStandaloneFrame()) {
        mgUnitMatrix(out_matrix);
        return;
    }
    UpDatePosition();
    frame.GetLWMatrix(out_matrix);
}

int CMapParts::InsideScreen() {
    sceVu0FMATRIX lw_matrix;
    sceVu0FVECTOR screen_max;
    sceVu0FVECTOR screen_min;

    if (!bound_valid) {
        return 0;
    }

    GetLWMatrix(lw_matrix);
    return mgInsideScreen(&bound_box, lw_matrix, screen_max, screen_min);
}

int CMapParts::InsideScreen(COcclusion *occluders, int count) {
    sceVu0FMATRIX matrix;
    SphereVec     sphere{};
    float         radius = {};
    int           i = {};

    if (bound_valid == 0) {
        return 0;
    }

    GetLWMatrix(matrix);

    if (mgInsideScreen(&bound_box, matrix) == 0) {
        return 0;
    }

    if (count <= 0) {
        return 1;
    }

    mgMulMatrix(matrix, mgRenderInfo.view, matrix);
    *reinterpret_cast<PartsVector *>(&sphere) = *reinterpret_cast<PartsVector *>(bound_sphere);
    radius = bound_sphere[3];
    sphere.w = 1.0f;
    sceVu0ApplyMatrix(&sphere.v[0], matrix, &sphere.v[0]);
    sphere.w = radius;

    for (i = 0; i < count; i++) {
        if (occluders->CheckSphere(&sphere.v[0]) != 0) {
            return 0;
        }

        occluders++;
    }

    return 1;
}

CFuncPoint *CMapParts::InScreenFunc(InScreenFuncInfo *info) {
    sceVu0FMATRIX point_matrix;
    sceVu0FVECTOR to_point;
    sceVu0FVECTOR facing;
    sceVu0FMATRIX camera_pose;
    sceVu0FVECTOR ray_start;
    sceVu0FVECTOR ray_end;
    sceVu0FVECTOR ray_far;
    sceVu0FVECTOR ray_near;
    sceVu0FVECTOR hit[2];
    sceVu0FVECTOR camera_pos;
    CFuncPoint   *point = {};
    CFuncPoint   *nearest = {};
    float         nearest_dist = {};
    float         range = {};
    float         facing_cos = {};
    float         dist = {};
    float         nearest_aux = {};

    if (func_point_mngr.UpdateFlag(FUNC_POINT_INVENT, &func_check) <= 0) {
        return nullptr;
    }

    func_point_mngr.GetStart(FUNC_POINT_INVENT);
    nearest_aux = 0.0f;
    mgCFrame *parts_frame = &frame;
    nearest = nullptr;
    nearest_dist = nearest_aux;

    if ((point = func_point_mngr.Get()) != nullptr) {
        do {
            if (!point->Check(nullptr)) {
                continue;
            }

            point->frame.SetReference(parts_frame);
            point->frame.GetLWMatrix(point_matrix);

            range = point->invent.range;

            if (range == 0.0f) {
                range = 400.0f;
            }

            mgGetDirFromCamera(to_point, point_matrix[3]);

            bool facing_ok = true;
            if (!(point->invent.angle <= 0.0f)) {
                sceVu0ScaleVector(facing, point_matrix[2], -1.0f);
                sceVu0Normalize(facing, facing);
                sceVu0Normalize(to_point, to_point);
                facing_cos = sceVu0InnerProduct(to_point, facing);

                if (facing_cos < cosf(point->invent.angle)) {
                    facing_ok = false;
                }
            }

            if (facing_ok) {
                mgGetCameraPos(camera_pos);
                mgGetCameraPose(camera_pose);
                sceVu0Normalize(ray_far, camera_pose[2]);
                std::memmove(ray_near, ray_far, sizeof(float) * 4);
                sceVu0ScaleVector(ray_far, ray_far, range);
                sceVu0ScaleVector(ray_near, ray_near, 1.0f);
                sceVu0AddVector(ray_start, camera_pos, ray_near);
                sceVu0AddVector(ray_end, camera_pos, ray_far);

                if (IntersectionBox(ray_start, ray_end, &point->invent.box, point_matrix, hit) > 0) {
                    dist = mgDistVector(hit[0], camera_pos);

                    if (dist <= 10.0f + info->range) {
                        if (nearest == nullptr || dist < nearest_dist) {
                            nearest = point;
                            nearest_aux = 0.0f;
                            nearest_dist = dist;
                        }
                    }
                }
            }

            point->frame.DeleteReference();
        } while ((point = func_point_mngr.Get()) != nullptr);
    }

    func_point_mngr.GetEnd();
    info->unk_04 = nearest_aux;
    info->dist = nearest_dist;
    return nearest;
}

void CMapParts::DrawScreenFunc(mgCFrame *marker) {
    float       point_matrix[4][4];
    float       box_matrix[4][4];
    float       marker_matrix[4][4];
    float       extent[4];
    float       origin[4];
    CFuncPoint *point = {};
    float       range = {};

    if (func_point_mngr.UpdateFlag(FUNC_POINT_INVENT, &func_check) <= 0) {
        return;
    }

    func_point_mngr.GetStart(FUNC_POINT_INVENT);

    mgCFrame *parts_frame = &frame;

    if ((point = func_point_mngr.Get()) != nullptr) {
        do {
            if (!point->Check(nullptr)) {
                continue;
            }

            point->frame.SetReference(parts_frame);
            point->frame.GetLWMatrix(point_matrix);

            if (marker != nullptr) {
                mgUnitMatrix(box_matrix);
                float *extent_x = &extent[0];
                float *origin_x = &origin[0];
                float *extent_y = &extent[1];
                float *origin_y = &origin[1];
                float *extent_z = &extent[2];
                float *origin_z = &origin[2];
                box_matrix[0][0] = *extent_x = point->invent.box.max[0] - point->invent.box.min[0];
                box_matrix[3][0] = *origin_x = point->invent.box.min[0];
                box_matrix[1][1] = *extent_y = point->invent.box.max[1] - point->invent.box.min[1];
                box_matrix[3][1] = *origin_y = point->invent.box.min[1];
                box_matrix[2][2] = *extent_z = point->invent.box.max[2] - point->invent.box.min[2];
                box_matrix[3][2] = *origin_z = point->invent.box.min[2];

                range = point->invent.range;

                if (range == 0.0f) {
                    range = 400.0f;
                }

                if (!(mgGetDistFromCamera(point_matrix[3]) <= 4.0f * range)) {
                    continue;
                }

                mgMulMatrix(marker_matrix, point_matrix, box_matrix);
                marker->SetTransMatrix(marker_matrix);
                mgDrawDirect(marker);
            }

            point->frame.DeleteReference();
        } while ((point = func_point_mngr.Get()) != nullptr);
    }

    func_point_mngr.GetEnd();
}

void CMapParts::Step() {
    CList<CMapPiece> *node = {};
    CMapPiece        *piece = {};
    mgCFrame         *piece_frame = {};

    if (need_step == 0) {
        return;
    }

    node = piece_list;

    if (node != nullptr) {
        do {
            piece = &node->data;
            piece_frame = piece->frame;

            if (piece_frame != nullptr) {
                piece_frame->SetReference(&frame);
                piece->Step();
                piece_frame->DeleteReference();
            }

            node = node->next;
        } while (node != nullptr);
    }
}

void CMapParts::AnimeStep(CFuncPointCheck *check, CObjAnimeEnv *env) {
    CList<CObjAnime> *node = {};
    CObjAnime        *anime = {};

    for (node = anime_list; node != nullptr; node = node->next) {
        anime = node->pGetData();

        if (anime->func_point != nullptr && anime->func_point->Check(check)) {
            anime->Step(env);
        }
    }
}

void CMapParts::StepFuncPoint(CFuncPointCheck &check) {
    CopyFuncPointCheck(check);
    func_point_mngr.UpdateFlag(FUNC_POINT_FIRE, &func_check);
    func_point_mngr.UpdateFlag(FUNC_POINT_FLARE, &func_check);
    func_point_mngr.UpdateFlag(FUNC_POINT_EFFECT, &func_check);
    func_point_mngr.Step(FUNC_POINT_PLIGHT, &func_check);
}

void CMapParts::CopyFuncPointCheck(CFuncPointCheck &check) {
    func_check.time = check.time;
    func_check.anime_frame = check.anime_frame;

    if (fixed_time >= 0.0f) {
        func_check.time = fixed_time;
    }
}

bool CMapParts::Copy(CMapParts &dest, mgCMemory *memory) {
    const auto bindings = piece_bindings.Acquire<PieceBindings>();
    CMapParts  source = *this;
    dest.Initialize();
    if (!source.HasStandaloneFrame()) {
        TracePartFailure("copy-part-frame", dc2::text::View(source.name));
        return false;
    }
    if (source.piece_list != nullptr && bindings == nullptr) {
        TracePartFailure("copy-part-bindings", dc2::text::View(source.name));
        return false;
    }
    if (bindings != nullptr) {
        for (const auto &binding : *bindings) {
            if (binding.view.Get() == nullptr) {
                TracePartFailure("copy-source-piece", binding.name);
                return false;
            }
        }
    }
    dest = source;
    dest.assignment_token = NewPartAssignment();
    dest.piece_list = nullptr;
    dest.piece_bindings = {};
    if (memory == nullptr) {
        dest.piece_list = source.piece_list;
        dest.piece_bindings = source.piece_bindings;
        return true;
    }
    dest.anime_list = nullptr;
    PieceBindings     copies;
    CList<CMapPiece> *last = nullptr;
    if (bindings != nullptr) {
        for (const auto &binding : *bindings) {
            auto *piece = binding.view.Get();
            if (piece == nullptr) {
                TracePartFailure("copy-retired-piece", binding.name);
                dest.Initialize();
                return false;
            }
            if (piece->col_type != 0) {
                continue;
            }
            auto *copy = dc2::memory::NewObject<CList<CMapPiece>>(*memory);
            if (copy == nullptr) {
                TracePartFailure("copy-piece-allocation", binding.name);
                dest.Initialize();
                return false;
            }
            if (!piece->Copy(copy->data, memory)) {
                TracePartFailure("copy-piece-copy", binding.name);
                dest.Initialize();
                return false;
            }
            auto        view = dc2::world::PieceView::Capture(*memory, *copy);
            auto       *name = dc2::memory::CopyText(*memory, binding.name);
            const char *failure = nullptr;
            if (view.Get() == nullptr) {
                failure = "copy-piece-view";
            } else if (name == nullptr) {
                failure = "copy-piece-name";

            } else if (piece->frame != nullptr && copy->data.frame == nullptr) {
                failure = "copy-piece-frame";
            } else if (piece->chara != nullptr && copy->data.chara == nullptr) {
                failure = "copy-piece-character";
            }
            if (failure != nullptr) {
                TracePartFailure(failure, binding.name);
                dest.Initialize();
                return false;
            }
            copy->data.SetName(name);
            copy->prev = last;
            if (last != nullptr) {
                last->next = copy;
            } else {
                dest.piece_list = copy;
            }
            last = copy;
            copies.push_back({binding.name, view});
        }
    }
    if (!dest.PublishPieceBindings(std::move(copies))) {
        TracePartFailure("copy-publish-bindings", dc2::text::View(source.name));
        dest.Initialize();
        return false;
    }
    if (source.func_point_mngr.Copy(dest.func_point_mngr, memory) == 0) {
        TracePartFailure("copy-function-points", dc2::text::View(source.name));
        dest.Initialize();
        return false;
    }
    if (dest.AssignFuncAnime(memory) == 0) {
        TracePartFailure("copy-function-animation", dc2::text::View(source.name));
        dest.Initialize();
        return false;
    }
    return true;
}

int CMapParts::AssignFuncAnime(mgCMemory *memory) {
    if (memory == nullptr) {
        return 0;
    }
    CFuncPoint       *point = {};
    CList<CObjAnime> *node = {};

    func_point_mngr.GetStart(FUNC_POINT_ANIME);

    while ((point = func_point_mngr.Get()) != nullptr) {
        node = dc2::memory::NewObject<CList<CObjAnime>>(*memory);

        if (node == nullptr) {
            return 0;
        }

        node->Initialize();

        CList<CObjAnime> *last = anime_list;

        if (last == nullptr) {
            anime_list = node;
        } else {
            CList<CObjAnime> *next = {};

            if (last != nullptr) {
                do {
                    next = last->next;

                    if (next == nullptr) {
                        break;
                    }

                    last = next;
                } while (next);
            }

            last->next = node;

            if (node != nullptr) {
                node->prev = last;
            }
        }

        node->pGetData()->AssignFuncAnime(point, this);
    }

    return 1;
}

template <>
void CList<CObjAnime>::Initialize() {
    prev = nullptr;
    next = nullptr;
}

void CMapTreasureBox::Initialize() {
    CCharacter2::Initialize();
    active = 0;
    flag_no = 0;
    item_no = -1;
    item_num = 0;
    floor_id = -1;
    func_point = nullptr;
    parts = nullptr;
}

int CMapTreasureBox::AssignFuncPoint(CFuncPoint *point, CMapParts *owner) {
    if (point == nullptr) {
        return 0;
    }

    active = 1;
    flag_no = point->flag_no;
    item_no = point->event.arg1;
    item_num = point->event.arg2;

    if (item_num == 0) {
        item_num = 1;
    }

    floor_id = point->event.arg3;
    func_point = point;
    parts = owner;

    if (parts != nullptr && GetFrame() != nullptr) {
        GetFrame()->SetReference(&parts->frame);
    }

    SetPosition(point->position);
    SetRotation(point->rotation);
    UpdatePosition();
    return 1;
}

void CMapTreasureBox::GetWorldPosition(float *out_position) {
    mgZeroVectorW(out_position);

    if (GetFrame() != nullptr) {
        GetFrame()->GetWorldPosition0(out_position);
    }
}

void CCharacter2::SetPosition(float x, float y, float z) {
    float new_position[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    new_position[0] = x;
    new_position[1] = y;
    new_position[2] = z;

    SetPosition(new_position);
}

int CMapPiece::DrawDirect() {
    return DrawSub(1);
}

int CMapPiece::Draw() {
    return DrawSub(0);
}
