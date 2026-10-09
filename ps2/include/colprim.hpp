#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the collision primitives that carry an attack's damage through the dungeon: the
 * damage parameter table that each attack names, the primitive that tests whether a sphere or
 * line of that attack touches a character, and the manager that holds every primitive.
 */

class CScene;
class mgCFrame;

/** Number of collision primitives that the manager holds. */
#define COLPRIM_MAX 64
/** Number of rows in the damage parameter table. */
#define DAMAGE_PARAM_MAX 115
/** Number of elemental attribute values that an attack carries. */
#define DAMAGE_ELEMENT_MAX 8

/**
 *
 * Shapes that a damage parameter row gives its collision primitive.
 *
 */
// clang-format off
enum DamageShape {
    DAMAGE_SHAPE_POINT = 1 << 0, /**< Spheres around the first position. */
    DAMAGE_SHAPE_LINE  = 1 << 1, /**< Capsules along the line from the first position to the second. */
    DAMAGE_SHAPE_TRAIL = 1 << 2, /**< Also tests the halfway point of the move since the previous step. */
};

// clang-format on

/**
 *
 * Sides of the battle that a collision primitive can hurt.
 *
 */
// clang-format off
enum DamageTarget {
    DAMAGE_TARGET_BY_OWNER = 1 << 0, /**< Hurts the side opposite to the owner: monsters for owner 0, the player otherwise. */
    DAMAGE_TARGET_PLAYER   = 1 << 1, /**< Hurts scene characters of type 1, the player's side. */
    DAMAGE_TARGET_MONSTER  = 1 << 2, /**< Hurts scene characters of type 3, the monsters. */
};

// clang-format on

/**
 *
 * Kinds of attack that a damage parameter row names, which choose the hit reaction, the hit
 * sound and the attacker's weapon wear.
 *
 */
// clang-format off
enum DamageKind {
    DAMAGE_KIND_MAX_MELEE      = 0x00, /**< Max's sword and kicks. */
    DAMAGE_KIND_MAX_GUN        = 0x01, /**< Max's gun shots. */
    DAMAGE_KIND_LASER_GUN      = 0x02, /**< Laser gun shots. */
    DAMAGE_KIND_GRENADE        = 0x03, /**< Grenade gun shots. */
    DAMAGE_KIND_MONICA_MELEE   = 0x04, /**< Monica's sword. */
    DAMAGE_KIND_MONICA_MAGIC   = 0x05, /**< Monica's magic. */
    DAMAGE_KIND_CHECK          = 0x0A, /**< Contact checks that cause no hit reaction, such as gifts. */
    DAMAGE_KIND_RIDEPOD_PUNCH  = 0x0B, /**< Ridepod punches and drill arms. */
    DAMAGE_KIND_RIDEPOD_SWORD  = 0x0C, /**< Ridepod sword arms. */
    DAMAGE_KIND_RIDEPOD_GUN    = 0x0D, /**< Ridepod lasers, machine guns, cannons and launchers. */
    DAMAGE_KIND_MONSTER        = 0x14, /**< Monster attacks. */
    DAMAGE_KIND_ITEM           = 0x19, /**< Thrown items, bombs and explosions. */
};

// clang-format on

/**
 *
 * Ways in which a collision primitive takes its position each step.
 *
 */
// clang-format off
enum ColPrimCoordType {
    COLPRIM_COORD_VECTOR = 1, /**< The positions given to SetCoord stay until they are set again. */
    COLPRIM_COORD_FRAME  = 2, /**< The positions follow the world positions of model frames. */
};

// clang-format on

/**
 *
 * Describes one named attack: the shape it hits with, whom it hurts, how much damage, element
 * and status effects it deals, and how the target reacts.
 *
 */
struct DAMAGE_PARAM {
    char        name[0x10]; /**< Name by which attacks and scripts look up the row. */
    s8          shape;      /**< DAMAGE_SHAPE flags selecting the attack's collision shape. */
    u8          unk_11[3];
    u_int       target; /**< DamageTarget flags. */
    signed char kind;   /**< DamageKind of the attack. */
    u_char      unk_19[0x3];
    int         damage;    /**< Damage that the primitive starts with. */
    signed char multi_hit; /**< Nonzero when the attack can hit the same character more than once. */
    u_char      unk_21;
    signed char stagger; /**< Amount that a hit adds to the target's stagger count. */
    u_char      unk_23;
    short       critical_rate; /**< Percentage by which a critical hit scales the damage. */
    s16         hit_flags;     /**< Flags that choose the hit effect and reaction. */
    int         unk_28;
    short       element[DAMAGE_ELEMENT_MAX]; /**< Elemental attribute values that the primitive starts with. */
    int         source_type;                 /**< Kind of attacker, recorded on the monster that takes the hit. */
    u_int       status;                      /**< Special status flags that a hit inflicts. */
    short       stun_time;                   /**< Frames for which a hit stuns the target. */
    short       hit_count;                   /**< Number of hits over which the attack's damage is divided. */
};

STATIC_ASSERT(sizeof(DAMAGE_PARAM) == 0x48);

/**
 *
 * A sphere or line that deals an attack's damage to the characters it touches,
 * following given positions or model frames until it is deleted or its time runs out.
 *
 */
class CColPrim {
public:
    int           id;       /**< Index of the primitive in its manager. */
    int           param_no; /**< Index of the damage parameter row. */
    DAMAGE_PARAM *param;    /**< Damage parameter row of the attack. */
    int           active;   /**< Nonzero while the primitive is in use. */
    int           owner;    /**< Identifier of the character or script that created the primitive. */
    int           unk_14;
    u_long        hit_mask;   /**< One bit per character identifier that the primitive has already hit. */
    int           step_count; /**< Steps since the primitive was set up. */
    int           life;       /**< Steps after which the primitive is deleted, or -1 to last until deleted. */
    int           hit_num;    /**< Number of hits that the primitive has dealt. */
    int           attacker;   /**< Battle character that deals the attack, or -1. */
    u_int         coord_type; /**< ColPrimCoordType of the positions. */
    int           unk_34;
    mgCFrame     *frame[2];   /**< Model frames whose world positions give the start and end of the shape. */
    sceVu0FVECTOR pos[2];     /**< Start and end of the shape this step. */
    sceVu0FVECTOR old_pos[2]; /**< Start and end of the shape on the previous step. */
    u_int         target;     /**< DamageTarget flags. */
    float         radius;     /**< Radius of the sphere or line. */
    int           damage;     /**< Damage that a hit deals. */
    int           unk_8c;
    short         element[DAMAGE_ELEMENT_MAX]; /**< Elemental attribute values of the attack. */
    u_int         status;                      /**< Special status flags that a hit inflicts. */
    float         range;                       /**< Distance from the origin beyond which the attack deals no damage. */
    u_char        unk_a8[0x8];
    sceVu0FVECTOR origin;   /**< Position where the primitive started, from which the range is measured. */
    signed char   reversed; /**< Nonzero when an attack has knocked the primitive back. */
    u_char        unk_c1[0xF];
    sceVu0FVECTOR revers_vec; /**< Direction in which the primitive was knocked back. */
    short         gift[3];    /**< Item numbers of the gift that the primitive carries. */
    signed char   has_gift;   /**< Nonzero when the primitive carries a gift. */
    u_char        unk_e7[0x9];
    sceVu0FVECTOR hit_vec; /**< Direction of the last hit. */
    sceVu0FVECTOR hit_pos; /**< Position of the last hit. */

    /**
     *
     * Sets the primitive up from the damage parameter row of the given name.
     *
     * @mangled SetDamage__8CColPrimFPci
     * @address 0x1BB040
     * @size 0x120
     */
    int SetDamage(char *name, int owner);

    /**
     *
     * Places a sphere of the given radius at a position.
     *
     * @mangled SetCoord__8CColPrimFPff
     * @address 0x1BB160
     * @size 0xA0
     */
    void SetCoord(float *pos, float radius);

    /**
     *
     * Places a line of the given radius between two positions.
     *
     * @mangled SetCoord__8CColPrimFPfPff
     * @address 0x1BB200
     * @size 0xE0
     */
    void SetCoord(float *start, float *end, float radius);

    /**
     *
     * Makes a sphere of the given radius follow a model frame.
     *
     * @mangled SetCoord__8CColPrimFP8mgCFramef
     * @address 0x1BB2E0
     * @size 0x50
     */
    void SetCoord(mgCFrame *start, float radius);

    /**
     *
     * Makes a line of the given radius follow two model frames.
     *
     * @mangled SetCoord__8CColPrimFP8mgCFrameP8mgCFramef
     * @address 0x1BB330
     * @size 0x50
     */
    void SetCoord(mgCFrame *start, mgCFrame *end, float radius);

    /**
     *
     * Tests whether the primitive touches a character of the scene, and records the hit.
     *
     * @mangled IsHit__8CColPrimFP6CScenei
     * @address 0x1BB380
     * @size 0x4A0
     */
    int IsHit(CScene *scene, int chara_id);

    /**
     *
     * Tests whether a player's attack is close enough to knock the primitive back.
     *
     * @mangled IsReversVec__8CColPrimFP8CColPrim
     * @address 0x1BB820
     * @size 0xB0
     */
    int IsReversVec(CColPrim *other);

    /**
     *
     * Gives the direction opposite to the primitive's last move.
     *
     * @mangled GetReversVec__8CColPrimFPf
     * @address 0x1BB8D0
     * @size 0x40
     */
    void GetReversVec(float *out_vector);

    /**
     *
     * Reserved debug drawing hook for the collision primitive.
     *
     * @mangled DebugDraw__8CColPrimFv
     * @address 0x1BB910
     * @size 0x10
     */
    void DebugDraw();

    /**
     *
     * Moves the positions on by one step and deletes the primitive when its time runs out.
     *
     * @mangled Step__8CColPrimFv
     * @address 0x1BB920
     * @size 0x140
     */
    int Step();

    /**
     *
     * Deletes the primitive if the given owner created it, or always for an owner of -1.
     *
     * @mangled Delete__8CColPrimFi
     * @address 0x1BBA60
     * @size 0x40
     */
    void Delete(int id);

    /**
     *
     * Clears the primitive to an unused state.
     *
     * @mangled Initialize__8CColPrimFv
     * @address 0x1BBAA0
     * @size 0x40
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CColPrim) == 0x110);

/**
 *
 * Holds every collision primitive of the dungeon, hands out free ones and
 * tests and steps them together.
 *
 */
class CColPrimMan {
public:
    CScene  *scene;             /**< Scene whose characters the primitives hit. */
    CColPrim prim[COLPRIM_MAX]; /**< Primitives that the manager hands out. */

    /**
     *
     * Gives a primitive that is not in use, or null when every one is.
     *
     * @mangled GetPrim__11CColPrimManFv
     * @address 0x1BBAE0
     * @size 0x50
     */
    CColPrim *GetPrim();

    /**
     *
     * Gives the primitive of the given index, or null for an index out of range.
     *
     * @mangled GetID2Prim__11CColPrimManFi
     * @address 0x1BBB30
     * @size 0x40
     */
    CColPrim *GetID2Prim(int id);

    /**
     *
     * Counts the primitives in use.
     *
     * @mangled ActivePrimNum__11CColPrimManFv
     * @address 0x1BBB70
     * @size 0x40
     */
    int ActivePrimNum();

    /**
     *
     * Deletes every primitive that the given owner created, or all of them for an owner of -1.
     *
     * @mangled Delete__11CColPrimManFi
     * @address 0x1BBBB0
     * @size 0x70
     */
    void Delete(int owner);

    /**
     *
     * Gives the first primitive that hits the given character, or null.
     *
     * @mangled CheckHit__11CColPrimManFi
     * @address 0x1BBC20
     * @size 0x90
     */
    CColPrim *CheckHit(int chara_id);

    /**
     *
     * Gives the first other primitive that the given player attack knocks back, or null.
     *
     * @mangled IsReversVec__11CColPrimManFP8CColPrim
     * @address 0x1BBCB0
     * @size 0x90
     */
    CColPrim *IsReversVec(CColPrim *attack);

    /**
     *
     * Steps every primitive.
     *
     * @mangled Step__11CColPrimManFv
     * @address 0x1BBD40
     * @size 0x60
     */
    void Step();

    /**
     *
     * Clears every primitive and sets the scene whose characters they hit.
     *
     * @mangled Initialize__11CColPrimManFP6CScene
     * @address 0x1BBDA0
     * @size 0x70
     */
    void Initialize(CScene *scene);
};

STATIC_ASSERT(sizeof(CColPrimMan) == 0x4410);

/** Damage parameters of every named attack. */
extern DAMAGE_PARAM Damage_Param_Table[DAMAGE_PARAM_MAX];
