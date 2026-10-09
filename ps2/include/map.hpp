#pragma once

#include "common.h"

#include <libvu0.h>

#include "effectlist.hpp"
#include "funcpoint.hpp"
#include "mapinfo.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_tanime.hpp"
#include "occlusion.hpp"

/**
 * @file
 * Declares a loaded map: its placed parts, parts groups, draw-off areas,
 * occlusion planes, function points, treasure boxes and water surfaces, the
 * base drawable object that parts and water are built on, and the flag block
 * that records which treasure boxes of a map have been opened.
 */

class mgCCamera;
class mgCFrame;
class mgCMemory;
class mgCTexture;
class CCameraInfo;
class CCPoly;
class CFireRaster;
class CFuncPoint;
class CFuncPointCheck;
class CMapLightingInfo;
class CMapParts;
class CMapTreasureBox;
class CMdsInfo;
class CMdsListSet;
class CObjAnime;
class CObjAnimeEnv;
class CWaterFrame;
struct InScreenFuncInfo;

/**
 *
 * Capacities of the fixed tables a map and its flag block hold.
 *
 */
enum {
    MAP_FLAG_MAX = 128,       /**< Flags held by one CMapFlagData. */
    MAP_PARTS_GROUP_MAX = 32, /**< Parts groups a map holds. */
    MAP_DRAW_RECT_MAX = 16,   /**< Draw-off areas a map holds. */
    MAP_OCCLUSION_MAX = 8,    /**< Occlusion planes a map holds. */
};

/**
 *
 * Results of CMap::GetFixCameraPos.
 *
 */
enum MapFixCamera {
    MAP_FIX_CAMERA_NONE = 0,  /**< No fixed camera covers the position. */
    MAP_FIX_CAMERA_POINT = 1, /**< The camera sits at the fixed camera's single point. */
    MAP_FIX_CAMERA_PATH = 2,  /**< The camera sits at the nearest place along the fixed camera's path. */
};

/**
 *
 * Bit flags of one map recording which treasure boxes have been opened, kept in the save data.
 *
 */
class CMapFlagData {
public:
    u32 flag[MAP_FLAG_MAX / 32]; /**< One bit per flag number, 32 to a word. */

    /**
     *
     * Sets or clears one flag and returns whether it was set before.
     *
     * @mangled SetFlag__12CMapFlagDataFii
     * @address 0x15D830
     * @size 0x80
     */
    int SetFlag(int no, int on);

    /**
     *
     * Returns whether one flag is set, or false for a number out of range.
     *
     * @mangled GetFlag__12CMapFlagDataFi
     * @address 0x15D8B0
     * @size 0x70
     */
    int GetFlag(int index);
};

STATIC_ASSERT(sizeof(CMapFlagData) == 0x10);

/**
 *
 * Entry of a parts group's list, naming one placed parts.
 *
 */
struct PartsGroupData {
    CMapParts *parts; /**< Placed parts that belongs to the group. */

    /**
     *
     * Makes an entry that names no placed parts.
     *
     */
    PartsGroupData() { parts = 0; }
};

STATIC_ASSERT(sizeof(PartsGroupData) == 0x4);
STATIC_ASSERT(sizeof(CList<PartsGroupData>) == 0x10);
STATIC_ASSERT(sizeof(CList<CMapParts *>) == 0x10);

/**
 *
 * Named set of placed parts that are hidden together, by an event or by a fixed camera.
 *
 */
class CPartsGroup {
public:
    char                  *name;       /**< Name the group is looked up by, or NULL when the slot is free. */
    s32                    off;        /**< Hides the group's parts while nonzero. */
    s32                    camera_off; /**< Hides the group's parts for the frame a fixed camera asks it to. */
    CList<PartsGroupData> *list;       /**< First entry of the group's parts. */

    CPartsGroup() { Initialize(); }

    /**
     *
     * Empties the group and frees its slot.
     *
     * @mangled Initialize__11CPartsGroupFv
     * @address 0x15D930
     * @size 0x20
     */
    void Initialize();

    /**
     *
     * Appends an entry to the end of the group's list.
     *
     * @mangled Add__11CPartsGroupFP23CList_14PartsGroupData_
     * @address 0x15D950
     * @size 0x50
     */
    void Add(CList<PartsGroupData> *node);
};

STATIC_ASSERT(sizeof(CPartsGroup) == 0x10);

/**
 *
 * Box of the map that hides a set of placed parts while the viewpoint is inside it, or while it is outside.
 *
 */
struct MapDrawOffRect {
    mgVu0FBOX           area;    /**< Box that the viewpoint is tested against. */
    s32                 used;    /**< Nonzero once the slot holds an area. */
    s32                 outside; /**< Hides the parts while the viewpoint is outside the area instead of inside. */
    CList<CMapParts *> *parts;   /**< Placed parts that the area hides. */

    MapDrawOffRect() {
        outside = 0;
        used = 0;
        parts = NULL;
    }
};

STATIC_ASSERT(sizeof(MapDrawOffRect) == 0x30);

/**
 *
 * Event function point found at a position, with the matrix that places it.
 *
 */
struct MapEventInfo {
    s32           check_type; /**< Kind of check the event was searched for. */
    s32           event_no;   /**< Event number of the point, or of the last event point passed through. */
    sceVu0FMATRIX matrix;     /**< World matrix of the event point. */
    s32           parts_no;   /**< Placed parts the point belongs to, or -1 for a point of the map itself. */
    s32           point_no;   /**< Number assigned to the point, such as its treasure box index. */
};

STATIC_ASSERT(sizeof(MapEventInfo) == 0x60);

/**
 *
 * Base of the map's drawable objects: an engine object that can be shown, hidden and faded between a near and a far distance.
 *
 */
class CObject : public mgCObject {
public:
    float far_dist;   /**< Distance from the camera beyond which the object is not drawn, or not above zero for none. */
    s32   fade;       /**< Fades the object in and out at the near and far distances instead of cutting it off. */
    float fade_alpha; /**< Current alpha of a fading object, or below zero before its first step. */
    float fade_speed; /**< Alpha the fade gains or loses each step. */
    float near_dist;  /**< Distance from the camera within which the object is not drawn, or not above zero for none. */
    s32   show;       /**< Draws the object while nonzero. */
    s32   draw_off;   /**< Keeps the object from drawing while nonzero, whatever show holds. */

    /**
     *
     * Makes an object at the world origin, shown, with no draw distances.
     *
     * @mangled __ct__7CObjectFv
     * @address 0x1631B0
     * @size 0x50
     */
    CObject() { Initialize(); }

    /**
     *
     * Draws the object. The base object draws nothing.
     *
     * @mangled Draw__7CObjectFv
     * @address 0x161F60
     * @size 0x10
     */
    virtual int Draw() { return 0; }

    /**
     *
     * Draws the object straight into the packet. The base object draws nothing.
     *
     * @mangled DrawDirect__7CObjectFv
     * @address 0x161F70
     * @size 0x10
     */
    virtual int DrawDirect() { return 0; }

    /**
     *
     * Puts the object at the world origin, shows it, and clears its draw distances and fade.
     *
     * @mangled Initialize__7CObjectFv
     * @address 0x16B1F0
     * @size 0xA0
     */
    virtual void Initialize();

    /**
     *
     * Returns whether the object is shown and not kept from drawing.
     *
     * @mangled PreDraw__7CObjectFv
     * @address 0x16B1C0
     * @size 0x30
     */
    virtual int PreDraw();

    /**
     *
     * Returns the distance from the camera to the object.
     *
     * @mangled GetCameraDist__7CObjectFv
     * @address 0x16B020
     * @size 0x10
     */
    virtual float GetCameraDist();

    /**
     *
     * Returns whether the object is drawn at a distance from the camera, stepping its fade and giving its alpha.
     *
     * @mangled FarClip__7CObjectFfPf
     * @address 0x16AED0
     * @size 0x150
     */
    virtual int FarClip(float dist, float *out_alpha);

    /**
     *
     * Steps the object's fade for its current distance from the camera.
     *
     * @mangled DrawStep__7CObjectFv
     * @address 0x16B120
     * @size 0x50
     */
    virtual void DrawStep();

    /**
     *
     * Returns the alpha the object is drawn with.
     *
     * @mangled GetAlpha__7CObjectFv
     * @address 0x16B170
     * @size 0x50
     */
    virtual float GetAlpha();

    /**
     *
     * Shows or hides the object.
     *
     * @mangled Show__7CObjectFi
     * @address 0x161F80
     * @size 0x10
     */
    virtual void Show(int on) { show = on; }

    /**
     *
     * Returns whether the object is shown.
     *
     * @mangled GetShow__7CObjectFv
     * @address 0x160520
     * @size 0x10
     */
    virtual int GetShow() { return show; }

    /**
     *
     * Sets the distance beyond which the object is not drawn.
     *
     * @mangled SetFarDist__7CObjectFf
     * @address 0x161F90
     * @size 0x10
     */
    virtual void SetFarDist(float dist) { far_dist = dist; }

    /**
     *
     * Returns the distance beyond which the object is not drawn.
     *
     * @mangled GetFarDist__7CObjectFv
     * @address 0x161FA0
     * @size 0x10
     */
    virtual float GetFarDist() { return far_dist; }

    /**
     *
     * Sets the distance within which the object is not drawn.
     *
     * @mangled SetNearDist__7CObjectFf
     * @address 0x161FB0
     * @size 0x10
     */
    virtual void SetNearDist(float dist) { near_dist = dist; }

    /**
     *
     * Returns the distance within which the object is not drawn.
     *
     * @mangled GetNearDist__7CObjectFv
     * @address 0x161FC0
     * @size 0x10
     */
    virtual float GetNearDist() { return near_dist; }

    /**
     *
     * Returns whether the object is to be drawn this frame.
     *
     * @mangled CheckDraw__7CObjectFv
     * @address 0x16B030
     * @size 0xF0
     */
    virtual int CheckDraw();

    /**
     *
     * Copies the object's placement, draw distances and fade into another object.
     *
     * @mangled Copy__7CObjectFR7CObjectP9mgCMemory
     * @address 0x161FD0
     * @size 0xB0
     */
    virtual void Copy(CObject &dest, mgCMemory *stack) { dest = *this; }

    /**
     *
     * Builds the object's world matrix from its scale, rotation and position.
     *
     * @mangled GetMatrix__7CObjectFPA4_f
     * @address 0x16AE00
     * @size 0xD0
     */
    void GetMatrix(float (*out_matrix)[4]);
};

STATIC_ASSERT(sizeof(CObject) == 0x70);

/**
 *
 * Water surface of a map, drawn at the placed parts it is attached to and optionally following the camera.
 *
 */
class CMapWater : public CObject {
public:
    CWaterFrame  *frame;      /**< Water surface drawn, or NULL when the slot is free. */
    sceVu0IVECTOR follow;     /**< Nonzero for each axis on which the surface follows the camera. */
    char         *parts_name; /**< Name of the placed parts the surface is drawn at, or NULL for the world origin. */
    s32           parts_max;  /**< Capacity of parts. */
    s32           parts_num;  /**< Number of placed parts in parts. */
    CMapParts   **parts;      /**< Placed parts the surface is drawn at, NULL for the world origin. */

    /**
     *
     * Makes an empty water surface.
     *
     * @mangled __ct__9CMapWaterFv
     * @address 0x166020
     * @size 0x40
     */
    CMapWater();

    /**
     *
     * Frees the slot and forgets the surface's placed parts.
     *
     * @mangled Initialize__9CMapWaterFv
     * @address 0x15D9A0
     * @size 0x20
     */
    virtual void Initialize();

    /**
     *
     * Forgets the placed parts the surface is drawn at.
     *
     * @mangled Clear__9CMapWaterFv
     * @address 0x15D9C0
     * @size 0x50
     */
    void Clear();
};

STATIC_ASSERT(sizeof(CMapWater) == 0xA0);

/**
 *
 * Loaded map: its lighting and file information, the parts placed in it, and everything it draws and checks besides.
 *
 */
class CMap {
public:
    CMapInfo          map_info; /**< File information and environmental settings for the loaded map. */
    CMdsListSet      *mds_list_set;                     /**< Model lists the map's parts are taken from. */
    CList<CMapParts> *parts_list;                       /**< First of the parts the map can place. */
    s32               parts_group_max;                  /**< Number of slots in parts_group. */
    CPartsGroup       parts_group[MAP_PARTS_GROUP_MAX]; /**< Named groups of placed parts. */
    s32               unk_30c;
    CEffectList       effect_list;                  /**< Effects the map's function points draw. */
    s32               place_parts_max;              /**< Capacity of place_parts. */
    CMapParts        *place_parts;                  /**< Parts placed in the map. */
    s32               place_parts_num;              /**< Number of entries of place_parts in use, up to the last placed. */
    s32               bbox_valid;                   /**< Nonzero once bbox holds the bounds of a placed parts. */
    mgVu0FBOX         bbox;                         /**< Bounds of every placed parts. */
    s32               draw_parts_num;               /**< Number of placed parts in draw_parts. */
    CMapParts       **draw_parts;                   /**< Placed parts on screen this frame. */
    s32               draw_rect_max;                /**< Number of slots in draw_rect. */
    MapDrawOffRect    draw_rect[MAP_DRAW_RECT_MAX]; /**< Areas that hide placed parts. */
    s32               occlusion_num;                /**< Number of planes in occlusion. */
    COcclusion        occlusion[MAP_OCCLUSION_MAX]; /**< Planes that hide the placed parts behind them. */
    s32               camera_info_num;              /**< Number of fixed cameras in camera_info. */
    CCameraInfo      *camera_info;                  /**< Fixed cameras of the map. */
    float             now_time;                     /**< Time of day the map is lit for, in hours. */
    s32               obj_anime_num;                /**< Number of animations in obj_anime. */
    CObjAnime        *obj_anime;                    /**< Animations driven by the map's function points. */
    s32               tr_box_texture;               /**< Texture block of the treasure box model, or -1. */
    s32               tr_box_num;                   /**< Number of treasure boxes in tr_box. */
    CMapTreasureBox  *tr_box;                       /**< Treasure boxes placed at the map's treasure box points. */
    CMapTreasureBox  *tr_box_model;                 /**< Treasure box that every one in tr_box is copied from. */
    s32               unk_ca4;
    s32               piece_load_skip;   /**< Skips loading the map's pieces while nonzero. */
    s32               parts_event;       /**< Nonzero when placed parts hold event points, so events are searched in them too. */
    CFuncPointMngr    func_point;        /**< Function points of the map itself. */
    float             anime_time;        /**< Frames counted by EffectStep, for the function points' animation. */
    s32               anime_frame;       /**< anime_time as a whole number of frames. */
    s32               water_surface_num; /**< Number of water surfaces in water_surface. */
    CWaterFrame     **water_surface;     /**< Water surfaces the map's water draws. */
    s32               water_num;         /**< Number of slots in water. */
    CMapWater        *water;             /**< Places the water surfaces are drawn at. */
    CFireRaster      *fire_raster;       /**< Heat-haze raster that fire points draw into, or NULL. */

    /**
     *
     * Draws every placed parts on screen, lit by the map's point lights, and returns the number drawn.
     *
     * @mangled DrawSub__4CMapFi
     * @address 0x15F660
     * @size 0x180
     */
    virtual int DrawSub(int direct);

    /**
     *
     * Draws every placed parts on screen.
     *
     * @mangled Draw__4CMapFv
     * @address 0x161F20
     * @size 0x20
     */
    virtual int Draw() { return DrawSub(0); }

    /**
     *
     * Draws every placed parts on screen straight into the packet.
     *
     * @mangled DrawDirect__4CMapFv
     * @address 0x161F40
     * @size 0x20
     */
    virtual int DrawDirect() { return DrawSub(1); }

    /**
     *
     * Works out which placed parts are on screen and steps their function points, and returns whether the map is on screen.
     *
     * @mangled PreDraw__4CMapFPf
     * @address 0x15EBB0
     * @size 0x440
     */
    virtual int PreDraw(float *view_pos);

    /**
     *
     * Draws the effects of the function points of the map and of every placed parts on screen.
     *
     * @mangled DrawEffect__4CMapFv
     * @address 0x15F800
     * @size 0x1E0
     */
    virtual void DrawEffect();

    /**
     *
     * Draws the fire of the fire points of the map and of every placed parts on screen.
     *
     * @mangled DrawFireEffect__4CMapFi
     * @address 0x15F9E0
     * @size 0x150
     */
    virtual void DrawFireEffect(int tex_block);

    /**
     *
     * Draws the heat haze of the fire points of the map and of every placed parts on screen.
     *
     * @mangled DrawFireRaster__4CMapFv
     * @address 0x15FB30
     * @size 0xE0
     */
    virtual void DrawFireRaster();

    /**
     *
     * Draws the map's water surfaces over a copy of the frame buffer.
     *
     * @mangled DrawWater__4CMapFP9mgCCameraP10mgCTextureP10mgCTexture
     * @address 0x15FC10
     * @size 0x770
     */
    virtual void DrawWater(mgCCamera *camera, mgCTexture *screen, mgCTexture *overlay);

    /**
     *
     * Gathers the polygons of one kind from the placed parts touching a box, and returns the number gathered.
     *
     * @mangled GetPoly__4CMapFiP6CCPolyR9mgVu0FBOXi
     * @address 0x160530
     * @size 0x140
     */
    virtual int GetPoly(int kind, CCPoly *polys, mgVu0FBOX &box, int max);

    /**
     *
     * Gathers the collision polygons of the placed parts touching a box.
     *
     * @mangled GetColPoly__4CMapFP6CCPolyR9mgVu0FBOXi
     * @address 0x160670
     * @size 0x30
     */
    virtual int GetColPoly(CCPoly *polys, mgVu0FBOX &box, int max);

    /**
     *
     * Gathers the camera collision polygons of the placed parts touching a box.
     *
     * @mangled GetCameraPoly__4CMapFP6CCPolyR9mgVu0FBOXi
     * @address 0x1606A0
     * @size 0x30
     */
    virtual int GetCameraPoly(CCPoly *polys, mgVu0FBOX &box, int max);

    /**
     *
     * Returns the nearest event point of the map or its placed parts that a position is inside, filling in its information.
     *
     * @mangled GetEvent__4CMapFPfiP12MapEventInfo
     * @address 0x160C90
     * @size 0x380
     */
    virtual CFuncPoint *GetEvent(float *pos, int check_type, MapEventInfo *info);

    /**
     *
     * Returns the nearest function point on screen that the camera looks at, among the placed parts on screen.
     *
     * @mangled InScreenFunc__4CMapFP16InScreenFuncInfo
     * @address 0x161010
     * @size 0x100
     */
    virtual CFuncPoint *InScreenFunc(InScreenFuncInfo *info);

    /**
     *
     * Draws the screen markers of the function points of every placed parts on screen.
     *
     * @mangled DrawScreenFunc__4CMapFP8mgCFrame
     * @address 0x161110
     * @size 0xA0
     */
    virtual void DrawScreenFunc(mgCFrame *frame);

    /**
     *
     * Gathers the sound effects that the sound points of the map and its placed parts play, with their volume and pan.
     *
     * @mangled GetSeSrcVolPan__4CMapFPiPfPfi
     * @address 0x161370
     * @size 0x170
     */
    virtual int GetSeSrcVolPan(int *ids, float *vol, float *pan, int max);

    /**
     *
     * Steps the animations of the placed parts and of the map's function points.
     *
     * @mangled AnimeStep__4CMapFP12CObjAnimeEnv
     * @address 0x161200
     * @size 0x100
     */
    virtual void AnimeStep(CObjAnimeEnv *env);

    /**
     *
     * Steps every placed parts.
     *
     * @mangled Step__4CMapFv
     * @address 0x161300
     * @size 0x70
     */
    virtual void Step();

    /**
     *
     * Returns the name of the map's class.
     *
     * @mangled Iam__4CMapFv
     * @address 0x15D920
     * @size 0x10
     */
    virtual char *Iam();

    /**
     *
     * Empties the map of parts, groups, areas, planes, points, treasure boxes and water.
     *
     * @mangled Initialize__4CMapFv
     * @address 0x15DC80
     * @size 0x1C0
     */
    virtual void Initialize();

    /**
     *
     * Makes an empty map.
     *
     * @mangled __ct__4CMapFv
     * @address 0x289910
     * @size 0xF0
     */
    CMap();

    /**
     *
     * Returns a parts group by slot number, or NULL for a number out of range.
     *
     * @mangled GetPartsGroup__4CMapFi
     * @address 0x15DA10
     * @size 0x40
     */
    CPartsGroup *GetPartsGroup(int no);

    /**
     *
     * Adds placed parts to the named parts group, making the group if needed, and returns the group's slot number or -1.
     *
     * @mangled AddPartsGroup__4CMapFPcP9CMapPartsP9mgCMemory
     * @address 0x15DA50
     * @size 0x100
     */
    int AddPartsGroup(char *name, CMapParts *parts, mgCMemory *memory);

    /**
     *
     * Returns the parts group of a name, or NULL.
     *
     * @mangled SearchPartsGroup__4CMapFPc
     * @address 0x15DB60
     * @size 0x30
     */
    CPartsGroup *SearchPartsGroup(char *name);

    /**
     *
     * Returns the slot number of the parts group of a name, or -1.
     *
     * @mangled SearchPartsGroupNo__4CMapFPc
     * @address 0x15DB90
     * @size 0xA0
     */
    int SearchPartsGroupNo(char *name);

    /**
     *
     * Returns the slot number of the first free parts group, or -1.
     *
     * @mangled SerachEmptyPartsGroupNo__4CMapFv
     * @address 0x15DC30
     * @size 0x50
     */
    int SerachEmptyPartsGroupNo();

    /**
     *
     * Makes the table of placed parts and the table of parts on screen, and empties them.
     *
     * @mangled SetPlacePartsBuff__4CMapFP9mgCMemoryi
     * @address 0x15DE40
     * @size 0x100
     */
    void SetPlacePartsBuff(mgCMemory *memory, int count);

    /**
     *
     * Returns the table of placed parts and gives its capacity.
     *
     * @mangled GetPlacPartsTable__4CMapFPi
     * @address 0x15DFE0
     * @size 0x10
     */
    CMapParts *GetPlacPartsTable(int *out_max);

    /**
     *
     * Sets the table of the map's fixed cameras.
     *
     * @mangled SetCameraInfoTable__4CMapFP11CCameraInfoi
     * @address 0x15DFF0
     * @size 0x10
     */
    void SetCameraInfoTable(CCameraInfo *table, int num);

    /**
     *
     * Returns a fixed camera by number, or NULL for a number out of range.
     *
     * @mangled GetCameraInfo__4CMapFi
     * @address 0x15E000
     * @size 0x50
     */
    CCameraInfo *GetCameraInfo(int no);

    /**
     *
     * Returns the first unused entry of the table of placed parts, or NULL when it is full.
     *
     * @mangled NewPlaceParts__4CMapFv
     * @address 0x15E050
     * @size 0x70
     */
    CMapParts *NewPlaceParts();

    /**
     *
     * Returns the model of a name from the map's model lists, or NULL.
     *
     * @mangled SearchMDS__4CMapFPc
     * @address 0x15E0C0
     * @size 0x30
     */
    CMdsInfo *SearchMDS(char *name);

    /**
     *
     * Loads the effects the map's function points draw.
     *
     * @mangled CreateEffect__4CMapFPUiiP9mgCMemory
     * @address 0x15E0F0
     * @size 0x20
     */
    void CreateEffect(unsigned int *pack, int tex_block, mgCMemory *stack);

    /**
     *
     * Returns the index of the effect of a name, or -1.
     *
     * @mangled SaerchEffectIndex__4CMapFPc
     * @address 0x15E110
     * @size 0x10
     */
    int SaerchEffectIndex(char *name);

    /**
     *
     * Appends parts to the end of the list of parts the map can place.
     *
     * @mangled AddParts__4CMapFP17CList_9CMapParts_
     * @address 0x15E120
     * @size 0x50
     */
    void AddParts(CList<CMapParts> *node);

    /**
     *
     * Returns the parts of a name that the map can place, or NULL.
     *
     * @mangled GetParts__4CMapFPc
     * @address 0x15E170
     * @size 0xA0
     */
    CMapParts *GetParts(char *name);

    /**
     *
     * Adds an area that hides the placed parts inside a second box.
     *
     * @mangled CreateDrawRect__4CMapFP9mgCMemoryP9mgVu0FBOXP9mgVu0FBOXi
     * @address 0x15E210
     * @size 0x1C0
     */
    void CreateDrawRect(mgCMemory *memory, mgVu0FBOX *rect, mgVu0FBOX *clip, int outside);

    /**
     *
     * Adds an occlusion plane given by its four corners.
     *
     * @mangled CreateOcclusion__4CMapFPA4_f
     * @address 0x15E3E0
     * @size 0xB0
     */
    void CreateOcclusion(float (*corner)[4]);

    /**
     *
     * Places the parts of a name at a position, rotation and scale, and returns the placed parts or NULL.
     *
     * @mangled PlaceParts__4CMapFPcPfPfPfP9mgCMemory
     * @address 0x15E490
     * @size 0xF0
     */
    CMapParts *PlaceParts(char *name, float *pos, float *rot, float *scale, mgCMemory *stack);

    /**
     *
     * Finishes placing parts: attaches water surfaces to their parts and works out the map's bounds.
     *
     * @mangled PlacePartsEnd__4CMapFv
     * @address 0x15E580
     * @size 0x1E0
     */
    void PlacePartsEnd();

    /**
     *
     * Resets every placed parts and water surface.
     *
     * @mangled ClearPlaceParts__4CMapFv
     * @address 0x15E760
     * @size 0xD0
     */
    void ClearPlaceParts();

    /**
     *
     * Returns the placed parts of a name, or NULL.
     *
     * @mangled GetPlaceParts__4CMapFPc
     * @address 0x15E830
     * @size 0xA0
     */
    CMapParts *GetPlaceParts(char *name);

    /**
     *
     * Returns the placed parts of a number, or NULL for a negative number or one beyond the parts count.
     *
     * @mangled GetPlaceParts__4CMapFi
     * @address 0x15E8D0
     * @size 0x50
     */
    CMapParts *GetPlaceParts(int no);

    /**
     *
     * Returns the number of a placed parts, or -1 for NULL.
     *
     * @mangled ConvertParts__4CMapFP9CMapParts
     * @address 0x15E920
     * @size 0x40
     */
    int ConvertParts(CMapParts *parts);

    /**
     *
     * Gathers the placed parts whose bounds touch a box, and returns the number gathered.
     *
     * @mangled GetPlaceParts__4CMapFP9mgVu0FBOXPP9CMapPartsi
     * @address 0x15E960
     * @size 0x100
     */
    int GetPlaceParts(mgVu0FBOX *box, CMapParts **out_parts, int max);

    /**
     *
     * Gathers the placed parts whose collision touches a box, and returns the number gathered.
     *
     * @mangled GetPlaceColParts__4CMapFP9mgVu0FBOXPP9CMapPartsi
     * @address 0x15EA60
     * @size 0xE0
     */
    int GetPlaceColParts(mgVu0FBOX *box, CMapParts **out_parts, int max);

    /**
     *
     * Fills in the time and frame that function points are checked against.
     *
     * @mangled CreateFuncCheck__4CMapFP15CFuncPointCheck
     * @address 0x15EB40
     * @size 0x40
     */
    void CreateFuncCheck(CFuncPointCheck *check);

    /**
     *
     * Gives the bounds of every placed parts and returns whether there are any.
     *
     * @mangled GetBBox__4CMapFP9mgVu0FBOX
     * @address 0x15EB80
     * @size 0x30
     */
    int GetBBox(mgVu0FBOX *out_box);

    /**
     *
     * Sets the engine's lights for a character from the map's light points, and returns the number of lights set.
     *
     * @mangled GetCharaLight__4CMapFP9mgCObjectP10CFuncPointii
     * @address 0x15EFF0
     * @size 0x4D0
     */
    int GetCharaLight(mgCObject *chara, CFuncPoint *points, int max, int use_parts);

    /**
     *
     * Sets the engine's point lights from the map's point-light points near a position, and returns the number set.
     *
     * @mangled SetFuncPLight__4CMapFPfP15CFuncPointCheck
     * @address 0x15F4C0
     * @size 0x110
     */
    int SetFuncPLight(float *pos, CFuncPointCheck *check);

    /**
     *
     * Turns off the engine's point lights that SetFuncPLight set.
     *
     * @mangled ResetFuncPLight__4CMapFi
     * @address 0x15F600
     * @size 0x60
     */
    void ResetFuncPLight(int num);

    /**
     *
     * Draws the treasure boxes that are not opened.
     *
     * @mangled DrawTrBox__4CMapFv
     * @address 0x160380
     * @size 0x1A0
     */
    void DrawTrBox();

    /**
     *
     * Gathers collision polygons around the treasure boxes that are not opened, and returns the number gathered.
     *
     * @mangled GetTrBoxColPoly__4CMapFP6CCPolyPfi
     * @address 0x1606D0
     * @size 0x110
     */
    int GetTrBoxColPoly(CCPoly *polys, float *param, int max);

    /**
     *
     * Gives the place of the fixed camera that covers a position, and returns a MapFixCamera.
     *
     * @mangled GetFixCameraPos__4CMapFPfPf
     * @address 0x1607E0
     * @size 0x360
     */
    int GetFixCameraPos(float *pos, float *out_camera_pos);

    /**
     *
     * Hides the parts groups that the fixed camera at a camera position asks to hide.
     *
     * @mangled FixCameraPartsOnOff__4CMapFPf
     * @address 0x160B40
     * @size 0x150
     */
    void FixCameraPartsOnOff(float *camera_pos);

    /**
     *
     * Advances the frame counter of the function points and steps the map's effects.
     *
     * @mangled EffectStep__4CMapFv
     * @address 0x1611B0
     * @size 0x50
     */
    void EffectStep();

    /**
     *
     * Loads the map's script files into the map.
     *
     * @mangled CreateMap__4CMapFP11CMdsListSetP9mgCMemory
     * @address 0x1614E0
     * @size 0x80
     */
    void CreateMap(CMdsListSet *mds_list_set, mgCMemory *stack);

    /**
     *
     * Makes an animation for each of the map's animation points.
     *
     * @mangled AssignFuncPoint__4CMapFP9mgCMemory
     * @address 0x161560
     * @size 0x150
     */
    void AssignFuncPoint(mgCMemory *stack);

    /**
     *
     * Makes a treasure box, copied from a model, at each treasure box point of the map and its placed parts.
     *
     * @mangled CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory
     * @address 0x1616D0
     * @size 0x2A0
     */
    void CreateTrBox(CMapTreasureBox *model, int tex_block, mgCMemory *stack);

    /**
     *
     * Returns a treasure box by number, or NULL for a negative number or one beyond the box count.
     *
     * @mangled GetTrBox__4CMapFi
     * @address 0x161A30
     * @size 0x50
     */
    CMapTreasureBox *GetTrBox(int index);

    /**
     *
     * Removes an opened treasure box and records it in the map's flags.
     *
     * @mangled DeleteTrBox__4CMapFiP12CMapFlagData
     * @address 0x161A80
     * @size 0x70
     */
    void DeleteTrBox(int no, CMapFlagData *flags);

    /**
     *
     * Shows each treasure box whose flag says it is not opened, and hides the rest.
     *
     * @mangled UpdateTrBoxFlag__4CMapFP12CMapFlagData
     * @address 0x161AF0
     * @size 0xA0
     */
    void UpdateTrBoxFlag(CMapFlagData *flag_data);

    /**
     *
     * Loads the map's textures and models from their pack files.
     *
     * @mangled LoadData__4CMapFPUiPUiPiP9mgCMemory
     * @address 0x161B90
     * @size 0x180
     */
    void LoadData(unsigned int *pcp_pack, unsigned int *img_pack, int *tex_block, mgCMemory *stack);

    /**
     *
     * Returns the time of day the map is lit for, in hours.
     *
     * @mangled GetNowTime__4CMapFv
     * @address 0x162140
     * @size 0x40
     */
    float GetNowTime();

    /**
     *
     * Returns the band of the day that the map's time falls in.
     *
     * @mangled GetNowTimeBand__4CMapFv
     * @address 0x162180
     * @size 0x30
     */
    int GetNowTimeBand();

    /**
     *
     * Returns the light set that the map's time falls in.
     *
     * @mangled GetNowTimeLightBand__4CMapFv
     * @address 0x1621B0
     * @size 0xD0
     */
    int GetNowTimeLightBand();

    /**
     *
     * Gives the weight of each light set at the map's time.
     *
     * @mangled GetLightingRatio__4CMapFPf
     * @address 0x162280
     * @size 0x170
     */
    void GetLightingRatio(float *out_ratio);

    /**
     *
     * Gives the weight of each light set at the map's time for the lens flare.
     *
     * @mangled GetLightingFlareRatio__4CMapFPf
     * @address 0x1623F0
     * @size 0x30
     */
    void GetLightingFlareRatio(float *out_ratio);

    /**
     *
     * Gives the weight of each light set at the map's time for the sun.
     *
     * @mangled GetLightingSunRatio__4CMapFPf
     * @address 0x162420
     * @size 0xE0
     */
    void GetLightingSunRatio(float *out_ratio);

    /**
     *
     * Gives the weight of each of the map's light sets at its time, and returns the number of light sets.
     *
     * @mangled GetTimeLightingRatio__4CMapFPf
     * @address 0x162500
     * @size 0x1C0
     */
    int GetTimeLightingRatio(float *out_ratio);

    /**
     *
     * Gives the position of the sun at the map's time.
     *
     * @mangled GetSunPoint__4CMapFPf
     * @address 0x1626C0
     * @size 0xB0
     */
    void GetSunPoint(float *out_pos);

    /**
     *
     * Returns the hour at which a light set is at full weight, or -1.
     *
     * @mangled GetLightNoTime__4CMapFi
     * @address 0x162770
     * @size 0x120
     */
    float GetLightNoTime(int index);

    /**
     *
     * Returns whether the map's lighting follows the time of day.
     *
     * @mangled GetTimeEnable__4CMapFv
     * @address 0x162890
     * @size 0x10
     */
    int GetTimeEnable();

    /**
     *
     * Gives the lighting at the map's time, blended from its light sets.
     *
     * @mangled GetLightInfo__4CMapFP16CMapLightingInfo
     * @address 0x1628A0
     * @size 0x1B0
     */
    void GetLightInfo(CMapLightingInfo *out_info);

    /**
     *
     * Returns a light set by number, or NULL for a number out of range.
     *
     * @mangled GetLightingInfo__4CMapFi
     * @address 0x162B70
     * @size 0x10
     */
    CMapLightingInfo *GetLightingInfo(int no);

    /**
     *
     * Returns the number of the light set in use when the lighting does not follow the time.
     *
     * @mangled GetActiveLightNo__4CMapFv
     * @address 0x162B80
     * @size 0x10
     */
    int GetActiveLightNo();

    /**
     *
     * Gives the lighting blended from the map's light sets by given weights.
     *
     * @mangled GetLightInfo__4CMapFP16CMapLightingInfoPfi
     * @address 0x162BA0
     * @size 0x4B0
     */
    void GetLightInfo(CMapLightingInfo *out_info, float *ratio, int num);

    /**
     *
     * Runs a map script, placing what it describes into the map.
     *
     * @mangled LoadMapFile__4CMapFPciP9mgCMemoryi
     * @address 0x165890
     * @size 0x90
     */
    void LoadMapFile(char *script, int length, mgCMemory *memory, int add_mode);

    /**
     *
     * Sets whether loading skips the map's pieces.
     *
     * @mangled SetPieceLoadSkip__4CMapFi
     * @address 0x165920
     * @size 0x10
     */
    void SetPieceLoadSkip(int skip);

    /**
     *
     * Runs a map configuration script, setting up the map's function points, areas, planes and water.
     *
     * @mangled LoadCfgFile__4CMapFPciP9mgCMemory
     * @address 0x1661E0
     * @size 0x70
     */
    void LoadCfgFile(char *script, int length, mgCMemory *memory);
};

STATIC_ASSERT(sizeof(CMap) == 0xD10);

/**
 *
 * Name that CMap::Iam returns.
 *
 */
extern char *CMapName;

/**
 *
 * Returns whether a position is inside an event point and passes its check, filling in the event and its distance.
 *
 * @mangled CheckFuncEvent__FP10CFuncPointPfiP12MapEventInfoPf
 * @address 0x161D10
 * @size 0x210
 */
int CheckFuncEvent(CFuncPoint *point, float *pos, int check_type, MapEventInfo *info, float *out_dist);
