#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the dungeon's field objects: the projectiles fired by the player's guns (rockets, lasers and machine gun
 * bullets), the pickups that drop from defeated monsters, and the robot's voice commentary.
 */

class mgCFrame;
class mgCTexture;
class mgCMemory;

/**
 * Dungeon work memory, cleared every frame and used for drawing and events as well as collision polygons.
 */
extern mgCMemory BuffWorkData__2;

/**
 *
 * Life stage of a rocket or a laser shot.
 *
 */
enum SHOT_STATE {
    SHOT_STATE_FREE = 0,   /**< The slot holds no shot. */
    SHOT_STATE_FIRED = 1,  /**< The shot has just been fired and starts flying on its next step. */
    SHOT_STATE_FLYING = 2, /**< The shot is flying, homing and testing for hits. */
    SHOT_STATE_BURST = 3,  /**< The shot has hit or run out of life; only its fading trail is left. */
};

/**
 *
 * Parts of a rocket or a laser shot that are drawn.
 *
 */
enum SHOT_DRAW_FLAG {
    SHOT_DRAW_MODEL = 1 << 0, /**< The shot's model is drawn at its head. */
    SHOT_DRAW_TRAIL = 1 << 1, /**< The trail of sprites behind the shot is drawn. */
};

/**
 *
 * One homing rocket fired by the player's launcher, drawn as a model with a smoke trail.
 *
 */
class CRocketLauncher {
public:
    int           target_chara;    /**< Scene index of the character the rocket homes in on, or -1 for none. */
    u32           unk_04;
    u32           unk_08;
    u32           unk_0c;
    sceVu0FVECTOR pos;             /**< Current world position of the rocket's head. */
    sceVu0FVECTOR start_pos;       /**< World position the rocket was fired from. */
    sceVu0FVECTOR target_pos;      /**< World position the rocket homes in on. */
    sceVu0FVECTOR dir;             /**< Unit direction of flight. */
    sceVu0FVECTOR trail[16];       /**< Ring of past head positions the smoke trail is drawn through. */
    int           trail_len;       /**< Number of trail sprites drawn. */
    int           trail_index;     /**< Ring slot the next trail position is written to. */
    int           trail_timer;     /**< Frames since a trail position was last recorded. */
    float         speed;           /**< Distance flown each frame. */
    int           col_prim_id;     /**< Identifier of the collision primitive that deals the rocket's damage, or -1. */
    u32           draw_flags;      /**< Parts drawn, as SHOT_DRAW_FLAG bits. */
    int           homing_delay;    /**< Frames left before the rocket starts homing. */
    int           homing_time;     /**< Frames left during which the rocket homes. */
    int           life;            /**< Frames left before the rocket bursts by itself. */
    SHOT_STATE    state;           /**< Life stage of the rocket. */
    mgCTexture   *trail_texture;   /**< Texture of the smoke trail sprites. */
    mgCFrame     *model;           /**< Frame that draws the rocket's model. */
    int           tex_block;       /**< Texture block of the model, uploaded before drawing. */
    u32           unk_184;
    u32           unk_188;
    u32           unk_18c;

    /**
     *
     * Fires the rocket from a position towards a target, flying in a direction, with the default speed, timers and trail.
     *
     * @mangled SetPos__15CRocketLauncherFPfPfPf
     * @address 0x1B7400
     * @size 0xE0
     */
    void SetPos(float *start, float *target, float *direction);

    /**
     *
     * Moves the rocket one frame: homes in on the target, tests for hits on the map and on enemies, bursts, and records the trail.
     *
     * @mangled Step__15CRocketLauncherFv
     * @address 0x1B74E0
     * @size 0x4B0
     */
    void Step();

    /**
     *
     * Draws the rocket's smoke trail and its model.
     *
     * @mangled Draw__15CRocketLauncherFv
     * @address 0x1B7990
     * @size 0x2A0
     */
    void Draw();

    /**
     *
     * Empties the slot: no target, no trail, no collision primitive and no shot.
     *
     * @mangled Initialize__15CRocketLauncherFv
     * @address 0x1B7C30
     * @size 0x20
     */
    void Initialize();
};
STATIC_ASSERT(sizeof(CRocketLauncher) == 0x190);

/**
 *
 * Every rocket slot of the player's launcher, stepped and drawn together.
 *
 */
class CRocketLauncherMan {
public:
    CRocketLauncher rocket[24]; /**< Rocket slots. */

    /**
     *
     * Gets a free rocket slot, or NULL when every slot is in use.
     *
     * @mangled Get__18CRocketLauncherManFv
     * @address 0x1B7C50
     * @size 0x50
     */
    CRocketLauncher *Get();

    /**
     *
     * Draws every rocket, uploading its model's textures first.
     *
     * @mangled Draw__18CRocketLauncherManFv
     * @address 0x1B7CA0
     * @size 0x80
     */
    void Draw();

    /**
     *
     * Moves every rocket one frame.
     *
     * @mangled Step__18CRocketLauncherManFv
     * @address 0x1B7D20
     * @size 0x60
     */
    void Step();

    /**
     *
     * Removes every rocket.
     *
     * @mangled Clear__18CRocketLauncherManFv
     * @address 0x1B7D80
     * @size 0x60
     */
    void Clear();

    /**
     *
     * Empties every slot and gives each the model, texture block and trail texture rockets are drawn with.
     *
     * @mangled Initialize__18CRocketLauncherManFP8mgCFrameiP10mgCTexture
     * @address 0x1B7DE0
     * @size 0x90
     */
    void Initialize(mgCFrame *model, int tex_block, mgCTexture *trail_texture);
};
STATIC_ASSERT(sizeof(CRocketLauncherMan) == 0x2580);

/**
 *
 * The bullets of the player's machine gun, which fly straight until they hit the map or an enemy or run out of life.
 *
 */
class CMachineGun {
public:
    sceVu0FVECTOR start_pos[16];   /**< World position each bullet was fired from. */
    sceVu0FVECTOR velocity[16];    /**< Distance each bullet moves each frame. */
    sceVu0FVECTOR pos[16];         /**< Current world position of each bullet. */
    s16           active[16];      /**< Non-zero while the bullet slot is in flight. */
    s16           col_prim_id[16]; /**< Identifier of the collision primitive dealing each bullet's damage, or -1. */
    int           life[16];        /**< Frames left before each bullet vanishes. */
    s16           index;           /**< Bullet slot last fired. */
    u8            unk_382[0xE];

    /**
     *
     * Fires a bullet from a position in a direction, in the next free slot after the one last fired.
     *
     * @mangled Set__11CMachineGunFPfPf
     * @address 0x1B7E70
     * @size 0x120
     */
    void Set(float *start, float *direction);

    /**
     *
     * Moves every bullet one frame, ending those that hit the map, hit an enemy or run out of life.
     *
     * @mangled Step__11CMachineGunFv
     * @address 0x1B7F90
     * @size 0x2F0
     */
    void Step();
};
STATIC_ASSERT(sizeof(CMachineGun) == 0x390);

/**
 *
 * One homing laser shot fired by the player's gun, drawn as a coloured, growing model with a glowing trail.
 *
 */
class CLaserGun {
public:
    int           target_chara;  /**< Scene index of the character the shot homes in on, or -1 for none. */
    u32           unk_04;
    u32           unk_08;
    u32           unk_0c;
    sceVu0FVECTOR pos;           /**< Current world position of the shot's head. */
    sceVu0FVECTOR start_pos;     /**< World position the shot was fired from. */
    sceVu0FVECTOR target_pos;    /**< World position the shot homes in on. */
    sceVu0FVECTOR dir;           /**< Unit direction of flight. */
    sceVu0FVECTOR trail[8];      /**< Ring of past head positions the trail is drawn through. */
    int           trail_len;     /**< Number of trail sprites drawn. */
    int           trail_index;   /**< Ring slot the next trail position is written to. */
    int           trail_timer;   /**< Frames since a trail position was last recorded. */
    float         speed;         /**< Distance flown each frame. */
    float         speed_add;     /**< Amount the speed grows each frame. */
    float         speed_max;     /**< Speed the growth stops at. */
    int           col_prim_id;   /**< Identifier of the collision primitive that deals the shot's damage, or -1. */
    u32           draw_flags;    /**< Parts drawn, as SHOT_DRAW_FLAG bits. */
    int           homing_delay;  /**< Frames left before the shot starts homing. */
    int           homing_time;   /**< Frames left during which the shot homes. */
    int           life;          /**< Frames left before the shot bursts by itself. */
    float         scale;         /**< Scale of the model and the trail sprites. */
    float         scale_add;     /**< Amount the scale grows each frame. */
    float         scale_max;     /**< Scale the growth stops at. */
    s16           visual_code;   /**< Look of the shot, as SetVisualCode chose it. */
    s16           unk_10a;
    u32           unk_10c;
    sceVu0FVECTOR color;         /**< Colour (red, green, blue, alpha, 0 to 128) of the model, the trail and the hit effect. */
    SHOT_STATE    state;         /**< Life stage of the shot. */
    mgCTexture   *trail_texture; /**< Texture of the trail sprites. */
    mgCFrame     *model;         /**< Frame that draws the shot's model. */
    int           tex_block;     /**< Texture block of the model, uploaded before drawing. */

    /**
     *
     * Fires the shot from a position towards a target, flying in a direction, with the default speed, timers, colour and trail.
     *
     * @mangled SetPos__9CLaserGunFPfPfPf
     * @address 0x1B8280
     * @size 0x110
     */
    void SetPos(float *start, float *target, float *direction);

    /**
     *
     * Chooses the shot's look, setting its colour, scale growth and, for some looks, its speed and timers.
     *
     * @mangled SetVisualCode__9CLaserGunFi
     * @address 0x1B8390
     * @size 0x1B0
     */
    void SetVisualCode(int code);

    /**
     *
     * Moves the shot one frame: homes in on the target, tests for hits on the map and on enemies, grows, bursts, and records the trail.
     *
     * @mangled Step__9CLaserGunFv
     * @address 0x1B8540
     * @size 0x690
     */
    void Step();

    /**
     *
     * Draws the shot's glowing trail and its coloured model.
     *
     * @mangled Draw__9CLaserGunFv
     * @address 0x1B8BD0
     * @size 0x580
     */
    void Draw();

    /**
     *
     * Empties the slot: no target, no trail, no collision primitive and no shot.
     *
     * @mangled Initialize__9CLaserGunFv
     * @address 0x1B9150
     * @size 0x20
     */
    void Initialize();
};
STATIC_ASSERT(sizeof(CLaserGun) == 0x130);

/**
 *
 * Every laser shot slot of the player's gun, stepped and drawn together.
 *
 */
class CLaserGunMan {
public:
    CLaserGun laser[16]; /**< Laser shot slots. */

    /**
     *
     * Gets a free laser shot slot, or NULL when every slot is in use.
     *
     * @mangled Get__12CLaserGunManFv
     * @address 0x1B9170
     * @size 0x50
     */
    CLaserGun *Get();

    /**
     *
     * Draws every laser shot, uploading its model's textures first.
     *
     * @mangled Draw__12CLaserGunManFv
     * @address 0x1B91C0
     * @size 0x80
     */
    void Draw();

    /**
     *
     * Moves every laser shot one frame.
     *
     * @mangled Step__12CLaserGunManFv
     * @address 0x1B9240
     * @size 0x60
     */
    void Step();

    /**
     *
     * Removes every laser shot.
     *
     * @mangled Clear__12CLaserGunManFv
     * @address 0x1B92A0
     * @size 0x60
     */
    void Clear();

    /**
     *
     * Empties every slot and gives each the model, texture block and trail texture laser shots are drawn with.
     *
     * @mangled Initialize__12CLaserGunManFP8mgCFrameiP10mgCTexture
     * @address 0x1B9300
     * @size 0x90
     */
    void Initialize(mgCFrame *model, int tex_block, mgCTexture *trail_texture);
};
STATIC_ASSERT(sizeof(CLaserGunMan) == 0x1300);

/**
 *
 * Kind of pickup, chosen when the pickup is set.
 *
 */
enum PULL_ITEM_TYPE {
    PULL_ITEM_MONEY = 0,       /**< A small coin, one of several a defeated monster drops, adding money when collected. */
    PULL_ITEM_WEAPON_EXP = 1,  /**< A glowing orb that adds growth to a weapon parameter when it reaches the player. */
    PULL_ITEM_GATE_KEY = 2,    /**< The gate key a monster was carrying, given when the player reaches it. */
    PULL_ITEM_MONEY_LARGE = 3, /**< A large coin adding money when collected. */
    PULL_ITEM_ITEM = 4,        /**< An item from a defeated monster's first drop slots, given when collected. */
    PULL_ITEM_ITEM2 = 5,       /**< An item from a defeated monster's second drop slot, given when collected. */
    PULL_ITEM_BADGE = 6,       /**< A monster badge, enabling the transformation into that monster when collected. */
    PULL_ITEM_STOLEN = 7,      /**< An item a monster had stolen, given back when the player reaches it. */
};

/**
 *
 * Life stage of a pickup.
 *
 */
enum PULL_ITEM_STATE {
    PULL_ITEM_STATE_FREE = 0,    /**< The slot holds no pickup. */
    PULL_ITEM_STATE_FALL = 1,    /**< The pickup is thrown out, falling and bouncing off the map. */
    PULL_ITEM_STATE_FLOAT = 2,   /**< The pickup floats where it was set, bobbing, and is drawn to the player. */
    PULL_ITEM_STATE_LAND = 3,    /**< The pickup lies on the ground until it is collected or its time runs out. */
    PULL_ITEM_STATE_COLLECT = 4, /**< The pickup is being collected, flying into the player. */
    PULL_ITEM_STATE_FADE = 5,    /**< The pickup fades out uncollected. */
    PULL_ITEM_STATE_GOT = 6,     /**< The pickup has been given and rises over the player for a moment. */
};

/**
 *
 * A pickup in the dungeon: money, weapon growth, a key, an item or a badge, which the player collects by walking up to it.
 *
 */
class CPullItem {
public:
    sceVu0FVECTOR   pos;          /**< World position of the pickup. */
    sceVu0FVECTOR   velocity;     /**< Distance the pickup moves each frame while falling. */
    sceVu0FVECTOR   draw_pos;     /**< World position the pickup's sprite was last drawn at. */
    s16             tex_u;        /**< Left edge of the sprite in the texture. */
    s16             tex_v;        /**< Top edge of the sprite in the texture. */
    s16             tex_w;        /**< Width of the sprite in the texture. */
    s16             tex_h;        /**< Height of the sprite in the texture. */
    float           width;        /**< Width the sprite is drawn at. */
    float           height;       /**< Height the sprite is drawn at. */
    s16             fall_time;    /**< Frames left to fall before the pickup fades out. */
    s16             wait_time;    /**< Frames left lying on the ground, then frames left fading out. */
    s16             anim_frame;   /**< Frame of the coin's spin animation, 0 to 15. */
    s16             unk_46;
    float           angle;        /**< Phase of the floating bob and of the collecting flight, in radians. */
    float           bob_height;   /**< Height of the floating bob. */
    s16             can_get;      /**< Non-zero once the pickup has settled and may be collected. */
    s16             get_delay;    /**< Frames left before the pickup may be collected. */
    float           pull_speed;   /**< Speed the pickup flies to the player at. */
    float           pull_accel;   /**< Amount the flying speed grows each frame. */
    float           get_range;    /**< Collection distance, in units of 20. */
    s8              type;         /**< Kind of pickup, a PULL_ITEM_TYPE. */
    s8              glow;         /**< Non-zero to draw the pickup with additive blending and a glow sprite. */
    u8              unk_62[2];
    float           exp;          /**< Growth the weapon exp pickup adds. */
    s16             num;          /**< Number of items given. */
    s16             exp_param;    /**< Weapon parameter the weapon exp pickup adds growth to. */
    s16             item_no;      /**< Item, badge or amount of money given. */
    s16             unk_6e;
    float           alpha;        /**< Alpha the pickup is drawn with, 0 to 128. */
    s8              wire_index;   /**< Index of the after-image wire following the pickup, or -1. */
    u8              unk_75[7];
    PULL_ITEM_STATE state;        /**< Life stage of the pickup. */

    /**
     *
     * Draws the pickup's sprite, bobbing, with its glow when it has one.
     *
     * @mangled Draw__9CPullItemFP10mgCTexture
     * @address 0x1B9390
     * @size 0x310
     */
    void Draw(mgCTexture *texture);

    /**
     *
     * Moves the pickup one frame through its life stages and gives the player its contents once collected.
     *
     * @mangled Step__9CPullItemFv
     * @address 0x1B96A0
     * @size 0xE10
     */
    void Step();

    /**
     *
     * Starts collecting the pickup when the player at a position is close enough to it.
     *
     * @mangled IsGet__9CPullItemFPf
     * @address 0x1BA4B0
     * @size 0xE0
     */
    void IsGet(float *player_pos);

    /**
     *
     * Sets a pickup of a kind at a position, thrown with a velocity, with that kind's look and timers.
     *
     * @mangled SetItem__9CPullItemFPfPfi
     * @address 0x1BA590
     * @size 0x3E0
     */
    void SetItem(float *position, float *velo, int item_type);

    /**
     *
     * Removes the pickup.
     *
     * @mangled Clear__9CPullItemFv
     * @address 0x1BA970
     * @size 0x10
     */
    void Clear();

    /**
     *
     * Empties the slot and gives it a default sprite.
     *
     * @mangled Initialize__9CPullItemFv
     * @address 0x1BA980
     * @size 0x30
     */
    void Initialize();
};
STATIC_ASSERT(sizeof(CPullItem) == 0x80);

/**
 *
 * The array of pickup slots the dungeon sets pickups in.
 *
 */
class CPullItemManager {
public:
    CPullItem *list; /**< Pickup slots, or NULL while the dungeon has none. */
    int        num;  /**< Number of pickup slots. */

    /**
     *
     * Gets the first free pickup slot at or after an index, or NULL when there is none.
     *
     * @mangled GetList__16CPullItemManagerFi
     * @address 0x1BA9B0
     * @size 0x60
     */
    CPullItem *GetList(int start);

    /**
     *
     * Removes every pickup.
     *
     * @mangled Clear__16CPullItemManagerFv
     * @address 0x1BAA10
     * @size 0x70
     */
    void Clear();
};
STATIC_ASSERT(sizeof(CPullItemManager) == 0x8);

/**
 *
 * Stage of the robot voice player.
 *
 */
enum ROBO_VOICE_STATUS {
    ROBO_VOICE_OFF = 0,     /**< The voice system is stopped. */
    ROBO_VOICE_OPEN = 1,    /**< A voice has been chosen and its stream is to be opened. */
    ROBO_VOICE_OPENING = 2, /**< The voice stream is opening. */
    ROBO_VOICE_STANDBY = 3, /**< The voice stream is being readied for playback. */
    ROBO_VOICE_PLAY = 4,    /**< The voice is playing. */
    ROBO_VOICE_WAIT = 5,    /**< Waiting before choosing the next voice. */
};

/**
 *
 * Plays the robot's spoken comments in the dungeon, chosen from its health, the time spent and the monsters nearby.
 *
 */
class CRoboVoiceSystem {
public:
    s16 status;      /**< Stage of the voice player, a ROBO_VOICE_STATUS. */
    s16 unk_02;
    int stream_open; /**< Non-zero while the voice stream is open. */
    u32 unk_08;
    int voice_no;    /**< Voice to play next, or -1 to choose one. */
    s16 unk_10;
    s16 wait_time;   /**< Frames left before the next voice is chosen. */
    s16 play_time;   /**< Frames the voice system has run. */
    s16 pause_time;  /**< Frames left during which the voice system is held. */

    /**
     *
     * Chooses the voice to play and starts opening its stream.
     *
     * @mangled SetStatus__16CRoboVoiceSystemFii
     * @address 0x1BAA80
     * @size 0x20
     */
    void SetStatus(int voice, int value);

    /**
     *
     * Starts the voice system, waiting a random time before the first voice.
     *
     * @mangled StartVoiceSystem__16CRoboVoiceSystemFv
     * @address 0x1BAAA0
     * @size 0x50
     */
    void StartVoiceSystem();

    /**
     *
     * Stops the voice system, closing any open voice stream, and holds it for a number of frames.
     *
     * @mangled StopVoice__16CRoboVoiceSystemFi
     * @address 0x1BAAF0
     * @size 0x70
     */
    void StopVoice(int pause);

    /**
     *
     * Runs the voice player one frame: opens, readies, plays and closes the voice stream, and chooses the next voice.
     *
     * @mangled Step__16CRoboVoiceSystemFv
     * @address 0x1BAB60
     * @size 0x4E0
     */
    void Step();
};
STATIC_ASSERT(sizeof(CRoboVoiceSystem) == 0x18);
