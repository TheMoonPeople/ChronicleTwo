#include "menu_mouse.hpp"

#include <SDL3/SDL.h>

#include <algorithm>
#include <cmath>
#include <cstring>
#include <utility>
#include <vector>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse_item.hpp"
#include "menudraw.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "platform/window.hpp"

namespace {
bool            enabled = false, closing = false;
int             frame = -1, buttons = 0, rows_frame = -1, language_frame = -1;
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
    int                 alpha = 128, seen = -100;
} hand;

struct Choices {
    const void                *owner = nullptr;
    int                        message = -1, drawn = -100, selected = -1, target = -1, ready = 0;
    bool                       horizontal = false, confirm = false;
    std::vector<MenuMouseRect> rows;
} choices;

// Choice windows drawn in the last two ticks: the tick each first appeared, the order it was first
// drawn in, and the tick it was last drawn.
struct ShownChoices {
    const void *owner;
    int         message, first, order, last;
};

std::vector<ShownChoices> shown_choices;
int                       shown_order = 0;

struct ListClick {
    const void *owner = nullptr;
    int         seen = -100, ready = 0, target = -1;
    bool        pending = false;
} list_click;
} // namespace

bool MenuMouseRect::Contains(float px, float py) const {
    return px >= x && px < x + w && py >= y && py < y + h;
}

float MenuMouseUnits(float scale, float pixels, float window) {
    return scale > 0 && pixels > 0 && window > 0 ? pixels / (scale * window) : 1;
}

int MenuMouseHit(std::span<const MenuMouseRect> rows, float x, float y) {
    for (int i = 0; std::cmp_less(i, rows.size()); ++i) {
        if (rows[i].Contains(x, y)) {
            return i;
        }
    }
    return -1;
}

MenuMouseRect MenuMouseClip(MenuMouseRect rect, MenuMouseRect clip) {
    const float left = std::max(rect.x, clip.x);
    const float top = std::max(rect.y, clip.y);
    const float right = std::min(rect.x + rect.w, clip.x + clip.w);
    const float bottom = std::min(rect.y + rect.h, clip.y + clip.h);
    return right > left && bottom > top ? MenuMouseRect{.x = left, .y = top, .w = right - left, .h = bottom - top} : MenuMouseRect{};
}

int MenuMouseChoose(const MenuMouseSample &mouse, std::span<const MenuMouseRect> rows, int selected, int wheel_step) {
    if (!mouse.pointing || rows.empty()) {
        return selected;
    }
    const int hit = MenuMouseHit(rows, mouse.x, mouse.y);
    if (hit >= 0 && (mouse.clicked & 1)) {
        return hit; // A click confirms the row it was pressed on; a wheel notch in the same sample is dropped.
    }
    if (hit >= 0 && mouse.moved) {
        selected = hit;
    }
    return MenuMouseWheelStep(selected, mouse.wheel, static_cast<int>(rows.size()), wheel_step);
}

int MenuMouseWheelStep(int selected, float wheel, int count, int wheel_step) {
    if (wheel == 0 || !std::isfinite(wheel) || count <= 0) {
        return selected;
    }
    return std::clamp(selected + (-static_cast<int>(std::clamp(wheel, -32.0f, 32.0f)) * wheel_step), 0, count - 1);
}

MENUFORMPARTS_TYPE *MenuMouseFindPart(CMenuPosDataForm *form, const char *name) {
    if (!form || !name) {
        return nullptr;
    }
    for (int i = 0; i < form->parts_num; ++i) {
        if (form->parts[i].name && std::strcmp(form->parts[i].name, name) == 0) {
            return &form->parts[i];
        }
    }
    return nullptr;
}

MenuMouseRect MenuMousePart(CMenuPosDataForm *form, const char *name) {
    if (!form || !form->draw_flag) {
        return {};
    }
    auto *part = MenuMouseFindPart(form, name);
    if (!part || !part->draw_flag) {
        return {};
    }
    float x = 0;
    float y = 0;
    form->GetPutPosXY(part->name, x, y);
    return {.x = x, .y = y, .w = part->w, .h = part->h};
}

MenuMouseView MenuMouseScroll(float wheel, MenuMouseView view, int count, int visible, int hovered) {
    if (wheel == 0 || !std::isfinite(wheel) || count <= 0 || visible <= 0) {
        return view;
    }
    const int notches = static_cast<int>(std::clamp(wheel, -32.0f, 32.0f));
    view.top = std::clamp(view.top - notches, 0, std::max(0, count - visible));
    if (hovered >= 0 && view.top + hovered < count) {
        view.selected = view.top + hovered;
    } else {
        view.selected = std::clamp(view.selected, view.top, std::min(count, view.top + visible) - 1);
    }
    return view;
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
           std::abs(static_cast<int>(pad.left_x) - 128) > 30 || std::abs(static_cast<int>(pad.left_y) - 128) > 30;
}

void MovePointer(MenuMouseSample &point, float dx, float dy) {
    const auto extent = mgPortVisibleUiExtent(gfx::kMainTarget);
    float      units_x = 1;
    float      units_y = 1;
    if (mgPortRendererReady()) {
        const auto mapping = gfx::GetUiMapping(gfx::kMainTarget);
        int        width = static_cast<int>(mapping.pixel_width);
        int        height = static_cast<int>(mapping.pixel_height);
        WindowSize(width, height);
        units_x = MenuMouseUnits(mapping.scale_x, mapping.pixel_width, width);
        units_y = MenuMouseUnits(mapping.scale_y, mapping.pixel_height, height);
    }
    if (std::isfinite(dx)) {
        point.x += dx * units_x;
    }
    if (std::isfinite(dy)) {
        point.y += dy * units_y;
    }
    point.x = std::clamp(point.x, extent.left, extent.right - 1);
    point.y = std::clamp(point.y, extent.top, extent.bottom - 1);
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
    frame = rows_frame = language_frame = -1;
    buttons = 0;
}

} // namespace

void MenuMouseEnable(bool on) {
    navigation = on;
    choices = {};
    shown_choices.clear();
    list_click = {};
    SetCapture(on);
}

void MenuMouseNoteChoices(const void *owner, int message, std::span<const MenuMouseRect> rows, int selected, bool horizontal) {
    // A question can open over a list that still draws its cursor (Cedric's repair question over his
    // commands). The newest window takes the mouse; alternating between them would drop every click.
    const int now = mgPortFrameCount();
    std::erase_if(shown_choices, [&](const ShownChoices &window) { return window.last < now - 1; });
    auto window = std::ranges::find_if(shown_choices, [&](const ShownChoices &shown) {
        return shown.owner == owner && shown.message == message;
    });
    if (window == shown_choices.end()) {
        shown_choices.push_back({.owner = owner, .message = message, .first = now, .order = ++shown_order, .last = now});
        window = shown_choices.end() - 1;
    }
    window->last = now;
    // Windows that appear in one tick rank by first draw: the later one is on top. The ranking holds
    // until a window closes, whatever order later redraws take.
    const ShownChoices mine = *window;
    if (std::ranges::any_of(shown_choices, [&](const ShownChoices &shown) {
            return shown.first > mine.first || (shown.first == mine.first && shown.order > mine.order);
        })) {
        return;
    }
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
                if (target >= 0 && std::cmp_less(target, choices.rows.size()) && choices.rows[target].w > 0) {
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

int MenuMouseLanguageButtons(int mask, int language) {
    // Only a lone Cross or Circle swaps; both together stay as they are.
    const bool lone = ((mask & PAD_CROSS) != 0) != ((mask & PAD_CIRCLE) != 0);
    return language == LANG_JAPANESE && lone ? mask ^ (PAD_CROSS | PAD_CIRCLE) : mask;
}

void MenuMouseLanguageClicks() {
    MenuMouseTake();
    // Adapters can run more than once a tick; swap this tick's clicks once.
    if (language_frame != frame) {
        language_frame = frame;
        buttons = MenuMouseLanguageButtons(buttons, LanguageCode);
    }
}

void MenuMouseDelayConfirm(const void *owner, int selected, int target, int ticks) {
    if (list_click.owner != owner || list_click.seen < frame - 1) {
        list_click = {.owner = owner, .seen = frame, .ready = frame, .target = selected, .pending = false};
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
    float dx = 0;
    float dy = 0;
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
                                 float rotation, int alpha, float scale) {
    if (texture.texture == gfx::kNullTexture) {
        return 0;
    }
    const auto key = MenuMouseNextHandKey();
    ++hand_index;
    if (enabled) {
        hand = {.key = key, .texture = texture, .uv = uv, .rotation = rotation, .scale = scale, .alpha = alpha, .seen = mgPortFrameCount()};
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
    const float c = std::cos(hand.rotation);
    const float s = std::sin(hand.rotation);
    // The pointing fingertip is at the far edge, halfway down the hand's atlas cell. The hand is
    // never mirrored, so its body stays on the same side of the hotspot on every target.
    const float   tip_x = hand.uv.w * hand.scale;
    const float   tip_y = hand.uv.h * hand.scale * 0.5f;
    const float   texture_scale = mgPortTextureScale(hand.texture.texture);
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

void MenuMouseClaimButtons(int mask) {
    buttons = mask;
    choices.target = choices.selected;
    choices.confirm = false;
}
