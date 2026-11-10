#pragma once

#include <cstdint>
#include <span>

#include "menu_mouse_item.hpp"

class CMenuKeyFunc;

namespace menumouse {

// MenuInventCreateCardDraw's cards and the list's five visible rows.
inline constexpr float kCardWidth = 231, kCardPitch = 46;
inline constexpr int   kCardRows = 5;

// Cards are kCardPitch apart from the eased list origin. clip_top is the first visible row;
// rows outside the visible window cannot be hit.
int CardHit(Point p, Point list, float clip_top, int visible_rows, int count);

// The Make menu's card list and item board, as drawn this tick.
struct MakeLists {
    bool  items_front = false;          // The item board is the active pane.
    bool  cards = false, board = false; // Each pane is drawn and selectable.
    int   card_cursor = 0, card_top = 0, card_count = 0;
    int   item_cursor = 0, item_top = 0, item_count = 0;
    Point card_list;     // Eased origin of the first card.
    float card_clip = 0; // Top of the first visible card row.
    Point board_origin;  // Eased origin of the first bag cell.
    Rect  board_clip;    // Visible aperture of the item board.
    Point board_rest;    // Resting origin of the first bag cell at top line 0.
};

struct MakeListsResult {
    MakeLists state;
    int       buttons = 0;
    bool      sound = false; // A cursor move within the pane in front; a pane change sounds itself.
};

// Hover, click and wheel on the Make menu's two panes.
MakeListsResult MakeListsUpdate(const MakeLists &lists, Point p, bool moved, std::uint32_t clicked, float wheel);

// The quantity board's Make and Quit buttons, its arrows and the number between them.
struct MakeBoard {
    Rect make, quit, fewer, count, more;
};

// pos is the board form's position; info is MakeBoardDrawInfo as the board last drew it.
MakeBoard MakeBoardRects(Point pos, std::span<const float, 5> info) noexcept;

// The make row to select (0 Make, 1 Quit, -1 none) and the retail buttons for this tick.
struct MakeInput {
    int row = -1, buttons = 0;
};

MakeInput MakeBoardInput(const MakeBoard &board, Point p, bool moved, std::uint32_t clicked, float wheel);

} // namespace menumouse

// Called before the invention menu reads its retail navigation and action buttons.
void MenuMouseMakeTick(CMenuKeyFunc &keys);
