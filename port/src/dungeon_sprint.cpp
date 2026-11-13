#include "common.h"

#include "dungeon_sprint.hpp"

#include "actionchara.hpp"
#include "dng_main.hpp"
#include "gamepad.hpp"
#include "mglib.hpp"
#include "platform/config.hpp"
#include "sprint.hpp"
#include "subgame.hpp"

namespace {

SprintTimer g_r2;
bool        g_sprint = false;
// The character and step DungeonSprintMove last set. Retail sets the walk's step every frame but leaves the
// run's alone, so a step still equal to this one is the scaled run step, not a fresh one.
CActionChara *g_scaled_chara = nullptr;
float         g_scaled_step = 0;

bool Allowed() {
    return ConfigGet().sprint && DngStatus.mode == DNG_STATUS_FIELD && !DngStatus.eye_view && MainChara__2 != nullptr &&
           !GamePad__2.key_lock && !SubGameRunning();
}

} // namespace

int DungeonSprintMainKey(int (*retail)()) {
    const bool allowed = Allowed();
    bool       tap = false;
    g_sprint = g_r2.Step(allowed, GamePad__2.Down(PAD_R2) != 0, GamePad__2.On(PAD_R2) != 0,
                         GamePad__2.Up(PAD_R2) != 0, mgGetNowFrameRate(), tap);
    if (!allowed) {
        return retail();
    }
    // Retail enters the first-person view on R2's press edge: hide the edge, or make one for a tap.
    PAD_STATUS &now = GamePad__2.pad[0];
    PAD_STATUS &before = GamePad__2.previous_pad[0];
    const int   now_buttons = now.button;
    const int   before_buttons = before.button;
    if (tap) {
        now.button |= PAD_R2;
        before.button &= ~PAD_R2;
    } else {
        before.button |= PAD_R2;
    }
    const int result = retail();
    now.button = now_buttons;
    before.button = before_buttons;
    return result;
}

void DungeonSprintMove(CActionChara *chara) {
    float step = chara->GetStep();
    if (chara == g_scaled_chara && step == g_scaled_step) {
        step /= kSprintStep;
    }
    g_scaled_chara = nullptr;
    const bool moving = chara->velocity[0] != 0.0f || chara->velocity[2] != 0.0f;
    if (g_sprint && GamePad__2.On(PAD_R2) && moving && chara->lock_on == 0) {
        chara->velocity[0] *= kSprintSpeed;
        chara->velocity[2] *= kSprintSpeed;
        step *= kSprintStep;
        g_scaled_chara = chara;
        g_scaled_step = step;
    }
    if (step != chara->GetStep()) {
        chara->SetStep(step);
    }
}
