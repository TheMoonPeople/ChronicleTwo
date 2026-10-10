#include "common.h"

#include <cstring>

#include "character.hpp"
#include "colprim.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scenesnd.hpp"

/**
 * Collision shape, damage and reaction parameters of each named attack.
 */
DAMAGE_PARAM Damage_Param_Table[DAMAGE_PARAM_MAX] = {
    {"\x83X\x83g\x81[\x83\x93\x83x\x83\x8A\x81[",          DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 5,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   3, 0x9000,   10, 1},
    {"\x83l\x83o\x83s\x81[\x83`",                          DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 5,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x11000,  10, 1},
    {"\x83\x8C\x81[\x83U\x81[G",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_LASER_GUN,     {0}, 0,  0, 0, 0, 0, 0,   0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   2, 0x0,      10, 1},
    {"\x93\xC5\x96\xB6",                                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 15,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x4,      10, 1},
    {"\x82l\x98"
     "A\x8C\x82\x82Q",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     0,
     2                                                                                                                                                                                                                                                              },
    {"\x82l\x98"
     "A\x8C\x82\x82S",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     0,
     4                                                                                                                                                                                                                                                              },
    {"\x82l\x98"
     "A\x8C\x82\x82W",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x4,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x82l\x82"
     "a\x98"
     "A\x8C\x82\x82P",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x2,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     0,
     1                                                                                                                                                                                                                                                              },
    {"\x96\x82\x90l\x83r\x81[\x83\x80",                    DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_PLAYER | DAMAGE_TARGET_MONSTER, DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 50,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      15, 1},
    {"\x83h\x83\x89\x83S\x83\x93\x89\xCE\x92"
     "e",
     DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     30,
     0x2,
     -1,
     {100, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x100000,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x95@\x83}\x83V\x83\x93\x83K\x83\x93",               DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 20,  0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x110000, 0,  3},
    {"\x83}\x83~\x81[\x93\xC5\x96\xB6",                    DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x100004, 10, 1},
    {"\x94\xCA\x8E\xE1\x93\xC5\x96\xB6",                   DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x100004, 10, 1},
    {"\x83V\x83O\x81[\x83u\x83\x8C\x83X",                  DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      0,  1},
    {"\x82\xE8\x82\xF1\x82\xD5\x82\xF1",                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 30,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x4,      10, 1},
    {"\x90\xB9\x90\x85",                                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 40, 0, 0, 2, 0, 50,  0x2,  -1, {0, 0, 0, 0, 0, 150, 0, 0}, 3, 0x41000,  10, 1},
    {"\x92\x86\x82"
     "f\x82"
     "b",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     50,
     0x8,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x8B@\x8F"
     "e",
     DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     50,
     0x4,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     0,
     4                                                                                                                                                                                                                                                              },
    {"\x8A"
     "C\x91\xAF\x94\x9A\x92"
     "e",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_PLAYER | DAMAGE_TARGET_MONSTER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     40,
     0xa,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x83R\x83g\x83\x8C\x83\x93\x8DU\x8C\x82",            DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x100000, 10, 1},
    {"\x83g\x83\x8C\x83\x93\x83g\x83X\x8DU\x8C\x82",       DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x4,      10, 1},
    {"\x83V\x81[\x83h\x83\x89\x8DU\x8C\x82",               DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x8000,   10, 1},
    {"\x83V\x81[\x83h\x83\x89\x8DU\x8C\x82\x82Q",          DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x4,      15, 1},
    {"\x83"
     "C\x83\x93\x83t\x83"
     "F\x8DU\x8C\x82",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x2,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x100000,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x83"
     "C\x83\x93\x83t\x83"
     "F\x8DU\x8C\x82\x82Q",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x100000,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83O\x83\x8A\x89H\x8D\xAA",                         DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 25,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      15, 1},
    {"\x83\x8D\x83{\x83\x8C\x81[\x83U\x81[",               DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_RIDEPOD_GUN,   {0}, 0,  0, 0, 1, 0, 0,   0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   4, 0x0,      10, 1},
    {"\x83\x8D\x83{\x83}\x83V\x83\x93\x83K\x83\x93",       DAMAGE_SHAPE_LINE,                       {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_RIDEPOD_GUN,   {0}, 0,  0, 0, 0, 0, 0,   0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   4, 0x0,      3,  4},
    {"\x83V\x81[\x83h\x83\x89\x8DU\x8C\x82\x82R",          DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 50,  0xa,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x100000, 15, 1},
    {"\x8E\xE3\x98"
     "A\x91\xB1",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     25,
     0x2,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     0,
     1                                                                                                                                                                                                                                                              },
    {"\x90\x81\x82\xC1\x94\xF2\x82\xD1\x82Q",              DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      45, 1},
    {"\x90\x81\x82\xC1\x94\xF2\x82\xD1\x8E\xE3\x82Q",      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 20,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      45, 1},
    {"\x90\x81\x82\xC1\x94\xF2\x82\xD1\x92\x86\x82Q",      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 50,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      45, 1},
    {"\x92\xCA\x8F\xED\x93\xC5",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x4,      10, 1},
    {"\x92\xCA\x8F\xED\x8A\xA3\x82\xAB",                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x100000, 10, 1},
    {"\x82"
     "e\x83{\x83\x80",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_ITEM,
     {0},
     1000,
     0,
     0,
     3,
     0,
     50,
     0x2,
     -1,
     {100, 100, 100, 100, 0, 0, 0, 0},
     3,
     0x80000,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x93"
     "d\x8C\xF5\x90\xCE\x89\xD4",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_ITEM,
     {0},
     800,
     0,
     0,
     3,
     0,
     50,
     0x2,
     -1,
     {0, 0, 120, 0, 0, 0, 0, 0},
     3,
     0x80000,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83\x82\x83\x93\x83X\x8DU\x8C\x82S",                DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      5,  2},
    {"\x8E\xE3\x93\xC5",                                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 25,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x4,      10, 1},
    {"\x83\x8D\x83{\x83L\x83\x83\x83m\x83\x93",            DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_RIDEPOD_GUN,   {0}, 0,  0, 0, 2, 0, 5,   0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   4, 0x0,      10, 1},
    {"\x83\x82\x83\x93\x83X\x8DU\x8C\x82"
     "B",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x2,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     8,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x95\xF3\x94\xA0\x94\x9A\x94\xAD",                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_PLAYER | DAMAGE_TARGET_MONSTER, DAMAGE_KIND_MONSTER,       {0}, 50, 0, 0, 1, 0, 100, 0xa,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x1000,   10, 1},
    {"\x82l\x98"
     "A\x8C\x82\x82P",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     0,
     1                                                                                                                                                                                                                                                              },
    {"\x83~\x83\x93\x83"
     "c\x8C\x95\x8DU\x8C\x82",
     DAMAGE_SHAPE_LINE | DAMAGE_SHAPE_TRAIL,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MAX_MELEE,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     1,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83\x82\x83j\x83J\x8C\x95\x8DU\x8C\x82",            DAMAGE_SHAPE_LINE | DAMAGE_SHAPE_TRAIL,  {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONICA_MELEE,  {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   1, 0x0,      10, 1},
    {"\x83\x86\x83\x8A\x83X\x97\xAD\x82\xDF\x8DU\x8C\x82", DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MAX_MELEE,     {0}, 0,  0, 0, 2, 0, 20,  0x12, -1, {0, 0, 0, 0, 0, 0, 0, 0},   1, 0x0,      10, 1},
    {"\x83\x82\x83j\x83J\x97\xAD\x82\xDF\x8DU\x8C\x82",    DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONICA_MELEE,  {0}, 0,  0, 0, 2, 0, 20,  0x12, -1, {0, 0, 0, 0, 0, 0, 0, 0},   1, 0x0,      10, 1},
    {"\x83\x8D\x83{\x83p\x83\x93\x83`\x82P",               DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_RIDEPOD_PUNCH, {0}, 0,  0, 0, 3, 0, 30,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   4, 0x0,      10, 1},
    {"\x83\x86\x83\x8A\x83X\x8F"
     "e\x8DU\x8C\x82",
     DAMAGE_SHAPE_LINE | DAMAGE_SHAPE_TRAIL,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MAX_GUN,
     {0},
     0,
     0,
     0,
     0,
     0,
     0,
     0x4,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     2,
     0x100000,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x94\x9A\x94\xAD",                                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 50, 0, 0, 3, 0, 50,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   3, 0x80000,  10, 1},
    {"\x83\x82\x83j\x83J\x96\x82\x96@",                    DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONICA_MAGIC,  {0}, 6,  0, 0, 0, 0, 0,   0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   2, 0x0,      10, 1},
    {"\x89\xCE\x89\x8A\x92"
     "e",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MAX_GUN,
     {0},
     6,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {100, 0, 0, 0, 0, 0, 0, 0},
     2,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x8B\xAD\x94\x9A\x94\xAD",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_PLAYER | DAMAGE_TARGET_MONSTER, DAMAGE_KIND_ITEM,          {0}, 0,  0, 0, 3, 0, 50,  0x3,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   3, 0x0,      10, 1},
    {"\x93G\x8A\xEE\x96{\x82P",                            DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 30,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      10, 1},
    {"\x92\xCA\x8F\xED\x8DU\x8C\x82",                      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      10, 1},
    {"\x8E\xE3\x8DU\x8C\x82",                              DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 25,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      10, 1},
    {"\x92\x86\x8DU\x8C\x82",                              DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 50,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      10, 1},
    {"\x8B\xAD\x8DU\x8C\x82",                              DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 80,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      10, 1},
    {"\x90\x81\x82\xC1\x94\xF2\x82\xD1\x8DU\x8C\x82",      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      15, 1},
    {"\x90\x81\x82\xC1\x94\xF2\x82\xD1\x8E\xE3",           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 20,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      15, 1},
    {"\x90\x81\x82\xC1\x94\xF2\x82\xD1\x92\x86",           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 40,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      15, 1},
    {"\x93\xC5\x89t\x82Q",                                 DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 25,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x4,      10, 1},
    {"\x92\xD9",                                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 15, 0, 0, 0, 0, 0,   0x3,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   3, 0x1000,   10, 1},
    {"\x89~\x8C`\x83`\x83"
     "F\x83"
     "b\x83N\x97p",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_CHECK,
     {0},
     0,
     0,
     0,
     0,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     3,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x82l\x83M\x83\x8B\x89\xCE\x92\x8C\x82P",            DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 50,  0xa,  -1, {100, 0, 0, 0, 0, 0, 0, 0}, 0, 0x0,      15, 1},
    {"\x8B\xAD\x90\xFC\x8C`\x93G",                         DAMAGE_SHAPE_LINE | DAMAGE_SHAPE_TRAIL,  {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 2, 0, 40,  0xa,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      10, 1},
    {"\x92\xCA\x8F\xED\x82"
     "f\x82"
     "b",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x8,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x8E\xE3\x82"
     "f\x82"
     "b",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     20,
     0x8,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83\x82\x83\x93\x83X\x83^\x81[\x8DU\x8C\x82",       DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      10, 1},
    {"\x95@\x94\x9A\x92"
     "e",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_PLAYER | DAMAGE_TARGET_MONSTER,
     DAMAGE_KIND_MONSTER,
     {0},
     15,
     0,
     0,
     1,
     0,
     80,
     0x3,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x92\xCA\x8F\xED\x82"
     "a\x82"
     "f\x82"
     "b",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     30,
     0xb,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x83\x86\x83\x8A\x83X\x8C\x95\x8B\xAD\x8DU\x8C\x82", DAMAGE_SHAPE_LINE,                       {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MAX_MELEE,     {0}, 0,  0, 0, 2, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   1, 0x0,      10, 1},
    {"\x83\x82\x83j\x83J\x8C\x95\x8B\xAD\x8DU\x8C\x82",    DAMAGE_SHAPE_LINE,                       {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONICA_MELEE,  {0}, 0,  0, 0, 2, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   1, 0x0,      10, 1},
    {"\x82j\x83~\x83~\x83"
     "b\x83N",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     10,
     0x2,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x2000,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x83W\x83\x87\x81[\x83J\x81[",                       DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 10,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      10, 1},
    {"\x96\x82\x90\xCE\x89\x8A",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 40, 0, 0, 2, 0, 50,  0x2,  -1, {150, 0, 0, 0, 0, 0, 0, 0}, 3, 0x1000,   10, 1},
    {"\x96\x82\x90\xCE\x97\xE2",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 40, 0, 0, 2, 0, 50,  0x2,  -1, {0, 150, 0, 0, 0, 0, 0, 0}, 3, 0x1000,   10, 1},
    {"\x96\x82\x90\xCE\x97\x8B",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 40, 0, 0, 2, 0, 50,  0x2,  -1, {0, 0, 150, 0, 0, 0, 0, 0}, 3, 0x1000,   10, 1},
    {"\x96\x82\x90\xCE\x95\x97",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 40, 0, 0, 2, 0, 50,  0x2,  -1, {0, 0, 0, 150, 0, 0, 0, 0}, 3, 0x1000,   10, 1},
    {"\x96\x82\x90\xCE\x90\xB9",                           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 40, 0, 0, 2, 0, 50,  0x2,  -1, {0, 0, 0, 0, 0, 150, 0, 0}, 3, 0x1000,   10, 1},
    {"\x89\xCE\x92"
     "e",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x2,
     -1,
     {100, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x95X\x92"
     "e",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x2,
     -1,
     {0, 100, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x97\x8B\x92"
     "e",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x2,
     -1,
     {0, 0, 100, 0, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x95\x97\x92"
     "e",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x2,
     -1,
     {0, 0, 0, 100, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x83\x86\x83\x8A\x83X\x8B\xAD\x8FR\x82\xE8",         DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MAX_MELEE,     {0}, 0,  0, 0, 1, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   1, 0x0,      10, 1},
    {"\x83T\x83\x93\xE5K\xE5N",                            DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 11,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      10, 1},
    {"\x83\x86\x83\x8A\x83X\x8E\xE3\x8FR\x82\xE8",         DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MAX_MELEE,     {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   1, 0x0,      10, 1},
    {"\x8E\xF4\x82\xA2\x8DU\x8C\x82",                      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x20000,  10, 1},
    {"\x82\xCB\x82\xCE\x8DU\x8C\x82",                      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x10000,  10, 1},
    {"\x90\xCE\x89\xBB\x8DU\x8C\x82",                      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x8000,   10, 1},
    {"\x83O\x83\x8A\x83R\x83\x93\x83{",                    DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 50,  0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      0,  2},
    {"\x90\x81\x82\xC1\x94\xF2\x82\xD1\x8B\xAD",           DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 65,  0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      15, 1},
    {"\x83O\x83\x8A\x83\\\x83j\x83"
     "b\x83N",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     10,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x8,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83O\x83\x8A\x83R\x83\x93\x83{\x82Q",               DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x2,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x4000,   15, 1},
    {"\x83T\x83\x80\x83\x89\x83"
     "C\x83\\\x81[\x83h",
     DAMAGE_SHAPE_LINE | DAMAGE_SHAPE_TRAIL,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_RIDEPOD_SWORD,
     {0},
     0,
     0,
     0,
     3,
     0,
     30,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     4,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83h\x83\x8A\x83\x8B\x83"
     "A\x81[\x83\x80",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_RIDEPOD_PUNCH,
     {0},
     0,
     1,
     0,
     1,
     0,
     30,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     4,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x82"
     "c\x82"
     "d\x96\xEE",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x30004,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x82l\x94\x9A\x92"
     "e\x94\x9A\x94\xAD",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_PLAYER | DAMAGE_TARGET_MONSTER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     40,
     0xb,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x92\x86\x82"
     "a\x82"
     "f\x82"
     "b",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     1,
     0,
     60,
     0xa,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     15,
     1                                                                                                                                                                                                                                                              },
    {"\x93\xC5\x82\xE8\x82\xF1\x82\xB2",                   DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 5,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   3, 0x1004,   10, 1},
    {"\x82\xC6\x82\xAB\x82\xDF\x82\xAB\x83`\x83"
     "F\x83\x8A",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_ITEM,
     {0},
     5,
     0,
     0,
     1,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 0, 0, 0, 0, 0},
     3,
     0x1008,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83\x8D\x83{\x83\x89\x83\x93\x83`\x83\x83",         DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_RIDEPOD_GUN,   {0}, 0,  0, 0, 2, 0, 5,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   4, 0x0,      4,  4},
    {"\x90\xCE\x83R\x83\x8D",                              DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_ITEM,          {0}, 8,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   3, 0x1000,   10, 1},
    {"\x96\x83\xE1\x83\x8DU\x8C\x82",                      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x8,      10, 1},
    {"\x96\x83\xE1\x83\x8DU\x8C\x82\x82Q",                 0,                                       {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      10, 1},
    {"\x82x\x83}\x83V\x83\x93\x83K\x83\x93",               DAMAGE_SHAPE_LINE,                       {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MAX_GUN,       {0}, 0,  0, 0, 0, 0, 0,   0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   2, 0x0,      3,  4},
    {"\x83h\x83\x89\x83S\x83\x93\x92\xDC",                 DAMAGE_SHAPE_POINT | DAMAGE_SHAPE_TRAIL, {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x8,      0,  2},
    {"\x83O\x83\x8C\x83l\x81[\x83hG",                      DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_GRENADE,       {0}, 0,  0, 0, 1, 0, 0,   0x4,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   2, 0x0,      4,  1},
    {"\x83M\x83t\x83g",                                    DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_CHECK,         {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      10, 1},
    {"\x89\xCE\x92"
     "e\x82Q",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x0,
     -1,
     {100, 0, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x95X\x92"
     "e\x82Q",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x0,
     -1,
     {0, 100, 0, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x97\x8B\x92"
     "e\x82Q",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x0,
     -1,
     {0, 0, 100, 0, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x95\x97\x92"
     "e\x82Q",
     DAMAGE_SHAPE_POINT,
     {0},
     DAMAGE_TARGET_BY_OWNER,
     DAMAGE_KIND_MONSTER,
     {0},
     0,
     0,
     0,
     2,
     0,
     0,
     0x0,
     -1,
     {0, 0, 0, 100, 0, 0, 0, 0},
     0,
     0x0,
     10,
     1                                                                                                                                                                                                                                                              },
    {"\x83V\x81[\x83O\x83\x89\x8DU\x8C\x82",               DAMAGE_SHAPE_POINT,                      {0}, DAMAGE_TARGET_PLAYER | DAMAGE_TARGET_MONSTER, DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   0, 0x0,      10, 1},
    {"\x83\x82\x83\x93\x83X\x83^\x81[\x8C\x95",            DAMAGE_SHAPE_LINE,                       {0}, DAMAGE_TARGET_BY_OWNER,                       DAMAGE_KIND_MONSTER,       {0}, 0,  0, 0, 1, 0, 0,   0x0,  -1, {0, 0, 0, 0, 0, 0, 0, 0},   8, 0x0,      10, 1},
};

// Code (.text)
int CColPrim::SetDamage(char *name, int owner_id) {
    int           index = 0;
    DAMAGE_PARAM *param = Damage_Param_Table;

    for (;;) {
        if (param->name[0] == 0) {
            return 0;
        }

        if (strcmp(param->name, name) == 0) {
            Initialize();
            param_no = index;
            active = 1;
            this->param = param;
            owner = owner_id;
            damage = param->damage;
            step_count = 0;
            coord_type = COLPRIM_COORD_VECTOR;
            attacker = -1;
            range = 10000.0f;
            memcpy(element, param->element, sizeof(element));
            status = param->status;

            if (param->target & DAMAGE_TARGET_BY_OWNER) {
                if (owner_id == 0) {
                    target = DAMAGE_TARGET_MONSTER;
                } else {
                    target = DAMAGE_TARGET_PLAYER;
                }
            } else {
                target = param->target;
            }

            return 1;
        }

        index++;
        param++;
    }
}

void CColPrim::SetCoord(float *position, float new_radius) {
    position[3] = 1.0f;

    if (step_count == 0) {
        sceVu0CopyVector(pos[0], position);
        sceVu0CopyVector(old_pos[0], position);
        sceVu0CopyVector(origin, position);
    } else {
        sceVu0CopyVector(old_pos[0], pos[0]);
        sceVu0CopyVector(pos[0], position);
    }

    radius = new_radius;
    coord_type = COLPRIM_COORD_VECTOR;
}

void CColPrim::SetCoord(float *start, float *end, float new_radius) {
    start[3] = 1.0f;
    end[3] = 1.0f;

    if (step_count == 0) {
        sceVu0CopyVector(pos[0], start);
        sceVu0CopyVector(pos[1], end);
        sceVu0CopyVector(old_pos[0], start);
        sceVu0CopyVector(old_pos[1], end);
        sceVu0CopyVector(origin, start);
    } else {
        sceVu0CopyVector(old_pos[0], pos[0]);
        sceVu0CopyVector(old_pos[1], pos[1]);
        sceVu0CopyVector(pos[0], start);
        sceVu0CopyVector(pos[1], end);
    }

    radius = new_radius;
    coord_type = COLPRIM_COORD_VECTOR;
}

void CColPrim::SetCoord(mgCFrame *start, float new_radius) {
    frame[0] = start;
    frame[1] = NULL;
    radius = new_radius;
    coord_type = COLPRIM_COORD_FRAME;

    if (step_count == 0 && start) {
        start->GetWorldPosition0(origin);
    }
}

void CColPrim::SetCoord(mgCFrame *start, mgCFrame *end, float new_radius) {
    frame[0] = start;
    frame[1] = end;
    radius = new_radius;
    coord_type = COLPRIM_COORD_FRAME;

    if (step_count == 0 && start) {
        start->GetWorldPosition0(origin);
    }
}

int CColPrim::IsHit(CScene *scene, int chara_id) {
    CColPrim *self = this;

    if (self->active == 0) {
        return 0;
    }

    if (self->param == 0) {
        return 0;
    }

    CCharacter2 *chara = scene->GetCharacter(chara_id);

    if (chara == 0) {
        return 0;
    }

    int chara_type = scene->GetType(SCENE_DATA_CHARA, chara_id);

    if (chara_type == 1 && !(self->target & DAMAGE_TARGET_PLAYER)) {
        return 0;
    }

    if (chara_type == 3 && !(self->target & DAMAGE_TARGET_MONSTER)) {
        return 0;
    }

    if (chara_id != -1 && (self->hit_mask & (1 << chara_id))) {
        return 0;
    }

    int   count = 0;
    int   entry_no = 0;
    int   hit = 0;
    float entry_position[4];
    float displacement[4];
    float starts[8][4];
    float ends[8][4];

    if (self->param->shape & DAMAGE_SHAPE_POINT) {
        sceVu0CopyVector(starts[count], self->pos[0]);
        count++;

        if ((self->param->shape & DAMAGE_SHAPE_TRAIL) && self->step_count > 0) {
            sceVu0SubVector(displacement, self->old_pos[0], self->pos[0]);
            sceVu0ScaleVector(displacement, displacement, 0.5f);
            sceVu0AddVector(starts[count], displacement, self->pos[0]);
            count++;
        }
    }

    if (self->param->shape & DAMAGE_SHAPE_LINE) {
        sceVu0CopyVector(starts[count], self->pos[0]);
        sceVu0CopyVector(ends[count], self->pos[1]);
        count++;

        if ((self->param->shape & DAMAGE_SHAPE_TRAIL) && self->step_count > 0) {
            sceVu0CopyVector(starts[count], self->pos[0]);
            sceVu0CopyVector(ends[count], self->old_pos[0]);
            sceVu0SubVector(displacement, self->pos[0], self->pos[1]);
            sceVu0ScaleVector(displacement, displacement, 0.5f);
            sceVu0AddVector(starts[count + 1], self->pos[1], displacement);
            sceVu0SubVector(displacement, self->old_pos[0], self->old_pos[1]);
            sceVu0ScaleVector(displacement, displacement, 0.5f);
            sceVu0AddVector(ends[count + 1], self->old_pos[1], displacement);
            count += 2;
        }
    }

    CHARA_ENTRY_OBJECT *entry;

    while ((entry = chara->GetEntryObjectPos(2, entry_no, entry_position)) != 0) {
        if (entry->enable == 0) {
            ++entry_no;
            continue;
        }

        if (self->param->shape & DAMAGE_SHAPE_POINT) {
            for (int i = 0; i < count; i++) {
                if (mgDistVector(starts[i], entry_position) <= 2.0f * (self->radius + entry->size)) {
                    entry_position[3] = 1.0f;
                    sceVu0CopyVector(self->hit_pos, entry_position);

                    if (self->param->shape & DAMAGE_SHAPE_TRAIL) {
                        sceVu0SubVector(self->hit_vec, self->pos[0], self->old_pos[0]);
                    } else {
                        sceVu0SubVector(self->hit_vec, entry_position, starts[i]);
                    }

                    self->hit_vec[1] = 0.0f;
                    sceVu0Normalize(self->hit_vec, self->hit_vec);
                    hit = 1;
                    break;
                }
            }
        }

        if (self->param->shape & DAMAGE_SHAPE_LINE) {
            for (int j = 0; j < count; j++) {
                if (mgDistLinePoint(entry_position, starts[j], ends[j], self->hit_pos) <= 2.0f * (self->radius + entry->size)) {
                    sceVu0SubVector(self->hit_vec, self->pos[1], self->old_pos[1]);
                    hit = 1;
                    break;
                }
            }
        }

        if (hit != 0) {
            if (chara_id != -1 && self->param->multi_hit == 0) {
                self->hit_mask |= 1 << chara_id;
            }

            self->hit_num++;
            return 1;
        }

        ++entry_no;
    }

    return 0;
}

int CColPrim::IsReversVec(CColPrim *other) {
    if (active == 0) {
        return 0;
    }

    if (param == 0) {
        return 0;
    }

    if (other->attacker != 0) {
        return 0;
    }

    other->pos[0][3] = 1.0f;
    pos[0][3] = 1.0f;

    if (mgDistVector(pos[0], other->pos[0]) <= 2.0f * (radius + 2.0f * other->radius)) {
        return 1;
    }

    return 0;
}

void CColPrim::GetReversVec(float *out_vector) {
    if (active && param) {
        sceVu0SubVector(out_vector, old_pos[0], pos[0]);
    }
}

void CColPrim::DebugDraw() {}

int CColPrim::Step() {
    if (active == 0) {
        return 0;
    }

    if (coord_type & 2) {
        if (step_count == 0) {
            for (int j = 0; j < 2; j++) {
                if (frame[j] != 0) {
                    frame[j]->GetWorldPosition0(pos[j]);
                }

                sceVu0CopyVector(old_pos[j], pos[j]);
            }
        } else {
            for (int i = 0; i < 2; i++) {
                sceVu0CopyVector(old_pos[i], pos[i]);

                if (frame[i] != 0) {
                    frame[i]->GetWorldPosition0(pos[i]);
                }
            }
        }
    }

    step_count++;
    int limit = life;

    if (limit != -1) {
        if (step_count >= limit) {
            active = 0;
        }
    }

    return 1;
}

void CColPrim::Delete(int id) {
    if (active != 0) {
        if (id == -1) {
            active = 0;
        } else if (owner == id) {
            active = 0;
        }
    }
}

void CColPrim::Initialize() {
    active = 0;
    owner = -1;
    hit_mask = 0;
    step_count = 0;
    life = -1;
    hit_num = 0;
    reversed = 0;
    has_gift = 0;
    unk_34 = 0;
    frame[1] = NULL;
    frame[0] = NULL;
    radius = 0;
    unk_8c = -1;
}

CColPrim *CColPrimMan::GetPrim() {
    for (int i = 0; i < COLPRIM_MAX; ++i) {
        if (!prim[i].active) {
            prim[i].id = i;
            return &prim[i];
        }
    }

    return NULL;
}

CColPrim *CColPrimMan::GetID2Prim(int id) {
    if (id < 0 || id >= COLPRIM_MAX) {
        return NULL;
    }

    prim[id].id = id;
    return &prim[id];
}

int CColPrimMan::ActivePrimNum() {
    int count = 0;

    for (int i = 0; i < COLPRIM_MAX; ++i) {
        if (prim[i].active) {
            ++count;
        }
    }

    return count;
}

void CColPrimMan::Delete(int owner) {
    for (int i = 0; i < COLPRIM_MAX; ++i) {
        prim[i].Delete(owner);
    }
}

CColPrim *CColPrimMan::CheckHit(int chara_id) {
    for (int i = 0; i < COLPRIM_MAX; ++i) {
        if (prim[i].IsHit(scene, chara_id)) {
            return &prim[i];
        }
    }

    return NULL;
}

CColPrim *CColPrimMan::IsReversVec(CColPrim *attack) {
    for (int i = 0; i < COLPRIM_MAX; ++i) {
        if (attack->id != i && prim[i].IsReversVec(attack)) {
            return &prim[i];
        }
    }

    return NULL;
}

void CColPrimMan::Step() {
    for (int i = 0; i < COLPRIM_MAX; ++i) {
        prim[i].Step();
    }
}

void CColPrimMan::Initialize(CScene *new_scene) {
    scene = new_scene;

    for (int i = 0; i < COLPRIM_MAX; ++i) {
        prim[i].Initialize();
        prim[i].id = i;
    }
}
