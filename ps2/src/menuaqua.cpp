struct fish_prize_record;
extern char aquarium_fish_maxtbl[];
#include "menuaqua.hpp"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "dataread.hpp"
#include "fishing.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
extern float MenuItemBrdUnderBrdPosXY[];
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_camera.hpp"
#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nameregi.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "title.hpp"
#include "userdata.hpp"
#include "water.hpp"

/**
 *
 * Tracks the current saved fish-race menu screen and prompt.
 *
 */
enum GyoraceMenuMode {
    GYORACE_MENU_LOAD = 0,                /**< Loads fish-race menu resources. */
    GYORACE_MENU_MAIN = 1,                /**< Chooses a saved fish-race command. */
    GYORACE_MENU_REGISTER_FULL = 2,       /**< Shows that no further fish can be registered. */
    GYORACE_MENU_START_FADE = 6,          /**< Waits for the fade into the fish race. */
    GYORACE_MENU_RENAME = 7,              /**< Runs name entry for a registered fish. */
    GYORACE_MENU_RENAME_FADE = 8,         /**< Waits for the fade before fish name entry. */
    GYORACE_MENU_ASSIGN_FISH = 0xA,       /**< Selects a saved fish for an entrant slot. */
    GYORACE_MENU_SELECT_TACTICS = 0xB,    /**< Chooses the assigned entrant's tactics. */
    GYORACE_MENU_TACTICS_RESULT = 0xC,    /**< Acknowledges the entrant's selected tactics. */
    GYORACE_MENU_DELETE_FISH = 0x14,      /**< Selects a saved fish to delete. */
    GYORACE_MENU_DELETE_CONFIRM = 0x15,   /**< Confirms deletion of the selected saved fish. */
    GYORACE_MENU_ALREADY_ASSIGNED = 0x16, /**< Shows why an assigned fish cannot be deleted. */
    GYORACE_MENU_WITHDRAW_CONFIRM = 0x1E, /**< Confirms withdrawal of all assigned entrants. */
    GYORACE_MENU_ACKNOWLEDGE = 0x1F,      /**< Acknowledges a notice before returning to commands. */
    GYORACE_MENU_VIEW_TACTICS = 0x28,     /**< Displays the assigned entrants and their tactics. */
    GYORACE_MENU_START_CONFIRM = 0x32,    /**< Confirms starting the race with the assigned entrants. */
    GYORACE_MENU_SAVE_FADE = 0x3C,        /**< Waits for the fade before opening the fish-load save menu. */
    GYORACE_MENU_SAVE = 0x3D,             /**< Runs the save menu to load fish data. */
    GYORACE_MENU_RETURN_FROM_SAVE = 0x3E, /**< Returns from the save menu and prepares the loaded fish list. */
    GYORACE_MENU_LOAD_FISH = 0x3F,        /**< Selects a fish from loaded save data for registration. */
    GYORACE_MENU_RESET_CONFIRM = 0x40,    /**< Confirms leaving fish loading and restoring the menu data. */
    GYORACE_MENU_ASSIGN_CONFIRM = 0x41,   /**< Confirms registering the fish selected from the loaded save. */
    GYORACE_MENU_ASSIGN_RESULT = 0x42,    /**< Acknowledges registration of the fish from the loaded save. */
    GYORACE_MENU_LOAD_BOARD = 0x43,       /**< Draws the board shared by the fish-load screens. */
};

/**
 *
 * Entry selected by the saved fish-race menu cursor.
 *
 */
enum GyoraceMenuCommand {
    GYORACE_COMMAND_REGISTER = 0, /**< Registers a new saved racer. */
    GYORACE_COMMAND_SAVE = 1,     /**< Opens the save and fish-load menu. */
    GYORACE_COMMAND_ASSIGN = 2,   /**< Assigns a saved fish to a race slot. */
    GYORACE_COMMAND_DELETE = 3,   /**< Deletes a saved fish. */
    GYORACE_COMMAND_WITHDRAW = 4, /**< Clears the assigned entrants. */
    GYORACE_COMMAND_TACTICS = 5,  /**< Displays the assigned racers and tactics. */
    GYORACE_COMMAND_START = 6,    /**< Starts a race with the assigned entrants. */
};

/**
 *
 * Describes the fish growth and parameter changes caused by food.
 *
 */
struct aqua_food_info {
    short       item_no;    /**< Item number of the food. */
    signed char growth;     /**< Growth change from the food. */
    signed char add_param3; /**< Change to fish parameter three. */
    signed char add_param0; /**< Change to fish parameter zero. */
    signed char add_param1; /**< Change to fish parameter one. */
    signed char add_param2; /**< Change to fish parameter two. */
    u16         add_timer;  /**< Duration added by the food. */
};

STATIC_ASSERT(sizeof(aqua_food_info) == 10);

/**
 *
 * References the horizontal and height data of an aquarium grid cell.
 *
 */
struct aqua_grid_cell {
    float *xz; /**< Horizontal position data. */
    float *y;  /**< Height data. */
};

/**
 *
 * Views four floating-point values as a single 128-bit value.
 *
 */
union aqua_quad {
    float     v[4]; /**< Four floating-point components. */
    u_long128 quad; /**< Combined 128-bit representation. */
};

/**
 *
 * Stores four floating-point components for aquarium geometry.
 *
 */
struct aqua_vector {
    float v[4]; /**< Four vector components. */
};

/**
 *
 * Records the parents and offspring of a fish breeding combination.
 *
 */
struct fish_breed_pair {
    signed char first_parent;  /**< First parent fish type. */
    signed char second_parent; /**< Second parent fish type. */
    signed char child;         /**< Resulting fish type. */
};

STATIC_ASSERT(sizeof(fish_breed_pair) == 3);

/**
 *
 * Associates a fish item with its image and sex-dependent colours.
 *
 */
struct aqua_fish_info {
    short       item_no;      /**< Fish item number. */
    const char *img_path;     /**< Filename prefix of the fish image. */
    signed char color_male;   /**< Colour index for a male fish. */
    signed char color_female; /**< Colour index for a female fish. */
};

STATIC_ASSERT(sizeof(aqua_fish_info) == 12);

/**
 *
 * Tracks the cursor and first visible row of a race list.
 *
 */
struct gyorace_list_select {
    int cursor; /**< Selected list row. */
    int top;    /**< First visible list row. */
};

/**
 *
 * Groups the prize records for a fish contest.
 *
 */
struct fish_prize_group {
    int                prize_count; /**< Number of prizes in the group. */
    int                unk_4[8];
    u8                 unk_24[0x1C];
    fish_prize_record *prizes; /**< Prize records for the group. */
};

/**
 *
 * Stores prize information for three ranks.
 *
 */
struct fish_prize_record {
    int             unk_0;
    FISH_PRIZE_INFO rank[3]; /**< Prize information for each rank. */
};

/**
 *
 * Stores a spherical collision point in the aquarium.
 *
 */
struct aqua_col_point {
    sceVu0FVECTOR pos;    /**< Centre position of the collision point. */
    float        radius; /**< Collision radius. */
};

STATIC_ASSERT(sizeof(aqua_col_point) == 0x20);

extern "C" aqua_vector at_1346;

/**
 *
 * Stores the aquarium lighting state for restoration.
 *
 */
struct aqua_light_env {
    float         light_dir[4][4];   /**< Directions of the active lights. */
    float         light_color[4][4]; /**< Colours of the active lights. */
    mgPOINT_LIGHT plight;            /**< Point-light settings. */
    int           plight_enable;     /**< Whether the point light is enabled. */
};

/**
 *
 * Stores bubble counts for the three aquarium groups.
 *
 */
struct aqua_bubble_counts {
    int num[3]; /**< Bubble count for each group. */
};

extern "C" aqua_bubble_counts at_2935;
extern "C" aqua_quad          at_2975;
extern "C" aqua_quad          at_2976;
extern "C" aqua_quad          at_3016;
extern "C" char               at_3150[];
extern "C" char               at_3151[];
extern "C" char               at_3152[];
extern "C" char               at_3153[];
extern "C" char               at_3154[];
extern "C" char               at_3155[];
extern "C" char               at_3156[];
extern "C" char               at_3157[];
extern "C" char               at_3158__2[];
extern "C" char               at_3159__2[];
extern "C" char               at_3160__2[];
extern "C" char               at_3161__2[];
extern "C" char               at_3163__2[];
extern "C" char               at_3164__3[];
extern "C" aqua_vector        at_3290;
extern "C" aqua_vector        at_3291__3;
extern "C" aqua_vector        at_3310;
extern "C" aqua_vector        at_3311;

extern int                menu_debug_flag;

/**
 *
 * Stores the position and width of a fish parameter icon.
 *
 */
struct aqua_param_icon {
    s16 x; /**< Horizontal icon position. */
    s16 y; /**< Vertical icon position. */
    s16 w; /**< Icon width. */
};

enum {
    short_flag_tour_count = 0x15,
    short_flag_wins_class0 = 0x16,
    short_flag_wins_class1 = 0x17,
    short_flag_wins_class2 = 0x18,
    short_flag_wins_class3 = 0x19,
    bit_flag_tour_cycled = 0x3F,
    fish_flag_won_class0 = 0x04,
    fish_flag_won_class1 = 0x08,
    fish_flag_won_class2 = 0x10,
    fish_flag_won_class3 = 0x20,
    omake_racer_slot_count = 6,
    gyorace_type_omake_racer = 6,
};

static const int max_fish_fatigue = 10000000;

static aqua_grid_cell *Get_aquarium_paul_table(int index);

static aqua_grid_cell *Get_aquarium_paul_table_xz(int x, int z);

static int GetFishPath(int item_no, char *out);

static aqua_food_info *GetEsaInfo(int item_no);

extern CAquarium      Aquarium;

static int local_aquarium_limmit_check(float *pos, float radius, int check_y, float height);

extern mgCMemory Aquarium_NameregistStack;
extern mgCMemory GyoraceStack;

extern mgCMemory   GyoraceFishSelStack;

static int local_aquarium_limmit_check(float *pos, float radius, int check_y, float height);

static int CombineParam(int a, int b);

CGameDataUsed *GetGyoRaceFish();

static int _GYORACE_LISTNUM(SPI_STACK *stack, int arg_count);

static int _GYORACE_DATA(SPI_STACK *stack, int arg_count);

static int _PRIZE_LISTNUM(SPI_STACK *stack, int arg_count);

static int _PRIZE_GROUP(SPI_STACK *stack, int arg_count);

static int _PRIZE(SPI_STACK *stack, int arg_count);

static void GyoraceCFGAnalyze(char *command);

static int SearchOmakeGyoracer(int slot);

CGameDataUsed *GetOmakeGyoracer2(int slot);

static void ForceSetGyoList();

inline void copy_name(ClsMes *window, int line, char *name) {
    if (name != NULL) {
        strcpy(window->name[line], name);
    }
}

/**
 *
 * Rounds a byte count up to the number of 16-byte allocation blocks.
 *
 */
static inline unsigned int align16_blocks(unsigned int bytes) {
    if (bytes & 0xF) {
        return (bytes >> 4) + 1;
    }

    return bytes >> 4;
}

#include "common.h"

/**
 *
 * Scene used to draw and animate the aquarium.
 *
 */
static CScene         *AquaScene;

/**
 *
 * Mode of the active aquarium menu.
 *
 */
static int            AquaMode;

/**
 *
 * Texture blocks reserved for aquarium fish name registration.
 *
 */
static int            *Aquarium_NameregistBlock;

/**
 *
 * Sound-bank identifier used by aquarium effects.
 *
 */
static int            Aqua_SpSndID;

/**
 *
 * Counter used to space aquarium battle sounds.
 *
 */
static s16             Aqua_SpSndBattleCount;

/**
 *
 * Camera control mode of the aquarium, an AQUA_CAMERA_CTRL value.
 *
 */
static int             AquaCameraCtrlMode;

/**
 *
 * Camera that follows the aquarium view.
 *
 */
static mgCCameraFollow *Camera__2;

/**
 *
 * Lighting state saved before drawing the aquarium.
 *
 */
static aqua_light_env *aqua_old_env;

/**
 *
 * Texture used for the aquarium menu.
 *
 */
static mgCTexture *Tex_Aqualium;

/**
 *
 * Texture used by fish effects.
 *
 */
static mgCTexture *Tex_FishEffect;

/**
 *
 * Selected aquarium debug parameter.
 *
 */
static s16                menu_debug_select;

/**
 *
 * Horizontal position vectors of the aquarium grid.
 *
 */
static float (*aquarium_xz_table)[4];

/**
 *
 * Height vectors of the aquarium grid.
 *
 */
static float (*aquarium_y_table)[4];

/**
 *
 * Position and height references of the aquarium grid cells.
 *
 */
static aqua_grid_cell *aquarium_paul_table;

/**
 *
 * Bubble emitters used by aquarium battles.
 *
 */
static CBubble               *AquaBattleBubble;

/**
 *
 * Delay before emitting the next battle bubble.
 *
 */
static s16                    AquaBattleBubble_Generate_Wait;

/**
 *
 * Battle bubble emitter selected for the next emission.
 *
 */
static int                    AquaBattleBubble_Generate_Counter;

/**
 *
 * Saved aquarium parameters used by the active tank.
 *
 */
static CFishAquarium *m_aquarium_para;

/**
 *
 * Loaded boundary data of the aquarium.
 *
 */
static u_long128      *m_aquarium_limmit_adr;

/**
 *
 * Indicates that a fish died during the aquarium step.
 *
 */
int AquaDeadCheck;

/**
 *
 * Saved background-music volume of the aquarium menu.
 *
 */
static float           Auqa_Bgm_Volf;

/**
 *
 * Bubble emitter of each aquarium group.
 *
 */
static CBubble        *AquaBubble[3];

/**
 *
 * Bubble emitter attached to each aquarium fish.
 *
 */
static CBubble *AquaFishBubble[6];

/**
 *
 * Position of the aquarium battle bubble emitter.
 *
 */
static float          AquaBattleBubble_Pos[4];

/**
 *
 * Effect controller attached to each aquarium fish.
 *
 */
static CAquaFishEff *AquaFishEff[6];

/**
 *
 * Fish data used by the race menus.
 *
 */
CGameDataUsed *GyoraceFish;

/**
 *
 * Mode of the race fish selector.
 *
 */
static signed char GyoraceFishSelectMode;

/**
 *
 * Fish selected for the race.
 *
 */
static s16 GyoraceFishSelectNo;

/**
 *
 * Texture block used by the race fish selector.
 *
 */
static short       GyoraceFishSelTexBk;

/**
 *
 * Texture block of the fish-selection frame image.
 *
 */
static short       GyoraceFishFrameImgTexNo;

/**
 *
 * Number of fish marked in the race selector.
 *
 */
static signed char GyoraceFishSelNum;

/**
 *
 * Selection flags of the six race fish slots.
 *
 */
static s8 GyoraceFishSel[6];

/**
 *
 * Phase of loading the race fish selection data.
 *
 */
static signed char GyoRaceFishReadPhase;

/**
 *
 * Aquarium selected for the race.
 *
 */
static signed char GyoRaceAquariumNo;

/**
 *
 * Class of the selected race.
 *
 */
static signed char GyoRaceClass;

/**
 *
 * Progress through the race tournament.
 *
 */
static signed char GyoRaceProgressNum;

/**
 *
 * Ranking selected by the race menu.
 *
 */
static signed char GyoRaceRankingData;

/**
 *
 * Arena used while parsing race fish definitions.
 *
 */
static mgCMemory *spi_gyorace_stack;

/**
 *
 * Fish definitions populated by the race script.
 *
 */
static CGyoraceFishData *spi_gyorace_data;

/**
 *
 * Race fish record currently populated by the script.
 *
 */
static CGameDataUsed *spi_nowanalyze_gyorace_data;

/**
 *
 * Number of fish records expected by the race script.
 *
 */
static short spi_nowanalyze_gyorace_limmit;

/**
 *
 * Fish record index advanced by the race script.
 *
 */
static short spi_gyorace_counter;

/**
 *
 * Arena used while parsing fish tournament prizes.
 *
 */
static mgCMemory *fish_prize_buildstack;

/**
 *
 * Prize groups available to the fish tournament.
 *
 */
static fish_prize_group *FishTournamentGoods;

/**
 *
 * Number of fish tournament prize groups.
 *
 */
static short FishTournamentGoodsNum;

/**
 *
 * Type of the fish tournament prize list.
 *
 */
static signed char FishTournamentGoodsType;

/**
 *
 * Prize group currently populated by the script.
 *
 */
static fish_prize_group *spiFishTournamentGoods;

/**
 *
 * Prize record currently populated by the script.
 *
 */
static fish_prize_record *spi_fish_prize_info;

/**
 *
 * Prize records saved for the race menu.
 *
 */
static fish_prize_record *save_fish_prize_list;

/**
 *
 * Subgame save data used by the race menu.
 *
 */
static CSubGameData    *SubSaveData;

/**
 *
 * Saved race participant data.
 *
 */
CGyoRaceData *GyoraceData;

/**
 *
 * Fish record of the active race participant.
 *
 */
static CGameDataUsed   *GyoracerActive;

/**
 *
 * Main message window of the race menu.
 *
 */
static CDC2Mes         *GyoraceMes;

/**
 *
 * Enables drawing of the main race message.
 *
 */
static u8               GyoraceMesDrawFlag;

/**
 *
 * Enables drawing of the selected race fish parameters.
 *
 */
static u8               GyoraceFishInfoDrawFlag;

/**
 *
 * Message window used for race fish information.
 *
 */
static CDC2Mes       *GyoraceFishMes;

/**
 *
 * Message window listing available race fish.
 *
 */
static CDC2Mes         *GyoraceFishHave;

/**
 *
 * Enables drawing of the available race fish list.
 *
 */
static u8               GyoraceFishHaveDrawFlag;

/**
 *
 * Message window used for race tactics.
 *
 */
static CDC2Mes         *GyoraceFishTacMes;

/**
 *
 * Enables drawing of the race tactics window.
 *
 */
static u8               GyoraceFishTacMesDrawFlag;

/**
 *
 * Cursor and first visible row of the available race fish list.
 *
 */
static gyorace_list_select GyoraceFishHaveListSelect;

/**
 *
 * Cursor texture of the race menu.
 *
 */
static mgCTexture      *GyoraceCursor;

/**
 *
 * Texture used to draw fish in the race menu.
 *
 */
static mgCTexture      *GyoraceFishTex;

/**
 *
 * Current race menu screen.
 *
 */
static s16              GyoraceNowMode;

/**
 *
 * Phase of the current race menu screen.
 *
 */
static s16              GyoraceNowPhase;

/**
 *
 * Enables drawing of the race confirmation question.
 *
 */
static u8               GyoraceQuestionMsgDrawFlag;

/**
 *
 * Enables drawing of the available-fish cursor.
 *
 */
static u8               GyoraceHaveFishCursorDrawFlag;

/**
 *
 * Animated position of the available-fish cursor.
 *
 */
static float            GyoraceHaveFishCursor;

/**
 *
 * Animation counter of the race menu pointer.
 *
 */
static int              Gyoracemenu_long_hand_count;

/**
 *
 * Position of the race menu cursor.
 *
 */
static float            Gyoracemenu_CursorXY[2];

/**
 *
 * Loaded race configuration script.
 *
 */
static char *GyoraceExeCfgBuffer;

/**
 *
 * Byte size of the loaded race configuration script.
 *
 */
static int GyoraceExeCfgBufferSize;

/**
 *
 * Number of rows in the available race fish list.
 *
 */
static s16              GyoraceHaveFishListMakeLine;

/**
 *
 * Animated vertical origin of the available race fish list.
 *
 */
static float            GyoraceHaveFishListTopY;

/**
 *
 * Animated position of the available-fish scroll bar.
 *
 */
static float            GyoraceHaveFishListScrlBarY;

/**
 *
 * Requests initialization of the available-fish scrolling state.
 *
 */
static int            GyoraceHaveFishListScrlInit;

/**
 *
 * Tracks loading of the selected aquarium fish.
 *
 */
static u8               MenuLoadFishIsLoad;

/**
 *
 * Selected row of the aquarium fish load list.
 *
 */
static int              MenuLoadFishSelect;

/**
 *
 * First visible row of the aquarium fish load list.
 *
 */
static int              MenuLoadFishTopLine;

/**
 *
 * Fish record selected for loading into the aquarium.
 *
 */
static CGameDataUsed   *MenuLoadFishSelectData;

/**
 *
 * Texture used for the aquarium fish load board.
 *
 */
static mgCTexture      *MenuLoadBoardTex;

/**
 *
 * Horizontal position of the aquarium fish load board.
 *
 */
static int              MenuLoadFishBoardX;

/**
 *
 * Saved prize information for four tournament groups and three ranks.
 *
 */
static FISH_PRIZE_INFO fish_save_present[4][3];

/**
 *
 * Texture blocks allocated to the race menu.
 *
 */
static int              GyoraceTexBlock[16];

/**
 *
 * Options saved while the race menu changes sound settings.
 *
 */
static SV_CONFIG_OPTION GyoraceMenuOptionBuff;

/**
 *
 * Shared aquarium and race message windows.
 *
 */
CDC2Mes *MenuDCMsg[9];

/**
 *
 * Identifies a fish species by its aquarium image model and breeding-table code.
 *
 */
enum AquaFishBreedKind {
    AQUA_FISH_KIND_F01 = 10, /**< Fish species using the f01a image. */
    AQUA_FISH_KIND_F02 = 11, /**< Fish species using the f02a image. */
    AQUA_FISH_KIND_F03 = 12, /**< Fish species using the f03a image. */
    AQUA_FISH_KIND_F04 = 13, /**< Fish species using the f04a image. */
    AQUA_FISH_KIND_F05 = 14, /**< Fish species using the f05a image. */
    AQUA_FISH_KIND_F06 = 15, /**< Fish species using the f06a image. */
    AQUA_FISH_KIND_F07 = 16, /**< Fish species using the f07a image. */
    AQUA_FISH_KIND_F08 = 17, /**< Fish species using the f08a image. */
    AQUA_FISH_KIND_F10 = 18, /**< Fish species using the f10a image. */
    AQUA_FISH_KIND_F11 = 19, /**< Fish species using the f11a image. */
    AQUA_FISH_KIND_F12 = 20, /**< Fish species using the f12a image. */
    AQUA_FISH_KIND_F13 = 21, /**< Fish species using the f13a image. */
    AQUA_FISH_KIND_F14 = 22, /**< Fish species using the f14a image. */
    AQUA_FISH_KIND_F15 = 23, /**< Fish species using the f15a image. */
    AQUA_FISH_KIND_F16 = 24, /**< Fish species using the f16a image. */
    AQUA_FISH_KIND_F17 = 25, /**< Fish species using the f17a image. */
    AQUA_FISH_KIND_F18 = 26, /**< Fish species using the f18a image. */
    AQUA_FISH_KIND_F19 = 0, /**< Fish species using the f19a image. */
};

/**
 *
 * Records the offspring species for each pair of breeding fish.
 *
 */
static fish_breed_pair aquafish_mixTable[171] = {
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F19, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F10},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F01, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F02, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F03, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F04, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F05, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F06},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F18},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F06, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F10},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F07, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F06},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F08, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F10},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F10, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F19},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F11, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F03},
    {AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F11},
    {AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F12, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F07},
    {AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F13},
    {AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F08},
    {AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F13, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F01},
    {AQUA_FISH_KIND_F14, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F02},
    {AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F15},
    {AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F04},
    {AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F14},
    {AQUA_FISH_KIND_F15, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F16},
    {AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F16, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F12},
    {AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F17},
    {AQUA_FISH_KIND_F17, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F05},
    {AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F18, AQUA_FISH_KIND_F18}
};

/**
 *
 * Stores the three aquarium ambient-light colours.
 *
 */
static float ambient[12] = {64.0f, 64.0f, 64.0f, 128.0f, 102.0f, 64.0f, 64.0f, 128.0f, 98.0f, 64.0f, 98.0f, 128.0f};

/**
 *
 * Stores the directions of the aquarium lights.
 *
 */
static float light_dir[4][4] = {
    {0.0f, 0.0f, 0.0f, 0.0f},
    {1.0f, 0.0f, 0.0f, 0.0f},
    {0.0f, 0.0f, 0.0f, 0.0f},
    {0.0f, 0.0f, 0.0f, 0.0f}
};

/**
 *
 * Stores the four light colours for each aquarium.
 *
 */
static float light_color[3][4][4] = {
    {
        {128.0f, 128.0f, 128.0f, 128.0f},
        {0.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 0.0f}
    },
    {
        {146.0f, 100.0f, 100.0f, 128.0f},
        {0.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 0.0f}
    },
    {
        {146.0f, 66.0f, 144.0f, 128.0f},
        {0.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 0.0f}
    }
};

/**
 *
 * Stores the spherical collision points of an aquarium.
 *
 */
static aqua_col_point ColChkPoint[9] = {
    {{18.6299992f, 25.0f, 0.389999986f, 1.0f}, 5.80000019f},
    {{18.6299992f, 20.0f, 0.389999986f, 1.0f}, 6.0f},
    {{13.5f, 20.0f, -4.09000015f, 1.0f}, 6.0f},
    {{-1.34000003f, 23.0f, -7.78999996f, 1.0f}, 8.0f},
    {{-5.5f, 22.1499996f, -5.69999981f, 1.0f}, 6.0f},
    {{-10.5f, 22.0f, -4.01999998f, 1.0f}, 6.0f},
    {{-14.6599998f, 21.5f, -3.3599999f, 1.0f}, 6.0f},
    {{-18.6599998f, 21.5f, -2.3599999f, 1.0f}, 6.0f},
    {{-22.0f, 21.5f, -4.36000013f, 1.0f}, 5.5999999f}
};

/**
 *
 * Stores the spherical collision points of an aquarium.
 *
 */
static aqua_col_point ColChkPoint2[9] = {
    {{-23.6299992f, 40.0f, -12.8000002f, 1.0f}, 6.4000001f},
    {{-23.6299992f, 33.0f, -12.8000002f, 1.0f}, 6.4000001f},
    {{-23.6299992f, 26.0f, -12.8000002f, 1.0f}, 6.4000001f},
    {{11.5f, 22.0f, -13.3000002f, 1.0f}, 4.0f},
    {{20.5f, 30.0f, -8.19999981f, 1.0f}, 6.0f},
    {{26.5f, 29.0f, -3.20000005f, 1.0f}, 6.0f},
    {{23.5f, 23.0f, -5.5f, 1.0f}, 6.0f}
};

/**
 *
 * Stores the spherical collision points of an aquarium.
 *
 */
static aqua_col_point ColChkPoint3[6] = {
    {{-1.94000006f, 23.0f, -7.09000015f, 1.0f}, 8.0f},
    {{-10.5f, 25.0f, -7.78999996f, 1.0f}, 6.0f},
    {{13.5f, 21.0f, -4.09000015f, 1.0f}, 6.0f},
    {{18.6299992f, 21.0f, 0.389999986f, 1.0f}, 6.0f},
    {{24.3299999f, 21.0f, 3.3900001f, 1.0f}, 6.0f},
    {{21.6299992f, 23.0f, -4.38999987f, 1.0f}, 6.0f}
};

/**
 *
 * Stores the fish-growth and parameter changes caused by aquarium food.
 *
 */
static aqua_food_info esa_info[10] = {
    {312, 1, 0, 0, 0, 1, 7200},
    {313, 0, 0, 0, 1, 0, 7200},
    {314, 1, 1, 0, 0, 0, 7200},
    {315, 2, 0, 1, 0, 0, 7200},
    {316, 1, 1, 0, 0, 0, 7200},
    {317, 1, 0, 1, 0, 0, 7200},
    {318, 1, 0, 0, 0, 1, 7200},
    {319, 1, 0, 0, 1, 0, 7200},
    {360, 2, 0, 0, 0, 0, 7200},
    {-1}
};

/**
 *
 * Stores the three bubble-emitter origins in each aquarium.
 *
 */
static float aqua_bubble_generate_pos[3][3][4] = {
    {
        {18.6299992f, 23.0f, 3.0f, 1.0f},
        {-26.2299995f, 20.5f, -14.0f, 1.0f},
        {0.0f, 20.5f, 12.0f, 1.0f}
    },
    {
        {19.6299992f, 19.0f, 8.0f, 1.0f},
        {-26.2299995f, 20.0f, 0.0f, 1.0f},
        {-8.0f, 19.0f, -12.0f, 1.0f}
    },
    {
        {18.6299992f, 23.0f, 3.0f, 1.0f},
        {-26.2299995f, 20.5f, -14.0f, 1.0f},
        {0.0f, 20.5f, 12.0f, 1.0f}
    }
};

/**
 *
 * Stores the rise speeds selected by a bubble wobble pattern.
 *
 */
static float up_tbl_996[5] = {0.0500000007f, 0.100000001f, 0.150000006f, 0.200000003f, 0.25f};

/**
 *
 * Stores the horizontal wobble amplitudes selected by a bubble pattern.
 *
 */
static float amptbl_997[5][2] = {
    {0.0199999996f, 0.0199999996f},
    {0.00999999978f, 0.0199999996f},
    {0.0399999991f, 0.00999999978f},
    {0.0199999996f, 0.00999999978f},
    {0.00999999978f, 0.0399999991f}
};

/**
 *
 * Stores turn directions for the two aquarium circling orientations.
 *
 */
static float dirtbl_1242[2][4] = {
    {1.57079637f, -3.1101768f, 0.0f, -1.57079637f},
    {0.0f, 1.57079637f, -1.57079637f, -3.1101768f}
};

/**
 *
 * Stores the duration of each aquarium fish effect.
 *
 */
static int max_tbl_1484[6] = {0, 250, 250, 25000, 250, 0};

/**
 *
 * Associates each fish item with its image model and sex-dependent colours.
 *
 */
static aqua_fish_info aquafish_info[19] = {
    {FISH_ITEM_BOUBOU, "f01a", 2, 1},
    {FISH_ITEM_GABURA, "f02a", 3, 2},
    {FISH_ITEM_NONKII, "f03a", 4, 3},
    {FISH_ITEM_KAJII, "f04a", 5, 4},
    {FISH_ITEM_BAKUBAKU, "f05a", 6, 9},
    {FISH_ITEM_MAADANGARAYAN, "f06a", 7, 18},
    {FISH_ITEM_GUMII, "f07a", 8, 5},
    {FISH_ITEM_NIIRAA, "f08a", 9, 16},
    {FISH_ITEM_UMADAKARA, "f10a", 10, 8},
    {FISH_ITEM_TAATON, "f11a", 11, 10},
    {FISH_ITEM_PIKKORII, "f12a", 12, 11},
    {FISH_ITEM_BON, "f13a", 13, 12},
    {FISH_ITEM_HAMAHAMA, "f14a", 14, 13},
    {FISH_ITEM_NEJII, "f15a", 15, 17},
    {FISH_ITEM_DEN, "f16a", 16, 15},
    {FISH_ITEM_HIIRA, "f17a", 17, 6},
    {FISH_ITEM_DANSHAKU_GARAYAN, "f18a", 18, 7},
    {FISH_ITEM_HAGUHAGU, "f19a", 1, 14},
    {-1}
};

/**
 *
 * Stores the three texture strips of the fish parameter board.
 *
 */
static short u_brdtbl_2493[12] = {226, 76, 10, 24, 236, 76, 10, 24, 246, 76, 10, 24};

/**
 *
 * Stores the translated texture rectangles of fish parameter labels and units.
 *
 */
static aqua_param_icon get_paraxtbl_2494[7][10] = {
    {{58, 166, 58}, {116, 166, 58}, {174, 166, 58}, {0, 184, 58}, {58, 184, 58}, {116, 184, 58}, {174, 184, 58}, {186, 202, 58}, {232, 184, 12}, {186, 220, 12}},
    {{58, 166, 58}, {116, 166, 58}, {174, 166, 58}, {0, 184, 60}, {58, 184, 56}, {116, 184, 62}, {178, 184, 70}, {0, 148, 58}, {204, 202, 12}, {204, 220, 12}},
    {{58, 166, 58}, {116, 166, 58}, {174, 166, 58}, {0, 184, 58}, {58, 184, 58}, {116, 184, 58}, {174, 184, 58}, {0, 148, 58}, {204, 202, 12}, {204, 220, 12}},
    {{58, 166, 58}, {116, 166, 58}, {174, 166, 58}, {0, 184, 58}, {58, 184, 58}, {116, 184, 58}, {174, 184, 58}, {0, 148, 58}, {204, 202, 12}, {204, 220, 12}},
    {{58, 166, 58}, {116, 166, 58}, {174, 166, 58}, {0, 184, 58}, {58, 184, 58}, {116, 184, 58}, {174, 184, 58}, {0, 148, 58}, {204, 202, 12}, {204, 220, 12}},
    {{58, 166, 58}, {116, 166, 58}, {174, 166, 58}, {0, 184, 58}, {58, 184, 58}, {116, 184, 58}, {174, 184, 58}, {0, 148, 58}, {204, 202, 12}, {204, 220, 12}},
    {{58, 166, 58}, {116, 166, 58}, {174, 166, 58}, {0, 184, 58}, {58, 184, 58}, {116, 184, 58}, {174, 184, 58}, {186, 202, 58}, {232, 184, 12}, {204, 220, 12}}
};

/**
 *
 * Stores translated fish name and sex-label positions and widths.
 *
 */
static s16 ptbl_2495[6][6] = {
    {242, 56, 252, 34, 34, 34},
    {232, 64, 239, 52, 52, 18},
    {235, 64, 242, 52, 52, 18},
    {235, 64, 242, 52, 52, 18},
    {235, 64, 242, 52, 52, 18},
    {235, 64, 242, 52, 52, 21}
};

/**
 *
 * Stores the translated texture positions of the four fish-kind labels.
 *
 */
static u8 chrtbl_2503[7][4][2] = {
    {
        {34, 202},
        {110, 202},
        {34, 220},
        {110, 220}
    },
    {
        {52, 202},
        {128, 202},
        {52, 220},
        {128, 220}
    },
    {
        {52, 202},
        {128, 202},
        {52, 220},
        {128, 220}
    },
    {
        {52, 202},
        {128, 202},
        {52, 220},
        {128, 220}
    },
    {
        {52, 202},
        {128, 202},
        {52, 220},
        {128, 220}
    },
    {
        {52, 202},
        {128, 202},
        {52, 220},
        {128, 220}
    },
    {
        {52, 202},
        {128, 202},
        {52, 220},
        {128, 220}
    }
};

/**
 *
 * Stores confirm and cancel button masks for Japanese and other languages.
 *
 */
static int langTbl_3630[2][2] = {
    {PAD_CIRCLE, PAD_CROSS},
    {PAD_CROSS, PAD_CIRCLE}
};

/**
 *
 * Stores the aquarium menu command for each tank and cursor slot.
 *
 */
static s8 menu_id_tbl_3721[18] = {0, 1, 2, 3, 4, 5, 0, 3, 4, 5, -1, -1, 0, 3, 4, 5, -1, -1};

/**
 *
 * Stores the reference position of an aquarium reflection wall.
 *
 */
static float v1orig_4373[4] = {0.0f, 16.5f, 21.0f, 1.0f};

/**
 *
 * Stores the reference position of an aquarium reflection wall.
 *
 */
static float v2orig_4374[4] = {0.0f, 16.5f, -21.0f, 1.0f};

/**
 *
 * Stores the reference position of an aquarium reflection wall.
 *
 */
static float v3orig_4375[4] = {34.0f, 16.5f, 0.0f, 1.0f};

/**
 *
 * Stores the reference position of an aquarium reflection wall.
 *
 */
static float v4orig_4376[4] = {-34.0f, 16.5f, 0.0f, 1.0f};

/**
 *
 * Stores the three texture strips of the aquarium title frame.
 *
 */
static short t_4408[12] = {170, 0, 36, 76, 206, 0, 14, 76, 220, 0, 36, 76};

/**
 *
 * Maps fish-race script tags to their handlers.
 *
 */
static SPI_TAG_PARAM gyorace_tag[3] = {
    {"NUM", _GYORACE_LISTNUM},
    {"DAT", _GYORACE_DATA},
    {NULL, NULL}
};

/**
 *
 * Maps fish-prize script tags to their handlers.
 *
 */
static SPI_TAG_PARAM gyoprize_tag[4] = {
    {"NUM", _PRIZE_LISTNUM},
    {"GRP", _PRIZE_GROUP},
    {"PRIZE", _PRIZE},
    {NULL, NULL}
};

/**
 *
 * Stores the six saved-racer data indices.
 *
 */
static short GyoracerIndexNo[6] = {-1, -1, -1, -1, -1, -1};

/**
 *
 * Stores the six saved-racer tactics numbers.
 *
 */
static short GyoracerTacticsNo[6] = {-1, -1, -1, -1, -1, -1};

/**
 *
 * Stores the translated labels of an empty saved-racer slot.
 *
 */
char *Mitouroku[7] = {
    "  ",
    "  None",
    "  Aucun",
    "  Leer",
    "  Nessuno",
    "  Ninguno",
    "  None"
};

/**
 *
 * Stores the six tactics message-item numbers of a saved racer.
 *
 */
static int vol_5253[6] = {5020, 5021, 5022, 5023, 5024, 5025};

/**
 *
 * Stores texture strips for a small subgame title.
 *
 */
static short pl_s_5630[12] = {172, 54, 24, 46, 196, 54, 10, 46, 206, 54, 24, 46};

/**
 *
 * Stores texture strips for a large subgame title.
 *
 */
static short pl_b_5631[12] = {172, 0, 24, 54, 196, 0, 10, 54, 206, 0, 24, 54};

/**
 *
 * Stores texture strips for a fixed subgame list frame.
 *
 */
static short tbl_5644[36] = {0, 0, 28, 28, 28, 0, 10, 28, 38, 0, 28, 28, 0, 28, 28, 10, 28, 28, 10, 10, 38, 28, 28, 10, 0, 38, 28, 28, 28, 38, 10, 28, 38, 38, 28, 28};

/**
 *
 * Stores texture strips for a scrolling subgame list frame.
 *
 */
static short tbl_5669[36] = {0, 0, 28, 28, 28, 0, 10, 28, 66, 0, 40, 28, 0, 28, 28, 10, 28, 28, 10, 10, 66, 28, 40, 10, 0, 38, 28, 28, 28, 38, 10, 28, 66, 38, 40, 28};

/**
 *
 * Stores texture strips for a subgame scrollbar thumb.
 *
 */
static short bart_5670[12] = {248, 0, 8, 10, 248, 10, 8, 10, 248, 20, 8, 10};

/**
 *
 * Stores texture strips for a subgame underline.
 *
 */
static short pl_s_5699[12] = {0, 66, 10, 6, 10, 66, 10, 6, 20, 66, 10, 6};

/**
 *
 * Stores the number of active collision points in each aquarium.
 *
 */
static s8 ColChkPointNum[3] = {9, 7, 6};

/**
 *
 * Stores the aquarium title horizontal position.
 *
 */
static int AQUA_TITLE_X = 10;

/**
 *
 * Stores the aquarium title vertical position.
 *
 */
static int AQUA_TITLE_Y = 6;

/**
 *
 * Stores the aquarium title width.
 *
 */
static int AQUA_TITLE_W = 158;

/**
 *
 * Stores the aquarium title height.
 *
 */
static int AQUA_TITLE_H = 66;

/**
 *
 * Stores the texture column positions of the fish parameter panel.
 *
 */
static u8 xtbl_2468[5] = {0, 50, 64, 78, 92};

/**
 *
 * Stores the texture row positions of the fish parameter panel.
 *
 */
static u8 ytbl_2469[5] = {0, 44, 58, 72, 86};

/**
 *
 * Stores the widths of the fish parameter panel texture columns.
 *
 */
static u8 wtbl_2470[5] = {50, 14, 14, 14, 50};

/**
 *
 * Stores the heights of the fish parameter panel texture rows.
 *
 */
static u8 htbl_2471[5] = {44, 14, 14, 14, 44};

/**
 *
 * Stores the shadow and foreground colours of the fish parameter panel.
 *
 */
static u8 coltbl_2472[2][4] = {
    {0, 0, 0, 48},
    {128, 128, 128, 128}
};

/**
 *
 * Stores the texture row offsets of the two fish sex marks.
 *
 */
static s8 offtbl_2496[2] = {0, 18};

/**
 *
 * Stores the fish name horizontal offset for each translated menu.
 *
 */
static s8 poffset_2511[7] = {79, 72, 72, 72, 72, 74, 79};

/**
 *
 * Stores the aquarium pending a tank change.
 *
 */
static short m_next_aqua_no = -1;

/**
 *
 * Stores aquarium model memory reservations in quadwords.
 *
 */
static u16 aqua_frame_sizetbl_2934[3] = {26965, 36965, 36965};

/**
 *
 * Stores the two fish effects selected by aquarium collisions.
 *
 */
static u8 tbl_3505[2] = {2, 1};

/**
 *
 * Stores the two destination aquariums for each active tank.
 *
 */
static s8 another_aquarium_Notbl_3642[3][2] = {
    {1, 2},
    {0, 2},
    {0, 1}
};

/**
 *
 * Stores the number of menu commands in each aquarium.
 *
 */
static s8 menu_max_tbl_3720[3] = {6, 4, 4};

/**
 *
 * Stores the fish-race and fishing-tournament prize script paths.
 *
 */
static char *filename_4899[2] = {"gyop.cfg", "uofp.cfg"};

// Code (.text)
/**
 *
 * Finds an aquarium grid cell, falling back to the first cell for an invalid index.
 *
 */
static aqua_grid_cell *Get_aquarium_paul_table(int index) {
    if ((index < 0) || (index >= 0x3C)) {
        index = 0;
    }

    return aquarium_paul_table + index;
}

/**
 *
 * Finds an aquarium grid cell by its horizontal coordinates.
 *
 */
static aqua_grid_cell *Get_aquarium_paul_table_xz(int x, int z) {
    return Get_aquarium_paul_table(x + z * 10);
}

/**
 *
 * Clamps an aquarium position to the tank walls and reports the walls touched.
 *
 */
static int local_aquarium_limmit_check(float *pos, float radius, int check_y, float height) {
    int hit = 0;

    if (pos[0] < -31.0f + radius) {
        pos[0] = -31.0f + radius;
        hit |= 2;
    } else if (!(pos[0] <= 31.0f - radius)) {
        pos[0] = 31.0f - radius;
        hit |= 1;
    }

    if (check_y != 0) {
        if (pos[1] < 19.6f + radius) {
            pos[1] = 19.6f + radius;
            hit |= 8;
        } else if (!(pos[1] <= (48.0f - radius) - height)) {
            pos[1] = (48.0f - radius) - height;
            hit |= 4;
        }
    }

    if (pos[2] < -18.0f + radius) {
        pos[2] = -18.0f + radius;
        return hit | 0x20;
    }

    if (!(pos[2] <= 18.0f - radius)) {
        pos[2] = 18.0f - radius;
        hit |= 1;
    }

    return hit;
}

int GetUseableEsaNo(int *out) {
    int count;
    int i;

    count = 0;

    for (i = 0; esa_info[i].item_no > 0; i++) {
        count++;
        out[i] = esa_info[i].item_no;
    }

    if (GetUserItemHaveNum(0x168) <= 0) {
        out[8] = -1;
        count--;
    }

    return count;
}

/**
 *
 * Finds aquarium food information by item number.
 *
 */
static aqua_food_info *GetEsaInfo(int item_no) {
    int i;

    for (i = 0; esa_info[i].item_no > 0; i++) {
        if (item_no == esa_info[i].item_no) {
            return &esa_info[i];
        }
    }

    return NULL;
}

void CBubble::Generate(int index) {
    AQUA_BUBBLE *particle = bubble + index;

    particle->drift_x = GetRandF(2.0f) - 1.0f;
    particle->drift_z = GetRandF(2.0f) - 1.0f;
    particle->pos[0] = origin[0] + particle->drift_x;
    particle->pos[1] = origin[1] + GetRandF(2.0f);
    particle->pos[2] = origin[2] + particle->drift_z;
    particle->pos[3] = 1.0f;
    particle->state = 0;
    particle->phase = GetRandF(3.1415927f);
    particle->pattern = GetRandI(5);
    particle->drift_x = 0.1f * particle->drift_x;
    particle->drift_z = 0.1f * particle->drift_z;
    particle->alpha = 32.0f;
}

int CBubble::Generate(float *start_pos) {

    if (active != 0 && bubble_num <= (unsigned int) generated) {
        return 0;
    }

    if (bubble_num <= (unsigned int) generated) {
        return 0;
    }

    *(u_long128 *) origin = *(u_long128 *) start_pos;
    Generate(generated);
    generated += 1;
    active = 1;
    return 1;
}

void CBubble::SetTexture(mgCTexture *image, int u, int v) {
    texture = image;
    tex_u = u;
    tex_v = v;
}

void CBubble::Step() {
    unsigned int finished;
    unsigned int index;
    AQUA_BUBBLE *particle;
    float       *amp;

    if (active == 0) {
        return;
    }

    finished = 0;
    index = 0;

    for (; index < bubble_num; index++) {
        particle = &bubble[index];

        if (particle->state == 0) {
            float depth = (particle->pos[1] - origin[1]) / height;
            float wobble;
            float spread;
            float jitter;

            particle->pos[1] = particle->pos[1] + (0.18f * depth + up_tbl_996[particle->pattern]);
            amp = amptbl_997[particle->pattern];
            wobble = (0.5f * depth + GetRandF(1.0f)) * sinf(particle->phase);
            depth *= 0.14f;
            spread = depth;
            float dx = amp[0] * wobble + particle->drift_x * spread;
            float dz = amp[1] * wobble + particle->drift_z * spread;
            jitter = 1.0f + GetRandF(spread);
            particle->pos[0] = particle->pos[0] + dx * jitter;
            particle->pos[2] = particle->pos[2] + dz * jitter;
            particle->phase += 0.15707964f;
            mgAngleLimit(particle->phase);

            if (!(particle->pos[1] < surface_y)) {
                particle->state = 1;
                particle->pos[1] = particle->pos[1] - GetRandF(0.1f);
                particle->pattern = GetRandI(10) + 16;
            }
        }

        if (particle->state == 1) {
            particle->pos[0] += particle->drift_x;
            particle->pos[2] += particle->drift_z;
            particle->pattern -= 1;
            particle->alpha = particle->alpha - 1.0f;

            if ((int) particle->pattern <= 0) {
                if (one_shot == 0) {
                    Generate(index);
                } else {
                    particle->state = 2;
                }
            }
        }

        if (particle->state == 2) {
            finished += 1;
        }
    }

    if (one_shot == 1 && bubble_num <= finished) {
        active = 0;
        generated = 0;
    }
}

void CBubble::Draw() {
    if (active == 0) {
        return;
    }

    mgCDrawPrim  prim;
    int          left[4];
    int          right[4];
    unsigned int index;
    AQUA_BUBBLE *particle;
    SetSpriteEnv(&prim, 4);
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.Begin(6);
    prim.Texture(texture);
    index = 0;

    for (; index < bubble_num; index++) {
        particle = &bubble[index];

        if (particle->state != 2 &&
            mgTransWorldPrim3DSprite(left, right, particle->pos, 0.4f, 0.4f, 0) != 0) {
            prim.Color(0x80, 0x80, 0x80, fptosi(particle->alpha));
            prim.TextureCrd(tex_u, tex_v);
            prim.Vertex4(left);
            prim.TextureCrd(tex_u + 0x10, tex_v + 0x10);
            prim.Vertex4(right);
        }
    }

    prim.End();
}

void CBubble::Initialize(mgCMemory *memory, float *start_pos, int count, float top) {
    unsigned int bytes;
    unsigned int blocks;
    unsigned int i;

    bubble_num = count;
    surface_y = top;
    origin[0] = start_pos[0];
    origin[1] = start_pos[1];
    origin[2] = start_pos[2];
    bytes = bubble_num * 0x30;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    bubble = (AQUA_BUBBLE *) memory->Alloc(blocks);
    i = 0;
    height = surface_y - origin[1];

    for (; i < bubble_num; i++) {
        Generate(i);
        float rise = GetRandF(height);
        bubble[i].pos[1] = origin[1] + rise;
    }

    active = 1;
    one_shot = 0;
    generated = 0;
}

void CBubble::RunOff() {
    active = 0;
    generated = 0;
}

/**
 *
 * Looks up the offspring species for a pair of aquarium fish.
 *
 */
static int GetChildFishNo(int first_fish, int second_fish) {
    for (int index = 0; index < 171; index++) {
        int first_parent = first_fish - 310;
        int second_parent = second_fish - 310;

        if (first_parent == aquafish_mixTable[index].first_parent &&
            second_parent == aquafish_mixTable[index].second_parent) {
            return aquafish_mixTable[index].child + 310;
        }

        if (first_parent == aquafish_mixTable[index].second_parent &&
            second_parent == aquafish_mixTable[index].first_parent) {
            return aquafish_mixTable[index].child + 310;
        }
    }

    return 310;
}

float SetFishAdjustScale(int length, int item_no, float base_scale, float max_scale) {
    CDataBreedFish *record;
    float           scale;
    float           result;

    scale = base_scale;
    record = GetBreedFishInfoData(item_no);

    if (record != NULL) {
        scale *= (float) length / record->size;
    }

    result = scale;

    if (max_scale <= scale) {
        result = max_scale;
    }

    return result;
}

void CAquaFishActionParam::Initialize() {
    memset(this, 0, sizeof(*this));
}

CAquaFish::CAquaFish() {
    action.Initialize();
    action.Initialize();
    action.Initialize();
    data = NULL;
    Initialize();
}

void CAquaFish::Initialize() {
    CCharacter2::Initialize();
    mgZeroVector(move);
    mgZeroVector(target_pos);
    mgZeroVector(target_rot);
    mgZeroVector(turn);
    turn[0] = 0.03141593f;
    think_mode = 0;
    think_timer = GetRandI(0x29) + 0xA;

    if (data != NULL) {
        data->Init();
    }

    data = NULL;
    pair_no = -1;
    col_flags = 0;
    radius = 0;
    wall_time = 0;
    eat_item = 0;
    swim_variant = GetRandI(8);
    action.Initialize();
    flash_count = 0;
    aqua_no = -1;
}

void CAquaFish::SetLiveParam(CGameDataUsed *item) {

    u16 value;
    int base;

    data = item;
    value = data->data.fish.param[3];
    base = ((value / 10) + (value >> 0x1F));
    fatigue_max = (base + (GetRandI(0x14) + 0x1A)) * 0x14;
    fatigue = 0;
}

void CAquaFish::SetAdjustScale() {
    float hi = 0.95f;
    float scale = SetFishAdjustScale(data->data.fish.size, data->item_no,
                                     0.6f, hi);
    SetScale(scale, scale, scale);
    radius = body_height * (scale / 0.6f);
}

int CAquaFish::AddFatigue(int amount) {
    fatigue += amount;

    if (fatigue < 0) {
        fatigue = 0;
    }

    if (max_fish_fatigue < fatigue) {
        fatigue = max_fish_fatigue;
    }

    return fatigue;
}

void CAquaFish::GetPosition2D(int *out) {
    float view[4][4];
    float camera_pos[4];
    int   screen_int[4];
    float screen[4];

    if (Camera__2 != NULL) {
        Camera__2->GetCameraMatrix(view);
        Camera__2->GetPos(camera_pos);
        mgSetViewMatrix(view, camera_pos);
        GetPosition(screen);
        mgTransWorldScreen(screen_int, screen);
        sceVu0ITOF4Vector(screen, screen_int);
        out[0] = fptosi(screen[0]);
        out[1] = fptosi(screen[1]);
    }
}

void CAquaFish::GetDirVect(float *out) {
    float       rot[4];
    float forward[4] = {0.0f, 0.0f, 1.0f, 1.0f};
    float       matrix[4][4];

    GetRotation(rot);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(out, matrix, forward);
    out[3] = 1.0f;
}

void CAquaFish::NormalGetNextVelo(float speed) {
    float to_target[4];

    GetPosition(to_target);
    sceVu0SubVector(to_target, target_pos, to_target);
    sceVu0Normalize(to_target, to_target);
    sceVu0ScaleVectorXYZ(to_target, to_target, speed);
    *(u_long128 *) move = *(u_long128 *) to_target;
    move[3] = 1.0f;
}

void CAquaFish::NormalGetNextRotY() {
    float dir[4];
    float pos[4];

    GetPosition(pos);
    sceVu0SubVector(dir, target_pos, pos);
    sceVu0Normalize(dir, dir);
    target_rot[1] = mgAngleLimit(atan2f(dir[0], dir[2]));
}

void CAquaFish::NormalGetNextRot() {
    float dir[4];
    float rot[4];
    float pos[4];

    GetRotation(rot);
    GetPosition(pos);
    sceVu0SubVector(dir, target_pos, pos);
    sceVu0Normalize(dir, dir);
    target_rot[0] = mgAngleLimit(atan2f(sqrt(dir[0] * dir[0] + dir[2] * dir[2]), dir[1]));

    if (0.0f < dir[1]) {
        target_rot[0] = -target_rot[0];
    }

    target_rot[1] = mgAngleLimit(atan2f(dir[0], dir[2]));
}

float CAquaFish::CalcMoveSpeed(float speed) {
    u8   *stats;
    float ceiling;
    int   offset;

    if (data == NULL) {
        stats = NULL;
    } else {
        stats = (u8 *) data + 0x10;
    }

    ceiling = 3.0f;

    switch (think_mode) {
        case 1:
            offset = GetRandI(3) * 2;
            speed *= 0.55f + 0.02f * (float) *(u16 *) (offset + (int) stats + 0x26);
            break;
        case 5:
            speed *= 0.65f + 0.024f * (float) *(u16 *) (stats + 0x26);
            ceiling = 4.4f;
            break;
        case 6:
            speed *= 0.65f + 0.024f * (float) *(u16 *) (stats + 0x26);
            break;
        case 7:
        case 8:
            speed *= 0.4f + 0.02f * (float) *(u16 *) (stats + 0x2C);
            break;
    }

    if (ceiling < speed) {
        speed = ceiling;
    }

    return speed;
}

void CAquaFish::NextRootNormal() {
    int             direction;
    int             grid_x;
    int             grid_z;
    int             level;
    float           sway;
    int             i;
    aqua_grid_cell *cell;
    float           dir[4];
    float           pos[4];
    float           rot[4];

    direction = GetRandI(2);
    grid_x = GetRandI(8) + 1;
    grid_z = GetRandI(5) + 1;
    level = GetRandI(4);
    sway = GetRandF(3.1415927f) - 1.5707964f;
    route_num = GetRandI(10) + 16;

    for (i = 0; i < route_num; i++) {
        cell = Get_aquarium_paul_table_xz(grid_x, grid_z);
        route[i][0] = cell->xz[0] + GetRandF(sinf(sway));
        route[i][2] = cell->xz[2] + GetRandF(sinf(sway));
        route[i][1] = cell->y[level];

        if (direction == 0) {
            grid_x += GetRandI(3) + 1;

            if (grid_x >= 10) {
                grid_x = 9;
                grid_z = GetRandI(2) + 4;
                direction ^= 1;
            }
        } else if (direction == 1) {
            grid_x -= GetRandI(3) + 1;

            if (grid_x <= 0) {
                grid_x = 0;
                grid_z = GetRandI(2);
                direction ^= 1;
            }
        }

        if (grid_z < 0) {
            grid_z = 0;
        }

        if (grid_z >= 6) {
            grid_z = 5;
        }

        level += GetRandI(3) - 1;

        if (level < 0) {
            level = 0;
        }

        if (level >= 4) {
            level = 3;
        }
    }

    route_no = 0;
    route_time = 0;
    *(u_long128 *) target_pos = *(u_long128 *) route[0];
    GetPosition(pos);
    GetRotation(rot);
    sceVu0SubVector(dir, target_pos, pos);
    sceVu0Normalize(dir, dir);
    target_rot[1] = mgAngleLimit(atan2f(dir[0], dir[2]));
}

#pragma optimization_level 4

void CAquaFish::MoveActionRound() {
    float  pos[4];
    float *turn;
    float  yaw;

    GetPosition(pos);
    sceVu0FVECTOR dir = {0.0f, 0.0f, 0.0f, 1.0f};
    yaw = target_rot[1];
    turn = dirtbl_1242[round.dir];

    if (pos[0] < -31.0f * round.width) {
        if (pos[2] < -18.0f * round.depth) {
            yaw = turn[0];
        } else if (18.0f * round.depth < pos[2]) {
            yaw = turn[1];
        }
    } else if (31.0f * round.width < pos[0]) {
        if (pos[2] < -18.0f * round.depth) {
            yaw = turn[2];
        } else if (18.0f * round.depth < pos[2]) {
            yaw = turn[3];
        }
    } else if (col_flags & 1) {
        wall_time += 1;

        if (wall_time > 200) {
            if ((round.dir == 0 && 0.0f <= pos[2]) || (round.dir == 1 && pos[2] < 0.0f)) {
                yaw = -1.5707964f;
            } else {
                yaw = 1.5707964f;
            }

            wall_time = 0;
        }
    } else {
        wall_time = 0;
    }

    action.speed += 0.01f;

    if (action.max_speed <= action.speed) {
        action.speed = action.max_speed;
    }

    target_rot[1] = mgAngleLimit(yaw);
    GetDirVect(dir);
    sceVu0Normalize(dir, dir);
    round.wave += 0.05235988f;
    round.wave = mgAngleLimit(round.wave);
    dir[1] += 0.1f * sinf(round.wave);

    if (col_flags & 2) {
        dir[1] += 0.2f;
    }

    sceVu0ScaleVectorXYZ(dir, dir, action.speed);
    *(aqua_quad *) move = *(aqua_quad *) dir;
}

#pragma optimization_level reset

void CAquaFish::MoveActionBattle() {
    CAquaFish    *foe;
    CAquaFishEff *eff;
    float         foe_pos[4];
    float         pos[4];

    struct {
        float        v[3];
        unsigned int w;
    } offset;

    float amount;
    float angle;
    float delta;

    foe = action.target;

    if (foe != NULL && swim_mode == 0) {
        foe->GetPosition(foe_pos);

        if (action.phase == 0) {
            *(u_long128 *) target_pos = *(u_long128 *) foe_pos;
            NormalGetNextVelo(CalcMoveSpeed(0.24f));
            NormalGetNextRot();
            think_timer -= 1;
        }

        if (action.phase == 1) {
            charge_angle = 0.0f;
            action.phase = 2;
            SetMotion("\x83\x6f\x83\x67\x83\x8b\x81\x69\x8c\xb3\x8b\x43\x81\x6a", 0);
            SetStep(1.0f);
        }

        if (action.phase == 2) {
            angle = charge_angle;
            angle += 0.10471976f;
            charge_angle = angle;

            if (3.1415927f < angle) {
                charge_angle = 3.1415927f;
                *(u_long128 *) target_pos = *(u_long128 *) foe_pos;
            }

            if (charge_angle < 3.1415927f) {
                charge_angle += 0.10471976f;
                delta = charge_angle - 2.9321532f;

                if (delta < 0.0f) {
                    delta = -delta;
                }

                if (delta <= 0.10471976f) {
                    eff = AquaFishEff[aqua_no];
                    eff->type = 4;
                    eff->timer = 0xFA0;
                }

                amount = 0.5f * sinf(mgAngleLimit(1.5707964f + charge_angle));
                GetPosition(pos);
                sceVu0SubVector(offset.v, foe_pos, pos);
                sceVu0Normalize(offset.v, offset.v);
                sceVu0ScaleVectorXYZ(offset.v, offset.v, amount);
                offset.w = 0x3F800000;
                sceVu0AddVector(target_pos, foe_pos, offset.v);
            } else if (col_flags & 0x10) {
                charge_angle = 0.0f;
                action.phase = 0;
                eff = AquaFishEff[aqua_no];
                eff->type = 0;
                eff->timer = -1;
                SetStep(0.5f);
            } else {
                NormalGetNextVelo(CalcMoveSpeed(0.3f));
                NormalGetNextRot();
                think_timer -= 1;
            }
        }
    }

    if (foe == NULL) {
        NextThink(5, NULL);
    }
}

void CAquaFish::NextThink(int think, NEXT_THINK_PARAM *param) {
    if (think < 0) {
        return;
    }

    switch (think) {
        case AQUA_FISH_THINK_REST:
            int timer = GetRandI(130) + 100;
            target_rot[0] = 0.0f;
            action.timer = timer;
            action.decel = 0.8f;
            SetMotion("\x92\xca\x8f\xed", 0);
            SetStep(0.5f);
            break;
        case AQUA_FISH_THINK_SWIM:
            swim_mode = AQUA_FISH_SWIM_POINT;
            swim_mode = AQUA_FISH_SWIM_ROUND;
            action.timer = 0;

            if (swim_mode == AQUA_FISH_SWIM_POINT) {
                float       pos[4];
                float       dir[4];
                float       rot[4];
                float       old_rot[4];
                aqua_vector forward;
                float       matrix[4][4];
                float       yaw;

                GetRandI(101);
                SetMotion("\x92\xca\x8f\xed", 0);
                GetRandF(40.0f);
                think_timer = 0;

                if (GetRandI(101) < 95) {
                    yaw = GetRandF(1.5707964f) - 0.7853982f;
                } else {
                    yaw = 3.1415927f + (GetRandF(1.5707964f) - 0.7853982f);
                }

                mgAngleLimit(yaw);
                turn[1] = 13.0f;
                GetRotation(rot);
                GetPosition(pos);
                *(u_long128 *) old_rot = *(u_long128 *) rot;

                if (col_flags & AQUA_FISH_COL_WALL) {
                    if (GetRandI(3) != 0) {
                        rot[1] += 0.19634955f;
                    } else {
                        rot[1] -= 0.19634955f;
                    }

                    mgAngleLimit(rot[1]);
                    SetRotation(rot);
                }

                GetDirVect(dir);
                forward = at_1346;
                sceVu0UnitMatrix(matrix);
                sceVu0RotMatrixY(matrix, matrix, rot[1]);
                sceVu0ApplyMatrix(dir, matrix, forward.v);
                dir[3] = 1.0f;
                sceVu0ScaleVector(dir, dir, 10.0f);
                sceVu0AddVector(pos, pos, dir);
                pos[1] += GetRandF(3.0f) - 1.5f;

                if (col_flags & AQUA_FISH_COL_OBJECT) {
                    pos[1] += 1.0f;
                }

                *(u_long128 *) target_pos = *(u_long128 *) pos;
                SetRotation(old_rot);
                NormalGetNextVelo(0.16f);
                NormalGetNextRotY();
                think_timer = 0;
                turn[0] = 0.24166098f;
                turn[1] = 24.0f;
            }

            if (swim_mode == AQUA_FISH_SWIM_ROUND) {
                float min_speed;
                float accel;

                SetMotion("\x92\xca\x8f\xed", 0);
                round.dir = GetRandI(2);
                round.width = 0.5f + GetRandF(0.02f) - 0.01f;
                round.depth = GetRandF(0.02f) - 0.01f;
                route_time = 0;
                action.max_speed = 0.12f + GetRandF(0.2f) - 0.1f;
                action.speed = 0.0f;

                if (0.2f < action.speed) {
                    action.speed *= 0.5f;
                }

                round.wave = GetRandF(6.2831855f) - 3.1415927f;
                turn[1] = 50.0f + GetRandF(5.0f) - 2.5f;
                think_timer = 0;
            }

            if (swim_mode == AQUA_FISH_SWIM_ROUTE) {
                action.phase = 0;
                SetMotion("\x92\xca\x8f\xed", 0);
                GetRandF(40.0f);
                think_timer = 0;
                turn[1] = 24.0f;

                if (swim_variant >= 8) {
                    swim_variant = 0;
                }

                NextRootNormal();
            }

            break;
        case AQUA_FISH_THINK_FOOD_LOOK:
            *(u_long128 *) target_pos = *(u_long128 *) param->pos;
            action.timer = (GetRandI(4) + 4) * 25;
            action.decel = 0.7f;
            turn[1] = 15.0f;
            break;
        case AQUA_FISH_THINK_FOOD_EAT:
            SetMotion("\x83\x6f\x83\x67\x83\x8b\x81\x69\x8c\xb3\x8b\x43\x81\x6a", 0);
            *(u_long128 *) target_pos = *(u_long128 *) param->pos;
            NormalGetNextRotY();
            think_timer = 0;
            turn[0] = 0.1308997f;
            turn[1] = 24.0f;
            param->effect->StartFishEffect(4);
            eat_item = 0;
            break;
        case AQUA_FISH_THINK_BATTLE:
            if (param != NULL) {
                action.target_no = param->target_no;
                action.target = param->target;
            }

            if (param == NULL || action.target_no < 0) {
                swim_mode = AQUA_FISH_SWIM_POINT;
                think = AQUA_FISH_THINK_BATTLE_REST;
                think_timer = GetRandI(250) + 250;
            } else {
                swim_mode = AQUA_FISH_SWIM_POINT;
                think_timer = GetRandI(175) + 125;
            }

            break;
        case AQUA_FISH_THINK_BATTLE_REST: {
            float x = GetRandF(60.0f) - 30.0f;
            float y = 17.0f + GetRandF(27.0f);
            float z = GetRandF(34.0f) - 17.0f;

            target_pos[0] = x;
            target_pos[1] = y;
            target_pos[2] = z;
            NormalGetNextVelo(0.05f);
            turn[1] = 24.0f;
            action.phase = 3;
            break;
        }
        case AQUA_FISH_THINK_LOVE_SEARCH:
        case AQUA_FISH_THINK_LOVE_CHASE:
        case 9:
            break;
    }

    think_mode = think;
}

int CAquaFish::ParamStep() {
    int             result = 0;
    BREEDFISH_USED *breed;

    breed = data == NULL ? NULL : &data->data.fish;

    if (breed == NULL) {
        return 0;
    }

    if (think_mode == AQUA_FISH_THINK_BATTLE && action.hit_count > 0xB4) {
        u16 before;

        action.hit_count = 0;
        before = breed->param[4];

        if (before < 100) {
            breed->param[4] = before + 1;

            if (data != NULL) {
                data->CheckParamLimmit();
            }

            if (before < breed->param[4]) {
                MenuSePlay(0x1E);
            }

            AquaFishEff[aqua_no]->StartFishEffect(2);
        }
    }

    if (data->AddFishHp(0) <= 0) {
        float pos[4];
        float bubble_pos[4];
        int   i;

        GetPosition(pos);

        for (i = 0; i < 0x88; i++) {
            bubble_pos[0] = pos[0] + GetRandF(5.0f) - 2.5f;
            bubble_pos[1] = pos[1] + GetRandF(3.0f) - 1.5f;
            bubble_pos[2] = pos[2] + GetRandF(5.0f) - 2.5f;
            AquaFishBubble[aqua_no]->Generate(bubble_pos);
        }

        result |= AQUA_FISH_RESULT_DEAD;
        AquaFishEff[aqua_no]->fish = NULL;
    }

    if (0 < eat_item && (col_flags & AQUA_FISH_COL_FOOD)) {
        aqua_food_info *esa = GetEsaInfo(eat_item);
        int             full = breed->flags & 0x80;

        if (full) {
            result |= AQUA_FISH_RESULT_FEEDING_EXHAUSTED;
        }

        if (esa != NULL && !full) {
            breed->param[3] += esa->add_param3;
            breed->param[0] += esa->add_param0;
            breed->param[1] += esa->add_param1;
            breed->param[2] += esa->add_param2;
            breed->grow_count = breed->grow_count + esa->growth;
            breed->timer += esa->add_timer;
        }

        breed->breed_feeds_remaining--;

        if (breed->breed_feeds_remaining < 0) {
            breed->breed_feeds_remaining = 0;
        }

        if (eat_item == 0x13B) {
            if (breed->sex == 0) {
                result |= AQUA_FISH_RESULT_SEX_CHANGED_TO_1;
                breed->sex = 1;
            } else if (breed->sex == 1) {
                breed->sex = 0;
                result |= AQUA_FISH_RESULT_SEX_CHANGED_TO_0;
            }
        }

        breed->flags |= 1;

        if (breed->grow_count > 10) {
            int grow = GetRandI(3) + 1;
            int gain = grow * (GetRandI(3) + 3);

            breed->size += grow;
            breed->weight += gain;
            breed->grow_count = -2;
        }

        if (breed->size > 2000) {
            breed->size = 2000;
        }

        if (breed->weight > 60000) {
            breed->weight = 60000;
        }

        data->CheckParamLimmit();
        SetAdjustScale();

        if (eat_item == 0x168) {
            breed->flags |= 2;
            breed->life = 200;
        }

        if (!(breed->flags & 2)) {
            int left = breed->life - 1;

            if (left <= 0) {
                left = 0;
                breed->flags |= 0x80;
            }

            breed->life = left;
        }

        MenuSePlay(Aqua_SpSndID, 1);
        eat_item = 0;
    }

    flash_count++;

    if (flash_count >= 25) {
        flash_count = 0;
    }

    return result;
}

void CAquaFish::FishDraw() {
    if (data != NULL) {
        unsigned int hp = data->data.fish.hp;
        float        saved[4];

        mgGetAmbient(saved);
        float bright[4] = {140.0f, 64.0f, 64.0f, 128.0f};

        if (hp < 0x1E && flash_count < 0xB) {
            bright[0] = 172.0f;
            mgSetAmbient(bright);
        }

        DrawDirect();
        mgSetAmbient(saved);
    }
}

void CAquaFishEff::Initialize() {
    fish = NULL;
    texture = NULL;
    type = 0;
    timer = 0;
}

void CAquaFishEff::StartFishEffect(int effect_kind) {
    type = (short) effect_kind;
    timer = max_tbl_1484[type];
}

void CAquaFishEff::Step() {
    if ((fish != 0) && (type != 0)) {
        timer -= 1;

        if (timer <= 0) {
            timer = 0;
            type = 0;
        }
    }
}

void CAquaFishEff::Draw() {
    int   alpha;
    float bob;

    if (fish == NULL || texture == NULL) {
        return;
    }

    if (type != 0) {
        alpha = 0x80;

        if (timer < 15) {
            alpha = timer * 8;
        }

        mgCDrawPrim prim;
        float       pos[4];
        int         left[4];
        int         right[4];

        fish->GetPosition(pos);
        SetSpriteEnv(&prim, 0);
        prim.Coord(1);
        prim.DepthTestEnable(1);
        prim.Bilinear(2);
        prim.Begin(6);
        prim.Texture(texture);
        prim.Color(0x80, 0x80, 0x80, alpha);
        bob = sinf(0.19634955f * (float) (timer % 16));
        pos[1] += 5.3f + 0.8f * (bob < 0.0f ? -bob : bob);

        switch (type) {
            case 1:
                if (mgTransWorldPrim3DSprite(left, right, pos, 3.0f, 3.0f, 0) != 0) {
                    prim.TextureCrd(0x6A, 0x16);
                    prim.Vertex4(left);
                    prim.TextureCrd(0x80, 0x2C);
                    prim.Vertex4(right);
                }

                break;
            case 2:
                if (mgTransWorldPrim3DSprite(left, right, pos, 3.0f, 3.0f, 0) != 0) {
                    prim.TextureCrd(0x6A, 0x2C);
                    prim.Vertex4(left);
                    prim.TextureCrd(0x80, 0x42);
                    prim.Vertex4(right);
                }

                break;
            case 3:
            case 4:
                if (mgTransWorldPrim3DSprite(left, right, pos, 3.0f, 3.0f, 0) != 0) {
                    prim.TextureCrd(0x6A, 0);
                    prim.Vertex4(left);
                    prim.TextureCrd(0x80, 0x16);
                    prim.Vertex4(right);
                }

                break;
            case 5:
                if (mgTransWorldPrim3DSprite(left, right, pos, 3.0f, 3.0f, 0) != 0) {
                    prim.TextureCrd(0x6A, 0x42);
                    prim.Vertex4(left);
                    prim.TextureCrd(0x80, 0x58);
                    prim.Vertex4(right);
                }

                break;
        }

        prim.End();
    }
}

CFishFood::CFishFood() {
    CCharacter2::Initialize();
    mgZeroVector(spin);
    pos[0] = 0.0f;
    pos[1] = 0.0f;
    pos[2] = 0.0f;
    pos[3] = 1.0f;
    item_no = 0;
    fall_time = 0;
    sway = 0.0f;
    sway_phase = 0.0f;
    state = FISH_FOOD_HOLD;
}

void CFishFood::SetDropPosition(float *pos) {
    *(u_long128 *) this->pos = *(u_long128 *) pos;
    SetPosition(this->pos);
}

void CFishFood::Drop() {
    state = 1;
    sway = 2.5f + GetRandF(1.6f);
    fall_time = 0;
    sway_phase = 0;
    spin[0] = 0.015707964f + GetRandF(3.1415927f) / 34.0f;
    spin[2] = 0.015707964f + GetRandF(3.1415927f) / 34.0f;
}

void CFishFood::Step() {
    float           next[4];
    float           rot[4];
    float           test[4];
    float           away[4];
    float           spin_z;
    float           sway_x;
    int             check_y;
    aqua_col_point *point;
    int             i;

    float spin_x = 0.0f;
    next[0] = 0.0f;
    next[1] = 0.0f;
    next[2] = 0.0f;
    spin_z = spin_x;
    GetRotation(rot);
    check_y = 1;

    if (state == FISH_FOOD_HOLD) {
        check_y = 0;
    } else if (48.0f < pos[1]) {
        fall_time++;
        pos[1] -= 0.25f * fall_time;
        spin_x = spin[0];
        spin_z = spin[2];
        check_y = 0;
    } else if (19.6f <= pos[1]) {
        pos[1] -= 0.15f;
        spin[0] -= 0.001f;

        if (spin[0] <= 0.0f) {
            spin[0] = 0.0f;
        }

        spin[2] -= 0.001f;

        if (spin[2] <= 0.0f) {
            spin[2] = 0.0f;
        }

        spin_x = spin[0];
        spin_z = spin[2];
        sway -= 0.017f;

        if (sway <= 0.0f) {
            sway = 0.0f;
        }

        sway_phase += 0.10471976f;

        if (!(sway_phase <= 3.1415927f)) {
            sway_phase -= 6.2831855f;
        }

        sway_x = sway * sinf(sway_phase) - 0.5f * sway;
        next[0] += sway_x;
        next[2] += sway_x;
        test[0] = next[0] + pos[0];
        test[1] = next[1] + pos[1];
        test[2] = next[2] + pos[2];
        point = ColChkPoint;

        for (i = 0; i < 9; i++, point++) {
            float limit = point->radius + body_width;

            if (mgDistVector(test, point->pos) < limit) {
                sceVu0SubVector(away, test, point->pos);
                away[3] = 1.0f;
                sceVu0Normalize(away, away);
                next[0] = 0.0f;
                next[1] = 0.0f;
                next[2] = 0.0f;
                pos[0] = point->pos[0] + point->radius * away[0];
                pos[1] = point->pos[1] + point->radius * away[1];
                pos[2] = point->pos[2] + point->radius * away[2];
                sway = 0.0f;
                break;
            }
        }
    }

    next[0] += pos[0];
    next[1] += pos[1];
    next[2] += pos[2];
    local_aquarium_limmit_check(next, 1.3f, check_y, 0.0f);
    int current_state = state;

    if (next[1] <= 48.0f) {
        if (current_state == FISH_FOOD_DROP) {
            state = FISH_FOOD_ENTER;
        } else {
            state = FISH_FOOD_SINK;
        }
    }

    rot[0] += spin_x;
    rot[2] += spin_z;
    mgAngleLimit(rot[0]);
    mgAngleLimit(rot[2]);
    SetPosition(next);
    SetRotation(rot);
    CCharacter2::Step();
}

void DrawEsaDropRoot(CFishFood *food, float bottom) {
    if (food == NULL) {
        return;
    } else {
        static int  count = 0;
        mgCDrawPrim prim;
        float       pos[4];
        int         left[4];
        int         right[4];

        SetSpriteEnv(&prim, 1);
        prim.Coord(1);
        prim.DepthTestEnable(1);
        food->GetPosition(pos);

        for (; bottom < pos[1]; pos[1] -= 2.4f) {
            if (mgTransWorldPrim3DSprite(left, right, pos, 0.3f, 1.0f, 0) != 0) {
                prim.Begin(6);
                prim.Color(0x80, 0x80, 0xC8, 0x60);
                prim.Vertex4(left);
                prim.Vertex4(right);
                prim.End();
            }
        }
    }
}

void AquaMesDispAdjustPos(ClsMes *window, int *pos) {
    int width;
    int height;

    if (window != NULL) {
        width = window->line_w[0];
        height = window->line_w[1];

        if (width < height) {
            width = height;
        }

        window->abs_win.x = pos[0] - (width >> 1);
        window->abs_win.y = pos[1];

        if (window->abs_win.x < 0x2C) {
            window->abs_win.x = 0x2C;
        }

        if (window->abs_win.y < 0x2C) {
            window->abs_win.y = 0x2C;
        }

        if (mgScreenWidth - 0x36 < window->abs_win.x + width) {
            window->abs_win.x = mgScreenWidth - 0x36 - width;
        }

        if (mgScreenHeight - 0x2C < window->abs_win.y + 0x30) {
            window->abs_win.y = mgScreenHeight - 0x5C;
        }
    }
}

CAquaMes::CAquaMes() {
    Initialize(NULL);
}

static inline short *AquaMesBuffer(mgCMemory *m) { return (short *) m->stAllocTest(1); }

void CAquaMes::Initialize(mgCMemory *stack) {
    short  *aqua_mes;
    ClsMes *mes;
    short  *system_mes;
    char    path[0x4C];
    int     size;

    memory = stack;
    title_mes = NULL;
    title_id = 0;
    title_draw = 0;
    menu_mes = NULL;
    menu_cursor = 0;
    menu_draw = 0;
    cursor_pos[0] = 0.0f;
    cursor_pos[1] = 0.0f;
    cursor_target[0] = 0.0f;
    cursor_target[1] = 0.0f;
    cursor_draw = 0;
    cursor_snap = 1;
    question_mes = NULL;
    question_cursor = 0;
    question_draw = 0;
    guide_mes = NULL;
    guide_id = 0xC8;
    guide_draw = 0;
    help_mes = NULL;
    help_draw = 0;
    fish_mes_time = 0;
    unk_5c = -1;
    unk_60 = -1;

    if (memory == NULL) {
        return;
    }

    system_mes = GetSystemMesBuffer();
    title_mes = new ((u_long128 *) memory->Alloc(align16_blocks(sizeof(ClsMes)) + 2)) ClsMes;
    menu_mes = new ((u_long128 *) memory->Alloc(align16_blocks(sizeof(ClsMes)) + 2)) ClsMes;
    guide_mes = new ((u_long128 *) memory->Alloc(align16_blocks(sizeof(ClsMes)) + 2)) ClsMes;
    question_mes = new ((u_long128 *) memory->Alloc(align16_blocks(sizeof(ClsMes)) + 2)) ClsMes;
    help_mes = new ((u_long128 *) memory->Alloc(align16_blocks(sizeof(ClsMes)) + 2)) ClsMes;
    info_mes = new ((u_long128 *) memory->Alloc(align16_blocks(sizeof(ClsMes)) + 2)) ClsMes;
    fish_mes = new ((u_long128 *) memory->Alloc(align16_blocks(sizeof(ClsMes)) + 2)) ClsMes;
    memory->Align64();
    aqua_mes = AquaMesBuffer(memory);
    sprintf(path, "menu/aqua/mes/fconv%d.bin", LanguageCode);

    if (LoadFile2(path, aqua_mes, &size, 0) != 0) {
        memory->Alloc(size / 16 + 1);
    }

    mes = title_mes;
    mes->Init();
    mes->SetBuff(aqua_mes);
    mes->texture_block = MenuArg.mes_tex_block;
    mes->SetBuff_system(system_mes);
    mes->SetWindowMode(0);
    mes->fade_speed = 0.0f;
    mes->draw_speed = 0.0f;
    mes->draw_speed_def = 0.0f;
    mes->abs_win.x = AQUA_TITLE_X;
    mes->abs_win.y = AQUA_TITLE_Y;
    mes->font_w++;
    mes->MakeMesWin(title_id);

    mes = menu_mes;
    mes->Init();
    mes->SetBuff(aqua_mes);
    mes->texture_block = MenuArg.mes_tex_block;
    mes->SetBuff_system(system_mes);
    mes->SetWindowMode(4);
    mes->fade_speed = 0.0f;
    mes->draw_speed = 0.0f;
    mes->draw_speed_def = 0.0f;

    if (mes->select < 0) {
        mes->cursor_time = 0;
    }

    mes->select = 0;
    mes->select_shade = 1;
    mes->select_top = 0;
    mes->abs_win.x = 0x1E;
    mes->abs_win.y = 0xB4;
    mes->MakeMesWin(0xA);

    mes = guide_mes;
    mes->Init();
    mes->SetBuff(aqua_mes);
    mes->texture_block = MenuArg.mes_tex_block;
    mes->SetBuff_system(system_mes);
    mes->centering = 0;
    mes->SetWindowMode(4);
    mes->fade_speed = 1.0f;
    mes->draw_speed = 0.0f;
    mes->draw_speed_def = 0.0f;
    mes->MakeMesWin(guide_id);
    mes->fukidashi_pos = 8;

    mes = question_mes;
    mes->Init();
    mes->SetBuff(aqua_mes);
    mes->texture_block = MenuArg.mes_tex_block;
    mes->SetBuff_system(system_mes);
    mes->centering = 0;
    mes->SetWindowMode(4);
    mes->fukidashi_pos = 5;
    mes->fade_speed = 1.0f;
    mes->draw_speed = 0.0f;
    mes->draw_speed_def = 0.0f;
    mes->mes_no = -1;

    mes = help_mes;
    mes->Init();
    mes->SetBuff(aqua_mes);
    mes->SetBuff_system(system_mes);
    mes->texture_block = MenuArg.mes_tex_block;
    mes->SetWindowMode(0);
    mes->fade_speed = 1.0f;
    mes->draw_speed = 0.0f;
    mes->draw_speed_def = 0.0f;
    mes->mes_no = -1;

    mes = info_mes;
    mes->Init();
    mes->SetBuff(aqua_mes);
    mes->SetBuff_system(system_mes);
    mes->texture_block = MenuArg.mes_tex_block;
    mes->SetWindowMode(4);
    mes->fukidashi_pos = 5;
    mes->fade_speed = 1.0f;
    mes->draw_speed = 0.0f;
    mes->draw_speed_def = 0.0f;
    mes->mes_no = -1;

    mes = fish_mes;
    mes->Init();
    mes->SetBuff(aqua_mes);
    mes->SetBuff_system(system_mes);
    mes->texture_block = MenuArg.mes_tex_block;
    mes->SetWindowMode(4);
    mes->fukidashi_pos = 5;
    mes->fade_speed = 1.0f;
    mes->draw_speed = 0.0f;
    mes->draw_speed_def = 0.0f;
    mes->mes_no = -1;
}

void CAquaMes::SettingAquaMes(int kind) {
    switch (kind) {
        case 0:
            SetTitleId(0);
            menu_mes->MakeMesWin(0xA);
            break;
        case 1:
            SetTitleId(1);
            menu_mes->MakeMesWin(0xB);
            break;
        case 2:
            SetTitleId(2);
            menu_mes->MakeMesWin(0xC);
            break;
    }

    SetCtrlHelpId(0x32);
}

void CAquaMes::SetTitleId(int id) {
    ClsMes *window;
    int     half_w;
    int     half_h;

    title_id = id;
    title_mes->MakeMesWin(title_id);
    title_mes->Step();
    window = title_mes;
    half_w = AQUA_TITLE_W / 2;
    window->abs_win.x = (AQUA_TITLE_X + half_w) - (window->line_w[0] >> 1);
    window = title_mes;
    half_h = AQUA_TITLE_H / 2;
    window->abs_win.y = ((AQUA_TITLE_Y + half_h) - (window->font_h >> 1)) + 2;
}

int CAquaMes::AddMenuCursor(int step, int count) {
    int before = menu_cursor;

    menu_cursor = before + step;

    if (menu_cursor < 0) {
        menu_cursor = count - 1;
    }

    if (menu_cursor >= count) {
        menu_cursor = 0;
    }

    if (before != menu_cursor) {
        return 1;
    }

    return 0;
}

void CAquaMes::SetQuestionId(int id, int top, int num) {
    char *item_name[12];
    int   item_no[12];
    char  format[0x100];
    char  line[0x80];

    question_cursor = 0;
    question_num = num;
    question_mes->select_top = top;

    if (id == 0x320) {
        int esa_num;
        int listed;

        question_mes->mes_no = -1;
        esa_num = GetUseableEsaNo(item_no);

        if (esa_num == 8) {
            id = 0x320;
        }

        if (esa_num == 9) {
            id = 0x321;
        }

        listed = 0;

        for (int i = 0; item_no[i] > 0; i++, listed++) {
            int have;
            int pad;
            item_name[i] = GetItemMessage(item_no[i]);

            if (item_name[i] == NULL) {
                break;
            }

            memset(format, 0, sizeof(format));
            have = GetUserItemHaveNum(item_no[i]);
            strcpy(format, item_name[i]);
            pad = 16 - strlen(format);

            if (CheckNowEurope()) {
                pad = 24 - strlen(format);
            }

            if (LanguageCode == 0) {
                for (int j = 0; j < pad / 2; j++) {
                    strcat(format, "\x81\x40");
                }

                strcat(format, "\x81\x7e%3d");
            } else {
                for (int j = 0; j < pad; j++) {
                    strcat(format, " ");
                }

                strcat(format, "x%3d");
            }

            sprintf(line, format, have);
            strcpy(question_mes->name[listed], line);
        }

        question_num = listed;
    }

    question_mes->SetHalfFontWPercent(0.5f);
    question_mes->MakeMesWin(id);
    question_mes->Step();
}

int CAquaMes::AddQuestionCursor() {
    int     step = 0;
    int     before = question_cursor;
    int     base;
    int     now;
    ClsMes *window;

    if (GamePad__2.Down(0x1000)) {
        step--;
    } else if (GamePad__2.Down(0x4000)) {
        step++;
    }

    question_cursor += step;

    if (question_cursor < 0) {
        question_cursor = 0;
    }

    if (question_num <= question_cursor) {
        question_cursor = question_num - 1;
    }

    now = question_cursor;

    if (before != now) {
        return 1;
    }

    window = question_mes;
    base = window->select_top;

    if (base < 0) {
        base = 0;
    }

    now = base + now;

    if (window->select < 0) {
        window->cursor_time = 0;
    }

    window->select = now;
    return 0;
}

void CAquaMes::SetCtrlHelpId(int id) {
    int     half_w;
    int     bottom;
    ClsMes *window;

    help_mes->mes_no = -1;
    help_mes->MakeMesWin(id);
    help_mes->Step();
    half_w = mgScreenWidth >> 1;
    bottom = mgScreenHeight - 0x28;
    window = help_mes;
    window->line_pos[0][0] = (half_w - window->line_w[0]) - 0x14;
    window->line_pos[0][1] = bottom;
    window->line_pos_on[0] = 1;
    window = help_mes;
    bottom = mgScreenHeight - 0x28;
    window->line_pos[1][0] = half_w + 0x32;
    window->line_pos[1][1] = bottom;
    window->line_pos_on[1] = 1;
}

void CAquaMes::SetInfoMsgID(int id) {
    info_mes->mes_no = -1;
    info_mes->MakeMesWin(id);
    info_mes->Step();
}

void CAquaMes::EatMessage(int id, CAquaFish *fish) {
    char *name;
    int   pos[2];

    name = fish->data->GetName(0);

    if (name != NULL) {
        copy_name(fish_mes, 0, name);
    }

    fish_mes->mes_no = -1;
    fish_mes->MakeMesWin(id);
    fish_mes_time = 0xFA;
    fish->GetPosition2D(pos);
    AquaMesDispAdjustPos(fish_mes, pos);
}

static inline CGameDataUsed *fish_data(CAquaFish *fish) {
    return fish->data;
}

void CAquaMes::ChangeManMessage(CAquaFish *fish) {
    CGameDataUsed *data = fish_data(fish);
    char          *name = data->GetName(0);
    int            pos[2];

    if (name != NULL) {
        copy_name(fish_mes, 0, name);
    }

    fish_mes->mes_no = -1;

    if (data->data.fish.sex == 0) {
        fish_mes->MakeMesWin(0x138);
    }

    if (data->data.fish.sex == 1) {
        fish_mes->MakeMesWin(0x137);
    }

    fish_mes_time = 0xFA;
    fish->GetPosition2D(pos);
    AquaMesDispAdjustPos(fish_mes, pos);
}

void CAquaMes::DeadMessage(CAquaFish *fish) {
    char *name;
    int   pos[2];

    if (fish != NULL) {
        name = fish->data->GetName(0);
        fish_mes->mes_no = -1;
        copy_name(fish_mes, 0, name);
        fish_mes->MakeMesWin(0x134);
        fish_mes->Step();
        fish_mes_time = 0xFA;
        fish->GetPosition2D(pos);
        AquaMesDispAdjustPos(fish_mes, pos);
    }
}

void CAquaMes::Step() {
    int index;

    for (index = 0; index < 2; index++) {
        if (title_mes != NULL) {
            title_mes->Step();
        }

        if (menu_mes != NULL) {
            ClsMes *menu = menu_mes;
            int     cursor = menu_cursor;

            if (menu->select < 0) {
                menu->cursor_time = 0;
            }

            menu->select = cursor;
            menu_mes->Step();
        }

        if (guide_mes != NULL) {
            guide_mes->Step();
        }

        if (question_mes != NULL) {
            question_mes->Step();
        }

        if (help_mes != NULL) {
            help_mes->Step();
        }

        if (info_mes != NULL) {
            info_mes->Step();
        }

        if (0 < fish_mes_time) {
            fish_mes_time--;
        }

        if (fish_mes != NULL) {
            fish_mes->Step();
        }
    }

    for (index = 0; index < 2; index++) {
        float target = cursor_target[index];
        float delta = target - cursor_pos[index];

        if (cursor_snap != 0 || (delta < 0.0f ? -delta : delta) <= 0.1f) {
            cursor_pos[index] = target;
        } else {
            cursor_pos[index] += delta / 3.0f;
        }
    }

    if (cursor_snap != 0) {
        cursor_snap = 0;
    }
}

void CAquaMes::Draw() {
    mgCTextureManager *manager;
    mgCTexture        *cursor_texture;

    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);

    if (menu_mes != NULL && menu_draw != 0) {
        menu_mes->DrawMesWin();
    }

    if (guide_mes != NULL && guide_draw != 0) {
        guide_mes->DrawMesWin();
    }

    if (question_mes != NULL && question_draw != 0) {
        question_mes->DrawMesWin();
    }

    if (help_mes != NULL && help_draw != 0) {
        help_mes->DrawMesWin();
    }

    if (info_mes != NULL && info_draw != 0) {
        info_mes->DrawMesWin();
    }

    if (fish_mes != NULL && 0 < fish_mes_time) {
        fish_mes->DrawMesWin();
    }

    if (cursor_draw != 0) {
        manager = &mgTexManager;
        cursor_texture = manager->GetTexture("mnmain", -1);

        if (cursor_texture != NULL) {
            manager->ReloadTexture(cursor_texture->block, (sceVif1Packet *) NULL);
            MenuCursorDraw(cursor_texture, cursor_pos, 0.0f, 0x80);
        }
    }
}

void CAquaMes::DrawTitleMes() {
    ClsMes *window;

    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    window = title_mes;

    if ((window != NULL) && (title_draw != 0)) {
        window->DrawMesWin();
    }
}

/**
 *
 * Builds the aquarium fish asset path for an item number.
 *
 */
static int GetFishPath(int item_no, char *out) {
    char *file_name;

    file_name = GetItemFileName(item_no, 1);

    if ((file_name == 0) || (out == NULL)) {
        return 1;
    }

    sprintf(out, "menu/aqua/fish/%s", file_name);
    return 0;
}

int GetFishImgPath(char *out, int item_no, BREEDFISH_USED *fish) {
    aqua_fish_info *info;

    if (item_no <= 0) {
        return 0;
    }

    if (fish == NULL) {
        return 0;
    }

    if (out == NULL) {
        return 0;
    }

    for (info = aquafish_info; info->item_no > 0; info++) {
        if (info->item_no == item_no) {
            sprintf(out, "menu/aqua/fish/%s%d.img", info->img_path, fish->color);
            return 1;
        }
    }

    return 0;
}

int GetFishImageColor(int item_no, int sex) {
    aqua_fish_info *info = aquafish_info;

    for (; info->img_path != 0; info++) {
        if (sex == 0 && info->item_no == item_no) {
            return info->color_male;
        }

        if (sex == 1 && info->item_no == item_no) {
            return info->color_female;
        }
    }

    return 0;
}

int FishIMGReplace(u_long128 *data, CCharacter2 *character, int item_no, BREEDFISH_USED *fish) {
    int  size;
    char path[0x80];
    char saved_dir[0x6C];
    u8  *texture_buffer;

    u8 *character_bytes = (u8 *) character;

    if (data == NULL || character_bytes == NULL || fish == NULL) {
        return 0;
    }

    if (fish->flags & 2) {
        return 0;
    }

    if (GetFishImgPath(path, item_no, fish) != 0) {
        GetCurrentDir(saved_dir);
        SetCurrentDir(NULL);

        if (LoadFile2(path, data, &size, 0) != 0) {
            texture_buffer = *(u8 **) (character_bytes + 0x2C4);
            mgTexManager.DeleteBlock(*(int *) (character_bytes + 0x2E4));
            memcpy(texture_buffer, data, size);
            mgTexManager.EnterIMGFile(texture_buffer, *(int *) (character_bytes + 0x2E4), NULL, NULL);
        }

        SetCurrentDir(saved_dir);
    }

    return 0;
}

void DrawFishParam(int x, int y, mgCTexture *tex, CGameDataUsed *data) {
    float fx;
    float fy;
    int   pass;
    int   row;
    int   col;
    int   cx;
    int   cy;
    int   lang;
    int   bx;
    int   by;
    int   name_x;

    if (data == NULL || tex == NULL) {
        return;
    }
    BREEDFISH_USED *breed;
    breed = &data->data.fish;
    fx = x;
    fy = y;
    int center_w = (0x14A - wtbl_2470[0] - wtbl_2470[2] - wtbl_2470[4]) >> 1;
    int center_h = (0x8C - htbl_2471[0] - htbl_2471[2] - htbl_2471[4]) >> 1;
    int w[5] = {wtbl_2470[0], center_w, wtbl_2470[2], center_w, wtbl_2470[4]};
    int h[5] = {htbl_2471[0], center_h, htbl_2471[2], center_h, htbl_2471[4]};
    int params[6] = {0};
    if (data->item_no > 1) {
        params[1] = breed->param[4];
        params[2] = breed->param[3];
        params[3] = breed->param[0];
        params[4] = breed->param[1];
        params[5] = breed->param[2];
    }
    mgCDrawPrim  prim;
    mgCDrawPrim *pen = &prim;
    SetSpriteEnv(pen, 0);
    pen->Begin(MG_PRIM_SPRITE);
    pen->Texture(tex);
    for (pass = 0; pass < 2; pass++) {
        pen->Color(coltbl_2472[pass][0], coltbl_2472[pass][1], coltbl_2472[pass][2], coltbl_2472[pass][3]);
        for (cy = 0, row = 0; row < 5; cy += h[row], row++) {
            for (cx = 0, col = 0; col < 5; cx += w[col], col++) {
                PrimQuad(pen, mgRect<int>((int) (fx + cx), (int) (fy + cy), w[col], h[row]),
                         mgRect<int>(xtbl_2468[col], ytbl_2469[row], wtbl_2470[col], htbl_2471[row]));
            }
        }
        fx -= 4.0f;
        fy -= 4.0f;
    }
    pen->End();
    lang = LanguageCode;
    fx = x;
    fy = y;
    mgRect<int> label_rect;
    mgRect<int> digit_rect;
    label_rect.Set(0, 0xA6, 0x3A, 0x12);
    digit_rect.Set(0, 0xEE, 0xC, 0x12);
    pen->Begin(MG_PRIM_SPRITE);
    pen->Texture(tex);
    pen->Color(0x80, 0x80, 0x80, 0x80);
    PrimQuad(pen, fx + ptbl_2495[lang][5], 24.0f + fy, label_rect);
    bx = (int) (fx + ptbl_2495[lang][0]);
    by = (int) (22.0f + fy);
    Menu3DivideTextureDraw(pen, mgRect<int>(bx, by, ptbl_2495[lang][1], u_brdtbl_2493[3]),
                           u_brdtbl_2493, 1);
    int name_y = (int) (22.0f + fy);
    {
        s8 sex = breed->sex;
        PrimQuad(pen, fx + ptbl_2495[lang][2], 24.0f + fy,
                 mgRect<int>(0, offtbl_2496[sex] + 0xCA, ptbl_2495[lang][3 + sex], 0x12));
    }
    cx = 0x16;
    cy = 0x2C;
    for (int i = 0; i < 6; i++) {
        bx = (int) (fx + cx);
        by = (int) (fy + cy);
        Menu3DivideTextureDraw(pen, mgRect<int>(bx, by, 0x5C, u_brdtbl_2493[3]), u_brdtbl_2493, 1);
        if (i == 0) {
            u8 *kind = chrtbl_2503[lang][breed->kind];

            PrimQuad(pen, bx + 8, by + 2, mgRect<int>(kind[0], kind[1], 0x4C, 0x12));
        } else {
            aqua_param_icon *icon = &get_paraxtbl_2494[lang][i];

            PrimQuad(pen, bx + 2, by + 2, mgRect<int>(icon->x, icon->y, icon->w, 0x12));
            PrimDrawNumber(pen, params[i], 0, bx + 0x56, by + 3, digit_rect, -2, 0);
        }
        cx += 0x5C;
        if (i == 2) {
            cx = 0x16;
            cy += 0x16;
        }
    }
    cx = 0x16;
    cy += 0x16;
    bx = (int) (fx + cx);
    by = (int) (fy + cy);
    Menu3DivideTextureDraw(pen, mgRect<int>(bx, by, 0x8A, u_brdtbl_2493[3]), u_brdtbl_2493, 1);
    PrimQuad(pen, bx + 2, by + 2, mgRect<int>(0x78, 0xEE, 0x82, 0x12));
    int size_high = breed->size / 10;
    int size_low = breed->size % 10;
    PrimDrawNumber(pen, size_high, 0, bx + 0x5A, by + 2, digit_rect, -1, 0);
    PrimDrawNumber(pen, size_low, 0, bx + 0x6A, by + 2, digit_rect, 0, 0);
    cx += 0x8A;
    bx = (int) (fx + cx);
    by = (int) (fy + cy);
    int wy = by + 2;
    Menu3DivideTextureDraw(pen, mgRect<int>(bx, by, 0x8A, u_brdtbl_2493[3]), u_brdtbl_2493, 1);
    PrimQuad(pen, bx + 0x78, wy,
             mgRect<int>(get_paraxtbl_2494[lang][8].x, get_paraxtbl_2494[lang][8].y, get_paraxtbl_2494[lang][8].w, 0x12));
    bx = (int) (2.0f + (fx + cx));
    PrimQuad(pen, bx, wy,
             mgRect<int>(get_paraxtbl_2494[lang][7].x, get_paraxtbl_2494[lang][7].y, get_paraxtbl_2494[lang][7].w, 0x12));
    if (data->data.fish.flags & BREEDFISH_FLAG_RAISED) {
        PrimDrawNumber(pen, breed->weight, 0, (int) (138.0f + (fx + cx) - 18.0f - 2.0f), wy, digit_rect, -1, 0);
    } else {
        aqua_param_icon *unknown = &get_paraxtbl_2494[lang][9];
        bx = (int) (69.0f + (fx + cx) - 2.0f);
        PrimQuad(pen, bx, wy, mgRect<int>(unknown->x, unknown->y, unknown->w, 0x12));
        PrimQuad(pen, bx + 0xE, wy, mgRect<int>(unknown->x, unknown->y, unknown->w, 0x12));
        PrimQuad(pen, bx + 0x1C, wy, mgRect<int>(unknown->x, unknown->y, unknown->w, 0x12));
    }
    pen->End();
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    name_x = (int) (fx + poffset_2511[lang]);
    if (LanguageCode >= LANG_FRENCH && LanguageCode < LANG_CHINESE) {
        name_y = (int) (24.0f + fy);
    }
    CMenuFont font;
    if (breed->flags & BREEDFISH_FLAG_ELECTRIC) {
        font.SetColor(0x803CA0A8);
    }
    font.DrawDirect(data->GetName(1), name_x, name_y);
}

CAquarium::CAquarium() {
    int i;

    for (i = 0; i < 13; i++) {
        tex_block[i] = -1;
    }

    Clear();
}

void CAquarium::Clear() {
    int i;
    mode = AQUARIUM_MODE_VIEW;
    aqua_stack.stack_used = 0;
    aqua_stack.lock = 0;
    ground_frame = 0;
    glass_frame = 0;
    aqua_frame = 0;
    mizu_frame = 0;
    ground_tex_block = -1;
    glass_tex_block = -1;
    aqua_tex_block = -1;
    mes_stack.stack_used = 0;
    mes_stack.lock = 0;
    menu_tex_block = -1;
    suimen_frame = 0;
    water = 0;
    water_tex_block = -1;
    ripple = 0.1f;
    food = NULL;
    food_tex_block = -1;
    unk_326 = 0;
    unk_386 = -1;
    drop_root_draw = 0;
    naka_stack.stack_used = 0;
    naka_stack.lock = 0;
    naka_frame = 0;
    food_stack.stack_used = 0;
    food_stack.lock = 0;
    MenuDeleteTextureBlock(tex_block);

    for (i = 0; i < 13; i++) {
        tex_block[i] = -1;
    }

    for (i = 0; i < 6; i++) {
        fish_stack[i].stack_used = 0;
        fish_stack[i].lock = 0;
        fish[i] = NULL;
        fish_tex_block[i] = -1;
    }

    sel_fish = 0;
    Aqua_SpSndID = 0;
    sndInitPort(8);
}

void CAquarium::Initialize(mgCMemory *memory, int *blocks) {
    int             i;
    int             gx;
    int             gz;
    int             cell_no;
    float          *xz;
    float          *y;
    aqua_col_point *point;

    user_data = &GetSaveData()->user_data;
    m_aquarium_para = &user_data->aquarium;
    memory->stack_used = 0;
    memory->lock = 0;

    for (i = 0; i < 12; i++) {
        tex_block[i] = blocks[i];
    }

    tex_block[i] = -1;
    MenuDeleteTextureBlock(tex_block);
    aqua_tex_block = tex_block[0];
    ground_tex_block = tex_block[1];
    glass_tex_block = tex_block[1];
    water_tex_block = tex_block[1];
    menu_tex_block = tex_block[2];
    food_tex_block = tex_block[3];
    unk_386 = tex_block[4];
    fish_tex_block[0] = tex_block[5];
    fish_tex_block[1] = tex_block[6];
    fish_tex_block[2] = tex_block[7];
    fish_tex_block[3] = tex_block[8];
    fish_tex_block[4] = tex_block[9];
    fish_tex_block[5] = tex_block[10];
    Aquarium_NameregistBlock = &tex_block[5];
    food_time = 0;
    MenuMainTextureReadBuf.stack_used = 0;
    MenuMainTextureReadBuf.lock = 0;
    mgCMemory sound_stack;
    sound_stack.stSetBuffer(MenuMainTextureReadBuf.stGetTop(), 0x80);
    MenuMainTextureReadBuf.Alloc(0x80);
    mes_stack.stSetBuffer(MenuMainTextureReadBuf.stGetTop(), 0x4650);
    MenuMainTextureReadBuf.Alloc(0x4650);
    MenuMainTextureReadBuf.Align64();
    naka_stack.stSetBuffer(MenuMainTextureReadBuf.stGetTop(), 0x1E00);
    MenuMainTextureReadBuf.Alloc(0x1E00);

    for (i = 0; i < 6; i++) {
        AquaFishEff[i] = new (MenuMainTextureReadBuf.Alloc(sizeof(CAquaFishEff) / 16 + 2)) CAquaFishEff;
        AquaFishEff[i]->Initialize();
    }

    float origin[4] = {0.0f, 0.0f, 0.0f, 1.0f};

    for (int no = 0; no < 6; no++) {
        AquaFishBubble[no] = new (MenuMainTextureReadBuf.Alloc(sizeof(CBubble) / 16 + 2)) CBubble;
        AquaFishBubble[no]->Initialize(&MenuMainTextureReadBuf, origin, 0x88, 47.0f);
        AquaFishBubble[no]->one_shot = 1;
        AquaFishBubble[no]->RunOff();
    }

    aquarium_xz_table = new (MenuMainTextureReadBuf.Alloc(sizeof(float[0x3C][4]) / 16 + 2)) float[0x3C][4];
    aquarium_y_table = new (MenuMainTextureReadBuf.Alloc(sizeof(float[0x3C][4]) / 16 + 2)) float[0x3C][4];
    aquarium_paul_table = new (MenuMainTextureReadBuf.Alloc(sizeof(aqua_grid_cell[0x3C]) / 16 + 2)) aqua_grid_cell[0x3C];

    for (gz = 0; gz < 6; gz++) {
        for (gx = 0; gx < 10; gx++) {
            cell_no = gx + gz * 10;
            xz = aquarium_xz_table[cell_no];
            xz[0] = 3.1f + (-31.0f + 6.2f * gx);
            xz[2] = 3.0f + (-18.0f + 6.0f * gz);
            xz[1] = 33.8f;
            xz[3] = 1.0f;
            y = aquarium_xz_table[cell_no];
            y[0] = 23.150002f;
            y[1] = 30.25f;
            y[2] = 37.350002f;
            y[3] = 44.45f;
            point = ColChkPoint;

            for (int col_no = 0; col_no < 9; col_no++, point++) {
                if (mgDistVectorXZ(point->pos, xz) < 7.7f) {
                    float test[4];
                    float dir[4];
                    float height;
                    float step;

                    test[0] = xz[0];
                    test[2] = xz[2];
                    test[3] = 1.0f;

                    for (int k = 0; k < 2; k++) {
                        test[1] = y[k];
                        sceVu0SubVector(dir, test, point->pos);
                        sceVu0Normalize(dir, dir);
                        float dist = mgDistVector(point->pos, test);
                        height = dist * dir[1];
                        step = (28.4f - height - 3.55f) / 3.0f;
                    }

                    y[0] = 19.6f + height + 0.75f * step - 0.5f * step;
                    y[1] = 19.6f + height + 1.5f * step - 0.5f * step;
                }
            }

            aquarium_paul_table[cell_no].xz = xz;
            aquarium_paul_table[cell_no].y = aquarium_y_table[cell_no];
        }
    }

    memory->Align64();
    load_buf = memory->stGetTop();
    load_stack.stSetBuffer(memory->stGetTop(), 0x10CC);
    Aquarium_NameregistStack.stSetBuffer(memory->stGetTop(), 0x129A8);
    m_aquarium_limmit_adr = memory->stGetTop() + memory->stack_size;
    Aqua_SpSndBattleCount = 0;

    if (LoadFile2("snd2/sp/SP_004.snd", load_buf, NULL, 0) != 0) {
        sndInitPort(8);
        Aqua_SpSndID = sndLoadSound(8, (unsigned int *) load_buf, &sound_stack);
        MenuSePlay(Aqua_SpSndID, 0);
        MenuSePlayUsedFlag = 1;
    }

    mgCTextureManager *textures = &mgTexManager;
    u8                *image;
    mes_stack.Align64();
    image = (u8 *) mes_stack.stAllocTest(1);
    char path[0x4C];
    int  size;
    sprintf(path, "menu/aqua/amenu%d.img", LanguageCode);

    if (LoadFile2(path, image, &size, 0) != 0) {
        mes_stack.Alloc(size / 16 + 1);
        textures->EnterIMGFile(image, menu_tex_block, NULL, NULL);
        Tex_Aqualium = textures->GetTexture("amenu0", -1);
        Tex_FishEffect = textures->GetTexture("fisheff", -1);
    }

    mes.Initialize(&mes_stack);
    mes.title_draw = 1;
    mes.help_draw = 1;
    love_phase = AQUA_EVENT_NONE;
    love_time = 0;
    SettingAqua();
}

int CAquarium::LoadFish(int no, CGameDataUsed *data) {
    char            path[0x100];
    float           pos[4];
    float           rot[4];
    int             size;
    int             aqua_no;
    BREEDFISH_USED *breed;
    CAquaFish      *aqua_fish;
    mgCMemory      *stack;
    CAquaFishEff   *effect;
    mgCFrame       *frame;
    float           center_z;

    if (data == NULL) {
        return 0;
    }

    if (GetFishPath(data->item_no, path) != 0) {
        return 0;
    }

    aqua_no = m_aquarium_para->active_tank;
    breed = &data->data.fish;

    if (data->data.fish.flags & 2) {
        strcpy(path, "menu/aqua/fish/f20a.chr");
    }

    if (LoadFile2(path, load_buf, &size, 0) != 0) {
        fish_stack[no].stack_used = 0;
        fish_stack[no].lock = 0;
        stack = &fish_stack[no];
        fish[no] = new (stack->Alloc(sizeof(CAquaFish) / 16 + 2)) CAquaFish;
        aqua_fish = fish[no];

        if (aqua_fish != NULL) {
            aqua_fish->Initialize();
            aqua_fish->aqua_no = no;
            aqua_fish->LoadPack((unsigned int *) load_buf, "info.cfg", stack, stack, stack, fish_tex_block[no], NULL);
            FishIMGReplace(load_buf, aqua_fish, data->item_no, breed);
            pos[0] = GetRandF(62.0f) - 31.0f;
            pos[1] = 20.0f + GetRandF(27.0f);
            pos[2] = GetRandF(36.0f) - 18.0f;

            if (aqua_no == 1) {
                pos[2] = GetRandF(36.0f) - 9.0f;
            }

            if (aqua_no == 2) {
                pos[1] = 20.0f + GetRandF(30.0f);
            }

            aqua_fish->SetLiveParam(data);
            rot[0] = 0.0f;
            rot[1] = GetRandF(6.2831855f) - 3.1415927f;
            rot[2] = 0.0f;
            aqua_fish->SetPosition(pos);
            aqua_fish->SetRotation(rot);
            *(u_long128 *) aqua_fish->target_rot = *(u_long128 *) rot;
            aqua_fish->SetAdjustScale();
            center_z = aqua_fish->body_height / 6.0f;
            frame = aqua_fish->GetFrame();
            frame->trans_matrix[3][0] = 0.0f;
            frame->trans_matrix[3][1] = 0.0f;
            frame->trans_matrix[3][2] = center_z;
            frame->changed = 1;
            aqua_fish->action.Initialize();
            aqua_fish->action.Initialize();
            aqua_fish->action.Initialize();
            AquaFishEff[no]->fish = fish[no];
            AquaFishEff[no]->texture = Tex_FishEffect;
            effect = AquaFishEff[no];
            effect->type = 0;
            effect->timer = -1;
        }

        return 1;
    }

    return 0;
}

#ifdef NONMATCHING
void CAquarium::SettingAqua() {
    int                fish_num = aquarium_fish_maxtbl[m_aquarium_para->active_tank];
    int                aqua_no = m_aquarium_para->active_tank;
    mgCTextureManager *textures = &mgTexManager;
    int                i;
    int                size;
    u_int             *file;
    u8                *image;
    mgCMemory          bubble_stack;
    char               path[0x40];
    aqua_quad          water_min;
    aqua_quad          water_max;
    CGameDataUsed     *fish_data[6];
    NEXT_THINK_PARAM   param;
    aqua_quad          pos;

    int rest = MenuMainTextureReadBuf.stGetRest();
    bubble_stack.stSetBuffer(MenuMainTextureReadBuf.stGetTop(), rest);
    float (*generate_pos)[4] = aqua_bubble_generate_pos[aqua_no];
    aqua_bubble_counts counts;
    counts = at_2935;

    for (i = 0; i < 3; i++) {
        AquaBubble[i] = new ((u_long128 *) bubble_stack.Alloc(sizeof(CBubble) / 16 + 2)) CBubble;
        AquaBubble[i]->Initialize(&bubble_stack, generate_pos[i], counts.num[i], 47.0f);
    }

    for (int i = 0; i < 6; i++) {
        if (AquaFishBubble[i] != NULL) {
            AquaFishBubble[i]->RunOff();
            AquaFishBubble[i]->generated = 0;
        }
    }

    AquaBattleBubble_Generate_Wait = 0;
    AquaBattleBubble_Generate_Counter = 0;
    AquaBattleBubble = NULL;
    u_long128 *frame_top = m_aquarium_limmit_adr - aqua_frame_sizetbl_2934[aqua_no];
    aqua_stack.stSetBuffer(frame_top, aqua_frame_sizetbl_2934[aqua_no]);

    for (int i = 0; i < fish_num; i++) {
        fish_stack[i].stSetBuffer(aqua_stack.stGetTop() - (i + 1) * 0x319C, 0x319C);
    }

    sprintf(path, at_3150, aqua_no);

    if (LoadFile2(path, load_buf, NULL, 0) == 0) {
        return;
    }

    textures->DeleteBlock(aqua_tex_block);
    textures->DeleteBlock(ground_tex_block);
    aqua_stack.stack_used = 0;
    aqua_stack.lock = 0;
    file = GetPackFile((u_int *) load_buf, at_3151, &size);

    if (file != NULL) {
        image = (u8 *) aqua_stack.Alloc(size / 16 + 1);
        memcpy(image, file, size);
        textures->EnterIMGFile(image, aqua_tex_block, &aqua_stack, NULL);
    }

    file = GetPackFile((u_int *) load_buf, at_3152, &size);

    if (file != NULL) {
        aqua_frame = mgLoadMDSFile((MDS_HEADER *) file, &aqua_stack, NULL, NULL);
    }

    file = GetPackFile((u_int *) load_buf, at_3153, &size);

    if (file != NULL) {
        image = (u8 *) aqua_stack.Alloc(size / 16 + 1);
        memcpy(image, file, size);
        textures->EnterIMGFile(image, ground_tex_block, NULL, NULL);
    }

    file = GetPackFile((u_int *) load_buf, at_3154, &size);

    if (file != NULL) {
        ground_frame = mgLoadMDSFile((MDS_HEADER *) file, &aqua_stack, NULL, NULL);
    }

    file = GetPackFile((u_int *) load_buf, at_3155, &size);

    if (file != NULL) {
        image = (u8 *) aqua_stack.Alloc(size / 16 + 1);
        memcpy(image, file, size);
        textures->EnterIMGFile(image, glass_tex_block, NULL, NULL);
    }

    file = GetPackFile((u_int *) load_buf, at_3156, &size);

    if (file != NULL) {
        glass_frame = mgLoadMDSFile((MDS_HEADER *) file, &aqua_stack, NULL, NULL);
    }

    strcpy(textures->name_suffix, at_3157);
    file = GetPackFile((u_int *) load_buf, at_3158__2, &size);

    if (file != NULL) {
        image = (u8 *) aqua_stack.Alloc(size / 16 + 1);
        memcpy(image, file, size);
        textures->EnterIMGFile(image, water_tex_block, NULL, NULL);
    }

    file = GetPackFile((u_int *) load_buf, at_3159__2, &size);

    if (file != NULL) {
        mizu_frame = mgLoadMDSFile((MDS_HEADER *) file, &aqua_stack, NULL, NULL);
    }

    file = GetPackFile((u_int *) load_buf, at_3160__2, &size);

    if (file != NULL) {
        suimen_frame = mgLoadMDSFile((MDS_HEADER *) file, &aqua_stack, NULL, NULL);
        suimen_frame->SetPosition(0.0f, 0.0f, 0.0f);
        suimen_frame->SetScale(0.99f, 1.0f, 1.0f);
    }

    file = GetPackFile((u_int *) load_buf, at_3161__2, &size);

    if (file != NULL) {
        image = (u8 *) aqua_stack.Alloc(size / 16 + 1);
        memcpy(image, file, size);
        textures->EnterIMGFile(image, water_tex_block, NULL, NULL);
    }

    textures->name_suffix[0] = 0;
    mgCTexture *screen = textures->EnterTexture(water_tex_block, "AQUA_WATER_WORK", NULL, mgScreenWidth, mgScreenHeight, 0x20, NULL, 0, 0);
    water_min = at_2975;
    water_max = at_2976;
    water = CreateWaterFrame(24, 16, water_min.v, water_max.v, &aqua_stack);

    if (water != NULL) {
        water->SetTexture(screen);
        float water_x = -34.0f;
        water->SetPosition(water_x, 47.0f, -21.5f);
    }

    naka_stack.stack_used = 0;
    naka_stack.lock = 0;
    naka_frame = NULL;

    if (aqua_no == 0 && LoadFile2(at_3163__2, load_buf, &size, 0) != 0) {
        naka_frame = mgLoadMDSFile((MDS_HEADER *) load_buf, &naka_stack, NULL, NULL);
    }

    CFishAquarium *aquarium = m_aquarium_para;

    for (i = 0; i < 6; i++) {
        fish_data[i] = NULL;
        fish[i] = NULL;
        fish_stack[i].stack_used = 0;
        fish_stack[i].lock = 0;
        AquaFishEff[i]->fish = NULL;
        textures->DeleteBlock(fish_tex_block[i]);
    }

    int            live_num = 0;
    CGameDataUsed *tank = aquarium->GetAquariumFishTop(aqua_no);

    for (int i = 0; i < fish_num; i++) {
        fish_data[i] = &tank[i];

        if (fish_data[i]->item_no > 0) {
            fish_data[i]->CheckParamLimmit();
            live_num++;
        }
    }

    for (i = 0; i < fish_num; i++) {
        if (fish_data[i] != NULL && LoadFish(i, fish_data[i]) != 0) {
            int think = AQUA_FISH_THINK_REST;

            if (GetRandI(3) != 0) {
                think = AQUA_FISH_THINK_SWIM;
            }

            if (aqua_no == 1) {
                think = AQUA_FISH_THINK_BATTLE;
                param.target_no = GetBattleTarget(i);
                param.target = NULL;

                if (0 <= param.target_no) {
                    param.target = fish[param.target_no];
                }
            }

            if (aqua_no == 2) {
                think = AQUA_FISH_THINK_LOVE_SEARCH;
                fish[i]->action.Initialize();
            }

            if (live_num == 1) {
                think = AQUA_FISH_THINK_REST;
            }

            fish[i]->NextThink(think, &param);
        }
    }

    if (aqua_no == 2) {
        pos = at_3016;

        if (fish[0] != NULL) {
            pos.v[0] += GetRandF(6.0f);
            pos.v[1] += GetRandF(2.0f);
            pos.v[2] += 2.0f + GetRandF(6.0f);
            fish[0]->SetPosition(pos.v);
        }

        if (fish[1] != NULL) {
            pos.v[0] += GetRandF(6.0f) - 20.0f;
            pos.v[1] += GetRandF(2.0f);
            pos.v[2] += 2.0f + GetRandF(6.0f);
            fish[1]->SetPosition(pos.v);
        }
    }

    love_tex_block = -1;
    love_chara = NULL;
    int love_size;

    if (aqua_no == 2 && LoadFile2(at_3164__3, load_buf, &love_size, 0) != 0) {
        mgCMemory love_stack;
        love_stack.stSetBuffer(fish_stack[1].stack - 0x3980, 0x3980);
        love_tex_block = fish_tex_block[2];
        textures->DeleteBlock(love_tex_block);
        CCharacter2 *chara;

        chara = new ((u_long128 *) love_stack.Alloc(sizeof(CCharacter2) / 16 + 2)) CCharacter2;

        love_chara = chara;
        love_chara->Initialize();
        love_chara->LoadPack((unsigned int *) load_buf, "info.cfg", &love_stack, &love_stack, &love_stack, love_tex_block, NULL);
        love_chara->SetPosition(0.0f, -66.0f, 0.0f);
        mgCFrame *frame = love_chara->GetFrame();

        if (frame->attr != NULL) {
            mgCFrameAttr *attr = frame->attr;

            attr->z_write = 1;
            frame->attr = attr;
        }
    }

    u_long128 *food_top = load_stack.stGetTop() + load_stack.stack_size;
    food_stack.stSetBuffer(food_top, fish_stack[fish_num - 1].stGetTop() - food_top);
    mes.SettingAquaMes(aqua_no);
    InitSelFish();
    mes.cursor_draw = 0;
    mode = 0;
    mes.help_draw = 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuaqua", SettingAqua__9CAquariumFv);
#endif

int CalcFishParam(BREEDFISH_USED *fish) {
    BREEDFISH_USED *body = fish;
    int             sum;

    if (body == NULL) {
        return 0;
    }

    sum = 0;
    sum += body->param[0];
    sum += body->param[1];
    sum += body->param[2];
    sum += body->param[3];
    sum += body->param[4];
    return sum;
}

/**
 *
 * Combines two inherited fish parameters and caps the result at 100.
 *
 */
static int CombineParam(int a, int b) {
    int result;

    if (a >= b) {
        result = a + b / 7;
    } else {
        result = b + a / 7;
    }

    if (result < 0) {
        result = 0;
    }

    if (result >= 100) {
        result = 100;
    }

    return result;
}

void CAquarium::CombineFish(int no1, int no2) {
    BREEDFISH_USED *child_breed;
    CAquaFish      *fish2;
    CGameDataUsed  *data1;
    int             total1;
    BREEDFISH_USED *breed1;
    CGameDataUsed  *data2;
    int             total2;
    CAquaFish      *fish1;
    BREEDFISH_USED *breed2;
    int             color;
    int             life;
    float           center[4];
    float           pos1[4];
    float           pos2[4];

    if (no1 < 0 || no2 < 0) {
        return;
    }

    fish1 = fish[no1];
    fish2 = fish[no2];
    data1 = fish1->data;
    data2 = fish2->data;
    breed1 = &data1->data.fish;
    breed2 = &data2->data.fish;
    fish1->GetPosition(pos1);
    fish2->GetPosition(pos2);
    sceVu0SubVector(pos2, pos2, pos1);
    center[0] = pos1[0] + 0.5f * pos2[0];
    center[1] = pos1[1] + 0.5f * pos2[1];
    center[2] = pos1[2] + 0.5f * pos2[2];
    CGameDataUsed child;
    child.Init();
    int child_no = GetChildFishNo(data1->item_no, data2->item_no);
    life = breed1->life;

    if (life < breed2->life) {
        life = breed2->life;
    }

    life += 20;

    if (life < 0) {
        life = 0;
    }

    child.CopyDataFish(child_no);
    child_breed = &child.data.fish;
    child_breed->sex = GetRandI(2);
    child_breed->unk_1c = 0;
    child_breed->hp = 100;
    child_breed->fatigue = 0;
    child_breed->size = breed1->size / 2 + breed2->size / 2;
    child_breed->weight = child_breed->size * (4.0f + GetRandF(2.0f));
    child_breed->param[0] = CombineParam(breed1->param[0], breed2->param[0]);
    child_breed->param[1] = CombineParam(breed1->param[1], breed2->param[1]);
    child_breed->param[2] = CombineParam(breed1->param[2], breed2->param[2]);
    child_breed->param[3] = CombineParam(breed1->param[3], breed2->param[3]);
    child_breed->param[4] = CombineParam(breed1->param[4], breed2->param[4]);
    child_breed->life = life;

    if (child_breed->life > 250) {
        child_breed->life = 250;
    }

    child_breed->breed_feeds_remaining = 5;
    child_breed->flags = 0;
    child_breed->flags |= 1;
    child_breed->kind = breed1->kind;
    total1 = CalcFishParam(breed1);
    total2 = CalcFishParam(breed2);
    int parent_color[2];
    parent_color[0] = 0;
    parent_color[1] = 0;
    parent_color[0] = breed1->color;

    if (breed1->color == 0) {
        parent_color[0] = GetFishImageColor(data1->item_no, 0);
    }

    parent_color[1] = breed2->color;

    if (breed2->color == 0) {
        parent_color[1] = GetFishImageColor(data2->item_no, 0);
    }

    if (total1 < total2) {
        color = parent_color[1];
    } else if (total2 < total1) {
        color = parent_color[0];
    } else {
        color = parent_color[GetRandI(2)];
    }

    if (color == GetFishImageColor(child.item_no, 0)) {
        color = 0;
    }

    child_breed->color = color;
    data1->CopyGameData(&child);
    data1->CheckParamLimmit();

    if (LoadFish(no1, data1) != 0) {
        float rot[4];

        fish[no1]->SetPosition(center);
        rot[0] = 0.0f;
        rot[1] = GetRandF(6.2831855f) - 3.1415927f;
        rot[2] = 0.0f;
        fish[no1]->SetRotation(rot);
        fish[no1]->think_mode = AQUA_FISH_THINK_REST;
    }

    AquaFishEff[no1]->Initialize();
    AquaFishEff[no2]->Initialize();
    fish[no2]->Initialize();
    fish[no2] = NULL;
}

int CAquarium::GetBattleTarget(int slot) {
    int round;
    int i;

    for (round = 0; round < 3; round++) {
        for (i = 0; i < 6; i++) {
            if (i != slot && fish[i] != NULL && GetRandI(3) == 0) {
                return i;
            }
        }
    }

    return -1;
}

struct AQUA_FISH_ROUTE_VIEW {
    CAquaFishActionParam action;
    AQUA_FISH_ROUND      round;
    sceVu0FVECTOR        route[32];
    s16                  route_num;
    s16                  route_no;
    s32                  route_time;
};

void CAquarium::Thinking(int no) {
    int              next;
    BREEDFISH_USED  *breed;
    int              food_state;
    CAquaFish       *me;
    float            food_pos[4];
    NEXT_THINK_PARAM param;
    CGameDataUsed   *data;
    CAquaFishEff    *effect;

    if (fish[no] == NULL) {
        return;
    }

    food_state = -1;

    if (food != NULL) {
        food_state = food->state;
        food->GetPosition(food_pos);
    }

    effect = AquaFishEff[no];
    param.effect = effect;
    me = fish[no];
    data = me->data;
    next = -1;
    breed = data == NULL ? NULL : &data->data.fish;

    if (data == NULL || breed == NULL) {
        return;
    }

    if (food_state == FISH_FOOD_ENTER) {
        param.pos[0] = food_pos[0];
        param.pos[1] = food_pos[1];
        param.pos[2] = food_pos[2];
        next = AQUA_FISH_THINK_FOOD_LOOK;

        if (breed->timer < GetRandI(300) + 1000) {
            next = AQUA_FISH_THINK_FOOD_EAT;
        }
    }

    switch (me->think_mode) {
        case AQUA_FISH_THINK_REST:
            sceVu0ScaleVectorXYZ(me->move, me->move, me->action.decel);
            me->action.timer--;

            if (me->action.timer <= 0) {
                next = AQUA_FISH_THINK_SWIM;
            }

            data->AddFishHp(1);
            break;
        case AQUA_FISH_THINK_SWIM:
            if (me->swim_mode == AQUA_FISH_SWIM_POINT) {
                float       pos[4];
                float       speed;
                float       rot[4];
                aqua_vector dir;
                aqua_vector steer;

                me->GetPosition(pos);
                me->GetRotation(rot);
                mgDistVector(pos, me->target_pos);
                dir = at_3290;
                steer = at_3291__3;

                if (pos[0] < -21.699999f) {
                    steer.v[0] += 0.034f;
                } else if (21.699999f < pos[0]) {
                    steer.v[0] -= 0.034f;
                } else {
                    steer.v[0] += me->move[0];
                }

                if (pos[2] < -10.8f) {
                    steer.v[2] += 0.032f;
                } else if (10.8f < pos[2]) {
                    steer.v[2] -= 0.032f;
                } else {
                    steer.v[2] += me->move[2];
                }

                steer.v[1] = GetRandF(0.04f) - 0.02f;

                if (me->col_flags & AQUA_FISH_COL_OBJECT) {
                    steer.v[1] += 0.03f + GetRandF(0.1f);
                }

                sceVu0Normalize(steer.v, steer.v);
                speed = mgDistVector(me->move);
                sceVu0AddVector(me->move, me->move, steer.v);
                sceVu0ScaleVectorXYZ(me->move, me->move, speed / mgDistVector(me->move));
                sceVu0Normalize(dir.v, me->move);
                me->target_rot[1] = mgAngleLimit(atan2f(dir.v[0], dir.v[2]));
            }

            if (me->swim_mode == AQUA_FISH_SWIM_ROUND) {
                me->MoveActionRound();
            }

            if (me->swim_mode == AQUA_FISH_SWIM_ROUTE) {
                float       pos[4];
                float       rot[4];
                aqua_vector dir;
                float       dist;
                aqua_vector steer;
                float       speed;
                float       ahead[4];

                me->GetPosition(pos);
                me->GetRotation(rot);
                dist = mgDistVectorXZ(pos, me->target_pos);
                dir = at_3310;
                steer = at_3311;
                AQUA_FISH_ROUTE_VIEW *r = (AQUA_FISH_ROUTE_VIEW *) &me->action;

                if (dist < 2.0f || r->route_time > 20) {
                    r->route_no++;
                    r->route_time = 0;

                    if (r->route_num - 3 <= r->route_no) {
                        r->route_no = 0;
                        me->NextRootNormal();
                    }

                    *(u_long128 *) me->target_pos = *(u_long128 *) r->route[r->route_no];
                    sceVu0SubVector(steer.v, me->target_pos, pos);
                }

                r->route_time++;
                sceVu0CopyVector(ahead, r->route[r->route_no + 2]);
                sceVu0SubVector(steer.v, ahead, pos);
                sceVu0Normalize(steer.v, steer.v);
                sceVu0ScaleVectorXYZ(steer.v, steer.v, 1.1f);
                speed = mgDistVector(me->move);
                sceVu0AddVector(me->move, me->move, steer.v);
                sceVu0ScaleVectorXYZ(me->move, me->move, speed / mgDistVector(me->move));
                me->GetPosition(pos);
                sceVu0SubVector(dir.v, me->target_pos, pos);
                sceVu0Normalize(dir.v, dir.v);
                me->target_rot[1] = mgAngleLimit(atan2f(dir.v[0], dir.v[2]));
            }

            if (GetRandI(200) < 2) {
                data->AddFishHp(1);
            }

            me->think_timer++;

            if (me->think_timer >= 500) {
                if (GetRandI(101) < 90) {
                    next = AQUA_FISH_THINK_SWIM;
                } else {
                    next = AQUA_FISH_THINK_REST;
                }
            }

            break;
        case AQUA_FISH_THINK_FOOD_LOOK: {
            float pos[4];

            me->GetPosition(pos);
            *(u_long128 *) me->target_pos = *(u_long128 *) food_pos;
            sceVu0ScaleVectorXYZ(me->move, me->move, me->action.decel);
            me->NormalGetNextRot();
            me->action.timer--;

            if (me->action.timer <= 0) {
                me->think_mode = AQUA_FISH_THINK_SWIM;
            }

            break;
        }
        case AQUA_FISH_THINK_FOOD_EAT:
            if (food_state == FISH_FOOD_SINK) {
                *(u_long128 *) me->target_pos = *(u_long128 *) food_pos;
                me->NormalGetNextVelo(0.2f * (0.5f + 0.05f * breed->param[0]));
                me->NormalGetNextRot();
                me->turn[1] = 14.0f;
                me->turn[0] = 0.052359879f;
            } else {
                if (fptosi(GetRandF(101.0f)) < 70) {
                    me->target_rot[0] = 0.0f;
                    next = AQUA_FISH_THINK_SWIM;
                } else {
                    me->target_rot[0] = 0.0f;
                    next = AQUA_FISH_THINK_REST;
                }

                me->target_rot[0] = 0.0f;
            }

            break;
        case AQUA_FISH_THINK_BATTLE:
            me->MoveActionBattle();

            if (me->think_timer < 0) {
                me->action.hit_count = 0;
                me->action.phase = 0;
                next = AQUA_FISH_THINK_BATTLE_REST;
                effect->type = 0;
                effect->timer = -1;
            } else if (me->fatigue_max <= me->AddFatigue(0)) {
                next = AQUA_FISH_THINK_BATTLE_REST;
                me->swim_mode = AQUA_FISH_SWIM_ROUTE;
                me->think_timer = 0;
                me->action.phase = 0;
                effect->type = 0;
                effect->timer = -1;
            }

            if (GetRandI(100) < 15) {
                if (data->AddFishHp(0) < GetRandI(8) + 10) {
                    next = AQUA_FISH_THINK_BATTLE_REST;
                    me->swim_mode = AQUA_FISH_SWIM_ROUTE;
                    me->think_timer = 0;
                    me->action.phase = 0;
                    effect->type = 0;
                    effect->timer = -1;
                }
            }

            break;
        case AQUA_FISH_THINK_BATTLE_REST: {
            bool rested = false;

            if (me->action.phase == 3) {
                float pos[4];
                float dist;

                me->GetPosition(pos);
                dist = mgDistVector(me->target_pos, pos);
                me->NormalGetNextVelo(me->CalcMoveSpeed(0.12f));
                me->NormalGetNextRot();
                data->AddFishHp(1);
                me->AddFatigue(-1);
                me->think_timer--;

                if (me->think_timer <= 0) {
                    me->think_timer = 0;
                }

                if (dist < 3.4f && !(me->col_flags & AQUA_FISH_COL_FISH)) {
                    me->action.phase = 4;
                    me->SetStep(0.5f);
                }
            } else if (me->action.phase == 4) {
                me->AddFatigue(-4);
                data->AddFishHp(2);
                mgZeroVector(me->move);

                if (me->col_flags & AQUA_FISH_COL_TARGET) {
                    me->think_mode = AQUA_FISH_THINK_BATTLE_REST;
                }

                if (me->fatigue <= me->fatigue_max >> 2) {
                    rested = true;
                }
            } else if (GetRandI(300) < 8) {
                data->AddFishHp(1);
            }

            me->think_timer--;

            if (rested || me->think_timer <= 0) {
                next = AQUA_FISH_THINK_BATTLE;
                param.target_no = GetBattleTarget(no);
                param.target = NULL;

                if (0 <= param.target_no) {
                    param.target = fish[param.target_no];
                }

                me->think_timer = 0;
                me->turn[1] = 28.0f;
                me->action.phase = 0;
            }

            break;
        }
        case AQUA_FISH_THINK_LOVE_SEARCH:
            if (0 < breed->breed_feeds_remaining) {
                me->pair_no = -1;
                me->think_mode = AQUA_FISH_THINK_SWIM;
                me->think_timer = 0;
            } else {
                me->pair_no = GetBattleTarget(no);

                if (me->pair_no < 0) {
                    me->think_mode = AQUA_FISH_THINK_LOVE_SEARCH;
                    me->think_timer = 0;
                } else {
                    me->SetMotion("\x83\x6f\x83\x67\x83\x8b\x81\x69\x8c\xb3\x8b\x43\x81\x6a", 0);
                    me->think_mode = AQUA_FISH_THINK_LOVE_CHASE;
                    me->think_timer = GetRandI(101) + 140;
                    effect->StartFishEffect(1);
                }
            }

            break;
        case AQUA_FISH_THINK_LOVE_CHASE: {
            CAquaFish *partner = fish[me->pair_no];
            float      gap[4];
            float      pos[4];
            float      partner_pos[4];
            float      love_pos[4];

            if (partner != NULL) {
                float          speed;
                CGameDataUsed *partner_data;

                partner->GetPosition(partner_pos);
                me->GetPosition(pos);
                *(u_long128 *) me->target_pos = *(u_long128 *) partner_pos;
                sceVu0SubVector(gap, partner_pos, pos);
                float dist = mgDistVector(partner_pos, pos);
                speed = 0.04f;

                if (12.0f < dist) {
                    speed = 0.13f;
                }

                me->NormalGetNextVelo(me->CalcMoveSpeed(speed));
                me->NormalGetNextRot();
                me->think_timer--;

                if (me->think_timer < 0) {
                    me->think_mode = AQUA_FISH_THINK_LOVE_SEARCH;
                    me->think_timer = 0;
                }

                partner_data = partner->data;

                if ((partner_data != NULL && 0 < partner_data->data.fish.breed_feeds_remaining) || 0 < breed->breed_feeds_remaining) {
                    me->action.hit_count = 0;
                }
            }

            if (love_phase == AQUA_EVENT_NONE && me->action.hit_count > 0xA0) {
                if ((u32) (AquaMode - AQUA_MENU_CLOSE_FADE_WAIT) > 1 && AquaMode != AQUA_MENU_TANK_FADE_OUT_WAIT && AquaMode != AQUA_MENU_RENAME_FADE_OUT_WAIT && love_chara != NULL) {
                    effect->type = 0;
                    effect->timer = -1;
                    sceVu0ScaleVectorXYZ(gap, gap, 0.5f);
                    sceVu0AddVector(love_pos, pos, gap);
                    love_phase = AQUA_EVENT_BREED_EFFECT_WAIT;
                    love_time = 0;
                    sndSePlay(Aqua_SpSndID, 2, 0);
                    love_chara->SetPosition(love_pos);
                    love_chara->SetMotion("\x94\x7a\x8d\x87", 6);
                    love_chara->SetScale(1.5f, 1.5f, 1.5f);
                    love_chara->Step();
                    target_fish = no;
                    partner_fish = me->pair_no;
                }
            }

            break;
        }
    }

    me->NextThink(next, &param);
}

int CAquarium::ColCheck(int no) {
    aqua_col_point       *point;
    int                   i;
    CAquaFishActionParam *action;
    int                   calm;
    int                   result;
    int                   num;
    int                   aqua_no;
    float                 dist;
    CAquaFish            *me;
    float                 radius;
    float                 pos[4];
    float                 move[4];
    float                 other_pos[4];
    float                 away[4];
    float                 point_away[4];
    float                 food_pos[4];
    float                 rot[4];
    if (fish[no] == NULL) {
        return 0;
    }
    me = fish[no];
    result = 0;
    radius = me->radius;
    radius = 0.29f * radius;
    me->GetPosition(pos);
    sceVu0AddVector(pos, pos, me->move);
    me->col_flags = 0;
    action = NULL;
    if (me->think_mode == AQUA_FISH_THINK_BATTLE) {
        action = &me->action;
    }
    if (me->think_mode == AQUA_FISH_THINK_SWIM) {
        action = &me->action;
    }
    if (me->think_mode == AQUA_FISH_THINK_LOVE_SEARCH || me->think_mode == AQUA_FISH_THINK_LOVE_CHASE) {
        action = &me->action;
    }
    calm = 0;
    if (AquaMode == AQUA_MENU_CLOSE_FADE_WAIT || AquaMode == AQUA_MENU_CLEAR || AquaMode == AQUA_MENU_TANK_FADE_OUT_WAIT || AquaMode == AQUA_MENU_RENAME_FADE_OUT_WAIT) {
        calm = 1;
    }
    for (i = 0; i < 6; i++) {
        if (i != no && fish[i] != NULL) {
            CAquaFish *other = fish[i];
            float      other_radius = other->radius;
            float      reach = radius + 0.26f * other_radius;
            float      dist;

            other->GetPosition(other_pos);
            dist = mgDistVector(pos, other_pos);
            if (dist < reach) {
                sceVu0SubVector(away, pos, other_pos);
                away[3] = 1.0f;
                sceVu0Normalize(away, away);
                reach -= dist;
                move[0] = 0.5f * (me->move[0] + away[0] * reach);
                move[1] = 0.5f * (me->move[1] + away[1] * reach);
                move[2] = 0.5f * (me->move[2] + away[2] * reach);
                move[3] = 1.0f;
                sceVu0ScaleVector(me->move, move, 1.5f);
                if (calm == 0) {
                    if (me->think_mode == AQUA_FISH_THINK_BATTLE || me->think_mode == AQUA_FISH_THINK_LOVE_CHASE) {
                        me->AddFatigue(1);
                        if (action != NULL) {
                            action->hit_count++;
                        }
                    }
                    if (me->think_mode == AQUA_FISH_THINK_BATTLE) {
                        result |= AQUA_FISH_RESULT_BATTLE_HIT;
                        me->data->AddFishHp(-1);
                        if (GetRandI(100) < 8) {
                            action->hit_count += 6;
                        }
                        sceVu0ScaleVector(away, away, 0.5f);
                        sceVu0AddVector(AquaBattleBubble_Pos, pos, away);
                    }
                    me->col_flags |= AQUA_FISH_COL_FISH;
                    if (action != NULL && action->target_no == i) {
                        me->col_flags |= AQUA_FISH_COL_TARGET;
                        if (me->think_mode == AQUA_FISH_THINK_BATTLE && me->action.phase == AQUA_FISH_ACTION_APPROACH) {
                            me->action.phase = AQUA_FISH_ACTION_SWING_START;
                        }
                    }
                }
            }
        }
    }
    aqua_no = m_aquarium_para->active_tank;
    point = ColChkPoint;
    if (aqua_no == AQUARIUM_TANK_SECOND) {
        point = ColChkPoint2;
    }
    if (aqua_no == AQUARIUM_TANK_BREED) {
        point = ColChkPoint3;
    }
    num = ColChkPointNum[aqua_no];
    for (i = 0; i < num; i++, point++) {
        float reach = point->radius + radius;
        dist = mgDistVector(pos, point->pos);

        if (dist < reach) {
            sceVu0SubVector(point_away, pos, point->pos);
            point_away[3] = 1.0f;
            sceVu0Normalize(point_away, point_away);
            reach -= dist;
            move[0] = 0.5f * (me->move[0] + point_away[0] * reach);
            move[1] = 0.5f * (me->move[1] + point_away[1] * reach);
            move[2] = 0.5f * (me->move[2] + point_away[2] * reach);
            move[3] = 1.0f;
            sceVu0ScaleVector(me->move, move, 1.5f);
            me->move[1] *= 1.05f;
            me->col_flags |= AQUA_FISH_COL_OBJECT;
        }
    }
    if (food != NULL && food->state == FISH_FOOD_SINK) {
        float food_size = food->body_width;
        int   eat;

        food->GetPosition(food_pos);
        float dist = mgDistVector(pos, food_pos);
        eat = 0;
        if (dist < radius + 1.06f * food_size) {
            me->col_flags |= AQUA_FISH_COL_FOOD;
            if (me->think_mode == AQUA_FISH_THINK_FOOD_EAT) {
                eat = 1;
            }
        }
        if (eat) {
            CUserDataManager *user;

            me->eat_item = food->item_no;
            user = GetUserDataMan();
            if (user != NULL) {
                user->DeleteItem(me->eat_item, 1);
            }
            food = NULL;
            for (i = 0; i < 6; i++) {
                CAquaFishEff *effect = AquaFishEff[i];

                effect->type = 0;
                effect->timer = -1;
            }
            int pick = GetRandI(2);
            AquaFishEff[no]->StartFishEffect(tbl_3505[pick]);
            if (me->eat_item == 0x168) {
                target_fish = no;
                result |= AQUA_FISH_RESULT_ELECTRIC_FOOD_EATEN;
                strcpy(target_name, me->data->GetName(1));
            }
        }
    }
    sceVu0AddVector(pos, pos, me->move);
    if (local_aquarium_limmit_check(pos, radius, 1, 2.4f) != 0) {
        me->col_flags |= AQUA_FISH_COL_WALL;
    }
    me->GetRotation(rot);
    rot[1] = mgAngleInterpolate(rot[1], me->target_rot[1], 3.1415927f / me->turn[1], 0);
    rot[0] = mgAngleInterpolate(rot[0], me->target_rot[0], me->turn[0], 0);
    if (0.31415927f < rot[0]) {
        rot[0] = 0.31415927f;
    }
    if (rot[0] < -0.31415927f) {
        rot[0] = -0.31415927f;
    }
    me->SetRotation(rot);
    me->SetPosition(pos);
    return result;
}

int CAquarium::InitSelFish() {
    int i;
    sel_fish = -1;
    mes.cursor_draw = 1;

    for (i = 0; i < 6; i++) {
        if (fish[i] != NULL) {
            float x, y;
            sel_fish = i;
            x = (float) mes.menu_mes->cursor_x;
            y = (float) mes.menu_mes->cursor_y;
            mes.cursor_pos[0] = x;
            mes.cursor_target[0] = x;
            mes.cursor_pos[1] = y;
            mes.cursor_target[1] = y;
            mes.cursor_snap = 1;
            SelFishSetCursor();
            return 0;
        }
    }

    mes.cursor_draw = 0;
    return 1;
}

void CAquarium::SelectFish(int force) {
    int step = 0;
    int no;
    int tries;
    int old_fish;

    if (GamePad__2.Down(0x2000)) {
        step++;
    } else if (GamePad__2.Down(0x8000)) {
        step--;
    }

    if (force) {
        step = 1;
    }

    if (step == 0) {
        return;
    }

    old_fish = sel_fish;
    no = old_fish + step;
    tries = 0;

    if (no < 0) {
        no = 5;
    }

    if (no > 5) {
        no = 0;
    }

    while (fish[no] == NULL) {
        no += step;

        if (no > 5) {
            no = 0;
        }

        if (no < 0) {
            no = 5;
        }

        if (++tries > 6) {
            no = -1;
            break;
        }
    }

    if (old_fish != no) {
        MenuSePlay(0);
    }

    sel_fish = no;
}

void CAquarium::SelFishSetCursor() {
    float view[4][4];
    float camera_pos[4];
    float fish_pos[4];
    int   screen_int[4];
    float screen[4];

    if (sel_fish >= 0 && fish[sel_fish] != NULL) {
        Camera__2->GetCameraMatrix(view);
        Camera__2->GetPos(camera_pos);
        mgSetViewMatrix(view, camera_pos);
        ((CAquaFish *) fish[sel_fish])->GetPosition(fish_pos);
        mgTransWorldScreen(screen_int, fish_pos);
        sceVu0ITOF4Vector(screen, screen_int);
        screen[0] -= 50.0f;
        float y = screen[1] - 12.0f;
        screen[1] = y;
        mes.cursor_target[0] = screen[0];
        mes.cursor_target[1] = y;
    }
}

int CAquarium::Step() {
    int       key = 0;
    int       next;
    int       lang;
    int       i;
    int       j;
    CAquaMes *menu;
    int       result;
    float     saved_pos[6][4];
    float     saved_rot[6][4];

    lang = LanguageCode;
    if (lang > LANG_JAPANESE) {
        lang = 1;
    }
    int *keys = langTbl_3630[lang];
    if (GamePad__2.Down(keys[0])) {
        key = MENU_PUSH_BUTTON_DECIDE;
    } else if (GamePad__2.Down(keys[1])) {
        key = MENU_PUSH_BUTTON_CANCEL;
    }
    next = -1;
    /**
     *
     * Keeps the selected fish while its destination tank is chosen.
     *
     */
    static CAquaFish *sel_sift_fish = NULL;
    /**
     *
     * Keeps the selected fish slot while its destination tank is chosen.
     *
     */
    static s16 sel_sift_fish_select;
    menu = &mes;
    if (AQUA_EVENT_NONE < love_phase) {
        switch (love_phase) {
            case AQUA_EVENT_BREED_FADE_OUT:
            case AQUA_EVENT_ELECTRIC_FADE_OUT:
                next = AQUARIUM_MODE_VIEW;
                if (love_phase == AQUA_EVENT_BREED_FADE_OUT) {
                    AquaScene->fade.FadeOut(30, 255.0f, 255.0f, 255.0f);
                }
                if (love_phase == AQUA_EVENT_ELECTRIC_FADE_OUT) {
                    AquaScene->fade.FadeOut(60, 255.0f, 255.0f, 255.0f);
                }
                love_phase++;
                break;
            case AQUA_EVENT_BREED_COMBINE:
            case AQUA_EVENT_ELECTRIC_RELOAD:
                if (AquaScene->fade.FadeCheck() != 0) {
                    if (love_phase == AQUA_EVENT_BREED_COMBINE) {
                        mgTexManager.DeleteBlock(fish_tex_block[0]);
                        mgTexManager.DeleteBlock(fish_tex_block[1]);
                        strcpy(target_name, fish[target_fish]->data->GetName(1));
                        strcpy(partner_name, fish[partner_fish]->data->GetName(1));
                        CombineFish(target_fish, partner_fish);
                    }
                    if (love_phase == AQUA_EVENT_ELECTRIC_RELOAD) {
                        for (i = 0; i < 6; i++) {
                            if (fish[i] != NULL) {
                                fish[i]->GetPosition(saved_pos[i]);
                                fish[i]->GetRotation(saved_rot[i]);
                            }
                        }
                        SettingAqua();
                        for (i = 0; i < 6; i++) {
                            if (fish[i] != NULL) {
                                fish[i]->SetPosition(saved_pos[i]);
                                fish[i]->SetRotation(saved_rot[i]);
                            }
                        }
                    }
                    AquaScene->fade.FadeIn(50, 255.0f, 255.0f, 255.0f);
                    if (love_chara != NULL) {
                        love_chara->SetFadeFlag(1);
                        love_chara->Show(0);
                    }
                    love_phase++;
                }
                break;
            case AQUA_EVENT_BREED_FADE_IN_WAIT:
            case AQUA_EVENT_ELECTRIC_FADE_IN_WAIT:
                if (AquaScene->fade.FadeCheck() != 0) {
                    CAquaFish *child = NULL;

                    if (love_phase == AQUA_EVENT_BREED_FADE_IN_WAIT) {
                        menu->guide_draw = 1;
                        copy_name(menu->guide_mes, 0, target_name);
                        copy_name(menu->guide_mes, 1, partner_name);
                        child = fish[0];
                        if (child == NULL) {
                            child = fish[1];
                        }
                        if (child != NULL) {
                            copy_name(menu->guide_mes, 2, child->data->GetName(1));
                            menu->guide_id = 0x12C;
                            menu->guide_mes->MakeMesWin(menu->guide_id);
                            menu->guide_mes->fukidashi_pos = 5;
                            menu->help_draw = 0;
                            MenuSePlay(0x1E);
                        }
                    }
                    if (love_phase == AQUA_EVENT_ELECTRIC_FADE_IN_WAIT) {
                        menu->guide_draw = 1;
                        copy_name(menu->guide_mes, 0, target_name);
                        child = fish[target_fish];
                        if (child == NULL) {
                            for (int n = 0; n < 6; n++) {
                                if (fish[n] != NULL) {
                                    child = fish[n];
                                    break;
                                }
                            }
                        }
                        if (child != NULL) {
                            copy_name(menu->guide_mes, 2, child->data->GetName(1));
                            menu->guide_id = 0x12F;
                            menu->guide_mes->MakeMesWin(menu->guide_id);
                            menu->guide_mes->fukidashi_pos = 5;
                            menu->help_draw = 0;
                        }
                    }
                    love_phase++;
                    if (child == NULL) {
                        love_phase = AQUA_EVENT_NONE;
                        next = AQUARIUM_MODE_VIEW;
                        menu->guide_mes->fukidashi_pos = 8;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }
                }
                break;
            case AQUA_EVENT_BREED_MESSAGE:
            case AQUA_EVENT_ELECTRIC_MESSAGE:
                if (key != 0) {
                    love_phase = AQUA_EVENT_NONE;
                    next = AQUARIUM_MODE_VIEW;
                    menu->guide_mes->fukidashi_pos = 8;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
                break;
            case AQUA_EVENT_BREED_EFFECT_WAIT:
                love_time++;
                if (love_time > 60) {
                    love_phase = AQUA_EVENT_BREED_FADE_OUT;
                }
                break;
        }
    } else {
        if (GamePad__2.GetPadOn() != 0) {
            mes.fish_mes_time = 0;
        }
        switch (mode) {
            case AQUARIUM_MODE_VIEW:
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    return 1;
                }
                if (GamePad__2.Down(PAD_TRIANGLE)) {
                    MenuSePlay(SYSTEM_SE_WINDOW);
                    next = AQUARIUM_MODE_COMMAND;
                }
                break;
            case AQUARIUM_MODE_COMMAND: {
                int aqua_no = m_aquarium_para->active_tank;
                int step = 0;

                if (GamePad__2.Down(PAD_UP)) {
                    step--;
                } else if (GamePad__2.Down(PAD_DOWN)) {
                    step++;
                }
                if (menu->AddMenuCursor(step, menu_max_tbl_3720[aqua_no]) != 0) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    next = AQUARIUM_MODE_VIEW;
                } else if (key & MENU_PUSH_BUTTON_DECIDE) {
                    const s8 *ids = &menu_id_tbl_3721[aqua_no * 6];
                    i = menu->menu_cursor;
                    switch (ids[i]) {
                        case AQUARIUM_COMMAND_FISH_INFO:
                            if (InitSelFish() != 0) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            } else {
                                next = AQUARIUM_MODE_FISH_INFO;
                                MenuSePlay(SYSTEM_SE_DECIDE);
                            }
                            break;
                        case AQUARIUM_COMMAND_FEED:
                            next = AQUARIUM_MODE_FOOD_SELECT;
                            MenuSePlay(SYSTEM_SE_DECIDE);
                            break;
                        case AQUARIUM_COMMAND_RENAME:
                            if (InitSelFish() != 0) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            } else {
                                next = AQUARIUM_MODE_RENAME_GUIDE;
                                MenuSePlay(SYSTEM_SE_DECIDE);
                            }
                            break;
                        case AQUARIUM_COMMAND_TAKE_OUT:
                            if (InitSelFish() != 0) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            } else {
                                MenuSePlay(SYSTEM_SE_DECIDE);
                                next = AQUARIUM_MODE_TAKE_OUT;
                            }
                            break;
                        case AQUARIUM_COMMAND_MOVE:
                            if (InitSelFish() != 0) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            } else {
                                MenuSePlay(SYSTEM_SE_DECIDE);
                                next = AQUARIUM_MODE_MOVE_SELECT;
                            }
                            break;
                        case AQUARIUM_COMMAND_SWITCH_TANK:
                            MenuSePlay(SYSTEM_SE_DECIDE);
                            next = AQUARIUM_MODE_SWITCH_TANK_SELECT;
                            break;
                    }
                }
                break;
            }
            case AQUARIUM_MODE_FISH_INFO:
                if (menu_debug_flag != 0) {
                    CAquaFish      *selected = fish[sel_fish];
                    BREEDFISH_USED *breed;
                    int             add;

                    if (selected == NULL) {
                        break;
                    }
                    breed = selected->data == NULL ? NULL : &selected->data->data.fish;
                    if (GamePad__2.Down(PAD_UP)) {
                        menu_debug_select--;
                    }
                    if (GamePad__2.Down(PAD_DOWN)) {
                        menu_debug_select++;
                    }
                    add = 0;
                    if (GamePad__2.On(PAD_LEFT)) {
                        add = -1;
                    }
                    if (GamePad__2.On(PAD_RIGHT)) {
                        add = 1;
                    }
                    if (GamePad__2.On(PAD_L1)) {
                        add = -7;
                    }
                    if (GamePad__2.On(PAD_R1)) {
                        add = 7;
                    }
                    if (menu_debug_select < 0) {
                        menu_debug_select = 11;
                    }
                    if (menu_debug_select > 11) {
                        menu_debug_select = 0;
                    }
                    if (menu_debug_select == 0) {
                        int value = breed->param[4] + add;

                        if (value < 0) {
                            breed->param[4] = 0;
                        } else if (value > 0xFFFE) {
                            breed->param[4] = 0xFFFF;
                        } else {
                            breed->param[4] += add;
                        }
                    }
                    if (menu_debug_select == 1) {
                        int value = breed->param[3] + add;

                        if (value < 0) {
                            breed->param[3] = 0;
                        } else if (value > 0xFFFE) {
                            breed->param[3] = 0xFFFF;
                        } else {
                            breed->param[3] += add;
                        }
                    }
                    if (menu_debug_select >= 2 && menu_debug_select < 5) {
                        int value = breed->param[menu_debug_select - 2] + add;

                        if (value < 0) {
                            breed->param[menu_debug_select - 2] = 0;
                        } else if (value > 0xFFFE) {
                            breed->param[menu_debug_select - 2] = 0xFFFF;
                        } else {
                            breed->param[menu_debug_select - 2] += add;
                        }
                    }
                    if (menu_debug_select == 5) {
                        int value = breed->color + add;

                        if (value < 0) {
                            value = 18;
                        }
                        if (value >= 19) {
                            value = 0;
                        }
                        breed->color = value;
                    }
                    if (menu_debug_select == 6) {
                        int value = breed->size + add;

                        if (value < 10) {
                            value = 10;
                        }
                        if (value >= 2000) {
                            value = 2000;
                        }
                        breed->size = value;
                        if (add != 0) {
                            fish[sel_fish]->SetAdjustScale();
                        }
                    }
                    if (menu_debug_select == 7) {
                        int value = breed->weight + add;

                        if (value < 0) {
                            value = 0;
                        }
                        if (value > 50000) {
                            value = 50000;
                        }
                        breed->weight = value;
                    }
                    if (menu_debug_select == 8) {
                        int value = breed->timer + add;

                        if (value < 0) {
                            value = 0;
                        }
                        if (value > 50000) {
                            value = 50000;
                        }
                        breed->timer = value;
                    }
                    if (menu_debug_select == 9) {
                        int value = breed->life + add;

                        if (value <= 0) {
                            value = 1;
                        }
                        if (value > 50000) {
                            value = 50000;
                        }
                        breed->life = value;
                    }
                    if (menu_debug_select == 10) {
                        int value = breed->breed_feeds_remaining + add;

                        if (value < 0) {
                            value = 0;
                        }
                        if (value > 100) {
                            value = 100;
                        }
                        breed->breed_feeds_remaining = value;
                    }
                    if (menu_debug_select == 11) {
                        int value = breed->hp + add;

                        if (value <= 0) {
                            value = 1;
                        }
                        if (value > 100) {
                            value = 100;
                        }
                        breed->hp = value;
                    }
                } else {
                    SelectFish(0);
                    SelFishSetCursor();
                    if (key & MENU_PUSH_BUTTON_CANCEL) {
                        next = AQUARIUM_MODE_COMMAND;
                        MenuSePlay(SYSTEM_SE_WINDOW);
                    }
                }
                break;
            case AQUARIUM_MODE_FOOD_SELECT:
                if (menu->AddQuestionCursor() != 0) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    MenuSePlay(SYSTEM_SE_WINDOW);
                    next = AQUARIUM_MODE_COMMAND;
                } else if (key & MENU_PUSH_BUTTON_DECIDE) {
                    i = menu->question_cursor;
                    int item_no = esa_info[i].item_no;

                    if (GetUserItemHaveNum(item_no) <= 0) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        int size;

                        MenuSePlay(SYSTEM_SE_DECIDE);
                        if (LoadFile2(GetItemFilePath(item_no, 0), load_buf, &size, 0) != 0) {
                            food_stack.stack_used = 0;
                            food_stack.lock = 0;
                            mgTexManager.DeleteBlock(food_tex_block);
                            food = new (food_stack.Alloc(sizeof(CFishFood) / 16 + 2)) CFishFood;
                            food->LoadPack((unsigned int *) load_buf, "info.cfg", &food_stack, &food_stack, &food_stack,
                                           food_tex_block, NULL);
                            food->item_no = item_no;
                            food->SetScale(0.6f, 0.6f, 0.6f);
                            drop_pos[0] = 0.0f;
                            drop_pos[1] = 61.0f;
                            drop_pos[2] = 0.0f;
                            drop_pos[3] = 1.0f;
                            food->SetDropPosition(drop_pos);
                            drop_root_draw = 1;
                        }
                        next = AQUARIUM_MODE_FOOD_POSITION;
                    }
                }
                break;
            case AQUARIUM_MODE_RENAME_GUIDE:
                if (key != 0) {
                    next = AQUARIUM_MODE_RENAME_SELECT;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
                break;
            case AQUARIUM_MODE_RENAME_SELECT:
                SelectFish(0);
                SelFishSetCursor();
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    MenuSePlay(SYSTEM_SE_WINDOW);
                    next = AQUARIUM_MODE_COMMAND;
                } else if ((key & MENU_PUSH_BUTTON_DECIDE) && fish[sel_fish] != NULL) {
                    Nameregi_Target.target = 0;
                    Nameregi_Target.item = fish[sel_fish]->data;
                    if (Nameregi_Target.item != NULL && Nameregi_Target.item->rename_flag != 0) {
                        next = AQUARIUM_MODE_RENAME_BLOCKED;
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        AquaMode = AQUA_MENU_RENAME_FADE_OUT_WAIT;
                        next = AQUARIUM_MODE_TRANSITION_WAIT;
                        AquaScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }
                }
                break;
            case AQUARIUM_MODE_RENAME_BLOCKED:
                if (key != 0) {
                    next = AQUARIUM_MODE_RENAME_SELECT;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
                break;
            case AQUARIUM_MODE_FOOD_POSITION: {
                float pos[4];
                float lx;
                float ly;
                float angle;

                food->GetPosition(pos);
                lx = GamePad__2.GetLXf();
                ly = GamePad__2.GetLYf();
                angle = Camera__2->GetAngle();
                pos[0] += lx * cosf(angle) + ly * sinf(angle);
                pos[2] += -lx * sinf(angle) + ly * cosf(angle);
                local_aquarium_limmit_check(pos, 0.0f, 0, 0.0f);
                pos[1] = 61.0f;
                food->SetDropPosition(pos);
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    next = AQUARIUM_MODE_FOOD_SELECT;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else if (key & MENU_PUSH_BUTTON_DECIDE) {
                    next = AQUARIUM_MODE_FOOD_WAIT;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
                break;
            }
            case AQUARIUM_MODE_FOOD_WAIT:
                food_time--;
                if (food != NULL) {
                    float pos[4];

                    food->GetPosition(pos);
                    if (pos[1] <= 21.6f && ((key & MENU_PUSH_BUTTON_DECIDE) || (key & MENU_PUSH_BUTTON_CANCEL))) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                        food = NULL;
                    }
                }
                if (food_time <= 0) {
                    food = NULL;
                }
                if (food == NULL) {
                    next = AQUARIUM_MODE_VIEW;
                }
                break;
            case AQUARIUM_MODE_TAKE_OUT:
                SelectFish(0);
                SelFishSetCursor();
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    MenuSePlay(SYSTEM_SE_WINDOW);
                    next = AQUARIUM_MODE_COMMAND;
                } else if (key & MENU_PUSH_BUTTON_DECIDE) {
                    CAquaFish     *selected = fish[sel_fish];
                    CGameDataUsed *data = selected->data;

                    if (data->data.fish.flags & BREEDFISH_FLAG_ELECTRIC) {
                        next = AQUARIUM_MODE_TAKE_OUT_INFO;
                        menu->SetInfoMsgID(0x12D);
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        CGameDataUsed *space = user_data->SearchSpaceUsedDataPtr();

                        if (space != NULL && selected != NULL) {
                            space->CopyGameData(data);
                            AquaFishEff[sel_fish]->Initialize();
                            selected->Initialize();
                            fish[sel_fish] = NULL;
                            if (InitSelFish() != 0) {
                                MenuSePlay(SYSTEM_SE_WINDOW);
                                next = AQUARIUM_MODE_COMMAND;
                            }
                            MenuSePlay(SYSTEM_SE_DECIDE);
                        } else {
                            next = AQUARIUM_MODE_TAKE_OUT_INFO;
                            menu->SetInfoMsgID(0x12E);
                            MenuSePlay(SYSTEM_SE_CANCEL);
                        }
                    }
                }
                break;
            case AQUARIUM_MODE_TAKE_OUT_INFO:
                if (key != 0) {
                    next = AQUARIUM_MODE_TAKE_OUT;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
                break;
            case AQUARIUM_MODE_MOVE_SELECT:
                SelectFish(0);
                SelFishSetCursor();
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    MenuSePlay(SYSTEM_SE_WINDOW);
                    next = AQUARIUM_MODE_COMMAND;
                } else if (key & MENU_PUSH_BUTTON_DECIDE) {
                    CAquaFish *selected = fish[sel_fish];

                    if (selected == NULL) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else if (selected->data->data.fish.flags & BREEDFISH_FLAG_ELECTRIC) {
                        next = AQUARIUM_MODE_TAKE_OUT_INFO;
                        menu->SetInfoMsgID(0x12D);
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        MenuSePlay(SYSTEM_SE_DECIDE);
                        next = AQUARIUM_MODE_MOVE_TANK_SELECT;
                    }
                }
                break;
            case AQUARIUM_MODE_MOVE_TANK_SELECT:
                if (menu->AddQuestionCursor() != 0) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
                if (AquaDeadCheck == 1 || sel_sift_fish_select < 0 || (0 <= sel_sift_fish_select && fish[sel_sift_fish_select] == NULL)) {
                    next = AQUARIUM_MODE_MOVE_SELECT;
                    sel_sift_fish_select = -1;
                } else if (key & MENU_PUSH_BUTTON_DECIDE) {
                    i = menu->question_cursor;
                    int            tank = another_aquarium_Notbl_3642[m_aquarium_para->active_tank][i];
                    int            space = m_aquarium_para->SearchAqua1NotUsed(tank);
                    CGameDataUsed *data;

                    if (tank == AQUARIUM_TANK_BREED) {
                        data = sel_sift_fish->data;

                        if (m_aquarium_para->CheckHaigouTankSex(data) == 0) {
                            next = AQUARIUM_MODE_MOVE_INFO;
                            menu->SetInfoMsgID(data->data.fish.sex + 0x130);
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                        }
                        if (0 < data->data.fish.breed_feeds_remaining) {
                            ClsMes *info = menu->info_mes;

                            next = AQUARIUM_MODE_MOVE_INFO;
                            info->values[0] = data->data.fish.breed_feeds_remaining;
                            info->value_width[0] = 0;
                            menu->SetInfoMsgID(0x133);
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                        }
                    }
                    if (space < 0) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        data = sel_sift_fish->data;
                        GetAquariumData()->FishIntoAquarium(tank, space, data);
                        AquaFishEff[sel_fish]->Initialize();
                        sel_sift_fish->Initialize();
                        fish[sel_fish] = NULL;
                        if (InitSelFish() != 0) {
                            MenuSePlay(SYSTEM_SE_WINDOW);
                            next = AQUARIUM_MODE_COMMAND;
                        } else {
                            next = AQUARIUM_MODE_MOVE_SELECT;
                            MenuSePlay(SYSTEM_SE_DECIDE);
                        }
                    }
                } else if (key & MENU_PUSH_BUTTON_CANCEL) {
                    next = AQUARIUM_MODE_MOVE_SELECT;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                }
                break;
            case AQUARIUM_MODE_MOVE_INFO:
                if (key != 0) {
                    next = AQUARIUM_MODE_MOVE_TANK_SELECT;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
                break;
            case AQUARIUM_MODE_SWITCH_TANK_SELECT:
                if (menu->AddQuestionCursor() != 0) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
                if (key & MENU_PUSH_BUTTON_CANCEL) {
                    MenuSePlay(SYSTEM_SE_WINDOW);
                    next = AQUARIUM_MODE_COMMAND;
                } else if (key & MENU_PUSH_BUTTON_DECIDE) {
                    i = menu->question_cursor;
                    m_next_aqua_no = another_aquarium_Notbl_3642[m_aquarium_para->active_tank][i];
                    AquaMode = AQUA_MENU_TANK_FADE_OUT_WAIT;
                    mes.menu_cursor = 0;
                    mes.cursor_snap = 1;
                    AquaScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    next = AQUARIUM_MODE_TRANSITION_WAIT;
                }
                break;
            case AQUARIUM_MODE_TRANSITION_WAIT:
                break;
        }
    }
    if (0 <= next) {
        if (next == AQUARIUM_MODE_VIEW || next == AQUARIUM_MODE_TRANSITION_WAIT) {
            menu->menu_draw = 0;
            menu->guide_draw = 0;
            menu->cursor_draw = 0;
            menu->question_draw = 0;
            menu->help_draw = 1;
            menu->SetCtrlHelpId(0x32);
            if (next == AQUARIUM_MODE_TRANSITION_WAIT) {
                menu->help_draw = 0;
            }
            fish_info_draw = 0;
        }
        if (next == AQUARIUM_MODE_COMMAND) {
            menu->cursor_draw = 0;
            menu->menu_draw = 1;
            menu->guide_draw = 0;
            menu->question_draw = 0;
            menu->help_draw = 0;
            fish_info_draw = 0;
        }
        if (next == AQUARIUM_MODE_FISH_INFO) {
            menu->menu_draw = 0;
            menu->cursor_draw = 1;
            fish_info_draw = 1;
        }
        if (next == AQUARIUM_MODE_RENAME_GUIDE) {
            menu->guide_id = 0x132;
            menu->guide_mes->MakeMesWin(menu->guide_id);
            menu->guide_draw = 1;
            menu->menu_draw = 0;
            menu->cursor_draw = 0;
        }
        if (next == AQUARIUM_MODE_RENAME_SELECT) {
            menu->guide_id = 0xC8;
            menu->guide_mes->MakeMesWin(menu->guide_id);
            menu->guide_draw = 1;
            menu->menu_draw = 0;
            menu->cursor_draw = 1;
            fish_info_draw = 1;
        }
        if (next == AQUARIUM_MODE_RENAME_BLOCKED) {
            menu->guide_id = 0x139;
            menu->guide_mes->MakeMesWin(menu->guide_id);
            menu->guide_draw = 1;
            menu->menu_draw = 0;
            menu->cursor_draw = 0;
            fish_info_draw = 0;
        }
        if (next == AQUARIUM_MODE_FOOD_SELECT) {
            menu->menu_draw = 0;
            menu->question_draw = 1;
            menu->SetQuestionId(0x320, 1, 7);
            menu->help_draw = 0;
            food = NULL;
            AquaCameraCtrlMode = AQUA_CAMERA_CTRL_FREE;
            drop_root_draw = 0;
        }
        if (next == AQUARIUM_MODE_FOOD_POSITION) {
            menu->menu_draw = 0;
            menu->guide_draw = 0;
            menu->cursor_draw = 0;
            menu->question_draw = 0;
            menu->SetCtrlHelpId(0x34);
            menu->help_draw = 1;
            AquaCameraCtrlMode = AQUA_CAMERA_CTRL_FOOD;
            drop_root_draw = 1;
        }
        if (next == AQUARIUM_MODE_FOOD_WAIT) {
            menu->help_draw = 0;
            food->Drop();
            food_time = 0xFA;
            AquaCameraCtrlMode = AQUA_CAMERA_CTRL_FREE;
            drop_root_draw = 0;
        }
        if (next == AQUARIUM_MODE_TAKE_OUT) {
            menu->guide_id = 0xD2;
            menu->guide_mes->MakeMesWin(menu->guide_id);
            menu->guide_draw = 1;
            menu->menu_draw = 0;
            menu->cursor_draw = 1;
            menu->info_draw = 0;
            fish_info_draw = 1;
        }
        if (next == AQUARIUM_MODE_TAKE_OUT_INFO) {
            menu->guide_draw = 0;
            menu->info_draw = 1;
            menu->cursor_draw = 0;
            fish_info_draw = 0;
        }
        if (next == AQUARIUM_MODE_SWITCH_TANK_SELECT) {
            menu->menu_draw = 0;
            menu->question_draw = 1;
            menu->SetQuestionId(m_aquarium_para->active_tank + 0x384, 1, 2);
        }
        if (next == AQUARIUM_MODE_MOVE_SELECT) {
            menu->menu_draw = 0;
            menu->guide_id = 0xDC;
            menu->guide_mes->MakeMesWin(menu->guide_id);
            menu->guide_draw = 1;
            menu->cursor_draw = 1;
            menu->question_draw = 0;
            fish_info_draw = 1;
            sel_sift_fish_select = -1;
            sel_sift_fish = NULL;
        }
        if (next == AQUARIUM_MODE_MOVE_TANK_SELECT) {
            sel_sift_fish = fish[sel_fish];
            sel_sift_fish_select = sel_fish;
            menu->guide_draw = 0;
            menu->cursor_draw = 0;
            menu->info_draw = 0;
            menu->question_draw = 1;
            menu->SetQuestionId(m_aquarium_para->active_tank + 0x3E8, 1, 2);
        }
        if (next == AQUARIUM_MODE_MOVE_INFO) {
            menu->guide_draw = 0;
            menu->cursor_draw = 0;
            menu->info_draw = 1;
            menu->question_draw = 0;
        }
        mode = next;
    }
    AquaDeadCheck = 0;
    if (food != NULL) {
        food->Step();
        if (food->state == FISH_FOOD_ENTER) {
            ripple = 0.18f;
        }
    }
    for (int i = 0; i < 3; i++) {
        if (AquaBubble[i] != NULL) {
            AquaBubble[i]->Step();
        }
    }
    for (int i = 0; i < 6; i++) {
        if (AquaFishBubble[i] != NULL) {
            AquaFishBubble[i]->Step();
        }
    }
    if (AquaBattleBubble != NULL) {
        for (int i = 0; i < 0x30; i++) {
            AquaBattleBubble[i].Step();
        }
    }
    for (int i = 0; i < 6; i++) {
        AquaFishEff[i]->Step();
    }
    if (AQUA_EVENT_NONE < love_phase && love_chara != NULL) {
        love_chara->Step();
        if (love_chara->CheckMotionEnd() == 1) {
            love_phase = AQUA_EVENT_NONE;
        }
    }
    result = 0;
    for (j = 0; j < 6; j++) {
        if (fish[j] != NULL) {
            Thinking(j);
            result |= ColCheck(j);
            fish[j]->Step();
            result |= fish[j]->ParamStep();
            if (result & AQUA_FISH_RESULT_FEEDING_EXHAUSTED) {
                mes.EatMessage(0x136, fish[j]);
                result &= ~AQUA_FISH_RESULT_FEEDING_EXHAUSTED;
            }
            if (result & AQUA_FISH_RESULT_SEX_CHANGED) {
                mes.ChangeManMessage(fish[j]);
                result &= ~AQUA_FISH_RESULT_SEX_CHANGED;
            }
            if (result & AQUA_FISH_RESULT_DEAD) {
                MenuSePlay(Aqua_SpSndID, 4);
                mes.DeadMessage(fish[j]);
                fish[j]->Initialize();
                fish[j] = NULL;
                AquaDeadCheck = 1;
                SelectFish(1);
                if (sel_fish < 0) {
                    menu->menu_draw = 0;
                    menu->guide_draw = 0;
                    menu->cursor_draw = 0;
                    menu->question_draw = 0;
                    menu->help_draw = 1;
                    menu->SetCtrlHelpId(0x32);
                }
                result &= ~AQUA_FISH_RESULT_DEAD;
            }
        }
    }
    if (0 < Aqua_SpSndBattleCount) {
        Aqua_SpSndBattleCount--;
    }
    if (0 < AquaBattleBubble_Generate_Wait) {
        AquaBattleBubble_Generate_Wait--;
    }
    if (result & AQUA_FISH_RESULT_BATTLE_HIT) {
        if (Aqua_SpSndBattleCount == 0) {
            MenuSePlay(Aqua_SpSndID, 3);
            Aqua_SpSndBattleCount = 8;
        }
        if (AquaBattleBubble != NULL && AquaBattleBubble_Generate_Wait <= 0) {
            CBubble *emitter = &AquaBattleBubble[AquaBattleBubble_Generate_Counter];
            float    pos[4];

            for (int i = 0; i < 0x30; i++) {
                pos[0] = AquaBattleBubble_Pos[0] + GetRandF(5.0f) - 2.5f;
                pos[1] = AquaBattleBubble_Pos[1] + GetRandF(3.0f) - 1.5f;
                pos[2] = AquaBattleBubble_Pos[2] + GetRandF(5.0f) - 2.5f;
                emitter->Generate(pos);
            }
            AquaBattleBubble_Generate_Counter++;
            if (AquaBattleBubble_Generate_Counter >= 0x30) {
                AquaBattleBubble_Generate_Counter = 0;
            }
            AquaBattleBubble_Generate_Wait = 6;
        }
    }
    menu->Step();
    if (result & AQUA_FISH_RESULT_ELECTRIC_FOOD_EATEN) {
        love_phase = AQUA_EVENT_ELECTRIC_FADE_OUT;
    }
    return 0;
}

void CAquarium::Draw() {
    mgCTextureManager *textures = &mgTexManager;
    int                i;
    float water_ambient[4] = {64.0f, 92.0f, 128.0f, 128.0f};

    mgSetAmbient(water_ambient);
    for (i = 0; i < 6; i++) {
        if (fish[i] != NULL) {
            textures->ReloadTexture(fish_tex_block[i], static_cast<sceVif1Packet *>(NULL));
            fish[i]->FishDraw();
        }
    }
    float *light = ambient;
    mgSetAmbient(light);
    if (ground_frame != NULL) {
        textures->ReloadTexture(ground_tex_block, static_cast<sceVif1Packet *>(NULL));
        mgDrawDirect(ground_frame);
    }
    if (aqua_frame != NULL) {
        load_stack.stack_used = 0;
        load_stack.lock = 0;
        mgBeginDraw(&load_stack, tex_block, NULL);
        mgDraw(aqua_frame);
        mgSetAmbient(water_ambient);
        if (naka_frame != NULL) {
            mgDraw(naka_frame);
        }
        mgSetAmbient(light);
        mgEndDraw(NULL);
    }
    if (glass_frame != NULL) {
        textures->ReloadTexture(glass_tex_block, static_cast<sceVif1Packet *>(NULL));
        mgDrawDirect(glass_frame);
    }
    if (food != NULL) {
        textures->ReloadTexture(food_tex_block, static_cast<sceVif1Packet *>(NULL));
        food->DrawDirect();
    }
    textures->ReloadTexture(menu_tex_block, static_cast<sceVif1Packet *>(NULL));
    for (int i = 0; i < 3; i++) {
        if (AquaBubble[i] != NULL) {
            AquaBubble[i]->SetTexture(Tex_Aqualium, 0xF8, 0x64);
            AquaBubble[i]->Draw();
        }
    }
    for (int i = 0; i < 6; i++) {
        if (AquaFishBubble[i] != NULL) {
            AquaFishBubble[i]->SetTexture(Tex_Aqualium, 0xF8, 0x64);
            AquaFishBubble[i]->Draw();
        }
    }
    if (AquaBattleBubble != NULL) {
        for (int i = 0; i < 0x30; i++) {
            AquaBattleBubble[i].SetTexture(Tex_Aqualium, 0xF8, 0x64);
            AquaBattleBubble[i].Draw();
        }
    }
    for (int i = 0; i < 6; i++) {
        AquaFishEff[i]->Draw();
    }
    if (suimen_frame != NULL) {
        float surface_ambient[4] = {128.0f, 128.0f, 128.0f, 8.0f};

        mgSetAmbient(surface_ambient);
        textures->ReloadTexture(water_tex_block, static_cast<sceVif1Packet *>(NULL));
        mgDrawDirect(suimen_frame);
        if (mizu_frame != NULL) {
            mgDrawDirect(mizu_frame);
        }
        mgSetAmbient(light);
    }
    if (food != NULL && drop_root_draw != 0) {
        DrawEsaDropRoot(food, 48.0f);
    }
    if (water != NULL) {
        float       camera_pos[4];
        float       matrix[4][4];
        mgCTexture *screen;
        mgCTexture *reflect;
        int         wall;

        Camera__2->GetPos(camera_pos);
        if (camera_pos[1] < 47.0f) {
            water->SetPosition(-34.0f, float(46.8), -21.5f);
        } else {
            water->SetPosition(-34.0f, 47.0f, -21.5f);
        }
        mgUnitMatrix(matrix);
        textures->ReloadTexture(water_tex_block, static_cast<sceVif1Packet *>(NULL));
        mgCTexture frame_buffer;
        mgGetFrameBuffer(&frame_buffer);
        screen = textures->GetTexture("AQUA_WATER_WORK", -1);
        mgRect<int> screen_rect;
        screen_rect.Set(0, 0, (mgScreenWidth - 1) * 16, (mgScreenHeight - 1) * 16);
        mgSetPkMoveImage(&frame_buffer, screen_rect, screen, 0, 0, 0);
        mgCDrawPrim prim;
        prim.Initialize(NULL, NULL);
        prim.DepthTestEnable(0);
        prim.ZMask(-1);
        prim.TextureMapEnable(1);
        prim.AlphaBlendEnable(0);
        prim.AlphaTestEnable(0);
        float dir[4];
        float flat_dir[4];
        Camera__2->GetDir(dir);
        sceVu0Normalize(flat_dir, dir);
        dir[1] = 0.0f;
        sceVu0Normalize(dir, dir);
        float axis_x[4] = {1.0f, 0.0f, 0.0f, 0.0f};
        float axis_z[4] = {1.0f, 0.0f, 0.0f, 0.0f};
        sceVu0InnerProduct(axis_x, dir);
        sceVu0InnerProduct(axis_z, flat_dir);
        water->CreatePacket();
        ripple -= 0.01f;
        if (ripple <= 0.1f) {
            ripple = 0.1f;
        }
        int row = fptosi(24.0f * GetRandF(1.0f));
        water->Shake(row, fptosi(16.0f * GetRandF(1.0f)), ripple);
        float speed = 0.0045f;
        water->SetParam(float(0.15), speed, 0.0f, 10.0f);
        water->Step();
        water->SetColor(0x80, 0x80, 0x80, 0x80);
        mgDrawDirect(water);
        reflect = textures->GetTexture("aquaref", -1);
        mgSetPkFrameBuffer(screen);
        if (reflect != NULL) {
            prim.Begin(6);
            prim.Texture(reflect);
            prim.Color(0x80, 0x80, 0x80, 0x80);
            PrimQuad(&prim, mgRect<int>(0, 0, mgScreenWidth, mgScreenHeight), mgRect<int>(0, 0, 0x80, 0x80));
            prim.End();
        }
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        water->SetColor(0x80, 0x80, 0x80, 0x30);
        water->SetParam(0.15f, speed, 0.0f, 100.0f);
        mgDrawDirect(water);
        mgGetFrameBuffer(&frame_buffer);
        mgSetPkMoveImage(&frame_buffer, screen_rect, screen, 0, 0, 0);
        sceVu0FVECTOR wall0[4] = {
            {-33.0f, 47.0f, 21.0f, 1.0f},
            {33.0f,  47.0f, 21.0f, 1.0f},
            {-33.0f, 15.0f, 21.0f, 1.0f},
            {33.0f,  15.0f, 21.0f, 1.0f}
        };
        sceVu0FVECTOR wall1[4] = {
            {-33.0f, 47.0f, -21.0f, 1.0f},
            {33.0f,  47.0f, -21.0f, 1.0f},
            {-33.0f, 15.0f, -21.0f, 1.0f},
            {33.0f,  15.0f, -21.0f, 1.0f}
        };
        sceVu0FVECTOR wall2[4] = {
            {33.2f, 47.0f, 21.0f,  1.0f},
            {33.2f, 47.0f, -21.0f, 1.0f},
            {33.2f, 15.0f, 21.0f,  1.0f},
            {33.2f, 15.0f, -21.0f, 1.0f}
        };
        sceVu0FVECTOR wall3[4] = {
            {-33.2f, 47.0f, 21.0f,  1.0f},
            {-33.2f, 47.0f, -21.0f, 1.0f},
            {-33.2f, 15.0f, 21.0f,  1.0f},
            {-33.2f, 15.0f, -21.0f, 1.0f}
        };
        float offset[4];
        int   prim_pos[4][4];
        int   screen_pos[4][4];
        for (wall = 0; wall < 4; wall++) {
            float (*quad)[4];
            int visible;
            int k;

            switch (wall) {
                case 0:
                    if (camera_pos[2] < 21.0f) {
                        continue;
                    }
                    quad = wall0;
                    sceVu0SubVector(offset, v1orig_4373, camera_pos);
                    break;
                case 1:
                    if (!(camera_pos[2] <= -21.0f)) {
                        continue;
                    }
                    quad = wall1;
                    sceVu0SubVector(offset, v2orig_4374, camera_pos);
                    break;
                case 2:
                    if (camera_pos[0] < 34.0f) {
                        continue;
                    }
                    quad = wall2;
                    sceVu0SubVector(offset, v3orig_4375, camera_pos);
                    break;
                case 3:
                    if (!(camera_pos[0] <= -34.0f)) {
                        continue;
                    }
                    quad = wall3;
                    sceVu0SubVector(offset, v4orig_4376, camera_pos);
                    break;
            }
            sceVu0Normalize(offset, offset);
            sceVu0ScaleVector(offset, offset, 1.5f);
            prim.Initialize(NULL, NULL);
            prim.DepthTestEnable(1);
            prim.DepthTest(1);
            prim.AlphaTestEnable(0);
            prim.AlphaBlendEnable(0);
            prim.TextureMapEnable(1);
            prim.Coord(1);
            prim.Begin(4);
            prim.Color(0x80, 0x80, 0x80, 0x80);
            visible = 1;
            for (k = 0; k < 4; k++) {
                visible &= mgTransWorldPrim(prim_pos[k], quad[k]);
                sceVu0AddVector(quad[k], quad[k], offset);
                mgTransWorldScreen(screen_pos[k], quad[k]);
            }
            if (wall == 0 || wall == 2) {
                screen_pos[0][0] += 0xC0;
                screen_pos[1][0] -= 0xC0;
                screen_pos[2][0] += 0xC0;
                screen_pos[3][0] -= 0xC0;
            } else {
                screen_pos[0][0] -= 0xC0;
                screen_pos[1][0] += 0xC0;
                screen_pos[2][0] -= 0xC0;
                screen_pos[3][0] += 0xC0;
            }
            screen_pos[0][1] += 0x60;
            screen_pos[1][1] += 0x60;
            screen_pos[2][1] -= 0x60;
            screen_pos[3][1] -= 0x60;
            if (visible) {
                prim.Texture(screen);
                prim.TextureCrd4(screen_pos[0][0], screen_pos[0][1]);
                prim.Vertex4(prim_pos[0]);
                prim.TextureCrd4(screen_pos[1][0], screen_pos[1][1]);
                prim.Vertex4(prim_pos[1]);
                prim.TextureCrd4(screen_pos[2][0], screen_pos[2][1]);
                prim.Vertex4(prim_pos[2]);
                prim.TextureCrd4(screen_pos[3][0], screen_pos[3][1]);
                prim.Vertex4(prim_pos[3]);
            }
            prim.End();
        }
    }
    textures->ReloadTexture(menu_tex_block, static_cast<sceVif1Packet *>(NULL));
    if (mes.title_draw != 0) {
        mgCDrawPrim title_prim;

        DrawMenuFillBox(&title_prim, AQUA_TITLE_X + 10, AQUA_TITLE_Y + 12, AQUA_TITLE_W - 18, AQUA_TITLE_H - 22, 0x10, 0, 0xFF, 0xFF);
        SetSpriteEnv(&title_prim, 0);
        title_prim.Begin(6);
        title_prim.Texture(Tex_Aqualium);
        title_prim.Color(0x80, 0x80, 0x80, 0x80);
        Menu3DivideTextureDraw(&title_prim, mgRect<int>(AQUA_TITLE_X, AQUA_TITLE_Y, AQUA_TITLE_W, AQUA_TITLE_H), t_4408, 1);
        title_prim.End();
    }
    mes.DrawTitleMes();
    textures->ReloadTexture(menu_tex_block, static_cast<sceVif1Packet *>(NULL));
    if (fish_info_draw != 0 && 0 <= sel_fish && fish[sel_fish] != NULL) {
        DrawFishParam(mgScreenWidth - 0x152, 2, Tex_Aqualium, fish[sel_fish]->data);
    }
    if (0 < love_phase && love_chara != NULL) {
        textures->ReloadTexture(love_tex_block, static_cast<sceVif1Packet *>(NULL));
        love_chara->DrawDirect();
    }
    textures->ReloadTexture(MenuArg.mes_tex_block, static_cast<sceVif1Packet *>(NULL));
    mes.Draw();
    if (menu_debug_flag != 0) {
        CMenuFont  font;
        CAquaFish *selected = fish[sel_fish];

        if (selected != NULL) {
            BREEDFISH_USED *breed = selected->data == NULL ? NULL : &selected->data->data.fish;
            int             x = mgScreenWidth - 0x78;
            float           top = 80.0f;
            float           h = 242.0f;
            float           w = 120.0f;
            int             y = 0x50;
            DrawMenuFillBox(x, top, w, h, 0x40, 0, 0, 0);
            char *formats[12] = {
                "  Battle:%d",
                "  Stamina:%d",
                "  Boost:%d",
                "  Endur:%d",
                "  Tenacity:%d",
                "  Color:%d",
                "  SIZE:%d",
                "  WEIGHT:%d",
                "  HUNGRY:%d",
                "  ESA:%d",
                "  MIX:%d",
                "  LIFE:%d",
            };
            int values[12] = {
                breed->param[4],
                breed->param[3],
                breed->param[0],
                breed->param[1],
                breed->param[2],
                breed->color,
                breed->size,
                breed->weight,
                breed->timer,
                breed->life,
                breed->breed_feeds_remaining,
                breed->hp,
            };
            char line[0x100];
            for (int i = 0; i < 12; y += 0x14, i++) {
                sprintf(line, formats[i], values[i]);
                if (i == menu_debug_select) {
                    line[0] = '>';
                }
                font.DrawDirect(line, x, y);
            }
        }
    }
}

void MenuAquaInit(mgCMemory *memory, int *tex_block, int) {
    AquaScene = GetMainScene();
    Auqa_Bgm_Volf = AquaScene->GetTimeBgmVolf();

    if (AquaScene->now_map_no != 10) {
        MenuMainScene->SetVolfBGM(0.6f * Auqa_Bgm_Volf);
    }

    StopEnvSoundMenu(1);
    MenuScreenBlackBeltSet(0);
    AQUA_TITLE_X = 10;
    AQUA_TITLE_Y = 6;
    AQUA_TITLE_W = 0x9E;
    AQUA_TITLE_H = 0x42;

    if (LanguageCode == 4) {
        AQUA_TITLE_W = 0xC4;
    }

    if (LanguageCode == 5) {
        AQUA_TITLE_W = 0xDA;
    }

    m_next_aqua_no = -1;
    Camera__2 = new ((u_long128 *) memory->Alloc(sizeof(mgCCameraFollow) / 16 + 2)) mgCCameraFollow(40.0f, 30.0f, 0.0f, 8.0f);
    aqua_old_env = (aqua_light_env *) memory->Alloc(sizeof(aqua_light_env) / 16);
    mgCMemory aqua_memory;
    int       rest = memory->stGetRest();
    aqua_memory.stSetBuffer(memory->stGetTop(), rest);
    Aquarium.Clear();
    Aquarium.Initialize(&aqua_memory, tex_block);
    AquaCameraCtrlMode = 0;
    Camera__2->SetDistance(140.0f);
    Camera__2->SetAngle(0.0f);
    Camera__2->SetHeight(0.0f);
    Camera__2->SetSpeed(4.0f, -1.0f);
    Camera__2->SetFollow(0.0f, 35.0f, 0.0f);
    Camera__2->Step(-1);
    AquaScene->fade.FadeIn(30);
    AquaMode = AQUA_MENU_INIT;
    mgGetPlight(0, &aqua_old_env->plight);
    aqua_old_env->plight_enable = mgGetPlightEnable();
    mgPlightEnable(1);
    mgGetLight(aqua_old_env->light_dir, aqua_old_env->light_color);
}

int MenuAquaKey() {
    switch (AquaMode) {
        case AQUA_MENU_INIT:
            AquaMode = AQUA_MENU_OPEN_FADE_WAIT;
            GamePad__2.MenuModeOff();
        case AQUA_MENU_OPEN_FADE_WAIT:
            Aquarium.Step();

            if (AquaScene->fade.FadeCheck() != 0) {
                AquaMode = AQUA_MENU_ACTIVE;
            }

            break;
        case AQUA_MENU_ACTIVE:
            if (AquaCameraCtrlMode == 0) {
                Camera__2->AddAngle(0.04f * -GamePad__2.GetRXf());
                Camera__2->AddAngle(0.04f * -GamePad__2.GetLXf());
                Camera__2->AddHeight(-2.0f * GamePad__2.GetRYf());
                Camera__2->AddDistance(2.0f * GamePad__2.GetLYf());

                if (Camera__2->GetHeight() < -20.0f) {
                    Camera__2->SetHeight(-20.0f);
                } else if (!(Camera__2->GetHeight() <= 90.0f)) {
                    Camera__2->SetHeight(90.0f);
                }

                if (Camera__2->GetDistance() < 130.0f) {
                    Camera__2->SetDistance(130.0f);
                } else if (!(Camera__2->GetDistance() <= 262.0f)) {
                    Camera__2->SetDistance(262.0f);
                }

                float pos_speed = 2.0f;
                Camera__2->SetSpeed(pos_speed, -1.0f);
            }

            if (AquaCameraCtrlMode == 1) {
                Camera__2->AddAngle(0.04f * -GamePad__2.GetRXf());
                Camera__2->AddHeight(-2.0f * GamePad__2.GetRYf());

                if (Camera__2->GetHeight() < -20.0f) {
                    Camera__2->SetHeight(-20.0f);
                } else if (!(Camera__2->GetHeight() <= 90.0f)) {
                    Camera__2->SetHeight(90.0f);
                }

                Camera__2->SetDistance(150.0f);
                Camera__2->SetSpeed(2.0f, -1.0f);
            }

            Camera__2->Step(1);

            if (Aquarium.Step() != 0) {
                AquaScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                AquaMode = AQUA_MENU_CLOSE_FADE_WAIT;
                GamePad__2.KeyLock(1);
            }

            break;
        case AQUA_MENU_CLOSE_FADE_WAIT:
            Aquarium.Step();

            if (AquaScene->fade.FadeCheck() == 0) {
                break;
            }

            AquaMode = AQUA_MENU_CLEAR;
        case AQUA_MENU_CLEAR:
            Aquarium.Clear();
            GamePad__2.KeyLock(0);
            GamePad__2.MenuModeOn(0x78);
            mgPlightEnable(aqua_old_env->plight_enable);
            mgSetPlight(0, &aqua_old_env->plight);
            mgSetLight(aqua_old_env->light_dir, aqua_old_env->light_color);
            ReStartEnvSoundMenu();
            MenuMainScene->SetVolfBGM(Auqa_Bgm_Volf);
            MenuScreenBlackBeltSet(1);
            return 1;
        case AQUA_MENU_TANK_FADE_OUT_WAIT:
            Aquarium.Step();

            if (AquaScene->fade.FadeCheck() != 0) {
                m_aquarium_para->active_tank = m_next_aqua_no;
                Aquarium.SettingAqua();
                AquaScene->fade.FadeIn(30);
                AquaMode = AQUA_MENU_TANK_FADE_IN_WAIT;
            }

            break;
        case AQUA_MENU_TANK_FADE_IN_WAIT:
        case AQUA_MENU_RENAME_FADE_IN_WAIT:
            Aquarium.Step();

            if (AquaScene->fade.FadeCheck() != 0) {
                AquaMode = AQUA_MENU_ACTIVE;
            }

            break;
        case AQUA_MENU_RENAME_FADE_OUT_WAIT:
            Aquarium.Step();

            if (AquaScene->fade.FadeCheck() != 0) {
                GamePad__2.MenuModeOn(0x78);
                SetMenuFrameRate(1);
                Aquarium_NameregistStack.stack_used = 0;
                Aquarium_NameregistStack.lock = 0;
                MenuScreenBlackBeltSet(1);
                NameRegistInit(&Aquarium_NameregistStack, Aquarium_NameregistBlock, 0);
                AquaMode = AQUA_MENU_RENAME;
            }

            break;
        case AQUA_MENU_RENAME:
            if (NameRegistKey() != 0) {
                MenuScreenBlackBeltSet(0);
                Aquarium.SettingAqua();
                AquaScene->fade.FadeIn(30);
                SetMenuFrameRate(2);
                GamePad__2.MenuModeOff();
                AquaMode = AQUA_MENU_RENAME_FADE_IN_WAIT;
            }

            break;
    }

    return 0;
}

void MenuAquaDraw() {
    float view[4][4];
    float position[4];

    if (AquaMode == AQUA_MENU_CLEAR) {
        return;
    }

    DrawMenuFillBox(128, 0, 0, 0);

    if (AquaMode == AQUA_MENU_RENAME) {
        NameRegistDraw();
    } else {
        mgSetLight(light_dir, light_color[m_aquarium_para->active_tank]);
        Camera__2->GetCameraMatrix(view);
        Camera__2->GetPos(position);
        mgSetViewMatrix(view, position);
        Aquarium.Draw();
    }
}

void MenuGyoraceFishSelInit(mgCMemory *memory, int *tex_block, int) {
    char       filename[76];
    int        file_size;
    int        available = memory->stGetRest();
    u_long128 *top = memory->stGetTop();
    GyoraceFishSelStack.stSetBuffer(top, available);
    short *banks = (short *) tex_block;
    GyoraceFishFrameImgTexNo = banks[0];
    GyoraceFishSelTexBk = banks[2];
    MenuBGTextureBlock = GyoraceFishFrameImgTexNo;
    MenuCapture(MenuBGTextureBlock, &GyoraceFishSelStack, 1);
    MenuCommonInfo->now_mode = MENU_MODE_GYORACE_FISH_SEL;
    m_aquarium_para = &GetUserDataMan()->aquarium;
    StartReadBG();
    sprintf(filename, "menu/aqua/amenu%d.img", LanguageCode);
    file_size = 0;
    GyoraceFishSelStack.Align64();
    LoadFileBG(filename, GyoraceFishSelStack.stGetTop(), &file_size);
    GyoraceFishSelStack.Alloc(align16_blocks(file_size));
    Tex_Aqualium = NULL;
    GyoRaceFishReadPhase = -1;
    GyoraceFishSelectMode = 0;
    GyoraceFishSelNum = 0;
    GyoraceFish = NULL;
}

int MenuGyoraceFishSelKey() {
    char          *names[8];
    char           name_buf[8][0x28];
    CDC2Mes       *mes;
    short         *menu_mes;
    CGameDataUsed *fish;
    CDC2Mes       *list;
    int            i;

    switch (GyoraceFishSelectMode) {
        case 0:
            if (ReadBGSync() == 0) {
                BG_READ_INFO *file = GetReadBGFile(0);

                if (file == NULL) {
                    return 1;
                }

                mgTexManager.EnterIMGFile((u_char *) file->buffer, GyoraceFishSelTexBk, NULL, NULL);
                Tex_Aqualium = mgTexManager.GetTexture("amenu0", -1);
                menu_mes = GetMenuMainMessageBuffer();
                mes = MenuDCMsg[0];
                mes->SetMessData(GetSystemMesBuffer(), menu_mes);
                mes->MsgPreset(0x12);
                mes->MakeMsg(GetGyoRaceNo() + 0x76C);
                mes->fade_speed = 1.0f;
                mes->StepMsg();
                mes->SetPutPos(((mgScreenWidth - mes->line_w[0]) >> 1) - 0xC, 8, -1, -1);
                list = MenuDCMsg[1];
                list->SetMessData(GetSystemMesBuffer(), menu_mes);
                list->MsgPreset(0xA);
                list->push_button = 0;
                list->fade_speed = 1.0f;
                list->select_top = 0;
                list->SetMsgCursor(0);
                fish = GetAquariumData()->GetAquariumFishTop(0);

                for (i = 0; i < 6; i++, fish++) {
                    if (fish->item_no > 0) {
                        names[GyoraceFishSelNum] = fish->GetName(1);

                        if (fish->data.fish.flags & 2) {
                            names[GyoraceFishSelNum] = NULL;
                        }

                        if (names[GyoraceFishSelNum] != NULL) {
                            strcpy(name_buf[GyoraceFishSelNum], names[GyoraceFishSelNum]);
                            names[GyoraceFishSelNum] = name_buf[GyoraceFishSelNum];
                            GyoraceFishSel[GyoraceFishSelNum] = i;
                            GyoraceFishSelNum++;
                        }
                    }
                }

                names[GyoraceFishSelNum] = NULL;
                list->SetMsgItemNo(names, GyoraceFishSelNum);
                list->MakeMsg(GyoraceFishSelNum + 0x31);
                list->SetPutPos((mgScreenWidth >> 1) - 0x64, 0x5A, 0xC8, -1);
                GyoraceFishSelectNo = 0;
                MenuCommonInfo->key_enable = 1;
                GyoraceFishSelectMode++;
            }

            break;
        case 1: {
            int button;

            MenuDCMsg[1]->AddMsgCursor2(0, GyoraceFishSelNum - 1, 1);
            button = MenuCommonInfo->CheckPushButton();
            GyoraceFishSelectNo = MenuDCMsg[1]->GetMsgCursor();
            GyoraceFish = m_aquarium_para->GetAquariumFishTop(0) + GyoraceFishSel[GyoraceFishSelectNo];

            if (button & 1) {
                CGameDataUsed *selected;

                MenuSePlay(SYSTEM_SE_DECIDE);
                MenuArg.result[0] = GyoraceFishSel[GyoraceFishSelectNo];
                fish = GetAquariumData()->GetAquariumFishTop(0);
                MenuArg.result[1] = 0;
                MenuArg.result[2] = 0;
                selected = &fish[MenuArg.result[0]];

                if (selected != NULL) {
                    if (!(selected->data.fish.flags & fish_flag_won_class0)) {
                        MenuArg.result[1] |= 1;
                    }

                    if (!(selected->data.fish.flags & fish_flag_won_class1)) {
                        MenuArg.result[1] |= 2;
                    }

                    if (!(selected->data.fish.flags & fish_flag_won_class2)) {
                        MenuArg.result[1] |= 4;
                    }

                    MenuArg.result[1] |= 8;

                    if (selected->data.fish.unk_3d & 1) {
                        MenuArg.result[2] = 1;
                    }
                }

                GyoraceFishSelectMode++;
            } else if (button & 2) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                MenuArg.result[1] = 0;
                GyoraceFish = NULL;
                MenuArg.result[0] = -1;
                GyoraceFishSelectMode++;
            }

            break;
        }
        case 2:
            return 1;
    }

    if (MenuDCMsg[0] != NULL) {
        MenuDCMsg[0]->StepMsg();
        MenuDCMsg[1]->StepMsg();
    }

    switch (GyoRaceFishReadPhase) {
        case -1:
            break;
        case 0:
            GyoRaceFishReadPhase++;
            break;
        case 1:
            GyoRaceFishReadPhase++;
            break;
        case 2:
            GyoRaceFishReadPhase++;
            break;
    }

    return 0;
}

void MenuGyoraceFishSelDraw() {
    mgCTextureManager *tex_manager = &mgTexManager;
    mgRect<int>        dest;
    mgRect<int>        source;
    tex_manager->ReloadTexture(MenuBGTextureBlock, (sceVif1Packet *) 0);
    source.Set(0, 0, mgScreenWidth >> 1, mgScreenHeight >> 1);
    dest.Set(0, 0, mgScreenWidth, mgScreenHeight);
    PrimQuad(MenuFrameTex, dest, source, 0x80, 0x80, 0x80, 0x80);

    if (Tex_Aqualium != 0) {
        tex_manager->ReloadTexture(GyoraceFishSelTexBk, (sceVif1Packet *) 0);
        DrawFishParam((mgScreenWidth - 0x14A >> 1) + 10, mgScreenHeight - 0x8E, Tex_Aqualium,
                      GyoraceFish);
    }

    if (GyoraceFishSelectMode != 0) {
        tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) 0);
        MenuDCMsg[0]->DrawMsg();
        MenuDCMsg[1]->DrawMsg();
    }
}

CGameDataUsed *GetGyoRaceFish() {
    return GyoraceFish;
}

void SetGyoRaceAquariumNo(int value) {
    GyoRaceAquariumNo = value;
}

int GetGyoRaceAquariumNo() {
    return GyoRaceAquariumNo;
}

void SetGyoRaceClass(int value) {
    GyoRaceClass = value;
}

int GetGyoRaceClass() {
    return GyoRaceClass;
}

void SetGyoRaceNo(int value) {
    GyoRaceProgressNum = value;

    if (GyoRaceProgressNum < 0) {
        GyoRaceProgressNum = 0;
    }
}

int GetGyoRaceNo() {
    return GyoRaceProgressNum;
}

void SetGyoRaceRanking(int rank) {
    int            race_class;
    CSaveData     *save_data;
    CGameDataUsed *fish;
    int            flag_no;
    int            wins;

    GyoRaceRankingData = rank;
    race_class = GetGyoRaceClass();
    save_data = GetSaveData();

    if (GetGyoRaceNo() != 2) {
        return;
    }

    fish = GetGyoRaceFish();

    if (rank <= 2) {

        *(&fish->data.fish.unk_3d) |= 1;
    }

    if (rank == 0 && fish != NULL) {
        flag_no = short_flag_wins_class0;

        if (race_class == 0) {
            fish->data.fish.flags |= fish_flag_won_class0;
        }

        if (race_class == 1) {
            fish->data.fish.flags |= fish_flag_won_class1;
            flag_no = short_flag_wins_class1;
        }

        if (race_class == 2) {
            fish->data.fish.flags |= fish_flag_won_class2;
            flag_no = short_flag_wins_class2;
        }

        if (race_class == 3) {
            fish->data.fish.flags |= fish_flag_won_class3;
            flag_no = short_flag_wins_class3;
        }

        wins = save_data->GetShortFlag(flag_no) + 1;

        if (wins > 2) {
            wins = 2;
        }

        save_data->SetShortFlag(flag_no, wins);
    }
}

int GetGyoRaceRanking() {
    return GyoRaceRankingData;
}

/**
 *
 * Allocates the fish records for one race class from a script count.
 *
 */
static int _GYORACE_LISTNUM(SPI_STACK *stack, int arg_count) {
    int          race_class;
    int          count;
    unsigned int blocks;

    race_class = spiGetStackInt(stack++);
    spi_nowanalyze_gyorace_limmit = spiGetStackInt(stack);
    spi_gyorace_data->fish_num[race_class] = spi_nowanalyze_gyorace_limmit;
    count = spi_nowanalyze_gyorace_limmit;

    if (((unsigned int) count * sizeof(CGameDataUsed)) & 0xF) {
        blocks = (((unsigned int) count * sizeof(CGameDataUsed)) >> 4) + 1;
    } else {
        blocks = ((unsigned int) count * sizeof(CGameDataUsed)) >> 4;
    }

    spi_gyorace_data->fish[race_class] = new (spi_gyorace_stack->Alloc(blocks + 2)) CGameDataUsed[count];
    spi_nowanalyze_gyorace_data = spi_gyorace_data->fish[race_class];
    spi_gyorace_counter = 0;
    return 1;
}

/**
 *
 * Populates the next scripted fish record for the current race class.
 *
 */
static int _GYORACE_DATA(SPI_STACK *stack, int arg_count) {
    CGameDataUsed *entry;
    u8            *fields;

    if (spi_nowanalyze_gyorace_limmit <= spi_gyorace_counter) {
        return 0;
    }

    entry = &spi_nowanalyze_gyorace_data[spi_gyorace_counter];
    entry->CopyDataFish(spiGetStackInt(stack++));

    fields = (u8 *) entry + 0x10;
    entry->SetName(spiGetStackString(stack++));
    *(fields + 0x16) = spiGetStackInt(stack++);
    *(short *) (fields + 0x2E) = spiGetStackInt(stack++);
    *(short *) (fields + 0x26) = spiGetStackInt(stack++);
    *(short *) (fields + 0x28) = spiGetStackInt(stack++);
    *(short *) (fields + 0x2A) = spiGetStackInt(stack++);
    *(short *) (fields + 0x2C) = spiGetStackInt(stack++);
    *(short *) (fields + 0x18) = spiGetStackInt(stack);
    spi_gyorace_counter += 1;
    return 1;
}

int CGyoraceFishData::LoadData(mgCMemory *memory, u_long128 *buffer) {
    char saved_dir[0x80];
    char path[0x40];
    int  size;

    if (memory == NULL) {
        return 0;
    }

    fish[0] = NULL;
    fish[1] = NULL;
    fish[2] = NULL;
    fish[3] = NULL;
    fish_num[0] = 0;
    fish_num[1] = 0;
    fish_num[2] = 0;
    fish_num[3] = 0;
    spi_gyorace_data = this;
    spi_gyorace_stack = memory;
    GetCurrentDir(saved_dir);
    SetCurrentDir(NULL);
    sprintf(path, "sg/gyo/rfd%d.cfg", LanguageCode);

    if (LoadFile2(path, buffer, &size, 0) != 0) {
        CScriptInterpreter interpreter;
        interpreter.SetTag(gyorace_tag);
        interpreter.SetScript((char *) buffer, size);
        interpreter.Run();
    }

    SetCurrentDir(saved_dir);
    return 1;
}

CGameDataUsed *CGyoraceFishData::GetRaceFish(int race_class, int index) {
    if (race_class < 0 || race_class > 3) {
        return NULL;
    }

    if (fish_num[race_class] <= 0 || fish_num[race_class] <= index) {
        return NULL;
    }

    if (fish[race_class] == NULL) {
        return NULL;
    }

    return &fish[race_class][index];
}

/**
 *
 * Allocates the tournament prize group table from its scripted count.
 *
 */
static int _PRIZE_LISTNUM(SPI_STACK *stack, int arg_count) {
    unsigned int bytes;

    bytes = (unsigned int) (spiGetStackInt(stack) * sizeof(fish_prize_group));
    FishTournamentGoods = (fish_prize_group *) operator new[](
        bytes, fish_prize_buildstack->Alloc(align16_blocks(bytes) + 2));
    FishTournamentGoodsNum = 0;
    return 1;
}

/**
 *
 * Starts a tournament prize group and allocates its prize records.
 *
 */
static int _PRIZE_GROUP(SPI_STACK *stack, int arg_count) {
    int          prize_count;
    int          i;
    int          offset;
    SPI_STACK   *arg;
    unsigned int bytes;

    arg = stack + 1;
    spiFishTournamentGoods = &FishTournamentGoods[FishTournamentGoodsNum++];
    prize_count = spiGetStackInt(stack);
    i = 0;
    offset = 0;
    spiFishTournamentGoods->prize_count = prize_count;

    do {

        ((int *) ((u8 *) spiFishTournamentGoods + offset))[1] = spiGetStackInt(arg++);
        i += 1;
        offset += 4;
    } while (i < 8);

    bytes = prize_count * sizeof(fish_prize_record);
    spiFishTournamentGoods->prizes = (fish_prize_record *) operator new[](
        bytes, fish_prize_buildstack->Alloc(align16_blocks(bytes) + 2));
    spi_fish_prize_info = spiFishTournamentGoods->prizes;
    return 1;
}

/**
 *
 * Adds a scripted rank prize to the current tournament group.
 *
 */
static int _PRIZE(SPI_STACK *stack, int arg_count) {
    SPI_STACK *arg;

    arg = stack + 1;

    if (spi_fish_prize_info == NULL) {
        return 0;
    }

    spi_fish_prize_info->unk_0 = spiGetStackInt(stack);
    spi_fish_prize_info->rank[0].unk_0 = spiGetStackInt(arg++);
    spi_fish_prize_info->rank[0].unk_4 = spiGetStackInt(arg++);
    spi_fish_prize_info->rank[1].unk_0 = spiGetStackInt(arg++);
    spi_fish_prize_info->rank[1].unk_4 = spiGetStackInt(arg++);
    spi_fish_prize_info->rank[2].unk_0 = spiGetStackInt(arg++);
    spi_fish_prize_info->rank[2].unk_4 = spiGetStackInt(arg);
    spi_fish_prize_info++;
    return 1;
}

void InitFishPrize() {
    fish_prize_buildstack = 0;
    FishTournamentGoods = 0;
    FishTournamentGoodsNum = 0;
    spi_fish_prize_info = 0;
}

#pragma optimization_level 4

int LoadFishPrize(int goods_type) {
    u8        buffer[0x2800];
    mgCMemory memory;
    memory.stSetBuffer((u_long128 *) buffer, 0x280);
    memory.Align64();
    LoadFishPrize(goods_type, &memory);
    return 0;
}

#pragma optimization_level reset

int LoadFishPrize(int goods_type, mgCMemory *pool) {
    u8    buffer[0x2800];
    int   size;
    void *script;

    InitFishPrize();
    script = (void *) MenuCalcBufAlignment((u_long128 *) buffer);
    FishTournamentGoodsType = goods_type;

    if (FishTournamentGoodsType < 0 || FishTournamentGoodsType >= 2) {
        FishTournamentGoodsType = 0;
    }

    if (LoadFile2(filename_4899[FishTournamentGoodsType], script, &size, 0) != 0) {
        fish_prize_buildstack = pool;
        CScriptInterpreter interpreter;
        interpreter.SetTag(gyoprize_tag);
        interpreter.SetScript((char *) script, size);
        interpreter.Run();
    }

    RefreshFishPrize();
    return 1;
}

int RefreshFishPrize() {
    CSaveData         *save_data;
    fish_prize_group  *group;
    fish_prize_record *prize;
    int                race_class;
    int                flag_no;

    save_fish_prize_list = NULL;
    save_data = GetSaveData();

    if (FishTournamentGoodsType == 0) {
        for (race_class = 0, flag_no = short_flag_wins_class0; race_class < 4; race_class++) {
            s16 wins = save_data->GetShortFlag(flag_no);
            group = FishTournamentGoods + race_class * 3 + wins;
            flag_no++;

            if (group == NULL) {
                return 0;
            }

            save_fish_prize_list = group->prizes;
            prize = save_fish_prize_list;
            fish_save_present[race_class][0] = prize->rank[0];
            fish_save_present[race_class][1] = prize->rank[1];
            fish_save_present[race_class][2] = prize->rank[2];
        }

        return 0;
    }

    group = &FishTournamentGoods[save_data->GetShortFlag(short_flag_tour_count)];
    save_fish_prize_list = group->prizes;
    fish_save_present[0][0] = save_fish_prize_list->rank[0];
    fish_save_present[0][1] = save_fish_prize_list->rank[1];
    fish_save_present[0][2] = save_fish_prize_list->rank[2];
    return 0;
}

int GetFishPrize(int race_no, int rank, FISH_PRIZE_INFO *info) {
    if (info == NULL) {
        return 0;
    }

    if (race_no < 0) {
        race_no = 0;
    }

    if (race_no > 3) {
        race_no = 3;
    }

    if (rank < 0) {
        rank = 0;
    }

    if (rank > 2) {
        rank = 2;
    }

    if (save_fish_prize_list != NULL) {
        info->unk_0 = fish_save_present[race_no][rank].unk_0;
        info->unk_4 = fish_save_present[race_no][rank].unk_4;
    }

    return 1;
}

void TuriTourCount() {
    CSaveData *save_data;
    int        count;
    int        last_tour;

    save_data = GetSaveData();

    if (save_data == NULL) {
        return;
    }

    count = save_data->GetShortFlag(short_flag_tour_count) + 1;
    last_tour = 9;

    if (save_data->GetBitFlag(bit_flag_tour_cycled) != 0) {
        last_tour = 8;
    }

    if (count > last_tour) {
        count = 1;
        save_data->SetBitFlag(bit_flag_tour_cycled, count);
    }

    save_data->SetShortFlag(short_flag_tour_count, count);
}

/**
 *
 * Applies a gyorace menu configuration command to its script buffer.
 *
 */
static void GyoraceCFGAnalyze(char *command) {
    MenuCommandAnalyze(GyoraceExeCfgBuffer, GyoraceExeCfgBufferSize, command);
}

/**
 *
 * Finds an empty bonus racer slot or retrieves the racer index in a given slot.
 *
 */
static int SearchOmakeGyoracer(int slot) {
    int i;

    if (slot < 0) {
        for (i = 0; i < omake_racer_slot_count; i++) {
            if (0 > GyoracerIndexNo[i]) {
                return i;
            }
        }

        return -1;
    }

    return GyoracerIndexNo[slot];
}

int CheckSameRacerFish(int fish_no) {
    int i;

    for (i = 0; i < omake_racer_slot_count; i++) {
        if (fish_no == GyoracerIndexNo[i]) {
            return i;
        }
    }

    return -1;
}

CGameDataUsed *GetOmakeGyoracer2(int slot) {
    int           index;
    GYORACE_DATA *record;

    index = SearchOmakeGyoracer(slot);

    if (index < 0) {
        return NULL;
    }

    record = GyoraceData->GetData(index);

    if (record == NULL) {
        return NULL;
    }

    if (record->fish.used_type == gyorace_type_omake_racer) {
        return &record->fish;
    }

    return NULL;
}

int GetOmakeGyoracerTactics(int slot) {
    if (slot < 0 || slot > 5) {
        return -1;
    }

    return GyoracerTacticsNo[slot];
}

void SetOmakeGyoracerTactics(int slot, int tactics) {
    if (slot < 0 || slot > 5) {
        return;
    }

    GyoracerTacticsNo[slot] = tactics;
}

/**
 *
 * Refreshes the displayed names of registered bonus racers.
 *
 */
static void GyoracerListUpdate() {
    ((ClsMes *) GyoraceFishMes)->mes_no = -1;

    for (int slot = 0; slot < 6; slot++) {
        int data_index = GyoracerIndexNo[slot];

        if (0 <= data_index) {
            GYORACE_DATA *record = GyoraceData->GetData(data_index);
            char         *name = record->fish.GetName(0);
            CDC2Mes      *message = GyoraceFishMes;

            if (name != NULL) {
                strcpy(message->name[slot], name);
            }
        } else {
            char    *name = Mitouroku[LanguageCode];
            CDC2Mes *message = GyoraceFishMes;

            if (name != NULL) {
                strcpy(message->name[slot], name);
            }
        }
    }

    GyoraceFishMes->fade_speed = 1.0f;
    GyoraceFishMes->MakeMsg(5001);
}

void GyoraceSubGameInitData() {
    GyoracerIndexNo[0] = -1;
    GyoracerTacticsNo[0] = -1;
    GyoracerIndexNo[1] = -1;
    GyoracerTacticsNo[1] = -1;
    GyoracerIndexNo[2] = -1;
    GyoracerTacticsNo[2] = -1;
    GyoracerIndexNo[3] = -1;
    GyoracerTacticsNo[3] = -1;
    GyoracerIndexNo[4] = -1;
    GyoracerTacticsNo[4] = -1;
    GyoracerIndexNo[5] = -1;
    GyoracerTacticsNo[5] = -1;
}

void GyoraceMenuInit(mgCMemory *memory, int *tex_block, int) {
    int    i;
    short *system_mes;
    short *menu_mes;
    int    language;

    int rest = memory->stGetRest();
    GyoraceStack.stSetBuffer(memory->stGetTop(), rest);

    for (i = 0; i < 16; i++) {
        GyoraceTexBlock[i] = tex_block[i];
    }

    GyoraceTexBlock[15] = -1;
    MenuDeleteTextureBlock(GyoraceTexBlock);
    MenuArg.result[0] = 0;
    SubSaveData = GetSubGameSaveData();

    if (SubSaveData == NULL) {
        return;
    }

    GyoraceData = SubSaveData->GetGyoRaceData();

    if (GyoraceData == NULL) {
        return;
    }

    GyoracerActive = NULL;
    GyoraceFishTex = NULL;
    MenuLoadBoardTex = NULL;
    GyoraceExeCfgBuffer = NULL;
    GyoraceExeCfgBufferSize = 0;
    GyoraceQuestionMsgDrawFlag = 0;
    memcpy(&GyoraceMenuOptionBuff, GetSaveData()->GetConfig(), sizeof(SV_CONFIG_OPTION));
    system_mes = GetSystemMesBuffer();
    menu_mes = GetMenuMainMessageBuffer();
    language = LanguageCode;
    GyoraceMes = new (GyoraceStack.Alloc(sizeof(CDC2Mes) / 16 + 2)) CDC2Mes;
    GyoraceMes->SetMessData(system_mes, menu_mes);
    GyoraceMes->MsgPreset(0x12, language);
    GyoraceMes->SetPutPos(0x1E, 0x4C, -1, -1);

    if (language > 0) {
        GyoraceMes->SetPutPos(0xC, 0x4C, -1, -1);
    }

    GyoraceMes->MakeMsg(0x13A6);
    GyoraceMes->SetMsgCursor(0);
    GyoraceMesDrawFlag = 1;
    GyoraceFishMes = new (GyoraceStack.Alloc(sizeof(CDC2Mes) / 16 + 2)) CDC2Mes;
    GyoraceFishMes->SetMessData(system_mes, menu_mes);
    GyoraceFishMes->MsgPreset(0x10, language);
    GyoraceFishMes->SetPutPos(0x116, 0x6C, 0xF0, -1);
    GyoraceFishMes->MakeMsg(0x1389);
    GyoraceFishHave = new (GyoraceStack.Alloc(sizeof(CDC2Mes) / 16 + 2)) CDC2Mes;
    GyoraceFishHave->SetMessData(system_mes, menu_mes);
    GyoraceFishHave->MsgPreset(0x10, language);
    GyoraceFishHave->MakeMsg(0x3C);
    GyoraceFishTacMes = MenuDCMsg[1];
    GyoraceFishHaveDrawFlag = 0;
    GyoraceFishTacMes->SetMessData(menu_mes, menu_mes);
    GyoraceFishTacMes->MsgPreset(0x10, language);
    GyoraceFishTacMes->MakeMsg(-1);
    GyoraceFishHaveListSelect.cursor = 0;
    GyoraceHaveFishListTopY = 60.0f;
    GyoraceFishTacMesDrawFlag = 0;
    GyoraceFishInfoDrawFlag = 0;
    GyoracerActive = NULL;
    GyoraceHaveFishListMakeLine = 0;
    GyoraceFishHaveListSelect.top = 0;
    Gyoracemenu_long_hand_count = 0;
    GyoraceHaveFishCursorDrawFlag = 0;
    GyoraceHaveFishCursor = 0.0f;
    GyoracerListUpdate();
    MenuBGTextureBlock = GyoraceTexBlock[0];
    GyoraceHaveFishListScrlInit = 0;
    MenuCapture(MenuBGTextureBlock, &GyoraceStack, 1);
    MenuPosData->AttachCommonTexInfo();
    MenuCommonInfo->key_enable = 1;
    GyoraceNowMode = GYORACE_MENU_LOAD;
    GyoraceNowPhase = 0;
    StartReadBG();
    GyoraceStack.Alloc(align16_blocks(LoadFileMenu("omake.pac", GyoraceStack.stGetTop(), 0) + 0xC00));
}

/**
 *
 * Converts race menu input to list movement and flags long scrolls.
 *
 */
static int OmakeGyoraceSelect(int key) {
    int movement = MenuListSelectKeyCheck(key, 8);
    int distance = abs(movement);

    if (distance > 3) {
        GyoraceHaveFishListScrlInit = 1;
    }

    return movement;
}

/**
 *
 * Keeps the fish list viewport and cursor aligned with an available entry.
 *
 */
static void ForceSetGyoList() {
    int slot = -1;

    if (GyoraceData->SearchSpaceData(&slot) == 0) {
        return;
    }

    while (slot < GyoraceFishHaveListSelect.top) {
        GyoraceFishHaveListSelect.top--;
    }

    while (slot >= GyoraceFishHaveListSelect.top + 9) {
        GyoraceFishHaveListSelect.top++;
    }

    while (GyoraceFishHaveListSelect.top + 9 <= GyoraceFishHaveListSelect.cursor) {
        GyoraceFishHaveListSelect.cursor--;
    }

    while (GyoraceFishHaveListSelect.cursor < GyoraceFishHaveListSelect.top) {
        GyoraceFishHaveListSelect.cursor++;
    }
}

static inline void SetHaveName(CDC2Mes *mes, int k, char *name) {
    if (name != NULL) {
        strcpy(mes->name[k], name);
    }
}

int GyoraceMenuKey() {
    /** Stores the fish being renamed while the name-entry menu is open. */
    static CGameDataUsed *local_gdata = NULL;
    CDC2Mes              *ask = MenuDCMsg[0];
    CDC2Mes              *tactics_mes = MenuDCMsg[1];
    int                   list_update = 0;
    int                   scroll_init = 0;
    int                   next = -1;
    int                   key;
    int                   button;
    int                   old_top;
    int                   cursor;
    int                   racer_num;
    int                   se;
    int                   i;
    char                 *name;
    GYORACE_DATA         *racer;

    GyoraceHaveFishListScrlInit = 0;
    key = MenuCommonInfo->CheckSelectKey();
    key |= MenuCommonInfo->CheckLRKey();
    button = MenuCommonInfo->CheckPushButton();
    old_top = GyoraceFishHaveListSelect.top;
    /** Keeps the selected saved-racer slot through the tactics prompt. */
    static s8 save_now_space_racer_no = 0;
    switch (GyoraceNowMode) {
        case GYORACE_MENU_LOAD:
            if (ReadBGSync() == 0) {
                BG_READ_INFO      *file;
                u_int             *image;
                mgCTextureManager *textures;

                GyoraceNowMode = GYORACE_MENU_MAIN;
                file = GetReadBGFile(0);
                textures = &mgTexManager;
                image = GetPackFile(reinterpret_cast<u_int *>(file->buffer), "omake.img", NULL);
                if (image != NULL) {
                    textures->EnterIMGFile(reinterpret_cast<u_char *>(image), GyoraceTexBlock[1], NULL, NULL);
                }
                image = GetPackFile(reinterpret_cast<u_int *>(file->buffer), "allitem.img", NULL);
                if (file != NULL) {
                    textures->EnterIMGFile(reinterpret_cast<u_char *>(image), GyoraceTexBlock[1], NULL, NULL);
                }
                GyoraceExeCfgBuffer = reinterpret_cast<char *>(
                    GetPackFile(reinterpret_cast<u_int *>(file->buffer), "omake_gyo.cfg", &GyoraceExeCfgBufferSize));
                MenuMainImageDataEnter(GyoraceTexBlock[1]);
                GyoraceFishTex = textures->GetTexture("omaketx", -1);
                GyoraceCursor = textures->GetTexture("mnmain", -1);
                Tex_Aqualium = textures->GetTexture("amenu0", -1);
                MenuLoadBoardTex = textures->GetTexture("mt0", -1);
                MenuPosData->AttachCommonTexInfo();
                scroll_init = 1;
                GyoraceHaveFishListScrlInit = scroll_init;
            }
            break;
        case GYORACE_MENU_MAIN:
            cursor = GyoraceMes->AddMsgCursor2(GYORACE_COMMAND_REGISTER, GYORACE_COMMAND_START, 1);
            if (button & MENU_PUSH_BUTTON_DECIDE) {
                GYORACE_DATA *space;

                racer_num = 0;
                for (i = 0; i < 6; i++) {
                    if (0 <= GyoracerIndexNo[i]) {
                        racer_num++;
                    }
                }
                space = GyoraceData->SearchSpaceData(NULL);
                se = SYSTEM_SE_DECIDE;
                switch (cursor) {
                    case GYORACE_COMMAND_REGISTER:
                        if (space == NULL) {
                            GyoraceNowMode = GYORACE_MENU_REGISTER_FULL;
                            GyoraceQuestionMsgDrawFlag = se;
                            GyoraceMes->cursor_on = 0;
                            GyoraceCFGAnalyze("\x93\x6f\x98\x5e\x95\x73\x89\xc2");
                            se = SYSTEM_SE_CANCEL;
                        } else {
                            Nameregi_Target.target = 3;
                            local_gdata = &space->fish;
                            Nameregi_Target.item = &space->fish;
                            MenuMainScene->fade.FadeOut(40, 0.0f, 0.0f, 0.0f);
                            GyoraceNowMode = GYORACE_MENU_RENAME_FADE;
                        }
                        break;
                    case GYORACE_COMMAND_ASSIGN:
                    case GYORACE_COMMAND_DELETE:
                        if (cursor == GYORACE_COMMAND_ASSIGN) {
                            GyoraceNowMode = GYORACE_MENU_ASSIGN_FISH;
                        }
                        if (cursor == GYORACE_COMMAND_DELETE) {
                            GyoraceNowMode = GYORACE_MENU_DELETE_FISH;
                        }
                        list_update = 1;
                        GyoraceMes->cursor_on = 0;
                        GyoraceMesDrawFlag = 0;
                        GyoraceFishHaveDrawFlag = list_update;
                        GyoraceHaveFishCursorDrawFlag = list_update;
                        GyoraceHaveFishListScrlInit = list_update;
                        break;
                    case GYORACE_COMMAND_WITHDRAW:
                        if (racer_num <= 0) {
                            se = SYSTEM_SE_CANCEL;
                        } else {
                            GyoraceNowMode = GYORACE_MENU_WITHDRAW_CONFIRM;
                            GyoraceQuestionMsgDrawFlag = se;
                            GyoraceCFGAnalyze("\x8e\x51\x89\xc1\x8e\xe6\x8f\xc1\x81\x48");
                        }
                        break;
                    case GYORACE_COMMAND_TACTICS:
                        GyoraceNowMode = GYORACE_MENU_VIEW_TACTICS;
                        GyoraceFishInfoDrawFlag = se;
                        GyoracerActive = NULL;
                        GyoraceFishTacMesDrawFlag = se;
                        tactics_mes->MsgPreset(6);
                        tactics_mes->MakeMsg(0x139A);
                        if (LanguageCode > 0) {
                            tactics_mes->point_x = 0x64;
                        }
                        tactics_mes->point_y = 0x50;
                        GyoraceMes->cursor_on = 0;
                        GyoraceFishMes->SetMsgCursor(0);
                        break;
                    case GYORACE_COMMAND_START:
                        if (racer_num <= 0) {
                            se = SYSTEM_SE_CANCEL;
                        } else {
                            GyoraceNowMode = GYORACE_MENU_START_CONFIRM;
                            GyoraceQuestionMsgDrawFlag = se;
                            GyoraceCFGAnalyze("\x8b\xa3\x8b\x5a\x8a\x4a\x8e\x6e\x81\x48");
                        }
                        break;
                    case GYORACE_COMMAND_SAVE:
                        GyoraceNowMode = GYORACE_MENU_SAVE_FADE;
                        MenuMainScene->fade.FadeOut(40, 0.0f, 0.0f, 0.0f);
                        break;
                }
                MenuSePlay(se);
            } else if (button & MENU_PUSH_BUTTON_CANCEL) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                return 2;
            } else if (DebugFlag == 1 && (button & MENU_PUSH_BUTTON_TRIANGLE)) {
                char debug_name[20] = "AAAAAAAAAAaaaaaaaaa";
                char debug_pass[14] = {0x47, 0x01, 0x09, 0x05, 0xF9, 0x01, 0xBB, 0x03, 0x0A, 0x03, 0x06, 0x00, 0x00, 0x00};

                GyoraceData->data[0].fish.Init();
                GyoraceData->data[0].fish.TransToData(debug_pass, 14);
                GyoraceData->data[0].fish.SetName(debug_name);
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            break;
        case GYORACE_MENU_REGISTER_FULL:
            if (button != 0) {
                next = GYORACE_MENU_MAIN;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
        case GYORACE_MENU_RENAME_FADE:
            if (MenuMainScene->fade.FadeCheck() != 0) {
                GyoraceNowMode = GYORACE_MENU_RENAME;
                NameRegistInit(&GyoraceStack, &GyoraceTexBlock[5], 0);
            }
            break;
        case GYORACE_MENU_RENAME:
            if (NameRegistKey() != 0) {
                local_gdata = NULL;
                MenuMainScene->fade.FadeIn(20);
                GyoraceNowMode = GYORACE_MENU_MAIN;
                GyoracerListUpdate();
            }
            break;
        case GYORACE_MENU_ASSIGN_FISH:
            if (MenuKeySelectCheck(OmakeGyoraceSelect(key), &GyoraceFishHaveListSelect.cursor,
                                   &GyoraceFishHaveListSelect.top, 0, 0x40, 9, 0) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                if (old_top != GyoraceFishHaveListSelect.top) {
                    GyoraceHaveFishListMakeLine = (old_top < GyoraceFishHaveListSelect.top) ? 1 : 0;
                    list_update = 1;
                }
            }
            if (button & MENU_PUSH_BUTTON_DECIDE) {
                int slot;

                racer = GyoraceData->GetData(GyoraceFishHaveListSelect.cursor);
                slot = SearchOmakeGyoracer(-1);
                if (racer == NULL || slot < 0) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else if (racer->IsUsed() == 0 || 0 <= CheckSameRacerFish(GyoraceFishHaveListSelect.cursor)) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else {
                    save_now_space_racer_no = slot;
                    GyoracerIndexNo[slot] = GyoraceFishHaveListSelect.cursor;
                    GyoracerListUpdate();
                    GyoracerTacticsNo[slot] = 0;
                    list_update = 1;
                    GyoraceFishTacMesDrawFlag = list_update;
                    GyoraceCFGAnalyze("\x8d\xec\x90\xed\x91\x49\x91\xf0");
                    tactics_mes->SetMsgItemNo(vol_5253, 6);
                    tactics_mes->select_top = list_update;
                    tactics_mes->SetWindowBgOpaqueFlg(list_update);
                    GyoraceNowMode = GYORACE_MENU_SELECT_TACTICS;
                }
            } else if (button & MENU_PUSH_BUTTON_CANCEL) {
                next = GYORACE_MENU_MAIN;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
        case GYORACE_MENU_SELECT_TACTICS:
            cursor = tactics_mes->AddMsgCursor2(1, 6, 1);
            if (button & MENU_PUSH_BUTTON_DECIDE) {
                CGameDataUsed *racer_fish;

                GyoracerTacticsNo[save_now_space_racer_no] = cursor - 1;
                GyoraceCFGAnalyze("\x8d\xec\x90\xed\x8c\x88\x92\xe8");
                name = NULL;
                racer_fish = GetOmakeGyoracer2(save_now_space_racer_no);
                if (racer_fish != NULL) {
                    name = racer_fish->GetName(0);
                }
                if (name != NULL) {
                    strcpy(tactics_mes->name[0], name);
                }
                tactics_mes->SetWindowBgOpaqueFlg(0);
                GyoraceNowMode = GYORACE_MENU_TACTICS_RESULT;
            } else if (button & MENU_PUSH_BUTTON_CANCEL) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                GyoraceFishTacMesDrawFlag = 0;
                tactics_mes->SetWindowBgOpaqueFlg(0);
                GyoraceNowMode = GYORACE_MENU_ASSIGN_FISH;
            }
            break;
        case GYORACE_MENU_TACTICS_RESULT:
            if (button != 0) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                GyoraceFishTacMesDrawFlag = 0;
                GyoraceNowMode = GYORACE_MENU_ASSIGN_FISH;
            }
            break;
        case GYORACE_MENU_DELETE_FISH:
            if (MenuKeySelectCheck(OmakeGyoraceSelect(key), &GyoraceFishHaveListSelect.cursor,
                                   &GyoraceFishHaveListSelect.top, 0, 0x40, 9, 0) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                if (old_top != GyoraceFishHaveListSelect.top) {
                    GyoraceHaveFishListMakeLine = (old_top < GyoraceFishHaveListSelect.top) ? 1 : 0;
                    list_update = 1;
                }
            }
            if (button & MENU_PUSH_BUTTON_DECIDE) {
                racer = GyoraceData->GetData(GyoraceFishHaveListSelect.cursor);
                if (racer == NULL) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else if (racer->IsUsed() == 0) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else {
                    GyoraceQuestionMsgDrawFlag = 1;
                    name = racer->fish.GetName(0);
                    if (0 <= CheckSameRacerFish(GyoraceFishHaveListSelect.cursor)) {
                        GyoraceNowMode = GYORACE_MENU_ALREADY_ASSIGNED;
                        GyoraceCFGAnalyze("\x8b\x9b\x8f\xc1\x82\xb9\x82\xc8\x82\xa2");
                        if (name != NULL) {
                            strcpy(ask->name[0], name);
                        }
                    } else {
                        GyoraceNowMode = GYORACE_MENU_DELETE_CONFIRM;
                        GyoraceCFGAnalyze("\x8b\x9b\x8f\xc1\x82\xb7\x81\x48");
                        if (name != NULL) {
                            strcpy(ask->name[0], name);
                        }
                    }
                }
            } else if (button & MENU_PUSH_BUTTON_CANCEL) {
                next = GYORACE_MENU_MAIN;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
        case GYORACE_MENU_DELETE_CONFIRM: {
            int answer = ask->YesNoCursor2(0);

            if (answer == 1) {
                racer = GyoraceData->GetData(GyoraceFishHaveListSelect.cursor);
                if (racer != NULL) {
                    racer->Init();
                }
                list_update = 1;
                GyoraceNowMode = GYORACE_MENU_DELETE_FISH;
                GyoraceQuestionMsgDrawFlag = 0;
                MenuSePlay(list_update);
            }
            if (answer == 2) {
                GyoraceNowMode = GYORACE_MENU_DELETE_FISH;
                GyoraceQuestionMsgDrawFlag = 0;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
        }
        case GYORACE_MENU_ALREADY_ASSIGNED:
            if (button != 0) {
                GyoraceNowMode = GYORACE_MENU_DELETE_FISH;
                GyoraceQuestionMsgDrawFlag = 0;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            break;
        case GYORACE_MENU_WITHDRAW_CONFIRM: {
            int answer = ask->YesNoCursor2(0);

            if (answer == 1) {
                GyoraceSubGameInitData();
                GyoracerListUpdate();
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            if (answer == 2) {
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            if (0 < answer) {
                next = GYORACE_MENU_MAIN;
            }
            break;
        }
        case GYORACE_MENU_ACKNOWLEDGE:
            if (button != 0) {
                next = GYORACE_MENU_MAIN;
                MenuSePlay(next);
            }
            break;
        case GYORACE_MENU_VIEW_TACTICS: {
            int old_cursor = GyoraceFishMes->GetMsgCursor();
            int racer_slot = GyoraceFishMes->AddMsgCursor2(0, 5, 0);

            GyoracerActive = GetOmakeGyoracer2(racer_slot);
            if (old_cursor != racer_slot) {
                MenuSePlay(SYSTEM_SE_CURSOR);
            }
            if (button & MENU_PUSH_BUTTON_CANCEL) {
                next = GYORACE_MENU_MAIN;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            int tactics[1] = {-1};
            if (GyoracerActive != NULL) {
                tactics[0] = GyoracerTacticsNo[racer_slot] + 0x139C;
            }
            tactics_mes->SetMsgItemNo(tactics, 1);
            break;
        }
        case GYORACE_MENU_START_CONFIRM: {
            int answer = ask->YesNoCursor2(0);

            if (answer == 1) {
                GyoraceNowMode = GYORACE_MENU_START_FADE;
                MenuArg.end_code = 0x11;
                MenuArg.result[0] = 1000;
                GyoraceQuestionMsgDrawFlag = 0;
                MenuMainScene->fade.FadeOut(40, 0.0f, 0.0f, 0.0f);
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            if (answer == 2) {
                next = GYORACE_MENU_MAIN;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }
            break;
        }
        case GYORACE_MENU_START_FADE:
            if (MenuMainScene->fade.FadeCheck() != 0) {
                return 2;
            }
            break;
        case GYORACE_MENU_SAVE_FADE:
            if (MenuMainScene->fade.FadeCheck() != 0) {
                GyoraceNowMode = GYORACE_MENU_SAVE;
                MenuSaveInit(&GyoraceStack, &GyoraceTexBlock[5], 0x1E);
            }
            break;
        case GYORACE_MENU_SAVE:
            if (0 < MenuSaveKey()) {
                MenuLoadFishIsLoad = 0;
                if (MenuArg.end_code == 10) {
                    MenuLoadFishIsLoad = 1;
                }
                next = GYORACE_MENU_RETURN_FROM_SAVE;
                MenuMainScene->fade.FadeIn(30);
                MenuArg.end_code = 0;
                MenuArg.result[0] = 0;
            }
            break;
        case GYORACE_MENU_RETURN_FROM_SAVE:
            if (MenuMainScene->fade.FadeCheck() != 0) {
                next = GYORACE_MENU_MAIN;
                if (MenuLoadFishIsLoad == 1) {
                    next = GYORACE_MENU_LOAD_FISH;
                }
            }
            break;
        case GYORACE_MENU_LOAD_FISH:
            if (MenuLoadFishBoardX > 0xE0) {
                CalcMenu1(0xE0, &MenuLoadFishBoardX, 3, 3, 0);
            } else {
                MenuItemBrdKey(key, &MenuLoadFishSelect, &MenuLoadFishTopLine, 1);
                CGameDataUsed *item = MenuDrawItemInfo[MenuLoadFishSelect];
                GyoracerActive = item;
                if (button & MENU_PUSH_BUTTON_CANCEL) {
                    next = GYORACE_MENU_RESET_CONFIRM;
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else if (button & MENU_PUSH_BUTTON_DECIDE) {
                    MenuLoadFishSelectData = item;
                    if (GyoraceData->SearchSpaceData(NULL) == NULL || MenuLoadFishSelectData == NULL) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        next = GYORACE_MENU_ASSIGN_CONFIRM;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }
                }
            }
            break;
        case GYORACE_MENU_RESET_CONFIRM:
        case GYORACE_MENU_ASSIGN_CONFIRM: {
            int answer = ask->YesNoCursor2(0);

            if (answer == 1) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                if (GyoraceNowMode == GYORACE_MENU_RESET_CONFIRM) {
                    next = GYORACE_MENU_MAIN;
                    InitSaveData();
                    InitOmakeEnv(next, NULL, NULL);
                    memcpy(GetSaveData()->GetConfig(), &GyoraceMenuOptionBuff, sizeof(SV_CONFIG_OPTION));
                }
                if (GyoraceNowMode == GYORACE_MENU_ASSIGN_CONFIRM) {
                    GYORACE_DATA *space = GyoraceData->SearchSpaceData(NULL);

                    if (space != NULL && MenuLoadFishSelectData != NULL) {
                        ForceSetGyoList();
                        space->Init();
                        space->fish.CopyGameData(MenuLoadFishSelectData);
                        list_update = 1;
                        next = GYORACE_MENU_ASSIGN_RESULT;
                        GyoraceHaveFishListScrlInit = list_update;
                    } else {
                        break;
                    }
                }
            }
            if (answer == 2) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                if (GyoraceNowMode == GYORACE_MENU_RESET_CONFIRM) {
                    next = GYORACE_MENU_LOAD_FISH;
                }
                if (GyoraceNowMode == GYORACE_MENU_ASSIGN_CONFIRM) {
                    next = GYORACE_MENU_LOAD_FISH;
                }
            }
            break;
        }
        case GYORACE_MENU_ASSIGN_RESULT:
            if (button != 0) {
                next = GYORACE_MENU_LOAD_FISH;
                MenuLoadFishSelectData->Init();
                MenuLoadFishSelectData = NULL;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            break;
    }
    if (0 <= next) {
        switch (next) {
            case GYORACE_MENU_MAIN:
                GyoraceMesDrawFlag = 1;
                GyoraceFishHaveDrawFlag = 0;
                GyoraceFishInfoDrawFlag = 0;
                GyoraceFishTacMesDrawFlag = 0;
                GyoraceQuestionMsgDrawFlag = 0;
                GyoraceMes->cursor_on = 1;
                GyoraceFishMes->SetMsgCursor(-1);
                break;
            case GYORACE_MENU_RETURN_FROM_SAVE:
                GyoraceFishInfoDrawFlag = 0;
                if (MenuLoadFishIsLoad != 0) {
                    int bag_max;

                    MenuLoadFishSelect = 0;
                    MenuLoadFishTopLine = 0;
                    SetModeMenuDrawItemBoard(4);
                    bag_max = GetNowBagMax(1);
                    MenuItemBrdSetInfo(MenuLoadFishSelect, MenuLoadFishTopLine, bag_max / 6, 5);
                    MenuItemBrdCalcManner = 0;
                    list_update = 1;
                    GyoraceMes->cursor_on = 0;
                    Gyoracemenu_CursorXY[0] = 206.0f;
                    Gyoracemenu_CursorXY[1] = 28.0f;
                    MenuLoadFishBoardX = 0x208;
                    GyoraceFishInfoDrawFlag = list_update;
                    GyoracerActive = NULL;
                }
                break;
            case GYORACE_MENU_LOAD_FISH:
                SetModeMenuDrawItemBoard(4);
                GyoraceQuestionMsgDrawFlag = 0;
                GyoraceFishHaveDrawFlag = 1;
                GyoraceHaveFishCursorDrawFlag = 0;
                break;
            case GYORACE_MENU_RESET_CONFIRM:
            case GYORACE_MENU_ASSIGN_CONFIRM:
                GyoraceQuestionMsgDrawFlag = 1;
                ask->MsgPreset(0xB);
                ask->SetAbsPos(5);
                ask->SetMsgCursor(1);
                if (next == GYORACE_MENU_RESET_CONFIRM) {
                    ask->MakeMsg(0x13AC);
                }
                if (next == GYORACE_MENU_ASSIGN_CONFIRM) {
                    ask->MakeMsg(0x1393);
                    if (MenuLoadFishSelectData != NULL) {
                        name = MenuLoadFishSelectData->GetName(0);
                        if (name != NULL) {
                            strcpy(ask->name[0], name);
                        }
                    }
                }
                break;
            case GYORACE_MENU_ASSIGN_RESULT:
                GyoraceCFGAnalyze("\x8b\x9b\x93\x6f\x98\x5e\x8f\x49\x97\xb9");
                name = MenuLoadFishSelectData->GetName(0);
                if (name != NULL) {
                    strcpy(ask->name[0], name);
                }
                break;
        }
        GyoraceNowMode = next;
    }
    if (GyoraceFishHave != NULL) {
        int top = GyoraceFishHaveListSelect.top;
        int line_y;

        if (GyoraceHaveFishListMakeLine == 1) {
            top--;
            if (top < 0) {
                top = 0;
            }
        }
        if (list_update != 0) {
            GYORACE_DATA *entry = GyoraceData->GetData(top);
            for (int k = 0; k < 10 && entry != NULL; entry++, k++) {
                name = Mitouroku[LanguageCode];
                SetHaveName(GyoraceFishHave, k, name);
                if (entry->IsUsed() != 0) {
                    name = entry->fish.GetName(0);
                    SetHaveName(GyoraceFishHave, k, name);
                }
            }
            GyoraceFishHave->ClsMes::mes_no = -1;
            GyoraceFishHave->MakeMsg(0x3C);
        }
        CalcMenu1(-26.0f * GyoraceFishHaveListSelect.top, &GyoraceHaveFishListTopY, 3.5f, 3.0f,
                  GyoraceHaveFishListScrlInit);
        line_y = (int) ((int) (112.0f + GyoraceHaveFishListTopY) + 26.0f * top);
        for (int j = 0; j < 10; j++) {
            CDC2Mes *have = GyoraceFishHave;
            if (j >= 0 && j < 20) {
                have->line_pos[j][0] = 0x32;
                have->line_pos[j][1] = line_y;
                have->line_pos_on[j] = 1;
            }
            line_y += 26.0f;
        }
    }
    if (GyoraceMes != NULL) {
        GyoraceMes->StepMsg();
        GyoraceFishMes->StepMsg();
        GyoraceFishHave->StepMsg();
        tactics_mes->StepMsg();
    }
    if (ask != NULL) {
        ask->StepMsg();
    }
    CalcMenu1(114.0f + 26.0f * (GyoraceFishHaveListSelect.cursor - GyoraceFishHaveListSelect.top),
              &GyoraceHaveFishCursor, 3.6f, 3.0f, scroll_init);
    return 0;
}

void GyoraceMenuDraw() {
    mgCTextureManager *textures;
    mgCDrawPrim       *prim;
    int                i;
    int                y;
    int                show_cursor;
    int                board_x;
    int                frame_block;

    switch (GyoraceNowMode) {
        case GYORACE_MENU_RENAME:
            NameRegistDraw();
            break;
        case GYORACE_MENU_SAVE:
            MenuSaveDraw();
            break;
        default: {
            mgRect<int> bg_tex;
            int         list_rect[4];
            mgRect<int> board;
            mgRect<int> cursor_rect;
            mgRect<int> bg_put;
            mgRect<int> bg_edge;
            mgRect<int> title;
            mgRect<int> wide_title;
            mgRect<int> label;
            mgRect<int> clip;
            mgRect<int> have_clip;

            textures = &mgTexManager;
            bg_tex.Set(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
            frame_block = -1;
            bg_put.Set(0, 0, mgScreenWidth, mgScreenHeight);
            DrawMenuMainFrmImg(frame_block, bg_put, bg_tex, 0x80, 0x80, 0x80, 0x80, 1);
            bg_edge.Set(-1, -1, mgScreenWidth + 1, mgScreenHeight + 1);
            DrawMenuMainFrmImg(frame_block, bg_edge, bg_tex, 0x80, 0x80, 0x80, 0x80, 0);

            if (GyoraceFishTex == NULL) {
                return;
            }

            textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);

            if (GyoraceMesDrawFlag != 0) {
                GyoraceMes->DrawMsg();
            }

            prim = GetMenuPrim();
            textures->ReloadTexture(GyoraceTexBlock[1], (sceVif1Packet *) NULL);

            if (LanguageCode == 0) {

                DrawSubGameTitle(GyoraceFishTex, 0, 0x116, 0x1E, 0xA0);
                title.Set(0, 0x9E, 0x6C, 0x18);
                PrimQuad(prim, GyoraceFishTex, 305.0f, 42.0f, title, 0x80, 0x80, 0x80, 0x80);
            } else {

                DrawSubGameTitle(GyoraceFishTex, 0, 0x116, 0x1E, 0xA8);
                wide_title.Set(0, 0x9E, 0x74, 0x18);
                PrimQuad(prim, GyoraceFishTex, 305.0f, 42.0f, wide_title, 0x80, 0x80, 0x80, 0x80);
            }

            DrawSubGameListFix(GyoraceFishTex, 0xFA, 0x52, 0xFA, 0xBE);

            for (i = 0; i < 6; i++) {
                DrawSubGameUnderLine(GyoraceFishTex, 0x10A, i * 0x18 + 0x7E, 0xDC);
            }

            switch (GyoraceNowMode) {
                case GYORACE_MENU_ASSIGN_FISH:
                case GYORACE_MENU_SELECT_TACTICS:
                case GYORACE_MENU_TACTICS_RESULT:
                case GYORACE_MENU_DELETE_FISH:
                case GYORACE_MENU_DELETE_CONFIRM:
                case GYORACE_MENU_ALREADY_ASSIGNED:
                case GYORACE_MENU_LOAD_FISH:
                case GYORACE_MENU_RESET_CONFIRM:
                case GYORACE_MENU_ASSIGN_CONFIRM:
                case GYORACE_MENU_ASSIGN_RESULT: {
                    int   title_x = 0x13;
                    float label_x = 34.0f;
                    int   title_w = 0xE4;
                    int   scroll[2];
                    float cursor_x;
                    float cursor_y;

                    if (LanguageCode > 0) {
                        title_x = 0xD;
                        label_x = 28.0f;
                        title_w = 0xEA;
                    }

                    DrawSubGameTitle(GyoraceFishTex, 1, title_x, 0x1A, title_w);
                    label.Set(0, 0xD2, 0xCA, 0x1A);
                    PrimQuad(prim, GyoraceFishTex, label_x, 40.0f, label, 0x80, 0x80, 0x80, 0x80);
                    list_rect[0] = 0x14;
                    list_rect[1] = 0x54;
                    list_rect[2] = 0xE4;
                    list_rect[3] = 0x118;
                    scroll[1] = 0x25;
                    CalcMenu1(4.125f * GyoraceFishHaveListSelect.top, &GyoraceHaveFishListScrlBarY, 4.0f, float(2),
                              GyoraceHaveFishListScrlInit);
                    scroll[0] = fptosi(GyoraceHaveFishListScrlBarY);
                    y = fptosi(21.0f + (112.0f + GyoraceHaveFishListTopY));
                    DrawSubGameScrlList(GyoraceFishTex, list_rect, scroll);
                    int clip_top = list_rect[1] + 0x12;
                    clip.Set(list_rect[0], clip_top, list_rect[0] + list_rect[2] + 0x24,
                             (int) (2.0f + (260.0f + clip_top) - 8.0f));
                    SetMenuScissor(clip);

                    for (i = 0; i < 0x40; i++) {
                        DrawSubGameUnderLine(GyoraceFishTex, list_rect[0] + 0xE, y, 0xBA);
                        y += 0x1A;

                        if (y >= 0x19B) {
                            break;
                        }
                    }

                    ResetMenuScissor();
                    cursor_x = 4.0f + 8.0f * cosf(mgAngleLimit(0.05235988f * Gyoracemenu_long_hand_count));
                    cursor_y = GyoraceHaveFishCursor + 4.0f * sinf(mgAngleLimit(0.10471976f * Gyoracemenu_long_hand_count));

                    if (GyoraceHaveFishCursorDrawFlag != 0) {
                        PrimQuad(prim, GyoraceCursor, cursor_x, cursor_y, menu_long_hand, 0x80, 0x80, 0x80, 0x80);
                    }

                    break;
                }
            }

            textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
            GyoraceFishMes->DrawMsg();

            if (GyoraceFishHaveDrawFlag != 0) {

                have_clip.Set(0x14, 0x6D, 0xD2, 0x158);
                SetMenuScissor(have_clip);
                GyoraceFishHave->DrawMsg();
                ResetMenuScissor();
            }

            if (GyoraceFishTacMesDrawFlag != 0) {
                int cursor = GyoraceFishMes->GetMsgCursor();

                if (GyoraceNowMode == GYORACE_MENU_VIEW_TACTICS) {
                    int tac_x = 0x118;
                    int tac_y = cursor * 0x18 + 0x30;

                    if (LanguageCode > 0) {
                        tac_x -= 0x38;
                        tac_y -= 0x18;
                    }

                    GyoraceFishTacMes->SetPutPos(tac_x, tac_y, -1, -1);
                }

                GyoraceFishTacMes->DrawMsg();
            }

            board_x = MenuLoadFishBoardX;
            show_cursor = 0;

            switch (GyoraceNowMode) {
                case GYORACE_MENU_LOAD_FISH:
                    show_cursor = 1;
                case GYORACE_MENU_RESET_CONFIRM:
                case GYORACE_MENU_ASSIGN_CONFIRM:
                case GYORACE_MENU_ASSIGN_RESULT:
                case GYORACE_MENU_LOAD_BOARD: {
                    int board_block;

                    Func_MenuItemBrdPosStep(MenuLoadFishTopLine);
                    board_block = -1;
                    board.Set(board_x + 0x10, 0x2A, board_x + 0x105, 0x128);
                    MenuItemBrdUnderBrdPosXY[0] = board_x + 0x10;
                    cursor_rect.Set(0, 0xF4, 0xA, 0xD);
                    MenuItemBrdDraw(MenuItemBrdUnderBrdPosXY, board, board_block, 0x80, 0x80, 0x80, 0x80);
                    MenuItemModeItemDraw(board_block, board, MenuItemBrdUnderBrdPosXY, NULL,
                                         textures->GetTexture("mnmain", -1), cursor_rect, 0);
                    MenuItemBrdFrameDraw(board_x, 0x18, board_block, 0x80, 0x80, 0x80, 0x80);
                    break;
                }
            }

            switch (GyoraceNowMode) {
                case GYORACE_MENU_VIEW_TACTICS:
                case GYORACE_MENU_LOAD_FISH:
                case GYORACE_MENU_RESET_CONFIRM:
                case GYORACE_MENU_ASSIGN_CONFIRM:
                    if (GyoraceFishInfoDrawFlag != 0 && GyoracerActive != NULL && Tex_Aqualium != NULL) {
                        textures->ReloadTexture(Tex_Aqualium->block, (sceVif1Packet *) NULL);
                        DrawFishParam(((mgScreenWidth - 0x14A) >> 1) + 0xA, mgScreenHeight - 0x8E, Tex_Aqualium,
                                      GyoracerActive);
                    }
            }

            if (show_cursor != 0) {
                float target_x = (board_x - 0x12 + (MenuLoadFishSelect % 6) * 0x28) +
                                 8.0f * cosf(mgAngleLimit(0.05235988f * Gyoracemenu_long_hand_count));
                float target_y = ((MenuLoadFishSelect / 6 - MenuLoadFishTopLine) * 0x32 + 0x40) +
                                 4.0f * sinf(mgAngleLimit(0.10471976f * Gyoracemenu_long_hand_count));

                float accel = 2.0f;
                float speed = 4.0f;
                CalcMenu1(target_x, Gyoracemenu_CursorXY, speed, accel, 0);
                CalcMenu1(target_y, Gyoracemenu_CursorXY + 1, speed, accel, 0);

                if (board_x <= 0xE0) {
                    PrimQuad(prim, GyoraceCursor, Gyoracemenu_CursorXY[0], Gyoracemenu_CursorXY[1], menu_long_hand,
                             0x80, 0x80, 0x80, 0x80);
                }
            }

            if (MenuDCMsg[0] != NULL && GyoraceQuestionMsgDrawFlag != 0) {
                textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
                MenuDCMsg[0]->DrawMsg();
            }

            break;
        }
    }

    Gyoracemenu_long_hand_count++;

    if (Gyoracemenu_long_hand_count > 60000000) {
        Gyoracemenu_long_hand_count = 0;
    }

    GyoraceHaveFishListScrlInit = 0;
}

void DrawSubGameTitle(mgCTexture *texture, int large, int x, int y, int width) {
    mgRect<int> shadow;
    mgRect<int> frame;
    short      *table = pl_s_5630;

    if (large == 1) {
        table = pl_b_5631;
    }

    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(texture);
    prim->Color(0, 0, 0, 0x40);
    shadow.Set(x + 4, y + 4, width, table[3]);
    Menu3DivideTextureDraw(prim, shadow, table, 1);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    frame.Set(x, y, width, table[3]);
    Menu3DivideTextureDraw(prim, frame, table, 1);
    prim->End();
}

void DrawSubGameListFix(mgCTexture *texture, int x, int y, int width, int height) {
    mgRect<int>  shadow_top;
    mgRect<int>  shadow_mid;
    mgRect<int>  shadow_bottom;
    mgRect<int>  frame_top;
    mgRect<int>  frame_mid;
    mgRect<int>  frame_bottom;
    int          mid_height = height - 0x38;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(texture);
    prim->Color(0, 0, 0, 0x40);
    int shadow_x = x + 4;
    int shadow_y = y + 4;
    shadow_top.Set(shadow_x, shadow_y, width, tbl_5644[3]);
    Menu3DivideTextureDraw(prim, shadow_top, tbl_5644, 1);
    shadow_mid.Set(shadow_x, shadow_y + tbl_5644[3], width, mid_height);
    Menu3DivideTextureDraw(prim, shadow_mid, tbl_5644 + 12, 1);
    shadow_bottom.Set(shadow_x, mid_height + (shadow_y + tbl_5644[3]), width, tbl_5644[27]);
    Menu3DivideTextureDraw(prim, shadow_bottom, tbl_5644 + 24, 1);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    frame_top.Set(x, y, width, tbl_5644[3]);
    Menu3DivideTextureDraw(prim, frame_top, tbl_5644, 1);
    frame_mid.Set(x, y + tbl_5644[3], width, mid_height);
    Menu3DivideTextureDraw(prim, frame_mid, tbl_5644 + 12, 1);
    frame_bottom.Set(x, mid_height + (y + tbl_5644[3]), width, tbl_5644[27]);
    Menu3DivideTextureDraw(prim, frame_bottom, tbl_5644 + 24, 1);
    prim->End();
}

void DrawSubGameScrlList(mgCTexture *texture, int *box, int *thumb) {
    mgRect<int>  unused_rect;
    mgRect<int>  shadow_top;
    mgRect<int>  shadow_mid;
    mgRect<int>  shadow_bottom;
    mgRect<int>  frame_top;
    mgRect<int>  frame_mid;
    mgRect<int>  frame_bottom;
    mgRect<int>  bar_rect;
    int          mid_height = box[3] - 0x38;
    int          x = box[0];
    int          y = box[1];
    int          width = box[2];
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(texture);
    prim->Color(0, 0, 0, 0x40);
    int shadow_x = x + 4;
    int shadow_y = y + 4;
    shadow_top.Set(shadow_x, shadow_y, width, tbl_5669[3]);
    Menu3DivideTextureDraw(prim, shadow_top, tbl_5669, 1);
    shadow_mid.Set(shadow_x, shadow_y + tbl_5669[3], width, mid_height);
    Menu3DivideTextureDraw(prim, shadow_mid, tbl_5669 + 12, 1);
    shadow_bottom.Set(shadow_x, mid_height + (shadow_y + tbl_5669[3]), width, tbl_5669[27]);
    Menu3DivideTextureDraw(prim, shadow_bottom, tbl_5669 + 24, 1);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    frame_top.Set(x, y, width, tbl_5669[3]);
    Menu3DivideTextureDraw(prim, frame_top, tbl_5669, 1);
    frame_mid.Set(x, y + tbl_5669[3], width, mid_height);
    Menu3DivideTextureDraw(prim, frame_mid, tbl_5669 + 12, 1);
    frame_bottom.Set(x, mid_height + (y + tbl_5669[3]), width, tbl_5669[27]);
    Menu3DivideTextureDraw(prim, frame_bottom, tbl_5669 + 24, 1);
    unused_rect.Set(0xF8, 0, 8, 0x1E);
    bar_rect.Set((x + width) - 0xF, box[1] + thumb[0] + 8, 8, thumb[1]);
    Menu3DivideTextureDraw(prim, bar_rect, bart_5670, 0);
    prim->End();
}

void DrawSubGameUnderLine(mgCTexture *texture, int x, int y, int width) {
    mgRect<int>  rect;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(texture);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    rect.Set(x, y, width, pl_s_5699[3]);
    Menu3DivideTextureDraw(prim, rect, pl_s_5699, 1);
    prim->End();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_1346__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_2935__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_2975__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_2976__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3016__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3290__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3291__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3310__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3311__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3150__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3151__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3152__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3153__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3154__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3155__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3156__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3157__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3158__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3159__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3160__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3161__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3163__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuaqua", at_3164__3__DATA);

// Uninitialised data (.bss)
mgCMemory Aquarium_NameregistStack;
CAquarium Aquarium;
mgCMemory GyoraceFishSelStack;
mgCMemory GyoraceStack;
