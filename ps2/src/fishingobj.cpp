#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "actionchara.hpp"
#include "scene.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "cameracontrol.hpp"
#include "fishingobj.hpp"
#include <cstdlib>
#include <cstring>
#include <cmath>

const int kLinePointNum = 64;
const int kUkiPointIndex = 60;
const int kRodTipIndex = 48;
const int kRodNearTipIndex = 36;
const int kSaoWeaponFrameIndex = 7;

struct TriAxis { int v[3]; };
struct Matrix4 { float m[4][4]; };

extern FISH_POINT LinePoint[64];
extern FISH_POINT FlyingPoint;
extern FISH_POINT FishPoint;
extern CFishObj HariObj;
extern CFishObj LureObj;
extern CFishObj UkiObj;
extern float RodPoint[60];
extern mgCFrame *SaoFrame[8];
extern u_char BattleStartPos[16];
extern float CastingPoint[4];
extern float ReleasePoint[4];
extern TriAxis at_975__5;
extern TriAxis at_985__4;
extern TriAxis at_986__3;
extern Matrix4 at_1797;
extern float at_1798[4];
extern char at_1503__4[];
extern char at_1564[];
extern int NowMode;
extern int ShowHari;
extern int LureLessFlag;
extern float WaterLevel;
extern int LineTop;
extern float LineTopDist;
extern int CastingLureFlag;
extern int CastingLureTime;
extern int AddLineSpeed;
extern int BattleFlag;
extern float BattleLineDist;
extern int ActionChanceNextCnt;
extern int ActionChanceCnt;
extern u_int ActionChanceDir;
extern int NowFishSpeed;
extern float NowFishRot;
extern "C" int fptosi(float value);
#include <libvu0.h>
#include "mg_math.hpp"
#include "gameutil.hpp"
#include "mg_frame.hpp"
#include "mg_drawprim.hpp"
#include "mglib.hpp"
#include "scenesnd.hpp"
#include "dng_main.hpp"

#ifdef NONMATCHING
static float WaterLevel;
static int LineTop;
static float LineTopDist;
static int CastingLureFlag;
static int CastingLureTime;
static int AddLineSpeed;
static int BattleFlag;
static float BattleLineDist;
static int ShowHari;
static int LureLessFlag;
static int NowMode;
static int NowFishSpeed;
static float NowFishRot;
static int ActionChanceNextCnt;
static int ActionChanceCnt;
static int ActionChanceDir;
static FISH_POINT RodPoint[5];
static FISH_ROD_SEGMENT RodPointDist[5];
static mgCFrame *SaoFrame[8];
static float SaoDist[8];
static FISH_POINT LinePoint[64];
static FISH_POINT LurePoint[3];
static FISH_POINT FlyingPoint;
static FISH_POINT FishPoint;
static sceVu0FVECTOR CastingPoint;
static sceVu0FVECTOR ReleasePoint;
static sceVu0FVECTOR BattleStartPos;
static CFishObj LureObj;
static CFishObj UkiObj;
static CFishObj HariObj;
static sceVu0FVECTOR ChanceBarPos;

static void BindPosition(float *point0, float *point1, float length, float rate);

static void SetObjectPoint(FISH_POINT &point, float x, float y, float z) {
    point.pos[0] = x;
    point.pos[1] = y;
    point.pos[2] = z;
    point.pos[3] = 1.0f;
}

static void SetObjectBind(FISH_BIND &bind, FISH_POINT &first, FISH_POINT &second) {
    bind.point0 = &first;
    bind.point1 = &second;
    bind.rate = 0.5f;
    bind.length = mgDistVector(first.pos, second.pos);
}
#endif

#ifndef NONMATCHING
void GetTriPose(float (*matrix)[4], float (*tri)[4], int *order);
#endif

// Code (.text)
void SetFishingMode(int value) {
    NowMode = value;
}
int GetFishingMode(void) {
    return NowMode;
}
void SetWaterLevel(float value) {
    WaterLevel = value;
}
float GetWaterLevel(void) {
    return WaterLevel;
}
CFishObj *GetActiveHariObj(void) {
    if (NowMode == 2) {
        return &LureObj;
    }
    return &HariObj;
}
CFishObj *GetActiveUkiObj(void) {
    if (NowMode == 2) {
        return NULL;
    }
    return &UkiObj;
}
int ExtendLine(float amount) {
    if (BattleFlag != 0) {
        BattleLineDist += amount;
        if (BattleLineDist < 20.0f) {
            BattleFlag = 0;
            LineTop = 59;
            LineTopDist = 5.0f;
            return -1;
        }
        return 0;
    }
    if (amount > 0.0f) {
        LineTopDist += amount;
        while (LineTopDist > 5.0f) {
            LineTopDist -= 5.0f;
            LineTop -= 1;
            if (LineTop >= 0) {
                FISH_POINT *point = &LinePoint[LineTop];
                *(u_long128 *)point->pos = *(u_long128 *)(RodPoint + kRodTipIndex);
                *(u_long128 *)point->old_pos = *(u_long128 *)(RodPoint + kRodTipIndex);
                mgZeroVector(point->velo);
            }
        }
        if (LineTop < 0) {
            LineTopDist = 5.0f;
            LineTop = 0;
            return 1;
        }
    }
    if (amount < 0.0f) {
        LineTopDist += amount;
        while (LineTopDist < 0.0f) {
            LineTopDist += 5.0f;
            LineTop += 1;
        }
        if (LineTop >= 59) {
            LineTop = 59;
            LineTopDist = 5.0f;
            return -1;
        }
    }
    return 0;
}
float GetNowLineLength(void) {
    if (BattleFlag != 0) {
        return BattleLineDist;
    }
    float length = 5.0f * (63 - LineTop);
    length += LineTopDist;
    return length;
}
float GetMinLineLength(void) {
    return 25.0f;
}
#ifdef NONMATCHING
void InitRodPoint(mgCFrame *reference, mgCFrame *rod) {
    for (int i = 0; i < 5; i++) {
        mgZeroVector(RodPoint[i].pos);
        mgZeroVector(RodPoint[i].old_pos);
        mgZeroVector(RodPoint[i].velo);
    }
    for (int i = 0; i < 64; i++) {
        mgZeroVector(LinePoint[i].pos);
        mgZeroVector(LinePoint[i].old_pos);
        mgZeroVector(LinePoint[i].velo);
    }
    for (int i = 0; i < 3; i++) {
        mgZeroVector(LurePoint[i].pos);
        mgZeroVector(LurePoint[i].old_pos);
        mgZeroVector(LurePoint[i].velo);
    }
    const char *joint_names[8] = {"sao1", "sao2", "sao3", "sao4", "sao5", "sao6", "sao7", "sao8"};
    for (int i = 0; i < 8; i++) {
        SaoFrame[i] = rod->SearchFrame((char *)joint_names[i]);
    }
    sceVu0FVECTOR root;
    sceVu0FVECTOR tip;
    sceVu0FVECTOR joint;
    sceVu0FVECTOR span;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR position;
    SaoFrame[0]->GetWorldPosition0(root);
    SaoFrame[7]->GetWorldPosition0(tip);
    for (int i = 0; i < 8; i++) {
        SaoFrame[i]->GetWorldPosition0(joint);
        SaoDist[i] = mgDistVector(root, joint);
    }
    sceVu0SubVector(span, tip, root);
    for (int i = 0; i < 5; i++) {
        sceVu0ScaleVector(offset, span, (float)i / 4.0f);
        sceVu0AddVector(position, root, offset);
        sceVu0CopyVector(RodPoint[i].pos, position);
        sceVu0CopyVector(RodPoint[i].old_pos, position);
        mgZeroVector(RodPoint[i].velo);
        if (i > 0) {
            RodPointDist[i].length = mgDistVector(RodPoint[i].pos, RodPoint[i - 1].pos);
        }
        RodPointDist[i].stiffness = ((float)(5 - i) * 0.3f) / 5.0f + 0.3f;
        if (RodPointDist[i].stiffness > 1.0f) {
            RodPointDist[i].stiffness = 1.0f;
        }
        RodPointDist[i].damping = ((float)(5 - i) * 0.2f) / 5.0f + 0.2f;
    }
    ResetLine(tip);
    LineTop = 59;
    LineTopDist = 5.0f;
    EndCastingLure();
    BattleFlag = 0;
    NowMode = FISHING_MODE_BAIT;
    ShowHari = 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", InitRodPoint__FP8mgCFrameP8mgCFrame);
#endif
#ifdef NONMATCHING
static void GetTriPose(sceVu0FMATRIX pose, sceVu0FVECTOR points[3], int axes[3]) {
    int first_axis = axes[0] < 0 ? -axes[0] : axes[0];
    int second_axis = axes[1] < 0 ? -axes[1] : axes[1];
    int normal_axis = axes[2] < 0 ? -axes[2] : axes[2];
    sceVu0SubVector(pose[first_axis], points[1], points[0]);
    sceVu0Normalize(pose[first_axis], pose[first_axis]);
    mgPlaneNormal(pose[normal_axis], points[0], points[1], points[2]);
    sceVu0Normalize(pose[normal_axis], pose[normal_axis]);
    sceVu0OuterProduct(pose[second_axis], pose[normal_axis], pose[first_axis]);
    for (int axis = 0; axis < 3; axis++) {
        sceVu0Normalize(pose[axis], pose[axis]);
        if (axes[axis] < 0) {
            sceVu0ScaleVector(pose[-axes[axis]], pose[-axes[axis]], -1.0f);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", GetTriPose__FPA4_fPA4_fPi);
#endif
void GetHariPos(float *pos, float *old_pos) {
    *(u_long128 *)pos = *(u_long128 *)LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *)old_pos = *(u_long128 *)LinePoint[kLinePointNum - 1].old_pos;
}
void GetUkiPos(float *pos, float *old_pos) {
    *(u_long128 *)pos = *(u_long128 *)LinePoint[kUkiPointIndex].pos;
    *(u_long128 *)old_pos = *(u_long128 *)LinePoint[kUkiPointIndex].old_pos;
}
void PullUki(float amount) {
    LinePoint[kLinePointNum - 1].velo[1] = LinePoint[kLinePointNum - 1].velo[1] - amount;
}
void SetShowHari(int value) {
    ShowHari = value;
}
int GetShowHari(void) {
    float pos[4];
    float velo[4];

    GetHariPos(pos, velo);
    float limit = GetWaterLevel();
    limit -= 3.0f;
    if (pos[1] < limit) {
        return 0;
    }
    return ShowHari;
}
int SetLurePose(mgCFrame *frame) {
    float position[4];
    float matrix[4][4];
    float tri[3][4];
    TriAxis order;

    if (frame == NULL) {
        return 0;
    }
    if (NowMode == 1) {
        return 0;
    }
    *(u_long128 *)position = *(u_long128 *)&LinePoint[kLinePointNum - 1].pos;
    mgUnitMatrix(matrix);
    *(u_long128 *)tri[0] = *(u_long128 *)&LureObj.point[0].pos;
    *(u_long128 *)tri[1] = *(u_long128 *)&LureObj.point[1].pos;
    *(u_long128 *)tri[2] = *(u_long128 *)&LureObj.point[2].pos;
    order = at_975__5;
    GetTriPose(matrix, tri, order.v);
    frame->SetPosition(position);
    frame->SetTransMatrix(matrix);
    return 1;
}
int SetUkiPose(mgCFrame *uki_frame, mgCFrame *hari_frame) {
    float matrix[4][4];
    float position[4];
    float tri[3][4];
    TriAxis uki_order;
    TriAxis hari_order;

    if (uki_frame == NULL || hari_frame == NULL) {
        return 0;
    }
    if (NowMode == 2) {
        return 0;
    }
    *(u_long128 *)position = *(u_long128 *)&LinePoint[kUkiPointIndex].pos;
    mgUnitMatrix(matrix);
    sceVu0AddVector(tri[1], UkiObj.point[1].pos, UkiObj.point[2].pos);
    mgAddVector(tri[1], UkiObj.point[3].pos);
    *(u_long128 *)tri[0] = *(u_long128 *)&UkiObj.point[0].pos;
    sceVu0ScaleVector(tri[1], tri[1], 0.33333334f);
    *(u_long128 *)tri[2] = *(u_long128 *)&UkiObj.point[1].pos;
    uki_order = at_985__4;
    GetTriPose(matrix, tri, uki_order.v);
    uki_frame->SetTransMatrix(matrix);
    uki_frame->SetPosition(position);
    *(u_long128 *)position = *(u_long128 *)&LinePoint[kLinePointNum - 1].pos;
    sceVu0AddVector(tri[1], HariObj.point[1].pos, HariObj.point[2].pos);
    *(u_long128 *)tri[0] = *(u_long128 *)&HariObj.point[0].pos;
    sceVu0ScaleVector(tri[1], tri[1], 0.5f);
    *(u_long128 *)tri[2] = *(u_long128 *)&HariObj.point[2].pos;
    hari_order = at_986__3;
    GetTriPose(matrix, tri, hari_order.v);
    hari_frame->SetTransMatrix(matrix);
    hari_frame->SetPosition(position);
    return 1;
}
int CastingLure(float *target) {
    float start[4];
    float to_target[4];
    *(u_long128 *)&start = *(u_long128 *)&LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *)&CastingPoint = *(u_long128 *)target;
    *(u_long128 *)&ReleasePoint = *(u_long128 *)&start;
    *(u_long128 *)&FlyingPoint.pos = *(u_long128 *)&start;
    *(u_long128 *)&FlyingPoint.old_pos = *(u_long128 *)&start;
    mgZeroVector(FlyingPoint.velo);
    sceVu0SubVector(to_target, target, start);
    float distance;
    float horizontal_speed;
    float flight_time;
    float unit = 1.0f;
    float lift_ratio = 0.8f;
    distance = 2.0f * mgDistVectorXZ(to_target);
    flight_time = sqrtf((0.6f * distance) / 1.6f);
    horizontal_speed = flight_time * unit;
    CastingLureTime = fptosi(distance / horizontal_speed);
    to_target[1] = 0.0f;
    sceVu0Normalize(to_target, to_target);
    sceVu0ScaleVector(FlyingPoint.velo, to_target, horizontal_speed);
    FlyingPoint.velo[1] = flight_time * lift_ratio;
    AddLineSpeed = 0;
    CastingLureFlag = 1;
    return CastingLureTime;
}
void EndCastingLure(void) {
    CastingLureFlag = 0;
    CastingLureTime = 0;
    AddLineSpeed = 0;
}
int CatchLine(float *target, float reach) {
    CFishObj *hari = GetActiveHariObj();
    float to_target[4];
    float moved[4];
    sceVu0SubVector(to_target, target, LinePoint[kLinePointNum - 1].pos);
    if (mgDistVector(to_target) < reach) {
        *(u_long128 *)&LinePoint[kLinePointNum - 1].pos = *(u_long128 *)target;
        *(u_long128 *)&LinePoint[kLinePointNum - 1].old_pos = *(u_long128 *)target;
        mgZeroVector(LinePoint[kLinePointNum - 1].velo);
        if (hari != 0) {
            *(u_long128 *)hari->point[0].pos = *(u_long128 *)target;
            *(u_long128 *)hari->point[0].old_pos = *(u_long128 *)target;
            mgZeroVector(hari->point[0].velo);
        }
        return 1;
    }
    sceVu0Normalize(to_target, to_target);
    sceVu0ScaleVector(to_target, to_target, reach);
    sceVu0AddVector(moved, LinePoint[kLinePointNum - 1].pos, to_target);
    *(u_long128 *)&LinePoint[kLinePointNum - 1].pos = *(u_long128 *)moved;
    *(u_long128 *)&LinePoint[kLinePointNum - 1].old_pos = *(u_long128 *)moved;
    mgZeroVector(LinePoint[kLinePointNum - 1].velo);
    if (hari != 0) {
        *(u_long128 *)hari->point[0].pos = *(u_long128 *)moved;
        *(u_long128 *)hari->point[0].old_pos = *(u_long128 *)moved;
        mgZeroVector(hari->point[0].velo);
    }
    return 0;
}
#ifdef NONMATCHING
void SlowLineVelo(float rate) {
    for (int i = LineTop; i < 64; i++) {
        sceVu0ScaleVector(LinePoint[i].velo, LinePoint[i].velo, rate);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", SlowLineVelo__Ff);
#endif
#ifdef NONMATCHING
void ResetLineVelo() {
    sceVu0FVECTOR top_pos;
    sceVu0CopyVector(top_pos, LinePoint[LineTop].pos);
    for (int i = LineTop; i < 64; i++) {
        sceVu0CopyVector(LinePoint[i].pos, top_pos);
        sceVu0CopyVector(LinePoint[i].old_pos, top_pos);
        mgZeroVector(LinePoint[i].velo);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", ResetLineVelo__Fv);
#endif
void ResetLine(float *tip) {
    LineTop = 59;
    FISH_POINT *last = &LinePoint[59];
    *(u_long128 *)&last->pos = *(u_long128 *)tip;
    *(u_long128 *)&last->old_pos = *(u_long128 *)tip;
    mgZeroVector(last->velo);
    for (int i = LineTop + 1; i < kLinePointNum; i++) {
        float pos[4];
        *(u_long128 *)&pos = *(u_long128 *)&LinePoint[i - 1].pos;
        pos[0] = tip[0];
        pos[1] -= 5.0f;
        pos[2] = tip[2];
        *(u_long128 *)&LinePoint[i].pos = *(u_long128 *)&pos;
        *(u_long128 *)&LinePoint[i].old_pos = *(u_long128 *)&pos;
        mgZeroVector(LinePoint[i].velo);
    }
    *(u_long128 *)&LureObj.point[0].pos = *(u_long128 *)&LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *)&LureObj.point[0].old_pos = *(u_long128 *)&LinePoint[kLinePointNum - 1].pos;
    mgZeroVector(LureObj.point[0].velo);
    *(u_long128 *)&UkiObj.point[0].pos = *(u_long128 *)&LinePoint[kUkiPointIndex].pos;
    *(u_long128 *)&UkiObj.point[0].old_pos = *(u_long128 *)&LinePoint[kUkiPointIndex].pos;
    mgZeroVector(UkiObj.point[0].velo);
    *(u_long128 *)&HariObj.point[0].pos = *(u_long128 *)&LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *)&HariObj.point[0].old_pos = *(u_long128 *)&LinePoint[kLinePointNum - 1].pos;
    mgZeroVector(HariObj.point[0].velo);
}
int GetNextChanceCnt(void) {
    return (rand() % 80) + 0x3C;
}
int InitFishBattle(void) {
    volatile u_long128 *last = (volatile u_long128 *)&LinePoint[kLinePointNum - 1];
    *(u_long128 *)BattleStartPos = *last;
    *(u_long128 *)&FishPoint.pos = *last;
    *(u_long128 *)&FishPoint.old_pos = *last;
    mgZeroVector(FishPoint.velo);
    float dist = mgDistVector(LinePoint[kLinePointNum - 1].pos, (RodPoint + kRodTipIndex));
    NowFishSpeed = 0;
    BattleLineDist = dist;
    BattleFlag = 1;
    NowFishRot = 0;
    ActionChanceNextCnt = GetNextChanceCnt();
    ActionChanceCnt = 0;
    return 1;
}
int EndFishBattle(void) {
    BattleFlag = 0;
    ActionChanceNextCnt = 0;
    ActionChanceCnt = 0;
    return 1;
}
int CheckRodActionChance(int direction, int *at_start) {
    int product;

    *at_start = 0;
    if ((BattleFlag == 0) || (ActionChanceCnt <= 0)) {
        return 0;
    }
    product = direction * ActionChanceDir;
    if (product > 0) {
        return 1;
    }
    if (product < 0) {
        return -1;
    }
    *at_start = ActionChanceCnt == 0x1C;
    return 0;
}
#ifdef NONMATCHING
int FishBattle(CScene *scene, CCPoly *poly_buffer, int poly_max) {
    if (BattleFlag == 0) {
        return 0;
    }
    CCharacter2 *player = scene->GetCharacter(scene->player_chara);
    sceVu0FVECTOR player_pos;
    sceVu0FVECTOR player_rot;
    sceVu0FVECTOR heading;
    sceVu0FVECTOR next_pos;
    player->GetPosition(player_pos);
    player->GetRotation(player_rot);
    float target_angle = player_rot[1] + (mgRnd() - 0.5f) * 2.5132742f;
    if (ActionChanceCnt <= 0) {
        --ActionChanceNextCnt;
        ActionChanceCnt = 0;
        if (ActionChanceNextCnt <= 0) {
            ActionChanceCnt = 30;
            ActionChanceDir = rand() % 2 == 0 ? -1 : 1;
        }
    }
    if (ActionChanceCnt > 0) {
        target_angle = ActionChanceDir > 0 ? player_rot[1] - mgRnd() * 1.2566371f :
                                              player_rot[1] + mgRnd() * 1.2566371f;
        sceVu0FVECTOR float_velo;
        GetUkiPos(ChanceBarPos, float_velo);
        ChanceBarPos[1] = WaterLevel;
        --ActionChanceCnt;
        if (ActionChanceCnt <= 0) {
            ActionChanceCnt = 0;
            ActionChanceNextCnt = GetNextChanceCnt();
        }
    }
    NowFishRot = mgAngleInterpolate(NowFishRot, mgAngleLimit(target_angle), 0.1f, 0);
    NowFishSpeed = 8;
    FishPoint.velo[0] = (float)NowFishSpeed * sinf(NowFishRot);
    FishPoint.velo[1] = 0.0f;
    FishPoint.velo[2] = (float)NowFishSpeed * cosf(NowFishRot);
    FishPoint.pos[1] = WaterLevel - 10.0f;
    sceVu0CopyVector(next_pos, FishPoint.pos);
    next_pos[0] += FishPoint.velo[0];
    next_pos[2] += FishPoint.velo[2];
    mgVu0FBOX query_box;
    sceVu0CopyVector(query_box.max, FishPoint.pos);
    sceVu0CopyVector(query_box.min, FishPoint.pos);
    for (int axis = 0; axis < 3; axis++) {
        query_box.max[axis] += 100.0f;
        query_box.min[axis] -= 100.0f;
    }
    int poly_count = scene->GetColPoly(poly_buffer, query_box, poly_max);
    MoveCheckInfo check;
    memset(&check, 0, sizeof(check));
    check.radius = 10.0f;
    MoveCheck(FishPoint.pos, FishPoint.velo, next_pos, &check, poly_buffer, poly_count, 0);
    sceVu0SubVector(heading, next_pos, player_pos);
    sceVu0Normalize(heading, heading);
    sceVu0InnerProduct(heading, player_rot);
    FishPoint.pos[0] = next_pos[0];
    FishPoint.pos[2] = next_pos[2];
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", FishBattle__FP6CSceneP6CCPolyi);
#endif
void GetFishPosVelo(float *pos, float *velo) {
    u_long128 v = *(volatile u_long128 *)&FishPoint.pos;
    *(u_long128 *)pos = v;
    *(u_long128 *)velo = *(volatile u_long128 *)&FishPoint.velo;
}
#ifdef NONMATCHING
static void BindFishObj() {
    CFishObj *hari = GetActiveHariObj();
    CFishObj *uki = GetActiveUkiObj();
    sceVu0CopyVector(LinePoint[LineTop].pos, RodPoint[4].pos);
    sceVu0CopyVector(LinePoint[LineTop].old_pos, RodPoint[4].pos);
    mgZeroVector(LinePoint[LineTop].velo);
    for (int step = 0; step < 4; step++) {
        for (int i = LineTop; i < 63; i++) {
            float rate = i > 58 ? 0.52f : 0.5f;
            float length = i == LineTop ? LineTopDist : 5.0f;
            BindPosition(LinePoint[i].pos, LinePoint[i + 1].pos, length, rate);
        }
        if (CastingLureFlag != 0) {
            sceVu0CopyVector(LinePoint[63].pos, FlyingPoint.pos);
        }
        if (LureLessFlag == 0) {
            BindPosition(LinePoint[63].pos, hari->point[0].pos, 0.0f, 0.45f);
        }
        hari->BindStep();
        if (uki != 0) {
            BindPosition(LinePoint[60].pos, uki->point[0].pos, 0.0f, 0.4f);
            uki->BindStep();
        }
        sceVu0CopyVector(LinePoint[LineTop].pos, RodPoint[4].pos);
        sceVu0CopyVector(LinePoint[LineTop].old_pos, RodPoint[4].pos);
        mgZeroVector(LinePoint[LineTop].velo);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", BindFishObj__Fv);
#endif
#ifdef NONMATCHING
void RodStep(CScene *scene, u_long128 *poly_buffer) {
    CCPoly *polys = (CCPoly *)poly_buffer;
    CFishObj *hari = GetActiveHariObj();
    CFishObj *uki = GetActiveUkiObj();
    sceVu0FVECTOR frame_pos;
    SaoFrame[0]->GetWorldPosition0(frame_pos);
    sceVu0CopyVector(RodPoint[0].pos, frame_pos);
    sceVu0CopyVector(RodPoint[0].old_pos, frame_pos);
    mgZeroVector(RodPoint[0].velo);
    SaoFrame[1]->GetWorldPosition0(frame_pos);
    sceVu0CopyVector(RodPoint[1].pos, frame_pos);
    sceVu0CopyVector(RodPoint[1].old_pos, frame_pos);
    mgZeroVector(RodPoint[1].velo);

    if (CastingLureFlag != 0) {
        FlyingPoint.velo[1] -= 0.6f;
        float cast_distance = mgDistVectorXZ(ReleasePoint, CastingPoint);
        float flown_distance = mgDistVectorXZ(ReleasePoint, FlyingPoint.pos);
        sceVu0FVECTOR flight_step;
        sceVu0CopyVector(flight_step, FlyingPoint.velo);
        if (flown_distance > cast_distance * 0.8f) {
            float scale = (cast_distance - flown_distance) / (cast_distance * 0.2f);
            flight_step[0] *= scale;
            flight_step[2] *= scale;
            ExtendLine(mgDistVectorXZ(flight_step));
        } else {
            float top_gap = mgDistVector(LinePoint[LineTop].pos, LinePoint[LineTop + 1].pos);
            if (top_gap > LineTopDist) {
                ExtendLine(0.8f * mgDistVectorXZ(flight_step));
            }
            for (int i = LineTop + 1; i < 63; i++) {
                sceVu0FVECTOR pull;
                sceVu0SubVector(pull, FlyingPoint.pos, LinePoint[i].pos);
                sceVu0Normalize(pull, pull);
                sceVu0ScaleVector(pull, pull, 2.0f);
                mgAddVector(LinePoint[i].velo, pull);
            }
        }
        float remaining = mgDistVectorXZ(CastingPoint, FlyingPoint.pos);
        if (remaining < mgDistVectorXZ(flight_step)) {
            flight_step[0] = 0.0f;
            flight_step[2] = 0.0f;
            FlyingPoint.velo[0] = 0.0f;
            FlyingPoint.velo[2] = 0.0f;
            FlyingPoint.pos[0] = CastingPoint[0];
            FlyingPoint.pos[2] = CastingPoint[2];
        }
        mgAddVector(FlyingPoint.pos, flight_step);
        sceVu0CopyVector(LinePoint[63].pos, FlyingPoint.pos);
        sceVu0CopyVector(LinePoint[63].old_pos, FlyingPoint.pos);
        mgZeroVector(LinePoint[63].velo);
        --CastingLureTime;
    }

    for (int i = 2; i < 5; i++) {
        sceVu0CopyVector(RodPoint[i].old_pos, RodPoint[i].pos);
        if (BattleFlag == 0) {
            mgAddVector(RodPoint[i].pos, RodPoint[i].velo);
        }
    }
    mgVu0FBOX line_box;
    sceVu0CopyVector(line_box.max, LinePoint[LineTop].pos);
    sceVu0CopyVector(line_box.min, LinePoint[LineTop].pos);
    for (int i = LineTop; i < 64; i++) {
        FISH_POINT &point = LinePoint[i];
        sceVu0CopyVector(point.old_pos, point.pos);
        mgAddVector(point.pos, point.velo);
        point.pos[1] -= 0.36f;
        mgVectorMaxMin(line_box.max, line_box.min, line_box.max, line_box.min, point.pos);
    }
    hari->MovePoint();
    if (uki != 0) {
        uki->MovePoint();
    }

    // Keep the rod's four moving masses spaced between its fixed joints and tip.
    for (int pass = 0; pass < 2; pass++) {
        if (BattleFlag != 0) {
            BindPosition(RodPoint[4].pos, FishPoint.pos, BattleLineDist, 0.2f);
        } else {
            BindPosition(RodPoint[4].pos, LinePoint[LineTop].pos, 0.0f, 0.8f);
        }
        for (int i = 3; i >= 2; i--) {
            sceVu0FVECTOR across;
            sceVu0FVECTOR half_across;
            sceVu0FVECTOR segment;
            sceVu0FVECTOR bend;
            sceVu0SubVector(across, RodPoint[i + 1].pos, RodPoint[i - 1].pos);
            sceVu0ScaleVector(half_across, across, 0.5f);
            sceVu0SubVector(segment, RodPoint[i].pos, RodPoint[i - 1].pos);
            sceVu0SubVector(bend, half_across, segment);
            sceVu0ScaleVector(bend, bend, RodPointDist[i].damping);
            mgAddVector(segment, bend);
            sceVu0Normalize(segment, segment);
            sceVu0ScaleVector(segment, segment, RodPointDist[i].length);
            sceVu0AddVector(RodPoint[i].pos, RodPoint[i - 1].pos, segment);
        }
        for (int i = 1; i < 4; i++) {
            sceVu0FVECTOR direction;
            sceVu0FVECTOR desired;
            sceVu0FVECTOR actual;
            sceVu0FVECTOR error;
            sceVu0SubVector(direction, RodPoint[i].pos, RodPoint[i - 1].pos);
            sceVu0Normalize(direction, direction);
            sceVu0ScaleVector(desired, direction, RodPointDist[i].length);
            sceVu0SubVector(actual, RodPoint[i + 1].pos, RodPoint[i].pos);
            sceVu0SubVector(error, desired, actual);
            sceVu0ScaleVector(error, error, RodPointDist[i].stiffness);
            mgAddVector(actual, error);
            sceVu0Normalize(actual, actual);
            sceVu0ScaleVector(actual, actual, RodPointDist[i].length);
            sceVu0AddVector(RodPoint[i + 1].pos, RodPoint[i].pos, actual);
        }
    }
    if (BattleFlag != 0) {
        for (int pass = 0; pass < 4; pass++) {
            sceVu0CopyVector(hari->point[0].pos, FishPoint.pos);
            sceVu0CopyVector(hari->point[0].old_pos, FishPoint.pos);
            mgZeroVector(hari->point[0].velo);
            sceVu0CopyVector(LinePoint[63].pos, FishPoint.pos);
            sceVu0CopyVector(LinePoint[63].old_pos, FishPoint.pos);
            mgZeroVector(LinePoint[63].velo);
            hari->BindStep();
            if (uki != 0) {
                sceVu0FVECTOR float_pos;
                sceVu0SubVector(float_pos, FishPoint.pos, RodPoint[4].pos);
                sceVu0Normalize(float_pos, float_pos);
                sceVu0ScaleVector(float_pos, float_pos, 15.0f);
                sceVu0SubVector(float_pos, FishPoint.pos, float_pos);
                sceVu0CopyVector(LinePoint[60].pos, float_pos);
                sceVu0CopyVector(LinePoint[60].old_pos, float_pos);
                mgZeroVector(LinePoint[60].velo);
                sceVu0CopyVector(uki->point[0].pos, float_pos);
                sceVu0CopyVector(uki->point[0].old_pos, float_pos);
                mgZeroVector(uki->point[0].velo);
                uki->BindStep();
            }
        }
    } else {
        sceVu0CopyVector(LinePoint[LineTop].pos, RodPoint[4].pos);
        sceVu0CopyVector(LinePoint[LineTop].old_pos, RodPoint[4].pos);
        mgZeroVector(LinePoint[LineTop].velo);
        BindFishObj();
    }
    for (int i = 1; i < 5; i++) {
        sceVu0SubVector(RodPoint[i].velo, RodPoint[i].pos, RodPoint[i].old_pos);
        sceVu0ScaleVector(RodPoint[i].velo, RodPoint[i].velo, 0.6f);
        RodPoint[i].velo[1] -= 0.6f;
        RodPoint[i].pos[3] = 1.0f;
    }

    // Move the model's seven flexible rod joints along the solved rod curve.
    sceVu0FVECTOR curve[5];
    for (int i = 0; i < 5; i++) {
        sceVu0CopyVector(curve[i], RodPoint[i].pos);
    }
    for (int i = 1; i < 8; i++) {
        mgCFrame *joint = SaoFrame[i];
        mgCFrame *parent = joint->parent;
        sceVu0FMATRIX joint_matrix;
        sceVu0FMATRIX parent_world;
        sceVu0FMATRIX parent_inverse;
        sceVu0FMATRIX parent_basis;
        sceVu0FVECTOR before;
        sceVu0FVECTOR after;
        sceVu0FVECTOR forward;
        sceVu0CopyMatrix(joint_matrix, joint->trans_matrix);
        parent->GetLWMatrix(parent_world);
        mgInversMatrix(parent_inverse, parent_world);
        sceVu0CopyMatrix(parent_basis, parent->trans_matrix);
        float fraction = SaoDist[i] / SaoDist[7];
        ParaBlend(before, 0.99f * SaoDist[i - 1] / SaoDist[7], curve, 5);
        before[3] = 1.0f;
        ParaBlend(after, 0.99f * fraction, curve, 5);
        sceVu0SubVector(forward, after, before);
        forward[3] = 0.0f;
        sceVu0ApplyMatrix(joint_matrix[0], parent_inverse, forward);
        if (i != 1) {
            sceVu0ApplyMatrix(joint_matrix[3], parent_inverse, before);
        }
        sceVu0OuterProduct(joint_matrix[2], joint_matrix[0], parent_basis[0]);
        sceVu0OuterProduct(joint_matrix[1], joint_matrix[2], joint_matrix[0]);
        sceVu0Normalize(joint_matrix[0], joint_matrix[0]);
        sceVu0Normalize(joint_matrix[1], joint_matrix[1]);
        sceVu0Normalize(joint_matrix[2], joint_matrix[2]);
        joint->SetTransMatrix(joint_matrix);
    }

    for (int axis = 0; axis < 3; axis++) {
        line_box.max[axis] += 20.0f;
        line_box.min[axis] -= 20.0f;
    }
    line_box.max[3] = 1.0f;
    line_box.min[3] = 1.0f;
    int poly_count = scene->GetColPoly(polys, line_box, 1024);
    for (int i = 0; i < poly_count; i++) {
        if (polys[i].area_kind == 7) {
            polys[i].ignore_mask |= 8;
        }
    }
    for (int i = LineTop; i < 64; i++) {
        int previous = i - 1 < LineTop ? LineTop : i - 1;
        int following = i + 1 > 63 ? 63 : i + 1;
        float heights[3] = {LinePoint[i].pos[1], LinePoint[previous].pos[1], LinePoint[following].pos[1]};
        for (int first = 0; first < 2; first++) {
            for (int second = first + 1; second < 3; second++) {
                if (heights[first] < heights[second]) {
                    float exchange = heights[first];
                    heights[first] = heights[second];
                    heights[second] = exchange;
                }
            }
        }
        sceVu0FVECTOR from;
        sceVu0FVECTOR to;
        sceVu0FVECTOR hit;
        sceVu0CopyVector(from, LinePoint[i].pos);
        sceVu0CopyVector(to, LinePoint[i].pos);
        from[1] = heights[0] + 4.0f;
        to[1] = heights[2] - 1.0f;
        float damping = 0.95f;
        if (CheckHit(polys, poly_count, from, to, hit, 1, 9) >= 0 && hit[1] + 1.0f >= LinePoint[i].pos[1]) {
            LinePoint[i].pos[1] += 0.4f * (hit[1] + 1.0f - LinePoint[i].pos[1]);
            damping = 0.95f * (i == 63 ? 0.05f : 0.1f);
        }
        sceVu0SubVector(LinePoint[i].velo, LinePoint[i].pos, LinePoint[i].old_pos);
        sceVu0ScaleVector(LinePoint[i].velo, LinePoint[i].velo, damping);
    }
    if (CastingLureTime <= 0) {
        EndCastingLure();
    }
    if (CastingLureFlag != 0) {
        sceVu0CopyVector(LinePoint[63].pos, FlyingPoint.pos);
        if (LineTop < 62) {
            sceVu0ScaleVector(LinePoint[62].pos, FlyingPoint.velo, 0.8f);
        }
        if (LineTop < 61) {
            sceVu0ScaleVector(LinePoint[61].pos, FlyingPoint.velo, 0.5f);
        }
    }
    hari->Correct(polys, poly_count, LureLessFlag == 0 ? 1.0f : 0.4f);
    if (uki != 0) {
        uki->Correct(polys, poly_count, 1.0f);
    }
    float water = GetWaterLevel();
    for (int i = LineTop; i < 64; i++) {
        if (uki != 0 && i == 60) {
            continue;
        }
        if (i == 63) {
            continue;
        }
        FISH_POINT &point = LinePoint[i];
        if (point.pos[1] < water) {
            float lift = water - point.pos[1];
            if (lift > 0.61f) {
                lift = 0.61f;
            }
            if (point.pos[1] < water - 0.05f) {
                point.velo[0] *= 0.1f;
                point.velo[1] *= 0.1f;
                point.velo[2] *= 0.1f;
            }
            point.velo[1] += lift;
        }
    }
    hari->FloatPoint(water);
    if (uki != 0) {
        uki->FloatPoint(water);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", RodStep__FP6CSceneP1);
#endif
extern "C" void BindPosition__FPfPfff__2(float *a, float *b, float length, float rate) {
    float delta[4];
    float move_a[4];
    float move_b[4];

    sceVu0SubVector(delta, a, b);
    float dist = mgDistVector(delta);
    float excess = dist - length;
    sceVu0ScaleVector(move_a, delta, ((1.0f - rate) * excess) / dist);
    sceVu0ScaleVector(move_b, delta, (rate * excess) / dist);
    mgSubVector(a, move_a);
    mgAddVector(b, move_b);
}
void DrawFishingLine(void) {
    float start[4];
    float end[4];
    float delta[4];
    mgCDrawPrim prim;
    int screen_a[4];
    int screen_b[4];
    int i;
    int ok;
    FISH_POINT *point;
    *(u_long128 *)start = *(u_long128 *)(RodPoint + kRodTipIndex);
    *(u_long128 *)delta = *(u_long128 *)(RodPoint + kRodNearTipIndex);
    sceVu0SubVector(delta, delta, start);
    sceVu0ScaleVector(delta, delta, 0.1f);
    mgAddVector(start, delta);
    *(u_long128 *)end = *(u_long128 *)&FishPoint.pos;
    start[3] = 1.0f;
    end[3] = 1.0f;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.AlphaBlendEnable(1);
    prim.ZMask(1);
    prim.TextureMapEnable(0);
    prim.Begin(1);
    prim.Color(0xDC, 0xDC, 0xDC, 0x10);
    if (BattleFlag != 0) {
        ok = mgTransWorldScreen(screen_a, start);
        ok &= mgTransWorldScreen(screen_b, end);
        if (ok) {
            prim.Vertex4(screen_a);
            prim.Vertex4(screen_b);
        }
    } else {
        ok = mgTransWorldScreen(screen_a, start);
        LinePoint[LineTop + 1].pos[3] = 1.0f;
        ok &= mgTransWorldScreen(screen_b, LinePoint[LineTop + 1].pos);
        if (ok) {
            prim.Vertex4(screen_a);
            prim.Vertex4(screen_b);
        }
        for (i = LineTop + 1; i < kLinePointNum - 1; i++) {
            LinePoint[i].pos[3] = 1.0f;
            point = &LinePoint[i];
            ok = mgTransWorldScreen(screen_a, point->pos);
            LinePoint[i + 1].pos[3] = 1.0f;
            ok &= mgTransWorldScreen(screen_b, LinePoint[i + 1].pos);
            if (ok) {
                if (point->pos[1] < GetWaterLevel()) {
                    prim.Color(0xDC, 0xDC, 0xDC, 0);
                }
                prim.Vertex4(screen_a);
                if (LinePoint[i + 1].pos[1] < GetWaterLevel()) {
                    prim.Color(0xDC, 0xDC, 0xDC, 0);
                }
                prim.Vertex4(screen_b);
            }
        }
    }
    prim.End();
}
void DrawFishingActionChance(void) {
    mgCTextureManager *textures = &mgTexManager;
    float start[4];
    float end[4];
    float mid[4];
    float delta[4];
    mgCDrawPrim prim;
    float to_end[4];
    int top_left[4];
    int bottom_right[4];
    *(u_long128 *)start = *(u_long128 *)(RodPoint + kRodTipIndex);
    *(u_long128 *)delta = *(u_long128 *)(RodPoint + kRodNearTipIndex);
    sceVu0SubVector(delta, delta, start);
    sceVu0ScaleVector(delta, delta, 0.1f);
    mgAddVector(start, delta);
    *(u_long128 *)end = *(u_long128 *)&FishPoint.pos;
    start[3] = 1.0f;
    end[3] = 1.0f;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.AlphaBlendEnable(1);
    prim.ZMask(1);
    prim.TextureMapEnable(0);
    if (BattleFlag != 0 && ActionChanceCnt > 0) {
        sceVu0SubVector(to_end, start, end);
        sceVu0ScaleVector(to_end, to_end, (WaterLevel - end[1]) / to_end[1]);
        sceVu0AddVector(mid, end, to_end);
        mid[3] = 1.0f;
        if (mgTransWorldPrim3DSprite(top_left, bottom_right, mid, 10.0f, 10.0f, 0) != 0) {
            int cx = (top_left[0] + bottom_right[0]) / 2;
            int cy = (top_left[1] + bottom_right[1]) / 2;
            bottom_right[0] = cx + 0x100;
            bottom_right[1] = cy + 0xE0;
            top_left[0] = cx - 0x100;
            top_left[1] = cy - 0xE0;
            prim.DepthTestEnable(0);
            prim.TextureMapEnable(1);
            prim.Coord(1);
            prim.ZMask(-1);
            prim.Begin(6);
            prim.Color(0x80, 0x80, 0x80, 0x80);
            prim.Texture(textures->GetTexture(at_1503__4, -1));
            if ((int)ActionChanceDir > 0) {
                bottom_right[0] += 0x180;
                top_left[0] += 0x180;
                prim.TextureCrd(0x1A, 0x16);
                prim.Vertex4(top_left);
                prim.TextureCrd(0x34, 0x2C);
                prim.Vertex4(bottom_right);
            }
            if ((int)ActionChanceDir < 0) {
                bottom_right[0] -= 0x180;
                top_left[0] -= 0x180;
                prim.TextureCrd(0, 0x16);
                prim.Vertex4(top_left);
                prim.TextureCrd(0x1A, 0x2C);
                prim.Vertex4(bottom_right);
            }
            prim.End();
        }
    }
}
void InitLureObj(int rod_type, mgCFrame *rod_frame) {
    float tip_pos[4];
    float sao_pos[4];
    float lure_dist;
    int i;
    int j;

    memset(&LureObj, 0, sizeof(CFishObj));
    LureLessFlag = 0;
    if (rod_type < 0 || rod_frame == NULL) {
        LureObj.point[0].pos[0] = 0.0f;
        LureLessFlag = 1;
        LureObj.point_num = 1;
        LureObj.point[0].pos[3] = 1.0f;
        LureObj.point[0].pos[1] = 0.0f;
        LureObj.point[0].pos[2] = 0.0f;
        return;
    }
    rod_frame->SetPosition(0.0f, 0.0f, 0.0f);
    rod_frame->SetRotation(0.0f, 0.0f, 0.0f);
    mgCFrame *tip_frame = rod_frame->SearchFrame(at_1564);
    lure_dist = 4.0f;
    if (rod_type == 0 && tip_frame != NULL) {
        tip_frame->GetWorldPosition0(tip_pos);
        lure_dist = mgDistVector(tip_pos);
    }
    LureObj.point_num = 5;
    for (i = 0; i < LureObj.point_num; i++) {
        FISH_POINT *point = &LureObj.point[i];
        mgZeroVector(point->pos);
        mgZeroVector(point->old_pos);
        mgZeroVector(point->velo);
    }
    LureObj.point[0].pos[0] = 0.0f;
    LureObj.point[0].pos[1] = 0.0f;
    LureObj.point[0].pos[2] = 0.0f;
    LureObj.point[0].pos[3] = 1.0f;
    LureObj.point[1].pos[0] = 0.0f;
    LureObj.point[1].pos[1] = 0.0f;
    LureObj.point[1].pos[2] = lure_dist;
    LureObj.point[1].pos[3] = 1.0f;
    LureObj.point[2].pos[0] = 0.0f;
    LureObj.point[2].pos[1] = -1.0f;
    LureObj.point[2].pos[2] = 0.5f * lure_dist;
    LureObj.point[2].pos[3] = 1.0f;
    LureObj.point[3].pos[0] = 0.0f;
    LureObj.point[3].pos[1] = 1.0f;
    LureObj.point[3].pos[3] = 1.0f;
    LureObj.point[4].pos[3] = 1.0f;
    LureObj.point[3].pos[2] = 2.0f + lure_dist;
    LureObj.point[4].pos[2] = 2.0f + lure_dist;
    LureObj.point[4].pos[0] = 0.0f;
    LureObj.point[4].pos[1] = -1.0f;
    float *pt1 = LureObj.point[1].pos;
    float dist = mgDistVector(LureObj.point[0].pos, pt1);
    LureObj.bind[0].point1 = (FISH_POINT *)pt1;
    LureObj.bind[0].point0 = (FISH_POINT *)LureObj.point[0].pos;
    LureObj.bind[0].length = dist;
    LureObj.bind[0].rate = 0.5f;
    float *pt2 = LureObj.point[2].pos;
    dist = mgDistVector(pt1, pt2);
    LureObj.bind[1].point0 = (FISH_POINT *)pt1;
    LureObj.bind[1].rate = 0.5f;
    LureObj.bind[1].point1 = (FISH_POINT *)pt2;
    LureObj.bind[1].length = dist;
    dist = mgDistVector(LureObj.point[0].pos, pt2);
    LureObj.bind[2].point0 = (FISH_POINT *)LureObj.point[0].pos;
    LureObj.bind[2].rate = 0.5f;
    LureObj.bind[2].point1 = (FISH_POINT *)pt2;
    LureObj.bind[2].length = dist;
    float *pt3 = LureObj.point[3].pos;
    dist = mgDistVector(pt1, pt3);
    LureObj.bind[3].point0 = (FISH_POINT *)pt1;
    LureObj.bind[3].rate = 0.5f;
    LureObj.bind[3].point1 = (FISH_POINT *)pt3;
    LureObj.bind[3].length = dist;
    float *pt4 = LureObj.point[4].pos;
    dist = mgDistVector(pt1, pt4);
    LureObj.bind[4].point0 = (FISH_POINT *)pt1;
    LureObj.bind[4].rate = 0.5f;
    LureObj.bind[4].point1 = (FISH_POINT *)pt4;
    LureObj.bind[4].length = dist;
    dist = mgDistVector(pt3, pt4);
    LureObj.bind[5].point0 = (FISH_POINT *)pt3;
    LureObj.bind[5].point1 = (FISH_POINT *)pt4;
    LureObj.bind[5].length = dist;
    LureObj.bind[5].rate = 0.5f;
    LureObj.bind_num = 6;
    LureObj.float_num = 2;
    LureObj.float_info[0].point1 = (FISH_POINT *)LureObj.point[0].pos;
    LureObj.float_info[1].point1 = (FISH_POINT *)pt1;
    LureObj.float_info[0].point0 = (FISH_POINT *)pt2;
    LureObj.float_info[1].point0 = (FISH_POINT *)pt2;
    LureObj.float_info[0].buoyancy = 2.5f;
    LureObj.float_info[1].buoyancy = 2.5f;
    LureObj.float_info[0].unk_8 = 0.0f;
    LureObj.float_info[1].unk_8 = 0.0f;
    SaoFrame[kSaoWeaponFrameIndex]->GetWorldPosition0(sao_pos);
    for (j = 0; j < LureObj.point_num; j++) {
        mgAddVector(LureObj.point[j].pos, sao_pos);
    }
}
#ifdef NONMATCHING
void InitUkiObj(int no, mgCFrame *uki, mgCFrame *hari) {
    sceVu0FVECTOR rod_tip;
    SaoFrame[7]->GetWorldPosition0(rod_tip);

    UkiObj.point_num = 4;
    for (int i = 0; i < UkiObj.point_num; i++) {
        mgZeroVector(UkiObj.point[i].pos);
        mgZeroVector(UkiObj.point[i].old_pos);
        mgZeroVector(UkiObj.point[i].velo);
    }
    SetObjectPoint(UkiObj.point[0], 0.0f, 2.0f, 0.0f);
    SetObjectPoint(UkiObj.point[1], 0.0f, -1.5f, 3.0f);
    SetObjectPoint(UkiObj.point[2], 2.5980763f, -1.5f, -1.5f);
    SetObjectPoint(UkiObj.point[3], -2.5980763f, -1.5f, -1.5f);
    for (int i = 0; i < UkiObj.point_num; i++) {
        mgAddVector(UkiObj.point[i].pos, rod_tip);
    }
    SetObjectBind(UkiObj.bind[0], UkiObj.point[0], UkiObj.point[1]);
    SetObjectBind(UkiObj.bind[1], UkiObj.point[0], UkiObj.point[2]);
    SetObjectBind(UkiObj.bind[2], UkiObj.point[0], UkiObj.point[3]);
    SetObjectBind(UkiObj.bind[3], UkiObj.point[1], UkiObj.point[2]);
    SetObjectBind(UkiObj.bind[4], UkiObj.point[2], UkiObj.point[3]);
    SetObjectBind(UkiObj.bind[5], UkiObj.point[3], UkiObj.point[1]);
    UkiObj.bind_num = 6;
    UkiObj.float_num = 3;
    for (int i = 0; i < UkiObj.float_num; i++) {
        UkiObj.float_info[i].point0 = &UkiObj.point[i + 1];
        UkiObj.float_info[i].point1 = &UkiObj.point[0];
        UkiObj.float_info[i].unk_8 = 0;
        UkiObj.float_info[i].buoyancy = 1.6f;
    }

    HariObj.point_num = 3;
    for (int i = 0; i < HariObj.point_num; i++) {
        mgZeroVector(HariObj.point[i].pos);
        mgZeroVector(HariObj.point[i].old_pos);
        mgZeroVector(HariObj.point[i].velo);
    }
    SetObjectPoint(HariObj.point[0], 0.0f, 0.0f, 0.0f);
    SetObjectPoint(HariObj.point[1], 1.0f, -4.0f, 0.0f);
    SetObjectPoint(HariObj.point[2], -1.0f, -4.0f, 0.0f);
    for (int i = 0; i < HariObj.point_num; i++) {
        mgAddVector(HariObj.point[i].pos, rod_tip);
    }
    SetObjectBind(HariObj.bind[0], HariObj.point[0], HariObj.point[1]);
    SetObjectBind(HariObj.bind[1], HariObj.point[0], HariObj.point[2]);
    SetObjectBind(HariObj.bind[2], HariObj.point[1], HariObj.point[2]);
    HariObj.bind_num = 3;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", InitUkiObj__FiP8mgCFrameP8mgCFrame);
#endif
void CFishObj::MovePoint() {
    for (int i = 0; i < point_num; i++) {
        *(u_long128 *)point[i].old_pos = *(u_long128 *)point[i].pos;
        mgAddVector(point[i].pos, point[i].velo);
        point[i].pos[1] -= 0.6f;
    }
}
void CFishObj::FloatPoint(float level) {
    for (int i = 0; i < float_num; i++) {
        float upper = float_info[i].point0->pos[1];
        float lower = float_info[i].point1->pos[1];
        float span = upper - lower;
        float abs_span = span < 0.0f ? -span : span;
        if (abs_span < 0.01f) {
            continue;
        }
        float ratio;
        if (upper > lower) {
            ratio = (level - lower) / (span < 0.0f ? -span : span);
        } else {
            ratio = (level - upper) / (span < 0.0f ? -span : span);
        }
        if (ratio < 0.0f) {
            continue;
        }
        if (!(ratio <= 1.0f)) {
            ratio = 1.0f;
        }

        ((FISH_POINT *)float_info[i].point0)->velo[0] *= 0.3f;
        ((FISH_POINT *)float_info[i].point0)->velo[2] *= 0.3f;
        ((FISH_POINT *)float_info[i].point0)->velo[1] += float_info[i].buoyancy * ratio;
    }
    for (int i = 0; i < point_num; i++) {
        if (point[i].pos[1] < level) {
            point[i].velo[0] *= 0.1f;
            if (point[i].velo[1] < 0.0f) {
                point[i].velo[1] *= 0.1f;
            }
            point[i].velo[2] *= 0.1f;
        }
    }
}
void CFishObj::BindStep() {
    for (int i = 0; i < bind_num; i++) {
        FISH_BIND *constraint = &bind[i];
        BindPosition__FPfPfff__2(constraint->point0->pos, constraint->point1->pos, constraint->length, constraint->rate);
    }
}
#ifdef NONMATCHING
void CFishObj::Correct(CCPoly *poly, int poly_num, float damping) {
    for (int i = 0; i < point_num; i++) {
        FISH_POINT &current = point[i];
        float upper = current.pos[1] > current.old_pos[1] ? current.pos[1] : current.old_pos[1];
        float lower = current.pos[1] < current.old_pos[1] ? current.pos[1] : current.old_pos[1];
        sceVu0FVECTOR from;
        sceVu0FVECTOR to;
        sceVu0FVECTOR hit;
        sceVu0FVECTOR correction;
        mgZeroVector(correction);
        sceVu0CopyVector(from, current.pos);
        sceVu0CopyVector(to, current.pos);
        from[1] = upper + 4.0f;
        to[1] = lower - 1.0f;
        int hit_poly = CheckHit(poly, poly_num, from, to, hit, 1, 9);
        float friction = 0.95f;
        if (hit_poly >= 0 && current.pos[1] < hit[1] + 1.0f) {
            correction[1] = -current.velo[1] * 0.5f;
            current.pos[1] += hit[1] + 1.0f - current.pos[1];
            friction = 0.19f;
        }
        sceVu0SubVector(current.velo, current.pos, current.old_pos);
        sceVu0ScaleVector(current.velo, current.velo, friction * damping);
        mgAddVector(current.velo, correction);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", Correct__8CFishObjFP6CCPolyif);
#endif
void ParaBlend(float *out, float t, float (*point)[4], int count) {
    Matrix4 basis;
    Matrix4 geometry;
    float powers[4];
    float step = 1.0f / (float)(count - 1);
    int cur = fptosi(t / step);
    int prev;
    int next;
    int next2;
    next = cur + 1;
    prev = cur - 1;
    next2 = next + 1;
    float local = t - (float)cur * step;
    local *= (float)(count - 1);
    if (prev < 0) {
        prev = 0;
    }
    if (cur >= count) {
        cur = count - 1;
    }
    if (next >= count) {
        next = count - 1;
    }
    if (next2 >= count) {
        next2 = count - 1;
    }
    basis = at_1797;
    sceVu0TransposeMatrix(basis.m, basis.m);
    *(u_long128 *)geometry.m[0] = *(u_long128 *)point[prev];
    geometry.m[0][3] = 0.0f;
    *(u_long128 *)geometry.m[1] = *(u_long128 *)point[cur];
    geometry.m[1][3] = 0.0f;
    *(u_long128 *)geometry.m[2] = *(u_long128 *)point[next];
    geometry.m[2][3] = 0.0f;
    *(u_long128 *)geometry.m[3] = *(u_long128 *)point[next2];
    geometry.m[3][3] = 0.0f;
    sceVu0TransposeMatrix(geometry.m, geometry.m);
    mgMulMatrix(basis.m, basis.m, geometry.m);
    sceVu0TransposeMatrix(basis.m, basis.m);
    *(u_long128 *)powers = *(u_long128 *)at_1798;
    float square = local * local;
    powers[0] = local * square;
    powers[1] = square;
    powers[2] = local;
    sceVu0ScaleVector(powers, powers, 0.5f);
    sceVu0ApplyMatrix(out, basis.m, powers);
}

// Static initialiser (.init)
#ifdef NONMATCHING
extern "C" void __sinit_fishingobj_cpp() {
    memset(&LureObj, 0, sizeof(LureObj));
    memset(&UkiObj, 0, sizeof(UkiObj));
    memset(&HariObj, 0, sizeof(HariObj));
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", __sinit_fishingobj_cpp);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_975__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_985__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_986__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_1797__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_1798__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_896__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_897__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_898__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_899__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_900__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_901__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_902__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_903__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_1503__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", at_1564__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishingobj", D_0037B08C__DATA);

// Small uninitialised data (.sbss)
#ifndef NONMATCHING
INCLUDE_BSS(WaterLevel, 0x4);
INCLUDE_BSS(LineTop, 0x4);
INCLUDE_BSS(LineTopDist, 0x4);
INCLUDE_BSS(CastingLureFlag, 0x4);
INCLUDE_BSS(CastingLureTime, 0x4);
INCLUDE_BSS(AddLineSpeed, 0x4);
INCLUDE_BSS(BattleFlag, 0x4);
INCLUDE_BSS(BattleLineDist, 0x4);
INCLUDE_BSS(ShowHari, 0x4);
INCLUDE_BSS(LureLessFlag, 0x4);
INCLUDE_BSS(NowMode, 0x4);
INCLUDE_BSS(NowFishSpeed, 0x4);
INCLUDE_BSS(NowFishRot, 0x4);
INCLUDE_BSS(ActionChanceNextCnt, 0x4);
INCLUDE_BSS(ActionChanceCnt, 0x4);
INCLUDE_BSS(ActionChanceDir, 0x4);
#endif

// Uninitialised data (.bss)
#ifndef NONMATCHING
INCLUDE_BSS(RodPoint, 0xF0);
INCLUDE_BSS(RodPointDist, 0x50);
INCLUDE_BSS(SaoFrame, 0x20);
INCLUDE_BSS(SaoDist, 0x20);
INCLUDE_BSS(LinePoint, 0xC00);
INCLUDE_BSS(LurePoint, 0x90);
INCLUDE_BSS(FlyingPoint, 0x30);
INCLUDE_BSS(FishPoint, 0x30);
INCLUDE_BSS(CastingPoint, 0x10);
INCLUDE_BSS(ReleasePoint, 0x10);
INCLUDE_BSS(BattleStartPos, 0x10);
INCLUDE_BSS(LureObj, 0x3D0);
INCLUDE_BSS(UkiObj, 0x3D0);
INCLUDE_BSS(HariObj, 0x3D0);
INCLUDE_BSS(ChanceBarPos, 0x10);
#endif
