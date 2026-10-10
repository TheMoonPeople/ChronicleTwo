#include "common.h"
#include "mw_runtime.h"

#include <cstring>

#include "collision.hpp"
#include "editmap.hpp"
#include "editriver.hpp"
#include "mdslist.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

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

            if ((grid = new (mem->Alloc(0x15)) CEditGrid) != NULL) {
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
                mgUnitMatrix((float(*)[4]) matrix);

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

                sceVu0CopyMatrix(this->grid[i]->rot[turn], (float(*)[4]) matrix);
            }

            return;
        }
    }
}

int CEditMap::GetRiverNum(float *position) {
    float cell_pos[4];
    int   count = 0;

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
    float       position[4];
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

void CEditMap::DrawRiverMask() {
    if (river_piece[0] == NULL || river_piece[1] == NULL || river_piece[2] == NULL || river_piece[3] == NULL) {
        return;
    }

    mgCDrawPrim draw;
    draw.Initialize(NULL, NULL);
    draw.TextureMapEnable(0);
    draw.DepthTestEnable(0);
    draw.AlphaTestEnable(0);
    draw.AlphaBlendEnable(1);
    draw.AlphaBlend(MG_ALPHA_BLEND_ADD);
    draw.Begin(MG_PRIM_SPRITE);
    draw.Color(0, 0, 0, 0x80);
    draw.Vertex(0, 0, 0);
    draw.Vertex(mgScreenWidth, mgScreenHeight, 0);
    draw.End();
    mgDrawDirectStart();

    for (int g = 0; g < grid_max; g++) {
        CEditGrid *grid = this->grid[g];

        if (grid != NULL) {
            int   height = grid->num_z;
            int   width = grid->num_x;
            float half_z = grid->step_z / 2.0f;
            float quarter_x = grid->step_x / 4.0f;
            float quarter_z = grid->step_z / 4.0f;
            float x = grid->origin[0] + grid->step_x / 2.0f;
            float y = grid->origin[1];

            for (int gx = 0; gx < width; gx++) {
                float z = grid->origin[2] + half_z;

                for (int gz = 0; gz < height; gz++) {
                    CGridData *cell = grid->GetFast(gx, gz);

                    if (cell != NULL && cell->river) {
                        float corner0[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner0[0] = x - quarter_x;
                        corner0[1] = y;
                        corner0[2] = z - quarter_z;
                        float corner1[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner1[0] = x + quarter_x;
                        corner1[1] = y;
                        corner1[2] = z - quarter_z;
                        float corner2[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner2[0] = x + quarter_x;
                        corner2[1] = y;
                        corner2[2] = z + quarter_z;
                        float corner3[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner3[0] = x - quarter_x;
                        corner3[1] = y;
                        corner3[2] = z + quarter_z;
                        mgCFrame *frame0 = river_piece[cell->piece[0]]->frame;
                        mgCFrame *frame1 = river_piece[cell->piece[1]]->frame;
                        mgCFrame *frame2 = river_piece[cell->piece[2]]->frame;
                        mgCFrame *frame3 = river_piece[cell->piece[3]]->frame;
                        frame0->SetPosition(corner0);
                        frame0->SetTransMatrix(grid->rot[cell->rot[0]]);
                        mgDrawDirect2(frame0);
                        frame1->SetPosition(corner1);
                        frame1->SetTransMatrix(grid->rot[cell->rot[1]]);
                        mgDrawDirect2(frame1);
                        frame2->SetPosition(corner2);
                        frame2->SetTransMatrix(grid->rot[cell->rot[2]]);
                        mgDrawDirect2(frame2);
                        frame3->SetPosition(corner3);
                        frame3->SetTransMatrix(grid->rot[cell->rot[3]]);
                        mgDrawDirect2(frame3);
                    }

                    z += grid->step_z;
                }

                x += grid->step_x;
            }
        }
    }

    mgDrawDirectEnd();
    float position[4];
    float rotation[4];

    for (int i = 0; i < edit_parts_max; i++) {
        CEditParts *parts = &edit_parts[i];
        int         empty = parts->name[0] == 0;

        if (!empty && parts->state) {
            CEditPartsInfo *info = parts->info;

            if (info != NULL && info->id == 0x3C) {
                parts->GetPosition(position);
                parts->GetRotation(rotation);

                if (mask_piece[0] != NULL) {
                    mask_piece[0]->SetPosition(position);
                    mask_piece[0]->SetRotation(rotation);
                    mask_piece[0]->DrawDirect();
                }
            }
        }
    }
}

void CEditMap::DrawRiver() {
    for (int i = 0; i < EDIT_MAP_RIVER_PARTS_MAX; i++) {
        if (river_parts[i] == NULL) {
            return;
        }
    }

    if (water_piece == NULL) {
        return;
    }

    for (int g = 0; g < grid_max; g++) {
        CEditGrid *grid = this->grid[g];

        if (grid != NULL) {
            int   height = grid->num_z;
            int   width = grid->num_x;
            float half_z = grid->step_z / 2.0f;
            float quarter_x = grid->step_x / 4.0f;
            float quarter_z = grid->step_z / 4.0f;
            float x = grid->origin[0] + grid->step_x / 2.0f;
            float y = grid->origin[1];

            for (int gx = 0; gx < width; gx++) {
                float z = grid->origin[2] + half_z;

                for (int gz = 0; gz < height; gz++) {
                    CGridData *cell = grid->GetFast(gx, gz);

                    if (cell != NULL && cell->river) {
                        float center[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        center[0] = x;
                        center[1] = y;
                        center[2] = z;
                        float corner0[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner0[0] = x - quarter_x;
                        corner0[1] = y;
                        corner0[2] = z - quarter_z;
                        float corner1[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner1[0] = x + quarter_x;
                        corner1[1] = y;
                        corner1[2] = z - quarter_z;
                        float corner2[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner2[0] = x + quarter_x;
                        corner2[1] = y;
                        corner2[2] = z + quarter_z;
                        float corner3[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        corner3[0] = x - quarter_x;
                        corner3[1] = y;
                        corner3[2] = z + quarter_z;
                        river_parts[cell->piece[0]]->SetPosition(corner0);
                        river_parts[cell->piece[0]]->frame.SetTransMatrix(grid->rot[cell->rot[0]]);
                        river_parts[cell->piece[0]]->Draw();
                        river_parts[cell->piece[1]]->SetPosition(corner1);
                        river_parts[cell->piece[1]]->frame.SetTransMatrix(grid->rot[cell->rot[1]]);
                        river_parts[cell->piece[1]]->Draw();
                        river_parts[cell->piece[2]]->SetPosition(corner2);
                        river_parts[cell->piece[2]]->frame.SetTransMatrix(grid->rot[cell->rot[2]]);
                        river_parts[cell->piece[2]]->Draw();
                        river_parts[cell->piece[3]]->SetPosition(corner3);
                        river_parts[cell->piece[3]]->frame.SetTransMatrix(grid->rot[cell->rot[3]]);
                        river_parts[cell->piece[3]]->Draw();
                        water_piece->SetPosition(center);
                        water_piece->Draw();
                    }

                    z += grid->step_z;
                }

                x += grid->step_x;
            }
        }
    }
}

void CEditGrid::Create(int w, int h, mgCMemory *mem) {
    int count = w * h;
    u32 blocks;

    if (((u32) count * 0x14) & 0xF) {
        blocks = (((u32) count * 0x14) >> 4) + 1;
    } else {
        blocks = ((u32) count * 0x14) >> 4;
    }

    u_long128 *block = mem->Alloc(blocks + 2);
    data = new (block) CGridData[count];
    num_x = w;
    num_z = h;
}

CGridData::CGridData() {
    memset(this, 0, sizeof(CGridData));
}

void CEditGrid::Clear() {

    memset((void *) data, 0, num_x * num_z * sizeof(CGridData));
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
    return (CGridData *) ((int) data + ((x + (y * num_x)) * sizeof(CGridData)));
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
    pos[0] = origin[0] + (float) x * step_x;
    pos[2] = origin[2] + (float) y * step_z;
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

int CEditGrid::UpdateRiver(int x, int z) {
    CGridData *cell = Get(x, z);

    if (cell == NULL) {
        return 0;
    }

    if (cell->river == 0) {
        return 0;
    }

    int shape[EDIT_GRID_CORNER_MAX] = {0};
    int turn[EDIT_GRID_CORNER_MAX] = {0};
    int hash = 0x10DCD;

    for (int corner = 0; corner < EDIT_GRID_CORNER_MAX; corner++) {
        int side_a;
        int side_b;
        int diagonal;
        int variant;

        hash *= (x + corner) * (z + corner + 1);
        variant = 0;

        if (hash < 0) {
            variant = EDIT_RIVER_PIECE_VARIANT;
        }

        switch (corner) {
            case 0:
                side_a = River(x - 1, z);
                side_b = River(x, z - 1);
                diagonal = River(x - 1, z - 1);
                break;
            case 1:
                side_a = River(x, z - 1);
                side_b = River(x + 1, z);
                diagonal = River(x + 1, z - 1);
                break;
            case 2:
                side_a = River(x + 1, z);
                side_b = River(x, z + 1);
                diagonal = River(x + 1, z + 1);
                break;
            case 3:
                side_a = River(x, z + 1);
                side_b = River(x - 1, z);
                diagonal = River(x - 1, z + 1);
                break;
        }

        int sides = side_a + side_b;

        if (sides == 0) {
            shape[corner] = EDIT_RIVER_PIECE_OUTER;
            turn[corner] = (corner + 2) % 4;
        }

        if (sides == 1) {
            shape[corner] = EDIT_RIVER_PIECE_EDGE;

            if (side_a != 0) {
                turn[corner] = 1;
            } else {
                turn[corner] = 0;
            }

            turn[corner] = (corner + turn[corner]) % 4;
        }

        if (sides == 2) {
            if (diagonal != 0) {
                shape[corner] = EDIT_RIVER_PIECE_FULL;
                turn[corner] = 0;
            } else {
                shape[corner] = EDIT_RIVER_PIECE_INNER;
                turn[corner] = corner;
            }
        }

        cell->piece[corner] = variant + shape[corner];
        cell->rot[corner] = turn[corner];
    }

    return 1;
}

int CEditGrid::River(int x, int z) {
    CGridData *cell;

    cell = Get(x, z);

    if (cell != NULL) {
        return cell->river;
    }

    return 0;
}

void CEditGrid::GetRiverPos(int x, int z, float (*pos)[4]) {
    float half_x = step_x / 2.0f;
    float half_z = step_z / 2.0f;
    float quarter_x = step_x / 4.0f;
    float quarter_z = step_z / 4.0f;
    float center[4];

    GetWPos(center, x, z);
    float y = center[1];
    float center_x = center[0] + half_x;
    float center_z = center[2] + half_z;
    pos[0][0] = center_x - quarter_x;
    pos[0][1] = y;
    pos[0][2] = center_z - quarter_z;
    pos[0][3] = 1.0f;
    pos[1][0] = center_x + quarter_x;
    pos[1][1] = y;
    pos[1][2] = center_z - quarter_z;
    pos[1][3] = 1.0f;
    pos[2][0] = center_x + quarter_x;
    pos[2][1] = y;
    pos[2][2] = center_z + quarter_z;
    pos[2][3] = 1.0f;
    pos[3][0] = center_x - quarter_x;
    pos[3][1] = y;
    pos[3][2] = center_z + quarter_z;
    pos[3][3] = 1.0f;
}

void CEditGrid::GetRiverPos(int x, int y, float *pos) {
    float half_width = step_x / 2.0f;
    float half_height = step_z / 2.0f;
    GetWPos(pos, x, y);
    pos[0] += half_width;
    pos[2] += half_height;
}

int CEditGrid::GetRiverPoly(CCPoly *poly, const mgVu0FBOX &box, int poly_max, float margin) {
    int upper[2];
    int lower[2];
    GetLPos(upper, box.max[0], box.max[2]);
    GetLPos(lower, box.min[0], box.min[2]);
    int   count = 0;
    float corners[5][4] = {
        {0.0f,   0.0f, 0.0f,   1.0f},
        {step_x, 0.0f, 0.0f,   1.0f},
        {step_x, 0.0f, step_z, 1.0f},
        {0.0f,   0.0f, step_z, 1.0f},
        {0.0f,   0.0f, 0.0f,   1.0f}
    };
    float inset[5][4];
    float position[4];

    for (int x = lower[0]; x <= upper[0]; x++) {
        for (int z = lower[1]; z <= upper[1]; z++) {
            if (River(x, z)) {
                if (poly_max < 8) {
                    return count;
                }

                *(u_long128 *) inset[0] = *(u_long128 *) corners[0];
                *(u_long128 *) inset[1] = *(u_long128 *) corners[1];
                *(u_long128 *) inset[2] = *(u_long128 *) corners[2];
                *(u_long128 *) inset[3] = *(u_long128 *) corners[3];

                if (!River(x + 1, z)) {
                    inset[1][0] -= margin;
                    inset[2][0] -= margin;
                }

                if (!River(x - 1, z)) {
                    inset[0][0] += margin;
                    inset[3][0] += margin;
                }

                if (!River(x, z + 1)) {
                    inset[2][2] -= margin;
                    inset[3][2] -= margin;
                }

                if (!River(x, z - 1)) {
                    inset[0][2] += margin;
                    inset[1][2] += margin;
                }

                *(u_long128 *) inset[4] = *(u_long128 *) inset[0];
                GetWPos(position, x, z);

                for (int i = 0; i < 4; i++) {
                    sceVu0AddVector(poly[0].vertex[0], inset[i], position);
                    sceVu0AddVector(poly[0].vertex[1], inset[i + 1], position);
                    sceVu0AddVector(poly[0].vertex[2], inset[i + 1], position);
                    poly[0].vertex[2][1] += 2000.0f;
                    poly[0].vertex[2][3] = 1.0f;
                    poly[0].vertex[1][3] = 1.0f;
                    poly[0].vertex[0][3] = 1.0f;
                    mgPlaneNormal(poly[0].normal, poly[0].vertex[0], poly[0].vertex[1], poly[0].vertex[2]);
                    *(u_long128 *) &poly[0].ground_kind = 0;
                    sceVu0AddVector(poly[1].vertex[0], inset[i + 1], position);
                    poly[1].vertex[0][1] += 2000.0f;
                    sceVu0AddVector(poly[1].vertex[1], inset[i], position);
                    poly[1].vertex[1][1] += 2000.0f;
                    sceVu0AddVector(poly[1].vertex[2], inset[i], position);
                    poly[1].vertex[2][3] = 1.0f;
                    poly[1].vertex[1][3] = 1.0f;
                    poly[1].vertex[0][3] = 1.0f;
                    mgPlaneNormal(poly[1].normal, poly[1].vertex[0], poly[1].vertex[1], poly[1].vertex[2]);
                    *(u_long128 *) &poly[1].ground_kind = 0;
                    poly += 2;
                }

                count += 8;
            }
        }
    }

    return count;
}

void CEditGrid::GetGridBox(mgVu0FBOX *box, float *pos) {
    int   cell[2];
    float corner[4];
    GetLPos(cell, pos[0], pos[2]);
    GetWPos(corner, cell[0], cell[1]);
    *(u_long128 *) box->min = *(u_long128 *) corner;
    box->min[3] = 1.0f;
    *(u_long128 *) box->max = *(u_long128 *) corner;
    box->min[3] = 1.0f;
    box->max[0] += step_x;
    box->max[2] += step_z;
}
