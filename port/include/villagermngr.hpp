#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_memory.hpp"

/**
 * @file
 * Declares the town villager manager: the per-villager state that walks
 * each townsperson along the route of its current place, makes it stop to
 * talk, and plays its camera poses, together with the place descriptions
 * read from the villager place script that drive it.
 */

/**
 *
 * Motions a villager can be told to play, by their index in the scene's motion name table.
 *
 */
enum VLGR_MOTION {
    VLGR_MOTION_NONE = -1,      /**< No motion requested. */
    VLGR_MOTION_STAND = 0,      /**< Standing. */
    VLGR_MOTION_WALK = 1,       /**< Walking. */
    VLGR_MOTION_RUN = 2,        /**< Running. */
    VLGR_MOTION_TALK = 3,       /**< Talking. */
    VLGR_MOTION_SIT = 4,        /**< Sitting. */
    VLGR_MOTION_CAMERA_IN = 5,  /**< Going into the pose for the camera. */
    VLGR_MOTION_CAMERA = 6,     /**< Holding the pose for the camera. */
    VLGR_MOTION_CAMERA_OUT = 7, /**< Coming back out of the pose for the camera. */
    VLGR_MOTION_SPECIAL = 8     /**< The villager's special motion. */
};

/**
 *
 * Time of day a villager place applies to.
 *
 */
enum VLGR_TIME {
    VLGR_TIME_NOON = 0, /**< Daytime. */
    VLGR_TIME_NIGHT = 1 /**< Night-time. */
};

/**
 *
 * Kinds of step on a villager's route.
 *
 */
enum VLGR_ROUTE_TYPE {
    VLGR_ROUTE_MOVE = 1, /**< Walk to a point. */
    VLGR_ROUTE_WAIT = 2  /**< Stand and wait for a number of frames. */
};

/**
 *
 * Steps of a villager's camera pose, run while the player photographs it.
 *
 */
enum VLGR_EX_STEP {
    VLGR_EX_STEP_START = 1,   /**< Begin turning into the pose. */
    VLGR_EX_STEP_IN = 2,      /**< Wait for the motion into the pose to end. */
    VLGR_EX_STEP_HOLD = 3,    /**< Hold the pose while the camera keeps asking for it. */
    VLGR_EX_STEP_OUT = 4,     /**< Wait for the motion out of the pose to end. */
    VLGR_EX_STEP_RESTORE = 5, /**< Go back to the place's waiting motion. */
    VLGR_EX_STEP_END = 6      /**< Leave the camera pose. */
};

/**
 *
 * Model parts a villager shows around its camera pose, as CVillagerData::parts_mode holds them.
 *
 */
enum VLGR_PARTS_MODE {
    VLGR_PARTS_MODE_NONE = 0,   /**< Leave the parts as they are. */
    VLGR_PARTS_MODE_POSE = 1,   /**< Show the posing hands in place of the normal ones. */
    VLGR_PARTS_MODE_NORMAL = 2, /**< Show the normal hands again. */
};

/**
 *
 * Where and how a villager appears: its standing point, talk area, motions and route.
 *
 */
class CVillagerPlaceInfo {
public:
    /**
     *
     * One step of a villager's route, either a point to walk to or a wait.
     *
     */
    struct Node {
        Node *next; /**< Next step of the route, or NULL after the last. */
        s32   type; /**< Kind of step, a VLGR_ROUTE_TYPE. */
        s32   unk_8;
        s32   unk_c;

        union {
            sceVu0FVECTOR pos; /**< Point to walk to, for a VLGR_ROUTE_MOVE step. */

            struct {
                s32 motion_end; /**< Whether the wait also ends when the motion ends. */
                s32 time;       /**< Number of frames to wait. */
                s32 motion;     /**< Motion to play while waiting, a VLGR_MOTION. */
            } wait;             /**< Wait settings, for a VLGR_ROUTE_WAIT step. */
        };
    };

    sceVu0FVECTOR pos{};         /**< Position the villager stands at, with the angle it faces in w. */
    sceVu0FVECTOR talk_offset{}; /**< Area the player can talk to the villager from. */
    s32           map_no{-1};    /**< Number of the map the place is on, or -1. */
    s32           motion{};      /**< Motion played while standing, a VLGR_MOTION. */
    s32           move_motion{}; /**< Motion played while walking the route, a VLGR_MOTION. */
    float         move_speed{};  /**< Distance walked per frame; a default is used when not above zero. */
    s32           no_shadow{};   /**< Whether the villager is drawn without a shadow. */
    Node         *route{};       /**< First step of the route, or NULL to stand still. */
    s32           unk_38{};
    s32           unk_3c{};

    /**
     *
     * Clears the place, leaving it on no map.
     *
     * @mangled __ct__18CVillagerPlaceInfoFv
     * @address 0x31F3B0
     * @size 0x40
     */
    CVillagerPlaceInfo();

    /**
     *
     * Allocates a new route step from a memory stack and appends it to the route.
     *
     * @mangled Add__18CVillagerPlaceInfoFP9mgCMemory
     * @address 0x2D1B00
     * @size 0x84
     */
    Node *Add(mgCMemory *stack);
};

STATIC_ASSERT(sizeof(CVillagerPlaceInfo::Node) == 0x20);
STATIC_ASSERT(sizeof(CVillagerPlaceInfo) == 0x40);

/**
 *
 * The places one villager can appear at as the story progresses.
 *
 */
class CVillagerPlace {
public:
    /**
     *
     * The places a villager uses from one point of the story's progress.
     *
     */
    struct ProgressInfo {
        s32                 progress;    /**< Story progress the entry applies from. */
        s32                 after;       /**< Whether the entry also applies to later progress. */
        CVillagerPlaceInfo *place[4][2]; /**< Places by alternative and by VLGR_TIME. */

        /**
         *
         * Clears the entry's progress and places.
         *
         * @mangled Init__Q214CVillagerPlace12ProgressInfoFv
         * @address 0x2D1A50
         * @size 0x30
         */
        void Init();
    };

    s32           prog_num{};  /**< Number of entries in prog_info. */
    ProgressInfo *prog_info{}; /**< Entries in order of story progress. */

    /**
     *
     * Clears the table of progress entries.
     *
     * @mangled __ct__14CVillagerPlaceFv
     * @address 0x31FBA0
     * @size 0x30
     */
    CVillagerPlace();
};

STATIC_ASSERT(sizeof(CVillagerPlace::ProgressInfo) == 0x28);
STATIC_ASSERT(sizeof(CVillagerPlace) == 0x8);

/**
 *
 * The running state of one villager placed in the town.
 *
 */
class CVillagerData {
public:
    s32                       chara_id{}; /**< Number of the scene character showing the villager. */
    s32                       vlgr_id{};  /**< Number of the villager, or -1 for a free entry. */
    s32                       unk_8{};
    s32                       unk_c{};
    s32                       unk_10{};
    CVillagerPlaceInfo       *place{};       /**< Place the villager follows. */
    CVillagerPlaceInfo::Node *route{};       /**< Step of the route being followed. */
    s32                       route_time{};  /**< Frames spent on the current route step. */
    s32                       ex_mode{};     /**< Whether the villager is posing for the camera. */
    s32                       ex_step{};     /**< Step of the camera pose, a VLGR_EX_STEP. */
    s32                       ex_time{};     /**< Frames since the camera last asked for the pose. */
    s32                       stay{};        /**< Number of requests holding the villager still. */
    s32                       req_motion{};  /**< Motion to switch to, a VLGR_MOTION. */
    s32                       now_motion{};  /**< Motion the character is playing, a VLGR_MOTION. */
    s32                       motion_flag{}; /**< Flags passed with req_motion when it is set. */
    s32                       motion_end{};  /**< Whether the character's motion has ended. */
    s32                       parts_mode{};  /**< Model parts shown around the camera pose, a VLGR_PARTS_MODE. */
    s32                       unk_44{};
    s32                       unk_48{};
    s32                       unk_4c{};
    sceVu0FVECTOR             pos{}; /**< Position of the villager. */
    sceVu0FVECTOR             rot{}; /**< Rotation of the villager. */

    /**
     *
     * Empties the entry.
     *
     */
    CVillagerData() {
        Initialize();
    }

    /**
     *
     * Empties the entry, freeing it for another villager.
     *
     * @mangled Initialize__13CVillagerDataFv
     * @address 0x2D1A80
     * @size 0x74
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CVillagerData) == 0x70);

/**
 *
 * Moves the villagers placed in the town each frame.
 *
 */
class CVillagerMngr {
public:
    s32           stop{};     /**< Whether every villager is held still. */
    s32           data_num{}; /**< Number of entries in data. */
    s32           unk_8{};
    s32           unk_c{};
    CVillagerData data[32]; /**< State of each villager placed. */

    /**
     *
     * Empties the manager.
     *
     */
    CVillagerMngr() {
        Initialize();
    }

    /**
     *
     * Frees every entry and lets the villagers move.
     *
     * @mangled Initialize__13CVillagerMngrFv
     * @address 0x2D1B90
     * @size 0x6C
     */
    void Initialize();

    /**
     *
     * Returns an entry by its number, or NULL for a number out of range.
     *
     * @mangled GetData__13CVillagerMngrFi
     * @address 0x2D1C00
     * @size 0x3C
     */
    CVillagerData *GetData(int no);

    /**
     *
     * Adds a request holding a villager still.
     *
     * @mangled Stay__13CVillagerMngrFi
     * @address 0x2D1C40
     * @size 0x30
     */
    void Stay(int chara_id);

    /**
     *
     * Removes a request holding a villager still.
     *
     * @mangled CancelStay__13CVillagerMngrFi
     * @address 0x2D1C70
     * @size 0x40
     */
    void CancelStay(int chara_id);

    /**
     *
     * Asks a villager to pose for the camera, starting the pose if it is not already posing.
     *
     * @mangled ExMode__13CVillagerMngrFi
     * @address 0x2D1CB0
     * @size 0x3C
     */
    void ExMode(int chara_id);

    /**
     *
     * Returns the number of the entry showing a scene character, or -1.
     *
     * @mangled SearchDataIDatCharaID__13CVillagerMngrFi
     * @address 0x2D1CF0
     * @size 0x48
     */
    int SearchDataIDatCharaID(int chara_id);

    /**
     *
     * Places a villager at a place, giving whether a free entry was found.
     *
     * @mangled Register__13CVillagerMngrFiiP18CVillagerPlaceInfo
     * @address 0x2D1D40
     * @size 0x94
     */
    int Register(int vlgr_id, int chara_id, CVillagerPlaceInfo *place);

    /**
     *
     * Frees the entries showing a scene character.
     *
     * @mangled DeleteCharaID__13CVillagerMngrFi
     * @address 0x2D1DE0
     * @size 0x74
     */
    void DeleteCharaID(int chara_id);

    /**
     *
     * Returns a free entry, or NULL when all are in use.
     *
     * @mangled NewData__13CVillagerMngrFv
     * @address 0x2D1E60
     * @size 0x50
     */
    CVillagerData *NewData();

    /**
     *
     * Returns whether a villager is being held still.
     *
     * @mangled CheckStay__13CVillagerMngrFi
     * @address 0x2D1EB0
     * @size 0x64
     */
    int CheckStay(int chara_id);

    /**
     *
     * Moves every villager along its route or through its camera pose for one frame.
     *
     * @mangled Step__13CVillagerMngrFv
     * @address 0x2D1F20
     * @size 0x4A4
     */
    void Step();

    /**
     *
     * Lists the villagers that appear on a map at a point of the story and time of day.
     *
     * @mangled GetAppearVlgr__13CVillagerMngrFiiiPiPP18CVillagerPlaceInfo
     * @address 0x2D23D0
     * @size 0x2A8
     */
    int GetAppearVlgr(int progress, int time, int map_no, int *villager_ids, CVillagerPlaceInfo **place);

    /**
     *
     * Gives the talk area of the villager shown by a scene character, and whether it has one.
     *
     * @mangled GetTalkRect__13CVillagerMngrFiPf
     * @address 0x2D2680
     * @size 0xA0
     */
    int GetTalkRect(int chara_id, float *rect);
};

STATIC_ASSERT(sizeof(CVillagerMngr) == 0xE10);
