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
void GetTriPose(float (*matrix)[4], float (*tri)[4], int *order);

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", InitRodPoint__FP8mgCFrameP8mgCFrame);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", GetTriPose__FPA4_fPA4_fPi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", SlowLineVelo__Ff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", ResetLineVelo__Fv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", FishBattle__FP6CSceneP6CCPolyi);
void GetFishPosVelo(float *pos, float *velo) {
    u_long128 v = *(volatile u_long128 *)&FishPoint.pos;
    *(u_long128 *)pos = v;
    *(u_long128 *)velo = *(volatile u_long128 *)&FishPoint.velo;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", BindFishObj__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", RodStep__FP6CSceneP1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", InitUkiObj__FiP8mgCFrameP8mgCFrame);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", Correct__8CFishObjFP6CCPolyif);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishingobj", __sinit_fishingobj_cpp);

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

// Uninitialised data (.bss)
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
