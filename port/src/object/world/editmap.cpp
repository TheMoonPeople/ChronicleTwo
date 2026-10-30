#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "editdata.hpp"
#include "editeff.hpp"
#include "editmap.hpp"
#include "editriver.hpp"
#include "funcpoint.hpp"
#include "log/game_output.hpp"
#include "mapload.hpp"
#include "mdslist.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"

/**
 *
 * Views an editor vector as four components or one quadword.
 *
 */
union EditVector {
    float     values[4]; /**< Vector components. */
    u_long128 quad;      /**< Quadword copy view. */
};

static EditVector at_1837__2 = {
    {0.0f, 1.0f, 0.0f, 0.0f}
};

const int kRiverPolyFlag = 0x10;
const int kMaxInfoId = 0x100;
const int kInfoFixedFlag = 0x1;
const int kInfoRiverRelatedFlag = 0x80000;

/**
 * Class name returned by the editor map object.
 */
static char *CEditMapName = "CEditMap";

/**
 * Editor map receiving script commands.
 */
static CEditMap *emapMap;

/**
 * Part-information manager receiving script commands.
 */
static CEditInfoMngr *emapInfo;

/**
 * Memory used by the editor map script.
 */
static mgCMemory *emapStack;

/**
 * Editor-map index state cleared before script interpretation.
 */
static int emapIdx;

/**
 * Editor-map information state cleared before script interpretation.
 */
static int emapNowInfo;

/**
 * Rectangle state cleared before editor-map script interpretation.
 */
static int emapRect;

/**
 * Rectangle count cleared before editor-map script interpretation.
 */
static int emapRectNum;

/**
 * Rectangle index cleared before editor-map script interpretation.
 */
static int emapRectIdx;

/**
 * Number of fixed-part placements in the script.
 */
static int emapFixNum;

/**
 * Number of initial-part placements in the script.
 */
static int emapInitNum;

/**
 * Next fixed-part placement to populate.
 */
static int emapFixIdx;

/**
 * Next initial-part placement to populate.
 */
static int emapInitIdx;

/**
 * Fixed-part placements populated by the script.
 */
static ePlaceData *emapFix;

/**
 * Initial-part placements populated by the script.
 */
static ePlaceData *emapInit;

char *CEditMap::Iam() {
    return CEditMapName;
}

void CEditMap::Initialize() {
    int i = {};
    int offset = {};
    area_no = -1;
    edit_parts_max = 0;
    edit_parts = nullptr;
    (&parts_heap)->Init();
    place_log_max = 0;
    place_log = nullptr;

    river_parts[0] = nullptr;
    river_piece[0] = nullptr;
    river_parts[1] = nullptr;
    river_piece[1] = nullptr;
    river_parts[2] = nullptr;
    river_piece[2] = nullptr;
    river_parts[3] = nullptr;
    river_piece[3] = nullptr;
    river_parts[4] = nullptr;
    river_piece[4] = nullptr;
    river_parts[5] = nullptr;
    river_piece[5] = nullptr;
    river_parts[6] = nullptr;
    river_piece[6] = nullptr;
    river_parts[7] = nullptr;
    river_piece[7] = nullptr;
    water_piece = nullptr;
    river_info = nullptr;
    mask_piece[0] = nullptr;
    river_poly_margin = 0;
    grid_max = 4;
    i = 0;
    offset = 0;

    for (; i < grid_max; i++) {
        this->grid[i] = nullptr;
        offset += 4;
    }

    ClearHouse();
    focus_parts = -1;
    frame = 0;
    balance_moved = 0;
    CMap::Initialize();
}

void CEditMap::ClearGrid() {
    int i = 0;

    for (; i < grid_max; i++) {
        CEditGrid *grid = this->grid[i];

        if (grid != nullptr) {
            grid->Clear();
        }
    }
}

void CEditMap::InitialPlaceParts(CEditData *data) {
    EP_PLACE_INFO   place_info{};
    float           rotation[4];
    int             i = {};
    ePlaceData     *placement = {};
    CEditPartsInfo *info = {};

    if (data->save_count != 0) {
        return;
    }

    i = 0;

    for (; i < info_mngr.init_parts_num; i++) {
        placement = &info_mngr.init_parts[i];
        info = GetePartsInfoAtID(placement->id);

        if (info != nullptr) {
            mgZeroVector(rotation);
            rotation[1] = GetEditAngle(placement->angle);

            if (CheckEditParts(info, placement->position, rotation[1], &place_info)) {
                int built = BuildEditParts(placement->id);

                if (built >= 0) {
                    PlaceEditParts(built, &place_info, placement->position, rotation, nullptr);
                }
            } else {
                dc2::log::PrintGame("init place err %d %s\n", i, info->edit_name);
            }
        }
    }
}

int CEditMap::GetPoly(int mode, CCPoly *polys, mgVu0FBOX &box, int max) {
    int         total = {};
    CEditParts *part = {};
    int         i = {};
    int         g = {};
    int         j = {};
    int         count = {};

    total = CMap::GetPoly(mode, polys, box, max);
    part = edit_parts;
    max -= total;
    polys += total;

    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = part->name[0] == 0;

        if (is_free) {
            continue;
        }

        if (part->state != EDIT_PARTS_STATE_PLACED) {
            continue;
        }

        count = part->GetPoly(mode, polys, box, max);

        for (j = 0; j < count; j++, polys++) {
            polys->parts_no = (static_cast<s16>(static_cast<u16>(i))) | CCPOLY_PARTS_EDIT;
        }

        max -= count;
        total += count;

        if (max <= 0) {
            return total;
        }
    }

    if (mode == 1) {
        for (g = 0; g < grid_max; g++) {
            if (grid[g] != nullptr) {
                count = grid[g]->GetRiverPoly(polys, box, max, river_poly_margin);

                for (j = 0; j < count; j++, polys++) {
                    polys->ignore_mask = kRiverPolyFlag;
                }

                polys += count;
                max -= count;
                total += count;

                if (max < 0) {
                    return total;
                }
            }
        }
    }

    return total;
}

CEditPartsInfo *CEditMap::GetePartsInfo(int index) {
    return info_mngr.GetePartsInfo(index);
}

CEditPartsInfo *CEditMap::GetePartsInfo(char *name) {
    return info_mngr.GetePartsInfo(name);
}

CEditPartsInfo *CEditMap::GetePartsInfoAtID(int id) {
    return info_mngr.GetePartsInfoAtID(id);
}

CEditPartsInfo *CEditMap::GetePartsInfoAtType(int type) {
    return info_mngr.GetePartsInfoAtType(type);
}

CEditPartsInfo *CEditMap::GetePartsInfoAtPlaceID(int index) {
    CEditParts *placed = {};

    placed = GetePlaceParts(index);

    if (placed != nullptr) {
        return placed->info;
    }

    return nullptr;
}

CEditParts *CEditMap::GetePlaceParts(int index) {
    if (index < 0) {
        return nullptr;
    }

    if (index < 0 || index >= edit_parts_max) {
        return nullptr;
    }

    return &edit_parts[index];
}

CEditParts *CEditMap::GetePlaceParts(char *name) {
    int         i = {};
    CEditParts *slot = {};
    i = 0;

    for (; i < edit_parts_max; i++) {
        slot = &edit_parts[i];
        int is_free = slot->name[0] == 0;

        if (!is_free) {
            if (slot->state != EDIT_PARTS_STATE_NONE) {
                if (slot->info != nullptr) {
                    CEditPartsInfo *info = slot->info;

                    if (info->parts_name != nullptr) {
                        if (strcmp(info->parts_name, name) == 0) {
                            return slot;
                        }
                    }
                }
            }
        }
    }

    return nullptr;
}

void CEditMap::GetRotMatrix(float (*matrix)[4], int step) {
    step = step % 24;
    mgUnitMatrix(matrix);

    if (step == 0) {
        return;
    }

    if (step == 6) {
        matrix[2][2] = 0.0f;
        matrix[0][0] = 0.0f;
        matrix[0][2] = -1.0f;
        matrix[2][0] = 1.0f;
    } else if (step == 12) {
        matrix[2][2] = -1.0f;
        matrix[0][0] = -1.0f;
    } else if (step == 18) {
        matrix[2][2] = 0.0f;
        matrix[0][0] = 0.0f;
        matrix[0][2] = 1.0f;
        matrix[2][0] = -1.0f;
    } else {
        sceVu0RotMatrixY(matrix, matrix, mgAngleLimit(GetEditAngle(step)));
    }
}

int CEditMap::GetEditAngle90(int step) {
    step = AngleLimit(step);
    return step / 6 * 6;
}

float CEditMap::GetEditAngle(int step) {
    step = step % 24;
    return mgAngleLimit(TWO_PI * static_cast<float>(step) / 24.0f);
}

int CEditMap::ConvEditAngle(float angle) {
    float steps = {};
    int   whole = {};

    if (angle < 0.0f) {
        angle += TWO_PI;
    }

    steps = angle / (PI / 12.0f);
    whole = fptosi(steps);

    if (!(steps - static_cast<float>(whole) <= 0.5f)) {
        whole++;
    }

    return AngleLimit(whole);
}

int CEditMap::AngleLimit(int angle) {
    angle = angle % EDIT_ANGLE_MAX;

    if (angle < 0) {
        angle += EDIT_ANGLE_MAX;
    }

    return angle;
}

void CEditMap::GetEditPos(float *out, float *pos) {
    if (!(pos[0] < 0.0f)) {
        out[0] = static_cast<float>(fptosi(0.01f + pos[0]));
    }

    if (pos[0] < 0.0f) {
        out[0] = static_cast<float>(fptosi(pos[0] - 0.01f));
    }

    if (!(pos[1] < 0.0f)) {
        out[1] = static_cast<float>(fptosi(0.01f + pos[1]));
    }

    if (pos[1] < 0.0f) {
        out[1] = static_cast<float>(fptosi(pos[1] - 0.01f));
    }

    if (!(pos[2] < 0.0f)) {
        out[2] = static_cast<float>(fptosi(0.01f + pos[2]));
    }

    if (pos[2] < 0.0f) {
        out[2] = static_cast<float>(fptosi(pos[2] - 0.01f));
    }

    out[3] = pos[3];
}

int CEditMap::CmpEditAlt(float alt, float base_alt) {
    float difference = alt - base_alt;

    if (!(difference <= 0.5f)) {
        return -1;
    }

    int result = 1;

    if (!(difference < -0.5f)) {
        result = 0;
    }

    return result;
}

float CEditMap::GetEditAlt(float altitude) {
    if (altitude > 0.0f) {
        return static_cast<float>(fptosi(0.5f + altitude));
    }

    return static_cast<float>(fptosi(altitude - 0.5f));
}

int CEditMap::GetGridPos(float *pos, float *river, float *out) {
    int        i = {};
    CEditGrid *grid = {};
    int        local[2];
    i = 0;

    for (; i < grid_max; i++) {
        grid = this->grid[i];

        if (grid != nullptr) {
            if (grid->GetLPos(local, pos[0], pos[2])) {
                grid->GetRiverPos(local[0], local[1], river);
                out[0] = grid->step_x;
                out[1] = 0.0f;
                out[2] = grid->step_z;
                return 1;
            }
        }
    }

    return 0;
}

void CEditMap::GetMatrix(float (*matrix)[4], float *pos, int step) {
    GetRotMatrix(matrix, step);
    *reinterpret_cast<u_long128 *>(matrix[3]) = *reinterpret_cast<u_long128 *>(pos);
    matrix[3][3] = 1.0f;
}

void CEditMap::GetInversMatrix(float (*a)[4], float (*b)[4]) {
    sceVu0InversMatrix(a, b);
}

int CEditMap::ConvertParts(CEditParts *part) {
    return part - edit_parts;
}

int CEditMap::GetSameParts(int index) {
    CEditParts *target = GetePlaceParts(index);
    void       *info = {};
    int         i = {};

    if (target == nullptr) {
        return -1;
    }

    info = target->info;

    if (info == nullptr) {
        return -1;
    }

    for (i = 0; i < edit_parts_max; i++) {
        int is_free = edit_parts[i].name[0] == 0;

        if (!is_free) {
            if (edit_parts[i].state == EDIT_PARTS_STATE_NONE) {
                if (edit_parts[i].info == info) {
                    return i;
                }
            }
        }
    }

    return -1;
}

int CEditMap::BuildEditParts(int id) {
    CEditPartsInfo *info = {};

    info = GetePartsInfoAtID(id);

    if (info != nullptr) {
        return BuildEditParts(info->edit_name);
    }

    return -1;
}

int CEditMap::GetTotalPolyn(int *vertex_total, int *texture_total) {
    int             poly_total = {};
    int             vertex_sum = {};
    int             texture_sum = {};
    CEditParts     *part = {};
    int             i = {};
    int             river_count = {};
    CEditPartsInfo *info = {};
    i = 0;
    texture_sum = 0;
    vertex_sum = 0;
    part = edit_parts;
    poly_total = 0;

    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part)) {
            info = part->info;

            if (info != nullptr) {
                poly_total += info->polyn[0];
                vertex_sum += info->polyn[1];
                texture_sum += info->polyn[2];
            }
        }
    }

    float river_pos[4] = {0.0f, 0.0f, 0.0f, -1.0f};
    river_count = GetRiverNum(river_pos);
    info = GetePartsInfoAtType(0xB);

    if (info != nullptr) {
        texture_sum += river_count * info->polyn[2];
        vertex_sum += river_count * info->polyn[1];
        poly_total += river_count * info->polyn[0];
    }

    if (vertex_total != nullptr) {
        *vertex_total = vertex_sum;
    }

    if (texture_total != nullptr) {
        *texture_total = texture_sum;
    }

    return poly_total;
}

int CEditMap::PlaceBurnParts() {
    CEditParts *part = edit_parts;
    int         i = 0;

    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) && part->IsBurn()) {
            return 1;
        }
    }

    return 0;
}

int CEditMap::BurnEditParts(RemoveInfo *remove_info) {
    float           remove_pos[4] = {10000000.0f, 10000000.0f, 1000000000.0f, 1.0f};
    float           pos[4];
    float           rotation[4];
    EP_PLACE_INFO   place{};
    int             placed_high = {};
    int             placed_low = {};
    CEditPartsInfo *high_info = {};
    CEditPartsInfo *low_info = {};
    CEditParts     *part = {};
    int             i = {};
    u32             flags = {};
    int             i2 = {};
    CEditPartsInfo *replacement = {};
    CEditPartsInfo *info = {};
    int             replacement_id = {};
    int            *placed_count = {};
    CEditParts     *part2 = {};
    high_info = info_mngr.GetePartsInfoAtID(0x57);
    low_info = info_mngr.GetePartsInfoAtID(0x56);

    if (high_info == nullptr || low_info == nullptr) {
        return 0;
    }

    placed_high = GetePlacePartsAtInfoID(0x57, nullptr, 0);
    placed_low = GetePlacePartsAtInfoID(0x56, nullptr, 0);
    part = edit_parts;
    i = 0;

    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) != 0 && part->info != nullptr &&
            (part->GetInfoID() == 0x57 || part->GetInfoID() == 0x56)) {
            RemoveEditParts(i, remove_pos, remove_info);
        }
    }

    part2 = edit_parts;
    i2 = 0;

    for (; i2 < edit_parts_max; i2++, part2++) {
        if (CheckNormalPlaceParts(part2) != 0) {
            info = part2->info;

            if (info != nullptr) {
                flags = info->attr;

                if (flags & 0x1000) {
                    part2->GetPosition(pos);
                    part2->GetRotation(rotation);
                    RemoveEditParts(i2, remove_pos, remove_info);

                    if (flags & 0x4000) {
                        replacement = low_info;
                        replacement_id = 0x56;
                        placed_count = &placed_low;

                        if (flags & 0x40) {
                            replacement_id = 0x57;
                            replacement = high_info;
                            placed_count = &placed_high;
                        }

                        if (*placed_count < replacement->max_num &&
                            CheckEditParts(replacement, pos, rotation[1],
                                           &place) != 0) {
                            PlaceEditParts(BuildEditParts(replacement_id), &place, pos, rotation, nullptr);
                            *placed_count += 1;
                        }
                    }
                }
            }
        }
    }

    return 1;
}

CEditParts *CEditMap::PlaceEditParts(char *name, float *pos, float *rot) {
    CEditParts *edit_parts = GetePlaceParts(BuildEditParts(name));

    if (edit_parts == nullptr) {
        return nullptr;
    }

    edit_parts->state = EDIT_PARTS_STATE_PLACED;
    edit_parts->SetPosition(pos);
    edit_parts->SetRotation(rot);
    edit_parts->SetScale(1.0f, 1.0f, 1.0f);
    return edit_parts;
}

CEditParts *CEditMap::PlaceEditParts(int index, EP_PLACE_INFO *place, float *pos, float *rotation,
                                     int *same_index) {
    CEditParts     *edit_parts = {};
    CEditPartsInfo *info = {};
    edit_parts = GetePlaceParts(index);

    if (edit_parts == nullptr) {
        return nullptr;
    }

    info = edit_parts->info;

    if (info == nullptr) {
        return nullptr;
    }

    if (edit_parts->GetPartsType() != EDIT_PARTS_TYPE_RIVER) {
        if (!CreatePlaceLog(index, place)) {
            return nullptr;
        }
    }

    if (area_no == 1) {
        if (place != nullptr) {
            CEditParts *other = GetePlaceParts(place->base[0]);

            if (other != nullptr) {
                edit_parts->ground = other->ground;
            }
        }
    }

    edit_parts->state = EDIT_PARTS_STATE_PLACED;

    if (same_index != nullptr) {
        *same_index = GetSameParts(index);
    }

    if (info->attr & EDIT_PARTS_ATR_RIVER) {
        if (CheckRiverParts(pos)) {
            PlaceRiver(pos);
            edit_parts->state = EDIT_PARTS_STATE_RIVER;
            edit_parts->SetPosition(0.0f, -10000.0f, 0.0f);
        } else {
            edit_parts->state = EDIT_PARTS_STATE_NONE;
        }

        return nullptr;
    }

    edit_parts->SetPosition(pos);
    edit_parts->SetRotation(rotation);
    edit_parts->SetScale(1.0f, 1.0f, 1.0f);
    return edit_parts;
}

int CEditMap::PlaceRiverParts(float *pos) {
    if (CheckRiverParts(pos) != 0) {
        PlaceRiver(pos);
        return 1;
    }

    return 0;
}

int CEditMap::CreatePlaceLog(int id, EP_PLACE_INFO *info) {
    EditPlaceLog *slot = {};
    int           index = {};
    int           remaining = {};
    int           i = {};

    if (info == nullptr || id < 0) {
        return 1;
    }

    if (place_log_max == 0 || place_log == nullptr) {
        return 0;
    }

    remaining = info->num;

    if (remaining < 0) {
        return 1;
    }

    slot = place_log;

    for (i = 0; i < place_log_max; i++, slot++) {
        int is_free = slot->parts_no < 0;

        if (is_free) {
            remaining--;
        }

        if (remaining <= 0) {
            break;
        }
    }

    if (remaining > 0) {
        return 0;
    }

    index = remaining;
    slot = place_log;

    for (i = 0; i < place_log_max; i++, slot++) {
        int is_free = slot->parts_no < 0;

        if (is_free) {
            slot->parts_no = id;
            slot->base_no = info->base[index];
            index++;

            if (!(index < info->num)) {
                break;
            }
        }
    }

    return 1;
}

int CEditMap::GetNearParts(CEditPartsInfo *info, float *pos, float angle, CEditParts **out, int max) {
    float       area_matrix[4][4];
    float       part_matrix[4][4];
    float       area_max[4];
    float       area_min[4];
    float       part_max[4];
    float       part_min[4];
    float       part_pos[4];
    float       part_rotation[4];
    CEditParts *part = {};
    int         i = {};
    int         count = {};
    float      *bounds = {};
    float      *info_bounds = {};

    if (info == nullptr) {
        return 0;
    }

    part = edit_parts;
    mgCreateMatrixPY(area_matrix, pos, angle);
    info->box.min[3] = 1.0f;
    info->box.max[3] = 1.0f;
    info_bounds = info->box.max;
    mgApplyMatrix(area_max, area_min, area_matrix, info_bounds, &info_bounds[4]);
    area_max[0] += 55.0f;
    area_max[2] += 55.0f;
    area_min[0] -= 55.0f;
    area_min[2] -= 55.0f;
    count = 0;
    i = 0;

    for (; i < edit_parts_max; i++, part++) {
        int is_free = part->name[0] == 0;

        if (is_free) {
            continue;
        }

        if (part->state != EDIT_PARTS_STATE_PLACED) {
            continue;
        }

        if (part->info == nullptr) {
            continue;
        }

        bounds = part->info->box.max;
        part->GetPosition(part_pos);
        part->GetRotation(part_rotation);
        mgCreateMatrixPY(part_matrix, part_pos, part_rotation[1]);

        mgApplyMatrix(part_max, part_min, part_matrix, bounds, &bounds[4]);

        if (!(count < max)) {
            break;
        }

        out[count++] = part;
    }

    return count;
}

int CEditMap::GetNearParts(mgVu0FBOX &box, CEditParts **out, int max) {
    float       matrix[4][4];
    float       world_max[4];
    float       world_min[4];
    float       pos[4];
    float       rotation[4];
    int         i = {};
    int         count = {};
    CEditParts *part = {};
    float      *bounds = {};
    count = 0;
    part = edit_parts;

    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = part->name[0] == 0;

        if (is_free) {
            continue;
        }

        if (part->state != EDIT_PARTS_STATE_PLACED) {
            continue;
        }

        if (part->info == nullptr) {
            continue;
        }

        bounds = part->info->box.max;
        part->GetPosition(pos);
        part->GetRotation(rotation);
        mgCreateMatrixPY(matrix, pos, rotation[1]);
        mgApplyMatrix(world_max, world_min, matrix, bounds, &bounds[4]);

        if (box.max[0] < world_min[0]) {
            continue;
        }

        if (box.max[2] < world_min[2]) {
            continue;
        }

        if (!(box.min[0] <= world_max[0])) {
            continue;
        }

        if (!(box.min[2] <= world_max[2])) {
            continue;
        }

        if (!(count < max)) {
            break;
        }

        out[count++] = part;
    }

    return count;
}

int CEditMap::GetePlaceParts(float *pos) {
    mgVu0FBOX   box{};
    CEditParts *near[0x200];
    int         count = {};

    *reinterpret_cast<u_long128 *>(box.max) = *reinterpret_cast<u_long128 *>(pos);
    *reinterpret_cast<u_long128 *>(box.min) = *reinterpret_cast<u_long128 *>(pos);

    for (int i = 0; i < 3; i++) {
        box.max[i] += pos[3];
        box.min[i] -= pos[3];
    }

    count = GetNearParts(box, near, 0x200);
    return GetePlaceParts(pos, near, count);
}

int CEditMap::GetePlaceParts(sceVu0FVECTOR pos, CEditParts **parts, int num) {
    sceVu0FVECTOR point;
    float         matrix[4][4];
    float         inverse[4][4];
    float         point_matrix[4][4];
    CCPoly        square[2];
    sceVu0FVECTOR offset;
    sceVu0FVECTOR parts_pos;
    sceVu0FVECTOR parts_rot;
    float         triangle[3][4];
    mgVu0FBOX     overlap_box{};
    float         overlap_area = {};
    float         radius = {};
    float         best_top{};
    int           i = {};
    int           j = {};
    CEditParts   *best = {};

    *reinterpret_cast<u_long128 *>(point) = *reinterpret_cast<u_long128 *>(pos);
    radius = point[3];
    point[3] = 1.0f;
    GetMatrix(point_matrix, point, 0);
    square[0].vertex[0][0] = 1.0f;
    square[0].vertex[0][1] = 0.0f;
    square[0].vertex[0][2] = 1.0f;
    square[0].vertex[0][3] = 1.0f;
    square[0].vertex[1][0] = -1.0f;
    square[0].vertex[1][1] = 0.0f;
    square[0].vertex[1][2] = -1.0f;
    square[0].vertex[1][3] = 1.0f;
    square[0].vertex[2][0] = -1.0f;
    square[0].vertex[2][1] = 0.0f;
    square[0].vertex[2][2] = 1.0f;
    square[0].vertex[2][3] = 1.0f;
    square[1].vertex[0][0] = 1.0f;
    square[1].vertex[0][1] = 0.0f;
    square[1].vertex[0][2] = 1.0f;
    square[1].vertex[0][3] = 1.0f;
    square[1].vertex[1][0] = 1.0f;
    square[1].vertex[1][1] = 0.0f;
    square[1].vertex[1][2] = -1.0f;
    square[1].vertex[1][3] = 1.0f;
    square[1].vertex[2][0] = -1.0f;
    square[1].vertex[2][1] = 0.0f;
    square[1].vertex[2][2] = -1.0f;
    square[1].vertex[2][3] = 1.0f;

    for (j = 0; j < 3; j++) {
        sceVu0ScaleVectorXYZ(square[0].vertex[j], square[0].vertex[j], radius);
        sceVu0ScaleVectorXYZ(square[1].vertex[j], square[1].vertex[j], radius);
    }

    best = nullptr;

    for (i = 0; i < num; i++) {
        CEditParts *part = parts[i];
        int         unnamed = part->name[0] == 0;

        if (unnamed) {
            continue;
        }

        CEditPartsInfo *info = part->info;

        if (info == nullptr || (info->attr & 4)) {
            continue;
        }

        part->GetPosition(parts_pos);
        part->GetRotation(parts_rot);
        GetMatrix(matrix, parts_pos, ConvEditAngle(parts_rot[1]));
        GetInversMatrix(inverse, matrix);
        sceVu0SubVector(offset, point, parts_pos);
        mgAngleLimit(-parts_rot[1]);
        CCPoly *poly = square;

        for (int j = 0; j < 2; j++, poly++) {
            mgApplyMatrixN(triangle, point_matrix, poly->vertex, 3);
            mgApplyMatrixN(triangle, inverse, triangle, 3);

            if (info->col_area3.OverlapPoly3XZ(triangle, &overlap_area, &overlap_box)) {
                float area = overlap_area < 0.0f ? -overlap_area : overlap_area;

                if (!(area <= 0.01f)) {
                    float top = overlap_box.max[1] + matrix[3][1];

                    if (best == nullptr || !(top <= best_top)) {
                        best = part;
                        best_top = top;
                    }
                }
            }
        }
    }

    int result = -1;

    if (best != nullptr) {
        pos[1] = best_top;
        result = ConvertParts(best);
    }

    return result;
}

int CEditMap::CheckEditParts(CEditPartsInfo *info, float *pos, float radius, EP_PLACE_INFO *place) {
    CEditParts *near_parts[512];
    int         count = {};

    if (info == nullptr) {
        return 0;
    }

    count = GetNearParts(info, pos, radius, near_parts, 512);
    return CheckEditParts(info, pos, radius, place, near_parts, count);
}

float CEditMap::GetEditPartsAlt(CEditPartsInfo *info, float *position, float angle) {
    CEditParts *near_parts[512];
    int         count = GetNearParts(info, position, angle, near_parts, 512);
    return GetEditPartsAlt(info, position, angle, near_parts, count);
}

int CEditMap::MagnetParts(CEditPartsInfo *info, float *pos, float *rot, CEditParts **parts, int num) {
    CEditParts     *nearest = {};
    float           part_area = {};
    float           height_limit = {};
    float           half_len = {};
    CEditParts     *part = {};
    int             line_part = {};
    float           dist = {};
    int             n = {};
    float           height_gap = {};
    float           gap_z = {};
    float           nearest_dist = {};
    float           gap_x = {};
    int             angle = {};
    float           rate = {};
    int             relative_angle = {};
    CEditParts     *flat_part = {};
    float           flat_rate = {};
    CEditParts     *touch_part = {};
    int             flat_angle = {};
    int             unnamed = {};
    CEditPartsInfo *part_info = {};
    int             other_angle = {};
    float           push_max_x = {};
    float           part_half_len = {};
    int             base_angle = {};
    int             shift_angle = {};
    int             near_count = {};
    float           area = {};
    int             part_angle = {};
    float           push_min_x = {};
    float           touch_rate = {};
    int             angle_gap{};
    float           push_max_z = {};
    float           push_min_z = {};
    int             moved = {};
    float           part_matrix[4][4];
    float           rot_matrix[4][4];
    float           matrix[4][4];

    if (info == nullptr) {
        return 0;
    }

    if (!(info->attr & 0x20)) {
        return 0;
    }

    line_part = 0;

    if (info->attr & 0x100) {
        line_part = 1;
    }

    angle = ConvEditAngle(*rot);
    GetMatrix(matrix, pos, angle);
    mgVu0FBOX box = info->area3_box;
    box.min[3] = 1.0f;
    box.max[3] = 1.0f;
    box.min[1] = 0.0f;
    box.max[1] = 0.0f;
    sceVu0FVECTOR end[2];
    sceVu0FVECTOR part_end[2];
    CEditParts   *near_list[64];
    sceVu0FVECTOR flat_pos;
    sceVu0FVECTOR touch_pos;
    sceVu0ApplyMatrix(end[0], matrix, box.min);
    sceVu0ApplyMatrix(end[1], matrix, box.max);
    end[0][1] = 0.0f;
    end[1][1] = 0.0f;
    half_len = 0.5f * mgDistVector(box.max, box.min);
    near_count = 0;
    nearest = nullptr;
    nearest_dist = 0.0f;
    flat_part = nullptr;
    touch_part = nullptr;
    flat_angle = 0;
    flat_rate = 0.0f;
    touch_rate = 0.0f;

    for (n = 0; n < num; n++) {
        part = parts[n];
        unnamed = part->name[0] == 0;

        if (unnamed) {
            continue;
        }

        part_info = part->info;

        if (part_info == nullptr || !(part_info->attr & 0x10)) {
            continue;
        }

        if (line_part) {
            if (!(part_info->attr & 0x100)) {
                continue;
            }
        } else if (part_info->attr & 0x100) {
            continue;
        }

        sceVu0FVECTOR part_pos;
        sceVu0FVECTOR offset;
        part->GetPosition(part_pos);
        mgVu0FBOX part_box = part_info->area3_box;
        part_box.min[1] = 0.0f;
        part_box.max[1] = 0.0f;
        part_half_len = 0.5f * mgDistVector(part_box.max, part_box.min);
        sceVu0SubVector(offset, pos, part_pos);
        offset[1] = 0.0f;

        if (!(mgDistVector(offset) <= 50.0f + (part_half_len + half_len))) {
            continue;
        }

        if (!line_part) {
            area = mgAbs(info->col_floor.AreaXZ());
            part_area = mgAbs(part_info->col_area1.AreaXZ());

            if (mgAbs(part_area - area) < 1.0f) {
                sceVu0FVECTOR other_pos;
                sceVu0FVECTOR other_rot;
                part->GetPosition(other_pos);
                part->GetRotation(other_rot);
                height_gap = other_pos[1] - pos[1];
                height_limit = 1.0f + part_info->GetPartsHeight();

                if (mgAbs(height_gap) <= height_limit) {
                    other_angle = ConvEditAngle(other_rot[1]);
                    float other_inverse[4][4];
                    float other_matrix[4][4];
                    float relative[4][4];
                    GetMatrix(other_matrix, other_pos, other_angle);
                    GetInversMatrix(other_inverse, other_matrix);
                    mgMulMatrix(relative, other_inverse, matrix);
                    rate = mgAbs(part_info->col_floor.OverlapXZ(info->col_area1, relative, nullptr) / area);

                    if (!(rate <= 0.01f) && (touch_part == nullptr || !(rate <= touch_rate))) {
                        touch_part = part;
                        touch_rate = rate;
                        *reinterpret_cast<u_long128 *>(touch_pos) = *reinterpret_cast<u_long128 *>(other_pos);
                    }

                    if (!(rate <= 0.6f) && (flat_part == nullptr || !(rate <= flat_rate))) {
                        flat_part = part;
                        flat_rate = rate;
                        flat_angle = other_angle;
                        *reinterpret_cast<u_long128 *>(flat_pos) = *reinterpret_cast<u_long128 *>(other_pos);
                    }
                }
            }
        }

        if (!(part_pos[1] < pos[1] + info->GetPartsHeight())) {
            continue;
        }

        if (part_pos[1] + part_info->GetPartsHeight() <= pos[1]) {
            continue;
        }

        if (!line_part) {
            GetRotMatrix(rot_matrix, AngleLimit(-ConvEditAngle(part->rotation[1])));
            offset[3] = 0.0f;
            sceVu0ApplyMatrix(offset, rot_matrix, offset);

            if (mgAbs(offset[2] - part_box.max[2]) < mgAbs(part_box.min[2] - offset[2])) {
                gap_z = mgAbs(offset[2] - part_box.max[2]);
            } else {
                gap_z = mgAbs(part_box.min[2] - offset[2]);
            }

            if (mgAbs(offset[0] - part_box.max[0]) < mgAbs(part_box.min[0] - offset[0])) {
                gap_x = mgAbs(offset[0] - part_box.max[0]);
            } else {
                gap_x = mgAbs(part_box.min[0] - offset[0]);
            }

            if (offset[0] <= part_box.max[0] && offset[0] >= part_box.min[0]) {
                dist = gap_z;
            } else if (offset[2] <= part_box.max[2] && offset[2] >= part_box.min[2]) {
                dist = gap_x;
            } else {
                dist = sqrtf(gap_x * gap_x + gap_z * gap_z);
            }
        } else {
            GetMatrix(part_matrix, part_pos, ConvEditAngle(part->rotation[1]));
            sceVu0ApplyMatrix(part_end[0], part_matrix, part_box.min);
            sceVu0ApplyMatrix(part_end[1], part_matrix, part_box.max);
            part_end[0][1] = 0.0f;
            part_end[1][1] = 0.0f;
            dist = mgDistVector(part_end[0], end[1]) < mgDistVector(part_end[1], end[0])
                       ? mgDistVector(part_end[0], end[1])
                       : mgDistVector(part_end[1], end[0]);
        }

        if (near_count >= 64) {
            break;
        }

        near_list[near_count++] = part;

        if (nearest == nullptr || dist < nearest_dist) {
            nearest = part;
            nearest_dist = dist;
        }
    }

    base_angle = 0;

    if (nearest == nullptr && flat_part == nullptr) {
        return 0;
    }

    if (nearest != nullptr) {
        base_angle = ConvEditAngle(nearest->rotation[1]);
        angle_gap = AngleLimit(angle - base_angle);
    }

    if (flat_part != nullptr) {
        base_angle = flat_angle;
        angle_gap = AngleLimit(angle - base_angle);

        if (!(mgAbs((box.max[0] - box.min[0]) - (box.max[2] - box.min[2])) <= 1.0f)) {
            if (angle_gap >= 6 && angle_gap < 18) {
                angle = flat_angle + 12;
            } else {
                angle = flat_angle;
            }

            angle_gap = 0;
        }
    }

    while (!line_part) {
        if (angle_gap % 6 != 0) {
            if (angle_gap >= 3 && angle_gap < 9) {
                angle = base_angle + 6;
            } else if (angle_gap >= 9 && angle_gap < 12) {
                angle = base_angle + 12;
            } else if (angle_gap >= 12 && angle_gap < 15) {
                angle = base_angle + 12;
            } else if (angle_gap >= 15 && angle_gap < 21) {
                angle = base_angle + 18;
            } else {
                angle = base_angle;
            }
        }

        break;
    }

    angle = AngleLimit(angle);

    if (flat_part != nullptr) {
        pos[0] = flat_pos[0];
        pos[2] = flat_pos[2];
        *rot = GetEditAngle(angle);
        return 1;
    }

    moved = 0;
    sceVu0FVECTOR shift;
    mgZeroVector(shift);
    shift_angle = 0;

    if (line_part) {
        sceVu0FVECTOR near_pos;
        sceVu0FVECTOR gap[2];
        nearest->GetPosition(near_pos);
        GetMatrix(part_matrix, near_pos, ConvEditAngle(nearest->rotation[1]));
        mgVu0FBOX near_box = nearest->info->area3_box;
        near_box.min[1] = 0.0f;
        near_box.max[1] = 0.0f;
        sceVu0ApplyMatrix(part_end[0], part_matrix, near_box.min);
        sceVu0ApplyMatrix(part_end[1], part_matrix, near_box.max);
        part_end[0][1] = 0.0f;
        part_end[1][1] = 0.0f;
        sceVu0SubVector(gap[1], part_end[0], end[1]);
        sceVu0SubVector(gap[0], part_end[1], end[0]);
        gap[1][1] = 0.0f;
        gap[0][1] = 0.0f;

        if (mgDistVector(gap[0]) < mgDistVector(gap[1])) {
            *reinterpret_cast<u_long128 *>(shift) = *reinterpret_cast<u_long128 *>(gap[0]);
        } else {
            *reinterpret_cast<u_long128 *>(shift) = *reinterpret_cast<u_long128 *>(gap[1]);
        }

        moved = 1;
    } else {
        for (n = 0; n < near_count; n++) {
            CEditParts *part = near_list[n];
            part_angle = ConvEditAngle(part->rotation[1]);
            relative_angle = AngleLimit(angle - part_angle);

            if (relative_angle % 6 != 0) {
                continue;
            }

            sceVu0FVECTOR local_pos;
            sceVu0FVECTOR local_max;
            sceVu0FVECTOR local_min;
            sceVu0FVECTOR target_pos;
            part->GetPosition(target_pos);
            sceVu0SubVector(local_pos, pos, target_pos);
            GetRotMatrix(rot_matrix, AngleLimit(-part_angle));
            local_pos[3] = 0.0f;
            sceVu0ApplyMatrix(local_pos, rot_matrix, local_pos);
            GetRotMatrix(rot_matrix, AngleLimit(relative_angle));
            sceVu0ApplyMatrix(local_max, rot_matrix, box.max);
            sceVu0ApplyMatrix(local_min, rot_matrix, box.min);
            mgVectorMaxMin(local_max, local_min, local_max, local_min);
            mgVu0FBOX target_box = part->info->area3_box;
            mgAddVector(local_max, local_pos);
            mgAddVector(local_min, local_pos);
            sceVu0FVECTOR push;
            mgZeroVector(push);
            push_max_x = target_box.max[0] - local_min[0];
            push_min_x = target_box.min[0] - local_max[0];
            push_max_z = target_box.max[2] - local_min[2];
            push_min_z = target_box.min[2] - local_max[2];

            if (!(local_max[0] <= target_box.min[0]) && local_min[0] < target_box.max[0]) {
                if (local_max[2] <= target_box.min[2]) {
                    push[2] = push_min_z;
                } else {
                    push[2] = push_max_z;
                }
            } else if (!(local_max[2] <= target_box.min[2]) && local_min[2] < target_box.max[2]) {
                if (local_max[0] <= target_box.min[0]) {
                    push[0] = push_min_x;
                } else {
                    push[0] = push_max_x;
                }
            }

            if (!(mgDistVector(push) <= 50.0f)) {
                continue;
            }

            if (!moved) {
                shift_angle = part_angle;
            }

            moved = 1;
            GetRotMatrix(part_matrix, AngleLimit(part_angle - shift_angle));
            sceVu0ApplyMatrix(push, part_matrix, push);

            if (shift[0] != 0.0f) {
                if (push[0] != 0.0f && !(mgAbs(shift[0]) <= mgAbs(push[0]))) {
                    shift[0] = push[0];
                }
            } else {
                shift[0] = push[0];
            }

            if (shift[2] != 0.0f) {
                if (push[2] != 0.0f && !(mgAbs(shift[2]) <= mgAbs(push[2]))) {
                    shift[2] = push[2];
                }
            } else {
                shift[2] = push[2];
            }
        }

        GetRotMatrix(part_matrix, AngleLimit(shift_angle));
        sceVu0ApplyMatrix(shift, part_matrix, shift);
    }

    shift[0] = static_cast<int>(shift[0]);
    shift[2] = static_cast<int>(shift[2]);

    if (moved) {
        pos[0] += shift[0];
        pos[2] += shift[2];
    }

    *rot = GetEditAngle(angle);
    return moved;
}

int CEditMap::MagnetParts(CEditPartsInfo *info, float *pos, float *magnet) {
    CEditParts *near_parts[512];
    int         count = GetNearParts(info, pos, magnet[0], near_parts, 512);
    return MagnetParts(info, pos, magnet, near_parts, count);
}

int CEditMap::CheckWallEditParts(CEditPartsInfo *info, float *pos, int wall_no, int base_no, EP_PLACE_INFO *place) {
    CEditParts::WallInfo wall{};
    sceVu0FVECTOR        world_normal;
    float                base_matrix[4][4];
    float                wall_basis[4][4];
    sceVu0FVECTOR        local_pos;
    sceVu0FVECTOR        wall_plane;
    EditVector           up{};
    float                wall_matrix[4][4];
    float                wall_inverse[4][4];
    float                swap_yz[4][4];
    sceVu0FVECTOR        poly_normal;
    float                triangle[3][4];
    float                place_matrix[4][4];
    float                other_matrix[4][4];
    float                other_inverse[4][4];
    float                covered_area = {};
    float                total = {};
    float                covered = {};
    CCPoly              *poly = {};
    int                  i = {};
    int                  count = {};

    if (info == nullptr) {
        return 0;
    }

    CEditParts     *base = GetePlaceParts(base_no);
    CEditPartsInfo *base_info = base->info;

    if (base == nullptr || base_info == nullptr || !base->GetWallPlane(wall_no, &wall)) {
        return 0;
    }

    base->GetLWMatrix(base_matrix);
    up = at_1837__2;
    sceVu0Normalize(wall_basis[2], wall.plane);
    wall_basis[2][3] = 0.0f;
    sceVu0OuterProduct(wall_basis[0], up.values, wall_basis[2]);
    wall_basis[0][3] = 0.0f;
    sceVu0OuterProduct(wall_basis[1], wall_basis[2], wall_basis[0]);
    wall_basis[1][3] = 0.0f;
    *reinterpret_cast<u_long128 *>(wall_basis[3]) = *reinterpret_cast<u_long128 *>(wall.center);
    wall_basis[3][3] = 1.0f;
    pos[3] = 1.0f;
    sceVu0ApplyMatrix(local_pos, wall_basis, pos);
    *reinterpret_cast<u_long128 *>(wall_plane) = *reinterpret_cast<u_long128 *>(wall.plane);
    wall_plane[3] = 0.0f;
    sceVu0ApplyMatrix(world_normal, base_matrix, wall_plane);
    mgMulMatrix(base_matrix, base_matrix, wall_basis);
    sceVu0ApplyMatrix(pos, base_matrix, pos);
    pos[3] = GetEditAngle(ConvEditAngle(atan2f(world_normal[0], world_normal[2])));
    mgUnitMatrix(wall_matrix);
    *reinterpret_cast<u_long128 *>(wall_matrix[1]) = *reinterpret_cast<u_long128 *>(wall_plane);
    wall_matrix[1][3] = 0.0f;
    wall_matrix[2][2] = 0.0f;
    wall_matrix[2][0] = 0.0f;
    wall_matrix[2][1] = 1.0f;
    sceVu0OuterProduct(wall_matrix[0], wall_matrix[1], wall_matrix[2]);
    *reinterpret_cast<u_long128 *>(wall_matrix[3]) = *reinterpret_cast<u_long128 *>(local_pos);
    wall_matrix[3][3] = 1.0f;
    GetInversMatrix(wall_inverse, wall_matrix);
    mgUnitMatrix(swap_yz);
    swap_yz[1][1] = 0.0f;
    swap_yz[2][2] = 0.0f;
    total = 0.0f;
    swap_yz[2][1] = 1.0f;
    swap_yz[1][2] = 1.0f;
    poly = info->col_area1.poly;

    for (i = 0, count = info->col_area1.poly_count; i < count; i++, poly++) {
        mgPlaneNormal(poly_normal, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
        total += 0.5f * mgDistVector(poly_normal);
    }

    count = info->col_area1.poly_count;
    poly = info->col_area1.poly;
    covered = 0.0f;

    for (i = 0; i < count; i++, poly++) {
        mgApplyMatrixN(triangle, swap_yz, poly->vertex, 3);

        if (base_info->col_wall.OverlapPoly3XZ(triangle, wall_inverse, &covered_area)) {
            covered += covered_area < 0.0f ? -covered_area : covered_area;
        }
    }

    info->col_area1.AreaXZ();
    CEditParts *part = edit_parts;
    GetMatrix(place_matrix, pos, ConvEditAngle(pos[3]));
    mgVu0FBOX place_box = info->col_area3.bbox;

    for (int n = 0; n < edit_parts_max; n++, part++) {
        if (n == base_no) {
            continue;
        }

        int unnamed = part->name[0] == 0;

        if (unnamed || part->state == EDIT_PARTS_STATE_NONE) {
            continue;
        }

        CEditPartsInfo *other_info = part->info;

        if (other_info == nullptr) {
            continue;
        }

        sceVu0FVECTOR other_pos;
        sceVu0FVECTOR other_rot;
        sceVu0FVECTOR offset;
        part->GetPosition(other_pos);
        part->GetRotation(other_rot);
        GetMatrix(other_matrix, other_pos, ConvEditAngle(other_rot[1]));
        mgInversMatrix(other_inverse, other_matrix);
        sceVu0SubVector(offset, pos, other_pos);
        mgVu0FBOX other_box = other_info->col_area3.bbox;
        float     relative[4][4];
        mgMulMatrix(relative, other_inverse, place_matrix);

        if (place_box.max[1] == 0.0f || other_box.max[1] == 0.0f) {
            continue;
        }

        if (place_box.max[1] + offset[1] <= other_box.min[1]) {
            continue;
        }

        if (!(place_box.min[1] + offset[1] < other_box.max[1])) {
            continue;
        }

        float overlap = other_info->col_area3.OverlapXZ(info->col_area3, relative, nullptr);
        float overlap_size = overlap < 0.0f ? -overlap : overlap;

        if (overlap_size < 0.01f) {
            continue;
        }

        float share = overlap / total;

        if (share < 0.0f) {
            share = -share;
        }

        if (!(share <= 0.01f)) {
            return 0;
        }
    }

    place->num = 1;
    place->base[0] = base_no;

    if (total < 0.0f) {
        return 0;
    }

    if (covered / total < 0.99f) {
        return 0;
    }

    return 1;
}

void CEditMap::Step() {
    frame += 1;
    CMap::Step();
}

int CEditMap::PreDraw(float *pos) {
    CEditParts *part = {};
    int         i = {};
    CMap::PreDraw(pos);
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    part = edit_parts;

    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = part->name[0] == 0;

        if (!is_free) {
            part->StepFuncPoint(check);
        }
    }

    return 1;
}

int CEditMap::DrawSub(int mode) {
    float       ambient[4];
    float       pulsed[4];
    CEditParts *part = {};
    int         total = {};
    int         light_b = {};
    int         i = {};
    int         channel = {};
    int         light_a = {};

    if (balance_moved != 0) {
        for (light_a = 0; light_a < 4; light_a++) {
            if (balance_parts[light_a] != nullptr) {
                balance_parts[light_a]->SetPosition(balance_base_pos[light_a]);
            }
        }
    }

    CFuncPointCheck check;
    CreateFuncCheck(&check);
    part = edit_parts;
    total = 0;
    i = 0;

    for (; i < edit_parts_max; i++, part++) {
        int is_free = part->name[0] == 0;

        if (!is_free && part->state == EDIT_PARTS_STATE_PLACED) {
            part->CopyFuncPointCheck(check);

            if (i == focus_parts) {
                float boost = {};
                mgGetAmbient(ambient);
                boost = 48.0f * (1.0f + sinf(TWO_PI * static_cast<float>(frame % 30) / 30.0f));

                for (channel = 0; channel < 3; channel++) {
                    pulsed[channel] = boost + ambient[channel];

                    if (!(pulsed[channel] <= 255.0f)) {
                        pulsed[channel] = 255.0f;
                    }
                }

                pulsed[3] = 128.0f;
                mgSetAmbient(pulsed);
            }

            if (mode != 0) {
                total += part->DrawDirect();
            } else {
                total += part->Draw();
            }

            if (i == focus_parts) {
                mgSetAmbient(ambient);
            }
        }
    }

    CMap::DrawSub(mode);

    if (balance_moved != 0) {
        for (light_b = 0; light_b < 4; light_b++) {
            if (balance_parts[light_b] != nullptr) {
                balance_parts[light_b]->SetPosition(balance_pos[light_b]);
            }
        }
    }

    return total;
}

void CEditMap::LoadEditInfo(char *script, int size, mgCMemory *stack) {
    int has_river = {};
    emapMap = this;
    emapStack = stack;
    emapInfo = &info_mngr;
    has_river = 0;

    for (int n = 0; n < info_mngr.parts_info_num; n++) {
        if (info_mngr.parts_info[n].attr & EDIT_PARTS_ATR_RIVER) {
            has_river = 1;
        }
    }

    for (int i = 0; i < info_mngr.parts_info_num; i++) {
        CEditPartsInfo *info = &info_mngr.parts_info[i];
        CMapParts      *parts = GetParts(info->parts_name);
        info->parts = parts;
        info->CreateBox();
        CMapPiece     *piece = nullptr;
        CColFrame     *col_frame = nullptr;
        CCollisionMDT *collision = nullptr;

        if (parts != nullptr) {
            piece = parts->SearchPieceColType(MDS_TYPE_COLLISION);
        }

        if (piece != nullptr) {
            col_frame = static_cast<CColFrame *>(piece->frame);
        }

        if (col_frame != nullptr) {
            collision = static_cast<CCollisionMDT *>(col_frame->collision);
        }

        mgVu0FBOX extent{};
        mgZeroVector(extent.max);
        mgZeroVector(extent.min);
        float area = 0.0f;
        info->place_anime = EDIT_PLACE_ANIME_SQUASH;

        if (collision != nullptr) {
            CEditCollision source;
            float          matrix[4][4];
            collision->Copy(source, nullptr);
            source.Copy(info->col_area1, 1, stack);
            col_frame->GetLWMatrix(matrix);
            info->col_area1.ApplyMatrix(matrix);
            mgUnitMatrix(matrix);
            col_frame->SetTransMatrix(matrix);
            mgVectorMaxMin(extent.max, extent.min, extent.min, extent.max,
                           info->col_area1.bbox.max, info->col_area1.bbox.min);
            area = info->col_area1.AreaXZ();
            source.Copy(info->col_area5, 5, stack);
            info->col_area5.ApplyMatrix(matrix);
            mgVectorMaxMin(extent.max, extent.min, extent.min, extent.max,
                           info->col_area5.bbox.max, info->col_area5.bbox.min);
            source.Copy(info->col_floor, 2, stack);
            source.Copy(info->col_wall, 2, stack);
            info->col_floor.ApplyMatrix(matrix);
            mgUnitMatrix(matrix);
            col_frame->SetTransMatrix(matrix);
            info->col_floor.DeleteVerticalPoly();
            mgVectorMaxMin(extent.max, extent.min, extent.min, extent.max,
                           info->col_floor.bbox.max, info->col_floor.bbox.min);
            info->col_wall.ApplyMatrix(matrix);
            info->wall_group_num = info->col_wall.PickupVerticalPoly();
            mgVectorMaxMin(extent.max, extent.min, extent.min, extent.max,
                           info->col_wall.bbox.max, info->col_wall.bbox.min);
            source.Copy(info->col_area3, 3, stack);
            info->col_area3.ApplyMatrix(matrix);
            info->col_area3.bbox.min[1] = 0.0f;
            info->area3_box = info->col_area3.bbox;

            if (info->attr & 0x100) {
                float width = info->area3_box.max[0] - info->area3_box.min[0];
                float depth = info->area3_box.max[2] - info->area3_box.min[2];

                if (width > depth) {
                    info->area3_box.max[2] = info->area3_box.min[2] += depth / 2.0f;
                } else {
                    info->area3_box.max[0] = info->area3_box.min[0] += width / 2.0f;
                }

                info->area3_box.max[1] = info->area3_box.min[1] = 0.0f;
            }

            mgVectorMaxMin(extent.max, extent.min, extent.min, extent.max,
                           info->col_area3.bbox.max, info->col_area3.bbox.min);
        }

        sceVu0FVECTOR zero;
        mgZeroVector(zero);

        if (parts != nullptr) {
            mgVu0FBOX bound{};
            mgZeroVector(zero);
            parts->SetPosition(zero);
            parts->SetRotation(zero);
            parts->SetPosition(1.0f, 1.0f, 1.0f);

            if (parts->GetBoundBox(&bound)) {
                float bottom = bound.min[1];

                if (bottom < -2.0f && (info->attr & 0x10000)) {
                    info->bury_depth = bottom < 0.0f ? -bottom : bottom;
                }

                float margin[4] = {10.0f, 10.0f, 10.0f, 0.0f};
                mgAddVector(bound.max, margin);
                mgSubVector(bound.min, margin);
            }

            extent.max[3] = 1.0f;
            extent.min[3] = 1.0f;
            info->box = extent;
            info->box.min[3] = 1.0f;
            info->box.max[3] = 1.0f;
            float height = extent.max[1] - extent.min[1];

            if (!(height * height / area <= 2.0f)) {
                info->place_anime = EDIT_PLACE_ANIME_SWAY;
            }

            sceVu0FVECTOR span;
            sceVu0SubVector(span, bound.max, bound.min);
            float span_x = span[0] < 0.0f ? -span[0] : span[0];
            float span_z = span[2] < 0.0f ? -span[2] : span[2];
            float radius = {};

            if (span_x > span_z) {
                radius = span[0] < 0.0f ? -span[0] : span[0];
            } else {
                radius = span[2] < 0.0f ? -span[2] : span[2];
            }

            info->territory_radius = radius;
            info->territory_height = (span[1] < 0.0f ? -span[1] : span[1]) / 2.0f;
            info->unk_278 = info->territory_radius;
            sceVu0AddVector(info->territory_center, bound.max, bound.min);
            sceVu0ScaleVector(info->territory_center, info->territory_center, 0.5f);
            info->territory_center[3] = 1.0f;
        }

        if (info->attr & 0x100) {
            info->place_anime = EDIT_PLACE_ANIME_NONE;
        }

        if (info->attr & 0x200) {
            info->place_anime = EDIT_PLACE_ANIME_NONE;
        }

        if (parts != nullptr && (info->attr & EDIT_PARTS_ATR_GROUND) == EDIT_PARTS_ATR_GROUND) {
            info->col_area3.Initialize();
            CList<CMapPiece> *node = parts->piece_list;
            mgCFrameAttr      frame_attr;
            frame_attr.dest_alpha_test = MG_DEST_ALPHA_TEST_ONE;

            for (; node != nullptr; node = node->next) {
                CMapPiece *model = node->pGetData();

                if (model->type == MDS_TYPE_MODEL) {
                    mgCFrame *frame = model->frame;

                    if (frame != nullptr) {
                        mgVu0FBOX grid_box{};

                        if (has_river) {
                            frame->SetAttrParam(frame_attr, 1, MG_FRAME_ATTR_DEST_ALPHA);
                        }

                        if (frame->GetWorldBBox(&grid_box)) {
                            float offset[4] = {80.0f, 0.0f, 80.0f, 0.0f};

                            if (info->id == 0x38) {
                                offset[0] = 0.0f;
                                offset[2] = 0.0f;
                            }

                            CreateGrid(grid_box.max, grid_box.min, stack, offset);
                        }
                    }

                    break;
                }
            }
        }
    }

    emapIdx = 0;
    emapNowInfo = 0;
    emapRect = 0;
    emapRectNum = 0;
    emapRectIdx = 0;
    emapFixNum = 0;
    emapFixIdx = 0;
    PortApplyEditMapConfig(this, script, size, stack);

    river_info = new (emapStack->Alloc(0x142)) CEditPartsInfo[EDIT_MAP_RIVER_PARTS_MAX];

    for (int river = 0; river < EDIT_MAP_RIVER_PARTS_MAX; river++) {
        if (river_parts[river] != nullptr) {
            CMapPiece *river_col = river_parts[river]->SearchPieceColType(MDS_TYPE_COLLISION);

            if (river_col != nullptr) {
                CColFrame *river_frame = static_cast<CColFrame *>(river_col->frame);

                if (river_frame != nullptr) {
                    CCollisionMDT *river_collision = static_cast<CCollisionMDT *>(river_frame->collision);
                    river_collision->Copy(river_info[river].col_floor, nullptr);
                    river_collision->Copy(river_info[river].col_area1, nullptr);
                }
            }
        }
    }
}

#include "common.h"

#include <algorithm>
#include <array>
#include <cstring>
#include <deque>
#include <new>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#include "editinfo.hpp"
#include "editmap.hpp"
#include "editparts.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "platform/arena.hpp"
#include "scene_documents.hpp"
#include "stubs/editmap.hpp"

namespace {

/** Quadwords a model heap must have free before a part's model is copied into it, as retail requires. */
constexpr int kPartBuildRest = 1000;

/** Definition attribute of parts that the river must keep carrying. */
constexpr u32 kRiverRelatedAttr = 0x80000;

/** Definition IDs that a removal counts. */
constexpr int kRemoveInfoIdMax = EDIT_REMOVE_INFO_ID_MAX;

/**
 * Host storage of one town's edit map beyond what CEditMap holds.
 */
struct EditMapStorage {
    std::deque<mgCMemory> heaps;            /**< Model heaps after parts_heap, at stable addresses. */
    std::size_t           heaps_in_use{};   /**< Leading entries of heaps holding models. */
    int                   heap_quadwords{}; /**< Quadwords of each model heap. */
    int                   house_count{};    /**< Houses handed out since the last clear. */
};

std::unordered_map<const CEditMap *, EditMapStorage> &Storages() {
    static std::unordered_map<const CEditMap *, EditMapStorage> storages;
    return storages;
}

EditMapStorage &Storage(const CEditMap &map) {
    return Storages()[&map];
}

/** Villagers made homeless by the removal in progress; RemoveInfo::house_npc points into it. */
std::vector<s32> &RemovedHouseNpcs() {
    static std::vector<s32> npcs;
    return npcs;
}

template <typename T>
T *SlotBlock(const void *owner, std::size_t count) {
    return reinterpret_cast<T *>(ArenaBlock(owner, count * sizeof(T)));
}

void BindHeap(mgCMemory &heap, int quadwords) {
    heap.SetHeapMem(SlotBlock<u_long128>(&heap, static_cast<std::size_t>(quadwords)), quadwords);
}

/**
 * Constructs the next edit part slot and its four placement log entries.
 */
void ConstructSlot(CEditMap &map) {
    // A town loaded where the last one was gets the same block back; its slots start as fresh memory would.
    CEditParts *slot = &map.edit_parts[map.edit_parts_max];
    std::memset(static_cast<void *>(slot), 0, sizeof(CEditParts));
    new (slot) CEditParts;
    for (int i = 0; i < EDIT_MAP_LOG_PER_PARTS; ++i) {
        map.place_log[map.place_log_max + i] = {.parts_no = -1, .base_no = -1};
    }
    ++map.edit_parts_max;
    map.place_log_max += EDIT_MAP_LOG_PER_PARTS;
}

/**
 * Model heap holding an address, or parts_heap when none does.
 */
mgCMemory &HeapOwning(CEditMap &map, const u_long128 *address) {
    auto &storage = Storage(map);
    for (std::size_t i = 0; i < storage.heaps_in_use; ++i) {
        mgCMemory &heap = storage.heaps[i];
        if (address >= heap.heap && address < heap.heap + heap.heap_size) {
            return heap;
        }
    }
    return map.parts_heap;
}

/**
 * Puts a model heap with room for a part's model into stack mode and returns it with the stack's start.
 */
std::pair<mgCMemory *, u_long128 *> HeapWithRoom(CEditMap &map) {
    const auto stack_with_room = [](mgCMemory &heap) -> u_long128 * {
        u_long128 *start = heap.StartStackMode(MG_STACK_MODE_LARGEST, 0);
        if (start != nullptr && heap.stGetRest() >= kPartBuildRest) {
            return start;
        }
        heap.EndStackMode();
        return nullptr;
    };
    if (u_long128 *start = stack_with_room(map.parts_heap)) {
        return {&map.parts_heap, start};
    }
    auto &storage = Storage(map);
    for (;;) {
        if (storage.heaps_in_use == storage.heaps.size()) {
            storage.heaps.emplace_back();
        }
        // Heaps out of use are empty: ClearAllParts cleared them, or CreateTable unbound them for a new size.
        mgCMemory &heap = storage.heaps[storage.heaps_in_use++];
        if (heap.heap_top == nullptr) {
            BindHeap(heap, storage.heap_quadwords);
        }
        if (u_long128 *start = stack_with_room(heap)) {
            return {&heap, start};
        }
    }
}

} // namespace

int PortEditHouseCount(const CEditMap &map) {
    return Storage(map).house_count;
}

CEditHouse *PortEditHouse(CEditMap &map, int index) {
    auto &storage = Storage(map);
    if (index < 0 || index >= kPortEditSlotCeiling) {
        return nullptr;
    }
    if (map.house == nullptr) {
        map.ClearHouse();
    }
    for (; storage.house_count <= index; ++storage.house_count) {
        std::memset(static_cast<void *>(&map.house[storage.house_count]), 0, sizeof(CEditHouse));
    }
    return &map.house[index];
}

void PortEditReserveSlots(CEditMap &map, int slots) {
    if (map.edit_parts == nullptr || map.place_log == nullptr) {
        return;
    }
    while (map.edit_parts_max < slots && map.edit_parts_max < kPortEditSlotCeiling) {
        ConstructSlot(map);
    }
}

int CEditMap::GetePlaceIDList(int *output, int capacity) {
    int count = 0;
    for (int index = 0; index < edit_parts_max && count < capacity; ++index) {
        if (edit_parts[index].name[0] != '\0') {
            output[count++] = index;
        }
    }
    return count;
}

// Houses live in one block sized for every slot, so a part's house pointer never moves.
void CEditMap::ClearHouse() {
    auto &storage = Storage(*this);
    house = SlotBlock<CEditHouse>(static_cast<const void *>(&house), kPortEditSlotCeiling);
    std::memset(static_cast<void *>(house), 0, static_cast<std::size_t>(storage.house_count) * sizeof(CEditHouse));
    storage.house_count = 0;
}

CEditHouse *CEditMap::eNewHouseInfo() {
    const int count = PortEditHouseCount(*this);
    for (int i = 0; i < count; ++i) {
        if (house[i].active == 0) {
            return &house[i];
        }
    }
    return PortEditHouse(*this, count);
}

// The slots and their placement log are one block each, reserved for the slot ceiling and constructed as the town
// needs them: placed parts and their animations keep pointers to their slots, and retail walks the slots as an array.
void CEditMap::CreateTable(mgCMemory * /*memory*/, int parts_max, int heap_size) {
    auto &storage = Storage(*this);
    // Every heap must fit at least one part's model, or a build would never find room.
    storage.heap_quadwords = std::max(heap_size * kArenaHeadroom, kPartBuildRest * 2);
    storage.heaps_in_use = 0;
    for (mgCMemory &heap : storage.heaps) {
        heap.Init();
    }
    BindHeap(parts_heap, storage.heap_quadwords);
    edit_parts = SlotBlock<CEditParts>(static_cast<const void *>(&edit_parts), kPortEditSlotCeiling);
    place_log = SlotBlock<EditPlaceLog>(static_cast<const void *>(&place_log), static_cast<std::size_t>(kPortEditSlotCeiling) * EDIT_MAP_LOG_PER_PARTS);
    edit_parts_max = 0;
    place_log_max = 0;
    PortEditReserveSlots(*this, parts_max);
}

int CEditMap::eNewPlaceParts() {
    for (int i = 0; i < edit_parts_max; ++i) {
        if (edit_parts[i].name[0] == '\0') {
            return i;
        }
    }
    if (edit_parts == nullptr || edit_parts_max >= kPortEditSlotCeiling) {
        return EDIT_BUILD_NO_SLOT;
    }
    ConstructSlot(*this);
    return edit_parts_max - 1;
}

void CEditMap::ClearAllParts() {
    auto &storage = Storage(*this);
    for (std::size_t i = 0; i < storage.heaps_in_use; ++i) {
        storage.heaps[i].ClearHeapMem();
    }
    storage.heaps_in_use = 0;

    int             i = {};
    int             log_offset = {};
    int             log_index = {};
    ePlaceData     *initial = {};
    CEditParts     *placed = {};
    int             initial_offset = {};
    int             k = {};
    float           rotation[4];
    CEditPartsInfo *info = {};
    (&parts_heap)->ClearHeapMem();
    i = 0;

    for (; i < edit_parts_max; i++) {
        edit_parts[i].Initialize();
    }

    log_index = 0;
    log_offset = 0;

    for (; log_index < place_log_max; log_index++) {
        *reinterpret_cast<s16 *>(reinterpret_cast<u8 *>(place_log) + log_offset) = -1;
        log_offset += 4;
    }

    ClearGrid();
    ClearHouse();
    k = 0;
    initial_offset = 0;

    for (; k < info_mngr.fix_parts_num; k++) {
        initial = reinterpret_cast<ePlaceData *>(reinterpret_cast<u8 *>(info_mngr.fix_parts) + initial_offset);
        static EditVector zero_rotation;
        *reinterpret_cast<EditVector *>(rotation) = zero_rotation;
        rotation[1] = GetEditAngle(initial->angle);
        info = info_mngr.GetePartsInfoAtID(initial->id);
        placed = nullptr;

        if (info != nullptr) {
            placed = PlaceEditParts(info->edit_name, initial->position, rotation);
        }

        if (area_no == 1 && placed != nullptr) {
            CMapParts *anchor = nullptr;

            switch (k) {
                case 0:
                    anchor = GetPlaceParts("p09_g0201");
                    break;
                case 1:
                    anchor = GetPlaceParts("p09_g0201-1");
                    break;
                case 2:
                    anchor = GetPlaceParts("p08_g0201");
                    break;
                case 3:
                    anchor = GetPlaceParts("p08_g0201-1");
                    break;
            }

            placed->ground = anchor;
        }

        initial_offset += 0x20;
    }

    focus_parts = -1;
    frame = 0;
}

// Retail's build, with the model copied into whichever heap has room.
int CEditMap::BuildEditParts(char *name) {
    CEditPartsInfo *info = GetePartsInfo(name);
    if (info == nullptr) {
        return EDIT_BUILD_NO_INFO;
    }
    const int   index = eNewPlaceParts();
    CEditParts *part = GetePlaceParts(index);
    if (part == nullptr) {
        return EDIT_BUILD_NO_SLOT;
    }
    CEditHouse *new_house = nullptr;
    if ((info->attr & EDIT_PARTS_ATR_TYPE_ONE) != 0) {
        new_house = eNewHouseInfo();
        if (new_house == nullptr) {
            part->Initialize();
            return EDIT_BUILD_NO_HOUSE;
        }
    }
    CMapParts *model = GetParts(info->parts_name);
    if (model == nullptr) {
        return EDIT_BUILD_NO_INFO;
    }
    const auto [heap, memory] = HeapWithRoom(*this);
    model->Copy(*part, heap);
    heap->EndStackMode();
    part->allocation_address = memory;
    part->info = info;
    part->SetPosition(0.0f, 0.0f, 0.0f);
    part->SetRotation(0.0f, 0.0f, 0.0f);
    part->SetScale(1.0f, 1.0f, 1.0f);
    part->CheckColorUpdate();
    if (new_house != nullptr) {
        std::memset(static_cast<void *>(new_house), 0, sizeof(CEditHouse));
        new_house->active = 1;
    }
    part->house = new_house;
    return index;
}

int CEditMap::DeleteEditParts(int index) {
    CEditParts *part = GetePlaceParts(index);
    if (part == nullptr) {
        return 0;
    }
    if (part->house != nullptr) {
        std::memset(static_cast<void *>(part->house), 0, sizeof(CEditHouse));
    }
    if (part->allocation_address != nullptr) {
        HeapOwning(*this, part->allocation_address).Free(part->allocation_address);
    }
    part->Initialize();
    return 1;
}

namespace {

/**
 * One call of retail's recursive removal waiting on the calls it made.
 */
struct RemovalFrame {
    bool                 river{};      /**< Walking the slots for river parts the removed river no longer carries. */
    int                  index{};      /**< Slot removed, for a part. */
    std::array<float, 4> pos{};        /**< Position passed down to the calls this one makes. */
    std::size_t          outer{};      /**< Own log entry, or slot, being visited. */
    std::size_t          inner{};      /**< Dependent log entry being visited under the own entry. */
    bool                 own_active{}; /**< The own entry at outer matched and its dependents are being visited. */
};

/**
 * Retail's RemoveEditParts as an explicit stack, with each slot's log entries found through indexes built once.
 */
class Removal {
public:
    Removal(CEditMap &map, CEditMap::RemoveInfo *info) : map(map), info(info) {
        const auto slots = static_cast<std::size_t>(std::max(map.edit_parts_max, 0));
        by_part.resize(slots);
        by_base.resize(slots);
        if (map.place_log == nullptr) {
            return;
        }
        // Removal only ever frees entries, so these lists stay complete; entries are rechecked when visited.
        for (int n = 0; n < map.place_log_max; ++n) {
            const EditPlaceLog &entry = map.place_log[n];
            if (entry.parts_no >= 0 && std::cmp_less(entry.parts_no, slots)) {
                by_part[entry.parts_no].push_back(n);
            }
            if (entry.base_no >= 0 && std::cmp_less(entry.base_no, slots)) {
                by_base[entry.base_no].push_back(n);
            }
        }
    }

    int Run(int index, const float *pos) {
        const int result = Enter(index, pos);
        while (!stack.empty()) {
            Step();
        }
        return result;
    }

private:
    CEditMap                     &map;
    CEditMap::RemoveInfo         *info;
    std::vector<std::vector<int>> by_part;
    std::vector<std::vector<int>> by_base;
    std::vector<RemovalFrame>     stack;

    void Count(int id) {
        if (id >= 0 && id < kRemoveInfoIdMax && info != nullptr) {
            info->parts_num[id] += 1;
        }
    }

    void RefundPaint(CEditParts &part) {
        if (info == nullptr || info->color_num <= 0 || part.IsFence() != 0 || part.info == nullptr) {
            return;
        }
        float color[4];
        for (int c = 0; c < part.info->paint_num; ++c) {
            if (part.GetColor(c, color) == 0) {
                continue;
            }
            for (int j = 0; j < info->color_num; ++j) {
                if (EditPartsCmpColor(color, info->color[j]) != 0) {
                    info->paint_num[j] += map.RePaintNum(part.info->paint_used);
                    break;
                }
            }
        }
    }

    // The body of one retail call up to its own recursion; a call that recurses leaves a frame on the stack.
    int Enter(int index, const float *pos) {
        RemovalFrame frame;
        std::copy_n(pos, 4, frame.pos.begin());
        CEditParts *part = map.GetePlaceParts(index);
        if (part != nullptr) {
            if (info != nullptr && info->force == 0 && part->info != nullptr && (part->info->attr & EDIT_PARTS_ATR_NO_REMOVE) != 0) {
                return 0;
            }
            Count(part->GetInfoID());
            part->state = EDIT_PARTS_STATE_NONE;
            if (part->house != nullptr && part->house->npc_no[0] > 0 && info != nullptr) {
                auto &npcs = RemovedHouseNpcs();
                npcs.resize(static_cast<std::size_t>(info->house_num));
                npcs.push_back(part->house->npc_no[0]);
                info->house_npc = npcs.data();
                ++info->house_num;
            }
            RefundPaint(*part);
            map.DeleteEditParts(index);
            if (map.place_log_max == 0 || map.place_log == nullptr) {
                return 1;
            }
            frame.index = index;
            stack.push_back(frame);
            return 1;
        }
        if (map.RemoveRiver(frame.pos.data()) == 0) {
            return 0;
        }
        if (CEditPartsInfo *river = map.GetePartsInfoAtType(EDIT_PARTS_TYPE_RIVER)) {
            Count(river->id);
        }
        frame.river = true;
        stack.push_back(frame);
        return 1;
    }

    void Step() {
        RemovalFrame &frame = stack.back();
        if (frame.river) {
            StepRiver(frame);
        } else {
            StepPart(frame);
        }
    }

    // Retail's walk over every entry naming this slot, removing the parts resting on it under each one.
    void StepPart(RemovalFrame &frame) {
        const auto &own = by_part[frame.index];
        const auto &dependents = by_base[frame.index];
        while (frame.outer < own.size()) {
            const int     m = own[frame.outer];
            EditPlaceLog &entry = map.place_log[m];
            if (!frame.own_active) {
                if (entry.parts_no != static_cast<s16>(frame.index)) {
                    ++frame.outer;
                    continue;
                }
                frame.own_active = true;
                frame.inner = 0;
            }
            while (frame.inner < dependents.size()) {
                const int n = dependents[frame.inner++];
                if (n == m) {
                    continue;
                }
                const auto depth = stack.size();
                const auto pos = frame.pos;
                Enter(map.place_log[n].parts_no, pos.data());
                if (stack.size() != depth) {
                    return;
                }
            }
            map.place_log[m].parts_no = -1;
            frame.own_active = false;
            ++frame.outer;
        }
        stack.pop_back();
    }

    // Retail's walk over the slots after a river cell is removed, removing the parts it no longer carries.
    void StepRiver(RemovalFrame &frame) {
        while (std::cmp_less(frame.outer, map.edit_parts_max)) {
            const int   i = static_cast<int>(frame.outer++);
            CEditParts *candidate = &map.edit_parts[i];
            if (map.CheckNormalPlaceParts(candidate) == 0 || candidate->info == nullptr ||
                (candidate->info->attr & kRiverRelatedAttr) == 0) {
                continue;
            }
            float parts_pos[4];
            float parts_rot[4];
            candidate->GetPosition(parts_pos);
            candidate->GetRotation(parts_rot);
            if (map.CheckEditPartsOnRiver(candidate->info, parts_pos, parts_rot[1]) != 0) {
                continue;
            }
            const auto depth = stack.size();
            Enter(i, parts_pos);
            if (stack.size() != depth) {
                return;
            }
        }
        stack.pop_back();
    }
};

} // namespace

// Retail's removal without its recursion: a removed part takes every part resting on it, through the placement log,
// only when it has a log entry of its own; a river cell takes the river parts it carried.
int CEditMap::RemoveEditParts(int index, float *pos, RemoveInfo *remove_info) {
    if (remove_info != nullptr && remove_info->house_num == 0) {
        RemovedHouseNpcs().clear();
    }
    return Removal(*this, remove_info).Run(index, pos);
}

namespace {

/**
 * Builds an editor part table as FIX_EPARTS_START or INIT_EPARTS_START and their rows do.
 */
ePlaceData *PlaceTable(const SceneEditTable &table, mgCMemory *stack) {
    if (table.count <= 0) {
        return nullptr;
    }
    const u32 size = table.count * sizeof(ePlaceData);
    const int quadwords = static_cast<int>((size & 0xF) != 0 ? (size >> 4) + 1 : size >> 4);
    auto     *places = new (stack->Alloc(quadwords + 2)) ePlaceData[table.count];
    if (places == nullptr) {
        return nullptr;
    }
    int index = 0;
    for (const auto &part : table.parts) {
        if (index >= table.count) {
            break;
        }
        ePlaceData *entry = &places[index++];
        entry->id = part.id;
        std::memcpy(entry->position, part.position.data(), sizeof(entry->position));
        entry->angle = part.angle;
    }
    return places;
}

/**
 * Makes a hidden river, mask or water piece of a model, as the river tags do.
 */
CMapPiece *RiverPiece(CEditMap &map, const SceneText &model, mgCMemory *stack, int attributes, const mgCFrameAttr &attr) {
    auto       *piece = new (stack->Alloc(0xD)) CMapPiece;
    std::string name = model.value_or(std::string{});
    CMdsInfo   *mds = map.SearchMDS(model ? name.data() : nullptr);
    if (mds != nullptr) {
        piece->AssignMds(mds);
        if (piece->frame != nullptr) {
            mgCFrameAttr copy = attr;
            piece->frame->SetAttrParam(copy, 1, attributes);
        }
    }
    return piece;
}

} // namespace

void PortApplyEditMapConfig(CEditMap *map, char *script, int /*size*/, mgCMemory *stack) {
    const auto config = ReadSceneConfig(script);
    if (!config || !config->georama) {
        return;
    }
    const auto &georama = *config->georama;
    if (georama.fixed_parts) {
        if (ePlaceData *table = PlaceTable(*georama.fixed_parts, stack)) {
            map->info_mngr.SeteFixPartsTable(table, georama.fixed_parts->count);
        }
    }
    mgCFrameAttr hidden;
    hidden.obj_alpha = 0.0f;
    hidden.clip_enable = 1;
    hidden.alpha_ref = 0;
    hidden.z_write = MG_ZBUF_NO_WRITE;
    const int hidden_attributes = MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE | MG_FRAME_ATTR_CLIP | MG_FRAME_ATTR_OBJ_ALPHA;
    for (const auto &[index, parts, model] : georama.river_parts) {
        if (index < 0 || index >= EDIT_MAP_RIVER_PARTS_MAX) {
            continue;
        }
        std::string parts_name = parts.value_or(std::string{});
        map->river_parts[index] = map->GetParts(parts ? parts_name.data() : nullptr);
        map->river_piece[index] = RiverPiece(*map, model, stack, hidden_attributes, hidden);
    }
    for (const auto &model : georama.water_models) {
        mgCFrameAttr water;
        water.z_write = MG_ZBUF_NO_WRITE;
        water.clip_enable = 1;
        map->water_piece = RiverPiece(*map, model, stack, MG_FRAME_ATTR_Z_WRITE | MG_FRAME_ATTR_CLIP, water);
    }
    for (const auto &[index, model] : georama.mask_parts) {
        if (index < 0 || index >= EDIT_MAP_MASK_PIECE_MAX) {
            continue;
        }
        map->mask_piece[index] = RiverPiece(*map, model, stack, hidden_attributes, hidden);
    }
    if (georama.initial_parts) {
        if (ePlaceData *table = PlaceTable(*georama.initial_parts, stack)) {
            map->info_mngr.init_parts = table;
            map->info_mngr.init_parts_num = georama.initial_parts->count;
        }
    }
}
