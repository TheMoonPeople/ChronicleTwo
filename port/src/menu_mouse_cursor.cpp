#include "common.h"

#include <algorithm>

#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menucommon.hpp"
#include "menusys.hpp"
#include "render/renderer.hpp"
#include "snd_mngr.hpp"

namespace {
int *pending_cursor = nullptr;
int  pending_selection = 0, pending_frame = -1;
int  sound_frame = -1, sounds = 0;
} // namespace

void MenuMouseCursorSound() {
    if (sound_frame == mgPortFrameCount()) {
        return;
    }
    sound_frame = mgPortFrameCount();
    ++sounds;
    MenuSePlay(SYSTEM_SE_CURSOR);
}

int MenuMouseCursorSounds() { return sounds; }

void MenuMouseMove(int *cursor, int selected) {
    pending_cursor = cursor;
    pending_selection = selected;
    pending_frame = mgPortFrameCount();
}

int MenuKeySelectCheck(int step, int *cursor, int *scroll, int min, int max, int visible, int limit_mode) {
    const int before = *cursor;
    if (cursor == pending_cursor && pending_frame == mgPortFrameCount()) {
        step = pending_selection - before;
        pending_cursor = nullptr;
    }
    *cursor += step;
    int result = MENU_CURSOR_UNCHANGED;
    switch (limit_mode) {
        case MENU_CURSOR_LIMIT_CLAMP:
            *cursor = std::max(*cursor, min);
            if (*cursor >= max) {
                *cursor = max - 1;
            }
            if (*cursor != before) {
                result = MENU_CURSOR_MOVED;
            }
            break;
        case MENU_CURSOR_LIMIT_WRAP:
            if (*cursor < min) {
                *cursor = max - 1;
            }
            if (*cursor >= max) {
                *cursor = min;
            }
            if (*cursor != before) {
                result = MENU_CURSOR_MOVED;
            }
            break;
        case MENU_CURSOR_LIMIT_EXIT:
            if (*cursor != before) {
                result = MENU_CURSOR_MOVED;
            }
            if (*cursor < min) {
                *cursor = min;
                result = MENU_CURSOR_EXIT;
            }
            if (*cursor >= max) {
                *cursor = max - 1;
                result = MENU_CURSOR_EXIT;
            }
            break;
        case MENU_CURSOR_LIMIT_REJECT:
            if (*cursor != before) {
                result = MENU_CURSOR_MOVED;
            }
            if (*cursor < min || *cursor >= max) {
                *cursor = before;
                result = MENU_CURSOR_BLOCKED;
            }
            break;
    }
    if (scroll) {
        *scroll = std::min(*cursor, *scroll);
        while (*scroll + visible <= *cursor) {
            ++*scroll;
        }
    }
    return result;
}
