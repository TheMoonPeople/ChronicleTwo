#include "scriptinterpreter.hpp"
#include "common.h"
#include "mapsky.hpp"
#include <cstring>

extern MAP_SKY_INFO * skyInfo;
extern int skyAnmNum;
extern int skybAnmNum;
extern SPI_TAG_PARAM tag__2[];
void LoadSkyPack(MAP_SKY_INFO *info, char *script, s32 size);
s32 CheckSkyID(s32 sky_id);
s32 _SKY_IMG(SPI_STACK *stack, s32 argCount);
s32 _SKY_MDS(SPI_STACK *stack, s32 argCount);
s32 _SUN_MDS(SPI_STACK *stack, s32 argCount);
s32 _SKYB_MDS(SPI_STACK *stack, s32 argCount);
s32 _SKY_BG(SPI_STACK *stack, s32 argCount);

// Code (.text)
void CMapSky::Initialize(void) {
    for (int band = 0; band < 4; band++) {
        sky[band] = NULL;
        skyb[band] = NULL;
        sun[band] = NULL;
        skyb_rot[band] = 0.0f;
        sky_rot[band] = 0.0f;
        skyb_rot_speed[band] = 0.0f;
        sky_rot_speed[band] = 0.0f;
        tex_block[band] = -1;
    }
    for (int frame = 0; frame < 16; frame += 8) {
        anime[frame + 0].frame = NULL;
        anime[frame + 0].speed = 0.0f;
        anime[frame + 1].frame = NULL;
        anime[frame + 1].speed = 0.0f;
        anime[frame + 2].frame = NULL;
        anime[frame + 2].speed = 0.0f;
        anime[frame + 3].frame = NULL;
        anime[frame + 3].speed = 0.0f;
        anime[frame + 4].frame = NULL;
        anime[frame + 4].speed = 0.0f;
        anime[frame + 5].frame = NULL;
        anime[frame + 5].speed = 0.0f;
        anime[frame + 6].frame = NULL;
        anime[frame + 6].speed = 0.0f;
        anime[frame + 7].frame = NULL;
        anime[frame + 7].speed = 0.0f;
    }
    bg = NULL;
    bg_visual = NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapsky", DrawSkyBack__7CMapSkyFPfPfPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapsky", DrawSky__7CMapSkyFPfPfPfiPfPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapsky", LoadPack__7CMapSkyFPUiiP9mgCMemory);
void LoadSkyPack(MAP_SKY_INFO *info, char *script, s32 size) {
    skyInfo = info;
    skyAnmNum = 0;
    skybAnmNum = 0;
    if (script == 0 || size == 0) {
        return;
    }
    CScriptInterpreter interpreter;
    interpreter.SetTag(tag__2);
    interpreter.SetScript(script, size);
    interpreter.Run();
}

/**
 *
 * Checks whether a sky time band index is in range.
 *
 */
s32 CheckSkyID(s32 sky_id) {
    s32 valid;
    if (sky_id < 0 || sky_id >= 4) valid = 0; else valid = 1;
    return valid;
}
s32 _SKY_IMG(SPI_STACK *stack, s32 argCount) {
    s32 skyId = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(skyId)) {
        return 0;
    }
    name = spiGetStackString(stack);
    if (name != 0) {
        strcpy(skyInfo->img_name[skyId], name);
    }
    return 1;
}
s32 _SKY_MDS(SPI_STACK *stack, s32 argCount) {
    s32 skyId = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(skyId)) {
        return 0;
    }
    name = spiGetStackString(stack++);
    if (name != 0) {
        strcpy(skyInfo->sky_mds_name[skyId], name);
    }
    skyInfo->sky_rot_speed[skyId] = spiGetStackFloat(stack) * 3.14159265358979323846f / 180.0f;
    return 1;
}
s32 _SUN_MDS(SPI_STACK *stack, s32 argCount) {
    s32 skyId = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(skyId)) {
        return 0;
    }
    name = spiGetStackString(stack);
    if (name != 0) {
        strcpy(skyInfo->sun_mds_name[skyId], name);
    }
    return 1;
}
s32 _SKYB_MDS(SPI_STACK *stack, s32 argCount) {
    s32 skyId = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(skyId)) {
        return 0;
    }
    name = spiGetStackString(stack++);
    if (name != 0) {
        strcpy(skyInfo->skyb_mds_name[skyId], name);
    }
    skyInfo->skyb_rot_speed[skyId] = spiGetStackFloat(stack) * 3.14159265358979323846f / 180.0f;
    return 1;
}
s32 _SKY_BG(SPI_STACK *stack, s32 argCount) {
    char *name;

    name = spiGetStackString(stack);
    if (name != 0) {
        strcpy(skyInfo->bg_mds_name, name);
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapsky", _SKY_ANIME__FP9SPI_STACKi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapsky", _SKYB_ANIME__FP9SPI_STACKi);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_387__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", tag__2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_386__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_457__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_462__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_463__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_464__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_465__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_466__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_467__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_468__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(skyInfo, 0x4);
INCLUDE_BSS(skyAnmNum, 0x4);
INCLUDE_BSS(skybAnmNum, 0x4);
