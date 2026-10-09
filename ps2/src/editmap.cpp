#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "editdata.hpp"
#include "editmap.hpp"
#include "editriver.hpp"
#include "funcpoint.hpp"
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

const int kPartsInfoColorCountOffset = 0x1C;
const int kPartsInfoRepaintOffset = 0x20;
const int kPartsPolyAttrOffset = 0x48;
const int kRiverPolyFlag = 0x10;
const int kEditPartsPolyFlag = 0x1000;
const int kRiverHeightOffset = 0xFF8;
const int kMaxInfoId = 0x100;
const int kInfoFixedFlag = 0x1;
const int kInfoRiverRelatedFlag = 0x80000;
const int kRiverPartsType = 0xB;

extern EditVector     at_1837__2;
extern EditVector     at_426;

/**
 * Class name returned by the editor map object.
 */
static char *CEditMapName = "CEditMap";

/**
 * Editor map receiving script commands.
 */
static CEditMap * emapMap;

/**
 * Part-information manager receiving script commands.
 */
static CEditInfoMngr * emapInfo;

/**
 * Memory used by the editor map script.
 */
static mgCMemory * emapStack;

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
static ePlaceData * emapFix;

/**
 * Initial-part placements populated by the script.
 */
static ePlaceData * emapInit;

// Code (.text)
char *CEditMap::Iam() {
    return CEditMapName;
}

void CEditMap::Initialize() {
    int i;
    int offset;
    area_no = -1;
    edit_parts_max = 0;
    edit_parts = 0;
    (&parts_heap)->Init();
    place_log_max = 0;
    place_log = 0;

    river_parts[0] = 0;
    river_piece[0] = 0;
    river_parts[1] = 0;
    river_piece[1] = 0;
    river_parts[2] = 0;
    river_piece[2] = 0;
    river_parts[3] = 0;
    river_piece[3] = 0;
    river_parts[4] = 0;
    river_piece[4] = 0;
    river_parts[5] = 0;
    river_piece[5] = 0;
    river_parts[6] = 0;
    river_piece[6] = 0;
    river_parts[7] = 0;
    river_piece[7] = 0;
    water_piece = 0;
    river_info = 0;
    mask_piece[0] = 0;
    river_poly_margin = 0;
    grid_max = 4;
    i = 0;
    offset = 0;

    for (; i < grid_max; i++) {
        this->grid[i] = NULL;
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

        if (grid != 0) {
            grid->Clear();
        }
    }
}

void CEditMap::ClearHouse() {
    int house_no = 0;

    do {
        memset(&house[house_no], 0, sizeof(CEditHouse));
        house_no++;
    } while (house_no < EDIT_MAP_HOUSE_MAX);
}

#pragma global_optimizer off

void CEditMap::ClearAllParts() {
    int             i;
    int             log_offset;
    int             log_index;
    ePlaceData     *initial;
    CEditParts     *placed;
    int             initial_offset;
    int             k;
    float           rotation[4];
    CEditPartsInfo *info;
    (&parts_heap)->ClearHeapMem();
    i = 0;

    for (; i < edit_parts_max; i++) {
        edit_parts[i].Initialize();
    }

    log_index = 0;
    log_offset = 0;

    for (; log_index < place_log_max; log_index++) {
        *(s16 *) ((u8 *) place_log + log_offset) = -1;
        log_offset += 4;
    }

    ClearGrid();
    ClearHouse();
    k = 0;
    initial_offset = 0;

    for (; k < info_mngr.fix_parts_num; k++) {
        initial = (ePlaceData *) ((u8 *) info_mngr.fix_parts + initial_offset);
        *(EditVector *) rotation = at_426;
        rotation[1] = GetEditAngle(initial->angle);
        info = info_mngr.GetePartsInfoAtID(initial->id);
        placed = 0;

        if (info != 0) {
            placed = (CEditParts *) PlaceEditParts(info->edit_name, initial->position, rotation);
        }

        if (area_no == 1 && placed != 0) {
            CMapParts *anchor = NULL;

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

#pragma global_optimizer reset

void CEditMap::InitialPlaceParts(CEditData *data) {
    EP_PLACE_INFO   place_info;
    float           rotation[4];
    int             i;
    ePlaceData     *placement;
    CEditPartsInfo *info;

    if (data->save_count != 0) {
        return;
    }

    i = 0;

    for (; i < info_mngr.init_parts_num; i++) {
        placement = &info_mngr.init_parts[i];
        info = GetePartsInfoAtID(placement->id);

        if (info != 0) {
            mgZeroVector(rotation);
            rotation[1] = GetEditAngle(placement->angle);

            if (CheckEditParts(info, placement->position, rotation[1], &place_info)) {
                int built = BuildEditParts(placement->id);

                if (built >= 0) {
                    PlaceEditParts(built, &place_info, placement->position, rotation, 0);
                }
            } else {
                printf("init place err %d %s\n", i, info->edit_name);
            }
        }
    }
}

int CEditMap::GetPoly(int mode, CCPoly *polys, mgVu0FBOX &box, int max) {
    int         total;
    CEditParts *part;
    int         i;
    int         g;
    int         j;
    int         count;

    total = CMap::GetPoly(mode, polys, box, max);
    part = edit_parts;
    max -= total;
    polys += total;

    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = part->name[0] == 0;

        if (is_free) {
            continue;
        }

        if (part->state != 1) {
            continue;
        }

        count = part->GetPoly(mode, polys, box, max);

        for (j = 0; j < count; j++, polys++) {
            polys->parts_no = ((s16) (u16) i) | kEditPartsPolyFlag;
        }

        max -= count;
        total += count;

        if (max <= 0) {
            return total;
        }
    }

    if (mode == 1) {
        for (g = 0; g < grid_max; g++) {
            if (grid[g] != 0) {
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

inline CMapParts::CMapParts() { Initialize(); }

void CEditMap::CreateTable(mgCMemory *memory, int parts_max, int heap_size) {
    parts_heap.SetHeapMem(memory->Alloc(heap_size), heap_size);
    edit_parts_max = parts_max;
    u_int byte_count = sizeof(CEditParts) * edit_parts_max;
    int   parts_count = edit_parts_max;
    u_int quadwords = (byte_count & 15) ? (byte_count >> 4) + 1 : byte_count >> 4;
    edit_parts = new (memory->Alloc(quadwords + 2)) CEditParts[parts_count];
    place_log_max = parts_max * 4;
    byte_count = sizeof(EditPlaceLog) * place_log_max;
    quadwords = (byte_count & 15) ? (byte_count >> 4) + 1 : byte_count >> 4;
    place_log = new (memory->Alloc(quadwords + 2)) EditPlaceLog[place_log_max];
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
    CEditParts *placed;

    placed = GetePlaceParts(index);

    if (placed != NULL) {
        return placed->info;
    }

    return 0;
}

int CEditMap::eNewPlaceParts() {
    int i;

    for (i = 0; i < edit_parts_max; i++) {
        int is_free = edit_parts[i].name[0] == 0;

        if (is_free) {
            return i;
        }
    }

    return -2;
}

CEditHouse *CEditMap::eNewHouseInfo() {
    int i;

    for (i = 0; i < 0x20; i++) {
        if (house[i].active == 0) {
            return &house[i];
        }
    }

    return 0;
}

#pragma global_optimizer off

CEditParts *CEditMap::GetePlaceParts(int index) {
    if (index < 0) {
        return 0;
    }

    if (index < 0 || index >= edit_parts_max) {
        return 0;
    }

    return &edit_parts[index];
}

#pragma global_optimizer reset

CEditParts *CEditMap::GetePlaceParts(char *name) {
    int         i;
    CEditParts *slot;
    i = 0;

    for (; i < edit_parts_max; i++) {
        slot = &edit_parts[i];
        int is_free = slot->name[0] == 0;

        if (!is_free) {
            if (slot->state != 0) {
                if (slot->info != 0) {
                    CEditPartsInfo *info = slot->info;

                    if (info->parts_name != 0) {
                        if (strcmp(info->parts_name, name) == 0) {
                            return slot;
                        }
                    }
                }
            }
        }
    }

    return 0;
}

#pragma global_optimizer off

int CEditMap::GetePlaceIDList(int *out, int max) {
    int found = 0;
    int i = 0;
    int offset = 0;
    int out_offset = 0;

    for (; i < edit_parts_max; i++) {
        s8 *part = (s8 *) edit_parts + offset;
        int is_free = part[0x70] == 0;

        if (!is_free) {
            if (found >= max) {
                break;
            }

            found++;
            *(int *) ((u8 *) out + out_offset) = i;
            out_offset += 4;
        }

        offset += 0x330;
    }

    return found;
}

#pragma global_optimizer reset

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
    return mgAngleLimit(6.2831855f * (float) step / 24.0f);
}

int CEditMap::ConvEditAngle(float angle) {
    float steps;
    int   whole;

    if (angle < 0.0f) {
        angle += 6.2831855f;
    }

    steps = angle / 0.2617994f;
    whole = fptosi(steps);

    if (!(steps - (float) whole <= 0.5f)) {
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
        out[0] = (float) fptosi(0.01f + pos[0]);
    }

    if (pos[0] < 0.0f) {
        out[0] = (float) fptosi(pos[0] - 0.01f);
    }

    if (!(pos[1] < 0.0f)) {
        out[1] = (float) fptosi(0.01f + pos[1]);
    }

    if (pos[1] < 0.0f) {
        out[1] = (float) fptosi(pos[1] - 0.01f);
    }

    if (!(pos[2] < 0.0f)) {
        out[2] = (float) fptosi(0.01f + pos[2]);
    }

    if (pos[2] < 0.0f) {
        out[2] = (float) fptosi(pos[2] - 0.01f);
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
        return (float) fptosi(0.5f + altitude);
    }

    return (float) fptosi(altitude - 0.5f);
}

int CEditMap::GetGridPos(float *pos, float *river, float *out) {
    int        i;
    CEditGrid *grid;
    int        local[2];
    i = 0;

    for (; i < grid_max; i++) {
        grid = this->grid[i];

        if (grid != 0) {
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
    *(u_long128 *) matrix[3] = *(u_long128 *) pos;
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
    void       *info;
    int         i;

    if (target == 0) {
        return -1;
    }

    info = target->info;

    if (info == 0) {
        return -1;
    }

    for (i = 0; i < edit_parts_max; i++) {
        int is_free = edit_parts[i].name[0] == 0;

        if (!is_free) {
            if (edit_parts[i].state == 0) {
                if (edit_parts[i].info == info) {
                    return i;
                }
            }
        }
    }

    return -1;
}

int CEditMap::BuildEditParts(int id) {
    CEditPartsInfo *info;

    info = GetePartsInfoAtID(id);

    if (info != NULL) {
        return BuildEditParts(info->edit_name);
    }

    return -1;
}

int CEditMap::GetTotalPolyn(int *vertex_total, int *texture_total) {
    int             poly_total;
    int             vertex_sum;
    int             texture_sum;
    CEditParts     *part;
    int             i;
    int             river_count;
    CEditPartsInfo *info;
    i = 0;
    texture_sum = 0;
    vertex_sum = 0;
    part = edit_parts;
    poly_total = 0;

    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part)) {
            info = part->info;

            if (info != 0) {
                poly_total += info->polyn[0];
                vertex_sum += info->polyn[1];
                texture_sum += info->polyn[2];
            }
        }
    }

    float river_pos[4] = {0.0f, 0.0f, 0.0f, -1.0f};
    river_count = GetRiverNum(river_pos);
    info = GetePartsInfoAtType(0xB);

    if (info != 0) {
        texture_sum += river_count * info->polyn[2];
        vertex_sum += river_count * info->polyn[1];
        poly_total += river_count * info->polyn[0];
    }

    if (vertex_total != 0) {
        *vertex_total = vertex_sum;
    }

    if (texture_total != 0) {
        *texture_total = texture_sum;
    }

    return poly_total;
}

int CEditMap::BuildEditParts(char *name) {
    CEditPartsInfo *info = GetePartsInfo(name);

    if (info == NULL) {
        return EDIT_BUILD_NO_INFO;
    }

    int         index = eNewPlaceParts();
    CEditParts *part = GetePlaceParts(index);

    if (part == NULL) {
        return EDIT_BUILD_NO_SLOT;
    }

    CEditHouse *house = NULL;

    if (info->attr & EDIT_PARTS_ATR_TYPE_ONE) {
        house = eNewHouseInfo();

        if (house == NULL) {
            part->Initialize();
            return EDIT_BUILD_NO_HOUSE;
        }
    }

    CMapParts *model = GetParts(info->parts_name);

    if (model == NULL) {
        return EDIT_BUILD_NO_INFO;
    }

    u_long128 *memory = parts_heap.StartStackMode(MG_STACK_MODE_LARGEST, 0);

    if (memory == NULL || parts_heap.stGetRest() < 1000) {
        part->Initialize();
        parts_heap.EndStackMode();
        return EDIT_BUILD_NO_INFO;
    }

    model->Copy(*part, &parts_heap);
    parts_heap.EndStackMode();
    part->allocation_address = memory;
    part->info = info;
    part->SetPosition(0.0f, 0.0f, 0.0f);
    part->SetRotation(0.0f, 0.0f, 0.0f);
    part->SetScale(1.0f, 1.0f, 1.0f);
    part->CheckColorUpdate();

    if (house != NULL) {
        memset(house, 0, sizeof(CEditHouse));
        house->active = 1;
    }

    part->house = house;
    return index;
}

int CEditMap::DeleteEditParts(int index) {
    CEditParts *edit_parts = GetePlaceParts(index);

    if (edit_parts == 0) {
        return 0;
    }

    if (edit_parts->house != 0) {
        memset(edit_parts->house, 0, 0x10);
    }

    if (edit_parts->allocation_address != NULL) {
        parts_heap.Free(edit_parts->allocation_address);
    }

    edit_parts->Initialize();
    return 1;
}

int CEditMap::RemoveEditParts(int index, float *pos, RemoveInfo *remove_info_opaque) {
    RemoveInfo     *remove_info = remove_info_opaque;
    float           color[4];
    float           parts_pos[4];
    float           parts_rot[4];
    CEditParts     *candidate;
    CEditHouse     *house;
    int             id;
    int             n;
    EditPlaceLog   *other;
    CEditPartsInfo *candidate_info;
    int             c;
    CEditPartsInfo *river_info;
    int             j;
    int             m;
    CEditParts     *part;
    int             extra_value;
    int             i;
    EditPlaceLog   *entry;

    part = GetePlaceParts(index);

    if (part != 0) {
        if (remove_info != 0 && remove_info->force == 0) {
            if (part->info != 0 && (part->info->attr & kInfoFixedFlag)) {
                return 0;
            }
        }

        id = part->GetInfoID();
        part->state = 0;

        if (id >= 0 && id < kMaxInfoId && remove_info != 0) {
            remove_info->parts_num[id] += 1;
        }

        house = part->house;

        if (house != 0) {
            extra_value = house->npc_no[0];

            if (extra_value > 0 && remove_info != 0) {
                int slot = remove_info->house_num;
                remove_info->house_num = slot + 1;
                remove_info->house_npc[slot] = extra_value;
            }
        }

        if (remove_info != 0 && remove_info->color_num > 0) {
            if (part->IsFence() == 0) {
                for (c = 0; c < part->info->paint_num; c++) {
                    if (part->GetColor(c, color) != 0) {
                        for (j = 0; j < remove_info->color_num; j++) {
                            if (EditPartsCmpColor(color, remove_info->color[j]) != 0) {
                                remove_info->paint_num[j] += RePaintNum(part->info->paint_used);
                                break;
                            }
                        }
                    }
                }
            }
        }

        DeleteEditParts(index);

        if (place_log_max == 0 || (entry = place_log) == 0) {
            return 1;
        }

        for (m = 0; m < place_log_max; m++, entry++) {
            if ((s16) index == entry->parts_no) {
                other = place_log;

                for (n = 0; n < place_log_max; n++, other++) {
                    if (n != m && other->base_no == index) {
                        RemoveEditParts(other->parts_no, pos, remove_info_opaque);
                    }
                }

                entry->parts_no = -1;
            }
        }

        return 1;
    }

    if (RemoveRiver(pos) != 0) {
        river_info = GetePartsInfoAtType(kRiverPartsType);

        if (river_info != 0) {
            id = river_info->id;

            if (id >= 0 && id < kMaxInfoId && remove_info != 0) {
                remove_info->parts_num[id] += 1;
            }
        }

        candidate = edit_parts;

        for (i = 0; i < edit_parts_max; i++, candidate++) {
            if (CheckNormalPlaceParts(candidate) != 0) {
                candidate_info = candidate->info;

                if (candidate_info != 0 && (candidate_info->attr & kInfoRiverRelatedFlag)) {
                    candidate->GetPosition(parts_pos);
                    candidate->GetRotation(parts_rot);

                    if (CheckEditPartsOnRiver(candidate_info, parts_pos, parts_rot[1]) == 0) {
                        RemoveEditParts(i, parts_pos, remove_info_opaque);
                    }
                }
            }
        }

        return 1;
    }

    return 0;
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

#pragma global_optimizer off

int CEditMap::BurnEditParts(RemoveInfo *remove_info) {
    float           remove_pos[4] = {10000000.0f, 10000000.0f, 1000000000.0f, 1.0f};
    float           pos[4];
    float           rotation[4];
    EP_PLACE_INFO   place;
    int             placed_high;
    int             placed_low;
    CEditPartsInfo *high_info;
    CEditPartsInfo *low_info;
    CEditParts     *part;
    int             i;
    u32             flags;
    int             i2;
    CEditPartsInfo *replacement;
    CEditPartsInfo *info;
    int             replacement_id;
    int            *placed_count;
    CEditParts     *part2;
    high_info = info_mngr.GetePartsInfoAtID(0x57);
    low_info = info_mngr.GetePartsInfoAtID(0x56);

    if (high_info == 0 || low_info == 0) {
        return 0;
    }

    placed_high = GetePlacePartsAtInfoID(0x57, 0, 0);
    placed_low = GetePlacePartsAtInfoID(0x56, 0, 0);
    part = edit_parts;
    i = 0;

    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) != 0 && part->info != 0 &&
            (part->GetInfoID() == 0x57 || part->GetInfoID() == 0x56)) {
            RemoveEditParts(i, remove_pos, remove_info);
        }
    }

    part2 = edit_parts;
    i2 = 0;

    for (; i2 < edit_parts_max; i2++, part2++) {
        if (CheckNormalPlaceParts(part2) != 0) {
            info = part2->info;

            if (info != 0) {
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
                            PlaceEditParts(BuildEditParts(replacement_id), &place, pos, rotation, 0);
                            *placed_count += 1;
                        }
                    }
                }
            }
        }
    }

    return 1;
}

#pragma global_optimizer reset

CEditParts *CEditMap::PlaceEditParts(char *name, float *pos, float *rot) {
    CEditParts *edit_parts = GetePlaceParts(BuildEditParts(name));

    if (edit_parts == 0) {
        return 0;
    }

    edit_parts->state = 1;
    edit_parts->SetPosition(pos);
    edit_parts->SetRotation(rot);
    edit_parts->SetScale(1.0f, 1.0f, 1.0f);
    return edit_parts;
}

CEditParts *CEditMap::PlaceEditParts(int index, EP_PLACE_INFO *place, float *pos, float *rotation,
                                     int *same_index) {
    CEditParts     *edit_parts;
    CEditPartsInfo *info;
    edit_parts = GetePlaceParts(index);

    if (edit_parts == 0) {
        return 0;
    }

    info = edit_parts->info;

    if (info == 0) {
        return 0;
    }

    if (edit_parts->GetPartsType() != 0xB) {
        if (!CreatePlaceLog(index, place)) {
            return 0;
        }
    }

    if (area_no == 1) {
        if (place != 0) {
            CEditParts *other = GetePlaceParts(place->base[0]);

            if (other != 0) {
                edit_parts->ground = other->ground;
            }
        }
    }

    edit_parts->state = 1;

    if (same_index != 0) {
        *same_index = GetSameParts(index);
    }

    if (info->attr & 0x80) {
        if (CheckRiverParts(pos)) {
            PlaceRiver(pos);
            edit_parts->state = 2;
            edit_parts->SetPosition(0.0f, -10000.0f, 0.0f);
        } else {
            edit_parts->state = 0;
        }

        return 0;
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
    EditPlaceLog *slot;
    int           index;
    int           remaining;
    int           i;

    if (info == 0 || id < 0) {
        return 1;
    }

    if (place_log_max == 0 || place_log == 0) {
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
    CEditParts *part;
    int         i;
    int         count;
    float      *bounds;
    float      *info_bounds;

    if (info == 0) {
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

        if (part->state != 1) {
            continue;
        }

        if (part->info == 0) {
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
    int         i;
    int         count;
    CEditParts *part;
    float      *bounds;
    count = 0;
    part = edit_parts;

    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = part->name[0] == 0;

        if (is_free) {
            continue;
        }

        if (part->state != 1) {
            continue;
        }

        if (part->info == 0) {
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
    mgVu0FBOX   box;
    CEditParts *near[0x200];
    int         count;

    *(u_long128 *) box.max = *(u_long128 *) pos;
    *(u_long128 *) box.min = *(u_long128 *) pos;

    for (int i = 0; i < 3; i++) {
        box.max[i] += pos[3];
        box.min[i] -= pos[3];
    }

    count = GetNearParts(box, near, 0x200);
    return GetePlaceParts(pos, near, count);
}
int CEditMap::GetePlaceParts(sceVu0FVECTOR pos, CEditParts **parts, int num) {
    sceVu0FVECTOR point;
    float matrix[4][4];
    float inverse[4][4];
    float point_matrix[4][4];
    CCPoly square[2];
    sceVu0FVECTOR offset;
    sceVu0FVECTOR parts_pos;
    sceVu0FVECTOR parts_rot;
    float triangle[3][4];
    mgVu0FBOX overlap_box;
    float overlap_area;
    float radius;
    float best_top;
    int i;
    int j;
    CEditParts *best;

    *(u_long128 *)point = *(u_long128 *)pos;
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
    best = NULL;
    for (i = 0; i < num; i++) {
        CEditParts *part = parts[i];
        int unnamed = part->name[0] == 0;
        if (unnamed) {
            continue;
        }
        CEditPartsInfo *info = part->info;
        if (info == NULL || (info->attr & 4)) {
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
                    if (best == NULL || !(top <= best_top)) {
                        best = part;
                        best_top = top;
                    }
                }
            }
        }
    }
    int result = -1;
    if (best != NULL) {
        pos[1] = best_top;
        result = ConvertParts(best);
    }
    return result;
}
int CEditMap::CheckEditParts(CEditPartsInfo *info, float *pos, float radius, EP_PLACE_INFO *place) {
    CEditParts *near_parts[512];
    int         count;

    if (info == 0) {
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
    CEditParts *nearest;
    float part_area;
    float height_limit;
    float half_len;
    CEditParts *part;
    int line_part;
    float dist;
    int n;
    float height_gap;
    float gap_z;
    float nearest_dist;
    float gap_x;
    int angle;
    float rate;
    int relative_angle;
    CEditParts *flat_part;
    float flat_rate;
    CEditParts *touch_part;
    int flat_angle;
    int unnamed;
    CEditPartsInfo *part_info;
    int other_angle;
    float push_max_x;
    float part_half_len;
    int base_angle;
    int shift_angle;
    int near_count;
    float area;
    int part_angle;
    float push_min_x;
    float touch_rate;
    int angle_gap;
    float push_max_z;
    float push_min_z;
    int moved;
    float part_matrix[4][4];
    float rot_matrix[4][4];
    float matrix[4][4];

    if (info == NULL) {
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
    CEditParts *near_list[64];
    sceVu0FVECTOR flat_pos;
    sceVu0FVECTOR touch_pos;
    sceVu0ApplyMatrix(end[0], matrix, box.min);
    sceVu0ApplyMatrix(end[1], matrix, box.max);
    end[0][1] = 0.0f;
    end[1][1] = 0.0f;
    half_len = 0.5f * mgDistVector(box.max, box.min);
    near_count = 0;
    nearest = NULL;
    nearest_dist = 0.0f;
    flat_part = NULL;
    touch_part = NULL;
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
        if (part_info == NULL || !(part_info->attr & 0x10)) {
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
                    rate = mgAbs(part_info->col_floor.OverlapXZ(info->col_area1, relative, NULL) / area);
                    if (!(rate <= 0.01f) && (touch_part == NULL || !(rate <= touch_rate))) {
                        touch_part = part;
                        touch_rate = rate;
                        *(u_long128 *)touch_pos = *(u_long128 *)other_pos;
                    }
                    if (!(rate <= 0.6f) && (flat_part == NULL || !(rate <= flat_rate))) {
                        flat_part = part;
                        flat_rate = rate;
                        flat_angle = other_angle;
                        *(u_long128 *)flat_pos = *(u_long128 *)other_pos;
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
        if (nearest == NULL || dist < nearest_dist) {
            nearest = part;
            nearest_dist = dist;
        }
    }

    base_angle = 0;
    if (nearest == NULL && flat_part == NULL) {
        return 0;
    }
    if (nearest != NULL) {
        base_angle = ConvEditAngle(nearest->rotation[1]);
        angle_gap = AngleLimit(angle - base_angle);
    }
    if (flat_part != NULL) {
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
    if (flat_part != NULL) {
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
            *(u_long128 *)shift = *(u_long128 *)gap[0];
        } else {
            *(u_long128 *)shift = *(u_long128 *)gap[1];
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
    shift[0] = (int)shift[0];
    shift[2] = (int)shift[2];
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
    CEditParts::WallInfo wall;
    sceVu0FVECTOR        world_normal;
    float                base_matrix[4][4];
    float                wall_basis[4][4];
    sceVu0FVECTOR        local_pos;
    sceVu0FVECTOR        wall_plane;
    EditVector           up;
    float                wall_matrix[4][4];
    float                wall_inverse[4][4];
    float                swap_yz[4][4];
    sceVu0FVECTOR        poly_normal;
    float                triangle[3][4];
    float                place_matrix[4][4];
    float                other_matrix[4][4];
    float                other_inverse[4][4];
    float                covered_area;
    float                total;
    float                covered;
    CCPoly              *poly;
    int                  i;
    int                  count;

    if (info == NULL) {
        return 0;
    }

    CEditParts     *base = GetePlaceParts(base_no);
    CEditPartsInfo *base_info = base->info;

    if (base == NULL || base_info == NULL || !base->GetWallPlane(wall_no, &wall)) {
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
    *(u_long128 *) wall_basis[3] = *(u_long128 *) wall.center;
    wall_basis[3][3] = 1.0f;
    pos[3] = 1.0f;
    sceVu0ApplyMatrix(local_pos, wall_basis, pos);
    *(u_long128 *) wall_plane = *(u_long128 *) wall.plane;
    wall_plane[3] = 0.0f;
    sceVu0ApplyMatrix(world_normal, base_matrix, wall_plane);
    mgMulMatrix(base_matrix, base_matrix, wall_basis);
    sceVu0ApplyMatrix(pos, base_matrix, pos);
    pos[3] = GetEditAngle(ConvEditAngle(atan2f(world_normal[0], world_normal[2])));
    mgUnitMatrix(wall_matrix);
    *(u_long128 *) wall_matrix[1] = *(u_long128 *) wall_plane;
    wall_matrix[1][3] = 0.0f;
    wall_matrix[2][2] = 0.0f;
    wall_matrix[2][0] = 0.0f;
    wall_matrix[2][1] = 1.0f;
    sceVu0OuterProduct(wall_matrix[0], wall_matrix[1], wall_matrix[2]);
    *(u_long128 *) wall_matrix[3] = *(u_long128 *) local_pos;
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

        if (other_info == NULL) {
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

        float overlap = other_info->col_area3.OverlapXZ(info->col_area3, relative, NULL);
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
    CEditParts *part;
    int         i;
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
    CEditParts *part;
    int         total;
    int         light_b;
    int         i;
    int         channel;
    int         light_a;

    if (balance_moved != 0) {
        for (light_a = 0; light_a < 4; light_a++) {
            if (balance_parts[light_a] != 0) {
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

        if (!is_free && part->state == 1) {
            part->CopyFuncPointCheck(check);

            if (i == focus_parts) {
                float boost;
                mgGetAmbient(ambient);
                boost = 48.0f * (1.0f + sinf(6.2831855f * (float) (frame % 30) / 30.0f));

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
            if (balance_parts[light_b] != 0) {
                balance_parts[light_b]->SetPosition(balance_pos[light_b]);
            }
        }
    }

    return total;
}

/**
 *
 * Accepts the start of a scripted river parts section.
 *
 */
int emapEDIT_RIVER(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Loads a named river part and its map piece model.
 *
 */
#ifdef NONMATCHING
int emapRIVER_PARTS_NAME(SPI_STACK *stack, int argc) {
    int index = spiGetStackInt(stack++);

    if (index < 0 || index >= EDIT_MAP_RIVER_PARTS_MAX) {
        return 0;
    }

    char *parts_name = spiGetStackString(stack++);
    char *mds_name = spiGetStackString(stack);
    emapMap->river_parts[index] = emapMap->GetParts(parts_name);
    CMapPiece *piece;

    piece = new ((u_long128 *) emapStack->Alloc(0xD)) CMapPiece;

    emapMap->river_piece[index] = piece;
    CMdsInfo *mds = emapMap->SearchMDS(mds_name);

    if (mds != NULL) {
        mgCFrameAttr attr;
        attr.obj_alpha = 0.0f;
        attr.clip_enable = 1;
        attr.alpha_ref = 0;
        attr.z_write = -1;
        emapMap->river_piece[index]->AssignMds(mds);
        mgCFrame *frame = emapMap->river_piece[index]->frame;

        if (frame != NULL) {
            frame->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE | MG_FRAME_ATTR_CLIP | MG_FRAME_ATTR_OBJ_ALPHA);
        }
    }

    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", emapRIVER_PARTS_NAME__FP9SPI_STACKi);
#endif

/**
 *
 * Loads the map mask piece model.
 *
 */
#ifdef NONMATCHING
int emapMASK_PARTS_NAME(SPI_STACK *stack, int argc) {
    int index = spiGetStackInt(stack++);

    if (index < 0 || index > 0) {
        return 0;
    }

    char      *mds_name = spiGetStackString(stack);
    CMapPiece *piece;

    piece = new ((u_long128 *) emapStack->Alloc(0xD)) CMapPiece;

    emapMap->mask_piece[index] = piece;
    CMdsInfo *mds = emapMap->SearchMDS(mds_name);

    if (mds != NULL) {
        mgCFrameAttr attr;
        attr.obj_alpha = 0.0f;
        attr.clip_enable = 1;
        attr.alpha_ref = 0;
        attr.z_write = -1;
        emapMap->mask_piece[index]->AssignMds(mds);
        mgCFrame *frame = emapMap->mask_piece[index]->frame;

        if (frame != NULL) {
            frame->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE | MG_FRAME_ATTR_CLIP | MG_FRAME_ATTR_OBJ_ALPHA);
        }
    }

    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", emapMASK_PARTS_NAME__FP9SPI_STACKi);
#endif

/**
 *
 * Loads the map water piece model.
 *
 */
#ifdef NONMATCHING
int emapWATER_PARTS_NAME(SPI_STACK *stack, int argc) {
    CMdsInfo  *mds = emapMap->SearchMDS(spiGetStackString(stack));
    CMapPiece *piece;

    piece = new ((u_long128 *) emapStack->Alloc(0xD)) CMapPiece;

    emapMap->water_piece = piece;

    if (mds != NULL) {
        emapMap->water_piece->AssignMds(mds);
        mgCFrameAttr attr;
        attr.z_write = -1;
        attr.clip_enable = 1;

        if (emapMap->water_piece->frame != NULL) {
            emapMap->water_piece->frame->SetAttrParam(attr, 1, MG_FRAME_ATTR_Z_WRITE | MG_FRAME_ATTR_CLIP);
        }
    }

    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", emapWATER_PARTS_NAME__FP9SPI_STACKi);
#endif

/**
 *
 * Accepts the end of a scripted river parts section.
 *
 */
int emapEDIT_RIVER_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Allocates the fixed edit parts table from a script.
 *
 */
int emapFIX_EPARTS_START(SPI_STACK *stack, int argc) {
    int         count = spiGetStackInt(stack);
    u32         size;
    int         quadwords;
    ePlaceData *table;

    if (count <= 0) {
        return 0;
    }

    size = count * sizeof(ePlaceData);
    quadwords = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
    table = new (emapStack->Alloc(quadwords + 2)) ePlaceData[count];
    emapInfo->SeteFixPartsTable(table, count);
    emapFixNum = count;
    emapFix = table;
    emapFixIdx = 0;
    return 1;
}

/**
 *
 * Adds a fixed edit part with its position and angle.
 *
 */
int emapFIX_EPARTS(SPI_STACK *stack, int argc) {
    int         index = emapFixIdx;
    ePlaceData *entry;

    if (index < 0 || index >= emapFixNum) {
        return 0;
    }

    if (emapFix == 0) {
        return 0;
    }

    entry = emapFix + index;
    entry->id = spiGetStackInt(stack++);
    spiGetStackVector(entry->position, stack);
    entry->angle = spiGetStackInt(stack += 3);
    emapFixIdx++;
    return 1;
}

/**
 *
 * Ends the fixed edit parts table definition.
 *
 */
int emapFIX_EPARTS_END(SPI_STACK *stack, int argc) {
    emapFixNum = 0;
    emapFixIdx = 0;
    emapFix = 0;
    return 1;
}

/**
 *
 * Allocates the initial edit parts table from a script.
 *
 */
int emapINIT_EPARTS_START(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);
    u32 size;
    int quadwords;
    ePlaceData *table;

    if (count <= 0) {
        return 0;
    }

    size = count * sizeof(ePlaceData);
    quadwords = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
    table = new (emapStack->Alloc(quadwords + 2)) ePlaceData[count];
    emapInfo->init_parts = table;
    emapInfo->init_parts_num = count;
    emapInit = table;
    emapInitNum = count;
    emapInitIdx = 0;
    return 1;
}

/**
 *
 * Adds an initial edit part with its position and angle.
 *
 */
int emapINIT_EPARTS(SPI_STACK *stack, int argc) {
    int         index = emapInitIdx;
    ePlaceData *entry;

    if (index < 0 || index >= emapInitNum) {
        return 0;
    }

    if (emapInit == 0) {
        return 0;
    }

    entry = emapInit + index;
    entry->id = spiGetStackInt(stack++);
    spiGetStackVector(entry->position, stack);
    entry->angle = spiGetStackInt(stack += 3);
    emapInitIdx++;
    return 1;
}

/**
 *
 * Ends the initial edit parts table definition.
 *
 */
int emapINIT_EPARTS_END(SPI_STACK *stack, int argc) {
    emapInitNum = 0;
    emapInitIdx = 0;
    emapInit = 0;
    return 1;
}

int emapRIVER_PARTS_NAME(SPI_STACK *stack, int argc);
int emapWATER_PARTS_NAME(SPI_STACK *stack, int argc);
int emapMASK_PARTS_NAME(SPI_STACK *stack, int argc);

/**
 * Script tags that define fixed, initial and river editor parts.
 */
static SPI_TAG_PARAM emap_tag[] = {
    {"FIX_EPARTS_START", emapFIX_EPARTS_START},
    {"FIX_EPARTS", emapFIX_EPARTS},
    {"FIX_EPARTS_END", emapFIX_EPARTS_END},
    {"EDIT_RIVER", emapEDIT_RIVER},
    {"RIVER_PARTS_NAME", emapRIVER_PARTS_NAME},
    {"WATER_PARTS_NAME", emapWATER_PARTS_NAME},
    {"EDIT_RIVER_END", emapEDIT_RIVER_END},
    {"INIT_EPARTS_START", emapINIT_EPARTS_START},
    {"INIT_EPARTS", emapINIT_EPARTS},
    {"INIT_EPARTS_END", emapINIT_EPARTS_END},
    {"MASK_PARTS_NAME", emapMASK_PARTS_NAME},
    {NULL, NULL}
};

void CEditMap::LoadEditInfo(char *script, int size, mgCMemory *stack) {
    int has_river;
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
        CMapPiece     *piece = NULL;
        CColFrame     *col_frame = NULL;
        CCollisionMDT *collision = NULL;

        if (parts != NULL) {
            piece = parts->SearchPieceColType(MDS_TYPE_COLLISION);
        }

        if (piece != NULL) {
            col_frame = (CColFrame *) piece->frame;
        }

        if (col_frame != NULL) {
            collision = (CCollisionMDT *) col_frame->collision;
        }

        mgVu0FBOX extent;
        mgZeroVector(extent.max);
        mgZeroVector(extent.min);
        float area = 0.0f;
        info->place_anime = 2;

        if (collision != NULL) {
            CEditCollision source;
            float          matrix[4][4];
            collision->Copy(source, NULL);
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

        if (parts != NULL) {
            mgVu0FBOX bound;
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
                info->place_anime = 1;
            }

            sceVu0FVECTOR span;
            sceVu0SubVector(span, bound.max, bound.min);
            float span_x = span[0] < 0.0f ? -span[0] : span[0];
            float span_z = span[2] < 0.0f ? -span[2] : span[2];
            float radius;

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
            info->place_anime = 0;
        }

        if (info->attr & 0x200) {
            info->place_anime = 0;
        }

        if (parts != NULL && (info->attr & EDIT_PARTS_ATR_GROUND) == EDIT_PARTS_ATR_GROUND) {
            info->col_area3.Initialize();
            CList<CMapPiece> *node = parts->piece_list;
            mgCFrameAttr      frame_attr;
            frame_attr.dest_alpha_test = MG_DEST_ALPHA_TEST_ONE;

            for (; node != NULL; node = node->next) {
                CMapPiece *model = node->pGetData();

                if (model->type == MDS_TYPE_MODEL) {
                    mgCFrame *frame = model->frame;

                    if (frame != NULL) {
                        mgVu0FBOX grid_box;

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
    CScriptInterpreter interpreter;
    interpreter.SetTag(emap_tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
    river_info = new (emapStack->Alloc(0x142)) CEditPartsInfo[EDIT_MAP_RIVER_PARTS_MAX];

    for (int river = 0; river < EDIT_MAP_RIVER_PARTS_MAX; river++) {
        if (river_parts[river] != NULL) {
            CMapPiece *river_col = river_parts[river]->SearchPieceColType(MDS_TYPE_COLLISION);

            if (river_col != NULL) {
                CColFrame *river_frame = (CColFrame *) river_col->frame;

                if (river_frame != NULL) {
                    CCollisionMDT *river_collision = (CCollisionMDT *) river_frame->collision;
                    river_collision->Copy(river_info[river].col_floor, NULL);
                    river_collision->Copy(river_info[river].col_area1, NULL);
                }
            }
        }
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_1837__2__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_426, 0x10);
