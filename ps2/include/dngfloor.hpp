#pragma once

#include "common.h"

/**
 * @file
 * Declares the dungeon floor manager: the grid of rooms and passages that
 * makes up one dungeon's tree map, read from the dungeon's map scripts, and
 * the queries the dungeon, its events and its menus make about each floor's
 * links, seals, challenges and sub games.
 */

class mgCMemory;

// clang-format off

/**
 *
 * Kinds of cell on a dungeon's tree map grid, as GLID_INFO::type holds them.
 *
 */
enum GLID_TYPE {
    GLID_TYPE_ROOT = 0, /**< A piece of passage between rooms, described by a DNGMAP_ROOT_INFO. */
    GLID_TYPE_ROOM = 1, /**< A room standing for one floor, described by a DNGMAP_ROOM_INFO. */
};

/**
 *
 * Directions from a grid cell to its neighbours, indexing GLID_INFO::link_glid,
 * DNGMAP_ROOM_INFO::link and DNGMAP_ROOM_INFO::key_room.
 *
 */
enum GLID_DIR {
    GLID_DIR_UP = 0,    /**< The cell one row above. */
    GLID_DIR_DOWN = 1,  /**< The cell one row below. */
    GLID_DIR_LEFT = 2,  /**< The cell one column to the left. */
    GLID_DIR_RIGHT = 3, /**< The cell one column to the right. */
    GLID_DIR_NUM = 4,   /**< Number of directions. */
};

/**
 *
 * Flags held in DNGMAP_ROOM_INFO::flag, set by the ROOM_OPTION keywords of a map script.
 *
 */
enum DNGMAP_ROOM_FLAG {
    DNGMAP_ROOM_FLAG_ROOM = 0x1,  /**< Set on every room. */
    DNGMAP_ROOM_FLAG_START = 0x2, /**< The room is the dungeon's entrance ("start"). */
    DNGMAP_ROOM_FLAG_EXIT = 0x4,  /**< The room is an exit ("exit"). */
    DNGMAP_ROOM_FLAG_BOSS = 0x8,  /**< The room is a boss floor ("boss"). */
    DNGMAP_ROOM_FLAG_SUB = 0x10,  /**< The room is a side floor ("sub"). */
};

/**
 *
 * Seals a floor can carry, as DNGMAP_ROOM_INFO::seal holds them.
 *
 */
enum DNGMAP_SEAL {
    DNGMAP_SEAL_NONE = 0,   /**< The floor is not sealed. */
    DNGMAP_SEAL_MONICA = 1, /**< A seal that applies only while Monica is in the party. */
    DNGMAP_SEAL_MAX = 2,    /**< A seal that applies only while Max is in the party. */
};

/**
 *
 * Sub games a floor offers, as CDngFloorManager::IsPlaySubGame gives them.
 *
 */
enum DNGMAP_SUB_GAME {
    DNGMAP_SUB_GAME_SPHEDA = 0x1,  /**< The floor has a spheda challenge. */
    DNGMAP_SUB_GAME_FISHING = 0x2, /**< The floor has a fishing record to beat. */
};

/**
 *
 * Results of CDngFloorManager::IsClearMostFastDestroy.
 *
 */
enum DNGMAP_FAST_DESTROY_RESULT {
    DNGMAP_FAST_DESTROY_NONE = 0,   /**< No new record. */
    DNGMAP_FAST_DESTROY_FIRST = 1,  /**< The floor is cleared within its target time for the first time. */
    DNGMAP_FAST_DESTROY_RECORD = 2, /**< The floor's best clear time is improved. */
};

/**
 *
 * Results of CDngFloorManager::IsClearPractice.
 *
 */
enum DNGMAP_PRACTICE_RESULT {
    DNGMAP_PRACTICE_NONE = 0,        /**< The floor has no practice condition to check now, or it is not met. */
    DNGMAP_PRACTICE_FAILED = 1,      /**< The practice condition is broken. */
    DNGMAP_PRACTICE_CLEAR = 2,       /**< The practice condition is met for the first time. */
    DNGMAP_PRACTICE_CLEAR_AGAIN = 3, /**< The practice condition is met again after an earlier clear. */
};

/**
 *
 * Special values of the floor manager.
 *
 */
enum {
    DNGMAP_DUNGEON_MAX = 6,      /**< Highest dungeon a data table can be loaded for. */
    DNGMAP_FLOOR_SPECIAL = 100,  /**< Floor number with a fixed answer outside the tree map's rooms. */
    DNGMAP_SPHEDA_PRIZE_NUM = 3, /**< Prizes a floor's spheda challenge offers. */
};

// clang-format on

/**
 *
 * Passage cell of a tree map: how the piece of passage is drawn and whether it is open.
 *
 */
struct DNGMAP_ROOT_INFO {
    u8 type;      /**< Kind of passage, whose mark is drawn on it and which bit of GetDngMapNextRoot it sets. */
    u8 shape;     /**< Shape the piece of passage is drawn with. */
    u8 show_mark; /**< Non-zero to draw the passage's type mark once it has been opened. */
    u8 open;      /**< Non-zero while both rooms the passage joins can be entered. */
    u8 opened;    /**< Non-zero once open has ever been set. */
};

STATIC_ASSERT(sizeof(DNGMAP_ROOT_INFO) == 0x5);

/**
 *
 * Room cell of a tree map: one floor of the dungeon, with its links, its
 * challenges and how its room is drawn.
 *
 */
struct DNGMAP_ROOM_INFO {
    char *unk_0;
    char *title;                                   /**< Name of the floor, from the dungeon's floor title file. */
    s8    floor_id;                                /**< Floor the room stands for. */
    s8    order;                                   /**< Position of the floor along the dungeon; links lead onward to rooms with a greater value. */
    u8    unk_a[0x2];
    u32   flag;                                    /**< Kind of room, a set of DNGMAP_ROOM_FLAG. */
    s32   fast_destroy_time;                       /**< Target clear time, in 1/60 seconds, of the floor's fast destroy challenge. */
    s8    seal;                                    /**< Seal on the floor, a DNGMAP_SEAL. */
    s8    spheda;                                  /**< Non-zero when the floor has a spheda challenge. */
    s8    geostone;                                /**< Non-zero when the floor holds a geostone. */
    s8    fishing;                                 /**< Fishing record test: below zero to beat at most fishing_record, above zero at least; zero for none. */
    s16   fishing_record;                          /**< Size, in hundredths, that the floor's fishing record test compares with. */
    s8    practice_type;                           /**< Kind of practice condition the floor sets, or -1 for none. */
    u8    unk_1b;
    s32   practice_param;                          /**< Value the practice condition is tested against. */
    u8    unk_20[0x4];
    s16   spheda_prize_item[DNGMAP_SPHEDA_PRIZE_NUM]; /**< Prize of the spheda challenge, by rank. */
    s8    spheda_prize_num[DNGMAP_SPHEDA_PRIZE_NUM];  /**< Number given of each spheda prize, by rank. */
    u8    unk_2d;
    s16   link[GLID_DIR_NUM];                      /**< Floor reached in each GLID_DIR, or a negative number for none. */
    s16   key_room[GLID_DIR_NUM];                  /**< Floor that GetKeyNextRoom gives for each GLID_DIR. */
    s16   offset_x;                                /**< Horizontal offset the room is drawn at. */
    s16   offset_y;                                /**< Vertical offset the room is drawn at. */
    s8    tex_no;                                  /**< Picture the room is drawn with. */
    u8    unk_43;
    u8    unk_44;
    u8    visited;                                 /**< Non-zero once the floor has been entered. */
    u8    mark;                                    /**< Non-zero to draw the bobbing mark over the room. */
    u8    unk_47;
    float mark_phase;                              /**< Angle, in radians, of the bobbing mark's motion. */
    s32   unk_4c;
};

STATIC_ASSERT(sizeof(DNGMAP_ROOM_INFO) == 0x50);

/**
 *
 * One cell of a dungeon's tree map grid, either a room or a piece of passage,
 * linked to the cells beside it.
 *
 */
struct GLID_INFO {
    s16        type;                    /**< Kind of cell, a GLID_TYPE. */
    s16        x;                       /**< Column of the cell. */
    s16        y;                       /**< Row of the cell. */
    s16        unk_6;
    s16        unk_8;
    u8         unk_a[0x2];
    GLID_INFO *link_glid[GLID_DIR_NUM]; /**< Cell beside this one in each GLID_DIR, or NULL. */
    u8         blink;                   /**< Non-zero to blink the cell on the map. */
    u8         unk_1d[0x3];
    union {
        DNGMAP_ROOM_INFO room; /**< Description of a GLID_TYPE_ROOM cell. */
        DNGMAP_ROOT_INFO root; /**< Description of a GLID_TYPE_ROOT cell. */
    };
};

STATIC_ASSERT(sizeof(GLID_INFO) == 0x70);

/**
 *
 * Holds the tree map grid of the dungeon being played and answers questions
 * about its floors: how they link, and the seals and challenges they carry.
 *
 */
class CDngFloorManager {
public:
    s8         dng_no;    /**< Dungeon whose data table is loaded. */
    u8         unk_1[0x3];
    GLID_INFO *glid_info; /**< Cells of the tree map grid. */
    s32        glid_num;  /**< Number of cells in glid_info. */
    s16        glid_w;    /**< Width of the grid, in cells. */
    s16        glid_h;    /**< Height of the grid, in cells. */

    /**
     *
     * Empties the manager of any data table.
     *
     * @mangled Initialize__16CDngFloorManagerFv
     * @address 0x2FDD70
     * @size 0x20
     */
    void Initialize();

    /**
     *
     * Runs one map script over the manager, adding the cells and floor details it describes.
     *
     * @mangled AnalyzeFile__16CDngFloorManagerFPciP9mgCMemory
     * @address 0x2FE4D0
     * @size 0x90
     */
    void AnalyzeFile(char *script, int size, mgCMemory *stack);

    /**
     *
     * Loads a dungeon's map, floor and floor title scripts, building its tree map grid.
     *
     * @mangled LoadDataTable__16CDngFloorManagerFiP9mgCMemory
     * @address 0x2FE560
     * @size 0x160
     */
    void LoadDataTable(int dng_no, mgCMemory *stack);

    /**
     *
     * Gives the room cell standing for a floor, or NULL.
     *
     * @mangled GetDngMapFloorGlidInfo__16CDngFloorManagerFi
     * @address 0x2FE6C0
     * @size 0x80
     */
    GLID_INFO *GetDngMapFloorGlidInfo(int floor_id);

    /**
     *
     * Tells whether a floor holds a geostone.
     *
     * @mangled IsGeoStone__16CDngFloorManagerFi
     * @address 0x2FE740
     * @size 0x30
     */
    s8 IsGeoStone(int floor_id);

    /**
     *
     * Gives a floor's spheda prize for a rank, giving 1, or 0 for no floor or a negative rank.
     *
     * @mangled GetSphedaPrize__16CDngFloorManagerFiiPiPi
     * @address 0x2FE770
     * @size 0xA0
     */
    int GetSphedaPrize(int floor_id, int rank, int *item, int *num);

    /**
     *
     * Gives the spheda prize for a rank on the floor the player is on.
     *
     * @mangled GetSphedaPrize__16CDngFloorManagerFiPiPi
     * @address 0x2FE810
     * @size 0x80
     */
    int GetSphedaPrize(int rank, int *item, int *num);

    /**
     *
     * Gives the sub games the floor the player is on offers, a set of DNGMAP_SUB_GAME.
     *
     * @mangled IsPlaySubGame__16CDngFloorManagerFv
     * @address 0x2FE890
     * @size 0x60
     */
    int IsPlaySubGame();

    /**
     *
     * Gives the seal that applies to a floor, or to the player's floor when negative, a DNGMAP_SEAL.
     *
     * @mangled IsSealFloor__16CDngFloorManagerFi
     * @address 0x2FE8F0
     * @size 0x110
     */
    s8 IsSealFloor(int floor_id);

    /**
     *
     * Records the clear time of the player's floor, giving a DNGMAP_FAST_DESTROY_RESULT.
     *
     * @mangled IsClearMostFastDestroy__16CDngFloorManagerFv
     * @address 0x2FEA00
     * @size 0x150
     */
    int IsClearMostFastDestroy();

    /**
     *
     * Tests the practice condition of the player's floor, giving a DNGMAP_PRACTICE_RESULT.
     *
     * @mangled IsClearPractice__16CDngFloorManagerFi
     * @address 0x2FEB50
     * @size 0x330
     */
    int IsClearPractice(int check_type);

    /**
     *
     * Gives the description of a floor's room, or NULL.
     *
     * @mangled GetDngMapFloorInfo__16CDngFloorManagerFi
     * @address 0x2FEE80
     * @size 0x50
     */
    DNGMAP_ROOM_INFO *GetDngMapFloorInfo(int floor_id);

    /**
     *
     * Gives the description of the room of the floor the player is on, or NULL.
     *
     * @mangled GetActiveFloorInfo__16CDngFloorManagerFv
     * @address 0x2FEED0
     * @size 0x50
     */
    DNGMAP_ROOM_INFO *GetActiveFloorInfo();

    /**
     *
     * Links every cell of the grid to the cells beside it.
     *
     * @mangled RelationGlid__16CDngFloorManagerFv
     * @address 0x2FEF20
     * @size 0xF0
     */
    void RelationGlid();

    /**
     *
     * Brings the drawing state of every room and passage up to date with the save data.
     *
     * @mangled CheckDrawGlidInfo__16CDngFloorManagerFv
     * @address 0x2FF010
     * @size 0x390
     */
    void CheckDrawGlidInfo();

    /**
     *
     * Gives the cell a passage continues to from a cell heading in a direction,
     * turning where the passage turns and updating the direction, or NULL.
     *
     * @mangled GetNextGlid__16CDngFloorManagerFP9GLID_INFOPi
     * @address 0x2FF3A0
     * @size 0xF0
     */
    GLID_INFO *GetNextGlid(GLID_INFO *glid, int *dir);

    /**
     *
     * Gives the room a floor links to in a direction, and the direction the link
     * was found in, or NULL.
     *
     * @mangled GetNextRoom__16CDngFloorManagerFiiP9GLID_INFOiPi
     * @address 0x2FF490
     * @size 0x130
     */
    GLID_INFO *GetNextRoom(int floor_id, int dir, GLID_INFO *glid, int unused, int *found_dir);

    /**
     *
     * Gives the room that a floor's key_room entry names for a direction, or NULL.
     *
     * @mangled GetKeyNextRoom__16CDngFloorManagerFiiP9GLID_INFO
     * @address 0x2FF5C0
     * @size 0x70
     */
    GLID_INFO *GetKeyNextRoom(int floor_id, int dir, GLID_INFO *glid);

    /**
     *
     * Gives the floor that a passage of a type leads onward to from a floor, or 0.
     *
     * @mangled GetDngMapNextFloorID__16CDngFloorManagerFii
     * @address 0x2FF630
     * @size 0x130
     */
    int GetDngMapNextFloorID(int floor_id, int root_type);

    /**
     *
     * Gives the name of a floor, or NULL.
     *
     * @mangled GetFloorTitle__16CDngFloorManagerFi
     * @address 0x2FF760
     * @size 0x90
     */
    char *GetFloorTitle(int floor_id);

    /**
     *
     * Gives the types of the passages leading onward from a floor, one bit per DNGMAP_ROOT_INFO::type.
     *
     * @mangled GetDngMapNextRoot__16CDngFloorManagerFi
     * @address 0x2FF7F0
     * @size 0x110
     */
    int GetDngMapNextRoot(int floor_id);
};

STATIC_ASSERT(sizeof(CDngFloorManager) == 0x10);

/**
 *
 * Counts the floors, across every dungeon, whose spheda challenge is cleared.
 *
 * @mangled GetCountSphedaClear__Fv
 * @address 0x2FF900
 * @size 0xA0
 */
int GetCountSphedaClear();

/**
 *
 * Tests a caught fish against the fishing record of the player's floor, giving 1 when it is newly beaten.
 *
 * @mangled CheckFishingRecord__Ff
 * @address 0x2FF9A0
 * @size 0x140
 */
int CheckFishingRecord(float size);
