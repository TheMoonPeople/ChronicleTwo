#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "dng_debug.hpp"
#include "dng_effect.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
#include "dng_status.hpp"
#include "editevent.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapload.hpp"
#include "menucommon.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "prespr.hpp"
#include "quest.hpp"
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "userdata.hpp"
#include "water.hpp"

static int gekirin_anim[16] = {0, 3, 6, 5, 4, 3, 2, 1, 3, 4, 3, 2, 1, 2, 1, 0};

void CLevelupInfo::SetLevelUpInfo(int screen_x, int screen_y, int source, int value) {
    unk_00 = 0;
    unk_04 = 0;
    unk_08 = 0;
    unk_0c = 0;
    unk_10 = 0;
    unk_14 = 0;
    unk_18 = 0;
    unk_1c = 0;
    progress = 0.0f;
    phase = LEVELUP_INFO_PHASE_APPEAR;
    x = screen_x - 0x23;
    y = screen_y - 6;
    weapon_slot = source;
    unk_34 = value;
}

void CLevelupInfo::Draw() {
    int i = {};

    if (phase != LEVELUP_INFO_PHASE_NONE) {

        CPreSprite sprite;
        sprite.Initialize(nullptr, nullptr);
        sprite.Preset2D();
        sprite.Begin(MG_PRIM_SPRITE);
        sprite.Texture(TEX_SystenFrame);

        switch (phase) {
            case LEVELUP_INFO_PHASE_APPEAR: {
                int rise = fptosi(32.0f * sinf((PI + HALF_PI) * progress - HALF_PI));
                sprite.Color(0x80, 0x80, 0x80, fptosi(128.0f * progress));
                sprite.SetIRect(x, y - rise, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - rise - 3, 0x10, 0x10, 0x30, 0x40);
                break;
            }
            case LEVELUP_INFO_PHASE_FLASH: {
                float pulse = {};
                sprite.Color(0x80, 0x80, 0x80, 0x80);
                sprite.SetIRect(x, y, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - 3, 0x10, 0x10, 0x30, 0x40);
                pulse = sinf(PI * progress);
                sprite.SetAlphaBlend(MG_ALPHA_BLEND_ADD);
                sprite.Color(0x80, 0x80, 0x80, fptosi(32.0f * pulse));

                for (i = 0; i < 4; i++) {
                    sprite.SetIStretch(x - i, y - i, i * 2 + 70, i * 2 + 12, 0,
                                       0xA2, 70, 12);
                    sprite.SetIStretch(x - i - 0x10, y - i - 3, i * 2 + 0x10, i * 2 + 0x10, 0x30,
                                       0x40, 0x10, 0x10);
                }

                break;
            }
            case LEVELUP_INFO_PHASE_HOLD:
                sprite.Color(0x80, 0x80, 0x80, 0x80);
                sprite.SetIRect(x, y, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - 3, 0x10, 0x10, 0x30, 0x40);
                break;
            case LEVELUP_INFO_PHASE_FADE:

                sinf((PI + HALF_PI) * progress - HALF_PI);
                sprite.Color(0x80, 0x80, 0x80, 0x80 - fptosi(128.0f * progress));
                sprite.SetIRect(x, y, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - 3, 0x10, 0x10, 0x30, 0x40);
                break;
        }

        sprite.End();
    }
}

void CLevelupInfo::Step() {
    if (phase != LEVELUP_INFO_PHASE_NONE) {
        switch (phase) {
            case LEVELUP_INFO_PHASE_APPEAR:
            case LEVELUP_INFO_PHASE_FLASH:
            case LEVELUP_INFO_PHASE_HOLD:
                if (progress < 0.9f) {
                    progress += 0.1f;
                } else {
                    progress = 0.0f;
                    phase += 1;
                }

                break;
            case LEVELUP_INFO_PHASE_FADE:
                if (progress < 0.9f) {
                    progress += 0.1f;
                } else {
                    phase = LEVELUP_INFO_PHASE_NONE;
                }

                break;
        }
    }
}

void CPiyori::Initialize() {
    target = nullptr;
}

void CPiyori::Reset() {
    target = nullptr;
    time = 0;
}

void CPiyori::Set(mgCObject *object, float height, float radius, s16 life) {
    int i = {};

    if (object != nullptr) {
        target = static_cast<CCharacter2 *>(object);
        this->height = height;
        this->radius = radius;
        this->time = life;
        circle_angle = 0.0f;

        for (i = 0; i < 3; i++) {
            star_angle[i] = fRand(TWO_PI) - PI;
        }

        se_wait = 0;
    }
}

void CPiyori::Set(mgCObject *target, s16 time) {
    if (target != nullptr) {
        CCharacter2 *character = static_cast<CCharacter2 *>(target);
        this->Set(target, 2.0f * character->body_height, 2.0f * character->body_width, time);
    }
}

void CPiyori::Draw() {
    float char_pos[4];

    struct {
        float v[3];
        int   w;
    } pos{};

    int   i = {};
    int   alpha = {};
    int   draw_time = {};
    float draw_angle = {};
    float draw_radius = {};

    if (this->target != nullptr) {
        this->target->GetPosition(char_pos);
        alpha = 0x80;
        char_pos[1] += this->height;
        draw_time = this->time;
        draw_radius = this->radius;
        draw_angle = this->circle_angle;

        if (draw_time < 16) {
            alpha = draw_time * 8;

            draw_radius = this->radius / 24.0 * draw_time;
        }

        CPreSprite prim;
        int        quad_a[4];
        int        quad_b[4];
        prim.Initialize(nullptr, nullptr);
        prim.Preset2D();
        prim.Coord(1);
        prim.DepthTestEnable(1);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.Bilinear(1);
        prim.TextureMapEnable(1);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0x80, 0x80, 0x80, alpha);
        prim.Texture(TEX_SystemEffect1);
        i = 0;
        pos.w = 0x3F800000;

        for (i = 0; i < 3; i++) {
            pos.v[0] = char_pos[0] + draw_radius * cosf(draw_angle);
            pos.v[1] = char_pos[1] + sinf(this->star_angle[i]);
            pos.v[2] = char_pos[2] + draw_radius * sinf(draw_angle);

            if (mgTransWorldPrim3DSprite(quad_a, quad_b, pos.v, 4.0f, 4.0f, 0) != 0) {
                prim.TextureCrd(0xC1, 0x61);
                prim.Vertex4(quad_a);
                prim.TextureCrd(0xDF, 0x7F);
                prim.Vertex4(quad_b);
            }

            draw_angle += TWO_PI / 3.0f;
        }

        prim.End();
    }
}

void CPiyori::Step() {
    float pos[4];
    float vol = {};
    float pan = {};
    int   i = {};

    if (target != nullptr) {
        time -= 1;

        if (time <= 0) {
            target = nullptr;
            return;
        }

        se_wait -= 1;

        if (se_wait <= 0) {
            target->GetEntryObjectPos(0, pos);
            sndGetVolPan(&vol, &pan, pos, 160.0f, 1200.0f);
            sndSePlayVPf(GetMainScene()->se_battle_id, 0x24, vol, pan, 0);
            se_wait = 13;
        }

        {
            float a = circle_angle;
            a += 6.0f * DEG_TO_RAD;
            circle_angle = a;

            if (a > PI) {
                circle_angle = a - TWO_PI;
            }
        }

        for (i = 0; i < 3; i++) {
            float a = star_angle[i];
            a += 12.0f * DEG_TO_RAD;
            star_angle[i] = a;

            if (a > PI) {
                star_angle[i] = a - TWO_PI;
            }
        }
    }
}

void CGiftMark::Set(CCharacter2 *character, float character_scale) {
    Initialize();
    chara = character;
    height = character_scale;
    active = true;
}

void CGiftMark::Draw() {
    struct {
        float v[3];
        int   w;
    } pos{};

    int i = {};

    if (active != 0) {
        if (chara != nullptr) {
            chara->GetEntryObjectPos(0, pos.v);
            pos.v[1] += 10.0f + 2.0f * height;
            pos.v[1] += 5.0f * sinf(angle);

            CPreSprite prim;
            int        quad_a[4];
            int        quad_b[4];
            prim.Initialize(nullptr, nullptr);
            prim.Preset2D();
            prim.Coord(1);
            prim.DepthTestEnable(1);
            prim.ZMask(MG_Z_MASK_MASKED);
            prim.Bilinear(1);
            prim.TextureMapEnable(1);
            prim.Begin(MG_PRIM_SPRITE);
            prim.Color(0x80, 0x80, 0x80, 0x80);
            prim.Texture(TEX_SystemEffect1);
            i = 0;
            pos.w = 0x3F800000;

            do {
                if (mgTransWorldPrim3DSprite(quad_a, quad_b, pos.v, 8.0f, 8.0f, 0) != 0) {
                    prim.TextureCrd(0xE1, 0x41);
                    prim.Vertex4(quad_a);
                    prim.TextureCrd(0xFC, 0x62);
                    prim.Vertex4(quad_b);
                }

                i += 1;
            } while (i < 3);

            prim.End();
        }
    }
}

void CGiftMark::Step() {
    if (active != 0) {
        angle += 7.5f * DEG_TO_RAD;

        if (angle > PI) {
            angle -= PI;
        }

        time += 1;

        if (time > 240) {
            active = false;
        }
    }
}

void CGiftMark::Initialize() {
    chara = nullptr;
    active = false;
    angle = 0.0f;
    time = 0;
}

void CEnemyGekirin::Draw(CPreSprite *sprite, int x, int y) {
    if (state != GEKIRIN_STATE_NONE) {
        sprite->SetAlphaBlend(0);
        sprite->Color(0x80, 0x80, 0x80, 0x80);
        sprite->SetIRect(x, y - gekirin_anim[frame] * 4, 8, 8, 0x78, 0xCA);

        if (state == GEKIRIN_STATE_BREAK) {
            sprite->SetAlphaBlend(MG_ALPHA_BLEND_ADD);
            sprite->Color(0x80, 0x80, 0x80, 0x40);
            sprite->SetIStretch(x - 4, y - gekirin_anim[frame] * 4 - 4, 0x10, 0x10, 0x78, 0xCA, 8,
                                8);
        }
    }
}

void CEnemyGekirin::Step() {
    if (state == GEKIRIN_STATE_BREAK) {
        frame += 1;

        if (gekirin_anim[frame] == 0) {
            state = GEKIRIN_STATE_NONE;
        }
    }
}

void CEnemyLifeGage::Set(float *position, int new_max_life, int new_life, int gekirin_count, int new_screen) {
    int i = {};

    sceVu0CopyVector(pos, position);
    max_hp = new_max_life;
    hp = new_life;
    screen = new_screen;

    for (i = 0; i < ENEMY_LIFE_GAGE_GEKIRIN_MAX; i++) {
        if (i > gekirin_count - 1 && gekirin[i].state == GEKIRIN_STATE_SHOW) {
            gekirin[i].frame = 0;
            gekirin[i].state = GEKIRIN_STATE_BREAK;
        }
    }
}

void CEnemyLifeGage::Step() {
    int i = {};

    if (screen != 0) {
        scale = 1.0f;
        return;
    }

    if (view != 0) {
        if (scale < 1.0f) {
            scale += 0.005f + scale / 3.0f;
        }

        if (!(scale < 1.0f)) {
            scale = 1.0f;
        }
    } else {
        if (scale > 0.0f) {
            scale -= 0.01f + scale / 2.0f;
        }

        if (scale <= 0.1f) {
            scale = 0.0f;
        }
    }

    for (i = 0; i < ENEMY_LIFE_GAGE_GEKIRIN_MAX; i++) {
        gekirin[i].Step();
    }
}

void CDamageScore::SetColor(s16 red, s16 green, s16 blue) {
    color[0] = red;
    color[1] = green;
    color[2] = blue;
}

void CDamageScore::Step() {
    if (active != 0) {
        if (sprite != 0) {
            if (phase == DAMAGE_SCORE_PHASE_APPEAR) {
                bounce[0] = bounce[0] - (PI / 8.0f);

                if (bounce[0] < -PI) {
                    bounce[0] = -PI;
                    phase = DAMAGE_SCORE_PHASE_FADE;
                }

                if (alpha < 0x80) {
                    alpha = alpha + 0xC;
                }
            }

            if (phase == DAMAGE_SCORE_PHASE_FADE) {
                alpha -= 4;

                if (alpha < 0) {
                    active = false;
                }
            }
        }

        if (sprite == 0) {
            if (phase == DAMAGE_SCORE_PHASE_APPEAR) {
                for (int i = 0; i < length; i++) {
                    bounce[i] = bounce[i] - (PI / (10.0f + (2.0f * static_cast<float>(i))));

                    if (bounce[i] < -PI) {
                        bounce[i] = -PI;

                        if (i == length - 1) {
                            phase = DAMAGE_SCORE_PHASE_FADE;
                        }
                    }
                }

                if (alpha < 0x80) {
                    alpha = alpha + 6;
                }
            }

            if (phase == DAMAGE_SCORE_PHASE_FADE) {
                alpha -= 6;

                if (alpha < 0) {
                    active = false;
                }
            }
        }
    }
}

void CDamageScore2::Step() {
    if (phase != DAMAGE_SCORE2_PHASE_NONE) {
        if (phase == DAMAGE_SCORE2_PHASE_JUMP) {
            progress += 0.1f;
            alpha += 0.1f;
            offset_y = static_cast<int>(64.0f * sinf(-(PI - QUARTER_PI) * progress));

            if (progress > 1.0f) {
                phase = DAMAGE_SCORE2_PHASE_HOLD;
                progress = 0.0f;
                alpha = 1.0f;
            }
        }

        if (phase == DAMAGE_SCORE2_PHASE_HOLD) {
            progress += 0.05f;

            if (progress > 1.0f) {
                phase = DAMAGE_SCORE2_PHASE_FADE;
                progress = 0.0f;
            }
        }

        if (phase == DAMAGE_SCORE2_PHASE_FADE) {
            progress += 0.125f;
            alpha -= 0.125f;
            offset_y += static_cast<int>(8.0f * progress);

            if (progress > 1.0f) {
                phase = DAMAGE_SCORE2_PHASE_NONE;
                alpha = 0.0f;
            }
        }
    }
}

void CLockOnModel::Step() {
    angle += 4.0f * DEG_TO_RAD;

    if (angle > PI) {
        angle -= TWO_PI;
    }
}

void CWarningGage2::Step() {
    time += 1;

    if (time >= 40) {
        time = 0;
    }
}

#include "common.h"

#include <math.h>

#include "actionchara.hpp"
#include "character.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "gfx/gfx.hpp"
#include "maintex.hpp"
#include "mg_drawprim.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "object/dun/target_presentation.hpp"
#include "prespr.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

void CWarningGage2::Draw() {
    if (time < 20 || layout == WARNING_GAGE_LAYOUT_NONE) {
        return;
    }

    struct WarningIcon {
        int x, y, width, height, u, v;
    };

    constexpr WarningIcon human_label[] = {
        {.x = 183, .y = 41, .width = 68, .height = 20, .u = 316, .v = 236},
        {.x = 274, .y = 64, .width = 68, .height = 20, .u = 316, .v = 236},
        {.x = 411, .y = 73, .width = 68, .height = 20, .u = 316, .v = 236}
    };
    constexpr WarningIcon human_icon[] = {
        {.x = 170, .y = 16, .width = 28, .height = 36, .u = 210, .v = 226},
        {.x = 302, .y = 15, .width = 26, .height = 54, .u = 290, .v = 202},
        {.x = 439, .y = 56, .width = 26, .height = 22, .u = 238, .v = 234}
    };
    constexpr WarningIcon robot_label[] = {
        {.x = 146, .y = 38, .width = 68, .height = 20, .u = 316, .v = 236},
        {.x = 320, .y = 33, .width = 68, .height = 20, .u = 316, .v = 236}
    };
    constexpr WarningIcon robot_icon[] = {
        {.x = 133, .y = 13, .width = 28, .height = 36, .u = 210, .v = 226},
        {.x = 348, .y = 16, .width = 26, .height = 22, .u = 238, .v = 234}
    };
    const bool human = layout == WARNING_GAGE_LAYOUT_MAIN;
    if (!human && layout != WARNING_GAGE_LAYOUT_ROBO) {
        return;
    }
    for (int i = 0; i < (human ? 3 : 2); ++i) {
        if (!warning[i] || (!human && i == 0 && rate[i] == 0.0f)) {
            continue;
        }
        auto label = human ? human_label[i] : robot_label[i];
        auto icon = human ? human_icon[i] : robot_icon[i];
        if (i != 0 && rate[i] == 0.0f) {
            label.v = 216;
            icon.u = human && i == 1 ? 264 : 238;
            icon.v = human && i == 1 ? 202 : 212;
        }
        // Warnings are emitted after DrawStatusBord, so they need the same panel's anchor here.
        gfx::UiAnchorScope anchor(human ? gfx::UiAnchor::Side(i == 0 ? -1 : 1, -1, true) : gfx::UiAnchor::Side(-1, -1, true));
        CPreSprite         sprite;
        sprite.Initialize(nullptr, nullptr);
        sprite.Preset2D();
        sprite.Begin(MG_PRIM_SPRITE);
        sprite.Texture(TEX_SystenFrame);
        sprite.Color(0x80, 0x80, 0x80, 0x80);
        sprite.SetIRect(label.x, label.y, label.width, label.height, label.u, label.v);
        sprite.SetIRect(icon.x, icon.y, icon.width, icon.height, icon.u, icon.v);
        sprite.End();
    }
}

// Retail's definition returns void against the fixed-up declaration (scripts/port/header_fixups.py).
int CLockOnModel::Draw() {
    float target_pos[4];
    int   top_left[4];
    int   bottom_right[4];

    auto *player = static_cast<CActionChara *>(scene->GetCharacter(0));

    if (player == nullptr) {
        mgPortHideTarget(this);
        return 0;
    }

    name = nullptr;

    if (player->target_no == -1) {
        mgPortHideTarget(this);
        return 0;
    }

    auto *target = static_cast<CActiveMonster *>(scene->GetCharacter(player->target_no));

    if (target == nullptr) {
        mgPortHideTarget(this);
        return 0;
    }

    float size = NAN;
    float height = target->body_height;

    if (!(target->target_dist <= target->clip_dist)) {
        mgPortHideTarget(this);
        return 0;
    }

    if (target->alpha <= 0.0f) {
        mgPortHideTarget(this);
        return 0;
    }

    CHARA_ENTRY_OBJECT *entry = target->GetEntryObjectPos(CHARA_ENTRY_GROUP_TARGET, 0, target_pos);

    if (entry == nullptr) {
        mgPortHideTarget(this);
        return 0;
    }

    size = entry->size;
    sceVu0CopyVector(pos, target_pos);

    if (!(height <= 85.0f)) {
        height = 85.0f;
    }

    pos[1] += height;
    name = target->tbl->name;
    int monster_id = -1;

    if (DngUserData->active_chr_no == USER_CHARA_MONSTER) {
        monster_id = DngUserData->monster_id;
    }

    if (target->monster_id == monster_id) {
        int message = target->message_no;

        if (message >= 0) {
            message += 5000;
        }

        message_no = message;
    } else {
        message_no = -1;
    }

    mgPortTrackTarget(this, target, player->target_no, player->lock_on != 0);
    if (player->lock_on == 0) {
        target_pos[1] += 5.0f + 10.0f * size;
        SetRotation(0.0f, angle, 0.0f);
        SetPosition(target_pos);
        CObjectFrame::DrawDirect();
        return 0;
    }

    gfx::Interp2DScope interpolation(mgPortTargetBrackets(this));
    CPreSprite         prim;
    prim.Initialize(nullptr, nullptr);
    prim.Preset2D();
    prim.Coord(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(TEX_SystenFrame);
    prim.Color(0x80, 0x80, 0x80, 0x80);

    if (mgTransWorldPrim3DSprite(top_left, bottom_right, target_pos, 20.0f * size, 20.0f * size, 0) != 0) {
        bottom_right[0] -= 0x120;
        bottom_right[1] -= 0x120;
        prim.TextureCrd(0xC0, 0x16);
        prim.Vertex4(top_left[0], top_left[1], 0);
        prim.TextureCrd(0xD2, 0x28);
        prim.Vertex4(top_left[0] + 0x120, top_left[1] + 0x120, 0);
        prim.TextureCrd(0xD2, 0x16);
        prim.Vertex4(bottom_right[0], top_left[1], 0);
        prim.TextureCrd(0xE4, 0x28);
        prim.Vertex4(bottom_right[0] + 0x120, top_left[1] + 0x120, 0);
        prim.TextureCrd(0xC0, 0x26);
        prim.Vertex4(top_left[0], bottom_right[1], 0);
        prim.TextureCrd(0xD2, 0x3A);
        prim.Vertex4(top_left[0] + 0x120, bottom_right[1] + 0x120, 0);
        prim.TextureCrd(0xD2, 0x28);
        prim.Vertex4(bottom_right[0], bottom_right[1], 0);
        prim.TextureCrd(0xE4, 0x3A);
        prim.Vertex4(bottom_right[0] + 0x120, bottom_right[1] + 0x120, 0);
    }

    prim.End();

    return 0;
}
