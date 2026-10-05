#include "common.h"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include <cmath>
#include "scriptinterpreter.hpp"
#include <cstdio>
#include "funcpoint.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "editdata.hpp"
#include "editriver.hpp"
#include "editmap.hpp"
#include <cstring>

union EditVector {
    float values[4];
    u_long128 quad;
};

extern "C" int fptosi(float value);

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

extern char at_449[];
extern char at_450[];
extern char at_451[];
extern char at_452[];
extern char at_474__2[];

extern "C" void Initialize__4CMapFv(void *self);
extern "C" int GetPlaceParts__4CMapFPc(void *map, char *name);
extern "C" void Free__9mgCMemoryFP1(void *memory, void *block);
extern "C" void Step__4CMapFv(...);
extern "C" void PreDraw__4CMapFPf(void *self, float *pos);
struct EditFuncCheck {
    float time;
    int anime_frame;
};
extern "C" void CreateFuncCheck__4CMapFP15CFuncPointCheck(void *self, EditFuncCheck *check);
extern "C" void StepFuncPoint__9CMapPartsFR15CFuncPointCheck(CMapParts *self, EditFuncCheck &check);
extern "C" void CopyFuncPointCheck__9CMapPartsFR15CFuncPointCheck(CMapParts *self, EditFuncCheck &check);
extern "C" void DrawSub__4CMapFi(void *map, int mode);
extern char *CEditMapName;
extern int emapInit;
extern int emapInitIdx;
extern int emapInitNum;
extern mgCMemory *emapStack;
extern CEditInfoMngr *emapInfo;
extern int emapFixNum;
extern int emapFix;
extern int emapFixIdx;
extern EditVector at_426;
extern "C" int GetPoly__4CMapFiP6CCPolyR9mgVu0FBOXi(void *map, int kind, CCPoly *polys,
                                                    mgVu0FBOX &box, int max);
extern "C" int GetRiverPoly__9CEditGridFP6CCPolyRC9mgVu0FBOXif(CEditGrid *grid, CCPoly *polys,
                                                               const mgVu0FBOX &box, int max,
                                                               float height);
extern EditVector at_830__3;
extern "C" int RePaintNum__8CEditMapFi(void *self, int count);
extern EditVector at_988;
extern "C" void mgCreateMatrixPY__FPA4_fPff(float (*matrix)[4], float *pos, float angle);
extern "C" void mgApplyMatrix__FPfPfPA4_fPfPf(float *outA, float *outB, float (*matrix)[4], float *inA,
                                              float *inB);

// Code (.text)
char *CEditMap::Iam(void) {
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
        *(int *)((u8 *)this + offset + 0xF54) = 0;
        offset += 4;
    }
    ClearHouse();
    focus_parts = -1;
    frame = 0;
    balance_moved = 0;
    Initialize__4CMapFv(this);
}
#pragma global_optimizer off
void CEditMap::ClearGrid() {
    int i = 0;
    int offset = 0;
    for (; i < grid_max; i++) {

        CEditGrid *grid = *(CEditGrid **)((u8 *)this + offset + 0xF54);
        if (grid != 0) {
            grid->Clear();
        }
        offset += 4;
    }
}
#pragma global_optimizer reset
void CEditMap::ClearHouse(void) {
    int house_no = 0;
    do {
        memset(&house[house_no], 0, sizeof(CEditHouse));
        house_no++;
    } while (house_no < EDIT_MAP_HOUSE_MAX);
}
#pragma global_optimizer off
void CEditMap::ClearAllParts() {
    int i;
    int offset;
    int log_offset;
    int log_index;
    ePlaceData *initial;
    CEditParts *placed;
    int initial_offset;
    int k;
    float rotation[4];
    CEditPartsInfo *info;
    (&parts_heap)->ClearHeapMem();
    i = 0;
    offset = 0;
    for (; i < edit_parts_max; i++) {
        ((CEditParts *)((u8 *)edit_parts + offset))->Initialize();
        offset += 0x330;
    }
    log_index = 0;
    log_offset = 0;
    for (; log_index < place_log_max; log_index++) {
        *(s16 *)((u8 *)place_log + log_offset) = -1;
        log_offset += 4;
    }
    ClearGrid();
    ClearHouse();
    k = 0;
    initial_offset = 0;
    for (; k < info_mngr.fix_parts_num; k++) {
        initial = (ePlaceData *)((u8 *)info_mngr.fix_parts + initial_offset);
        *(EditVector *)rotation = at_426;
        rotation[1] = GetEditAngle(initial->angle);
        info = info_mngr.GetePartsInfoAtID(initial->id);
        placed = 0;
        if (info != 0) {
            placed = (CEditParts *)PlaceEditParts(info->edit_name, initial->position, rotation);
        }
        if (area_no == 1 && placed != 0) {
            int anchor = 0;
            switch (k) {
                case 0:
                    anchor = GetPlaceParts__4CMapFPc(this, at_449);
                    break;
                case 1:
                    anchor = GetPlaceParts__4CMapFPc(this, at_450);
                    break;
                case 2:
                    anchor = GetPlaceParts__4CMapFPc(this, at_451);
                    break;
                case 3:
                    anchor = GetPlaceParts__4CMapFPc(this, at_452);
                    break;
            }
            placed->ground = (CMapParts *)anchor;
        }
        initial_offset += 0x20;
    }
    focus_parts = -1;
    frame = 0;
}
#pragma global_optimizer reset
void CEditMap::InitialPlaceParts(CEditData *data) {
    EP_PLACE_INFO place_info;
    float rotation[4];
    int i;
    ePlaceData *placement;
    CEditPartsInfo *info;
    int offset;
    if (data->save_count != 0) {
        return;
    }
    i = 0;
    offset = 0;
    for (; i < info_mngr.init_parts_num; i++) {
        placement = (ePlaceData *)((char *)info_mngr.init_parts + offset);
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
                printf(at_474__2, i, info->edit_name);
            }
        }
        offset += 0x20;
    }
}
int CEditMap::GetPoly(int mode, CCPoly *polys, mgVu0FBOX &box, int max) {
    int total;
    CEditParts *part;
    int i;
    int g;
    int j;
    int count;

    total = GetPoly__4CMapFiP6CCPolyR9mgVu0FBOXi(this, mode, polys, box, max);
    part = edit_parts;
    max -= total;
    polys += total;
    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = *(signed char *)((u_char *)part + 0x70) == 0;
        if (is_free) {
            continue;
        }
        if (part->state != 1) {
            continue;
        }
        count = ((CMapParts *)part)->GetPoly(mode, polys, box, max);
        for (j = 0; j < count; j++, polys++) {
            polys->parts_no = ((s16)(u16)i) | kEditPartsPolyFlag;
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
                count = GetRiverPoly__9CEditGridFP6CCPolyRC9mgVu0FBOXif(
                    grid[g], polys, box, max, river_poly_margin);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", CreateTable__8CEditMapFP9mgCMemoryii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", __ct__10CEditPartsFv);
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
        int is_free = *(signed char *)((u_char *)&edit_parts[i] + 0x70) == 0;
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
    int i;
    CEditParts *slot;
    int offset;
    offset = 0;
    i = 0;
    for (; i < edit_parts_max; i++) {
        slot = (CEditParts *)((char *)edit_parts + offset);
        int is_free = *(signed char *)((u_char *)slot + 0x70) == 0;
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
        offset += 0x330;
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
        s8 *part = (s8 *)edit_parts + offset;
        int is_free = part[0x70] == 0;
        if (!is_free) {
            if (found >= max) {
                break;
            }
            found++;
            *(int *)((u8 *)out + out_offset) = i;
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
    return mgAngleLimit(6.2831855f * (float)step / 24.0f);
}
int CEditMap::ConvEditAngle(float angle) {
    float steps;
    int whole;
    if (angle < 0.0f) {
        angle += 6.2831855f;
    }
    steps = angle / 0.2617994f;
    whole = fptosi(steps);
    if (!(steps - (float)whole <= 0.5f)) {
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
        out[0] = (float)fptosi(0.01f + pos[0]);
    }
    if (pos[0] < 0.0f) {
        out[0] = (float)fptosi(pos[0] - 0.01f);
    }
    if (!(pos[1] < 0.0f)) {
        out[1] = (float)fptosi(0.01f + pos[1]);
    }
    if (pos[1] < 0.0f) {
        out[1] = (float)fptosi(pos[1] - 0.01f);
    }
    if (!(pos[2] < 0.0f)) {
        out[2] = (float)fptosi(0.01f + pos[2]);
    }
    if (pos[2] < 0.0f) {
        out[2] = (float)fptosi(pos[2] - 0.01f);
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
        return (float)fptosi(0.5f + altitude);
    }
    return (float)fptosi(altitude - 0.5f);
}
int CEditMap::GetGridPos(float *pos, float *river, float *out) {
    int i;
    CEditGrid *grid;
    int offset;
    int local[2];
    offset = 0;
    i = 0;
    for (; i < grid_max; i++) {
        grid = *(CEditGrid **)((u8 *)this + offset + 0xF54);
        if (grid != 0) {
            if (grid->GetLPos(local, pos[0], pos[2])) {
                grid->GetRiverPos(local[0], local[1], river);
                out[0] = grid->step_x;
                out[1] = 0.0f;
                out[2] = grid->step_z;
                return 1;
            }
        }
        offset += 4;
    }
    return 0;
}
void CEditMap::GetMatrix(float (*matrix)[4], float *pos, int step) {
    GetRotMatrix(matrix, step);
    *(u_long128 *)matrix[3] = *(u_long128 *)pos;
    matrix[3][3] = 1.0f;
}
void CEditMap::GetInversMatrix(float (*a)[4], float (*b)[4]) {
    sceVu0InversMatrix(a, b);
}
int CEditMap::ConvertParts(CEditParts *part) {
    return ((int)part - (int)edit_parts) / 816;
}
int CEditMap::GetSameParts(int index) {
    CEditParts *target = GetePlaceParts(index);
    void *info;
    int i;
    int offset;
    if (target == 0) {
        return -1;
    }
    info = target->info;
    if (info == 0) {
        return -1;
    }
    i = 0;
    offset = 0;
    for (; i < edit_parts_max; i++) {
        CEditParts *slot = (CEditParts *)((char *)edit_parts + offset);
        int is_free = *(signed char *)((u_char *)slot + 0x70) == 0;
        if (!is_free) {
            if (slot->state == 0) {
                if (slot->info == info) {
                    return i;
                }
            }
        }
        offset += 0x330;
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
    int poly_total;
    int vertex_sum;
    int texture_sum;
    CEditParts *part;
    int i;
    int river_count;
    CEditPartsInfo *info;
    float river_pos[4];
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
    *(EditVector *)river_pos = at_830__3;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", BuildEditParts__8CEditMapFPc);
int CEditMap::DeleteEditParts(int index) {
    CEditParts *edit_parts = GetePlaceParts(index);
    if (edit_parts == 0) {
        return 0;
    }
    if (edit_parts->house != 0) {
        memset(edit_parts->house, 0, 0x10);
    }
    if (edit_parts->unk_320 != 0) {
        parts_heap.Free((u_long128 *)edit_parts->unk_320);
    }
    edit_parts->Initialize();
    return 1;
}
int CEditMap::RemoveEditParts(int index, float *pos, RemoveInfo *remove_info_opaque) {
    RemoveInfo *remove_info = remove_info_opaque;
    float color[4];
    float parts_pos[4];
    float parts_rot[4];
    CEditParts *candidate;
    int *extra;
    int id;
    int n;
    EditPlaceLog *other;
    CEditPartsInfo *candidate_info;
    int color_offset;
    int c;
    CEditPartsInfo *river_info;
    int j;
    int m;
    CEditParts *part;
    int extra_value;
    int i;
    EditPlaceLog *entry;

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
        extra = (int *)part->house;
        if (extra != 0) {
            extra_value = extra[1];
            if (extra_value > 0 && remove_info != 0) {
                int slot = remove_info->house_num;
                remove_info->house_num = slot + 1;
                remove_info->house_npc[slot] = extra_value;
            }
        }
        if (remove_info != 0 && remove_info->color_num > 0) {
            if (part->IsFence() == 0) {
                for (c = 0; c < part->info->paint_num; c++) {
                    if (((CMapParts *)part)->GetColor(c, color) != 0) {
                        for (j = 0, color_offset = 0; j < remove_info->color_num;
                             color_offset += 0x10, j++) {
                            if (EditPartsCmpColor(
                                    color, (float *)((u8 *)remove_info->color + color_offset)) != 0) {
                                remove_info->paint_num[j] += RePaintNum__8CEditMapFi(
                                    this, part->info->paint_used);
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
            if ((s16)index == entry->parts_no) {
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
    int i = 0;
    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) && part->IsBurn()) {
            return 1;
        }
    }
    return 0;
}
#pragma global_optimizer off
int CEditMap::BurnEditParts(RemoveInfo *remove_info) {
    float remove_pos[4];
    float pos[4];
    float rotation[4];
    EP_PLACE_INFO place;
    int placed_high;
    int placed_low;
    CEditPartsInfo *high_info;
    CEditPartsInfo *low_info;
    CEditParts *part;
    int i;
    u32 flags;
    int i2;
    CEditPartsInfo *replacement;
    CEditPartsInfo *info;
    int replacement_id;
    int *placed_count;
    CEditParts *part2;
    *(EditVector *)remove_pos = at_988;
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
                            CheckEditParts((CEditPartsInfo *)replacement, pos, rotation[1],
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
    CEditParts *edit_parts;
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
            CEditParts *other = GetePlaceParts(((int *)place)[1]);
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
    int index;
    int remaining;
    int i;
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
    float area_matrix[4][4];
    float part_matrix[4][4];
    float area_max[4];
    float area_min[4];
    float part_max[4];
    float part_min[4];
    float part_pos[4];
    float part_rotation[4];
    CEditParts *part;
    int i;
    int count;
    float *bounds;
    int out_offset;
    float *info_bounds;
    if (info == 0) {
        return 0;
    }
    part = edit_parts;
    mgCreateMatrixPY__FPA4_fPff(area_matrix, pos, angle);
    ((float *)info)[0x6C / 4] = 1.0f;
    ((float *)info)[0x5C / 4] = 1.0f;
    info_bounds = (float *)((u8 *)info + 0x50);
    mgApplyMatrix__FPfPfPA4_fPfPf(area_max, area_min, area_matrix, info_bounds, info_bounds + 4);
    area_max[0] += 55.0f;
    area_max[2] += 55.0f;
    area_min[0] -= 55.0f;
    area_min[2] -= 55.0f;
    count = 0;
    i = 0;
    out_offset = 0;
    for (; i < edit_parts_max; i++, part++) {
        int is_free = *(signed char *)((u_char *)part + 0x70) == 0;
        if (is_free) {
            continue;
        }
        if (part->state != 1) {
            continue;
        }
        if (part->info == 0) {
            continue;
        }
        bounds = (float *)((u8 *)part->info + 0x50);
        part->GetPosition(part_pos);
        part->GetRotation(part_rotation);
        mgCreateMatrixPY__FPA4_fPff(part_matrix, part_pos, part_rotation[1]);

        mgApplyMatrix__FPfPfPA4_fPfPf(part_max, part_min, part_matrix, bounds, bounds + 4);
        if (!(count < max)) {
            break;
        }
        count++;
        *(CEditParts **)((u8 *)out + out_offset) = part;
        out_offset += 4;
    }
    return count;
}
int CEditMap::GetNearParts(mgVu0FBOX &box, CEditParts **out, int max) {
    float matrix[4][4];
    float world_max[4];
    float world_min[4];
    float pos[4];
    float rotation[4];
    int i;
    int count;
    CEditParts *part;
    float *bounds;
    int out_offset;
    count = 0;
    out_offset = 0;
    part = edit_parts;
    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = *(signed char *)((u_char *)part + 0x70) == 0;
        if (is_free) {
            continue;
        }
        if (part->state != 1) {
            continue;
        }
        if (part->info == 0) {
            continue;
        }
        bounds = (float *)((u8 *)part->info + 0x50);
        part->GetPosition(pos);
        part->GetRotation(rotation);
        mgCreateMatrixPY__FPA4_fPff(matrix, pos, rotation[1]);
        mgApplyMatrix__FPfPfPA4_fPfPf(world_max, world_min, matrix, bounds, bounds + 4);
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
        count++;
        *(CEditParts **)((u8 *)out + out_offset) = part;
        out_offset += 4;
    }
    return count;
}
int CEditMap::GetePlaceParts(float *pos) {
    mgVu0FBOX box;
    CEditParts *near[0x200];
    int count;

    *(u_long128 *)box.max = *(u_long128 *)pos;
    *(u_long128 *)box.min = *(u_long128 *)pos;
    for (int i = 0; i < 3; i++) {
        box.max[i] += pos[3];
        box.min[i] -= pos[3];
    }
    count = GetNearParts(box, near, 0x200);
    return GetePlaceParts(pos, near, count);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", GetePlaceParts__8CEditMapFPfPP10CEditPartsi);
int CEditMap::CheckEditParts(CEditPartsInfo *info, float *pos, float radius, EP_PLACE_INFO *place) {
    CEditParts *near_parts[512];
    int count;
    if (info == 0) {
        return 0;
    }
    count = GetNearParts(info, pos, radius, near_parts, 512);
    return CheckEditParts(info, pos, radius, place, near_parts, count);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", GetEditPartsAlt__8CEditMapFP14CEditPartsInfoPff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", MagnetParts__8CEditMapFP14CEditPartsInfoPfPfPP10CEditPartsi);
int CEditMap::MagnetParts(CEditPartsInfo *info, float *pos, float *magnet) {
    CEditParts *near_parts[512];
    int count = GetNearParts(info, pos, magnet[0], near_parts, 512);
    return MagnetParts(info, pos, magnet, near_parts, count);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", CheckWallEditParts__8CEditMapFP14CEditPartsInfoPfiiP13EP_PLACE_INFO);
void CEditMap::Step() {
    frame += 1;
    Step__4CMapFv(this);
}
int CEditMap::PreDraw(float *pos) {
    EditFuncCheck check;
    CEditParts *part;
    int i;
    PreDraw__4CMapFPf(this, pos);
    check.time = 0;
    CreateFuncCheck__4CMapFP15CFuncPointCheck(this, &check);
    part = edit_parts;
    for (i = 0; i < edit_parts_max; i++, part++) {
        int is_free = *(signed char *)((u_char *)part + 0x70) == 0;
        if (!is_free) {
            StepFuncPoint__9CMapPartsFR15CFuncPointCheck((CMapParts *)part, check);
        }
    }
    return 1;
}
int CEditMap::DrawSub(int mode) {
    float ambient[4];
    float pulsed[4];
    EditFuncCheck check;
    CEditParts *part;
    int total;
    int light_b;
    int i;
    int channel;
    int light_a;
    if (balance_moved != 0) {
        for (light_a = 0; light_a < 4; light_a++) {
            if (balance_parts[light_a] != 0) {
                balance_parts[light_a]->SetPosition(balance_base_pos[light_a]);
            }
        }
    }
    check.time = 0;
    CreateFuncCheck__4CMapFP15CFuncPointCheck(this, &check);
    part = edit_parts;
    total = 0;
    i = 0;
    for (; i < edit_parts_max; i++, part++) {
        int is_free = *(signed char *)((u_char *)part + 0x70) == 0;
        if (!is_free && part->state == 1) {
            CopyFuncPointCheck__9CMapPartsFR15CFuncPointCheck((CMapParts *)part, check);
            if (i == focus_parts) {
                float boost;
                mgGetAmbient(ambient);
                boost = 48.0f * (1.0f + sinf(6.2831855f * (float)(frame % 30) / 30.0f));
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
    DrawSub__4CMapFi(this, mode);
    if (balance_moved != 0) {
        for (light_b = 0; light_b < 4; light_b++) {
            if (balance_parts[light_b] != 0) {
                balance_parts[light_b]->SetPosition(balance_pos[light_b]);
            }
        }
    }
    return total;
}
int emapEDIT_RIVER(SPI_STACK *stack, int argc) {
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", emapRIVER_PARTS_NAME__FP9SPI_STACKi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", emapMASK_PARTS_NAME__FP9SPI_STACKi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", emapWATER_PARTS_NAME__FP9SPI_STACKi);
int emapEDIT_RIVER_END(SPI_STACK *stack, int argc) {
    return 1;
}
int emapFIX_EPARTS_START(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);
    u32 size;
    int quadwords;
    ePlaceData *table;
    if (count <= 0) {
        return 0;
    }

    size = count * sizeof(ePlaceData);
    quadwords = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
    table = new ((u_long128 *)emapStack->Alloc(quadwords + 2)) ePlaceData[count];
    emapInfo->SeteFixPartsTable(table, count);
    emapFixNum = count;
    emapFix = (int)table;
    emapFixIdx = 0;
    return 1;
}
int emapFIX_EPARTS(SPI_STACK *stack, int argc) {
    int index = emapFixIdx;
    ePlaceData *entry;
    if (index < 0 || index >= emapFixNum) {
        return 0;
    }
    if (emapFix == 0) {
        return 0;
    }
    entry = (ePlaceData *)emapFix + index;
    entry->id = spiGetStackInt(stack++);
    spiGetStackVector(entry->position, stack);
    entry->angle = spiGetStackInt(stack += 3);
    emapFixIdx++;
    return 1;
}
int emapFIX_EPARTS_END(SPI_STACK *stack, int argc) {
    emapFixNum = 0;
    emapFixIdx = 0;
    emapFix = 0;
    return 1;
}
int emapINIT_EPARTS_START(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);
    u32 size;
    int quadwords;
    int table;
    if (count <= 0) {
        return 0;
    }

    size = count * sizeof(ePlaceData);
    quadwords = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
    table = (int) new ((u_long128 *)emapStack->Alloc(quadwords + 2)) ePlaceData[count];
    emapInfo->init_parts = (ePlaceData *)table;
    emapInfo->init_parts_num = count;
    emapInit = table;
    emapInitNum = count;
    emapInitIdx = 0;
    return 1;
}
int emapINIT_EPARTS(SPI_STACK *stack, int argc) {
    int index = emapInitIdx;
    ePlaceData *entry;
    if (index < 0 || index >= emapInitNum) {
        return 0;
    }
    if (emapInit == 0) {
        return 0;
    }
    entry = (ePlaceData *)emapInit + index;
    entry->id = spiGetStackInt(stack++);
    spiGetStackVector(entry->position, stack);
    entry->angle = spiGetStackInt(stack += 3);
    emapInitIdx++;
    return 1;
}
int emapINIT_EPARTS_END(SPI_STACK *stack, int argc) {
    emapInitNum = 0;
    emapInitIdx = 0;
    emapInit = 0;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", LoadEditInfo__8CEditMapFPciP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap", __ct__14CEditPartsInfoFv);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_830__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_988__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_1837__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", emap_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2257__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2278__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_346__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_449__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_450__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_451__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_452__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_474__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2072__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2073__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2074__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2075__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2076__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2077__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2078__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2079__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2080__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2081__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", at_2082__2__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", __vt__14CEditCollision__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", __vt__8CEditMap__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap", CEditMapName__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(emapMap, 0x4);
INCLUDE_BSS(emapInfo, 0x4);
INCLUDE_BSS(emapStack, 0x4);
INCLUDE_BSS(emapIdx, 0x4);
INCLUDE_BSS(emapNowInfo, 0x4);
INCLUDE_BSS(emapRect, 0x4);
INCLUDE_BSS(emapRectNum, 0x4);
INCLUDE_BSS(emapRectIdx, 0x4);
INCLUDE_BSS(emapFixNum, 0x4);
INCLUDE_BSS(emapInitNum, 0x4);
INCLUDE_BSS(emapFixIdx, 0x4);
INCLUDE_BSS(emapInitIdx, 0x4);
INCLUDE_BSS(emapFix, 0x4);
INCLUDE_BSS(emapInit, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_426, 0x10);
