#pragma once

#include "common.h"

#include <libvu0.h>

#include "editcoll.hpp"
#include "mapparts.hpp"
#include "mg_drawenv.hpp"

/**
 * @file
 * Declares the parts the town editor (Georama) places: the definition of
 * each kind of part, each placed part, and the house that records which
 * villagers live in a placed building.
 */

class mgCMemory;

/**
 * Number of materials an edit part can need to be built.
 */
#define EDIT_PARTS_MATERIAL_MAX 4

/**
 * Number of villagers one house can hold.
 */
#define EDIT_HOUSE_NPC_MAX 3

/**
 * Attribute bits of an edit part's definition, set by the commands of the
 * edit information script.
 */
enum EditPartsAtr {
    EDIT_PARTS_ATR_GROUND = 0x7,    /**< Bits that GROUND_PARTS sets; a part with all three is ground that holds a placement grid. */
    EDIT_PARTS_ATR_BLOCK  = 0x30,   /**< Bits that BLOCK_PARTS sets. */
    EDIT_PARTS_ATR_TYPE_ONE = 0x40, /**< Bit that makes GetPartsType return type 1. */
    EDIT_PARTS_ATR_RIVER  = 0x80,   /**< Bit that RIVER_PARTS sets; the part is a piece of river laid on the grid. */
    EDIT_PARTS_ATR_FENCE  = 0x130,  /**< Bits that FENCE_PARTS sets; a part with all of them is a fence. */
    EDIT_PARTS_ATR_BURN   = 0x1000, /**< Bit marking a part that can burn. */
};

/**
 * Kind of edit part, as the definition's parts_type gives it or as its
 * attributes override it.
 */
enum EditPartsType {
    EDIT_PARTS_TYPE_RIVER = 11, /**< Piece of river. */
};

/**
 * How a placed edit part stands in the town.
 */
enum EditPartsState {
    EDIT_PARTS_STATE_NONE   = 0, /**< Not placed. */
    EDIT_PARTS_STATE_PLACED = 1, /**< Placed in the town and drawn. */
    EDIT_PARTS_STATE_RIVER  = 2, /**< Piece of river, kept out of sight while the river grid draws it. */
};

/**
 * One material an edit part needs to be built: an item and how many of
 * it are used.
 */
struct EditPartsMaterial {
    s32 item_no; /**< Item used as the material; 0 or below for none. */
    s32 num;     /**< Number of the item used. */
};

STATIC_ASSERT(sizeof(EditPartsMaterial) == 0x8);

/**
 * Defines one kind of part the town editor can place: its names, cost,
 * attributes, the map part that models it, and the collision and extent
 * the editor tests placements against.
 */
class CEditPartsInfo {
public:
    s32               id;                                  /**< Number that identifies the kind of part; -999 while unset. */
    u32               attr;                                /**< Attribute bits, EditPartsAtr. */
    s32               cpoint[2];                           /**< Two culture point values the part gives the town. */
    s32               weight;                              /**< Weight the part puts on the ground it stands on. */
    s32               max_num;                             /**< Number of the part that can be placed. */
    s32               geo_stone;                           /**< Geostone the part belongs to, or -1. */
    s32               paint_num;                           /**< Number of colours of the part that can be painted. */
    s32               paint_used;                          /**< Value of the PAINT_USED command. */
    s32               parts_type;                          /**< Kind of part, EditPartsType. */
    float             place_eps;                           /**< Share of the part's base that must rest on ground for it to be placed; 0.98 when not above zero. */
    s32               map_no;                              /**< Map the part belongs to, or -1. */
    s32               polyn[3];                            /**< Values of the POLYN command. */
    char             *edit_name;                           /**< Name of the part shown in the editor. */
    char             *parts_name;                          /**< Name of the map part that models the part. */
    CMapParts        *parts;                               /**< Map part that models the part, or NULL. */
    char             *comment;                             /**< Description of the part shown in the editor. */
    s32               unk_4c;
    mgVu0FBOX         box;                                 /**< Extent of the part's collision, in the part's own space. */
    EditPartsMaterial material[EDIT_PARTS_MATERIAL_MAX];   /**< Materials needed to build the part. */
    s32               place_anime;                         /**< Animation played when the part is placed; 0 for none. */
    s32               unk_94;
    s32               unk_98;
    s32               unk_9c;
    mgVu0FBOX         area3_box;                           /**< Extent of col_area3; for a part with attribute 0x100, flattened to the line between the part's two ends. */
    CEditCollision    col_area1;                           /**< Collision triangles of area kind 1. */
    CEditCollision    col_floor;                           /**< Floor triangles of area kind 2, that other parts can stand on. */
    CEditCollision    col_wall;                            /**< Wall triangles of area kind 2, numbered by wall. */
    CEditCollision    col_area3;                           /**< Collision triangles of area kind 3. */
    CEditCollision    col_area5;                           /**< Collision triangles of area kind 5. */
    float             bury_depth;                          /**< Depth the part reaches below the ground it stands on. */
    s32               wall_group_num;                      /**< Number of walls in col_wall. */
    s32               unk_258;
    s32               unk_25c;
    sceVu0FVECTOR     territory_center;                    /**< Centre of the space the part takes up, in the part's own space. */
    float             territory_radius;                    /**< Half the larger of the part's width and depth. */
    float             territory_height;                    /**< Half the part's height. */
    float             unk_278;
    s32               unk_27c;

    /**
     * Makes a definition that describes no part.
     *
     * @mangled __ct__14CEditPartsInfoFv
     * @address 0x1B6790
     * @size 0x1F0
     */
    CEditPartsInfo() { Initialize(); }

    /**
     * Clears the definition to one that describes no part.
     *
     * @mangled Initialize__14CEditPartsInfoFv
     * @address 0x1B6980
     * @size 0xE0
     */
    void Initialize();

    /**
     * Gets the kind of part, an EditPartsType, with the river and
     * attribute 0x40 overriding parts_type.
     *
     * @mangled GetPartsType__14CEditPartsInfoFv
     * @address 0x1B6A60
     * @size 0x40
     */
    int GetPartsType();

    /**
     * Sets up the part's extent with a W of one on both corners.
     *
     * @mangled CreateBox__14CEditPartsInfoFv
     * @address 0x1B6AA0
     * @size 0x30
     */
    void CreateBox();

    /**
     * Gets the height of the part's extent.
     *
     * @mangled GetPartsHeight__14CEditPartsInfoFv
     * @address 0x1B6AD0
     * @size 0x10
     */
    float GetPartsHeight();

    /**
     * Gets the largest of the width, height and depth of the part's
     * extent.
     *
     * @mangled GetPartsMaxWidth__14CEditPartsInfoFv
     * @address 0x1B6AE0
     * @size 0x80
     */
    float GetPartsMaxWidth();

    /**
     * Gets one of the materials needed to build the part, or NULL for a
     * number out of range.
     *
     * @mangled GetMaterial__14CEditPartsInfoFi
     * @address 0x1B6B60
     * @size 0x30
     */
    EditPartsMaterial *GetMaterial(int no);

    /**
     * Gets the colour the model gives one colour number before it is
     * painted; gives back 0 without a model.
     *
     * @mangled GetDefColor__14CEditPartsInfoFiPf
     * @address 0x1B6B90
     * @size 0x30
     */
    int GetDefColor(int no, float *out_rgba);
};

STATIC_ASSERT(sizeof(CEditPartsInfo) == 0x280);

/**
 * House a placed building gives, recording the villagers who live in it.
 */
class CEditHouse {
public:
    s32 active;                     /**< Non-zero while a placed building uses the house. */
    s32 npc_no[EDIT_HOUSE_NPC_MAX]; /**< Villagers who live in the house; 0 or below for none. */

    /**
     * Gives back non-zero while any villager lives in the house.
     *
     * @mangled LiveChara__10CEditHouseFv
     * @address 0x1B6BC0
     * @size 0x40
     */
    int LiveChara();
};

STATIC_ASSERT(sizeof(CEditHouse) == 0x10);

/**
 * Part placed in the town by the editor: a map part made from an edit
 * part's definition, standing on a ground part of the map, which may have
 * a house of villagers.
 */
class CEditParts : public CMapParts {
public:
    /**
     * Plane, centre and extent of one wall of a part, which other parts
     * can be put against.
     */
    struct WallInfo {
        sceVu0FVECTOR plane;  /**< Plane of the wall: normal in XYZ, distance from the origin in W. */
        sceVu0FVECTOR center; /**< Centre of the wall's triangles. */
        mgVu0FBOX     box;    /**< Extent of the wall from its centre: distance across in X, height in Y. */
    };

    s32             state;            /**< How the part stands in the town, EditPartsState. */
    CMapParts      *ground;           /**< Ground part of the map the part stands on, or NULL. */
    s32             max_material_num; /**< Largest number of materials any piece of the part recolours. */
    s32             unk_31c;
    s32             unk_320;
    CEditPartsInfo *info;             /**< Definition of the part, or NULL. */
    CEditHouse     *house;            /**< House of villagers the part has, or NULL. */
    s32             unk_32c;

    /**
     * Makes a part that is not placed.
     *
     * @mangled __ct__10CEditPartsFv
     * @address 0x1B1EB0
     * @size 0xB0
     */
    CEditParts() { Initialize(); }

    /**
     * Sets the position of the part, given in world space, as a height
     * above the ground it stands on.
     *
     * @mangled SetPosition__10CEditPartsFPf
     * @address 0x1B6C90
     * @size 0x80
     */
    virtual void SetPosition(float *position);

    /**
     * Sets the position of the part, given in world space, as a height
     * above the ground it stands on.
     *
     * @mangled SetPosition__10CEditPartsFfff
     * @address 0x1B6D10
     * @size 0x50
     */
    virtual void SetPosition(float x, float y, float z);

    /**
     * Gets the position of the part in world space, adding the height of
     * the ground it stands on.
     *
     * @mangled GetPosition__10CEditPartsFPf
     * @address 0x1B6D60
     * @size 0x60
     */
    virtual void GetPosition(float *out_position);

    /**
     * Clears the part to one that is not placed and has no definition.
     *
     * @mangled Initialize__10CEditPartsFv
     * @address 0x1B6C00
     * @size 0x20
     */
    virtual void Initialize();

    /**
     * Copies a changed position, rotation and scale into the frame, lifted
     * by the height of the ground the part stands on.
     *
     * @mangled UpDatePosition__10CEditPartsFv
     * @address 0x1B6DD0
     * @size 0xB0
     */
    virtual void UpDatePosition();

    /**
     * Copies the part into another map part.
     *
     * @mangled Copy__10CEditPartsFR9CMapPartsP9mgCMemory
     * @address 0x1B7240
     * @size 0x10
     */
    virtual void Copy(CMapParts &dest, mgCMemory *memory);

    /**
     * Gets the position of the part relative to the ground it stands on.
     *
     * @mangled GetLocalPos__10CEditPartsFPf
     * @address 0x1B6DC0
     * @size 0x10
     */
    void GetLocalPos(float *out_position);

    /**
     * Gets the number that identifies the part's definition, or -1
     * without one.
     *
     * @mangled GetInfoID__10CEditPartsFv
     * @address 0x1B6E80
     * @size 0x20
     */
    int GetInfoID();

    /**
     * Gets the first villager living in the part's house, or -1 without a
     * house.
     *
     * @mangled GetLiveNPC__10CEditPartsFv
     * @address 0x1B6EA0
     * @size 0x20
     */
    int GetLiveNPC();

    /**
     * Gives back non-zero when the part has walls that other parts can be
     * put against.
     *
     * @mangled IsWallParts__10CEditPartsFv
     * @address 0x1B6EC0
     * @size 0x30
     */
    int IsWallParts();

    /**
     * Gives back non-zero when the part is a fence.
     *
     * @mangled IsFence__10CEditPartsFv
     * @address 0x1B6EF0
     * @size 0x30
     */
    int IsFence();

    /**
     * Gives back non-zero when the part can burn.
     *
     * @mangled IsBurn__10CEditPartsFv
     * @address 0x1B6F20
     * @size 0x30
     */
    int IsBurn();

    /**
     * Gets the world positions of the two ends of a fence; gives back 0
     * when the part has no ends to give.
     *
     * @mangled GetFenceSide__10CEditPartsFPfPf
     * @address 0x1B6F50
     * @size 0xB0
     */
    int GetFenceSide(float *out_side0, float *out_side1);

    /**
     * Gets the plane, centre and extent of one wall of the part; gives
     * back 0 when the part has no such wall.
     *
     * @mangled GetWallPlane__10CEditPartsFiPQ210CEditParts8WallInfo
     * @address 0x1B7000
     * @size 0x1F0
     */
    int GetWallPlane(int wall_no, WallInfo *out_info);

    /**
     * Gets the number of walls the part has, or 0 without a definition.
     *
     * @mangled GetWallGroupNum__10CEditPartsFv
     * @address 0x1B71F0
     * @size 0x20
     */
    int GetWallGroupNum();

    /**
     * Gets the kind of part, an EditPartsType, or -1 without a
     * definition.
     *
     * @mangled GetPartsType__10CEditPartsFv
     * @address 0x1B7210
     * @size 0x30
     */
    int GetPartsType();

    /**
     * Gives back non-zero when the space this part takes up meets the
     * space another part takes up.
     *
     * @mangled CheckTerritory__10CEditPartsFP10CEditParts
     * @address 0x1B7250
     * @size 0x130
     */
    int CheckTerritory(CEditParts *other);

    /**
     * Finds the largest number of materials any piece of the part
     * recolours.
     *
     * @mangled CheckColorUpdate__10CEditPartsFv
     * @address 0x1B7380
     * @size 0x40
     */
    void CheckColorUpdate();
};

STATIC_ASSERT(sizeof(CEditParts::WallInfo) == 0x40);
STATIC_ASSERT(sizeof(CEditParts) == 0x330);

/**
 * Gives back non-zero when two colours are near enough to count as the
 * same.
 *
 * @mangled EditPartsCmpColor__FPfPf
 * @address 0x1B73C0
 * @size 0x40
 */
int EditPartsCmpColor(float *color0, float *color1);
