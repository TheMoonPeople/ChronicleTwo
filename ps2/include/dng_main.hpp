#pragma once

#include "common.h"

#include <libvu0.h>

#include "character.hpp"
#include "collision.hpp"
#include "colprim.hpp"
#include "dng_effect.hpp"
#include "dng_hud.hpp"
#include "dng_object.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the dungeon main-loop mode, which sets up a dungeon floor, runs
 * the player, monsters, events and menus on it each frame, and holds the
 * buffers, managers and effects that the rest of the dungeon code shares.
 */

class CActionChara;
class CWeaponElement;
class CAutoMapGen;
class CBPot;
class CCameraControl;
class CEffectScriptMan;
class CGeoStone;
class CHealingEffectMan;
class CMap;
class CMapEffectsManeger;
class CMiniEffPrimMan;
class CMonsterMan;
class CPot;
class CRandomCircle;
class CRedMarkModel;
class CSaveData;
class CSaveDataDungeon;
class CScene;
class CStartupEpisodeTitle;
class CTreasureBoxManager;
class CUserDataManager;
class BattleEffectMan;
class ClsMes;
class MessageTaskManager;
class mgCFrame;
struct DNG_BATTLE_AREA;
struct DNG_FLOOR_SAVE;
struct INIT_LOOP_ARG;
struct RUN_SCRIPT_ENV;

// clang-format off

/**
 *
 * What the dungeon main loop runs each frame.
 *
 */
enum DNG_STATUS_MODE {
    DNG_STATUS_FIELD      = 0, /**< The player moves about the floor. */
    DNG_STATUS_MENU       = 1, /**< The menu opened from the floor is up. */
    DNG_STATUS_EVENT      = 2, /**< An event script runs. */
    DNG_STATUS_EVENT_EDIT = 3, /**< The event editor runs. */
    DNG_STATUS_EVENT_MENU = 4, /**< The menu opened by an event is up. */
    DNG_STATUS_EXIT       = 5  /**< The dungeon is being left. */
};

// clang-format on

/**
 *
 * Holds the ground and special-area hits found while moving a character.
 *
 */
struct MoveCheckInfo {
    float         radius;          /**< Radius used by the movement query. */
    int           skip_ground;     /**< Skips the ground search when set. */
    int           landed;          /**< Indicates a ground contact. */
    CCPoly        ground_poly;     /**< Ground polygon under the character. */
    int           ground_found;    /**< Indicates that a ground polygon was found. */
    CCPoly        second_poly;     /**< Other polygon retained by the movement query. */
    sceVu0FVECTOR ground_point;    /**< Ground contact point. */
    int           width_result;    /**< Result of the width check. */
    int           in_water;        /**< Indicates a water-area contact. */
    sceVu0FVECTOR water_surface;   /**< Water surface contact point. */
    int           crossed_area;    /**< Indicates a special-area crossing. */
    float         signed_distance; /**< Signed distance to the special area. */
    sceVu0FVECTOR crossed_point;   /**< Special-area crossing point. */

    /**
     *
     * Clears the movement query state.
     *
     * @mangled Initialize__13MoveCheckInfoFv
     * @address 0x1CF550
     * @size 0x10
     */
    void Initialize() {
        memset(this, 0, sizeof(MoveCheckInfo));
    }

    void Clear() {
        Initialize();
    }
};

STATIC_ASSERT(sizeof(MoveCheckInfo) == 0x110);

/**
 *
 * State of the dungeon main loop that the dungeon's other code reads and changes.
 *
 */
struct DNG_STATUS {
    int   mode;          /**< What the main loop runs each frame, a DNG_STATUS_MODE. */
    int   dungeon_no;    /**< Dungeon that the loop was entered with. */
    int   eye_view;      /**< Non-zero while the first-person view is on. */
    int   active_item;   /**< Slot of the active item that the player uses. */
    float cursor_fade;   /**< Opacity of the active item cursor, from 0 to 1. */
    int   status_count;  /**< Frames counted towards the next status-ailment flash. */
    int   debug_window;  /**< Non-zero while the debug window is drawn. */
};

STATIC_ASSERT(sizeof(DNG_STATUS) == 0x1C);

/**
 *
 * Charging effect that gathers on the player's weapon.
 *
 */
struct ACCUME_EFFECT {
    mgCFrame *frame;          /**< Frame that the effect gathers on. */
    u8        unk_4[0x30C];
    int       mode;           /**< Stage of the effect that the action script set. */
    u8        unk_314[0xC];
    s32       unk_320;
    u8        unk_324[0xC];
};

STATIC_ASSERT(sizeof(ACCUME_EFFECT) == 0x330);

/**
 *
 * Stack from which the dungeon's long-lived objects are allocated.
 *
 */
extern mgCMemory *MainBuffer__2;

/**
 *
 * Buffer that the dungeon's files are read into.
 *
 */
extern u_long128 *BuffReadData;

/**
 *
 * Saved record of the floor that the player is on.
 *
 */
extern DNG_FLOOR_SAVE *NowFloorInfoPtr;

/**
 *
 * Throwable items that the action script uses.
 *
 */
extern RUN_SCRIPT_ENV ActionScriptEnv;

/**
 *
 * Player's characters, items and status in the save data.
 *
 */
extern CUserDataManager *DngUserData;

/**
 *
 * Save data that the dungeon reads and writes.
 *
 */
extern CSaveData *DngSaveData;

/**
 *
 * Dungeon part of the save data.
 *
 */
extern CSaveDataDungeon *DngSaveDataDungeon;

/**
 *
 * Scene that the dungeon runs in.
 *
 */
extern CScene *DngMainScene;

/**
 *
 * Dungeon settings that the main scene keeps.
 *
 */
extern DNG_BATTLE_AREA *BattleAreaScene;

/**
 *
 * Map of the floor that the player is on.
 *
 */
extern CMap *DngMainMap;

/**
 *
 * Monsters of the floor.
 *
 */
extern CMonsterMan *ActiveMonster;

/**
 *
 * Message window for the dungeon's prompts.
 *
 */
extern ClsMes *DngMess;

/**
 *
 * Message window for the dungeon's episode titles.
 *
 */
extern ClsMes *DngMess2;

/**
 *
 * Message window for event scripts.
 *
 */
extern ClsMes *EventMess;

/**
 *
 * Message window for monster messages.
 *
 */
extern ClsMes *MonsterMess;

/**
 *
 * Marker drawn over a target.
 *
 */
extern CRedMarkModel *RedMarkModel;

/**
 *
 * Model of the treasure chests.
 *
 */
extern CCharacter2 *TreasureBoxModel;

/**
 *
 * Treasure chests of the floor.
 *
 */
extern CTreasureBoxManager *TreasureBoxMan;

/**
 *
 * Character that the player controls.
 *
 */
extern CActionChara *MainChara__2;

/**
 *
 * Effect scripts of the dungeon.
 *
 */
extern CEffectScriptMan *FxScriptMan;

/**
 *
 * Collision shape of the pot that the player carries, or NULL for none.
 *
 */
extern CColPrim *BTsuboCol;

/**
 *
 * Pickups that lie on the floor.
 *
 */
extern CPullItemManager PullItemMan;

/**
 *
 * Model of the tornado effect.
 *
 */
extern mgCFrame *TornadoModel;

extern CAfterWire afterWire[16];

/**
 *
 * Packet list buffers, one per frame.
 *
 */
extern mgCMemory BuffPaketList[2];

/**
 *
 * Packet data buffers, one per frame.
 *
 */
extern mgCMemory BuffPaketData[2];

/**
 *
 * Buffer for the floor's map.
 *
 */
extern mgCMemory BuffStageMain;

/**
 *
 * Buffer for the floor's characters.
 *
 */
extern mgCMemory BuffStageChara;

/**
 *
 * Buffer for the floor's other data.
 *
 */
extern mgCMemory BuffStageSubData;

/**
 *
 * Buffer for the floor's other characters.
 *
 */
extern mgCMemory BuffStageSubChara;

/**
 *
 * Buffer for the event editor's work data.
 *
 */
extern mgCMemory BuffWorkData;

/**
 *
 * Buffer for the player's characters.
 *
 */
extern mgCMemory BuffCharacter;

/**
 *
 * Stacks for the player's characters.
 *
 */
extern mgCMemory BaseCharacter[6];

/**
 *
 * Buffer for temporary data.
 *
 */
extern mgCMemory BuffTempData;

/**
 *
 * Buffer for scripts.
 *
 */
extern mgCMemory BuffScriptData;

/**
 *
 * Work buffer of the effect scripts.
 *
 */
extern mgCMemory BuffEffectScriptData;

/**
 *
 * Buffers for event data.
 *
 */
extern mgCMemory BuffEventData[4];

/**
 *
 * Buffer for building models.
 *
 */
extern mgCMemory BuffMDTBuild;

/**
 *
 * Second buffer for building models.
 *
 */
extern mgCMemory BuffMDTBuild2;

/**
 *
 * State of the dungeon main loop.
 *
 */
extern DNG_STATUS DngStatus;

/**
 *
 * Map effects of the floor.
 *
 */
extern CMapEffectsManeger map_effect;

/**
 *
 * Charging effect on the player's weapon.
 *
 */
extern ACCUME_EFFECT AccumulateEffect;

/**
 *
 * Damage number shown over the player.
 *
 */
extern CDamageScore DamageScore;

/**
 *
 * Damage numbers shown over monsters.
 *
 */
extern CDamageScore DamageScoreMons[8];

/**
 *
 * Status damage number shown over the player.
 *
 */
extern CDamageScore2 DamageScore2;

/**
 *
 * Queued messages of the dungeon.
 *
 */
extern MessageTaskManager MsgTaskMan;

/**
 *
 * Episode title shown when a dungeon starts.
 *
 */
extern CStartupEpisodeTitle StartupEpisodeTitle;

/**
 *
 * Battle effects of the dungeon.
 *
 */
extern BattleEffectMan BattleFX;

/**
 *
 * Level-up notices.
 *
 */
extern CLevelupInfo LevelupInfo;

/**
 *
 * Lock-on marker.
 *
 */
extern CLockOnModel LockOnModel;

/**
 *
 * Low-gauge warning.
 *
 */
extern CWarningGage2 WarningGage2;

/**
 *
 * Map that the floor's automap is built from.
 *
 */
extern CAutoMapGen AutoMapGen;

/**
 *
 * Collision shapes of the dungeon's attacks.
 *
 */
extern CColPrimMan ColPrimMan;

/**
 *
 * Ring effect of the dungeon.
 *
 */
extern CRandomCircle RandomCircle;

/**
 *
 * Geostone of the floor.
 *
 */
extern CGeoStone GeoStone;

/**
 *
 * Camera that follows the player.
 *
 */
extern CCameraControl MainCamera;

/**
 *
 * Camera that event scripts move.
 *
 */
extern CCameraControl EventCamera__2;

/**
 *
 * Healing effect.
 *
 */
extern CHealingEffectMan HealingEffectMan;

/**
 *
 * Small primitive effects.
 *
 */
extern CMiniEffPrimMan MiniEffPrimMan;

/**
 *
 * Models of the throwable items, one per item kind.
 *
 */
extern CCharacter2 ItemBaseData[19];

/**
 *
 * Voice of the robot.
 *
 */
extern CRoboVoiceSystem VoiceUnit;

/**
 *
 * Pot that the player carries.
 *
 */
extern CPot BTsubo;

/**
 *
 * Breakable pot.
 *
 */
extern CBPot BTsubo2;

/**
 *
 * Rocket launcher shots.
 *
 */
extern CRocketLauncherMan RocketLauncher;

/**
 *
 * Machine gun.
 *
 */
extern CMachineGun MachineGun;

/**
 *
 * Laser gun shots.
 *
 */
extern CLaserGunMan LaserGun;

/**
 *
 * Model of the laser gun.
 *
 */
extern CCharacter2 LaserGunModel;

/**
 *
 * Pickup slots that PullItemMan hands out.
 *
 */
extern CPullItem PullItem[72];

/**
 *
 * Models of the spark effect.
 *
 */
extern mgCFrame *SparcModel[3];

/**
 *
 * Hands out the next weapon element effect, reusing them in turn.
 *
 * @mangled GetWeaponEffect__Fv
 * @address 0x1CD130
 * @size 0x40
 */
CWeaponElement *GetWeaponEffect();

/**
 *
 * Prepares the dungeon when the main loop enters it: memory, scene, cameras, models, effects and the floor.
 *
 * @mangled InitDungeonMain__F13INIT_LOOP_ARG
 * @address 0x1CD440
 * @size 0x2110
 */
void InitDungeonMain(INIT_LOOP_ARG arg);

/**
 *
 * Resets the dungeon's shared effects and pickups for a new floor.
 *
 * @mangled CommonStageClassInit__Fv
 * @address 0x1CF700
 * @size 0x450
 */
void CommonStageClassInit();

/**
 *
 * Releases the dungeon when the main loop leaves it.
 *
 * @mangled FinishDungeonMain__Fv
 * @address 0x1CFE10
 * @size 0x10
 */
void FinishDungeonMain();

/**
 *
 * Runs one frame of the dungeon, returning non-zero to leave it.
 *
 * @mangled LoopDungeonMain__Fv
 * @address 0x1CFE20
 * @size 0x690
 */
int LoopDungeonMain();

void EntryEventScript(int event_no);

void ResetEyeView(CActionChara *chara);
