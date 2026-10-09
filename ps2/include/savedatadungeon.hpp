#pragma once

#include "common.h"

/**
 * @file
 * Declares the dungeon part of the save data: the dungeon and floor the
 * player is in, and the record kept for every floor of every dungeon.
 */

/**
 *
 * Counts of the dungeons and floors that the dungeon save data holds records for.
 *
 */
enum {
    SAVE_DUNGEON_NUM = 7,        /**< Dungeons that the save data tracks a floor for. */
    SAVE_DUNGEON_FLOOR_NUM = 162 /**< Floor records across every dungeon. */
};

/**
 *
 * Progress flags held in DNG_FLOOR_SAVE::flag.
 *
 */
enum DNG_FLOOR_FLAG {
    DNG_FLOOR_FLAG_OPEN = 0x1,                /**< The floor can be entered. */
    DNG_FLOOR_FLAG_CLEAR = 0x2,               /**< The floor has been cleared. */
    DNG_FLOOR_FLAG_PRACTICE_CLEAR = 0x8,      /**< The floor's practice condition is cleared. */
    DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR = 0x10, /**< The floor is cleared within its target time. */
    DNG_FLOOR_FLAG_FISHING_CLEAR = 0x20,      /**< The floor's fishing record is beaten. */
    DNG_FLOOR_FLAG_TALK_MONSTER = 0x40,       /**< The floor's talk monster has been spoken to. */
    DNG_FLOOR_FLAG_SPHEDA_CLEAR = 0x80,       /**< The floor's spheda challenge is cleared. */
    DNG_FLOOR_FLAG_GEOSTONE_FOUND = 0x100,    /**< The floor's geostone is found. */
    DNG_FLOOR_FLAG_GEOSTONE_READ = 0x200,     /**< The parts of the floor's geostone are handed out. */
    DNG_FLOOR_FLAG_SEAL_CLEAR = 0x400         /**< The floor's seal no longer applies. */
};

/**
 *
 * Record that the save data keeps for one floor of a dungeon.
 *
 */
struct DNG_FLOOR_SAVE {
    s32 unk_0;
    s32 fast_destroy_time; /**< Best clear time, in 1/60 seconds; 0 while the floor has none. */
    u16 unk_8;
    u8  unk_a;
    u8  unk_b;
    u16 spheda_clear; /**< Non-zero once the floor's spheda challenge is cleared. */
    u16 flag;         /**< Progress on the floor, a set of DNG_FLOOR_FLAG. */
    u16 kill_count;   /**< Monsters defeated on the floor. */
    u16 visit_count;  /**< Times the floor has been entered. */
};

STATIC_ASSERT(sizeof(DNG_FLOOR_SAVE) == 0x14);

/**
 *
 * Dungeon part of the save data, holding where the player is in each dungeon
 * and a record for every floor.
 *
 */
class CSaveDataDungeon {
public:
    s32            stage_id;                           /**< Dungeon that the player is in. */
    s32            floor_id[SAVE_DUNGEON_NUM];         /**< Floor that the player is on, per dungeon. */
    s32            prev_floor_id[SAVE_DUNGEON_NUM];    /**< Floor that the player was on before, per dungeon; -1 for none. */
    DNG_FLOOR_SAVE floor_info[SAVE_DUNGEON_FLOOR_NUM]; /**< Records of every floor, dungeon by dungeon. */

    /**
     *
     * Gives the record of a floor of a dungeon, or null for a dungeon or floor out of range.
     *
     * @mangled GetFloorInfoPtr__16CSaveDataDungeonFii
     * @address 0x2FC2A0
     * @size 0x120
     */
    DNG_FLOOR_SAVE *GetFloorInfoPtr(int dungeon, int floor);

    /**
     *
     * Clears every floor record, opens floors 0 and 1 of each dungeon, and puts
     * the player on floor 1 of each dungeon, in the first dungeon.
     *
     * @mangled Initialize__16CSaveDataDungeonFv
     * @address 0x2FC3C0
     * @size 0xE0
     */
    void Initialize();

    /**
     *
     * Moves the player to a floor of the current dungeon, remembering the floor left.
     *
     * @mangled SetFloorID__16CSaveDataDungeonFi
     * @address 0x2FC4A0
     * @size 0x50
     */
    void SetFloorID(int floor);
};

STATIC_ASSERT(sizeof(CSaveDataDungeon) == 0xCE4);
