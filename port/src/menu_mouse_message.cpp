#include "common.h"

#include <algorithm>
#include <limits>
#include <vector>

#include "font.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "nd_meswin.hpp"

std::vector<MenuMouseRect> MenuMouseMessageRows(ClsMes &message, int count) {
    std::vector<MenuMouseRect> choices;
    if (message.font_h <= 0) {
        return choices;
    }
    if (message.window_mode == MES_WIN_YESNO) {
        for (int i = 0; i < 2; ++i) {
            const auto &choice = message.choice_pos[i];
            const int   spacing = message.choice_pos[1 - i][0] - choice[0];
            const float width = static_cast<float>(spacing > 0 ? std::min(72, spacing) : 72);
            choices.push_back(choice[0] >= 0 && choice[1] >= 0 ? MenuMouseRect{.x = static_cast<float>(choice[0] - 4), .y = static_cast<float>(choice[1] - 4), .w = width, .h = 32} : MenuMouseRect{});
        }
    } else {
        int dx = 0;
        int dy = 0;
        message.CalcCenteringXY(&dx, &dy);
        for (int i = 0; i < std::clamp(count, 0, static_cast<int>(MES_LINE_MAX)); ++i) {
            // DrawFont offsets every line, placed or flowing, by draw_off.
            const float x = (message.line_pos_on[i] ? message.line_pos[i][0] : message.text_x + dx) + message.draw_off_x;
            const float y = (message.line_pos_on[i] ? message.line_pos[i][1] : message.text_y + dy + message.font_h * i) + message.draw_off_y;
            choices.push_back(i >= message.select_top ? MenuMouseRect{.x = x, .y = y, .w = static_cast<float>(std::max({message.text_w, message.line_w[i], 60})), .h = static_cast<float>(message.font_h)} : MenuMouseRect{});
        }
    }
    return choices;
}

namespace {
// The gaiji symbols of the face buttons, as Japanese draws them.
constexpr int kGaijiCircle = GAIJI_CODE_TOP + 6;
constexpr int kGaijiTriangle = GAIJI_CODE_TOP + 7;
constexpr int kGaijiCross = GAIJI_CODE_TOP + 8;
constexpr int kGaijiSquare = GAIJI_CODE_TOP + 9;

// The laid-out characters of one drawn line, first to last.
template <class Each>
void LineGlyphs(const ClsMes &message, int line, Each each) {
    if (message.font_h <= 0 || line < 0 || line >= MES_LINE_MAX || message.line_shade[line] == MES_SHADE_HIDDEN) {
        return;
    }
    for (int i = std::max(0, message.page_top); i < std::min(message.reveal_num, static_cast<int>(MES_WIN_TBL_MAX)); ++i) {
        if (message.tbl[i].y / message.font_h == line) {
            each(message.tbl[i]);
        }
    }
}
} // namespace

int MenuMouseLabelButton(const ClsMes &message, int line) {
    int code = 0;
    LineGlyphs(message, line, [&](const MES_WIN_TBL &glyph) {
        if (code == 0 && glyph.code >= GAIJI_CODE_TOP && glyph.code < GAIJI_CODE_END) {
            code = glyph.code;
        }
    });
    // DrawGaiji_sub draws the Circle and Cross symbols swapped outside Japanese.
    const bool swapped = LanguageCode != LANG_JAPANESE;
    switch (code) {
        case kGaijiCircle:
            return swapped ? PAD_CROSS : PAD_CIRCLE;
        case kGaijiTriangle:
            return PAD_TRIANGLE;
        case kGaijiCross:
            return swapped ? PAD_CIRCLE : PAD_CROSS;
        case kGaijiSquare:
            return PAD_SQUARE;
        default:
            return 0;
    }
}

MenuMouseRect MenuMouseLabelRect(const ClsMes &message, int line) {
    int left = std::numeric_limits<int>::max();
    int right = std::numeric_limits<int>::min();
    if (line >= 0 && line < MES_LINE_MAX && message.line_pos_on[line]) {
        LineGlyphs(message, line, [&](const MES_WIN_TBL &glyph) {
            left = std::min<int>(left, glyph.x);
            right = std::max<int>(right, glyph.x);
        });
    }
    if (left > right) {
        return {};
    }
    // DrawFont puts a placed line's characters at line_pos plus their own offsets and draw_off.
    const float x = static_cast<float>(message.line_pos[line][0] + left) + message.draw_off_x;
    const float y = static_cast<float>(message.line_pos[line][1]) + message.draw_off_y;
    return {.x = x - 2, .y = y - 6, .w = static_cast<float>(right - left + message.font_w + 4), .h = static_cast<float>(message.font_h + 12)};
}
