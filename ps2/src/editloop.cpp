#include "common.h"
#include "vlgr_info.hpp"
#include "dng_effect.hpp"
#include "mglib.hpp"
#include "sphida.hpp"
#include "nowload.hpp"
#include "helpmes.hpp"
#include "sysmes.hpp"
#include "mapselect.hpp"
#include "mapjump.hpp"
#include "event.hpp"
#include "scenesnd.hpp"
#include "mg_memory.hpp"
#include "dataread.hpp"
#include "actionchara.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "editevent.hpp"
#include <cstdio>
#include "editanalyze.hpp"
#include "menucommon.hpp"
#include "nd_meswin.hpp"
#include "subgame.hpp"
#include "sound.hpp"
#include "eventedit.hpp"
#include "main.hpp"
#include "dbg_font.hpp"
#include "editdebug.hpp"
#include "editdata.hpp"
#include "editmenu.hpp"
#include "editmode.hpp"
#include "editctrl.hpp"
#include "editmap.hpp"
#include "editexception.hpp"
#include "mg_texture.hpp"
#include "sceneevent.hpp"
#include "mg_math.hpp"
#include "cameracontrol.hpp"
#include "gamepad.hpp"
#include "padcontrol.hpp"
#include "userdata.hpp"
#include "savedata.hpp"
#include "character.hpp"
#include "scene.hpp"
#include "editloop.hpp"
#include <cstring>

void EditModeChgStep(CScene *scene);

extern EditDebugInfo EdDebugInfo;
extern DEBUG_INFO DebugInfo;
extern CEditEvent EditEvent;
extern "C" int Reset__10CEditEventFv(CEditEvent *event);

static const int kEventNoMapJump = 0x1869F;
static const int kEventDataCallFlag = 8;
static const int kKeyOpenEvent = 0x96;
static const int kCameraKindEvent = 0x3E8;

extern char at_2948[];
extern char at_2949[];
extern char at_2950[];
extern char at_2951[];
extern char at_2952[];
extern char at_2953[];
extern char at_2954[];
extern char at_2955[];
extern char at_2956[];
extern char at_2957[];
extern char at_2958[];
extern char at_2261[];
extern char at_2262[];

extern mgCMemory ControlCharaBuff;
extern mgCMemory MainDataBuff;
extern EditDebugInfo EdDebugInfo;
extern int EditDrawCancelFlag;
extern int LoopCounter;
extern int LanguageCode;
extern mgCTextureManager mgTexManager;
extern CScene *MainScene__2;
extern int SubMapLoadBG;
extern int now_load_map_no;
extern u_long128 *read_buffer;
extern int MapNo;
extern int DelMainNPCflag;
extern CMapTreasureBox *TreasureBox;
extern int beforeAnalyze[16];
extern DEBUG_INFO DebugInfo;
extern CEditEvent EditEvent;
extern float at_3041[4];
extern CCharacter2 *WalkChara;
extern int ControlMode;
extern int LoopMode;
extern ClsMes EventMes1;
extern char at_2747[9];
extern "C" void LoadEditInfo__13CEditInfoMngrFPciP9mgCMemory(void *infoMngr, char *data, int size,
                                                             mgCMemory *memory);
extern "C" void CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory(CMap *map, CMapTreasureBox *boxes,
                                                                  int count, int stack);
extern "C" int Reset__10CEditEventFv(CEditEvent *event);
extern "C" void *__ct__10CRunScriptFv(void *);
extern CGamePad GamePad__2;
extern int LockChara;
extern int EditModeChgCnt;
extern int EditModeChgEvent;
extern int EditModeChgFlag;

// Code (.text)
extern "C" CUserDataManager *GetUserData__Fv__2(void) {
    CSaveData *save;

    save = GetSaveData();
    if (save != 0) {
        return &save->user_data;
    }
    return 0;
}
void InitLockCharaCtrl(void) {
    LockChara = 0;
}
void LockCharaCtrl(void) {
    LockChara++;
}
void UnLockCharaCtrl(void) {
    LockChara -= 1;
    if (LockChara < 0) {
        LockChara = 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", IsEditMode__Fv);
void InitEditModeChg(void) {
    EditModeChgFlag = 0;
    EditModeChgCnt = 0;
    EditModeChgEvent = 0;
}
int NowEditModeChg(void) {
    if (EditModeChgFlag != 0) {
        return EditModeChgCnt > 0;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditModeChg__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditModeChgStep__FP6CScene);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", SetDataPacket__Fi);
void PreExitLoop(CScene *scene) {
    BurnEditParts();
    EditDataSave();
    sgBreakSubGame();
    scene->StopBGM(0);
    scene->InitBGM();
    scene->SeAllStop();
    BreakReadBG();
    sndStopVoice(1);
    ResetNpcTalkMes();
    EdEventTermination();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditInit__F13INIT_LOOP_ARG);
CameraCtrlParam &CameraCtrlParam::operator=(const CameraCtrlParam &src) {
    min_dist = src.min_dist;
    max_dist = src.max_dist;
    near_height = src.near_height;
    far_height = src.far_height;
    height = src.height;
    max_height = src.max_height;
    min_height = src.min_height;
    rest_max_height = src.rest_max_height;
    rest_min_height = src.rest_min_height;
    ground_space = src.ground_space;
    no_check = src.no_check;
    return *this;
}
CActionChara::CActionChara() {
    memset(&move_check, 0, sizeof(move_check));
}
void EditExit(void) {
    sndSeAllStop(1);
    MainScene__2->InitSeSrc();
    mgCloseFont();
    BreakReadBG();
    sndStopVoice(1);
    if (SubGameRunning() != 0) {
        sgExitSubGame();
    }
}
void InitSubMapLoadStep(void) {
    SubMapLoadBG = 0;
    now_load_map_no = -1;
}
int SubMapLoadStep(void) {
    CScene *scene;
    if (MainScene__2->LoadMapBGStep(0) != 0) {
        if (SubMapLoadBG != 0) {
            SubMapLoadBG = 0;
            MainScene__2->SetActive(2, 1);
            MainScene__2->LoadSubVillager(GetSubMapNo(), 0x5E);
            MainScene__2->PreLoadVillagerEnd();
            char *name = GetMapName(now_load_map_no, 0);
            scene = MainScene__2;
            EditMapInitEvent(now_load_map_no, (CEditMap *)scene->GetMap(scene->GetMapID(name)));
            now_load_map_no = -1;
        }
        return 0;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditLoop__Fv);
void InitEditEvent(void) {
    InitLockCharaCtrl();
    Reset__10CEditEventFv(&EditEvent);
}
void ResetEditEvent() {
    if (EditEvent.state == 1) {
        Reset__10CEditEventFv(&EditEvent);
        UnLockCharaCtrl();
    }
}
void RestartEditEvent() {
    if (EditEvent.state == 1) {
        ResetEditEvent();
        if (EditEvent.StartEvent(&MainScene__2->event_data) != 0) {
            LockCharaCtrl();
        }
    }
}
int EditStep(void) {
    CEditMap *maps[8];
    float viewer[24];
    int event_no;
    int map_count;
    int index;
    CSceneEventData *event_data;
    CCameraControl *camera;
    CEditMap *map;
    CCharacter2 *chara;

    chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
    WalkChara = chara;
    if (chara != NULL) {
        chara->foot_se_bank = MainScene__2->se_base_id;
    }
    EditModeChgStep(MainScene__2);
    if (MainScene__2->event_run != 0) {
        event_no = MainScene__2->event_no;
        printf(at_2261, event_no);
        event_data = &MainScene__2->event_data;
        if (event_no == kEventNoMapJump) {
            if (EditEvent.StartEvent( event_data) != 0) {
                camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
                if (camera == NULL || camera->Iam() != kCameraKindEvent) {
                    return 0;
                }
                if ((event_data->event.flag & kEventDataCallFlag) != 0) {
                    event_no = event_data->event.unk_34;
                    if (event_no > 0) {
                        printf(at_2262, event_no);
                        if (RunEvent(event_data->event.unk_34, MainScene__2) > 0) {
                            ResetViewMode(MainScene__2);
                            ControlMode = 2;
                        }
                    }
                }
                LockCharaCtrl();
            }
        } else {
            InitEvent(MainScene__2);
            MainScene__2->before_camera = MainScene__2->active_camera;
            if (RunEvent(event_no, MainScene__2) > 0) {
                ResetViewMode(MainScene__2);
                ControlMode = 2;
            }
        }
        MainScene__2->event_run = 0;
    }
    if (GamePad__2.Down2(0x80) != 0) {
        InitEvent(MainScene__2);
        ReloadMapScript();
        MainScene__2->before_camera = MainScene__2->active_camera;
        if (RunEvent(kKeyOpenEvent, MainScene__2) != 0) {
            ControlMode = 2;
        }
    }
    map_count = MainScene__2->GetActiveMap((CMap **)maps, 8);
    if (WalkChara != NULL) {
        *(u_long128 *)viewer = *(u_long128 *)WalkChara->position;
        viewer[4] = MainScene__2->time;
        index = 0;
        if (0 < map_count) {
            do {
                map = maps[index];
                if (map != NULL) {
                    map->AnimeStep((CObjAnimeEnv *)viewer);
                    maps[index]->Step();
                }
                index += 1;
            } while (index < map_count);
        }
    }
    MainScene__2->PrePlaySeSrc();
    MainScene__2->PlayMapSeSrc();
    if (LoopMode != 2) {
        EditStepChara(MainScene__2);
    }
    MainScene__2->EffectStep();
    MainScene__2->StepEffectScript(-1);
    if (InInterior() == 0) {
        StepFirePowder(MainScene__2);
        StepGeyserEffect(MainScene__2);
    }
    camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
    if (camera != NULL) {
        camera->Step(1);
    }
    EditExceptionStep(MapNo, MainScene__2);
    EventMes1.Step();
    GetSystemMessage()->Step();
    GetSystemMessage(1)->Step();
    GetSystemMessage(2)->Step();
    StepHelpMes();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditDraw__Fv);
void UpdateTrBoxFlag(int map_no) {
    int i;
    CMapFlagData *flag_data = (CMapFlagData *)GetSaveData()->GetMapFlag(map_no);
    CMap *map = MainScene__2->GetMap(MainScene__2->active_map);
    map->UpdateTrBoxFlag(flag_data);
    int box_count = map->tr_box_num;

    CSaveDataDungeon *dungeon_save = &GetSaveData()->save_dungeon;
    for (i = 0; i < box_count; i++) {
        CMapTreasureBox *box = map->GetTrBox(i);
        if (box != NULL) {

            DNG_FLOOR_SAVE *floor = (DNG_FLOOR_SAVE *)dungeon_save->GetFloorInfoPtr(
                box->floor_id / 100 - 1, box->floor_id % 100);
            if (floor != NULL && (u16)floor->visit_count <= 0) {
                map->DeleteTrBox(i, NULL);
            }
        }
    }
}
int BurnEditParts(void) {
    CEditMap::RemoveInfo info;
    CEditMap *map;
    int i;
    int id;
    if (GetSaveData()->GetBitFlag(0x208) != 0) {
        return 0;
    }
    if (MainScene__2->GetMainMapNo() == 3) {
        map = (CEditMap *)MainScene__2->GetMap(MainScene__2->active_map);
        if (map != NULL) {
            memset(&info, 0, sizeof(info));
            map->BurnEditParts(&info);
            for (i = 0; i < info.house_num; i++) {
                GetSaveData()->user_data.LeaveHouse(info.house_npc[i]);
            }
            id = 0;
            do {
                CEditPartsInfo *river_info = map->GetePartsInfoAtID(id);

                if (river_info != NULL && !(river_info->attr & 0x8000) &&
                    !(river_info->attr & 0x1000)) {
                    int count = info.parts_num[id];
                    if (count > 0) {
                        GetSaveData()->AddBuildPartsNum(id, count);
                    }
                }
                id++;
            } while (id < 0x100);
            return 1;
        }
    }
    return 0;
}
void editLoadSound(int map_no) {
    int sound_data_id;
    int bgm_no;

    sound_data_id = GetMapSndDataID(map_no);
    MainScene__2->LoadSound(sound_data_id, read_buffer);
    if (MainScene__2->skip_load_bgm == 0) {
        bgm_no = MainScene__2->GetDefBgmNo(sound_data_id);
        if (bgm_no == -1) {
            MainScene__2->StopBGM(0);
        }

        if ((MainScene__2->CheckLoadBGM(bgm_no) == 0) || (bgm_no == 0x270F)) {
            MainScene__2->PlayBGM(0, -1, 1.0f);
            return;
        }
        MainScene__2->StopBGM(0);
        if (MainScene__2->LoadBGM(bgm_no, read_buffer) != 0) {
            MainScene__2->PlayBGM(0, -1, 1.0f);
            if (bgm_no == 0) {
                MainScene__2->AutoChangeBGMVol(1);
                MainScene__2->StepSnd();
                sndStep(2.0f);
            }
        }
    } else {
        MainScene__2->skip_load_bgm = 0;
    }
}
int EditMapJump(int map_no) {
    SCN_LOADMAP_INFO2 load_info;
    char path[0x88];
    int file_size;
    char size_text[4];
    int sub_map_no;
    char *map_name;
    mgCMemory *main_data;
    int area_no;
    CEditMap *map;
    mgCTextureManager *textures;
    int used_before;
    CCameraControl *camera;
    CameraCtrlParam *param;
    CEditData *edit_data;
    int loaded_sub;
    int used_quads;
    int used_kb;
    int free_quads;

    InitEditEvent();
    DeleteFileCache();
    textures = &mgTexManager;
    sub_map_no = map_no;
    if (map_no > 0xA && map_no < 0xF) {
        map_no = 0xA;
    } else {
        sub_map_no = -1;
    }
    InitSubMapLoadStep();
    map_name = GetMapName(map_no, NULL);
    if (map_name == NULL) {
        printf(at_2948, map_no);
        return 0;
    }
    MainScene__2->SeAllStop();
    EditDataSave();
    MainScene__2->ResetWind();
    InitSphida();
    mgWaitFrame();
    if (GetMapType(map_no) == 1) {
        SetDataPacket(2);
    } else {
        SetDataPacket(1);
    }
    free_quads = ControlCharaBuff.stack_size;
    ControlCharaBuff.lock = 1;
    MainDataBuff.stSetBuffer((u_long128 *)(ControlCharaBuff.stack + ControlCharaBuff.stack_used),
                             free_quads - ControlCharaBuff.stack_used);
    MainDataBuff.stack_used = 0;
    MainDataBuff.lock = 0;
    printf(at_2949, MainDataBuff.stack + MainDataBuff.stack_used);
    load_info.Initialize();
    if (GetLoadMapInfo(&load_info, map_no) == 0) {
        return 0;
    }
    if (map_no == SearchMapNo(at_2950) &&
        ((CEditData *)GetSaveData()->GetEditData(0))->GetAnalyzeFlag(0, 3) == 0) {
        strcat(load_info.files[0].map_name, at_2951);
        strcat(load_info.files[0].mpk_name, at_2951);
        strcat(load_info.files[0].ipk_name, at_2951);
    }
    MainScene__2->DeleteVillager();
    MainScene__2->DeleteSubVillager();
    MapJump(MainScene__2, &load_info, map_no);
    EditMapInitEvent(map_no, (CEditMap *)MainScene__2->GetMap(0));
    main_data = &MainDataBuff;
    ResetNpcTalkMes();
    if (map_no == 0xA || map_no == 0x22 || map_no == 0x79) {
        main_data->Align64();
        LoadNpcTalkMes(main_data);
    }
    NowLoadingBarStep();
    MapNo = SearchMapNo(map_name);
    MainScene__2->SetNowMapNo(MapNo);
    EdEventMapInit();
    if (GetMapType(MapNo) == 1) {
        used_before = main_data->stack_used;
        map = (CEditMap *)MainScene__2->GetMap(0);
        map->CreateTable(main_data, 0x100, 0xA000);
        GetMapPath(path, map_name);
        sprintf(size_text, at_2952, LanguageCode);
        strcat(path, size_text);
        strcat(path, at_2953);
        if (LoadFile2(path, (void *)read_buffer, &file_size, 0) != 0) {
            LoadEditInfo__13CEditInfoMngrFPciP9mgCMemory(&map->info_mngr, (char *)read_buffer,
                                                         file_size, main_data);
        }
        GetMapPath(path, map_name);
        strcat(path, at_2954);
        if (LoadFile2(path, (void *)read_buffer, &file_size, 0) != 0) {
            map->LoadEditInfo((char *)read_buffer, file_size, main_data);
        }
        map->area_no = MainScene__2->now_map_no;
        map->ClearAllParts();
        used_quads = main_data->stack_used - used_before;
        used_kb = (used_quads * 0x10) / 0x400;
        printf(at_2955, used_kb);
        EditDataLoad();
        if (map_no == 0) {
            map->river_poly_margin = 15.0f;
        }
    }
    NowLoadingBarStep();
    MainScene__2->LoadGameObject(map_no, 0xA4, main_data);
    if (GetMapType(MapNo) == 5) {
        area_no = 0;
        SearchMapNo(at_2950);
        if (map_no == SearchMapNo(at_2956)) {
            area_no = 1;
        }
        if (map_no == SearchMapNo(at_2957)) {
            area_no = 2;
        }
        if (map_no == SearchMapNo(at_2958)) {
            area_no = 3;
        }
        edit_data = (CEditData *)GetSaveData()->GetEditData(area_no);
        map = (CEditMap *)MainScene__2->GetMap(MainScene__2->active_map);
        if (map != NULL) {
            map->PartsOnOff(area_no, edit_data);
        }
    }
    map = (CEditMap *)MainScene__2->GetMap(MainScene__2->active_map);
    if (map != NULL) {
        if (TreasureBox != NULL) {
            CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory((CMap *)map, TreasureBox, 0xAD,
                                                              (int)main_data);
            UpdateTrBoxFlag(MapNo);
        }
        map->now_time = MainScene__2->time;
    }
    InitFirePowder(map_no, MainScene__2, 0xD0, main_data);
    InitGeyserEffect(map_no, MainScene__2, 0xD1, main_data);
    EditControlInit(MainScene__2);
    NowLoadingBarStep();
    editLoadSound(map_no);
    NowLoadingBarStep();
    MainScene__2->DeleteVillager();
    MainScene__2->LoadVillager(MapNo, 0x4E);
    NowLoadingBarStep();
    if (sub_map_no > 0) {
        loaded_sub = LoadSubMap(MainScene__2, sub_map_no, 0);
        NowLoadingBarStep();
        if (loaded_sub != 0) {
            MainScene__2->SetActive(2, 1);
            MainScene__2->LoadSubVillager(GetSubMapNo(), 0x5E);
            EditMapInitEvent(sub_map_no, (CEditMap *)MainScene__2->GetMap(1));
        }
        NowLoadingBarStep();
    } else {
        NowLoadingBarStep();
        NowLoadingBarStep();
    }
    area_no = MapNo;
    if (area_no == SearchMapNo(at_2950)) {
        area_no = 0;
    }
    if (MapNo == SearchMapNo(at_2956)) {
        area_no = 1;
    }
    if (MapNo == SearchMapNo(at_2957)) {
        area_no = 2;
    }
    if (MapNo == SearchMapNo(at_2958)) {
        area_no = 3;
    }
    EdDebugInfo.edit_data_no = area_no;
    EdDebugInfo.edit_data = (CEditData *)GetSaveData()->GetEditData(area_no);
    mgPlightEnable(0);
    MainScene__2->UpDateMapInfo();
    camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
    if (camera != NULL) {
        param = camera->GetActiveParam();
        param->min_dist = camera->default_param.min_dist;
        param->max_dist = camera->default_param.max_dist;
        param->near_height = camera->default_param.near_height;
        param->far_height = camera->default_param.far_height;
        param->height = camera->default_param.height;
        param->max_height = camera->default_param.max_height;
        param->min_height = camera->default_param.min_height;
        param->rest_max_height = camera->default_param.rest_max_height;
        param->rest_min_height = camera->default_param.rest_min_height;
        param->ground_space = camera->default_param.ground_space;
        param->no_check = camera->default_param.no_check;
    }
    textures->ReloadTexture(-1, (sceVif1Packet *)NULL);
    LoopCounter = 0;
    EditDrawCancelFlag = 1;
    InitS51Thunder();
    return 1;
}
int EditGotoInterior(int interior_no, int delete_villagers) {
    float door_pos[4];
    int stack;
    CMap *map;
    InitEditEvent();
    DeleteFileCache();
    EditDataSave();
    MainScene__2->StopSeSrc();
    DelMainNPCflag = 0;
    if (delete_villagers != 0) {
        MainScene__2->DeleteVillager();
        DelMainNPCflag = 1;
    }
    MainScene__2->DeleteSubVillager();
    if (InInterior() != 0) {
        InteriorMapJump(MainScene__2, interior_no);
    } else {
        GotoInterior(MainScene__2, interior_no);
    }
    editLoadSound(interior_no);
    stack =
        (int)MainScene__2->GetStack(3);
    map = MainScene__2->GetMap(MainScene__2->active_map);
    if (map != NULL && TreasureBox != NULL) {
        CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory(map, TreasureBox, 0xAD, stack);
        UpdateTrBoxFlag(interior_no);
    }
    MainScene__2->LoadSubVillager(interior_no, 0x5E);
    MainScene__2->SetActiveVillager();
    EditControlInit(MainScene__2);
    if (EditEvent.door_se >= 0) {
        MainScene__2->SePlayCloseDoor(EditEvent.door_se, door_pos);
    }
    mgPlightEnable(0);
    MainScene__2->UpDateMapInfo();
    return 1;
}
int EditExitInterior(int interior_no) {
    int exit_map_no;
    float door_pos[4];
    int villager_time;
    int saved_time;
    InitEditEvent();
    DeleteFileCache();
    MainScene__2->StopSeSrc();
    MainScene__2->DeleteSubVillager();
    villager_time = MainScene__2->GetNowVillagerTime();
    saved_time =
        MainScene__2->villager_time;
    if (DelMainNPCflag != 0 || villager_time != saved_time) {
        DeleteInterior(MainScene__2);
        MainScene__2->DeleteVillager();
        MainScene__2->LoadVillager(GetMainMapNo(), 0x4E);
    }
    exit_map_no = -1;
    ExitInterior(MainScene__2, &exit_map_no);
    EditMapInitEvent(exit_map_no, (CEditMap *)MainScene__2->GetMap(1));
    MainScene__2->LoadSubVillager(GetSubMapNo(), 0x5E);
    MainScene__2->SetActiveVillager();
    EditControlInit(MainScene__2);
    if (EditEvent.door_se >= 0) {
        MainScene__2->SePlayCloseDoor(EditEvent.door_se, door_pos);
    }
    MainScene__2->LoadSound(GetMapSndDataID(GetMainMapNo()), read_buffer);
    mgPlightEnable(0);
    MainScene__2->UpDateMapInfo();
    return 1;
}
void EditDataSave(void) {
    CEditData *edit_data;
    CEditMap *map;

    if (InInterior() == 0) {
        edit_data = (CEditData *)(GetSaveData()->GetEditData(MapNo));
        if (edit_data != NULL) {
            map = (CEditMap *)(MainScene__2->GetMap(MainScene__2->active_map));
            if ((map != NULL) && (strcmp(map->Iam(), at_2747) == 0) && (map != NULL)) {
                map->SaveData(edit_data);
                GetSaveData()->GetBitFlag(0x208);
                edit_data->culture_point = map->CultureAnalyze(0);
                edit_data->save_count += 1;
                map->GroundBalance(0);
                map->UpdateHouse();
                if ((DebugInfo.georama_debug == 0) && (GetMapType(MapNo) == 1)) {
                    AnalyzeEditMap(MapNo, map);
                }
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditDataLoad__Fv);
void KeepEditAnalyze() {
    CEditData *edit_data = (CEditData *)GetSaveData()->GetEditData(MapNo);
    for (int entry = 0; entry < 16; entry++) {
        beforeAnalyze[entry] = edit_data->GetAnalyzeFlag(MapNo, entry);
    }
}
int EditAnalyzeChanged() {
    if (GetGameChapter(GetSaveData()->game_progress) >= 8) {
        return 0;
    }
    CEditData *edit_data = (CEditData *)GetSaveData()->GetEditData(MapNo);
    for (int entry = 0; entry < 16; entry++) {
        int analyze_flag = edit_data->GetAnalyzeFlag(MapNo, entry);
        if (analyze_flag != beforeAnalyze[entry]) {
            return 1;
        }
    }
    return 0;
}
void LoadComVillaager(void) {
}
void LoadMap(void) {
    LoadComVillaager();
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", __sinit_editloop_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1045__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1053__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1528__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2271__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_3040__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1032__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1033__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1395__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1396__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1397__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1398__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1399__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1400__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1401__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1402__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1403__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1404__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1405__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1406__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1407__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1408__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1409__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1410__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1411__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1412__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1413__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1414__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1415__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1416__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1417__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1418__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1419__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1420__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1421__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1422__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2125__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2126__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2127__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2128__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2129__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2130__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2131__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2132__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2133__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2134__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2136__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2261__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2262__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2747__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2748__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2749__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2750__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2751__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2752__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2753__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2948__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2949__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2950__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2951__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2952__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2953__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2954__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2955__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2956__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2957__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2958__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", D_0037B00C__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", MenuInfo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", DataPktMode__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2346__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2352__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(WaterFrame, 0x4);
INCLUDE_BSS(RedBicMark, 0x4);
INCLUDE_BSS(BlueBicMark, 0x4);
INCLUDE_BSS(TreasureBox, 0x4);
INCLUDE_BSS(MapNo, 0x4);
INCLUDE_BSS(Camera, 0x4);
static INCLUDE_BSS(EventCamera, 0x4);
INCLUDE_BSS(FixCamera, 0x4);
INCLUDE_BSS(EditCamera, 0x4);
INCLUDE_BSS(ActiveCharaNo, 0x4);
INCLUDE_BSS(ControlCharaID, 0x4);
INCLUDE_BSS(WalkChara, 0x4);
INCLUDE_BSS(LoopCounter, 0x4);
INCLUDE_BSS(LoopMode, 0x4);
INCLUDE_BSS(ControlMode, 0x4);
INCLUDE_BSS(SubMapLoadBG, 0x4);
INCLUDE_BSS(now_load_map_no, 0x4);
INCLUDE_BSS(EventSquareJump, 0x4);
INCLUDE_BSS(EditDrawFlag, 0x4);
INCLUDE_BSS(EditDrawCancelFlag, 0x4);
INCLUDE_BSS(PauseFlag, 0x4);
INCLUDE_BSS(LockChara, 0x4);
INCLUDE_BSS(PreEditMenuCnt, 0x4);
INCLUDE_BSS(EditModeChgFlag, 0x4);
INCLUDE_BSS(EditModeChgCnt, 0x4);
INCLUDE_BSS(EditModeChgEvent, 0x4);
INCLUDE_BSS(MainScene__2, 0x4);
INCLUDE_BSS(main_pkt1, 0x4);
INCLUDE_BSS(main_pkt2, 0x4);
INCLUDE_BSS(read_buffer_end, 0x4);
INCLUDE_BSS(MenuDataBuf, 0x4);
INCLUDE_BSS(MenuDataSize, 0x4);
INCLUDE_BSS(FixCharaBuffSize, 0x4);
INCLUDE_BSS(CrossFadeBuff, 0x4);
INCLUDE_BSS(time_step_1481, 0x4);
INCLUDE_BSS(init_1482, 0x4);
INCLUDE_BSS(show_time_step_1484, 0x4);
INCLUDE_BSS(init_1485, 0x4);
INCLUDE_BSS(old_cm_1772, 0x4);
INCLUDE_BSS(rain_flag_1849, 0x4);
INCLUDE_BSS(init_1850, 0x4);
INCLUDE_BSS(start_bt_cnt_1865, 0x4);
INCLUDE_BSS(init_1866, 0x4);
INCLUDE_BSS(encount_flag_1868, 0x4);
INCLUDE_BSS(init_1869, 0x4);
INCLUDE_BSS(show_encount_cnt_1871, 0x4);
INCLUDE_BSS(init_1872, 0x4);
INCLUDE_BSS(next_encount_1874, 0x4);
INCLUDE_BSS(init_1875, 0x4);
INCLUDE_BSS(flag_2408, 0x4);
INCLUDE_BSS(init_2409, 0x4);
INCLUDE_BSS(DelMainNPCflag, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_949, 0x10);
INCLUDE_BSS(WaveTable, 0x1210);
INCLUDE_BSS(CharaOldPos, 0x10);
INCLUDE_BSS(EventMes1, 0x2960);
INCLUDE_BSS(buf0, 0x30);
INCLUDE_BSS(buf1, 0x30);
INCLUDE_BSS(data_buf__2, 0x60);
INCLUDE_BSS(init_dbuf, 0x60);
INCLUDE_BSS(WorkBuffer, 0x30);
INCLUDE_BSS(MenuBuffer__2, 0x30);
INCLUDE_BSS(ChrEffBuffer, 0x30);
INCLUDE_BSS(ScriptBuffer__2, 0x30);
INCLUDE_BSS(TotalDataBuff, 0x30);
INCLUDE_BSS(ControlCharaBuff, 0x30);
INCLUDE_BSS(MainDataBuff, 0x30);
INCLUDE_BSS(MainCharaBuff, 0x30);
INCLUDE_BSS(SubDataBuff, 0x30);
INCLUDE_BSS(SubCharaBuff, 0x30);
INCLUDE_BSS(EventBuff, 0xC0);
INCLUDE_BSS(CharaBufs, 0x180);
INCLUDE_BSS(FishingBuff, 0x30);
INCLUDE_BSS(SkyBuff, 0x30);
INCLUDE_BSS(EditEvent, 0x150);
INCLUDE_BSS(EdDebugInfo, 0x40);
INCLUDE_BSS(TestVisual, 0x50);
INCLUDE_BSS(TestFrame, 0x110);
INCLUDE_BSS(at_1077, 0x10);
INCLUDE_BSS(at_3041, 0x10);
INCLUDE_BSS(beforeAnalyze, 0x40);
