#include <cmath>
extern "C" int fptosi(float value);
#include "mglib.hpp"
#include "common.h"
#include "collision.hpp"
#include "funcpoint.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "water.hpp"
#include "mapload.hpp"

#include <cstring>
#include <libvu0.h>

#include "map.hpp"
#include "mapinfo.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "object.hpp"
#include "scriptinterpreter.hpp"

extern CFuncPoint * mapNowFuncPoint;
extern int mapCameraInfoIdx;
extern int mapCameraRectIdx;
extern int mapFuncPointIdx;
extern float mapFarDist;
extern int mapFarAlpha;
extern int mapShow;
extern char mapMapPartsName[0x100];
extern char mapPlacePartsName[0x100];
extern CWaterFrame * cfgWater;
extern int WaterIndex;
extern int ReserveFuncFlag;
extern SPI_TAG_PARAM map_tag[];
extern SPI_TAG_PARAM cfg_tag[];
extern char at_1064[];
extern char at_1128[];
extern char at_1129[];
extern char at_1130[];
extern char at_1131[];
extern char at_1132[];
extern char at_1133[];
extern char at_1134[];
extern char at_1135[];
extern char at_1136[];
extern char at_1278[];
extern char at_1279[];
extern char at_1280[];
extern char at_1281[];
extern char at_1282[];
extern char at_1283[];
extern char at_1284[];
extern char at_1436[];
extern char at_1437[];
extern char at_1438[];
extern char at_1439[];
extern char at_1544[];
MAP_TIME_BAND GetTimeBand(float time);
int mapDummy(SPI_STACK *stack, int argument_count);
static int IsAddMode();
int mapPARTS(SPI_STACK *stack, int argument_count);
int mapFAR_CLIP(SPI_STACK *stack, int argument_count);
int mapLIGHT_FLAG(SPI_STACK *stack, int argument_count);
int mapMOVE_FLAG(SPI_STACK *stack, int argument_count);
int mapLOD_START(SPI_STACK *stack, int argument_count);
int mapLOD_BLEND(SPI_STACK *stack, int argument_count);
int mapLOD_PIECE(SPI_STACK *stack, int argument_count);
int mapLOD_END(SPI_STACK *stack, int argument_count);
int mapPIECE(SPI_STACK *stack, int argument_count);
int mapPIECE_NAME(SPI_STACK *stack, int argument_count);
int mapPIECE_POS(SPI_STACK *stack, int argument_count);
int mapPIECE_ROT(SPI_STACK *stack, int argument_count);
int mapPIECE_SCALE(SPI_STACK *stack, int argument_count);
int mapPIECE_MATERIAL_START(SPI_STACK *stack, int argument_count);
int mapPIECE_MATERIAL(SPI_STACK *stack, int argc);
s32 mapPIECE_MATERIAL_END(SPI_STACK *stack, int argc);
int mapPIECE_COL_TYPE(SPI_STACK *stack, int argc);
int mapPIECE_TIME(SPI_STACK *stack, int argc);
int mapPIECE_END(SPI_STACK *stack, int argc);
int mapPARTS_END(SPI_STACK *stack, int argc);
int mapMAP_PARTS(SPI_STACK *stack, int argc);
int mapMAP_FAR_CLIP(SPI_STACK *stack, int argc);
int mapPARTS_NAME(SPI_STACK *stack, int argc);
int mapPARTS_GROUP(SPI_STACK *stack, int argc);
int mapPARTS_POS(SPI_STACK *stack, int argc);
int mapPARTS_ROT(SPI_STACK *stack, int argc);
int mapPARTS_SCALE(SPI_STACK *stack, int argc);
int mapMAP_PARTS_END(SPI_STACK *stack, int argc);
s32 map_MAP_INFO_TOP(SPI_STACK *stack, int argc);
int mapCAMERA_INFO(SPI_STACK *stack, int argc);
int mapFIX_CAMERA(SPI_STACK *stack, int argc);
int mapFIX_CAMERA_POS(SPI_STACK *stack, int argc);
int mapFIX_CAMERA_POS2(SPI_STACK *stack, int argc);
int mapFIX_CAMERA_RECT(SPI_STACK *stack, int argc);
int mapFIX_CAMERA_END(SPI_STACK *stack, int argc);
s32 mapCAMERA_INFO_END(SPI_STACK *stack, s32 argument_count);
int mapFUNC_POINT(SPI_STACK *stack, int argc);
int mapFUNC_DATA(SPI_STACK *stack, int argc);
int mapFUNC_NAME(SPI_STACK *stack, int argc);
int mapFUNC_FLAG(SPI_STACK *stack, int argc);
int mapFUNC_FIRE_DATA(SPI_STACK *stack, int argc);
int mapFUNC_PLIGHT_DATA(SPI_STACK *stack, int argc);
int mapFUNC_ANIME_DATA(SPI_STACK *stack, int argc);
int mapFUNC_INVENT_DATA(SPI_STACK *stack, int argc);
int mapFUNC_EVENT_DATA(SPI_STACK *stack, int argc);
int mapFUNC_SOUND_DATA(SPI_STACK *stack, int argc);
int mapFUNC_EFFECT_NAME(SPI_STACK *stack, int argc);
int mapFUNC_POS(SPI_STACK *stack, int argc);
int mapFUNC_DATA_END(SPI_STACK *stack, int argc);
int mapFUNC_POINT_END(SPI_STACK *stack, int argc);
int cfgDRAW_OFF_RECT(SPI_STACK *stack, int argc);
int cfgOCCLUSION_PLANE(SPI_STACK *stack, int argc);
int cfgFUNC_DATA(SPI_STACK *stack, int argc);
int cfgFUNC_EVENT_DATA(SPI_STACK *stack, int argc);
int cfgFUNC_DATA_END(SPI_STACK *stack, int argc);
int cfgWATER_SURFACE_NUM(SPI_STACK *stack, int argc);
s32 cfgWATER_SURFACE_START(SPI_STACK *stack, int argc);
int cfgWATER_VERTEX(SPI_STACK *stack, int argc);
int cfgWATER_POS(SPI_STACK *stack, int argc);
int cfgWATER_PARAM(SPI_STACK *stack, int argc);
s32 cfgWATER_SHAKE(SPI_STACK *stack, int argc);
int cfgWATER_SURFACE_END(SPI_STACK *stack, int argc);
int cfgWATER_DRAW(SPI_STACK *stack, int argc);

/** Non-zero when loading an additional map into the current map. */
extern int mapAddMode;

/**
 *
 * Map the map script is loading into.
 *
 */
// Small uninitialised data (.sbss)
static CMap *mapMap;

/**
 *
 * Node of the map part the map script is building, or null outside a part.
 *
 */
static CList<CMapParts> *mapNowMapParts;

/**
 *
 * Node of the map piece the map script is building, or null outside a piece.
 *
 */
static CList<CMapPiece> *mapNowMapPiece;

/**
 *
 * Memory that everything the map script builds is taken from.
 *
 */
static mgCMemory *mapStack;

/**
 *
 * Non-zero while function points of the map script go to the current map part rather than the map.
 *
 */
static int mapPtsFunc;

/**
 *
 * Next entry of the current piece's materials that the map script fills in.
 *
 */
static int mapMatIdx;

/**
 *
 * Level of detail that the map script is giving pieces to.
 *
 */
static int mapLOD_ID;

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
    if (time_enable) {
        return now_time;
    }
    if (fixed_time_enable) {
        return fixed_time;
    }
    return 12.0f;
}

int CMap::GetNowTimeBand() {
    return GetTimeBand(GetNowTime());
}

int CMap::GetNowTimeLightBand() {
    int num = time_light_num;
    if (num < 2) {
        return 0;
    }
    if (num == MAP_TIME_BAND_NUM) {
        return GetNowTimeBand();
    }

    // The light sets divide the day evenly, the first starting at 9:00.
    float time = GetNowTime() - 9.0f;
    if (time < 0.0f) {
        time += 24.0f;
    }
    return (int)(time / (24.0f / num)) % num;
}

void CMap::GetLightingRatio(float *out_ratio) {
    float time = GetNowTime();
    out_ratio[MAP_TIME_BAND_DAY] = 0.0f;
    out_ratio[MAP_TIME_BAND_EVENING] = 0.0f;
    out_ratio[MAP_TIME_BAND_NIGHT] = 0.0f;
    out_ratio[MAP_TIME_BAND_MORNING] = 0.0f;

    // In the last hour of each band the light fades into the next band's.
    float blend = 0.0f;
    int band = GetNowTimeBand();
    int next = (band + 1) % MAP_TIME_BAND_NUM;
    if (band == MAP_TIME_BAND_NIGHT) {
        if (time < 6.0f && time > 5.0f) {
            blend = time - 5.0f;
        }
    } else if (band == MAP_TIME_BAND_EVENING) {
        if (time > 20.0f) {
            blend = time - 20.0f;
        }
    } else if (band == MAP_TIME_BAND_DAY) {
        if (time > 16.0f) {
            blend = time - 16.0f;
        }
    } else if (band == MAP_TIME_BAND_MORNING) {
        if (time > 8.0f) {
            blend = time - 8.0f;
        }
    }
    out_ratio[band] = 1.0f - blend;
    out_ratio[next] = blend;
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

int CMap::GetTimeLightingRatio(float *out_ratio) {
    int num = time_light_num;
    if (num == MAP_TIME_BAND_NUM) {
        GetLightingRatio(out_ratio);
    } else {
        float time = GetNowTime();
        for (int i = 0; i < num; i++) {
            out_ratio[i] = 0.0f;
        }
        if (num < 2) {
            out_ratio[0] = 1.0f;
        } else {
            // The light set in use fades into the next over the last hour before the next starts.
            int band = GetNowTimeLightBand();
            float start = band * (24.0f / num) + 9.0f;
            if (start >= 24.0f) {
                start -= 24.0f;
            }
            float ratio = (start + 24.0f / num) - time;
            if (ratio >= 1.0f) {
                ratio = 1.0f;
            }
            out_ratio[band] = ratio;
            out_ratio[(band + 1) % num] = 1.0f - ratio;
        }
    }
    return num;
}

void CMap::GetSunPoint(float *out_pos) {
    sceVu0FVECTOR sun = {0.0f, -1900.0f, 700.0f, 1.0f};
    sceVu0FMATRIX matrix;

    mgUnitMatrix(matrix);
    sceVu0RotMatrixZ(matrix, matrix, mgAngleLimit((GetNowTime() * 6.2831855f) / 24.0f));
    sceVu0RotMatrixY(matrix, matrix, sun_angle);
    sceVu0ApplyMatrix(out_pos, matrix, sun);
}

float CMap::GetLightNoTime(int light_no) {
    int num = time_light_num;
    if (light_no < num && GetTimeEnable()) {
        if (num == MAP_TIME_BAND_NUM) {
            switch (light_no) {
            case MAP_TIME_BAND_MORNING:
                return 6.5f;
            case MAP_TIME_BAND_DAY:
                return 9.5f;
            case MAP_TIME_BAND_EVENING:
                return 17.5f;
            case MAP_TIME_BAND_NIGHT:
                return 21.5f;
            default:
                return -1.0f;
            }
        }
        float time = (24.0f * light_no) / num + 9.5f;
        if (time < 0.0f) {
            time += 24.0f;
        }
        return time;
    }
    return -1.0f;
}

int CMap::GetTimeEnable() {
    return time_enable;
}

void CMap::GetLightInfo(CMapLightingInfo *out_info) {
    if (out_info == NULL) {
        return;
    }

    int num = time_light_num;
    if (GetActiveLightNo() >= num || (!GetTimeEnable() && !fixed_time_enable)) {
        CMapLightingInfo *info = GetLightingInfo(GetActiveLightNo());
        if (info != NULL) {
            *out_info = *info;
            return;
        }
    }

    CMapLightingInfo *list[8];
    float ratio[8];
    sceVu0FVECTOR sun;

    int band = GetNowTimeLightBand();
    for (int i = 0; i < num; i++) {
        list[i] = CMapInfo::GetLightingInfo(i);
        if (list[i] == NULL) {
            return;
        }
    }
    *out_info = *list[band];

    if (time_light_blend) {
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

// Generated by the compiler from CMapLightingInfo in mapload.hpp.
CMapLightingInfo &CMapLightingInfo::operator=(const CMapLightingInfo &other) {
    projection = other.projection;
    memcpy(bg_color, other.bg_color, sizeof(bg_color));
    memcpy(bg_color2, other.bg_color2, sizeof(bg_color2));
    memcpy(light_dir, other.light_dir, sizeof(light_dir));
    memcpy(light_color, other.light_color, sizeof(light_color));
    plight_enable = other.plight_enable;
    memcpy(point_light, other.point_light, sizeof(point_light));
    memcpy(ambient, other.ambient, sizeof(ambient));
    fog_enable = other.fog_enable;
    memcpy(&fog, &other.fog, sizeof(fog));
    return *this;
}
mgMaterial *mgCFrame::GetMaterial(int index) { if (visual != NULL) return visual->GetMaterial(index); return NULL; }

CMapLightingInfo *CMap::GetLightingInfo(int no) {
    return CMapInfo::GetLightingInfo(no);
}

int CMap::GetActiveLightNo() {
    return CMapInfo::GetActiveLightNo();
}

// Defined in mapinfo.hpp.
void CMap::GetLightInfo(CMapLightingInfo *out_info, float *ratio, int num) {
    sceVu0FMATRIX light_dir;
    sceVu0FMATRIX light_color;
    sceVu0FVECTOR ambient;
    sceVu0FVECTOR bg_color;
    sceVu0FVECTOR bg_color2;
    sceVu0FVECTOR fog;
    sceVu0FVECTOR fog_color;
    CMapLightingInfo *list[8];
    sceVu0FVECTOR work;
    int fog_num = 0;
    int i;
    int j;

    for (i = 0; i < time_light_num; i++) {
        list[i] = CMapInfo::GetLightingInfo(i);
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
        if (ratio[i] > 0.0f) {
            CMapLightingInfo *info = list[i];
            sceVu0ScaleVector(work, info->ambient, ratio[i]);
            mgAddVector(ambient, work);
            sceVu0ScaleVector(work, info->bg_color, ratio[i]);
            mgAddVector(bg_color, work);
            sceVu0ScaleVector(work, info->bg_color2, ratio[i]);
            mgAddVector(bg_color2, work);

            // Only the sets that draw fog weigh in its colour and distances.
            if (info->fog_enable) {
                work[0] = info->fog.r;
                work[1] = info->fog.g;
                work[2] = info->fog.b;
                work[3] = info->fog.unk_b;
                sceVu0ScaleVector(work, work, ratio[i]);
                mgAddVector(fog_color, work);
                work[0] = info->fog.near_dist;
                work[1] = info->fog.far_dist;
                work[2] = info->fog.far_value;
                work[3] = info->fog.near_value;
                sceVu0ScaleVector(work, work, ratio[i]);
                mgAddVector(fog, work);
                fog_num++;
            }

            for (j = 0; j < 4; j++) {
                sceVu0ScaleVector(work, info->light_dir[j], ratio[i]);
                mgAddVector(light_dir[j], work);
                sceVu0ScaleVector(work, info->light_color[j], ratio[i]);
                mgAddVector(light_color[j], work);
            }
        }
    }

    // Each row now holds one light's direction, normalised unless the blend cancelled it out.
    sceVu0TransposeMatrix(light_dir, light_dir);
    for (i = 0; i < 4; i++) {
        if (mgDistVector(light_dir[i]) > 0.0f) {
            sceVu0Normalize(light_dir[i], light_dir[i]);
        }
    }

    if (mgAbs(ambient[3] - 128.0f) < 0.01f) {
        ambient[3] = 128.0f;
    }

    sceVu0CopyVector(out_info->ambient, ambient);
    sceVu0CopyVector(out_info->bg_color, bg_color);
    sceVu0CopyVector(out_info->bg_color2, bg_color2);
    for (i = 0; i < 4; i++) {
        out_info->light_dir[0][i] = light_dir[i][0];
        out_info->light_dir[1][i] = light_dir[i][1];
        out_info->light_dir[2][i] = light_dir[i][2];
        sceVu0CopyVector(out_info->light_color[i], light_color[i]);
    }
    out_info->fog.r = fog_color[0];
    out_info->fog.g = fog_color[1];
    out_info->fog.b = fog_color[2];
    out_info->fog.unk_b = fog_color[3];
    out_info->fog.near_dist = fog[0];
    out_info->fog.far_dist = fog[1];
    out_info->fog.far_value = fog[2];
    out_info->fog.near_value = fog[3];
    out_info->fog_enable = fog_num > 0;
}

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
int mapPARTS(SPI_STACK *stack, int argument_count) {
    mapNowMapParts = new (mapStack->Alloc(algn16_size(sizeof(CList<CMapParts>)) + 2)) CList<CMapParts>;
    CMapParts *parts = mapNowMapParts->pGetData();
    char *name = spiGetStackString(stack);
    parts->SetName(name);
    parts->SetPartsName(name);
    mapLOD_ID = 0;
    mapPtsFunc = 1;
    return 1;
}

// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.
CObject::CObject() {
    Initialize();
}

// Defined in mg_frame.hpp.
// Defined in mapload.hpp.
unsigned int algn16_size(unsigned int size) {
    unsigned int units = size >> 4;
    if (size & 0xF) {
        units = (size >> 4) + 1;
    }
    return units;
}

/**
 *
 * Gives the current map part its far clip distance and whether it fades out there.
 *
 */
int mapFAR_CLIP(SPI_STACK *stack, int argument_count) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    mapNowMapParts->pGetData()->far_dist = spiGetStackFloat(&stack[0]);
    mapNowMapParts->pGetData()->fade = spiGetStackInt(&stack[1]);
    return 1;
}

/**
 *
 * Sets whether the current map part is drawn without the scene's lights and without point lights.
 *
 */
int mapLIGHT_FLAG(SPI_STACK *stack, int argument_count) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    mapNowMapParts->pGetData()->no_light = spiGetStackInt(&stack[0]);
    mapNowMapParts->pGetData()->no_plight = spiGetStackInt(&stack[1]);
    return 1;
}

/**
 *
 * Sets the four move flags of the current map part, one per argument.
 *
 */
int mapMOVE_FLAG(SPI_STACK *stack, int argument_count) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    CMapParts *parts = mapNowMapParts->pGetData();
    parts->move_flag = 0;
    if (spiGetStackInt(&stack[0])) {
        parts->move_flag |= 1;
    }
    if (spiGetStackInt(&stack[1])) {
        parts->move_flag |= 2;
    }
    if (spiGetStackInt(&stack[2])) {
        parts->move_flag |= 4;
    }
    if (spiGetStackInt(&stack[3])) {
        parts->move_flag |= 8;
    }
    return 1;
}

/**
 *
 * Gives the current map part four levels of detail at the standard distances.
 *
 */
int mapLOD_START(SPI_STACK *stack, int argument_count) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    float *dist = (float *)mapStack->Alloc(1);
    CMapParts *parts = mapNowMapParts->pGetData();
    dist[0] = 600.0f;
    dist[1] = 1000.0f;
    dist[2] = 1400.0f;
    dist[3] = 1800.0f;
    parts->SetLODDist(dist, 4);
    return 1;
}

// Defined in mapparts.hpp.
/**
 *
 * Sets whether the current map part blends between its levels of detail.
 *
 */
int mapLOD_BLEND(SPI_STACK *stack, int argument_count) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    mapNowMapParts->pGetData()->SetLODBlend(spiGetStackInt(stack));
    return 1;
}

// Defined in mapparts.hpp.
/**
 *
 * Puts a piece of the current map part into a level of detail, hiding it until that level is reached.
 *
 */
int mapLOD_PIECE(SPI_STACK *stack, int argument_count) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    CMapParts *parts = mapNowMapParts->pGetData();
    int level = spiGetStackInt(&stack[0]);
    CMapPiece *piece = parts->SearchPiece(spiGetStackString(&stack[1]));
    if (piece != NULL) {
        if (level > 0) {
            piece->show = 0;
            piece->fade_alpha = 0.0f;
        }
        if (parts->GetLODBlend()) {
            piece->fade = 1;
        }
    }
    return 1;
}

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
int mapPIECE(SPI_STACK *stack, int argument_count) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    char *name = spiGetStackString(stack);
    if (name == NULL) {
        return 0;
    }
    int show = 1;
    if (argument_count > 1) {
        show = spiGetStackInt(&stack[1]);
    }
    if (!(mapMap->piece_load_skip & 1)) {
        mapNowMapPiece = new (mapStack->Alloc(algn16_size(sizeof(CList<CMapPiece>)) + 2)) CList<CMapPiece>;
        CMapPiece *piece = mapNowMapPiece->pGetData();
        int size = strlen(name) + 1;
        char *copy = (char *)mapStack->Alloc(size / 16 + (size % 16 != 0));
        strcpy(copy, name);
        piece->SetName(copy);
        piece->show = show;
        CMdsInfo *mds = mapMap->SearchMDS(copy);
        if (mds != NULL) {
            piece->AssignMds(mds);
        }
    }
    return 1;
}

// Defined in mdslist.hpp.
// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.
// Defined in mg_tanime.hpp.
// Defined in mdslist.hpp.
// Defined in object.hpp.
CObjectFrame::CObjectFrame() {
    Initialize();
}

/**
 *
 * Renames the model data that the current piece uses.
 *
 */
int mapPIECE_NAME(SPI_STACK *stack, int argument_count) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }
    CMapPiece *piece = mapNowMapPiece->pGetData();
    char *name = spiGetStackString(stack);
    if (name != NULL) {
        char *copy = (char *)mapStack->Alloc(algn16_size(strlen(name) + 1));
        strcpy(copy, name);
        piece->SetName(copy);
    }
    return 1;
}

/**
 *
 * Moves the current piece to the position of the three arguments.
 *
 */
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

/**
 *
 * Turns the current piece to the angles of the three arguments.
 *
 */
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

/**
 *
 * Scales the current piece by the three arguments.
 *
 */
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

/**
 *
 * Gives the current piece as many material colour entries as the first argument, filled in by the PIECE_MATERIAL tags that follow.
 *
 */
int mapPIECE_MATERIAL_START(SPI_STACK *stack, int argument_count) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }
    mapMatIdx = 0;
    int num = spiGetStackInt(stack);
    if (num > 0) {
        PieceMaterial *material = new (mapStack->Alloc(algn16_size(num * sizeof(PieceMaterial)) + 2)) PieceMaterial[num];
        if (material != NULL) {
            mapNowMapPiece->pGetData()->SetMaterial(material, num);
        }
    }
    return 1;
}

// Defined in mdslist.hpp.
PieceMaterial::PieceMaterial() { Initialize(); }
void PieceMaterial::Initialize() { memset(this, 0, sizeof(PieceMaterial)); }
int mapPIECE_MATERIAL(SPI_STACK *stack, int argc) {
    CMapPiece *piece;
    PieceMaterial *slot;
    mgCFrame *frame;
    char *name;

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
    frame = (mgCFrame *)((CObjectFrame *)piece)->GetFrame();
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

s32 mapPIECE_MATERIAL_END(SPI_STACK *stack, int argc) {
    return 1;
}
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
int mapPIECE_TIME(SPI_STACK *stack, int argc) {
    if (mapNowMapPiece == NULL) {
        return 0;
    }
    CMapPiece *piece = mapNowMapPiece->pGetData();
    float start = spiGetStackFloat(stack++);
    piece->SetTimeBand(start, spiGetStackFloat(stack));
    return 1;
}
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
int mapPARTS_END(SPI_STACK *stack, int argc) {
    if (mapNowMapParts == NULL) {
        return 0;
    }
    mapMap->AddParts(mapNowMapParts);
    mapPtsFunc = 0;
    mapNowMapParts->pGetData()->CreateBoundBox();
    return 1;
}
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
int mapMAP_FAR_CLIP(SPI_STACK *stack, int argc) {
    mapFarDist = spiGetStackFloat(stack++);
    mapFarAlpha = spiGetStackInt(stack);
    return 1;
}
int mapPARTS_NAME(SPI_STACK *stack, int argc) {
    char *text = spiGetStackString(stack);
    if (text == NULL) {
        return 0;
    }
    strcpy(mapMapPartsName, text);
    return 1;
}
int mapPARTS_GROUP(SPI_STACK *stack, int argc) {
    char *text = spiGetStackString(stack);
    if (text == NULL) {
        return 0;
    }
    strcpy(mapMapPartsGroupName, text);
    return 1;
}
int mapPARTS_POS(SPI_STACK *stack, int argc) {
    spiGetStackVector(mapPos, stack);
    return 1;
}
int mapPARTS_ROT(SPI_STACK *stack, int argc) {
    spiGetStackVector(mapRot, stack);
    return 1;
}
int mapPARTS_SCALE(SPI_STACK *stack, int argc) {
    spiGetStackVector(mapScale, stack);
    return 1;
}
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
    if ((s8)mapMapPartsGroupName[0] != 0) {
        parts->group_no = mapMap->AddPartsGroup(mapMapPartsGroupName, parts, mapStack);
    }
    return 1;
}
s32 map_MAP_INFO_TOP(SPI_STACK *stack, int argc) {
    return 1;
}
int mapCAMERA_INFO(SPI_STACK *stack, int argc) { if (IsAddMode()) return 1; int num = spiGetStackInt(stack); if (num < 0) return 0; mapMap->SetCameraInfoTable(new (mapStack->Alloc(algn16_size(num * sizeof(CCameraInfo)) + 2)) CCameraInfo[num], num); mapCameraInfoIdx = 0; return 1; }
CCameraInfo::CCameraInfo() {
    Initialize();
}
CCameraDrawInfo::CCameraDrawInfo() {
    Initialize();
}
void CCameraDrawInfo::Initialize() { unk_4 = 0; group_no = -1; }
int mapFIX_CAMERA(SPI_STACK *stack, int argc) {
    if (IsAddMode() != 0) {
        return 1;
    }
    mapCameraRectIdx = 0;
    return 1;
}
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
int mapFIX_CAMERA_POS2(SPI_STACK *stack, int argc) {
    CCameraInfo *info;
    int index;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapload", mapFIX_CAMERA_OFF_GROUP__FP9SPI_STACKi);
int mapFIX_CAMERA_RECT(SPI_STACK *stack, int argc) {
    CCameraInfo *info;
    char *name;
    CColFrame *frame;
    CCollision *collision;
    float vec[4];

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
    frame = (CColFrame *)operator new(sizeof(CColFrame),
                                      (u_long128 *)mapStack->Alloc(algn16_size(sizeof(CColFrame)) + 2));
    if (frame != NULL) {
        new ((u_long128 *)frame) CColFrame;
    }
    collision = NULL;
    if (strcmp(name, at_1064) == 0) {
        collision = (CCollision *)operator new(
            sizeof(CCollision), (u_long128 *)mapStack->Alloc(algn16_size(sizeof(CCollision)) + 2));
        if (collision != NULL) {
            new ((u_long128 *)collision) CCollision;
        }
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

int mapFIX_CAMERA_END(SPI_STACK *stack, int argc) {
    if (IsAddMode() != 0) {
        return 1;
    }
    mapCameraInfoIdx += 1;
    return 1;
}
s32 mapCAMERA_INFO_END(SPI_STACK *stack, s32 argument_count) {
    if (IsAddMode() != 0) {
        return 1;
    }
    return 1;
}
int mapFUNC_POINT(SPI_STACK *stack, int argc) {
    spiGetStackInt(stack);
    mapFuncPointIdx = 0;
    return 1;
}
int mapFUNC_DATA(SPI_STACK *stack, int argc) {
    char *name;
    int kind;

    mapNowFuncPoint = NULL;
    name = spiGetStackString(stack++);
    if (name == NULL) {
        return 0;
    }
    if (strcmp(name, at_1128) == 0) {
        kind = 1;
    } else if (strcmp(name, at_1129) == 0) {
        kind = 2;
    } else if (strcmp(name, at_1130) == 0) {
        kind = 3;
    } else if (strcmp(name, at_1131) == 0) {
        kind = 4;
    } else if (strcmp(name, at_1132) == 0) {
        kind = 5;
    } else if (strcmp(name, at_1133) == 0) {
        kind = 7;
    } else if (strcmp(name, at_1134) == 0) {
        kind = 6;
        mapMap->parts_event = 1;
    } else if (strcmp(name, at_1135) == 0) {
        kind = 8;
    } else if (strcmp(name, at_1136) == 0) {
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
int mapFUNC_NAME(SPI_STACK *stack, int argc) {
    if (mapNowFuncPoint == 0) {
        return 0;
    }
    char *name = spiGetStackString(stack);
    if (name == NULL) {
        return 0;
    }
    char *copy = (char *)mapStack->Alloc(algn16_size(strlen(name) + 1));
    if (copy != NULL) {
        strcpy(copy, name);
    }
    mapNowFuncPoint->name = copy;
    return 1;
}
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
    *(u_long128 *)mapNowFuncPoint->fire.color = *(u_long128 *)color;
    mapNowFuncPoint->fire.unk_30 = !(spiGetStackInt(stack++) != 0);
    if (argc >= 5) {
        mapNowFuncPoint->fire.unk_34 = spiGetStackInt(stack++);
    }
    if (argc >= 6) {
        mapNowFuncPoint->fire.unk_38 = spiGetStackInt(stack);
    }
    return 1;
}
int mapFUNC_PLIGHT_DATA(SPI_STACK *stack, int argc) {
    float color[4];
    float largest;
    CFuncPoint *funcPoint;
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
    funcPoint = (CFuncPoint *)mapNowFuncPoint;
    funcPoint->plight.range =
        0.25 * ((double)funcPoint->plight.power * sqrt((double)largest));
    *(u_long128 *)mapNowFuncPoint->plight.color = *(u_long128 *)color;
    mapNowFuncPoint->plight.unk_38 = spiGetStackInt(stack++);
    if (argc >= 6) {
        mapNowFuncPoint->plight.unk_3c = spiGetStackInt(stack++);
    }
    if (argc >= 7) {
        mapNowFuncPoint->plight.unk_40 = spiGetStackInt(stack++);
    }
    if (argc >= 8) {
        mapNowFuncPoint->plight.unk_44 = spiGetStackInt(stack++);
    }
    if (argc >= 9) {
        mapNowFuncPoint->plight.unk_48 = spiGetStackInt(stack++);
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
int mapFUNC_ANIME_DATA(SPI_STACK *stack, int argc) {
    CFuncPoint::AnimeData *anime;
    if (mapNowFuncPoint == 0) {
        return 0;
    }
    anime = &mapNowFuncPoint->anime;
    anime->unk_20 = mgCopyString(spiGetStackString(stack++), mapStack);
    anime->piece_name = mgCopyString(spiGetStackString(stack++), mapStack);
    anime->frame_name = mgCopyString(spiGetStackString(stack++), mapStack);
    anime->unk_2c = spiGetStackInt(stack++);
    anime->unk_30 = spiGetStackInt(stack++);
    spiGetStackVector(anime->param, stack);
    spiGetStackVector(anime->unk_50, stack + 3);
    spiGetStackVector(anime->unk_60, stack + 6);
    anime->unk_34 = 0;
    stack += 9;
    if (argc >= 15) {
        anime->unk_34 = spiGetStackInt(stack++);
    }
    if (argc >= 16) {
        anime->unk_36 = spiGetStackInt(stack);
    }
    return 1;
}
int mapFUNC_INVENT_DATA(SPI_STACK *stack, int argc) {
    CFuncPoint::InventData *invent = &mapNowFuncPoint->invent;
    if (mapNowFuncPoint == 0) {
        return 0;
    }
    invent->unk_20 = spiGetStackInt(stack++);
    spiGetStackVector(invent->box.min, stack);
    invent->box.min[3] = 1.0f;
    spiGetStackVector(invent->box.max, stack + 3);
    stack += 6;
    invent->box.max[3] = 1.0f;
    invent->unk_24 = spiGetStackInt(stack++);
    invent->unk_28 = spiGetStackFloat(stack++);
    invent->angle = 3.1415927f * spiGetStackFloat(stack) / 180.0f;
    return 1;
}
int mapFUNC_EVENT_DATA(SPI_STACK *stack, int argc) {
    char *kindName;
    int kind;
    char *targetName;
    CFuncPoint::EventData *event;
    if (mapNowFuncPoint == 0) {
        return 0;
    }
    kindName = spiGetStackString(stack++);
    kind = 0;
    event = &mapNowFuncPoint->event;
    event->event_no = spiGetStackInt(stack++);
    event->unk_28 = spiGetStackInt(stack++);
    event->unk_2c = spiGetStackInt(stack++);
    event->unk_30 = spiGetStackInt(stack++);
    event->unk_34 = spiGetStackInt(stack++);
    if (kindName != NULL) {
        if (strcmp(kindName, at_1278) == 0) {
            kind = 0x10A;
        } else if (strcmp(kindName, at_1279) == 0) {
            kind = 0x11A;
        } else if (strcmp(kindName, at_1280) == 0) {
            kind = 0x20;
            event->event_no = 1;
        } else if (strcmp(kindName, at_1281) == 0) {
            kind = 0x40;
            event->event_no = 1;
        } else if (strcmp(kindName, at_1282) == 0) {
            kind = 0x8A;
        } else if (strcmp(kindName, at_1283) == 0) {
            kind = 0x202;
            event->event_no = 1;
        } else if (strcmp(kindName, at_1284) == 0) {
            kind = 0x402;
        }
    }
    event->flag = kind;
    if (argc >= 7) {
        targetName = spiGetStackString(stack++);
        if (targetName != NULL) {
            if ((u32)strlen(targetName) >= 0x10) {
                strncpy(event->unk_38, targetName, 0xF);
                event->unk_38[0xF] = 0;
            } else {
                strcpy(event->unk_38, targetName);
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
int mapFUNC_SOUND_DATA(SPI_STACK *stack, int argc) {
    CFuncPoint::SoundData *sound = &mapNowFuncPoint->sound;
    if (mapNowFuncPoint == 0) {
        return 0;
    }
    sound->se_no = spiGetStackInt(stack++);
    sound->unk_24 = spiGetStackFloat(stack++);
    sound->unk_28 = spiGetStackFloat(stack++);
    sound->unk_2c = (float)spiGetStackInt(stack++);
    sound->shape = spiGetStackInt(stack++);
    spiGetStackVector(sound->start, stack);
    spiGetStackVector(sound->end, stack + 3);
    sound->end[3] = 1.0f;
    sound->start[3] = 1.0f;
    return 1;
}
int mapFUNC_EFFECT_NAME(SPI_STACK *stack, int argc) {
    char *name;
    char *copy;
    int effectIndex;

    if (mapNowFuncPoint == NULL) {
        return 0;
    }
    name = spiGetStackString(stack);
    if (name == NULL) {
        return 0;
    }
    copy = (char *)mapStack->Alloc(algn16_size(strlen(name) + 1));
    if (copy != NULL) {
        strcpy(copy, name);
    }
    mapNowFuncPoint->anime.unk_20 = copy;
    effectIndex = mapMap->SaerchEffectIndex(copy);
    if (effectIndex >= 0) {
        *(int *)&mapNowFuncPoint->anime.piece_name = effectIndex;
        ((mgCFrame *)&mapNowFuncPoint->frame)
            ->SetBound((mgCFrame::BoundInfo *)operator new(
                0xB0, (u_long128 *)mapStack->Alloc(algn16_size(0xB0) + 2)));
    } else {
        mapNowFuncPoint->type = 0;
    }
    return 1;
}

int mapFUNC_POS(SPI_STACK *stack, int argc) {
    float pos[4];
    float rot[4];
    float scale[4];
    float offset[4];
    float matrix[4][4];
    CFuncPoint::EventData *event;
    CFuncPoint *point;
    int scaleY;
    int scaleZ;
    int scaleX;

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
            scaleY = fptosi(0.1f + scale[1]);
            scaleZ = fptosi(0.1f + scale[2]);
            scaleX = fptosi(0.1f + scale[0]);
            if (scaleX == 1 && scaleY == 1 && scaleZ == 1) {
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
        mgUnitMatrix((float(*)[4])matrix);
        sceVu0RotMatrixY(matrix, matrix, rot[1]);
        sceVu0ApplyMatrix(offset, matrix, offset);
        mgAddVector(pos, offset);
        mapNowFuncPoint->SetPosition(pos);
    }
    return 1;
}
void CFuncPoint::SetScale(float *scl) {
    *(u_long128 *)scale = *(u_long128 *)scl;
    frame.SetScale(scl);
}
void CFuncPoint::SetRotation(float *rot) {
    *(u_long128 *)rotation = *(u_long128 *)rot;
    frame.SetRotation(rot);
}
void CFuncPoint::SetPosition(float *pos) {
    *(u_long128 *)position = *(u_long128 *)pos;
    frame.SetPosition(pos);
}
int mapFUNC_DATA_END(SPI_STACK *stack, int argc) {
    mapNowFuncPoint = 0;
    mapFuncPointIdx++;
    return 1;
}
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
void CMap::LoadMapFile(char *script, int length, mgCMemory *memory, int addMode) {

    CScriptInterpreter interpreter;
    mapStack = memory;
    mapAddMode = addMode;
    mapMap = this;
    mapNowMapParts = 0;
    mapNowMapPiece = 0;
    mapCameraInfoIdx = 0;
    mapCameraRectIdx = 0;
    mapFuncPointIdx = 0;
    mapNowFuncPoint = 0;
    mapPtsFunc = 0;
    SetPieceLoadSkip(0);
    interpreter.SetTag(map_tag);
    interpreter.SetScript(script, length);
    interpreter.Run();
}
void CMap::SetPieceLoadSkip(s32 skip) {
    piece_load_skip = skip;
}
int cfgDRAW_OFF_RECT(SPI_STACK *stack, int argc) {
    mgVu0FBOX firstBox;
    mgVu0FBOX secondBox;
    spiGetStackVector(firstBox.min, stack);
    spiGetStackVector(firstBox.max, stack + 3);
    spiGetStackVector(secondBox.min, stack + 6);
    spiGetStackVector(secondBox.max, stack + 9);
    mapMap->CreateDrawRect(mapStack, &firstBox, &secondBox, 0);
    return 1;
}
int cfgOCCLUSION_PLANE(SPI_STACK *stack, int argc) {
    float plane[4][4];
    int i;

    for (i = 0; i < 4; i++) {
        spiGetStackVector(plane[i], stack);
        *(int *)&plane[i][3] = 0x3F800000;
        stack += 3;
    }
    mapMap->CreateOcclusion(plane);
    return 1;
}
int cfgFUNC_DATA(SPI_STACK *stack, int argc) {
    char *kindName;

    if (ReserveFuncFlag == 0) {
        mapMap->func_point.Reserve(0x40, mapStack);
        ReserveFuncFlag = 1;
    }
    kindName = spiGetStackString(stack);
    if (kindName == NULL) {
        return 0;
    }
    if (strcmp(kindName, at_1134) == 0) {
        mapMap->parts_event = 1;
    } else {
        return 0;
    }
    mapNowFuncPoint = mapMap->func_point.AddFromReserve(6);
    return mapNowFuncPoint != 0;
}
int cfgFUNC_EVENT_DATA(SPI_STACK *stack, int argc) {
    char *modeName;
    if (mapNowFuncPoint == 0) {
        return 0;
    }
    mapNowFuncPoint->event.unk_28 = spiGetStackInt(stack++);
    if (argc > 1) {
        modeName = spiGetStackString(stack);
        mapNowFuncPoint->event.event_no = 0;
        if (modeName != NULL) {
            if (strcmp(modeName, at_1436) == 0) {
                mapNowFuncPoint->event.flag = 1;
            } else if (strcmp(modeName, at_1437) == 0) {
                mapNowFuncPoint->event.flag = 2;
            } else if (strcmp(modeName, at_1438) == 0) {
                mapNowFuncPoint->event.flag = 2;
                mapNowFuncPoint->event.event_no = 1;
            } else if (strcmp(modeName, at_1439) == 0) {
                mapNowFuncPoint->event.flag = 4;
                mapNowFuncPoint->event.event_no = 1;
            } else if (strcmp(modeName, at_1133) == 0) {
                mapNowFuncPoint->event.flag = 2;
                mapNowFuncPoint->event.event_no = 2;
            } else {
                return 0;
            }
        }
    }
    return 1;
}
int cfgFUNC_DATA_END(SPI_STACK *stack, int argc) {
    mapNowFuncPoint = 0;
    return 1;
}
int cfgWATER_SURFACE_NUM(SPI_STACK *stack, int argc) {
    int i;

    mapMap->water_surface_num = spiGetStackInt(stack);
    if (mapMap->water_surface_num > 0) {
        mapMap->water_surface = (CWaterFrame **)operator new[](
            mapMap->water_surface_num * 4,
            (u_long128 *)mapStack->Alloc(algn16_size(mapMap->water_surface_num * 4) + 2));
        if (mapMap->water_surface == NULL) {
            mapMap->water_surface_num = 0;
        }
        for (i = 0; i < mapMap->water_surface_num; i++) {
            mapMap->water_surface[i] = NULL;
        }
    }
    return 1;
}
s32 cfgWATER_SURFACE_START(SPI_STACK *stack, int argc) {
    return 1;
}
int cfgWATER_VERTEX(SPI_STACK *stack, int argc) {
    float corner0[4];
    float corner1[4];
    int countX = spiGetStackInt(stack++);
    int countZ = spiGetStackInt(stack++);
    spiGetStackVector(corner0, stack);
    spiGetStackVector(corner1, stack + 3);
    corner1[3] = 1.0f;
    corner0[3] = 1.0f;
    cfgWater = CreateWaterFrame(countX, countZ, corner0, corner1, mapStack);
    return 1;
}
int cfgWATER_POS(SPI_STACK *stack, int argc) {
    float pos[4];

    if (cfgWater == NULL) {
        return 0;
    }
    spiGetStackVector(pos, stack);
    ((mgCFrame *)cfgWater)->SetPosition(pos);
    return 1;
}
int cfgWATER_PARAM(SPI_STACK *stack, int argc) {
    float first = spiGetStackFloat(stack++);
    float second = spiGetStackFloat(stack++);
    float third = spiGetStackFloat(stack++);
    float fourth = spiGetStackFloat(stack);
    cfgWater->SetParam(first, second, third, fourth);
    return 1;
}
s32 cfgWATER_SHAKE(SPI_STACK *stack, int argc) {
    return 1;
}
int cfgWATER_SURFACE_END(SPI_STACK *stack, int argc) {
    if (WaterIndex >= mapMap->water_surface_num) {
        return 0;
    }
    mapMap->water_surface[WaterIndex] = cfgWater;
    cfgWater = NULL;
    WaterIndex++;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapload", cfgWATER_DRAW_NUM__FP9SPI_STACKi);
CMapWater::CMapWater() {}
int cfgWATER_DRAW(SPI_STACK *stack, int argc) {
    CMapWater *slot;
    char *name;
    float vertices[4];
    int surface;
    int i;

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
        if (*(s8 *)name != 0) {
            if (strncmp(name, at_1544, 7) == 0) {
                slot->follow[0] = ((s8 *)name)[7] - '0';
                slot->follow[1] = ((s8 *)name)[8] - '0';
                slot->follow[2] = ((s8 *)name)[9] - '0';
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
void CMap::LoadCfgFile(char *script, int length, mgCMemory *memory) {

    CScriptInterpreter interpreter;
    mapMap = this;
    mapStack = memory;
    ReserveFuncFlag = 0;
    WaterIndex = 0;
    cfgWater = NULL;
    interpreter.SetTag(cfg_tag);
    interpreter.SetScript(script, length);
    interpreter.Run();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_438__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", map_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", cfg_tag__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_611__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_612__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_613__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_614__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_615__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_616__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_617__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_618__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_619__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_620__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_621__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_622__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_623__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_624__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_625__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_626__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_627__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_628__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_629__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_630__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_631__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_632__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_633__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_634__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_635__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_636__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_637__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_638__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_639__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_640__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_641__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_642__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_643__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_644__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_645__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_646__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_647__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_648__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_649__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_650__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_651__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_652__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_653__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_654__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_655__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_656__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_657__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_658__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_659__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_660__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_661__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_662__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1064__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1128__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1129__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1130__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1131__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1132__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1133__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1134__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1135__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1136__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1278__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1279__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1280__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1281__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1282__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1283__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1284__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1370__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1371__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1372__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1373__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1374__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1375__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1376__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1377__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1378__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1379__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1380__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1436__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1437__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1438__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1439__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", at_1544__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", __vt__17CList_9CMapPiece___DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapload", __vt__17CList_9CMapParts___DATA);

INCLUDE_BSS(mapFarDist, 0x4);
INCLUDE_BSS(mapFarAlpha, 0x4);
INCLUDE_BSS(mapShow, 0x4);
INCLUDE_BSS(mapCameraInfoIdx, 0x4);
INCLUDE_BSS(mapCameraRectIdx, 0x4);
INCLUDE_BSS(mapFuncPointIdx, 0x4);
INCLUDE_BSS(mapNowFuncPoint, 0x4);
INCLUDE_BSS(mapAddMode, 0x4);
INCLUDE_BSS(ReserveFuncFlag, 0x4);
INCLUDE_BSS(WaterIndex, 0x4);
INCLUDE_BSS(cfgWater, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(mapPlacePartsName, 0x100);
INCLUDE_BSS(mapMapPartsName, 0x100);
INCLUDE_BSS(mapMapPartsGroupName, 0x100);
INCLUDE_BSS(mapPos, 0x10);
INCLUDE_BSS(mapRot, 0x10);
INCLUDE_BSS(mapScale, 0x10);
