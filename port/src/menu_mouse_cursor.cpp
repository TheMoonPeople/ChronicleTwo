#include "common.h"

#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menucommon.hpp"
#include "menusys.hpp"
#include "mglib_port.hpp"
#include "snd_mngr.hpp"

namespace {
int *pending_cursor = nullptr;
int  pending_selection = 0, pending_frame = -1;
int  sound_frame = -1, sounds = 0, all_sounds = 0;
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

// Retail's body; it counts every menu cursor sound, retail or mouse, for tests.
PORT_OVERRIDE void MenuSePlay(int sound_no) {
    if (sound_no == SYSTEM_SE_CURSOR) {
        ++all_sounds;
    }
    if (sound_no >= 0) {
        MenuSePlay(SystemSND_ID, sound_no);
    }
}

int MenuCursorSounds() { return all_sounds; }

void MenuMouseMove(int *cursor, int selected) {
    pending_cursor = cursor;
    pending_selection = selected;
    pending_frame = mgPortFrameCount();
}

PORT_OVERRIDE int MenuKeySelectCheck(int step, int *cursor, int *scroll, int min, int max, int visible, int limit_mode) {
    const int before = *cursor;
    if (cursor == pending_cursor && pending_frame == mgPortFrameCount()) {
        step = pending_selection - before;
        pending_cursor = nullptr;
    }
    *cursor += step;
    int result = MENU_CURSOR_UNCHANGED;
    switch (limit_mode) {
        case MENU_CURSOR_LIMIT_CLAMP:
            if (*cursor < min) {
                *cursor = min;
            }
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
        if (*cursor < *scroll) {
            *scroll = *cursor;
        }
        while (*scroll + visible <= *cursor) {
            ++*scroll;
        }
    }
    return result;
}
