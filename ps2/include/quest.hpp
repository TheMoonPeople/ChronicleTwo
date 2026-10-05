#pragma once

#include "common.h"

/**
 * @file
 * Declares the townspeople's requests: the request list read from the quest
 * script for the request memo, the saved progress of each request, and the
 * monster book's saved defeat counts.
 */

class mgCMemory;

/**
 *
 * Limits of the request and monster book records.
 *
 */
enum QUEST_LIMIT {
    QUEST_PLAY_DATA_MAX = 0x40,      /**< Number of requests whose progress the save data keeps. */
    QUEST_INFO_COMMENT_MAX = 4,      /**< Number of reaction comment slots of a request. */
    MONSTER_BOOK_ENTRY_MAX = 0x180,  /**< Number of monsters the monster book keeps a record of. */
    MONSTER_BOOK_KILL_MAX = 60000,   /**< Highest defeat count the monster book records for one monster. */
};

/**
 *
 * Progress of a request, as GetQuestRequestStatus gives it to the event scripts.
 *
 */
enum QUEST_REQUEST_STATUS {
    QUEST_REQUEST_STATUS_INVALID = -1,  /**< No save data, or the request number is out of range. */
    QUEST_REQUEST_STATUS_NONE = 0,      /**< The request has not been taken on. */
    QUEST_REQUEST_STATUS_ACCEPTED = 1,  /**< The request has been taken on but not fulfilled. */
    QUEST_REQUEST_STATUS_CLEARED = 2,   /**< The request has been fulfilled. */
};

/**
 *
 * Describes one request of the quest script: its number, title and the comments shown in the request memo.
 *
 */
struct QUEST_INFO {
    s32  id;                                    /**< Request number, as the save data and the event scripts identify the request. */
    char name[0x84];                            /**< Title of the request shown in the request list. */
    char comment[0x140];                        /**< Description of the request given by the townsperson who asks it. */
    char reaction[QUEST_INFO_COMMENT_MAX][0x82]; /**< Further comments: slot 0 is shown while the request is open, slot 1 once it is cleared. */
};

STATIC_ASSERT(sizeof(QUEST_INFO) == 0x3D0);

/**
 *
 * Holds the request list read from the quest script, for the request memo.
 *
 */
class CQuestManager {
public:
    s32         num;  /**< Number of requests in the list. */
    QUEST_INFO *info; /**< Requests of the list, in script order. */

    /**
     *
     * Makes an empty request list.
     *
     */
    CQuestManager() { Initialize(); }

    /**
     *
     * Empties the request list.
     *
     * @mangled Initialize__13CQuestManagerFv
     * @address 0x31FC10
     * @size 0xC
     */
    void Initialize();

    /**
     *
     * Gives the request with a request number, or null when the list has none.
     *
     * @mangled GetQuestInfo__13CQuestManagerFi
     * @address 0x31FC20
     * @size 0x5C
     */
    QUEST_INFO *GetQuestInfo(int id);

    /**
     *
     * Reads the request list from a quest script, allocating the requests from a heap.
     *
     * @mangled LoadCfg__13CQuestManagerFP9mgCMemoryPci
     * @address 0x31FE00
     * @size 0x64
     */
    void LoadCfg(mgCMemory *stack, char *script, int script_size);
};

STATIC_ASSERT(sizeof(CQuestManager) == 0x8);

/**
 *
 * Saved progress of one request.
 *
 */
struct QUEST_PLAY_DATA {
    s8 accepted;   /**< Non-zero once the request has been taken on; the event script sets the value. */
    s8 cleared;    /**< Non-zero once the request has been fulfilled. */
    u8 unk_2[0xE];
};

STATIC_ASSERT(sizeof(QUEST_PLAY_DATA) == 0x10);

/**
 *
 * Saved progress of every request, kept in the save data.
 *
 */
class CQuestData {
public:
    /**
     *
     * Creates request progress with no request taken on.
     *
     */
    CQuestData() { Initialize(); }

    QUEST_PLAY_DATA play[QUEST_PLAY_DATA_MAX]; /**< Progress of each request, by request number. */
    u8              unk_400[0x80];

    /**
     *
     * Marks every request as not taken on.
     *
     * @mangled Initialize__10CQuestDataFv
     * @address 0x31FE70
     * @size 0xC
     */
    void Initialize();

    /**
     *
     * Sets whether a request has been taken on; an out-of-range request number is ignored.
     *
     * @mangled SetQuestFlag__10CQuestDataFii
     * @address 0x31FE80
     * @size 0x30
     */
    void SetQuestFlag(int id, int flag);

    /**
     *
     * Marks a request as fulfilled; an out-of-range request number is ignored.
     *
     * @mangled QuestClear__10CQuestDataFi
     * @address 0x31FEB0
     * @size 0x34
     */
    void QuestClear(int id);

    /**
     *
     * Gives the progress of a request, or null for an out-of-range request number.
     *
     * @mangled GetPlayQuestData__10CQuestDataFi
     * @address 0x31FEF0
     * @size 0x2C
     */
    QUEST_PLAY_DATA *GetPlayQuestData(int id);
};

STATIC_ASSERT(sizeof(CQuestData) == 0x480);

/**
 *
 * Monster book record of one monster.
 *
 */
struct MONSTER_BOOK_ENTRY {
    u8  unk_0[0x2];
    u16 kill_count; /**< Number of the monster defeated, up to MONSTER_BOOK_KILL_MAX. */
    u8  unk_4[0x8];
};

STATIC_ASSERT(sizeof(MONSTER_BOOK_ENTRY) == 0xC);

/**
 *
 * Monster book records of every monster, kept in the save data.
 *
 */
class CMonsterBook {
public:
    MONSTER_BOOK_ENTRY entry[MONSTER_BOOK_ENTRY_MAX]; /**< Record of each monster, by monster number. */

    /**
     *
     * Adds to the defeat count of a monster and gives the new count, or 0 for an out-of-range monster number.
     *
     * @mangled CountKill__12CMonsterBookFii
     * @address 0x320020
     * @size 0x68
     */
    int CountKill(int monster_id, int count);
};

STATIC_ASSERT(sizeof(CMonsterBook) == 0x1200);

/**
 *
 * Sets whether a request of the saved game has been taken on.
 *
 * @mangled QuestRequestSetFlag__Fii
 * @address 0x31FF20
 * @size 0x44
 */
void QuestRequestSetFlag(int id, int flag);

/**
 *
 * Marks a request of the saved game as fulfilled; the second argument is unused.
 *
 * @mangled QuestRequestClear__Fii
 * @address 0x31FF70
 * @size 0x38
 */
void QuestRequestClear(int id, int unused);

/**
 *
 * Gives the progress of a request of the saved game, as a QUEST_REQUEST_STATUS.
 *
 * @mangled GetQuestRequestStatus__Fi
 * @address 0x31FFB0
 * @size 0x68
 */
int GetQuestRequestStatus(int id);

