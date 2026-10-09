#include "common.h"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "editmap.hpp"
#include "event.hpp"
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
static char now_script_file[0x40];

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

// Code (.text)
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
    memset(this, 0, 0x18);
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

int MapJump(CScene *scene, SCN_LOADMAP_INFO2 *info, int map_index) {
    char *map_name = GetMapName(map_index, NULL);

    if (map_name == NULL) {
        printf("not found map %d\n", map_index);
        return 0;
    }

    scene->StopSeSrc();
    sndSeAllStop(1);
    int chara_index;

    CSaveData *save_data = GetSaveData();
    s16       *map_nos = (&save_data->map_no);
    (&save_data->map_no)[2] = (s16) NowMainMapNo;
    mgWaitFrame();
    mgInitLighting();
    scene->DeleteMap(SubMapInfo.map_no, 1);
    scene->DeleteMap(MainMapInfo.map_no, 1);
    NowMainMapNo = -1;
    NowSubMapNo = -1;

    for (chara_index = 0; chara_index < 0x38; chara_index++) {
        scene->DeleteChara(chara_index + 8);
    }

    scene->ClearStack(1);
    NowMainMapNo = SearchMapNo(map_name);
    scene->SetNowMapNo(NowMainMapNo);
    map_nos[0] = (s16) NowMainMapNo;
    map_nos[3] = -1;
    map_nos[1] = -1;
    int area_no = GetMapAreaNo(NowMainMapNo);

    if (area_no > 0) {
        *(int *) (map_nos + 4) = area_no;
    }

    info->load_sky = 1;

    if (scene->LoadMap(MainMapInfo.map_no, info, 0) < 0) {
        return 0;
    }

    scene->SetActive(2, MainMapInfo.map_no);
    scene->active_map = MainMapInfo.map_no;
    CEditMap *map = (CEditMap *) scene->GetMap(scene->active_map);

    if (map != NULL) {
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
    char  map_path[0x40];
    char  file_name[0x20];
    char  add_path[0x80];
    char  add_directory[0x40];
    char *map_name = GetMapName(map_no, NULL);

    if (map_name == NULL) {
        printf("not found map %d\n", map_no);
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
    GetMapPath(map_path, map_name);
    DivPathName(map_path, info->files[0].dir, file_name);
    info->files[0].enable = 1;
    strcpy(info->files[0].map_name, file_name);
    strcpy(info->files[0].cfg_name, file_name);
    strcpy(info->files[0].mpk_name, file_name);
    strcpy(info->files[0].ipk_name, file_name);
    strcpy(info->files[0].efp_name, file_name);
    strcpy(info->files[0].sky_name, file_name);
    strcpy(info->files[0].def_sky_name, "def");

    if (progress != NULL) {
        s16 chapter = progress->chapter;

        if (chapter >= 8 && chapter < 10) {
            strcat(info->files[0].sky_name, "b");
            strcat(info->files[0].def_sky_name, "b");
        }
    }

    strcpy(info->name, file_name);
    char *add_map_path = GetAddMapPath(map_no);

    if (add_map_path != NULL && *add_map_path != 0) {
        strcpy(add_path, add_map_path);
        info->files[1].enable = 1;

        if (progress != NULL) {
            s16 chapter = progress->chapter;

            if (chapter >= 6) {
                if (chapter < 8 && strcmp(add_path, "trn/train") == 0) {
                    strcpy(add_path, "trn2/s36");
                }
            }
        }

        DivPathName(add_path, add_directory, file_name);
        strcpy(info->files[1].dir, "map/cmn/");
        strcat(info->files[1].dir, add_directory);
        strcpy(info->files[1].map_name, file_name);
        strcpy(info->files[1].cfg_name, file_name);
        strcpy(info->files[1].mpk_name, file_name);
        strcpy(info->files[1].ipk_name, file_name);
        strcpy(info->files[1].efp_name, file_name);
    }

    return 1;
}

int LoadSubMap(CScene *scene, int sub_map_no, int flag) {
    char *map_name = GetMapName(sub_map_no, NULL);

    if (map_name == NULL) {
        printf("not found map %d\n", sub_map_no);
        return 0;
    }

    mgWaitFrame();
    scene->DeleteMap(SubMapInfo.map_no, 1);
    scene->DeleteSubVillager();
    SCN_LOADMAP_INFO2 info;
    char              map_path[0x40];
    char              file_name[0x20];
    info.tex_block = SubMapInfo.tex_block;
    info.stack_no = SubMapInfo.stack_no;
    info.load_buf = SubMapInfo.load_buf;
    info.efp_tex_block = SubMapInfo.efp_tex_block;
    strcpy(info.name, map_name);

    if (info.place_parts_max <= 0) {
        info.place_parts_max = 0x140;
    }

    GetMapPath(map_path, map_name);
    DivPathName(map_path, info.files[0].dir, file_name);
    info.files[0].enable = 1;
    strcpy(info.files[0].map_name, file_name);
    strcpy(info.files[0].cfg_name, file_name);
    strcpy(info.files[0].mpk_name, file_name);
    strcpy(info.files[0].ipk_name, file_name);
    strcpy(info.files[0].efp_name, file_name);
    strcpy(info.name, file_name);

    if (scene->LoadMap(SubMapInfo.map_no, &info, flag) < 0) {
        return 0;
    }

    CSaveData *save_data = GetSaveData();

    s16 *sub_map_nos = (&save_data->map_no);
    sub_map_nos[3] = NowSubMapNo;
    scene->SetNowSubMapNo(sub_map_no);
    NowSubMapNo = sub_map_no;
    sub_map_nos[1] = sub_map_no;
    return 1;
}

void LoadMapScript(char *map_name) {
    char map_path[0x80];
    char script[0x80] = "";
    GetMapPath(map_path, map_name);
    strcat(script, map_path);
    strcat(script, ".stb");
    LoadScript(script);
    strcpy(now_script_file, script);
}

void ReloadMapScript() {
    if (now_script_file[0] != 0) {
        LoadScript(now_script_file);
    }
}

void LoadScript(char *path) {
    char localized_path[0x100];
    char language_suffix[0x1C];
    int  file_size;

    {
        mgCMemory *memory = ScriptBuffer;
        memory->stack_used = 0;
        memory->lock = 0;
    }
    ScriptBuffer->Align64();
    u8 *buffer = (u8 *) (ScriptBuffer->stack + ScriptBuffer->stack_used);
    int length = strlen(path);

    if (length >= 5) {
        strncpy(localized_path, path, length - 4);
        localized_path[length - 4] = 0;
        sprintf(language_suffix, "_%d.stb", LanguageCode);
        strcat(localized_path, language_suffix);

        if (LoadFile2(localized_path, buffer, &file_size, 0) != 0) {
            u32 blocks;

            if (file_size & 0xF) {
                blocks = ((u32) file_size >> 4) + 1;
            } else {
                blocks = (u32) file_size >> 4;
            }

            ScriptBuffer->Alloc(blocks);
            SetEventScript((char *) buffer, NULL, ScriptBuffer);
            return;
        }

        if (LoadFile2(path, buffer, &file_size, 0) != 0) {
            u32 blocks;

            if (file_size & 0xF) {
                blocks = ((u32) file_size >> 4) + 1;
            } else {
                blocks = (u32) file_size >> 4;
            }

            ScriptBuffer->Alloc(blocks);
            SetEventScript((char *) buffer, NULL, ScriptBuffer);
            return;
        }

        SetEventScript(NULL, NULL, NULL);
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

    if (map_name != NULL) {
        strcpy(old_mapname, map_name);
    }

    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);

    if (chara != NULL) {
        chara->GetPosition(OldPos);
        chara->GetRotation(OldRot);
    }

    old_bgm_no = scene->GetActiveBgmInfo()->load_no;
    scene->GetActiveBgmStatus(&OldBgmStatus);
    mgCCamera *camera = scene->GetCamera(scene->active_camera);

    if (camera != NULL) {
        camera->GetPos(OldCamPos);
        camera->GetRef(OldCamRef);
    }
}

void SetInteriorDoorPos(CScene *scene) {
    CFuncPoint  *point;
    CMap        *map = scene->GetMap(scene->active_map);
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);

    if (map == NULL || chara == NULL) {
        return;
    }

    char door_name[0x40] = "exit";

    if (PrevInterior[0] != 0) {
        strcpy(door_name, PrevInterior);
    }

    chara->SetPosition(0.0f, 0.0f, 0.0f);
    chara->SetRotation(0.0f, 0.0f, 0.0f);
    map->func_point.GetStart(FUNC_POINT_EVENT);

    while ((point = map->func_point.Get()) != NULL) {
        if ((point->event.flag & FUNC_EVENT_DOOR) && strcmp(door_name, point->event.target) == 0) {
            sceVu0FVECTOR position;
            sceVu0FVECTOR rotation;
            *(u_long128 *) position = *(u_long128 *) point->position;
            *(u_long128 *) rotation = *(u_long128 *) point->rotation;
            rotation[2] = 0.0f;
            rotation[0] = 0.0f;
            rotation[1] = mgAngleLimit(3.1415927f + rotation[1]);
            chara->SetPosition(position);
            chara->SetRotation(rotation);
            mgCCamera *camera = scene->GetCamera(scene->active_camera);

            if (camera != NULL) {
                camera->Step(-1);
            }

            return;
        }
    }
}

void GotoInterior(CScene *scene, int interior_no) {
    char *map_name = GetMapName(interior_no, NULL);

    if (map_name != NULL && InInterior() == 0) {
        mgWaitFrame();
        SaveBeforeInterior(scene);

        if (LoadSubMap(scene, interior_no, 0) != 0) {
            scene->SetActive(2, SubMapInfo.map_no);
            scene->ResetActive(2, MainMapInfo.map_no);
            scene->active_map = SubMapInfo.map_no;
            SetInteriorDoorPos(scene);
        }

        if (GetMapType(interior_no) == 2) {
            LoadMapScript("g00");
        } else {
            LoadMapScript(map_name);
        }

        scene->SetNowMapNo(-1);
        scene->SetNowMapNo(NowMainMapNo);
        OldInteriorMapNo = NowInteriorMapNo;
        NowInteriorMapNo = NowMainMapNo;
        CEditMap *map = (CEditMap *) scene->GetMap(scene->active_map);

        if (map != NULL) {
            map->now_time = scene->time;
        }

        strcpy(NowInterior, map_name);
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

    if (chara != NULL) {
        chara->SetMotion("\x97\xa7\x82\xbf", 4);
        chara->SetPosition(OldPos);
        chara->SetRotation(0.0f, mgAngleLimit(3.1415927f + OldRot[1]), 0.0f);
        chara->ResetDAPosition();
        chara->Step();
        chara->StepDA(10);
    }

    mgCCamera *camera = scene->GetCamera(scene->active_camera);

    if (camera != NULL) {
        camera->SetPos(OldCamPos);
        camera->SetRef(OldCamRef);
    }

    ClearSubMapNo();

    if (map_no != NULL) {
        *map_no = -1;
    }

    if (old_mapname[0] != 0) {
        int old_map_no = SearchMapNo(old_mapname);

        if (map_no != NULL) {
            *map_no = old_map_no;
        }

        if (old_map_no >= 0 && LoadSubMap(scene, old_map_no, 0) != 0) {
            scene->SetActive(2, SubMapInfo.map_no);
        }
    } else {
        scene->SetNowSubMapNo(-1);
    }

    scene->SetActive(2, MainMapInfo.map_no);
    scene->active_map = MainMapInfo.map_no;
    OldInteriorMapNo = NowInteriorMapNo;
    NowInteriorMapNo = -1;
    CMap *map = scene->GetMap(scene->active_map);

    if (map != NULL) {
        map->now_time = scene->time;
    }

    LoadMapScript(scene->GetMapName(MainMapInfo.map_no));
    PrevInterior[0] = 0;
    NowInterior[0] = 0;
    InitInterior();

    if (old_bgm_no >= 0) {
        scene->LoadBGM(old_bgm_no, read_buffer);
        scene->SetActiveBgmStatus(&OldBgmStatus);
    }
}

int InteriorMapJump(CScene *scene, int interior_no) {
    if (LoadSubMap(scene, interior_no, 0) != 0) {
        scene->SetActive(2, SubMapInfo.map_no);
        scene->ResetActive(2, MainMapInfo.map_no);
        scene->active_map = SubMapInfo.map_no;
        char *map_name = GetMapName(interior_no, NULL);
        strcpy(PrevInterior, NowInterior);

        if (map_name != NULL) {
            strcpy(NowInterior, map_name);
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
