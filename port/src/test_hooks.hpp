#pragma once

#include <array>
#include <cstdint>
#include <optional>
#include <span>
#include <string_view>
#include <vector>

#include "mainloop.hpp"

class mgCCamera;
class mgCFrame;
class CScene;
class CGamePad;
class CRunScript;
struct CCPoly;

enum class JumpMode {
    Town,
    Georama,
    Dungeon,
    Event,
    Title,
    Opening,
    Menu
};

struct GameJump {
    JumpMode mode = JumpMode::Menu;
    int      map = 10;
    int      floor = 1;
    int      event = 0;
};

namespace dc2::debug {

/**
 * Describes the current native Halloween message and performance-input boundary.
 */
struct HalloweenPreambleInputContext {
    const CScene *scene = nullptr;     /**< Current combat scene. */
    const void   *program = nullptr;   /**< Current event program identity. */
    bool          exact_scene = false; /**< Whether the requested and resolved Halloween arena match. */
    bool          running = false;     /**< Whether the observed event program is still running. */
    bool          ready = false;       /**< Whether performance warmup has begun. */
    bool          started = false;     /**< Whether a measurement has ever begun. */
    bool          measuring = false;   /**< Whether a measurement window is active. */
    int           monster_id = -1;     /**< Current live boss identity. */
    int           tutorial_flags = 0;  /**< Actual boss tutorial bits. */
    bool          live_boss = false;   /**< Whether the drawn boss and its life metadata remain valid. */
    int           message_state = 0;   /**< Native state of event message zero. */
};

/**
 * Composes one explicitly enabled tutorial acknowledgement with ordinary controller samples.
 */
struct HalloweenPreambleInput {
    bool          enabled = false;   /**< Whether the explicit setup option is active. */
    bool          consumed = false;  /**< Whether this option lifetime already supplied its one edge. */
    const CScene *scene = nullptr;   /**< Scene that successfully started event 540. */
    const void   *program = nullptr; /**< Program that successfully started event 540. */

    /**
     * Replaces the observed event identity without renewing an already consumed acknowledgement.
     */
    void Observe(int event, const CScene *event_scene, const void *event_program, int result);
    /**
     * Adds one normal Circle press only to an eligible, fully shown pre-measurement tutorial.
     */
    bool Apply(CGamePad &pad, const HalloweenPreambleInputContext &context);
};

/**
 * Validates the explicit setup-input option against its requested event and measurement duration.
 */
constexpr bool HalloweenPreambleAcknowledgementAllowed(bool enabled, const GameJump *jump, int seconds) {
    return !enabled || (jump != nullptr && jump->mode == JumpMode::Event && jump->event == 21020 && seconds > 0);
}

/**
 * Configures the optional acknowledgement only for an explicitly measured Halloween event.
 */
bool ConfigureHalloweenPreambleAcknowledgement(bool enabled);
/**
 * Reports whether the explicit Halloween setup-input option is enabled.
 */
bool HalloweenPreambleAcknowledgementEnabled();
/**
 * Observes a real event start or invalidation without changing the event interpreter.
 */
void ObserveHalloweenPreambleEvent(int event, CScene *scene, CRunScript *script, int result);
/**
 * Composes the optional acknowledgement at the primary controller's ordinary consumption point.
 */
void ApplyHalloweenPreambleAcknowledgement(CGamePad &pad);

/**
 * Retains the native triangle broadphase bounds for one current collision snapshot.
 */
struct DungeonStressRayBounds {
    std::array<float, 4> minimum{};      /**< Native component minima. */
    std::array<float, 4> maximum{};      /**< Native component maxima. */
    bool                 finite = false; /**< Whether every source spatial coordinate is finite. */
};

/**
 * Refreshes retained broadphase bounds from the current native collision polygons.
 */
void DungeonStressPrepareRayBounds(std::span<CCPoly> polygons, std::vector<DungeonStressRayBounds> &bounds);

/**
 * Stably fills separate retained ray scratch without changing the native narrowphase.
 */
void DungeonStressSelectRayCandidates(std::span<const CCPoly> polygons, std::span<const DungeonStressRayBounds> bounds,
                                      std::array<float, 4> from, std::array<float, 4> to, std::vector<CCPoly> &candidates);

/**
 * Distinguishes the real enemy and chest bodies observed by the dungeon stress fixture.
 */
enum class DungeonStressEntityKind : std::uint8_t {
    Enemy,
    Chest
};

/**
 * Identifies one fixture body and the canonical tick that created its draw packet.
 */
struct DungeonStressBodyTag {
    std::uint64_t           generation = 0;                        /**< Fixture instance that owns the body. */
    std::uint64_t           tick = 0;                              /**< Canonical draw that created the packet. */
    DungeonStressEntityKind kind = DungeonStressEntityKind::Enemy; /**< Body category. */
    int                     slot = -1;                             /**< Native manager slot, independent of shared model identity. */
};

/**
 * Associates native body packet creation with one enemy or chest slot.
 */
class DungeonStressBodyScope {
    DungeonStressBodyTag previous; /**< Body identity restored after the native draw. */
public:
    /**
     * Selects one native body while its render packets are recorded.
     */
    DungeonStressBodyScope(DungeonStressEntityKind kind, int slot) noexcept;
    /**
     * Restores the enclosing native body's packet identity.
     */
    ~DungeonStressBodyScope();
    /**
     * Keeps packet identity restoration owned by one scope.
     */
    DungeonStressBodyScope(const DungeonStressBodyScope &) = delete;
    /**
     * Prevents replacing an active packet identity scope.
     */
    DungeonStressBodyScope &operator=(const DungeonStressBodyScope &) = delete;
};

/**
 * Reports whether the validated, disposable dungeon stress fixture is active.
 */
bool DungeonStressEnabled();

/**
 * Returns the language of the dungeon script to load; the debug-only boss events exist in the Japanese script alone.
 */
int JumpScriptLanguage(int language);

/**
 * Reports whether this run shows one monster of every kind its dungeon can place.
 */
bool RosterStressEnabled();

/**
 * Loads every kind of the current dungeon for the roster fixture.
 */
void RosterStressLoadMonsters(mgCMemory *memory);

/**
 * Places one monster of every loaded kind, replacing the floor's own placement when the fixture runs.
 */
bool RosterStressPlaceMonsters();

/**
 * Reports whether the roster fixture has framed its monsters, or is not running.
 */
bool RosterStressReady();

/**
 * Copies the body identity into a native packet before its deferred submission.
 */
DungeonStressBodyTag DungeonStressCurrentBody();

/**
 * Allows immutable triangle discovery until readiness freezes witnesses for warmup and measurement.
 */
bool DungeonStressCaptureWitnesses();

/**
 * Records an indexed body submission, permitting discovery or the current canonical body's first witness.
 */
bool DungeonStressBodySubmitted(DungeonStressBodyTag tag);

/**
 * Records a projected surface witness only when its current camera ray is unobstructed.
 */
bool DungeonStressObserveBodyWitness(DungeonStressBodyTag tag, std::array<float, 3> world_point, float pixel_area);

/**
 * Retains a posed body's complete native bounds for fixed-view setup and margin checks.
 */
void DungeonStressBodyBounds(mgCFrame *frame);

/**
 * Places the bounded fixture after the floor's ordinary treasure and scenery setup.
 */
void DungeonStressAfterTreasures();

/**
 * Activates the fixture's ten native floor actors instead of ordinary random placement.
 */
bool DungeonStressPlaceMonsters();

/**
 * Applies the fixture's legal fixed overview and starts its canonical body observation.
 */
void DungeonStressCamera(mgCCamera &camera);

/**
 * Extends only the fixture's normal visibility priority budget to ten actors.
 */
int DungeonStressPriorityLimit(int ordinary_limit);

/**
 * Applies the declared stress focal scale to the native per-tick projection before culling.
 */
float DungeonStressProjection(float focal_distance);

/**
 * Recognizes a live required boss identity or a generic actor marked as a boss.
 */
constexpr bool CombatBossActorReady(int expected_monster, int monster_id, bool live_active, bool boss_metadata) {
    return live_active && (expected_monster >= 0 ? monster_id == expected_monster : boss_metadata);
}

/**
 * Waits for Halloween's natural first-bomb tutorial and every event-request handoff to finish.
 */
constexpr bool CombatBossPreambleReady(int event, int monster_id, int tutorial_flags, int monster_pending,
                                       bool scene_present, int scene_pending, bool scene_running) {
    return event != 21020 || (monster_id == 500 && (tutorial_flags & 2) != 0 && monster_pending == -1 &&
                              scene_present && scene_pending < 0 && !scene_running);
}

/**
 * Classifies a combat floor from a complete PAL boss-event table, or reports incomplete or malformed input.
 */
std::optional<bool> CombatDungeonFloor(std::string_view event_table, int dungeon, int floor);

} // namespace dc2::debug

bool GameParseJump(std::string_view text, GameJump &jump);
bool GameParseGive(std::string_view text, std::vector<int> &items);
bool GameSetJump(std::string_view text);
bool GameSetGive(std::string_view text);
bool GameHasJump();
bool GameDebugEnabled();
void GameSetFastLoad(bool fast);
bool GameFastLoad();
void GameSetSkipEvents(bool skip);
bool GameSkipEvents();
void GameSetInvincible(bool invincible);
bool GameInvincible();
void GameDebugFrame(int mode);
void GamePrepareJump(int &mode, INIT_LOOP_ARG &arg);
void GameGiveOnArrival(int mode);
bool GameDeveloperMenuRequested(int mode);
bool GameDebugPauseRequested(CGamePad &pad);
bool GameDebugPauseResumeRequested(CGamePad &pad);

// Scene measurement: once the mode is under player control and warmed up, log one window a second, then exit.
void GameSetPerfSeconds(int seconds);
bool GamePerfEnabled();
// The game thread's work for one tick: its update and recording, then everything before its wait for the next tick.
void GamePerfTickTimes(double update_ms, double busy_ms);
void GamePerfStep(int mode);

void                         GameSetSeed(std::optional<std::uint32_t> seed);
std::optional<std::uint32_t> GameSeed();
