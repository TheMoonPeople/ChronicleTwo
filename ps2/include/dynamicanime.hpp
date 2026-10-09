#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the dynamic animation that swings cloth, hair and other loose parts of a model as a set of
 * vertices moved by gravity, wind and collisions, and the collision volumes those vertices are kept out of.
 */

class mgCFrame;
class mgCMemory;

/**
 *
 * Ways a frame pose turns four vertices into the orientation of a frame.
 *
 */
enum DA_FRAME_POSE_TYPE {
    DA_FRAME_POSE_NONE = 0,    /**< Leaves the frame unposed. */
    DA_FRAME_POSE_BONE = 1,    /**< "bone": z runs from the first vertex to the second and x towards the midpoint of the last two, from the midpoint of the first two. */
    DA_FRAME_POSE_BONE_YX = 2, /**< "bone_yx": as DA_FRAME_POSE_BONE with y, not z, running from the first vertex to the second. */
    DA_FRAME_POSE_B_CDLR = 3,  /**< "b_cdlr": x runs from the first vertex to the second and z from the fourth to the third, from the first vertex. */
};

/**
 *
 * Places one frame of the model from the positions of four simulated vertices.
 *
 */
struct DA_FRAME_POSE {
    int  type;       /**< How the vertices give the orientation, a DA_FRAME_POSE_TYPE. */
    int  vertex_num; /**< Number of entries in vertex_id. */
    int *vertex_id;  /**< Indices of the vertices the pose is built from. */
    int  local;      /**< Whether the pose is made relative to the frame's parent rather than set as the frame's world transform. */
};

STATIC_ASSERT(sizeof(DA_FRAME_POSE) == 0x10);

/**
 *
 * Ties a simulated vertex to a point fixed in the space of one frame of the model.
 *
 */
struct DA_FIX_VERTEX {
    sceVu0FVECTOR position;      /**< Point the vertex is tied to, in the frame's space. */
    int           frame_id;      /**< Index in the frame table of the frame the point moves with, or -1 when the vertex is free. */
    float         weight;        /**< How far the vertex is pulled onto the point each step; 1.0 or more holds it there. */
    float         velocity_rate; /**< Part of the pull taken back out of the vertex's velocity. */
    float         unk_1c;
};

STATIC_ASSERT(sizeof(DA_FIX_VERTEX) == 0x20);

/**
 *
 * Keeps two simulated vertices at the distance they had when the animation was loaded.
 *
 */
struct DA_BIND_VERTEX {
    int   vertex_id[2]; /**< Indices of the two vertices. */
    float rate;         /**< Share of the correction given to the second vertex; the first takes the rest. */
    float length;       /**< Distance the vertices are held at. */
};

STATIC_ASSERT(sizeof(DA_BIND_VERTEX) == 0x10);

/**
 *
 * Box read from the BOUNDING_BOX tag of an animation script, given in the space of one frame.
 *
 */
struct DA_BOUNDING_BOX {
    sceVu0FVECTOR min;      /**< Minimum corner of the animated bounding box. */
    sceVu0FVECTOR max;      /**< Maximum corner of the animated bounding box. */
    int           frame_id; /**< Index in the frame table of the frame the box belongs to, or -1. */
};

STATIC_ASSERT(sizeof(DA_BOUNDING_BOX) == 0x30);

/**
 *
 * A volume attached to a frame of the model that simulated vertices are pushed out of. The base volume hits nothing.
 *
 */
class CDACollision {
public:
    int           frame_id;       /**< Index in the frame table of the frame the volume moves with. */
    float         friction;       /**< Factor applied to the velocity of a vertex that touches the volume. */
    sceVu0FVECTOR center;         /**< Centre of the volume in the frame's space. */
    sceVu0FVECTOR radius;         /**< Half-size of the volume along each axis of the frame. */
    mgCFrame     *frame;          /**< Frame the volume moves with, looked up before each step, or null. */
    sceVu0FMATRIX lw_matrix;      /**< Local-to-world matrix of the frame for the current step. */
    sceVu0FMATRIX inverse_matrix; /**< World-to-local matrix of the frame for the current step. */

    /**
     *
     * Pushes a world-space point out of the volume. Returns whether the
     * point was inside. The base volume hits nothing.
     *
     * @mangled CheckHit__12CDACollisionFPf
     * @address 0x17B2A0
     * @size 0x10
     */
    virtual int CheckHit(float *position);

    /**
     *
     * Puts the volume at the frame's origin with no size and the default
     * friction.
     *
     * @mangled Initialize__12CDACollisionFv
     * @address 0x17D260
     * @size 0x40
     */
    virtual void Initialize();

    /**
     *
     * Makes a volume with its fields at their defaults.
     *
     */
    CDACollision() { Initialize(); }
};

STATIC_ASSERT(sizeof(CDACollision) == 0xD0);

/**
 *
 * A collision volume shaped as an elliptic cylinder: the "pipe" volume of an animation script.
 *
 */
class CDAColPipe : public CDACollision {
public:
    int axis; /**< Axis of the frame the cylinder runs along: 0 for x, 1 for y, 2 for z. */

    /**
     *
     * Pushes a world-space point lying within the cylinder's length out
     * through its side. Returns whether the point was inside.
     *
     * @mangled CheckHit__10CDAColPipeFPf
     * @address 0x17D4D0
     * @size 0x1B0
     */
    virtual int CheckHit(float *point);

    /**
     *
     * Puts the cylinder along the frame's x axis at its origin with no size
     * and the default friction.
     *
     * @mangled Initialize__10CDAColPipeFv
     * @address 0x17D220
     * @size 0x40
     */
    virtual void Initialize();

    /**
     *
     * Makes a cylinder with its fields at their defaults.
     *
     */
    CDAColPipe() { Initialize(); }
};

STATIC_ASSERT(sizeof(CDAColPipe) == 0xE0);

/**
 *
 * Moves a set of vertices attached to a character's model under gravity, wind and collisions, and poses
 * frames of the model from them, so that cloth and hair swing as the character moves.
 *
 */
class CDynamicAnime {
public:
    mgCFrame        *top_frame;         /**< Root frame of the model the animation moves. */
    int              frame_num;         /**< Number of entries in frame. */
    mgCFrame       **frame;             /**< Frames of the model the animation refers to by index. */
    DA_FRAME_POSE   *frame_pose;        /**< Pose of each entry of frame, frame_num entries. */
    int              vertex_num;        /**< Number of simulated vertices. */
    sceVu0FVECTOR   *init_vertex;       /**< World position of each vertex as loaded. */
    sceVu0FVECTOR   *now_vertex;        /**< Position of each vertex in the current step. */
    sceVu0FVECTOR   *old_vertex;        /**< Position of each vertex in the previous step. */
    sceVu0FVECTOR   *velocity;          /**< Velocity of each vertex. */
    sceVu0FVECTOR   *world_init_vertex; /**< Loaded positions moved by the root frame's matrix, made each step while k is positive. */
    int              fix_vertex_num;    /**< Number of entries the fix vertex table was made for. */
    DA_FIX_VERTEX   *fix_vertex;        /**< Point each vertex is tied to, indexed by vertex. */
    int              draw_frame_num;    /**< Number of entries in draw_frame. */
    int             *draw_frame;        /**< Indices in frame of the frames drawn with the animation, -1 for none. */
    int              bind_vertex_num;   /**< Number of entries in bind_vertex. */
    DA_BIND_VERTEX  *bind_vertex;       /**< Pairs of vertices held at a fixed distance. */
    int              bbox_num;          /**< Number of entries in bbox. */
    DA_BOUNDING_BOX *bbox;              /**< Boxes read from the animation script. */
    int              collision_num;     /**< Number of entries in collision. */
    CDACollision   **collision;         /**< Volumes the vertices are pushed out of; an entry may be null. */
    sceVu0FVECTOR    gravity;           /**< Velocity added to each vertex every step. */
    float            k;                 /**< Value of the script's K tag; a positive value makes world_init_vertex each step. */
    float            wind_scale;        /**< Factor applied to the wind, from the script's WIND tag. */
    float            wind_power;        /**< Strength of the wind, or 0.0 for none. */
    sceVu0FVECTOR    wind_dir;          /**< Unit direction the wind blows in. */
    int              wind_seed;         /**< State of the random sequence that makes the wind gust. */
    float            wind_gust;         /**< Current strength of the gust, kept between 0.0 and 1.0. */
    int              floor_enable;      /**< Whether the vertices are kept above floor_y. */
    float            floor_y;           /**< Height the vertices may not fall below while floor_enable is set. */

    /**
     *
     * Makes an empty animation with its fields at their defaults.
     *
     * @mangled __ct__13CDynamicAnimeFv
     * @address 0x178300
     * @size 0x30
     */
    CDynamicAnime();

    /**
     *
     * Puts every vertex back on its loaded position, moved by the root
     * frame's matrix, at rest.
     *
     * @mangled ResetPosition__13CDynamicAnimeFv
     * @address 0x17ACB0
     * @size 0xA0
     */
    void ResetPosition();

    /**
     *
     * Moves the vertices one step under gravity, ties, distance limits,
     * collisions, the floor and the wind, then poses the frames from them.
     *
     * @mangled Step__13CDynamicAnimeFv
     * @address 0x17AD50
     * @size 0x550
     */
    void Step();

    /**
     *
     * Makes the wind blow with a strength in a direction.
     *
     * @mangled SetWind__13CDynamicAnimeFfPf
     * @address 0x17B2B0
     * @size 0x10
     */
    void SetWind(float power, float *dir);

    /**
     *
     * Stops the wind.
     *
     * @mangled ResetWind__13CDynamicAnimeFv
     * @address 0x17B2C0
     * @size 0x10
     */
    void ResetWind();

    /**
     *
     * Keeps the vertices above a height.
     *
     * @mangled SetFloor__13CDynamicAnimeFf
     * @address 0x17B2D0
     * @size 0x10
     */
    void SetFloor(float height);

    /**
     *
     * Lets the vertices fall to any height.
     *
     * @mangled ResetFloor__13CDynamicAnimeFv
     * @address 0x17B2E0
     * @size 0x10
     */
    void ResetFloor();

    /**
     *
     * Sets a frame's transform from the vertices its pose names.
     *
     * @mangled FramePose__13CDynamicAnimeFP8mgCFrameP13DA_FRAME_POSE
     * @address 0x17B2F0
     * @size 0x340
     */
    void FramePose(mgCFrame *frame, DA_FRAME_POSE *pose);

    /**
     *
     * Looks up the frame of each collision volume and takes its matrices for
     * the coming step.
     *
     * @mangled PreCollision__13CDynamicAnimeFv
     * @address 0x17B630
     * @size 0xB0
     */
    void PreCollision();

    /**
     *
     * Empties the animation and puts gravity, wind and floor back to their
     * defaults.
     *
     * @mangled Initialize__13CDynamicAnimeFv
     * @address 0x17B6E0
     * @size 0xC0
     */
    void Initialize();

    /**
     *
     * Makes empty frame and frame pose tables of a size.
     *
     * @mangled NewFrameTable__13CDynamicAnimeFiP9mgCMemory
     * @address 0x17B7A0
     * @size 0xF0
     */
    void NewFrameTable(int count, mgCMemory *memory);

    /**
     *
     * Makes the per-vertex position and velocity tables for a number of
     * vertices.
     *
     * @mangled NewVertexTable__13CDynamicAnimeFiP9mgCMemory
     * @address 0x17B890
     * @size 0x160
     */
    void NewVertexTable(int count, mgCMemory *memory);

    /**
     *
     * Makes an empty fix vertex table of a size.
     *
     * @mangled NewFixVertexTable__13CDynamicAnimeFiP9mgCMemory
     * @address 0x17B9F0
     * @size 0xA0
     */
    void NewFixVertexTable(int count, mgCMemory *memory);

    /**
     *
     * Makes a draw frame table of a size with no frame in it.
     *
     * @mangled NewDrawFrameTable__13CDynamicAnimeFiP9mgCMemory
     * @address 0x17BA90
     * @size 0x90
     */
    void NewDrawFrameTable(int count, mgCMemory *memory);

    /**
     *
     * Makes an empty bind vertex table of a size.
     *
     * @mangled NewBindVertexTable__13CDynamicAnimeFiP9mgCMemory
     * @address 0x17BB20
     * @size 0xA0
     */
    void NewBindVertexTable(int count, mgCMemory *memory);

    /**
     *
     * Makes an empty bounding box table of a size.
     *
     * @mangled NewBoundingBoxTable__13CDynamicAnimeFiP9mgCMemory
     * @address 0x17BBC0
     * @size 0xB0
     */
    void NewBoundingBoxTable(int count, mgCMemory *memory);

    /**
     *
     * Makes a collision table of a size with no volume in it.
     *
     * @mangled NewCollisionTable__13CDynamicAnimeFiP9mgCMemory
     * @address 0x17BC70
     * @size 0x80
     */
    void NewCollisionTable(int count, mgCMemory *memory);

    /**
     *
     * Puts a frame into the frame table, if the index is in range.
     *
     * @mangled SetFrame__13CDynamicAnimeFiP8mgCFrame
     * @address 0x17BCF0
     * @size 0x40
     */
    void SetFrame(int index, mgCFrame *frame);

    /**
     *
     * Gets a frame from the frame table, or null when the index is out of
     * range.
     *
     * @mangled GetFrame__13CDynamicAnimeFi
     * @address 0x17BD30
     * @size 0x40
     */
    mgCFrame *GetFrame(int index);

    /**
     *
     * Gets the pose of an entry of the frame table, or null when the index
     * is out of range.
     *
     * @mangled pGetFramePose__13CDynamicAnimeFi
     * @address 0x17BD70
     * @size 0x40
     */
    DA_FRAME_POSE *pGetFramePose(int index);

    /**
     *
     * Tells whether a vertex index is in range.
     *
     * @mangled CheckVertexID__13CDynamicAnimeFi
     * @address 0x17BDB0
     * @size 0x30
     */
    int CheckVertexID(int index);

    /**
     *
     * Sets a vertex's loaded position, if the index is in range.
     *
     * @mangled SetInitVertex__13CDynamicAnimeFiPf
     * @address 0x17BDE0
     * @size 0x60
     */
    void SetInitVertex(int index, float *position);

    /**
     *
     * Gets a vertex's loaded position, if the index is in range.
     *
     * @mangled GetInitVertex__13CDynamicAnimeFiPf
     * @address 0x17BE40
     * @size 0x60
     */
    void GetInitVertex(int index, float *pos);

    /**
     *
     * Sets a vertex's current position, if the index is in range.
     *
     * @mangled SetNowVertex__13CDynamicAnimeFiPf
     * @address 0x17BEA0
     * @size 0x60
     */
    void SetNowVertex(int index, float *position);

    /**
     *
     * Sets a vertex's previous position, if the index is in range.
     *
     * @mangled SetOldVertex__13CDynamicAnimeFiPf
     * @address 0x17BF00
     * @size 0x60
     */
    void SetOldVertex(int index, float *position);

    /**
     *
     * Gets an entry of the fix vertex table, or null when the index is out
     * of range.
     *
     * @mangled pGetFixVertex__13CDynamicAnimeFi
     * @address 0x17BF60
     * @size 0x40
     */
    DA_FIX_VERTEX *pGetFixVertex(int index);

    /**
     *
     * Puts the index of a frame into the draw frame table, if the index is
     * in range.
     *
     * @mangled SetDrawFrame__13CDynamicAnimeFii
     * @address 0x17BFA0
     * @size 0x40
     */
    void SetDrawFrame(int index, int frame_id);

    /**
     *
     * Gets the frame an entry of the draw frame table names, or null when
     * the index is out of range.
     *
     * @mangled GetDrawFrame__13CDynamicAnimeFi
     * @address 0x17BFE0
     * @size 0x50
     */
    mgCFrame *GetDrawFrame(int index);

    /**
     *
     * Gets an entry of the bind vertex table, or null when the index is out
     * of range.
     *
     * @mangled pGetBindVertex__13CDynamicAnimeFi
     * @address 0x17C030
     * @size 0x40
     */
    DA_BIND_VERTEX *pGetBindVertex(int index);

    /**
     *
     * Gets an entry of the bounding box table, or null when the index is out
     * of range.
     *
     * @mangled pGetBoundingBox__13CDynamicAnimeFi
     * @address 0x17C070
     * @size 0x40
     */
    DA_BOUNDING_BOX *pGetBoundingBox(int index);

    /**
     *
     * Puts a volume into the collision table, if the index is in range.
     *
     * @mangled SetCollision__13CDynamicAnimeFiP12CDACollision
     * @address 0x17C0B0
     * @size 0x40
     */
    void SetCollision(int index, CDACollision *collision);

    /**
     *
     * Draws the frames of the draw frame table, queued or at once. Returns
     * the total the drawing calls give.
     *
     * @mangled DrawSub__13CDynamicAnimeFi
     * @address 0x17C0F0
     * @size 0xA0
     */
    int DrawSub(int direct);

    /**
     *
     * Copies the animation into another for a copy of the model, finding the
     * same frames in the new model and giving it its own vertex tables.
     *
     * @mangled Copy__13CDynamicAnimeFR13CDynamicAnimeP8mgCFrameP9mgCMemory
     * @address 0x17C190
     * @size 0x410
     */
    void Copy(CDynamicAnime &dest, mgCFrame *root, mgCMemory *memory);

    /**
     *
     * Builds the animation from a script for a model, with the model held
     * at the origin, unrotated and unscaled while the script runs.
     *
     * @mangled Load__13CDynamicAnimeFPciP8mgCFrameP9mgCMemory
     * @address 0x17D340
     * @size 0x190
     */
    void Load(char *name, int size, mgCFrame *top_frame, mgCMemory *memory);
};

STATIC_ASSERT(sizeof(CDynamicAnime) == 0x90);
