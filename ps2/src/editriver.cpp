#include "common.h"
#include "mg_memory.hpp"
#include <cstring>
#include "mg_texture.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "editmap.hpp"
#include "editriver.hpp"

extern "C" int fptosi(float value);

// Code (.text)
int CEditMap::PlaceRiver(float *pos) {
    for (int i = 0; i < grid_max; i++) {
        CEditGrid *grid = this->grid[i];
        if (grid != NULL && grid->SetRiver(pos[0], pos[2])) {
            return 1;
        }
    }
    return 0;
}
int CEditMap::RemoveRiver(float *pos) {
    for (int i = 0; i < grid_max; i++) {
        CEditGrid *grid = this->grid[i];
        if (grid != NULL && grid->ResetRiver(pos[0], pos[2])) {
            return 1;
        }
    }
    return 0;
}
void CEditMap::CreateGrid(float *upper, float *lower, mgCMemory *mem, float *offset) {
    float matrix[16];
    float origin_x = lower[0];
    float origin_z = lower[2];
    origin_x += offset[0];
    origin_z += offset[2];
    int num_x = fptosi((upper[0] - origin_x) / 160.0f);
    int num_z = fptosi((upper[2] - origin_z) / 160.0f);
    for (int i = 0; i < grid_max; i++) {
        if (grid[i] == NULL) {
            CEditGrid *grid;
            if ((grid = new ((u_long128 *)mem->Alloc(0x15)) CEditGrid) != NULL) {
                grid->Initialize();
            }
            this->grid[i] = grid;
            this->grid[i]->Create(num_x, num_z, mem);
            this->grid[i]->step_x = 160.0f;
            this->grid[i]->step_z = 160.0f;
            this->grid[i]->origin[0] = origin_x;
            this->grid[i]->origin[1] = lower[1];
            this->grid[i]->origin[2] = origin_z;
            this->grid[i]->Clear();
            for (int x = 0; x < num_x; x++) {
                for (int y = 0; y < num_z; y++) {
                }
            }
            for (int turn = 0; turn < 4; turn++) {
                mgUnitMatrix((float (*)[4])matrix);
                if (turn == 3) {
                    matrix[10] = 0.0f;
                    matrix[2] = -1.0f;
                    matrix[0] = 0.0f;
                    matrix[8] = 1.0f;
                }
                if (turn == 2) {
                    matrix[10] = -1.0f;
                    matrix[0] = -1.0f;
                }
                if (turn == 1) {
                    matrix[10] = 0.0f;
                    matrix[2] = 1.0f;
                    matrix[0] = 0.0f;
                    matrix[8] = -1.0f;
                }
                sceVu0CopyMatrix(this->grid[i]->rot[turn], (float (*)[4])matrix);
            }
            return;
        }
    }
}
int CEditMap::GetRiverNum(float *position) {
    float cell_pos[4];
    int count = 0;
    for (int g = 0; g < grid_max; g++) {
        CEditGrid *grid = this->grid[g];
        if (grid != NULL) {
            for (int x = 0; x < grid->num_x; x++) {
                for (int y = 0; y < grid->num_z; y++) {
                    if (grid->River(x, y)) {
                        grid->GetRiverPos(x, y, cell_pos);
                        if (position[3] < 0.0f || mgDistVectorXZ(cell_pos, position) <
                                                      position[3] + 1.4f * grid->step_x) {
                            count++;
                        }
                    }
                }
            }
        }
    }
    return count;
}
int CEditMap::IsRiverGrid(float *pos) {
    int cell[2];
    for (int i = 0; i < grid_max; i++) {
        CEditGrid *grid = this->grid[i];
        if (grid != NULL && grid->GetLPos(cell, pos[0], pos[2]) && grid->River(cell[0], cell[1])) {
            return 1;
        }
    }
    return 0;
}
int CEditMap::GetRiverNum(int parts_index, float radius) {
    float position[4];
    CEditParts *edit_parts = GetePlaceParts(parts_index);
    if (edit_parts == NULL) {
        return 0;
    }
    if (!CheckNormalPlaceParts(edit_parts)) {
        return 0;
    }
    edit_parts->GetPosition(position);
    position[3] = radius;
    return GetRiverNum(position);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editriver", DrawRiverMask__8CEditMapFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editriver", DrawRiver__8CEditMapFv);
void CEditGrid::Create(int w, int h, mgCMemory *mem) {
    int count = w * h;
    u32 blocks;

    if (((u32)count * 0x14) & 0xF) {
        blocks = (((u32)count * 0x14) >> 4) + 1;
    } else {
        blocks = ((u32)count * 0x14) >> 4;
    }
    u_long128 *block = (u_long128 *)mem->Alloc(blocks + 2);
    data = new (block) CGridData[count];
    num_x = w;
    num_z = h;
}
CGridData::CGridData() {
    memset(this, 0, sizeof(CGridData));
}
void CEditGrid::Clear() {

    memset((void *)data, 0, num_x * num_z * sizeof(CGridData));
}
void CEditGrid::Initialize() {
    num_z = 0;
    num_x = 0;
    data = 0;
    step_z = 0;
    step_x = 0;
    mgZeroVector(origin);
}
int CEditGrid::Check(int x, int y) {
    if (x < 0 || x >= num_x) {
        return 0;
    }
    if (y < 0 || y >= num_z) {
        return 0;
    }
    return 1;
}
CGridData *CEditGrid::Get(int x, int y) {
    if (!Check(x, y)) {
        return NULL;
    }
    return GetFast(x, y);
}
CGridData *CEditGrid::GetFast(int x, int y) {
    return (CGridData *)((int)data + ((x + (y * num_x)) * sizeof(CGridData)));
}
int CEditGrid::GetLPos(int *cell, float x, float z) {
    float cell_x = (x - origin[0]) / step_x;
    float cell_y = (z - origin[2]) / step_z;
    cell[0] = fptosi(cell_x);
    cell[1] = fptosi(cell_y);
    if (cell_x < 0.0f || cell_y < 0.0f) {
        return 0;
    }
    return Check(cell[0], cell[1]) != 0;
}
void CEditGrid::GetWPos(float *pos, int x, int y) {
    pos[0] = origin[0] + (float)x * step_x;
    pos[2] = origin[2] + (float)y * step_z;
    pos[1] = 0.0f;
    pos[3] = 1.0f;
}
int CEditGrid::SetRiver(float x, float z) {
    int grid_pos[2];
    int result;
    if (GetLPos(grid_pos, x, z)) {
        result = SetRiver(grid_pos[0], grid_pos[1]);
    } else {
        result = 0;
    }
    return result;
}
int CEditGrid::ResetRiver(float x, float z) {
    int grid_pos[2];
    int result;
    if (GetLPos(grid_pos, x, z)) {
        result = ResetRiver(grid_pos[0], grid_pos[1]);
    } else {
        result = 0;
    }
    return result;
}
int CEditGrid::SetRiver(int x, int z) {
    CGridData *cell;

    cell = Get(x, z);
    if (cell == NULL) {
        return 0;
    }
    cell->river = 1;
    UpdateRiver(x, z);
    UpdateRiver(x - 1, z);
    UpdateRiver(x + 1, z);
    UpdateRiver(x, z + 1);
    UpdateRiver(x, z - 1);
    UpdateRiver(x - 1, z - 1);
    UpdateRiver(x + 1, z - 1);
    UpdateRiver(x + 1, z + 1);
    UpdateRiver(x - 1, z + 1);
    return 1;
}
int CEditGrid::ResetRiver(int x, int z) {
    CGridData *cell;

    cell = Get(x, z);
    if (cell == NULL) {
        return 0;
    }
    if (cell->river == 0) {
        return 0;
    }
    cell->river = 0;
    UpdateRiver(x, z);
    UpdateRiver(x - 1, z);
    UpdateRiver(x + 1, z);
    UpdateRiver(x, z + 1);
    UpdateRiver(x, z - 1);
    UpdateRiver(x - 1, z - 1);
    UpdateRiver(x + 1, z - 1);
    UpdateRiver(x + 1, z + 1);
    UpdateRiver(x - 1, z + 1);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editriver", UpdateRiver__9CEditGridFii);
int CEditGrid::River(int x, int z) {
    CGridData *cell;

    cell = Get(x, z);
    if (cell != NULL) {
        return cell->river;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editriver", GetRiverPos__9CEditGridFiiPA4_f);
void CEditGrid::GetRiverPos(int x, int y, float *pos) {
    float half_width = step_x / 2.0f;
    float half_height = step_z / 2.0f;
    GetWPos(pos, x, y);
    pos[0] += half_width;
    pos[2] += half_height;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editriver", GetRiverPoly__9CEditGridFP6CCPolyRC9mgVu0FBOXif);
void CEditGrid::GetGridBox(mgVu0FBOX *box, float *pos) {
    int cell[2];
    float corner[4];
    GetLPos(cell, pos[0], pos[2]);
    GetWPos(corner, cell[0], cell[1]);
    *(u_long128 *)box->min = *(u_long128 *)corner;
    box->min[3] = 1.0f;
    *(u_long128 *)box->max = *(u_long128 *)corner;
    box->min[3] = 1.0f;
    box->max[0] += step_x;
    box->max[2] += step_z;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_504__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_505__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_506__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_507__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_590__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_591__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_592__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_593__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_594__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editriver", at_799__3__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_733__2, 0x10);
INCLUDE_BSS(at_734, 0x10);
