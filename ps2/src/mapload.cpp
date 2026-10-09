#include "common.h"
#include "mw_runtime.h"

#include <libvu0.h>

#include <cmath>
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
#include "mglib.hpp"
#include "object.hpp"
#include "scriptinterpreter.hpp"
#include "water.hpp"

int        mapDummy(SPI_STACK *stack, int argument_count);
static int IsAddMode();
int        mapPARTS(SPI_STACK *stack, int argument_count);
int        mapFAR_CLIP(SPI_STACK *stack, int argument_count);
int        mapLIGHT_FLAG(SPI_STACK *stack, int argument_count);
int        mapMOVE_FLAG(SPI_STACK *stack, int argument_count);
int        mapLOD_START(SPI_STACK *stack, int argument_count);
int        mapLOD_BLEND(SPI_STACK *stack, int argument_count);
int        mapLOD_PIECE(SPI_STACK *stack, int argument_count);
int        mapLOD_END(SPI_STACK *stack, int argument_count);
int        mapPIECE(SPI_STACK *stack, int argument_count);
int        mapPIECE_NAME(SPI_STACK *stack, int argument_count);
int        mapPIECE_POS(SPI_STACK *stack, int argument_count);
int        mapPIECE_ROT(SPI_STACK *stack, int argument_count);
int        mapPIECE_SCALE(SPI_STACK *stack, int argument_count);
int        mapPIECE_MATERIAL_START(SPI_STACK *stack, int argument_count);
int        mapPIECE_MATERIAL(SPI_STACK *stack, int argc);
s32        mapPIECE_MATERIAL_END(SPI_STACK *stack, int argc);
int        mapPIECE_COL_TYPE(SPI_STACK *stack, int argc);
int        mapPIECE_TIME(SPI_STACK *stack, int argc);
int        mapPIECE_END(SPI_STACK *stack, int argc);
int        mapPARTS_END(SPI_STACK *stack, int argc);
int        mapMAP_PARTS(SPI_STACK *stack, int argc);
int        mapMAP_FAR_CLIP(SPI_STACK *stack, int argc);
int        mapPARTS_NAME(SPI_STACK *stack, int argc);
int        mapPARTS_GROUP(SPI_STACK *stack, int argc);
int        mapPARTS_POS(SPI_STACK *stack, int argc);
int        mapPARTS_ROT(SPI_STACK *stack, int argc);
int        mapPARTS_SCALE(SPI_STACK *stack, int argc);
int        mapMAP_PARTS_END(SPI_STACK *stack, int argc);
s32        map_MAP_INFO_TOP(SPI_STACK *stack, int argc);
int        mapCAMERA_INFO(SPI_STACK *stack, int argc);
int        mapFIX_CAMERA(SPI_STACK *stack, int argc);
int        mapFIX_CAMERA_POS(SPI_STACK *stack, int argc);
int        mapFIX_CAMERA_POS2(SPI_STACK *stack, int argc);
int        mapFIX_CAMERA_RECT(SPI_STACK *stack, int argc);
int        mapFIX_CAMERA_END(SPI_STACK *stack, int argc);
s32        mapCAMERA_INFO_END(SPI_STACK *stack, s32 argument_count);
int        mapFUNC_POINT(SPI_STACK *stack, int argc);
int        mapFUNC_DATA(SPI_STACK *stack, int argc);
int        mapFUNC_NAME(SPI_STACK *stack, int argc);
int        mapFUNC_FLAG(SPI_STACK *stack, int argc);
int        mapFUNC_FIRE_DATA(SPI_STACK *stack, int argc);
int        mapFUNC_PLIGHT_DATA(SPI_STACK *stack, int argc);
int        mapFUNC_ANIME_DATA(SPI_STACK *stack, int argc);
int        mapFUNC_INVENT_DATA(SPI_STACK *stack, int argc);
int        mapFUNC_EVENT_DATA(SPI_STACK *stack, int argc);
int        mapFUNC_SOUND_DATA(SPI_STACK *stack, int argc);
int        mapFUNC_EFFECT_NAME(SPI_STACK *stack, int argc);
int        mapFUNC_POS(SPI_STACK *stack, int argc);
int        mapFUNC_DATA_END(SPI_STACK *stack, int argc);
int        mapFUNC_POINT_END(SPI_STACK *stack, int argc);
int        cfgDRAW_OFF_RECT(SPI_STACK *stack, int argc);
int        cfgOCCLUSION_PLANE(SPI_STACK *stack, int argc);
int        cfgFUNC_DATA(SPI_STACK *stack, int argc);
int        cfgFUNC_EVENT_DATA(SPI_STACK *stack, int argc);
int        cfgFUNC_DATA_END(SPI_STACK *stack, int argc);
int        cfgWATER_SURFACE_NUM(SPI_STACK *stack, int argc);
s32        cfgWATER_SURFACE_START(SPI_STACK *stack, int argc);
int        cfgWATER_VERTEX(SPI_STACK *stack, int argc);
int        cfgWATER_POS(SPI_STACK *stack, int argc);
int        cfgWATER_PARAM(SPI_STACK *stack, int argc);
s32        cfgWATER_SHAKE(SPI_STACK *stack, int argc);
int        cfgWATER_SURFACE_END(SPI_STACK *stack, int argc);
int        cfgWATER_DRAW(SPI_STACK *stack, int argc);

/**
 * Map the map script is loading into.
 */
static CMap *mapMap;

/**
 * Node of the map part the map script is building, or null outside a part.
 */
static CList<CMapParts> *mapNowMapParts;

/**
 * Node of the map piece the map script is building, or null outside a piece.
 */
static CList<CMapPiece> *mapNowMapPiece;

/**
 * Memory that everything the map script builds is taken from.
 */
static mgCMemory *mapStack;

/**
 * Far clipping distance of the placed map part, or negative for no clipping.
 */
static float mapFarDist;

/**
 * Far-distance fade mode of the placed map part.
 */
static int mapFarAlpha;

/**
 * Visibility setting of the placed map part.
 */
static int mapShow;

/**
 * Level of detail that the map script is giving pieces to.
 */
static int mapLOD_ID;

/**
 * Current fixed-camera information entry.
 */
static int mapCameraInfoIdx;

/**
 * Next rectangle of the current fixed-camera information entry.
 */
static int mapCameraRectIdx;

/**
 * Index of the function point being filled by script handlers.
 */
static int mapFuncPointIdx;

/**
 * Function point being filled by script handlers.
 */
static CFuncPoint *mapNowFuncPoint;

/**
 * Next entry of the current piece materials that the map script fills in.
 */
static int mapMatIdx;

/**
 * Non-zero while map-script function points belong to the current map part.
 */
static int mapPtsFunc;

/**
 * Non-zero when loading an additional map into the current map.
 */
static int mapAddMode;

/**
 * Non-zero when configuration function-point storage is reserved.
 */
static int ReserveFuncFlag;

/**
 * Next water-surface entry being filled by configuration handlers.
 */
static int WaterIndex;

/**
 * Water frame being filled by configuration handlers.
 */
static CWaterFrame *cfgWater;

/**
 * Instance name of the placed map part.
 */
static char mapPlacePartsName[0x100];

/**
 * Definition name of the map part to place.
 */
static char mapMapPartsName[0x100];

/**
 * Group name of the placed map part.
 */
char mapMapPartsGroupName[0x100];

/**
 * Position of the placed map part.
 */
sceVu0FVECTOR mapPos;

/**
 * Rotation of the placed map part.
 */
sceVu0FVECTOR mapRot;

/**
 * Scale of the placed map part.
 */
sceVu0FVECTOR mapScale;

// Code (.text)
MAP_TIME_BAND GetTimeBand(float time) {
    MAP_TIME_BAND band = MAP_TIME_BAND_NIGHT;

    if (time >= 6.0f && time < 9.0f) {
        band = MAP_TIME_BAND_MORNING;
    }

    if (time >= 9.0f && time < 17.0f) {
        band = MAP_TIME_BAND_DAY;
    }

    if (time >= 17.0f && time < 21.0f) {
        band = MAP_TIME_BAND_EVENING;
    }

    return band;
}

float CMap::GetNowTime() {
    if (map_info.time_enable) {
        return now_time;
    }

    if (map_info.fixed_time_enable) {
        return map_info.fixed_time;
    }

    return 12.0f;
}

int CMap::GetNowTimeBand() {
    return GetTimeBand(GetNowTime());
}

int CMap::GetNowTimeLightBand() {
    int band_count = map_info.time_light_num;

    if (band_count < 2) {
        return 0;
    }

    if (band_count == 4) {
        return GetNowTimeBand();
    }

    float hour = GetNowTime();
    hour -= 9.0f;

    if (hour < 0.0f) {
        hour += 24.0f;
    }

    return fptosi(hour / (24.0f / (float) band_count)) % band_count;
}

void CMap::GetLightingRatio(float *ratio) {
    float time = GetNowTime();
    float blend;
    int   band;
    int   next;

    ratio[0] = 0.0f;
    ratio[1] = 0.0f;
    ratio[2] = 0.0f;
    blend = 0.0f;
    ratio[3] = 0.0f;
    band = GetNowTimeBand();
    next = (band + 1) % 4;

    switch (band) {
        case 3:
            if (time > 8.0f) {
                blend = time - 8.0f;
            }

            break;
        case 0:
            if (time > 16.0f) {
                blend = time - 16.0f;
            }

            break;
        case 1:
            if (time > 20.0f) {
                blend = time - 20.0f;
            }

            break;
        case 2:
            if (time < 6.0f) {
                if (time > 5.0f) {
                    blend = time - 5.0f;
                }
            }

            break;
    }

    ratio[band] = 1.0f - blend;
    ratio[next] = blend;
}

void CMap::GetLightingFlareRatio(float *out_ratio) {
    GetLightingRatio(out_ratio);
    out_ratio[MAP_TIME_BAND_NIGHT] = 0.0f;
}

void CMap::GetLightingSunRatio(float *out_ratio) {
    float time = GetNowTime();
    GetLightingRatio(out_ratio);

    if (time < 6.0f) {
        if (time > 4.0f) {
            out_ratio[MAP_TIME_BAND_NIGHT] = 0.0f;
            out_ratio[MAP_TIME_BAND_MORNING] = 0.0f;
        } else if (time > 3.0f) {
            out_ratio[MAP_TIME_BAND_NIGHT] = 1.0f - (time - 3.0f);
        }
    }

    if (out_ratio[MAP_TIME_BAND_NIGHT] > 0.0f) {
        out_ratio[MAP_TIME_BAND_MORNING] = 0.0f;
        out_ratio[MAP_TIME_BAND_EVENING] = 0.0f;
    }
}

int CMap::GetTimeLightingRatio(float *ratio) {
    int   band_count = map_info.time_light_num;
    int   i;
    float hour;
    float blend;
    float band_length;
    float band_start;
    int   band;
    int   next_band;

    if (band_count == 4) {
        GetLightingRatio(ratio);
        return band_count;
    }

    hour = GetNowTime();

    for (i = 0; i < band_count; i++) {
        ratio[i] = 0.0f;
    }

    if (band_count < 2) {
        ratio[0] = 1.0f;
        return band_count;
    }

    blend = 1.0f;
    band = GetNowTimeLightBand();
    next_band = (band + 1) % band_count;
    band_length = 24.0f / (float) band_count;
    band_start = 9.0f + (float) band * band_length;

    if (!(band_start < 24.0f)) {
        band_start -= 24.0f;
    }

    band_start = band_start + band_length - hour;

    if (band_start < 1.0f) {
        blend = band_start;
    }

    ratio[band] = blend;
    ratio[next_band] = 1.0f - blend;
    return band_count;
}

void CMap::GetSunPoint(float *out_pos) {
    sceVu0FVECTOR sun = {0.0f, -1900.0f, 700.0f, 1.0f};
    sceVu0FMATRIX matrix;

    mgUnitMatrix(matrix);
    sceVu0RotMatrixZ(matrix, matrix, mgAngleLimit((GetNowTime() * 6.2831855f) / 24.0f));
    sceVu0RotMatrixY(matrix, matrix, map_info.sun_angle);
    sceVu0ApplyMatrix(out_pos, matrix, sun);
}

float CMap::GetLightNoTime(int index) {
    int   band_count = map_info.time_light_num;
    float hour;

    if (index >= band_count || GetTimeEnable() == 0) {
        return -1.0f;
    }

    if (band_count == 4) {
        switch (index) {
            case 3:
                return 6.5f;
            case 0:
                return 9.5f;
            case 1:
                return 17.5f;
            case 2:
                return 21.5f;
        }

        return -1.0f;
    }

    hour = 24.0f * index / band_count;
    hour += 9.5f;

    if (hour < 0.0f) {
        hour += 24.0f;
    }

    return hour;
}

int CMap::GetTimeEnable() {
    return map_info.time_enable;
}

#pragma inline_depth(0)

void CMap::GetLightInfo(CMapLightingInfo *out_info) {
    if (out_info == NULL) {
        return;
    }

    int num = map_info.time_light_num;

    if (GetActiveLightNo() >= num || (!GetTimeEnable() && !map_info.fixed_time_enable)) {
        CMapLightingInfo *info = GetLightingInfo(GetActiveLightNo());

        if (info != NULL) {
            *out_info = *info;
            return;
        }
    }

    CMapLightingInfo *list[8];
    float             ratio[8];
    sceVu0FVECTOR     sun;

    int band = GetNowTimeLightBand();

    for (int i = 0; i < num; i++) {
        list[i] = map_info.GetLightingInfo(i);

        if (list[i] == NULL) {
            return;
        }
    }

    *out_info = *list[band];

    if (map_info.time_light_blend) {
        GetLightInfo(out_info, ratio, GetTimeLightingRatio(ratio));

        // The first directional light follows the sun, never lower than a fixed height.
        GetSunPoint(sun);
        sceVu0Normalize(sun, sun);

        if (sun[1] < 0.2f) {
            sun[1] = 0.2f;
            sceVu0Normalize(sun, sun);
        }

        out_info->light_dir[0][0] = sun[0];
        out_info->light_dir[1][0] = sun[1];
        out_info->light_dir[2][0] = sun[2];
    }
}

#pragma inline_depth reset

mgMaterial *mgCFrame::GetMaterial(int index) {
    if (visual != NULL) {
        return visual->GetMaterial(index);
    }

    return NULL;
}

CMapLightingInfo *CMap::GetLightingInfo(int no) {
    return map_info.GetLightingInfo(no);
}

#pragma inline_depth(0)

int CMap::GetActiveLightNo() {
    return map_info.GetActiveLightNo();
}

#pragma inline_depth reset

// Defined in mapinfo.hpp.
#pragma inline_depth(0)

void CMap::GetLightInfo(CMapLightingInfo *out_info, float *ratio, int num) {
    sceVu0FMATRIX     light_dir;
    sceVu0FMATRIX     light_color;
    sceVu0FVECTOR     ambient;
    sceVu0FVECTOR     bg_color;
    sceVu0FVECTOR     bg_color2;
    sceVu0FVECTOR     fog;
    sceVu0FVECTOR     fog_color;
    CMapLightingInfo *list[8];
    sceVu0FVECTOR     work;
    int               fog_num = 0;
    int               i;
    int               j;
    int               lighting_num = map_info.time_light_num;

    for (i = 0; i < lighting_num; i++) {
        list[i] = map_info.GetLightingInfo(i);

        if (list[i] == NULL) {
            return;
        }
    }

    mgZeroVector(ambient);
    mgZeroVector(fog);
    mgZeroVector(fog_color);
    mgZeroVector(bg_color);
    mgZeroVector(bg_color2);
    mgZeroMatrix(light_dir);
    mgZeroMatrix(light_color);

    for (i = 0; i < num; i++) {
        if (!(ratio[i] <= 0.0f)) {

            sceVu0ScaleVector(work, list[i]->ambient, ratio[i]);
            mgAddVector(ambient, work);
            sceVu0ScaleVector(work, list[i]->bg_color, ratio[i]);
            mgAddVector(bg_color, work);
            sceVu0ScaleVector(work, list[i]->bg_color2, ratio[i]);
            mgAddVector(bg_color2, work);

            // Only the sets that draw fog weigh in its colour and distances.
            if (list[i]->fog_enable) {
                work[0] = list[i]->fog.r;
                work[1] = list[i]->fog.g;
                work[2] = list[i]->fog.b;
                work[3] = list[i]->fog.a;
                sceVu0ScaleVector(work, work, ratio[i]);
                mgAddVector(fog_color, work);
                work[0] = list[i]->fog.near_dist;
                work[1] = list[i]->fog.far_dist;
                work[2] = list[i]->fog.far_value;
                work[3] = list[i]->fog.near_value;
                sceVu0ScaleVector(work, work, ratio[i]);
                mgAddVector(fog, work);
                fog_num++;
            }

            for (j = 0; j < 4; j++) {
                sceVu0ScaleVector(work, list[i]->light_dir[j], ratio[i]);
                mgAddVector(light_dir[j], work);
                sceVu0ScaleVector(work, list[i]->light_color[j], ratio[i]);
                mgAddVector(light_color[j], work);
            }
        }
    }

    // Each row now holds one light's direction, normalised unless the blend cancelled it out.
    sceVu0TransposeMatrix(light_dir, light_dir);

    for (i = 0; i < 4; i++) {
        if (!(mgDistVector(light_dir[i]) <= 0.0f)) {
            sceVu0Normalize(light_dir[i], light_dir[i]);
        }
    }

    if (mgAbs(ambient[3] - 128.0f) < 0.01f) {
        ambient[3] = 128.0f;
    }

    *(u_long128 *) out_info->ambient = *(u_long128 *) ambient;
    *(u_long128 *) out_info->bg_color = *(u_long128 *) bg_color;
    *(u_long128 *) out_info->bg_color2 = *(u_long128 *) bg_color2;
    *(u_long128 *) out_info->light_color[0] = *(u_long128 *) light_color[0];

    for (i = 0; i < 4; i++) {
        for (j = 0; j < 3; j++) {
            out_info->light_dir[j][i] = light_dir[i][j];
        }

        *(u_long128 *) out_info->light_color[i] = *(u_long128 *) light_color[i];
    }

    out_info->fog.r = fog_color[0];
    out_info->fog.g = fog_color[1];
    out_info->fog.b = fog_color[2];
    out_info->fog.a = fog_color[3];
    out_info->fog.near_dist = fog[0];
    out_info->fog.far_dist = fog[1];
    out_info->fog.far_value = fog[2];
    out_info->fog.near_value = fog[3];
    out_info->fog_enable = fog_num > 0;
}

#pragma inline_depth reset

/**
 *
 * Handles a map script tag that does nothing.
 *
 */
int mapDummy(SPI_STACK *stack, int argument_count) {
    return 1;
}

/**
 *
 * Tells whether the map script being loaded adds to a map already loaded.
 *
 */
static int IsAddMode() {
    return mapAddMode;
}

// Defined in mapload.hpp.
/**
 *
 * Starts a map part of the name of the first argument, which the tags up to PARTS_END build.
 *
 */
#pragma inline_depth(0)

int mapPARTS(SPI_STACK *stack, int argument_count) {
    mapNowMapParts = new (mapStack->Alloc(algn16_size(sizeof(CList<CMapParts>)) + 2)) CList<CMapParts>;
    CMapParts *parts = mapNowMapParts->pGetData();
    char      *name = spiGetStackString(stack);
    parts->SetName(name);
    parts->SetPartsName(name);
    mapLOD_ID = 0;
    mapPtsFunc = 1;
    return 1;
}

#pragma inline_depth reset

// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.

// Defined in mg_frame.hpp.
// Defined in mapload.hpp.
unsigned int algn16_size(unsigned int size) {
    if ((size & 0xF) != 0) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

/**
 *
 * Gives the current map part its far clip distance and whether it fades out there.
 *
 */
#pragma inline_depth(0)

int mapFAR_CLIP(SPI_STACK *stack, int argc) {
    SPI_STACK *alpha_arg = stack + 1;

    if (mapNowMapParts == NULL) {
        return 0;
    }

    (mapNowMapParts->pGetData())->far_dist = spiGetStackFloat(stack);
    (mapNowMapParts->pGetData())->fade = spiGetStackInt(alpha_arg);
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Sets whether the current map part is drawn without the scene's lights and without point lights.
 *
 */
#pragma inline_depth(0)

int mapLIGHT_FLAG(SPI_STACK *stack, int argc) {
    SPI_STACK *second_arg = stack + 1;

    if (mapNowMapParts == NULL) {
        return 0;
    }

    (mapNowMapParts->pGetData())->no_light = spiGetStackInt(stack);
    (mapNowMapParts->pGetData())->no_plight = spiGetStackInt(second_arg);
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Sets the four move flags of the current map part, one per argument.
 *
 */
#pragma inline_depth(0)

int mapMOVE_FLAG(SPI_STACK *stack, int argc) {
    if (mapNowMapParts == NULL) {
        return 0;
    }

    CMapParts *parts = mapNowMapParts->pGetData();
    parts->move_flag = 0;

    if (spiGetStackInt(stack++)) {
        parts->move_flag |= 1;
    }

    if (spiGetStackInt(stack++)) {
        parts->move_flag |= 2;
    }

    if (spiGetStackInt(stack++)) {
        parts->move_flag |= 4;
    }

    if (spiGetStackInt(stack)) {
        parts->move_flag |= 8;
    }

    return 1;
}

#pragma inline_depth reset

/**
 *
 * Gives the current map part four levels of detail at the standard distances.
 *
 */
#pragma inline_depth(0)

int mapLOD_START(SPI_STACK *stack, int argc) {
    CMapParts *parts;
    float     *dist;

    if (mapNowMapParts == NULL) {
        return 0;
    }

    dist = (float *) mapStack->Alloc(1);
    parts = mapNowMapParts->pGetData();
    dist[0] = 600.0f;
    dist[1] = 1000.0f;
    dist[2] = 1400.0f;
    dist[3] = 1800.0f;
    parts->SetLODDist(dist, 4);
    return 1;
}

#pragma inline_depth reset

// Defined in mapparts.hpp.
/**
 *
 * Sets whether the current map part blends between its levels of detail.
 *
 */
#pragma inline_depth(0)

int mapLOD_BLEND(SPI_STACK *stack, int argc) {
    if (mapNowMapParts == NULL) {
        return 0;
    }

    CMapParts *parts = mapNowMapParts->pGetData();
    parts->SetLODBlend(spiGetStackInt(stack));
    return 1;
}

#pragma inline_depth reset

// Defined in mapparts.hpp.
/**
 *
 * Puts a piece of the current map part into a level of detail, hiding it until that level is reached.
 *
 */
#pragma inline_depth(0)

int mapLOD_PIECE(SPI_STACK *stack, int argc) {
    if (mapNowMapParts == NULL) {
        return 0;
    }

    CMapParts *parts = mapNowMapParts->pGetData();
    int        reset_flag = spiGetStackInt(stack++);
    CMapPiece *piece = parts->SearchPiece(spiGetStackString(stack));

    if (piece != NULL) {
        if (reset_flag > 0) {
            piece->show = 0;
            piece->fade_alpha = 0.0f;
        }

        if (parts->GetLODBlend() != 0) {
            piece->fade = 1;
        }
    }

    return 1;
}

#pragma inline_depth reset

// Defined in mapparts.hpp.
/**
 *
 * Ends a level of detail, so that the next pieces go to the following level.
 *
 */
int mapLOD_END(SPI_STACK *stack, int argument_count) {
    mapLOD_ID++;
    return 1;
}

/**
 *
 * Starts a piece of the current map part that uses the model data of the first argument, shown unless the second argument is zero.
 *
 */
#pragma inline_depth(0)

int mapPIECE(SPI_STACK *stack, int argument_count) {
    char      *name;
    int        show;
    SPI_STACK *show_arg;
    CMapPiece *piece;
    int        size;
    char      *copy;
    CMdsInfo  *mds;

    if (mapNowMapParts == NULL) {
        return 0;
    }

    show_arg = stack + 1;
    name = spiGetStackString(stack);

    if (name == NULL) {
        return 0;
    }

    show = 1;

    if (!(argument_count < 2)) {
        show = spiGetStackInt(show_arg);
    }

    if (mapMap->piece_load_skip & 1) {
        return 1;
    }

    mapNowMapPiece = new (mapStack->Alloc(algn16_size(sizeof(CList<CMapPiece>)) + 2)) CList<CMapPiece>;
    piece = mapNowMapPiece->pGetData();
    size = strlen(name) + 1;

    if (size % 16 != 0) {
        size = size / 16 + 1;
    } else {
        size = size / 16;
    }

    copy = (char *) mapStack->Alloc(size);
    strcpy(copy, name);
    piece->SetName(copy);
    piece->show = show;
    mds = mapMap->SearchMDS(copy);

    if (mds != NULL) {
        piece->AssignMds(mds);
    }

    return 1;
}

#pragma inline_depth reset

// Defined in mdslist.hpp.
// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.
// Defined in mdslist.hpp.
// Defined in object.hpp.

/**
 *
 * Renames the model data that the current piece uses.
 *
 */
#pragma inline_depth(0)

int mapPIECE_NAME(SPI_STACK *stack, int argc) {
    CMapPiece *piece;
    char      *name;
    char      *copy;

    if (mapNowMapPiece == NULL) {
        return 0;
    }

    piece = mapNowMapPiece->pGetData();
    name = spiGetStackString(stack);

    if (name != NULL) {
        copy = (char *) mapStack->Alloc(algn16_size(strlen(name) + 1));
        strcpy(copy, name);
        piece->SetName(copy);
    }

    return 1;
}

#pragma inline_depth reset

/**
 *
 * Moves the current piece to the position of the three arguments.
 *
 */
#pragma inline_depth(0)

int mapPIECE_POS(SPI_STACK *stack, int argument_count) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }

    CMapPiece *piece = mapNowMapPiece->pGetData();

    if (piece == NULL) {
        return 0;
    }

    sceVu0FVECTOR position;
    spiGetStackVector(position, stack);
    piece->SetPosition(position);
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Turns the current piece to the angles of the three arguments.
 *
 */
#pragma inline_depth(0)

int mapPIECE_ROT(SPI_STACK *stack, int argument_count) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }

    CMapPiece *piece = mapNowMapPiece->pGetData();

    if (piece == NULL) {
        return 0;
    }

    sceVu0FVECTOR rotation;
    spiGetStackVector(rotation, stack);
    piece->SetRotation(rotation);
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Scales the current piece by the three arguments.
 *
 */
#pragma inline_depth(0)

int mapPIECE_SCALE(SPI_STACK *stack, int argument_count) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }

    CMapPiece *piece = mapNowMapPiece->pGetData();

    if (piece == NULL) {
        return 0;
    }

    sceVu0FVECTOR scale;
    spiGetStackVector(scale, stack);
    piece->SetScale(scale);
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Gives the current piece as many material colour entries as the first argument, filled in by the PIECE_MATERIAL tags that follow.
 *
 */
#pragma inline_depth(0)

int mapPIECE_MATERIAL_START(SPI_STACK *stack, int argument_count) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }

    mapMatIdx = 0;
    int num = spiGetStackInt(stack);

    if (num <= 0) {
        return 1;
    }

    PieceMaterial *material = new (mapStack->Alloc(algn16_size(num * sizeof(PieceMaterial)) + 2)) PieceMaterial[num];

    if (material != NULL) {
        mapNowMapPiece->pGetData()->SetMaterial(material, num);
    }

    return 1;
}

#pragma inline_depth reset

// Defined in mdslist.hpp.
PieceMaterial::PieceMaterial() { Initialize(); }

void PieceMaterial::Initialize() { memset(this, 0, sizeof(PieceMaterial)); }

#pragma inline_depth(0)

/**
 *
 * Assigns a named frame material and color to the current map piece.
 *
 */
int mapPIECE_MATERIAL(SPI_STACK *stack, int argc) {
    CMapPiece     *piece;
    PieceMaterial *slot;
    mgCFrame      *frame;
    char          *name;

    if (mapNowMapPiece == NULL) {
        return 0;
    }

    piece = mapNowMapPiece->pGetData();

    if (piece == NULL) {
        return 0;
    }

    slot = piece->GetMaterial(mapMatIdx++);

    if (slot == NULL) {
        return 0;
    }

    frame = piece->GetFrame();
    name = spiGetStackString(stack++);

    if (name == NULL || frame == NULL) {
        return 0;
    }

    slot->frame = frame->SearchFrame(name);

    if (slot->frame == NULL) {
        return 0;
    }

    slot->material_no = spiGetStackInt(stack++);
    slot->material = slot->frame->GetMaterial(slot->material_no);
    slot->color[0] = spiGetStackFloat(stack++);
    slot->color[1] = spiGetStackFloat(stack++);
    slot->color[2] = spiGetStackFloat(stack++);
    slot->color[3] = spiGetStackFloat(stack++);
    slot->unk_c = spiGetStackInt(stack);
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Accepts the end marker of a map piece material list.
 *
 */
s32 mapPIECE_MATERIAL_END(SPI_STACK *stack, int argc) {
    return 1;
}

#pragma inline_depth(0)

/**
 *
 * Sets the collision type and optional collision parameter of a map piece.
 *
 */
int mapPIECE_COL_TYPE(SPI_STACK *stack, int argc) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }

    CMapPiece *piece = mapNowMapPiece->pGetData();
    piece->col_type = spiGetStackInt(stack++);

    if (argc >= 2) {
        piece->col_param = spiGetStackInt(stack);
    }

    return 1;
}

#pragma inline_depth reset
#pragma inline_depth(0)

/**
 *
 * Sets the time interval in which the current map piece is active.
 *
 */
int mapPIECE_TIME(SPI_STACK *stack, int argc) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }

    CMapPiece *piece = mapNowMapPiece->pGetData();
    float      start = spiGetStackFloat(stack++);
    piece->SetTimeBand(start, spiGetStackFloat(stack));
    return 1;
}

#pragma inline_depth reset
#pragma inline_depth(0)

/**
 *
 * Adds the completed piece to the current map part definition.
 *
 */
int mapPIECE_END(SPI_STACK *stack, int argc) {
    if (mapNowMapParts == NULL || mapNowMapPiece == NULL) {
        return 0;
    }

    CMapParts *parts = mapNowMapParts->pGetData();

    if (parts == NULL) {
        return 0;
    }

    parts->AddPiece(mapNowMapPiece);
    return 1;
}

#pragma inline_depth reset
#pragma inline_depth(0)

/**
 *
 * Adds the completed map part definition and builds its bounding box.
 *
 */
int mapPARTS_END(SPI_STACK *stack, int argc) {
    if (mapNowMapParts == NULL) {
        return 0;
    }

    mapMap->AddParts(mapNowMapParts);
    mapPtsFunc = 0;
    mapNowMapParts->pGetData()->CreateBoundBox();
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Starts a placed map part with default transform and drawing settings.
 *
 */
int mapMAP_PARTS(SPI_STACK *stack, int argc) {
    char *name;

    name = spiGetStackString(stack++);
    mapNowMapParts = NULL;

    if (name == NULL) {
        return 0;
    }

    strcpy(mapPlacePartsName, name);
    mgZeroVector(mapPos);
    mgZeroVector(mapRot);
    mapScale[3] = 0.0f;
    mapFarDist = -1.0f;
    mapScale[2] = 1.0f;
    mapShow = 1;
    mapScale[1] = 1.0f;
    mapScale[0] = 1.0f;
    mapFarAlpha = 0;

    if (argc > 1) {
        mapShow = spiGetStackInt(stack);
    }

    mapMapPartsName[0] = 0;
    mapMapPartsGroupName[0] = 0;
    return 1;
}

/**
 *
 * Sets the far clipping distance and fade mode for a placed map part.
 *
 */
int mapMAP_FAR_CLIP(SPI_STACK *stack, int argc) {
    mapFarDist = spiGetStackFloat(stack++);
    mapFarAlpha = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the definition name of the placed map part being parsed.
 *
 */
int mapPARTS_NAME(SPI_STACK *stack, int argc) {
    char *text = spiGetStackString(stack);

    if (text == NULL) {
        return 0;
    }

    strcpy(mapMapPartsName, text);
    return 1;
}

/**
 *
 * Sets the group name for the placed map part being parsed.
 *
 */
int mapPARTS_GROUP(SPI_STACK *stack, int argc) {
    char *text = spiGetStackString(stack);

    if (text == NULL) {
        return 0;
    }

    strcpy(mapMapPartsGroupName, text);
    return 1;
}

/**
 *
 * Sets the position of the placed map part being parsed.
 *
 */
int mapPARTS_POS(SPI_STACK *stack, int argc) {
    spiGetStackVector(mapPos, stack);
    return 1;
}

/**
 *
 * Sets the rotation of the placed map part being parsed.
 *
 */
int mapPARTS_ROT(SPI_STACK *stack, int argc) {
    spiGetStackVector(mapRot, stack);
    return 1;
}

/**
 *
 * Sets the scale of the placed map part being parsed.
 *
 */
int mapPARTS_SCALE(SPI_STACK *stack, int argc) {
    spiGetStackVector(mapScale, stack);
    return 1;
}

/**
 *
 * Places the configured map part and applies its visibility, clipping, and group settings.
 *
 */
int mapMAP_PARTS_END(SPI_STACK *stack, int argc) {
    CMapParts *parts = mapMap->PlaceParts(mapMapPartsName, mapPos, mapRot, mapScale, mapStack);

    if (parts == NULL) {
        return 0;
    }

    parts->SetName(mapPlacePartsName);

    if (mapFarDist > 0.0f) {
        parts->far_dist = mapFarDist;
        parts->fade = mapFarAlpha;
    }

    parts->show = mapShow;

    if ((s8) mapMapPartsGroupName[0] != 0) {
        parts->group_no = mapMap->AddPartsGroup(mapMapPartsGroupName, parts, mapStack);
    }

    return 1;
}

/**
 *
 * Accepts the top-level map information section marker.
 *
 */
s32 map_MAP_INFO_TOP(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Allocates the fixed camera information table for a map.
 *
 */
int mapCAMERA_INFO(SPI_STACK *stack, int argc) {
    if (IsAddMode()) {
        return 1;
    }

    int num = spiGetStackInt(stack);

    if (num < 0) {
        return 0;
    }

    mapMap->SetCameraInfoTable(new (mapStack->Alloc(algn16_size(num * sizeof(CCameraInfo)) + 2)) CCameraInfo[num], num);
    mapCameraInfoIdx = 0;
    return 1;
}

CCameraInfo::CCameraInfo() {
    Initialize();
}

CCameraDrawInfo::CCameraDrawInfo() {
    Initialize();
}

void CCameraDrawInfo::Initialize() {
    unk_4 = 0;
    group_no = -1;
}

/**
 *
 * Starts a fixed camera record and resets its rectangle index.
 *
 */
int mapFIX_CAMERA(SPI_STACK *stack, int argc) {
    if (IsAddMode() != 0) {
        return 1;
    }

    mapCameraRectIdx = 0;
    return 1;
}

/**
 *
 * Sets the first position of the current fixed camera.
 *
 */
int mapFIX_CAMERA_POS(SPI_STACK *stack, int argc) {
    CCameraInfo *info;

    if (IsAddMode() != 0) {
        return 1;
    }

    info = mapMap->GetCameraInfo(mapCameraInfoIdx);

    if (info == NULL) {
        return 0;
    }

    spiGetStackVector(info->pos[0], stack);
    return 1;
}

/**
 *
 * Sets an indexed position of the current fixed camera.
 *
 */
int mapFIX_CAMERA_POS2(SPI_STACK *stack, int argc) {
    CCameraInfo *info;
    int          index;

    if (IsAddMode()) {
        return 1;
    }

    info = mapMap->GetCameraInfo(mapCameraInfoIdx);

    if (info == NULL) {
        return 0;
    }

    index = spiGetStackInt(stack++);

    if (index < 0 || index >= 8) {
        return 0;
    }

    spiGetStackVector(info->pos[index], stack);
    info->pos_num = (index + 1 < info->pos_num) ? info->pos_num : index + 1;
    return 1;
}

/**
 *
 * Associates a fixed camera draw entry with a named map part group.
 *
 */
int mapFIX_CAMERA_OFF_GROUP(SPI_STACK *stack, int argument_count) {
    if (IsAddMode()) {
        return 1;
    }

    int          draw_index = spiGetStackInt(stack++);
    CCameraInfo *camera = mapMap->GetCameraInfo(mapCameraInfoIdx);

    if (camera == NULL) {
        return 0;
    }

    CCameraDrawInfo *draw_info = camera->GetDrawInfo(draw_index);

    if (draw_info == NULL) {
        return 0;
    }

    char *group_name = spiGetStackString(stack++);

    if (group_name == NULL) {
        return 0;
    }

    if (group_name[0] == 0) {
        return 1;
    }

    draw_info->unk_4 = spiGetStackInt(stack);
    draw_info->group_no = mapMap->SearchPartsGroupNo(group_name);
    return 1;
}

#pragma inline_depth(0)

/**
 *
 * Adds a collision rectangle and optional transform to a fixed camera.
 *
 */
int mapFIX_CAMERA_RECT(SPI_STACK *stack, int argc) {
    CCameraInfo *info;
    char        *name;
    CColFrame   *frame;
    CCollision  *collision;
    float        vec[4];

    if (IsAddMode() != 0) {
        return 1;
    }

    info = mapMap->GetCameraInfo(mapCameraInfoIdx);

    if (info == NULL) {
        return 0;
    }

    name = spiGetStackString(stack++);

    if (name == NULL) {
        return 0;
    }

    frame = new (mapStack->Alloc(algn16_size(sizeof(CColFrame)) + 2)) CColFrame;
    collision = NULL;

    if (strcmp(name, "box") == 0) {
        collision = new (mapStack->Alloc(algn16_size(sizeof(CCollision)) + 2)) CCollision;
        spiGetStackVector(collision->bbox.min, stack);
        collision->bbox.min[3] = 1.0f;
        spiGetStackVector(collision->bbox.max, stack + 3);
        collision->bbox.max[3] = 1.0f;
        stack += 6;

        if (frame != NULL) {
            if (argc >= 8) {
                spiGetStackVector(vec, stack);
                stack += 3;
                frame->SetPosition(vec);
            }

            if (argc >= 11) {
                spiGetStackVector(vec, stack);
                stack += 3;
                frame->SetRotation(vec);
            }

            if (argc >= 14) {
                spiGetStackVector(vec, stack);
                frame->SetScale(vec);
            }
        }
    }

    if (frame != NULL) {
        frame->SetCollision(collision);
    }

    if (mapCameraRectIdx < info->rect_num) {
        info->rect[mapCameraRectIdx] = frame;
        mapCameraRectIdx += 1;
    }

    return 1;
}

#pragma inline_depth reset

/**
 *
 * Finishes the current fixed camera record.
 *
 */
int mapFIX_CAMERA_END(SPI_STACK *stack, int argc) {
    if (IsAddMode() != 0) {
        return 1;
    }

    mapCameraInfoIdx += 1;
    return 1;
}

/**
 *
 * Accepts the end marker of the map camera information section.
 *
 */
s32 mapCAMERA_INFO_END(SPI_STACK *stack, s32 argument_count) {
    if (IsAddMode() != 0) {
        return 1;
    }

    return 1;
}

/**
 *
 * Starts a map function point section and resets its entry index.
 *
 */
int mapFUNC_POINT(SPI_STACK *stack, int argc) {
    spiGetStackInt(stack);
    mapFuncPointIdx = 0;
    return 1;
}

#pragma inline_depth(0)

/**
 *
 * Creates a map or part function point of the scripted kind.
 *
 */
int mapFUNC_DATA(SPI_STACK *stack, int argc) {
    char *name;
    int   kind;

    mapNowFuncPoint = NULL;
    name = spiGetStackString(stack++);

    if (name == NULL) {
        return 0;
    }

    if (strcmp(name, "effect") == 0) {
        kind = 1;
    } else if (strcmp(name, "fire") == 0) {
        kind = 2;
    } else if (strcmp(name, "flare") == 0) {
        kind = 3;
    } else if (strcmp(name, "plight") == 0) {
        kind = 4;
    } else if (strcmp(name, "anime") == 0) {
        kind = 5;
    } else if (strcmp(name, "invent") == 0) {
        kind = 7;
    } else if (strcmp(name, "event") == 0) {
        kind = 6;
        mapMap->parts_event = 1;
    } else if (strcmp(name, "sound") == 0) {
        kind = 8;
    } else if (strcmp(name, "pos") == 0) {
        kind = 9;
    } else {
        return 0;
    }

    if (mapPtsFunc != 0) {
        if (mapNowMapParts == NULL) {
            return 0;
        }

        mapNowFuncPoint = mapNowMapParts->pGetData()->func_point_mngr.Add(kind, mapStack);
    } else {
        mapNowFuncPoint = mapMap->func_point.Add(kind, mapStack);
    }

    if (mapNowFuncPoint == NULL) {
        return 0;
    }

    mapNowFuncPoint->type = kind;
    mapNowFuncPoint->enable = spiGetStackInt(stack);
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Stores a copy of the current function point's name.
 *
 */
int mapFUNC_NAME(SPI_STACK *stack, int argc) {
    if (mapNowFuncPoint == 0) {
        return 0;
    }

    char *name = spiGetStackString(stack);

    if (name == NULL) {
        return 0;
    }

    char *copy = (char *) mapStack->Alloc(algn16_size(strlen(name) + 1));

    if (copy != NULL) {
        strcpy(copy, name);
    }

    mapNowFuncPoint->name = copy;
    return 1;
}

/**
 *
 * Sets the current function point's flags and active time interval.
 *
 */
int mapFUNC_FLAG(SPI_STACK *stack, int argc) {
    if (mapNowFuncPoint == 0) {
        return 0;
    }

    mapNowFuncPoint->unk_c = spiGetStackInt(stack++);
    mapNowFuncPoint->unk_8 = spiGetStackInt(stack++);
    mapNowFuncPoint->start = spiGetStackFloat(stack++);
    mapNowFuncPoint->end = spiGetStackFloat(stack);
    return 1;
}

/**
 *
 * Sets the current fire function point's color and effect options.
 *
 */
int mapFUNC_FIRE_DATA(SPI_STACK *stack, int argc) {
    float color[4];

    if (mapNowFuncPoint == 0) {
        return 0;
    }

    spiGetStackVector(color, stack);
    stack += 3;

    if (0.0f == color[2] + (color[0] + color[1])) {
        color[0] = 128.0f;
        color[1] = 90.0f;
        color[2] = 38.0f;
    } else {
        sceVu0ScaleVector(color, color, 128.0f);
    }

    color[3] = 128.0f;
    *(u_long128 *) mapNowFuncPoint->fire.color = *(u_long128 *) color;
    mapNowFuncPoint->fire.effect_off = !(spiGetStackInt(stack++) != 0);

    if (argc >= 5) {
        mapNowFuncPoint->fire.heat_haze = spiGetStackInt(stack++);
    }

    if (argc >= 6) {
        mapNowFuncPoint->fire.cast_light = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Sets the current point light's power, color, range, and optional animation settings.
 *
 */
int mapFUNC_PLIGHT_DATA(SPI_STACK *stack, int argc) {
    float       color[4];
    float       largest;
    CFuncPoint *func_point;

    if (mapNowFuncPoint == 0) {
        return 0;
    }

    mapNowFuncPoint->plight.power = spiGetStackFloat(stack++);
    spiGetStackVector(color, stack);
    stack += 3;
    sceVu0ScaleVector(color, color, 0.5f);
    color[3] = 0.0f;

    if (color[0] > color[1]) {
        largest = (color[0] > color[2]) ? color[0] : color[2];
    } else {
        largest = (color[1] > color[2]) ? color[1] : color[2];
    }

    func_point = mapNowFuncPoint;
    func_point->plight.range =
        0.25 * ((double) func_point->plight.power * sqrt((double) largest));
    *(u_long128 *) mapNowFuncPoint->plight.color = *(u_long128 *) color;
    mapNowFuncPoint->plight.light_type = spiGetStackInt(stack++);

    if (argc >= 6) {
        mapNowFuncPoint->plight.light_chara = spiGetStackInt(stack++);
    }

    if (argc >= 7) {
        mapNowFuncPoint->plight.unk_40 = spiGetStackInt(stack++);
    }

    if (argc >= 8) {
        mapNowFuncPoint->plight.unk_44 = spiGetStackInt(stack++);
    }

    if (argc >= 9) {
        mapNowFuncPoint->plight.no_map_light = spiGetStackInt(stack++);
    }

    if (argc >= 10) {
        mapNowFuncPoint->plight.flicker_type = spiGetStackInt(stack++);
    }

    if (argc >= 11) {
        mapNowFuncPoint->plight.flicker_depth = spiGetStackFloat(stack++);
    }

    if (argc >= 12) {
        mapNowFuncPoint->plight.flicker_period = spiGetStackFloat(stack);
    }

    return 1;
}

/**
 *
 * Configures the current function point's target frame and animation parameters.
 *
 */
int mapFUNC_ANIME_DATA(SPI_STACK *stack, int argc) {
    CFuncPoint::AnimeData *anime;

    if (mapNowFuncPoint == 0) {
        return 0;
    }

    anime = &mapNowFuncPoint->anime;
    anime->parts_name = mgCopyString(spiGetStackString(stack++), mapStack);
    anime->piece_name = mgCopyString(spiGetStackString(stack++), mapStack);
    anime->frame_name = mgCopyString(spiGetStackString(stack++), mapStack);
    anime->kind = spiGetStackInt(stack++);
    anime->mode = spiGetStackInt(stack++);
    spiGetStackVector(anime->param, stack);
    spiGetStackVector(anime->speed, stack + 3);
    spiGetStackVector(anime->end, stack + 6);
    anime->uniform = 0;
    stack += 9;

    if (argc >= 15) {
        anime->uniform = spiGetStackInt(stack++);
    }

    if (argc >= 16) {
        anime->piece_space = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Configures an invention function point's idea number and trigger region.
 *
 */
int mapFUNC_INVENT_DATA(SPI_STACK *stack, int argc) {
    CFuncPoint::InventData *invent = &mapNowFuncPoint->invent;

    if (mapNowFuncPoint == 0) {
        return 0;
    }

    invent->neta_no = spiGetStackInt(stack++);
    spiGetStackVector(invent->box.min, stack);
    invent->box.min[3] = 1.0f;
    spiGetStackVector(invent->box.max, stack + 3);
    stack += 6;
    invent->box.max[3] = 1.0f;
    invent->unk_24 = spiGetStackInt(stack++);
    invent->range = spiGetStackFloat(stack++);
    invent->angle = 3.1415927f * spiGetStackFloat(stack) / 180.0f;
    return 1;
}

/**
 *
 * Configures the current event function point's event identifiers and flags.
 *
 */
int mapFUNC_EVENT_DATA(SPI_STACK *stack, int argc) {
    char                  *kind_name;
    int                    kind;
    char                  *target_name;
    CFuncPoint::EventData *event;

    if (mapNowFuncPoint == 0) {
        return 0;
    }

    kind_name = spiGetStackString(stack++);
    kind = 0;
    event = &mapNowFuncPoint->event;
    event->event_no = spiGetStackInt(stack++);
    event->point_no = spiGetStackInt(stack++);
    event->arg1 = spiGetStackInt(stack++);
    event->arg2 = spiGetStackInt(stack++);
    event->arg3 = spiGetStackInt(stack++);

    if (kind_name != NULL) {
        if (strcmp(kind_name, "door") == 0) {
            kind = 0x10A;
        } else if (strcmp(kind_name, "ed_door") == 0) {
            kind = 0x11A;
        } else if (strcmp(kind_name, "lddr_b") == 0) {
            kind = 0x20;
            event->event_no = 1;
        } else if (strcmp(kind_name, "lddr_t") == 0) {
            kind = 0x40;
            event->event_no = 1;
        } else if (strcmp(kind_name, "close_door") == 0) {
            kind = 0x8A;
        } else if (strcmp(kind_name, "t_box") == 0) {
            kind = 0x202;
            event->event_no = 1;
        } else if (strcmp(kind_name, "book") == 0) {
            kind = 0x402;
        }
    }

    event->flag = kind;

    if (argc >= 7) {
        target_name = spiGetStackString(stack++);

        if (target_name != NULL) {
            if ((u32) strlen(target_name) >= 0x10) {
                strncpy(event->target, target_name, 0xF);
                event->target[0xF] = 0;
            } else {
                strcpy(event->target, target_name);
            }
        }
    }

    if (argc >= 8) {
        if (spiGetStackInt(stack++)) {
            event->flag |= 2;
        }
    }

    if (argc >= 9) {
        if (spiGetStackInt(stack++)) {
            event->flag |= 4;
        }
    }

    if (argc >= 10) {
        if (spiGetStackInt(stack)) {
            event->flag |= 0x100;
        } else {
            event->flag &= ~0x100;
        }
    }

    return 1;
}

/**
 *
 * Configures the current sound function point's sound and spatial region.
 *
 */
int mapFUNC_SOUND_DATA(SPI_STACK *stack, int argc) {
    CFuncPoint::SoundData *sound = &mapNowFuncPoint->sound;

    if (mapNowFuncPoint == 0) {
        return 0;
    }

    sound->se_no = spiGetStackInt(stack++);
    sound->near_dist = spiGetStackFloat(stack++);
    sound->far_dist = spiGetStackFloat(stack++);
    sound->unk_2c = (float) spiGetStackInt(stack++);
    sound->shape = spiGetStackInt(stack++);
    spiGetStackVector(sound->start, stack);
    spiGetStackVector(sound->end, stack + 3);
    sound->end[3] = 1.0f;
    sound->start[3] = 1.0f;
    return 1;
}

#pragma inline_depth(0)

/**
 *
 * Resolves an effect name and assigns its bounds to the current function point.
 *
 */
int mapFUNC_EFFECT_NAME(SPI_STACK *stack, int argc) {
    char *name;
    char *copy;
    int   effect_index;

    if (mapNowFuncPoint == NULL) {
        return 0;
    }

    name = spiGetStackString(stack);

    if (name == NULL) {
        return 0;
    }

    copy = (char *) mapStack->Alloc(algn16_size(strlen(name) + 1));

    if (copy != NULL) {
        strcpy(copy, name);
    }

    mapNowFuncPoint->effect.name = copy;
    effect_index = mapMap->SaerchEffectIndex(copy);

    if (effect_index >= 0) {
        mapNowFuncPoint->effect.index = effect_index;
        mapNowFuncPoint->frame.SetBound(new (mapStack->Alloc(algn16_size(0xB0) + 2)) mgCFrame::BoundInfo);
    } else {
        mapNowFuncPoint->type = 0;
    }

    return 1;
}

#pragma inline_depth reset

/**
 *
 * Sets the current function point's transform and adjusts event trigger bounds.
 *
 */
int mapFUNC_POS(SPI_STACK *stack, int argc) {
    float                  pos[4];
    float                  rot[4];
    float                  scale[4];
    float                  offset[4];
    float                  matrix[4][4];
    CFuncPoint::EventData *event;
    CFuncPoint            *point;
    int                    scale_y;
    int                    scale_z;
    int                    scale_x;

    if (mapNowFuncPoint == NULL) {
        return 0;
    }

    spiGetStackVector(pos, stack);
    pos[3] = 1.0f;
    spiGetStackVector(rot, stack + 3);
    rot[3] = 0.0f;
    spiGetStackVector(scale, stack + 6);
    scale[3] = 0.0f;
    mapNowFuncPoint->SetPosition(pos);
    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    mapNowFuncPoint->SetRotation(rot);
    mapNowFuncPoint->SetScale(scale);
    point = mapNowFuncPoint;

    if (point->type == 6) {
        event = &point->event;

        if ((event->flag & 0x40) != 0 || (event->flag & 0x20) != 0) {
            if (scale[0] <= 1.1f && scale[1] <= 1.1f && scale[2] <= 1.1f) {
                scale[2] = 25.0f;
                scale[1] = 25.0f;
                scale[0] = 25.0f;
            }
        } else if ((event->flag & 0x200) != 0) {
            scale[2] = 20.0f;
            scale[1] = 20.0f;
            scale[0] = 20.0f;
        } else {
            scale_y = fptosi(0.1f + scale[1]);
            scale_z = fptosi(0.1f + scale[2]);
            scale_x = fptosi(0.1f + scale[0]);

            if (scale_x == 1 && scale_y == 1 && scale_z == 1) {
                scale[2] = 15.0f;
                scale[1] = 15.0f;
                scale[0] = 15.0f;
            }
        }

        point->SetScale(scale);
        mgZeroVector(offset);

        if ((event->flag & 8) != 0) {
            offset[0] = -2.0f;
            offset[2] = -12.0f;
        }

        mgUnitMatrix(matrix);
        sceVu0RotMatrixY(matrix, matrix, rot[1]);
        sceVu0ApplyMatrix(offset, matrix, offset);
        mgAddVector(pos, offset);
        mapNowFuncPoint->SetPosition(pos);
    }

    return 1;
}

void CFuncPoint::SetScale(float *scl) {
    *(u_long128 *) scale = *(u_long128 *) scl;
    frame.SetScale(scl);
}

void CFuncPoint::SetRotation(float *rot) {
    *(u_long128 *) rotation = *(u_long128 *) rot;
    frame.SetRotation(rot);
}

void CFuncPoint::SetPosition(float *pos) {
    *(u_long128 *) position = *(u_long128 *) pos;
    frame.SetPosition(pos);
}

/**
 *
 * Finishes the current function point entry.
 *
 */
int mapFUNC_DATA_END(SPI_STACK *stack, int argc) {
    mapNowFuncPoint = 0;
    mapFuncPointIdx++;
    return 1;
}

#pragma inline_depth(0)

/**
 *
 * Updates status for function points parsed on the map or current part.
 *
 */
int mapFUNC_POINT_END(SPI_STACK *stack, int argc) {
    CFuncPointMngr *mngr;

    if (mapPtsFunc != 0) {
        if (mapNowMapParts == NULL) {
            return 0;
        }

        mngr = &mapNowMapParts->pGetData()->func_point_mngr;
        goto update;
    }

    mngr = &mapMap->func_point;
update:
    mngr->UpdateStatus();
    return 1;
}

#pragma inline_depth reset

/**
 *
 * Maps map script tags to their argument handlers.
 *
 */
static SPI_TAG_PARAM map_tag[] = {
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"d",                    mapDummy               },
    {"PARTS",                mapPARTS               },
    {"FAR_CLIP",             mapFAR_CLIP            },
    {"LIGHT_FLAG",           mapLIGHT_FLAG          },
    {"MOVE_FLAG",            mapMOVE_FLAG           },
    {"LOD_START",            mapLOD_START           },
    {"LOD_BLEND",            mapLOD_BLEND           },
    {"LOD_PIECE",            mapLOD_PIECE           },
    {"LOD_END",              mapLOD_END             },
    {"PIECE",                mapPIECE               },
    {"PIECE_POS",            mapPIECE_POS           },
    {"PIECE_NAME",           mapPIECE_NAME          },
    {"PIECE_ROT",            mapPIECE_ROT           },
    {"PIECE_SCALE",          mapPIECE_SCALE         },
    {"PIECE_MATERIAL_START", mapPIECE_MATERIAL_START},
    {"PIECE_MATERIAL",       mapPIECE_MATERIAL      },
    {"PIECE_MATERIAL_END",   mapPIECE_MATERIAL_END  },
    {"PIECE_COL_TYPE",       mapPIECE_COL_TYPE      },
    {"PIECE_TIME",           mapPIECE_TIME          },
    {"PIECE_END",            mapPIECE_END           },
    {"PARTS_END",            mapPARTS_END           },
    {"MAP_PARTS",            mapMAP_PARTS           },
    {"MAP_FAR_CLIP",         mapMAP_FAR_CLIP        },
    {"PARTS_NAME",           mapPARTS_NAME          },
    {"PARTS_GROUP",          mapPARTS_GROUP         },
    {"PARTS_POS",            mapPARTS_POS           },
    {"PARTS_ROT",            mapPARTS_ROT           },
    {"PARTS_SCALE",          mapPARTS_SCALE         },
    {"MAP_PARTS_END",        mapMAP_PARTS_END       },
    {"_MAP_INFO_TOP",        map_MAP_INFO_TOP       },
    {"CAMERA_INFO",          mapCAMERA_INFO         },
    {"FIX_CAMERA",           mapFIX_CAMERA          },
    {"FIX_CAMERA_POS",       mapFIX_CAMERA_POS      },
    {"FIX_CAMERA_POS2",      mapFIX_CAMERA_POS2     },
    {"FIX_CAMERA_OFF_GROUP", mapFIX_CAMERA_OFF_GROUP},
    {"FIX_CAMERA_RECT",      mapFIX_CAMERA_RECT     },
    {"FIX_CAMERA_END",       mapFIX_CAMERA_END      },
    {"CAMERA_INFO_END",      mapCAMERA_INFO_END     },
    {"FUNC_POINT",           mapFUNC_POINT          },
    {"FUNC_DATA",            mapFUNC_DATA           },
    {"FUNC_NAME",            mapFUNC_NAME           },
    {"FUNC_FLAG",            mapFUNC_FLAG           },
    {"FUNC_FIRE_DATA",       mapFUNC_FIRE_DATA      },
    {"FUNC_EFFECT_NAME",     mapFUNC_EFFECT_NAME    },
    {"FUNC_FIRE_DATA",       mapFUNC_EFFECT_NAME    },
    {"FUNC_PLIGHT_DATA",     mapFUNC_PLIGHT_DATA    },
    {"FUNC_ANIME_DATA",      mapFUNC_ANIME_DATA     },
    {"FUNC_INVENT_DATA",     mapFUNC_INVENT_DATA    },
    {"FUNC_EVENT_DATA",      mapFUNC_EVENT_DATA     },
    {"FUNC_POS",             mapFUNC_POS            },
    {"FUNC_DATA_END",        mapFUNC_DATA_END       },
    {"FUNC_POINT_END",       mapFUNC_POINT_END      },
    {"FUNC_SOUND_DATA",      mapFUNC_SOUND_DATA     },
    {NULL,                   NULL                   },
};

void CMap::LoadMapFile(char *script, int length, mgCMemory *memory, int add_mode) {
    mapStack = memory;
    mapAddMode = add_mode;
    mapMap = this;
    mapNowMapParts = 0;
    mapNowMapPiece = 0;
    mapCameraInfoIdx = 0;
    mapCameraRectIdx = 0;
    mapFuncPointIdx = 0;
    mapNowFuncPoint = 0;
    mapPtsFunc = 0;
    SetPieceLoadSkip(0);
    CScriptInterpreter interpreter;
    interpreter.SetTag(map_tag);
    interpreter.SetScript(script, length);
    interpreter.Run();
}

void CMap::SetPieceLoadSkip(s32 skip) {
    piece_load_skip = skip;
}

/**
 *
 * Adds a map region excluded from normal drawing.
 *
 */
int cfgDRAW_OFF_RECT(SPI_STACK *stack, int argc) {
    mgVu0FBOX first_box;
    mgVu0FBOX second_box;
    spiGetStackVector(first_box.min, stack);
    spiGetStackVector(first_box.max, stack + 3);
    spiGetStackVector(second_box.min, stack + 6);
    spiGetStackVector(second_box.max, stack + 9);
    mapMap->CreateDrawRect(mapStack, &first_box, &second_box, 0);
    return 1;
}

/**
 *
 * Creates a map occlusion plane from four scripted corners.
 *
 */
int cfgOCCLUSION_PLANE(SPI_STACK *stack, int argc) {
    float plane[4][4];
    int   i;

    for (i = 0; i < 4; i++) {
        spiGetStackVector(plane[i], stack);
        plane[i][3] = 1.0f;
        stack += 3;
    }

    mapMap->CreateOcclusion(plane);
    return 1;
}

/**
 *
 * Reserves and creates an event function point from the map configuration.
 *
 */
int cfgFUNC_DATA(SPI_STACK *stack, int argc) {
    char *kind_name;

    if (ReserveFuncFlag == 0) {
        mapMap->func_point.Reserve(0x40, mapStack);
        ReserveFuncFlag = 1;
    }

    kind_name = spiGetStackString(stack);

    if (kind_name == NULL) {
        return 0;
    }

    if (strcmp(kind_name, "event") == 0) {
        mapMap->parts_event = 1;
    } else {
        return 0;
    }

    mapNowFuncPoint = mapMap->func_point.AddFromReserve(6);
    return mapNowFuncPoint != 0;
}

/**
 *
 * Sets the configured event point's identifier and event mode.
 *
 */
int cfgFUNC_EVENT_DATA(SPI_STACK *stack, int argc) {
    char *mode_name;

    if (mapNowFuncPoint == 0) {
        return 0;
    }

    mapNowFuncPoint->event.point_no = spiGetStackInt(stack++);

    if (argc > 1) {
        mode_name = spiGetStackString(stack);
        mapNowFuncPoint->event.event_no = 0;

        if (mode_name != NULL) {
            if (strcmp(mode_name, "every") == 0) {
                mapNowFuncPoint->event.flag = 1;
            } else if (strcmp(mode_name, "action") == 0) {
                mapNowFuncPoint->event.flag = 2;
            } else if (strcmp(mode_name, "check") == 0) {
                mapNowFuncPoint->event.flag = 2;
                mapNowFuncPoint->event.event_no = 1;
            } else if (strcmp(mode_name, "item") == 0) {
                mapNowFuncPoint->event.flag = 4;
                mapNowFuncPoint->event.event_no = 1;
            } else if (strcmp(mode_name, "invent") == 0) {
                mapNowFuncPoint->event.flag = 2;
                mapNowFuncPoint->event.event_no = 2;
            } else {
                return 0;
            }
        }
    }

    return 1;
}

/**
 *
 * Finishes the current configured function point.
 *
 */
int cfgFUNC_DATA_END(SPI_STACK *stack, int argc) {
    mapNowFuncPoint = 0;
    return 1;
}

/**
 *
 * Allocates the map's water surface frame table.
 *
 */
int cfgWATER_SURFACE_NUM(SPI_STACK *stack, int argc) {
    int i;

    mapMap->water_surface_num = spiGetStackInt(stack);

    if (mapMap->water_surface_num > 0) {
        mapMap->water_surface =
            new (mapStack->Alloc(algn16_size(mapMap->water_surface_num * 4) + 2)) CWaterFrame *[mapMap->water_surface_num];

        if (mapMap->water_surface == NULL) {
            mapMap->water_surface_num = 0;
        }

        for (i = 0; i < mapMap->water_surface_num; i++) {
            mapMap->water_surface[i] = NULL;
        }
    }

    return 1;
}

/**
 *
 * Accepts the start marker of a water surface definition.
 *
 */
s32 cfgWATER_SURFACE_START(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Creates a water surface grid from its dimensions and opposite corners.
 *
 */
int cfgWATER_VERTEX(SPI_STACK *stack, int argc) {
    float corner0[4];
    float corner1[4];
    int   count_x = spiGetStackInt(stack++);
    int   count_z = spiGetStackInt(stack++);
    spiGetStackVector(corner0, stack);
    spiGetStackVector(corner1, stack + 3);
    corner1[3] = 1.0f;
    corner0[3] = 1.0f;
    cfgWater = CreateWaterFrame(count_x, count_z, corner0, corner1, mapStack);
    return 1;
}

/**
 *
 * Sets the current water surface frame's position.
 *
 */
int cfgWATER_POS(SPI_STACK *stack, int argc) {
    float pos[4];

    if (cfgWater == NULL) {
        return 0;
    }

    spiGetStackVector(pos, stack);
    cfgWater->SetPosition(pos);
    return 1;
}

/**
 *
 * Applies four scripted parameters to the current water surface.
 *
 */
int cfgWATER_PARAM(SPI_STACK *stack, int argc) {
    float first = spiGetStackFloat(stack++);
    float second = spiGetStackFloat(stack++);
    float third = spiGetStackFloat(stack++);
    float fourth = spiGetStackFloat(stack);
    cfgWater->SetParam(first, second, third, fourth);
    return 1;
}

/**
 *
 * Accepts the water shake configuration tag.
 *
 */
s32 cfgWATER_SHAKE(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Stores the completed water surface frame in the map table.
 *
 */
int cfgWATER_SURFACE_END(SPI_STACK *stack, int argc) {
    if (WaterIndex >= mapMap->water_surface_num) {
        return 0;
    }

    mapMap->water_surface[WaterIndex] = cfgWater;
    cfgWater = NULL;
    WaterIndex++;
    return 1;
}

/**
 *
 * Allocates the map's water drawing records and their part lists.
 *
 */
int cfgWATER_DRAW_NUM(SPI_STACK *stack, int argument_count) {
    mapMap->water_num = spiGetStackInt(stack);
    int water_count = mapMap->water_num;

    if (water_count < 0) {
        return 0;
    }

    mapMap->water = new (
        mapStack->Alloc(algn16_size(water_count * sizeof(CMapWater)) + 2)) CMapWater[water_count];

    for (int index = 0; index < mapMap->water_num; index++) {
        mapMap->water[index].Initialize();
        mapMap->water[index].parts_max = 16;
        mapMap->water[index].parts = new (
            mapStack->Alloc(algn16_size(mapMap->water[index].parts_max * sizeof(CMapParts *)) + 2))
            CMapParts *[mapMap->water[index].parts_max];
        mapMap->water[index].Clear();
    }

    return 1;
}

CMapWater::CMapWater() {}

/**
 *
 * Links a configured water surface to a drawing record and its map parts.
 *
 */
int cfgWATER_DRAW(SPI_STACK *stack, int argc) {
    CMapWater *slot;
    char      *name;
    float      vertices[4];
    int        surface;
    int        i;

    surface = spiGetStackInt(stack++);

    if (surface < 0 || surface >= mapMap->water_surface_num) {
        return 0;
    }

    slot = NULL;

    for (i = 0; i < mapMap->water_num; i++) {
        if (mapMap->water[i].frame == NULL) {
            slot = &mapMap->water[i];
            break;
        }
    }

    if (slot == NULL) {
        return 0;
    }

    slot->frame = mapMap->water_surface[surface];
    name = spiGetStackString(stack++);

    if (name != NULL) {
        if (name[0] != 0) {
            if (strncmp(name, "#follow", 7) == 0) {
                slot->follow[0] = name[7] - '0';
                slot->follow[1] = name[8] - '0';
                slot->follow[2] = name[9] - '0';
            } else {
                slot->parts_name = mgCopyString(name, mapStack);
            }
        }
    }

    if (argc >= 5) {
        spiGetStackVector(vertices, stack);
        slot->SetPosition(vertices);
    }

    return 1;
}

/**
 *
 * Maps map configuration tags to their argument handlers.
 *
 */
static SPI_TAG_PARAM cfg_tag[] = {
    {"DRAW_OFF_RECT",       cfgDRAW_OFF_RECT      },
    {"OCCLUSION_PLANE",     cfgOCCLUSION_PLANE    },
    {"FUNC_DATA",           cfgFUNC_DATA          },
    {"FUNC_NAME",           mapFUNC_NAME          },
    {"FUNC_EVENT_DATA",     cfgFUNC_EVENT_DATA    },
    {"FUNC_POS",            mapFUNC_POS           },
    {"FUNC_DATA",           cfgFUNC_DATA_END      },
    {"WATER_SURFACE_NUM",   cfgWATER_SURFACE_NUM  },
    {"WATER_SURFACE_START", cfgWATER_SURFACE_START},
    {"WATER_VERTEX",        cfgWATER_VERTEX       },
    {"WATER_POS",           cfgWATER_POS          },
    {"WATER_PARAM",         cfgWATER_PARAM        },
    {"WATER_SHAKE",         cfgWATER_SHAKE        },
    {"WATER_SURFACE_END",   cfgWATER_SURFACE_END  },
    {"WATER_DRAW_NUM",      cfgWATER_DRAW_NUM     },
    {"WATER_DRAW",          cfgWATER_DRAW         },
    {NULL,                  NULL                  },
};

void CMap::LoadCfgFile(char *script, int length, mgCMemory *memory) {
    mapMap = this;
    mapStack = memory;
    ReserveFuncFlag = 0;
    WaterIndex = 0;
    cfgWater = NULL;
    CScriptInterpreter interpreter;
    interpreter.SetTag(cfg_tag);
    interpreter.SetScript(script, length);
    interpreter.Run();
}
