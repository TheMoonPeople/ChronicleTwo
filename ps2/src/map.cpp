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

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", SetFlag__12CMapFlagDataFii);
int CMapFlagData::GetFlag(int index) {
    if (index < 0 || index >= MAP_FLAG_MAX) {
        return 0;
    }
    u32 mask = 1;
    mask <<= index % 32;
    return (mask & flag[index / 32]) != 0;
}
char *CMap::Iam() { return CMapName; }
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
void CMapWater::Clear() { parts_num = 0; if (parts != NULL) { for (int i = 0; i < parts_max; i++) { parts[i] = NULL; } } }
CPartsGroup *CMap::GetPartsGroup(int index) {
    if (index < 0 || index >= parts_group_max)
        return 0;
    return &parts_group[index];
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
CMapParts *CMap::GetPlacPartsTable(int *effect_num) {
    *effect_num = place_parts_max;
    return (CMapParts *)place_parts;
}
void CMap::SetCameraInfoTable(CCameraInfo *info, int num) { camera_info_num = num; camera_info = info; }
CCameraInfo *CMap::GetCameraInfo(int index) { if (index < 0 || index >= camera_info_num) return NULL; return &camera_info[index]; }
CMapParts *CMap::NewPlaceParts() { for (int i = 0; i < place_parts_max; i++) { if (place_parts[i].name[0] == 0) return &place_parts[i]; } return NULL; }
CMdsInfo *CMap::SearchMDS(char *name) { if (mds_list_set != NULL) return mds_list_set->SearchMDS(name); return NULL; }
void CMap::CreateEffect(u32 *data, int size, mgCMemory *memory) {
    effect_list.LoadEFPFile(at_574, data, size, memory);
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
    CList<CMapParts> *node;
    CMapParts *parts;
    if (name == 0 || *(s8 *)name == 0)
        return 0;
    for (node = parts_list; node != 0; node = node->next) {
        parts = &node->data;
        if (parts != 0 && parts->name != 0 && strcasecmp(name, parts->name) == 0)
            return parts;
    }
    return 0;
}
void CMap::CreateDrawRect(mgCMemory *memory, mgVu0FBOX *rect, mgVu0FBOX *clip, int outside) { mgVu0FBOX parts_box; for (int i = 0; i < draw_rect_max; i++) { MapDrawOffRect *slot = &draw_rect[i]; if (slot->used) continue; slot->used = 1; slot->area = *rect; slot->outside = outside; slot->parts = NULL; for (int j = 0; j < place_parts_max; j++) { CMapParts *part = &place_parts[j]; if (part->name[0] == 0 || !part->GetBoundBox(&parts_box)) continue; if (!mgClipInBox(parts_box.max, parts_box.min, clip->max, clip->min)) continue; CList<CMapParts *> *node = new (memory->Alloc(3)) CList<CMapParts *>; node->data = part; CList<CMapParts *> *last = slot->parts; if (last == NULL) slot->parts = node; else { while (last->next != NULL) last = last->next; last->next = node; node->prev = last; } } break; } }
void CMap::CreateOcclusion(float (*matrix)[4]) { if (occlusion_num >= MAP_OCCLUSION_MAX) return; memcpy(occlusion[occlusion_num].vertex, matrix, sizeof(sceVu0FMATRIX)); occlusion[occlusion_num].enable = 1; occlusion_num++; }
CMapParts *CMap::PlaceParts(char *name, float *pos, float *rot, float *scale, mgCMemory *memory) { CMapParts *src = GetParts(name); if (src == NULL) return NULL; CMapParts *placed = NewPlaceParts(); if (placed == NULL) return NULL; src->Copy(*placed, memory); placed->SetPosition(pos); placed->SetRotation(rot); placed->SetScale(scale); return placed; }
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", PlacePartsEnd__4CMapFv);
void CMap::ClearPlaceParts() { for (int i = 0; i < place_parts_max; i++) { place_parts[i].Initialize(); } bbox_valid = 0; place_parts_num = 0; }
CMapParts *CMap::GetPlaceParts(char *name) { if (name == NULL) return NULL; for (int i = 0; i < place_parts_max; i++) { if (strcmp(place_parts[i].name, name) == 0) return &place_parts[i]; } return NULL; }
CMapParts *CMap::GetPlaceParts(int index) { return &place_parts[index]; }
int CMap::ConvertParts(CMapParts *parts) {
    int index = -1;
    if (parts != 0)
        index = (parts - place_parts);
    return index;
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
int CMap::GetBBox(mgVu0FBOX *box) {
    (*box = bbox);
    return bbox_valid;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", PreDraw__4CMapFPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", GetCharaLight__4CMapFP9mgCObjectP10CFuncPointii);
int CMap::SetFuncPLight(float *pos, CFuncPointCheck *check) {
    int effect_num;
    int i;
    float color[4];
    if (init_1249 == 0) {
        for (int slot = 0; slot < 8; slot++) new ((u_long128 *)&ft_1248[slot]) CFuncPoint;
        init_1249 = 1;
    }
    effect_num = func_point.GetLight(pos, ft_1248, 3, check, 0);
    for (i = 0; i < effect_num; i++) {

        CFuncPoint *point = &ft_1248[i];
        sceVu0ScaleVector((float *)color, point->plight.color,
                          GetLightAnimeWeight((CFuncPoint *)point, anime_frame));
        mgSetPlight(3 - i, point->position, color, point->plight.power,
                    point->plight.range);
    }
    return effect_num;
}
CFuncPoint::CFuncPoint() {}
void CMap::ResetFuncPLight(int effect_num) {
    int i;
    for (i = 0; i < effect_num; i++)
        mgSetPlight(3 - i, 0);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", DrawWater__4CMapFP9mgCCameraP10mgCTextureP10mgCTexture);
void CMap::DrawTrBox() { if (tr_box_num == 0 || tr_box == NULL) return; mgTexManager.ReloadTexture(tr_box_texture, (sceVif1Packet *)NULL); int plight_enable = mgGetPlightEnable(); int lighting = mgActiveLighting(2, 1); CFuncPointCheck check; CreateFuncCheck(&check); GetNowTime(); for (int i = 0; i < tr_box_num; i++) { CMapTreasureBox *box = &tr_box[i]; if (!box->active) continue; if (box->parts != NULL && !box->parts->GetShow()) continue; int light_count = 0; if (func_point.flag & FUNC_POINT_MNGR_LIGHT) { float position[4]; box->GetPosition(position); position[3] = 40.0f; light_count = SetFuncPLight(position, &check); } if (light_count > 0) mgPlightEnable(1); box->DrawDirect(); ResetFuncPLight(light_count); } mgPlightEnable(plight_enable); if (lighting >= 0) mgActiveLighting(lighting, 0); }
int CObject::GetShow() { return show; }
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
int CMap::GetColPoly(CCPoly *poly, mgVu0FBOX &box, int index) {
    return GetPoly(1, poly, box, index);
}
int CMap::GetCameraPoly(CCPoly *poly, mgVu0FBOX &box, int index) {
    return GetPoly(3, poly, box, index);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", GetFixCameraPos__4CMapFPfPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", FixCameraPartsOnOff__4CMapFPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", GetEvent__4CMapFPfiP12MapEventInfo);
CFuncPoint *CMap::InScreenFunc(InScreenFuncInfo *info) { CFuncPoint *hit = NULL; int saved_value = 0; float nearest = 0.0f; for (int i = 0; i < place_parts_max; i++) { CMapParts *parts = &place_parts[i]; if (parts->name[0] == 0 || !parts->CheckDraw()) continue; CFuncPoint *result = parts->InScreenFunc(info); if (result == NULL) continue; if (hit != NULL && !(info->dist < nearest)) continue; hit = result; saved_value = info->unk_04; nearest = info->dist; } info->unk_04 = saved_value; return hit; }
void CMap::DrawScreenFunc(mgCFrame *frame) { for (int i = 0; i < place_parts_max; i++) { CMapParts *parts = &place_parts[i]; if (parts->name[0] != 0 && parts->CheckDraw()) parts->DrawScreenFunc(frame); } }
void CMap::EffectStep() {
    anime_time += 1.0f;
    anime_frame = fptosi(anime_time);
    effect_list.Step();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", AnimeStep__4CMapFP12CObjAnimeEnv);
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
void CMap::CreateMap(CMdsListSet *mdsListSet, mgCMemory *memory) {
    int length;
    char *add_map_file;

    add_map_file = GetAddMapFile(&length);
    if (add_map_file != NULL) {
        if (length > 0) {
            LoadMapFile(add_map_file, length, memory, 1);
        }
    }
    LoadMapFile(GetMapFile(&length), length, memory, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", AssignFuncPoint__4CMapFP9mgCMemory);
CObjAnime::CObjAnime() {
    frame = 0;
    piece = 0;
    parts = 0;
    func_point = 0;
    back = 0;
    stop = 0;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory);
CMapTreasureBox::CMapTreasureBox() { Initialize(); }
CMapTreasureBox *CMap::GetTrBox(int index) {
    if (index < 0 || index > tr_box_num || tr_box == NULL) {
        return NULL;
    }
    return &tr_box[index];
}
void CMap::DeleteTrBox(int index, CMapFlagData *flagData) {
    CMapTreasureBox *box;
    int flag_no;

    box = GetTrBox(index);
    if (box != NULL) {
        box->active = 0;
        flag_no = box->flag_no;
        if (flag_no > 0) {
            if (flagData != NULL) {
                flagData->SetFlag(flag_no, 1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", LoadData__4CMapFPUiPUiPiP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/map", CheckFuncEvent__FP10CFuncPointPfiP12MapEventInfoPf);
int CMap::Draw() { return DrawSub(0); }
int CMap::DrawDirect() { return DrawSub(1); }
int CObject::Draw() { return 0; }
int CObject::DrawDirect() { return 0; }
void CObject::Show(int showFlag) {
    this->show = showFlag;
}
void CObject::SetFarDist(float dist) {
    this->far_dist = dist;
}
float CObject::GetFarDist(void) {
    return this->far_dist;
}
void CObject::SetNearDist(float dist) {
    this->near_dist = dist;
}
float CObject::GetNearDist(void) {
    return this->near_dist;
}
void CObject::Copy(CObject &dest, mgCMemory *memory) { memcpy(dest.position, position, sizeof(position)); memcpy(dest.rotation, rotation, sizeof(rotation)); memcpy(dest.scale, scale, sizeof(scale)); dest.changed = changed; dest.use_srt = use_srt; dest.far_dist = far_dist; dest.fade = fade; dest.fade_alpha = fade_alpha; dest.fade_speed = fade_speed; dest.near_dist = near_dist; dest.show = show; dest.draw_off = draw_off; }

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
