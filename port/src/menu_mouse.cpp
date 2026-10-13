#include "menu_mouse.hpp"

#include <SDL3/SDL.h>

#include <algorithm>
#include <cmath>
#include <vector>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse_item.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "platform/window.hpp"

namespace {
bool            enabled = false, closing = false;
int             frame = -1, buttons = 0, rows_frame = -1;
std::uint32_t   held = 0;
MenuMouseSample sample;
bool            navigation = false;
double          wheel_remainder = 0;
int             hand_frame = -1;
unsigned        hand_index = 0;

struct Hand {
    gfx::InterpKey      key = 0;
    gfx::TextureBinding texture;
    gfx::LogicalRect    uv{};
    float               rotation = 0, scale = 1;
    int                 reverse = 0, alpha = 128, seen = -100;
} hand;

struct Choices {
    const void                *owner = nullptr;
    int                        message = -1, drawn = -100, selected = -1, target = -1, ready = 0;
    bool                       horizontal = false, confirm = false;
    std::vector<MenuMouseRect> rows;
} choices;

struct ListClick {
    const void *owner = nullptr;
    int         seen = -100, ready = 0, target = -1;
    bool        pending = false;
} list_click;

void SetCapture(bool on);

} // namespace

bool MenuMouseRect::Contains(float px, float py) const {
    return px >= x && px < x + w && py >= y && py < y + h;
}

float MenuMouseUnits(float scale, float pixels, float window) {
    return scale > 0 && pixels > 0 && window > 0 ? pixels / (scale * window) : 1;
}

int MenuMouseHit(std::span<const MenuMouseRect> rows, float x, float y) {
    for (int i = 0; i < static_cast<int>(rows.size()); ++i) {
        if (rows[i].Contains(x, y)) {
            return i;
        }
    }
    return -1;
}

int MenuMouseChoose(const MenuMouseSample &mouse, std::span<const MenuMouseRect> rows, int selected, int wheel_step) {
    if (!mouse.pointing || rows.empty()) {
        return selected;
    }
    const int hit = MenuMouseHit(rows, mouse.x, mouse.y);
    if (hit >= 0 && (mouse.moved || (mouse.clicked & 1))) {
        selected = hit;
    }
    if (mouse.wheel != 0 && std::isfinite(mouse.wheel)) {
        selected = std::clamp(selected + (-static_cast<int>(std::clamp(mouse.wheel, -32.0f, 32.0f)) * wheel_step), 0, static_cast<int>(rows.size()) - 1);
    }
    return selected;
}

namespace {
bool PadOrFocusOwnsPointer() {
    const auto &pad = InputGetPad(0);
    WindowMode  mode;
    // Headless scripts have no native cursor/capture owner. A real window must
    // release the pointer immediately when capture or input focus is lost.
    const bool inactive = WindowCurrentMode(mode) &&
                          (!MouseInputLive() || !(SDL_GetWindowFlags(WindowHandle()) & SDL_WINDOW_INPUT_FOCUS));
    return inactive || pad.buttons || GamePad__2.pad[0].button ||
           std::abs(int(pad.left_x) - 128) > 30 || std::abs(int(pad.left_y) - 128) > 30;
}

void MovePointer(MenuMouseSample &point, float dx, float dy) {
    const auto extent = mgPortVisibleExtent(gfx::kMainTarget);
    float      left = extent.left, top = extent.top, right = extent.right, bottom = extent.bottom;
    float      units_x = 1, units_y = 1;
    if (mgPortRendererReady()) {
        const auto mapping = gfx::GetUiMapping(gfx::kMainTarget);
        const auto scene = gfx::GetLogicalMapping(gfx::kMainTarget);
        int        width = static_cast<int>(mapping.pixel_width), height = static_cast<int>(mapping.pixel_height);
        WindowSize(width, height);
        units_x = MenuMouseUnits(mapping.scale_x, mapping.pixel_width, width);
        units_y = MenuMouseUnits(mapping.scale_y, mapping.pixel_height, height);
        left = (extent.left * scene.scale_x + scene.offset_x - mapping.offset_x) / mapping.scale_x;
        right = (extent.right * scene.scale_x + scene.offset_x - mapping.offset_x) / mapping.scale_x;
        top = (extent.top * scene.scale_y + scene.offset_y - mapping.offset_y) / mapping.scale_y;
        bottom = (extent.bottom * scene.scale_y + scene.offset_y - mapping.offset_y) / mapping.scale_y;
    }
    if (std::isfinite(dx)) {
        point.x += dx * units_x;
    }
    if (std::isfinite(dy)) {
        point.y += dy * units_y;
    }
    point.x = std::clamp(point.x, left, right - 1);
    point.y = std::clamp(point.y, top, bottom - 1);
}

void SetCapture(bool on) {
    if (enabled == on) {
        return;
    }
    enabled = on;
    hand = {};
    wheel_remainder = 0;
    MouseSetPointerCursor(false);
    if (on) {
        closing = false;
        InputSetMenuMouse(true);
        held = InputTakeMenuMouse().buttons;
    } else {
        closing = true;
    }
    sample = {};
    sample.x = mgScreenWidth * 0.5f;
    sample.y = mgScreenHeight * 0.5f;
    frame = rows_frame = -1;
    buttons = 0;
}

} // namespace

void MenuMouseEnable(bool on) {
    navigation = on;
    choices = {};
    list_click = {};
    SetCapture(on);
}

void MenuMouseNoteChoices(const void *owner, int message, std::span<const MenuMouseRect> rows, int selected, bool horizontal) {
    if (choices.owner != owner || choices.message != message || choices.drawn < mgPortFrameCount() - 1) {
        choices.target = selected;
        choices.confirm = false;
    }
    if (choices.selected != selected) {
        choices.ready = mgPortFrameCount() + 6;
    }
    choices.owner = owner;
    choices.message = message;
    choices.drawn = mgPortFrameCount();
    choices.selected = selected;
    choices.horizontal = horizontal;
    choices.rows.assign(rows.begin(), rows.end());
    if (!enabled) {
        SetCapture(true);
    }
}

const MenuMouseSample &MenuMouseTake() {
    if (!navigation && enabled && choices.drawn < mgPortFrameCount() - 1) {
        SetCapture(false);
    }
    if ((!enabled && !closing) || frame == mgPortFrameCount()) {
        return sample;
    }
    frame = mgPortFrameCount();
    const auto mouse = InputTakeMenuMouse();
    if (closing) {
        buttons = 0;
        if (mouse.buttons == 0) {
            closing = false;
            InputSetMenuMouse(false);
        }
        return sample;
    }
    sample.clicked = mouse.buttons & ~held;
    sample.released = held & ~mouse.buttons;
    sample.held = mouse.buttons;
    held = mouse.buttons;
    if (std::isfinite(mouse.wheel)) {
        wheel_remainder += mouse.wheel;
    }
    wheel_remainder = std::clamp(wheel_remainder, -32.0, 32.0);
    sample.wheel = std::trunc(wheel_remainder);
    wheel_remainder -= sample.wheel;
    sample.moved = mouse.dx != 0 || mouse.dy != 0;
    if (PadOrFocusOwnsPointer()) {
        sample.pointing = false;
        sample.clicked = sample.released = 0;
        sample.wheel = 0;
        wheel_remainder = 0;
        buttons = 0;
        choices.confirm = false;
        choices.target = choices.selected;
        return sample;
    }
    if (!sample.pointing) {
        choices.confirm = false;
        choices.target = choices.selected;
        if (sample.moved || sample.clicked || sample.wheel != 0) {
            MenuMouseItemOrigin(sample.x, sample.y);
        }
    }
    if (sample.moved || sample.clicked || sample.wheel != 0) {
        sample.pointing = true;
    }
    MovePointer(sample, mouse.dx, mouse.dy);
    if (MenuMouseItemActive()) {
        buttons = 0;
        choices.confirm = false;
        return sample;
    }
    buttons = (sample.clicked & 1 ? PAD_CROSS : 0) | (sample.clicked & 2 ? PAD_CIRCLE : 0);
    if (choices.drawn >= frame - 1 && !choices.rows.empty()) {
        buttons &= ~PAD_CROSS;
        if (sample.pointing) {
            const int hit = MenuMouseHit(choices.rows, sample.x, sample.y);
            if (hit >= 0 && (sample.moved || (sample.clicked & 1))) {
                choices.target = hit;
            }
            if (sample.wheel != 0 && std::isfinite(sample.wheel)) {
                int target = choices.selected + -static_cast<int>(sample.wheel);
                if (target >= 0 && target < static_cast<int>(choices.rows.size()) && choices.rows[target].w > 0) {
                    choices.target = target;
                }
            }
            if ((sample.clicked & 1) && hit >= 0) {
                choices.confirm = true;
            }
            if (sample.clicked & 2) {
                choices.confirm = false;
            }
            if (choices.target != choices.selected) {
                buttons |= choices.horizontal ? (choices.target < choices.selected ? PAD_LEFT : PAD_RIGHT) : (choices.target < choices.selected ? PAD_UP : PAD_DOWN);
            } else if (choices.confirm && frame >= choices.ready) {
                buttons |= PAD_CROSS;
                choices.confirm = false;
            }
        }
    }
    return sample;
}

int MenuMouseButtons() {
    MenuMouseTake();
    return enabled ? buttons : 0;
}

void MenuMousePress(int mask) {
    if (mask & PAD_START) {
        buttons &= ~PAD_CROSS;
    }
    buttons |= mask;
}

int MenuMouseRows(std::span<const MenuMouseRect> rows, int selected, int wheel_step) {
    const auto &mouse = MenuMouseTake();
    if (rows_frame == frame) {
        return selected;
    }
    rows_frame = frame;
    if (mouse.clicked & 1) {
        buttons &= ~PAD_CROSS;
        if (mouse.pointing && MenuMouseHit(rows, mouse.x, mouse.y) >= 0) {
            buttons |= PAD_CROSS;
        }
    }
    return MenuMouseChoose(mouse, rows, selected, wheel_step);
}

void MenuMouseDelayConfirm(const void *owner, int selected, int target, int ticks) {
    if (list_click.owner != owner || list_click.seen < frame - 1) {
        list_click = {owner, frame, frame, selected, false};
    }
    list_click.seen = frame;
    if (target != list_click.target) {
        list_click.target = target;
        list_click.pending = false;
    }
    if (target != selected) {
        list_click.ready = frame + ticks;
    }
    if (buttons & PAD_CROSS) {
        list_click.pending = true;
    }
    buttons &= ~PAD_CROSS;
    if ((buttons & PAD_CIRCLE) || !sample.pointing) {
        list_click.pending = false;
    }
    if (list_click.pending && target == selected && frame >= list_click.ready) {
        buttons |= PAD_CROSS;
        list_click.pending = false;
    }
}

MenuMouseSample MenuMouseDisplaySample() {
    auto point = sample;
    if (!enabled || PadOrFocusOwnsPointer()) {
        sample.pointing = false;
        point.pointing = false;
        return point;
    }
    float dx = 0, dy = 0;
    InputPeekMenuMouseMotion(dx, dy);
    if (dx != 0 || dy != 0) {
        if (!point.pointing) {
            MenuMouseItemOrigin(point.x, point.y);
        }
        point.pointing = true;
    }
    MovePointer(point, dx, dy);
    return point;
}

gfx::InterpKey MenuMouseNextHandKey() {
    if (hand_frame != mgPortFrameCount()) {
        hand_frame = mgPortFrameCount();
        hand_index = 0;
    }
    return kMenuMouseHandKey + hand_index;
}

gfx::InterpKey MenuMouseReplacedHandKey() { return MenuMousePointerVisible() ? hand.key : 0; }

gfx::InterpKey MenuMouseNoteHand(const gfx::TextureBinding &texture, gfx::LogicalRect uv,
                                 float rotation, int reverse, int alpha, float scale) {
    if (texture.texture == gfx::kNullTexture) {
        return 0;
    }
    const auto key = MenuMouseNextHandKey();
    ++hand_index;
    if (enabled) {
        hand = {key, texture, uv, rotation, scale, reverse, alpha, mgPortFrameCount()};
    }
    return key;
}

bool MenuMousePointerVisible() {
    return enabled && hand.texture.texture != gfx::kNullTexture &&
           hand.seen >= mgPortFrameCount() - 1 && MenuMouseDisplaySample().pointing;
}

void MenuMouseDraw() {
    const bool visible = MenuMousePointerVisible();
    MouseSetPointerCursor(visible);
    if (!visible) {
        return;
    }
    const auto     point = MenuMouseDisplaySample();
    gfx::DrawState state{};
    state.blend = true;
    state.alpha_test = true;
    state.alpha_func = gfx::AlphaFunc::Greater;
    const float c = std::cos(hand.rotation), s = std::sin(hand.rotation);
    const float sign = hand.reverse ? -1 : 1;
    // The pointing fingertip is at the far edge, halfway down the hand's atlas cell.
    const float   tip_x = sign * hand.uv.w * hand.scale;
    const float   tip_y = hand.uv.h * hand.scale * 0.5f;
    const float texture_scale = mgPortTextureScale(hand.texture.texture);
    gfx::Vertex2D vertices[4]{};
    for (int i = 0; i < 4; ++i) {
        const float x = (i & 1 ? tip_x : 0) - tip_x;
        const float y = (i & 2 ? hand.uv.h * hand.scale : 0) - tip_y;
        auto       &v = vertices[i];
        v.x = point.x + x * c - y * s;
        v.y = point.y + x * s + y * c;
        v.u = (hand.uv.x + (i & 1 ? hand.uv.w : 0)) * texture_scale;
        v.v = (hand.uv.y + (i & 2 ? hand.uv.h : 0)) * texture_scale;
        v.color[0] = v.color[1] = v.color[2] = 128;
        v.color[3] = static_cast<uint8_t>(hand.alpha);
    }
    gfx::Draw2D(gfx::Primitive::TriangleStrip, vertices, hand.texture, state);
}

void MenuMouseSetButtons(int mask) { buttons = mask; }

bool MenuMouseActive() { return enabled; }
