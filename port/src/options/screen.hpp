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
constexpr int kPages = 5;
constexpr int kBindingsPage = kPages - 1;
constexpr int kTabStep = (kRight - kLeft) / kPages;

struct State {
    bool               open = false;
    int                page = 0;
    std::array<int, kPages> row{};
    std::array<int, kPages> first{};
    int                binding = -1;
    bool               save_failed = false;
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

Point PointerToUi(float x, float y, int window_width, int window_height, const gfx::LogicalMapping &mapping);
Point PointerPosition();
bool  Pointing();
// Handles PC options input and forwards retail Options cancel to the pad edge.
bool Run();
Hit  HitTest(const State &state, float x, float y);
void SelectPage(State &state, int page);
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
