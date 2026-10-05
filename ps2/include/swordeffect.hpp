#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the after-image trail a swung weapon leaves behind: a ring of
 * point pairs recorded each step from two frames of the weapon, smoothed
 * into a curve and drawn as a fading strip.
 */

class mgCFrame;
class mgCMemory;
class mgCTexture;

/**
 *
 * Trail left behind a weapon swing, built from a ring of point pairs recorded from two frames and smoothed into a strip.
 *
 */
class CSWordAfterEffect {
public:
    mgCFrame      *frame0;      /**< Frame whose world position is recorded into the first ring each step. */
    mgCFrame      *frame1;      /**< Frame whose world position is recorded into the second ring each step. */
    sceVu0FVECTOR *point0;      /**< Ring of recorded positions of the first frame. */
    sceVu0FVECTOR *point1;      /**< Ring of recorded positions of the second frame. */
    sceVu0FVECTOR *smooth0;     /**< Smoothed curve built from the first ring. */
    sceVu0FVECTOR *smooth1;     /**< Smoothed curve built from the second ring. */
    u_char             unk_18[8];
    sceVu0IVECTOR  color0;      /**< Colour and peak alpha of the first edge; also of the second when textured. */
    sceVu0IVECTOR  color1;      /**< Colour and peak alpha of the second edge when untextured. */
    float          unk_40[4];
    float          unk_50[2];
    int            division; /**< Smoothed points made between two recorded points. */
    int            smooth_num; /**< Number of smoothed points last built. */
    int            tex_block; /**< Texture block reloaded into VRAM before drawing. */
    mgCTexture    *texture;     /**< Texture the strip is mapped with; NULL draws it untextured. */
    int            tex_u; /**< Texel u the strip's texture starts at. */
    int            tex_v; /**< Texel v of the first edge. */
    int            tex_w; /**< Texel width the texture spans along the strip. */
    int            tex_h; /**< Texel height from the first edge to the second. */
    int            point_max; /**< Size of the rings. */
    int            point_num; /**< Number of recorded points in the rings. */
    int            write_index; /**< Ring slot written next; the ring fills downward. */
    int            head_index; /**< Ring slot written last. */
    int            active; /**< Non-zero while the trail is recorded and drawn. */
    int            length; /**< Smoothed points drawn while the trail is fully opaque. */
    int            hold_time; /**< Steps left before the trail starts to fade. */
    float          alpha;       /**< Fade of the trail, from 1 down to 0. */
    float          fade_speed;  /**< Fade taken off the alpha each step once fading. */
    u_char             unk_9c[4];

    /**
     *
     * Sets both edges to a neutral colour at full alpha.
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
    void SetTexture(int block, mgCTexture *tex, int u, int v, int w, int h);

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
    void StartEffect(mgCFrame *frame_0, mgCFrame *frame_1, int length, int fade_time, int hold_time);

    /**
     *
     * Records a pair of positions into the rings.
     *
     * @mangled AddPoint__17CSWordAfterEffectFPfPf
     * @address 0x2FAE00
     * @size 0xA0
     */
    void AddPoint(float *pos0, float *pos1);

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
    void Initialize(mgCMemory *memory, int point_max, int division);

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
int CreatSmoothPassSW(float (*dst)[4], float (*src)[4], int num, int division, int start, int ring_size);
