#pragma once

#include <cstdint>

#include "menu_mouse.hpp"

class CMenuKeyFunc;
class CMenuPosDataForm;

namespace menumouse {

struct Point {
    float x = 0, y = 0;
};

struct Rect {
    float              x = 0, y = 0, w = 0, h = 0;
    [[nodiscard]] bool Contains(Point p) const;
};

struct Target {
    int  panel = -1, cursor = -1;
    bool operator==(const Target &) const = default;

    explicit operator bool() const { return panel >= 0 && cursor >= 0; }
};

// Grid icons are 40 by 50 logical units. The origin follows the animated board;
// clip is its visible aperture, so rows sliding out cannot be selected.
Target GridHit(Point p, Point origin, Rect clip, int count);
int    ScrollTop(int top, int count, int visible_rows, float wheel);
// True when a bag cell's row is inside the target visible rows, not just the eased aperture.
bool  VisibleRow(int cursor, int top, int visible_rows);
Point FormPoint(CMenuPosDataForm *form, const char *part = nullptr);
// The item board's visible aperture for its form.
Rect ItemBoardClip(CMenuPosDataForm *board);
// Func_MenuItemBrdPosStep's resting origin of the bag's first cell at top line 0.
Point ItemBoardRest(CMenuPosDataForm *board);
// After a wheel scroll to top, the visible cell that settles under p, else the cursor kept within the visible rows.
Target WheelTarget(Point p, Point rest, Rect clip, int top, int count, int cursor);
// The bag cell under p on a drawn item board, or -1.
int BagHit(Point p, CMenuPosDataForm *board, int count);

struct Take {
    bool          pointing = false, moved = false;
    std::uint32_t pressed = 0, released = 0, held = 0;
    float         wheel = 0;
};

struct Pointer {
    Point pos;
    bool  pointing = false;
};

enum class Action {
    None,
    Click,
    PickUp,
    Drop,
    Cancel
};

struct Gesture {
    bool   pending = false, dragging = false, release_pending = false;
    Target source;
    Point  origin;
    void   Reset();
    Action Update(const Take &take, Point p, Target hit, bool can_pick_up, bool holding);
};
} // namespace menumouse

// Menu input is sampled at the retail menu's SelDataInit, once per menu tick.
// The pad latch clears synthetic presses and releases the channel after exit.
void MenuMouseUpdate(CMenuKeyFunc &keys);
void MenuMousePadTick();
void MenuMouseClose();

bool MenuMouseItemActive();
void MenuMouseItemOrigin(float &x, float &y);
// Where the pointer is on screen while it carries an item on the item page.
bool MenuMouseHeldItemAt(float &x, float &y);
