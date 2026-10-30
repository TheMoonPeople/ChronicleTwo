#include "common.h"

#include <algorithm>
#include <cmath>
#include <string>
#include <utility>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "options/rows.hpp"
#include "options/screen.hpp"
#include "platform/display.hpp"
#include "platform/input.hpp"
#include "platform/input_script.hpp"
#include "platform/mouse.hpp"
#include "platform/window.hpp"
#include "snd_mngr.hpp"

extern CMenuOption *PortMenuOption asm("MenuOption_Current");

namespace options {

State g_screen;

namespace {

// MenuMouseSample button bits.
constexpr std::uint32_t kMouseLeft = 1;
constexpr std::uint32_t kMouseRight = 2;

Repeat        g_repeat;
bool          g_tracking = false;
bool          g_pointing = false;
float         g_pointer_x = 0;
float         g_pointer_y = 0;
std::uint32_t g_buttons = 0;
std::string   g_wait_source;
bool          g_drain = false;
// Frames a controller capture has waited; a pad has no Escape, so waiting cancels it.
int g_capture_frames = 0;

constexpr int kPadCaptureFrames = 5 * 60;

bool Inside(float x, float y, float left, float top, float right, float bottom) {
    return x >= left && x < right && y >= top && y < bottom;
}

const Row &CurrentRow() { return Pages()[g_screen.page].rows[g_screen.row[g_screen.page]]; }

void Save(const Config &config) {
    g_screen.save_failed = !DisplayApply([&] { return ConfigChange(config); });
}

void Change(int direction) {
    Config config = ConfigGet();
    if (StepRow(CurrentRow(), config, direction)) {
        Save(config);
        MenuSePlay(SYSTEM_SE_CURSOR);
    }
}

void BeginBinding() {
    g_screen.binding = g_screen.row[g_screen.page];
    g_capture_frames = 0;
    InputBeginBindCapture();
    MenuSePlay(SYSTEM_SE_DECIDE);
}

void Close() {
    g_screen.open = false;
    g_screen.binding = -1;
    g_wait_source.clear();
    // Swallow the closing click or held key so it cannot change a retail option underneath.
    g_drain = true;
    MenuSePlay(SYSTEM_SE_CANCEL);
}

void Open() {
    g_screen = {};
    g_screen.open = true;
    g_screen.save_failed = !ConfigSaved();
    ListResolutions();
    g_wait_source.clear();
    g_drain = true;
    MenuSePlay(SYSTEM_SE_DECIDE);
}

void Activate(const Hit &hit) {
    switch (hit.kind) {
        case HitKind::Entry:
            Open();
            break;
        case HitKind::Tab:
            SelectPage(g_screen, hit.index);
            break;
        case HitKind::Previous:
            SelectPage(g_screen, g_screen.page - 1);
            break;
        case HitKind::Next:
            SelectPage(g_screen, g_screen.page + 1);
            break;
        case HitKind::Row:
            g_screen.row[g_screen.page] = hit.index;
            if (!CurrentRow().action.empty()) {
                BeginBinding();
            } else {
                Change(hit.direction);
            }
            break;
        case HitKind::Back:
            Close();
            break;
        case HitKind::ResetBinding: {
            Config config = ConfigGet();
            if (CurrentRow().pad) {
                ResetPadBinding(config, CurrentRow().action);
            } else {
                ResetBinding(config, CurrentRow().action);
            }
            Save(config);
            break;
        }
        default:
            break;
    }
}

InputMenuMouse Pointer() {
    const auto &sample = MenuMouseTake();
    g_pointer_x = sample.x;
    g_pointer_y = sample.y;
    g_pointing = sample.pointing;
    // This page handles its own clicks; they must not also reach the retail Options screen as pad edges.
    MenuMouseSetButtons(0);
    return {.dx = sample.pointing && sample.moved ? 1.0f : 0.0f, .dy = 0, .wheel = sample.wheel, .buttons = sample.held};
}

void Track(bool on) {
    if (on == g_tracking) {
        return;
    }
    g_tracking = on;
    g_buttons = MenuMouseTake().held;
    g_repeat.Reset(GamePad__2.GetPadOn());
    g_drain = false;
    g_wait_source.clear();
    g_screen = {};
    g_pointing = false;
    const auto &sample = MenuMouseTake();
    g_pointer_x = sample.x;
    g_pointer_y = sample.y;
}

} // namespace

bool Capturing() { return g_screen.binding >= 0 || !g_wait_source.empty(); }

bool Run() {
    auto       mouse = Pointer();
    const auto pressed_mouse = MenuMouseTake().clicked & ~g_buttons;
    g_buttons = mouse.buttons;
    const auto held = static_cast<std::uint16_t>(GamePad__2.GetPadOn());
    const auto pressed = g_repeat.Step(held);
    if (auto saved = DisplayTakePumpSave()) {
        g_screen.save_failed = !*saved;
    }
    if (g_drain) {
        if (held == 0 && mouse.buttons == 0 && (g_wait_source.empty() || !InputBindSourceHeld(g_wait_source))) {
            g_drain = false;
            g_wait_source.clear();
            g_repeat.Reset();
        }
        return true;
    }
    const int cancel = LanguageCode > 0 ? PAD_CIRCLE : PAD_CROSS;
    const int confirm = LanguageCode > 0 ? PAD_CROSS : PAD_CIRCLE;
    if (pressed_mouse & kMouseRight) {
        if (g_screen.binding >= 0) {
            g_screen.binding = -1;
            g_drain = true;
        } else if (g_screen.open) {
            Close();
        } else {
            MenuMousePress(cancel);
        }
        return g_screen.open || g_drain;
    }
    if (g_screen.binding >= 0) {
        const auto point = PointerPosition();
        if ((pressed_mouse & kMouseLeft) && HitTest(g_screen, point.x, point.y).kind == HitKind::Back) {
            g_screen.binding = -1;
            g_drain = true;
            return true;
        }
        if (CurrentRow().pad) {
            // Every button is the binding's, Circle and Cross too: Escape, a right click, Back or a wait cancels.
            const std::string button = InputTakeBindPadButton();
            const std::string key = InputTakeBindKey(false);
            if (!button.empty()) {
                Config config = ConfigGet();
                if (SetPadBinding(config, CurrentRow().action, button)) {
                    Save(config);
                }
                g_screen.binding = -1;
                g_wait_source = "Gamepad:" + button;
                g_drain = true;
            } else if (key == "Escape" || ++g_capture_frames >= kPadCaptureFrames) {
                g_screen.binding = -1;
                g_drain = true;
            }
            return true;
        }
        const std::string key = InputTakeBindKey(false);
        if (!key.empty()) {
            Config config = ConfigGet();
            if (SetBinding(config, CurrentRow().action, key)) {
                Save(config);
            }
            g_screen.binding = -1;
            g_wait_source = key;
            g_drain = true;
        } else if (pressed & cancel) {
            g_screen.binding = -1;
            g_drain = true;
        }
        return true;
    }
    if (!g_screen.open) {
        if (pressed & PAD_SELECT) {
            Open();
            return true;
        }
    } else if (pressed != 0) {
        g_pointing = false;
        if (pressed & cancel) {
            Close();
            return true;
        }
        if (pressed & PAD_L1) {
            SelectPage(g_screen, g_screen.page - 1);
        } else if (pressed & PAD_R1) {
            SelectPage(g_screen, g_screen.page + 1);
        } else if (pressed & PAD_UP) {
            MoveRow(g_screen, -1);
        } else if (pressed & PAD_DOWN) {
            MoveRow(g_screen, 1);
        } else if (pressed & PAD_LEFT) {
            Change(-1);
        } else if (pressed & PAD_RIGHT) {
            Change(1);
        } else if (pressed & confirm) {
            if (!CurrentRow().action.empty()) {
                BeginBinding();
            } else {
                Change(1);
            }
        } else if ((pressed & PAD_SQUARE) && !CurrentRow().action.empty()) {
            Activate({.kind = HitKind::ResetBinding});
        }
    }
    const auto point = PointerPosition();
    const Hit  hit = HitTest(g_screen, point.x, point.y);
    NavigatePointer(g_screen, point, mouse.dx != 0 || mouse.dy != 0, mouse.wheel);
    if (pressed_mouse & kMouseLeft) {
        Activate(hit);
        if (g_screen.open) {
            return true;
        }
        if (!g_drain && PortMenuOption && MenuPosData &&
            MenuMouseOption(*PortMenuOption, MenuPosData->GetFormInfo(const_cast<char *>("Op_Switch")),
                            MenuPosData->GetFormInfo(const_cast<char *>("clip0")))) {
            MenuMousePress(confirm);
        }
    }
    return g_screen.open || g_drain;
}

Point PointerPosition() { return CurrentView(g_screen).ToPage({.x = g_pointer_x, .y = g_pointer_y}); }

bool Pointing() { return g_tracking && g_pointing; }

Point PointerToUi(float x, float y, int w, int h, const gfx::LogicalMapping &mapping) {
    if (w <= 0 || h <= 0 || mapping.scale_x <= 0 || mapping.scale_y <= 0) {
        return {.x = -1, .y = -1};
    }
    return {.x = (x * mapping.pixel_width / w - mapping.offset_x) / mapping.scale_x,
            .y = (y * mapping.pixel_height / h - mapping.offset_y) / mapping.scale_y};
}

Point View::ToUi(Point page) const {
    return {.x = centre_x + (page.x - centre_x) * scale, .y = centre_y + (page.y - centre_y) * scale};
}

Point View::ToPage(Point ui) const {
    return {.x = centre_x + (ui.x - centre_x) / scale, .y = centre_y + (ui.y - centre_y) / scale};
}

View FitView(const gfx::LogicalRect &bounds, const gfx::LogicalRect &visible, const gfx::LogicalRect &frame,
             float ui_scale) {
    View view{.centre_x = frame.x + frame.w / 2, .centre_y = frame.y + frame.h / 2, .scale = 1};
    if (!(ui_scale > 0) || frame.w <= 0 || frame.h <= 0) {
        return view;
    }
    // Each edge of bounds may sit as far from the centre as the visible edge on the same side.
    float      fit = ui_scale;
    const auto limit = [&](float centre, float edge, float low, float high) {
        const float room = edge > centre ? high - centre : centre - low;
        if (edge != centre) {
            fit = std::min(fit, std::max(0.0f, room / std::fabs(edge - centre)));
        }
    };
    limit(view.centre_x, bounds.x, visible.x, visible.x + visible.w);
    limit(view.centre_x, bounds.x + bounds.w, visible.x, visible.x + visible.w);
    limit(view.centre_y, bounds.y, visible.y, visible.y + visible.h);
    limit(view.centre_y, bounds.y + bounds.h, visible.y, visible.y + visible.h);
    if (fit > 0) {
        view.scale = fit / ui_scale;
    }
    return view;
}

View CurrentView(const State &state) {
    return FitView(state.open ? kPageBounds : kEntryBounds, gfx::VisibleLogicalRect(gfx::kMainTarget),
                   gfx::LogicalFrame(), gfx::CurrentFrameLayout().ui_scale);
}

Hit HitTest(const State &state, float x, float y) {
    if (state.binding >= 0) {
        return Inside(x, y, kLeft, 343, kLeft + 105, 370) ? Hit{.kind = HitKind::Back} : Hit{};
    }
    if (!state.open) {
        return Inside(x, y, 284, 51, 444, 76) ? Hit{.kind = HitKind::Entry} : Hit{};
    }
    for (int page = 0; page < kPages; ++page) {
        if (Inside(x, y, kLeft + page * kTabStep, 91, kLeft + (page + 1) * kTabStep, 114)) {
            return {.kind = HitKind::Tab, .index = page};
        }
    }
    if (Inside(x, y, kLeft, 343, kLeft + 105, 370)) {
        return {.kind = HitKind::Back};
    }
    if (BindingPage(state.page) && Inside(x, y, 272, 343, kRight, 370)) {
        return {.kind = HitKind::ResetBinding};
    }
    if (Inside(x, y, kLeft, kRowY, kRight, kRowY + kVisibleRows * kRowStep)) {
        int row = state.first[state.page] + static_cast<int>(y - kRowY) / kRowStep;
        if (std::cmp_less(row, Pages()[state.page].rows.size())) {
            return {.kind = HitKind::Row, .index = row, .direction = x < kValueX + 65 ? -1 : 1};
        }
    }
    return {};
}

bool SelectPage(State &state, int page) {
    const int previous = state.page;
    state.page = (page + kPages) % kPages;
    state.binding = -1;
    if (state.page == previous) {
        return false;
    }
    MenuSePlay(SYSTEM_SE_CURSOR);
    return true;
}

void MoveRow(State &state, int direction) {
    const int count = static_cast<int>(Pages()[state.page].rows.size());
    int      &row = state.row[state.page];
    row = std::clamp(row + direction, 0, count - 1);
    int &first = state.first[state.page];
    first = std::clamp(first, std::max(0, row - kVisibleRows + 1), row);
}

void NavigatePointer(State &state, Point point, bool moved, float wheel) {
    if (!state.open || state.binding >= 0) {
        return;
    }
    const auto hit = HitTest(state, point.x, point.y);
    if (moved && hit.kind == HitKind::Row) {
        state.row[state.page] = hit.index;
    }
    if (wheel != 0) {
        MoveRow(state, wheel > 0 ? -1 : 1);
    }
}

std::uint16_t Repeat::Step(std::uint16_t held) {
    std::uint16_t pressed = 0;
    for (int bit = 0; bit < 16; ++bit) {
        if (!(held & (1u << bit))) {
            frames_[bit] = 0;
            continue;
        }
        const int  frame = ++frames_[bit];
        const bool repeat = (1u << bit) & (PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT);
        if (frame == 1 || (repeat && frame >= 20 && (frame - 20) % 5 == 0)) {
            pressed |= 1u << bit;
        }
    }
    return pressed;
}

void Repeat::Reset(std::uint16_t held) {
    for (int bit = 0; bit < 16; ++bit) {
        frames_[bit] = held & (1u << bit) ? 1 : 0;
    }
}

} // namespace options

int MenuOptionKey() {
    // The original menu still owns opening, saving retail options, closing and all pad behavior.
    // SELECT is unused by its KeyStep; L1/R1 keep their retail page-scroll meaning there.
    const bool ready = PortMenuOption->mode == MENU_ASK_MODE_NONE && GetMenuMainFrameEndFlag() != 0;
    options::Track(ready);
    if (ready && options::Run()) {
        return 0;
    }
    const int finished = PortMenuOption->KeyStep();
    if (finished || PortMenuOption->mode == MENU_ASK_MODE_CLOSE) {
        options::Track(false);
    }
    return finished;
}

void MenuOptionDraw() {
    MenuPosData->FormDraw();
    if (PortMenuOption->mode == MENU_ASK_MODE_NONE) {
        options::Draw();
    }
}
