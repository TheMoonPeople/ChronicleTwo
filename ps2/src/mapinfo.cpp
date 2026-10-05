#include "common.h"
#include "mapload.hpp"
#include "mapinfo.hpp"

#include <cmath>
#include <cstdio>
#include <cstring>
#include <libvu0.h>

#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"

extern "C" void __ct__18CScriptInterpreterFv(void *);

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

// mglib.hpp cannot be included beside mapload.hpp (both declare mgFOG_PARAM).
extern int mgScreenWidth;
extern "C" int fptosi(float);
extern char at_360[];
extern char at_361[];
extern char at_362[];
extern char at_363[];
extern char at_364[];
extern char at_365[];
extern char at_366[];
extern char at_367[];
extern char at_368[];
extern char at_369__3[];
extern char at_370__2[];
extern char at_371[];
extern char at_372[];
extern char at_373[];
extern char at_374[];
extern char at_375[];
extern char at_376[];
extern char at_377[];
extern char at_378[];
extern char at_379[];
extern char at_380[];
extern char at_381[];
extern char at_382__2[];
extern char at_704[];
extern char at_705[];
extern char at_706[];
extern char at_707[];
extern char at_708[];
extern char at_709[];
extern char at_710[];
extern char at_711[];
extern char at_712[];
extern char at_713__2[];


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
 * Tags of a map's configuration script and the routines that read them.
 */
// Initialised data (.data)
static SPI_TAG_PARAM mapinfo_tag[] = {
    { at_360, mapIMG },
    { at_361, mapPCP },
    { at_362, mapACTIVE_LIGHT_SET },
    { at_363, mapLIGHT_SET },
    { at_364, mapFOV },
    { at_365, mapBGCOLOR },
    { at_366, mapBGCOLOR2 },
    { at_367, mapAMBIENT },
    { at_368, mapLIGHT },
    { at_369__3, mapPLIGHT },
    { at_370__2, mapFOG_ENABLE },
    { at_371, mapFOG },
    { at_372, mapLIGHT_SET_END },
    { at_373, mapFLOOR },
    { at_374, mapCHARA_POS },
    { at_375, mapTIME_FLAG },
    { at_376, mapTIME_LIGHT_NUM },
    { at_377, mapDEF_FOOT },
    { at_378, mapSKY_INFO },
    { at_379, mapLENS_FLARE },
    { at_380, mapTIME_CFADE },
    { at_381, mapALL_SCISSOR },
    { at_382__2, mapCHARA_LIGHT_ADJUST },
    { NULL, NULL },
};

/**
 * Tags of a map's additional configuration script and the routines that read them.
 */
static SPI_TAG_PARAM add_mapinfo_tag[] = {
    { at_360, amapIMG },
    { at_361, amapPCP },
    { NULL, NULL },
};

/**
 * Map settings being filled in by the running configuration script.
 */
// Small uninitialised data (.sbss)
static CMapInfo *MapInfo;

/**
 * Memory that the copies of the script's names are taken from.
 */
static mgCMemory *MapInfoStack;

/**
 * Index of the next texture pack name the configuration script gives.
 */
static int now_img_num;

/**
 * Index of the next model pack name the configuration script gives.
 */
static int now_pcp_num;

/**
 * Lighting set that the configuration script's lighting tags fill in, or null outside a set.
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
 * Adds a texture pack to the map, keeping a copy of its name.
 * Reads the IMG tag: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 */
static int mapIMG(SPI_STACK *stack, int argument_count) {
    char *name;
    char *copy;
    u32 size;
    u32 blocks;

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
    copy = (char *)MapInfoStack->Alloc(blocks);
    strcpy(copy, name);
    MapInfo->img_name[now_img_num] = copy;
    now_img_num++;
    return 1;
}

/**
 * Adds a model pack to the map, keeping a copy of its name.
 * Reads the PCP tag: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 */
static int mapPCP(SPI_STACK *stack, int argument_count) {
    char *name;
    char *copy;
    u32 size;
    u32 blocks;

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
    copy = (char *)MapInfoStack->Alloc(blocks);
    strcpy(copy, name);
    MapInfo->pcp_name[now_pcp_num] = copy;
    now_pcp_num++;
    return 1;
}

/**
 * Chooses the lighting set used when lighting does not follow the time of day.
 * Reads the ACTIVE_LIGHT_SET tag: the set's index.
 * Always gives 1.
 */
static int mapACTIVE_LIGHT_SET(SPI_STACK *stack, int argument_count) {
    MapInfo->active_light_no = spiGetStackInt(stack);
    return 1;
}

/**
 * Starts the lighting set that the following lighting tags fill in.
 * Reads the LIGHT_SET tag: the set's index.
 * Gives 1 when the index names a set, 0 otherwise.
 */
static int mapLIGHT_SET(SPI_STACK *stack, int argument_count) {
    LightingInfo = MapInfo->GetLightingInfo(spiGetStackInt(stack));
    return LightingInfo != NULL;
}

/**
 * Sets the projection of the current lighting set to a horizontal field of view of 52 degrees.
 * Reads the FOV tag; its arguments are not used.
 * Gives 1 inside a lighting set, 0 otherwise.
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
 * Sets the background colour of the current lighting set.
 * Reads the BGCOLOR tag: red, green and blue, 0 to 255.
 * Gives 1 inside a lighting set, 0 otherwise.
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
 * Sets the second background colour of the current lighting set; black takes the first one.
 * Reads the BGCOLOR2 tag: red, green and blue, 0 to 255.
 * Gives 1 inside a lighting set, 0 otherwise.
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
        *(u_long128 *)LightingInfo->bg_color2 = *(u_long128 *)LightingInfo->bg_color;
    }
    return 1;
}

/**
 * Sets the ambient light colour of the current lighting set.
 * Reads the AMBIENT tag: red, green and blue, 0 to 255.
 * Gives 1 inside a lighting set, 0 otherwise.
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
 * Sets the direction and, optionally, the colour of one directional light of the current lighting set.
 * Reads the LIGHT tag: light index (0 to 3), direction x, y, z, then optionally red, green, blue.
 * Gives 1 on success, 0 outside a lighting set, for a bad index or too few arguments.
 */
static int mapLIGHT(SPI_STACK *stack, int argument_count) {
    float vec[4];
    int index;
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
 * Sets one point light of the current lighting set and switches point lights on.
 * Reads the PLIGHT tag: light index (0 to 3), power, position x, y, z, colour red, green, blue.
 * Gives 1 on success, 0 outside a lighting set or for a bad index.
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
 * Switches the fog of the current lighting set on or off.
 * Reads the FOG_ENABLE tag: non-zero for on.
 * Gives 1 inside a lighting set, 0 otherwise.
 */
static int mapFOG_ENABLE(SPI_STACK *stack, int argument_count) {
    if (LightingInfo == NULL) {
        return 0;
    }
    LightingInfo->fog_enable = spiGetStackInt(stack);
    return 1;
}

/**
 * Sets the fog of the current lighting set; colour and values left out take white, 0 and 255.
 * Reads the FOG tag: near and far distances, optionally red, green, blue, then optionally two fog values.
 * Gives 1 inside a lighting set, 0 otherwise.
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
 * Ends the lighting set that the lighting tags fill in.
 * Reads the LIGHT_SET_END tag, which has no arguments.
 * Always gives 1.
 */
static int mapLIGHT_SET_END(SPI_STACK *stack, int argument_count) {
    LightingInfo = NULL;
    return 1;
}

/**
 * Sets the map's FLOOR value.
 * Reads the FLOOR tag: one number.
 * Always gives 1.
 */
static int mapFLOOR(SPI_STACK *stack, int argument_count) {
    MapInfo->floor = spiGetStackFloat(stack);
    return 1;
}

/**
 * Sets the map's character position.
 * Reads the CHARA_POS tag: x, y, z.
 * Always gives 1.
 */
static int mapCHARA_POS(SPI_STACK *stack, int argument_count) {
    spiGetStackVector(MapInfo->chara_pos, stack);
    return 1;
}

/**
 * Sets how the map follows the time of day.
 * Reads the TIME_FLAG tag: follow the clock, blend lighting, then optionally the fixed hour and its switch.
 * Always gives 1.
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
 * Sets the number of lighting sets that divide the day.
 * Reads the TIME_LIGHT_NUM tag: the number of sets.
 * Always gives 1.
 */
static int mapTIME_LIGHT_NUM(SPI_STACK *stack, int argument_count) {
    MapInfo->time_light_num = spiGetStackInt(stack);
    return 1;
}

/**
 * Sets the map's DEF_FOOT value.
 * Reads the DEF_FOOT tag: one integer.
 * Always gives 1.
 */
static int mapDEF_FOOT(SPI_STACK *stack, int argument_count) {
    MapInfo->def_foot = spiGetStackInt(stack);
    return 1;
}

/**
 * Sets the map's sky settings.
 * Reads the SKY_INFO tag: an integer, a number, then optionally the sun path's angle in degrees.
 * Always gives 1.
 */
static int mapSKY_INFO(SPI_STACK *stack, int argument_count) {
    MapInfo->sky_info = spiGetStackInt(stack++);
    MapInfo->unk_dc = spiGetStackFloat(stack++);
    if (argument_count >= 3) {
        MapInfo->sun_angle = mgAngleLimit(3.1415927f * spiGetStackFloat(stack) / 180.0f);
    }
    return 1;
}

/**
 * Switches the map's lens flare on or off.
 * Reads the LENS_FLARE tag: non-zero for on.
 * Always gives 1.
 */
static int mapLENS_FLARE(SPI_STACK *stack, int argument_count) {
    MapInfo->lens_flare = spiGetStackInt(stack);
    return 1;
}

/**
 * Sets the map's TIME_CFADE value.
 * Reads the TIME_CFADE tag: one integer.
 * Always gives 1.
 */
static int mapTIME_CFADE(SPI_STACK *stack, int argument_count) {
    MapInfo->time_cfade = spiGetStackInt(stack);
    return 1;
}

/**
 * Sets the value passed on when the map's model packs are loaded.
 * Reads the ALL_SCISSOR tag: one integer.
 * Always gives 1.
 */
static int mapALL_SCISSOR(SPI_STACK *stack, int argument_count) {
    MapInfo->all_scissor = spiGetStackInt(stack);
    return 1;
}

/**
 * Sets the map's character lighting adjustment.
 * Reads the CHARA_LIGHT_ADJUST tag: an integer and three numbers.
 * Always gives 1.
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

    u8 interpreter[0xED0];
    __ct__18CScriptInterpreterFv(interpreter);
    ((CScriptInterpreter *)interpreter)->SetTag(mapinfo_tag);
    ((CScriptInterpreter *)interpreter)->SetScript(script, script_size);

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
        qwc = ((u32)script_size >> 4) + 1;
    } else {
        qwc = (u32)script_size >> 4;
    }
    map_file = (char *)stack->Alloc(qwc);
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

    ((CScriptInterpreter *)interpreter)->SetScript(script, script_size);
    ((CScriptInterpreter *)interpreter)->Run();
}

// Defined in mapload.hpp.
/**
 * Adds a texture pack to the map in its first free entry, keeping a copy of its name.
 * Reads the IMG tag of an additional configuration script: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 */
static int amapIMG(SPI_STACK *stack, int argument_count) {
    char *name = spiGetStackString(stack);
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
    char *copy = (char *)MapInfoStack->Alloc(qwc);
    strcpy(copy, name);
    *entry = copy;
    return 1;
}

/**
 * Adds a model pack to the map in its first free entry, keeping a copy of its name.
 * Reads the PCP tag of an additional configuration script: the pack's name.
 * Gives 1 on success, 0 when the list is full or the name is missing.
 */
static int amapPCP(SPI_STACK *stack, int argument_count) {
    char *name = spiGetStackString(stack);
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
    char *copy = (char *)MapInfoStack->Alloc(qwc);
    strcpy(copy, name);
    *entry = copy;
    return 1;
}

void CMapInfo::AddMapInfo(char *script, int script_size, mgCMemory *stack) {
    MapInfoStack = stack;
    MapInfo = this;

    u8 interpreter[0xED0];
    __ct__18CScriptInterpreterFv(interpreter);
    ((CScriptInterpreter *)interpreter)->SetTag(add_mapinfo_tag);
    ((CScriptInterpreter *)interpreter)->SetScript(script, script_size);

    u32 qwc;
    if (script_size & 0xF) {
        qwc = ((u32)script_size >> 4) + 1;
    } else {
        qwc = (u32)script_size >> 4;
    }
    add_map_file = (char *)stack->Alloc(qwc);
    memcpy(add_map_file, script, script_size);
    add_map_file_size = script_size;

    ((CScriptInterpreter *)interpreter)->SetScript(script, script_size);
    ((CScriptInterpreter *)interpreter)->Run();
}

int CMapInfo::OutputLightData(char *buff) {
    char *cursor = buff;
    int set;
    int offset;
    int light;
    struct { float x, y, z, w; } color;
    struct { int x, y, z, w; } ambient;

    cursor += sprintf(cursor, at_704, active_light_no);
    for (set = 0, offset = 0; set < lighting_info_num; offset += sizeof(CMapLightingInfo), set++) {
        CMapLightingInfo *info = (CMapLightingInfo *)((u8 *)lighting_info + offset);
        cursor += sprintf(cursor, at_705, set);
        cursor += sprintf(cursor, at_706);
        cursor += sprintf(cursor, at_707, (int)info->bg_color[0], (int)info->bg_color[1], (int)info->bg_color[2]);
        cursor += sprintf(cursor, at_708, (int)info->bg_color2[0], (int)info->bg_color2[1], (int)info->bg_color2[2]);
        ambient.x = fptosi(info->ambient[0]);
        int converted_y = fptosi(info->ambient[1]);
        int *ambient_y = &ambient.y;
        *ambient_y = converted_y;
        int converted_z = fptosi(info->ambient[2]);
        int *ambient_z = &ambient.z;
        *ambient_z = converted_z;
        cursor += sprintf(cursor, at_709, ambient.x, *ambient_y, *ambient_z);
        light = 0;
        int color_offset = 0;
        int direction_offset = 0;
        do {
            CMapLightingInfo *source = (CMapLightingInfo *)((u8 *)info + color_offset);
            float *color_y = &color.y;
            float *color_z = &color.z;
            color.x = source->light_color[0][0];
            *color_y = source->light_color[0][1];
            *color_z = source->light_color[0][2];
            CMapLightingInfo *direction = (CMapLightingInfo *)((u8 *)info + direction_offset);
            cursor += sprintf(cursor, at_710, light, direction->light_dir[0][0], direction->light_dir[1][0], direction->light_dir[2][0], (int)color.x, (int)*color_y, (int)*color_z);
            light++;
            color_offset += 16;
            direction_offset += 4;
        } while (light < 4);
        cursor += sprintf(cursor, at_711, info->fog_enable);
        cursor += sprintf(cursor, at_712, info->fog.near_dist, info->fog.far_dist, info->fog.r, info->fog.g, info->fog.b, (int)info->fog.far_value, (int)info->fog.near_value);
        cursor += sprintf(cursor, at_713__2);
    }
    return cursor - buff;
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_360__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_361__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_362__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_363__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_364__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_365__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_366__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_367__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_368__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_369__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_370__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_371__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_372__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_373__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_374__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_375__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_376__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_377__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_378__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_379__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_380__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_381__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_382__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_704__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_705__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_706__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_707__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_708__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_709__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_710__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_711__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_712__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapinfo", at_713__2__DATA);
