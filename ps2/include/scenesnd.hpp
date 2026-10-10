#pragma once

#include "common.h"

#include <libvu0.h>

#include "dngfloor.hpp"
#include "effectlist.hpp"
#include "mdslist.hpp"
#include "mg_memory.hpp"
#include "scene.hpp"
#include "sceneevent.hpp"
#include "sceneload.hpp"
#include "snd_mngr.hpp"
#include "villagermngr.hpp"
#include "water.hpp"

/**
 * @file
 * Declares the scene: the object that holds everything a running game mode
 * draws and updates -- its memory stacks, the slots of its characters,
 * cameras, messages, maps, skies, game objects and effect scripts, the time
 * of day and wind, the running event, the dungeon state, the villagers --
 * together with the music, environment sound and sound effect banks it has
 * loaded and plays.
 */

class BattleEffectMan;
class CCharacter2;
class CEffectScriptMan;
class CFuncPoint;
class CMap;
class CMapSky;
class CSaveData;
class CTreasureBoxManager;
class CVillagerPlaceInfo;
class ClsMes;
class mgCCamera;
class mgCFrame;
struct CCPoly;
struct InScreenFuncInfo;
struct mgVu0FBOX;

/**
 *
 * Markers in the sound table (snd2 file info) that stand in for a sound bank or file number.
 *
 */
enum SND_FILE_NO {
    SND_FILE_NO_NONE = -1,   /**< The scene uses no bank of this kind; the bank loaded before is released. */
    SND_FILE_NO_KEEP = 9999, /**< The scene keeps whatever bank of this kind is loaded ('*' in the table). */
};

/**
 *
 * Event script request the dungeon keeps until it can run it.
 *
 */
struct SYSTEM_SCRIPT_INFO {
    s16 event_no; /**< Number of the event to run, or -1 for none. */
    s16 running;  /**< Set to 1 once the event has been started. */
};

/**
 *
 * What the mini map shows of the parts of a floor not yet explored, as DNG_BATTLE_AREA::minimap_reveal holds it.
 *
 */
// clang-format off
enum MINIMAP_REVEAL {
    MINIMAP_REVEAL_ROOMS   = 1, /**< Unexplored cells are drawn dimmed instead of hidden. */
    MINIMAP_REVEAL_SYMBOLS = 2, /**< Monster and object symbols are drawn in unexplored cells. */
};

// clang-format on

enum DNG_BGM_STATE {
    DNG_BGM_MAP = 0,
    DNG_BGM_FADE_OUT_MAP = 1,
    DNG_BGM_BATTLE = 2,
    DNG_BGM_FADE_OUT_BATTLE = 3,
    DNG_BGM_FADE_IN_MAP = 4,
};

enum DNG_WEATHER {
    DNG_WEATHER_NORMAL = 0,
    DNG_WEATHER_RAIN = 2,
};

#define DNG_FLOOR_DISABLE_MAX 1
#define DNG_FLOOR_DISABLE_MONICA 2
#define DNG_FLOOR_DISABLE_ITEMS 4
#define DNG_FLOOR_SEAL_MASK 7

#define DNG_PAUSE_MONSTER_AI 0x1
#define DNG_PAUSE_PLAYER_STEP 0x2
#define DNG_PAUSE_PLAYER_CONTROL 0x4
#define DNG_PAUSE_MONSTER_DRAW 0x10
#define DNG_PAUSE_SKY_DRAW 0x20
#define DNG_PAUSE_MAP_DRAW 0x80
#define DNG_PAUSE_MINIMAP 0x100
#define DNG_PAUSE_PICKUPS 0x200
#define DNG_PAUSE_PLAYER_STATUS 0x400
#define DNG_PAUSE_EXIT_HEAL 0x800
#define DNG_PAUSE_ENEMY_STEP 0x1000
#define DNG_PAUSE_WEAPON_DRAW 0x2000
#define DNG_PAUSE_BATTLE_MUSIC 0x4000
#define DNG_PAUSE_PAD_RESET 0x8000
#define DNG_PAUSE_MONSTER_NAMES 0x10000

/**
 *
 * Status flags held in DNG_BATTLE_AREA::floor_status.
 *
 */
enum DNG_FLOOR_STATUS {
    DNG_FLOOR_STATUS_SEAL_MONICA = 0x1, /**< The floor's Monica seal applies. */
    DNG_FLOOR_STATUS_SEAL_MAX = 0x2,    /**< The floor's Max seal applies. */
    DNG_FLOOR_STATUS_UNK_4 = 0x4,
};

/**
 *
 * Dungeon state a scene keeps: pause and floor flags, the floor manager, the status bar, camera quake and battle music.
 *
 */
struct DNG_BATTLE_AREA {
    s32                  unk_0;
    s32                  unk_4;
    u32                  pause_flag;   /**< Flags of the dungeon systems paused by events and menus. */
    u16                  floor_status; /**< Status flags of the current floor, set and read by event scripts. */
    u8                   unk_e[0x2];
    s32                  timer;              /**< Frames counted since the dungeon timer was last reset. */
    CDngFloorManager     floor_manager;      /**< Floor data of the current dungeon. */
    char                 map_name[0x20];     /**< Name of the dungeon map file loaded. */
    SYSTEM_SCRIPT_INFO   script;             /**< Event the dungeon is to run. */
    s8                   statusbar_show;     /**< Whether the status bar is shown. */
    s8                   statusbar_show_old; /**< Value of statusbar_show before it was last set. */
    u8                   unk_4a[0x2];
    float                statusbar_rate;  /**< How far the status bar is shown, 0 (hidden) to 1 (shown). */
    float                statusbar_speed; /**< Amount statusbar_rate moves by in one frame. */
    s32                  camera_mode;     /**< Camera mode used while a dungeon battle area runs. */
    s32                  boss_map;        /**< Non-zero on a boss floor, where the mini map symbols are hidden. */
    s32                  battle_clear;    /**< Non-zero after a dungeon battle area has been cleared. */
    u8                   unk_60[0x4];
    u32                  minimap_reveal; /**< MINIMAP_REVEAL flags set by floor items for the rest of the floor. */
    u8                   unk_68[0x4];
    float                bright_rate; /**< Scale applied to the colours the dungeon is drawn with. */
    float                quake_power; /**< Strength of the running camera quake. */
    float                quake_step;  /**< Amount quake_power falls by in one frame. */
    s16                  quake_count; /**< Frames left in the running camera quake. */
    u8                   unk_7a[0x2];
    CTreasureBoxManager *treasure_box;     /**< Treasure boxes of the current floor, or NULL. */
    BattleEffectMan     *battle_effect;    /**< Battle effects of the dungeon. */
    s32                  battle_bgm_state; /**< Step of the battle music change on entering and leaving a fight. */
    float                battle_bgm_vol;   /**< Volume the battle music is played at. */
    s8                   weather;          /**< Weather condition active on this dungeon floor. */
    u8                   unk_8d[0x3];
    u64                  subject_counter;  /**< Play time at which the floor's subject counter was last reset. */
    u32                  practice_actions; /**< Battle actions performed toward the floor goal. */
    s8                   map_effect_id;    /**< Map effect number set by event scripts, or -1. */
    u8                   unk_9d;
    s16                  lock_on_mode; /**< How the player picks a target: 0 nearest with lock-on, 2 the RockOn target selection; set by _SET_LOCKON_MODE. */
    s32                  free_texb;    /**< First texture block left free after the dungeon's own textures. */
    u8                   unk_a4[0x4];

    void SetStatusBar(int show, float speed) {
        statusbar_show_old = statusbar_show;
        statusbar_show = show;

        if (show) {
            statusbar_rate = 0.0f;
        } else {
            statusbar_rate = 1.0f;
        }

        statusbar_speed = speed;
    }

    void ApplyQuake(float *value) {
        float *power = &quake_power;

        if (quake_count > 0) {
            if (quake_count % 2) {
                *value += *power;
            } else {
                *value -= *power;
            }
        }
    }

    void SetStatusBarNow(int show) {
        SetStatusBar(show, 1.0f);
        statusbar_rate = show ? 1.0f : 0.0f;
    }
};

STATIC_ASSERT(sizeof(DNG_BATTLE_AREA) == 0xA8);

/**
 *
 * One row of the sound table: the music and sound banks a map number uses, and its environment sound and reverb.
 *
 */
struct SND_FILE_INFO {
    s16 id;           /**< Map number the row is for; rows are sorted by it. */
    s16 bgm_no;       /**< Music played by default, or SND_FILE_NO_NONE / SND_FILE_NO_KEEP. */
    s16 se_base;      /**< Base sound effect bank (BS), or SND_FILE_NO_NONE / SND_FILE_NO_KEEP. */
    s16 se_battle;    /**< Battle sound effect bank (FG), or SND_FILE_NO_NONE / SND_FILE_NO_KEEP. */
    s16 se_env;       /**< Environment sound bank (SR), or SND_FILE_NO_NONE / SND_FILE_NO_KEEP. */
    s16 env_bgm;      /**< Environment sound played, or -1 when it follows the time of day. */
    s16 env_vol;      /**< Volume of the environment sound that follows the time of day, 0 to 127. */
    s16 se_src[8];    /**< Map object sound effect banks (OB), -1 for none; se_src[0] may be SND_FILE_NO_KEEP. */
    s16 event_se[2];  /**< Two numbers naming the event sound effect file (EV), or -1. */
    u8  reverb_type;  /**< Reverb type of the map. */
    u8  reverb_depth; /**< Reverb depth of the map. */
};

STATIC_ASSERT(sizeof(SND_FILE_INFO) == 0x24);

/**
 *
 * One row of the reverb table that the sound table's reverb column refers to.
 *
 */
struct SND_REV_INFO {
    s16 id;    /**< Number the sound table refers to the row by. */
    s16 type;  /**< Reverb type. */
    s16 depth; /**< Reverb depth. */
    s16 unk_6;
};

STATIC_ASSERT(sizeof(SND_REV_INFO) == 0x8);

/**
 *
 * Map object sound effect requested this frame from several sources, mixed into one volume and pan.
 *
 */
struct SE_SRC_PLAY_INFO {
    s32   se_no;   /**< Sound effect requested, or -1 for a free entry. */
    s32   num;     /**< Number of requests made this frame. */
    float vol[16]; /**< Volume of each request. */
    float pan[16]; /**< Pan of each request. */
};

STATIC_ASSERT(sizeof(SE_SRC_PLAY_INFO) == 0x88);

/**
 *
 * Everything a game mode draws and updates, with the music and sound it plays.
 *
 */
class CScene {
public:
    /**
     *
     * Music bank loaded into one music port, with the volume and fade it is played at.
     *
     */
    struct BGM_INFO {
        s32       port;        /**< Sound port the bank is loaded into (sndPORT). */
        s32       snd_id;      /**< Sound ID of the loaded bank, or -1. */
        s32       load_no;     /**< Number of the music loaded, or -1. */
        float     master_volf; /**< Master volume multiplier applied to this music channel. */
        s32       vol;         /**< Volume of the music, 0 to 127. */
        float     volf;        /**< Scale applied to vol. */
        float     fade_volf;   /**< Fade scale applied to vol, 0 to 1. */
        float     fade_speed;  /**< Amount fade_volf changes by in one frame; zero when no fade runs. */
        s32       play_no;     /**< Number of the music played, or the music last stopped. */
        s32       time_vol;    /**< Non-zero when volf follows the lighting of the time of day. */
        u8        unk_28[0x8];
        u_long128 buff[0x40]; /**< Memory the bank is loaded into. */
        mgCMemory stack;      /**< Memory stack over buff. */

        /**
         *
         * Resets the entry to no music loaded at full volume.
         *
         * @mangled Init__Q26CScene8BGM_INFOFv
         * @address 0x2A9FF0
         * @size 0x24
         */
        void Init();
    };

    /**
     *
     * Saved state of the active music, to be restored later.
     *
     */
    struct BGM_STATUS {
        s32   state;       /**< Playback state of the music (sndSQ_STATE); 1 plays, 2 pauses and below 1 stops it on restore. */
        s32   load_no;     /**< Number of the music loaded. */
        s32   play_no;     /**< Number of the music played. */
        float master_volf; /**< Master volume multiplier applied to this music channel. */
        s32   vol;         /**< Volume of the music, 0 to 127. */
        float volf;        /**< Scale applied to vol. */
        s32   time_vol;    /**< Non-zero when the volume follows the lighting of the time of day. */
    };

    /**
     *
     * Character found on screen near the screen centre.
     *
     */
    struct InScreenCharaInfo {
        s32   chara_no;  /**< Character number of the character found. */
        float dist;      /**< Distance to the character, less 10. */
        s32   in_center; /**< Non-zero when the character is within the inner part of the screen. */
    };

    s32             stack_num;   /**< Number of entries in stack. */
    s32             stack_no;    /**< Memory stack last assigned by AssignStack. */
    mgCMemory      *stack[12];   /**< Memory stacks data is loaded into. */
    mgCMemory      *work_stack;  /**< Memory stack for temporary work memory. */
    u_long128      *read_buff;   /**< Buffer files are read into before they are loaded. */
    s32             chara_num;   /**< Number of entries in chara. */
    CSceneCharacter chara[128];  /**< Character slots. */
    s32             camera_num;  /**< Number of entries in camera. */
    CSceneCamera    camera[8];   /**< Camera slots. */
    s32             message_num; /**< Number of entries in message. */
    CSceneMessage   message[8];  /**< Message slots. */
    u8              unk_23cc[0x4];
    CMdsListSet     mds_list_set; /**< Model packs and image files loaded by the scene. */
    CFireRaster     fire_raster;  /**< Heat haze effect drawn over the screen. */
    s32             map_num;      /**< Number of entries in map. */
    CSceneMap       map[4];       /**< Map slots. */
    s32             sky_num;      /**< Number of entries in sky. */
    CSceneSky       sky[4];       /**< Sky slots. */
    s32             gameobj_num;  /**< Number of entries in gameobj. */
    CSceneGameObj   gameobj[4];   /**< Game object slots. */
    s32             effect_num;   /**< Number of entries in effect. */
    CSceneEffect    effect[8];    /**< Effect script slots. */
#pragma cpp_extensions on

    union {
        CFadeInOut fade; /**< Screen fade. */

        struct {
            u8  unk_2c70[0x2C];
            int motion_blur; /**< Strength of the scene's motion blur effect. */
        };
    };

#pragma cpp_extensions reset
    s32               bg_load_step; /**< Next step of the map loaded in the background, plus one; 0 when none is. */
    u8                unk_2ca4[0x4];
    SCN_LOADMAP_INFO2 bg_load_info;      /**< Map loaded in the background. */
    s32               player_chara;      /**< Character slot of the player, or -1. */
    s32               active_camera;     /**< Camera slot drawn with, or -1. */
    s32               before_camera;     /**< Camera slot used before the event camera took over, or -1. */
    s32               active_map;        /**< Map slot the player is in (0 main map, 1 sub map), or -1. */
    s32               now_map_no;        /**< Number of the main map, or -1. */
    s32               now_sub_map_no;    /**< Number of the sub map, or -1. */
    s32               old_map_no;        /**< Number of the main map before the last change, or -1. */
    s32               old_sub_map_no;    /**< Number of the sub map before the last change, or -1. */
    s32               chara_texb;        /**< Texture block of the characters in slots 0 to 7. */
    s32               villager_texb;     /**< First texture block of the characters from slot 8. */
    s32               villager_texb_num; /**< Number of texture blocks from villager_texb. */
    s32               event_texb;        /**< First texture block for the images events load. */
    s32               event_texb_num;    /**< Number of texture blocks from event_texb. */
    s32               unk_2e84;
    s32               event_run; /**< Non-zero while an event runs. */
    s32               event_no;  /**< Number of the running event. */
#pragma cpp_extensions on

    union {
        CSceneEventData event_data; /**< Description of the running event. */

        struct {
            u32   map_jump_flags; /**< Options applied while changing maps. */
            u8    unk_2e94[8];
            int   door_place_no[2]; /**< Place numbers passed to an event when a door is used. */
            u8    unk_2ea4[4];
            char  map_jump_name[1]; /**< Name of the destination map. */
            u8    unk_2ea9[0x77];
            float door_dir_x; /**< Horizontal x direction used to calculate the door facing angle. */
            u8    unk_2f24[4];
            float door_dir_z; /**< Horizontal z direction used to calculate the door facing angle. */
            u8    unk_2f2c[4];
            float door_vec[3]; /**< Door vector passed to the event. */
            u8    unk_2f3c[0x4];
            int   event_parts_id; /**< Map part selected for the current event. */
            u8    unk_2f44[0x18];
            int   villager_id; /**< Villager selected for an edit event. */
        };
    };

#pragma cpp_extensions reset
    s32              map_event_no; /**< Number of the event last reached on the map. */
    s32              exit_flag;    /**< Exit flag set and read by event scripts. */
    s32              day;          /**< Number of days passed. */
    float            time;         /**< Time of day, in hours from 0 to 24. */
    float            time_speed;   /**< Hours passed in one time step. */
    s32              time_step;    /**< Non-zero while the time of day advances. */
    float            wind_power;   /**< Strength of the wind, 0 for none. */
    u8               unk_2f7c[0x4];
    sceVu0FVECTOR    wind_dir;               /**< Direction of the wind, normalised. */
    DNG_BATTLE_AREA  battle_area;            /**< Dungeon state. */
    s32              skip_load_villager;     /**< When set, the next LoadVillager is skipped and the flag cleared. */
    s32              skip_load_sub_villager; /**< When set, the next LoadSubVillager is skipped and the flag cleared. */
    CSaveData       *save_data;              /**< Save data the time of day is kept in, or NULL. */
    u8               unk_3044[0xC];
    CVillagerMngr    villager_mngr;     /**< Villagers placed in the town. */
    s32              villager_time;     /**< Time band the villagers were loaded for, or -1. */
    s32              sub_villager_time; /**< Time band the sub villagers were loaded for, or -1. */
    s32              tex_block_base;    /**< First texture block reserved for the scene. */
    s32              tex_block_count;   /**< Number of texture blocks reserved for the scene. */
    CThunderEffect   thunder;           /**< Thunder effect. */
    u8               unk_3f0c[0x154];
    s32              snd_file_num;    /**< Number of rows in snd_file. */
    SND_FILE_INFO    snd_file[512];   /**< Sound table, sorted by map number. */
    s32              snd_rev_num;     /**< Number of rows in snd_rev. */
    SND_REV_INFO     snd_rev[256];    /**< Reverb table. */
    s32              snd_file_id;     /**< Map number whose sound table row is loaded, or -1. */
    s32              skip_load_bgm;   /**< When set, the next LoadBGM is skipped and the flag cleared. */
    s32              skip_load_sound; /**< When set, the next LoadSound is skipped and the flag cleared. */
    s32              skip_play_bgm;   /**< When set, the next PlayBGM is skipped and the flag cleared. */
    u8               unk_9078[0x8];
    BGM_INFO         bgm[2];        /**< Music ports. */
    s32              bgm_no;        /**< Index of the active entry of bgm. */
    u32              se_src_id[16]; /**< Sound IDs of the map object sound effect banks, or -1. */
    s32              se_src_no[16]; /**< Numbers of the map object sound effect banks, or -1. */
    u8               unk_99c4[0xC];
    u_long128        se_src_buff[0x40];   /**< Memory the map object sound effect banks are loaded into. */
    mgCMemory        se_src_stack;        /**< Memory stack over se_src_buff. */
    SE_SRC_PLAY_INFO se_src_play[4];      /**< Map object sound effects requested this frame. */
    s32              se_src_play_no[4];   /**< Map object sound effects playing, or -1. */
    s32              se_src_play_flag[4]; /**< Non-zero for the entries of se_src_play_no requested this frame. */
    s32              se_env_id;           /**< Sound ID of the environment sound bank, or -1. */
    s32              se_env_no;           /**< Number of the environment sound bank, or -1. */
    u8               unk_a048[0x8];
    u_long128        se_env_buff[0x40]; /**< Memory the environment sound bank is loaded into. */
    mgCMemory        se_env_stack;      /**< Memory stack over se_env_buff. */
    s32              unk_a480;
    s32              env_bgm_no;          /**< Environment sound playing, or -1. */
    float            env_bgm_vol;         /**< Volume the environment sound plays at. */
    float            env_bgm_volf;        /**< Volume the environment sound is to play at. */
    s32              env_bgm_auto;        /**< Non-zero when the environment sound follows the time band of the map. */
    s32              env_bgm_offset;      /**< Environment sound played for the first time band. */
    s32              se_base_id;          /**< Sound ID of the base sound effect bank, or -1. */
    s32              se_base_no;          /**< Number of the base sound effect bank, or -1. */
    u_long128        se_base_buff[0x200]; /**< Memory the base sound effect bank is loaded into. */
    mgCMemory        se_base_stack;       /**< Memory stack over se_base_buff. */
    s32              se_battle_id;        /**< Sound ID of the battle sound effect bank, or -1. */
    s32              se_battle_no;        /**< Number of the battle sound effect bank, or -1. */
    u8               unk_c4d8[0x8];
    u_long128        se_battle_buff[0x200]; /**< Memory the battle sound effect bank is loaded into. */
    mgCMemory        se_battle_stack;       /**< Memory stack over se_battle_buff. */
    u_long128        loop_se_buff[0x200];   /**< Memory the looping sound effect manager is created in. */
    mgCMemory        loop_se_stack;         /**< Memory stack over loop_se_buff. */
    CLoopSeMngr      loop_se;               /**< Looping sound effects. */

    /**
     *
     * Creates a scene with all data slots and playback state reset.
     *
     */
    CScene() : event_data() { InitAllData(); }

    /**
     *
     * Resets the scene and forgets the time of day, the map numbers and the save data.
     *
     * @mangled InitAllData__6CSceneFv
     * @address 0x286C10
     * @size 0x5C
     */
    void InitAllData();

    /**
     *
     * Empties every slot and resets the scene's state.
     *
     * @mangled Initialize__6CSceneFv
     * @address 0x286C70
     * @size 0x2A8
     */
    virtual void Initialize();

    /**
     *
     * Sets one of the scene's memory stacks.
     *
     * @mangled SetStack__6CSceneFiP9mgCMemory
     * @address 0x286F20
     * @size 0x34
     */
    void SetStack(int index, mgCMemory *stack);

    /**
     *
     * Gets one of the scene's memory stacks, or NULL.
     *
     * @mangled GetStack__6CSceneFi
     * @address 0x286F60
     * @size 0x38
     */
    mgCMemory *GetStack(int index);

    /**
     *
     * Empties a memory stack and releases the buffers of the stacks after it.
     *
     * @mangled ClearStack__6CSceneFi
     * @address 0x286FA0
     * @size 0x94
     */
    void ClearStack(int index);

    /**
     *
     * Gives a memory stack the free memory left at the end of the stack before it.
     *
     * @mangled AssignStack__6CSceneFi
     * @address 0x287040
     * @size 0xC8
     */
    void AssignStack(int index);

    /**
     *
     * Gets a character slot, or NULL.
     *
     * @mangled GetSceneCharacter__6CSceneFi
     * @address 0x287110
     * @size 0x34
     */
    CSceneCharacter *GetSceneCharacter(int index);

    /**
     *
     * Gets a map slot, or NULL.
     *
     * @mangled GetSceneMap__6CSceneFi
     * @address 0x287150
     * @size 0x3C
     */
    CSceneMap *GetSceneMap(int index);

    /**
     *
     * Gets a message slot, or NULL.
     *
     * @mangled GetSceneMessage__6CSceneFi
     * @address 0x287190
     * @size 0x3C
     */
    CSceneMessage *GetSceneMessage(int index);

    /**
     *
     * Gets a camera slot, or NULL.
     *
     * @mangled GetSceneCamera__6CSceneFi
     * @address 0x2871D0
     * @size 0x3C
     */
    CSceneCamera *GetSceneCamera(int index);

    /**
     *
     * Gets a sky slot, or NULL.
     *
     * @mangled GetSceneSky__6CSceneFi
     * @address 0x287210
     * @size 0x3C
     */
    CSceneSky *GetSceneSky(int index);

    /**
     *
     * Gets a game object slot, or NULL.
     *
     * @mangled GetSceneGameObj__6CSceneFi
     * @address 0x287250
     * @size 0x34
     */
    CSceneGameObj *GetSceneGameObj(int index);

    /**
     *
     * Gets an effect script slot, or NULL.
     *
     * @mangled GetSceneEffect__6CSceneFi
     * @address 0x287290
     * @size 0x3C
     */
    CSceneEffect *GetSceneEffect(int index);

    /**
     *
     * Checks whether an image file of a name is loaded in the scene.
     *
     * @mangled CheckIMGName__6CSceneFiPc
     * @address 0x2872D0
     * @size 0xCC
     */
    int CheckIMGName(int excluded_map, char *name);

    /**
     *
     * Checks whether a model pack of a name is loaded in the scene.
     *
     * @mangled CheckMDSName__6CSceneFiPc
     * @address 0x2873A0
     * @size 0xCC
     */
    int CheckMDSName(int excluded_map, char *name);

    /**
     *
     * Gets a slot of a kind (SCENE_DATA_KIND), or NULL.
     *
     * @mangled GetData__6CSceneFii
     * @address 0x287470
     * @size 0x9C
     */
    CSceneData *GetData(int kind, int index);

    /**
     *
     * Puts a camera in a slot under a name; gives back the slot, or -1.
     *
     * @mangled AssignCamera__6CSceneFiP9mgCCameraPc
     * @address 0x287510
     * @size 0xE0
     */
    int AssignCamera(int index, mgCCamera *camera, char *name);

    /**
     *
     * Gets the camera slot of a name, or -1.
     *
     * @mangled GetCameraID__6CSceneFPc
     * @address 0x2875F0
     * @size 0x9C
     */
    int GetCameraID(char *name);

    /**
     *
     * Gets the camera in a slot, or NULL.
     *
     * @mangled GetCamera__6CSceneFi
     * @address 0x287690
     * @size 0x50
     */
    mgCCamera *GetCamera(int index);

    /**
     *
     * Puts a message window in a slot under a name; gives back the slot, or -1.
     *
     * @mangled AssignMessage__6CSceneFiP6ClsMesPc
     * @address 0x2876E0
     * @size 0xD0
     */
    int AssignMessage(int index, ClsMes *message, char *name);

    /**
     *
     * Gets the message window in a slot, or NULL.
     *
     * @mangled GetMessage__6CSceneFi
     * @address 0x2877B0
     * @size 0x50
     */
    ClsMes *GetMessage(int index);

    /**
     *
     * Puts a character in a slot under a name; gives back the slot, or -1.
     *
     * @mangled AssignChara__6CSceneFiP11CCharacter2Pc
     * @address 0x287800
     * @size 0xD0
     */
    int AssignChara(int index, CCharacter2 *chara, char *name);

    /**
     *
     * Sets the character number of a character slot.
     *
     * @mangled SetCharaNo__6CSceneFii
     * @address 0x2878D0
     * @size 0x30
     */
    void SetCharaNo(int index, int value);

    /**
     *
     * Gets the character number of a character slot.
     *
     * @mangled GetCharaNo__6CSceneFi
     * @address 0x287900
     * @size 0x30
     */
    int GetCharaNo(int index);

    /**
     *
     * Gets the character in a slot, or NULL.
     *
     * @mangled GetCharacter__6CSceneFi
     * @address 0x287930
     * @size 0x50
     */
    CCharacter2 *GetCharacter(int index);

    /**
     *
     * Puts a map in a slot under a name; gives back the slot, or -1.
     *
     * @mangled AssignMap__6CSceneFiP4CMapPc
     * @address 0x287980
     * @size 0xE0
     */
    int AssignMap(int index, CMap *map, char *name);

    /**
     *
     * Gets the name a map slot was given.
     *
     * @mangled GetMapName__6CSceneFi
     * @address 0x287A60
     * @size 0x30
     */
    char *GetMapName(int index);

    /**
     *
     * Gets the map slot of a name, or -1.
     *
     * @mangled GetMapID__6CSceneFPc
     * @address 0x287A90
     * @size 0x9C
     */
    int GetMapID(char *name);

    /**
     *
     * Gets the map in a slot, or NULL.
     *
     * @mangled GetMap__6CSceneFi
     * @address 0x287B30
     * @size 0x50
     */
    CMap *GetMap(int index);

    /**
     *
     * Gets the sky in a slot, or NULL.
     *
     * @mangled GetSky__6CSceneFi
     * @address 0x287B80
     * @size 0x50
     */
    CMapSky *GetSky(int index);

    /**
     *
     * Gets the number of the map the player is in.
     *
     * @mangled GetMainMapNo__6CSceneFv
     * @address 0x287BD0
     * @size 0x24
     */
    int GetMainMapNo();

    /**
     *
     * Finds the screen function point in front of the camera, or NULL.
     *
     * @mangled InScreenFunc__6CSceneFP16InScreenFuncInfo
     * @address 0x287C00
     * @size 0x4B8
     */
    CFuncPoint *InScreenFunc(InScreenFuncInfo *info);

    /**
     *
     * Draws a screen function point frame.
     *
     * @mangled DrawScreenFunc__6CSceneFP8mgCFrame
     * @address 0x2880C0
     * @size 0x9C
     */
    void DrawScreenFunc(mgCFrame *frame);

    /**
     *
     * Puts a sky in a slot under a name; gives back the slot, or -1.
     *
     * @mangled AssignSky__6CSceneFiP7CMapSkyPc
     * @address 0x288160
     * @size 0xD0
     */
    int AssignSky(int index, CMapSky *sky, char *name);

    /**
     *
     * Empties a sky slot; gives back zero when there is no such slot.
     *
     * @mangled DeleteSky__6CSceneFi
     * @address 0x288230
     * @size 0x38
     */
    int DeleteSky(int index);

    /**
     *
     * Puts an effect script manager in a slot under a name; gives back the slot, or -1.
     *
     * @mangled AssignEffect__6CSceneFiP16CEffectScriptManPc
     * @address 0x288270
     * @size 0x70
     */
    int AssignEffect(int index, CEffectScriptMan *effect, char *name);

    /**
     *
     * Empties an effect script slot.
     *
     * @mangled DeleteEffect__6CSceneFi
     * @address 0x2882E0
     * @size 0x30
     */
    void DeleteEffect(int index);

    /**
     *
     * Gets the effect script manager in a slot, or NULL.
     *
     * @mangled GetEffect__6CSceneFi
     * @address 0x288310
     * @size 0x30
     */
    CEffectScriptMan *GetEffect(int index);

    /**
     *
     * Advances the effect scripts of a slot by one frame.
     *
     * @mangled StepEffectScript__6CSceneFi
     * @address 0x288340
     * @size 0x90
     */
    void StepEffectScript(int index);

    /**
     *
     * Draws the effect scripts of a slot.
     *
     * @mangled DrawEffectScript__6CSceneFi
     * @address 0x2883D0
     * @size 0x90
     */
    void DrawEffectScript(int index);

    /**
     *
     * Checks whether a slot of a kind is in use and active.
     *
     * @mangled IsActive__6CSceneFii
     * @address 0x288460
     * @size 0x3C
     */
    int IsActive(int kind, int index);

    /**
     *
     * Marks a slot of a kind active.
     *
     * @mangled SetActive__6CSceneFii
     * @address 0x2884A0
     * @size 0x30
     */
    void SetActive(int kind, int index);

    /**
     *
     * Marks a slot of a kind inactive.
     *
     * @mangled ResetActive__6CSceneFii
     * @address 0x2884D0
     * @size 0x34
     */
    void ResetActive(int kind, int index);

    /**
     *
     * Sets status flags of a slot of a kind.
     *
     * @mangled SetStatus__6CSceneFiii
     * @address 0x288510
     * @size 0x38
     */
    void SetStatus(int kind, int index, int bits);

    /**
     *
     * Clears status flags of a slot of a kind.
     *
     * @mangled ResetStatus__6CSceneFiii
     * @address 0x288550
     * @size 0x3C
     */
    void ResetStatus(int kind, int index, int bits);

    /**
     *
     * Gets the status flags of a slot of a kind.
     *
     * @mangled GetStatus__6CSceneFii
     * @address 0x288590
     * @size 0x30
     */
    int GetStatus(int kind, int index);

    /**
     *
     * Sets the type of a slot of a kind.
     *
     * @mangled SetType__6CSceneFiii
     * @address 0x2885C0
     * @size 0x30
     */
    void SetType(int kind, int index, int type);

    /**
     *
     * Gets the type of a slot of a kind.
     *
     * @mangled GetType__6CSceneFii
     * @address 0x2885F0
     * @size 0x30
     */
    int GetType(int kind, int index);

    /**
     *
     * Gathers the maps of the active map slots; gives back their number.
     *
     * @mangled GetActiveMap__6CSceneFPP4CMapi
     * @address 0x288620
     * @size 0xB0
     */
    int GetActiveMap(CMap **maps, int max);

    /**
     *
     * Gets the texture block a character slot is drawn with, or -1.
     *
     * @mangled GetCharaTexb__6CSceneFi
     * @address 0x2886D0
     * @size 0x8C
     */
    int GetCharaTexb(int index);

    /**
     *
     * Sets the texture block a character slot is drawn with.
     *
     * @mangled SetCharaTexb__6CSceneFii
     * @address 0x288760
     * @size 0x30
     */
    void SetCharaTexb(int index, int texb);

    /**
     *
     * Sets the time of day, wrapped into 0 to 24 hours.
     *
     * @mangled SetTime__6CSceneFf
     * @address 0x288790
     * @size 0x98
     */
    void SetTime(float hours);

    /**
     *
     * Moves the time of day on by a number of hours.
     *
     * @mangled AddTime__6CSceneFf
     * @address 0x288830
     * @size 0xC
     */
    void AddTime(float hours);

    /**
     *
     * Advances the time of day, counting the days that pass.
     *
     * @mangled TimeStep__6CSceneFf
     * @address 0x288840
     * @size 0xBC
     */
    void TimeStep(float frame_scale);

    /**
     *
     * Sets the strength and direction of the wind.
     *
     * @mangled SetWind__6CSceneFfPf
     * @address 0x288900
     * @size 0xC
     */
    void SetWind(float strength, float *dir);

    /**
     *
     * Stops the wind.
     *
     * @mangled ResetWind__6CSceneFv
     * @address 0x288910
     * @size 0x8
     */
    void ResetWind();

    /**
     *
     * Gets the direction of the wind; gives back its strength.
     *
     * @mangled GetWind__6CSceneFPf
     * @address 0x288920
     * @size 0x10
     */
    float GetWind(float *dir);

    /**
     *
     * Sets the number of the main map, remembering the one before.
     *
     * @mangled SetNowMapNo__6CSceneFi
     * @address 0x288930
     * @size 0x18
     */
    void SetNowMapNo(int map_no);

    /**
     *
     * Returns the scene's current main-map number.
     *
     */
    int GetNowMapNo() { return now_map_no; }

    /**
     *
     * Sets the number of the sub map, remembering the one before.
     *
     * @mangled SetNowSubMapNo__6CSceneFi
     * @address 0x288950
     * @size 0x18
     */
    void SetNowSubMapNo(int map_no);

    /**
     *
     * Creates a character from a pack in a slot; gives back the slot, or -1.
     *
     * @mangled LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii
     * @address 0x288F30
     * @size 0x244
     */
    int LoadChara(int index, unsigned int *pack, char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, int no_outline);

    /**
     *
     * Empties a character slot.
     *
     * @mangled DeleteChara__6CSceneFi
     * @address 0x289180
     * @size 0x30
     */
    void DeleteChara(int index);

    /**
     *
     * Creates in a slot a copy of the character in another slot; gives back the slot, or -1.
     *
     * @mangled CopyChara__6CSceneFiiP9mgCMemory
     * @address 0x2891B0
     * @size 0x284
     */
    int CopyChara(int index, int source_index, mgCMemory *memory);

    /**
     *
     * Builds a map in a slot from files already read, running every step.
     *
     * @mangled LoadMapFromMemory__6CSceneFiP17SCN_LOADMAP_INFO2
     * @address 0x289440
     * @size 0x80
     */
    int LoadMapFromMemory(int no, SCN_LOADMAP_INFO2 *info);

    /**
     *
     * Runs one step of building a map in a slot; gives back the next step (SCN_LOADMAP_STEP), or -1.
     *
     * @mangled LoadMapFromMemory__6CSceneFiiP17SCN_LOADMAP_INFO2
     * @address 0x2894C0
     * @size 0x434
     */
    int LoadMapFromMemory(int no, int step, SCN_LOADMAP_INFO2 *info);

    /**
     *
     * Runs the next step of building the map loaded in the background.
     *
     * @mangled LoadMapBGStep__6CSceneFP17SCN_LOADMAP_INFO2
     * @address 0x289A00
     * @size 0xA8
     */
    int LoadMapBGStep(SCN_LOADMAP_INFO2 *info);

    /**
     *
     * Reads a map's files into a slot, building the map now or leaving it to the background.
     *
     * @mangled LoadMap__6CSceneFiP17SCN_LOADMAP_INFO2i
     * @address 0x289AB0
     * @size 0xD0
     */
    int LoadMap(int no, SCN_LOADMAP_INFO2 *info, int deferred);

    /**
     *
     * Deletes the map in a slot with its textures and memory.
     *
     * @mangled DeleteMap__6CSceneFii
     * @address 0x289C40
     * @size 0x204
     */
    int DeleteMap(int map_index, int clear_stack);

    /**
     *
     * Resets every sound bank and the music.
     *
     * @mangled InitSnd__6CSceneFv
     * @address 0x2AA020
     * @size 0xC8
     */
    void InitSnd();

    /**
     *
     * Releases the active music bank and resets its port.
     *
     * @mangled InitBGM__6CSceneFv
     * @address 0x2AA0F0
     * @size 0x44
     */
    void InitBGM();

    /**
     *
     * Stops and releases the map object sound effect banks.
     *
     * @mangled InitSeSrc__6CSceneFv
     * @address 0x2AA140
     * @size 0x1B8
     */
    void InitSeSrc();

    /**
     *
     * Stops and releases the environment sound bank and the map object sound effect banks.
     *
     * @mangled InitSeEnv__6CSceneFv
     * @address 0x2AA300
     * @size 0xD0
     */
    void InitSeEnv();

    /**
     *
     * Stops and releases the battle sound effect bank and the banks InitSeEnv releases.
     *
     * @mangled InitSeBattle__6CSceneFv
     * @address 0x2AA3D0
     * @size 0x74
     */
    void InitSeBattle();

    /**
     *
     * Stops and releases the base sound effect bank and the banks InitSeBattle releases.
     *
     * @mangled InitSeBas__6CSceneFv
     * @address 0x2AA450
     * @size 0x74
     */
    void InitSeBas();

    /**
     *
     * Stops every sound effect.
     *
     * @mangled SeAllStop__6CSceneFv
     * @address 0x2AA4D0
     * @size 0x34
     */
    void SeAllStop();

    /**
     *
     * Stops the music and every sound effect.
     *
     * @mangled SoundAllStop__6CSceneFv
     * @address 0x2AA510
     * @size 0x38
     */
    void SoundAllStop();

    /**
     *
     * Recreates the looping sound effect manager in its own memory.
     *
     * @mangled InitLooSeMngr__6CSceneFv
     * @address 0x2AA550
     * @size 0x7C
     */
    void InitLooSeMngr();

    /**
     *
     * Gets the active music port.
     *
     * @mangled GetActiveBgmInfo__6CSceneFv
     * @address 0x2AA5D0
     * @size 0x30
     */
    BGM_INFO *GetActiveBgmInfo();

    /**
     *
     * Plays music at a volume, stopping the music playing before; a negative volume uses the music's own.
     *
     * @mangled PlayBGM__6CSceneFiif
     * @address 0x2AA600
     * @size 0xF4
     */
    void PlayBGM(int bgm_no, int vol, float volf);

    /**
     *
     * Pauses the music.
     *
     * @mangled PauseBGM__6CSceneFv
     * @address 0x2AA700
     * @size 0x30
     */
    void PauseBGM();

    /**
     *
     * Resumes the music.
     *
     * @mangled RePlayBGM__6CSceneFv
     * @address 0x2AA730
     * @size 0x34
     */
    void RePlayBGM();

    /**
     *
     * Stops music, cancelling any fade.
     *
     * @mangled StopBGM__6CSceneFi
     * @address 0x2AA770
     * @size 0x58
     */
    void StopBGM(int play_no);

    /**
     *
     * Sets the volume of the music; a negative volume uses the music's own.
     *
     * @mangled SetVolBGM__6CSceneFi
     * @address 0x2AA7D0
     * @size 0x70
     */
    void SetVolBGM(int vol);

    /**
     *
     * Gets the volume of the music.
     *
     * @mangled GetVolBGM__6CSceneFv
     * @address 0x2AA840
     * @size 0x20
     */
    int GetVolBGM();

    /**
     *
     * Gets the playback state of the music (sndSQ_STATE).
     *
     * @mangled GetBGMState__6CSceneFv
     * @address 0x2AA860
     * @size 0x28
     */
    int GetBGMState();

    /**
     *
     * Sets the scale applied to the volume of the music.
     *
     * @mangled SetVolfBGM__6CSceneFf
     * @address 0x2AA890
     * @size 0x78
     */
    void SetVolfBGM(float rate);

    /**
     *
     * Gets the scale applied to the volume of the music.
     *
     * @mangled GetVolfBGM__6CSceneFv
     * @address 0x2AA910
     * @size 0x20
     */
    float GetVolfBGM();

    /**
     *
     * Fades the music out over a number of frames.
     *
     * @mangled FadeOutBGM__6CSceneFi
     * @address 0x2AA930
     * @size 0x3C
     */
    void FadeOutBGM(int frames);

    /**
     *
     * Fades the music in from silence over a number of frames.
     *
     * @mangled FadeInBGM__6CSceneFi
     * @address 0x2AA970
     * @size 0x60
     */
    void FadeInBGM(int frames);

    /**
     *
     * Sets whether the volume of the music follows the lighting of the time of day.
     *
     * @mangled AutoChangeBGMVol__6CSceneFi
     * @address 0x2AA9D0
     * @size 0x28
     */
    void AutoChangeBGMVol(int enable);

    /**
     *
     * Saves the state of the active music.
     *
     * @mangled GetActiveBgmStatus__6CSceneFPQ26CScene10BGM_STATUS
     * @address 0x2AAA00
     * @size 0x70
     */
    void GetActiveBgmStatus(BGM_STATUS *status);

    /**
     *
     * Restores the state of the active music, playing, pausing or stopping it.
     *
     * @mangled SetActiveBgmStatus__6CSceneFPQ26CScene10BGM_STATUS
     * @address 0x2AAA70
     * @size 0x108
     */
    void SetActiveBgmStatus(BGM_STATUS *status);

    /**
     *
     * Plays an environment sound at a volume, unless it is already playing.
     *
     * @mangled PlayEnvBGM__6CSceneFif
     * @address 0x2AAB80
     * @size 0x8C
     */
    void PlayEnvBGM(int play_no, float vol);

    /**
     *
     * Sets the volume of the environment sound.
     *
     * @mangled SetEnvBGMVol__6CSceneFf
     * @address 0x2AAC10
     * @size 0x84
     */
    void SetEnvBGMVol(float vol);

    /**
     *
     * Gets the volume the environment sound is to play at.
     *
     * @mangled GetEnvBGMVol__6CSceneFv
     * @address 0x2AACA0
     * @size 0x10
     */
    float GetEnvBGMVol();

    /**
     *
     * Stops the environment sound.
     *
     * @mangled StopEnvBGM__6CSceneFv
     * @address 0x2AACB0
     * @size 0x54
     */
    void StopEnvBGM();

    /**
     *
     * Sets whether the environment sound follows the time band of the map.
     *
     * @mangled AutoChangeEnvBGM__6CSceneFi
     * @address 0x2AAD10
     * @size 0x10
     */
    void AutoChangeEnvBGM(int enable);

    /**
     *
     * Sets the environment sound played for the first time band.
     *
     * @mangled AutoChangeEnvOffset__6CSceneFi
     * @address 0x2AAD20
     * @size 0x10
     */
    void AutoChangeEnvOffset(int offset);

    /**
     *
     * Starts the environment sound of the loaded sound table row.
     *
     * @mangled PlayEnvBgm__6CSceneFv
     * @address 0x2AAD30
     * @size 0xB0
     */
    void PlayEnvBgm();

    /**
     *
     * Gets the sound ID of a loaded map object sound effect bank, or -1.
     *
     * @mangled GetSeSrcID__6CSceneFi
     * @address 0x2AADE0
     * @size 0x50
     */
    int GetSeSrcID(int key);

    /**
     *
     * Makes the file name of a music bank.
     *
     * @mangled GetBgmFile__6CSceneFPci
     * @address 0x2AAEC0
     * @size 0x40
     */
    void GetBgmFile(char *path, int number);

    /**
     *
     * Makes the file name of a map object sound effect bank.
     *
     * @mangled GetSeSrcFile__6CSceneFPci
     * @address 0x2AAF00
     * @size 0x40
     */
    void GetSeSrcFile(char *path, int number);

    /**
     *
     * Makes the file name of an environment sound bank.
     *
     * @mangled GetSeEnvFile__6CSceneFPci
     * @address 0x2AAF40
     * @size 0x40
     */
    void GetSeEnvFile(char *path, int number);

    /**
     *
     * Makes the file name of a base sound effect bank.
     *
     * @mangled GetSeBaseFile__6CSceneFPci
     * @address 0x2AAF80
     * @size 0x40
     */
    void GetSeBaseFile(char *path, int number);

    /**
     *
     * Makes the file name of a battle sound effect bank.
     *
     * @mangled GetSeBattleFile__6CSceneFPci
     * @address 0x2AAFC0
     * @size 0x40
     */
    void GetSeBattleFile(char *path, int number);

    /**
     *
     * Checks whether a music bank needs loading.
     *
     * @mangled CheckLoadBGM__6CSceneFi
     * @address 0x2AB000
     * @size 0x40
     */
    int CheckLoadBGM(int no);

    /**
     *
     * Checks whether a map object sound effect bank needs loading.
     *
     * @mangled CheckLoadSeSrc__6CSceneFi
     * @address 0x2AB040
     * @size 0x50
     */
    int CheckLoadSeSrc(int key);

    /**
     *
     * Checks whether an environment sound bank needs loading.
     *
     * @mangled CheckLoadSeEnv__6CSceneFi
     * @address 0x2AB090
     * @size 0x28
     */
    int CheckLoadSeEnv(int no);

    /**
     *
     * Checks whether a battle sound effect bank needs loading.
     *
     * @mangled CheckLoadSeBattle__6CSceneFi
     * @address 0x2AB0C0
     * @size 0x28
     */
    int CheckLoadSeBattle(int no);

    /**
     *
     * Checks whether a base sound effect bank needs loading.
     *
     * @mangled CheckLoadSeBase__6CSceneFi
     * @address 0x2AB0F0
     * @size 0x28
     */
    int CheckLoadSeBase(int no);

    /**
     *
     * Finds the sound table row of a map number, or NULL.
     *
     * @mangled SearchSndDataID__6CSceneFi
     * @address 0x2AB120
     * @size 0x90
     */
    SND_FILE_INFO *SearchSndDataID(int id);

    /**
     *
     * Gets the music a map number plays by default, or -1.
     *
     * @mangled GetDefBgmNo__6CSceneFi
     * @address 0x2AB1B0
     * @size 0x30
     */
    int GetDefBgmNo(int id);

    /**
     *
     * Makes the file name of the event sound effects of a map number; gives back zero when it has no row.
     *
     * @mangled GetDefEventSeFile__6CSceneFiPc
     * @address 0x2AB1E0
     * @size 0x74
     */
    int GetDefEventSeFile(int id, char *path);

    /**
     *
     * Loads the sound banks of a map number's sound table row and sets its reverb and environment sound.
     *
     * @mangled LoadSound__6CSceneFiP1
     * @address 0x2AB260
     * @size 0x218
     */
    int LoadSound(int id, u_long128 *buff);

    /**
     *
     * Reads and loads a music bank, unless it is loaded.
     *
     * @mangled LoadBGM__6CSceneFiP1
     * @address 0x2AB480
     * @size 0xB4
     */
    int LoadBGM(int no, u_long128 *buff);

    /**
     *
     * Reads and loads a map object sound effect bank, unless it is loaded.
     *
     * @mangled LoadSeSrc__6CSceneFiP1
     * @address 0x2AB540
     * @size 0x8C
     */
    int LoadSeSrc(int no, u_long128 *buff);

    /**
     *
     * Reads and loads an environment sound bank, unless it is loaded.
     *
     * @mangled LoadSeEnv__6CSceneFiP1
     * @address 0x2AB5D0
     * @size 0x8C
     */
    int LoadSeEnv(int no, u_long128 *buff);

    /**
     *
     * Reads and loads a battle sound effect bank, unless it is loaded.
     *
     * @mangled LoadSeBattle__6CSceneFiP1
     * @address 0x2AB660
     * @size 0x8C
     */
    int LoadSeBattle(int no, u_long128 *buff);

    /**
     *
     * Reads and loads a base sound effect bank, unless it is loaded.
     *
     * @mangled LoadSeBase__6CSceneFiP1
     * @address 0x2AB6F0
     * @size 0x8C
     */
    int LoadSeBase(int no, u_long128 *buff);

    /**
     *
     * Loads a music bank from a pack already read into the active music port.
     *
     * @mangled LoadBGMPack__6CSceneFiPUi
     * @address 0x2AB780
     * @size 0xAC
     */
    int LoadBGMPack(int no, unsigned int *buff);

    /**
     *
     * Loads a map object sound effect bank from a pack already read into a free entry.
     *
     * @mangled LoadSeSrcPack__6CSceneFiPUi
     * @address 0x2AB830
     * @size 0xD0
     */
    int LoadSeSrcPack(int no, unsigned int *buffer);

    /**
     *
     * Loads an environment sound bank from a pack already read.
     *
     * @mangled LoadSeEnvPack__6CSceneFiPUi
     * @address 0x2AB900
     * @size 0xB0
     */
    int LoadSeEnvPack(int no, unsigned int *buffer);

    /**
     *
     * Loads a battle sound effect bank from a pack already read.
     *
     * @mangled LoadSeBattlePack__6CSceneFiPUi
     * @address 0x2AB9B0
     * @size 0x9C
     */
    int LoadSeBattlePack(int no, unsigned int *buffer);

    /**
     *
     * Loads a base sound effect bank from a pack already read.
     *
     * @mangled LoadSeBasePack__6CSceneFiPUi
     * @address 0x2ABA50
     * @size 0x9C
     */
    int LoadSeBasePack(int no, unsigned int *buffer);

    /**
     *
     * Clears the map object sound effects requested.
     *
     * @mangled PrePlaySeSrc__6CSceneFv
     * @address 0x2ABAF0
     * @size 0x68
     */
    void PrePlaySeSrc();

    /**
     *
     * Requests a map object sound effect for this frame at a volume and pan.
     *
     * @mangled PlaySeSrc__6CSceneFiff
     * @address 0x2ABB60
     * @size 0x138
     */
    void PlaySeSrc(int se_no, float vol, float pan);

    /**
     *
     * Marks a map object sound effect as requested; gives back 1 when it already plays, 0 when it is to start, -1 when no entry is free.
     *
     * @mangled check_se_play__6CSceneFi
     * @address 0x2ABCA0
     * @size 0xBC
     */
    int check_se_play(int id);

    /**
     *
     * Gets the music volume scale for the lighting of the time of day.
     *
     * @mangled GetTimeBgmVolf__6CSceneFv
     * @address 0x2ABD60
     * @size 0xC8
     */
    float GetTimeBgmVolf();

    /**
     *
     * Advances the music fades, the environment sound and the map object and looping sound effects by one frame.
     *
     * @mangled StepSnd__6CSceneFv
     * @address 0x2ABE30
     * @size 0x5BC
     */
    void StepSnd();

    /**
     *
     * Stops the map object sound effects requested.
     *
     * @mangled StopSeSrc__6CSceneFv
     * @address 0x2AC3F0
     * @size 0xA8
     */
    void StopSeSrc();

    /**
     *
     * Requests the sound effects of the objects of the active maps.
     *
     * @mangled PlayMapSeSrc__6CSceneFv
     * @address 0x2AC4A0
     * @size 0xE8
     */
    void PlayMapSeSrc();

    /**
     *
     * Plays the sound of a door of a type opening.
     *
     * @mangled SePlayOpenDoor__6CSceneFiPf
     * @address 0x2AC590
     * @size 0x1C
     */
    void SePlayOpenDoor(int type, float *pos);

    /**
     *
     * Plays the sound of a door of a type closing.
     *
     * @mangled SePlayCloseDoor__6CSceneFiPf
     * @address 0x2AC5B0
     * @size 0x1C
     */
    void SePlayCloseDoor(int type, float *pos);

    /**
     *
     * Plays a footstep sound on a ground type at a position.
     *
     * @mangled SePlayFoot__6CSceneFiiPf
     * @address 0x2AC5D0
     * @size 0x7C
     */
    void SePlayFoot(int ground, int foot, float *pos);

    /**
     *
     * Copies the reverb table from a file's data.
     *
     * @mangled LoadSndRevInfo__6CSceneFPci
     * @address 0x2AC7F0
     * @size 0x1C
     */
    void LoadSndRevInfo(char *src, int size);

    /**
     *
     * Reads the sound table from a text file's data.
     *
     * @mangled LoadSndFileInfo__6CSceneFPci
     * @address 0x2AC810
     * @size 0x4C0
     */
    void LoadSndFileInfo(char *src, int size);

    /**
     *
     * Passes the time of day and lighting settings on to the active map.
     *
     * @mangled UpDateMapInfo__6CSceneFv
     * @address 0x2CC360
     * @size 0x160
     */
    void UpDateMapInfo();

    /**
     *
     * Gathers the collision polygons of the active maps within a box; gives back their number.
     *
     * @mangled GetColPoly__6CSceneFP6CCPolyR9mgVu0FBOXi
     * @address 0x2CC4C0
     * @size 0xCC
     */
    int GetColPoly(CCPoly *poly, mgVu0FBOX &box, int max);

    /**
     *
     * Gathers the camera collision polygons of the active maps within a box; gives back their number.
     *
     * @mangled GetCameraPoly__6CSceneFP6CCPolyR9mgVu0FBOXi
     * @address 0x2CC590
     * @size 0xCC
     */
    int GetCameraPoly(CCPoly *poly, mgVu0FBOX &box, int max);

    /**
     *
     * Starts an event, unless an event that cannot be replaced is running.
     *
     * @mangled RunEvent__6CSceneFiP15CSceneEventData
     * @address 0x2CC660
     * @size 0x16C
     */
    void RunEvent(int event_no, CSceneEventData *data);

    /**
     *
     * Finds the map event point at a position; gives back its event number, or zero.
     *
     * @mangled GetMapEvent__6CSceneFPfiP15CSceneEventData
     * @address 0x2CC7D0
     * @size 0x204
     */
    int GetMapEvent(float *pos, int map_no, CSceneEventData *event);

    /**
     *
     * Gets the fixed camera position and target for a position; gives back zero when there is none.
     *
     * @mangled GetFixCameraPos__6CSceneFPfPf
     * @address 0x2CC9E0
     * @size 0xB0
     */
    int GetFixCameraPos(float *pos, float *camera);

    /**
     *
     * Hides the map parts in the way of the fixed camera at a position.
     *
     * @mangled FixCameraPartsOnOff__6CSceneFPf
     * @address 0x2CCA90
     * @size 0x7C
     */
    void FixCameraPartsOnOff(float *pos);

    /**
     *
     * Shows or hides the map parts that are hidden in the first person view.
     *
     * @mangled EyeViewDrawOnOff__6CSceneFi
     * @address 0x2CCB10
     * @size 0xC0
     */
    void EyeViewDrawOnOff(int on);

    /**
     *
     * Gets the position of the sun.
     *
     * @mangled GetSunPosition__6CSceneFPf
     * @address 0x2CCBD0
     * @size 0xC4
     */
    void GetSunPosition(float *pos);

    /**
     *
     * Gets the position of the moon.
     *
     * @mangled GetMoonPosition__6CSceneFPf
     * @address 0x2CCCA0
     * @size 0x3C
     */
    void GetMoonPosition(float *pos);

    /**
     *
     * Draws the sky of a slot.
     *
     * @mangled DrawSky__6CSceneFi
     * @address 0x2CCCE0
     * @size 0x1A4
     */
    void DrawSky(int sky_index);

    /**
     *
     * Draws the lens flare of the sun with two textures.
     *
     * @mangled DrawLensFlare__6CSceneFiPcPc
     * @address 0x2CCE90
     * @size 0x26C
     */
    void DrawLensFlare(int flare_type, char *texture, char *alpha_texture);

    /**
     *
     * Advances the scene's screen effects by one frame.
     *
     * @mangled EffectStep__6CSceneFv
     * @address 0x2CD100
     * @size 0x84
     */
    void EffectStep();

    /**
     *
     * Draws the scene's screen effects.
     *
     * @mangled DrawEffect__6CSceneFi
     * @address 0x2CD190
     * @size 0x1F8
     */
    void DrawEffect(int tex_block);

    /**
     *
     * Checks whether the character in a slot is drawn (SCENE_CHARA_STATUS).
     *
     * @mangled CheckDrawChara__6CSceneFi
     * @address 0x2CD4E0
     * @size 0x74
     */
    int CheckDrawChara(int index);

    /**
     *
     * Checks whether the shadow of the character in a slot is drawn (SCENE_CHARA_STATUS).
     *
     * @mangled CheckDrawCharaShadow__6CSceneFi
     * @address 0x2CD560
     * @size 0x74
     */
    int CheckDrawCharaShadow(int index);

    /**
     *
     * Advances the character in a slot by one frame.
     *
     * @mangled StepChara__6CSceneFi
     * @address 0x2CD5E0
     * @size 0xF8
     */
    int StepChara(int index);

    /**
     *
     * Works out the lighting of a character at a position from the active maps.
     *
     * @mangled GetCharaLighting__6CSceneFPA4_fPf
     * @address 0x2CD6E0
     * @size 0x210
     */
    void GetCharaLighting(float (*light)[4], float *ambient);

    void SetVillagerTexb(int texb, int num) {
        villager_texb = texb;
        villager_texb_num = num;
    }

    void SetEventTexb(int texb, int num) {
        event_texb = texb;
        event_texb_num = num;
    }

    /**
     *
     * Returns the first texture block reserved for event images.
     *
     */
    int GetEventTexb() {
        return event_texb;
    }

    int GetTextureBlockNo(int group, int *out_block, int max) {
        return mds_list_set.GetTextureBlockNo(group, out_block, max);
    }

    /**
     *
     * Draws the character in a slot.
     *
     * @mangled DrawChara__6CSceneFii
     * @address 0x2CD8F0
     * @size 0x2F8
     */
    int DrawChara(int index, int pass);

    /**
     *
     * Draws the shadow of the character in a slot.
     *
     * @mangled DrawCharaShadow__6CSceneFi
     * @address 0x2CDBF0
     * @size 0x14C
     */
    int DrawCharaShadow(int no);

    /**
     *
     * Draws an exclamation mark model over the characters that call for it.
     *
     * @mangled DrawExclamationMark__6CSceneFP8mgCFrame
     * @address 0x2CDD40
     * @size 0x114
     */
    void DrawExclamationMark(mgCFrame *frame);

    /**
     *
     * Finds a texture block used by a villager slot of a character number, or -1.
     *
     * @mangled SearchCharaTexb__6CSceneFi
     * @address 0x2CDE60
     * @size 0x9C
     */
    int SearchCharaTexb(int slot);

    /**
     *
     * Starts reading in the background the models of the villagers of a map; gives back their number.
     *
     * @mangled PreLoadVillager__6CSceneFiP1
     * @address 0x2CDF00
     * @size 0x94
     */
    int PreLoadVillager(int map_id, u_long128 *cache);

    /**
     *
     * Ends the background reading of villager models.
     *
     * @mangled PreLoadVillagerEnd__6CSceneFv
     * @address 0x2CDFA0
     * @size 0x8
     */
    void PreLoadVillagerEnd();

    /**
     *
     * Removes the villager of a character number.
     *
     * @mangled DeleteVillager__6CSceneFi
     * @address 0x2CDFB0
     * @size 0x20
     */
    int DeleteVillager(int chara_id);

    /**
     *
     * Removes every sub villager.
     *
     * @mangled DeleteSubVillager__6CSceneFv
     * @address 0x2CDFD0
     * @size 0xB0
     */
    void DeleteSubVillager();

    /**
     *
     * Removes every villager.
     *
     * @mangled DeleteVillager__6CSceneFv
     * @address 0x2CE080
     * @size 0xB0
     */
    void DeleteVillager();

    /**
     *
     * Finds the character slot of a character number, or -1.
     *
     * @mangled SearchCharaID__6CSceneFi
     * @address 0x2CE130
     * @size 0x68
     */
    int SearchCharaID(int chara_id);

    /**
     *
     * Checks whether it is night, when the night villagers are placed.
     *
     * @mangled GetNowVillagerTime__6CSceneFv
     * @address 0x2CE1A0
     * @size 0x48
     */
    int GetNowVillagerTime();

    /**
     *
     * Lists the villagers placed on a map; gives back their number.
     *
     * @mangled GetLoadVillagerList__6CSceneFiPiPP18CVillagerPlaceInfo
     * @address 0x2CE1F0
     * @size 0x100
     */
    int GetLoadVillagerList(int map_id, int *chara_ids, CVillagerPlaceInfo **place);

    /**
     *
     * Finds a villager slot whose model a character number can copy, or -1.
     *
     * @mangled SearchCopyModel__6CSceneFi
     * @address 0x2CE2F0
     * @size 0xDC
     */
    int SearchCopyModel(int villager_id);

    /**
     *
     * Shows or hides the parts of the character in a slot as its villager settings ask.
     *
     * @mangled CharaObjectOnOff__6CSceneFiP9mgCMemory
     * @address 0x2CE4F0
     * @size 0x1C0
     */
    void CharaObjectOnOff(int index, mgCMemory *memory);

    /**
     *
     * Loads the villagers of a map.
     *
     * @mangled LoadVillager__6CSceneFii
     * @address 0x2CE6B0
     * @size 0x348
     */
    int LoadVillager(int map_no, int texb);

    /**
     *
     * Loads the sub villagers of a map.
     *
     * @mangled LoadSubVillager__6CSceneFii
     * @address 0x2CEA00
     * @size 0x338
     */
    int LoadSubVillager(int map_no, int texb);

    /**
     *
     * Places the villager in a slot at a numbered villager place.
     *
     * @mangled RegisterVillager__6CSceneFiii
     * @address 0x2CED40
     * @size 0x54
     */
    void RegisterVillager(int chara_id, int slot, int place_no);

    /**
     *
     * Places the villager in a slot with place settings.
     *
     * @mangled RegisterVillager__6CSceneFiiP18CVillagerPlaceInfo
     * @address 0x2CEDA0
     * @size 0x14
     */
    int RegisterVillager(int chara_id, int slot, CVillagerPlaceInfo *place);

    /**
     *
     * Places the villager in a slot where it stands now.
     *
     * @mangled RegisterVillager__6CSceneFiiP9mgCMemory
     * @address 0x2CEDC0
     * @size 0xF0
     */
    int RegisterVillager(int chara_id, int slot, mgCMemory *memory);

    /**
     *
     * Finds the villager to talk to at a position; gives back its event number, or zero.
     *
     * @mangled GetTalkEvent__6CSceneFPfP15CSceneEventData
     * @address 0x2CEEB0
     * @size 0x184
     */
    int GetTalkEvent(float *pos, CSceneEventData *event);

    /**
     *
     * Moves the villagers by one frame.
     *
     * @mangled StepVillager__6CSceneFv
     * @address 0x2CF1F0
     * @size 0x444
     */
    void StepVillager();

    /**
     *
     * Holds still the villagers near a position, flagging each one held.
     *
     * @mangled StayNearVillager__6CSceneFPfPi
     * @address 0x2CF640
     * @size 0x188
     */
    void StayNearVillager(float *pos, int *stay);

    /**
     *
     * Releases the villagers flagged as held.
     *
     * @mangled CancelStayVillager__6CSceneFPi
     * @address 0x2CF7D0
     * @size 0x80
     */
    void CancelStayVillager(int *flags);

    /**
     *
     * Holds still the villager of a character number.
     *
     * @mangled StayVillager__6CSceneFi
     * @address 0x2CF850
     * @size 0x3C
     */
    void StayVillager(int chara_id);

    /**
     *
     * Releases the villager of a character number.
     *
     * @mangled CancelStayVillager__6CSceneFi
     * @address 0x2CF890
     * @size 0xB0
     */
    void CancelStayVillager(int chara_id);

    /**
     *
     * Hands the villager of a character number over to event control.
     *
     * @mangled ExModeVillager__6CSceneFi
     * @address 0x2CF940
     * @size 0x3C
     */
    void ExModeVillager(int chara_id);

    /**
     *
     * Activates the villager slots of the map the player is in.
     *
     * @mangled SetActiveVillager__6CSceneFv
     * @address 0x2CF980
     * @size 0xF4
     */
    void SetActiveVillager();

    /**
     *
     * Finds the character nearest the screen centre; gives back zero when there is none.
     *
     * @mangled InScreenChara__6CSceneFPQ26CScene17InScreenCharaInfoPf
     * @address 0x2CFA80
     * @size 0x488
     */
    int InScreenChara(InScreenCharaInfo *info, float *range);

    /**
     *
     * Loads the game objects (save points, books and markers) of a map.
     *
     * @mangled LoadGameObject__6CSceneFiiP9mgCMemory
     * @address 0x2CFF10
     * @size 0x358
     */
    void LoadGameObject(int map_no, int tex_block, mgCMemory *memory);

    /**
     *
     * Finds the game object at a position; gives back its slot, or zero.
     *
     * @mangled GetGameObjectEvent__6CSceneFPfP15CSceneEventData
     * @address 0x2D0270
     * @size 0x19C
     */
    int GetGameObjectEvent(float *pos, CSceneEventData *event);

    /**
     *
     * Draws the game objects of the map.
     *
     * @mangled DrawGameObject__6CSceneFi
     * @address 0x2D0410
     * @size 0x25C
     */
    void DrawGameObject(int now_map_no);
};

STATIC_ASSERT(sizeof(CScene::BGM_INFO) == 0x460);
STATIC_ASSERT(sizeof(CScene::BGM_STATUS) == 0x1C);
STATIC_ASSERT(sizeof(CScene::InScreenCharaInfo) == 0xC);
STATIC_ASSERT(sizeof(CScene) == 0x10550);
