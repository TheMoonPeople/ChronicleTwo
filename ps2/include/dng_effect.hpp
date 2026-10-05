#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_frame.hpp"
#include "mg_tanime.hpp"
#include "prespr.hpp"

/**
 * @file
 * Declares the dungeon's battle and field effects: the shards, flames, whirlwinds and sparks that follow an
 * elemental hit, the sparks thrown off a charged weapon, the pooled hit, flash, power-up and death effects of
 * the battle effect manager, the healing point's lights, the drifting light balls of some floors, the trails
 * of the pull-item wire and of a sword swing, and the palette flashes of characters.
 */

class mgCCamera;
class mgCMemory;
class CCharacter2;

/** Number of shards that one chill after-hit effect throws. */
#define CHILL_AFTER_HIT_PIECE_MAX 24

/** Number of flames that one fire after-hit effect throws. */
#define FIRE_AFTER_HIT_FLAME_MAX 14

/** Number of trail puffs that each fire after-hit flame leaves. */
#define FIRE_AFTER_HIT_TRAIL_MAX 6

/** Number of rings that one whirlwind effect raises. */
#define TORNADO_PIECE_MAX 18

/** Number of sparks that one thunder effect scatters. */
#define THUNDER_SPARK_MAX 48

/** Number of small sprites that the mini effect manager keeps. */
#define MINI_EFF_PRIM_MAX 64

/** Number of orbiting lights drawn around a healing point. */
#define HEALING_LIGHT_MAX 16

/** Number of positions that a pull-item wire remembers. */
#define AFTER_WIRE_POINT_MAX 16

/** Number of sparks that one charged weapon can throw off. */
#define WEAPON_ELEMENT_SPARK_MAX 32

/** Number of bolts that the thunder element can arc between its sparks. */
#define WEAPON_ELEMENT_BOLT_MAX 16

/**
 *
 * Names the element that a weapon is charged with, which picks the way its sparks move and are drawn.
 *
 */
enum WEAPON_ELEMENT_KIND {
    WEAPON_ELEMENT_FIRE = 0,    /**< Sparks that drift upward and flicker. */
    WEAPON_ELEMENT_COLD = 1,    /**< Sparks that fall away from the blade; also used for any unlisted kind. */
    WEAPON_ELEMENT_THUNDER = 2, /**< Sparks that fly apart, with bolts arcing between them. */
    WEAPON_ELEMENT_WIND = 3,    /**< Sparks that blow away on a rising wind, spinning. */
};

/**
 *
 * Pools that BattleEffectMan::AllocEffect can fill.
 *
 */
enum BATTLE_EFFECT_KIND {
    BATTLE_EFFECT_HIT = 0,        /**< CHitEffectImage pool. */
    BATTLE_EFFECT_FLUSH = 1,      /**< CFlushEffect pool. */
    BATTLE_EFFECT_POWER_LINE = 2, /**< CPowerLine pool. */
    BATTLE_EFFECT_DEAD = 3,       /**< CDeadEffect pool. */
    BATTLE_EFFECT_CHARA = 4,      /**< Pool of characters with their slot records. */
};

/**
 *
 * Ways in which a hit effect draws its sparks.
 *
 */
enum HIT_EFFECT_KIND {
    HIT_EFFECT_BOARD = 0,       /**< Each spark is a textured quad. */
    HIT_EFFECT_SPARK_SHORT = 1, /**< Each spark is a short streak along its direction. */
    HIT_EFFECT_SPARK_LONG = 2,  /**< Each spark is a long streak along its direction. */
};

/**
 *
 * States of the healing point's lights.
 *
 */
enum HEALING_EFFECT_MODE {
    HEALING_EFFECT_IDLE = 0,     /**< The lights glow steadily. */
    HEALING_EFFECT_SPENT = 1,    /**< The healing point has been used: the lights flare and fade out. */
    HEALING_EFFECT_RECHARGE = 2, /**< The healing point is ready again: the lights fade back in. */
    HEALING_EFFECT_OFF = 3,      /**< The lights are not drawn. */
};

/**
 *
 * States of the sword glow.
 *
 */
enum SWORD_LUMINOUS_MODE {
    SWORD_LUMINOUS_OFF = 0,      /**< Nothing is drawn. */
    SWORD_LUMINOUS_FADE_IN = 1,  /**< The glow brightens. */
    SWORD_LUMINOUS_ON = 2,       /**< The glow holds. */
    SWORD_LUMINOUS_FADE_OUT = 3, /**< The glow dims, then turns off. */
};

/**
 *
 * States of a mini effect sprite.
 *
 */
enum MINI_EFF_PRIM_STATE {
    MINI_EFF_PRIM_FREE = 0,   /**< The slot holds no sprite. */
    MINI_EFF_PRIM_RISING = 2, /**< The sprite rises and fades out. */
};

/**
 *
 * States of a thrown-sparkle model effect.
 *
 */
enum SPARC_EFFECT_STATE {
    SPARC_EFFECT_OFF = 0,      /**< Nothing is drawn. */
    SPARC_EFFECT_FADE_IN = 1,  /**< The models brighten up to their peak. */
    SPARC_EFFECT_FADE_OUT = 2, /**< The models dim, then turn off. */
};

/**
 *
 * Floors whose light balls a CMapEffectsManeger runs.
 *
 */
enum MAP_EFFECT_TYPE {
    MAP_EFFECT_NONE = -1, /**< The floor has no light balls. */
    MAP_EFFECT_D01 = 0,   /**< Large faint balls of floor "d01f01". */
    MAP_EFFECT_D02 = 1,   /**< Small bright balls of floor "d02f01". */
    MAP_EFFECT_D03 = 2,   /**< Large brighter balls, spawned lower, of floors "d03f01" to "d03f03". */
};

/**
 *
 * One particle of the battle effect manager's pooled effects, kept in a block allocated beside each effect.
 *
 */
struct BattleEffectPrim {
    s32           kind;      /**< Look of a death-effect fleck: 0 a cloud puff, 1 a shrinking glitter. */
    sceVu0FVECTOR pos;       /**< Position, absolute for hit sparks and relative to the effect for the others. */
    sceVu0FVECTOR velocity;  /**< Direction of a hit spark, or distance a death-effect fleck moves per step. */
    float         size;      /**< Drawn size of a death-effect fleck. */
    float         speed;     /**< Distance a hit spark moves along its direction, or a power-line streak rises, per step. */
    float         rate;      /**< Speed a hit spark loses per step, or the peak alpha of a death-effect fleck. */
    s32           life;      /**< Steps left; the particle is free at zero. */
    s32           life_max;  /**< Steps the death-effect fleck started with. */
    float         alpha;     /**< Blend of a hit spark, from one down to nothing. */
    float         alpha_step; /**< Blend a hit spark loses per step. */
};

STATIC_ASSERT(sizeof(BattleEffectPrim) == 0x50);

/**
 *
 * Slot record that the battle effect manager keeps for each pooled character.
 *
 */
struct BattleEffectChara {
    s32          unk_0;
    s32          unk_4;
    s32          unk_8;
    u8           unk_c[0xC];
    CCharacter2 *chara; /**< Character the slot holds. */
};

STATIC_ASSERT(sizeof(BattleEffectChara) == 0x1C);

/**
 *
 * One ice shard thrown by a chill after-hit effect.
 *
 */
struct CHILL_AFTER_HIT_PIECE {
    sceVu0FVECTOR pos;        /**< Position of the shard. */
    sceVu0FVECTOR velocity;   /**< Distance moved per step while the shard still flies. */
    float         size;       /**< Drawn size of the shard. */
    float         damping;    /**< Factor the velocity is scaled by each step. */
    float         angle;      /**< Screen angle the shard is drawn turned by. */
    float         spin;       /**< Angle added each step while the shard flies; shrinks each step. */
    s8            rect;       /**< Texture rectangle the shard is drawn with. */
    s8            move_time;  /**< Steps left for which the shard still flies; once spent it falls and fades. */
    s8            trail_num;  /**< Number of earlier positions drawn behind the shard. */
    s8            fade_speed; /**< Alpha the shard loses per step once it stops flying. */
    s16           alpha;      /**< Blend of the shard; the shard is gone at zero. */
    float         trail[2][3]; /**< The shard's last two positions, newest first. */
};

STATIC_ASSERT(sizeof(CHILL_AFTER_HIT_PIECE) == 0x50);

/**
 *
 * Throws a burst of ice shards from the point where a cold-element hit landed.
 *
 */
class CChillAfterHit {
public:
    s32                   active;    /**< Non-zero while any shard is still drawn. */
    s32                   piece_num; /**< Number of shards the burst throws. */
    float                 rate;      /**< Strength of the hit, from nothing to one, which sets the count and size. */
    sceVu0FVECTOR         center;    /**< Point the hit landed at. */
    CHILL_AFTER_HIT_PIECE piece[CHILL_AFTER_HIT_PIECE_MAX]; /**< The shards. */

    /**
     *
     * Clears the effect.
     *
     * @mangled __ct__14CChillAfterHitFv
     * @address 0x1D5CB0
     * @size 0x30
     */
    CChillAfterHit() { Initialize(); }

    /**
     *
     * Turns the effect off and clears every shard.
     *
     * @mangled Initialize__14CChillAfterHitFv
     * @address 0x1BFAD0
     * @size 0x50
     */
    void Initialize();

    /**
     *
     * Starts a burst at a point, sized by the given size and the hit's strength; weak hits start nothing.
     *
     * @mangled SetPos__14CChillAfterHitFPffi
     * @address 0x1BFB20
     * @size 0x370
     */
    void SetPos(float *pos, float size, int strength);

    /**
     *
     * Moves every shard one step and turns the effect off once all have faded.
     *
     * @mangled Step__14CChillAfterHitFv
     * @address 0x1BFE90
     * @size 0x1C0
     */
    void Step();

    /**
     *
     * Draws every shard with its trail and glow.
     *
     * @mangled Draw__14CChillAfterHitFv
     * @address 0x1C0500
     * @size 0x3D0
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CChillAfterHit) == 0x7A0);

/**
 *
 * One flame thrown by a fire after-hit effect.
 *
 */
struct FIRE_AFTER_HIT_FLAME {
    sceVu0FVECTOR pos;         /**< Position of the flame. */
    float         velocity[3]; /**< Distance moved per step. */
    float         size;        /**< Drawn size of the flame. */
    s16           alpha;       /**< Blend of the flame; it stops being drawn at zero. */
    s16           age;         /**< Steps the flame has moved. */
    s16           fade_speed;  /**< Alpha the flame loses per step. */
    s8            trail_head;  /**< Trail puff that is written next. */
    s8            delay;       /**< Steps left before the flame starts moving. */
};

STATIC_ASSERT(sizeof(FIRE_AFTER_HIT_FLAME) == 0x30);

/**
 *
 * One puff of smoke left behind a fire after-hit flame.
 *
 */
struct FIRE_AFTER_HIT_TRAIL {
    float pos[3]; /**< Position of the puff. */
    float size;   /**< Drawn size of the puff; grows each step. */
    s16   alpha;  /**< Blend of the puff; it is not drawn at zero. */
};

STATIC_ASSERT(sizeof(FIRE_AFTER_HIT_TRAIL) == 0x14);

/**
 *
 * Throws a burst of flames, each leaving a smoke trail, from the point where a fire-element hit landed.
 *
 */
class CFireAfterHit {
public:
    s32                  active;    /**< Non-zero while any flame or puff is still drawn. */
    s32                  flame_num; /**< Number of flames the burst throws. */
    s32                  time;      /**< Steps since the burst started. */
    float                rate;      /**< Strength of the hit, from nothing to one, which sets the count and size. */
    FIRE_AFTER_HIT_FLAME flame[FIRE_AFTER_HIT_FLAME_MAX]; /**< The flames. */
    FIRE_AFTER_HIT_TRAIL trail[FIRE_AFTER_HIT_FLAME_MAX][FIRE_AFTER_HIT_TRAIL_MAX]; /**< Smoke puffs of each flame. */

    /**
     *
     * Clears the effect.
     *
     * @mangled __ct__13CFireAfterHitFv
     * @address 0x1D5C80
     * @size 0x30
     */
    CFireAfterHit() { Initialize(); }

    /**
     *
     * Turns the effect off and clears every flame and puff.
     *
     * @mangled Initialize__13CFireAfterHitFv
     * @address 0x1C08D0
     * @size 0x50
     */
    void Initialize();

    /**
     *
     * Starts a burst at a point, sized by the given size and the hit's strength; weak hits start nothing.
     *
     * @mangled SetPos__13CFireAfterHitFPffi
     * @address 0x1C0920
     * @size 0x250
     */
    void SetPos(float *pos, float size, int strength);

    /**
     *
     * Moves every flame one step, laying smoke puffs behind it, and turns the effect off once all have faded.
     *
     * @mangled Step__13CFireAfterHitFv
     * @address 0x1C0B70
     * @size 0x2C0
     */
    void Step();

    /**
     *
     * Draws the smoke puffs, then every flame with its glow.
     *
     * @mangled Draw__13CFireAfterHitFv
     * @address 0x1C0E30
     * @size 0x4A0
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CFireAfterHit) == 0x940);

/**
 *
 * One ring of a whirlwind effect.
 *
 */
struct TORNADO_PIECE {
    sceVu0FVECTOR pos;   /**< Position of the ring. */
    float         scale; /**< Width of the ring; grows as it fades. */
    float         angle; /**< Turn of the ring about the vertical. */
    float         alpha; /**< Blend of the ring, from one down to nothing. */
    float         rise;  /**< Height the ring rises per step. */
    s8            life;  /**< Steps left; the ring is gone at zero. */
};

STATIC_ASSERT(sizeof(TORNADO_PIECE) == 0x30);

/**
 *
 * Raises a whirlwind of turning rings at the point where a wind-element hit landed.
 *
 */
class CTornado {
public:
    mgCFrame     *model;    /**< Ring model, drawn once per ring. */
    s32           live_num; /**< Number of rings still turning. */
    s32           active;   /**< Non-zero while any ring is still drawn. */
    float         rate;     /**< Strength of the hit, from nothing to one, which sets the count and the ring height. */
    sceVu0FVECTOR center;   /**< Point the hit landed at. */
    TORNADO_PIECE piece[TORNADO_PIECE_MAX]; /**< The rings. */

    /**
     *
     * Places a whirlwind at a point, sized by the given size and the hit's strength; weak hits start nothing.
     *
     * @mangled SetPos__8CTornadoFPfff
     * @address 0x1C12D0
     * @size 0x1F0
     */
    void SetPos(float *pos, float size, float strength);

    /**
     *
     * Draws every live ring with the ring model.
     *
     * @mangled Draw__8CTornadoFv
     * @address 0x1C14C0
     * @size 0x140
     */
    void Draw();

    /**
     *
     * Raises and turns every ring one step and turns the effect off once all have died.
     *
     * @mangled Step__8CTornadoFv
     * @address 0x1C1600
     * @size 0x140
     */
    void Step();

    /**
     *
     * Turns the effect off and frees every ring.
     *
     * @mangled Initialize__8CTornadoFv
     * @address 0x1C1740
     * @size 0x80
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CTornado) == 0x380);

/**
 *
 * One spark scattered by a thunder effect.
 *
 */
struct THUNDER_SPARK {
    sceVu0FVECTOR pos;      /**< Position relative to the effect's frame. */
    sceVu0FVECTOR velocity; /**< Distance moved per step. */
    float         angle;    /**< Screen angle the spark is drawn turned by. */
    float         spin;     /**< Angle added each step. */
    float         life;     /**< Steps left; the spark is gone at zero. */
    float         scale;    /**< Size factor, which shrinks over the last steps. */
    s8            frame;    /**< Row of thn_tbl and thn_uv the spark is drawn with, picked anew each step. */
};

STATIC_ASSERT(sizeof(THUNDER_SPARK) == 0x40);

/**
 *
 * Scatters crackling sparks around the point where a thunder-element hit landed.
 *
 */
class CThunder {
public:
    mgCFrame      frame;    /**< Frame that places the sparks and draws them as one sprite visual. */
    mgCFrameAttr  attr;     /**< Drawing attributes of the frame. */
    u8            unk_1a0[0x10];
    THUNDER_SPARK spark[THUNDER_SPARK_MAX]; /**< The sparks. */
    s8            active;   /**< Non-zero while any spark is still drawn. */
    s8            live_num; /**< Number of sparks still alive. */
    float         rate;     /**< Strength of the hit, from nothing to one, which sets the count and size. */

    /**
     *
     * Places the sparks around a point, sized by the given size and the hit's strength; weak hits start nothing.
     *
     * @mangled SetPos__8CThunderFPfff
     * @address 0x1C17C0
     * @size 0x200
     */
    void SetPos(float *pos, float size, float strength);

    /**
     *
     * Builds a sprite packet of every live spark and draws it at the frame.
     *
     * @mangled Draw__8CThunderFv
     * @address 0x1C19C0
     * @size 0x360
     */
    void Draw();

    /**
     *
     * Moves every spark one step and turns the effect off once all have died.
     *
     * @mangled Step__8CThunderFv
     * @address 0x1C1D20
     * @size 0x150
     */
    void Step();

    /**
     *
     * Turns the effect off and attaches the attributes to the frame.
     *
     * @mangled Initialize__8CThunderFv
     * @address 0x1C1E70
     * @size 0x20
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CThunder) == 0xDC0);

/**
 *
 * Fades a set of sparkle models in and out, tinted by element.
 *
 */
class CSparcEffect {
public:
    mgCFrame     *model[3]; /**< The sparkle models, two of which are drawn by pattern. */
    sceVu0FVECTOR pos;      /**< Point the models are drawn at. */
    u8            unk_20[0x80];
    float         alpha_max; /**< Blend the models fade in to. */
    float         alpha;     /**< Current blend of the models. */
    s8            pattern;   /**< Pair of models drawn: 0 the first two, 1 the last two, 2 the first and last. */
    s8            state;     /**< Fade state, a SPARC_EFFECT_STATE value. */
    s8            color;     /**< Tint: 0 fire, 1 cold, 2 thunder, 3 wind. */

    /**
     *
     * Draws the selected models, tinted and faded.
     *
     * @mangled Draw__12CSparcEffectFv
     * @address 0x1C1E90
     * @size 0x240
     */
    void Draw();

    /**
     *
     * Fades the models one step.
     *
     * @mangled Step__12CSparcEffectFv
     * @address 0x1C20D0
     * @size 0xB0
     */
    void Step();

    /**
     *
     * Turns the effect off.
     *
     * @mangled Initialize__12CSparcEffectFv
     * @address 0x1C2180
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CSparcEffect) == 0xB0);

/**
 *
 * Small sprite that rises and fades, such as the glint of a picked-up item.
 *
 */
class CMiniEffPrim {
public:
    sceVu0FVECTOR pos;   /**< Position of the sprite. */
    s8            state; /**< State, a MINI_EFF_PRIM_STATE value. */
    s8            color; /**< Tint: 0 green, 1 gold. */
    float         alpha; /**< Blend, from one down to nothing. */
    float         size;  /**< Drawn size. */

    /**
     *
     * Starts the sprite at a point with a tint.
     *
     * @mangled SetPrim__12CMiniEffPrimFPfi
     * @address 0x1C2190
     * @size 0x70
     */
    void SetPrim(float *pos, int color);

    /**
     *
     * Adds the sprite to a primitive batch.
     *
     * @mangled Draw__12CMiniEffPrimFP10CPreSprite
     * @address 0x1C2200
     * @size 0x150
     */
    void Draw(CPreSprite *prim);

    /**
     *
     * Raises and fades the sprite one step; returns non-zero on the step it vanishes.
     *
     * @mangled Step__12CMiniEffPrimFv
     * @address 0x1C2350
     * @size 0x80
     */
    int Step();

    /**
     *
     * Frees the sprite's slot.
     *
     * @mangled Initialize__12CMiniEffPrimFv
     * @address 0x1C23D0
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CMiniEffPrim) == 0x20);

/**
 *
 * Keeps a pool of mini effect sprites and draws them in one batch.
 *
 */
class CMiniEffPrimMan {
public:
    CMiniEffPrim prim[MINI_EFF_PRIM_MAX]; /**< The sprites. */
    s32          active_num;              /**< Number of sprites in use. */
    u8           unk_804[0xC];
    CPreSprite   draw_prim;               /**< Primitive batch the sprites are drawn with. */

    /**
     *
     * Starts a sprite in the first free slot.
     *
     * @mangled CreatPrim__15CMiniEffPrimManFPfi
     * @address 0x1C23E0
     * @size 0x70
     */
    void CreatPrim(float *pos, int color);

    /**
     *
     * Draws every sprite in use.
     *
     * @mangled Draw__15CMiniEffPrimManFv
     * @address 0x1C2450
     * @size 0xE0
     */
    void Draw();

    /**
     *
     * Moves every sprite one step and counts the ones that vanish.
     *
     * @mangled Step__15CMiniEffPrimManFv
     * @address 0x1C2530
     * @size 0x70
     */
    void Step();

    /**
     *
     * Frees every sprite.
     *
     * @mangled Initialize__15CMiniEffPrimManFv
     * @address 0x1C25A0
     * @size 0x60
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CMiniEffPrimMan) == 0x940);

/**
 *
 * Pulses a character's lighting toward a colour a set number of times.
 *
 */
struct CPalletAnime {
    s16 red;       /**< Red the lighting pulses toward. */
    s16 green;     /**< Green the lighting pulses toward. */
    s16 blue;      /**< Blue the lighting pulses toward. */
    s16 pulse_num; /**< Number of pulses in one cycle. */
    s16 elapsed;   /**< Frames elapsed in the current cycle. */
    s16 duration;  /**< Frames in one cycle; the animation is off at zero. */
    s16 repeats;   /**< Cycles left after this one, or -1 to repeat indefinitely. */

    /**
     *
     * Starts a palette animation.
     *
     * @mangled SetAnim__12CPalletAnimeFssssss
     * @address 0x1C2600
     * @size 0x20
     */
    void SetAnim(short red, short green, short blue, short pulse_num, short duration, short repeats);

    /**
     *
     * Blends a base colour toward this animation's colour by the current pulse; returns non-zero if it did.
     *
     * @mangled CreatPallet__12CPalletAnimeFPfPf
     * @address 0x1C2620
     * @size 0x130
     */
    int CreatPallet(float *out, float *base);

    /**
     *
     * Advances the palette animation by one frame.
     *
     * @mangled Step__12CPalletAnimeFv
     * @address 0x1C2750
     * @size 0x70
     */
    void Step();

    /**
     *
     * Stops the palette animation.
     *
     * @mangled Initialize__12CPalletAnimeFv
     * @address 0x1C27C0
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CPalletAnime) == 0xE);

/**
 *
 * One light orbiting a healing point.
 *
 */
struct HEALING_LIGHT {
    sceVu0FVECTOR pos;        /**< World position, worked out each draw. */
    float         radius;     /**< Distance from the healing point. */
    float         angle;      /**< Angle about the vertical. */
    float         bob_height; /**< Height of the up-and-down bob. */
    float         bob_phase;  /**< Phase of the bob. */
    float         bob_speed;  /**< Phase added to the bob per step. */
    float         spin;       /**< Angle added per step. */
};

STATIC_ASSERT(sizeof(HEALING_LIGHT) == 0x30);

/**
 *
 * Draws the lights that circle a floor's healing point and shows whether it can be used.
 *
 */
class CHealingEffectMan {
public:
    s16           active;     /**< Non-zero once a healing point has been placed. */
    HEALING_LIGHT light[HEALING_LIGHT_MAX]; /**< The lights. */
    float         brightness; /**< Fade value that the mode animates. */
    s16           mode;       /**< State, a HEALING_EFFECT_MODE value. */
    sceVu0FVECTOR center;     /**< Position of the healing point. */

    /**
     *
     * Draws the lights, faded out with distance from the camera.
     *
     * @mangled Draw__17CHealingEffectManFP9mgCCamera
     * @address 0x1C27D0
     * @size 0x3B0
     */
    void Draw(mgCCamera *camera);

    /**
     *
     * Advances the fade and moves every light one step.
     *
     * @mangled Step__17CHealingEffectManFv
     * @address 0x1C2B80
     * @size 0x150
     */
    void Step();

    /**
     *
     * Changes the state of the lights.
     *
     * @mangled SetMode__17CHealingEffectManFi
     * @address 0x1C2CD0
     * @size 0x10
     */
    void SetMode(int mode);

    /**
     *
     * Places the healing point and lights it.
     *
     * @mangled Set__17CHealingEffectManFPf
     * @address 0x1C2CE0
     * @size 0x40
     */
    void Set(float *pos);

    /**
     *
     * Turns the effect off and scatters the lights' orbits.
     *
     * @mangled Initialize__17CHealingEffectManFv
     * @address 0x1C2D20
     * @size 0x120
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CHealingEffectMan) == 0x330);

/**
 *
 * Glow drawn along the blade of the player's sword.
 *
 */
class CSwordLuminous {
public:
    s8        mode;       /**< State, a SWORD_LUMINOUS_MODE value. */
    mgCFrame *tip_frame;  /**< Frame at the tip of the blade. */
    mgCFrame *root_frame; /**< Frame at the root of the blade. */
    u8        unk_c[4];
    float     fade;       /**< Fade value that the mode animates. */
    float     pulse;      /**< Phase of the glow's size pulse. */

    /**
     *
     * Draws a row of glows from the root to the tip of the blade.
     *
     * @mangled Draw__14CSwordLuminousFv
     * @address 0x1C2E40
     * @size 0x200
     */
    void Draw();

    /**
     *
     * Advances the fade and the pulse one step.
     *
     * @mangled Step__14CSwordLuminousFv
     * @address 0x1C3040
     * @size 0xD0
     */
    void Step();
};

STATIC_ASSERT(sizeof(CSwordLuminous) == 0x18);

/**
 *
 * Ribbon left behind a sword swing in events, built from a ring of recorded edge pairs smoothed into a curve.
 *
 */
class CSWordAfterImage {
public:
    sceVu0FVECTOR *edge_point;   /**< Ring of recorded points along the leading edge. */
    sceVu0FVECTOR *back_point;   /**< Ring of recorded points along the trailing edge. */
    float         *life;         /**< Ring of the recorded pairs' remaining lives. */
    sceVu0FVECTOR *smooth_edge;  /**< Smoothed leading edge built from the ring. */
    sceVu0FVECTOR *smooth_back;  /**< Smoothed trailing edge built from the ring. */
    float         *smooth_life;  /**< Life interpolated along the smoothed edges. */
    u8             unk_18[8];
    s32            edge_color[4]; /**< Colour and peak alpha of the leading edge. */
    s32            back_color[4]; /**< Colour and peak alpha of the trailing edge. */
    s32            division;      /**< Smoothed points made between two recorded pairs. */
    s32            smooth_num;    /**< Number of smoothed points last built. */
    s32            point_max;     /**< Size of the rings. */
    s32            point_num;     /**< Number of live pairs in the rings. */
    s32            write_index;   /**< Ring slot written next; the ring fills downward. */
    s32            head_index;    /**< Ring slot written last. */
    s32            active;        /**< Non-zero while any pair is alive. */
    u8             unk_5c[4];

    /**
     *
     * Draws the smoothed ribbon.
     *
     * @mangled Draw__16CSWordAfterImageFv
     * @address 0x1C3110
     * @size 0x200
     */
    void Draw();

    /**
     *
     * Rebuilds the smoothed edges and lives from the ring.
     *
     * @mangled CreatPointList__16CSWordAfterImageFv
     * @address 0x1C3310
     * @size 0x180
     */
    void CreatPointList();

    /**
     *
     * Records a new edge pair with its life.
     *
     * @mangled AddPoint__16CSWordAfterImageFPfPff
     * @address 0x1C3490
     * @size 0xD0
     */
    void AddPoint(float *edge, float *back, float life);

    /**
     *
     * Ages every live pair one step and drops the dead ones.
     *
     * @mangled Step__16CSWordAfterImageFv
     * @address 0x1C3560
     * @size 0xC0
     */
    void Step();

    /**
     *
     * Allocates the rings and smoothed lists and resets the ribbon.
     *
     * @mangled Initialize__16CSWordAfterImageFP9mgCMemoryii
     * @address 0x1C3620
     * @size 0x180
     */
    void Initialize(mgCMemory *memory, int point_max, int division);
};

STATIC_ASSERT(sizeof(CSWordAfterImage) == 0x60);

/**
 *
 * Wire drawn from the player to a pulled item, as a smoothed line through its recent positions.
 *
 */
class CAfterWire {
public:
    s32           mode;        /**< Non-zero while the wire is drawn. */
    sceVu0FVECTOR point[AFTER_WIRE_POINT_MAX]; /**< Ring of recent positions. */
    s16           smooth_num;  /**< Number of smoothed points last built. */
    s16           point_num;   /**< Number of positions in the ring. */
    s16           oldest;      /**< Ring slot of the oldest position. */
    s16           write_index; /**< Ring slot written next. */
    s16           newest;      /**< Ring slot written last. */

    /**
     *
     * Clears the wire.
     *
     * @mangled __ct__10CAfterWireFv
     * @address 0x1D5D10
     * @size 0x10
     */
    CAfterWire() { mode = 0; }

    /**
     *
     * Turns the wire on or off and empties the ring.
     *
     * @mangled SetMode__10CAfterWireFi
     * @address 0x1C37A0
     * @size 0x20
     */
    void SetMode(int mode);

    /**
     *
     * Records a new position.
     *
     * @mangled SetPos__10CAfterWireFPf
     * @address 0x1C37C0
     * @size 0xB0
     */
    void SetPos(float *pos);

    /**
     *
     * Smooths the ring into a work buffer and draws it as a fading line strip.
     *
     * @mangled DrawWire__10CAfterWireFPA4_f
     * @address 0x1C3870
     * @size 0x180
     */
    void DrawWire(sceVu0FVECTOR *work);

    /**
     *
     * Does nothing.
     *
     * @mangled StepWire__10CAfterWireFv
     * @address 0x1C39F0
     * @size 0x20
     */
    void StepWire();
};

STATIC_ASSERT(sizeof(CAfterWire) == 0x120);

/**
 * Dungeon trail slots used by weapon experience pickups.
 */
extern CAfterWire afterWire[16];

/**
 *
 * Burst of sparks thrown from the point of a hit or a guard.
 *
 */
class CHitEffectImage {
public:
    sceVu0FVECTOR     origin;      /**< Point the burst starts at. */
    sceVu0FVECTOR     direction;   /**< Direction the burst is thrown in. */
    BattleEffectPrim *spark;       /**< The sparks. */
    s32               spark_num;   /**< Number of sparks in the burst. */
    s32               live_num;    /**< Number of sparks still alive; the effect is off at zero. */
    s32               spark_max;   /**< Number of sparks the block holds. */
    float             spread;      /**< Size of the box the sparks' directions are picked in. */
    float             slow;        /**< Most speed a spark loses per step, doubled. */
    float             distance;    /**< Distance a spark travels over its life. */
    float             gravity;     /**< Drop added to each spark's direction per step. */
    float             sprite_size; /**< Drawn size of a quad spark. */
    s32               kind;        /**< Way the sparks are drawn, a HIT_EFFECT_KIND value. */
    u8                unk_48[8];
    mgRect<int>       tex_rect;    /**< Texture position and size of a quad spark. */

    /**
     *
     * Clears the texture rectangle.
     *
     * @mangled __ct__15CHitEffectImageFv
     * @address 0x1C6D70
     * @size 0x40
     */
    CHitEffectImage();

    /**
     *
     * Throws a new burst from a point in a direction.
     *
     * @mangled SethitEffect__15CHitEffectImageFPfPfffffii
     * @address 0x1C3A10
     * @size 0x310
     */
    void SethitEffect(float *pos, float *direction, float spread, float distance, float slow, float gravity,
                      int life, int spark_num);

    /**
     *
     * Moves every spark one step.
     *
     * @mangled Step__15CHitEffectImageFv
     * @address 0x1C3D20
     * @size 0x120
     */
    void Step();

    /**
     *
     * Draws the sparks as the kind asks.
     *
     * @mangled Draw__15CHitEffectImageFv
     * @address 0x1C3E40
     * @size 0x80
     */
    void Draw();

    /**
     *
     * Draws every spark as a textured quad.
     *
     * @mangled DrawBord__15CHitEffectImageFv
     * @address 0x1C3EC0
     * @size 0x280
     */
    void DrawBord();

    /**
     *
     * Draws every spark as a streak of a given length along its direction.
     *
     * @mangled DrawSpark__15CHitEffectImageFf
     * @address 0x1C4140
     * @size 0x1C0
     */
    void DrawSpark(float length);
};

STATIC_ASSERT(sizeof(CHitEffectImage) == 0x60);

/**
 *
 * Flash that grows and fades at a point, or on a frame it follows.
 *
 */
class CFlushEffect {
public:
    mgCFrame     *follow;     /**< Frame whose position the flash follows, or null. */
    sceVu0FVECTOR pos;        /**< Position of the flash. */
    float         fade_speed; /**< Alpha lost per step. */
    s16           alpha;      /**< Blend of the flash. */
    float         size;       /**< Drawn size. */
    float         grow;       /**< Size added per step. */
    s16           active;     /**< Non-zero while the flash is drawn. */
    s16           tex_u;      /**< Left texel of the flash's texture square. */
    s16           tex_v;      /**< Top texel of the flash's texture square. */
    s16           tex_size;   /**< Width and height of the texture square. */

    /**
     *
     * Draws the flash as a textured quad.
     *
     * @mangled Draw__12CFlushEffectFv
     * @address 0x1C4300
     * @size 0x210
     */
    void Draw();

    /**
     *
     * Follows the frame, grows and fades the flash one step.
     *
     * @mangled Step__12CFlushEffectFv
     * @address 0x1C4510
     * @size 0x80
     */
    void Step();
};

STATIC_ASSERT(sizeof(CFlushEffect) == 0x40);

/**
 *
 * Streaks rising around a frame while a character powers up.
 *
 */
class CPowerLine {
public:
    mgCFrame         *source;    /**< Frame the streaks rise around. */
    sceVu0FVECTOR     pos;       /**< Position of the frame, read each step. */
    float             radius;    /**< Distance from the frame a streak can start. */
    float             prim_size; /**< Size range of a new streak. */
    float             rise;      /**< Height a new streak rises per step. */
    u8                unk_2c[8];
    s32               duration;  /**< Steps left over which new streaks are started; off at zero. */
    s32               elapsed;   /**< Steps for which streaks have been started. */
    s32               prim_life; /**< Steps a new streak lives. */
    float             height;    /**< Height range a new streak starts in, over five. */
    u8                unk_44[0xC];
    mgRect<int>       tex_rect;  /**< Texture position of a streak. */
    s32               color[4];  /**< Colour and alpha of the streaks. */
    BattleEffectPrim *prim;      /**< The streaks. */
    s32               prim_max;  /**< Number of streaks the block holds. */
    s32               live_num;  /**< Number of streaks still alive. */
    s32               next;      /**< Block slot the next streak is written to. */

    /**
     *
     * Clears the texture rectangle and sets a neutral colour.
     *
     * @mangled __ct__10CPowerLineFv
     * @address 0x1C6D20
     * @size 0x50
     */
    CPowerLine();

    /**
     *
     * Starts a streak at a random point around the frame.
     *
     * @mangled CreatPrim__10CPowerLineFv
     * @address 0x1C4590
     * @size 0x120
     */
    void CreatPrim();

    /**
     *
     * Raises every streak one step, follows the frame and starts a new streak while the duration lasts.
     *
     * @mangled Step__10CPowerLineFv
     * @address 0x1C46B0
     * @size 0x100
     */
    void Step();

    /**
     *
     * Draws every live streak as a textured quad.
     *
     * @mangled Draw__10CPowerLineFv
     * @address 0x1C47B0
     * @size 0x270
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CPowerLine) == 0x80);

/**
 *
 * Coloured cloud that bursts from a monster as it dies.
 *
 */
class CDeadEffect {
public:
    sceVu0FVECTOR     pos;      /**< Point the cloud bursts from. */
    float             height;   /**< Height range a new fleck starts in, over 0.3. */
    float             radius;   /**< Distance from the point a new fleck can start. */
    float             size;     /**< Size range of a new fleck. */
    s32               duration; /**< Steps over which new flecks are started; off at zero. */
    s32               elapsed;  /**< Steps for which flecks have been started. */
    BattleEffectPrim *prim;     /**< The flecks. */
    s32               prim_max; /**< Number of flecks the block holds. */
    s32               live_num; /**< Number of flecks still alive. */
    s32               next;     /**< Block slot the next fleck is written to. */

    /**
     *
     * Starts a cloud at a point.
     *
     * @mangled SetDeadEffect__11CDeadEffectFPffffi
     * @address 0x1C4A20
     * @size 0x70
     */
    void SetDeadEffect(float *pos, float radius, float height, float size, int duration);

    /**
     *
     * Starts a fleck of a given look at a random point of the cloud.
     *
     * @mangled CreatPrim__11CDeadEffectFi
     * @address 0x1C4A90
     * @size 0x280
     */
    void CreatPrim(int kind);

    /**
     *
     * Moves every fleck one step and starts new flecks while the duration lasts.
     *
     * @mangled Step__11CDeadEffectFv
     * @address 0x1C4D10
     * @size 0x1B0
     */
    void Step();

    /**
     *
     * Draws every live fleck, coloured in turn.
     *
     * @mangled Draw__11CDeadEffectFv
     * @address 0x1C4EC0
     * @size 0x480
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CDeadEffect) == 0x40);

/**
 *
 * One light ball drifting around the camera on some floors.
 *
 */
class CMapEffect_Sprite {
public:
    sceVu0FVECTOR pos;        /**< Position of the ball. */
    sceVu0FVECTOR target;     /**< Point the ball drifts toward; picked anew once reached. */
    sceVu0FVECTOR direction;  /**< Direction toward the first target, which bends the drift. */
    float         bob_angle;  /**< Phase of the up-and-down bob. */
    float         bob_height; /**< Height of the bob, over ten. */
    s32           life;       /**< Steps left; the ball is gone at zero. */
    s32           life_max;   /**< Steps the ball started with. */
    float         speed;      /**< Distance moved per step. */
    s32           type;       /**< Look of the ball, a MAP_EFFECT_TYPE value. */

    /**
     *
     * Starts the ball at a point, with a random target, life and bob.
     *
     * @mangled Set__17CMapEffect_SpriteFPf
     * @address 0x1C5340
     * @size 0x230
     */
    void Set(float *pos);

    /**
     *
     * Drifts the ball one step, and ends it once it is far from the camera.
     *
     * @mangled Step__17CMapEffect_SpriteFP9mgCCamera
     * @address 0x1C5570
     * @size 0x2B0
     */
    void Step(mgCCamera *camera);

    /**
     *
     * Adds the ball to a primitive batch, faded in and out over its life.
     *
     * @mangled Draw__17CMapEffect_SpriteFP9mgCCameraP10CPreSprite
     * @address 0x1C5820
     * @size 0x330
     */
    void Draw(mgCCamera *camera, CPreSprite *prim);
};

STATIC_ASSERT(sizeof(CMapEffect_Sprite) == 0x50);

/**
 *
 * Keeps the light balls that drift around the camera on some floors.
 *
 */
class CMapEffectsManeger {
public:
    s32                spawn_wait; /**< Steps left before another ball may start. */
    s32                live_num;   /**< Number of live balls, counted each step. */
    s32                sprite_num; /**< Number of balls the pool holds. */
    CMapEffect_Sprite *sprite;     /**< The balls. */
    s32                type;       /**< Floor's ball type, a MAP_EFFECT_TYPE value. */

    /**
     *
     * Allocates the pool of balls.
     *
     * @mangled Init_LightBoll__18CMapEffectsManegerFP9mgCMemoryi
     * @address 0x1C5B50
     * @size 0x160
     */
    void Init_LightBoll(mgCMemory *memory, int sprite_num);

    /**
     *
     * Starts a ball in front of the camera when one is free, and moves every live ball one step.
     *
     * @mangled Step__18CMapEffectsManegerFP9mgCCamera
     * @address 0x1C5CB0
     * @size 0x3A0
     */
    void Step(mgCCamera *camera);

    /**
     *
     * Draws every live ball in one batch.
     *
     * @mangled Draw__18CMapEffectsManegerFP9mgCCamera
     * @address 0x1C6050
     * @size 0x180
     */
    void Draw(mgCCamera *camera);
};

STATIC_ASSERT(sizeof(CMapEffectsManeger) == 0x14);

/**
 *
 * Pools of the battle's short effects, each handed out in turn from a ring.
 *
 */
class BattleEffectMan {
public:
    BattleEffectPrim  *hit_prim;    /**< Spark block shared by the hit effects. */
    CHitEffectImage   *hit;         /**< Hit effects. */
    s32                hit_num;     /**< Number of hit effects. */
    s32                hit_next;    /**< Hit effect handed out next. */
    CFlushEffect      *flush;       /**< Flashes. */
    s32                flush_num;   /**< Number of flashes. */
    s32                flush_next;  /**< Flash handed out next. */
    BattleEffectPrim  *power_prim;  /**< Streak block shared by the power lines. */
    CPowerLine        *power;       /**< Power lines. */
    s32                power_num;   /**< Number of power lines. */
    s32                power_next;  /**< Power line handed out next. */
    BattleEffectPrim  *dead_prim;   /**< Fleck block shared by the death clouds. */
    CDeadEffect       *dead;        /**< Death clouds. */
    s32                dead_num;    /**< Number of death clouds. */
    s32                dead_next;   /**< Death cloud handed out next. */
    CCharacter2       *chara;       /**< Pooled characters. */
    BattleEffectChara *chara_slot;  /**< Slot record of each pooled character. */
    s32                chara_num;   /**< Number of pooled characters. */

    /**
     *
     * Allocates one pool and its blocks; returns non-zero on success.
     *
     * @mangled AllocEffect__15BattleEffectManFiP9mgCMemoryi
     * @address 0x1C61D0
     * @size 0xAB0
     */
    int AllocEffect(int kind, mgCMemory *memory, int num);

    /**
     *
     * Moves every pooled effect one step.
     *
     * @mangled Step__15BattleEffectManFv
     * @address 0x1C6DB0
     * @size 0x110
     */
    void Step();

    /**
     *
     * Draws every pooled effect.
     *
     * @mangled Draw__15BattleEffectManFv
     * @address 0x1C6EC0
     * @size 0x110
     */
    void Draw();
};

STATIC_ASSERT(sizeof(BattleEffectMan) == 0x48);

/**
 *
 * Throws a cloud of sparks off a weapon for as long as its element is charged, giving each spark the motion
 * its element calls for and drawing them all from the "effect02" texture.
 *
 */
class CWeaponElement {
public:
    sceVu0FVECTOR *origin;     /**< Point the cloud is drawn around, held by the weapon. */
    sceVu0FVECTOR  fire_pos;   /**< Point the fire element was started at, which its sparks stay around. */
    sceVu0FVECTOR  offset[WEAPON_ELEMENT_SPARK_MAX];     /**< Distance of each spark from the origin. */
    sceVu0FVECTOR  velocity[WEAPON_ELEMENT_SPARK_MAX];   /**< Distance each spark moves per step. */
    float          size[WEAPON_ELEMENT_SPARK_MAX];       /**< Width each spark draws at before it shrinks. */
    float          shrink[WEAPON_ELEMENT_SPARK_MAX];     /**< Share of the width left, from one down to nothing. */
    float          alpha[WEAPON_ELEMENT_SPARK_MAX];      /**< Blend each spark draws at; nothing means the slot is free. */
    float          spread;                               /**< Distance from the origin that a new spark can start. */
    s16            kind;                                 /**< Element the weapon is charged with, a WEAPON_ELEMENT_KIND value. */
    float          power;                                /**< Strength of the charge, which sets the count and the size. */
    s16            on;                                   /**< Non-zero while the cloud is moved and drawn. */
    s16            count;                                /**< Number of sparks the charge starts with. */
    float          scale;                                /**< Width every spark is drawn at, over the size it carries. */
    float          spin[WEAPON_ELEMENT_SPARK_MAX];       /**< Angle each spark is turned about the vertical. */
    float          spin_speed[WEAPON_ELEMENT_SPARK_MAX]; /**< Angle the spin turns each step. */
    s16            spawn_delay_max;                      /**< Longest wait between two sparks being started again. */
    s16            spawn_delay;                          /**< Steps left before the next spark is started again. */
    s16            spawn_budget;                         /**< Number of sparks the charge can still start again. */
    s16            fading[WEAPON_ELEMENT_SPARK_MAX];     /**< 0 while a spark brightens, 1 once it is fading out. */
    s16            frame[WEAPON_ELEMENT_SPARK_MAX];      /**< Texture row offset each spark draws. */
    s16            frame_timer;                          /**< Counts four steps down, and the sparks pick new rows on the fourth. */
    s16            bolt_head[WEAPON_ELEMENT_BOLT_MAX];   /**< Spark each bolt arcs from. */
    s16            bolt_tail[WEAPON_ELEMENT_BOLT_MAX];   /**< Spark each bolt arcs to. */
    s16            bolt_timer[WEAPON_ELEMENT_BOLT_MAX];  /**< Steps left before a bolt picks new ends. */
    s16            bolt_frame[WEAPON_ELEMENT_BOLT_MAX];  /**< Part of the texture each bolt draws. */
    s16            bolt_count;                           /**< Number of bolts the charge arcs between its sparks. */

    /**
     *
     * Resets every spark's size and blend and turns the cloud off.
     *
     * @mangled Initialize__14CWeaponElementFv
     * @address 0x1C6FD0
     * @size 0x70
     */
    void Initialize();

    /**
     *
     * Charges the cloud with one element and starts its first sparks.
     *
     * @mangled Set__14CWeaponElementFPA4_fPffif
     * @address 0x1C7040
     * @size 0xC0
     */
    void Set(sceVu0FVECTOR *origin, float *position, float power, int kind, float spread);

    /**
     *
     * Moves the cloud one step, by the way the charged element calls for.
     *
     * @mangled Step__14CWeaponElementFv
     * @address 0x1C7100
     * @size 0x80
     */
    void Step();

    /**
     *
     * Draws the cloud, by the way the charged element calls for.
     *
     * @mangled Draw__14CWeaponElementFv
     * @address 0x1C7180
     * @size 0x80
     */
    void Draw();

    /**
     *
     * Starts a cloud of sparks that fall away from the blade.
     *
     * @mangled Init_Cold__14CWeaponElementFPf
     * @address 0x1C7200
     * @size 0x380
     */
    void Init_Cold(float *position);

    /**
     *
     * Drops every cold spark, and starts free slots again while the budget lasts.
     *
     * @mangled Step_Cold__14CWeaponElementFv
     * @address 0x1C7580
     * @size 0x4C0
     */
    void Step_Cold();

    /**
     *
     * Draws every cold spark that still carries a blend.
     *
     * @mangled Draw_Cold__14CWeaponElementFv
     * @address 0x1C7A40
     * @size 0x220
     */
    void Draw_Cold();

    /**
     *
     * Starts a cloud of sparks that blow away on a rising wind, each spinning.
     *
     * @mangled Init_Wind__14CWeaponElementFPf
     * @address 0x1C7C60
     * @size 0x480
     */
    void Init_Wind(float *position);

    /**
     *
     * Blows every wind spark along, turning it, and starts free slots again.
     *
     * @mangled Step_Wind__14CWeaponElementFv
     * @address 0x1C80E0
     * @size 0x5A0
     */
    void Step_Wind();

    /**
     *
     * Draws every wind spark, turned about the vertical by the spin it carries.
     *
     * @mangled Draw_Wind__14CWeaponElementFv
     * @address 0x1C8680
     * @size 0x260
     */
    void Draw_Wind();

    /**
     *
     * Starts a cloud of sparks that drift upward off the blade.
     *
     * @mangled Init_Fire__14CWeaponElementFPf
     * @address 0x1C88E0
     * @size 0x390
     */
    void Init_Fire(float *position);

    /**
     *
     * Raises every fire spark, and starts free slots again while the budget lasts.
     *
     * @mangled Step_Fire__14CWeaponElementFv
     * @address 0x1C8C70
     * @size 0x4C0
     */
    void Step_Fire();

    /**
     *
     * Draws every fire spark that still carries a blend.
     *
     * @mangled Draw_Fire__14CWeaponElementFv
     * @address 0x1C9130
     * @size 0x220
     */
    void Draw_Fire();

    /**
     *
     * Starts a cloud of sparks that fly apart, and the bolts that arc between them.
     *
     * @mangled Init_Thunder__14CWeaponElementFPf
     * @address 0x1C9350
     * @size 0x520
     */
    void Init_Thunder(float *position);

    /**
     *
     * Carries every thunder spark along its own line, and gives the bolts new ends.
     *
     * @mangled Step_Thunder__14CWeaponElementFv
     * @address 0x1C9870
     * @size 0x2C0
     */
    void Step_Thunder();

    /**
     *
     * Draws every thunder spark, then a bolt across each pair the charge picked.
     *
     * @mangled Draw_Thunder__14CWeaponElementFv
     * @address 0x1C9B30
     * @size 0x540
     */
    void Draw_Thunder();
};

STATIC_ASSERT(sizeof(CWeaponElement) == 0x7C0);

/**
 *
 * Builds a Catmull-Rom curve through a ring of points, writing a set number of points per span; returns the
 * number of points written, or zero for fewer than three points.
 *
 * @mangled CreatSmoothPass__FPA4_fPA4_fiiii
 * @address 0x1CA070
 * @size 0x390
 */
int CreatSmoothPass(sceVu0FVECTOR *out, sceVu0FVECTOR *ring, int point_num, int division, int start, int ring_size);

/**
 *
 * Turns a frame's heading one step toward a target angle, by a fraction of a half turn; returns the new heading.
 *
 * @mangled unitRotation__FP8mgCFrameff
 * @address 0x1CA400
 * @size 0x270
 */
float unitRotation(mgCFrame *frame, float target, float divide);

/**
 *
 * Returns a random integer from zero up to, but not including, a limit.
 *
 * @mangled iRand__Fi
 * @address 0x1CA670
 * @size 0x60
 */
int iRand(int limit);

/**
 *
 * Returns a random float from zero up to a limit.
 *
 * @mangled fRand__Ff
 * @address 0x1CA6D0
 * @size 0x40
 */
float fRand(float limit);

int LocalTransWorldPrimPos(int (*corners)[4], float *pos, float width, float height, float angle);
