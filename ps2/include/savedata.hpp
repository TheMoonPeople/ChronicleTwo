#pragma once

#include "common.h"

#include "editdata.hpp"
#include "map.hpp"
#include "menusystemdata.hpp"
#include "quest.hpp"
#include "savedatadungeon.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the game's save record (story flags, time of day, map position,
 * Georama layouts, options, the player's party and inventory, the fishing
 * tournament schedule) and the separate record of the bonus sub-games
 * (Spheda scores and the Finny Frenzy fish roster).
 */

/**
 * Number of one-bit story flags the save data holds.
 */
#define SAVE_BIT_FLAG_MAX 0x800

/**
 * Number of sixteen-bit story counters the save data holds.
 */
#define SAVE_SHORT_FLAG_MAX 0x80

/**
 * Number of maps that keep a set of map flags in the save data.
 */
#define SAVE_MAP_FLAG_MAX 0x100

/**
 * Number of Georama parts whose held count the save data keeps.
 */
#define SAVE_BUILD_PARTS_MAX 0x100

/**
 * Largest number of copies of one Georama part the player can hold.
 */
#define SAVE_BUILD_PARTS_NUM_MAX 9999

/**
 * Number of Georama towns whose layout the save data keeps.
 */
#define SAVE_EDIT_DATA_MAX 5

/**
 * Number of days, counted from the start of a tournament cycle, during
 * which a fishing tournament runs.
 */
#define SAVE_TOUR_DAYS 3

/**
 * Number of days after which the fishing tournament cycle repeats.
 */
#define SAVE_TOUR_CYCLE 10

/**
 * Largest value of the tournament's progress count.
 */
#define SAVE_TOUR_COUNT_MAX 100

/**
 * Number of entries in the Spheda score table.
 */
#define SPHIDA_PLAYER_MAX 64

/**
 * Number of holes in a round of Spheda.
 */
#define SPHIDA_HOLE_MAX 9

/**
 * Number of fish places in the Finny Frenzy roster.
 */
#define GYORACE_DATA_MAX 64

/**
 *
 * Holds the game options set in the option menu.
 *
 */
struct SV_CONFIG_OPTION {
    s32 cursor_save;   /**< Zero while menus remember their cursor position. */
    s32 vibration;     /**< Zero while controller vibration is enabled. */
    s32 message_speed; /**< One to show messages at once instead of letter by letter. */
    s32 sound_mode;    /**< Zero for stereo sound, otherwise mono. */
    s32 fast_time;     /**< Non-zero to make the time of day pass one and a half times as fast. */
    s32 map;           /**< Size of the dungeon mini-map: zero hides it, one is small, two is large. */
    u8  unk_18[4];
    s32 enemy_hp;      /**< How the dungeon shows the enemies' life gauges. */
    s32 damage_off;    /**< Non-zero to hide the damage numbers in battle. */
    u8  unk_24[4];
    s32 monster_name;  /**< How the dungeon shows the enemies' names. */
    s32 anger_counter; /**< How the dungeon shows the enemies' anger counters. */
    s32 dof_off;       /**< Non-zero to turn off the depth of field blur. */
    u8  caption_off;   /**< Non-zero to hide the event captions. */
    u8  unk_35;
    s8  eye_reverse;   /**< Zero to invert the vertical axis of the first-person camera. */
    s8  unk_37;
    u8  unk_38[8];
};

STATIC_ASSERT(sizeof(SV_CONFIG_OPTION) == 0x40);

/**
 *
 * Holds the schedule of the recurring fishing tournament.
 *
 */
struct SAVE_TOUR_INFO {
    s32 start_day;  /**< Day, counted from base_day, on which the current tournament started. */
    s32 finish_day; /**< Day, counted from base_day, on which the last tournament ended. */
    s16 now_event;  /**< One while a tournament is running. */
    s8  type;       /**< Kind of the current tournament. */
    s8  count;      /**< Progress count of the current tournament, from zero to SAVE_TOUR_COUNT_MAX. */
    s32 base_day;   /**< Day on which the tournament cycle began, or -1 before tournaments are available. */
    u8  unk_10[0xC];
};

STATIC_ASSERT(sizeof(SAVE_TOUR_INFO) == 0x1C);

/**
 *
 * Holds the whole of one game's save data.
 *
 */
class CSaveData {
public:
    u32              bit_flag[SAVE_BIT_FLAG_MAX / 32];       /**< One-bit story flags, 32 to a word. */
    s16              short_flag[SAVE_SHORT_FLAG_MAX];        /**< Sixteen-bit story counters. */
    CMapFlagData     map_flag[SAVE_MAP_FLAG_MAX];            /**< Flags of each map, such as its opened treasure boxes. */
    u8               unk_1200[0x800];
    s64              play_time;                              /**< Play time, in frames. */
    s32              game_progress;                          /**< Point the story has reached, from which the chapter follows. */
    s32              time_stop;                              /**< Non-zero to keep the time of day from passing in town. */
    float            now_time;                               /**< Time of day, in hours. */
    s32              day;                                    /**< Number of days that have passed. */
    s16              map_no;                                 /**< Main map the player is on. */
    s16              sub_map_no;                             /**< Interior the player is in, or -1 for none. */
    s16              prev_map_no;                            /**< Main map the player was on before the last map change. */
    s16              prev_sub_map_no;                        /**< Interior the player was in before the last interior change. */
    s32              area_no;                                /**< Area of the last main map that belongs to one. */
    s16              build_parts_num[SAVE_BUILD_PARTS_MAX];  /**< Number of copies of each Georama part the player holds. */
    CEditData        edit_data[SAVE_EDIT_DATA_MAX];          /**< Georama layout of each town. */
    SV_CONFIG_OPTION config;                                 /**< Game options. */
    CSaveDataDungeon save_dungeon;                           /**< Progress through the dungeons. */
    u8               unk_1D298[8];
    CUserDataManager user_data;                              /**< The party, the inventory and the other player data. */
    CQuestData       quest_data;                             /**< State of the side quests. */
    CMonsterBook     monster_book;                           /**< Monster encyclopedia with kill counts. */
    CMenuSystemData  menu_system_data;                       /**< State kept for the menus. */
    u8               bit_ctrl;                               /**< Control bits set and cleared by the scripts and by map changes. */
    u8               unk_643C9;
    u8               unk_643CA[6];
    SAVE_TOUR_INFO   tour;                                   /**< Schedule of the fishing tournament. */
    u8               unk_643EC[0x1544];

    /**
     *
     * Sets every part of the save data to the state of a new game.
     *
     * @mangled Initialize__9CSaveDataFv
     * @address 0x2FB2A0
     * @size 0x1C0
     */
    void Initialize();

    /**
     *
     * Returns whether a number names one of the one-bit story flags.
     *
     * @mangled CheckBitFlagNo__9CSaveDataFi
     * @address 0x2FB460
     * @size 0x20
     */
    int CheckBitFlagNo(int no);

    /**
     *
     * Sets or clears a one-bit story flag and returns whether it was set before.
     *
     * @mangled SetBitFlag__9CSaveDataFii
     * @address 0x2FB480
     * @size 0xB0
     */
    int SetBitFlag(int no, int on);

    /**
     *
     * Returns whether a one-bit story flag is set, or false for a number out of range.
     *
     * @mangled GetBitFlag__9CSaveDataFi
     * @address 0x2FB530
     * @size 0x80
     */
    int GetBitFlag(int no);

    /**
     *
     * Sets a sixteen-bit story counter and returns its previous value.
     *
     * @mangled SetShortFlag__9CSaveDataFis
     * @address 0x2FB5B0
     * @size 0x40
     */
    s16 SetShortFlag(int no, s16 value);

    /**
     *
     * Returns a sixteen-bit story counter, or zero for a number out of range.
     *
     * @mangled GetShortFlag__9CSaveDataFi
     * @address 0x2FB5F0
     * @size 0x40
     */
    s16 GetShortFlag(int no);

    /**
     *
     * Sets the number of copies of a Georama part the player holds.
     *
     * @mangled SetBuildPartsNum__9CSaveDataFii
     * @address 0x2FB630
     * @size 0x60
     */
    void SetBuildPartsNum(int parts_no, int num);

    /**
     *
     * Returns the number of copies of a Georama part the player holds.
     *
     * @mangled GetBuildPartsNum__9CSaveDataFi
     * @address 0x2FB690
     * @size 0x40
     */
    s16 GetBuildPartsNum(int parts_no);

    /**
     *
     * Adds to the number of copies of a Georama part the player holds and returns the new number.
     *
     * @mangled AddBuildPartsNum__9CSaveDataFii
     * @address 0x2FB6D0
     * @size 0x70
     */
    s16 AddBuildPartsNum(int parts_no, int add);

    /**
     *
     * Returns the Georama layout of a town, or NULL for a number out of range.
     *
     * @mangled GetEditData__9CSaveDataFi
     * @address 0x2FB740
     * @size 0x40
     */
    CEditData *GetEditData(int town_no);

    /**
     *
     * Counts the copies of a Georama part placed in all the towns.
     *
     * @mangled GetPlaceEditPartsNum__9CSaveDataFi
     * @address 0x2FB780
     * @size 0x80
     */
    int GetPlaceEditPartsNum(int parts_id);

    /**
     *
     * Returns the flags of a map, or NULL for a number out of range.
     *
     * @mangled GetMapFlag__9CSaveDataFi
     * @address 0x2FB800
     * @size 0x30
     */
    CMapFlagData *GetMapFlag(int map_no);

    /**
     *
     * Clears all the control bits.
     *
     * @mangled InitBitCtrl__9CSaveDataFv
     * @address 0x2FB830
     * @size 0x10
     */
    void InitBitCtrl();

    /**
     *
     * Sets control bits and returns the bits as they were before.
     *
     * @mangled SetBitCtrl__9CSaveDataFi
     * @address 0x2FB840
     * @size 0x40
     */
    u8 SetBitCtrl(int bits);

    /**
     *
     * Clears control bits.
     *
     * @mangled ResetBitCtrl__9CSaveDataFi
     * @address 0x2FB880
     * @size 0x30
     */
    void ResetBitCtrl(int bits);

    /**
     *
     * Returns the control bits.
     *
     * @mangled GetBitCtrl__9CSaveDataFv
     * @address 0x2FB8B0
     * @size 0x10
     */
    u8 GetBitCtrl();

    /**
     *
     * Gives the player copies of an item.
     *
     * @mangled GetItem__9CSaveDataFii
     * @address 0x2FB8C0
     * @size 0x10
     */
    int GetItem(int item_no, int num);

    /**
     *
     * Starts the fishing tournament cycle on a given day with a tournament of a given kind.
     *
     * @mangled ForceBootTour__9CSaveDataFii
     * @address 0x2FB8D0
     * @size 0x60
     */
    void ForceBootTour(int day, int type);

    /**
     *
     * Returns the number of days from the start of the tournament cycle to a day, or -1 before the cycle starts.
     *
     * @mangled CheckEventDay__9CSaveDataFi
     * @address 0x2FB930
     * @size 0x30
     */
    int CheckEventDay(int day);

    /**
     *
     * Starts or ends the fishing tournament as the given day requires.
     *
     * @mangled CheckTourBoot__9CSaveDataFi
     * @address 0x2FB960
     * @size 0x220
     */
    void CheckTourBoot(int day);

    /**
     *
     * Returns one while a fishing tournament is running.
     *
     * @mangled CheckNowTourEvent__9CSaveDataFv
     * @address 0x2FBB80
     * @size 0x10
     */
    s16 CheckNowTourEvent();

    /**
     *
     * Returns the kind of the current fishing tournament.
     *
     * @mangled CheckNowTourType__9CSaveDataFv
     * @address 0x2FBB90
     * @size 0x10
     */
    s8 CheckNowTourType();

    /**
     *
     * Adds to the progress count of the current tournament and returns the new count.
     *
     * @mangled AddTourCountEtc__9CSaveDataFi
     * @address 0x2FBBA0
     * @size 0x70
     */
    s8 AddTourCountEtc(int add);

    /**
     *
     * Returns the progress count of the current tournament.
     *
     * @mangled GetTourCountEtc__9CSaveDataFv
     * @address 0x2FBC10
     * @size 0x10
     */
    s8 GetTourCountEtc();

    /**
     *
     * Ends the current fishing tournament on the current day.
     *
     * @mangled FinishTour__9CSaveDataFv
     * @address 0x2FBC20
     * @size 0x40
     */
    void FinishTour();

    SV_CONFIG_OPTION *GetConfig() {
        return &config;
    }
};

STATIC_ASSERT(sizeof(CSaveData) == 0x65930);

/**
 *
 * Holds one entry of the Spheda score table.
 *
 */
struct SPHIDA_PLAYER_DATA {
    char name[0x14];                     /**< Name of the player, or an empty string for an unused entry. */
    u8   unk_14[4];
    s32  password_key;                   /**< Random number that goes into the entry's password. */
    u8   unk_1C[4];
    s32  total_score;                    /**< Total score of the round, by which the table is ordered. */
    u8   hole_score[SPHIDA_HOLE_MAX];    /**< Score of each hole. */
    u8   unk_2D[0xB];
    s32  unk_38;
    u8   unk_3C[0x14];
};

STATIC_ASSERT(sizeof(SPHIDA_PLAYER_DATA) == 0x50);

/**
 *
 * Holds the Spheda score table and the round being played.
 *
 */
class CSphidaData {
public:
    u8                 unk_0[0x48];
    SPHIDA_PLAYER_DATA player[SPHIDA_PLAYER_MAX]; /**< Score table, best first. */
    u16                hole_score[SPHIDA_HOLE_MAX]; /**< Score of each hole of the round being played. */
    u8                 unk_145A[0x1E];
    s16                now_hole;                  /**< Hole being played. */
    u8                 unk_147A[2];
    char               player_name[0x1C];         /**< Name of the player of the round being played. */
    u8                 unk_1498[0x3B0];

    /**
     *
     * Clears the score table and the round.
     *
     */
    CSphidaData() {
        Initialize();
    }

    /**
     *
     * Clears the score table and the round.
     *
     * @mangled Initialize__11CSphidaDataFv
     * @address 0x2FBC60
     * @size 0x10
     */
    void Initialize();

    /**
     *
     * Sets the hole being played.
     *
     * @mangled SetHorl__11CSphidaDataFi
     * @address 0x2FBC70
     * @size 0x10
     */
    void SetHorl(int hole);

    /**
     *
     * Sets the score of a hole of the round, or of the hole being played for -1.
     *
     * @mangled SetHorlScore__11CSphidaDataFii
     * @address 0x2FBC80
     * @size 0x50
     */
    void SetHorlScore(int score, int hole);

    /**
     *
     * Returns the hole being played.
     *
     * @mangled GetNowHorl__11CSphidaDataFv
     * @address 0x2FBCD0
     * @size 0x10
     */
    s16 GetNowHorl();

    /**
     *
     * Returns the score of a hole of the round, or the round's total for -1.
     *
     * @mangled GetHorlScore__11CSphidaDataFi
     * @address 0x2FBCE0
     * @size 0xD0
     */
    int GetHorlScore(int hole);

    /**
     *
     * Removes an entry from the score table, moving the entries below it up.
     *
     * @mangled ClearPlayerScore__11CSphidaDataFi
     * @address 0x2FBDB0
     * @size 0xC0
     */
    void ClearPlayerScore(int no);

    /**
     *
     * Enters the round into the score table and returns its place, or 100 when it does not rank.
     *
     * @mangled EnterScore__11CSphidaDataFv
     * @address 0x2FBE70
     * @size 0x1A0
     */
    int EnterScore();

    /**
     *
     * Returns an entry of the score table, or NULL for a number out of range.
     *
     * @mangled GetPlayerData__11CSphidaDataFi
     * @address 0x2FC010
     * @size 0x40
     */
    SPHIDA_PLAYER_DATA *GetPlayerData(int no);

    /**
     *
     * Clears the round being played.
     *
     * @mangled InitPlay__11CSphidaDataFv
     * @address 0x2FC050
     * @size 0x50
     */
    void InitPlay();
};

STATIC_ASSERT(sizeof(CSphidaData) == 0x1848);

/**
 *
 * Holds one fish of the Finny Frenzy roster.
 *
 */
struct GYORACE_DATA {
    CGameDataUsed fish;  /**< The fish, as an item. */
    u8            unk_6C[0x34];

    /**
     *
     * Returns whether the place holds a fish.
     *
     * @mangled IsUsed__12GYORACE_DATAFv
     * @address 0x2FC0A0
     * @size 0x10
     */
    int IsUsed();

    /**
     *
     * Empties the place.
     *
     * @mangled Init__12GYORACE_DATAFv
     * @address 0x2FC0B0
     * @size 0x10
     */
    void Init();
};

STATIC_ASSERT(sizeof(GYORACE_DATA) == 0xA0);

/**
 *
 * Holds the Finny Frenzy fish roster.
 *
 */
class CGyoRaceData {
public:
    u8           unk_0[0x28];
    GYORACE_DATA data[GYORACE_DATA_MAX]; /**< Places of the roster. */
    u8           unk_2828[0x400];

    /**
     *
     * Empties the roster.
     *
     */
    CGyoRaceData() {
        Initialize();
    }

    /**
     *
     * Empties the roster.
     *
     * @mangled Initialize__12CGyoRaceDataFv
     * @address 0x2FC0C0
     * @size 0x10
     */
    void Initialize();

    /**
     *
     * Returns the number of the first empty place, or -1 when the roster is full.
     *
     * @mangled SearchSpace__12CGyoRaceDataFv
     * @address 0x2FC0D0
     * @size 0x40
     */
    int SearchSpace();

    /**
     *
     * Returns the first empty place and stores its number, or returns NULL when the roster is full.
     *
     * @mangled SearchSpaceData__12CGyoRaceDataFPi
     * @address 0x2FC110
     * @size 0x60
     */
    GYORACE_DATA *SearchSpaceData(int *no);

    /**
     *
     * Returns a place of the roster, or NULL for a number out of range.
     *
     * @mangled GetData__12CGyoRaceDataFi
     * @address 0x2FC170
     * @size 0x40
     */
    GYORACE_DATA *GetData(int no);
};

STATIC_ASSERT(sizeof(CGyoRaceData) == 0x2C28);

/**
 *
 * Holds the save data of the bonus sub-games, kept apart from the game's save data.
 *
 */
class CSubGameData {
public:
    u8           unk_0[8];
    u32          play_enable; /**< One bit for each sub-game the player has unlocked. */
    u8           unk_C[0xF4];
    CSphidaData  sphida;      /**< Spheda scores. */
    CGyoRaceData gyorace;     /**< Finny Frenzy fish roster. */
    u8           unk_4570[0xF00];

    /**
     *
     * Clears all the sub-game data.
     *
     * @mangled __ct__12CSubGameDataFv
     * @address 0x2FC1B0
     * @size 0x80
     */
    CSubGameData();

    /**
     *
     * Clears all the sub-game data.
     *
     * @mangled Initialize__12CSubGameDataFv
     * @address 0x2FC230
     * @size 0x10
     */
    void Initialize();

    /**
     *
     * Marks sub-games as unlocked or locked.
     *
     * @mangled PlayEnable__12CSubGameDataFii
     * @address 0x2FC240
     * @size 0x40
     */
    void PlayEnable(int bits, int enable);

    /**
     *
     * Returns the Spheda scores.
     *
     * @mangled GetSphidaData__12CSubGameDataFv
     * @address 0x2FC280
     * @size 0x10
     */
    CSphidaData *GetSphidaData();

    /**
     *
     * Returns the Finny Frenzy fish roster.
     *
     * @mangled GetGyoRaceData__12CSubGameDataFv
     * @address 0x2FC290
     * @size 0x10
     */
    CGyoRaceData *GetGyoRaceData();
};

STATIC_ASSERT(sizeof(CSubGameData) == 0x5470);

/**
 *
 * Sets the game options to their defaults.
 *
 * @mangled InitSV_CONFIG_OPTION__FP16SV_CONFIG_OPTION
 * @address 0x2FB260
 * @size 0x40
 */
void InitSV_CONFIG_OPTION(SV_CONFIG_OPTION *option);
