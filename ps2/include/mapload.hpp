#pragma once

#include "common.h"

#include <libvu0.h>

#include <cstring>

#include "mg_drawenv.hpp"
#include "mg_frame.hpp"

/**
 * @file
 * Declares what the map and configuration script loaders fill in: the
 * lighting sets, the function points placed on a map, the material colours
 * of a map piece and the part groups of a fixed camera, together with the
 * time-of-day bands the lighting follows.
 */

class CFuncPointCheck;

/**
 *
 * Bands of the day that a map's hour of the day falls in.
 *
 */
enum MAP_TIME_BAND {
    MAP_TIME_BAND_DAY = 0,     /**< From 9:00 until 17:00. */
    MAP_TIME_BAND_EVENING = 1, /**< From 17:00 until 21:00. */
    MAP_TIME_BAND_NIGHT = 2,   /**< From 21:00 until 6:00. */
    MAP_TIME_BAND_MORNING = 3, /**< From 6:00 until 9:00. */
    MAP_TIME_BAND_NUM = 4,     /**< Number of bands, and the number of light sets that follow them one to one. */
};

/**
 *
 * Kinds of function point, each kept in its own list of a function point manager.
 *
 */
enum FUNC_POINT_TYPE {
    FUNC_POINT_NONE = 0,   /**< No function; given to an effect point whose effect is not found. */
    FUNC_POINT_EFFECT = 1, /**< Plays one of the map's effects, script word "effect". */
    FUNC_POINT_FIRE = 2,   /**< Draws a fire, script word "fire". */
    FUNC_POINT_FLARE = 3,  /**< Draws a flare, script word "flare". */
    FUNC_POINT_PLIGHT = 4, /**< Lights the surroundings as a point light, script word "plight". */
    FUNC_POINT_ANIME = 5,  /**< Animates a frame of a map piece, script word "anime". */
    FUNC_POINT_EVENT = 6,  /**< Starts an event when the player reaches it, script word "event". */
    FUNC_POINT_INVENT = 7, /**< Covers a box, script word "invent". */
    FUNC_POINT_SOUND = 8,  /**< Plays a sound effect around it, script word "sound". */
    FUNC_POINT_POS = 9,    /**< Marks a named position, script word "pos". */
    FUNC_POINT_TYPE_NUM,   /**< Number of kinds, and of lists in a function point manager. */
};

/**
 *
 * Bits of the flags of an event function point.
 *
 */
enum FUNC_EVENT_FLAG {
    FUNC_EVENT_EVERY = 0x1,          /**< Set by the configuration word "every". */
    FUNC_EVENT_ACTION = 0x2,         /**< Starts only on the action button. */
    FUNC_EVENT_ITEM = 0x4,           /**< Starts only when an item is used. */
    FUNC_EVENT_DOOR = 0x8,           /**< A door, whose point is moved in front of its position. */
    FUNC_EVENT_ED_DOOR = 0x10,       /**< Set only for the "ed_door" kind. */
    FUNC_EVENT_LADDER_BOTTOM = 0x20, /**< The foot of a ladder, kind "lddr_b". */
    FUNC_EVENT_LADDER_TOP = 0x40,    /**< The top of a ladder, kind "lddr_t". */
    FUNC_EVENT_CLOSE_DOOR = 0x80,    /**< Set only for the "close_door" kind. */
    FUNC_EVENT_UNK_100 = 0x100,      /**< Set for the door kinds, and by the tenth argument of the map tag. */
    FUNC_EVENT_TREASURE_BOX = 0x200, /**< A treasure box, kind "t_box". */
    FUNC_EVENT_BOOK = 0x400,         /**< A book, kind "book". */
};

/**
 *
 * Kinds of light a light function point gives the parts around it.
 *
 */
enum FUNC_PLIGHT_TYPE {
    FUNC_PLIGHT_DIRECTIONAL = 0, /**< A directional light from the point's direction. */
    FUNC_PLIGHT_AMBIENT = 1,     /**< The ambient colour. */
    FUNC_PLIGHT_POINT = 2,       /**< A point light at the point's position; the only kind GetLight hands out. */
};

/**
 *
 * Ways the strength of a point light function point varies over time.
 *
 */
enum FUNC_PLIGHT_FLICKER {
    FUNC_PLIGHT_FLICKER_NONE = 0,   /**< Steady. */
    FUNC_PLIGHT_FLICKER_RANDOM = 1, /**< Random each frame, down by at most the depth. */
    FUNC_PLIGHT_FLICKER_SINE = 2,   /**< Along a sine wave of the period. */
    FUNC_PLIGHT_FLICKER_SAW = 3,    /**< Falls by the depth over the period, then jumps back. */
};

/**
 *
 * One lighting set of a map: projection, background colours, directional, ambient and point lights, and fog.
 *
 */
class CMapLightingInfo {
public:
    float         projection;     /**< Distance to the projection plane, set from a horizontal field of view of 52 degrees. */
    sceVu0FVECTOR bg_color;       /**< Background colour, 0 to 255 with w of 128. */
    sceVu0FVECTOR bg_color2;      /**< Second background colour; takes bg_color when given as black. */
    sceVu0FMATRIX light_dir;      /**< Direction of each of the four directional lights, one light per column. */
    sceVu0FMATRIX light_color;    /**< Colour of each of the four directional lights, one light per row. */
    int           plight_enable;  /**< Non-zero once a point light has been given. */
    mgPOINT_LIGHT point_light[4]; /**< Point lights. */
    sceVu0FVECTOR ambient;        /**< Ambient light colour, 0 to 255 with w of 128. */
    int           fog_enable;     /**< Non-zero to draw fog. */
    mgFOG_PARAM   fog;            /**< Fog distances, colour and strengths. */

    /**
     *
     * Creates a lighting set with every value zero.
     *
     * @mangled __ct__16CMapLightingInfoFv
     * @address 0x1670B0
     * @size 0x30
     */
    CMapLightingInfo() { memset(this, 0, sizeof(CMapLightingInfo)); }
};

STATIC_ASSERT(sizeof(CMapLightingInfo) == 0x1D0);

/**
 *
 * A point placed on a map or a map part that gives a function to its position: an effect, a light, an event and so on.
 *
 */
class CFuncPoint {
public:
    /**
     *
     * Settings of an effect point.
     *
     */
    struct EffectData {
        char *name;  /**< Name of the effect. */
        int   index; /**< Index of the effect in the map's effect list. */
    };

    /**
     *
     * Settings of a fire or flare point.
     *
     */
    struct FireData {
        sceVu0FVECTOR color;      /**< Colour, 0 to 128 with w of 128. */
        int           effect_off; /**< Non-zero leaves out the fire effect drawn at the point. */
        int           heat_haze;  /**< Non-zero draws the map's CFireRaster heat haze above the point. */
        int           cast_light; /**< Non-zero makes the fire light its surroundings as a point light. */
    };

    /**
     *
     * Settings of a point light point.
     *
     */
    struct PlightData {
        sceVu0FVECTOR color;       /**< Colour of the light, with w of 0. */
        float         power;       /**< Strength of the light. */
        float         range;       /**< Distance the light reaches. */
        int           light_type;  /**< Kind of light, a FUNC_PLIGHT_TYPE. */
        int           light_chara; /**< Non-zero lets the light reach characters. */
        int           unk_40;
        int           unk_44;
        int           no_map_light;   /**< Non-zero keeps the light off the map itself. */
        int           flicker_type;   /**< How the strength varies, a FUNC_PLIGHT_FLICKER. */
        float         flicker_depth;  /**< Largest fraction of the strength that the variation takes away. */
        float         flicker_period; /**< Frames one cycle of the variation lasts. */
    };

    /**
     *
     * Settings of an animation point.
     *
     */
    struct AnimeData {
        char         *parts_name;  /**< Placed part that the animation controls. */
        char         *piece_name;  /**< Name of the map piece animated. */
        char         *frame_name;  /**< Name of the frame of that piece animated. */
        int           kind;        /**< Value the animation drives, an OBJ_ANIME_PARAM. */
        int           mode;        /**< How the value moves each step, an OBJ_ANIME_MODE. */
        s16           uniform;     /**< Non-zero copies the first component to the other two. */
        s16           piece_space; /**< Non-zero applies a position in the space of the piece. */
        sceVu0FVECTOR param;       /**< Start value of the animation. */
        sceVu0FVECTOR speed;       /**< Value added each step; for the clock and time modes, the time range and fade. */
        sceVu0FVECTOR end;         /**< End value of the animation. */
    };

    /**
     *
     * Settings of an event point.
     *
     */
    struct EventData {
        u32  flag;       /**< FUNC_EVENT_FLAG bits. */
        int  event_no;   /**< Event the point starts, used when above zero. */
        int  point_no;   /**< Event point number, or treasure-box index for a box point. */
        int  arg1;       /**< First integer argument of the event point. */
        int  arg2;       /**< Second integer argument of the event point. */
        int  arg3;       /**< Third integer argument of the event point. */
        char target[16]; /**< Name of the event point's target. */
    };

    /**
     *
     * Settings of a sound point.
     *
     */
    struct SoundData {
        int           se_no;     /**< Sound effect played. */
        float         near_dist; /**< Distance at which the sound starts its spatial falloff. */
        float         far_dist;  /**< Distance at which the sound ends its spatial falloff. */
        float         unk_2c;
        int           shape; /**< 1 to sound along the line from start to end rather than from the point's position. */
        sceVu0FVECTOR start; /**< First end of the sounding line, in the point's space. */
        sceVu0FVECTOR end;   /**< Second end of the sounding line, in the point's space. */
    };

    /**
     *
     * Settings of an invention point.
     *
     */
    struct InventData {
        int       neta_no; /**< Photo subject (neta) the point gives a picture taken of it. */
        int       unk_24;
        float     range; /**< Distance the point reaches, 400 when zero. */
        float     angle; /**< Angle in radians, given in degrees by the script. */
        mgVu0FBOX box;   /**< Box the point covers. */
    };

    char *name; /**< Name the point is searched by, or null. */
    int   type; /**< Kind of point, a FUNC_POINT_TYPE. */
    int   unk_8;
    int   flag_no;
    int   enable; /**< Non-zero while the point works. */
    float start;  /**< Hour of the day the point starts working. */
    float end;    /**< Hour of the day the point stops working; equal to start for all day. */

    union {
        int        data[0x14]; /**< Settings of the point as raw words, copied as a whole. */
        EffectData effect;     /**< Settings of a FUNC_POINT_EFFECT point. */
        FireData   fire;       /**< Settings of a FUNC_POINT_FIRE or FUNC_POINT_FLARE point. */
        PlightData plight;     /**< Settings of a FUNC_POINT_PLIGHT point. */
        AnimeData  anime;      /**< Settings of a FUNC_POINT_ANIME point. */
        EventData  event;      /**< Settings of a FUNC_POINT_EVENT point. */
        SoundData  sound;      /**< Settings of a FUNC_POINT_SOUND point. */
        InventData invent;     /**< Settings of a FUNC_POINT_INVENT point. */
    };

    mgCFrame      frame;    /**< Places the point in the world. */
    sceVu0FVECTOR position; /**< Position given to the frame. */
    sceVu0FVECTOR rotation; /**< Rotation given to the frame. */
    sceVu0FVECTOR scale;    /**< Scale given to the frame. */
    int           active;   /**< Result of the last check of the point against the time of day. */

    /**
     *
     * Creates a point with a new frame and its other values unset.
     *
     * @mangled __ct__10CFuncPointFv
     * @address 0x15F5D0
     * @size 0x30
     */
    CFuncPoint() {}

    /**
     *
     * Resets the point to an enabled, all-day point at the origin with no settings.
     *
     * @mangled Initialize__10CFuncPointFv
     * @address 0x2A0460
     * @size 0x80
     */
    void Initialize();

    /**
     *
     * Tells whether the point works, given the time of day of a check or no check.
     *
     * @mangled Check__10CFuncPointFP15CFuncPointCheck
     * @address 0x2A04E0
     * @size 0x50
     */
    int Check(CFuncPointCheck *check);

    /**
     *
     * Moves the point and its frame to a position.
     *
     * @mangled SetPosition__10CFuncPointFPf
     * @address 0x1657F0
     * @size 0x20
     */
    void SetPosition(float *position);

    /**
     *
     * Turns the point and its frame to an angle about each axis.
     *
     * @mangled SetRotation__10CFuncPointFPf
     * @address 0x1657D0
     * @size 0x20
     */
    void SetRotation(float *rotation);

    /**
     *
     * Scales the point and its frame along each axis.
     *
     * @mangled SetScale__10CFuncPointFPf
     * @address 0x1657B0
     * @size 0x20
     */
    void SetScale(float *scl);
};

STATIC_ASSERT(sizeof(CFuncPoint) == 0x1C0);

/**
 *
 * Colour a map piece gives one material of one of its frames while the piece is drawn.
 *
 */
class PieceMaterial {
public:
    mgCFrame     *frame;       /**< Frame of the piece that holds the material. */
    int           material_no; /**< Index of the material in the frame's visual. */
    mgMaterial   *material;    /**< Material whose colour is replaced, or null. */
    int           color_no;
    sceVu0FVECTOR color; /**< Colour the material takes while the piece is drawn. */

    /**
     *
     * Creates an entry with every value zero.
     *
     * @mangled __ct__13PieceMaterialFv
     * @address 0x163B70
     * @size 0x30
     */
    PieceMaterial();

    /**
     *
     * Sets every value of the entry to zero.
     *
     * @mangled Initialize__13PieceMaterialFv
     * @address 0x163BA0
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(PieceMaterial) == 0x20);

/**
 *
 * Map part group that a fixed camera area switches on while the camera is in use.
 *
 */
class CCameraDrawInfo {
public:
    int group_no; /**< Index of the map's part group, or -1 for none. */
    int unk_4;

    /**
     *
     * Creates an entry that names no part group.
     *
     * @mangled __ct__15CCameraDrawInfoFv
     * @address 0x164320
     * @size 0x30
     */
    CCameraDrawInfo();

    /**
     *
     * Makes the entry name no part group.
     *
     * @mangled Initialize__15CCameraDrawInfoFv
     * @address 0x164350
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CCameraDrawInfo) == 0x8);

/**
 *
 * Name of the part group that the map part being placed by the map script joins, or empty for none.
 *
 * @mangled mapMapPartsGroupName
 * @address 0x3F3260
 * @size 0x100
 */
extern char mapMapPartsGroupName[0x100];

/**
 *
 * Position of the map part being placed by the map script.
 *
 * @mangled mapPos
 * @address 0x3F3360
 * @size 0x10
 */
extern sceVu0FVECTOR mapPos;

/**
 *
 * Rotation of the map part being placed by the map script.
 *
 * @mangled mapRot
 * @address 0x3F3370
 * @size 0x10
 */
extern sceVu0FVECTOR mapRot;

/**
 *
 * Scale of the map part being placed by the map script.
 *
 * @mangled mapScale
 * @address 0x3F3380
 * @size 0x10
 */
extern sceVu0FVECTOR mapScale;

/**
 *
 * Gives the band of the day that an hour of the day falls in.
 *
 * @mangled GetTimeBand__Ff
 * @address 0x162080
 * @size 0xC0
 */
MAP_TIME_BAND GetTimeBand(float time);

/**
 *
 * Gives the absolute value of a number.
 *
 * @mangled mgAbs__Ff
 * @address 0x163050
 * @size 0x30
 */
inline float mgAbs(float value) {
    if (value < 0.0f) {
        return -value;
    }

    return value;
}

/**
 *
 * Gives the number of 16-byte units needed to hold a number of bytes.
 *
 * @mangled algn16_size__FUi
 * @address 0x163240
 * @size 0x20
 */
unsigned int algn16_size(unsigned int size);
