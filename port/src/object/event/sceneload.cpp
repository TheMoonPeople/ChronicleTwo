#include "common.h"

#include <array>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <memory>
#include <span>

#include "character.hpp"
#include "dataread.hpp"
#include "editmap.hpp"
#include "map.hpp"
#include "mapsky.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"
#include "text/bounded.hpp"

namespace dc2::scene {
/**
 *
 * Owns one aligned map-file read buffer independently of other loading requests.
 *
 */
class MapReadStorage {
    struct alignas(64) Line {
        std::array<u8, 64> bytes{}; /**< Aligned bytes of a map-file read. */
    };

    std::unique_ptr<Line[]> lines;      /**< Owning array whose alignment also covers sector reads. */
    std::size_t             line_count; /**< Actual allocated number of lines. */

public:
    /**
     *
     * Allocates the complete aligned storage requested by a map load.
     *
     */
    explicit MapReadStorage(std::size_t count) : lines(std::make_unique<Line[]>(count)), line_count(count) {}

    /**
     *
     * Returns the actual allocated bytes of this read buffer.
     *
     */
    std::span<u8> Bytes() const {
        return {reinterpret_cast<u8 *>(lines.get()), line_count * sizeof(Line)};
    }
};
} // namespace dc2::scene

static uptr        LoadMapData(SCN_LOADMAP_INFO2 &info, int deferred);
static const u_int timer0_count = 0x10000000;

namespace {
std::size_t MapLoadCapacity(const SCN_LOADMAP_INFO2 &info);

} // namespace

/**
 *
 * Loads each enabled map file into the scene stack, optionally through background I/O.
 *
 */
static uptr LoadMapData(SCN_LOADMAP_INFO2 &info, int deferred) {
    char       path[0x80];
    mgCMemory *stack = info.stack;
    u8        *load_buf = PortMapLoadBuffer(info);
    int        result = 1;
    int        i = {};
    if (stack == nullptr || stack->stack == nullptr || load_buf == nullptr) {
        return 0;
    }
    const std::uintptr_t load_begin = reinterpret_cast<std::uintptr_t>(load_buf);
    const std::size_t    load_capacity = MapLoadCapacity(info);
    const auto           load_destination = [=](const void *cursor) -> std::span<u8> {
        const std::uintptr_t address = reinterpret_cast<std::uintptr_t>(cursor);
        if (address < load_begin || address - load_begin > load_capacity) {
            return {};
        }
        return {reinterpret_cast<u8 *>(const_cast<void *>(cursor)), load_capacity - (address - load_begin)};
    };
    const auto stack_destination = [stack]() -> std::span<u8> {
        const auto available = dc2::memory::RemainingBytes(*stack);
        if (stack->lock != 0 || available.size() <= sizeof(u_long128)) {
            return {};
        }
        return available.first(available.size() - sizeof(u_long128));
    };
    info.data_ready = 1;

    if (deferred != 0) {
        StartReadBG();
    }

    for (i = 0; i < SCN_LOADMAP_FILES_MAX; i++) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info.files[i];
        int                          mpk_size = {};
        int                          sky_size = {};
        int                          ipk_size = {};
        int                          size = {};

        if (files->enable == 0) {
            break;
        }

        files->map_data = (char *) load_buf;
        dc2::text::Copy(path, dc2::text::View(files->dir));
        dc2::text::Append(path, dc2::text::View(files->map_name));
        dc2::text::Append(path, dc2::text::View(".map.json"));

        if (deferred != 0) {
            result = LoadFileBG(path, load_destination(files->map_data), &files->map_size);
        } else {
            result = LoadFile2(path, load_destination(files->map_data), &files->map_size, 0);
        }

        size = files->map_size;
        int map_rest = size % 64;

        if (map_rest != 0) {
            size += 64 - map_rest;
        }

        load_buf += size / 16 * 16;
        files->cfg_data = (char *) load_buf;
        dc2::text::Copy(path, dc2::text::View(files->dir));
        dc2::text::Append(path, dc2::text::View(files->cfg_name));
        dc2::text::Append(path, dc2::text::View(".cfg.json"));
        files->cfg_size = 0;

        if (deferred != 0) {
            LoadFileBG(path, load_destination(files->cfg_data), &files->cfg_size);
        } else {
            LoadFile2(path, load_destination(files->cfg_data), &files->cfg_size, 0);
        }

        size = files->cfg_size;
        int cfg_rest = size % 64;

        if (cfg_rest != 0) {
            size += 64 - cfg_rest;
        }

        load_buf += size / 16 * 16;
        files->mpk_data = (u_int *) load_buf;
        dc2::text::Copy(path, dc2::text::View(files->dir));
        dc2::text::Append(path, dc2::text::View(files->mpk_name));
        dc2::text::Append(path, dc2::text::View(".mpk"));

        if (deferred != 0) {
            result &= LoadFileBG(path, load_destination(files->mpk_data), &mpk_size);
        } else {
            result &= LoadFile2(path, load_destination(files->mpk_data), &mpk_size, 0);
        }

        size = mpk_size;

        if (size % 64 != 0) {
            size += 64 - size % 64;
        }

        load_buf += size / 16 * 16;
        sky_size = 0;
        files->sky_data = (u_int *) load_buf;

        if (info.load_sky != 0) {
            dc2::text::Copy(path, dc2::text::View(files->dir));
            dc2::text::Append(path, dc2::text::View(files->sky_name));
            dc2::text::Append(path, dc2::text::View(".sky"));
            char def_sky_path[0x20] = "map/";
            dc2::text::Append(def_sky_path, dc2::text::View(files->def_sky_name));
            dc2::text::Append(def_sky_path, dc2::text::View(".sky"));

            if (deferred != 0) {
                if (LoadFileBG(path, load_destination(files->sky_data), &sky_size) == 0) {
                    files->sky_data = nullptr;
                }
            } else if (LoadFile2(path, load_destination(files->sky_data), &sky_size, 0) == 0 &&
                       LoadFile2(def_sky_path, load_destination(files->sky_data), &sky_size, 0) == 0) {
                files->sky_data = nullptr;
            }
        }

        size = sky_size;

        if (size % 64 != 0) {
            size += 64 - size % 64;
        }

        load_buf += size / 16 * 16;
        stack->Align64();
        dc2::text::Copy(path, dc2::text::View(files->dir));
        dc2::text::Append(path, dc2::text::View(files->ipk_name));
        dc2::text::Append(path, dc2::text::View(".ipk"));
        files->ipk_data = (u_int *) stack->stGetTop();

        if (deferred != 0) {
            if (LoadFileBG(path, stack_destination(), &ipk_size) != 0) {
                stack->Alloc(((u_int) ipk_size & 0xF) != 0 ? ((u_int) ipk_size >> 4) + 1 : (u_int) ipk_size >> 4);
            } else {
                files->ipk_data = nullptr;
                result = 0;
            }
        } else if (LoadFile2(path, stack_destination(), &ipk_size, 0) != 0) {
            stack->Alloc(((u_int) ipk_size & 0xF) != 0 ? ((u_int) ipk_size >> 4) + 1 : (u_int) ipk_size >> 4);
        } else {
            files->ipk_data = nullptr;
            result = 0;
        }

        stack->Align64();
        dc2::text::Copy(path, dc2::text::View(files->dir));
        dc2::text::Append(path, dc2::text::View(files->efp_name));
        dc2::text::Append(path, dc2::text::View(".efp"));
        files->effect_directory = deferred != 0 ? dc2::io::QueueBackgroundRead(path) : dc2::io::ReadResourceFile(path);
    }

    if (result == 0) {
        return 0;
    }

    return (uptr) load_buf;
}

void SCN_LOADMAP_INFO2::Initialize() {
    *this = SCN_LOADMAP_INFO2{};
}

void CScene::DeleteChara(int index) {
    CSceneCharacter *chara = {};

    chara = GetSceneCharacter(index);

    if (chara != nullptr) {
        chara->Initialize();
    }
}

int CScene::CopyChara(int index, int source_index, mgCMemory *memory) {
    float        position[4];
    float        rotation[4];
    float        scale[4];
    CCharacter2 *chara = {};

    if (memory == nullptr) {
        return -1;
    }
    auto *source = GetSceneCharacter(source_index);
    if (source == nullptr || source->character.Get() == nullptr) {
        return -1;
    }
    const auto   source_resource = source->character;
    const int    source_texture = source->texb;
    CCharacter2 *original = source_resource.Get();
    chara = dc2::memory::NewObject<CCharacter2>(*memory);
    if (chara == nullptr) {
        return -1;
    }

    chara->Initialize();
    DeleteChara(index);
    int slot = AssignChara(index, dc2::scene::CharacterResource::FromArena(*memory, *chara), "chara");

    if (slot < 0) {
        return -1;
    }

    CSceneCharacter *scene_chara = GetSceneCharacter(slot);

    if (scene_chara == nullptr) {
        return slot;
    }

    scene_chara->status |= SCENE_DATA_LOADED;
    scene_chara->texb = source_texture;

    if (original == nullptr) {
        return slot;
    }

    original->GetPosition(position);
    original->GetRotation(rotation);
    original->GetScale(scale);
    original->SetPosition(0.0f, 0.0f, 0.0f);
    original->SetRotation(0.0f, 0.0f, 0.0f);
    original->SetScale(1.0f, 1.0f, 1.0f);
    original->Copy(*chara, memory);
    original->SetPosition(position);
    original->SetRotation(rotation);
    original->SetScale(scale);
    return slot;
}

int CScene::LoadMapFromMemory(int map_no, SCN_LOADMAP_INFO2 *info) {
    int step = 0;
    int next = {};

    while (1) {
        next = LoadMapFromMemory(map_no, step, info);

        if (next < 0) {
            return -1;
        }

        if (next == step) {
            break;
        }

        step = next;
    }

    return map_no;
}

template <>
void mgCObjectStack<CList<EMAP_MESSAGE>>::Initialize() {
    unk_8 = 0;
}

CMap::CMap() {
    Initialize();
}

int CScene::LoadMapBGStep(SCN_LOADMAP_INFO2 *info) {
    int step = {};
    int result = {};

    if (bg_load_step == 0) {
        return 1;
    }

    if (ReadBGSync() != 0) {
        return 0;
    }

    if (bg_load_info.data_ready != 0) {
        step = bg_load_step - 1;
        result = LoadMapFromMemory(bg_load_info.map_no, step, &bg_load_info);

        if (result < 0) {
            return 0;
        }

        if (result == step) {
            bg_load_step = 0;
            return 1;
        }

        bg_load_step = result + 1;
        return 0;
    }

    return 1;
}

int CScene::LoadMap(int map_no, SCN_LOADMAP_INFO2 *info, int deferred) {
    ClearStack(info->stack_no);
    AssignStack(info->stack_no);
    info->stack = GetStack(info->stack_no);
    info->data_ready = 1;
    info->map_no = map_no;

    if (deferred != 0) {
        if (LoadMapData(*info, 1) != 0) {
            bg_load_info = *info;
            bg_load_step = 1;
            return 0;
        }
    } else {
        if (LoadMapData(*info, 0) != 0) {
            return LoadMapFromMemory(map_no, info);
        }
    }

    return -1;
}

int CScene::DeleteMapResources(int map_index, int clear_stack) {
    mgCTextureManager *textures = &mgTexManager;
    CSceneMap         *slot = {};
    int                texture_count = {};
    int                index = {};
    CMap              *loaded_map = {};
    mgCMemory         *memory = {};
    int                texture_block = {};
    char              *file_name = {};
    slot = GetSceneMap(map_index);

    if (slot == nullptr) {
        return 0;
    }

    loaded_map = GetMap(map_index);

    if (loaded_map == nullptr) {
        return 0;
    }

    memory = slot->stack;
    texture_block = slot->tex_block;
    texture_count = slot->tex_block_num;

    if (texture_block >= 0 && texture_count > 0) {
        for (index = 0; index < texture_count; index++) {
            textures->DeleteBlock(texture_block + index);
        }
    }

    if (loaded_map->effect_list.block >= 0) {
        textures->DeleteBlock(loaded_map->effect_list.block);
    }

    for (index = 0;; index++) {
        file_name = loaded_map->map_info.GetImgName(index);

        if (file_name == nullptr) {
            break;
        }

        if (CheckIMGName(map_index, file_name) == 0) {
            mds_list_set.DeleteIMG(file_name);
        }
    }

    for (index = 0;; index++) {
        file_name = loaded_map->map_info.GetPCPName(index);

        if (file_name == nullptr) {
            break;
        }

        if (CheckMDSName(map_index, file_name) == 0) {
            mds_list_set.DeleteMdsList(file_name);
        }
    }

    loaded_map->Initialize();
    slot->Initialize();

    if (clear_stack != 0) {
        for (index = 0; index < map_num; index++) {
            CSceneMap *other_slot = GetSceneMap(index);
            if (other_slot != nullptr && other_slot->map != nullptr && other_slot->stack == memory) {
                DeleteMap(index, 0);
            }
        }
    }
    bool shared = false;
    for (index = 0; index < map_num; ++index) {
        const auto *other_slot = GetSceneMap(index);
        if (other_slot != nullptr && other_slot->map != nullptr && other_slot->stack == memory) {
            shared = true;
            break;
        }
    }
    if (memory != nullptr && !shared) {
        memory->stReset();
    }
    return 1;
}

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

#include "assets/data_registry.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "editmap.hpp"
#include "event_func.hpp"
#include "log/log.hpp"
#include "map.hpp"
#include "mapsky.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object/world/map_load_size.hpp"
#include "platform/clock.hpp"
#include "platform/model_assets.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"

// Retail's printf diagnostics, logged as the game's own (docs/LOGGING.md).
#include "log/game_output.hpp"

int CScene::LoadChara(int index, u_int *model, char *profile, mgCMemory *model_memory,
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
    auto *character = dc2::memory::NewObject<CCharacter2>(*model_memory);
    if (character == nullptr) {
        return -1;
    }
    DeleteChara(index);
    const int slot = AssignChara(index, dc2::scene::CharacterResource::FromArena(*model_memory, *character), "chara");
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

int CScene::LoadMapFromMemory(int map_no, int step, SCN_LOADMAP_INFO2 *info) {
    mgCMemory *stack = info->stack;
    int        tex_block = info->tex_block;

    if (step == SCN_LOADMAP_STEP_CREATE) {
        std::unique_ptr<CEditMap> edit_map;

        if (info->data_ready == 0) {
            return -1;
        }

        u8 *buf = info->load_buf;

        if (stack == nullptr || buf == nullptr) {
            return -1;
        }
        CT_LOG_DEBUG(Data, "sceneload: map {} loading", map_no);

        const auto producer = dc2::memory::ArenaLifetime::Capture(*stack);
        if (!producer.IsLive()) {
            return -1;
        }
        edit_map = std::make_unique<CEditMap>();
        edit_map->mds_list_set = &mds_list_set;
        auto *slot = GetSceneMap(AssignMap(map_no, edit_map.get(), info->name));
        if (slot == nullptr || !slot->OwnEditMap(std::move(edit_map))) {
            return -1;
        }
        slot->stack = stack;
        slot->BindResources(producer);
        return 1;
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
        if (files->effect_directory) {
            map->CreateEffect(files->effect_directory, info->efp_tex_block, stack);
        }

        dc2::text::Copy(mgTexManager.name_suffix, dc2::text::View("1"));

        if (map->map_info.sky_info != 0 && files->sky_data != nullptr && info->sky_tex_block > 0) {
            DeleteSky(0);

            auto *sky = dc2::memory::NewObject<CMapSky>(*stack);

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
            if (!map->SetPlacePartsBuff(stack, info->place_parts_max)) {
                return -1;
            }
        }

        map->CreateMap(&mds_list_set, stack);
        dc2::log::PrintGame("5:%u\n", static_cast<unsigned>(HostTimer0Count() - start_count));
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
        dc2::log::PrintGame("remain %dkByte\n", stack->stGetRest() * 16 / 1024);
        return SCN_LOADMAP_STEP_CFG;
    }

    return -1;
}

namespace {

// One 64-byte line, so map reads keep the alignment of retail's stAlloc64 load buffers.
std::size_t MapLoadCapacity(const SCN_LOADMAP_INFO2 &info) {
    return info.map_read_storage ? info.map_read_storage->Bytes().size() : 0;
}

// The bytes LoadMapData's cursor advances past a file: its size rounded up to 64, or nothing when it is missing.
std::size_t MapFileBytes(std::string_view dir, std::string_view name, std::string_view extension) {
    std::string path = std::format("{}{}{}", dir, name, extension);
    int         size = 0;

    if (LoadFile2(path.data(), std::span<u8>{}, &size, LOAD_FILE_SIZE) == 0 || size <= 0) {
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

        const auto dir = dc2::text::View(files.dir, sizeof(files.dir));
        bytes += MapFileBytes(dir, dc2::text::View(files.map_name, sizeof(files.map_name)), ".map.json");
        bytes += MapFileBytes(dir, dc2::text::View(files.cfg_name, sizeof(files.cfg_name)), ".cfg.json");
        bytes += MapFileBytes(dir, dc2::text::View(files.mpk_name, sizeof(files.mpk_name)), ".mpk");

        if (info.load_sky != 0) {
            // A missing map sky falls back to the common one.
            bytes += std::max(MapFileBytes(dir, dc2::text::View(files.sky_name, sizeof(files.sky_name)), ".sky"),
                              MapFileBytes("map/", dc2::text::View(files.def_sky_name, sizeof(files.def_sky_name)), ".sky"));
        }
    }

    // The reader zeroes the rest of the last file's final sector.
    return bytes + DATAREAD_SECTOR_SIZE;
}

// Each request retains its aligned file storage, including while copied background metadata is still in use.
u8 *PortMapLoadBuffer(SCN_LOADMAP_INFO2 &info) {
    constexpr std::size_t alignment = 64;
    const std::size_t     bytes = PortMapLoadBytes(info);
    const std::size_t     lines = (bytes + alignment - 1) / alignment;
    if (!info.map_read_storage || info.map_read_storage.use_count() != 1 || MapLoadCapacity(info) < bytes) {
        info.map_read_storage = std::make_shared<dc2::scene::MapReadStorage>(lines);
    }
    return info.map_read_storage->Bytes().data();
}

namespace {

/**
 * Checks whether a map-backed event handle points inside a memory arena.
 */
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

/**
 * Resets event handles whose targets belong to a released map arena.
 */
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
        handle = CEoh{};
    }
}

} // namespace

/**
 * Releases event handles into a map before deleting its resources.
 */
int CScene::DeleteMap(int map_index, int clear_stack) {
    CSceneMap *slot = GetSceneMap(map_index);

    if (slot != nullptr && slot->stack != nullptr && GetMap(map_index) != nullptr) {
        ForgetEventHandlesIn(*slot->stack);
    }

    return DeleteMapResources(map_index, clear_stack);
}
