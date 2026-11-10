#pragma once

#include "common.h"

#include "gamedata.hpp"

/**
 * @file
 * Declares the player's saved progress: every item owned, the two party characters with their
 * equipment, the ridepod, the fish in the aquarium, the monsters Monica can transform into, the
 * townsfolk who have joined the party and the fishing records, together with the battle-time view
 * of the character being played.
 */

/**
 *
 * Characters the user data keeps a status for, as the chara arguments of CUserDataManager take them.
 *
 */
enum USER_CHARA {
    USER_CHARA_MAX = 0,     /**< Max. */
    USER_CHARA_MONICA = 1,  /**< Monica. */
    USER_CHARA_ROBO = 2,    /**< The ridepod. */
    USER_CHARA_MONSTER = 3, /**< The monster Monica has transformed into. */
    USER_CHARA_NUM = 4,     /**< Number of playable characters. */
};

/**
 *
 * Kinds of status a CBattleCharaInfo reads, as its chara_type holds them.
 *
 */
enum BATTLE_CHARA_TYPE {
    BATTLE_CHARA_HUMAN = 0,   /**< Max or Monica, whose data is a CHARA_DATA. */
    BATTLE_CHARA_ROBO = 1,    /**< The ridepod, whose data is a ROBO_DATA. */
    BATTLE_CHARA_MONSTER = 2, /**< A monster transformation, whose data is a MOS_CHANGE_PARAM. */
};

/**
 *
 * Bits of a character's status attribute, as CHARA_DATA::status_attr holds them.
 *
 */
enum CHARA_STATUS_ATTR {
    CHARA_STATUS_POISON = 0x01, /**< Loses a little health every 100 steps while above 1. */
    CHARA_STATUS_SLOW = 0x02,   /**< Timed condition counted down by CHARA_DATA::status_time[1]. */
    CHARA_STATUS_CURSE = 0x04,  /**< Cursed. */
    CHARA_STATUS_STOP = 0x08,   /**< Stopped: a timed condition that blocks changing character. */
    CHARA_STATUS_POWER = 0x10,  /**< Timed boost that raises attack by half and wards off the first two bits. */
    CHARA_STATUS_STONE = 0x20,  /**< Petrified: a timed condition that blocks changing character. */
    CHARA_STATUS_DRY = 0x40,    /**< Thirsty. */
    CHARA_STATUS_ALL = 0x7F,    /**< Every status bit. */
};

/**
 *
 * How CUserDataManager::SetCharaStatusAttirbute applies its status attribute bits.
 *
 */
enum CHARA_STATUS_ATTR_MODE {
    CHARA_STATUS_ATTR_MODE_ADD = 0,   /**< Adds the bits; a power boost wards off and cures poison and slow. */
    CHARA_STATUS_ATTR_MODE_CLEAR = 1, /**< Clears the bits. */
};

/**
 *
 * Ways CBattleCharaInfo::AddHp_Rate changes health by a rate.
 *
 */
enum HP_RATE_KIND {
    HP_RATE_OF_MAX = 0,          /**< By a fraction of the health capacity. */
    HP_RATE_OF_NOW = 1,          /**< By a fraction of the current health. */
    HP_RATE_OF_MAX_KEEP_ONE = 2, /**< By a fraction of the health capacity, leaving at least 1. */
    HP_RATE_OF_NOW_KEEP_ONE = 3, /**< By a fraction of the current health, leaving at least 1. */
};

/**
 *
 * Bits CUserDataManager::CheckEnableCharaChange reports about changing to a character.
 *
 */
enum CHARA_CHANGE_REASON {
    CHARA_CHANGE_REASON_ALIVE = 0x1,         /**< The character has health left. */
    CHARA_CHANGE_REASON_FLOOR_LIMITED = 0x2, /**< The dungeon floor bars Max or Monica. */
    CHARA_CHANGE_REASON_STATUS_OK = 0x4,     /**< No condition blocks changing to the character. */
};

/**
 *
 * Bits of the quick-change state CUserDataManager::CheckQuickChange gives.
 *
 */
enum QUICK_CHANGE_STATE {
    QUICK_CHANGE_STATE_IN_PARTY = 0x1, /**< The character is in the party. */
    QUICK_CHANGE_STATE_ENABLED = 0x2,  /**< The player can change to the character now. */
};

/**
 *
 * Extents of the inventory measured by GetNowBagMax and searched by CUserDataManager::SearchItemOnItemBrd.
 *
 */
enum ITEM_BOARD {
    ITEM_BOARD_MAIN = 0, /**< The item board alone. */
    ITEM_BOARD_ALL = 1,  /**< The item board followed by its overflow places. */
};

/**
 *
 * Forms of an owned item's name that CGameDataUsed::GetName gives.
 *
 */
enum ITEM_NAME_TYPE {
    ITEM_NAME_TYPE_PLAIN = 0,  /**< The name alone. */
    ITEM_NAME_TYPE_LEVEL = 1,  /**< The name followed by the level of a weapon or attachment. */
    ITEM_NAME_TYPE_QUOTED = 2, /**< The name and level inside the language's quotation marks. */
};

/**
 *
 * Party status bits of a townsperson, as PARTY_CHARA_INFO::status holds them.
 *
 */
enum PARTY_CHARA_STATUS {
    PARTY_CHARA_STATUS_IN_PARTY = 0x1, /**< The townsperson is in the party. */
    PARTY_CHARA_STATUS_JOINED = 0x2,   /**< The townsperson has joined and waits outside the party. */
    PARTY_CHARA_STATUS_IN_HOUSE = 0x4, /**< The townsperson lives in a house of the town. */
    PARTY_CHARA_STATUS_JOIN = 0x80,    /**< Request to CUserDataManager::SetPartyCharaStatus to make the townsperson join. */
};

/**
 *
 * Bits CFishingRecord::CheckRecordFish gives for a catch.
 *
 */
enum FISH_RECORD_UPDATE {
    FISH_RECORD_UPDATE_SIZE = 0x1,   /**< The catch set a new size record. */
    FISH_RECORD_UPDATE_WEIGHT = 0x2, /**< The catch set a new weight record. */
};

/**
 *
 * Where CUserDataManager::GetFishInAquarium put a caught fish.
 *
 */
enum FISH_STORE_RESULT {
    FISH_STORE_KEPT = 0,     /**< In the inventory or the first aquarium tank. */
    FISH_STORE_OVERFLOW = 1, /**< In an overflow place of the item board. */
    FISH_STORE_NO_ROOM = 2,  /**< Nowhere; there was no room. */
};

/**
 *
 * Places SetEnvUserDataMan prepares the character changes for.
 *
 */
enum USER_DATA_ENV {
    USER_DATA_ENV_TOWN = 0,    /**< The town, where the ridepod and monster forms cannot be changed to. */
    USER_DATA_ENV_DUNGEON = 1, /**< A dungeon, where the ridepod and monster forms can be changed to. */
};

/**
 *
 * Effects of a dungeon random circle, as GetRandomCircleTrapID picks them.
 *
 */
enum RANDOM_CIRCLE {
    RANDOM_CIRCLE_NONE_ROBO = -2,    /**< No effect, for the ridepod. */
    RANDOM_CIRCLE_NONE_MONSTER = -1, /**< No effect, for a monster form. */
    RANDOM_CIRCLE_NONE = 0,          /**< No effect. */
    RANDOM_CIRCLE_ABS_BONUS = 1,     /**< Gives a tenth of both weapons' absorption capacity. */
    RANDOM_CIRCLE_HEAL = 2,          /**< Restores health and cures every condition but the power boost. */
    RANDOM_CIRCLE_REPAIR = 3,        /**< Repairs both weapons of Max and Monica. */
    RANDOM_CIRCLE_UNK_4 = 4,
    RANDOM_CIRCLE_POISON = 5,           /**< Poisons the character. */
    RANDOM_CIRCLE_HALVE_HP = 6,         /**< Halves the character's health. */
    RANDOM_CIRCLE_WEAPON_DAMAGE = 7,    /**< Picks one of the four weapon durability effects that follow. */
    RANDOM_CIRCLE_MAX_SUB_WHP = 8,      /**< Halves the durability of Max's second weapon. */
    RANDOM_CIRCLE_MAX_MAIN_WHP = 9,     /**< Halves the durability of Max's first weapon. */
    RANDOM_CIRCLE_MONICA_SUB_WHP = 10,  /**< Halves the durability of Monica's second weapon. */
    RANDOM_CIRCLE_MONICA_MAIN_WHP = 11, /**< Halves the durability of Monica's first weapon. */
    RANDOM_CIRCLE_UNK_12 = 12,
};

/**
 *
 * Sex of a fish, as BREEDFISH_USED::sex holds it.
 *
 */
enum BREEDFISH_SEX {
    BREEDFISH_SEX_MALE = 0,   /**< Male. */
    BREEDFISH_SEX_FEMALE = 1, /**< Female. */
};

/**
 *
 * Flags recording special properties of a fish in its owned-item data.
 *
 */
enum BREEDFISH_FLAGS {
    BREEDFISH_FLAG_RAISED = 0x1,              /**< Marks a fish fed or bred in the aquarium; its weight is shown and the fishing tournament refuses it. */
    BREEDFISH_FLAG_ELECTRIC = 0x2,            /**< Marks an electric fish, which is never rubbish. */
    BREEDFISH_FLAG_WON_CLASS_0 = 0x04,        /**< Marks a fish that has won the first race class. */
    BREEDFISH_FLAG_WON_CLASS_1 = 0x08,        /**< Marks a fish that has won the second race class. */
    BREEDFISH_FLAG_WON_CLASS_2 = 0x10,        /**< Marks a fish that has won the third race class. */
    BREEDFISH_FLAG_WON_CLASS_3 = 0x20,        /**< Marks a fish that has won the fourth race class. */
    BREEDFISH_FLAG_FEED_LIMIT_REACHED = 0x80, /**< Marks a fish that has used up its feedings and no longer eats. */
};

/**
 *
 * What an attachment made by spectrumising came from, as ATTACH_USED::spectol_type holds it.
 *
 */
enum SPECTOL_TYPE {
    SPECTOL_TYPE_NONE = 0,       /**< An ordinary attachment. */
    SPECTOL_TYPE_WEAPON = 1,     /**< A weapon of level 5 or more, whose parameters it keeps. */
    SPECTOL_TYPE_ATTACH = 2,     /**< Attachments, whose parameters it multiplies by their count. */
    SPECTOL_TYPE_WEAPON_LOW = 3, /**< A weapon below level 5, which gives one random parameter. */
    SPECTOL_TYPE_ITEM = 4,       /**< An item or a fish. */
};

/**
 *
 * Equipment slots of CHARA_DATA::equip.
 *
 */
enum CHARA_EQUIP_SLOT {
    CHARA_EQUIP_MELEE = 0,   /**< Max's wrench, hammer or fishing rod, Monica's sword. */
    CHARA_EQUIP_SUB = 1,     /**< Max's gun, Monica's armband. */
    CHARA_EQUIP_HEAD = 2,    /**< Max's hat, Monica's hair accessory. */
    CHARA_EQUIP_FEET = 3,    /**< Max's shoes, Monica's boots. */
    CHARA_EQUIP_CLOTHES = 4, /**< The outfit. */
};

/**
 *
 * Status of Max or Monica: health, conditions, active items and equipment.
 *
 */
struct CHARA_DATA {
    COMMON_GAGE   hp;             /**< Health gauge. */
    u16           status_attr;    /**< Conditions, CHARA_STATUS_ATTR bits. */
    u16           defence;        /**< Defence of the character. */
    s16           status_time[4]; /**< Time left of the CHARA_STATUS_POWER, SLOW, STOP and STONE conditions. */
    u8            unk_14[0x17];
    u8            keep_costume_on_equip_change; /**< Keeps the selected costume when equipment changes. */
    CGameDataUsed active_item[3];               /**< Active items. */
    CGameDataUsed equip[5];                     /**< Equipment, by CHARA_EQUIP_SLOT. */
};

STATIC_ASSERT(sizeof(CHARA_DATA) == 0x38C);
PORT_RECORD_ASSERT(sizeof(CHARA_DATA) == 0x38C);

/**
 *
 * Part slots of ROBO_DATA::parts.
 *
 */
enum ROBO_PART_SLOT {
    ROBO_PART_ARM = 0,   /**< The arm, which sets the attack, its sound and its durability. */
    ROBO_PART_BODY = 1,  /**< The body. */
    ROBO_PART_PACK = 2,  /**< The energy pack. */
    ROBO_PART_LEG = 3,   /**< The legs, which set the movement type. */
};

/**
 *
 * Status of the ridepod: name, energy, absorption and fitted parts.
 *
 */
struct ROBO_DATA {
    u8            unk_0[2];
    char          name[0x1A]; /**< Name of the ridepod. */
    s8            voice_unit; /**< Non-zero once the voice unit is fitted. */
    s8            voice_flag; /**< Non-zero while the ridepod's voice is on. */
    u8            unk_1e[2];
    COMMON_GAGE   hp;             /**< Energy gauge. */
    COMMON_GAGE   abs;            /**< Absorption gauge. */
    CGameDataUsed parts[4];       /**< Fitted parts, by ROBO_PART_SLOT. */
    s16           status_time[3]; /**< Time left of the CHARA_STATUS_SLOW, STOP and STONE conditions. */
    u8            unk_1e6[2];
    u16           shield_kit_num; /**< Shield kits used, each adding 4 to the defence. */
    u8            unk_1ea[0x36];

    /**
     *
     * Adds to the energy gauge and gives how full it is.
     *
     * @mangled AddPoint__9ROBO_DATAFf
     * @address 0x19BD50
     * @size 0x30
     */
    float AddPoint(float amount);

    /**
     *
     * Gives the defence of the ridepod.
     *
     * @mangled GetDefenceVol__9ROBO_DATAFv
     * @address 0x19BD80
     * @size 0x14
     */
    int GetDefenceVol();
};

STATIC_ASSERT(sizeof(ROBO_DATA) == 0x220);
PORT_RECORD_ASSERT(sizeof(ROBO_DATA) == 0x220);

/**
 *
 * Base parameters of one monster Monica can transform into.
 *
 */
struct MOS_HENGE_PARAM {
    s16   monster_id; /**< Monster this row belongs to. */
    s16   attack;     /**< Base attack. */
    s16   defence;    /**< Base defence. */
    u8    unk_6[2];
    char *script_name;    /**< Monster script basename used to form its .stb path. */
    char *effect_name[4]; /**< Effect base names loaded for the monster. */
};

STATIC_ASSERT(sizeof(MOS_HENGE_PARAM) == 0x1C);

/**
 *
 * One monster badge: whether Monica can transform into the monster and the monster's status.
 *
 */
class MOS_CHANGE_PARAM {
public:
    s16         no;          /**< Index of the badge. */
    s16         level;       /**< Level, up to 99. */
    s16         class_level; /**< Class the monster has reached, up to 3. */
    s16         progress;    /**< Progress through the monster's family. */
    s16         monster_id;  /**< Monster the badge transforms into. */
    u8          enable;      /**< Non-zero once Monica can use the badge. */
    u8          unk_b;
    COMMON_GAGE hp;  /**< Health gauge. */
    COMMON_GAGE abs; /**< Absorption gauge; the monster levels up when it fills. */
    u8          unk_1c[0x20];
    s16         poison_time; /**< Time left of the 0x1 condition. */
    s16         power_time;  /**< Time left of the CHARA_STATUS_POWER condition. */
    u8          unk_40[0x7C];

    /**
     *
     * Gives the attack of a monster, by default the badge's own, scaled by the badge level.
     *
     * @mangled GetAttackVol__16MOS_CHANGE_PARAMFi
     * @address 0x19BE00
     * @size 0x9C
     */
    int GetAttackVol(int monster_no);

    /**
     *
     * Gives the defence of a monster, by default the badge's own, raised by the badge degree.
     *
     * @mangled GetDefenceVol__16MOS_CHANGE_PARAMFi
     * @address 0x19BEA0
     * @size 0x88
     */
    int GetDefenceVol(int monster_no);

    /**
     *
     * Gives whether the monster's level allows its next class.
     *
     * @mangled CheckClassChange__16MOS_CHANGE_PARAMFv
     * @address 0x19BF30
     * @size 0x4C
     */
    int CheckClassChange();

    /**
     *
     * Gives the degree of the badge, a sixth of its level up to 15.
     *
     * @mangled GetDegreeLevel__16MOS_CHANGE_PARAMFv
     * @address 0x19BF80
     * @size 0x3C
     */
    int GetDegreeLevel();

    /**
     *
     * Levels the monster up when its absorption gauge is full.
     *
     * @mangled LevelUp__16MOS_CHANGE_PARAMFv
     * @address 0x19BFC0
     * @size 0xAC
     */
    int LevelUp();
};

STATIC_ASSERT(sizeof(MOS_CHANGE_PARAM) == 0xBC);
PORT_RECORD_ASSERT(sizeof(MOS_CHANGE_PARAM) == 0xBC);

/**
 *
 * The monster badges Monica has collected.
 *
 */
class CMonsterBox {
public:
    MOS_CHANGE_PARAM monster[64]; /**< Badges, by badge number less one. */

    /**
     *
     * Resets every badge to its starting status.
     *
     * @mangled Initialize__11CMonsterBoxFv
     * @address 0x19C070
     * @size 0xEC
     */
    void Initialize();

    /**
     *
     * Gives a badge by its number from 1, or null.
     *
     * @mangled GetMonsterBajjiData__11CMonsterBoxFi
     * @address 0x19C160
     * @size 0x40
     */
    MOS_CHANGE_PARAM *GetMonsterBajjiData(int no);

    /**
     *
     * Gives the badge of a monster, or null.
     *
     * @mangled GetMonsterBajjiDataByMonsterID__11CMonsterBoxFi
     * @address 0x19C1A0
     * @size 0x38
     */
    MOS_CHANGE_PARAM *GetMonsterBajjiDataByMonsterID(int monster_id);

    /**
     *
     * Lets Monica use a badge.
     *
     * @mangled EnableChange__11CMonsterBoxFi
     * @address 0x19C1E0
     * @size 0x68
     */
    void EnableChange(int no);

    /**
     *
     * Gives whether Monica can use a badge.
     *
     * @mangled IsChange__11CMonsterBoxFi
     * @address 0x19C250
     * @size 0x30
     */
    int IsChange(int no);

    /**
     *
     * Restores the health of every badge's monster.
     *
     * @mangled AllCure__11CMonsterBoxFv
     * @address 0x19C280
     * @size 0x5C
     */
    void AllCure();
};

STATIC_ASSERT(sizeof(CMonsterBox) == 0x2F00);
PORT_RECORD_ASSERT(sizeof(CMonsterBox) == 0x2F00);

/**
 *
 * Tanks of the aquarium, as CFishAquarium::active_tank and its tank arguments number them.
 *
 */
enum AQUARIUM_TANK {
    AQUARIUM_TANK_FIRST = 0,  /**< First tank, held in fish_tank. */
    AQUARIUM_TANK_SECOND = 1, /**< Second tank, held in sub_tank. */
    AQUARIUM_TANK_BREED = 2,  /**< Breeding tank, held in breed_tank. */
};

/**
 *
 * The aquarium: three tanks of fish.
 *
 */
class CFishAquarium {
public:
    u16           active_tank; /**< Aquarium tank currently shown by the menu. */
    s16           unk_2;
    CGameDataUsed fish_tank[6];  /**< First tank. */
    CGameDataUsed sub_tank[4];   /**< Second tank, where fish crowded together tire. */
    CGameDataUsed breed_tank[2]; /**< Breeding tank, which takes a pair of opposite sexes. */
    u8            unk_514[4];
    u64           unk_518;
    s64           last_time; /**< Save data clock at the last refresh. */
    int           last_day;  /**< Day of the last fatigue step. */
    float         last_hour; /**< Hour of the day of the last fatigue step. */

    /**
     *
     * Empties the aquarium.
     *
     */
    CFishAquarium() { Initialize(); }

    /**
     *
     * Empties every tank and clears the clocks.
     *
     * @mangled Initialize__13CFishAquariumFv
     * @address 0x19B680
     * @size 0xC0
     */
    void Initialize();

    /**
     *
     * Gives the first place of a tank, or null.
     *
     * @mangled GetAquariumFishTop__13CFishAquariumFi
     * @address 0x19B740
     * @size 0x38
     */
    CGameDataUsed *GetAquariumFishTop(int tank);

    /**
     *
     * Gives the first empty place of a tank, or -1.
     *
     * @mangled SearchAqua1NotUsed__13CFishAquariumFi
     * @address 0x19B780
     * @size 0x70
     */
    int SearchAqua1NotUsed(int tank);

    /**
     *
     * Puts a fish into a place of a tank.
     *
     * @mangled FishIntoAquarium__13CFishAquariumFiiP13CGameDataUsed
     * @address 0x19B7F0
     * @size 0x13C
     */
    void FishIntoAquarium(int tank, int slot, CGameDataUsed *fish);

    /**
     *
     * Gives how many fish a tank holds.
     *
     * @mangled GetAquariumFishNum__13CFishAquariumFi
     * @address 0x19B930
     * @size 0x74
     */
    int GetAquariumFishNum(int tank);

    /**
     *
     * Gives whether a fish can join the breeding tank, which no fish of its sex is in.
     *
     * @mangled CheckHaigouTankSex__13CFishAquariumFP13CGameDataUsed
     * @address 0x19B9B0
     * @size 0x58
     */
    int CheckHaigouTankSex(CGameDataUsed *fish);

    /**
     *
     * Advances the fish by the time that has passed.
     *
     * @mangled RefreshParam__13CFishAquariumFv
     * @address 0x19BA10
     * @size 0x30C
     */
    void RefreshParam();
};

STATIC_ASSERT(sizeof(CFishAquarium) == 0x530);
PORT_RECORD_ASSERT(sizeof(CFishAquarium) == 0x530);

/**
 *
 * The best catch of one kind of fish.
 *
 */
struct FISH_RECORD {
    float size;        /**< Largest size caught. */
    float prev_size;   /**< Largest size before the current record. */
    float weight;      /**< Heaviest weight caught. */
    float prev_weight; /**< Heaviest weight before the current record. */
    int   num;         /**< Number caught, up to 999999. */
    u8    unk_14[0xC];
};

STATIC_ASSERT(sizeof(FISH_RECORD) == 0x20);
PORT_RECORD_ASSERT(sizeof(FISH_RECORD) == 0x20);

/**
 *
 * The best catches of every kind of fish.
 *
 */
class CFishingRecord {
public:
    u8          unk_0[0x40];
    FISH_RECORD record[24]; /**< Records, in the order of the fish record table. */

    /**
     *
     * Clears every record.
     *
     * @mangled __ct__14CFishingRecordFv
     * @address 0x19C330
     * @size 0x30
     */
    CFishingRecord();

    /**
     *
     * Gives the record of a fish, or null for a fish without one.
     *
     * @mangled GetFishRecord__14CFishingRecordFi
     * @address 0x19C360
     * @size 0x3C
     */
    FISH_RECORD *GetFishRecord(int fish_no);

    /**
     *
     * Counts a catch and keeps it when it beats the record; gives its FISH_RECORD_UPDATE bits.
     *
     * @mangled CheckRecordFish__14CFishingRecordFiff
     * @address 0x19C3A0
     * @size 0xAC
     */
    int CheckRecordFish(int fish_no, float size, float weight);
};

STATIC_ASSERT(sizeof(CFishingRecord) == 0x340);
PORT_RECORD_ASSERT(sizeof(CFishingRecord) == 0x340);

/**
 *
 * One fish entered in the fishing tournament.
 *
 */
struct FISH_TOURNAMENT_ENTRY {
    s16 item_no; /**< Item number of the fish, or 0 for an empty place. */
    s16 size;    /**< Size of the fish, in tenths. */
    s16 weight;  /**< Weight of the fish. */
    s16 unk_6;
};

STATIC_ASSERT(sizeof(FISH_TOURNAMENT_ENTRY) == 0x8);
PORT_RECORD_ASSERT(sizeof(FISH_TOURNAMENT_ENTRY) == 0x8);

/**
 *
 * The fish entered in the fishing tournament and the rank reached.
 *
 */
class CFishingTournament {
public:
    u8                    unk_0[4];
    s16                   rank; /**< Rank reached, 0 to 100. */
    u8                    unk_6[0x1A];
    FISH_TOURNAMENT_ENTRY entry[10]; /**< Fish entered. */

    /**
     *
     * Clears the tournament.
     *
     */
    CFishingTournament() { Initialize(); }

    /**
     *
     * Clears the rank and every entry.
     *
     * @mangled Initialize__18CFishingTournamentFv
     * @address 0x19C450
     * @size 0xC
     */
    void Initialize();

    /**
     *
     * Clears every entry.
     *
     * @mangled ResetRecord__18CFishingTournamentFv
     * @address 0x19C460
     * @size 0x10
     */
    void ResetRecord();

    /**
     *
     * Enters a fish in the first free place.
     *
     * @mangled EntryFish__18CFishingTournamentFiii
     * @address 0x19C470
     * @size 0x48
     */
    int EntryFish(int item_no, int size, int weight);

    /**
     *
     * Gives how many places are still free.
     *
     * @mangled EntryRemain__18CFishingTournamentFv
     * @address 0x19C4C0
     * @size 0x3C
     */
    int EntryRemain();

    /**
     *
     * Gives one entry, or null.
     *
     * @mangled GetRecord__18CFishingTournamentFi
     * @address 0x19C500
     * @size 0x30
     */
    FISH_TOURNAMENT_ENTRY *GetRecord(int index);

    /**
     *
     * Sets the rank, kept between 0 and 100.
     *
     * @mangled SetRank__18CFishingTournamentFi
     * @address 0x19C530
     * @size 0x24
     */
    void SetRank(int rank);

    /**
     *
     * Sorts the entries by weight, heaviest first.
     *
     * @mangled SortRecord__18CFishingTournamentFv
     * @address 0x19C560
     * @size 0xD8
     */
    void SortRecord();

    /**
     *
     * Gives the total weight of the three heaviest fish.
     *
     * @mangled CalcTopWeight__18CFishingTournamentFv
     * @address 0x19C640
     * @size 0x38
     */
    int CalcTopWeight();
};

STATIC_ASSERT(sizeof(CFishingTournament) == 0x70);
PORT_RECORD_ASSERT(sizeof(CFishingTournament) == 0x70);

/**
 *
 * State of one townsperson who can join the party.
 *
 */
struct PARTY_CHARA_INFO {
    s16 chara_no; /**< Number of the townsperson, or -1 for an empty place. */
    u16 status;   /**< Party status, PARTY_CHARA_STATUS bits. */
    s16 point;    /**< Ability points left. */
    u8  unk_6[6];
};

STATIC_ASSERT(sizeof(PARTY_CHARA_INFO) == 0xC);
PORT_RECORD_ASSERT(sizeof(PARTY_CHARA_INFO) == 0xC);

/**
 *
 * One photo taken with the camera: what it shows and where its pixels are.
 *
 */
struct USER_PICTURE_INFO {
    s8    used;       /**< Non-zero when the slot holds a photo. */
    s8    is_new;     /**< Non-zero for a photo not yet looked at in the menu. */
    short map_no;     /**< Map the photo was taken on, or -1. */
    short npc_no;     /**< Townsperson the photo shows, or -1. */
    short monster_no; /**< Monster the photo shows, or -1. */
    short unk_8;
    short neta_id; /**< Idea (under 1000) or scoop (1000 and over) the photo shows, or 0 or less for none. */
    u8    unk_c[8];
    char *image; /**< Byte view of the photo's 64x64 packed 16-bit pixels. */
};

STATIC_ASSERT(sizeof(USER_PICTURE_INFO) == 0x18);

/**
 *
 * Invention card the player has made, in the order made.
 *
 */
struct INVENT_CREATED_ITEM {
    short item_id; /**< Item the invention produced, or 0 or less for an empty slot. */
    short unk_2;
};

STATIC_ASSERT(sizeof(INVENT_CREATED_ITEM) == 0x4);
PORT_RECORD_ASSERT(sizeof(INVENT_CREATED_ITEM) == 0x4);

/**
 *
 * Record of one scoop: whether the player has heard of it and whether a photo or idea of it has been obtained.
 *
 */
struct SCOOP_INFO {
    s8 known;    /**< Non-zero once the scoop's event flag has been seen. */
    s8 obtained; /**< Non-zero once a photo or idea of the scoop has been obtained. */
    u8 unk_2[2];
};

STATIC_ASSERT(sizeof(SCOOP_INFO) == 0x4);
PORT_RECORD_ASSERT(sizeof(SCOOP_INFO) == 0x4);

/**
 *
 * Records of every scoop, indexed by each scoop's SCOOP_DATA::info_no.
 *
 */
class CScoopDataManager {
public:
    SCOOP_INFO info[0x80]; /**< Record of each scoop. */

    /**
     *
     * Returns the record of a scoop, or NULL when the scoop is not in the scoop table.
     *
     * @mangled GetScoopInfo__17CScoopDataManagerFi
     * @address 0x200C50
     * @size 0x60
     */
    SCOOP_INFO *GetScoopInfo(int scoop_id);

    /**
     *
     * Sets whether a scoop is known.
     *
     * @mangled SetViewFlag__17CScoopDataManagerFii
     * @address 0x200CB0
     * @size 0x30
     */
    void SetViewFlag(int scoop_id, int flag);

    /**
     *
     * Marks as known every scoop whose event flag is set, returning how many became known.
     *
     * @mangled KnowScoop__17CScoopDataManagerFv
     * @address 0x200CE0
     * @size 0xC0
     */
    int KnowScoop();

    /**
     *
     * Marks as obtained every scoop the player has a photo or idea of, returning how many were newly obtained.
     *
     * @mangled CheckScoop__17CScoopDataManagerFv
     * @address 0x200DA0
     * @size 0x110
     */
    int CheckScoop();

    /**
     *
     * Returns how many scoops have been obtained, storing the number of scoops in total.
     *
     * @mangled GetScoopTotal__17CScoopDataManagerFPi
     * @address 0x200EB0
     * @size 0x50
     */
    int GetScoopTotal(int *total);
};

/**
 *
 * Invention part of the save data: camera records, ideas, photos, invention cards and scoops.
 *
 */
class CInventUserData {
public:
    int                 shutter_num;         /**< Photos taken, up to 99999. */
    int                 level;               /**< Photographer level, less one. */
    short               neta_id[0x200];      /**< Ideas learnt, packed from the start, 0 for an empty slot. */
    USER_PICTURE_INFO   photo[30];           /**< Photos carried. */
    INVENT_CREATED_ITEM created_item[0x100]; /**< Invention cards made. */
    CScoopDataManager   scoop;               /**< Records of the scoops. */
    u8                  unk_cd8[0x88];
    u_short             photo_work[30][64 * 64]; /**< Packed 16-bit pixels of the carried 64x64 photos. */
    u8                  unk_3cd60[0x100];

    CScoopDataManager *GetScoopData() {
        return &scoop;
    }

    /**
     *
     * Creates the invention records cleared.
     *
     */
    CInventUserData() { Initialize(); }

    /**
     *
     * Clears every record and points each photo at its pixels.
     *
     * @mangled Initialize__15CInventUserDataFv
     * @address 0x200030
     * @size 0xF0
     */
    void Initialize();

    /**
     *
     * Points each photo at its pixels in photo_work.
     *
     * @mangled ResetAddress__15CInventUserDataFv
     * @address 0x200120
     * @size 0xC0
     */
    void ResetAddress();

    /**
     *
     * Clears the new mark of every photo once the menu has shown them.
     *
     * @mangled PhotoCheckEnd__15CInventUserDataFv
     * @address 0x2001E0
     * @size 0x80
     */
    void PhotoCheckEnd();

    /**
     *
     * Returns a photo slot, or NULL for an index out of range.
     *
     * @mangled GetPhotoInfo__15CInventUserDataFi
     * @address 0x200260
     * @size 0x40
     */
    USER_PICTURE_INFO *GetPhotoInfo(int slot);

    /**
     *
     * Returns the pixels of the first photo slot.
     *
     * @mangled GetPhototWorkAdr__15CInventUserDataFv
     * @address 0x2002A0
     * @size 0x10
     */
    char *GetPhototWorkAdr();

    /**
     *
     * Returns the first empty photo slot, storing its index, or NULL when every slot is used.
     *
     * @mangled IsPhotoSpace__15CInventUserDataFPi
     * @address 0x2002B0
     * @size 0x70
     */
    USER_PICTURE_INFO *IsPhotoSpace(int *slot);

    /**
     *
     * Empties a photo slot.
     *
     * @mangled DeletePhotoData__15CInventUserDataFi
     * @address 0x200320
     * @size 0x50
     */
    void DeletePhotoData(int slot);

    /**
     *
     * Returns the slot holding an idea, or -1 when it has not been learnt.
     *
     * @mangled CheckNetaFlag__15CInventUserDataFi
     * @address 0x200370
     * @size 0x40
     */
    int CheckNetaFlag(int neta_id);

    /**
     *
     * Returns the idea in a slot, or 0 for an index out of range.
     *
     * @mangled GetNetaID__15CInventUserDataFi
     * @address 0x2003B0
     * @size 0x40
     */
    int GetNetaID(int slot);

    /**
     *
     * Learns an idea, placing it in the first empty slot.
     *
     * @mangled SetNetaFlag__15CInventUserDataFi
     * @address 0x2003F0
     * @size 0x60
     */
    void SetNetaFlag(int neta_id);

    /**
     *
     * Returns the photo slot showing an idea, or -1 when no photo shows it.
     *
     * @mangled CheckNetaFlagHavePhoto__15CInventUserDataFi
     * @address 0x200450
     * @size 0x80
     */
    int CheckNetaFlagHavePhoto(int neta_id);

    /**
     *
     * Returns how many ideas (as opposed to scoops) the user data manager records as photographed.
     *
     * @mangled CountNeta__15CInventUserDataFv
     * @address 0x2004D0
     * @size 0x70
     */
    int CountNeta();

    /**
     *
     * Returns how many scoops the user data manager records as photographed.
     *
     * @mangled CountScoop__15CInventUserDataFv
     * @address 0x200540
     * @size 0x70
     */
    int CountScoop();

    /**
     *
     * Adds to the number of photos taken, keeping it within 0 to 99999, and returns the new number.
     *
     * @mangled AddShutterNum__15CInventUserDataFi
     * @address 0x2005B0
     * @size 0x40
     */
    int AddShutterNum(int add);

    /**
     *
     * Returns how many photo slots hold a photo.
     *
     * @mangled GetNowHavePictureNum__15CInventUserDataFv
     * @address 0x2005F0
     * @size 0x40
     */
    int GetNowHavePictureNum();

    /**
     *
     * Stores the number of photos held and the number of slots, returning the former.
     *
     * @mangled GetPictureNum__15CInventUserDataFPi
     * @address 0x200630
     * @size 0x40
     */
    int GetPictureNum(int *counts);

    /**
     *
     * Returns the photographer experience: two points per idea and five per scoop photographed.
     *
     * @mangled CalcPhotoExp__15CInventUserDataFv
     * @address 0x200670
     * @size 0x80
     */
    int CalcPhotoExp();

    /**
     *
     * Records a newly photographed idea and recalculates the level, returning non-zero when the level changed.
     *
     * @mangled LevelCheck__15CInventUserDataFP17USER_PICTURE_INFO
     * @address 0x2006F0
     * @size 0x120
     */
    int LevelCheck(USER_PICTURE_INFO *info);

    /**
     *
     * Returns the photographer level, counted from 1.
     *
     * @mangled GetLevel__15CInventUserDataFv
     * @address 0x200810
     * @size 0x10
     */
    int GetLevel();

    /**
     *
     * Records a made invention card in a slot, or in the first empty slot when that one is taken.
     *
     * @mangled SetCreateItemFlag__15CInventUserDataFii
     * @address 0x200820
     * @size 0x70
     */
    void SetCreateItemFlag(int slot, int item_id);

    /**
     *
     * Returns the item of an invention card slot, or 0 for an index out of range.
     *
     * @mangled GetCreateItemID__15CInventUserDataFi
     * @address 0x200890
     * @size 0x40
     */
    int GetCreateItemID(int slot);

    /**
     *
     * Returns the invention card slot of an item, or -1 when it has not been invented.
     *
     * @mangled IsAlreadyCreatedItem__15CInventUserDataFi
     * @address 0x2008D0
     * @size 0x50
     */
    int IsAlreadyCreatedItem(int item_id);

    /**
     *
     * Returns how many invention cards have been made.
     *
     * @mangled GetHatsumeiNum__15CInventUserDataFv
     * @address 0x200920
     * @size 0x40
     */
    int GetHatsumeiNum();
};

STATIC_ASSERT(sizeof(CInventUserData) == 0x3CE60);

/**
 *
 * Everything the player owns and has achieved, held inside the save data.
 *
 */
class CUserDataManager {
public:
    CGameDataUsed      used_data[150]; /**< Inventory; the item board followed by its overflow places. */
    CHARA_DATA         chara_data[2];  /**< Status of Max and Monica. */
    ROBO_DATA          robo_data;      /**< Status of the ridepod. */
    CGameDataUsed      esa[2];         /**< Bait fitted to each of the two fishing rods. */
    CFishAquarium      aquarium;       /**< The aquarium. */
    u8                 unk_4e88[0x28];
    CMonsterBox        monster_box;       /**< Monster badges. */
    PARTY_CHARA_INFO   party_chara[32];   /**< Townsfolk who can join the party, by number less one. */
    CInventUserData    invent_data;       /**< Inventions and photos. */
    u16                party_member;      /**< Characters in the party, bits by USER_CHARA. */
    u16                chara_change;      /**< Characters that can be changed to, bits by USER_CHARA. */
    u8                 chara_change_mask; /**< Characters that changing to is not masked off for. */
    u8                 unk_44d95;
    s16                active_chr_no; /**< Character being played, a USER_CHARA. */
    s16                monster_id;    /**< Monster Monica transforms into. */
    u8                 unk_44d9a[2];
    int                money;          /**< Money, up to 999999. */
    s16                yarikomi_medal; /**< Medals, up to 999. */
    u8                 unk_44da2[0x1E];
    s16                special_item_bought; /**< Number of special shop items bought. */
    u8                 unk_44dc2[6];
    u64                unk_44dc8;
    s16                photo_subject[0x200]; /**< Subject numbers of the photos taken, in order; 0 ends the list. */
    u64                unk_451d0;
    s64                last_refresh_time; /**< Save data clock at the last parameter refresh. */
    int                npc_refresh_day;   /**< Day of the last townsfolk refresh. */
    float              npc_refresh_hour;  /**< Hour of the day of the last townsfolk refresh. */
    CFishingTournament fish_tournament;   /**< The fishing tournament. */
    CFishingRecord     fish_record;       /**< The fishing records. */
    unsigned long      costume_bit;       /**< Costumes collected, one bit each. */
    u8                 unk_455a0[0x200];

    CInventUserData *GetInventUserData() {
        return &invent_data;
    }

    /**
     *
     * Creates the data of a new game.
     *
     * @mangled __ct__16CUserDataManagerFv
     * @address 0x1957C0
     */
    CUserDataManager();

    /**
     *
     * Resets everything to the start of a new game.
     *
     * @mangled Initialize__16CUserDataManagerFv
     * @address 0x19C680
     * @size 0x214
     */
    void Initialize();

    /**
     *
     * Advances the townsfolk, the inventory fish and the aquarium by the time that has passed.
     *
     * @mangled RefreshParam__16CUserDataManagerFv
     * @address 0x19C8A0
     * @size 0xCC
     */
    void RefreshParam();

    /**
     *
     * Gives an inventory place, or null.
     *
     * @mangled GetUsedDataPtr__16CUserDataManagerFi
     * @address 0x19C970
     * @size 0x3C
     */
    CGameDataUsed *GetUsedDataPtr(int index);

    /**
     *
     * Gives the status of Max or Monica, or null.
     *
     * @mangled GetCharaDataPtr__16CUserDataManagerFi
     * @address 0x19C9B0
     * @size 0x2C
     */
    CHARA_DATA *GetCharaDataPtr(int chara);

    /**
     *
     * Gives the health gauge of a character, or null.
     *
     * @mangled GetCharaHpGage__16CUserDataManagerFi
     * @address 0x19C9E0
     * @size 0x50
     */
    COMMON_GAGE *GetCharaHpGage(int chara);

    /**
     *
     * Adds to a character's health and gives the new health.
     *
     * @mangled AddHp__16CUserDataManagerFii
     * @address 0x19CA30
     * @size 0x50
     */
    int AddHp(int chara, int amount);

    /**
     *
     * Gives a character's health.
     *
     * @mangled GetHp__16CUserDataManagerFi
     * @address 0x19CA80
     * @size 0x3C
     */
    float GetHp(int chara);

    /**
     *
     * Adds a fraction of a character's health, leaving at least 1, and gives how full it is.
     *
     * @mangled AddHp_Rate__16CUserDataManagerFif
     * @address 0x19CAC0
     * @size 0x78
     */
    float AddHp_Rate(int chara, float rate);

    /**
     *
     * Gives the durability gauge of a character's weapon, or null.
     *
     * @mangled GetWHpGage__16CUserDataManagerFii
     * @address 0x19CB40
     * @size 0xC8
     */
    COMMON_GAGE *GetWHpGage(int group, int member);

    /**
     *
     * Gives the absorption gauge of a character's weapon, or null.
     *
     * @mangled GetAbsGage__16CUserDataManagerFii
     * @address 0x19CC10
     * @size 0xC8
     */
    COMMON_GAGE *GetAbsGage(int group, int member);

    /**
     *
     * Adds to a weapon's durability and gives the new durability.
     *
     * @mangled AddWhp__16CUserDataManagerFiii
     * @address 0x19CCE0
     * @size 0x58
     */
    int AddWhp(int group, int member, int amount);

    /**
     *
     * Gives a weapon's durability and its full value.
     *
     * @mangled GetWhp__16CUserDataManagerFiiPi
     * @address 0x19CD40
     * @size 0x5C
     */
    int GetWhp(int group, int member, int *max);

    /**
     *
     * Adds to a weapon's absorption and gives the new absorption.
     *
     * @mangled AddAbs__16CUserDataManagerFiii
     * @address 0x19CDA0
     * @size 0x8C
     */
    int AddAbs(int group, int member, int amount);

    /**
     *
     * Gives a weapon's absorption and its full value.
     *
     * @mangled GetAbs__16CUserDataManagerFiiPi
     * @address 0x19CE30
     * @size 0x8C
     */
    int GetAbs(int group, int member, int *max);

    /**
     *
     * Adds a character to the party.
     *
     * @mangled JoinPartyMember__16CUserDataManagerFi
     * @address 0x19CEC0
     * @size 0x4C
     */
    void JoinPartyMember(int chara);

    /**
     *
     * Takes a character out of the party.
     *
     * @mangled LeavePartyMember__16CUserDataManagerFi
     * @address 0x19CF10
     * @size 0x50
     */
    void LeavePartyMember(int chara);

    /**
     *
     * Gives the characters in the party, with the monster when the badge box is owned.
     *
     * @mangled GetNowPartyMember__16CUserDataManagerFv
     * @address 0x19CF60
     * @size 0x44
     */
    int GetNowPartyMember();

    /**
     *
     * Lets the player change to a character.
     *
     * @mangled EnableCharaChange__16CUserDataManagerFi
     * @address 0x19CFB0
     * @size 0x4C
     */
    void EnableCharaChange(int chara);

    /**
     *
     * Stops the player changing to a character.
     *
     * @mangled DisableCharaChange__16CUserDataManagerFi
     * @address 0x19D000
     * @size 0x50
     */
    void DisableCharaChange(int chara);

    /**
     *
     * Gives whether the player can change to a character now, writing CHARA_CHANGE_REASON bits to
     * out.
     *
     * @mangled CheckEnableCharaChange__16CUserDataManagerFiPi
     * @address 0x19D050
     * @size 0x1D4
     */
    int CheckEnableCharaChange(int chara, int *out);

    /**
     *
     * Gives the QUICK_CHANGE_STATE bits of a character.
     *
     * @mangled CheckQuickChange__16CUserDataManagerFiPi
     * @address 0x19D230
     * @size 0x1D4
     */
    int CheckQuickChange(int chara, int *out);

    /**
     *
     * Unmasks changing to a character.
     *
     * @mangled EnableCharaChangeMask__16CUserDataManagerFi
     * @address 0x19D410
     * @size 0x2C
     */
    void EnableCharaChangeMask(int chara);

    /**
     *
     * Masks off changing to a character.
     *
     * @mangled DisableCharaChangeMask__16CUserDataManagerFi
     * @address 0x19D440
     * @size 0x30
     */
    void DisableCharaChangeMask(int chara);

    /**
     *
     * Unmasks changing to every character.
     *
     * @mangled InitCharaChangeMask__16CUserDataManagerFv
     * @address 0x19D470
     * @size 0x14
     */
    void InitCharaChangeMask();

    /**
     *
     * Gives the characters the player can change to now.
     *
     * @mangled GetEnableCharaChangeFlag__16CUserDataManagerFv
     * @address 0x19D490
     * @size 0xD4
     */
    u32 GetEnableCharaChangeFlag();

    /**
     *
     * Gives the status attribute of Max or Monica, or null.
     *
     * @mangled GetCharaStatusAttirbutePtr__16CUserDataManagerFi
     * @address 0x19D570
     * @size 0x58
     */
    u16 *GetCharaStatusAttirbutePtr(int chara);

    /**
     *
     * Sets or clears status attribute bits of a character, by a CHARA_STATUS_ATTR_MODE, and gives
     * the result.
     *
     * @mangled SetCharaStatusAttirbute__16CUserDataManagerFiUii
     * @address 0x19D5D0
     * @size 0xD0
     */
    int SetCharaStatusAttirbute(int chara, unsigned int attr, int mode);

    /**
     *
     * Sets status attribute bits of a character together with how long they last.
     *
     * @mangled SetCharaStatusAttirbuteVol__16CUserDataManagerFiUii
     * @address 0x19D6A0
     * @size 0x124
     */
    int SetCharaStatusAttirbuteVol(int chara, unsigned int attr, int value);

    /**
     *
     * Gives the status attribute of a character, or 0.
     *
     * @mangled GetCharaStatusAttirbute__16CUserDataManagerFi
     * @address 0x19D7D0
     * @size 0x30
     */
    int GetCharaStatusAttirbute(int chara);

    /**
     *
     * Gives a monster badge by its number from 1, or null.
     *
     * @mangled GetMonsterBajjiDataPtr__16CUserDataManagerFi
     * @address 0x19D800
     * @size 0x8
     */
    MOS_CHANGE_PARAM *GetMonsterBajjiDataPtr(int no);

    /**
     *
     * Gives the badge of a monster, or null.
     *
     * @mangled GetMonsterBajjiDataPtrMosId__16CUserDataManagerFi
     * @address 0x19D810
     * @size 0x8
     */
    MOS_CHANGE_PARAM *GetMonsterBajjiDataPtrMosId(int monster_id);

    /**
     *
     * Gives the number of overflow places after the item board.
     *
     * @mangled GetItemBoardOverNum__16CUserDataManagerFv
     * @address 0x19D820
     * @size 0x38
     */
    int GetItemBoardOverNum();

    /**
     *
     * Gives the number of inventory places in an ITEM_BOARD extent.
     *
     * @mangled GetItemBoardMaxNum__16CUserDataManagerFi
     * @address 0x19D860
     * @size 0x74
     */
    int GetItemBoardMaxNum(int board);

    /**
     *
     * Sets the character being played.
     *
     * @mangled SetActiveChrNo__16CUserDataManagerFi
     * @address 0x19D8E0
     * @size 0x44
     */
    void SetActiveChrNo(int chara);

    /**
     *
     * Gives the character being played.
     *
     */
    s16 GetActiveChrNo() {
        return active_chr_no;
    }

    /**
     *
     * Gives the monster Monica transforms into.
     *
     */
    s16 GetMonsterID() {
        return monster_id;
    }

    /**
     *
     * Renames the ridepod.
     *
     * @mangled SetRoboName__16CUserDataManagerFPc
     * @address 0x19D930
     * @size 0x20
     */
    void SetRoboName(char *name);

    /**
     *
     * Gives the name of the ridepod.
     *
     * @mangled GetRoboName__16CUserDataManagerFv
     * @address 0x19D950
     * @size 0x8
     */
    char *GetRoboName();

    /**
     *
     * Gives the ridepod's default name in the current language.
     *
     * @mangled GetRoboNameDefault__16CUserDataManagerFv
     * @address 0x19D960
     * @size 0x1C
     */
    char *GetRoboNameDefault();

    /**
     *
     * Fits or removes the ridepod's voice unit, turning the voice on when fitted.
     *
     * @mangled SetVoiceUnit__16CUserDataManagerFi
     * @address 0x19D980
     * @size 0x24
     */
    void SetVoiceUnit(int fitted);

    /**
     *
     * Gives whether the voice unit is fitted.
     *
     * @mangled CheckVoiceUnit__16CUserDataManagerFv
     * @address 0x19D9B0
     * @size 0x8
     */
    int CheckVoiceUnit();

    /**
     *
     * Turns the ridepod's voice on or off.
     *
     * @mangled SetRoboVoiceFlag__16CUserDataManagerFi
     * @address 0x19D9C0
     * @size 0x8
     */
    void SetRoboVoiceFlag(int flag);

    /**
     *
     * Gives whether the ridepod speaks: the voice unit is fitted and the voice is on.
     *
     * @mangled CheckRoboVoiceFlag__16CUserDataManagerFv
     * @address 0x19D9D0
     * @size 0x20
     */
    int CheckRoboVoiceFlag();

    /**
     *
     * Adds to the ridepod's absorption, kept between 0 and 99999, and gives the new value.
     *
     * @mangled AddRoboAbs__16CUserDataManagerFf
     * @address 0x19D9F0
     * @size 0x54
     */
    float AddRoboAbs(float amount);

    /**
     *
     * Gives the ridepod's absorption.
     *
     * @mangled GetRoboAbs__16CUserDataManagerFv
     * @address 0x19DA50
     * @size 0x8
     */
    float GetRoboAbs();

    /**
     *
     * Gives the energy capacity of the owned ridepod core, or 0.
     *
     * @mangled CheckCapacity__16CUserDataManagerFv
     * @address 0x19DA60
     * @size 0x78
     */
    int CheckCapacity();

    /**
     *
     * Gives the item number of the owned ridepod core, or -1.
     *
     * @mangled CheckRobotCore__16CUserDataManagerFv
     * @address 0x19DAE0
     * @size 0x54
     */
    int CheckRobotCore();

    /**
     *
     * Gives a character's defence.
     *
     * @mangled GetDefenceVol__16CUserDataManagerFi
     * @address 0x19DB40
     * @size 0x84
     */
    int GetDefenceVol(int chara);

    /**
     *
     * Records a townsperson as able to join the party, with a status.
     *
     * @mangled JoinPartyChara__16CUserDataManagerFiii
     * @address 0x19DBD0
     * @size 0x6C
     */
    void JoinPartyChara(int chara_no, int status, int unused);

    /**
     *
     * Changes the PARTY_CHARA_STATUS of a townsperson; bringing one into the party sends the others
     * out.
     *
     * @mangled SetPartyCharaStatus__16CUserDataManagerFii
     * @address 0x19DC40
     * @size 0x194
     */
    void SetPartyCharaStatus(int chara_no, int status);

    /**
     *
     * Gives the party status of a townsperson.
     *
     * @mangled GetPartyCharaStatus__16CUserDataManagerFi
     * @address 0x19DDE0
     * @size 0x40
     */
    int GetPartyCharaStatus(int chara_no);

    /**
     *
     * Gives the number of the townsperson in the party, or -1.
     *
     * @mangled NowPartyCharaID__16CUserDataManagerFv
     * @address 0x19DE20
     * @size 0x40
     */
    int NowPartyCharaID();

    /**
     *
     * Sends a townsperson home, keeping them in the party if they were.
     *
     * @mangled LeaveHouse__16CUserDataManagerFi
     * @address 0x19DE60
     * @size 0x6C
     */
    void LeaveHouse(int chara_no);

    /**
     *
     * Gives the state of a townsperson, or null.
     *
     * @mangled GetPartyCharaInfo__16CUserDataManagerFi
     * @address 0x19DED0
     * @size 0x38
     */
    PARTY_CHARA_INFO *GetPartyCharaInfo(int chara_no);

    /**
     *
     * Gives whether a townsperson has the points for an ability, spending them when asked.
     *
     * @mangled UseNpcAbility__16CUserDataManagerFiii
     * @address 0x19DF10
     * @size 0xAC
     */
    int UseNpcAbility(int npc_no, int ability, int consume);

    /**
     *
     * Restores every ridepod part, the ridepod body and the ridepod's energy.
     *
     * @mangled AllWeaponRepair__16CUserDataManagerFv
     * @address 0x19DFC0
     * @size 0x88
     */
    void AllWeaponRepair();

    /**
     *
     * Restores the townsfolk's ability points by the hours that have passed.
     *
     * @mangled RefreshNPCStatus__16CUserDataManagerFi
     * @address 0x19E050
     * @size 0x338
     */
    void RefreshNPCStatus(int unused);

    /**
     *
     * Gives the item number of Max's first weapon, the fishing rod when one is equipped.
     *
     * @mangled GetFishingRodNo__16CUserDataManagerFv
     * @address 0x19E390
     * @size 0x8
     */
    int GetFishingRodNo();

    /**
     *
     * Gives whether Max has a fishing rod equipped.
     *
     * @mangled NowFishingStyle__16CUserDataManagerFv
     * @address 0x19E3A0
     * @size 0x30
     */
    int NowFishingStyle();

    /**
     *
     * Gives the bait of the equipped fishing rod.
     *
     * @mangled GetActiveEsa__16CUserDataManagerFv
     * @address 0x19E3D0
     * @size 0x30
     */
    CGameDataUsed *GetActiveEsa();

    /**
     *
     * Gives the bait of a fishing rod, or null.
     *
     * @mangled GetActiveEsa__16CUserDataManagerFi
     * @address 0x19E400
     * @size 0x2C
     */
    CGameDataUsed *GetActiveEsa(int rod_no);

    /**
     *
     * Gives the item number of the equipped fishing rod's bait, or 0.
     *
     * @mangled GetFishBait__16CUserDataManagerFv
     * @address 0x19E430
     * @size 0x48
     */
    int GetFishBait();

    /**
     *
     * Uses up one of the equipped fishing rod's bait.
     *
     * @mangled DeleteBait__16CUserDataManagerFv
     * @address 0x19E480
     * @size 0x40
     */
    void DeleteBait();

    /**
     *
     * Adds a caught fish to the inventory, the aquarium or an overflow place and gives a
     * FISH_STORE_RESULT.
     *
     * @mangled GetFishInAquarium__16CUserDataManagerFiff
     * @address 0x19E4C0
     * @size 0x1F0
     */
    int GetFishInAquarium(int fish_no, float size, float weight);

    /**
     *
     * Counts a catch in the fishing records.
     *
     * @mangled CheckFishRecordUpdate__16CUserDataManagerFiff
     * @address 0x19E6B0
     * @size 0x38
     */
    int CheckFishRecordUpdate(int fish_no, float size, float weight);

    /**
     *
     * Gives the record size and weight of a fish.
     *
     * @mangled GetFishRecord__16CUserDataManagerFiPfPf
     * @address 0x19E6F0
     * @size 0x6C
     */
    void GetFishRecord(int fish_no, float *size, float *weight);

    /**
     *
     * Gives the first five attributes of the equipped fishing rod.
     *
     * @mangled GetRodStatus__16CUserDataManagerFPi
     * @address 0x19E760
     * @size 0x68
     */
    void GetRodStatus(int *out);

    /**
     *
     * Adds synthesis points to the equipped fishing rod and gives the new total.
     *
     * @mangled AddFp__16CUserDataManagerFi
     * @address 0x19E7D0
     * @size 0x48
     */
    int AddFp(int point);

    /**
     *
     * Equips an owned item on a character, swapping it with what was in its slot.
     *
     * @mangled SetChrEquip__16CUserDataManagerFiP13CGameDataUsed
     * @address 0x19E820
     * @size 0x180
     */
    int SetChrEquip(int chara, CGameDataUsed *item);

    /**
     *
     * Equips an item number from the inventory on a character.
     *
     * @mangled SetChrEquip__16CUserDataManagerFii
     * @address 0x19E9A0
     * @size 0xA4
     */
    int SetChrEquip(int chara, int item_no);

    /**
     *
     * Equips a new copy of an item number on a character.
     *
     * @mangled SetChrEquipDirect__16CUserDataManagerFii
     * @address 0x19EA50
     * @size 0xA4
     */
    int SetChrEquipDirect(int chara, int item_no);

    /**
     *
     * Gives the active item or equipment of a character that has an item number, or null.
     *
     * @mangled SearchEquip__16CUserDataManagerFii
     * @address 0x19EB00
     * @size 0xF8
     */
    CGameDataUsed *SearchEquip(int chara, int item_no);

    /**
     *
     * Gives the model path of a character's equipment slot.
     *
     * @mangled GetCharaEquipDataPath__16CUserDataManagerFii
     * @address 0x19EC00
     * @size 0xBC
     */
    char *GetCharaEquipDataPath(int chara, int slot);

    /**
     *
     * Adds synthesis points to a character's weapon and gives the new total.
     *
     * @mangled AddFusionPoint__16CUserDataManagerFiii
     * @address 0x19ECC0
     * @size 0x70
     */
    int AddFusionPoint(int group, int member, int point);

    /**
     *
     * Gives the first empty item board place, or -1.
     *
     * @mangled SearchSpaceUsedData__16CUserDataManagerFv
     * @address 0x19ED30
     * @size 0x64
     */
    int SearchSpaceUsedData();

    /**
     *
     * Gives the item board place that can take one more of an item number, or the first empty one.
     *
     * @mangled SearchSpaceUsedData__16CUserDataManagerFi
     * @address 0x19EDA0
     * @size 0xC8
     */
    int SearchSpaceUsedData(int item_no);

    /**
     *
     * Gives the first empty item board place, or null.
     *
     * @mangled SearchSpaceUsedDataPtr__16CUserDataManagerFv
     * @address 0x19EE70
     * @size 0x48
     */
    CGameDataUsed *SearchSpaceUsedDataPtr();

    /**
     *
     * Gives the item board place that can take one more of an item number, or null.
     *
     * @mangled SearchSpaceUsedDataPtr__16CUserDataManagerFi
     * @address 0x19EEC0
     * @size 0x48
     */
    CGameDataUsed *SearchSpaceUsedDataPtr(int item_no);

    /**
     *
     * Gives the active item place of a character that can take an item number, or -1.
     *
     * @mangled SearchActiveItemTableSpace__16CUserDataManagerFii
     * @address 0x19EF10
     * @size 0xC4
     */
    int SearchActiveItemTableSpace(int chara, int item_no);

    /**
     *
     * Gives the inventory place holding an item number within an ITEM_BOARD extent, or null.
     *
     * @mangled SearchItemOnItemBrd__16CUserDataManagerFii
     * @address 0x19EFE0
     * @size 0x8C
     */
    CGameDataUsed *SearchItemOnItemBrd(int item_no, int board);

    /**
     *
     * Gives how many overflow places hold an item.
     *
     * @mangled GetNumStackOverBoard__16CUserDataManagerFv
     * @address 0x19F070
     * @size 0xA8
     */
    int GetNumStackOverBoard();

    /**
     *
     * Gives the inventory or active item place holding an item number, or null.
     *
     * @mangled SearchAllHaveItem__16CUserDataManagerFi
     * @address 0x19F120
     * @size 0xA4
     */
    CGameDataUsed *SearchAllHaveItem(int item_no);

    /**
     *
     * Moves a fish into an empty place of the first aquarium tank.
     *
     * @mangled FishInAquarium__16CUserDataManagerFP13CGameDataUsedi
     * @address 0x19F1D0
     * @size 0x8C
     */
    int FishInAquarium(CGameDataUsed *fish, int tank);

    /**
     *
     * Gives whether the first aquarium tank holds an electric fish.
     *
     * @mangled CheckElectricFish__16CUserDataManagerFv
     * @address 0x19F260
     * @size 0x70
     */
    int CheckElectricFish();

    /**
     *
     * Gives how many of an item number the player owns, counting gift boxes and equipment.
     *
     * @mangled GetNumSameItem__16CUserDataManagerFi
     * @address 0x19F2D0
     * @size 0x18C
     */
    int GetNumSameItem(int item_no);

    /**
     *
     * Adds medals, kept between 0 and 999, and gives the new count.
     *
     * @mangled AddYarikomiMedal__16CUserDataManagerFi
     * @address 0x19F460
     * @size 0x70
     */
    int AddYarikomiMedal(int amount);

    /**
     *
     * Gives the number of medals.
     *
     * @mangled GetYarikomiMedal__16CUserDataManagerFv
     * @address 0x19F4D0
     * @size 0x10
     */
    int GetYarikomiMedal();

    /**
     *
     * Gives the player a count of an item number, the rest going to overflow places.
     *
     * @mangled GetItem__16CUserDataManagerFii
     * @address 0x19F4E0
     * @size 0xB4
     */
    int GetItem(int item_no, int count);

    /**
     *
     * Gives the player as many of an item number as fit on the item board and gives that count.
     *
     * @mangled GetItemNotOver__16CUserDataManagerFii
     * @address 0x19F5A0
     * @size 0x2E4
     */
    int GetItemNotOver(int item_no, int num);

    /**
     *
     * Puts a count of an item number into the overflow places.
     *
     * @mangled GetOverItem__16CUserDataManagerFii
     * @address 0x19F890
     * @size 0x194
     */
    int GetOverItem(int item_no, int count);

    /**
     *
     * Gives the first item number owned beyond its limit, or 0.
     *
     * @mangled CheckItemLimmitOver__16CUserDataManagerFv
     * @address 0x19FA30
     * @size 0x244
     */
    int CheckItemLimmitOver();

    /**
     *
     * Takes a count of an item number away, from the end of the inventory and then the active items.
     *
     * @mangled DeleteItem__16CUserDataManagerFii
     * @address 0x19FD50
     * @size 0x114
     */
    int DeleteItem(int item_no, int count);

    /**
     *
     * Fills a place with a new item of an item number, by its family.
     *
     * @mangled CopyGameData__16CUserDataManagerFP13CGameDataUsedi
     * @address 0x19FE70
     * @size 0xF0
     */
    int CopyGameData(CGameDataUsed *item, int item_no);

    /**
     *
     * Adds money, kept between 0 and 999999, and gives the new amount.
     *
     * @mangled AddMoney__16CUserDataManagerFi
     * @address 0x19FF60
     * @size 0x74
     */
    int AddMoney(int amount);

    /**
     *
     * Sets the costumes collected.
     *
     * @mangled SetCostumeBit__16CUserDataManagerFUl
     * @address 0x19FFE0
     * @size 0x10
     */
    void SetCostumeBit(unsigned long bit);

    /**
     *
     * Gives the costumes collected.
     *
     * @mangled GetCostumeBit__16CUserDataManagerFv
     * @address 0x19FFF0
     * @size 0x10
     */
    unsigned long GetCostumeBit();

    /**
     *
     * Marks the costume an item number gives as collected.
     *
     * @mangled GetCostume__16CUserDataManagerFi
     * @address 0x1A0000
     * @size 0x54
     */
    void GetCostume(int costume_no);

    /**
     *
     * Gives how many fish the inventory and the first aquarium tank hold.
     *
     * @mangled CountFish__16CUserDataManagerFv
     * @address 0x1A0060
     * @size 0x70
     */
    int CountFish();
};

STATIC_ASSERT(sizeof(CUserDataManager) == 0x457A0);

/**
 *
 * Battle parameters of one of a character's weapons.
 *
 */
struct BATTLE_WEAPON_PARAM {
    s16 status[10]; /**< Status parameters of the weapon. */
    u32 special;    /**< Special ability bits of the weapon. */
    s16 pallet_no;  /**< Colour palette of the weapon's model. */
    u8  unk_1a[2];
};

STATIC_ASSERT(sizeof(BATTLE_WEAPON_PARAM) == 0x1C);

/**
 *
 * Battle view of the character being played: where its status lives and the parameters worked
 * out from it.
 *
 */
class CBattleCharaInfo {
public:
    s16                 chr_no;             /**< Character being played, a USER_CHARA. */
    s16                 user_mons_id;       /**< Monster form selected for the playable character. */
    s16                 now_npc;            /**< Townsperson in the party, or -1. */
    s16                 chara_type;         /**< Kind of status read, a BATTLE_CHARA_TYPE. */
    union {
        void             *any;     /**< Status of any kind, for untyped uses. */
        CHARA_DATA       *human;   /**< Status of Max or Monica, for BATTLE_CHARA_HUMAN. */
        ROBO_DATA        *robo;    /**< Status of the ridepod, for BATTLE_CHARA_ROBO. */
        MOS_CHANGE_PARAM *monster; /**< Badge of the monster form, for BATTLE_CHARA_MONSTER. */
    } chara_data;                  /**< Status being read, by chara_type. */
    float               robo_hp_drain;      /**< Energy the ridepod loses each step. */
    float               monster_hp_drain;   /**< Health a monster loses each step. */
    s16                 regen_count;        /**< Steps towards the next health regained. */
    s16                 poison_count;       /**< Steps towards the next health lost to poison. */
    s16                 magic_sword_elem;   /**< Element of Monica's charged magic sword, or -1. */
    s16                 magic_sword_num;    /**< Number of magic sword charges. */
    s16                 magic_sword_pow[7]; /**< Strength of each magic sword charge. */
    u8                  unk_2a[2];
    CGameDataUsed      *active_item;     /**< Active items of the character, or null. */
    CGameDataUsed      *equip;           /**< Equipment of the character. */
    BATTLE_WEAPON_PARAM weapon_param[2]; /**< Parameters of the two weapons. */
    s16                 defence;         /**< Defence of the character. */
    u8                  unk_6e[6];
    COMMON_GAGE        *hp;               /**< Health gauge of the character. */
    float               hp_change_frames; /**< Frames the shown health takes to reach the real health. */
    float               hp_change_step;   /**< Change of the shown health each frame. */
    float               disp_hp_max;      /**< Maximum health used by the displayed gauge. */
    float               disp_hp;          /**< Health shown, which follows the real health. */
    float               prev_hp_max;      /**< Maximum health used by the previous gauge state. */
    float               prev_hp;          /**< Health before the last change. */

    /**
     *
     * Clears the battle view.
     *
     */
    CBattleCharaInfo() { Initialize(); }

    /**
     *
     * Clears the battle view.
     *
     * @mangled Initialize__16CBattleCharaInfoFv
     * @address 0x1A0360
     * @size 0x58
     */
    void Initialize();

    /**
     *
     * Gives an equipment slot of the character, or null.
     *
     * @mangled GetEquipTablePtr__16CBattleCharaInfoFi
     * @address 0x1A03C0
     * @size 0x40
     */
    CGameDataUsed *GetEquipTablePtr(int slot);

    /**
     *
     * Switches to playing a character and works its parameters out.
     *
     * @mangled SetChrNo__16CBattleCharaInfoFi
     * @address 0x1A0400
     * @size 0x1E8
     */
    void SetChrNo(int new_chara_no);

    /**
     *
     * Gives the monster Monica transforms into.
     *
     * @mangled GetMonsterID__16CBattleCharaInfoFv
     * @address 0x1A05F0
     * @size 0x34
     */
    int GetMonsterID();

    /**
     *
     * Gives the townsperson in the party.
     *
     * @mangled GetNowNPC__16CBattleCharaInfoFv
     * @address 0x1A0630
     * @size 0x8
     */
    int GetNowNPC();

    /**
     *
     * Has the townsperson in the party heal the character when they can.
     *
     * @mangled UseNPCPoint__16CBattleCharaInfoFi
     * @address 0x1A0640
     * @size 0x114
     */
    int UseNPCPoint(int unused);

    /**
     *
     * Gives an active item of the character, or null.
     *
     * @mangled GetActiveItemInfo__16CBattleCharaInfoFi
     * @address 0x1A0760
     * @size 0x2C
     */
    CGameDataUsed *GetActiveItemInfo(int index);

    /**
     *
     * Uses an item on the character, or a repair item on its weapon.
     *
     * @mangled UseActiveItem__16CBattleCharaInfoFP13CGameDataUsed
     * @address 0x1A0790
     * @size 0xC4
     */
    int UseActiveItem(CGameDataUsed *item);

    /**
     *
     * Gives the special ability bits of a weapon of Max or Monica, or 0.
     *
     * @mangled GetSpecialStatus__16CBattleCharaInfoFi
     * @address 0x1A0860
     * @size 0x44
     */
    u32 GetSpecialStatus(int slot);

    /**
     *
     * Gives the colour palette of a weapon of Max or Monica, or -1.
     *
     * @mangled GetPalletNo__16CBattleCharaInfoFi
     * @address 0x1A08B0
     * @size 0x44
     */
    int GetPalletNo(int slot);

    /**
     *
     * Works the character's battle parameters out from its status and equipment.
     *
     * @mangled RefreshParamater__16CBattleCharaInfoFv
     * @address 0x1A0900
     * @size 0x364
     */
    void RefreshParamater();

    /**
     *
     * Gives the durability gauge of a weapon, or null.
     *
     * @mangled GetNowAccessWHp__16CBattleCharaInfoFi
     * @address 0x1A0C70
     * @size 0x74
     */
    COMMON_GAGE *GetNowAccessWHp(int slot);

    /**
     *
     * Gives the absorption gauge of a weapon, or null.
     *
     * @mangled GetNowAccessAbs__16CBattleCharaInfoFi
     * @address 0x1A0CF0
     * @size 0x74
     */
    COMMON_GAGE *GetNowAccessAbs(int slot);

    /**
     *
     * Adds to a weapon's durability and gives how full it is.
     *
     * @mangled AddWhp__16CBattleCharaInfoFif
     * @address 0x1A0D70
     * @size 0x78
     */
    float AddWhp(int slot, float amount);

    /**
     *
     * Gives a weapon's durability and its full value.
     *
     * @mangled GetNowWhp__16CBattleCharaInfoFiPi
     * @address 0x1A0DF0
     * @size 0x50
     */
    void GetNowWhp(int slot, int *out);

    /**
     *
     * Gives a weapon's durability as shown.
     *
     * @mangled GetWhpNowVol__16CBattleCharaInfoFi
     * @address 0x1A0E40
     * @size 0x38
     */
    int GetWhpNowVol(int slot);

    /**
     *
     * Adds a charge of an element to Monica's magic sword.
     *
     * @mangled SetMagicSwordPow__16CBattleCharaInfoFii
     * @address 0x1A0E80
     * @size 0xB4
     */
    void SetMagicSwordPow(int elem, int pow);

    /**
     *
     * Gives the element of Monica's magic sword, or -1.
     *
     * @mangled GetMagicSwordElem__16CBattleCharaInfoFv
     * @address 0x1A0F40
     * @size 0x20
     */
    int GetMagicSwordElem();

    /**
     *
     * Gives the total strength of Monica's magic sword charges.
     *
     * @mangled GetMagicSwordPow__16CBattleCharaInfoFv
     * @address 0x1A0F60
     * @size 0xC4
     */
    int GetMagicSwordPow();

    /**
     *
     * Gives the number of Monica's magic sword charges.
     *
     * @mangled GetMagicSwordCounterNow__16CBattleCharaInfoFv
     * @address 0x1A1030
     * @size 0x28
     */
    int GetMagicSwordCounterNow();

    /**
     *
     * Gives how many magic sword charges Monica's weapon can hold.
     *
     * @mangled GetMagicSwordCounterMax__16CBattleCharaInfoFv
     * @address 0x1A1060
     * @size 0x80
     */
    int GetMagicSwordCounterMax();

    /**
     *
     * Clears Monica's magic sword charges.
     *
     * @mangled ClearMagicSwordPow__16CBattleCharaInfoFv
     * @address 0x1A10E0
     * @size 0x2C
     */
    void ClearMagicSwordPow();

    /**
     *
     * Adds to a weapon's or monster's absorption, levelling it up when full.
     *
     * @mangled AddAbs__16CBattleCharaInfoFifPi
     * @address 0x1A1110
     * @size 0x1A8
     */
    float AddAbs(int slot, float amount, int *leveled_up);

    /**
     *
     * Adds a fraction of a weapon's absorption, levelling it up when full.
     *
     * @mangled AddAbsRate__16CBattleCharaInfoFifPi
     * @address 0x1A12C0
     * @size 0xFC
     */
    int AddAbsRate(int slot, float rate, int *leveled_up);

    /**
     *
     * Gives a weapon's absorption and its full value.
     *
     * @mangled GetNowAbs__16CBattleCharaInfoFiPi
     * @address 0x1A13C0
     * @size 0x50
     */
    void GetNowAbs(int slot, int *out);

    /**
     *
     * Levels a weapon of Max or Monica up when it can.
     *
     * @mangled LevelUpWeapon__16CBattleCharaInfoFP13CGameDataUsed
     * @address 0x1A1410
     * @size 0x68
     */
    int LevelUpWeapon(CGameDataUsed *weapon);

    /**
     *
     * Gives the character's defence.
     *
     * @mangled GetDefenceVol__16CBattleCharaInfoFv
     * @address 0x1A1480
     * @size 0x8
     */
    s16 GetDefenceVol();

    /**
     *
     * Adds to the character's health over a number of frames and gives how full it is.
     *
     * @mangled AddHp_Point__16CBattleCharaInfoFff
     * @address 0x1A1490
     * @size 0xF4
     */
    float AddHp_Point(float point, float frames);

    /**
     *
     * Adds a fraction of the character's health, in an HP_RATE_KIND way, and gives how full it is.
     *
     * @mangled AddHp_Rate__16CBattleCharaInfoFfif
     * @address 0x1A1590
     * @size 0x1B8
     */
    float AddHp_Rate(float rate, int kind, float frames);

    /**
     *
     * Fills the character's health to a fraction.
     *
     * @mangled SetHpRate__16CBattleCharaInfoFf
     * @address 0x1A1750
     * @size 0x28
     */
    void SetHpRate(float rate);

    /**
     *
     * Gives the character's full health.
     *
     * @mangled GetMaxHp_i__16CBattleCharaInfoFv
     * @address 0x1A1780
     * @size 0x34
     */
    int GetMaxHp_i();

    /**
     *
     * Gives the character's health as shown.
     *
     * @mangled GetNowHp_i__16CBattleCharaInfoFv
     * @address 0x1A17C0
     * @size 0x34
     */
    int GetNowHp_i();

    /**
     *
     * Sets or clears status attribute bits of the character, by a CHARA_STATUS_ATTR_MODE, and gives
     * the result.
     *
     * @mangled SetAttr__16CBattleCharaInfoFii
     * @address 0x1A1800
     * @size 0x70
     */
    int SetAttr(int attr, int mode);

    /**
     *
     * Sets status attribute bits of the character with how long they last.
     *
     * @mangled SetAttrVol__16CBattleCharaInfoFii
     * @address 0x1A1870
     * @size 0x70
     */
    int SetAttrVol(int attr, int value);

    /**
     *
     * Gives the character's status attribute.
     *
     * @mangled GetAttr__16CBattleCharaInfoFv
     * @address 0x1A18E0
     * @size 0x44
     */
    int GetAttr();

    /**
     *
     * Makes the shown health jump to the real health.
     *
     * @mangled ForceSet__16CBattleCharaInfoFv
     * @address 0x1A1930
     * @size 0x3C
     */
    void ForceSet();

    /**
     *
     * Steps the character's timed conditions and gives the attribute when poison took health.
     *
     * @mangled StatusParamStep__16CBattleCharaInfoFPi
     * @address 0x1A1CB0
     * @size 0x38C
     */
    int StatusParamStep(int *damage);

    /**
     *
     * Steps the energy drain and the shown health.
     *
     * @mangled Step__16CBattleCharaInfoFv
     * @address 0x1A2040
     * @size 0x238
     */
    void Step();
};

STATIC_ASSERT(sizeof(CBattleCharaInfo) == 0x90);

/**
 *
 * Number of places in each aquarium tank, by tank.
 *
 * @mangled aquarium_fish_maxtbl
 * @address 0x37C780
 * @size 0x3
 */
extern s8 aquarium_fish_maxtbl[3];

/**
 *
 * Battle view of the character being played.
 *
 * @mangled BattleParamater
 * @address 0x1EC94A0
 * @size 0x90
 */
extern CBattleCharaInfo BattleParamater;

/**
 *
 * Gives the user data inside the save data, or null.
 *
 * @mangled GetUserDataMan__Fv
 * @address 0x198100
 * @size 0x34
 */
CUserDataManager *GetUserDataMan();

/**
 *
 * Gives the fishing tournament, or null.
 *
 * @mangled GetFishTournament__Fv
 * @address 0x198140
 * @size 0x34
 */
CFishingTournament *GetFishTournament();

/**
 *
 * Gives the aquarium, or null.
 *
 * @mangled GetAquariumData__Fv
 * @address 0x198180
 * @size 0x30
 */
CFishAquarium *GetAquariumData();

/**
 *
 * Gives how full a gauge is, or 0 for null.
 *
 * @mangled GetCommonGageRate__FP11COMMON_GAGE
 * @address 0x1982D0
 * @size 0x2C
 */
float GetCommonGageRate(COMMON_GAGE *gage);

/**
 *
 * Gives the sum of a fish's racing parameters.
 *
 * @mangled CalcBreedFishParam__FP14BREEDFISH_USED
 * @address 0x198300
 * @size 0x2C
 */
int CalcBreedFishParam(BREEDFISH_USED *fish);

/**
 *
 * Remembers the weapon to give back to Max after the fishing game.
 *
 * @mangled SetFishingGamePreEquip__FP13CGameDataUsed
 * @address 0x198330
 * @size 0x8
 */
void SetFishingGamePreEquip(CGameDataUsed *data);

/**
 *
 * Gives Max back the weapon he had before the fishing game.
 *
 * @mangled ReEquipFishingGameWeapon__Fv
 * @address 0x198340
 * @size 0x3C
 */
void ReEquipFishingGameWeapon();

/**
 *
 * Gives whether an owned item is the weapon remembered for after the fishing game.
 *
 * @mangled CheckFishingWeapon__FP13CGameDataUsed
 * @address 0x198380
 * @size 0x10
 */
int CheckFishingWeapon(CGameDataUsed *weapon);

/**
 *
 * Swaps two owned items, keeping the weapon remembered for after fishing in step when asked.
 *
 * @mangled GameDataSwap__FP13CGameDataUsedP13CGameDataUsedi
 * @address 0x198390
 * @size 0x174
 */
void GameDataSwap(CGameDataUsed *first, CGameDataUsed *second, int mode);

/**
 *
 * Gives the energy capacity the ridepod's parts use, and the capacity of its core.
 *
 * @mangled CheckNowRoboUseCapacity__FP9ROBO_DATAPi
 * @address 0x198510
 * @size 0x90
 */
int CheckNowRoboUseCapacity(ROBO_DATA *robo, int *capacity);

/**
 *
 * Builds the model file name of Max or Monica for their equipped weapon.
 *
 * @mangled GetMainCharaModelName__FiPci
 * @address 0x19A910
 * @size 0xF0
 */
int GetMainCharaModelName(int chara, char *name, int alternate);

/**
 *
 * Gives how many of a shield kit item the ridepod can use.
 *
 * @mangled GetShiledKitLimmit__Fi
 * @address 0x19BD20
 * @size 0x2C
 */
int GetShiledKitLimmit(int item_no);

/**
 *
 * Gives the base data of a monster, or null.
 *
 * @mangled GetMonsterBaseInfo__Fi
 * @address 0x19BDA0
 * @size 0x8
 */
BASE_MONSTER_TBL *GetMonsterBaseInfo(int monster_no);

/**
 *
 * Gives the transformation parameters of a monster, or null.
 *
 * @mangled GetMonsterHengeParam__Fi
 * @address 0x19BDB0
 * @size 0x4C
 */
MOS_HENGE_PARAM *GetMonsterHengeParam(int monster_no);

/**
 *
 * Sets which characters can be changed to for a USER_DATA_ENV.
 *
 * @mangled SetEnvUserDataMan__Fi
 * @address 0x1A00D0
 * @size 0x80
 */
void SetEnvUserDataMan(int env);

/**
 *
 * Fills a list, ended by -1, with the item numbers of a character's starting equipment.
 *
 * @mangled GetCharaDefaultWeapon__FiPi
 * @address 0x1A0150
 * @size 0x9C
 */
void GetCharaDefaultWeapon(int chara, int *weapons);

/**
 *
 * Equips both characters with their starting equipment for the current language and names the
 * ridepod.
 *
 * @mangled LanguageEquipChange__Fv
 * @address 0x1A01F0
 * @size 0xA4
 */
void LanguageEquipChange();

/**
 *
 * Gives Monica her starting equipment when she joins.
 *
 * @mangled CheckEquipChange__Fi
 * @address 0x1A02A0
 * @size 0xBC
 */
void CheckEquipChange(int chara);

/**
 *
 * Gives the battle view of the character being played.
 *
 * @mangled GetBattleCharaInfo__Fv
 * @address 0x1A2280
 * @size 0xC
 */
CBattleCharaInfo *GetBattleCharaInfo();

/**
 *
 * Splits an item's status bits into the conditions it gives and the conditions it cures.
 *
 * @mangled ConvertItemAttrToCharaAttr__FiPiPi
 * @address 0x1A2290
 * @size 0xF4
 */
void ConvertItemAttrToCharaAttr(int attr, int *add, int *cure);

/**
 *
 * Gives whether a status attribute holds a bad condition.
 *
 * @mangled CheckBadStatus__Fi
 * @address 0x1A2390
 * @size 0x44
 */
int CheckBadStatus(int attr);

/**
 *
 * Cancels the weapon attributes that a set of status bits is weak against.
 *
 * @mangled CheckWeaponAttribute__FUiUi
 * @address 0x1A23E0
 * @size 0x64
 */
unsigned int CheckWeaponAttribute(unsigned int mask_a, unsigned int mask_b);

/**
 *
 * Gives whether every monster a weapon needs defeated to build up has been.
 *
 * @mangled CheckBuildUpMonsterCondition__FP11CDataWeapon
 * @address 0x1A2450
 * @size 0xA0
 */
int CheckBuildUpMonsterCondition(CDataWeapon *weapon);

/**
 *
 * Gives how many of a monster have been defeated.
 *
 * @mangled KillMonsterCount__Fii
 * @address 0x1A24F0
 * @size 0x64
 */
int KillMonsterCount(int monster_id, int amount);

/**
 *
 * Gives the item type a character's equipment slot takes, or 0.
 *
 * @mangled SearchEquipType__Fii
 * @address 0x1A2560
 * @size 0x70
 */
int SearchEquipType(int category, int slot);

/**
 *
 * Gives which character can equip an item number, and in which slot.
 *
 * @mangled IsItemtypeWhoisEquip__FiPi
 * @address 0x1A25D0
 * @size 0xB0
 */
int IsItemtypeWhoisEquip(int item_no, int *slot);

/**
 *
 * Gives whether a character is in the party.
 *
 * @mangled IsCheckParty__Fi
 * @address 0x1A2680
 * @size 0x3C
 */
int IsCheckParty(int chara);

/**
 *
 * Gives the name of a fish in the first aquarium tank, or null.
 *
 * @mangled GetAquariumFish0__Fi
 * @address 0x1A26C0
 * @size 0x84
 */
char *GetAquariumFish0(int slot);

/**
 *
 * Gives how many of an item number the player owns.
 *
 * @mangled GetUserItemHaveNum__Fi
 * @address 0x1A2750
 * @size 0x40
 */
int GetUserItemHaveNum(int item_no);

/**
 *
 * Gives how many overflow places hold an item.
 *
 * @mangled CheckItemOver__Fv
 * @address 0x1A2790
 * @size 0x9C
 */
int CheckItemOver();

/**
 *
 * Gives the first item number owned beyond its limit, or 0.
 *
 * @mangled CheckItemLimmitOver__Fv
 * @address 0x1A2830
 * @size 0x38
 */
int CheckItemLimmitOver();

/**
 *
 * Gives how many of a count of an item number the player can take.
 *
 * @mangled CheckGetItemLimmitOver__Fii
 * @address 0x1A2870
 * @size 0x1C8
 */
int CheckGetItemLimmitOver(int item_no, int count);

/**
 *
 * Gives how many more of an item number the player can own.
 *
 * @mangled CheckGetItemRemainNum__Fi
 * @address 0x1A2A40
 * @size 0x50
 */
int CheckGetItemRemainNum(int item_no);

/**
 *
 * Removes the dungeon keys and leaves both characters standing and free of poison.
 *
 * @mangled CheckItemDngKey__Fv
 * @address 0x1A2A90
 * @size 0x10C
 */
void CheckItemDngKey();

/**
 *
 * Restores the health and conditions of both characters and every monster.
 *
 * @mangled PlayerPartyCure__Fv
 * @address 0x1A2BA0
 * @size 0x88
 */
void PlayerPartyCure();

/**
 *
 * Advances the user data by the time that has passed.
 *
 * @mangled UserDataRefresh__Fv
 * @address 0x1A2C30
 * @size 0x30
 */
void UserDataRefresh();

/**
 *
 * Takes the first electric fish out of the first aquarium tank.
 *
 * @mangled DeleteErekiFish__Fv
 * @address 0x1A2C60
 * @size 0x88
 */
void DeleteErekiFish();

/**
 *
 * Gives the number of inventory places in an ITEM_BOARD extent.
 *
 * @mangled GetNowBagMax__Fi
 * @address 0x1A2CF0
 * @size 0x30
 */
int GetNowBagMax(int board);

/**
 *
 * Moves Monica's active items back to the inventory when she leaves.
 *
 * @mangled LeaveMonicaItemCheck__Fv
 * @address 0x1A2D20
 * @size 0x13C
 */
void LeaveMonicaItemCheck();

/**
 *
 * Clears the fatigue of every fish in the inventory and the aquarium.
 *
 * @mangled AquaFishFatigueClear__Fv
 * @address 0x1A2E60
 * @size 0xF4
 */
void AquaFishFatigueClear();

/**
 *
 * Sets up the user data for one of the debug starting states.
 *
 * @mangled DebugGetItem__FP16CUserDataManageri
 * @address 0x1A2F60
 * @size 0x4FC
 */
void DebugGetItem(CUserDataManager *user_data, int mode);

/**
 *
 * Picks the RANDOM_CIRCLE effect a random circle of a kind sets off for the character played.
 *
 * @mangled GetRandomCircleTrapID__Fi
 * @address 0x1A1970
 * @size 0x114
 */
int GetRandomCircleTrapID(int kind);

/**
 *
 * Applies a RANDOM_CIRCLE effect; gives whether it took effect.
 *
 * @mangled SetRandamCircleStatus__FiRf
 * @address 0x1A1A90
 * @size 0x21C
 */
int SetRandamCircleStatus(int trap, float &amount_out);
