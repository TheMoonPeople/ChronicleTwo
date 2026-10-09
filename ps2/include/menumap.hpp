#pragma once

#include "common.h"

#include "menusys.hpp"

/**
 * @file
 * Declares the world map menu, where the player picks an area of the world
 * and a place within it to travel to, and the Spheda menus of the extras
 * screen: the course list with its passwords and score clearing, and the
 * score view shown after a game of Spheda.
 */

class CDC2Mes;
class mgCMemory;
class mgCTexture;
struct SPI_STACK;

/**
 *
 * Sizes of the world map's tables.
 *
 */
enum {
    WMAP_AREA_POS_MAX = 8,      /**< Places one area of the world map can hold. */
    WMAP_AREA_POS_LIST = 6,     /**< Places of an area that the place list looks at. */
    WMAP_NEAR_AREA_MAX = 0x40,  /**< Areas the cursor can weigh up when it moves. */
    WMAP_WAVE_LINE_NUM = 0x118, /**< Rows or columns of anim_tex that wobble on the second world map. */
};

/**
 *
 * Kinds of place on the world map, as WMAP_POS_DATA::type holds them.
 *
 */
enum WMAP_POS_TYPE {
    WMAP_POS_TYPE_GEORAMA = 4, /**< A Georama site, drawn with the icon of type 3 and named by geo_table. */
};

/**
 *
 * States of the world map menu, as CBaseMenuClass::mode holds them.
 *
 */
enum WORLD_MAP_MODE {
    WORLD_MAP_MODE_RUN = 0,   /**< Takes input for the current step. */
    WORLD_MAP_MODE_OPEN = 1,  /**< Waits for the map files, then loads the map and fades in. */
    WORLD_MAP_MODE_CLOSE = 2, /**< Fades out, then hands back the result. */
};

/**
 *
 * Steps of the world map menu while it is open, as CBaseMenuClass::step holds them.
 *
 */
enum WORLD_MAP_STEP {
    WORLD_MAP_STEP_AREA = 0,     /**< Moves the cursor between areas. */
    WORLD_MAP_STEP_POS = 1,      /**< Chooses a place in the list of the chosen area. */
    WORLD_MAP_STEP_ASK = 2,      /**< Asks whether to travel to the chosen place. */
    WORLD_MAP_STEP_TREE_MAP = 3, /**< Fades out to open a dungeon's tree map. */
    WORLD_MAP_STEP_WAIT = 10,    /**< Waits for a button, then goes back to choosing an area. */
};

/**
 *
 * What WorldMoveKey and CWorldMapMenu::KeyStep give back each frame.
 *
 */
enum WORLD_MOVE_RESULT {
    WORLD_MOVE_CONTINUE = 0, /**< The menu is still open. */
    WORLD_MOVE_CLOSE = 1,    /**< The menu has closed without travelling. */
    WORLD_MOVE_JUMP = 2,     /**< The menu has closed to travel to the chosen place. */
};

/**
 *
 * Phases of the Spheda menu of the extras screen, as SphidaMenuPhase holds them.
 *
 */
enum SPHIDA_MENU_PHASE {
    SPHIDA_MENU_TOP = 0,             /**< Chooses between playing, passwords, clearing scores and leaving. */
    SPHIDA_MENU_EXIT = 1,            /**< Fades out, then leaves the menu. */
    SPHIDA_MENU_NAME_FADE = 99,      /**< Fades out before the player's name is entered. */
    SPHIDA_MENU_NAME_REGIST = 100,   /**< Takes the player's name for a new game. */
    SPHIDA_MENU_PASSWORD = 200,      /**< Chooses the course whose password is shown. */
    SPHIDA_MENU_PASSWORD_VIEW = 201, /**< Shows a course's password until a button is pressed. */
    SPHIDA_MENU_CLEAR = 300,         /**< Chooses the course whose score is cleared. */
    SPHIDA_MENU_CLEAR_ASK = 301,     /**< Asks whether to clear the chosen course's score. */
    SPHIDA_MENU_QUIT_ASK = 400,      /**< Asks whether to leave the menu. */
};

/**
 *
 * One place of the world map that the player can travel to, read from the POS tag of "wldmap.cfg".
 *
 */
struct WMAP_POS_DATA {
    char *name;    /**< Name of the place shown in the place list. */
    s32   map_no;  /**< Map the place leads to. */
    s16   loop_no; /**< Game loop the place leads to. @see MainLoopMode */
    s16   area_no; /**< Area of the world map the place belongs to. */
    s16   dng_no;  /**< Dungeon the place leads to when loop_no is LOOP_DUNGEON. */
    s8    floor;   /**< Dungeon floor to start on, or negative to choose one on the dungeon's tree map. */
    s8    enable;  /**< Non-zero once the place can be travelled to. */
    s16   flag_no; /**< Event flag that makes the place reachable. */
    s8    type;    /**< Kind of place, which picks its icon. @see WMAP_POS_TYPE */
    u8    unk_13;
};

STATIC_ASSERT(sizeof(WMAP_POS_DATA) == 0x14);

/**
 *
 * One area of the world map, holding its places, read from the AREA tag of "wldmap.cfg".
 *
 */
struct WMAP_AREA_DATA {
    s32            area_no;                /**< Number of the area. */
    WMAP_POS_DATA *pos[WMAP_AREA_POS_MAX]; /**< Places of the area, ending with a null entry. */
    s16            map_no;                 /**< Map number represented by the area. */
    u8             unk_26[0x2];
    s32            x;         /**< Screen x of the area's mark. */
    s32            y;         /**< Screen y of the area's mark. */
    s32            name_x;    /**< Screen x that the area's name window is placed from. */
    s32            name_y;    /**< Screen y of the area's name window. */
    s32            name_side; /**< 0 to put the name window right of name_x, 1 to put it left. */
    s32            enable;    /**< Non-zero once one of the area's places can be travelled to. */
    char          *name;      /**< Name of the area. */
    float          dist;      /**< Distance from the area the cursor is on, while the cursor moves. */
    float          dir_dot;   /**< How closely the area lies in the direction the cursor is pushed. */
};

STATIC_ASSERT(sizeof(WMAP_AREA_DATA) == 0x4C);

/**
 *
 * World map menu, where the player moves between the areas of the world and chooses a place to travel to.
 *
 */
class CWorldMapMenu : public CBaseMenuClass {
public:
    s32             area_no; /**< Area the cursor is on. */
    u8              unk_114[0x4];
    u8              unk_118[0x50];
    u8              unk_168[0x4];
    s32             exit_wait; /**< Frames counted while the menu closes. */
    s16             map_type;  /**< Which of the four world maps is shown, by story progress. */
    u8              unk_172[0x2];
    s32             here_area;    /**< Area marked alone on a map that only shows where the player is, or -1 to mark every reachable area. */
    s32             view_only;    /**< Non-zero when any button closes the menu. */
    mgCTexture     *capture_tex;  /**< Capture of the screen behind the menu ("menuwork2"). */
    float           back_alpha;   /**< Alpha of the black box drawn over the screen behind the menu. */
    u8              capture_view; /**< 1 to draw capture_tex behind the map. */
    u8              unk_185[0x3];
    mgCTexture     *cursor_tex;   /**< Texture of the cursor ("mnmain"), or null when no area is reachable. */
    u8              cursor_reset; /**< Non-zero to put the cursor onto its area at once. */
    u8              cursor_view;  /**< Non-zero to draw the cursor. */
    u8              unk_18e[0x2];
    float           cursor_pos[2];                 /**< Screen position of the cursor, easing towards its area. */
    mgCTexture     *map_tex;                       /**< Texture of the world map. */
    mgCTexture     *mark_tex;                      /**< Texture of the area marks, name frames and place icons ("wname"). */
    mgCTexture     *anim_tex;                      /**< Texture that wobbles over the second world map ("wmap021"), or that bobs on the fourth ("wmap04"). */
    mgCTexture     *pulse_tex;                     /**< Texture drawn twice with pulsing colour over the second world map ("wmap022"). */
    float           wave_x[WMAP_WAVE_LINE_NUM];    /**< Angle of the sideways wobble of each row of anim_tex. */
    float           wave_y[WMAP_WAVE_LINE_NUM];    /**< Angle of the up-and-down wobble of each column of anim_tex. */
    float           pulse_angle[2];                /**< Angles of the pulsing colour of the two copies of pulse_tex. */
    float           float_angle;                   /**< Angle of the bobbing of anim_tex on the fourth world map. */
    s32             blink_cnt;                     /**< Frame of the 90-frame blink of the area marks. */
    short          *mes_data;                      /**< Messages of the area and place names ("mapname.mes"). */
    short          *menu_mes_data;                 /**< Messages of the main menu. */
    WMAP_AREA_DATA *select_area;                   /**< Area whose place list is open. */
    s32             pos_num;                       /**< Number of reachable places in the place list. */
    WMAP_POS_DATA  *select_pos;                    /**< Place chosen from the place list. */
    s32             near_num;                      /**< Number of entries in near_area. */
    WMAP_AREA_DATA *near_area[WMAP_NEAR_AREA_MAX]; /**< Reachable areas sorted by distance, while the cursor moves. */
    u8              name_view;                     /**< Non-zero to show the name of the area the cursor is on. */
    u8              pos_list_view;                 /**< Non-zero to show the place list. */
    u8              ask_view;                      /**< Non-zero to show the travel question. */
    u8              unk_b93;
    s16             pos_icon[WMAP_AREA_POS_MAX]; /**< Icon of each entry of the place list. */

    /**
     *
     * Creates the menu with its cursor, sea and messages cleared and empties the world map tables.
     *
     */
    CWorldMapMenu();

    /**
     *
     * Points the menu's three message windows at the place names and the main menu's messages.
     *
     * @mangled SetMsgBuffer__13CWorldMapMenuFv
     * @address 0x2AFEE0
     * @size 0xA0
     */
    void SetMsgBuffer();

    /**
     *
     * Steps the menu one frame: loads the map, moves the cursor between areas, opens the place
     * list and asks about travelling; gives a WORLD_MOVE_RESULT.
     *
     * @mangled KeyStep__13CWorldMapMenuFv
     * @address 0x2AFF80
     * @size 0x10D0
     */
    int KeyStep();

    /**
     *
     * Draws the world map, its moving sea, the area marks, the cursor and the messages.
     *
     * @mangled Draw__13CWorldMapMenuFv
     * @address 0x2B1050
     * @size 0xF30
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CWorldMapMenu) == 0xBA4);

/**
 *
 * Reads the POS_NUM tag of the world map script and makes room for that many places.
 *
 * @mangled _WMAP_POSNUM__FP9SPI_STACKi
 * @address 0x2AFA60
 * @size 0x60
 */
int _WMAP_POSNUM(SPI_STACK *stack, int argument_count);

/**
 *
 * Reads one POS tag of the world map script into the place table.
 *
 * @mangled _WMAP_POS__FP9SPI_STACKi
 * @address 0x2AFAC0
 * @size 0x110
 */
int _WMAP_POS(SPI_STACK *stack, int argument_count);

/**
 *
 * Reads the AREA_NUM tag of the world map script and makes room for that many areas.
 *
 * @mangled _WMAP_AREANUM__FP9SPI_STACKi
 * @address 0x2AFBD0
 * @size 0x60
 */
int _WMAP_AREANUM(SPI_STACK *stack, int argument_count);

/**
 *
 * Reads one AREA tag of the world map script into the area table and gathers its places.
 *
 * @mangled _WMAP_AREA__FP9SPI_STACKi
 * @address 0x2AFC30
 * @size 0x240
 */
int _WMAP_AREA(SPI_STACK *stack, int argument_count);

/**
 *
 * Runs the world map script, building its area and place tables in a menu's memory.
 *
 * @mangled worldmap_analyze__FP9mgCMemoryPci
 * @address 0x2AFE70
 * @size 0x70
 */
void worldmap_analyze(mgCMemory *stack, char *script, int size);

/**
 *
 * Creates the world map menu in a menu's memory and starts reading its map; gives 1.
 *
 * @mangled WorldMoveInit__FP9mgCMemoryPii
 * @address 0x2B1F80
 * @size 0x2F0
 */
int WorldMoveInit(mgCMemory *stack, int *tex_block, int open_type);

/**
 *
 * Steps the world map menu, or the dungeon tree map opened from it; gives a WORLD_MOVE_RESULT.
 *
 * @mangled WorldMoveKey__Fv
 * @address 0x2B2270
 * @size 0x100
 */
int WorldMoveKey();

/**
 *
 * Draws the world map menu, or the dungeon tree map opened from it.
 *
 * @mangled WorldMoveDraw__Fv
 * @address 0x2B2370
 * @size 0x40
 */
void WorldMoveDraw();

/**
 *
 * Fills a message window with the names of the Spheda courses on the shown page of the list.
 *
 * @mangled SphidaScreListUpdate__FP7CDC2Mesi
 * @address 0x2B23B0
 * @size 0x130
 */
void SphidaScreListUpdate(CDC2Mes *mes, int update);

/**
 *
 * Creates the Spheda menu of the extras screen in a menu's memory with its windows and textures.
 *
 * @mangled SphidaMenuInit__FP9mgCMemoryPii
 * @address 0x2B24E0
 * @size 0x3D0
 */
void SphidaMenuInit(mgCMemory *stack, int *tex_block, int open_type);

/**
 *
 * Moves the Spheda course list by a key, noting a jump of more than two lines; gives the move.
 *
 * @mangled OmakeSfidaSelect__Fi
 * @address 0x2B28B0
 * @size 0x50
 */
int OmakeSfidaSelect(int key);

/**
 *
 * Steps the Spheda menu one frame; gives 0 while open, 1 with no Spheda data, 2 once it has closed.
 *
 * @mangled SphidaMenuKey__Fv
 * @address 0x2B2900
 * @size 0x870
 */
int SphidaMenuKey();

/**
 *
 * Draws the Spheda menu: its backdrop, course list, cursor and windows.
 *
 * @mangled SphidaMenuDraw__Fv
 * @address 0x2B3170
 * @size 0x8F0
 */
void SphidaMenuDraw();

/**
 *
 * Creates the Spheda score view in a menu's memory and loads its textures.
 *
 * @mangled SphidaScoreViewInit__FP9mgCMemoryPii
 * @address 0x2B3A60
 * @size 0x1B0
 */
void SphidaScoreViewInit(mgCMemory *memory, int *tex_block, int open_type);

/**
 *
 * Steps the Spheda score view one frame; gives 1 once a button closes it.
 *
 * @mangled SphidaScoreViewKey__Fv
 * @address 0x2B3C10
 * @size 0x60
 */
int SphidaScoreViewKey();

/**
 *
 * Draws the Spheda score view with the scores of each hole of the course just played.
 *
 * @mangled SphidaScoreViewDraw__Fv
 * @address 0x2B3C70
 * @size 0x580
 */
void SphidaScoreViewDraw();
