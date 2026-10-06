#include "common.h"
#include "vlgr_info.hpp"
#include "savedata.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "editdata.hpp"
#include "editmap.hpp"
#include "editanalyze.hpp"
#include "editmenu.hpp"

const int info_tree_a = 0x28;
const int info_tree_b = 0x29;
const int info_tree_c = 0x2A;
const int info_stone_wall = 0x2B;
const int info_fence = 0x2F;
const int analyze_slots = 64;
const int parts_list_max = 0x200;

extern float at_964__4[4];
extern float at_1297__4[4];
union HouseInfoIds {
    int id[4];
    u_long128 qw;
};

extern "C" HouseInfoIds at_913__6;

// Code (.text)
void AnalyzeEditMap(int chara_no, CEditMap *map) {
    CEditData *data;

    if (map != NULL) {
        data = (CEditData *)GetSaveData()->GetEditData(chara_no);
        if (data != NULL) {
            if (chara_no == 0) {
                AnalyzeSharlot(data, map);
            }
            if (chara_no == 1) {
                AnalyzeStera(data, map);
            }
            if (chara_no == 2) {
                AnalyzeBenietio(data, map);
            }
            if (chara_no == 3) {
                AnalyzeHeim(data, map);
            }
            if (chara_no == 4) {
                AnalyzeMoonFlower(data, map);
            }
        }
    }
}
int CountPartsType(int parts_type, CEditMap *map, int *parts_nos, int count) {
    CEditParts *parts;
    int matches;
    int i;

    i = 0;
    matches = 0;
    if (0 < count) {
        do {
            parts = map->GetePlaceParts(parts_nos[i]);
            if ((parts != NULL) && (parts_type == parts->GetPartsType())) {
                matches += 1;
            }
            i += 1;
        } while (i < count);
    }
    return matches;
}
int CountPartsInfoID(int id, CEditMap *map, int *parts_nos, int count) {
    CEditParts *parts;
    int matches;
    int i;

    i = 0;
    matches = 0;
    if (0 < count) {
        do {
            parts = map->GetePlaceParts(parts_nos[i]);
            if ((parts != NULL) && (id == parts->GetInfoID())) {
                matches += 1;
            }
            i += 1;
        } while (i < count);
    }
    return matches;
}
int CheckSaku(CEditMap *map, int parts_no) {
    CEditParts *parts;

    parts = map->GetePlaceParts(parts_no);
    if (parts == NULL) {
        return 0;
    }
    return parts->GetPartsType() == 8;
}
int GetTreeNum(CEditMap *map) {
    int n;

    n = map->GetePlacePartsAtInfoID(7, NULL, 0);
    n += map->GetePlacePartsAtInfoID(0x13, NULL, 0);
    n += map->GetePlacePartsAtInfoID(0x1D, NULL, 0);
    n += map->GetePlacePartsAtInfoID(0x23, NULL, 0);
    n += map->GetePlacePartsAtInfoID(info_tree_a, NULL, 0);
    n += map->GetePlacePartsAtInfoID(info_tree_b, NULL, 0);
    n += map->GetePlacePartsAtInfoID(info_tree_c, NULL, 0);
    return n;
}
int GetHouseParts(CEditMap *map, int *out, int max) {
    HouseInfoIds ids = at_913__6;
    int total = 0;
    for (int i = 0; i < 4; i++) {
        int found = map->GetePlacePartsAtInfoID(ids.id[i], out, max);
        out += found;
        total += found;
        max -= found;
        if (max <= 0) {
            break;
        }
    }
    return total;
}
int CheckInfoID(CEditMap *map, int parts_no, int id) {
    CEditParts *parts;

    parts = map->GetePlaceParts(parts_no);
    if (parts == NULL) {
        return 0;
    }
    return id == parts->GetInfoID();
}
CEditParts *GetPartsPos(CEditMap *map, int parts_no, float *position) {
    if (map == NULL) {
        return NULL;
    }
    CEditParts *parts = map->GetePlaceParts(parts_no);
    if (parts == NULL) {
        return NULL;
    }
    parts->GetPosition(position);
    return parts;
}
void AnalyzeSharlot(CEditData *data, CEditMap *map) {
    int condition[analyze_slots];
    int target[analyze_slots];
    int parts_nos[parts_list_max];
    float river_pos[4];
    float tree_pos[3][4];
    float to_second[4];
    float to_third[4];
    float closest[4];
    int tree_a;
    int tree_b;
    int tree_c;
    int enough_trees;
    int stone_wall;
    int fence;

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = 0;
        target[i] = -1;
    }
    *(u_long128 *)river_pos = *(u_long128 *)at_964__4;
    condition[0] = map->GetRiverNum(river_pos) >= 0xF;
    int tree_count = map->GetePlacePartsAtInfoID(info_tree_a, &parts_nos[0], 1);
    tree_count += map->GetePlacePartsAtInfoID(info_tree_b, &parts_nos[1], 1);
    tree_count += map->GetePlacePartsAtInfoID(info_tree_c, &parts_nos[2], 1);
    while (tree_count == 3) {
        for (int i = 0; i < 3; i++) {
            CEditParts *parts = map->GetePlaceParts(parts_nos[i]);
            if (parts != NULL) {
                parts->GetPosition(tree_pos[i]);
            }
            tree_pos[i][1] = 0.0f;
        }
        sceVu0SubVector(to_second, tree_pos[1], tree_pos[0]);
        sceVu0SubVector(to_third, tree_pos[2], tree_pos[0]);
        float length = mgDistVector(to_second);
        if (length <= 800.0f) {
            sceVu0Normalize(to_second, to_second);
            float along = sceVu0InnerProduct(to_second, to_third) / length;
            if (!(along < 0.0f) && along < 1.0f) {
                if (mgDistLinePoint(tree_pos[2], tree_pos[0], tree_pos[1], closest) <= 100.0f) {
                    condition[1] = 1;
                }
            }
        }
        break;
    }
    int river_total = 0;
    if (map->GetePlacePartsAtInfoID(info_tree_a, &tree_a, 1) != 0) {
        int rivers = map->GetRiverNum(tree_a, 350.0f);
        if (rivers > 6) {
            rivers = 6;
        }
        river_total += rivers;
    }
    if (map->GetePlacePartsAtInfoID(info_tree_b, &tree_b, 1) != 0) {
        int rivers = map->GetRiverNum(tree_b, 350.0f);
        if (rivers > 6) {
            rivers = 6;
        }
        river_total += rivers;
    }
    if (map->GetePlacePartsAtInfoID(info_tree_c, &tree_c, 1) != 0) {
        int rivers = map->GetRiverNum(tree_c, 350.0f);
        if (rivers > 4) {
            rivers = 4;
        }
        river_total += rivers;
    }
    condition[2] = river_total >= 0xF;
    condition[3] = 0;
    target[3] = 2;
    condition[4] = 0;
    target[4] = 0;
    condition[5] = map->CheckLiveNPC(3, -1);
    condition[6] = 0;
    target[6] = 3;
    condition[7] = data->culture_point >= 0x1E;
    condition[8] = map->CheckLiveNPC(0xB, -1);
    condition[9] = map->CheckLiveNPC(0xC, -1);
    condition[10] = map->CheckLiveNPC(0xF, -1);
    enough_trees = GetTreeNum(map) >= 0xA;
    target[12] = 7;
    condition[12] = 0;
    condition[11] = enough_trees;
    condition[13] = map->CheckLiveNPC(-1, 1);
    if (map->GetePlacePartsAtInfoID(info_stone_wall, &stone_wall, 1) > 0) {
        int place_log_max = map->GetChildParts(stone_wall, parts_nos, parts_list_max);
        for (int i = 0; i < place_log_max; i++) {
            if (CheckInfoID(map, parts_nos[i], info_fence) != 0) {
                condition[14] = 1;
            }
        }
    }
    if (map->GetePlacePartsAtInfoID(info_fence, &fence, 1) > 0) {
        int count = map->GetTerritoryParts(fence, parts_nos, parts_list_max);
        int fence_num = 0;
        for (int i = 0; i < count; i++) {
            if (CheckSaku(map, parts_nos[i]) != 0) {
                fence_num++;
            }
        }
        condition[15] = fence_num >= 0xF;
    }
    condition[16] = data->culture_point >= 0x28;
    condition[17] = data->culture_point >= 0x32;
    data->Analize(0, condition, target);
}
void AnalyzeStera(CEditData *data, CEditMap *map) {
    int condition[analyze_slots];
    int target[analyze_slots];
    for (int i = 0; i < analyze_slots; ++i) {
        condition[i] = 0;
        target[i] = -1;
    }
    map->GroundBalance(0);
    condition[0] = map->BalanceCheck();
    condition[1] = data->culture_point >= 20;
    target[2] = 0;
    condition[3] = GetTreeNum(map) >= 15;
    condition[4] = data->culture_point >= 30;
    target[5] = 2;
    condition[6] = map->GetePlacePartsAtInfoID(4, NULL, 0) >= 4;
    condition[7] = map->CheckLiveNPC(18, -1);
    condition[8] = map->CheckLiveNPC(10, -1);
    condition[9] = data->culture_point >= 40;
    condition[10] = map->CheckLiveNPC(7, 73);
    condition[11] = GetSaveData()->GetBitFlag(0x14A);
    condition[12] = map->CheckLiveNPC(5, -1);
    condition[13] = GetSaveData()->GetBitFlag(0x164);
    target[14] = 1;
    condition[15] = map->CheckLiveNPC(-1, -1) >= 2;
    condition[16] = map->GetePlacePartsAtInfoID(74, NULL, 0) > 0;
    condition[17] = map->CheckLiveNPC(14, -1);
    condition[18] = data->culture_point >= 50;
    target[19] = 4;
    data->Analize(EDIT_ANALYZE_MAP_STERA, condition, target);
}

void AnalyzeBenietio(CEditData *data, CEditMap *map) {
    int condition[analyze_slots];
    int target[analyze_slots];
    int parts_nos[parts_list_max];
    int territory[parts_list_max];
    int i;
    CEditParts *parts;
    int slot;
    int count;

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = 0;
        target[i] = -1;
    }
    condition[0] = map->GetePlacePartsAtInfoID(0x35, NULL, 0) >= 8;
    condition[1] = map->CheckLiveNPC(-1, -1) >= 1;
    target[2] = 0;
    count = map->GetePlacePartsAtInfoID(0x1F, parts_nos, parts_list_max);
    for (i = 0; i < count; i++) {
        parts = map->GetePlaceParts(parts_nos[i]);
        if (parts != NULL) {
            CEditPartsInfo *info = parts->info;
            if (info != NULL) {
                int color;
                if (info->paint_num == 1) {
                    color = GetColorType(parts, 0);
                } else {
                    color = GetColorType(parts, 1);
                }
                if (color >= 0) {
                    slot = 3;
                    if (color == 1) {
                        slot = 6;
                    }
                    if (color == 5) {
                        slot = 9;
                    }
                    if (color == 3) {
                        slot = 0xB;
                    }
                    condition[slot] = 1;
                    int territory_count =
                        map->GetTerritoryParts(parts_nos[i], territory, parts_list_max);
                    if (CountPartsInfoID(0x4E, map, territory, territory_count) != 0) {
                        if (slot < 9) {
                            condition[slot + 2] = 1;
                        } else {
                            condition[slot + 1] = 1;
                        }
                    }
                    if (slot == 3) {

                        CEditHouse *extra = parts->house;
                        if (extra == NULL) {
                            continue;
                        }
                        if (extra->npc_no[0] == 8) {
                            condition[slot + 1] = 1;
                        }
                    }
                    if (slot == 6) {
                        CEditHouse *extra = parts->house;
                        if (extra != NULL && extra->npc_no[0] == 4) {
                            condition[slot + 1] = 1;
                        }
                    }
                }
            }
        }
    }
    condition[14] = GetSaveData()->GetBitFlag(0x1BC);
    target[15] = 5;
    condition[16] = map->GetePlacePartsAtInfoID(0x4D, NULL, 0) >= 8;
    condition[17] = map->GetePlacePartsAtInfoID(0x4F, NULL, 0) >= 1;
    condition[18] = data->culture_point >= 0x1E;
    condition[19] = data->culture_point >= 0x32;
    condition[20] = data->culture_point >= 0x3C;
    condition[21] = data->culture_point >= 0x50;
    data->Analize(2, condition, target);
    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = data->analyze.condition[i];
        target[i] = -1;
    }
    int flag1 = data->GetAnalyzeFlag(2, 1);
    int flag2 = data->GetAnalyzeFlag(2, 2);
    int flag3 = data->GetAnalyzeFlag(2, 3);
    int flag4 = data->GetAnalyzeFlag(2, 4);
    condition[13] = flag1 != 0 && flag2 != 0 && flag3 != 0 && flag4 != 0;
    target[15] = 5;
    data->Analize(2, condition, target);
}
int GetColorType(CEditParts *parts, int color_no) {
    float color[4];
    float default_color[4];
    float paint_color[4];
    if (parts == NULL) {
        return -1;
    }
    if (!parts->GetColor(color_no, color)) {
        return -1;
    }
    CEditPartsInfo *info = parts->info;
    if (info == NULL) {
        return -1;
    }
    if (!info->GetDefColor(color_no, default_color)) {
        return -1;
    }
    if (EditPartsCmpColor(color, default_color)) {
        return -1;
    }
    sceVu0ScaleVector(color, color, 128.0f);
    int closest = -1;
    float closest_distance;
    for (int index = 0; index < 8; ++index) {
        GetPenkiColor(index, paint_color);
        float distance = mgDistVector(paint_color, color);
        if (distance <= 2.0f && (closest < 0 || distance < closest_distance)) {
            closest = index;
            closest_distance = distance;
        }
    }
    return closest < 0 ? -1 : closest;
}
void AnalyzeHeim(CEditData *data, CEditMap *map) {
    int condition[analyze_slots];
    int target[analyze_slots];
    int house_nos[parts_list_max];
    int child_nos[parts_list_max];
    float position[4];
    int i;

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = 0;
        target[i] = -1;
    }
    int bit_a = GetSaveData()->GetBitFlag(0x208);
    int bit_b = GetSaveData()->GetBitFlag(0x218);
    int placed = 0;
    int house_num = GetHouseParts(map, house_nos, parts_list_max);
    for (i = 0; i < house_num; i++) {
        CEditParts *parts = map->GetePlaceParts(house_nos[i]);
        if (parts != NULL) {
            parts->GetPosition(position);
            placed++;
            if (!(position[1] < 125.0f)) {
                condition[1] = 1;
            }
            if (!(position[1] < 167.0f) && parts->GetLiveNPC() > 0) {
                condition[16] = 1;
            }
            int has_a = 0;
            int has_b = 0;
            int has_c = 0;
            int has_fence = 0;
            int place_log = map->GetChildParts(house_nos[i], child_nos, parts_list_max);
            if (CountPartsInfoID(0x51, map, child_nos, place_log) > 0) {
                has_a = 1;
            }
            if (CountPartsInfoID(0x52, map, child_nos, place_log) > 0) {
                has_b = 1;
            }
            if (CountPartsType(3, map, child_nos, place_log) > 0) {
                has_c = 1;
            }
            int resident = parts->GetLiveNPC();
            if (has_a != 0 && resident > 0) {
                condition[9] = 1;
            }
            if (has_b != 0 && resident > 0) {
                condition[11] = 1;
            }
            if (has_c != 0 && resident > 0) {
                condition[17] = 1;
            }
            if (CountPartsInfoID(0x4F, map, child_nos,
                                 map->GetTerritoryParts(house_nos[i], child_nos, parts_list_max)) >
                0) {
                has_fence = 1;
            }
            if (has_fence != 0 && resident == 0xD) {
                condition[18] = 1;
            }
        }
    }
    condition[0] = placed >= 3;
    target[3] = 1;
    target[2] = 0;
    condition[4] = map->CheckLiveNPC(2, -1);
    if (map->GetePlacePartsAtInfoID(0x50, NULL, 0) > 0) {
        condition[6] = 1;
    }
    condition[7] = map->CheckLiveNPC(1, -1);
    target[8] = 3;
    condition[10] = map->GetePlacePartsAtInfoID(0x4F, NULL, 0) >= 1;
    target[12] = 6;
    condition[13] =
        map->GetePlacePartsAtInfoID(5, NULL, 0) + map->GetePlacePartsAtInfoID(4, NULL, 0) >= 0xA;
    condition[14] = bit_a;
    condition[15] = map->CheckLiveNPC(0x10, -1);
    condition[19] = bit_b;
    condition[20] = data->culture_point >= 0x1E;
    condition[21] = data->culture_point >= 0x3C;
    condition[22] = data->culture_point >= 0x46;
    condition[23] = data->culture_point >= 0x50;
    condition[24] = data->culture_point >= 0x64;
    target[25] = 2;
    data->Analize(3, condition, target);
    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = data->analyze.condition[i];
        target[i] = -1;
    }
    int flag4 = data->GetAnalyzeFlag(3, 4);
    int flag5 = data->GetAnalyzeFlag(3, 5);
    condition[5] = flag4 != 0 && flag5 != 0;
    target[8] = 3;
    target[12] = 6;
    data->Analize(3, condition, target);
}
#ifdef NONMATCHING
void AnalyzeMoonFlower(CEditData *data, CEditMap *map) {
    int condition[analyze_slots];
    int target[analyze_slots];
    float position[4];
    int parts_nos[parts_list_max];
    int i;

    int count;
    for (count = 0; count < analyze_slots; count++) {
        condition[count] = 0;
        target[count] = -1;
    }
    float center[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    if (map->GetePlacePartsAtInfoID(0x39, parts_nos, parts_list_max) > 0) {
        if (GetPartsPos(map, parts_nos[0], position) && mgDistVector(position, center) < 300.0f) {
            *(u_long128 *)center = *(u_long128 *)position;
            condition[0] = 1;
        }
    }
    int num = map->GetePlacePartsAtInfoID(0x42, parts_nos, parts_list_max);
    count = 0;
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position)) {
            float distance = position[0] - center[0];
            distance = distance < 0.0f ? -distance : distance;
            if (distance < 50.0f) {
                count++;
            }
        }
    }
    if (count >= 8) {
        condition[1] = 1;
    }
    num = map->GetePlacePartsAtInfoID(0x40, parts_nos, parts_list_max);
    count = 0;
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position)) {
            float distance = position[0] - center[0];
            distance = distance < 0.0f ? -distance : distance;
            if (!(distance < 150.0f) && distance <= 250.0f) {
                count++;
            }
        }
    }
    if (count >= 16) {
        condition[2] = 1;
    }
    num = map->GetePlacePartsAtInfoID(0x43, parts_nos, parts_list_max);
    count = 0;
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position)) {
            float distance = position[2] - center[2];
            distance = distance < 0.0f ? -distance : distance;
            if (distance < 50.0f) {
                count++;
            }
        }
    }
    if (count >= 4) {
        condition[3] = 1;
    }
    int east;
    int west = 0;
    east = 0;
    num = map->GetePlacePartsAtInfoID(0x3D, parts_nos, parts_list_max);
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position)) {
            float distance = position[2] - center[2];
            distance = distance < 0.0f ? -distance : distance;
            if (distance <= 100.0f) {
                float side = position[0] - center[0];
                if (!(side <= 50.0f)) {
                    east++;
                } else if (side < -50.0f) {
                    west++;
                }
            }
        }
    }
    condition[4] = east > 0 && west > 0;
    count = 0;
    for (i = 0; i < num; i++) {
        if (map->GetRiverNum(parts_nos[i], 50.0f) > 0) {
            count++;
        }
    }
    if (count >= 2) {
        condition[5] = 1;
    }
    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3E, parts_nos, parts_list_max);
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && (position[0] - center[0]) <= -50.0f && (position[2] - center[2]) <= -50.0f) {
            count++;
        }
    }
    if (count >= 2) {
        condition[6] = 1;
    }
    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3F, parts_nos, parts_list_max);
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && !((position[0] - center[0]) < 50.0f) && (position[2] - center[2]) <= -50.0f) {
            count++;
        }
    }
    if (count >= 1) {
        condition[7] = 1;
    }
    count = 0;
    num = map->GetePlacePartsAtInfoID(0x41, parts_nos, parts_list_max);
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && !((position[0] - center[0]) < 50.0f) && (position[2] - center[2]) <= -50.0f) {
            count++;
        }
    }
    if (count >= 1) {
        condition[8] = 1;
    }
    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3B, parts_nos, parts_list_max);
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && (position[0] - center[0]) <= -50.0f && !((position[2] - center[2]) < 50.0f)) {
            count++;
        }
    }
    if (count >= 1) {
        condition[9] = 1;
    }
    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3C, parts_nos, parts_list_max);
    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && !((position[0] - center[0]) < 50.0f) && !((position[2] - center[2]) < 50.0f)) {
            count++;
        }
    }
    if (count >= 1) {
        condition[10] = 1;
    }
    condition[11] = map->GetePlacePartsAtInfoID(0x44, parts_nos, parts_list_max) >= 2;
    data->Analize(4, condition, target);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editanalyze", AnalyzeMoonFlower__FP9CEditDataP8CEditMap);
#endif
int CheckLiveChara(int map_no, CEditMap *map, int no, int chara) {
    int parts_nos[parts_list_max];
    float position[4];
    CEditParts *parts = map->GetePlaceParts(no);
    if (parts == NULL) return 0;
    CEditPartsInfo *info = parts->info;
    if (info == NULL) return 0;
    parts->GetPosition(position);
    switch (chara) {
    case 1: return 1;
    case 2: return 1;
    case 3:
        if (CountPartsType(2, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) return 1;
        break;
    case 4: return 1;
    case 5:
        if (GetColorType(parts, 1) == 5) return 1;
        if (info->paint_num == 1 && GetColorType(parts, 0) == 5) return 1;
        break;
    case 6: return 1;
    case 7: return 1;
    case 8:
        if (CountPartsType(6, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) <= 0) return 0;
        return 1;
    case 9:
        if (CountPartsInfoID(7, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) return 1;
        break;
    case 10:
        if (map_no == 2) return 0;
        if (map->GetRiverNum(no, 300.0f) > 0) return 0;
        return 1;
    case 11: return 1;
    case 12:
        if (CountPartsInfoID(0x11, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) return 1;
        break;
    case 13: return 1;
    case 14: {
        int num = map->GetTerritoryParts(no, parts_nos, parts_list_max);
        if (CountPartsType(8, map, parts_nos, num) < 7) return 0;
        if (CountPartsType(7, map, parts_nos, num) <= 0) return 0;
        return 1;
    }
    case 15:
        if (parts->GetInfoID() != 1) return 1;
        break;
    case 16:
        if (map->CultureAnalyzeParts(no, 0) >= 20) return 1;
        break;
    case 17:
        if (CountPartsInfoID(0x12, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) return 1;
        break;
    case 18:
        if (parts->GetInfoID() == 0x4B) return 1;
        break;
    case 19:
        if (map_no == 2) {
            if (!(position[1] < 134.0f)) return 1;
        } else if (!(position[1] < 84.0f)) return 1;
        break;
    case 20:
        if (map->GetRiverNum(no, 300.0f) >= 3) return 1;
        break;
    case 21: return 1;
    case 22: return 1;
    case 23:
        if (map_no != 0) return 1;
        break;
    case 24:
        if (parts->GetInfoID() != 0x16) return 0;
        if (GetColorType(parts, 0) != 6) return 0;
        if (CountPartsInfoID(0x12, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) return 1;
        break;
    case 25: return 1;
    }
    return 0;
}
void EditMapInitEvent(int map_no, CEditMap *edit_map) {
    if (edit_map == NULL || map_no < 0) {
        return;
    }
    if (map_no == 14) {
        CFuncPoint *point = edit_map->func_point.Search("dun07");
        int opened = GetSaveData()->GetBitFlag(800);
        if (point != NULL) {
            point->enable = opened;
        }
        CMapParts *parts = edit_map->GetPlaceParts("p02_e05a02-0");
        if (parts != NULL) {
            parts->Show(!opened);
        }
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editanalyze", at_913__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editanalyze", at_964__4__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editanalyze", at_1618__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editanalyze", at_1632__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editanalyze", at_1633__3__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1297__4, 0x10);
