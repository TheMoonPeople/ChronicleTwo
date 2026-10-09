#include "common.h"
#include "mw_runtime.h"

#include <libvu0.h>

#include <cstdio>
#include <cstring>

#include "editdata.hpp"
#include "editmap.hpp"
#include "editmap2.hpp"
#include "editriver.hpp"
#include "mainloop.hpp"
#include "mdslist.hpp"
#include "menusystemdata.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "savedata.hpp"
#include "snd_mngr.hpp"

static const float kFenceChainDistance = 5.0f;
static const int   kBalanceLimit = 4;
static const u32   kFuncPointHasSound = 0x80;
static const int   kPartsTypeRiver = 0xB;
static const int   kNpcLiveLength = 7;
static const int   kChildIdMax = 0x200;

// Code (.text)
/**
 *
 * Calculates a normal for a triangle projected onto the horizontal plane.
 *
 */
static void PlaneNormalXZ(float *normal, float *p0, float *p1, float *p2) {
    asm {
        lqc2 vf15, 0(p0)
        vsub.xyzw vf10, vf10, vf10
        lqc2 vf16, 0(p1)
        vsub.xyzw vf11, vf11, vf11
        lqc2 vf17, 0(p2)
        vsub.xz vf10, vf16, vf15
        vsub.xz vf11, vf17, vf15
        vopmula.xyz ACC, vf10, vf11
        vopmsub.xyz vf12, vf11, vf10
        sqc2 vf12, 0(normal)
    }
}
float CEditMap::GetEditPartsAlt(CEditPartsInfo *info, sceVu0FVECTOR pos, float rot_y, CEditParts **parts, int num) {
    sceVu0FMATRIX   parts_matrix;
    sceVu0FMATRIX   invers_matrix;
    sceVu0FMATRIX   matrix;
    sceVu0FVECTOR   parts_pos;
    sceVu0FVECTOR   offset;
    sceVu0FVECTOR   parts_rot;
    sceVu0FVECTOR   triangle[3];
    mgVu0FBOX       box;
    sceVu0FVECTOR   normal;
    CEditPartsInfo *parts_info;
    int             i;
    float           area;
    CCPoly         *poly;
    int             j;
    CEditParts     *edit_parts;
    float           alt;
    int             poly_count;

    if (info == NULL) {
        return pos[1];
    }
    GetMatrix(matrix, pos, ConvEditAngle(rot_y));
    alt = pos[1];
    for (i = 0; i < num; i++) {
        edit_parts = parts[i];
        int empty = edit_parts->name[0] == 0;
        if (empty) {
            continue;
        }
        parts_info = edit_parts->info;
        if (parts_info == NULL) {
            continue;
        }
        edit_parts->GetPosition(parts_pos);
        edit_parts->GetRotation(parts_rot);
        GetMatrix(parts_matrix, parts_pos, ConvEditAngle(parts_rot[1]));
        GetInversMatrix(invers_matrix, parts_matrix);
        sceVu0SubVector(offset, pos, parts_pos);
        mgAngleLimit(rot_y - parts_rot[1]);
        poly_count = info->col_area1.poly_count;
        poly = info->col_area1.poly;
        for (j = 0; j < poly_count; j++, poly++) {
            mgApplyMatrixN(triangle, matrix, poly->vertex, 3);
            mgApplyMatrixN(triangle, invers_matrix, triangle, 3);
            PlaneNormalXZ(normal, triangle[0], triangle[1], triangle[2]);
            if (parts_info->col_floor.OverlapPoly3XZ(triangle, &area, &box) == 0) {
                continue;
            }
            float overlap = (area < 0.0f) ? -area : area;
            if (overlap <= 0.01f) {
                continue;
            }
            float top = box.max[1] + parts_matrix[3][1];
            if (top <= alt) {
                continue;
            }
            alt = top;
        }
    }
    return GetEditAlt(alt);
}
int CEditMap::CheckEditParts(CEditPartsInfo *info, float *pos, float rot_y, EP_PLACE_INFO *place, CEditParts **parts, int num) {
    sceVu0FMATRIX parts_matrix;
    sceVu0FMATRIX invers_matrix;
    sceVu0FMATRIX matrix;

    if (info == NULL) {
        return 0;
    }

    place->num = 0;
    place->unk_44 = 0;
    GetMatrix(matrix, pos, ConvEditAngle(rot_y));
    mgVu0FBOX     box = info->col_area3.bbox;
    mgVu0FBOX     overlap_box;
    sceVu0FVECTOR parts_pos;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR parts_rot;
    mgBoxMaxMin(&box, &info->col_area5.bbox);
    float total_area = 0.0f;
    float area = info->col_area1.AreaXZ();
    info->col_area5.AreaXZ();
    static int cnt = 0;
    cnt++;
    cnt %= 10;

    for (int i = 0; i < num; i++) {
        CEditParts *edit_parts = parts[i];
        int         empty = edit_parts->name[0] == 0;

        if (empty) {
            continue;
        }

        CEditPartsInfo *parts_info = edit_parts->info;

        if (parts_info != NULL) {
            edit_parts->GetPosition(parts_pos);
            edit_parts->GetRotation(parts_rot);
            GetMatrix(parts_matrix, parts_pos, ConvEditAngle(parts_rot[1]));
            GetInversMatrix(invers_matrix, parts_matrix);
            sceVu0SubVector(offset, pos, parts_pos);
            mgAngleLimit(rot_y - parts_rot[1]);
            mgVu0FBOX     parts_box = parts_info->col_area3.bbox;
            sceVu0FMATRIX local_matrix;
            mgMulMatrix(local_matrix, invers_matrix, matrix);

            if (box.max[1] != 0.0f && !(box.max[1] + offset[1] <= parts_box.min[1]) && box.min[1] + offset[1] < parts_box.max[1]) {
                float overlap = parts_info->col_area3.OverlapXZ(info->col_area3, local_matrix, NULL);
                float smaller_area = parts_info->col_area3.AreaXZ();
                smaller_area = smaller_area < area ? smaller_area : area;

                if (!(smaller_area <= 0.01f)) {
                    float ratio = overlap / smaller_area;
                    ratio = ratio < 0.0f ? -ratio : ratio;

                    if (!(ratio <= 0.01f)) {
                        if (parts_info->id == 0x46 || parts_info->id == 0x47 || parts_info->id == 0x48) {
                            place->unk_44 = 1;
                        }

                        return 0;
                    }
                }
            }

            float floor_top = parts_matrix[3][1] + parts_info->col_floor.bbox.max[1];
            float floor_bottom = parts_matrix[3][1] + parts_info->col_floor.bbox.min[1];

            if (pos[1] <= floor_top && !(pos[1] < floor_bottom)) {
                float overlap = parts_info->col_floor.OverlapXZ(info->col_area1, local_matrix, &overlap_box);

                if (!(overlap < 0.01f) && place->num < 16) {
                    int base = ConvertParts(edit_parts);
                    total_area += overlap;
                    place->base[place->num++] = base;
                }
            }
        }
    }

    if (!CheckEditPartsOnRiver(info, pos, rot_y)) {
        return 0;
    }

    if (info->attr & 0x10000) {
        for (int i = 0; i < place->num; i++) {
            CEditParts *base = GetePlaceParts(place->base[i]);

            if (base != NULL && base->info != NULL && !(base->info->attr & 0x20000)) {
                return 0;
            }
        }
    }

    if (area_no == 2) {
        if (!(info->attr & 0x2000)) {
            for (int i = 0; i < place->num; i++) {
                if (place->base[i] == 0) {
                    return 0;
                }
            }
        }

        if (info->id == 0x35 || info->id == 0x4E) {
            for (int i = 0; i < place->num; i++) {
                if (place->base[i] != 0) {
                    return 0;
                }
            }
        }
    }

    if (area <= 0.0f) {
        return 1;
    }

    float covered_area = total_area / area;
    float required_area = info->place_eps;

    if (required_area <= 0.00001f) {
        required_area = 0.98f;
    }

    if (covered_area < required_area) {
        return 0;
    }

    return CmpEditAlt(overlap_box.max[1] - overlap_box.min[1], info->bury_depth) >= 0;
}

int CEditMap::CheckEditPartsOnRiver(CEditPartsInfo *info, float *pos, float rot_y) {
    sceVu0FMATRIX matrix;
    int           x;

    GetMatrix(matrix, pos, ConvEditAngle(rot_y));
    mgVu0FBOX     box = info->col_area3.bbox;
    float         area = info->col_area5.AreaXZ();
    mgVu0FBOX     world_box;
    float         corner[EDIT_GRID_CORNER_MAX][4];
    sceVu0FMATRIX piece_matrix;
    sceVu0FMATRIX invers_matrix;
    sceVu0FMATRIX local_matrix;
    int           max_pos[2];
    int           min_pos[2];
    mgApplyMatrix(world_box.max, world_box.min, matrix, box.max, box.min);
    float river_area = 0.0f;

    for (int i = 0; i < grid_max; i++) {
        if (grid[i] == NULL) {
            continue;
        }

        grid[i]->GetLPos(min_pos, world_box.min[0], world_box.min[2]);
        grid[i]->GetLPos(max_pos, world_box.max[0], world_box.max[2]);

        for (x = min_pos[0]; x <= max_pos[0]; x++) {
            for (int z = min_pos[1]; z <= max_pos[1]; z++) {
                CGridData *cell = grid[i]->Get(x, z);

                if (cell == NULL) {
                    continue;
                }

                if (grid[i]->River(x, z) == 0) {
                    continue;
                }

                grid[i]->GetRiverPos(x, z, corner);

                for (int c = 0; c < EDIT_GRID_CORNER_MAX; c++) {
                    sceVu0CopyMatrix(piece_matrix, grid[i]->rot[cell->rot[c]]);
                    *(u_long128 *) piece_matrix[3] = *(u_long128 *) corner[c];
                    mgInversMatrix(invers_matrix, piece_matrix);
                    mgMulMatrix(local_matrix, invers_matrix, matrix);
                    river_area += river_info[cell->piece[c]].col_floor.OverlapXZ(info->col_area5, local_matrix, NULL);

                    if (river_info[cell->piece[c]].col_floor.OverlapXZ(info->col_area1, local_matrix, NULL) > 0.01f) {
                        return 0;
                    }
                }
            }
        }
    }

    float rest = area - river_area;
    rest = (rest < 0.0f) ? -rest : rest;

    if (rest > 0.01f) {
        return 0;
    }

    return 1;
}

int CEditMap::CheckRiverParts(float *pos) {
    int        lpos[2];
    CEditGrid *river = NULL;

    for (int i = 0; i < grid_max; i++) {
        river = grid[i];

        if (river == NULL) {
            continue;
        }

        if (river->GetLPos(lpos, pos[0], pos[2]) == 0) {
            continue;
        }

        if (river->River(lpos[0], lpos[1]) != 0) {
            return 0;
        }

        break;
    }

    if (river == NULL) {
        return 0;
    }

    int x = lpos[0];
    int z = lpos[1];
    river->SetRiver(x, z);
    CGridData *cell = river->Get(x, z);

    if (cell == NULL) {
        return 0;
    }

    river->ResetRiver(x, z);
    CGridData     cell_copy = *cell;
    float         corner[EDIT_GRID_CORNER_MAX][4];
    sceVu0FMATRIX piece_matrix[EDIT_GRID_CORNER_MAX];
    sceVu0FMATRIX parts_matrix;
    sceVu0FMATRIX invers_matrix;
    mgVu0FBOX     box;
    CEditParts   *near_parts[0x100];
    sceVu0FVECTOR parts_pos;
    sceVu0FVECTOR parts_rot;
    sceVu0FMATRIX local_matrix;
    river->GetRiverPos(x, z, corner);

    for (int c = 0; c < EDIT_GRID_CORNER_MAX; c++) {
        *(u_long128 *) piece_matrix[c][0] = *(u_long128 *) river->rot[cell_copy.rot[c]][0];
        *(u_long128 *) piece_matrix[c][1] = *(u_long128 *) river->rot[cell_copy.rot[c]][1];
        *(u_long128 *) piece_matrix[c][2] = *(u_long128 *) river->rot[cell_copy.rot[c]][2];
        *(u_long128 *) piece_matrix[c][3] = *(u_long128 *) river->rot[cell_copy.rot[c]][3];
        *(u_long128 *) piece_matrix[c][3] = *(u_long128 *) corner[c];
    }

    river->GetGridBox(&box, pos);
    int near_num = GetNearParts(box, near_parts, 0x100);

    for (int i = 0; i < near_num; i++) {
        CEditParts     *parts = near_parts[i];
        CEditPartsInfo *parts_info = parts->info;

        if (parts_info == NULL) {
            continue;
        }

        parts->GetPosition(parts_pos);
        parts->GetRotation(parts_rot);
        GetMatrix(parts_matrix, parts_pos, ConvEditAngle(parts_rot[1]));
        GetInversMatrix(invers_matrix, parts_matrix);

        for (int c = 0; c < EDIT_GRID_CORNER_MAX; c++) {
            mgMulMatrix(local_matrix, invers_matrix, piece_matrix[c]);

            if (parts_info->col_area1.OverlapXZ(river_info[cell_copy.piece[c]].col_floor, local_matrix, NULL) > 0.01f) {
                return 0;
            }
        }
    }

    return 1;
}

int CEditMap::CheckNormalPlaceParts(int place_no) {
    CEditParts *edit_parts = GetePlaceParts(place_no);
    return CheckNormalPlaceParts(edit_parts);
}

int CEditMap::CheckNormalPlaceParts(CEditParts *edit_parts) {
    if (edit_parts == NULL) {
        return 0;
    }

    if ((edit_parts->name[0] == 0) != 0 || edit_parts->state != 1) {
        return 0;
    }

    return 1;
}

int CEditMap::CheckLiveNPC(int npc_id, int id) {
    CEditParts *part;
    int         count;
    int         i;

    i = 0;
    part = edit_parts;
    count = 0;

    while (i < edit_parts_max) {
        if (CheckNormalPlaceParts(part) != 0 && part->house != NULL) {
            if (id < 0 && npc_id < 0) {
                if (part->house->npc_no[0] > 0) {
                    count++;
                }
            } else if (id <= 0 || part->info->id == id) {
                if (npc_id < 0) {
                    if (part->house->npc_no[0] > 0) {
                        return 1;
                    }
                } else if (part->house->npc_no[0] == npc_id) {
                    return 1;
                }
            }
        }

        i++;
        part++;
    }

    return count;
}

int CEditMap::GetePlacePartsAtInfoID(int id, int *out, int max) {
    int             found = 0;
    int             limit = max;
    CEditPartsInfo *info;
    CEditParts     *part;
    int             i;

    info = GetePartsInfoAtID(id);

    if (info == NULL) {
        return 0;
    }

    if (info->GetPartsType() == kPartsTypeRiver) {
        sceVu0FVECTOR position = {0.0f, 0.0f, 0.0f, -1.0f};
        int river_count = GetRiverNum(position);
        limit = river_count < limit ? river_count : limit;

        for (i = 0; i < limit; i++) {
            out[i] = 0;
        }

        return river_count;
    }

    part = edit_parts;

    for (i = 0; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) != 0 && part->info->id == id) {
            if (out != NULL) {
                out[found] = i;
                found++;

                if (found >= limit) {
                    break;
                }
            } else {
                found++;
            }
        }
    }

    return found;
}

int CEditMap::GetTerritoryParts(int id, int *out, int max) {
    CEditParts *place;
    int         n;
    CEditParts *p;
    int         i;

    if (out == NULL || max <= 0) {
        return 0;
    }

    place = GetePlaceParts(id);

    if (place == NULL) {
        return 0;
    }

    if (CheckNormalPlaceParts(id) == 0) {
        return 0;
    }

    p = edit_parts;
    n = 0;

    for (i = 0; i < edit_parts_max; i++, p++) {
        if (CheckNormalPlaceParts(p) != 0 && place->CheckTerritory(p) != 0) {
            n++;
            *out++ = i;

            if (n >= max) {
                break;
            }
        }
    }

    return n;
}

int CEditMap::GetChildParts(int parent, int *out, int max) {
    int           found;
    EditPlaceLog *child;
    int           i;
    s16           id;

    if (GetePlaceParts(parent) == NULL) {
        return 0;
    }

    child = place_log;
    found = 0;

    for (i = 0; i < place_log_max; i++, child++) {
        id = child->parts_no;

        if ((id < 0) != 0 || child->base_no != parent) {
            continue;
        }

        out[found] = id;
        found++;

        if (found >= max) {
            break;
        }
    }

    return found;
}

int CEditMap::RePaintNum(int count) {
    return count / 2;
}

int CEditMap::PaintFence(int index, float *color, int count) {
    CEditParts *fence;
    CEditParts *candidates[0x800];
    CEditParts *part;
    int         i;

    fence = GetePlaceParts(index);

    if (fence == NULL || fence->info == NULL) {
        return 0;
    } else {
        if (fence->IsFence() == 0) {
            return 0;
        }

        if (fence->info->paint_num <= 0) {
            return 0;
        }

        fence_list = candidates;
        *(u_long128 *) fence_color = *(u_long128 *) color;
        paint_num = count;
        part = edit_parts;
        fence_num = 0;

        for (i = 0; i < edit_parts_max; i++, part++) {
            if (CheckNormalPlaceParts(part) != 0 && part->IsFence() != 0 &&
                part->info->paint_num > 0 && part != fence) {
                candidates[fence_num] = part;
                fence_num++;
            }
        }

        candidates[fence_num] = NULL;
        return PaintFence(fence);
    }
}

/**
 *
 * Checks whether two fence parts meet closely enough to form a chain.
 *
 */
int CheckFenceChain(CEditParts *a, CEditParts *b) {
    float sphere_a[4];
    float sphere_b[4];
    float a_start[4];
    float b_start[4];
    float a_end[4];
    float b_end[4];

    if (a == NULL || b == NULL) {
        return 0;
    }

    if (a->GetBoundSphere(sphere_a) == 0) {
        return 0;
    }

    if (b->GetBoundSphere(sphere_b) == 0) {
        return 0;
    }

    if (!(mgDistVector(sphere_a, sphere_b) <= sphere_a[3] + sphere_b[3])) {
        return 0;
    }

    if (a->GetFenceSide(a_start, a_end) == 0) {
        return 0;
    }

    if (b->GetFenceSide(b_start, b_end) == 0) {
        return 0;
    }

    if (mgDistVector(a_start, b_end) < kFenceChainDistance) {
        return 1;
    }

    if (mgDistVector(b_start, a_end) < kFenceChainDistance) {
        return 1;
    }

    if (mgDistVector(a_start, b_start) < kFenceChainDistance) {
        return 1;
    }

    if (mgDistVector(a_end, b_end) < kFenceChainDistance) {
        return 1;
    }

    return 0;
}

int CEditMap::PaintFence(CEditParts *fence) {
    int painted = 0;
    int i;

    fence->SetColor(0, fence_color);
    fence->UpdateColor();
    painted++;
    paint_num--;

    for (i = 0; i < fence_num; i++) {
        fence_now = fence_list[i];

        if (fence_now != NULL && CheckFenceChain(fence, fence_now) != 0) {
            fence_list[i] = NULL;
            painted += PaintFence(fence_now);
        }
    }

    return painted;
}

void CEditMap::UpdateHouse() {
    int               index;
    CList<CMapPiece> *node;
    int               live_length;
    CMapPiece        *model;
    CEditParts       *part;
    char             *node_name;
    int               visible;
    float             fade;
    int               child_ids[kChildIdMax];
    int               child_num;
    int               i;
    CEditParts       *child;
    part = edit_parts;

    for (index = 0; index < edit_parts_max; index++, part++) {
        if (CheckNormalPlaceParts(part) != 0 && part->house != NULL) {
            fade = -1.0f;
            visible = 0;

            if (part->house->LiveChara() == 0) {
                visible = 1;
                fade = 12.0f;
            }

            part->fixed_time = fade;

            for (node = part->piece_list; node != NULL; node = node->next) {
                node_name = node->data.name;
                model = &node->data;
                char live_name[10] = "npclive";
                char suffix[10];
                live_length = kNpcLiveLength;

                if (LanguageCode > 0) {
                    live_length += sprintf(suffix, "%d", LanguageCode);
                    strcat(live_name, suffix);
                }

                if (node_name != NULL && strncmp(node_name, "npclive", kNpcLiveLength) == 0) {
                    model->Show(0);

                    if (strncmp(node_name, live_name, live_length) == 0) {
                        model->Show(visible);
                    }
                }
            }

            child_num = GetChildParts(index, child_ids, kChildIdMax);

            for (i = 0; i < child_num; i++) {
                child = GetePlaceParts(child_ids[i]);

                if (child != NULL) {
                    child->fixed_time = fade;
                }
            }
        }
    }
}

void CEditMap::GroundBalance(int animate) {
    if (area_no != 1) {
        return;
    }

    int weights[4] = {0, 0, 0, 0};
    balance_parts[0] = GetPlaceParts("p09_g0201");
    balance_parts[1] = GetPlaceParts("p09_g0201-1");
    balance_parts[2] = GetPlaceParts("p08_g0201");
    balance_parts[3] = GetPlaceParts("p08_g0201-1");

    if (balance_parts[0] == NULL || balance_parts[1] == NULL ||
        balance_parts[2] == NULL || balance_parts[3] == NULL) {
        return;
    }

    int         ground_index;
    CEditParts *part = edit_parts;

    for (int index = 0; index < edit_parts_max; ++index, ++part) {
        if (CheckNormalPlaceParts(part)) {
            CMapParts *ground = part->ground;

            if (ground == NULL) {
                continue;
            }

            for (ground_index = 0; ground_index < 4; ++ground_index) {
                if (ground == balance_parts[ground_index]) {
                    if (part->info != NULL) {
                        weights[ground_index] += part->info->weight;
                    }

                    break;
                }
            }
        }
    }

    int first_difference = weights[1] - weights[0];

    if (first_difference < 4 && first_difference > 0) {
        first_difference = 0;
    }

    if (first_difference > -4 && first_difference < 0) {
        first_difference = 0;
    }

    int second_difference = weights[3] - weights[2];

    if (second_difference < 4 && second_difference > 0) {
        second_difference = 0;
    }

    if (second_difference > -4 && second_difference < 0) {
        second_difference = 0;
    }

    if (first_difference > 30) {
        first_difference = 30;
    }

    if (first_difference < -30) {
        first_difference = -30;
    }

    if (second_difference > 30) {
        second_difference = 30;
    }

    if (second_difference < -30) {
        second_difference = -30;
    }

    if (balance_moved == 0) {
        for (int index = 0; index < 4; ++index) {
            balance_parts[index]->GetPosition(balance_base_pos[index]);
        }

        balance_moved = 1;
    }

    balance_parts[0]->GetPosition(balance_pos[0]);
    balance_pos[0][1] = 4.0f * first_difference;
    balance_parts[1]->GetPosition(balance_pos[1]);
    balance_pos[1][1] = 4.0f * -first_difference;
    balance_parts[2]->GetPosition(balance_pos[2]);
    balance_pos[2][1] = 4.0f * second_difference;
    balance_parts[3]->GetPosition(balance_pos[3]);
    balance_pos[3][1] = 4.0f * -second_difference;

    if (animate == 0) {
        balance_moved = 0;
    }

    for (int index = 0; index < 4; ++index) {
        balance_parts[index]->SetPosition(balance_pos[index]);
    }

    balance_weight[0] = weights[0];
    balance_weight[1] = weights[1];
    balance_weight[2] = weights[2];
    balance_weight[3] = weights[3];
}

int CEditMap::BalanceCheck() {
    float side_diff = (float) (balance_weight[0] - balance_weight[1]);

    if (side_diff < 0.0f) {
        side_diff = -side_diff;
    }

    int   side = fptosi(side_diff);
    float depth_diff = (float) (balance_weight[2] - balance_weight[3]);

    if (depth_diff < 0.0f) {
        depth_diff = -depth_diff;
    }

    int depth = fptosi(depth_diff);
    return side < kBalanceLimit && depth < kBalanceLimit;
}

CFuncPoint *CEditMap::InScreenFunc(InScreenFuncInfo *info) {
    CFuncPoint *result;
    CEditParts *part;
    float       best_near;
    float       best_distance;
    int         i;

    result = CMap::InScreenFunc(info);
    best_near = info->unk_04;
    part = edit_parts;
    best_distance = info->dist;

    for (i = 0; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) && part->CheckDraw()) {
            CFuncPoint *hit = part->InScreenFunc(info);

            if (hit != 0 && (result == 0 || info->dist < best_distance)) {
                result = hit;
                best_near = info->unk_04;
                best_distance = info->dist;
            }
        }
    }

    info->unk_04 = best_near;
    info->unk_04 = best_distance;
    return result;
}

void CEditMap::DrawScreenFunc(mgCFrame *frame) {
    CMap::DrawScreenFunc(frame);
    CEditParts *part = edit_parts;

    for (int i = 0; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) && part->CheckDraw()) {
            part->DrawScreenFunc(frame);
        }
    }
}

int CEditMap::GetSeSrcVolPan(int *se_no, float *vol, float *pan, int max) {
    CFuncPointCheck check;
    float           matrix[4][4];
    int             count;
    int             i;
    int             x;
    int             y;
    CEditParts     *part;
    int             added;

    check.time = 0.0f;
    CreateFuncCheck(&check);
    count = 0;
    mgUnitMatrix(matrix);
    added = CMap::GetSeSrcVolPan(se_no, vol, pan, max);
    max -= added;
    count += added;
    se_no += added;
    pan += added;
    i = 0;
    part = edit_parts;
    vol += added;

    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) && (*(u32 *) &part->func_point_mngr & kFuncPointHasSound)) {
            part->GetLWMatrix(matrix);

            if (max <= 0) {
                return count;
            }

            added = ::GetSeSrcVolPan(matrix, &part->func_point_mngr, &check, se_no, vol, pan, max);
            max -= added;
            count += added;
            se_no += added;
            vol += added;
            pan += added;
        }
    }

    if (max <= 0) {
        return count;
    }

    float      near_dist = 10.0f;
    float      far_dist = 2000.0f;
    float      max_vol = 0.0f;
    int        river_count = 0;
    float      pan_sum = 0.0f;
    CEditGrid *grid;

    for (i = 0; i < grid_max; i++) {

        grid = this->grid[i];

        if (grid != NULL) {
            for (x = 0; x < grid->num_x; x++) {
                for (y = 0; y < grid->num_z; y++) {
                    if (grid->River(x, y)) {
                        float pos[4];
                        float vol;
                        float pan;
                        grid->GetWPos(pos, x, y);
                        sndGetVolPan(&vol, &pan, pos, near_dist, far_dist);

                        if (!(vol <= 0.0f)) {
                            river_count++;

                            if (max_vol < vol) {
                                max_vol = vol;
                            }

                            pan_sum += pan * vol;
                        }
                    }
                }
            }
        }
    }

    if (river_count > 0) {
        count++;
        *se_no = 6;
        *vol = max_vol;
        *pan = pan_sum / (float) river_count;
    }

    return count;
}

// Small uninitialised data (.sbss)
INCLUDE_BSS(cnt_482, 0x4);
INCLUDE_BSS(init_483, 0x4);
