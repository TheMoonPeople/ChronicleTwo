#pragma once

#include "common.h"

#include <libvu0.h>

#include "collision.hpp"
#include "font.hpp"

/**
 * @file
 * Declares the motion data that drives a model's frames and skin, the queries that test lines,
 * pipes and spheres against collision polygons, and small geometry helpers.
 */

class mgCCamera;
class mgCFrame;
class mgCMemory;
class mgCVisualMDT;
struct MoveCheckInfo;

/**
 *
 * What a motion key list sets, as Mot_List::type holds it.
 *
 */
// clang-format off
enum MotionKeyType {
    MOTION_KEY_ROTATION        = 0,  /**< Rotation of the frame, as a quaternion. */
    MOTION_KEY_SCALE           = 1,  /**< Scale of the frame. */
    MOTION_KEY_TRANSLATION     = 2,  /**< Translation of the frame. */
    MOTION_KEY_VERTEX          = 12, /**< Position of one vertex of the frame's visual. */
    MOTION_KEY_SKIN_WEIGHTED   = 20, /**< Vertices that a bone moves, each by its own weight. */
    MOTION_KEY_SKIN_AVERAGED   = 21, /**< Vertices that a bone moves, averaged over every bone that moves them. */
    MOTION_KEY_CAMERA_POSITION = 30, /**< Camera eye position. */
    MOTION_KEY_CAMERA_TARGET   = 31, /**< Camera look-at position. */
    MOTION_KEY_CAMERA_ROLL     = 32, /**< Camera roll, in degrees. */
    MOTION_KEY_CAMERA_FOV      = 33, /**< Camera field of view, in degrees. */
    MOTION_KEY_MATERIAL_ALPHA  = 40, /**< Transparency of one material of the frame's visual. */
    MOTION_KEY_MATERIAL_COLOR  = 41, /**< Colour of one material of the frame's visual. */
    MOTION_KEY_VISIBLE         = 50, /**< Visibility of the frame. */
    MOTION_KEY_VISIBLE_TREE          = 51, /**< Visibility of the frame, with the other pair of draw modes. */
};

// clang-format on

/**
 *
 * Sides on which CheckWidth and CheckWidthPipe found a wall, combined as bits.
 *
 */
// clang-format off
enum CheckWidthSide {
    CHECK_WIDTH_SIDE_POS_X = 1 << 0, /**< A wall on the positive X side. */
    CHECK_WIDTH_SIDE_NEG_X = 1 << 1, /**< A wall on the negative X side. */
    CHECK_WIDTH_SIDE_POS_Z = 1 << 2, /**< A wall on the positive Z side. */
    CHECK_WIDTH_SIDE_NEG_Z = 1 << 3, /**< A wall on the negative Z side. */
};

// clang-format on

/**
 *
 * Holds one key of a motion file: the frame it stands on and the value it sets there.
 *
 */
struct FRAME_VECTOR_EX_DATA {
    u32           frame; /**< Motion frame that the key stands on; for a skin list, the vertex it weights. */
    u8            unk_04[0xC];
    sceVu0FVECTOR value; /**< What the key sets; for a skin list, the weight in percent in x. */
};

STATIC_ASSERT(sizeof(FRAME_VECTOR_EX_DATA) == 0x20);

/**
 *
 * Heads one key list in a motion file; its keys follow it.
 *
 */
struct Mot_File_List {
    s32 frame;  /**< Frame of the model that the keys drive. */
    s32 target; /**< Part of the frame that the keys drive: a vertex, a material or a bone frame. */
    s32 type;   /**< What the keys set. @see MotionKeyType. */
    u8  unk_0C[4];
    u32 key_count; /**< Number of keys after the header. */
    u32 more;      /**< Nonzero when another key list follows this one's keys. */
    u8  unk_18[8];
};

STATIC_ASSERT(sizeof(Mot_File_List) == 0x20);

/**
 *
 * Drives one part of a model's frame from a run of motion keys.
 *
 */
struct Mot_List {
    s32            frame;      /**< Frame of the model that the keys drive. */
    s32            target;     /**< Part of the frame that the keys drive: a vertex (counted from 1), a material or a bone frame. */
    s32            type;       /**< What the keys set. @see MotionKeyType. */
    u32            key_count;  /**< Number of keys. */
    sceVu0FVECTOR *values;     /**< Value of each key. */
    u32           *key_frames; /**< Motion frame of each key, in ascending order; for a skin list, the vertex each key weights. */
    Mot_List      *next;       /**< Next key list, or NULL after the last. */
    u8             unk_1C[4];
};

STATIC_ASSERT(sizeof(Mot_List) == 0x20);

/**
 *
 * Lists the normal indices associated with one of a visual's vertices.
 *
 */
struct FrameLinkRecord {
    s32 count;    /**< Number of entries of link in use. */
    s32 link[11]; /**< Normal indices associated with this vertex. */
};

STATIC_ASSERT(sizeof(FrameLinkRecord) == 0x30);

/**
 *
 * Holds what a model's motion needs to know about one of its frames to skin its visual.
 *
 */
struct tagFRAME_INF {
    s32              parent;        /**< Parent frame index when a parent is present; unused for roots. */
    u32              vertex_count;  /**< Number of vertices of the frame's visual. */
    u32              normal_count;  /**< Number of normals of the frame's visual. */
    FrameLinkRecord *vertex_refs;   /**< Per-vertex lists of the associated normal indices. */
    sceVu0FVECTOR   *base_vertices; /**< Copy of the visual's undeformed vertices. */
    sceVu0FVECTOR   *base_normals;  /**< Copy of the visual's undeformed normals. */
    u8               unk_18[8];
};

STATIC_ASSERT(sizeof(tagFRAME_INF) == 0x20);

/**
 *
 * Carries one motion of a model: its bind pose, its key lists and the frames that it skins.
 *
 */
struct tagMOTION_TYPE {
    sceVu0FMATRIX *base_matrices; /**< Bind-pose matrix of each frame, loaded from the motion's first file. */
    Mot_List      *motion_list;   /**< Key lists that pose the frames, applied by SetMotionTime and ChangeMotion. */
    Mot_List      *skin_list;     /**< Key lists that skin the visuals, applied by DeformMesh. */
    u32            unk_0C;
    tagFRAME_INF  *frame_info; /**< Skinning data of each frame of the model. */
};

STATIC_ASSERT(sizeof(tagMOTION_TYPE) == 0x14);

/**
 *
 * Names one file of a motion found in a pack file.
 *
 */
struct MOTION_FILE_INFO {
    char *name; /**< Name of the file in the pack file, or NULL when the motion has no such file. */
    void *data; /**< Contents of the file. */
    int   size; /**< Size of the file in bytes. */
};

STATIC_ASSERT(sizeof(MOTION_FILE_INFO) == 0xC);

/**
 *
 * Names a set of collision polygons for the queries that test against them.
 *
 */
struct CollisionInfo {
    s32     count; /**< Number of polygons. */
    CCPoly *polys; /**< The polygons. */
    s32     unk_08;
    s32     unk_0C;
};

STATIC_ASSERT(sizeof(CollisionInfo) == 0x10);

/**
 *
 * Poses a model on one time of its motion from one key list, and gives back the next key list.
 *
 * @mangled MotionProc__FP8mgCFramefP8Mot_ListP9mgCCamera
 * @address 0x14BEC0
 * @size 0x94C
 */
Mot_List *MotionProc(mgCFrame *root, float time, Mot_List *list, mgCCamera *camera);

/**
 *
 * Poses a model part of the way from one frame of its motion to another from one key list, and gives back the next key list.
 *
 * @mangled MotionProc__FP8mgCFrameUiUifP8Mot_ListP9mgCCamera
 * @address 0x14C810
 * @size 0x7CC
 */
Mot_List *MotionProc(mgCFrame *root, unsigned int from_frame, unsigned int to_frame, float blend, Mot_List *list, mgCCamera *camera);

/**
 *
 * Moves the vertices of a skinned visual by one bone without normals, and gives back the next key list.
 *
 * @mangled MotionProc2__FP8mgCFrameP14tagMOTION_TYPEP12tagFRAME_INFP8Mot_List
 * @address 0x14D020
 * @size 0x374
 */
Mot_List *MotionProc2(mgCFrame *root, tagMOTION_TYPE *motion, tagFRAME_INF *frame_info, Mot_List *list);

/**
 *
 * Moves the vertices and normals of a skinned visual by one bone, and gives back the next key list.
 *
 * @mangled MotionProc3__FP8mgCFrameP14tagMOTION_TYPEP12tagFRAME_INFP8Mot_List
 * @address 0x14D3A0
 * @size 0x3C4
 */
Mot_List *MotionProc3(mgCFrame *root, tagMOTION_TYPE *motion, tagFRAME_INF *frame_info, Mot_List *list);

/**
 *
 * Poses a model on one time of a motion.
 *
 * @mangled SetMotionTime__FP8mgCFrameP14tagMOTION_TYPEfP9mgCCamera
 * @address 0x14D770
 * @size 0x60
 */
void SetMotionTime(mgCFrame *root, tagMOTION_TYPE *motion, float time, mgCCamera *camera);

/**
 *
 * Poses a model part of the way from one frame of a motion to another, to blend between motions.
 *
 * @mangled ChangeMotion__FP8mgCFrameP14tagMOTION_TYPEUiUifP9mgCCamera
 * @address 0x14D7D0
 * @size 0x80
 */
void ChangeMotion(mgCFrame *root, tagMOTION_TYPE *motion, unsigned int from_frame, unsigned int to_frame, float blend, mgCCamera *camera);

/**
 *
 * Skins every visual of a model by the bones of its motion.
 *
 * @mangled DeformMesh__FP8mgCFrameP14tagMOTION_TYPEP12tagFRAME_INFb
 * @address 0x14D850
 * @size 0x9C
 */
void DeformMesh(mgCFrame *root, tagMOTION_TYPE *motion, tagFRAME_INF *frame_info, bool with_normals);

/**
 *
 * Replaces the skin weights of one frame with those of a skin file, and takes a fresh copy of its visual.
 *
 * @mangled ChangeWeight__FP8Mot_ListP9mgCMemoryPUciP12tagFRAME_INFP12mgCVisualMDTP8mgCFrameP8mgCFrame
 * @address 0x14D9D0
 * @size 0x340
 */
void ChangeWeight(Mot_List *list, mgCMemory *memory, unsigned char *file, int frame, tagFRAME_INF *frame_info, mgCVisualMDT *visual, mgCFrame *root, mgCFrame *skin_root);

/**
 *
 * Builds a motion's bind pose and key lists from its files.
 *
 * @mangled CreateAnimeDataEX__FP14tagMOTION_TYPEP9mgCMemoryP16MOTION_FILE_INFO
 * @address 0x14DD10
 * @size 0x220
 */
int CreateAnimeDataEX(tagMOTION_TYPE *motion, mgCMemory *memory, MOTION_FILE_INFO *files);

/**
 *
 * Allocates a model's per-frame skinning table and fills it.
 *
 * @mangled AnimeDataInit__FP8mgCFrameP14tagMOTION_TYPEP9mgCMemoryPP12tagFRAME_INF
 * @address 0x14DF30
 * @size 0x78
 */
void AnimeDataInit(mgCFrame *root, tagMOTION_TYPE *motion, mgCMemory *memory, tagFRAME_INF **frame_info);

/**
 *
 * Fills a model's per-frame skinning table in storage already set aside.
 *
 * @mangled AnimeDataInit__FP8mgCFrameP14tagMOTION_TYPEP9mgCMemoryP12tagFRAME_INF
 * @address 0x14DFB0
 * @size 0x35C
 */
int AnimeDataInit(mgCFrame *root, tagMOTION_TYPE *motion, mgCMemory *memory, tagFRAME_INF *frame_info);

/**
 *
 * Finds a polygon that a line crosses, and gives back its index or -1.
 *
 * @mangled CheckHit__FP6CCPolyiPfPfPfii
 * @address 0x14E310
 * @size 0x40
 */
int CheckHit(CCPoly *polys, int count, float *from, float *to, float *hit_point, int nearest, int ignore_mask);

/**
 *
 * Finds a polygon of a set that a line crosses, the nearest to its start when asked, and gives back its index or -1.
 *
 * @mangled CheckHit__FP13CollisionInfoPfPfPfii
 * @address 0x14E350
 * @size 0x32C
 */
int CheckHit(CollisionInfo *info, float *from, float *to, float *hit_point, int nearest, int ignore_mask);

/**
 *
 * Finds the polygon nearest a point straight above or below it, and gives back its index or -1.
 *
 * @mangled CheckHitVertical__FP6CCPolyiPffPfi
 * @address 0x14E680
 * @size 0x38
 */
int CheckHitVertical(CCPoly *polys, int count, float *from, float height, float *hit_point, int ignore_mask);

/**
 *
 * Finds the polygon of a set nearest a point straight above or below it, and gives back its index or -1.
 *
 * @mangled CheckHitVertical__FP13CollisionInfoPffPfi
 * @address 0x14E6C0
 * @size 0x1AC
 */
int CheckHitVertical(CollisionInfo *info, float *from, float height, float *hit_point, int ignore_mask);

/**
 *
 * Finds every polygon that a line crosses, and gives back how many it found.
 *
 * @mangled CheckHits__FP6CCPolyiPfPfiPiPA4_fii
 * @address 0x14E870
 * @size 0x48
 */
int CheckHits(CCPoly *polys, int count, float *from, float *to, int max_hits, int *hit_polys, float (*hit_points)[4], int sort, int ignore_mask);

/**
 *
 * Finds every polygon of a set that a line crosses, sorted by distance when asked, and gives back how many it found.
 *
 * @mangled CheckHits__FP13CollisionInfoPfPfiPiPA4_fii
 * @address 0x14E8C0
 * @size 0x418
 */
int CheckHits(CollisionInfo *info, float *from, float *to, int max_hits, int *hit_polys, float (*hit_points)[4], int sort, int ignore_mask);

/**
 *
 * Finds every polygon that a vertical pipe meets, and gives back how many it found.
 *
 * @mangled CheckHitsPipeY__FP6CCPolyiPffiPiPA4_fii
 * @address 0x14ECE0
 * @size 0x4C8
 */
int CheckHitsPipeY(CCPoly *polys, int count, float *from, float height, int max_hits, int *hit_polys, float (*hit_points)[4], int sort, int ignore_mask);

/**
 *
 * Finds every polygon that a pipe between two points meets, and gives back how many it found.
 *
 * @mangled CheckHitsPipe__FP6CCPolyiPfPfiPiPA4_fii
 * @address 0x14F1B0
 * @size 0x504
 */
int CheckHitsPipe(CCPoly *polys, int count, float *from, float *to, int max_hits, int *hit_polys, float (*hit_points)[4], int sort, int ignore_mask);

/**
 *
 * Finds every polygon that a sphere meets, and gives back how many it found.
 *
 * @mangled CheckHitsSphere__FP6CCPolyiPfiPiPA4_fii
 * @address 0x14F6C0
 * @size 0x3E4
 */
int CheckHitsSphere(CCPoly *polys, int count, float *sphere, int max_hits, int *hit_polys, float (*hit_points)[4], int sort, int ignore_mask);

/**
 *
 * Moves a character by one step against collision polygons, and records what it ran into.
 *
 * @mangled MoveCheck__FPfPfPfP13MoveCheckInfoP6CCPolyii
 * @address 0x14FAB0
 * @size 0x608
 */
int MoveCheck(float *pos, float *velocity, float *out_pos, MoveCheckInfo *info, CCPoly *polys, int count, int ignore_mask);

/**
 *
 * Finds the ground polygon below a point and the point on it, and gives back whether it found one.
 *
 * @mangled GetFootPoly__FPffP6CCPolyPfP6CCPolyii
 * @address 0x1500C0
 * @size 0x330
 */
int GetFootPoly(float *pos, float depth, CCPoly *found, float *ground, CCPoly *polys, int count, int ignore_mask);

/**
 *
 * Records the special areas that a character's step crosses and that lie above where it lands.
 *
 * @mangled GetCPolyAttr__FP13MoveCheckInfoPfPffP6CCPolyii
 * @address 0x1503F0
 * @size 0x23C
 */
void GetCPolyAttr(MoveCheckInfo *info, float *from, float *to, float height, CCPoly *polys, int count, int ignore_mask);

/**
 *
 * Pushes a point out of the walls within a radius of it, and gives back the sides that it found walls on.
 *
 * @mangled CheckWidth__FP6CCPolyiPffPfi
 * @address 0x150630
 * @size 0x7FC
 */
int CheckWidth(CCPoly *polys, int count, float *pos, float radius, float *out_pos, int ignore_mask);

/**
 *
 * Pushes a pipe out of the walls within a radius of it, and gives back the sides that it found walls on.
 *
 * @mangled CheckWidthPipe__FP6CCPolyiPffPfi
 * @address 0x150E30
 * @size 0x480
 */
int CheckWidthPipe(CCPoly *polys, int count, float *pos, float radius, float *out_pos, int ignore_mask);

/**
 *
 * Builds the two collision polygons of an upright wall in front of a character, and gives back how many it built.
 *
 * @mangled CreateCharaCPoly__FP6CCPolyiPfPfff
 * @address 0x1512B0
 * @size 0x1FC
 */
int CreateCharaCPoly(CCPoly *polys, int max_polys, float *pos, float *target, float distance, float half_size);

/**
 *
 * Gives back the value a fraction of the way from one value to another.
 *
 * @mangled LinerInterpolation__Ffff
 * @address 0x1514B0
 * @size 0x10
 */
float LinerInterpolation(float from, float to, float rate);

/**
 *
 * Gives back the integer that a step lies along a number of steps from one integer to another.
 *
 * @mangled LinerInterpolationI__Fiiii
 * @address 0x1514C0
 * @size 0x20
 */
int LinerInterpolationI(int from, int to, int step, int steps);

/**
 *
 * Turns a screen point about another by an angle, and writes where it lands.
 *
 * @mangled RollPos__FPfPffPf
 * @address 0x1514E0
 * @size 0xB0
 */
void RollPos(float *centre, float *pos, float angle, float *out);

/**
 *
 * Tells whether a point lies inside a rectangle.
 *
 * @mangled CheckPosInOutForRect__FP4RECTii
 * @address 0x151590
 * @size 0x64
 */
int CheckPosInOutForRect(RECT *rect, int x, int y);

/**
 *
 * Gives back how far a point lies from the centre of a rectangle.
 *
 * @mangled GetDisPosToRect__FP4RECTii
 * @address 0x151600
 * @size 0x84
 */
float GetDisPosToRect(RECT *rect, int x, int y);

/**
 *
 * Tells whether a point lies inside the box that two corner points span.
 *
 * @mangled CheckPosInOutFor2P__Fffffff
 * @address 0x151690
 * @size 0xA0
 */
int CheckPosInOutFor2P(float x0, float y0, float x1, float y1, float x, float y);

/**
 *
 * Finds where two lines, each through two points, cross, and gives back whether they do.
 *
 * @mangled CalcIntersectionPointLineAndLine__FffffffffPfPf
 * @address 0x151730
 * @size 0xEC
 */
int CalcIntersectionPointLineAndLine(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1, float *out_x, float *out_y);

/**
 *
 * Finds where two segments cross, and gives back whether they do.
 *
 * @mangled CalcIntersectionPoint2PAnd2P__FffffffffPfPf
 * @address 0x151820
 * @size 0xEC
 */
int CalcIntersectionPoint2PAnd2P(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1, float *out_x, float *out_y);
