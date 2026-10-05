#pragma once

#include "common.h"

#include <libvu0.h>

#include "mapload.hpp"
#include "mg_tanime.hpp"

/**
 * @file
 * Declares the function points of a map and its placed parts: the manager
 * that keeps them in one list per kind, the conditions they are checked
 * against, the animations they drive on the pieces of a part, and the
 * helpers that draw their fire, find their lights and place their sounds.
 */

class mgCFrame;
class mgCMemory;
class mgCTexture;
class CFireRaster;
class CMapParts;
class CMapPiece;

/**
 *
 * Bits of CFuncPointMngr::flag that say which kinds of point the manager holds.
 *
 */
enum FUNC_POINT_MNGR_FLAG {
    FUNC_POINT_MNGR_ANY = 0x1,     /**< Holds at least one point. */
    FUNC_POINT_MNGR_BURN = 0x2,    /**< Holds a fire or flare point. */
    FUNC_POINT_MNGR_FIRE = 0x4,    /**< Holds a fire point. */
    FUNC_POINT_MNGR_FLARE = 0x8,   /**< Holds a flare point. */
    FUNC_POINT_MNGR_EFFECT = 0x10, /**< Holds an effect point. */
    FUNC_POINT_MNGR_PLIGHT = 0x20, /**< Holds a light point. */
    FUNC_POINT_MNGR_LIGHT = 0x40,  /**< Holds a point that casts a point light. */
    FUNC_POINT_MNGR_SOUND = 0x80,  /**< Holds a point that makes a sound (a fire or sound point). */
    FUNC_POINT_MNGR_EVENT = 0x100, /**< Holds an event point. */
};

/**
 *
 * Values of a piece that an animation point drives.
 *
 */
enum OBJ_ANIME_PARAM {
    OBJ_ANIME_PARAM_POSITION = 1, /**< Position of the frame. */
    OBJ_ANIME_PARAM_ROTATION = 2, /**< Rotation of the frame, given in degrees. */
    OBJ_ANIME_PARAM_SCALE = 3,    /**< Scale of the frame. */
    OBJ_ANIME_PARAM_COLOR = 4,    /**< Colour the frame is drawn with, unlit. */
    OBJ_ANIME_PARAM_ALPHA = 5,    /**< Alpha factor the frame is drawn with. */
};

/**
 *
 * Ways an animation point moves the value it drives each step.
 *
 */
enum OBJ_ANIME_MODE {
    OBJ_ANIME_MODE_NONE = 0,          /**< Leaves the value as it is. */
    OBJ_ANIME_MODE_LOOP = 1,          /**< Adds the speed every step without end. */
    OBJ_ANIME_MODE_STOP = 2,          /**< Adds the speed until the end value, then holds there. */
    OBJ_ANIME_MODE_REPEAT = 3,        /**< Adds the speed until the end value, then starts again from the start value. */
    OBJ_ANIME_MODE_PINGPONG = 4,      /**< Moves back and forth between the start and end values. */
    OBJ_ANIME_MODE_PINGPONG_ONCE = 5, /**< Moves to the end value and back to the start value once, then stops. */
    OBJ_ANIME_MODE_LOOK = 6,          /**< Turns the frame to face the player, within the start and end angles. */
    OBJ_ANIME_MODE_RANDOM = 7,        /**< Picks a random value between the start and end values every step. */
    OBJ_ANIME_MODE_CLOCK_MINUTE = 8,  /**< Turns about Y once per hour of the time of day, as a clock's minute hand. */
    OBJ_ANIME_MODE_CLOCK_HOUR = 9,    /**< Turns about Y once per twelve hours of the time of day, as a clock's hour hand. */
    OBJ_ANIME_MODE_TIME = 10,         /**< Moves between the start and end values as the time of day enters and leaves the point's time range. */
};

/**
 *
 * Conditions function points are checked against: the time of day and the animation frame.
 *
 */
class CFuncPointCheck {
public:
    float time;      /**< Time of day, in hours, that a point's time range must contain. */
    s32 anime_frame; /**< Frames counted by the map, that light animations are timed by. */

    /**
     *
     * Creates conditions for midnight.
     *
     */
    CFuncPointCheck() { time = 0.0f; }
};

STATIC_ASSERT(sizeof(CFuncPointCheck) == 0x8);

/**
 *
 * What an animation step looks at: where the player is and the time of day.
 *
 */
class CObjAnimeEnv {
public:
    sceVu0FVECTOR chara_pos; /**< Position of the player, that looking animations turn towards. */
    float time;              /**< Time of day, in hours, that clock and time animations follow. */
    u8    unk_14[0x4C];
};

/**
 *
 * Moves one value of a piece of a placed part as an animation point describes.
 *
 */
class CObjAnime {
public:
    CFuncPoint *func_point; /**< Animation point that describes the motion. */
    mgCFrame *frame;        /**< Frame of the piece that is moved, or NULL to move the piece or part as a whole. */
    CMapPiece *piece;       /**< Piece of the part that the point names, or NULL. */
    CMapParts *parts;       /**< Placed part the animation belongs to. */
    s32 stop;               /**< Non-zero once the animation has finished and no longer steps. */
    s32 back;               /**< Non-zero while a back-and-forth animation moves towards its start value. */
    s32 unk_18;
    s32 unk_1c;
    sceVu0FVECTOR param;    /**< Value currently given to the frame, piece or part. */

    /**
     *
     * Creates an animation that moves nothing.
     *
     * @mangled __ct__9CObjAnimeFv
     * @address 0x1616B0
     * @size 0x20
     */
    CObjAnime();

    /**
     *
     * Advances the animation by one step and applies the new value.
     *
     * @mangled Step__9CObjAnimeFP12CObjAnimeEnv
     * @address 0x2A05D0
     * @size 0x650
     */
    void Step(CObjAnimeEnv *env);

    /**
     *
     * Applies a value to the frame, piece or part the animation moves.
     *
     * @mangled SetParam__9CObjAnimeFPf
     * @address 0x2A0C20
     * @size 0x3B0
     */
    void SetParam(float *value);

    /**
     *
     * Gives back the value last applied, in the units the animation point uses.
     *
     * @mangled GetParam__9CObjAnimeFPf
     * @address 0x2A0FD0
     * @size 0xE0
     */
    void GetParam(float *out_value);

    /**
     *
     * Binds the animation to an animation point and the piece of a part it names; non-zero on success.
     *
     * @mangled AssignFuncAnime__9CObjAnimeFP10CFuncPointP9CMapParts
     * @address 0x2A10B0
     * @size 0x110
     */
    int AssignFuncAnime(CFuncPoint *point, CMapParts *parts);
};

STATIC_ASSERT(sizeof(CObjAnime) == 0x30);

template <>
void CList<CFuncPoint>::Initialize();

/**
 *
 * Keeps the function points of a map or placed part in one list per kind and walks through them.
 *
 */
class CFuncPointMngr {
public:
    u32 flag;                                   /**< Kinds of point held, from FUNC_POINT_MNGR_FLAG. */
    CList<CFuncPoint> *list[FUNC_POINT_TYPE_NUM]; /**< First node of the list of each kind of point, from FUNC_POINT_TYPE. */
    CList<CFuncPoint> *now;                     /**< Node that Get gives back next. */

    /**
     *
     * Creates a manager that holds no points.
     *
     */
    CFuncPointMngr() { Initialize(); }

    /**
     *
     * Makes a new point of a kind and adds it to that kind's list; gives back the point, or NULL.
     *
     * @mangled Add__14CFuncPointMngrFiP9mgCMemory
     * @address 0x2A11C0
     * @size 0xA0
     */
    CFuncPoint *Add(int type, mgCMemory *stack);

    /**
     *
     * Adds a node to the end of a kind's list; gives back the node's point, or NULL.
     *
     * @mangled Add__14CFuncPointMngrFiP19CList_10CFuncPoint_
     * @address 0x2A1270
     * @size 0x90
     */
    CFuncPoint *Add(int type, CList<CFuncPoint> *node);

    /**
     *
     * Makes a number of unused points and keeps them in the reserve list.
     *
     * @mangled Reserve__14CFuncPointMngrFiP9mgCMemory
     * @address 0x2A1300
     * @size 0xE0
     */
    void Reserve(int num, mgCMemory *stack);

    /**
     *
     * Takes the last node off the reserve list, or gives back NULL when it is empty.
     *
     * @mangled GetReserve__14CFuncPointMngrFv
     * @address 0x2A1430
     * @size 0x90
     */
    CList<CFuncPoint> *GetReserve();

    /**
     *
     * Takes a reserved point, clears it and adds it to a kind's list; gives back the point, or NULL.
     *
     * @mangled AddFromReserve__14CFuncPointMngrFi
     * @address 0x2A14C0
     * @size 0x70
     */
    CFuncPoint *AddFromReserve(int type);

    /**
     *
     * Counts the points of a kind.
     *
     * @mangled GetNum__14CFuncPointMngrFi
     * @address 0x2A1530
     * @size 0x70
     */
    int GetNum(int type);

    /**
     *
     * Counts the event points that have any of the given event flags set.
     *
     * @mangled GetEventNum__14CFuncPointMngrFi
     * @address 0x2A15A0
     * @size 0x90
     */
    int GetEventNum(int event_flag);

    /**
     *
     * Counts the points of a kind that passed their last check.
     *
     * @mangled EnableFuncNum__14CFuncPointMngrFi
     * @address 0x2A1630
     * @size 0x60
     */
    int EnableFuncNum(int type);

    /**
     *
     * Starts walking through the points of a kind.
     *
     * @mangled GetStart__14CFuncPointMngrFi
     * @address 0x2A1690
     * @size 0x40
     */
    void GetStart(int type);

    /**
     *
     * Gives back the next point of the walk, or NULL at its end.
     *
     * @mangled Get__14CFuncPointMngrFv
     * @address 0x2A16D0
     * @size 0x30
     */
    CFuncPoint *Get();

    /**
     *
     * Ends a walk through the points.
     *
     * @mangled GetEnd__14CFuncPointMngrFv
     * @address 0x2A1700
     * @size 0x10
     */
    void GetEnd();

    /**
     *
     * Finds a point of any kind but the reserve by name, ignoring case, or gives back NULL.
     *
     * @mangled Search__14CFuncPointMngrFPc
     * @address 0x2A1710
     * @size 0xB0
     */
    CFuncPoint *Search(char *name);

    /**
     *
     * Copies the nearest point lights that reach a sphere into an array of points and gives back how many.
     *
     * @mangled GetLight__14CFuncPointMngrFPfP10CFuncPointiP15CFuncPointChecki
     * @address 0x2A17C0
     * @size 0x620
     */
    int GetLight(float *sphere, CFuncPoint *out_lights, int max, CFuncPointCheck *check, int mode);

    /**
     *
     * Checks every point of a kind against the conditions and records the results.
     *
     * @mangled Step__14CFuncPointMngrFiP15CFuncPointCheck
     * @address 0x2A1DE0
     * @size 0x10
     */
    void Step(int type, CFuncPointCheck *check);

    /**
     *
     * Checks every point of a kind against the conditions, records the results and gives back how many passed.
     *
     * @mangled UpdateFlag__14CFuncPointMngrFiP15CFuncPointCheck
     * @address 0x2A1DF0
     * @size 0x90
     */
    int UpdateFlag(int type, CFuncPointCheck *check);

    /**
     *
     * Sets the bits of flag for the kinds of point the manager holds.
     *
     * @mangled UpdateStatus__14CFuncPointMngrFv
     * @address 0x2A1E80
     * @size 0x120
     */
    void UpdateStatus();

    /**
     *
     * Empties the manager, dropping every list.
     *
     * @mangled Initialize__14CFuncPointMngrFv
     * @address 0x2A2170
     * @size 0x70
     */
    void Initialize();

    /**
     *
     * Copies every point into another manager, making the new points on a stack; non-zero on success.
     *
     * @mangled Copy__14CFuncPointMngrFR14CFuncPointMngrP9mgCMemory
     * @address 0x2A1FA0
     * @size 0x1D0
     */
    virtual int Copy(CFuncPointMngr &dest, mgCMemory *stack);
};

STATIC_ASSERT(sizeof(CFuncPointMngr) == 0x34);

/**
 *
 * Tells whether a time of day lies within a time range, which may wrap past midnight.
 *
 * @mangled CheckTime__Ffff
 * @address 0x2A02B0
 * @size 0xA0
 */
int CheckTime(float time, float start, float end);

/**
 *
 * Brings a time of day into the range 0 to 24 hours.
 *
 * @mangled LimitTime__Ff
 * @address 0x2A0350
 * @size 0xC0
 */
float LimitTime(float time);

/**
 *
 * Gives the number of hours between two times of day, the short way round the clock.
 *
 * @mangled SubTime__Fff
 * @address 0x2A0410
 * @size 0x50
 */
float SubTime(float time, float sub);

/**
 *
 * Draws the fire sprites of the fire points and the glows of the flare points that passed their check.
 *
 * @mangled DrawFireEffect__FPA4_fP14CFuncPointMngrP15CFuncPointCheckfP10mgCTextureP10mgCTexture
 * @address 0x2A21E0
 * @size 0x6B0
 */
void DrawFireEffect(float (*lw_matrix)[4], CFuncPointMngr *mngr, CFuncPointCheck *check, float rate, mgCTexture *fire_tex, mgCTexture *light_tex);

/**
 *
 * Draws the heat haze above the fire points that passed their check, at a middle distance from the camera.
 *
 * @mangled DrawFireRaster__FPA4_fP14CFuncPointMngrP15CFuncPointCheckP11CFireRaster
 * @address 0x2A2890
 * @size 0x120
 */
void DrawFireRaster(float (*lw_matrix)[4], CFuncPointMngr *mngr, CFuncPointCheck *check, CFireRaster *raster);

/**
 *
 * Gives the sound, volume and pan of every audible fire and sound point, and how many there are.
 *
 * @mangled GetSeSrcVolPan__FPA4_fP14CFuncPointMngrP15CFuncPointCheckPiPfPfi
 * @address 0x2A29B0
 * @size 0x2A0
 */
int GetSeSrcVolPan(float (*lw_matrix)[4], CFuncPointMngr *mngr, CFuncPointCheck *check, int *out_se_no, float *out_vol, float *out_pan, int max);

/**
 *
 * Gives the brightness factor of a light point on an animation frame, from 0 to 1.
 *
 * @mangled GetLightAnimeWeight__FP10CFuncPointi
 * @address 0x2A2C50
 * @size 0x220
 */
float GetLightAnimeWeight(CFuncPoint *point, int frame);
