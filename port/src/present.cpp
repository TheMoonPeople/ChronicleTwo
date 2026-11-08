#include "present.hpp"

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <functional>
#include <mutex>
#include <string>
#include <thread>

#include "camera_fixed.hpp"
#include "exitcodes.hpp"
#include "gfx/displaylist.hpp"
#include "gfx/gfx.hpp"
#include "log/log.hpp"
#include "menu_mouse.hpp"
#include "platform/clock.hpp"
#include "platform/frame_timing.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "platform/overlay.hpp"
#include "platform/window.hpp"
#include "present_timing.hpp"
#include "profile.hpp"
#include "render/renderer.hpp"

namespace {

using Clock = std::chrono::steady_clock;

// Caps unfinished application frames before scheduling another display.
constexpr std::uint32_t kPresentGpuFrames = 2;
// How long the render thread yields while the GPU catches up.
constexpr auto kPresentGpuPoll = std::chrono::microseconds(500);

struct FpsOverlay {
    bool                on = false;
    OverlayRate         frames;
    OverlayRate         ticks;
    gfx::DisplayListRef list;
};

PresentSettings   settings;
PresentStats      stats;
bool              tick_shown = true;
PresentPacer      pacer;
Clock::time_point last_log;
FpsOverlay        overlay;
std::int64_t      counted_tick = 0;
int               wait_start = 0;
int               wait_frames = 0;

/**
 * Enables intermediate displays for game frames below the requested presentation cadence.
 */
bool InterpolateFrame([[maybe_unused]] int frames) {
#ifdef __SWITCH__
    return settings.interpolation && frames > 1;
#else
    return settings.interpolation;
#endif
}

enum class EndpointPolicy {
    Replay,
    CanonicalAuthored
};
std::atomic<std::uint64_t> settings_epoch{0};

// The tick the render thread presents, written by the game thread under publish_mutex.
struct Published {
    gfx::DisplayListRef list;     // The tick's canonical list.
    gfx::DisplayListRef previous; // The tick before it.
    gfx::DisplayListRef overlay;  // The host overlay recorded for this tick, or null.
    PresentSettings     settings;
    gfx::InterpKey      suppressed_2d_key = 0;
    // The game frame ending with this tick: it began at frame_start, lasts frame_frames ticks at tick_rate.
    Clock::time_point                       frame_start;
    Clock::duration                         frame_length{};
    int                                     frame_frames = 0;
    double                                  tick_rate = 0.0;
    float                                   look_yaw = 0.0f;
    float                                   look_pitch = 0.0f;
    bool                                    mouse_fixed = false;
    bool                                    mouse_pointer = false;
    std::uint64_t                           serial = 0;
    std::uint64_t                           epoch = 0;
    EndpointPolicy                          endpoint_policy = EndpointPolicy::Replay;
    bool                                    canonical_endpoint_source = false;
    std::optional<gfx::CanonicalImageToken> canonical_image;
};

/**
 * What the game thread prepares for a tick's publication.
 */
struct TickPublication {
    gfx::DisplayListRef list;                     /**< The tick's canonical list. */
    gfx::DisplayListRef previous;                 /**< The tick before it. */
    gfx::DisplayListRef overlay;                  /**< The host overlay, or null. */
    gfx::InterpKey      suppressed_key = 0;       /**< 2D key the menu pointer replaces. */
    std::uint64_t       epoch = 0;                /**< Settings epoch. */
    PresentSettings     settings;                 /**< Settings for the tick. */
    bool                interpolation = false;    /**< Whether display frames interpolate. */
    bool                endpoint_enabled = false; /**< Whether authored endpoints are on. */
    bool                endpoint_allowed = false; /**< Whether the tick's image may be an endpoint. */
    Clock::time_point   frame_start;              /**< Start of the game frame ending with the tick. */
    Clock::duration     frame_length{};           /**< Its length. */
    int                 frames = 0;               /**< Its length in ticks. */
    double              tick_rate = 0.0;          /**< Ticks a second. */
    float               yaw = 0.0f;               /**< Fixed-look yaw. */
    float               pitch = 0.0f;             /**< Fixed-look pitch. */
    bool                fixed = false;            /**< Whether the fixed look is active. */
    bool                pointer = false;          /**< Whether the menu pointer shows. */
};

std::mutex                 publish_mutex;
Published                  published;
std::atomic<double>        async_fps{0.0};
std::atomic<std::uint64_t> async_presented{0};
std::atomic<std::uint64_t> async_display_frames{0};
std::atomic<std::uint64_t> async_canonical_presents{0};
std::atomic<std::uint64_t> async_unfinished_pairs{0};
std::atomic<std::uint64_t> async_replay_ticks{0};
std::atomic<std::uint64_t> async_held_frames{0};

// Device ownership serializes the idle hook and the pre-canonical endpoint retirement.
PresentPacer                    render_pacer;
OverlayRate                     render_frames;
std::uint64_t                   render_serial = 0;
bool                            render_tick_shown = false;
dc2::presentation::EndpointPair render_pair;

/**
 * Counts bounded deferred-commit selection and fallback reasons without per-frame output.
 */
struct DeferredCanonicalMetrics {
    std::atomic<std::uint64_t> attempts{0};     /**< Queued canonical jobs requesting the experiment. */
    std::atomic<std::uint64_t> selected{0};     /**< Jobs passing the source and presentation guards. */
    std::atomic<std::uint64_t> rendered{0};     /**< Canonical images replayed through the bounded transaction. */
    std::atomic<std::uint64_t> retired{0};      /**< Prior endpoints successfully presented by its callback. */
    std::atomic<std::uint64_t> mode{0};         /**< Jobs without actual native feedback pacing. */
    std::atomic<std::uint64_t> pair{0};         /**< Sources without an already-shown pending endpoint. */
    std::atomic<std::uint64_t> policy{0};       /**< Sources outside the supported authored presentation policy. */
    std::atomic<std::uint64_t> epoch{0};        /**< Sources invalidated by settings changes. */
    std::atomic<std::uint64_t> gpu{0};          /**< Sources exceeding the existing pending-presentation budget. */
    std::atomic<std::uint64_t> image{0};        /**< Sources without the exact current canonical identity. */
    std::atomic<std::uint64_t> preservation{0}; /**< Transactions rejected before replay by shared preservation guards. */
};

/** Lifetime experiment counters; no measurement-time allocation is required. */
DeferredCanonicalMetrics deferred_canonical_metrics;

/**
 * Counts fixed-storage lifetime observations of the opt-in idle endpoint readiness check.
 */
struct EndpointPreflightMetrics {
    std::atomic<std::uint64_t> probes{0};  /**< Eligible idle endpoints checked through native feedback. */
    std::atomic<std::uint64_t> pending{0}; /**< Idle polls yielding without attempting a presentation. */
};

/** Lifetime readiness counts shared with the final diagnostic reader. */
EndpointPreflightMetrics endpoint_preflight_metrics;

/**
 * Identifies the publication or scheduling site that produced an observation.
 */
enum class ScheduleEvent {
    Publish,
    Idle,
    Retire,
    Outcome
};
/**
 * Distinguishes original guard outcomes from evaluated scheduling decisions.
 */
enum class ScheduleReason {
    Published,
    NoList,
    GpuBacklog,
    EpochMismatch,
    ReplayPolicy,
    MouseOverride,
    ImageMismatch,
    Selected,
    ExpiredUnshown,
    Presented,
    Failed,
    Replaced,
    FeedbackPending
};

/**
 * Associates a native clock sample with its enclosing steady-clock reads.
 */
struct ScheduleClock {
    std::int64_t  steady_before = 0; /**< Steady nanoseconds before the native read. */
    std::uint64_t native = 0;        /**< Native presentation-clock nanoseconds. */
    std::int64_t  steady_after = 0;  /**< Steady nanoseconds after the native read. */
};

/**
 * Retains one publication or changed scheduling decision without retaining render resources.
 */
struct ScheduleRow {
    ScheduleEvent                                          event{};                 /**< Scheduling site. */
    ScheduleReason                                         reason{};                /**< Selected action or guard outcome. */
    ScheduleClock                                          clock;                   /**< Clock mapping at first observation. */
    ScheduleClock                                          last_clock;              /**< Clock mapping at last repeated observation. */
    std::uint64_t                                          serial = 0;              /**< Publication serial. */
    std::uint64_t                                          pair_serial = 0;         /**< Publication currently owned by the pair scheduler. */
    std::uint64_t                                          instance = 0;            /**< Canonical list renderer instance. */
    std::uint64_t                                          list = 0;                /**< Canonical list serial. */
    std::uint64_t                                          previous = 0;            /**< Previous list serial. */
    std::uint64_t                                          epoch = 0;               /**< Publication settings epoch. */
    EndpointPolicy                                         policy{};                /**< Publication image policy. */
    double                                                 max_fps = 0;             /**< Configured presentation cap. */
    std::int64_t                                           frame_start = 0;         /**< Source frame start in steady nanoseconds. */
    std::int64_t                                           frame_end = 0;           /**< Reconstructed source-frame deadline in steady nanoseconds. */
    std::int64_t                                           decision_now = 0;        /**< Clock used by the scheduling decision. */
    std::int64_t                                           deadline = 0;            /**< Deadline returned by that decision. */
    std::optional<dc2::presentation::EndpointPair::Action> action;                  /**< Chosen pair action, if evaluated. */
    std::optional<bool>                                    gate;                    /**< Actual native gate state, if sampled. */
    std::optional<bool>                                    pending;                 /**< Whether a shown midpoint still needs its endpoint. */
    std::optional<bool>                                    gpu;                     /**< Original GPU-budget guard result, if evaluated. */
    std::optional<bool>                                    current;                 /**< Original canonical-image guard result, if evaluated. */
    std::optional<bool>                                    epoch_match;             /**< Original settings guard result, if evaluated. */
    std::optional<bool>                                    shown;                   /**< Actual presentation result, if evaluated. */
    bool                                                   image = false;           /**< Whether publication retained an image token. */
    bool                                                   eligible_source = false; /**< Whether publication can supply authored images. */
    std::uint64_t                                          repeats = 1;             /**< Identical observations represented by this row. */
};

/**
 * Owns optional bounded scheduling evidence for warmup and its measured interval.
 */
struct SchedulingTrace {
    std::vector<ScheduleRow>                  rows;             /**< Preallocated scalar observations. */
    std::array<std::optional<std::size_t>, 2> last;             /**< Last idle and retirement decision rows. */
    ScheduleClock                             collection;       /**< Start of warmup collection. */
    std::int64_t                              begin_steady = 0; /**< Measured interval start. */
    std::int64_t                              end_steady = 0;   /**< Measured interval end. */
    std::uint64_t                             begin_native = 0; /**< Native measured interval start. */
    std::uint64_t                             end_native = 0;   /**< Native measured interval end. */
    std::uint64_t                             overflow = 0;     /**< Observations omitted at the capacity limit. */
    std::uint64_t                             clock_errors = 0; /**< Invalid paired clock samples. */
    bool                                      enabled = false;  /**< Whether this capture was requested. */
};

/** Maximum retained scalar scheduling observations. */
constexpr std::size_t kScheduleTraceCapacity = 4096;
/** Scheduling evidence collected outside and inside the measured boundaries. */
SchedulingTrace scheduling_trace;
/** Serializes evidence updates without acquiring renderer or publication locks. */
std::mutex scheduling_trace_mutex;
/** Avoids evidence work when scheduling capture is disabled. */
std::atomic<bool> scheduling_trace_active{};

/**
 * Converts a steady-clock boundary into its scalar diagnostic representation.
 */
std::int64_t ScheduleNs(Clock::time_point now) {
    return std::chrono::duration_cast<std::chrono::nanoseconds>(now.time_since_epoch()).count();
}

/**
 * Samples both clock domains without assuming they share an epoch.
 */
ScheduleClock ScheduleClockNow() {
    const auto before = ScheduleNs(Clock::now());
    const auto native = gfx::PresentationHistoryClockNs();
    return {.steady_before = before, .native = native, .steady_after = ScheduleNs(Clock::now())};
}

/**
 * Copies only publication identities and scheduling inputs into optional evidence.
 */
std::optional<ScheduleRow> ScheduleObservation(const Published &frame, ScheduleEvent event, ScheduleReason reason) {
    if (!scheduling_trace_active.load(std::memory_order_acquire)) {
        return std::nullopt;
    }
    ScheduleRow row;
    row.event = event;
    row.reason = reason;
    row.clock = row.last_clock = ScheduleClockNow();
    row.serial = frame.serial;
    row.pair_serial = render_serial;
    row.instance = frame.list ? frame.list->instance : 0;
    row.list = frame.list ? frame.list->serial : 0;
    row.previous = frame.previous ? frame.previous->serial : 0;
    row.epoch = frame.epoch;
    row.policy = frame.endpoint_policy;
    row.max_fps = frame.settings.max_fps;
    row.frame_start = ScheduleNs(frame.frame_start);
    row.frame_end = ScheduleNs(frame.frame_start + frame.frame_length);
    row.image = frame.canonical_image.has_value();
    row.eligible_source = frame.canonical_endpoint_source;
    if (event != ScheduleEvent::Publish) {
        row.pending = render_pair.PendingEndpoint();
    }
    return row;
}

/**
 * Coalesces repeated polling decisions in preallocated storage without taking renderer locks.
 */
void AppendSchedule(std::optional<ScheduleRow> observation) {
    if (!observation) {
        return;
    }
    auto            &row = *observation;
    std::scoped_lock lock{scheduling_trace_mutex};
    if (!scheduling_trace_active.load(std::memory_order_relaxed) || row.clock.steady_before < scheduling_trace.collection.steady_before) {
        return;
    }
    if (row.clock.native == 0 || row.clock.steady_after < row.clock.steady_before) {
        ++scheduling_trace.clock_errors;
    }
    const auto site = row.event == ScheduleEvent::Idle ? 0 : 1;
    if (row.event == ScheduleEvent::Idle || row.event == ScheduleEvent::Retire) {
        if (const auto index = scheduling_trace.last[site]) {
            auto &last = scheduling_trace.rows[*index];
            if (last.serial == row.serial && last.event == row.event && last.reason == row.reason &&
                last.action == row.action && last.pending == row.pending && last.gate == row.gate &&
                last.gpu == row.gpu && last.current == row.current && last.epoch_match == row.epoch_match) {
                ++last.repeats;
                last.last_clock = row.clock;
                return;
            }
        }
    }
    if (scheduling_trace.rows.size() == kScheduleTraceCapacity) {
        ++scheduling_trace.overflow;
        return;
    }
    if (row.event == ScheduleEvent::Idle || row.event == ScheduleEvent::Retire) {
        scheduling_trace.last[site] = scheduling_trace.rows.size();
    }
    scheduling_trace.rows.push_back(row);
}

/**
 * Describes one evaluated pair decision without re-evaluating its pacer or image guards.
 */
void TracePairDecision(const Published &frame, ScheduleEvent event, Clock::time_point now,
                       const dc2::presentation::EndpointPair::Decision &decision, bool gate) {
    const bool expired = decision.action == dc2::presentation::EndpointPair::Action::Endpoint && !render_pair.PendingEndpoint();
    auto       row = ScheduleObservation(frame, event, expired ? ScheduleReason::ExpiredUnshown : ScheduleReason::Selected);
    if (row) {
        row->action = decision.action;
        row->decision_now = ScheduleNs(now);
        row->deadline = ScheduleNs(decision.deadline);
        row->gate = gate;
        row->gpu = row->current = row->epoch_match = true;
    }
    AppendSchedule(row);
}

/**
 * Records only guards that the scheduling path actually evaluated.
 */
void TraceScheduleGuard(const Published &frame, ScheduleEvent event, ScheduleReason reason,
                        std::optional<bool> gpu = {}, std::optional<bool> current = {},
                        std::optional<bool> epoch_match = {}, std::optional<bool> shown = {},
                        std::optional<dc2::presentation::EndpointPair::Action> action = {}, std::optional<bool> gate = {}) {
    auto row = ScheduleObservation(frame, event, reason);
    if (row) {
        row->gpu = gpu;
        row->current = current;
        row->epoch_match = epoch_match;
        row->shown = shown;
        row->action = action;
        row->gate = gate;
    }
    AppendSchedule(row);
}

bool PresentAsync() {
    return gfx::ActiveRenderThreadMode() == gfx::RenderThreadMode::Async;
}

void PollFpsToggle() {
    if (InputHostPressed(InputHostAction::FpsToggle)) {
        overlay.on = !overlay.on;
    }
}

// Records the host overlay of a presented frame: the FPS counter when asked, then the menu pointer.
gfx::DisplayListRef RecordHostOverlay(bool fps) {
    gfx::BeginRecording(gfx::RecordingKind::Overlay);
    if (!gfx::Recording()) {
        return nullptr;
    }
    if (fps) {
        const int pixel = OverlayPixelSize(gfx::GetPresentationMapping());
        OverlayDrawText(PresentFpsText(), gfx::GetPresentationMapping(true), pixel,
                        pixel * kOverlayPadding, pixel * kOverlayPadding);
    }
    MenuMouseDraw();
    return gfx::EndRecording();
}

const gfx::DisplayList *DisplayOverlayList() {
    if (PresentMouseActive() && !ClockUnbounded()) {
        if (!WindowPollEvents()) {
            std::exit(kExitOk);
        }
        InputPoll();
    }
    MouseSetPointerCursor(MenuMousePointerVisible());
    if (!overlay.on && !MenuMousePointerVisible()) {
        return nullptr;
    }
    overlay.list = RecordHostOverlay(overlay.on);
    return overlay.list.get();
}

/**
 * Reports presentation rates and opt-in renderer timing samples once per second.
 */
void LogPresentRates(Clock::time_point now) {
    if ((settings.log_fps || gfx::FrameTimingEnabled()) && now - last_log >= std::chrono::seconds(1)) {
        const double seconds = last_log == Clock::time_point{} ? 1.0 : std::chrono::duration<double>(now - last_log).count();
        last_log = now;
        if (settings.log_fps) {
            CT_LOG_INFO(Gfx, "present: {}", PresentFpsText());
        }
        if (gfx::FrameTimingEnabled()) {
            gfx::LogFrameTimings(seconds);
        }
    }
}

void NotePresented() {
    ++stats.presented;
    CT_PROFILE_FRAME("Display");
    const Clock::time_point now = Clock::now();
    overlay.frames.Count(now);
    LogPresentRates(now);
}

double DisplaySeconds(bool intermediate = false) {
    if (ClockUnbounded()) {
        const int displays = intermediate ? std::max(1, settings.display_per_tick) : 1;
        return std::max(1, wait_frames) / ClockTickRate() / displays;
    }
    static Clock::time_point before = Clock::now();
    const auto               now = Clock::now();
    const double             seconds = std::chrono::duration<double>(now - before).count();
    before = now;
    return seconds;
}

bool DisplayFrame(float alpha, bool present) {
    CT_PROFILE_ZONE("Display frame render");
    const gfx::DisplayList *list = mgPortLastList();

    if (list == nullptr) {
        return false;
    }

    gfx::RenderOptions options;
    options.previous = settings.interpolation ? mgPortPreviousList() : nullptr;
    options.present = present;
    options.overlay = present ? DisplayOverlayList() : nullptr;
    options.suppressed_2d_key = present ? MenuMouseReplacedHandKey() : 0;
    const bool shown = MouseFixedRender(*list, alpha, options, DisplaySeconds(!present));

    if (shown) {
        ++stats.display_frames;

        if (present) {
            NotePresented();
        }
    }

    return shown;
}

bool PresentCanonicalFrame() {
    CT_PROFILE_ZONE("Canonical image present");
    const gfx::DisplayList *overlay_list = DisplayOverlayList();
    const double            seconds = ClockUnbounded() && settings.display_per_tick > 0 ? 0 : DisplaySeconds();
    const bool              fixed = MouseFixedActive(seconds);
    const bool              pointer = MenuMousePointerVisible();
    bool                    shown = false;

    if (fixed || pointer) {
        gfx::RenderOptions options;
        options.present = true;
        options.overlay = overlay_list;
        options.suppressed_2d_key = MenuMouseReplacedHandKey();
        shown = pacer.Present([&] { return MouseFixedRender(*mgPortLastList(), 1, options, 0); }, Clock::now);
    } else if (overlay_list != nullptr) {
        gfx::RenderOptions options;
        options.present = true;
        options.host = true;
        shown = pacer.Present([&] { return gfx::RenderList(*overlay_list, 1.0f, options); }, Clock::now);
    } else {
        shown = pacer.Present(gfx::PresentCanonical, Clock::now);
    }

    if (shown) {
        ++stats.canonical_presents;
        NotePresented();
    }

    return shown;
}

// Async, between ticks: follows the mouse at the display's pace, as DisplayOverlayList does in Off, so the menu
// pointer and the fixed-camera look move with the display frames rather than once a tick.
void RepublishMouse() {
    CT_PROFILE_ZONE("Republish mouse");
    if (!WindowPollEvents()) {
        std::exit(kExitOk);
    }
    InputPoll();
    const bool pointer = MenuMousePointerVisible();
    MouseSetPointerCursor(pointer);
    gfx::DisplayListRef overlay_list;
    if (overlay.on || pointer) {
        // Recording shares the renderer's state with the worker's display frames.
        gfx::RenderLease lease;
        overlay_list = RecordHostOverlay(overlay.on);
    }
    const bool fixed = MouseFixedActive(DisplaySeconds());
    float      yaw = 0.0f;
    float      pitch = 0.0f;
    MouseFixedLook(yaw, pitch);
    {
        std::lock_guard lock(publish_mutex);
        published.overlay = std::move(overlay_list);
        published.look_yaw = yaw;
        published.look_pitch = pitch;
        published.mouse_fixed = fixed;
        published.mouse_pointer = pointer;
        published.suppressed_2d_key = MenuMouseReplacedHandKey();
        if (fixed || pointer || published.suppressed_2d_key != 0) {
            published.endpoint_policy = EndpointPolicy::Replay;
            published.canonical_endpoint_source = false;
        }
    }
    gfx::WakeRenderThread();
}

bool BetweenTicks(double fraction, Clock::time_point next_tick) {
    // The render thread presents while the game thread waits. While the mouse drives the pointer or the
    // fixed-camera look, the game thread polls it about once a millisecond; otherwise it sleeps until the tick.
    if (PresentAsync()) {
        PollFpsToggle();
        if (!PresentMouseActive() || ClockUnbounded() || mgPortLastList() == nullptr || Clock::now() >= next_tick) {
            return false;
        }
        RepublishMouse();
        std::this_thread::sleep_until(std::min(next_tick, Clock::now() + std::chrono::milliseconds(1)));
        return true;
    }

    if (mgPortLastList() == nullptr) {
        return false;
    }

    if (Clock::now() >= next_tick) {
        return false;
    }

    PollFpsToggle();

    const bool interpolation = InterpolateFrame(wait_frames);
    if (!interpolation && !PresentMouseActive()) {
        if (!tick_shown) {
            PresentCanonicalFrame();
            tick_shown = true;
        }

        return false;
    }

    const auto decision = pacer.Next(Clock::now(), next_tick, settings.max_fps);
    if (decision.action == PresentPacer::Action::Tick) {
        return false;
    }
    if (decision.action == PresentPacer::Action::Wait) {
        CT_PROFILE_ZONE("Display pace wait");
        std::this_thread::sleep_until(decision.deadline);
        return true;
    }

    // A game frame spans mgFrameRate ticks, so alpha is the fraction of the game frame elapsed, not of the tick.
    const float alpha = interpolation ? PresentFrameAlpha(static_cast<double>(ClockTickCount() - wait_start), fraction, wait_frames) : 1.0f;

    if (!pacer.Present([&] { return DisplayFrame(alpha, true); }, Clock::now)) {
        return false;
    }

    tick_shown = true;
    return true;
}

// Counts a presented frame and updates the rate the FPS text shows, on the render thread.
void NoteAsyncPresented(Clock::time_point now) {
    async_presented.fetch_add(1);
    CT_PROFILE_FRAME("Display");
    if (render_frames.Count(now)) {
        async_fps.store(render_frames.PerSecond());
    }
}

// The published tick at alpha, as DisplayFrame renders it, with the overlay recorded on the game thread.
bool RenderPublished(const Published &frame, float alpha) {
    gfx::RenderOptions options;
    options.previous = frame.settings.interpolation ? frame.previous.get() : nullptr;
    options.present = true;
    options.overlay = frame.overlay.get();
    options.suppressed_2d_key = frame.suppressed_2d_key;
    if (frame.mouse_fixed) {
        return MouseFixedRenderAt(*frame.list, options.previous, frame.look_yaw, frame.look_pitch, alpha, options);
    }
    return gfx::RenderList(*frame.list, alpha, options);
}

// The canonical present of the published tick, as PresentCanonicalFrame makes it with no mouse-fixed look or pointer.
bool PresentPublishedCanonical(const Published &frame) {
    if (frame.overlay) {
        gfx::RenderOptions options;
        options.present = true;
        options.host = true;
        return render_pacer.Present([&] { return gfx::RenderList(*frame.overlay, 1.0f, options); }, Clock::now);
    }
    return render_pacer.Present(gfx::PresentCanonical, Clock::now);
}

void SelectPublication(const Published &frame) {
    if (frame.serial != render_serial) {
        render_serial = frame.serial;
        render_tick_shown = false;
        if (!render_pair.Finished()) {
            async_unfinished_pairs.fetch_add(1);
        }
        if (frame.endpoint_policy == EndpointPolicy::CanonicalAuthored) {
            render_pair.Begin();
        } else {
            async_replay_ticks.fetch_add(1);
            render_pair.Cancel();
        }
    }
}

bool CurrentCanonicalImage(const Published &frame) {
    const auto current = gfx::CaptureCanonicalImage();
    return frame.canonical_image && current && *current == *frame.canonical_image;
}

bool PresentAuthoredEndpoint(const Published &frame) {
    if (!frame.canonical_image) {
        return false;
    }
    return render_pacer.Present([&] { return gfx::PresentCanonicalImage(*frame.canonical_image, frame.overlay.get()); }, Clock::now);
}

// Alpha of the published tick at now, as BetweenTicks computes it from the tick count: the fraction of the game
// frame elapsed. Without interpolation the display is the tick itself.
float PublishedAlpha(const Published &frame, Clock::time_point now) {
    if (!frame.settings.interpolation) {
        return 1.0f;
    }
    const double elapsed = std::chrono::duration<double>(now - frame.frame_start).count();
    return PresentFrameAlpha(elapsed * frame.tick_rate, 0.0, frame.frame_frames);
}

// An authored frame's intermediate image shows on the field between its two endpoints, whenever its render begins:
// alpha from the wall clock would follow how long the render waited for the GPU, so turns would judder.
float AuthoredIntermediateAlpha(const Published &frame) {
    return 1.0f / static_cast<float>(std::max(frame.frame_frames, 1));
}

/**
 * Decides when an authored intermediate would make its pair miss a vblank, so that its endpoint shows in its place.
 *
 * A miss slows the game and leaves the frame on screen for longer; holding the endpoint keeps both ticks on time.
 */
class IntermediateHold {
public:
    /**
     * Reports whether this tick's intermediate should be held, from the pair's expected GPU work and the last pair's length.
     */
    [[nodiscard]] bool Next(Clock::time_point now) {
        if (!Enabled()) {
            return false;
        }
        const gfx::RecentGpuWork work = gfx::GetRecentGpuWork();
        if (work.canonical_ms > 0.0f && work.replay_ms > 0.0f && work.replay_ms != last_replay_ms) {
            // A held pair renders no replay, so its cost follows the canonical render's by this ratio.
            last_replay_ms = work.replay_ms;
            replay_ratio = std::clamp(work.replay_ms / work.canonical_ms, kMinReplayRatio, kMaxReplayRatio);
        }
        // Only a pair that rendered its intermediate says anything about that intermediate's cost.
        const bool overran = !last_held && last_pair != Clock::time_point{} && now - last_pair > kPairOverrun && now - last_pair < kPairStale;
        // One missed vblank can stretch two pairs, and the intermediate did not cause it; holding only pays once the CPU stays behind.
        overruns = overran ? overruns + 1 : 0;
        if (overruns >= kOverrunsToHold) {
            cpu_hold = kCpuHoldPairs;
            overruns = 0;
        }
        last_pair = now;
        if (cpu_hold > 0) {
            --cpu_hold;
            last_held = true;
            return true;
        }
        last_held = work.canonical_ms * (1.0f + replay_ratio) > kBudgetMs;
        return last_held;
    }

private:
    static bool Enabled() {
        static const bool enabled = [] {
            const char *setting = std::getenv("DC2_PRESENT_HOLD");
#ifdef __SWITCH__
            const bool on = setting == nullptr || std::string_view(setting) != "0";
#else
            const bool on = setting != nullptr && std::string_view(setting) == "1";
#endif
            gfx::SetGpuWorkTracking(on);
            return on;
        }();
        return enabled;
    }

    // Two 60 Hz frames: a hold repeats a frame just as a miss does, so it must not fire ahead of a likely miss.
    static constexpr float kBudgetMs = 33.5f;
    // A pair this long missed a vblank whatever the GPU reported, so the CPU is behind.
    static constexpr auto kPairOverrun = std::chrono::microseconds(36000);
    // Longer than this is a pause or a load, not a pair.
    static constexpr auto kPairStale = std::chrono::milliseconds(100);
    static constexpr int  kOverrunsToHold = 3;
    static constexpr int  kCpuHoldPairs = 6;
    // The samples are a frame or two apart, so one odd pair must not decide the next.
    static constexpr float kMinReplayRatio = 0.9f;
    static constexpr float kMaxReplayRatio = 1.4f;

    Clock::time_point last_pair{};
    float             last_replay_ms = 0.0f;
    float             replay_ratio = 1.1f;
    int               cpu_hold = 0;
    int               overruns = 0;
    bool              last_held = false;
};

IntermediateHold intermediate_hold;

// The render thread's idle hook. It presents the newest published tick and returns how long it may sleep.
std::chrono::steady_clock::duration PresentRenderIdle(void *) {
    Published frame;
    {
        std::lock_guard lock(publish_mutex);
        frame = published;
    }

    if (!frame.list) {
        TraceScheduleGuard(frame, ScheduleEvent::Idle, ScheduleReason::NoList);
        return std::chrono::milliseconds(10);
    }
    // A present waits for an earlier frame's GPU work while it holds the device; yielding until that work is done
    // leaves the device to the game thread's tick meanwhile.
    if (!gfx::GpuPresentsPendingAtMost(kPresentGpuFrames)) {
        TraceScheduleGuard(frame, ScheduleEvent::Idle, ScheduleReason::GpuBacklog, false);
        return kPresentGpuPoll;
    }

    if (frame.epoch != settings_epoch.load()) {
        TraceScheduleGuard(frame, ScheduleEvent::Idle, ScheduleReason::EpochMismatch, true, {}, false);
        render_pair.Cancel();
        return std::chrono::milliseconds(2);
    }
    SelectPublication(frame);
    if (frame.mouse_fixed || frame.mouse_pointer || frame.suppressed_2d_key != 0) {
        TraceScheduleGuard(frame, ScheduleEvent::Idle, ScheduleReason::MouseOverride, true, {}, true);
        frame.endpoint_policy = EndpointPolicy::Replay;
        render_pair.Cancel();
    }
    using Action = dc2::presentation::EndpointPair::Action;
    if (frame.endpoint_policy == EndpointPolicy::CanonicalAuthored) {
        if (!CurrentCanonicalImage(frame)) {
            TraceScheduleGuard(frame, ScheduleEvent::Idle, ScheduleReason::ImageMismatch, true, false, true);
            render_pair.Cancel();
            return std::chrono::milliseconds(2);
        }
        const auto now = Clock::now();
        const bool gate = gfx::VsyncGateActive();
        const auto decision = render_pair.NextIdle(now, frame.frame_start + frame.frame_length, frame.settings.max_fps,
                                                   render_pacer, gate);
        if (decision.action == Action::Endpoint && frame.settings.endpoint_preflight &&
            !render_pair.IdleEndpointFeedbackReady(decision.action, frame.settings.max_fps, true,
                                                   gfx::PresentedGateActive(), [] {
                                                       endpoint_preflight_metrics.probes.fetch_add(1, std::memory_order_relaxed);
                                                       return gfx::PresentedGateReady();
                                                   })) {
            endpoint_preflight_metrics.pending.fetch_add(1, std::memory_order_relaxed);
            TraceScheduleGuard(frame, ScheduleEvent::Idle, ScheduleReason::FeedbackPending,
                               true, true, true, false, decision.action, gate);
            return std::chrono::milliseconds(1);
        }
        TracePairDecision(frame, ScheduleEvent::Idle, now, decision, gate);
        if (decision.action == Action::Wait) {
            return decision.deadline - now;
        }
        if (decision.action == Action::Done) {
            return std::chrono::milliseconds(2);
        }
        const bool hold = decision.action == Action::Intermediate && intermediate_hold.Next(now);
        const bool shown = decision.action == Action::Endpoint || hold ? PresentAuthoredEndpoint(frame)
                                                                       : render_pacer.Present([&] { return RenderPublished(frame, AuthoredIntermediateAlpha(frame)); }, Clock::now);
        if (shown) {
            render_pair.Presented(decision.action);
            if (decision.action == Action::Endpoint) {
                async_canonical_presents.fetch_add(1);
            } else {
                async_display_frames.fetch_add(1);
                async_held_frames.fetch_add(hold ? 1 : 0);
            }
            NoteAsyncPresented(Clock::now());
        }
        TraceScheduleGuard(frame, ScheduleEvent::Outcome, shown ? ScheduleReason::Presented : ScheduleReason::Failed,
                           true, true, true, shown, decision.action, gate);
        return shown ? Clock::duration::zero() : std::chrono::milliseconds(1);
    }

    // Without interpolation the tick is presented once, as PresentCanonicalFrame does at the tick's end.
    if (!frame.settings.interpolation && !frame.mouse_fixed && !frame.mouse_pointer) {
        if (!render_tick_shown) {
            const auto now = Clock::now();
            const auto due = render_pacer.Next(now, Clock::time_point::max(), frame.settings.max_fps);
            if (due.action != PresentPacer::Action::Display) {
                return due.deadline - now;
            }
            if (PresentPublishedCanonical(frame)) {
                async_canonical_presents.fetch_add(1);
                NoteAsyncPresented(Clock::now());
                render_tick_shown = true;
            }
        }
        return std::chrono::milliseconds(2);
    }

    const Clock::time_point now = Clock::now();
    const Clock::time_point frame_end = frame.frame_start + frame.frame_length;
    const auto              decision = render_pacer.Next(now, frame_end, frame.settings.max_fps);

    if (decision.action == PresentPacer::Action::Wait) {
        return decision.deadline - now;
    }

    if (decision.action == PresentPacer::Action::Tick) {
        // The game frame has ended: show its last moment once, if the pace allowed none.
        if (!render_tick_shown) {
            const float alpha = frame.settings.interpolation ? std::nextafter(1.0f, 0.0f) : 1.0f;
            if (render_pacer.Present([&] { return RenderPublished(frame, alpha); }, Clock::now)) {
                async_display_frames.fetch_add(1);
                NoteAsyncPresented(Clock::now());
                render_tick_shown = true;
            }
        }
        return std::chrono::milliseconds(1);
    }

    const float alpha = PublishedAlpha(frame, now);
    if (!render_pacer.Present([&] { return RenderPublished(frame, alpha); }, Clock::now)) {
        return std::chrono::milliseconds(1);
    }

    async_display_frames.fetch_add(1);
    NoteAsyncPresented(Clock::now());
    render_tick_shown = true;
    return Clock::duration::zero();
}

} // namespace

namespace dc2::presentation {

PresentSettings SwitchPresentationSettings(PresentSettings value) {
    value.endpoint_preflight = true;
    value.deferred_canonical = true;
    value.max_fps = value.max_fps > 0.0 && value.max_fps < 60.0 ? value.max_fps : 60.0;
    value.display_per_tick = 0;
    return value;
}

void ResumeAfterSuspend() {
    gfx::RenderLease lease;
    const auto       epoch = settings_epoch.fetch_add(1) + 1;
    std::uint64_t    retired_serial = 0;
    {
        std::scoped_lock lock{publish_mutex};
        retired_serial = published.serial;
        published = {};
        published.serial = retired_serial;
        published.epoch = epoch;
        render_serial = retired_serial;
    }
    render_pair.Cancel();
    render_pacer = {};
    pacer = {};
    render_frames = OverlayRate{};
    render_tick_shown = false;
    tick_shown = true;
    dc2::timing::BeginFrame();
    mgPortCutInterpolation();
    CT_LOG_INFO(Main, "presentation resume: retired_publication={} epoch={} pending_endpoint=cancelled next_publication=fresh-replay", retired_serial, epoch);
}

void PrepareSchedulingTrace() {
    const char *setting = std::getenv("DC2_PERF_PRESENT_TRACE");
    if (setting == nullptr || std::string_view{setting} != "1") {
        return;
    }
    scheduling_trace_active.store(false, std::memory_order_release);
    std::scoped_lock lock{scheduling_trace_mutex};
    scheduling_trace = {};
    scheduling_trace.rows.reserve(kScheduleTraceCapacity);
    scheduling_trace.collection = ScheduleClockNow();
    scheduling_trace.enabled = true;
    scheduling_trace_active.store(true, std::memory_order_release);
}

void BeginSchedulingTrace(Clock::time_point now, std::uint64_t native_ns) {
    std::scoped_lock lock{scheduling_trace_mutex};
    if (scheduling_trace.enabled) {
        scheduling_trace.begin_steady = ScheduleNs(now);
        scheduling_trace.begin_native = native_ns;
    }
}

void EndSchedulingTrace(Clock::time_point now, std::uint64_t native_ns) {
    scheduling_trace_active.store(false, std::memory_order_release);
    std::scoped_lock lock{scheduling_trace_mutex};
    if (scheduling_trace.enabled) {
        scheduling_trace.end_steady = ScheduleNs(now);
        scheduling_trace.end_native = native_ns;
    }
}

void LogSchedulingTrace() {
    PresentSettings captured_settings;
    {
        std::scoped_lock lock{publish_mutex};
        captured_settings = published.settings;
    }
    if (captured_settings.endpoint_preflight) {
        CT_LOG_INFO(Main, "perf endpoint preflight: scope=lifetime feedback={} probes={} pending={}",
                    gfx::PresentedGateActive(), endpoint_preflight_metrics.probes.load(std::memory_order_relaxed),
                    endpoint_preflight_metrics.pending.load(std::memory_order_relaxed));
    }
    if (captured_settings.deferred_canonical) {
        const auto &metrics = deferred_canonical_metrics;
        CT_LOG_INFO(Main, "perf deferred canonical: scope=lifetime feedback={} attempts={} selected={} rendered={} retired={} fallback_mode={} fallback_pair={} fallback_policy={} fallback_epoch={} fallback_gpu={} fallback_image={} fallback_preservation={}",
                    gfx::PresentedGateActive(), metrics.attempts.load(), metrics.selected.load(), metrics.rendered.load(),
                    metrics.retired.load(), metrics.mode.load(), metrics.pair.load(), metrics.policy.load(), metrics.epoch.load(),
                    metrics.gpu.load(), metrics.image.load(), metrics.preservation.load());
    }
    scheduling_trace_active.store(false, std::memory_order_release);
    SchedulingTrace captured;
    {
        std::scoped_lock lock{scheduling_trace_mutex};
        if (!scheduling_trace.enabled) {
            return;
        }
        captured = std::move(scheduling_trace);
        scheduling_trace = {};
    }
    const bool valid = !captured.rows.empty() && captured.collection.native > 0 && captured.overflow == 0 && captured.clock_errors == 0 && captured.begin_native > 0 &&
                       captured.end_native > captured.begin_native && captured.end_steady > captured.begin_steady;
    CT_LOG_INFO(Main, "perf scheduling begin: valid={} records={} overflow={} clock_errors={} collection_steady_ns={} collection_native_ns={} begin_steady_ns={} begin_native_ns={} end_steady_ns={} end_native_ns={}",
                valid, captured.rows.size(), captured.overflow, captured.clock_errors, captured.collection.steady_before,
                captured.collection.native, captured.begin_steady, captured.begin_native, captured.end_steady, captured.end_native);
    CT_LOG_INFO(Main, "perf scheduling scope: warmup included; select measured events by clock boundaries; native requires KZ_PERF_FRAME_HISTORY=1; guard -1=untested; paired steady reads bound native-clock offset");
    constexpr std::array events = {"publish", "idle", "retire", "outcome"};
    constexpr std::array reasons = {"published", "no-list", "gpu-backlog", "epoch-mismatch", "replay-policy", "mouse-override",
                                    "image-mismatch", "selected", "expired-unshown", "presented", "failed", "replaced",
                                    "feedback-pending"};
    const auto           optional_flag = [](std::optional<bool> value) {
        if (!value) {
            return -1;
        }
        return *value ? 1 : 0;
    };
    const auto action_name = [](std::optional<EndpointPair::Action> action) {
        if (!action) {
            return "untested";
        }
        switch (*action) {
            case EndpointPair::Action::Wait:
                return "wait";
            case EndpointPair::Action::Intermediate:
                return "intermediate";
            case EndpointPair::Action::Endpoint:
                return "endpoint";
            case EndpointPair::Action::Done:
                return "done";
        }
        return "unknown";
    };
    for (const auto &row : captured.rows) {
        CT_LOG_INFO(Main, "perf scheduling row: event={} reason={} publication={} pair={} instance={} list={} previous={} epoch={} policy={} cap={} image={} eligible={} pending={} gate={} gpu={} current={} epoch_match={} shown={} action={} frame_start_ns={} frame_end_ns={} now_ns={} deadline_ns={} steady_before_ns={} native_ns={} steady_after_ns={} repeats={} last_steady_before_ns={} last_native_ns={} last_steady_after_ns={}",
                    events[static_cast<std::size_t>(row.event)], reasons[static_cast<std::size_t>(row.reason)], row.serial,
                    row.pair_serial, row.instance, row.list, row.previous, row.epoch,
                    row.policy == EndpointPolicy::CanonicalAuthored ? "authored" : "replay", row.max_fps,
                    row.image, row.eligible_source, optional_flag(row.pending), optional_flag(row.gate), optional_flag(row.gpu),
                    optional_flag(row.current), optional_flag(row.epoch_match), optional_flag(row.shown), action_name(row.action),
                    row.frame_start, row.frame_end, row.decision_now, row.deadline, row.clock.steady_before, row.clock.native,
                    row.clock.steady_after, row.repeats, row.last_clock.steady_before, row.last_clock.native, row.last_clock.steady_after);
    }
    CT_LOG_INFO(Main, "perf scheduling end: records={} overflow={} clock_errors={} valid={}", captured.rows.size(), captured.overflow, captured.clock_errors, valid);
}

void BeforeCanonical() {
    if (!PresentAsync()) {
        return;
    }
    Published frame;
    {
        std::lock_guard lock(publish_mutex);
        frame = published;
    }
    if (!frame.list || frame.endpoint_policy != EndpointPolicy::CanonicalAuthored ||
        frame.mouse_fixed || frame.mouse_pointer || frame.suppressed_2d_key != 0) {
        auto reason = ScheduleReason::MouseOverride;
        if (!frame.list) {
            reason = ScheduleReason::NoList;
        } else if (frame.endpoint_policy != EndpointPolicy::CanonicalAuthored) {
            reason = ScheduleReason::ReplayPolicy;
        }
        TraceScheduleGuard(frame, ScheduleEvent::Retire, reason);
        render_pair.Cancel();
        return;
    }
    SelectPublication(frame);
    // Retirement retains the current image's ownership and the existing GPU backlog limit.
    if (frame.epoch != settings_epoch.load()) {
        TraceScheduleGuard(frame, ScheduleEvent::Retire, ScheduleReason::EpochMismatch, {}, {}, false);
    } else if (!gfx::GpuPresentsPendingAtMost(kPresentGpuFrames)) {
        TraceScheduleGuard(frame, ScheduleEvent::Retire, ScheduleReason::GpuBacklog, false, {}, true);
    } else if (!CurrentCanonicalImage(frame)) {
        TraceScheduleGuard(frame, ScheduleEvent::Retire, ScheduleReason::ImageMismatch, true, false, true);
    } else {
        const auto now = Clock::now();
        const bool gate = gfx::VsyncGateActive();
        const auto decision = render_pair.NextBeforeCanonical(now, frame.frame_start + frame.frame_length,
                                                              frame.settings.max_fps, render_pacer, gate);
        TracePairDecision(frame, ScheduleEvent::Retire, now, decision, gate);
        if (decision.action == EndpointPair::Action::Endpoint) {
            const bool shown = PresentAuthoredEndpoint(frame);
            if (shown) {
                async_canonical_presents.fetch_add(1);
                NoteAsyncPresented(Clock::now());
            }
            TraceScheduleGuard(frame, ScheduleEvent::Outcome, shown ? ScheduleReason::Presented : ScheduleReason::Failed,
                               true, true, true, shown, decision.action, gate);
        }
    }
    TraceScheduleGuard(frame, ScheduleEvent::Retire, ScheduleReason::Replaced);
    // The next canonical render replaces this source, so any remaining phase is obsolete.
    render_pair.Cancel();
}

bool TryRenderCanonicalBeforeEndpoint(const gfx::DisplayList &next) {
    if (!PresentAsync()) {
        return false;
    }
    Published frame;
    {
        std::scoped_lock lock{publish_mutex};
        frame = published;
    }
    if (!frame.settings.deferred_canonical) {
        return false;
    }
    auto &metrics = deferred_canonical_metrics;
    ++metrics.attempts;
    if (!gfx::PresentedGateActive()) {
        ++metrics.mode;
        return false;
    }
    if (!frame.list || !frame.canonical_image || frame.endpoint_policy != EndpointPolicy::CanonicalAuthored ||
        frame.mouse_fixed || frame.mouse_pointer || frame.suppressed_2d_key != 0 ||
        (frame.settings.max_fps > 0.0 && frame.settings.max_fps < 60.0)) {
        ++metrics.policy;
        return false;
    }
    if (frame.serial != render_serial || !render_pair.PendingEndpoint()) {
        ++metrics.pair;
        return false;
    }
    if (frame.epoch != settings_epoch.load()) {
        ++metrics.epoch;
        return false;
    }
    if (!gfx::GpuPresentsPendingAtMost(kPresentGpuFrames)) {
        ++metrics.gpu;
        return false;
    }
    if (!CurrentCanonicalImage(frame)) {
        ++metrics.image;
        return false;
    }
    ++metrics.selected;
    bool       retired = false;
    const bool rendered = gfx::RenderCanonicalBeforeCommit(next, *frame.canonical_image, frame.overlay.get(), [&] {
        const auto before = async_canonical_presents.load();
        BeforeCanonical();
        retired = async_canonical_presents.load() != before;
    });
    if (!rendered) {
        ++metrics.preservation;
        return false;
    }
    ++metrics.rendered;
    if (retired) {
        ++metrics.retired;
    }
    return true;
}

} // namespace dc2::presentation

bool PresentMouseActive() {
    return MenuMousePointerVisible() || MouseFixedActive(0);
}

void PresentSetSettings(const PresentSettings &value) {
    settings = value;
    const auto resolve = [](const char *name, bool fallback) {
        const char *setting = std::getenv(name);
        if (setting != nullptr && std::string_view{setting} == "0") {
            return false;
        }
        if (setting != nullptr && std::string_view{setting} == "1") {
            return true;
        }
        return fallback;
    };
    settings.endpoint_preflight = resolve("DC2_PERF_ENDPOINT_PREFLIGHT", value.endpoint_preflight);
    settings.deferred_canonical = resolve("DC2_PERF_DEFERRED_CANONICAL_COMMIT", value.deferred_canonical);
    settings_epoch.fetch_add(1);
    overlay.on = value.show_fps;
    if (PresentAsync()) {
        gfx::SetRenderIdleHook(PresentRenderIdle, nullptr);
    }
}

const PresentSettings &PresentGetSettings() {
    return settings;
}

PresentStats PresentGetStats() {
    PresentStats result = stats;
    if (PresentAsync()) {
        result.presented = async_presented.load();
        result.display_frames = async_display_frames.load();
        result.canonical_presents = async_canonical_presents.load();
        result.unfinished_pairs = async_unfinished_pairs.load();
        result.replay_ticks = async_replay_ticks.load();
        result.held_frames = async_held_frames.load();
    }
    return result;
}

void PresentResetStats() {
    stats = PresentStats{};
    async_presented = 0;
    async_display_frames = 0;
    async_canonical_presents = 0;
    async_unfinished_pairs = 0;
    async_replay_ticks = 0;
    async_held_frames = 0;
}

void PresentTickRendered() {
    const gfx::DisplayList *list = mgPortLastList();

    if (list == nullptr) {
        return;
    }

    ++stats.ticks;
    const gfx::DisplayListStats draws = gfx::ListStats(*list);
    stats.last_draws = draws.mesh_draws + draws.draws_2d;
    CT_PROFILE_PLOT("Scene mesh draws", static_cast<std::int64_t>(draws.mesh_draws));
    CT_PROFILE_PLOT("Scene 2D draws", static_cast<std::int64_t>(draws.draws_2d));

    // Capped so a long stall does not replay an unbounded number of ticks into the rate window.
    const Clock::time_point now = Clock::now();
    const std::int64_t      now_tick = ClockTickCount();

    for (std::int64_t t = counted_tick; t < now_tick && t < counted_tick + 16; ++t) {
        overlay.ticks.Count(now);
    }

    counted_tick = now_tick;
    tick_shown = false;
}

void PresentWaitFrame(int start, int frames) {
    wait_start = start;
    wait_frames = frames;
    dc2::timing::WaitTicks(start, frames, BetweenTicks);
}

namespace {

TickPublication PrepareTick(int start, int frames, bool canonical_endpoint_allowed) {
    TickPublication tick;
    // The game thread records the host overlay and reads the mouse, as DisplayOverlayList does for a display.
    tick.pointer = MenuMousePointerVisible();
    MouseSetPointerCursor(tick.pointer);
    if (overlay.on || tick.pointer) {
        tick.overlay = RecordHostOverlay(overlay.on);
    }

    const double seconds = ClockUnbounded() && settings.display_per_tick > 0 ? 0 : DisplaySeconds();
    tick.fixed = MouseFixedActive(seconds);
    MouseFixedLook(tick.yaw, tick.pitch);

    // The game frame began at the boundary of tick `start`, which lies this many ticks before now.
    const Clock::time_point now = Clock::now();
    tick.tick_rate = ClockTickRate();
    const double ticks_since_start = static_cast<double>(ClockTickCount() - start) + ClockTickFraction();
    tick.frame_start = now - std::chrono::duration_cast<Clock::duration>(std::chrono::duration<double>(ticks_since_start / tick.tick_rate));
    tick.frame_length = std::chrono::duration_cast<Clock::duration>(std::chrono::duration<double>(frames / tick.tick_rate));

    LogPresentRates(now);

#ifdef __SWITCH__
    const char *endpoint_override = std::getenv("DC2_SWITCH_CANONICAL_ENDPOINTS");
    tick.endpoint_enabled = endpoint_override == nullptr || std::string_view(endpoint_override) != "0";
#endif
    tick.list = mgPortLastListRef();
    tick.previous = mgPortPreviousListRef();
    tick.suppressed_key = MenuMouseReplacedHandKey();
    tick.epoch = settings_epoch.load();
    tick.settings = settings;
    tick.interpolation = InterpolateFrame(frames);
    tick.endpoint_allowed = canonical_endpoint_allowed;
    tick.frames = frames;
    return tick;
}

// Whether the tick's canonical image may end its game frame, with the image and the one the tick before published.
EndpointPolicy EndpointPolicyFor(const TickPublication &tick, const std::optional<gfx::CanonicalImageToken> &image,
                                 const Published &before, const std::optional<gfx::CanonicalImageToken> &before_image,
                                 bool &eligible_source) {
    const bool previous_compatible = before.list && tick.previous && before.list.get() == tick.previous.get() &&
                                     before.frame_frames == 2 && before.settings.interpolation && before.canonical_endpoint_source &&
                                     before.epoch == tick.epoch && before_image && image && image->SharesStorageWith(*before_image);
    eligible_source = tick.endpoint_enabled && tick.endpoint_allowed && image && tick.list && tick.frames == 2 && tick.interpolation &&
                      !ClockUnbounded() && tick.settings.display_per_tick == 0 && std::abs(tick.tick_rate - 60.0) < .1 &&
                      std::abs(tick.settings.max_fps - 60.0) < .1 && !tick.fixed && !tick.pointer && tick.suppressed_key == 0;
    const bool endpoint = eligible_source && previous_compatible && tick.previous && tick.list->instance == tick.previous->instance &&
                          tick.list->cut_generation == tick.previous->cut_generation;
    return endpoint ? EndpointPolicy::CanonicalAuthored : EndpointPolicy::Replay;
}

// Device thread, once the tick's canonical render has run.
void Publish(TickPublication tick, const std::optional<gfx::CanonicalImageToken> &image) {
    std::optional<ScheduleRow> trace;
    {
        std::scoped_lock lock(publish_mutex);
        if (tick.epoch != settings_epoch.load()) {
            return;
        }
        bool eligible_source = false;
        published.endpoint_policy = EndpointPolicyFor(tick, image, published, published.canonical_image, eligible_source);
        published.canonical_endpoint_source = eligible_source;
        published.canonical_image = image;
        published.epoch = tick.epoch;
        published.list = std::move(tick.list);
        published.previous = std::move(tick.previous);
        published.overlay = std::move(tick.overlay);
        published.settings = tick.settings;
        published.settings.interpolation = tick.interpolation;
        published.suppressed_2d_key = tick.suppressed_key;
        published.frame_start = tick.frame_start;
        published.frame_length = tick.frame_length;
        published.frame_frames = tick.frames;
        published.tick_rate = tick.tick_rate;
        published.look_yaw = tick.yaw;
        published.look_pitch = tick.pitch;
        published.mouse_fixed = tick.fixed;
        published.mouse_pointer = tick.pointer;
        ++published.serial;
        trace = ScheduleObservation(published, ScheduleEvent::Publish, ScheduleReason::Published);
    }
    AppendSchedule(trace);
}

} // namespace

std::function<void()> PresentPrepareTick(int start, int frames, bool canonical_endpoint_allowed) {
    if (!PresentAsync()) {
        return {};
    }
    return [tick = PrepareTick(start, frames, canonical_endpoint_allowed)]() mutable {
        Publish(std::move(tick), gfx::CaptureCanonicalImage());
        gfx::WakeRenderThread();
    };
}

void PresentPublishTick(int start, int frames, bool canonical_endpoint_allowed) {
    if (const auto publish = PresentPrepareTick(start, frames, canonical_endpoint_allowed)) {
        publish();
    }
}

void PresentTickEnd() {
    CT_PROFILE_ZONE("Present tick end");
    if (PresentAsync()) {
        return;
    }

    if (tick_shown || mgPortLastList() == nullptr) {
        return;
    }

    PollFpsToggle();

    if (ClockUnbounded()) {
        for (int k = 0; k < settings.display_per_tick; ++k) {
            DisplayFrame(static_cast<float>(k) / static_cast<float>(settings.display_per_tick), false);
        }
    }

    PresentCanonicalFrame();
    tick_shown = true;
}

std::string PresentFpsText() {
    char piece[64];
    std::snprintf(piece, sizeof piece, "FPS %.1f", PresentAsync() ? async_fps.load() : overlay.frames.PerSecond());
    std::string text = piece;

    if (settings.fps_detail != ConfigFpsDetail::Fps) {
        std::snprintf(piece, sizeof piece, "  TICK %.1f/%g", overlay.ticks.PerSecond(), ClockTickRate());
        text += piece;
    }

    if (settings.fps_detail == ConfigFpsDetail::All) {
        std::snprintf(piece, sizeof piece, "  DRAWS %u", stats.last_draws);
        text += piece;
    }

    return text;
}

bool PresentScreenshotDisplay(float alpha, std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height) {
    const gfx::DisplayList *list = mgPortLastList();
    const gfx::DisplayList *previous = mgPortPreviousList();

    if (list == nullptr) {
        return false;
    }

    // Interpolation off presents the canonical image once per tick; alpha must not blend it with the previous tick.
    if (!settings.interpolation) {
        if (MouseFixedActive(0)) {
            gfx::RenderOptions options;
            options.present = true;
            return MouseFixedRender(*list, 1, options, 0) && gfx::ReadbackFrame(rgba, width, height);
        }
        return gfx::PresentCanonical() && gfx::ReadbackFrame(rgba, width, height);
    }

    if (previous == nullptr) {
        return false;
    }

    gfx::RenderOptions options;
    options.previous = previous;
    options.present = true;

    return MouseFixedRender(*list, alpha, options, 0) && gfx::ReadbackFrame(rgba, width, height);
}

bool PresentScreenshotFps(std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height) {
    const gfx::DisplayList *list = mgPortLastList();

    if (list == nullptr) {
        return false;
    }

    // The overlay exists only in a presented image, and the canonical target never takes it, so the
    // composite is presented at alpha 1 and read back from the window-sized display image.
    // Like a presented frame, it carries the menu pointer in place of the retail hand it stands for.
    const gfx::DisplayListRef fps = RecordHostOverlay(true);
    if (!fps) {
        return false;
    }
    gfx::RenderOptions options;
    options.present = true;
    options.overlay = fps.get();
    options.suppressed_2d_key = MenuMouseReplacedHandKey();

    return gfx::RenderList(*list, 1.0f, options) && gfx::ReadbackFrame(rgba, width, height);
}
