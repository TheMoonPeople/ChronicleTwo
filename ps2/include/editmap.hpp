#pragma once

#include "common.h"

#include <libvu0.h>

#include "editinfo.hpp"
#include "editparts.hpp"
#include "map.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "sceneload.hpp"

/**
 * @file
 * Declares the map of a town being built in the Georama editor: the edit
 * parts placed in it, the houses and the placement log they keep, the river
 * grids laid on its ground, and the checks that decide where a part may go.
 */

class mgCFrame;
class mgCMemory;
class CCPoly;
class CEditData;
class CEditGrid;
class CFuncPoint;
class CMapParts;
class CMapPiece;
class CObjAnimeEnv;
struct EMAP_MESSAGE;
struct InScreenFuncInfo;
struct MapEventInfo;
struct mgVu0FBOX;

/**
 *
 * Capacities of the fixed tables an edit map holds, and the steps its placement angles are counted in.
 *
 */
enum {
    EDIT_MAP_HOUSE_MAX = 32,       /**< Houses an edit map holds. */
    EDIT_MAP_GRID_MAX = 4,         /**< River grids an edit map holds. */
    EDIT_MAP_RIVER_PARTS_MAX = 8,  /**< Ground parts that river pieces are made for. */
    EDIT_MAP_MASK_PIECE_MAX = 1,   /**< Models that mask the river. */
    EDIT_MAP_BALANCE_MAX = 4,      /**< Ground pieces that tilt to show how the town's weight is balanced. */
    EDIT_MAP_LOG_PER_PARTS = 4,    /**< Placement log entries kept for each edit part slot. */
    EDIT_ANGLE_MAX = 24,           /**< Steps of a full turn that placement angles are counted in (15 degrees each). */
    EDIT_ANGLE_90 = 6,             /**< Steps of a quarter turn. */
    EP_PLACE_BASE_MAX = 16,        /**< Parts that a placement can rest on. */
    EDIT_REMOVE_INFO_ID_MAX = 256, /**< Part definitions that a removal counts. */
    EDIT_REMOVE_HOUSE_MAX = 32,    /**< Villagers that a removal can leave without a house. */
};

/**
 *
 * Failures of CEditMap::BuildEditParts and CEditMap::eNewPlaceParts, given in place of a slot number.
 *
 */
enum EditBuildResult {
    EDIT_BUILD_NO_INFO = -1,  /**< No part definition or map part of that name, or no room left to build its model. */
    EDIT_BUILD_NO_SLOT = -2,  /**< Every edit part slot is in use. */
    EDIT_BUILD_NO_HOUSE = -3, /**< The part gives a house and every house is in use. */
};

/**
 *
 * Result of the checks on a placement: the placed parts the new part rests on.
 *
 */
struct EP_PLACE_INFO {
    s32 num;                       /**< Number of placed parts in base. */
    s32 base[EP_PLACE_BASE_MAX];   /**< Slot numbers of the placed parts the new part rests on. */
    s32 unk_44;
};

STATIC_ASSERT(sizeof(EP_PLACE_INFO) == 0x48);

/**
 *
 * Entry of an edit map's placement log, recording that one placed part rests on another.
 *
 */
struct EditPlaceLog {
    s16 parts_no; /**< Slot number of the part that rests on the other, or below zero when the entry is free. */
    s16 base_no;  /**< Slot number of the part it rests on. */
};

STATIC_ASSERT(sizeof(EditPlaceLog) == 0x4);

/**
 *
 * Map of a town being built in the Georama editor, holding the edit parts placed in it on top of the map's own parts.
 *
 */
class CEditMap : public CMap {
public:
    /**
     *
     * Tally of what a removal took away, so that the parts and villagers can be given back.
     *
     */
    struct RemoveInfo {
        s32 force;                                    /**< Removes parts even when their definition protects them. */
        s32 color_num;                                /**< Number of colours in color. */
        float (*color)[4];                            /**< Paint colours whose use is given back. */
        s32 *paint_num;                               /**< Paint given back for each colour in color. */
        s32 parts_num[EDIT_REMOVE_INFO_ID_MAX];       /**< Parts removed of each definition ID. */
        s32 house_num;                                /**< Number of villagers in house_npc. */
        s32 house_npc[EDIT_REMOVE_HOUSE_MAX];         /**< Villagers whose house was removed. */
    };

    mgCMemory parts_heap;                                  /**< Heap that the models of the edit parts are built in. */
    s32 edit_parts_max;                                    /**< Number of slots in edit_parts. */
    CEditParts *edit_parts;                                /**< Slots of the edit parts that can be placed. */
    CEditHouse house[EDIT_MAP_HOUSE_MAX];                  /**< Houses that placed buildings give. */
    s32 place_log_max;                                     /**< Number of entries in place_log. */
    EditPlaceLog *place_log;                               /**< Which placed part rests on which. */
    s32 grid_max;                                          /**< Number of slots in grid. */
    CEditGrid *grid[EDIT_MAP_GRID_MAX];                    /**< River grids laid on the ground parts, or NULL. */
    s32 focus_parts;                                       /**< Slot number of the placed part drawn flashing, or -1. */
    s32 frame;                                             /**< Steps counted for the flashing of focus_parts. */
    mgCObjectStack<CList<EMAP_MESSAGE> > message;          /**< Messages of the edit map. */
    s32 area_no;                                           /**< Georama area being built, copied from the scene, or -1. */
    s32 balance_weight[EDIT_MAP_BALANCE_MAX];              /**< Weight resting on each balance ground piece. */
    CEditInfoMngr info_mngr;                               /**< Definitions of the parts that can be placed, and the parts placed from the start. */
    CMapParts *river_parts[EDIT_MAP_RIVER_PARTS_MAX];      /**< Ground parts that river pieces are made for, or NULL. */
    CEditPartsInfo *river_info;                            /**< Definitions made from the collision of each of river_parts. */
    CMapPiece *river_piece[EDIT_MAP_RIVER_PARTS_MAX];      /**< Models the river is drawn with on each of river_parts. */
    CMapPiece *water_piece;                                /**< Model of the river's water surface. */
    CMapPiece *mask_piece[EDIT_MAP_MASK_PIECE_MAX];        /**< Models that mask the ground under the river. */
    float river_poly_margin;                               /**< Distance by which river polygons are grown for collision. */
    s32 fence_num;                                         /**< Number of fences in fence_list during a paint. */
    CEditParts **fence_list;                               /**< Fences not yet reached during a paint. */
    CEditParts *fence_now;                                 /**< Fence being tested during a paint. */
    sceVu0FVECTOR fence_color;                             /**< Colour a paint gives to fences. */
    s32 paint_num;                                         /**< Paint left during a paint. */
    u8 unk_1024[0x2C];
    s32 balance_moved;                                     /**< Nonzero once balance_base_pos holds the balance pieces' positions before tilting. */
    CMapParts *balance_parts[EDIT_MAP_BALANCE_MAX];        /**< Ground pieces that tilt to show the town's balance. */
    sceVu0FVECTOR balance_pos[EDIT_MAP_BALANCE_MAX];       /**< Positions of the balance pieces, tilted for the weight on them. */
    sceVu0FVECTOR balance_base_pos[EDIT_MAP_BALANCE_MAX];  /**< Positions of the balance pieces before tilting. */

    /**
     *
     * Makes an empty edit map.
     *
     */
    CEditMap() {
        Initialize();
    }

    /**
     *
     * Draws every edit part placed, flashing the one in focus, then the map's own parts, and returns the number drawn.
     *
     * @mangled DrawSub__8CEditMapFi
     * @address 0x1B5560
     * @size 0x290
     */
    virtual int DrawSub(int direct);

    /**
     *
     * Works out which of the map's parts are on screen and steps the function points of every edit part placed.
     *
     * @mangled PreDraw__8CEditMapFPf
     * @address 0x1B54D0
     * @size 0x90
     */
    virtual int PreDraw(float *view_pos);

    /**
     *
     * Draws the effects of the function points of the map and of every edit part placed.
     *
     * @mangled DrawEffect__8CEditMapFv
     * @address 0x29FFE0
     * @size 0x170
     */
    virtual void DrawEffect();

    /**
     *
     * Draws the fire of the fire points of the map and of every edit part placed.
     *
     * @mangled DrawFireEffect__8CEditMapFi
     * @address 0x29FDF0
     * @size 0x140
     */
    virtual void DrawFireEffect(int tex_block);

    /**
     *
     * Draws the heat haze of the fire points of the map and of every edit part placed.
     *
     * @mangled DrawFireRaster__8CEditMapFv
     * @address 0x29FF30
     * @size 0xB0
     */
    virtual void DrawFireRaster();

    /**
     *
     * Gathers the polygons of one kind from the map, the edit parts placed and the river grids touching a box.
     *
     * @mangled GetPoly__8CEditMapFiP6CCPolyR9mgVu0FBOXi
     * @address 0x1B1BB0
     * @size 0x1E0
     */
    virtual int GetPoly(int kind, CCPoly *polys, mgVu0FBOX &box, int max);

    /**
     *
     * Returns the nearest event point of the map or of an edit part placed that a position is inside, filling in its information.
     *
     * @mangled GetEvent__8CEditMapFPfiP12MapEventInfo
     * @address 0x2A9E50
     * @size 0x1A0
     */
    virtual CFuncPoint *GetEvent(float *pos, int check_type, MapEventInfo *info);

    /**
     *
     * Returns the nearest function point on screen that the camera looks at, among the map and the edit parts placed.
     *
     * @mangled InScreenFunc__8CEditMapFP16InScreenFuncInfo
     * @address 0x2F4530
     * @size 0x100
     */
    virtual CFuncPoint *InScreenFunc(InScreenFuncInfo *info);

    /**
     *
     * Draws the screen markers of the function points of the map and of every edit part placed.
     *
     * @mangled DrawScreenFunc__8CEditMapFP8mgCFrame
     * @address 0x2F4630
     * @size 0xA0
     */
    virtual void DrawScreenFunc(mgCFrame *marker);

    /**
     *
     * Gathers the sound effects that the map, the edit parts placed and the river play, with their volume and pan.
     *
     * @mangled GetSeSrcVolPan__8CEditMapFPiPfPfi
     * @address 0x2F46D0
     * @size 0x2E0
     */
    virtual int GetSeSrcVolPan(int *se_no, float *vol, float *pan, int max);

    /**
     *
     * Steps the animations of the map and of the function points of every edit part placed.
     *
     * @mangled AnimeStep__8CEditMapFP12CObjAnimeEnv
     * @address 0x2A0150
     * @size 0x160
     */
    virtual void AnimeStep(CObjAnimeEnv *env);

    /**
     *
     * Counts a step for the flashing part and steps every part of the map.
     *
     * @mangled Step__8CEditMapFv
     * @address 0x1B54C0
     * @size 0x10
     */
    virtual void Step();

    /**
     *
     * Returns the name of the edit map's class.
     *
     * @mangled Iam__8CEditMapFv
     * @address 0x1B16D0
     * @size 0x10
     */
    virtual char *Iam();

    /**
     *
     * Empties the edit map of edit parts, houses, log, grids and river models, and empties the map.
     *
     * @mangled Initialize__8CEditMapFv
     * @address 0x1B16E0
     * @size 0xE0
     */
    virtual void Initialize();

    /**
     *
     * Empties the river grids.
     *
     * @mangled ClearGrid__8CEditMapFv
     * @address 0x1B17C0
     * @size 0x70
     */
    void ClearGrid();

    /**
     *
     * Frees every house.
     *
     * @mangled ClearHouse__8CEditMapFv
     * @address 0x1B1830
     * @size 0x60
     */
    void ClearHouse();

    /**
     *
     * Removes every edit part, then places again the parts that stand from the start.
     *
     * @mangled ClearAllParts__8CEditMapFv
     * @address 0x1B1890
     * @size 0x200
     */
    void ClearAllParts();

    /**
     *
     * Places the parts of the edit information's starting list, for a town that has no save data yet.
     *
     * @mangled InitialPlaceParts__8CEditMapFP9CEditData
     * @address 0x1B1A90
     * @size 0x120
     */
    void InitialPlaceParts(CEditData *data);

    /**
     *
     * Makes the heap for the edit parts' models, the edit part slots and the placement log.
     *
     * @mangled CreateTable__8CEditMapFP9mgCMemoryii
     * @address 0x1B1D90
     * @size 0x120
     */
    void CreateTable(mgCMemory *stack, int parts_max, int heap_size);

    /**
     *
     * Returns a part definition by number, or NULL for a number out of range.
     *
     * @mangled GetePartsInfo__8CEditMapFi
     * @address 0x1B1F60
     * @size 0x10
     */
    CEditPartsInfo *GetePartsInfo(int no);

    /**
     *
     * Returns the part definition of a name, or NULL.
     *
     * @mangled GetePartsInfo__8CEditMapFPc
     * @address 0x1B1F70
     * @size 0x10
     */
    CEditPartsInfo *GetePartsInfo(char *name);

    /**
     *
     * Returns the part definition of an ID, or NULL.
     *
     * @mangled GetePartsInfoAtID__8CEditMapFi
     * @address 0x1B1F80
     * @size 0x10
     */
    CEditPartsInfo *GetePartsInfoAtID(int id);

    /**
     *
     * Returns the first part definition of a kind, or NULL.
     *
     * @mangled GetePartsInfoAtType__8CEditMapFi
     * @address 0x1B1F90
     * @size 0x10
     */
    CEditPartsInfo *GetePartsInfoAtType(int type);

    /**
     *
     * Returns the definition of the edit part in a slot, or NULL.
     *
     * @mangled GetePartsInfoAtPlaceID__8CEditMapFi
     * @address 0x1B1FA0
     * @size 0x30
     */
    CEditPartsInfo *GetePartsInfoAtPlaceID(int no);

    /**
     *
     * Returns the number of the first free edit part slot, or EDIT_BUILD_NO_SLOT.
     *
     * @mangled eNewPlaceParts__8CEditMapFv
     * @address 0x1B1FD0
     * @size 0x60
     */
    int eNewPlaceParts();

    /**
     *
     * Returns the first free house, or NULL.
     *
     * @mangled eNewHouseInfo__8CEditMapFv
     * @address 0x1B2030
     * @size 0x40
     */
    CEditHouse *eNewHouseInfo();

    /**
     *
     * Returns the edit part in a slot, or NULL for a number out of range.
     *
     * @mangled GetePlaceParts__8CEditMapFi
     * @address 0x1B2070
     * @size 0x60
     */
    CEditParts *GetePlaceParts(int no);

    /**
     *
     * Returns the placed edit part whose definition has a name, or NULL.
     *
     * @mangled GetePlaceParts__8CEditMapFPc
     * @address 0x1B20D0
     * @size 0xC0
     */
    CEditParts *GetePlaceParts(char *name);

    /**
     *
     * Gives the slot numbers of the edit parts in use, up to a maximum.
     *
     * @mangled GetePlaceIDList__8CEditMapFPii
     * @address 0x1B2190
     * @size 0x70
     */
    int GetePlaceIDList(int *out_no, int max);

    /**
     *
     * Makes the rotation matrix about the vertical axis for a placement angle.
     *
     * @mangled GetRotMatrix__8CEditMapFPA4_fi
     * @address 0x1B2200
     * @size 0xE0
     */
    void GetRotMatrix(float (*out_matrix)[4], int angle);

    /**
     *
     * Returns a placement angle turned down to a whole quarter turn.
     *
     * @mangled GetEditAngle90__8CEditMapFi
     * @address 0x1B22E0
     * @size 0x50
     */
    int GetEditAngle90(int angle);

    /**
     *
     * Returns a placement angle in radians.
     *
     * @mangled GetEditAngle__8CEditMapFi
     * @address 0x1B2330
     * @size 0x50
     */
    float GetEditAngle(int angle);

    /**
     *
     * Returns the nearest placement angle to an angle in radians.
     *
     * @mangled ConvEditAngle__8CEditMapFf
     * @address 0x1B2380
     * @size 0xA0
     */
    int ConvEditAngle(float rot);

    /**
     *
     * Returns a placement angle brought into a single turn.
     *
     * @mangled AngleLimit__8CEditMapFi
     * @address 0x1B2420
     * @size 0x30
     */
    int AngleLimit(int angle);

    /**
     *
     * Gives a position with each coordinate snapped to a whole unit.
     *
     * @mangled GetEditPos__8CEditMapFPfPf
     * @address 0x1B2450
     * @size 0x1B0
     */
    void GetEditPos(float *out_pos, float *pos);

    /**
     *
     * Returns -1 when one height is above another by more than half a unit, 1 when below by more, otherwise 0.
     *
     * @mangled CmpEditAlt__8CEditMapFff
     * @address 0x1B2600
     * @size 0x50
     */
    int CmpEditAlt(float alt, float base_alt);

    /**
     *
     * Returns a height rounded to a whole unit.
     *
     * @mangled GetEditAlt__8CEditMapFf
     * @address 0x1B2650
     * @size 0x60
     */
    float GetEditAlt(float alt);

    /**
     *
     * Gives the centre and the size of the river grid cell under a position, and returns whether there is one.
     *
     * @mangled GetGridPos__8CEditMapFPfPfPf
     * @address 0x1B26B0
     * @size 0xE0
     */
    int GetGridPos(float *pos, float *out_pos, float *out_size);

    /**
     *
     * Makes the matrix that places a part at a position and placement angle.
     *
     * @mangled GetMatrix__8CEditMapFPA4_fPfi
     * @address 0x1B2790
     * @size 0x50
     */
    void GetMatrix(float (*out_matrix)[4], float *pos, int angle);

    /**
     *
     * Gives the inverse of a matrix.
     *
     * @mangled GetInversMatrix__8CEditMapFPA4_fPA4_f
     * @address 0x1B27E0
     * @size 0x10
     */
    void GetInversMatrix(float (*out_matrix)[4], float (*matrix)[4]);

    /**
     *
     * Returns the slot number of an edit part.
     *
     * @mangled ConvertParts__8CEditMapFP10CEditParts
     * @address 0x1B27F0
     * @size 0x30
     */
    int ConvertParts(CEditParts *parts);

    /**
     *
     * Returns the slot number of an unplaced edit part built from the same definition as the part in a slot, or -1.
     *
     * @mangled GetSameParts__8CEditMapFi
     * @address 0x1B2820
     * @size 0xB0
     */
    int GetSameParts(int no);

    /**
     *
     * Builds an edit part from the definition of an ID, and returns its slot number or an EditBuildResult.
     *
     * @mangled BuildEditParts__8CEditMapFi
     * @address 0x1B28D0
     * @size 0x50
     */
    int BuildEditParts(int id);

    /**
     *
     * Returns the first polygon count (polyn[0]) of every edit part placed and of the river, and gives the other two.
     *
     * @mangled GetTotalPolyn__8CEditMapFPiPi
     * @address 0x1B2920
     * @size 0x140
     */
    int GetTotalPolyn(int *out_polyn1, int *out_polyn2);

    /**
     *
     * Builds an edit part from the definition of a name, and returns its slot number or an EditBuildResult.
     *
     * @mangled BuildEditParts__8CEditMapFPc
     * @address 0x1B2A60
     * @size 0x1F0
     */
    int BuildEditParts(char *name);

    /**
     *
     * Frees an edit part's slot, its house and its model, and returns whether there was one.
     *
     * @mangled DeleteEditParts__8CEditMapFi
     * @address 0x1B2C50
     * @size 0x80
     */
    int DeleteEditParts(int no);

    /**
     *
     * Removes an edit part, or the river at a position, with every part resting on it, tallying what was removed.
     *
     * @mangled RemoveEditParts__8CEditMapFiPfPQ28CEditMap10RemoveInfo
     * @address 0x1B2CD0
     * @size 0x3B0
     */
    int RemoveEditParts(int no, float *pos, RemoveInfo *info);

    /**
     *
     * Returns whether any placed edit part can burn.
     *
     * @mangled PlaceBurnParts__8CEditMapFv
     * @address 0x1B3080
     * @size 0x90
     */
    int PlaceBurnParts();

    /**
     *
     * Removes the parts that burn, putting burnt remains where they stood, and returns whether the remains' definitions exist.
     *
     * @mangled BurnEditParts__8CEditMapFPQ28CEditMap10RemoveInfo
     * @address 0x1B3110
     * @size 0x270
     */
    int BurnEditParts(RemoveInfo *info);

    /**
     *
     * Builds and places an edit part of a name at a position and rotation, without any checks.
     *
     * @mangled PlaceEditParts__8CEditMapFPcPfPf
     * @address 0x1B3380
     * @size 0xB0
     */
    CEditParts *PlaceEditParts(char *name, float *pos, float *rot);

    /**
     *
     * Places a built edit part at a position and rotation after its checks, logging what it rests on.
     *
     * @mangled PlaceEditParts__8CEditMapFiP13EP_PLACE_INFOPfPfPi
     * @address 0x1B3430
     * @size 0x1D0
     */
    CEditParts *PlaceEditParts(int no, EP_PLACE_INFO *place, float *pos, float *rot, int *out_same);

    /**
     *
     * Lays river on the grid at a position if it may go there, and returns whether it was laid.
     *
     * @mangled PlaceRiverParts__8CEditMapFPf
     * @address 0x1B3600
     * @size 0x50
     */
    int PlaceRiverParts(float *pos);

    /**
     *
     * Logs the placed parts that an edit part rests on, and returns whether the log had room.
     *
     * @mangled CreatePlaceLog__8CEditMapFiP13EP_PLACE_INFO
     * @address 0x1B3650
     * @size 0x100
     */
    int CreatePlaceLog(int no, EP_PLACE_INFO *place);

    /**
     *
     * Gathers the placed edit parts near a part of a definition at a position and angle, and returns the number gathered.
     *
     * @mangled GetNearParts__8CEditMapFP14CEditPartsInfoPffPP10CEditPartsi
     * @address 0x1B3750
     * @size 0x1B0
     */
    int GetNearParts(CEditPartsInfo *info, float *pos, float rot_y, CEditParts **out_parts, int max);

    /**
     *
     * Gathers the placed edit parts whose bounds touch a box, and returns the number gathered.
     *
     * @mangled GetNearParts__8CEditMapFR9mgVu0FBOXPP10CEditPartsi
     * @address 0x1B3900
     * @size 0x1A0
     */
    int GetNearParts(mgVu0FBOX &box, CEditParts **out_parts, int max);

    /**
     *
     * Returns the slot number of the highest placed edit part under a point, or -1.
     *
     * @mangled GetePlaceParts__8CEditMapFPf
     * @address 0x1B3AA0
     * @size 0xD0
     */
    int GetePlaceParts(float *pos);

    /**
     *
     * Returns the slot number of the highest of some placed edit parts under a point, setting the point's height to its top, or -1.
     *
     * @mangled GetePlaceParts__8CEditMapFPfPP10CEditPartsi
     * @address 0x1B3B70
     * @size 0x310
     */
    int GetePlaceParts(float *pos, CEditParts **parts, int num);

    /**
     *
     * Returns whether a part of a definition may be placed at a position and angle, giving the parts it would rest on.
     *
     * @mangled CheckEditParts__8CEditMapFP14CEditPartsInfoPffP13EP_PLACE_INFO
     * @address 0x1B3E80
     * @size 0x90
     */
    int CheckEditParts(CEditPartsInfo *info, float *pos, float rot_y, EP_PLACE_INFO *place);

    /**
     *
     * Returns the height a part of a definition would stand at, at a position and angle.
     *
     * @mangled GetEditPartsAlt__8CEditMapFP14CEditPartsInfoPff
     * @address 0x1B3F10
     * @size 0x70
     */
    float GetEditPartsAlt(CEditPartsInfo *info, float *pos, float rot_y);

    /**
     *
     * Moves a part of a definition so that it snaps against some placed edit parts nearby, and returns whether it moved.
     *
     * @mangled MagnetParts__8CEditMapFP14CEditPartsInfoPfPfPP10CEditPartsi
     * @address 0x1B3F80
     * @size 0xF40
     */
    int MagnetParts(CEditPartsInfo *info, float *pos, float *rot, CEditParts **parts, int num);

    /**
     *
     * Moves a part of a definition so that it snaps against the placed edit parts nearby, and returns whether it moved.
     *
     * @mangled MagnetParts__8CEditMapFP14CEditPartsInfoPfPf
     * @address 0x1B4EC0
     * @size 0x70
     */
    int MagnetParts(CEditPartsInfo *info, float *pos, float *rot);

    /**
     *
     * Returns whether a part of a definition may be hung on one wall of a placed edit part, giving its position and the part it rests on.
     *
     * @mangled CheckWallEditParts__8CEditMapFP14CEditPartsInfoPfiiP13EP_PLACE_INFO
     * @address 0x1B4F30
     * @size 0x590
     */
    int CheckWallEditParts(CEditPartsInfo *info, float *pos, int wall_no, int base_no, EP_PLACE_INFO *place);

    /**
     *
     * Runs the edit map script, then makes the river definitions and grids of the ground parts.
     *
     * @mangled LoadEditInfo__8CEditMapFPciP9mgCMemory
     * @address 0x1B5EF0
     * @size 0x8A0
     */
    void LoadEditInfo(char *script, int size, mgCMemory *stack);

    /**
     *
     * Lays river on the grid cell at a position, and returns whether there was a grid there.
     *
     * @mangled PlaceRiver__8CEditMapFPf
     * @address 0x29A5D0
     * @size 0x90
     */
    int PlaceRiver(float *pos);

    /**
     *
     * Takes the river off the grid cell at a position, and returns whether there was a grid there.
     *
     * @mangled RemoveRiver__8CEditMapFPf
     * @address 0x29A660
     * @size 0x90
     */
    int RemoveRiver(float *pos);

    /**
     *
     * Makes a river grid covering a ground part's bounds.
     *
     * @mangled CreateGrid__8CEditMapFPfPfP9mgCMemoryPf
     * @address 0x29A6F0
     * @size 0x2B0
     */
    void CreateGrid(float *max, float *min, mgCMemory *stack, float *ofs);

    /**
     *
     * Returns the number of river cells within a distance of a point.
     *
     * @mangled GetRiverNum__8CEditMapFPf
     * @address 0x29A9A0
     * @size 0x160
     */
    int GetRiverNum(float *sphere);

    /**
     *
     * Returns whether the grid cell at a position holds river.
     *
     * @mangled IsRiverGrid__8CEditMapFPf
     * @address 0x29AB00
     * @size 0xC0
     */
    int IsRiverGrid(float *pos);

    /**
     *
     * Returns the number of river cells within a distance of a placed edit part.
     *
     * @mangled GetRiverNum__8CEditMapFif
     * @address 0x29ABC0
     * @size 0x90
     */
    int GetRiverNum(int no, float range);

    /**
     *
     * Draws the mask under the river cells of the grids.
     *
     * @mangled DrawRiverMask__8CEditMapFv
     * @address 0x29AC50
     * @size 0x520
     */
    void DrawRiverMask();

    /**
     *
     * Draws the river and its water surface on the river cells of the grids.
     *
     * @mangled DrawRiver__8CEditMapFv
     * @address 0x29B170
     * @size 0x420
     */
    void DrawRiver();

    /**
     *
     * Writes the edit parts placed, their colours and the river into the save data.
     *
     * @mangled SaveData__8CEditMapFP9CEditData
     * @address 0x2AD030
     * @size 0x5D0
     */
    void SaveData(CEditData *data);

    /**
     *
     * Builds and places the edit parts, their colours and the river from the save data.
     *
     * @mangled LoadData__8CEditMapFP9CEditData
     * @address 0x2AD600
     * @size 0x6E0
     */
    void LoadData(CEditData *data);

    /**
     *
     * Returns the culture points that a placed edit part earns from the parts around it and on it.
     *
     * @mangled CultureAnalyzeParts__8CEditMapFii
     * @address 0x2ADD10
     * @size 0x200
     */
    int CultureAnalyzeParts(int no, int cpoint_no);

    /**
     *
     * Returns the culture points that every placed edit part earns.
     *
     * @mangled CultureAnalyze__8CEditMapFi
     * @address 0x2ADF10
     * @size 0x90
     */
    int CultureAnalyze(int cpoint_no);

    /**
     *
     * Gathers the map parts or pieces that a switch name names, and returns the number gathered.
     *
     * @mangled GetOnOffParts__8CEditMapFPcPP9CMapPartsPP9CMapPiecei
     * @address 0x2ADFA0
     * @size 0x1B0
     */
    int GetOnOffParts(char *name, CMapParts **out_parts, CMapPiece **out_piece, int max);

    /**
     *
     * Shows or hides the map parts that the town's analysis results switch.
     *
     * @mangled PartsOnOff__8CEditMapFiP9CEditData
     * @address 0x2AE150
     * @size 0x1E0
     */
    void PartsOnOff(int map_no, CEditData *data);

    /**
     *
     * Returns the height a part of a definition would stand at on some placed edit parts, at a position and angle.
     *
     * @mangled GetEditPartsAlt__8CEditMapFP14CEditPartsInfoPffPP10CEditPartsi
     * @address 0x2F2720
     * @size 0x270
     */
    float GetEditPartsAlt(CEditPartsInfo *info, float *pos, float rot_y, CEditParts **parts, int num);

    /**
     *
     * Returns whether a part of a definition may be placed at a position and angle among some placed edit parts, giving the parts it would rest on.
     *
     * @mangled CheckEditParts__8CEditMapFP14CEditPartsInfoPffP13EP_PLACE_INFOPP10CEditPartsi
     * @address 0x2F2990
     * @size 0x5D0
     */
    int CheckEditParts(CEditPartsInfo *info, float *pos, float rot_y, EP_PLACE_INFO *place, CEditParts **parts, int num);

    /**
     *
     * Returns whether a part of a definition at a position and angle keeps clear of the river, or fits it where it must.
     *
     * @mangled CheckEditPartsOnRiver__8CEditMapFP14CEditPartsInfoPff
     * @address 0x2F2F60
     * @size 0x320
     */
    int CheckEditPartsOnRiver(CEditPartsInfo *info, float *pos, float rot_y);

    /**
     *
     * Returns whether river may be laid on the grid cell at a position.
     *
     * @mangled CheckRiverParts__8CEditMapFPf
     * @address 0x2F3280
     * @size 0x370
     */
    int CheckRiverParts(float *pos);

    /**
     *
     * Returns whether the edit part in a slot is placed in the town.
     *
     * @mangled CheckNormalPlaceParts__8CEditMapFi
     * @address 0x2F35F0
     * @size 0x30
     */
    int CheckNormalPlaceParts(int no);

    /**
     *
     * Returns whether an edit part is placed in the town.
     *
     * @mangled CheckNormalPlaceParts__8CEditMapFP10CEditParts
     * @address 0x2F3620
     * @size 0x40
     */
    int CheckNormalPlaceParts(CEditParts *parts);

    /**
     *
     * Returns whether a villager lives in a placed house, optionally one of a definition, or the number of houses lived in when neither is given.
     *
     * @mangled CheckLiveNPC__8CEditMapFii
     * @address 0x2F3660
     * @size 0x110
     */
    int CheckLiveNPC(int npc_no, int id);

    /**
     *
     * Gathers the placed edit parts of a definition ID, and returns the number placed.
     *
     * @mangled GetePlacePartsAtInfoID__8CEditMapFiPii
     * @address 0x2F3770
     * @size 0x1B0
     */
    int GetePlacePartsAtInfoID(int id, int *out_no, int max);

    /**
     *
     * Gathers the placed edit parts within the territory of a placed edit part, and returns the number gathered.
     *
     * @mangled GetTerritoryParts__8CEditMapFiPii
     * @address 0x2F3920
     * @size 0x110
     */
    int GetTerritoryParts(int no, int *out_no, int max);

    /**
     *
     * Gathers the placed edit parts that rest on a placed edit part, and returns the number gathered.
     *
     * @mangled GetChildParts__8CEditMapFiPii
     * @address 0x2F3A30
     * @size 0xC0
     */
    int GetChildParts(int no, int *out_no, int max);

    /**
     *
     * Returns the paint given back for a part that took an amount to paint.
     *
     * @mangled RePaintNum__8CEditMapFi
     * @address 0x2F3AF0
     * @size 0x20
     */
    int RePaintNum(int num);

    /**
     *
     * Paints a placed fence and the fences joined to it, up to an amount of paint, and returns the number painted.
     *
     * @mangled PaintFence__8CEditMapFiPfi
     * @address 0x2F3B10
     * @size 0x150
     */
    int PaintFence(int no, float *color, int num);

    /**
     *
     * Paints a fence and, through fence_list, the fences joined to it, and returns the number painted.
     *
     * @mangled PaintFence__8CEditMapFP10CEditParts
     * @address 0x2F3DE0
     * @size 0xE0
     */
    int PaintFence(CEditParts *parts);

    /**
     *
     * Brings the houses up to date with the buildings placed and the parts resting on them.
     *
     * @mangled UpdateHouse__8CEditMapFv
     * @address 0x2F3EC0
     * @size 0x1F0
     */
    void UpdateHouse();

    /**
     *
     * Weighs the parts on each balance ground piece and tilts the pieces to match.
     *
     * @mangled GroundBalance__8CEditMapFi
     * @address 0x2F40B0
     * @size 0x3D0
     */
    void GroundBalance(int keep);

    /**
     *
     * Returns whether the weights on opposite balance ground pieces are within three of each other.
     *
     * @mangled BalanceCheck__8CEditMapFv
     * @address 0x2F4480
     * @size 0xB0
     */
    int BalanceCheck();
};

STATIC_ASSERT(sizeof(CEditMap::RemoveInfo) == 0x494);
STATIC_ASSERT(sizeof(CEditMap) == 0x10F0);
