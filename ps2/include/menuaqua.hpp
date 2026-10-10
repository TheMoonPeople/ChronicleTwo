#pragma once

#include "common.h"

#include <libvu0.h>

#include "character.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the aquarium menu, where the fish that Max has caught swim, eat
 * the food he drops, fight and pair up, and the fish race (gyorace) and
 * fishing tournament menus that pick fish from it and hand out prizes.
 */

class CDC2Mes;
class CGameDataUsed;
class CGyoRaceData;
class CUserDataManager;
class CWaterFrame;
class ClsMes;
class mgCFrame;
class mgCTexture;
struct BREEDFISH_USED;

class CAquaFish;
class CAquaFishEff;

/**
 *
 * Current command or prompt of CAquarium.
 *
 */
enum AQUARIUM_MODE {
    AQUARIUM_MODE_VIEW = 0,                /**< Views the tank without an open command window. */
    AQUARIUM_MODE_COMMAND = 1,             /**< Chooses an aquarium command. */
    AQUARIUM_MODE_FISH_INFO = 2,           /**< Selects a fish and displays its parameters. */
    AQUARIUM_MODE_TAKE_OUT = 3,            /**< Moves the selected fish into carried inventory. */
    AQUARIUM_MODE_TAKE_OUT_INFO = 4,       /**< Shows why a selected fish cannot be taken out. */
    AQUARIUM_MODE_RENAME_SELECT = 6,       /**< Chooses the fish to rename. */
    AQUARIUM_MODE_RENAME_GUIDE = 7,        /**< Shows the introductory rename message. */
    AQUARIUM_MODE_RENAME_BLOCKED = 8,      /**< Shows why the selected fish cannot be renamed. */
    AQUARIUM_MODE_MOVE_SELECT = 10,        /**< Chooses the fish to transfer to another tank. */
    AQUARIUM_MODE_SWITCH_TANK_SELECT = 11, /**< Chooses the tank to view. */
    AQUARIUM_MODE_MOVE_TANK_SELECT = 12,   /**< Chooses the destination of a fish transfer. */
    AQUARIUM_MODE_MOVE_INFO = 13,          /**< Shows why the selected transfer cannot proceed. */
    AQUARIUM_MODE_FOOD_SELECT = 14,        /**< Chooses food to drop into the tank. */
    AQUARIUM_MODE_FOOD_POSITION = 15,      /**< Positions the food above the water. */
    AQUARIUM_MODE_FOOD_WAIT = 16,          /**< Waits for the dropped food to disappear. */
    AQUARIUM_MODE_TRANSITION_WAIT = 17,    /**< Waits while the enclosing menu changes tank or opens name entry. */
};

/**
 *
 * Command in a slot of the aquarium command window.
 *
 */
enum AQUARIUM_COMMAND {
    AQUARIUM_COMMAND_NONE = -1,       /**< No command; pads the slots of a tank with fewer commands. */
    AQUARIUM_COMMAND_FISH_INFO = 0,   /**< Selects a fish and displays its parameters. */
    AQUARIUM_COMMAND_FEED = 1,        /**< Chooses food to drop into the tank. */
    AQUARIUM_COMMAND_RENAME = 2,      /**< Renames a fish. */
    AQUARIUM_COMMAND_TAKE_OUT = 3,    /**< Moves a fish into carried inventory. */
    AQUARIUM_COMMAND_MOVE = 4,        /**< Transfers a fish to another tank. */
    AQUARIUM_COMMAND_SWITCH_TANK = 5, /**< Chooses another tank to view. */
};

/**
 *
 * Stage of an aquarium breeding or electric-food transition.
 *
 */
enum AQUA_EVENT_PHASE {
    AQUA_EVENT_NONE = 0,                   /**< No breeding or electric-food transition is pending. */
    AQUA_EVENT_BREED_FADE_OUT = 1,         /**< Starts the white fade before breeding. */
    AQUA_EVENT_BREED_COMBINE = 2,          /**< Combines the parent fish after the fade. */
    AQUA_EVENT_BREED_FADE_IN_WAIT = 3,     /**< Waits for the fade before showing the offspring. */
    AQUA_EVENT_BREED_MESSAGE = 4,          /**< Waits for acknowledgement of the offspring message. */
    AQUA_EVENT_BREED_EFFECT_WAIT = 5,      /**< Waits for the breeding effect before fading out. */
    AQUA_EVENT_ELECTRIC_FADE_OUT = 10,     /**< Starts the white fade after electric food is eaten. */
    AQUA_EVENT_ELECTRIC_RELOAD = 11,       /**< Reloads the aquarium while preserving the fish transforms. */
    AQUA_EVENT_ELECTRIC_FADE_IN_WAIT = 12, /**< Waits for the fade before the electric-food message. */
    AQUA_EVENT_ELECTRIC_MESSAGE = 13,      /**< Waits for acknowledgement of the electric-food message. */
};

/**
 *
 * Stage of the enclosing aquarium menu and its fades.
 *
 */
enum AQUA_MENU_MODE {
    AQUA_MENU_INIT = 0,                 /**< Disables pad menu mode before opening the aquarium. */
    AQUA_MENU_OPEN_FADE_WAIT = 1,       /**< Waits for the opening fade while stepping the tank. */
    AQUA_MENU_ACTIVE = 2,               /**< Runs normal aquarium input and simulation. */
    AQUA_MENU_CLOSE_FADE_WAIT = 3,      /**< Waits for the closing fade. */
    AQUA_MENU_CLEAR = 4,                /**< Clears aquarium resources and restores the scene. */
    AQUA_MENU_TANK_FADE_IN_WAIT = 5,    /**< Waits for the fade after changing tanks. */
    AQUA_MENU_TANK_FADE_OUT_WAIT = 6,   /**< Waits for the fade before changing tanks. */
    AQUA_MENU_RENAME_FADE_OUT_WAIT = 7, /**< Waits for the fade before opening fish name entry. */
    AQUA_MENU_RENAME = 8,               /**< Runs fish name entry. */
    AQUA_MENU_RENAME_FADE_IN_WAIT = 9,  /**< Waits for the fade after fish name entry. */
};

/**
 *
 * How the pad steers the aquarium camera, as AquaCameraCtrlMode holds it.
 *
 */
enum AQUA_CAMERA_CTRL {
    AQUA_CAMERA_CTRL_FREE = 0, /**< Both sticks turn, raise and zoom the camera. */
    AQUA_CAMERA_CTRL_FOOD = 1, /**< The right stick turns and raises the camera at a fixed distance while the left positions the food. */
};

/**
 *
 * Events returned by fish parameter and aquarium collision updates.
 *
 */
enum AQUA_FISH_RESULT {
    AQUA_FISH_RESULT_ELECTRIC_FOOD_EATEN = 0x01,                                                          /**< A fish consumes electric food and requests its transition. */
    AQUA_FISH_RESULT_DEAD = 0x02,                                                                         /**< A fish has no remaining health. */
    AQUA_FISH_RESULT_BATTLE_HIT = 0x04,                                                                   /**< A fish takes damage from a battle collision. */
    AQUA_FISH_RESULT_FEEDING_EXHAUSTED = 0x08,                                                            /**< Food is eaten after normal feeding gains have been exhausted. */
    AQUA_FISH_RESULT_SEX_CHANGED_TO_0 = 0x10,                                                             /**< Special food changes the fish sex from one to zero. */
    AQUA_FISH_RESULT_SEX_CHANGED_TO_1 = 0x20,                                                             /**< Special food changes the fish sex from zero to one. */
    AQUA_FISH_RESULT_SEX_CHANGED = AQUA_FISH_RESULT_SEX_CHANGED_TO_0 | AQUA_FISH_RESULT_SEX_CHANGED_TO_1, /**< Special food changes either sex value. */
};

/**
 *
 * What a fish of the aquarium is doing, as CAquaFish::think_mode holds it.
 *
 */
enum AQUA_FISH_THINK {
    AQUA_FISH_THINK_REST = 0,        /**< Slows to a stop and waits out think_timer before swimming again. */
    AQUA_FISH_THINK_SWIM = 1,        /**< Swims about the tank in the way that swim_mode picks. */
    AQUA_FISH_THINK_FOOD_LOOK = 3,   /**< Turns towards food that has entered the water, then swims on. */
    AQUA_FISH_THINK_FOOD_EAT = 4,    /**< Swims to the sinking food to eat it. */
    AQUA_FISH_THINK_BATTLE = 5,      /**< Charges at another fish of the tank. */
    AQUA_FISH_THINK_BATTLE_REST = 6, /**< Rests at a random point between charges, recovering from fatigue. */
    AQUA_FISH_THINK_LOVE_SEARCH = 7, /**< Looks for another fish to pair with. */
    AQUA_FISH_THINK_LOVE_CHASE = 8,  /**< Follows the fish that pair_no names until the pair are bred. */
};

/**
 *
 * How a swimming fish picks its way, as CAquaFish::swim_mode holds it.
 *
 */
enum AQUA_FISH_SWIM {
    AQUA_FISH_SWIM_POINT = 0, /**< Heads for one point a little ahead of the fish. */
    AQUA_FISH_SWIM_ROUTE = 1, /**< Follows the route of tank points that NextRootNormal lays. */
    AQUA_FISH_SWIM_ROUND = 2, /**< Circles the tank, turning back at its walls. */
};

/**
 *
 * Bits of CAquaFish::col_flags, set by CAquarium::ColCheck each step.
 *
 */
enum AQUA_FISH_COL {
    AQUA_FISH_COL_WALL = 0x1,    /**< The fish was held inside the walls of the tank. */
    AQUA_FISH_COL_OBJECT = 0x2,  /**< The fish was pushed off one of the tank's ornaments. */
    AQUA_FISH_COL_FOOD = 0x4,    /**< The fish touched the sinking food. */
    AQUA_FISH_COL_FISH = 0x8,    /**< The fish was pushed off another fish. */
    AQUA_FISH_COL_TARGET = 0x10, /**< The fish that pushed this one is its action target. */
};

/**
 *
 * Stage of one bubble of a CBubble.
 *
 */
enum AQUA_BUBBLE_STATE {
    AQUA_BUBBLE_RISE = 0, /**< Wobbles up towards the surface. */
    AQUA_BUBBLE_POP = 1,  /**< Drifts at the surface and fades until its count runs out. */
    AQUA_BUBBLE_END = 2,  /**< Gone, waiting for the emitter to end or to make it again. */
};

/**
 *
 * Stage of the food that Max drops into the tank, as CFishFood::state holds it.
 *
 */
enum FISH_FOOD_STATE {
    FISH_FOOD_HOLD = 0,  /**< Held above the tank, following the cursor. */
    FISH_FOOD_DROP = 1,  /**< Falling through the air towards the water. */
    FISH_FOOD_ENTER = 2, /**< Reached the water this step. */
    FISH_FOOD_SINK = 3,  /**< Sinking through the water, ready to be eaten. */
};

/**
 *
 * One bubble of a CBubble emitter.
 *
 */
struct AQUA_BUBBLE {
    u8            pattern; /**< Row of the wobble tables while rising; steps left before vanishing while popping. */
    u8            state;   /**< Stage of the bubble, an AQUA_BUBBLE_STATE value. */
    float         phase;   /**< Angle, in radians, of the bubble's side-to-side wobble. */
    float         drift_x; /**< Sideways drift along x added at the surface. */
    float         drift_z; /**< Sideways drift along z added at the surface. */
    sceVu0FVECTOR pos;     /**< World position of the bubble. */
    float         alpha;   /**< Alpha that the bubble draws with. */
    u8            unk_24[0xC];
};

STATIC_ASSERT(sizeof(AQUA_BUBBLE) == 0x30);

/**
 *
 * Emitter of bubbles that rise from a point to the water surface.
 *
 */
class CBubble {
public:
    s8            one_shot;  /**< Nonzero to let finished bubbles end the emitter instead of rising again. */
    s8            active;    /**< Nonzero while the emitter moves and draws its bubbles. */
    u32           generated; /**< Bubbles made since the emitter was last started. */
    u8            unk_08[0x8];
    sceVu0FVECTOR origin;     /**< Point that the bubbles rise from. */
    float         surface_y;  /**< Height at which the bubbles reach the surface. */
    float         height;     /**< Distance from the origin up to the surface. */
    mgCTexture   *texture;    /**< Texture that the bubbles draw from. */
    s16           tex_u;      /**< Left edge of the bubble image in the texture. */
    s16           tex_v;      /**< Top edge of the bubble image in the texture. */
    u32           bubble_num; /**< Number of entries in bubble. */
    AQUA_BUBBLE  *bubble;     /**< Bubbles of the emitter. */
    u8            unk_38[0x8];

    /**
     *
     * Starts one bubble again at a random point around the origin.
     *
     * @mangled Generate__7CBubbleFi
     * @address 0x20E6B0
     * @size 0x104
     */
    void Generate(int index);

    /**
     *
     * Moves the origin and starts the next bubble from it; says whether a bubble was left to start.
     *
     * @mangled Generate__7CBubbleFPf
     * @address 0x20E7C0
     * @size 0x88
     */
    int Generate(float *pos);

    /**
     *
     * Sets the texture and the corner of the image that the bubbles draw with.
     *
     * @mangled SetTexture__7CBubbleFP10mgCTextureii
     * @address 0x20E850
     * @size 0x10
     */
    void SetTexture(mgCTexture *image, int u, int v);

    /**
     *
     * Moves every bubble one step, rising, popping or starting it again.
     *
     * @mangled Step__7CBubbleFv
     * @address 0x20E860
     * @size 0x2B4
     */
    void Step();

    /**
     *
     * Draws every bubble that has not ended as a sprite.
     *
     * @mangled Draw__7CBubbleFv
     * @address 0x20EB20
     * @size 0x154
     */
    void Draw();

    /**
     *
     * Allocates the bubbles from memory and scatters them between the origin and the surface.
     *
     * @mangled Initialize__7CBubbleFP9mgCMemoryPfif
     * @address 0x20EC80
     * @size 0xF0
     */
    void Initialize(mgCMemory *memory, float *start_pos, int count, float top);

    /**
     *
     * Stops the emitter and forgets the bubbles it has made.
     *
     * @mangled RunOff__7CBubbleFv
     * @address 0x20ED70
     * @size 0xC
     */
    void RunOff();
};

STATIC_ASSERT(sizeof(CBubble) == 0x40);

/**
 *
 * Stage of a battle or battle rest, as CAquaFishActionParam::phase holds it.
 *
 */
enum AQUA_FISH_ACTION_PHASE {
    AQUA_FISH_ACTION_APPROACH = 0,    /**< Swims at the target fish until the two touch. */
    AQUA_FISH_ACTION_SWING_START = 1, /**< Starts the battle motion after touching the target. */
    AQUA_FISH_ACTION_SWING = 2,       /**< Swings at the target fish, then charges it until the two touch again. */
    AQUA_FISH_ACTION_REST_MOVE = 3,   /**< Swims to the resting point of a battle rest. */
    AQUA_FISH_ACTION_REST = 4,        /**< Rests at the resting point, recovering health and fatigue. */
};

/**
 *
 * Steering of a fish within one action: its phase, timer, target and speed.
 *
 */
class CAquaFishActionParam {
public:
    s16        phase;     /**< Stage of the action; in battles an AQUA_FISH_ACTION_PHASE value. */
    s32        timer;     /**< Steps left in the stage. */
    s16        target_no; /**< Tank slot of the fish that the action is aimed at; below zero for none. */
    CAquaFish *target;    /**< Fish that the action is aimed at. */
    float      speed;     /**< Speed of the fish while it circles the tank. */
    float      max_speed; /**< Speed that speed builds up to. */
    u8         unk_18[0x18];
    float      decel;     /**< Factor that the fish's movement is scaled by each step while it slows. */
    s32        hit_count; /**< Times the fish has bumped into others during the action. */
    u8         unk_38[0x8];

    /**
     *
     * Clears the whole action.
     *
     * @mangled Initialize__20CAquaFishActionParamFv
     * @address 0x20EEB0
     * @size 0xC
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CAquaFishActionParam) == 0x40);

/**
 *
 * Way of circling the tank of a fish whose swim_mode is AQUA_FISH_SWIM_ROUND.
 *
 */
struct AQUA_FISH_ROUND {
    s16   dir;   /**< Way round the tank, 0 or 1, that picks the turn-back angles. */
    float width; /**< Fraction of the tank's half width at which the fish turns back. */
    float depth; /**< Fraction of the tank's half depth at which the fish turns back. */
    float wave;  /**< Angle, in radians, of the fish's up-and-down weave. */
};

STATIC_ASSERT(sizeof(AQUA_FISH_ROUND) == 0x10);

/**
 *
 * What CAquaFish::NextThink needs to start a new action.
 *
 */
struct NEXT_THINK_PARAM {
    sceVu0FVECTOR pos;       /**< Position of the food that the fish heads for. */
    CAquaFishEff *effect;    /**< Icon of the fish, started when it goes to eat. */
    CAquaFish    *target;    /**< Fish to fight. */
    s16           target_no; /**< Tank slot of target; below zero for none. */
};

STATIC_ASSERT(sizeof(NEXT_THINK_PARAM) == 0x20);

/**
 *
 * Fish of the aquarium, a character steered by its think mode and kept in
 * step with the fish's data in the save.
 *
 */
class CAquaFish : public CCharacter2 {
public:
    sceVu0FVECTOR        target_pos;  /**< Point that the fish heads for. */
    sceVu0FVECTOR        move;        /**< Distance that the fish moves this step. */
    sceVu0FVECTOR        target_rot;  /**< Rotation that the fish turns towards. */
    sceVu0FVECTOR        turn;        /**< x: angle of pitch turned each step; y: steps to turn the yaw to target_rot. */
    s16                  aqua_no;     /**< Tank slot of the fish, the index of its icon and bubbles. */
    float                radius;      /**< Size of the fish's body for collisions. */
    s32                  think_timer; /**< Steps that the think mode has run or has left. */
    s16                  pair_no;     /**< Tank slot of the fish chased in AQUA_FISH_THINK_LOVE_CHASE; -1 for none. */
    s16                  think_mode;  /**< What the fish is doing, an AQUA_FISH_THINK value. */
    s16                  swim_mode;   /**< Way of swimming, an AQUA_FISH_SWIM value. */
    u8                   unk_6b2[0xE];
    CAquaFishActionParam action; /**< Steering of the current action. */

    union {
        AQUA_FISH_ROUND round;        /**< Way of circling the tank in AQUA_FISH_SWIM_ROUND. */
        float           charge_angle; /**< Angle, in radians, of the swing of a charge in AQUA_FISH_THINK_BATTLE. */
    };

    sceVu0FVECTOR  route[32];  /**< Points of the route of AQUA_FISH_SWIM_ROUTE. */
    s16            route_num;  /**< Number of points in route. */
    s16            route_no;   /**< Point of route that the fish heads for. */
    s32            route_time; /**< Steps spent heading for the current point of route. */
    u8             unk_918[0x8];
    s16            eat_item;     /**< Item number of the food that the fish has just eaten; 0 for none. */
    s8             swim_variant; /**< Swimming variant index that wraps after the eighth value. */
    u32            col_flags;    /**< What the fish touched this step, AQUA_FISH_COL bits. */
    s32            wall_time;    /**< Steps that the fish has kept touching the walls while circling. */
    s32            fatigue;      /**< Fatigue built up by fighting. */
    s32            fatigue_max;  /**< Fatigue at which the fish stops fighting to rest. */
    s32            flash_count;  /**< Counter, from 0 to 24, of the brightening of a fish low on life. */
    CGameDataUsed *data;         /**< Fish's data in the save; NULL for none. */

    /**
     *
     * Makes a fish with no data.
     *
     * @mangled __ct__9CAquaFishFv
     * @address 0x20EEC0
     * @size 0xD4
     */
    CAquaFish();

    /**
     *
     * Clears the character and the fish's movement, action and data.
     *
     * @mangled Initialize__9CAquaFishFv
     * @address 0x20EFA0
     * @size 0xB4
     */
    virtual void Initialize();

    /**
     *
     * Gives the fish its data and works out the fatigue at which it stops fighting.
     *
     * @mangled SetLiveParam__9CAquaFishFP13CGameDataUsed
     * @address 0x20F060
     * @size 0x7C
     */
    void SetLiveParam(CGameDataUsed *item);

    /**
     *
     * Scales the fish to the size in its data and sizes its body to match.
     *
     * @mangled SetAdjustScale__9CAquaFishFv
     * @address 0x20F0E0
     * @size 0x8C
     */
    void SetAdjustScale();

    /**
     *
     * Adds to the fish's fatigue, keeping it between 0 and 10000000; gives the new fatigue.
     *
     * @mangled AddFatigue__9CAquaFishFi
     * @address 0x20F170
     * @size 0x40
     */
    int AddFatigue(int amount);

    /**
     *
     * Gives the screen position of the fish as seen by the aquarium camera.
     *
     * @mangled GetPosition2D__9CAquaFishFPi
     * @address 0x20F1B0
     * @size 0xA0
     */
    void GetPosition2D(int *out);

    /**
     *
     * Gives the direction that the fish faces.
     *
     * @mangled GetDirVect__9CAquaFishFPf
     * @address 0x20F250
     * @size 0x74
     */
    void GetDirVect(float *out);

    /**
     *
     * Sets the fish moving straight at target_pos at a speed.
     *
     * @mangled NormalGetNextVelo__9CAquaFishFf
     * @address 0x20F2D0
     * @size 0x7C
     */
    void NormalGetNextVelo(float speed);

    /**
     *
     * Turns the fish's target yaw towards target_pos.
     *
     * @mangled NormalGetNextRotY__9CAquaFishFv
     * @address 0x20F350
     * @size 0x64
     */
    void NormalGetNextRotY();

    /**
     *
     * Turns the fish's target pitch and yaw towards target_pos.
     *
     * @mangled NormalGetNextRot__9CAquaFishFv
     * @address 0x20F3C0
     * @size 0xF4
     */
    void NormalGetNextRot();

    /**
     *
     * Scales a speed by the fish's parameters for its think mode, capped for the mode.
     *
     * @mangled CalcMoveSpeed__9CAquaFishFf
     * @address 0x20F4C0
     * @size 0x220
     */
    float CalcMoveSpeed(float speed);

    /**
     *
     * Lays a new random route through the tank and heads for its first point.
     *
     * @mangled NextRootNormal__9CAquaFishFv
     * @address 0x20F6E0
     * @size 0x280
     */
    void NextRootNormal();

    /**
     *
     * Moves the fish one step of circling the tank.
     *
     * @mangled MoveActionRound__9CAquaFishFv
     * @address 0x20F960
     * @size 0x2D4
     */
    void MoveActionRound();

    /**
     *
     * Moves the fish one step of charging at its target.
     *
     * @mangled MoveActionBattle__9CAquaFishFv
     * @address 0x20FC40
     * @size 0x318
     */
    void MoveActionBattle();

    /**
     *
     * Starts a think mode, setting up the fish's motion, target and timers for it.
     *
     * @mangled NextThink__9CAquaFishFiP16NEXT_THINK_PARAM
     * @address 0x20FF60
     * @size 0x6AC
     */
    void NextThink(int think, NEXT_THINK_PARAM *param);

    /**
     *
     * Updates the fish's data for a step, applying food it ate; gives bits of what happened.
     *
     * @mangled ParamStep__9CAquaFishFv
     * @address 0x210610
     * @size 0x3F0
     */
    int ParamStep();

    /**
     *
     * Draws the fish, brighter now and then when it is low on life.
     *
     * @mangled FishDraw__9CAquaFishFv
     * @address 0x210A00
     * @size 0x88
     */
    void FishDraw();
};

STATIC_ASSERT(sizeof(CAquaFish) == 0x940);

/**
 *
 * Icon that floats above a fish of the aquarium for a time.
 *
 */
class CAquaFishEff {
public:
    CAquaFish  *fish;    /**< Fish that the icon floats above; NULL for none. */
    mgCTexture *texture; /**< Texture of the icons. */
    u16         type;    /**< Icon shown, 1 to 5; 0 for none. */
    s32         timer;   /**< Steps left to show the icon. */

    /**
     *
     * Clears the icon and its fish.
     *
     * @mangled Initialize__12CAquaFishEffFv
     * @address 0x210A90
     * @size 0x14
     */
    void Initialize();

    /**
     *
     * Shows an icon for the time that the icon's type gives.
     *
     * @mangled StartFishEffect__12CAquaFishEffFi
     * @address 0x210AB0
     * @size 0x24
     */
    void StartFishEffect(int effect_kind);

    /**
     *
     * Counts down the icon's time, hiding it when the time runs out.
     *
     * @mangled Step__12CAquaFishEffFv
     * @address 0x210AE0
     * @size 0x40
     */
    void Step();

    /**
     *
     * Draws the icon bobbing above the fish, fading out at the end of its time.
     *
     * @mangled Draw__12CAquaFishEffFv
     * @address 0x210B20
     * @size 0x350
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CAquaFishEff) == 0x10);

/**
 *
 * Food that Max drops into the aquarium, a character that falls, sinks and
 * sways until a fish eats it.
 *
 */
class CFishFood : public CCharacter2 {
public:
    sceVu0FVECTOR spin;       /**< Angle, in radians, that the food turns about x and z each step. */
    sceVu0FVECTOR pos;        /**< Position of the food before its sway. */
    s16           item_no;    /**< Item number of the food. */
    s32           fall_time;  /**< Steps that the food has fallen through the air. */
    float         sway;       /**< Size of the food's side-to-side sway as it sinks. */
    float         sway_phase; /**< Angle, in radians, of the sway. */
    u8            state;      /**< Stage of the food, a FISH_FOOD_STATE value. */

    /**
     *
     * Makes food held above the tank.
     *
     * @mangled __ct__9CFishFoodFv
     * @address 0x210E70
     * @size 0xE0
     */
    CFishFood();

    /**
     *
     * Moves the food, still held, to a position.
     *
     * @mangled SetDropPosition__9CFishFoodFPf
     * @address 0x210F50
     * @size 0x1C
     */
    void SetDropPosition(float *pos);

    /**
     *
     * Lets the food fall, with a random spin and sway.
     *
     * @mangled Drop__9CFishFoodFv
     * @address 0x210F70
     * @size 0xB4
     */
    void Drop();

    /**
     *
     * Moves the food one step of falling or sinking, keeping it off the ornaments and in the tank.
     *
     * @mangled Step__9CFishFoodFv
     * @address 0x211030
     * @size 0x414
     */
    virtual void Step();
};

STATIC_ASSERT(sizeof(CFishFood) == 0x6A0);

/**
 *
 * Message windows of the aquarium: its title, menu, questions, guidance,
 * button help, information and the messages about one fish.
 *
 */
class CAquaMes {
public:
    mgCMemory *memory;           /**< Memory that the windows were allocated from; NULL for none. */
    ClsMes    *title_mes;        /**< Window of the aquarium's title. */
    s32        title_id;         /**< Message shown in title_mes. */
    u8         title_draw;       /**< Nonzero to draw title_mes. */
    ClsMes    *menu_mes;         /**< Window of the aquarium menu. */
    s32        menu_cursor;      /**< Item of menu_mes under the cursor. */
    u8         menu_draw;        /**< Nonzero to draw menu_mes. */
    u8         cursor_snap;      /**< Nonzero to move the cursor straight to cursor_target on the next step. */
    u8         cursor_draw;      /**< Nonzero to draw the hand cursor. */
    float      cursor_target[2]; /**< Screen position that the hand cursor moves to. */
    float      cursor_pos[2];    /**< Screen position of the hand cursor. */
    ClsMes    *question_mes;     /**< Window of a question with choices. */
    s32        question_cursor;  /**< Choice of question_mes under the cursor. */
    u8         question_draw;    /**< Nonzero to draw question_mes. */
    s16        question_num;     /**< Number of choices in question_mes. */
    ClsMes    *guide_mes;        /**< Window of guidance about what is happening in the tank. */
    s32        guide_id;         /**< Message shown in guide_mes. */
    u8         guide_draw;       /**< Nonzero to draw guide_mes. */
    ClsMes    *help_mes;         /**< Window of the button help at the bottom of the screen. */
    u8         help_draw;        /**< Nonzero to draw help_mes. */
    ClsMes    *info_mes;         /**< Window of information. */
    u8         info_draw;        /**< Nonzero to draw info_mes. */
    ClsMes    *fish_mes;         /**< Window about one fish, shown next to it. */
    s32        fish_mes_time;    /**< Steps left to show fish_mes. */
    s32        unk_5c;
    s32        unk_60;

    /**
     *
     * Makes the messages with no windows.
     *
     * @mangled __ct__8CAquaMesFv
     * @address 0x211640
     * @size 0x2C
     */
    CAquaMes();

    /**
     *
     * Clears the messages and, given memory, makes and lays out every window and loads the message file.
     *
     * @mangled Initialize__8CAquaMesFP9mgCMemory
     * @address 0x211670
     * @size 0x16A8
     */
    void Initialize(mgCMemory *memory);

    /**
     *
     * Shows the title and menu of one of the three aquariums.
     *
     * @mangled SettingAquaMes__8CAquaMesFi
     * @address 0x212D20
     * @size 0x9C
     */
    void SettingAquaMes(int kind);

    /**
     *
     * Shows a title, centred in the title box.
     *
     * @mangled SetTitleId__8CAquaMesFi
     * @address 0x212DC0
     * @size 0x9C
     */
    void SetTitleId(int id);

    /**
     *
     * Moves the menu cursor, wrapping round; says whether it moved.
     *
     * @mangled AddMenuCursor__8CAquaMesFii
     * @address 0x212E60
     * @size 0x48
     */
    int AddMenuCursor(int step, int count);

    /**
     *
     * Shows a question; the food question lists the foods Max has with their counts.
     *
     * @mangled SetQuestionId__8CAquaMesFiii
     * @address 0x212EB0
     * @size 0x234
     */
    void SetQuestionId(int id, int top, int num);

    /**
     *
     * Moves the question cursor by the pad; gives 0 when it did not move.
     *
     * @mangled AddQuestionCursor__8CAquaMesFv
     * @address 0x2130F0
     * @size 0xE8
     */
    int AddQuestionCursor();

    /**
     *
     * Shows a button help message at the bottom of the screen.
     *
     * @mangled SetCtrlHelpId__8CAquaMesFi
     * @address 0x2131E0
     * @size 0x88
     */
    void SetCtrlHelpId(int id);

    /**
     *
     * Shows an information message.
     *
     * @mangled SetInfoMsgID__8CAquaMesFi
     * @address 0x213270
     * @size 0x3C
     */
    void SetInfoMsgID(int id);

    /**
     *
     * Shows a message, naming the fish, about the fish eating, next to it.
     *
     * @mangled EatMessage__8CAquaMesFiP9CAquaFish
     * @address 0x2132B0
     * @size 0x98
     */
    void EatMessage(int id, CAquaFish *fish);

    /**
     *
     * Shows a message, naming the fish, about the fish changing sex, next to it.
     *
     * @mangled ChangeManMessage__8CAquaMesFP9CAquaFish
     * @address 0x213350
     * @size 0xC0
     */
    void ChangeManMessage(CAquaFish *fish);

    /**
     *
     * Shows a message, naming the fish, about the fish dying, next to it.
     *
     * @mangled DeadMessage__8CAquaMesFP9CAquaFish
     * @address 0x213410
     * @size 0x90
     */
    void DeadMessage(CAquaFish *fish);

    /**
     *
     * Steps every window and moves the hand cursor towards its target.
     *
     * @mangled Step__8CAquaMesFv
     * @address 0x2134A0
     * @size 0x1AC
     */
    void Step();

    /**
     *
     * Draws every window that is shown, but the title, and the hand cursor.
     *
     * @mangled Draw__8CAquaMesFv
     * @address 0x213650
     * @size 0x160
     */
    void Draw();

    /**
     *
     * Draws the title window when it is shown.
     *
     * @mangled DrawTitleMes__8CAquaMesFv
     * @address 0x2137B0
     * @size 0x58
     */
    void DrawTitleMes();
};

STATIC_ASSERT(sizeof(CAquaMes) == 0x64);

/**
 *
 * The aquarium menu: the tank, its models and water, its fish, the food
 * that Max drops and the pairing of fish.
 *
 */
class CAquarium {
public:
    s32               mode;               /**< Stage of the menu that Step runs. @see AQUARIUM_MODE */
    u_long128        *load_buf;           /**< Buffer that files are loaded into. */
    mgCMemory         load_stack;         /**< Memory over load_buf. */
    s32               tex_block[13];      /**< Texture blocks that the menu was given, ending in -1. */
    CUserDataManager *user_data;          /**< Max's data in the save. */
    mgCMemory         aqua_stack;         /**< Memory of the tank's models and images. */
    mgCFrame         *ground_frame;       /**< Model of the tank's floor. */
    mgCFrame         *glass_frame;        /**< Model of the tank's glass. */
    mgCFrame         *aqua_frame;         /**< Model of the tank. */
    mgCFrame         *mizu_frame;         /**< Model of the water in the tank. */
    s16               ground_tex_block;   /**< Texture block of the floor's images. */
    s16               glass_tex_block;    /**< Texture block of the glass's images. */
    s16               aqua_tex_block;     /**< Texture block of the tank's images. */
    CWaterFrame      *water;              /**< Rippling water surface. */
    s16               water_tex_block;    /**< Texture block of the water's images. */
    mgCFrame         *suimen_frame;       /**< Model of the water surface. */
    float             ripple;             /**< Strength of the surface's ripple, raised when food lands. */
    mgCMemory         naka_stack;         /**< Memory of naka_frame. */
    mgCFrame         *naka_frame;         /**< Model inside the first aquarium; NULL for the others. */
    CAquaMes          mes;                /**< Message windows of the menu. */
    mgCMemory         mes_stack;          /**< Memory of the message windows and the menu's images. */
    s16               menu_tex_block;     /**< Texture block of the menu's images. */
    mgCMemory         fish_stack[6];      /**< Memory of each fish's model. */
    CAquaFish        *fish[6];            /**< Fish in each slot of the tank; NULL for none. */
    s16               fish_tex_block[6];  /**< Texture block of each fish's images. */
    s16               sel_fish;           /**< Slot of the fish under the cursor; -1 for none. */
    char              target_name[0x20];  /**< Name of target_fish for the messages. */
    char              partner_name[0x20]; /**< Name of partner_fish for the messages. */
    s16               target_fish;        /**< Slot of the fish that a pairing or special food concerns. */
    s16               partner_fish;       /**< Slot of the fish that target_fish pairs with. */
    u8                fish_info_draw;     /**< Nonzero to draw the data of sel_fish. */
    CFishFood        *food;               /**< Food that Max drops; NULL for none. */
    s16               food_tex_block;     /**< Texture block of the food's images. */
    s16               unk_326;
    sceVu0FVECTOR     drop_pos;  /**< Position that the food is held at before it drops. */
    s32               food_time; /**< Steps left before dropped food is taken away. */
    u8                unk_344[0x40];
    u8                drop_root_draw; /**< Nonzero to draw the line below the held food. */
    s16               unk_386;
    s16               love_phase;     /**< Stage of the breeding or electric-food transition. @see AQUA_EVENT_PHASE */
    s16               love_time;      /**< Steps spent in love_phase. */
    s16               love_tex_block; /**< Texture block of love_chara's images. */
    CCharacter2      *love_chara;     /**< Effect shown when two fish pair; NULL outside the third aquarium. */
    mgCMemory         food_stack;     /**< Memory of the food's model. */

    /**
     *
     * Makes the aquarium with its memories empty and no texture blocks.
     *
     * @mangled __ct__9CAquariumFv
     * @address 0x214570
     * @size 0xF8
     */
    CAquarium();

    /**
     *
     * Forgets every model, fish, texture block and the sound port of the aquarium.
     *
     * @mangled Clear__9CAquariumFv
     * @address 0x214670
     * @size 0x184
     */
    void Clear();

    /**
     *
     * Sets up the menu's memories, effects, bubbles and tank tables, loads its sound, images and messages, and sets up the aquarium.
     *
     * @mangled Initialize__9CAquariumFP9mgCMemoryPi
     * @address 0x214800
     * @size 0x7FC
     */
    void Initialize(mgCMemory *memory, int *blocks);

    /**
     *
     * Loads the model of a fish into a tank slot and puts it at a random place; says whether it loaded.
     *
     * @mangled LoadFish__9CAquariumFiP13CGameDataUsed
     * @address 0x215000
     * @size 0x344
     */
    int LoadFish(int no, CGameDataUsed *data);

    /**
     *
     * Loads the models of the aquarium chosen in the save and the fish in it, and starts them thinking.
     *
     * @mangled SettingAqua__9CAquariumFv
     * @address 0x215350
     * @size 0xBB4
     */
    void SettingAqua();

    /**
     *
     * Breeds the fish in two tank slots.
     *
     * @mangled CombineFish__9CAquariumFii
     * @address 0x215FE0
     * @size 0x45C
     */
    void CombineFish(int no1, int no2);

    /**
     *
     * Picks a random other fish of the tank; gives its slot, or -1 when none was picked.
     *
     * @mangled GetBattleTarget__9CAquariumFi
     * @address 0x216440
     * @size 0xA0
     */
    int GetBattleTarget(int slot);

    /**
     *
     * Runs one step of the think mode of the fish in a slot and starts the mode that follows.
     *
     * @mangled Thinking__9CAquariumFi
     * @address 0x2164E0
     * @size 0xD0C
     */
    void Thinking(int no);

    /**
     *
     * Keeps the fish in a slot off the other fish, the ornaments and the walls, feeds it, and turns it; gives bits of what happened.
     *
     * @mangled ColCheck__9CAquariumFi
     * @address 0x2171F0
     * @size 0x6F8
     */
    int ColCheck(int no);

    /**
     *
     * Puts the cursor on the first fish of the tank; gives 1 when there is none.
     *
     * @mangled InitSelFish__9CAquariumFv
     * @address 0x2178F0
     * @size 0x90
     */
    int InitSelFish();

    /**
     *
     * Moves the cursor to the next or previous fish by the pad, or to the next when forced.
     *
     * @mangled SelectFish__9CAquariumFi
     * @address 0x217980
     * @size 0x114
     */
    void SelectFish(int force);

    /**
     *
     * Moves the hand cursor next to the fish under the cursor.
     *
     * @mangled SelFishSetCursor__9CAquariumFv
     * @address 0x217AA0
     * @size 0xDC
     */
    void SelFishSetCursor();

    /**
     *
     * Runs one step of the menu, its fish, food, bubbles and pairing; gives nonzero when the menu ends.
     *
     * @mangled Step__9CAquariumFv
     * @address 0x217B80
     * @size 0x1B04
     */
    int Step();

    /**
     *
     * Draws the tank, its fish, food, bubbles, water and windows.
     *
     * @mangled Draw__9CAquariumFv
     * @address 0x219690
     * @size 0xE78
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CAquarium) == 0x3D0);

/**
 *
 * Fish that race against Max's in each class of the fish race, loaded from
 * the race's script.
 *
 */
class CGyoraceFishData {
public:
    s16            fish_num[4]; /**< Number of fish of each class. */
    CGameDataUsed *fish[4];     /**< Fish of each class. */

    /**
     *
     * Loads the race fish script into a buffer and runs it to build the fish; gives 0 without memory.
     *
     * @mangled LoadData__16CGyoraceFishDataFP9mgCMemoryP1
     * @address 0x21B7D0
     * @size 0xD4
     */
    int LoadData(mgCMemory *memory, u_long128 *buffer);

    /**
     *
     * Gives a fish of a class, or NULL when there is no such fish.
     *
     * @mangled GetRaceFish__16CGyoraceFishDataFii
     * @address 0x21B8B0
     * @size 0x74
     */
    CGameDataUsed *GetRaceFish(int race_class, int index);
};

/**
 *
 * One prize of the fish race or the fishing tournament.
 *
 */
struct FISH_PRIZE_INFO {
    s32 unk_0;
    s32 unk_4;
};

STATIC_ASSERT(sizeof(FISH_PRIZE_INFO) == 0x8);

/**
 *
 * Lists the item numbers of the foods that can be fed to the fish; gives
 * how many, one fewer when Max has none of the special food.
 *
 * @mangled GetUseableEsaNo__FPi
 * @address 0x20E5C0
 * @size 0x84
 */
int GetUseableEsaNo(int *out);

/**
 *
 * Scales a fish's size against the size in its breeding data, capped at a
 * maximum.
 *
 * @mangled SetFishAdjustScale__Fiiff
 * @address 0x20EE30
 * @size 0x74
 */
float SetFishAdjustScale(int length, int item_no, float scale, float max);

/**
 *
 * Draws a dotted line down from the food to a height, showing where it will
 * fall.
 *
 * @mangled DrawEsaDropRoot__FP9CFishFoodf
 * @address 0x211450
 * @size 0x13C
 */
void DrawEsaDropRoot(CFishFood *food, float bottom);

/**
 *
 * Places a window next to a screen position, keeping it on the screen.
 *
 * @mangled AquaMesDispAdjustPos__FP6ClsMesPi
 * @address 0x211590
 * @size 0xA8
 */
void AquaMesDispAdjustPos(ClsMes *window, int *pos);

/**
 *
 * Makes the path of the image file of a fish's colouring; says whether the
 * fish has one.
 *
 * @mangled GetFishImgPath__FPciP14BREEDFISH_USED
 * @address 0x213870
 * @size 0x84
 */
int GetFishImgPath(char *out, int item_no, BREEDFISH_USED *fish);

/**
 *
 * Gives one of the two colour numbers of a fish's images.
 *
 * @mangled GetFishImageColor__Fii
 * @address 0x213900
 * @size 0x64
 */
int GetFishImageColor(int item_no, int sex);

/**
 *
 * Replaces the images of a fish's model with those of its colouring.
 *
 * @mangled FishIMGReplace__FP1P11CCharacter2iP14BREEDFISH_USED
 * @address 0x213970
 * @size 0xFC
 */
int FishIMGReplace(u_long128 *data, CCharacter2 *chara, int item_no, BREEDFISH_USED *fish);

/**
 *
 * Draws the data panel of a fish.
 *
 * @mangled DrawFishParam__FiiP10mgCTextureP13CGameDataUsed
 * @address 0x213A70
 * @size 0xAF8
 */
void DrawFishParam(int x, int y, mgCTexture *tex, CGameDataUsed *data);

/**
 *
 * Adds up the five parameters of a fish; gives 0 for no fish.
 *
 * @mangled CalcFishParam__FP14BREEDFISH_USED
 * @address 0x215F10
 * @size 0x40
 */
int CalcFishParam(BREEDFISH_USED *fish);

/**
 *
 * Opens the aquarium menu: its camera, lighting and aquarium.
 *
 * @mangled MenuAquaInit__FP9mgCMemoryPii
 * @address 0x21A510
 * @size 0x234
 */
void MenuAquaInit(mgCMemory *memory, int *tex_block, int arg);

/**
 *
 * Runs one step of the aquarium menu; gives nonzero when the menu ends.
 *
 * @mangled MenuAquaKey__Fv
 * @address 0x21A750
 * @size 0x514
 */
int MenuAquaKey();

/**
 *
 * Draws the aquarium menu.
 *
 * @mangled MenuAquaDraw__Fv
 * @address 0x21AC70
 * @size 0xB0
 */
void MenuAquaDraw();

/**
 *
 * Opens the menu that picks the aquarium fish to race.
 *
 * @mangled MenuGyoraceFishSelInit__FP9mgCMemoryPii
 * @address 0x21AD20
 * @size 0x110
 */
void MenuGyoraceFishSelInit(mgCMemory *memory, int *tex_block, int arg);

/**
 *
 * Runs one step of the menu that picks the fish to race; gives nonzero when
 * the menu ends.
 *
 * @mangled MenuGyoraceFishSelKey__Fv
 * @address 0x21AE30
 * @size 0x4D8
 */
int MenuGyoraceFishSelKey();

/**
 *
 * Draws the menu that picks the fish to race.
 *
 * @mangled MenuGyoraceFishSelDraw__Fv
 * @address 0x21B310
 * @size 0x100
 */
void MenuGyoraceFishSelDraw();

/**
 *
 * Gives the fish picked to race; NULL for none.
 *
 * @mangled GetGyoRaceFish__Fv
 * @address 0x21B410
 * @size 0x8
 */
CGameDataUsed *GetGyoRaceFish();

/**
 *
 * Sets the aquarium that the racing fish comes from.
 *
 * @mangled SetGyoRaceAquariumNo__Fi
 * @address 0x21B420
 * @size 0x8
 */
void SetGyoRaceAquariumNo(int value);

/**
 *
 * Gives the aquarium that the racing fish comes from.
 *
 * @mangled GetGyoRaceAquariumNo__Fv
 * @address 0x21B430
 * @size 0x8
 */
int GetGyoRaceAquariumNo();

/**
 *
 * Sets the class of the fish race.
 *
 * @mangled SetGyoRaceClass__Fi
 * @address 0x21B440
 * @size 0x8
 */
void SetGyoRaceClass(int value);

/**
 *
 * Gives the class of the fish race.
 *
 * @mangled GetGyoRaceClass__Fv
 * @address 0x21B450
 * @size 0x8
 */
int GetGyoRaceClass();

/**
 *
 * Sets how far the fish race has got, at least 0.
 *
 * @mangled SetGyoRaceNo__Fi
 * @address 0x21B460
 * @size 0x1C
 */
void SetGyoRaceNo(int value);

/**
 *
 * Gives how far the fish race has got.
 *
 * @mangled GetGyoRaceNo__Fv
 * @address 0x21B480
 * @size 0x8
 */
int GetGyoRaceNo();

/**
 *
 * Sets the racing fish's place, marking the fish and counting the class won
 * in the save when it won.
 *
 * @mangled SetGyoRaceRanking__Fi
 * @address 0x21B490
 * @size 0x124
 */
void SetGyoRaceRanking(int rank);

/**
 *
 * Gives the racing fish's place.
 *
 * @mangled GetGyoRaceRanking__Fv
 * @address 0x21B5C0
 * @size 0x8
 */
int GetGyoRaceRanking();

/**
 *
 * Forgets the prizes of the fish race and fishing tournament.
 *
 * @mangled InitFishPrize__Fv
 * @address 0x21BB60
 * @size 0x14
 */
void InitFishPrize();

/**
 *
 * Loads the prizes of the fish race (0) or fishing tournament (1) into a
 * buffer of its own.
 *
 * @mangled LoadFishPrize__Fi
 * @address 0x21BB80
 * @size 0x50
 */
int LoadFishPrize(int type);

/**
 *
 * Loads and runs the prize script of the fish race (0) or fishing
 * tournament (1), building the prizes in memory.
 *
 * @mangled LoadFishPrize__FiP9mgCMemory
 * @address 0x21BBD0
 * @size 0xC4
 */
int LoadFishPrize(int type, mgCMemory *pool);

/**
 *
 * Picks the prizes on offer from the counts of races and tournaments won
 * in the save.
 *
 * @mangled RefreshFishPrize__Fv
 * @address 0x21BCA0
 * @size 0x180
 */
int RefreshFishPrize();

/**
 *
 * Gives a prize of a class and place; says whether the arguments were valid.
 *
 * @mangled GetFishPrize__FiiP15FISH_PRIZE_INFO
 * @address 0x21BE20
 * @size 0xA0
 */
int GetFishPrize(int race_no, int rank, FISH_PRIZE_INFO *info);

/**
 *
 * Counts one more fishing tournament in the save.
 *
 * @mangled TuriTourCount__Fv
 * @address 0x21BEC0
 * @size 0xA0
 */
void TuriTourCount();

/**
 *
 * Gives the slot of the race list that holds a racer; -1 when it is not
 * listed.
 *
 * @mangled CheckSameRacerFish__Fi
 * @address 0x21BFE0
 * @size 0x44
 */
int CheckSameRacerFish(int fish_no);

/**
 *
 * Gives the fish of the saved racers listed in a slot; NULL for none.
 *
 * @mangled GetOmakeGyoracer2__Fi
 * @address 0x21C030
 * @size 0x64
 */
CGameDataUsed *GetOmakeGyoracer2(int slot);

/**
 *
 * Gives the tactics of the racer listed in a slot.
 *
 * @mangled GetOmakeGyoracerTactics__Fi
 * @address 0x21C0A0
 * @size 0x3C
 */
int GetOmakeGyoracerTactics(int slot);

/**
 *
 * Sets the tactics of the racer listed in a slot.
 *
 * @mangled SetOmakeGyoracerTactics__Fii
 * @address 0x21C0E0
 * @size 0x38
 */
void SetOmakeGyoracerTactics(int slot, int tactics);

/**
 *
 * Empties the list of racers and their tactics.
 *
 * @mangled GyoraceSubGameInitData__Fv
 * @address 0x21C220
 * @size 0x68
 */
void GyoraceSubGameInitData();

/**
 *
 * Opens the menu of the saved fish race.
 *
 * @mangled GyoraceMenuInit__FP9mgCMemoryPii
 * @address 0x21C290
 * @size 0x3C4
 */
void GyoraceMenuInit(mgCMemory *memory, int *tex_block, int arg);

/**
 *
 * Runs one step of the menu of the saved fish race; gives nonzero when the
 * menu ends.
 *
 * @mangled GyoraceMenuKey__Fv
 * @address 0x21C790
 * @size 0x12AC
 */
int GyoraceMenuKey();

/**
 *
 * Draws the menu of the saved fish race.
 *
 * @mangled GyoraceMenuDraw__Fv
 * @address 0x21DA40
 * @size 0x9B4
 */
void GyoraceMenuDraw();

/**
 *
 * Draws a title panel of a sub-game menu, small (0) or big (1), with its
 * shadow.
 *
 * @mangled DrawSubGameTitle__FP10mgCTextureiiii
 * @address 0x21E400
 * @size 0x12C
 */
void DrawSubGameTitle(mgCTexture *tex, int large, int x, int y, int w);

/**
 *
 * Draws a list panel of a sub-game menu with its shadow.
 *
 * @mangled DrawSubGameListFix__FP10mgCTextureiiii
 * @address 0x21E530
 * @size 0x224
 */
void DrawSubGameListFix(mgCTexture *tex, int x, int y, int w, int h);

/**
 *
 * Draws a scrolling list panel of a sub-game menu with its shadow and
 * scroll bar.
 *
 * @mangled DrawSubGameScrlList__FP10mgCTexturePiPi
 * @address 0x21E760
 * @size 0x298
 */
void DrawSubGameScrlList(mgCTexture *tex, int *box, int *thumb);

/**
 *
 * Draws an underline of a sub-game menu.
 *
 * @mangled DrawSubGameUnderLine__FP10mgCTextureiii
 * @address 0x21EA00
 * @size 0xCC
 */
void DrawSubGameUnderLine(mgCTexture *tex, int x, int y, int w);

/**
 *
 * Text, in each language, of a racer slot with no fish.
 *
 * @mangled Mitouroku
 * @address 0x3543F0
 * @size 0x1C
 */
extern char *Mitouroku[7];

/**
 *
 * Nonzero when a fish of the aquarium died this step.
 *
 * @mangled AquaDeadCheck
 * @address 0x37D8A4
 * @size 0x4
 */
extern int AquaDeadCheck;

/**
 *
 * Fish picked to race; NULL for none.
 *
 * @mangled GyoraceFish
 * @address 0x37D8B8
 * @size 0x4
 */
extern CGameDataUsed *GyoraceFish;

/**
 *
 * Saved fish race racers of the save.
 *
 * @mangled GyoraceData
 * @address 0x37D920
 * @size 0x4
 */
extern CGyoRaceData *GyoraceData;

/**
 *
 * Message windows shared by the menus.
 *
 * @mangled MenuDCMsg
 * @address 0x1EFBA40
 * @size 0x24
 */
extern CDC2Mes *MenuDCMsg[9];
