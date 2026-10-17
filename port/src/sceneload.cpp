#include "common.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <memory>

#include "character.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "editmap.hpp"
#include "map.hpp"
#include "mapsky.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/model_assets.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "sceneload_port.hpp"
#include "scenesnd.hpp"

PORT_OVERRIDE int CScene::LoadChara(int index, u_int *model, char *profile, mgCMemory *model_memory,
                                    mgCMemory *motion_memory, mgCMemory *image_memory, int texture_block, int no_outline) {
    const auto path = DataReadBufferPath(model);
    if (!path || !model_memory) {
        return -1;
    }
    std::string error;
    std::string selected;
    if (!profile) {
        const auto game = model_assets::ReadGameplay(*path, error);
        if (!game) {
            return -1;
        }
        selected = game->value("default_profile", std::string{});
        profile = selected.data();
    }
    auto *character = new (model_memory->Alloc((sizeof(CCharacter2) + 15) / 16 + 2)) CCharacter2;
    DeleteChara(index);
    const int slot = AssignChara(index, character, "chara");
    if (slot < 0) {
        return -1;
    }
    auto *scene_character = GetSceneCharacter(slot);
    if (!scene_character) {
        return -1;
    }
    character->Initialize();
    model_assets::CharacterLoadOptions options{model_memory, motion_memory, image_memory, &mgTexManager, nullptr, texture_block, no_outline == 0};
    if (!model_assets::LoadCharacter(*character, *path, profile, options, error)) {
        std::fprintf(stderr, "character: %s: %s\n", path->c_str(), error.c_str());
        DeleteChara(slot);
        return -1;
    }
    scene_character->status |= SCENE_DATA_LOADED;
    SetCharaTexb(slot, texture_block);
    character->sound_info.foot_se_bank = se_base_id;
    character->sound_info.foot_sound_id = 0;
    return slot;
}

namespace {

constexpr double kHblanksPerField = 262.0;

// Only differences of the count are used, so the anchor is arbitrary. The count is truncated to
// 32 bits like the hardware register, so a difference wraps the same way.
u_int HostTimer0Count() {
    static const std::chrono::steady_clock::time_point anchor = std::chrono::steady_clock::now();
    const std::chrono::duration<double>                elapsed = std::chrono::steady_clock::now() - anchor;
    return static_cast<u_int>(static_cast<std::uint64_t>(elapsed.count() * ClockTickRate() * kHblanksPerField));
}

} // namespace

PORT_OVERRIDE int CScene::LoadMapFromMemory(int map_no, int step, SCN_LOADMAP_INFO2 *info) {
    mgCMemory *stack = info->stack;
    int        tex_block = info->tex_block;

    if (step == SCN_LOADMAP_STEP_CREATE) {
        CEditMap *edit_map;

        if (info->data_ready == 0) {
            return -1;
        }

        u8 *buf = info->load_buf;

        if (stack == NULL || buf == NULL) {
            return -1;
        }

        edit_map = new (stack->Alloc(0x111)) CEditMap;

        if (edit_map == NULL) {
            return -1;
        }

        edit_map->mds_list_set = &mds_list_set;
        return GetSceneMap(AssignMap(map_no, edit_map, info->name)) != NULL ? 1 : -1;
    }

    if (step == SCN_LOADMAP_STEP_MAP_INFO) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info->files[0];
        SCN_LOADMAP_INFO2::MapFiles *add_files = NULL;
        CMap                        *map = GetMap(map_no);

        if (info->files[1].enable != 0) {
            add_files = &info->files[1];
        }

        map->map_info.LoadMapInfo(files->map_data, files->map_size, stack);

        if (add_files != NULL) {
            map->map_info.AddMapInfo(add_files->map_data, add_files->map_size, stack);
        }

        return SCN_LOADMAP_STEP_DATA;
    }

    if (step == SCN_LOADMAP_STEP_DATA) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info->files[0];
        SCN_LOADMAP_INFO2::MapFiles *add_files = NULL;
        CMap                        *map = GetMap(map_no);
        int                          add_block_num = 0;
        int                          block;

        if (info->files[1].enable != 0) {
            add_files = &info->files[1];
        }

        block = tex_block;

        if (add_files != NULL) {
            map->LoadData(add_files->mpk_data, add_files->ipk_data, &block, stack);
            add_block_num += block;
            tex_block += block;
        }

        block = tex_block;
        map->LoadData(files->mpk_data, files->ipk_data, &block, stack);
        add_block_num += block;
        info->tex_block_num = add_block_num;
        return SCN_LOADMAP_STEP_EFFECT;
    }

    if (step == SCN_LOADMAP_STEP_EFFECT) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info->files[0];
        CMap                        *map = GetMap(map_no);
        unsigned int                *efp_data = files->efp_data;

        if (efp_data != NULL) {
            map->CreateEffect(efp_data, info->efp_tex_block, stack);
        }

        strcpy(mgTexManager.name_suffix, "1");

        if (map->map_info.sky_info != 0 && files->sky_data != NULL && info->sky_tex_block > 0) {
            DeleteSky(0);

            CMapSky *sky = (CMapSky *) operator new(sizeof(CMapSky), stack->Alloc(0x13));

            if (sky != NULL) {
                sky->Initialize();
                sky->LoadPack(files->sky_data, info->sky_tex_block, stack);
                AssignSky(0, sky, NULL);
            }
        }

        mgTexManager.name_suffix[0] = 0;
        return SCN_LOADMAP_STEP_CREATE_MAP;
    }

    if (step == SCN_LOADMAP_STEP_CREATE_MAP) {
        CMap *map;
        u_int start_count = HostTimer0Count();

        map = GetMap(map_no);

        if (info->place_parts_max > 0) {
            map->SetPlacePartsBuff(stack, info->place_parts_max);
        }

        map->CreateMap(&mds_list_set, stack);
        printf("5:%d\n", HostTimer0Count() - start_count);
        return SCN_LOADMAP_STEP_FUNC_POINT;
    }

    if (step == SCN_LOADMAP_STEP_FUNC_POINT) {
        GetMap(map_no)->AssignFuncPoint(stack);
        return SCN_LOADMAP_STEP_CFG;
    }

    if (step == SCN_LOADMAP_STEP_CFG) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info->files[0];
        CMap                        *map = GetMap(map_no);
        CSceneMap                   *slot = GetSceneMap(map_no);

        if (files->cfg_size > 0) {
            map->LoadCfgFile(files->cfg_data, files->cfg_size, stack);
        }

        int num = info->tex_block_num;
        slot->tex_block = info->tex_block;
        slot->tex_block_num = num;
        slot->stack = stack;
        slot->status |= SCENE_DATA_LOADED;
        map->PlacePartsEnd();
        printf("remain %dkByte\n", stack->stGetRest() * 16 / 1024);
        return SCN_LOADMAP_STEP_CFG;
    }

    return -1;
}

namespace {

// One 64-byte line, so the read buffer keeps the 64-byte alignment of retail's stAlloc64 buffers.
struct alignas(64) MapLoadLine {
    u8 bytes[64];
};

// Map file reads, which retail put in the caller's fixed load buffer.
struct MapLoadScratch {
    std::unique_ptr<MapLoadLine[]> lines;
    std::unique_ptr<MapLoadLine[]> retired; // deferred LoadMapFromMemory steps (bg_load_info) may still read it
    std::size_t                    capacity = 0;
    std::size_t                    measured = 0;
};

MapLoadScratch map_load;

constexpr u8 kMapLoadGuard = 0xA5;

std::size_t Pad64(int size) {
    return size > 0 ? (static_cast<std::size_t>(size) + 63) / 64 * 64 : 0;
}

int MapFileSize(const char *dir, const char *name, const char *extension) {
    char path[0x80];
    int  size = 0;
    std::snprintf(path, sizeof path, "%s%s%s", dir, name, extension);
    return LoadFile2(path, NULL, &size, LOAD_FILE_SIZE) ? size : 0;
}

} // namespace

// The bytes LoadMapData's reads can write: each read advances the buffer by its size rounded up to 64.
std::size_t PortMapLoadBytes(const SCN_LOADMAP_INFO2 &info) {
    std::size_t bytes = 0;

    for (const SCN_LOADMAP_INFO2::MapFiles &files : info.files) {
        if (files.enable == 0) {
            break;
        }

        bytes += Pad64(MapFileSize(files.dir, files.map_name, ".map.json"));
        bytes += Pad64(MapFileSize(files.dir, files.cfg_name, ".cfg.json"));
        bytes += Pad64(MapFileSize(files.dir, files.mpk_name, ".mpk"));

        if (info.load_sky != 0) {
            bytes += Pad64(std::max(MapFileSize(files.dir, files.sky_name, ".sky"), MapFileSize("map/", files.def_sky_name, ".sky")));
        }
    }

    // The reader zeroes the last file's sector tail past its 64-byte rounding.
    return bytes + DATAREAD_SECTOR_SIZE;
}

// Retail reads a map's .map, .cfg, .mpk and .sky one after another into the caller's load buffer, the dungeon's
// BuffReadData or the town's read buffer (200000 quadwords, 260000 on PC). The converted maps are larger: the Sea
// Dragon's arena, s15.map.json, is 4.35 MB and Ocean's Roar Cave's floors, d04f01.map.json, 5.16 MB. A map past the
// buffer's end overwrote the party and monster objects carved after it, and the first monster's Initialize crashed on
// map text. LoadMapData reads into this buffer instead, sized to the map's files.
u8 *PortMapLoadBuffer(const SCN_LOADMAP_INFO2 &info) {
    const std::size_t measured = PortMapLoadBytes(info);
    const std::size_t needed = measured + DATAREAD_SECTOR_SIZE;

    if (needed > map_load.capacity) {
        const std::size_t lines = (needed + needed / 4 + sizeof(MapLoadLine) - 1) / sizeof(MapLoadLine);
        map_load.retired = std::move(map_load.lines);
        map_load.lines = std::make_unique<MapLoadLine[]>(lines);
        map_load.capacity = lines * sizeof(MapLoadLine);
        std::fprintf(stderr, "map load: %s%s needs %zu bytes; read buffer grown to %zu\n", info.files[0].dir,
                     info.files[0].map_name, measured - DATAREAD_SECTOR_SIZE, map_load.capacity);
    }

    map_load.measured = measured;
    u8 *base = map_load.lines[0].bytes;
    std::memset(base + measured, kMapLoadGuard, DATAREAD_SECTOR_SIZE);
    return base;
}

// Stops the game when LoadMapData's reads went past what PortMapLoadBuffer measured, or wrote into the guard after it.
void PortMapLoadCheck(const SCN_LOADMAP_INFO2 &info, const u8 *end) {
    const u8         *base = map_load.lines[0].bytes;
    const std::size_t used = static_cast<std::size_t>(end - base);
    const u8         *guard = base + map_load.measured;
    bool              intact = true;

    for (int i = 0; i < DATAREAD_SECTOR_SIZE; i++) {
        intact = intact && guard[i] == kMapLoadGuard;
    }

    if (used + DATAREAD_SECTOR_SIZE > map_load.measured || !intact) {
        std::fprintf(stderr, "map load: %s%s read %zu bytes, past the %zu measured for its files\n", info.files[0].dir,
                     info.files[0].map_name, used, map_load.measured - DATAREAD_SECTOR_SIZE);
        std::abort();
    }
}
