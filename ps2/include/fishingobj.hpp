#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the fishing tackle simulation: the point masses and constraints
 * that model the lure, float and hook, and the functions that step the rod,
 * line and tackle, run the struggle with a hooked fish and draw the line.
 */

class CScene;
class mgCFrame;
struct CCPoly;

/**
 *
 * Kinds of tackle the fishing minigame is played with, as given to SetFishingMode.
 *
 */
enum FishingMode {
    FISHING_MODE_BAIT = 1, /**< Bait on a hook below a float; the float and hook objects are simulated. */
    FISHING_MODE_LURE = 2, /**< A lure; the lure object takes the hook's place and there is no float. */
};

/**
 *
 * Point mass of the tackle simulation, stepped from its current and previous positions.
 *
 */
struct FISH_POINT {
    sceVu0FVECTOR pos;     /**< Current world position. */
    sceVu0FVECTOR old_pos; /**< World position before the last step. */
    sceVu0FVECTOR velo;    /**< Velocity added to the position each step. */
};

STATIC_ASSERT(sizeof(FISH_POINT) == 0x30);

/**
 *
 * Distance constraint that holds two point masses of a tackle object a fixed length apart.
 *
 */
struct FISH_BIND {
    FISH_POINT *point0; /**< First point held by the constraint. */
    FISH_POINT *point1; /**< Second point held by the constraint. */
    float rate;         /**< Share of each correction applied to the first point; the second takes the rest. */
    float length;       /**< Distance the two points are held at. */
};

STATIC_ASSERT(sizeof(FISH_BIND) == 0x10);

/**
 *
 * Pair of point masses whose span across the water surface lifts the first of them.
 *
 */
struct FISH_FLOAT {
    FISH_POINT *point0; /**< Point that is slowed and lifted while the pair is in the water. */
    FISH_POINT *point1; /**< Point whose height with the first's sets how much of the pair is under water. */
    int unk_8;
    float buoyancy;     /**< Upward velocity added to the first point when the pair is fully submerged. */
};

STATIC_ASSERT(sizeof(FISH_FLOAT) == 0x10);

/**
 *
 * Distance and motion weights for a segment of the fishing rod.
 *
 */
struct FISH_ROD_SEGMENT {
    float length;        /**< Rest length from the preceding rod point. */
    float stiffness;     /**< Strength of the segment's distance correction. */
    float damping;       /**< Share of motion retained during correction. */
    float unk_c;
};

STATIC_ASSERT(sizeof(FISH_ROD_SEGMENT) == 0x10);

/**
 *
 * Piece of fishing tackle (lure, float or hook) simulated as point masses held by constraints.
 *
 */
class CFishObj {
public:
    int point_num; /**< Number of entries of point in use. */
    FISH_POINT point[8];    /**< Point masses making up the object's shape. */
    int bind_num; /**< Number of entries of bind in use. */
    FISH_BIND bind[18];     /**< Constraints holding the points in shape. */
    u_char unk_2b4[0xC];
    int float_num; /**< Number of entries of float_info in use. */
    FISH_FLOAT float_info[16]; /**< Point pairs that float the object at the water surface. */

    /**
     *
     * Advances every point by its velocity under gravity, keeping its previous position.
     *
     * @mangled MovePoint__8CFishObjFv
     * @address 0x3184B0
     * @size 0x90
     */
    void MovePoint();

    /**
     *
     * Lifts and slows points that are below the water surface.
     *
     * @mangled FloatPoint__8CFishObjFf
     * @address 0x318540
     * @size 0x1D0
     */
    void FloatPoint(float water_level);

    /**
     *
     * Applies each of the object's constraints once.
     *
     * @mangled BindStep__8CFishObjFv
     * @address 0x318710
     * @size 0x70
     */
    void BindStep();

    /**
     *
     * Keeps the points above the ground and rebuilds their velocities from their movement this step.
     *
     * @mangled Correct__8CFishObjFP6CCPolyif
     * @address 0x318780
     * @size 0x1F0
     */
    void Correct(CCPoly *poly, int poly_num, float damping);
};

STATIC_ASSERT(sizeof(CFishObj) == 0x3D0);

/**
 *
 * Sets the kind of tackle being fished with, a FishingMode.
 *
 * @mangled SetFishingMode__Fi
 * @address 0x314DB0
 * @size 0x10
 */
void SetFishingMode(int mode);

/**
 *
 * Returns the kind of tackle being fished with, a FishingMode.
 *
 * @mangled GetFishingMode__Fv
 * @address 0x314DC0
 * @size 0x10
 */
int GetFishingMode();

/**
 *
 * Sets the height of the water surface the tackle floats on.
 *
 * @mangled SetWaterLevel__Ff
 * @address 0x314DD0
 * @size 0x10
 */
void SetWaterLevel(float level);

/**
 *
 * Returns the height of the water surface the tackle floats on.
 *
 * @mangled GetWaterLevel__Fv
 * @address 0x314DE0
 * @size 0x10
 */
float GetWaterLevel();

/**
 *
 * Pays the line out (positive length) or reels it in (negative), returning 1 at full length, -1 at the shortest and 0 otherwise.
 *
 * @mangled ExtendLine__Ff
 * @address 0x314E50
 * @size 0x1C0
 */
int ExtendLine(float length);

/**
 *
 * Returns the length of line currently out.
 *
 * @mangled GetNowLineLength__Fv
 * @address 0x315010
 * @size 0x50
 */
float GetNowLineLength();

/**
 *
 * Returns the shortest length the line can be reeled in to.
 *
 * @mangled GetMinLineLength__Fv
 * @address 0x315060
 * @size 0x10
 */
float GetMinLineLength();

/**
 *
 * Lays out the rod and line along the rod model's joints and resets the tackle for bait fishing.
 *
 * @mangled InitRodPoint__FP8mgCFrameP8mgCFrame
 * @address 0x315070
 * @size 0x3B0
 */
void InitRodPoint(mgCFrame *reference, mgCFrame *rod);

/**
 *
 * Copies out the position and velocity of the line's end, where the hook hangs.
 *
 * @mangled GetHariPos__FPfPf
 * @address 0x3155F0
 * @size 0x30
 */
void GetHariPos(float *pos, float *velo);

/**
 *
 * Copies out the position and velocity of the line point the float hangs from.
 *
 * @mangled GetUkiPos__FPfPf
 * @address 0x315620
 * @size 0x30
 */
void GetUkiPos(float *pos, float *velo);

/**
 *
 * Pulls the float downwards, as a fish nibbling at the bait.
 *
 * @mangled PullUki__Ff
 * @address 0x315650
 * @size 0x20
 */
void PullUki(float power);

/**
 *
 * Sets whether the hook is shown.
 *
 * @mangled SetShowHari__Fi
 * @address 0x315670
 * @size 0x10
 */
void SetShowHari(int show);

/**
 *
 * Returns whether the hook is shown; it is hidden once well below the water surface.
 *
 * @mangled GetShowHari__Fv
 * @address 0x315680
 * @size 0x60
 */
int GetShowHari();

/**
 *
 * Places the lure model on the simulated lure, returning nonzero when it was placed.
 *
 * @mangled SetLurePose__FP8mgCFrame
 * @address 0x3156E0
 * @size 0xF0
 */
int SetLurePose(mgCFrame *lure);

/**
 *
 * Places the float and hook models on the simulated float and hook, returning nonzero when they were placed.
 *
 * @mangled SetUkiPose__FP8mgCFrameP8mgCFrame
 * @address 0x3157D0
 * @size 0x1F0
 */
int SetUkiPose(mgCFrame *uki, mgCFrame *hari);

/**
 *
 * Throws the line's end towards a point on the water, returning the number of frames the flight lasts.
 *
 * @mangled CastingLure__FPf
 * @address 0x3159C0
 * @size 0x170
 */
int CastingLure(float *target);

/**
 *
 * Ends the flight of a cast.
 *
 * @mangled EndCastingLure__Fv
 * @address 0x315B30
 * @size 0x10
 */
void EndCastingLure();

/**
 *
 * Moves the line's end towards a point by at most a distance, returning nonzero once it reaches it.
 *
 * @mangled CatchLine__FPff
 * @address 0x315B40
 * @size 0x150
 */
int CatchLine(float *pos, float max_dist);

/**
 *
 * Scales the velocity of every paid-out point of the line.
 *
 * @mangled SlowLineVelo__Ff
 * @address 0x315C90
 * @size 0x80
 */
void SlowLineVelo(float rate);

/**
 *
 * Gathers the paid-out points of the line at its first one and stops them.
 *
 * @mangled ResetLineVelo__Fv
 * @address 0x315D10
 * @size 0xC0
 */
void ResetLineVelo();

/**
 *
 * Hangs the shortest length of line straight down from a position and puts the tackle at its end.
 *
 * @mangled ResetLine__FPf
 * @address 0x315DD0
 * @size 0x190
 */
void ResetLine(float *pos);

/**
 *
 * Starts the struggle with a hooked fish at the hook's position.
 *
 * @mangled InitFishBattle__Fv
 * @address 0x315FA0
 * @size 0x90
 */
int InitFishBattle();

/**
 *
 * Ends the struggle with a hooked fish.
 *
 * @mangled EndFishBattle__Fv
 * @address 0x316030
 * @size 0x20
 */
int EndFishBattle();

/**
 *
 * Checks a rod direction against the open action chance, returning 1 when it matches, -1 when it opposes and 0 otherwise.
 *
 * @mangled CheckRodActionChance__FiPi
 * @address 0x316050
 * @size 0x70
 */
int CheckRodActionChance(int dir, int *just);

/**
 *
 * Steps the hooked fish's swimming during the struggle, keeping it out of the scenery.
 *
 * @mangled FishBattle__FP6CSceneP6CCPolyi
 * @address 0x3160C0
 * @size 0x3B0
 */
int FishBattle(CScene *scene, CCPoly *poly_buffer, int poly_max);

/**
 *
 * Copies out the position and velocity of the hooked fish.
 *
 * @mangled GetFishPosVelo__FPfPf
 * @address 0x316470
 * @size 0x30
 */
void GetFishPosVelo(float *pos, float *velo);

/**
 *
 * Steps the rod, line and tackle by one frame.
 *
 * @mangled RodStep__FP6CSceneP1
 * @address 0x316690
 * @size 0xF70
 */
void RodStep(CScene *scene, u_long128 *poly_buffer);

/**
 *
 * Draws the fishing line from the rod tip to the tackle.
 *
 * @mangled DrawFishingLine__Fv
 * @address 0x3176E0
 * @size 0x2F0
 */
void DrawFishingLine();

/**
 *
 * Draws the marker of the open action chance during the struggle with a fish.
 *
 * @mangled DrawFishingActionChance__Fv
 * @address 0x3179D0
 * @size 0x310
 */
void DrawFishingActionChance();

/**
 *
 * Builds the lure object at the rod tip from the lure model, or a bare line end when there is no lure.
 *
 * @mangled InitLureObj__FiP8mgCFrame
 * @address 0x317CE0
 * @size 0x440
 */
void InitLureObj(int lure_no, mgCFrame *lure);

/**
 *
 * Builds the float and hook objects at the rod tip.
 *
 * @mangled InitUkiObj__FiP8mgCFrameP8mgCFrame
 * @address 0x318120
 * @size 0x390
 */
void InitUkiObj(int no, mgCFrame *uki, mgCFrame *hari);
