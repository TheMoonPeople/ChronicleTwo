#include "common.h"

#include <cstring>

#include "dataread.hpp"
#include "mapsky.hpp"
#include "mg_dataset.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"

/**
 *
 * Sky configuration currently being populated by script commands.
 *
 */
static MAP_SKY_INFO *skyInfo;

/**
 *
 * Number of sky-model animation entries read from the script.
 *
 */
static int skyAnmNum;

/**
 *
 * Number of background-sky animation entries read from the script.
 *
 */
static int skybAnmNum;

extern char at_386[];
static s32           CheckSkyID(s32 sky_id);
static s32           _SKY_IMG(SPI_STACK *stack, s32 arg_count);
static s32           _SKY_MDS(SPI_STACK *stack, s32 arg_count);
static s32           _SUN_MDS(SPI_STACK *stack, s32 arg_count);
static s32           _SKYB_MDS(SPI_STACK *stack, s32 arg_count);

static int  _SKY_BG(SPI_STACK *stack, int argument_count);
static int  _SKY_ANIME(SPI_STACK *stack, int argument_count);
static int  _SKYB_ANIME(SPI_STACK *stack, int argument_count);
static void LoadSkyPack(MAP_SKY_INFO *info, char *script, int size);

/**
 *
 * Sky configuration commands and their script callbacks.
 *
 */
static SPI_TAG_PARAM tag[8] = {
    {"SKY_IMG", _SKY_IMG},
    {"SKY_MDS", _SKY_MDS},
    {"SKY_ANIME", _SKY_ANIME},
    {"SUN_MDS", _SUN_MDS},
    {"SKYB_MDS", _SKYB_MDS},
    {"SKYB_ANIME", _SKYB_ANIME},
    {"SKY_BG", _SKY_BG},
    {NULL, NULL},
};

// Code (.text)
void CMapSky::Initialize() {
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

void CMapSky::DrawSkyBack(float *camera_pos, float *color1, float *color0) {
    if (bg == NULL) {
        return;
    }

    bg->SetPosition(camera_pos[0], camera_pos[1], camera_pos[2]);

    if (bg_visual != NULL) {
        int            color_count;
        sceVu0FVECTOR *colors = bg_visual->GetColor(&color_count);

        if (colors != NULL && color_count == 2) {
            sceVu0CopyVector(colors[1], color1);
            sceVu0CopyVector(colors[0], color0);
        }
    }

    bg->SetScale(1.0f, 1.0f, 1.0f);
    mgDrawDirect(bg);
    bg->SetScale(1.0f, -1.0f, 1.0f);
    mgDrawDirect(bg);
}
void CMapSky::DrawSky(float *camera_pos, float *sun_pos, float *moon_pos, int time_band,
                      float *lighting_ratio, float *sun_lighting_ratio) {
    float rotation[4];
    float ambient[4];
    float ambient_back[4];

    if (time_band < 0 || time_band >= 4) {
        return;
    }
    for (int i = 0; i < 16; i++) {
        AnimeFrame *entry = &anime[i];
        if (entry->frame != NULL) {
            entry->frame->GetRotation(rotation);
            rotation[1] = mgAngleLimit(rotation[1] + entry->speed);
            entry->frame->SetRotation(rotation);
        }
    }
    for (int i = 0; i < 4; i++) {
        sky_rot[i] = mgAngleLimit(sky_rot[i] + sky_rot_speed[i]);
        skyb_rot[i] = mgAngleLimit(skyb_rot[i] + skyb_rot_speed[i]);
    }
    mgCTextureManager *textures = &mgTexManager;
    mgGetAmbient(ambient);
    mgGetAmbient(ambient_back);
    mgCFrameAttr attr;
    for (int i = 0; i < 4; i++) {
        attr.obj_alpha = lighting_ratio[i];
        if (!(lighting_ratio[i] <= 0.0f) && skyb[i] != NULL) {
            textures->ReloadTexture(tex_block[i], (sceVif1Packet *)NULL);
            skyb[i]->SetScale(1.0f, 1.0f, 1.0f);
            skyb[i]->SetPosition(camera_pos[0], camera_pos[1], camera_pos[2]);
            skyb[i]->SetRotation(0.0f, skyb_rot[i], 0.0f);
            skyb[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);
            mgDrawDirect(skyb[i]);
            skyb[i]->SetScale(1.0f, -1.0f, 1.0f);
            mgDrawDirect(skyb[i]);
        }
    }
    if (lighting_ratio[2] <= 0.0f) {
        for (int i = 0; i < 4; i++) {
            attr.obj_alpha = sun_lighting_ratio[i];
            if (!(sun_lighting_ratio[i] <= 0.0f) && sun[i] != NULL) {
                textures->ReloadTexture(tex_block[i], (sceVif1Packet *)NULL);
                sun[i]->SetPosition(sun_pos);
                sun[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);
                if (!(sun_pos[1] <= camera_pos[1])) {
                    mgDrawDirect(sun[i]);
                    if (i != 2) {
                        sun[i]->SetPosition(sun_pos[0], camera_pos[1] - sun_pos[1], sun_pos[2]);
                        mgDrawDirect(sun[i]);
                    }
                }
            }
        }
    }
    if (!(lighting_ratio[2] <= 0.0f)) {
        for (int i = 0; i < 4; i++) {
            attr.obj_alpha = sun_lighting_ratio[i];
            if (!(sun_lighting_ratio[i] <= 0.0f) && sun[i] != NULL) {
                textures->ReloadTexture(tex_block[i], (sceVif1Packet *)NULL);
                sun[i]->SetPosition(moon_pos);
                sun[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);
                if (!(moon_pos[1] <= camera_pos[1])) {
                    mgDrawDirect(sun[i]);
                    if (i != 2) {
                        sun[i]->SetPosition(moon_pos[0], camera_pos[1] - moon_pos[1], moon_pos[2]);
                        mgDrawDirect(sun[i]);
                    }
                }
            }
        }
    }
    for (int i = 0; i < 4; i++) {
        attr.obj_alpha = lighting_ratio[i];
        if (!(lighting_ratio[i] <= 0.0f) && sky[i] != NULL) {
            textures->ReloadTexture(tex_block[i], (sceVif1Packet *)NULL);
            sky[i]->SetScale(1.0f, 1.0f, 1.0f);
            sky[i]->SetPosition(camera_pos[0], camera_pos[1], camera_pos[2]);
            sky[i]->SetRotation(0.0f, sky_rot[i], 0.0f);
            sky[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);
            mgDrawDirect(sky[i]);
            sky[i]->SetScale(1.0f, -1.0f, 1.0f);
            mgDrawDirect(sky[i]);
        }
    }
}
void CMapSky::LoadPack(unsigned int *pack, int tex_block_base, mgCMemory *memory) {
    if (pack == NULL) {
        return;
    }
    Initialize();
    int script_size = 0;
    char *script = (char *)GetPackFile(pack, "info.cfg", &script_size);
    MAP_SKY_INFO info;
    memset(&info, 0, sizeof(info));
    LoadSkyPack(&info, script, script_size);
    mgCTextureManager *textures = &mgTexManager;
    mgCFrameAttr attr;
    attr.alpha_ref = 0;
    attr.z_write = -1;
    for (int i = 0; i < 4; i++) {
        int image_size;
        u_char *image;
        int texture_block = tex_block_base + i;
        textures->DeleteBlock(texture_block);
        u_int *image_in_pack = GetPackFile(pack, info.img_name[i], &image_size);
        unsigned int quadwords;
        if (image_size & 0xF) {
            quadwords = ((unsigned int)image_size >> 4) + 1;
        } else {
            quadwords = (unsigned int)image_size >> 4;
        }
        image = (u_char *)memory->Alloc(quadwords);
        memcpy(image, image_in_pack, image_size);
        MDS_HEADER *sky_file = (MDS_HEADER *)GetPackFile(pack, info.sky_mds_name[i], NULL);
        MDS_HEADER *skyb_file = (MDS_HEADER *)GetPackFile(pack, info.skyb_mds_name[i], NULL);
        MDS_HEADER *sun_file = (MDS_HEADER *)GetPackFile(pack, info.sun_mds_name[i], NULL);
        sky_rot_speed[i] = info.sky_rot_speed[i];
        skyb_rot_speed[i] = info.skyb_rot_speed[i];
        if (image != NULL) {
            tex_block[i] = texture_block;
            textures->EnterIMGFile(image, texture_block, memory, NULL);
        }
        if (sky_file != NULL) {
            sky[i] = mgLoadMDSFile(sky_file, memory, NULL, NULL);
            if (sky[i] != NULL) {
                sky[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE);
            }
        }
        if (skyb_file != NULL) {
            skyb[i] = mgLoadMDSFile(skyb_file, memory, NULL, NULL);
            if (skyb[i] != NULL) {
                skyb[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE);
            }
        }
        if (sun_file != NULL) {
            sun[i] = mgLoadMDSFile(sun_file, memory, NULL, NULL);
            if (sun[i] != NULL) {
                sun[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE);
            }
        }
    }
    MDS_HEADER *background_file = (MDS_HEADER *)GetPackFile(pack, info.bg_mds_name, NULL);
    if (background_file != NULL) {
        mgCreateVisualType visual_types[2] = {{0, at_386}, {MG_VISUAL_CREATE_END, NULL}};
        bg = mgLoadMDSFile(background_file, memory, visual_types, NULL);
        if (bg != NULL) {
            mgCFrameAttr *bg_attr = bg->attr;
            if (bg_attr != NULL) {
                bg_attr->z_write = -1;
                bg_attr->clip_enable = 1;
                bg_attr->fog = 0;
            }
            bg_visual = (mgCVisualMDT *)bg->visual;
        }
    }
    int next = 0;
    for (int i = 0; i < 16; i++) {
        if (info.sky_anime_name[i][0] != 0 && next < 16) {
            mgCFrame *model = sky[info.sky_anime_id[i]];
            if (model != NULL) {
                mgCFrame *frame = model->SearchFrame(info.sky_anime_name[i]);
                if (frame != NULL) {
                    anime[next].frame = frame;
                    anime[next].speed = info.sky_anime_speed[i];
                    next++;
                }
            }
        }
    }
    for (int i = 0; i < 16; i++) {
        if (info.skyb_anime_name[i][0] != 0 && next < 16) {
            mgCFrame *model = skyb[info.skyb_anime_id[i]];
            if (model != NULL) {
                mgCFrame *frame = model->SearchFrame(info.skyb_anime_name[i]);
                if (frame != NULL) {
                    anime[next].frame = frame;
                    anime[next].speed = info.skyb_anime_speed[i];
                    next++;
                }
            }
        }
    }
}

/**
 *
 * Parses sky configuration tags into the supplied sky information record.
 *
 */
static void LoadSkyPack(MAP_SKY_INFO *info, char *script, int size) {
    skyInfo = info;
    skyAnmNum = 0;
    skybAnmNum = 0;

    if (script == NULL || size == 0) {
        return;
    }

    CScriptInterpreter interpreter;
    interpreter.SetTag(tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
}

/**
 *
 * Checks whether a sky time band index is in range.
 *
 */
static s32 CheckSkyID(s32 sky_id) {
    s32 valid;

    if (sky_id < 0 || sky_id >= 4) {
        valid = 0;
    } else {
        valid = 1;
    }

    return valid;
}

/**
 *
 * Records the texture pack name for a sky time band.
 *
 */
static s32 _SKY_IMG(SPI_STACK *stack, s32 arg_count) {
    s32   sky_id = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(sky_id)) {
        return 0;
    }

    name = spiGetStackString(stack);

    if (name != 0) {
        strcpy(skyInfo->img_name[sky_id], name);
    }

    return 1;
}

/**
 *
 * Records a sky model and its rotation speed for a time band.
 *
 */
static s32 _SKY_MDS(SPI_STACK *stack, s32 arg_count) {
    s32   sky_id = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(sky_id)) {
        return 0;
    }

    name = spiGetStackString(stack++);

    if (name != 0) {
        strcpy(skyInfo->sky_mds_name[sky_id], name);
    }

    skyInfo->sky_rot_speed[sky_id] = spiGetStackFloat(stack) * 3.14159265358979323846f / 180.0f;
    return 1;
}

/**
 *
 * Records the sun or moon model name for a time band.
 *
 */
static s32 _SUN_MDS(SPI_STACK *stack, s32 arg_count) {
    s32   sky_id = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(sky_id)) {
        return 0;
    }

    name = spiGetStackString(stack);

    if (name != 0) {
        strcpy(skyInfo->sun_mds_name[sky_id], name);
    }

    return 1;
}

/**
 *
 * Records a background sky model and its rotation speed for a time band.
 *
 */
static s32 _SKYB_MDS(SPI_STACK *stack, s32 arg_count) {
    s32   sky_id = spiGetStackInt(stack++);
    char *name;

    if (!CheckSkyID(sky_id)) {
        return 0;
    }

    name = spiGetStackString(stack++);

    if (name != 0) {
        strcpy(skyInfo->skyb_mds_name[sky_id], name);
    }

    skyInfo->skyb_rot_speed[sky_id] = spiGetStackFloat(stack) * 3.14159265358979323846f / 180.0f;
    return 1;
}

/**
 *
 * Records the shared sky background model name.
 *
 */
static int _SKY_BG(SPI_STACK *stack, int argument_count) {
    char *name = spiGetStackString(&stack[0]);

    if (name != NULL) {
        strcpy(skyInfo->bg_mds_name, name);
    }

    return 1;
}

/**
 *
 * Adds a named sky model animation for a time band.
 *
 */
static int _SKY_ANIME(SPI_STACK *stack, int argument_count) {
    if (skyAnmNum >= 16) {
        return 0;
    }

    int id = spiGetStackInt(stack++);

    if (!CheckSkyID(id)) {
        return 0;
    }

    skyInfo->sky_anime_id[skyAnmNum] = id;
    char *name = spiGetStackString(stack++);

    if (name != NULL) {
        strcpy(skyInfo->sky_anime_name[skyAnmNum], name);
    }

    skyInfo->sky_anime_speed[skyAnmNum] = 3.1415927f * spiGetStackFloat(stack) / 180.0f;
    ++skyAnmNum;
    return 1;
}

/**
 *
 * Adds a named background sky animation for a time band.
 *
 */
static int _SKYB_ANIME(SPI_STACK *stack, int argument_count) {
    if (skybAnmNum >= 16) {
        return 0;
    }

    int id = spiGetStackInt(stack++);

    if (!CheckSkyID(id)) {
        return 0;
    }

    skyInfo->skyb_anime_id[skybAnmNum] = id;
    char *name = spiGetStackString(stack++);

    if (name != NULL) {
        strcpy(skyInfo->skyb_anime_name[skybAnmNum], name);
    }

    skyInfo->skyb_anime_speed[skybAnmNum] = 3.1415927f * spiGetStackFloat(stack) / 180.0f;
    ++skybAnmNum;
    return 1;
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapsky", at_386__DATA);
