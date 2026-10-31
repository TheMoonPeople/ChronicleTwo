#include "present.hpp"

#include <algorithm>
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

// Presents the GPU may still be running when another is made. The WSI waits for the image presented three presents
// before, so two keep the GPU fed without a present waiting.
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

// Device ownership serializes the idle hook and the pre-canonical endpoint retirement.
PresentPacer                    render_pacer;
OverlayRate                     render_frames;
std::uint64_t                   render_serial = 0;
bool                            render_tick_shown = false;
dc2::presentation::EndpointPair render_pair;

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

// The render thread's idle hook. It presents the newest published tick and returns how long it may sleep.
std::chrono::steady_clock::duration PresentRenderIdle(void *) {
    Published frame;
    {
        std::lock_guard lock(publish_mutex);
        frame = published;
    }

    if (!frame.list) {
        return std::chrono::milliseconds(10);
    }
    // A present waits for an earlier frame's GPU work while it holds the device; yielding until that work is done
    // leaves the device to the game thread's tick meanwhile.
    if (!gfx::GpuPresentsPendingAtMost(kPresentGpuFrames)) {
        return kPresentGpuPoll;
    }

    if (frame.epoch != settings_epoch.load()) {
        render_pair.Cancel();
        return std::chrono::milliseconds(2);
    }
    SelectPublication(frame);
    if (frame.mouse_fixed || frame.mouse_pointer || frame.suppressed_2d_key != 0) {
        frame.endpoint_policy = EndpointPolicy::Replay;
        render_pair.Cancel();
    }
    using Action = dc2::presentation::EndpointPair::Action;
    if (frame.endpoint_policy == EndpointPolicy::CanonicalAuthored) {
        if (!CurrentCanonicalImage(frame)) {
            render_pair.Cancel();
            return std::chrono::milliseconds(2);
        }
        const auto now = Clock::now();
        const auto decision = render_pair.Next(now, frame.frame_start + frame.frame_length, frame.settings.max_fps, render_pacer);
        if (decision.action == Action::Wait) {
            return decision.deadline - now;
        }
        if (decision.action == Action::Done) {
            return std::chrono::milliseconds(2);
        }
        const bool shown = decision.action == Action::Endpoint ? PresentAuthoredEndpoint(frame)
                                                               : render_pacer.Present([&] { return RenderPublished(frame, AuthoredIntermediateAlpha(frame)); }, Clock::now);
        if (shown) {
            render_pair.Presented(decision.action);
            if (decision.action == Action::Endpoint) {
                async_canonical_presents.fetch_add(1);
            } else {
                async_display_frames.fetch_add(1);
            }
            NoteAsyncPresented(Clock::now());
        }
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
        render_pair.Cancel();
        return;
    }
    SelectPublication(frame);
    // The tick's endpoint is skipped rather than holding up the game thread behind earlier GPU work.
    if (frame.epoch == settings_epoch.load() && gfx::GpuPresentsPendingAtMost(kPresentGpuFrames) && CurrentCanonicalImage(frame)) {
        const auto decision = render_pair.Next(Clock::now(), frame.frame_start + frame.frame_length,
                                               frame.settings.max_fps, render_pacer);
        if (decision.action == EndpointPair::Action::Endpoint && PresentAuthoredEndpoint(frame)) {
            async_canonical_presents.fetch_add(1);
            NoteAsyncPresented(Clock::now());
        }
    }
    // Device work must not sleep to rescue a phase that missed its available source image.
    render_pair.Cancel();
}

} // namespace dc2::presentation

bool PresentMouseActive() {
    return MenuMousePointerVisible() || MouseFixedActive(0);
}

void PresentSetSettings(const PresentSettings &value) {
    settings = value;
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
    std::lock_guard lock(publish_mutex);
    bool            eligible_source = false;
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
