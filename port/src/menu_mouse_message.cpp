#include "common.h"

#include <algorithm>
#include <climits>
#include <cstring>
#include <vector>

#include "font.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "mg_drawprim.hpp"
#include "mglib_port.hpp"
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
            const float width = float(spacing > 0 ? std::min(72, spacing) : 72);
            choices.push_back(choice[0] >= 0 && choice[1] >= 0 ? MenuMouseRect{float(choice[0] - 4), float(choice[1] - 4), width, 32} : MenuMouseRect{});
        }
    } else {
        int dx = 0, dy = 0;
        message.CalcCenteringXY(&dx, &dy);
        for (int i = 0; i < std::clamp(count, 0, int(MES_LINE_MAX)); ++i) {
            // DrawFont offsets every line, placed or flowing, by draw_off.
            const float x = (message.line_pos_on[i] ? message.line_pos[i][0] : message.text_x + dx) + message.draw_off_x;
            const float y = (message.line_pos_on[i] ? message.line_pos[i][1] : message.text_y + dy + message.font_h * i) + message.draw_off_y;
            choices.push_back(i >= message.select_top ? MenuMouseRect{x, y, float(std::max({message.text_w, message.line_w[i], 60})), float(message.font_h)} : MenuMouseRect{});
        }
    }
    return choices;
}

namespace {
// The laid-out characters of one drawn line, first to last.
template <class Each>
void LineGlyphs(const ClsMes &message, int line, Each each) {
    if (message.font_h <= 0 || line < 0 || line >= MES_LINE_MAX || message.line_shade[line] == MES_SHADE_HIDDEN) {
        return;
    }
    for (int i = std::max(0, message.page_top); i < std::min(message.reveal_num, int(MES_WIN_TBL_MAX)); ++i) {
        if (message.tbl[i].y / message.font_h == line) {
            each(message.tbl[i]);
        }
    }
}
} // namespace

int MenuMouseLabelButton(const ClsMes &message, int line) {
    int symbol = -1;
    LineGlyphs(message, line, [&](const MES_WIN_TBL &glyph) {
        if (symbol < 0 && glyph.code >= MES_CODE_GAIJI && glyph.code < MES_CODE_GAIJI + 0x32) {
            symbol = glyph.code - MES_CODE_GAIJI;
        }
    });
    // DrawGaiji_sub shows the confirm and cancel symbols swapped outside Japanese.
    if (LanguageCode != 0 && (symbol == 6 || symbol == 8)) {
        symbol = 14 - symbol;
    }
    constexpr int buttons[] = {PAD_CIRCLE, PAD_TRIANGLE, PAD_CROSS, PAD_SQUARE};
    return symbol >= 6 && symbol <= 9 ? buttons[symbol - 6] : 0;
}

MenuMouseRect MenuMouseLabelRect(const ClsMes &message, int line) {
    int left = INT_MAX, right = INT_MIN;
    if (line >= 0 && line < MES_LINE_MAX && message.line_pos_on[line]) {
        LineGlyphs(message, line, [&](const MES_WIN_TBL &glyph) {
            left = std::min(left, int(glyph.x));
            right = std::max(right, int(glyph.x));
        });
    }
    if (left > right) {
        return {};
    }
    // DrawFont puts a placed line's characters at line_pos plus their own offsets and draw_off.
    const float x = message.line_pos[line][0] + message.draw_off_x + left;
    const float y = message.line_pos[line][1] + message.draw_off_y;
    return {x - 2, y - 6, float(right - left + message.font_w + 4), float(message.font_h + 12)};
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
    if (select < static_cast<int>(choices.size())) {
        MenuMouseNoteChoices(this, mes_no, choices, select, window_mode == MES_WIN_YESNO);
    }
}

PORT_OVERRIDE void _set2DSprite(char *name, mgCDrawPrim *primitive, mgRect<int> destination,
                                mgRect<int> uv, RGBAQ_TYPE *color) {
    if (MesAbsDrawOff != 0) {
        return;
    }
    const bool cursor = std::strcmp(name, "gaiji") == 0 && uv.left == 96 && uv.top == 232 &&
                        uv.right == 40 && uv.bottom == 24;
    gfx::Interp2DScope tag(cursor ? gfx::Interp2D{MenuMouseNextHandKey(), static_cast<uint64_t>(mgPortFrameCount())} : gfx::CurrentInterp2D());
    primitive->Begin(MG_PRIM_SPRITE);
    MySetTex(name, primitive);
    if (cursor && (color->r || color->g || color->b)) {
        MenuMouseNoteHand(mgPortBinding(primitive->texture.tex0_bits, primitive->texture.tex1_bits),
                          {float(uv.left), float(uv.top), float(uv.right), float(uv.bottom)},
                          0, 0, color->a);
    }
    set2DSpriteEasy(primitive, destination, uv, color);
    primitive->End();
}
