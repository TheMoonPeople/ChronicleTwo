#include "common.h"

#include <cstdio>
#include <cstring>
#include <format>
#include <string>
#include <utility>

#include "dataread.hpp"
#include "editmap.hpp"
#include "event.hpp"
#include "log/game_output.hpp"
#include "mainloop.hpp"
#include "mapjump.hpp"
#include "mapselect.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"
#include "text/bounded.hpp"
#include "vlgr_info.hpp"

/**
 *
 * Map-slot and resource settings for the main map.
 *
 */
static MapJumpMapInfo MainMapInfo;

/**
 *
 * Map-slot and resource settings for the sub map.
 *
 */
static MapJumpMapInfo SubMapInfo;

/**
 *
 * Number of the loaded main map.
 *
 */
static int NowMainMapNo;

/**
 *
 * Number of the loaded sub map.
 *
 */
static int NowSubMapNo;

/**
 *
 * Number of the current interior map.
 *
 */
static int NowInteriorMapNo;

/**
 *
 * Number of the previous interior map.
 *
 */
static int OldInteriorMapNo;

/**
 *
 * Memory stack used to load map event scripts.
 *
 */
static mgCMemory *ScriptBuffer;

/**
 *
 * Whether the player is inside an interior.
 *
 */
static int InteriorFlag;

/**
 *
 * Music bank saved before entering an interior.
 *
 */
static int old_bgm_no;

/**
 *
 * Path of the most recently loaded map script.
 *
 */
static std::string now_script_file;

/**
 *
 * Sub-map name saved before entering an interior.
 *
 */
static char old_mapname[0x40];

/**
 *
 * Player position saved before entering an interior.
 *
 */
static sceVu0FVECTOR OldPos;

/**
 *
 * Player rotation saved before entering an interior.
 *
 */
static sceVu0FVECTOR OldRot;

/**
 *
 * Camera position saved before entering an interior.
 *
 */
static sceVu0FVECTOR OldCamPos;

/**
 *
 * Camera target saved before entering an interior.
 *
 */
static sceVu0FVECTOR OldCamRef;

/**
 *
 * Name of the interior exited when positioning its door.
 *
 */
static char PrevInterior[0x40];

/**
 *
 * Name of the current interior.
 *
 */
static char NowInterior[0x40];

/**
 *
 * Music playback state saved before entering an interior.
 *
 */
static CScene::BGM_STATUS OldBgmStatus;

int GetMainMapNo() {
    return NowMainMapNo;
}

int GetSubMapNo() {
    return NowSubMapNo;
}

void ClearSubMapNo() {
    NowSubMapNo = -1;
}

MapJumpMapInfo::MapJumpMapInfo() {
    memset(this, 0, sizeof(*this));
}

void SetMainMapInfo(MapJumpMapInfo *info) {
    MainMapInfo.map_no = info->map_no;
    MainMapInfo.tex_block = info->tex_block;
    MainMapInfo.stack_no = info->stack_no;
    MainMapInfo.efp_tex_block = info->efp_tex_block;
    MainMapInfo.sky_tex_block = info->sky_tex_block;
    MainMapInfo.load_buf = info->load_buf;
}

void SetSubMapInfo(MapJumpMapInfo *info) {
    SubMapInfo.map_no = info->map_no;
    SubMapInfo.tex_block = info->tex_block;
    SubMapInfo.stack_no = info->stack_no;
    SubMapInfo.efp_tex_block = info->efp_tex_block;
    SubMapInfo.sky_tex_block = info->sky_tex_block;
    SubMapInfo.load_buf = info->load_buf;
}

void SetScriptBuffer(mgCMemory *buffer) {
    ScriptBuffer = buffer;
}

int PreLoadSync() {
    ReadBG();
    return ReadBGSync();
}

void DeleteJumpMaps(CScene *scene) {
    scene->DeleteMap(SubMapInfo.map_no, 1);
    scene->DeleteMap(MainMapInfo.map_no, 1);
}

int MapJump(CScene *scene, SCN_LOADMAP_INFO2 *info, int map_index) {
    char *map_name = GetMapName(map_index, nullptr);

    if (map_name == nullptr) {
        dc2::log::PrintGame("not found map %d\n", map_index);
        return 0;
    }

    scene->StopSeSrc();
    sndSeAllStop(1);
    int chara_index = {};

    CSaveData *save_data = GetSaveData();
    save_data->prev_map_no = static_cast<s16>(NowMainMapNo);
    mgWaitFrame();
    mgInitLighting();
    DeleteJumpMaps(scene);
    NowMainMapNo = -1;
    NowSubMapNo = -1;

    for (chara_index = 0; chara_index < 0x38; chara_index++) {
        scene->DeleteChara(chara_index + 8);
    }

    scene->ClearStack(1);
    NowMainMapNo = SearchMapNo(map_name);
    scene->SetNowMapNo(NowMainMapNo);
    save_data->map_no = static_cast<s16>(NowMainMapNo);
    save_data->prev_sub_map_no = -1;
    save_data->sub_map_no = -1;
    int area_no = GetMapAreaNo(NowMainMapNo);

    if (area_no > 0) {
        save_data->area_no = area_no;
    }

    info->load_sky = 1;

    if (scene->LoadMap(MainMapInfo.map_no, info, 0) < 0) {
        return 0;
    }

    scene->SetActive(SCENE_DATA_MAP, MainMapInfo.map_no);
    scene->active_map = MainMapInfo.map_no;
    CEditMap *map = static_cast<CEditMap *>(scene->GetMap(scene->active_map));

    if (map != nullptr) {
        map->now_time = scene->time;
    }

    LoadMapScript(map_name);
    InitInterior();
    NowInteriorMapNo = -1;
    OldInteriorMapNo = -1;
    GetSaveData()->ResetBitCtrl(1);
    return 1;
}

int GetLoadMapInfo(SCN_LOADMAP_INFO2 *info, int map_no) {
    char  add_path[0x80];
    char *map_name = GetMapName(map_no, nullptr);

    if (map_name == nullptr) {
        dc2::log::PrintGame("not found map %d\n", map_no);
        return 0;
    }

    info->tex_block = MainMapInfo.tex_block;
    info->stack_no = MainMapInfo.stack_no;
    info->load_buf = MainMapInfo.load_buf;
    info->efp_tex_block = MainMapInfo.efp_tex_block;
    info->sky_tex_block = MainMapInfo.sky_tex_block;

    if (info->place_parts_max <= 0) {
        info->place_parts_max = 0x140;
    }

    GAME_PROGRESS_INFO *progress = GetGameProgressInfo(GetSaveData()->game_progress);
    const std::string   map_path = dc2::world::MapPath(map_name);
    const auto [map_directory, file_name] = DivPathName(map_path);
    dc2::text::Copy(info->files[0].dir, map_directory);
    info->files[0].enable = 1;
    dc2::text::Copy(info->files[0].map_name, file_name);
    dc2::text::Copy(info->files[0].cfg_name, file_name);
    dc2::text::Copy(info->files[0].mpk_name, file_name);
    dc2::text::Copy(info->files[0].ipk_name, file_name);
    dc2::text::Copy(info->files[0].efp_name, file_name);
    dc2::text::Copy(info->files[0].sky_name, file_name);
    dc2::text::Copy(info->files[0].def_sky_name, dc2::text::View("def"));

    if (progress != nullptr) {
        s16 chapter = progress->chapter;

        if (chapter >= 8 && chapter < 10) {
            dc2::text::Append(info->files[0].sky_name, dc2::text::View("b"));
            dc2::text::Append(info->files[0].def_sky_name, dc2::text::View("b"));
        }
    }

    dc2::text::Copy(info->name, file_name);
    char *add_map_path = GetAddMapPath(map_no);

    if (add_map_path != nullptr && *add_map_path != 0) {
        dc2::text::Copy(add_path, dc2::text::View(add_map_path));
        info->files[1].enable = 1;

        if (progress != nullptr) {
            s16 chapter = progress->chapter;

            if (chapter >= 6) {
                if (chapter < 8 && strcmp(add_path, "trn/train") == 0) {
                    dc2::text::Copy(add_path, dc2::text::View("trn2/s36"));
                }
            }
        }

        const auto [add_directory, add_file_name] = DivPathName(add_path);
        dc2::text::Copy(info->files[1].dir, dc2::text::View("map/cmn/"));
        dc2::text::Append(info->files[1].dir, add_directory);
        dc2::text::Copy(info->files[1].map_name, add_file_name);
        dc2::text::Copy(info->files[1].cfg_name, add_file_name);
        dc2::text::Copy(info->files[1].mpk_name, add_file_name);
        dc2::text::Copy(info->files[1].ipk_name, add_file_name);
        dc2::text::Copy(info->files[1].efp_name, add_file_name);
    }

    return 1;
}

int LoadSubMap(CScene *scene, int sub_map_no, int flag) {
    char *map_name = GetMapName(sub_map_no, nullptr);

    if (map_name == nullptr) {
        dc2::log::PrintGame("not found map %d\n", sub_map_no);
        return 0;
    }

    mgWaitFrame();
    scene->DeleteMap(SubMapInfo.map_no, 1);
    scene->DeleteSubVillager();
    SCN_LOADMAP_INFO2 info;
    info.tex_block = SubMapInfo.tex_block;
    info.stack_no = SubMapInfo.stack_no;
    info.load_buf = SubMapInfo.load_buf;
    info.efp_tex_block = SubMapInfo.efp_tex_block;
    dc2::text::Copy(info.name, dc2::text::View(map_name));

    if (info.place_parts_max <= 0) {
        info.place_parts_max = 0x140;
    }

    const std::string map_path = dc2::world::MapPath(map_name);
    const auto [map_directory, file_name] = DivPathName(map_path);
    dc2::text::Copy(info.files[0].dir, map_directory);
    info.files[0].enable = 1;
    dc2::text::Copy(info.files[0].map_name, file_name);
    dc2::text::Copy(info.files[0].cfg_name, file_name);
    dc2::text::Copy(info.files[0].mpk_name, file_name);
    dc2::text::Copy(info.files[0].ipk_name, file_name);
    dc2::text::Copy(info.files[0].efp_name, file_name);
    dc2::text::Copy(info.name, file_name);

    if (scene->LoadMap(SubMapInfo.map_no, &info, flag) < 0) {
        return 0;
    }

    CSaveData *save_data = GetSaveData();

    save_data->prev_sub_map_no = NowSubMapNo;
    scene->SetNowSubMapNo(sub_map_no);
    NowSubMapNo = sub_map_no;
    save_data->sub_map_no = sub_map_no;
    return 1;
}

void LoadMapScript(char *map_name) {
    if (map_name == nullptr) {
        return;
    }
    std::string script = dc2::world::MapPath(map_name) + ".stb";
    LoadScript(script);
    now_script_file = std::move(script);
}

void ReloadMapScript() {
    if (!now_script_file.empty()) {
        LoadScript(now_script_file);
    }
}

void LoadScript(std::string_view path) {
    const std::string original_path(path);
    SetEventScript({}, nullptr);
    if (ScriptBuffer == nullptr || original_path.size() < 5 || original_path.find('\0') != std::string::npos) {
        return;
    }

    ScriptBuffer->stClearUsed();
    ScriptBuffer->stSetLocked(false);
    ScriptBuffer->Align64();
    const auto destination = dc2::memory::RemainingBytes(*ScriptBuffer);
    if (destination.empty()) {
        return;
    }
    const auto load = [&](std::string candidate) {
        int file_size{};
        if (LoadFile2(candidate.data(), destination, &file_size, LOAD_FILE_READ) == 0 || file_size <= 0) {
            return false;
        }
        const auto size = static_cast<std::size_t>(file_size);
        const auto quadwords = dc2::memory::ArrayQuadwords<u8>(size);
        if (size > destination.size() || !quadwords ||
            destination.size() / sizeof(u_long128) <= static_cast<std::size_t>(*quadwords) ||
            ScriptBuffer->Alloc(*quadwords) == nullptr) {
            return false;
        }
        SetEventScript(destination.first(size), ScriptBuffer);
        return true;
    };
    const auto localized_path = original_path.substr(0, original_path.size() - 4) + std::format("_{}.stb", LanguageCode);
    if (!load(localized_path)) {
        static_cast<void>(load(original_path));
    }
}

int GetOldInteriorMapNo() {
    if (InInterior() != 0) {
        return -1;
    }

    return OldInteriorMapNo;
}

void InitInterior() {
    old_mapname[0] = 0;
    InteriorFlag = 0;
    PrevInterior[0] = 0;
    NowInterior[0] = 0;
}

int InInterior() {
    return InteriorFlag;
}

void SaveBeforeInterior(CScene *scene) {
    char *map_name = scene->GetMapName(SubMapInfo.map_no);

    if (map_name != nullptr) {
        dc2::text::Copy(old_mapname, dc2::text::View(map_name));
    }

    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);

    if (chara != nullptr) {
        chara->GetPosition(OldPos);
        chara->GetRotation(OldRot);
    }

    old_bgm_no = scene->GetActiveBgmInfo()->load_no;
    scene->GetActiveBgmStatus(&OldBgmStatus);
    mgCCamera *camera = scene->GetCamera(scene->active_camera);

    if (camera != nullptr) {
        camera->GetPos(OldCamPos);
        camera->GetRef(OldCamRef);
    }
}

void SetInteriorDoorPos(CScene *scene) {
    CFuncPoint  *point = {};
    CMap        *map = scene->GetMap(scene->active_map);
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);

    if (map == nullptr || chara == nullptr) {
        return;
    }

    char door_name[0x40] = "exit";

    if (PrevInterior[0] != 0) {
        dc2::text::Copy(door_name, dc2::text::View(PrevInterior));
    }

    chara->SetPosition(0.0f, 0.0f, 0.0f);
    chara->SetRotation(0.0f, 0.0f, 0.0f);
    map->func_point.GetStart(FUNC_POINT_EVENT);

    while ((point = map->func_point.Get()) != nullptr) {
        if ((point->event.flag & FUNC_EVENT_DOOR) && strcmp(door_name, point->event.target) == 0) {
            sceVu0FVECTOR position;
            sceVu0FVECTOR rotation;
            std::memmove(position, point->position, sizeof(float) * 4);
            std::memmove(rotation, point->rotation, sizeof(float) * 4);
            rotation[2] = 0.0f;
            rotation[0] = 0.0f;
            rotation[1] = mgAngleLimit(PI + rotation[1]);
            chara->SetPosition(position);
            chara->SetRotation(rotation);
            mgCCamera *camera = scene->GetCamera(scene->active_camera);

            if (camera != nullptr) {
                camera->Step(-1);
            }

            return;
        }
    }
}

void GotoInterior(CScene *scene, int interior_no) {
    char *map_name = GetMapName(interior_no, nullptr);

    if (map_name != nullptr && InInterior() == 0) {
        mgWaitFrame();
        SaveBeforeInterior(scene);

        if (LoadSubMap(scene, interior_no, 0) != 0) {
            scene->SetActive(SCENE_DATA_MAP, SubMapInfo.map_no);
            scene->ResetActive(SCENE_DATA_MAP, MainMapInfo.map_no);
            scene->active_map = SubMapInfo.map_no;
            SetInteriorDoorPos(scene);
        }

        if (GetMapType(interior_no) == MAP_TYPE_GEORAMA_INTERIOR) {
            LoadMapScript("g00");
        } else {
            LoadMapScript(map_name);
        }

        scene->SetNowMapNo(-1);
        scene->SetNowMapNo(NowMainMapNo);
        OldInteriorMapNo = NowInteriorMapNo;
        NowInteriorMapNo = NowMainMapNo;
        CEditMap *map = static_cast<CEditMap *>(scene->GetMap(scene->active_map));

        if (map != nullptr) {
            map->now_time = scene->time;
        }

        dc2::text::Copy(NowInterior, dc2::text::View(map_name));
        PrevInterior[0] = 0;
        InteriorFlag = 1;
    }
}

void DeleteInterior(CScene *scene) {
    if (InInterior() != 0) {
        mgWaitFrame();
        scene->DeleteMap(SubMapInfo.map_no, 1);
        scene->DeleteSubVillager();
        NowSubMapNo = -1;
        s16 *p = &(&GetSaveData()->map_no)[1];
        *p = -1;
    }
}

void ExitInterior(CScene *scene, int *map_no) {
    if (!InInterior()) {
        return;
    }

    DeleteInterior(scene);
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);

    if (chara != nullptr) {
        chara->SetMotion("\x97\xa7\x82\xbf", 4);
        chara->SetPosition(OldPos);
        chara->SetRotation(0.0f, mgAngleLimit(PI + OldRot[1]), 0.0f);
        chara->ResetDAPosition();
        chara->Step();
        chara->StepDA(10);
    }

    mgCCamera *camera = scene->GetCamera(scene->active_camera);

    if (camera != nullptr) {
        camera->SetPos(OldCamPos);
        camera->SetRef(OldCamRef);
    }

    ClearSubMapNo();

    if (map_no != nullptr) {
        *map_no = -1;
    }

    if (old_mapname[0] != 0) {
        int old_map_no = SearchMapNo(old_mapname);

        if (map_no != nullptr) {
            *map_no = old_map_no;
        }

        if (old_map_no >= 0 && LoadSubMap(scene, old_map_no, 0) != 0) {
            scene->SetActive(SCENE_DATA_MAP, SubMapInfo.map_no);
        }
    } else {
        scene->SetNowSubMapNo(-1);
    }

    scene->SetActive(SCENE_DATA_MAP, MainMapInfo.map_no);
    scene->active_map = MainMapInfo.map_no;
    OldInteriorMapNo = NowInteriorMapNo;
    NowInteriorMapNo = -1;
    CMap *map = scene->GetMap(scene->active_map);

    if (map != nullptr) {
        map->now_time = scene->time;
    }

    LoadMapScript(scene->GetMapName(MainMapInfo.map_no));
    PrevInterior[0] = 0;
    NowInterior[0] = 0;
    InitInterior();

    if (old_bgm_no >= 0) {
        scene->LoadBGM(old_bgm_no, ReadBufferBytes());
        scene->SetActiveBgmStatus(&OldBgmStatus);
    }
}

int InteriorMapJump(CScene *scene, int interior_no) {
    if (LoadSubMap(scene, interior_no, 0) != 0) {
        scene->SetActive(SCENE_DATA_MAP, SubMapInfo.map_no);
        scene->ResetActive(SCENE_DATA_MAP, MainMapInfo.map_no);
        scene->active_map = SubMapInfo.map_no;
        char *map_name = GetMapName(interior_no, nullptr);
        dc2::text::Copy(PrevInterior, dc2::text::View(NowInterior));

        if (map_name != nullptr) {
            dc2::text::Copy(NowInterior, dc2::text::View(map_name));
        } else {
            NowInterior[0] = 0;
        }

        SetInteriorDoorPos(scene);
        LoadMapScript(map_name);
        OldInteriorMapNo = NowInteriorMapNo;
        NowInteriorMapNo = interior_no;
        return 1;
    }

    return 0;
}
