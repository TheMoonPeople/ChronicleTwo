#pragma once

#include "common.h"

/**
 * @file
 * Declares the fishing sub game: the fish table, the appearance places of each map, the state of
 * a hooked fish and the entry points the sub game manager calls each frame.
 */

class CCameraControl;
class mgCMemory;
struct SubGameInfo;

/**
 *
 * Identifies the step of the fishing sub game that the player character is in.
 *
 */
enum FISHING_CHARA_MODE {
    FISHING_CHARA_MODE_CONTROL = 0,      /**< The player moves about freely with the rod. */
    FISHING_CHARA_MODE_SELECT_POINT = 1, /**< The player aims the point to cast to. */
    FISHING_CHARA_MODE_CASTING = 2,      /**< The rod is being swung and the line thrown. */
    FISHING_CHARA_MODE_UKI_WAIT = 3,     /**< The float is in the water, waiting for a bite. */
    FISHING_CHARA_MODE_NONE = 4,         /**< No step runs. */
    FISHING_CHARA_MODE_BATTLE = 5,       /**< A hooked fish is fighting the line. */
    FISHING_CHARA_MODE_FALSE = 6,        /**< The fish got away. */
    FISHING_CHARA_MODE_SUCCESS = 7,      /**< The fish was landed. */
};

/**
 *
 * Rates how readily a fish takes a bait, or bites at a time of day.
 *
 */
enum FISH_AFFINITY {
    FISH_AFFINITY_NONE = 0,   /**< The fish does not bite. */
    FISH_AFFINITY_LOW = 1,    /**< The fish bites at half its usual rate. */
    FISH_AFFINITY_NORMAL = 2, /**< The fish bites at its usual rate. */
    FISH_AFFINITY_HIGH = 3,   /**< The fish bites at one and a half times its usual rate. */
};

/**
 *
 * Identifies the shape of the area that a fish appearance place covers.
 *
 */
enum FISH_PLACE_AREA {
    FISH_PLACE_AREA_CIRCLE = 2, /**< A circle on the ground plane; every other shape covers the whole map. */
};

/**
 *
 * Identifies the inventory item associated with each fish species.
 *
 */
enum FISH_ITEM_ID {
    FISH_ITEM_NONE = 0,               /**< No caught fish item. */
    FISH_ITEM_HAGUHAGU = 310,         /**< Haguhagu fish item. */
    FISH_ITEM_BOUBOU = 320,           /**< Boubou fish item. */
    FISH_ITEM_GABURA = 321,           /**< Gabura fish item. */
    FISH_ITEM_NONKII = 322,           /**< Nonkii fish item. */
    FISH_ITEM_KAJII = 323,            /**< Kajii fish item. */
    FISH_ITEM_BAKUBAKU = 324,         /**< Bakubaku fish item. */
    FISH_ITEM_MAADANGARAYAN = 325,    /**< Maadangarayan fish item. */
    FISH_ITEM_GUMII = 326,            /**< Gumii fish item. */
    FISH_ITEM_NIIRAA = 327,           /**< Niiraa fish item. */
    FISH_ITEM_UMADAKARA = 328,        /**< Umadakara fish item. */
    FISH_ITEM_TAATON = 329,           /**< Taaton fish item. */
    FISH_ITEM_PIKKORII = 330,         /**< Pikkorii fish item. */
    FISH_ITEM_BON = 331,              /**< Bon fish item. */
    FISH_ITEM_HAMAHAMA = 332,         /**< Hamahama fish item. */
    FISH_ITEM_NEJII = 333,            /**< Nejii fish item. */
    FISH_ITEM_DEN = 334,              /**< Den fish item. */
    FISH_ITEM_HIIRA = 335,            /**< Hiira fish item. */
    FISH_ITEM_DANSHAKU_GARAYAN = 336, /**< Danshaku garayan fish item. */
};

/**
 *
 * Describes one kind of fish: its names, item, size range and how readily it bites.
 *
 */
struct FISH_PARAM {
    char *name;      /**< Display name of the fish. */
    char *file_name; /**< Base name of the fish's model file under sg/fish. */
    int   item_no;   /**< FISH_ITEM_ID of the fish once caught. */
    float base_size; /**< Size at which the fish's model is drawn at its natural scale. */
    float min_size;  /**< Smallest size a caught fish can have, before the rod's size rate. */
    float max_size;  /**< Largest typical size of a caught fish, before the rod's size rate. */
    float unk_18;
    float weight_rate;           /**< Weight of the fish per unit of size. */
    float fishing_point_rate;    /**< Fishing points awarded per unit of size. */
    float pull_rate;             /**< Strength with which the fish pulls on the line, per 80 units of size. */
    short bait_affinity[18];     /**< FISH_AFFINITY of the fish for each bait. */
    short time_band_affinity[4]; /**< FISH_AFFINITY of the fish for each band of the time of day. */
};

STATIC_ASSERT(sizeof(FISH_PARAM) == 0x54);

/**
 *
 * Holds the attributes of the equipped fishing rod while the sub game runs.
 *
 */
struct FISHING_ROD_DATA {
    int   status[5];    /**< Rod attributes, the first three scaled by the fourth. */
    float status4_rate; /**< Fifth attribute as a fraction of 100. */
};

STATIC_ASSERT(sizeof(FISHING_ROD_DATA) == 0x18);

/**
 *
 * Holds the fish chosen to bite the bait and the state of its fight against the line.
 *
 */
struct FISH_DATA {
    int   fish_no;         /**< Index of the fish in the fish table, or -1 for none. */
    float size;            /**< Size of the fish. */
    float weight;          /**< Weight of the fish. */
    float length_scale;    /**< Scale of the fish's model along its length. */
    float width_scale;     /**< Scale of the fish's model across its body. */
    float pull_strength;   /**< Strength with which the fish pulls on the line. */
    float vigour_recovery; /**< Amount the fish's vigour regains each frame it is left alone. */
    float vigour;          /**< Fighting vigour of the fish, from -1 to 1. */
    int   fishing_point;   /**< Fishing points awarded when the fish is landed. */
};

STATIC_ASSERT(sizeof(FISH_DATA) == 0x24);

/**
 *
 * Gives one kind of fish that can appear at a place and how often it bites.
 *
 */
struct FISH_PLACE {
    int   fish_no;   /**< Index of the fish in the fish table, or -1 for an empty entry. */
    float rate;      /**< Weight of the fish when choosing which fish bites. */
    float wait_bias; /**< Shortens the wait for a bite when positive and lengthens it when negative. */
};

STATIC_ASSERT(sizeof(FISH_PLACE) == 0xC);

/**
 *
 * Describes an area of a map and the fish that can appear in it, as read from the fish place script.
 *
 */
class FISH_PLACE_MAP {
public:
    int        map_no;        /**< Map on which the place lies. */
    int        exclusive;     /**< Whether the place's fish replace those of every other place rather than adding to them. */
    int        area_type;     /**< FISH_PLACE_AREA shape of the place. */
    char      *name;          /**< Name of the place. */
    float      area_param[5]; /**< Shape parameters; a circle uses the centre X, the centre Z and the radius. */
    int        fish_num;      /**< Number of entries used in fish. */
    FISH_PLACE fish[8];       /**< Fish that can appear at the place. */

    /**
     *
     * Merges the place's fish into a list of fish, or replaces the list with them when the place
     * is exclusive; gives the number of entries newly filled.
     *
     * @mangled SetFishPlace__14FISH_PLACE_MAPFP10FISH_PLACEii
     * @address 0x3089E0
     * @size 0x210
     */
    int SetFishPlace(FISH_PLACE *place, int place_num, int replace);

    /**
     *
     * Gives whether a position lies within the place's area.
     *
     * @mangled CheckFishPlace__14FISH_PLACE_MAPFPf
     * @address 0x308BF0
     * @size 0x90
     */
    int CheckFishPlace(float *position);
};

STATIC_ASSERT(sizeof(FISH_PLACE_MAP) == 0x88);

/**
 *
 * Stack size, in bytes, of the thread that loads the sub game's data.
 *
 */
extern int stack_size;

/**
 *
 * Prepares the fishing sub game: its texture blocks, read buffers and the player's stance;
 * gives 1.
 *
 * @mangled sgInitFishing__FP11SubGameInfo
 * @address 0x301840
 * @size 0x1C0
 */
int sgInitFishing(SubGameInfo *info);

/**
 *
 * Starts a round of fishing with the rod and bait the sub game was entered with, loading the bait
 * or lure model and reading the rod's attributes; gives 1.
 *
 * @mangled sgRestartFishing__FP11SubGameInfo
 * @address 0x301A00
 * @size 0x560
 */
int sgRestartFishing(SubGameInfo *info);

/**
 *
 * Stops the sub game at once, ending the loading thread before leaving; gives 1.
 *
 * @mangled sgBreakFishing__Fv
 * @address 0x302D30
 * @size 0x30
 */
int sgBreakFishing();

/**
 *
 * Leaves the sub game: frees its textures, gives the player back their weapon, resumes the
 * previous music and restores the player's stance; gives 1.
 *
 * @mangled sgExitFishing__FP11SubGameInfo
 * @address 0x302D60
 * @size 0xC0
 */
int sgExitFishing(SubGameInfo *info);

/**
 *
 * Runs a frame of the sub game: loads its data on first entry, then runs the current step of
 * the player character; gives the exit code once the sub game ends, otherwise 0.
 *
 * @mangled sgLoopFishing__FP11SubGameInfo
 * @address 0x302E20
 * @size 0x340
 */
int sgLoopFishing(SubGameInfo *info);

/**
 *
 * Runs the second part of a frame of the sub game: moves the rod and line with the player
 * character; gives 0.
 *
 * @mangled sgLoopFishing2__FP11SubGameInfo
 * @address 0x303160
 * @size 0x100
 */
int sgLoopFishing2(SubGameInfo *info);

/**
 *
 * Draws the rod, lure, float, hook, casting cursor, bait, landed fish and line of the sub game;
 * gives 0.
 *
 * @mangled sgDrawFishing__FP11SubGameInfo
 * @address 0x303260
 * @size 0x3A0
 */
int sgDrawFishing(SubGameInfo *info);

/**
 *
 * Draws the sub game's display: the rod action chance, the line tension gauge, its three-digit
 * readout and the hit and catch banners; gives 1 once the sub game's data is loaded, otherwise 0.
 *
 * @mangled sgSystemDrawFishing__FP11SubGameInfo
 * @address 0x3036A0
 * @size 0x920
 */
int sgSystemDrawFishing(SubGameInfo *info);

/**
 *
 * Turns the camera back from its float-watching view and restores the settings it had before.
 *
 * @mangled ResetUkiCamera__FP14CCameraControl
 * @address 0x305180
 * @size 0x50
 */
void ResetUkiCamera(CCameraControl *camera);

/**
 *
 * Lists the fish that can appear at a position of a map, falling back to the places common to
 * every map when the map has none; gives the number of fish listed.
 *
 * @mangled GetAppearFish__FiPfP10FISH_PLACEi
 * @address 0x308800
 * @size 0x1E0
 */
int GetAppearFish(int map_no, float *position, FISH_PLACE *place, int max_places);

/**
 *
 * Reads the fish place script, building the table of fish appearance places in a block of memory.
 *
 * @mangled LoadFishPlaceData__FPciP9mgCMemory
 * @address 0x308F50
 * @size 0x70
 */
void LoadFishPlaceData(char *script, int size, mgCMemory *stack);
