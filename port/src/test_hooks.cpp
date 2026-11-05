#include "test_hooks.hpp"

#include <algorithm>
#include <array>
#include <charconv>
#include <chrono>
#include <climits>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <functional>
#include <limits>
#include <optional>
#include <sstream>
#include <string>
#include <thread>
#include <utility>
#include <vector>

#include "actionchara.hpp"
#include "automap.hpp"
#include "collision.hpp"
#include "dng_main.hpp"
#include "editloop.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "exitcodes.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "gameutil.hpp"
#include "log/log.hpp"
#include "main.hpp"
#include "map.hpp"
#include "mapparts.hpp"
#include "mapselect.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "options/screen.hpp"
#include "platform/config.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"
#include "platform/vfs.hpp"
#include "present.hpp"
#include "profile.hpp"
#include "render/renderer.hpp"
#include "render/shadow_mesh.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "title.hpp"
#include "userdata.hpp"

extern unsigned char PortGameBootInit asm("Title_GameBootInit");

namespace {
std::optional<GameJump>      target;
std::vector<int>             gifts;
bool                         fast_load = false;
bool                         skip_events = false;
bool                         invincible = false;
std::optional<std::uint32_t> seed;

/**
 * Holds the resolved debug destination that a performance sample must reach.
 */
struct PerfTarget {
    int           mode = LOOP_MENU;     /**< Main loop selected by the requested jump. */
    INIT_LOOP_ARG argument;             /**< Map, floor and event selected by the jump. */
    bool          combat_floor = false; /**< The requested dungeon floor requires a live combat encounter. */
};

std::optional<PerfTarget> perf_target;

using PerfClock = std::chrono::steady_clock;

// Sums of one-second measurement windows.
struct PerfSpan {
    int    ticks = 0;
    double update_ms = 0.0;
    double update_max_ms = 0.0;
    double busy_ms = 0.0;
    double busy_max_ms = 0.0;
};

struct PerfRun {
    /**
     * Initializes the inactive performance counters without allocating resources.
     */
    PerfRun() noexcept = default;

    int                                  seconds = 0;
    std::optional<PerfClock::time_point> ready;
    std::optional<PerfClock::time_point> window_start;
    PerfClock::time_point                started;
    std::optional<PerfClock::time_point> last_wait_log;
    int                                  windows = 0;
    PerfSpan                             window;
    PerfSpan                             total;
    PresentStats                         window_present;
    PresentStats                         start_present;
};

PerfRun perf;

/**
 * Owns the explicit one-shot Halloween setup-input lifetime.
 */
dc2::debug::HalloweenPreambleInput halloween_input;
/**
 * Borrows the permanent event interpreter whose successful start was observed.
 */
CRunScript *halloween_event_script = nullptr;
/**
 * Limits the setup eligibility receipt to the first fully shown message.
 */
bool halloween_input_observed_shown = false;

using StressPoint = std::array<float, 4>;
constexpr int kStressBodies = 10;

/**
 * Tracks one native actor without confusing manager slots with shared model addresses.
 */
struct StressEnemy {
    CActiveMonster *actor = nullptr;  /**< Actor returned by native activation. */
    int             slot = -1;        /**< Manager slot that must retain the actor. */
    int             monster_id = -1;  /**< Pinned floor roster identity. */
    int             locate_param = 0; /**< Original native floor placement parameter. */
};

/**
 * Holds the disposable floor fixture and its canonical body evidence.
 */
struct DungeonStress {
    std::vector<dc2::debug::DungeonStressRayBounds>                ray_bounds;                                                    /**< Current-snapshot native triangle bounds. */
    std::vector<CCPoly>                                            ray_candidates;                                                /**< Separate retained stable-order narrowphase scratch. */
    std::uint64_t                                                  ray_candidate_total = 0;                                       /**< Measured polygons admitted to the native narrowphase. */
    std::uint64_t                                                  ray_source_total = 0;                                          /**< Measured source polygons considered by cached broadphase. */
    std::uint64_t                                                  native_bounds_excursions = 0;                                  /**< Post-setup canonical framing-aid excursions. */
    std::uint64_t                                                  first_bounds_excursion_tick = 0;                               /**< First observed excursion retained for the footer. */
    std::uint64_t                                                  last_bounds_excursion_tick = 0;                                /**< Last unique canonical excursion. */
    std::uint64_t                                                  measured_preview_readbacks = 0;                                /**< Measured Windows diagnostic readback calls. */
    bool                                                           first_bounds_valid = false;                                    /**< Whether every first-excursion corner projected successfully. */
    std::array<float, 4>                                           first_bounds_union{};                                          /**< First projected native hierarchy union. */
    std::array<float, 4>                                           first_bounds_frame{};                                          /**< First excursion's physical visible frame. */
    std::array<std::array<float, 4>, 20>                           first_bounds_slots{};                                          /**< Per-body framing bounds retained without measured logging. */
    std::uint64_t                                                  camera_started_tick = 0;                                       /**< First observation using the current legal eye. */
    std::uint64_t                                                  last_stable_view_tick = 0;                                     /**< Last setup observation included in the fit stability count. */
    int                                                            stable_view_ticks = 0;                                         /**< Consecutive complete body observations before freezing the tuple. */
    float                                                          projection_scale = 0.8f;                                       /**< Bounded declared fixture focal multiplier. */
    float                                                          layout_spacing = 0.0f;                                         /**< Validated spacing independent of roster-to-pose permutation. */
    StressPoint                                                    player_position{};                                             /**< One-time legal player midpoint between approach bearings. */
    std::array<mgVu0FBOX, 20>                                      body_bounds{};                                                 /**< Current native hierarchy bounds used only for framing. */
    std::array<bool, 20>                                           has_body_bounds{};                                             /**< Bodies with current native bounds. */
    int                                                            fit_adjustments = 0;                                           /**< Bounded setup-only adjustments for the current legal eye. */
    float                                                          projection_base = 0.0f;                                        /**< Native per-tick focal distance before the fixture scale. */
    float                                                          projection_selected = 0.0f;                                    /**< Declared focal distance used by both culling and body drawing. */
    float                                                          aim_height = 0.0f;                                             /**< Midpoint of actual floor and native body/chest height range. */
    std::uint64_t                                                  last_setup_observation = 0;                                    /**< Last bounded pre-measurement camera diagnostic. */
    CCharacter2                                                   *chest_model = nullptr;                                         /**< Loaded native closed-box model. */
    mgCFrame                                                      *chest_frame = nullptr;                                         /**< Root of the actual box geometry. */
    mgCFrame                                                      *chest_lid = nullptr;                                           /**< Named tbox1 lid retained by every real box. */
    bool                                                           enabled = false;                                               /**< Explicit validated debug request. */
    bool                                                           treasures_placed = false;                                      /**< One-shot treasure phase completed. */
    bool                                                           monsters_placed = false;                                       /**< One-shot native actor activation completed. */
    bool                                                           player_placed = false;                                         /**< Fresh player pose was applied after entry control. */
    bool                                                           setup_logged = false;                                          /**< Fixed view first established all body witnesses. */
    bool                                                           measuring = false;                                             /**< Canonical observations belong to the measured interval. */
    std::uint64_t                                                  generation = 0;                                                /**< Fixture lifetime identity. */
    std::uint64_t                                                  tick = 0;                                                      /**< Current canonical packet identity. */
    std::uint64_t                                                  measured_tick = 0;                                             /**< Last observation included in the summary. */
    int                                                            canonical_ticks = 0;                                           /**< Measured canonical observations. */
    int                                                            failures = 0;                                                  /**< Invalid fixture conditions. */
    int                                                            setup_ticks = 0;                                               /**< Bounded controllable setup duration. */
    int                                                            room_id = -1;                                                  /**< Actual generated room selected for placement. */
    int                                                            layout_choice = -1;                                            /**< Deterministic placement candidate. */
    int                                                            camera_choice = 0;                                             /**< Collision-cleared overview candidate. */
    CMap                                                          *map = nullptr;                                                 /**< Loaded native floor identity. */
    StressPoint                                                    center{};                                                      /**< Validated one-time player placement. */
    StressPoint                                                    camera_pos{};                                                  /**< Fixed normal-projection eye. */
    StressPoint                                                    camera_ref{};                                                  /**< Fixed normal-projection reference point. */
    std::array<StressPoint, kStressBodies>                         enemy_positions{};                                             /**< Validated initial actor poses. */
    std::array<StressPoint, kStressBodies>                         chest_positions{};                                             /**< Validated closed chest poses. */
    std::array<StressEnemy, kStressBodies>                         enemies{};                                                     /**< Exact live native actors. */
    std::array<int, kStressBodies>                                 chest_slots{};                                                 /**< Exact real chest slots. */
    std::array<bool, static_cast<std::size_t>(kStressBodies) * 2U> submitted{};                                                   /**< Unique actual indexed body submissions this tick. */
    std::array<bool, static_cast<std::size_t>(kStressBodies) * 2U> witnessed{};                                                   /**< Unique projected and ray-clear bodies this tick. */
    std::array<int, 6>                                             minimum{INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX}; /**< Measured count lower bounds. */
    std::array<int, 6>                                             maximum{};                                                     /**< Measured count upper bounds. */
    std::vector<CCPoly>                                            polygons;                                                      /**< Current real collision polygons refreshed each canonical tick. */
    mgVu0FBOX                                                      collision_bounds{};                                            /**< Spatial domain covered by the collision snapshot. */
    double                                                         measured_map_refresh_ms = 0.0;                                 /**< Measured CPU cost of current-map collision collection. */
    double                                                         maximum_map_refresh_ms = 0.0;                                  /**< Largest measured current-map collection cost. */
};

/**
 * Holds the active disposable fixture and its bounded observation state.
 */
DungeonStress stress;
/**
 * Distinguishes fresh fixture lifetimes from stale recorded body tags.
 */
std::uint64_t stress_generation = 0;
/**
 * Identifies the current game-thread body recording scope.
 */
thread_local dc2::debug::DungeonStressBodyTag stress_body;
/**
 * Describes the latest bounded legal-layout search rejection.
 */
std::string_view stress_search_failure = "none";

/**
 * Stops rendering and rejects an invalid disposable stress sample.
 */
[[noreturn]] void StressInvalid(std::string_view reason) {
    ++stress.failures;
    CT_LOG_ERROR(Main, "perf invalid: stress {} generation={} tick={}", reason, stress.generation, stress.tick);
    // Stop replay before exit destroys its function-local interpolation scratch.
    gfx::RendererShutdown();
    LogFlush();
    std::exit(2);
}

/**
 * Checks the pinned dungeon, floor and live map identity.
 */
bool StressSceneValid() {
    return DngMainScene != nullptr && DngSaveDataDungeon != nullptr && DngStatus.dungeon_no == 0 &&
           DngSaveDataDungeon->floor_id[0] == 3 &&
           DngMainScene->GetMap(DngMainScene->active_map) == stress.map;
}

/**
 * Maps a current canonical entity tag to its unique fixture observation.
 */
int StressBodyIndex(dc2::debug::DungeonStressBodyTag tag) {
    if (!stress.enabled || tag.generation != stress.generation || tag.tick != stress.tick) {
        return -1;
    }
    for (int index = 0; index < kStressBodies; ++index) {
        if (tag.kind == dc2::debug::DungeonStressEntityKind::Enemy && stress.enemies[static_cast<std::size_t>(index)].slot == tag.slot) {
            return index;
        }
        if (tag.kind == dc2::debug::DungeonStressEntityKind::Chest && stress.chest_slots[static_cast<std::size_t>(index)] == tag.slot) {
            return index + kStressBodies;
        }
    }
    return -1;
}

/**
 * Tests a complete cached-map sight segment inside its bounded collision domain.
 */
bool StressRayClear(StressPoint from, StressPoint to) {
    CT_PROFILE_ZONE("Dungeon stress map ray");
    for (std::size_t axis = 0; axis < 3; ++axis) {
        if (!std::isfinite(from[axis]) || !std::isfinite(to[axis]) ||
            from[axis] <= stress.collision_bounds.min[axis] || from[axis] >= stress.collision_bounds.max[axis] ||
            to[axis] <= stress.collision_bounds.min[axis] || to[axis] >= stress.collision_bounds.max[axis]) {
            return false;
        }
    }
    dc2::debug::DungeonStressSelectRayCandidates(stress.polygons, stress.ray_bounds, from, to, stress.ray_candidates);
    if (stress.measuring) {
        stress.ray_candidate_total += stress.ray_candidates.size();
        stress.ray_source_total += stress.polygons.size();
    }
    StressPoint hit{};
    if (CheckHit(stress.ray_candidates.data(), static_cast<int>(stress.ray_candidates.size()), from.data(), to.data(), hit.data(), 1, 0) < 0) {
        return true;
    }
    // A surface witness may touch its supporting collision surface within float precision.
    const float dx = hit[0] - to[0];
    const float dy = hit[1] - to[1];
    const float dz = hit[2] - to[2];
    return dx * dx + dy * dy + dz * dz <= 0.25f;
}

/**
 * Refreshes the bounded current-map collision snapshot without accepting truncated geometry.
 */
bool StressRefreshCollision() {
    std::array<CMapParts *, 128> parts{};
    const int                    part_count = stress.map->GetPlaceColParts(&stress.collision_bounds, parts.data(), static_cast<int>(parts.size()));
    if (part_count <= 0 || std::cmp_greater_equal(part_count, parts.size())) {
        stress_search_failure = "collision-part-count";
        return false;
    }
    stress.polygons.resize(8192);
    const int count = stress.map->GetColPoly(stress.polygons.data(), stress.collision_bounds, static_cast<int>(stress.polygons.size()));
    if (count <= 0 || std::cmp_greater_equal(count, stress.polygons.size())) {
        stress_search_failure = "collision-poly-count";
        stress.polygons.clear();
        return false;
    }
    stress.polygons.resize(static_cast<std::size_t>(count));
    dc2::debug::DungeonStressPrepareRayBounds(stress.polygons, stress.ray_bounds);
    stress.ray_candidates.reserve(stress.polygons.size());
    return true;
}

/**
 * Finds confirmed flat native support without forbidden placement surfaces.
 */
bool StressFloorAt(float x, float z, float y, StressPoint &position) {
    StressPoint         from{x, y + 4200.0f, z, 1.0f};
    StressPoint         to{x, y - 4200.0f, z, 1.0f};
    std::array<int, 64> hit_polys{};
    float               hit_points[64][4]{};
    const int           count = CheckHits(stress.polygons.data(), static_cast<int>(stress.polygons.size()), from.data(), to.data(),
                                          static_cast<int>(hit_polys.size()), hit_polys.data(), hit_points, 0, 0);
    if (count <= 0 || std::cmp_greater_equal(count, hit_polys.size())) {
        stress_search_failure = "floor-hit-count";
        return false;
    }
    for (int index = 0; index < count; ++index) {
        const auto kind = stress.polygons[static_cast<std::size_t>(hit_polys[static_cast<std::size_t>(index)])].area_kind;
        if (kind == COL_AREA_NO_PLACE) {
            stress_search_failure = "no-place-surface";
            return false;
        }
        if (kind != COL_AREA_FLAT) {
            continue;
        }
        std::copy_n(hit_points[index], 4, position.begin());
        from = to = position;
        from[1] += 10.0f;
        to[1] -= 10.0f;
        if (CheckHit(stress.polygons.data(), static_cast<int>(stress.polygons.size()), from.data(), to.data(), position.data(), 1, 1) >= 0) {
            position[3] = 1.0f;
            for (std::size_t axis = 0; axis < 3; ++axis) {
                if (!std::isfinite(position[axis]) || position[axis] <= stress.collision_bounds.min[axis] + 32.0f ||
                    position[axis] >= stress.collision_bounds.max[axis] - 32.0f) {
                    stress_search_failure = "support-outside-collision-domain";
                    return false;
                }
            }
            return true;
        }
    }
    stress_search_failure = "no-flat-surface";
    return false;
}

/**
 * Checks native support, placement clearance and the fixture support footprint.
 */
bool StressLegalPosition(float x, float z, float y, StressPoint &position) {
    if (!StressFloorAt(x, z, y, position)) {
        return false;
    }
    if (!CheckObjectPutArea(position.data())) {
        stress_search_failure = "occupied-position";
        return false;
    }
    // Require supporting floor around the body rather than accepting a point on an edge.
    for (const auto offset : {
             std::array{24.0f,  0.0f  },
             std::array{-24.0f, 0.0f  },
             std::array{0.0f,   24.0f },
             std::array{0.0f,   -24.0f}
    }) {
        StressPoint edge{};
        if (!StressFloorAt(x + offset[0], z + offset[1], position[1], edge) || std::abs(edge[1] - position[1]) > 4.0f) {
            stress_search_failure = "body-support";
            return false;
        }
        StressPoint raised = edge;
        raised[1] += 40.0f;
        StressPoint origin = position;
        origin[1] += 40.0f;
        if (!StressRayClear(origin, raised)) {
            stress_search_failure = "side-obstruction";
            return false;
        }
    }
    return true;
}

/**
 * Selects one collision-checked fixed overview of the legal fixture.
 */
bool StressChooseCamera(int choice) {
    constexpr std::array height_factors{2.7f, 2.2f, 3.2f, 1.8f, 3.8f};
    if (choice < 0 || choice >= static_cast<int>(height_factors.size()) * 4) {
        return false;
    }
    const float          spacing = stress.layout_spacing;
    constexpr std::array directions{
        std::array{0.0f,  -1.0f},
        std::array{1.0f,  0.0f },
        std::array{-1.0f, 0.0f },
        std::array{0.0f,  1.0f }
    };
    const auto        direction = directions[static_cast<std::size_t>(choice % 4)];
    const StressPoint eye{stress.center[0] + direction[0] * 3.3f * spacing,
                          stress.center[1] + height_factors[static_cast<std::size_t>(choice / 4)] * spacing,
                          stress.center[2] + direction[1] * 3.3f * spacing, 1.0f};
    StressPoint       floor{};
    if (!StressFloorAt(eye[0], eye[2], stress.center[1], floor)) {
        return false;
    }
    floor[1] += 2.0f;
    if (!StressRayClear(floor, eye)) {
        return false;
    }
    for (int index = 0; index < kStressBodies; ++index) {
        for (auto point : {stress.enemy_positions[static_cast<std::size_t>(index)], stress.chest_positions[static_cast<std::size_t>(index)]}) {
            point[1] += 20.0f;
            if (!StressRayClear(eye, point)) {
                return false;
            }
        }
    }
    stress.camera_pos = eye;
    stress.camera_ref = {stress.center[0], stress.aim_height != 0.0f ? stress.aim_height : stress.center[1] + 16.0f, stress.center[2], 1.0f};
    stress.camera_choice = choice;
    stress.fit_adjustments = 0;
    stress.camera_started_tick = stress.tick;
    stress.stable_view_ticks = 0;
    return true;
}

/**
 * Chooses a deterministic legal room layout using native map geometry.
 */
bool StressChooseLayout() {
    if (AutoMapGen.room_num <= 0 || AutoMapGen.room_num > AUTOMAP_ROOM_MAX) {
        return false;
    }
    std::vector<int> rooms;
    rooms.reserve(static_cast<std::size_t>(AutoMapGen.room_num));
    for (int index = 0; index < AutoMapGen.room_num; ++index) {
        rooms.push_back(index);
    }
    std::ranges::stable_sort(rooms, [](int left, int right) {
        const auto &a = AutoMapGen.room[left];
        const auto &b = AutoMapGen.room[right];
        return static_cast<std::int64_t>(a.w) * a.h > static_cast<std::int64_t>(b.w) * b.h;
    });
    int choice = 0;
    for (int room : rooms) {
        if (room == AutoMapGen.door_room) {
            continue;
        }
        StressPoint center{};
        int         cells = 0;
        for (const auto &cell : AutoMapGen.GridCells()) {
            if (cell.room_no != room || cell.parts == nullptr || (cell.attr & AUTOMAP_ATTR_HIDE) != 0) {
                continue;
            }
            StressPoint point{};
            cell.parts->GetPosition(point.data());
            for (std::size_t axis = 0; axis < 3; ++axis) {
                center[axis] += point[axis];
            }
            ++cells;
        }
        if (cells == 0) {
            CT_LOG_INFO(Main, "perf stress search: room={} cells=0", room);
            continue;
        }
        for (std::size_t axis = 0; axis < 3; ++axis) {
            center[axis] /= static_cast<float>(cells);
        }
        center[3] = 1.0f;
        CT_LOG_INFO(Main, "perf stress search: room={} cells={} dimensions={}x{} center={},{},{}",
                    room, cells, AutoMapGen.room[room].w, AutoMapGen.room[room].h, center[0], center[1], center[2]);
        mgVu0FBOX bounds{};
        for (std::size_t axis = 0; axis < 3; ++axis) {
            const float extent = axis == 1 ? 4200.0f : 720.0f;
            bounds.min[axis] = center[axis] - extent;
            bounds.max[axis] = center[axis] + extent;
        }
        bounds.min[3] = bounds.max[3] = 1.0f;
        stress.collision_bounds = bounds;
        if (!StressRefreshCollision()) {
            CT_LOG_INFO(Main, "perf stress search: room={} collection_rejected={}", room, stress_search_failure);
            continue;
        }
        for (float spacing : {80.0f, 64.0f, 48.0f}) {
            ++choice;
            StressPoint player{};
            if (!StressLegalPosition(center[0], center[2], center[1], player)) {
                CT_LOG_INFO(Main, "perf stress search: room={} spacing={} player_rejected={}", room, spacing, stress_search_failure);
                continue;
            }
            bool legal = true;
            int  legal_enemies = 0;
            int  legal_chests = 0;
            for (int index = 0; index < kStressBodies; ++index) {
                const float x = center[0] + static_cast<float>(index % 5 - 2) * spacing;
                const int   row = index / 5;
                const float z = static_cast<float>(row + 1) * spacing;
                const bool  enemy_ok = StressLegalPosition(x, center[2] + z, player[1], stress.enemy_positions[static_cast<std::size_t>(index)]);
                const bool  chest_ok = StressLegalPosition(x, center[2] - z, player[1], stress.chest_positions[static_cast<std::size_t>(index)]);
                legal_enemies += enemy_ok ? 1 : 0;
                legal_chests += chest_ok ? 1 : 0;
                legal = enemy_ok && chest_ok && legal;
            }
            CT_LOG_INFO(Main, "perf stress search: room={} spacing={} ground_y={} legal_enemies={} legal_chests={} last_rejection={}",
                        room, spacing, player[1], legal_enemies, legal_chests, stress_search_failure);
            if (legal) {
                stress.center = player;
                stress.layout_spacing = spacing;
                stress.room_id = room;
                stress.layout_choice = choice;
                // The normal projection is unchanged; actual body witnesses still decide readiness.
                for (int attempt = 0; attempt < 20; ++attempt) {
                    const int camera = (attempt + 3) % 20;
                    if (StressChooseCamera(camera)) {
                        return true;
                    }
                }
                CT_LOG_INFO(Main, "perf stress search: room={} spacing={} legal_overviews=0", room, spacing);
            }
        }
    }
    return false;
}

/**
 * Counts current live actors, indexed body submissions and unobstructed projected witnesses.
 */
std::array<int, 6> StressCounts() {
    std::array<int, 6> counts{};
    if (!StressSceneValid() || ActiveMonster == nullptr || TreasureBoxMan == nullptr) {
        return counts;
    }
    for (int slot = 0; slot < MONSTER_ACTIVE_MAX; ++slot) {
        const auto *actor = ActiveMonster->GetActiveMonster(slot);
        counts[0] += actor != nullptr && actor->chara_kind == ACTION_KIND_SCRIPT && actor->life > 0 ? 1 : 0;
    }
    for (const auto &box : TreasureBoxMan->box) {
        counts[3] += box.state != TREASURE_BOX_STATE_NONE ? 1 : 0;
    }
    for (int index = 0; index < kStressBodies; ++index) {
        const auto offset = static_cast<std::size_t>(index);
        counts[1] += stress.submitted[offset] ? 1 : 0;
        counts[2] += stress.witnessed[offset] ? 1 : 0;
        counts[4] += stress.submitted[offset + kStressBodies] ? 1 : 0;
        counts[5] += stress.witnessed[offset + kStressBodies] ? 1 : 0;
    }
    return counts;
}

/**
 * Projects every native hierarchy corner into the physical visible frame.
 */
bool StressProjectedBounds(std::array<float, 4> &bounds, std::array<float, 4> &frame, bool log_slots = false,
                           std::array<std::array<float, 4>, 20> *body_bounds = nullptr) {
    CT_PROFILE_ZONE("Dungeon stress projected native bounds");
    if (!std::ranges::all_of(stress.has_body_bounds, [](bool found) { return found; })) {
        return false;
    }
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    const auto visible = gfx::VisibleLogicalRect(gfx::kMainTarget);
    frame = {std::max(0.0f, mapping.offset_x + visible.x * mapping.scale_x),
             std::max(0.0f, mapping.offset_y + visible.y * mapping.scale_y),
             std::min(static_cast<float>(mapping.pixel_width), mapping.offset_x + (visible.x + visible.w) * mapping.scale_x),
             std::min(static_cast<float>(mapping.pixel_height), mapping.offset_y + (visible.y + visible.h) * mapping.scale_y)};
    std::array<float, 16> matrix{};
    mgPortWorldToClip(matrix.data());
    bounds = {INFINITY, INFINITY, -INFINITY, -INFINITY};
    std::size_t body_index = 0;
    for (const auto &box : stress.body_bounds) {
        std::array<float, 4> body{INFINITY, INFINITY, -INFINITY, -INFINITY};
        for (unsigned corner = 0; corner < 8; ++corner) {
            const StressPoint world{(corner & 1U) != 0 ? box.max[0] : box.min[0],
                                    (corner & 2U) != 0 ? box.max[1] : box.min[1],
                                    (corner & 4U) != 0 ? box.max[2] : box.min[2], 1.0f};
            StressPoint       clip{};
            for (std::size_t row = 0; row < 4; ++row) {
                for (std::size_t column = 0; column < 4; ++column) {
                    clip[row] += matrix[column * 4 + row] * world[column];
                }
            }
            if (!std::ranges::all_of(clip, [](float value) { return std::isfinite(value); }) || clip[3] <= 0.0f || clip[2] < 0.0f || clip[2] > clip[3]) {
                return false;
            }
            const float x = (clip[0] / clip[3] + 1.0f) * 0.5f * static_cast<float>(mapping.pixel_width);
            const float y = (clip[1] / clip[3] + 1.0f) * 0.5f * static_cast<float>(mapping.pixel_height);
            bounds[0] = std::min(bounds[0], x);
            bounds[1] = std::min(bounds[1], y);
            bounds[2] = std::max(bounds[2], x);
            bounds[3] = std::max(bounds[3], y);
            body[0] = std::min(body[0], x);
            body[1] = std::min(body[1], y);
            body[2] = std::max(body[2], x);
            body[3] = std::max(body[3], y);
        }
        if (body_bounds != nullptr) {
            (*body_bounds)[body_index] = body;
        }
        if (log_slots) {
            const bool enemy = body_index < kStressBodies;
            const int  slot = enemy ? stress.enemies[body_index].slot : stress.chest_slots[body_index - kStressBodies];
            CT_LOG_INFO(Main, "perf stress full bounds: tick={} camera={} kind={} slot={} pixels={},{},{},{}",
                        stress.tick, stress.camera_choice, enemy ? "enemy" : "chest", slot, body[0], body[1], body[2], body[3]);
        }
        ++body_index;
    }
    return frame[2] > frame[0] && frame[3] > frame[1];
}

/**
 * Checks the setup framing inset against current native hierarchy bounds.
 */
bool StressWholeBodiesFit() {
    std::array<float, 4> bounds{};
    std::array<float, 4> frame{};
    if (!StressProjectedBounds(bounds, frame)) {
        return false;
    }
    const float margin_x = 0.02f * (frame[2] - frame[0]);
    const float margin_y = 0.02f * (frame[3] - frame[1]);
    return bounds[0] >= frame[0] + margin_x && bounds[1] >= frame[1] + margin_y &&
           bounds[2] <= frame[2] - margin_x && bounds[3] <= frame[3] - margin_y;
}

/**
 * Fits the fixed reference and focal distance to current projected native hierarchy bounds.
 */
bool StressFitSetup() {
    if (!stress.enabled || !stress.player_placed || stress.setup_logged || stress.tick == 0 || stress.tick % 15 != 0 ||
        !std::ranges::all_of(stress.has_body_bounds, [](bool found) { return found; })) {
        return false;
    }
    std::array<float, 4> bounds{}, frame{};
    if (!StressProjectedBounds(bounds, frame) || StressWholeBodiesFit() || stress.fit_adjustments >= 4) {
        return false;
    }
    const float center_x = 0.5f * (bounds[0] + bounds[2]);
    const float center_y = 0.5f * (bounds[1] + bounds[3]);
    const float radius_x = 0.5f * (bounds[2] - bounds[0]);
    const float radius_y = 0.5f * (bounds[3] - bounds[1]);
    const float ratio = std::min(0.48f * (frame[2] - frame[0]) / radius_x, 0.48f * (frame[3] - frame[1]) / radius_y);
    const float selected = ratio < 1.0f ? std::clamp(stress.projection_scale * ratio * 0.98f, 0.45f, 0.8f) : stress.projection_scale;
    const auto  mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    const auto  identity = gfx::IdentityMeshTransform();
    const auto  transform = mgPortMeshTransform(identity.model);
    if (mapping.pixel_width == 0 || mapping.pixel_height == 0 || transform.projection[0] == 0.0f || transform.projection[5] == 0.0f) {
        return false;
    }
    // Invert this frame's actual perspective ray and orthonormal camera rotation.
    const std::array     ray{(2.0f * center_x / static_cast<float>(mapping.pixel_width) - 1.0f - transform.projection[8]) / transform.projection[0],
                             (2.0f * center_y / static_cast<float>(mapping.pixel_height) - 1.0f - transform.projection[9]) / transform.projection[5], 1.0f};
    std::array<float, 3> direction{};
    for (std::size_t world_axis = 0; world_axis < 3; ++world_axis) {
        for (std::size_t view_axis = 0; view_axis < 3; ++view_axis) {
            direction[world_axis] += transform.view[world_axis * 4 + view_axis] * ray[view_axis];
        }
    }
    const float length = std::sqrt(direction[0] * direction[0] + direction[1] * direction[1] + direction[2] * direction[2]);
    const float dx = stress.camera_ref[0] - stress.camera_pos[0];
    const float dy = stress.camera_ref[1] - stress.camera_pos[1];
    const float dz = stress.camera_ref[2] - stress.camera_pos[2];
    const float reach = std::sqrt(dx * dx + dy * dy + dz * dz);
    if (!std::isfinite(length) || length <= 0.0f || !std::isfinite(reach) || reach <= 0.0f) {
        return false;
    }
    for (std::size_t axis = 0; axis < 3; ++axis) {
        stress.camera_ref[axis] = stress.camera_pos[axis] + reach * direction[axis] / length;
    }
    stress.projection_scale = selected;
    stress.stable_view_ticks = 0;
    ++stress.fit_adjustments;
    CT_LOG_INFO(Main, "perf stress fit: tick={} full_bounds=20 method=unprojected-box-center aim={},{},{} focal_scale={} projected={},{},{},{} margin=0.02",
                stress.tick, stress.camera_ref[0], stress.camera_ref[1], stress.camera_ref[2], selected, bounds[0], bounds[1], bounds[2], bounds[3]);
    return true;
}

/**
 * Reports bounded setup observations and optional Windows preview pixels.
 */
void StressObserveSetup() {
    if (!stress.enabled || !stress.player_placed || stress.setup_logged || stress.tick % 45 != 44 ||
        stress.tick == stress.last_setup_observation || !StressSceneValid()) {
        return;
    }
    stress.last_setup_observation = stress.tick;
    std::array<float, 4> projected{}, frame{};
    const bool           projected_valid = StressProjectedBounds(projected, frame, true);
    CT_LOG_INFO(Main, "perf stress full union: tick={} camera={} valid={} pixels={},{},{},{} frame={},{},{},{} margin=0.02 fit={}",
                stress.tick, stress.camera_choice, projected_valid, projected[0], projected[1], projected[2], projected[3],
                frame[0], frame[1], frame[2], frame[3], StressWholeBodiesFit());
    const auto counts = StressCounts();
    CT_LOG_INFO(Main, "perf stress view: tick={} camera={} priority_limit={} live_enemies={} submitted_enemies={} projected_ray_enemies={} live_chests={} submitted_chests={} projected_ray_chests={} collision_polygons={}",
                stress.tick, stress.camera_choice, ActiveMonster->priority_limit,
                counts[0], counts[1], counts[2], counts[3], counts[4], counts[5], stress.polygons.size());
    for (const auto &identity : stress.enemies) {
        const auto *actor = ActiveMonster->GetActiveMonster(identity.slot);
        if (actor != nullptr) {
            CT_LOG_INFO(Main, "perf stress view actor: slot={} body_width={} body_height={} priority={} view={} alpha={} view_alpha={} camera_alpha={} target_dist={} clip_dist={}",
                        identity.slot, actor->body_width, actor->body_height, actor->priority, actor->view_state,
                        actor->alpha, actor->view_alpha, actor->camera_alpha, actor->target_dist, actor->clip_dist);
        }
    }
    if (const char *directory = std::getenv("DC2_PERF_STRESS_SETUP_CAPTURE"); directory != nullptr && *directory != '\0') {
        // Setup captures run between canonical ticks and never inside the measured interval.
        gfx::RenderLease          lease;
        std::vector<std::uint8_t> pixels;
        std::uint32_t             width = 0;
        std::uint32_t             height = 0;
        const auto                path = PathsFromUtf8(directory) / ("camera-" + std::to_string(stress.camera_choice) + "-tick-" + std::to_string(stress.tick) + ".png");
        if (!gfx::ReadbackFrame(pixels, width, height) || !gfx::WritePng(path, pixels.data(), width, height)) {
            StressInvalid("pre-measurement setup capture failed");
        }
    }
}

/**
 * Validates current actor identities and fresh canonical body evidence.
 */
bool StressReady() {
    CT_PROFILE_ZONE("Dungeon stress readiness");
    if (!stress.enabled) {
        return true;
    }
    if (stress.measuring && stress.tick <= stress.measured_tick) {
        StressInvalid("a measured tick has no fresh canonical body observation");
    }
    bool ready = StressSceneValid() && stress.monsters_placed && stress.player_placed &&
                 ActiveMonster != nullptr && TreasureBoxMan != nullptr && ActiveMonster->priority_limit >= kStressBodies && BattleAreaScene != nullptr &&
                 (BattleAreaScene->pause_flag & (DNG_PAUSE_MONSTER_AI | DNG_PAUSE_MONSTER_DRAW | DNG_PAUSE_FIELD_STEP | DNG_PAUSE_MAP_DRAW)) == 0;
    if (ready) {
        for (int index = 0; index < kStressBodies; ++index) {
            const auto &identity = stress.enemies[static_cast<std::size_t>(index)];
            const auto *actor = ActiveMonster->GetActiveMonster(identity.slot);
            const auto &box = TreasureBoxMan->box[stress.chest_slots[static_cast<std::size_t>(index)]];
            ready = actor == identity.actor && actor != nullptr && actor->monster_id == identity.monster_id &&
                    actor->chara_kind == ACTION_KIND_SCRIPT && actor->life > 0 && actor->tbl != nullptr &&
                    actor->view_state != MONSTER_VIEW_OUT && actor->alpha >= 1.0f && actor->view_alpha >= 1.0f && actor->camera_alpha >= 1.0f &&
                    actor->target_dist < actor->clip_dist && (actor->attrib & MONSTER_ATTRIB_ALWAYS_VIEW) == 0 &&
                    (actor->status.attr & (MONSTER_STATUS_STOP | MONSTER_STATUS_STONE)) == 0 &&
                    box.state == TREASURE_BOX_STATE_UNOPENED && box.model == stress.chest_model && box.frame == stress.chest_frame &&
                    box.lid_frame == stress.chest_lid && (box.flags & TREASURE_BOX_FLAG_MIMIC) == 0 && ready;
        }
    }
    const auto counts = StressCounts();
    const bool whole_bounds_fit = StressWholeBodiesFit();
    ready = ready && std::ranges::all_of(counts, [](int count) { return count == kStressBodies; }) &&
            (stress.setup_logged || whole_bounds_fit);
    if (stress.setup_logged && !whole_bounds_fit && stress.last_bounds_excursion_tick != stress.tick) {
        stress.last_bounds_excursion_tick = stress.tick;
        ++stress.native_bounds_excursions;
        if (stress.native_bounds_excursions == 1) {
            stress.first_bounds_excursion_tick = stress.tick;
            stress.first_bounds_valid = StressProjectedBounds(stress.first_bounds_union, stress.first_bounds_frame, false, &stress.first_bounds_slots);
#ifndef __SWITCH__
            if (const char *directory = std::getenv("DC2_PERF_STRESS_SETUP_CAPTURE"); directory != nullptr && *directory != 0) {
                // This explicit Windows visual diagnostic can stall the measured preview.
                gfx::RenderLease          lease;
                std::vector<std::uint8_t> pixels;
                std::uint32_t             width = 0;
                std::uint32_t             height = 0;
                const auto                path = PathsFromUtf8(directory) / ("bounds-excursion-tick-" + std::to_string(stress.tick) + ".png");
                stress.measured_preview_readbacks += stress.measuring ? 1 : 0;
                if (gfx::ReadbackFrame(pixels, width, height)) {
                    gfx::WritePng(path, pixels.data(), width, height);
                }
            }
#endif
        }
    }
    if (!ready && stress.measuring) {
        CT_LOG_ERROR(Main, "perf stress lost: live_enemies={} submitted_enemies={} projected_ray_enemies={} live_chests={} submitted_chests={} projected_ray_chests={}",
                     counts[0], counts[1], counts[2], counts[3], counts[4], counts[5]);
        StressInvalid("required canonical body or live fixture count dropped");
    }
    if (!stress.setup_logged) {
        if (!ready) {
            stress.stable_view_ticks = 0;
        } else if (stress.last_stable_view_tick != stress.tick) {
            stress.last_stable_view_tick = stress.tick;
            ++stress.stable_view_ticks;
        }
        if (stress.stable_view_ticks < 30) {
            return false;
        }
    }
    if (ready && !stress.setup_logged) {
        stress.setup_logged = true;
        CT_LOG_INFO(Main, "perf stress setup: schema=1 generation={} dungeon=0 floor=3 seed=1 expected_enemies=10 expected_chests=10 scope=canonical30Hz ai_enabled=1 animation_enabled=1 fixed_camera=1 priority_limit={} room_id=room-{} layout_id=water-channel-0-3-seed1-v1-{}-camera{}",
                    stress.generation, ActiveMonster->priority_limit, stress.room_id, stress.layout_choice, stress.camera_choice);
        CT_LOG_INFO(Main, "perf stress camera: eye={},{},{} ref={},{},{} projection=fixture-focal focal_scale={} base_focal={} selected_focal={} verification=projected-indexed-body-and-map-ray outline_source=main-origin-named-outline-shared-depth-matched-mapping final_pixel_occlusion=not-certified",
                    stress.camera_pos[0], stress.camera_pos[1], stress.camera_pos[2], stress.camera_ref[0], stress.camera_ref[1], stress.camera_ref[2],
                    stress.projection_scale, stress.projection_base, stress.projection_selected);
    }
    if (stress.measuring && stress.measured_tick != stress.tick) {
        stress.measured_tick = stress.tick;
        ++stress.canonical_ticks;
        for (std::size_t index = 0; index < counts.size(); ++index) {
            stress.minimum[index] = std::min(stress.minimum[index], counts[index]);
            stress.maximum[index] = std::max(stress.maximum[index], counts[index]);
        }
    }
    return ready;
}

/**
 * Reports measured population evidence and bounded framing diagnostics.
 */
void StressLogSummary() {
    if (!stress.enabled) {
        return;
    }
    CT_LOG_INFO(Main, "perf stress summary: schema=1 generation={} dungeon=0 floor=3 seed=1 expected_enemies=10 expected_chests=10 scope=canonical30Hz ai_enabled=1 animation_enabled=1 canonical_ticks={} failures={} enemies_live_min={} enemies_live_max={} enemies_submitted_min={} enemies_submitted_max={} enemies_projected_ray_min={} enemies_projected_ray_max={} chests_live_min={} chests_live_max={} chests_submitted_min={} chests_submitted_max={} chests_projected_ray_min={} chests_projected_ray_max={}",
                stress.generation, stress.canonical_ticks, stress.failures,
                stress.minimum[0], stress.maximum[0], stress.minimum[1], stress.maximum[1], stress.minimum[2], stress.maximum[2],
                stress.minimum[3], stress.maximum[3], stress.minimum[4], stress.maximum[4], stress.minimum[5], stress.maximum[5]);
    CT_LOG_INFO(Main, "perf stress observer: collision_refresh_ms_total={} collision_refresh_ms_max={} collision_polygons={} collision_part_limit=128 collision_poly_limit=8192 observer_extra_gpu_queries=0 observer_extra_gpu_waits={} measured_preview_readbacks={}",
                stress.measured_map_refresh_ms, stress.maximum_map_refresh_ms, stress.polygons.size(),
                stress.measured_preview_readbacks == 0 ? "0" : "unquantified-preview-readback", stress.measured_preview_readbacks);
    const auto shadow_stats = dc2::render::GetShadowMeshStats();
    CT_LOG_INFO(Main, "perf shadow memo: scope=lifetime draws={} memoized={} reference={} source_corners={} transformed_positions={} topology_hits={} topology_rebuilds={}",
                shadow_stats.draws, shadow_stats.memoized_draws, shadow_stats.reference_draws, shadow_stats.source_corners,
                shadow_stats.transformed_positions, shadow_stats.topology_hits, shadow_stats.topology_rebuilds);
    CT_LOG_INFO(Main, "perf stress ray broadphase: source_polygons={} candidate_polygons={} snapshot_refresh=every-canonical native_narrowphase=unchanged stable_order=1", stress.ray_source_total, stress.ray_candidate_total);
    CT_LOG_INFO(Main, "perf stress native bounds: scope=post-setup-canonical purpose=framing-diagnostic containment_required=0 excursions={} first_tick={} valid={} pixels={},{},{},{} frame={},{},{},{} inset=0.02",
                stress.native_bounds_excursions, stress.first_bounds_excursion_tick, stress.first_bounds_valid,
                stress.first_bounds_union[0], stress.first_bounds_union[1], stress.first_bounds_union[2], stress.first_bounds_union[3],
                stress.first_bounds_frame[0], stress.first_bounds_frame[1], stress.first_bounds_frame[2], stress.first_bounds_frame[3]);
    if (stress.first_bounds_valid) {
        for (std::size_t index = 0; index < stress.first_bounds_slots.size(); ++index) {
            const auto &bounds = stress.first_bounds_slots[index];
            CT_LOG_INFO(Main, "perf stress native bounds slot: first_tick={} kind={} index={} pixels={},{},{},{}",
                        stress.first_bounds_excursion_tick, index < kStressBodies ? "enemy" : "chest", index % kStressBodies,
                        bounds[0], bounds[1], bounds[2], bounds[3]);
        }
    }
}

// Control returns after loading and the arrival scene; time before then is not part of the scene.
constexpr std::chrono::seconds kPerfWarmup{1};

/**
 * Records the exact queued-image sequence boundary for captured presentation measurements.
 */
void PerfLogMarker(const char *boundary) {
    if (std::strcmp(boundary, "end") == 0) {
        gfx::LogAttachmentAlphaTrace();
    }
    const auto marker = gfx::GetPresentMarkerSnapshot();
    if (marker.enabled) {
        CT_LOG_INFO(Main, "perf marker {}: instance {} sequence {} accepted {} failed {} boundary_ns {} present_ns {}",
                    boundary, marker.renderer_instance, marker.last_sequence, marker.accepted, marker.failed,
                    marker.boundary_ns, marker.last_present_ns);
    }
}

/**
 * Counts the live active monster actors in the current dungeon scene.
 */
int PerfMonsterCount() {
    int count = 0;
    if (ActiveMonster != nullptr) {
        for (int index = 0; index < MONSTER_ACTIVE_MAX; ++index) {
            CActiveMonster *monster = ActiveMonster->GetActiveMonster(index);
            count += monster != nullptr && monster->IsDraw(1) != 0 ? 1 : 0;
        }
    }
    return count;
}

/**
 * Distinguishes the retail combat boss events from their three subgame entries.
 */
bool CombatBossEvent(int event) {
    return event >= 21010 && event <= 28020 && event != 22010 && event != 22020 && event != 23010;
}

/**
 * Reports whether the requested event or cached dungeon floor requires combat actors.
 */
bool PerfCombatBoss() {
    return (target && target->mode == JumpMode::Event && CombatBossEvent(target->event)) ||
           (perf_target && perf_target->combat_floor);
}

/**
 * Checks the live boss actors required by the debug event's opponent setup.
 */
bool PerfBossActorsReady() {
    if (!target) {
        return false;
    }
    int expected_monster = -1;
    switch (target->event) {
        case 25010:
            expected_monster = 517;
            break;
        case 25020:
            expected_monster = 512;
            break;
        case 25030:
            expected_monster = 511;
            break;
        case 26040:
            expected_monster = 613;
            break;
        default:
            break;
    }
    if (ActiveMonster != nullptr) {
        for (int index = 0; index < MONSTER_ACTIVE_MAX; ++index) {
            CActiveMonster *monster = ActiveMonster->GetActiveMonster(index);
            if (monster != nullptr && dc2::debug::CombatBossActorReady(expected_monster, monster->monster_id, monster->IsDraw(1) != 0, monster->tbl != nullptr && monster->tbl->boss != 0) &&
                dc2::debug::CombatBossPreambleReady(target->event, monster->monster_id, monster->script_vars[7].i,
                                                    monster->event_no, BattleAreaScene != nullptr,
                                                    BattleAreaScene != nullptr ? BattleAreaScene->script.event_no : -1,
                                                    BattleAreaScene != nullptr && BattleAreaScene->script.running != 0)) {
                return true;
            }
        }
    }
    return false;
}

/**
 * Logs the requested destination and the live scene and actors used by a sample.
 */
void PerfLogScene(const char *phase, int mode) {
    const auto *save = GetSaveData();
    const int   dungeon = mode == LOOP_DUNGEON ? DngStatus.dungeon_no : -1;
    const int   floor = mode == LOOP_DUNGEON && DngSaveDataDungeon != nullptr && dungeon >= 0 && dungeon < SAVE_DUNGEON_NUM
                            ? DngSaveDataDungeon->floor_id[dungeon]
                            : -1;
    CT_LOG_INFO(Main, "perf scene {} requested_kind {} requested_map {} requested_floor {} requested_event {} resolved_loop {} resolved_map {} resolved_floor {} resolved_event {} actual_loop {} actual_map {} actual_submap {} actual_dungeon {} actual_floor {} control {} monsters {} boss_life {} combat_expected {}",
                phase, target ? static_cast<int>(target->mode) : -1, target ? target->map : -1,
                target ? target->floor : -1, target ? target->event : -1,
                perf_target ? perf_target->mode : -1, perf_target ? perf_target->argument.map_no : -1,
                perf_target ? perf_target->argument.floor_no : -1, perf_target ? perf_target->argument.event_no : -1,
                mode, save != nullptr ? save->map_no : -1, save != nullptr ? save->sub_map_no : -1,
                dungeon, floor, mode == LOOP_DUNGEON ? PortDungeonFieldControl() : PortTownFieldControl(),
                mode == LOOP_DUNGEON ? PerfMonsterCount() : 0,
                mode == LOOP_DUNGEON && ActiveMonster != nullptr ? ActiveMonster->boss_max_life : 0, PerfCombatBoss());
    if (mode == LOOP_DUNGEON && BattleAreaScene != nullptr) {
        CT_LOG_INFO(Main, "perf dungeon map {} pending_event {} event_running {} boss_map {} battle_clear {}",
                    BattleAreaScene->map_name, BattleAreaScene->script.event_no, BattleAreaScene->script.running,
                    BattleAreaScene->boss_map, BattleAreaScene->battle_clear);
    }
    if (mode == LOOP_DUNGEON && ActiveMonster != nullptr) {
        for (int index = 0; index < MONSTER_ACTIVE_MAX; ++index) {
            CActiveMonster *monster = ActiveMonster->GetActiveMonster(index);
            if (monster != nullptr && monster->IsDraw(1) != 0) {
                CT_LOG_INFO(Main, "perf actor slot {} monster_id {} program {}", index, monster->monster_id, monster->now_prog);
                if (target && target->mode == JumpMode::Event && target->event == 21020 && monster->monster_id == 500) {
                    CT_LOG_INFO(Main, "perf boss preamble: event=21020 monster=500 vars6={} vars7={} actor_pending={} scene_present={} scene_pending={} scene_running={}",
                                monster->script_vars[6].i, monster->script_vars[7].i, monster->event_no,
                                BattleAreaScene != nullptr, BattleAreaScene != nullptr ? BattleAreaScene->script.event_no : -1,
                                BattleAreaScene != nullptr && BattleAreaScene->script.running != 0);
                }
            }
        }
    }
}

bool PerfReady(int mode) {
    const int saved_stable_view_ticks = stress.stable_view_ticks;
    stress.stable_view_ticks = 0;
    if (perf_target) {
        if (mode != perf_target->mode) {
            return false;
        }
        if (mode == LOOP_EDIT) {
            const auto *save = GetSaveData();
            if (save == nullptr || (save->map_no != perf_target->argument.map_no && save->sub_map_no != perf_target->argument.map_no)) {
                return false;
            }
        }
        if (mode == LOOP_DUNGEON) {
            const int dungeon = DngStatus.dungeon_no;
            if (dungeon != perf_target->argument.map_no || dungeon < 0 || dungeon >= SAVE_DUNGEON_NUM ||
                DngSaveDataDungeon == nullptr || DngSaveDataDungeon->floor_id[dungeon] != perf_target->argument.floor_no) {
                return false;
            }
            // A combat event can return control before it has placed its opponent.
            if (PerfCombatBoss() && (!PerfBossActorsReady() || ActiveMonster == nullptr || ActiveMonster->boss_max_life <= 0)) {
                return false;
            }
        }
    }

    switch (mode) {
        case LOOP_MENU:
            return false;
        case LOOP_EDIT:
            return PortTownFieldControl() || IsEditMode() != 0;
        case LOOP_DUNGEON:
            if (!PortDungeonFieldControl()) {
                return false;
            }
            stress.stable_view_ticks = saved_stable_view_ticks;
            return StressReady();
        default:
            return true;
    }
}

void PerfAdd(PerfSpan &span, double update_ms, double busy_ms) {
    ++span.ticks;
    span.update_ms += update_ms;
    span.update_max_ms = std::max(span.update_max_ms, update_ms);
    span.busy_ms += busy_ms;
    span.busy_max_ms = std::max(span.busy_max_ms, busy_ms);
}

void PerfLog(const char *label, int mode, double seconds, const PerfSpan &span, const PresentStats &from) {
    const PresentStats now = PresentGetStats();
    const double       ticks = std::max(1, span.ticks);
    CT_LOG_INFO(Main, "perf {} {:.3f}s loop {} ticks {} presented {} canonical {} unfinished {} replay {} fps {:.2f} update {:.2f}/{:.2f} busy {:.2f}/{:.2f} draws {}",
                label, seconds, mode, span.ticks, now.presented - from.presented,
                now.canonical_presents - from.canonical_presents, now.unfinished_pairs - from.unfinished_pairs,
                now.replay_ticks - from.replay_ticks,
                static_cast<double>(now.presented - from.presented) / seconds, span.update_ms / ticks, span.update_max_ms,
                span.busy_ms / ticks, span.busy_max_ms, now.last_draws);
}

// Lists the zones that took the most game-thread time over the run, per game tick.
// Each zone's game-thread time at the last tick, and its largest single-tick time.
std::array<std::uint64_t, 512> zone_last{};
std::array<std::uint64_t, 512> zone_max{};

void PerfLogZones(int ticks) {
#ifndef CT_ENABLE_TRACY
    const int                               count = std::min(gfx::profile::site_count.load(), gfx::profile::kMaxSites);
    std::vector<const gfx::profile::Site *> order;
    for (int index = 0; index < count; ++index) {
        order.push_back(&gfx::profile::sites[static_cast<std::size_t>(index)]);
    }
    std::ranges::sort(order, std::greater{}, [](const gfx::profile::Site *site) { return site->game_ns.load(); });
    const double per_tick = 1.0e6 * std::max(1, ticks);
    for (const gfx::profile::Site *site : order) {
        if (site->game_count == 0 && site->other_count == 0) {
            continue;
        }
        CT_LOG_INFO(Main, "perf zone {:8.3f} ms/tick max {:7.3f} {:8.1f} calls/tick | other {:8.3f} ms/tick | {}",
                    static_cast<double>(site->game_ns.load()) / per_tick,
                    static_cast<double>(zone_max[static_cast<std::size_t>(site - gfx::profile::sites.data())]) / 1.0e6,
                    static_cast<double>(site->game_count.load()) / std::max(1, ticks),
                    static_cast<double>(site->other_ns.load()) / per_tick, site->name);
    }
#else
    static_cast<void>(ticks);
#endif
}

// The dungeon script event that loads the selected floor without opening the floor list.
constexpr int kDungeonFloorLoadEvent = 1010;

constexpr int kNoLimit = std::numeric_limits<int>::max();

bool Number(std::string_view text, int &value, int maximum) {
    if (text.empty()) {
        return false;
    }
    auto [end, error] = std::from_chars(text.data(), text.data() + text.size(), value);
    return error == std::errc{} && end == text.data() + text.size() && value >= 0 && value <= maximum;
}

[[noreturn]] void BadTarget() {
    CT_LOG_ERROR(Main, "bad --jump: target is absent from the game tables");
    LogFlush();
    std::exit(2);
}

void RequireKnownItem(int item) {
    if (GetCommonItemData(item) == nullptr) {
        CT_LOG_ERROR(Main, "bad --give: unknown item {}", item);
        LogFlush();
        std::exit(2);
    }
}

/**
 * Reads the complete event-view document used to resolve debug destinations.
 */
std::optional<std::string> ReadEventTable() {
    std::vector<std::uint8_t> bytes;
    if (!vfs::Read(vfs::Find(vfs::Base(), "event/view_pal.txt"), bytes) || bytes.empty()) {
        return std::nullopt;
    }
    return std::string(bytes.begin(), bytes.end());
}

/**
 * Visits tab-separated event rows until a destination predicate accepts one.
 */
template <typename Visitor>
bool VisitEventRows(std::string_view table, Visitor visitor) {
    std::istringstream file{std::string(table)};
    std::string        line;
    while (std::getline(file, line)) {
        std::vector<std::string_view> columns;
        std::string_view              rest = line;
        for (;;) {
            const auto tab = rest.find('	');
            columns.push_back(rest.substr(0, tab));
            if (tab == std::string_view::npos) {
                break;
            }
            rest.remove_prefix(tab + 1);
        }
        if (visitor(columns)) {
            return true;
        }
    }
    return false;
}

bool ResolveEvent(int event, int &mode, INIT_LOOP_ARG &arg) {
    const auto table = ReadEventTable();
    if (!table) {
        return false;
    }
    bool valid = false;
    VisitEventRows(*table, [&](const auto &columns) {
        int id = 0;
        if (columns.size() < 4 || !Number(columns[3], id, kNoLimit) || id != event) {
            return false;
        }
        arg.event_no = id;
        mode = LOOP_EDIT;
        if (!columns[1].empty()) {
            int dungeon = 0;
            if (!Number(columns[1], dungeon, 7) || dungeon == 0 || !Number(columns[2], arg.floor_no, 99)) {
                return true;
            }
            arg.map_no = dungeon - 1;
            mode = LOOP_DUNGEON;
        } else {
            std::string name(columns[0]);
            arg.map_no = SearchMapNo(name.data());
        }
        valid = arg.map_no >= 0;
        return true;
    });
    return valid;
}
} // namespace

namespace dc2::debug {

void HalloweenPreambleInput::Observe(int event, const CScene *event_scene, const void *event_program, int result) {
    scene = nullptr;
    program = nullptr;
    if (enabled && event == 540 && result == 1 && event_scene != nullptr && event_program != nullptr) {
        scene = event_scene;
        program = event_program;
    }
}

bool HalloweenPreambleInput::Apply(CGamePad &pad, const HalloweenPreambleInputContext &context) {
    constexpr int debug_modifier = PAD_L2 | PAD_SELECT;
    if (!enabled || consumed || scene == nullptr || program == nullptr || context.scene != scene ||
        context.program != program || !context.exact_scene || !context.running || context.ready ||
        context.started || context.measuring || context.monster_id != 500 || !context.live_boss ||
        (context.tutorial_flags & 2) == 0 || context.message_state != CLSMES_SHOWN || pad.key_lock != 0 ||
        ((pad.pad[0].button | pad.previous_pad[0].button) & PAD_CIRCLE) != 0 ||
        (pad.pad[0].button & debug_modifier) == debug_modifier ||
        (pad.previous_pad[0].button & debug_modifier) == debug_modifier) {
        return false;
    }
    pad.pad[0].button |= PAD_CIRCLE;
    consumed = true;
    return true;
}

bool ConfigureHalloweenPreambleAcknowledgement(bool enabled) {
    halloween_input = HalloweenPreambleInput{};
    halloween_event_script = nullptr;
    halloween_input_observed_shown = false;
    if (!HalloweenPreambleAcknowledgementAllowed(enabled, target ? &*target : nullptr, perf.seconds)) {
        return false;
    }
    halloween_input.enabled = enabled;
    return true;
}

bool HalloweenPreambleAcknowledgementEnabled() { return halloween_input.enabled; }

void ObserveHalloweenPreambleEvent(int event, CScene *scene, CRunScript *script, int result) {
    if (!halloween_input.enabled) {
        return;
    }
    halloween_input.Observe(event, scene, script != nullptr ? script->prog : nullptr, result);
    halloween_event_script = halloween_input.program != nullptr ? script : nullptr;
    if (event == 540 && result == 1) {
        CT_LOG_INFO(Main, "perf Halloween event observed: event=540 result={} bound={} running={}", result,
                    halloween_input.scene != nullptr, script != nullptr && !script->end);
    }
}

void ApplyHalloweenPreambleAcknowledgement(CGamePad &pad) {
    if (&pad != &GamePad__2 || !halloween_input.enabled || halloween_input.consumed || perf.ready ||
        perf.started != PerfClock::time_point{} || perf.window_start) {
        return;
    }
    HalloweenPreambleInputContext context;
    context.scene = DngMainScene;
    context.program = halloween_event_script != nullptr ? halloween_event_script->prog : nullptr;
    context.exact_scene = target && target->mode == JumpMode::Event && target->event == 21020 && perf_target &&
                          perf_target->mode == LOOP_DUNGEON && perf_target->argument.map_no == 0 &&
                          perf_target->argument.floor_no == 7 && GetNowLoopNo() == LOOP_DUNGEON &&
                          DngStatus.dungeon_no == 0 && DngMainScene != nullptr && DngSaveDataDungeon != nullptr &&
                          DngSaveDataDungeon->floor_id[0] == 7 && BattleAreaScene != nullptr &&
                          BattleAreaScene == &DngMainScene->battle_area &&
                          std::string_view(BattleAreaScene->map_name) == "d01b01";
    context.running = halloween_event_script != nullptr && !halloween_event_script->end && BattleAreaScene != nullptr &&
                      BattleAreaScene->script.running != 0 && EventScene == DngMainScene && DngStatus.mode == DNG_STATUS_EVENT;
    context.ready = perf.ready.has_value();
    context.started = perf.started != PerfClock::time_point{};
    context.measuring = perf.window_start.has_value();
    if (ActiveMonster != nullptr) {
        for (int slot = 0; slot < MONSTER_ACTIVE_MAX; ++slot) {
            auto *monster = ActiveMonster->GetActiveMonster(slot);
            if (monster != nullptr && monster->monster_id == 500 && monster->IsDraw(1) != 0) {
                context.monster_id = monster->monster_id;
                context.tutorial_flags = monster->script_vars[7].i;
                context.live_boss = monster->tbl != nullptr && monster->tbl->boss != 0 && ActiveMonster->boss_max_life > 0;
                break;
            }
        }
    }
    if (auto *message = GetEventMessage(0); message != nullptr) {
        context.message_state = message->State();
    }
    if (context.message_state == CLSMES_SHOWN && !halloween_input_observed_shown) {
        halloween_input_observed_shown = true;
        CT_LOG_INFO(Main, "perf Halloween input eligibility: bound={} scene_match={} program_match={} exact={} running={} live={} monster={} vars7={} key_lock={} debug_lock={} buttons={} previous={} loop={} mode={}",
                    halloween_input.scene != nullptr, context.scene == halloween_input.scene,
                    context.program == halloween_input.program, context.exact_scene, context.running,
                    context.live_boss, context.monster_id, context.tutorial_flags, pad.key_lock, pad.debug_key_lock,
                    pad.pad[0].button, pad.previous_pad[0].button, GetNowLoopNo(), DngStatus.mode);
    }
    if (halloween_input.Apply(pad, context)) {
        CT_LOG_INFO(Main, "perf Halloween preamble input: event=540 message_state={} vars7={} button=Circle edges=1 ready={} started={} measuring={}",
                    context.message_state, context.tutorial_flags, context.ready, context.started, context.measuring);
    }
}

void DungeonStressPrepareRayBounds(std::span<CCPoly> polygons, std::vector<DungeonStressRayBounds> &bounds) {
    bounds.resize(polygons.size());
    for (std::size_t index = 0; index < polygons.size(); ++index) {
        auto &poly = polygons[index];
        auto &box = bounds[index];
        mgVectorMaxMin(box.maximum.data(), box.minimum.data(), poly.vertex[0], poly.vertex[1], poly.vertex[2]);
        box.finite = true;
        for (const auto &vertex : poly.vertex) {
            for (std::size_t axis = 0; axis < 3; ++axis) {
                box.finite = box.finite && std::isfinite(vertex[axis]);
            }
        }
    }
}

void DungeonStressSelectRayCandidates(std::span<const CCPoly> polygons, std::span<const DungeonStressRayBounds> bounds,
                                      std::array<float, 4> from, std::array<float, 4> to, std::vector<CCPoly> &candidates) {
    candidates.clear();
    std::array<float, 4> segment_max{}, segment_min{};
    mgVectorMaxMin(segment_max.data(), segment_min.data(), from.data(), to.data());
    bool finite_segment = true;
    for (std::size_t axis = 0; axis < 3; ++axis) {
        finite_segment = finite_segment && std::isfinite(from[axis]) && std::isfinite(to[axis]);
    }
    for (std::size_t index = 0; index < polygons.size(); ++index) {
        if (bounds.size() == polygons.size() && bounds[index].finite && finite_segment) {
            const auto &box = bounds[index];
            // Preserve SegmentCrossesPoly's exact comparison order and boundary inclusion.
            if (segment_max[0] < box.minimum[0] || segment_max[1] < box.minimum[1] || segment_max[2] < box.minimum[2] ||
                !(segment_min[0] <= box.maximum[0]) || !(segment_min[1] <= box.maximum[1]) || !(segment_min[2] <= box.maximum[2])) {
                continue;
            }
        }
        candidates.push_back(polygons[index]);
    }
}

DungeonStressBodyScope::DungeonStressBodyScope(DungeonStressEntityKind kind, int slot) noexcept : previous(stress_body) {
    stress_body = stress.enabled && gfx::CurrentRenderTarget() == gfx::kMainTarget
                      ? DungeonStressBodyTag{.generation = stress.generation, .tick = stress.tick, .kind = kind, .slot = slot}
                      : DungeonStressBodyTag{};
}

DungeonStressBodyScope::~DungeonStressBodyScope() { stress_body = previous; }

bool DungeonStressEnabled() { return stress.enabled; }

DungeonStressBodyTag DungeonStressCurrentBody() { return stress_body; }

bool DungeonStressCaptureWitnesses() { return stress.enabled && !perf.ready; }

bool DungeonStressBodySubmitted(DungeonStressBodyTag tag) {
    const int index = StressBodyIndex(tag);
    if (index < 0) {
        return false;
    }
    stress.submitted[static_cast<std::size_t>(index)] = true;
    return DungeonStressCaptureWitnesses() || !stress.witnessed[static_cast<std::size_t>(index)];
}

void DungeonStressBodyBounds(mgCFrame *frame) {
    CT_PROFILE_ZONE("Dungeon stress native hierarchy bounds");
    const int index = StressBodyIndex(stress_body);
    if (index < 0 || frame == nullptr) {
        return;
    }
    mgVu0FBOX box{};
    if (frame->GetWorldBBox(&box) == 0) {
        return;
    }
    for (std::size_t axis = 0; axis < 3; ++axis) {
        if (!std::isfinite(box.min[axis]) || !std::isfinite(box.max[axis]) || box.max[axis] < box.min[axis]) {
            return;
        }
    }
    const auto offset = static_cast<std::size_t>(index);
    if (stress.has_body_bounds[offset]) {
        for (std::size_t axis = 0; axis < 3; ++axis) {
            stress.body_bounds[offset].min[axis] = std::min(stress.body_bounds[offset].min[axis], box.min[axis]);
            stress.body_bounds[offset].max[axis] = std::max(stress.body_bounds[offset].max[axis], box.max[axis]);
        }
    } else {
        stress.body_bounds[offset] = box;
        stress.has_body_bounds[offset] = true;
    }
}

bool DungeonStressObserveBodyWitness(DungeonStressBodyTag tag, std::array<float, 3> world_point, float pixel_area) {
    const int index = StressBodyIndex(tag);
    if (index < 0 || !stress.player_placed || !StressSceneValid() || !std::isfinite(pixel_area) || pixel_area < 1.0f) {
        return false;
    }
    StressPoint surface{world_point[0], world_point[1], world_point[2], 1.0f};
    for (std::size_t axis = 0; axis < 3; ++axis) {
        if (!std::isfinite(surface[axis]) || surface[axis] <= stress.collision_bounds.min[axis] || surface[axis] >= stress.collision_bounds.max[axis]) {
            return false;
        }
    }
    if (!StressRayClear(stress.camera_pos, surface)) {
        return false;
    }
    stress.witnessed[static_cast<std::size_t>(index)] = true;
    return true;
}

int DungeonStressPriorityLimit(int ordinary_limit) {
    return stress.enabled ? std::max(ordinary_limit, kStressBodies) : ordinary_limit;
}

float DungeonStressProjection(float focal_distance) {
    if (!stress.enabled) {
        return focal_distance;
    }
    if (!std::isfinite(focal_distance) || focal_distance <= 0.0f || (stress.measuring && focal_distance != stress.projection_base)) {
        StressInvalid("native focal distance changed or is invalid for the fixed fixture view");
    }
    stress.projection_base = focal_distance;
    stress.projection_selected = focal_distance * stress.projection_scale;
    return stress.projection_selected;
}

void DungeonStressAfterTreasures() {
    if (!stress.enabled) {
        return;
    }
    if (stress.treasures_placed || DngMainScene == nullptr || DngSaveDataDungeon == nullptr || DngStatus.dungeon_no != 0 ||
        DngSaveDataDungeon->floor_id[0] != 3 || ActiveMonster == nullptr || TreasureBoxMan == nullptr) {
        StressInvalid("treasure placement order or floor identity is invalid");
    }
    stress.map = DngMainScene->GetMap(DngMainScene->active_map);
    if (stress.map == nullptr || TreasureBoxMan->model == nullptr || TreasureBoxMan->col_frame == nullptr) {
        StressInvalid("real floor or chest references are not loaded");
    }
    stress.chest_model = TreasureBoxMan->model;
    stress.chest_frame = stress.chest_model->CObjectFrame::frame;
    stress.chest_lid = stress.chest_frame != nullptr ? stress.chest_frame->SearchFrame("tbox1") : nullptr;
    if (stress.chest_frame == nullptr || stress.chest_lid == nullptr) {
        StressInvalid("the loaded model has no actual tbox1 chest body and lid");
    }
    std::vector<int> occupied;
    std::vector<int> free_slots;
    for (int slot = 0; slot < TREASURE_BOX_MAX; ++slot) {
        const auto &box = TreasureBoxMan->box[slot];
        if (box.state == TREASURE_BOX_STATE_NONE) {
            free_slots.push_back(slot);
        } else if (box.state == TREASURE_BOX_STATE_UNOPENED && box.lid_open == 0.0f && box.frame == stress.chest_frame &&
                   box.lid_frame == stress.chest_lid && box.model == stress.chest_model && (box.flags & TREASURE_BOX_FLAG_MIMIC) == 0) {
            occupied.push_back(slot);
        } else {
            StressInvalid("fresh floor contains an unsupported active chest");
        }
    }
    if (occupied.empty() || occupied.size() > kStressBodies || occupied.size() + free_slots.size() < kStressBodies || !StressChooseLayout()) {
        StressInvalid("bounded room search found no validated twenty-body layout");
    }
    const auto ordinary = std::ranges::find_if(occupied, [](int slot) {
        const auto &box = TreasureBoxMan->box[slot];
        return slot >= 2 && slot <= 7 && (box.flags & TREASURE_BOX_FLAG_MIMIC) == 0 && box.item[0] > 0 && box.num[0] > 0;
    });
    if (ordinary == occupied.end()) {
        StressInvalid("native ordinary floor chest contents are unavailable");
    }
    const auto &example = TreasureBoxMan->box[*ordinary];
    const int   extra_item = example.item[0];
    if (extra_item <= 0 || extra_item > 32767) {
        StressInvalid("native chest item is invalid");
    }
    for (int index = 0; index < kStressBodies; ++index) {
        const auto  offset = static_cast<std::size_t>(index);
        const bool  existing = offset < occupied.size();
        const int   slot = existing ? occupied[offset] : free_slots[offset - occupied.size()];
        auto       &box = TreasureBoxMan->box[slot];
        StressPoint rotation{};
        box.GetRotation(rotation.data());
        const int flags = existing ? box.flags : example.flags;
        const int item0 = existing ? box.item[0] : extra_item;
        const int count0 = existing ? box.num[0] : example.num[0];
        const int item1 = existing ? box.item[1] : example.item[1];
        const int count1 = existing ? box.num[1] : example.num[1];
        TreasureBoxMan->PutTreasureBox(slot, stress.chest_positions[offset].data(), existing ? rotation[1] : 0.0f,
                                       flags, item0, count0, item1, count1);
        stress.chest_slots[offset] = slot;
        CT_LOG_INFO(Main, "perf stress chest: slot={} position={},{},{} flags={} item0={} count0={} item1={} count1={}",
                    slot, stress.chest_positions[offset][0], stress.chest_positions[offset][1], stress.chest_positions[offset][2],
                    flags, item0, count0, item1, count1);
    }
    stress.treasures_placed = true;
}

bool DungeonStressPlaceMonsters() {
    if (!stress.enabled) {
        return false;
    }
    if (!StressSceneValid() || !stress.treasures_placed || stress.monsters_placed || ActiveMonster == nullptr ||
        ActiveMonster->locate.num < kStressBodies) {
        StressInvalid("monster placement order or loaded floor population is invalid");
    }
    constexpr std::array expected_ids{24, 24, 24, 24, 32, 32, 32, 32, 60, 60};
    constexpr std::array expected_params{2404, 2407, 2406, 2405, 3202, 3200, 3203, 3201, 6001, 6000};
    for (int slot = 0; slot < MONSTER_ACTIVE_MAX; ++slot) {
        const auto *actor = ActiveMonster->GetActiveMonster(slot);
        if (actor != nullptr && actor->chara_kind == ACTION_KIND_SCRIPT && actor->life > 0) {
            StressInvalid("floor actors were activated before the fixture");
        }
    }
    DngMainScene->battle_area.battle_clear = false;
    const auto           original_poses = stress.enemy_positions;
    constexpr std::array pose_order{1, 3, 6, 8, 4, 5, 7, 9, 2, 0};
    for (std::size_t index = 0; index < pose_order.size(); ++index) {
        stress.enemy_positions[index] = original_poses[static_cast<std::size_t>(pose_order[index])];
    }
    if (!StressLegalPosition(stress.center[0], stress.center[2] + 1.5f * stress.layout_spacing, stress.center[1], stress.player_position)) {
        StressInvalid("the one-time player midpoint is not legally supported");
    }
    for (int index = 0; index < kStressBodies; ++index) {
        const auto offset = static_cast<std::size_t>(index);
        if (ActiveMonster->locate.monster_id[index] != expected_ids[offset] || ActiveMonster->locate.param[index] != expected_params[offset]) {
            StressInvalid("actual floor roster differs from the pinned native fixture");
        }
        const int   base = ActiveMonster->SearchBaseIndex(expected_ids[offset]);
        StressPoint direction{};
        auto       *actor = base >= 0 ? ActiveMonster->SetActiveMonster(base, stress.enemy_positions[offset].data(), direction.data(), -1) : nullptr;
        if (actor == nullptr) {
            StressInvalid("native actor activation failed");
        }
        const int slot = actor->chara_type - DNG_CHARA_SLOT_MONSTER;
        if (slot < 0 || slot >= MONSTER_ACTIVE_MAX || ActiveMonster->GetActiveMonster(slot) != actor || actor->tbl == nullptr) {
            StressInvalid("native actor slot identity is invalid");
        }
        actor->locate_param = ActiveMonster->locate.param[index];
        if (index == 0) {
            const int key = GetGateKeyIndex(0, 3);
            if (key >= 0) {
                actor->gate_key = static_cast<s16>(key);
            }
        }
        stress.enemies[offset] = {.actor = actor, .slot = slot, .monster_id = expected_ids[offset], .locate_param = actor->locate_param};
        CT_LOG_INFO(Main, "perf stress enemy: slot={} monster_id={} locate_param={} position={},{},{} gate_key={}",
                    slot, actor->monster_id, actor->locate_param, stress.enemy_positions[offset][0], stress.enemy_positions[offset][1],
                    stress.enemy_positions[offset][2], actor->gate_key);
    }
    float       lowest_ground = stress.center[1];
    float       highest_body = lowest_ground;
    mgVu0FBOX   chest_bounds{};
    const bool  has_chest_bounds = stress.chest_frame->GetWorldBBox(&chest_bounds) != 0;
    const float chest_height = has_chest_bounds ? chest_bounds.max[1] - chest_bounds.min[1] : 0.0f;
    if (!std::isfinite(chest_height) || chest_height <= 0.0f) {
        StressInvalid("native chest height is unavailable for fixed-view fitting");
    }
    for (std::size_t index = 0; index < stress.enemies.size(); ++index) {
        const float height = stress.enemies[index].actor->GetBodyHeight();
        if (!std::isfinite(height) || height <= 0.0f) {
            StressInvalid("native actor height is unavailable for fixed-view fitting");
        }
        lowest_ground = std::min({lowest_ground, stress.enemy_positions[index][1], stress.chest_positions[index][1]});
        highest_body = std::max({highest_body, stress.enemy_positions[index][1] + height, stress.chest_positions[index][1] + chest_height});
    }
    stress.aim_height = 0.5f * (lowest_ground + highest_body);
    for (const auto &identity : stress.enemies) {
        StressPoint position{};
        identity.actor->GetPosition(position.data());
        const float dx = position[0] - stress.player_position[0];
        const float dz = position[2] - stress.player_position[2];
        const float clearance = 2.0f * (identity.actor->GetBodyWidth() + MainChara__2->GetBodyWidth());
        if (!std::isfinite(clearance) || clearance <= 0.0f || dx * dx + dz * dz <= clearance * clearance) {
            StressInvalid("the player midpoint overlaps a real native actor body");
        }
    }
    stress.camera_ref[1] = stress.aim_height;
    CT_LOG_INFO(Main, "perf stress fitting: ground_min={} body_top_max={} aim_height={} chest_height={} spacing={}",
                lowest_ground, highest_body, stress.aim_height, chest_height, stress.layout_spacing);
    stress.monsters_placed = true;
    return true;
}

void DungeonStressCamera(mgCCamera &camera) {
    if (!stress.enabled || !stress.monsters_placed || !PortDungeonFieldControl()) {
        return;
    }
    if (!StressSceneValid() || MainChara__2 == nullptr || (++stress.setup_ticks > 900 && !stress.measuring)) {
        StressInvalid("fixed overview setup did not establish twenty visible bodies");
    }
    const auto refresh_start = PerfClock::now();
    if (!StressRefreshCollision()) {
        StressInvalid("current collision collection is empty or its completeness bounds saturated");
    }
    if (stress.measuring) {
        const double refresh_ms = std::chrono::duration<double, std::milli>(PerfClock::now() - refresh_start).count();
        stress.measured_map_refresh_ms += refresh_ms;
        stress.maximum_map_refresh_ms = std::max(stress.maximum_map_refresh_ms, refresh_ms);
    }
    if (!stress.player_placed) {
        MainChara__2->SetPosition(stress.player_position.data());
        MainChara__2->SetRotation(0.0f, 0.0f, 0.0f);
        MainChara__2->ResetAccele();
        MainChara__2->ResetDAPosition();
        MainChara__2->Step();
        MainChara__2->StepDA(10);
        mgPortCutInterpolation();
        stress.player_placed = true;
    }
    if (!stress.setup_logged && stress.stable_view_ticks == 0 && stress.tick - stress.camera_started_tick >= 120 && stress.setup_ticks % 15 == 0) {
        bool selected = false;
        for (int candidate = stress.camera_choice + 1; candidate < 20; ++candidate) {
            if (StressChooseCamera(candidate)) {
                selected = true;
                mgPortCutCameraInterpolation();
                break;
            }
        }
        if (!selected) {
            StressInvalid("legal fixed overviews did not show all twenty real bodies");
        }
    }
    camera.SetPos(stress.camera_pos.data());
    camera.SetRef(stress.camera_ref.data());
    ++stress.tick;
    stress.submitted.fill(false);
    stress.witnessed.fill(false);
    stress.has_body_bounds.fill(false);
}

} // namespace dc2::debug

std::optional<bool> dc2::debug::CombatDungeonFloor(std::string_view event_table, int dungeon, int floor) {
    constexpr std::size_t expected_boss_rows = 27;
    std::vector<int>      events;
    bool                  malformed = false;
    bool                  combat = false;
    VisitEventRows(event_table, [&](const auto &columns) {
        if (columns.size() < 9) {
            return false;
        }
        auto kind = columns[8];
        if (kind.ends_with('\r')) {
            kind.remove_suffix(1);
        }
        if (kind != "B") {
            return false;
        }
        int event = 0;
        if (!Number(columns[3], event, kNoLimit) || std::ranges::find(events, event) != events.end()) {
            malformed = true;
            return false;
        }
        events.push_back(event);
        if (!CombatBossEvent(event)) {
            malformed = malformed || (event != 22010 && event != 22020 && event != 23010);
            return false;
        }
        int event_dungeon = 0;
        int event_floor = 0;
        if (!Number(columns[1], event_dungeon, SAVE_DUNGEON_NUM) || event_dungeon == 0 ||
            !Number(columns[2], event_floor, 99)) {
            malformed = true;
            return false;
        }
        combat = combat || (event_dungeon - 1 == dungeon && event_floor == floor);
        return false;
    });
    if (malformed || events.size() != expected_boss_rows) {
        return std::nullopt;
    }
    return combat;
}

bool GameParseJump(std::string_view text, GameJump &jump) {
    GameJump parsed;
    auto     colon = text.find(':');
    auto     name = text.substr(0, colon);
    auto     arg = colon == std::string_view::npos ? std::string_view{} : text.substr(colon + 1);
    if (name == "town" || name == "edit") {
        parsed.mode = JumpMode::Town;
        if (colon != std::string_view::npos && !Number(arg, parsed.map, 188)) {
            return false;
        }
    } else if (name == "georama") {
        // The developer menu's "diorama map" row: the Georama towns are maps 0 to 4.
        parsed.mode = JumpMode::Georama;
        parsed.map = 0;
        if (colon != std::string_view::npos && !Number(arg, parsed.map, 4)) {
            return false;
        }
    } else if (name == "dungeon") {
        parsed.mode = JumpMode::Dungeon;
        parsed.map = 0;
        auto floor = arg.find(':');
        if (colon != std::string_view::npos && !Number(arg.substr(0, floor), parsed.map, 6)) {
            return false;
        }
        if (floor != std::string_view::npos && (!Number(arg.substr(floor + 1), parsed.floor, 99) || parsed.floor == 0)) {
            return false;
        }
        CSaveDataDungeon floors{};
        if (!floors.GetFloorInfoPtr(parsed.map, parsed.floor)) {
            return false;
        }
    } else if (name == "event") {
        parsed.mode = JumpMode::Event;
        if (colon == std::string_view::npos || !Number(arg, parsed.event, kNoLimit) || parsed.event == 0) {
            return false;
        }
    } else {
        if (colon != std::string_view::npos) {
            return false;
        }
        if (name == "title") {
            parsed.mode = JumpMode::Title;
        } else if (name == "opening") {
            parsed.mode = JumpMode::Opening;
        } else if (name == "menu") {
            parsed.mode = JumpMode::Menu;
        } else {
            return false;
        }
    }
    jump = parsed;
    return true;
}

bool GameParseGive(std::string_view text, std::vector<int> &items) {
    std::vector<int> parsed;
    for (;;) {
        auto comma = text.find(',');
        int  item = 0;
        if (!Number(text.substr(0, comma), item, 32767) || item == 0) {
            return false;
        }
        parsed.push_back(item);
        if (comma == std::string_view::npos) {
            break;
        }
        text.remove_prefix(comma + 1);
    }
    items = std::move(parsed);
    return true;
}

bool GameSetJump(std::string_view text) {
    GameJump parsed;
    if (!GameParseJump(text, parsed)) {
        return false;
    }
    target = parsed;
    return true;
}

bool GameSetGive(std::string_view text) { return GameParseGive(text, gifts); }

bool GameHasJump() { return target.has_value(); }

bool GameDebugEnabled() { return ConfigGet().debug_mode || GameHasJump(); }

void GameSetFastLoad(bool fast) { fast_load = fast; }

bool GameFastLoad() { return fast_load; }

void GameSetSkipEvents(bool skip) { skip_events = skip; }

bool GameSkipEvents() { return skip_events; }

void GameSetInvincible(bool value) { invincible = value; }

bool GameInvincible() { return invincible; }

void GameSetSeed(std::optional<std::uint32_t> value) { seed = value; }

std::optional<std::uint32_t> GameSeed() { return seed; }

void GameSetPerfSeconds(int seconds) { perf.seconds = seconds; }

bool GamePerfEnabled() { return perf.seconds > 0; }

void GamePerfTickTimes(double update_ms, double busy_ms) {
#ifndef CT_ENABLE_TRACY
    if (gfx::profile::sampling) {
        const int count = std::min(gfx::profile::site_count.load(), gfx::profile::kMaxSites);
        for (int index = 0; index < count; ++index) {
            const std::uint64_t now_ns = gfx::profile::sites[static_cast<std::size_t>(index)].game_ns.load();
            zone_max[static_cast<std::size_t>(index)] = std::max(zone_max[static_cast<std::size_t>(index)], now_ns - zone_last[static_cast<std::size_t>(index)]);
            zone_last[static_cast<std::size_t>(index)] = now_ns;
        }
    }
#endif
    if (perf.window_start) {
        PerfAdd(perf.window, update_ms, busy_ms);
        PerfAdd(perf.total, update_ms, busy_ms);
    }
}

void GamePerfStep(int mode) {
    if (perf.seconds <= 0) {
        return;
    }
#ifndef CT_ENABLE_TRACY
    gfx::profile::game_thread = true;
#endif
    const auto now = PerfClock::now();
    const auto native_now_ns = gfx::PresentationHistoryClockNs();
    if (mode == LOOP_DUNGEON) {
        if (StressFitSetup()) {
            return;
        }
        StressObserveSetup();
    }
    if (!perf.ready) {
        if (perf_target && mode == perf_target->mode && (!perf.last_wait_log || now - *perf.last_wait_log >= std::chrono::seconds{5})) {
            PerfLogScene("waiting", mode);
            perf.last_wait_log = now;
        }
        if (PerfReady(mode)) {
            if (stress.enabled) {
                if (const char *directory = std::getenv("DC2_PERF_STRESS_SETUP_CAPTURE"); directory != nullptr && *directory != '\0') {
                    gfx::RenderLease          lease;
                    std::vector<std::uint8_t> pixels;
                    std::uint32_t             width = 0;
                    std::uint32_t             height = 0;
                    const auto                path = PathsFromUtf8(directory) / "ready.png";
                    if (!gfx::ReadbackFrame(pixels, width, height) || !gfx::WritePng(path, pixels.data(), width, height)) {
                        StressInvalid("initial fixed-view capture failed");
                    }
                }
            }
            perf.ready = now;
            if (stress.enabled) {
                perf.ready = PerfClock::now();
            }
            dc2::presentation::PrepareSchedulingTrace();
            PerfLogScene("ready", mode);
            CT_LOG_INFO(Main, "perf ready: loop {}", mode);
        }
        return;
    }
    if (!perf.window_start) {
        if (!PerfReady(mode)) {
            perf.ready.reset();
            return;
        }
        if (now - *perf.ready >= kPerfWarmup) {
            perf.window_start = perf.started = now;
            if (stress.enabled) {
                stress.measuring = true;
                stress.measured_tick = stress.tick;
            }
            perf.window_present = perf.start_present = PresentGetStats();
            gfx::BeginAttachmentAlphaTrace(static_cast<uint64_t>(std::chrono::duration_cast<std::chrono::nanoseconds>(now.time_since_epoch()).count()));
            gfx::BeginPresentationHistory(native_now_ns);
            dc2::presentation::BeginSchedulingTrace(now, native_now_ns);
            PerfLogMarker("start");
#ifndef CT_ENABLE_TRACY
            const char *zones = std::getenv("DC2_PERF_ZONES");
            gfx::profile::sampling = zones != nullptr && std::string_view(zones) == "1";
#endif
            PerfLogScene("start", mode);
            CT_LOG_INFO(Main, "perf start: loop {} seconds {} thread {}", mode, perf.seconds,
                        std::hash<std::thread::id>{}(std::this_thread::get_id()));
            if (mode == LOOP_DUNGEON && ActiveMonster != nullptr && TreasureBoxMan != nullptr) {
                int monsters = 0;
                for (int i = 0; i < MONSTER_ACTIVE_MAX; i++) {
                    CActiveMonster *monster = ActiveMonster->GetActiveMonster(i);
                    monsters += monster != nullptr && monster->IsDraw(1) != 0 ? 1 : 0;
                }
                const auto chests = std::ranges::count_if(TreasureBoxMan->box, [](const CTreasureBox &box) { return box.state != TREASURE_BOX_STATE_NONE; });
                CT_LOG_INFO(Main, "perf floor: monsters {} chests {}", monsters, chests);
            }
        }
        return;
    }
    if (!PerfReady(mode)) {
        PerfLogScene("invalid", mode);
        if (stress.enabled) {
            StressInvalid("requested fixture lost control or its resolved scene");
        }
        CT_LOG_ERROR(Main, "perf invalid: requested scene lost control or required actors during measurement");
        LogFlush();
        std::exit(2);
    }
    const double elapsed = std::chrono::duration<double>(now - perf.started).count();
    const bool   complete = elapsed >= perf.seconds;
    if (complete) {
        gfx::EndAttachmentAlphaTrace(static_cast<uint64_t>(std::chrono::duration_cast<std::chrono::nanoseconds>(now.time_since_epoch()).count()));
        gfx::EndPresentationHistory(native_now_ns);
        dc2::presentation::EndSchedulingTrace(now, native_now_ns);
    }
    const double seconds = std::chrono::duration<double>(now - *perf.window_start).count();
    if (seconds < 1.0 && !complete) {
        return;
    }
    PerfLog("window", mode, seconds, perf.window, perf.window_present);
    perf.window = {};
    perf.window_present = PresentGetStats();
    perf.window_start = now;
    ++perf.windows;
    if (!complete) {
        return;
    }
    const char *capture_hold_setting = std::getenv("DC2_PERF_CAPTURE_HOLD_MS");
    int         capture_hold_ms = 0;
    if (capture_hold_setting != nullptr && !Number(capture_hold_setting, capture_hold_ms, 30000)) {
        capture_hold_ms = 0;
    }
    {
        // Native history drains already queued images while the final scene remains frozen.
        gfx::RenderLease lease;
        gfx::SetRenderIdleHook(nullptr, nullptr);
        PerfLogMarker("end");
        gfx::LogPresentationHistory();
        dc2::presentation::LogSchedulingTrace();
        StressLogSummary();
        if (stress.enabled) {
            if (const char *screenshot = std::getenv("DC2_PERF_STRESS_SCREENSHOT"); screenshot != nullptr && *screenshot != '\0') {
                std::vector<std::uint8_t> pixels;
                std::uint32_t             width = 0;
                std::uint32_t             height = 0;
                if (!gfx::ReadbackFrame(pixels, width, height) || !gfx::WritePng(PathsFromUtf8(screenshot), pixels.data(), width, height)) {
                    StressInvalid("post-measurement preview screenshot failed");
                }
            }
        }
        PerfLog("total", mode, elapsed, perf.total, perf.start_present);
        PerfLogZones(perf.total.ticks);
        LogFlush();
        if (capture_hold_ms > 0) {
            CT_LOG_INFO(Main, "perf capture hold: {} ms; presentation frozen outside measurement", capture_hold_ms);
            LogFlush();
            std::this_thread::sleep_for(std::chrono::milliseconds{capture_hold_ms});
        }
    }
    std::exit(kExitOk);
}

void GameDebugFrame(int mode) {
    if (mode != LOOP_DUNGEON) {
        return;
    }
    if (invincible && MainChara__2 != nullptr) {
        // Keeps the hit check's invulnerability window open, so no hit lands or knocks the character back.
        MainChara__2->muteki_time = std::max(MainChara__2->muteki_time, 2);
    }
    if (skip_events && DngStatus.mode == DNG_STATUS_EVENT && EdEventInfo.skip_state == EVENT_SKIP_ENABLED) {
        SkipEventStart();
    }
}

void GamePrepareJump(int &mode, INIT_LOOP_ARG &arg) {
    dc2::debug::ObserveHalloweenPreambleEvent(-1, nullptr, nullptr, 0);
    for (int item : gifts) {
        RequireKnownItem(item);
    }
    const char *stress_option = std::getenv("DC2_PERF_DUNGEON_STRESS");
    const bool  stress_requested = stress_option != nullptr && std::string_view(stress_option) == "1";
    if (stress_option != nullptr && *stress_option != '\0' && std::string_view(stress_option) != "0" && !stress_requested) {
        StressInvalid("DC2_PERF_DUNGEON_STRESS accepts only zero or one");
    }
    if (stress_requested && (!target || target->mode != JumpMode::Dungeon || target->map != 0 || target->floor != 3 ||
                             seed != std::optional<std::uint32_t>{1} || perf.seconds != 8 || !skip_events || !invincible)) {
        StressInvalid("fixture requires dungeon:0:3 seed1 perf8 skip-events and invincible");
    }
    stress = DungeonStress{};
    stress.chest_slots.fill(-1);
    stress.enabled = stress_requested;
    if (stress_requested) {
        stress.generation = ++stress_generation;
    }
    if (!target) {
        return;
    }
    InitSaveData();
    auto jump = *target;
    arg = INIT_LOOP_ARG{};
    DebugFlag = 1;
    PortGameBootInit = 1;
    char town_config[] = "dbg/pb.cfg.json";
    char dungeon_config[] = "dbg/cap1.cfg.json";
    switch (jump.mode) {
        case JumpMode::Menu:
            mode = LOOP_MENU;
            break;
        case JumpMode::Title:
            mode = LOOP_TITLE;
            break;
        case JumpMode::Town:
            if (GetMapName(jump.map, nullptr) == nullptr || GetMapType(jump.map) < 0) {
                BadTarget();
            }
            LoadGameConfig(town_config);
            mode = LOOP_EDIT;
            arg.map_no = jump.map;
            arg.event_no = 100;
            break;
        case JumpMode::Georama: {
            char georama_config[] = "dbg/geo.cfg.json";
            LoadGameConfig(georama_config);
            mode = LOOP_EDIT;
            arg.map_no = jump.map;
            break;
        }
        case JumpMode::Dungeon:
            LoadGameConfig(dungeon_config);
            if (stress.enabled) {
                // The native floor-three loader requires this prerequisite in its disposable debug save.
                GetSaveData()->SetBitFlag(102, 1);
                if (!GetSaveData()->GetBitFlag(102)) {
                    StressInvalid("fresh floor-three prerequisite was not applied");
                }
                CT_LOG_INFO(Main, "perf stress prerequisite: fresh_debug_save=1 flag=102 value=1 persistent_write=0");
            }
            mode = LOOP_DUNGEON;
            arg.map_no = jump.map;
            arg.floor_no = jump.floor;
            if (skip_events) {
                arg.event_no = kDungeonFloorLoadEvent;
            }
            break;
        case JumpMode::Opening: {
            DebugGetItem(&GetSaveData()->user_data, 1);
            auto &user = GetSaveData()->user_data;
            user.LeavePartyMember(USER_CHARA_MAX);
            user.JoinPartyMember(USER_CHARA_MONICA);
            user.EnableCharaChange(USER_CHARA_MONICA);
            user.SetActiveChrNo(USER_CHARA_MONICA);
            mode = LOOP_DUNGEON;
            arg.map_no = 0;
            arg.floor_no = 20;
            arg.event_no = 1010;
            break;
        }
        case JumpMode::Event:
            DebugGetItem(&GetSaveData()->user_data, 0);
            if (!ResolveEvent(jump.event, mode, arg)) {
                BadTarget();
            }
            break;
    }
    bool combat_floor = false;
    if (GamePerfEnabled() && jump.mode == JumpMode::Dungeon) {
        const auto table = ReadEventTable();
        const auto classification = table ? dc2::debug::CombatDungeonFloor(*table, arg.map_no, arg.floor_no) : std::nullopt;
        if (!classification) {
            CT_LOG_ERROR(Main, "perf invalid: cannot classify dungeon floor from the complete boss-event table");
            LogFlush();
            std::exit(2);
        }
        combat_floor = *classification;
    }
    perf_target = PerfTarget{.mode = mode, .argument = arg, .combat_floor = combat_floor};
}

void GameGiveOnArrival(int mode) {
    if (mode != LOOP_EDIT && mode != LOOP_DUNGEON) {
        return;
    }
    auto &user = GetSaveData()->user_data;
    for (int item : gifts) {
        RequireKnownItem(item);
        if (user.SearchAllHaveItem(item) == nullptr) {
            user.GetItem(item, 1);
        }
    }
}

bool GameDeveloperMenuRequested(int mode) {
    static bool    held_before = false;
    constexpr auto chord = kInputStart | kInputSelect;
    const auto     buttons = InputGetPad(0).buttons;
    bool           held = (buttons & chord) == chord;
    // The debug_menu binding (F1 by default) stands in for the chord on a keyboard; its press is
    // consumed whether or not debug controls are enabled, so it cannot fire later.
    bool key = false;
    while (InputHostPressed(InputHostAction::DebugMenu)) {
        key = true;
    }
    bool pressed = (held && !held_before) || key;
    // A partial release must not re-arm a chord carried across a mode change.
    if ((buttons & chord) == 0) {
        held_before = false;
    } else if (held) {
        held_before = true;
    }
    return pressed && GameDebugEnabled() && mode != LOOP_MENU && !options::Capturing();
}

bool GameDebugPauseRequested(CGamePad &pad) {
    constexpr int modifier = PAD_L2 | PAD_SELECT;
    const bool    chord = GameDebugEnabled() && !pad.key_lock &&
                          (pad.pad[0].button & modifier) == modifier &&
                          !(pad.previous_pad[0].button & PAD_SELECT);
    return chord || pad.Down2(PAD_SELECT);
}

bool GameDebugPauseResumeRequested(CGamePad &pad) {
    constexpr int modifier = PAD_L2 | PAD_SELECT;
    const bool    single_debug = GameDebugEnabled() && (pad.pad[0].button & modifier) == modifier;
    const int     pad1_pressed = pad.pad[0].button & ~pad.previous_pad[0].button;
    return (!single_debug && !pad.key_lock && (pad1_pressed & PAD_START)) ||
           GameDebugPauseRequested(pad);
}
