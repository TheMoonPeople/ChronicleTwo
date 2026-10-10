#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "automap.hpp"
#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "savedatadungeon.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"

enum {
    kMiniMapInfoCount = 18,
    kHealingCooldown = 0x708,
    kStepUp = 1,
    kStepDown = 2,
    kStepRight = 4,
    kStepLeft = 8,
    kTermRightMargin = 21,
    kDoorPartsBegin = 0xE8,
    kDoorPartsEnd = 0xF0,
    kDoorPartsLast = kDoorPartsEnd - 1
};

static int _ROOM_FIXED(SPI_STACK *stack, int arg_count);
static int _GRID_SIZE(SPI_STACK *stack, int unused);
static int _ROOM_ID(SPI_STACK *stack, int arg_count);
static int _ROOM_SIZE(SPI_STACK *stack, int arg_count);
static int _ROOM_RATE(SPI_STACK *stack, int arg_count);
static int _RD(SPI_STACK *stack, int arg_count);
static int _ROOM_END(SPI_STACK *stack, int arg_count);

/**
 *
 * Names and connection flags of parts for generated dungeon cells.
 *
 */
AUTOMAP_PARTS_INFO PartsInfoData[277] = {
    {"way00",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z,                                           0,                                       {0, 0, 0, 0, 0, 0, 0, 0}        },
    {"way01",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                                           0,                                       {1, 1, 1, 1, 1, 1, 1, 1}        },
    {"way02",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z,                                           0,                                       {2, 2, 2, 2, 2, 2, 2, 2}        },
    {"way03",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                                           0,                                       {3, 3, 3, 3, 3, 3, 3, 3}        },
    {"way04",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z,                                           0,                                       {0, 0, 0, 0, 0, 0, 0, 0}        },
    {"way05",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                                           0,                                       {1, 1, 1, 1, 1, 1, 1, 1}        },
    {"way06",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z,                                           0,                                       {2, 2, 2, 2, 2, 2, 2, 2}        },
    {"way07",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                                           0,                                       {3, 3, 3, 3, 3, 3, 3, 3}        },
    {"way08",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {4, 4, 4, 4, 4, 4, 4, 4}        },
    {"way09",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {5, 5, 5, 5, 5, 5, 5, 5}        },
    {"way10",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {6, 6, 6, 6, 6, 6, 6, 6}        },
    {"way11",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {7, 7, 7, 7, 7, 7, 7, 7}        },
    {"way12",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {4, 4, 4, 4, 4, 4, 4, 4}        },
    {"way13",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {5, 5, 5, 5, 5, 5, 5, 5}        },
    {"way14",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {6, 6, 6, 6, 6, 6, 6, 6}        },
    {"way15",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {7, 7, 7, 7, 7, 7, 7, 7}        },
    {"way16",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {8, 8, 0, 8, 8, 8, 8, 8}        },
    {"way17",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {9, 9, 1, 9, 9, 9, 9, 9}        },
    {"way18",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {10, 10, 2, 10, 10, 10, 10, 10} },
    {"way19",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {11, 11, 3, 11, 11, 11, 11, 11} },
    {"way20",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {12, 12, 0, 12, 12, 12, 12, 12} },
    {"way21",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {13, 13, 1, 13, 13, 13, 13, 13} },
    {"way22",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {14, 14, 2, 14, 14, 14, 14, 14} },
    {"way23",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {15, 15, 3, 15, 15, 15, 15, 15} },
    {"way24",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {12, 12, 16, 12, 12, 12, 12, 12}},
    {"way25",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {13, 13, 17, 13, 13, 13, 13, 13}},
    {"way26",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {14, 14, 18, 14, 14, 14, 14, 14}},
    {"way27",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {15, 15, 19, 15, 15, 15, 15, 15}},
    {"way28",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_Z,                                                                0,                                       {16, 16, 16, 16, 16, 16, 16, 16}},
    {"way29",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_X,                                                                0,                                       {17, 17, 19, 17, 17, 17, 17, 17}},
    {"way30",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_NEG_Z,                                                                0,                                       {18, 18, 18, 18, 18, 18, 18, 18}},
    {"way31",  AUTOMAP_KIND_ROAD,                                                                           AUTOMAP_LINK_POS_X,                                                                0,                                       {19, 19, 17, 19, 19, 19, 19, 19}},
    {"way32",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_Z,                                                                0,                                       {20, 20, 22, 20, 20, 20, 20, 20}},
    {"way33",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_X,                                                                0,                                       {21, 21, 21, 21, 21, 21, 21, 21}},
    {"way34",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_Z,                                                                0,                                       {22, 22, 22, 22, 22, 22, 22, 22}},
    {"way35",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_X,                                                                0,                                       {23, 23, 21, 23, 23, 23, 23, 23}},
    {"way36",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_Z,                                                                0,                                       {24, 24, 24, 24, 24, 24, 24, 24}},
    {"way37",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_X,                                                                0,                                       {25, 25, 25, 25, 25, 25, 25, 25}},
    {"way38",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_Z,                                                                0,                                       {26, 26, 24, 26, 26, 26, 26, 26}},
    {"way39",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_X,                                                                0,                                       {27, 27, 25, 27, 27, 27, 27, 27}},
    {"way40",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_Z,                                                                0,                                       {24, 24, 24, 24, 24, 24, 24, 24}},
    {"way41",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_X,                                                                0,                                       {25, 25, 25, 25, 25, 25, 25, 25}},
    {"way42",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_Z,                                                                0,                                       {26, 26, 24, 26, 26, 26, 26, 26}},
    {"way43",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_X,                                                                0,                                       {27, 27, 25, 27, 27, 27, 27, 27}},
    {"way44",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_Z,                                                                0,                                       {24, 24, 24, 24, 24, 24, 24, 24}},
    {"way45",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_X,                                                                0,                                       {25, 25, 25, 25, 25, 25, 25, 25}},
    {"way46",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_Z,                                                                0,                                       {26, 26, 24, 26, 26, 26, 26, 26}},
    {"way47",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_X,                                                                0,                                       {27, 27, 25, 27, 27, 27, 27, 27}},
    {"way48",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_Z,                                                                0,                                       {24, 24, 24, 24, 24, 24, 24, 24}},
    {"way49",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_X,                                                                0,                                       {25, 25, 25, 25, 25, 25, 25, 25}},
    {"way50",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_NEG_Z,                                                                0,                                       {26, 26, 24, 26, 26, 26, 26, 26}},
    {"way51",  AUTOMAP_KIND_ROAD_END,                                                                       AUTOMAP_LINK_POS_X,                                                                0,                                       {27, 27, 25, 27, 27, 27, 27, 27}},
    {"room00", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 28, 28, 28, 28, 28, 28}},
    {"room01", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 29, 29, 29, 29, 29, 29}},
    {"room02", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 30, 30, 30, 30, 30, 30}},
    {"room03", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 31, 31, 31, 31, 31, 31}},
    {"room04", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 36, 28, 28, 28, 28, 28}},
    {"room05", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 37, 29, 29, 29, 29, 29}},
    {"room06", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 38, 30, 30, 30, 30, 30}},
    {"room07", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 39, 31, 31, 31, 31, 31}},
    {"room08", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {32, 32, 46, 32, 32, 32, 32, 32}},
    {"room09", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {33, 33, 47, 33, 33, 33, 33, 33}},
    {"room10", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {34, 34, 48, 34, 34, 34, 34, 34}},
    {"room11", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {35, 35, 49, 35, 35, 35, 35, 35}},
    {"room12", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {32, 32, 0, 32, 32, 32, 32, 32} },
    {"room13", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {33, 33, 1, 33, 33, 33, 33, 33} },
    {"room14", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {34, 34, 2, 34, 34, 34, 34, 34} },
    {"room15", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {35, 35, 3, 35, 35, 35, 35, 35} },
    {"room16", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {36, 36, 36, 36, 36, 36, 36, 36}},
    {"room17", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {37, 37, 37, 37, 37, 37, 37, 37}},
    {"room18", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {38, 38, 38, 38, 38, 38, 38, 38}},
    {"room19", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {39, 39, 39, 39, 39, 39, 39, 39}},
    {"room20", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {36, 36, 36, 36, 36, 36, 36, 36}},
    {"room21", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {37, 37, 37, 37, 37, 37, 37, 37}},
    {"room22", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {38, 38, 38, 38, 38, 38, 38, 38}},
    {"room23", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {39, 39, 39, 39, 39, 39, 39, 39}},
    {"room24", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {40, 40, 40, 40, 40, 40, 40, 40}},
    {"room25", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {41, 41, 41, 41, 41, 41, 41, 41}},
    {"room26", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {40, 40, 40, 40, 40, 40, 40, 40}},
    {"room27", AUTOMAP_KIND_ROOM,                                                                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {41, 41, 41, 41, 41, 41, 41, 41}},
    {"door00", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z,                      {42, 42, 40, 42, 42, 42, 42, 42}},
    {"door01", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_X,                      {43, 43, 40, 43, 43, 43, 43, 43}},
    {"door02", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z,                      {44, 44, 40, 44, 44, 44, 44, 44}},
    {"door03", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_X,                      {45, 45, 40, 45, 45, 45, 45, 45}},
    {"door04", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_Z,                      {46, 46, 46, 46, 46, 46, 46, 46}},
    {"door05", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {47, 47, 47, 47, 47, 47, 47, 47}},
    {"door06", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_Z,                      {48, 48, 48, 48, 48, 48, 48, 48}},
    {"door07", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_NEG_X,                      {49, 49, 49, 49, 49, 49, 49, 49}},
    {"door08", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_NEG_Z,                      {50, 50, 50, 50, 50, 50, 50, 50}},
    {"door09", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {51, 51, 51, 51, 51, 51, 51, 51}},
    {"door10", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_Z,                      {52, 52, 52, 52, 52, 52, 52, 52}},
    {"door11", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_X,                      {53, 53, 53, 53, 53, 53, 53, 53}},
    {"door12", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_Z,                      {54, 54, 54, 54, 54, 54, 54, 54}},
    {"door13", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_X,                      {55, 55, 55, 55, 55, 55, 55, 55}},
    {"door14", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_Z,                      {56, 56, 56, 56, 56, 56, 56, 56}},
    {"door15", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_X,                      {57, 57, 57, 57, 57, 57, 57, 57}},
    {"door16", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_X,                      {58, 58, 58, 58, 58, 58, 58, 58}},
    {"door17", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_Z,                      {59, 59, 59, 59, 59, 59, 59, 59}},
    {"door18", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {60, 60, 60, 60, 60, 60, 60, 60}},
    {"door19", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_POS_Z,                      {61, 61, 61, 61, 61, 61, 61, 61}},
    {"door20", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_X,                      {62, 62, 62, 62, 62, 62, 62, 62}},
    {"door21", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_NEG_Z,                      {63, 63, 63, 63, 63, 63, 63, 63}},
    {"door22", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_X,                      {64, 64, 64, 64, 64, 64, 64, 64}},
    {"door23", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_DOOR,                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_POS_Z,                      {65, 65, 65, 65, 65, 65, 65, 65}},
    {"door24", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X, {82, 82, 82, 82, 82, 82, 82, 82}},
    {"door25", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X, {83, 83, 83, 83, 83, 83, 83, 83}},
    {"door26", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X, {84, 84, 84, 84, 84, 84, 84, 84}},
    {"door27", AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ENTRANCE,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X, {85, 85, 85, 85, 85, 85, 85, 85}},
    {"room28", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 28, 28, 28, 28, 28, 28}},
    {"room29", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 29, 29, 29, 29, 29, 29}},
    {"room30", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 30, 30, 30, 30, 30, 30}},
    {"room31", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 31, 40, 31, 31, 31, 31}},
    {"room32", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 28, 40, 28, 28, 28, 28}},
    {"room33", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 29, 29, 29, 29, 29, 29}},
    {"room34", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 30, 40, 30, 30, 30, 30}},
    {"room35", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 31, 47, 31, 31, 31, 31}},
    {"room36", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {32, 32, 32, 46, 32, 32, 32, 32}},
    {"room37", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {33, 33, 33, 33, 33, 33, 33, 33}},
    {"room38", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {34, 34, 34, 34, 34, 34, 34, 34}},
    {"room39", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {35, 35, 35, 71, 35, 35, 35, 35}},
    {"room40", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {32, 32, 32, 40, 32, 32, 32, 32}},
    {"room41", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {33, 33, 33, 40, 33, 33, 33, 33}},
    {"room42", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {34, 34, 34, 40, 34, 34, 34, 34}},
    {"room43", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {35, 35, 35, 72, 35, 35, 35, 35}},
    {"room44", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {36, 36, 36, 40, 36, 36, 36, 36}},
    {"room45", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {37, 37, 37, 37, 37, 37, 37, 37}},
    {"room46", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {38, 38, 38, 38, 38, 38, 38, 38}},
    {"room47", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {39, 39, 39, 40, 39, 39, 39, 39}},
    {"room48", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {36, 36, 36, 40, 36, 36, 36, 36}},
    {"room49", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {37, 37, 37, 37, 37, 37, 37, 37}},
    {"room50", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {38, 38, 38, 38, 38, 38, 38, 38}},
    {"room51", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {39, 39, 39, 39, 39, 39, 39, 39}},
    {"room52", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {40, 40, 40, 40, 40, 40, 40, 40}},
    {"room53", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {41, 41, 41, 40, 41, 41, 41, 41}},
    {"room54", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {40, 40, 40, 40, 40, 40, 40, 40}},
    {"room55", AUTOMAP_KIND_ROOM_ALT,                                                                       AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {41, 41, 41, 40, 41, 41, 41, 41}},
    {"room56", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_HEALING,                                                AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {28, 28, 0, 28, 28, 28, 28, 28} },
    {"room57", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_HEALING,                                                AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {29, 29, 1, 29, 29, 29, 29, 29} },
    {"room58", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_HEALING,                                                AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {30, 30, 2, 30, 30, 30, 30, 30} },
    {"room59", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_HEALING,                                                AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {31, 31, 3, 31, 31, 31, 31, 31} },
    {"door28", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z,                      {42, 42, 42, 48, 42, 42, 42, 42}},
    {"door29", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_X,                      {43, 43, 43, 49, 43, 43, 43, 43}},
    {"door30", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z,                      {44, 44, 44, 54, 44, 44, 44, 44}},
    {"door31", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_X,                      {45, 45, 45, 45, 45, 45, 45, 45}},
    {"door32", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_Z,                      {46, 46, 28, 46, 46, 46, 46, 46}},
    {"door33", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {47, 47, 29, 47, 47, 47, 47, 47}},
    {"door34", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_Z,                      {48, 48, 30, 48, 48, 48, 48, 48}},
    {"door35", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_NEG_X,                      {49, 49, 31, 49, 49, 49, 49, 49}},
    {"door36", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_NEG_Z,                      {50, 50, 50, 50, 50, 50, 50, 50}},
    {"door37", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {51, 51, 51, 55, 51, 51, 51, 51}},
    {"door38", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_Z,                      {52, 52, 52, 56, 52, 52, 52, 52}},
    {"door39", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_X,                      {53, 53, 53, 53, 53, 53, 53, 53}},
    {"door40", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_Z,                      {54, 54, 54, 54, 54, 54, 54, 54}},
    {"door41", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_X,                      {55, 55, 55, 55, 55, 55, 55, 55}},
    {"door42", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_Z,                      {56, 56, 56, 56, 56, 56, 56, 56}},
    {"door43", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_X,                      {57, 57, 57, 57, 57, 57, 57, 57}},
    {"door44", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_X,                      {58, 58, 58, 58, 58, 58, 58, 58}},
    {"door45", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_Z,                      {59, 59, 59, 57, 59, 59, 59, 59}},
    {"door46", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {60, 60, 60, 62, 60, 60, 60, 60}},
    {"door47", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_POS_Z,                      {61, 61, 61, 61, 61, 61, 61, 61}},
    {"door48", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_X,                      {62, 62, 62, 62, 62, 62, 62, 62}},
    {"door49", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_NEG_Z,                      {63, 63, 63, 63, 63, 63, 63, 63}},
    {"door50", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_X,                      {64, 64, 64, 64, 64, 64, 64, 64}},
    {"door51", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_POS_Z,                      {65, 65, 65, 65, 65, 65, 65, 65}},
    {"door52", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X, {82, 82, 82, 82, 82, 82, 82, 82}},
    {"door53", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X, {83, 83, 83, 83, 83, 83, 83, 83}},
    {"door54", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X, {84, 84, 84, 84, 84, 84, 84, 84}},
    {"door55", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE,                                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X, {85, 85, 85, 85, 85, 85, 85, 85}},
    {"part00", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {66, 66, 66, 66, 66, 66, 66, 66}},
    {"part01", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {67, 67, 67, 66, 67, 67, 67, 67}},
    {"part02", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {68, 68, 68, 68, 68, 68, 68, 68}},
    {"part03", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {69, 69, 69, 69, 69, 69, 69, 69}},
    {"part04", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {66, 66, 66, 68, 66, 66, 66, 66}},
    {"part05", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {67, 67, 67, 63, 67, 67, 67, 67}},
    {"part06", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {68, 68, 68, 64, 68, 68, 68, 68}},
    {"part07", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {69, 69, 69, 69, 69, 69, 69, 69}},
    {"part08", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {70, 70, 70, -1, 70, 70, 70, 70}},
    {"part09", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {71, 71, 71, 40, 71, 71, 71, 71}},
    {"part10", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {72, 72, 72, 72, 72, 72, 72, 72}},
    {"part11", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {73, 73, 73, 73, 73, 73, 73, 73}},
    {"part12", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {70, 70, 70, 65, 70, 70, 70, 70}},
    {"part13", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {71, 71, 71, 70, 71, 71, 71, 71}},
    {"part14", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {72, 72, 72, 72, 72, 72, 72, 72}},
    {"part15", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {73, 73, 73, 73, 73, 73, 73, 73}},
    {"part16", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {74, 74, 74, -1, 74, 74, 74, 74}},
    {"part17", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {75, 75, 75, -1, 75, 75, 75, 75}},
    {"part18", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {76, 76, 76, 76, 76, 76, 76, 76}},
    {"part19", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {77, 77, 77, -1, 77, 77, 77, 77}},
    {"part20", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {74, 74, 74, -1, 74, 74, 74, 74}},
    {"part21", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {75, 75, 75, -1, 75, 75, 75, 75}},
    {"part22", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {76, 76, 76, 76, 76, 76, 76, 76}},
    {"part23", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {77, 77, 77, 77, 77, 77, 77, 77}},
    {"part24", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {78, 78, 78, 78, 78, 78, 78, 78}},
    {"part25", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {79, 79, 79, 79, 79, 79, 79, 79}},
    {"part26", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {80, 80, 80, 80, 80, 80, 80, 80}},
    {"part27", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {81, 81, 81, 81, 81, 81, 81, 81}},
    {"part28", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {78, 78, 78, 78, 78, 78, 78, 78}},
    {"part29", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {79, 79, 79, 79, 79, 79, 79, 79}},
    {"part30", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {80, 80, 80, 80, 80, 80, 80, 80}},
    {"part31", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_PART,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {81, 81, 81, 81, 81, 81, 81, 81}},
    {"step00", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40,                         AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 33, 28, 28, 28, 28, 28}},
    {"step01", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40,                         AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 33, 29, 29, 29, 29, 29}},
    {"step02", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40,                         AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 33, 30, 30, 30, 30, 30}},
    {"step03", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40,                         AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 33, 31, 31, 31, 31, 31}},
    {"step04", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80,                         AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 33, 28, 28, 28, 28, 28}},
    {"step05", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80,                         AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 33, 29, 29, 29, 29, 29}},
    {"step06", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80,                         AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 33, 30, 30, 30, 30, 30}},
    {"step07", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80,                         AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 33, 31, 31, 31, 31, 31}},
    {"step08", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 33, 28, 28, 28, 28, 28}},
    {"step09", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 33, 29, 29, 29, 29, 29}},
    {"step10", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 33, 30, 30, 30, 30, 30}},
    {"step11", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 33, 31, 31, 31, 31, 31}},
    {"step12", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {28, 28, 33, 28, 28, 28, 28, 28}},
    {"step13", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      0,                                       {29, 29, 33, 29, 29, 29, 29, 29}},
    {"step14", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      0,                                       {30, 30, 33, 30, 30, 30, 30, 30}},
    {"step15", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      0,                                       {31, 31, 33, 31, 31, 31, 31, 31}},
    {"step16", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {32, 32, 33, 32, 32, 32, 32, 32}},
    {"step17", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {33, 33, 33, 33, 33, 33, 33, 33}},
    {"step18", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {34, 34, 33, 34, 34, 34, 34, 34}},
    {"step19", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {35, 35, 35, 35, 35, 35, 35, 35}},
    {"step20", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {32, 32, 32, 32, 32, 32, 32, 32}},
    {"step21", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {33, 33, 33, 33, 33, 33, 33, 33}},
    {"step22", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           0,                                       {34, 34, 33, 34, 34, 34, 34, 34}},
    {"step23", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           0,                                       {35, 35, 33, 35, 35, 35, 35, 35}},
    {"step24", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {36, 36, 33, 36, 36, 36, 36, 36}},
    {"step25", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {37, 37, 33, 37, 37, 37, 37, 37}},
    {"step26", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {38, 38, 33, 38, 38, 38, 38, 38}},
    {"step27", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {39, 39, 33, 39, 39, 39, 39, 39}},
    {"step28", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {36, 36, 33, 36, 36, 36, 36, 36}},
    {"step29", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {37, 37, 33, 37, 37, 37, 37, 37}},
    {"step30", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {38, 38, 33, 38, 38, 38, 38, 38}},
    {"step31", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_STEP,                                                   AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, 0,                                       {39, 39, 33, 39, 39, 39, 39, 39}},
    {"door56", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z,                      {42, 42, 42, 42, 42, 42, 42, 42}},
    {"door57", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_X,                      {43, 43, 43, 43, 43, 43, 43, 43}},
    {"door58", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z,                      {44, 44, 44, 44, 44, 44, 44, 44}},
    {"door59", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_40, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_X,                      {45, 45, 45, 45, 45, 45, 45, 45}},
    {"door60", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z,                      {46, 46, 46, 46, 46, 46, 46, 46}},
    {"door61", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_X,                      {47, 47, 47, 47, 47, 47, 47, 47}},
    {"door62", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z,                      {48, 48, 48, 48, 48, 48, 48, 48}},
    {"door63", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP | AUTOMAP_KIND_UNKNOWN_80, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_X,                      {49, 49, 49, 49, 49, 49, 49, 49}},
    {"door64", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z,                      {42, 42, 42, 42, 42, 42, 42, 42}},
    {"door65", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_X,                      {43, 43, 43, 43, 43, 43, 43, 43}},
    {"door66", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z,                      {44, 44, 44, 44, 44, 44, 44, 44}},
    {"door67", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_X,                      {45, 45, 45, 45, 45, 45, 45, 45}},
    {"door68", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_Z,                      {46, 46, 46, 46, 46, 46, 46, 46}},
    {"door69", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {47, 47, 47, 47, 47, 47, 47, 47}},
    {"door70", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_Z,                      {48, 48, 48, 48, 48, 48, 48, 48}},
    {"door71", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_NEG_X,                      {49, 49, 49, 49, 49, 49, 49, 49}},
    {"door72", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_NEG_Z,                      {50, 50, 50, 50, 50, 50, 50, 50}},
    {"door73", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {51, 51, 51, 51, 51, 51, 51, 51}},
    {"door74", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_Z,                      {52, 52, 52, 52, 52, 52, 52, 52}},
    {"door75", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_X,                      {53, 53, 53, 53, 53, 53, 53, 53}},
    {"door76", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_Z,                      {54, 54, 54, 54, 54, 54, 54, 54}},
    {"door77", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_X,                      {55, 55, 55, 55, 55, 55, 55, 55}},
    {"door78", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_Z,                      {56, 56, 56, 56, 56, 56, 56, 56}},
    {"door79", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_X,                      {57, 57, 57, 57, 57, 57, 57, 57}},
    {"door80", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_X,                      {58, 58, 58, 58, 58, 58, 58, 58}},
    {"door81", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_Z,                      {59, 59, 59, 59, 59, 59, 59, 59}},
    {"door82", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {60, 60, 60, 60, 60, 60, 60, 60}},
    {"door83", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_POS_Z,                      {61, 61, 61, 61, 61, 61, 61, 61}},
    {"door84", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_NEG_X,                      {62, 62, 62, 62, 62, 62, 62, 62}},
    {"door85", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_NEG_Z,                      {63, 63, 63, 63, 63, 63, 63, 63}},
    {"door86", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X,                                           AUTOMAP_LINK_POS_X,                      {64, 64, 64, 64, 64, 64, 64, 64}},
    {"door87", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_STEP,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X,                                           AUTOMAP_LINK_POS_Z,                      {65, 65, 65, 65, 65, 65, 65, 65}},
    {"door88", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_NEG_X, {82, 82, 82, 82, 82, 82, 82, 82}},
    {"door89", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X, {83, 83, 83, 83, 83, 83, 83, 83}},
    {"door90", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X, {84, 84, 84, 84, 84, 84, 84, 84}},
    {"door91", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_STEP,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X, {85, 85, 85, 85, 85, 85, 85, 85}},
    {"door92", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_PART,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_Z,                      {42, 42, 42, 42, 42, 42, 42, 42}},
    {"door93", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_PART,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_X,                      {43, 43, 43, 43, 43, 43, 43, 43}},
    {"door94", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_PART,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_POS_Z,                      {44, 44, 44, 44, 44, 44, 44, 44}},
    {"door95", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_ENTRANCE | AUTOMAP_KIND_PART,                           AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X, AUTOMAP_LINK_NEG_X,                      {45, 45, 45, 45, 45, 45, 45, 45}},
    {"door96", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_PART,                               AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_NEG_Z,                      {46, 46, 46, 46, 46, 46, 46, 46}},
    {"door97", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_PART,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_X,                      {47, 47, 47, 47, 47, 47, 47, 47}},
    {"door98", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_PART,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_X | AUTOMAP_LINK_NEG_X,                      AUTOMAP_LINK_POS_Z,                      {48, 48, 48, 48, 48, 48, 48, 48}},
    {"door99", AUTOMAP_KIND_ROOM_ALT | AUTOMAP_KIND_DOOR | AUTOMAP_KIND_PART,                               AUTOMAP_LINK_NEG_Z | AUTOMAP_LINK_POS_Z | AUTOMAP_LINK_POS_X,                      AUTOMAP_LINK_NEG_X,                      {49, 49, 49, 49, 49, 49, 49, 49}},
    {"",       0,                                                                                           0,                                                                                 0,                                       {0, 0, 0, 0, 0, 0, 0, 0}        }
};

/**
 *
 * Mini map tile indices for each dungeon map and generated part.
 *
 */
MINIMAP_INFO MiniMapInfoData[18] = {
    {"d01f01",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 152, 153, 154, 155, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                              },
    {"d02f01",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 1, 0, 3, 2, 1, 0, 3, 2, 4, 5, 6, 7, 4, 5, 6, 7, 6, 7, 4, 5, 6, 7, 4, 5, 94, 95, 94, 95, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 8, 9, 10, 11, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 176, 177, 178, 179, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                },
    {"d02f01r", {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 1, 0, 3, 2, 1, 0, 3, 2, 4, 5, 6, 7, 4, 5, 6, 7, 6, 7, 4, 5, 6, 7, 4, 5, 94, 95, 94, 95, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 8, 9, 10, 11, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 176, 177, 178, 179, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                },
    {"d03f01",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 18, 17, 16, 19, 16, 19, 18, 17, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 36, 37, 38, 39, 44, 45, 46, 47, 0, 1, 2, 3, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 56, 57, 58, 59, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                                                                                            },
    {"d03f02",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 18, 17, 16, 19, 16, 19, 18, 17, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 36, 37, 38, 39, 44, 45, 46, 47, 0, 1, 2, 3, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 28, 29, 30, 31, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 56, 57, 58, 59, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                                                                                            },
    {"d03f03",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 18, 17, 16, 19, 16, 19, 18, 17, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 0, 1, 2, 3, 52, 53, 54, 55, 0, 1, 2, 3, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 28, 29, 30, 31, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 48, 49, 50, 51, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 56, 57, 58, 59, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                                                                                                },
    {"d03f01r", {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 18, 17, 16, 19, 16, 19, 18, 17, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 36, 37, 38, 39, 44, 45, 46, 47, 0, 1, 2, 3, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 56, 57, 58, 59, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                                                                                            },
    {"d03f02r", {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 18, 17, 16, 19, 16, 19, 18, 17, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 36, 37, 38, 39, 44, 45, 46, 47, 0, 1, 2, 3, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 28, 29, 30, 31, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 56, 57, 58, 59, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                                                                                            },
    {"d03f03r", {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 18, 17, 16, 19, 16, 19, 18, 17, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 0, 1, 2, 3, 52, 53, 54, 55, 0, 1, 2, 3, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 28, 29, 30, 31, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 48, 49, 50, 51, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 56, 57, 58, 59, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                                                                                                                },
    {"d04f00",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 94, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 152, 153, 154, 155, 46, 47, 48, 49, 156, 157, 158, 159, 54, 55, 56, 57, 160, 161, 162, 163, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 40, 40, 29, 40, 95, 94, 33, 34, 119, 40, 40, 40, 120, 40, 37, 38, 40, 40, 37, 38, 39, 40, 40, 40, 40, 176, 177, 178, 179, 96, 97, 102, 45, 46, 47, 48, 49, 50, 103, 104, 53, 54, 55, 56, 57, 58, 105, 110, 61, 62, 63, 64, 65, 82, 83, 84, 85, 114, 114, 116, 117, 116, 111, 112, 117, -1, 40, 120, 73, 113, 118, 72, 73, -1, -1, -1, -1, -1, -1, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
    {"d04f01",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 152, 153, 154, 155, 46, 47, 48, 49, 156, 157, 158, 159, 54, 55, 56, 57, 160, 161, 162, 163, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 176, 177, 178, 179, 152, 153, 154, 155, 46, 47, 48, 49, 156, 157, 158, 159, 54, 55, 56, 57, 160, 161, 162, 163, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 168, 169, 170, 171, 128, 129, 130, 131, 172, 173, 174, 175, 136, 137, 138, 139, 180, 181, 182, 183, 144, 145, 146, 147, 148, 149, 150, 151, 164, 165, 166, 167, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}  },
    {"d04f02",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 152, 153, 154, 155, 46, 47, 48, 49, 156, 157, 158, 159, 54, 55, 56, 57, 160, 161, 162, 163, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 40, 40, 29, 40, 95, 94, 33, 34, 119, 40, 40, 40, 120, 40, 37, 38, 40, 40, 37, 38, 39, 40, 40, 40, 40, 176, 177, 178, 179, 96, 97, 102, 45, 46, 47, 48, 49, 50, 103, 104, 53, 54, 55, 56, 57, 58, 105, 110, 61, 62, 63, 64, 65, 82, 83, 84, 85, 114, 114, 116, 117, 116, 111, 112, 117, -1, 40, 120, 73, 113, 118, 72, 73, -1, -1, -1, -1, -1, -1, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
    {"d05f01",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 176, 177, 178, 179, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                              },
    {"d05f02",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 176, 177, 178, 179, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                              },
    {"d06f01",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 152, 153, 154, 155, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                              },
    {"d06f02",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 152, 153, 154, 155, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                              },
    {"d06f03",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 152, 153, 154, 155, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                              },
    {"d07f01",  {0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 28, 29, 30, 31, 28, 29, 30, 31, 32, 33, 34, 35, 32, 33, 34, 35, 36, 37, 38, 39, 36, 37, 38, 39, 40, 41, 40, 41, 176, 177, 178, 179, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 82, 83, 84, 85, 66, 67, 68, 69, 66, 67, 68, 69, 70, 71, 72, 73, 70, 71, 72, 73, 74, 75, 76, 77, 74, 75, 76, 77, 78, 79, 80, 81, 78, 79, 80, 81, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 104, 105, 106, 107, 108, 109, 110, 111, 108, 109, 110, 111, 112, 113, 114, 115, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 86, 87, 88, 89, 90, 91, 92, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}                              }
};

/**
 *
 * Colours, sizes and visibility rules of the mini map symbols.
 *
 */
static MINIMAP_SYMBOL_INFO symbol_table[] = {
    {MINIMAP_SYMBOL_MONSTER_BLINK, 255, 0,   0,   10, 10, 1, 1},
    {MINIMAP_SYMBOL_MONSTER,       255, 0,   0,   10, 10, 0, 1},
    {MINIMAP_SYMBOL_TREASURE_BOX,  96,  64,  0,   10, 10, 0, 1},
    {MINIMAP_SYMBOL_RANDOM_CIRCLE, 255, 255, 0,   10, 10, 0, 1},
    {MINIMAP_SYMBOL_GEOSTONE,      255, 0,   180, 10, 10, 0, 1},
    {MINIMAP_SYMBOL_SPHIDA_6,      255, 0,   0,   10, 10, 1, 0},
    {MINIMAP_SYMBOL_SPHIDA_7,      0,   0,   255, 10, 10, 1, 0},
    {MINIMAP_SYMBOL_SPHIDA_4,      255, 0,   0,   14, 14, 0, 0},
    {MINIMAP_SYMBOL_SPHIDA_5,      0,   64,  255, 14, 14, 0, 0},
    {MINIMAP_SYMBOL_END,           0,   0,   0,   0,  0,  0, 0}
};

// Small uninitialised data (.sbss)
/**
 *
 * Floor generator whose room script is running.
 *
 */
static CAutoMapGen *auto_map;

/**
 *
 * Memory arena for room presets read from the current script.
 *
 */
static mgCMemory *nowPrisetStack;

/**
 *
 * Room preset receiving the current script commands.
 *
 */
static AUTOMAP_ROOM_INFO *nowPriset;

/**
 *
 * Number of room layouts read from the current script.
 *
 */
static int nowPrisetNum;

/**
 *
 * Next cell value to fill in the current room preset.
 *
 */
static s16 *nowPrisetTable;

/**
 *
 * Horizontal grid coordinate of the last navigation target.
 *
 */
static int cax;

/**
 *
 * Vertical grid coordinate of the last navigation target.
 *
 */
static int cay;

/**
 *
 * Grid position of a linked dungeon room.
 *
 */
struct ROOM_LINK_POINT {
    int x; /**< Horizontal grid position. */
    int y; /**< Vertical grid position. */
};

// Code (.text)
void CMiniMapSymbol::SetMapInfo(CMap *new_map, CAutoMapParts *new_auto_map_parts, int width, int height,
                                float cell_width, float cell_depth) {
    if (new_map == 0) {
        return;
    }

    map = new_map;
    grid = new_auto_map_parts;
    grid_w = width;
    grid_h = height;
    cell_w = cell_width;
    cell_d = cell_depth;
    parts_table = new_map->GetPlacPartsTable(&parts_num);
    CMapParts *part = parts_table;
    parts_num = 0;

    while ((part->name[0] == 0) == 0) {
        part++;
        parts_num++;
    }

    texture = mgTexManager.GetTexture("minimap1", -1);
    char *floor_name = BattleAreaScene->map_name;

    if (*floor_name == 0) {
        return;
    }

    info = 0;
    char buffer[0x40];
    strcpy(buffer, floor_name);

    if (strlen(buffer) == 7) {
        buffer[6] = 0;
    }

    for (int i = 0; i < kMiniMapInfoCount; i++) {
        char *entry_name = MiniMapInfoData[i].name;

        if (entry_name != 0 && strcmp(buffer, entry_name) == 0) {
            info = &MiniMapInfoData[i];
            break;
        }
    }

    if (info == 0) {
        return;
    }

    part = parts_table;

    if (part == 0) {
        return;
    }

    for (int i = 0; i < parts_num; i++) {
        char *parts_name = part->parts_name;
        part->minimap_tile = -1;

        for (int j = 0; PartsInfoData[j].name != 0; j++) {
            if (strcmp(PartsInfoData[j].name, parts_name) == 0) {
                part->minimap_tile = info->tile[j];
            }
        }

        part++;
    }
}

void CMiniMapSymbol::DrawSymbolOpen() {
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x80, 0x80, 0x80, 0x60);
    prim.Texture(TEX_SystenFrame);
    prim.SetScirror(x - w / 2, y - h / 2, w, h);
}

void CMiniMapSymbol::DrawSymbolClose() {
    prim.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    prim.End();
    blink_cnt++;

    if (blink_cnt > 30) {
        blink_cnt = 0;
    }
}

void CMiniMapSymbol::DrawSymbol(float *pos, int symbol) {
    float delta[4];

    if (BattleAreaScene->boss_map != 0) {
        return;
    }

    sceVu0SubVector(delta, pos, center);
    float size_x = cell_w;
    float ratio = delta[0] / size_x;
    int   screen_x = x + (int) (16.0f * ratio);
    int   screen_y = y + (int) (16.0f * (delta[2] / cell_d));
    int   cell_x = (int) ((pos[0] + 0.5f * size_x) / size_x);
    int   cell_z = (int) ((pos[2] + 0.5f * cell_d) / cell_d);
    int   revealed = 0;

    if (grid != NULL && (grid + cell_z * grid_w)[cell_x].visible != 0) {
        revealed = 1;
    }

    if (BattleAreaScene->minimap_reveal & MINIMAP_REVEAL_SYMBOLS) {
        revealed = 1;
    }

    for (MINIMAP_SYMBOL_INFO *info = symbol_table; info->symbol != MINIMAP_SYMBOL_END; info++) {
        if (info->symbol == symbol) {
            if ((info->need_visible == 0 || revealed != 0) && (info->blink == 0 || blink_cnt < 16)) {
                prim.Color(info->r, info->g, info->b, 0x80);
                prim.SetIStretch(screen_x - info->w / 2 + 8, screen_y - info->h / 2 + 8, info->w, info->w, 0xBA, 0xF6, 10, 10);
            }

            break;
        }
    }
}

void CMiniMapSymbol::DrawSymbol_Chara(CCharacter2 *chara) {
    float pos[4];
    float rot[4];

    if (chara == NULL) {
        return;
    }

    if (BattleAreaScene->boss_map != 0) {
        return;
    }

    chara->GetPosition(pos);
    chara->GetRotation(rot);
    sceVu0SubVector(pos, pos, center);
    int        screen_x = x + (int) (16.0f * (pos[0] / cell_w)) + 8;
    int        screen_y = y + (int) (16.0f * (pos[2] / cell_d)) + 8;
    float      angle = rot[1];
    CPreSprite sprite;
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.Color(0x80, 0x80, 0x80, 0x60);
    sprite.Texture(TEX_SystenFrame);
    sprite.SetScirror(x - w / 2, y - h / 2, w, h);
    int off_x = (int) (-7.0f * sinf(angle) - -6.0f * cosf(angle));
    int off_y = (int) (-6.0f * sinf(angle) + -7.0f * cosf(angle));
    sprite.TextureCrd(0xC4, 0xF2);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = (int) (-7.0f * sinf(angle) - 6.0f * cosf(angle));
    off_y = (int) (6.0f * sinf(angle) + -7.0f * cosf(angle));
    sprite.TextureCrd(0xD0, 0xF2);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = (int) (7.0f * sinf(angle) - -6.0f * cosf(angle));
    off_y = (int) (-6.0f * sinf(angle) + 7.0f * cosf(angle));
    sprite.TextureCrd(0xC4, 0x100);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = (int) (7.0f * sinf(angle) - 6.0f * cosf(angle));
    off_y = (int) (6.0f * sinf(angle) + 7.0f * cosf(angle));
    sprite.TextureCrd(0xD0, 0x100);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    sprite.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    sprite.End();
}

void CMiniMapSymbol::Draw(float *pos) {
    if (map == NULL) {
        return;
    }

    CMapParts *parts = parts_table;

    if (parts == NULL) {
        return;
    }

    if (BattleAreaScene->boss_map != 0) {
        return;
    }

    sceVu0CopyVector(center, pos);
    int dimmed = 0;

    if (BattleAreaScene->minimap_reveal & MINIMAP_REVEAL_ROOMS) {
        dimmed = 1;
    }

    CPreSprite sprite;
    CPreSprite spare;
    float      part_pos[4];
    float      delta[4];
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Texture(texture);
    sprite.Color(0x80, 0x80, 0x80, 0x60);
    sprite.SetScirror(x - w / 2, y - h / 2, w, h);

    for (int i = 0; i < parts_num; i++) {
        if ((parts->name[0] == 0) == 0) {
            int tile = parts->minimap_tile;

            if (tile == -1) {
                parts++;
                continue;
            }

            int tile_u = (tile % 16) * 16;
            int tile_v = (tile / 16) * 16;
            parts->GetPosition(part_pos);
            sceVu0SubVector(delta, part_pos, center);
            float          rate_z = delta[2] / cell_d;
            float          rate_x = delta[0] / cell_w;
            float          screen_x = (float) x + 16.0f * rate_x;
            float          screen_y = y + rate_z * 16.0f;
            float          size_d = cell_d;
            CAutoMapParts *cells = grid;

            if (cells != NULL) {
                s16            width = grid_w;
                CAutoMapParts *cell = &cells[width * (int) (part_pos[2] / size_d) + (int) (part_pos[0] / size_d)];

                if (cell->attr & AUTOMAP_ATTR_HIDE) {
                    parts++;
                    continue;
                }

                if (cell->visible != 0) {
                    sprite.Color(0x80, 0x80, 0x80, 0x80);
                } else if (dimmed != 0) {
                    sprite.Color(0x30, 0x30, 0x30, 0x80);
                } else {
                    sprite.Color(0x30, 0x30, 0x30, 0);
                }
            }

            int rect_x = (int) screen_x;
            sprite.SetIRect(rect_x, (int) screen_y, 16, 16, tile_u, tile_v);
        }

        parts++;
    }

    sprite.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    sprite.End();
}

int CHealingPoint::CheckHealingTime() {
    if (enable == 0) {
        return 0;
    }

    if (timer > 0) {
        return 0;
    }

    HealingEffectMan.SetMode((int) HEALING_EFFECT_SPENT);
    timer = kHealingCooldown;
    return 1;
}

void CHealingPoint::Step() {
    int remaining;

    if (enable != 0) {
        remaining = timer;

        if (remaining > 0) {
            timer = remaining - 1;
        }

        if (timer <= 0) {
            HealingEffectMan.SetMode((int) HEALING_EFFECT_RECHARGE);
        }
    }
}

/**
 *
 * Sets the fixed flag of the current automap room preset.
 *
 */
static int _ROOM_FIXED(SPI_STACK *stack, int arg_count) {
    nowPriset->fixed = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the automap cell width and depth from a script.
 *
 */
static int _GRID_SIZE(SPI_STACK *stack, int unused) {
    float        cell_size_x = spiGetStackFloat(stack++);
    float        cell_size_z = spiGetStackFloat(stack);
    CAutoMapGen *map = auto_map;
    map->cell_w = cell_size_x;
    map->cell_d = cell_size_z;
    return 1;
}

/**
 *
 * Sets the identifier of the current automap room preset.
 *
 */
static int _ROOM_ID(SPI_STACK *stack, int arg_count) {
    nowPriset->id = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Allocates the cell table for the current automap room preset.
 *
 */
static int _ROOM_SIZE(SPI_STACK *stack, int arg_count) {
    if (arg_count != 2) {
        return 0;
    }

    int width = spiGetStackInt(stack++);
    int height = spiGetStackInt(stack);
    u32 bytes = width * height * 4;
    nowPriset->w = width;
    nowPriset->h = height;
    u32 blocks;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    nowPriset->table = (s16 *) operator new[](bytes, nowPrisetStack->Alloc(blocks + 2));
    nowPrisetTable = nowPriset->table;
    nowPrisetNum += 1;
    return 1;
}

/**
 *
 * Sets the appearance rate of the current automap room preset.
 *
 */
static int _ROOM_RATE(SPI_STACK *stack, int arg_count) {
    nowPriset->rate = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Appends one row of cell data to the current automap room preset.
 *
 */
static int _RD(SPI_STACK *stack, int arg_count) {
    if (arg_count != nowPriset->w * 2) {
        return 0;
    }

    for (int i = 0; i < arg_count / 2; i++) {
        *nowPrisetTable++ = spiGetStackInt(stack++);
        *nowPrisetTable++ = spiGetStackInt(stack++);
    }

    return 1;
}

/**
 *
 * Advances to the next automap room preset.
 *
 */
static int _ROOM_END(SPI_STACK *stack, int arg_count) {
    nowPriset = nowPriset + 1;
    return 1;
}

/**
 *
 * Commands accepted by the dungeon room preset script interpreter.
 *
 */
static SPI_TAG_PARAM tag[] = {
    {"ROOM_FIXED", _ROOM_FIXED},
    {"GRID_SIZE",  _GRID_SIZE },
    {"ROOM_ID",    _ROOM_ID   },
    {"ROOM_SIZE",  _ROOM_SIZE },
    {"ROOM_RATE",  _ROOM_RATE },
    {"RD",         _RD        },
    {"ROOM_END",   _ROOM_END  },
    {NULL,         NULL       }
};

void CAutoMapGen::SetupRoomInfo(char *name, int length, mgCMemory *mem) {
    int i;

    room_info = new (mem->Alloc(0x62)) AUTOMAP_ROOM_INFO[64];

    for (i = 0; i < 64; i++) {
        AUTOMAP_ROOM_INFO *preset = room_info + i;
        preset->id = -1;
        preset->fixed = 0;
        preset->table = 0;
    }

    room_info_num = 0;
    nowPrisetStack = mem;
    auto_map = this;
    nowPriset = room_info;
    nowPrisetNum = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(tag);
    interpreter.SetScript(name, length);
    interpreter.Run();
    room_info_num = nowPrisetNum;
}

int CAutoMapGen::CreatRoom(int x, int y, int room_no, int info_no) {
    int                w, h;
    int                pick;
    s16               *table;
    AUTOMAP_ROOM_INFO *info;

    if (info_no == -1) {
        do {
            pick = iRand(room_info_num);

            if (room_info[pick].fixed > 0) {
                pick = -1;
            }

            if (room_info[pick].rate < iRand(100)) {
                pick = -1;
            }
        } while (pick == -1);

        info_no = pick;
    }

    info = &room_info[info_no];

    if (info->table == NULL) {
        return 0;
    }

    w = info->w;
    h = info->h;

    if (x < 0 || y < 0) {
        return 0;
    }

    if (x + w > grid_w || y + h > grid_h) {
        return 0;
    }

    for (int row = y - 1; row < y + h + 1; row++) {
        for (int col = x; col < x + w; col++) {
            if ((grid + row * grid_w)[col].kind != 0) {
                return 0;
            }
        }
    }

    for (int row = y; row < y + h; row++) {
        for (int col = x - 1; col < x + w + 1; col++) {
            if ((grid + row * grid_w)[col].kind != 0) {
                return 0;
            }
        }
    }

    table = info->table;

    for (int row = y; row < y + h; row++) {
        for (int col = x; col < x + w; col++) {
            s16 parts_no = table[0];
            s16 attr = table[1];
            table += 2;

            if (parts_no != -1) {
                (grid + row * grid_w)[col].parts_no = parts_no;
                (grid + row * grid_w)[col].attr = attr;
                (grid + row * grid_w)[col].kind = PartsInfoData[parts_no].kind;
                (grid + row * grid_w)[col].link = PartsInfoData[parts_no].link;
                (grid + row * grid_w)[col].road_link = 0;
                (grid + row * grid_w)[col].room_no = room_no;
            }
        }
    }

    room[room_no].x = x;
    room[room_no].y = y;
    room[room_no].w = w;
    room[room_no].h = h;
    return 1;
}

int CAutoMapGen::LinkConnectCheck(int x, int y, int kind, int room_no, int exclude) {
    int sides[4];
    int cell_kind;
    int count = 0;

    if (exclude != kStepDown) {
        if (y > 0) {
            cell_kind = (grid + (y - 1) * grid_w)[x].kind;
            int cell_room = (grid + (y - 1) * grid_w)[x].room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepUp;
            }
        }
    }

    if (exclude != kStepUp) {
        if (y < grid_h - 1) {
            cell_kind = (grid + (y + 1) * grid_w)[x].kind;
            int cell_room = (grid + (y + 1) * grid_w)[x].room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepDown;
            }
        }
    }

    if (exclude != kStepLeft) {
        if (x < grid_w - 1) {
            cell_kind = (grid + y * grid_w + x + 1)->kind;
            int cell_room = (grid + y * grid_w + x + 1)->room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepRight;
            }
        }
    }

    if (exclude != kStepRight) {
        if (x > 0) {
            cell_kind = (grid + y * grid_w + x - 1)->kind;
            int cell_room = (grid + y * grid_w + x - 1)->room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepLeft;
            }
        }
    }

    if (count <= 0) {
        return 0;
    }

    return sides[iRand(count)];
}

void CAutoMapGen::SetRoadLinkMark(int x, int y, int direction) {
    int nx = x;
    int ny = y;
    int mark;

    switch (direction) {
        case 1:
            ny++;
            mark = 2;
            break;
        case 2:
            ny--;
            mark = 1;
            break;
        case 4:
            nx--;
            mark = 8;
            break;
        case 8:
            nx++;
            mark = 4;
            break;
    }

    (grid + y * grid_w)[x].link |= (u8) mark;
    (grid + y * grid_w)[x].road_link |= (u8) mark;
    (grid + ny * grid_w)[nx].link |= (u8) direction;
    (grid + ny * grid_w)[nx].road_link |= (u8) direction;
}

void CAutoMapGen::RoomLink(int from, int to) {
    ROOM_LINK_POINT starts[64];
    int             dx;
    s32             steps;
    AUTOMAP_ROOM   *dst;
    int             dy;
    AUTOMAP_ROOM   *src;
    int             joined;
    int             depth;
    float           dist_y;
    int             pick;
    int             x;
    int             side;
    int             src_x;
    int             goal_y;
    int             y;
    src = &room[from];
    dst = &room[to];

    src_x = src->x + src->w / 2;
    int src_y = src->y + src->h / 2;
    int goal_x = dst->x + dst->w / 2;
    goal_y = dst->y + dst->h / 2;
    float dist_x = (float) (src_x - goal_x);

    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }

    dist_y = (float) (src_y - goal_y);
    dx = src_x - goal_x;
    dy = src_y - goal_y;

    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }

    if (!(dist_x <= dist_y)) {
        if (dx < 0) {
            side = kStepRight;
        } else {
            side = kStepLeft;
        }
    } else {
        if (dy < 0) {
            side = kStepDown;
        } else {
            side = kStepUp;
        }
    }

    if (gen_flag & AUTOMAP_GEN_FIXED_START && from == 0) {
        side = kStepRight;
    }

    int start_num = 0;
    depth = 0;

    switch (side) {
        case kStepUp:
            while (start_num <= 0) {
                for (int col = src->x; col < src->x + src->w; col++) {
                    u32 kind = (grid + (src->y + depth) * grid_w)[col].kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = col;
                        starts[start_num].y = src->y + depth;
                        start_num++;
                    }
                }

                depth++;
            }

            break;
        case kStepDown:
            while (start_num <= 0) {
                for (int col = src->x; col < src->x + src->w; col++) {
                    u32 kind = (grid + (src->y + src->h - 1 - depth) * grid_w)[col].kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = col;
                        starts[start_num].y = src->y + src->h - 1 - depth;
                        start_num++;
                    }
                }

                depth++;
            }

            break;
        case kStepRight:
            while (start_num <= 0) {
                for (int row = src->y; row < src->y + src->h; row++) {
                    u32 kind = (grid + row * grid_w + src->x + src->w - 1 - depth)->kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = src->x + src->w - 1 - depth;
                        starts[start_num].y = row;
                        start_num++;
                    }
                }

                depth++;
            }

            break;
        case kStepLeft:
            while (start_num <= 0) {
                for (int row = src->y; row < src->y + src->h; row++) {
                    u32 kind = (grid + depth + row * grid_w + src->x)->kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = src->x + depth;
                        starts[start_num].y = row;
                        start_num++;
                    }
                }

                depth++;
            }

            break;
    }

    if (start_num <= 0) {
        printf("ERR:NotFound StartLinkPoint\n");
        return;
    }

    pick = iRand(start_num);
    x = starts[pick].x;
    y = starts[pick].y;
    (grid + y * grid_w)[x].kind |= AUTOMAP_KIND_ENTRANCE;
    dist_x = dx;

    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }

    dist_y = (float) dy;

    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }

    if (!(dist_x <= dist_y)) {
        side = kStepLeft;

        if (dx < 0) {
            side = kStepRight;
        }

        float d = (float) dx;

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand((int) (d - (float) (src->w / 2))) + 1;
    } else {
        if (dy < 0) {
            side = kStepDown;
        } else {
            side = kStepUp;
        }

        float d = (float) dy;

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand((int) (d - (float) (src->h / 2))) + 1;
    }

    joined = 0;

    do {
        if (steps > 0) {
            do {
                int link = LinkConnectCheck(x, y, 1, from, side);

                if (link != 0) {
                    steps = 0;
                    side = link;
                    joined = 1;
                }

                if (link == 0) {
                    link = LinkConnectCheck(x, y, 6, from, side);

                    if (link > 0) {
                        side = link;
                        steps = 0;
                        joined = 6;
                    }
                }

                switch (side) {
                    case kStepUp:
                        y--;
                        break;
                    case kStepDown:
                        y++;
                        break;
                    case kStepRight:
                        x++;
                        break;
                    case kStepLeft:
                        x--;
                        break;
                }

                switch (joined) {
                    case 6:
                        (grid + y * grid_w)[x].kind |= 8;
                        break;
                    default:
                        (grid + y * grid_w)[x].kind |= 1;
                        break;
                }

                if (joined == 0) {
                    (grid + y * grid_w)[x].room_no = from;
                }

                SetRoadLinkMark(x, y, side);
                steps--;
            } while (steps > 0);
        }

        dx = x - goal_x;
        dist_x = (float) dx;

        if (dist_x < 0.0f) {
            dist_x = -dist_x;
        }

        dy = y - goal_y;
        dist_y = (float) dy;

        if (dist_y < 0.0f) {
            dist_y = -dist_y;
        }

        if (!(dist_x <= dist_y)) {
            if (dx < 0) {
                side = kStepRight;
            } else {
                side = kStepLeft;
            }

            float d = (float) dx;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        } else {
            if (dy < 0) {
                side = kStepDown;
            } else {
                side = kStepUp;
            }

            float d = (float) dy;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        }
    } while (joined == 0);
}

void CAutoMapGen::CreatDummyRoot(int room_no) {
    int tries = 0;
    int x;
    int y;
    int occupied;

    do {
        x = iRand(grid_w - 3);
        y = iRand(grid_h - 3);
        occupied = 0;

        for (int row = y; row < y + 3; row++) {
            for (int col = x; col < x + 3; col++) {
                occupied |= (grid + row * grid_w)[col].kind;
            }
        }

        tries++;

        if (tries >= 1000) {
            return;
        }
    } while (occupied != 0);

    AUTOMAP_ROOM *target = &room[iRand(room_num)];
    int           goal_x = target->x + target->w / 2;
    int           goal_y = target->y + target->h / 2;
    int           side;
    int           steps;
    int           dx = x - goal_x;
    float         dist_x = (float) dx;

    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }

    int   dy = y - goal_y;
    float dist_y = (float) dy;

    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }

    if (!(dist_x <= dist_y)) {
        side = dx < 0 ? kStepRight : kStepLeft;
        float d = (float) dx;

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand((int) d) + 1;
    } else {
        side = dy < 0 ? kStepDown : kStepUp;
        float d = (float) dy;

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand((int) d) + 1;
    }

    if (steps >= 2) {
        steps = 2;
    }

    int joined = 0;
    (grid + y * grid_w)[x].kind = 1;
    (grid + y * grid_w)[x].room_no = room_no;

    do {
        if (steps > 0) {
            do {
                int link = LinkConnectCheck(x, y, 1, room_no, side);

                if (link != 0) {
                    steps = 0;
                    side = link;
                    joined = 1;
                }

                if (link == 0) {
                    link = LinkConnectCheck(x, y, 6, room_no, side);

                    if (link > 0) {
                        side = link;
                        steps = 0;
                        joined = 6;
                    }
                }

                switch (side) {
                    case kStepUp:
                        y--;
                        break;
                    case kStepDown:
                        y++;
                        break;
                    case kStepRight:
                        x++;
                        break;
                    case kStepLeft:
                        x--;
                        break;
                }

                switch (joined) {
                    case 6:
                        (grid + y * grid_w)[x].kind |= 8;
                        break;
                    default:
                        (grid + y * grid_w)[x].kind |= 1;
                        break;
                }

                if (joined == 0) {
                    (grid + y * grid_w)[x].room_no = room_no;
                }

                SetRoadLinkMark(x, y, side);
                steps--;
            } while (steps > 0);
        }

        dx = x - goal_x;
        dist_x = (float) dx;

        if (dist_x < 0.0f) {
            dist_x = -dist_x;
        }

        dy = y - goal_y;
        dist_y = (float) dy;

        if (dist_y < 0.0f) {
            dist_y = -dist_y;
        }

        if (!(dist_x <= dist_y)) {
            if (dx < 0) {
                side = kStepRight;
            } else {
                side = kStepLeft;
            }

            float d = (float) dx;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        } else {
            if (dy < 0) {
                side = kStepDown;
            } else {
                side = kStepUp;
            }

            float d = dy;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        }

        if (steps >= 2) {
            steps = 2;
        }
    } while (joined == 0);
}

void CAutoMapGen::CreatTermParts() {
    CAutoMapParts *grid;
    int            open_dirs;
    int            x;
    int            y;
    int            length;
    int            direction;
    int            steps;
    int            row_width;
    int            x_off;
    int            y_off;
    CAutoMapParts *cell;
    int            pending;
    int            room_no;

    do {
        open_dirs = 0;
        x = iRand(grid_w - 4) + 2;
        y = iRand(grid_h - 4) + 2;
        row_width = grid_w;
        grid = this->grid;
        x_off = x * sizeof(CAutoMapParts);
        y_off = y * row_width;
        y_off *= sizeof(CAutoMapParts);
        cell = (CAutoMapParts *) ((u8 *) grid + y_off + x_off);

        if (cell->kind == 1) {
            if (((CAutoMapParts *) ((u8 *) grid + (y - 1) * row_width * sizeof(CAutoMapParts) + x_off))
                    ->kind == 0) {
                open_dirs |= kStepUp;
            }

            if (((CAutoMapParts *) ((u8 *) grid + (y + 1) * row_width * sizeof(CAutoMapParts) + x_off))
                    ->kind == 0) {
                open_dirs |= kStepDown;
            }

            if ((cell - 1)->kind == 0) {
                open_dirs |= kStepLeft;
            }

            if ((cell + 1)->kind == 0) {
                open_dirs |= kStepRight;
            }
        }
    } while (open_dirs == 0);

    room_no = ((CAutoMapParts *) (x_off + (y_off + (int) grid)))->room_no;

    do {
        direction = 1 << iRand(4);
    } while (!(open_dirs & direction));

    switch (direction) {
        case kStepUp:
            y--;
            break;
        case kStepDown:
            y++;
            break;
        case kStepLeft:
            x--;
            break;
        case kStepRight:
            x++;
            break;
    }

    (this->grid + y * grid_w + x)->kind |= 1;
    (this->grid + y * grid_w + x)->room_no = room_no;
    SetRoadLinkMark(x, y, direction);
    length = iRand(2);
    pending = 0;

    do {
        if (y > 0 && (this->grid + (y - 1) * grid_w + x)->kind == 0) {
            pending |= kStepUp;
        }

        if (y <= grid_h - 2 && (this->grid + (y + 1) * grid_w + x)->kind == 0) {
            pending |= kStepDown;
        }

        if (x > 0 && (this->grid + y * grid_w + x - 1)->kind == 0) {
            pending |= kStepLeft;
        }

        if (x <= grid_w - 2 && (this->grid + y * grid_w + x + 1)->kind == 0) {
            pending |= kStepRight;
        }

        if (pending == 0) {
            break;
        }

        do {
            direction = 1 << iRand(4);
        } while (!(pending & direction));

        steps = iRand(2);
        pending = 0;

        while (steps > 0) {
            switch (direction) {
                case kStepUp:
                    y--;

                    if (y < 2) {
                        steps = 0;
                    }

                    break;
                case kStepDown:
                    y++;

                    if (grid_h - 2 < y) {
                        steps = 0;
                    }

                    break;
                case kStepLeft:
                    x--;

                    if (x < 2) {
                        steps = 0;
                    }

                    break;
                case kStepRight:
                    x++;

                    if (grid_w - kTermRightMargin < x) {
                        steps = 0;
                    }

                    break;
            }

            (this->grid + y * grid_w + x)->kind |= 1;
            (this->grid + y * grid_w + x)->room_no = room_no;
            SetRoadLinkMark(x, y, direction);

            if (steps <= 0) {
                break;
            }

            switch (direction) {
                case kStepUp:
                    if ((this->grid + (y - 1) * grid_w + x)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case kStepDown:
                    if ((this->grid + (y + 1) * grid_w + x)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case kStepLeft:
                    if ((this->grid + y * grid_w + x - 1)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case kStepRight:
                    if ((this->grid + y * grid_w + x + 1)->kind != 0) {
                        steps = 0;
                    }

                    break;
            }
        }

        length--;
    } while (length > 0);
}

void CAutoMapGen::CreatDoorRoom() {
    if (iRand(100) < 50) {
        return;
    }

    int candidates[8];

    for (int i = 0; i < 8; i++) {
        candidates[i] = -1;
    }

    int candidate_num = 0;

    for (int i = 0; i < room_num; i++) {
        if (room[i].unk_0 != 0) {
            continue;
        }

        if ((gen_flag & AUTOMAP_GEN_FIXED_START) && i == 0) {
            continue;
        }

        int entrances = 0;

        for (int row = room[i].y; row < room[i].y + room[i].h; row++) {
            for (int col = room[i].x; col < room[i].x + room[i].w; col++) {
                CAutoMapParts *cell = &(grid + row * grid_w)[col];

                if (cell->parts_no >= kDoorPartsBegin && cell->parts_no < kDoorPartsEnd) {
                    entrances += 999;
                } else if (cell->kind & AUTOMAP_KIND_ENTRANCE) {
                    u8 road_link = cell->road_link;

                    if (road_link & AUTOMAP_LINK_NEG_Z) {
                        entrances++;
                    }

                    if (road_link & AUTOMAP_LINK_POS_Z) {
                        entrances++;
                    }

                    if (road_link & AUTOMAP_LINK_POS_X) {
                        entrances++;
                    }

                    if (road_link & AUTOMAP_LINK_NEG_X) {
                        entrances++;
                    }
                }
            }
        }

        if (entrances == 1) {
            candidates[candidate_num++] = i;
        }
    }

    if (candidate_num > 0) {
        door_room = -1;
        int           pick = iRand(candidate_num);
        AUTOMAP_ROOM *r = &room[candidates[pick]];

        for (int row = r->y; row < r->y + r->h; row++) {
            for (int col = r->x; col < r->x + r->w; col++) {
                CAutoMapParts *cell = &(grid + row * grid_w)[col];

                if (cell->parts_no < kDoorPartsBegin || cell->parts_no > kDoorPartsLast) {
                    if (cell->kind & AUTOMAP_KIND_ENTRANCE) {
                        cell->kind |= AUTOMAP_KIND_DOOR;
                        (grid + row * grid_w)[col].parts_no += 4;
                        door_room = candidates[pick];
                    }
                }
            }
        }
    }
}

CMapParts *CAutoMapGen::SearchDoorParts() {
    int row;
    int col;

    if (grid == NULL) {
        return 0;
    }

    for (row = 0; grid_h != 0; row++) {
        for (col = 0; col < grid_w; col++) {
            if ((this->grid + row * grid_w)[col].kind & 0x10) {
                return (this->grid + row * grid_w)[col].parts;
            }
        }
    }

    return 0;
}

void CAutoMapGen::SetPartsIndex() {
    int            y;
    int            x;
    int            i;
    int            j;
    int            flags;
    CAutoMapParts *cell;

    for (y = 0; y < grid_h; y++) {
        for (x = 0; x < grid_w; x++) {
            cell = &(grid + y * grid_w)[x];
            flags = cell->kind;

            if (flags == 0) {
                cell->parts_no = -1;
            } else if (flags & 1) {
                for (i = 0;; i++) {
                    if ((PartsInfoData[i].kind & 1) &&
                        PartsInfoData[i].link == (grid + y * grid_w)[x].road_link) {
                        (grid + y * grid_w)[x].parts_no = i;
                        break;
                    }
                }
            } else if (flags & 8) {
                printf("%d,%d [%d][%d]\n", x, y, flags, cell->road_link);

                for (j = 0; j < 0x118; j++) {
                    if (PartsInfoData[j].kind == (grid + y * grid_w)[x].kind &&
                        PartsInfoData[j].entrance == (grid + y * grid_w)[x].road_link &&
                        PartsInfoData[j].link == (grid + y * grid_w)[x].link) {
                        (grid + y * grid_w)[x].parts_no = j;
                        break;
                    }
                }
            }
        }
    }
}

void CAutoMapGen::SetDummyMountain() {
    CMap *map = DngMainScene->GetMap(0);

    if (map != NULL) {
        mgCMemory *stack = DngMainScene->GetStack(2);
        float      pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
        float      scale[4] = {1.0f, 1.0f, 1.0f, 1.0f};
        map->PlaceParts("o00", pos, pos, scale, stack);
    }
}

void CAutoMapGen::SetDummyTree() {
    s16   field[0x4000];
    float pos[4];

    int   width = grid_w + 8;
    int   height = grid_h + 8;
    CMap *map = DngMainScene->GetMap(0);

    if (map == NULL) {
        return;
    }

    for (int i = 0; i < height * width; i++) {
        field[i] = -1;
    }

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            if ((grid + row * grid_w)[col].parts_no != -1) {
                field[(row + 4) * width + col + 4] = 1;
            }
        }
    }

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            if (field[row * width + col] == -1) {
                int touches = 0;

                if (field[(row - 1) * width + col] == 1) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col] == 1) {
                    touches = 1;
                }

                if (field[row * width + col - 1] == 1) {
                    touches = 1;
                }

                if (field[row * width + col + 1] == 1) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col - 1] == 1) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col + 1] == 1) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col - 1] == 1) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col + 1] == 1) {
                    touches = 1;
                }

                if (touches != 0) {
                    field[row * width + col] = 2;
                }
            }
        }
    }

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            if (field[row * width + col] == -1) {
                int touches = 0;

                if (field[(row - 1) * width + col] == 2) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col] == 2) {
                    touches = 1;
                }

                if (field[row * width + col - 1] == 2) {
                    touches = 1;
                }

                if (field[row * width + col + 1] == 2) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col - 1] == 2) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col + 1] == 2) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col - 1] == 2) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col + 1] == 2) {
                    touches = 1;
                }

                if (touches != 0) {
                    field[row * width + col] = 3;
                }
            }
        }
    }

    mgCMemory *stack = DngMainScene->GetStack(2);
    CMapParts *parts;
    float      rot[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float      scale[4] = {1.0f, 1.0f, 1.0f, 1.0f};

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            s16 tile = field[row * width + col];

            if (tile > 1) {
                pos[0] = (float) col * cell_w - 4.0f * cell_w;
                pos[1] = 0.0f;
                pos[2] = (float) row * cell_d - 4.0f * cell_d;
                pos[3] = 1.0f;

                if (tile == 2) {
                    parts = map->PlaceParts("o00", pos, rot, scale, stack);
                }

                if (field[row * width + col] == 3) {
                    parts = map->PlaceParts("o01", pos, rot, scale, stack);
                }

                if (parts != NULL) {
                    parts->minimap_tile = -1;
                }
            }
        }
    }
}

void CAutoMapGen::SearchHealingPoint(CMap *map) {
    CMapParts  *parts;
    int         i;
    char        name[64];
    float       pos[4];
    float       offset[4];
    CFuncPoint *point;

    if (map == NULL) {
        return;
    }

    for (i = 0; i < 4; i++) {
        sprintf(name, "room5%d", i + 6);
        parts = map->GetPlaceParts(name);

        if (parts != NULL) {
            (parts)->GetPosition(pos);
            point = parts->func_point_mngr.Search("kaifuku");

            if (point != NULL) {
                *(u_long128 *) offset = *(u_long128 *) point->position;
                sceVu0AddVector(pos, pos, offset);
                HealingEffectMan.Set(pos);
                healing_point.enable = 1;
            }

            break;
        }
    }
}

void CAutoMapGen::IndexToPartsPlace() {
    float pos[4];

    CMap *map = DngMainScene->GetMap(0);

    if (map == NULL) {
        return;
    }

    DngMainScene->ClearStack(2);
    DngMainScene->AssignStack(2);
    mgCMemory *stack = DngMainScene->GetStack(2);

    if (stack == NULL) {
        return;
    }

    map->ClearPlaceParts();
    float rot[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float scale[4] = {1.0f, 1.0f, 1.0f, 1.0f};

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            CAutoMapParts *cell = &(grid + row * grid_w)[col];

            if (cell->parts_no != -1) {
                char *name = PartsInfoData[cell->parts_no].name;
                pos[0] = (float) col * cell_w;
                pos[1] = 0.0f;
                pos[2] = (float) row * cell_d;
                pos[3] = 1.0f;
                (grid + row * grid_w)[col].parts = map->PlaceParts(name, pos, rot, scale, stack);
            }
        }
    }

    SearchHealingPoint(map);

    if (gen_flag & AUTOMAP_GEN_DUMMY_TREE) {
        SetDummyTree();
    }

    if (gen_flag & AUTOMAP_GEN_DUMMY_MOUNTAIN) {
        SetDummyMountain();
    }

    pos[1] = -99999.0f;
    pos[3] = 1.0f;
    pos[0] = 0.0f;
    pos[2] = 0.0f;
    gio_parts = map->PlaceParts("p01_gio", pos, rot, scale, stack);

    for (int i = 0; i < 12; i++) {
        random_stone[i] = map->PlaceParts("obj01", pos, rot, scale, stack);
    }

    pot_parts = map->PlaceParts("obj02", pos, rot, scale, stack);
    map->PlacePartsEnd();

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            CAutoMapParts *cell = &(grid + row * grid_w)[col];

            if (cell->parts_no != -1) {
                if (cell->parts != NULL) {
                    cell->wall = cell->parts->move_flag;
                }
            }
        }
    }
}

void CAutoMapGen::SetInOutPartsIndex(int offset) {
    int candidates[64];
    int count = 0;
    int base;
    int y;
    int x;
    int pick;

    for (y = 0; y < grid_h; y++) {
        for (x = 0; x < grid_w; x++) {
            if (count >= 64) {
                break;
            }

            base = y * grid_w;
            s16 parts = (grid + base)[x].parts_no;

            if (parts >= 0x1C && parts < 0x20) {
                candidates[count++] = x + base;
            }
        }
    }

    if (count > 0) {
        printf("EXIT INDEX = %d\n", count);
        pick = iRand(count);
        grid[candidates[pick]].parts_no += offset;
    }
}

void CAutoMapGen::SetHealingPointIndex() {
    int candidates[64];
    int count = 0;
    int base;
    int y;
    int x;
    int pick;

    if (iRand(100) < 51) {
        for (y = 0; y < grid_h; y++) {
            for (x = 0; x < grid_w; x++) {
                if (count >= 64) {
                    break;
                }

                base = y * grid_w;
                s16 parts = (grid + base)[x].parts_no;

                if (parts >= 0x6C && parts < 0x74) {
                    candidates[count++] = x + base;
                }
            }
        }

        if (count > 0) {
            pick = iRand(count);
            s16 parts = grid[candidates[pick]].parts_no;
            int next;

            if (parts < 0x70) {
                next = parts + 0x1C;
            } else {
                next = parts + 0x18;
            }

            grid[candidates[pick]].parts_no = next;
        }
    }
}

void CAutoMapGen::CreatFixedMap(int preset_no) {
    CAutoMapParts     *cell;
    int                i;
    AUTOMAP_ROOM_INFO *preset = room_info + preset_no;
    int                preset_width;
    int                preset_height;
    s16               *table;
    int                y;
    int                x;

    for (i = 0; i < grid_w * grid_h; i++) {
        cell = grid + i;
        cell->parts_no = -1;
        cell->attr = 0;
        cell->kind = 0;
        cell->room_no = -1;
        cell->road_link = 0;
        cell->link = 0;
        cell->visible = 0;
        cell->wall = -1;
        cell->parts = 0;
    }

    for (i = 0; i < 8; i++) {
        room[i].unk_0 = 0;
    }

    preset_height = preset->h;
    preset_width = preset->w;
    table = preset->table;

    for (y = 0; y < preset_height; y++) {
        for (x = 0; x < preset_width; x++) {
            s16 parts_no = table[0];
            s16 attr = table[1];
            table += 2;

            if (parts_no != -1) {
                (grid + y * grid_w)[x].parts_no = parts_no;
                (grid + y * grid_w)[x].attr = attr;
                (grid + y * grid_w)[x].kind = PartsInfoData[parts_no].kind;
                (grid + y * grid_w)[x].link = PartsInfoData[parts_no].link;
                (grid + y * grid_w)[x].road_link = 0;
                (grid + y * grid_w)[x].room_no = 0;
            }
        }
    }

    room[0].x = 0;
    room[0].y = 0;
    room[0].w = preset_width;
    room[0].h = preset_height;
}

void CAutoMapGen::RandomMapMainProc() {
    int               link;
    int               i;
    int               rooms;
    int               goal;
    int               exits;
    int               seed;
    int               floor_id;
    int               round;
    int               dummy_roots;
    int               failures;
    int               to;
    int               result;
    int               n;
    CDngFloorManager *manager;
    random_map = 1;
    seed = iRand(0xFFFF);

    if (DebugFlag != 0) {
        printf("rand = %d\n", seed);
    }

    srand(seed);
    floor_id = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
    manager = &BattleAreaScene->floor_manager;

    for (i = 0; i < grid_w * grid_h; i++) {
        grid[i].Initialize();
    }

    for (n = 0; n < 8; n++) {
        room[n].unk_0 = 0;
    }

    do {
        if (gen_flag & AUTOMAP_GEN_FIXED_START) {
            CreatFixedMap(0);
            n = 1;
        } else {
            n = CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, 0, -1);
        }
    } while (n == 0);

    while (CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, 1, -1) == 0) {
    }

    RoomLink(0, 1);

    rooms = 2;
    goal = iRand(3) + 4;
    round = 0;

    while (rooms < goal) {
        failures = 0;

        do {
            result = CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, rooms, -1);
            link = iRand(rooms);

            if ((gen_flag & AUTOMAP_GEN_FIXED_START) && link == 0) {
                link++;
            }

            if (result != 0) {
                RoomLink(rooms, link);
                rooms++;
                round = 0;
                break;
            }

            failures++;
        } while (failures < 128);

        if (round > 128) {
            break;
        }

        round++;
    }

    room_num = rooms;

    n = iRand(3) + 1;

    for (link = 0; link < n;) {
        result = iRand(rooms);
        to = iRand(rooms);

        if ((!(gen_flag & AUTOMAP_GEN_FIXED_START) || (result != 0 && to != 0)) && result != to) {
            RoomLink(result, to);
            link++;
        }
    }

    dummy_roots = iRand(3) + 1;

    for (i = 0; i < dummy_roots; i++) {
        CreatDummyRoot(i + 50);
    }

    CreatTermParts();
    CreatTermParts();
    CreatTermParts();
    SetPartsIndex();

    if (!(gen_flag & AUTOMAP_GEN_NO_IN_OUT)) {
        SetInOutPartsIndex(4);
    }

    CreatDoorRoom();

    if (!(gen_flag & AUTOMAP_GEN_NO_HEALING)) {
        SetHealingPointIndex();
    }

    exits = manager->GetDngMapNextRoot(floor_id);

    if (exits & 1) {
        SetInOutPartsIndex(8);
    }

    if (exits & 2) {
        SetInOutPartsIndex(12);
    }

    if (exits & 4) {
        SetInOutPartsIndex(16);
    }

    if (exits & 8) {
        SetInOutPartsIndex(20);
    }

    IndexToPartsPlace();
}

void CAutoMapGen::Build() {
    int        floor_no;
    int        room;
    int        mode;
    CMap      *map;
    CMapParts *parts;

    minimap_enable = 1;
    navi_enable = 1;
    mode = gen_flag;

    if (mode & 0x40) {
        AUTOMAP_ROOM_INFO *preset = room_info;
        int                h = preset->h;
        grid_w = preset->w;
        grid_h = h;
        CreatFixedMap(0);
        IndexToPartsPlace();
        return;
    }

    if (mode & 2) {
        floor_no = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
        printf("%d\n", floor_no);
        room = 0;

        if (floor_no < 8) {
            if (floor_no == 5) {
                room = 0;
            } else {
                room = iRand(19) + 1;
            }
        }

        if (floor_no < 19) {
            if (floor_no >= 8) {
                if (floor_no == 11) {
                    room = 0;
                } else {
                    room = iRand(19) + 1;
                }
            }
        }

        if (floor_no >= 19) {
            room = iRand(10);
        }

        int h = room_info[room].h;
        grid_w = room_info[room].w;
        grid_h = h;
        CreatFixedMap(room);
        IndexToPartsPlace();
        return;
    }

    if (mode & 8) {
        grid_w = 20;
        grid_h = 16;
        RandomMapMainProc();
        return;
    }

    grid_w = 14;
    grid_h = 14;
    RandomMapMainProc();
    map = DngMainScene->GetMap(0);

    if (map != NULL) {
        parts = map->GetPlacPartsTable(&place_parts_num);
        place_parts_num = 0;

        if (place_parts_num > 0) {
            while ((parts->name[0] == 0) == 0) {
                parts++;
                place_parts_num++;
            }
        }
    }
}

void CAutoMapGen::MinimapVisTest(float *pos) {
    float          size_x;
    float          size_z;
    int            x;
    int            z;
    CAutoMapParts *cell;
    int            i;
    int            row;
    int            col;
    CAutoMapParts *grid = this->grid;

    if (grid != NULL && minimap_enable != 0) {
        size_x = cell_w;
        x = (int) ((pos[0] + 0.5f * size_x) / size_x);
        size_z = cell_d;
        z = (int) ((pos[2] + 0.5f * size_z) / size_z);

        if (x < 0) {
            x = 0;
        }

        if (z < 0) {
            z = 0;
        }

        (grid + z * grid_w)[x].visible = 1;
        cell = &(this->grid + z * grid_w)[x];

        if (z > 0) {
            CAutoMapParts *up = cell - grid_w;

            if (!(up->wall & 8)) {
                up->visible = 1;
            }
        }

        if (z < grid_h - 1) {
            if (!(cell[grid_w].wall & 2)) {
                cell[grid_w].visible = 1;
            }
        }

        if (x > 0 && !(cell[-1].wall & 4)) {
            cell[-1].visible = 1;
        }

        if (x < grid_w - 1 && !(cell[1].wall & 1)) {
            cell[1].visible = 1;
        }

        if (!(gen_flag & 2)) {
            for (i = 0; i < room_num; i++) {
                if (x >= room[i].x && z >= room[i].y && x < room[i].x + room[i].w &&
                    z < room[i].y + room[i].h) {
                    for (row = 0; row < room[i].h; row++) {
                        for (col = 0; col < room[i].w; col++) {
                            (&(this->grid + (room[i].y + row) * grid_w)[col])[room[i].x].visible = 1;
                        }
                    }
                }
            }
        }
    }
}

void CAutoMapGen::MinimapDoorOpen(float *pos) {
    int        x;
    int        z;
    CMapParts *door;
    int        opened;

    if (grid == NULL) {
        return;
    }

    x = (int) ((pos[0] + 0.5f * cell_w) / cell_w);
    z = (int) ((pos[2] + 0.5f * cell_d) / cell_d);
    door = (grid + z * grid_w)[x].parts;

    if (door != NULL) {
        door->minimap_tile -= 4;
        u8 link = (grid + z * grid_w)[x].road_link;
        opened = 0;

        if (link == 1) {
            opened = 2;
        }

        if (link == 2) {
            opened = 8;
        }

        if (link == 4) {
            opened = 4;
        }

        if (link == 8) {
            opened = 1;
        }

        (grid + z * grid_w)[x].wall &= ~opened;
    }
}

CMapParts *CAutoMapGen::SearchRandomStone(float *pos, float radius) {
    float stone_pos[4];
    int   i;

    for (i = 0; i < 12; i++) {
        if (random_stone[i] != NULL) {
            random_stone[i]->GetPosition(stone_pos);

            if (mgDistVector(pos, stone_pos) < radius) {
                return random_stone[i];
            }
        }
    }

    return NULL;
}

void CAutoMapGen::ClearRandomStone() {
    int i;

    for (i = 0; i < 12; i++) {
        if (random_stone[i] != NULL) {
            random_stone[i]->SetPosition(0.0f, -99999.0f, 0.0f);
        }
    }
}

void CAutoMapGen::Step() {
    healing_point.Step();
}

int CAutoMapGen::GetAttrStatus(float *pos) {
    CAutoMapParts *grid = this->grid;
    float          size_x;
    float          size_z;
    int            x;
    int            z;

    if (grid == NULL) {
        return 0;
    }

    size_x = cell_w;
    x = (int) ((pos[0] + 0.5f * size_x) / size_x);
    size_z = cell_d;
    z = (int) ((pos[2] + 0.5f * size_z) / size_z);

    if (x < 0 || !((float) x < size_x)) {
        return 1;
    }

    if (z < 0 || !((float) z < size_z)) {
        return 1;
    }

    return (grid + z * grid_w)[x].attr;
}

void CAutoMapGen::MinimapAllVisible() {
    int i;

    for (i = 0; i < grid_w * grid_h; i++) {
        grid[i].visible = 1;
    }
}

float CAutoMapGen::GetNaviDistance(float *pos) {
    float size_x;
    float size_z;
    int   x;
    int   z;
    s8    step;

    if (navi_valid == 0 || navi_enable == 0) {
        return 0.0f;
    }

    size_x = cell_w;
    x = (int) ((pos[0] + 0.5f * size_x) / size_x);
    size_z = cell_d;
    z = (int) ((pos[2] + 0.5f * size_z) / size_z);

    if (x < 0) {
        x = 0;
    }

    if (z < 0) {
        z = 0;
    }

    step = (grid + z * grid_w)[x].navi;

    if (step <= 0) {
        return -1.0f;
    }

    float distance = (float) (navi_depth - step);
    distance *= (size_x + size_z) / 2.0f;
    return distance;
}

void CAutoMapGen::UpdateNaviMap(float *pos, int depth) {
    int            steps;
    int            x;
    u32            wall;
    int            changed;
    int            z;
    int            row;
    CAutoMapParts *cell;
    int            i;
    float          size_x;
    int            col;

    if (grid == NULL || navi_enable == 0) {
        return;
    }

    navi_depth = depth;
    size_x = cell_w;
    x = (int) ((pos[0] + 0.5f * size_x) / size_x);
    float size_z = cell_d;
    z = (int) ((pos[2] + 0.5f * size_z) / size_z);

    if (x < 0) {
        x = 0;
    }

    if (z < 0) {
        z = 0;
    }

    if (x != cax || z != cay) {
        cax = x;
        cay = z;
    } else {
        return;
    }

    cell = grid;

    for (i = 0; i < grid_w * grid_h; i++) {
        if (cell->parts_no != -1) {
            cell->navi = 0;
        } else {
            cell->navi = -1;
        }

        cell++;
    }

    (grid + z * grid_w)[x].navi = depth;

    do {
        cell = grid;
        changed = 0;

        for (row = 0; row < grid_h; row++) {
            for (col = 0; col < grid_w; col++) {
                steps = cell->navi;
                wall = cell->wall;

                if (steps > 0) {
                    if (row > 0 && !(wall & AUTOMAP_WALL_NEG_Z)) {
                        int next = steps - 1;

                        if ((cell - grid_w)->navi < next && !((cell - grid_w)->wall & AUTOMAP_WALL_POS_Z)) {
                            (cell - grid_w)->navi = next;
                            changed = 1;
                        }
                    }

                    if (row < grid_h - 1 && !(wall & AUTOMAP_WALL_POS_Z)) {
                        int next = steps - 1;

                        if ((cell + grid_w)->navi < next && !((cell + grid_w)->wall & AUTOMAP_WALL_NEG_Z)) {
                            (cell + grid_w)->navi = next;
                            changed = 1;
                        }
                    }

                    if (col > 0 && !(wall & AUTOMAP_WALL_NEG_X)) {
                        int next = steps - 1;

                        if (cell[-1].navi < next && !(cell[-1].wall & AUTOMAP_WALL_POS_X)) {
                            cell[-1].navi = next;
                            changed = 1;
                        }
                    }

                    if (col < grid_w - 1 && !(wall & AUTOMAP_WALL_POS_X)) {
                        int next = steps - 1;

                        if (cell[1].navi < next && !(cell[1].wall & AUTOMAP_WALL_NEG_X)) {
                            cell[1].navi = next;
                            changed = 1;
                        }
                    }
                }

                cell++;
            }
        }
    } while (changed != 0);

    navi_valid = 1;
}
