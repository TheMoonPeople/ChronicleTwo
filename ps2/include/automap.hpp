#pragma once

#include "common.h"

#include <libvu0.h>

#include "prespr.hpp"

/**
 * @file
 * Declares the dungeon floor generator that lays out random floors on a grid
 * of map parts, the mini map that draws that grid and the symbols on it, and
 * the healing point a generated floor may contain.
 */

class CCharacter2;
class CMap;
class CMapParts;
class mgCMemory;
class mgCTexture;

/**
 *
 * Kinds of grid cell, as flags, taken from the family of parts a cell uses.
 *
 */
enum AUTOMAP_PARTS_KIND {
    AUTOMAP_KIND_NONE = 0x0,       /**< Empty cell. */
    AUTOMAP_KIND_ROAD = 0x1,       /**< Corridor cell ("way" parts). */
    AUTOMAP_KIND_ROOM = 0x2,       /**< Room cell of the first room family ("room00" to "room27"). */
    AUTOMAP_KIND_ROOM_ALT = 0x4,   /**< Room cell of the second room family ("room28" to "room55"). */
    AUTOMAP_KIND_ENTRANCE = 0x8,   /**< Room cell that a corridor enters ("door" parts). */
    AUTOMAP_KIND_DOOR = 0x10,      /**< Entrance closed by a door that the floor's door event opens. */
    AUTOMAP_KIND_STEP = 0x20,      /**< Cell of the "step" parts family. */
    AUTOMAP_KIND_PART = 0x100,     /**< Cell of the "part" parts family. */
    AUTOMAP_KIND_ROAD_END = 0x200, /**< Corridor end that holds a way in or out of the floor. */
    AUTOMAP_KIND_HEALING = 0x400,  /**< Room cell that holds the healing point. */
};

/**
 *
 * Sides of a grid cell that a corridor or room opens onto, as flags.
 *
 */
enum AUTOMAP_LINK {
    AUTOMAP_LINK_NEG_Z = 0x1, /**< Opens onto the cell on the previous row. */
    AUTOMAP_LINK_POS_Z = 0x2, /**< Opens onto the cell on the next row. */
    AUTOMAP_LINK_POS_X = 0x4, /**< Opens onto the next cell of the row. */
    AUTOMAP_LINK_NEG_X = 0x8, /**< Opens onto the previous cell of the row. */
};

/**
 *
 * Sides of a grid cell that a wall closes, as flags, taken from the placed part.
 *
 */
enum AUTOMAP_WALL {
    AUTOMAP_WALL_NEG_X = 0x1, /**< Closed towards the previous cell of the row. */
    AUTOMAP_WALL_NEG_Z = 0x2, /**< Closed towards the cell on the previous row. */
    AUTOMAP_WALL_POS_X = 0x4, /**< Closed towards the next cell of the row. */
    AUTOMAP_WALL_POS_Z = 0x8, /**< Closed towards the cell on the next row. */
};

/**
 *
 * Attribute flags a grid cell carries for scripts and the mini map.
 *
 */
enum AUTOMAP_ATTR {
    AUTOMAP_ATTR_HIDE = 0x1, /**< The mini map never draws the cell. */
};

/**
 *
 * Options that change how a floor is generated, as flags.
 *
 */
enum AUTOMAP_GEN_FLAG {
    AUTOMAP_GEN_DUMMY_TREE = 0x1,     /**< Surrounds the floor with dummy tree parts. */
    AUTOMAP_GEN_PRESET_FLOOR = 0x2,   /**< Uses a whole preset layout chosen by the dungeon floor, and does not reveal whole rooms on the mini map. */
    AUTOMAP_GEN_DUMMY_MOUNTAIN = 0x4, /**< Places the dummy mountain part. */
    AUTOMAP_GEN_FIXED_START = 0x8,    /**< Starts a 20 by 16 random floor from preset layout 0. */
    AUTOMAP_GEN_NO_IN_OUT = 0x10,     /**< Does not place the floor's way in and out. */
    AUTOMAP_GEN_NO_HEALING = 0x20,    /**< Does not place a healing point. */
    AUTOMAP_GEN_FIXED_FLOOR = 0x40,   /**< Uses preset layout 0 as the whole floor. */
};

/**
 *
 * Kinds of symbol the mini map draws over the grid.
 *
 */
enum MINIMAP_SYMBOL {
    MINIMAP_SYMBOL_MONSTER = 0,       /**< A monster, or a ball of the sphida game. */
    MINIMAP_SYMBOL_TREASURE_BOX = 1,  /**< A treasure box. */
    MINIMAP_SYMBOL_RANDOM_CIRCLE = 2, /**< A random circle. */
    MINIMAP_SYMBOL_GEOSTONE = 3,      /**< The geostone. */
    MINIMAP_SYMBOL_SPHIDA_4 = 4,      /**< First sphida game marker, in its first state. */
    MINIMAP_SYMBOL_SPHIDA_5 = 5,      /**< First sphida game marker, in its second state. */
    MINIMAP_SYMBOL_SPHIDA_6 = 6,      /**< Second sphida game marker, in its first state. */
    MINIMAP_SYMBOL_SPHIDA_7 = 7,      /**< Second sphida game marker, in its second state. */
    MINIMAP_SYMBOL_MONSTER_BLINK = 8, /**< A monster shown with a blinking symbol. */
    MINIMAP_SYMBOL_END = -1,          /**< Ends the symbol table. */
};

/**
 *
 * One kind of map part the generator can place in a grid cell.
 *
 */
struct AUTOMAP_PARTS_INFO {
    char *name;      /**< Name of the part to place; NULL ends the table. */
    s16 kind;        /**< Cell kind, an AUTOMAP_PARTS_KIND combination. */
    u8 link;         /**< Sides the part opens onto, an AUTOMAP_LINK combination. */
    u8 entrance;     /**< Side an entrance part's corridor arrives from, an AUTOMAP_LINK combination. */
    s16 unk_8[8];
};
STATIC_ASSERT(sizeof(AUTOMAP_PARTS_INFO) == 0x18);

/**
 *
 * Mini map tiles to show for every part of one map.
 *
 */
struct MINIMAP_INFO {
    char name[16];  /**< Name of the map the tiles belong to. */
    s16 tile[320];  /**< Mini map tile of each AUTOMAP_PARTS_INFO entry, by its index. */
};
STATIC_ASSERT(sizeof(MINIMAP_INFO) == 0x290);

/**
 *
 * Appearance of one kind of mini map symbol.
 *
 */
struct MINIMAP_SYMBOL_INFO {
    s16 symbol;       /**< Kind of symbol, a MINIMAP_SYMBOL; MINIMAP_SYMBOL_END ends the table. */
    s16 r;            /**< Red of the symbol's colour. */
    s16 g;            /**< Green of the symbol's colour. */
    s16 b;            /**< Blue of the symbol's colour. */
    s16 w;            /**< Width of the symbol on screen. */
    s16 h;            /**< Height of the symbol on screen. */
    s16 blink;        /**< Non-zero blinks the symbol. */
    s16 need_visible; /**< Non-zero draws the symbol only over cells already revealed. */
};
STATIC_ASSERT(sizeof(MINIMAP_SYMBOL_INFO) == 0x10);

/**
 *
 * Preset room layout read from a floor's room script.
 *
 */
struct AUTOMAP_ROOM_INFO {
    s32 id;     /**< Number the script gives the layout. */
    s32 w;      /**< Width of the layout in cells. */
    s32 h;      /**< Height of the layout in cells. */
    s32 fixed;  /**< Above zero keeps the layout out of random room selection. */
    s32 rate;   /**< Chance out of 100 that random room selection keeps the layout. */
    s16 *table; /**< Part index and attribute of each cell, row by row; a part index of -1 leaves the cell empty. */
};
STATIC_ASSERT(sizeof(AUTOMAP_ROOM_INFO) == 0x18);

/**
 *
 * Area of the grid a generated room covers.
 *
 */
struct AUTOMAP_ROOM {
    s32 unk_0;
    s32 x; /**< First cell of the room along a row. */
    s32 y; /**< First row of the room. */
    s32 w; /**< Width of the room in cells. */
    s32 h; /**< Height of the room in rows. */
};
STATIC_ASSERT(sizeof(AUTOMAP_ROOM) == 0x14);

/**
 *
 * One cell of a dungeon floor's grid: the part placed there, how it links to
 * its neighbours, and what the mini map and navigation know about it.
 *
 */
class CAutoMapParts {
public:
    u32 kind;          /**< Cell kind, an AUTOMAP_PARTS_KIND combination. */
    s16 parts_no;      /**< Index into PartsInfoData of the part to place, or -1. */
    s16 attr;          /**< Attribute flags, an AUTOMAP_ATTR combination. */
    s16 room_no;       /**< Room or corridor the cell belongs to, or -1. */
    u8 road_link;      /**< Sides a corridor opens onto, an AUTOMAP_LINK combination. */
    u8 link;           /**< Sides the cell opens onto, an AUTOMAP_LINK combination. */
    s16 visible;       /**< Non-zero once the mini map reveals the cell. */
    CMapParts *parts;  /**< Part placed in the cell. */
    u32 wall;          /**< Sides a wall closes, an AUTOMAP_WALL combination. */
    s8 navi;           /**< Steps left to the navigation target, 0 if unreached, or -1 for an empty cell. */

    void Initialize() {
        parts_no = -1;
        attr = 0;
        kind = 0;
        room_no = -1;
        road_link = 0;
        link = 0;
        visible = 0;
        wall = -1;
        parts = NULL;
    }
};
STATIC_ASSERT(sizeof(CAutoMapParts) == 0x1C);

/**
 *
 * Mini map of a dungeon floor: draws the part tiles of the revealed cells and
 * the symbols of characters and objects over them.
 *
 */
class CMiniMapSymbol {
public:
    CMap *map;                  /**< Map whose placed parts are drawn. */
    CMapParts *parts_table;     /**< Placed parts of the map. */
    s32 parts_num;              /**< Number of placed parts in parts_table. */
    mgCTexture *texture;        /**< Texture holding the mini map tiles. */
    CPreSprite prim;            /**< Primitive builder that draws the symbols. */
    CAutoMapParts *grid;        /**< Grid of the generated floor, or NULL. */
    MINIMAP_INFO *info;         /**< Tiles of the current map, or NULL. */
    s16 grid_w;                 /**< Width of the grid in cells. */
    s16 grid_h;                 /**< Height of the grid in cells. */
    float cell_w;               /**< Width of a cell along X in world units. */
    float cell_d;               /**< Depth of a cell along Z in world units. */
    s32 unk_154[3];
    sceVu0FVECTOR center;       /**< World position the mini map is centred on. */
    s16 x;                      /**< Screen X of the mini map's centre. */
    s16 y;                      /**< Screen Y of the mini map's centre. */
    s16 w;                      /**< Screen width of the mini map. */
    s16 h;                      /**< Screen height of the mini map. */
    s32 blink_cnt;              /**< Frame counter that blinks symbols, from 0 to 30. */
    s16 large;                  /**< Non-zero while the mini map is shown at its large size. */
    u8  unk_17e[0x2];

    /**
     *
     * Takes the map, grid and cell size to draw, and finds the tile of each
     * placed part for the current map.
     *
     * @mangled SetMapInfo__14CMiniMapSymbolFP4CMapP13CAutoMapPartsiiff
     * @address 0x1D5D60
     * @size 0x1F0
     */
    void SetMapInfo(CMap *map, CAutoMapParts *grid, int grid_w, int grid_h, float cell_w, float cell_d);

    /**
     *
     * Starts drawing symbols, limited to the mini map's screen area.
     *
     * @mangled DrawSymbolOpen__14CMiniMapSymbolFv
     * @address 0x1D5F50
     * @size 0xB0
     */
    void DrawSymbolOpen();

    /**
     *
     * Finishes drawing symbols and advances the blink counter.
     *
     * @mangled DrawSymbolClose__14CMiniMapSymbolFv
     * @address 0x1D6000
     * @size 0x70
     */
    void DrawSymbolClose();

    /**
     *
     * Draws a symbol of the given kind at a world position.
     *
     * @mangled DrawSymbol__14CMiniMapSymbolFPfi
     * @address 0x1D6070
     * @size 0x250
     */
    void DrawSymbol(float *pos, int symbol);

    /**
     *
     * Draws the arrow that shows a character's position and facing.
     *
     * @mangled DrawSymbol_Chara__14CMiniMapSymbolFP11CCharacter2
     * @address 0x1D62C0
     * @size 0x410
     */
    void DrawSymbol_Chara(CCharacter2 *chara);

    /**
     *
     * Draws the tiles of the revealed cells around a world position.
     *
     * @mangled Draw__14CMiniMapSymbolFPf
     * @address 0x1D66D0
     * @size 0x380
     */
    void Draw(float *pos);
};
STATIC_ASSERT(sizeof(CMiniMapSymbol) == 0x180);

/**
 *
 * Healing point of a dungeon floor, which heals the party at most once every
 * 1800 frames.
 *
 */
class CHealingPoint {
public:
    s32 enable; /**< Non-zero once the floor has a healing point. */
    s32 timer;  /**< Frames left until the healing point can heal again. */

    /**
     *
     * Returns non-zero, starting the healing effect and restarting the timer,
     * when the healing point exists and is ready to heal.
     *
     * @mangled CheckHealingTime__13CHealingPointFv
     * @address 0x1D6A50
     * @size 0x60
     */
    int CheckHealingTime();

    /**
     *
     * Counts the timer down and sets the healing effect to its idle state
     * once it runs out.
     *
     * @mangled Step__13CHealingPointFv
     * @address 0x1D6AB0
     * @size 0x50
     */
    void Step();
};
STATIC_ASSERT(sizeof(CHealingPoint) == 0x8);

/**
 *
 * Generator of dungeon floors: builds a grid of rooms and corridors from
 * preset layouts or at random, places the parts, and keeps the mini map,
 * navigation and random stones of the floor.
 *
 */
class CAutoMapGen {
public:
    CMapParts *gio_parts;          /**< Placed "p01_gio" part. */
    CMapParts *random_stone[12];   /**< Placed "obj01" parts used as random stones. */
    CMapParts *pot_parts;          /**< Placed "obj02" part used by the pot. */
    s16 random_map;                /**< Non-zero once a random floor has been generated. */
    s16 minimap_enable;            /**< Non-zero once Build has run, letting the mini map reveal cells. */
    u32 gen_flag;                  /**< Generation options, an AUTOMAP_GEN_FLAG combination. */
    CMiniMapSymbol mini_map;       /**< Mini map of the floor. */
    CHealingPoint healing_point;   /**< Healing point of the floor. */
    s16 grid_w;                    /**< Width of the grid in cells. */
    s16 grid_h;                    /**< Height of the grid in cells. */
    float cell_w;                  /**< Width of a cell along X in world units. */
    float cell_d;                  /**< Depth of a cell along Z in world units. */
    AUTOMAP_ROOM_INFO *room_info;  /**< Preset room layouts read from the room script. */
    s32 room_info_num;             /**< Number of entries of room_info in use. */
    CAutoMapParts *grid;           /**< Cells of the grid, row by row. */
    s32 place_parts_num;           /**< Number of parts placed in the map. */
    AUTOMAP_ROOM room[8];          /**< Rooms of the generated floor. */
    s32 room_num;                  /**< Number of entries of room in use. */
    s32 door_room;                 /**< Room whose entrance has a door, or -1. */
    s32 navi_valid;                /**< Non-zero once the navigation distances have been worked out. */
    s32 navi_depth;                /**< Step count given to the navigation target. */
    s32 navi_enable;               /**< Non-zero once Build has run, enabling navigation. */
    s32 unk_298[2];

    /**
     *
     * Reads the preset room layouts and grid size from a room script.
     *
     * @mangled SetupRoomInfo__11CAutoMapGenFPciP9mgCMemory
     * @address 0x1D6D80
     * @size 0x170
     */
    void SetupRoomInfo(char *script, int size, mgCMemory *stack);

    /**
     *
     * Puts a room into the grid at the given cell when the area is free,
     * using the given preset layout or a random one for -1; returns non-zero
     * on success.
     *
     * @mangled CreatRoom__11CAutoMapGenFiiii
     * @address 0x1D6EF0
     * @size 0x390
     */
    int CreatRoom(int x, int y, int room_no, int info_no);

    /**
     *
     * Picks at random a side of a cell whose neighbour has one of the given
     * kinds and belongs to another room, never the excluded side; returns
     * the AUTOMAP_LINK side, or 0 when there is none.
     *
     * @mangled LinkConnectCheck__11CAutoMapGenFiiiii
     * @address 0x1D7280
     * @size 0x200
     */
    int LinkConnectCheck(int x, int y, int kind, int room_no, int exclude);

    /**
     *
     * Marks the link between a cell and the cell it was entered from on the
     * given side.
     *
     * @mangled SetRoadLinkMark__11CAutoMapGenFiii
     * @address 0x1D7480
     * @size 0x140
     */
    void SetRoadLinkMark(int x, int y, int side);

    /**
     *
     * Lays a corridor from one room to another.
     *
     * @mangled RoomLink__11CAutoMapGenFii
     * @address 0x1D75C0
     * @size 0x920
     */
    void RoomLink(int from, int to);

    /**
     *
     * Lays a dead-end corridor that leads off from a random room.
     *
     * @mangled CreatDummyRoot__11CAutoMapGenFi
     * @address 0x1D7EE0
     * @size 0x580
     */
    void CreatDummyRoot(int room_no);

    /**
     *
     * Lays a short corridor branch off a random corridor cell.
     *
     * @mangled CreatTermParts__11CAutoMapGenFv
     * @address 0x1D8460
     * @size 0x5D0
     */
    void CreatTermParts();

    /**
     *
     * Sometimes closes the single entrance of a random room with a door.
     *
     * @mangled CreatDoorRoom__11CAutoMapGenFv
     * @address 0x1D8A30
     * @size 0x2D0
     */
    void CreatDoorRoom();

    /**
     *
     * Returns the part placed at the floor's door, or NULL.
     *
     * @mangled SearchDoorParts__11CAutoMapGenFv
     * @address 0x1D8D00
     * @size 0xB0
     */
    CMapParts *SearchDoorParts();

    /**
     *
     * Chooses the part of every corridor and entrance cell from its kind and
     * links.
     *
     * @mangled SetPartsIndex__11CAutoMapGenFv
     * @address 0x1D8DB0
     * @size 0x1B0
     */
    void SetPartsIndex();

    /**
     *
     * Places the dummy mountain part.
     *
     * @mangled SetDummyMountain__11CAutoMapGenFv
     * @address 0x1D8F60
     * @size 0x80
     */
    void SetDummyMountain();

    /**
     *
     * Places dummy tree parts around the floor.
     *
     * @mangled SetDummyTree__11CAutoMapGenFv
     * @address 0x1D8FE0
     * @size 0x590
     */
    void SetDummyTree();

    /**
     *
     * Finds the healing point among the placed room parts and starts its
     * effect there.
     *
     * @mangled SearchHealingPoint__11CAutoMapGenFP4CMap
     * @address 0x1D9570
     * @size 0xF0
     */
    void SearchHealingPoint(CMap *map);

    /**
     *
     * Places the part of every cell in the map, with the floor's extra parts.
     *
     * @mangled IndexToPartsPlace__11CAutoMapGenFv
     * @address 0x1D9660
     * @size 0x340
     */
    void IndexToPartsPlace();

    /**
     *
     * Turns a random corridor end into a way in or out by offsetting its part
     * index.
     *
     * @mangled SetInOutPartsIndex__11CAutoMapGenFi
     * @address 0x1D99A0
     * @size 0x120
     */
    void SetInOutPartsIndex(int offset);

    /**
     *
     * Sometimes turns a random room cell into the healing point's room.
     *
     * @mangled SetHealingPointIndex__11CAutoMapGenFv
     * @address 0x1D9AC0
     * @size 0x130
     */
    void SetHealingPointIndex();

    /**
     *
     * Clears the grid and fills it from a preset room layout.
     *
     * @mangled CreatFixedMap__11CAutoMapGenFi
     * @address 0x1D9BF0
     * @size 0x200
     */
    void CreatFixedMap(int info_no);

    /**
     *
     * Generates a random floor: rooms, corridors, doors, ways in and out and
     * the healing point, then places the parts.
     *
     * @mangled RandomMapMainProc__11CAutoMapGenFv
     * @address 0x1D9DF0
     * @size 0x430
     */
    void RandomMapMainProc();

    /**
     *
     * Builds the floor as gen_flag asks, from a preset layout or at random.
     *
     * @mangled Build__11CAutoMapGenFv
     * @address 0x1DA220
     * @size 0x1F0
     */
    void Build();

    /**
     *
     * Reveals on the mini map the cell at a world position, its open
     * neighbours and the room it is in.
     *
     * @mangled MinimapVisTest__11CAutoMapGenFPf
     * @address 0x1DA410
     * @size 0x2C0
     */
    void MinimapVisTest(float *pos);

    /**
     *
     * Opens the door at a world position on the mini map and for navigation.
     *
     * @mangled MinimapDoorOpen__11CAutoMapGenFPf
     * @address 0x1DA6D0
     * @size 0x150
     */
    void MinimapDoorOpen(float *pos);

    /**
     *
     * Returns the random stone within the given distance of a world position,
     * or NULL.
     *
     * @mangled SearchRandomStone__11CAutoMapGenFPff
     * @address 0x1DA820
     * @size 0xB0
     */
    CMapParts *SearchRandomStone(float *pos, float range);

    /**
     *
     * Moves every random stone out of the floor.
     *
     * @mangled ClearRandomStone__11CAutoMapGenFv
     * @address 0x1DA8D0
     * @size 0x80
     */
    void ClearRandomStone();

    /**
     *
     * Steps the healing point.
     *
     * @mangled Step__11CAutoMapGenFv
     * @address 0x1DA950
     * @size 0x10
     */
    void Step();

    /**
     *
     * Returns the attribute flags of the cell at a world position, or 1 off
     * the grid.
     *
     * @mangled GetAttrStatus__11CAutoMapGenFPf
     * @address 0x1DA960
     * @size 0x140
     */
    int GetAttrStatus(float *pos);

    /**
     *
     * Reveals every cell on the mini map.
     *
     * @mangled MinimapAllVisible__11CAutoMapGenFv
     * @address 0x1DAAA0
     * @size 0x50
     */
    void MinimapAllVisible();

    /**
     *
     * Returns the walking distance from a world position to the navigation
     * target, -1 if it cannot be reached, or 0 without navigation.
     *
     * @mangled GetNaviDistance__11CAutoMapGenFPf
     * @address 0x1DAAF0
     * @size 0x150
     */
    float GetNaviDistance(float *pos);

    /**
     *
     * Works out the step count of every cell from the navigation target at a
     * world position, when the target has moved to another cell.
     *
     * @mangled UpdateNaviMap__11CAutoMapGenFPfi
     * @address 0x1DAC40
     * @size 0x320
     */
    void UpdateNaviMap(float *pos, int depth);
};
STATIC_ASSERT(sizeof(CAutoMapGen) == 0x2A0);

/** Every kind of part the floor generator can place, ending with an entry whose name is NULL. */
extern AUTOMAP_PARTS_INFO PartsInfoData[277];

/** Mini map tiles of the parts of each dungeon map. */
extern MINIMAP_INFO MiniMapInfoData[18];
