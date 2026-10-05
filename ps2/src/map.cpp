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

enum { kFuncPointHasFire = 2, kFuncPointHasPLight = 0x40, kMapPartsSize = 0x310 };
extern CFuncPoint ft_1248[8];
extern mgCFrameAttr attr_1300;
extern int init_1249;
extern int init_1301;
extern char at_1352[];
extern char at_1353[];
extern char at_574[];

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
#ifdef NONMATCHING
int CMapFlagData::SetFlag(int no, int on) {
    u32 mask;
    u32 old_flag;

    if (no < 0 || no >= MAP_FLAG_MAX) {
        return 0;
    }

    mask = 1 << (no % 32);
    old_flag = flag[no / 32];
    if (on) {
        flag[no / 32] = old_flag | mask;
    } else {
        flag[no / 32] = old_flag & ~mask;
    }
    return (old_flag & mask) != 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", SetFlag__12CMapFlagDataFii);
#endif
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
void CMapWater::Initialize() { frame = NULL; memset(follow, 0, sizeof(follow)); parts = NULL; parts_max = 0; parts_num = 0; parts_name = NULL; }

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
    if ((node = new (memory->Alloc(3)) CList<PartsGroupData>) != 0) {
        node->Initialize();
        node->data.parts = 0;
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
void CMap::SetPlacePartsBuff(mgCMemory *memory, int num) { place_parts = new (memory->Alloc(algn16_size(num * sizeof(CMapParts)) + 2)) CMapParts[num]; draw_parts = new (memory->Alloc(algn16_size(num * sizeof(CMapParts *)) + 2)) CMapParts *[num]; place_parts_max = num; ClearPlaceParts(); }
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
CMapParts *CMap::NewPlaceParts() { for (int i = 0; i < place_parts_max; i++) { if (place_parts[i].name[0] == 0) return &place_parts[i]; } return NULL; }

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
void CMap::CreateDrawRect(mgCMemory *memory, mgVu0FBOX *rect, mgVu0FBOX *clip, int outside) { mgVu0FBOX parts_box; for (int i = 0; i < draw_rect_max; i++) { MapDrawOffRect *slot = &draw_rect[i]; if (slot->used) continue; slot->used = 1; slot->area = *rect; slot->outside = outside; slot->parts = NULL; for (int j = 0; j < place_parts_max; j++) { CMapParts *part = &place_parts[j]; if (part->name[0] == 0 || !part->GetBoundBox(&parts_box)) continue; if (!mgClipInBox(parts_box.max, parts_box.min, clip->max, clip->min)) continue; CList<CMapParts *> *node = new (memory->Alloc(3)) CList<CMapParts *>; node->data = part; CList<CMapParts *> *last = slot->parts; if (last == NULL) slot->parts = node; else { while (last->next != NULL) last = last->next; last->next = node; node->prev = last; } } break; } }

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

#ifdef NONMATCHING
void CMap::PlacePartsEnd() {
    mgVu0FBOX  bounds;
    CMapParts *parts;
    CMapWater *surface;
    char      *name;
    int        i;
    int        j;

    for (i = 0; i < water_num; i++) {
        surface = &water[i];
        if (surface->frame != NULL && surface->parts_name == NULL) {
            surface->parts[surface->parts_num++] = NULL;
        }
    }
    place_parts_num = place_parts_max;
    for (i = 0; i < place_parts_max; i++) {
        parts = &place_parts[i];
        if (parts->name[0] != 0) {
            place_parts_num = i + 1;
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
            for (j = 0; j < water_num; j++) {
                surface = &water[j];
                if (surface->frame != NULL && surface->parts_name != NULL && strcmp(surface->parts_name, name) == 0) {
                    if (surface->parts_num < surface->parts_max) {
                        surface->parts[surface->parts_num++] = parts;
                    }
                }
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", PlacePartsEnd__4CMapFv);
#endif
void CMap::ClearPlaceParts() { for (int i = 0; i < place_parts_max; i++) { place_parts[i].Initialize(); } bbox_valid = 0; place_parts_num = 0; }

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
int CMap::GetPlaceParts(mgVu0FBOX *box, CMapParts **out, int max) { if (box == NULL) return 0; int num = 0; mgVu0FBOX parts_box; for (int i = 0; i < place_parts_num; i++) { CMapParts *part = &place_parts[i]; if (part->name[0] == 0 || !part->GetBoundBox(&parts_box)) continue; if (!mgClipBox(parts_box.max, parts_box.min, box->max, box->min)) continue; out[num++] = part; if (num >= max) break; } return num; }
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

#ifdef NONMATCHING
int CMap::PreDraw(float *view_pos) {
    CFuncPointCheck         check;
    CMapParts              *parts;
    MapDrawOffRect         *rect;
    CPartsGroup            *group;
    CList<CMapParts *>     *rect_entry;
    CList<PartsGroupData>  *group_entry;
    CList<CMapPiece>       *piece;
    int                     active_occlusion;
    int                     index;
    int                     hide;

    if (bbox_valid != 0 && mgInsideScreen(&bbox) == 0) {
        draw_parts_num = 0;
        return 0;
    }

    active_occlusion = 0;
    for (index = 0; index < occlusion_num; index++) {
        if (occlusion[index].enable != 0) {
            occlusion[index].Setup(mgRenderInfo.view);
            active_occlusion++;
        }
    }

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
                hide = !(view_pos[0] < rect->area.min[0])
                    && !(view_pos[1] < rect->area.min[1])
                    && !(view_pos[2] < rect->area.min[2])
                    && view_pos[0] <= rect->area.max[0]
                    && view_pos[1] <= rect->area.max[1]
                    && view_pos[2] <= rect->area.max[2];
            } else {
                hide = view_pos[0] <= rect->area.min[0]
                    || view_pos[1] <= rect->area.min[1]
                    || view_pos[2] <= rect->area.min[2]
                    || !(view_pos[0] < rect->area.max[0])
                    || !(view_pos[1] < rect->area.max[1])
                    || !(view_pos[2] < rect->area.max[2]);
            }
            if (hide != 0) {
                for (rect_entry = rect->parts; rect_entry != NULL; rect_entry = rect_entry->next) {
                    if (rect_entry->data != NULL) {
                        rect_entry->data->in_screen = 0;
                    }
                }
            }
        }
    }

    group = parts_group;
    for (index = 0; index < parts_group_max; index++, group++) {
        if (group->name != NULL && (group->camera_off != 0 || group->off != 0)) {
            for (group_entry = group->list; group_entry != NULL; group_entry = group_entry->next) {
                if (group_entry->data.parts != NULL) {
                    group_entry->data.parts->in_screen = 0;
                }
            }
            group->camera_off = 0;
        }
    }

    draw_parts_num = 0;
    if (draw_parts == NULL) {
        return 0;
    }

    parts = place_parts;
    for (index = 0; index < place_parts_num; index++, parts++) {
        if (parts->name[0] != '\0') {
            if (parts->in_screen != 0) {
                draw_parts[draw_parts_num++] = parts;
            } else {
                for (piece = parts->piece_list; piece != NULL; piece = piece->next) {
                    piece->data.fade_alpha = -1.0f;
                }
            }
        }
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", PreDraw__4CMapFPf);
#endif

#ifdef NONMATCHING
int CMap::GetCharaLight(mgCObject *chara, CFuncPoint *points, int max, int use_parts) {
    CFuncPoint       candidate;
    CFuncPoint       nearest;
    CMapParts       *parts;
    sceVu0FMATRIX    world_matrix;
    sceVu0FMATRIX    inverse_matrix;
    sceVu0FVECTOR    local_position;
    float            distance;
    int              nearest_distance;
    CFuncPointCheck  check;
    sceVu0FVECTOR    chara_position;
    sceVu0FVECTOR    direction;
    sceVu0FVECTOR    color;
    CFuncPoint      *point;
    float            attenuation;
    int              light_num;
    int              light_mode;
    int              index;

    if (max <= 0) {
        return 0;
    }

    CreateFuncCheck(&check);
    chara->GetPosition(chara_position);
    chara_position[3] = 0.0f;
    chara_position[1] += 20.0f;
    light_mode = 1;
    if (use_parts != 0) {
        light_mode |= 0x2;
    }

    light_num = func_point.GetLight(chara_position, points, max, &check, light_mode);
    if (light_num >= 3) {
        light_num = 2;
    }
    for (index = 0; index < light_num; index++) {
        point = &points[index];
        sceVu0SubVector(direction, point->position, chara_position);
        attenuation = point->plight.power * point->plight.power / mgDistVector2(direction);
        if (!(attenuation <= 1.0f)) {
            attenuation = 1.0f;
        }
        sceVu0ScaleVector(color, point->plight.color, 0.4f * (attenuation * GetLightAnimeWeight(point, anime_frame)));
        color[3] = 128.0f;
        sceVu0Normalize(direction, direction);
        mgSetLight(3 - index, direction, color);
    }

    if (use_parts != 0) {
        chara->GetPosition(chara_position);
        chara_position[3] = 1.0f;
        GetNowTime();

        nearest_distance = 0x4876E000;
        nearest.type = FUNC_POINT_NONE;
        parts = place_parts;
        for (index = 0; index < place_parts_num; index++, parts++) {
            if ((parts->func_point_mngr.flag & FUNC_POINT_MNGR_LIGHT) != 0 && parts->name[0] != '\0') {
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

        if (nearest.type == FUNC_POINT_PLIGHT) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", GetCharaLight__4CMapFP9mgCObjectP10CFuncPointii);
#endif

int CMap::SetFuncPLight(float *pos, CFuncPointCheck *check) {
    static CFuncPoint points[8];
    sceVu0FVECTOR    color;
    CFuncPoint      *point;
    int              light_num;
    int              index;

    light_num = func_point.GetLight(pos, points, 3, check, 0);
    for (index = 0; index < light_num; index++) {
        point = &points[index];
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
void CMap::DrawEffect() {
    CFuncPointCheck check;
    CMapParts **list;
    CMapParts *parts;
    u8 *partsPoint;
    u8 *point;
    int i;
    GetNowTime();
    effect_list.CreatePacket();
    check.time = 0;
    CreateFuncCheck(&check);
    if (init_1301 == 0) {
        new ((u_long128 *)&attr_1300) mgCFrameAttr;
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

#ifdef NONMATCHING
void CMap::DrawWater(mgCCamera *camera, mgCTexture *screen, mgCTexture *overlay) {
    mgCDrawPrim    prim;
    sceVu0FVECTOR  overlay_position;
    sceVu0FVECTOR  overlay_rotation;
    sceVu0FVECTOR  overlay_scale;
    mgCTexture     framebuffer;
    mgRect<int>    screen_rect(0, 0, (mgScreenWidth - 1) * 16, (mgScreenHeight - 1) * 16);
    sceVu0FVECTOR  camera_position;
    sceVu0FVECTOR  camera_direction;
    sceVu0FVECTOR  camera_rotation;
    sceVu0FMATRIX  identity;
    sceVu0FMATRIX  parts_matrix;
    sceVu0FVECTOR  position;
    sceVu0FVECTOR  rotation;
    sceVu0FVECTOR  scale;
    CMapWater     *placement;
    CWaterFrame   *surface;
    CMapParts     *parts;
    int            surface_no;
    int            placement_no;
    int            parts_no;
    int            ripple_row;
    int            ripple_column;

    if (water_surface_num <= 0) {
        return;
    }
    if (screen == NULL) {
        return;
    }
    if (water_num <= 0) {
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
    }

    for (surface_no = 0; surface_no < water_surface_num; surface_no++) {
        if (water_surface[surface_no] != NULL) {
            water_surface[surface_no]->CreatePacket();
            water_surface[surface_no]->SetTexture(screen);
            ripple_row = (int)(48.0f * ((float)rand() / 2147483648.0f));
            ripple_column = (int)(32.0f * ((float)rand() / 2147483648.0f));
            water_surface[surface_no]->Shake(ripple_row, ripple_column, 0.1f);
            water_surface[surface_no]->SetParam(0.15f, 0.0045f, 0.0f, 16.0f);
            water_surface[surface_no]->Step();
            water_surface[surface_no]->SetColor(0x80, 0x80, 0x80, 0x80);
        }
    }

    mgTexManager.ReloadTexture(screen->block, (sceVif1Packet *)NULL);

    mgGetFrameBuffer(&framebuffer);
    mgSetPkMoveImage(&framebuffer, screen_rect, screen, 0, 0, 0);
    placement = water;
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
        placement = water;

        for (placement_no = 0; placement_no < water_num; placement_no++, placement++) {
            surface = placement->frame;
            if (surface != NULL) {
                placement->GetPosition(overlay_position);
                placement->GetRotation(overlay_rotation);
                placement->GetScale(overlay_scale);
                placement->GetPosition(overlay_position);
                placement->GetRotation(overlay_rotation);
                placement->GetScale(overlay_scale);
                if (placement->follow[0] != 0) {
                    overlay_position[0] = camera_position[0];
                }
                if (placement->follow[1] != 0) {
                    overlay_position[1] = camera_position[1];
                }
                if (placement->follow[2] != 0) {
                    overlay_position[2] = camera_position[2];
                }
                surface->SetPosition(overlay_position);
                surface->SetRotation(overlay_rotation);
                if (placement->follow[0] != 0 && placement->follow[2] != 0) {
                    surface->SetRotation(camera_rotation);
                }
                surface->SetColor(0x80, 0x80, 0x80, 0x20);
                surface->SetParam(0.15f, 0.0045f, 0.0f, 300.0f);
                surface->SetScale(overlay_scale);

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
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", DrawWater__4CMapFP9mgCCameraP10mgCTextureP10mgCTexture);
#endif
void CMap::DrawTrBox() { if (tr_box_num == 0 || tr_box == NULL) return; mgTexManager.ReloadTexture(tr_box_texture, (sceVif1Packet *)NULL); int plight_enable = mgGetPlightEnable(); int lighting = mgActiveLighting(2, 1); CFuncPointCheck check; CreateFuncCheck(&check); GetNowTime(); for (int i = 0; i < tr_box_num; i++) { CMapTreasureBox *box = &tr_box[i]; if (!box->active) continue; if (box->parts != NULL && !box->parts->GetShow()) continue; int light_count = 0; if (func_point.flag & FUNC_POINT_MNGR_LIGHT) { float position[4]; box->GetPosition(position); position[3] = 40.0f; light_count = SetFuncPLight(position, &check); } if (light_count > 0) mgPlightEnable(1); box->DrawDirect(); ResetFuncPLight(light_count); } mgPlightEnable(plight_enable); if (lighting >= 0) mgActiveLighting(lighting, 0); }
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
        if (linked_parts != 0 && linked_parts->CheckDraw() == 0)
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
int CMap::GetFixCameraPos(float *pos, float *out_camera_pos) {
    sceVu0FVECTOR projection[8];
    sceVu0FVECTOR direction;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR projection_sum;
    CCameraInfo  *selected;
    CCameraInfo  *camera;
    float         segment_length2;
    float         weight;
    float         nearest_distance2;
    float         nearest_distance;
    float         distance;
    int           camera_no;
    int           rect_no;
    int           segment_no;
    int           projection_num;
    int           nearest_projection;
    int           point_no;

    selected = NULL;
    camera = camera_info;
    for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
        if (camera->rect[0] == NULL) {
            selected = camera;
        }
    }
    camera = camera_info;
    for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
        for (rect_no = 0; rect_no < camera->rect_num; rect_no++) {
            if (camera->rect[rect_no] == NULL) {
                break;
            }
            if (camera->rect[rect_no]->InsidePoint(pos) != 0) {
                selected = camera;
            }
        }
    }

    if (selected == NULL) {
        return MAP_FIX_CAMERA_NONE;
    }
    if (selected->pos_num >= 2) {
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
                if (nearest_projection < 0) {
                    nearest_projection = projection_num;
                } else {
                    nearest_distance2 = mgDistVector2(pos, projection[nearest_projection]);
                    if (mgDistVector2(pos, projection[projection_num]) < nearest_distance2) {
                        nearest_projection = projection_num;
                    }
                }
                projection_num++;
            }
        }

        mgZeroVector(projection_sum);
        for (point_no = 0; point_no < projection_num; point_no++) {
            mgAddVector(projection_sum, projection[point_no]);
        }
        point_no = 0;
        if (projection_num > 0) {
            *(u_long128 *)out_camera_pos = *(u_long128 *)projection[nearest_projection];
            nearest_distance = mgDistVector(out_camera_pos, pos);
        } else {
            nearest_distance = mgDistVector(selected->pos[0], pos);
            *(u_long128 *)out_camera_pos = *(u_long128 *)selected->pos[0];
            point_no = 1;
        }
        for (; point_no < selected->pos_num; point_no++) {
            distance = mgDistVector(pos, selected->pos[point_no]);
            if (distance < nearest_distance) {
                nearest_distance = distance;
                *(u_long128 *)out_camera_pos = *(u_long128 *)selected->pos[point_no];
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

#ifdef NONMATCHING
void CMap::FixCameraPartsOnOff(float *camera_pos) {
    CCameraInfo     *camera;
    CCameraInfo     *selected;
    CCameraDrawInfo *draw_info;
    CPartsGroup     *group;
    int              camera_no;
    int              draw_no;

    camera = camera_info;
    for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
        for (draw_no = 0; draw_no < 4; draw_no++) {
            draw_info = camera->GetDrawInfo(draw_no);
            if (draw_info != NULL) {
                group = GetPartsGroup(draw_info->group_no);
                if (group != NULL) {
                    group->camera_off = 0;
                }
            }
        }
    }
    camera = camera_info;
    selected = NULL;
    for (camera_no = 0; camera_no < camera_info_num; camera_no++, camera++) {
        if (mgDistVector(camera->pos[0], camera_pos) < 10.0f) {
            selected = camera;
            break;
        }
    }
    if (selected != NULL) {
        for (draw_no = 0; draw_no < 4; draw_no++) {
            draw_info = selected->GetDrawInfo(draw_no);
            if (draw_info != NULL) {
                group = GetPartsGroup(draw_info->group_no);
                if (group != NULL) {
                    group->camera_off = 1;
                }
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", FixCameraPartsOnOff__4CMapFPf);
#endif

#ifdef NONMATCHING
CFuncPoint *CMap::GetEvent(float *pos, int check_type, MapEventInfo *info) {
    MapEventInfo    event_info;
    MapEventInfo    nearest_info;
    CFuncPoint     *nearest_point;
    CFuncPoint     *point;
    CMapParts      *parts;
    CFuncPointMngr *manager;
    float          nearest_distance;
    float          distance;
    int            last_event;
    int            accepted;
    int            parts_no;
    int            row;

    nearest_point = NULL;
    event_info.event_no = 0;
    mgUnitMatrix(event_info.matrix);
    event_info.point_no = -1;
    event_info.parts_no = -1;
    func_point.GetStart(FUNC_POINT_EVENT);
    nearest_distance = 0.0f;
    last_event = 0;
    point = func_point.Get();
    while (point != NULL) {
        if (CheckFuncEvent(point, pos, check_type, &event_info, &distance) == 0) {
            if (event_info.event_no != 0) {
                last_event = event_info.event_no;
            }
        } else {
            event_info.point_no = point->event.point_no;
            if (nearest_point == NULL || distance < nearest_distance) {
                nearest_distance = distance;
                nearest_point = point;
                nearest_info.check_type = event_info.check_type;
                nearest_info.event_no = event_info.event_no;
                for (row = 0; row < 4; row++) {
                    *(u_long128 *)nearest_info.matrix[row] = *(u_long128 *)event_info.matrix[row];
                }
                nearest_info.parts_no = event_info.parts_no;
                nearest_info.point_no = event_info.point_no;
            }
        }
        point = func_point.Get();
    }

    parts = place_parts;
    if (parts_event != 0) {
        for (parts_no = 0; parts_no < place_parts_max; parts_no++, parts++) {
            manager = &parts->func_point_mngr;
            if ((manager->flag & FUNC_POINT_MNGR_EVENT) && parts->name[0] != '\0' && parts->GetShow() != 0) {
                manager->GetStart(FUNC_POINT_EVENT);
                point = manager->Get();
                while (point != NULL) {
                    point->frame.SetReference(&parts->frame);
                    accepted = CheckFuncEvent(point, pos, check_type, &event_info, &distance);
                    point->frame.DeleteReference();
                    event_info.parts_no = parts_no;
                    if (event_info.event_no != 0) {
                        last_event = event_info.event_no;
                    }
                    if (accepted != 0) {
                        event_info.point_no = point->event.point_no;
                        if (nearest_point == NULL || distance < nearest_distance) {
                            nearest_distance = distance;
                            nearest_point = point;
                            nearest_info.check_type = event_info.check_type;
                            nearest_info.event_no = event_info.event_no;
                            for (row = 0; row < 4; row++) {
                                *(u_long128 *)nearest_info.matrix[row] = *(u_long128 *)event_info.matrix[row];
                            }
                            nearest_info.parts_no = event_info.parts_no;
                            nearest_info.point_no = event_info.point_no;
                        }
                    }
                    point = manager->Get();
                }
            }
        }
    }
    if (info != NULL) {
        info->check_type = nearest_info.check_type;
        info->event_no = nearest_info.event_no;
        for (row = 0; row < 4; row++) {
            *(u_long128 *)info->matrix[row] = *(u_long128 *)nearest_info.matrix[row];
        }
        info->parts_no = nearest_info.parts_no;
        info->point_no = nearest_info.point_no;
        info->event_no = last_event;
    }
    return nearest_point;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", GetEvent__4CMapFPfiP12MapEventInfo);
#endif
CFuncPoint *CMap::InScreenFunc(InScreenFuncInfo *info) { CFuncPoint *hit = NULL; int saved_value = 0; float nearest = 0.0f; for (int i = 0; i < place_parts_max; i++) { CMapParts *parts = &place_parts[i]; if (parts->name[0] == 0 || !parts->CheckDraw()) continue; CFuncPoint *result = parts->InScreenFunc(info); if (result == NULL) continue; if (hit != NULL && !(info->dist < nearest)) continue; hit = result; saved_value = info->unk_04; nearest = info->dist; } info->unk_04 = saved_value; return hit; }
void CMap::DrawScreenFunc(mgCFrame *frame) { for (int i = 0; i < place_parts_max; i++) { CMapParts *parts = &place_parts[i]; if (parts->name[0] != 0 && parts->CheckDraw()) parts->DrawScreenFunc(frame); } }

void CMap::EffectStep() {
    anime_time += 1.0f;
    anime_frame = (int)anime_time;
    effect_list.Step();
}

#ifdef NONMATCHING
void CMap::AnimeStep(CObjAnimeEnv *env) {
    CFuncPointCheck check;
    CObjAnime      *animation;
    int             i;

    CreateFuncCheck(&check);
    for (i = 0; i < place_parts_num; i++) {
        place_parts[i].AnimeStep(&check, env);
    }
    if (obj_anime_num > 0) {
        animation = obj_anime;
        if (animation == NULL) {
            return;
        }
        for (i = 0; i < obj_anime_num; i++, animation++) {
            if (animation->func_point != NULL && animation->func_point->Check(&check)) {
                animation->Step(env);
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", AnimeStep__4CMapFP12CObjAnimeEnv);
#endif
void CMap::Step() { for (int i = 0; i < place_parts_num; i++) place_parts[i].Step(); }
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

#ifdef NONMATCHING
void CMap::AssignFuncPoint(mgCMemory *stack) {
    CObjAnime  *animation;
    CFuncPoint *point;
    CMapParts  *parts;

    obj_anime_num = func_point.GetNum(FUNC_POINT_ANIME);
    if (obj_anime_num > 0) {
        obj_anime = new (stack->Alloc((obj_anime_num * sizeof(CObjAnime) + 15) / 16 + 2)) CObjAnime[obj_anime_num];
        animation = obj_anime;
        if (animation != NULL) {
            func_point.GetStart(FUNC_POINT_ANIME);
            for (point = func_point.Get(); point != NULL; point = func_point.Get(), animation++) {
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
            }
            func_point.GetEnd();
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", AssignFuncPoint__4CMapFP9mgCMemory);
#endif
CObjAnime::CObjAnime() {
    frame = 0;
    piece = 0;
    parts = 0;
    func_point = 0;
    back = 0;
    stop = 0;
}

#ifdef NONMATCHING
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
        if (parts->name[0] != '\0') {
            tr_box_num += parts->func_point_mngr.GetEventNum(FUNC_EVENT_TREASURE_BOX);
        }
    }

    tr_box = new (stack->Alloc((tr_box_num * sizeof(CMapTreasureBox) + 15) / 16 + 2)) CMapTreasureBox[tr_box_num];
    if (tr_box == NULL) {
        tr_box_num = 0;
    }

    box_index = 0;
    for (parts_index = -1; parts_index < place_parts_max; parts_index++) {
        if (box_index >= tr_box_num) {
            break;
        }
        parts = NULL;
        if (parts_index < 0) {
            manager = &func_point;
        } else {
            parts = &place_parts[parts_index];
            manager = &parts->func_point_mngr;
        }
        manager->GetStart(FUNC_POINT_EVENT);
        for (point = manager->Get(); point != NULL; point = manager->Get()) {
            if ((point->event.flag & FUNC_EVENT_TREASURE_BOX) != 0) {
                tr_box_model->Copy(tr_box[box_index], stack);
                tr_box[box_index].AssignFuncPoint(point, parts);
                point->event.point_no = box_index;
                box_index++;
            }
        }
        manager->GetEnd();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory);
#endif
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

#ifdef NONMATCHING
void CMap::LoadData(unsigned int *pcp_pack, unsigned int *img_pack, int *tex_block, mgCMemory *stack) {
    mgCEnterIMGInfo info;
    char          *name;
    unsigned int  *file;
    int            block;
    int            first_block;
    int            index;

    if (mds_list_set != NULL) {
        block = *tex_block;
        for (index = 0; (name = GetImgName(index)) != NULL; index++) {
            file = GetPackFile(img_pack, name, NULL);
            printf("%x %s\n", file, name);
            if (file != NULL) {
                first_block = block;
                block += mgTexManager.EnterIMGFile((u_char *)file, block, stack, &info) + 1;
                mgTexManager.EndEnterTexture(first_block);
                mds_list_set->LoadIMGFile(name, &info, stack);
            }
        }
        for (index = 0; (name = GetPCPName(index)) != NULL; index++) {
            file = GetPackFile(pcp_pack, name, NULL);
            if (file != NULL) {
                mds_list_set->LoadPCPFile(name, file, stack, all_scissor);
            }
        }
        *tex_block = block - *tex_block;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", LoadData__4CMapFPUiPUiPiP9mgCMemory);
#endif

#ifdef NONMATCHING
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
        if (flags & (FUNC_EVENT_ACTION | FUNC_EVENT_ITEM)) {
            switch (check_type) {
            case 0:
                if (flags & FUNC_EVENT_ACTION) {
                    return 0;
                }
                if (flags & FUNC_EVENT_ITEM) {
                    return 0;
                }
                break;
            case 1:
                if (!(flags & FUNC_EVENT_ACTION)) {
                    return 0;
                }
                break;
            case 2:
                if (!(flags & FUNC_EVENT_ITEM)) {
                    return 0;
                }
                break;
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", CheckFuncEvent__FP10CFuncPointPfiP12MapEventInfoPf);
#endif
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
INCLUDE_BSS(init_1301, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(attr_1300, 0x90);
