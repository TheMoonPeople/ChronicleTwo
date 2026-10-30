#include <algorithm>
#include <cmath>
#include <format>
#include <string>
#include <utility>

#include "font.hpp"
#include "mainloop.hpp"
#include "menudraw.hpp"
#include "options/rows.hpp"
#include "options/screen.hpp"
#include "platform/display.hpp"

namespace options {
namespace {

// The fitted view this frame's entry or page draws through. Layout and text measurement stay in
// page units; DrawScaledText and DrawScaledFill apply the view, once, as they draw.
View g_view;

// Font sizes round down, so scaled text stays inside the width it was measured against.
int FontSize(int size) { return std::max(1, static_cast<int>(size * g_view.scale)); }

void DrawScaledText(CFont &font, std::string &text, int x, int y, int size) {
    font.SetDrawSize(FontSize(size), FontSize(size + 4));
    font.SetClearance(FontSize(size), FontSize(size + 5));
    const Point at = g_view.ToUi({.x = static_cast<float>(x), .y = static_cast<float>(y)});
    font.DrawDirect(text.data(), static_cast<int>(std::lround(at.x)), static_cast<int>(std::lround(at.y)));
}

void DrawScaledFill(int x, int y, int w, int h, int alpha, int r, int g, int b) {
    const Point at = g_view.ToUi({.x = static_cast<float>(x), .y = static_cast<float>(y)});
    DrawMenuFillBox(at.x, at.y, w * g_view.scale, h * g_view.scale, alpha, r, g, b);
}

void Text(std::string text, int x, int y, int width, bool gold = false, int size = 16) {
    CFont font;
    font.SetDrawSize(size, size + 4);
    font.SetClearance(size, size + 5);
    font.SetFuchi(FUCHI_SHADOW_BLACK);
    font.SetColor(gold ? 128 : 118, gold ? 108 : 118, gold ? 64 : 118, 128);
    int w = 0;
    int h = 0;
    font.CalcDrawWH(text.data(), &w, &h);
    // Keep both custom values and lists of key bindings inside their own column.
    if (w > width) {
        while (text.size() > 3 && w > width) {
            text.pop_back();
            std::string shortened = text + "...";
            font.CalcDrawWH(shortened.data(), &w, &h);
        }
        text += "...";
    }
    DrawScaledText(font, text, x, y, size);
}

void Fill(int x, int y, int w, int h, int r, int g, int b) { DrawScaledFill(x, y, w, h, 128, r, g, b); }

void Plate(int x, int y, int width, int height, bool selected) {
    Fill(x, y, width, height, selected ? 108 : 65, selected ? 83 : 48, selected ? 38 : 28);
    Fill(x + 1, y + 1, width - 2, height - 2, selected ? 55 : 36, selected ? 42 : 27, selected ? 28 : 20);
    if (selected) {
        Fill(x + 2, y + height - 2, width - 4, 1, 124, 106, 66);
    }
}

// The page's ground over retail's Options contents.
void Backdrop() {
    Fill(72, 90, 366, 236, 18, 17, 16);
    Fill(48, 386, 420, 60, 18, 17, 16);
}

void Help(const std::string &help) {
    auto split = help.find('\n');
    Text(help.substr(0, split), 53, 389, 404, false, 14);
    if (split != std::string::npos) {
        Text(help.substr(split + 1), 53, 410, 404, false, 14);
    }
}

} // namespace

void Draw() {
    // Retail owns the textured background, gold frame, title and transitions. Cover only its
    // contents while on the PC page; no form or message state is rewritten.
    ResetMenuScissor();
    const auto &config = ConfigGet();
    const auto  point = PointerPosition();
    const auto  hit = Pointing() ? HitTest(g_screen, point.x, point.y) : Hit{};
    g_view = CurrentView(g_screen);
    if (g_screen.open && g_view.scale < 1) {
        // Drawn smaller than the UI scale, the page still covers retail's contents at the UI's size.
        const View page = std::exchange(g_view, View{});
        Backdrop();
        g_view = page;
    }
    if (!g_screen.open) {
        Plate(284, 51, 160, 25, hit.kind == HitKind::Entry);
        Text(ButtonName("select", config) + ": " + kPageTitle, 291, 54, 147, true, 13);
    } else {
        Backdrop();
        // The original scrollbar remains a useful track, with this page's own thumb and count.
        Fill(446, 98, 5, 225, 16, 13, 9);
        const auto &page = Pages()[g_screen.page];
        const int   count = static_cast<int>(page.rows.size());
        const int   first = g_screen.first[g_screen.page];
        const int   shown = std::min(kVisibleRows, count);
        const int   thumb_h = 221 * shown / count;
        const int   thumb_y = 100 + (count > shown ? (221 - thumb_h) * first / (count - shown) : 0);
        Fill(447, thumb_y, 3, thumb_h, 95, 67, 35);
        Text(kPageTitle, 83, 55, 190, true, 18);
        Text(std::format("{} / {}", g_screen.page + 1, Pages().size()), 385, 56, 60, false, 14);
        for (int p = 0; p < kPages; ++p) {
            const int  x = kLeft + p * kTabStep;
            const bool selected = p == g_screen.page;
            Plate(x, 91, kTabStep - 3, 23, selected || (hit.kind == HitKind::Tab && hit.index == p));
            Text(Pages()[p].name, x + 4, 93, kTabStep - 9, selected, 13);
        }
        for (int row = first; row < std::min(count, first + kVisibleRows); ++row) {
            int         y = kRowY + (row - first) * kRowStep;
            const auto &item = page.rows[row];
            const bool  selected = g_screen.row[g_screen.page] == row;
            if (selected) {
                Fill(kLeft - 6, y, kRight - kLeft + 6, 23, 42, 33, 23);
                Text(">", kLeft - 5, y + 1, 12, true, 14);
            }
            Text(item.label, kLeft + 8, y + 1, kValueX - kLeft - 18, false, 15);
            Plate(kValueX, y + 1, kRight - kValueX, 21, selected);
            std::string value;
            if (g_screen.binding == row) {
                value = item.pad ? "Press a button..." : "Press a key...";
            } else {
                value = item.value(config);
            }
            Text(value, kValueX + 15, y + 2, kRight - kValueX - 29, selected, 14);
            if (selected && item.step) {
                Text("<", kValueX + 3, y + 2, 10, true, 14);
                Text(">", kRight - 11, y + 2, 10, true, 14);
            }
        }
        Text(std::format("{}-{} of {}", first + 1, std::min(first + kVisibleRows, count), count),
             332, 314, 103, false, 12);
        Plate(kLeft, 343, 105, 27, hit.kind == HitKind::Back);
        Text(g_screen.binding >= 0 ? "Cancel capture" : "Back to Options", kLeft + 5, 348, 96, false, 12);
        if (BindingPage(g_screen.page) && g_screen.binding < 0) {
            Plate(272, 343, kRight - 272, 27, hit.kind == HitKind::ResetBinding);
            Text(ButtonName("square", config) + ": Restore binding", 278, 348, kRight - 284, false, 12);
        }
        if (g_screen.save_failed) {
            Help("Could not save config.json. Settings work this session.\nCheck the folder above the saves; change a setting to retry.");
        } else if (DisplayGetWarning() != DisplayWarning::None) {
            Help("The display could not apply that mode.\nThe setting shows the mode the window kept.");
        } else if (g_screen.binding >= 0 && g_screen.page == kPadBindingsPage) {
            Help("Press a controller button or trigger. Escape or five\nseconds cancels. A button another one has swaps.");
        } else if (g_screen.binding >= 0) {
            Help("Press a key or mouse button. Escape cancels.\nEscape is reserved and cannot be bound.");
        } else {
            Help(page.rows[g_screen.row[g_screen.page]].help);
        }
        const auto *const confirm = LanguageCode > 0 ? "cross" : "circle";
        const auto *const cancel = LanguageCode > 0 ? "circle" : "cross";
        const std::string shortcuts = g_screen.binding >= 0 ? "Escape: Cancel capture" : ButtonName("l1", config) + "/" + ButtonName("r1", config) + ": Page   " + ButtonName(confirm, config) + ": Change   " + ButtonName(cancel, config) + ": Back";
        Text(shortcuts, 53, 432, 404, true, 12);
    }
}

} // namespace options
