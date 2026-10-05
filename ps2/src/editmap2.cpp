#include "common.h"
#include "mdslist.hpp"
#include <cstdio>
#include <cstring>
#include "mg_texture.hpp"
#include "menusystemdata.hpp"
#include "savedata.hpp"
#include "snd_mngr.hpp"
#include "mg_math.hpp"
#include "editdata.hpp"
#include "editriver.hpp"
#include "editmap.hpp"
#include "editmap2.hpp"

extern "C" int fptosi(float value);
extern "C" int sndGetVolPan__FPfPfPfff(float *, float *, float *, float, float);

static const float kFenceChainDistance = 5.0f;
static const int kBalanceLimit = 4;
static const u32 kFuncPointHasSound = 0x80;
static const int kPartsTypeRiver = 0xB;
static const int kNpcLiveLength = 7;
static const int kChildIdMax = 0x200;

extern "C" char at_1042__4[];
extern "C" char at_1043__4[];

struct NpcLiveName {
    char text[10];
};
extern "C" NpcLiveName at_983__3;
extern int LanguageCode;
extern u_long128 at_796__4;

// Code (.text)
void PlaneNormalXZ(float *normal, float *p0, float *p1, float *p2) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap2", GetEditPartsAlt__8CEditMapFP14CEditPartsInfoPffPP10CEditPartsi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap2", CheckEditParts__8CEditMapFP14CEditPartsInfoPffP13EP_PLACE_INFOPP10CEditPartsi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap2", CheckEditPartsOnRiver__8CEditMapFP14CEditPartsInfoPff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmap2", CheckRiverParts__8CEditMapFPf);
int CEditMap::CheckNormalPlaceParts(int place_no) {
    CEditParts *edit_parts = GetePlaceParts(place_no);
    return CheckNormalPlaceParts(edit_parts);
}
int CEditMap::CheckNormalPlaceParts(CEditParts *edit_parts) {
    if (edit_parts == NULL)
        return 0;
    if ((edit_parts->name[0] == 0) != 0 || edit_parts->state != 1)
        return 0;
    return 1;
}
int CEditMap::CheckLiveNPC(int npc_id, int id) {
    CEditParts *part;
    int count;
    int i;

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
    int found = 0;
    int limit = max;
    CEditPartsInfo *info;
    CEditParts *part;
    int i;

    info = GetePartsInfoAtID(id);
    if (info == NULL) {
        return 0;
    }
    if (info->GetPartsType() == kPartsTypeRiver) {
        union RiverPosition { u_long128 quad; float values[4]; };
        RiverPosition position = *(RiverPosition *)&at_796__4;
        int river_count = GetRiverNum((float *)&position);
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
    int n;
    CEditParts *p;
    int i;
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
    int found;
    EditPlaceLog *child;
    int i;
    s16 id;
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
    int i;

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
        *(u_long128 *)fence_color = *(u_long128 *)color;
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
    int index;
    CList<CMapPiece> *node;
    int live_length;
    CMapPiece *model;
    CEditParts *part;
    char *node_name;
    int visible;
    float fade;
    int child_ids[kChildIdMax];
    int child_num;
    int i;
    CEditParts *child;
    NpcLiveName live_name;
    char suffix[10];
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
                live_name = at_983__3;
                live_length = kNpcLiveLength;
                if (LanguageCode > 0) {
                    live_length += sprintf(suffix, at_1042__4, LanguageCode);
                    strcat(live_name.text, suffix);
                }
                if (node_name != NULL && strncmp(node_name, at_1043__4, kNpcLiveLength) == 0) {
                    model->Show(0);
                    if (strncmp(node_name, live_name.text, live_length) == 0) {
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
    int ground_index;
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
    float side_diff = (float)(balance_weight[0] - balance_weight[1]);
    if (side_diff < 0.0f) {
        side_diff = -side_diff;
    }
    int side = fptosi(side_diff);
    float depth_diff = (float)(balance_weight[2] - balance_weight[3]);
    if (depth_diff < 0.0f) {
        depth_diff = -depth_diff;
    }
    int depth = fptosi(depth_diff);
    return side < kBalanceLimit && depth < kBalanceLimit;
}
CFuncPoint *CEditMap::InScreenFunc(InScreenFuncInfo *info) {
    CFuncPoint *result;
    CEditParts *part;
    float best_near;
    float best_distance;
    int i;

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
int CEditMap::GetSeSrcVolPan(int *ids, float *vols, float *pans, int max) {
    CFuncPointCheck check;
    float matrix[4][4];
    int count;
    int i;
    int x;
    int y;
    CEditParts *part;
    int added;

    check.time = 0.0f;
    CreateFuncCheck(&check);
    count = 0;
    mgUnitMatrix(matrix);
    added = CMap::GetSeSrcVolPan(ids, vols, pans, max);
    max -= added;
    count += added;
    ids += added;
    pans += added;
    i = 0;
    part = edit_parts;
    vols += added;
    for (; i < edit_parts_max; i++, part++) {
        if (CheckNormalPlaceParts(part) && (*(u32 *)&part->func_point_mngr & kFuncPointHasSound)) {
            part->GetLWMatrix(matrix);
            if (max <= 0) {
                return count;
            }
            added = ::GetSeSrcVolPan(matrix, &part->func_point_mngr, &check, ids, vols, pans, max);
            max -= added;
            count += added;
            ids += added;
            vols += added;
            pans += added;
        }
    }
    if (max <= 0) {
        return count;
    }
    float near_dist = 10.0f;
    float far_dist = 2000.0f;
    float max_vol = 0.0f;
    int data = 0;
    float pan_sum = 0.0f;
    CEditGrid *grid;
    int off;
    int g;
    for (g = 0, off = 0; g < grid_max; off += 4, g++) {

        grid = *(CEditGrid **)((u8 *)this + off + 0xF54);
        if (grid != NULL) {
            for (x = 0; x < grid->num_x; x++) {
                for (y = 0; y < grid->num_z; y++) {
                    if (grid->River(x, y)) {
                        float pos[4];
                        float vol;
                        float pan;
                        grid->GetWPos(pos, x, y);
                        sndGetVolPan__FPfPfPfff(&vol, &pan, pos, near_dist, far_dist);
                        if (!(vol <= 0.0f)) {
                            data++;
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
    if (data > 0) {
        count++;
        *ids = 6;
        *vols = max_vol;
        *pans = pan_sum / (float)data;
    }
    return count;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_796__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_983__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_1042__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_1043__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_1127__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_1128__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_1129__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmap2", at_1130__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(cnt_482, 0x4);
INCLUDE_BSS(init_483, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1050__2, 0x10);
