#pragma once

#include "common.h"

#include <libvu0.h>

#include "collision.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_frame.hpp"

/**
 * @file
 * Declares the pot or box the player picks up and throws in a dungeon, and
 * the broken pieces that scatter from it when it smashes.
 */

/**
 *
 * Capacities and timings of a thrown pot and its broken pieces.
 *
 */
enum {
    BPOT_FRAGMENT_MAX = 32, /**< Broken pieces a smashed pot holds. */
    BPOT_BREAK_TIME = 60,   /**< Steps the broken pieces stay after the smash. */
    BPOT_FADE_TIME = 30,    /**< Steps, at the end of the break time, over which the pieces fade out. */
    POT_FLY_TIME_MAX = 150, /**< Steps a thrown pot flies before it is dropped without breaking. */
};

/**
 *
 * What a carried pot is doing, held in CPot::state.
 *
 */
enum POT_STATE {
    POT_STATE_NONE = 0, /**< No pot is held or in flight. */
    POT_STATE_HOLD = 1, /**< The pot is carried and follows its map part. */
    POT_STATE_FLY = 2,  /**< The pot has been thrown and is flying. */
};

/**
 *
 * Results of a step of a carried pot.
 *
 */
enum POT_STEP_RESULT {
    POT_STEP_NONE = 0,    /**< The pot is still held, flying, or absent. */
    POT_STEP_BREAK = 1,   /**< The flying pot hit a wall or the floor and smashed. */
    POT_STEP_TIMEOUT = 2, /**< The flying pot ran out of flight time and was let go. */
};

/**
 *
 * Kinds of broken object, held in CBPot::type, each with its own pieces and sound.
 *
 */
enum BPOT_TYPE {
    BPOT_TYPE_NONE = 0,  /**< No broken object is set up. */
    BPOT_TYPE_BOX = 1,   /**< A wooden box, broken into the "box" pieces of box_offset. */
    BPOT_TYPE_ROCK0 = 2, /**< A rock, broken into the "rock" pieces of iwa0_offset. */
    BPOT_TYPE_ROCK1 = 3, /**< A second rock, broken into the "rock" pieces of iwa1_offset. */
};

/**
 *
 * One broken piece of a smashed pot, which falls, bounces off the ground and spins until the break ends.
 *
 */
class CFragment {
public:
    int           no{};       /**< Index of the piece among those found in the broken model, or -1. */
    int           active{};   /**< Moves and draws the piece while nonzero. */
    sceVu0FVECTOR position{}; /**< World position of the piece. */
    sceVu0FVECTOR velocity{}; /**< Distance the piece moves each step. */
    sceVu0FVECTOR gravity{};  /**< Change of velocity each step. */
    sceVu0FVECTOR rotation{}; /**< Angle, in radians, about each axis, kept within -pi to pi. */
    mgCFrame     *frame{};    /**< Frame of the broken model that draws the piece, or NULL. */

    /**
     *
     * Makes an inactive piece with no frame.
     *
     */
    CFragment() { Init(); }

    /**
     *
     * Places the piece's frame relative to the broken model's origin and
     * fades it to an alpha factor.
     *
     * @mangled Draw__9CFragmentFPff
     * @address 0x2D0740
     * @size 0x90
     */
    void Draw(float *camera_pos, float alpha);

    /**
     *
     * Moves the piece one step against the collision triangles around it,
     * bouncing it off any it hits and splashing where it passes through water.
     *
     * @mangled Step__9CFragmentFP6CCPolyi
     * @address 0x2D07D0
     * @size 0x370
     */
    void Step(CCPoly *polys, int poly_count);

    /**
     *
     * Starts the piece moving from a position at a velocity, under gravity.
     *
     * @mangled Set__9CFragmentFPfPf
     * @address 0x2D0B40
     * @size 0x60
     */
    void Set(float *position, float *velocity);

    /**
     *
     * Makes the piece inactive with no frame and no index.
     *
     * @mangled Init__9CFragmentFv
     * @address 0x2D0BA0
     * @size 0x50
     */
    void Init();
};

STATIC_ASSERT(sizeof(CFragment) == 0x60);

/**
 *
 * The broken form of a pot or box: the pieces that scatter from the point where it smashed and fade out.
 *
 */
class CBPot {
public:
    int           timer{};                     /**< Steps left before the pieces are hidden; the pieces fade over the last BPOT_FADE_TIME. */
    int           type{};                      /**< Kind of broken object, from BPOT_TYPE. */
    CMapParts    *parts{};                     /**< Map part that holds the broken model, or NULL. */
    CMapPiece    *piece{};                     /**< Piece of the map part that is the broken model, or NULL. */
    mgCFrame     *frame{};                     /**< Frame of the broken model, under which each piece's frame lies, or NULL. */
    sceVu0FVECTOR position{};                  /**< World position of the smash, from which the pieces are placed. */
    int           fragment_num{};              /**< Number of pieces in use. */
    CFragment     fragment[BPOT_FRAGMENT_MAX]; /**< Broken pieces. */
    float (*offset)[4]{};                      /**< Starting offset of each piece from the smash, one per piece. */

    /**
     *
     * Makes a broken object with no model and no pieces in use.
     *
     */
    CBPot() { Init(); }

    /**
     *
     * Smashes the object at a position: shows the broken model there and
     * throws each piece out from its offset, pushed along a velocity.
     *
     * @mangled Clash__5CBPotFPfPfPf
     * @address 0x2D0BF0
     * @size 0x170
     */
    void Clash(float *hit_position, float *unused, float *normal);

    /**
     *
     * Moves and draws the pieces while the break lasts, and hides the broken
     * model when it ends.
     *
     * @mangled Step__5CBPotFv
     * @address 0x2D0D60
     * @size 0x1C0
     */
    void Step();

    /**
     *
     * Sets up the broken model for a kind of object from a map part, finding
     * the frame of each piece. Returns the number of pieces found.
     *
     * @mangled SetObject2__5CBPotFiP9CMapParts
     * @address 0x2D0F20
     * @size 0x1F0
     */
    int SetObject2(int kind, CMapParts *parts);

    /**
     *
     * Clears the broken object: no model, no pieces in use, every piece
     * inactive.
     *
     * @mangled Init__5CBPotFv
     * @address 0x2D1110
     * @size 0x80
     */
    void Init();
};

STATIC_ASSERT(sizeof(CBPot) == 0xC50);

/**
 *
 * A pot or box that the player carries above their head and throws, which smashes when it hits something.
 *
 */
class CPot {
public:
    int           state{};         /**< What the pot is doing, from POT_STATE. */
    CMapParts    *parts{};         /**< Map part that is the pot, or NULL when there is no pot. */
    sceVu0FVECTOR position{};      /**< World position of the pot. */
    sceVu0FVECTOR velocity{};      /**< Distance the thrown pot moves each step. */
    sceVu0FVECTOR gravity{};       /**< Change of velocity each step while thrown. */
    sceVu0FVECTOR hold_pos{};      /**< Position of the pot at the last held step, from which it is thrown. */
    sceVu0FVECTOR prev_hold_pos{}; /**< Position of the pot at the held step before the last. */
    sceVu0FVECTOR break_pos{};     /**< Position at which the pot was last smashed or put away. */
    int           fly_time{};      /**< Steps the pot has been flying. */

    /**
     *
     * Makes a pot that is neither held nor flying.
     *
     */
    CPot() { Init(0); }

    /**
     *
     * Makes the pot follow its map part while it is carried.
     *
     * @mangled HoldStep__4CPotFv
     * @address 0x2D1190
     * @size 0x60
     */
    void HoldStep();

    /**
     *
     * Moves the thrown pot one step against the collision around it,
     * smashing it when it hits something. Returns a POT_STEP_RESULT.
     *
     * @mangled FlyStep__4CPotFv
     * @address 0x2D11F0
     * @size 0x4A0
     */
    int FlyStep();

    /**
     *
     * Puts the pot away out of sight below where it is and lets it go,
     * keeping where it was.
     *
     * @mangled Clear__4CPotFv
     * @address 0x2D1690
     * @size 0x80
     */
    void Clear();

    /**
     *
     * Smashes the pot where it is, with the sound of its kind, throwing its
     * pieces along a velocity, and puts it away.
     *
     * @mangled Bakuhatsu__4CPotFPfPf
     * @address 0x2D1710
     * @size 0xD0
     */
    void Bakuhatsu(float *position_, float *normal);

    /**
     *
     * Steps the pot as it is held or flying. Returns a POT_STEP_RESULT.
     *
     * @mangled Step__4CPotFv
     * @address 0x2D17E0
     * @size 0x80
     */
    int Step();

    /**
     *
     * Throws the held pot forward along the direction the player faces.
     *
     * @mangled Throw__4CPotFv
     * @address 0x2D1860
     * @size 0x110
     */
    void Throw();

    /**
     *
     * Starts carrying a map part as the pot.
     *
     * @mangled Hold__4CPotFP9CMapParts
     * @address 0x2D1970
     * @size 0x50
     */
    void Hold(CMapParts *parts);

    /**
     *
     * Makes the pot neither held nor flying; a keep of 1 leaves its velocity
     * and break position as they are.
     *
     * @mangled Init__4CPotFi
     * @address 0x2D19C0
     * @size 0x90
     */
    void Init(int keep);
};

STATIC_ASSERT(sizeof(CPot) == 0x80);

/**
 *
 * Reflects a direction off a surface: gives the direction mirrored about the
 * surface's normal, with w of 1.
 *
 * @mangled CalcReflectionVector__FPfPfPf
 * @address 0x2D0670
 * @size 0xD0
 */
void CalcReflectionVector(float *incoming, float *surface, float *reflected);

/**
 *
 * Starting offsets of the twelve pieces of a broken box from the smash.
 *
 */
extern float box_offset[12][4];

/**
 *
 * Starting offsets of the ten pieces of the first kind of broken rock from
 * the smash.
 *
 */
extern float iwa0_offset[10][4];

/**
 *
 * Starting offsets of the nine pieces of the second kind of broken rock from
 * the smash.
 *
 */
extern float iwa1_offset[9][4];
