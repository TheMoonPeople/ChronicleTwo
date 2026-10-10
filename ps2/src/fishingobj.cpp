#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "fishingobj.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "scene.hpp"

void        ParaBlend(float *out, float t, float (*points)[4], int count);
static void BindPosition(float *point0, float *point1, float length, float rate);

const int kLinePointNum = 64;
const int kUkiPointIndex = 60;
const int kRodTipIndex = 4;
const int kRodNearTipIndex = 3;
const int kSaoWeaponFrameIndex = 7;

/**
 *
 * Three integer axis values used by the fishing line.
 *
 */
struct TriAxis {
    int v[3]; /**< Axis values. */
};

/**
 *
 * Four by four transform matrix used by fishing objects.
 *
 */
struct Matrix4 {
    float m[4][4]; /**< Matrix rows. */
};

/**
 *
 * Height of the fishing water surface.
 *
 */
static float WaterLevel;

/**
 *
 * First point in the paid-out fishing line.
 *
 */
static int LineTop;

/**
 *
 * Length of the first paid-out line segment.
 *
 */
static float LineTopDist;

/**
 *
 * Whether the tackle is following a cast trajectory.
 *
 */
static int CastingLureFlag;

/**
 *
 * Remaining frames of tackle casting.
 *
 */
static int CastingLureTime;

/**
 *
 * Extra line payout requested during a cast.
 *
 */
static int AddLineSpeed;

/**
 *
 * Whether a hooked fish is being fought.
 *
 */
static int BattleFlag;

/**
 *
 * Length of line available during a fish battle.
 *
 */
static float BattleLineDist;

/**
 *
 * Whether the hook model is visible.
 *
 */
static int ShowHari;

/**
 *
 * Whether lure physics should omit the lure model.
 *
 */
static int LureLessFlag;

/**
 *
 * Current FishingMode value.
 *
 */
static int NowMode;

/**
 *
 * Current hooked fish movement speed.
 *
 */
static int NowFishSpeed;

/**
 *
 * Current hooked fish heading.
 *
 */
static float NowFishRot;

/**
 *
 * Frames until the next directional rod prompt.
 *
 */
static int ActionChanceNextCnt;

/**
 *
 * Remaining frames of the active rod prompt.
 *
 */
static int ActionChanceCnt;

/**
 *
 * Direction requested by the active rod prompt.
 *
 */
static int ActionChanceDir;

/**
 *
 * Five masses along the flexible fishing rod.
 *
 */
static FISH_POINT RodPoint[5];

/**
 *
 * Rest lengths and motion weights for the rod masses.
 *
 */
static FISH_ROD_SEGMENT RodPointDist[5];

/**
 *
 * Eight model joints along the fishing rod.
 *
 */
static mgCFrame *SaoFrame[8];

/**
 *
 * Distances of rod model joints from the rod root.
 *
 */
static float SaoDist[8];

/**
 *
 * Masses along the paid-out fishing line.
 *
 */
static FISH_POINT LinePoint[64];

/**
 *
 * Additional masses used by lure motion.
 *
 */
static FISH_POINT LurePoint[3];

/**
 *
 * Tackle endpoint following a cast trajectory.
 *
 */
static FISH_POINT FlyingPoint;

/**
 *
 * Hooked fish mass during a battle.
 *
 */
static FISH_POINT FishPoint;

/**
 *
 * Starting point of the current tackle cast.
 *
 */
static float CastingPoint[4];

/**
 *
 * Target point used when releasing the fishing line.
 *
 */
static float ReleasePoint[4];

/**
 *
 * Hook position when the current fish battle starts.
 *
 */
static sceVu0FVECTOR BattleStartPos;

/**
 *
 * Point and constraint state of the fishing lure.
 *
 */
static CFishObj LureObj;

/**
 *
 * Point and constraint state of the fishing float.
 *
 */
static CFishObj UkiObj;

/**
 *
 * Point and constraint state of the fishing hook.
 *
 */
static CFishObj HariObj;

/**
 *
 * World position of the directional rod prompt.
 *
 */
static sceVu0FVECTOR ChanceBarPos;
#include <libvu0.h>

#include "dng_main.hpp"
#include "gameutil.hpp"
#include "scenesnd.hpp"

// Code (.text)
void SetFishingMode(int value) {
    NowMode = value;
}

int GetFishingMode() {
    return NowMode;
}

void SetWaterLevel(float value) {
    WaterLevel = value;
}

float GetWaterLevel() {
    return WaterLevel;
}

/**
 *
 * Returns the active hook or lure physics object for the fishing mode.
 *
 */
CFishObj *GetActiveHariObj() {
    if (NowMode == 2) {
        return &LureObj;
    }

    return &HariObj;
}

/**
 *
 * Returns the float physics object when bait fishing is active.
 *
 */
CFishObj *GetActiveUkiObj() {
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
                *(u_long128 *) point->pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
                *(u_long128 *) point->old_pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
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

float GetNowLineLength() {
    if (BattleFlag != 0) {
        return BattleLineDist;
    }

    float length = 5.0f * (63 - LineTop);
    length += LineTopDist;
    return length;
}

float GetMinLineLength() {
    return 25.0f;
}

void InitRodPoint(mgCFrame *reference, mgCFrame *rod) {
    int i;

    for (i = 0; i < 5; i++) {
        mgZeroVector(RodPoint[i].pos);
        mgZeroVector(RodPoint[i].old_pos);
        mgZeroVector(RodPoint[i].velo);
    }

    for (i = 0; i < 64; i++) {
        mgZeroVector(LinePoint[i].pos);
        mgZeroVector(LinePoint[i].old_pos);
        mgZeroVector(LinePoint[i].velo);
    }

    for (i = 0; i < 3; i++) {
        mgZeroVector(LurePoint[i].pos);
        mgZeroVector(LurePoint[i].old_pos);
        mgZeroVector(LurePoint[i].velo);
    }

    SaoFrame[0] = rod->SearchFrame("sao");
    SaoFrame[1] = rod->SearchFrame("sao2");
    SaoFrame[2] = rod->SearchFrame("sao3");
    SaoFrame[3] = rod->SearchFrame("sao4");
    SaoFrame[4] = rod->SearchFrame("sao5");
    SaoFrame[5] = rod->SearchFrame("sao6");
    SaoFrame[6] = rod->SearchFrame("sao7");
    SaoFrame[7] = rod->SearchFrame("ito");
    sceVu0FVECTOR span;
    sceVu0FVECTOR root;
    sceVu0FVECTOR tip;
    sceVu0FVECTOR joint;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR position;
    SaoFrame[0]->GetWorldPosition0(root);
    SaoFrame[7]->GetWorldPosition0(tip);

    for (i = 0; i < 8; i++) {
        SaoFrame[i]->GetWorldPosition0(joint);
        SaoDist[i] = mgDistVector(root, joint);
    }

    sceVu0SubVector(span, tip, root);

    for (i = 0; i < 5; i++) {
        sceVu0ScaleVector(offset, span, (float) i / 4.0f);
        sceVu0AddVector(position, root, offset);
        *(u_long128 *) RodPoint[i].pos = *(u_long128 *) position;
        *(u_long128 *) RodPoint[i].old_pos = *(u_long128 *) position;
        mgZeroVector(RodPoint[i].velo);

        if (i > 0) {
            RodPointDist[i - 1].length = mgDistVector(RodPoint[i].pos, RodPoint[i - 1].pos);
        }

        RodPointDist[i].stiffness = ((float) (5 - i) * 0.3f) / 5.0f + 0.3f;

        if (RodPointDist[i].stiffness > 1.0f) {
            RodPointDist[i].stiffness = 1.0f;
        }

        RodPointDist[i].damping = ((float) (5 - i) * 0.2f) / 5.0f + 0.2f;
    }

    ResetLine(tip);
    LineTop = 59;
    LineTopDist = 5.0f;
    EndCastingLure();
    BattleFlag = 0;
    NowMode = FISHING_MODE_BAIT;
    ShowHari = 1;
}

static void GetTriPose(sceVu0FMATRIX pose, sceVu0FVECTOR points[3], int axes[3]) {
    float first[4];
    float second[4];
    float third[4];
    *(u_long128 *) first = *(u_long128 *) points[0];
    *(u_long128 *) second = *(u_long128 *) points[1];
    *(u_long128 *) third = *(u_long128 *) points[2];
    float(*matrix)[4] = pose;
    float first_value = (float) axes[0];
    first_value = first_value < 0.0f ? -first_value : first_value;
    int   first_axis = (int) first_value;
    float second_value = (float) axes[1];
    second_value = second_value < 0.0f ? -second_value : second_value;
    int   second_axis = (int) second_value;
    float normal_value = (float) axes[2];
    normal_value = normal_value < 0.0f ? -normal_value : normal_value;
    int normal_axis = (int) normal_value;
    sceVu0SubVector(matrix[first_axis], second, first);
    sceVu0Normalize(matrix[first_axis], matrix[first_axis]);
    mgPlaneNormal(matrix[normal_axis], first, second, third);
    sceVu0Normalize(matrix[normal_axis], matrix[normal_axis]);
    sceVu0OuterProduct(matrix[second_axis], matrix[normal_axis], matrix[first_axis]);
    sceVu0Normalize(matrix[0], matrix[0]);
    sceVu0Normalize(matrix[1], matrix[1]);
    sceVu0Normalize(matrix[2], matrix[2]);

    if (axes[0] < 0) {
        sceVu0ScaleVector(matrix[first_axis], matrix[first_axis], -1.0f);
    }

    if (axes[1] < 0) {
        sceVu0ScaleVector(matrix[second_axis], matrix[second_axis], -1.0f);
    }

    if (axes[2] < 0) {
        sceVu0ScaleVector(matrix[normal_axis], matrix[normal_axis], -1.0f);
    }
}

void GetHariPos(float *pos, float *old_pos) {
    *(u_long128 *) pos = *(u_long128 *) LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *) old_pos = *(u_long128 *) LinePoint[kLinePointNum - 1].old_pos;
}

void GetUkiPos(float *pos, float *old_pos) {
    *(u_long128 *) pos = *(u_long128 *) LinePoint[kUkiPointIndex].pos;
    *(u_long128 *) old_pos = *(u_long128 *) LinePoint[kUkiPointIndex].old_pos;
}

void PullUki(float amount) {
    LinePoint[kLinePointNum - 1].velo[1] = LinePoint[kLinePointNum - 1].velo[1] - amount;
}

void SetShowHari(int value) {
    ShowHari = value;
}

int GetShowHari() {
    float pos[4];
    float old_pos[4];

    GetHariPos(pos, old_pos);
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

    if (frame == NULL) {
        return 0;
    }

    if (NowMode == 1) {
        return 0;
    }

    *(u_long128 *) position = *(u_long128 *) &LinePoint[kLinePointNum - 1].pos;
    mgUnitMatrix(matrix);
    *(u_long128 *) tri[0] = *(u_long128 *) &LureObj.point[0].pos;
    *(u_long128 *) tri[1] = *(u_long128 *) &LureObj.point[1].pos;
    *(u_long128 *) tri[2] = *(u_long128 *) &LureObj.point[2].pos;
    TriAxis order = {
        {0, 1, 2}
    };
    GetTriPose(matrix, tri, order.v);
    frame->SetPosition(position);
    frame->SetTransMatrix(matrix);
    return 1;
}

int SetUkiPose(mgCFrame *uki_frame, mgCFrame *hari_frame) {
    float matrix[4][4];
    float position[4];
    float tri[3][4];

    if (uki_frame == NULL || hari_frame == NULL) {
        return 0;
    }

    if (NowMode == 2) {
        return 0;
    }

    *(u_long128 *) position = *(u_long128 *) &LinePoint[kUkiPointIndex].pos;
    mgUnitMatrix(matrix);
    sceVu0AddVector(tri[1], UkiObj.point[1].pos, UkiObj.point[2].pos);
    mgAddVector(tri[1], UkiObj.point[3].pos);
    *(u_long128 *) tri[0] = *(u_long128 *) &UkiObj.point[0].pos;
    sceVu0ScaleVector(tri[1], tri[1], 0.33333334f);
    *(u_long128 *) tri[2] = *(u_long128 *) &UkiObj.point[1].pos;
    TriAxis uki_order = {
        {-1, 2, 0}
    };
    GetTriPose(matrix, tri, uki_order.v);
    uki_frame->SetTransMatrix(matrix);
    uki_frame->SetPosition(position);
    *(u_long128 *) position = *(u_long128 *) &LinePoint[kLinePointNum - 1].pos;
    sceVu0AddVector(tri[1], HariObj.point[1].pos, HariObj.point[2].pos);
    *(u_long128 *) tri[0] = *(u_long128 *) &HariObj.point[0].pos;
    sceVu0ScaleVector(tri[1], tri[1], 0.5f);
    *(u_long128 *) tri[2] = *(u_long128 *) &HariObj.point[2].pos;
    TriAxis hari_order = {
        {-1, 0, 2}
    };
    GetTriPose(matrix, tri, hari_order.v);
    hari_frame->SetTransMatrix(matrix);
    hari_frame->SetPosition(position);
    return 1;
}

int CastingLure(float *target) {
    float start[4];
    float to_target[4];
    *(u_long128 *) &start = *(u_long128 *) &LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *) &CastingPoint = *(u_long128 *) target;
    *(u_long128 *) &ReleasePoint = *(u_long128 *) &start;
    *(u_long128 *) &FlyingPoint.pos = *(u_long128 *) &start;
    *(u_long128 *) &FlyingPoint.old_pos = *(u_long128 *) &start;
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

void EndCastingLure() {
    CastingLureFlag = 0;
    CastingLureTime = 0;
    AddLineSpeed = 0;
}

int CatchLine(float *target, float reach) {
    CFishObj *hari = GetActiveHariObj();
    float     to_target[4];
    float     moved[4];
    sceVu0SubVector(to_target, target, LinePoint[kLinePointNum - 1].pos);

    if (mgDistVector(to_target) < reach) {
        *(u_long128 *) &LinePoint[kLinePointNum - 1].pos = *(u_long128 *) target;
        *(u_long128 *) &LinePoint[kLinePointNum - 1].old_pos = *(u_long128 *) target;
        mgZeroVector(LinePoint[kLinePointNum - 1].velo);

        if (hari != 0) {
            *(u_long128 *) hari->point[0].pos = *(u_long128 *) target;
            *(u_long128 *) hari->point[0].old_pos = *(u_long128 *) target;
            mgZeroVector(hari->point[0].velo);
        }

        return 1;
    }

    sceVu0Normalize(to_target, to_target);
    sceVu0ScaleVector(to_target, to_target, reach);
    sceVu0AddVector(moved, LinePoint[kLinePointNum - 1].pos, to_target);
    *(u_long128 *) &LinePoint[kLinePointNum - 1].pos = *(u_long128 *) moved;
    *(u_long128 *) &LinePoint[kLinePointNum - 1].old_pos = *(u_long128 *) moved;
    mgZeroVector(LinePoint[kLinePointNum - 1].velo);

    if (hari != 0) {
        *(u_long128 *) hari->point[0].pos = *(u_long128 *) moved;
        *(u_long128 *) hari->point[0].old_pos = *(u_long128 *) moved;
        mgZeroVector(hari->point[0].velo);
    }

    return 0;
}

void SlowLineVelo(float rate) {
    for (int i = LineTop; i < 64; i++) {
        sceVu0ScaleVector(LinePoint[i].velo, LinePoint[i].velo, rate);
    }
}

void ResetLineVelo() {
    float top_pos[4];
    *(u_long128 *) top_pos = *(u_long128 *) LinePoint[LineTop].pos;

    for (int i = LineTop; i < 64; i++) {
        float pos[4];
        *(u_long128 *) pos = *(u_long128 *) LinePoint[i].pos;
        pos[0] = top_pos[0];
        pos[2] = top_pos[2];
        *(u_long128 *) LinePoint[i].pos = *(u_long128 *) pos;
        *(u_long128 *) LinePoint[i].old_pos = *(u_long128 *) pos;
        mgZeroVector(LinePoint[i].velo);
    }
}

void ResetLine(float *tip) {
    LineTop = 59;
    FISH_POINT *last = &LinePoint[59];
    *(u_long128 *) &last->pos = *(u_long128 *) tip;
    *(u_long128 *) &last->old_pos = *(u_long128 *) tip;
    mgZeroVector(last->velo);

    for (int i = LineTop + 1; i < kLinePointNum; i++) {
        float pos[4];
        *(u_long128 *) &pos = *(u_long128 *) &LinePoint[i - 1].pos;
        pos[0] = tip[0];
        pos[1] -= 5.0f;
        pos[2] = tip[2];
        *(u_long128 *) &LinePoint[i].pos = *(u_long128 *) &pos;
        *(u_long128 *) &LinePoint[i].old_pos = *(u_long128 *) &pos;
        mgZeroVector(LinePoint[i].velo);
    }

    *(u_long128 *) &LureObj.point[0].pos = *(u_long128 *) &LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *) &LureObj.point[0].old_pos = *(u_long128 *) &LinePoint[kLinePointNum - 1].pos;
    mgZeroVector(LureObj.point[0].velo);
    *(u_long128 *) &UkiObj.point[0].pos = *(u_long128 *) &LinePoint[kUkiPointIndex].pos;
    *(u_long128 *) &UkiObj.point[0].old_pos = *(u_long128 *) &LinePoint[kUkiPointIndex].pos;
    mgZeroVector(UkiObj.point[0].velo);
    *(u_long128 *) &HariObj.point[0].pos = *(u_long128 *) &LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *) &HariObj.point[0].old_pos = *(u_long128 *) &LinePoint[kLinePointNum - 1].pos;
    mgZeroVector(HariObj.point[0].velo);
}

/**
 *
 * Returns a randomized delay until the next fishing action chance.
 *
 */
int GetNextChanceCnt() {
    return (rand() % 80) + 0x3C;
}

int InitFishBattle() {
    *(u_long128 *) BattleStartPos = *(u_long128 *) LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *) FishPoint.pos = *(u_long128 *) LinePoint[kLinePointNum - 1].pos;
    *(u_long128 *) FishPoint.old_pos = *(u_long128 *) LinePoint[kLinePointNum - 1].pos;
    mgZeroVector(FishPoint.velo);
    float dist = mgDistVector(LinePoint[kLinePointNum - 1].pos, RodPoint[kRodTipIndex].pos);
    NowFishSpeed = 0;
    BattleLineDist = dist;
    BattleFlag = 1;
    NowFishRot = 0;
    ActionChanceNextCnt = GetNextChanceCnt();
    ActionChanceCnt = 0;
    return 1;
}

int EndFishBattle() {
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

int FishBattle(CScene *scene, CCPoly *poly_buffer, int poly_max) {
    if (BattleFlag == 0) {
        return 0;
    }

    CCharacter2  *player = scene->GetCharacter(scene->player_chara);
    sceVu0FVECTOR player_rot;
    sceVu0FVECTOR player_pos;
    sceVu0FMATRIX matrix;
    sceVu0FVECTOR float_velo;
    sceVu0FVECTOR heading;
    sceVu0FVECTOR next_pos;
    player->GetPosition(player_pos);
    player->GetRotation(player_rot);
    mgUnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, player_rot[1]);
    float target_angle = player_rot[1] + (mgRnd() - 0.5f) * 2.5132742f;

    if (ActionChanceCnt <= 0) {
        --ActionChanceNextCnt;
        ActionChanceCnt = 0;

        if (ActionChanceNextCnt <= 0) {
            ActionChanceCnt = 30;

            if (rand() % 2 != 0) {
                ActionChanceDir = 1;
            } else {
                ActionChanceDir = -1;
            }
        }
    }

    if (ActionChanceCnt > 0) {
        target_angle = ActionChanceDir > 0 ? player_rot[1] - mgRnd() * 1.2566371f : player_rot[1] + mgRnd() * 1.2566371f;
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
    FishPoint.velo[0] = (float) NowFishSpeed * sinf(NowFishRot);
    FishPoint.velo[2] = (float) NowFishSpeed * cosf(NowFishRot);
    FishPoint.velo[1] = 0.0f;
    FishPoint.pos[1] = WaterLevel - 10.0f;
    *(u_long128 *) heading = *(u_long128 *) matrix[2];
    next_pos[0] = FishPoint.pos[0] + FishPoint.velo[0];
    next_pos[1] = FishPoint.pos[1];
    next_pos[2] = FishPoint.pos[2] + FishPoint.velo[2];
    mgVu0FBOX query_box;
    *(u_long128 *) query_box.max = *(u_long128 *) FishPoint.pos;
    *(u_long128 *) query_box.min = *(u_long128 *) FishPoint.pos;

    for (int axis = 0; axis < 3; axis++) {
        query_box.max[axis] += 100.0f;
        query_box.min[axis] -= 100.0f;
    }

    int           poly_count = scene->GetColPoly(poly_buffer, query_box, poly_max);
    MoveCheckInfo check;
    memset(&check, 0, sizeof(check));
    check.radius = 10.0f;
    MoveCheck(FishPoint.pos, FishPoint.velo, next_pos, &check, poly_buffer, poly_count, 0);
    sceVu0SubVector(heading, next_pos, player_pos);
    sceVu0Normalize(heading, heading);
    sceVu0InnerProduct(heading, matrix[2]);
    FishPoint.pos[0] = next_pos[0];
    FishPoint.pos[2] = next_pos[2];
    return 0;
}

void GetFishPosVelo(float *pos, float *velo) {
    *(u_long128 *) pos = *(u_long128 *) FishPoint.pos;
    *(u_long128 *) velo = *(u_long128 *) FishPoint.velo;
}

/**
 *
 * Solves line, hook, and float distance constraints over four passes.
 *
 */
static void BindFishObj() {
    CFishObj   *hari = GetActiveHariObj();
    CFishObj   *uki = GetActiveUkiObj();
    FISH_POINT *top = &LinePoint[LineTop];
    *(u_long128 *) top->pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
    *(u_long128 *) top->old_pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
    mgZeroVector(top->velo);

    for (int step = 0; step < 4; step++) {
        for (int i = LineTop; i < 63; i++) {
            float rate = 0.5f;

            if (i >= 59) {
                rate = 0.52f;
            }

            float length = 5.0f;

            if (i == LineTop) {
                length = LineTopDist;
            }

            BindPosition(LinePoint[i].pos, LinePoint[i + 1].pos, length, rate);
        }

        if (CastingLureFlag != 0) {
            *(u_long128 *) LinePoint[63].pos = *(u_long128 *) FlyingPoint.pos;
        }

        if (LureLessFlag == 0) {
            float        length_value = 0.0f;
            const float &length = length_value;
            BindPosition(LinePoint[63].pos, hari->point[0].pos, length, 0.45f);
        }

        hari->BindStep();

        if (uki != 0) {
            BindPosition(LinePoint[60].pos, uki->point[0].pos, 0.0f, 0.4f);
            uki->BindStep();
        }

        top = &LinePoint[LineTop];
        *(u_long128 *) top->pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
        *(u_long128 *) top->old_pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
        mgZeroVector(top->velo);
    }
}

void RodStep(CScene *scene, u_long128 *poly_buffer) {
    float         remaining;
    int           i;
    int           pass;
    int           axis;
    CCPoly       *polys;
    CFishObj     *hari = GetActiveHariObj();
    CFishObj     *uki = GetActiveUkiObj();
    sceVu0FVECTOR frame_pos;
    SaoFrame[0]->GetWorldPosition0(frame_pos);
    *(u_long128 *) (RodPoint[0].pos) = *(u_long128 *) (frame_pos);
    *(u_long128 *) (RodPoint[0].old_pos) = *(u_long128 *) (frame_pos);
    mgZeroVector(RodPoint[0].velo);
    SaoFrame[1]->GetWorldPosition0(frame_pos);
    *(u_long128 *) (RodPoint[1].pos) = *(u_long128 *) (frame_pos);
    *(u_long128 *) (RodPoint[1].old_pos) = *(u_long128 *) (frame_pos);
    mgZeroVector(RodPoint[1].velo);

    if (CastingLureFlag != 0) {
        FlyingPoint.velo[1] -= 0.6f;
        float         cast_distance = mgDistVectorXZ(ReleasePoint, CastingPoint);
        float         flown_distance = mgDistVectorXZ(ReleasePoint, FlyingPoint.pos);
        sceVu0FVECTOR flight_step;
        *(u_long128 *) (flight_step) = *(u_long128 *) (FlyingPoint.velo);

        if (cast_distance * 0.8f < flown_distance) {
            float scale = (cast_distance - flown_distance) / (cast_distance * 0.2f);
            flight_step[0] *= scale;
            flight_step[2] *= scale;
            ExtendLine(mgDistVectorXZ(flight_step));
        } else {
            float top_gap = mgDistVector(LinePoint[LineTop].pos, LinePoint[LineTop + 1].pos);

            if (!(top_gap - LineTopDist <= 0.0f)) {
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

        remaining = mgDistVectorXZ(CastingPoint, FlyingPoint.pos);

        if (remaining < mgDistVectorXZ(flight_step)) {
            flight_step[2] = 0.0f;
            flight_step[0] = 0.0f;
            FlyingPoint.velo[2] = 0.0f;
            FlyingPoint.velo[0] = 0.0f;
            FlyingPoint.pos[0] = CastingPoint[0];
            FlyingPoint.pos[2] = CastingPoint[2];
        }

        mgAddVector(FlyingPoint.pos, flight_step);
        *(u_long128 *) (LinePoint[63].pos) = *(u_long128 *) (FlyingPoint.pos);
        *(u_long128 *) (LinePoint[63].old_pos) = *(u_long128 *) (FlyingPoint.pos);
        mgZeroVector(LinePoint[63].velo);
        --CastingLureTime;
    }

    for (i = 2; i < 5; i++) {
        *(u_long128 *) (RodPoint[i].old_pos) = *(u_long128 *) (RodPoint[i].pos);

        if (BattleFlag == 0) {
            mgAddVector(RodPoint[i].pos, RodPoint[i].velo);
        }
    }

    mgVu0FBOX line_box;
    *(u_long128 *) (line_box.max) = *(u_long128 *) (LinePoint[LineTop].pos);
    *(u_long128 *) (line_box.min) = *(u_long128 *) (LinePoint[LineTop].pos);

    for (int i = LineTop; i < 64; i++) {
        *(u_long128 *) (LinePoint[i].old_pos) = *(u_long128 *) (LinePoint[i].pos);
        mgAddVector(LinePoint[i].pos, LinePoint[i].velo);
        LinePoint[i].pos[1] -= 0.36f;
        mgVectorMaxMin(line_box.max, line_box.max + 4, line_box.max, line_box.min, LinePoint[i].pos);
    }

    hari->MovePoint();

    if (uki != 0) {
        uki->MovePoint();
    }

    for (pass = 0; pass < 2; pass++) {
        if (BattleFlag != 0) {
            BindPosition(RodPoint[kRodTipIndex].pos, FishPoint.pos, BattleLineDist, 0.2f);
        } else {
            BindPosition(RodPoint[kRodTipIndex].pos, LinePoint[LineTop].pos, 0.0f, 0.8f);
        }

        for (i = 3; i >= 2; i--) {
            sceVu0FVECTOR across;
            sceVu0FVECTOR half_across;
            sceVu0FVECTOR segment;
            sceVu0FVECTOR bend;
            sceVu0SubVector(across, RodPoint[i + 1].pos, RodPoint[i - 1].pos);
            sceVu0ScaleVector(half_across, across, 0.5f);
            sceVu0SubVector(segment, RodPoint[i].pos, RodPoint[i - 1].pos);
            sceVu0SubVector(bend, half_across, segment);
            sceVu0ScaleVector(bend, bend, RodPointDist[i - 1].damping);
            mgAddVector(segment, bend);
            sceVu0Normalize(segment, segment);
            sceVu0ScaleVector(segment, segment, RodPointDist[i - 1].length);
            sceVu0AddVector(RodPoint[i].pos, RodPoint[i - 1].pos, segment);
        }

        for (i = 1; i < 4; i++) {
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
            *(u_long128 *) (hari->point[0].pos) = *(u_long128 *) (FishPoint.pos);
            *(u_long128 *) (hari->point[0].old_pos) = *(u_long128 *) (FishPoint.pos);
            mgZeroVector(hari->point[0].velo);
            *(u_long128 *) (LinePoint[63].pos) = *(u_long128 *) (FishPoint.pos);
            *(u_long128 *) (LinePoint[63].old_pos) = *(u_long128 *) (FishPoint.pos);
            mgZeroVector(LinePoint[63].velo);
            hari->BindStep();

            if (uki != 0) {
                sceVu0FVECTOR float_pos;
                sceVu0SubVector(float_pos, FishPoint.pos, RodPoint[kRodTipIndex].pos);
                sceVu0Normalize(float_pos, float_pos);
                sceVu0ScaleVector(float_pos, float_pos, 15.0f);
                sceVu0SubVector(float_pos, FishPoint.pos, float_pos);
                *(u_long128 *) (LinePoint[60].pos) = *(u_long128 *) (float_pos);
                *(u_long128 *) (LinePoint[60].old_pos) = *(u_long128 *) (float_pos);
                mgZeroVector(LinePoint[60].velo);
                *(u_long128 *) (uki->point[0].pos) = *(u_long128 *) (float_pos);
                *(u_long128 *) (uki->point[0].old_pos) = *(u_long128 *) (float_pos);
                mgZeroVector(uki->point[0].velo);
                uki->BindStep();
            }
        }
    } else {
        FISH_POINT *top = &LinePoint[LineTop];
        *(u_long128 *) top->pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
        *(u_long128 *) top->old_pos = *(u_long128 *) RodPoint[kRodTipIndex].pos;
        mgZeroVector(top->velo);
        BindFishObj();
    }

    for (int i = 1; i < 5; i++) {
        sceVu0SubVector(RodPoint[i].velo, RodPoint[i].pos, RodPoint[i].old_pos);
        sceVu0ScaleVector(RodPoint[i].velo, RodPoint[i].velo, 0.6f);
        RodPoint[i].velo[1] += -0.6f;
        RodPoint[i].pos[3] = 1.0f;
    }

    sceVu0FVECTOR curve[5];
    *(u_long128 *) curve[0] = *(u_long128 *) RodPoint[0].pos;
    *(u_long128 *) curve[1] = *(u_long128 *) RodPoint[1].pos;
    *(u_long128 *) curve[2] = *(u_long128 *) RodPoint[2].pos;
    *(u_long128 *) curve[3] = *(u_long128 *) RodPoint[3].pos;
    *(u_long128 *) curve[4] = *(u_long128 *) RodPoint[4].pos;

    for (int i = 1; i < 8; i++) {
        sceVu0FMATRIX joint_matrix;
        sceVu0FMATRIX parent_world;
        sceVu0FMATRIX parent_inverse;
        sceVu0FVECTOR forward;
        sceVu0FVECTOR before;
        sceVu0FVECTOR after;
        sceVu0CopyMatrix(joint_matrix, SaoFrame[i]->trans_matrix);
        SaoFrame[i]->parent->GetLWMatrix(parent_world);
        mgInversMatrix(parent_inverse, parent_world);
        sceVu0CopyMatrix(parent_world, SaoFrame[i]->parent->trans_matrix);
        float fraction = 0.99f * (SaoDist[i] / SaoDist[7]);
        ParaBlend(before, 0.99f * (SaoDist[i - 1] / SaoDist[7]), curve, 5);
        before[3] = 1.0f;
        ParaBlend(after, fraction, curve, 5);
        sceVu0SubVector(forward, after, before);
        forward[3] = 0.0f;
        sceVu0ApplyMatrix(joint_matrix[0], parent_inverse, forward);

        if (i != 1) {
            sceVu0ApplyMatrix(joint_matrix[3], parent_inverse, before);
        }

        sceVu0OuterProduct(joint_matrix[2], joint_matrix[0], parent_world[0]);
        sceVu0OuterProduct(joint_matrix[1], joint_matrix[2], joint_matrix[0]);
        sceVu0Normalize(joint_matrix[0], joint_matrix[0]);
        sceVu0Normalize(joint_matrix[1], joint_matrix[1]);
        sceVu0Normalize(joint_matrix[2], joint_matrix[2]);
        SaoFrame[i]->SetTransMatrix(joint_matrix);
    }

    for (axis = 0; axis < 3; axis++) {
        line_box.max[axis] += 20.0f;
    }

    line_box.max[3] = 1.0f;
    *line_box.min -= 20.0f;
    line_box.min[1] -= 20.0f;
    line_box.min[2] -= 20.0f;
    line_box.min[3] = 1.0f;
    polys = (CCPoly *) poly_buffer;
    int poly_count = scene->GetColPoly(polys, line_box, 1024);

    for (int i = 0; i < poly_count; i++) {
        CCPoly *poly = &polys[i];

        if (poly->area_kind == 7) {
            poly->ignore_mask |= 8;
        }
    }

    for (int i = LineTop; i < 64; i++) {
        float damping = 0.95f;
        int   previous = i - 1;
        int   following = i + 1;

        if (previous < LineTop) {
            previous = LineTop;
        }

        if (following >= 64) {
            following = 63;
        }

        sceVu0FVECTOR from;
        sceVu0FVECTOR to;
        sceVu0FVECTOR hit;
        float         heights[3];
        *(u_long128 *) to = *(u_long128 *) from = *(u_long128 *) LinePoint[i].pos;
        heights[0] = LinePoint[i].pos[1];
        heights[1] = LinePoint[previous].pos[1];
        heights[2] = LinePoint[following].pos[1];

        for (int first = 0; first < 2; first++) {
            for (int second = first + 1; second < 3; second++) {
                if (heights[first] < heights[second]) {
                    float exchange = heights[first];
                    heights[first] = heights[second];
                    heights[second] = exchange;
                }
            }
        }

        from[1] = heights[0];
        to[1] = heights[2];
        from[1] += 4.0f;
        to[1] -= 1.0f;

        if (CheckHit(polys, poly_count, from, to, hit, 1, 9) >= 0 && !(1.0f + hit[1] < LinePoint[i].pos[1])) {
            LinePoint[i].pos[1] += 0.4f * (hit[1] + 1.0f - LinePoint[i].pos[1]);

            if (i == 63) {
                damping *= 0.05f;
            } else {
                damping *= 0.1f;
            }
        }

        sceVu0SubVector(LinePoint[i].velo, LinePoint[i].pos, LinePoint[i].old_pos);
        sceVu0ScaleVector(LinePoint[i].velo, LinePoint[i].velo, damping);
    }

    if (CastingLureTime <= 0) {
        EndCastingLure();
    }

    if (CastingLureFlag != 0) {
        *(u_long128 *) (LinePoint[63].pos) = *(u_long128 *) (FlyingPoint.pos);

        if (LineTop < 62) {
            sceVu0ScaleVector(LinePoint[62].velo, FlyingPoint.velo, 0.8f);
        }

        if (LineTop < 61) {
            sceVu0ScaleVector(LinePoint[61].velo, FlyingPoint.velo, 0.5f);
        }
    }

    float tackle_damping = 1.0f;

    if (ShowHari == 0) {
        tackle_damping = 0.4f;
    }

    hari->Correct(polys, poly_count, tackle_damping);

    if (uki != 0) {
        uki->Correct(polys, poly_count, 1.0f);
    }

    float water = GetWaterLevel();

    for (i = LineTop; i < 64; i++) {
        if (uki != 0 && i == 60) {
            continue;
        }

        if (i == 63) {
            continue;
        }

        FISH_POINT &point = LinePoint[i];

        if (point.pos[1] < water) {
            float lift = water - point.pos[1];

            if (!(lift <= 0.61f)) {
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

/**
 *
 * Moves two points toward their required separation at a chosen share.
 *
 */
static void BindPosition(float *point0, float *point1, float length, float rate) {
    float delta[4];
    float move_a[4];
    float move_b[4];

    sceVu0SubVector(delta, point0, point1);
    float dist = mgDistVector(delta);
    float excess = dist - length;
    sceVu0ScaleVector(move_a, delta, ((1.0f - rate) * excess) / dist);
    sceVu0ScaleVector(move_b, delta, (rate * excess) / dist);
    mgSubVector(point0, move_a);
    mgAddVector(point1, move_b);
}

void DrawFishingLine() {
    float       start[4];
    float       end[4];
    float       delta[4];
    int         i;
    int         ok;
    FISH_POINT *point;
    *(u_long128 *) start = *(u_long128 *) RodPoint[kRodTipIndex].pos;
    *(u_long128 *) delta = *(u_long128 *) RodPoint[kRodNearTipIndex].pos;
    sceVu0SubVector(delta, delta, start);
    sceVu0ScaleVector(delta, delta, 0.1f);
    mgAddVector(start, delta);
    *(u_long128 *) end = *(u_long128 *) &FishPoint.pos;
    start[3] = 1.0f;
    end[3] = 1.0f;
    mgCDrawPrim prim;
    int         screen_a[4];
    int         screen_b[4];
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.AlphaBlendEnable(1);
    prim.ZMask(MG_Z_MASK_WRITE);
    prim.TextureMapEnable(0);
    prim.Begin(MG_PRIM_LINE);
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

void DrawFishingActionChance() {
    mgCTextureManager *textures = &mgTexManager;
    float              start[4];
    float              end[4];
    float              mid[4];
    float              delta[4];
    *(u_long128 *) start = *(u_long128 *) RodPoint[kRodTipIndex].pos;
    *(u_long128 *) delta = *(u_long128 *) RodPoint[kRodNearTipIndex].pos;
    sceVu0SubVector(delta, delta, start);
    sceVu0ScaleVector(delta, delta, 0.1f);
    mgAddVector(start, delta);
    *(u_long128 *) end = *(u_long128 *) &FishPoint.pos;
    start[3] = 1.0f;
    end[3] = 1.0f;
    mgCDrawPrim prim;
    float       to_end[4];
    int         top_left[4];
    int         bottom_right[4];
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.AlphaBlendEnable(1);
    prim.ZMask(MG_Z_MASK_WRITE);
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
            prim.ZMask(MG_Z_MASK_MASKED);
            prim.Begin(MG_PRIM_SPRITE);
            prim.Color(0x80, 0x80, 0x80, 0x80);
            prim.Texture(textures->GetTexture("fish_juji", -1));

            if (ActionChanceDir > 0) {
                bottom_right[0] += 0x180;
                top_left[0] += 0x180;
                prim.TextureCrd(0x1A, 0x16);
                prim.Vertex4(top_left);
                prim.TextureCrd(0x34, 0x2C);
                prim.Vertex4(bottom_right);
            }

            if (ActionChanceDir < 0) {
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
    int   i;
    int   j;

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
    mgCFrame *tip_frame = rod_frame->SearchFrame("obj1");
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
    FISH_POINT *pt1 = &LureObj.point[1];
    float       dist = mgDistVector(LureObj.point[0].pos, pt1->pos);
    LureObj.bind[0].point1 = pt1;
    LureObj.bind[0].point0 = &LureObj.point[0];
    LureObj.bind[0].length = dist;
    LureObj.bind[0].rate = 0.5f;
    FISH_POINT *pt2 = &LureObj.point[2];
    dist = mgDistVector(pt1->pos, pt2->pos);
    LureObj.bind[1].point0 = pt1;
    LureObj.bind[1].rate = 0.5f;
    LureObj.bind[1].point1 = pt2;
    LureObj.bind[1].length = dist;
    dist = mgDistVector(LureObj.point[0].pos, pt2->pos);
    LureObj.bind[2].point0 = &LureObj.point[0];
    LureObj.bind[2].rate = 0.5f;
    LureObj.bind[2].point1 = pt2;
    LureObj.bind[2].length = dist;
    FISH_POINT *pt3 = &LureObj.point[3];
    dist = mgDistVector(pt1->pos, pt3->pos);
    LureObj.bind[3].point0 = pt1;
    LureObj.bind[3].rate = 0.5f;
    LureObj.bind[3].point1 = pt3;
    LureObj.bind[3].length = dist;
    FISH_POINT *pt4 = &LureObj.point[4];
    dist = mgDistVector(pt1->pos, pt4->pos);
    LureObj.bind[4].point0 = pt1;
    LureObj.bind[4].rate = 0.5f;
    LureObj.bind[4].point1 = pt4;
    LureObj.bind[4].length = dist;
    dist = mgDistVector(pt3->pos, pt4->pos);
    LureObj.bind[5].point0 = pt3;
    LureObj.bind[5].point1 = pt4;
    LureObj.bind[5].length = dist;
    LureObj.bind[5].rate = 0.5f;
    LureObj.bind_num = 6;
    LureObj.float_num = 2;
    LureObj.float_info[0].point1 = &LureObj.point[0];
    LureObj.float_info[1].point1 = pt1;
    LureObj.float_info[0].point0 = pt2;
    LureObj.float_info[1].point0 = pt2;
    LureObj.float_info[0].buoyancy = 2.5f;
    LureObj.float_info[1].buoyancy = 2.5f;
    LureObj.float_info[0].unk_8 = 0.0f;
    LureObj.float_info[1].unk_8 = 0.0f;
    SaoFrame[kSaoWeaponFrameIndex]->GetWorldPosition0(sao_pos);

    for (j = 0; j < LureObj.point_num; j++) {
        mgAddVector(LureObj.point[j].pos, sao_pos);
    }
}

void InitUkiObj(int no, mgCFrame *uki, mgCFrame *hari) {
    float       rod_tip[4];
    FISH_POINT *pt2;
    FISH_POINT *point;
    FISH_POINT *pt3;
    float       dist;
    CFishObj   *hari_obj;
    CFishObj   *uki_obj;
    int         j;
    FISH_POINT *pt1;
    int         i;
    i = 0;
    UkiObj.point_num = 4;
    uki_obj = &UkiObj;

    for (; i < uki_obj->point_num; i++) {
        point = &uki_obj->point[i];
        mgZeroVector(point->pos);
        mgZeroVector(point->old_pos);
        mgZeroVector(point->velo);
    }

    uki_obj->point[0].pos[0] = 0.0f;
    uki_obj->point[0].pos[1] = 2.0f;
    uki_obj->point[0].pos[2] = 0.0f;
    uki_obj->point[0].pos[3] = 1.0f;
    uki_obj->point[1].pos[0] = 0.0f;
    uki_obj->point[1].pos[1] = -1.5f;
    uki_obj->point[1].pos[2] = 3.0f;
    uki_obj->point[1].pos[3] = 1.0f;
    uki_obj->point[2].pos[0] = 2.598f;
    uki_obj->point[2].pos[1] = -1.5f;
    uki_obj->point[2].pos[2] = -1.5f;
    uki_obj->point[2].pos[3] = 1.0f;
    uki_obj->point[3].pos[0] = -2.598f;
    uki_obj->point[3].pos[1] = -1.5f;
    uki_obj->point[3].pos[2] = -1.5f;
    uki_obj->point[3].pos[3] = 1.0f;
    SaoFrame[7]->GetWorldPosition0(rod_tip);

    for (int k = 0; k < uki_obj->point_num; k++) {
        mgAddVector(uki_obj->point[k].pos, rod_tip);
    }

    pt1 = &uki_obj->point[1];
    dist = mgDistVector(uki_obj->point[0].pos, pt1->pos);
    uki_obj->bind[0].point0 = &uki_obj->point[0];
    uki_obj->bind[0].point1 = pt1;
    uki_obj->bind[0].length = dist;
    uki_obj->bind[0].rate = 0.5f;
    pt2 = &uki_obj->point[2];
    dist = mgDistVector(uki_obj->point[0].pos, pt2->pos);
    uki_obj->bind[1].point0 = &uki_obj->point[0];
    uki_obj->bind[1].point1 = pt2;
    uki_obj->bind[1].length = dist;
    uki_obj->bind[1].rate = 0.5f;
    pt3 = &uki_obj->point[3];
    dist = mgDistVector(uki_obj->point[0].pos, pt3->pos);
    uki_obj->bind[2].point0 = &uki_obj->point[0];
    uki_obj->bind[2].point1 = pt3;
    uki_obj->bind[2].length = dist;
    uki_obj->bind[2].rate = 0.5f;
    dist = mgDistVector(pt1->pos, pt2->pos);
    uki_obj->bind[3].point0 = pt1;
    uki_obj->bind[3].point1 = pt2;
    uki_obj->bind[3].length = dist;
    uki_obj->bind[3].rate = 0.5f;
    dist = mgDistVector(pt2->pos, pt3->pos);
    uki_obj->bind[4].point0 = pt2;
    uki_obj->bind[4].point1 = pt3;
    uki_obj->bind[4].length = dist;
    uki_obj->bind[4].rate = 0.5f;
    dist = mgDistVector(pt3->pos, pt1->pos);
    uki_obj->bind[5].point0 = pt3;
    uki_obj->bind[5].point1 = pt1;
    uki_obj->bind[5].length = dist;
    uki_obj->bind[5].rate = 0.5f;
    uki_obj->bind_num = 6;
    uki_obj->float_num = 3;
    uki_obj->float_info[0].point0 = pt1;
    uki_obj->float_info[0].point1 = &uki_obj->point[0];
    uki_obj->float_info[0].buoyancy = 1.6f;
    uki_obj->float_info[0].unk_8 = 0;
    uki_obj->float_info[1].point0 = pt2;
    uki_obj->float_info[1].point1 = &uki_obj->point[0];
    uki_obj->float_info[1].buoyancy = 1.6f;
    uki_obj->float_info[1].unk_8 = 0;
    uki_obj->float_info[2].point0 = pt3;
    uki_obj->float_info[2].point1 = &uki_obj->point[0];
    uki_obj->float_info[2].buoyancy = 1.6f;
    uki_obj->float_info[2].unk_8 = 0;
    hari_obj = &HariObj;
    HariObj.point_num = 3;

    for (j = 0; j < hari_obj->point_num; j++) {
        point = &hari_obj->point[j];
        mgZeroVector(point->pos);
        mgZeroVector(point->old_pos);
        mgZeroVector(point->velo);
    }

    hari_obj->point[0].pos[0] = 0.0f;
    hari_obj->point[0].pos[1] = 0.0f;
    hari_obj->point[0].pos[2] = 0.0f;
    hari_obj->point[0].pos[3] = 1.0f;
    hari_obj->point[1].pos[0] = 1.0f;
    hari_obj->point[1].pos[1] = -4.0f;
    hari_obj->point[1].pos[2] = 0.0f;
    hari_obj->point[1].pos[3] = 1.0f;
    hari_obj->point[2].pos[0] = -1.0f;
    hari_obj->point[2].pos[1] = -4.0f;
    hari_obj->point[2].pos[2] = 0.0f;
    hari_obj->point[2].pos[3] = 1.0f;

    for (int k = 0; k < hari_obj->point_num; k++) {
        mgAddVector(hari_obj->point[k].pos, rod_tip);
    }

    hari_obj->bind_num = 3;
    pt1 = &hari_obj->point[1];
    dist = mgDistVector(hari_obj->point[0].pos, pt1->pos);
    hari_obj->bind[0].point0 = &hari_obj->point[0];
    hari_obj->bind[0].point1 = pt1;
    hari_obj->bind[0].length = dist;
    hari_obj->bind[0].rate = 0.5f;
    pt2 = &hari_obj->point[2];
    dist = mgDistVector(hari_obj->point[0].pos, pt2->pos);
    hari_obj->bind[1].point0 = &hari_obj->point[0];
    hari_obj->bind[1].point1 = pt2;
    hari_obj->bind[1].length = dist;
    hari_obj->bind[1].rate = 0.5f;
    dist = mgDistVector(pt1->pos, pt2->pos);
    hari_obj->bind[2].point0 = pt1;
    hari_obj->bind[2].point1 = pt2;
    hari_obj->bind[2].length = dist;
    hari_obj->bind[2].rate = 0.5f;
}

void CFishObj::MovePoint() {
    for (int i = 0; i < point_num; i++) {
        *(u_long128 *) point[i].old_pos = *(u_long128 *) point[i].pos;
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

        (float_info[i].point0)->velo[0] *= 0.3f;
        (float_info[i].point0)->velo[2] *= 0.3f;
        (float_info[i].point0)->velo[1] += float_info[i].buoyancy * ratio;
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
        BindPosition(constraint->point0->pos, constraint->point1->pos, constraint->length, constraint->rate);
    }
}

void CFishObj::Correct(CCPoly *poly, int poly_num, float damping) {
    for (int i = 0; i < point_num; i++) {
        float friction = 0.95f;
        float upper;
        float lower;
        float y = point[i].pos[1];
        float old_y = point[i].old_pos[1];

        if (y > old_y) {
            upper = y;
        } else {
            upper = old_y;
        }

        if (y < old_y) {
            lower = y;
        } else {
            lower = old_y;
        }

        sceVu0FVECTOR from;
        sceVu0FVECTOR to;
        sceVu0FVECTOR hit;
        sceVu0FVECTOR correction;
        mgZeroVector(correction);
        u_long128 position = *(u_long128 *) point[i].pos;
        *(u_long128 *) from = position;
        *(u_long128 *) to = position;
        from[1] = upper + 4.0f;
        to[1] = lower - 1.0f;
        int hit_poly = CheckHit(poly, poly_num, from, to, hit, 1, 9);

        if (hit_poly >= 0 && !(1.0f + hit[1] <= point[i].pos[1])) {
            correction[1] = -point[i].velo[1] * 0.5f;
            point[i].pos[1] += hit[1] + 1.0f - point[i].pos[1];
            friction *= 0.2f;
        }

        sceVu0SubVector(point[i].velo, point[i].pos, point[i].old_pos);
        sceVu0ScaleVector(point[i].velo, point[i].velo, friction * damping);
        mgAddVector(point[i].velo, correction);
    }
}

/**
 *
 * Interpolates a fishing line point along a cubic curve.
 *
 */
void ParaBlend(float *out, float t, float (*point)[4], int count) {
    float step = 1.0f / (float) (count - 1);
    int   cur = fptosi(t / step);
    int   prev;
    int   next;
    int   next2;
    next = cur + 1;
    prev = cur - 1;
    next2 = next + 1;
    float local = t - (float) cur * step;
    local *= (float) (count - 1);

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

    Matrix4 basis = {
        {{-1.0f, 3.0f, -3.0f, 1.0f},
         {2.0f, -5.0f, 4.0f, -1.0f},
         {-1.0f, 0.0f, 1.0f, 0.0f},
         {0.0f, 2.0f, 0.0f, 0.0f}}
    };
    Matrix4 geometry;
    sceVu0TransposeMatrix(basis.m, basis.m);
    *(u_long128 *) geometry.m[0] = *(u_long128 *) point[prev];
    geometry.m[0][3] = 0.0f;
    *(u_long128 *) geometry.m[1] = *(u_long128 *) point[cur];
    geometry.m[1][3] = 0.0f;
    *(u_long128 *) geometry.m[2] = *(u_long128 *) point[next];
    geometry.m[2][3] = 0.0f;
    *(u_long128 *) geometry.m[3] = *(u_long128 *) point[next2];
    geometry.m[3][3] = 0.0f;
    sceVu0TransposeMatrix(geometry.m, geometry.m);
    mgMulMatrix(basis.m, basis.m, geometry.m);
    sceVu0TransposeMatrix(basis.m, basis.m);
    float powers[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float square = local * local;
    powers[0] = local * square;
    powers[1] = square;
    powers[2] = local;
    sceVu0ScaleVector(powers, powers, 0.5f);
    sceVu0ApplyMatrix(out, basis.m, powers);
}
