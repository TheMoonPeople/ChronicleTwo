#pragma once

#include "common.h"

#include <libvu0.h>

#include <span>

#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"

/**
 * @file
 * Declares the after-image trail a swung weapon leaves behind: a ring of
 * point pairs recorded each step from two frames of the weapon, smoothed
 * into a curve and drawn as a fading strip.
 */

/**
 *
 * Four floating point values used by the weapon trail.
 *
 */
struct SWordFloat4 {
    float values[4]; /**< Four floating point components. */
};

/**
 *
 * Pair of floating point values used by the weapon trail.
 *
 */
struct SWordFloat2 {
    float values[2]; /**< Two floating point components. */
};

/**
 *
 * Records and draws the fading trail left by a weapon swing.
 *
 */
class CSWordAfterEffect {
public:
    mgCFrame      *frame0 = nullptr;  /**< Frame whose world position is recorded into the first ring each step. */
    mgCFrame      *frame1 = nullptr;  /**< Frame whose world position is recorded into the second ring each step. */
    sceVu0FVECTOR *point0 = nullptr;  /**< Ring of recorded positions of the first frame. */
    sceVu0FVECTOR *point1 = nullptr;  /**< Ring of recorded positions of the second frame. */
    sceVu0FVECTOR *smooth0 = nullptr; /**< Smoothed curve built from the first ring. */
    sceVu0FVECTOR *smooth1 = nullptr; /**< Smoothed curve built from the second ring. */
    u_char         unk_18[8]{};
    sceVu0IVECTOR  color0{}; /**< Colour and peak alpha of the first edge; also of the second when textured. */
    sceVu0IVECTOR  color1{}; /**< Colour and peak alpha of the second edge when untextured. */
    SWordFloat4    unk_40{};
    SWordFloat2    unk_50{};
    int            division{};        /**< Smoothed points made between two recorded points. */
    int            smooth_num{};      /**< Number of smoothed points last built. */
    int            tex_block = -1;    /**< Texture block reloaded into VRAM before drawing. */
    mgCTexture    *texture = nullptr; /**< Texture the strip is mapped with; NULL draws it untextured. */
    int            tex_u{};           /**< Texel u the strip's texture starts at. */
    int            tex_v{};           /**< Texel v of the first edge. */
    int            tex_w{};           /**< Texel width the texture spans along the strip. */
    int            tex_h{};           /**< Texel height from the first edge to the second. */
    int            point_max{};       /**< Size of the rings. */
    int            point_num{};       /**< Number of recorded points in the rings. */
    int            write_index = -1;  /**< Ring slot written next; the ring fills downward. */
    int            head_index = -1;   /**< Ring slot written last. */
    int            active{};          /**< Non-zero while the trail is recorded and drawn. */
    int            length{};          /**< Smoothed points drawn while the trail is fully opaque. */
    int            hold_time{};       /**< Steps left before the trail starts to fade. */
    float          alpha{};           /**< Fade of the trail, from 1 down to 0. */
    float          fade_speed{};      /**< Fade taken off the alpha each step once fading. */
    u_char         unk_9c[4]{};

    /**
     *
     * Creates an inactive trail with no point storage and neutral edge colours.
     *
     */
    CSWordAfterEffect() {
        color0[0] = 0x80;
        color0[1] = 0x80;
        color0[2] = 0x80;
        color0[3] = 0x80;
        color1[0] = 0x80;
        color1[1] = 0x80;
        color1[2] = 0x80;
        color1[3] = 0x80;
    }

    /**
     *
     * Draws the smoothed strip with its alpha falling off along its length.
     *
     * @mangled Draw__17CSWordAfterEffectFv
     * @address 0x2FA8C0
     * @size 0x3C0
     */
    void Draw();

    /**
     *
     * Rebuilds both smoothed curves from the rings.
     *
     * @mangled CreatPointList__17CSWordAfterEffectFv
     * @address 0x2FAC80
     * @size 0xB0
     */
    void CreatPointList();

    /**
     *
     * Maps the strip with a texture and its texel rectangle and sets both edges to a neutral colour.
     *
     * @mangled SetTexture__17CSWordAfterEffectFiP10mgCTextureiiii
     * @address 0x2FAD30
     * @size 0x40
     */
    void SetTexture(int tex_no, mgCTexture *tex, int u, int v, int u1, int v1);

    /**
     *
     * Changes the texel rectangle the strip's texture is mapped from.
     *
     * @mangled SetTexture__17CSWordAfterEffectFiiii
     * @address 0x2FAD70
     * @size 0x20
     */
    void SetTexture(int u, int v, int w, int h);

    /**
     *
     * Starts a trail between two frames, emptying the rings and setting its length and fade timing.
     *
     * @mangled StartEffect__17CSWordAfterEffectFP8mgCFrameP8mgCFrameiii
     * @address 0x2FAD90
     * @size 0x70
     */
    void StartEffect(mgCFrame *start, mgCFrame *end, int length, int frames, int hold_time);

    /**
     *
     * Records a pair of positions into the rings.
     *
     * @mangled AddPoint__17CSWordAfterEffectFPfPf
     * @address 0x2FAE00
     * @size 0xA0
     */
    void AddPoint(float *first, float *second);

    /**
     *
     * Records the frames' current positions and advances the hold and fade.
     *
     * @mangled Step__17CSWordAfterEffectFv
     * @address 0x2FAEA0
     * @size 0xB0
     */
    void Step();

    /**
     *
     * Stops the trail and detaches it from its frames.
     *
     * @mangled Clear__17CSWordAfterEffectFv
     * @address 0x2FAF50
     * @size 0x10
     */
    void Clear();

    /**
     *
     * Allocates the rings and smoothed curves and resets the trail to its default colours.
     *
     * @mangled Initialize__17CSWordAfterEffectFP9mgCMemoryii
     * @address 0x2FAF60
     * @size 0x140
     */
    void Initialize(mgCMemory *memory, int capacity, int subdivisions);

    /**
     *
     * Copies this trail into another, giving the copy its own buffers when a memory is supplied.
     *
     * @mangled Copy__17CSWordAfterEffectFR17CSWordAfterEffectP9mgCMemory
     * @address 0x2FB0A0
     * @size 0x1C0
     */
    void Copy(CSWordAfterEffect &dst, mgCMemory *memory);
};

STATIC_ASSERT(sizeof(CSWordAfterEffect) == 0xA0);

/**
 *
 * Builds a Catmull-Rom curve through a ring of points and gives the number of points written.
 *
 * @mangled CreatSmoothPassSW__FPA4_fPA4_fiiii
 * @address 0x2FA530
 * @size 0x390
 */
int CreatSmoothPassSW(std::span<sceVu0FVECTOR> dst, std::span<const sceVu0FVECTOR> src, int num, int division, int start);
