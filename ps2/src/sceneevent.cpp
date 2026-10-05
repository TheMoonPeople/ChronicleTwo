#include "common.h"
#include "map.hpp"
#include "mapload.hpp"
#include "mg_drawenv.hpp"
#include "mg_texture.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "screeneffect.hpp"
#include "collision.hpp"
#include "mapsky.hpp"
#include <cstdio>
#include <cstring>

extern float col_1003[4][4];
extern float at_1013__4[4];
extern char at_858__3[];
extern char at_958__3[];
extern char at_959__3[];
extern char at_1093[];

// Code (.text)
void CScene::UpDateMapInfo() {
    CMap *active_maps[4];
    CMapLightingInfo *lighting;
    int count = GetActiveMap(active_maps, 4);
    int i;
    for (i = 0; i < count; i++) {
        if (active_maps[i] != NULL) {
            active_maps[i]->now_time = time;
        }
    }
    CMap *map = GetMap(active_map);
    if (map != NULL) {
        CMapLightingInfo lighting_data;
        map->GetLightInfo(lighting = &lighting_data);
        mgFogEnable(lighting->fog_enable);
        if (lighting->fog_enable != 0) {
            mgSetFogParam(lighting->fog.near_dist, lighting->fog.far_dist, lighting->fog.r,
                          lighting->fog.g, lighting->fog.b, lighting->fog.far_value,
                          lighting->fog.near_value);
        }
        mgSetRenderInfo(lighting->projection, 3.0f, 50000.0f);
        mgSetLight(lighting->light_dir, lighting->light_color);
        mgSetAmbient(lighting->ambient);
        mgResetPlight();
        if (lighting->plight_enable != 0) {
            mgPlightEnable(1);
            int light;
            for (light = 0; light < 4; light++) {
                mgSetPlight(light, (mgPOINT_LIGHT *)&lighting->point_light[light]);
            }
        }
        mgSetBackGround(lighting->bg_color);
    }
}
int CScene::GetColPoly(CCPoly *polys, mgVu0FBOX &box, int max) {
    CMap *maps[4];
    int count = GetActiveMap(maps, 4);
    int total = 0;
    int i;
    for (i = 0; i < count; i++) {
        int found = maps[i]->GetColPoly(polys, box, max);
        total += found;
        polys += found;
        max -= found;
        if (max < 0) {
            break;
        }
    }
    return total;
}
int CScene::GetCameraPoly(CCPoly *polys, mgVu0FBOX &box, int max) {
    CMap *maps[4];
    int count = GetActiveMap(maps, 4);
    int total = 0;
    int i;
    for (i = 0; i < count; i++) {
        int found = maps[i]->GetCameraPoly(polys, box, max);
        total += found;
        polys += found;
        max -= found;
        if (max < 0) {
            break;
        }
    }
    return total;
}
void CScene::RunEvent(int event_number, CSceneEventData *data) {
    if (event_run == 0 || (printf(at_858__3), event_no != 100)) {
        event_no = event_number;
        if (data != NULL) {
            event_data.head = data->head;
            event_data.group_1 = data->group_1;
            event_data.group_2 = data->group_2;
            event_data.group_3 = data->group_3;
            event_data.group_4 = data->group_4;
            event_data.group_5 = data->group_5;
            event_data.vectors_a = data->vectors_a;
            event_data.vectors_b = data->vectors_b;
            event_data.chara_no = data->chara_no;
            event_data.chara_slot = data->chara_slot;
            event_data.gameobj_no = data->gameobj_no;
            event_data.unk_cc = data->unk_cc;
        }
        event_run = 1;
    }
}
int CScene::GetMapEvent(float *position, int map_no, CSceneEventData *event) {
    CMap *maps[4];
    MapEventInfo result;
    int flag_no;
    int count = GetActiveMap(maps, 4);
    int i;
    flag_no = 0;
    for (i = 0; i < count; i++) {
        CFuncPoint *point = maps[i]->GetEvent(position, map_no, &result);
        if (result.event_no != 0) {
            flag_no = result.event_no;
        }
        if (point != NULL) {
            if (event != NULL) {
                *(u_long128 *)event->position = *(u_long128 *)point->position;
                *(u_long128 *)event->rotation = *(u_long128 *)point->rotation;
                *(u_long128 *)event->scale = *(u_long128 *)point->scale;
                event->event.flag = point->event.flag;
                event->event.event_no = point->event.event_no;
                event->event.unk_28 = point->event.unk_28;
                event->event.unk_2c = point->event.unk_2c;
                event->event.unk_30 = point->event.unk_30;
                event->event.unk_34 = point->event.unk_34;
                memcpy(event->event.unk_38, point->event.unk_38, sizeof(event->event.unk_38));
                event->map_event.check_type = result.check_type;
                event->map_event.event_no = result.event_no;
                memcpy(event->map_event.matrix, result.matrix, sizeof(event->map_event.matrix));
                event->map_event.parts_no = result.parts_no;
                event->map_event.point_no = result.point_no;
            }
            return 1;
        }
    }
    map_event_no = flag_no;
    int object_chara = GetGameObjectEvent(position, event);
    if (object_chara < 0) {
        return 0;
    }
    map_event_no = 1;
    if (map_no != 1) {
        return 0;
    }
    if (object_chara == 0x78) {
        event->event.unk_28 = 300;
    } else if (object_chara == 0x7A) {
        event->event.unk_28 = 400;
    }
    return 1;
}
int CScene::GetFixCameraPos(float *position, float *out_camera) {
    float lifted[4];
    CMap *maps[4];
    int count;
    int i;
    *(u_long128 *)lifted = *(u_long128 *)position;
    lifted[1] += 1.0f;
    count = GetActiveMap(maps, 4);
    for (i = 0; i < count; i++) {
        if (maps[i]->GetFixCameraPos(lifted, out_camera) != 0) {
            return 1;
        }
    }
    return 0;
}
void CScene::FixCameraPartsOnOff(float *position) {
    CMap *maps[4];
    int count = GetActiveMap(maps, 4);
    int i;
    for (i = 0; i < count; i++) {
        maps[i]->FixCameraPartsOnOff(position);
    }
}
void CScene::EyeViewDrawOnOff(int on) {
    CMap *maps[4];
    int count;
    int i;
    count = GetActiveMap(maps, 4);
    for (i = 0; i < count; i++) {
        CPartsGroup *hidden = maps[i]->SearchPartsGroup(at_958__3);
        CPartsGroup *shown = maps[i]->SearchPartsGroup(at_959__3);
        if (hidden != NULL) {
            hidden->off = (unsigned char)((on != 0) ^ 1);
        }
        if (shown != NULL) {
            shown->off = on;
        }
    }
}
void CScene::GetSunPosition(float *sun_position) {
    float camera_position[4];
    mgCCamera *camera;
    CMap *map;
    mgZeroVector(camera_position);
    camera = GetCamera(active_camera);
    if (camera != NULL) {
        camera->GetPos(camera_position);
    }
    map = GetMap(active_map);
    if (map != NULL) {
        map->GetSunPoint(sun_position);
        sceVu0Normalize(sun_position, sun_position);
        sceVu0ScaleVector(sun_position, sun_position, 5000.0f);
        sun_position[0] += camera_position[0];
        sun_position[1] += map->unk_dc;
        sun_position[2] += camera_position[2];
    }
}
void CScene::GetMoonPosition(float *position) {
    GetSunPosition(position);
    position[1] *= -1.0f;
}
void CScene::DrawSky(int sky_index) {
    float camera_info[4];
    float sun_position[4];
    float moon_position[4];
    float lighting_ratio[8];
    float sun_ratio[8];
    CMapLightingInfo lighting;
    float sky_color_a[4];
    float sky_color_b[4];
    CMapSky *sky;
    mgCCamera *camera;
    CMap *map;
    if (sky_index < 0) {
        sky = GetSky(1);
        if (sky == NULL) {
            sky = GetSky(0);
        }
    } else {
        sky = GetSky(sky_index);
    }
    if (sky != NULL) {
        mgZeroVector(camera_info);
        camera = GetCamera(active_camera);
        if (camera != NULL) {
            camera->GetPos(camera_info);
            camera_info[3] = camera->GetAngleH();
        }
        map = GetMap(active_map);
        if (map != NULL && map->sky_info != 0) {
            camera_info[1] = map->unk_dc;
            map->GetLightInfo(&lighting);
            map->GetLightingRatio(lighting_ratio);
            map->GetLightingSunRatio(sun_ratio);
            GetSunPosition(sun_position);
            GetMoonPosition(moon_position);
            sceVu0CopyVector(sky_color_a, lighting.bg_color);
            sceVu0ScaleVector(sky_color_a, sky_color_a, 0.0078125f);
            sky_color_a[3] = 1.0f;
            sceVu0CopyVector(sky_color_b, lighting.bg_color2);
            sceVu0ScaleVector(sky_color_b, sky_color_b, 0.0078125f);
            sky_color_b[3] = 1.0f;
            sky->DrawSkyBack(camera_info, sky_color_a, sky_color_b);
            sky->DrawSky(camera_info, sun_position, moon_position,
                                          map->GetNowTimeBand(), lighting_ratio, sun_ratio);
        }
    }
}
void CScene::DrawLensFlare(int flare_type, char *texture, char *alpha_texture) {
    float ratio[4];
    float color[4];
    float sun_position[4];
    int screen[4];
    CMap *map = GetMap(active_map);
    if (map != NULL && map->sky_info != 0) {
        if (map->lens_flare == 0) {
            return;
        }
    } else {
        return;
    }
    map->GetLightingFlareRatio(ratio);
    if (ratio[0] != 0.0f || ratio[1] != 0.0f || ratio[3] != 0.0f) {
        sceVu0CopyVector(color, at_1013__4);
        color[0] += col_1003[0][0] * ratio[0];
        color[1] += col_1003[0][1] * ratio[0];
        color[2] += col_1003[0][2] * ratio[0];
        color[0] += col_1003[1][0] * ratio[1];
        color[1] += col_1003[1][1] * ratio[1];
        color[2] += col_1003[1][2] * ratio[1];
        color[0] += col_1003[2][0] * ratio[2];
        color[1] += col_1003[2][1] * ratio[2];
        color[2] += col_1003[2][2] * ratio[2];
        color[0] += col_1003[3][0] * ratio[3];
        color[1] += col_1003[3][1] * ratio[3];
        color[2] += col_1003[3][2] * ratio[3];
        GetSunPosition(sun_position);
        sun_position[3] = 1.0f;
        if (mgTransWorldScreen(screen, sun_position) != 0) {
            screen[2] = mgTransZPrim(10000.0f);
            LensFlare(screen, color, flare_type, texture, alpha_texture);
        }
    }
}
void CScene::EffectStep() {
    CMap *maps[4];
    int count = GetActiveMap(maps, 4);
    int i;
    for (i = 0; i < count; i++) {
        maps[i]->EffectStep();
    }
    fire_raster.Step();
}
void CScene::DrawEffect(int tex_block) {
    CMap *maps[4];
    mgCTextureManager *tex_manager = &mgTexManager;
    mgCTexture *fire_texture;
    int count = GetActiveMap(maps, 4);
    int i;
    int j;
    int k;
    for (i = 0; i < count; i++) {
        int block = maps[i]->effect_list.block;
        if (block >= 0) {
            tex_manager->ReloadTexture(block, (sceVif1Packet *)NULL);
            maps[i]->DrawEffect();
        }
    }
    tex_manager->ReloadTexture(tex_block, (sceVif1Packet *)NULL);
    for (j = 0; j < count; j++) {
        if (maps[j] != NULL) {
            maps[j]->fire_raster = &fire_raster;
            maps[j]->DrawFireEffect(tex_block);
            maps[j]->fire_raster = NULL;
        }
    }
    fire_texture =
        tex_manager->GetTexture(at_1093, tex_block);
    fire_raster.SetTexture(fire_texture);
    mgCTexture frame;
    mgRect<int> rect;
    mgGetFrameBuffer(&frame);
    rect.Set( 0, 0, (mgScreenWidth - 1) << 4, (mgScreenHeight - 1) << 4);
    mgSetPkMoveImage(&frame, rect, fire_texture, 0, 0, 0);
    for (k = 0; k < count; k++) {
        if (maps[k] != NULL) {
            maps[k]->fire_raster = &fire_raster;
            maps[k]->DrawFireRaster();
            maps[k]->fire_raster = NULL;
        }
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneevent", col_1003__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneevent", at_1013__4__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneevent", at_858__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneevent", at_958__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneevent", at_959__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneevent", at_1093__DATA);
