#include "common.h"
#include "mw_runtime.h"

#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstring>

#include "mapinfo.hpp"
#include "mapload.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"

static int mapIMG(SPI_STACK *stack, int argument_count);
static int mapPCP(SPI_STACK *stack, int argument_count);
static int mapACTIVE_LIGHT_SET(SPI_STACK *stack, int argument_count);
static int mapLIGHT_SET(SPI_STACK *stack, int argument_count);
static int mapFOV(SPI_STACK *stack, int argument_count);
static int mapBGCOLOR(SPI_STACK *stack, int argument_count);
static int mapBGCOLOR2(SPI_STACK *stack, int argument_count);
static int mapAMBIENT(SPI_STACK *stack, int argument_count);
static int mapLIGHT(SPI_STACK *stack, int argument_count);
static int mapPLIGHT(SPI_STACK *stack, int argument_count);
static int mapFOG_ENABLE(SPI_STACK *stack, int argument_count);
static int mapFOG(SPI_STACK *stack, int argument_count);
static int mapLIGHT_SET_END(SPI_STACK *stack, int argument_count);
static int mapFLOOR(SPI_STACK *stack, int argument_count);
static int mapCHARA_POS(SPI_STACK *stack, int argument_count);
static int mapTIME_FLAG(SPI_STACK *stack, int argument_count);
static int mapTIME_LIGHT_NUM(SPI_STACK *stack, int argument_count);
static int mapDEF_FOOT(SPI_STACK *stack, int argument_count);
static int mapSKY_INFO(SPI_STACK *stack, int argument_count);
static int mapLENS_FLARE(SPI_STACK *stack, int argument_count);
static int mapTIME_CFADE(SPI_STACK *stack, int argument_count);
static int mapALL_SCISSOR(SPI_STACK *stack, int argument_count);
static int mapCHARA_LIGHT_ADJUST(SPI_STACK *stack, int argument_count);
static int amapIMG(SPI_STACK *stack, int argument_count);
static int amapPCP(SPI_STACK *stack, int argument_count);

/**
 *
 * Tags of a map's configuration script and the routines that read them.
 *
 */
// Initialised data (.data)
static SPI_TAG_PARAM mapinfo_tag[] = {
    {"IMG",                mapIMG               },
    {"PCP",                mapPCP               },
    {"ACTIVE_LIGHT_SET",   mapACTIVE_LIGHT_SET  },
    {"LIGHT_SET",          mapLIGHT_SET         },
    {"FOV",                mapFOV               },
    {"BGCOLOR",            mapBGCOLOR           },
    {"BGCOLOR2",           mapBGCOLOR2          },
    {"AMBIENT",            mapAMBIENT           },
    {"LIGHT",              mapLIGHT             },
    {"PLIGHT",             mapPLIGHT            },
    {"FOG_ENABLE",         mapFOG_ENABLE        },
    {"FOG",                mapFOG               },
    {"LIGHT_SET_END",      mapLIGHT_SET_END     },
    {"FLOOR",              mapFLOOR             },
    {"CHARA_POS",          mapCHARA_POS         },
    {"TIME_FLAG",          mapTIME_FLAG         },
    {"TIME_LIGHT_NUM",     mapTIME_LIGHT_NUM    },
    {"DEF_FOOT",           mapDEF_FOOT          },
    {"SKY_INFO",           mapSKY_INFO          },
    {"LENS_FLARE",         mapLENS_FLARE        },
    {"TIME_CFADE",         mapTIME_CFADE        },
    {"ALL_SCISSOR",        mapALL_SCISSOR       },
    {"CHARA_LIGHT_ADJUST", mapCHARA_LIGHT_ADJUST},
    {NULL,                 NULL                 },
};

/**
 *
 * Tags of a map's additional configuration script and the routines that read them.
 *
 */
static SPI_TAG_PARAM add_mapinfo_tag[] = {
    {"IMG", amapIMG},
    {"PCP", amapPCP},
    {NULL,  NULL   },
};

/**
 *
 * Map settings being filled in by the running configuration script.
 *
 */
// Small uninitialised data (.sbss)
static CMapInfo *MapInfo;

/**
 *
 * Memory that the copies of the script's names are taken from.
 *
 */
static mgCMemory *MapInfoStack;

/**
 *
 * Index of the next texture pack name the configuration script gives.
 *
 */
static int now_img_num;

/**
 *
 * Index of the next model pack name the configuration script gives.
 *
 */
static int now_pcp_num;

/**
 *
 * Lighting set that the configuration script's lighting tags fill in, or null outside a set.
 *
 */
static CMapLightingInfo *LightingInfo;

// Code (.text)
void CCameraInfo::Initialize() {
    int i;
    int j;
    int k;

    pos_num = 0;

    for (i = 0; i < 8; i++) {
        mgZeroVectorW(pos[i]);
    }

    rect_num = 4;

    for (j = 0; j < rect_num; j++) {
        rect[j] = NULL;
    }

    draw_info_num = 4;

    for (k = 0; k < draw_info_num; k++) {
        draw_info[k].unk_4 = 0;
        draw_info[k].group_no = -1;
    }
}

CCameraDrawInfo *CCameraInfo::GetDrawInfo(int index) {
    if (index < 0 || index >= draw_info_num) {
        return NULL;
    }

    return &draw_info[index];
}

void CMapInfo::Initialize() {
    memset(this, 0, sizeof(CMapInfo));
    time_light_num = 4;
    fixed_time = 12.0f;
    lens_flare = 1;
}

char *CMapInfo::GetImgName(int index) {
    if (index < 0 || index >= img_num) {
        return NULL;
    }

    return img_name[index];
}

char *CMapInfo::GetPCPName(int index) {
    if (index < 0 || index >= pcp_num) {
        return NULL;
    }

    return pcp_name[index];
}

char *CMapInfo::GetMapFile(int *size) {
    *size = map_file_size;
    return map_file;
}

char *CMapInfo::GetAddMapFile(int *size) {
    *size = add_map_file_size;
    return add_map_file;
}

CMapLightingInfo *CMapInfo::GetLightingInfo(int index) {
    if (index < 0 || index >= lighting_info_num) {
        return NULL;
    }

    return &lighting_info[index];
}

/**
 *
 * Adds a texture pack to the map, keeping a copy of its name.
 * Reads the IMG tag: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 *
 */
static int mapIMG(SPI_STACK *stack, int argument_count) {
    char *name;
    char *copy;
    u32   size;
    u32   blocks;

    if (now_img_num >= MapInfo->img_num || argument_count <= 0) {
        return 0;
    }

    name = spiGetStackString(stack);

    if (name == NULL) {
        return 0;
    }

    size = strlen(name) + 1;

    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }

    copy = (char *) MapInfoStack->Alloc(blocks);
    strcpy(copy, name);
    MapInfo->img_name[now_img_num] = copy;
    now_img_num++;
    return 1;
}

/**
 *
 * Adds a model pack to the map, keeping a copy of its name.
 * Reads the PCP tag: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 *
 */
static int mapPCP(SPI_STACK *stack, int argument_count) {
    char *name;
    char *copy;
    u32   size;
    u32   blocks;

    if (now_pcp_num >= MapInfo->pcp_num || argument_count <= 0) {
        return 0;
    }

    name = spiGetStackString(stack);

    if (name == NULL) {
        return 0;
    }

    size = strlen(name) + 1;

    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }

    copy = (char *) MapInfoStack->Alloc(blocks);
    strcpy(copy, name);
    MapInfo->pcp_name[now_pcp_num] = copy;
    now_pcp_num++;
    return 1;
}

/**
 *
 * Chooses the lighting set used when lighting does not follow the time of day.
 * Reads the ACTIVE_LIGHT_SET tag: the set's index.
 * Always gives 1.
 *
 */
static int mapACTIVE_LIGHT_SET(SPI_STACK *stack, int argument_count) {
    MapInfo->active_light_no = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Starts the lighting set that the following lighting tags fill in.
 * Reads the LIGHT_SET tag: the set's index.
 * Gives 1 when the index names a set, 0 otherwise.
 *
 */
static int mapLIGHT_SET(SPI_STACK *stack, int argument_count) {
    LightingInfo = MapInfo->GetLightingInfo(spiGetStackInt(stack));
    return LightingInfo != NULL;
}

/**
 *
 * Sets the projection of the current lighting set to a horizontal field of view of 52 degrees.
 * Reads the FOV tag; its arguments are not used.
 * Gives 1 inside a lighting set, 0 otherwise.
 *
 */
static int mapFOV(SPI_STACK *stack, int argument_count) {
    if (LightingInfo == NULL) {
        return 0;
    }

    LightingInfo->projection = 400.0f;
    LightingInfo->projection = (mgScreenWidth / 2.0f) / tanf(0.45378563f);
    return 1;
}

/**
 *
 * Sets the background colour of the current lighting set.
 * Reads the BGCOLOR tag: red, green and blue, 0 to 255.
 * Gives 1 inside a lighting set, 0 otherwise.
 *
 */
static int mapBGCOLOR(SPI_STACK *stack, int argument_count) {
    if (LightingInfo == 0) {
        return 0;
    }

    LightingInfo->bg_color[0] = spiGetStackFloat(stack++);
    LightingInfo->bg_color[1] = spiGetStackFloat(stack++);
    LightingInfo->bg_color[2] = spiGetStackFloat(stack++);
    LightingInfo->bg_color[3] = 128.0f;
    return 1;
}

/**
 *
 * Sets the second background colour of the current lighting set; black takes the first one.
 * Reads the BGCOLOR2 tag: red, green and blue, 0 to 255.
 * Gives 1 inside a lighting set, 0 otherwise.
 *
 */
static int mapBGCOLOR2(SPI_STACK *stack, int argument_count) {
    if (LightingInfo == 0) {
        return 0;
    }

    LightingInfo->bg_color2[0] = spiGetStackFloat(stack++);
    LightingInfo->bg_color2[1] = spiGetStackFloat(stack++);
    LightingInfo->bg_color2[2] = spiGetStackFloat(stack++);
    LightingInfo->bg_color2[3] = 128.0f;

    if (0.0f == LightingInfo->bg_color2[0] && 0.0f == LightingInfo->bg_color2[1] &&
        0.0f == LightingInfo->bg_color2[2]) {
        *(u_long128 *) LightingInfo->bg_color2 = *(u_long128 *) LightingInfo->bg_color;
    }

    return 1;
}

/**
 *
 * Sets the ambient light colour of the current lighting set.
 * Reads the AMBIENT tag: red, green and blue, 0 to 255.
 * Gives 1 inside a lighting set, 0 otherwise.
 *
 */
static int mapAMBIENT(SPI_STACK *stack, int argument_count) {
    if (LightingInfo == 0) {
        return 0;
    }

    LightingInfo->ambient[0] = spiGetStackFloat(stack++);
    LightingInfo->ambient[1] = spiGetStackFloat(stack++);
    LightingInfo->ambient[2] = spiGetStackFloat(stack++);
    LightingInfo->ambient[3] = 128.0f;
    return 1;
}

/**
 *
 * Sets the direction and, optionally, the colour of one directional light of the current lighting set.
 * Reads the LIGHT tag: light index (0 to 3), direction x, y, z, then optionally red, green, blue.
 * Gives 1 on success, 0 outside a lighting set, for a bad index or too few arguments.
 *
 */
static int mapLIGHT(SPI_STACK *stack, int argument_count) {
    float vec[4];
    int   index;

    if (LightingInfo == 0) {
        return 0;
    }

    index = spiGetStackInt(stack++);

    if (index < 0 || index > 3) {
        return 0;
    }

    if (argument_count < 4) {
        return 0;
    }

    spiGetStackVector(vec, stack);
    sceVu0Normalize(vec, vec);
    LightingInfo->light_dir[0][index] = vec[0];
    LightingInfo->light_dir[1][index] = vec[1];
    LightingInfo->light_dir[2][index] = vec[2];

    if (argument_count >= 7) {
        spiGetStackVector(vec, stack + 3);
        vec[3] = 0.0f;
        sceVu0CopyVector(LightingInfo->light_color[index], vec);
    }

    return 1;
}

/**
 *
 * Sets one point light of the current lighting set and switches point lights on.
 * Reads the PLIGHT tag: light index (0 to 3), power, position x, y, z, colour red, green, blue.
 * Gives 1 on success, 0 outside a lighting set or for a bad index.
 *
 */
static int mapPLIGHT(SPI_STACK *stack, int argument_count) {
    int index;

    if (LightingInfo == NULL) {
        return 0;
    }

    index = spiGetStackInt(stack++);

    if (index < 0 || index > 3) {
        return 0;
    }

    LightingInfo->point_light[index].power = spiGetStackFloat(stack++);
    spiGetStackVector(LightingInfo->point_light[index].pos, stack);
    LightingInfo->point_light[index].pos[3] = 1.0f;
    spiGetStackVector(LightingInfo->point_light[index].color, stack + 3);
    LightingInfo->point_light[index].color[3] = 0.0f;
    LightingInfo->plight_enable = 1;
    return 1;
}

/**
 *
 * Switches the fog of the current lighting set on or off.
 * Reads the FOG_ENABLE tag: non-zero for on.
 * Gives 1 inside a lighting set, 0 otherwise.
 *
 */
static int mapFOG_ENABLE(SPI_STACK *stack, int argument_count) {
    if (LightingInfo == NULL) {
        return 0;
    }

    LightingInfo->fog_enable = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the fog of the current lighting set; colour and values left out take white, 0 and 255.
 * Reads the FOG tag: near and far distances, optionally red, green, blue, then optionally two fog values.
 * Gives 1 inside a lighting set, 0 otherwise.
 *
 */
static int mapFOG(SPI_STACK *stack, int argument_count) {
    if (LightingInfo == 0) {
        return 0;
    }

    LightingInfo->fog.r = 255;
    LightingInfo->fog.g = 255;
    LightingInfo->fog.b = 255;
    LightingInfo->fog.far_value = 0.0f;
    LightingInfo->fog.near_value = 255.0f;
    LightingInfo->fog.near_dist = spiGetStackFloat(stack++);
    LightingInfo->fog.far_dist = spiGetStackFloat(stack++);

    if (argument_count > 2) {
        LightingInfo->fog.r = spiGetStackInt(stack++);
        LightingInfo->fog.g = spiGetStackInt(stack++);
        LightingInfo->fog.b = spiGetStackInt(stack++);
    }

    if (argument_count > 5) {
        LightingInfo->fog.far_value = spiGetStackFloat(stack++);
        LightingInfo->fog.near_value = spiGetStackFloat(stack);
    }

    return 1;
}

/**
 *
 * Ends the lighting set that the lighting tags fill in.
 * Reads the LIGHT_SET_END tag, which has no arguments.
 * Always gives 1.
 *
 */
static int mapLIGHT_SET_END(SPI_STACK *stack, int argument_count) {
    LightingInfo = NULL;
    return 1;
}

/**
 *
 * Sets the map's FLOOR value.
 * Reads the FLOOR tag: one number.
 * Always gives 1.
 *
 */
static int mapFLOOR(SPI_STACK *stack, int argument_count) {
    MapInfo->floor = spiGetStackFloat(stack);
    return 1;
}

/**
 *
 * Sets the map's character position.
 * Reads the CHARA_POS tag: x, y, z.
 * Always gives 1.
 *
 */
static int mapCHARA_POS(SPI_STACK *stack, int argument_count) {
    spiGetStackVector(MapInfo->chara_pos, stack);
    return 1;
}

/**
 *
 * Sets how the map follows the time of day.
 * Reads the TIME_FLAG tag: follow the clock, blend lighting, then optionally the fixed hour and its switch.
 * Always gives 1.
 *
 */
static int mapTIME_FLAG(SPI_STACK *stack, int argument_count) {
    MapInfo->time_enable = spiGetStackInt(stack++);
    MapInfo->time_light_blend = spiGetStackInt(stack++);

    if (argument_count >= 3) {
        MapInfo->fixed_time = spiGetStackFloat(stack++);
    }

    if (argument_count >= 4) {
        MapInfo->fixed_time_enable = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Sets the number of lighting sets that divide the day.
 * Reads the TIME_LIGHT_NUM tag: the number of sets.
 * Always gives 1.
 *
 */
static int mapTIME_LIGHT_NUM(SPI_STACK *stack, int argument_count) {
    MapInfo->time_light_num = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the map's DEF_FOOT value.
 * Reads the DEF_FOOT tag: one integer.
 * Always gives 1.
 *
 */
static int mapDEF_FOOT(SPI_STACK *stack, int argument_count) {
    MapInfo->def_foot = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the map's sky settings.
 * Reads the SKY_INFO tag: an integer, a number, then optionally the sun path's angle in degrees.
 * Always gives 1.
 *
 */
static int mapSKY_INFO(SPI_STACK *stack, int argument_count) {
    MapInfo->sky_info = spiGetStackInt(stack++);
    MapInfo->sky_height = spiGetStackFloat(stack++);

    if (argument_count >= 3) {
        MapInfo->sun_angle = mgAngleLimit(3.1415927f * spiGetStackFloat(stack) / 180.0f);
    }

    return 1;
}

/**
 *
 * Switches the map's lens flare on or off.
 * Reads the LENS_FLARE tag: non-zero for on.
 * Always gives 1.
 *
 */
static int mapLENS_FLARE(SPI_STACK *stack, int argument_count) {
    MapInfo->lens_flare = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the map's TIME_CFADE value.
 * Reads the TIME_CFADE tag: one integer.
 * Always gives 1.
 *
 */
static int mapTIME_CFADE(SPI_STACK *stack, int argument_count) {
    MapInfo->time_cfade = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the value passed on when the map's model packs are loaded.
 * Reads the ALL_SCISSOR tag: one integer.
 * Always gives 1.
 *
 */
static int mapALL_SCISSOR(SPI_STACK *stack, int argument_count) {
    MapInfo->all_scissor = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the map's character lighting adjustment.
 * Reads the CHARA_LIGHT_ADJUST tag: an integer and three numbers.
 * Always gives 1.
 *
 */
static int mapCHARA_LIGHT_ADJUST(SPI_STACK *stack, int argument_count) {
    MapInfo->chara_light_adjust = spiGetStackInt(stack++);
    MapInfo->chara_light_adjust_value[0] = spiGetStackFloat(stack++);
    MapInfo->chara_light_adjust_value[1] = spiGetStackFloat(stack++);
    MapInfo->chara_light_adjust_value[2] = spiGetStackFloat(stack);
    return 1;
}

void CMapInfo::LoadMapInfo(char *script, int script_size, mgCMemory *stack) {
    int i;

    MapInfoStack = stack;
    MapInfo = this;
    now_img_num = 0;
    now_pcp_num = 0;
    LightingInfo = NULL;

    CScriptInterpreter interpreter;
    interpreter.SetTag(mapinfo_tag);
    interpreter.SetScript(script, script_size);

    img_num = 16;

    for (i = 0; i < img_num; i++) {
        img_name[i] = NULL;
    }

    pcp_num = 16;

    // The model pack names are cleared up to the texture pack capacity.
    for (i = 0; i < img_num; i++) {
        pcp_name[i] = NULL;
    }

    u32 qwc;

    if (script_size & 0xF) {
        qwc = ((u32) script_size >> 4) + 1;
    } else {
        qwc = (u32) script_size >> 4;
    }

    map_file = (char *) stack->Alloc(qwc);
    memcpy(map_file, script, script_size);
    map_file_size = script_size;

    lighting_info_num = 16;
    int count = lighting_info_num;
    u32 bytes = count * sizeof(CMapLightingInfo);
    u32 blocks;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    lighting_info = new (stack->Alloc(blocks + 2)) CMapLightingInfo[count];

    interpreter.SetScript(script, script_size);
    interpreter.Run();
}

// Defined in mapload.hpp.
/**
 *
 * Adds a texture pack to the map in its first free entry, keeping a copy of its name.
 * Reads the IMG tag of an additional configuration script: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 *
 */
static int amapIMG(SPI_STACK *stack, int argument_count) {
    char  *name = spiGetStackString(stack);
    char **entry = NULL;

    if (name == NULL) {
        return 0;
    }

    for (int i = 0; i < 16; i++) {
        if (MapInfo->img_name[i] == NULL) {
            entry = &MapInfo->img_name[i];
            break;
        }
    }

    if (entry == NULL) {
        return 0;
    }

    u32 size = strlen(name) + 1;
    u32 qwc;

    if (size & 0xF) {
        qwc = (size >> 4) + 1;
    } else {
        qwc = size >> 4;
    }

    char *copy = (char *) MapInfoStack->Alloc(qwc);
    strcpy(copy, name);
    *entry = copy;
    return 1;
}

/**
 *
 * Adds a model pack to the map in its first free entry, keeping a copy of its name.
 * Reads the PCP tag of an additional configuration script: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 *
 */
static int amapPCP(SPI_STACK *stack, int argument_count) {
    char  *name = spiGetStackString(stack);
    char **entry = NULL;

    if (name == NULL) {
        return 0;
    }

    for (int i = 0; i < 16; i++) {
        if (MapInfo->pcp_name[i] == NULL) {
            entry = &MapInfo->pcp_name[i];
            break;
        }
    }

    if (entry == NULL) {
        return 0;
    }

    u32 size = strlen(name) + 1;
    u32 qwc;

    if (size & 0xF) {
        qwc = (size >> 4) + 1;
    } else {
        qwc = size >> 4;
    }

    char *copy = (char *) MapInfoStack->Alloc(qwc);
    strcpy(copy, name);
    *entry = copy;
    return 1;
}

void CMapInfo::AddMapInfo(char *script, int script_size, mgCMemory *stack) {
    MapInfoStack = stack;
    MapInfo = this;

    CScriptInterpreter interpreter;
    interpreter.SetTag(add_mapinfo_tag);
    interpreter.SetScript(script, script_size);

    u32 qwc;

    if (script_size & 0xF) {
        qwc = ((u32) script_size >> 4) + 1;
    } else {
        qwc = (u32) script_size >> 4;
    }

    add_map_file = (char *) stack->Alloc(qwc);
    memcpy(add_map_file, script, script_size);
    add_map_file_size = script_size;

    interpreter.SetScript(script, script_size);
    interpreter.Run();
}

int CMapInfo::OutputLightData(char *buff) {
    char *cursor = buff;
    int   set;
    int   light;

    struct {
        float x, y, z, w;
    } color;

    struct {
        int x, y, z, w;
    } ambient;

    cursor += sprintf(cursor, "MPL_ACTIVE_LIGHT_SET %d;\n", active_light_no);

    for (set = 0; set < lighting_info_num; set++) {
        CMapLightingInfo *info = &lighting_info[set];
        cursor += sprintf(cursor, "MPL_LIGHT_SET %d;\n", set);
        cursor += sprintf(cursor, " MPL_FOV 52;\n");
        cursor += sprintf(cursor, " MPL_BGCOLOR %d,%d,%d;\n", (int) info->bg_color[0], (int) info->bg_color[1], (int) info->bg_color[2]);
        cursor += sprintf(cursor, " MPL_BGCOLOR2 %d,%d,%d;\n", (int) info->bg_color2[0], (int) info->bg_color2[1], (int) info->bg_color2[2]);
        ambient.x = fptosi(info->ambient[0]);
        int  converted_y = fptosi(info->ambient[1]);
        int *ambient_y = &ambient.y;
        *ambient_y = converted_y;
        int  converted_z = fptosi(info->ambient[2]);
        int *ambient_z = &ambient.z;
        *ambient_z = converted_z;
        cursor += sprintf(cursor, " MPL_AMBIENT %d,%d,%d;\n", ambient.x, *ambient_y, *ambient_z);
        light = 0;

        do {
            float *color_y = &color.y;
            float *color_z = &color.z;
            color.x = info->light_color[light][0];
            *color_y = info->light_color[light][1];
            *color_z = info->light_color[light][2];
            cursor += sprintf(cursor, " MPL_LIGHT %d,%f,%f,%f,%d,%d,%d,1;\n", light, info->light_dir[0][light], info->light_dir[1][light], info->light_dir[2][light], (int) color.x, (int) *color_y, (int) *color_z);
            light++;
        } while (light < 4);

        cursor += sprintf(cursor, " MPL_FOG_ENABLE %d;\n", info->fog_enable);
        cursor += sprintf(cursor, " MPL_FOG %f,%f,%d,%d,%d,%d,%d;\n", info->fog.near_dist, info->fog.far_dist, info->fog.r, info->fog.g, info->fog.b, (int) info->fog.far_value, (int) info->fog.near_value);
        cursor += sprintf(cursor, "MPL_LIGHT_SET_END;\n");
    }

    return cursor - buff;
}
