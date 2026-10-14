#include "common.h"

#include <algorithm>
#include <cstring>
#include <limits>
#include <utility>
#include <vector>

#include "drawwin.hpp"
#include "font.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "mg_drawprim.hpp"
#include "mglib_port.hpp"
#include "nd_meswin.hpp"

namespace {
int yesno_highlight = -1;
}

PORT_OVERRIDE void ClsMes::SetSelectCursorPos(RECT rect) {
    CalcSelectCursorPos(rect, &choice_pos[0][0]);
    yesno_highlight = window_mode == MES_WIN_YESNO && select >= 0 && select < 2 &&
                              fade >= 1 && alpha > 0 && buff && font_h > 0 && MenuMousePointerVisible()
                          ? select
                          : -1;
}

PORT_OVERRIDE void DrawYesNo(mgCDrawPrim *primitive, int yes_x, int yes_y, int no_x, int no_y, RGBAQ_TYPE *color) {
    const int selected = std::exchange(yesno_highlight, -1);
    for (int choice = 0; choice < 2; ++choice) {
        RGBAQ_TYPE tint = *color;
        // Brighten the mouse choice once, as retail costume selection does.
        if (choice == selected) {
            tint.r = tint.g = tint.b = 0xA4;
        }
        set2DSprite(primitive, {choice == 0 ? yes_x : no_x, choice == 0 ? yes_y : no_y, 60, 26},
                    {choice == 0 ? 136 : 196, 230, 60, 26}, &tint);
    }
}

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

PORT_OVERRIDE void ClsMes::StepSelectCursor(int steps) {
    if (select < 0) {
        cursor_time = 0;
        return;
    }
    SetGoalCursorXY();
    if (cursor_time <= 0) {
        cursor_x = goal_cursor_x;
        cursor_y = goal_cursor_y;
        cursor_time = 1;
    } else {
        for (int i = 0; i < steps; ++i) {
            cursor_x = (cursor_x + goal_cursor_x) / 2;
            cursor_y = (cursor_y + goal_cursor_y) / 2;
            ++cursor_time;
        }
    }
    if (fade < 1 || alpha <= 0 || !buff || font_h <= 0) {
        return;
    }
    const auto choices = MenuMouseMessageRows(*this, (text_h + font_h - 1) / font_h);
    if (std::cmp_less(select, choices.size())) {
        MenuMouseNoteChoices(this, mes_no, choices, select, window_mode == MES_WIN_YESNO);
    }
}

PORT_OVERRIDE void _set2DSprite(char *name, mgCDrawPrim *primitive, mgRect<int> destination,
                                mgRect<int> uv, RGBAQ_TYPE *color) {
    if (MesAbsDrawOff != 0) {
        return;
    }
    const bool         cursor = std::strcmp(name, "gaiji") == 0 && uv.left == 96 && uv.top == 232 &&
                                uv.right == 40 && uv.bottom == 24;
    gfx::Interp2DScope tag(cursor ? gfx::Interp2D{.key = MenuMouseNextHandKey(), .generation = static_cast<uint64_t>(mgPortFrameCount())} : gfx::CurrentInterp2D());
    primitive->Begin(MG_PRIM_SPRITE);
    MySetTex(name, primitive);
    if (cursor && (color->r || color->g || color->b)) {
        MenuMouseNoteHand(mgPortBinding(primitive->texture.tex0_bits, primitive->texture.tex1_bits),
                          {.x = static_cast<float>(uv.left), .y = static_cast<float>(uv.top), .w = static_cast<float>(uv.right), .h = static_cast<float>(uv.bottom)},
                          0, color->a);
    }
    set2DSpriteEasy(primitive, destination, uv, color);
    primitive->End();
}
