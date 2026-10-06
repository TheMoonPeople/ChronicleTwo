#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the slots in which a scene keeps its characters, maps, messages,
 * cameras, skies, game objects and effect scripts, the rain effect with its
 * drops, splashes and ripples, and the random number helpers they share.
 */

class CCharacter2;
class CEffectScriptMan;
class CMap;
class CMapSky;
class ClsMes;
class mgCCamera;
class mgCMemory;

/**
 * Number of rain drops that fall close to the camera.
 */
#define RAIN_DROP_NUM 100

/**
 * Number of rain drops that fall far from the camera.
 */
#define RAIN_FAR_DROP_NUM 50

/**
 * Number of splash particles the rain can show at once.
 */
#define RAIN_PARTICLE_NUM 100

/**
 * Number of ripples the rain keeps on the ground.
 */
#define RAIN_RIPPLE_NUM 200

/**
 * Number of earlier positions a rain drop remembers to draw its streak.
 */
#define RAIN_DROP_TRAIL_NUM 8

/**
 * Kinds of data a scene keeps in slots, selecting which list of slots a
 * scene's status and type functions work on.
 */
enum SCENE_DATA_KIND {
    SCENE_DATA_CHARA   = 1, /**< Character slots. */
    SCENE_DATA_MAP     = 2, /**< Map slots. */
    SCENE_DATA_MESSAGE = 3, /**< Message slots. */
    SCENE_DATA_CAMERA  = 4, /**< Camera slots. */
    SCENE_DATA_SKY     = 5, /**< Sky slots; the scene's slot lookup gives none for this kind. */
    SCENE_DATA_GAMEOBJ = 6, /**< Game object slots. */
    SCENE_DATA_EFFECT  = 7, /**< Effect script slots; the scene's slot lookup gives a game object slot for this kind. */
};

/**
 * Status flags of a scene data slot shared by every kind of slot; the
 * higher bits are given meanings by the code that uses each kind.
 */
enum SCENE_DATA_STATUS {
    SCENE_DATA_LOADED   = 1 << 0, /**< The slot's data has finished loading into its memory stack. */
    SCENE_DATA_ACTIVE   = 1 << 1, /**< The slot takes part in stepping and drawing. */
    SCENE_DATA_ASSIGNED = 1 << 2, /**< Data has been given to the slot. */
};

/**
 * Kinds of rain drop, telling how far from the camera a drop falls.
 */
enum RAIN_DROP_TYPE {
    RAIN_DROP_NEAR = 0, /**< Falls close to the camera and leaves ripples when it lands. */
    RAIN_DROP_FAR  = 1, /**< Falls far from the camera and starts again as soon as it lands. */
};

/**
 * Gives back a random number between two values.
 *
 * @mangled f_rand__Fff
 * @address 0x2850B0
 * @size 0x50
 */
float f_rand(float min, float max);

/**
 * Gives back a random whole number between two values.
 *
 * @mangled i_rand__Fii
 * @address 0x285100
 * @size 0x30
 */
int i_rand(int min, int max);

/**
 * Sets a vector to the origin, with a W of one.
 *
 * @mangled InitVector__FPf
 * @address 0x285130
 * @size 0x20
 */
void InitVector(float *vec);

/**
 * Picks a random ground position in front of the main scene's camera, at a
 * distance and within an angle either side of the view direction, and gives
 * back a height that grows with the distance as the camera looks down.
 *
 * @mangled RandXYinViewArea__FfffPfPf
 * @address 0x285150
 * @size 0x170
 */
float RandXYinViewArea(float min_dist, float max_dist, float angle, float *x, float *z);

/**
 * Draws short streaks of rain at random places straight onto the screen.
 *
 * @mangled DrawScreenRain__Fv
 * @address 0x2865A0
 * @size 0x210
 */
void DrawScreenRain();

/**
 * Ripple that spreads and fades on the ground where rain lands.
 */
class CRipple {
public:
    s32           active;  /**< Non-zero while the ripple is showing. */
    u8            unk_04[0xC];
    sceVu0FVECTOR pos;     /**< Centre of the ripple in the world. */
    float         size;    /**< Width the ripple reaches at the end of its life. */
    s32           count;   /**< Frames the ripple has shown for. */
    s32           life;    /**< Frames the ripple shows for in all. */
    s32           unk_2c;

    /**
     * Makes a ripple that is not showing.
     */
    CRipple() { Init(); }

    /**
     * Starts the ripple at a position with a random size and life, unless
     * it is already showing; gives back zero when it was already showing.
     *
     * @mangled Birth__7CRippleFPf
     * @address 0x2852C0
     * @size 0x80
     */
    int Birth(float *pos);

    /**
     * Ages the ripple by one frame; gives back zero when it is not showing,
     * one while it shows, and -1 on the frame it ends.
     *
     * @mangled Step__7CRippleFv
     * @address 0x285340
     * @size 0x50
     */
    int Step();

    /**
     * Draws the ripple as a circle lying on the ground, growing and fading
     * with its age.
     *
     * @mangled Draw__7CRippleFv
     * @address 0x285390
     * @size 0x3E0
     */
    void Draw();

    /**
     * Stops the ripple and clears its position, size and age.
     *
     * @mangled Init__7CRippleFv
     * @address 0x285770
     * @size 0x40
     */
    void Init();
};

STATIC_ASSERT(sizeof(CRipple) == 0x30);

/**
 * Splash particle thrown up where rain lands, falling back under gravity
 * until it drops below the height it started at.
 */
class CParticle {
public:
    s32           active;  /**< Non-zero while the particle is moving. */
    u8            unk_04[0xC];
    sceVu0FVECTOR pos;     /**< Position of the particle in the world. */
    sceVu0FVECTOR speed;   /**< Distance the particle moves each frame. */
    sceVu0FVECTOR accel;   /**< Change made to speed each frame. */
    float         base_y;  /**< Height the particle started at; it ends when it falls below this. */
    u8            unk_44[0xC];

    /**
     * Makes a particle that is not moving.
     */
    CParticle() { Init(); }

    /**
     * Starts the particle at a position with a speed, falling under
     * gravity, unless it is already moving; gives back non-zero when it
     * was started.
     *
     * @mangled Birth__9CParticleFPfPf
     * @address 0x2857B0
     * @size 0x80
     */
    int Birth(float *pos, float *speed);

    /**
     * Moves the particle by one frame; gives back zero when it is not
     * moving, one while it moves, and -1 on the frame it ends.
     *
     * @mangled Step__9CParticleFv
     * @address 0x285830
     * @size 0xB0
     */
    int Step();

    /**
     * Draws the particle as a point that fades with its distance from the
     * main scene's camera.
     *
     * @mangled Draw__9CParticleFv
     * @address 0x2858E0
     * @size 0x1D0
     */
    void Draw();

    /**
     * Stops the particle and clears its position, speed and acceleration.
     *
     * @mangled Init__9CParticleFv
     * @address 0x285AB0
     * @size 0x40
     */
    void Init();
};

STATIC_ASSERT(sizeof(CParticle) == 0x50);

/**
 * One falling rain drop, drawn as a streak through the positions it held
 * over the last few frames.
 */
class CRainDrop {
public:
    s32           active;                    /**< Non-zero while the drop is falling. */
    s32           type;                      /**< How far from the camera the drop falls (RAIN_DROP_TYPE). */
    u8            unk_08[0x8];
    sceVu0FVECTOR pos[RAIN_DROP_TRAIL_NUM];  /**< Position of the drop this frame, then in each frame before. */
    sceVu0FVECTOR speed;                     /**< Distance the drop moves each frame. */
    s32           color[4];                  /**< Red, green, blue and alpha the streak is drawn with. */

    /**
     * Makes a drop that is not falling.
     */
    CRainDrop() { Init(); }

    /**
     * Starts the drop at a random place above the ground in front of the
     * camera, near or far by its type, unless it is already falling.
     *
     * @mangled Birth__9CRainDropFi
     * @address 0x285AF0
     * @size 0x170
     */
    void Birth(int type);

    /**
     * Moves the drop by one frame; gives back zero when it is not falling,
     * one while it falls, -1 while it is below the ground, and -2 once it
     * has fallen far below it.
     *
     * @mangled Step__9CRainDropFv
     * @address 0x285C60
     * @size 0xD0
     */
    int Step();

    /**
     * Draws the drop as lines through its remembered positions.
     *
     * @mangled Draw__9CRainDropFv
     * @address 0x285D30
     * @size 0x1A0
     */
    void Draw();

    /**
     * Stops the drop and clears its positions, speed and colour.
     *
     * @mangled Init__9CRainDropFv
     * @address 0x285ED0
     * @size 0x80
     */
    void Init();
};

STATIC_ASSERT(sizeof(CRainDrop) == 0xB0);

/**
 * Rain falling around the camera: near and far drops, ripples on the
 * ground, splashes off a character, and streaks drawn over the screen.
 */
class CRain {
public:
    s32       active;                        /**< Non-zero while it is raining. */
    s32       chara_no;                      /**< Scene character slot that rain splashes off, or -1 for none. */
    u8        unk_08[0x8];
    CRainDrop drop[RAIN_DROP_NUM];           /**< Drops falling close to the camera. */
    CRainDrop far_drop[RAIN_FAR_DROP_NUM];   /**< Drops falling far from the camera. */
    CParticle particle[RAIN_PARTICLE_NUM];   /**< Splashes thrown up by the rain. */
    CRipple   ripple[RAIN_RIPPLE_NUM];       /**< Ripples on the ground. */

    /**
     * Makes rain that is not falling.
     */
    CRain() { Init(); }

    /**
     * Chooses the scene character that rain splashes off; choosing none
     * clears every splash.
     *
     * @mangled SetCharNo__5CRainFi
     * @address 0x285F50
     * @size 0x70
     */
    void SetCharNo(int chara_no);

    /**
     * Throws up a splash particle at a position, from a character when the
     * flag is set and from the ground otherwise, using the first particle
     * that is free.
     *
     * @mangled ParticleBirth__5CRainFPfi
     * @address 0x285FC0
     * @size 0xE0
     */
    void ParticleBirth(float *pos, int from_chara);

    /**
     * Stops the rain.
     *
     * @mangled Stop__5CRainFv
     * @address 0x2860A0
     * @size 0x10
     */
    void Stop();

    /**
     * Starts the rain, setting every drop and ripple going.
     *
     * @mangled Start__5CRainFv
     * @address 0x2860B0
     * @size 0x100
     */
    void Start();

    /**
     * Moves the rain by one frame, starting drops, ripples and splashes
     * again as they end.
     *
     * @mangled Step__5CRainFv
     * @address 0x2861B0
     * @size 0x310
     */
    void Step();

    /**
     * Stops the rain and clears every drop, splash and ripple.
     *
     * @mangled Init__5CRainFv
     * @address 0x2864C0
     * @size 0xE0
     */
    void Init();

    /**
     * Draws the drops, splashes and ripples of the rain, then the streaks
     * over the screen, while it is raining.
     *
     * @mangled Draw__5CRainFv
     * @address 0x2867B0
     * @size 0xE0
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CRain) == 0xABF0);

/**
 * Slot in which a scene keeps one piece of named data, with its status and
 * the memory and texture blocks it was loaded into.
 */
class CSceneData {
public:
    CSceneData() { Initialize(); }
    u32        status;         /**< Status flags of the slot (SCENE_DATA_STATUS). */
    s32        type;           /**< Kind of the data within its slot list, set by the data's user. */
    char       name[32];       /**< Name the data was given to the slot under. */
    s32        tex_block;      /**< First texture block the data's textures were loaded into, or -1. */
    s32        tex_block_num;  /**< Number of texture blocks from tex_block that the data uses. */
    mgCMemory *stack;          /**< Memory stack the data was loaded into. */

    /**
     * Empties the slot: no status, no name, and no memory or textures.
     *
     * @mangled Initialize__10CSceneDataFv
     * @address 0x286890
     * @size 0x20
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CSceneData) == 0x34);

/**
 * Slot in which a scene keeps one character.
 */
class CSceneCharacter : public CSceneData {
public:
    CSceneCharacter() { Initialize(); }
    CCharacter2 *chara;    /**< Character kept in the slot. */
    s32          texb;     /**< Texture block the character is drawn with, or -1 for the scene's default. */
    s32          chara_no; /**< Number of the villager or character placed in the slot, or -1. */

    /**
     * Puts a character in the slot under a name; gives back zero when
     * either is missing.
     *
     * @mangled AssignData__15CSceneCharacterFP11CCharacter2Pc
     * @address 0x2868B0
     * @size 0x60
     */
    int AssignData(CCharacter2 *chara, char *name);

    /**
     * Empties the slot.
     *
     * @mangled Initialize__15CSceneCharacterFv
     * @address 0x286910
     * @size 0x20
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CSceneCharacter) == 0x40);

/**
 * Slot in which a scene keeps one map.
 */
class CSceneMap : public CSceneData {
public:
    CSceneMap() { Initialize(); }
    CMap *map; /**< Map kept in the slot. */

    /**
     * Empties the slot.
     *
     * @mangled Initialize__9CSceneMapFv
     * @address 0x286930
     * @size 0x10
     */
    void Initialize();

    /**
     * Puts a map in the slot under a name; gives back zero when either is
     * missing.
     *
     * @mangled AssignData__9CSceneMapFP4CMapPc
     * @address 0x286940
     * @size 0x80
     */
    int AssignData(CMap *map, char *name);
};

STATIC_ASSERT(sizeof(CSceneMap) == 0x38);

/**
 * Slot in which a scene keeps one set of messages.
 */
class CSceneMessage : public CSceneData {
public:
    CSceneMessage() { Initialize(); }
    ClsMes *mes; /**< Messages kept in the slot. */

    /**
     * Empties the slot.
     *
     * @mangled Initialize__13CSceneMessageFv
     * @address 0x2869C0
     * @size 0x10
     */
    void Initialize();

    /**
     * Puts a set of messages in the slot under a name, which may be
     * missing; gives back zero when the messages are missing.
     *
     * @mangled AssignData__13CSceneMessageFP6ClsMesPc
     * @address 0x2869D0
     * @size 0x80
     */
    int AssignData(ClsMes *mes, char *name);
};

STATIC_ASSERT(sizeof(CSceneMessage) == 0x38);

/**
 * Slot in which a scene keeps one camera.
 */
class CSceneCamera : public CSceneData {
public:
    CSceneCamera() { Initialize(); }
    mgCCamera *camera; /**< Camera kept in the slot. */

    /**
     * Puts a camera in the slot under a name, which may be missing; gives
     * back zero when the camera is missing.
     *
     * @mangled AssignData__12CSceneCameraFP9mgCCameraPc
     * @address 0x286A50
     * @size 0x80
     */
    int AssignData(mgCCamera *camera, char *name);

    /**
     * Empties the slot.
     *
     * @mangled Initialize__12CSceneCameraFv
     * @address 0x286AD0
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CSceneCamera) == 0x38);

/**
 * Slot in which a scene keeps one sky.
 */
class CSceneSky : public CSceneData {
public:
    CSceneSky() { Initialize(); }
    CMapSky *sky; /**< Sky kept in the slot. */

    /**
     * Puts a sky in the slot under a name, which may be missing; gives
     * back zero when the sky is missing.
     *
     * @mangled AssignData__9CSceneSkyFP7CMapSkyPc
     * @address 0x286AE0
     * @size 0x80
     */
    int AssignData(CMapSky *sky, char *name);

    /**
     * Empties the slot.
     *
     * @mangled Initialize__9CSceneSkyFv
     * @address 0x286B60
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CSceneSky) == 0x38);

/**
 * Slot in which a scene keeps one game object, held as a character.
 */
class CSceneGameObj : public CSceneCharacter {
public:
    CSceneGameObj() { Initialize(); }
    /**
     * Empties the slot.
     *
     * @mangled Initialize__13CSceneGameObjFv
     * @address 0x286B70
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CSceneGameObj) == 0x40);

/**
 * Slot in which a scene keeps one effect script manager.
 */
class CSceneEffect : public CSceneData {
public:
    CSceneEffect() { Initialize(); }
    CEffectScriptMan *effect; /**< Effect script manager kept in the slot. */

    /**
     * Empties the slot.
     *
     * @mangled Initialize__12CSceneEffectFv
     * @address 0x286B80
     * @size 0x10
     */
    void Initialize();

    /**
     * Puts an effect script manager in the slot under a name, which may be
     * missing; gives back zero when the manager is missing.
     *
     * @mangled AssignData__12CSceneEffectFP16CEffectScriptManPc
     * @address 0x286B90
     * @size 0x80
     */
    int AssignData(CEffectScriptMan *effect, char *name);
};

STATIC_ASSERT(sizeof(CSceneEffect) == 0x38);
