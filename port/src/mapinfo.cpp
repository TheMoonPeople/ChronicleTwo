#include "common.h"

#include <cmath>
#include <cstring>
#include <numbers>
#include <optional>
#include <string>

#include "mapinfo.hpp"
#include "mapload.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "scene_documents.hpp"
#include "texture_copy.hpp"

namespace {

/**
 * Gives the number of quadwords that hold a byte count.
 */
u32 Quadwords(u32 bytes) {
    return (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
}

/**
 * Keeps a copy of a pack name in the map's memory, as mapIMG and mapPCP do.
 */
char *CopyName(const std::string &name, mgCMemory *memory) {
    auto *copy = reinterpret_cast<char *>(memory->Alloc(static_cast<int>(Quadwords(static_cast<u32>(name.size() + 1)))));
    if (copy != nullptr) {
        std::strcpy(copy, name.c_str());
    }
    return copy;
}

/**
 * Copies three script values into a vector's first three components.
 */
void SetVec3(float *vector, const SceneVec3 &value) {
    vector[0] = value[0];
    vector[1] = value[1];
    vector[2] = value[2];
}

/**
 * Fills one lighting set as LIGHT_SET and its lighting tags do.
 */
void ApplyLightSet(CMapInfo &info, const SceneLightSet &set) {
    CMapLightingInfo *lighting = info.GetLightingInfo(set.index);
    if (lighting == nullptr) {
        return;
    }
    if (set.fov) {
        lighting->projection = (mgScreenWidth / 2.0f) / tanf(0.45378563f);
    }
    if (set.bg_color) {
        SetVec3(lighting->bg_color, *set.bg_color);
        lighting->bg_color[3] = 128.0f;
    }
    if (set.bg_color2) {
        SetVec3(lighting->bg_color2, *set.bg_color2);
        lighting->bg_color2[3] = 128.0f;
        // A black second background takes the first one.
        if (lighting->bg_color2[0] == 0.0f && lighting->bg_color2[1] == 0.0f && lighting->bg_color2[2] == 0.0f) {
            std::memcpy(lighting->bg_color2, lighting->bg_color, sizeof(lighting->bg_color2));
        }
    }
    if (set.ambient) {
        SetVec3(lighting->ambient, *set.ambient);
        lighting->ambient[3] = 128.0f;
    }
    for (const auto &light : set.lights) {
        if (light.index < 0 || light.index > 3 || !light.direction) {
            continue;
        }
        float vector[4] = {(*light.direction)[0], (*light.direction)[1], (*light.direction)[2], 0.0f};
        sceVu0Normalize(vector, vector);
        lighting->light_dir[0][light.index] = vector[0];
        lighting->light_dir[1][light.index] = vector[1];
        lighting->light_dir[2][light.index] = vector[2];
        if (light.color) {
            float color[4] = {(*light.color)[0], (*light.color)[1], (*light.color)[2], 0.0f};
            sceVu0CopyVector(lighting->light_color[light.index], color);
        }
    }
    for (const auto &light : set.point_lights) {
        if (light.index < 0 || light.index > 3) {
            continue;
        }
        mgPOINT_LIGHT *point = &lighting->point_light[light.index];
        point->power = light.power;
        SetVec3(point->pos, light.position);
        point->pos[3] = 1.0f;
        SetVec3(point->color, light.color);
        point->color[3] = 0.0f;
        lighting->plight_enable = 1;
    }
    if (set.fog_enable) {
        lighting->fog_enable = *set.fog_enable;
    }
    if (set.fog) {
        const auto &fog = *set.fog;
        lighting->fog.r = fog.color ? (*fog.color)[0] : 255;
        lighting->fog.g = fog.color ? (*fog.color)[1] : 255;
        lighting->fog.b = fog.color ? (*fog.color)[2] : 255;
        lighting->fog.far_value = 0.0f;
        lighting->fog.near_value = 255.0f;
        lighting->fog.near_dist = fog.near_dist;
        lighting->fog.far_dist = fog.far_dist;
        // FOG gives both fog values or neither.
        if (fog.far_value && fog.near_value) {
            lighting->fog.far_value = *fog.far_value;
            lighting->fog.near_value = *fog.near_value;
        }
    }
}

/**
 * Applies the map-wide settings of a scene_map document.
 */
void ApplySettings(CMapInfo &info, const SceneInfo &settings) {
    if (settings.active_light_set) {
        info.active_light_no = *settings.active_light_set;
    }
    for (const auto &set : settings.light_sets) {
        ApplyLightSet(info, set);
    }
    if (settings.floor) {
        info.floor = *settings.floor;
    }
    if (settings.chara_pos) {
        SetVec3(info.chara_pos, *settings.chara_pos);
    }
    if (settings.def_foot) {
        info.def_foot = *settings.def_foot;
    }
    if (settings.time_enable) {
        info.time_enable = *settings.time_enable;
        info.time_light_blend = settings.time_blend;
        if (settings.fixed_time) {
            info.fixed_time = *settings.fixed_time;
        }
        if (settings.fixed_time_enable) {
            info.fixed_time_enable = *settings.fixed_time_enable;
        }
    }
    if (settings.time_light_num) {
        info.time_light_num = *settings.time_light_num;
    }
    if (settings.time_cfade) {
        info.time_cfade = *settings.time_cfade;
    }
    if (settings.sky_info) {
        info.sky_info = *settings.sky_info;
        info.sky_height = settings.sky_height;
        if (settings.sun_angle_degrees) {
            info.sun_angle = mgAngleLimit(std::numbers::pi_v<float> * *settings.sun_angle_degrees / 180.0f);
        }
    }
    if (settings.lens_flare) {
        info.lens_flare = *settings.lens_flare;
    }
    if (settings.all_scissor) {
        info.all_scissor = *settings.all_scissor;
    }
    if (settings.chara_light_adjust) {
        info.chara_light_adjust = *settings.chara_light_adjust;
        SetVec3(info.chara_light_adjust_value, settings.chara_light_value);
    }
}

/**
 * Copies the map script into the map's memory so the map loads from it later, as retail does.
 */
char *CopyScript(char *script, int size, mgCMemory *memory) {
    auto *copy = reinterpret_cast<char *>(memory->Alloc(static_cast<int>(Quadwords(static_cast<u32>(size)))));
    if (copy != nullptr) {
        PortTextureSourceCopy(copy, script, static_cast<std::size_t>(size));
    }
    return copy;
}

/**
 * Adds a pack name in the first free entry of a 16-entry name list, as the add-map tags do.
 */
void AddName(char **names, const SceneText &name, mgCMemory *memory) {
    if (!name) {
        return;
    }
    for (int index = 0; index < 16; ++index) {
        if (names[index] == nullptr) {
            names[index] = CopyName(*name, memory);
            return;
        }
    }
}

} // namespace

PORT_OVERRIDE void CMapInfo::LoadMapInfo(char *script, int script_size, mgCMemory *stack) {
    img_num = 16;
    for (int index = 0; index < img_num; ++index) {
        img_name[index] = nullptr;
    }
    pcp_num = 16;
    // The model pack names are cleared up to the texture pack capacity.
    for (int index = 0; index < img_num; ++index) {
        pcp_name[index] = nullptr;
    }
    map_file = CopyScript(script, script_size, stack);
    map_file_size = script_size;
    lighting_info_num = 16;
    const int count = lighting_info_num;
    const u32 blocks = Quadwords(count * sizeof(CMapLightingInfo));
    lighting_info = new (stack->Alloc(static_cast<int>(blocks + 2))) CMapLightingInfo[count];

    const auto document = ReadSceneMap(script);
    if (!document) {
        return;
    }
    int images = 0;
    for (const auto &name : document->info.texture_packs) {
        if (images < img_num && name) {
            img_name[images++] = CopyName(*name, stack);
        }
    }
    int models = 0;
    for (const auto &name : document->info.model_packs) {
        if (models < pcp_num && name) {
            pcp_name[models++] = CopyName(*name, stack);
        }
    }
    ApplySettings(*this, document->info);
}

PORT_OVERRIDE void CMapInfo::AddMapInfo(char *script, int script_size, mgCMemory *stack) {
    add_map_file = CopyScript(script, script_size, stack);
    add_map_file_size = script_size;
    const auto document = ReadSceneMap(script);
    if (!document) {
        return;
    }
    for (const auto &name : document->info.texture_packs) {
        AddName(img_name, name, stack);
    }
    for (const auto &name : document->info.model_packs) {
        AddName(pcp_name, name, stack);
    }
}
