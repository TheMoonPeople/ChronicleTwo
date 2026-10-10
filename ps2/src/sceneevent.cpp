#include "common.h"

#include <cstdio>
#include <cstring>

#include "collision.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapsky.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "screeneffect.hpp"

/**
 *
 * Scene event vector viewed as floats or a quadword.
 *
 */
union CopyVector {
    float     f[4]; /**< Floating point components. */
    u_long128 word; /**< The same components as one quadword. */
};

/**
 *
 * Name copied into a scene event record.
 *
 */
struct CopyEventName {
    char text[16]; /**< Event name. */
};

/**
 *
 * Integer words copied into a scene event record.
 *
 */
struct CopyEventWords {
    int value[16]; /**< Event data words. */
};

#include "mg_tanime.hpp"

static sceVu0FVECTOR at_1013__4 = {0.0f, 0.0f, 0.0f, 78.0f};

// Code (.text)
void CScene::UpDateMapInfo() {
    CMap             *active_maps[4];
    CMapLightingInfo *lighting;
    int               count = GetActiveMap(active_maps, 4);
    int               i;

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
                mgSetPlight(light, (mgPOINT_LIGHT *) &lighting->point_light[light]);
            }
        }

        mgSetBackGround(lighting->bg_color);
    }
}

int CScene::GetColPoly(CCPoly *polys, mgVu0FBOX &box, int max) {
    CMap *maps[4];
    int   count = GetActiveMap(maps, 4);
    int   total = 0;
    int   i;

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
    int   count = GetActiveMap(maps, 4);
    int   total = 0;
    int   i;

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

void CScene::RunEvent(int requested_event_no, CSceneEventData *data) {
    if (event_run == 0 || (printf("start event running!!\n"), event_no != 100)) {
        event_no = requested_event_no;

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
    CMap        *maps[4];
    MapEventInfo result;
    int          flag_no;
    int          count = GetActiveMap(maps, 4);
    int          i;
    flag_no = 0;

    for (i = 0; i < count; i++) {
        CFuncPoint *point = maps[i]->GetEvent(position, map_no, &result);

        if (result.event_no != 0) {
            flag_no = result.event_no;
        }

        if (point != NULL) {
            if (event != NULL) {
                *(CopyVector *) event->position = *(CopyVector *) point->position;
                *(CopyVector *) event->rotation = *(CopyVector *) point->rotation;
                *(CopyVector *) event->scale = *(CopyVector *) point->scale;
                event->event.flag = point->event.flag;
                event->event.event_no = point->event.event_no;
                event->event.point_no = point->event.point_no;
                event->event.arg1 = point->event.arg1;
                event->event.arg2 = point->event.arg2;
                event->event.arg3 = point->event.arg3;
                *(CopyEventName *) event->event.target = *(CopyEventName *) point->event.target;
                event->map_event.check_type = result.check_type;
                event->map_event.event_no = result.event_no;
                *(CopyEventWords *) event->map_event.matrix = *(CopyEventWords *) result.matrix;
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
        event->event.point_no = 300;
    } else if (object_chara == 0x7A) {
        event->event.point_no = 400;
    }

    return 1;
}

int CScene::GetFixCameraPos(float *position, float *out_camera) {
    float lifted[4];
    CMap *maps[4];
    int   count;
    int   i;
    *(u_long128 *) lifted = *(u_long128 *) position;
    lifted[1] += 1.0f;
    count = GetActiveMap(maps, 4);

    for (i = 0; i < count; i++) {
        if (maps[i]->GetFixCameraPos(lifted, out_camera) != 0) {
            return 1;
        }
    }

    return 0;
}

void CScene::FixCameraPartsOnOff(float *pos) {
    CMap *maps[4];
    int   count = GetActiveMap(maps, 4);

    for (int index = 0; index < count; ++index) {
        maps[index]->FixCameraPartsOnOff(pos);
    }
}

void CScene::EyeViewDrawOnOff(int on) {
    CMap *maps[4];
    int   count = GetActiveMap(maps, 4);

    for (int index = 0; index < count; ++index) {
        CPartsGroup *shown = maps[index]->SearchPartsGroup("eyeview_on");
        CPartsGroup *hidden = maps[index]->SearchPartsGroup("eyeview_off");

        if (shown != NULL) {
            shown->off = (u8) ((on != 0) ^ 1);
        }

        if (hidden != NULL) {
            hidden->off = on;
        }
    }
}

void CScene::GetSunPosition(float *pos) {
    sceVu0FVECTOR camera_pos;
    mgZeroVector(camera_pos);
    mgCCamera *camera = GetCamera(active_camera);

    if (camera != NULL) {
        camera->GetPos(camera_pos);
    }

    CMap *map = GetMap(active_map);

    if (map == NULL) {
        return;
    }

    map->GetSunPoint(pos);
    sceVu0Normalize(pos, pos);
    sceVu0ScaleVector(pos, pos, 5000.0f);
    pos[0] += camera_pos[0];
    pos[1] += map->map_info.sky_height;
    pos[2] += camera_pos[2];
}

void CScene::GetMoonPosition(float *pos) {
    GetSunPosition(pos);
    pos[1] *= -1.0f;
}

void CScene::DrawSky(int sky_index) {
    float camera_info[4];
    float sun_position[4];
    float moon_position[4];
    float lighting_ratio[8];
    float sun_ratio[8];

    union {
        CMapLightingInfo lighting;
    };

    float      sky_color_a[4];
    float      sky_color_b[4];
    CMapSky   *sky;
    mgCCamera *camera;
    CMap      *map;

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

        if (map != NULL && map->map_info.sky_info != 0) {
            camera_info[1] = map->map_info.sky_height;
            memset(&lighting, 0, sizeof(lighting));
            map->GetLightInfo(&lighting);
            map->GetLightingRatio(lighting_ratio);
            map->GetLightingSunRatio(sun_ratio);
            GetSunPosition(sun_position);
            GetMoonPosition(moon_position);
            *(CopyVector *) sky_color_a = *(CopyVector *) lighting.bg_color;
            sceVu0ScaleVector(sky_color_a, sky_color_a, 0.0078125f);
            sky_color_a[3] = 1.0f;
            *(CopyVector *) sky_color_b = *(CopyVector *) lighting.bg_color2;
            sceVu0ScaleVector(sky_color_b, sky_color_b, 0.0078125f);
            sky_color_b[3] = 1.0f;
            sky->DrawSkyBack(camera_info, sky_color_a, sky_color_b);
            sky->DrawSky(camera_info, sun_position, moon_position,
                         map->GetNowTimeBand(), lighting_ratio, sun_ratio);
        }
    }
}

void CScene::DrawLensFlare(int flare_type, char *texture, char *alpha_texture) {
    // Lens-flare color for each map time band.
    static float col[4][4] __attribute__((aligned(16))) = {
        {128.0f, 128.0f, 128.0f, 128.0f},
        {192.0f, 96.0f,  0.0f,   128.0f},
        {0.0f,   0.0f,   0.0f,   0.0f  },
        {128.0f, 128.0f, 128.0f, 128.0f}
    };

    float ratio[4];
    float color[4];
    float sun_position[4];
    int   screen[4];
    CMap *map = GetMap(active_map);

    if (map != NULL && map->map_info.sky_info != 0) {
        if (map->map_info.lens_flare == 0) {
            return;
        }
    } else {
        return;
    }

    map->GetLightingFlareRatio(ratio);

    if (ratio[0] != 0.0f || ratio[1] != 0.0f || ratio[3] != 0.0f) {
        *(CopyVector *) color = *(const CopyVector *) at_1013__4;
        color[0] += col[0][0] * ratio[0];
        color[1] += col[0][1] * ratio[0];
        color[2] += col[0][2] * ratio[0];
        color[0] += col[1][0] * ratio[1];
        color[1] += col[1][1] * ratio[1];
        color[2] += col[1][2] * ratio[1];
        color[0] += col[2][0] * ratio[2];
        color[1] += col[2][1] * ratio[2];
        color[2] += col[2][2] * ratio[2];
        color[0] += col[3][0] * ratio[3];
        color[1] += col[3][1] * ratio[3];
        color[2] += col[3][2] * ratio[3];
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
    int   count = GetActiveMap(maps, 4);

    for (int index = 0; index < count; ++index) {
        maps[index]->EffectStep();
    }

    fire_raster.Step();
}

void CScene::DrawEffect(int tex_block) {
    CMap              *maps[4];
    mgCTextureManager *tex_manager = &mgTexManager;
    mgCTexture        *fire_texture;
    int                count = GetActiveMap(maps, 4);
    int                i;
    int                j;
    int                k;

    for (i = 0; i < count; i++) {
        int block = maps[i]->effect_list.block;

        if (block >= 0) {
            tex_manager->ReloadTexture(block, (sceVif1Packet *) NULL);
            maps[i]->DrawEffect();
        }
    }

    tex_manager->ReloadTexture(tex_block, (sceVif1Packet *) NULL);

    for (j = 0; j < count; j++) {
        if (maps[j] != NULL) {
            maps[j]->fire_raster = &fire_raster;
            maps[j]->DrawFireEffect(tex_block);
            maps[j]->fire_raster = NULL;
        }
    }

    fire_texture =
        tex_manager->GetTexture("fire_work", tex_block);
    fire_raster.SetTexture(fire_texture);
    mgCTexture  frame;
    mgRect<int> rect;
    mgGetFrameBuffer(&frame);
    rect.Set(0, 0, (mgScreenWidth - 1) << 4, (mgScreenHeight - 1) << 4);
    mgSetPkMoveImage(&frame, rect, fire_texture, 0, 0, 0);

    for (k = 0; k < count; k++) {
        if (maps[k] != NULL) {
            maps[k]->fire_raster = &fire_raster;
            maps[k]->DrawFireRaster();
            maps[k]->fire_raster = NULL;
        }
    }
}
