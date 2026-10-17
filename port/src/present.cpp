#include "present.hpp"

#include <chrono>
#include <cstdint>
#include <cstdio>
#include <string>
#include <thread>
#include <utility>

#include "camera_fixed.hpp"
#include "exitcodes.hpp"
#include "gfx/gfx.hpp"
#include "menu_mouse.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "platform/overlay.hpp"
#include "platform/window.hpp"
#include "present_timing.hpp"

void mgTimeWaitTicks(int start, int frames, ClockWaitHook hook);

namespace {

using Clock = std::chrono::steady_clock;

struct FpsOverlay {
    bool on = false;
    OverlayRate frames;
    OverlayRate ticks;
    gfx::DisplayListRef list;
};

PresentSettings settings;
PresentStats stats;
bool tick_shown = true;
PresentPacer      pacer;
Clock::time_point last_log;
FpsOverlay overlay;
std::int64_t counted_tick = 0;
int wait_start = 0;
int wait_frames = 0;

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
    const Clock::time_point now = Clock::now();
    overlay.frames.Count(now);

    if (settings.log_fps && now - last_log >= std::chrono::seconds(1)) {
        last_log = now;
        std::fprintf(stderr, "present: %s\n", PresentFpsText().c_str());
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

bool BetweenTicks(double fraction, Clock::time_point next_tick) {
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

} // namespace

bool PresentMouseActive() {
    return MenuMousePointerVisible() || MouseFixedActive(0);
}

void PresentSetSettings(const PresentSettings &value) {
    settings = value;
    overlay.on = value.show_fps;
}

const PresentSettings &PresentGetSettings() {
    return settings;
}

PresentStats PresentGetStats() {
    return stats;
}

void PresentResetStats() {
    stats = PresentStats{};
}

void PresentTickRendered() {
    const gfx::DisplayList *list = mgPortLastList();

    if (list == nullptr) {
        return;
    }

    ++stats.ticks;
    const gfx::DisplayListStats draws = gfx::ListStats(*list);
    stats.last_draws = draws.mesh_draws + draws.draws_2d;

    // Capped so a long stall does not replay an unbounded number of ticks into the rate window.
    const Clock::time_point now = Clock::now();
    const std::int64_t now_tick = ClockTickCount();

    for (std::int64_t t = counted_tick; t < now_tick && t < counted_tick + 16; ++t) {
        overlay.ticks.Count(now);
    }

    counted_tick = now_tick;
    tick_shown = false;
}

void PresentWaitFrame(int start, int frames) {
    wait_start = start;
    wait_frames = frames;
    mgTimeWaitTicks(start, frames, BetweenTicks);
}

void PresentTickEnd() {
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
    std::snprintf(piece, sizeof piece, "FPS %.1f", overlay.frames.PerSecond());
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
