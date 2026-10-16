#include "common.h"

#include "editmap.hpp"
#include "editriver.hpp"
#include "mdslist.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"

// River coverage clears destination alpha so ground pieces leave water and river beds visible.
PORT_OVERRIDE void CEditMap::DrawRiverMask() {
    if (river_piece[0] == nullptr || river_piece[1] == nullptr || river_piece[2] == nullptr || river_piece[3] == nullptr) {
        return;
    }

    mgPortBeginDestAlphaMask();
    mgDrawDirectStart();

    for (int g = 0; g < grid_max; g++) {
        CEditGrid *grid = this->grid[g];

        if (grid != nullptr) {
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

                    if (cell != nullptr && cell->river) {
                        float corners[4][4] = {
                            {x - quarter_x, y, z - quarter_z, 1.0f},
                            {x + quarter_x, y, z - quarter_z, 1.0f},
                            {x + quarter_x, y, z + quarter_z, 1.0f},
                            {x - quarter_x, y, z + quarter_z, 1.0f},
                        };

                        for (int corner = 0; corner < 4; corner++) {
                            mgCFrame *frame = river_piece[cell->piece[corner]]->frame;
                            frame->SetPosition(corners[corner]);
                            frame->SetTransMatrix(grid->rot[cell->rot[corner]]);
                            mgDrawDirect2(frame);
                        }
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

            if (info != nullptr && info->id == 0x3C) {
                parts->GetPosition(position);
                parts->GetRotation(rotation);

                if (mask_piece[0] != nullptr) {
                    mask_piece[0]->SetPosition(position);
                    mask_piece[0]->SetRotation(rotation);
                    mask_piece[0]->DrawDirect();
                }
            }
        }
    }

    mgPortEndDestAlphaMask();
}
