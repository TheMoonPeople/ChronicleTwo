#pragma once

#include "common.h"

#include "mg_sprite.hpp"

/**
 * @file
 * Declares the special cases of the Georama edit maps and the S51 dungeon
 * floor: the fading pieces of one placed part, the lightning flashes
 * of S51, the falling fire rain and the geysers that erupt from placed geyser
 * parts.
 */

class CScene;
class mgCFrame;
class mgCMemory;
class mgCTexture;

/**
 *
 * Counts of the fire rain particles, the geyser emitters and the points each emitter owns.
 *
 */
enum {
    FIRE_POWDER_NUM = 0x100,        /**< Fire rain particles drifting around the camera. */
    GEYSER_EFFECT_NUM = 4,          /**< Geyser emitters shared, by placed part index, among all placed geyser parts. */
    GEYSER_EFFECT_POINT_NUM = 0x30, /**< Points each geyser emitter owns. */
};

/**
 *
 * One fire rain particle, falling and swaying inside a box that is repeated around the camera.
 *
 */
struct FirePowder {
    float pos[4];      /**< Position in the box, with w holding the sway phase angle. */
    float phase_speed; /**< Angle added to the sway phase each frame. */
    float sway_x;      /**< Sway amplitude along the X and Z axes. */
    float sway_z;      /**< Second sway amplitude, set but not used when drawing. */
    float fall_speed;  /**< Height added each frame, always negative. */
};

STATIC_ASSERT(sizeof(FirePowder) == 0x20);

/**
 *
 * One rising, swaying, fading billboard of a geyser eruption.
 *
 */
class CGeyserEffectPoint {
public:
    float pos[4];      /**< Position relative to the geyser, with w holding the sway phase angle. */
    float phase_speed; /**< Angle added to the sway phase each frame. */
    float sway_x;      /**< Sway amplitude along the X axis, scaled by the point's scale. */
    float sway_z;      /**< Sway amplitude along the Z axis, scaled by the point's scale. */
    float rise_speed;  /**< Height added each frame. */
    float alpha;       /**< Opacity, fading each frame; the point ends when it falls below zero. */
    float scale;       /**< Size and sway multiplier, growing each frame. */
    s32   active;      /**< Nonzero while the point is in use. */
    s32   unk_2c;

    /**
     *
     * Makes an unused point.
     *
     * @mangled __ct__18CGeyserEffectPointFv
     * @address 0x2FDAE0
     * @size 0x10
     */
    CGeyserEffectPoint();
};

STATIC_ASSERT(sizeof(CGeyserEffectPoint) == 0x30);

/**
 *
 * Geyser emitter that waits a random time, then erupts a burst of points drawn as billboards.
 *
 */
class CGeyserEffect {
public:
    s32                 wait;        /**< Frames left until the next eruption starts. */
    s32                 erupting;    /**< Nonzero while the eruption is emitting points. */
    s32                 erupt_frame; /**< Frames since the eruption was armed. */
    s32                 erupt_count; /**< Points the eruption has left to emit. */
    s32                 point_num;   /**< Number of points in point. */
    CGeyserEffectPoint *point;       /**< Points of the emitter. */
    u8                  unk_18[0x8];
    mgC3DSprite         sprite;  /**< Visual the points are built into and drawn with. */
    mgCTexture         *texture; /**< Texture the points are drawn with. */
    u8                  unk_74[0xC];

    /**
     *
     * Makes an emitter with no points, ready to arm its first eruption.
     *
     * @mangled __ct__13CGeyserEffectFv
     * @address 0x2FDAF0
     * @size 0x80
     */
    CGeyserEffect();

    /**
     *
     * Counts down to and arms eruptions, and emits points while erupting.
     *
     * @mangled Create__13CGeyserEffectFv
     * @address 0x2FD330
     * @size 0xE0
     */
    void Create();

    /**
     *
     * Advances the emitter and moves, fades and ends its active points.
     *
     * @mangled Step__13CGeyserEffectFv
     * @address 0x2FD410
     * @size 0x100
     */
    void Step();

    /**
     *
     * Returns the first unused point, or NULL when every point is in use.
     *
     * @mangled GetEmpty__13CGeyserEffectFv
     * @address 0x2FD510
     * @size 0x60
     */
    CGeyserEffectPoint *GetEmpty();

    /**
     *
     * Starts an unused point at the geyser's origin with a random sway and rise speed.
     *
     * @mangled CreatePoint__13CGeyserEffectFv
     * @address 0x2FD570
     * @size 0xE0
     */
    void CreatePoint();

    /**
     *
     * Builds the sprite's packet of billboards for the active points.
     *
     * @mangled CreatePacket__13CGeyserEffectFv
     * @address 0x2FD650
     * @size 0x280
     */
    void CreatePacket();
};

STATIC_ASSERT(sizeof(CGeyserEffect) == 0x80);

/**
 *
 * Fades two pieces of the p07_g0301 part in and out in time with its g0301_21 texture animation on edit maps 2 and 9.
 *
 * @mangled EditExceptionStep__FiP6CScene
 * @address 0x2FC4F0
 * @size 0x280
 */
void EditExceptionStep(int map_no, CScene *scene);

/**
 *
 * Clears the character chosen to react to the camera and its reaction motion step.
 *
 * @mangled InitNpcCameraReaction__Fv
 * @address 0x2FC770
 * @size 0x10
 */
void InitNpcCameraReaction();

/**
 *
 * Resets the lightning of the S51 floor so the first flash comes after a delay.
 *
 * @mangled InitS51Thunder__Fv
 * @address 0x2FC780
 * @size 0x20
 */
void InitS51Thunder();

/**
 *
 * Flashes lightning on the S51 floor at random intervals, playing thunder and relighting the map.
 *
 * @mangled S51Thunder__FP6CScene
 * @address 0x2FC7A0
 * @size 0x290
 */
void S51Thunder(CScene *scene);

/**
 *
 * Loads the fire rain texture and particles on the edit maps that have it, until its story flag is set.
 *
 * @mangled InitFirePowder__FiP6CSceneiP9mgCMemory
 * @address 0x2FCA30
 * @size 0x358
 */
void InitFirePowder(int map_no, CScene *scene, int texb, mgCMemory *memory);

/**
 *
 * Moves the fire rain particles down, wrapping them to the top of their box.
 *
 * @mangled StepFirePowder__FP6CScene
 * @address 0x2FCD90
 * @size 0xA0
 */
void StepFirePowder(CScene *scene);

/**
 *
 * Draws the fire rain box repeated in a grid around a point in front of the camera, in fog.
 *
 * @mangled DrawFirePowder__FP6CScene
 * @address 0x2FCE30
 * @size 0x500
 */
void DrawFirePowder(CScene *scene);

/**
 *
 * Loads the geyser texture and creates the geyser emitters on the edit map that has them.
 *
 * @mangled InitGeyserEffect__FiP6CSceneiP9mgCMemory
 * @address 0x2FD8D0
 * @size 0x210
 */
void InitGeyserEffect(int scene_no, CScene *scene, int texb, mgCMemory *memory);

/**
 *
 * Steps every geyser emitter.
 *
 * @mangled StepGeyserEffect__FP6CScene
 * @address 0x2FDB70
 * @size 0x60
 */
void StepGeyserEffect(CScene *scene);

/**
 *
 * Draws a geyser emitter at each placed geyser part of the edit map.
 *
 * @mangled DrawGeyserEffect__FP6CScene
 * @address 0x2FDBD0
 * @size 0x1A0
 */
void DrawGeyserEffect(CScene *scene);
