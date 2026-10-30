#include "common.h"

#include "editanalyze.hpp"
#include "editdata.hpp"
#include "editmap.hpp"
#include "editmenu.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "savedata.hpp"
#include "vlgr_info.hpp"

/**
 *
 * Checks the Sharlot town layout against its analysis conditions.
 *
 * @mangled AnalyzeSharlot__FP9CEditDataP8CEditMap
 * @address 0x31C2A0
 * @size 0x54C
 */
static void AnalyzeSharlot(CEditData *data, CEditMap *map);

/**
 *
 * Checks the Stera town layout against its analysis conditions.
 *
 * @mangled AnalyzeStera__FP9CEditDataP8CEditMap
 * @address 0x31C7F0
 * @size 0x230
 */
static void AnalyzeStera(CEditData *data, CEditMap *map);

/**
 *
 * Checks the Benietio town layout against its analysis conditions.
 *
 * @mangled AnalyzeBenietio__FP9CEditDataP8CEditMap
 * @address 0x31CA20
 * @size 0x48C
 */
static void AnalyzeBenietio(CEditData *data, CEditMap *map);

/**
 *
 * Checks the Heim town layout against its analysis conditions.
 *
 * @mangled AnalyzeHeim__FP9CEditDataP8CEditMap
 * @address 0x31CFE0
 * @size 0x564
 */
static void AnalyzeHeim(CEditData *data, CEditMap *map);

/**
 *
 * Checks the Moon Flower town layout against its analysis conditions.
 *
 * @mangled AnalyzeMoonFlower__FP9CEditDataP8CEditMap
 * @address 0x31D550
 * @size 0x884
 */
static void AnalyzeMoonFlower(CEditData *data, CEditMap *map);

/**
 *
 * Classifies a placed part color for the town analysis checks.
 *
 * @mangled GetColorType__FP10CEditPartsi
 * @address 0x31CEB0
 * @size 0x128
 */
static int GetColorType(CEditParts *parts, int no);

const int info_tree_a = 0x28;
const int info_tree_b = 0x29;
const int info_tree_c = 0x2A;
const int info_stone_wall = 0x2B;
const int info_fence = 0x2F;
const int analyze_slots = 64;
const int parts_list_max = 0x200;

void AnalyzeEditMap(int map_no, CEditMap *map) {
    CEditData *data = {};

    if (map != nullptr) {
        data = GetSaveData()->GetEditData(map_no);

        if (data != nullptr) {
            if (map_no == EDIT_ANALYZE_MAP_SHARLOT) {
                AnalyzeSharlot(data, map);
            }

            if (map_no == EDIT_ANALYZE_MAP_STERA) {
                AnalyzeStera(data, map);
            }

            if (map_no == EDIT_ANALYZE_MAP_BENIETIO) {
                AnalyzeBenietio(data, map);
            }

            if (map_no == EDIT_ANALYZE_MAP_HEIM) {
                AnalyzeHeim(data, map);
            }

            if (map_no == EDIT_ANALYZE_MAP_MOON_FLOWER) {
                AnalyzeMoonFlower(data, map);
            }
        }
    }
}

int CountPartsType(int parts_type, CEditMap *map, int *parts_nos, int count) {
    CEditParts *parts = {};
    int         matches = {};
    int         i = {};

    i = 0;
    matches = 0;

    if (0 < count) {
        do {
            parts = map->GetePlaceParts(parts_nos[i]);

            if (parts != nullptr && parts_type == parts->GetPartsType()) {
                matches++;
            }

            i++;
        } while (i < count);
    }

    return matches;
}

int CountPartsInfoID(int info_id, CEditMap *map, int *parts_nos, int count) {
    CEditParts *parts = {};
    int         matches = {};
    int         i = {};

    i = 0;
    matches = 0;

    if (0 < count) {
        do {
            parts = map->GetePlaceParts(parts_nos[i]);

            if (parts != nullptr && info_id == parts->GetInfoID()) {
                matches++;
            }

            i++;
        } while (i < count);
    }

    return matches;
}

/**
 *
 * Checks whether a placed edit part is a fence.
 *
 */
static int CheckSaku(CEditMap *map, int parts_no) {
    CEditParts *parts = {};

    parts = map->GetePlaceParts(parts_no);

    if (parts == nullptr) {
        return false;
    }

    return parts->GetPartsType() == EDIT_PARTS_TYPE_FENCE;
}

/**
 *
 * Counts placed trees across the supported tree part types.
 *
 */
static int GetTreeNum(CEditMap *map) {
    int n = {};

    n = map->GetePlacePartsAtInfoID(7, nullptr, 0);
    n += map->GetePlacePartsAtInfoID(0x13, nullptr, 0);
    n += map->GetePlacePartsAtInfoID(0x1D, nullptr, 0);
    n += map->GetePlacePartsAtInfoID(0x23, nullptr, 0);
    n += map->GetePlacePartsAtInfoID(info_tree_a, nullptr, 0);
    n += map->GetePlacePartsAtInfoID(info_tree_b, nullptr, 0);
    n += map->GetePlacePartsAtInfoID(info_tree_c, nullptr, 0);
    return n;
}

int GetHouseParts(CEditMap *map, int *out, int max) {
    int ids[4] = {1, 9, 0x16, 0x1F};
    int total = 0;

    for (int i = 0; i < 4; i++) {
        int found = map->GetePlacePartsAtInfoID(ids[i], out, max);
        out += found;
        total += found;
        max -= found;

        if (max <= 0) {
            break;
        }
    }

    return total;
}

/**
 *
 * Checks the information identifier of a placed edit part.
 *
 */
static int CheckInfoID(CEditMap *map, int parts_no, int id) {
    CEditParts *parts = {};

    parts = map->GetePlaceParts(parts_no);

    if (parts == nullptr) {
        return false;
    }

    return id == parts->GetInfoID();
}

CEditParts *GetPartsPos(CEditMap *map, int parts_no, float *position) {
    if (map == nullptr) {
        return nullptr;
    }

    CEditParts *parts = map->GetePlaceParts(parts_no);

    if (parts == nullptr) {
        return nullptr;
    }

    parts->GetPosition(position);
    return parts;
}

void AnalyzeSharlot(CEditData *data, CEditMap *map) {
    int condition[analyze_slots];
    int target[analyze_slots];
    int parts_nos[parts_list_max];
    int tree_a = {};
    int tree_b = {};
    int tree_c = {};
    int enough_trees = {};
    int stone_wall = {};
    int fence = {};

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = 0;
        target[i] = -1;
    }

    sceVu0FVECTOR river_pos = {0.0f, 0.0f, 0.0f, -1.0f};
    float         tree_pos[3][4];
    float         to_second[4];
    float         to_third[4];
    float         closest[4];
    condition[0] = map->GetRiverNum(river_pos) >= 0xF;
    int tree_count = map->GetePlacePartsAtInfoID(info_tree_a, &parts_nos[0], 1);
    tree_count += map->GetePlacePartsAtInfoID(info_tree_b, &parts_nos[1], 1);
    tree_count += map->GetePlacePartsAtInfoID(info_tree_c, &parts_nos[2], 1);

    while (tree_count == 3) {
        for (int i = 0; i < 3; i++) {
            CEditParts *parts = map->GetePlaceParts(parts_nos[i]);

            if (parts != nullptr) {
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
                    condition[1] = true;
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
            if (CheckInfoID(map, parts_nos[i], info_fence)) {
                condition[14] = true;
            }
        }
    }

    if (map->GetePlacePartsAtInfoID(info_fence, &fence, 1) > 0) {
        int count = map->GetTerritoryParts(fence, parts_nos, parts_list_max);
        int fence_num = 0;

        for (int i = 0; i < count; i++) {
            if (CheckSaku(map, parts_nos[i])) {
                fence_num++;
            }
        }

        condition[15] = fence_num >= 0xF;
    }

    condition[16] = data->culture_point >= 0x28;
    condition[17] = data->culture_point >= 0x32;
    data->Analize(EDIT_ANALYZE_MAP_SHARLOT, condition, target);
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
    condition[6] = map->GetePlacePartsAtInfoID(4, nullptr, 0) >= 4;
    condition[7] = map->CheckLiveNPC(18, -1);
    condition[8] = map->CheckLiveNPC(10, -1);
    condition[9] = data->culture_point >= 40;
    condition[10] = map->CheckLiveNPC(7, 73);
    condition[11] = GetSaveData()->GetBitFlag(0x14A);
    condition[12] = map->CheckLiveNPC(5, -1);
    condition[13] = GetSaveData()->GetBitFlag(0x164);
    target[14] = 1;
    condition[15] = map->CheckLiveNPC(-1, -1) >= 2;
    condition[16] = map->GetePlacePartsAtInfoID(74, nullptr, 0) > 0;
    condition[17] = map->CheckLiveNPC(14, -1);
    condition[18] = data->culture_point >= 50;
    target[19] = 4;
    data->Analize(EDIT_ANALYZE_MAP_STERA, condition, target);
}

void AnalyzeBenietio(CEditData *data, CEditMap *map) {
    int         condition[analyze_slots];
    int         target[analyze_slots];
    int         parts_nos[parts_list_max];
    int         territory[parts_list_max];
    int         i = {};
    CEditParts *parts = {};
    int         slot = {};
    int         count = {};

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = 0;
        target[i] = -1;
    }

    condition[0] = map->GetePlacePartsAtInfoID(0x35, nullptr, 0) >= 8;
    condition[1] = map->CheckLiveNPC(-1, -1) >= 1;
    target[2] = 0;
    count = map->GetePlacePartsAtInfoID(0x1F, parts_nos, parts_list_max);

    for (i = 0; i < count; i++) {
        parts = map->GetePlaceParts(parts_nos[i]);

        if (parts != nullptr) {
            CEditPartsInfo *info = parts->info;

            if (info != nullptr) {
                int color = {};

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

                    condition[slot] = true;
                    int territory_count =
                        map->GetTerritoryParts(parts_nos[i], territory, parts_list_max);

                    if (CountPartsInfoID(0x4E, map, territory, territory_count) != 0) {
                        if (slot < 9) {
                            condition[slot + 2] = true;
                        } else {
                            condition[slot + 1] = true;
                        }
                    }

                    if (slot == 3) {

                        CEditHouse *extra = parts->house;

                        if (extra == nullptr) {
                            continue;
                        }

                        if (extra->npc_no[0] == 8) {
                            condition[slot + 1] = true;
                        }
                    }

                    if (slot == 6) {
                        CEditHouse *extra = parts->house;

                        if (extra != nullptr && extra->npc_no[0] == 4) {
                            condition[slot + 1] = true;
                        }
                    }
                }
            }
        }
    }

    condition[14] = GetSaveData()->GetBitFlag(0x1BC);
    target[15] = 5;
    condition[16] = map->GetePlacePartsAtInfoID(0x4D, nullptr, 0) >= 8;
    condition[17] = map->GetePlacePartsAtInfoID(0x4F, nullptr, 0) >= 1;
    condition[18] = data->culture_point >= 0x1E;
    condition[19] = data->culture_point >= 0x32;
    condition[20] = data->culture_point >= 0x3C;
    condition[21] = data->culture_point >= 0x50;
    data->Analize(EDIT_ANALYZE_MAP_BENIETIO, condition, target);

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = data->analyze.condition[i];
        target[i] = -1;
    }

    int flag1 = data->GetAnalyzeFlag(EDIT_ANALYZE_MAP_BENIETIO, 1);
    int flag2 = data->GetAnalyzeFlag(EDIT_ANALYZE_MAP_BENIETIO, 2);
    int flag3 = data->GetAnalyzeFlag(EDIT_ANALYZE_MAP_BENIETIO, 3);
    int flag4 = data->GetAnalyzeFlag(EDIT_ANALYZE_MAP_BENIETIO, 4);
    condition[13] = flag1 && flag2 && flag3 && flag4;
    target[15] = 5;
    data->Analize(EDIT_ANALYZE_MAP_BENIETIO, condition, target);
}

int GetColorType(CEditParts *parts, int color_no) {
    float color[4];
    float default_color[4];
    float paint_color[4];

    if (parts == nullptr) {
        return -1;
    }

    if (!parts->GetColor(color_no, color)) {
        return -1;
    }

    CEditPartsInfo *info = parts->info;

    if (info == nullptr) {
        return -1;
    }

    if (!info->GetDefColor(color_no, default_color)) {
        return -1;
    }

    if (EditPartsCmpColor(color, default_color)) {
        return -1;
    }

    sceVu0ScaleVector(color, color, 128.0f);
    int   closest = -1;
    float closest_distance{};

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
    int   condition[analyze_slots];
    int   target[analyze_slots];
    int   house_nos[parts_list_max];
    int   child_nos[parts_list_max];
    float position[4];
    int   i = {};

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = 0;
        target[i] = -1;
    }

    int bit_a = GetSaveData()->GetBitFlag(SAVE_FLAG_HEIM_FIRE_OUT);
    int bit_b = GetSaveData()->GetBitFlag(0x218);
    int placed = 0;
    int house_num = GetHouseParts(map, house_nos, parts_list_max);

    for (i = 0; i < house_num; i++) {
        CEditParts *parts = map->GetePlaceParts(house_nos[i]);

        if (parts != nullptr) {
            parts->GetPosition(position);
            placed++;

            if (!(position[1] < 125.0f)) {
                condition[1] = true;
            }

            if (!(position[1] < 167.0f) && parts->GetLiveNPC() > 0) {
                condition[16] = true;
            }

            int has_a = false;
            int has_b = false;
            int has_c = false;
            int has_fence = false;
            int place_log = map->GetChildParts(house_nos[i], child_nos, parts_list_max);

            if (CountPartsInfoID(0x51, map, child_nos, place_log) > 0) {
                has_a = true;
            }

            if (CountPartsInfoID(0x52, map, child_nos, place_log) > 0) {
                has_b = true;
            }

            if (CountPartsType(3, map, child_nos, place_log) > 0) {
                has_c = true;
            }

            int resident = parts->GetLiveNPC();

            if (has_a && resident > 0) {
                condition[9] = true;
            }

            if (has_b && resident > 0) {
                condition[11] = true;
            }

            if (has_c && resident > 0) {
                condition[17] = true;
            }

            if (CountPartsInfoID(0x4F, map, child_nos,
                                 map->GetTerritoryParts(house_nos[i], child_nos, parts_list_max)) >
                0) {
                has_fence = true;
            }

            if (has_fence && resident == 0xD) {
                condition[18] = true;
            }
        }
    }

    condition[0] = placed >= 3;
    target[3] = 1;
    target[2] = 0;
    condition[4] = map->CheckLiveNPC(2, -1);

    if (map->GetePlacePartsAtInfoID(0x50, nullptr, 0) > 0) {
        condition[6] = true;
    }

    condition[7] = map->CheckLiveNPC(1, -1);
    target[8] = 3;
    condition[10] = map->GetePlacePartsAtInfoID(0x4F, nullptr, 0) >= 1;
    target[12] = 6;
    condition[13] =
        map->GetePlacePartsAtInfoID(5, nullptr, 0) + map->GetePlacePartsAtInfoID(4, nullptr, 0) >= 0xA;
    condition[14] = bit_a;
    condition[15] = map->CheckLiveNPC(0x10, -1);
    condition[19] = bit_b;
    condition[20] = data->culture_point >= 0x1E;
    condition[21] = data->culture_point >= 0x3C;
    condition[22] = data->culture_point >= 0x46;
    condition[23] = data->culture_point >= 0x50;
    condition[24] = data->culture_point >= 0x64;
    target[25] = 2;
    data->Analize(EDIT_ANALYZE_MAP_HEIM, condition, target);

    for (int i = 0; i < analyze_slots; i++) {
        condition[i] = data->analyze.condition[i];
        target[i] = -1;
    }

    int flag4 = data->GetAnalyzeFlag(EDIT_ANALYZE_MAP_HEIM, 4);
    int flag5 = data->GetAnalyzeFlag(EDIT_ANALYZE_MAP_HEIM, 5);
    condition[5] = flag4 && flag5;
    target[8] = 3;
    target[12] = 6;
    data->Analize(EDIT_ANALYZE_MAP_HEIM, condition, target);
}

void AnalyzeMoonFlower(CEditData *data, CEditMap *map) {
    int   condition[analyze_slots];
    int   target[analyze_slots];
    float position[4];
    int   parts_nos[parts_list_max];
    int   i = {};
    int   hits = {};
    int   num = {};
    int   count = {};

    for (count = 0; count < analyze_slots; count++) {
        condition[count] = 0;
        target[count] = -1;
    }

    float center[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    num = map->GetePlacePartsAtInfoID(0x39, parts_nos, parts_list_max);

    if (num > 0) {
        if (GetPartsPos(map, parts_nos[0], position) && mgDistVector(position, center) < 300.0f) {
            *reinterpret_cast<u_long128 *>(center) = *reinterpret_cast<u_long128 *>(position);
            condition[0] = true;
        }
    }

    num = map->GetePlacePartsAtInfoID(0x42, parts_nos, parts_list_max);
    hits = 0;

    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position)) {
            float distance = position[0] - center[0];
            distance = distance < 0.0f ? -distance : distance;

            if (distance < 50.0f) {
                hits++;
            }
        }
    }

    if (hits >= 8) {
        condition[1] = true;
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
        condition[2] = true;
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
        condition[3] = true;
    }

    int east = {};
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
    hits = 0;

    for (i = 0; i < num; i++) {
        int no = parts_nos[i];

        if (map->GetRiverNum(no, 50.0f) > 0) {
            hits++;
        }
    }

    if (hits >= 2) {
        condition[5] = true;
    }

    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3E, parts_nos, parts_list_max);

    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && (position[0] - center[0]) <= -50.0f && (position[2] - center[2]) <= -50.0f) {
            count++;
        }
    }

    if (count >= 2) {
        condition[6] = true;
    }

    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3F, parts_nos, parts_list_max);

    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && !((position[0] - center[0]) < 50.0f) && (position[2] - center[2]) <= -50.0f) {
            count++;
        }
    }

    if (count >= 1) {
        condition[7] = true;
    }

    count = 0;
    num = map->GetePlacePartsAtInfoID(0x41, parts_nos, parts_list_max);

    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && !((position[0] - center[0]) < 50.0f) && (position[2] - center[2]) <= -50.0f) {
            count++;
        }
    }

    if (count >= 1) {
        condition[8] = true;
    }

    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3B, parts_nos, parts_list_max);

    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && (position[0] - center[0]) <= -50.0f && !((position[2] - center[2]) < 50.0f)) {
            count++;
        }
    }

    if (count >= 1) {
        condition[9] = true;
    }

    count = 0;
    num = map->GetePlacePartsAtInfoID(0x3C, parts_nos, parts_list_max);

    for (i = 0; i < num; i++) {
        if (GetPartsPos(map, parts_nos[i], position) && !((position[0] - center[0]) < 50.0f) && !((position[2] - center[2]) < 50.0f)) {
            count++;
        }
    }

    if (count >= 1) {
        condition[10] = true;
    }

    condition[11] = map->GetePlacePartsAtInfoID(0x44, parts_nos, parts_list_max) >= 2;
    data->Analize(EDIT_ANALYZE_MAP_MOON_FLOWER, condition, target);
}

int CheckLiveChara(int map_no, CEditMap *map, int no, int chara) {
    int         parts_nos[parts_list_max];
    float       position[4];
    CEditParts *parts = map->GetePlaceParts(no);

    if (parts == nullptr) {
        return false;
    }

    CEditPartsInfo *info = parts->info;

    if (info == nullptr) {
        return false;
    }

    parts->GetPosition(position);

    switch (chara) {
        case 1:
            return true;
        case 2:
            return true;
        case 3:
            if (CountPartsType(2, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) {
                return true;
            }

            break;
        case 4:
            return true;
        case 5:
            if (GetColorType(parts, 1) == 5) {
                return true;
            }

            if (info->paint_num == 1 && GetColorType(parts, 0) == 5) {
                return true;
            }

            break;
        case 6:
            return true;
        case 7:
            return true;
        case 8:
            if (CountPartsType(6, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) <= 0) {
                return false;
            }

            return true;
        case 9:
            if (CountPartsInfoID(7, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) {
                return true;
            }

            break;
        case 10:
            if (map_no == 2) {
                return false;
            }

            if (map->GetRiverNum(no, 300.0f) > 0) {
                return false;
            }

            return true;
        case 11:
            return true;
        case 12:
            if (CountPartsInfoID(0x11, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) {
                return true;
            }

            break;
        case 13:
            return true;
        case 14: {
            int num = map->GetTerritoryParts(no, parts_nos, parts_list_max);

            if (CountPartsType(8, map, parts_nos, num) < 7) {
                return false;
            }

            if (CountPartsType(7, map, parts_nos, num) <= 0) {
                return false;
            }

            return true;
        }
        case 15:
            if (parts->GetInfoID() != 1) {
                return true;
            }

            break;
        case 16:
            if (map->CultureAnalyzeParts(no, 0) >= 20) {
                return true;
            }

            break;
        case 17:
            if (CountPartsInfoID(0x12, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) {
                return true;
            }

            break;
        case 18:
            if (parts->GetInfoID() == 0x4B) {
                return true;
            }

            break;
        case 19:
            if (map_no == 2) {
                if (!(position[1] < 134.0f)) {
                    return true;
                }
            } else if (!(position[1] < 84.0f)) {
                return true;
            }

            break;
        case 20:
            if (map->GetRiverNum(no, 300.0f) >= 3) {
                return true;
            }

            break;
        case 21:
            return true;
        case 22:
            return true;
        case 23:
            if (map_no != 0) {
                return true;
            }

            break;
        case 24:
            if (parts->GetInfoID() != 0x16) {
                return false;
            }

            if (GetColorType(parts, 0) != 6) {
                return false;
            }

            if (CountPartsInfoID(0x12, map, parts_nos, map->GetTerritoryParts(no, parts_nos, parts_list_max)) > 0) {
                return true;
            }

            break;
        case 25:
            return true;
    }

    return false;
}

void EditMapInitEvent(int map_no, CEditMap *edit_map) {
    if (edit_map == nullptr || map_no < 0) {
        return;
    }

    if (map_no == 14) {
        CFuncPoint *point = edit_map->func_point.Search("dun07");
        int         opened = GetSaveData()->GetBitFlag(SAVE_FLAG_CHAPTER_8_STARTED);

        if (point != nullptr) {
            point->enable = opened;
        }

        CMapParts *parts = edit_map->GetPlaceParts("p02_e05a02-0");

        if (parts != nullptr) {
            parts->Show(!opened);
        }
    }
}
