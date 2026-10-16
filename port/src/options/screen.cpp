#include "common.h"

#include <SDL3/SDL.h>

#include <algorithm>
#include <cmath>
#include <string>

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
Repeat        g_repeat;
bool          g_tracking = false;
bool          g_pointing = false;
float         g_pointer_x = 0;
float         g_pointer_y = 0;
std::uint32_t g_buttons = 0;
std::string   g_wait_source;
bool          g_drain = false;

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
    InputBeginBindCapture();
    MenuSePlay(SYSTEM_SE_DECIDE);
}

void Close() {
    g_screen.open = false;
    g_screen.binding = -1;
    g_wait_source.clear();
    g_drain = true;
    // Stay in menu-pointer mode until the retail Options screen finishes, so a closing click or
    // held key cannot change one of its options. Its pad state and settings are otherwise untouched.
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
            ResetBinding(config, CurrentRow().action);
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
    // This page handles its own hit regions, so a click must not also reach the
    // underlying retail Options screen through the shared synthetic pad edge.
    MenuMouseSetButtons(0);
    return {sample.pointing && sample.moved ? 1.0f : 0.0f, 0, sample.wheel, sample.held};
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
    if (pressed_mouse & 2) {
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
        if ((pressed_mouse & 1) && HitTest(g_screen, point.x, point.y).kind == HitKind::Back) {
            g_screen.binding = -1;
            g_drain = true;
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
            Activate({HitKind::ResetBinding});
        }
    }
    const auto point = PointerPosition();
    const Hit  hit = HitTest(g_screen, point.x, point.y);
    NavigatePointer(g_screen, point, mouse.dx != 0 || mouse.dy != 0, mouse.wheel);
    if (pressed_mouse & 1) {
        Activate(hit);
        if (g_screen.open) {
            return true;
        }
        if (!g_drain && PortMenuOption && MenuMouseOption(*PortMenuOption, MenuPosData ? MenuPosData->GetFormInfo(const_cast<char *>("Op_Switch")) : nullptr)) {
            MenuMousePress(confirm);
        }
    }
    return g_screen.open || g_drain;
}

Point PointerPosition() { return {g_pointer_x, g_pointer_y}; }

bool Pointing() { return g_tracking && g_pointing; }

Point PointerToUi(float x, float y, int w, int h, const gfx::LogicalMapping &mapping) {
    if (w <= 0 || h <= 0 || mapping.scale_x <= 0 || mapping.scale_y <= 0) {
        return {-1, -1};
    }
    return {(x * mapping.pixel_width / w - mapping.offset_x) / mapping.scale_x,
            (y * mapping.pixel_height / h - mapping.offset_y) / mapping.scale_y};
}

Hit HitTest(const State &state, float x, float y) {
    if (state.binding >= 0) {
        return Inside(x, y, kLeft, 343, kLeft + 105, 370) ? Hit{HitKind::Back} : Hit{};
    }
    if (!state.open) {
        return Inside(x, y, 284, 51, 444, 76) ? Hit{HitKind::Entry} : Hit{};
    }
    for (int page = 0; page < kPages; ++page) {
        if (Inside(x, y, kLeft + page * kTabStep, 91, kLeft + (page + 1) * kTabStep, 114)) {
            return {HitKind::Tab, page};
        }
    }
    if (Inside(x, y, kLeft, 343, kLeft + 105, 370)) {
        return {HitKind::Back};
    }
    if (state.page == kBindingsPage && Inside(x, y, 272, 343, kRight, 370)) {
        return {HitKind::ResetBinding};
    }
    if (Inside(x, y, kLeft, kRowY, kRight, kRowY + kVisibleRows * kRowStep)) {
        int row = state.first[state.page] + static_cast<int>(y - kRowY) / kRowStep;
        if (row < static_cast<int>(Pages()[state.page].rows.size())) {
            return {HitKind::Row, row, x < kValueX + 65 ? -1 : 1};
        }
    }
    return {};
}

void SelectPage(State &state, int page) {
    state.page = (page + kPages) % kPages;
    state.binding = -1;
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

PORT_OVERRIDE int MenuOptionKey() {
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

PORT_OVERRIDE void MenuOptionDraw() {
    MenuPosData->FormDraw();
    if (PortMenuOption->mode == MENU_ASK_MODE_NONE) {
        options::Draw();
    }
}
