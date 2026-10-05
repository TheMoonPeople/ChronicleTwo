#pragma once

#include "common.h"

#include <libvu0.h>

#include "actionchara.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "mg_memory.hpp"
#include "runscript.hpp"
#include "scenesnd.hpp"

/**
 * @file
 * Declares the dungeon's monsters: the table of monster kinds, the monsters
 * that are out on the floor, and the manager that loads, places, thinks for,
 * damages and draws them.
 */

class CActiveMonster;
class CColPrim;
class CEffectScriptMan;
class CMapParts;
class CMapPiece;
class CMiniMapSymbol;
class CScene;
class mgCFrame;

/**
 *
 * Numbers of monster slots that the monster manager keeps.
 *
 */
enum MONSTER_MAN_SIZE {
    MONSTER_ACTIVE_MAX = 24, /**< Monsters that can be out on the floor at once. */
    MONSTER_REFER_MAX  = 12, /**< Monster kinds that can be loaded at once. */
    MONSTER_LOCATE_MAX = 32, /**< Entries in the floor's list of monsters to place. */
    MONSTER_VAR_MAX    = 8,  /**< Variables that each monster's script keeps for itself. */
    MONSTER_VAR2_MAX   = 32, /**< Second set of variables that each monster's script keeps for itself. */
    MONSTER_SHARE_MAX  = 128 /**< Variables that every monster's script shares. */
};

/**
 *
 * Life states of a monster slot, as an active monster's state holds them.
 *
 */
enum ACTIVE_MONSTER_STATE {
    ACTIVE_MONSTER_NONE = 0, /**< The slot holds no monster. */
    ACTIVE_MONSTER_LIVE = 1, /**< The monster is alive. */
    ACTIVE_MONSTER_DEAD = 3  /**< The monster has died and is fading out. */
};

/**
 *
 * Whether a monster is within the player's sight, as an active monster's view_state holds it.
 *
 */
enum MONSTER_VIEW {
    MONSTER_VIEW_INIT     = 0, /**< Not yet checked since the monster was placed. */
    MONSTER_VIEW_OUT      = 1, /**< Out of sight and not drawn. */
    MONSTER_VIEW_IN       = 2, /**< In sight and drawn. */
    MONSTER_VIEW_FADE_IN  = 3, /**< Coming into sight, fading in. */
    MONSTER_VIEW_FADE_OUT = 4  /**< Going out of sight, fading out. */
};

/**
 *
 * Bits of an active monster's attrib, which its script sets and clears.
 *
 */
enum MONSTER_ATTRIB {
    MONSTER_ATTRIB_NO_LOCK_ON   = 0x1,   /**< The player cannot lock on to the monster. */
    MONSTER_ATTRIB_UNK_2        = 0x2,
    MONSTER_ATTRIB_SET_VELOCITY = 0x4,   /**< The walk towards the next position replaces the velocity instead of adding to it. */
    MONSTER_ATTRIB_NO_MAP_HIT   = 0x8,   /**< The monster moves without being checked against the map. */
    MONSTER_ATTRIB_NO_BODY_HIT  = 0x10,  /**< The monster moves without being pushed off other monsters. */
    MONSTER_ATTRIB_NO_DAMAGE    = 0x20,  /**< The monster takes no damage and cannot be stunned. */
    MONSTER_ATTRIB_QUICK_DEAD   = 0x40,  /**< The monster vanishes at once when it dies. */
    MONSTER_ATTRIB_UNK_80       = 0x80,
    MONSTER_ATTRIB_SKIP_GROUND  = 0x100, /**< The map check skips the search for ground. */
    MONSTER_ATTRIB_ALWAYS_VIEW  = 0x200  /**< The monster counts as in sight wherever it is. */
};

/**
 *
 * Bits of the statuses that hits leave on a monster, as MONSTER_STATUS::attr holds them.
 *
 */
enum MONSTER_STATUS_ATTR {
    MONSTER_STATUS_POISON = 0x1,  /**< Loses a share of its life every 120 steps. */
    MONSTER_STATUS_SLOW   = 0x2,  /**< Moves at half speed. */
    MONSTER_STATUS_UNK_8  = 0x8,  /**< Greyed out for a while; set by hits with attribute bit 0x8. */
    MONSTER_STATUS_UNK_20 = 0x20  /**< Greyed out for a while; set by hits with attribute bit 0x8000. */
};

/**
 *
 * Programs in a monster's script that the monster manager asks it to run, as an active monster's req_prog holds them.
 *
 */
enum MONSTER_PROG {
    MONSTER_PROG_RUNNING  = -1,   /**< Resumes the program that is already running. */
    MONSTER_PROG_INIT     = 100,  /**< Sets the monster up when it is placed. */
    MONSTER_PROG_MAIN     = 200,  /**< Runs the monster's normal behaviour. */
    MONSTER_PROG_STATUS   = 400,  /**< Reacts to a hit while greyed out, or to a hit that greys it out. */
    MONSTER_PROG_DAMAGE   = 500,  /**< Reacts to a hit that staggers it. */
    MONSTER_PROG_KNOCK    = 600,  /**< Reacts to a hit that knocks it over. */
    MONSTER_PROG_GUARD    = 700,  /**< Guards against a hit. */
    MONSTER_PROG_ESCAPE_0 = 800,  /**< Dodges the target's first kind of attack. */
    MONSTER_PROG_ESCAPE_1 = 900,  /**< Dodges the target's second kind of attack. */
    MONSTER_PROG_DEAD     = 1000, /**< Runs the monster's death. */
    MONSTER_PROG_LAND     = 1200, /**< Lands the monster after it has been thrown. */
    MONSTER_PROG_PIYORI   = 1400  /**< Stuns the monster. */
};

/**
 *
 * What a monster is linked with on the map, as an active monster's link_type holds it.
 *
 */
enum MONSTER_LINK {
    MONSTER_LINK_NONE  = 0, /**< Not linked. */
    MONSTER_LINK_PARTS = 1, /**< A map part follows the monster. */
    MONSTER_LINK_PIECE = 2  /**< The monster rides on a piece of a map part. */
};

/**
 *
 * Bits of MONSTER_SCOOP::type, saying when a photo of the monster can be taken.
 *
 */
enum MONSTER_SCOOP_TYPE {
    MONSTER_SCOOP_MOTION = 0x1, /**< While a named motion plays between two frames. */
    MONSTER_SCOOP_ALWAYS = 0x2  /**< At any time. */
};

/**
 *
 * Describes one kind of monster: its name, files, life and battle parameters.
 *
 */
struct BASE_MONSTER_TBL {
    s16   id;            /**< Number of the monster kind; the table ends at an entry with an empty name. */
    s16   grade;         /**< Grade of the monster that its script reads. */
    char  name[32];      /**< Name shown for the monster, loaded per language. */
    char  model[16];     /**< Base name of the monster's model and settings files under dungeon/monster. */
    char  script[16];    /**< Base name of the monster's script file under dungeon/monster. */
    s16   gift_type;     /**< Kind that picks the monster's row of the gift item table. */
    s32   sound_no;      /**< Number of the monster's sound bank under snd2/mon; 0 or less for none. */
    s32   unk_4c;
    s32   life;          /**< Life that the monster starts with. */
    s8    user_mons_id;  /**< Monster that the player can turn into to pass as this one; -1 for none. */
    u16   unk_56;
    u16   unk_58;
    s16   unk_5a;
    float whp;           /**< Wear that a melee hit on the monster does to the main character's weapon. */
    s16   gekirin_num;   /**< Hits that fill the monster's rage. */
    s8    guard_rate;    /**< Chance out of 100 that the monster guards a hit. */
    s8    escape_rate[2]; /**< Chances out of 100 that the monster dodges each kind of attack of its target. */
    s16   attack;        /**< Attack power of the monster. */
    u8    defense;       /**< Defence that is taken off the attack power of a hit. */
    s8    stagger;       /**< Stagger that hits must build up to make the monster flinch; 0 to flinch at every hit. */
    s8    boss;          /**< Nonzero for a boss, whose life is shown across the foot of the screen. */
    s8    sw_effect_num; /**< Number of sword after-images that the monster's model carries. */
    s16   unk_6c[8];
    s16   ext_param[12]; /**< Percentages that scale the damage of each kind of attack. */
    u32   unk_94;
    u32   unk_98;
    s32   next_id;       /**< Monster kind that is loaded along with this one; -1 for none. */
    union {
        s16 drop_item[3];
        s16 drop_items[3];
    };
    u32   resist_attr;   /**< Hit attribute bits that cannot leave statuses on the monster. */
    s16   unk_ac;
    s16   unk_ae;
    s8    unk_b0;
    s16   unk_b2;
    s16   unk_b4;
};

STATIC_ASSERT(sizeof(BASE_MONSTER_TBL) == 0xB8);

/**
 *
 * Says when a photo of a monster can be taken, and what the photo is.
 *
 */
struct MONSTER_SCOOP {
    s32   type;   /**< When a photo can be taken, MONSTER_SCOOP_TYPE bits; 0 never. */
    char *motion; /**< Name of the motion during which a photo can be taken. */
    float start;  /**< Motion frame from which a photo can be taken. */
    float end;    /**< Motion frame before which a photo can be taken. */
    s32   no;     /**< Number of the photo that is taken. */
    s32   ok;     /**< Nonzero while a photo can be taken this step. */
};

STATIC_ASSERT(sizeof(MONSTER_SCOOP) == 0x18);

/**
 *
 * Statuses that hits have left on a monster, with the time left on each.
 *
 */
struct MONSTER_STATUS {
    u32 attr;         /**< Statuses on the monster, MONSTER_STATUS_ATTR bits. */
    s16 poison_count; /**< Steps since poison last took life. */
    s16 grey_time;    /**< Steps left of MONSTER_STATUS_UNK_8 and MONSTER_STATUS_UNK_20. */
    s16 slow_time;    /**< Steps left of MONSTER_STATUS_SLOW. */
};

STATIC_ASSERT(sizeof(MONSTER_STATUS) == 0xC);

/**
 *
 * A monster out on the dungeon floor, run by its own script on top of an action character.
 *
 */
union ScriptVariable { int i; float f; };

class CActiveMonster : public CActionChara {
public:
    sceVu0FVECTOR    place_pos;       /**< Position at which the monster was placed, which its script can move. */
    CRunScript       mons_script;     /**< Interpreter that runs the monster's script. */
    BASE_MONSTER_TBL param;           /**< Monster's own copy of its kind's parameters, which its script can change. */
    BASE_MONSTER_TBL *base_tbl;       /**< Entry of the monster table for the monster's kind. */
    BASE_MONSTER_TBL *tbl;            /**< Parameters in use: param for a monster on the floor, the table entry for a loaded kind. */
    s16              refer_no;        /**< Loaded kind slot of the monster manager that the monster was made from. */
    s16              monster_id;      /**< Number of the monster's kind. */
    s16              req_prog;        /**< Program for the script to run next, a MONSTER_PROG value. */
    s16              now_prog;        /**< Program that the script last started. */
    ScriptVariable   var[MONSTER_VAR_MAX];   /**< Integer or float variables of the monster's script. */
    ScriptVariable   var2[MONSTER_VAR2_MAX]; /**< Second set of integer or float variables of the monster's script. */
    CMapParts        *link_parts;     /**< Map part that the monster is linked with; NULL for none. */
    CMapPiece        *link_piece;     /**< Piece of link_parts that the monster rides on; NULL for none. */
    s16              link_type;       /**< How the monster is linked with link_parts, a MONSTER_LINK value. */
    s32              unk_1208;
    s32              last_hit_chara;  /**< Battle character that dealt the killing hit, or -1. */
    s32              last_hit_source; /**< Kind of attacker that dealt the killing hit. */
    u32              last_hit_attr;   /**< Attribute bits of the hit that killed the monster. */
    CEnemyLifeGage   life_gage;       /**< Life gauge drawn over the monster. */
    CPiyori          piyori;          /**< Stars that circle the monster while it is stunned. */
    CGiftMark        gift_mark;       /**< Mark shown over the monster when it has been given a gift. */
    s16              att_type;        /**< Kind of the last attack that hit the monster. */
    MONSTER_SCOOP    scoop;           /**< When a photo of the monster can be taken. */
    void             *reserv_img[2];  /**< Images that the monster's script has loaded for later. */
    s32              reserv_img_size[2]; /**< Sizes, in bytes, of the reserved images. */
    sceVu0FVECTOR    center_pos;      /**< World position of the monster's first entered object, found each step. */
    s16              event_no;        /**< Event script that the monster's script asks to run; -1 for none. */
    s16              target_no;       /**< Scene character number of the monster's target; -1 for none. */
    s16              view_state;      /**< Whether the monster is in sight, a MONSTER_VIEW value. */
    float            view_alpha;      /**< Fade, from 0.0 to 1.0, of the monster coming into or going out of sight. */
    float            camera_alpha;    /**< Fade, from 0.0 to 1.0, that hides the monster when it is too near the camera. */
    s16              priority;        /**< Rank of the monster by distance to its target, 0 for the nearest; -1 for none. */
    float            target_dist;     /**< Distance to the target. */
    float            camera_dist;     /**< Distance to the camera. */
    float            clip_dist;       /**< Distance within which the monster comes into sight and its life gauge is drawn. */
    float            unk_1300;
    float            unk_1304;
    s16              unk_1308;
    float            height;          /**< Height of the monster above the ground. */
    s32              max_life;        /**< Life that fills the monster's life gauge. */
    s32              life;            /**< Life left. */
    u16              attack;          /**< Attack power, raised while the monster is enraged. */
    s16              gekirin_num;     /**< Hits that fill the monster's rage. */
    float            gekirin;         /**< Hits left before the monster is enraged; -1.0 for a boss. */
    s16              gekirin_time;    /**< Steps left of the monster's rage. */
    s16              unk_1322;
    u16              whp;             /**< Wear that a melee hit on the monster does to the main character's weapon. */
    u16              defense;         /**< Defence that is taken off the attack power of a hit. */
    s32              reward_exp;      /**< Weapon experience scattered when the monster dies. */
    s32              reward_money;    /**< Money scattered when the monster dies. */
    s32              state;           /**< Life state of the monster, an ACTIVE_MONSTER_STATE value. */
    s32              dead_alpha;      /**< Fade, from 128 down to 0, of a dead monster. */
    s16              piyori_mark;     /**< Steps left for which the stun stars are shown. */
    s16              piyori_time;     /**< Steps left of the monster's stun. */
    MONSTER_STATUS   status;          /**< Statuses that hits have left on the monster. */
    u32              attrib;          /**< Behaviour bits that the script sets, MONSTER_ATTRIB bits. */
    s32              unk_134c;
    s32              locate_param;    /**< Value given with the monster in the floor's list of monsters; -1 for none. */
    s16              gate_key;        /**< Gate key that the monster drops when it dies; 0 or less for none. */
    s16              no_damage_cnt;   /**< Hits that did the monster no damage. */
    s8               drop_badge;      /**< Nonzero to drop the monster transformation badge on death. */
    MoveCheckInfo    mons_move_check; /**< Result of checking the monster's move against the map. */
    sceVu0FVECTOR    next_pos;        /**< Position that the monster walks towards. */
    float            move_speed;      /**< Speed of the walk towards next_pos; 0.0 for none. */
    float            arrive_dist;     /**< Distance from next_pos at which the walk ends. */
    s32              unk_1488;
    s32              unk_148c;
    float            next_rot;        /**< Angle that the monster turns towards. */
    float            rot_speed;       /**< Speed of the turn towards next_rot; 0.0 for none. */

    /**
     * Makes a monster with an empty interpreter and a cleared map check.
     *
     * @mangled __ct__14CActiveMonsterFv
     * @address 0x1CF640
     * @size 0xB4
     */
    CActiveMonster() {
        mons_move_check.Clear();
    }

    /**
     * Says whether the monster is on the floor, and with alive_only set also alive.
     *
     * @mangled IsDraw__14CActiveMonsterFi
     * @address 0x1DAF60
     * @size 0x44
     */
    int IsDraw(int alive_only);

    /**
     * Steps the statuses on the monster, taking life for poison and flashing its colour.
     *
     * @mangled CheckStatusAttr__14CActiveMonsterFv
     * @address 0x1DAFB0
     * @size 0x1E4
     */
    void CheckStatusAttr();

    /**
     * Works out whether the monster comes into or goes out of sight, and gives back its MONSTER_VIEW state.
     *
     * @mangled CheckView__14CActiveMonsterFi
     * @address 0x1DB1A0
     * @size 0x104
     */
    int CheckView(int priority_limit);

    /**
     * Steps the monster as an action character.
     *
     * @mangled Step__14CActiveMonsterFv
     * @address 0x1DB2B0
     * @size 0x8
     */
    virtual void Step();

    /**
     * Copies this monster into another, and with memory given copies its model too.
     *
     * @mangled Copy__14CActiveMonsterFR14CActiveMonsterP9mgCMemory
     * @address 0x1DB2C0
     * @size 0x450
     */
    virtual void Copy(CActiveMonster &dest, mgCMemory *memory);

    /**
     * Puts the monster back to its initial state as an empty slot.
     *
     * @mangled Initialize__14CActiveMonsterFv
     * @address 0x1DC090
     * @size 0x194
     */
    virtual void Initialize();
};

STATIC_ASSERT(sizeof(CActiveMonster) == 0x14A0);

/**
 *
 * A loaded monster kind: the model, script and parameters that monsters of the kind are copied from.
 *
 */
struct MONSTER_REFER {
    s32            id;     /**< Number of the loaded monster kind; -1 while the slot is free. */
    CActiveMonster chara;  /**< Monster holding the kind's model, from which placed monsters are copied. */
    char           *script; /**< Copy of the kind's script file. */
};

STATIC_ASSERT(sizeof(MONSTER_REFER) == 0x14C0);

/**
 *
 * The floor's list of monsters to place, and which monster slots have been filled from it.
 *
 */
class CMonsterLocateInfo {
public:
    s32 num;                            /**< Number of entries in the list. */
    s32 put_num;                        /**< Number of monsters placed. */
    u32 put_flag;                       /**< One bit per monster slot that has been filled. */
    s16 monster_id[MONSTER_LOCATE_MAX]; /**< Monster kind of each entry; -1 for none. */
    s16 param[MONSTER_LOCATE_MAX];      /**< Value given to the monster of each entry; -1 for none. */

    /**
     * Marks a monster slot as filled or as free, keeping count of the monsters placed.
     *
     * @mangled SetPutFlag__18CMonsterLocateInfoFii
     * @address 0x1DC270
     * @size 0x78
     */
    void SetPutFlag(int no, int put);
};

STATIC_ASSERT(sizeof(CMonsterLocateInfo) == 0x8C);

/**
 *
 * Loads monster kinds, places monsters on the floor, and thinks for, damages and draws them.
 *
 */
class CMonsterMan {
public:
    CScene             *scene;                            /**< Scene that the monsters are in. */
    mgCMemory          memory[MONSTER_ACTIVE_MAX];        /**< Memory for the script stacks of each monster slot. */
    CActiveMonster     *active[MONSTER_ACTIVE_MAX];       /**< Monster of each slot, which is the scene character 24 slots on. */
    MONSTER_REFER      refer[MONSTER_REFER_MAX];          /**< Loaded monster kinds. */
    ScriptVariable     share_var[MONSTER_SHARE_MAX];      /**< Integer or float variables that every monster's script shares; scripts number them from 8. */
    CEffectScriptMan   *effect_man;                       /**< Effect scripts that the monsters start. */
    CMonsterLocateInfo locate;                            /**< The floor's list of monsters to place. */
    s16                priority_limit;                    /**< Number of nearest monsters that are let come into sight. */
    CEnemyLifeGage     boss_life_gage;                    /**< Life gauge of the bosses, drawn across the foot of the screen. */
    s32                boss_max_life;                     /**< Sum of the life of every boss placed. */

    /**
     * Takes the scene's monster characters as the slots and clears every slot and loaded kind.
     *
     * @mangled Initialize__11CMonsterManFP6CScene
     * @address 0x1DC2F0
     * @size 0x26C
     */
    void Initialize(CScene *scene);

    /**
     * Draws the effects of every monster.
     *
     * @mangled DrawEffectScript__11CMonsterManFv
     * @address 0x1DC560
     * @size 0x68
     */
    void DrawEffectScript();

    int CheckPhoto(CScene::InScreenCharaInfo *info);

    /**
     * Steps the effects of every monster.
     *
     * @mangled StepEffectScript__11CMonsterManFv
     * @address 0x1DC5D0
     * @size 0x68
     */
    void StepEffectScript();

    /**
     * Gets the distance to the nearest monster that the battle music answers to.
     *
     * @mangled IsBattleStyleDist__11CMonsterManFv
     * @address 0x1DC640
     * @size 0x118
     */
    float IsBattleStyleDist();

    /**
     * Finds the nearest monster that can be talked to, or gives back -1.
     *
     * @mangled CheckMonsterTolk__11CMonsterManFPf
     * @address 0x1DC760
     * @size 0x1DC
     */
    int CheckMonsterTolk(float *pos);

    /**
     * Has a frame catch the monster near it, or gives back NULL.
     *
     * @mangled CheckThrowTarget__11CMonsterManFP8mgCFrame
     * @address 0x1DC940
     * @size 0x188
     */
    CActiveMonster *CheckThrowTarget(mgCFrame *frame);

    /**
     * Finds the loaded kind slot of a monster kind, or gives back -1.
     *
     * @mangled SearchBaseIndex__11CMonsterManFi
     * @address 0x1DCAD0
     * @size 0x3C
     */
    int SearchBaseIndex(int id);

    /**
     * Counts the monsters on the floor within a distance of their target, or all of them for a distance below 0.
     *
     * @mangled GetMonsterNum__11CMonsterManFf
     * @address 0x1DCB10
     * @size 0x78
     */
    int GetMonsterNum(float dist);

    /**
     * Finds the monster table entry of a monster kind, or gives back NULL.
     *
     * @mangled GetReferPtr2__11CMonsterManFi
     * @address 0x1DCB90
     * @size 0x40
     */
    BASE_MONSTER_TBL *GetReferPtr2(int id);

    /**
     * Finds a monster slot that holds no monster, or gives back -1.
     *
     * @mangled SearchActiveMonsterBlock__11CMonsterManFv
     * @address 0x1DCBD0
     * @size 0x50
     */
    int SearchActiveMonsterBlock();

    /**
     * Finds a free loaded kind slot, or gives back -1.
     *
     * @mangled SearchReferBlock__11CMonsterManFv
     * @address 0x1DCC20
     * @size 0x40
     */
    int SearchReferBlock();

    /**
     * Loads a monster kind and every kind that it brings with it.
     *
     * @mangled EntryRefer__11CMonsterManFiP9mgCMemory
     * @address 0x1DCC60
     * @size 0xA0
     */
    int EntryRefer(int id, mgCMemory *memory);

    /**
     * Loads the model, sounds, sword after-images and script of a monster kind into a free slot.
     *
     * @mangled LoadReferMonsterFile__11CMonsterManFiP16BASE_MONSTER_TBLP9mgCMemory
     * @address 0x1DCD00
     * @size 0x348
     */
    int LoadReferMonsterFile(int id, BASE_MONSTER_TBL *tbl, mgCMemory *memory);

    /**
     * Places a monster of a loaded kind on the floor and runs its initialising program.
     *
     * @mangled SetActiveMonster__11CMonsterManFiPfPfi
     * @address 0x1DD050
     * @size 0xA98
     */
    CActiveMonster *SetActiveMonster(int refer_no, float *pos, float *rot, int param);

    /**
     * Draws the monsters on the mini-map.
     *
     * @mangled DrawMiniMapSymbol__11CMonsterManFP14CMiniMapSymbol
     * @address 0x1DDAF0
     * @size 0x13C
     */
    void DrawMiniMapSymbol(CMiniMapSymbol *symbol);

    /**
     * Draws the life gauges of the monsters in sight and the bosses' gauge.
     *
     * @mangled DrawLifeGage__11CMonsterManFii
     * @address 0x1DDC30
     * @size 0x20C
     */
    void DrawLifeGage(int hide_gekirin, int hide);

    /**
     * Draws the stun stars and gift marks of every monster.
     *
     * @mangled DrawPiyori__11CMonsterManFv
     * @address 0x1DDE40
     * @size 0x94
     */
    void DrawPiyori();

    /**
     * Draws the monsters that are wholly in sight.
     *
     * @mangled DrawActMonster__11CMonsterManFv
     * @address 0x1DDEE0
     * @size 0x100
     */
    void DrawActMonster();

    /**
     * Draws the monsters that are fading in or out.
     *
     * @mangled DrawInvisibleMonster__11CMonsterManFv
     * @address 0x1DDFE0
     * @size 0x16C
     */
    void DrawInvisibleMonster();

    /**
     * Draws the shadows of the monsters in sight.
     *
     * @mangled DrawShadowActMonster__11CMonsterManFv
     * @address 0x1DE150
     * @size 0x1DC
     */
    void DrawShadowActMonster();

    /**
     * Ranks the monsters on the floor by distance to their target.
     *
     * @mangled PriorityLevelCheck__11CMonsterManFv
     * @address 0x1DE330
     * @size 0x238
     */
    void PriorityLevelCheck();

    /**
     * Finds the monster of a rank, giving its scene character number too, or gives back NULL.
     *
     * @mangled GetPriorityLevelIndex__11CMonsterManFiPi
     * @address 0x1DE570
     * @size 0x70
     */
    CActiveMonster *GetPriorityLevelIndex(int priority, int *chara_no);

    /**
     * Stuns every monster within a distance of its target.
     *
     * @mangled SetNearAreaPiyori__11CMonsterManFf
     * @address 0x1DE8B0
     * @size 0x90
     */
    void SetNearAreaPiyori(float dist);

    /**
     * Takes the event script that a monster has asked to run, or gives back -1.
     *
     * @mangled IsRunEvent__11CMonsterManFv
     * @address 0x1DE940
     * @size 0x4C
     */
    int IsRunEvent();

    /**
     * Turns a monster's velocity away from the other monsters that it would run into.
     *
     * @mangled CollisionCheck__11CMonsterManFP14CActiveMonsterPfPfPf
     * @address 0x1DE990
     * @size 0x3F8
     */
    void CollisionCheck(CActiveMonster *monster, float *pos, float *velocity, float *out_velocity);

    /**
     * Takes the damage of every collision primitive that has hit a monster, and asks for the reaction to it.
     *
     * @mangled CheckDamage__11CMonsterManFv
     * @address 0x1DF5D0
     * @size 0x13F0
     */
    void CheckDamage();

    /**
     * Moves a monster by its velocity and walk against the other monsters and the map.
     *
     * @mangled MoveUnit__11CMonsterManFP14CActiveMonsterP6CCPolyi
     * @address 0x1E09C0
     * @size 0x5D8
     */
    void MoveUnit(CActiveMonster *monster, CCPoly *poly, int poly_num);

    /**
     * Runs one step of every monster: its sight, script, move, damage and death.
     *
     * @mangled ThinkHost__11CMonsterManFv
     * @address 0x1E0FA0
     * @size 0x9B8
     */
    void ThinkHost();

    /**
     * Runs the requested program of a monster's script, or resumes the one running.
     *
     * @mangled RunScript__11CMonsterManFi
     * @address 0x1E1AB0
     * @size 0xA8
     */
    void RunScript(int no);
};

STATIC_ASSERT(sizeof(CMonsterMan) == 0x100F0);

/**
 * Table of every monster kind, ended by an entry with an empty name.
 */
extern BASE_MONSTER_TBL base_monster_define[344];

/**
 * Finds the monster table entry of a monster kind, or gives back NULL.
 *
 * @mangled GetMonsterTable__Fi
 * @address 0x1DC230
 * @size 0x40
 */
BASE_MONSTER_TBL *GetMonsterTable(int id);

/**
 * Gets the distance along a line from a point to the map, or the distance given when nothing is hit.
 *
 * @mangled SearchArea__FP6CScenePfPff
 * @address 0x1DED90
 * @size 0x108
 */
float SearchArea(CScene *scene, float *from, float *to, float dist);

/**
 * Loads the monster names of a language.
 *
 * @mangled LoadMonsterLanguage__Fi
 * @address 0x1E1A30
 * @size 0x80
 */
void LoadMonsterLanguage(int language);
