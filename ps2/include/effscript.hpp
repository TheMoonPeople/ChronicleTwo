#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_sprite.hpp"
#include "runscript.hpp"

/**
 * @file
 * Declares the effect script manager, which loads the effect bases that the effect definition
 * table names (a model or a texture with a compiled script), starts scripted effects from them,
 * and steps and draws every running effect with its characters and billboard sprites.
 */

class mgCMemory;
class CCharacter2;
class CColPrim;
class CScene;

/** Number of effect bases that the manager can hold loaded at once. */
#define EFF_SPT_BASE_MAX 64
/** Number of owners whose effects the manager keeps in its slot table. */
#define EFF_SPT_OWNER_MAX 128
/** Number of effect slots that each owner has in the slot table. */
#define EFF_SPT_OWNER_SLOT_MAX 8
/** Number of extra character copies that a running effect can have. */
#define EFF_SPT_SUB_CHARA_MAX 4
/** Number of script values that a running effect carries. */
#define EFF_SPT_VALUE_MAX 8
/** Number of load levels whose texture buffer use the manager counts. */
#define EFF_SPT_LEVEL_MAX 4
/** Number of rows in the effect definition table, the end row included. */
#define EFF_SPT_BASE_DEF_NUM 219

/**
 * Kinds of resource that an effect definition row loads besides its script.
 */
// clang-format off
enum EffSptBaseType {
    EFF_SPT_BASE_END = -1, /**< Ends the definition table. */
    EFF_SPT_BASE_CHR = 0,  /**< A character model, loaded from "<file>.chr". */
    EFF_SPT_BASE_IMG = 1,  /**< A texture image, loaded from "<file>.img". */
};

// clang-format on

/**
 * States that a running effect can be paused in.
 */
// clang-format off
enum EffSptState {
    EFF_SPT_STATE_RUN          = 0, /**< Runs its script, moves and draws. */
    EFF_SPT_STATE_SCRIPT_PAUSE = 1, /**< Moves and draws but does not run its script. */
    EFF_SPT_STATE_HIDE_STOP    = 2, /**< Neither steps nor draws. */
    EFF_SPT_STATE_STOP         = 3, /**< Draws but does not step. */
    EFF_SPT_STATE_HIDE         = 4, /**< Steps but does not draw. */
};

// clang-format on

/**
 * Names one effect, the resource it is built on and its compiled script.
 */
struct EFF_SPT_BASE_DEF {
    char name[0x20];   /**< Name that effects are started by; empty in the end row. */
    int  type; /**< EffSptBaseType of the resource. */
    char file[0x20];   /**< File name, without extension, of the model or texture image. */
    char script[0x20]; /**< File name, without extension, of the compiled script. */
};

STATIC_ASSERT(sizeof(EFF_SPT_BASE_DEF) == 0x64);

/**
 * Loaded effect base: the model or texture and the script that running effects are started from.
 */
struct EFF_SPT_BASE {
    int          base_no; /**< Row of the effect definition table. */
    CCharacter2 *chara;      /**< Model that running effects copy, or NULL for a texture base. */
    int          texb; /**< Texture block that the base's textures are entered in. */
    int          texb_owned; /**< Nonzero when the texture block was taken from the manager's pool. */
    char        *script;     /**< Compiled script. */
    int          level; /**< Load level the base belongs to. */
    int          work_size; /**< Quadwords of work memory that one running effect needs. */
};

STATIC_ASSERT(sizeof(EFF_SPT_BASE) == 0x1C);

/**
 * Billboard sprite of a running effect, with the velocities and accelerations that move it.
 */
struct _ES_SPRITE {
    int           draw_flag; /**< Nonzero to draw the sprite. */
    int           alpha; /**< Alpha blending mode that the sprite is drawn with. */
    u_char            unk_08[0x8];
    sceVu0FVECTOR pos;                /**< Position, relative to the effect's origin. */
    float         uv[4];              /**< Texture rectangle: left, top, width and height. */
    sceVu0FVECTOR color;              /**< Colour and alpha, each from 0 to 255. */
    float         scale[2];           /**< Horizontal and vertical scale of the drawn size. */
    float         put_size[2];        /**< Drawn width and height before scaling. */
    float         rotz;               /**< Angle, in radians, of the sprite about the view direction. */
    u_char            unk_54[0xC];
    sceVu0FVECTOR velo_pos;           /**< Change of the position in each step. */
    sceVu0FVECTOR acc_pos;            /**< Change of the position velocity in each step. */
    sceVu0FVECTOR velo_col;           /**< Change of the colour in each step. */
    sceVu0FVECTOR acc_col;            /**< Change of the colour velocity in each step. */
    float         velo_rotz;          /**< Change of the angle in each step. */
    float         acc_rotz;           /**< Change of the angle velocity in each step. */
    float         velo_scl[2];        /**< Change of the scale in each step. */
    float         acc_scl[2];         /**< Change of the scale velocity in each step. */
    float         scale_target[2];    /**< Scale that the sprite eases towards. */
    float         scale_conv_div;     /**< Divisor of the scale's remaining distance moved in each step; easing stops at zero or below. */
    u_char            unk_c4[0xC];
    sceVu0FVECTOR color_target;       /**< Colour that the sprite eases towards. */
    float         color_conv_div;     /**< Divisor of the colour's remaining distance moved in each step; easing stops at zero or below. */
    u_char            unk_e4[0xC];
    sceVu0FVECTOR blink_amp;          /**< Amount that blinking adds to each colour component at the peak of its wave. */
    float         blink_speed;        /**< Change of the blink phase in each drawn frame; zero for no blinking. */
    float         blink_phase;        /**< Angle, in radians, of the blink wave. */
    u_char            unk_108[0x8];
};

STATIC_ASSERT(sizeof(_ES_SPRITE) == 0x110);

/**
 * Value slot that a running effect's script and its starter share, holding an integer or a float.
 */
union EFF_SPT_VALUE {
    int   i; /**< Value as an integer. */
    float f; /**< Value as a float. */
};

/**
 * Running effect: its script interpreter, its characters and sprites, and the state that
 * the script works on.
 */
struct _EFF_SCRIPT {
    u_long128    *work;                              /**< Work memory block that holds the effect. */
    u_long128    *chara_work;                        /**< Work memory block of a character copied in by the starter, or NULL. */
    CCharacter2  *chara;                             /**< Copy of the base's model that the effect moves, or NULL. */
    u_long128    *sub_chara_work;                    /**< Work memory block of the extra character copies, or NULL. */
    CCharacter2  *sub_chara[EFF_SPT_SUB_CHARA_MAX];  /**< Extra copies of the model, or NULL. */
    int           texb; /**< Texture block that the effect's textures are taken from. */
    int           level; /**< Load level of the base the effect was started from. */
    _ES_SPRITE   *sprite;                            /**< Billboard sprites, or NULL when none are assigned. */
    int           sprite_num; /**< Number of billboard sprites. */
    char          tex_name[0x20];                    /**< Name of the texture that the sprites are drawn with. */
    CRunScript    run;                               /**< Interpreter of the effect's script. */
    int           prog_no; /**< Script program to start in the next step, or -1 to resume the running one. */
    int           user_id; /**< Owner of the effect: its row in the slot table and the identifier its attacks carry. */
    int           slot; /**< Column of the owner's slot table holding the effect, or -1. */
    sceVu0FVECTOR origin;                            /**< Position that the effect's model and sprites are placed relative to. */
    int           auto_offset; /**< Nonzero to add the target character's position, or its named frame's, to the origin. */
    char          offset_frame[0x20];                /**< Name of the target character's frame that the origin follows; empty for the character itself. */
    u_char            unk_e4[0xC];
    sceVu0FVECTOR work_vect1;                        /**< First vector that the starter passes the script. */
    sceVu0FVECTOR work_vect2;                        /**< Second vector that the starter passes the script. */
    int           target_id; /**< Scene character that the effect aims at or follows, or -1. */
    EFF_SPT_VALUE value[EFF_SPT_VALUE_MAX];          /**< Values that the starter and the script share. */
    CColPrim     *colprim;                           /**< Collision primitive carrying the effect's attack, or NULL. */
    int           light_flag; /**< Nonzero to colour the sprites with the scene lighting instead of their own colour. */
    int           state; /**< EffSptState that the effect is paused in. */
    _EFF_SCRIPT  *prev;                              /**< Previous effect in the manager's list, which is ordered by texture block. */
    _EFF_SCRIPT  *next;                              /**< Next effect in the manager's list. */
    u_char            unk_148[0x8];
};

STATIC_ASSERT(sizeof(_EFF_SCRIPT) == 0x150);

/**
 * Loads effect bases and runs the scripted effects started from them, keeping every
 * running effect in a list and in a table of slots by owner.
 */
class CEffectScriptMan {
public:
    mgCMemory     *memory;                                        /**< Memory that effect bases are built in when no other is given. */
    mgCMemory     *work_memory;                                   /**< Memory that running effects, their characters and sprites are allocated from. */
    u_long128     *load_buffer;                                   /**< Buffer that base files are read into before they are built. */
    int            level; /**< Load level that bases built now belong to. */
    int            texb_start; /**< First texture block of the manager's pool. */
    int            texb_num; /**< Number of texture blocks in the pool. */
    int            texb_used; /**< Number of texture blocks of the pool in use. */
    int            level_texb_used[EFF_SPT_LEVEL_MAX]; /**< Number of pool texture blocks taken by each load level. */
    int            unk_2c;
    mgC3DSprite    sprite;                                        /**< Builds the packet that the running effects' billboards are drawn with. */
    EFF_SPT_BASE  *base[EFF_SPT_BASE_MAX];                        /**< Loaded effect bases, or NULL for free entries. */
    int            base_num; /**< Number of effect bases built. */
    _EFF_SCRIPT   *slot[EFF_SPT_OWNER_MAX][EFF_SPT_OWNER_SLOT_MAX]; /**< Running effects by owner and slot, or NULL. */
    _EFF_SCRIPT   *now;                                           /**< Effect started last, which calls given a negative slot act on. */
    _EFF_SCRIPT   *head;                                          /**< First running effect. */
    _EFF_SCRIPT   *tail;                                          /**< Last running effect. */

    /**
     * Creates a manager with no memory, texture pool, bases or effects.
     */
    CEffectScriptMan() { Initialize(NULL, -1, -1); }

    /**
     * Forgets every base and effect, and takes the memory and the pool of
     * texture blocks that bases are built in.
     *
     * @mangled Initialize__16CEffectScriptManFP9mgCMemoryii
     * @address 0x2E4DE0
     * @size 0x130
     */
    void Initialize(mgCMemory *memory, int texb_start, int texb_num);

    /**
     * Sets the memory that running effects are allocated from, unless it is
     * NULL.
     *
     * @mangled SetWorkBuffer__16CEffectScriptManFP9mgCMemory
     * @address 0x2E4F10
     * @size 0x20
     */
    void SetWorkBuffer(mgCMemory *work_memory);

    /**
     * Finds the row of the effect definition table that has the given
     * name, or -1.
     *
     * @mangled SearchBaseNo__16CEffectScriptManFPc
     * @address 0x2E4F30
     * @size 0x70
     */
    int SearchBaseNo(char *name);

    /**
     * Reads the files of an effect base into the load buffer and builds
     * it, unless it is already loaded.
     *
     * @mangled LoadBaseEffSpt__16CEffectScriptManFiP9mgCMemoryi
     * @address 0x2E4FA0
     * @size 0x160
     */
    int LoadBaseEffSpt(int base_no, mgCMemory *memory, int texb);

    /**
     * Reads the files of the named effect base and builds it, unless it is
     * already loaded.
     *
     * @mangled LoadBaseEffSpt__16CEffectScriptManFPcP9mgCMemoryi
     * @address 0x2E5100
     * @size 0x50
     */
    int LoadBaseEffSpt(char *name, mgCMemory *memory, int texb);

    /**
     * Stops the effects of a load level and frees its bases, listing the
     * texture blocks they used.
     *
     * @mangled ClearBaseFromLevel__16CEffectScriptManFiPii
     * @address 0x2E5150
     * @size 0x160
     */
    void ClearBaseFromLevel(int level, int *texb_list, int texb_list_max);

    /**
     * Finds a loaded base with the same model file as a definition row,
     * whose model can be copied instead of loaded again.
     *
     * @mangled GetBaseChara__16CEffectScriptManFi
     * @address 0x2E52B0
     * @size 0xD0
     */
    CCharacter2 *GetBaseChara(int base_no);

    /**
     * Finds a loaded base with the same model file as the named definition
     * row.
     *
     * @mangled GetBaseChara__16CEffectScriptManFPc
     * @address 0x2E5380
     * @size 0x30
     */
    CCharacter2 *GetBaseChara(char *name);

    /**
     * Gives the next free texture block of the pool, or -1 when the pool is
     * full.
     *
     * @mangled GetNotUsedTexb__16CEffectScriptManFv
     * @address 0x2E53B0
     * @size 0x30
     */
    int GetNotUsedTexb();

    /**
     * Marks the next texture block of the pool used by the current load
     * level.
     *
     * @mangled AddTexb__16CEffectScriptManFv
     * @address 0x2E53E0
     * @size 0x40
     */
    void AddTexb();

    /**
     * Builds an effect base from its model or texture data and its script
     * data, entering its textures in a texture block.
     *
     * @mangled BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi
     * @address 0x2E5420
     * @size 0x630
     */
    int BuildBase(int base_no, u_long128 *data, int data_size, u_long128 *script, int script_size, mgCMemory *memory, int texb);

    /**
     * Builds the named effect base from its model or texture data and its
     * script data.
     *
     * @mangled BuildBase__16CEffectScriptManFPcP1iP1iP9mgCMemoryi
     * @address 0x2E5A50
     * @size 0x90
     * @unknownret
     */
    int BuildBase(char *name, u_long128 *data, int data_size, u_long128 *script, int script_size, mgCMemory *memory, int texb);

    /**
     * Builds an effect base from the files that a loaded pack holds.
     *
     * @mangled BuildPack__16CEffectScriptManFiPUiP9mgCMemoryi
     * @address 0x2E5AE0
     * @size 0x120
     */
    int BuildPack(int base_no, u_int *pack, mgCMemory *memory, int texb);

    /**
     * Builds the named effect base from the files that a loaded pack holds.
     *
     * @mangled BuildPack__16CEffectScriptManFPcPUiP9mgCMemoryi
     * @address 0x2E5C00
     * @size 0x60
     */
    int BuildPack(char *name, u_int *pack, mgCMemory *memory, int texb);

    /**
     * Makes the paths of the resource file and the script file of an
     * effect base.
     *
     * @mangled GetNeedFilePath__16CEffectScriptManFiPcPc
     * @address 0x2E5C60
     * @size 0xB0
     */
    int GetNeedFilePath(int base_no, char *data_path, char *script_path);

    /**
     * Makes the paths of the resource file and the script file of the named
     * effect base.
     *
     * @mangled GetNeedFilePath__16CEffectScriptManFPcPcPc
     * @address 0x2E5D10
     * @size 0x50
     * @unknownret
     */
    int GetNeedFilePath(char *name, char *data_path, char *script_path);

    /**
     * Starts an effect from a loaded base for an owner, optionally giving it
     * a slot of the owner's table.
     *
     * @mangled CreateEffSpt__16CEffectScriptManFiii
     * @address 0x2E5D60
     * @size 0x500
     */
    _EFF_SCRIPT *CreateEffSpt(int base_no, int user_id, int use_slot);

    /**
     * Starts the named effect for an owner, giving its slot or -1.
     *
     * @mangled CreateEffSpt__16CEffectScriptManFPcii
     * @address 0x2E6260
     * @size 0x70
     */
    int CreateEffSpt(char *name, int user_id, int use_slot);

    /**
     * Stops every effect of an owner.
     *
     * @mangled ClearEffectFromChrid__16CEffectScriptManFi
     * @address 0x2E62D0
     * @size 0x70
     */
    void ClearEffectFromChrid(int user_id);

    /**
     * Stops every effect of a load level.
     *
     * @mangled ClearEffectFromLevel__16CEffectScriptManFi
     * @address 0x2E6340
     * @size 0x70
     */
    void ClearEffectFromLevel(int level);

    /**
     * Stops an effect, unlinking it and freeing its memory.
     *
     * @mangled DeleteEffSpt__16CEffectScriptManFP11_EFF_SCRIPT
     * @address 0x2E63B0
     * @size 0x140
     */
    void DeleteEffSpt(_EFF_SCRIPT *script);

    /**
     * Stops the effect in an owner's slot.
     *
     * @mangled DeleteEffSpt__16CEffectScriptManFii
     * @address 0x2E64F0
     * @size 0x60
     */
    int DeleteEffSpt(int user_id, int slot);

    /**
     * Stops every running effect and empties the slot table.
     *
     * @mangled AllClearEffSpt__16CEffectScriptManFv
     * @address 0x2E6550
     * @size 0xB0
     */
    void AllClearEffSpt();

    /**
     * Runs the scripts of the running effects and moves their characters
     * and sprites, stopping the effects whose scripts end.
     *
     * @mangled Step__16CEffectScriptManFv
     * @address 0x2E6600
     * @size 0x3B0
     */
    void Step();

    /**
     * Draws the characters and the billboard sprites of the running
     * effects.
     *
     * @mangled Draw__16CEffectScriptManFv
     * @address 0x2E69B0
     * @size 0x4C0
     */
    void Draw();

    /**
     * Allocates the given number of cleared billboard sprites from the work
     * memory.
     *
     * @mangled AssignSprite__16CEffectScriptManFi
     * @address 0x2E6E70
     * @size 0xF0
     */
    _ES_SPRITE *AssignSprite(int num);

    /**
     * Frees billboard sprites allocated by AssignSprite.
     *
     * @mangled DeleteSprite__16CEffectScriptManFP10_ES_SPRITE
     * @address 0x2E6F60
     * @size 0x40
     */
    void DeleteSprite(_ES_SPRITE *sprite);

    /**
     * Gives an effect the given number of extra copies of its model.
     *
     * @mangled AssignCharacter__16CEffectScriptManFP11_EFF_SCRIPTi
     * @address 0x2E6FA0
     * @size 0x1B0
     */
    int AssignCharacter(_EFF_SCRIPT *script, int num);

    /**
     * Sets the script program that an owner's effect starts in its next
     * step.
     *
     * @mangled SetScriptProgNo__16CEffectScriptManFiii
     * @address 0x2E7150
     * @size 0x60
     */
    int SetScriptProgNo(int prog_no, int user_id, int slot);

    /**
     * Sets the EffSptState of an owner's effect.
     *
     * @mangled Pause__16CEffectScriptManFiii
     * @address 0x2E71B0
     * @size 0x60
     */
    int Pause(int state, int user_id, int slot);

    /**
     * Sets the EffSptState of every effect of a load level.
     *
     * @mangled PauseFromLevel__16CEffectScriptManFii
     * @address 0x2E7210
     * @size 0x40
     */
    void PauseFromLevel(int level, int state);

    /**
     * Sets the first work vector of an effect: the one in an owner's slot,
     * or the last started one when the slot is negative.
     *
     * @mangled SetScriptVect1__16CEffectScriptManFPfii
     * @address 0x2E7250
     * @size 0x80
     */
    int SetScriptVect1(float *vect, int user_id, int slot);

    /**
     * Gives the first work vector of an effect: the one in an owner's slot,
     * or the last started one when the slot is negative.
     *
     * @mangled GetScriptVect1__16CEffectScriptManFPfii
     * @address 0x2E72D0
     * @size 0x90
     */
    int GetScriptVect1(float *vect, int user_id, int slot);

    /**
     * Sets the second work vector of an effect: the one in an owner's slot,
     * or the last started one when the slot is negative.
     *
     * @mangled SetScriptVect2__16CEffectScriptManFPfii
     * @address 0x2E7360
     * @size 0x80
     */
    int SetScriptVect2(float *vect, int user_id, int slot);

    /**
     * Gives the second work vector of an effect: the one in an owner's slot,
     * or the last started one when the slot is negative.
     *
     * @mangled GetScriptVect2__16CEffectScriptManFPfii
     * @address 0x2E73E0
     * @size 0x90
     */
    int GetScriptVect2(float *vect, int user_id, int slot);

    /**
     * Sets the target character of an effect: the one in an owner's slot,
     * or the last started one when the slot is negative.
     *
     * @mangled SetScriptTargetId__16CEffectScriptManFiii
     * @address 0x2E7470
     * @size 0x80
     */
    int SetScriptTargetId(int target_id, int user_id, int slot);

    /**
     * Gives the target character of an effect: the one in an owner's slot,
     * or the last started one when the slot is negative.
     *
     * @mangled GetScriptTargetId__16CEffectScriptManFRiii
     * @address 0x2E74F0
     * @size 0x90
     */
    int GetScriptTargetId(int &target_id, int user_id, int slot);

    /**
     * Sets the owner of an effect: the one in an owner's slot, or the last
     * started one when the slot is negative.
     *
     * @mangled SetScriptUserId__16CEffectScriptManFiii
     * @address 0x2E7580
     * @size 0x80
     */
    int SetScriptUserId(int new_user_id, int user_id, int slot);

    /**
     * Gives the owner of an effect: the one in an owner's slot, or the last
     * started one when the slot is negative.
     *
     * @mangled GetScriptUserId__16CEffectScriptManFRiii
     * @address 0x2E7600
     * @size 0x90
     */
    int GetScriptUserId(int &out_user_id, int user_id, int slot);

    /**
     * Sets the collision primitive of an effect: the one in an owner's
     * slot, or the last started one when the slot is negative.
     *
     * @mangled SetColPrim__16CEffectScriptManFP8CColPrimii
     * @address 0x2E7690
     * @size 0x80
     */
    int SetColPrim(CColPrim *colprim, int user_id, int slot);

    /**
     * Sets an integer script value of an effect: the one in an owner's
     * slot, or the last started one when the slot is negative.
     *
     * @mangled SetValue__16CEffectScriptManFiiii
     * @address 0x2E7710
     * @size 0xB0
     */
    int SetValue(int index, int value, int user_id, int slot);

    /**
     * Sets a float script value of an effect: the one in an owner's slot,
     * or the last started one when the slot is negative.
     *
     * @mangled SetValue__16CEffectScriptManFifii
     * @address 0x2E77C0
     * @size 0xB0
     */
    int SetValue(int index, float value, int user_id, int slot);

    /**
     * Sets the origin of an effect: the one in an owner's slot, or the last
     * started one when the slot is negative.
     *
     * @mangled SetOrigin__16CEffectScriptManFPfii
     * @address 0x2E7870
     * @size 0x80
     */
    int SetOrigin(float *origin, int user_id, int slot);

    /**
     * Gives the model copy of an effect: the one in an owner's slot, or the
     * last started one when the slot is negative.
     *
     * @mangled GetCharacter__16CEffectScriptManFii
     * @address 0x2E78F0
     * @size 0x80
     */
    CCharacter2 *GetCharacter(int user_id, int slot);

    /**
     * Gives an effect a copy of the given character as its model: the one
     * in an owner's slot, or the last started one when the slot is negative.
     *
     * @mangled SetCharacter__16CEffectScriptManFP11CCharacter2ii
     * @address 0x2E7970
     * @size 0x2A0
     */
    int SetCharacter(CCharacter2 *chara, int user_id, int slot);

    /**
     * Sets the texture block of an effect: the one in an owner's slot, or
     * the last started one when the slot is negative.
     *
     * @mangled SetTexb__16CEffectScriptManFiii
     * @address 0x2E7C10
     * @size 0x80
     */
    int SetTexb(int texb, int user_id, int slot);
};

STATIC_ASSERT(sizeof(CEffectScriptMan) == 0x1190);

/**
 * Names every effect, the resource it is built on and its script; ended by a row of type
 * EFF_SPT_BASE_END.
 */
extern EFF_SPT_BASE_DEF eff_spt_base_def[EFF_SPT_BASE_DEF_NUM];

/**
 * Scene that the effect scripts act on, taken when a manager is initialised.
 */
extern "C" CScene *now_scene;

/**
 * Manager whose effects are being stepped, which the script functions act on.
 */
extern "C" CEffectScriptMan *EffScriptMan;
