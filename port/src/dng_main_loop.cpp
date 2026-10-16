#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

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
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapselect.hpp"
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
#include "userdata.hpp"
#include "water.hpp"
#include "wavetable.hpp"

#include "stubs/dng_main.hpp"

PORT_OVERRIDE int LoopDungeonMain() {
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

    PAUSE_INFO pause;
    pause.scene = NULL;
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
