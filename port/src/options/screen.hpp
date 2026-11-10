#pragma once

#include <array>
#include <cstdint>

#include "gfx/gfx.hpp"

namespace options {

constexpr int kVisibleRows = 8;
constexpr int kRowY = 120;
constexpr int kRowStep = 24;
constexpr int kLeft = 82;
constexpr int kRight = 434;
constexpr int kValueX = 288;
constexpr int kPages = 6;
// The keyboard's and the controller's bindings, two sets apart.
constexpr int kBindingsPage = kPages - 2;
constexpr int kPadBindingsPage = kPages - 1;
constexpr int kTabStep = (kRight - kLeft) / kPages;

/**
 * Reports whether a page edits keyboard or controller bindings.
 */
constexpr bool BindingPage(int page) { return page == kBindingsPage || page == kPadBindingsPage; }

struct State {
    bool                    open = false;
    int                     page = 0;
    std::array<int, kPages> row{};
    std::array<int, kPages> first{};
    int                     binding = -1;
    bool                    save_failed = false;
};

enum class HitKind {
    None,
    Entry,
    Tab,
    Row,
    Previous,
    Next,
    Back,
    ResetBinding
};

struct Hit {
    HitKind kind = HitKind::None;
    int     index = -1;
    int     direction = 0;
};

struct Point {
    float x;
    float y;
};

// The PC SETTINGS entry and page, in UI units with a 4-unit margin.
constexpr gfx::LogicalRect kEntryBounds{.x = 280, .y = 47, .w = 168, .h = 33};
constexpr gfx::LogicalRect kPageBounds{.x = 44, .y = 51, .w = 428, .h = 401};

// Places the page's coordinates in UI space: scaled by scale about the logical frame's centre, which
// is also where the UI scale scales from.
struct View {
    float centre_x = 0;
    float centre_y = 0;
    float scale = 1;

    [[nodiscard]] Point ToUi(Point page) const;
    [[nodiscard]] Point ToPage(Point ui) const;
};

Point PointerToUi(float x, float y, int window_width, int window_height, const gfx::LogicalMapping &mapping);
// The largest view, up to the UI's own size, that keeps bounds inside visible (logical units) at
// ui_scale, so every UI scale leaves this page whole and reachable.
View FitView(const gfx::LogicalRect &bounds, const gfx::LogicalRect &visible, const gfx::LogicalRect &frame,
             float ui_scale);
// The view for the entry or the open page on the main target's current layout.
View CurrentView(const State &state);
// The pointer in page coordinates.
Point PointerPosition();
bool  Pointing();
// Handles PC options input and forwards retail Options cancel to the pad edge.
bool Run();
/**
 * Reports whether binding capture or release of a newly bound input is pending.
 */
bool Capturing();
Hit  HitTest(const State &state, float x, float y);
// Shows a tab, wrapping at either end; a change of tab plays the retail cursor sound and returns true.
bool SelectPage(State &state, int page);
void MoveRow(State &state, int direction);
void NavigatePointer(State &state, Point point, bool moved, float wheel);

// Raw held-button repeat is independent of the retail menu's repeat bookkeeping.
class Repeat {
public:
    std::uint16_t Step(std::uint16_t held);
    void          Reset(std::uint16_t held = 0);

private:
    std::array<int, 16> frames_{};
};

extern State g_screen;
void         Draw();

} // namespace options
