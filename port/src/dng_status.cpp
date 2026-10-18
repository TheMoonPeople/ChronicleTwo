#include "common.h"

#include <cmath>

#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "gfx/gfx.hpp"
#include "mglib_port.hpp"
#include "quick_loadout.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

PORT_OVERRIDE void DrawStatusBord() {
    // Draws a slot's new picture, if one is due, before the board's anchor applies to anything.
    PortQuickLoadoutPrepare();
    gfx::UiAnchorScope anchor(gfx::UiAnchor::Side(-1, -1, true));

    float rate = NAN;
    int   chara = 0;

    chara = DngUserData->active_chr_no;
    rate = BattleAreaScene->statusbar_rate;
    WarningGage2.warning[0] = false;
    WarningGage2.warning[1] = false;
    WarningGage2.warning[2] = false;
    LockOnModel.pos[3] = 0.0f;

    // Retail keeps TEX0 in the GS across Initialize; the second weapon's synth gauge relies on it.
    mgPortGs().inherit_prim_texture = true;

    switch (chara) {
        case USER_CHARA_MAX:
        case USER_CHARA_MONICA: {
            // Retail batches each human panel separately: HP/items are left of the midpoint;
            // both weapon panels and the magic-sword charges are right of it. Move each draw whole.
            gfx::UiAnchorScope panels({.left_until = 256.0f, .right_from = 256.0f, .top_until = INFINITY, .bottom_from = -INFINITY, .scissor = true});
            DrawMainUnitStatusBord(rate);
            break;
        }
        case USER_CHARA_ROBO:
            DrawRoboUnitStatusBord(rate);
            break;
        case USER_CHARA_MONSTER:
            DrawMonsterUnitStatusBord(rate);
            break;
    }

    mgPortGs().inherit_prim_texture = false;
    PortQuickLoadoutDraw(rate);
}
