#include "common.h"

#include <cstdio>
#include <cstring>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "dbg_font.hpp"
#include "dng_effect.hpp"
#include "editanalyze.hpp"
#include "editctrl.hpp"
#include "editdata.hpp"
#include "editdebug.hpp"
#include "editevent.hpp"
#include "editexception.hpp"
#include "editloop.hpp"
#include "editmap.hpp"
#include "editmenu.hpp"
#include "editmode.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "eventedit.hpp"
#include "gamepad.hpp"
#include "helpmes.hpp"
#include "main.hpp"
#include "mainloop.hpp"
#include "mapjump.hpp"
#include "mapselect.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "nowload.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "sound.hpp"
#include "sphida.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#include "vlgr_info.hpp"
#include "wavetable.hpp"

#include "stubs/editloop.hpp"

void EditModeChgStep(CScene *scene);
int SubMapLoadStep();
void PreExitLoop(CScene *scene);
void ResetEditEvent();
void RestartEditEvent();
int NowEditModeChg();
void EditModeChg(int event);
static const int kEventDataCallFlag = 8;
static const int kKeyOpenEvent = 0x96;

PORT_OVERRIDE int EditLoop() {
    static int       old_cm;
    CMap            *map;
    CCharacter2     *chara;
    CCameraControl  *camera;
    CCameraControl  *walk_camera;
    CameraCtrlParam *camera_param;
    CameraCtrlParam *default_param;
    SubGameInfo     *current_subgame;
    sceVu0FVECTOR    position;
    sceVu0FVECTOR    ground_position;
    sceVu0FVECTOR    closest;
    sceVu0FVECTOR    line_start;
    sceVu0FVECTOR    line_end;
    char            *map_name;
    float            time_rate;
    float            projection;
    float            distance;
    float            camera_angle;
    int              game_progress;
    int              light_check;
    int              light_band;
    int              finish;
    int              wait_for_map;
    int              next_sub_map;
    int              open_menu;
    int              menu_mode;
    int              change_mode;
    int              return_to_player;
    int              start_event;
    int              pause_enabled;
    int              event_result;
    int              reset_event;
    int              menu_requested;
    int              menu_button;
    int              quick_change;
    int              next_chara;
    int              menu_enabled;
    int              debug_closed;
    int              debug_move;
    int              edit_enabled;
    int              main_map_no;
    int              change_event;
    int              pause_result;
    finish = 0;
    mgSetAllScissorFlag(0);
    LoopCounter++;

    if (LoopCounter > 10000) {
        LoopCounter = 10000;
    }

    /**
     *
     * Whether automatic town time progression is enabled.
     *
     */
    static int time_step = 1;
    /**
     *
     * Frames remaining to display the time-progression toggle.
     *
     */
    static int show_time_step = 0;

    if (PauseFlag == 0 && IsLightingEditMode() == 0) {
        CMap *time_map = MainScene->GetMap(MainScene->active_map);

        if (time_map != NULL) {
            light_check = 1;
            time_map->now_time = MainScene->time;
            light_band = time_map->GetNowTimeLightBand();

            if (GamePad__2.On2(PAD_RIGHT) != 0) {
                MainScene->AddTime(0.1f);
            }

            if (GamePad__2.On2(PAD_LEFT) != 0) {
                MainScene->AddTime(-0.1f);
            }

            if (GamePad__2.Down2(PAD_UP) != 0) {
                MainScene->SetTime(((int) MainScene->time / 2) * 2 + 2);
            }

            if (GamePad__2.Down2(PAD_DOWN) != 0) {
                time_step = !time_step;
                show_time_step = 30;
            }

            if (LoopMode == EDIT_LOOP_WAIT_READ) {
                if (ReadBGSync() == 0) {
                    LoopMode = EDIT_LOOP_WALK;
                }
            } else if (GetSaveData()->time_stop == 0 && time_step != 0 &&
                       ControlMode == EDIT_CONTROL_PLAYER && LoopMode == EDIT_LOOP_WALK) {
                time_rate = 1.0f;
                light_check = 1;

                if (GetSaveData() != NULL && GetSaveData()->GetConfig()->fast_time != 0) {
                    time_rate = 1.5f;
                }

                MainScene->TimeStep(time_rate);
            }

            time_map->now_time = MainScene->time;

            if (light_check != 0 && light_band != time_map->GetNowTimeLightBand() && time_map->map_info.time_cfade != 0) {
                MainScene->fade.CaptureScreen();
                MainScene->fade.CrossFade(10, 0.8f);
            }
        }
    }

    wait_for_map = 0;

    if (PadCtrl.Btn(PAD_BTN_CONFIRM) != 0 || PadCtrl.Btn(PAD_BTN_MENU) != 0) {
        wait_for_map = 1;
    }

    map_name = MainScene->GetMapName(MainScene->active_map);

    while (LoopCounter > 2 && LoopMode == EDIT_LOOP_WALK && map_name != NULL && strcmp(map_name, "m01") == 0) {
        chara = MainScene->GetCharacter(MainScene->player_chara);

        if (chara != NULL) {
            chara->GetPosition(position);
            *(u_long128 *) ground_position = *(u_long128 *) position;
            ground_position[1] = 0.0f;
            line_end[3] = 1.0f;
            line_start[3] = 1.0f;
            sceVu0FVECTOR load_position = {1400.0f, -6.0f, -218.0f, 1.0f};
            next_sub_map = -1;

            if (MainScene->LoadMapBGStep(NULL) == 0) {
                line_start[0] = 1900.0f;
                line_start[1] = 0.0f;
                line_start[2] = 1200.0f;
                line_end[0] = 1900.0f;
                line_end[1] = 0.0f;
                line_end[2] = 1700.0f;

                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }

                line_start[0] = 1713.0f;
                line_start[1] = 0.0f;
                line_start[2] = -302.0f;
                line_end[0] = 1423.0f;
                line_end[1] = 0.0f;
                line_end[2] = -487.0f;

                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }

                line_start[0] = -1380.0f;
                line_start[1] = 0.0f;
                line_start[2] = 151.0f;
                line_end[0] = -1380.0f;
                line_end[1] = 0.0f;
                line_end[2] = 444.0f;

                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }

                line_start[0] = -3283.0f;
                line_start[1] = 0.0f;
                line_start[2] = 1362.0f;
                line_end[0] = -2996.0f;
                line_end[1] = 0.0f;
                line_end[2] = 1616.0f;

                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }

                line_start[0] = -2218.0f;
                line_start[1] = 0.0f;
                line_start[2] = 628.0f;
                line_end[0] = -2041.0f;
                line_end[1] = 0.0f;
                line_end[2] = 660.0f;

                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }
            }

            line_start[0] = 1340.0f;
            line_start[1] = 0.0f;
            line_start[2] = 79.0f;
            line_end[0] = 1125.0f;
            line_end[1] = 0.0f;
            line_end[2] = -245.0f;

            if (now_load_map_no != 11 &&
                mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f && MainScene->GetMapID("m02") != 1) {
                next_sub_map = 11;
            }

            line_start[0] = 1500.0f;
            line_start[1] = 0.0f;
            line_start[2] = 1600.0f;
            line_end[0] = 1500.0f;
            line_end[1] = 0.0f;
            line_end[2] = 1100.0f;

            if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 40.0f) {
                if (GetSquareEvent() != 0) {
                    if (ground_position[0] >= 1500.0f && CharaOldPos[0] < 1500.0f) {
                        MainScene->RunEvent(201, NULL);

                        if (SubGameRunning() != 0 && GetSubGameNo() == SUBGAME_FISHING) {
                            sgExitSubGame();
                        }
                    }
                } else if (now_load_map_no != 12 && MainScene->GetMapID("m03") != 1) {
                    next_sub_map = 12;
                }
            }

            game_progress = GetSaveData()->game_progress;

            if (game_progress != 2 && game_progress != 3) {
                line_start[0] = -520.0f;
                line_start[1] = 0.0f;
                line_start[2] = 243.0f;
                line_end[0] = -608.0f;
                line_end[1] = 0.0f;
                line_end[2] = -187.0f;

                if (now_load_map_no != 13 &&
                    mgDistLinePoint(ground_position, line_start, line_end, closest) < 50.0f && MainScene->GetMapID("m04") != 1) {
                    next_sub_map = 13;
                }
            }

            load_position[0] = -2259.0f;
            load_position[1] = 185.0f;
            load_position[2] = 851.0f;

            if (now_load_map_no != 13 && mgDistVectorXZ(position, load_position) < 150.0f && MainScene->GetMapID("m04") != 1) {
                next_sub_map = 13;
            }

            load_position[0] = -2700.0f;
            load_position[1] = 256.0f;
            load_position[2] = 1207.0f;

            if (now_load_map_no != 14 && mgDistVectorXZ(position, load_position) < 150.0f && MainScene->GetMapID("m05") != 1) {
                next_sub_map = 14;
            }

            line_start[0] = -2157.0f;
            line_start[1] = 0.0f;
            line_start[2] = 756.0f;
            line_end[0] = -3037.0f;
            line_end[1] = 0.0f;
            line_end[2] = 1531.0f;
            distance = mgDistLinePoint(ground_position, line_start, line_end, closest);
            camera = (CCameraControl *) MainScene->GetCamera(MainScene->active_camera);
            camera_param = camera->GetActiveParam();
            default_param = &camera->default_param;

            if (distance < 220.0f) {
                CancelEyeViewMode();
                camera_param->min_height += (100.0f - camera_param->min_height) / 8.0f;
                camera_param->max_height = camera_param->min_height;
            } else {
                camera_param->min_height += (default_param->min_height - camera_param->min_height) / 8.0f;
                camera_param->max_height += (default_param->max_height - camera_param->max_height) / 8.0f;
            }

            *(u_long128 *) CharaOldPos = *(u_long128 *) position;

            if (next_sub_map > 0) {
                now_load_map_no = next_sub_map;
                LoadSubMap(MainScene, next_sub_map, 1);
                MainScene->PreLoadVillager(next_sub_map, read_buffer_end);
                SubMapLoadBG = 1;
            }
        }

        break;
    }

    if (SubMapLoadStep() != 0) {
        while (wait_for_map != 0 && SubMapLoadStep() != 0) {
        }
    }

    if (LoopMode == EDIT_LOOP_WALK_MENU || LoopMode == EDIT_LOOP_EDIT_MENU) {
        PAUSE_INFO menu_pause;
        menu_pause.scene = NULL;
        menu_pause.scene = MainScene;
        menu_pause.event_skip = 0;

        if (PadCtrl.Btn(PAD_BTN_PAUSE) != 0) {
            PauseStart(&menu_pause);
        }

        if (MenuMainLoop() != 0) {
            MenuMainExit();

            if (LoopMode == EDIT_LOOP_WALK_MENU) {
                LoopMode = EDIT_LOOP_WALK;

                if (MenuInfo->end_code != MENU_END_FISHING && SubGameRunning() != 0 && GetSubGameNo() == SUBGAME_FISHING) {
                    sgExitSubGame();
                }

                int end_code = MenuInfo->end_code;

                if (end_code == MENU_END_CHARA_CHANGE_FADE || end_code == MENU_END_CHARA_CHANGE) {
                    if (end_code == MENU_END_CHARA_CHANGE_FADE) {
                        MainScene->fade.CaptureScreen();
                        MainScene->fade.CrossFade(20, 1.0f);
                    }

                    ActiveCharaNo = MenuInfo->result[0];
                    ActiveCharaNo = GetUserData()->active_chr_no;
                    chara = MainScene->GetCharacter(MainScene->player_chara);

                    if (chara != NULL) {
                        chara->UpdatePosition();
                        chara->ResetDAPosition();
                    }

                    EditControlStatusInit(MainScene);
                } else if (end_code == MENU_END_FISHING) {
                    SubGameInfo fishing;
                    fishing.scene = MainScene;
                    fishing.rod_no = MenuInfo->result[0];
                    fishing.esa_no = MenuInfo->result[1];
                    const int &fishing_size = CharaBufs[0].stack_size - CharaBufs[0].stack_used;
                    FishingBuff.stSetBuffer(CharaBufs[0].stack + CharaBufs[0].stack_used, fishing_size);
                    fishing.menu_buff = &MenuBuffer__2;
                    fishing.load_buff = &FishingBuff;
                    MenuInfo->end_code = MENU_END_NONE;
                    current_subgame = GetNowSubGameInfo();

                    if (SubGameRunning() != 0 && current_subgame->rod_no != fishing.rod_no) {
                        fishing.keep_bgm = 1;
                    }

                    if ((GetMenuEtcFlag() & MENU_ETC_FLAG_CHARA_RELOAD) != 0 || SubGameRunning() == 0 || current_subgame->rod_no != fishing.rod_no) {
                        ResetViewMode(MainScene);
                        sgInitSubGame(SUBGAME_FISHING, &fishing);
                    } else {
                        sgRestartSubGame(&fishing);
                    }
                } else if (end_code == MENU_END_WORLD_MOVE) {
                    SetEventScript(NULL, NULL, NULL);

                    if (ControlMode == EDIT_CONTROL_EVENT) {
                        MainScene->active_camera = MainScene->before_camera;
                        ControlMode = EDIT_CONTROL_PLAYER;
                    }

                    if (MenuInfo->result[0] != LOOP_EDIT) {
                        finish = 1;
                        INIT_LOOP_ARG next_loop;
                        next_loop.floor_no = MenuInfo->result[2];
                        next_loop.map_no = MenuInfo->result[1];
                        next_loop.event_no = 1010;
                        NextLoop(MenuInfo->result[0], next_loop);
                    } else {
                        BurnEditParts();
                        EditMapJump(MenuInfo->result[1]);
                        MainScene->RunEvent(100, NULL);
                    }
                }
            } else if (LoopMode == EDIT_LOOP_EDIT_MENU) {
                MainScene->GetMap(MainScene->active_map);
                MainScene->GetCharacter(MainScene->player_chara);
                LoopMode = EDIT_LOOP_EDIT;
                MainScene->before_camera = MainScene->active_camera;
                MainScene->active_camera = 3;
                StartEditModeFromMenu(MainScene, MenuInfo->end_code, MenuInfo->result);
            }
        }

        FadeOutForE3();
        MainScene->fade.FadeStep();
        MainScene->fade.Draw();

        if (finish != 0) {
            PreExitLoop(MainScene);
            return 1;
        }

        return TimeLimitCheck() != 0;
    }

    if (DebugFlag != 0 && EdDebugInfo.jump_map_no >= 0) {
        BurnEditParts();
        EditMapJump(EdDebugInfo.jump_map_no);
        MainScene->RunEvent(100, NULL);
        EdDebugInfo.jump_map_no = -1;
        return 0;
    }

    mgPlightEnable(0);
    MainScene->UpDateMapInfo();
    projection = mgGetProjection() + PhotoAddProjection();

    if (strcmp(MainScene->GetMapName(MainScene->active_map), "s32") == 0 ||
        strcmp(MainScene->GetMapName(MainScene->active_map), "s55") == 0) {
        projection = 250.0f;
    }

    if (projection < 300.0f) {
        projection = 300.0f;
    }

    if (projection > 1000.0f) {
        projection = 1000.0f;
    }

    mgSetRenderInfo(projection, 3.0f, 30000.0f);
    S51Thunder(MainScene);
    menu_mode = LoopMode;
    open_menu = 0;
    change_mode = 0;
    return_to_player = 0;
    start_event = -1;
    PAUSE_INFO pause;
    pause.scene = NULL;
    pause.event_skip = 0;
    pause.scene = MainScene;
    pause_enabled = 0;

    if (PauseFlag == 0) {
        switch (ControlMode) {
            case EDIT_CONTROL_PLAYER:
                pause_enabled = 1;
                pause.event_skip = 0;

                if (SubGameRunning() != 0) {
                    sgLoopSubGame();
                } else {
                    if (LockChara == 0 && IsEditMode() != 0) {
                        EditMode(MainScene);
                        GamePad__2.SetAutoRepeat2(PAD_L2 | PAD_R2, 13, 2);
                        GamePad__2.SetAutoRepeat2(PAD_UP | PAD_RIGHT | PAD_DOWN | PAD_LEFT, 13, 2);
                    }

                    event_result = EditEvent.Step(MainScene);
                    CSceneEventData event_data;
                    reset_event = 0;

                    switch (event_result) {
                        case EDIT_EVENT_RESULT_CONTINUE:
                            break;
                        case EDIT_EVENT_RESULT_END:
                            reset_event = 1;
                            EditDataSave();
                            break;
                        case EDIT_EVENT_RESULT_ENTER:
                        case EDIT_EVENT_RESULT_ENTER_HOUSE:
                            reset_event = 1;
                            event_data = EditEvent.data;
                            EditGotoInterior(SearchMapNo(EditEvent.map_name), event_result == EDIT_EVENT_RESULT_ENTER_HOUSE);
                            MainScene->RunEvent(100, &event_data);
                            break;
                        case EDIT_EVENT_RESULT_EXIT:
                            reset_event = 1;
                            event_data = EditEvent.data;
                            EditExitInterior(0);
                            MainScene->RunEvent(100, &event_data);
                            break;
                        case EDIT_EVENT_RESULT_MENU:
                            open_menu = 1;
                            menu_mode = EDIT_LOOP_WALK_MENU;
                            break;
                    }

                    if (reset_event != 0) {
                        EditEvent.Reset();
                        UnLockCharaCtrl();
                    }

                    if (LoopMode == EDIT_LOOP_WALK) {
                        if (LockChara == 0) {
                            EditControl(MainScene, &PadCtrl);
                        } else {
                            EditControl(MainScene, NULL);
                        }

                        GamePad__2.AutoRepeatOff();
                        MainScene->EyeViewDrawOnOff(!IsWalkMode());

                        if (LockChara == 0 && MainScene->event_run == 0 && PadCtrl.Btn(PAD_BTN_CONFIRM) != 0 && IsWalkMode() != 0) {
                            sceVu0FVECTOR talk_position;
                            sceVu0FVECTOR talk_height;
                            chara = MainScene->GetCharacter(MainScene->player_chara);
                            chara->GetPosition(talk_position);
                            chara->GetPosition(talk_height);
                            talk_position[3] = talk_height[1];
                            CSceneEventData talk_event;

                            if (MainScene->GetTalkEvent(talk_position, &talk_event) != 0) {
                                MainScene->RunEvent(1000, &talk_event);
                                printf("chara No = %d\n", talk_event.chara_no);
                            }
                        }
                    }
                }

                break;
            case EDIT_CONTROL_EVENT:
                pause.event_skip = 1;

                if (!CheckEventSkip()) {
                    pause.event_skip = 0;
                }

                pause_enabled = 1;

                switch (EventLoop()) {
                    case EVENT_REQUEST_EDIT_MODE:
                        change_mode = 1;
                        return_to_player = 1;
                        break;
                    case EVENT_REQUEST_RESET_EDIT:
                        ResetEditEvent();
                        return_to_player = 1;
                        break;
                    case EVENT_REQUEST_RESTART_EDIT:
                        RestartEditEvent();
                        return_to_player = 1;
                        break;
                    case EVENT_REQUEST_END:
                        return_to_player = 1;
                        break;
                    case EVENT_REQUEST_SUB_MODE:
                        menu_mode = EDIT_LOOP_WALK_MENU;
                        open_menu = 1;
                        break;
                    case EVENT_REQUEST_GOTO:
                        finish = 1;
                        break;
                    case EVENT_REQUEST_MAP_JUMP:
                        BurnEditParts();
                        EditMapJump(SearchMapNo(EdEventInfo.jump_map_name));
                        start_event = EdEventInfo.event_no;

                        if (start_event < 0) {
                            start_event = 100;
                        }

                        printf("start_event = %d\n", start_event);
                        EdEventInfo.event_no = -1;
                        break;
                    case EVENT_REQUEST_INTERIOR:
                        EditGotoInterior(SearchMapNo(EdEventInfo.jump_map_name), EdEventInfo.interior_entrance);
                        start_event = EdEventInfo.event_no;

                        if (start_event < 0) {
                            start_event = 100;
                        }

                        printf("start_event = %d\n", start_event);
                        EdEventInfo.event_no = -1;
                        break;
                    case EVENT_REQUEST_OUTSIDE:
                        EditExitInterior(0);
                        start_event = EdEventInfo.event_no;

                        if (start_event < 0) {
                            start_event = 100;
                        }

                        printf("start_event = %d\n", start_event);
                        EdEventInfo.event_no = -1;
                        break;
                    default:
                        if (DebugFlag != 0 && ChkEventEditStart() != 0) {
                            ControlMode = EDIT_CONTROL_EVENT_EDIT;
                        }

                        break;
                }

                if (return_to_player != 0) {
                    ControlMode = EDIT_CONTROL_PLAYER;
                    MainScene->active_camera = MainScene->before_camera;
                }

                if (start_event > 0) {
                    MainScene->RunEvent(start_event, NULL);
                }

                break;
            case EDIT_CONTROL_EVENT_EDIT:
                if (EventEdit(&WorkBuffer) == 0) {
                    ControlMode = EDIT_CONTROL_EVENT;
                }

                break;
        }

        if (pause_enabled != 0 && (PadCtrl.Btn(PAD_BTN_PAUSE) != 0 || GamePad__2.Connect() == 0)) {
            PauseStart(&pause);
        }

        CCharacter2 *const walk_chara = MainScene->GetCharacter(MainScene->player_chara);
        WalkChara = walk_chara;

        if (walk_chara != NULL) {
            walk_chara->sound_info.foot_se_bank = MainScene->se_base_id;
        }

        EditStep();
        int           stay[32];
        sceVu0FVECTOR villager_position;

        if (WalkChara != NULL) {
            WalkChara->GetPosition(villager_position);
            villager_position[3] = 30.0f;
            MainScene->StayNearVillager(villager_position, stay);
        }

        if (LoopMode == EDIT_LOOP_WALK) {
            MainScene->StepVillager();
        }

        MainScene->CancelStayVillager(stay);
        sgLoopSubGame2();

        if (open_menu == 0 && LockChara == 0 && sgMenuOpenEnable() != 0 && change_mode == 0) {
            menu_requested = PadCtrl.Btn(PAD_BTN_MENU) != 0 || sgGetItemOver() != 0;
            menu_button = PadCtrl.Btn(PAD_BTN_MENU);
            quick_change = EditOnGround() != 0 && PadCtrl.Btn(PAD_BTN_QUICK_CHANGE) != 0 && !SubGameRunning();
            CScene *const fade_scene = MainScene;
            int           cross_fading = fade_scene->fade.NowFade() && fade_scene->fade.cross;

            if (cross_fading) {
                quick_change = 0;
            }

            next_chara = !GetUserData()->active_chr_no;

            if ((GetUserData()->CheckQuickChange(next_chara, NULL) & 0x1) == 0) {
                quick_change = 0;
            }

            if (IsWalkMode() == 0 || GetPauseFlag() != 0) {
                quick_change = 0;
            }

            menu_enabled = 1;

            if (LoopMode != EDIT_LOOP_EDIT && SubGameRunning() == 0 && EditOnGround() == 0) {
                menu_enabled = 0;
            }

            if (menu_enabled != 0 && LoopCounter > 2 && ControlMode == EDIT_CONTROL_PLAYER &&
                (menu_requested != 0 || quick_change != 0 || menu_button != 0)) {
                ShowOffOnceHelpMes();

                if (LoopMode == EDIT_LOOP_WALK) {
                    if (menu_requested != 0) {
                        if (NowTakePhoto() != 0) {
                            if (IsEnablePhotoMenu() != 0) {
                                MenuInfo->open_type = MENU_OPEN_INVENT;
                                HidePhoto();
                                menu_mode = EDIT_LOOP_WALK_MENU;
                                open_menu = 1;
                            }
                        } else {
                            menu_mode = EDIT_LOOP_WALK_MENU;
                            open_menu = 1;
                            MenuInfo->open_type = MENU_OPEN_MAIN_TOWN;
                        }
                    } else {
                        open_menu = 1;
                        menu_mode = EDIT_LOOP_WALK_MENU;
                        MenuInfo->open_type = MENU_OPEN_MAIN_CHARA_BG;
                        MenuInfo->param[0] = next_chara;
                    }
                } else if (LoopMode == EDIT_LOOP_EDIT && menu_button != 0) {
                    EditDataSave();
                    LoopMode = EDIT_LOOP_EDIT_PRE_MENU;
                    MenuInfo->open_type = MENU_OPEN_GEORAMA;
                    PreEditMenuCnt = 0;
                    EditModeControlLock();

                    if (menu_button != 0) {
                        MenuInfo->param[0] = -1;
                    } else {
                        EditPreMenuAnime(25);
                        MenuInfo->param[0] = GetSelPartsInfoID();
                    }
                }
            }
        }

        if (open_menu != 0) {
            EditDrawFlag |= 0x1;
        }
    }

    mgFlushRenderInfo();
    EditEvent.Draw(MainScene);
    EditDraw();
    debug_closed = 0;

    if (DebugFlag != 0) {
        if (EditDebugMode() != 0 && EditDebugLoop(MainScene, &EdDebugInfo) != 0) {
            ControlMode = old_cm;

            if (ControlMode == EDIT_CONTROL_DEBUG) {
                ControlMode = EDIT_CONTROL_PLAYER;
            }

            debug_closed = 1;
        }

        if (ControlMode != EDIT_CONTROL_DEBUG && GamePad__2.Down(PAD_R3) != 0 && debug_closed == 0) {
            EditDebugStart(215, &MenuBuffer__2);
            old_cm = ControlMode;
            ControlMode = EDIT_CONTROL_DEBUG;
        }

        LightingEdit(MainScene);
    }

    if (PauseFlag == 0) {
        if (LockChara == 0 && NowEditModeChg() == 0) {
            edit_enabled = 1;
            debug_move = DebugInfo.chara_move > 0;
            chara = MainScene->GetCharacter(MainScene->player_chara);

            if (debug_move == 0) {
                if ((GetSaveData()->GetBitCtrl() & MENU_DEBUG_BIT_CTRL_NO_GEORAMA) != 0) {
                    edit_enabled = 0;
                }

                main_map_no = MainScene->GetMainMapNo();

                if (main_map_no < 0 || main_map_no >= 5) {
                    edit_enabled = 0;
                }
            }

            if (PadCtrl.Btn(PAD_BTN_EDIT_SWITCH) != 0) {
                change_mode = 1;
            }

            if (open_menu != 0) {
                change_mode = 0;
            }

            if (SubGameRunning() != 0) {
                change_mode = 0;
            }

            if (edit_enabled != 0 && chara != NULL && ControlMode == EDIT_CONTROL_PLAYER && change_mode != 0) {
                sceVu0FVECTOR edit_position;
                sceVu0FVECTOR return_position;
                chara->GetPosition(edit_position);

                if (LoopMode == EDIT_LOOP_WALK) {
                    if (CheckWalkToEdit(MainScene, edit_position) != 0 || debug_move != 0) {
                        open_menu = 0;
                        ResetViewMode(MainScene);
                        MainScene->before_camera = MainScene->active_camera;
                        MainScene->active_camera = 3;
                        StartEditMode(MainScene);
                        LoopMode = EDIT_LOOP_EDIT;
                        KeepEditAnalyze();
                        chara->SetMotion("\x97\xA7\x82\xBF", 0);
                        MainScene->map_event_no = 0;
                    }
                } else if (LoopMode == EDIT_LOOP_EDIT && (CheckEditToWalk(MainScene, return_position) != 0 || debug_move != 0)) {
                    sceVu0FVECTOR camera_position;
                    sceVu0FVECTOR camera_reference;
                    LoopMode = EDIT_LOOP_WALK;
                    open_menu = 0;
                    EndEditMode(MainScene, return_position);
                    EditControlStatusInit(MainScene);
                    camera = (CCameraControl *) MainScene->GetCamera(MainScene->active_camera);
                    camera_angle = 0.0f;

                    if (camera != NULL) {
                        camera_angle = camera->GetAngle();
                        camera->GetPos(camera_position);
                        camera->GetRef(camera_reference);
                    }

                    walk_camera = (CCameraControl *) MainScene->GetCamera(0);

                    if (walk_camera != NULL) {
                        walk_camera->FollowOff();
                        walk_camera->SetRef(camera_reference);
                        camera_position[1] += 0.1f;
                        walk_camera->SetPos(camera_position);
                        walk_camera->SetAngle(camera_angle);
                        walk_camera->Step(-1);
                        walk_camera->FollowOn();
                    }

                    MainScene->active_camera = 0;
                    EditDataSave();
                    GeoUpdateNpcPos(MainScene);

                    if (GetGameChapter(GetSaveData()->game_progress) < 8) {
                        change_event = -1;

                        if (MapNo == 0 && GetSaveData()->GetBitFlag(0x21) != 0 && GetSaveData()->GetBitFlag(0x22) == 0) {
                            change_event = 507;
                        }

                        if (change_event < 0 && EditAnalyzeChanged() != 0) {
                            change_event = 310;
                        }

                        if (change_event > 0) {
                            EditModeChg(change_event);
                        }
                    }
                }
            }
        }

        if (LoopMode == EDIT_LOOP_EDIT_PRE_MENU) {
            PreEditMenuCnt++;

            if (MenuInfo->param[0] < 0 || PreEditMenuCnt > 24) {
                menu_mode = EDIT_LOOP_EDIT_MENU;
                MenuInfo->open_type = MENU_OPEN_GEORAMA;
                open_menu = 1;
                EditModeControlUnLock();
            }
        }

#ifdef PORT
        {
            // Frame the player first and render one tick, so the menu's snapshot is the framed view.
            extern bool MenuFrameCameraForSnapshot(CScene *field_scene, bool town);
            extern bool MenuSnapshotStep();
            static int  snapshot_pending = 0;
            static int  snapshot_menu_mode = 0;

            if (snapshot_pending != 0) {
                open_menu = 0;
                if (MenuSnapshotStep()) {
                    snapshot_pending = 0;
                    open_menu = 1;
                    menu_mode = snapshot_menu_mode;
                    MenuInfo->open_type = MENU_OPEN_MAIN_TOWN;
                }
            } else if (open_menu != 0 && MenuInfo->open_type == MENU_OPEN_MAIN_TOWN &&
                       MenuFrameCameraForSnapshot(MainScene, true)) {
                snapshot_pending = 1;
                snapshot_menu_mode = menu_mode;
                open_menu = 0;
            }
        }
#endif

        if (open_menu != 0) {
            EditDrawFlag &= ~0x1;

            if (!(0 < MainScene->bg_load_step)) {
                CScene *const fade_scene = MainScene;
                int           cross_fading = fade_scene->fade.NowFade() && fade_scene->fade.cross;

                if (cross_fading) {
                    MainScene->fade.FadeIn(0);
                }

                MenuInfo->scene = MainScene;

                if (MenuDataBuf != NULL) {
                    LoopMode = menu_mode;
                    MenuMainInit(MenuInfo);

                    if (sgGetItemOver() != 0) {
                        sgGetItemOverReset();
                    }
                }
            }
        }

        /**
         *
         * Whether the debug rain effect is enabled.
         *
         */
        static int rain_flag = 0;

        if (GamePad__2.Down2(PAD_R2) != 0) {
            if (rain_flag == 0) {
                EventRain.Start();
            } else {
                EventRain.Stop();
            }

            rain_flag = !rain_flag;
        }

        MainScene->fade.FadeStep();
    }

    MainScene->fade.Draw();

    if (PauseFlag != 0) {
        pause_result = PauseMenu();

        if (pause_result == 1) {
            PauseFlag = 0;
        }

        if (pause_result == 2) {
            finish = 1;
        }
    }

    DrawEventEdit();
    FadeOutForE3();

    if (DebugFlag != 0) {
        /**
         *
         * Persistent debug battle-start counter.
         *
         */
        static int start_bt_cnt = 0;
        /**
         *
         * Whether debug encounters are enabled.
         *
         */
        static int encount_flag = 1;
        /**
         *
         * Frames remaining to display the encounter toggle.
         *
         */
        static int show_encount_cnt = 0;
        /**
         *
         * Selection of the next debug encounter, or -1 for none.
         *
         */
        static int next_encount = -1;

        if (show_time_step > 0 || show_encount_cnt > 0) {
            mgCDrawPrim prim;
            prim.Initialize(NULL, NULL);
            prim.DepthTestEnable(0);
            prim.AlphaBlendEnable(0);
            prim.ZMask(1);
            prim.TextureMapEnable(0);

            if ((show_time_step > 0 && time_step != 0) || (show_encount_cnt > 0 && encount_flag != 0)) {
                prim.Begin(MG_PRIM_TRIANGLE);

                if (show_encount_cnt > 0) {
                    prim.Color(255, 0, 0, 128);
                } else {
                    prim.Color(255, 255, 255, 128);
                }

                prim.Vertex(450, 10, 0);
                prim.Vertex(480, 25, 0);
                prim.Vertex(450, 40, 0);
                prim.End();
            } else {
                prim.Begin(MG_PRIM_SPRITE);

                if (show_encount_cnt > 0) {
                    prim.Color(255, 0, 0, 128);
                } else {
                    prim.Color(255, 255, 255, 128);
                }

                prim.Vertex(450, 10, 0);
                prim.Vertex(480, 40, 0);
                prim.End();
            }
        }

        show_time_step--;
        show_encount_cnt--;

        if (show_time_step < 0) {
            show_time_step = 0;
        }

        if (show_encount_cnt < 0) {
            show_encount_cnt = 0;
        }
    }

    if (DebugFlag != 0 && GamePad__2.On(PAD_SELECT) != 0 && GamePad__2.Down(PAD_START) != 0) {
        finish = 1;
    }

    if (MainScene->exit_flag != 0) {
        finish = 1;
    }

    if (finish != 0) {
        PauseCancel();
        PreExitLoop(MainScene);
        return 1;
    }

    return 0;
}
