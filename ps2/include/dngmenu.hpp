#pragma once

#include "common.h"

#include "dng_event.hpp"
#include "menucls1.hpp"
#include "menusys.hpp"
#include "mg_tanime.hpp"

/**
 * @file
 * Declares the dungeon floor map: the board of rooms and passages that shows
 * where the player's piece stands, drawn both by the dungeon menu's tree map,
 * where a floor is chosen to jump to, and by event scripts that move the
 * piece across it; plus the menu that runs the tree map.
 */

class CDngFloorManager;
class CSaveDataDungeon;
class mgCMemory;
class mgCTexture;
struct DNGMAP_ROOM_INFO;
struct DNGMAP_ROOT_INFO;
struct GLID_INFO;

/**
 *
 * Callers a floor map is drawn for, which decide what it draws around the rooms.
 *
 */
enum DNGMAP_MODE {
    DNGMAP_MODE_MENU = 0,  /**< Drawn by the dungeon menu's tree map, over the scrolling backdrop. */
    DNGMAP_MODE_EVENT = 1, /**< Drawn by an event script, over a darkened screen. */
};

/**
 *
 * Directions a floor map's fade runs in.
 *
 */
enum DNGMAP_FADE {
    DNGMAP_FADE_NONE = -1, /**< No fade has been started. */
    DNGMAP_FADE_IN = 0,    /**< Raises the map's alpha towards 128. */
    DNGMAP_FADE_OUT = 1,   /**< Lowers the map's alpha towards 0. */
};

/**
 *
 * Directions in which a map route follows rooms and their interpolation points.
 *
 */
enum DNGMAP_PATH_ORDER {
    DNGMAP_PATH_NONE = -1,   /**< The cell has no interpolation path in this direction. */
    DNGMAP_PATH_FORWARD = 0, /**< Reads a cell's interpolation points from first to last. */
    DNGMAP_PATH_REVERSE = 1, /**< Reads a cell's interpolation points from last to first. */
};

/**
 *
 * Sizes of the floor map's tables.
 *
 */
enum {
    DNGMAP_ROOT_HOKAN_POINTS = 20,    /**< Interpolation points in a passage path, excluding its terminator. */
    DNGMAP_ROOM_HOKAN_POINTS = 10,    /**< Interpolation points in a room path, excluding its terminator. */
    DNGMAP_MARK_MAX = 8,              /**< Room marks the map can queue in one frame. */
    DNGMAP_BLINK_CYCLE = 100,         /**< Frames one cycle of the map's blink counter lasts. */
    DNG_TREE_MAP_MES_MAX = 8,         /**< Message windows the tree map menu holds. */
    DNG_TREE_MAP_MATERIA_MAX = 0x103, /**< Georama parts the tree map can list for one floor. */
    DNG_TREE_MAP_MATERIA_PAGE = 14,   /**< Georama parts one page of the material list shows. */
};

/**
 *
 * Results the tree map menu's step gives its caller.
 *
 */
enum DNG_TREE_MAP_RESULT {
    DNG_TREE_MAP_CONTINUE = 0, /**< The menu stays open. */
    DNG_TREE_MAP_CLOSE = 1,    /**< The menu has closed without choosing a floor. */
    DNG_TREE_MAP_JUMP = 2,     /**< The menu has closed after a floor was chosen to jump to. */
};

/**
 *
 * Opening contexts distinguished by the dungeon tree map.
 *
 */
enum DNG_TREE_MAP_FUNC {
    DNG_TREE_MAP_FUNC_OTHER = 0,      /**< An opening request outside the dungeon or save-point contexts. */
    DNG_TREE_MAP_FUNC_DUNGEON = 1,    /**< The dungeon main menu or its requested sub map. */
    DNG_TREE_MAP_FUNC_SAVE_POINT = 2, /**< The tree-map request opened at a save point. */
};

/**
 *
 * Screens the tree map's key and draw functions run.
 *
 */
enum DNG_TREE_MODE {
    DNG_TREE_MODE_MAP = 0,  /**< The tree map menu itself. */
    DNG_TREE_MODE_SAVE = 1, /**< The save menu opened from the tree map. */
};

/**
 *
 * Screens of the tree map menu whose keys its step reads, as CBaseMenuClass::key_arg_no holds them.
 *
 */
enum DNG_TREE_MAP_SCREEN {
    DNG_TREE_MAP_SCREEN_MAP = 0,       /**< The cursor moves between the floors. */
    DNG_TREE_MAP_SCREEN_FLOOR = 1,     /**< The selected floor's jump question or information is open. */
    DNG_TREE_MAP_SCREEN_MATERIALS = 2, /**< The selected floor's georama material list is open. */
};

/**
 *
 * One point of the path the player's piece moves along in an event.
 *
 */
struct DNGMAP_KOMA_POS {
    float            x;    /**< Screen x of the point. */
    float            y;    /**< Screen y of the point. */
    DNGMAP_KOMA_POS *next; /**< Following point of the path, or NULL at its end. */
};

STATIC_ASSERT(sizeof(DNGMAP_KOMA_POS) == 0xC);

/**
 *
 * Board of one dungeon's floors, scrolled to keep a room in view, that draws
 * the rooms and passages, the player's piece and the dungeon's name.
 *
 */
class CDngFreeMap {
public:
    CSaveDataDungeon *save_dungeon;  /**< Saved progress through the dungeons. */
    CDngFloorManager *floor_manager; /**< Floors and rooms of the dungeon being shown. */
    u8                active;        /**< Non-zero while the map steps and draws. */
    u8                unk_9;
    s16               dng_no; /**< Dungeon being shown. */
    s16               mode;   /**< Caller the map is drawn for, a DNGMAP_MODE. */
    u8                unk_e[0x2];
    float             back_scroll; /**< Offset the backdrop's tiles have scrolled by. */
    u8                unk_14[0xC];
    mgRect<float>     view_rect; /**< Screen area the shown room is kept inside. */
    s32               mark_num;  /**< Room marks queued this frame. */
    u8                unk_34[0xC];
    mgRect<float>     mark_rect[DNGMAP_MARK_MAX]; /**< Screen rectangles of the room marks queued this frame, drawn above the rooms. */
    s16               user_room_no;               /**< Room the player's piece stands in; negative for none. */
    s16               next_room_no;               /**< Room the player's piece moves to in an event; negative for none. */
    GLID_INFO        *user_glid;                  /**< Grid cell of the room the player's piece stands in. */
    s16               blink_cnt;                  /**< Frame counter, wrapping at DNGMAP_BLINK_CYCLE, that blinks the rooms. */
    u8                unk_ca[0x2];
    GLID_INFO        *select_glid; /**< Grid cell the tree map's cursor is on, or NULL. */
    s16               tex_block;   /**< Texture block the map's textures are entered into; negative for none. */
    u8                unk_d2[0x2];
    mgCTexture       *name_tex;  /**< Dungeon names and room letters ("dtname"). */
    mgCTexture       *map_tex;   /**< Rooms, passages and backdrop tiles ("dt"). */
    mgCTexture       *last_tex;  /**< Picture laid over the whole screen ("dtbg"). */
    mgCTexture       *koma_tex;  /**< Player's piece ("dngop"). */
    DNGMAP_KOMA_POS  *koma_path; /**< Head of the path the player's piece moves along in an event. */
    DNGMAP_KOMA_POS  *koma_now;  /**< Point of the path the player's piece moves to next. */
    s16               koma_move; /**< Non-zero while the player's piece moves along its path. */
    u8                unk_ee[0x2];
    float             alpha;      /**< Opacity the map draws with, from 0 to 128. */
    s32               fade_time;  /**< Frames the current fade lasts. */
    float             fade_step;  /**< Amount alpha changes by each frame of the fade. */
    s32               fade_mode;  /**< Direction of the current fade, a DNGMAP_FADE. */
    float             pos_x;      /**< Horizontal offset the board is scrolled by. */
    float             pos_y;      /**< Vertical offset the board is scrolled by. */
    float             next_pos_x; /**< Horizontal offset the board scrolls towards. */
    float             next_pos_y; /**< Vertical offset the board scrolls towards. */

    /**
     *
     * Creates a map with nothing loaded.
     *
     */
    CDngFreeMap() { Initialize(); }

    /**
     *
     * Puts the map back into its starting state, with nothing loaded and nothing shown.
     *
     * @mangled Initialize__11CDngFreeMapFv
     * @address 0x1EBC70
     * @size 0xC4
     */
    void Initialize();

    /**
     *
     * Forgets the map's textures and texture block.
     *
     * @mangled InitTexture__11CDngFreeMapFv
     * @address 0x1EBD40
     * @size 0x1C
     */
    void InitTexture();

    /**
     *
     * Places the player's piece in a room.
     *
     * @mangled SetUserGlid__11CDngFreeMapFi
     * @address 0x1EBD60
     * @size 0x38
     */
    void SetUserGlid(int room_no);

    /**
     *
     * Works out where on the screen, or on the unscrolled board, a grid cell is drawn.
     *
     * @mangled CalcGlidPutPos__11CDngFreeMapFP9GLID_INFORfRfi
     * @address 0x1EBDA0
     * @size 0x8C
     */
    void CalcGlidPutPos(GLID_INFO *glid, float &x, float &y, int board);

    /**
     *
     * Works out how far the board has to scroll for a point to lie inside the view rectangle.
     *
     * @mangled CheckIsViewMove__11CDngFreeMapFiiRfRf
     * @address 0x1EBE30
     * @size 0x140
     */
    void CheckIsViewMove(int x, int y, float &move_x, float &move_y);

    /**
     *
     * Scrolls the board towards a grid cell, as far as keeps it in view.
     *
     * @mangled SetNextRoomPos__11CDngFreeMapFP9GLID_INFO
     * @address 0x1EBF70
     * @size 0x88
     */
    void SetNextRoomPos(GLID_INFO *glid);

    /**
     *
     * Gives the grid cell a passage leads to from another cell.
     *
     * @mangled GetNextGlid__11CDngFreeMapFP9GLID_INFOPi
     * @address 0x1EC000
     * @size 0x34
     */
    GLID_INFO *GetNextGlid(GLID_INFO *glid, int *direction);

    /**
     *
     * Gives the grid cell of a room, or NULL when the dungeon has no such room.
     *
     * @mangled GetRoomGlid__11CDngFreeMapFi
     * @address 0x1EC040
     * @size 0x28
     */
    GLID_INFO *GetRoomGlid(int room_no);

    /**
     *
     * Gives the grid cell of the dungeon's entrance room, or NULL when it has none.
     *
     * @mangled GetEntranceRoomGlid__11CDngFreeMapFv
     * @address 0x1EC070
     * @size 0x74
     */
    GLID_INFO *GetEntranceRoomGlid();

    /**
     *
     * Looks up the tree map's textures among those already entered.
     *
     * @mangled SetTextureInfo__11CDngFreeMapFv
     * @address 0x1EC0F0
     * @size 0x90
     */
    void SetTextureInfo();

    /**
     *
     * Scrolls the board to centre a room, at once or over the following frames.
     *
     * @mangled ResetDngMapPos__11CDngFreeMapFii
     * @address 0x1EC180
     * @size 0x198
     */
    void ResetDngMapPos(int room_no, int at_once);

    /**
     *
     * Draws the backdrop: scrolling tiles for the menu, a darkened screen for an event.
     *
     * @mangled DrawBackPattern__11CDngFreeMapFi
     * @address 0x1EC320
     * @size 0x160
     */
    void DrawBackPattern(int alpha);

    /**
     *
     * Draws the dungeon's name, with its shadow, in the top left corner.
     *
     * @mangled DrawDngName__11CDngFreeMapFi
     * @address 0x1EC480
     * @size 0x104
     */
    void DrawDngName(int alpha);

    /**
     *
     * Lays the overlay picture over the whole screen.
     *
     * @mangled DrawLast__11CDngFreeMapFv
     * @address 0x1EC590
     * @size 0xEC
     */
    void DrawLast();

    /**
     *
     * Draws a passage cell, or its shadow, with the joints to the cells around it.
     *
     * @mangled DrawRoot__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOT_INFOiUii
     * @address 0x1EC680
     * @size 0xD2C
     */
    void DrawRoot(mgRect<float> rect, DNGMAP_ROOT_INFO *root, int shadow, unsigned int marks, int opacity);

    /**
     *
     * Works out which of a cell's neighbours a passage cell has to be joined to.
     *
     * @mangled DrawGlidCheck__11CDngFreeMapFP9GLID_INFO
     * @address 0x1ED3B0
     * @size 0x130
     */
    unsigned int DrawGlidCheck(GLID_INFO *glid);

    /**
     *
     * Draws one room cell with its shadow, its marks and its room letters.
     *
     * @mangled DrawRoomOne__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOM_INFOUiif
     * @address 0x1ED4E0
     * @size 0x914
     */
    void DrawRoomOne(mgRect<float> rect, DNGMAP_ROOM_INFO *room, unsigned int unused, int opacity, float brightness);

    /**
     *
     * Outlines a grid cell, for debugging.
     *
     * @mangled DrawGlid__11CDngFreeMapF9mgRect_f_
     * @address 0x1EDE00
     * @size 0x130
     */
    void DrawGlid(mgRect<float> rect);

    /**
     *
     * Draws every cell of the floor, and the light circle around the menu's cursor.
     *
     * @mangled DrawTreeMap__11CDngFreeMapFi
     * @address 0x1EF010
     * @size 0x31C
     */
    void DrawTreeMap(int alpha);

    /**
     *
     * Draws the player's piece, bobbing in the menu and moving along its path in an event.
     *
     * @mangled DrawPlayer__11CDngFreeMapFi
     * @address 0x1EF330
     * @size 0x244
     */
    void DrawPlayer(int alpha);

    /**
     *
     * Runs the fade, scrolls the board towards its target and advances the blink counters.
     *
     * @mangled Step__11CDngFreeMapFv
     * @address 0x1EF580
     * @size 0x1A8
     */
    void Step();

    /**
     *
     * Draws the whole map, and the debugging readout of the cursor's room when enabled.
     *
     * @mangled Draw__11CDngFreeMapFv
     * @address 0x1EF730
     * @size 0x608
     */
    void Draw();

    /**
     *
     * Starts fading the map in over a number of frames.
     *
     * @mangled FadeIn__11CDngFreeMapFi
     * @address 0x1EFD40
     * @size 0x38
     */
    void FadeIn(int frames);

    /**
     *
     * Starts fading the map out over a number of frames.
     *
     * @mangled FadeOut__11CDngFreeMapFi
     * @address 0x1EFD80
     * @size 0x3C
     */
    void FadeOut(int frames);

    /**
     *
     * Frees the texture block the map's textures were entered into.
     *
     * @mangled DeleteTexBlock__11CDngFreeMapFv
     * @address 0x1EFDC0
     * @size 0x2C
     */
    void DeleteTexBlock();

    /**
     *
     * Starts or stops the player's piece moving along its path from the start.
     *
     * @mangled SetKomaMove__11CDngFreeMapFi
     * @address 0x1EFDF0
     * @size 0x28
     */
    void SetKomaMove(int moving);

    /**
     *
     * Loads a dungeon's map for an event, places the player's piece and builds the
     * path it moves along to another room; gives the memory used, in 16-byte units.
     *
     * @mangled LoadDngInfo__11CDngFreeMapFP9mgCMemoryiiii
     * @address 0x1EFE20
     * @size 0xFE0
     */
    int LoadDngInfo(mgCMemory *stack, int block, int dungeon, int room, int next_room);
};

STATIC_ASSERT(sizeof(CDngFreeMap) == 0x110);
STATIC_ASSERT(sizeof(mgRect<float>) == 0x10);

/**
 *
 * Dungeon menu's tree map, where the player looks over a dungeon's floors and
 * chooses one to jump to.
 *
 */
class CMenuTreeMap : public CBaseMenuClass {
public:
    float                  cursor_pos[2]; /**< Screen position of the cursor, easing towards the chosen floor. */
    s16                    dng_no;        /**< Dungeon being shown. */
    s16                    draw_hidden;   /**< Non-zero while the dungeon map drawing is hidden. */
    s16                    jump_pay;      /**< Non-zero when jumping to a floor costs half the player's money. */
    u8                     unk_11e[0x2];
    GLID_INFO             *select_glid; /**< Grid cell of the floor the cursor is on. */
    u8                     unk_124[0xC];
    CDC2Mes                mes[DNG_TREE_MAP_MES_MAX]; /**< Message windows of the floor information. */
    short                 *mes_data;                  /**< Messages the menu shows ("systree.mes"). */
    s32                    cursor_view;               /**< Non-zero to draw the cursor. */
    s32                    cursor_reset;              /**< Non-zero to put the cursor onto its floor at once. */
    s32                    money_view;                /**< Non-zero to show the player's money beside the jump question. */
    s32                    help_view;                 /**< Non-zero to show the help message along the bottom of the screen. */
    u8                     tresure_loaded;            /**< Non-zero once the dungeon's treasure tables are read. */
    u8                     unk_153c5[0x3];
    TRESURE_BOX_FLOOR_INFO tresure;                                   /**< Treasure tables of the dungeon's floors. */
    s32                    georama_materia[DNG_TREE_MAP_MATERIA_MAX]; /**< Georama parts that can be found on the chosen floor. */

    /**
     *
     * Creates the menu with its message windows and points the floor windows at them.
     *
     */
    CMenuTreeMap();

    /**
     *
     * Loads the tree map's textures and messages and puts the cursor on the floor the player last reached.
     *
     * @mangled InitEnd__12CMenuTreeMapFv
     * @address 0x1F0F90
     * @size 0x380
     */
    virtual void InitEnd();

    /**
     *
     * Sets up the message windows and the help message along the bottom of the screen.
     *
     * @mangled MsgInit__12CMenuTreeMapFv
     * @address 0x1F1310
     * @size 0x1D0
     */
    void MsgInit();

    /**
     *
     * Moves the cursor between floors, shows their information and asks about
     * jumping to the chosen one; gives a DNG_TREE_MAP_RESULT.
     *
     * @mangled Step__12CMenuTreeMapFv
     * @address 0x1F14E0
     * @size 0x1828
     */
    int Step();

    /**
     *
     * Draws the floor map, the floor information, the cursor and the messages.
     *
     * @mangled Draw__12CMenuTreeMapFv
     * @address 0x1F2D10
     * @size 0x728
     */
    void Draw();

    /**
     *
     * Advances the menu's fade, starting the fade-out once an opening fade has
     * finished; gives non-zero once the fade being waited for is done.
     *
     * @mangled FadeInOutMenu__12CMenuTreeMapFv
     * @address 0x1F3440
     * @size 0x94
     */
    int FadeInOutMenu();
};

STATIC_ASSERT(sizeof(CMenuTreeMap) == 0x2FBE0);

/**
 *
 * Returns the tree map's opening context as a DNG_TREE_MAP_FUNC.
 *
 * @mangled CheckDngTreeMapFuncType__Fv
 * @address 0x1F0E00
 * @size 0x3C
 */
int CheckDngTreeMapFuncType();

/**
 *
 * Works out the loop and map a jump to a dungeon's floor starts.
 *
 * @mangled MakeDngTreeMapJumpNo__FiiPiPi
 * @address 0x1F0E40
 * @size 0x144
 */
void MakeDngTreeMapJumpNo(int dng_no, int floor_id, int *loop_no, int *map_no);

/**
 *
 * Creates the tree map menu and floor map in a menu's memory and loads the dungeon's map.
 *
 * @mangled DngTreeMapInit__FP9mgCMemoryPiii
 * @address 0x1F34E0
 * @size 0x3F8
 */
void DngTreeMapInit(mgCMemory *stack, int *tex_block, int menu_mode, int dng_no);

/**
 *
 * Steps the tree map, or the save menu opened from it; gives a DNG_TREE_MAP_RESULT.
 *
 * @mangled DngTreeMapKey__Fv
 * @address 0x1F3BA0
 * @size 0x114
 */
int DngTreeMapKey();

/**
 *
 * Draws the tree map, or the save menu opened from it.
 *
 * @mangled DngTreeMapDraw__Fv
 * @address 0x1F3CC0
 * @size 0x40
 */
void DngTreeMapDraw();

/** Non-zero while the tree map was opened from a save point and offers to save. */
extern u8 TreeMapSaveFlag;

/** Saves made since the tree map was opened from a save point. */
extern s16 TreeMapSaveNum;

/** Non-zero when the tree map was opened from the dungeon's sub map. */
extern u8 TreeMapCallDungeonSubMap;

/** Non-zero while the tree map is open over the world map. */
extern u8 TreeMapCalledWorldMap;
