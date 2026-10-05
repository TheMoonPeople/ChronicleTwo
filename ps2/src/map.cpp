#include <cstring>
#include "object.hpp"
#include "mglib.hpp"
#include "mg_math.hpp"
#include "common.h"
#include "collision.hpp"
#include "funcpoint.hpp"
#include "mapinfo.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "map.hpp"
#include "mg_sprite.hpp"
extern "C" int fptosi(float value);
extern "C" void __ct__8mgCFrameFv(void *);

enum { kFuncPointHasFire = 2, kFuncPointHasPLight = 0x40, kMapPartsSize = 0x310 };
extern CFuncPoint ft_1248[8];
extern mgCFrameAttr attr_1300;
extern s8 init_1249;
extern s8 init_1301;
extern char at_1352[];
extern char at_1353[];
extern char at_574[];
extern char at_2008[];
extern char at_1927[];

#include <cmath>
#include <cstdlib>
#include <cstdio>
#include <cstring>

#include "collision.hpp"
#include "dataread.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_camera.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "water.hpp"

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
void CPartsGroup::Initialize(void) {
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
            if (next == 0)
                break;
            last = next;
        } while (next != 0);
    }
    last->next = node;
    if (node != 0)
        node->prev = last;
}
void CMapWater::Initialize() { frame = NULL; *(u_long128 *)follow = 0; parts = NULL; parts_max = 0; parts_num = 0; parts_name = NULL; }

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
extern void *__vt__23CList_14PartsGroupData_[];
int CMap::AddPartsGroup(char *name, CMapParts *parts, mgCMemory *memory) {
    int groupNo;
    char *newName;
    CPartsGroup *group;
    CList<PartsGroupData> *node;
    groupNo = SearchPartsGroupNo(name);
    newName = 0;
    if (groupNo < 0) {
        groupNo = SerachEmptyPartsGroupNo();
        newName = mgCopyString(name, memory);
    }
    group = GetPartsGroup(groupNo);
    if (group == 0)
        return -1;
    if (newName != 0)
        group->name = newName;
    if ((node = (CList<PartsGroupData> *)operator new(0x10, memory->Alloc(3))) != 0) {
        *(void ***)((u8 *)node + 0xC) = __vt__23CList_14PartsGroupData_;
        node->data.parts = 0;
        node->Initialize();
    }
    node->data.parts = parts;
    group->Add(node);
    return groupNo;
}

CPartsGroup *CMap::SearchPartsGroup(char *name) {
    return GetPartsGroup(SearchPartsGroupNo(name));
}
int CMap::SearchPartsGroupNo(char *name) {
    int i;
    for (i = 0; i < parts_group_max; i++) {

        u8 used = !!parts_group[i].name ^ 1;
        if (!used && strcmp(parts_group[i].name, name) == 0)
            return i;
    }
    return -1;
}
int CMap::SerachEmptyPartsGroupNo() {
    int i;
    for (i = 0; i < parts_group_max; i++) {
        u8 e = !!parts_group[i].name ^ 1;
        if (e)
            return i;
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
    for (j = 0; j < MAP_PARTS_GROUP_MAX; j++)
        parts_group[j].Initialize();
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
    for (k = 0; k < MAP_OCCLUSION_MAX; k++)
        memset(&occlusion[k], 0, sizeof(COcclusion));
    bbox_valid = 0;
    mgZeroVectorW(bbox.max);
    mgZeroVectorW(bbox.min);
    piece_load_skip = 0;
}
static inline unsigned int map_alloc_size(unsigned int bytes) {
    if (bytes & 0xF) return (bytes >> 4) + 1;
    else return bytes >> 4;
}
extern "C" void *__nwa__FUiP1(unsigned int, int);
extern "C" void *__construct_new_array(void *, void *(*)(void *), void *, unsigned int, int);
extern "C" void *__ct__9CMapPartsFv(void *);
void CMap::SetPlacePartsBuff(mgCMemory *memory, int count) {
    unsigned int list_bytes;
    int block = (int)memory->Alloc(map_alloc_size((unsigned int)count * 0x310) + 2);
    place_parts = (CMapParts *)__construct_new_array(__nwa__FUiP1(count * 0x310 + 0x10, block), __ct__9CMapPartsFv, 0, 0x310, count);
    list_bytes = count << 2;
    block = (int)memory->Alloc(map_alloc_size(list_bytes) + 2);
    draw_parts = (CMapParts **)__nwa__FUiP1(list_bytes, block);
    place_parts_max = count;
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
CMapParts *CMap::NewPlaceParts() { for (int i = 0; i < place_parts_max; i++) { u8 unused = *(s8 *)place_parts[i].name == 0; if (unused) return &place_parts[i]; } return NULL; }

CMdsInfo *CMap::SearchMDS(char *name) {
    CMdsInfo *model;

    model = NULL;
    if (mds_list_set != NULL) {
        model = mds_list_set->SearchMDS(name);
    }
    return model;
}

void CMap::CreateEffect(unsigned int *pack, int tex_block, mgCMemory *stack) {
    effect_list.LoadEFPFile(at_574, pack, tex_block, stack);
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
                    if (next == 0)
                        break;
                    last = next;
                } while (next != 0);
            }
            last->next = node;
            if (node != 0)
                node->prev = last;
        } else {
            parts_list = node;
        }
    }
}

CMapParts *CMap::GetParts(char *name) {
    CList<CMapParts> *entry;
    CMapParts       *parts;

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
extern "C" int __as__9mgVu0FBOXFR9mgVu0FBOX(mgVu0FBOX *, mgVu0FBOX *);
extern "C" int GetBoundBox__9CMapPartsFP9mgVu0FBOX(void *, float *);
extern void *__vt__18CList_P9CMapParts_[];
void CMap::CreateDrawRect(mgCMemory *memory, mgVu0FBOX *rect, mgVu0FBOX *clip, int outside) {
    float parts_box[4];
    float view_box[4];
    MapDrawOffRect *slot;
    char *parts;
    int i;
    int j;
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
        __as__9mgVu0FBOXFR9mgVu0FBOX(&slot->area, rect);
        slot->outside = outside;
        parts = (char *)place_parts;
        for (j = 0; j < place_parts_max; j++, parts += 0x310) {
            u8 unused = *(s8 *)((CMapParts *)parts)->name == 0;
            if (unused) continue;
            if (GetBoundBox__9CMapPartsFP9mgVu0FBOX(parts, parts_box) == 0) continue;
            if (mgClipInBox(parts_box, view_box, clip->max, clip->min) == 0) continue;
            if ((node = (CList<CMapParts *> *)operator new(0x10, memory->Alloc(3))) != 0) {
                *(void ***)((u8 *)node + 0xC) = __vt__18CList_P9CMapParts_;
                node->Initialize();
            }
            node->data = (CMapParts *)parts;
            last = slot->parts;
            if (last == 0) {
                slot->parts = node;
            } else {
                if (last != 0) {
                    do {
                        next = last->next;
                        if (next == 0) break;
                        last = next;
                    } while (next != 0);
                }
                last->next = node;
                if (node != 0) node->prev = last;
            }
        }
    }
}

void CMap::CreateOcclusion(float (*corner)[4]) {
    if (occlusion_num < MAP_OCCLUSION_MAX) {
        occlusion[occlusion_num].enable = 1;
        *(u_long128 *)occlusion[occlusion_num].vertex[0] = *(u_long128 *)corner[0];
        *(u_long128 *)occlusion[occlusion_num].vertex[1] = *(u_long128 *)corner[1];
        *(u_long128 *)occlusion[occlusion_num].vertex[2] = *(u_long128 *)corner[2];
        *(u_long128 *)occlusion[occlusion_num].vertex[3] = *(u_long128 *)corner[3];
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
    int water_index;
    CMapWater *surface;
    int water_offset;
    for (water_index = 0, water_offset = 0; water_index < water_num; water_offset += 0xA0, water_index++) {
        surface = (CMapWater *)((u8 *)water + water_offset);
        if (surface->frame != NULL && surface->parts_name == NULL) {
            surface->parts[surface->parts_num++] = NULL;
        }
    }
    }
    int parts_index;
    int water_index;
    CMapWater *surface;
    int water_offset;
    int parts_offset;
    CMapParts *parts;
    char *name;
    place_parts_num = place_parts_max;
    for (parts_index = 0, parts_offset = 0; parts_index < place_parts_max; parts_offset += 0x310, parts_index++) {
        parts = (CMapParts *)((u8 *)place_parts + parts_offset);
        u8 unused = *(s8 *)parts->name == 0;
        if (!unused) place_parts_num = parts_index + 1;
        if (parts->GetBoundBox(&bounds)) {
            if (!bbox_valid) {
                __as__9mgVu0FBOXFR9mgVu0FBOX(&bbox, &bounds);
                bbox_valid = 1;
            } else {
                mgBoxMaxMin(&bbox, &bounds);
            }
        }
        name = parts->parts_name;
        if (name != NULL) {
            for (water_index = 0, water_offset = 0; water_index < water_num; water_offset += 0xA0, water_index++) {
                surface = (CMapWater *)((u8 *)water + water_offset);
                if (surface->frame != NULL && surface->parts_name != NULL && strcmp(surface->parts_name, name) == 0) {
                    if (surface->parts_num < surface->parts_max) surface->parts[surface->parts_num++] = parts;
                }
            }
        }
    }
}
void CMap::ClearPlaceParts() { int i; int j; place_parts_num = place_parts_max; for (i = 0; i < place_parts_max; i++) { place_parts[i].Initialize(); draw_parts[i] = 0; } for (j = 0; j < water_num; j++) water[j].Clear(); }

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
extern "C" int GetBoundBox__9CMapPartsFP9mgVu0FBOX(void *, float *);
int CMap::GetPlaceParts(mgVu0FBOX *box, CMapParts **out, int max) {
    float parts_box[8];
    char *parts;
    int count;
    int i;
    int out_index;
    if (box == 0) return 0;
    parts = (char *)place_parts;
    count = 0;
    i = 0;
    out_index = 0;
    for (; i < place_parts_num; i++, parts += sizeof(CMapParts)) {
        u8 unused = *(s8 *)((CMapParts *)parts)->name == 0;
        if (unused) continue;
        if (GetBoundBox__9CMapPartsFP9mgVu0FBOX(parts, parts_box) == 0) continue;
        if (mgClipBox(parts_box, parts_box + 4, (float *)box, (float *)box + 4) == 0) continue;
        count++;
        out[out_index++] = (CMapParts *)parts;
        if (count >= max) break;
    }
    return count;
}
int CMap::GetPlaceColParts(mgVu0FBOX *box, CMapParts **out, int max) {
    CMapParts *parts;
    int effect_num;
    int i;
    int outIndex;
    if (box == 0)
        return 0;
    parts = place_parts;
    effect_num = 0;
    i = 0;
    outIndex = 0;
    for (; i < place_parts_num; i++, parts++) {
        u8 unused = *(s8 *)parts->name == 0;
        if (unused)
            continue;
        if (((CMapParts *)parts)->CheckColBox(box) == 0)
            continue;
        effect_num++;
        out[outIndex++] = (CMapParts *)parts;
        if (effect_num >= max)
            break;
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
    CMapParts              *parts;
    MapDrawOffRect         *rect;
    CList<CMapParts *>     *rect_entry;
    CList<CMapPiece>       *piece;
    int                     active_occlusion;
    int                     index;


    if (bbox_valid != 0 && mgInsideScreen(&bbox) == 0) {
        draw_parts_num = 0;
        return 0;
    }

    active_occlusion = 0;
    int occlusion_offset;
    for (index = 0, occlusion_offset = 0; index < occlusion_num; occlusion_offset += 0xC0, index++) {
        COcclusion *current = (COcclusion *)((u8 *)this + occlusion_offset + 0x680);
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
                if (!(!(view_pos[0] < rect->area.min[0]) && !(view_pos[1] < rect->area.min[1]) && !(view_pos[2] < rect->area.min[2])
                    && view_pos[0] <= rect->area.max[0] && view_pos[1] <= rect->area.max[1])) continue;
                do { if (!(view_pos[2] <= rect->area.max[2])) break; goto hide_parts; } while (0);
                continue;
            }
            if (!(view_pos[0] <= rect->area.min[0]) && !(view_pos[1] <= rect->area.min[1]) && !(view_pos[2] <= rect->area.min[2])
                && view_pos[0] < rect->area.max[0] && view_pos[1] < rect->area.max[1] && view_pos[2] < rect->area.max[2]) continue;
            hide_parts:
            {
                for (rect_entry = rect->parts; rect_entry != NULL; rect_entry = rect_entry->next) {
                    if (rect_entry->data != NULL) {
                        rect_entry->data->in_screen = 0;
                    }
                }
            }
        }
    }

    {
    int group_num = parts_group_max;
    CPartsGroup *group = parts_group;
    int group_no = 0;
    CList<PartsGroupData> *group_entry;
    if (0 < group_num) do {
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

    draw_parts_num = 0;
    if (draw_parts == NULL) {
        return 0;
    }

    parts = place_parts;
    for (index = 0; index < place_parts_num; index++, parts++) {
        if ((u8)(*(s8 *)parts->name == 0) == 0) {
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
    sceVu0FVECTOR    chara_position;
    sceVu0FVECTOR    direction;
    sceVu0FVECTOR    color;
    float            attenuation;
    int              light_num;
    int              light_mode;

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
    {
    int index;
    int point_offset;
    CFuncPoint *point;
    index = 0;
    if (0 < light_num) {
    point_offset = 0;
    do {
        point = (CFuncPoint *)((u8 *)points + point_offset);
        sceVu0SubVector(direction, point->position, chara_position);
        attenuation = point->plight.power;
        attenuation *= attenuation;
        attenuation /= mgDistVector2(direction);
        if (!(attenuation <= 1.0f)) {
            attenuation = 1.0f;
        }
        sceVu0ScaleVector(color, point->plight.color, 0.4f * (attenuation * GetLightAnimeWeight(point, anime_frame)));
        color[3] = 128.0f;
        sceVu0Normalize(direction, direction);
        mgSetLight(3 - index, direction, color);
        index++;
        point_offset += 0x1C0;
    } while (index < light_num);
    }

    }
    if (use_parts != 0) {
        CMapParts *parts;
        int nearest_distance;
        int index;
        float distance;
        chara->GetPosition(chara_position);
        chara_position[3] = 1.0f;
        parts = place_parts;
        GetNowTime();
        CFuncPoint candidate;
        CFuncPoint nearest;
        sceVu0FVECTOR local_position;
        sceVu0FMATRIX world_matrix;
        sceVu0FMATRIX inverse_matrix;

        int *nearest_type = &nearest.type;
        nearest_distance = 0x4876E000;
        *nearest_type = FUNC_POINT_NONE;
        for (index = 0; index < place_parts_num; index++, parts++) {
            if ((parts->func_point_mngr.flag & FUNC_POINT_MNGR_LIGHT) != 0 && (u8)(*(s8 *)parts->name == 0) == 0) {
                chara_position[3] = 1.0f;
                parts->GetLWMatrix(world_matrix);
                mgInversMatrix(inverse_matrix, world_matrix);
                sceVu0ApplyMatrix(local_position, inverse_matrix, chara_position);
                local_position[3] = 0.0f;
                if (parts->func_point_mngr.GetLight(local_position, &candidate, 1, &check, light_mode) > 0) {
                    distance = mgDistVector(candidate.position, local_position);
                    if (distance < nearest_distance) {
                        nearest_distance = (int)distance;
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

extern "C" void *__construct_array(void *, void *(*)(void *), void *, unsigned int, unsigned int);
extern "C" void *__ct__10CFuncPointFv(void *);
int CMap::SetFuncPLight(float *pos, CFuncPointCheck *check) {
    int count;
    int i;
    float color[4];
    if (init_1249 == 0) {
        __construct_array(ft_1248, (void *(*)(void *))__ct__10CFuncPointFv, 0, sizeof(CFuncPoint), 8);
        init_1249 = 1;
    }
    count = func_point.GetLight(pos, ft_1248, 3, check, 0);
    for (i = 0; i < count; i++) {
        u8 *point = (u8 *)ft_1248 + i * 0x1C0;
        sceVu0ScaleVector((float *)color, (float *)(point + 0x20), GetLightAnimeWeight((CFuncPoint *)point, anime_frame));
        mgSetPlight(3 - i, (float *)(point + 0x180), color, *(float *)(point + 0x30), *(float *)(point + 0x34));
    }
    return count;
}
extern "C" void *__ct__10CFuncPointFv(void *point) {
    __ct__8mgCFrameFv((u8 *)point + 0x70);
    return point;
}

void CMap::ResetFuncPLight(int num) {
    int index;

    for (index = 0; index < num; index++) {
        mgSetPlight(3 - index, NULL);
    }
}
int CMap::DrawSub(int direct) {
    int plightEnable = mgGetPlightEnable();
    int lighting = mgActiveLighting(2, 1);
    CFuncPointCheck check;
    float sphere[4];
    CMapParts **list;
    CMapParts *parts;
    int total;
    int lightCount;
    int drawn;
    int i;
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
            lightCount = SetFuncPLight(sphere, &check);
        } else {
            lightCount = 0;
        }
        if (lightCount > 0)
            mgPlightEnable(1);
        if (direct != 0)
            drawn = parts->DrawDirect();
        else
            drawn = parts->Draw();
        total += drawn;
        ResetFuncPLight(lightCount);
    }
    mgPlightEnable(plightEnable);
    if (lighting >= 0)
        mgActiveLighting(lighting, 0);
    return total;
}
int CMapParts::Draw() { return DrawSub(0); }
int CMapParts::DrawDirect() { return DrawSub(1); }
extern "C" void __ct__12mgCFrameAttrFv(void *);
void CMap::DrawEffect() {
    CMapParts **list;
    CMapParts *parts;
    u8 *partsPoint;
    u8 *point;
    int i;
    GetNowTime();
    effect_list.CreatePacket();
    CFuncPointCheck check;
    check.time = 0;
    CreateFuncCheck(&check);
    if (init_1301 == 0) {
        __ct__12mgCFrameAttrFv(&attr_1300);
        init_1301 = 1;
    }
    attr_1300.draw = 3;
    attr_1300.no_cull = 1;
    attr_1300.fog = 2;
    attr_1300.depth_bias = 1.015f;
    func_point.GetStart(1);
    if ((point = (u8 *)func_point.Get()) != 0) {
        do {
            if (((CFuncPoint *)point)->Check(&check) != 0) {
                ((mgCFrame *)(point + 0x70))->SetVisual(effect_list.GetEffectVisual(*(int *)(point + 0x24)));
                *(u8 **)(point + 0x164) = (u8 *)&attr_1300;
                mgDrawDirect((mgCFrame *)(point + 0x70));
            }
        } while ((point = (u8 *)func_point.Get()) != 0);
    }
    func_point.GetEnd();
    list = draw_parts;
    for (i = 0; i < draw_parts_num; i++, list++) {
        parts = *list;
        if (parts->CheckDraw() == 0)
            continue;
        (&parts->func_point_mngr)->GetStart(1);
        if ((partsPoint = (u8 *)(&parts->func_point_mngr)->Get()) != 0) {
            do {
                if (*(int *)(partsPoint + 0x1B0) != 0) {
                    ((mgCFrame *)(partsPoint + 0x70))->SetReference((mgCFrame *)&parts->frame);
                    ((mgCFrame *)(partsPoint + 0x70))->SetVisual(effect_list.GetEffectVisual(*(int *)(partsPoint + 0x24)));
                    *(u8 **)(partsPoint + 0x164) = (u8 *)&attr_1300;
                    mgDrawDirect((mgCFrame *)(partsPoint + 0x70));
                    ((mgCFrame *)(partsPoint + 0x70))->DeleteReference();
                }
            } while ((partsPoint = (u8 *)(&parts->func_point_mngr)->Get()) != 0);
        }
    }
}
void CMap::DrawFireEffect(int texBlock) {
    CFuncPointCheck check;
    float matrix[4][4];
    mgCTexture *fireTexture;
    mgCTexture *lightTexture;
    CMapParts **list;
    CMapParts *parts;
    int i;
    check.time = 0;
    CreateFuncCheck(&check);
    mgTexManager.ReloadTexture(texBlock, (sceVif1Packet *)0);
    fireTexture = mgTexManager.GetTexture(at_1352, texBlock);
    lightTexture = mgTexManager.GetTexture(at_1353, texBlock);
    mgUnitMatrix(matrix);

    ::DrawFireEffect((float(*)[4])matrix, &func_point, &check, 1.0f, fireTexture, lightTexture);
    list = draw_parts;
    if (list != 0) {
        for (i = 0; i < draw_parts_num; i++, list++) {
            parts = *list;
            if ((parts->func_point_mngr.flag & kFuncPointHasFire) == 0)
                continue;
            if (parts->CheckDraw() == 0)
                continue;
            parts->GetLWMatrix(matrix);
            ::DrawFireEffect((float(*)[4])matrix, &parts->func_point_mngr, &check,
                             1.0f, fireTexture, lightTexture);
        }
    }
}
void CMap::DrawFireRaster() {
    CFuncPointCheck check;
    float matrix[4][4];
    CMapParts **list;
    int i;
    CMapParts *parts;
    check.time = 0;
    CreateFuncCheck(&check);
    mgUnitMatrix(matrix);

    ::DrawFireRaster((float(*)[4])matrix, &func_point, &check, fire_raster);
    list = draw_parts;
    if (list != 0) {
        for (i = 0; i < draw_parts_num; i++, list++) {
            parts = *list;
            u8 unused = *(s8 *)parts->name == 0;
            if (unused)
                continue;
            if (parts->CheckDraw() == 0)
                continue;
            parts->GetLWMatrix(matrix);
            ::DrawFireRaster(matrix, &parts->func_point_mngr, &check, fire_raster);
        }
    }
}

void CMap::DrawWater(mgCCamera *camera, mgCTexture *screen, mgCTexture *overlay) {
    sceVu0FVECTOR  camera_position;
    sceVu0FVECTOR  camera_direction;
    sceVu0FVECTOR  camera_rotation;

    int ripple_row;
    int surface_no;
    int surface_offset;
    int ripple_column;
    if (water_surface_num <= 0) return;
    if (screen == NULL) {
        return;
    }
    while (water_num <= 0) return;

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

    for (surface_no = 0, surface_offset = 0; surface_no < water_surface_num; surface_offset += 4, surface_no++) {
        if ((*(CWaterFrame **)((u8 *)water_surface + surface_offset)) != NULL) {
            (*(CWaterFrame **)((u8 *)water_surface + surface_offset))->CreatePacket();
            (*(CWaterFrame **)((u8 *)water_surface + surface_offset))->SetTexture(screen);
            ripple_row = fptosi(48.0f * ((float)rand() / (float)0x7FFFFFFF));
            ripple_column = fptosi(32.0f * ((float)rand() / 2147483648.0f));
            float shake_strength = 0.1f;
            (*(CWaterFrame **)((u8 *)water_surface + surface_offset))->Shake(ripple_row, ripple_column, shake_strength);
            float speed_value = 0.15f;
            const float &speed = speed_value;
            (*(CWaterFrame **)((u8 *)water_surface + surface_offset))->SetParam(speed, 0.0045f, 0.0f, 16.0f);
            (*(CWaterFrame **)((u8 *)water_surface + surface_offset))->Step();
            (*(CWaterFrame **)((u8 *)water_surface + surface_offset))->SetColor(0x80, 0x80, 0x80, 0x80);
        }
    }

    mgTexManager.ReloadTexture(screen->block, (sceVif1Packet *)NULL);

    mgCTexture framebuffer;
    mgGetFrameBuffer(&framebuffer);
    mgRect<int> screen_rect(0, 0, (mgScreenWidth - 1) * 16, (mgScreenHeight - 1) * 16);
    mgSetPkMoveImage(&framebuffer, screen_rect, screen, 0, 0, 0);
    sceVu0FMATRIX identity;
    sceVu0FMATRIX parts_matrix;
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    sceVu0FVECTOR scale;
    CMapWater *placement = water;
    int placement_no;
    CWaterFrame *surface;
    CMapParts *parts;
    int parts_no;
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
        mgCDrawPrim prim;
        sceVu0FVECTOR overlay_position;
        sceVu0FVECTOR overlay_rotation;
        sceVu0FVECTOR overlay_scale;
        prim.Initialize(NULL, NULL);
        prim.DepthTestEnable(0);
        prim.ZMask(-1);
        prim.TextureMapEnable(1);
        prim.AlphaBlendEnable(0);
        prim.AlphaTestEnable(0);
        mgSetPkFrameBuffer(screen);
        prim.Begin(6);
        prim.Texture(overlay);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.TextureCrd(0, 0);
        prim.Vertex(0, 0, 0);
        prim.TextureCrd(0x80, 0x80);
        prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim.End();
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        int overlay_no;
        CWaterFrame *overlay_surface;
        int overlay_parts_no;
        int overlay_parts_offset;
        CMapWater *overlay_water;
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
                float overlay_speed_value = 0.15f;
                const float &overlay_speed = overlay_speed_value;
                overlay_surface->SetParam(overlay_speed, 0.0045f, 0.0f, 300.0f);
                overlay_surface->SetScale(overlay_scale);

                for (overlay_parts_no = 0, overlay_parts_offset = 0; overlay_parts_no < overlay_water->parts_num; overlay_parts_offset += 4, overlay_parts_no++) {
                    parts = *(CMapParts **)((u8 *)overlay_water->parts + overlay_parts_offset);
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
    int plight_enable;
    int lighting;
    float position[4];
    char *box;
    int i;
    int light_count;
    if (tr_box_num == 0 || tr_box == 0) return;
    mgTexManager.ReloadTexture(tr_box_texture, (sceVif1Packet *)0);
    plight_enable = mgGetPlightEnable();
    lighting = mgActiveLighting(2, 1);
    CFuncPointCheck check;
    check.time = 0;
    CreateFuncCheck(&check);
    GetNowTime();
    box = (char *)tr_box;
    for (i = 0; i < tr_box_num; i++, box += 0x680) {
        if (((CMapTreasureBox *)box)->active == 0) continue;
        CMapParts *link = ((CMapTreasureBox *)box)->parts;
        if (link != 0 && link->GetShow() == 0) continue;
        if (*(unsigned int *)&func_point & 0x40) {
            ((CMapTreasureBox *)box)->GetPosition(position);
            position[3] = 40.0f;
            light_count = SetFuncPLight(position, &check);
        } else { light_count = 0; }
        if (light_count > 0) mgPlightEnable(1);
        ((CMapTreasureBox *)box)->DrawDirect();
        ResetFuncPLight(light_count);
    }
    mgPlightEnable(plight_enable);
    if (lighting >= 0) mgActiveLighting(lighting, 0);
}
int CMap::GetPoly(int kind, CCPoly *polys, mgVu0FBOX &box, int max) {
    CMapParts *found[128];
    int foundCount = GetPlaceColParts(&box, found, 128);
    int total = 0;
    int i;
    int j;
    for (i = 0; i < foundCount; i++) {
        CMapParts *parts = found[i];
        u8 unused = *(s8 *)parts->name == 0;
        if (unused)
            continue;
        if (parts->GetShow() == 0)
            continue;
        int effect_num = ((CMapParts *)parts)->GetPoly(kind, polys, box, max);
        if (0 < effect_num) {
            j = 0;
            do {
                j++;
                *(s16 *)((u8 *)polys + 0x48) = i;
                polys++;
            } while (j < effect_num);
        }
        max -= effect_num;
        total += effect_num;
        if (max <= 0)
            return total;
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
    float position[4];
    int total = 0;
    CMapTreasureBox *box = tr_box;
    int i;
    int effect_num;

    for (i = 0; i < tr_box_num; i++, box++) {
        if (box->active == 0)
            continue;
        CMapParts *linked_parts = box->parts;
        if (linked_parts != 0 && linked_parts->GetShow() == 0)
            continue;
        box->GetWorldPosition(position);
        effect_num = CreateCharaCPoly(polys, max, position, param, 5.0f, 20.0f);
        total += effect_num;
        polys += effect_num;
        max -= effect_num;
        if (max < 0)
            break;
    }
    return total;
}

#ifdef NONMATCHING
int CMap::GetFixCameraPos(sceVu0FVECTOR pos, sceVu0FVECTOR out_camera_pos) {
    CCameraInfo *selected;
    int camera_no;
    int rect_no;
    int rect_offset;
    CCameraInfo *camera;

    float         segment_length2;
    float         weight;
    float         nearest_distance2;
    float         nearest_distance;
    float         distance;
    int           segment_no;
    int           projection_num;
    int           nearest_projection;
    sceVu0FVECTOR projection[8];
    sceVu0FVECTOR direction;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR projection_sum;

    selected = NULL;
    CCameraInfo *camera_base = camera_info;
    {
        CCameraInfo *current = camera_base;
        for (int default_no = 0; default_no < camera_info_num; default_no++, current++) {
            if (current->rect[0] == NULL) selected = current;
        }
    }
    camera = camera_base;
    for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
        for (rect_no = 0, rect_offset = 0; rect_no < camera->rect_num; rect_offset += 4, rect_no++) {
            CColFrame *rect = *(CColFrame **)((u8 *)camera + 0x94 + rect_offset);
            if (rect == NULL) break;
            if (rect->InsidePoint(pos) != 0) selected = camera;
        }
    }

    if (selected == NULL) {
        return MAP_FIX_CAMERA_NONE;
    }
    if (1 < selected->pos_num) {
        projection_num = 0;
        nearest_projection = -1;
        for (segment_no = 0; segment_no < selected->pos_num - 1; segment_no++) {
            float *segment = selected->pos[segment_no];
            sceVu0SubVector(direction, selected->pos[segment_no + 1], segment);
            sceVu0SubVector(offset, pos, segment);
            segment_length2 = mgDistVector2(direction);
            weight = sceVu0InnerProduct(direction, offset) / segment_length2;
            if (!(weight < 0.0f) && weight <= 1.0f) {
                sceVu0ScaleVector(projection[projection_num], direction, weight);
                mgAddVector(projection[projection_num], segment);
                if (nearest_projection >= 0) {
                    nearest_distance2 = mgDistVector2(pos, projection[nearest_projection]);
                    if (!(mgDistVector2(pos, projection[projection_num]) < nearest_distance2)) goto next_projection;
                }
                nearest_projection = projection_num;
                next_projection:
                projection_num++;
            }
        }

        mgZeroVector(projection_sum);
        int sum_offset;
        int sum_no = 0;
        if (0 < projection_num) {
            sum_offset = 0;
            do {
                mgAddVector(projection_sum, (float *)((u8 *)projection + sum_offset));
                sum_no++;
                sum_offset += 0x10;
            } while (sum_no < projection_num);
        }
        sum_no = 0;
        if (projection_num > 0) {
            *(u_long128 *)out_camera_pos = *(u_long128 *)projection[nearest_projection];
            nearest_distance = mgDistVector(out_camera_pos, pos);
        } else {
            nearest_distance = mgDistVector(selected->pos[0], pos);
            *(u_long128 *)out_camera_pos = *(u_long128 *)selected->pos[0];
            sum_no = 1;
        }
        for (; sum_no < selected->pos_num; sum_no++) {
            distance = mgDistVector(pos, selected->pos[sum_no]);
            if (distance < nearest_distance) {
                nearest_distance = distance;
                *(u_long128 *)out_camera_pos = *(u_long128 *)selected->pos[sum_no];
            }
        }
        return MAP_FIX_CAMERA_PATH;
    }
    *(u_long128 *)out_camera_pos = *(u_long128 *)selected->pos[0];
    return MAP_FIX_CAMERA_POINT;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", GetFixCameraPos__4CMapFPfPf);
#endif

void CMap::FixCameraPartsOnOff(float *camera_pos) {
    {
        CCameraInfo *camera = camera_info;
        int camera_no;
        int draw_no;
        for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
            for (draw_no = 0; draw_no < 4; draw_no++) {
                CCameraDrawInfo *draw_info = camera->GetDrawInfo(draw_no);
                if (draw_info != NULL) {
                    CPartsGroup *group = GetPartsGroup(draw_info->group_no);
                    if (group != NULL) group->camera_off = 0;
                }
            }
        }
    }
    CCameraInfo *selected = NULL;
    int camera_no;
    char *candidate = (char *)camera_info;
    for (camera_no = 0; camera_no < camera_info_num; camera_no++, candidate += 0xD0) {
        if (mgDistVector(((CCameraInfo *)candidate)->pos[0], camera_pos) < 10.0f) {
            selected = (CCameraInfo *)candidate;
            break;
        }
    }
    if (selected != NULL) {
        for (int draw_no = 0; draw_no < 4; draw_no++) {
            CCameraDrawInfo *draw_info = selected->GetDrawInfo(draw_no);
            if (draw_info != NULL) {
                CPartsGroup *group = GetPartsGroup(draw_info->group_no);
                if (group != NULL) group->camera_off = 1;
            }
        }
    }
}

CFuncPoint *CMap::GetEvent(float *pos, int check_type, MapEventInfo *info) {
    union { u_long128 words[6]; } event_storage;
    MapEventInfo    nearest_info;
    CFuncPoint     *nearest_point;
    MapEventInfo *current;
    CFuncPoint     *point;
    CMapParts      *parts;
    CFuncPointMngr *manager;
    float          nearest_distance;
    float          distance;
    int            last_event;
    int            parts_no;
    int            accepted;
    int            row;

    current = (MapEventInfo *)&event_storage;
    nearest_point = NULL;
    current->event_no = 0;
    mgUnitMatrix((float (*)[4])((u8 *)current + 0x10));
    current->point_no = -1;
    current->parts_no = -1;
    func_point.GetStart(FUNC_POINT_EVENT);
    nearest_distance = 0.0f;
    last_event = 0;
    if ((point = func_point.Get()) != NULL) do {
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

    parts = place_parts;
    if (parts_event != 0) {
        for (parts_no = 0; parts_no < place_parts_max; parts_no++, parts++) {
            manager = &parts->func_point_mngr;
            if ((manager->flag & FUNC_POINT_MNGR_EVENT) && (u8)(*(s8 *)parts->name == 0) == 0 && parts->GetShow() != 0) {
                manager->GetStart(FUNC_POINT_EVENT);
                if ((point = manager->Get()) != NULL) do {
                    point->frame.SetReference(&parts->frame);
                    accepted = CheckFuncEvent(point, pos, check_type, current, &distance);
                    point->frame.DeleteReference();
                    if (current != NULL) {
                        current->parts_no = parts_no;
                        if (current->event_no != 0) last_event = current->event_no;
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
    if (info != NULL) {
        *info = nearest_info;
        info->event_no = last_event;
    }
    return nearest_point;
}
CFuncPoint *CMap::InScreenFunc(InScreenFuncInfo *info) {
    CFuncPoint *hit = 0;
    char *parts;
    int i;
    CFuncPoint *result;
    float saved_y = 0.0f;
    float nearest = 0.0f;
    float *values = (float *)info;
    parts = (char *)place_parts;
    for (i = 0; i < place_parts_max; i++, parts += sizeof(CMapParts)) {
        u8 unused = *(s8 *)((CMapParts *)parts)->name == 0;
        if (unused) continue;
        if (((CMapParts *)parts)->CheckDraw() == 0) continue;
        result = ((CMapParts *)parts)->InScreenFunc(info);
        if (result == 0) continue;
        if (hit != 0 && !(values[2] < nearest)) continue;
        hit = result;
        saved_y = values[1];
        nearest = values[2];
    }
    values[1] = saved_y;
    return hit;
}
void CMap::DrawScreenFunc(mgCFrame *frame) {
    char *parts = (char *)place_parts;
    int i;
    for (i = 0; i < place_parts_max; i++, parts += sizeof(CMapParts)) {
        u8 unused = *(s8 *)((CMapParts *)parts)->name == 0;
        if (!unused && ((CMapParts *)parts)->CheckDraw() != 0) ((CMapParts *)parts)->DrawScreenFunc(frame);
    }
}

void CMap::EffectStep() {
    anime_time += 1.0f;
    anime_frame = (int)anime_time;
    effect_list.Step();
}

#ifdef NONMATCHING
void CMap::AnimeStep(CObjAnimeEnv *env) {
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    {
        char *parts = (char *)place_parts;
        int parts_no;
        for (parts_no = 0; parts_no < place_parts_num; parts_no++, parts += 0x310) {
            ((CMapParts *)parts)->AnimeStep(&check, env);
        }
    }
    if (obj_anime_num > 0) {
        int animation_no = 0;
        char *animation = (char *)obj_anime;
        if (animation == NULL) return;
        for (animation_no = 0; animation_no < obj_anime_num; animation_no++, animation += 0x30) {
            if (((CObjAnime *)animation)->func_point != NULL) {
                if (((CObjAnime *)animation)->func_point->Check(&check) != 0) {
                    ((CObjAnime *)animation)->Step(env);
                }
            }
        }
    }
    return;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", AnimeStep__4CMapFP12CObjAnimeEnv);
#endif
void CMap::Step() {
    char *parts = (char *)place_parts;
    int i;
    for (i = 0; i < place_parts_num; i++, parts += sizeof(CMapParts)) ((CMapParts *)parts)->Step();
}
int CMap::GetSeSrcVolPan(int *ids, float *vols, float *pans, int max) {
    CFuncPointCheck check;
    float matrix[4][4];
    int total;
    int got;
    CMapParts *parts;
    int i;
    check.time = 0;
    CreateFuncCheck(&check);
    total = 0;
    mgUnitMatrix(matrix);

    got = ::GetSeSrcVolPan((float(*)[4])matrix, &func_point, &check, ids, vols, pans, max);
    total += got;
    ids += got;
    max -= got;
    vols += got;
    pans += got;
    parts = place_parts;
    for (i = 0; i < place_parts_max; i++, parts++) {
        u8 unused = *(s8 *)parts->name == 0;
        if (unused)
            continue;
        if (parts->CheckDraw() == 0)
            continue;
        if ((*(u32 *)&parts->func_point_mngr & 0x80) == 0)
            continue;
        ((CMapParts *)parts)->GetLWMatrix(matrix);
        if (max <= 0)
            return total;
        got = ::GetSeSrcVolPan((float(*)[4])matrix, (CFuncPointMngr *)&parts->func_point_mngr,
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

    script = GetAddMapFile(&size);
    if (script != NULL && size > 0) {
        LoadMapFile(script, size, stack, 1);
    }
    script = GetMapFile(&size);
    LoadMapFile(script, size, stack, 0);
}

extern "C" void *__ct__9CObjAnimeFv(void *);
void CMap::AssignFuncPoint(mgCMemory *stack) {
    CMapParts  *parts;

    obj_anime_num = func_point.GetNum(FUNC_POINT_ANIME);
    if (obj_anime_num > 0) {
        int count = obj_anime_num;
        unsigned int bytes = (unsigned int)count * 0x30;
        unsigned int blocks;
        switch (bytes & 0xF) {
            default: blocks = (bytes >> 4) + 1; break;
            case 0: blocks = bytes >> 4; break;
        }
        obj_anime = new (stack->Alloc(blocks + 2)) CObjAnime[count];
        CFuncPoint *point;
        char *animation = (char *)obj_anime;
        if (animation != NULL) {
            func_point.GetStart(FUNC_POINT_ANIME);
            if ((point = func_point.Get()) != NULL) do {
                ((CObjAnime *)animation)->frame = NULL;
                ((CObjAnime *)animation)->piece = NULL;
                ((CObjAnime *)animation)->parts = NULL;
                ((CObjAnime *)animation)->func_point = NULL;
                ((CObjAnime *)animation)->back = 0;
                ((CObjAnime *)animation)->stop = 0;
                ((CObjAnime *)animation)->func_point = point;
                parts = NULL;
                if (point->anime.parts_name != NULL) {
                    parts = GetPlaceParts(point->anime.parts_name);
                }
                ((CObjAnime *)animation)->AssignFuncAnime(point, parts);
                animation += 0x30;
            } while ((point = func_point.Get()) != NULL);
            func_point.GetEnd();
        }
    }
}
CObjAnime::CObjAnime() {
    frame = 0;
    piece = 0;
    parts = 0;
    func_point = 0;
    back = 0;
    stop = 0;
}

extern "C" void *__ct__15CMapTreasureBoxFv(void *);
void CMap::CreateTrBox(CMapTreasureBox *model, int tex_block, mgCMemory *stack) {
    mgCFrame        *top_frame;
    CMapParts       *parts;
    CFuncPointMngr  *manager;
    CFuncPoint      *point;
    int              parts_index;
    int              box_index;

    if (model == NULL || model->CObjectFrame::frame == NULL) {
        return;
    }
    top_frame = model->CObjectFrame::frame->SearchFrame(at_1927);
    if (top_frame != NULL) {
        top_frame->SetRotType(2);
    }
    model->fade = 1;
    tr_box_texture = tex_block;
    tr_box_model = model;
    tr_box_num = func_point.GetEventNum(FUNC_EVENT_TREASURE_BOX);
    parts = place_parts;
    for (parts_index = 0; parts_index < place_parts_max; parts_index++, parts++) {
        if ((u8)(*(s8 *)parts->name == 0) == 0) {
            tr_box_num += parts->func_point_mngr.GetEventNum(FUNC_EVENT_TREASURE_BOX);
        }
    }

    int count = tr_box_num;
    unsigned int bytes = (unsigned int)count * 0x680;
    unsigned int blocks;
    switch (bytes & 0xF) {
        default: blocks = (bytes >> 4) + 1; break;
        case 0: blocks = bytes >> 4; break;
    }
    int block = (int)stack->Alloc(blocks + 2);
    tr_box = (CMapTreasureBox *)__construct_new_array(__nwa__FUiP1(count * 0x680 + 0x10, block), __ct__15CMapTreasureBoxFv, 0, 0x680, count);
    if (tr_box == NULL) {
        tr_box_num = 0;
    }

    {
    int box_no;
    CFuncPointMngr *current_manager;
    CFuncPoint *current_point;
    int box_offset;
    int total_box_offset;
    CMapParts *linked_parts;
    int parts_no;
    CMapParts *parts_cursor = place_parts;
    box_no = 0;
    total_box_offset = 0;
    for (parts_no = -1, parts_cursor--; parts_no < place_parts_max; parts_cursor++, parts_no++) {
        if (box_no >= tr_box_num) break;
        linked_parts = NULL;
        if (parts_no < 0) {
            current_manager = &func_point;
        } else {
            current_manager = &parts_cursor->func_point_mngr;
            linked_parts = parts_cursor;
        }
        current_manager->GetStart(FUNC_POINT_EVENT);
        if ((current_point = current_manager->Get()) != NULL) {
            box_offset = total_box_offset;
            do {
                if ((current_point->event.flag & FUNC_EVENT_TREASURE_BOX) != 0) {
                    tr_box_model->Copy(*(CMapTreasureBox *)((u8 *)tr_box + box_offset), stack);
                    ((CMapTreasureBox *)((u8 *)tr_box + box_offset))->AssignFuncPoint(current_point, linked_parts);
                    current_point->event.point_no = box_no;
                    box_offset += 0x680;
                    total_box_offset += 0x680;
                    box_no++;
                }
            } while ((current_point = current_manager->Get()) != NULL);
        }
        current_manager->GetEnd();
    }
    }
}
CMapTreasureBox::CMapTreasureBox() { Initialize(); }
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
void CMap::UpdateTrBoxFlag(CMapFlagData *flagData) {
    CMapTreasureBox *box;
    int i;
    if (flagData != NULL) {
        box = tr_box;
        for (i = 0; i < tr_box_num; i++, box++) {
            if (box->flag_no > 0) {
                box->active = !(flagData->GetFlag(box->flag_no) != 0);
                if (box->func_point != NULL) {
                    box->func_point->enable = box->active;
                }
            }
        }
    }
}

void CMap::LoadData(unsigned int *pcp_pack, unsigned int *img_pack, int *tex_block, mgCMemory *stack) {
    mgCEnterIMGInfo info;
    int index;
    int block;
    char *name;
    unsigned int *file;
    int first_block;

    if (mds_list_set != NULL) {
        block = *tex_block;
        mgCTextureManager *manager = &mgTexManager;
        for (index = 0; ; index++) {
            name = GetImgName(index);
            if (name == NULL) break;
            file = GetPackFile(img_pack, name, NULL);
            printf(at_2008, file, name);
            if (file != NULL) {
                first_block = block;
                block += manager->EnterIMGFile((u_char *)file, block, stack, &info);
                block++;
                manager->EndEnterTexture(first_block);
                mds_list_set->LoadIMGFile(name, &info, stack);
            }
        }
        char *pcp_name;
        int pcp_index;
        for (pcp_index = 0; ; pcp_index++) {
            pcp_name = GetPCPName(pcp_index);
            if (pcp_name == NULL) break;
            file = GetPackFile(pcp_pack, pcp_name, NULL);
            if (file != NULL) {
                mds_list_set->LoadPCPFile(pcp_name, file, stack, all_scissor);
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
    *(u_long128 *)world_position = *(u_long128 *)matrix[3];
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
        *(u_long128 *)info->matrix[0] = *(u_long128 *)matrix[0];
        *(u_long128 *)info->matrix[1] = *(u_long128 *)matrix[1];
        *(u_long128 *)info->matrix[2] = *(u_long128 *)matrix[2];
        *(u_long128 *)info->matrix[3] = *(u_long128 *)matrix[3];
    }
    if (out_dist != NULL) {
        *out_dist = mgDistVector(world_position, pos);
    }
    return 1;
}
int CObject::Draw() { return 0; }
int CObject::DrawDirect() { return 0; }


// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", at_327__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", at_574__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", at_1352__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", at_1353__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", at_1927__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", at_2008__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", __vt__4CMap__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", __vt__18CList_P9CMapParts___DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", __vt__23CList_14PartsGroupData___DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", __vt__9CMapWater__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/map", CMapName__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(init_1249, 0x4);
INCLUDE_BSS(init_1301, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(ft_1248, 0xE00);
INCLUDE_BSS(attr_1300, 0x90);
