#pragma once

#include "common.h"

#include <libvu0.h>

#include <span>

#include "actionchara.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "colprim.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "dng_hud.hpp"
#include "dng_object.hpp"
#include "effscript.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "pot.hpp"
#include "savedata.hpp"
#include "savedatadungeon.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

/**
 * @file
 * Declares the dungeon main-loop mode, which sets up a dungeon floor, runs
 * the player, monsters, events and menus on it each frame, and holds the
 * buffers, managers and effects that the rest of the dungeon code shares.
 */

namespace dc2::dungeon {
/**
 *
 * Gives the live allocated storage used for dungeon file reads.
 *
 */
std::span<u8> ReadStorage();

/**
 *
 * Restores the dungeon camera and player visibility when eye view ends.
 *
 */
void ResetEyeViewCore(CActionChara *character);

/**
 *
 * Selects the character requested by a dungeon change command.
 *
 */
int ChangeSetUnitCore(int change);

/**
 *
 * Handles the dungeon field's ordinary key commands.
 *
 */
int MainKeyCore();
} // namespace dc2::dungeon

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
 * Ranges of the scene's character slots that the dungeon fills.
 *
 */
enum DNG_CHARA_SLOT {
    DNG_CHARA_SLOT_PARTY = 0,    /**< First slot of the action characters; the player is in this slot. */
    DNG_CHARA_PARTY_NUM = 8,     /**< Number of action character slots. */
    DNG_CHARA_SLOT_EVENT = 8,    /**< First slot of the characters that events load. */
    DNG_CHARA_EVENT_NUM = 16,    /**< Number of event character slots. */
    DNG_CHARA_SLOT_MONSTER = 24, /**< First slot of the MONSTER_ACTIVE_MAX active monsters. */
    DNG_CHARA_SLOT_MONSTER_END = DNG_CHARA_SLOT_MONSTER + MONSTER_ACTIVE_MAX,
};

/**
 *
 * Numbers of entries in the dungeon's shared object and effect arrays.
 *
 */
enum DNG_MAIN_ARRAY_SIZE {
    DNG_BASE_CHARACTER_NUM = 7,    /**< Character stacks, including the temporary seventh stack. */
    DNG_EVENT_BUFFER_NUM = 4,      /**< Buffers in BuffEventData. */
    DNG_DAMAGE_SCORE_MONS_NUM = 8, /**< Damage numbers in DamageScoreMons. */
    DNG_ITEM_BASE_NUM = 19,        /**< Models in ItemBaseData. */
    DNG_AFTER_WIRE_NUM = 16,       /**< Wires in afterWire. */
    DNG_PULL_ITEM_NUM = 72,        /**< Pickup slots in PullItem. */
    DNG_SPARC_MODEL_NUM = 3,       /**< Models in SparcModel. */
    DNG_WEAPON_EFFECT_NUM = 8,     /**< Weapon element effects in wep_effect. */
    DNG_ELEMENT_EFFECT_NUM = 6,    /**< Effects in Sparc_fx, thunder, tornado, chillAfterHit and fireAfterHit. */
};

/**
 *
 * System event scripts that the dungeon starts by number.
 *
 */
enum DNG_SYSTEM_EVENT {
    DNG_EVENT_FLOOR_START = 1000,       /**< Runs when a floor is entered without an event of its own. */
    DNG_EVENT_TREASURE_BOX = 1100,      /**< Opens the treasure box the player stands at. */
    DNG_EVENT_RANDOM_CIRCLE = 1120,     /**< The player has stepped into a random circle. */
    DNG_EVENT_GEOSTONE = 1130,          /**< Examines the floor's geostone. */
    DNG_EVENT_MONSTER_TALK = 1150,      /**< Talks to a monster that can be spoken to. */
    DNG_EVENT_FLOOR_CLEAR = 1500,       /**< Every monster of the floor has been defeated. */
    DNG_EVENT_RANDOM_STONE = 2500,      /**< Examines a random stone before its first explanation. */
    DNG_EVENT_LEVEL_UP_GUIDE = 2520,    /**< Explains levelling up the first time it happens. */
    DNG_EVENT_ROBO_BIKE_GUIDE = 2530,   /**< Explains the ridepod's wheels the first time they are used. */
    DNG_EVENT_MAGIC_SWORD_GUIDE = 2540, /**< Explains the magic sword counter the first time it fills. */
};

/**
 *
 * Kinds of footstep effect that a floor surface raises, as DngStep's surface table holds them.
 *
 */
enum DNG_FOOT_EFFECT {
    DNG_FOOT_EFFECT_NONE = -1,  /**< No effect. */
    DNG_FOOT_EFFECT_DUST = 0,   /**< A puff of sand. */
    DNG_FOOT_EFFECT_GRASS = 1,  /**< A puff of sand with flying grass. */
    DNG_FOOT_EFFECT_SPLASH = 2, /**< A splash of water. */
};

/**
 *
 * Quick character changes the stick buttons ask ChangeSetUnit for.
 *
 */
enum DNG_CHANGE_UNIT {
    DNG_CHANGE_UNIT_PARTNER = 0, /**< Switches between Max and Monica (L3). */
    DNG_CHANGE_UNIT_RIDE = 1,    /**< Switches a character with the ridepod or the monster form (R3). */
};

/**
 *
 * State of the dungeon main loop that the dungeon's other code reads and changes.
 *
 */
struct DNG_STATUS {
    int   mode;         /**< What the main loop runs each frame, a DNG_STATUS_MODE. */
    int   dungeon_no;   /**< Dungeon that the loop was entered with. */
    int   eye_view;     /**< Non-zero while the first-person view is on. */
    int   active_item;  /**< Slot of the active item that the player uses. */
    float cursor_fade;  /**< Opacity of the active item cursor, from 0 to 1. */
    int   status_count; /**< Frames counted towards the next status-ailment flash. */
    int   debug_window; /**< Non-zero while the debug window is drawn. */
};

STATIC_ASSERT(sizeof(DNG_STATUS) == 0x1C);

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

namespace dc2::dungeon {
/**
 * Returns the checked scene-slot binding of the published dungeon map.
 */
[[nodiscard]] dc2::scene::MapView MainMap();

/**
 * Publishes a map view issued by its genuine owning scene slot.
 */
void SetMainMap(dc2::scene::MapView map);
} // namespace dc2::dungeon

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

/**
 *
 * Wires drawn behind the weapon growth pickups as they fly to the player.
 *
 */
extern CAfterWire afterWire[DNG_AFTER_WIRE_NUM];

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
extern mgCMemory BaseCharacter[DNG_BASE_CHARACTER_NUM];

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
extern mgCMemory BuffEventData[DNG_EVENT_BUFFER_NUM];

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
extern CDamageScore DamageScoreMons[DNG_DAMAGE_SCORE_MONS_NUM];

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
extern CCharacter2 ItemBaseData[DNG_ITEM_BASE_NUM];

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
extern CPullItem PullItem[DNG_PULL_ITEM_NUM];

/**
 *
 * Models of the spark effect.
 *
 */
extern mgCFrame *SparcModel[DNG_SPARC_MODEL_NUM];

/**
 *
 * Lightning effects of thunder-element hits.
 *
 */
extern CThunder thunder[DNG_ELEMENT_EFFECT_NUM];

/**
 *
 * Whirlwind effects of wind-element hits.
 *
 */
extern CTornado tornado[DNG_ELEMENT_EFFECT_NUM];

/**
 *
 * Frost effects left on monsters struck by ice-element hits.
 *
 */
extern CChillAfterHit chillAfterHit[DNG_ELEMENT_EFFECT_NUM];

/**
 *
 * Flame effects left on monsters struck by fire-element hits.
 *
 */
extern CFireAfterHit fireAfterHit[DNG_ELEMENT_EFFECT_NUM];

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

/**
 *
 * Loads the event script for the selected dungeon.
 *
 * @mangled EntryEventScript__Fi
 * @address 0x1CFC70
 * @size 0x194
 */
void EntryEventScript(int event_no);

/**
 *
 * Restores the follow camera and character display after eye view ends.
 *
 * @mangled ResetEyeView__FP12CActionChara
 * @address 0x1D52F0
 * @size 0xBC
 */
void ResetEyeView(CActionChara *chara);

/**
 *
 * Allocates the dungeon's packet, work, character, script and read buffers from the main stack.
 *
 * @mangled memoryInit__Fv
 * @address 0x1CD170
 * @size 0x2C8
 */
void memoryInit();

/**
 *
 * Resets the shared effects and pickups, then fills the battle effect pools.
 *
 * @mangled CommonClassInit__Fv
 * @address 0x1CFB50
 * @size 0x11C
 */
void CommonClassInit();

/**
 *
 * Draws the floor, its characters, effects and the dungeon's interface for the active camera.
 *
 * @mangled DngMainDraw__Fv
 * @address 0x1D04B0
 * @size 0x1634
 */
void DngMainDraw();

/**
 *
 * Moves the floor on by one frame: the player, monsters, characters, effects, pickups and the time of day.
 *
 * @mangled DngStep__Fv
 * @address 0x1D1AF0
 * @size 0xC98
 */
void DngStep();

/**
 *
 * Runs the event script one frame and switches the main loop's mode on its request, giving the new mode.
 *
 * @mangled RunMainEvent__Fv
 * @address 0x1D2790
 * @size 0x9C
 */
int RunMainEvent();

/**
 *
 * Handles the field mode's input for one frame: menus, character changes, the eye view and the camera.
 *
 * @mangled DngMainKey__Fv
 * @address 0x1D2830
 * @size 0x1E4C
 */
int DngMainKey();

/**
 *
 * Checks what the player stands at or has done and requests the matching system event.
 *
 * @mangled IsEventRun__Fv
 * @address 0x1D4680
 * @size 0x5DC
 */
void IsEventRun();

/**
 *
 * Starts a system event script and switches the main loop to event mode, giving true when it started.
 *
 * @mangled EventScriptSetup__FP18SYSTEM_SCRIPT_INFO
 * @address 0x1D4C60
 * @size 0xF8
 */
int EventScriptSetup(SYSTEM_SCRIPT_INFO *script);

/**
 *
 * Requests the death of the player's character once its hit points, or a monster form's weapon, run out.
 *
 * @mangled IsRunDeadEvent__FP12CActionChara
 * @address 0x1D4D60
 * @size 0x98
 */
int IsRunDeadEvent(CActionChara *chara);

/**
 *
 * Gives the character a DNG_CHANGE_UNIT quick change switches to, or -1 when none is allowed.
 *
 * @mangled ChangeSetUnit__Fi
 * @address 0x1D4E00
 * @size 0x140
 */
int ChangeSetUnit(int change);

/**
 *
 * Applies the damage and colour flashes of the player's status ailments.
 *
 * @mangled CheckStatusError__Fv
 * @address 0x1D4F40
 * @size 0x1F8
 */
void CheckStatusError();

/**
 *
 * Switches the camera to the eye view, facing where the character or the ridepod's arm faces.
 *
 * @mangled InitEyeCamera__FP12CActionChara
 * @address 0x1D5140
 * @size 0x100
 */
void InitEyeCamera(CActionChara *chara);

/**
 *
 * Hides the player's weapons while events ask for it, and shows them otherwise.
 *
 * @mangled CheckWeaponEnable__Fv
 * @address 0x1D5240
 * @size 0xA8
 */
void CheckWeaponEnable();

/**
 *
 * Draws the debug command menu and the debug monster loader when they are open.
 *
 * @mangled DebugMainDraw__Fv
 * @address 0x1D5690
 * @size 0x538
 */
void DebugMainDraw();

/**
 *
 * Starts an event script from the debug command menu.
 *
 * @mangled DBGCMD_RunScript__Fi
 * @address 0x1D5BD0
 * @size 0xB0
 */
void DBGCMD_RunScript(int no);
