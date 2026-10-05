#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the scripted particle effects: the particles, the emitters that spawn them, and the manager that runs one effect file.
 */

class mgC3DSprite;
class mgCTexture;

/**
 *
 * How a scripted value is randomised each time an emitter uses it, as the *_RAND effect script tags set it.
 *
 */
enum EFFECT_RAND_TYPE {
    EFFECT_RAND_NONE = 0,       /**< The value is used unchanged. */
    EFFECT_RAND_UNIFORMITY = 1, /**< A uniform random offset across the range is added (UniformityRand). */
    EFFECT_RAND_REGULARITY = 2, /**< An offset averaged from several random samples, weighted towards the centre, is added (RegularityRand). */
};

/**
 *
 * How a particle's position, scale or alpha changes over its life, as the MOVE_TYPE, SCALE_TYPE and ALPHA_TYPE effect script tags set it.
 *
 */
enum EFFECT_CHANGE_TYPE {
    EFFECT_CHANGE_NONE = 0,         /**< The value keeps its base. */
    EFFECT_CHANGE_ADD = 1,          /**< The value rises steadily through the whole life. */
    EFFECT_CHANGE_SUB = 2,          /**< The value falls steadily through the whole life. */
    EFFECT_CHANGE_ADD_HEAD = 3,     /**< The value rises over the first part of the life, then holds. */
    EFFECT_CHANGE_SUB_TAIL = 4,     /**< The value holds, then falls over the rest of the life. */
    EFFECT_CHANGE_ADD_HEAD_TAIL = 5, /**< The value rises over the start of the life, holds, and falls back over the end. */
    EFFECT_CHANGE_SINE = 6,         /**< The value swings about its base along a sine wave. */
};

/**
 *
 * How a particle's colour is blended into the frame, as the ALPHA_BLEND effect script tag sets it.
 *
 */
enum EFFECT_ALPHA_BLEND {
    EFFECT_ALPHA_BLEND_NONE = 0, /**< The particle replaces the frame where it passes the alpha test. */
    EFFECT_ALPHA_BLEND_ADD = 1,  /**< The particle is added to the frame, weighted by its alpha. */
    EFFECT_ALPHA_BLEND_SUB = 2,  /**< The particle is subtracted from the frame, weighted by its alpha. */
};

/**
 *
 * Everything that describes one particle when an emitter spawns it: its life, size, motion, scale, alpha and texture.
 *
 */
struct EffectTypeTriple {
    EFFECT_CHANGE_TYPE first;
    EFFECT_CHANGE_TYPE second;
    EFFECT_CHANGE_TYPE third;

    EffectTypeTriple() {}
    EffectTypeTriple(const EffectTypeTriple &other)
        : first(other.first), second(other.second), third(other.third) {}
};

struct EffectRect {
    int left;
    int top;
    int right;
    int bottom;
};

struct EFFECT_PARAM {
    int                life;             /**< Frames the particle lives for. */
    float              width;            /**< Unscaled width of the particle's sprite. */
    float              height;           /**< Unscaled height of the particle's sprite. */
    int                dir;              /**< Direction setting copied from the emitter's DIR tag. */
    sceVu0FVECTOR      pos;              /**< Current world position, before the move curves are applied. */
    sceVu0FVECTOR      velo;             /**< Velocity added to the position every frame. */
    sceVu0FVECTOR      acc;              /**< Acceleration added to the velocity every frame. */
    sceVu0FVECTOR      velo_mul;         /**< Per-axis factor the velocity is multiplied by every frame. */
    sceVu0FVECTOR      acc_mul;          /**< Per-axis factor the acceleration is multiplied by every frame. */
    EFFECT_CHANGE_TYPE move_type[3];     /**< Curve applied to each axis of the position over the life. */
    u_int                unk_6c;
    sceVu0FVECTOR      move_p1;          /**< Per-axis amount of the position curves. */
    sceVu0FVECTOR      move_p2;          /**< Per-axis timing of the position curves. */
    EFFECT_CHANGE_TYPE scale_type[3];    /**< Curve applied to the width and height scales over the life. */
    u_int                unk_9c;
    sceVu0FVECTOR      scale;            /**< Current width and height scale, before the scale curves are applied. */
    sceVu0FVECTOR      svelo;            /**< Scale added every frame. */
    sceVu0FVECTOR      scale_p1;         /**< Amount of the width and height scale curves. */
    sceVu0FVECTOR      scale_p2;         /**< Timing of the width and height scale curves. */
    EFFECT_ALPHA_BLEND alpha_blend;      /**< How the particle is blended into the frame. */
    EFFECT_CHANGE_TYPE alpha_type;       /**< Curve applied to the alpha over the life. */
    float              alpha;            /**< Base alpha, 0 to 1. */
    float              alpha_p1;         /**< Amount of the alpha curve. */
    float              alpha_p2;         /**< Timing of the alpha curve. */
    mgCTexture        *texture;          /**< Texture the particle is drawn with; a particle without one dies. */
    union {
        int tex_rect[8][4];
        EffectRect tex_rect_copy[8];
    };   /**< Texture rectangles (x, y, width, height) the particle shows, the first used alone when not animated. */
    int                tex_get_type;     /**< Zero to show the first rectangle only, otherwise to step through the rectangles over the life. */
    int                tex_frame;        /**< Frames each rectangle is shown for when the rectangles are stepped through. */
    int                gravity;          /**< Non-zero to pull the particle towards the gravity point. */
    u_int                unk_184;
    u_int                unk_188;
    u_int                unk_18c;
    sceVu0FVECTOR      gravity_pos;      /**< World position the particle is pulled towards. */
    float              gravity_accel;    /**< Strength of the pull, multiplied by gravity_mass and divided by the squared distance. */
    float              gravity_mass;     /**< Second factor of the pull's strength. */
    u_int                unk_1a8;
    u_int                unk_1ac;
};
STATIC_ASSERT(sizeof(EFFECT_PARAM) == 0x1B0);

/**
 *
 * Gives a particle description its defaults: no life, no motion, unit scale and multipliers, full alpha, and the standard gravity strength.
 *
 * @mangled InitEffectParam__FP12EFFECT_PARAM
 * @address 0x180B30
 * @size 0x150
 */
void InitEffectParam(EFFECT_PARAM *param);

/**
 *
 * One particle of an effect: its description and the position, scale, alpha and texture rectangle it is drawn with this frame.
 *
 */
class CEffect {
public:
    int           active;      /**< Non-zero while the slot holds a live particle. */
    int           frame;       /**< Frames the particle has lived. */
    float         alpha;       /**< Alpha the particle is drawn with, 0 to 1. */
    u_int           unk_0c;
    sceVu0FVECTOR pos;         /**< World position the particle is drawn at. */
    sceVu0FVECTOR scale;       /**< Width and height scale the particle is drawn with. */
    int           tex_rect[4]; /**< Texture rectangle (x, y, width, height) the particle is drawn with. */
    int           tex_count;   /**< Frames the current texture rectangle has been shown. */
    int           tex_index;   /**< Index of the texture rectangle being shown. */
    u_int           unk_48;
    u_int           unk_4c;
    EFFECT_PARAM  param;       /**< Description the particle was spawned with, moved on every frame. */

    /**
     *
     * Constructs an empty particle slot.
     *
     * @mangled __ct__7CEffectFv
     * @address 0x180C80
     * @size 0x30
     */
    CEffect();

    /**
     *
     * Empties the slot and gives its description the defaults.
     *
     * @mangled Initialize__7CEffectFv
     * @address 0x180CB0
     * @size 0x70
     */
    void Initialize();

    /**
     *
     * Spawns a particle in the slot from a description.
     *
     * @mangled SetEffect__7CEffectFP12EFFECT_PARAM
     * @address 0x180D20
     * @size 0x50
     */
    void SetEffect(EFFECT_PARAM *param);

    /**
     *
     * Moves the particle on by one frame: ages it, moves it, pulls it towards the gravity point, applies its curves and picks its texture rectangle.
     *
     * @mangled Step__7CEffectFi
     * @address 0x180D70
     * @size 0x7B0
     */
    void Step(int steps);

    /**
     *
     * Draws the particle as a camera-facing textured sprite.
     *
     * @mangled Draw__7CEffectFv
     * @address 0x181520
     * @size 0x1C0
     */
    void Draw();
};
STATIC_ASSERT(sizeof(CEffect) == 0x200);

/**
 *
 * One emitter of an effect, read from an EFFECT_START to EFFECT_END block of an effect script: spawns batches of particles, with optional repeats and randomised settings.
 *
 */
class CEffectCtrl {
public:
    sceVu0FVECTOR      origin;                 /**< World position the emitter's positions are relative to. */
    int                run;                    /**< Non-zero while the emitter is spawning. */
    int                entry;                  /**< Non-zero once the slot holds an emitter. */
    float              width;                  /**< Width of the particles spawned. */
    float              height;                 /**< Height of the particles spawned. */
    int                dir;                    /**< Direction setting given to the particles spawned. */
    int                num;                    /**< Particles spawned in each batch. */
    EFFECT_RAND_TYPE   num_rand_type;          /**< How the batch size is randomised. */
    float              num_rand;               /**< Range the batch size is randomised over. */
    int                num_rand_count;         /**< Samples averaged when the batch size is randomised by regularity. */
    int                count;                  /**< Life, in frames, of the particles spawned. */
    EFFECT_RAND_TYPE   cnt_rand_type;          /**< How the life is randomised. */
    float              cnt_rand;               /**< Range the life is randomised over. */
    int                cnt_rand_count;         /**< Samples averaged when the life is randomised by regularity. */
    int                repeat;                 /**< 1 to spawn further batches after the first. */
    int                repeat_wait;            /**< Base number of frames between batches. */
    int                repeat_wait_now;        /**< Frames between batches, as last randomised. */
    int                repeat_timer;           /**< Frames since the last batch. */
    EFFECT_RAND_TYPE   rep_rand_type;          /**< How the frames between batches are randomised. */
    float              rep_rand;               /**< Range the frames between batches are randomised over. */
    int                rep_rand_count;         /**< Samples averaged when the frames between batches are randomised by regularity. */
    int                repeat_num;             /**< Batches spawned before the emitter stops, or -1 to never stop. */
    int                repeat_cnt;             /**< Batches spawned so far. */
    sceVu0FVECTOR      pos;                    /**< Spawn position, relative to the origin. */
    EFFECT_RAND_TYPE   pos_rand_type;          /**< How the spawn position is randomised. */
    sceVu0FVECTOR      pos_rand;               /**< Per-axis range the spawn position is randomised over. */
    int                pos_rand_count;         /**< Samples averaged when the spawn position is randomised by regularity. */
    EffectTypeTriple move_type;           /**< Curve applied to each axis of the particles' position. */
    sceVu0FVECTOR      velo;                   /**< Velocity of the particles spawned. */
    sceVu0FVECTOR      acc;                    /**< Acceleration of the particles spawned. */
    sceVu0FVECTOR      velo_mul;               /**< Per-axis factor the particles' velocity is multiplied by every frame. */
    sceVu0FVECTOR      acc_mul;                /**< Per-axis factor the particles' acceleration is multiplied by every frame. */
    sceVu0FVECTOR      move_p1;                /**< Per-axis amount of the position curves. */
    sceVu0FVECTOR      move_p2;                /**< Per-axis timing of the position curves. */
    EFFECT_RAND_TYPE   velo_rand_type;         /**< How the velocity is randomised. */
    EFFECT_RAND_TYPE   acc_rand_type;          /**< How the acceleration is randomised. */
    EFFECT_RAND_TYPE   move_p1_rand_type;      /**< How the position curve amounts are randomised. */
    EFFECT_RAND_TYPE   move_p2_rand_type;      /**< How the position curve timings are randomised. */
    sceVu0FVECTOR      velo_rand;              /**< Per-axis range the velocity is randomised over. */
    sceVu0FVECTOR      acc_rand;               /**< Per-axis range the acceleration is randomised over. */
    sceVu0FVECTOR      move_p1_rand;           /**< Per-axis range the position curve amounts are randomised over. */
    sceVu0FVECTOR      move_p2_rand;           /**< Per-axis range the position curve timings are randomised over. */
    int                velo_rand_count;        /**< Samples averaged when the velocity is randomised by regularity. */
    int                acc_rand_count;         /**< Samples averaged when the acceleration is randomised by regularity. */
    int                move_p1_rand_count;     /**< Samples averaged when the position curve amounts are randomised by regularity. */
    int                move_p2_rand_count;     /**< Samples averaged when the position curve timings are randomised by regularity. */
    EffectTypeTriple scale_type;          /**< Curve applied to the particles' width and height scales. */
    sceVu0FVECTOR      scale;                  /**< Width and height scale of the particles spawned. */
    sceVu0FVECTOR      svelo;                  /**< Scale added to the particles every frame. */
    sceVu0FVECTOR      scale_p1;               /**< Amount of the scale curves. */
    sceVu0FVECTOR      scale_p2;               /**< Timing of the scale curves. */
    EFFECT_RAND_TYPE   scale_rand_type;        /**< How the scale is randomised. */
    EFFECT_RAND_TYPE   svelo_rand_type;        /**< How the scale velocity is randomised. */
    EFFECT_RAND_TYPE   scale_p1_rand_type;     /**< How the scale curve amounts are randomised. */
    EFFECT_RAND_TYPE   scale_p2_rand_type;     /**< How the scale curve timings are randomised. */
    sceVu0FVECTOR      scale_rand;             /**< Range the scale is randomised over. */
    sceVu0FVECTOR      svelo_rand;             /**< Range the scale velocity is randomised over. */
    sceVu0FVECTOR      scale_p1_rand;          /**< Range the scale curve amounts are randomised over. */
    sceVu0FVECTOR      scale_p2_rand;          /**< Range the scale curve timings are randomised over. */
    int                scale_rand_count;       /**< Samples averaged when the scale is randomised by regularity. */
    int                svelo_rand_count;       /**< Samples averaged when the scale velocity is randomised by regularity. */
    int                scale_p1_rand_count;    /**< Samples averaged when the scale curve amounts are randomised by regularity. */
    int                scale_p2_rand_count;    /**< Samples averaged when the scale curve timings are randomised by regularity. */
    EFFECT_ALPHA_BLEND alpha_blend;            /**< How the particles are blended into the frame. */
    EFFECT_CHANGE_TYPE alpha_type;             /**< Curve applied to the particles' alpha. */
    float              alpha;                  /**< Base alpha of the particles, 0 to 1. */
    float              alpha_p1;               /**< Amount of the alpha curve. */
    float              alpha_p2;               /**< Timing of the alpha curve. */
    EFFECT_RAND_TYPE   alpha_rand_type;        /**< How the alpha is randomised. */
    EFFECT_RAND_TYPE   alpha_p1_rand_type;     /**< How the alpha curve amount is randomised. */
    EFFECT_RAND_TYPE   alpha_p2_rand_type;     /**< How the alpha curve timing is randomised. */
    float              alpha_rand;             /**< Range the alpha is randomised over. */
    float              alpha_p1_rand;          /**< Range the alpha curve amount is randomised over. */
    float              alpha_p2_rand;          /**< Range the alpha curve timing is randomised over. */
    int                alpha_rand_count;       /**< Samples averaged when the alpha is randomised by regularity. */
    int                alpha_p1_rand_count;    /**< Samples averaged when the alpha curve amount is randomised by regularity. */
    int                alpha_p2_rand_count;    /**< Samples averaged when the alpha curve timing is randomised by regularity. */
    int                tex_rect_num;           /**< Texture rectangles in use. */
    union {
        int tex_rect[8][4];
        EffectRect tex_rect_copy[8];
    };         /**< Texture rectangles (x, y, width, height) the particles show. */
    mgCTexture        *texture;                /**< Texture the particles are drawn with. */
    int                tex_get_type;           /**< Zero to give each particle one random rectangle, otherwise to step every particle through all of them over its life. */
    int                gravity;                /**< Non-zero to pull the particles towards the gravity point. */
    sceVu0FVECTOR      gravity_pos;            /**< Point the particles are pulled towards, relative to the origin. */
    float              gravity_accel;          /**< Strength of the pull, multiplied by gravity_mass and divided by the squared distance. */
    float              gravity_mass;           /**< Second factor of the pull's strength. */

    /**
     *
     * Constructs an emitter with the default settings.
     *
     * @mangled __ct__11CEffectCtrlFv
     * @address 0x1816E0
     * @size 0x30
     */
    CEffectCtrl();

    /**
     *
     * Destroys an emitter.
     *
     * @mangled __dt__11CEffectCtrlFv
     * @address 0x181710
     * @size 0x50
     */
    ~CEffectCtrl();

    /**
     *
     * Runs the emitter for one frame, spawning a batch into free particle slots when one is due.
     *
     * @mangled Ctrl__11CEffectCtrlFP7CEffecti
     * @address 0x181760
     * @size 0xCB0
     */
    void Ctrl(CEffect *effects, int effect_num);

    /**
     *
     * Gives the emitter its default settings and leaves it stopped and empty.
     *
     * @mangled Initialize__11CEffectCtrlFv
     * @address 0x182410
     * @size 0x2B0
     */
    void Initialize();

    /**
     *
     * Starts the emitter, restarting its repeats.
     *
     * @mangled Run__11CEffectCtrlFv
     * @address 0x1826C0
     * @size 0x20
     */
    void Run();

    /**
     *
     * Moves the world position the emitter's positions are relative to.
     *
     * @mangled SetOrigin__11CEffectCtrlFPf
     * @address 0x1826E0
     * @size 0x10
     */
    void SetOrigin(float *origin);

    /**
     *
     * Copies every setting of another emitter.
     *
     * @mangled __as__11CEffectCtrlFRC11CEffectCtrl
     * @address 0x1826F0
     * @size 0x350
     */
    CEffectCtrl &operator=(const CEffectCtrl &other);
};
STATIC_ASSERT(sizeof(CEffectCtrl) == 0x310);

/**
 *
 * One effect, read from an effect script: its emitters, the particle pool they share, and the timing that starts the emitters one after another.
 *
 */
class CEffectManager {
public:
    char         name[32];         /**< Name the effect is looked up by. */
    CEffect     *effects;          /**< Particle pool. */
    int          effect_num;       /**< Particles in the pool. */
    CEffectCtrl *ctrls;            /**< Emitters. */
    int          ctrl_num;         /**< Emitters available. */
    int          load;             /**< Non-zero once the effect script has been read. */
    int          ctrl_index;       /**< Single emitter to start, or -1 to start the emitters one after another. */
    int          run;              /**< Non-zero while the effect is playing. */
    int          wait_count;       /**< Frames since the last emitter was started. */
    int          next_ctrl;        /**< Next emitter to start. */
    int          wait_frame[8];    /**< Frames to wait before starting each emitter, from the WAIT_FRAME tag. */
    char         ctrl_name[8][32]; /**< Name of each emitter, from its EFFECT_START tag. */
    char         img_name[32];     /**< Texture archive the effect needs, from the IMG_NAME tag. */

    /**
     *
     * Constructs an effect with no particle pool and no emitters.
     *
     * @mangled __ct__14CEffectManagerFv
     * @address 0x184030
     * @size 0x50
     */
    CEffectManager();

    /**
     *
     * Stops the effect, clears its timings and names, and gives every emitter its defaults.
     *
     * @mangled Initialize__14CEffectManagerFv
     * @address 0x184080
     * @size 0xD0
     */
    void Initialize();

    /**
     *
     * Gives the effect its particle pool and its emitters.
     *
     * @mangled EntryEffCtrls__14CEffectManagerFP7CEffectiP11CEffectCtrli
     * @address 0x184150
     * @size 0x20
     */
    void EntryEffCtrls(CEffect *effects, int effect_num, CEffectCtrl *ctrls, int ctrl_num);

    /**
     *
     * Sets how many particles and emitters the effect has, as the BUFFER_SIZE tag gives them.
     *
     * @mangled SetEffectNums__14CEffectManagerFii
     * @address 0x184170
     * @size 0x10
     */
    void SetEffectNums(int effect_num, int ctrl_num);

    /**
     *
     * Starts the emitters whose wait has passed.
     *
     * @mangled Ctrl__14CEffectManagerFv
     * @address 0x184180
     * @size 0x120
     */
    void Ctrl();

    /**
     *
     * Runs every emitter for one frame and moves every particle on by one frame.
     *
     * @mangled Step__14CEffectManagerFi
     * @address 0x1842A0
     * @size 0xD0
     */
    void Step(int steps);

    /**
     *
     * Draws every particle one by one.
     *
     * @mangled Draw__14CEffectManagerFv
     * @address 0x184370
     * @size 0x70
     */
    void Draw();

    /**
     *
     * Starts playing the effect from its first emitter.
     *
     * @mangled Run__14CEffectManagerFv
     * @address 0x1843E0
     * @size 0x40
     */
    void Run();

    /**
     *
     * Stops the effect and every emitter; live particles play out.
     *
     * @mangled Stop__14CEffectManagerFv
     * @address 0x184420
     * @size 0x60
     */
    void Stop();

    /**
     *
     * Copies an emitter into the first empty emitter slot under a name; gives 0 on success and 1 when every slot is taken.
     *
     * @mangled EnterEffectCtrl__14CEffectManagerF11CEffectCtrlPc
     * @address 0x184480
     * @size 0xD0
     */
    int EnterEffectCtrl(CEffectCtrl ctrl, char *name);

    /**
     *
     * Reads an effect script for its BUFFER_SIZE only, giving the particles and emitters it needs.
     *
     * @mangled GetBufferNums__14CEffectManagerFPciPiPi
     * @address 0x184550
     * @size 0xA0
     */
    void GetBufferNums(char *script, int size, int *effect_num, int *ctrl_num);

    /**
     *
     * Reads an effect script, entering each of its emitters.
     *
     * @mangled Load__14CEffectManagerFPci
     * @address 0x1845F0
     * @size 0x80
     */
    void Load(char *script, int size);

    /**
     *
     * Moves the world position of every emitter in use.
     *
     * @mangled SetOrigin__14CEffectManagerFPf
     * @address 0x184670
     * @size 0x80
     */
    void SetOrigin(float *origin);

    /**
     *
     * Builds the draw packet of every live particle into a 3D sprite, grouped by texture and blend.
     *
     * @mangled CreatePacket__14CEffectManagerFP11mgC3DSprite
     * @address 0x17E850
     * @size 0x340
     */
    void CreatePacket(mgC3DSprite *sprite);
};
STATIC_ASSERT(sizeof(CEffectManager) == 0x184);
