#include "common.h"

#include <cstring>

#include "character.hpp"
#include "collision.hpp"
#include "funcpoint.hpp"
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

// Code (.text)
void CMapParts::Initialize() {
    int i;

    piece_list = NULL;
    name[0] = 0;
    parts_name[0] = 0;
    frame.Initialize();
    in_screen = 1;
    lod_num = 0;
    minimap_tile = 0;
    lod_dist = NULL;
    lod_blend = 0;
    color_num = 4;
    func_point_mngr.Initialize();
    func_check.time = 0;
    no_plight = 0;
    no_light = 0;
    group_no = -1;
    move_flag = 0;
    anime_list = NULL;
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
    if (new_name == NULL || (u32) strlen(new_name) > 0x1F) {
        return;
    }

    strcpy(name, new_name);
}

void CMapParts::SetPartsName(char *new_name) {
    if (new_name == NULL || (u32) strlen(new_name) > 0x1F) {
        return;
    }

    strcpy(parts_name, new_name);
}

void CMapParts::AddPiece(CList<CMapPiece> *node) {
    if (node == NULL) {
        return;
    }

    if (node->data.type & 4) {
        need_step = 1;
    }

    CList<CMapPiece> *last = piece_list;

    if (last == NULL) {
        piece_list = node;
        return;
    }

    CList<CMapPiece> *next;

    if (last != NULL) {
        do {
            next = last->next;

            if (next == NULL) {
                break;
            }

            last = next;
        } while (next);
    }

    last->next = node;

    if (node != NULL) {
        node->prev = last;
    }
}

CMapPiece *CMapParts::SearchPiece(char *piece_name) {
    CList<CMapPiece> *node;
    CMapPiece        *piece;

    if (piece_list == NULL || piece_name == NULL) {
        return NULL;
    }

    for (node = piece_list; node != NULL; node = node->next) {
        piece = node->pGetData();

        if (strcmp(piece_name, piece->name) == 0) {
            return piece;
        }
    }

    return NULL;
}

CMapPiece *CMapParts::SearchPieceColType(int col_type) {
    CList<CMapPiece> *node;
    CMapPiece        *piece;

    if (piece_list == NULL || name == NULL) {
        return NULL;
    }

    for (node = piece_list; node != NULL; node = node->next) {
        piece = node->pGetData();

        if (piece->col_type == col_type) {
            return piece;
        }
    }

    return NULL;
}

int CMapParts::GetPoly(int kind, CCPoly *poly, mgVu0FBOX &box, int max) {
    CList<CMapPiece> *node;
    int               total;
    CMapPiece        *piece;
    mgCFrame         *piece_frame;
    int               found;

    if (this->GetShow() == 0) {
        return 0;
    }

    node = piece_list;
    this->UpDatePosition();
    total = 0;

    if (node != NULL) {
        do {
            piece = &node->data;

            if (piece != NULL) {
                piece_frame = piece->frame;

                if (piece_frame != NULL) {
                    if (piece_frame->parent == 0) {
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
        } while (node != NULL);
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

    *(u_long128 *) color[no] = *(u_long128 *) rgba;
    color[no][3] = 1.0f;
    return 1;
}

int CMapParts::GetColor(int no, float *out_rgba) {
    if (no < 0 || no >= color_num) {
        return 0;
    }

    *(u_long128 *) out_rgba = *(u_long128 *) color[no];
    return 1;
}

int CMapParts::GetDefColor(int id, float *out_color) {
    CList<CMapPiece> *node;
    int               i;
    CMapPiece        *piece;
    int               material_count;
    PieceMaterial    *material;

    if (id < 0 || id >= color_num) {
        return 0;
    }

    for (node = piece_list; node != NULL; node = node->next) {
        piece = &node->data;
        material_count = piece->material_num;

        for (i = 0; i < material_count; i++) {
            material = piece->GetMaterial(i);

            if (material != NULL && material->material != 0 && id == material->unk_c) {
                sceVu0CopyVector(out_color, material->color);
                return 1;
            }
        }
    }

    return 0;
}

void CMapParts::UpdateColor() {
    int               id;
    CList<CMapPiece> *node;
    int               j;
    CMapPiece        *piece;
    int               material_count;
    PieceMaterial    *material;

    for (id = 0; id < color_num; id++) {
        node = piece_list;

        if (color[id][3] > 0.0f) {
            for (; node != NULL; node = node->next) {
                piece = &node->data;
                material_count = piece->material_num;

                for (j = 0; j < material_count; j++) {
                    material = piece->GetMaterial(j);

                    if (material != NULL && material->material != 0 && id == material->unk_c) {
                        sceVu0CopyVectorXYZ(material->color, color[id]);
                    }
                }
            }
        }
    }
}

int CMapParts::PreDraw() {
    float alpha;

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
    int               light_no;
    int               plight_no;
    int               pass;
    int               draw_num;
    CFuncPoint       *point;
    CList<CMapPiece> *node;
    CMapPiece        *piece;
    float             weight;
    float             ambient_alpha;
    int               lighting_set;
    int               old_lighting;
    int               plight_enable;
    mgCFrame         *piece_frame;

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

        if ((point = func_point_mngr.Get()) != NULL) {
            do {
                if (!point->active) {
                    goto next_light;
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

            next_light:;
            } while ((point = func_point_mngr.Get()) != NULL);
        }
    }

    draw_num = 0;

    for (pass = 0; pass < 1; pass++) {
        node = piece_list;

        if (node != NULL) {
            do {
                piece = &node->data;

                if (CheckTime(func_check.time, piece->time_start, piece->time_end)) {
                    piece->draw_off &= ~1;
                } else {
                    piece->draw_off |= 1;
                }

                piece_frame = piece->frame;

                if (piece_frame != NULL && piece_frame->parent == NULL) {
                    piece_frame->SetReference(&frame);

                    if (direct == 0) {
                        draw_num += piece->Draw();
                    } else {
                        draw_num += piece->DrawDirect();
                    }

                    piece_frame->DeleteReference();
                }

                node = node->next;
            } while (node != NULL);
        }
    }

    if (lighting_set) {
        mgActiveLighting(old_lighting, 0);
    }

    mgPlightEnable(plight_enable);
    return draw_num;
}

void CMapParts::DrawStep() {
    CList<CMapPiece> *node;
    CMapPiece        *piece;

    UpDatePosition();
    CObject::DrawStep();

    for (node = piece_list; node != NULL; node = node->next) {
        piece = node->pGetData();
        piece->UpDatePosition();
        piece->DrawStep();
    }
}

int CMapParts::CreateBoundBox() {
    mgVu0FBOX         box;
    CList<CMapPiece> *node;
    CMapPiece        *piece;
    int               found;
    int               col_found;
    int               first;
    int               col_first;

    found = 0;
    first = 1;
    col_found = 0;
    col_first = first;

    for (node = piece_list; node != NULL; node = node->next) {
        piece = node->pGetData();

        if (piece == NULL || piece->frame == NULL || !piece->GetBoundBox(&box)) {
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
    mgVu0FBOX     world_box;

    if (!col_bound_valid) {
        return 0;
    }

    GetLWMatrix(lw_matrix);
    *(u_long128 *) sphere = *(u_long128 *) col_bound_sphere;
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
    int has_box;

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
    float         radius;

    if (bound_valid == 0) {
        return 0;
    }

    GetLWMatrix(matrix);
    *(PartsVector *) sphere_center = *(PartsVector *) bound_sphere;
    radius = bound_sphere[3];
    sphere_center[3] = 1.0f;
    sceVu0ApplyMatrix(sphere, matrix, sphere_center);
    sphere[3] = radius;
    return bound_valid;
}

void CMapParts::GetLWMatrix(sceVu0FMATRIX out_matrix) {
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
    SphereVec     sphere;
    float         radius;
    int           i;

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
    *(PartsVector *) &sphere = *(PartsVector *) bound_sphere;
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
    CFuncPoint   *point;
    CFuncPoint   *nearest;
    float         nearest_dist;
    float         range;
    float         facing_cos;
    float         dist;
    float         nearest_aux;

    if (func_point_mngr.UpdateFlag(FUNC_POINT_INVENT, &func_check) <= 0) {
        return NULL;
    }

    func_point_mngr.GetStart(FUNC_POINT_INVENT);
    nearest_aux = 0.0f;
    mgCFrame *parts_frame = &frame;
    nearest = NULL;
    nearest_dist = nearest_aux;

    if ((point = func_point_mngr.Get()) != NULL) {
        do {
            if (!point->Check(NULL)) {
                goto next_point;
            }

            point->frame.SetReference(parts_frame);
            point->frame.GetLWMatrix(point_matrix);

            range = point->invent.range;

            if (range == 0.0f) {
                range = 400.0f;
            }

            mgGetDirFromCamera(to_point, point_matrix[3]);

            if (!(point->invent.angle <= 0.0f)) {
                sceVu0ScaleVector(facing, point_matrix[2], -1.0f);
                sceVu0Normalize(facing, facing);
                sceVu0Normalize(to_point, to_point);
                facing_cos = sceVu0InnerProduct(to_point, facing);

                if (facing_cos < cosf(point->invent.angle)) {
                    goto release_point;
                }
            }

            {
                mgGetCameraPos(camera_pos);
                mgGetCameraPose(camera_pose);
                sceVu0Normalize(ray_far, camera_pose[2]);
                *(u_long128 *) ray_near = *(u_long128 *) ray_far;
                sceVu0ScaleVector(ray_far, ray_far, range);
                sceVu0ScaleVector(ray_near, ray_near, 1.0f);
                sceVu0AddVector(ray_start, camera_pos, ray_near);
                sceVu0AddVector(ray_end, camera_pos, ray_far);

                if (IntersectionBox(ray_start, ray_end, &point->invent.box, point_matrix, hit) > 0) {
                    dist = mgDistVector(hit[0], camera_pos);

                    if (dist <= 10.0f + info->range) {
                        if (nearest == NULL || dist < nearest_dist) {
                            nearest = point;
                            nearest_aux = 0.0f;
                            nearest_dist = dist;
                        }
                    }
                }
            }

        release_point:
            point->frame.DeleteReference();
        next_point:;
        } while ((point = func_point_mngr.Get()) != NULL);
    }

    func_point_mngr.GetEnd();
    info->unk_04 = nearest_aux;
    info->dist = nearest_dist;
    return nearest;
}

#pragma global_optimizer off

void CMapParts::DrawScreenFunc(mgCFrame *marker) {
    float       point_matrix[4][4];
    float       box_matrix[4][4];
    float       marker_matrix[4][4];
    float       extent[4];
    float       origin[4];
    CFuncPoint *point;
    float       range;

    if (func_point_mngr.UpdateFlag(FUNC_POINT_INVENT, &func_check) <= 0) {
        return;
    }

    func_point_mngr.GetStart(FUNC_POINT_INVENT);

    mgCFrame *parts_frame = &frame;

    if ((point = func_point_mngr.Get()) != NULL) {
        do {
            if (!point->Check(NULL)) {
                goto next_point;
            }

            point->frame.SetReference(parts_frame);
            point->frame.GetLWMatrix(point_matrix);

            if (marker != NULL) {
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
                    goto next_point;
                }

                mgMulMatrix(marker_matrix, point_matrix, box_matrix);
                marker->SetTransMatrix(marker_matrix);
                mgDrawDirect(marker);
            }

            point->frame.DeleteReference();
        next_point:;
        } while ((point = func_point_mngr.Get()) != NULL);
    }

    func_point_mngr.GetEnd();
}

#pragma global_optimizer reset

void CMapParts::Step() {
    CList<CMapPiece> *node;
    CMapPiece        *piece;
    mgCFrame         *piece_frame;

    if (need_step == 0) {
        return;
    }

    node = piece_list;

    if (node != NULL) {
        do {
            piece = &node->data;
            piece_frame = piece->frame;

            if (piece_frame != NULL) {
                piece_frame->SetReference(&frame);
                piece->Step();
                piece_frame->DeleteReference();
            }

            node = node->next;
        } while (node != NULL);
    }
}

void CMapParts::AnimeStep(CFuncPointCheck *check, CObjAnimeEnv *env) {
    CList<CObjAnime> *node;
    CObjAnime        *anime;

    for (node = anime_list; node != NULL; node = node->next) {
        anime = node->pGetData();

        if (anime->func_point != NULL && anime->func_point->Check(check)) {
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

void CMapParts::Copy(CMapParts &dest, mgCMemory *memory) {
    if (memory != NULL) {
        dest = *this;

        CList<CMapPiece> *copies = NULL;
        CList<CMapPiece> *source = piece_list;

        while (source != NULL) {
            if (source->data.col_type == 0) {
                CList<CMapPiece> *copy = new (memory->Alloc((sizeof(CList<CMapPiece>) + 15) / 16 + 2)) CList<CMapPiece>;
                if (copy == NULL) {
                    return;
                }
                source->data.Copy(copy->data, memory);

                CList<CMapPiece> *last = copies;
                if (last != NULL) {
                    CList<CMapPiece> *next;
                    if (last != NULL) {
                        do {
                            next = last->next;
                            if (next == NULL) {
                                break;
                            }
                            last = next;
                        } while (next);
                    }
                    last->next = copy;
                    if (copy != NULL) {
                        copy->prev = last;
                    }
                } else {
                    copies = copy;
                }
            }
            source = source->next;
        }
        dest.piece_list = copies;
        func_point_mngr.Copy(dest.func_point_mngr, memory);
        dest.AssignFuncAnime(memory);
    } else {
        dest = *this;
    }
}

int CMapParts::AssignFuncAnime(mgCMemory *memory) {
    CFuncPoint *point;
    CList<CObjAnime> *node;

    func_point_mngr.GetStart(FUNC_POINT_ANIME);
    while ((point = func_point_mngr.Get()) != NULL) {
        node = new (memory->Alloc((sizeof(CList<CObjAnime>) + 15) / 16 + 2)) CList<CObjAnime>;
        if (node == NULL) {
            return 0;
        }
        node->Initialize();

        CList<CObjAnime> *last = anime_list;
        if (last == NULL) {
            anime_list = node;
        } else {
            CList<CObjAnime> *next;
            if (last != NULL) {
                do {
                    next = last->next;
                    if (next == NULL) {
                        break;
                    }
                    last = next;
                } while (next);
            }
            last->next = node;
            if (node != NULL) {
                node->prev = last;
            }
        }
        node->pGetData()->AssignFuncAnime(point, this);
    }
    return 1;
}

template <>
void CList<CObjAnime>::Initialize() {
    prev = NULL;
    next = NULL;
}

void CMapTreasureBox::Initialize() {
    CCharacter2::Initialize();
    active = 0;
    flag_no = 0;
    item_no = -1;
    item_num = 0;
    floor_id = -1;
    func_point = NULL;
    parts = NULL;
}

int CMapTreasureBox::AssignFuncPoint(CFuncPoint *point, CMapParts *owner) {
    if (point == NULL) {
        return 0;
    }

    active = 1;
    flag_no = point->unk_c;
    item_no = point->event.arg1;
    item_num = point->event.arg2;

    if (item_num == 0) {
        item_num = 1;
    }

    floor_id = point->event.arg3;
    func_point = point;
    parts = owner;

    if (parts != NULL && GetFrame() != NULL) {
        GetFrame()->SetReference(&parts->frame);
    }

    SetPosition(point->position);
    SetRotation(point->rotation);
    UpdatePosition();
    return 1;
}

void CMapTreasureBox::GetWorldPosition(float *out_position) {
    mgZeroVectorW(out_position);

    if (GetFrame() != NULL) {
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
