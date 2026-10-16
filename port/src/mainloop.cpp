#include "common.h"

#include <libgraph.h>

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <optional>
#include <utility>

#include "arena_root.hpp"
#include "dataread.hpp"
#include "debug_mode.hpp"
#include "dng_main.hpp"
#include "editctrl_port.hpp"
#include "editdata.hpp"
#include "editloop.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "helpmes.hpp"
#include "inventmn.hpp"
#include "menuchr_port.hpp"
#include "quick_loadout.hpp"
#include "item_icon3d.hpp"
#include "main.hpp"
#include "mainloop.hpp"
#include "mainloop3.hpp"
#include "mainloop_port.hpp"
#include "mapjump.hpp"
#include "mapselect.hpp"
#include "menuchr_port.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_memory_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "monster.hpp"
#include "nowload.hpp"
#include "npccfg.hpp"
#include "padcontrol.hpp"
#include "platform/arena.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"
#include "play_time.hpp"
#include "save_slots.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "test_hooks.hpp"
#include "userdata.hpp"
#include "vlgr_info.hpp"

int PortVSyncCallBack(int unused) asm("MainLoop_VSyncCallBack");

bool PortAutosave = false;

namespace {

std::optional<std::pair<int, int> > autosaved_floor;
std::optional<int>                  autosaved_map;

bool AutosaveEnabled() {
    return PortAutosave && ConfigGet().autosave && PortCaptureMode == CAPTURE_OFF;
}

void WriteAutosave(int program_loop_no, AutosaveSpawn *spawn = nullptr) {
    if (!SaveSlotWriteAutosave(program_loop_no, spawn)) {
        std::fprintf(stderr, "autosave: could not write %s\n", PathsDisplay(SaveSlotAutosavePath()).c_str());
    }
}

// Once per floor, the first frame the player has control on it.
void AutosaveFloor() {
    const auto *save = GetSaveData();
    const auto *scene = GetMainScene();
    if (!save || !AutosaveEnabled() || DngStatus.mode != DNG_STATUS_FIELD || !scene || scene->event_run || GamePad__2.key_lock ||
        !BattleAreaScene || (BattleAreaScene->pause_flag & (DNG_PAUSE_PLAYER_STEP | DNG_PAUSE_FIELD_STEP)) ||
        save->save_dungeon.stage_id < 0 || save->save_dungeon.stage_id >= SAVE_DUNGEON_NUM) {
        return;
    }
    const auto &dungeon = save->save_dungeon;
    const auto  floor = std::pair{dungeon.stage_id, static_cast<int>(dungeon.floor_id[dungeon.stage_id])};
    if (floor != autosaved_floor) {
        autosaved_floor = floor;
        WriteAutosave(LOOP_DUNGEON);
    }
}

// Save on the first controllable exterior frame of each town map.
void AutosaveTown() {
    CScene *scene = GetMainScene();
    if (!GetSaveData() || !scene || IsEditMode() || PortTownLoopMode != EDIT_LOOP_WALK || PortTownControlMode != EDIT_CONTROL_PLAYER ||
        PortTownLockChara || PortTownPause || scene->event_run || GamePad__2.key_lock || SubGameRunning() || InInterior()) {
        return;
    }
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);
    mgCCamera   *camera = scene->GetCamera(scene->active_camera);
    const int    map = scene->GetNowMapNo();
    if (!chara || !camera || map < 0) {
        return;
    }
    if (auto spawn = SaveSlotTakePendingSpawn(GetSaveData()->map_no)) {
        chara->SetPosition(spawn->position);
        chara->SetRotation(spawn->rotation);
        chara->ResetDAPosition();
        chara->Step();
        chara->StepDA(10);
        camera->SetPos(spawn->camera_pos);
        camera->SetRef(spawn->camera_ref);
        autosaved_map = map;
        return;
    }
    if (AutosaveEnabled() && map != autosaved_map) {
        autosaved_map = map;
        AutosaveSpawn spawn;
        spawn.map_no = GetSaveData()->map_no;
        chara->GetPosition(spawn.position);
        chara->GetRotation(spawn.rotation);
        camera->GetPos(spawn.camera_pos);
        camera->GetRef(spawn.camera_ref);
        WriteAutosave(LOOP_EDIT, &spawn);
    }
}

} // namespace

void PortAutosaveResetArrival() {
    autosaved_floor.reset();
    autosaved_map.reset();
}

void PortAutosaveStep(int program_loop_no) {
    if (program_loop_no == LOOP_DUNGEON) {
        AutosaveFloor();
    } else if (program_loop_no == LOOP_EDIT) {
        AutosaveTown();
    }
}

extern u_long128 main_buffer[0x1A0000];
extern CScene    MainScene;
extern CFont     Font;

static constexpr int kSubGameQuads = std::max(5000, static_cast<int>((sizeof(CSubGameData) + 15) / 16));

int PortPlayTimeVSyncCallback(int) {
    if (PortPlayTimeCountFlag != 0) {
        GetSaveData()->play_time += PlayTimeTick(true);
    }
    return 0;
}

PORT_OVERRIDE void InitSaveData() {
    GetSaveData()->Initialize();
    SaveSlotSetPendingSpawn(std::nullopt);
    PlayTimeReset();
}

void PortDrawFrameBorder() {
    const auto  edge = mgPortVisibleExtent();
    mgCDrawPrim frame_border;
    frame_border.Initialize(NULL, NULL);
    frame_border.DepthTestEnable(false);
    frame_border.AlphaTestEnable(false);
    frame_border.AlphaBlendEnable(false);
    frame_border.TextureMapEnable(false);
    frame_border.ZMask(MG_Z_MASK_MASKED);
    frame_border.Begin(MG_PRIM_LINE_STRIP);
    frame_border.Color(0, 0, 0, 0x80);
    frame_border.Vertex(edge.left, edge.top, 0.0f);
    frame_border.Vertex(edge.right - 1, edge.top, 0.0f);
    frame_border.Vertex(edge.right - 1, edge.bottom - 1, 0.0f);
    frame_border.Vertex(edge.left, edge.bottom - 1, 0.0f);
    frame_border.Vertex(edge.left, edge.top, 0.0f);
    frame_border.End();
}

PORT_OVERRIDE void MainLoop() {
    static u_long128 *vu_prog[16];

    mgCMemory        *memory;
    mgCMemory        *read_memory;
    CUserDataManager *user_data;
    u_long128        *file_buffer;
    int               file_size;
    int               mode_finished;
    std::uintptr_t    buffer_address;
    std::uintptr_t    alignment;
    u_long128        *main_arena = ArenaRoot(&main_buffer, 0x1A0000, "MainBuffer");

    memory = GetMainStack();
    memory->stSetBuffer(main_arena, 0x1A0000 * kArenaHeadroom);
    memory->stack_used = 0;
    memory->lock = 0;
    SaveData.Initialize();
    PlayTimeReset();
    PortActiveSaveData = &SaveData;
    PortSubGameSaveData = NULL;
    DebugFlag = false;
    GamePad__2.Init();
    InitFileCache(NULL, 0);
    mgInit(MG_SCREEN_MODE_512X480, 3);
    PortPlayTimeCountFlag = false;
    mgInitVSyncCallBack(PortPlayTimeVSyncCallback);
    LanguageCode = GameHasJump() ? LANG_ENGLISH : LANG_FRENCH;
    if (!GameHasJump()) {
        SCElogoFade(0, memory);
    }
    PortLoopNo = LOOP_TITLE;
    DebugFlag = false;
    DebugInfo.chara_move = 0;

    static int pmeter_flag = false;

    pmeter_flag = false;
    GamePad__2.WaitEnable();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    MasterDebugCode = 0;
    DebugFlag = false;

    if (GamePad__2.On2(PAD_R1) && GamePad__2.On2(PAD_R2) && GamePad__2.On2(PAD_L1) && GamePad__2.On2(PAD_L2)) {
        MasterDebugCode = MASTER_DEBUG_CODE;
    }
    DebugModeBoot(GameDebugEnabled());

    GamePad__2.DebugKeyLock(1);
    sceGsSyncV(0);
    GamePad__2.UpDate();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    sceGsSyncV(0);
    GamePad__2.UpDate();
    mgSetUserVuProg(vu_prog, 16);
    mgSetUserVuProgAdr(0, Vu_prog_wtr);
    PortInitPadTable(LanguageCode);
    GameItemDataManage.LoadData();
    GameItemDataManage.LoadItemSystemMes(LanguageCode);
    LoadSystemMes();
    CreateSystemMes();
    LoadFontTexture();
    LoadGaijiImg();
    LoadFontTblBin();
    LoadFontTex2Img();
    LoadNPCCfg();
    InfoStack.stSetBuffer(ArenaRoot(PortInfoBuff, 5000, "InfoStack"), 5000 * kArenaHeadroom);
    LoadGameInfo(&InfoStack);
    InitPauseData();
    InitSaveData();
    user_data = NULL;

    if (PortActiveSaveData != NULL) {
        user_data = &PortActiveSaveData->user_data;
    }

    LoadMonsterLanguage(LanguageCode);
    PortInitPadTable(LanguageCode);
    LanguageEquipChange();
    DebugGetItem(user_data, 0);
    PortCaptureMode = CAPTURE_OFF;
    sndInitMngr();
    MainScene.InitSnd();
    SetCurrentDir(NULL);
    SystemSeStack.stSetBuffer(ArenaRoot(PortSystemSeBuff, 400, "SystemSeStack"), 400 * kArenaHeadroom);
    SystemSeStack.stack_used = 0;
    SystemSeStack.lock = 0;
    read_memory = GetMainStack();
    buffer_address = reinterpret_cast<std::uintptr_t>(read_memory->stack + read_memory->stack_used);
    alignment = buffer_address % 64;

    if (alignment != 0) {
        buffer_address += ((64 - alignment) / 16) * 16;
    }

    file_buffer = reinterpret_cast<u_long128 *>(buffer_address);
    SystemSND_ID = -1;

    char sy_path[] = "snd2/sy_000.sound.json";
    char rev_path[] = "snd2/rev.json";
    char map_index_path[] = "snd2/map_index.json";

    if (LoadFile2(sy_path, file_buffer, NULL, 0)) {
        SystemSND_ID = sndLoadSound(SND_PORT_SYSTEM, (u_int *) file_buffer, &SystemSeStack);
    }

    if (LoadFile2(rev_path, file_buffer, &file_size, 0)) {
        MainScene.LoadSndRevInfo((char *) file_buffer, file_size);
    }

    if (LoadFile2(map_index_path, file_buffer, &file_size, 0)) {
        MainScene.LoadSndFileInfo((char *) file_buffer, file_size);
    }

    LoadHelpMes(file_buffer);
    LoadMapName(LanguageCode, file_buffer);
    LoadEditAnalyzeData(LanguageCode, file_buffer);
    LoadFilePictureName();
    Font.Init();
    Font.Preset(FONT_PRESET_SHADOWED);
    Font.SetFuchi(0);
    Font.SetClearance(15, 18);
    CreateGamePadThread(&GamePad__2);
    LoadGameConfig(NULL);
    SetIoErrCallBack(EmergencyMessage);
    if (!GameHasJump()) {
        SCElogoFade(1, memory);
    }
    GamePrepareJump(PortLoopNo, InitArg);

    while (1) {
        if (PortLoopNo == LOOP_TITLE || OmakeFlag != 0) {
            PortSubGameSaveData = (CSubGameData *) main_arena;
            memory->stSetBuffer(&main_arena[kSubGameQuads], 0x1A0000 * kArenaHeadroom - kSubGameQuads);
            memory->stack_used = 0;
            memory->lock = 0;
        }

        printf("main_data remain = %dkb\n", ((memory->stack_size - memory->stack_used) * 16) / 1024);

        if (PortLoopNo < 0 || PortLoopNo >= LOOP_MODE_NUM) {
            break;
        }

        if (DebugFlag == 0 && PortLoopNo == LOOP_MENU) {
            PortLoopNo = LOOP_TITLE;
        }

        if (PortCaptureMode == CAPTURE_RECORD) {
            GamePad__2.CaptureStart();
            srand(9999);
        }

        if (PortCaptureMode == CAPTURE_PLAY || PortCaptureMode == CAPTURE_PLAY_SCREEN) {
            if (PortCaptureMode != CAPTURE_OFF) {
                GamePad__2.LoadCapture();
            }

            GamePad__2.CapturePlay();
            srand(9999);
        }

        mgFrameRate = 2;
        PortCaptureScreen = false;
        GetMainScene()->save_data = GetSaveData();
        float now_time = GetSaveData()->now_time;
        GetMainScene()->SetTime(now_time);
        GetMainScene()->day = GetSaveData()->day;

        if (GetSaveData()->game_progress == 2) {
            CSaveData *save = GetSaveData();
            save->now_time = 22.0f;
            GetMainScene()->SetTime(22.0f);
            GetMainScene()->time_step = 0;
        }

        if (PortLoopNo == LOOP_TITLE) {
            sndSeAllStop(-1);
            sndDeletePort(SND_PORT_BGM);
            MainScene.InitSnd();
        }

        printf("##### %d\n", mgGetVSyncCount());
        // Single entry for every mode change: covers the LOOP_MENU->LOOP_TITLE redirect above and the PortNextLoopNo hand-off below.
        mgPortCutInterpolation();
        PortCancelQuickChangeBanner();
        PortQuickLoadoutReset();
        ItemIcons3DReset();
        LoopInit[PortLoopNo](InitArg);
        GameGiveOnArrival(PortLoopNo);
        PortAutosaveResetArrival();
        INIT_LOOP_ARG next_arg;

        NextLoop(LOOP_MENU, next_arg);

        bool developer_menu_requested = false;
        auto request_developer_menu = [&]() {
            if (!GameDeveloperMenuRequested(PortLoopNo)) {
                return false;
            }
            developer_menu_requested = true;
            PauseEnd();
            PauseCancel();
            return true;
        };

        while (1) {
            request_developer_menu();
            if (developer_menu_requested) {
                DebugFlag = 1;
                GamePad__2.KeyLock(0);
                if (PortLoopNo == LOOP_EDIT) {
                    PreExitLoop(GetMainScene());
                } else if (PortLoopNo == LOOP_DUNGEON || PortLoopNo == LOOP_TITLE) {
                    // These loops own cleanup that their LoopExit callbacks do not perform.
                    const int buttons = GamePad__2.pad[0].button;
                    GamePad__2.pad[0].button = PAD_START | PAD_SELECT;
                    if (PortLoopNo == LOOP_DUNGEON) {
                        DngStatus.mode = DNG_STATUS_EXIT;
                    }
                    mgBeginFrame(NULL);
                    LoopMain[PortLoopNo]();
                    mgEndFrame(NULL);
                    GamePad__2.pad[0].button = buttons;
                }
                PauseCancel();
                INIT_LOOP_ARG menu_arg;
                NextLoop(LOOP_MENU, menu_arg);
                break;
            }
            if (GamePad__2.On(PAD_CIRCLE)) {
                cat_start();
            }

            if (PortLoopNo != LOOP_MENU) {
                GetMainScene()->save_data = GetSaveData();
                float now_time = GetSaveData()->now_time;
                GetMainScene()->SetTime(now_time);
                GetMainScene()->day = GetSaveData()->day;

                if (GetSaveData()->game_progress == 2) {
                    CSaveData *save = GetSaveData();
                    save->now_time = 22.0f;
                    GetMainScene()->SetTime(22.0f);
                    GetMainScene()->time_step = 0;
                }
            }

            SV_CONFIG_OPTION *config = &GetSaveData()->config;
            GamePad__2.VibrationEnable(!config->vibration);

            if (GamePad__2.Down2(PAD_L1)) {
                pmeter_flag = !pmeter_flag;
            }

            mgPerformanceMeter(pmeter_flag);

            if (GamePad__2.Down2(PAD_CIRCLE) ||
                (GameDebugEnabled() && DebugModeToggleChord(GamePad__2.GetPadOn(), GamePad__2.GetPadDown()))) {
                DebugFlag = !DebugFlag;
            }

            mgBeginFrame(NULL);
            mode_finished = LoopMain[PortLoopNo]();
            sndStep(mgGetNowFrameRate());
            MainScene.StepSnd();
            GamePad__2.UpDate();
            PortQuickLoadoutPad();
            PadCtrl.Update(&GamePad__2);
            PortStepQuickChangeEffect();
            PortDrawQuickChangeBanner();
            PortDrawFrameBorder();
            mgEndFrame(NULL);

            if (mode_finished != 0) {
                PauseCancel();
                break;
            }
            PortAutosaveStep(PortLoopNo);

            if (GamePad__2.On(PAD_CIRCLE)) {
                cat_end();
            }

            switch (PortLoopNo) {
                case LOOP_EDIT:
                case LOOP_DUNGEON:
                case LOOP_TITLE: {
                    static int pause = false;

                    if (GameDebugPauseRequested(GamePad__2)) {
                        pause = true;
                    }

                    while (pause != 0) {
                        sceGsSyncV(0);
                        GamePad__2.UpDate();

                        // Modified Start is reserved for frame capture while paused.
                        if (!GamePad__2.On2(PAD_START) && request_developer_menu()) {
                            pause = false;
                            break;
                        }

                        if (GameDebugPauseResumeRequested(GamePad__2)) {
                            pause = false;
                            break;
                        }

                        if (GamePad__2.Down2(PAD_START)) {
                            mgStoreFrameImage();
                        }

                        if (GamePad__2.Down(PAD_RIGHT | PAD_CIRCLE) || GamePad__2.Down2(PAD_RIGHT)) {
                            break;
                        }
                    }

                    break;
                }
            }

            while (!developer_menu_requested && PauseLoop() != 0) {
                request_developer_menu();
            }

            PauseCount();
        }

        LoopExit[PortLoopNo]();
        MemoryLogPeaks();

        if (PortLoopNo != LOOP_MENU) {
            if (PortCaptureMode != CAPTURE_OFF) {
                GamePad__2.SaveCapture();
            }

            PortCaptureMode = CAPTURE_OFF;
        }

        PortPrevLoopNo = PortLoopNo;
        PrevInitArg = InitArg;
        PortLoopNo = PortNextLoopNo;
        InitArg = NextInitArg;
        GamePad__2.CaptureEnd();
        sceGsSyncV(0);
        GamePad__2.UpDate();
        sceGsSyncV(0);
        GamePad__2.UpDate();

        while (sceGsSyncV(0) != 0) {
        }
    }

    sndSeAllStop(-1);
    sndStopVoice(0);
    sndStopVoice(1);
    sceGsSyncV(0);
    sndStep(2.0f);
    sceGsSyncV(0);
    sndStep(2.0f);
    GamePad__2.Close();
}
