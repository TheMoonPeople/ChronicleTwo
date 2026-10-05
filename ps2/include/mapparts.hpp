#pragma once

#include "common.h"

#include <libvu0.h>

#include "character.hpp"
#include "funcpoint.hpp"
#include "map.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_tanime.hpp"

/**
 * @file
 * Declares one placed part of a map, the pieces of model it is built from,
 * and the treasure chests that its function points place.
 */

class CCPoly;
class CFuncPoint;
class CMapPiece;
class CObjAnime;
class CObjAnimeEnv;
class COcclusion;
class mgCMemory;

/**
 * Number of material colours that one map part can override.
 */
#define MAP_PARTS_COLOR_MAX 4

/**
 * Asks which screen function point lies in front of the camera, and
 * receives the nearest one found.
 */
struct InScreenFuncInfo {
    float range;  /**< Distance from the camera within which a function point counts. */
    float unk_04;
    float dist;   /**< Distance from the camera to the function point found. */
};

STATIC_ASSERT(sizeof(InScreenFuncInfo) == 0xC);

/**
 * Places one part of a map in the world: a named group of model pieces that
 * share one frame, together with the function points (lights, animations,
 * treasure chests and screen targets) that come with the part.
 */
class CMapParts : public CObject {
public:
    char                       name[32];                         /**< Name the map gives this placement of the part. */
    char                       parts_name[32];                   /**< Name of the part that was placed. */
    CList<CMapPiece>          *piece_list;                       /**< First node of the list of pieces the part is built from. */
    mgCFrame                   frame;                            /**< Frame that places every piece of the part in the world. */
    s32                        lod_num;                          /**< Number of levels of detail the part has distances for. */
    s32                        lod_blend;                        /**< Non-zero blends between levels of detail. */
    float                     *lod_dist;                         /**< Distance at which each level of detail starts. */
    s32                        unk_1dc;
    float                      fixed_time;                       /**< Time of day the function points are checked against; below zero to use the scene's time. */
    s32                        need_step;                        /**< Non-zero while a piece of the part moves and must be stepped every frame. */
    s32                        color_num;                        /**< Number of entries of color in use. */
    sceVu0FVECTOR              color[MAP_PARTS_COLOR_MAX];       /**< Colour given to the materials of each colour number; a W of zero or below leaves them as they are. */
    s32                        bound_valid;                      /**< Non-zero while bound_box holds the extent of the drawn pieces. */
    mgVu0FBOX                  bound_box;                        /**< Extent of the drawn pieces, in the part's own space. */
    sceVu0FVECTOR              bound_sphere;                     /**< Sphere around bound_box: centre in XYZ, radius in W. */
    s32                        col_bound_valid;                  /**< Non-zero while col_bound_box holds the extent of the collision pieces. */
    mgVu0FBOX                  col_bound_box;                    /**< Extent of the collision pieces, in the part's own space. */
    sceVu0FVECTOR              col_bound_sphere;                 /**< Sphere around col_bound_box: centre in XYZ, radius in W. */
    CFuncPointMngr             func_point_mngr;                  /**< Function points that come with the part. */
    s32                        no_light;                         /**< Non-zero draws the part with the scene's lights cleared, lit only by its own light points. */
    s32                        no_plight;                        /**< Non-zero draws the part with point lights turned off. */
    u32                        move_flag;                        /**< Four flags that the map's MOVE_FLAG command sets, read by the automap. */
    CList<CObjAnime>          *anime_list;                       /**< First node of the list of animations the function points drive. */
    s32                        group_no;                         /**< Group of parts the placement belongs to, or -1. */
    s32                        in_screen;                        /**< Non-zero while the part is on screen this frame. */
    CFuncPointCheck            func_check;                       /**< Conditions the function points were last checked against. */

    /**
     * Makes a part that holds no pieces.
     *
     * @mangled __ct__9CMapPartsFv
     * @address 0x15DF40
     * @size 0xA0
     */
    CMapParts();

    /**
     * Draws every piece of the part through the drawing list, lit by the
     * part's light points.
     *
     * @mangled Draw__9CMapPartsFv
     * @address 0x15F7E0
     * @size 0x10
     */
    virtual int Draw();

    /**
     * Draws every piece of the part straight away, lit by the part's light
     * points.
     *
     * @mangled DrawDirect__9CMapPartsFv
     * @address 0x15F7F0
     * @size 0x10
     */
    virtual int DrawDirect();

    /**
     * Empties the part: no pieces, no function points, no colours, and the
     * frame and bounds cleared.
     *
     * @mangled Initialize__9CMapPartsFv
     * @address 0x167660
     * @size 0x110
     */
    virtual void Initialize();

    /**
     * Gives back non-zero when the part is to be drawn this frame and lies
     * within its far clip distance.
     *
     * @mangled PreDraw__9CMapPartsFv
     * @address 0x167E10
     * @size 0x70
     */
    virtual int PreDraw();

    /**
     * Brings the frame up to date and steps the drawing of every piece.
     *
     * @mangled DrawStep__9CMapPartsFv
     * @address 0x168260
     * @size 0x80
     */
    virtual void DrawStep();

    /**
     * Steps every piece of the part that moves.
     *
     * @mangled Step__9CMapPartsFv
     * @address 0x168CF0
     * @size 0x90
     */
    virtual void Step();

    /**
     * Steps every animation of the part whose function point passes a check.
     *
     * @mangled AnimeStep__9CMapPartsFP15CFuncPointCheckP12CObjAnimeEnv
     * @address 0x168D80
     * @size 0x80
     */
    virtual void AnimeStep(CFuncPointCheck *check, CObjAnimeEnv *env);

    /**
     * Copies a changed position, rotation and scale into the frame.
     *
     * @mangled UpDatePosition__9CMapPartsFv
     * @address 0x167B00
     * @size 0x70
     */
    virtual void UpDatePosition();

    /**
     * Copies the part into another; with a memory pool, also makes the
     * other part its own copies of the pieces, function points and
     * animations.
     *
     * @mangled Copy__9CMapPartsFR9CMapPartsP9mgCMemory
     * @address 0x168EB0
     * @size 0x6B0
     */
    virtual void Copy(CMapParts &dest, mgCMemory *memory);

    /**
     * Names this placement of the part; a name of 32 characters or more is
     * ignored.
     *
     * @mangled SetName__9CMapPartsFPc
     * @address 0x167770
     * @size 0x60
     */
    void SetName(char *new_name);

    /**
     * Names the part that was placed; a name of 32 characters or more is
     * ignored.
     *
     * @mangled SetPartsName__9CMapPartsFPc
     * @address 0x1677D0
     * @size 0x60
     */
    void SetPartsName(char *new_name);

    /**
     * Adds a piece to the end of the part's list of pieces.
     *
     * @mangled AddPiece__9CMapPartsFP17CList_9CMapPiece_
     * @address 0x167830
     * @size 0x70
     */
    void AddPiece(CList<CMapPiece> *piece);

    /**
     * Finds the piece with a given name, or gives back NULL.
     *
     * @mangled SearchPiece__9CMapPartsFPc
     * @address 0x1678A0
     * @size 0x90
     */
    CMapPiece *SearchPiece(char *piece_name);

    /**
     * Finds the first piece with a given collision type, or gives back NULL.
     *
     * @mangled SearchPieceColType__9CMapPartsFi
     * @address 0x167930
     * @size 0x60
     */
    CMapPiece *SearchPieceColType(int col_type);

    /**
     * Copies the polygons of one kind that meet a box from every piece into
     * an array, and gives back how many were copied.
     *
     * @mangled GetPoly__9CMapPartsFiP6CCPolyR9mgVu0FBOXi
     * @address 0x167990
     * @size 0x130
     */
    int GetPoly(int kind, CCPoly *poly, mgVu0FBOX &box, int max);

    /**
     * Copies the collision polygons that meet a box into an array, and gives
     * back how many were copied.
     *
     * @mangled GetColPoly__9CMapPartsFP6CCPolyR9mgVu0FBOXi
     * @address 0x167AC0
     * @size 0x20
     */
    int GetColPoly(CCPoly *poly, mgVu0FBOX &box, int max);

    /**
     * Copies the polygons that stop the camera and meet a box into an array,
     * and gives back how many were copied.
     *
     * @mangled GetCameraPoly__9CMapPartsFP6CCPolyR9mgVu0FBOXi
     * @address 0x167AE0
     * @size 0x20
     */
    int GetCameraPoly(CCPoly *poly, mgVu0FBOX &box, int max);

    /**
     * Sets the colour of one colour number; gives back 0 for a number out
     * of range.
     *
     * @mangled SetColor__9CMapPartsFiPf
     * @address 0x167B70
     * @size 0x50
     */
    int SetColor(int no, float *rgba);

    /**
     * Gets the colour of one colour number; gives back 0 for a number out
     * of range.
     *
     * @mangled GetColor__9CMapPartsFiPf
     * @address 0x167BC0
     * @size 0x40
     */
    int GetColor(int no, float *out_rgba);

    /**
     * Gets the colour that the first material of a colour number has in the
     * model data; gives back 0 when no material has that number.
     *
     * @mangled GetDefColor__9CMapPartsFiPf
     * @address 0x167C00
     * @size 0xF0
     */
    int GetDefColor(int no, float *out_rgba);

    /**
     * Copies every colour that is in use into the materials of its colour
     * number.
     *
     * @mangled UpdateColor__9CMapPartsFv
     * @address 0x167CF0
     * @size 0x120
     */
    void UpdateColor();

    /**
     * Lights the part with its light points and draws every piece that is
     * shown at the current time, through the drawing list or straight away;
     * gives back the number drawn.
     *
     * @mangled DrawSub__9CMapPartsFi
     * @address 0x167E80
     * @size 0x3C0
     */
    int DrawSub(int direct);

    /**
     * Measures the extent and bounding sphere of the drawn pieces and of the
     * collision pieces; gives back non-zero when either has any.
     *
     * @mangled CreateBoundBox__9CMapPartsFv
     * @address 0x1682E0
     * @size 0x1C0
     */
    int CreateBoundBox();

    /**
     * Gives back non-zero when the collision pieces of the part meet a world
     * box.
     *
     * @mangled CheckColBox__9CMapPartsFP9mgVu0FBOX
     * @address 0x1684A0
     * @size 0x140
     */
    int CheckColBox(mgVu0FBOX *box);

    /**
     * Gets the extent of the drawn pieces in the part's own space; gives
     * back 0 when it has not been measured.
     *
     * @mangled GetBBox__9CMapPartsFP9mgVu0FBOX
     * @address 0x1685E0
     * @size 0x50
     */
    int GetBBox(mgVu0FBOX *out_box);

    /**
     * Gets the extent of the drawn pieces in world space; gives back 0 when
     * it has not been measured.
     *
     * @mangled GetBoundBox__9CMapPartsFP9mgVu0FBOX
     * @address 0x168630
     * @size 0x60
     */
    int GetBoundBox(mgVu0FBOX *out_box);

    /**
     * Gets the bounding sphere of the drawn pieces in world space; gives
     * back 0 when it has not been measured.
     *
     * @mangled GetBoundSphere__9CMapPartsFPf
     * @address 0x168690
     * @size 0x80
     */
    int GetBoundSphere(float *out_sphere);

    /**
     * Gets the matrix that takes the part's own space into world space.
     *
     * @mangled GetLWMatrix__9CMapPartsFPA4_f
     * @address 0x168710
     * @size 0x50
     */
    void GetLWMatrix(sceVu0FMATRIX out_matrix);

    /**
     * Gives back non-zero while the drawn pieces lie at least partly on
     * screen.
     *
     * @mangled InsideScreen__9CMapPartsFv
     * @address 0x168760
     * @size 0x50
     */
    int InsideScreen();

    /**
     * Gives back non-zero while the drawn pieces lie on screen and no
     * occluder hides their bounding sphere.
     *
     * @mangled InsideScreen__9CMapPartsFP10COcclusioni
     * @address 0x1687B0
     * @size 0x110
     */
    int InsideScreen(COcclusion *occlusion, int occlusion_num);

    /**
     * Finds the nearest screen function point of the part that the camera
     * looks at within range, or gives back NULL.
     *
     * @mangled InScreenFunc__9CMapPartsFP16InScreenFuncInfo
     * @address 0x1688C0
     * @size 0x280
     */
    CFuncPoint *InScreenFunc(InScreenFuncInfo *info);

    /**
     * Draws a frame over every screen function point of the part that lies
     * near enough to the camera.
     *
     * @mangled DrawScreenFunc__9CMapPartsFP8mgCFrame
     * @address 0x168B40
     * @size 0x1B0
     */
    void DrawScreenFunc(mgCFrame *marker);

    /**
     * Brings the function points of the part up to date with a check of
     * the scene's conditions, and steps its light points.
     *
     * @mangled StepFuncPoint__9CMapPartsFR15CFuncPointCheck
     * @address 0x168E00
     * @size 0x70
     */
    void StepFuncPoint(CFuncPointCheck &check);

    /**
     * Keeps the scene's conditions for the function points, with the part's
     * own time of day in place of the scene's when it has one.
     *
     * @mangled CopyFuncPointCheck__9CMapPartsFR15CFuncPointCheck
     * @address 0x168E70
     * @size 0x40
     */
    void CopyFuncPointCheck(CFuncPointCheck &check);

    /**
     * Makes an animation for every animation function point of the part;
     * gives back 0 when the memory pool runs out.
     *
     * @mangled AssignFuncAnime__9CMapPartsFP9mgCMemory
     * @address 0x169560
     * @size 0x140
     */
    int AssignFuncAnime(mgCMemory *memory);

    /**
     * Sets the distances at which each level of detail starts.
     *
     * @mangled SetLODDist__9CMapPartsFPfi
     * @address 0x163490
     * @size 0x10
     */
    void SetLODDist(float *dist, int num) {
        lod_num = num;
        lod_dist = dist;
    }

    /**
     * Sets whether levels of detail are blended.
     *
     * @mangled SetLODBlend__9CMapPartsFi
     * @address 0x163500
     * @size 0x10
     */
    void SetLODBlend(int blend) { lod_blend = blend; }

    /**
     * Gets whether levels of detail are blended.
     *
     * @mangled GetLODBlend__9CMapPartsFv
     * @address 0x1635C0
     * @size 0x10
     */
    int GetLODBlend() { return lod_blend; }
};

STATIC_ASSERT(sizeof(CMapParts) == 0x310);

/**
 * Treasure chest that a function point of a map or map part places, holding
 * the item it gives and the flag that records it was opened.
 */
class CMapTreasureBox : public CCharacter2 {
public:
    s32         active;     /**< Non-zero while the chest stands closed in the map. */
    s32         flag_no;    /**< Map flag that records the chest as opened; 0 or below for none. */
    s32         item_no;    /**< Item the chest gives, or -1. */
    s32         item_num;   /**< Number of the item the chest gives. */
    s32         floor_id;   /**< Dungeon and floor the chest belongs to, as dungeon * 100 + floor; -1 for none. */
    CFuncPoint *func_point; /**< Function point that placed the chest. */
    CMapParts  *parts;      /**< Map part whose frame the chest follows; NULL for the map itself. */

    /**
     * Makes a chest that no function point has placed.
     *
     * @mangled __ct__15CMapTreasureBoxFv
     * @address 0x161970
     * @size 0xC0
     */
    CMapTreasureBox();

    /**
     * Clears the chest to one that no function point has placed.
     *
     * @mangled Initialize__15CMapTreasureBoxFv
     * @address 0x1696B0
     * @size 0x50
     */
    virtual void Initialize();

    /**
     * Places the chest where a function point says, attached to a map part's
     * frame, and takes its item and flag from the function point; gives
     * back 0 without a function point.
     *
     * @mangled AssignFuncPoint__15CMapTreasureBoxFP10CFuncPointP9CMapParts
     * @address 0x169700
     * @size 0xD0
     */
    int AssignFuncPoint(CFuncPoint *point, CMapParts *owner);

    /**
     * Gets the world position of the chest's model.
     *
     * @mangled GetWorldPosition__15CMapTreasureBoxFPf
     * @address 0x1697D0
     * @size 0x50
     */
    void GetWorldPosition(float *out_position);
};

STATIC_ASSERT(sizeof(CMapTreasureBox) == 0x680);
