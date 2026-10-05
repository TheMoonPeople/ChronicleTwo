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
#include <cstring>

extern int wep_effect_cnt;
extern char at_3602[];
extern char at_1940[];
extern "C" float backup_pos[4];
extern "C" int init_camera;
extern "C" float viewAngleH__2;
extern "C" float viewAngleV__2;
extern char at_3589[];
extern char at_3496[];
extern CWeaponElement wep_effect[8];
extern char at_1994[];
extern char at_2001[];
extern char at_941__2[];
extern "C" int fptosi(float value);

// Code (.text)
CWeaponElement *GetWeaponEffect(void) {
    CWeaponElement *slot = &wep_effect[wep_effect_cnt];
    wep_effect_cnt += 1;
    if (wep_effect_cnt >= 8) {
        wep_effect_cnt = 0;
    }
    return slot;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", memoryInit__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", InitDungeonMain__F13INIT_LOOP_ARG);
void MoveCheckInfo::Initialize(void) {
    memset(this, 0, sizeof(*this));
}
void CRedMarkModel::Initialize(void) {
    this->draw_request = 0;
    this->angle = 0;
    this->frame = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", __as__9mgCCameraFRC9mgCCamera);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", __ct__14CActiveMonsterFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", CommonStageClassInit__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", CommonClassInit__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", EntryEventScript__Fi);
void FinishDungeonMain(void) {
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", LoopDungeonMain__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", DngMainDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", DngStep__Fv);
int RunMainEvent(void) {
    switch (EventLoop()) {
        case 1:
            DngStatus.mode = 0;
            BattleAreaScene->script.running = 0;
            DngMainScene->active_camera = 0;
            BattleAreaScene->pause_flag &= ~0x400;
            LoopSoundManager(1);
            break;
        case 2:
            DngStatus.mode = 4;
            break;
        case 3:
            DngStatus.mode = 5;
            break;
    }
    return DngStatus.mode;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", DngMainKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", IsEventRun__Fv);
int EventScriptSetup(SYSTEM_SCRIPT_INFO *info) {
    InitEvent(DngMainScene);
    VoiceUnit.StopVoice(10);
    DngMainScene->fade.ResetFade();
    if (RunEvent(info->event_no, DngMainScene) != 0) {
        info->running = 1;
        printf(at_3496, info->event_no);
        DngStatus.mode = 2;
        DngMainScene->before_camera = 0;
        ResetEyeView(MainChara__2);
        memcpy(&EventCamera__2, &MainCamera, sizeof(MainCamera));
        DngMainScene->active_camera = 1;
        MainChara__2->foot_sound_id = -1;
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
    if (DngStatus.mode != 0) {
        return 0;
    }
    CBattleCharaInfo *info = GetBattleCharaInfo();
    if (info->chr_no == 3 && info->GetWhpNowVol(0) <= 0) {
        chara->damage_req = 4;
        return 1;
    }
    if (info->GetNowHp_i() <= 0) {
        chara->damage_req = 4;
        return 1;
    }
    return 0;
}
int ChangeSetUnit(int direction) {
    int next;
    int current = GetUserDataMan()->active_chr_no;
    next = -1;
    if (direction == 0) {
        if (current == 0) {
            if (DngUserData->CheckQuickChange(1, 0) != 0) {
                next = 1;
            }
        }
        if (current == 1) {
            if (DngUserData->CheckQuickChange(0, 0) != 0) {
                next = 0;
            }
        }
    }
    if (direction == 1) {
        if (current == 0) {
            if (DngUserData->CheckQuickChange(2, 0) != 0) {
                next = 2;
            }
        }
        if (current == 1) {
            if (DngUserData->CheckQuickChange(3, 0) != 0) {
                next = 3;
            }
        }
        if (current == 2) {
            if (DngUserData->CheckQuickChange(0, 0) != 0) {
                next = 0;
            }
        }
        if (current == 3 && DngUserData->CheckQuickChange(1, 0) != 0) {
            next = 1;
        }
    }
    return next;
}
void CheckStatusError(void) {
    int damage;
    float pos[4];
    float entry_pos[4];
    if (MainChara__2 != 0) {
        ((CCharacter2 *)MainChara__2)->GetEntryObjectPos(0, 0, pos);
        CBattleCharaInfo *info = GetBattleCharaInfo();
        int step_flags = info->StatusParamStep(&damage);
        int attr = info->GetAttr();
        if (info->GetNowHp_i() > 0) {
            ((CCharacter2 *)MainChara__2)->GetEntryObjectPos(0, 0, entry_pos);
            entry_pos[1] += MainChara__2->body_height;
            if (step_flags & 1) {
                DamageScore2.SetValue(0, damage, MainChara__2->body_height);
                ((CPalletAnime *)&MainChara__2->pallet[0])
                    ->SetAnim(0x60, 0x20, 0x60, 1, 30, 0);
            }
            DngStatus.status_count++;
            if (DngStatus.status_count >= 45) {
                DngStatus.status_count = 0;
                if (attr & 0x10) {
                    ((CPalletAnime *)&MainChara__2->pallet[0])
                        ->SetAnim(0x100, 0xDC, 0x40, 1, 45, 0);
                }
                if (attr & 2) {
                    ((CPalletAnime *)&MainChara__2->pallet[0])
                        ->SetAnim(0xA0, 0x40, 0xA0, 1, 45, 0);
                }
                if (attr & 8) {
                    ((CPalletAnime *)&MainChara__2->pallet[0])
                        ->SetAnim(0x80, 0x40, 0, 1, 45, 0);
                }
                if (attr & 0x20) {
                    ((CPalletAnime *)&MainChara__2->pallet[0])
                        ->SetAnim(0x20, 0x20, 0x20, 1, 45, 0);
                }
            }
            if (info->GetNowHp_i() <= 0) {
                MainChara__2->damage_req = 4;
            }
        }
    }
}
void InitEyeCamera(CActionChara *chara) {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    float rotation[4];
    float partner_rotation[4];
    chara->GetRotation(rotation);
    if (info->chr_no == 2) {
        CActionChara *partner = MainChara__2->SearchChara(at_3589);
        if (partner != 0) {
            partner->GetRotation(partner_rotation);
            rotation[1] = mgAngleLimit(rotation[1] + partner_rotation[1]);
        }
    }
    viewAngleV__2 = 0;
    viewAngleH__2 = rotation[1];
    mgCCameraFollow *camera = (mgCCameraFollow *)DngMainScene->GetCamera(DngMainScene->active_camera);
    if (camera != 0) {
        (camera)->GetPos(backup_pos);
        camera->FollowOff();
        init_camera = 1;
    }
    DngStatus.eye_view = 1;
    MainChara__2->Show(0, 1);
    mgSetAllScissorFlag(1);
}
void CheckWeaponEnable(void) {
    if (BattleAreaScene->pause_flag & 0x2000) {
        CActionChara *first = MainChara__2->SearchChara(at_3602);
        if (first != 0) {
            first->Show(0, 0);
        }
        CActionChara *second = MainChara__2->SearchChara(at_1940);
        if (second != 0) {
            second->Show(0, 0);
        }
    } else {
        MainChara__2->Show(1, 1);
    }
}
void ResetEyeView(CActionChara *chara) {
    if (DngStatus.eye_view != 0) {
        mgCCameraFollow *camera =
            (mgCCameraFollow *)DngMainScene->GetCamera(DngMainScene->active_camera);
        if (camera != 0) {
            if (init_camera != 0) {
                (camera)->SetPos(backup_pos);
            }
            camera->FollowOn();
        }
        DngStatus.eye_view = 0;
        chara->Show(1, 1);
        CheckWeaponEnable();
        mgSetAllScissorFlag(0);
        init_camera = 0;
        if (NowTakePhoto() != 0) {
            EndTakePhoto();
        }
    }
}
extern "C" void EyeCamera__FP9mgCCameraP11CCharacter2i__2(mgCCamera *camera,
                                                                CCharacter2 *chara,
                                                                int right_stick) {
    float look_speed = 0.04f;
    float stick_x;
    float stick_y;
    if (right_stick != 0) {
        stick_x = 0.0f;
        stick_y = -GamePad__2.GetRYf();
    } else {
        stick_x = GamePad__2.GetLXf();
        stick_y = -GamePad__2.GetLYf();
        SV_CONFIG_OPTION *settings = &GetSaveData()->config;
        if (settings->eye_reverse != 0) {
            stick_y = -stick_y;
        }
    }
    if (stick_x > 0.0f) {
        viewAngleH__2 = viewAngleH__2 - stick_x * look_speed;
        if (viewAngleH__2 < -3.1415927f) {
            viewAngleH__2 += 6.2831855f;
        }
    }
    if (stick_x < 0.0f) {
        viewAngleH__2 = viewAngleH__2 - stick_x * look_speed;
        if (viewAngleH__2 > 3.1415927f) {
            viewAngleH__2 -= 6.2831855f;
        }
    }
    if (stick_y > 0.0f && viewAngleV__2 < 0.65f) {
        viewAngleV__2 = viewAngleV__2 + stick_y * look_speed;
    }
    if (stick_y < 0.0f && viewAngleV__2 > -1.0f) {
        viewAngleV__2 = viewAngleV__2 + stick_y * look_speed;
    }
    float pos[4];
    float ref[4];
    float matrix[4][4];
    float base[4][4];
    ref[0] = 0.0f;
    ref[1] = 0.0f;
    ref[2] = 10.0f;
    ref[3] = 0.0f;
    sceVu0UnitMatrix(base);
    sceVu0RotMatrixX(matrix, base, viewAngleV__2);
    sceVu0RotMatrixY(matrix, matrix, viewAngleH__2);
    sceVu0ApplyMatrix(ref, matrix, ref);
    chara->GetPosition(pos);
    pos[1] += 28.0f;
    ref[0] += pos[0];
    ref[1] += pos[1];
    ref[2] += pos[2];
    (camera)->SetPos(pos);
    (camera)->SetRef(ref);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", DebugMainDraw__Fv);
void DBGCMD_RunScript(int event_no) {
    EntryEventScript(DngStatus.dungeon_no);
    mgCMemory *stack = GetMainStack();
    BuffEventData[0].stSetBuffer(stack->stack + stack->stack_used, stack->stack_size - stack->stack_used);
    memcpy(&EventCamera__2, &MainCamera, sizeof(MainCamera));
    DngMainScene->active_camera = 1;
    InitEvent(DngMainScene);
    if (RunEvent(event_no, DngMainScene) != 0) {
        DngStatus.debug_window = 0;
        DngStatus.mode = 2;
        DngMainScene->before_camera = 0;
    }
}
CFireAfterHit::CFireAfterHit() {
    Initialize();
}
CChillAfterHit::CChillAfterHit() {
    Initialize();
}
CThunder::CThunder() {
}
CAfterWire::CAfterWire(void) {
    this->mode = 0;
}
CDamageScore::CDamageScore() {
    memset(color, 0x80, 6);
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_main", __sinit_dng_main_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1081__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1849__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1944__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1997__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1998__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2004__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2624__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2628__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2646__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2700__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2994__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", cam_table_3000__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", cam_table_dist_3001__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", debug_no__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3734__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1016__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1017__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1018__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1019__2__DATA);
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
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1580__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1581__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1582__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1583__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1584__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1585__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1586__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1587__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1588__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1589__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1590__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1591__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1592__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1593__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1594__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1595__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1596__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1597__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1598__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1599__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1600__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1601__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1602__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1603__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1604__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1605__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1606__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1607__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1608__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1609__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1610__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1611__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1612__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1613__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1614__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1615__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1616__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1617__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1618__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1619__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1620__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1621__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1622__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1623__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1624__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1625__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1626__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1627__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1628__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1629__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1630__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1631__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1632__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1633__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1786__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1787__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1788__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1789__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1790__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1842__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1843__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1844__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1845__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1846__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1847__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1848__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_1940__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2593__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2594__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2595__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2596__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2597__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2598__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3336__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3337__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3496__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3589__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3602__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3727__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3728__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3729__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3730__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3731__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3732__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3733__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3791__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3792__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3793__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3794__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3795__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3796__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3797__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3798__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3799__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3800__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3801__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3802__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_3803__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", D_0037B014__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", __vt__12CTreasureBox__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2044__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_main", at_2046__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MainBuffer__2, 0x4);
INCLUDE_BSS(BuffReadData, 0x4);
INCLUDE_BSS(debag_param, 0x4);
INCLUDE_BSS(viewAngleH__2, 0x4);
INCLUDE_BSS(viewAngleV__2, 0x4);
INCLUDE_BSS(init_camera, 0x4);
INCLUDE_BSS(NowFloorInfoPtr, 0x8);
INCLUDE_BSS(ActionScriptEnv, 0x8);
INCLUDE_BSS(DebugPause, 0x4);
INCLUDE_BSS(test_dist, 0x4);
INCLUDE_BSS(DngUserData, 0x4);
INCLUDE_BSS(DngSaveData, 0x4);
INCLUDE_BSS(DngSaveDataDungeon, 0x4);
INCLUDE_BSS(DngMainScene, 0x4);
INCLUDE_BSS(BattleAreaScene, 0x4);
INCLUDE_BSS(DngMainMap, 0x4);
INCLUDE_BSS(ActiveMonster, 0x4);
INCLUDE_BSS(DngMess, 0x4);
INCLUDE_BSS(DngMess2, 0x4);
INCLUDE_BSS(EventMess, 0x4);
INCLUDE_BSS(MonsterMess, 0x4);
INCLUDE_BSS(RedMarkModel, 0x4);
INCLUDE_BSS(TreasureBoxModel, 0x4);
INCLUDE_BSS(TreasureBoxMan, 0x4);
INCLUDE_BSS(MainChara__2, 0x4);
INCLUDE_BSS(FxScriptMan, 0x4);
INCLUDE_BSS(BTsuboCol, 0x8);
INCLUDE_BSS(PullItemMan, 0x8);
INCLUDE_BSS(TornadoModel, 0x4);
INCLUDE_BSS(wep_effect_cnt, 0x4);
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

// Uninitialised data (.bss)
INCLUDE_BSS(BuffPaketList, 0x60);
INCLUDE_BSS(BuffPaketData, 0x60);
INCLUDE_BSS(BuffStageMain, 0x30);
INCLUDE_BSS(BuffStageChara, 0x30);
INCLUDE_BSS(BuffStageSubData, 0x30);
INCLUDE_BSS(BuffStageSubChara, 0x30);
INCLUDE_BSS(BuffWorkData__2, 0x30);
INCLUDE_BSS(BuffCharacter, 0x30);
INCLUDE_BSS(BaseCharacter, 0x120);
INCLUDE_BSS(BuffTempData, 0x30);
INCLUDE_BSS(BuffScriptData, 0x30);
INCLUDE_BSS(BuffEffectScriptData, 0x30);
INCLUDE_BSS(BuffEventData, 0xC0);
INCLUDE_BSS(BuffMDTBuild, 0x30);
INCLUDE_BSS(BuffMDTBuild2, 0x30);
INCLUDE_BSS(DngStatus, 0x20);
INCLUDE_BSS(map_effect, 0x20);
INCLUDE_BSS(AccumulateEffect, 0x330);
INCLUDE_BSS(DamageScore, 0x90);
INCLUDE_BSS(DamageScoreMons, 0x480);
INCLUDE_BSS(DamageScore2, 0x30);
INCLUDE_BSS(MsgTaskMan, 0x370);
INCLUDE_BSS(StartupEpisodeTitle, 0x20);
INCLUDE_BSS(BattleFX, 0x50);
INCLUDE_BSS(LevelupInfo, 0x40);
INCLUDE_BSS(LockOnModel, 0xB0);
INCLUDE_BSS(WarningGage2, 0x20);
INCLUDE_BSS(AutoMapGen, 0x2A0);
INCLUDE_BSS(ColPrimMan, 0x4410);
INCLUDE_BSS(RandomCircle, 0x6A0);
INCLUDE_BSS(GeoStone, 0x670);
INCLUDE_BSS(MainCamera, 0x1F0);
INCLUDE_BSS(EventCamera__2, 0x1F0);
INCLUDE_BSS(HealingEffectMan, 0x330);
INCLUDE_BSS(MiniEffPrimMan, 0x940);
INCLUDE_BSS(ItemBaseData, 0x7920);
INCLUDE_BSS(afterWire, 0x1200);
INCLUDE_BSS(VoiceUnit, 0x20);
INCLUDE_BSS(BTsubo, 0x80);
INCLUDE_BSS(BTsubo2, 0xC50);
INCLUDE_BSS(RocketLauncher, 0x2580);
INCLUDE_BSS(MachineGun, 0x390);
INCLUDE_BSS(LaserGun, 0x1300);
INCLUDE_BSS(LaserGunModel, 0x660);
INCLUDE_BSS(PullItem, 0x2400);
INCLUDE_BSS(nowload, 0x40);
INCLUDE_BSS(at_941__2, 0x10);
INCLUDE_BSS(WaveTable__2, 0x1208);
INCLUDE_BSS(SparcModel, 0x18);
INCLUDE_BSS(SwordLuminous, 0x20);
INCLUDE_BSS(wep_effect, 0x3E00);
INCLUDE_BSS(Sparc_fx, 0x420);
INCLUDE_BSS(thunder, 0x5280);
INCLUDE_BSS(tornado, 0x1500);
INCLUDE_BSS(chillAfterHit, 0x2DC0);
INCLUDE_BSS(fireAfterHit, 0x3780);
INCLUDE_BSS(debug_event_stack_1106, 0x30);
INCLUDE_BSS(stack_1823, 0x30);
INCLUDE_BSS(at_1994, 0x10);
INCLUDE_BSS(at_2001, 0x10);
INCLUDE_BSS(chk_pos_2870, 0x10);
INCLUDE_BSS(backup_pos, 0x10);
