// clang-format off
#include "platform/native_config.hpp"
#include "log/game_output.hpp"
// clang-format on

#include "common.h"
#include "mw_runtime.h"

#include <array>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <memory>
#include <optional>
#include <string>
#include <vector>

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

/**
 *
 * Names and connection flags of parts for generated dungeon cells.
 *
 */
AUTOMAP_PARTS_INFO PartsInfoData[AUTOMAP_PARTS_INFO_NUM] = {
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
MINIMAP_INFO MiniMapInfoData[MINIMAP_INFO_NUM] = {
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

/**
 *
 * Floor generator whose room script is running.
 *
 */
static CAutoMapGen *auto_map;

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

namespace {
/**
 * Resolves initialized cells only while their exact producer allocation is live.
 */
std::span<CAutoMapParts> LiveGridCells(const dc2::memory::ArenaBuffer &storage, int width, int height) {
    auto bytes = storage.Bytes();
    if (width <= 0 || height <= 0 || bytes.empty() ||
        reinterpret_cast<std::uintptr_t>(bytes.data()) % alignof(CAutoMapParts) != 0) {
        return {};
    }
    const auto cells = static_cast<std::size_t>(width) * static_cast<std::size_t>(height);
    if (cells > bytes.size() / sizeof(CAutoMapParts)) {
        return {};
    }
    return {reinterpret_cast<CAutoMapParts *>(bytes.data()), cells};
}

/**
 * Converts a projected pixel only when its integer representation is valid.
 */
std::optional<int> PixelCoordinate(double value) {
    value = std::trunc(value);
    if (!std::isfinite(value) || value < static_cast<double>(std::numeric_limits<int>::min()) ||
        value > static_cast<double>(std::numeric_limits<int>::max())) {
        return std::nullopt;
    }
    return static_cast<int>(value);
}

/**
 * Converts a finite world position only when its resulting cell is within the grid.
 */
std::optional<std::array<int, 2>> GridPoint(const float *position, float cell_width, float cell_depth,
                                            int width, int height, bool centered = true, bool clamp_negative = false) {
    if (position == nullptr || !std::isfinite(cell_width) || !std::isfinite(cell_depth) ||
        cell_width <= 0.0f || cell_depth <= 0.0f || width <= 0 || height <= 0) {
        return std::nullopt;
    }
    const auto coordinate = [centered, clamp_negative](float value, float size, int count) -> std::optional<int> {
        if (!std::isfinite(value)) {
            return std::nullopt;
        }
        double result = std::trunc(static_cast<double>(value) / static_cast<double>(size) + (centered ? 0.5 : 0.0));
        if (clamp_negative && result < 0.0) {
            result = 0.0;
        }
        if (result < 0.0 || result >= static_cast<double>(count)) {
            return std::nullopt;
        }
        return static_cast<int>(result);
    };
    const auto x = coordinate(position[0], cell_width, width);
    const auto z = coordinate(position[2], cell_depth, height);
    if (!x || !z) {
        return std::nullopt;
    }
    return std::array{*x, *z};
}

} // namespace

void CAutoMapGen::SetGridStorage(dc2::memory::ArenaBuffer storage) { grid_storage = storage; }

dc2::memory::ArenaBuffer CAutoMapGen::GridStorage() const { return grid_storage; }

std::span<CAutoMapParts> CAutoMapGen::GridCells() const { return LiveGridCells(grid_storage, grid_w, grid_h); }

std::span<CAutoMapParts> CMiniMapSymbol::GridCells() const { return LiveGridCells(grid_storage, grid_w, grid_h); }

void CMiniMapSymbol::DrawSymbol(float *pos, int symbol) {
    auto *grid = GridCells().data();
    if (grid_w > 0 && grid_h > 0 && grid == nullptr) {
        return;
    }

    if (pos == nullptr || BattleAreaScene == nullptr || BattleAreaScene->boss_map != 0 ||
        !std::isfinite(cell_w) || !std::isfinite(cell_d) || cell_w <= 0.0f || cell_d <= 0.0f) {
        return;
    }
    const double screen_x = x + 16.0 * (static_cast<double>(pos[0]) - center[0]) / cell_w;
    const double screen_y = y + 16.0 * (static_cast<double>(pos[2]) - center[2]) / cell_d;
    int          revealed = false;
    const auto   point = GridPoint(pos, cell_w, cell_d, grid_w, grid_h);
    if (grid != nullptr && point && grid[(*point)[1] * grid_w + (*point)[0]].visible) {
        revealed = true;
    }

    if (BattleAreaScene->minimap_reveal & MINIMAP_REVEAL_SYMBOLS) {
        revealed = true;
    }

    for (MINIMAP_SYMBOL_INFO *symbol_info = symbol_table; symbol_info->symbol != MINIMAP_SYMBOL_END; symbol_info++) {
        if (symbol_info->symbol == symbol) {
            if ((!symbol_info->need_visible || revealed) && (!symbol_info->blink || blink_cnt < 16)) {
                const auto left = PixelCoordinate(screen_x - symbol_info->w / 2 + 8);
                const auto top = PixelCoordinate(screen_y - symbol_info->h / 2 + 8);
                if (!left || !top) {
                    return;
                }
                prim.Color(symbol_info->r, symbol_info->g, symbol_info->b, 0x80);
                prim.SetIStretch(*left, *top, symbol_info->w, symbol_info->w, 0xBA, 0xF6, 10, 10);
            }

            break;
        }
    }
}

int CHealingPoint::CheckHealingTime() {
    if (!enable) {
        return false;
    }

    if (timer > 0) {
        return false;
    }

    HealingEffectMan.SetMode(HEALING_EFFECT_SPENT);
    timer = HEALING_POINT_COOLDOWN;
    return true;
}

void CHealingPoint::Step() {
    int remaining = {};

    if (enable) {
        remaining = timer;

        if (remaining > 0) {
            timer = remaining - 1;
        }

        if (timer <= 0) {
            HealingEffectMan.SetMode(HEALING_EFFECT_RECHARGE);
        }
    }
}

int CAutoMapGen::CreatRoom(int x, int y, int room_no, int info_no) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return 0;
    }

    int                      w = {}, h = {};
    int                      pick = {};
    const s16               *table = {};
    const AUTOMAP_ROOM_INFO *info = {};

    if (room_no < 0 || std::cmp_greater_equal(room_no, std::size(room))) {
        return 0;
    }
    const auto presets = RoomInfoView();
    if (presets.empty()) {
        return false;
    }
    if (info_no == -1) {
        if (std::ranges::none_of(presets, [](const auto &preset) {
                return preset.fixed <= 0 && preset.rate >= 0 && preset.table != nullptr && preset.w > 0 && preset.h > 0;
            })) {
            return false;
        }
        for (;;) {
            pick = iRand(room_info_num);
            const int roll = iRand(100);
            if (pick < 0 || static_cast<std::size_t>(pick) >= presets.size()) {
                continue;
            }
            const auto &preset = presets[static_cast<std::size_t>(pick)];
            if (preset.fixed <= 0 && preset.rate >= roll && preset.table != nullptr && preset.w > 0 && preset.h > 0) {
                info_no = pick;
                break;
            }
        }
    }
    if (info_no < 0 || static_cast<std::size_t>(info_no) >= presets.size()) {
        return false;
    }

    info = &room_info[info_no];

    if (info->table == nullptr) {
        return false;
    }

    w = info->w;
    h = info->h;

    if (grid == nullptr || x <= 0 || y <= 0 || x >= grid_w || y >= grid_h || w <= 0 || h <= 0 ||
        w >= grid_w - x || h >= grid_h - y) {
        return false;
    }

    for (int row = y - 1; row < y + h + 1; row++) {
        for (int col = x; col < x + w; col++) {
            if ((grid + row * grid_w)[col].kind != 0) {
                return false;
            }
        }
    }

    for (int row = y; row < y + h; row++) {
        for (int col = x - 1; col < x + w + 1; col++) {
            if ((grid + row * grid_w)[col].kind != 0) {
                return false;
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
    return true;
}

int CAutoMapGen::LinkConnectCheck(int x, int y, int kind, int room_no, int exclude) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return 0;
    }

    if (x < 0 || y < 0 || x >= grid_w || y >= grid_h) {
        return 0;
    }
    int sides[4];
    int cell_kind = {};
    int count = 0;

    if (exclude != AUTOMAP_LINK_POS_Z) {
        if (y > 0) {
            cell_kind = (grid + (y - 1) * grid_w)[x].kind;
            int cell_room = (grid + (y - 1) * grid_w)[x].room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = AUTOMAP_LINK_NEG_Z;
            }
        }
    }

    if (exclude != AUTOMAP_LINK_NEG_Z) {
        if (y < grid_h - 1) {
            cell_kind = (grid + (y + 1) * grid_w)[x].kind;
            int cell_room = (grid + (y + 1) * grid_w)[x].room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = AUTOMAP_LINK_POS_Z;
            }
        }
    }

    if (exclude != AUTOMAP_LINK_NEG_X) {
        if (x < grid_w - 1) {
            cell_kind = (grid + y * grid_w + x + 1)->kind;
            int cell_room = (grid + y * grid_w + x + 1)->room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = AUTOMAP_LINK_POS_X;
            }
        }
    }

    if (exclude != AUTOMAP_LINK_POS_X) {
        if (x > 0) {
            cell_kind = (grid + y * grid_w + x - 1)->kind;
            int cell_room = (grid + y * grid_w + x - 1)->room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = AUTOMAP_LINK_NEG_X;
            }
        }
    }

    if (count <= 0) {
        return 0;
    }

    return sides[iRand(count)];
}

void CAutoMapGen::SetRoadLinkMark(int x, int y, int direction) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    if (x < 0 || y < 0 || x >= grid_w || y >= grid_h) {
        return;
    }
    int nx = x;
    int ny = y;
    int mark{};

    switch (direction) {
        case AUTOMAP_LINK_NEG_Z:
            ny++;
            mark = AUTOMAP_LINK_POS_Z;
            break;
        case AUTOMAP_LINK_POS_Z:
            ny--;
            mark = AUTOMAP_LINK_NEG_Z;
            break;
        case AUTOMAP_LINK_POS_X:
            nx--;
            mark = AUTOMAP_LINK_NEG_X;
            break;
        case AUTOMAP_LINK_NEG_X:
            nx++;
            mark = AUTOMAP_LINK_POS_X;
            break;
        default:
            return;
    }
    if (nx < 0 || ny < 0 || nx >= grid_w || ny >= grid_h) {
        return;
    }

    (grid + y * grid_w)[x].link |= mark;
    (grid + y * grid_w)[x].road_link |= mark;
    (grid + ny * grid_w)[nx].link |= direction;
    (grid + ny * grid_w)[nx].road_link |= direction;
}

void CAutoMapGen::RoomLink(int from, int to) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    std::vector<ROOM_LINK_POINT> starts;
    int                          dx = {};
    s32                          steps = {};
    AUTOMAP_ROOM                *dst = {};
    int                          dy = {};
    AUTOMAP_ROOM                *src = {};
    int                          joined_kind = {};
    int                          depth = {};
    float                        dist_y = {};
    int                          pick = {};
    int                          x = {};
    int                          side = {};
    int                          src_x = {};
    int                          goal_y = {};
    int                          y = {};
    if (from < 0 || to < 0 || std::cmp_greater_equal(from, std::size(room)) ||
        std::cmp_greater_equal(to, std::size(room))) {
        return;
    }
    src = &room[from];
    dst = &room[to];
    const auto fits_grid = [this](const AUTOMAP_ROOM &value) {
        return value.x >= 0 && value.y >= 0 && value.w > 0 && value.h > 0 &&
               value.x < grid_w && value.y < grid_h && value.w <= grid_w - value.x && value.h <= grid_h - value.y;
    };
    if (!fits_grid(*src) || !fits_grid(*dst)) {
        return;
    }

    src_x = src->x + src->w / 2;
    int src_y = src->y + src->h / 2;
    int goal_x = dst->x + dst->w / 2;
    goal_y = dst->y + dst->h / 2;
    float dist_x = static_cast<float>(src_x - goal_x);

    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }

    dist_y = static_cast<float>(src_y - goal_y);
    dx = src_x - goal_x;
    dy = src_y - goal_y;

    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }

    if (!(dist_x <= dist_y)) {
        if (dx < 0) {
            side = AUTOMAP_LINK_POS_X;
        } else {
            side = AUTOMAP_LINK_NEG_X;
        }
    } else {
        if (dy < 0) {
            side = AUTOMAP_LINK_POS_Z;
        } else {
            side = AUTOMAP_LINK_NEG_Z;
        }
    }

    if (gen_flag & AUTOMAP_GEN_FIXED_START && from == 0) {
        side = AUTOMAP_LINK_POS_X;
    }

    depth = 0;

    switch (side) {
        case AUTOMAP_LINK_NEG_Z:
            while (starts.empty() && depth < src->h) {
                for (int col = src->x; col < src->x + src->w; col++) {
                    u32 kind = (grid + (src->y + depth) * grid_w)[col].kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts.push_back({col, src->y + depth});
                    }
                }

                depth++;
            }

            break;
        case AUTOMAP_LINK_POS_Z:
            while (starts.empty() && depth < src->h) {
                for (int col = src->x; col < src->x + src->w; col++) {
                    u32 kind = (grid + (src->y + src->h - 1 - depth) * grid_w)[col].kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts.push_back({col, src->y + src->h - 1 - depth});
                    }
                }

                depth++;
            }

            break;
        case AUTOMAP_LINK_POS_X:
            while (starts.empty() && depth < src->w) {
                for (int row = src->y; row < src->y + src->h; row++) {
                    u32 kind = (grid + row * grid_w + src->x + src->w - 1 - depth)->kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts.push_back({src->x + src->w - 1 - depth, row});
                    }
                }

                depth++;
            }

            break;
        case AUTOMAP_LINK_NEG_X:
            while (starts.empty() && depth < src->w) {
                for (int row = src->y; row < src->y + src->h; row++) {
                    u32 kind = (grid + depth + row * grid_w + src->x)->kind;

                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts.push_back({src->x + depth, row});
                    }
                }

                depth++;
            }

            break;
    }

    if (starts.empty()) {
        dc2::log::PrintGame("ERR:NotFound StartLinkPoint\n");
        return;
    }

    pick = iRand(static_cast<int>(starts.size()));
    x = starts[pick].x;
    y = starts[pick].y;
    (grid + y * grid_w)[x].kind |= AUTOMAP_KIND_ENTRANCE;
    dist_x = dx;

    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }

    dist_y = static_cast<float>(dy);

    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }

    if (!(dist_x <= dist_y)) {
        side = AUTOMAP_LINK_NEG_X;

        if (dx < 0) {
            side = AUTOMAP_LINK_POS_X;
        }

        float d = static_cast<float>(dx);

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand(static_cast<int>(d - static_cast<float>(src->w / 2))) + 1;
    } else {
        if (dy < 0) {
            side = AUTOMAP_LINK_POS_Z;
        } else {
            side = AUTOMAP_LINK_NEG_Z;
        }

        float d = static_cast<float>(dy);

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand(static_cast<int>(d - static_cast<float>(src->h / 2))) + 1;
    }

    joined_kind = AUTOMAP_KIND_NONE;

    do {
        if (steps > 0) {
            do {
                int link = LinkConnectCheck(x, y, AUTOMAP_KIND_ROAD, from, side);

                if (link != 0) {
                    steps = 0;
                    side = link;
                    joined_kind = AUTOMAP_KIND_ROAD;
                }

                if (link == 0) {
                    link = LinkConnectCheck(x, y, AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT, from, side);

                    if (link > 0) {
                        side = link;
                        steps = 0;
                        joined_kind = AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT;
                    }
                }

                switch (side) {
                    case AUTOMAP_LINK_NEG_Z:
                        y--;
                        break;
                    case AUTOMAP_LINK_POS_Z:
                        y++;
                        break;
                    case AUTOMAP_LINK_POS_X:
                        x++;
                        break;
                    case AUTOMAP_LINK_NEG_X:
                        x--;
                        break;
                }

                switch (joined_kind) {
                    case AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT:
                        (grid + y * grid_w)[x].kind |= AUTOMAP_KIND_ENTRANCE;
                        break;
                    default:
                        (grid + y * grid_w)[x].kind |= AUTOMAP_KIND_ROAD;
                        break;
                }

                if (joined_kind == AUTOMAP_KIND_NONE) {
                    (grid + y * grid_w)[x].room_no = from;
                }

                SetRoadLinkMark(x, y, side);
                steps--;
            } while (steps > 0);
        }

        dx = x - goal_x;
        dist_x = static_cast<float>(dx);

        if (dist_x < 0.0f) {
            dist_x = -dist_x;
        }

        dy = y - goal_y;
        dist_y = static_cast<float>(dy);

        if (dist_y < 0.0f) {
            dist_y = -dist_y;
        }

        if (!(dist_x <= dist_y)) {
            if (dx < 0) {
                side = AUTOMAP_LINK_POS_X;
            } else {
                side = AUTOMAP_LINK_NEG_X;
            }

            float d = static_cast<float>(dx);
            steps = iRand(static_cast<int>(d < 0.0f ? -d : d)) + 1;
        } else {
            if (dy < 0) {
                side = AUTOMAP_LINK_POS_Z;
            } else {
                side = AUTOMAP_LINK_NEG_Z;
            }

            float d = static_cast<float>(dy);
            steps = iRand(static_cast<int>(d < 0.0f ? -d : d)) + 1;
        }
    } while (joined_kind == AUTOMAP_KIND_NONE);
}

void CAutoMapGen::CreatDummyRoot(int room_no) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int tries = 0;
    int x = {};
    int y = {};
    int occupied = {};

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
    int           side = {};
    int           steps = {};
    int           dx = x - goal_x;
    float         dist_x = static_cast<float>(dx);

    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }

    int   dy = y - goal_y;
    float dist_y = static_cast<float>(dy);

    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }

    if (!(dist_x <= dist_y)) {
        side = dx < 0 ? AUTOMAP_LINK_POS_X : AUTOMAP_LINK_NEG_X;
        float d = static_cast<float>(dx);

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand(static_cast<int>(d)) + 1;
    } else {
        side = dy < 0 ? AUTOMAP_LINK_POS_Z : AUTOMAP_LINK_NEG_Z;
        float d = static_cast<float>(dy);

        if (d < 0.0f) {
            d = -d;
        }

        steps = iRand(static_cast<int>(d)) + 1;
    }

    if (steps >= 2) {
        steps = 2;
    }

    int joined_kind = AUTOMAP_KIND_NONE;
    (grid + y * grid_w)[x].kind = AUTOMAP_KIND_ROAD;
    (grid + y * grid_w)[x].room_no = room_no;

    do {
        if (steps > 0) {
            do {
                int link = LinkConnectCheck(x, y, AUTOMAP_KIND_ROAD, room_no, side);

                if (link != 0) {
                    steps = 0;
                    side = link;
                    joined_kind = AUTOMAP_KIND_ROAD;
                }

                if (link == 0) {
                    link = LinkConnectCheck(x, y, AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT, room_no, side);

                    if (link > 0) {
                        side = link;
                        steps = 0;
                        joined_kind = AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT;
                    }
                }

                switch (side) {
                    case AUTOMAP_LINK_NEG_Z:
                        y--;
                        break;
                    case AUTOMAP_LINK_POS_Z:
                        y++;
                        break;
                    case AUTOMAP_LINK_POS_X:
                        x++;
                        break;
                    case AUTOMAP_LINK_NEG_X:
                        x--;
                        break;
                }

                switch (joined_kind) {
                    case AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT:
                        (grid + y * grid_w)[x].kind |= AUTOMAP_KIND_ENTRANCE;
                        break;
                    default:
                        (grid + y * grid_w)[x].kind |= AUTOMAP_KIND_ROAD;
                        break;
                }

                if (joined_kind == AUTOMAP_KIND_NONE) {
                    (grid + y * grid_w)[x].room_no = room_no;
                }

                SetRoadLinkMark(x, y, side);
                steps--;
            } while (steps > 0);
        }

        dx = x - goal_x;
        dist_x = static_cast<float>(dx);

        if (dist_x < 0.0f) {
            dist_x = -dist_x;
        }

        dy = y - goal_y;
        dist_y = static_cast<float>(dy);

        if (dist_y < 0.0f) {
            dist_y = -dist_y;
        }

        if (!(dist_x <= dist_y)) {
            if (dx < 0) {
                side = AUTOMAP_LINK_POS_X;
            } else {
                side = AUTOMAP_LINK_NEG_X;
            }

            float d = static_cast<float>(dx);
            steps = iRand(static_cast<int>(d < 0.0f ? -d : d)) + 1;
        } else {
            if (dy < 0) {
                side = AUTOMAP_LINK_POS_Z;
            } else {
                side = AUTOMAP_LINK_NEG_Z;
            }

            float d = dy;
            steps = iRand(static_cast<int>(d < 0.0f ? -d : d)) + 1;
        }

        if (steps >= 2) {
            steps = 2;
        }
    } while (joined_kind == AUTOMAP_KIND_NONE);
}

void CAutoMapGen::CreatTermParts() {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    CAutoMapParts *cells = {};
    int            open_dirs = {};
    int            x = {};
    int            y = {};
    int            length = {};
    int            direction = {};
    int            steps = {};
    int            row_width = {};
    int            x_off = {};
    int            y_off = {};
    CAutoMapParts *cell = {};
    int            pending = {};
    int            room_no = {};

    do {
        open_dirs = 0;
        x = iRand(grid_w - 4) + 2;
        y = iRand(grid_h - 4) + 2;
        row_width = grid_w;
        cells = grid;
        x_off = x * sizeof(CAutoMapParts);
        y_off = y * row_width;
        y_off *= sizeof(CAutoMapParts);
        cell = reinterpret_cast<CAutoMapParts *>(reinterpret_cast<u8 *>(cells) + y_off + x_off);

        if (cell->kind == AUTOMAP_KIND_ROAD) {
            if ((reinterpret_cast<CAutoMapParts *>(reinterpret_cast<u8 *>(cells) + (y - 1) * row_width * sizeof(CAutoMapParts) + x_off))
                    ->kind == 0) {
                open_dirs |= AUTOMAP_LINK_NEG_Z;
            }

            if ((reinterpret_cast<CAutoMapParts *>(reinterpret_cast<u8 *>(cells) + (y + 1) * row_width * sizeof(CAutoMapParts) + x_off))
                    ->kind == 0) {
                open_dirs |= AUTOMAP_LINK_POS_Z;
            }

            if ((cell - 1)->kind == 0) {
                open_dirs |= AUTOMAP_LINK_NEG_X;
            }

            if ((cell + 1)->kind == 0) {
                open_dirs |= AUTOMAP_LINK_POS_X;
            }
        }
    } while (open_dirs == 0);

    room_no = ((CAutoMapParts *) (x_off + (y_off + (uptr) cells)))->room_no;

    do {
        direction = 1 << iRand(4);
    } while (!(open_dirs & direction));

    switch (direction) {
        case AUTOMAP_LINK_NEG_Z:
            y--;
            break;
        case AUTOMAP_LINK_POS_Z:
            y++;
            break;
        case AUTOMAP_LINK_NEG_X:
            x--;
            break;
        case AUTOMAP_LINK_POS_X:
            x++;
            break;
    }

    (grid + y * grid_w + x)->kind |= AUTOMAP_KIND_ROAD;
    (grid + y * grid_w + x)->room_no = room_no;
    SetRoadLinkMark(x, y, direction);
    length = iRand(2);
    pending = 0;

    do {
        if (y > 0 && (grid + (y - 1) * grid_w + x)->kind == 0) {
            pending |= AUTOMAP_LINK_NEG_Z;
        }

        if (y <= grid_h - 2 && (grid + (y + 1) * grid_w + x)->kind == 0) {
            pending |= AUTOMAP_LINK_POS_Z;
        }

        if (x > 0 && (grid + y * grid_w + x - 1)->kind == 0) {
            pending |= AUTOMAP_LINK_NEG_X;
        }

        if (x <= grid_w - 2 && (grid + y * grid_w + x + 1)->kind == 0) {
            pending |= AUTOMAP_LINK_POS_X;
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
                case AUTOMAP_LINK_NEG_Z:
                    y--;

                    if (y < 2) {
                        steps = 0;
                    }

                    break;
                case AUTOMAP_LINK_POS_Z:
                    y++;

                    if (grid_h - 2 < y) {
                        steps = 0;
                    }

                    break;
                case AUTOMAP_LINK_NEG_X:
                    x--;

                    if (x < 2) {
                        steps = 0;
                    }

                    break;
                case AUTOMAP_LINK_POS_X:
                    x++;

                    if (grid_w - 21 < x) {
                        steps = 0;
                    }

                    break;
            }

            (grid + y * grid_w + x)->kind |= AUTOMAP_KIND_ROAD;
            (grid + y * grid_w + x)->room_no = room_no;
            SetRoadLinkMark(x, y, direction);

            if (steps <= 0) {
                break;
            }

            switch (direction) {
                case AUTOMAP_LINK_NEG_Z:
                    if ((grid + (y - 1) * grid_w + x)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case AUTOMAP_LINK_POS_Z:
                    if ((grid + (y + 1) * grid_w + x)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case AUTOMAP_LINK_NEG_X:
                    if ((grid + y * grid_w + x - 1)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case AUTOMAP_LINK_POS_X:
                    if ((grid + y * grid_w + x + 1)->kind != 0) {
                        steps = 0;
                    }

                    break;
            }
        }

        length--;
    } while (length > 0);
}

void CAutoMapGen::CreatDoorRoom() {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    if (iRand(100) < 50) {
        return;
    }

    int candidates[8];

    for (int i = 0; i < 8; i++) {
        candidates[i] = -1;
    }

    int candidate_num = 0;

    for (int i = 0; i < room_num; i++) {
        if (room[i].no_door != 0) {
            continue;
        }

        if ((gen_flag & AUTOMAP_GEN_FIXED_START) && i == 0) {
            continue;
        }

        int entrances = 0;

        for (int row = room[i].y; row < room[i].y + room[i].h; row++) {
            for (int col = room[i].x; col < room[i].x + room[i].w; col++) {
                CAutoMapParts *cell = &(grid + row * grid_w)[col];

                if (cell->parts_no >= AUTOMAP_PARTS_STEP_DOOR && cell->parts_no < AUTOMAP_PARTS_STEP_DOOR + 8) {
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

                if (cell->parts_no < AUTOMAP_PARTS_STEP_DOOR || cell->parts_no > AUTOMAP_PARTS_STEP_DOOR + 7) {
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
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return nullptr;
    }

    int row = {};
    int col = {};

    if (grid == nullptr) {
        return nullptr;
    }

    for (row = 0; grid_h != 0; row++) {
        for (col = 0; col < grid_w; col++) {
            if ((grid + row * grid_w)[col].kind & AUTOMAP_KIND_DOOR) {
                return (grid + row * grid_w)[col].parts;
            }
        }
    }

    return nullptr;
}

void CAutoMapGen::SetPartsIndex() {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int            y = {};
    int            x = {};
    int            i = {};
    int            j = {};
    int            kind = {};
    CAutoMapParts *cell = {};

    for (y = 0; y < grid_h; y++) {
        for (x = 0; x < grid_w; x++) {
            cell = &(grid + y * grid_w)[x];
            kind = cell->kind;

            if (kind == 0) {
                cell->parts_no = -1;
            } else if (kind & AUTOMAP_KIND_ROAD) {
                for (i = 0;; i++) {
                    if ((PartsInfoData[i].kind & AUTOMAP_KIND_ROAD) &&
                        PartsInfoData[i].link == (grid + y * grid_w)[x].road_link) {
                        (grid + y * grid_w)[x].parts_no = i;
                        break;
                    }
                }
            } else if (kind & AUTOMAP_KIND_ENTRANCE) {
                dc2::log::PrintGame("%d,%d [%d][%d]\n", x, y, kind, cell->road_link);

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

    if (map != nullptr) {
        mgCMemory *stack = DngMainScene->GetStack(2);
        float      pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
        float      scale[4] = {1.0f, 1.0f, 1.0f, 1.0f};
        map->PlaceParts("o00", pos, pos, scale, stack);
    }
}

void CAutoMapGen::SetDummyTree() {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    if (DngMainScene == nullptr || grid == nullptr || grid_w <= 0 || grid_h <= 0) {
        return;
    }
    float     pos[4];
    const int width = grid_w + 8;
    const int height = grid_h + 8;
    CMap     *map = DngMainScene->GetMap(0);
    if (map == nullptr) {
        return;
    }
    std::vector<s16> field(static_cast<std::size_t>(width) * static_cast<std::size_t>(height), -1);

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            if ((grid + row * grid_w)[col].parts_no != -1) {
                field[(row + 4) * width + col + 4] = 1;
            }
        }
    }

    for (int row = 1; row < height - 1; row++) {
        for (int col = 1; col < width - 1; col++) {
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

    for (int row = 1; row < height - 1; row++) {
        for (int col = 1; col < width - 1; col++) {
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
    if (stack == nullptr) {
        return;
    }
    CMapParts *parts{};
    float      rot[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float      scale[4] = {1.0f, 1.0f, 1.0f, 1.0f};

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            s16 tile = field[row * width + col];

            if (tile > 1) {
                pos[0] = static_cast<float>(col) * cell_w - 4.0f * cell_w;
                pos[1] = 0.0f;
                pos[2] = static_cast<float>(row) * cell_d - 4.0f * cell_d;
                pos[3] = 1.0f;

                if (tile == 2) {
                    parts = map->PlaceParts("o00", pos, rot, scale, stack);
                }

                if (field[row * width + col] == 3) {
                    parts = map->PlaceParts("o01", pos, rot, scale, stack);
                }

                if (parts != nullptr) {
                    parts->minimap_tile = -1;
                }
            }
        }
    }
}

void CAutoMapGen::SearchHealingPoint(CMap *map) {
    CMapParts  *parts = {};
    int         i = {};
    char        name[64];
    float       pos[4];
    float       offset[4];
    CFuncPoint *point = {};

    if (map == nullptr) {
        return;
    }

    for (i = 0; i < 4; i++) {
        std::snprintf(name, sizeof(name), "room5%d", i + 6);
        parts = map->GetPlaceParts(name);

        if (parts != nullptr) {
            parts->GetPosition(pos);
            point = parts->func_point_mngr.Search("kaifuku");

            if (point != nullptr) {
                std::memmove(offset, point->position, sizeof(float) * 4);
                sceVu0AddVector(pos, pos, offset);
                HealingEffectMan.Set(pos);
                healing_point.enable = true;
            }

            break;
        }
    }
}

void CAutoMapGen::IndexToPartsPlace() {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    float pos[4];

    CMap *map = DngMainScene->GetMap(0);

    if (map == nullptr) {
        return;
    }

    DngMainScene->ClearStack(2);
    DngMainScene->AssignStack(2);
    mgCMemory *stack = DngMainScene->GetStack(2);

    if (stack == nullptr) {
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
                pos[0] = static_cast<float>(col) * cell_w;
                pos[1] = 0.0f;
                pos[2] = static_cast<float>(row) * cell_d;
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

    for (int i = 0; i < AUTOMAP_RANDOM_STONE_MAX; i++) {
        random_stone[i] = map->PlaceParts("obj01", pos, rot, scale, stack);
    }

    pot_parts = map->PlaceParts("obj02", pos, rot, scale, stack);
    map->PlacePartsEnd();

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            CAutoMapParts *cell = &(grid + row * grid_w)[col];

            if (cell->parts_no != -1) {
                if (cell->parts != nullptr) {
                    cell->wall = cell->parts->move_flag;
                }
            }
        }
    }
}

void CAutoMapGen::SetInOutPartsIndex(int offset) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int candidates[64];
    int count = 0;
    int base = {};
    int y = {};
    int x = {};
    int pick = {};

    for (y = 0; y < grid_h; y++) {
        for (x = 0; x < grid_w; x++) {
            if (count >= 64) {
                break;
            }

            base = y * grid_w;
            s16 parts = (grid + base)[x].parts_no;

            if (parts >= AUTOMAP_PARTS_DEAD_END && parts < AUTOMAP_PARTS_DEAD_END + 4) {
                candidates[count++] = x + base;
            }
        }
    }

    if (count > 0) {
        dc2::log::PrintGame("EXIT INDEX = %d\n", count);
        pick = iRand(count);
        grid[candidates[pick]].parts_no += offset;
    }
}

void CAutoMapGen::SetHealingPointIndex() {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int candidates[64];
    int count = 0;
    int base = {};
    int y = {};
    int x = {};
    int pick = {};

    if (iRand(100) < 51) {
        for (y = 0; y < grid_h; y++) {
            for (x = 0; x < grid_w; x++) {
                if (count >= 64) {
                    break;
                }

                base = y * grid_w;
                s16 parts = (grid + base)[x].parts_no;

                if (parts >= AUTOMAP_PARTS_ROOM_ALT && parts < AUTOMAP_PARTS_ROOM_ALT + 8) {
                    candidates[count++] = x + base;
                }
            }
        }

        if (count > 0) {
            pick = iRand(count);
            s16 parts = grid[candidates[pick]].parts_no;
            int next = {};

            if (parts < AUTOMAP_PARTS_ROOM_ALT + 4) {
                next = parts - AUTOMAP_PARTS_ROOM_ALT + AUTOMAP_PARTS_HEALING;
            } else {
                next = parts - (AUTOMAP_PARTS_ROOM_ALT + 4) + AUTOMAP_PARTS_HEALING;
            }

            grid[candidates[pick]].parts_no = next;
        }
    }
}

void CAutoMapGen::CreatFixedMap(int preset_no) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    const auto presets = RoomInfoView();
    if (preset_no < 0 || static_cast<std::size_t>(preset_no) >= presets.size() || grid == nullptr) {
        return;
    }
    const auto &selected = presets[static_cast<std::size_t>(preset_no)];
    if (selected.w <= 0 || selected.h <= 0 || selected.w > grid_w || selected.h > grid_h || selected.table == nullptr) {
        return;
    }
    int                      i = {};
    const AUTOMAP_ROOM_INFO *preset = &room_info[preset_no];
    int                      preset_width = {};
    int                      preset_height = {};
    const s16               *table = {};
    int                      y = {};
    int                      x = {};

    for (i = 0; i < grid_w * grid_h; i++) {
        grid[i].Initialize();
    }

    for (i = 0; i < AUTOMAP_ROOM_MAX; i++) {
        room[i].no_door = false;
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
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int               link = {};
    int               i = {};
    int               rooms = {};
    int               goal = {};
    int               exits = {};
    int               seed = {};
    int               floor_id = {};
    int               round = {};
    int               dummy_roots = {};
    int               failures = {};
    int               to = {};
    int               result = {};
    int               n = {};
    CDngFloorManager *manager = {};
    random_map = true;
    seed = iRand(0xFFFF);

    if (DebugFlag) {
        dc2::log::PrintGame("rand = %d\n", seed);
    }

    srand(seed);
    floor_id = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
    manager = &BattleAreaScene->floor_manager;

    for (i = 0; i < grid_w * grid_h; i++) {
        grid[i].Initialize();
    }

    for (n = 0; n < AUTOMAP_ROOM_MAX; n++) {
        room[n].no_door = false;
    }

    do {
        if (gen_flag & AUTOMAP_GEN_FIXED_START) {
            CreatFixedMap(0);
            n = true;
        } else {
            n = CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, 0, -1);
        }
    } while (!n);

    while (!CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, 1, -1)) {
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

            if (result) {
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
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    if (RoomInfoView().empty() || grid == nullptr) {
        minimap_enable = false;
        navi_enable = false;
        return;
    }
    int        floor_no = {};
    int        preset_no = {};
    int        mode = {};
    CMap      *map = {};
    CMapParts *parts = {};

    minimap_enable = true;
    navi_enable = true;
    mode = gen_flag;

    if (mode & AUTOMAP_GEN_FIXED_FLOOR) {
        const AUTOMAP_ROOM_INFO *preset = room_info;
        int                      h = preset->h;
        grid_w = preset->w;
        grid_h = h;
        CreatFixedMap(0);
        IndexToPartsPlace();
        return;
    }

    if (mode & AUTOMAP_GEN_PRESET_FLOOR) {
        floor_no = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
        dc2::log::PrintGame("%d\n", floor_no);
        preset_no = 0;

        if (floor_no < 8) {
            if (floor_no == 5) {
                preset_no = 0;
            } else {
                preset_no = iRand(19) + 1;
            }
        }

        if (floor_no < 19) {
            if (floor_no >= 8) {
                if (floor_no == 11) {
                    preset_no = 0;
                } else {
                    preset_no = iRand(19) + 1;
                }
            }
        }

        if (floor_no >= 19) {
            preset_no = iRand(10);
        }

        if (preset_no < 0 || static_cast<std::size_t>(preset_no) >= RoomInfoView().size()) {
            minimap_enable = false;
            navi_enable = false;
            return;
        }
        int h = room_info[preset_no].h;
        grid_w = room_info[preset_no].w;
        grid_h = h;
        CreatFixedMap(preset_no);
        IndexToPartsPlace();
        return;
    }

    if (mode & AUTOMAP_GEN_FIXED_START) {
        grid_w = 20;
        grid_h = 16;
        RandomMapMainProc();
        return;
    }

    grid_w = 14;
    grid_h = 14;
    RandomMapMainProc();
    map = DngMainScene->GetMap(0);

    if (map != nullptr) {
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
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int            x = {};
    int            z = {};
    CAutoMapParts *cell = {};
    int            i = {};
    int            row = {};
    int            col = {};
    CAutoMapParts *cells = grid;

    if (cells != nullptr && minimap_enable) {
        const auto point = GridPoint(pos, cell_w, cell_d, grid_w, grid_h, true, true);
        if (!point) {
            return;
        }
        x = (*point)[0];
        z = (*point)[1];

        if (x < 0) {
            x = 0;
        }

        if (z < 0) {
            z = 0;
        }

        (cells + z * grid_w)[x].visible = true;
        cell = &(grid + z * grid_w)[x];

        if (z > 0) {
            CAutoMapParts *up = cell - grid_w;

            if (!(up->wall & AUTOMAP_WALL_POS_Z)) {
                up->visible = true;
            }
        }

        if (z < grid_h - 1) {
            if (!(cell[grid_w].wall & AUTOMAP_WALL_NEG_Z)) {
                cell[grid_w].visible = true;
            }
        }

        if (x > 0 && !(cell[-1].wall & AUTOMAP_WALL_POS_X)) {
            cell[-1].visible = true;
        }

        if (x < grid_w - 1 && !(cell[1].wall & AUTOMAP_WALL_NEG_X)) {
            cell[1].visible = true;
        }

        if (!(gen_flag & AUTOMAP_GEN_PRESET_FLOOR)) {
            for (i = 0; i < room_num && std::cmp_less(i, std::size(room)); i++) {
                if (room[i].x < 0 || room[i].y < 0 || room[i].w <= 0 || room[i].h <= 0 ||
                    room[i].x >= grid_w || room[i].y >= grid_h || room[i].w > grid_w - room[i].x ||
                    room[i].h > grid_h - room[i].y) {
                    continue;
                }
                if (x >= room[i].x && z >= room[i].y && x < room[i].x + room[i].w &&
                    z < room[i].y + room[i].h) {
                    for (row = 0; row < room[i].h; row++) {
                        for (col = 0; col < room[i].w; col++) {
                            (&(grid + (room[i].y + row) * grid_w)[col])[room[i].x].visible = true;
                        }
                    }
                }
            }
        }
    }
}

void CAutoMapGen::MinimapDoorOpen(float *pos) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int        x = {};
    int        z = {};
    CMapParts *door = {};
    int        opened_wall = {};

    if (grid == nullptr) {
        return;
    }

    const auto point = GridPoint(pos, cell_w, cell_d, grid_w, grid_h);
    if (!point) {
        return;
    }
    x = (*point)[0];
    z = (*point)[1];
    door = (grid + z * grid_w)[x].parts;

    if (door != nullptr) {
        door->minimap_tile -= 4;
        u8 link = (grid + z * grid_w)[x].road_link;
        opened_wall = 0;

        if (link == AUTOMAP_LINK_NEG_Z) {
            opened_wall = AUTOMAP_WALL_NEG_Z;
        }

        if (link == AUTOMAP_LINK_POS_Z) {
            opened_wall = AUTOMAP_WALL_POS_Z;
        }

        if (link == AUTOMAP_LINK_POS_X) {
            opened_wall = AUTOMAP_WALL_POS_X;
        }

        if (link == AUTOMAP_LINK_NEG_X) {
            opened_wall = AUTOMAP_WALL_NEG_X;
        }

        (grid + z * grid_w)[x].wall &= ~opened_wall;
    }
}

CMapParts *CAutoMapGen::SearchRandomStone(float *pos, float radius) {
    float stone_pos[4];
    int   i = {};

    for (i = 0; i < AUTOMAP_RANDOM_STONE_MAX; i++) {
        if (random_stone[i] != nullptr) {
            random_stone[i]->GetPosition(stone_pos);

            if (mgDistVector(pos, stone_pos) < radius) {
                return random_stone[i];
            }
        }
    }

    return nullptr;
}

void CAutoMapGen::ClearRandomStone() {
    int i = {};

    for (i = 0; i < AUTOMAP_RANDOM_STONE_MAX; i++) {
        if (random_stone[i] != nullptr) {
            random_stone[i]->SetPosition(0.0f, -99999.0f, 0.0f);
        }
    }
}

void CAutoMapGen::Step() {
    healing_point.Step();
}

int CAutoMapGen::GetAttrStatus(float *pos) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return 0;
    }

    CAutoMapParts *cells = grid;
    int            x = {};
    int            z = {};

    if (cells == nullptr) {
        return 0;
    }

    const auto point = GridPoint(pos, cell_w, cell_d, grid_w, grid_h, true, false);
    if (!point) {
        return AUTOMAP_ATTR_HIDE;
    }
    x = (*point)[0];
    z = (*point)[1];

    return (cells + z * grid_w)[x].attr;
}

void CAutoMapGen::MinimapAllVisible() {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int i = {};

    for (i = 0; i < grid_w * grid_h; i++) {
        grid[i].visible = true;
    }
}

float CAutoMapGen::GetNaviDistance(float *pos) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return 0.0f;
    }

    float size_x = {};
    float size_z = {};
    int   x = {};
    int   z = {};
    s8    step = {};

    if (!navi_valid || !navi_enable) {
        return 0.0f;
    }

    const auto point = GridPoint(pos, cell_w, cell_d, grid_w, grid_h, true, true);
    if (!point) {
        return -1.0f;
    }
    x = (*point)[0];
    z = (*point)[1];
    size_x = cell_w;
    size_z = cell_d;

    step = (grid + z * grid_w)[x].navi;

    if (step <= 0) {
        return -1.0f;
    }

    const double distance = (static_cast<double>(navi_depth) - step) *
                            (static_cast<double>(size_x) + size_z) / 2.0;
    if (!std::isfinite(distance) || distance < -static_cast<double>(std::numeric_limits<float>::max()) ||
        distance > static_cast<double>(std::numeric_limits<float>::max())) {
        return -1.0f;
    }
    return static_cast<float>(distance);
}

void CAutoMapGen::UpdateNaviMap(float *pos, int depth) {
    auto *grid = GridCells().data();
    if (grid == nullptr) {
        return;
    }

    int            steps = {};
    int            x = {};
    u32            wall = {};
    int            changed = {};
    int            z = {};
    int            row = {};
    CAutoMapParts *cell = {};
    int            i = {};
    int            col = {};

    if (grid == nullptr || !navi_enable) {
        return;
    }

    const auto point = GridPoint(pos, cell_w, cell_d, grid_w, grid_h, true, true);
    if (!point) {
        return;
    }
    x = (*point)[0];
    z = (*point)[1];
    if (depth < 0 || depth > std::numeric_limits<s8>::max()) {
        return;
    }
    navi_depth = depth;
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
        changed = false;

        for (row = 0; row < grid_h; row++) {
            for (col = 0; col < grid_w; col++) {
                steps = cell->navi;
                wall = cell->wall;

                if (steps > 0) {
                    if (row > 0 && !(wall & AUTOMAP_WALL_NEG_Z)) {
                        int next = steps - 1;

                        if ((cell - grid_w)->navi < next && !((cell - grid_w)->wall & AUTOMAP_WALL_POS_Z)) {
                            (cell - grid_w)->navi = next;
                            changed = true;
                        }
                    }

                    if (row < grid_h - 1 && !(wall & AUTOMAP_WALL_POS_Z)) {
                        int next = steps - 1;

                        if ((cell + grid_w)->navi < next && !((cell + grid_w)->wall & AUTOMAP_WALL_NEG_Z)) {
                            (cell + grid_w)->navi = next;
                            changed = true;
                        }
                    }

                    if (col > 0 && !(wall & AUTOMAP_WALL_NEG_X)) {
                        int next = steps - 1;

                        if (cell[-1].navi < next && !(cell[-1].wall & AUTOMAP_WALL_POS_X)) {
                            cell[-1].navi = next;
                            changed = true;
                        }
                    }

                    if (col < grid_w - 1 && !(wall & AUTOMAP_WALL_POS_X)) {
                        int next = steps - 1;

                        if (cell[1].navi < next && !(cell[1].wall & AUTOMAP_WALL_NEG_X)) {
                            cell[1].navi = next;
                            changed = true;
                        }
                    }
                }

                cell++;
            }
        }
    } while (changed);

    navi_valid = true;
}

// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format off
// clang-format on

#include "common.h"

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <iterator>
#include <new>
#include <optional>
#include <stdexcept>
#include <utility>
#include <vector>

#include "automap.hpp"
#include "dng_main.hpp"
#include "gfx/gfx.hpp"
#include "maintex.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "scenesnd.hpp"
#include "test_hooks.hpp"

namespace dc2::dungeon {
/**
 * Owns the immutable room records and flattened cell tables used while generating a floor.
 */
struct RoomStorage {
    std::array<AUTOMAP_ROOM_INFO, AUTOMAP_ROOM_INFO_MAX> rooms{}; /**< Stable room records, including unused empty slots. */
    std::array<std::vector<s16>, AUTOMAP_ROOM_INFO_MAX>  tables;  /**< Owned part and attribute pairs of each room. */
    std::size_t                                          count{}; /**< Number of complete room records published by this snapshot. */
};
} // namespace dc2::dungeon

CAutoMapGen::CAutoMapGen() = default;
CAutoMapGen::~CAutoMapGen() = default;

void CAutoMapGen::ClearRoomInfo() {
    room_info = nullptr;
    room_info_num = 0;
    room_storage.reset();
}

std::span<const AUTOMAP_ROOM_INFO> CAutoMapGen::RoomInfoView() const {
    if (room_storage == nullptr || room_info != room_storage->rooms.data() || room_info_num < 0 ||
        room_info_num > AUTOMAP_ROOM_INFO_MAX || static_cast<std::size_t>(room_info_num) != room_storage->count) {
        return {};
    }
    return std::span(room_storage->rooms).first(static_cast<std::size_t>(room_info_num));
}

namespace {

constexpr gfx::UiAnchor kMiniMapAnchor = gfx::UiAnchor::Side(1, -1, true);

/**
 * Part index and attribute of one cell of a room preset.
 */
using RoomCell = std::pair<s16, s16>;

/**
 * One room preset of a dungeon_rooms document.
 */
struct RoomPreset {
    int                                id;    /**< Number the script gives the layout. */
    int                                w;     /**< Width of the layout in cells. */
    int                                h;     /**< Height of the layout in cells. */
    int                                rate;  /**< Chance out of 100 that random room selection keeps the layout. */
    int                                fixed; /**< Above zero keeps the layout out of random room selection. */
    std::vector<std::vector<RoomCell>> table; /**< Cells of each row, in script order. */
};

/**
 * Typed contents of a dungeon_rooms document.
 */
struct RoomPresets {
    std::optional<std::pair<float, float>> cell_size; /**< Cell width and depth, when the script sets them. */
    std::vector<RoomPreset>                rooms;     /**< Room presets, in script order. */
};

/**
 * Largest cell count of one room preset, far above any retail layout, so its table size stays in range.
 */
constexpr int kRoomCellMax = 0x10000;

/**
 * Parses a dungeon_rooms document.
 */
RoomPresets ParseRoomPresets(const native_config::Json &document) {
    using namespace native_config;
    RoomPresets presets;
    const auto  cell_w = OptionalFloat(document, "cell_w");
    const auto  cell_d = OptionalFloat(document, "cell_d");
    if (cell_w.has_value() != cell_d.has_value()) {
        throw std::runtime_error("cell_w and cell_d go together");
    }
    if (cell_w) {
        presets.cell_size.emplace(*cell_w, *cell_d);
    }
    for (const auto &room : Array(document, "rooms")) {
        RoomPreset preset{.id = Int(room, "id"), .w = Int(room, "w"), .h = Int(room, "h"), .rate = Int(room, "rate"), .fixed = Int(room, "fixed"), .table = {}};
        if (preset.w < 0 || preset.h < 0 || (preset.h != 0 && preset.w > kRoomCellMax / preset.h)) {
            throw std::runtime_error("room size out of range");
        }
        for (const auto &row : Array(room, "table")) {
            if (!row.is_array()) {
                throw std::runtime_error("room table row is not an array");
            }
            auto &cells = preset.table.emplace_back();
            for (const auto &cell : row) {
                if (!cell.is_array() || cell.size() != 2) {
                    throw std::runtime_error("room cell needs a part and an attribute");
                }
                cells.emplace_back(static_cast<s16>(Int(cell[0])), static_cast<s16>(Int(cell[1])));
            }
        }
        presets.rooms.push_back(std::move(preset));
    }
    return presets;
}

/**
 * Fills one preset entry and its cell table as ROOM_ID, ROOM_SIZE, ROOM_RATE, ROOM_FIXED and RD do.
 */
void ApplyRoomPreset(AUTOMAP_ROOM_INFO &info, std::vector<s16> &cells, const RoomPreset &preset) {
    const auto cell_count = static_cast<std::size_t>(preset.w) * static_cast<std::size_t>(preset.h);
    cells.assign(cell_count * 2, 0);
    for (std::size_t index = 0; index < cell_count; ++index) {
        cells[index * 2] = -1;
    }
    info.id = preset.id;
    info.w = preset.w;
    info.h = preset.h;
    info.rate = preset.rate;
    info.fixed = preset.fixed;
    std::size_t offset = 0;
    int         rows = 0;
    for (const auto &row : preset.table) {
        if (std::cmp_not_equal(row.size(), preset.w)) {
            continue;
        }
        if (rows++ == preset.h) {
            break;
        }
        for (const auto &[part, attribute] : row) {
            cells[offset++] = part;
            cells[offset++] = attribute;
        }
    }
    info.table = cells.empty() ? nullptr : cells.data();
}

} // namespace

std::span<CMapParts> CMiniMapSymbol::PlacedParts() const {
    auto *map = map_view.Get();
    if (map == nullptr) {
        return {};
    }
    auto       parts = map->PlacedParts();
    const auto end = std::ranges::find_if(parts, [](const CMapParts &part) { return part.name[0] == 0; });
    return parts.first(static_cast<std::size_t>(end - parts.begin()));
}

void CMiniMapSymbol::SetMapInfo(dc2::scene::MapView new_map, dc2::memory::ArenaBuffer new_grid, int width, int height,
                                float cell_width, float cell_depth) {
    map_view = std::move(new_map);
    grid_storage = new_grid;
    grid_w = width;
    grid_h = height;
    cell_w = cell_width;
    cell_d = cell_depth;
    info = nullptr;
    texture = nullptr;
    const auto parts = PlacedParts();
    if (map_view.Get() == nullptr) {
        return;
    }
    texture = mgTexManager.GetTexture("minimap1", -1);
    if (BattleAreaScene == nullptr) {
        return;
    }
    char floor_name[sizeof(BattleAreaScene->map_name)];
    std::memcpy(floor_name, BattleAreaScene->map_name, sizeof floor_name);
    floor_name[sizeof floor_name - 1] = 0;
    if (std::strlen(floor_name) == 7) {
        floor_name[6] = 0;
    }
    for (auto &entry : MiniMapInfoData) {
        if (std::strcmp(entry.name, floor_name) == 0) {
            info = &entry;
            break;
        }
    }
    if (!info) {
        return;
    }
    for (auto &part : parts) {
        part.minimap_tile = -1;
        // The final entry has an empty string, not a null pointer.
        for (std::size_t j = 0; j < std::size(PartsInfoData) && j < std::size(info->tile); ++j) {
            const char *name = PartsInfoData[j].name;
            if (!name || !*name) {
                break;
            }
            if (std::strcmp(name, part.parts_name) == 0) {
                part.minimap_tile = info->tile[j];
            }
        }
    }
}

void CMiniMapSymbol::DrawSymbolOpen() {
    prim.Initialize(nullptr, nullptr);
    prim.Preset2D();
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x80, 0x80, 0x80, 0x60);
    prim.Texture(TEX_SystenFrame);
    prim.SetScirror(x - w / 2, y - h / 2, w, h);
    // Symbols other objects draw between Open and Close are part of the map, so they stay anchored with it.
    gfx::SetUiAnchor(kMiniMapAnchor);
}

void CMiniMapSymbol::DrawSymbolClose() {
    prim.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    prim.End();
    blink_cnt++;

    if (blink_cnt > 30) {
        blink_cnt = 0;
    }

    gfx::SetUiAnchor({});
}

void CMiniMapSymbol::DrawSymbol_Chara(CCharacter2 *chara) {
    gfx::UiAnchorScope anchor(kMiniMapAnchor);

    float pos[4];
    float rot[4];

    if (chara == nullptr) {
        return;
    }

    if (BattleAreaScene->boss_map != 0) {
        return;
    }

    chara->GetPosition(pos);
    chara->GetRotation(rot);
    sceVu0SubVector(pos, pos, center);
    int        screen_x = x + static_cast<int>(16.0f * (pos[0] / cell_w)) + 8;
    int        screen_y = y + static_cast<int>(16.0f * (pos[2] / cell_d)) + 8;
    float      angle = rot[1];
    CPreSprite sprite;
    sprite.Initialize(nullptr, nullptr);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.Color(0x80, 0x80, 0x80, 0x60);
    sprite.Texture(TEX_SystenFrame);
    sprite.SetScirror(x - w / 2, y - h / 2, w, h);
    int off_x = static_cast<int>(-7.0f * sinf(angle) - -6.0f * cosf(angle));
    int off_y = static_cast<int>(-6.0f * sinf(angle) + -7.0f * cosf(angle));
    sprite.TextureCrd(0xC4, 0xF2);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = static_cast<int>(-7.0f * sinf(angle) - 6.0f * cosf(angle));
    off_y = static_cast<int>(6.0f * sinf(angle) + -7.0f * cosf(angle));
    sprite.TextureCrd(0xD0, 0xF2);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = static_cast<int>(7.0f * sinf(angle) - -6.0f * cosf(angle));
    off_y = static_cast<int>(-6.0f * sinf(angle) + 7.0f * cosf(angle));
    sprite.TextureCrd(0xC4, 0x100);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = static_cast<int>(7.0f * sinf(angle) - 6.0f * cosf(angle));
    off_y = static_cast<int>(6.0f * sinf(angle) + 7.0f * cosf(angle));
    sprite.TextureCrd(0xD0, 0x100);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    sprite.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    sprite.End();
}

void CMiniMapSymbol::Draw(float *pos) {
    auto *grid = GridCells().data();
    if (grid_w > 0 && grid_h > 0 && grid == nullptr) {
        return;
    }

    gfx::UiAnchorScope anchor(kMiniMapAnchor);

    if (pos == nullptr || BattleAreaScene == nullptr ||
        !std::isfinite(cell_w) || !std::isfinite(cell_d) || cell_w <= 0.0f || cell_d <= 0.0f) {
        return;
    }

    const auto live_parts = PlacedParts();
    CMapParts *parts = live_parts.data();

    if (live_parts.empty()) {
        return;
    }

    if (BattleAreaScene->boss_map != 0) {
        return;
    }

    sceVu0CopyVector(center, pos);
    const bool dimmed = (BattleAreaScene->minimap_reveal & MINIMAP_REVEAL_ROOMS) != 0;

    CPreSprite sprite;
    CPreSprite spare;
    float      part_pos[4];
    float      delta[4];
    sprite.Initialize(nullptr, nullptr);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Texture(texture);
    sprite.Color(0x80, 0x80, 0x80, 0x60);
    sprite.SetScirror(x - w / 2, y - h / 2, w, h);

    for (std::size_t i = 0; i < live_parts.size(); i++) {
        if (parts->name[0] != 0) {
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
            float          screen_x = static_cast<float>(x) + 16.0f * rate_x;
            float          screen_y = y + rate_z * 16.0f;
            CAutoMapParts *cells = grid;

            if (cells != nullptr) {
                const auto point = GridPoint(part_pos, cell_w, cell_d, grid_w, grid_h, false);
                if (!point) {
                    parts++;
                    continue;
                }
                CAutoMapParts *cell = &cells[grid_w * (*point)[1] + (*point)[0]];

                if (cell->attr & AUTOMAP_ATTR_HIDE) {
                    parts++;
                    continue;
                }

                if (cell->visible) {
                    sprite.Color(0x80, 0x80, 0x80, 0x80);
                } else if (dimmed) {
                    sprite.Color(0x30, 0x30, 0x30, 0x80);
                } else {
                    sprite.Color(0x30, 0x30, 0x30, 0);
                }
            }

            const auto rect_x = PixelCoordinate(screen_x);
            const auto rect_y = PixelCoordinate(screen_y);
            if (!rect_x || !rect_y) {
                parts++;
                continue;
            }
            sprite.SetIRect(*rect_x, *rect_y, 16, 16, tile_u, tile_v);
        }

        parts++;
    }

    sprite.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    sprite.End();
}

bool CAutoMapGen::SetupRoomInfo(std::string_view path) {
    ClearRoomInfo();
    const auto presets = native_config::Read<RoomPresets>(std::string(path), "dungeon_rooms", ParseRoomPresets);
    if (!presets || presets->rooms.empty()) {
        return false;
    }
    auto storage = std::make_unique<dc2::dungeon::RoomStorage>();
    for (auto &room : storage->rooms) {
        room.id = -1;
    }
    std::size_t count = 0;
    for (const auto &preset : presets->rooms) {
        if (count == storage->rooms.size()) {
            break;
        }
        ApplyRoomPreset(storage->rooms[count], storage->tables[count], preset);
        ++count;
    }
    if (const auto seed = GameSeed()) {
        srand(*seed);
    }
    if (presets->cell_size) {
        cell_w = presets->cell_size->first;
        cell_d = presets->cell_size->second;
    }
    storage->count = count;
    room_storage = std::move(storage);
    room_info = room_storage->rooms.data();
    room_info_num = static_cast<int>(count);
    return true;
}
