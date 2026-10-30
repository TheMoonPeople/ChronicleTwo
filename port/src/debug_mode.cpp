#include "debug_mode.hpp"

#include "dng_debug.hpp"
#include "dng_main.hpp"
#include "editdebug.hpp"
#include "editloop.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "object/world/town_control.hpp"
#include "options/screen.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/input.hpp"
#include "scenesnd.hpp"
#include "sphida.hpp"
#include "subgame.hpp"
#include "title.hpp"

namespace {

// The frame the last ordinary tick ended on, or -1 after a wait.
int menu_key_frame = -1;

/**
 * Reports whether dungeon gameplay can receive a debug-menu shortcut.
 */
bool DungeonDebugKeyControl() {
    const CSphida *sphida = GetSphidaPtr();
    return PortDungeonFieldControl() && !(BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_CONTROL) &&
           !SubGameRunning() && !(sphida && sphida->play_flag);
}

} // namespace

void DebugModeBoot(bool debug_mode) {
    if (!debug_mode) {
        return;
    }
    MasterDebugCode = MASTER_DEBUG_CODE;
    // title.cpp only reads the save's debug code while this is 0, so setting it here stands in for the developer save.
    MasterDebugModeOn = 1;
}

int DebugModeMenuButtons(int loop) {
    // A locked pad reads no buttons, and the injected press would linger in its history.
    if (GamePad__2.key_lock) {
        return 0;
    }
    switch (loop) {
        case LOOP_TITLE:
            return PAD_START | PAD_SELECT;
        case LOOP_DUNGEON:
            // The open debug menu accepts a second R3 while its player and field steps are paused.
            return DungeonDebugKeyControl() || (DngStatus.mode == DNG_STATUS_FIELD && dngGetDebugInfo()->active)
                       ? PAD_R3
                       : 0;
        case LOOP_EDIT:
            // The open debug menu retains control until a second R3 closes it.
            return PortTownFieldControl() || (EditDebugMode() && PortTownControlMode == EDIT_CONTROL_DEBUG) ? PAD_R3 : 0;
        default:
            return 0;
    }
}

bool DebugModeMenuKey(int loop) {
    const int buttons = DebugModeMenuButtons(loop);
    if (buttons == 0) {
        return false;
    }
    DebugFlag = 1;
    GamePad__2.pad[0].button |= buttons;
    GamePad__2.previous_pad[0].button &= ~buttons;
    return true;
}

bool DebugModeTakeMenuKey(int frame) {
    bool pressed = false;
    while (InputHostPressed(InputHostAction::ModeDebugMenu)) {
        pressed = true;
    }
    return pressed && !options::Capturing() && menu_key_frame >= 0 && frame == menu_key_frame;
}

void DebugModeEndMenuKeyTick(int begin_frame, int end_frame) {
    menu_key_frame = end_frame == begin_frame + 1 ? end_frame : -1;
}

void DebugModeDiscardMenuKey() {
    while (InputHostPressed(InputHostAction::ModeDebugMenu)) {
    }
    menu_key_frame = -1;
}

bool DebugModeToggleChord(int pad1_held, int pad1_pressed) {
    constexpr int kShoulders = PAD_L1 | PAD_R1 | PAD_L2 | PAD_R2;
    return MasterDebugCode == MASTER_DEBUG_CODE && (pad1_held & kShoulders) == kShoulders && (pad1_pressed & PAD_R3) != 0;
}
