#pragma once

#include "common.h"

#include <libgraph.h>
#include <libvu0.h>

/**
 * @file
 * Declares the engine's GS draw environment packet, the render state that
 * holds the scene's transforms, lights and fog, and the axis-aligned box.
 */

class mgCFrameAttr;

/**
 *
 * Blend modes that mgCDrawEnv::SetAlpha writes into the GS alpha register.
 *
 */
enum mgAlphaMacroID {
    MG_ALPHA_MACRO_NONE = 0,    /**< Alpha register holds none of the modes GetAlphaMacroID recognises. */
    MG_ALPHA_MACRO_BLEND = 1,   /**< (Cs - Cd) * As + Cd: ordinary translucency. */
    MG_ALPHA_MACRO_ADD = 2,     /**< Cs * As + Cd: additive blending scaled by source alpha. */
    MG_ALPHA_MACRO_SUB = 3,     /**< Cd - Cs * As: subtractive blending. */
    MG_ALPHA_MACRO_OPAQUE = 4,  /**< Cs: the source colour replaces the frame buffer. */
    MG_ALPHA_MACRO_ADD_FIX = 5, /**< Cs * 0x80 / 0x80 + Cd: additive blending that ignores source alpha. */
};

/**
 *
 * Settings that mgCDrawEnv::SetZBuf applies to the depth buffer's write mask.
 *
 */
enum mgZBufMode {
    MG_ZBUF_NO_WRITE = -1, /**< Depth is tested but not written. */
    MG_ZBUF_KEEP = 0,      /**< Leaves the write mask as it is. */
    MG_ZBUF_WRITE = 1,     /**< Depth is tested and written. */
};

/**
 *
 * Axis-aligned box in floating point, held as its largest and smallest corners.
 *
 */
struct mgVu0FBOX {
    sceVu0FVECTOR max; /**< Corner with the largest coordinate on every axis. */
    sceVu0FVECTOR min; /**< Corner with the smallest coordinate on every axis. */

    /**
     *
     * Copies both corners of another box into this one.
     *
     * @mangled __as__9mgVu0FBOXFR9mgVu0FBOX
     * @address 0x139F00
     * @size 0x20
     */
    mgVu0FBOX &operator=(mgVu0FBOX &source);
};

STATIC_ASSERT(sizeof(mgVu0FBOX) == 0x20);

/**
 *
 * Four floating-point values used by drawing calculations.
 *
 */
struct mgVec4 {
    float v[4]; /**< Vector components. */
};

/**
 *
 * Point light: a coloured light at a position that reaches objects within its range.
 *
 */
struct mgPOINT_LIGHT {
    union {
        sceVu0FVECTOR pos;      /**< Position of the light in world space. */
        mgVec4        pos_copy; /**< Stored vector view of the light's position. */
    }; /**< World position of the light; the stored copy has w = 1. */

    union {
        sceVu0FVECTOR color;      /**< Colour of the light. */
        mgVec4        color_copy; /**< Stored vector view of the light's colour. */
    };

    float power; /**< Strength of the light; zero or less switches the light off. */
    float range; /**< Distance the light reaches; zero or less derives it from the power and colour. */
};

STATIC_ASSERT(sizeof(mgPOINT_LIGHT) == 0x30);

/**
 *
 * One lighting setup: up to four directional lights, an ambient colour and four point lights.
 *
 */
struct mgLIGHT_INFO {
    sceVu0FMATRIX light_dir;      /**< Direction of each directional light, one light per column. */
    sceVu0FMATRIX light_color;    /**< Colour of each directional light, one light per row. */
    sceVu0FVECTOR ambient;        /**< Ambient light colour. */
    mgPOINT_LIGHT point_light[4]; /**< Point lights. */
};

STATIC_ASSERT(sizeof(mgLIGHT_INFO) == 0x150);

#pragma cpp_extensions on

/**
 *
 * Distance fog: the colour it fades to and the coefficients that give the fog value from depth.
 *
 */
struct mgFOG_PARAM {
    float near_dist; /**< Distance at which the fog takes its near value. */
    float far_dist;  /**< Distance at which the fog takes its far value. */

    union {
        struct {
            u_char r; /**< Red component of the fog colour. */
            u_char g; /**< Green component of the fog colour. */
            u_char b; /**< Blue component of the fog colour. */
            u_char a; /**< Alpha component of the fog colour. */
        };

        u_char color[4]; /**< RGBA channels of the fog colour. */
    };

    union {
        struct {
            float offset;     /**< Constant term of the fog value as a function of the reciprocal of depth. */
            float far_value;  /**< Fog value at the far distance. */
            float near_value; /**< Fog value at the near distance. */
            float scale;      /**< Coefficient of the reciprocal of depth in the fog value. */
        };

        float values[4]; /**< Fog coefficients viewed as one four-float array. */
    };

    sceVu0FVECTOR coef; /**< Copy of offset, far_value, near_value and scale, sent to VU1 as one quadword. */
};

#pragma cpp_extensions reset
STATIC_ASSERT(sizeof(mgFOG_PARAM) == 0x30);

/**
 *
 * GS packet that sets the depth test, depth buffer and alpha blending registers of one drawing context.
 *
 */
class mgCDrawEnv {
public:
    sceGifTag  giftag;     /**< GIF tag for the three register writes that follow, in A+D mode. */
    sceGsTest  test;       /**< Alpha and depth test settings. */
    u_long     test_addr;  /**< TEST register of the context the packet writes to. */
    sceGsZbuf  zbuf;       /**< Depth buffer settings, including the depth write mask. */
    u_long     zbuf_addr;  /**< ZBUF register of the context the packet writes to. */
    sceGsAlpha alpha;      /**< Alpha blending equation. */
    u_long     alpha_addr; /**< ALPHA register of the context the packet writes to. */

    /**
     *
     * Creates a packet for the first drawing context with the default
     * settings.
     *
     * @mangled __ct__10mgCDrawEnvFv
     * @address 0x138EE0
     * @size 0x30
     */
#ifndef MG_DRAWPRIM_MANUAL_CTOR
    mgCDrawEnv();
#endif

    /**
     *
     * Copies every register setting of another draw environment packet.
     *
     * @mangled __as__10mgCDrawEnvFR10mgCDrawEnv
     * @address 0x138F10
     * @size 0x30
     */
    mgCDrawEnv &operator=(mgCDrawEnv &source);

    /**
     *
     * Builds the packet for a drawing context (zero for the first, any other
     * value for the second) with depth testing on and ordinary blending.
     *
     * @mangled Initialize__10mgCDrawEnvFi
     * @address 0x138F40
     * @size 0xC0
     */
    void Initialize(int context);

    /**
     *
     * Sets the alpha blending equation to one of the mgAlphaMacroID modes;
     * any other value leaves it as it is.
     *
     * @mangled SetAlpha__10mgCDrawEnvFi
     * @address 0x139000
     * @size 0x80
     */
    void SetAlpha(int macro);

    /**
     *
     * Returns the mgAlphaMacroID mode that the alpha blending equation
     * holds, or MG_ALPHA_MACRO_NONE.
     *
     * @mangled GetAlphaMacroID__10mgCDrawEnvFv
     * @address 0x139080
     * @size 0x60
     */
    int GetAlphaMacroID();

    /**
     *
     * Turns depth writes on or off according to an mgZBufMode value; any
     * other value leaves them as they are.
     *
     * @mangled SetZBuf__10mgCDrawEnvFi
     * @address 0x1390E0
     * @size 0x60
     */
    void SetZBuf(int mode);
};

STATIC_ASSERT(sizeof(mgCDrawEnv) == 0x40);

/**
 *
 * Render state of the scene: the projection and view transforms, the clipping boxes,
 * the lighting setups, the draw environments, the fog and the state of the object being drawn.
 *
 */
class mgRENDER_INFO {
public:
    float         projection;       /**< Distance from the eye to the screen plane, in GS pixels. */
    sceVu0FMATRIX world_screen;     /**< Transform from world space to GS screen coordinates. */
    sceVu0FMATRIX view_screen;      /**< Transform from view space to GS screen coordinates. */
    sceVu0FMATRIX world_screen_rel; /**< Transform from world space to screen coordinates relative to the screen centre. */
    sceVu0FMATRIX aspect;           /**< Scale of the vertical axis that corrects the pixel aspect ratio. */
    sceVu0FMATRIX screen;           /**< Perspective projection to GS screen coordinates. */
    sceVu0FMATRIX world_view;       /**< Transform from world space to view space, aspect correction included. */
    u_int         unk_190[4];
    sceVu0FMATRIX view;                /**< Transform from world space to view space, as the camera gives it. */
    sceVu0FMATRIX view_clip;           /**< Perspective projection to clip space over the guard area. */
    sceVu0FMATRIX world_clip;          /**< Transform from world space to clip space over the guard area. */
    sceVu0FMATRIX clip_screen;         /**< Transform from guard-area clip space to GS screen coordinates. */
    sceVu0FMATRIX view_clip_full;      /**< Perspective projection to clip space over the whole GS coordinate range. */
    sceVu0FMATRIX clip_screen_full;    /**< Transform from full-range clip space to GS screen coordinates. */
    sceVu0FVECTOR shadow_plane_pos;    /**< Point on the plane that drop shadows fall onto. */
    sceVu0FVECTOR shadow_plane_normal; /**< Normal of the plane that drop shadows fall onto. */
    sceVu0FMATRIX shadow;              /**< Projection that flattens geometry onto the shadow plane. */
    u_int         unk_380[4];
    sceVu0FVECTOR shadow_light_dir; /**< Direction of the light that casts drop shadows. */
    sceVu0FVECTOR camera_pos;       /**< World position of the eye. */
    sceVu0FMATRIX camera_pose;      /**< Orientation and position of the camera in world space. */
    int           light_changed;    /**< Set whenever the lighting changes. */
    int           active_light;     /**< Index of the lighting setup in use. */
    mgLIGHT_INFO  light_info[8];    /**< Lighting setups. */
    sceVu0FVECTOR clip_min;         /**< Smallest GS screen coordinates, with the near distance as z. */
    sceVu0FVECTOR clip_max;         /**< Largest GS screen coordinates, with the far distance as z. */
    sceVu0FVECTOR guard_max;        /**< Largest corner of the guard area in GS coordinates, with the far distance as w. */
    sceVu0FVECTOR guard_min;        /**< Smallest corner of the guard area in GS coordinates, with the near distance as w. */
    sceVu0FVECTOR full_max;         /**< Largest corner of the GS coordinate range, with the far distance as w. */
    sceVu0FVECTOR full_min;         /**< Smallest corner of the GS coordinate range, with the near distance as w. */
    sceVu0FVECTOR screen_box_max;   /**< Largest corner of the screen relative to its centre, with the far distance as w. */
    sceVu0FVECTOR screen_box_min;   /**< Smallest corner of the screen relative to its centre, with the near distance as w. */
    sceVu0FVECTOR gs_box_max;       /**< Largest corner of the GS drawing range relative to its centre, with the far distance as w. */
    sceVu0FVECTOR gs_box_min;       /**< Smallest corner of the GS drawing range relative to its centre, with the near distance as w. */
    mgCDrawEnv    draw_env[2];      /**< Default draw environment of each drawing context. */
    int           all_scissor;      /**< Non-zero scissors every object that needs clipping, whatever its attributes. */
    int           fog_enable;       /**< Non-zero draws fog. */
    int           plight_enable;    /**< Non-zero lights objects with the point lights. */
    int           lighting_enabled; /**< Non-zero when object lighting is applied. */
    u_int         render_params[4]; /**< Values passed to sprite and shadow rendering packets. */
    int           clip;             /**< Non-zero while the visible object being drawn is not wholly inside the GS drawing range. */
    int           scissor;          /**< Non-zero while the object being drawn needs scissoring, as its attributes or all_scissor ask. */
    int           plight_hit;       /**< Non-zero while a point light reaches the object being drawn. */
    mgCFrameAttr *attr;             /**< Attributes of the object being drawn. */
    mgFOG_PARAM   fog;              /**< Fog settings. */
    sceVu0FVECTOR object_color;     /**< Colour of the object being drawn. */
    int           motion;           /**< Non-zero while the object being drawn is a motion model. */

    /**
     *
     * Puts both draw environments back to their defaults and the fog, point
     * light, clipping and motion flags to their initial states.
     *
     * @mangled Initialize__13mgRENDER_INFOFv
     * @address 0x139140
     * @size 0x60
     */
    void Initialize();

    /**
     *
     * Builds the projection, clipping boxes and screen transforms for a
     * screen of the given size, then rebuilds the view transforms; a
     * projection of zero or less, or a near or far distance below zero,
     * keeps the current one.
     *
     * @mangled SetRenderInfo__13mgRENDER_INFOFfiiffif
     * @address 0x1391A0
     * @size 0x490
     */
    void SetRenderInfo(float projection, int width, int height, float near_dist, float far_dist,
                       int zdepth, float aspect_y);

    /**
     *
     * Sets the camera's view matrix and position and rebuilds every
     * transform that depends on them.
     *
     * @mangled SetViewMatrix__13mgRENDER_INFOFPA4_fPf
     * @address 0x139630
     * @size 0xE0
     */
    void SetViewMatrix(float (*view)[4], float *camera_pos);

    /**
     *
     * Sets the light and the plane for drop shadows and builds the matrix
     * that flattens geometry onto that plane.
     *
     * @mangled SetDropShadowMatrix__13mgRENDER_INFOFPfPfPf
     * @address 0x139710
     * @size 0x80
     */
    void SetDropShadowMatrix(float *light_dir, float *plane_pos, float *plane_normal);

    /**
     *
     * Switches to another lighting setup, optionally copying the current one
     * into it, and returns the index of the setup in use before.
     *
     * @mangled ActiveLighting__13mgRENDER_INFOFii
     * @address 0x139790
     * @size 0x130
     */
    int ActiveLighting(int index, int copy);

    /**
     *
     * Returns the lighting setup in use.
     *
     * @mangled GetpLightInfo__13mgRENDER_INFOFv
     * @address 0x1398C0
     * @size 0x30
     */
    mgLIGHT_INFO *GetpLightInfo();

    /**
     *
     * Clears every light of the lighting setup in use.
     *
     * @mangled InitActiveLighting__13mgRENDER_INFOFv
     * @address 0x1398F0
     * @size 0x30
     */
    void InitActiveLighting();

    /**
     *
     * Clears every light of every lighting setup.
     *
     * @mangled InitLighting__13mgRENDER_INFOFv
     * @address 0x139920
     * @size 0x70
     */
    void InitLighting();

    /**
     *
     * Sets every directional light of the setup in use from a direction
     * matrix and a colour matrix.
     *
     * @mangled SetLight__13mgRENDER_INFOFPA4_fPA4_f
     * @address 0x139990
     * @size 0x80
     */
    void SetLight(float (*light_dir)[4], float (*light_color)[4]);

    /**
     *
     * Gives the direction matrix and the colour matrix of the directional
     * lights of the setup in use.
     *
     * @mangled GetLight__13mgRENDER_INFOFPA4_fPA4_f
     * @address 0x139A10
     * @size 0x60
     */
    void GetLight(float (*light_dir)[4], float (*light_color)[4]);

    /**
     *
     * Sets the direction and colour of one directional light of the setup
     * in use.
     *
     * @mangled SetLight__13mgRENDER_INFOFiPfPf
     * @address 0x139A70
     * @size 0xB0
     */
    void SetLight(int index, float *dir, float *color);

    /**
     *
     * Sets the ambient colour of the setup in use.
     *
     * @mangled SetAmbient__13mgRENDER_INFOFPf
     * @address 0x139B20
     * @size 0x30
     */
    void SetAmbient(float *color);

    /**
     *
     * Gives the ambient colour of the setup in use.
     *
     * @mangled GetAmbient__13mgRENDER_INFOFPf
     * @address 0x139B50
     * @size 0x30
     */
    void GetAmbient(float *color);

    /**
     *
     * Sets one point light of the setup in use from its position, colour,
     * power and range.
     *
     * @mangled SetPlight__13mgRENDER_INFOFiPfPfff
     * @address 0x139B80
     * @size 0x80
     */
    void SetPlight(int index, float *pos, float *color, float power, float range);

    /**
     *
     * Sets one point light of the setup in use, or switches it off when no
     * light is given.
     *
     * @mangled SetPlight__13mgRENDER_INFOFiP13mgPOINT_LIGHT
     * @address 0x139C00
     * @size 0x170
     */
    void SetPlight(int index, mgPOINT_LIGHT *light);

    /**
     *
     * Gives one point light of the setup in use.
     *
     * @mangled GetPlight__13mgRENDER_INFOFiP13mgPOINT_LIGHT
     * @address 0x139D70
     * @size 0xC0
     */
    void GetPlight(int index, mgPOINT_LIGHT *out);

    /**
     *
     * Turns fog on or off.
     *
     * @mangled FogEnable__13mgRENDER_INFOFi
     * @address 0x139E30
     * @size 0x10
     */
    void FogEnable(int enable);

    /**
     *
     * Returns whether fog is on.
     *
     * @mangled GetFogEnable__13mgRENDER_INFOFv
     * @address 0x139E40
     * @size 0x10
     */
    int GetFogEnable();

    /**
     *
     * Turns point lighting on or off.
     *
     * @mangled PlightEnable__13mgRENDER_INFOFi
     * @address 0x139E50
     * @size 0x10
     */
    void PlightEnable(int enable);

    /**
     *
     * Returns whether point lighting is on.
     *
     * @mangled GetPlightEnable__13mgRENDER_INFOFv
     * @address 0x139E60
     * @size 0x10
     */
    int GetPlightEnable();

    /**
     *
     * Sets the fog's distances, colour and values at those distances, and
     * works out the coefficients that give the fog value from depth.
     *
     * @mangled SetFogParam__13mgRENDER_INFOFffUcUcUcff
     * @address 0x139E70
     * @size 0x90
     */
    void SetFogParam(float near_dist, float far_dist, u_char r, u_char g, u_char b,
                     float depth_max, float depth_min);
};

STATIC_ASSERT(sizeof(mgRENDER_INFO) == 0x1020);
