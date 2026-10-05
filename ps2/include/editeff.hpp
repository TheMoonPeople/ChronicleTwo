#pragma once

#include "common.h"

#include <libvu0.h>

#include "map.hpp"
#include "mg_sprite.hpp"

/**
 * @file
 * Declares the effects the Georama edit mode plays when a part is placed,
 * painted or removed: the spinning stars around a newly placed part, the
 * splash of paint drops, and the hop, squash and lift animations of the
 * placed parts themselves.
 */

class CEditParts;
class CMapParts;
class mgCMemory;
class mgCTexture;

/**
 * Number of star effects that can play at once.
 */
#define EDIT_STAR_EFFECT_MAX 3

/**
 * Number of paint effects allocated by EditSetEffectBuffer.
 */
#define EDIT_PAINT_EFFECT_MAX 1

/**
 * Number of paint drops thrown by one paint effect.
 */
#define EDIT_PAINT_DROP_NUM 24

/**
 * Number of placed parts that can be animated at once.
 */
#define EDIT_PLACE_ANIME_MAX 3

/**
 *
 * Progress of an edit effect or place animation slot.
 *
 */
enum EditEffectState {
    EDIT_EFFECT_STATE_FREE = 0,    /**< Slot holds nothing and may be taken. */
    EDIT_EFFECT_STATE_PLAY = 1,    /**< Effect is playing; a paint effect waits, undrawn, for its delay to run out. */
    EDIT_EFFECT_STATE_SCATTER = 2, /**< Paint drops are flying and fading. */
    EDIT_EFFECT_STATE_END = 3,     /**< Effect has finished and waits to be cleared. */
};

/**
 *
 * Animation a placed part plays, as given by its parts data's place_anime.
 *
 */
enum EditPlaceAnimeType {
    EDIT_PLACE_ANIME_NONE = 0,   /**< No animation. */
    EDIT_PLACE_ANIME_SWAY = 1,   /**< Part hops and sways about its horizontal axes for 60 frames. */
    EDIT_PLACE_ANIME_SQUASH = 2, /**< Part hops, then squashes and stretches for 15 frames. */
    EDIT_PLACE_ANIME_REMOVE = 3, /**< Copy of a removed part rises and narrows for 10 frames. */
};

/**
 *
 * One star of a star effect, placed relative to the effect's position.
 *
 */
struct EditStarParticle {
    sceVu0FVECTOR position; /**< Offset of the star from the effect, before the effect's scale; w is 1. */
    s32 unk_10;
    s32 shape;              /**< Row of the size and texture coordinate tables the star is drawn with: 0 or 1. */
    s32 unk_18;
    s32 unk_1c;
};

STATIC_ASSERT(sizeof(EditStarParticle) == 0x20);

/**
 *
 * Ring of spinning stars that spreads out and rises from a newly placed part, then fades.
 *
 */
class CStarEffect : public CObject {
public:
    s32 state;                    /**< Progress of the effect, an EditEffectState. */
    float spin_speed;             /**< Angle added to the effect's yaw each frame. */
    float rise_speed;             /**< Height added to the effect's position each frame. */
    float alpha;                  /**< Opacity of the stars, from 1 down to 0. */
    float star_angle;             /**< Angle each star is turned to on screen. */
    float size;                   /**< Scale of each star's sprite, larger for larger parts. */
    s32 frame;                    /**< Frames the effect has played. */
    s32 particle_max;             /**< Capacity of particle. */
    s32 particle_num;             /**< Number of stars in use. */
    EditStarParticle *particle;   /**< Stars of the effect. */
    s32 unk_98;
    s32 unk_9c;
    mgC3DSprite sprite;           /**< Billboards the stars are drawn with. */
    mgCTexture *texture;          /**< Texture the stars are drawn with. */
    s32 unk_f4;
    s32 unk_f8;
    s32 unk_fc;

    /**
     *
     * Makes an idle star effect with an empty sprite.
     *
     * @mangled __ct__11CStarEffectFv
     * @address 0x301550
     * @size 0xA0
     */
    CStarEffect();

    /**
     *
     * Starts the effect, scattering its stars through an area of the given size.
     *
     * @mangled ParamInit__11CStarEffectFPfi
     * @address 0x3001B0
     * @size 0x1A0
     */
    void ParamInit(float *area, int num);

    /**
     *
     * Spreads, spins and lifts the stars, fading them out once the effect has played a while.
     *
     * @mangled Step__11CStarEffectFv
     * @address 0x300350
     * @size 0x130
     */
    void Step();

    /**
     *
     * Draws the stars as additive billboards at the effect's position.
     *
     * @mangled Draw__11CStarEffectFv
     * @address 0x300480
     * @size 0x2D0
     */
    virtual int Draw();
};

STATIC_ASSERT(sizeof(CStarEffect) == 0x100);

/**
 *
 * Splash of paint drops thrown up from a painted part, which fall and fade.
 *
 */
class CPaintEffect : public CObject {
public:
    s32 state;                                     /**< Progress of the effect, an EditEffectState. */
    s32 shape;                                     /**< Row of the texture coordinate tables the drops are drawn with: 1 for a river, else 0. */
    s32 unk_78;
    s32 unk_7c;
    sceVu0FVECTOR color;                           /**< Colour of the drops, each of red, green and blue at most 255. */
    mgCTexture *texture;                           /**< Texture the drops are drawn with. */
    s32 unk_94;
    s32 unk_98;
    s32 unk_9c;
    mgC3DSprite sprite;                            /**< Billboards the drops are drawn with. */
    float alpha;                                   /**< Opacity of the drops, from 1 down to 0. */
    s32 wait;                                      /**< Frames left before the drops start to fly. */
    s32 unk_f8;
    s32 unk_fc;
    sceVu0FVECTOR drop[EDIT_PAINT_DROP_NUM];       /**< Offset of each drop from the effect, with its size in w. */
    sceVu0FVECTOR drop_speed[EDIT_PAINT_DROP_NUM]; /**< Distance each drop moves each frame. */

    /**
     *
     * Makes an idle paint effect with an empty sprite.
     *
     * @mangled __ct__12CPaintEffectFv
     * @address 0x2FFC20
     * @size 0xA0
     */
    CPaintEffect();

    /**
     *
     * Starts the effect, giving each drop a random size up to the given scale and a random speed.
     *
     * @mangled ParamInit__12CPaintEffectFf
     * @address 0x300750
     * @size 0x100
     */
    void ParamInit(float scale);

    /**
     *
     * Counts down the delay, then moves the drops under gravity and fades them out.
     *
     * @mangled Step__12CPaintEffectFv
     * @address 0x300850
     * @size 0xE0
     */
    void Step();

    /**
     *
     * Draws the flying drops as blended billboards at the effect's position.
     *
     * @mangled Draw__12CPaintEffectFv
     * @address 0x300930
     * @size 0x270
     */
    virtual int Draw();
};

STATIC_ASSERT(sizeof(CPaintEffect) == 0x400);

/**
 *
 * Animation of one placed or removed part, applied on top of the part's own position, rotation and scale.
 *
 */
class CPlaceAnime {
public:
    s32 state;                   /**< Progress of the animation, an EditEffectState. */
    s32 type;                    /**< Animation played, an EditPlaceAnimeType. */
    CMapParts *parts;            /**< Part animated; for a removal, a copy of the removed part. */
    s32 unk_0c;
    sceVu0FVECTOR rotation;      /**< Rotation given to the part while it animates. */
    sceVu0FVECTOR scale;         /**< Scale given to the part while it animates. */
    sceVu0FVECTOR position;      /**< Position given to the part while it animates. */
    sceVu0FVECTOR base_rotation; /**< Rotation the part had before the frame's animation was applied. */
    sceVu0FVECTOR base_scale;    /**< Scale the part had before the frame's animation was applied. */
    sceVu0FVECTOR base_position; /**< Position the part had before the frame's animation was applied. */
    s32 frame;                   /**< Frames the animation has played. */
    s32 phase;                   /**< Stage of a squash animation: 0 while hopping, 1 once landed. */
    float power;                 /**< Strength of the sway or squash, decaying each frame. */
    float height;                /**< Height the part is raised above its position. */
    float height_speed;          /**< Height added each frame, falling under gravity. */
    s32 unk_84;
    s32 unk_88;
    s32 unk_8c;

    /**
     *
     * Applies the frame's hop, sway, squash or lift to the part, freeing the slot when the animation ends.
     *
     * @mangled Step__11CPlaceAnimeFv
     * @address 0x300FA0
     * @size 0x400
     */
    void Step();

    /**
     *
     * Puts the part back to the position, rotation and scale it had before Step.
     *
     * @mangled Step2__11CPlaceAnimeFv
     * @address 0x3013A0
     * @size 0xA0
     */
    void Step2();

    /**
     *
     * Draws the copy of a removed part while its removal animation plays.
     *
     * @mangled Draw__11CPlaceAnimeFv
     * @address 0x301440
     * @size 0x70
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CPlaceAnime) == 0x90);

/**
 *
 * Animations of the parts being placed or removed.
 *
 */
extern CPlaceAnime PlaceAnime[EDIT_PLACE_ANIME_MAX];

/**
 *
 * Allocates the stars, the paint effect and the buffer that copies of removed parts are made in.
 *
 * @mangled EditSetEffectBuffer__FP9mgCMemory
 * @address 0x2FFAE0
 * @size 0x140
 */
void EditSetEffectBuffer(mgCMemory *memory);

/**
 *
 * Stops every star and paint effect.
 *
 * @mangled EditInitPlaceEffect__Fv
 * @address 0x2FFCC0
 * @size 0x40
 */
void EditInitPlaceEffect();

/**
 *
 * Starts a star effect at a placed part, sized to the part, taking the oldest one when none is free.
 * Returns whether one was started.
 *
 * @mangled EditPlaceEffect__FP10CEditPartsPf
 * @address 0x2FFD00
 * @size 0x1B0
 */
int EditPlaceEffect(CEditParts *parts, float *position);

/**
 *
 * Starts the paint effect at a position in a colour, larger and at once for a river.
 * Returns whether it was started.
 *
 * @mangled EditPaintEffect__FP10CEditPartsPfPfi
 * @address 0x2FFEB0
 * @size 0x160
 */
int EditPaintEffect(CEditParts *parts, float *position, float *color, int river);

/**
 *
 * Steps every star and paint effect.
 *
 * @mangled EditPEffectStep__Fv
 * @address 0x300010
 * @size 0x80
 */
void EditPEffectStep();

/**
 *
 * Draws every star and paint effect.
 *
 * @mangled EditPEffectDraw__Fi
 * @address 0x300090
 * @size 0x80
 */
void EditPEffectDraw(int unused);

/**
 *
 * Returns EDIT_EFFECT_STATE_PLAY while a star effect plays, else EDIT_EFFECT_STATE_END if one has ended, else EDIT_EFFECT_STATE_FREE.
 *
 * @mangled EditGetPEffectState__Fv
 * @address 0x300110
 * @size 0x50
 */
int EditGetPEffectState();

/**
 *
 * Stops the effects once the star effects have ended, returning EDIT_EFFECT_STATE_END then, else whether one plays.
 *
 * @mangled EditPEffectEndCheck__Fv
 * @address 0x300160
 * @size 0x50
 */
int EditPEffectEndCheck();

/**
 *
 * Frees every place animation slot.
 *
 * @mangled EditInitPlaceAnime__Fv
 * @address 0x300BA0
 * @size 0x50
 */
void EditInitPlaceAnime();

/**
 *
 * Returns whether any place animation is playing.
 *
 * @mangled EditNowPlaceAnime__Fv
 * @address 0x300BF0
 * @size 0x50
 */
int EditNowPlaceAnime();

/**
 *
 * Starts an animation on a part, copying the part first for a removal.
 * Returns whether one was started.
 *
 * @mangled EditSetPlaceAnime__FiP9CMapParts
 * @address 0x300C40
 * @size 0x270
 */
int EditSetPlaceAnime(int type, CMapParts *parts);

/**
 *
 * Applies the frame's animation to every animated part.
 *
 * @mangled EditPlaceAnime__Fv
 * @address 0x300EB0
 * @size 0x50
 */
void EditPlaceAnime();

/**
 *
 * Puts every animated part back to its own position, rotation and scale.
 *
 * @mangled EditPlaceAnime2__Fv
 * @address 0x300F00
 * @size 0x50
 */
void EditPlaceAnime2();

/**
 *
 * Draws the copies of the parts being removed.
 *
 * @mangled EditPlaceAnimeDraw__Fv
 * @address 0x300F50
 * @size 0x50
 */
void EditPlaceAnimeDraw();

/**
 *
 * Returns EDIT_EFFECT_STATE_PLAY while a place animation plays, else EDIT_EFFECT_STATE_END if one has ended, else EDIT_EFFECT_STATE_FREE.
 *
 * @mangled EditGetPlaceAnimeState__Fv
 * @address 0x3014B0
 * @size 0x50
 */
int EditGetPlaceAnimeState();

/**
 *
 * Frees the place animations once they have ended, returning EDIT_EFFECT_STATE_END then, else whether one plays.
 *
 * @mangled EditPlaceAnimeEndCheck__Fv
 * @address 0x301500
 * @size 0x50
 */
int EditPlaceAnimeEndCheck();
