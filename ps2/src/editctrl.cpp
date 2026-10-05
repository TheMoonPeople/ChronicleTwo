#include "common.h"
#include "dng_effect.hpp"
#include "helpmes.hpp"
#include "inventmn.hpp"
#include "scenesnd.hpp"
#include <cstring>
#include "mainloop.hpp"
#include "mglib.hpp"
#include "sphida.hpp"
#include "editmap.hpp"
#include "editexception.hpp"
#include "mg_texture.hpp"
#include "sceneevent.hpp"
#include "photo.hpp"
#include "mg_math.hpp"
#include "cameracontrol.hpp"
#include "gamepad.hpp"
#include "padcontrol.hpp"
#include "userdata.hpp"
#include "savedata.hpp"
#include "character.hpp"
#include "scene.hpp"
#include "editctrl.hpp"

void LadderControl(CScene *scene, CPadControl *pad);
void CameraControl(CScene *scene, CPadControl *pad);

const int kFirstEventChara = 8;
const int kEventCharaEnd = 0x40;
const int kCharaTypeEffect = 4;

extern char at_962[];

extern CSceneEventData LadderData;
extern "C" int CharaControl__FP6CSceneP11CPadControl(CScene *, CPadControl *);
extern "C" void CancelRotBack__14CCameraControlFv(CCameraControl *camera);
extern u8 MoveInfo[0x110];
extern int move_chara;
extern int CharaAngleTarget;
extern int CharaAngleTargetFlag;
extern int FixCameraFlag;
extern int InitEyeViewFlag;
extern float viewAngleH;
extern float viewAngleV;
extern int AddProj;
extern int ShutterCnt;
extern float OldCameraPos[4];
extern int name_id_982[30];
extern char *name_978[4];
extern "C" void ControlOff__14CCameraControlFv(CCameraControl *camera);
extern "C" void ControlOn__14CCameraControlFv(CCameraControl *camera);
extern "C" void FollowOff__15mgCCameraFollowFv(CCameraControl *camera);
extern "C" void FollowOn__15mgCCameraFollowFv(CCameraControl *camera);
extern "C" void SetDistance__15mgCCameraFollowFf(CCameraControl *camera, float distance);
extern "C" void SetHeight__14CCameraControlFf(CCameraControl *camera, float height);
extern "C" float GetHeight__15mgCCameraFollowFv(CCameraControl *camera);
extern "C" void EyeCamera__FP9mgCCameraP11CCharacter2i(mgCCameraFollow *, CCharacter2 *, int);
extern "C" void InitEyeCamera__FP11CCharacter2P14CCameraControl(CCharacter2 *chara,
                                                                CCameraControl *camera);
extern DEBUG_INFO DebugInfo;
extern "C" void GetPos__9mgCCameraFPf(CCameraControl *camera, float *out);
extern "C" void SetPos__9mgCCameraFPf(mgCCameraFollow *camera, float *pos);
extern "C" void SetNextPos__9mgCCameraFPf(mgCCameraFollow *camera, float *pos);
extern "C" void SetNextRef__9mgCCameraFPf(mgCCameraFollow *camera, float *ref);
extern int LadderMode;
extern int EyeViewCancelOnce;
extern int CharaFallFlag;
extern u32 CharaMotionMode;
extern u32 CharaMotionModeCnt;
extern u32 FixCameraChgCnt;
extern int ViewMode;
extern CGamePad GamePad__2;

// Code (.text)
extern "C" CUserDataManager *GetUserData__Fv(void) {
    CSaveData *save;

    save = GetSaveData();
    if (save != 0) {
        return &save->user_data;
    }
    return 0;
}
int EditOnGround(void) {
    if (CharaFallFlag > 0) {
        return 0;
    }
    if (CharaMotionMode != 0) {
        return 0;
    }
    return (LadderMode != 0) ^ 1;
}
int IsWalkMode(void) {
    return ViewMode == 0;
}
void EditControlInit(CScene *scene) {
    CCameraControl *camera;
    memset(MoveInfo, 0, 0x110);
    EyeViewCancelOnce = 0;
    ViewMode = 0;
    InitEyeViewFlag = 0;
    viewAngleH = 0;
    viewAngleV = 0;
    AddProj = 0;
    ShutterCnt = 0;
    move_chara = 0;
    scene->ResetStatus(1, scene->player_chara, 0x10);
    CharaAngleTarget = 0;
    CharaAngleTargetFlag = 0;
    FixCameraFlag = 0;
    InitTakePhoto();
    EditControlStatusInit(scene);
    camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
    if (camera != NULL && camera->Iam() != 1000) {
        CancelRotBack__14CCameraControlFv(camera);
    }
}
void EditControlStatusInit(CScene *scene) {
    CCharacter2 *chara;

    LadderMode = 0;
    CharaMotionMode = 0;
    CharaMotionModeCnt = 0;
    CharaFallFlag = 0;
    FixCameraChgCnt = 0;
    chara = scene->GetCharacter(scene->player_chara);
    if (chara != NULL) {
        chara->SetMotion(at_962, 4);

        *(int *)((u8 *)chara + 0x84) = 0;
        chara->Step();
    }
}
int EditControl(CScene *scene, CPadControl *pad) {
    CPadControl *camera_pad;

    camera_pad = pad;
    if (LadderMode != 0) {
        LadderControl(scene, pad);
    } else {
        CharaControl__FP6CSceneP11CPadControl(scene, pad);
        if (scene->event_run != 0) {
            camera_pad = (CPadControl *)NULL;
        }
        CameraControl(scene, camera_pad);
    }
    return 0;
}
char *GetFootEffName(int index) {
    if (index < 0 || index >= 30) {
        return 0;
    }
    return name_978[name_id_982[index]];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editctrl", EditMoveChara__FP6CScenePfP17EditMoveCharaInfo);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editctrl", EditCameraControl__FP6CSceneP11CPadControlPA4_f);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editctrl", CharaControl__FP6CSceneP11CPadControl);
void CancelEyeViewMode(void) {
    EyeViewCancelOnce = 1;
}
void CameraControl(CScene *scene, CPadControl *pad) {
    int photo_locked;
    int eye_pressed;
    int photo_pressed;
    CCharacter2 *chara;
    CCameraControl *camera;
    CInventUserData *user_data;
    float position[4];
    float facing[4];
    chara = scene->GetCharacter(scene->player_chara);
    if (chara != NULL) {
        camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
        if (camera != NULL) {
            switch (camera->Iam()) {
                default:
                    return;
                case 1000: {
                    photo_locked = 0;
                    if (scene->event_run != 0) {
                        photo_locked = 1;
                    }
                    if (IsTakePhoto() == 0 && DebugInfo.chara_move == 0) {
                        photo_locked = 1;
                    }
                    chara->GetPosition(position);
                    chara->GetPosition(facing);
                    mgGetNowFrameRate();
                    if (pad != NULL) {
                        if (ViewMode == 0) {
                            eye_pressed = pad->Btn(6);
                            photo_pressed = !photo_locked && pad->Btn(0x33) != 0;
                            if (eye_pressed != 0) {
                                photo_pressed = 0;
                            }
                            if (eye_pressed != 0 || photo_pressed != 0) {
                                if (EyeViewCancelOnce != 0) {
                                    ShowErrorHelpMes(200, 40);
                                } else {
                                    ViewMode = 1;
                                    if (photo_pressed != 0) {
                                        ViewMode = 2;
                                        StartTakePhoto();
                                    }
                                    ControlOff__14CCameraControlFv(camera);
                                    FollowOff__15mgCCameraFollowFv(camera);
                                    InitEyeCamera__FP11CCharacter2P14CCameraControl(chara, camera);
                                    EyeCamera__FP9mgCCameraP11CCharacter2i(
                                        (mgCCameraFollow *)camera, chara, 0);
                                    scene->SetStatus(1, scene->player_chara, 0x10);
                                    scene->EyeViewDrawOnOff(1);
                                    goto done;
                                }
                            }
                        } else if (ViewMode == 1 || ViewMode == 2) {
                            if (pad->Btn(6) != 0 || pad->Btn(1) != 0) {
                                if (ViewMode == 2) {
                                    EndTakePhoto();
                                }
                                FollowOn__15mgCCameraFollowFv(camera);
                                if (DebugInfo.debug_camera == 0) {
                                    SetDistance__15mgCCameraFollowFf(camera, 5.0f);
                                    SetHeight__14CCameraControlFf(camera, 0.0f);
                                } else {
                                    SetHeight__14CCameraControlFf(
                                        camera, GetHeight__15mgCCameraFollowFv(camera));
                                }
                                camera->Step(-1);
                                ControlOn__14CCameraControlFv(camera);
                                ResetViewMode(scene);
                                scene->EyeViewDrawOnOff(0);
                            } else {
                                FollowOff__15mgCCameraFollowFv(camera);
                                EyeCamera__FP9mgCCameraP11CCharacter2i(
                                    (mgCCameraFollow *)camera, chara, 0);
                                user_data = NULL;
                                if (GetUserData__Fv() != 0) {
                                    user_data =
                                        (CInventUserData *)((u8 *)GetUserData__Fv() +
                                                            0x7F30);
                                }
                                LoopTakePhoto(pad, user_data);
                                goto done;
                            }
                        }
                    }
                    EditCameraControl(scene, pad, NULL);
                    EyeViewCancelOnce = 0;
                }
            }
        }
    }
done:;
}
void InitEyeCamera(CCharacter2 *chara, CCameraControl *camera) {
    float rotation[4];
    chara->GetPosition(rotation);
    InitEyeViewFlag = 1;
    viewAngleV = 0;
    AddProj = 0;
    ShutterCnt = 0;
    viewAngleH = rotation[1];
    GetPos__9mgCCameraFPf(camera, OldCameraPos);
}
void ResetViewMode(CScene *scene) {
    mgCCameraFollow *camera;
    ViewMode = 0;
    camera = (mgCCameraFollow *)scene->GetCamera(scene->active_camera);
    if (InitEyeViewFlag != 0) {
        SetPos__9mgCCameraFPf(camera, OldCameraPos);
    }
    InitEyeViewFlag = 0;
    if (camera != NULL) {
        camera->Step(-1);
    }
    scene->ResetStatus(1, scene->player_chara, 0x10);
    EndTakePhoto();
}
extern "C" void EyeCamera__FP9mgCCameraP11CCharacter2i(mgCCameraFollow *camera,
                                                                CCharacter2 *chara,
                                                                int use_right_stick) {
    SV_CONFIG_OPTION *options;
    float angle;
    float turn_speed =
        0.04f;
    float stick_x;
    float stick_y;
    float pos[4];
    float ref[4];
    float look[4][4];
    float unit[4][4];
    mgSetAllScissorFlag(1);
    if (use_right_stick != 0) {
        stick_x = 0.0f;
        stick_y = GamePad__2.GetRYf();
    } else {
        stick_x = GamePad__2.GetLXf();
        stick_y = GamePad__2.GetLYf();
    }
    options = &GetSaveData()->config;
    if (options->eye_reverse == 0) {
        stick_y = -stick_y;
    }
    if (stick_x > 0.0f) {
        viewAngleH -= stick_x * turn_speed;
        if (viewAngleH < -3.1415927f) {
            viewAngleH += 6.2831855f;
        }
    }
    if (stick_x < 0.0f) {
        viewAngleH -= stick_x * turn_speed;
        if (viewAngleH > 3.1415927f) {
            viewAngleH -= 6.2831855f;
        }
    }
    if (stick_y > 0.0f && viewAngleV < 0.65f) {
        viewAngleV += stick_y * turn_speed;
    }
    if (stick_y < 0.0f && viewAngleV > -1.0f) {
        viewAngleV += stick_y * turn_speed;
    }
    ref[0] = 0.0f;
    ref[1] = 0.0f;
    ref[2] = 10.0f;
    ref[3] = 0.0f;
    sceVu0UnitMatrix(unit);
    sceVu0RotMatrixX(look, unit, viewAngleV);
    sceVu0RotMatrixY(look, look, viewAngleH);
    sceVu0ApplyMatrix(ref, look, ref);
    chara->GetPosition(pos);
    pos[1] += 28.0f;
    ref[0] += pos[0];
    ref[1] += pos[1];
    ref[2] += pos[2];
    SetNextPos__9mgCCameraFPf(camera, pos);
    SetNextRef__9mgCCameraFPf(camera, ref);
    camera->Step(-1);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editctrl", InitLadder__FiP6CSceneP15CSceneEventData);
void EndLadder(void) {
    LadderMode = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editctrl", LadderControl__FP6CSceneP11CPadControl);
void EditStepChara(CScene *scene) {
    scene->StepChara(scene->player_chara);
    for (int slot = kFirstEventChara; slot < kEventCharaEnd; slot++) {
        scene->StepChara(slot);
    }
    scene->StepChara(0x78);
    scene->StepChara(0x79);
    scene->StepChara(0x7A);
    scene->StepChara(0x7B);
}
void EditDrawShadowChara(CScene *scene) {
    scene->DrawCharaShadow(scene->player_chara);
    for (int slot = kFirstEventChara; slot < kEventCharaEnd; slot++) {
        scene->DrawCharaShadow(slot);
    }
}
void EditDrawChara(CScene *scene) {
    scene->DrawChara(scene->player_chara, 0);
    for (int slot = kFirstEventChara; slot < kEventCharaEnd; slot++) {
        if (scene->GetType(1, slot) != kCharaTypeEffect) {
            scene->DrawChara(slot, 1);
        }
    }
}
void EditDrawEffectChara(CScene *scene) {
    for (int slot = kFirstEventChara; slot < kEventCharaEnd; slot++) {
        if (scene->GetType(1, slot) == kCharaTypeEffect) {
            scene->DrawChara(slot, 2);
        }
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editctrl", __sinit_editctrl_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", name_978__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", name_id_982__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1080__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1320__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_962__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_979__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_980__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_981__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1239__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1240__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1241__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1355__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1356__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1357__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1465__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1466__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1467__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1468__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1759__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1760__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1761__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1762__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1763__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1764__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1765__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1766__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", at_1767__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editctrl", D_0037B008__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(LadderMode, 0x4);
INCLUDE_BSS(LadderStep, 0x4);
INCLUDE_BSS(CharaMotionMode, 0x4);
INCLUDE_BSS(CharaMotionModeCnt, 0x4);
INCLUDE_BSS(CharaFallFlag, 0x4);
INCLUDE_BSS(CharaAngleTargetFlag, 0x4);
INCLUDE_BSS(CharaAngleTarget, 0x4);
INCLUDE_BSS(FixCameraFlag, 0x4);
INCLUDE_BSS(FixCameraChgCnt, 0x4);
INCLUDE_BSS(EyeViewCancelOnce, 0x4);
INCLUDE_BSS(ViewMode, 0x4);
INCLUDE_BSS(viewAngleH, 0x4);
INCLUDE_BSS(viewAngleV, 0x4);
INCLUDE_BSS(AddProj, 0x4);
INCLUDE_BSS(ShutterCnt, 0x4);
INCLUDE_BSS(InitEyeViewFlag, 0x4);
INCLUDE_BSS(move_chara, 0x4);
INCLUDE_BSS(HamonCnt_1075, 0x4);
INCLUDE_BSS(init_1076, 0x4);
INCLUDE_BSS(reference_1252, 0x4);
INCLUDE_BSS(init_1253, 0x4);
INCLUDE_BSS(camera_dist_mode_1317, 0x4);
INCLUDE_BSS(init_1318, 0x4);
INCLUDE_BSS(LadderCamera, 0x4);
INCLUDE_BSS(LdrNext, 0x4);
INCLUDE_BSS(LdrRot, 0x4);
INCLUDE_BSS(OldMtnRate, 0x4);
INCLUDE_BSS(LdrSound, 0x4);
INCLUDE_BSS(LdrBtmFoot, 0x4);
INCLUDE_BSS(LdrTopFoot, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(MoveInfo, 0x110);
INCLUDE_BSS(OldFixCameraPos, 0x10);
INCLUDE_BSS(OldCameraPos, 0x10);
INCLUDE_BSS(LadderData, 0xD0);
INCLUDE_BSS(LdrPos, 0x10);
INCLUDE_BSS(StdPos, 0x10);
INCLUDE_BSS(LdrBottomPos, 0x10);
INCLUDE_BSS(LdrTopPos, 0x10);
INCLUDE_BSS(LdrTopWalk, 0x10);
INCLUDE_BSS(LdrCamPos, 0x10);
