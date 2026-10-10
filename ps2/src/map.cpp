#include "common.h"
#include "mw_runtime.h"

#include <cstring>

#include "collision.hpp"
#include "funcpoint.hpp"
#include "map.hpp"
#include "mapinfo.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"

enum {
    kFuncPointHasFire = 2,
    kFuncPointHasPLight = 0x40,
    kMapPartsSize = 0x310
};

#include <cmath>
#include <cstdio>
#include <cstdlib>

#include "dataread.hpp"
#include "mg_camera.hpp"
#include "mg_drawprim.hpp"
#include "water.hpp"

/**
 * Class name returned by the map object.
 */
char *CMapName = "CMap";

// Code (.text)
int CMapFlagData::SetFlag(int no, int on) {
    u32 mask;
    u32 old_flag;

    if (no < 0 || no >= MAP_FLAG_MAX) {
        return 0;
    }

    mask = 1;
    int index = no / 32;
    mask <<= no % 32;
    old_flag = flag[index];
    int was_set = (mask & old_flag) != 0;

    if (on) {
        flag[index] = mask | old_flag;
    } else {
        flag[index] = ~mask & old_flag;
    }

    return was_set;
}

int CMapFlagData::GetFlag(int index) {
    if (index < 0 || index >= MAP_FLAG_MAX) {
        return 0;
    }

    u32 mask = 1;
    mask <<= index % 32;
    return (mask & flag[index / 32]) != 0;
}

char *CMap::Iam() {
    return CMapName;
}

void CPartsGroup::Initialize() {
    name = 0;
    camera_off = 0;
    off = 0;
    list = 0;
}

void CPartsGroup::Add(CList<PartsGroupData> *node) {
    CList<PartsGroupData> *last = list;
    CList<PartsGroupData> *next;

    if (last == 0) {
        list = node;
        return;
    }

    if (last != 0) {
        do {
            next = last->next;

            if (next == 0) {
                break;
            }

            last = next;
        } while (next != 0);
    }

    last->next = node;

    if (node != 0) {
        node->prev = last;
    }
}

void CMapWater::Initialize() {
    frame = NULL;
    *(u_long128 *) follow = 0;
    parts = NULL;
    parts_max = 0;
    parts_num = 0;
    parts_name = NULL;
}

void CMapWater::Clear() {
    int i;

    parts_num = 0;

    if (parts != NULL) {
        for (i = 0; i < parts_max; i++) {
            parts[i] = NULL;
        }
    }
}

CPartsGroup *CMap::GetPartsGroup(int no) {
    if (no < 0 || no >= parts_group_max) {
        return NULL;
    }

    return &parts_group[no];
}

int CMap::AddPartsGroup(char *name, CMapParts *parts, mgCMemory *memory) {
    int                    group_no;
    char                  *new_name;
    CPartsGroup           *group;
    CList<PartsGroupData> *node;
    group_no = SearchPartsGroupNo(name);
    new_name = 0;

    if (group_no < 0) {
        group_no = SerachEmptyPartsGroupNo();
        new_name = mgCopyString(name, memory);
    }

    group = GetPartsGroup(group_no);

    if (group == 0) {
        return -1;
    }

    if (new_name != 0) {
        group->name = new_name;
    }

    node = new (memory->Alloc(sizeof(CList<PartsGroupData>) / 16 + 2)) CList<PartsGroupData>;

    node->data.parts = parts;
    group->Add(node);
    return group_no;
}

template <>
void CList<PartsGroupData>::Initialize() {
    prev = 0;
    next = 0;
}

CPartsGroup *CMap::SearchPartsGroup(char *name) {
    return GetPartsGroup(SearchPartsGroupNo(name));
}

int CMap::SearchPartsGroupNo(char *name) {
    int i;

    for (i = 0; i < parts_group_max; i++) {

        u8 used = !!parts_group[i].name ^ 1;

        if (!used && strcmp(parts_group[i].name, name) == 0) {
            return i;
        }
    }

    return -1;
}

int CMap::SerachEmptyPartsGroupNo() {
    int i;

    for (i = 0; i < parts_group_max; i++) {
        u8 e = !!parts_group[i].name ^ 1;

        if (e) {
            return i;
        }
    }

    return -1;
}

void CMap::Initialize() {
    int i;
    int j;
    int k;
    parts_list = 0;
    effect_list.pack = 0;
    effect_list.name = 0;
    effect_list.block = -1;
    effect_list.effect_num = 0;
    effect_list.managers = 0;
    effect_list.sprites = 0;
    place_parts = 0;
    place_parts_max = 0;
    draw_parts_num = 0;
    draw_parts = 0;
    mds_list_set = 0;
    camera_info_num = 0;
    camera_info = 0;
    draw_rect_max = MAP_DRAW_RECT_MAX;

    for (i = 0; i < MAP_DRAW_RECT_MAX; i++) {
        draw_rect[i].outside = 0;
        draw_rect[i].used = 0;
        draw_rect[i].parts = 0;
    }

    parts_group_max = MAP_PARTS_GROUP_MAX;

    for (j = 0; j < MAP_PARTS_GROUP_MAX; j++) {
        parts_group[j].Initialize();
    }

    parts_event = 0;
    func_point.Initialize();
    obj_anime_num = 0;
    obj_anime = 0;
    tr_box_num = 0;
    tr_box = 0;
    tr_box_texture = -1;
    tr_box_model = 0;
    unk_30c = 0;
    now_time = 0;
    water_surface_num = 0;
    water_surface = 0;
    water_num = 0;
    water = 0;
    fire_raster = 0;
    anime_time = 0;
    anime_frame = 0;
    occlusion_num = 0;

    for (k = 0; k < MAP_OCCLUSION_MAX; k++) {
        memset(&occlusion[k], 0, sizeof(COcclusion));
    }

    bbox_valid = 0;
    mgZeroVectorW(bbox.max);
    mgZeroVectorW(bbox.min);
    piece_load_skip = 0;
}

/**
 *
 * Rounds a byte count up to the number of 16-byte map allocation blocks.
 *
 */
static inline unsigned int map_alloc_size(unsigned int bytes) {
    if (bytes & 0xF) {
        return (bytes >> 4) + 1;
    } else {
        return bytes >> 4;
    }
}

void CMap::SetPlacePartsBuff(mgCMemory *stack, int max) {
    unsigned int list_bytes;
    u_long128   *block = stack->Alloc(map_alloc_size((u_int) max * sizeof(CMapParts)) + 2);
    place_parts = new (block) CMapParts[max];
    list_bytes = max << 2;
    block = stack->Alloc(map_alloc_size(list_bytes) + 2);
    draw_parts = (CMapParts **) new (block) char[list_bytes];
    place_parts_max = max;
    ClearPlaceParts();
}

CMapParts::CMapParts() { Initialize(); }

CMapParts *CMap::GetPlacPartsTable(int *out_max) {
    *out_max = place_parts_max;
    return place_parts;
}

void CMap::SetCameraInfoTable(CCameraInfo *table, int num) {
    camera_info_num = num;
    camera_info = table;
}

CCameraInfo *CMap::GetCameraInfo(int no) {
    if (no < 0 || no >= camera_info_num) {
        return NULL;
    }

    return &camera_info[no];
}

CMapParts *CMap::NewPlaceParts() {
    for (int i = 0; i < place_parts_max; i++) {
        u8 unused = place_parts[i].name[0] == 0;

        if (unused) {
            return &place_parts[i];
        }
    }

    return NULL;
}

CMdsInfo *CMap::SearchMDS(char *name) {
    CMdsInfo *model;

    model = NULL;

    if (mds_list_set != NULL) {
        model = mds_list_set->SearchMDS(name);
    }

    return model;
}

void CMap::CreateEffect(unsigned int *pack, int tex_block, mgCMemory *stack) {
    effect_list.LoadEFPFile("test", pack, tex_block, stack);
}

int CMap::SaerchEffectIndex(char *name) {
    return effect_list.SaerchEffectIndex(name);
}

void CMap::AddParts(CList<CMapParts> *node) {
    CList<CMapParts> *last;
    CList<CMapParts> *next;

    if (node != 0) {
        last = parts_list;

        if (last != 0) {
            if (last != 0) {
                do {
                    next = last->next;

                    if (next == 0) {
                        break;
                    }

                    last = next;
                } while (next != 0);
            }

            last->next = node;

            if (node != 0) {
                node->prev = last;
            }
        } else {
            parts_list = node;
        }
    }
}

CMapParts *CMap::GetParts(char *name) {
    CList<CMapParts> *entry;
    CMapParts        *parts;

    if (name == NULL || name[0] == 0) {
        return NULL;
    }

    for (entry = parts_list; entry != NULL; entry = entry->next) {
        parts = &entry->data;

        if (parts != NULL && parts->name != NULL && strcasecmp(name, parts->name) == 0) {
            return parts;
        }
    }

    return NULL;
}

void CMap::CreateDrawRect(mgCMemory *memory, mgVu0FBOX *rect, mgVu0FBOX *clip, int outside) {
    mgVu0FBOX           parts_box;
    MapDrawOffRect     *slot;
    CMapParts          *parts;
    int                 i;
    int                 j;
    CList<CMapParts *> *node;
    CList<CMapParts *> *last;
    CList<CMapParts *> *next;
    slot = 0;

    for (i = 0; i < draw_rect_max; i++) {
        if (draw_rect[i].used == 0) {
            slot = &draw_rect[i];
            break;
        }
    }

    rect->max[3] = 1.0f;
    rect->min[3] = 1.0f;
    clip->max[3] = 1.0f;
    clip->min[3] = 1.0f;

    if (slot != 0) {
        slot->used = 1;
        slot->area = *rect;
        slot->outside = outside;
        parts = place_parts;

        for (j = 0; j < place_parts_max; j++, parts++) {
            u8 unused = parts->name[0] == 0;

            if (unused) {
                continue;
            }

            if (parts->GetBoundBox(&parts_box) == 0) {
                continue;
            }

            if (mgClipInBox(parts_box.max, parts_box.min, clip->max, clip->min) == 0) {
                continue;
            }

            node = new (memory->Alloc(sizeof(CList<CMapParts *>) / 16 + 2)) CList<CMapParts *>;

            node->data = parts;
            last = slot->parts;

            if (last == 0) {
                slot->parts = node;
            } else {
                if (last != 0) {
                    do {
                        next = last->next;

                        if (next == 0) {
                            break;
                        }

                        last = next;
                    } while (next != 0);
                }

                last->next = node;

                if (node != 0) {
                    node->prev = last;
                }
            }
        }
    }
}

template <>
void CList<CMapParts *>::Initialize() {
    prev = 0;
    next = 0;
}

void CMap::CreateOcclusion(float (*corner)[4]) {
    if (occlusion_num < MAP_OCCLUSION_MAX) {
        occlusion[occlusion_num].enable = 1;
        *(u_long128 *) occlusion[occlusion_num].vertex[0] = *(u_long128 *) corner[0];
        *(u_long128 *) occlusion[occlusion_num].vertex[1] = *(u_long128 *) corner[1];
        *(u_long128 *) occlusion[occlusion_num].vertex[2] = *(u_long128 *) corner[2];
        *(u_long128 *) occlusion[occlusion_num].vertex[3] = *(u_long128 *) corner[3];
        occlusion_num++;
    }
}

CMapParts *CMap::PlaceParts(char *name, float *pos, float *rot, float *scale, mgCMemory *stack) {
    CMapParts *model;
    CMapParts *parts;

    model = GetParts(name);

    if (model == NULL) {
        return NULL;
    }

    parts = NewPlaceParts();

    if (parts == NULL) {
        return NULL;
    }

    model->Copy(*parts, stack);
    parts->SetPosition(pos);
    parts->SetRotation(rot);
    parts->SetScale(scale);
    return parts;
}

void CMap::PlacePartsEnd() {
    mgVu0FBOX bounds;

    {
        int        water_index;
        CMapWater *surface;

        for (water_index = 0; water_index < water_num; water_index++) {
            surface = &water[water_index];

            if (surface->frame != NULL && surface->parts_name == NULL) {
                surface->parts[surface->parts_num++] = NULL;
            }
        }
    }
    int        parts_index;
    int        water_index;
    CMapWater *surface;
    CMapParts *parts;
    char      *name;
    place_parts_num = place_parts_max;

    for (parts_index = 0; parts_index < place_parts_max; parts_index++) {
        parts = &place_parts[parts_index];
        u8 unused = parts->name[0] == 0;

        if (!unused) {
            place_parts_num = parts_index + 1;
        }

        if (parts->GetBoundBox(&bounds)) {
            if (!bbox_valid) {
                bbox = bounds;
                bbox_valid = 1;
            } else {
                mgBoxMaxMin(&bbox, &bounds);
            }
        }

        name = parts->parts_name;

        if (name != NULL) {
            for (water_index = 0; water_index < water_num; water_index++) {
                surface = &water[water_index];

                if (surface->frame != NULL && surface->parts_name != NULL && strcmp(surface->parts_name, name) == 0) {
                    if (surface->parts_num < surface->parts_max) {
                        surface->parts[surface->parts_num++] = parts;
                    }
                }
            }
        }
    }
}

void CMap::ClearPlaceParts() {
    int i;
    int j;
    place_parts_num = place_parts_max;

    for (i = 0; i < place_parts_max; i++) {
        place_parts[i].Initialize();
        draw_parts[i] = 0;
    }

    for (j = 0; j < water_num; j++) {
        water[j].Clear();
    }
}

CMapParts *CMap::GetPlaceParts(char *name) {
    int i;

    for (i = 0; i < place_parts_num; i++) {
        if (strcmp(name, place_parts[i].name) == 0) {
            return &place_parts[i];
        }
    }

    return NULL;
}

CMapParts *CMap::GetPlaceParts(int no) {
    if (no < 0 || place_parts_num < no) {
        return NULL;
    }

    return &place_parts[no];
}

int CMap::ConvertParts(CMapParts *parts) {
    int no;

    no = -1;

    if (parts != NULL) {
        no = parts - place_parts;
    }

    return no;
}

int CMap::GetPlaceParts(mgVu0FBOX *box, CMapParts **out_parts, int max) {
    mgVu0FBOX  bounds;
    CMapParts *parts;
    int        count;
    int        i;
    int        out_index;

    if (box == 0) {
        return 0;
    }

    parts = place_parts;
    count = 0;
    i = 0;
    out_index = 0;

    for (; i < place_parts_num; i++, parts++) {
        u8 unused = parts->name[0] == 0;

        if (unused) {
            continue;
        }

        if (parts->GetBoundBox(&bounds) == 0) {
            continue;
        }

        if (mgClipBox(bounds.max, bounds.min, box->max, box->min) == 0) {
            continue;
        }

        count++;
        out_parts[out_index++] = parts;

        if (count >= max) {
            break;
        }
    }

    return count;
}

int CMap::GetPlaceColParts(mgVu0FBOX *box, CMapParts **out, int max) {
    CMapParts *parts;
    int        effect_num;
    int        i;
    int        out_index;

    if (box == 0) {
        return 0;
    }

    parts = place_parts;
    effect_num = 0;
    i = 0;
    out_index = 0;

    for (; i < place_parts_num; i++, parts++) {
        u8 unused = parts->name[0] == 0;

        if (unused) {
            continue;
        }

        if ((parts)->CheckColBox(box) == 0) {
            continue;
        }

        effect_num++;
        out[out_index++] = parts;

        if (effect_num >= max) {
            break;
        }
    }

    return effect_num;
}

void CMap::CreateFuncCheck(CFuncPointCheck *check) {
    check->time = GetNowTime();
    check->anime_frame = anime_frame;
}

int CMap::GetBBox(mgVu0FBOX *out_box) {
    *out_box = bbox;
    return bbox_valid;
}

int CMap::PreDraw(float *view_pos) {
    CMapParts          *parts;
    MapDrawOffRect     *rect;
    CList<CMapParts *> *rect_entry;
    CList<CMapPiece>   *piece;
    int                 active_occlusion;
    int                 index;

    if (bbox_valid != 0 && mgInsideScreen(&bbox) == 0) {
        draw_parts_num = 0;
        return 0;
    }

    active_occlusion = 0;

    for (index = 0; index < occlusion_num; index++) {
        COcclusion *current = &occlusion[index];

        if (current->enable != 0) {
            current->Setup(mgRenderInfo.view);
            active_occlusion++;
        }
    }

    CFuncPointCheck check;
    CreateFuncCheck(&check);
    func_point.UpdateFlag(FUNC_POINT_FIRE, &check);
    func_point.UpdateFlag(FUNC_POINT_FLARE, &check);
    func_point.Step(FUNC_POINT_PLIGHT, &check);
    func_point.UpdateFlag(FUNC_POINT_EFFECT, &check);

    parts = place_parts;

    for (index = 0; index < place_parts_num; index++, parts++) {
        if (active_occlusion > 0) {
            parts->in_screen = parts->InsideScreen(occlusion, occlusion_num);
        } else {
            parts->in_screen = parts->InsideScreen();
        }

        if (parts->in_screen != 0) {
            parts->StepFuncPoint(check);
        }
    }

    rect = draw_rect;

    for (index = 0; index < draw_rect_max; index++, rect++) {
        if (rect->used != 0) {
            if (rect->outside == 0) {
                if (!(!(view_pos[0] < rect->area.min[0]) && !(view_pos[1] < rect->area.min[1]) && !(view_pos[2] < rect->area.min[2]) && view_pos[0] <= rect->area.max[0] && view_pos[1] <= rect->area.max[1])) {
                    continue;
                }

                do {
                    if (!(view_pos[2] <= rect->area.max[2])) {
                        break;
                    }

                    goto hide_parts;
                } while (0);

                continue;
            }

            if (!(view_pos[0] <= rect->area.min[0]) && !(view_pos[1] <= rect->area.min[1]) && !(view_pos[2] <= rect->area.min[2]) && view_pos[0] < rect->area.max[0] && view_pos[1] < rect->area.max[1] && view_pos[2] < rect->area.max[2]) {
                continue;
            }

        hide_parts: {
            for (rect_entry = rect->parts; rect_entry != NULL; rect_entry = rect_entry->next) {
                if (rect_entry->data != NULL) {
                    rect_entry->data->in_screen = 0;
                }
            }
        }
        }
    }

    {
        int                    group_num = parts_group_max;
        CPartsGroup           *group = parts_group;
        int                    group_no = 0;
        CList<PartsGroupData> *group_entry;

        if (0 < group_num) {
            do {
                u8 unused = (group->name != NULL) ^ 1;

                if (!unused && (group->camera_off != 0 || group->off != 0)) {
                    for (group_entry = group->list; group_entry != NULL; group_entry = group_entry->next) {
                        if (group_entry->data.parts != NULL) {
                            group_entry->data.parts->in_screen = 0;
                        }
                    }

                    group->camera_off = 0;
                }

                group_no++;
                group++;
            } while (group_no < group_num);
        }
    }

    draw_parts_num = 0;

    if (draw_parts == NULL) {
        return 0;
    }

    parts = place_parts;

    for (index = 0; index < place_parts_num; index++, parts++) {
        u8 is_empty = parts->name[0] == 0;

        if (is_empty == 0) {
            if (parts->in_screen != 0) {
                draw_parts[draw_parts_num] = parts;
                draw_parts_num++;
            } else {
                for (piece = parts->piece_list; piece != NULL; piece = piece->next) {
                    piece->data.fade_alpha = -1.0f;
                }
            }
        }
    }

    return 1;
}

int CMap::GetCharaLight(mgCObject *chara, CFuncPoint *points, int max, int use_parts) {
    sceVu0FVECTOR chara_position;
    sceVu0FVECTOR direction;
    sceVu0FVECTOR color;
    float         attenuation;
    int           light_num;
    int           light_mode;

    if (max <= 0) {
        return 0;
    }

    CFuncPointCheck check;
    CreateFuncCheck(&check);
    chara->GetPosition(chara_position);
    chara_position[3] = 0.0f;
    chara_position[1] += 20.0f;
    light_mode = 1;

    if (use_parts != 0) {
        light_mode |= 0x2;
    }

    light_num = func_point.GetLight(chara_position, points, max, &check, light_mode);

    if (2 < light_num) {
        light_num = 2;
    }

    for (int index = 0; index < light_num; index++) {
        sceVu0SubVector(direction, points[index].position, chara_position);
        attenuation = points[index].plight.power;
        attenuation *= attenuation;
        attenuation /= mgDistVector2(direction);

        if (!(attenuation <= 1.0f)) {
            attenuation = 1.0f;
        }

        sceVu0ScaleVector(color, points[index].plight.color, 0.4f * (attenuation * GetLightAnimeWeight(&points[index], anime_frame)));
        color[3] = 128.0f;
        sceVu0Normalize(direction, direction);
        mgSetLight(3 - index, direction, color);
    }

    if (use_parts != 0) {
        CMapParts *parts;
        int        nearest_distance;
        int        index;
        float      distance;
        chara->GetPosition(chara_position);
        chara_position[3] = 1.0f;
        parts = place_parts;
        GetNowTime();
        CFuncPoint    candidate;
        CFuncPoint    nearest;
        sceVu0FVECTOR local_position;
        sceVu0FMATRIX world_matrix;
        sceVu0FMATRIX inverse_matrix;

        int *nearest_type = &nearest.type;
        nearest_distance = 0x4876E000;
        *nearest_type = FUNC_POINT_NONE;

        for (index = 0; index < place_parts_num; index++, parts++) {
            if ((parts->func_point_mngr.flag & FUNC_POINT_MNGR_LIGHT) != 0 && (u8) (parts->name[0] == 0) == 0) {
                chara_position[3] = 1.0f;
                parts->GetLWMatrix(world_matrix);
                mgInversMatrix(inverse_matrix, world_matrix);
                sceVu0ApplyMatrix(local_position, inverse_matrix, chara_position);
                local_position[3] = 0.0f;

                if (parts->func_point_mngr.GetLight(local_position, &candidate, 1, &check, light_mode) > 0) {
                    distance = mgDistVector(candidate.position, local_position);

                    if (distance < nearest_distance) {
                        nearest_distance = (int) distance;
                        nearest = candidate;
                        nearest.position[3] = 1.0f;
                        sceVu0ApplyMatrix(nearest.position, world_matrix, nearest.position);
                    }
                }
            }
        }

        if (*nearest_type == FUNC_POINT_PLIGHT) {
            sceVu0FVECTOR direction;
            sceVu0FVECTOR color;
            sceVu0SubVector(direction, nearest.position, chara_position);
            attenuation = nearest.plight.power / mgDistVector(direction);
            attenuation *= attenuation;

            if (!(attenuation <= 1.0f)) {
                attenuation = 1.0f;
            }

            sceVu0ScaleVector(color, nearest.plight.color, 0.4f * (attenuation * GetLightAnimeWeight(&nearest, anime_frame)));
            color[3] = 128.0f;
            sceVu0Normalize(direction, direction);
            mgSetLight(2, direction, color);
        }
    }

    return light_num;
}

int CMap::SetFuncPLight(float *pos, CFuncPointCheck *check) {
    static CFuncPoint ft[8];
    sceVu0FVECTOR     color;
    CFuncPoint       *point;
    int               light_num;
    int               index;

    light_num = func_point.GetLight(pos, ft, 3, check, 0);

    for (index = 0; index < light_num; index++) {
        point = &ft[index];
        sceVu0ScaleVector(color, point->plight.color, GetLightAnimeWeight(point, anime_frame));
        mgSetPlight(3 - index, point->position, color, point->plight.power, point->plight.range);
    }

    return light_num;
}

void CMap::ResetFuncPLight(int num) {
    int index;

    for (index = 0; index < num; index++) {
        mgSetPlight(3 - index, NULL);
    }
}

int CMap::DrawSub(int direct) {
    int             plight_enable = mgGetPlightEnable();
    int             lighting = mgActiveLighting(2, 1);
    CFuncPointCheck check;
    float           sphere[4];
    CMapParts     **list;
    CMapParts      *parts;
    int             total;
    int             light_count;
    int             drawn;
    int             i;
    check.time = 0;
    CreateFuncCheck(&check);
    total = 0;
    list = draw_parts;
    GetNowTime();

    for (i = 0; i < draw_parts_num; i++, list++) {
        parts = *list;
        parts->CopyFuncPointCheck(check);

        if (func_point.flag & kFuncPointHasPLight) {
            parts->GetBoundSphere(sphere);
            light_count = SetFuncPLight(sphere, &check);
        } else {
            light_count = 0;
        }

        if (light_count > 0) {
            mgPlightEnable(1);
        }

        if (direct != 0) {
            drawn = parts->DrawDirect();
        } else {
            drawn = parts->Draw();
        }

        total += drawn;
        ResetFuncPLight(light_count);
    }

    mgPlightEnable(plight_enable);

    if (lighting >= 0) {
        mgActiveLighting(lighting, 0);
    }

    return total;
}

void CMap::DrawEffect() {
    CMapParts **list;
    CMapParts  *parts;
    CFuncPoint *parts_point;
    CFuncPoint *point;
    int         index;
    GetNowTime();
    effect_list.CreatePacket();
    CFuncPointCheck check;
    check.time = 0;
    CreateFuncCheck(&check);
    static mgCFrameAttr attr;
    attr.draw = MG_FRAME_DRAW_VISIBLE | MG_FRAME_DRAW_SKIP_CHILDREN;
    attr.no_cull = 1;
    attr.fog = 2;
    attr.no_cull = 1;
    attr.depth_bias = 1.015f;
    func_point.GetStart(FUNC_POINT_EFFECT);

    if ((point = func_point.Get()) != 0) {
        do {
            if (point->Check(&check) != 0) {
                point->frame.SetVisual(effect_list.GetEffectVisual(point->effect.index));
                point->frame.attr = &attr;
                mgDrawDirect(&point->frame);
            }
        } while ((point = func_point.Get()) != 0);
    }

    func_point.GetEnd();
    list = draw_parts;

    for (index = 0; index < draw_parts_num; index++, list++) {
        parts = *list;

        if (parts->CheckDraw() == 0) {
            continue;
        }

        parts->func_point_mngr.GetStart(FUNC_POINT_EFFECT);

        if ((parts_point = parts->func_point_mngr.Get()) != 0) {
            do {
                if (parts_point->active != 0) {
                    parts_point->frame.SetReference(&parts->frame);
                    parts_point->frame.SetVisual(effect_list.GetEffectVisual(parts_point->effect.index));
                    parts_point->frame.attr = &attr;
                    mgDrawDirect(&parts_point->frame);
                    parts_point->frame.DeleteReference();
                }
            } while ((parts_point = parts->func_point_mngr.Get()) != 0);
        }
    }
}

void CMap::DrawFireEffect(int tex_block) {
    CFuncPointCheck check;
    float           matrix[4][4];
    mgCTexture     *fire_texture;
    mgCTexture     *light_texture;
    CMapParts     **list;
    CMapParts      *parts;
    int             i;
    check.time = 0;
    CreateFuncCheck(&check);
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) 0);
    fire_texture = mgTexManager.GetTexture("fire_wrk", tex_block);
    light_texture = mgTexManager.GetTexture("lightling", tex_block);
    mgUnitMatrix(matrix);

    ::DrawFireEffect(matrix, &func_point, &check, 1.0f, fire_texture, light_texture);
    list = draw_parts;

    if (list != 0) {
        for (i = 0; i < draw_parts_num; i++, list++) {
            parts = *list;

            if ((parts->func_point_mngr.flag & kFuncPointHasFire) == 0) {
                continue;
            }

            if (parts->CheckDraw() == 0) {
                continue;
            }

            parts->GetLWMatrix(matrix);
            ::DrawFireEffect(matrix, &parts->func_point_mngr, &check,
                             1.0f, fire_texture, light_texture);
        }
    }
}

void CMap::DrawFireRaster() {
    CFuncPointCheck check;
    float           matrix[4][4];
    CMapParts     **list;
    int             i;
    CMapParts      *parts;
    check.time = 0;
    CreateFuncCheck(&check);
    mgUnitMatrix(matrix);

    ::DrawFireRaster(matrix, &func_point, &check, fire_raster);
    list = draw_parts;

    if (list != 0) {
        for (i = 0; i < draw_parts_num; i++, list++) {
            parts = *list;
            u8 unused = parts->name[0] == 0;

            if (unused) {
                continue;
            }

            if (parts->CheckDraw() == 0) {
                continue;
            }

            parts->GetLWMatrix(matrix);
            ::DrawFireRaster(matrix, &parts->func_point_mngr, &check, fire_raster);
        }
    }
}

void CMap::DrawWater(mgCCamera *camera, mgCTexture *screen, mgCTexture *overlay) {
    sceVu0FVECTOR camera_position;
    sceVu0FVECTOR camera_direction;
    sceVu0FVECTOR camera_rotation;

    int ripple_row;
    int surface_no;
    int ripple_column;

    if (water_surface_num <= 0) {
        return;
    }

    if (screen == NULL) {
        return;
    }

    while (water_num <= 0) {
        return;
    }

    mgZeroVector(camera_position);
    mgZeroVector(camera_rotation);

    if (camera != NULL) {
        camera->GetDir(camera_direction);
        camera->GetPos(camera_position);
        sceVu0Normalize(camera_direction, camera_direction);
        sceVu0ScaleVector(camera_direction, camera_direction, 400.0f);
        mgAddVector(camera_position, camera_direction);
        camera_rotation[1] = mgAngleLimit(atan2f(camera_direction[0], camera_direction[2]));
    } else {
        surface_no = 0;
    }

    for (surface_no = 0; surface_no < water_surface_num; surface_no++) {
        if (water_surface[surface_no] != NULL) {
            water_surface[surface_no]->CreatePacket();
            water_surface[surface_no]->SetTexture(screen);
            ripple_row = fptosi(48.0f * ((float) rand() / (float) 0x7FFFFFFF));
            ripple_column = fptosi(32.0f * ((float) rand() / 2147483648.0f));
            float shake_strength = 0.1f;
            water_surface[surface_no]->Shake(ripple_row, ripple_column, shake_strength);
            float        speed_value = 0.15f;
            const float &speed = speed_value;
            water_surface[surface_no]->SetParam(speed, 0.0045f, 0.0f, 16.0f);
            water_surface[surface_no]->Step();
            water_surface[surface_no]->SetColor(0x80, 0x80, 0x80, 0x80);
        }
    }

    mgTexManager.ReloadTexture(screen->block, (sceVif1Packet *) NULL);

    mgCTexture framebuffer;
    mgGetFrameBuffer(&framebuffer);
    mgRect<int> screen_rect(0, 0, (mgScreenWidth - 1) * 16, (mgScreenHeight - 1) * 16);
    mgSetPkMoveImage(&framebuffer, screen_rect, screen, 0, 0, 0);
    sceVu0FMATRIX identity;
    sceVu0FMATRIX parts_matrix;
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    sceVu0FVECTOR scale;
    CMapWater    *placement = water;
    int           placement_no;
    CWaterFrame  *surface;
    CMapParts    *parts;
    int           parts_no;
    mgUnitMatrix(identity);

    for (placement_no = 0; placement_no < water_num; placement_no++, placement++) {
        surface = placement->frame;

        if (surface != NULL) {
            placement->GetPosition(position);
            placement->GetRotation(rotation);
            placement->GetScale(scale);

            if (placement->follow[0] != 0) {
                position[0] = camera_position[0];
            }

            if (placement->follow[1] != 0) {
                position[1] = camera_position[1];
            }

            if (placement->follow[2] != 0) {
                position[2] = camera_position[2];
            }

            surface->SetPosition(position);
            surface->SetRotation(rotation);

            if (placement->follow[0] != 0 && placement->follow[2] != 0) {
                surface->SetRotation(camera_rotation);
            }

            surface->SetScale(scale);

            for (parts_no = 0; parts_no < placement->parts_num; parts_no++) {
                parts = placement->parts[parts_no];

                if (parts == NULL) {
                    mgDrawDirect(surface);
                } else {
                    parts->GetLWMatrix(parts_matrix);
                    surface->SetTransMatrix(parts_matrix);
                    mgDrawDirect(surface);
                    surface->SetTransMatrix(identity);
                }
            }
        }
    }

    if (overlay != NULL) {
        mgCDrawPrim   prim;
        sceVu0FVECTOR overlay_position;
        sceVu0FVECTOR overlay_rotation;
        sceVu0FVECTOR overlay_scale;
        prim.Initialize(NULL, NULL);
        prim.DepthTestEnable(0);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.TextureMapEnable(1);
        prim.AlphaBlendEnable(0);
        prim.AlphaTestEnable(0);
        mgSetPkFrameBuffer(screen);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Texture(overlay);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.TextureCrd(0, 0);
        prim.Vertex(0, 0, 0);
        prim.TextureCrd(0x80, 0x80);
        prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim.End();
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        int          overlay_no;
        CWaterFrame *overlay_surface;
        int          overlay_parts_no;
        int          overlay_parts_offset;
        CMapWater   *overlay_water;
        overlay_water = water;

        for (overlay_no = 0; overlay_no < water_num; overlay_no++, overlay_water++) {
            overlay_surface = overlay_water->frame;

            if (overlay_surface != NULL) {
                overlay_water->GetPosition(overlay_position);
                overlay_water->GetRotation(overlay_rotation);
                overlay_water->GetScale(overlay_scale);
                overlay_water->GetPosition(overlay_position);
                overlay_water->GetRotation(overlay_rotation);
                overlay_water->GetScale(overlay_scale);

                if (overlay_water->follow[0] != 0) {
                    overlay_position[0] = camera_position[0];
                }

                if (overlay_water->follow[1] != 0) {
                    overlay_position[1] = camera_position[1];
                }

                if (overlay_water->follow[2] != 0) {
                    overlay_position[2] = camera_position[2];
                }

                overlay_surface->SetPosition(overlay_position);
                overlay_surface->SetRotation(overlay_rotation);

                if (overlay_water->follow[0] != 0 && overlay_water->follow[2] != 0) {
                    overlay_surface->SetRotation(camera_rotation);
                }

                overlay_surface->SetColor(0x80, 0x80, 0x80, 0x20);
                float        overlay_speed_value = 0.15f;
                const float &overlay_speed = overlay_speed_value;
                overlay_surface->SetParam(overlay_speed, 0.0045f, 0.0f, 300.0f);
                overlay_surface->SetScale(overlay_scale);

                for (overlay_parts_no = 0, overlay_parts_offset = 0; overlay_parts_no < overlay_water->parts_num; overlay_parts_offset += 4, overlay_parts_no++) {
                    parts = *(CMapParts **) ((u8 *) overlay_water->parts + overlay_parts_offset);

                    if (parts == NULL) {
                        mgDrawDirect(overlay_surface);
                    } else {
                        parts->GetLWMatrix(parts_matrix);
                        overlay_surface->SetTransMatrix(parts_matrix);
                        mgDrawDirect(overlay_surface);
                        overlay_surface->SetTransMatrix(identity);
                    }
                }
            }
        }
    }

    return;
}

void CMap::DrawTrBox() {
    int              plight_enable;
    int              lighting;
    float            position[4];
    CMapTreasureBox *box;
    int              i;
    int              light_count;

    if (tr_box_num == 0 || tr_box == 0) {
        return;
    }

    mgTexManager.ReloadTexture(tr_box_texture, (sceVif1Packet *) 0);
    plight_enable = mgGetPlightEnable();
    lighting = mgActiveLighting(2, 1);
    CFuncPointCheck check;
    check.time = 0;
    CreateFuncCheck(&check);
    GetNowTime();
    box = tr_box;

    for (i = 0; i < tr_box_num; i++, box++) {
        if (box->active == 0) {
            continue;
        }

        CMapParts *link = box->parts;

        if (link != 0 && link->GetShow() == 0) {
            continue;
        }

        if (func_point.flag & FUNC_POINT_MNGR_LIGHT) {
            box->GetPosition(position);
            position[3] = 40.0f;
            light_count = SetFuncPLight(position, &check);
        } else {
            light_count = 0;
        }

        if (light_count > 0) {
            mgPlightEnable(1);
        }

        box->DrawDirect();
        ResetFuncPLight(light_count);
    }

    mgPlightEnable(plight_enable);

    if (lighting >= 0) {
        mgActiveLighting(lighting, 0);
    }
}

int CMap::GetPoly(int kind, CCPoly *polys, mgVu0FBOX &box, int max) {
    CMapParts *found[128];
    int        found_count = GetPlaceColParts(&box, found, 128);
    int        total = 0;
    int        i;
    int        j;

    for (i = 0; i < found_count; i++) {
        CMapParts *parts = found[i];
        u8         unused = parts->name[0] == 0;

        if (unused) {
            continue;
        }

        if (parts->GetShow() == 0) {
            continue;
        }

        int effect_num = (parts)->GetPoly(kind, polys, box, max);

        if (0 < effect_num) {
            j = 0;

            do {
                j++;
                polys->parts_no = i;
                polys++;
            } while (j < effect_num);
        }

        max -= effect_num;
        total += effect_num;

        if (max <= 0) {
            return total;
        }
    }

    return total;
}

int CMap::GetColPoly(CCPoly *polys, mgVu0FBOX &box, int max) {
    return GetPoly(1, polys, box, max);
}

int CMap::GetCameraPoly(CCPoly *polys, mgVu0FBOX &box, int max) {
    return GetPoly(3, polys, box, max);
}

int CMap::GetTrBoxColPoly(CCPoly *polys, float *param, int max) {
    float            position[4];
    int              total = 0;
    CMapTreasureBox *box = tr_box;
    int              i;
    int              effect_num;

    for (i = 0; i < tr_box_num; i++, box++) {
        if (box->active == 0) {
            continue;
        }

        CMapParts *linked_parts = box->parts;

        if (linked_parts != 0 && linked_parts->GetShow() == 0) {
            continue;
        }

        box->GetWorldPosition(position);
        effect_num = CreateCharaCPoly(polys, max, position, param, 5.0f, 20.0f);
        total += effect_num;
        polys += effect_num;
        max -= effect_num;

        if (max < 0) {
            break;
        }
    }

    return total;
}

int CMap::GetFixCameraPos(sceVu0FVECTOR pos, sceVu0FVECTOR out_camera_pos) {
    CCameraInfo *selected;
    int          camera_no;
    int          rect_no;
    CCameraInfo *camera;

    float         nearest_distance2;
    float         distance;
    float         weight;
    int           segment_no;
    int           projection_num;
    float         segment_length2;
    int           nearest_projection;
    float         nearest_distance;
    sceVu0FVECTOR projection[8];
    sceVu0FVECTOR direction;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR projection_sum;

    selected = NULL;
    {
        CCameraInfo *current = camera_info;

        for (int default_no = 0; default_no < camera_info_num; default_no++, current++) {
            if (current->rect[0] == NULL) {
                selected = current;
            }
        }
    }
    camera = camera_info;

    for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
        for (rect_no = 0; rect_no < camera->rect_num; rect_no++) {
            CColFrame *rect = camera->rect[rect_no];

            if (rect == NULL) {
                break;
            }

            if (rect->InsidePoint(pos) != 0) {
                selected = camera;
            }
        }
    }

    if (selected == NULL) {
        return MAP_FIX_CAMERA_NONE;
    }

    if (1 < selected->pos_num) {
        projection_num = 0;
        nearest_projection = -1;

        for (segment_no = 0; segment_no < selected->pos_num - 1; segment_no++) {
            sceVu0SubVector(direction, selected->pos[segment_no + 1], selected->pos[segment_no]);
            sceVu0SubVector(offset, pos, selected->pos[segment_no]);
            segment_length2 = mgDistVector2(direction);
            weight = sceVu0InnerProduct(direction, offset) / segment_length2;

            if (!(weight < 0.0f) && weight <= 1.0f) {
                sceVu0ScaleVector(projection[projection_num], direction, weight);
                mgAddVector(projection[projection_num], selected->pos[segment_no]);

                if (nearest_projection >= 0) {
                    nearest_distance2 = mgDistVector2(pos, projection[nearest_projection]);

                    if (!(mgDistVector2(pos, projection[projection_num]) < nearest_distance2)) {
                        goto next_projection;
                    }
                }

                nearest_projection = projection_num;
            next_projection:
                projection_num++;
            }
        }

        mgZeroVector(projection_sum);

        for (segment_no = 0; segment_no < projection_num; segment_no++) {
            mgAddVector(projection_sum, projection[segment_no]);
        }

        segment_no = 0;

        if (projection_num > 0) {
            *(u_long128 *) out_camera_pos = *(u_long128 *) projection[nearest_projection];
            nearest_distance = mgDistVector(out_camera_pos, pos);
        } else {
            nearest_distance = mgDistVector(selected->pos[0], pos);
            *(u_long128 *) out_camera_pos = *(u_long128 *) selected->pos[0];
            segment_no = 1;
        }

        for (; segment_no < selected->pos_num; segment_no++) {
            distance = mgDistVector(pos, selected->pos[segment_no]);

            if (distance < nearest_distance) {
                nearest_distance = distance;
                *(u_long128 *) out_camera_pos = *(u_long128 *) selected->pos[segment_no];
            }
        }

        return MAP_FIX_CAMERA_PATH;
    }

    *(u_long128 *) out_camera_pos = *(u_long128 *) selected->pos[0];
    return MAP_FIX_CAMERA_POINT;
}

void CMap::FixCameraPartsOnOff(float *camera_pos) {
    {
        CCameraInfo *camera = camera_info;
        int          camera_no;
        int          draw_no;

        for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
            for (draw_no = 0; draw_no < 4; draw_no++) {
                CCameraDrawInfo *draw_info = camera->GetDrawInfo(draw_no);

                if (draw_info != NULL) {
                    CPartsGroup *group = GetPartsGroup(draw_info->group_no);

                    if (group != NULL) {
                        group->camera_off = 0;
                    }
                }
            }
        }
    }
    CCameraInfo *selected = NULL;
    int          camera_no;
    CCameraInfo *candidate = camera_info;

    for (camera_no = 0; camera_no < camera_info_num; camera_no++, candidate++) {
        if (mgDistVector(candidate->pos[0], camera_pos) < 10.0f) {
            selected = candidate;
            break;
        }
    }

    if (selected != NULL) {
        for (int draw_no = 0; draw_no < 4; draw_no++) {
            CCameraDrawInfo *draw_info = selected->GetDrawInfo(draw_no);

            if (draw_info != NULL) {
                CPartsGroup *group = GetPartsGroup(draw_info->group_no);

                if (group != NULL) {
                    group->camera_off = 1;
                }
            }
        }
    }
}

CFuncPoint *CMap::GetEvent(float *pos, int check_type, MapEventInfo *info) {
    union {
        u_long128 words[6];
    } event_storage;

    MapEventInfo    nearest_info;
    CFuncPoint     *nearest_point;
    MapEventInfo   *current;
    CFuncPoint     *point;
    CMapParts      *parts;
    CFuncPointMngr *manager;
    float           nearest_distance;
    float           distance;
    int             last_event;
    int             parts_no;
    int             accepted;
    int             row;

    current = (MapEventInfo *) &event_storage;
    nearest_point = NULL;
    current->event_no = 0;
    mgUnitMatrix(current->matrix);
    current->point_no = -1;
    current->parts_no = -1;
    func_point.GetStart(FUNC_POINT_EVENT);
    nearest_distance = 0.0f;
    last_event = 0;

    if ((point = func_point.Get()) != NULL) {
        do {
            if (CheckFuncEvent(point, pos, check_type, current, &distance) == 0) {
                if (current != NULL && current->event_no != 0) {
                    last_event = current->event_no;
                }
            } else {
                current->point_no = point->event.point_no;

                if (nearest_point == NULL || distance < nearest_distance) {
                    nearest_distance = distance;
                    nearest_point = point;
                    nearest_info = *current;
                }
            }
        } while ((point = func_point.Get()) != NULL);
    }

    parts = place_parts;

    if (parts_event != 0) {
        for (parts_no = 0; parts_no < place_parts_max; parts_no++, parts++) {
            manager = &parts->func_point_mngr;

            if ((manager->flag & FUNC_POINT_MNGR_EVENT) && (u8) (parts->name[0] == 0) == 0 && parts->GetShow() != 0) {
                manager->GetStart(FUNC_POINT_EVENT);

                if ((point = manager->Get()) != NULL) {
                    do {
                        point->frame.SetReference(&parts->frame);
                        accepted = CheckFuncEvent(point, pos, check_type, current, &distance);
                        point->frame.DeleteReference();

                        if (current != NULL) {
                            current->parts_no = parts_no;

                            if (current->event_no != 0) {
                                last_event = current->event_no;
                            }
                        }

                        if (accepted != 0) {
                            current->point_no = point->event.point_no;

                            if (nearest_point == NULL || distance < nearest_distance) {
                                nearest_distance = distance;
                                nearest_point = point;
                                nearest_info = *current;
                            }
                        }
                    } while ((point = manager->Get()) != NULL);
                }
            }
        }
    }

    if (info != NULL) {
        *info = nearest_info;
        info->event_no = last_event;
    }

    return nearest_point;
}

CFuncPoint *CMap::InScreenFunc(InScreenFuncInfo *info) {
    CFuncPoint *hit = 0;
    CMapParts  *parts;
    int         i;
    CFuncPoint *result;
    float       saved_y = 0.0f;
    float       nearest = 0.0f;
    parts = place_parts;

    for (i = 0; i < place_parts_max; i++, parts++) {
        u8 unused = parts->name[0] == 0;

        if (unused) {
            continue;
        }

        if (parts->CheckDraw() == 0) {
            continue;
        }

        result = parts->InScreenFunc(info);

        if (result == 0) {
            continue;
        }

        if (hit != 0 && !(info->dist < nearest)) {
            continue;
        }

        hit = result;
        saved_y = info->unk_04;
        nearest = info->dist;
    }

    info->unk_04 = saved_y;
    return hit;
}

void CMap::DrawScreenFunc(mgCFrame *frame) {
    CMapParts *parts = place_parts;
    int        i;

    for (i = 0; i < place_parts_max; i++, parts++) {
        u8 unused = parts->name[0] == 0;

        if (!unused && parts->CheckDraw() != 0) {
            parts->DrawScreenFunc(frame);
        }
    }
}

void CMap::EffectStep() {
    anime_time += 1.0f;
    anime_frame = (int) anime_time;
    effect_list.Step();
}

void CMap::AnimeStep(CObjAnimeEnv *env) {
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    CMapParts *parts = place_parts;

    for (int parts_no = 0; parts_no < place_parts_num; parts_no++, parts++) {
        parts->AnimeStep(&check, env);
    }

    if (obj_anime_num <= 0 || obj_anime == NULL) {
        return;
    }

    CObjAnime *anime = obj_anime;

    for (int anime_no = 0; anime_no < obj_anime_num; anime_no++, anime++) {
        if (anime->func_point != NULL && anime->func_point->Check(&check) != 0) {
            anime->Step(env);
        }
    }
}

void CMap::Step() {
    CMapParts *parts = place_parts;
    int        i;

    for (i = 0; i < place_parts_num; i++, parts++) {
        parts->Step();
    }
}

int CMap::GetSeSrcVolPan(int *ids, float *vols, float *pans, int max) {
    CFuncPointCheck check;
    float           matrix[4][4];
    int             total;
    int             got;
    CMapParts      *parts;
    int             i;
    check.time = 0;
    CreateFuncCheck(&check);
    total = 0;
    mgUnitMatrix(matrix);

    got = ::GetSeSrcVolPan(matrix, &func_point, &check, ids, vols, pans, max);
    total += got;
    ids += got;
    max -= got;
    vols += got;
    pans += got;
    parts = place_parts;

    for (i = 0; i < place_parts_max; i++, parts++) {
        u8 unused = parts->name[0] == 0;

        if (unused) {
            continue;
        }

        if (parts->CheckDraw() == 0) {
            continue;
        }

        if ((parts->func_point_mngr.flag & FUNC_POINT_MNGR_SOUND) == 0) {
            continue;
        }

        (parts)->GetLWMatrix(matrix);

        if (max <= 0) {
            return total;
        }

        got = ::GetSeSrcVolPan(matrix, (&parts->func_point_mngr),
                               &check, ids, vols, pans, max);
        total += got;
        ids += got;
        max -= got;
        vols += got;
        pans += got;
    }

    return total;
}

void CMap::CreateMap(CMdsListSet *mds_list_set, mgCMemory *stack) {
    char *script;
    int   size;

    script = map_info.GetAddMapFile(&size);

    if (script != NULL && size > 0) {
        LoadMapFile(script, size, stack, 1);
    }

    script = map_info.GetMapFile(&size);
    LoadMapFile(script, size, stack, 0);
}

void CMap::AssignFuncPoint(mgCMemory *stack) {
    CMapParts *parts;

    obj_anime_num = func_point.GetNum(FUNC_POINT_ANIME);

    if (obj_anime_num > 0) {
        int          count = obj_anime_num;
        unsigned int bytes = (unsigned int) count * 0x30;
        unsigned int blocks;

        switch (bytes & 0xF) {
            default:
                blocks = (bytes >> 4) + 1;
                break;
            case 0:
                blocks = bytes >> 4;
                break;
        }

        obj_anime = new (stack->Alloc(blocks + 2)) CObjAnime[count];
        CFuncPoint *point;
        CObjAnime  *animation = obj_anime;

        if (animation != NULL) {
            func_point.GetStart(FUNC_POINT_ANIME);

            if ((point = func_point.Get()) != NULL) {
                do {
                    animation->frame = NULL;
                    animation->piece = NULL;
                    animation->parts = NULL;
                    animation->func_point = NULL;
                    animation->back = 0;
                    animation->stop = 0;
                    animation->func_point = point;
                    parts = NULL;

                    if (point->anime.parts_name != NULL) {
                        parts = GetPlaceParts(point->anime.parts_name);
                    }

                    animation->AssignFuncAnime(point, parts);
                    animation++;
                } while ((point = func_point.Get()) != NULL);
            }

            func_point.GetEnd();
        }
    }
}

void CMap::CreateTrBox(CMapTreasureBox *model, int tex_block, mgCMemory *stack) {
    mgCFrame       *top_frame;
    CMapParts      *parts;
    CFuncPointMngr *manager;
    CFuncPoint     *point;
    int             parts_index;
    int             box_index;

    if (model == NULL || model->CObjectFrame::frame == NULL) {
        return;
    }

    top_frame = model->CObjectFrame::frame->SearchFrame("top");

    if (top_frame != NULL) {
        top_frame->SetRotType(2);
    }

    model->fade = 1;
    tr_box_texture = tex_block;
    tr_box_model = model;
    tr_box_num = func_point.GetEventNum(FUNC_EVENT_TREASURE_BOX);
    parts = place_parts;

    for (parts_index = 0; parts_index < place_parts_max; parts_index++, parts++) {
        if ((u8) (parts->name[0] == 0) == 0) {
            tr_box_num += parts->func_point_mngr.GetEventNum(FUNC_EVENT_TREASURE_BOX);
        }
    }

    int          count = tr_box_num;
    unsigned int bytes = (unsigned int) count * 0x680;
    unsigned int blocks;

    switch (bytes & 0xF) {
        default:
            blocks = (bytes >> 4) + 1;
            break;
        case 0:
            blocks = bytes >> 4;
            break;
    }

    u_long128 *block = stack->Alloc(blocks + 2);
    tr_box = new (block) CMapTreasureBox[count];

    if (tr_box == NULL) {
        tr_box_num = 0;
    }

    {
        int             box_no;
        CFuncPointMngr *current_manager;
        CFuncPoint     *current_point;
        CMapParts      *linked_parts;
        int             parts_no;
        CMapParts      *parts_cursor = place_parts;
        box_no = 0;

        for (parts_no = -1, parts_cursor--; parts_no < place_parts_max; parts_cursor++, parts_no++) {
            if (box_no >= tr_box_num) {
                break;
            }

            linked_parts = NULL;

            if (parts_no < 0) {
                current_manager = &func_point;
            } else {
                current_manager = &parts_cursor->func_point_mngr;
                linked_parts = parts_cursor;
            }

            current_manager->GetStart(FUNC_POINT_EVENT);

            if ((current_point = current_manager->Get()) != NULL) {
                do {
                    if ((current_point->event.flag & FUNC_EVENT_TREASURE_BOX) != 0) {
                        tr_box_model->Copy(tr_box[box_no], stack);
                        tr_box[box_no].AssignFuncPoint(current_point, linked_parts);
                        current_point->event.point_no = box_no;
                        box_no++;
                    }
                } while ((current_point = current_manager->Get()) != NULL);
            }

            current_manager->GetEnd();
        }
    }
}

CMapTreasureBox *CMap::GetTrBox(int index) {
    if (index < 0 || index > tr_box_num || tr_box == NULL) {
        return NULL;
    }

    return &tr_box[index];
}

void CMap::DeleteTrBox(int no, CMapFlagData *flags) {
    CMapTreasureBox *box;

    box = GetTrBox(no);

    if (box != NULL) {
        box->active = 0;

        if (box->flag_no > 0) {
            if (flags != NULL) {
                flags->SetFlag(box->flag_no, 1);
            }

            if (box->func_point != NULL) {
                box->func_point->enable = 0;
            }
        }
    }
}

void CMap::UpdateTrBoxFlag(CMapFlagData *flag_data) {
    CMapTreasureBox *box;
    int              i;

    if (flag_data != NULL) {
        box = tr_box;

        for (i = 0; i < tr_box_num; i++, box++) {
            if (box->flag_no > 0) {
                box->active = !(flag_data->GetFlag(box->flag_no) != 0);

                if (box->func_point != NULL) {
                    box->func_point->enable = box->active;
                }
            }
        }
    }
}

void CMap::LoadData(unsigned int *pcp_pack, unsigned int *img_pack, int *tex_block, mgCMemory *stack) {
    mgCEnterIMGInfo info;
    int             index;
    int             block;
    char           *name;
    unsigned int   *file;
    int             first_block;

    if (mds_list_set != NULL) {
        block = *tex_block;
        mgCTextureManager *manager = &mgTexManager;

        for (index = 0;; index++) {
            name = map_info.GetImgName(index);

            if (name == NULL) {
                break;
            }

            file = GetPackFile(img_pack, name, NULL);
            printf("%x %s\n", file, name);

            if (file != NULL) {
                first_block = block;
                block += manager->EnterIMGFile((u_char *) file, block, stack, &info);
                block++;
                manager->EndEnterTexture(first_block);
                mds_list_set->LoadIMGFile(name, &info, stack);
            }
        }

        char *pcp_name;
        int   pcp_index;

        for (pcp_index = 0;; pcp_index++) {
            pcp_name = map_info.GetPCPName(pcp_index);

            if (pcp_name == NULL) {
                break;
            }

            file = GetPackFile(pcp_pack, pcp_name, NULL);

            if (file != NULL) {
                mds_list_set->LoadPCPFile(pcp_name, file, stack, map_info.all_scissor);
            }
        }

        *tex_block = block - *tex_block;
    }
}

int CheckFuncEvent(CFuncPoint *point, float *pos, int check_type, MapEventInfo *info, float *out_dist) {
    sceVu0FMATRIX matrix;
    sceVu0FVECTOR world_position;
    sceVu0FVECTOR normalized_offset;
    float         scale_x;
    float         scale_y;
    float         scale_z;
    u32           flags;

    if (point->Check(NULL) == 0) {
        return 0;
    }

    point->frame.GetLWMatrix(matrix);
    *(u_long128 *) world_position = *(u_long128 *) matrix[3];
    scale_x = mgDistVector(matrix[0]);
    scale_y = mgDistVector(matrix[1]);
    scale_z = mgDistVector(matrix[2]);
    normalized_offset[0] = (world_position[0] - pos[0]) / scale_x;
    normalized_offset[1] = (world_position[1] - pos[1]) / scale_y;
    normalized_offset[2] = (world_position[2] - pos[2]) / scale_z;

    if (!(mgDistVector(normalized_offset) <= 1.0f)) {
        return 0;
    }

    if (info != NULL) {
        if (point->event.event_no > 0) {
            info->event_no = point->event.event_no;
        }

        info->check_type = check_type;
        flags = point->event.flag;

        if ((flags & FUNC_EVENT_ACTION) != 0 || (flags & FUNC_EVENT_ITEM) != 0) {
            if (check_type == 0) {
                if (flags & FUNC_EVENT_ACTION) {
                    return 0;
                }

                if (flags & FUNC_EVENT_ITEM) {
                    return 0;
                }
            } else if (check_type == 1) {
                if (!(flags & FUNC_EVENT_ACTION)) {
                    return 0;
                }
            } else if (check_type == 2) {
                if (!(flags & FUNC_EVENT_ITEM)) {
                    return 0;
                }
            }
        }

        *(u_long128 *) info->matrix[0] = *(u_long128 *) matrix[0];
        *(u_long128 *) info->matrix[1] = *(u_long128 *) matrix[1];
        *(u_long128 *) info->matrix[2] = *(u_long128 *) matrix[2];
        *(u_long128 *) info->matrix[3] = *(u_long128 *) matrix[3];
    }

    if (out_dist != NULL) {
        *out_dist = mgDistVector(world_position, pos);
    }

    return 1;
}
