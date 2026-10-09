#pragma once

#include "common.h"

#include "dng_main.hpp"

/**
 * @file
 * Declares the player control of the town-building (Georama) edit mode: walking the character
 * against collision, the follow, eye-view and photo cameras, ladder climbing, and the per-frame
 * stepping and drawing of the characters on the edit map.
 */

class CPadControl;
class CScene;
struct CCPoly;

/**
 *
 * How the edit-mode camera is being used, as the unit's view mode holds it.
 *
 */
// clang-format off
enum EditViewMode {
    EDIT_VIEW_MODE_WALK  = 0, /**< The camera follows the walking character. */
    EDIT_VIEW_MODE_EYE   = 1, /**< First-person view from the character's eyes. */
    EDIT_VIEW_MODE_PHOTO = 2, /**< First-person view with the photo camera raised. */
};

// clang-format on

/**
 *
 * Which end of a ladder the character got on at, as the unit's ladder mode holds it.
 *
 */
// clang-format off
enum EditLadderMode {
    EDIT_LADDER_MODE_NONE   = 0, /**< The character is not on a ladder. */
    EDIT_LADDER_MODE_BOTTOM = 1, /**< The character got on at the bottom and climbs up. */
    EDIT_LADDER_MODE_TOP    = 2, /**< The character got on at the top and climbs down. */
};

// clang-format on

/**
 *
 * Special motion the walking character is held in, as the unit's character motion mode holds it.
 *
 */
// clang-format off
enum EditCharaMotionMode {
    EDIT_CHARA_MOTION_FREE    = 0, /**< The character moves as the pad steers it. */
    EDIT_CHARA_MOTION_LANDING = 1, /**< The character recovers from a hard landing and cannot move. */
};

// clang-format on

/**
 *
 * Effect script selected by the material beneath the player's feet.
 *
 */
enum EditFootEffect {
    EDIT_FOOT_EFFECT_NONE = 0,  /**< No footstep effect. */
    EDIT_FOOT_EFFECT_SAND = 1,  /**< Sand kicked up by a footstep. */
    EDIT_FOOT_EFFECT_WATER = 2, /**< Water splashed by a footstep. */
    EDIT_FOOT_EFFECT_GRASS = 3, /**< Grass disturbed by a footstep. */
};

/**
 *
 * Extra collision polygons handed to EditMoveChara, and what the move ran into.
 *
 */
struct EditMoveCharaInfo {
    int           poly_num; /**< Number of extra collision polygons in polys. */
    CCPoly       *polys;    /**< Extra collision polygons to move against, or null for none. */
    u8            unk_8[8];
    MoveCheckInfo move_info;    /**< What the move ran into. */
    int           hard_landing; /**< Whether the character landed while falling faster than the hard-landing speed. */
    u8            unk_124[0xC];
};

STATIC_ASSERT(sizeof(EditMoveCharaInfo) == 0x130);

/**
 *
 * Gives back whether the character stands on the ground: not falling, not landing and not on a ladder.
 *
 * @mangled EditOnGround__Fv
 * @address 0x1A5500
 * @size 0x40
 */
int EditOnGround();

/**
 *
 * Gives back whether the camera is following the walking character rather than looking through its eyes.
 *
 * @mangled IsWalkMode__Fv
 * @address 0x1A5540
 * @size 0x10
 */
int IsWalkMode();

/**
 *
 * Resets the edit-mode player control, its view mode and its camera when the edit map is entered.
 *
 * @mangled EditControlInit__FP6CScene
 * @address 0x1A5550
 * @size 0xC0
 */
void EditControlInit(CScene *scene);

/**
 *
 * Takes the character off any ladder or landing and puts it back into its standing motion.
 *
 * @mangled EditControlStatusInit__FP6CScene
 * @address 0x1A5610
 * @size 0x80
 */
void EditControlStatusInit(CScene *scene);

/**
 *
 * Runs one frame of player control: walking and the camera, or climbing a ladder.
 *
 * @mangled EditControl__FP6CSceneP11CPadControl
 * @address 0x1A5690
 * @size 0x70
 */
int EditControl(CScene *scene, CPadControl *pad);

/**
 *
 * Gives back the name of the effect script that a step on a kind of ground raises, or null for none.
 *
 * @mangled GetFootEffName__Fi
 * @address 0x1A5700
 * @size 0x50
 */
char *GetFootEffName(int index);

/**
 *
 * Moves the player character by a velocity against the map, the other characters and any extra polygons.
 *
 * @mangled EditMoveChara__FP6CScenePfP17EditMoveCharaInfo
 * @address 0x1A5750
 * @size 0xB10
 */
void EditMoveChara(CScene *scene, float *velocity, EditMoveCharaInfo *info);

/**
 *
 * Steers the follow camera behind the player character, optionally looking at a given point.
 *
 * @mangled EditCameraControl__FP6CSceneP11CPadControlPA4_f
 * @address 0x1A6260
 * @size 0x930
 */
void EditCameraControl(CScene *scene, CPadControl *pad, float (*look_at)[4]);

/**
 *
 * Stops the next press of the eye-view button from leaving the walking camera.
 *
 * @mangled CancelEyeViewMode__Fv
 * @address 0x1A7390
 * @size 0x10
 */
void CancelEyeViewMode();

/**
 *
 * Returns the camera to following the walking character and puts away the photo camera.
 *
 * @mangled ResetViewMode__FP6CScene
 * @address 0x1A7740
 * @size 0x90
 */
void ResetViewMode(CScene *scene);

/**
 *
 * Steps the player character, the edit map's other characters and the four fixed extra characters.
 *
 * @mangled EditStepChara__FP6CScene
 * @address 0x1A8AA0
 * @size 0x90
 */
void EditStepChara(CScene *scene);

/**
 *
 * Draws the shadows of the player character and of the edit map's other characters.
 *
 * @mangled EditDrawShadowChara__FP6CScene
 * @address 0x1A8B30
 * @size 0x60
 */
void EditDrawShadowChara(CScene *scene);

/**
 *
 * Draws the player character and every other edit-map character that is not an effect character.
 *
 * @mangled EditDrawChara__FP6CScene
 * @address 0x1A8B90
 * @size 0x80
 */
void EditDrawChara(CScene *scene);

/**
 *
 * Draws the edit map's effect characters, in the pass after the other characters.
 *
 * @mangled EditDrawEffectChara__FP6CScene
 * @address 0x1A8C10
 * @size 0x70
 */
void EditDrawEffectChara(CScene *scene);
