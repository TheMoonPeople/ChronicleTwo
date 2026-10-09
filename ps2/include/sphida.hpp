#pragma once

#include "common.h"

#include <libvu0.h>

#include "dng_event.hpp"
#include "mg_drawenv.hpp"

/**
 * @file
 * Declares the sphida game played on a dungeon floor: its shot power gauge, the pin, ball and
 * course state that the event scripts drive, and the clubs that the player can swing.
 */

class CColFrame;
class CMiniMapSymbol;
class mgCDrawPrim;
class mgCMemory;
class mgCTexture;
struct CCPoly;
struct MDS_HEADER;

/**
 *
 * Stages of a swing on the power gauge, as CPowGage::state holds them.
 *
 */
enum PowGageState {
    POWGAGE_STATE_IDLE = -1,      /**< The gauge waits for a swing to start. */
    POWGAGE_STATE_START = 0,      /**< Resets the gauge and starts the power cursor. */
    POWGAGE_STATE_CHARGE = 1,     /**< The cursor runs to full power and back until the power is set. */
    POWGAGE_STATE_CHARGE_SET = 2, /**< The power is set; the cursor runs on to full power. */
    POWGAGE_STATE_IMPACT = 3,     /**< The cursor runs back towards the impact point until it is stopped. */
    POWGAGE_STATE_JUDGE = 4,      /**< Turns where the cursor stopped into a result code. */
};

/**
 *
 * Special result codes of a swing, as CPowGage::code holds them. Codes from -3 to 3 give how far,
 * and to which side, the cursor stopped from the impact point; 0 is a stop on the point.
 *
 */
enum PowGageCode {
    POWGAGE_CODE_NONE = -10,   /**< No swing has been made. */
    POWGAGE_CODE_JUST = 0,     /**< The cursor stopped on the impact point. */
    POWGAGE_CODE_LATE = 4,     /**< The cursor ran past the impact point without being stopped. */
    POWGAGE_CODE_NO_POWER = 5, /**< The cursor ran back to empty without the power being set. */
};

/**
 *
 * Events that the sphida game runs from the dungeon when the player acts near the ball.
 *
 */
enum SphidaEvent {
    SPHIDA_EVENT_SHOT = 3000,           /**< The player stands at the ball and presses the action button. */
    SPHIDA_EVENT_NEAR_BALL = 3001,      /**< The player presses the menu button near the ball. */
    SPHIDA_EVENT_NEAR_BALL_LAST = 3002, /**< As SPHIDA_EVENT_NEAR_BALL, with fewer than two shots of par left. */
    SPHIDA_EVENT_OMAKE_AWAY = 3003,     /**< The player presses the menu button away from the ball in the bonus courses. */
};

/**
 *
 * Properties of one sphida club, which the event scripts read to play a shot.
 *
 */
struct GOLF_CLUB_DEF {
    float power; /**< Speed at which the club sends the ball off. */
    float unk_4;
    int   unk_8;
};

STATIC_ASSERT(sizeof(GOLF_CLUB_DEF) == 0xC);

/**
 *
 * Gauge on which the player sets the power of a shot and then stops a cursor on the impact point.
 *
 */
class CPowGage {
public:
    float       pos_x;      /**< Screen position of the centre of the gauge across. */
    float       pos_y;      /**< Screen position of the centre of the gauge down. */
    mgCTexture *texture;    /**< Texture that the gauge is drawn from; nothing is drawn while NULL. */
    float       power;      /**< Power of the shot, from 0 to 1. */
    int         safe_level; /**< Width, from 1 to 6, of the zone about the impact point in which a stop is accurate. */
    int         code;       /**< Result of the last swing (PowGageCode, or -3 to 3 for the stop's offset). */
    int         count;      /**< Position of the cursor, in steps from the impact point. */
    int         state;      /**< Stage of the swing (PowGageState). */
    int         reverse;    /**< Nonzero once the cursor has reached full power and runs back. */

    /**
     *
     * Makes a gauge that waits for a swing.
     *
     */
    CPowGage() {
        Initialize();
    }

    /**
     *
     * Puts the gauge back to waiting for a swing, with no result.
     *
     * @mangled Initialize__8CPowGageFv
     * @address 0x2EDEF0
     * @size 0x30
     */
    void Initialize();

    /**
     *
     * Moves the cursor one step for the stage of the swing, and works out the
     * result when the swing ends.
     *
     * @mangled Step__8CPowGageFv
     * @address 0x2EDF20
     * @size 0x260
     */
    void Step();

    /**
     *
     * Draws the gauge, its power bar, its safe zone and its cursor.
     *
     * @mangled Draw__8CPowGageFv
     * @address 0x2EE180
     * @size 0x3E0
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CPowGage) == 0x24);

/**
 *
 * Sphida game on the current floor: where the pin and the ball are, the par, the status panel, the
 * mini map markers and the collision of the pin.
 *
 */
class CSphida {
public:
    CPowGage      pow_gage;     /**< Gauge on which the player swings. */
    int           tex_bank;     /**< Texture bank that the status panel and the par counter are drawn from. */
    int           play_flag;    /**< Nonzero while the game is played; nothing is stepped or drawn otherwise. */
    int           minimap_flag; /**< 1 to let the player scroll the mini map while an event runs. */
    int           mm_line_flag; /**< 1 to mark the points of mm_line_pos on the mini map. */
    int           status_flag;  /**< Nonzero to draw the status panel and the gauge. */
    u_char        unk_38[0x8];
    sceVu0FVECTOR mm_line_pos[5]; /**< Points of the shot line that the mini map marks. */
    sceVu0FVECTOR pin_pos;        /**< Position of the pin. */
    sceVu0FVECTOR ball_pos;       /**< Position of the ball. */
    int           pin_col;        /**< Colour of the pin, 0 or 1, which picks its mini map marker. */
    int           ball_col;       /**< Colour of the ball, 0 or 1, which picks its mini map marker. */
    int           par_count;      /**< Shots of par for the hole, from 1 to 99. */
    u_char        unk_bc[0x4];
    CRedMarkModel red_mark; /**< Marker drawn over the ball while the player stands at it. */
    u_char        unk_150[0x48];
    u_char        unk_198[6];
    u_char        unk_19e[0x42];
    sceVu0FVECTOR map_view_pos;    /**< Centre of the mini map while the player scrolls it during an event. */
    int           mini_level;      /**< Scale of the mini map that the event scripts read. */
    float         spin_mark_pos_x; /**< Across position, from -1 to 1, of the spin mark on the ball panel. */
    float         spin_mark_pos_y; /**< Down position, from -1 to 1, of the spin mark on the ball panel. */
    int           club_no;         /**< Club that the player holds, as GetSphidaClubDef takes it. */
    float         carry;           /**< Angle, in radians, at which the ball is struck, which also lowers its speed. */
    int           last_challenge;  /**< Nonzero once the last challenge of the hole is under way. */
    CColFrame    *col_model;       /**< Collision of the pin; NULL while none is loaded. */
    int           omake_mode;      /**< 1 while one of the bonus courses is played. */
    int           unk_210[9];
    u_char        unk_234[0xC];

    /**
     *
     * Makes a sphida game that is not played yet.
     *
     * @mangled __ct__7CSphidaFv
     * @address 0x2EE580
     * @size 0xA0
     */
    CSphida();

    /**
     *
     * Stops the game and clears the flags, the positions, the par and the
     * collision.
     *
     * @mangled Initialize__7CSphidaFv
     * @address 0x2EE620
     * @size 0x100
     */
    void Initialize();

    /**
     *
     * Places the pin and the ball at random on the floor, works out the par
     * from the path between them, and starts the game.
     *
     * @mangled SetUp__7CSphidaFi
     * @address 0x2EE720
     * @size 0x480
     */
    void SetUp(int arg);

    /**
     *
     * Places the pin and the ball at the fixed positions of the story's
     * sphida hole and starts the game.
     *
     * @mangled s17_SetUp__7CSphidaFi
     * @address 0x2EEBA0
     * @size 0x100
     */
    void s17_SetUp(int arg);

    /**
     *
     * Places the pin and the ball of one of the bonus courses, gives it its
     * par, and starts the game.
     *
     * @mangled Omake_SetUp__7CSphidaFii
     * @address 0x2EECA0
     * @size 0x380
     */
    void Omake_SetUp(int course, int tex_bank);

    /**
     *
     * Steps the gauge and the red marker, and starts the shot or menu event
     * when the player acts near the ball.
     *
     * @mangled Step__7CSphidaFv
     * @address 0x2EF020
     * @size 0x320
     * @return 1 when an event was started, 0 otherwise.
     */
    int Step();

    /**
     *
     * Gets the gauge onto its place on the screen and gives it its texture.
     *
     * @mangled InitStatusSprite__7CSphidaFv
     * @address 0x2EF340
     * @size 0x50
     */
    void InitStatusSprite();

    /**
     *
     * Draws the status panel: the par, the distance to the pin, the spin mark
     * panel, the carry of the club and the gauge.
     *
     * @mangled DrawStatusSprite__7CSphidaFv
     * @address 0x2EF390
     * @size 0x111C
     */
    void DrawStatusSprite();

    /**
     *
     * Draws the par as a number floating over the ball.
     *
     * @mangled DrawParCounter__7CSphidaFv
     * @address 0x2F04B0
     * @size 0x2E0
     */
    void DrawParCounter();

    /**
     *
     * Draws the status panel, the mini map of the game, the red marker and the
     * par counter.
     *
     * @mangled Draw__7CSphidaFv
     * @address 0x2F0790
     * @size 0x4D0
     */
    void Draw();

    /**
     *
     * Loads the collision of the pin from a model file.
     *
     * @mangled SetCollisionModel__7CSphidaFP10MDS_HEADERP9mgCMemory
     * @address 0x2F0C60
     * @size 0x40
     * @return Nonzero when the collision was loaded.
     */
    int SetCollisionModel(MDS_HEADER *header, mgCMemory *memory);

    /**
     *
     * Gathers the polygons of the pin's collision that lie in a box, when the
     * game is played and a position is near the pin.
     *
     * @mangled PickupCollision__7CSphidaFPfP6CCPoly9mgVu0FBOXi
     * @address 0x2F0CA0
     * @size 0xD0
     * @return Number of polygons written.
     */
    int PickupCollision(float *pos, CCPoly *poly, mgVu0FBOX box, int capacity);

    /**
     *
     * Marks the pin, the ball and, when asked for, the shot line on the mini
     * map.
     *
     * @mangled DrawMiniMapSymbol__7CSphidaFP14CMiniMapSymbol
     * @address 0x2F0D70
     * @size 0xE0
     */
    void DrawMiniMapSymbol(CMiniMapSymbol *symbol);
};

STATIC_ASSERT(sizeof(CSphida) == 0x240);

/**
 *
 * Sphida game of the current floor; NULL while none is played.
 *
 */
extern CSphida *Sphida;

/**
 *
 * Gets the properties of a club.
 *
 * @mangled GetSphidaClubDef__Fi
 * @address 0x2EDDD0
 * @size 0x50
 * @return The club's properties, or NULL for a number outside 9 to 14.
 */
GOLF_CLUB_DEF *GetSphidaClubDef(int club_no);

/**
 *
 * Adds a sprite centred on a screen position, taken from a rectangle of the
 * texture, to a strip of sprites being drawn.
 *
 * @mangled DPrimEnterSprite__FP11mgCDrawPrimiiiiffff
 * @address 0x2EDE20
 * @size 0xD0
 */
void DPrimEnterSprite(mgCDrawPrim *prim, int u, int v, int tex_w, int tex_h, float x, float y, float w, float h);

/**
 *
 * Forgets the sphida game, so that none is played.
 *
 * @mangled InitSphida__Fv
 * @address 0x2EE560
 * @size 0x10
 */
void InitSphida();

/**
 *
 * Gets the sphida game of the current floor.
 *
 * @mangled GetSphidaPtr__Fv
 * @address 0x2EE570
 * @size 0x10
 * @return The game, or NULL while none is played.
 */
CSphida *GetSphidaPtr();
