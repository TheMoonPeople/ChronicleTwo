#include "common.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <format>
#include <memory>
#include <string>
#include <string_view>

#include "bounded_text.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "editmap.hpp"
#include "event_func.hpp"
#include "log/log.hpp"
#include "map.hpp"
#include "mapsky.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/model_assets.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "sceneload_port.hpp"
#include "scenesnd.hpp"

// Retail's printf diagnostics, logged as the game's own (docs/LOGGING.md).
#include "ps2_printf.hpp"

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
    model_assets::CharacterLoadOptions options{.model_memory = model_memory, .motion_memory = motion_memory, .image_memory = image_memory, .textures = &mgTexManager, .parent = nullptr, .texture_block = texture_block, .outline = no_outline == 0};
    if (!model_assets::LoadCharacter(*character, *path, profile, options, error)) {
        CT_LOG_ERROR(Data, "character: {}: {}", *path, error);
        DeleteChara(slot);
        return -1;
    }
    scene_character->status |= SCENE_DATA_LOADED;
    CT_LOG_TRACE(Data, "sceneload: character {} slot {} from {} ({})", index, slot, *path, std::string_view(profile));
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
        CEditMap *edit_map = nullptr;

        if (info->data_ready == 0) {
            return -1;
        }

        u8 *buf = info->load_buf;

        if (stack == nullptr || buf == nullptr) {
            return -1;
        }
        CT_LOG_DEBUG(Data, "sceneload: map {} loading", map_no);

        edit_map = new (stack->Alloc(0x111)) CEditMap;

        if (edit_map == nullptr) {
            return -1;
        }

        edit_map->mds_list_set = &mds_list_set;
        return GetSceneMap(AssignMap(map_no, edit_map, info->name)) != nullptr ? 1 : -1;
    }

    if (step == SCN_LOADMAP_STEP_MAP_INFO) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info->files[0];
        SCN_LOADMAP_INFO2::MapFiles *add_files = nullptr;
        CMap                        *map = GetMap(map_no);

        if (info->files[1].enable != 0) {
            add_files = &info->files[1];
        }

        map->map_info.LoadMapInfo(files->map_data, files->map_size, stack);

        if (add_files != nullptr) {
            map->map_info.AddMapInfo(add_files->map_data, add_files->map_size, stack);
        }

        return SCN_LOADMAP_STEP_DATA;
    }

    if (step == SCN_LOADMAP_STEP_DATA) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info->files[0];
        SCN_LOADMAP_INFO2::MapFiles *add_files = nullptr;
        CMap                        *map = GetMap(map_no);
        int                          add_block_num = 0;
        int                          block = 0;

        if (info->files[1].enable != 0) {
            add_files = &info->files[1];
        }

        block = tex_block;

        if (add_files != nullptr) {
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

        if (efp_data != nullptr) {
            map->CreateEffect(efp_data, info->efp_tex_block, stack);
        }

        strcpy(mgTexManager.name_suffix, "1");

        if (map->map_info.sky_info != 0 && files->sky_data != nullptr && info->sky_tex_block > 0) {
            DeleteSky(0);

            auto *sky = static_cast<CMapSky *>(operator new(sizeof(CMapSky), stack->Alloc(0x13)));

            if (sky != nullptr) {
                sky->Initialize();
                sky->LoadPack(files->sky_data, info->sky_tex_block, stack);
                AssignSky(0, sky, nullptr);
            }
        }

        mgTexManager.name_suffix[0] = 0;
        return SCN_LOADMAP_STEP_CREATE_MAP;
    }

    if (step == SCN_LOADMAP_STEP_CREATE_MAP) {
        CMap *map = nullptr;
        u_int start_count = HostTimer0Count();

        map = GetMap(map_no);

        if (info->place_parts_max > 0) {
            map->SetPlacePartsBuff(stack, info->place_parts_max);
        }

        map->CreateMap(&mds_list_set, stack);
        CtPs2Printf("5:%u\n", static_cast<unsigned>(HostTimer0Count() - start_count));
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
        CT_LOG_DEBUG(Data, "sceneload: map {} loaded", map_no);
        CtPs2Printf("remain %dkByte\n", stack->stGetRest() * 16 / 1024);
        return SCN_LOADMAP_STEP_CFG;
    }

    return -1;
}

namespace {

// One 64-byte line, so map reads keep the alignment of retail's stAlloc64 load buffers.
struct alignas(64) MapLoadLine {
    std::array<u8, 64> bytes;
};

// The map read buffer, and the one it replaced, which a deferred map build may still be reading.
std::unique_ptr<MapLoadLine[]> map_load_lines;
std::unique_ptr<MapLoadLine[]> map_load_retired;
std::size_t                    map_load_capacity = 0;

// The bytes LoadMapData's cursor advances past a file: its size rounded up to 64, or nothing when it is missing.
std::size_t MapFileBytes(std::string_view dir, std::string_view name, std::string_view extension) {
    std::string path = std::format("{}{}{}", dir, name, extension);
    int         size = 0;

    if (LoadFile2(path.data(), nullptr, &size, LOAD_FILE_SIZE) == 0 || size <= 0) {
        return 0;
    }

    return (static_cast<std::size_t>(size) + 63) / 64 * 64;
}

} // namespace

std::size_t PortMapLoadBytes(const SCN_LOADMAP_INFO2 &info) {
    std::size_t bytes = 0;

    for (const SCN_LOADMAP_INFO2::MapFiles &files : info.files) {
        if (files.enable == 0) {
            break;
        }

        const auto dir = bounded_text::View(files.dir, sizeof(files.dir));
        bytes += MapFileBytes(dir, bounded_text::View(files.map_name, sizeof(files.map_name)), ".map.json");
        bytes += MapFileBytes(dir, bounded_text::View(files.cfg_name, sizeof(files.cfg_name)), ".cfg.json");
        bytes += MapFileBytes(dir, bounded_text::View(files.mpk_name, sizeof(files.mpk_name)), ".mpk");

        if (info.load_sky != 0) {
            // A missing map sky falls back to the common one.
            bytes += std::max(MapFileBytes(dir, bounded_text::View(files.sky_name, sizeof(files.sky_name)), ".sky"),
                              MapFileBytes("map/", bounded_text::View(files.def_sky_name, sizeof(files.def_sky_name)), ".sky"));
        }
    }

    // The reader zeroes the rest of the last file's final sector.
    return bytes + DATAREAD_SECTOR_SIZE;
}

// Retail reads the files into the caller's fixed buffer (the dungeon's BuffReadData or the town's read buffer), which
// a large map or a datapack's replacement overruns into the objects carved after it.
u8 *PortMapLoadBuffer(const SCN_LOADMAP_INFO2 &info) {
    const std::size_t lines = (PortMapLoadBytes(info) + sizeof(MapLoadLine) - 1) / sizeof(MapLoadLine);

    if (lines > map_load_capacity) {
        map_load_retired = std::move(map_load_lines);
        map_load_lines = std::make_unique<MapLoadLine[]>(lines);
        map_load_capacity = lines;
    }

    return map_load_lines[0].bytes.data();
}

namespace {

// The event handle a map deletion leaves dangling: an object, frame or function point inside the map's stack.
bool EventHandleIn(const CEoh &handle, std::uintptr_t begin, std::uintptr_t end) {
    const void *target = nullptr;

    switch (handle.type) {
        case EOH_TYPE_OBJECT:
            target = handle.object;
            break;
        case EOH_TYPE_FRAME:
            target = handle.frame;
            break;
        case EOH_TYPE_FUNC_POINT:
            target = handle.func_point;
            break;
        default:
            return false;
    }

    const auto address = reinterpret_cast<std::uintptr_t>(target);
    return address >= begin && address < end;
}

// Points every event handle into the stack at nothing, as EventSeqInit does.
void ForgetEventHandlesIn(const mgCMemory &memory) {
    if (memory.stack == nullptr || memory.stack_size <= 0) {
        return;
    }

    const auto begin = reinterpret_cast<std::uintptr_t>(memory.stack);
    const auto end = begin + static_cast<std::uintptr_t>(memory.stack_size) * sizeof(u_long128);

    for (int slot = 0; slot < EOH_NUM; slot++) {
        CEoh &handle = EventObjHandleMother.eoh[slot];

        if (!EventHandleIn(handle, begin, end)) {
            continue;
        }

        CT_LOG_DEBUG(Data, "sceneload: event handle {} released with its map", slot);
        handle.type = EOH_TYPE_NONE;
        handle.scene_no = -1;
        handle.world_coord = 1;
        handle.object = NULL;
    }
}

} // namespace

// An event can replace a map while its handles still name the map's parts. After the Griffon fight, s35's event 500
// loads the dungeon map d06e01 (LoadDungeonMapFile) and requests the next script, and the event step between the two
// still plays the object sequences of three s35 parts. Retail reads the freed parts there, which on the PS2 still held
// a usable vtable; the port finds it zeroed. Handles into the deleted map refer to nothing instead, so GetPos fails and
// each such sequence clears itself (CSceneObjSeq::Play).
PORT_OVERRIDE int CScene::DeleteMap(int map_index, int clear_stack) {
    CSceneMap *slot = GetSceneMap(map_index);

    if (slot != nullptr && slot->stack != nullptr && GetMap(map_index) != nullptr) {
        ForgetEventHandlesIn(*slot->stack);
    }

    return PortRetailDeleteMap(map_index, clear_stack);
}
