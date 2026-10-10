#include "common.h"
#include "mw_runtime.h"

#include <eekernel.h>
#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "dataread.hpp"
#include "dngfloor.hpp"
#include "editctrl.hpp"
#include "effscript.hpp"
#include "fishing.hpp"
#include "fishingobj.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "helpmes.hpp"
#include "intersection.hpp"
#include "mainloop.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "subgame.hpp"

/**
 *
 * Stores a four-component fishing position, direction or scale.
 *
 */
struct Vec4 {
    float v[4]; /**< Vector components. */
};

static void       StepDataLoading(void *arg);
extern const char at_2197__3[] = "\x92\xDE\x82\xEA\x82\xBD\x8E\x9E";
extern const char at_2198__3[] = "\x92\xDE\x82\xE8\x8F\xE3\x82\xB0\x8A\xEC\x82\xD1";

enum {
    kFishShapeCount = 5,
    kFishShapeCircle = 2
};

const int kFishPlaceValueCount = 5;
const int kFishPlaceMaxFish = 8;

enum {
    kUkiStart = 0,
    kUkiWaitBite = 1,
    kUkiPoke = 2,
    kUkiPull = 3,
    kUkiReeledIn = 4,
    kUkiCharge = 5,
    kUkiBite = 6,
};

/**
 *
 * Fishing modes selected for float bait and lures.
 *
 */
enum {
    kFishingModeFloat = 1,
    kFishingModeLure = 2
};

const int kFishCameraState = 1000;

enum {
    kFishBtnCameraToggle = 6,
    kFishBtnAction = 0x78,
    kFishBtnReel = 0x79,
    kFishBtnReelFast = 0x7A,
};

enum {
    kFishAxisUp = 4,
    kFishAxisSide = 5,
};

int                InitUkiWait(CScene *scene);
int                InitFalse(CScene *scene);
int                InitBattle(CScene *scene);
int                InitSuccess(CScene *scene);
void               DrawHamon(float *pos, float scale);
void               SetNextMode(int mode);
float              GetFishDist(CScene *scene);
void               EsaInit();
int                GetMotionCount(CCharacter2 *chara, char *name, int min_count, int max_count, int min_speed);
void               DeleteEsa();
int                EndSelectCastingPoint(CScene *scene);
static FISH_PARAM *GetFishParam(int index);
int                GetUkiWaitTime(FISH_DATA *fish, CScene *scene, float *position, int rod_no, int bait_no);
int                GetUkiPokeTime(FISH_DATA *fish);
int                GetUkiPullTime(FISH_DATA *fish);
int                FishLoadBG(FISH_DATA *fish, u_long128 *buffer);
float              GetRandamNumber(float center, float high, float floor);
void               DrawSplash(float *pos, float scale);
void               LineTensionStep(FISH_DATA *fish, int reel);
void               ExitFishing(CScene *scene);
int                LoadExMotionBG(SubGameInfo *info, u_long128 *buffer);
void               ReplayPrevBGM(CScene *scene);
int                LoadExMotionStep(SubGameInfo *info, mgCMemory *memory);
int                InitDataLoading();
int                switch_thread();
int                CreateLoadThread(mgCMemory *memory);
int                StepLoadThread();
void               DeleteLoadThread();
void               DrawNumber(mgCDrawPrim *prim, int digit, int x, int y);
int                InitCasting(CScene *scene);

enum {
    kPadButtonDebugJump = 1,
    kPadButtonCancel = 1,
    kPadButtonCast = 0x78
};

int InitSelectCastingPoint(CScene *scene);
int CheckCasting(CScene *scene, float *position, float *direction);

/**
 *
 * Defines the names, sizes and bite affinities of each fish species.
 *
 */
static FISH_PARAM FishParam[19] = {
    {"\x89\x65\x2F\x83\x7B\x83\x45\x83\x59",                             "f00", FISH_ITEM_NONE,             0.0f,   0.0f,  0.0f,   0.0f,   0.0f,  0.0f, 0.0f, {FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},          {FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE}        },
    {"\x83\x6E\x83\x4F\x83\x6E\x83\x4F",                                 "f19", FISH_ITEM_HAGUHAGU,         145.0f, 50.0f, 80.0f,  133.0f, 60.0f, 0.8f, 0.8f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},                 {FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL}   },
    {"\x83\x7B\x81\x5B\x83\x7B\x81\x5B",                                 "f01", FISH_ITEM_BOUBOU,           89.0f,  50.0f, 106.0f, 160.0f, 60.0f, 1.0f, 1.0f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},           {FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL}   },
    {"\x83\x4B\x83\x75\x83\x89",                                         "f02", FISH_ITEM_GABURA,           98.0f,  60.0f, 120.0f, 186.0f, 50.0f, 1.2f, 1.2f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE},               {FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL}      },
    {"\x83\x6D\x83\x93\x83\x4C\x81\x5B",                                 "f03", FISH_ITEM_NONKII,           130.0f, 50.0f, 130.0f, 200.0f, 45.0f, 1.1f, 1.1f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},     {FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL}      },
    {"\x83\x4A\x83\x57\x81\x5B",                                         "f04", FISH_ITEM_KAJII,            175.0f, 80.0f, 145.0f, 153.0f, 60.0f, 1.5f, 1.5f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE},         {FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE}       },
    {"\x83\x6F\x83\x4E\x83\x6F\x83\x4E",                                 "f05", FISH_ITEM_BAKUBAKU,         145.0f, 60.0f, 100.0f, 46.0f,  50.0f, 1.3f, 1.3f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE},        {FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL}      },
    {"\x83\x7D\x81\x5B\x83\x5F\x83\x93\x83\x4B\x83\x89\x83\x84\x83\x93", "f06", FISH_ITEM_MAADANGARAYAN,    105.0f, 40.0f, 80.0f,  130.0f, 80.0f, 4.0f, 1.5f, {FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},        {FISH_AFFINITY_NONE, FISH_AFFINITY_HIGH, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW}          },
    {"\x83\x4F\x83\x7E\x81\x5B",                                         "f07", FISH_ITEM_GUMII,            100.0f, 40.0f, 50.0f,  70.0f,  30.0f, 0.5f, 0.5f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},     {FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL}},
    {"\x83\x6A\x83\x89\x81\x5B",                                         "f08", FISH_ITEM_NIIRAA,           100.0f, 40.0f, 65.0f,  80.0f,  40.0f, 1.0f, 1.0f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},   {FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL}},
    {"\x83\x45\x83\x7D\x83\x5F\x83\x4A\x83\x89",                         "f10", FISH_ITEM_UMADAKARA,        105.0f, 60.0f, 90.0f,  100.0f, 60.0f, 1.4f, 1.4f, {FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},        {FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_HIGH}          },
    {"\x83\x5E\x81\x5B\x83\x67\x83\x93",                                 "f11", FISH_ITEM_TAATON,           100.0f, 40.0f, 80.0f,  100.0f, 60.0f, 0.9f, 0.9f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},         {FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL}      },
    {"\x83\x73\x83\x62\x83\x52\x83\x8A\x81\x5B",                         "f12", FISH_ITEM_PIKKORII,         100.0f, 40.0f, 50.0f,  70.0f,  20.0f, 0.7f, 0.7f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},              {FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE}    },
    {"\x83\x7B\x83\x93",                                                 "f13", FISH_ITEM_BON,              80.0f,  50.0f, 80.0f,  100.0f, 40.0f, 0.8f, 0.8f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE}, {FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL}},
    {"\x83\x6E\x83\x7D\x83\x6E\x83\x7D",                                 "f14", FISH_ITEM_HAMAHAMA,         105.0f, 50.0f, 106.0f, 130.0f, 50.0f, 1.4f, 1.4f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE},            {FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE}    },
    {"\x83\x6C\x83\x57\x81\x5B",                                         "f15", FISH_ITEM_NEJII,            100.0f, 40.0f, 50.0f,  80.0f,  30.0f, 0.8f, 0.8f, {FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE},       {FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW}   },
    {"\x83\x66\x83\x93",                                                 "f16", FISH_ITEM_DEN,              100.0f, 50.0f, 80.0f,  100.0f, 60.0f, 1.0f, 1.0f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},          {FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL}   },
    {"\x83\x71\x83\x43\x83\x89",                                         "f17", FISH_ITEM_HIIRA,            100.0f, 40.0f, 50.0f,  80.0f,  30.0f, 0.7f, 0.7f, {FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE},                  {FISH_AFFINITY_NORMAL, FISH_AFFINITY_LOW, FISH_AFFINITY_NORMAL, FISH_AFFINITY_NORMAL}   },
    {"\x92\x6A\x8E\xDD\x83\x4B\x83\x89\x83\x84\x83\x93",                 "f18", FISH_ITEM_DANSHAKU_GARAYAN, 105.0f, 80.0f, 90.0f,  100.0f, 70.0f, 2.0f, 2.0f, {FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NONE, FISH_AFFINITY_NORMAL},        {FISH_AFFINITY_HIGH, FISH_AFFINITY_LOW, FISH_AFFINITY_NONE, FISH_AFFINITY_LOW}          }
};

/**
 *
 * Item numbers of the baits and lures, indexed by local bait number.
 *
 */
static int EsaInfo[18] = {
    0x11F, 0x120, 0x121, 0x122, 0x123, 0x124,
    0x138, 0x139, 0x13A, 0x13B, 0x13C, 0x13D, 0x13E, 0x13F,
    0x179, 0x17A, 0x17B, 0x17C};

/**
 *
 * Model file names of the four lures.
 *
 */
static char *lure_file[4] = {"supina.chr", "kaeru.chr", "lure01.chr", "fork.chr"};

enum {
    kCameraSettled = 1000
};

enum {
    kLastFishParam = 18
};

enum {
    kLoadThreadPriority = 10
};

enum {
    kCharaModeReel = 6,
    kCharaModeReel2 = 7,
};

enum {
    kCaptureSeed = 0xC31AFF
};

static void CharaControl(CScene *scene, CPadControl *pad);
void        SelectCastingPoint(CScene *scene, CPadControl *pad);
void        CastingLoop(CScene *scene, CPadControl *pad);
void        UkiWaitLoop(CScene *scene, CPadControl *pad);
void        BattleLoop(CScene *scene, CPadControl *pad);
void        FalseLoop(CScene *scene, CPadControl *pad);
void        SuccessLoop(CScene *scene, CPadControl *pad);
int         CheckFishing(float *pos, CCPoly *polys, int count);
/**
 *
 * Allocates the scripted fishing place map table.
 *
 */
static int fpFISH_MAP_NUM(SPI_STACK *args, int arg_count);

/**
 *
 * Starts a scripted fishing place map definition.
 *
 */
static int fpFISH_MAP(SPI_STACK *args, int arg_count);

/**
 *
 * Sets the area and location of the current fishing place map.
 *
 */
static int fpFISH_PLACE(SPI_STACK *args, int arg_count);

/**
 *
 * Adds a fish appearance entry to the current fishing place map.
 *
 */
static int fpFISH(SPI_STACK *args, int arg_count);

/**
 *
 * Finishes the current fishing place map definition.
 *
 */
static int fpFISH_MAP_END(SPI_STACK *args, int arg_count);

/**
 *
 * Dispatches the fishing place script tags to their definition handlers.
 *
 */
static SPI_TAG_PARAM tag[6] = {
    {"FISH_MAP_NUM", fpFISH_MAP_NUM},
    {"FISH_MAP",     fpFISH_MAP    },
    {"FISH_PLACE",   fpFISH_PLACE  },
    {"FISH",         fpFISH        },
    {"FISH_MAP_END", fpFISH_MAP_END},
    {NULL,           NULL          }
};

/**
 *
 * Returns the unused allocation capacity of a stack memory buffer.
 *
 */
static inline int FreeSize(mgCMemory *memory) {
    return memory->stack_size - memory->stack_used;
}

/**
 *
 * Returns the start of unused allocation space in a stack memory buffer.
 *
 */
static inline u_long128 *FreeTop(mgCMemory *memory) {
    return memory->stGetTop();
}

/**
 *
 * Water effects used by the fishing subgame.
 *
 */
static CEffectScriptMan *EffectMan;

/**
 *
 * Loaded fishing sound bank.
 *
 */
static u_int FishSnd;

/**
 *
 * Loaded catch fanfare sound bank.
 *
 */
static u_int FanSnd;

/**
 *
 * Character model of the float fishing rod.
 *
 */
static CCharacter2 *UkiRod;

/**
 *
 * Character model of the lure fishing rod.
 *
 */
static CCharacter2 *LureRod;

/**
 *
 * Character model of the fishing float.
 *
 */
static CCharacter2 *Uki;

/**
 *
 * Character model of the equipped lure.
 *
 */
static CCharacter2 *Lure;

/**
 *
 * Character model of the fishing hook.
 *
 */
static CCharacter2 *Hari;

/**
 *
 * Texture block for fishing equipment.
 *
 */
static int FishingTexb;

/**
 *
 * Texture block for the caught fish.
 *
 */
static int FishTexb;

/**
 *
 * Texture block for the fishing interface.
 *
 */
static int SystemTexb;

/**
 *
 * Texture block for bait and lures.
 *
 */
static int EsaTexb;

/**
 *
 * Player character controlled by the fishing subgame.
 *
 */
static CCharacter2 *MainChara;

/**
 *
 * Character model of the landed fish.
 *
 */
static CCharacter2 *FishChara;

/**
 *
 * Character model of the equipped bait.
 *
 */
static CCharacter2 *EsaChara;

/**
 *
 * Character models used by the casting cursor.
 *
 */
static CCharacter2 *CursorChara[2];

/**
 *
 * Player hand frame carrying the fishing rod.
 *
 */
static mgCFrame *RodHand;

/**
 *
 * Frame of the fishing float.
 *
 */
static mgCFrame *UkiFrame;

/**
 *
 * Frame of the equipped lure.
 *
 */
static mgCFrame *LureFrame;

/**
 *
 * Frame of the fishing hook.
 *
 */
static mgCFrame *HariFrame;

/**
 *
 * Previous horizontal rod input.
 *
 */
static float oldPadRx;

/**
 *
 * Previous vertical rod input.
 *
 */
static float oldPadRy;

/**
 *
 * Whether the selected casting point is valid.
 *
 */
static int CastOKFlag;

/**
 *
 * Event to run after the fishing fade completes.
 *
 */
static int RunEventNo;

/**
 *
 * Whether the current map permits the Mardan fishing event.
 *
 */
static int MardanEventMap;

/**
 *
 * Whether the selected fishing place triggers the Mardan event.
 *
 */
static int MardanEventPlace;

/**
 *
 * Current fishing character mode.
 *
 */
static int CharaMode;

/**
 *
 * Requested next fishing character mode.
 *
 */
static int NextCharaMode;

/**
 *
 * Whether fishing resource loading has completed.
 *
 */
static int fgLoopMode;

/**
 *
 * Current fishing resource loading step.
 *
 */
static int fgLoopStep;

/**
 *
 * Frames elapsed during fishing initialization.
 *
 */
static int fgLoopCnt;

/**
 *
 * Equipped fishing rod item number.
 *
 */
static int RodNo;

/**
 *
 * Equipped bait item number.
 *
 */
static int EsaNo;

/**
 *
 * Equipped bait's index in the fishing bait table.
 *
 */
static int LocalEsaNo;

/**
 *
 * Selected fish's affinity for the equipped bait.
 *
 */
static int FavoredEsa;

/**
 *
 * Equipped lure model index.
 *
 */
static int LureNo;

/**
 *
 * Selected casting distance.
 *
 */
static float CastDist;

/**
 *
 * Fish size multiplier derived from casting distance.
 *
 */
static float CastDistSizeRate;

/**
 *
 * Current float or lure waiting state.
 *
 */
static int UkiMode;

/**
 *
 * Frames remaining in the float or lure waiting state.
 *
 */
static int UkiModeCnt;

/**
 *
 * Lure action points remaining before a bite.
 *
 */
static int RodActionPoint;

/**
 *
 * Shared buffer used to read fishing resources.
 *
 */
static u_long128 *ReadBuffer;

/**
 *
 * Whether the hooked fish model has been loaded.
 *
 */
static int LoadFishFlag;

/**
 *
 * Whether external fishing motion loading is pending.
 *
 */
static int LoadExMotionFlag;

/**
 *
 * Current fishing line tension.
 *
 */
static float LineTension;

/**
 *
 * Change in line tension during the current frame.
 *
 */
static float addLineTension;

/**
 *
 * Minimum line tension reached during the fish battle.
 *
 */
static float MinLineTension;

/**
 *
 * Line length at the start of the fish battle.
 *
 */
static float LineMaxLen;

/**
 *
 * Minimum line length at the start of the fish battle.
 *
 */
static float LineMinLen;

/**
 *
 * Fish distance at the start of the fish battle.
 *
 */
static float FishMaxLen;

/**
 *
 * Distance at which the fish can be landed.
 *
 */
static float FishMinLen;

/**
 *
 * Frames elapsed during the fish battle.
 *
 */
static int BattleCount;

/**
 *
 * Whether the player is winding the reel.
 *
 */
static int WindReel;

/**
 *
 * Rod action state during the fish battle.
 *
 */
static int RodStatus;

/**
 *
 * Frames remaining in the rod action state.
 *
 */
static int RodStatusCnt;

/**
 *
 * Recent player rod actions.
 *
 */
static int ActionCount;

/**
 *
 * Frames until recent rod actions begin to decay.
 *
 */
static int ActionDecCount;

/**
 *
 * Fishing subgame exit result.
 *
 */
static int RetCode;

/**
 *
 * Frames remaining for the hit banner.
 *
 */
static int DrawHit;

/**
 *
 * Frames remaining for the catch banner.
 *
 */
static int DrawCongra;

/**
 *
 * Whether fishing replaced the scene's loaded music.
 *
 */
static int BgmReadFlag;

/**
 *
 * Frames before the fish battle music starts.
 *
 */
static int BattleBgmCnt;

/**
 *
 * Loaded external fishing motion buffer.
 *
 */
static u_long128 *ex_mtn_buff;

/**
 *
 * Fishing loading thread stack size in bytes.
 *
 */
int stack_size;

/**
 *
 * Aligned address of the fishing loading thread stack.
 *
 */
static int ThreadStack;

/**
 *
 * Fishing loading thread identifier.
 *
 */
static int TheadID;

/**
 *
 * Whether the fishing loading thread is active.
 *
 */
static int ThreadRunning;

/**
 *
 * Whether the fishing loading thread has completed.
 *
 */
static int step_end_flag;

/**
 *
 * Current casting animation stage.
 *
 */
static int CastStep;

/**
 *
 * Frames elapsed during the current casting stage.
 *
 */
static int CastCount;

/**
 *
 * Duration of the tackle's casting flight.
 *
 */
static int CastTime;

/**
 *
 * Frames remaining in the casting character motion.
 *
 */
static int CastMotionCnt;

/**
 *
 * Whether the player has performed a rod action.
 *
 */
static int RodActFlag;

/**
 *
 * Whether the camera is watching the float.
 *
 */
static int UkiCameraFlag;

/**
 *
 * Camera angle restored after watching the float.
 *
 */
static float UkiCamOldRot;

/**
 *
 * Current failure or success presentation stage.
 *
 */
static int FalseStep;

/**
 *
 * Current catch result message stage.
 *
 */
static int FalseStep2;

/**
 *
 * Frames remaining in the failure or success motion.
 *
 */
static int FalseMotionCount;

/**
 *
 * Result of adding the caught fish to the aquarium.
 *
 */
static int GetItemRet;

/**
 *
 * Catch result message number.
 *
 */
static int FishMesNo;

/**
 *
 * Caught fish message font height.
 *
 */
static int FishFontH;

/**
 *
 * Number of fish appearance maps.
 *
 */
static int FishPlaceMapNum;

/**
 *
 * Fish appearance map table.
 *
 */
static FISH_PLACE_MAP *FishPlaceMap;

/**
 *
 * Memory stack used to parse fish appearance data.
 *
 */
static mgCMemory *fpStack;

/**
 *
 * Fish appearance map currently being parsed.
 *
 */
static FISH_PLACE_MAP *fpNowFishPlaceMap;

/**
 *
 * Number of the fish appearance map currently being parsed.
 *
 */
static u_int fpNowFishPlaceMapNum;

/**
 *
 * Selected world position to cast toward.
 *
 */
static Vec4 CastPoint;

/**
 *
 * World position of the casting cursor.
 *
 */
static Vec4 CastPointCur;

/**
 *
 * Attributes of the equipped fishing rod.
 *
 */
static FISHING_ROD_DATA RodData;

/**
 *
 * Selected fish and its battle state.
 *
 */
static FISH_DATA FishData;

/**
 *
 * Scene music status restored after fishing.
 *
 */
static CScene::BGM_STATUS BgmStatus;

/**
 *
 * Storage for bait and lure resources.
 *
 */
static mgCMemory EsaStack;

/**
 *
 * Storage for fishing sound resources.
 *
 */
static mgCMemory SndStack;

/**
 *
 * Camera state used while entering fishing.
 *
 */
static CCameraControl CameraInfo;

/**
 *
 * Camera state used while watching the fishing float.
 *
 */
static CCameraControl UkiCameraInfo;

/**
 *
 * Storage for external fishing character motion.
 *
 */
static mgCMemory MotionBuff;

/**
 *
 * Memory stack used to read fishing resources.
 *
 */
static mgCMemory ReadStack;

/**
 *
 * Storage for the fishing subgame resources.
 *
 */
static mgCMemory FishingBuff;

/**
 *
 * Storage for the hooked fish model.
 *
 */
static mgCMemory FishStack;

// Code (.text)
/**
 *
 * Returns the fish parameter record for a valid fish index.
 *
 */
static FISH_PARAM *GetFishParam(int index) {
    if (index < 0 || index > kLastFishParam) {
        return NULL;
    }

    return &FishParam[index];
}

/**
 *
 * Clears bait and lure state and resets the lure object.
 *
 */
void EsaInit() {
    CObjectFrame *lure = Lure;
    EsaChara = 0;
    LureFrame = 0;
    EsaNo = -1;
    LocalEsaNo = -1;
    FavoredEsa = -1;
    LureNo = -1;
    lure->Initialize();
}

/**
 *
 * Restores the scene BGM that played before fishing.
 *
 */
void ReplayPrevBGM(CScene *scene) {
    u_long128 *read_buff;

    if (BgmReadFlag == 0) {
        scene->SetActiveBgmStatus(&BgmStatus);
        return;
    }

    read_buff = &scene->read_buff[0x10000];

    if (BgmStatus.load_no < 0) {
        scene->StopBGM(0);
        scene->InitBGM();
        return;
    }

    scene->LoadBGM(BgmStatus.load_no, read_buff);
    scene->SetActiveBgmStatus(&BgmStatus);
}

/**
 *
 * Starts background loading of fishing motion resources.
 *
 */
int LoadExMotionBG(SubGameInfo *info, u_long128 *buffer) {
    LoadExMotionFlag = 0;

    if (info->dungeon != 0) {
        return 0;
    }

    StartReadBG();

    if (LoadFileBG("chara/c01_fishing.chr", buffer, 0) == 0) {
        return 0;
    }

    ex_mtn_buff = buffer;
    LoadExMotionFlag = 1;
    return 1;
}

/**
 *
 * Finishes loading and attaching fishing motion resources.
 *
 */
int LoadExMotionStep(SubGameInfo *info, mgCMemory *memory) {
    CCharacter2 *chara;
    CScene      *scene;

    if (info->dungeon != 0) {
        return 0;
    }

    if (ReadBGSync() != 0) {
        return 1;
    }

    if (LoadExMotionFlag == 0) {
        return 0;
    }

    scene = info->scene;
    chara = scene->GetCharacter(scene->player_chara);

    if (chara != NULL) {
        chara->LoadPack((u_int *) ex_mtn_buff, "info.cfg", memory, memory, memory, 0, NULL);
    }

    LoadExMotionFlag = 0;
    return 0;
}

/**
 *
 * Requests a fishing character mode change.
 *
 */
void SetNextMode(int mode) {
    NextCharaMode = mode;
}

/**
 *
 * Requests exit from the fishing subgame.
 *
 */
void ExitFishing(CScene *scene) {
    RetCode = 1;
}

int sgInitFishing(SubGameInfo *info) {
    CCharacter2 *chara;
    CScene      *scene;

    FishingTexb = info->texb;
    FishTexb = info->texb + 1;
    SystemTexb = info->texb + 2;
    EsaTexb = info->texb + 4;
    scene = info->scene;
    mgTexManager.DeleteBlock(FishingTexb);
    mgTexManager.DeleteBlock(FishTexb);
    mgTexManager.DeleteBlock(SystemTexb);
    LoadExMotionFlag = 0;
    u_long128 *read_buff = scene->read_buff;
    ReadBuffer = read_buff;

    if (info->menu_buff != NULL) {
        int        buffer_size = info->menu_buff->stGetSize();
        u_long128 *buffer_top = info->menu_buff->stack;
        ReadStack.stSetBuffer(buffer_top, buffer_size);
        ReadStack.stReset();
        ReadBuffer = ReadStack.stAlloc64(0x10000);
        ReadStack.Align64();
        int        remaining = ReadStack.stGetRest();
        u_long128 *top = ReadStack.stGetTop();
        MotionBuff.stSetBuffer(top, remaining);
    } else {
        MotionBuff.stSetBuffer(&read_buff[0x10000], 30000);
    }

    chara = scene->GetCharacter(scene->player_chara);

    if (chara != NULL) {
        if (chara->GetKeyListPtr("\x82\xB2\x82\xBB\x82\xB2\x82\xBB", NULL) != 0) {
            chara->SetMotion("\x82\xB2\x82\xBB\x82\xB2\x82\xBB", 0);
        } else {
            chara->SetMotion("\x97\xA7\x82\xBF", 0);
        }
    }

    fgLoopMode = 0;
    fgLoopStep = 0;
    fgLoopCnt = 0;
    info->no_map_event = info->dungeon;
    info->record_check = info->dungeon;
    return 1;
}

int sgRestartFishing(SubGameInfo *info) {
    CScene    *scene = info->scene;
    u_long128 *buffer = ReadBuffer;

    mgTexManager.DeleteBlock(EsaTexb);
    EsaStack.stack_used = 0;
    LocalEsaNo = -1;
    EsaStack.lock = 0;
    EsaChara = NULL;

    for (int i = 0; i < 18; i++) {
        if (info->esa_no == EsaInfo[i]) {
            LocalEsaNo = i;
            break;
        }
    }

    if (info->rod_no == (int) ITEM_ID_LURE_ROD) {
        SetFishingMode(kFishingModeLure);
        EsaChara = NULL;
        char lure_path[0x40] = "sg/fish/";
        int  lure_no = LocalEsaNo - 14;

        if (lure_no >= 4) {
            lure_no = -1;
        }

        LureFrame = NULL;

        if (lure_no >= 0) {
            strcat(lure_path, lure_file[lure_no]);

            if (LoadFile2(lure_path, buffer, NULL, LOAD_FILE_READ) != 0) {
                Lure->LoadPackNoLine((u_int *) buffer, "info.cfg", &EsaStack, &EsaStack, &EsaStack, EsaTexb, NULL);
            }

            LureFrame = Lure->CObjectFrame::frame;
        }

        InitLureObj(lure_no, LureFrame);

        if (lure_no < 0) {
            LureFrame = NULL;
            Lure->Initialize();
        }

        LureNo = lure_no;
    } else {
        SetFishingMode(kFishingModeFloat);
        char *esa_path = GetItemFilePath(info->esa_no, 0);

        if (esa_path != NULL) {
            if (*esa_path != 0 && LocalEsaNo >= 0) {
                CCharacter2 *esa_chara;
                esa_chara = new (EsaStack.Alloc(0x68)) CCharacter2;
                EsaChara = esa_chara;
                EsaChara->Initialize();

                if (LoadFile2(esa_path, buffer, NULL, LOAD_FILE_READ) != 0) {
                    EsaChara->LoadPackNoLine((u_int *) buffer, "info.cfg", &EsaStack, &EsaStack, &EsaStack, EsaTexb, NULL);
                } else {
                    EsaChara = NULL;
                }
            }
        }
    }

    sndSeAllStop(SND_PORT_ENEMY);
    sndSeAllStop(SND_PORT_MENU);

    if (sndSeCheck(FanSnd, 0) == 0) {
        mgCMemory sound_memory;
        int       sound_size = MotionBuff.stGetRest();
        sound_memory.stSetBuffer(MotionBuff.stGetTop(), sound_size);
        u_int *sound_buffer = (u_int *) sound_memory.stAlloc64(0x4000);

        if (sound_buffer != NULL && LoadFile2("snd2/sp/SP_006.snd", sound_buffer, NULL, LOAD_FILE_READ) != 0) {
            sndInitPort(SND_PORT_MENU);
            SndStack.stack_used = 0;
            SndStack.lock = 0;
            FanSnd = sndLoadSound(SND_PORT_MENU, sound_buffer, &SndStack);
        }
    }

    MardanEventMap = 0;
    MardanEventPlace = 0;
    CSaveData *save_data = GetSaveData();

    if (scene->now_map_no == 0x41) {
        if (save_data->GetBitFlag(0xEB) != 0 && save_data->GetBitFlag(0xF0) == 0) {
            MardanEventPlace = 0;
            MardanEventMap = 1;
        }
    }

    int rod_status[5];
    save_data->user_data.GetRodStatus(rod_status);
    RodData.status[0] = rod_status[0];
    RodData.status[1] = rod_status[1];
    RodData.status[2] = rod_status[2];
    RodData.status[3] = rod_status[3];
    RodData.status[4] = rod_status[4];
    float rate = 0.2f * ((float) RodData.status[3] / 100.0f);
    rate += 0.8f;
    RodData.status[0] = (int) (0.5f + (float) RodData.status[0] * rate);
    RodData.status[1] = (int) (0.5f + (float) RodData.status[1] * rate);
    RodData.status[2] = (int) (0.5f + (float) RodData.status[2] * rate);
    RodData.status4_rate = (float) RodData.status[4] / 100.0f;
    CastDist = 160.0f;
    SetWaterLevel(-100000.0f);
    return 1;
}

/**
 *
 * Resets fishing loading state and captures the active BGM status.
 *
 */
int InitDataLoading() {
    SubGameInfo *info;
    CScene      *scene;
    int          bgm_no;
    mgCMemory   *memory;

    info = GetNowSubGameInfo();
    memory = info->load_buff;
    scene = info->scene;

    if (memory != NULL) {
        memory->stack_used = 0;
        memory->lock = 0;
        memory->Align64();
    } else {
        scene->AssignStack(5);
        scene->GetStack(5);
    }

    bgm_no = scene->GetDefBgmNo(0x205);

    if (info->keep_bgm == 0) {
        scene->GetActiveBgmStatus(&BgmStatus);

        if (scene->CheckLoadBGM(bgm_no) != 0) {
            scene->StopBGM(0);
        }
    }

    EffectMan = scene->GetEffect(0);
    CharaMode = (int) FISHING_CHARA_MODE_CONTROL;
    NextCharaMode = -1;
    RunEventNo = -1;
    CastOKFlag = 0;
    MardanEventMap = 0;
    MardanEventPlace = 0;
    RodNo = info->rod_no;
    EsaNo = info->esa_no;
    RetCode = 0;
    oldPadRy = 0;
    oldPadRx = 0;
    DrawCongra = 0;
    DrawHit = 0;
    return 1;
}

/**
 *
 * Yields execution to the fishing loading thread.
 *
 */
int switch_thread() {
    return RotateThreadReadyQueue(kLoadThreadPriority);
}

/**
 *
 * Allocates and starts the fishing data loading thread.
 *
 */
int CreateLoadThread(mgCMemory *memory) {
    ThreadParam param;
    int         misalignment;

    stack_size = 0x40000;

    ThreadStack = (int) memory->Alloc(0x4001);
    misalignment = ThreadStack & 0x3F;

    if (misalignment != 0) {
        ThreadStack += 0x40 - misalignment;
    }

    param.entry = StepDataLoading;
    step_end_flag = 0;
    param.initPriority = kLoadThreadPriority;
    param.option = 0;
    param.gpReg = &_gp;
    param.stack = (void *) ThreadStack;
    param.stackSize = stack_size;
    TheadID = CreateThread(&param);
    ThreadRunning = 1;
    StartThread(TheadID, NULL);
    return 1;
}

/**
 *
 * Advances the fishing loading thread and reports whether it is active.
 *
 */
int StepLoadThread() {
    if (ThreadRunning == 0) {
        return 0;
    }

    switch_thread();

    return !(step_end_flag != 0);
}

/**
 *
 * Waits for and deletes the fishing data loading thread.
 *
 */
void DeleteLoadThread() {
    if (ThreadRunning != 0) {
        while (StepLoadThread() != 0) {
        }

        TerminateThread(TheadID);
        DeleteThread(TheadID);
        ThreadRunning = 0;
    }
}

/**
 *
 * Loads the fishing models, textures, sounds and scene configuration in the worker thread.
 *
 */
static void StepDataLoading(void *arg) {
    char               path[0x80];
    char               bgm_path[0x80];
    int                file_size;
    int                pack_size;
    mgCTextureManager *tex_manager = &mgTexManager;
    u_long128         *buffer = ReadBuffer;
    SubGameInfo       *info = GetNowSubGameInfo();
    CScene            *scene = info->scene;
    mgCMemory         *memory = info->load_buff;

    if (memory == NULL) {
        memory = scene->GetStack(5);
    }

    if (LoadFile2("sg/fish/fishing.cfg", buffer, &file_size, LOAD_FILE_READ) != 0) {
        LoadFishPlaceData((char *) buffer, file_size, memory);
    }

    StartReadBG();

    if (LanguageCode >= 2) {
        sprintf(path, "sg/fish/fishing2_%d.pak", LanguageCode);
    } else {
        strcpy(path, "sg/fish/fishing2.pak");
    }

    if (LoadFileBG(path, buffer, &pack_size) == 0) {
        step_end_flag = 1;
        return;
    }

    while (ReadBGSync() != 0) {
        switch_thread();
    }

    CCharacter2 *chara;
    chara = new (memory->Alloc(0x68)) CCharacter2;
    UkiRod = chara;
    chara = new (memory->Alloc(0x68)) CCharacter2;
    LureRod = chara;
    chara = new (memory->Alloc(0x68)) CCharacter2;
    Uki = chara;
    chara = new (memory->Alloc(0x68)) CCharacter2;
    Lure = chara;
    chara = new (memory->Alloc(0x68)) CCharacter2;
    Hari = chara;
    chara = new (memory->Alloc(0x68)) CCharacter2;
    CursorChara[0] = chara;
    chara = new (memory->Alloc(0x68)) CCharacter2;
    CursorChara[1] = chara;
    EsaChara = NULL;
    FishChara = NULL;
    UkiRod->Initialize();
    LureRod->Initialize();
    Uki->Initialize();
    Lure->Initialize();
    Hari->Initialize();
    CursorChara[0]->Initialize();
    CursorChara[1]->Initialize();
    BG_READ_INFO *read_info = GetReadBGFile(0);

    if (read_info == NULL) {
        step_end_flag = 1;
        return;
    }

    u_int *pack = (u_int *) read_info->buffer;
    int    bgm_no = scene->GetDefBgmNo(0x205);

    if (scene->CheckLoadBGM(bgm_no) != 0) {
        scene->GetBgmFile(bgm_path, bgm_no);
        u_int *bgm_pack = GetPackFile(pack, bgm_path, NULL);

        if (bgm_pack != NULL) {
            BgmReadFlag = 1;
            scene->LoadBGMPack(bgm_no, bgm_pack);
        }
    }

    switch_thread();
    scene->PlayBGM(0, -1, 1.0f);

    if (info->rod_no == (int) ITEM_ID_LURE_ROD) {
        u_int *rod_pack;

        if ((rod_pack = GetPackFile(pack, "f_rod2.chr", NULL)) != NULL) {
            UkiRod->LoadPackNoLine(rod_pack, "info.cfg", memory, memory, memory, FishingTexb, NULL);
        }
    } else {
        u_int *rod_pack;

        if ((rod_pack = GetPackFile(pack, "f_rod.chr", NULL)) != NULL) {
            UkiRod->LoadPackNoLine(rod_pack, "info.cfg", memory, memory, memory, FishingTexb, NULL);
        }
    }

    if (UkiRod->CObjectFrame::frame == NULL) {
        step_end_flag = 1;
        return;
    }

    u_int *cursor_pack = GetPackFile(pack, "c_point.chr", NULL);

    if (cursor_pack != NULL) {
        CursorChara[0]->LoadPackNoLine(cursor_pack, "info.cfg", memory, memory, memory, FishingTexb, NULL);
    }

    u_int *system_pack;

    if ((system_pack = GetPackFile(pack, "fish_juji.img", &pack_size)) != NULL) {
        int qwords;

        if ((u_int) pack_size & 0xF) {
            qwords = ((u_int) pack_size >> 4) + 1;
        } else {
            qwords = (u_int) pack_size >> 4;
        }

        u_char *copy = (u_char *) memory->Alloc(qwords);

        if (copy != NULL) {
            memcpy(copy, system_pack, pack_size);
            tex_manager->EnterIMGFile(copy, SystemTexb, NULL, NULL);
        }
    }

    u_int *fish_pack;

    if ((fish_pack = GetPackFile(pack, "linetens.img", &pack_size)) != NULL) {
        int qwords;

        if ((u_int) pack_size & 0xF) {
            qwords = ((u_int) pack_size >> 4) + 1;
        } else {
            qwords = (u_int) pack_size >> 4;
        }

        u_char *copy = (u_char *) memory->Alloc(qwords);

        if (copy != NULL) {
            memcpy(copy, fish_pack, pack_size);
            tex_manager->EnterIMGFile(copy, SystemTexb, NULL, NULL);
        }
    }

    u_int *uki_pack = GetPackFile(pack, "uki.chr", NULL);

    if (uki_pack != NULL) {
        Uki->LoadPackNoLine(uki_pack, "info.cfg", memory, memory, memory, FishingTexb, NULL);
    }

    u_int *hari_pack;

    if ((hari_pack = GetPackFile(pack, "hari.chr", NULL)) != NULL) {
        Hari->LoadPackNoLine(hari_pack, "info.cfg", memory, memory, memory, FishingTexb, NULL);
    }

    mgCFrame *uki_frame = Uki->CObjectFrame::frame;
    UkiFrame = uki_frame;
    mgCFrame *hari_frame = Hari->CObjectFrame::frame;
    HariFrame = hari_frame;

    if (uki_frame == NULL || hari_frame == NULL) {
        step_end_flag = 1;
        return;
    }

    CCharacter2 *main_chara;
    MainChara = main_chara = scene->GetCharacter(scene->player_chara);

    if (main_chara == NULL || main_chara->CObjectFrame::frame == NULL) {
        step_end_flag = 1;
        return;
    }

    RodHand = main_chara->CObjectFrame::frame->SearchFrame("gun_hand");

    if (RodHand == NULL) {
        step_end_flag = 1;
        return;
    }

    UkiRod->CObjectFrame::frame->SetReference(RodHand);
    InitRodPoint(RodHand, UkiRod->CObjectFrame::frame);
    InitUkiObj(0, UkiFrame, HariFrame);
    EsaStack.stSetBuffer(memory->Alloc(8000), 8000);
    FishSnd = -1;
    FanSnd = -1;
    SndStack.stSetBuffer(memory->Alloc(100), 100);

    if (LoadFile2("snd2/mon/EN_901.snd", buffer, NULL, LOAD_FILE_READ) != 0) {
        sndInitPort(SND_PORT_ENEMY);
        FishSnd = sndLoadSound(SND_PORT_ENEMY, (u_int *) buffer, memory);
    }

    if (LoadFile2("snd2/sp/SP_006.snd", buffer, NULL, LOAD_FILE_READ) != 0) {
        sndInitPort(SND_PORT_MENU);
        SndStack.stack_used = 0;
        SndStack.lock = 0;
        FanSnd = sndLoadSound(SND_PORT_MENU, (u_int *) buffer, &SndStack);
    }

    if (info->dungeon != 0) {
        if (LoadFile2("chara/c01_fishing.chr", buffer, NULL, LOAD_FILE_READ) != 0) {
            MainChara->LoadPack((u_int *) buffer, "info.cfg", memory, memory, memory, 0, NULL);
        }
    }

    sgRestartFishing(info);
    printf("fg remain = %dkb\n", (memory->stack_size - memory->stack_used) * 16 / 1024);
    step_end_flag = 1;
}

int sgBreakFishing() {
    DeleteLoadThread();
    sgExitFishing(GetNowSubGameInfo());
    return 1;
}

int sgExitFishing(SubGameInfo *info) {
    CCharacter2 *chara;
    CScene      *scene;

    mgTexManager.DeleteBlock(FishingTexb);
    mgTexManager.DeleteBlock(FishTexb);
    mgTexManager.DeleteBlock(SystemTexb);
    ReEquipFishingGameWeapon();

    if (info != NULL && info->scene != NULL) {
        ReplayPrevBGM(info->scene);
    }

    scene = info->scene;
    chara = scene->GetCharacter(scene->player_chara);

    if (chara != NULL) {
        chara->DeleteExtMotion();
        chara->SetMotion("\x97\xA7\x82\xBF", 0);
    }

    BgmReadFlag = 0;
    return 1;
}

int sgLoopFishing(SubGameInfo *info) {
    CScene      *scene = info->scene;
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);

    if (fgLoopMode == 0) {
        fgLoopCnt++;
        CharaControl(scene, NULL);

        switch (fgLoopStep) {
            case 0:
                if (fgLoopCnt < 3) {
                    return 0;
                }

                while (0 < scene->bg_load_step) {
                    return 0;
                }

                fgLoopStep++;
            case 1:
                InitDataLoading();
                fgLoopStep++;
                return 0;
            case 2:
                MotionBuff.stReset();
                CreateLoadThread(&MotionBuff);
                fgLoopStep++;
            case 3:
                if (StepLoadThread() != 0) {
                    return 0;
                }

                fgLoopStep++;
            case 4:
                scene->fade.CaptureScreen();
                scene->fade.CrossFade(20, 1.0f);
                fgLoopStep++;
                return 0;
            case 5:
                if (chara != NULL) {
                    chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x97\xA7\x82\xBF", 4);
                    chara->UpdatePosition();
                    chara->Step();
                }

                DeleteLoadThread();
                fgLoopStep = 0;
                fgLoopMode = 1;
                fgLoopCnt = 0;
                break;
            default:
                ExitFishing(scene);
                sgExitFishing(info);
                return RetCode;
        }
    }

    CPadControl *pad = &PadCtrl;
    sgSetMenuOpenEnableFlag(0);

    switch (CharaMode) {
        case (int) FISHING_CHARA_MODE_CONTROL:
            CharaControl(scene, pad);
            break;
        case (int) FISHING_CHARA_MODE_SELECT_POINT:
            SelectCastingPoint(scene, pad);
            break;
        case (int) FISHING_CHARA_MODE_CASTING:
            CastingLoop(scene, pad);
            break;
        case (int) FISHING_CHARA_MODE_UKI_WAIT:
            UkiWaitLoop(scene, pad);
            break;
        case (int) FISHING_CHARA_MODE_BATTLE:
            BattleLoop(scene, pad);
            break;
        case (int) FISHING_CHARA_MODE_FALSE:
            FalseLoop(scene, pad);
            break;
        case (int) FISHING_CHARA_MODE_SUCCESS:
            SuccessLoop(scene, pad);

            if (FishChara != NULL) {
                FishChara->Step();
            }

            break;
    }

    oldPadRx = pad->Analog(5);
    oldPadRy = pad->Analog(4);

    if (NextCharaMode >= 0) {
        CharaMode = NextCharaMode;
    }

    if (CharaMode == (int) FISHING_CHARA_MODE_CONTROL) {
        sgSetMenuOpenEnableFlag(1);
    }

    DrawHit--;

    if (DrawHit < 0) {
        DrawHit = 0;
    }

    DrawCongra--;

    if (DrawCongra < 0) {
        DrawCongra = 0;
    }

    if (RetCode != 0) {
        sgExitFishing(info);
    }

    return RetCode;
}

int sgLoopFishing2(SubGameInfo *info) {
    CScene *scene;

    u_long128    poly_buffer[0x1400];
    float        hand_pos[4];
    CCharacter2 *chara;
    mgCFrame    *frame;

    if (fgLoopMode == 0) {
        return 0;
    }

    scene = info->scene;
    MainChara->UpdatePosition();
    UkiRod->CObjectFrame::frame->SetReference(RodHand);
    RodStep(scene, poly_buffer);

    if (CharaMode == FISHING_CHARA_MODE_FALSE || CharaMode == FISHING_CHARA_MODE_SUCCESS) {
        chara = scene->GetCharacter(scene->player_chara);

        if (chara != NULL) {
            frame = chara->CObjectFrame::frame;

            if (frame != NULL) {
                frame = frame->SearchFrame("item");
            }

            if (frame != NULL) {
                frame->GetWorldPosition0(hand_pos);

                if (CatchLine(hand_pos, 50.0f) == 0) {
                    SlowLineVelo(0.2f);
                }
            }
        }
    }

    return 0;
}

int sgDrawFishing(SubGameInfo *info) {
    sceVu0FMATRIX uki_matrix;
    sceVu0FMATRIX lure_matrix;

    if (fgLoopMode == 0) {
        return 0;
    }

    mgCTextureManager *textures = &mgTexManager;
    textures->ReloadTexture(FishingTexb, (sceVif1Packet *) NULL);
    UkiRod->DrawDirect();
    float hook_offset[4] = {0.0f, -3.5f, 1.0f, 0.0f};

    if (LureFrame != NULL && SetLurePose(LureFrame) != 0) {
        if (GetShowHari() != 0) {
            textures->ReloadTexture(EsaTexb, (sceVif1Packet *) NULL);
            mgDrawDirect(LureFrame);
        }

        LureFrame->GetLWMatrix(uki_matrix);
        sceVu0FVECTOR lure_swap_row;
        *(u_long128 *) lure_swap_row = *(u_long128 *) uki_matrix[0];
        *(u_long128 *) uki_matrix[0] = *(u_long128 *) uki_matrix[2];
        *(u_long128 *) uki_matrix[2] = *(u_long128 *) lure_swap_row;
        sceVu0ScaleVector(uki_matrix[2], uki_matrix[2], -1.0f);
        *(u_long128 *) lure_matrix[0] = *(u_long128 *) uki_matrix[0];
        *(u_long128 *) lure_matrix[1] = *(u_long128 *) uki_matrix[1];
        *(u_long128 *) lure_matrix[2] = *(u_long128 *) uki_matrix[2];
        *(u_long128 *) lure_matrix[3] = *(u_long128 *) uki_matrix[3];
        LureFrame->GetWorldPosition(lure_matrix[3], hook_offset);
    }

    textures->ReloadTexture(FishingTexb, (sceVif1Packet *) NULL);

    if (SetUkiPose(UkiFrame, HariFrame) != 0) {
        mgDrawDirect(UkiFrame);

        if (GetShowHari() != 0) {
            mgDrawDirect(HariFrame);
        }

        HariFrame->GetLWMatrix(uki_matrix);
        sceVu0FVECTOR hari_swap_row;
        *(u_long128 *) hari_swap_row = *(u_long128 *) uki_matrix[1];
        *(u_long128 *) uki_matrix[1] = *(u_long128 *) uki_matrix[2];
        *(u_long128 *) uki_matrix[2] = *(u_long128 *) hari_swap_row;
        sceVu0ScaleVector(uki_matrix[0], uki_matrix[0], -1.0f);
        *(u_long128 *) lure_matrix[0] = *(u_long128 *) uki_matrix[0];
        *(u_long128 *) lure_matrix[1] = *(u_long128 *) uki_matrix[1];
        *(u_long128 *) lure_matrix[2] = *(u_long128 *) uki_matrix[2];
        *(u_long128 *) lure_matrix[3] = *(u_long128 *) uki_matrix[3];
        HariFrame->GetWorldPosition(lure_matrix[3], hook_offset);
    }

    if (CharaMode == (int) FISHING_CHARA_MODE_SELECT_POINT) {
        char *cursor_motion[2] = {"NG", "OK"};
        CursorChara[0]->SetMotion(cursor_motion[CastOKFlag], 0);
        CursorChara[0]->SetPosition(CastPointCur.v);
        CursorChara[0]->Step();
        CursorChara[0]->DrawDirect();
    }

    if (EsaChara != NULL && FishChara == NULL) {
        textures->ReloadTexture(EsaTexb, (sceVif1Packet *) NULL);
        EsaChara->SetPosition(lure_matrix[3]);
        mgZeroVectorW(lure_matrix[3]);

        if (EsaChara->CObjectFrame::frame != NULL) {
            EsaChara->CObjectFrame::frame->SetTransMatrix(lure_matrix);
        }

        if (GetShowHari() != 0) {
            EsaChara->DrawDirect();
        }
    }

    if (FishChara != NULL) {
        textures->ReloadTexture(FishTexb, (sceVif1Packet *) NULL);
        FishChara->SetPosition(uki_matrix[3]);
        mgZeroVectorW(uki_matrix[3]);

        if (FishChara->CObjectFrame::frame != NULL) {
            FishChara->CObjectFrame::frame->SetTransMatrix(uki_matrix);
        }

        FishChara->DrawDirect();
    }

    DrawFishingLine();
    return 0;
}

/**
 *
 * Draws one digit of a fishing interface number.
 *
 */
void DrawNumber(mgCDrawPrim *prim, int digit, int x, int y) {

    int tex_u = 0;
    tex_u += digit * 12;
    prim->TextureCrd(tex_u, 0x72);
    prim->Vertex(x, y, 0);
    prim->TextureCrd(tex_u + 12, 0x80);
    prim->Vertex(x + 12, y + 14, 0);
}

int sgSystemDrawFishing(SubGameInfo *info) {
    CScene     *scene;
    mgCTexture *system_texture;
    mgCTexture *banner_texture;
    int         top;
    int         gauge_top;
    float       reach;
    float       line_length;
    int         length;
    float       fill;
    float       bottom_y;
    float       tension;
    float       fish_dist;
    int         hundreds;
    int         tens;
    int         ones;

    if (fgLoopMode == 0) {
        return 0;
    }

    mgTexManager.ReloadTexture(SystemTexb, (sceVif1Packet *) NULL);
    DrawFishingActionChance();
    scene = info->scene;
    system_texture = mgTexManager.GetTexture("linetens", SystemTexb);
    banner_texture = mgTexManager.GetTexture("turi_hit", SystemTexb);

    mgCDrawPrim prim;

    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.DepthTestEnable(0);
    prim.Coord(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);
    prim.TextureMapEnable(0);

    if (CharaMode == (int) FISHING_CHARA_MODE_BATTLE) {
        top = mgScreenHeight - 0x47;
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x15, 0x29, 0x47, 0x60);
        prim.Vertex(0x156, top + 0x25, 0);
        prim.Vertex(0x1C4, top + 0x2A, 0);
        prim.End();
        fish_dist = GetFishDist(scene);
        reach = (FishMaxLen - fish_dist) / (FishMaxLen - FishMinLen);

        if (reach < 0.0f) {
            reach = 0.0f;
        }

        if (!(reach <= 1.0f)) {
            reach = 1.0f;
        }

        line_length = GetNowLineLength();
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x15, 0x29, 0xFF, 0x80);
        prim.Vertex(342.0f + 110.0f * reach, (float) (top + 0x25), 0.0f);
        prim.Vertex(0x1C4, top + 0x2A, 0);
        prim.End();
        prim.Bilinear(0);
        prim.TextureMapEnable(1);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(system_texture);
        prim.TextureCrd(0, 0x34);
        prim.Vertex(0x146, top, 0);
        prim.TextureCrd(0xA8, 0x6A);
        prim.Vertex(0x1EE, top + 0x36, 0);
        prim.End();
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(system_texture);
        gauge_top = mgScreenHeight - 0x36;
        length = fptosi(line_length / 2.0f);
        hundreds = length / 100;
        length %= 100;
        tens = length / 10;
        length %= 10;
        DrawNumber(&prim, hundreds, 0x18B, gauge_top);
        DrawNumber(&prim, tens, 0x194, gauge_top);
        DrawNumber(&prim, length, 0x1A3, gauge_top);
        prim.End();
        prim.Bilinear(1);
        prim.TextureMapEnable(0);
        top = mgScreenHeight - 0xD7;
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x15, 0x29, 0x47, 0x60);
        prim.Vertex(0x1D5, top + 0x14, 0);
        prim.Vertex(0x1E1, top + 0x96, 0);
        prim.End();
        tension = LineTension;
        fill = 130.0f * (1.0f - (float) tension);
        float tension_end[4] = {21.0f, 41.0f, 255.0f, 128.0f};
        float tension_color[4] = {255.0f, 20.0f, 10.0f, 128.0f};
        sceVu0InterVectorXYZ(tension_color, tension_color, tension_end, tension);
        prim.Shading(1);
        prim.Begin(MG_PRIM_TRIANGLE_STRIP);
        prim.Color(fptosi(tension_end[0]), fptosi(tension_end[1]), fptosi(tension_end[2]), 0x80);
        bottom_y = (float) (top + 0x96);
        prim.Vertex(469.0f, bottom_y, 0.0f);
        prim.Color(fptosi(tension_end[0]), fptosi(tension_end[1]), fptosi(tension_end[2]), 0x80);
        prim.Vertex(481.0f, (float) (top + 0x96), 0.0f);
        prim.Color(fptosi(tension_color[0]), fptosi(tension_color[1]), fptosi(tension_color[2]),
                   0x80);
        fill = fill + (float) (top + 0x14);
        prim.Vertex(469.0f, fill, 0.0f);
        prim.Color(fptosi(tension_color[0]), fptosi(tension_color[1]), fptosi(tension_color[2]),
                   0x80);
        prim.Vertex(481.0f, fill, 0.0f);
        prim.End();
        prim.Begin(MG_PRIM_TRIANGLE_STRIP);
        prim.Color(0xFF, 0xFF, 0xFF, 0x20);
        prim.Vertex(0x1D5, top + 0x14, 0);
        prim.Color(0xFF, 0xFF, 0xFF, 0);
        prim.Vertex(0x1E1, top + 0x14, 0);
        prim.Color(0xFF, 0xFF, 0xFF, 0x20);
        prim.Vertex(0x1D5, top + 0x96, 0);
        prim.Color(0xFF, 0xFF, 0xFF, 0);
        prim.Vertex(0x1E1, top + 0x96, 0);
        prim.End();
        prim.Bilinear(0);
        prim.TextureMapEnable(1);
        prim.Begin(MG_PRIM_TRIANGLE_STRIP);
        prim.Texture(system_texture);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.TextureCrd(0, 0x34);
        prim.Vertex(0x1C3, top, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex(0x1F6, top, 0);
        prim.TextureCrd(0xA8, 0x34);
        prim.Vertex(0x1C3, top + 0xA7, 0);
        prim.TextureCrd(0xA8, 0);
        prim.Vertex(0x1F6, top + 0xA7, 0);
        prim.End();
    }

    prim.TextureMapEnable(1);

    if (DrawCongra > 0) {
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(banner_texture);
        prim.TextureCrd(0, 0);
        prim.Vertex(0x80, 0xBD, 0);
        prim.TextureCrd(0x100, 0x26);
        prim.Vertex(0x180, 0xE3, 0);
        prim.End();
    }

    if (DrawHit > 0) {
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(banner_texture);
        prim.TextureCrd(0, 0x50);
        prim.Vertex(0x80, 0xB8, 0);
        prim.TextureCrd(0x100, 0x80);
        prim.Vertex(0x180, 0xE8, 0);
        prim.End();
    }

    return 1;
}

/**
 *
 * Updates player movement and camera control during fishing.
 *
 */
static void CharaControl(CScene *scene, CPadControl *pad) {
    mgCCameraFollow  *camera;
    CCharacter2      *chara;
    float             position[4];
    float             rotation[4];
    float             velocity[4];
    float             matrix[4][4];
    EditMoveCharaInfo idle_info;
    float             turn_rotation[4];
    EditMoveCharaInfo move_info;
    float             camera_angle;
    float             stick_y;
    float             stick_x;
    float             move_x;
    float             move_z;
    float             target_angle;
    float             turned_angle;
    float             turn_delta;
    float             stick_length;
    int               can_cast;

    chara = scene->GetCharacter(scene->player_chara);

    if (chara != NULL) {
        camera = (mgCCameraFollow *) scene->GetCamera(scene->active_camera);

        if (camera != NULL) {
            switch (camera->Iam()) {
                case kCameraSettled:
                    break;
                default:
                    return;
            }

            chara->GetPosition(position);
            chara->GetRotation(rotation);
            mgCreateMatrixPY(matrix, position, rotation[1]);
            *(u_long128 *) velocity = *(u_long128 *) chara->velocity;

            if (pad == NULL) {
                memset(&idle_info.move_info, 0, sizeof(idle_info.move_info));
                memset(&idle_info, 0, sizeof(idle_info));
                velocity[1] -= 0.6f;
                EditMoveChara(scene, velocity, &idle_info);
                EditCameraControl(scene, NULL, NULL);
                return;
            }

            camera_angle = camera->GetAngle();
            stick_y = pad->Analog(5);
            stick_x = pad->Analog(4);
            move_x = stick_y * cosf(camera_angle) + stick_x * sinf(camera_angle);
            move_z = -stick_y * sinf(camera_angle) + stick_x * cosf(camera_angle);
            move_x *= 3.5f;
            move_z *= 3.5f;

            if (DebugInfo.chara_move != 0) {
                if (GamePad__2.On(PAD_L2) != 0) {
                    move_x *= 3.0f;
                    move_z *= 3.0f;
                }

                if (pad->Btn(kPadButtonDebugJump) != 0) {
                    velocity[1] = 8.0f;
                }
            }

            velocity[0] = move_x;
            velocity[2] = move_z;
            velocity[1] -= 0.6f;

            if (move_x != 0.0f || move_z != 0.0f) {
                chara->GetRotation(turn_rotation);
                target_angle = atan2f(move_x, move_z);
                turned_angle = mgAngleInterpolate(turn_rotation[1], target_angle, 0.3f, 0);
                turn_delta = target_angle - turned_angle;

                if (turn_delta < 0.0f) {
                    turn_delta = -turn_delta;
                }

                if (!((float) fptosi(turn_delta) <= 1.0f)) {
                    velocity[0] *= 0.5f;
                    velocity[2] *= 0.5f;
                }

                chara->SetRotation(0.0f, turned_angle, 0.0f);
                stick_length = sqrtf(stick_y * stick_y + stick_x * stick_x);

                if (stick_length < 0.8f) {
                    chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x95\xE0\x82\xAB", 0);
                    chara->SetStep(0.1f + stick_length / 0.8f);
                } else {
                    chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x91\x96\x82\xE8", 0);
                }
            } else {
                chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x97\xA7\x82\xBF", 0);
            }

            memset(&move_info.move_info, 0, sizeof(move_info.move_info));
            memset(&move_info, 0, sizeof(move_info));
            EditMoveChara(scene, velocity, &move_info);
            EditCameraControl(scene, pad, NULL);
            float cast_dir[4] = {0.0f, 0.0f, 160.0f, 1.0f};
            sceVu0ApplyMatrix(cast_dir, matrix, cast_dir);
            can_cast = move_info.move_info.landed;

            if (GetFishingMode() == 2 && LureNo < 0) {
                can_cast = 0;
            }

            if (can_cast != 0 && CheckCasting(scene, position, cast_dir) != 0) {
                ShowHelpMes(0x65, 1);

                if (pad->Btn(kPadButtonCast) != 0 && InitSelectCastingPoint(scene) != 0) {
                    SetNextMode((int) FISHING_CHARA_MODE_SELECT_POINT);
                }
            }

            if (GetNowSubGameInfo()->no_map_event == 0) {
                float event_pos[4];
                chara->GetPosition(event_pos);

                union {
                    CSceneEventData data;

                    struct {
                        u_char unknown_00[8];
                        int    event_no;
                    } fields;
                } event_data;

                if (scene->GetMapEvent(event_pos, 0, &event_data.data) != 0) {
                    scene->RunEvent(event_data.fields.event_no, &event_data.data);
                    ExitFishing(scene);
                }

                scene->map_event_no = 0;
            }
        }
    }
}

/**
 *
 * Sets up the camera and character for choosing a casting point.
 *
 */
int InitSelectCastingPoint(CScene *scene) {
    CCharacter2     *chara = scene->GetCharacter(scene->player_chara);
    CCameraControl  *camera;
    float            position[4];
    CameraCtrlParam *param;

    if (chara == NULL) {
        return 0;
    }

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (camera == NULL || camera->Iam() != kCameraSettled) {
        return 0;
    }

    chara->GetRotation(position);
    camera->CopyParam(CameraInfo);
    param = camera->GetActiveParam();
    param->max_dist = 120.0f;
    param->min_dist = 120.0f;
    param->near_height = 12.0f;
    param->far_height = 12.0f;

    if (GetCaptureMode() != 0) {
        srand(kCaptureSeed);
    }

    LoadExMotionBG(GetNowSubGameInfo(), ReadBuffer);
    return 1;
}

/**
 *
 * Restores camera state after choosing a casting point.
 *
 */
int EndSelectCastingPoint(CScene *scene) {
    CCameraControl *camera = (CCameraControl *) scene->GetCamera(scene->active_camera);
    CCharacter2    *chara;

    if (camera == NULL || camera->Iam() != kCameraSettled) {
        return 1;
    }

    CameraInfo.CopyParam(*camera);

    if (GetNowSubGameInfo()->dungeon == 0) {
        chara = scene->GetCharacter(scene->player_chara);

        if (chara != NULL) {
            chara->DeleteExtMotion();
            chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x97\xA7\x82\xBF", 4);
        }
    }

    SetWaterLevel(-100000.0f);
    CastOKFlag = 0;
    return 1;
}

/**
 *
 * Updates the cast target and camera from player input.
 *
 */
void SelectCastingPoint(CScene *scene, CPadControl *pad) {
    CCharacter2    *chara;
    CCameraControl *camera;
    float           matrix[4][4];
    float           rotation[4];
    float           position[4];
    float           angle_diff;
    float           turn;
    float           max_dist;
    float           cast_distance;
    float           ratio;
    float           lean;
    float           lean_abs;
    int             saved_cancel;
    int             castable;

    if (pad == NULL) {
        return;
    }

    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return;
    }

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (camera == NULL) {
        return;
    }

    switch (camera->Iam()) {
        case kCameraSettled:
            break;
        default:
            return;
    }

    chara->GetPosition(position);
    chara->GetRotation(rotation);
    mgCreateMatrixPY(matrix, position, rotation[1]);
    angle_diff = mgAngleLimit(rotation[1] - mgAngleLimit(camera->GetAngle() - 3.1415927f));
    turn = 0.0f;

    if (!(angle_diff <= 0.4f)) {
        turn = 0.2f * mgAngleLimit(angle_diff - 0.4f);
    }

    if (angle_diff < -0.4f) {
        turn = 0.2f * mgAngleLimit(0.4f + angle_diff);
    }

    camera->Rotate(turn);
    CastDist -= 5.0f * pad->Analog(4);
    max_dist = 240.0f * (0.5f * (1.0f + (float) RodData.status[0] / 100.0f));
    max_dist += 160.0f;

    if (CastDist < 160.0f) {
        CastDist = 160.0f;
    }

    if (!(CastDist <= max_dist)) {
        CastDist = max_dist;
    }

    cast_distance = CastDist;
    CastDistSizeRate = (cast_distance - 160.0f) / 240.0f;
    CastDistSizeRate = 0.8f + 0.4f * CastDistSizeRate;
    float cast_dir[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float target[4];
    float follow_offset[4];
    cast_dir[2] = cast_distance;
    sceVu0ApplyMatrix(cast_dir, matrix, cast_dir);
    camera->GetFollowOffset(follow_offset);
    sceVu0AddVector(target, cast_dir, follow_offset);
    float camera_pos[4];
    camera->GetPos(camera_pos);
    ratio = mgDistVectorXZ(camera_pos, position);
    ratio = ratio / mgDistVectorXZ(camera_pos, cast_dir);
    float diff[4];
    sceVu0SubVector(diff, target, camera_pos);
    sceVu0ScaleVector(diff, diff, ratio);
    sceVu0AddVector(target, diff, camera_pos);
    sceVu0SubVector(target, target, follow_offset);
    target[0] = position[0];
    target[2] = position[2];
    saved_cancel = camera->rot_cancel;
    camera->BitSetRotCameraCancel((int) CAMERA_ROT_CANCEL_AUTO_MOVE);
    EditCameraControl(scene, pad, NULL);
    camera->SetRotCameraCancel(saved_cancel);
    castable = CheckCasting(scene, position, cast_dir);

    if (mgDistVectorXZ(camera_pos, position) < 30.0f) {
        castable = 0;
    }

    if (castable > 0) {
        CastOKFlag = 1;
    } else {
        CastOKFlag = 0;
    }

    *(u_long128 *) &CastPoint = *(u_long128 *) cast_dir;
    *(u_long128 *) &CastPointCur = *(u_long128 *) cast_dir;

    if (CastOKFlag != 0) {
        SetWaterLevel(cast_dir[1]);
        ShowHelpMes(0x66, 1);
    } else {
        SetWaterLevel(-100000.0f);
        ShowHelpMes(0x6A, 1);

        if (!(cast_dir[1] <= position[1])) {
            cast_dir[1] = position[1];
        }
    }

    CastPoint.v[1] = cast_dir[1];
    CastPointCur.v[1] = cast_dir[1];
    lean = 0.05f * -pad->Analog(5);
    lean_abs = lean < 0.0f ? -lean : lean;

    if (!(lean_abs <= 0.01f)) {
        rotation[1] = mgAngleLimit(rotation[1] + lean);
        chara->SetRotation(rotation);
        chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x95\xE0\x82\xAB", 0);
    } else {
        chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x97\xA7\x82\xBF", 0);
    }

    ReadBG();

    if (CastOKFlag != 0 && pad->Btn(kPadButtonCast) != 0) {
        if (InitCasting(scene) != 0) {
            SetNextMode((int) FISHING_CHARA_MODE_CASTING);
        }
    } else if (pad->Btn(kPadButtonCancel) != 0) {
        BreakReadBG();

        if (EndSelectCastingPoint(scene) != 0) {
            SetNextMode((int) FISHING_CHARA_MODE_CONTROL);
        }
    }
}

/**
 *
 * Starts a scaled water ripple effect at the fishing position.
 *
 */
void DrawHamon(float *pos, float scale) {
    if (EffectMan != NULL) {
        float pos_vec[4];
        Vec4  scale_vec = {
            {0.0f, 0.0f, 0.0f, 0.0f}
        };
        scale_vec.v[0] = scale;
        scale_vec.v[1] = scale;
        scale_vec.v[2] = scale;
        *(u_long128 *) pos_vec = *(u_long128 *) pos;
        pos_vec[1] = 0.5f + GetWaterLevel();
        EffectMan->CreateEffSpt("\x91\xAB\x94\x67\x96\xE4", 0, 0);
        EffectMan->SetScriptVect1(pos_vec, -1, -1);
        EffectMan->SetScriptVect2(scale_vec.v, -1, -1);
    }
}

/**
 *
 * Starts a scaled water splash effect at the fishing position.
 *
 */
void DrawSplash(float *pos, float scale) {
    if (EffectMan != NULL) {
        float pos_vec[4];
        Vec4  scale_vec = {
            {0.0f, 0.0f, 0.0f, 0.0f}
        };
        scale_vec.v[0] = scale;
        scale_vec.v[1] = scale;
        scale_vec.v[2] = scale;
        *(u_long128 *) pos_vec = *(u_long128 *) pos;
        pos_vec[1] = 0.5f + GetWaterLevel();
        EffectMan->CreateEffSpt("\x91\xAB\x90\x85\x83\x70\x83\x56\x83\x83", 0, 0);
        EffectMan->SetScriptVect1(pos_vec, -1, -1);
        EffectMan->SetScriptVect2(scale_vec.v, -1, -1);
    }
}

/**
 *
 * Returns the motion frame count clamped to the requested bounds.
 *
 */
int GetMotionCount(CCharacter2 *chara, char *name, int min_count, int max_count, int min_speed) {
    CHRINFO_KEY_SET *list;
    float            speed;
    float            floor;
    int              count;

    list = chara->GetKeyListPtr(name, NULL);

    if (list == NULL) {
        return min_count;
    }

    speed = list->step;
    floor = (float) min_speed;

    if (speed < floor) {
        speed = floor;
    }

    count = fptosi((float) (list->end_frame - list->start_frame) / speed);

    if (count <= min_count) {
        count = min_count;
    }

    if (count >= max_count) {
        count = max_count;
    }

    return count;
}

/**
 *
 * Starts the character casting animation and prepares its motion buffer.
 *
 */
int InitCasting(CScene *scene) {
    CCharacter2 *chara;

    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return 0;
    }

    MotionBuff.stack_used = 0;
    MotionBuff.lock = 0;

    while (LoadExMotionStep(GetNowSubGameInfo(), &MotionBuff) != 0) {
    }

    chara->SetMotion("\x65\x78\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x97\xA7\x82\xBF", 4);
    chara->Step();
    CastStep = 0;
    CastTime = 60;
    CastCount = 0;
    chara->SetMotion("\x8A\xC6\x93\x8A\x82\xB0", 2);
    CastMotionCnt = GetMotionCount(chara, "\x8A\xC6\x93\x8A\x82\xB0", 20, 300, 0);
    return 1;
}

/**
 *
 * Updates the casting animation and thrown tackle.
 *
 */
void CastingLoop(CScene *scene, CPadControl *pad) {
    CCharacter2 *chara;
    float        hari_pos[4];
    float        hari_prev[4];
    chara = scene->GetCharacter(scene->player_chara);

    if (chara != NULL) {
        EditCameraControl(scene, pad, NULL);
        GetHariPos(hari_pos, hari_prev);

        if (hari_pos[1] <= GetWaterLevel() && !(hari_prev[1] <= GetWaterLevel())) {
            DrawHamon(hari_pos, 0.8f);
            sndSePlay(FishSnd, 4, 0);
        }

        if (CastStep == 0) {
            CastCount += 1;

            if (CastCount == 0x23) {
                sndSePlay(FishSnd, 0, 0);
                CastTime = CastingLure(CastPoint.v);
            }

            CastMotionCnt -= 1;

            if (CastMotionCnt <= 0) {
                CastCount = 0;
                CastStep = 1;
                chara->SetMotion("\x8A\xC6\x82\xBD\x82\xE7\x82\xB5\x97\xA7\x82\xBF", 0);
                return;
            }
        } else if (CastStep == 1) {
            CastCount += 1;

            if (CastCount >= CastTime) {
                EndCastingLure();

                if (InitUkiWait(scene) != 0) {
                    SetNextMode((int) FISHING_CHARA_MODE_UKI_WAIT);
                }
            }
        }
    }
}

/**
 *
 * Resets the float waiting state after a cast.
 *
 */
int InitUkiWait(CScene *scene) {
    RodActFlag = 0;
    UkiMode = kUkiStart;
    UkiModeCnt = 0;
    UkiCameraFlag = 0;
    return 1;
}

void ResetUkiCamera(CCameraControl *camera) {
    if (UkiCameraFlag != 0) {
        camera->RotBack(UkiCamOldRot);

        if (camera != NULL) {
            UkiCameraInfo.CopyParam(*camera);
        }
    }

    UkiCameraFlag = 0;
}

/**
 *
 * Updates float movement and player input while waiting for a bite.
 *
 */
void UkiWaitLoop(CScene *scene, CPadControl *pad) {
    int              moved;
    int              up_push;
    int              right_push;
    int              left_push;
    CCharacter2     *chara;
    CCameraControl  *camera;
    int              pushed;
    CameraCtrlParam *param;
    float            stick_side;
    float            stick_up;
    int              up_now;
    u_char           right_now;
    u_char           left_now;
    u_char           up_old;
    u_char           right_old;
    u_char           left_old;
    int              reel_result;
    int              reel_sound;
    int              reel_held;
    int              caught;
    float            hari_pos[4];
    float            hari_prev[4];
    float            chara_pos[4];
    float            hari_now[4];
    float            hari_now_prev[4];
    float            uki_pos[4];
    float            uki_prev[4];
    float            chara_now[4];
    float            camera_target[1][4];
    float            uki_pos2[4];
    float            dist;
    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return;
    }

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (UkiMode == kUkiReeledIn) {
        UkiModeCnt += 1;

        if (UkiModeCnt > 15) {
            EndSelectCastingPoint(scene);

            if (chara != NULL) {
                chara->SetMotion("\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x97\xA7\x82\xBF", 4);
            }

            SetNextMode((int) FISHING_CHARA_MODE_CONTROL);
        }

        return;
    }

    moved = 1;
    stick_side = pad->Analog(kFishAxisSide);
    stick_up = pad->Analog(kFishAxisUp);

    if (stick_up > 0.8f) {
        RodActFlag = 1;
        chara->SetMotion("\x82\xB5\x82\xE1\x82\xAD\x82\xE8\x8F\xE3", 6);
    } else if (stick_side > 0.8f) {
        RodActFlag = 1;
        chara->SetMotion("\x82\xB5\x82\xE1\x82\xAD\x82\xE8\x89\x45", 6);
    } else if (stick_side < -0.8f) {
        RodActFlag = 1;
        chara->SetMotion("\x82\xB5\x82\xE1\x82\xAD\x82\xE8\x8D\xB6", 6);
    } else {
        chara->SetMotion("\x8A\xC6\x82\xBD\x82\xE7\x82\xB5\x97\xA7\x82\xBF", 0);
        moved = 0;
    }

    right_now = stick_side > 0.8f;
    left_now = stick_side < -0.8f;
    up_old = oldPadRy > 0.8f;
    right_old = oldPadRx > 0.8f;
    left_old = oldPadRx < -0.8f;
    up_now = stick_up > 0.8f;
    up_push = up_now && !up_old;
    right_push = right_now && !right_old;
    left_push = left_now && !left_old;
    pushed = up_push || right_push || left_push;
    reel_result = 0;
    reel_held = 0;
    reel_sound = 7;

    if (pad->Btn(kFishBtnReel) != 0) {
        reel_sound = 7;
        reel_result = ExtendLine(-1.0f);
        moved = reel_held = 1;
    } else if (pad->Btn(kFishBtnReelFast) != 0) {
        reel_result = ExtendLine(-2.5f);
        moved = 1;
        reel_held = moved;
        reel_sound = 8;
    }

    if (reel_result < 0) {
        UkiMode = kUkiReeledIn;

        if (chara != NULL) {
            chara->SetMotion("\x65\x78\x82\xC2\x82\xE8\x8A\xC6\x8E\x9D\x82\xBF\x97\xA7\x82\xBF", 0);
        }

        UkiModeCnt = 0;
        return;
    }

    if (reel_held != 0) {
        scene->loop_se.SeLoopPlayStop(FishSnd, reel_sound, 2, 13);
    }

    GetHariPos(hari_pos, hari_prev);
    chara->GetPosition(chara_pos);

    if (!(hari_pos[1] <= GetWaterLevel() - 3.0f)) {
        if (GetFishingMode() == kFishingModeFloat) {
            FishData.fish_no = -1;
        }
    }

    if (mgDistVectorXZ(chara_pos, hari_pos) < 160.0f) {
        FishData.fish_no = -1;
    }

    static int hamon_count = 0;
    static int boze_cnt;
    static int pull_uki_cnt;
    static int act_count;
    static int charge_point;
    static int act_interval;

    caught = 0;
    GetHariPos(hari_now, hari_now_prev);
    GetUkiPos(uki_pos, uki_prev);
    chara->GetPosition(chara_now);
    dist = mgDistVectorXZ(chara_now, hari_now);

    if (dist < 160.0f) {
        dist = 160.0f;
    }

    if (!(dist <= 400.0f)) {
        dist = 400.0f;
    }

    CastDistSizeRate = (dist - 160.0f) / 240.0f;
    CastDistSizeRate = 0.8f + 0.4f * CastDistSizeRate;

    if (GetFishingMode() == kFishingModeFloat) {
        ShowHelpMes(0x67, 1);

        switch (UkiMode) {
            case kUkiStart:
                scene->ResetStatus(SCENE_DATA_CHARA, scene->player_chara, 0x20);
                UkiModeCnt = GetUkiWaitTime(&FishData, scene, hari_now, RodNo, LocalEsaNo);
                boze_cnt = 0;
                UkiMode = kUkiWaitBite;
                hamon_count = 10;
            case kUkiWaitBite:
                if (moved != 0 || boze_cnt > 0x258) {
                    UkiMode = kUkiStart;
                } else {
                    if (hamon_count <= 0) {
                        DrawHamon(uki_pos, 0.4f);
                        hamon_count = fptosi(50.0f * mgRnd()) + 30;
                    }

                    hamon_count -= 1;

                    if (FishData.fish_no < 0) {
                        boze_cnt += 1;
                    } else if (UkiModeCnt <= 0) {
                        UkiMode = kUkiPoke;
                        UkiModeCnt = GetUkiPokeTime(&FishData);
                        pull_uki_cnt = 0;
                    }
                }

                break;
            case kUkiPoke:
                if (moved != 0) {
                    UkiMode = kUkiStart;
                } else {
                    if (UkiModeCnt <= 0) {
                        if (FishData.fish_no <= 0) {
                            UkiMode = kUkiStart;
                            break;
                        }

                        UkiMode = kUkiPull;
                        UkiModeCnt = GetUkiPullTime(&FishData);
                    }

                    if (pull_uki_cnt <= 0) {
                        PullUki(2.0f + 5.0f * mgRnd());
                        GamePad__2.SetVibration(1, 0x50, 10);
                        pull_uki_cnt = rand() % 10 + 5;
                        DrawHamon(uki_pos, 0.6f);
                    }

                    pull_uki_cnt -= 1;
                }

                break;
            case kUkiPull:
                if (FishData.fish_no <= 0) {
                    UkiMode = kUkiStart;
                } else {
                    scene->SetStatus(SCENE_DATA_CHARA, scene->player_chara, 0x20);

                    if (pushed != 0) {
                        caught = 1;
                    }

                    GamePad__2.SetVibration(1, 0x96, 4);

                    if (UkiModeCnt <= 0) {
                        UkiMode = kUkiStart;
                    } else {
                        PullUki(10.0f);
                    }
                }

                break;
        }
    } else {
        ShowHelpMes(0x68, 1);

        switch (UkiMode) {
            case kUkiStart:
                scene->ResetStatus(SCENE_DATA_CHARA, scene->player_chara, 0x20);
                RodActionPoint = GetUkiWaitTime(&FishData, scene, hari_now, RodNo, LocalEsaNo);
                act_count = 0;
                UkiMode = kUkiCharge;
                charge_point = 0;
                act_interval = 0;
            case kUkiCharge:
                if (act_count <= 0 && pushed != 0) {
                    RodActionPoint -= charge_point;
                    act_count = 0;
                    charge_point = 0;
                }

                if (pushed != 0 || pad->Btn(kFishBtnAction) != 0) {
                    if (act_interval < 3) {
                        RodActionPoint = RodActionPoint + fptosi(3.0f * mgRnd());
                    } else {
                        charge_point += fptosi(10.0f * mgRnd()) + 2;
                        RodActionPoint = RodActionPoint - fptosi(3.0f * mgRnd());
                    }

                    act_interval = 0;
                    act_count = fptosi(30.0f * mgRnd()) + 10;
                    DrawHamon(hari_now, 0.5f);
                    sndSePlay(FishSnd, 10, 0);
                }

                act_interval += 1;
                act_count -= 1;

                if (FishData.fish_no >= 0 && RodActionPoint < 0) {
                    UkiMode = kUkiBite;
                    UkiModeCnt = 0x23;
                    DrawHamon(hari_now, 0.8f);
                    DrawSplash(hari_now, 0.5f);
                    sndSePlay(FishSnd, 11, 0);
                }

                break;
            case kUkiBite:
                if (UkiModeCnt < 0x20 && pushed != 0) {
                    caught = 1;
                }

                scene->SetStatus(SCENE_DATA_CHARA, scene->player_chara, 0x20);
                GamePad__2.SetVibration(1, 0x96, 4);

                if (UkiModeCnt <= 0) {
                    UkiMode = kUkiStart;
                } else {
                    PullUki(10.0f);
                }

                break;
        }
    }

    UkiModeCnt -= 1;

    if (UkiModeCnt < 0) {
        UkiModeCnt = 0;
    }

    camera->SetRotCameraCancel((int) CAMERA_ROT_CANCEL_AUTO_MOVE);

    if (caught == 0 && GetFishingMode() == kFishingModeFloat) {
        GetUkiPos(camera_target[0], uki_pos2);

        if (!(camera_target[0][1] <= 1.0f + GetWaterLevel())) {
            ResetUkiCamera(camera);
        }

        if (moved != 0) {
            ResetUkiCamera(camera);
        }

        if (UkiCameraFlag != 0) {
            camera_target[0][1] = GetWaterLevel() - 20.0f;
            EditCameraControl(scene, NULL, camera_target);
        } else {
            EditCameraControl(scene, pad, NULL);
        }
    } else {
        EditCameraControl(scene, pad, NULL);
    }

    if (GetFishingMode() == kFishingModeFloat) {
        if (pad->Btn(kFishBtnCameraToggle) != 0) {
            if (UkiCameraFlag == 0) {
                UkiCamOldRot = camera->GetAngle();
                UkiCameraFlag = 1;
                camera->CopyParam(UkiCameraInfo);
                param = camera->GetActiveParam();
                param->SetFixHeight(100.0f);
                param->SetFixDist(80.0f);
                param->no_check = 1;
            } else {
                ResetUkiCamera(camera);
            }
        }
    }

    camera->SetRotCameraCancel(0);

    if (caught != 0) {
        ResetUkiCamera(camera);
        scene->ResetStatus(SCENE_DATA_CHARA, scene->player_chara, 0x20);

        if (InitBattle(scene) != 0) {
            GamePad__2.SetVibration(0, 1, 5);
            SetNextMode((int) FISHING_CHARA_MODE_BATTLE);
            sndSePlay(FishSnd, 0x12, 0);

            if (MardanEventMap != 0 && MardanEventPlace != 0) {
                RunEventNo = 0x1F9;
                scene->fade.FadeOut(0x14, 0.0f, 0.0f, 0.0f);
            }

            LoadFishFlag = FishLoadBG(&FishData, ReadBuffer);
        }
    }
}

/**
 *
 * Sets up the character and camera for a hooked fish battle.
 *
 */
int InitBattle(CScene *scene) {
    CCharacter2     *chara;
    CCameraControl  *camera;
    CameraCtrlParam *param;
    float            chara_rot[4];
    float            chara_pos[4];
    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return 0;
    }

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (camera == NULL || camera->Iam() != kFishCameraState) {
        return 0;
    }

    chara->GetPosition(chara_pos);
    chara->GetRotation(chara_rot);
    param = camera->GetActiveParam();
    param->max_dist = 80.0f;
    param->min_dist = 80.0f;
    param->near_height = 12.0f;
    param->far_height = 12.0f;
    camera->RotBack(mgAngleLimit(3.1415927f + chara_rot[1] - 0.2f));
    camera->Step(-1);
    InitFishBattle();
    LineTension = 0;
    addLineTension = 0;
    MinLineTension = 0;
    LineMaxLen = GetNowLineLength();
    LineMinLen = GetMinLineLength();
    FishMaxLen = GetFishDist(scene);
    FishMinLen = 90.0f;
    DrawHit = 60;
    RodStatus = 0;
    RodStatusCnt = 0;
    ActionCount = 0;
    ActionDecCount = 0;
    WindReel = 0;
    BattleBgmCnt = 0;
    scene->StopBGM(0);
    BattleCount = 0;
    return 1;
}

/**
 *
 * Updates player input, line tension, and fish behavior during a battle.
 *
 */
void BattleLoop(CScene *scene, CPadControl *pad) {
    int          pushed;
    int          released;
    CCharacter2 *chara;
    float        stick_side;
    float        stick_up;
    u_char       up_now;
    u_char       right_now;
    u_char       left_now;
    u_char       up_old;
    u_char       right_old;
    u_char       left_old;
    int          rod_dir;
    int          rod_chance;
    int          rod_sound;
    int          reel_result;
    int          finished;
    float        hari_pos[4];
    float        hari_prev[4];
    CCPoly       polys[0x400];
    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return;
    }

    EditCameraControl(scene, pad, NULL);
    ReadBG();
    ShowHelpMes(0x69, 1);

    if (RunEventNo > 0 && scene->fade.FadeCheck() != 0) {
        scene->StopBGM(0);
        scene->InitBGM();
        scene->RunEvent(RunEventNo, NULL);
        EsaInit();
        EsaChara = 0;
        GetSaveData()->user_data.DeleteBait();
        EndSelectCastingPoint(scene);
        ExitFishing(scene);
        return;
    }

    if (BattleBgmCnt == 20) {
        scene->PlayBGM(1, -1, 1.0f);
    }

    BattleBgmCnt += 1;
    stick_side = pad->Analog(kFishAxisSide);
    stick_up = pad->Analog(kFishAxisUp);
    up_now = stick_up > 0.8f;
    right_now = stick_side > 0.8f;
    left_now = stick_side < -0.8f;
    up_old = oldPadRy > 0.8f;
    right_old = oldPadRx > 0.8f;
    left_old = oldPadRx < -0.8f;
    pushed = (up_now && !up_old) || (right_now && !right_old) || (left_now && !left_old);
    released = (!up_now && up_old) || (!right_now && right_old) || (!left_now && left_old);
    rod_dir = 0;

    if (right_now) {
        rod_dir = 1;
    }

    if (left_now) {
        rod_dir = -1;
    }

    rod_chance = CheckRodActionChance(rod_dir, &rod_sound);

    if (rod_sound != 0) {
        sndSePlay(FishSnd, 0x11, 0);
    }

    static int snd_cnt = 0;

    if (pushed) {
        GetHariPos(hari_pos, hari_prev);
        sndSePlay(FishSnd, 0xB, 0);
        DrawSplash(hari_pos, 0.5f);

        if (snd_cnt == 0) {
            sndSePlay(FishSnd, 9, 0);
            snd_cnt = 10;
        }
    }

    snd_cnt -= 1;

    if (snd_cnt < 0) {
        snd_cnt = 0;
    }

    switch (RodStatus) {
        case 0:
            if (pushed) {
                RodStatus = 1;
                RodStatusCnt = 20;
            } else if (released) {
                RodStatus = 2;
                RodStatusCnt = 20;
            }

            break;
        case 1:
            if (RodStatusCnt == 0) {
                RodStatus = 0;
            } else if (released) {
                RodStatus = 2;
            }

            break;
        case 2:
            if (RodStatusCnt == 0) {
                RodStatus = 0;
            } else if (pushed) {
                RodStatus = 1;
            }

            break;
    }

    RodStatusCnt -= 1;
    BattleCount += 1;

    if (stick_up > 0.8f) {
        chara->SetMotion("\x83\x71\x83\x62\x83\x67\x8E\x9E\x8A\xC6\x8F\xE3", 0);
    } else if (stick_side > 0.8f) {
        chara->SetMotion("\x83\x71\x83\x62\x83\x67\x8E\x9E\x8A\xC6\x89\x45", 0);
    } else if (stick_side < -0.8f) {
        chara->SetMotion("\x83\x71\x83\x62\x83\x67\x8E\x9E\x8A\xC6\x8D\xB6", 0);
    } else {
        chara->SetMotion("\x83\x71\x83\x62\x83\x67\x8E\x9E\x97\xA7\x82\xBF", 0);
    }

    reel_result = 0;

    if (pad->Btn(kFishBtnReel) != 0) {
        scene->loop_se.SeLoopPlayStop(FishSnd, 7, 2, 100);
        reel_result = ExtendLine(-1.0f);
        WindReel = 1;
    } else {
        WindReel = 0;
    }

    if (pushed || pad->Btn(kFishBtnAction) != 0) {
        ActionCount += 1;
        ActionDecCount = 10;
    }

    ActionDecCount -= 1;

    if (ActionDecCount <= 0) {
        ActionCount -= 1;

        if (ActionCount < 0) {
            ActionCount = 0;
        }
    }

    FishBattle(scene, polys, 0x400);
    LineTensionStep(&FishData, rod_chance);
    finished = 0;

    if (GetFishDist(scene) < FishMinLen || reel_result < 0) {
        finished = 1;
    }

    if (BattleCount < 100) {
        finished = 0;
    }

    if (MardanEventMap != 0 && MardanEventPlace != 0) {
        finished = 0;
    }

    if (!(LineTension < 1.0f)) {
        if (InitFalse(scene) != 0) {
            EndFishBattle();
            SetNextMode((int) FISHING_CHARA_MODE_FALSE);
            sndSePlay(FishSnd, 0x13, 0);
            scene->StopBGM(0);
        }
    } else if (finished != 0) {
        if (LoadFishFlag == 0) {
            if (InitFalse(scene) != 0) {
                EndFishBattle();
                SetNextMode((int) FISHING_CHARA_MODE_FALSE);
            }
        } else if (InitSuccess(scene) != 0) {
            EndFishBattle();
            SetNextMode((int) FISHING_CHARA_MODE_SUCCESS);
            sndSePlay(FishSnd, 0x14, 0);
            scene->StopBGM(0);
        }
    }
}

/**
 *
 * Returns the horizontal distance from the player to the current fish.
 *
 */
float GetFishDist(CScene *scene) {
    float        chara_rot[4];
    float        chara_pos[4];
    float        fish_pos[4];
    float        fish_velo[4];
    float        matrix[4][4];
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);
    chara->GetPosition(chara_pos);
    chara->GetRotation(chara_rot);
    mgUnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, chara_rot[1]);
    GetFishPosVelo(fish_pos, fish_velo);
    return mgDistVectorXZ(chara_pos, fish_pos);
}

/**
 *
 * Removes consumed bait and resets the lure state.
 *
 */
void DeleteEsa() {
    CSaveData *saved = GetSaveData();
    EsaInit();
    EsaChara = 0;
    saved->user_data.DeleteBait();
}

/**
 *
 * Sets up the character and camera after a failed catch.
 *
 */
int InitFalse(CScene *scene) {
    CCharacter2 *chara;
    mgCCamera   *camera;
    float        roll;
    float        chance;
    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return 0;
    }

    camera = scene->GetCamera(scene->active_camera);

    if (camera == NULL || camera->Iam() != kFishCameraState) {
        return 0;
    }

    ExtendLine(-1000.0f);
    ExtendLine(20.0f);
    ResetLineVelo();
    FalseStep = 0;
    chara->SetMotion("\x92\xDE\x82\xEA\x82\xC8\x82\xA2\x82\xAA\x82\xC1\x82\xA9\x82\xE8", 6);
    FalseMotionCount = GetMotionCount(chara, "\x92\xDE\x82\xEA\x82\xC8\x82\xA2\x82\xAA\x82\xC1\x82\xA9\x82\xE8", 20, 300, 0);
    roll = mgRnd();
    chance = 0.3f;
    chance *= 1.0f - 0.5f * RodData.status4_rate;

    if (GetFishingMode() == kFishingModeLure) {
        chance *= 0.5f;
    }

    if (roll < chance) {
        DeleteEsa();
    }

    return 1;
}

/**
 *
 * Updates the failed catch animation and camera.
 *
 */
void FalseLoop(CScene *scene, CPadControl *pad) {
    CCharacter2     *chara;
    CCameraControl  *camera;
    CameraCtrlParam *param;
    float            chara_rot[4];
    float            chara_pos[4];
    float            ref_pos[4];
    float            cam_pos[4];

    if (pad == NULL) {
        return;
    }

    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return;
    }

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (camera == NULL) {
        return;
    }

    switch (camera->Iam()) {
        case kFishCameraState:
            break;
        default:
            return;
    }

    chara->GetPosition(chara_pos);
    chara->GetPosition(ref_pos);
    chara->GetRotation(chara_rot);
    param = camera->GetActiveParam();
    param->max_dist = 80.0f;
    param->min_dist = 80.0f;
    param->near_height = -5.0f;
    param->far_height = -5.0f;
    param->min_height = -5.0f;
    ref_pos[1] += 15.0f;
    camera->GetPos(cam_pos);
    cam_pos[1] = 5.0f + ref_pos[1];
    camera->SetRef(ref_pos);
    camera->SetPos(cam_pos);
    camera->SetRotate(mgAngleLimit(chara_rot[1] - 0.2f));
    camera->Step(-1);
    FalseMotionCount -= 1;

    if (FalseStep == 0 && (FalseMotionCount <= 0 || chara->CheckMotionEnd() != 0)) {
        chara->SetMotion("\x92\xDE\x82\xEA\x82\xC8\x82\xA2\x82\xAA\x82\xC1\x82\xA9\x82\xE8\x4C", 4);
        FalseStep = 1;
        FalseMotionCount = 40;
    }

    if (FalseStep > 0 && FalseMotionCount <= 0 && pad->Btn(kFishBtnAction) != 0) {
        ExtendLine(-1000.0f);
        ResetLineVelo();
        EndSelectCastingPoint(scene);
        SetNextMode((int) FISHING_CHARA_MODE_CONTROL);
        camera->RotBack(mgAngleLimit(3.1415927f + chara_rot[1]));
        scene->PlayBGM(0, -1, 1.0f);
    }
}

/**
 *
 * Prepares caught fish data, rewards, and the success display.
 *
 */
#ifdef NONMATCHING
int InitSuccess(CScene *scene) {
    mgCTextureManager *tex_manager;
    CCharacter2       *fish_chara;
    CCharacter2       *chara;
    ClsMes            *message;
    CSaveData         *save_data;
    FISH_PARAM        *fish_param;
    int                fish_item_no;
    float              fish_size;
    float              fish_weight;
    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return 0;
    }

    mgCCamera *camera = scene->GetCamera(scene->active_camera);

    if (camera == NULL || camera->Iam() != kFishCameraState) {
        return 0;
    }

    tex_manager = &mgTexManager;
    FishFontH = 0;

    if (LoadFishFlag != 0) {
        while (ReadBGSync() != 0) {
        }

        int size = FreeSize(&MotionBuff);
        FishStack.stSetBuffer(FreeTop(&MotionBuff), size);
        FishStack.stack_used = 0;
        FishStack.lock = 0;

        fish_chara = new (FishStack.Alloc(0x68)) CCharacter2;

        FishChara = fish_chara;
        fish_chara->Initialize();
        tex_manager->DeleteBlock(FishTexb);
        FishChara->LoadPack((u_int *) ReadBuffer, "info.cfg", &FishStack, &FishStack, &FishStack,
                            FishTexb, NULL);
        FishChara->SetScale(FishData.width_scale, FishData.width_scale, FishData.length_scale);
        FishChara->SetMotion("\x92\xDE\x82\xEA\x82\xBD\x8E\x9E", 0);
    }

    ExtendLine(-1000.0f);
    ExtendLine(20.0f);
    ResetLineVelo();
    FalseStep = 0;
    chara->SetMotion("\x92\xDE\x82\xE8\x8F\xE3\x82\xB0\x8A\xEC\x82\xD1", 6);
    FalseMotionCount = GetMotionCount(chara, "\x92\xDE\x82\xE8\x8F\xE3\x82\xB0\x8A\xEC\x82\xD1", 20, 300, 0);
    save_data = GetSaveData();

    if (GetFishingMode() == kFishingModeFloat) {
        DeleteEsa();
    }

    GetItemRet = 0;
    message = scene->GetMessage(1);
    fish_param = GetFishParam(FishData.fish_no);
    message->values[0] = 0;
    message->value_width[0] = 0;
    fish_item_no = -1;
    message->values[1] = 0;
    message->value_width[1] = 0;

    if (fish_param != NULL) {
        fish_size = FishData.size / 100.0f;
        fish_item_no = fish_param->item_no;
        fish_weight = FishData.weight;
        GetItemRet = save_data->user_data.GetFishInAquarium(fish_item_no, fish_size, fish_weight);
        save_data->user_data.AddFp(FishData.fishing_point);
        save_data->user_data.CheckFishRecordUpdate(fish_item_no, fish_size, fish_weight);
    }

    DrawCongra = 100;
    SetShowHari(0);

    if (fish_item_no >= 0) {
        message->Preset(4);
        message->SetWindowMode(4);
        message->item_mes[0] = GetItemMessageNo(fish_param->item_no, 1);
        message->values[0] = fptosi(FishData.size);
        message->value_width[0] = 0;
        message->values[1] = FishData.fishing_point;
        message->value_width[1] = 0;

        if (LanguageCode > 0 && LanguageCode < 6) {
            message->value_half = 1;
        }

        FishFontH = message->font_h;
        message->font_h += 4;
        message->MakeMesWin(13);
        message->fukidashi_pos = 8;
        message->abs_win.height = message->font_h * 4 - message->font_h / 2 + 4;
    }

    sndSePlay(FanSnd, 0, 0);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", InitSuccess__FP6CScene);
#endif

/**
 *
 * Updates the caught fish display and its exit sequence.
 *
 */
void SuccessLoop(CScene *scene, CPadControl *pad) {
    ClsMes          *message;
    CCharacter2     *chara;
    CCameraControl  *camera;
    CameraCtrlParam *param;
    float            chara_rot[4];
    float            chara_pos[4];
    float            ref_pos[4];
    float            cam_pos[4];

    if (pad == NULL) {
        return;
    }

    chara = scene->GetCharacter(scene->player_chara);

    if (chara == NULL) {
        return;
    }

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (camera == NULL) {
        return;
    }

    switch (camera->Iam()) {
        case kFishCameraState:
            break;
        default:
            return;
    }

    message = scene->GetMessage(1);
    chara->GetPosition(chara_pos);
    chara->GetPosition(ref_pos);
    chara->GetRotation(chara_rot);
    param = camera->GetActiveParam();
    param->max_dist = 80.0f;
    param->min_dist = 80.0f;
    param->near_height = -5.0f;
    param->far_height = -5.0f;
    param->min_height = -5.0f;
    ref_pos[1] += 15.0f;
    camera->GetPos(cam_pos);
    cam_pos[1] = 5.0f + ref_pos[1];
    camera->SetRef(ref_pos);
    camera->SetPos(cam_pos);
    camera->SetRotate(mgAngleLimit(chara_rot[1] - 0.2f));
    camera->Step(-1);
    FalseMotionCount -= 1;

    if (FalseStep == 0 && (FalseMotionCount <= 0 || chara->CheckMotionEnd() != 0)) {
        chara->SetMotion("\x92\xDE\x82\xE8\x8F\xE3\x82\xB0\x8A\xEC\x82\xD1\x4C", 4);
        FalseStep2 = 0;
        FalseStep = 1;
        FalseMotionCount = 60;
    }

    if (FalseMotionCount <= 0) {
        FalseMotionCount = 0;
    }

    static int font_h = 0;

    if (FalseStep == 1) {
        if (FalseMotionCount <= 0 && pad->Btn(kFishBtnAction) != 0) {
            if (message->select < 0) {
                message->cursor_time = 0;
            }

            message->select = -1;
            message->draw_speed = message->GetDrawSpeedDef();
            message->mes_no = -1;
            message->text_ptr = 0;
            message->open = 0;
            message->fade = 0.0f;
            message->fukidashi_centre_x = -1;
            message->fukidashi_centre_y = -1;
            message->fukidashi_pos = 0;

            if (FishFontH > 0) {
                message->font_h = FishFontH;
            }

            message->abs_win.height = -1;
            sndSePlay(GetSystemSndID(), 0x19, 0);
            FalseStep = 3;

            if (GetSaveData()->GetBitFlag(0x3C) == 0) {
                FalseStep2 = 0;
                FalseStep = 2;
                FishMesNo = 0x7D1;
            }

            if (GetNowSubGameInfo()->record_check != 0 &&
                CheckFishingRecord(FishData.size / 100.0f) != 0) {
                FalseStep2 = 0;
                FalseStep = 2;
                FishMesNo = 0x7D2;
            }

            return;
        }
    }

    if (FalseStep == 2) {
        ClsMes *result_message = scene->GetMessage(1);
        int     state = result_message->State();
        int     confirm = pad->Btn(kFishBtnAction);

        switch (FalseStep2) {
            case 0:
                GetSaveData()->SetBitFlag(0x3C, 1);
                result_message->Preset(4);
                result_message->SetWindowMode(4);
                result_message->MakeMesWin(FishMesNo);
                result_message->fukidashi_pos = 8;
                FalseStep2 += 1;
                break;
            case 1:
                switch (state) {
                    case 5:
                        if (confirm != 0) {
                            result_message->GoNextPage();
                            sndSePlay(GetSystemSndID(), 0x19, 0);

                            if (FishMesNo == 0x7D2) {
                                sndSePlay(GetSystemSndID(), 0x12, 0);
                            }
                        }

                        break;
                    case 3:
                        if (confirm != 0) {
                            FalseStep2 += 1;
                            sndSePlay(GetSystemSndID(), 0x19, 0);
                        }

                        break;
                    case 0:
                        FalseStep2 += 1;
                        break;
                }

                break;
            case 2:
                if (result_message->select < 0) {
                    result_message->cursor_time = 0;
                }

                result_message->select = -1;
                result_message->draw_speed = result_message->GetDrawSpeedDef();
                result_message->mes_no = -1;
                result_message->text_ptr = 0;
                result_message->open = 0;
                result_message->fade = 0.0f;
                result_message->fukidashi_centre_x = -1;
                result_message->fukidashi_centre_y = -1;
                result_message->fukidashi_pos = 0;
                FalseStep = 3;
                break;
        }
    }

    if (FalseStep >= 3) {
        ExtendLine(-1000.0f);
        ResetLineVelo();
        EndSelectCastingPoint(scene);
        SetNextMode((int) FISHING_CHARA_MODE_CONTROL);
        FishChara = NULL;
        mgTexManager.DeleteBlock(FishTexb);
        camera->RotBack(mgAngleLimit(3.1415927f + chara_rot[1]));
        SetShowHari(1);
        scene->PlayBGM(0, -1, 1.0f);

        if (GetItemRet != 0) {
            sgGetItemOverFlagOn();
        }
    }
}

/**
 *
 * Checks for fishable water below a position and places it on that surface.
 *
 */
int CheckFishing(float *pos, CCPoly *polys, int count) {
    float end[4];
    int   hit_index[32];
    float hit_point[32][4];
    int   hits;
    int   i;
    *(u_long128 *) end = *(u_long128 *) pos;
    end[1] -= 140.0f;
    hits = CheckHits(polys, count, pos, end, 32, hit_index, hit_point, 1, 0);
    i = 0;

    if (hits <= 0) {
        return 0;
    }

    for (; i < 1; i++) {
        int   index = hit_index[i];
        float height = hit_point[i][1];
        pos[1] = height;

        if (polys[index].area_kind == 7) {
            return 1;
        }
    }

    return 0;
}

int CheckCasting(CScene *scene, float *position, float *direction) {
    mgVu0FBOX box;
    CCPoly    poly_buffer[0x400];
    float     end[4];
    float     move_dir[4];
    float     step_point[4];
    float     from[4];
    float     to[4];
    float     point_a[4];
    float     point_b[4];
    float     point_dir[4];
    float     probe[4];
    float     hit_point[32][4];
    int       hit_index[32];

    mgVectorMaxMin(box.max, box.min, position, direction);
    box.max[0] += 40.0f;
    box.max[1] += 2000.0f;
    box.max[3] = 1.0f;
    box.max[2] += 40.0f;
    box.min[0] -= 40.0f;
    box.min[3] = 1.0f;
    box.min[1] -= 2000.0f;
    box.min[2] -= 40.0f;
    CCPoly *polys = poly_buffer;
    int     poly_count = scene->GetColPoly(polys, box, 0x400);
    direction[1] = 40.0f + position[1];
    sceVu0SubVector(move_dir, direction, position);
    move_dir[1] = 0.0f;
    *(u_long128 *) end = *(u_long128 *) direction;
    *(u_long128 *) from = *(u_long128 *) position;
    *(u_long128 *) to = *(u_long128 *) direction;
    from[1] = direction[1];
    from[3] = 1.0f;
    *(u_long128 *) point_b = *(u_long128 *) direction;

    if (CheckFishing(direction, polys, poly_count) == 0) {
        return 0;
    }

    to[1] = 1.0f + (direction[1] + from[3]);
    mgNormalizeVector(step_point, move_dir, 80.0f);
    mgAddVector(step_point, position);
    step_point[1] = end[1];
    *(u_long128 *) point_a = *(u_long128 *) step_point;

    if (CheckFishing(step_point, polys, poly_count) == 0) {
        return 0;
    }

    sceVu0SubVector(point_dir, point_b, point_a);
    point_dir[1] = 0.0f;
    mgNormalizeVector(point_dir, point_dir, 10.0f);
    int steps = fptosi(mgDistVectorXZ(point_a, point_b) / 10.0f);
    mgAddVector(point_a, point_dir);

    for (int i = 1; i < steps; i++) {
        *(u_long128 *) probe = *(u_long128 *) point_a;

        if (CheckFishing(probe, polys, poly_count) == 0) {
            return 0;
        }

        mgAddVector(point_a, point_dir);
    }

    return CheckHits(polys, poly_count, from, to, 32, hit_index, hit_point, 0, 9) <= 0;
}

/**
 *
 * Selects a random size value with a lower bound.
 *
 */
float GetRandamNumber(float center, float high, float floor) {
    float value = mgNRnd();
    value = center + value * ((high - center) / 3.0f);

    if (value < floor) {
        value = floor + (center - floor) * mgRnd();
    }

    return value;
}

int GetUkiWaitTime(FISH_DATA *fish, CScene *scene, float *position, int rod_no, int bait_no) {
    FISH_PLACE place[16];
    int        i;
    int        picked;

    if (bait_no < 0) {
        fish->fish_no = -1;
        return 100;
    }

    int   time_band = GetTimeBand(scene->time);
    int   place_num = GetAppearFish(scene->GetMainMapNo(), position, place, 16);
    int   candidate_num = 0;
    float rate_sum = 0.0f;

    for (i = 0; i < place_num; i++) {
        FISH_PARAM *param = GetFishParam(place[i].fish_no);
        FISH_PLACE *entry = &place[i];

        if (param == NULL) {
            continue;
        }

        int bait_affinity;

        if (bait_no < 0 || bait_no >= 18) {
            bait_affinity = 0;
        } else {
            bait_affinity = param->bait_affinity[bait_no];
        }

        if (entry->fish_no > 0) {
            switch (bait_affinity) {
                case FISH_AFFINITY_NONE:
                    entry->rate = 0.0f;
                    break;
                case FISH_AFFINITY_LOW:
                    entry->rate *= 0.5f;
                    break;
                case FISH_AFFINITY_NORMAL:
                    break;
                case FISH_AFFINITY_HIGH:
                    entry->rate *= 1.5f;
                    break;
            }

            int time_affinity;

            if (time_band < 0 || time_band >= 4) {
                time_affinity = 0;
            } else {
                time_affinity = param->time_band_affinity[time_band];
            }

            switch (time_affinity) {
                case FISH_AFFINITY_NONE:
                    entry->rate = 0.0f;
                    break;
                case FISH_AFFINITY_LOW:
                    entry->rate *= 0.5f;
                    break;
                case FISH_AFFINITY_NORMAL:
                    break;
                case FISH_AFFINITY_HIGH:
                    entry->rate *= 1.5f;
                    break;
            }
        }

        if (entry->fish_no == 0) {
            entry->rate *= 1.0f - 0.5f * RodData.status4_rate;
        }

        rate_sum += entry->rate;

        if (!(entry->rate <= 0.0f)) {
            candidate_num++;
        }
    }

    float roll = mgRnd();
    float cumulative;
    cumulative = 0.0f;

    for (i = 0; i < place_num; i++) {
        FISH_PLACE *entry = &place[i];
        entry->rate /= rate_sum;

        if (entry->rate <= 0.0f) {
            continue;
        }

        cumulative += entry->rate;

        if (!(cumulative <= roll)) {
            break;
        }
    }

    picked = i;
    int   fish_no = place[picked].fish_no;
    float pull_strength = 0.5f;
    float size = 100.0f;
    float length_scale = 1.0f;
    int   wait_base = 240;
    FavoredEsa = 0;
    int   fishing_point = 0;
    float vigour_recovery = 0.01f;
    int   wait_extra = 240;
    float width_scale = 1.0f;
    float weight;
    int   wait_time;

    if (MardanEventMap != 0 && bait_no == 4 && position[0] < 1000.0f && position[2] < -300.0f) {
        MardanEventPlace = 1;
    }

    if (MardanEventPlace != 0) {
        fish->vigour_recovery = 0.005f;
        pull_strength = 0.5f;
        fish_no = 7;
        wait_time = 100;
        size = 500.0f;
        FavoredEsa = 2;
    } else {
        if (candidate_num <= 0) {
            return 100;
        }

        if (fish_no == 0) {
            fish->fish_no = -1;
            return 100;
        }

        float wait_bias = 0.0f;

        if (fish_no > 0) {
            FISH_PARAM *param = GetFishParam(fish_no);
            int         favored;

            if (bait_no < 0 || bait_no >= 18) {
                favored = 0;
            } else {
                favored = param->bait_affinity[bait_no];
            }

            FavoredEsa = favored;
            wait_bias = place[picked].wait_bias;

            if (!(wait_bias <= 2.0f)) {
                wait_bias = 2.0f;
            }

            if (wait_bias < -2.0f) {
                wait_bias = -2.0f;
            }

            float min_size = param->min_size * CastDistSizeRate;
            float max_size = param->max_size * CastDistSizeRate;
            size = GetRandamNumber(min_size, max_size, min_size / 2.0f);

            if (GetCaptureMode() != 0) {
                size = float(60.0);
            }

            length_scale = size / param->base_size;
            length_scale *= float(1.05);

            if (!(length_scale <= float(4.0))) {
                length_scale = float(4.0);
            }

            float width_rate = GetRandamNumber(1.0f, 1.3f, float(0.6));

            if (!(width_rate <= 1.3f)) {
                width_rate = 1.3f;
            }

            width_scale = length_scale * width_rate;
            weight = width_rate * (size * param->weight_rate);
            vigour_recovery = 0.01f;
            pull_strength = param->pull_rate * (size / 80.0f * width_rate);
            fishing_point = (int) (width_rate * (param->fishing_point_rate * size));

            if (GetFishingMode() == 2) {
                fishing_point *= 2;
            }
        }

        if (rod_no == (int) ITEM_ID_LURE_ROD) {
            wait_base /= 2;
            wait_extra /= 2;
        }

        if (!(wait_bias < 0.0f)) {
            wait_time = (int) (wait_base / (1.0f + wait_bias));
            wait_extra = (int) (wait_extra / (1.0f + wait_bias));
        } else {
            wait_time = (int) (wait_base * (1.0f - wait_bias));
            wait_extra = (int) (wait_extra / (1.0f - wait_bias));
        }

        wait_time += (int) (wait_extra * mgRnd());
    }

    int rod_power = RodData.status[2] - 10;

    if (rod_power < 0) {
        rod_power = 0;
    }

    fish->fish_no = fish_no;
    pull_strength /= 1.0f + 2.0f * (rod_power / 90.0f);
    fish->size = size;
    fish->weight = weight;
    fish->length_scale = length_scale;
    fish->width_scale = width_scale;
    fish->pull_strength = pull_strength;
    fish->vigour_recovery = vigour_recovery;
    fish->vigour = 0.0f;
    fish->fishing_point = fishing_point;
    return wait_time;
}

/**
 *
 * Returns a float poke delay based on bait affinity.
 *
 */
int GetUkiPokeTime(FISH_DATA *fish) {
    switch (FavoredEsa) {
        case 0:
            fish->fish_no = -1;
            return 5;
        case 1:
            return (int) (60.0f * mgRnd()) + 100;
        case 2:
            return (int) (50.0f * mgRnd()) + 50;
        case 3:
            return (int) (30.0f * mgRnd()) + 30;
    }

    return 0;
}

/**
 *
 * Returns the duration of a float pull.
 *
 */
int GetUkiPullTime(FISH_DATA *fish) {
    return 30;
}

/**
 *
 * Starts background loading of the selected fish model.
 *
 */
int FishLoadBG(FISH_DATA *fish, u_long128 *buffer) {
    char path[0x40];

    if (fish->fish_no < 0) {
        return 0;
    }

    StartReadBG();
    FISH_PARAM *param = GetFishParam(fish->fish_no);

    if (param == NULL) {
        return 0;
    }

    sprintf(path, "sg/fish/%sa.chr", param->file_name);
    return LoadFileBG(path, buffer, 0) != 0;
}

void LineTensionStep(FISH_DATA *fish, int reel) {
    float tension_rate;
    int   left_vibration;
    int   right_vibration;
    float pull;

    pull = fish->pull_strength * (1.0f + 0.5f * fish->vigour);
    int action_count = ActionCount;
    tension_rate = -0.004f;

    if (action_count > 5) {
        tension_rate = -0.004f + 0.01f * (float) (action_count - 5) / 15.0f;
    }

    if (action_count > 20) {
        tension_rate = 0.2f;
    }

    left_vibration = 0;

    if (!(tension_rate <= 0.0f)) {
        tension_rate *= pull;
    }

    right_vibration = 0x96;

    if (reel > 0) {
        LineTension *= 0.9f;
    }

    if (reel < 0) {
        pull *= 2.0f;
        fish->vigour -= 0.05f * (3.0f * ((float) RodData.status[1] / 100.0f));
    }

    switch (RodStatus) {
        case 0:
            fish->vigour += fish->vigour_recovery;

            if (tension_rate < 0.0f) {
                right_vibration = 0;
                left_vibration = 0;
            }

            break;
        case 1:
            tension_rate += 0.03f * pull;
            fish->vigour -= 0.02f;
            right_vibration = 0xDC;
            break;
        case 2:
            right_vibration = 0x64;
            tension_rate -= 0.008f;
            break;
    }

    if (WindReel != 0) {
        tension_rate += 0.03f * pull;
    }

    if (!(fish->vigour <= 1.0f)) {
        fish->vigour = 1.0f;
    }

    if (fish->vigour < -1.0f) {
        fish->vigour = -1.0f;
    }

    MinLineTension += 0.0001f;

    if (!(MinLineTension <= 1.0f)) {
        MinLineTension = 1.0f;
    }

    LineTension += tension_rate;
    addLineTension = tension_rate;

    if (LineTension < MinLineTension) {
        LineTension = MinLineTension;
    }

    if (!(LineTension <= 1.0f)) {
        LineTension = 1.0f;
    }

    if (!(tension_rate <= 0.001f)) {
        left_vibration = 1;
    }

    GamePad__2.SetVibration(1, right_vibration, 4);
    GamePad__2.SetVibration(0, left_vibration, 4);
    static int snd_cnt = 0;

    if (!(LineTension <= 0.7f) && snd_cnt == 0) {
        sndSePlay(FishSnd, 0x10, 0);
        snd_cnt = 0x14;
    }

    snd_cnt--;

    if (snd_cnt < 0) {
        snd_cnt = 0;
    }
}

int GetAppearFish(int map_no, float *pos, FISH_PLACE *places, int max_places) {
    FISH_PLACE_MAP *map;
    int             i;
    int             count;
    map = FishPlaceMap;

    for (i = 0; i < max_places; i++) {
        places[i].fish_no = -1;
        places[i].wait_bias = 0;
        places[i].rate = 0;
    }

    for (i = 0; i < FishPlaceMapNum; i++, map++) {
        if (map_no == map->map_no && map->CheckFishPlace(pos) != 0) {
            map->SetFishPlace(places, max_places, map->exclusive);

            if (map->exclusive != 0) {
                break;
            }
        }
    }

    for (count = 0; count < max_places; count++) {
        if (places[count].fish_no < 0) {
            break;
        }
    }

    if (map_no >= 0 && count <= 0) {
        return GetAppearFish(-1, pos, places, max_places);
    }

    return count;
}

int FISH_PLACE_MAP::SetFishPlace(FISH_PLACE *place, int place_num, int replace) {
    int filled = 0;

    if (replace != 0) {
        for (int i = 0; i < place_num; i++) {
            place[i].fish_no = -1;
            place[i].wait_bias = 0.0f;
            place[i].rate = 0.0f;
        }
    }

    if (fish_num >= place_num) {
        fish_num = place_num;
    }

    for (int i = 0; i < fish_num; i++) {
        FISH_PLACE *source = &fish[i];

        if (replace == 0) {
            int j;

            for (j = 0; j < place_num; j++) {
                if (place[j].fish_no < 0 || source->fish_no == place[j].fish_no) {
                    FISH_PLACE *target = &place[j];

                    if (target->fish_no < 0) {
                        filled++;
                    }

                    target->fish_no = source->fish_no;
                    target->rate = place[i].rate > source->rate ? place[i].rate : source->rate;
                    target->wait_bias = place[i].wait_bias > source->wait_bias ? place[i].wait_bias : source->wait_bias;
                    break;
                }
            }
        } else {
            filled++;
            place[i].fish_no = source->fish_no;
            place[i].rate = source->rate;
            place[i].wait_bias = source->wait_bias;
        }
    }

    return filled;
}

int FISH_PLACE_MAP::CheckFishPlace(float *pos) {
    float center[4];
    mgZeroVector(center);

    switch (area_type) {
        case kFishShapeCircle:
            center[0] = area_param[0];
            center[2] = area_param[1];
            float dist = mgDistVectorXZ(center, pos);

            if (dist > area_param[2]) {
                return 0;
            }

            return 1;
    }

    return 1;
}

/**
 *
 * Allocates the scripted fishing place map table.
 *
 */
static int fpFISH_MAP_NUM(SPI_STACK *args, int arg_count) {
    FishPlaceMapNum = spiGetStackInt(args);
    u_int blocks;

    if (((u_int) FishPlaceMapNum * sizeof(FISH_PLACE_MAP)) & 0xF) {
        blocks = (((u_int) FishPlaceMapNum * sizeof(FISH_PLACE_MAP)) >> 4) + 1;
    } else {
        blocks = ((u_int) FishPlaceMapNum * sizeof(FISH_PLACE_MAP)) >> 4;
    }

    u_long128 *block = fpStack->Alloc(blocks + 2);
    FishPlaceMap = new (block) FISH_PLACE_MAP[FishPlaceMapNum];
    fpNowFishPlaceMapNum = 0;
    fpNowFishPlaceMap = FishPlaceMap;
    return 1;
}

/**
 *
 * Starts a scripted fishing place map definition.
 *
 */
static int fpFISH_MAP(SPI_STACK *args, int arg_count) {
    fpNowFishPlaceMap = NULL;

    if ((int) fpNowFishPlaceMapNum >= FishPlaceMapNum) {
        return 0;
    }

    fpNowFishPlaceMap = &FishPlaceMap[fpNowFishPlaceMapNum];
    memset(fpNowFishPlaceMap, 0, sizeof(FISH_PLACE_MAP));
    fpNowFishPlaceMap->map_no = spiGetStackInt(args++);

    if (arg_count >= 2) {
        fpNowFishPlaceMap->exclusive = spiGetStackInt(args);
    }

    return 1;
}

/**
 *
 * Sets the area and location of the current fishing place map.
 *
 */
static int fpFISH_PLACE(SPI_STACK *args, int arg_count) {
    int   area_type;
    char *name;
    int   i;

    if (fpNowFishPlaceMap == 0) {
        return 0;
    }

    area_type = spiGetStackInt(args++);

    if (area_type < 0 || area_type >= kFishShapeCount) {
        area_type = 0;
    }

    fpNowFishPlaceMap->area_type = area_type;
    name = spiGetStackString(args++);

    if (name != 0 && *name != 0) {
        fpNowFishPlaceMap->name = mgCopyString(name, fpStack);
    }

    for (i = 0; i < kFishPlaceValueCount; i++) {
        fpNowFishPlaceMap->area_param[i] = spiGetStackFloat(args++);
    }

    return 1;
}

/**
 *
 * Adds a fish appearance entry to the current fishing place map.
 *
 */
static int fpFISH(SPI_STACK *args, int arg_count) {
    FISH_PLACE *entry;
    int         index;
    int        *count_ptr;

    if (fpNowFishPlaceMap == 0) {
        return 0;
    }

    count_ptr = &fpNowFishPlaceMap->fish_num;
    index = *count_ptr;

    if (index >= kFishPlaceMaxFish) {
        return 0;
    }

    *count_ptr = index + 1;
    entry = &fpNowFishPlaceMap->fish[index];
    entry->fish_no = -1;
    entry->wait_bias = 0;
    entry->rate = 0;
    entry->fish_no = spiGetStackInt(args++);
    entry->rate = spiGetStackFloat(args++);
    entry->wait_bias = spiGetStackFloat(args);
    return 1;
}

/**
 *
 * Finishes the current fishing place map definition.
 *
 */
static int fpFISH_MAP_END(SPI_STACK *args, int arg_count) {
    if (fpNowFishPlaceMap == 0) {
        return 0;
    }

    fpNowFishPlaceMapNum += 1;
    return 1;
}

void LoadFishPlaceData(char *script, int size, mgCMemory *stack) {
    fpStack = stack;
    FishPlaceMapNum = 0;
    FishPlaceMap = NULL;
    CScriptInterpreter interpreter;
    interpreter.SetTag(tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
}
