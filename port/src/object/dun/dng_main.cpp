#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <memory>
#include <string>

#include "actionchara.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "charasetup.hpp"
#include "collision.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dbg_font.hpp"
#include "dng_debug.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
#include "dng_status.hpp"
#include "dungeon_articles.hpp"
#include "editexception.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "eventedit.hpp"
#include "font.hpp"
#include "funcpoint.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "helpmes.hpp"
#include "log/game_output.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapselect.hpp"
#include "memory/tracked_copy.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "nowload.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "pot.hpp"
#include "prespr.hpp"
#include "quest.hpp"
#include "savedata.hpp"
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "screeneffect.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "sphida.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"
#include "water.hpp"
#include "wavetable.hpp"

/**
 *
 * Stack that the dungeon's long-lived objects are allocated from.
 *
 */
mgCMemory *MainBuffer;
u_long128 *BuffReadData;

namespace {
/**
 * Owns the dungeon monster controller so its arena members are destroyed before the dungeon backing is reset.
 */
std::unique_ptr<CMonsterMan> &DungeonMonsterOwner() {
    static std::unique_ptr<CMonsterMan> owner;
    return owner;
}

/**
 * Stops dungeon initialization when a required checked allocation cannot be constructed.
 */
template <class T>
T *RequireDungeonAllocation(T *value) {
    if (value == nullptr) {
        dc2::log::PrintGame("dungeon allocation failed\n");
        std::exit(EXIT_FAILURE);
    }
    return value;
}

/**
 * Releases the owned monster controller while preserving an independently borrowed controller alias.
 */
void ResetDungeonMonsters() {
    auto &owner = DungeonMonsterOwner();
    if (ActiveMonster == owner.get()) {
        ActiveMonster = nullptr;
    }
    owner.reset();
}
} // namespace

std::span<u8> dc2::dungeon::ReadStorage() {
    if (MainBuffer == nullptr || BuffReadData == nullptr) {
        return {};
    }
    auto                  storage = dc2::memory::AllocationBytes(*MainBuffer, BuffReadData);
    constexpr std::size_t kScratchBytes = 0x20000 * sizeof(u_long128);
    // The renderer places its cross texture at this offset; nowload owns a later region.
    return storage.first(std::min(storage.size(), kScratchBytes));
}

/**
 *
 * Non-zero to draw the dungeon's interface; the debug pad toggles it.
 *
 */
static int debag_param;
/**
 *
 * Horizontal angle of the eye view, in radians.
 *
 */
float viewAngleH__2;
/**
 *
 * Vertical angle of the eye view, in radians.
 *
 */
float viewAngleV__2;
/**
 *
 * Non-zero once the eye view has saved the camera position it restores.
 *
 */
static int      init_camera;
DNG_FLOOR_SAVE *NowFloorInfoPtr;
RUN_SCRIPT_ENV  ActionScriptEnv;
/**
 *
 * Non-zero while the dungeon is held for debugging.
 *
 */
static int DebugPause;
/**
 *
 * Distance of the follow camera from the player.
 *
 */
static float      test_dist;
CUserDataManager *DngUserData;
CSaveData        *DngSaveData;
CSaveDataDungeon *DngSaveDataDungeon;
CScene           *DngMainScene;
DNG_BATTLE_AREA  *BattleAreaScene;

namespace dc2::dungeon {
namespace {
dc2::scene::MapView main_map; /**< Assignment-specific dungeon map binding, without retaining its scene owner. */
}

dc2::scene::MapView MainMap() { return main_map; }

void SetMainMap(dc2::scene::MapView map) { main_map = std::move(map); }
} // namespace dc2::dungeon

CMonsterMan         *ActiveMonster;
ClsMes              *DngMess;
ClsMes              *DngMess2;
ClsMes              *EventMess;
ClsMes              *MonsterMess;
CRedMarkModel       *RedMarkModel;
CCharacter2         *TreasureBoxModel;
CTreasureBoxManager *TreasureBoxMan;
CActionChara        *MainChara__2;
CEffectScriptMan    *FxScriptMan;
CColPrim            *BTsuboCol;
CPullItemManager     PullItemMan;
mgCFrame            *TornadoModel;
/**
 *
 * Index of the next weapon element effect that GetWeaponEffect hands out.
 *
 */
static int wep_effect_cnt;

static void EyeCamera(mgCCamera *camera, CCharacter2 *chara, int mode);
/**
 *
 * Selected line of the debug command menu.
 *
 */
static int debug_cursor;
/**
 *
 * First monster listed by the debug monster loader.
 *
 */
static int debug_mons_no;
/**
 *
 * Selected line of the debug monster loader, or -1 while it is closed.
 *
 */
static int debug_mons_cur;
/**
 *
 * Number of monsters the debug monster loader can list.
 *
 */
static int debug_mons_num;

mgCMemory            BuffPaketList[2];
mgCMemory            BuffPaketData[2];
mgCMemory            BuffStageMain;
mgCMemory            BuffStageChara;
mgCMemory            BuffStageSubData;
mgCMemory            BuffStageSubChara;
mgCMemory            BuffWorkData;
mgCMemory            BuffCharacter;
extern mgCMemory     BaseCharacter[DNG_BASE_CHARACTER_NUM];
mgCMemory            BuffTempData;
mgCMemory            BuffScriptData;
mgCMemory            BuffEffectScriptData;
mgCMemory            BuffEventData[DNG_EVENT_BUFFER_NUM];
mgCMemory            BuffMDTBuild;
mgCMemory            BuffMDTBuild2;
DNG_STATUS           DngStatus;
CMapEffectsManeger   map_effect;
ACCUME_EFFECT        AccumulateEffect;
CDamageScore         DamageScore;
CDamageScore         DamageScoreMons[DNG_DAMAGE_SCORE_MONS_NUM];
CDamageScore2        DamageScore2;
MessageTaskManager   MsgTaskMan;
CStartupEpisodeTitle StartupEpisodeTitle;
BattleEffectMan      BattleFX;
CLevelupInfo         LevelupInfo;
CLockOnModel         LockOnModel;
CWarningGage2        WarningGage2;
CAutoMapGen          AutoMapGen;
CColPrimMan          ColPrimMan;
CRandomCircle        RandomCircle;
CGeoStone            GeoStone;
CCameraControl       MainCamera;
CCameraControl       EventCamera;
CHealingEffectMan    HealingEffectMan;
CMiniEffPrimMan      MiniEffPrimMan;
CCharacter2          ItemBaseData[DNG_ITEM_BASE_NUM];
CAfterWire           afterWire[DNG_AFTER_WIRE_NUM];
CRoboVoiceSystem     VoiceUnit;
CPot                 BTsubo;
CBPot                BTsubo2;
CRocketLauncherMan   RocketLauncher;
CMachineGun          MachineGun;
CLaserGunMan         LaserGun;
CCharacter2          LaserGunModel;
CPullItem            PullItem[DNG_PULL_ITEM_NUM];
/**
 *
 * Loading screen shown while the dungeon is set up.
 *
 */
static NowLoadingInfo nowload;
/**
 *
 * Wave animation of the floor's water texture.
 *
 */
static CWaveTable WaveTable;
mgCFrame         *SparcModel[DNG_SPARC_MODEL_NUM];
/**
 *
 * Glow trail of the player's sword.
 *
 */
static CSwordLuminous SwordLuminous;
/**
 *
 * Weapon element effects that GetWeaponEffect hands out in turn.
 *
 */
CWeaponElement wep_effect[DNG_WEAPON_EFFECT_NUM];
/**
 *
 * Spark effects of weapon hits.
 *
 */
CSparcEffect   Sparc_fx[DNG_ELEMENT_EFFECT_NUM];
CThunder       thunder[DNG_ELEMENT_EFFECT_NUM];
CTornado       tornado[DNG_ELEMENT_EFFECT_NUM];
CChillAfterHit chillAfterHit[DNG_ELEMENT_EFFECT_NUM];
CFireAfterHit  fireAfterHit[DNG_ELEMENT_EFFECT_NUM];

CWeaponElement *GetWeaponEffect() {
    CWeaponElement *effect = &wep_effect[wep_effect_cnt++];

    if (wep_effect_cnt >= DNG_WEAPON_EFFECT_NUM) {
        wep_effect_cnt = 0;
    }

    return effect;
}

void memoryInit() {
    u_long128 *buffer0 = {};
    u_long128 *buffer1 = {};
    int        size = {};

    MainBuffer = GetMainStack();
    ResetDungeonMonsters();
    MainBuffer->stReset();
    buffer0 = MainBuffer->stAlloc64(10000);
    buffer1 = MainBuffer->stAlloc64(10000);
    mgInitVif1Packet(buffer0, buffer1, 160000);
    buffer0 = MainBuffer->stAlloc64(20000);
    buffer1 = MainBuffer->stAlloc64(20000);
    BuffPaketList[0].stSetChildBuffer(*MainBuffer, buffer0, 20000);
    BuffPaketList[1].stSetChildBuffer(*MainBuffer, buffer1, 20000);
    mgSetPacketBuffer(&BuffPaketList[0], &BuffPaketList[1]);
    buffer0 = MainBuffer->stAlloc64(60000);
    buffer1 = MainBuffer->stAlloc64(60000);
    BuffPaketData[0].stSetChildBuffer(*MainBuffer, buffer0, 60000);
    BuffPaketData[1].stSetChildBuffer(*MainBuffer, buffer1, 60000);
    mgSetDataBuffer(&BuffPaketData[0], &BuffPaketData[1], 1);
    BuffWorkData.stSetChildBuffer(*MainBuffer, MainBuffer->stAlloc64(10000 * static_cast<int>(sizeof(mgSORT_PACKET)) / 16), 10000 * static_cast<int>(sizeof(mgSORT_PACKET)) / 16);

    dc2::text::Copy(BuffWorkData.name, dc2::text::View("Work Buffer"));

    BuffWorkData.stReset();
    mgTexManager.SetTableBuffer(0x140, 0xAF, MainBuffer);
    mgTexManager.Initialize(GetVramTopAddress(), -1);
    size = GetCharaMemAllocSize();
    BuffCharacter.stSetChildBuffer(*MainBuffer, MainBuffer->stAlloc64(size), size);

    dc2::text::Copy(BuffCharacter.name, dc2::text::View("Chara Buffer"));

    BuffCharacter.stReset();
    BuffScriptData.stSetChildBuffer(*MainBuffer, MainBuffer->stAlloc64(20000), 20000);

    dc2::text::Copy(BuffScriptData.name, dc2::text::View("Script Buffer"));

    BuffScriptData.stReset();
    BuffEffectScriptData.SetHeapMem(MainBuffer->stAlloc64(40000), 40000);

    dc2::text::Copy(BuffEffectScriptData.name, dc2::text::View("EScriptW Buffer"));

    BuffReadData = MainBuffer->stAlloc64(260000);
}

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline unsigned int DngAlign16Size(unsigned int size) {
    if (size & 15) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

void InitDungeonMain(INIT_LOOP_ARG arg) {
    SetCurrentDir(nullptr);
    memoryInit();
    nowload.tex_block = 0x51;
    nowload.unk_4 = 1;
    nowload.step_count = 10;
    arg.mc_load = 0;
    nowload.memory.stSetChildBuffer(*MainBuffer, BuffReadData + 0x2E630, 10000);
    CreateNowLoading(&nowload);
    DngSaveData = GetSaveData();

    if (DngSaveData != nullptr) {
        DngUserData = &DngSaveData->user_data;
    }

    NowFloorInfoPtr = nullptr;
    DngSaveDataDungeon = &DngSaveData->save_dungeon;
    SetEnvUserDataMan(1);
    DngMainScene = GetMainScene();
    BattleAreaScene = &DngMainScene->battle_area;
    DngSaveDataDungeon->stage_id = arg.map_no;

    if (arg.floor_no >= 0) {
        DngSaveDataDungeon->SetFloorID(arg.floor_no);
    }

    CameraCtrlParam *param = MainCamera.GetActiveParam();

    if (param != nullptr) {
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
    DngMainScene->read_buffer_storage = dc2::memory::ArenaBuffer::Bind(*MainBuffer, dc2::dungeon::ReadStorage());
    DNG_BATTLE_AREA *area = BattleAreaScene;

    dc2::dungeon::SetMainMap({});
    area->battle_clear = true;
    area->battle_bgm_state = DNG_BGM_MAP;
    area->battle_bgm_vol = 0.0f;
    area->camera_mode = DNG_CAMERA_FOLLOW;
    area->pause_flag = 0;
    area->timer = 0;
    area->minimap_reveal = 0;
    area->quake_count = 0;
    area->script.running = false;
    area->subject_counter = 0;
    area->practice_actions = 0;
    area->floor_status = 0;
    area->weather = DNG_WEATHER_NORMAL;
    area->lock_on_mode = DNG_LOCK_ON_NEAREST;
    BattleAreaScene->map_name[0] = '\0';

    for (int i = 0; i < DNG_CHARA_PARTY_NUM; i++) {
        CActionChara *chara = RequireDungeonAllocation(dc2::memory::NewObject<CActionChara>(*MainBuffer));

        DngMainScene->AssignChara(i, dc2::scene::CharacterResource::FromArena(*MainBuffer, *chara));
        DngMainScene->SetType(SCENE_DATA_CHARA, i, SCENE_CHARA_TYPE_PLAYER);
    }

    MainChara__2 = static_cast<CActionChara *>(DngMainScene->GetCharacter(0));
    DngMainScene->SetActive(SCENE_DATA_CHARA, 0);
    DngMainScene->player_chara = 0;

    for (int i = 0; i < DNG_CHARA_EVENT_NUM; i++) {
        CCharacter2 *chara = RequireDungeonAllocation(dc2::memory::NewObject<CCharacter2>(*MainBuffer));

        chara->Initialize();
        DngMainScene->AssignChara(i + DNG_CHARA_SLOT_EVENT, dc2::scene::CharacterResource::FromArena(*MainBuffer, *chara));
        DngMainScene->ResetActive(SCENE_DATA_CHARA, i + DNG_CHARA_SLOT_EVENT);
        DngMainScene->SetType(SCENE_DATA_CHARA, i + DNG_CHARA_SLOT_EVENT, SCENE_CHARA_TYPE_EVENT);
    }

    CActiveMonster *mons = RequireDungeonAllocation(dc2::memory::NewArray<CActiveMonster>(*MainBuffer, MONSTER_ACTIVE_MAX));

    for (int i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        mons[i].Initialize();
        DngMainScene->AssignChara(i + DNG_CHARA_SLOT_MONSTER, dc2::scene::CharacterResource::FromArena(*MainBuffer, mons[i]));
        DngMainScene->SetType(SCENE_DATA_CHARA, i + DNG_CHARA_SLOT_MONSTER, SCENE_CHARA_TYPE_MONSTER);
    }

    BattleAreaScene->floor_manager.LoadDataTable(arg.map_no, MainBuffer);
    MainBuffer->Align64();
    MenuArg.pack = reinterpret_cast<u32 *>(&MainBuffer->stack[MainBuffer->stack_used]);
    LoadFile(GetMenuCfgFileName(0, 0), dc2::memory::AvailableFrom(*MainBuffer, MenuArg.pack), &MenuArg.pack_size);
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
    DngStatus.debug_window = false;
    DngStatus.eye_view = false;
    mgSetAllScissorFlag(0);
    mgInitLighting();
    test_dist = 160.0f;
    debag_param = true;
    init_camera = false;
    MainCamera.SetPos(0.0f, 0.0f, 0.0f);
    MainCamera.SetDistance(test_dist);
    MainCamera.SetFollowOffset(0.0f, 30.0f, 0.0f);
    MainCamera.SetHeight(5.0f);
    MainCamera.SetAngle(PI);
    MainCamera.SetSpeed(6.0f, -1.0f);
    MainCamera.Step(10);
    MainCamera.ControlOn();
    MainCamera.SetRotCameraCancel(CAMERA_ROT_CANCEL_BUTTON);
    EventCamera = MainCamera;
    EdEventLoopInit();
    InitTakePhoto();
    DngMainScene->LoadSeBase(0, dc2::dungeon::ReadStorage());
    int sound = arg.map_no * 1000 + 1601;

    if (arg.map_no >= 5) {
        sound += 1000;
    }

    DngMainScene->LoadSound(sound, dc2::dungeon::ReadStorage());
    NowLoadingBarStep();
    int bgm = {};
    int skip = DngMainScene->skip_load_bgm;

    bgm = DngMainScene->GetDefBgmNo(sound);

    if (bgm < 0) {
        DngMainScene->StopBGM(0);
    }

    if (DngMainScene->LoadBGM(bgm, dc2::dungeon::ReadStorage())) {
        DngMainScene->PlayBGM(0, -1, 1.0f);
    }

    if (skip) {
        DngMainScene->skip_load_bgm = 1;
    }

    NowLoadingBarStep();
    DngMess = RequireDungeonAllocation(dc2::memory::NewObject<ClsMes>(*MainBuffer));
    DngMess->Preset(4);
    DngMess->SetWindowMode(7);
    DngMess->push_button = 0;
    DngMess->draw_speed_def = 0;
    DngMess->draw_speed = 0;
    DngMess->texture_block = 0x58;

    if (LanguageCode > LANG_JAPANESE && LanguageCode < LANG_CHINESE) {
        DngMess->value_half = 1;
    }

    MsgTaskMan.Initialize();
    MsgTaskMan.mes = DngMess;
    DngMess2 = RequireDungeonAllocation(dc2::memory::NewObject<ClsMes>(*MainBuffer));
    DngMess2->Preset(4);
    DngMess2->SetWindowMode(0);
    DngMess2->font_w = 16;
    DngMess2->push_button = 0;
    DngMess2->draw_speed_def = 0;
    DngMess2->texture_block = 0x58;
    StartupEpisodeTitle.Initialize();
    StartupEpisodeTitle.mes = DngMess2;
    EventMess = RequireDungeonAllocation(dc2::memory::NewObject<ClsMes>(*MainBuffer));
    EventMess->Preset(0);
    EventMess->SetBuff_system(GetSystemMesBuffer());
    EventMess->texture_block = 0x58;
    MainBuffer->Align64();
    char path[64];
    int  size = {};
    s16 *mes_buff = reinterpret_cast<s16 *>(&MainBuffer->stack[MainBuffer->stack_used]);

    std::snprintf(path, sizeof(path), "dungeon/msg/d01_%d.mes", LanguageCode);
    LoadFile(path, dc2::memory::AvailableFrom(*MainBuffer, mes_buff), &size);
    EventMess->SetBuff(size > 0 ? dc2::text::MessageTable::Parse(
                                      {reinterpret_cast<const std::byte *>(mes_buff), static_cast<std::size_t>(size)})
                                : dc2::text::MessageTable{});
    MainBuffer->stAlloc64((size / 64 + 1) * 64 / 16);
    DngMainScene->AssignMessage(0, EventMess, nullptr);
    GetSystemMessage()->texture_block = 0x58;
    DngMainScene->AssignMessage(1, GetSystemMessage(), nullptr);
    MonsterMess = RequireDungeonAllocation(dc2::memory::NewObject<ClsMes>(*MainBuffer));
    MonsterMess->Preset(2);
    MonsterMess->texture_block = 0x58;
    NowLoadingBarStep();
    mgCTextureManager *tex_man = &mgTexManager;

    MainTextureInterface(MainBuffer, DngMainScene);
    NowLoadingBarStep();
    if (!PortLoadDungeonArticleModels()) {
        std::exit(1);
        return;
    }

    ActionScriptEnv.item_chara = ItemBaseData;
    ActionScriptEnv.texb = 0x68;
    TreasureBoxModel = RequireDungeonAllocation(dc2::memory::NewObject<CCharacter2>(*MainBuffer));
    TreasureBoxMan = RequireDungeonAllocation(dc2::memory::NewObject<CTreasureBoxManager>(*MainBuffer));
    TreasureBoxModel->Initialize();
    TreasureBoxMan->Initialize();
    char tbox_path[64];

    std::snprintf(tbox_path, sizeof(tbox_path), "map/d/d0%d/f01/tbox0.gltf", DngStatus.dungeon_no + 1);
    LoadFile(tbox_path, dc2::dungeon::ReadStorage(), nullptr);
    TreasureBoxModel->LoadPack(reinterpret_cast<u32 *>(BuffReadData), "info", MainBuffer, MainBuffer, MainBuffer, 0x57, nullptr);
    TreasureBoxMan->SetLargeModel(TreasureBoxModel, 0x57);
    TreasureBoxMan->SetCollisionModel(reinterpret_cast<unsigned int *>(BuffReadData), MainBuffer);
    BattleAreaScene->treasure_box = TreasureBoxMan;
    NowLoadingBarStep();
    LoadFile("textures/img/allitem.json", dc2::dungeon::ReadStorage(), nullptr);
    tex_man->EnterIMGFile(reinterpret_cast<u8 *>(BuffReadData), 0x50, nullptr, nullptr);
    mgCTexture *icon[2];

    icon[0] = tex_man->GetTexture("icon_dmy1", -1);
    icon[1] = tex_man->GetTexture("icon_dmy2", -1);
    CopyActiveIconTexture(icon, DngUserData->active_chr_no, nullptr);
    tex_man->DeleteBlock(0x50);
    NowLoadingBarStep();
    SetupMainUnit(std::span<u8>(reinterpret_cast<u8 *>(BuffReadData),
                                static_cast<std::size_t>(260000) * sizeof(u_long128)),
                  &BuffCharacter, BaseCharacter, 16, DngMainScene, DngUserData,
                  DngUserData->active_chr_no, 0);
    GetBattleCharaInfo();
    DngMainScene->SetCharaTexb(0, 16);
    NowLoadingBarStep();
    LoadFile("dungeon/articles/eff01.gltf", dc2::dungeon::ReadStorage(), &size);
    u32 *eff_pack = reinterpret_cast<u32 *>(BuffReadData);

    FxScriptMan = RequireDungeonAllocation(dc2::memory::NewObject<CEffectScriptMan>(*MainBuffer));
    FxScriptMan->Initialize(MainBuffer, 0x8C, 32);
    FxScriptMan->load_buffer = BuffReadData + size / 16 + 1;
    FxScriptMan->SetWorkBuffer(&BuffEffectScriptData);
    FxScriptMan->level = 0;
    FxScriptMan->BuildPack("\x8d\xbb\x89\x8c", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x91\xab\x8d\xbb\x89\x8c", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x91\xab\x94g\x96\xe4", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x91\xab\x90\x85\x83p\x83V\x83\x83", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x91\xab\x8e\xc5\x90\xb6", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x92\xca\x8f\xed\x89\xf1\x95\x9c", eff_pack, nullptr, -1);
    FxScriptMan->level = 1;
    FxScriptMan->BuildPack("\x83K\x81[\x83h\x83G\x83t\x83"
                           "F\x83N\x83g\x82`",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x8f"
                           "e\x92"
                           "e",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x94\x9a\x94\xad", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83}\x83Y\x83\x8b\x83t\x83\x89\x83"
                           "b\x83V\x83\x85",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x86\x83\x8a\x83X\x97\xad\x82\xdf\x8dU\x8c\x82", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x97\xad\x82\xdf\x8dU\x8c\x82", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x97\xad\x82\xdf", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95\x97", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95\x97\x83q\x83"
                           "b\x83g",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x97\x8b", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x97\x8b\x83q\x83"
                           "b\x83g",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95X", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95X\x83q\x83"
                           "b\x83g",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x8f\x83"
                           "C\x83\x93\x92M\x92"
                           "e",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x89\x8a", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x97\xe2", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x97\x8b", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x95\x97", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x96\x82\x90\xce\x90\xb9", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x82x\x83r\x81[\x83\x80\x82g", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x82x\x83O\x83\x8c\x82g", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x93"
                           "d\x8c\xf5\x90\xce\x89\xce",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x82"
                           "e\x83{\x83\x80\x82g",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x8e\xe8\x93\x8a\x82\xb0\x94\x9a\x92"
                           "e",
                           eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x89\xce", eff_pack, nullptr, -1);
    FxScriptMan->BuildPack("\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x89\xce\x83q\x83"
                           "b\x83g",
                           eff_pack, nullptr, -1);
    DngMainScene->AssignEffect(0, FxScriptMan, nullptr);
    FxScriptMan->load_buffer = BuffReadData;
    CCharacter2 *rocket = FxScriptMan->GetBaseChara("\x83\x8f\x83"
                                                    "C\x83\x93\x92M\x92"
                                                    "e");

    RocketLauncher.Initialize(rocket->GetFrame(), rocket->texture_block, mgTexManager.GetTexture("Shell_kemuri", -1));
    LaserGunModel.Initialize();
    LoadFile2("dungeon/eff_script/rp_beam_s.gltf", dc2::dungeon::ReadStorage(), nullptr, 0);
    LaserGunModel.LoadPackNoLine(reinterpret_cast<u32 *>(BuffReadData), "info", MainBuffer, MainBuffer, MainBuffer, 0x4A, nullptr);
    LaserGun.Initialize(LaserGunModel.GetFrame(), 0x4A, mgTexManager.GetTexture("potbeam", -1));
    BattleAreaScene->free_texb = FxScriptMan->GetNotUsedTexb();
    auto &monster_owner = DungeonMonsterOwner();
    monster_owner = std::make_unique<CMonsterMan>();
    ActiveMonster = monster_owner.get();
    ActiveMonster->Initialize(DngMainScene);
    CommonClassInit();
    AutoMapGen.SetGridStorage({});
    AutoMapGen.gio_parts = nullptr;

    for (int i = 0; i < AUTOMAP_RANDOM_STONE_MAX; i++) {
        AutoMapGen.random_stone[i] = nullptr;
    }

    AutoMapGen.pot_parts = nullptr;

    for (int i = 0; i < AUTOMAP_ROOM_MAX; i++) {
        AutoMapGen.room[i].no_door = 0;
    }

    AutoMapGen.ClearRoomInfo();
    AutoMapGen.place_parts_num = 0;
    AutoMapGen.gen_flag = 0;
    AutoMapGen.navi_valid = 0;
    AutoMapGen.navi_enable = 0;
    AutoMapGen.cell_d = 320.0f;
    AutoMapGen.cell_w = 320.0f;
    auto *grid = RequireDungeonAllocation(dc2::memory::NewArray<CAutoMapParts>(*MainBuffer, 900));
    AutoMapGen.SetGridStorage(dc2::memory::ArenaBuffer::Bind(*MainBuffer,
                                                             std::span(reinterpret_cast<u8 *>(grid), 900 * sizeof(CAutoMapParts))));
    for (int i = 0; i < 900; i++) {
        grid[i].Initialize();
    }

    AutoMapGen.grid_w = 30;
    AutoMapGen.grid_h = 30;
    MainChara__2->sound_info.foot_se_bank = DngMainScene->se_base_id;
    MainChara__2->sound_info.foot_sound_id = -1;
    sndInitPort(SND_PORT_CHARA);
    std::string snd_path = dc2::character::SoundAssetPath(DngUserData, DngUserData->active_chr_no);
    if (!snd_path.empty() &&
        LoadFile2(snd_path.data(), std::span<u8>(reinterpret_cast<u8 *>(BuffReadData), static_cast<std::size_t>(260000) * sizeof(u_long128)),
                  nullptr, 0)) {
        int base = 3;

        if (DngUserData->active_chr_no == USER_CHARA_ROBO) {
            base = 1;
        }

        if (DngUserData->active_chr_no == USER_CHARA_MONSTER) {
            base = 0;
        }

        MainChara__2->sound_info.se_bank = sndLoadSound(SND_PORT_CHARA, reinterpret_cast<u32 *>(BuffReadData), &BaseCharacter[base]);
    }

    MainChara__2->sound_info.se_bank_2 = DngMainScene->se_battle_id;
    MainChara__2->effect_man = FxScriptMan;
    NowLoadingBarStep();
    BuffStageMain.stSetBorrowedBuffer(*MainBuffer, std::span(MainBuffer->stGetTop(), static_cast<std::size_t>(MainBuffer->stGetRest())));
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
    BTsuboCol = nullptr;
    DngMainScene->time_step = 1;

    for (int e = 0; e < DNG_ELEMENT_EFFECT_NUM; e++) {
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

    DebugPause = false;
    InitPauseMenu(0x6C);
    VoiceUnit.status = ROBO_VOICE_OFF;
    VoiceUnit.pause_time = 2;
    VoiceUnit.play_time = 0;
    VoiceUnit.stream_open = false;
    EdEventInfo.script_name[0] = '\0';
    EntryEventScript(DngStatus.dungeon_no);
    static mgCMemory debug_event_stack;

    debug_event_stack.stSetChildBuffer(*MainBuffer, BuffReadData, 200000);
    InitEventEdit(0x7D, &debug_event_stack);
    SYSTEM_SCRIPT_INFO *script = &BattleAreaScene->script;

    script->event_no = arg.event_no;

    if (arg.event_no <= 0) {
        script->event_no = DNG_EVENT_FLOOR_START;
    }

    EventScriptSetup(script);
    BattleAreaScene->SetStatusBarNow(1);
    NowLoadingBarSteEnd();
    DeleteNowLoading();
}

void CRedMarkModel::Initialize() {
    draw_request = false;
    angle = 0.0f;
    frame = nullptr;
}

void CommonStageClassInit() {
    int i = {};

    HealingEffectMan.Initialize();
    MiniEffPrimMan.Initialize();
    ColPrimMan.Initialize(DngMainScene);
    LevelupInfo.phase = 0;
    SwordLuminous.root_frame = nullptr;
    SwordLuminous.tip_frame = nullptr;
    SwordLuminous.mode = SWORD_LUMINOUS_OFF;
    map_effect.spawn_wait = 0;
    map_effect.live_num = 0;
    map_effect.sprite_num = 0;
    map_effect.sprite = nullptr;
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

    for (i = 0; i < DNG_DAMAGE_SCORE_MONS_NUM; i++) {
        DamageScoreMons[i].active = 0;
        DamageScoreMons[i].unk_00 = 0;
        DamageScoreMons[i].unk_54 = 0;
        DamageScoreMons[i].unk_58 = 0;
        DamageScoreMons[i].digit_w = 12;
        DamageScoreMons[i].digit_h = 17;
        DamageScoreMons[i].digit_u = 0;
        DamageScoreMons[i].digit_v = 202;
    }

    AccumulateEffect.frame = nullptr;
    AccumulateEffect.unk_320 = 0;
    AccumulateEffect.mode = 0;
    WarningGage2.warning[0] = false;
    WarningGage2.warning[1] = false;
    WarningGage2.warning[2] = false;
    WarningGage2.time = 0;

    for (i = 0; i < DNG_PULL_ITEM_NUM; i++) {
        PullItem[i].Initialize();
    }

    PullItemMan.list = nullptr;
    PullItemMan.num = 0;
    PullItemMan.list = PullItem;
    PullItemMan.num = DNG_PULL_ITEM_NUM;

    for (int w = 0; w < DNG_AFTER_WIRE_NUM; w++) {
        afterWire[w].mode = false;
    }

    for (int b = 0; b < MACHINE_GUN_BULLET_NUM; b++) {
        MachineGun.active[b] = 0;
        MachineGun.col_prim_id[b] = -1;
    }

    MachineGun.index = 0;

    for (int e = 0; e < DNG_WEAPON_EFFECT_NUM; e++) {
        wep_effect[e].Initialize();
    }

    wep_effect_cnt = 0;
}

void CommonClassInit() {
    CommonStageClassInit();
    BattleFX.hit_prim = nullptr;
    BattleFX.hit = nullptr;
    BattleFX.hit_num = 0;
    BattleFX.hit_next = 0;
    BattleFX.flush = nullptr;
    BattleFX.flush_num = 0;
    BattleFX.flush_next = 0;
    BattleFX.power_prim = nullptr;
    BattleFX.power = nullptr;
    BattleFX.power_num = 0;
    BattleFX.power_next = 0;
    BattleFX.dead_prim = nullptr;
    BattleFX.dead = nullptr;
    BattleFX.dead_num = 0;
    BattleFX.dead_next = 0;
    BattleFX.chara_slot = nullptr;
    BattleFX.chara_num = 0;
    BattleFX.AllocEffect(BATTLE_EFFECT_HIT, MainBuffer, 4);
    BattleFX.AllocEffect(BATTLE_EFFECT_FLUSH, MainBuffer, 4);
    BattleFX.AllocEffect(BATTLE_EFFECT_POWER_LINE, MainBuffer, 8);
    BattleFX.AllocEffect(BATTLE_EFFECT_DEAD, MainBuffer, 4);
    BattleAreaScene->battle_effect = &BattleFX;
    InitPause(0x69);
}

void EntryEventScript(int no) {
    std::string path;
    int         size = {};

    BindReadBuffer(std::span<u8>(reinterpret_cast<u8 *>(BuffReadData),
                                 static_cast<std::size_t>(260000) * sizeof(u_long128)),
                   *MainBuffer);

    if (OmakeFlag) {
        const std::string map = "d0" + std::to_string(static_cast<std::int64_t>(no) + 1);
        path = "map/d/" + map + "/" + map + "_sfida_" + std::to_string(LanguageCode) + ".stb";
    } else if (EdEventInfo.script_name[0] == 0) {
        const auto        map_no = static_cast<std::int64_t>(no) + 1;
        const std::string map = std::string(map_no < 10 ? "d0" : "d") + std::to_string(map_no);
        path = "map/d/" + map + "/" + map + "_" + std::to_string(LanguageCode) + ".stb";
    } else {
        const auto script_name = dc2::text::View(EdEventInfo.script_name);
        const auto separator = script_name.find('/');
        if (separator == std::string_view::npos || separator == 0) {
            return;
        }
        path = dc2::world::MapPath(script_name.substr(0, separator)) + ".stb";
    }

    dc2::log::PrintGame("SCRIPT FILE %s\n", path.c_str());
    BuffScriptData.stClearUsed();
    BuffScriptData.stSetLocked(false);
    BuffScriptData.Align64();
    u_long128 *script = BuffScriptData.stack + BuffScriptData.stack_used;

    if (LoadFile2(path.data(), dc2::memory::RemainingBytes(BuffScriptData), &size, 0) && size > 0) {
        BuffScriptData.Alloc((size & 0xF) ? static_cast<u_int>(size) / 16 + 1 : static_cast<u_int>(size) / 16);
        SetEventScript(std::span<u8>(reinterpret_cast<u8 *>(script), static_cast<std::size_t>(size)), &BuffScriptData);
    }
}

void FinishDungeonMain() {
    AutoMapGen.ClearRoomInfo();
    AutoMapGen.SetGridStorage({});
    AutoMapGen.mini_map.SetMapInfo({}, {}, 0, 0, 0.0f, 0.0f);
    ResetDungeonMonsters();
}

int LoopDungeonMain() {
    int key{};
    int mode = {};

    auto *main_map_slot = DngMainScene->GetSceneMap(DngMainScene->active_map);
    dc2::dungeon::SetMainMap(main_map_slot != nullptr ? main_map_slot->GetMapView() : dc2::scene::MapView{});
    CMapLightingInfo light;

    if (auto *floor_map = dc2::dungeon::MainMap().Get(); floor_map != nullptr) {
        floor_map->GetLightInfo(&light);
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

                stack.stSetChildBuffer(*MainBuffer, BuffReadData, 260000);
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

                if (MenuArg.end_code == MENU_END_CHARA_CHANGE) {
                    MenuArg.active_chara_no = MenuArg.result[0];
                }

                if (MenuArg.end_code == MENU_END_CHARA_CHANGE_FADE) {
                    MenuArg.active_chara_no = MenuArg.result[0];
                }

                if (MenuArg.end_code == MENU_END_DNG_MOVE && MenuArg.result[2] == 0) {
                    INIT_LOOP_ARG arg;
                    char         *map[7] = {"d01e01", "s02", "g02", "g03", "g04", "d06e01", "m05"};
                    arg.map_no = SearchMapNo(map[DngStatus.dungeon_no]);
                    arg.event_no = 100;
                    NextLoop(LOOP_EDIT, arg);
                    DngStatus.mode = DNG_STATUS_EXIT;
                }

                if (MenuArg.end_code != MENU_END_FISHING && SubGameRunning() && GetSubGameNo() == SUBGAME_FISHING) {
                    sgExitSubGame();
                }

                if (MenuArg.end_code == MENU_END_FISHING) {
                    SubGameInfo info;

                    DngMainScene->tex_block_base = 40;
                    DngMainScene->tex_block_count = 31;
                    info.scene = DngMainScene;
                    info.rod_no = MenuArg.result[0];
                    info.esa_no = MenuArg.result[1];
                    info.dungeon = true;
                    MenuArg.end_code = MENU_END_NONE;
                    SubGameInfo *now = GetNowSubGameInfo();

                    if ((GetMenuEtcFlag() & MENU_ETC_FLAG_CHARA_RELOAD) || !SubGameRunning() || now->rod_no != info.rod_no) {
                        sgInitSubGame(SUBGAME_FISHING, &info);
                    } else {
                        sgRestartSubGame(&info);
                    }

                    MainChara__2->SearchChara("shot")->Show(0, 0);
                }

                ResetEyeView(MainChara__2);
            }

            break;
    }

    PAUSE_INFO pause{};
    pause.scene = nullptr;
    pause.scene = DngMainScene;
    pause.event_skip = false;

    if (!OmakeFlag) {
        if (DngStatus.mode == DNG_STATUS_EVENT && CheckEventSkip()) {
            pause.event_skip = true;
        }

        if (PadCtrl.Btn(PAD_BTN_PAUSE) || !GamePad__2.Connect()) {
            PauseStart(&pause);
        }
    }

    if (DebugFlag && !(BattleAreaScene->pause_flag & DNG_PAUSE_PAD_RESET) && GamePad__2.On(PAD_START) && GamePad__2.On(PAD_SELECT)) {
        DngStatus.mode = DNG_STATUS_EXIT;
    }

    if (DngMainScene->exit_flag) {
        DngMainScene->exit_flag = false;
        DngStatus.mode = DNG_STATUS_EXIT;
    }

    if (DngStatus.mode == DNG_STATUS_EXIT) {
        sgBreakSubGame();
        CheckItemDngKey();

        if (!(BattleAreaScene->pause_flag & DNG_PAUSE_EXIT_HEAL)) {
            PlayerPartyCure();
        }

        BattleAreaScene->floor_status &= ~DNG_FLOOR_SEAL_MASK;
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
        return true;
    }

    return false;
}

void DngMainDraw() {
    mgCTextureManager *tex_man = &mgTexManager;
    SV_CONFIG_OPTION  *config = {};
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

    auto *main_map_slot = DngMainScene->GetSceneMap(DngMainScene->active_map);
    dc2::dungeon::SetMainMap(main_map_slot != nullptr ? main_map_slot->GetMapView() : dc2::scene::MapView{});
    CMapLightingInfo  light;
    CMapLightingInfo *info = &light;

    if (auto *floor_map = dc2::dungeon::MainMap().Get(); floor_map != nullptr) {
        floor_map->map_info.time_light_blend = 1;
        floor_map->now_time = DngMainScene->time;
        floor_map->GetLightInfo(info);

        if (info != nullptr) {
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

        if (info != nullptr) {
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

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_SKY_DRAW)) {
        DngMainScene->DrawSky(0);
    }

    if (auto *floor_map = dc2::dungeon::MainMap().Get(); floor_map != nullptr && !(BattleAreaScene->pause_flag & DNG_PAUSE_MAP_DRAW)) {
        S51Thunder(DngMainScene);
        BuffWorkData.stReset();
        int list[68];
        int i = {};

        for (i = 0; i < 15; i++) {
            list[i] = i;
        }

        list[15] = -1;
        mgBeginDraw(&BuffWorkData, list, nullptr);
        MainChara__2->GetPosition(view);
        floor_map->PreDraw(view);
        floor_map->Draw();
        mgCTexture *water = tex_man->GetTexture("water", -1);
        int         water_block = -1;

        if (water != nullptr) {
            water_block = water->block;
            WaveTable.GetEffect();
        }

        mgPreEndDraw(nullptr);
        int g = {};
        int b = {};
        int block = {};
        int num = {};
        int idx = {};

        for (g = 0; g < 6; g++) {
            int blocks[128];

            num = DngMainScene->GetTextureBlockNo(g, blocks, 128);

            for (b = 0; b < num; b++) {
                idx = num - b - 1;
                block = blocks[idx];

                if (mgEndDrawReloadTexture(block, nullptr) && water_block == blocks[idx]) {
                    WaveTable.CreateTexture(water);
                }

                mgEndDraw(block, nullptr);
            }
        }

        mgSetPkTextureRepeat(0);
    }

    EdEventFirstDraw();
    tex_man->ReloadTexture(100, (sceVif1Packet *) nullptr);
    mgBeginDrawShadow(TEX_ShadowTexture, nullptr);
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

        MainChara__2->GetEntryObjectPos(CHARA_ENTRY_GROUP_SHADOW, 0, pos);
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

        for (int c = 0; c < DNG_CHARA_EVENT_NUM; c++) {
            if (DngMainScene->CheckDrawCharaShadow(c + DNG_CHARA_SLOT_EVENT)) {
                CCharacter2 *chara = DngMainScene->GetCharacter(c + DNG_CHARA_SLOT_EVENT);

                if (chara != nullptr) {
                    chara->GetEntryObjectPos(CHARA_ENTRY_GROUP_SHADOW, 0, pos);
                    pos[1] -= 20.0f;
                    mgSetDropShadowMatrix(dir, pos, normal);
                    chara->ShadowStep();
                    chara->DrawShadowDirect();
                }
            }
        }
    }

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_MONSTER_DRAW)) {
        ActiveMonster->DrawShadowActMonster();
    }

    TreasureBoxMan->DrawShadow(cam_pos);
    mgEndDrawShadow(TEX_ShadowTexture, nullptr);
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
        tex_man->ReloadTexture(TreasureBoxMan->tex_block, (sceVif1Packet *) nullptr);
        camera->GetPos(cam_pos);
        TreasureBoxMan->Draw(cam_pos);

        if (!(BattleAreaScene->pause_flag & DNG_PAUSE_MONSTER_DRAW)) {
            ActiveMonster->DrawActMonster();
        }

        if (DngMainScene->CheckDrawChara(0)) {
            if (auto *floor_map = dc2::dungeon::MainMap().Get(); floor_map != nullptr) {
                int        num = 0;
                CFuncPoint points[2];

                for (int m = 0; m < 1; m++) {
                    num += floor_map->GetCharaLight(MainChara__2, &points[num], 2 - num, 1);

                    if (num >= 3) {
                        break;
                    }
                }
            }

            tex_man->ReloadTexture(16, (sceVif1Packet *) nullptr);
            MainChara__2->DrawDirect();
        }

        for (int c = 0; c < DNG_CHARA_EVENT_NUM; c++) {
            if (DngMainScene->CheckDrawChara(c + DNG_CHARA_SLOT_EVENT) && DngMainScene->GetType(SCENE_DATA_CHARA, c + DNG_CHARA_SLOT_EVENT) != SCENE_CHARA_TYPE_EFFECT) {
                CCharacter2 *chara = DngMainScene->GetCharacter(c + DNG_CHARA_SLOT_EVENT);

                if (chara != nullptr) {
                    tex_man->ReloadTexture(DngMainScene->GetCharaTexb(c + DNG_CHARA_SLOT_EVENT), (sceVif1Packet *) nullptr);
                    chara->DrawDirect();
                }
            }
        }

        mgActiveLighting(old, 0);
    }

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_MAP_DRAW)) {
        mgTexManager.ReloadTexture(100, (sceVif1Packet *) nullptr);
        mgCTexture *work = TEX_ShadowTexture;

        if (!config->dof_off) {
            float dof[] = {1800.0f};

            DepthOfField(1, dof, work, 1.0f);
        } else {
            float dof[] = {1000.0f, 2000.0f};

            DepthOfField(2, dof, work, 1.0f);
        }
    }

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_SKY_DRAW)) {
        tex_man->ReloadTexture(100, (sceVif1Packet *) nullptr);
        DngMainScene->DrawLensFlare(100, "work", "work2");
    }

    mgSetPkTextureRepeat(0);
    tex_man->ReloadTexture(0xAD, (sceVif1Packet *) nullptr);
    sceVu0FVECTOR chara_pos;

    MainChara__2->GetPosition(chara_pos);
    RandomCircle.Draw(chara_pos);
    tex_man->ReloadTexture(0xAD, (sceVif1Packet *) nullptr);
    GeoStone.GeoDraw(chara_pos);
    tex_man->ReloadTexture(0x6A, (sceVif1Packet *) nullptr);

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_PICKUPS)) {
        mgCTexture *tex = tex_man->GetTexture("keyetc", 0x6A);

        for (int p = 0; p < DNG_PULL_ITEM_NUM; p++) {
            PullItem[p].Draw(tex);
        }
    }

    sceVu0FVECTOR work[256];

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_PICKUPS)) {
        for (int w = 0; w < DNG_AFTER_WIRE_NUM; w++) {
            afterWire[w].StepWire();
            afterWire[w].DrawWire(work);
        }
    }

    ActiveMonster->DrawInvisibleMonster();

    if (auto *floor_map = dc2::dungeon::MainMap().Get(); floor_map != nullptr && !(BattleAreaScene->pause_flag & DNG_PAUSE_MAP_DRAW)) {
        int g = {};
        int b = {};
        int block = {};
        int num = {};

        for (g = 6; g < 16; g++) {
            int blocks[128];

            num = DngMainScene->GetTextureBlockNo(g, blocks, 128);

            for (b = 0; b < num; b++) {
                block = blocks[b];
                mgEndDrawReloadTexture(block, nullptr);
                mgEndDraw(block, nullptr);
            }
        }

        mgSetPkTextureRepeat(0);
        mgCTexture *work_tex = tex_man->GetTexture("water_work", 0x59);
        mgCTexture *ref_tex = tex_man->GetTexture("ref", 0x59);

        floor_map->DrawWater(DngMainScene->GetCamera(DngMainScene->active_camera), work_tex, ref_tex);
    }

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_MAP_DRAW)) {
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

        for (int c = 0; c < DNG_CHARA_EVENT_NUM; c++) {
            if (DngMainScene->CheckDrawChara(c + DNG_CHARA_SLOT_EVENT) && DngMainScene->GetType(SCENE_DATA_CHARA, c + DNG_CHARA_SLOT_EVENT) == SCENE_CHARA_TYPE_EFFECT) {
                CCharacter2 *chara = DngMainScene->GetCharacter(c + DNG_CHARA_SLOT_EVENT);

                if (chara != nullptr) {
                    tex_man->ReloadTexture(DngMainScene->GetCharaTexb(c + DNG_CHARA_SLOT_EVENT), (sceVif1Packet *) nullptr);
                    chara->DrawDirect();
                }
            }
        }

        mgActiveLighting(old, 0);
    }
    tex_man->ReloadTexture(0x49, (sceVif1Packet *) nullptr);
    map_effect.Draw(&MainCamera);
    HealingEffectMan.Draw(&MainCamera);
    BattleFX.Draw();

    for (int e = 0; e < DNG_WEAPON_EFFECT_NUM; e++) {
        wep_effect[e].Step();
        wep_effect[e].Draw();
    }

    ActiveMonster->DrawPiyori();
    MiniEffPrimMan.Draw();
    SwordLuminous.Draw();
    RocketLauncher.Draw();
    LaserGun.Draw();
    tex_man->ReloadTexture(0x6B, (sceVif1Packet *) nullptr);

    for (int e = 0; e < DNG_ELEMENT_EFFECT_NUM; e++) {
        Sparc_fx[e].Draw();
        thunder[e].Draw();
        tornado[e].Draw();
        chillAfterHit[e].Draw();
        fireAfterHit[e].Draw();
    }

    tex_man->ReloadTexture(0x4A, (sceVif1Packet *) nullptr);

    if (DngMainScene->CheckDrawChara(0)) {
        MainChara__2->DrawEffect();
    }

    for (int c = 0; c < DNG_CHARA_EVENT_NUM; c++) {
        if (DngMainScene->CheckDrawChara(c + DNG_CHARA_SLOT_EVENT) && DngMainScene->GetType(SCENE_DATA_CHARA, c + DNG_CHARA_SLOT_EVENT) != SCENE_CHARA_TYPE_EFFECT) {
            CCharacter2 *chara = DngMainScene->GetCharacter(c + DNG_CHARA_SLOT_EVENT);

            if (chara != nullptr) {
                chara->DrawEffect();
            }
        }
    }

    ActiveMonster->DrawEffectScript();

    if (BattleAreaScene->weather == DNG_WEATHER_RAIN) {
        CPreSprite prim;

        prim.Initialize(nullptr, nullptr);
        prim.Preset2D();
        prim.TextureMapEnable(0);
        prim.Coord(0);
        prim.Shading(1);
        prim.DepthTestEnable(0);
        prim.DepthTest(MG_DEPTH_TEST_ALWAYS);
        prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
        prim.Begin(MG_PRIM_LINE);
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

    if (sphida != nullptr) {
        sphida->Draw();
    }

    int k = {};
    s8  show = BattleAreaScene->statusbar_show;

    if (NowTakePhoto()) {
        show = false;
    }

    if (show && debag_param && !(BattleAreaScene->pause_flag & DNG_PAUSE_MONSTER_DRAW)) {
        tex_man->ReloadTexture(0x48, (sceVif1Packet *) nullptr);
        LockOnModel.Draw();
    }

    if (show && debag_param && !(BattleAreaScene->pause_flag & (DNG_PAUSE_MONSTER_NAMES | DNG_PAUSE_MONSTER_DRAW)) && !config->monster_name) {
        LockOnModel.DrawMess(0x58);
    }

    tex_man->ReloadTexture(0x48, (sceVif1Packet *) nullptr);
    RedMarkModel->Draw();

    if (show && debag_param) {
        DngMainScene->DrawExclamationMark(RedMarkModel->frame);

        if (!(BattleAreaScene->pause_flag & DNG_PAUSE_MONSTER_DRAW)) {
            ActiveMonster->DrawLifeGage(config->anger_counter, config->enemy_hp);

            if (!config->damage_off) {
                DamageScore.Draw();
                DamageScore2.Draw(DngMainScene);

                for (k = 0; k < DNG_DAMAGE_SCORE_MONS_NUM; k++) {
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

        if (!BattleAreaScene->script.running && !(BattleAreaScene->pause_flag & DNG_PAUSE_MINIMAP) && config->map != SV_CONFIG_MAP_OFF) {
            tex_man->ReloadTexture(0x66, (sceVif1Packet *) nullptr);
            sceVu0FVECTOR pos;

            MainChara__2->GetPosition(pos);

            if (config->map == SV_CONFIG_MAP_SMALL) {
                AutoMapGen.mini_map.large = 0;
                AutoMapGen.mini_map.x = 436;
                AutoMapGen.mini_map.y = 144;
                AutoMapGen.mini_map.w = 112;
                AutoMapGen.mini_map.h = 112;
            }

            if (config->map == SV_CONFIG_MAP_LARGE) {
                AutoMapGen.mini_map.x = 336;
                AutoMapGen.mini_map.y = 212;
                AutoMapGen.mini_map.w = 320;
                AutoMapGen.mini_map.h = 280;
                AutoMapGen.mini_map.large = 1;
            }

            AutoMapGen.mini_map.Draw(pos);
            tex_man->ReloadTexture(0x48, (sceVif1Packet *) nullptr);
            AutoMapGen.mini_map.DrawSymbolOpen();
            GeoStone.DrawMiniMapSymbol(&AutoMapGen.mini_map);
            ActiveMonster->DrawMiniMapSymbol(&AutoMapGen.mini_map);
            TreasureBoxMan->DrawMiniMapSymbol(&AutoMapGen.mini_map);
            RandomCircle.DrawSymbol(&AutoMapGen.mini_map);
            CSphida *sphida2 = GetSphidaPtr();

            if (sphida2 != nullptr) {
                sphida2->DrawMiniMapSymbol(&AutoMapGen.mini_map);
            }

            AutoMapGen.mini_map.DrawSymbolClose();
            AutoMapGen.mini_map.DrawSymbol_Chara(MainChara__2);
        }
    }

    for (int c = 0; c < COLPRIM_MAX; c++) {
        ColPrimMan.prim[c].DebugDraw();
    }

    EdEventDraw();
    tex_man->ReloadTexture(0x58, (sceVif1Packet *) nullptr);

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
        int                       photo_neta = {};
        int                       monster = {};
        USER_PICTURE_INFO        *picture = {};
        CInventUserData          *invent = {};
        CFuncPoint               *point = {};
        CScene::InScreenCharaInfo chara_info{};
        float                     distance = {};

        tex_man->ReloadTexture(0x67, (sceVif1Packet *) nullptr);
        chara_info.chara_no = -1;
        chara_info.dist = 0.0f;
        chara_info.in_center = 0;
        invent = &DngUserData->invent_data;
        photo_neta = ActiveMonster->CheckPhoto(&chara_info);
        monster = chara_info.chara_no;
        picture = invent->IsPhotoSpace(nullptr);

        if (DrawTakePhoto(picture, &distance)) {
            InScreenFuncInfo func_info{};

            func_info.range = -1.0f;
            func_info.unk_04 = 0;
            func_info.dist = -1.0f;
            func_info.range = distance;
            point = DngMainScene->InScreenFunc(&func_info);
            picture->map_no = SearchMapNo(BattleAreaScene->map_name);
            int neta = -1;

            picture->neta_id = -1;
            picture->npc_no = -1;

            if (point != nullptr) {
                neta = point->invent.neta_no;
            }

            if (neta == 30001) {
                neta = -1;
                picture->npc_no = 260;
            }

            if (neta > 0) {
                picture->neta_id = neta;
                sndSePlay(GetSystemSndID(), SYSTEM_SE_IDEA, 0);
            }

            if (monster >= 0) {
                picture->monster_no = monster;

                if (photo_neta > 0) {
                    picture->neta_id = photo_neta;
                    sndSePlay(GetSystemSndID(), SYSTEM_SE_IDEA, 0);
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
    DNG_BATTLE_AREA  *area = {};
    sceVu0FVECTOR     wind;
    float             power = {};
    int               i = {};

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

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_STEP)) {
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
            int             foot_no = MainChara__2->CheckFootEffect();
            DNG_FOOT_EFFECT effect[35] = {DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_GRASS, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_DUST, DNG_FOOT_EFFECT_DUST, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_SPLASH, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_DUST, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_DUST, DNG_FOOT_EFFECT_NONE,
                                          DNG_FOOT_EFFECT_SPLASH, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE, DNG_FOOT_EFFECT_NONE};

            if (foot_no >= 0) {
                int kind = effect[foot_no];

                if (kind == DNG_FOOT_EFFECT_DUST) {
                    FxScriptMan->CreateEffSpt("\x91\xab\x8d\xbb\x89\x8c", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                }

                if (kind == DNG_FOOT_EFFECT_GRASS) {
                    FxScriptMan->CreateEffSpt("\x91\xab\x8d\xbb\x89\x8c", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                    FxScriptMan->CreateEffSpt("\x91\xab\x8e\xc5\x90\xb6", 0, -1);
                    FxScriptMan->SetScriptVect1(pos, -1, -1);
                }

                if (kind == DNG_FOOT_EFFECT_SPLASH) {
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

    if (pot == POT_STEP_BREAK || pot == POT_STEP_TIMEOUT) {
        if (BTsuboCol != nullptr) {
            BTsuboCol->Delete(-1);
            BTsuboCol = nullptr;
        }

        if (iRand(100) % 3 == 0) {
            sceVu0FVECTOR pos;

            sceVu0CopyVector(pos, BTsubo.break_pos);
            pos[1] += 10.0f;
            sceVu0FVECTOR velo = {0.0f, 1.5f, 0.0f, 0.0f};
            CPullItem    *item = PullItemMan.GetList(2);

            if (item != nullptr) {
                int no = {};

                sceVu0CopyVector(velo, BTsubo.velocity);
                sceVu0Normalize(velo, velo);
                sceVu0ScaleVector(velo, velo, -2.0f);
                item->SetItem(pos, velo, PULL_ITEM_ITEM);

                if (iRand(100) % 10 == 0) {
                    no = iRand(10) + 175;
                } else {
                    int r = iRand(100);

                    no = 275;

                    if (r < 80) {
                        no = 268;
                    }

                    if (r < 40) {
                        no = ITEM_ID_MELEE_REPAIR;

                        if (iRand(100) < 40) {
                            if (DngSaveDataDungeon->stage_id == 0) {
                                no = ITEM_ID_GUN_REPAIR;
                            } else {
                                if (iRand(100) < 50) {
                                    no = ITEM_ID_GUN_REPAIR;
                                } else {
                                    no = ITEM_ID_MAGIC_REPAIR;
                                }
                            }
                        }
                    }

                    if (DngSaveDataDungeon->stage_id == 0) {
                        if (DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id] >= 5 && iRand(100) < 20) {
                            no = ITEM_ID_RIDEPOD_FUEL;
                        }
                    } else if (iRand(100) < 20) {
                        no = ITEM_ID_RIDEPOD_FUEL;
                    }
                }

                item->item_no = no;
            }
        }
    }

    if (BTsuboCol != nullptr) {
        BTsuboCol->SetCoord(BTsubo.position, 5.0f);

        if (BTsuboCol->hit_num) {
            sceVu0FVECTOR hit;
            sceVu0FVECTOR velo;

            /**
             *
             * Four components copied into the hit position.
             *
             */
            struct VEC4 {
                float v[4]; /**< Vector components. */
            };

            *reinterpret_cast<VEC4 *>(hit) = *reinterpret_cast<VEC4 *>(BTsuboCol->hit_vec);
            velo[0] = 0.0f;
            velo[1] = 10.0f;
            velo[2] = 0.0f;
            velo[3] = 1.0f;
            BTsubo.Bakuhatsu(velo, hit);
            BTsuboCol->Delete(-1);
            BTsuboCol = nullptr;
        }
    }

    BTsubo2.Step();
    sceVu0FVECTOR player;
    MainChara__2->GetPosition(player);
    AutoMapGen.UpdateNaviMap(player, 4);

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_MONSTER_AI)) {
        ActiveMonster->ThinkHost();
    }

    if (BattleAreaScene->pause_flag & DNG_PAUSE_FIELD_STEP) {
        return;
    }

    static int water_cnt2 = 0;
    water_cnt2++;

    if (water_cnt2 >= 10) {
        water_cnt2 = 0;

        for (int m = 0; m < MONSTER_ACTIVE_MAX; m++) {
            CActiveMonster *mons = ActiveMonster->active[m];

            if (mons != nullptr && mons->state && mons->target_dist <= mons->clip_dist && mons->mons_move_check.in_water) {
                sceVu0FVECTOR pos;
                sceVu0FVECTOR top;

                sceVu0CopyVector(pos, mons->mons_move_check.water_surface);
                pos[1] += 0.1f;
                float width = mons->GetBodyWidth() / 5.0f;
                float height = mons->GetBodyHeight();
                mons->GetEntryObjectPos(CHARA_ENTRY_GROUP_TARGET, 0, top);

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

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_MONSTER_AI)) {
        ActiveMonster->StepEffectScript();
    }

    if (BattleAreaScene->pause_flag & DNG_PAUSE_MONSTER_AI) {
        FxScriptMan->PauseFromLevel(3, 3);
    }

    FxScriptMan->Step();
    FxScriptMan->PauseFromLevel(3, 0);

    for (i = 0; i < DNG_CHARA_EVENT_NUM; i++) {
        if (DngMainScene->CheckDrawChara(i + DNG_CHARA_SLOT_EVENT) || DngMainScene->CheckDrawCharaShadow(i + DNG_CHARA_SLOT_EVENT)) {
            CCharacter2 *chara = DngMainScene->GetCharacter(i + DNG_CHARA_SLOT_EVENT);

            if (chara != nullptr) {
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

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_STATUS)) {
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

    for (int d = 0; d < DNG_DAMAGE_SCORE_MONS_NUM; d++) {
        DamageScoreMons[d].Step();
    }

    map_effect.Step(&MainCamera);
    BattleFX.Step();

    for (int e = 0; e < DNG_ELEMENT_EFFECT_NUM; e++) {
        Sparc_fx[e].Step();
        thunder[e].Step();
        tornado[e].Step();
        chillAfterHit[e].Step();
        fireAfterHit[e].Step();
    }

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_PICKUPS)) {
        for (int p = 0; p < DNG_PULL_ITEM_NUM; p++) {
            PullItem[p].Step();
            PullItem[p].IsGet(player);
        }

        for (int w = 0; w < DNG_AFTER_WIRE_NUM; w++) {
            afterWire[w].StepWire();
        }
    }

    if (BattleAreaScene->statusbar_show && debag_param) {
        WarningGage2.Step();
    }

    MiniEffPrimMan.Step();

    if (auto *floor_map = dc2::dungeon::MainMap().Get(); floor_map != nullptr) {
        CObjAnimeEnv env{};

        *reinterpret_cast<u_long128 *>(env.chara_pos) = *reinterpret_cast<u_long128 *>(MainChara__2->position);
        env.time = DngMainScene->time;
        floor_map->EffectStep();
        floor_map->AnimeStep(&env);
        floor_map->Step();
        HealingEffectMan.Step();
        AutoMapGen.Step();
    }

    RandomCircle.Step();
    GeoStone.GeoStep();
    StepHelpMes();
    BattleSoundManager();

    if (!(BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_STATUS)) {
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
            BattleAreaScene->script.running = false;
            DngMainScene->active_camera = 0;
            BattleAreaScene->pause_flag &= ~DNG_PAUSE_PLAYER_STATUS;
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

int DngMainKey();

void IsEventRun() {
    sceVu0FVECTOR     pos;
    CBattleCharaInfo *info = {};
    int               button = {};
    int               near = {};
    s16              *event_no = {};

    if (MainChara__2 == nullptr) {
        return;
    }

    MainChara__2->GetPosition(pos);
    event_no = &BattleAreaScene->script.event_no;
    info = GetBattleCharaInfo();

    if (info == nullptr) {
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

    if (MainChara__2->move_check.ground_poly.area_kind == COL_AREA_HEALING && info->chr_no != USER_CHARA_ROBO) {
        int max = {};
        int attr = {};

        attr = info->GetAttr() & (CHARA_STATUS_ALL & ~CHARA_STATUS_POWER);
        max = info->GetMaxHp_i();

        if ((max > info->GetNowHp_i() || attr) && AutoMapGen.healing_point.CheckHealingTime()) {
            float healing = 9999.0f;
            info->AddHp_Point(healing, 0.0f);
            info->SetAttr(CHARA_STATUS_ALL & ~CHARA_STATUS_POWER, 1);
            FxScriptMan->CreateEffSpt("\x92\xca\x8f\xed\x89\xf1\x95\x9c", 0, 0);
            FxScriptMan->SetScriptTargetId(0, -1, -1);
            CPalletAnime *pallet = &MainChara__2->script_pallet;
            pallet->red = 0x60;
            pallet->green = 0xB4;
            pallet->blue = 0xFF;
            pallet->pulse_num = 1;
            pallet->duration = 45;
            pallet->elapsed = 0;
            pallet->repeats = 0;
            sndSePlay(GetSystemSndID(), SYSTEM_SE_RECOVER, 0);
            BattleAreaScene->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
        }
    }

    if (info->GetAttr() & (CHARA_STATUS_STOP | CHARA_STATUS_STONE)) {
        return;
    }

    int run = ActiveMonster->IsRunEvent();

    if (run != -1) {
        *event_no = run;
        return;
    }

    int num = ActiveMonster->GetMonsterNum(-1.0f);
    num += TreasureBoxMan->MimicCount();

    if (num == 0 && !BattleAreaScene->battle_clear) {
        *event_no = DNG_EVENT_FLOOR_CLEAR;
        BattleAreaScene->battle_clear = true;
        ColPrimMan.Initialize(DngMainScene);
        BTsubo.Clear();
        BTsuboCol = nullptr;
        return;
    }

    if (DngStatus.eye_view) {
        return;
    }

    if (!DngSaveData->GetBitFlag(SAVE_FLAG_GUIDE_MAGIC_SWORD) && info->GetMagicSwordCounterNow() > 0) {
        *event_no = DNG_EVENT_MAGIC_SWORD_GUIDE;
        DngSaveData->SetBitFlag(SAVE_FLAG_GUIDE_MAGIC_SWORD, 1);
        return;
    }

    if (!MainChara__2->CheckRunEvent()) {
        return;
    }

    if (RandomCircle.CheckEvent(pos) != -1) {
        *event_no = DNG_EVENT_RANDOM_CIRCLE;
        MainChara__2->ResetAccele();
        return;
    }

    button = MAP_EVENT_CHECK_TOUCH;

    if (PadCtrl.Btn(PAD_BTN_CONFIRM)) {
        button = MAP_EVENT_CHECK_ACTION;
    }

    if (PadCtrl.Btn(PAD_BTN_ACTION_SQUARE)) {
        button = MAP_EVENT_CHECK_ITEM;
    }

    near = false;
    CActiveMonster *target = ActiveMonster->GetPriorityLevelIndex(0, nullptr);

    if (target != nullptr && target->target_dist < 200.0f) {
        near = true;
    }

    CSceneEventData data;

    if (DngMainScene->GetMapEvent(pos, button, &data)) {
        DngMainScene->RunEvent(data.event.point_no, &data);
        return;
    }

    if (DngMainScene->map_event_no) {
        RedMarkModel->draw_request = true;
    }

    if (!DngSaveData->GetBitFlag(SAVE_FLAG_ROBO_BIKE_EVENT_SEEN) && info->chr_no == USER_CHARA_ROBO && MainChara__2->move_type == ACTION_MOVE_ROBO_BIKE) {
        *event_no = DNG_EVENT_ROBO_BIKE_GUIDE;
        DngSaveData->SetBitFlag(SAVE_FLAG_ROBO_BIKE_EVENT_SEEN, 1);
    }

    if (!DngSaveData->GetBitFlag(SAVE_FLAG_GUIDE_RANDOM_STONE) && (info->chr_no == USER_CHARA_MAX || info->chr_no == USER_CHARA_MONICA)) {
        if (AutoMapGen.SearchRandomStone(pos, 30.0f)) {
            if (button == MAP_EVENT_CHECK_ACTION) {
                *event_no = DNG_EVENT_RANDOM_STONE;
                return;
            }

            RedMarkModel->draw_request = true;
        }
    }

    if (!DngSaveData->GetBitFlag(SAVE_FLAG_GUIDE_LEVEL_UP) && LevelupInfo.phase != 0) {
        *event_no = DNG_EVENT_LEVEL_UP_GUIDE;
        DngSaveData->SetBitFlag(SAVE_FLAG_GUIDE_LEVEL_UP, 1);
        return;
    }

    if (GeoStone.CheckEvent(pos)) {
        if (button == MAP_EVENT_CHECK_ACTION) {
            *event_no = DNG_EVENT_GEOSTONE;
            return;
        }

        RedMarkModel->draw_request = true;
    }

    float dist = 30.0f;

    if (info->chr_no == USER_CHARA_ROBO) {
        dist = 50.0f;
    }

    if (TreasureBoxMan->CheckEvent(pos, dist) >= 0 && !near) {
        if (button == MAP_EVENT_CHECK_ACTION) {
            *event_no = DNG_EVENT_TREASURE_BOX;
            return;
        }

        RedMarkModel->draw_request = true;
    }

    int talk = ActiveMonster->CheckMonsterTolk(pos);

    if (talk != -1) {
        if (button == MAP_EVENT_CHECK_ACTION || button == MAP_EVENT_CHECK_ITEM) {
            *event_no = DNG_EVENT_MONSTER_TALK;
            EdEventInfo.monster_talk[0] = talk + DNG_CHARA_SLOT_MONSTER;
            EdEventInfo.monster_talk[2] = ActiveMonster->active[talk]->locate_param;
            EdEventInfo.monster_talk[1] = ActiveMonster->active[talk]->monster_id;
        } else {
            RedMarkModel->draw_request = true;
        }
    }
}

int EventScriptSetup(SYSTEM_SCRIPT_INFO *script) {
    InitEvent(DngMainScene);
    VoiceUnit.StopVoice(10);
    DngMainScene->fade.ResetFade();

    if (RunEvent(script->event_no, DngMainScene)) {
        script->running = true;
        dc2::log::PrintGame("RUN SYS_SCRIPT %d\n", script->event_no);
        DngStatus.mode = DNG_STATUS_EVENT;
        DngMainScene->before_camera = 0;
        ResetEyeView(MainChara__2);
        dc2::memory::CopyTrackedBytes(&EventCamera, &MainCamera, sizeof(CCameraControl));
        DngMainScene->active_camera = 1;
        MainChara__2->sound_info.foot_sound_id = -1;
        LoopSoundManager(0);
        BattleAreaScene->pause_flag |= DNG_PAUSE_PLAYER_STATUS;
        MainChara__2->RemoveThrowItem();
        MsgTaskMan.Clear();
        BattleAreaScene->script.event_no = -1;
        return true;
    }

    return false;
}

int IsRunDeadEvent(CActionChara *chara) {
    CBattleCharaInfo *info = {};

    if (DngStatus.mode != DNG_STATUS_FIELD) {
        return false;
    }

    info = GetBattleCharaInfo();

    if (info->chr_no == USER_CHARA_MONSTER) {
        if (info->GetWhpNowVol(0) <= 0) {
            chara->damage_req = ACTION_DAMAGE_REQ_DEAD;
            return true;
        }
    }

    if (info->GetNowHp_i() <= 0) {
        chara->damage_req = ACTION_DAMAGE_REQ_DEAD;
        return true;
    }

    return false;
}

int ChangeSetUnit(int change);

void CheckStatusError() {
    sceVu0FVECTOR     pos;
    sceVu0FVECTOR     top;
    CBattleCharaInfo *info = {};
    int               damage = {};
    int               step = {};
    int               attr = {};

    if (MainChara__2 == nullptr) {
        return;
    }

    MainChara__2->GetEntryObjectPos(CHARA_ENTRY_GROUP_TARGET, 0, pos);
    info = GetBattleCharaInfo();
    step = info->StatusParamStep(&damage);
    attr = info->GetAttr();

    if (info->GetNowHp_i() <= 0) {
        return;
    }

    MainChara__2->GetEntryObjectPos(CHARA_ENTRY_GROUP_TARGET, 0, top);
    top[1] += MainChara__2->body_height;

    if (step & 1) {
        DamageScore2.SetValue(0, damage, MainChara__2->body_height);
        MainChara__2->pallet[0].SetAnim(0x60, 0x20, 0x60, 1, 30, 0);
    }

    DngStatus.status_count++;

    if (DngStatus.status_count >= 45) {
        DngStatus.status_count = 0;

        if (attr & CHARA_STATUS_POWER) {
            MainChara__2->pallet[0].SetAnim(0x100, 0xDC, 0x40, 1, 45, 0);
        }

        if (attr & CHARA_STATUS_SLOW) {
            MainChara__2->pallet[0].SetAnim(0xA0, 0x40, 0xA0, 1, 45, 0);
        }

        if (attr & CHARA_STATUS_STOP) {
            MainChara__2->pallet[0].SetAnim(0x80, 0x40, 0, 1, 45, 0);
        }

        if (attr & CHARA_STATUS_STONE) {
            MainChara__2->pallet[0].SetAnim(0x20, 0x20, 0x20, 1, 45, 0);
        }
    }

    if (info->GetNowHp_i() <= 0) {
        MainChara__2->damage_req = ACTION_DAMAGE_REQ_DEAD;
    }
}

/**
 *
 * Camera position saved when the eye view starts and restored when it ends.
 *
 */
static sceVu0FVECTOR backup_pos;

void InitEyeCamera(CActionChara *chara) {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    sceVu0FVECTOR     rot;
    sceVu0FVECTOR     arm_rot;
    CActionChara     *arm = {};
    mgCCamera        *camera = {};

    chara->GetRotation(rot);

    if (info->chr_no == USER_CHARA_ROBO) {
        arm = MainChara__2->SearchChara("arm");

        if (arm != nullptr) {
            arm->GetRotation(arm_rot);
            rot[1] = mgAngleLimit(rot[1] + arm_rot[1]);
        }
    }

    viewAngleV__2 = 0.0f;
    viewAngleH__2 = rot[1];
    camera = DngMainScene->GetCamera(DngMainScene->active_camera);

    if (camera != nullptr) {
        camera->GetPos(backup_pos);
        (static_cast<mgCCameraFollow *>(camera))->FollowOff();
        init_camera = true;
    }

    DngStatus.eye_view = true;
    MainChara__2->Show(0, 1);
    mgSetAllScissorFlag(1);
}

void CheckWeaponEnable() {
    CActionChara *weapon = {};

    if (BattleAreaScene->pause_flag & DNG_PAUSE_WEAPON_DRAW) {
        weapon = MainChara__2->SearchChara("sword");

        if (weapon != nullptr) {
            weapon->Show(0, 0);
        }

        weapon = MainChara__2->SearchChara("shot");

        if (weapon != nullptr) {
            weapon->Show(0, 0);
        }
    } else {
        MainChara__2->Show(1, 1);
    }
}

void ResetEyeView(CActionChara *chara);

/**
 *
 * Updates the dungeon eye camera orientation from gamepad input.
 *
 */
static void EyeCamera(mgCCamera *camera, CCharacter2 *chara, int mode) {
    float             lx = {};
    float             ly = {};
    float             speed = 0.04f;
    SV_CONFIG_OPTION *config = {};
    sceVu0FVECTOR     pos;
    sceVu0FVECTOR     ref;
    sceVu0FMATRIX     rot;
    sceVu0FMATRIX     unit;

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

        if (viewAngleH__2 < -PI) {
            viewAngleH__2 += TWO_PI;
        }
    }

    if (lx < 0.0f) {
        viewAngleH__2 -= lx * speed;

        if (viewAngleH__2 > PI) {
            viewAngleH__2 -= TWO_PI;
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

/**
 *
 * Value shown on each line of the debug command menu.
 *
 */
int debug_no[8] = {100, 0, 1, 0, 0, 0, 0, 0};

void DebugMainDraw() {
    if (DngStatus.debug_window) {
        mgTexManager.ReloadTexture(0x6C, (sceVif1Packet *) nullptr);
        CPreSprite prim;
        prim.Initialize(nullptr, nullptr);
        prim.Preset2D();
        prim.TextureMapEnable(0);
        prim.Begin(MG_PRIM_SPRITE);
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
        char *menu[7] = {"%sRUN SCRIPT %d", "%sENEMY RELOAD %d", "%sBGM %d", "%sRANDOM MAP %d",
                         "%sPLAY SPHIDA %d", "%sCAMERA DEBUG %d", "%sMOVE DEBUG %d"};
        int   i = {};

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
            prim.Initialize(nullptr, nullptr);
            prim.Preset2D();
            prim.TextureMapEnable(0);
            prim.Begin(MG_PRIM_SPRITE);
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
    mgCMemory *stack = {};

    EntryEventScript(DngStatus.dungeon_no);
    stack = GetMainStack();
    BuffEventData[0].stSetBorrowedBuffer(*stack, std::span(stack->stGetTop(), static_cast<std::size_t>(stack->stGetRest())));
    dc2::memory::CopyTrackedBytes(&EventCamera, &MainCamera, sizeof(CCameraControl));
    DngMainScene->active_camera = 1;
    InitEvent(DngMainScene);

    if (RunEvent(no, DngMainScene)) {
        DngStatus.debug_window = false;
        DngStatus.mode = DNG_STATUS_EVENT;
        DngMainScene->before_camera = 0;
    }
}

void dc2::dungeon::ResetEyeViewCore(CActionChara *chara) {
    mgCCamera *camera = {};

    if (!DngStatus.eye_view) {
        return;
    }

    camera = DngMainScene->GetCamera(DngMainScene->active_camera);

    if (camera != nullptr) {
        if (init_camera) {
            camera->SetPos(backup_pos);
        }

        (static_cast<mgCCameraFollow *>(camera))->FollowOn();
    }

    DngStatus.eye_view = false;
    chara->Show(1, 1);
    CheckWeaponEnable();
    mgSetAllScissorFlag(0);
    init_camera = false;

    if (NowTakePhoto()) {
        EndTakePhoto();
    }
}

int dc2::dungeon::ChangeSetUnitCore(int change) {
    CUserDataManager *user = GetUserDataMan();
    int               next = -1;
    int               chr = user->active_chr_no;

    if (change == DNG_CHANGE_UNIT_PARTNER) {
        if (chr == USER_CHARA_MAX && DngUserData->CheckQuickChange(USER_CHARA_MONICA, nullptr)) {
            next = USER_CHARA_MONICA;
        }

        if (chr == USER_CHARA_MONICA && DngUserData->CheckQuickChange(USER_CHARA_MAX, nullptr)) {
            next = USER_CHARA_MAX;
        }
    }

    if (change == DNG_CHANGE_UNIT_RIDE) {
        if (chr == USER_CHARA_MAX && DngUserData->CheckQuickChange(USER_CHARA_ROBO, nullptr)) {
            next = USER_CHARA_ROBO;
        }

        if (chr == USER_CHARA_MONICA && DngUserData->CheckQuickChange(USER_CHARA_MONSTER, nullptr)) {
            next = USER_CHARA_MONSTER;
        }

        if (chr == USER_CHARA_ROBO && DngUserData->CheckQuickChange(USER_CHARA_MAX, nullptr)) {
            next = USER_CHARA_MAX;
        }

        if (chr == USER_CHARA_MONSTER && DngUserData->CheckQuickChange(USER_CHARA_MONICA, nullptr)) {
            next = USER_CHARA_MONICA;
        }
    }

    return next;
}

int dc2::dungeon::MainKeyCore() {
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

        if (GamePad__2.Down(PAD_R3)) {
            dngDebugStart();
            return 0;
        }

        if (GamePad__2.Down2(PAD_R1)) {
            debag_param ^= 1;
        }

        if (GamePad__2.Down2(PAD_CROSS)) {
            static float         erate = 1.0f;
            static sceVu0FVECTOR chk_pos;

            MainChara__2->GetEntryObjectPos(CHARA_ENTRY_GROUP_TARGET, 0, chk_pos);
            wep_effect->Set(reinterpret_cast<sceVu0FVECTOR *>(chk_pos), chk_pos, erate, 2, 10.0f);
            erate += 32.0f;

            if (erate > 300.0f) {
                erate = 1.0f;
            }
        }

        if (GamePad__2.Down2(PAD_TRIANGLE)) {
            float         size = 20.0f;
            sceVu0FVECTOR pos;

            MainChara__2->GetPosition(pos);
            tornado[0].SetPos(pos, size, fRand(255.0f));
            size = 1.0f;
        }

        if (GamePad__2.On2(PAD_R2)) {
            BattleAreaScene->SetStatusBar(1, 0.02f);
        }

        if (GamePad__2.On2(PAD_L2)) {
            BattleAreaScene->SetStatusBar(0, 0.02f);
        }
    }

    if (GamePad__2.Down(PAD_SELECT)) {
        SV_CONFIG_OPTION *config = DngSaveData->GetConfig();

        if (config != nullptr) {
            config->map++;

            if (config->map > SV_CONFIG_MAP_LARGE) {
                config->map = SV_CONFIG_MAP_OFF;
            }
        }
    }

    int               dead = false;
    CBattleCharaInfo *chara_info = GetBattleCharaInfo();

    if (chara_info != nullptr && chara_info->GetNowHp_i() <= 0) {
        dead = true;
    }

    if (SubGameRunning()) {
        sgLoopSubGame();

        if (GamePad__2.Down(PAD_TRIANGLE) && sgMenuOpenEnable()) {
            VoiceUnit.StopVoice(10);
            MenuArg.open_type = MENU_OPEN_MAIN_DUNGEON;
            DngStatus.mode = DNG_STATUS_MENU;
            DngMainScene->fade.ResetFade();
            BattleAreaScene->SetStatusBarNow(0);
            WarningGage2.warning[0] = false;
            WarningGage2.warning[1] = false;
            WarningGage2.warning[2] = false;
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
    SYSTEM_SCRIPT_INFO *script = {};

    if (DngMainScene->event_run) {
        int no = {};

        DngMainScene->event_run = false;
        script = &BattleAreaScene->script;
        script->event_no = no = DngMainScene->event_no;
    }

    CSphida *sphida = GetSphidaPtr();

    if (sphida != nullptr) {
        if (OmakeFlag && (PadCtrl.Btn(PAD_BTN_PAUSE) || !GamePad__2.Connect())) {
            MenuArg.open_type = MENU_OPEN_SPHIDA_SCORE_VIEW;
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

    if (GamePad__2.Down(PAD_L3)) {
        unit = DNG_CHANGE_UNIT_PARTNER;
    }

    if (GamePad__2.Down(PAD_R3)) {
        unit = DNG_CHANGE_UNIT_RIDE;
    }

    if (MainChara__2->CheckRunEvent() && unit >= 0 && !dead) {
        unit = ChangeSetUnit(unit);

        if (unit >= 0) {
            VoiceUnit.StopVoice(10);
            MenuArg.param[0] = unit;
            MenuArg.open_type = MENU_OPEN_MAIN_CHARA_BG_DUNGEON;
            DngStatus.mode = DNG_STATUS_MENU;
            DngMainScene->fade.ResetFade();
            BattleAreaScene->SetStatusBarNow(0);
            MainChara__2->RemoveThrowItem();
            WarningGage2.warning[0] = false;
            WarningGage2.warning[1] = false;
            WarningGage2.warning[2] = false;
            LockOnModel.pos[3] = 0.0f;
            return 0;
        }
    }

    if (GamePad__2.On(PAD_TRIANGLE) && MainChara__2->CheckRunEvent() && !dead) {
        if (NowTakePhoto()) {
            MenuArg.open_type = MENU_OPEN_INVENT;
        } else {
            MenuArg.open_type = MENU_OPEN_MAIN_DUNGEON;
        }

        VoiceUnit.StopVoice(10);
        DngStatus.mode = DNG_STATUS_MENU;
        DngMainScene->fade.ResetFade();
        BattleAreaScene->SetStatusBarNow(0);
        MainChara__2->RemoveThrowItem();
        WarningGage2.warning[0] = false;
        WarningGage2.warning[1] = false;
        WarningGage2.warning[2] = false;
        LockOnModel.pos[3] = 0.0f;
        return 0;
    }

    CActionChara   *chara = MainChara__2;
    CCameraControl *camera = static_cast<CCameraControl *>(DngMainScene->GetCamera(DngMainScene->active_camera));

    if (DngStatus.eye_view) {
        if (GamePad__2.Down(PAD_R2) || PadCtrl.Btn(PAD_BTN_CANCEL)) {
            ResetEyeView(MainChara__2);
            return 0;
        }
    } else if (GamePad__2.Down(PAD_R2) && !SubGameRunning() && MainChara__2->CheckRunEvent()) {
        InitEyeCamera(MainChara__2);
        return 0;
    }

    if (!DngStatus.eye_view && GamePad__2.Down(PAD_SQUARE) && !(BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_CONTROL) && chara_info->chr_no == USER_CHARA_MAX &&
        MainChara__2->CheckRunEvent()) {
        int            found = false;
        CGameDataUsed *items = GetBattleCharaInfo()->GetActiveItemInfo(0);

        if (BattleAreaScene->statusbar_show) {
            CGameDataUsed *item = &items[DngStatus.active_item];

            if (item->item_no == ITEM_ID_CAMERA) {
                found = true;
            }
        } else {
            for (int i = 0; i < 3; i++) {
                if (items[i].item_no == ITEM_ID_CAMERA) {
                    found = true;
                }
            }
        }

        if (found) {
            StartTakePhoto();
            InitEyeCamera(MainChara__2);
            return 0;
        }
    }

    if (BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_CONTROL) {
        ResetEyeView(MainChara__2);
    }

    if (DngUserData->active_chr_no == USER_CHARA_ROBO && DngUserData->CheckRoboVoiceFlag() && VoiceUnit.status == ROBO_VOICE_OFF) {
        VoiceUnit.StartVoiceSystem();
    }

    if (IsRunDeadEvent(MainChara__2)) {
        ResetEyeView(MainChara__2);
    }

    if (!DngStatus.eye_view) {
        if (!DebugPause && !(BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_CONTROL)) {
            MainChara__2->RunScript(DngMainScene, &ActionScriptEnv);
        }

        if (MainChara__2->CheckReleaseTimming(-1)) {
            if (MainChara__2->CheckReleaseTimming(-1) == ACTION_RELEASE_KICK) {
                BTsubo.Hold(MainChara__2->hold_parts);
                BTsubo2.SetObject2(DngStatus.dungeon_no, AutoMapGen.pot_parts);
                BTsubo.Throw();
                BTsuboCol = ColPrimMan.GetPrim();

                if (BTsuboCol != nullptr) {
                    BTsuboCol->SetDamage("\x92\xd9", 0);
                }
            }

            if (MainChara__2->CheckReleaseTimming(ACTION_HOLD_STONE) == ACTION_RELEASE_CATCH) {
                BTsubo.Hold(MainChara__2->hold_parts);
                BTsubo2.SetObject2(DngStatus.dungeon_no, AutoMapGen.pot_parts);
            }

            if (MainChara__2->CheckReleaseTimming(-1) == ACTION_RELEASE_THROW_STONE) {
                MainChara__2->GetNowFrame(nullptr);
                BTsubo.Throw();
                BTsuboCol = ColPrimMan.GetPrim();

                if (BTsuboCol != nullptr) {
                    BTsuboCol->SetDamage("\x92\xd9", 0);
                }
            }
        }

        MainCamera.rot_reverse = !DngSaveData->GetConfig()->rot_normal;
        static int camera_default_dist = 1;
        float      dist_table[3] = {100.0f, 160.0f, 500.0f};

        if (GamePad__2.Down2(PAD_SELECT)) {
            if (camera_default_dist >= 2) {
                camera_default_dist = 0;
            } else {
                camera_default_dist++;
            }

            MainCamera.SetDistance(dist_table[camera_default_dist]);
            test_dist = dist_table[camera_default_dist];
        }

        static int   cam_table[] = {0, 1, 2, 3};
        static float cam_table_dist[][2] = {
            {110.0f, 140.0f},
            {110.0f, 140.0f},
            {130.0f, 190.0f},
            {110.0f, 140.0f}
        };
        int n = {};

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
            int             no = chara->target_no - DNG_CHARA_SLOT_MONSTER;
            CActiveMonster *mons = ActiveMonster->active[no];

            if (mons != nullptr) {
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
                        float rate = (static_cast<float>(screen[0]) - 480.0f) / 128.0f;

                        if (rate > 1.0f) {
                            rate = 1.0f;
                        }

                        MainCamera.Rotate(-(PI / 24.0f * rate));
                    }

                    if (screen[0] < 32) {
                        float rate = static_cast<float>(screen[0]) - 32.0f;

                        rate /= 128.0f;
                        MainCamera.Rotate(-(PI / 24.0f * rate));
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

                    if (angle > PI) {
                        angle -= TWO_PI;
                    }

                    if (angle <= -PI) {
                        angle += TWO_PI;
                    }

                    if (angle > 0.0f) {
                        MainCamera.Rotate(-(PI / 32.0f));
                    }

                    if (angle < 0.0f) {
                        MainCamera.Rotate(PI / 32.0f);
                    }
                }
            }
        }

        if (BattleAreaScene->camera_mode == DNG_CAMERA_FOLLOW) {
            if (DebugInfo.debug_camera == 0) {
                sceVu0FVECTOR rot;

                camera->ControlOn();
                MainChara__2->GetRotation(rot);
                float         dist = camera->GetDistance();
                CMap         *map = DngMainScene->GetMap(DngMainScene->active_map);
                CCPoly        poly[512];
                mgVu0FBOX     box{};
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
                    dc2::log::PrintGame("camera ply not found\n");
                    return 0;
                }

                camera->MoveCamera(&PadCtrl, rot, poly, num);
            }

            if (DebugInfo.debug_camera == 1) {
                camera->ControlOff();
                camera->AddAngle(0.06f * -GamePad__2.GetRXf());

                if (GamePad__2.On(PAD_L3)) {
                    camera->AddDistance(3.0f * GamePad__2.GetRYf());
                } else {
                    camera->AddHeight(3.0f * -GamePad__2.GetRYf());
                }

                if (GamePad__2.On(PAD_L2)) {
                    reference += 3.0f * -GamePad__2.GetRYf();
                }
            }

            if (PadCtrl.Btn(PAD_BTN_ACTION_CANCEL)) {
                sceVu0FVECTOR rot;

                MainChara__2->GetRotation(rot);
                float angle = rot[1];

                if (MainChara__2->lock_on && chara->target_no >= 0) {
                    int             no = chara->target_no - DNG_CHARA_SLOT_MONSTER;
                    CActiveMonster *mons = ActiveMonster->active[no];

                    if (mons != nullptr) {
                        sceVu0FVECTOR chara_pos;
                        sceVu0FVECTOR target;

                        mons->GetPosition(target);
                        MainChara__2->GetPosition(chara_pos);
                        sceVu0SubVector(target, target, chara_pos);
                        angle = atan2f(target[0], target[2]);
                    }
                }

                angle += PI;

                if (angle > PI) {
                    angle -= TWO_PI;
                }

                camera->RotBack(angle);
            }
        }

        if (BattleAreaScene->camera_mode == DNG_CAMERA_BOSS) {
            MainCamera.FollowOff();
            CCharacter2  *boss = DngMainScene->GetCharacter(DNG_CHARA_SLOT_MONSTER);
            sceVu0FVECTOR chara_pos;

            MainChara__2->GetPosition(chara_pos);
            chara_pos[1] += 2.0f * MainChara__2->GetBodyHeight();
            sceVu0FVECTOR boss_pos;

            boss->GetEntryObjectPos(CHARA_ENTRY_GROUP_TARGET, 0, boss_pos);

            if (boss_pos[1] > 160.0f) {
                boss_pos[1] = 160.0f;
            }

            sceVu0FVECTOR eye;

            sceVu0SubVector(eye, chara_pos, boss_pos);
            eye[3] = 1.0f;
            mgDistVector(eye);
            float height = atan2f(sqrt(eye[0] * eye[0] + eye[2] * eye[2]), eye[1]) / PI / 2.0f;

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

        if (BattleAreaScene->camera_mode == DNG_CAMERA_ARENA) {
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
            float rate = (mgDistVector(from, to) - 172.0) / 497.0;
            float k_radius = 450.0f;
            float k_eye = 50.0f;
            float k_ref = -100.0f;
            float radius = rate * k_radius;
            float eye_y = {};
            float ref_y = {};

            radius += 350.0f;
            eye_y = rate * k_eye;
            eye_y += 800.0f;
            ref_y = rate * k_ref;
            ref_y += 850.0f;
            rate = 268.8 + radius * sin(angle);
            MainCamera.SetNextPos(rate, eye_y, -322.4 + radius * cos(angle));
            MainCamera.SetNextRef(268.8f, ref_y, -322.4f);
        }

        if (BattleAreaScene->camera_mode == DNG_CAMERA_FOLLOW_LOW) {
            sceVu0FVECTOR rot;

            camera->ControlOn();
            MainChara__2->GetRotation(rot);
            float         dist = camera->GetDistance();
            CMap         *map = DngMainScene->GetMap(DngMainScene->active_map);
            CCPoly        poly[512];
            mgVu0FBOX     box{};
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

            if (PadCtrl.Btn(PAD_BTN_ACTION_CANCEL)) {
                sceVu0FVECTOR rot2;

                MainChara__2->GetRotation(rot2);
                float angle = rot2[1];

                if (MainChara__2->lock_on && chara->target_no >= 0) {
                    int             no = chara->target_no - DNG_CHARA_SLOT_MONSTER;
                    CActiveMonster *mons = ActiveMonster->active[no];

                    if (mons != nullptr) {
                        sceVu0FVECTOR chara_pos;
                        sceVu0FVECTOR target;

                        mons->GetPosition(target);
                        MainChara__2->GetPosition(chara_pos);
                        sceVu0SubVector(target, target, chara_pos);
                        angle = atan2f(target[0], target[2]);
                    }
                }

                angle += PI;

                if (angle > PI) {
                    angle -= TWO_PI;
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

    if (GamePad__2.On2(PAD_RIGHT)) {
        DngMainScene->AddTime(0.1f);
    }

    if (GamePad__2.On2(PAD_LEFT)) {
        DngMainScene->AddTime(-0.1f);
    }

    if (GamePad__2.Down2(PAD_UP)) {
        DngMainScene->SetTime(static_cast<int>(DngMainScene->time) / 2 * 2 + 2);
    }

    if (GamePad__2.Down2(PAD_DOWN)) {
        time_step = !time_step;
    }

    if (time_step) {
        DngMainScene->AddTime(0.003f);
    }

    return 0;
}

#include "common.h"

#include "charasetup.hpp"
#include "mg_memory.hpp"

// The seventh element is retail's BuffTempData, which SetupMainUnit reaches as stacks[6] by link adjacency on the PS2.
mgCMemory BaseCharacter[CHARA_MEM_STACK_NUM];
