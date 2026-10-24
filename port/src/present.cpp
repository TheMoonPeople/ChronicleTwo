#include "present.hpp"

#include <algorithm>
#include <atomic>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <mutex>
#include <string>
#include <thread>

#include "camera_fixed.hpp"
#include "exitcodes.hpp"
#include "gfx/gfx.hpp"
#include "log/log.hpp"
#include "luau_runtime.hpp"
#include "menu_mouse.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "platform/overlay.hpp"
#include "platform/window.hpp"
#include "present_timing.hpp"
#include "profile.hpp"
#include "stubs/mglib.hpp"

namespace {

using Clock = std::chrono::steady_clock;

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

// The tick the render thread presents, written by the game thread under publish_mutex.
struct Published {
    gfx::DisplayListRef list;     // The tick's canonical list.
    gfx::DisplayListRef previous; // The tick before it.
    gfx::DisplayListRef overlay;  // The host overlay recorded for this tick, or null.
    PresentSettings     settings;
    gfx::InterpKey      suppressed_2d_key = 0;
    // The game frame ending with this tick: it began at frame_start, lasts frame_frames ticks at tick_rate.
    Clock::time_point frame_start;
    Clock::duration   frame_length{};
    int               frame_frames = 0;
    double            tick_rate = 0.0;
    float             look_yaw = 0.0f;
    float             look_pitch = 0.0f;
    bool              mouse_fixed = false;
    bool              mouse_pointer = false;
    std::uint64_t     serial = 0;
};

std::mutex                 publish_mutex;
Published                  published;
std::atomic<double>        async_fps{0.0};
std::atomic<std::uint64_t> async_presented{0};
std::atomic<std::uint64_t> async_display_frames{0};
std::atomic<std::uint64_t> async_canonical_presents{0};

// Only the render thread's idle hook touches these.
PresentPacer  render_pacer;
OverlayRate   render_frames;
std::uint64_t render_serial = 0;
bool          render_tick_shown = false;

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
        const int pixel = OverlayPixelSize(gfx::GetLogicalMapping(gfx::kMainTarget));
        OverlayDrawText(PresentFpsText(), gfx::GetUiMapping(gfx::kMainTarget), pixel,
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

void NotePresented() {
    ++stats.presented;
    CT_PROFILE_FRAME("Display");
    const Clock::time_point now = Clock::now();
    overlay.frames.Count(now);

    if (settings.log_fps && now - last_log >= std::chrono::seconds(1)) {
        last_log = now;
        CT_LOG_INFO(Gfx, "present: {}", PresentFpsText());
    }
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

    if (!settings.interpolation && !PresentMouseActive()) {
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
    const float alpha = settings.interpolation ? PresentFrameAlpha(static_cast<double>(ClockTickCount() - wait_start), fraction, wait_frames) : 1.0f;

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

// Alpha of the published tick at now, as BetweenTicks computes it from the tick count: the fraction of the game
// frame elapsed. Without interpolation the display is the tick itself.
float PublishedAlpha(const Published &frame, Clock::time_point now) {
    if (!frame.settings.interpolation) {
        return 1.0f;
    }
    const double elapsed = std::chrono::duration<double>(now - frame.frame_start).count();
    return PresentFrameAlpha(elapsed * frame.tick_rate, 0.0, frame.frame_frames);
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

    if (frame.serial != render_serial) {
        render_serial = frame.serial;
        render_tick_shown = false;
    }

    // Without interpolation the tick is presented once, as PresentCanonicalFrame does at the tick's end.
    if (!frame.settings.interpolation && !frame.mouse_fixed && !frame.mouse_pointer) {
        if (!render_tick_shown) {
            if (PresentPublishedCanonical(frame)) {
                async_canonical_presents.fetch_add(1);
                NoteAsyncPresented(Clock::now());
            }
            render_tick_shown = true;
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

bool PresentMouseActive() {
    return MenuMousePointerVisible() || MouseFixedActive(0);
}

void PresentSetSettings(const PresentSettings &value) {
    settings = value;
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
    }
    return result;
}

void PresentResetStats() {
    stats = PresentStats{};
    async_presented = 0;
    async_display_frames = 0;
    async_canonical_presents = 0;
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

namespace {

// With KZ_FRAME_STATS set, where the game thread's time went, logged every five seconds beside Kazarov's frame
// stats: the time between one game frame's wait and the next is the frame's own work, scripts included.
struct GameStats {
    std::uint64_t     frames = 0;
    double            busy_ms = 0;
    double            longest_ms = 0;
    double            wait_ms = 0;
    Clock::time_point wait_end{};
    Clock::time_point since = Clock::now();
};

GameStats game_stats;

} // namespace

void PresentWaitFrame(int start, int frames) {
    wait_start = start;
    wait_frames = frames;
    static const bool stats_on = std::getenv("KZ_FRAME_STATS") != nullptr;
    if (!stats_on) {
        mgTimeWaitTicks(start, frames, BetweenTicks);
        return;
    }
    const Clock::time_point wait_begin = Clock::now();
    if (game_stats.wait_end != Clock::time_point{}) {
        const double busy = std::chrono::duration<double, std::milli>(wait_begin - game_stats.wait_end).count();
        ++game_stats.frames;
        game_stats.busy_ms += busy;
        game_stats.longest_ms = std::max(game_stats.longest_ms, busy);
    }
    mgTimeWaitTicks(start, frames, BetweenTicks);
    game_stats.wait_end = Clock::now();
    game_stats.wait_ms += std::chrono::duration<double, std::milli>(game_stats.wait_end - wait_begin).count();
    if (game_stats.wait_end - game_stats.since >= std::chrono::seconds(5) && game_stats.frames > 0) {
        const double seconds = std::chrono::duration<double>(game_stats.wait_end - game_stats.since).count();
        const double count = static_cast<double>(game_stats.frames);
        const double script_ms = static_cast<double>(luau_runtime::TakeScriptNanoseconds()) / 1e6;
        CT_LOG_INFO(Gfx,
                    "game stats: {:.1f} game frames a second, {:.2f} ms of work a frame (longest {:.1f}), of which "
                    "{:.2f} in Luau scripts and the commands they call; {:.2f} ms waiting a frame",
                    count / seconds, game_stats.busy_ms / count, game_stats.longest_ms, script_ms / count,
                    game_stats.wait_ms / count);
        const Clock::time_point wait_end = game_stats.wait_end;
        game_stats = {};
        game_stats.wait_end = wait_end;
    }
}

void PresentPublishTick(int start, int frames) {
    if (!PresentAsync()) {
        return;
    }

    // The game thread records the host overlay and reads the mouse, as DisplayOverlayList does for a display.
    const bool pointer = MenuMousePointerVisible();
    MouseSetPointerCursor(pointer);
    gfx::DisplayListRef overlay_list;
    if (overlay.on || pointer) {
        overlay_list = RecordHostOverlay(overlay.on);
    }

    const double seconds = ClockUnbounded() && settings.display_per_tick > 0 ? 0 : DisplaySeconds();
    const bool   fixed = MouseFixedActive(seconds);
    float        yaw = 0.0f;
    float        pitch = 0.0f;
    MouseFixedLook(yaw, pitch);

    // The game frame began at the boundary of tick `start`, which lies this many ticks before now.
    const Clock::time_point now = Clock::now();
    const double            tick_rate = ClockTickRate();
    const double            ticks_since_start = static_cast<double>(ClockTickCount() - start) + ClockTickFraction();
    const auto              frame_start = now - std::chrono::duration_cast<Clock::duration>(
                                                    std::chrono::duration<double>(ticks_since_start / tick_rate));
    const auto              frame_length =
        std::chrono::duration_cast<Clock::duration>(std::chrono::duration<double>(frames / tick_rate));

    if (settings.log_fps && now - last_log >= std::chrono::seconds(1)) {
        last_log = now;
        CT_LOG_INFO(Gfx, "present: {}", PresentFpsText());
    }

    gfx::DisplayListRef list = mgPortLastListRef();
    gfx::DisplayListRef previous = mgPortPreviousListRef();
    const auto          suppressed_key = MenuMouseReplacedHandKey();
    {
        std::lock_guard lock(publish_mutex);
        published.list = std::move(list);
        published.previous = std::move(previous);
        published.overlay = std::move(overlay_list);
        published.settings = settings;
        published.suppressed_2d_key = suppressed_key;
        published.frame_start = frame_start;
        published.frame_length = frame_length;
        published.frame_frames = frames;
        published.tick_rate = tick_rate;
        published.look_yaw = yaw;
        published.look_pitch = pitch;
        published.mouse_fixed = fixed;
        published.mouse_pointer = pointer;
        ++published.serial;
    }
    gfx::WakeRenderThread();
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
