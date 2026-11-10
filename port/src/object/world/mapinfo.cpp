#include "common.h"
#include "mw_runtime.h"

#include <libvu0.h>

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <format>
#include <limits>

#include "assets/data_registry.hpp"
#include "mapinfo.hpp"
#include "mapload.hpp"
#include "memory/tracked_copy.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"

void CCameraInfo::Initialize() {
    int i = {};
    int j = {};
    int k = {};

    pos_num = 0;

    for (i = 0; i < 8; i++) {
        mgZeroVectorW(pos[i]);
    }

    rect_num = 4;

    for (j = 0; j < rect_num; j++) {
        rect[j] = nullptr;
    }

    draw_info_num = 4;

    for (k = 0; k < draw_info_num; k++) {
        draw_info[k].unk_4 = 0;
        draw_info[k].group_no = -1;
    }
}

CCameraDrawInfo *CCameraInfo::GetDrawInfo(int index) {
    if (index < 0 || index >= draw_info_num) {
        return nullptr;
    }

    return &draw_info[index];
}

void CMapInfo::Initialize() {
    *this = CMapInfo{};
}

char *CMapInfo::GetImgName(int index) {
    if (index < 0 || index >= img_num) {
        return nullptr;
    }

    return img_name[index];
}

char *CMapInfo::GetPCPName(int index) {
    if (index < 0 || index >= pcp_num) {
        return nullptr;
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
        return nullptr;
    }

    return &lighting_info[index];
}

namespace {
/**
 *
 * Converts edited lighting components without overflowing the integer representation.
 *
 */
int LightingInteger(float value) {
    if (std::isnan(value)) {
        return 0;
    }
    if (value >= static_cast<float>(std::numeric_limits<int>::max())) {
        return std::numeric_limits<int>::max();
    }
    if (value <= static_cast<float>(std::numeric_limits<int>::min())) {
        return std::numeric_limits<int>::min();
    }
    return static_cast<int>(value);
}
} // namespace

std::string dc2::world::LightingText(const CMapInfo &map) {
    if (map.lighting_info_num < 0 || (map.lighting_info_num > 0 && map.lighting_info == nullptr)) {
        return {};
    }
    auto text = std::format("MPL_ACTIVE_LIGHT_SET {};\n", map.active_light_no);
    for (int set = 0; set < map.lighting_info_num; ++set) {
        const auto &info = map.lighting_info[set];
        text += std::format("MPL_LIGHT_SET {};\n MPL_FOV 52;\n", set);
        text += std::format(" MPL_BGCOLOR {},{},{};\n", LightingInteger(info.bg_color[0]), LightingInteger(info.bg_color[1]), LightingInteger(info.bg_color[2]));
        text += std::format(" MPL_BGCOLOR2 {},{},{};\n", LightingInteger(info.bg_color2[0]), LightingInteger(info.bg_color2[1]), LightingInteger(info.bg_color2[2]));
        text += std::format(" MPL_AMBIENT {},{},{};\n", LightingInteger(info.ambient[0]), LightingInteger(info.ambient[1]), LightingInteger(info.ambient[2]));
        for (std::size_t light = 0; light < std::size(info.light_color); ++light) {
            text += std::format(" MPL_LIGHT {},{:.6f},{:.6f},{:.6f},{},{},{},1;\n", light,
                                info.light_dir[0][light], info.light_dir[1][light], info.light_dir[2][light],
                                LightingInteger(info.light_color[light][0]), LightingInteger(info.light_color[light][1]), LightingInteger(info.light_color[light][2]));
        }
        text += std::format(" MPL_FOG_ENABLE {};\n", info.fog_enable);
        text += std::format(" MPL_FOG {:.6f},{:.6f},{},{},{},{},{};\nMPL_LIGHT_SET_END;\n", info.fog.near_dist, info.fog.far_dist,
                            info.fog.r, info.fog.g, info.fog.b, LightingInteger(info.fog.far_value), LightingInteger(info.fog.near_value));
    }
    return text;
}

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

namespace {

/**
 * Keeps a copy of a pack name in the map's memory, as mapIMG and mapPCP do.
 */
char *CopyName(const std::string &name, mgCMemory *memory) {
    return memory == nullptr ? nullptr : dc2::memory::CopyText(*memory, name);
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
 *
 * Copies a registered map document into a checked arena allocation.
 *
 */
char *CopyScript(char *script, int size, mgCMemory *memory) {
    if (script == nullptr || memory == nullptr || size <= 0 ||
        static_cast<std::size_t>(size) > DataReadBufferSize(script)) {
        return nullptr;
    }
    const auto count = static_cast<std::size_t>(size);
    auto      *copy = dc2::memory::NewArray<char>(*memory, count);
    if (copy != nullptr) {
        dc2::memory::CopyTrackedBytes(copy, script, count);
    }
    return copy;
}

/**
 *
 * Adds a pack name to a bounded list without publishing failed allocations.
 *
 */
bool AddName(std::span<char *> names, const SceneText &name, mgCMemory *memory) {
    if (!name) {
        return true;
    }
    for (auto &slot : names) {
        if (slot == nullptr) {
            auto *copy = CopyName(*name, memory);
            if (copy == nullptr) {
                return false;
            }
            slot = copy;
            return true;
        }
    }
    return true;
}

} // namespace

void CMapInfo::LoadMapInfo(char *script, int script_size, mgCMemory *stack) {
    if (stack == nullptr || script == nullptr || script_size <= 0 ||
        static_cast<std::size_t>(script_size) > DataReadBufferSize(script)) {
        return;
    }
    const auto document = ReadSceneMap(script);
    if (!document) {
        return;
    }
    auto pending = *this;
    pending.img_num = static_cast<int>(std::size(pending.img_name));
    std::fill(std::begin(pending.img_name), std::end(pending.img_name), nullptr);
    pending.pcp_num = static_cast<int>(std::size(pending.pcp_name));
    std::fill(std::begin(pending.pcp_name), std::end(pending.pcp_name), nullptr);
    pending.map_file = CopyScript(script, script_size, stack);
    pending.map_file_size = script_size;
    pending.lighting_info_num = 16;
    pending.lighting_info = dc2::memory::NewArray<CMapLightingInfo>(*stack, static_cast<std::size_t>(pending.lighting_info_num));
    if (pending.map_file == nullptr || pending.lighting_info == nullptr) {
        return;
    }
    for (const auto &name : document->info.texture_packs) {
        if (!AddName(pending.img_name, name, stack)) {
            return;
        }
    }
    for (const auto &name : document->info.model_packs) {
        if (!AddName(pending.pcp_name, name, stack)) {
            return;
        }
    }
    ApplySettings(pending, document->info);
    *this = pending;
}

void CMapInfo::AddMapInfo(char *script, int script_size, mgCMemory *stack) {
    if (stack == nullptr || script == nullptr || script_size <= 0 ||
        static_cast<std::size_t>(script_size) > DataReadBufferSize(script)) {
        return;
    }
    const auto document = ReadSceneMap(script);
    if (!document) {
        return;
    }
    auto pending = *this;
    pending.add_map_file = CopyScript(script, script_size, stack);
    if (pending.add_map_file == nullptr) {
        return;
    }
    pending.add_map_file_size = script_size;
    for (const auto &name : document->info.texture_packs) {
        if (!AddName(pending.img_name, name, stack)) {
            return;
        }
    }
    for (const auto &name : document->info.model_packs) {
        if (!AddName(pending.pcp_name, name, stack)) {
            return;
        }
    }
    *this = pending;
}
