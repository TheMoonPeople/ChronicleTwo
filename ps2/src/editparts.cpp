#include "common.h"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "editparts.hpp"
#include "mdslist.hpp"

extern "C" int fptosi(float value);

const int kPartsInfoWallValueOffset = 0x1A4;
const int kFenceEndAOffset = 0xA0;
const int kFenceEndBOffset = 0xB0;
const int kFenceFlagOffset = 0x230;
const int kTerritoryCenterOffset = 0x260;
const int kTerritoryRadiusOffset = 0x270;
const int kTerritoryHeightOffset = 0x274;
const int kNoTerritoryFlags = 0xAC2;

union EditPartsPosition {
    float f[4];
    u_long128 qw;
};
extern EditPartsPosition at_418;

// Code (.text)
void CEditPartsInfo::Initialize() {
    id = -999;
    attr = 0;
    edit_name = 0;
    comment = 0;
    parts_name = 0;
    parts = 0;
    place_anime = 0;
    bury_depth = 0;
    col_area1.Initialize();
    col_floor.Initialize();
    col_wall.Initialize();
    col_area3.Initialize();
    wall_group_num = 0;
    cpoint[0] = 0;
    cpoint[1] = 0;
    weight = 0;
    geo_stone = -1;
    max_num = 0;
    material[0].num = 0;
    material[0].item_no = 0;
    material[1].num = 0;
    material[1].item_no = 0;
    material[2].num = 0;
    material[2].item_no = 0;
    material[3].num = 0;
    material[3].item_no = 0;
    paint_num = 0;
    paint_used = 0;
    parts_type = 0;
    map_no = -1;
    polyn[0] = 0;
    polyn[1] = 0;
    polyn[2] = 0;
    place_eps = 0;
}
int CEditPartsInfo::GetPartsType(void) {
    if (attr & EDIT_PARTS_ATR_TYPE_ONE) {
        return 1;
    }
    if (attr & EDIT_PARTS_ATR_RIVER) {
        return EDIT_PARTS_TYPE_RIVER;
    }
    return parts_type;
}
void CEditPartsInfo::CreateBox() {
    float corner0[4];
    float corner1[4];
    *(u_long128 *)box.max = *(u_long128 *)corner0;
    box.max[3] = 1.0f;
    *(u_long128 *)box.min = *(u_long128 *)corner1;
    box.min[3] = 1.0f;
}
float CEditPartsInfo::GetPartsHeight() {
    return box.max[1] - box.min[1];
}
float CEditPartsInfo::GetPartsMaxWidth() {
    float num_x = box.max[0] - box.min[0];
    float num_z = box.max[1] - box.min[1];
    float depth = box.max[2] - box.min[2];
    if (num_x > num_z) {
        if (num_x > depth) {
            return num_x;
        }
        return depth;
    }
    if (num_z > depth) {
        return num_z;
    }
    return depth;
}
EditPartsMaterial *CEditPartsInfo::GetMaterial(int index) {
    if (index < 0 || index >= 4) {
        return 0;
    }
    return &material[index];
}
int CEditPartsInfo::GetDefColor(int index, float *color) {
    CMapParts *parts;

    parts = this->parts;
    if (parts == NULL) {
        return 0;
    }
    return parts->GetDefColor(index, color);
}
int CEditHouse::LiveChara() {
    int i;

    for (i = 0; i < 3; i++) {
        if (npc_no[i] > 0) {
            return 1;
        }
    }
    return 0;
}
void CEditParts::Initialize() {
    piece_list = 0;
    anime_list = 0;
    info = 0;
    state = 0;
    house = 0;
    ground = 0;
    max_material_num = 0;
    CMapParts::Initialize();
}
float StandardPos(float pos) {
    if (pos > 0.0f) {
        return (float)fptosi(0.001f + pos);
    }
    return (float)fptosi(pos - 0.001f);
}
void CEditParts::SetPosition(float *pos) {
    if (ground == 0) {
        mgCObject::SetPosition(pos);
    } else {
        float offset[4];
        float local[4];
        ground->GetPosition(offset);
        *(u_long128 *)local = *(u_long128 *)pos;
        local[1] -= StandardPos(offset[1]);
        mgCObject::SetPosition(local);
    }
}
void CEditParts::SetPosition(float x, float y, float z) {
    float pos[4];
    *(EditPartsPosition *)pos = at_418;
    pos[0] = x;
    pos[1] = y;
    pos[2] = z;
    ((mgCObject *)this)->SetPosition(pos);
}
void CEditParts::GetPosition(float *pos) {
    GetLocalPos(pos);
    if (ground != 0) {
        float offset[4];
        ground->GetPosition(offset);
        pos[1] += StandardPos(offset[1]);
    }
}
void CEditParts::GetLocalPos(float *pos) {
    mgCObject::GetPosition(pos);
}
void CEditParts::UpDatePosition() {
    float pos[4];
    float offset[4];
    if (changed != 0 || ground != 0) {
        GetLocalPos(pos);
        if (ground != 0) {
            ground->GetPosition(offset);
            pos[1] += offset[1];
        }
        frame.SetPosition(pos);
        frame.SetRotation(rotation);
        frame.SetScale(scale);
        changed = 0;
    }
}
int CEditParts::GetInfoID() {
    CEditPartsInfo *river_info;

    river_info = info;
    if (river_info != NULL) {
        return river_info->id;
    }
    return -1;
}
int CEditParts::GetLiveNPC(void) {
    CEditHouse *part_house = house;
    if (part_house != NULL) {
        return part_house->npc_no[0];
    }
    return -1;
}
int CEditParts::IsWallParts() {
    if (info == 0) {
        return 0;
    }

    return ((info->col_wall.poly_count <= 0) ^ 1);
}
int CEditParts::IsFence() {
    CEditPartsInfo *river_info;

    river_info = info;
    if (river_info == NULL) {
        return 0;
    }
    return (river_info->attr & 0x130) == 0x130;
}
int CEditParts::IsBurn() {
    CEditPartsInfo *river_info;

    river_info = info;
    if (river_info == NULL) {
        return 0;
    }
    return (river_info->attr & 0x1000) != 0;
}
int CEditParts::GetFenceSide(float *end_a, float *end_b) {
    float matrix[4][4];
    float point_a[4];
    float point_b[4];
    if (bound_valid == 0) {
        return 0;
    }
    if (info == 0) {
        return 0;
    }
    ((CMapParts *)this)->GetLWMatrix(matrix);
    *(u_long128 *)point_a = *(u_long128 *)info->area3_box.max;
    *(u_long128 *)point_b = *(u_long128 *)info->area3_box.min;
    point_b[3] = 1.0f;
    point_a[3] = 1.0f;
    sceVu0ApplyMatrix(end_a, matrix, point_a);
    sceVu0ApplyMatrix(end_b, matrix, point_b);
    return 1;
}
int CEditParts::GetWallPlane(int wall_no, WallInfo *out_info) {
    sceVu0FVECTOR sum;
    mgVu0FBOX     box;
    sceVu0FVECTOR poly_max;
    sceVu0FVECTOR poly_min;
    int           found;
    int           vertex_count;
    int           i;
    int           poly_count;
    CCPoly       *poly;

    if (!IsWallParts()) {
        return 0;
    }
    vertex_count = 0;
    poly_count = info->col_wall.poly_count;
    poly = info->col_wall.poly;
    found = 0;
    mgZeroVector(sum);
    for (i = 0; i < poly_count; i++, poly++) {
        if (poly->ignore_mask == wall_no) {
            if (!found) {
                sceVu0Normalize(out_info->plane, poly->normal);
                out_info->plane[3] = -sceVu0InnerProduct(out_info->plane, poly->vertex[0]);
                mgVectorMaxMin(box.max, box.min, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
                found = 1;
            } else {
                mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
                mgVectorMaxMin(box.max, box.min, box.max, box.min, poly_max, poly_min);
            }
            mgAddVector(sum, poly->vertex[0]);
            mgAddVector(sum, poly->vertex[1]);
            mgAddVector(sum, poly->vertex[2]);
            vertex_count += 3;
        }
    }
    sceVu0ScaleVector(out_info->center, sum, 1.0f / (float)vertex_count);
    out_info->box.max[1] = box.max[1] - out_info->center[1];
    out_info->box.min[1] = box.min[1] - out_info->center[1];
    out_info->box.max[0] = mgDistVectorXZ(box.max, out_info->center);
    out_info->box.min[0] = -mgDistVectorXZ(box.min, out_info->center);
    out_info->box.max[2] = 0.0f;
    out_info->box.min[2] = 0.0f;
    out_info->box.max[3] = 1.0f;
    out_info->box.min[3] = 1.0f;
    out_info->center[3] = 1.0f;
    return found;
}

int CEditParts::GetWallGroupNum() {
    CEditPartsInfo *river_info;

    river_info = info;
    if (river_info != NULL) {
        return river_info->wall_group_num;
    }
    return 0;
}
int CEditParts::GetPartsType(void) {
    CEditPartsInfo *part_info = info;
    if (part_info != NULL) {
        return part_info->GetPartsType();
    }
    return -1;
}
void CEditParts::Copy(CMapParts &source, mgCMemory *memory) {
    CMapParts::Copy(source, memory);
}
int CEditParts::CheckTerritory(CEditParts *other) {
    float center[4];
    float other_center[4];
    float matrix[4][4];
    float other_matrix[4][4];
    float radius_sum;
    float height_limit;
    float height_diff;

    if (info == 0 || other == 0 || other->info == 0) {
        return 0;
    }
    if (other->info->attr & kNoTerritoryFlags) {
        return 0;
    }
    ((CMapParts *)this)->GetLWMatrix(matrix);
    ((CMapParts *)other)->GetLWMatrix(other_matrix);
    sceVu0ApplyMatrix(center, matrix, info->territory_center);
    sceVu0ApplyMatrix(other_center, other_matrix,
                      other->info->territory_center);
    radius_sum = info->territory_radius +
                other->info->territory_radius;
    if (!(mgDistVectorXZ(center, other_center) <= radius_sum)) {
        return 0;
    }
    height_limit = info->territory_height +
                  other->info->territory_height;
    height_diff = other_center[1] - center[1];
    if (height_diff < 0.0f) {
        height_diff = -height_diff;
    }
    if (!(height_diff <= height_limit)) {
        return 0;
    }
    return 1;
}
void CEditParts::CheckColorUpdate() {
    CList<CMapPiece> *node = piece_list;
    max_material_num = 0;
    if (node != 0) {
        do {
            int count = node->data.material_num;
            if (count > 0) {
                int cur = max_material_num;
                max_material_num = (count < cur) ? cur : count;
            }
            node = node->next;
        } while (node != 0);
    }
}
int EditPartsCmpColor(float *a, float *b) {
    if (mgDistVector(a, b) < 0.02f) {
        return 1;
    }
    return 0;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editparts", at_418__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editparts", __vt__10CEditParts__DATA);
