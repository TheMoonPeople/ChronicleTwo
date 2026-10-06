#include <cstdio>
#include "vlgr_info.hpp"
#include "scene.hpp"
#include "mglib.hpp"
#include "mg_math.hpp"
#include "mapselect.hpp"
#include "mainloop.hpp"
#include "event.hpp"
#include "dataread.hpp"
#include "common.h"
#include "editmap.hpp"
#include "mg_memory.hpp"
#include "mg_camera.hpp"
#include "savedata.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"
#include "mapjump.hpp"
#include <cstring>

struct ScriptPathBuffer { char text[0x80]; };
extern int NowMainMapNo;
extern int NowSubMapNo;
extern int NowInteriorMapNo;
extern int OldInteriorMapNo;
extern mgCMemory * ScriptBuffer;
extern int InteriorFlag;
static MapJumpMapInfo MainMapInfo__2;
static MapJumpMapInfo SubMapInfo;
extern ScriptPathBuffer at_912__4;
extern char now_script_file[0x40];
extern char old_mapname[0x40];
extern char PrevInterior[0x40];
extern char NowInterior[0x40];
extern int old_bgm_no;
extern sceVu0FVECTOR OldPos;
extern sceVu0FVECTOR OldRot;
extern sceVu0FVECTOR OldCamPos;
extern sceVu0FVECTOR OldCamRef;
extern CScene::BGM_STATUS OldBgmStatus;
extern char at_1047__2[];
extern char at_863__3[];
extern char at_890__4[];
extern char at_891__3[];
extern char at_892__2[];
extern char at_893__2[];
extern char at_894__2[];
extern char at_914__4[];
extern char at_950__4[];
extern char at_1091__2[];
int GetMainMapNo(void);
int GetSubMapNo(void);
void ClearSubMapNo(void);
void SetMainMapInfo(MapJumpMapInfo *info);
void SetSubMapInfo(MapJumpMapInfo *info);
void SetScriptBuffer(mgCMemory *buffer);
void PreLoadSync(void);
int MapJump(CScene *scene, SCN_LOADMAP_INFO2 *info, int mapIndex);
int GetLoadMapInfo(SCN_LOADMAP_INFO2 *info, int mapNo);
int LoadSubMap(CScene *scene, int subMapNo, int flag);
void LoadMapScript(char *mapName);
void ReloadMapScript(void);
void LoadScript(char *path);
int GetOldInteriorMapNo(void);
void InitInterior(void);
int InInterior(void);
void GotoInterior(CScene *scene, int interiorNo);
void DeleteInterior(CScene *scene);
int InteriorMapJump(CScene *scene, int interiorNo);

// Code (.text)
int GetMainMapNo(void) {
    return NowMainMapNo;
}
int GetSubMapNo(void) {
    return NowSubMapNo;
}
void ClearSubMapNo(void) {
    NowSubMapNo = -1;
}
MapJumpMapInfo::MapJumpMapInfo() {
    memset(this, 0, 0x18);
}
void SetMainMapInfo(MapJumpMapInfo *info) {
    MainMapInfo__2.map_no = info->map_no;
    MainMapInfo__2.tex_block = info->tex_block;
    MainMapInfo__2.stack_no = info->stack_no;
    MainMapInfo__2.efp_tex_block = info->efp_tex_block;
    MainMapInfo__2.sky_tex_block = info->sky_tex_block;
    MainMapInfo__2.load_buf = info->load_buf;
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
void PreLoadSync(void) {
    ReadBG();
    ReadBGSync();
}
int MapJump(CScene *scene, SCN_LOADMAP_INFO2 *info, int mapIndex) {
    char *mapName = GetMapName(mapIndex, NULL);
    if (mapName == NULL) {
        printf(at_863__3, mapIndex);
        return 0;
    }
    scene->StopSeSrc();
    sndSeAllStop(1);
    int charaIndex;

    CSaveData *saveData = GetSaveData();
    s16 *mapNos = (&saveData->map_no);
    (&saveData->map_no)[2] = (s16)NowMainMapNo;
    mgWaitFrame();
    mgInitLighting();
    scene->DeleteMap(SubMapInfo.map_no, 1);
    scene->DeleteMap(MainMapInfo__2.map_no, 1);
    NowMainMapNo = -1;
    NowSubMapNo = -1;
    for (charaIndex = 0; charaIndex < 0x38; charaIndex++) {
        scene->DeleteChara(charaIndex + 8);
    }
    scene->ClearStack(1);
    NowMainMapNo = SearchMapNo(mapName);
    scene->SetNowMapNo(NowMainMapNo);
    mapNos[0] = (s16)NowMainMapNo;
    mapNos[3] = -1;
    mapNos[1] = -1;
    int areaNo = GetMapAreaNo(NowMainMapNo);
    if (areaNo > 0) {
        *(int *)(mapNos + 4) = areaNo;
    }
    info->load_sky = 1;
    if (scene->LoadMap(MainMapInfo__2.map_no, info, 0) < 0) {
        return 0;
    }
    scene->SetActive(2, MainMapInfo__2.map_no);
    scene->active_map = MainMapInfo__2.map_no;
    CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
    if (map != NULL) {
        map->now_time = scene->time;
    }
    LoadMapScript(mapName);
    InitInterior();
    NowInteriorMapNo = -1;
    OldInteriorMapNo = -1;
    GetSaveData()->ResetBitCtrl(1);
    return 1;
}
int GetLoadMapInfo(SCN_LOADMAP_INFO2 *info, int mapNo) {
    char mapPath[0x40];
    char fileName[0x20];
    char addPath[0x80];
    char addDirectory[0x40];
    char *mapName = GetMapName(mapNo, NULL);
    if (mapName == NULL) {
        printf(at_863__3, mapNo);
        return 0;
    }
    info->tex_block = MainMapInfo__2.tex_block;
    info->stack_no = MainMapInfo__2.stack_no;
    info->load_buf = MainMapInfo__2.load_buf;
    info->efp_tex_block = MainMapInfo__2.efp_tex_block;
    info->sky_tex_block = MainMapInfo__2.sky_tex_block;
    if (info->place_parts_max <= 0) {
        info->place_parts_max = 0x140;
    }
    GAME_PROGRESS_INFO *progress = GetGameProgressInfo(GetSaveData()->game_progress);
    GetMapPath(mapPath, mapName);
    DivPathName(mapPath, info->files[0].dir, fileName);
    info->files[0].enable = 1;
    strcpy(info->files[0].map_name, fileName);
    strcpy(info->files[0].cfg_name, fileName);
    strcpy(info->files[0].mpk_name, fileName);
    strcpy(info->files[0].ipk_name, fileName);
    strcpy(info->files[0].efp_name, fileName);
    strcpy(info->files[0].sky_name, fileName);
    strcpy(info->files[0].def_sky_name, at_890__4);
    if (progress != NULL) {
        s16 chapter = progress->chapter;
        if (chapter >= 8 && chapter < 10) {
            strcat(info->files[0].sky_name, at_891__3);
            strcat(info->files[0].def_sky_name, at_891__3);
        }
    }
    strcpy(info->name, fileName);
    char *addMapPath = GetAddMapPath(mapNo);
    if (addMapPath != NULL && *addMapPath != 0) {
        strcpy(addPath, (char *)addMapPath);
        info->files[1].enable = 1;
        if (progress != NULL) {
            s16 chapter = progress->chapter;
            if (chapter >= 6) {
                if (chapter < 8 && strcmp(addPath, at_892__2) == 0) {
                    strcpy(addPath, at_893__2);
                }
            }
        }
        DivPathName(addPath, addDirectory, fileName);
        strcpy(info->files[1].dir, at_894__2);
        strcat(info->files[1].dir, addDirectory);
        strcpy(info->files[1].map_name, fileName);
        strcpy(info->files[1].cfg_name, fileName);
        strcpy(info->files[1].mpk_name, fileName);
        strcpy(info->files[1].ipk_name, fileName);
        strcpy(info->files[1].efp_name, fileName);
    }
    return 1;
}
int LoadSubMap(CScene *scene, int subMapNo, int flag) {
    char *mapName = GetMapName(subMapNo, NULL);
    if (mapName == NULL) {
        printf(at_863__3, subMapNo);
        return 0;
    }
    mgWaitFrame();
    scene->DeleteMap(SubMapInfo.map_no, 1);
    scene->DeleteSubVillager();
    SCN_LOADMAP_INFO2 info;
    char mapPath[0x40];
    char fileName[0x20];
    info.tex_block = SubMapInfo.tex_block;
    info.stack_no = SubMapInfo.stack_no;
    info.load_buf = SubMapInfo.load_buf;
    info.efp_tex_block = SubMapInfo.efp_tex_block;
    strcpy(info.name, mapName);
    if (info.place_parts_max <= 0) {
        info.place_parts_max = 0x140;
    }
    GetMapPath(mapPath, mapName);
    DivPathName(mapPath, info.files[0].dir, fileName);
    info.files[0].enable = 1;
    strcpy(info.files[0].map_name, fileName);
    strcpy(info.files[0].cfg_name, fileName);
    strcpy(info.files[0].mpk_name, fileName);
    strcpy(info.files[0].ipk_name, fileName);
    strcpy(info.files[0].efp_name, fileName);
    strcpy(info.name, fileName);
    if (scene->LoadMap(SubMapInfo.map_no, &info, flag) < 0) {
        return 0;
    }
    CSaveData *saveData = GetSaveData();

    s16 *subMapNos = (&saveData->map_no);
    subMapNos[3] = NowSubMapNo;
    scene->SetNowSubMapNo(subMapNo);
    NowSubMapNo = subMapNo;
    subMapNos[1] = subMapNo;
    return 1;
}
void LoadMapScript(char *mapName) {
    char mapPath[0x80];
    ScriptPathBuffer script = at_912__4;
    GetMapPath(mapPath, mapName);
    strcat(script.text, mapPath);
    strcat(script.text, at_914__4);
    LoadScript(script.text);
    strcpy((char *)now_script_file, script.text);
}
void ReloadMapScript(void) {
    if (now_script_file[0] != 0)
        LoadScript((char *)now_script_file);
}
void LoadScript(char *path) {
    char localizedPath[0x100];
    char languageSuffix[0x1C];
    int fileSize;

    {
        mgCMemory *memory = ScriptBuffer;
        memory->stack_used = 0;
        memory->lock = 0;
    }
    ScriptBuffer->Align64();
    u8 *buffer = (u8 *)(ScriptBuffer->stack + ScriptBuffer->stack_used);
    int length = strlen(path);
    if (length >= 5) {
        strncpy(localizedPath, path, length - 4);
        localizedPath[length - 4] = 0;
        sprintf(languageSuffix, at_950__4, LanguageCode);
        strcat(localizedPath, languageSuffix);
        if (LoadFile2(localizedPath, buffer, &fileSize, 0) != 0) {
            u32 blocks;
            if (fileSize & 0xF) {
                blocks = ((u32)fileSize >> 4) + 1;
            } else {
                blocks = (u32)fileSize >> 4;
            }
            ScriptBuffer->Alloc(blocks);
            SetEventScript((char *)buffer, NULL, ScriptBuffer);
            return;
        }

        if (LoadFile2(path, buffer, &fileSize, 0) != 0) {
            u32 blocks;
            if (fileSize & 0xF) {
                blocks = ((u32)fileSize >> 4) + 1;
            } else {
                blocks = (u32)fileSize >> 4;
            }
            ScriptBuffer->Alloc(blocks);
            SetEventScript((char *)buffer, NULL, ScriptBuffer);
            return;
        }
        SetEventScript(NULL, NULL, NULL);
    }
}
int GetOldInteriorMapNo(void) {
    if (InInterior() != 0) {
        return -1;
    }
    return OldInteriorMapNo;
}
void InitInterior(void) {
    old_mapname[0] = 0;
    InteriorFlag = 0;
    PrevInterior[0] = 0;
    NowInterior[0] = 0;
}
int InInterior(void) {
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
    CFuncPoint *point;
    CMap *map = scene->GetMap(scene->active_map);
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
        if ((point->event.flag & FUNC_EVENT_DOOR) && strcmp(door_name, point->event.unk_38) == 0) {
            sceVu0FVECTOR position;
            sceVu0FVECTOR rotation;
            *(u_long128 *)position = *(u_long128 *)point->position;
            *(u_long128 *)rotation = *(u_long128 *)point->rotation;
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
void GotoInterior(CScene *scene, int interiorNo) {
    char *mapName = GetMapName(interiorNo, NULL);
    if (mapName != NULL && InInterior() == 0) {
        mgWaitFrame();
        SaveBeforeInterior(scene);
        if (LoadSubMap(scene, interiorNo, 0) != 0) {
            scene->SetActive(2, SubMapInfo.map_no);
            scene->ResetActive(2, MainMapInfo__2.map_no);
            scene->active_map = SubMapInfo.map_no;
            SetInteriorDoorPos(scene);
        }
        if (GetMapType(interiorNo) == 2) {
            LoadMapScript(at_1047__2);
        } else {
            LoadMapScript(mapName);
        }
        scene->SetNowMapNo(-1);
        scene->SetNowMapNo(NowMainMapNo);
        OldInteriorMapNo = NowInteriorMapNo;
        NowInteriorMapNo = NowMainMapNo;
        CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
        if (map != NULL) {
            map->now_time = scene->time;
        }
        strcpy(NowInterior, mapName);
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
        chara->SetMotion(at_1091__2, 4);
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
    scene->SetActive(2, MainMapInfo__2.map_no);
    scene->active_map = MainMapInfo__2.map_no;
    OldInteriorMapNo = NowInteriorMapNo;
    NowInteriorMapNo = -1;
    CMap *map = scene->GetMap(scene->active_map);
    if (map != NULL) {
        map->now_time = scene->time;
    }
    LoadMapScript(scene->GetMapName(MainMapInfo__2.map_no));
    PrevInterior[0] = 0;
    NowInterior[0] = 0;
    InitInterior();
    if (old_bgm_no >= 0) {
        scene->LoadBGM(old_bgm_no, read_buffer);
        scene->SetActiveBgmStatus(&OldBgmStatus);
    }
}
int InteriorMapJump(CScene *scene, int interiorNo) {
    if (LoadSubMap(scene, interiorNo, 0) != 0) {
        scene->SetActive(2, SubMapInfo.map_no);
        scene->ResetActive(2, MainMapInfo__2.map_no);
        scene->active_map = SubMapInfo.map_no;
        char *mapName = GetMapName(interiorNo, NULL);
        strcpy(PrevInterior, NowInterior);
        if (mapName != NULL) {
            strcpy(NowInterior, mapName);
        } else {
            NowInterior[0] = 0;
        }
        SetInteriorDoorPos(scene);
        LoadMapScript(mapName);
        OldInteriorMapNo = NowInteriorMapNo;
        NowInteriorMapNo = interiorNo;
        return 1;
    }
    return 0;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_997__4__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_863__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_890__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_891__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_892__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_893__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_894__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_914__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_950__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_1047__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapjump", at_1091__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(NowMainMapNo, 0x4);
INCLUDE_BSS(NowSubMapNo, 0x4);
INCLUDE_BSS(NowInteriorMapNo, 0x4);
INCLUDE_BSS(OldInteriorMapNo, 0x4);
INCLUDE_BSS(ScriptBuffer, 0x4);
INCLUDE_BSS(InteriorFlag, 0x4);
INCLUDE_BSS(old_bgm_no, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(now_script_file, 0x40);
INCLUDE_BSS(at_912__4, 0x80);
INCLUDE_BSS(old_mapname, 0x40);
INCLUDE_BSS(OldPos, 0x10);
INCLUDE_BSS(OldRot, 0x10);
INCLUDE_BSS(OldCamPos, 0x10);
INCLUDE_BSS(OldCamRef, 0x10);
INCLUDE_BSS(PrevInterior, 0x40);
INCLUDE_BSS(NowInterior, 0x40);
INCLUDE_BSS(OldBgmStatus, 0x20);
