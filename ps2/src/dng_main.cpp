#include "common.h"
#include "mg_drawprim.hpp"
#include "automap.hpp"
#include "effscript.hpp"
#include "maintex.hpp"
#include "monster.hpp"
#include "font.hpp"
#include "cameracontrol.hpp"
#include "event_func.hpp"
#include "menucommon.hpp"
#include "water.hpp"
#include "photo.hpp"
#include "event.hpp"
#include "mglib.hpp"
#include "quest.hpp"
#include "mapload.hpp"
#include "mainloop.hpp"
#include <cmath>
#include <cstdlib>
#include <cstdio>
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_seseq.hpp"
#include "mg_drawenv.hpp"
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "dng_status.hpp"
#include "dng_debug.hpp"
#include "actionchara.hpp"
#include "character.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "dng_hud.hpp"
#include "mg_camera.hpp"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"
#include "dng_main.hpp"

#include <cmath>
#include <cstdio>
#include <cstring>

extern int wep_effect_cnt;
extern char at_3602[];
extern char at_1063__3[];
extern char at_1064__3[];
extern char at_1065__2[];
extern char at_1066__2[];
extern char at_1067__2[];
extern char at_1068__2[];
extern char at_1069__3[];
extern char at_1070__2[];
extern char at_1071__2[];
extern char at_1072[];
extern char at_1073__2[];
extern char at_1074__2[];
extern char at_1075[];
extern char at_1076[];
extern char at_1077__2[];
extern char at_1078[];
extern char at_1079__2[];
extern char at_1080__2[];
extern char at_1940[];
extern "C" float backup_pos[4];
extern "C" int init_camera;
extern "C" float viewAngleH__2;
extern "C" float viewAngleV__2;
extern char at_3589[];
extern CWeaponElement wep_effect[8];
extern "C" int fptosi(float value);
#include "actionchara.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "charasetup.hpp"
#include "collision.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dbg_font.hpp"
#include "dng_debug.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "dng_hud.hpp"
#include "dng_object.hpp"
#include "dng_status.hpp"
#include "editexception.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "eventedit.hpp"
#include "funcpoint.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "helpmes.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapselect.hpp"
#include "menumain.hpp"
#include "mg_camera.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "nowload.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "pot.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "screeneffect.hpp"
#include "snd_mngr.hpp"
#include "sphida.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#include "wavetable.hpp"

// Small uninitialised data (.sbss)
mgCMemory            *MainBuffer;
u_long128            *BuffReadData;
static int            debag_param;
float                 viewAngleH__2;
float                 viewAngleV__2;
static int            init_camera;
DNG_FLOOR_SAVE       *NowFloorInfoPtr;
RUN_SCRIPT_ENV        ActionScriptEnv;
static int            DebugPause;
static float          test_dist;
CUserDataManager     *DngUserData;
CSaveData            *DngSaveData;
CSaveDataDungeon     *DngSaveDataDungeon;
CScene               *DngMainScene;
DNG_BATTLE_AREA      *BattleAreaScene;
CMap                 *DngMainMap;
CMonsterMan          *ActiveMonster;
ClsMes               *DngMess;
ClsMes               *DngMess2;
ClsMes               *EventMess;
ClsMes               *MonsterMess;
CRedMarkModel        *RedMarkModel;
CCharacter2          *TreasureBoxModel;
CTreasureBoxManager  *TreasureBoxMan;
CActionChara         *MainChara__2;
CEffectScriptMan     *FxScriptMan;
CColPrim             *BTsuboCol;
CPullItemManager      PullItemMan;
mgCFrame             *TornadoModel;
static int            wep_effect_cnt;

void EntryEventScript(int no);
void ResetEyeView(CActionChara *chara);
int  DngMainKey();
int  RunMainEvent();
void CheckWeaponEnable();
void CheckStatusError();
void DngStep();
void DngMainDraw();
void DebugMainDraw();
void CommonClassInit();
void DBGCMD_RunScript(int no);
static void EyeCamera(mgCCamera *camera, CCharacter2 *chara, int mode);
void IsEventRun();
int  EventScriptSetup(SYSTEM_SCRIPT_INFO *script);
int  ChangeSetUnit(int dir);
void InitEyeCamera(CActionChara *chara);
int  IsRunDeadEvent(CActionChara *chara);
extern CGamePad GamePad__2;
extern int debug_cursor;
extern int debug_mons_no;
extern int debug_mons_cur;
extern int debug_mons_num;

// Uninitialised data (.bss)
mgCMemory              BuffPaketList[2];
mgCMemory              BuffPaketData[2];
mgCMemory              BuffStageMain;
mgCMemory              BuffStageChara;
mgCMemory              BuffStageSubData;
mgCMemory              BuffStageSubChara;
mgCMemory              BuffWorkData;
mgCMemory              BuffCharacter;
mgCMemory              BaseCharacter[6];
mgCMemory              BuffTempData;
mgCMemory              BuffScriptData;
mgCMemory              BuffEffectScriptData;
mgCMemory              BuffEventData[4];
mgCMemory              BuffMDTBuild;
mgCMemory              BuffMDTBuild2;
DNG_STATUS             DngStatus;
CMapEffectsManeger     map_effect;
ACCUME_EFFECT          AccumulateEffect;
CDamageScore           DamageScore;
CDamageScore           DamageScoreMons[8];
CDamageScore2          DamageScore2;
MessageTaskManager     MsgTaskMan;
CStartupEpisodeTitle   StartupEpisodeTitle;
BattleEffectMan        BattleFX;
CLevelupInfo           LevelupInfo;
CLockOnModel           LockOnModel;
CWarningGage2          WarningGage2;
CAutoMapGen            AutoMapGen;
CColPrimMan            ColPrimMan;
CRandomCircle          RandomCircle;
CGeoStone              GeoStone;
CCameraControl         MainCamera;
CCameraControl         EventCamera;
CHealingEffectMan      HealingEffectMan;
CMiniEffPrimMan        MiniEffPrimMan;
CCharacter2            ItemBaseData[19];
CAfterWire       afterWire[16];
CRoboVoiceSystem       VoiceUnit;
CPot                   BTsubo;
CBPot                  BTsubo2;
CRocketLauncherMan     RocketLauncher;
CMachineGun            MachineGun;
CLaserGunMan           LaserGun;
CCharacter2            LaserGunModel;
CPullItem              PullItem[72];
static NowLoadingInfo  nowload;
INCLUDE_BSS(at_941__2, 0x10);
static CWaveTable      WaveTable;
mgCFrame              *SparcModel[3];
static CSwordLuminous  SwordLuminous;
CWeaponElement   wep_effect[8];
CSparcEffect     Sparc_fx[6];
CThunder         thunder[6];
CTornado         tornado[6];
CChillAfterHit   chillAfterHit[6];
CFireAfterHit    fireAfterHit[6];

INCLUDE_BSS(debug_event_stack_1106, 0x30);
INCLUDE_BSS(stack_1823, 0x30);
INCLUDE_BSS(at_1994, 0x10);
INCLUDE_BSS(at_2001, 0x10);
INCLUDE_BSS(chk_pos_2870, 0x10);

// Code (.text)
CWeaponElement *GetWeaponEffect() {
    CWeaponElement *effect = &wep_effect[wep_effect_cnt++];

    if (wep_effect_cnt >= 8) {
        wep_effect_cnt = 0;
    }
    return effect;
}
void memoryInit() {
    u_long128 *buffer0;
    u_long128 *buffer1;
    int        size;

    MainBuffer = GetMainStack();
    MainBuffer->stReset();
    buffer0 = MainBuffer->stAlloc64(10000);
    buffer1 = MainBuffer->stAlloc64(10000);
    mgInitVif1Packet(buffer0, buffer1, 160000);
    buffer0 = MainBuffer->stAlloc64(20000);
    buffer1 = MainBuffer->stAlloc64(20000);
    BuffPaketList[0].stSetBuffer(buffer0, 20000);
    BuffPaketList[1].stSetBuffer(buffer1, 20000);
    mgSetPacketBuffer(&BuffPaketList[0], &BuffPaketList[1]);
    buffer0 = MainBuffer->stAlloc64(60000);
    buffer1 = MainBuffer->stAlloc64(60000);
    BuffPaketData[0].stSetBuffer(buffer0, 60000);
    BuffPaketData[1].stSetBuffer(buffer1, 60000);
    mgSetDataBuffer(&BuffPaketData[0], &BuffPaketData[1], 1);
    BuffWorkData.stSetBuffer(MainBuffer->stAlloc64(10000), 10000);
    if (strlen("Work Buffer") < sizeof(BuffWorkData.name)) {
        strcpy(BuffWorkData.name, "Work Buffer");
    }
    BuffWorkData.stReset();
    mgTexManager.SetTableBuffer(0x140, 0xAF, MainBuffer);
    mgTexManager.Initialize(GetVramTopAddress(), -1);
    size = GetCharaMemAllocSize();
    BuffCharacter.stSetBuffer(MainBuffer->stAlloc64(size), size);
    if (strlen("Chara Buffer") < sizeof(BuffCharacter.name)) {
        strcpy(BuffCharacter.name, "Chara Buffer");
    }
    BuffCharacter.stReset();
    BuffScriptData.stSetBuffer(MainBuffer->stAlloc64(20000), 20000);
    if (strlen("Script Buffer") < sizeof(BuffScriptData.name)) {
        strcpy(BuffScriptData.name, "Script Buffer");
    }
    BuffScriptData.stReset();
    BuffEffectScriptData.SetHeapMem(MainBuffer->stAlloc64(40000), 40000);
    if (strlen("EScriptW Buffer") < sizeof(BuffEffectScriptData.name)) {
        strcpy(BuffEffectScriptData.name, "EScriptW Buffer");
    }
    BuffReadData = MainBuffer->stAlloc64(200000);
}
static inline unsigned int DngAlign16Size(unsigned int size) {
    if (size & 15) {
        return (size >> 4) + 1;
    }
    return size >> 4;
}
void InitDungeonMain(INIT_LOOP_ARG arg) {
    SetCurrentDir(NULL);
    memoryInit();
    nowload.tex_block = 0x51;
    nowload.unk_4 = 1;
    nowload.step_count = 10;
    arg.unk_4c = 0;
    nowload.memory.stSetBuffer(BuffReadData + 0x2E630, 10000);
    CreateNowLoading(&nowload);
    DngSaveData = GetSaveData();
    if (DngSaveData != NULL) {
        DngUserData = &DngSaveData->user_data;
    }
    NowFloorInfoPtr = NULL;
    DngSaveDataDungeon = &DngSaveData->save_dungeon;
    SetEnvUserDataMan(1);
    DngMainScene = GetMainScene();
    BattleAreaScene = &DngMainScene->battle_area;
    DngSaveDataDungeon->stage_id = arg.map_no;
    if (arg.floor_no >= 0) {
        DngSaveDataDungeon->SetFloorID(arg.floor_no);
    }
    CameraCtrlParam *param = MainCamera.GetActiveParam();

    if (param != NULL) {
        param->min_dist = 100.0f;
        param->max_dist = 160.0f;
        param->near_height = 18.0f;
        param->far_height = 10.0f;
        param->max_height = 40.0f;
        param->min_height = -15.0f;
        param->rest_max_height = 20.0f;
        param->rest_min_height = -15.0f;
        param->height = -15.0f;
        param->ground_space = 25.0f;
    }
    DngMainScene->Initialize();
    DngMainScene->AssignCamera(0, &MainCamera, "MainCam");
    DngMainScene->AssignCamera(1, &EventCamera, "EventCam");
    DngMainScene->active_camera = 0;
    DngMainScene->chara_texb = 16;
    DngMainScene->SetVillagerTexb(24, 16);
    DngMainScene->SetEventTexb(0x51, 3);
    DngMainScene->read_buff = BuffReadData;
    DNG_BATTLE_AREA *area = BattleAreaScene;

    DngMainMap = NULL;
    area->unk_5c = 1;
    area->battle_bgm_state = 0;
    area->battle_bgm_vol = 0.0f;
    area->unk_54 = 0;
    area->pause_flag = 0;
    area->timer = 0;
    area->minimap_reveal = 0;
    area->quake_count = 0;
    area->script.running = 0;
    area->subject_counter = 0;
    area->unk_98 = 0;
    area->floor_status = 0;
    area->unk_8c = 0;
    area->lock_on_mode = 0;
    BattleAreaScene->map_name[0] = '\0';
    for (int i = 0; i < 8; i++) {
        CActionChara *chara = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CActionChara)) + 2)) CActionChara;

        DngMainScene->AssignChara(i, chara, NULL);
        DngMainScene->SetType(1, i, 1);
    }
    MainChara__2 = (CActionChara *) DngMainScene->GetCharacter(0);
    DngMainScene->SetActive(1, 0);
    DngMainScene->player_chara = 0;
    for (int i = 0; i < 16; i++) {
        CCharacter2 *chara = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CCharacter2)) + 2)) CCharacter2;

        chara->Initialize();
        DngMainScene->AssignChara(i + 8, chara, NULL);
        DngMainScene->ResetActive(1, i + 8);
        DngMainScene->SetType(1, i + 8, 2);
    }
    memset(&MainBuffer->stack[MainBuffer->stack_used], 0xFF, 0x1EF00);
    CActiveMonster *mons = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CActiveMonster) * 24) + 2)) CActiveMonster[24];

    for (int i = 0; i < 24; i++) {
        mons[i].Initialize();
        DngMainScene->AssignChara(i + 24, &mons[i], NULL);
        DngMainScene->SetType(1, i + 24, 3);
    }
    BattleAreaScene->floor_manager.LoadDataTable(arg.map_no, MainBuffer);
    MainBuffer->Align64();
    MenuArg.pack = (u32 *) &MainBuffer->stack[MainBuffer->stack_used];
    LoadFile(GetMenuCfgFileName(0, 0), MenuArg.pack, &MenuArg.pack_size);
    MainBuffer->Alloc(MenuArg.pack_size / 16 + 1);
    MenuArg.mes_tex_block = 0x58;
    MenuArg.tex_block_top = 0x6C;
    MenuArg.tex_block_num = 16;
    MenuArg.active_chara_no = DngUserData->active_chr_no;
    MenuArg.user_data = DngUserData;
    MenuArg.scene = DngMainScene;
    MenuArg.base_chara_stack = BaseCharacter;
    MenuArg.chara_tex_block = 16;
    DngStatus.dungeon_no = arg.map_no;
    DngStatus.cursor_fade = 1.0f;
    DngStatus.mode = DNG_STATUS_FIELD;
    DngStatus.active_item = 0;
    DngStatus.status_count = 0;
    DngStatus.debug_window = 0;
    DngStatus.eye_view = 0;
    mgSetAllScissorFlag(0);
    mgInitLighting();
    test_dist = 160.0f;
    debag_param = 1;
    init_camera = 0;
    MainCamera.SetPos(0.0f, 0.0f, 0.0f);
    MainCamera.SetDistance(test_dist);
    MainCamera.SetFollowOffset(0.0f, 30.0f, 0.0f);
    MainCamera.SetHeight(5.0f);
    MainCamera.SetAngle(3.1415927f);
    MainCamera.SetSpeed(6.0f, -1.0f);
    MainCamera.Step(10);
    MainCamera.ControlOn();
    MainCamera.SetRotCameraCancel(1);
    EventCamera = MainCamera;
    EdEventLoopInit();
    InitTakePhoto();
    DngMainScene->LoadSeBase(0, BuffReadData);
    int sound = arg.map_no * 1000 + 1601;

    if (arg.map_no >= 5) {
        sound += 1000;
    }
    DngMainScene->LoadSound(sound, BuffReadData);
    NowLoadingBarStep();
    int bgm;
    int skip = DngMainScene->skip_load_bgm;

    bgm = DngMainScene->GetDefBgmNo(sound);

    if (bgm < 0) {
        DngMainScene->StopBGM(0);
    }
    if (DngMainScene->LoadBGM(bgm, BuffReadData)) {
        DngMainScene->PlayBGM(0, -1, 1.0f);
    }
    if (skip) {
        DngMainScene->skip_load_bgm = 1;
    }
    NowLoadingBarStep();
    DngMess = new (MainBuffer->Alloc(DngAlign16Size(sizeof(ClsMes)) + 2)) ClsMes;
    DngMess->Preset(4);
    DngMess->SetWindowMode(7);
    DngMess->push_button = 0;
    DngMess->draw_speed_def = 0;
    DngMess->draw_speed = 0;
    DngMess->texture_block = 0x58;
    if (LanguageCode > 0 && LanguageCode < 6) {
        DngMess->value_half = 1;
    }
    MsgTaskMan.Initialize();
    MsgTaskMan.mes = DngMess;
    DngMess2 = new (MainBuffer->Alloc(DngAlign16Size(sizeof(ClsMes)) + 2)) ClsMes;
    DngMess2->Preset(4);
    DngMess2->SetWindowMode(0);
    DngMess2->font_w = 16;
    DngMess2->push_button = 0;
    DngMess2->draw_speed_def = 0;
    DngMess2->texture_block = 0x58;
    StartupEpisodeTitle.Initialize();
    StartupEpisodeTitle.mes = DngMess2;
    EventMess = new (MainBuffer->Alloc(DngAlign16Size(sizeof(ClsMes)) + 2)) ClsMes;
    EventMess->Preset(0);
    EventMess->SetBuff_system(GetSystemMesBuffer());
    EventMess->texture_block = 0x58;
    MainBuffer->Align64();
    char  path[64];
    int   size;
    s16  *mes_buff = (s16 *) &MainBuffer->stack[MainBuffer->stack_used];

    sprintf(path, "dungeon/msg/d01_%d.mes", LanguageCode);
    LoadFile(path, mes_buff, &size);
    EventMess->SetBuff(mes_buff);
    MainBuffer->stAlloc64((size / 64 + 1) * 64 / 16);
    DngMainScene->AssignMessage(0, EventMess, NULL);
    GetSystemMessage()->texture_block = 0x58;
    DngMainScene->AssignMessage(1, GetSystemMessage(), NULL);
    MonsterMess = new (MainBuffer->Alloc(DngAlign16Size(sizeof(ClsMes)) + 2)) ClsMes;
    MonsterMess->Preset(2);
    MonsterMess->texture_block = 0x58;
    NowLoadingBarStep();
    mgCTextureManager *tex_man = &mgTexManager;

    MainTextureInterface(MainBuffer, DngMainScene);
    NowLoadingBarStep();
    char pack_path[64];

    sprintf(pack_path, "dungeon/articles/pack01_%d.chr", LanguageCode);
    LoadFile(pack_path, BuffReadData, NULL);
    int pack_size;

    LockOnModel.name = NULL;
    LockOnModel.scene = DngMainScene;
    mgCFrame *frame =
        mgLoadMDSFile((MDS_HEADER *) GetPackFile((u32 *) BuffReadData, "cursor.mds", &pack_size), MainBuffer, NULL, NULL);

    LockOnModel.frame = frame;
    mgCFrameAttr *lock_attr = frame->attr;

    lock_attr->no_light = 1;
    lock_attr->color[2] = 255.0f;
    lock_attr->color[1] = 255.0f;
    lock_attr->color[0] = 255.0f;
    lock_attr->color[3] = 128.0f;
    LockOnModel.frame->SetAttrParam(*lock_attr, 1, 0x18000);
    LockOnModel.name = NULL;
    LockOnModel.mes = MonsterMess;
    RedMarkModel = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CRedMarkModel)) + 2)) CRedMarkModel;
    RedMarkModel->Initialize();
    RedMarkModel->frame = mgLoadMDSFile(
        (MDS_HEADER *) GetPackFile((u32 *) BuffReadData, "bikkuri_aka.mds", &pack_size), MainBuffer, NULL, NULL);
    mgCFrameAttr attr;

    attr.billboard = 2;
    attr.no_light = 1;
    attr.color[0] = 255.0f;
    attr.color[1] = 255.0f;
    attr.color[2] = 255.0f;
    attr.color[3] = 128.0f;
    RedMarkModel->frame->SetAttrParam(attr, 1, 0);
    RedMarkModel->draw_request = 0;
    GeoStone.Initialize();
    u32 *pack = (u32 *) GetPackFile((u32 *) BuffReadData, "giostone.chr", &pack_size);

    GeoStone.LoadPack(pack, "info.cfg", MainBuffer, MainBuffer, MainBuffer, 0xAD, NULL);
    RandomCircle.Initialize();
    pack = (u32 *) GetPackFile((u32 *) BuffReadData, "ring_loop.chr", &pack_size);
    RandomCircle.model.LoadPack(pack, "info.cfg", MainBuffer, MainBuffer, MainBuffer, 0xAD, NULL);
    SparcModel[0] = mgLoadMDSFile((MDS_HEADER *) GetPackFile((u32 *) BuffReadData, "bteffe_att_a.mds", &pack_size),
                                  MainBuffer, NULL, NULL);
    SparcModel[1] = mgLoadMDSFile((MDS_HEADER *) GetPackFile((u32 *) BuffReadData, "bteffe_att_b.mds", &pack_size),
                                  MainBuffer, NULL, NULL);
    SparcModel[2] = mgLoadMDSFile((MDS_HEADER *) GetPackFile((u32 *) BuffReadData, "bteffe_att_c.mds", &pack_size),
                                  MainBuffer, NULL, NULL);
    TornadoModel = mgLoadMDSFile((MDS_HEADER *) GetPackFile((u32 *) BuffReadData, "bteffe_cyc.mds", &pack_size),
                                 MainBuffer, NULL, NULL);
    NowLoadingBarStep();
    LoadFile("dungeon/articles/item01b.chr", BuffReadData, NULL);
    char *item_file[20] = {at_1063__3, at_1064__3, at_1065__2, at_1066__2, at_1067__2, at_1068__2, at_1069__3, at_1070__2, at_1071__2, at_1072, at_1073__2, at_1074__2, at_1075, at_1076, at_1077__2, at_1078, at_1079__2, at_1080__2};

    for (int i = 0; i < 18; i++) {
        if (item_file[i] != NULL) {
            pack = (u32 *) GetPackFile((u32 *) BuffReadData, item_file[i], &pack_size);

            if (pack != NULL) {
                ItemBaseData[i].Initialize();
                ItemBaseData[i].LoadPackNoLine(pack, "info.cfg", MainBuffer, MainBuffer, MainBuffer, 0x68, NULL);
            }
        }
    }
    ActionScriptEnv.item_chara = ItemBaseData;
    ActionScriptEnv.texb = 0x68;
    TreasureBoxModel = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CCharacter2)) + 2)) CCharacter2;
    TreasureBoxMan = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CTreasureBoxManager)) + 2)) CTreasureBoxManager;
    TreasureBoxModel->Initialize();
    TreasureBoxMan->Initialize();
    char tbox_path[64];

    sprintf(tbox_path, "map/d/d0%d/f01/tbox0.chr", DngStatus.dungeon_no + 1);
    LoadFile(tbox_path, BuffReadData, NULL);
    TreasureBoxModel->LoadPack((u32 *) BuffReadData, "info.cfg", MainBuffer, MainBuffer, MainBuffer, 0x57, NULL);
    TreasureBoxMan->SetLargeModel(TreasureBoxModel, 0x57);
    TreasureBoxMan->SetCollisionModel((unsigned int *) BuffReadData, MainBuffer);
    BattleAreaScene->treasure_box = TreasureBoxMan;
    NowLoadingBarStep();
    LoadFile("img/allitem.img", BuffReadData, NULL);
    tex_man->EnterIMGFile((u8 *) BuffReadData, 0x50, NULL, NULL);
    mgCTexture *icon[2];

    icon[0] = tex_man->GetTexture("icon_dmy1", -1);
    icon[1] = tex_man->GetTexture("icon_dmy2", -1);
    CopyActiveIconTexture(icon, DngUserData->active_chr_no, NULL);
    tex_man->DeleteBlock(0x50);
    NowLoadingBarStep();
    SetupMainUnit(BuffReadData, &BuffCharacter, BaseCharacter, 16, DngMainScene, DngUserData,
                  DngUserData->active_chr_no, 0);
    GetBattleCharaInfo();
    DngMainScene->SetCharaTexb(0, 16);
    NowLoadingBarStep();
    LoadFile("dungeon/articles/eff01.chr", BuffReadData, &size);
    u32 *eff_pack = (u32 *) BuffReadData;

    FxScriptMan = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CEffectScriptMan)) + 2)) CEffectScriptMan;
    FxScriptMan->Initialize(MainBuffer, 0x8C, 32);
    FxScriptMan->load_buffer = BuffReadData + size / 16 + 1;
    FxScriptMan->SetWorkBuffer(&BuffEffectScriptData);
    FxScriptMan->level = 0;
    FxScriptMan->BuildPack("\x8d\xbb\x89\x8c", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x91\xab\x8d\xbb\x89\x8c", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x91\xab\x94g\x96\xe4", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x91\xab\x90\x85\x83p\x83V\x83\x83", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x91\xab\x8e\xc5\x90\xb6", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x92\xca\x8f\xed\x89\xf1\x95\x9c", eff_pack, NULL, -1);
    FxScriptMan->level = 1;
    FxScriptMan->BuildPack("\x83K\x81[\x83h\x83G\x83t\x83" "F\x83N\x83g\x82`", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x8f" "e\x92" "e", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x94\x9a\x94\xad", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83}\x83Y\x83\x8b\x83t\x83\x89\x83" "b\x83V\x83\x85", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x86\x83\x8a\x83X\x97\xad\x82\xdf\x8dU\x8c\x82", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x97\xad\x82\xdf\x8dU\x8c\x82", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x97\xad\x82\xdf", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95\x97", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95\x97\x83q\x83" "b\x83g", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x97\x8b", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x97\x8b\x83q\x83" "b\x83g", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95X", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95X\x83q\x83" "b\x83g", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x8f\x83" "C\x83\x93\x92M\x92" "e", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x89\x8a", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x97\xe2", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x97\x8b", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x95\x97", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x90\xb9", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x82x\x83r\x81[\x83\x80\x82g", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x82x\x83O\x83\x8c\x82g", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x93" "d\x8c\xf5\x90\xce\x89\xce", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x82" "e\x83{\x83\x80\x82g", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x8e\xe8\x93\x8a\x82\xb0\x94\x9a\x92" "e", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x89\xce", eff_pack, NULL, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x89\xce\x83q\x83" "b\x83g", eff_pack, NULL, -1);
    DngMainScene->AssignEffect(0, FxScriptMan, NULL);
    FxScriptMan->load_buffer = BuffReadData;
    CCharacter2 *rocket = FxScriptMan->GetBaseChara("\x83\x8f\x83" "C\x83\x93\x92M\x92" "e");

    RocketLauncher.Initialize(rocket->GetFrame(), rocket->texture_block, mgTexManager.GetTexture("Shell_kemuri", -1));
    LaserGunModel.Initialize();
    LoadFile2("dungeon/eff_script/rp_beam_s.chr", BuffReadData, NULL, 0);
    LaserGunModel.LoadPackNoLine((u32 *) BuffReadData, "info.cfg", MainBuffer, MainBuffer, MainBuffer, 0x4A, NULL);
    LaserGun.Initialize(LaserGunModel.GetFrame(), 0x4A, mgTexManager.GetTexture("potbeam", -1));
    BattleAreaScene->free_texb = FxScriptMan->GetNotUsedTexb();
    ActiveMonster = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CMonsterMan)) + 2)) CMonsterMan;
    ActiveMonster->Initialize(DngMainScene);
    CommonClassInit();
    AutoMapGen.grid = NULL;
    AutoMapGen.gio_parts = NULL;
    for (int i = 0; i < 12; i++) {
        AutoMapGen.random_stone[i] = NULL;
    }
    AutoMapGen.pot_parts = NULL;
    for (int i = 0; i < 8; i++) {
        AutoMapGen.room[i].unk_0 = 0;
    }
    AutoMapGen.room_info = NULL;
    AutoMapGen.room_info_num = 0;
    AutoMapGen.place_parts_num = 0;
    AutoMapGen.gen_flag = 0;
    AutoMapGen.navi_valid = 0;
    AutoMapGen.navi_enable = 0;
    AutoMapGen.cell_d = 320.0f;
    AutoMapGen.cell_w = 320.0f;
    AutoMapGen.grid = new (MainBuffer->Alloc(DngAlign16Size(sizeof(CAutoMapParts) * 900) + 2)) CAutoMapParts[900];
    for (int i = 0; i < 900; i++) {
        AutoMapGen.grid[i].Initialize();
    }
    AutoMapGen.grid_w = 30;
    AutoMapGen.grid_h = 30;
    MainChara__2->sound_info.foot_se_bank = DngMainScene->se_base_id;
    MainChara__2->sound_info.foot_sound_id = -1;
    sndInitPort(7);
    char snd_path[64];

    GetCharacterSnd(DngUserData, DngUserData->active_chr_no, snd_path);
    if (LoadFile2(snd_path, BuffReadData, NULL, 0)) {
        int base = 3;

        if (DngUserData->active_chr_no == 2) {
            base = 1;
        }
        if (DngUserData->active_chr_no == 3) {
            base = 0;
        }
        MainChara__2->sound_info.se_bank = sndLoadSound(7, (u32 *) BuffReadData, &BaseCharacter[base]);
    }
    MainChara__2->sound_info.se_bank_2 = DngMainScene->se_battle_id;
    MainChara__2->effect_man = FxScriptMan;
    NowLoadingBarStep();
    BuffStageMain.stSetBuffer(MainBuffer->stGetTop(), MainBuffer->stGetRest());
    BuffStageMain.stReset();
    DngMainScene->SetStack(0, &BuffCharacter);
    DngMainScene->SetStack(1, &BuffStageMain);
    DngMainScene->SetStack(2, &BuffStageChara);
    DngMainScene->SetStack(3, &BuffStageSubData);
    DngMainScene->SetStack(4, &BuffStageSubChara);
    DngMainScene->SetStack(5, &BuffEventData[0]);
    DngMainScene->SetStack(6, &BuffEventData[1]);
    DngMainScene->SetStack(7, &BuffEventData[2]);
    DngMainScene->SetStack(8, &BuffEventData[3]);
    NowLoadingBarStep();
    dngDebugInit();
    InitSphida();
    InitSubGame(DngMainScene);
    CreateHelpMes(0x58);
    BTsubo.Init(0);
    BTsubo2.Init();
    BTsuboCol = NULL;
    DngMainScene->time_step = 1;
    for (int e = 0; e < 6; e++) {
        Sparc_fx[e].Initialize();
        Sparc_fx[e].model[0] = SparcModel[0];
        Sparc_fx[e].model[1] = SparcModel[1];
        Sparc_fx[e].model[2] = SparcModel[2];
        thunder[e].Initialize();
        tornado[e].Initialize();
        tornado[e].model = TornadoModel;
        chillAfterHit[e].Initialize();
        fireAfterHit[e].Initialize();
    }
    DebugPause = 0;
    InitPauseMenu(0x6C);
    VoiceUnit.status = 0;
    VoiceUnit.pause_time = 2;
    VoiceUnit.play_time = 0;
    VoiceUnit.stream_open = 0;
    EdEventInfo.script_name[0] = '\0';
    EntryEventScript(DngStatus.dungeon_no);
    static mgCMemory debug_event_stack;

    debug_event_stack.stSetBuffer(BuffReadData, 200000);
    InitEventEdit(0x7D, &debug_event_stack);
    SYSTEM_SCRIPT_INFO *script = &BattleAreaScene->script;

    script->event_no = arg.event_no;
    if (arg.event_no <= 0) {
        script->event_no = 1000;
    }
    EventScriptSetup(script);
    BattleAreaScene->SetStatusBarNow(1);
    NowLoadingBarSteEnd();
    DeleteNowLoading();
}
void CRedMarkModel::Initialize() {
    draw_request = 0;
    angle = 0.0f;
    frame = NULL;
}
void CommonStageClassInit() {
    int i;

    HealingEffectMan.Initialize();
    MiniEffPrimMan.Initialize();
    ColPrimMan.Initialize(DngMainScene);
    LevelupInfo.phase = 0;
    SwordLuminous.root_frame = NULL;
    SwordLuminous.tip_frame = NULL;
    SwordLuminous.mode = 0;
    map_effect.spawn_wait = 0;
    map_effect.live_num = 0;
    map_effect.sprite_num = 0;
    map_effect.sprite = NULL;
    BattleAreaScene->map_effect_id = -1;
    DamageScore.active = 0;
    DamageScore.unk_00 = 0;
    DamageScore.unk_54 = 0;
    DamageScore.unk_58 = 0;
    DamageScore.digit_w = 12;
    DamageScore.digit_h = 17;
    DamageScore.digit_u = 0;
    DamageScore.digit_v = 202;
    DamageScore2.phase = 0;
    for (i = 0; i < 8; i++) {
        DamageScoreMons[i].active = 0;
        DamageScoreMons[i].unk_00 = 0;
        DamageScoreMons[i].unk_54 = 0;
        DamageScoreMons[i].unk_58 = 0;
        DamageScoreMons[i].digit_w = 12;
        DamageScoreMons[i].digit_h = 17;
        DamageScoreMons[i].digit_u = 0;
        DamageScoreMons[i].digit_v = 202;
    }
    AccumulateEffect.frame = NULL;
    AccumulateEffect.unk_320 = 0;
    AccumulateEffect.mode = 0;
    WarningGage2.warning[0] = 0;
    WarningGage2.warning[1] = 0;
    WarningGage2.warning[2] = 0;
    WarningGage2.time = 0;
    for (i = 0; i < 72; i++) {
        PullItem[i].Initialize();
    }
    PullItemMan.list = NULL;
    PullItemMan.num = 0;
    PullItemMan.list = PullItem;
    PullItemMan.num = 72;
    for (int w = 0; w < 16; w++) {
        afterWire[w].mode = 0;
    }
    for (int b = 0; b < 16; b++) {
        MachineGun.active[b] = 0;
        MachineGun.col_prim_id[b] = -1;
    }
    MachineGun.index = 0;
    for (int e = 0; e < 8; e++) {
        wep_effect[e].Initialize();
    }
    wep_effect_cnt = 0;
}
void CommonClassInit() {
    CommonStageClassInit();
    BattleFX.hit_prim = NULL;
    BattleFX.hit = NULL;
    BattleFX.hit_num = 0;
    BattleFX.hit_next = 0;
    BattleFX.flush = NULL;
    BattleFX.flush_num = 0;
    BattleFX.flush_next = 0;
    BattleFX.power_prim = NULL;
    BattleFX.power = NULL;
    BattleFX.power_num = 0;
    BattleFX.power_next = 0;
    BattleFX.dead_prim = NULL;
    BattleFX.dead = NULL;
    BattleFX.dead_num = 0;
    BattleFX.dead_next = 0;
    BattleFX.chara_slot = NULL;
    BattleFX.chara_num = 0;
    BattleFX.AllocEffect(0, MainBuffer, 4);
    BattleFX.AllocEffect(1, MainBuffer, 4);
    BattleFX.AllocEffect(2, MainBuffer, 8);
    BattleFX.AllocEffect(3, MainBuffer, 4);
    BattleAreaScene->battle_effect = &BattleFX;
    InitPause(0x69);
}
void EntryEventScript(int no) {
    char path[64];
    char map[44];
    int  size;
    int  i;

    read_buffer = BuffReadData;
    if (OmakeFlag) {
        sprintf(path, "map/d/d0%d/d0%d_sfida_%d.stb", no + 1, no + 1, LanguageCode);
    } else if (EdEventInfo.script_name[0] == 0) {
        if (no + 1 < 10) {
            sprintf(path, "map/d/d0%d/d0%d_%d.stb", no + 1, no + 1, LanguageCode);
        } else {
            sprintf(path, "map/d/d%d/d%d_%d.stb", no + 1, no + 1, LanguageCode);
        }
    } else {
        for (i = 0; EdEventInfo.script_name[i] != '/'; i++) {
            map[i] = EdEventInfo.script_name[i];
        }
        GetMapPath(path, map);
        strcat(path, ".stb");
    }
    printf("SCRIPT FILE %s\n", path);
    BuffScriptData.stack_used = 0;
    BuffScriptData.lock = 0;
    BuffScriptData.Align64();
    u_long128 *script = BuffScriptData.stack + BuffScriptData.stack_used;
    if (LoadFile2(path, script, &size, 0)) {
        BuffScriptData.Alloc((size & 0xF) ? (u_int) size / 16 + 1 : (u_int) size / 16);
        SetEventScript((char *) script, NULL, &BuffScriptData);
    }
}
void FinishDungeonMain(void) {
}
int LoopDungeonMain() {
    int key;
    int mode;

    DngMainMap = DngMainScene->GetMap(DngMainScene->active_map);
    CMapLightingInfo light;
    if (DngMainMap != NULL) {
        DngMainMap->GetLightInfo(&light);
        float projection = light.projection + PhotoAddProjection();

        mgSetRenderInfo(projection, 5.0f, 50000.0f);
    }
    switch (mode = DngStatus.mode) {
    case DNG_STATUS_FIELD:
        key = DngMainKey();
        if (DngStatus.mode != DNG_STATUS_MENU) {
            DngStep();
        }
        break;
    case DNG_STATUS_MENU:
    case DNG_STATUS_EVENT_MENU:
        key = MenuMainKey();
        break;
    case DNG_STATUS_EVENT:
        key = RunMainEvent();
        DngStep();
        if (ChkEventEditStart()) {
            DngStatus.mode = DNG_STATUS_EVENT_EDIT;
        }
        break;
    case DNG_STATUS_EVENT_EDIT:
        if (!EventEdit(&BuffWorkData)) {
            DngStatus.mode = DNG_STATUS_EVENT;
        }
        break;
    }
    DngMainScene->fade.FadeStep();
    switch (mode) {
    case DNG_STATUS_FIELD:
    case DNG_STATUS_EVENT:
    case DNG_STATUS_EVENT_EDIT:
        DngMainDraw();
        if (DngStatus.mode == DNG_STATUS_MENU || DngStatus.mode == DNG_STATUS_EVENT_MENU) {
            static mgCMemory stack;

            stack.stSetBuffer(BuffReadData, 200000);
            MenuArg.stack = &stack;
            MenuArg.chara_stack = &BuffCharacter;
            LoopSoundManager(0);
            MenuMainInit(&MenuArg);
        }
        break;
    case DNG_STATUS_EVENT_MENU:
        MenuMainDraw();
        FadeOutForE3();
        if (key) {
            MenuMainExit();
            DngStatus.mode = DNG_STATUS_EVENT;
        }
        break;
    case DNG_STATUS_MENU:
        MenuMainDraw();
        FadeOutForE3();
        if (key) {
            MenuMainExit();
            LoopSoundManager(1);
            CheckWeaponEnable();
            DngStatus.mode = DNG_STATUS_FIELD;
            if (BattleAreaScene->statusbar_show_old) {
                BattleAreaScene->SetStatusBarNow(1);
            }
            if (MenuArg.end_code == 1) {
                MenuArg.active_chara_no = MenuArg.result[0];
            }
            if (MenuArg.end_code == 21) {
                MenuArg.active_chara_no = MenuArg.result[0];
            }
            if (MenuArg.end_code == 5 && MenuArg.result[2] == 0) {
                INIT_LOOP_ARG arg;
                char *map[7] = {"d01e01", "s02", "g02", "g03", "g04", "d06e01", "m05"};
                arg.map_no = SearchMapNo(map[DngStatus.dungeon_no]);
                arg.event_no = 100;
                NextLoop(1, arg);
                DngStatus.mode = DNG_STATUS_EXIT;
            }
            if (MenuArg.end_code != 11 && SubGameRunning() && GetSubGameNo() == 1) {
                sgExitSubGame();
            }
            if (MenuArg.end_code == 11) {
                SubGameInfo info;

                DngMainScene->unk_3e68 = 40;
                DngMainScene->unk_3e6c = 31;
                info.scene = DngMainScene;
                info.rod_no = MenuArg.result[0];
                info.esa_no = MenuArg.result[1];
                info.dungeon = 1;
                MenuArg.end_code = 0;
                SubGameInfo *now = GetNowSubGameInfo();
                if ((GetMenuEtcFlag() & 1) || !SubGameRunning() || now->rod_no != info.rod_no) {
                    sgInitSubGame(1, &info);
                } else {
                    sgRestartSubGame(&info);
                }
                MainChara__2->SearchChara(at_1940)->Show(0, 0);
            }
            ResetEyeView(MainChara__2);
        }
        break;
    }
    PAUSE_INFO pause;
    pause.scene = NULL;
    pause.scene = DngMainScene;
    pause.event_skip = 0;
    if (!OmakeFlag) {
        if (DngStatus.mode == DNG_STATUS_EVENT && CheckEventSkip()) {
            pause.event_skip = 1;
        }
        if (PadCtrl.Btn(0x15) || !GamePad__2.Connect()) {
            PauseStart(&pause);
        }
    }
    if (DebugFlag && !(BattleAreaScene->pause_flag & 0x8000) && GamePad__2.On(0x800) && GamePad__2.On(0x100)) {
        DngStatus.mode = DNG_STATUS_EXIT;
    }
    if (DngMainScene->exit_flag) {
        DngMainScene->exit_flag = 0;
        DngStatus.mode = DNG_STATUS_EXIT;
    }
    if (DngStatus.mode == DNG_STATUS_EXIT) {
        sgBreakSubGame();
        CheckItemDngKey();
        if (!(BattleAreaScene->pause_flag & 0x800)) {
            PlayerPartyCure();
        }
        BattleAreaScene->floor_status &= ~7;
        EdEventTermination();
        BreakReadBG();
        if (DngUserData->active_chr_no == USER_CHARA_ROBO) {
            DngUserData->SetActiveChrNo(USER_CHARA_MAX);
        }
        if (DngUserData->active_chr_no == USER_CHARA_MONSTER) {
            DngUserData->SetActiveChrNo(USER_CHARA_MONICA);
        }
        DngMainScene->StopSeSrc();
        sndSeAllStop(-1);
        sndStopVoice(1);
        return 1;
    }
    return 0;
}
void DngMainDraw() {
    mgCTextureManager *tex_man = &mgTexManager;
    SV_CONFIG_OPTION  *config;
    sceVu0FVECTOR      cam_pos;
    sceVu0FVECTOR      cam_ref;
    sceVu0FMATRIX      view_mat;

    mgFogEnable(1);
    sceVu0FVECTOR view = {0.0f, 0.0f, 100.0f, 0.0f};
    mgCCamera    *camera = DngMainScene->GetCamera(DngMainScene->active_camera);

    camera->Step(1);
    camera->GetCameraMatrix(view_mat);
    camera->GetPos(cam_pos);
    camera->GetRef(cam_ref);
    mgSetViewMatrix(view_mat, cam_pos);
    sceVu0SubVector(cam_ref, cam_ref, cam_pos);
    sndSetMicPos(cam_pos, cam_ref);
    config = &DngSaveData->config;

    DngMainMap = DngMainScene->GetMap(DngMainScene->active_map);
    CMapLightingInfo  light;
    CMapLightingInfo *info = &light;

    if (DngMainMap != NULL) {
        DngMainMap->time_light_blend = 1;
        DngMainMap->now_time = DngMainScene->time;
        DngMainMap->GetLightInfo(info);
        if (info != NULL) {
            info->ambient[0] *= BattleAreaScene->bright_rate;
            info->ambient[1] *= BattleAreaScene->bright_rate;
            info->ambient[2] *= BattleAreaScene->bright_rate;
            info->light_dir[0][0] *= BattleAreaScene->bright_rate;
            info->light_dir[1][0] *= BattleAreaScene->bright_rate;
            info->light_dir[2][0] *= BattleAreaScene->bright_rate;
            info->light_dir[0][1] *= BattleAreaScene->bright_rate;
            info->light_dir[1][1] *= BattleAreaScene->bright_rate;
            info->light_dir[2][1] *= BattleAreaScene->bright_rate;
            info->light_dir[0][2] *= BattleAreaScene->bright_rate;
            info->light_dir[1][2] *= BattleAreaScene->bright_rate;
            info->light_dir[2][2] *= BattleAreaScene->bright_rate;
            info->light_dir[0][3] *= BattleAreaScene->bright_rate;
            info->light_dir[1][3] *= BattleAreaScene->bright_rate;
            info->light_dir[2][3] *= BattleAreaScene->bright_rate;
        }
        if (info != NULL) {
            mgFogEnable(info->fog_enable);
            if (info->fog_enable) {
                mgSetFogParam(info->fog.near_dist, info->fog.far_dist, info->fog.r, info->fog.g, info->fog.b,
                              info->fog.far_value, info->fog.near_value);
            }
            mgSetLight(info->light_dir, info->light_color);
            mgSetAmbient(info->ambient);
            if (info->plight_enable) {
                mgPlightEnable(1);
                for (int p = 0; p < 4; p++) {
                    mgSetPlight(p, &info->point_light[p]);
                }
            }
            mgSetBackGround(info->bg_color);
        }
    }
    if (!(BattleAreaScene->pause_flag & 0x20)) {
        DngMainScene->DrawSky(0);
    }
    if (DngMainMap != NULL && !(BattleAreaScene->pause_flag & 0x80)) {
        S51Thunder(DngMainScene);
        BuffWorkData.stReset();
        int list[68];
        int i;

        for (i = 0; i < 15; i++) {
            list[i] = i;
        }
        list[15] = -1;
        mgBeginDraw(&BuffWorkData, list, NULL);
        MainChara__2->GetPosition(view);
        DngMainMap->PreDraw(view);
        DngMainMap->Draw();
        mgCTexture *water = tex_man->GetTexture("water", -1);
        int         water_block = -1;

        if (water != NULL) {
            water_block = water->block;
            WaveTable.GetEffect();
        }
        mgPreEndDraw(NULL);
        int g;
        int b;
        int block;
        int num;
        int idx;

        for (g = 0; g < 6; g++) {
            int blocks[128];

            num = DngMainScene->GetTextureBlockNo(g, blocks, 128);
            for (b = 0; b < num; b++) {
                idx = num - b - 1;
                block = blocks[idx];
                if (mgEndDrawReloadTexture(block, NULL) && water_block == blocks[idx]) {
                    WaveTable.CreateTexture(water);
                }
                mgEndDraw(block, NULL);
            }
        }
        mgSetPkTextureRepeat(0);
    }
    EdEventFirstDraw();
    tex_man->ReloadTexture(100, (sceVif1Packet *) NULL);
    mgBeginDrawShadow(TEX_ShadowTexture, NULL);
    {
        sceVu0FMATRIX ld;
        sceVu0FMATRIX lc;

        mgGetLight(ld, lc);
        sceVu0FVECTOR dir = {ld[0][0], ld[1][0], ld[2][0]};

        dir[1] = dir[1] < 0.0f ? -dir[1] : dir[1];
        if (dir[1] < 0.8f) {
            dir[1] = 0.8f;
        }
        sceVu0FVECTOR pos = {0.0f, -10.0f, 0.0f, 0.0f};
        sceVu0FVECTOR normal = {0.0f, 1.0f, 0.0f, 0.0f};

        MainChara__2->GetEntryObjectPos(1, 0, pos);
        pos[1] -= 20.0f;
        mgSetDropShadowMatrix(dir, pos, normal);
        if (DngMainScene->CheckDrawCharaShadow(0)) {
            MainChara__2->ShadowStep();
            MainChara__2->DrawShadowDirect();
        }
    }
    {
        sceVu0FMATRIX ld;
        sceVu0FMATRIX lc;

        mgGetLight(ld, lc);
        sceVu0FVECTOR dir = {ld[0][0], ld[1][0], ld[2][0]};

        dir[1] = dir[1] < 0.0f ? -dir[1] : dir[1];
        if (dir[1] < 0.8f) {
            dir[1] = 0.8f;
        }
        sceVu0FVECTOR pos;
        sceVu0FVECTOR normal = {0.0f, 1.0f, 0.0f, 0.0f};

        for (int c = 0; c < 16; c++) {
            if (DngMainScene->CheckDrawCharaShadow(c + 8)) {
                CCharacter2 *chara = DngMainScene->GetCharacter(c + 8);

                if (chara != NULL) {
                    chara->GetEntryObjectPos(1, 0, pos);
                    pos[1] -= 20.0f;
                    mgSetDropShadowMatrix(dir, pos, normal);
                    chara->ShadowStep();
                    chara->DrawShadowDirect();
                }
            }
        }
    }
    if (!(BattleAreaScene->pause_flag & 0x10)) {
        ActiveMonster->DrawShadowActMonster();
    }
    TreasureBoxMan->DrawShadow(cam_pos);
    mgEndDrawShadow(TEX_ShadowTexture, NULL);
    {
        int           old = mgActiveLighting(1, 1);
        sceVu0FMATRIX ld;
        sceVu0FMATRIX lc;
        sceVu0FVECTOR amb;

        mgGetLight(ld, lc);
        mgGetAmbient(amb);
        DngMainScene->GetCharaLighting(lc, amb);
        mgSetLight(ld, lc);
        mgSetAmbient(amb);
        tex_man->ReloadTexture(TreasureBoxMan->tex_block, (sceVif1Packet *) NULL);
        camera->GetPos(cam_pos);
        TreasureBoxMan->Draw(cam_pos);
        if (!(BattleAreaScene->pause_flag & 0x10)) {
            ActiveMonster->DrawActMonster();
        }
        if (DngMainScene->CheckDrawChara(0)) {
            if (DngMainMap != NULL) {
                int        num = 0;
                CFuncPoint points[2];

                for (int m = 0; m < 1; m++) {
                    num += DngMainMap->GetCharaLight(MainChara__2, &points[num], 2 - num, 1);
                    if (num >= 3) {
                        break;
                    }
                }
            }
            tex_man->ReloadTexture(16, (sceVif1Packet *) NULL);
            MainChara__2->DrawDirect();
        }
        for (int c = 0; c < 16; c++) {
            if (DngMainScene->CheckDrawChara(c + 8) && DngMainScene->GetType(1, c + 8) != 4) {
                CCharacter2 *chara = DngMainScene->GetCharacter(c + 8);

                if (chara != NULL) {
                    tex_man->ReloadTexture(DngMainScene->GetCharaTexb(c + 8), (sceVif1Packet *) NULL);
                    chara->DrawDirect();
                }
            }
        }
        mgActiveLighting(old, 0);
    }
    if (!(BattleAreaScene->pause_flag & 0x80)) {
        mgTexManager.ReloadTexture(100, (sceVif1Packet *) NULL);
        mgCTexture *work = TEX_ShadowTexture;

        if (!config->dof_off) {
            float dof[] = {1800.0f};

            DepthOfField(1, dof, work, 1.0f);
        } else {
            float dof[] = {1000.0f, 2000.0f};

            DepthOfField(2, dof, work, 1.0f);
        }
    }
    if (!(BattleAreaScene->pause_flag & 0x20)) {
        tex_man->ReloadTexture(100, (sceVif1Packet *) NULL);
        DngMainScene->DrawLensFlare(100, "work", "work2");
    }
    mgSetPkTextureRepeat(0);
    tex_man->ReloadTexture(0xAD, (sceVif1Packet *) NULL);
    sceVu0FVECTOR chara_pos;

    MainChara__2->GetPosition(chara_pos);
    RandomCircle.Draw(chara_pos);
    tex_man->ReloadTexture(0xAD, (sceVif1Packet *) NULL);
    GeoStone.GeoDraw(chara_pos);
    tex_man->ReloadTexture(0x6A, (sceVif1Packet *) NULL);
    if (!(BattleAreaScene->pause_flag & 0x200)) {
        mgCTexture *tex = tex_man->GetTexture("keyetc", 0x6A);

        for (int p = 0; p < 72; p++) {
            PullItem[p].Draw(tex);
        }
    }
    float work[256][4];

    if (!(BattleAreaScene->pause_flag & 0x200)) {
        for (int w = 0; w < 16; w++) {
            afterWire[w].StepWire();
            afterWire[w].DrawWire(work);
        }
    }
    ActiveMonster->DrawInvisibleMonster();
    if (DngMainMap != NULL && !(BattleAreaScene->pause_flag & 0x80)) {
        int g;
        int b;
        int block;
        int num;

        for (g = 6; g < 16; g++) {
            int blocks[128];

            num = DngMainScene->GetTextureBlockNo(g, blocks, 128);
            for (b = 0; b < num; b++) {
                block = blocks[b];
                mgEndDrawReloadTexture(block, NULL);
                mgEndDraw(block, NULL);
            }
        }
        mgSetPkTextureRepeat(0);
        mgCTexture *work_tex = tex_man->GetTexture("water_work", 0x59);
        mgCTexture *ref_tex = tex_man->GetTexture("ref", 0x59);

        DngMainMap->DrawWater(DngMainScene->GetCamera(DngMainScene->active_camera), work_tex, ref_tex);
    }
    if (!(BattleAreaScene->pause_flag & 0x80)) {
        DngMainScene->DrawEffect(0x4B);
    }
    {
        int           old = mgActiveLighting(1, 1);
        sceVu0FMATRIX ld;
        sceVu0FMATRIX lc;
        sceVu0FVECTOR amb;

        mgGetLight(ld, lc);
        mgGetAmbient(amb);
        DngMainScene->GetCharaLighting(lc, amb);
        mgSetLight(ld, lc);
        mgSetAmbient(amb);
        for (int c = 0; c < 16; c++) {
            if (DngMainScene->CheckDrawChara(c + 8) && DngMainScene->GetType(1, c + 8) == 4) {
                CCharacter2 *chara = DngMainScene->GetCharacter(c + 8);

                if (chara != NULL) {
                    tex_man->ReloadTexture(DngMainScene->GetCharaTexb(c + 8), (sceVif1Packet *) NULL);
                    chara->DrawDirect();
                }
            }
        }
        mgActiveLighting(old, 0);
    }
    tex_man->ReloadTexture(0x49, (sceVif1Packet *) NULL);
    map_effect.Draw(&MainCamera);
    HealingEffectMan.Draw(&MainCamera);
    BattleFX.Draw();
    for (int e = 0; e < 8; e++) {
        wep_effect[e].Step();
        wep_effect[e].Draw();
    }
    ActiveMonster->DrawPiyori();
    MiniEffPrimMan.Draw();
    SwordLuminous.Draw();
    RocketLauncher.Draw();
    LaserGun.Draw();
    tex_man->ReloadTexture(0x6B, (sceVif1Packet *) NULL);
    for (int e = 0; e < 6; e++) {
        Sparc_fx[e].Draw();
        thunder[e].Draw();
        tornado[e].Draw();
        chillAfterHit[e].Draw();
        fireAfterHit[e].Draw();
    }
    tex_man->ReloadTexture(0x4A, (sceVif1Packet *) NULL);
    if (DngMainScene->CheckDrawChara(0)) {
        MainChara__2->DrawEffect();
    }
    for (int c = 0; c < 16; c++) {
        if (DngMainScene->CheckDrawChara(c + 8) && DngMainScene->GetType(1, c + 8) != 4) {
            CCharacter2 *chara = DngMainScene->GetCharacter(c + 8);

            if (chara != NULL) {
                chara->DrawEffect();
            }
        }
    }
    ActiveMonster->DrawEffectScript();
    if (BattleAreaScene->unk_8c == 2) {
        CPreSprite prim;

        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.TextureMapEnable(0);
        prim.Coord(0);
        prim.Shading(1);
        prim.DepthTestEnable(0);
        prim.DepthTest(-1);
        prim.AlphaBlend(1);
        prim.Begin(1);
        int x = 16;

        for (int r = 0; r < 132; r++) {
            int top = iRand(64) - 32;
            int slant = iRand(256) - 128;
            int len = -iRand(256);

            prim.Color(0x80, 0x80, 0x84, iRand(4));
            prim.Vertex(x + top, 0, 0);
            prim.Color(0x80, 0x80, 0x84, iRand(16));
            prim.Vertex(x - slant, mgScreenHeight - len + 32, 0);
            x += iRand(8);
        }
        prim.End();
    }
    sgDrawSubGameChara();
    sgDrawSubGameEffect();
    sgDrawSubGameSystem();
    CSphida *sphida = GetSphidaPtr();

    if (sphida != NULL) {
        sphida->Draw();
    }
    int k;
    s8  show = BattleAreaScene->statusbar_show;

    if (NowTakePhoto()) {
        show = 0;
    }
    if (show && debag_param && !(BattleAreaScene->pause_flag & 0x10)) {
        tex_man->ReloadTexture(0x48, (sceVif1Packet *) NULL);
        LockOnModel.Draw();
    }
    if (show && debag_param && !(BattleAreaScene->pause_flag & 0x10010) && !config->monster_name) {
        LockOnModel.DrawMess(0x58);
    }
    tex_man->ReloadTexture(0x48, (sceVif1Packet *) NULL);
    RedMarkModel->Draw();
    if (show && debag_param) {
        DngMainScene->DrawExclamationMark(RedMarkModel->frame);
        if (!(BattleAreaScene->pause_flag & 0x10)) {
            ActiveMonster->DrawLifeGage(config->anger_counter, config->enemy_hp);
            if (!config->damage_off) {
                DamageScore.Draw();
                DamageScore2.Draw(DngMainScene);
                for (k = 0; k < 8; k++) {
                    DamageScoreMons[k].Draw();
                }
            }
        }
        LevelupInfo.Draw();
    }
    if (!NowTakePhoto()) {
        DrawStatusBord();
    }
    if (show && debag_param) {
        WarningGage2.Draw();
        if (!BattleAreaScene->script.running && !(BattleAreaScene->pause_flag & 0x100) && config->map) {
            tex_man->ReloadTexture(0x66, (sceVif1Packet *) NULL);
            sceVu0FVECTOR pos;

            MainChara__2->GetPosition(pos);
            if (config->map == 1) {
                AutoMapGen.mini_map.large = 0;
                AutoMapGen.mini_map.x = 436;
                AutoMapGen.mini_map.y = 144;
                AutoMapGen.mini_map.w = 112;
                AutoMapGen.mini_map.h = 112;
            }
            if (config->map == 2) {
                AutoMapGen.mini_map.x = 336;
                AutoMapGen.mini_map.y = 212;
                AutoMapGen.mini_map.w = 320;
                AutoMapGen.mini_map.h = 280;
                AutoMapGen.mini_map.large = 1;
            }
            AutoMapGen.mini_map.Draw(pos);
            tex_man->ReloadTexture(0x48, (sceVif1Packet *) NULL);
            AutoMapGen.mini_map.DrawSymbolOpen();
            GeoStone.DrawMiniMapSymbol(&AutoMapGen.mini_map);
            ActiveMonster->DrawMiniMapSymbol(&AutoMapGen.mini_map);
            TreasureBoxMan->DrawMiniMapSymbol(&AutoMapGen.mini_map);
            RandomCircle.DrawSymbol(&AutoMapGen.mini_map);
            CSphida *sphida2 = GetSphidaPtr();

            if (sphida2 != NULL) {
                sphida2->DrawMiniMapSymbol(&AutoMapGen.mini_map);
            }
            AutoMapGen.mini_map.DrawSymbolClose();
            AutoMapGen.mini_map.DrawSymbol_Chara(MainChara__2);
        }
    }
    for (int c = 0; c < 64; c++) {
        ColPrimMan.prim[c].DebugDraw();
    }
    EdEventDraw();
    tex_man->ReloadTexture(0x58, (sceVif1Packet *) NULL);
    if (show && debag_param) {
        MsgTaskMan.Step();
        MsgTaskMan.Draw();
    }
    EventMess->Step();
    EventMess->DrawMesWin();
    GetSystemMessage()->Step();
    GetSystemMessage()->DrawMesWin();
    EventTimeDraw();
    if (show && debag_param) {
        StartupEpisodeTitle.Step();
        StartupEpisodeTitle.DrawEpisode(0x58, 0x48);
    }
    if (NowTakePhoto()) {
        int                       photo_neta;
        int                       monster;
        USER_PICTURE_INFO        *picture;
        CInventUserData          *invent;
        CFuncPoint               *point;
        CScene::InScreenCharaInfo chara_info;
        float                     distance;

        tex_man->ReloadTexture(0x67, (sceVif1Packet *) NULL);
        chara_info.chara_no = -1;
        chara_info.dist = 0.0f;
        chara_info.in_center = 0;
        invent = &DngUserData->invent_data;
        photo_neta = ActiveMonster->CheckPhoto(&chara_info);
        monster = chara_info.chara_no;
        picture = invent->IsPhotoSpace(NULL);
        if (DrawTakePhoto(picture, &distance)) {
            InScreenFuncInfo func_info;

            func_info.range = -1.0f;
            func_info.unk_04 = 0;
            func_info.dist = -1.0f;
            func_info.range = distance;
            point = DngMainScene->InScreenFunc(&func_info);
            picture->map_no = SearchMapNo(BattleAreaScene->map_name);
            int neta = -1;

            picture->neta_id = -1;
            picture->npc_no = -1;
            if (point != NULL) {
                neta = point->invent.neta_no;
            }
            if (neta == 30001) {
                neta = -1;
                picture->npc_no = 260;
            }
            if (neta > 0) {
                picture->neta_id = neta;
                sndSePlay(GetSystemSndID(), 14, 0);
            }
            if (monster >= 0) {
                picture->monster_no = monster;
                if (photo_neta > 0) {
                    picture->neta_id = photo_neta;
                    sndSePlay(GetSystemSndID(), 14, 0);
                }
            }
            SetTookPhotoData(picture);
        }
        if (DngStatus.mode == DNG_STATUS_FIELD) {
            DrawTakePhotoSystem(0x58, invent);
        }
    }
    DrawHelpMes();
    DngMainScene->fade.Draw();
    DrawEventEdit();
    DebugMainDraw();
    dngDebugDraw();
    DrawDebugWindow();
}
void DngStep() {
    SV_CONFIG_OPTION *config = &DngSaveData->config;
    DNG_BATTLE_AREA  *area;
    sceVu0FVECTOR     wind;
    float             power;
    int               i;

    if (DebugPause) {
        return;
    }
    area = BattleAreaScene;
    area->timer++;
    if (area->quake_count > 0) {
        area->quake_power -= area->quake_step;
        area->quake_count--;
    }
    if (area->statusbar_show) {
        if (area->statusbar_rate < 1.0f) {
            area->statusbar_rate += area->statusbar_speed;
        }
        if (area->statusbar_rate > 1.0f) {
            area->statusbar_rate = 1.0f;
        }
    } else {
        if (area->statusbar_rate > 0.0f) {
            area->statusbar_rate -= area->statusbar_speed;
        }
        if (area->statusbar_rate < 0.0f) {
            area->statusbar_rate = 0.0f;
        }
    }
    DngMainScene->PrePlaySeSrc();
    DngMainScene->PlayMapSeSrc();
    Lamb2WolfManager();
    power = DngMainScene->GetWind(wind);
    if (!(BattleAreaScene->pause_flag & 2)) {
        sceVu0FVECTOR foot;

        MainChara__2->SetWind(power, wind);
        if (MainChara__2->GetEntryObjectPos(1, foot)) {
            MainChara__2->SetFloor(foot[1]);
        }
        MainChara__2->Step();
        if (MainChara__2->move_check.in_water) {
            static int water_cnt = 0;

            water_cnt++;
            if (water_cnt >= 10) {
                sceVu0FVECTOR pos;

                water_cnt = 0;
                sceVu0CopyVector(pos, MainChara__2->move_check.water_surface);
                pos[1] += 0.1f;
                FxScriptMan->CreateEffSpt("\x91\xab\x94g\x96\xe4", 0, -1);
                FxScriptMan->SetScriptVect1(pos, -1, -1);
                sceVu0FVECTOR scale = {1.0f, 1.0f, 1.0f, 1.0f};
                FxScriptMan->SetScriptVect2(scale, -1, -1);
            }
        }
        if (MainChara__2->move_check.landed && MainChara__2->CheckFootEffect() >= 0) {
            sceVu0FVECTOR pos;

            MainChara__2->GetPosition(pos);
            int foot_no = MainChara__2->CheckFootEffect();
            int effect[35] = {-1, 1,  -1, -1, -1, -1, -1, 0,  0,  -1, -1, 2,  -1, -1, 0,  -1, 0, -1,
                              2,  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
            if (foot_no >= 0) {
                int kind = effect[foot_no];

                if (kind == 0) {
                    FxScriptMan->CreateEffSpt("\x91\xab\x8d\xbb\x89\x8c", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                }
                if (kind == 1) {
                    FxScriptMan->CreateEffSpt("\x91\xab\x8d\xbb\x89\x8c", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                    FxScriptMan->CreateEffSpt("\x91\xab\x8e\xc5\x90\xb6", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                }
                if (kind == 2) {
                    FxScriptMan->CreateEffSpt("\x91\xab\x90\x85\x83p\x83V\x83\x83", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                }
            }
        }
    }
    MainChara__2->StepEffect();
    if (DngUserData->active_chr_no == USER_CHARA_ROBO) {
        VoiceUnit.Step();
    }
    sgLoopSubGame2();
    int pot = BTsubo.Step();
    if (pot == 1 || pot == 2) {
        if (BTsuboCol != NULL) {
            BTsuboCol->Delete(-1);
            BTsuboCol = NULL;
        }
        if (iRand(100) % 3 == 0) {
            sceVu0FVECTOR pos;

            sceVu0CopyVector(pos, BTsubo.break_pos);
            pos[1] += 10.0f;
            sceVu0FVECTOR velo = {0.0f, 1.5f, 0.0f, 0.0f};
            CPullItem *item = PullItemMan.GetList(2);
            if (item != NULL) {
                int no;

                sceVu0CopyVector(velo, BTsubo.velocity);
                sceVu0Normalize(velo, velo);
                sceVu0ScaleVector(velo, velo, -2.0f);
                item->SetItem(pos, velo, 4);
                if (iRand(100) % 10 == 0) {
                    no = iRand(10) + 175;
                } else {
                    int r = iRand(100);

                    no = 275;
                    if (r < 80) {
                        no = 268;
                    }
                    if (r < 40) {
                        no = 294;
                        if (iRand(100) < 40) {
                            if (DngSaveDataDungeon->stage_id == 0) {
                                no = 298;
                            } else {
                                if (iRand(100) < 50) {
                                    no = 298;
                                } else {
                                    no = 352;
                                }
                            }
                        }
                    }
                    if (DngSaveDataDungeon->stage_id == 0) {
                        if (DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id] >= 5 && iRand(100) < 20) {
                            no = 381;
                        }
                    } else if (iRand(100) < 20) {
                        no = 381;
                    }
                }
                item->item_no = no;
            }
        }
    }
    if (BTsuboCol != NULL) {
        BTsuboCol->SetCoord(BTsubo.position, 5.0f);
        if (BTsuboCol->hit_num) {
            sceVu0FVECTOR hit;
            sceVu0FVECTOR velo;
            struct VEC4 {
                float v[4];
            };
            *(VEC4 *) hit = *(VEC4 *) BTsuboCol->hit_vec;
            velo[0] = 0.0f;
            velo[1] = 10.0f;
            velo[2] = 0.0f;
            velo[3] = 1.0f;
            BTsubo.Bakuhatsu(velo, hit);
            BTsuboCol->Delete(-1);
            BTsuboCol = NULL;
        }
    }
    BTsubo2.Step();
    sceVu0FVECTOR player;
    MainChara__2->GetPosition(player);
    AutoMapGen.UpdateNaviMap(player, 4);
    if (!(BattleAreaScene->pause_flag & 1)) {
        ActiveMonster->ThinkHost();
    }
    if (BattleAreaScene->pause_flag & 8) {
        return;
    }
    static int water_cnt2 = 0;
    water_cnt2++;
    if (water_cnt2 >= 10) {
        water_cnt2 = 0;
        for (int m = 0; m < 24; m++) {
            CActiveMonster *mons = ActiveMonster->active[m];

            if (mons != NULL && mons->state && mons->target_dist <= mons->clip_dist && mons->mons_move_check.in_water) {
                sceVu0FVECTOR pos;
                sceVu0FVECTOR top;

                sceVu0CopyVector(pos, mons->mons_move_check.water_surface);
                pos[1] += 0.1f;
                float width = mons->GetBodyWidth() / 5.0f;
                float height = mons->GetBodyHeight();
                mons->GetEntryObjectPos(0, 0, top);
                if (top[1] - height <= pos[1]) {
                    FxScriptMan->CreateEffSpt("\x91\xab\x94g\x96\xe4", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                    sceVu0FVECTOR scale = {0.0f, 1.0f, 0.0f, 1.0f};
                    scale[0] = width;
                    scale[2] = width;
                    FxScriptMan->SetScriptVect2(scale, -1, -1);
                }
            }
        }
    }
    if (!(BattleAreaScene->pause_flag & 1)) {
        ActiveMonster->StepEffectScript();
    }
    if (BattleAreaScene->pause_flag & 1) {
        FxScriptMan->PauseFromLevel(3, 3);
    }
    FxScriptMan->Step();
    FxScriptMan->PauseFromLevel(3, 0);
    for (i = 0; i < 16; i++) {
        if (DngMainScene->CheckDrawChara(i + 8) || DngMainScene->CheckDrawCharaShadow(i + 8)) {
            CCharacter2 *chara = DngMainScene->GetCharacter(i + 8);

            if (chara != NULL) {
                sceVu0FVECTOR foot;

                chara->SetWind(power, wind);
                if (chara->GetEntryObjectPos(1, foot)) {
                    chara->SetFloor(foot[1]);
                }
                chara->Step();
                chara->CCharacter2::StepEffect();
            }
        }
    }
    ColPrimMan.Step();
    if (!(BattleAreaScene->pause_flag & 0x400)) {
        CheckStatusError();
        if (MainChara__2->CheckDamage()) {
            ResetEyeView(MainChara__2);
        }
    }
    ActiveMonster->CheckDamage();
    SwordLuminous.Step();
    LevelupInfo.Step();
    LockOnModel.Step();
    RedMarkModel->Step();
    RocketLauncher.Step();
    MachineGun.Step();
    LaserGun.Step();
    DamageScore.Step();
    DamageScore2.Step();
    for (int d = 0; d < 8; d++) {
        DamageScoreMons[d].Step();
    }
    map_effect.Step(&MainCamera);
    BattleFX.Step();
    for (int e = 0; e < 6; e++) {
        Sparc_fx[e].Step();
        thunder[e].Step();
        tornado[e].Step();
        chillAfterHit[e].Step();
        fireAfterHit[e].Step();
    }
    if (!(BattleAreaScene->pause_flag & 0x200)) {
        for (int p = 0; p < 72; p++) {
            PullItem[p].Step();
            PullItem[p].IsGet(player);
        }
        for (int w = 0; w < 16; w++) {
            afterWire[w].StepWire();
        }
    }
    if (BattleAreaScene->statusbar_show && debag_param) {
        WarningGage2.Step();
    }
    MiniEffPrimMan.Step();
    if (DngMainMap != NULL) {
        CObjAnimeEnv env;

        *(u_long128 *) env.chara_pos = *(u_long128 *) MainChara__2->position;
        env.time = DngMainScene->time;
        DngMainMap->EffectStep();
        DngMainMap->AnimeStep(&env);
        DngMainMap->Step();
        HealingEffectMan.Step();
        AutoMapGen.Step();
    }
    RandomCircle.Step();
    GeoStone.GeoStep();
    StepHelpMes();
    BattleSoundManager();
    if (!(BattleAreaScene->pause_flag & 0x400)) {
        GetBattleCharaInfo()->Step();
    }
    if (config->fast_time) {
        DngMainScene->TimeStep(1.5f);
    } else {
        DngMainScene->TimeStep(1.0f);
    }
}
int RunMainEvent() {
    switch (EventLoop()) {
    case EVENT_REQUEST_END:
        DngStatus.mode = DNG_STATUS_FIELD;
        BattleAreaScene->script.running = 0;
        DngMainScene->active_camera = 0;
        BattleAreaScene->pause_flag &= ~0x400;
        LoopSoundManager(1);
        break;
    case EVENT_REQUEST_SUB_MODE:
        DngStatus.mode = DNG_STATUS_EVENT_MENU;
        break;
    case EVENT_REQUEST_GOTO:
        DngStatus.mode = DNG_STATUS_EXIT;
        break;
    }
    return DngStatus.mode;
}
int DngMainKey() {
    DngMainScene->GetCamera(DngMainScene->active_camera);
    if (DebugPause && !DebugFlag) {
        return 0;
    }
    if (DebugFlag) {
        if (dngDebugKey()) {
            DNG_DEBUG_INFO *info = dngGetDebugInfo();

            if (info->command < 0) {
                return 0;
            }
            if (info->command == 0) {
                DBGCMD_RunScript(info->event_no);
                return 0;
            }
            if (info->command == 0) {
                DBGCMD_RunScript(info->event_no);
                return 0;
            }
        }
        if (GamePad__2.Down(0x400)) {
            dngDebugStart();
            return 0;
        }
        if (GamePad__2.Down2(8)) {
            debag_param ^= 1;
        }
        if (GamePad__2.Down2(0x40)) {
            static float         erate = 1.0f;
            static sceVu0FVECTOR chk_pos;

            MainChara__2->GetEntryObjectPos(0, 0, chk_pos);
            wep_effect->Set((sceVu0FVECTOR *) chk_pos, chk_pos, erate, 2, 10.0f);
            erate += 32.0f;
            if (erate > 300.0f) {
                erate = 1.0f;
            }
        }
        if (GamePad__2.Down2(0x10)) {
            float         size = 20.0f;
            sceVu0FVECTOR pos;

            MainChara__2->GetPosition(pos);
            tornado[0].SetPos(pos, size, fRand(255.0f));
            size = 1.0f;
        }
        if (GamePad__2.On2(2)) {
            BattleAreaScene->SetStatusBar(1, 0.02f);
        }
        if (GamePad__2.On2(1)) {
            BattleAreaScene->SetStatusBar(0, 0.02f);
        }
    }
    if (GamePad__2.Down(0x100)) {
        SV_CONFIG_OPTION *config = DngSaveData->GetConfig();

        if (config != NULL) {
            config->map++;
            if (config->map > 2) {
                config->map = 0;
            }
        }
    }
    int               dead = 0;
    CBattleCharaInfo *chara_info = GetBattleCharaInfo();

    if (chara_info != NULL && chara_info->GetNowHp_i() <= 0) {
        dead = 1;
    }
    if (SubGameRunning()) {
        sgLoopSubGame();
        if (GamePad__2.Down(0x10) && sgMenuOpenEnable()) {
            VoiceUnit.StopVoice(10);
            MenuArg.open_type = 1;
            DngStatus.mode = DNG_STATUS_MENU;
            DngMainScene->fade.ResetFade();
            BattleAreaScene->SetStatusBarNow(0);
            WarningGage2.warning[0] = 0;
            WarningGage2.warning[1] = 0;
            WarningGage2.warning[2] = 0;
            LockOnModel.pos[3] = 0.0f;
            return 0;
        }
        return 0;
    }
    if (DngStatus.eye_view && NowTakePhoto()) {
        EyeCamera(DngMainScene->GetCamera(DngMainScene->active_camera), MainChara__2, 0);
        LoopTakePhoto(&PadCtrl, &DngUserData->invent_data);
    }
    IsEventRun();
    sceVu0FVECTOR mark;

    MainChara__2->GetPosition(mark);
    mark[1] += 1.3f * MainChara__2->GetBodyHeight();
    RedMarkModel->SetPosition(mark);
    SYSTEM_SCRIPT_INFO *script;

    if (DngMainScene->event_run) {
        int no;

        DngMainScene->event_run = 0;
        script = &BattleAreaScene->script;
        script->event_no = no = DngMainScene->event_no;
    }
    CSphida *sphida = GetSphidaPtr();

    if (sphida != NULL) {
        if (OmakeFlag && (PadCtrl.Btn(0x15) || !GamePad__2.Connect())) {
            MenuArg.open_type = 28;
            VoiceUnit.StopVoice(10);
            DngStatus.mode = DNG_STATUS_MENU;
            DngMainScene->fade.ResetFade();
            BattleAreaScene->SetStatusBarNow(0);
            return 0;
        }
        if (sphida->Step()) {
            return 0;
        }
    }
    int unit = -1;

    script = &BattleAreaScene->script;

    if (script->event_no != -1) {
        StartupEpisodeTitle.Switch(0);
        EventScriptSetup(script);
        script->event_no = -1;
        return 0;
    }
    if (GamePad__2.Down(0x200)) {
        unit = 0;
    }
    if (GamePad__2.Down(0x400)) {
        unit = 1;
    }
    if (MainChara__2->CheckRunEvent() && unit >= 0 && !dead) {
        unit = ChangeSetUnit(unit);
        if (unit >= 0) {
            VoiceUnit.StopVoice(10);
            MenuArg.param[0] = unit;
            MenuArg.open_type = 21;
            DngStatus.mode = DNG_STATUS_MENU;
            DngMainScene->fade.ResetFade();
            BattleAreaScene->SetStatusBarNow(0);
            MainChara__2->RemoveThrowItem();
            WarningGage2.warning[0] = 0;
            WarningGage2.warning[1] = 0;
            WarningGage2.warning[2] = 0;
            LockOnModel.pos[3] = 0.0f;
            return 0;
        }
    }
    if (GamePad__2.On(0x10) && MainChara__2->CheckRunEvent() && !dead) {
        if (NowTakePhoto()) {
            MenuArg.open_type = 10;
        } else {
            MenuArg.open_type = 1;
        }
        VoiceUnit.StopVoice(10);
        DngStatus.mode = DNG_STATUS_MENU;
        DngMainScene->fade.ResetFade();
        BattleAreaScene->SetStatusBarNow(0);
        MainChara__2->RemoveThrowItem();
        WarningGage2.warning[0] = 0;
        WarningGage2.warning[1] = 0;
        WarningGage2.warning[2] = 0;
        LockOnModel.pos[3] = 0.0f;
        return 0;
    }
    CActionChara   *chara = MainChara__2;
    CCameraControl *camera = (CCameraControl *) DngMainScene->GetCamera(DngMainScene->active_camera);

    if (DngStatus.eye_view) {
        if (GamePad__2.Down(2) || PadCtrl.Btn(1)) {
            ResetEyeView(MainChara__2);
            return 0;
        }
    } else if (GamePad__2.Down(2) && !SubGameRunning() && MainChara__2->CheckRunEvent()) {
        InitEyeCamera(MainChara__2);
        return 0;
    }
    if (!DngStatus.eye_view && GamePad__2.Down(0x80) && !(BattleAreaScene->pause_flag & 4) && chara_info->chr_no == 0 &&
        MainChara__2->CheckRunEvent()) {
        int            found = 0;
        CGameDataUsed *items = GetBattleCharaInfo()->GetActiveItemInfo(0);

        if (BattleAreaScene->statusbar_show) {
            CGameDataUsed *item = &items[DngStatus.active_item];

            if (item->item_no == 369) {
                found = 1;
            }
        } else {
            for (int i = 0; i < 3; i++) {
                if (items[i].item_no == 369) {
                    found = 1;
                }
            }
        }
        if (found) {
            StartTakePhoto();
            InitEyeCamera(MainChara__2);
            return 0;
        }
    }
    if (BattleAreaScene->pause_flag & 4) {
        ResetEyeView(MainChara__2);
    }
    if (DngUserData->active_chr_no == USER_CHARA_ROBO && DngUserData->CheckRoboVoiceFlag() && VoiceUnit.status == 0) {
        VoiceUnit.StartVoiceSystem();
    }
    if (IsRunDeadEvent(MainChara__2)) {
        ResetEyeView(MainChara__2);
    }
    if (!DngStatus.eye_view) {
        if (!DebugPause && !(BattleAreaScene->pause_flag & 4)) {
            MainChara__2->RunScript(DngMainScene, &ActionScriptEnv);
        }
        if (MainChara__2->CheckReleaseTimming(-1)) {
            if (MainChara__2->CheckReleaseTimming(-1) == 5) {
                BTsubo.Hold(MainChara__2->hold_parts);
                BTsubo2.SetObject2(DngStatus.dungeon_no, AutoMapGen.pot_parts);
                BTsubo.Throw();
                BTsuboCol = ColPrimMan.GetPrim();
                if (BTsuboCol != NULL) {
                    BTsuboCol->SetDamage("\x92\xd9", 0);
                }
            }
            if (MainChara__2->CheckReleaseTimming(4) == 1) {
                BTsubo.Hold(MainChara__2->hold_parts);
                BTsubo2.SetObject2(DngStatus.dungeon_no, AutoMapGen.pot_parts);
            }
            if (MainChara__2->CheckReleaseTimming(-1) == 3) {
                MainChara__2->GetNowFrame(0);
                BTsubo.Throw();
                BTsuboCol = ColPrimMan.GetPrim();
                if (BTsuboCol != NULL) {
                    BTsuboCol->SetDamage("\x92\xd9", 0);
                }
            }
        }
        MainCamera.rot_reverse = !DngSaveData->GetConfig()->unk_37;
        static int camera_default_dist = 1;
        float      dist_table[3] = {100.0f, 160.0f, 500.0f};

        if (GamePad__2.Down2(0x100)) {
            if (camera_default_dist >= 2) {
                camera_default_dist = 0;
            } else {
                camera_default_dist++;
            }
            MainCamera.SetDistance(dist_table[camera_default_dist]);
            test_dist = dist_table[camera_default_dist];
        }
        static int   cam_table[] = {0, 1, 2, 3};
        static float cam_table_dist[][2] = {{110.0f, 140.0f}, {110.0f, 140.0f}, {130.0f, 190.0f}, {110.0f, 140.0f}};
        int          n;

        for (n = 0;; n++) {
            if (cam_table[n] == DngUserData->GetActiveChrNo()) {
                camera->GetActiveParam()->min_dist = cam_table_dist[n][0];
                camera->GetActiveParam()->max_dist = cam_table_dist[n][1];
                break;
            }
        }
        sceVu0FVECTOR ref;
        sceVu0FVECTOR dir;

        chara->GetPosition(ref);
        MainCamera.SetCheckRef(ref);
        sceVu0CopyVector(dir, chara->velocity);
        static float reference = 0.0f;

        ref[0] += 3.0f * dir[0];
        ref[1] += 2.0f * dir[1] + reference;
        ref[2] += 3.0f * dir[2];
        BattleAreaScene->ApplyQuake(&ref[1]);
        camera->SetFollow(ref[0], ref[1], ref[2]);
        if (chara->lock_on && chara->target_no >= 0) {
            int             no = chara->target_no - 24;
            CActiveMonster *mons = ActiveMonster->active[no];

            if (mons != NULL) {
                mons->GetPosition(dir);
                sceVu0SubVector(dir, dir, ref);
                float dist = mgDistVector(dir);

                if (dist >= 20.0f) {
                    dist = 20.0f;
                }
                sceVu0Normalize(dir, dir);
                sceVu0ScaleVector(dir, dir, dist);
                sceVu0AddVector(ref, ref, dir);
                camera->SetFollow(ref[0], ref[1], ref[2]);
                sceVu0FVECTOR mons_pos;
                int           screen[4];

                mons->GetPosition(mons_pos);
                if (mgTransWorldScreen(screen, mons_pos)) {
                    screen[0] >>= 4;
                    if (screen[0] > 480) {
                        float rate = ((float) screen[0] - 480.0f) / 128.0f;

                        if (rate > 1.0f) {
                            rate = 1.0f;
                        }
                        MainCamera.Rotate(-(0.1308997f * rate));
                    }
                    if (screen[0] < 32) {
                        float rate = (float) screen[0] - 32.0f;

                        rate /= 128.0f;
                        MainCamera.Rotate(-(0.1308997f * rate));
                    }
                } else {
                    sceVu0FVECTOR diff;
                    sceVu0FVECTOR chara_pos;
                    sceVu0FVECTOR target;

                    MainChara__2->GetPosition(chara_pos);
                    mons->GetPosition(target);
                    sceVu0SubVector(diff, target, chara_pos);
                    float now = MainCamera.GetAngle();
                    float angle = atan2f(diff[0], diff[2]) - now;

                    if (angle > 3.1415927f) {
                        angle -= 6.2831855f;
                    }
                    if (angle <= -3.1415927f) {
                        angle += 6.2831855f;
                    }
                    if (angle > 0.0f) {
                        MainCamera.Rotate(-0.09817477f);
                    }
                    if (angle < 0.0f) {
                        MainCamera.Rotate(0.09817477f);
                    }
                }
            }
        }
        if (BattleAreaScene->unk_54 == 0) {
            if (DebugInfo.debug_camera == 0) {
                sceVu0FVECTOR rot;

                camera->ControlOn();
                MainChara__2->GetRotation(rot);
                float     dist = camera->GetDistance();
                CMap     *map = DngMainScene->GetMap(DngMainScene->active_map);
                CCPoly    poly[512];
                mgVu0FBOX box;
                sceVu0FVECTOR pos;

                MainChara__2->GetPosition(pos);
                box.max[0] = pos[0] + dist + 10.0;
                box.min[0] = pos[0] - dist - 10.0;
                box.max[1] = pos[1] + dist + 10.0;
                box.min[1] = pos[1] - dist - 10.0;
                box.max[2] = pos[2] + dist + 10.0;
                box.min[2] = pos[2] - dist - 10.0;
                box.max[3] = 1.0f;
                box.min[3] = 1.0f;
                int num = map->GetCameraPoly(poly, box, 512);

                if (num < 0) {
                    printf("camera ply not found\n");
                    return 0;
                }
                camera->MoveCamera(&PadCtrl, rot, poly, num);
            }
            if (DebugInfo.debug_camera == 1) {
                camera->ControlOff();
                camera->AddAngle(0.06f * -GamePad__2.GetRXf());
                if (GamePad__2.On(0x200)) {
                    camera->AddDistance(3.0f * GamePad__2.GetRYf());
                } else {
                    camera->AddHeight(3.0f * -GamePad__2.GetRYf());
                }
                if (GamePad__2.On(1)) {
                    reference += 3.0f * -GamePad__2.GetRYf();
                }
            }
            if (PadCtrl.Btn(0x34)) {
                sceVu0FVECTOR rot;

                MainChara__2->GetRotation(rot);
                float angle = rot[1];

                if (MainChara__2->lock_on && chara->target_no >= 0) {
                    int             no = chara->target_no - 24;
                    CActiveMonster *mons = ActiveMonster->active[no];

                    if (mons != NULL) {
                        sceVu0FVECTOR chara_pos;
                        sceVu0FVECTOR target;

                        mons->GetPosition(target);
                        MainChara__2->GetPosition(chara_pos);
                        sceVu0SubVector(target, target, chara_pos);
                        angle = atan2f(target[0], target[2]);
                    }
                }
                angle += 3.1415927f;
                if (angle > 3.1415927f) {
                    angle -= 6.2831855f;
                }
                camera->RotBack(angle);
            }
        }
        if (BattleAreaScene->unk_54 == 1) {
            MainCamera.FollowOff();
            CCharacter2  *boss = DngMainScene->GetCharacter(24);
            sceVu0FVECTOR chara_pos;

            MainChara__2->GetPosition(chara_pos);
            chara_pos[1] += 2.0f * MainChara__2->GetBodyHeight();
            sceVu0FVECTOR boss_pos;

            boss->GetEntryObjectPos(0, 0, boss_pos);
            if (boss_pos[1] > 160.0f) {
                boss_pos[1] = 160.0f;
            }
            sceVu0FVECTOR eye;

            sceVu0SubVector(eye, chara_pos, boss_pos);
            eye[3] = 1.0f;
            mgDistVector(eye);
            float height = atan2f(sqrt(eye[0] * eye[0] + eye[2] * eye[2]), eye[1]) / 3.1415927f / 2.0f;

            if (sqrt(eye[0] * eye[0] + eye[2] * eye[2]) < 20.0) {
                MainCamera.GetPos(eye);
            } else {
                sceVu0Normalize(eye, eye);
                sceVu0ScaleVectorXYZ(eye, eye, 140.0f);
                sceVu0AddVector(eye, eye, chara_pos);
                if (eye[1] <= 1.0f + 10.0f * height) {
                    eye[1] = 1.0f + 10.0f * height;
                }
            }
            BattleAreaScene->ApplyQuake(&eye[1]);
            MainCamera.SetPos(eye);
            MainCamera.SetRef(boss_pos);
        }
        if (BattleAreaScene->unk_54 == 2) {
            MainCamera.FollowOff();
            sceVu0FVECTOR pos;

            MainChara__2->GetPosition(pos);
            float         angle = atan2f(pos[0] - 268.8, pos[2] - -322.4);
            sceVu0FVECTOR from;
            sceVu0FVECTOR to;

            from[0] = pos[0];
            from[1] = 0.0f;
            from[2] = pos[2];
            from[3] = 1.0f;
            to[0] = 268.8f;
            to[1] = 0.0f;
            to[2] = -322.4f;
            to[3] = 1.0f;
            float         rate = (mgDistVector(from, to) - 172.0) / 497.0;
            float         k_radius = 450.0f;
            float         k_eye = 50.0f;
            float         k_ref = -100.0f;
            float         radius = rate * k_radius;
            float         eye_y;
            float         ref_y;

            radius += 350.0f;
            eye_y = rate * k_eye;
            eye_y += 800.0f;
            ref_y = rate * k_ref;
            ref_y += 850.0f;
            rate = 268.8 + radius * sin(angle);
            MainCamera.SetNextPos(rate, eye_y, -322.4 + radius * cos(angle));
            MainCamera.SetNextRef(268.8f, ref_y, -322.4f);
        }
        if (BattleAreaScene->unk_54 == 4) {
            sceVu0FVECTOR rot;

            camera->ControlOn();
            MainChara__2->GetRotation(rot);
            float     dist = camera->GetDistance();
            CMap     *map = DngMainScene->GetMap(DngMainScene->active_map);
            CCPoly    poly[512];
            mgVu0FBOX box;
            sceVu0FVECTOR pos;

            MainChara__2->GetPosition(pos);
            box.max[0] = pos[0] + dist + 10.0;
            box.min[0] = pos[0] - dist - 10.0;
            box.max[1] = pos[1] + dist + 10.0;
            box.min[1] = pos[1] - dist - 10.0;
            box.max[2] = pos[2] + dist + 10.0;
            box.min[2] = pos[2] - dist - 10.0;
            box.max[3] = 1.0f;
            box.min[3] = 1.0f;
            int num = map->GetCameraPoly(poly, box, 512);

            if (num < 0) {
                return 0;
            }
            CameraCtrlParam *param = camera->GetActiveParam();

            param->min_height = param->rest_min_height = -37.0f;
            camera->MoveCamera(&PadCtrl, rot, poly, num);
            if (PadCtrl.Btn(0x34)) {
                sceVu0FVECTOR rot2;

                MainChara__2->GetRotation(rot2);
                float angle = rot2[1];

                if (MainChara__2->lock_on && chara->target_no >= 0) {
                    int             no = chara->target_no - 24;
                    CActiveMonster *mons = ActiveMonster->active[no];

                    if (mons != NULL) {
                        sceVu0FVECTOR chara_pos;
                        sceVu0FVECTOR target;

                        mons->GetPosition(target);
                        MainChara__2->GetPosition(chara_pos);
                        sceVu0SubVector(target, target, chara_pos);
                        angle = atan2f(target[0], target[2]);
                    }
                }
                angle += 3.1415927f;
                if (angle > 3.1415927f) {
                    angle -= 6.2831855f;
                }
                camera->RotBack(angle);
            }
        }
    } else {
        EyeCamera(camera, chara, 0);
    }
    sceVu0FVECTOR pos;

    MainChara__2->GetPosition(pos);
    AutoMapGen.MinimapVisTest(pos);
    static int time_step = 0;

    if (GamePad__2.On2(0x2000)) {
        DngMainScene->AddTime(0.1f);
    }
    if (GamePad__2.On2(0x8000)) {
        DngMainScene->AddTime(-0.1f);
    }
    if (GamePad__2.Down2(0x1000)) {
        DngMainScene->SetTime((int) DngMainScene->time / 2 * 2 + 2);
    }
    if (GamePad__2.Down2(0x4000)) {
        time_step = !time_step;
    }
    if (time_step) {
        DngMainScene->AddTime(0.003f);
    }
    return 0;
}
void IsEventRun() {
    sceVu0FVECTOR     pos;
    CBattleCharaInfo *info;
    int               button;
    int               near;
    s16              *event_no;

    if (MainChara__2 == NULL) {
        return;
    }
    MainChara__2->GetPosition(pos);
    event_no = &BattleAreaScene->script.event_no;
    info = GetBattleCharaInfo();
    if (info == NULL) {
        return;
    }
    if (info->GetNowHp_i() <= 0) {
        return;
    }
    if (!MainChara__2->move_check.landed) {
        return;
    }
    static int npc_heal_cnt = 0;
    if (info->chr_no != USER_CHARA_ROBO) {
        npc_heal_cnt++;
        if (npc_heal_cnt > 150) {
            info->UseNPCPoint(-1);
            npc_heal_cnt = 0;
        }
    }
    if (MainChara__2->move_check.ground_poly.area_kind == 8 && info->chr_no != USER_CHARA_ROBO) {
        int max;
        int attr;

        attr = info->GetAttr() & 0x6F;
        max = info->GetMaxHp_i();

        if ((max > info->GetNowHp_i() || attr) && AutoMapGen.healing_point.CheckHealingTime()) {
            float healing = 9999.0f;
            info->AddHp_Point(healing, 0.0f);
            info->SetAttr(0x6F, 1);
            FxScriptMan->CreateEffSpt("\x92\xca\x8f\xed\x89\xf1\x95\x9c", 0, 0);
            FxScriptMan->SetScriptTargetId(0, -1, -1);
            CPalletAnime *pallet = &MainChara__2->unk_67c;
            pallet->red = 0x60;
            pallet->green = 0xB4;
            pallet->blue = 0xFF;
            pallet->pulse_num = 1;
            pallet->duration = 45;
            pallet->elapsed = 0;
            pallet->repeats = 0;
            sndSePlay(GetSystemSndID(), 10, 0);
            BattleAreaScene->unk_98 |= 0x80;
        }
    }
    if (info->GetAttr() & 0x28) {
        return;
    }
    int run = ActiveMonster->IsRunEvent();
    if (run != -1) {
        *event_no = run;
        return;
    }
    int num = ActiveMonster->GetMonsterNum(-1.0f);
    num += TreasureBoxMan->MimicCount();
    if (num == 0 && BattleAreaScene->unk_5c == 0) {
        *event_no = 1500;
        BattleAreaScene->unk_5c = 1;
        ColPrimMan.Initialize(DngMainScene);
        BTsubo.Clear();
        BTsuboCol = NULL;
        return;
    }
    if (DngStatus.eye_view) {
        return;
    }
    if (!DngSaveData->GetBitFlag(0x3B) && info->GetMagicSwordCounterNow() > 0) {
        *event_no = 2540;
        DngSaveData->SetBitFlag(0x3B, 1);
        return;
    }
    if (!MainChara__2->CheckRunEvent()) {
        return;
    }
    if (RandomCircle.CheckEvent(pos) != -1) {
        *event_no = 1120;
        MainChara__2->ResetAccele();
        return;
    }
    button = 0;
    if (PadCtrl.Btn(0)) {
        button = 1;
    }
    if (PadCtrl.Btn(0x33)) {
        button = 2;
    }
    near = 0;
    CActiveMonster *target = ActiveMonster->GetPriorityLevelIndex(0, NULL);
    if (target != NULL && target->target_dist < 200.0f) {
        near = 1;
    }
    CSceneEventData data;
    if (DngMainScene->GetMapEvent(pos, button, &data)) {
        DngMainScene->RunEvent(data.event.point_no, &data);
        return;
    }
    if (DngMainScene->map_event_no) {
        RedMarkModel->draw_request = 1;
    }
    if (!DngSaveData->GetBitFlag(0x35) && info->chr_no == USER_CHARA_ROBO && MainChara__2->move_type == 3) {
        *event_no = 2530;
        DngSaveData->SetBitFlag(0x35, 1);
    }
    if (!DngSaveData->GetBitFlag(0x32) && (info->chr_no == USER_CHARA_MAX || info->chr_no == USER_CHARA_MONICA)) {
        if (AutoMapGen.SearchRandomStone(pos, 30.0f)) {
            if (button == 1) {
                *event_no = 2500;
                return;
            }
            RedMarkModel->draw_request = 1;
        }
    }
    if (!DngSaveData->GetBitFlag(0x34) && LevelupInfo.phase != 0) {
        *event_no = 2520;
        DngSaveData->SetBitFlag(0x34, 1);
        return;
    }
    if (GeoStone.CheckEvent(pos)) {
        if (button == 1) {
            *event_no = 1130;
            return;
        }
        RedMarkModel->draw_request = 1;
    }
    float dist = 30.0f;
    if (info->chr_no == USER_CHARA_ROBO) {
        dist = 50.0f;
    }
    if (TreasureBoxMan->CheckEvent(pos, dist) >= 0 && !near) {
        if (button == 1) {
            *event_no = 1100;
            return;
        }
        RedMarkModel->draw_request = 1;
    }
    int talk = ActiveMonster->CheckMonsterTolk(pos);
    if (talk != -1) {
        if (button == 1 || button == 2) {
            *event_no = 1150;
            EdEventInfo.monster_talk[0] = talk + 24;
            EdEventInfo.monster_talk[2] = ActiveMonster->active[talk]->locate_param;
            EdEventInfo.monster_talk[1] = ActiveMonster->active[talk]->monster_id;
        } else {
            RedMarkModel->draw_request = 1;
        }
    }
}
int EventScriptSetup(SYSTEM_SCRIPT_INFO *script) {
    InitEvent(DngMainScene);
    VoiceUnit.StopVoice(10);
    DngMainScene->fade.ResetFade();
    if (RunEvent(script->event_no, DngMainScene)) {
        script->running = 1;
        printf("RUN SYS_SCRIPT %d\n", script->event_no);
        DngStatus.mode = DNG_STATUS_EVENT;
        DngMainScene->before_camera = 0;
        ResetEyeView(MainChara__2);
        memcpy(&EventCamera, &MainCamera, sizeof(CCameraControl));
        DngMainScene->active_camera = 1;
        MainChara__2->sound_info.foot_sound_id = -1;
        LoopSoundManager(0);
        BattleAreaScene->pause_flag |= 0x400;
        MainChara__2->RemoveThrowItem();
        MsgTaskMan.Clear();
        BattleAreaScene->script.event_no = -1;
        return 1;
    }
    return 0;
}
int IsRunDeadEvent(CActionChara *chara) {
    CBattleCharaInfo *info;

    if (DngStatus.mode != DNG_STATUS_FIELD) {
        return 0;
    }
    info = GetBattleCharaInfo();
    if (info->chr_no == USER_CHARA_MONSTER) {
        if (info->GetWhpNowVol(0) <= 0) {
            chara->damage_req = ACTION_DAMAGE_REQ_DEAD;
            return 1;
        }
    }
    if (info->GetNowHp_i() <= 0) {
        chara->damage_req = ACTION_DAMAGE_REQ_DEAD;
        return 1;
    }
    return 0;
}
int ChangeSetUnit(int dir) {
    CUserDataManager *user = GetUserDataMan();
    int next = -1;
    int chr = user->active_chr_no;

    if (dir == 0) {
        if (chr == USER_CHARA_MAX && DngUserData->CheckQuickChange(USER_CHARA_MONICA, NULL)) {
            next = USER_CHARA_MONICA;
        }
        if (chr == USER_CHARA_MONICA && DngUserData->CheckQuickChange(USER_CHARA_MAX, NULL)) {
            next = USER_CHARA_MAX;
        }
    }
    if (dir == 1) {
        if (chr == USER_CHARA_MAX && DngUserData->CheckQuickChange(USER_CHARA_ROBO, NULL)) {
            next = USER_CHARA_ROBO;
        }
        if (chr == USER_CHARA_MONICA && DngUserData->CheckQuickChange(USER_CHARA_MONSTER, NULL)) {
            next = USER_CHARA_MONSTER;
        }
        if (chr == USER_CHARA_ROBO && DngUserData->CheckQuickChange(USER_CHARA_MAX, NULL)) {
            next = USER_CHARA_MAX;
        }
        if (chr == USER_CHARA_MONSTER && DngUserData->CheckQuickChange(USER_CHARA_MONICA, NULL)) {
            next = USER_CHARA_MONICA;
        }
    }
    return next;
}
void CheckStatusError() {
    sceVu0FVECTOR     pos;
    sceVu0FVECTOR     top;
    CBattleCharaInfo *info;
    int               damage;
    int               step;
    int               attr;

    if (MainChara__2 == NULL) {
        return;
    }
    MainChara__2->GetEntryObjectPos(0, 0, pos);
    info = GetBattleCharaInfo();
    step = info->StatusParamStep(&damage);
    attr = info->GetAttr();
    if (info->GetNowHp_i() <= 0) {
        return;
    }
    MainChara__2->GetEntryObjectPos(0, 0, top);
    top[1] += MainChara__2->body_height;
    if (step & 1) {
        DamageScore2.SetValue(0, damage, MainChara__2->body_height);
        MainChara__2->pallet[0].SetAnim(0x60, 0x20, 0x60, 1, 30, 0);
    }
    DngStatus.status_count++;
    if (DngStatus.status_count >= 45) {
        DngStatus.status_count = 0;
        if (attr & 0x10) {
            MainChara__2->pallet[0].SetAnim(0x100, 0xDC, 0x40, 1, 45, 0);
        }
        if (attr & 0x2) {
            MainChara__2->pallet[0].SetAnim(0xA0, 0x40, 0xA0, 1, 45, 0);
        }
        if (attr & 0x8) {
            MainChara__2->pallet[0].SetAnim(0x80, 0x40, 0, 1, 45, 0);
        }
        if (attr & 0x20) {
            MainChara__2->pallet[0].SetAnim(0x20, 0x20, 0x20, 1, 45, 0);
        }
    }
    if (info->GetNowHp_i() <= 0) {
        MainChara__2->damage_req = ACTION_DAMAGE_REQ_DEAD;
    }
}

static sceVu0FVECTOR backup_pos;

void InitEyeCamera(CActionChara *chara) {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    sceVu0FVECTOR     rot;
    sceVu0FVECTOR     arm_rot;
    CActionChara     *arm;
    mgCCamera        *camera;

    chara->GetRotation(rot);
    if (info->chr_no == USER_CHARA_ROBO) {
        arm = MainChara__2->SearchChara(at_3589);
        if (arm != NULL) {
            arm->GetRotation(arm_rot);
            rot[1] = mgAngleLimit(rot[1] + arm_rot[1]);
        }
    }
    viewAngleV__2 = 0.0f;
    viewAngleH__2 = rot[1];
    camera = DngMainScene->GetCamera(DngMainScene->active_camera);
    if (camera != NULL) {
        camera->GetPos(backup_pos);
        ((mgCCameraFollow *) camera)->FollowOff();
        init_camera = 1;
    }
    DngStatus.eye_view = 1;
    MainChara__2->Show(0, 1);
    mgSetAllScissorFlag(1);
}
void CheckWeaponEnable() {
    CActionChara *weapon;

    if (BattleAreaScene->pause_flag & 0x2000) {
        weapon = MainChara__2->SearchChara(at_3602);
        if (weapon != NULL) {
            weapon->Show(0, 0);
        }
        weapon = MainChara__2->SearchChara(at_1940);
        if (weapon != NULL) {
            weapon->Show(0, 0);
        }
    } else {
        MainChara__2->Show(1, 1);
    }
}
void ResetEyeView(CActionChara *chara) {
    mgCCamera *camera;

    if (DngStatus.eye_view == 0) {
        return;
    }
    camera = DngMainScene->GetCamera(DngMainScene->active_camera);
    if (camera != NULL) {
        if (init_camera) {
            camera->SetPos(backup_pos);
        }
        ((mgCCameraFollow *) camera)->FollowOn();
    }
    DngStatus.eye_view = 0;
    chara->Show(1, 1);
    CheckWeaponEnable();
    mgSetAllScissorFlag(0);
    init_camera = 0;
    if (NowTakePhoto()) {
        EndTakePhoto();
    }
}
static void EyeCamera(mgCCamera *camera, CCharacter2 *chara, int mode) {
    float         lx;
    float         ly;
    float         speed = 0.04f;
    SV_CONFIG_OPTION *config;
    sceVu0FVECTOR pos;
    sceVu0FVECTOR ref;
    sceVu0FMATRIX rot;
    sceVu0FMATRIX unit;

    if (mode) {
        lx = 0.0f;
        ly = -GamePad__2.GetRYf();
    } else {
        lx = GamePad__2.GetLXf();
        ly = -GamePad__2.GetLYf();
        config = &GetSaveData()->config;
        if (config->eye_reverse) {
            ly = -ly;
        }
    }
    if (lx > 0.0f) {
        viewAngleH__2 -= lx * speed;
        if (viewAngleH__2 < -3.1415927f) {
            viewAngleH__2 += 6.2831855f;
        }
    }
    if (lx < 0.0f) {
        viewAngleH__2 -= lx * speed;
        if (viewAngleH__2 > 3.1415927f) {
            viewAngleH__2 -= 6.2831855f;
        }
    }
    if (ly > 0.0f && viewAngleV__2 < 0.65f) {
        viewAngleV__2 += ly * speed;
    }
    if (ly < 0.0f && viewAngleV__2 > -1.0f) {
        viewAngleV__2 += ly * speed;
    }
    ref[0] = 0.0f;
    ref[1] = 0.0f;
    ref[2] = 10.0f;
    ref[3] = 0.0f;
    sceVu0UnitMatrix(unit);
    sceVu0RotMatrixX(rot, unit, viewAngleV__2);
    sceVu0RotMatrixY(rot, rot, viewAngleH__2);
    sceVu0ApplyMatrix(ref, rot, ref);
    chara->GetPosition(pos);
    pos[1] += 28.0f;
    ref[0] += pos[0];
    ref[1] += pos[1];
    ref[2] += pos[2];
    camera->SetPos(pos);
    camera->SetRef(ref);
}
int debug_no[7] = {100, 0, 1, 0, 0, 0, 0};

void DebugMainDraw() {
    if (DngStatus.debug_window) {
        mgTexManager.ReloadTexture(0x6C, (sceVif1Packet *) NULL);
        CPreSprite prim;
        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.TextureMapEnable(0);
        prim.Begin(6);
        prim.Color(0x10, 0x10, 0x40, 0x74);
        prim.Vertex(0x10, 0x28, 0);
        prim.Vertex(0x100, 0x120, 0);
        prim.End();
        JisFont.Clear();
        JisFont.color[0] = 0xFF;
        JisFont.color[1] = 0xFF;
        JisFont.color[2] = 0xFF;
        JisFont.color[3] = 0xA0;
        JisFont.PrintDirect(0x10, 0x28, "-DEBUG MENU-");
        char *menu[7] = {"%sRUN SCRIPT %d",  "%sENEMY RELOAD %d", "%sBGM %d",       "%sRANDOM MAP %d",
                         "%sPLAY SPHIDA %d", "%sCAMERA DEBUG %d", "%sMOVE DEBUG %d"};
        int   i;

        for (i = 0; i < 7; i++) {
            if (debug_cursor == i) {
                JisFont.PrintDirect(0x10, 0x40 + i * 0x10, menu[i], ">", debug_no[i]);
            } else {
                JisFont.PrintDirect(0x10, 0x40 + i * 0x10, menu[i], " ", debug_no[i]);
            }
        }
        mgCMemory *stack = DngMainScene->GetStack(5);
        stack->stReset();
        JisFont.PrintDirect(0x10, 0xD0, " Main    %4d/%4d KB\n", MainBuffer->stGetUsed() * 16 / 1024,
                            MainBuffer->stGetSize() * 16 / 1024);
        JisFont.PrintDirect(0x10, 0xE0, " Stage   %4d/%4d KB\n", BuffStageChara.stack_used * 16 / 1024,
                            BuffStageChara.stack_size * 16 / 1024);
        JisFont.PrintDirect(0x10, 0xF0, " Chara   %4d/%4d KB\n", BuffCharacter.stack_used * 16 / 1024,
                            BuffCharacter.stack_size * 16 / 1024);
        JisFont.PrintDirect(0x10, 0x100, " Script  %4d/%4d KB\n", BuffScriptData.stack_used * 16 / 1024,
                            BuffScriptData.stack_size * 16 / 1024);
        JisFont.PrintDirect(0x10, 0x110, " TOTAL   %4d/%d KB\n", (stack->stack_size - stack->stack_used) * 16 / 1024,
                            stack->stack_size * 16 / 1024);
        if (debug_mons_cur != -1) {
            prim.Initialize(NULL, NULL);
            prim.Preset2D();
            prim.TextureMapEnable(0);
            prim.Begin(6);
            prim.Color(8, 8, 0x20, 0x74);
            prim.Vertex(0x5C, 0x3C, 0);
            prim.Vertex(0x168, 0x158, 0);
            prim.End();
            JisFont.PrintDirect(0x60, 0x40, "\x83\x82\x83\x93\x83X\x83^\x81[\x83\x8d\x81[\x83_\x81|");
            for (int k = 0; k < 16; k++) {
                int               no = debug_mons_no + k;
                BASE_MONSTER_TBL *def = &base_monster_define[no];

                if (def->name[0] == 0 || debug_mons_num <= no) {
                    if (k == debug_mons_cur) {
                        JisFont.PrintDirect(0x60, 0x50 + k * 0x10, ">%3d.---------", no);
                    } else {
                        JisFont.PrintDirect(0x60, 0x50 + k * 0x10, " %3d.---------", no);
                    }
                } else if (k == debug_mons_cur) {
                    JisFont.PrintDirect(0x60, 0x50 + k * 0x10, ">%3d.%s", no, def->name);
                } else {
                    JisFont.PrintDirect(0x60, 0x50 + k * 0x10, " %3d.%s", no, def->name);
                }
            }
        }
    }
}
void DBGCMD_RunScript(int no) {
    mgCMemory *stack;

    EntryEventScript(DngStatus.dungeon_no);
    stack = GetMainStack();
    BuffEventData[0].stSetBuffer(stack->stack + stack->stack_used, stack->stack_size - stack->stack_used);
    memcpy(&EventCamera, &MainCamera, sizeof(CCameraControl));
    DngMainScene->active_camera = 1;
    InitEvent(DngMainScene);
    if (RunEvent(no, DngMainScene)) {
        DngStatus.debug_window = 0;
        DngStatus.mode = DNG_STATUS_EVENT;
        DngMainScene->before_camera = 0;
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", cam_table_3000__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", cam_table_dist_3001__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1063__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1064__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1065__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1066__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1067__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1068__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1069__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1070__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1071__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1072__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1073__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1074__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1075__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1076__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1077__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1078__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1079__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1080__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1940__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3589__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3602__DATA);

// Virtual tables (.vtables)

// Small initialised data (.sdata)

// Small uninitialised data (.sbss)
INCLUDE_BSS(init_1107, 0x4);
INCLUDE_BSS(init_1824, 0x4);
INCLUDE_BSS(water_cnt_2619, 0x4);
INCLUDE_BSS(init_2620, 0x4);
INCLUDE_BSS(water_cnt2_2681, 0x4);
INCLUDE_BSS(init_2682, 0x4);
INCLUDE_BSS(erate_2867, 0x4);
INCLUDE_BSS(init_2868, 0x4);
INCLUDE_BSS(camera_default_dist_2991, 0x4);
INCLUDE_BSS(init_2992, 0x4);
INCLUDE_BSS(reference_3008, 0x4);
INCLUDE_BSS(init_3009, 0x4);
INCLUDE_BSS(time_step_3092, 0x4);
INCLUDE_BSS(init_3093, 0x4);
INCLUDE_BSS(npc_heal_cnt_3352, 0x4);
INCLUDE_BSS(init_3353, 0x4);
INCLUDE_BSS(debug_cursor, 0x4);
INCLUDE_BSS(debug_mons_no, 0x4);
INCLUDE_BSS(debug_mons_cur, 0x4);
INCLUDE_BSS(debug_mons_num, 0x4);
