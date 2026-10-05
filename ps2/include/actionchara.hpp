#pragma once

#include "common.h"
#include <cstring>

#include <cstring>
#include <libvu0.h>

#include "character.hpp"
#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "runscript.hpp"

/**
 * @file
 * Declares the character that an action script drives in the dungeon: the player, the ridepod and the monsters.
 */

class mgCFrame;
class mgCMemory;
class CScene;
class CMapParts;
class CColPrim;
class CEffectScriptMan;
class CActionChara;

/**
 *
 * Kinds of character that an action character plays, as its chara_type holds them.
 *
 */
enum ACTION_CHARA_TYPE {
    ACTION_CHARA_MAX     = 0, /**< Max, and any other character set up with the first user-data slot. */
    ACTION_CHARA_MONICA  = 1, /**< Monica. */
    ACTION_CHARA_ROBO    = 2, /**< The ridepod. */
    ACTION_CHARA_MONSTER = 3, /**< A monster. */
};

/**
 *
 * Ways of moving that the movement script functions choose between, as an action character's move_type holds them.
 *
 */
enum ACTION_MOVE_TYPE {
    ACTION_MOVE_HUMAN      = 0, /**< Moves on foot with HumanMoveIF. */
    ACTION_MOVE_ROBO_WALK  = 1, /**< Moves the ridepod on legs with RoboWalkMoveIF. */
    ACTION_MOVE_ROBO_TANK  = 2, /**< Moves the ridepod on treads with RoboTankMoveIF. */
    ACTION_MOVE_ROBO_BIKE  = 3, /**< Moves the ridepod on wheels with RoboBikeMoveIF. */
    ACTION_MOVE_MONSTER    = 3, /**< Moves a monster with MonsterMoveIF. */
    ACTION_MOVE_ROBO_WALK2 = 4, /**< Moves the ridepod on legs with RoboWalkMoveIF. */
    ACTION_MOVE_ROBO_TANK2 = 5, /**< Moves the ridepod on treads with RoboTankMoveIF, with the differences that it checks for. */
    ACTION_MOVE_ROBO_AIR   = 6, /**< Moves the ridepod through the air with RoboAirMoveIF. */
    ACTION_MOVE_ROBO_AIR2  = 7, /**< Moves the ridepod through the air with RoboAirMoveIF, with the differences that it checks for. */
};

/**
 *
 * What an action character is in its chain of parts, as its chara_kind holds it.
 *
 */
enum ACTION_CHARA_KIND {
    ACTION_KIND_NONE   = 0, /**< A character with no action script. */
    ACTION_KIND_PART   = 1, /**< A part that SetRef has attached to another character's frame. */
    ACTION_KIND_SCRIPT = 2, /**< A character with a loaded action script. */
};

/**
 *
 * What an action character holds in its hands, as its hold_type holds it.
 *
 */
enum ACTION_HOLD_TYPE {
    ACTION_HOLD_NONE  = 0, /**< Holds nothing. */
    ACTION_HOLD_ITEM  = 1, /**< Holds an item that it is about to throw. */
    ACTION_HOLD_ENEMY = 3, /**< Holds a monster that it has caught. */
    ACTION_HOLD_STONE = 4, /**< Holds a stone from the map that it has picked up. */
};

/**
 *
 * Reactions that damage asks the action script for, as an action character's damage_req holds them.
 *
 */
enum ACTION_DAMAGE_REQ {
    ACTION_DAMAGE_REQ_NONE  = 0, /**< Asks for nothing. */
    ACTION_DAMAGE_REQ_SMALL = 1, /**< Runs ACTION_PROG_DAMAGE_SMALL. */
    ACTION_DAMAGE_REQ_LARGE = 2, /**< Runs ACTION_PROG_DAMAGE_LARGE. */
    ACTION_DAMAGE_REQ_DEAD  = 4, /**< Runs ACTION_PROG_DEAD. */
    ACTION_DAMAGE_REQ_HOLD  = 7, /**< Runs ACTION_PROG_HOLD. */
};

/**
 *
 * Program numbers in an action script that the character runs, as its prog_no holds them.
 *
 */
enum ACTION_PROG {
    ACTION_PROG_RUNNING      = -1,   /**< Resumes the program that is already running. */
    ACTION_PROG_INIT         = 100,  /**< Sets the character up when its script is initialised. */
    ACTION_PROG_RESET        = 150,  /**< Puts the character back into its normal state. */
    ACTION_PROG_MAIN         = 200,  /**< Runs the character's normal behaviour. */
    ACTION_PROG_DAMAGE_SMALL = 500,  /**< Reacts to a small hit. */
    ACTION_PROG_HOLD         = 550,  /**< Holds the character in place. */
    ACTION_PROG_DAMAGE_LARGE = 600,  /**< Reacts to a large hit. */
    ACTION_PROG_DEAD         = 1400, /**< Runs the character's death. */
    ACTION_PROG_LAND         = 1500, /**< Lands the character after a fall. */
};

/**
 *
 * Items that the dungeon gives the action script for throwing them.
 *
 */
struct RUN_SCRIPT_ENV {
    CCharacter2 *item_chara; /**< Models of the throwable items, one per item kind. */
    s32          texb;       /**< Texture bank that the thrown item's effect script draws with. */
};

STATIC_ASSERT(sizeof(RUN_SCRIPT_ENV) == 0x8);

/**
 *
 * Starts a sword's after-image while a motion of the character plays between two frames.
 *
 */
struct ACTION_SW_EFFECT {
    s16   sword_no;  /**< Index into the character's sword after-image effects. */
    char *chara;     /**< Name of the part in the chain whose motion is watched; NULL for the character itself. */
    char *motion;    /**< Name of the motion that starts the after-image; NULL while the slot is free. */
    float start;     /**< Motion frame from which the after-image starts. */
    float end;       /**< Motion frame before which the after-image starts. */
    char *frame0;    /**< Name of the frame at one end of the blade. */
    char *frame1;    /**< Name of the frame at the other end of the blade. */
    s8    unk_1c;
    s8    unk_1d;
    s8    fade_time; /**< Number of steps over which the after-image fades. */
    s8    wait;      /**< Steps left before the after-image can start again. */
};

STATIC_ASSERT(sizeof(ACTION_SW_EFFECT) == 0x20);

/**
 *
 * Makes a collision primitive that deals damage while a motion plays between two frames.
 *
 */
struct ACTION_DAMAGE {
    s8        use;         /**< 1 while the slot holds a damage entry. */
    char     *chara;       /**< Name of the part in the chain whose motion is watched; NULL for the character itself. */
    mgCFrame *frame0;      /**< Frame at one end of the damaging capsule. */
    mgCFrame *frame1;      /**< Frame at the other end of the damaging capsule. */
    float     radius;      /**< Radius of the damaging capsule. */
    float     power_rate;  /**< Multiplier on the damage that the collision primitive deals. */
    float     start_frame; /**< Motion frame from which the damage is dealt. */
    float     end_frame;   /**< Motion frame before which the damage is dealt. */
    char     *damage;      /**< Name of the damage settings given to the collision primitive. */
    CColPrim *prim;        /**< Collision primitive that deals the damage; NULL until it is made. */
};

STATIC_ASSERT(sizeof(ACTION_DAMAGE) == 0x28);

/**
 *
 * Remembers a frame of the character that the action script refers to by number.
 *
 */
struct ACTION_OBJECT {
    mgCFrame     *frame; /**< Frame of the character; NULL while the slot is free. */
    s32           unk_4[3];
    sceVu0FVECTOR pos;   /**< World position of the frame, worked out each time the character is drawn. */
};

STATIC_ASSERT(sizeof(ACTION_OBJECT) == 0x20);

/**
 *
 * Gives the character a body collision sphere around one of its numbered frames.
 *
 */
struct ACTION_BODY_COL {
    s32   type;   /**< 0 while the slot is free; 2 for a sphere around an object. */
    s32   object; /**< Index of the object whose frame the sphere sits on. */
    float radius; /**< Radius of the sphere. */
    s32   unk_c[5];
    s32   unk_20;
};

STATIC_ASSERT(sizeof(ACTION_BODY_COL) == 0x24);

/**
 *
 * Plays a sound while a motion of the character plays between two frames.
 *
 */
struct ACTION_SOUND {
    s32   se_no;       /**< Sound to play; -1 while the slot is free. */
    float start_frame; /**< Motion frame from which the sound plays. */
    float end_frame;   /**< Motion frame before which the sound plays. */
    s32   unk_c;
    char *chara;       /**< Name of the part in the chain whose motion is watched; NULL for the character itself. */
};

STATIC_ASSERT(sizeof(ACTION_SOUND) == 0x14);

/**
 *
 * Holds how fast the character speeds up and moves.
 *
 */
struct ACTION_ACCELE {
    sceVu0FVECTOR accele;     /**< Acceleration of the character. */
    float         speed;      /**< Forward speed of a wheeled ridepod. */
    float         move_speed; /**< Speed at which the character walks. */
    s32           unk_18;
    s32           unk_1c;
};

STATIC_ASSERT(sizeof(ACTION_ACCELE) == 0x20);

/**
 *
 * Says which frame the charging effect gathers on.
 *
 */
struct ACTION_ACCUME {
    mgCFrame *frame;  /**< Frame of the object that the charging effect gathers on. */
    s16       unk_4;
    s16       active; /**< 1 once the charging effect has started. */
};

STATIC_ASSERT(sizeof(ACTION_ACCUME) == 0x8);

/**
 *
 * Shakes the character up and down for a while after it is hit.
 *
 */
struct ACTION_SHAKE {
    s16   time;   /**< Steps left to shake. */
    float offset; /**< Height by which the character is moved this step. */
};

STATIC_ASSERT(sizeof(ACTION_SHAKE) == 0x8);

/**
 *
 * Runs a character, and the parts chained onto it, from an action script that reads the pad and reacts to damage.
 *
 */
class CActionChara : public CCharacter2 {
public:
    sceVu0FVECTOR    old_pos;        /**< Position of the character before this step's move. */
    s32              chara_type;     /**< Kind of character, an ACTION_CHARA_TYPE value. */
    CActionChara    *parent;         /**< Character that this part is chained onto; NULL for the head of the chain. */
    CActionChara    *next;           /**< Next part in the chain; NULL for the last. */
    CPalletAnime     unk_67c;
    s16              chara_kind;     /**< What the character is in its chain, an ACTION_CHARA_KIND value. */
    sceVu0FVECTOR    front_vec;      /**< Direction that the character faces. */
    s32              mask_flag;      /**< Bits that monster scripts set and clear. */
    s32              attack_type;    /**< Attack type that the action script reads. */
    s32              move_type;      /**< Way of moving, an ACTION_MOVE_TYPE value. */
    float            max_speed;      /**< Speed at which the ridepod moves at its fastest. */
    s32              unk_6b0;
    s16              unk_6b4;
    char            *script_buf;     /**< Copy of the action script file that the interpreter runs. */
    CRunScript       script;         /**< Interpreter that runs the action script. */
    s16              prog_no;        /**< Program to run next, an ACTION_PROG value. */
    s16              prog;           /**< Value that the action script keeps for itself. */
    u32              pad_history;    /**< Buttons pressed since the action script last cleared them. */
    char            *default_motion; /**< Name of the motion that the character returns to. */
    s16              hold_type;      /**< What the character holds, an ACTION_HOLD_TYPE value. */
    CMapParts       *hold_parts;     /**< Stone that the character holds. */
    mgCFrame        *hold_frame;     /**< Frame of the character that carries what it holds. */
    s16              release_timing; /**< What has just happened to what the character holds; cleared each step. */
    s16              unk_72a;
    mgCFrame        *catch_frame;    /**< Frame of the character that has caught this one. */
    s16              catch_state;    /**< 1 while another character holds this one, 2 while it flies after being thrown. */
    s16              no_hit_time;    /**< Steps left before this character's body collides again. */
    CPalletAnime     pallet[3];      /**< Colour flashes over the character's lighting; the first one playing is used. */
    s16              unk_75e;
    float            unk_760;
    s16              shot_wait;      /**< Steps left before the character can shoot again. */
    s32              muteki_time;    /**< Steps left for which the character takes no damage. */
    s8               menu_flag;      /**< Nonzero while the character may open the menu. */
    s8               stand_flag;     /**< 1 while the stick is not pushed. */
    s8               dir_gun;        /**< 1 when the action script has aimed the gun this step. */
    s16              target_no;      /**< Scene character number of the lock-on target; -1 for none. */
    s16              lock_on;        /**< 1 while the character is locked on to its target. */
    s32              murderous_time; /**< Steps left for the character's murderous value. */
    s32              murderous;      /**< Murderous value that the action script set. */
    s32              now_status;     /**< Status that the action scripts of other characters read from this one. */
    ACTION_ACCELE    accele;         /**< How fast the character speeds up and moves. */
    sceVu0FVECTOR    add_vec;        /**< Direction of a movement added to the character's velocity. */
    float            add_speed;      /**< Speed of the added movement. */
    float            add_decel;      /**< Amount taken off the added movement's speed each step. */
    s32              add_time;       /**< Steps left for the added movement; 0 for none. */
    float            stick_angle;    /**< Direction of the stick relative to the character. */
    s32              stick_time;     /**< Steps for which the stick has kept its direction. */
    float            target_dot;     /**< Cosine of the angle between the character's velocity and its target. */
    s32              unk_7c8;
    void            *accume_effect;  /**< Charging effect that the character's weapon shows; NULL for none. */
    ACTION_ACCUME    accume;         /**< Frame that the charging effect gathers on. */
    s32              acumu_pad;      /**< Steps for which the charge button has been held. */
    CEffectScriptMan *effect_man;    /**< Effect scripts that the character starts. */
    s8               throw_effect;   /**< Effect script of the item about to be thrown; below 0 for none. */
    ACTION_SW_EFFECT sw_effect[9];   /**< Sword after-images that the character's motions start. */
    s8               sw_effect_num;  /**< Number of sword after-images entered. */
    MoveCheckInfo    move_check;     /**< Result of checking the character's move against the map. */
    ACTION_DAMAGE    damage[11];     /**< Damage that the character's motions deal. */
    s8               damage_num;     /**< Number of damage entries entered. */
    s32              damage_req;     /**< Reaction that damage asks for, an ACTION_DAMAGE_REQ value. */
    s32              unk_be0;
    s32              unk_be4;
    s32              damage_time;    /**< Steps left before the character can be hit again. */
    s32              unk_bec;
    s32              guard_flag;     /**< Nonzero while the character guards. */
    s8               stagger;        /**< Stagger built up from recent hits. */
    s8               stagger_time;   /**< Steps left before the built-up stagger is cleared. */
    ACTION_SHAKE     shake;          /**< Shaking after a hit. */
    ACTION_OBJECT    object[8];      /**< Frames that the action script refers to by number. */
    ACTION_BODY_COL  body_col[16];   /**< Body collision spheres of the character. */
    sceVu0FVECTOR    blow_vec;       /**< Direction in which the character is knocked back. */
    float            blow_rate;      /**< Multiplier on the speed of a knock-back. */
    float            blow_speed;     /**< Speed of the knock-back. */
    float            blow_decel;     /**< Amount taken off the knock-back speed each step. */
    s32              blow_time;      /**< Steps left for the knock-back; 0 for none. */
    ACTION_SOUND     sound[10];      /**< Sounds that the character's motions play. */

    /**
     * Makes a character with an empty interpreter and a cleared map check.
     *
     * @mangled __ct__12CActionCharaFv
     * @address 0x1ACF40
     * @size 0xC0
     */
    CActionChara() {
        memset(&move_check, 0, sizeof(move_check));
    }

    /**
     * Stops the character speeding up.
     *
     * @mangled ResetAccele__12CActionCharaFv
     * @address 0x16B550
     * @size 0x14
     */
    void ResetAccele();

    /**
     * Ends the character's damage, after-images and held item, and runs the reset program.
     *
     * @mangled ResetAction__12CActionCharaFv
     * @address 0x16B570
     * @size 0xB8
     */
    void ResetAction();

    /**
     * Clears every object, body sphere, damage entry, sound and after-image that the script entered.
     *
     * @mangled ResetScript__12CActionCharaFv
     * @address 0x16B630
     * @size 0x298
     */
    void ResetScript();

    /**
     * Says whether the character may open the menu, which it may not while it holds anything.
     *
     * @mangled CheckRunEvent__12CActionCharaFv
     * @address 0x16B8D0
     * @size 0x18
     */
    int CheckRunEvent();

    /**
     * Sets or clears bits of the mask flags.
     *
     * @mangled SetMaskFlag__12CActionCharaFii
     * @address 0x16B8F0
     * @size 0x30
     */
    void SetMaskFlag(int flag, int on);

    /**
     * Enters a frame of the chain as an object, in the first free slot or the slot given.
     *
     * @mangled EntryObject__12CActionCharaFPci
     * @address 0x16B920
     * @size 0xAC
     */
    ACTION_OBJECT *EntryObject(char *name, int no);

    /**
     * Works out the world position of every entered object.
     *
     * @mangled CalcCollision__12CActionCharaFv
     * @address 0x16B9D0
     * @size 0x54
     */
    void CalcCollision();

    /**
     * Enters a body collision sphere around an entered object.
     *
     * @mangled EntryBodyCol__12CActionCharaFif
     * @address 0x16BA30
     * @size 0x8C
     */
    ACTION_BODY_COL *EntryBodyCol(int object, float radius);

    /**
     * Enters damage dealt between two named frames while a motion plays between two points of it.
     *
     * @mangled EntryDamage2__12CActionCharaFPcPcPcfPcffPc
     * @address 0x16BAC0
     * @size 0x194
     */
    ACTION_DAMAGE *EntryDamage2(char *frame0, char *frame1, char *damage, float radius, char *motion, float start, float end, char *chara);

    /**
     * Enters damage dealt between two frames while a motion plays between two points of it.
     *
     * @mangled EntryDamage2__12CActionCharaFP8mgCFrameP8mgCFramePcfPcffPc
     * @address 0x16BC60
     * @size 0x160
     */
    ACTION_DAMAGE *EntryDamage2(mgCFrame *frame0, mgCFrame *frame1, char *damage, float radius, char *motion, float start, float end, char *chara);

    /**
     * Deletes the collision primitive of every damage entry.
     *
     * @mangled AllDeleteDamage__12CActionCharaFv
     * @address 0x16BDC0
     * @size 0x78
     */
    void AllDeleteDamage();

    /**
     * Gets the first free sword after-image slot.
     *
     * @mangled GetSwEffectPtr__12CActionCharaFv
     * @address 0x16BE40
     * @size 0x38
     */
    ACTION_SW_EFFECT *GetSwEffectPtr();

    /**
     * Gives every part in the chain the character's sound settings.
     *
     * @mangled SetSoundInfoCopy__12CActionCharaFv
     * @address 0x16BE80
     * @size 0x54
     */
    void SetSoundInfoCopy();

    /**
     * Sets the fade flag of every part in the chain.
     *
     * @mangled SetFadeFlag__12CActionCharaFi
     * @address 0x16BEE0
     * @size 0x30
     */
    virtual void SetFadeFlag(int flag);

    /**
     * Sets the far drawing distance of every part in the chain.
     *
     * @mangled SetFarDist__12CActionCharaFf
     * @address 0x16BF10
     * @size 0x30
     */
    virtual void SetFarDist(float dist);

    /**
     * Sets the near drawing distance of every part in the chain.
     *
     * @mangled SetNearDist__12CActionCharaFf
     * @address 0x16BF40
     * @size 0x30
     */
    virtual void SetNearDist(float dist);

    /**
     * Gets the camera distance of the head of the chain.
     *
     * @mangled GetCameraDist__12CActionCharaFv
     * @address 0x16BF70
     * @size 0x38
     */
    virtual float GetCameraDist();

    /**
     * Shows or hides the character, and with all set every part in the chain.
     *
     * @mangled Show__12CActionCharaFii
     * @address 0x16BFB0
     * @size 0x40
     */
    virtual void Show(int show, int all);

    /**
     * Says whether the named part of the chain is shown, or the character itself for NULL.
     *
     * @mangled GetShow__12CActionCharaFPc
     * @address 0x16BFF0
     * @size 0x80
     */
    virtual int GetShow(char *chara);

    /**
     * Kicks the stone nearest the named frame, or with kick unset only says whether there is one.
     *
     * @mangled CheckKeri__12CActionCharaFPci
     * @address 0x16C070
     * @size 0xCC
     */
    int CheckKeri(char *name, int kick);

    /**
     * Catches the monster or picks up the stone at the named frame.
     *
     * @mangled CheckEnemyCatch__12CActionCharaFPc
     * @address 0x16C140
     * @size 0x210
     */
    int CheckEnemyCatch(char *name);

    /**
     * Throws the held item forwards and takes it out of the inventory.
     *
     * @mangled ThrowItemObject__12CActionCharaFv
     * @address 0x16C350
     * @size 0xDC
     */
    void ThrowItemObject();

    /**
     * Uses the active item: 1 when used, 2 when it is to be thrown, 3 when there is none, 0 otherwise.
     *
     * @mangled UsedItemAction__12CActionCharaFv
     * @address 0x16C430
     * @size 0x194
     */
    int UsedItemAction();

    /**
     * Puts the active item into the character's hands to throw it.
     *
     * @mangled EntryThrowItem__12CActionCharaFv
     * @address 0x16C5D0
     * @size 0x1FC
     */
    void EntryThrowItem();

    /**
     * Puts away an item that the character holds without throwing it.
     *
     * @mangled RemoveThrowItem__12CActionCharaFv
     * @address 0x16C7D0
     * @size 0x5C
     */
    void RemoveThrowItem();

    /**
     * Sets the numbered motion on every part in the chain.
     *
     * @mangled SetMotion__12CActionCharaFii
     * @address 0x16CB30
     * @size 0x60
     */
    virtual void SetMotion(int no, int flags);

    /**
     * Sets the named motion on the character, and with all set on every part in the chain.
     *
     * @mangled SetMotion__12CActionCharaFPcii
     * @address 0x16CB90
     * @size 0x78
     */
    virtual void SetMotion(char *name, int flags, int all);

    /**
     * Resets the motion of every part in the chain.
     *
     * @mangled ResetMotion__12CActionCharaFv
     * @address 0x16CC10
     * @size 0x48
     */
    virtual void ResetMotion();

    /**
     * Gets the motion wait of the named part of the chain, or of the character itself for NULL.
     *
     * @mangled GetNowFrameWait__12CActionCharaFPc
     * @address 0x16C830
     * @size 0x80
     */
    virtual float GetNowFrameWait(char *chara);

    /**
     * Gets the motion frame of the named part of the chain, or of the character itself for NULL.
     *
     * @mangled GetNowFrame__12CActionCharaFPc
     * @address 0x16C8B0
     * @size 0x80
     */
    virtual float GetNowFrame(char *chara);

    /**
     * Says whether the motion of the named part of the chain, or of the character itself for NULL, has ended.
     *
     * @mangled CheckMotionEnd__12CActionCharaFPc
     * @address 0x16C930
     * @size 0x8C
     */
    virtual int CheckMotionEnd(char *chara);

    /**
     * Gets the motion status of the named part of the chain, or of the character itself for NULL.
     *
     * @mangled GetMotionStatus__12CActionCharaFPc
     * @address 0x16C9C0
     * @size 0x80
     */
    virtual int GetMotionStatus(char *chara);

    /**
     * Turns a point between 0 and 1 of a motion of the named part of the chain into a motion frame.
     *
     * @mangled GetWaitToFrame__12CActionCharaFPcfPc
     * @address 0x16CA40
     * @size 0xE8
     */
    float GetWaitToFrame(char *motion, float rate, char *chara);

    /**
     * Draws every part in the chain through the drawing list, shaking the character after a hit.
     *
     * @mangled Draw__12CActionCharaFv
     * @address 0x16CC60
     * @size 0xF0
     */
    virtual int Draw();

    /**
     * Draws every part in the chain straight away, under the colour flash that is playing.
     *
     * @mangled DrawDirect__12CActionCharaFv
     * @address 0x16CD50
     * @size 0x130
     */
    virtual int DrawDirect();

    /**
     * Draws the shadow of every part in the chain.
     *
     * @mangled DrawShadowDirect__12CActionCharaFv
     * @address 0x16CE80
     * @size 0x48
     * @unknownret
     */
    virtual int DrawShadowDirect();

    /**
     * Draws the character's effects and its effect scripts.
     *
     * @mangled DrawEffect__12CActionCharaFv
     * @address 0x16CED0
     * @size 0x38
     */
    virtual void DrawEffect();

    /**
     * Starts the sword after-images whose motions have reached them, and steps the character's effects.
     *
     * @mangled StepEffect__12CActionCharaFv
     * @address 0x16CF10
     * @size 0x188
     */
    virtual void StepEffect();

    /**
     * Finds the named part of the chain.
     *
     * @mangled SearchChara__12CActionCharaFPc
     * @address 0x16D0A0
     * @size 0x60
     */
    CActionChara *SearchChara(char *name);

    /**
     * Finds the named frame in the models of the chain.
     *
     * @mangled SearchObject__12CActionCharaFPc
     * @address 0x16D100
     * @size 0x70
     */
    mgCFrame *SearchObject(char *name);

    /**
     * Takes the character off the chain and its frame off the frame it was attached to.
     *
     * @mangled ResetParent__12CActionCharaFv
     * @address 0x16D170
     * @size 0x2C
     */
    void ResetParent();

    /**
     * Attaches a part to the named frame of the chain and adds it to the end of the chain.
     *
     * @mangled SetRef__12CActionCharaFP12CActionCharaPc
     * @address 0x16D1A0
     * @size 0xC0
     */
    int SetRef(CActionChara *part, char *name);

    /**
     * Gets the distance to the lock-on target, or -1 when there is none.
     *
     * @mangled GetTargetDist__12CActionCharaFP6CScene
     * @address 0x16D260
     * @size 0x90
     */
    float GetTargetDist(CScene *scene);

    /**
     * Turns a velocity away from the body spheres of the monsters that it would run into.
     *
     * @mangled CollisionCheck__12CActionCharaFPfPfPf
     * @address 0x16D880
     * @size 0x32C
     */
    void CollisionCheck(float *pos, float *velocity, float *out_velocity);

    /**
     * Locks on to a target, switches it or lets it go when the lock-on button is pressed.
     *
     * @mangled RockOn__12CActionCharaFv
     * @address 0x16DBB0
     * @size 0x1E4
     */
    void RockOn();

    /**
     * Moves a character on foot with the stick.
     *
     * @mangled HumanMoveIF__12CActionCharaFv
     * @address 0x16DDA0
     * @size 0xBD0
     */
    int HumanMoveIF();

    /**
     * Moves a character on foot with the stick while it holds something to throw.
     *
     * @mangled HumanShrowMoveIF__12CActionCharaFv
     * @address 0x16E970
     * @size 0x378
     */
    int HumanShrowMoveIF();

    /**
     * Moves a character on foot with the stick while it charges an attack.
     *
     * @mangled HumanTameMoveIF__12CActionCharaFv
     * @address 0x16ECF0
     * @size 0x1BC
     */
    int HumanTameMoveIF();

    /**
     * Moves a character on foot with the stick while it aims a gun, facing its target when locked on.
     *
     * @mangled HumanGunMoveIF__12CActionCharaFPcPc
     * @address 0x16EEB0
     * @size 0x2E0
     */
    int HumanGunMoveIF(char *stand_motion, char *move_motion);

    /**
     * Moves the ridepod on legs with the stick.
     *
     * @mangled RoboWalkMoveIF__12CActionCharaFi
     * @address 0x16F190
     * @size 0x514
     */
    int RoboWalkMoveIF(int mode);

    /**
     * Moves the ridepod on treads with the stick.
     *
     * @mangled RoboTankMoveIF__12CActionCharaFi
     * @address 0x16F6B0
     * @size 0x74C
     */
    int RoboTankMoveIF(int mode);

    /**
     * Moves the ridepod on wheels with the stick.
     *
     * @mangled RoboBikeMoveIF__12CActionCharaFi
     * @address 0x16FE00
     * @size 0x93C
     */
    int RoboBikeMoveIF(int mode);

    /**
     * Moves the ridepod through the air with the stick.
     *
     * @mangled RoboAirMoveIF__12CActionCharaFii
     * @address 0x170740
     * @size 0x6F8
     */
    int RoboAirMoveIF(int unk, int mode);

    /**
     * Moves a monster that the player controls with the stick.
     *
     * @mangled MonsterMoveIF__12CActionCharaFv
     * @address 0x170E40
     * @size 0x6D0
     */
    int MonsterMoveIF();

    /**
     * Takes the damage of a collision primitive that has hit the character, and asks for the reaction to it.
     *
     * @mangled CheckDamage__12CActionCharaFv
     * @address 0x171B40
     * @size 0x98C
     */
    int CheckDamage();

    /**
     * Copies an action script file into memory and gives it to the interpreter.
     *
     * @mangled LoadActionFile__12CActionCharaFPciP9mgCMemory
     * @address 0x1724D0
     * @size 0x94
     */
    int LoadActionFile(char *data, int size, mgCMemory *memory);

    /**
     * Clears what the script entered and runs the initialising program.
     *
     * @mangled InitScript__12CActionCharaFv
     * @address 0x172570
     * @size 0x54
     */
    void InitScript();

    /**
     * Runs the holding program when the script has one.
     *
     * @mangled SetHold__12CActionCharaFv
     * @address 0x1725D0
     * @size 0x50
     */
    void SetHold();

    /**
     * Runs one step of the action script, then moves the character against the map and makes its damage.
     *
     * @mangled RunScript__12CActionCharaFP6CSceneP14RUN_SCRIPT_ENV
     * @address 0x172620
     * @size 0x7A8
     */
    void RunScript(CScene *scene, RUN_SCRIPT_ENV *env);

    /**
     * Gets what has just happened to what the character holds, when it holds the kind given or for -1 any kind.
     *
     * @mangled CheckReleaseTimming__12CActionCharaFi
     * @address 0x172DD0
     * @size 0x30
     */
    int CheckReleaseTimming(int hold_type);

    /**
     * Works out the facing, adds the added movement and knock-back to the velocity and counts down the timers.
     *
     * @mangled StepParam__12CActionCharaFv
     * @address 0x172E00
     * @size 0x484
     */
    void StepParam();

    /**
     * Steps the character and every part in its chain, and carries what it holds.
     *
     * @mangled Step__12CActionCharaFv
     * @address 0x173290
     * @size 0x210
     */
    virtual void Step();

    /**
     * Steps the shadow of every part in the chain.
     *
     * @mangled ShadowStep__12CActionCharaFv
     * @address 0x1734A0
     * @size 0x48
     */
    virtual void ShadowStep();

    /**
     * Puts the character back to its initial state.
     *
     * @mangled Initialize__12CActionCharaFP9mgCMemory
     * @address 0x1734F0
     * @size 0x298
     */
    virtual void Initialize(mgCMemory *memory);

    /**
     * Copies this character into another, and with memory given copies its model too.
     *
     * @mangled Copy__12CActionCharaFR12CActionCharaP9mgCMemory
     * @address 0x173790
     * @size 0x474
     */
    virtual void Copy(CActionChara &dest, mgCMemory *memory);
};

STATIC_ASSERT(sizeof(CActionChara) == 0x1030);
