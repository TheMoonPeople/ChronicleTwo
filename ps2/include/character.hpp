#pragma once

#include "common.h"

#include <libvu0.h>

#include "effect.hpp"
#include "gameutil.hpp"
#include "object.hpp"

/**
 * @file
 * Declares the character that a character info file builds: its model, shadow, motions, motion
 * sequences, sounds, effects, cloth and levels of detail.
 */

class CDynamicAnime;
class CEffectManager;
class CLoopSeMngr;
class COutLineDraw;
class CSWordAfterEffect;
class mgCFrame;
class mgCMemory;
struct mgIMG_FILE_HEADER;

/** Number of motion sets that one character can hold. */
#define CHARA_MOTION_SET_MAX 8
/** Number of frames that the character can name as places to put objects. */
#define CHARA_ENTRY_OBJECT_MAX 24
/** Number of frames that the character can name as its main object positions. */
#define CHARA_ENTRY_FRAME_MAX 2
/** Number of IMG archives that one character can load. */
#define CHARA_IMAGE_MAX 6
/** Number of frames whose skin the character deforms. */
#define CHARA_DEFORM_FRAME_MAX 24
/** Number of sword trails that one character can draw. */
#define CHARA_SWORD_EFFECT_MAX 3
/** Number of effects that one motion can start. */
#define CHARA_ENTRY_EFFECT_MAX 8

/**
 *
 * Playback flags of a motion, as CCharacter2::SetMotion takes them.
 *
 */
// clang-format off
enum CharaMotionFlag {
    CHARA_MOTION_PAUSE   = 1 << 0, /**< Holds the motion on its current frame. */
    CHARA_MOTION_HOLD    = 1 << 1, /**< Stops the motion on its last frame instead of looping. */
    CHARA_MOTION_RESTART = 1 << 2, /**< Starts the motion from its first frame without blending. */
};

// clang-format on

/**
 *
 * States of the motion that a character plays, as CCharacter2::GetMotionStatus gives them.
 *
 */
// clang-format off
enum CharaMotionStatus {
    CHARA_MOTION_STATUS_NONE  = 0, /**< No motion has been set. */
    CHARA_MOTION_STATUS_START = 1, /**< The motion stands on its first frame. */
    CHARA_MOTION_STATUS_PLAY  = 2, /**< The motion advances. */
    CHARA_MOTION_STATUS_BLEND = 3, /**< The character blends from the previous motion into this one. */
    CHARA_MOTION_STATUS_END   = 4, /**< The motion reached its last frame. */
};

// clang-format on

/**
 *
 * States of a motion sequence that a character plays.
 *
 */
// clang-format off
enum CharaSeqState {
    CHARA_SEQ_STATE_NONE  = 0, /**< No sequence plays. */
    CHARA_SEQ_STATE_START = 1, /**< The sequence started its first step. */
    CHARA_SEQ_STATE_PLAY  = 2, /**< A step of the sequence plays. */
    CHARA_SEQ_STATE_WAIT  = 3, /**< A step waits for the request to move on. */
    CHARA_SEQ_STATE_END   = 4, /**< The sequence finished its last step. */
};

// clang-format on

/**
 *
 * How one step of a motion sequence ends, as CHRINFO_SEQ::type holds it.
 *
 */
// clang-format off
enum ChrInfoSeqType {
    CHRINFO_SEQ_ONCE      = 0, /**< Plays the motion once, holding its last frame. */
    CHRINFO_SEQ_LOOP      = 1, /**< Plays the motion the number of times that CHRINFO_SEQ::loop_count gives. */
    CHRINFO_SEQ_HOLD_WAIT = 2, /**< Plays the motion once, holding its last frame, then waits for the request to move on. */
    CHRINFO_SEQ_WAIT      = 3, /**< Loops the motion until the request to move on. */
    CHRINFO_SEQ_LOOP_WAIT = 7, /**< Loops the motion, moving on at its end once the request to move on is made. */
};

// clang-format on

/**
 *
 * What a sound entry of a motion plays, as CHRINFO_SE::kind holds it.
 *
 */
// clang-format off
enum ChrInfoSeKind {
    CHRINFO_SE_FOOT_0      = 0, /**< First footstep sound of the ground's footstep set. */
    CHRINFO_SE_FOOT_1      = 1, /**< Second footstep sound of the ground's footstep set. */
    CHRINFO_SE_SOUND       = 2, /**< Sound from the character's sound bank. */
    CHRINFO_SE_SOUND_2     = 3, /**< Sound from the character's second sound bank. */
    CHRINFO_SE_SOUND_FOOT  = 4, /**< Sound from the character's sound bank that also starts a foot effect. */
};

// clang-format on

/**
 *
 * Flags of CCharacter2::dynamic_anime_flags.
 *
 */
// clang-format off
enum CharaDynamicAnimeFlag {
    CHARA_DYNAMIC_ANIME_DISABLE = 1 << 0, /**< The cloth and hair animations do not step. */
};

// clang-format on

/**
 *
 * Names one motion of a character and the frames of its motion data that it plays.
 *
 */
struct CHRINFO_KEY_SET {
    char  name[0x24];  /**< Name that the motion is set by; empty in the entry that ends the list. */
    s32   start_frame; /**< First frame of the motion. */
    s32   end_frame;   /**< Last frame of the motion. */
    float step;        /**< Frames that the motion advances each step. */
};

STATIC_ASSERT(sizeof(CHRINFO_KEY_SET) == 0x30);

/**
 *
 * One step of a motion sequence: the motion it plays and how it ends.
 *
 */
struct CHRINFO_SEQ {
    char  name[0x22]; /**< Name of the motion that the step plays; empty in the entry that ends the sequence. */
    u8    type;       /**< How the step ends. @see ChrInfoSeqType. */
    u8    unk_23;
    s32   loop_count;  /**< Number of times that a looping step plays its motion. */
    float blend_speed; /**< Blend weight gained each step while blending into the motion; -1.0 for the default. */
};

STATIC_ASSERT(sizeof(CHRINFO_SEQ) == 0x2C);

/**
 *
 * Names one motion sequence of a character and heads its steps.
 *
 */
struct CHRINFO_SEQ_HEADER {
    char                name[0x24]; /**< Name that the sequence is set by. */
    CHRINFO_SEQ        *seq;        /**< Steps of the sequence. */
    CHRINFO_SEQ_HEADER *next;       /**< Next sequence of the same motion set, or NULL. */
    s32                 seq_num;    /**< Number of steps, counting the one that ends the sequence. */
};

STATIC_ASSERT(sizeof(CHRINFO_SEQ_HEADER) == 0x30);

/**
 *
 * One sound that a motion plays on a frame, or loops over a range of frames.
 *
 */
struct CHRINFO_SE {
    float frame;     /**< Frame that plays the sound, or the first frame that a looping sound plays on. */
    float end_frame; /**< Last frame that a looping sound plays on; 0.0 for a sound played once. */
    s16   loop_slot; /**< Loop slot of the loop sound manager; zero or below for a sound played once. */
    s16   kind;      /**< What the entry plays. @see ChrInfoSeKind. */
    s16   se_no;     /**< Sound number in the bank. */
    s16   wait;      /**< Steps before the entry may play again. */
};

STATIC_ASSERT(sizeof(CHRINFO_SE) == 0x10);

/**
 *
 * Effect playback data with the character frame and motion that attach it to the model.
 *
 */
struct CHARA_EFFECT_MANAGER : public CEffectManager {
    CEffectCtrl  *emitter_pool; /**< Emitter pool allocated with the character. */
    u32           unk_188;
    CEffect      *particle_pool; /**< Particle pool allocated with the character. */
    u32           unk_190;
    u32           unk_194;
    s32           local_draw;      /**< Nonzero to transform the effect sprite packet by its attachment matrix. */
    char          frame_name[32];  /**< Model frame the effect follows; empty for the origin. */
    char          motion_name[32]; /**< Motion that starts the effect. */
    float         start_ratio;     /**< Part of the motion after which the effect starts. */
    sceVu0FVECTOR offset;          /**< Position relative to the attachment frame. */
};

STATIC_ASSERT(sizeof(CHARA_EFFECT_MANAGER) == 0x1F0);

/**
 *
 * One effect that a character's info file loads, with the motion that starts it.
 *
 */
struct CHRINFO_EFFECT {
    char                  name[0x20]; /**< Name of the effect. */
    CHARA_EFFECT_MANAGER *effect;     /**< Effect that plays. */
    CHRINFO_EFFECT       *next;       /**< Next effect of the character, or NULL. */
};

STATIC_ASSERT(sizeof(CHRINFO_EFFECT) == 0x28);

/**
 *
 * One IMG archive that an effect of a character entered, kept so that it is entered once.
 *
 */
struct CHRINFO_EFFECT_IMAGE {
    u8                   *data;       /**< Copy of the archive. */
    char                  name[0x20]; /**< Name of the archive in the effect pack. */
    CHRINFO_EFFECT_IMAGE *next;       /**< Next archive, or NULL. */
};

STATIC_ASSERT(sizeof(CHRINFO_EFFECT_IMAGE) == 0x28);

/**
 *
 * A frame of the character's model named as a place to put objects.
 *
 */
struct CHARA_ENTRY_OBJECT {
    mgCFrame *frame; /**< Frame of the model; NULL for a free slot. */
    float     size; /**< Size used when checking a frame against a character entry. */
    s32       group;  /**< Group that the frame belongs to; -1 for a free slot. */
    s32       enable; /**< Nonzero while the slot is in use. */
};

STATIC_ASSERT(sizeof(CHARA_ENTRY_OBJECT) == 0x10);

/**
 *
 * An effect that the motion playing started, with whether it runs yet.
 *
 */
struct CHARA_ENTRY_EFFECT {
    CHARA_EFFECT_MANAGER *effect;  /**< Effect to run. */
    s32                   active;  /**< Nonzero while the slot holds an effect of the motion. */
    s32                   running; /**< Nonzero once the motion reached the point that runs the effect. */
};

STATIC_ASSERT(sizeof(CHARA_ENTRY_EFFECT) == 0xC);

/**
 *
 * Index of each frame of one model that matches a frame of another model,
 * pairing the frames that are posed together.
 *
 */
class CCharaFrameMatching {
public:
    s32  num;       /**< Number of entries in src_frame and dst_frame. */
    s32 *src_frame; /**< Index of each frame of the first model. */
    s32 *dst_frame; /**< Index of the frame of the second model that matches each entry of src_frame. */

    /**
     *
     * Empties the matching.
     *
     * @mangled Initialize__19CCharaFrameMatchingFv
     * @address 0x1FF8A0
     * @size 0x10
     */
    void Initialize() {
        num = 0;
        dst_frame = 0;
        src_frame = 0;
    }
};

STATIC_ASSERT(sizeof(CCharaFrameMatching) == 0xC);

/**
 *
 * Sound banks and playback settings attached to a character.
 *
 */
struct CHARA_SOUND_INFO {
    u32          foot_se_bank;      /**< Sound bank of the footstep sounds. */
    s32          foot_sound_id;     /**< Footstep set of the ground; below zero for none. */
    s32          foot_sound_enable; /**< Nonzero while the feet play sounds. */
    u32          se_bank;           /**< Sound bank of the character's sounds. */
    u32          se_bank_2;         /**< Second sound bank of the character's sounds. */
    s32          se_positional;     /**< Nonzero to take the volume and pan of the sounds from the character's position. */
    float        se_volume;         /**< Volume that the sounds play at. */
    float        se_pan;            /**< Pan that the sounds play at. */
    s32          foot_effect_wait;  /**< Steps left in which a foot touched the ground. */
    CLoopSeMngr *loop_se;           /**< Manager of the sounds that loop over a range of frames. */
};

STATIC_ASSERT(sizeof(CHARA_SOUND_INFO) == 0x28);

/**
 *
 * One level of detail of a character: the model drawn beyond a distance.
 *
 */
class CCharaLOD {
public:
    float     distance;   /**< Camera distance beyond which the level is drawn. */
    s32       motion;     /**< Nonzero when the character's motion plays while the level is drawn. */
    s32       standalone; /**< Nonzero when the level is a model of its own rather than visuals swapped into the main model. */
    mgCFrame *frame;      /**< Model of the level. */
    s32       link_num;   /**< Number of entries in link. */
    s32 (*link)[2];       /**< Pairs of frame indices: the frame of the main model, then the frame of this level that gives it its visual. */

    /**
     *
     * Makes an empty level of detail.
     *
     * @mangled __ct__9CCharaLODFv
     * @address 0x179B10
     * @size 0x20
     */
    CCharaLOD();
};

STATIC_ASSERT(sizeof(CCharaLOD) == 0x18);

/**
 *
 * A character of the world: a skinned model with motions, a shadow model, motion sequences,
 * motion sounds and effects, cloth and hair, outlines and levels of detail.
 *
 */
class CCharacter2 : public CObjectFrame {
public:
    sceVu0FVECTOR velocity;        /**< Distance that the character moves each step. */
    sceVu0FVECTOR base_scale;      /**< Scale that the info file gives the model. */
    float         move_accel;      /**< Acceleration accumulated while the character moves. */
    sceVu0FMATRIX entry_matrix;    /**< Matrix of the first entry frame as of the last step, used to reset the cloth after a jump. */
    char          name[0x10];      /**< Name that scripts find the character by. */
    float         alpha;           /**< Alpha that the character draws with. */
    s32           poly_num;        /**< Polygon count of the model that the info file gives. */
    s32           shadow_poly_num; /**< Polygon count of the shadow that the info file gives. */
    float         body_width;      /**< Width of the body. */
    float         body_height;     /**< Height of the body, used for framing and scaling. */

    float                 body_depth;                           /**< Depth of the body. */
    s32                   load_size;                            /**< Quadwords of the model memory that loading the character took. */
    s32                   copy_size;                            /**< Quadwords that a copy of the character takes; zero or below to take load_size. */
    s16                   dynamic_anime_flags;                  /**< Flags of the cloth and hair animations. @see CharaDynamicAnimeFlag. */
    COutLineDraw         *outline;                              /**< Outlines drawn around the character, linked through COutLineDraw::next. */
    s32                   outline_tex_no;                       /**< Number of the screen texture that the outlines draw into. */
    s32                   dynamic_anime_num;                    /**< Number of entries in dynamic_anime. */
    CDynamicAnime        *dynamic_anime;                        /**< Cloth and hair animations of the character. */
    s32                   shape_anime;                          /**< Nonzero when the skin deforms by shape animation. */
    mgCFrame             *entry_frame[CHARA_ENTRY_FRAME_MAX];   /**< Frames named as the character's main object positions. */
    CHARA_ENTRY_OBJECT    entry_object[CHARA_ENTRY_OBJECT_MAX]; /**< Frames named as places to put objects. */
    mgCFrame             *shadow_frame;                         /**< Shadow model; NULL when the character has none. */
    mgIMG_FILE_HEADER    *images[CHARA_IMAGE_MAX];              /**< IMG archives that the character entered; the first is its own, the rest come from extension packs. */
    s32                   tex_anime_group_num;                  /**< Number of texture animation groups in the character's texture block. */
    s32                   tex_anime_group_start;                /**< First texture animation group of the character's own archive. */
    s32                   texture_block;                        /**< Texture block that the character's textures are entered in. */
    mgCFrame             *deform_frame[CHARA_DEFORM_FRAME_MAX]; /**< Frames of the model whose skin deforms. */
    s32                   deform_frame_num;                     /**< Number of entries in deform_frame. */
    s32                   lod_num;                              /**< Number of entries in lod. */
    CCharaLOD            *lod;                                  /**< Levels of detail of the character. */
    s32                   lod_no;                               /**< Level of detail drawn; below zero before the first change. */
    s32                   motion_enable;                        /**< Nonzero while the character's motion plays. */
    CCharaFrameMatching   shadow_link;                          /**< Frames of the model that pose the frames of the shadow. */
    CHRINFO_KEY_SET      *next_key;                             /**< Motion set to play from the next step. */
    s32                   next_flags;                           /**< Playback flags of next_key. @see CharaMotionFlag. */
    s32                   next_set;                             /**< Motion set of next_key. */
    CHRINFO_KEY_SET      *now_key;                              /**< Motion that plays. */
    s32                   seq_mode;                             /**< Nonzero while a motion sequence drives the motion. */
    s32                   now_flags;                            /**< Playback flags of now_key. @see CharaMotionFlag. */
    s32                   now_set;                              /**< Motion set of now_key. */
    s32                   motion_status;                        /**< State of the motion. @see CharaMotionStatus. */
    float                 frame;                                /**< Frame of the motion that plays. */
    float                 frame_ratio;                          /**< Part of the motion played, from 0.0 to 1.0. */
    float                 step;                                 /**< Frames that the motion advances each step. */
    CHRINFO_KEY_SET      *posed_key;                            /**< Motion that the model is posed by; differs from now_key while blending. */
    s32                   prev_flags;                           /**< Playback flags of the previous motion. */
    s32                   prev_set;                             /**< Motion set of the previous motion. */
    float                 prev_frame;                           /**< Frame that the previous motion stood on. */
    CHRINFO_SEQ_HEADER   *next_seq;                             /**< Motion sequence to play from the next step. */
    CHRINFO_SEQ_HEADER   *now_seq;                              /**< Motion sequence that plays. */
    CHRINFO_SEQ          *seq_step;                             /**< Step of the motion sequence that plays. */
    s32                   seq_flags;                            /**< Playback flags given to every step of the sequence. @see CharaMotionFlag. */
    s32                   seq_loop;                             /**< Plays left of a looping step. */
    s32                   seq_state;                            /**< State of the motion sequence. @see CharaSeqState. */
    s32                   seq_advance;                          /**< Nonzero to let a waiting step move on. */
    tagMOTION_TYPE        motion[CHARA_MOTION_SET_MAX];         /**< Motion data of each motion set of the model. */
    tagMOTION_TYPE        shadow_motion[CHARA_MOTION_SET_MAX];  /**< Motion data of each motion set of the shadow. */
    tagFRAME_INF         *main_frame_info;                      /**< Frame information used by the character's main model. */
    tagFRAME_INF         *shadow_frame_info;                    /**< Skinning data that every motion set of the shadow shares. */
    float                 blend;                                /**< Weight of the motion that plays against the previous one while blending. */
    float                 blend_speed;                          /**< Weight that blend gains each step. */
    CHRINFO_KEY_SET      *key_list[CHARA_MOTION_SET_MAX];       /**< Motions of each motion set. */
    s32                   key_num[CHARA_MOTION_SET_MAX];        /**< Number of motions of each motion set, counting the one that ends the list. */
    CHRINFO_SEQ_HEADER   *seq_list[CHARA_MOTION_SET_MAX];       /**< Motion sequences of each motion set. */
    CSWordAfterEffect    *sword_effect[CHARA_SWORD_EFFECT_MAX]; /**< Sword trails that the character draws. */
    CHARA_SOUND_INFO      sound_info;                           /**< Sound banks and settings that linked characters share. */
    CHRINFO_SE           *se_list[CHARA_MOTION_SET_MAX];        /**< Motion sounds of each motion set. */
    s32                   se_num[CHARA_MOTION_SET_MAX];         /**< Number of entries of each se_list. */
    s32                   effect_image_load;                    /**< Nonzero to enter the IMG archives that the effects name. */
    CHRINFO_EFFECT       *effect_list;                          /**< Effects that the info file loaded. */
    CHARA_ENTRY_EFFECT    entry_effect[CHARA_ENTRY_EFFECT_MAX]; /**< Effects that the motion playing starts. */
    CHRINFO_EFFECT_IMAGE *effect_image_list;                    /**< IMG archives that the effects entered. */
    s32                   effect_enable;                        /**< Nonzero while motions start their effects. */

    float GetBodyWidth() {
        return body_width;
    }

    float GetBodyHeight() {
        return body_height;
    }

    /**
     *
     * Makes a character with no model and no motion.
     *
     * @mangled __ct__11CCharacter2Fv
     * @address 0x1C6C80
     * @size 0xA0
     */
    CCharacter2() {
        shadow_link.Initialize();
        Initialize();
    }

    /**
     *
     * Moves the character to a position, marking its transform changed when it moves.
     *
     * @mangled SetPosition__11CCharacter2FPf
     * @address 0x1741F0
     * @size 0x10
     */
    virtual void SetPosition(float *position);

    /**
     *
     * Moves the character to a position given as three coordinates.
     *
     * @mangled SetPosition__11CCharacter2Ffff
     * @address 0x1698E0
     * @size 0x50
     */
    virtual void SetPosition(float x, float y, float z);

    /**
     *
     * Draws the model and the cloth through the drawing list when the character is to be drawn.
     *
     * @mangled Draw__11CCharacter2Fv
     * @address 0x174370
     * @size 0x150
     */
    virtual int Draw();

    /**
     *
     * Draws the level of detail for the camera distance, its outlines and the cloth straight away.
     *
     * @mangled DrawDirect__11CCharacter2Fv
     * @address 0x174600
     * @size 0x420
     */
    virtual int DrawDirect();

    /**
     *
     * Puts the character back to its initial state, with no model, motion, sound or effect.
     *
     * @mangled Initialize__11CCharacter2Fv
     * @address 0x176780
     * @size 0x2E0
     */
    virtual void Initialize();

    /**
     *
     * Gets the distance from the camera to the line from the character's feet to its head.
     *
     * @mangled GetCameraDist__11CCharacter2Fv
     * @address 0x174580
     * @size 0x80
     */
    virtual float GetCameraDist();

    /**
     *
     * Works out whether the character is within its drawing distance.
     *
     * @mangled DrawStep__11CCharacter2Fv
     * @address 0x174530
     * @size 0x50
     */
    virtual void DrawStep();

    /**
     *
     * Loads the character from its info file in a pack, with its outlines.
     *
     * @mangled LoadPack__11CCharacter2FPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryiP11CCharacter2
     * @address 0x176610
     * @size 0x30
     */
    virtual void LoadPack(unsigned int *pack, char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, CCharacter2 *parent);

    /**
     *
     * Loads the character from its info file in a pack, without its outlines.
     *
     * @mangled LoadPackNoLine__11CCharacter2FPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryiP11CCharacter2
     * @address 0x176640
     * @size 0x30
     */
    virtual void LoadPackNoLine(unsigned int *pack, char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, CCharacter2 *parent);

    /**
     *
     * Runs the character's info file from a pack and, for a character with no motion yet, sets its first motion.
     *
     * @mangled LoadChrFile__11CCharacter2FPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryiP11CCharacter2i
     * @address 0x176670
     * @size 0x110
     */
    virtual void LoadChrFile(unsigned int *pack, char *name, mgCMemory *a, mgCMemory *b, mgCMemory *c, int d, CCharacter2 *e, int with_line);

    /**
     *
     * Gets the state of the motion.
     *
     * @mangled GetMotionStatus__11CCharacter2Fv
     * @address 0x169820
     * @size 0x10
     */
    virtual int GetMotionStatus() {
        return motion_status;
    }

    /**
     *
     * Gets the name of the motion that plays, or NULL for none.
     *
     * @mangled GetNowMotionName__11CCharacter2Fv
     * @address 0x169830
     * @size 0x20
     */
    virtual char *GetNowMotionName() {
        if (now_key != NULL) {
            return now_key->name;
        }

        return NULL;
    }

    /**
     *
     * Tells whether the motion reaches its last frame within the next two steps, or no motion plays.
     *
     * @mangled CheckMotionEnd__11CCharacter2Fv
     * @address 0x174CD0
     * @size 0x80
     */
    virtual int CheckMotionEnd();

    /**
     *
     * Gets the part of the motion played, from 0.0 to 1.0.
     *
     * @mangled GetNowFrameWait__11CCharacter2Fv
     * @address 0x169850
     * @size 0x10
     */
    virtual float GetNowFrameWait() {
        return frame_ratio;
    }

    /**
     *
     * Gets the blend weight while blending into the motion, or -1.0 otherwise.
     *
     * @mangled GetChgStepWait__11CCharacter2Fv
     * @address 0x174CA0
     * @size 0x30
     */
    virtual float GetChgStepWait();

    /**
     *
     * Sets the frame of the motion that plays.
     *
     * @mangled SetNowFrame__11CCharacter2Ff
     * @address 0x169860
     * @size 0x10
     */
    virtual void SetNowFrame(float now_frame) {
        frame = now_frame;
    }

    /**
     *
     * Sets the frame of the motion that plays as a part of the motion, from 0.0 to 1.0.
     *
     * @mangled SetNowFrameWeight__11CCharacter2Ff
     * @address 0x174DD0
     * @size 0x90
     */
    virtual void SetNowFrameWeight(float weight);

    /**
     *
     * Gets the frame of the motion that plays.
     *
     * @mangled GetNowFrame__11CCharacter2Fv
     * @address 0x169870
     * @size 0x10
     */
    virtual float GetNowFrame() {
        return frame;
    }

    /**
     *
     * Gets the frame that lies a part of the way through a motion of the character being loaded.
     *
     * @mangled GetWaitToFrame__11CCharacter2FPcf
     * @address 0x1765A0
     * @size 0x60
     */
    virtual float GetWaitToFrame(char *name, float wait);

    /**
     *
     * Sets the motion to play from the next step by its number across every motion set.
     *
     * @mangled SetMotion__11CCharacter2Fii
     * @address 0x174D50
     * @size 0x70
     */
    virtual void SetMotion(int no, int flags);

    /**
     *
     * Sets the motion or motion sequence to play from the next step by its name.
     *
     * @mangled SetMotion__11CCharacter2FPci
     * @address 0x174DC0
     * @size 0x10
     */
    virtual void SetMotion(char *name, int flags);

    /**
     *
     * Stops the motion and the motion sequence.
     *
     * @mangled ResetMotion__11CCharacter2Fv
     * @address 0x174C80
     * @size 0x20
     */
    virtual void ResetMotion();

    /**
     *
     * Sets the frames that the motion advances each step.
     *
     * @mangled SetStep__11CCharacter2Ff
     * @address 0x174C70
     * @size 0x10
     */
    virtual void SetStep(float frame_step);

    /**
     *
     * Gets the frames that the motion advances each step.
     *
     * @mangled GetStep__11CCharacter2Fv
     * @address 0x169880
     * @size 0x10
     */
    virtual float GetStep() {
        return step;
    }

    /**
     *
     * Gets the frames that the motion that plays advances each step by default.
     *
     * @mangled GetDefaultStep__11CCharacter2Fv
     * @address 0x174C50
     * @size 0x20
     */
    virtual float GetDefaultStep();

    /**
     *
     * Sets whether the character fades by its distance from the camera.
     *
     * @mangled SetFadeFlag__11CCharacter2Fi
     * @address 0x169890
     * @size 0x10
     */
    virtual void SetFadeFlag(int fade_flag) {
        fade = fade_flag;
    }

    /**
     *
     * Gets whether the character fades by its distance from the camera.
     *
     * @mangled GetFadeFlag__11CCharacter2Fv
     * @address 0x1698A0
     * @size 0x10
     */
    virtual int GetFadeFlag() {
        return fade;
    }

    /**
     *
     * Poses the shadow on the model and draws it straight away.
     *
     * @mangled DrawShadowDirect__11CCharacter2Fv
     * @address 0x174A20
     * @size 0xF0
     */
    virtual int DrawShadowDirect();

    /**
     *
     * Changes to the motion set to play, blends into it and advances it, posing the model.
     *
     * @mangled NormalDrive__11CCharacter2Fv
     * @address 0x1759B0
     * @size 0x3A0
     */
    virtual void NormalDrive();

    /**
     *
     * Plays the motion sounds, drives the motion or motion sequence, and steps the cloth and the effects.
     *
     * @mangled Step__11CCharacter2Fv
     * @address 0x175300
     * @size 0x410
     */
    virtual void Step();

    /**
     *
     * Poses each frame of the shadow on the frame of the model that it follows.
     *
     * @mangled ShadowStep__11CCharacter2Fv
     * @address 0x175D50
     * @size 0x130
     */
    virtual void ShadowStep();

    /**
     *
     * Makes the wind blow on the cloth and hair.
     *
     * @mangled SetWind__11CCharacter2FfPf
     * @address 0x1757F0
     * @size 0x80
     */
    virtual void SetWind(float power, float *dir);

    /**
     *
     * Stops the wind on the cloth and hair.
     *
     * @mangled ResetWind__11CCharacter2Fv
     * @address 0x175870
     * @size 0x60
     */
    virtual void ResetWind();

    /**
     *
     * Keeps the cloth and hair above a height.
     *
     * @mangled SetFloor__11CCharacter2Ff
     * @address 0x1758D0
     * @size 0x80
     */
    virtual void SetFloor(float y);

    /**
     *
     * Lets the cloth and hair fall to any height.
     *
     * @mangled ResetFloor__11CCharacter2Fv
     * @address 0x175950
     * @size 0x60
     */
    virtual void ResetFloor();

    /**
     *
     * Copies this character into another, copying the model into memory when memory is given.
     *
     * @mangled Copy__11CCharacter2FR11CCharacter2P9mgCMemory
     * @address 0x17A0B0
     * @size 0xA70
     */
    virtual void Copy(CCharacter2 &dest, mgCMemory *memory);

    /**
     *
     * Gets the quadwords that a copy of the character takes.
     *
     * @mangled GetCopySize__11CCharacter2Fv
     * @address 0x1698B0
     * @size 0x30
     */
    virtual int GetCopySize() {
        if (copy_size > 0) {
            return copy_size;
        }

        return load_size;
    }

    /**
     *
     * Draws the sword trails and the effects of the character.
     *
     * @mangled DrawEffect__11CCharacter2Fv
     * @address 0x1790F0
     * @size 0x190
     */
    virtual void DrawEffect();

    /**
     *
     * Adds an outline around a frame of the model, or of a model that an outline already draws.
     *
     * @mangled AddOutLine__11CCharacter2FPcP12COutLineDraw
     * @address 0x174200
     * @size 0x110
     */
    void AddOutLine(char *frame_name, COutLineDraw *outline);

    /**
     *
     * Makes the outlines draw into the screen texture of another character's outlines.
     *
     * @mangled CopyOutLine__11CCharacter2FP11CCharacter2
     * @address 0x174310
     * @size 0x60
     */
    void CopyOutLine(CCharacter2 *other);

    /**
     *
     * Rebuilds the bounding boxes of the frames whose skin deforms.
     *
     * @mangled SetDeformMesh__11CCharacter2Fv
     * @address 0x1744C0
     * @size 0x70
     */
    void SetDeformMesh();

    /**
     *
     * Gives the model and the shadow the position, rotation and scale of the character.
     *
     * @mangled UpdatePosition__11CCharacter2Fv
     * @address 0x174B10
     * @size 0xB0
     */
    void UpdatePosition();

    /**
     *
     * Moves the model into place and puts the cloth and hair back to rest on it.
     *
     * @mangled ResetDAPosition__11CCharacter2Fv
     * @address 0x174BC0
     * @size 0x90
     */
    void ResetDAPosition();

    /**
     *
     * Sets the motion or motion sequence to play by its name, keeping the sequence for a sequence step.
     *
     * @mangled SetMotionPara__11CCharacter2FPcii
     * @address 0x174E60
     * @size 0xC0
     */
    void SetMotionPara(char *name, int flags, int keep_seq);

    /**
     *
     * Turns the stepping of the cloth and hair on or off.
     *
     * @mangled SetDAnimeEnable__11CCharacter2Fi
     * @address 0x174F20
     * @size 0x30
     */
    void SetDAnimeEnable(int enable);

    /**
     *
     * Copies the motion sounds of the first motion set into memory.
     *
     * @mangled GetSoundInfoCopy__11CCharacter2FP9mgCMemory
     * @address 0x174F50
     * @size 0x90
     */
    CHRINFO_SE *GetSoundInfoCopy(mgCMemory *memory);

    /**
     *
     * Gets the footstep set of the ground while a foot touches it, or -1 otherwise.
     *
     * @mangled CheckFootEffect__11CCharacter2Fv
     * @address 0x174FE0
     * @size 0x30
     */
    int CheckFootEffect();

    /**
     *
     * Plays the motion sounds that the frame of the motion reached.
     *
     * @mangled SePlay__11CCharacter2Fv
     * @address 0x175010
     * @size 0x2F0
     */
    void SePlay();

    /**
     *
     * Steps the cloth and hair a number of times, or puts them back to rest for a negative count.
     *
     * @mangled StepDA__11CCharacter2Fi
     * @address 0x175710
     * @size 0xE0
     */
    void StepDA(int count);

    /**
     *
     * Finds a motion by its number across every motion set.
     *
     * @mangled GetKeyListIndexPtr__11CCharacter2FiPi
     * @address 0x175E80
     * @size 0x90
     */
    CHRINFO_KEY_SET *GetKeyListIndexPtr(int no, int *out_list);

    /**
     *
     * Finds a motion by its name.
     *
     * @mangled GetKeyListPtr__11CCharacter2FPcPi
     * @address 0x175F10
     * @size 0xE0
     */
    CHRINFO_KEY_SET *GetKeyListPtr(char *name, int *out_list);

    /**
     *
     * Finds a motion sequence by its name.
     *
     * @mangled GetSeqHeaderPtr__11CCharacter2FPcPi
     * @address 0x175FF0
     * @size 0xC0
     */
    CHRINFO_SEQ_HEADER *GetSeqHeaderPtr(char *name, int *out_list);

    /**
     *
     * Drops the motion sets, textures and sounds that extension packs added.
     *
     * @mangled DeleteExtMotion__11CCharacter2Fv
     * @address 0x1760B0
     * @size 0x1F0
     */
    void DeleteExtMotion();

    /**
     *
     * Deletes the textures and texture animations of the character's own IMG archive.
     *
     * @mangled DeleteImage__11CCharacter2Fv
     * @address 0x1762A0
     * @size 0xF0
     */
    void DeleteImage();

    /**
     *
     * Gets the world position of an entry frame, or the character's position when it has none.
     *
     * @mangled GetEntryObjectPos__11CCharacter2FiPf
     * @address 0x176390
     * @size 0x90
     */
    int GetEntryObjectPos(int index, float *out_position);

    /**
     *
     * Gets the matrix of an entry frame, or one made from the character's position and Y rotation when it has none.
     *
     * @mangled GetEntryObjectPos__11CCharacter2FiPA4_f
     * @address 0x176420
     * @size 0xA0
     */
    int GetEntryObjectPos(int index, float (*out_matrix)[4]);

    /**
     *
     * Gets the world position of the frame of a group named as a place to put objects.
     *
     * @mangled GetEntryObjectPos__11CCharacter2FiiPf
     * @address 0x1764C0
     * @size 0xE0
     */
    CHARA_ENTRY_OBJECT *GetEntryObjectPos(int id, int nth, float *out_position);

    /**
     *
     * Runs a skin info file from a pack, replacing parts of the model.
     *
     * @mangled LoadSkin__11CCharacter2FPUiPcPcP9mgCMemoryi
     * @address 0x176600
     * @size 0x10
     */
    void LoadSkin(unsigned int *pack, char *name, char *skin_name, mgCMemory *memory, int texture_block);

    /**
     *
     * Clears the effects of the character.
     *
     * @mangled InitEffect__11CCharacter2Fv
     * @address 0x178DF0
     * @size 0x80
     */
    void InitEffect();

    /**
     *
     * Stops the effects of the previous motion and gathers those that a motion starts.
     *
     * @mangled ExecEntryEffect__11CCharacter2FP15CHRINFO_KEY_SET
     * @address 0x178E70
     * @size 0x100
     */
    void ExecEntryEffect(CHRINFO_KEY_SET *key);

    /**
     *
     * Runs each gathered effect once the motion reaches its point.
     *
     * @mangled CtrlEffect__11CCharacter2Fv
     * @address 0x178F70
     * @size 0xD0
     */
    void CtrlEffect();

    /**
     *
     * Steps the sword trails and the effects of the character.
     *
     * @mangled StepEffect__11CCharacter2Fv
     * @address 0x179040
     * @size 0xB0
     */
    void StepEffect();

    /**
     *
     * Changes the level of detail, giving back the model that it draws.
     *
     * @mangled ChangeLOD__11CCharacter2Fi
     * @address 0x179EA0
     * @size 0x210
     */
    mgCFrame *ChangeLOD(int index);
};

STATIC_ASSERT(sizeof(CCharacter2) == 0x660);
